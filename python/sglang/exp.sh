traverse_list=(1000 1500 2000 2500 3000 3500 4000 4500 5000)
port_list=(10000)

for port in "${port_list[@]}"
do 
    # 根据port值设置对应的policy
    if [ "$port" -eq 5000 ]; then
        policy="random"
    elif [ "$port" -eq 8000 ]; then
        policy="reverse_length"
    elif [ "$port" -eq 11000 ]; then
        policy="length"
    else
        policy="unknown"
    fi

    for num_prompts in "${traverse_list[@]}"
    do
        # 构造日志文件名
        file_name="sglang_by_len_new_order_decode_${num_prompts}_${policy}.log"
        
        echo "num_prompts: $num_prompts" | tee "$file_name"
        
        # 将标准输出和标准错误同时重定向到文件和命令行
        python3 /home/ubuntu/my_sglang_dev/sglang/python/sglang/bench_serving_new_order.py \
            --backend sglang \
            --dataset-name random \
            --num-prompts "$num_prompts" \
            --port "$port" \
            --decode-reorder 2>&1 | tee -a "$file_name"
    done
done
