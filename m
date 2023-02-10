Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD76169233F
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 17:27:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbjBJQ1Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 11:27:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbjBJQ1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 11:27:23 -0500
Received: from smtpout.efficios.com (smtpout.efficios.com [167.114.26.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA65870710;
        Fri, 10 Feb 2023 08:27:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=efficios.com;
        s=smtpout1; t=1676046438;
        bh=5r+k7RW0v5BJOw1L84xs5DpMpFaDIdBb4yzzggUHu9M=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=dItlT652fP4XJS7n37sGJEZIXIRGaqo8Dh0RUJt19GVrYMbBwQPMyq1NbsPiZKNlo
         0FcfuuSvhbMi6gKB7WqX1pSVgX6PNIK7JS9zaXGc8TxNSaJpJIoK2tIzTmEhcq9y7E
         Mfj+Z1i27+jmeQ9IokuyFB+Z0vbvD7VVVDZvus3ksV6PWVakEuqrmRmZkXh3RZfwlQ
         vZavH6GnqmT5d5nsA4Ji1v8KVsFqofoYqPgN/BrpqwFxkwlx2RaNLgG/W+GRWjPHxt
         +LjVgZlb/NDTCCzaadZlIysbYhPZ7eGdxmqhTUZ5VuW5r7p5xC1jzacugnhig9ratQ
         4LnnDYsCLPxEA==
Received: from [10.1.0.205] (192-222-188-97.qc.cable.ebox.net [192.222.188.97])
        by smtpout.efficios.com (Postfix) with ESMTPSA id 4PCzfG3STFzkrS;
        Fri, 10 Feb 2023 11:27:18 -0500 (EST)
Message-ID: <32e0332a-4ef4-bfe3-129e-50afa989a151@efficios.com>
Date:   Fri, 10 Feb 2023 11:27:18 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH -trace] trace: fix TASK_COMM_LEN in trace event format
 file
Content-Language: en-US
To:     Yafang Shao <laoar.shao@gmail.com>, rostedt@goodmis.org,
        mhiramat@kernel.org
Cc:     linux-trace-kernel@vger.kernel.org,
        John Stultz <jstultz@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        stable@vger.kernel.org
References: <20230210155921.4610-1-laoar.shao@gmail.com>
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
In-Reply-To: <20230210155921.4610-1-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-02-10 10:59, Yafang Shao wrote:
> After commit 3087c61ed2c4 ("tools/testing/selftests/bpf: replace open-coded 16 with TASK_COMM_LEN"),
> the content of the format file under
> /sys/kernel/debug/tracing/events/task/task_newtask was changed from
>    field:char comm[16];    offset:12;    size:16;    signed:0;
> to
>    field:char comm[TASK_COMM_LEN];    offset:12;    size:16;    signed:0;
> 
> John reported that this change breaks older versions of perfetto.
> Then Mathieu pointed out that this behavioral change was caused by the
> use of __stringify(_len), which happens to work on macros, but not on enum
> labels. And he also gave the suggestion on how to fix it:
>    :One possible solution to make this more robust would be to extend
>    :struct trace_event_fields with one more field that indicates the length
>    :of an array as an actual integer, without storing it in its stringified
>    :form in the type, and do the formatting in f_show where it belongs.
> 
> The result as follows after this change,
> $ cat /sys/kernel/debug/tracing/events/task/task_newtask/format
>          field:char comm[16];    offset:12;      size:16;        signed:0;
> 
> Fixes: 3087c61ed2c4 ("tools/testing/selftests/bpf: replace open-coded 16 with TASK_COMM_LEN")
> Reported-by: John Stultz <jstultz@google.com>
> Debugged-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Kajetan Puchalski <kajetan.puchalski@arm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: John Stultz <jstultz@google.com>
> Cc: stable@vger.kernel.org # v5.17+
> ---
>   include/linux/trace_events.h               |  1 +
>   include/trace/stages/stage4_event_fields.h |  3 ++-
>   kernel/trace/trace.h                       |  1 +
>   kernel/trace/trace_events.c                | 24 ++++++++++++++++--------
>   4 files changed, 20 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
> index 4342e99..0e37322 100644
> --- a/include/linux/trace_events.h
> +++ b/include/linux/trace_events.h
> @@ -270,6 +270,7 @@ struct trace_event_fields {
>   			const int  align;
>   			const int  is_signed;
>   			const int  filter_type;
> +			const int  len;
>   		};
>   		int (*define_fields)(struct trace_event_call *);
>   	};
> diff --git a/include/trace/stages/stage4_event_fields.h b/include/trace/stages/stage4_event_fields.h
> index affd541..306f39a 100644
> --- a/include/trace/stages/stage4_event_fields.h
> +++ b/include/trace/stages/stage4_event_fields.h
> @@ -26,7 +26,8 @@
>   #define __array(_type, _item, _len) {					\
>   	.type = #_type"["__stringify(_len)"]", .name = #_item,		\

Just out of curiosity, is the content of __stringify(_len) ever used 
after this patch ? Perhaps we could remove it and just leave:

.type = #_type"[]"

considering that f_show appears to use the opening square bracket to 
detect arrays. This would remove a few useless bytes of data.

Thanks,

Mathieu


>   	.size = sizeof(_type[_len]), .align = ALIGN_STRUCTFIELD(_type),	\
> -	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER },
> +	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER, \
> +	.len = _len},
>   
>   #undef __dynamic_array
>   #define __dynamic_array(_type, _item, _len) {				\
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index e46a492..19caf15 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -1282,6 +1282,7 @@ struct ftrace_event_field {
>   	int			offset;
>   	int			size;
>   	int			is_signed;
> +	int			len;
>   };
>   
>   struct prog_entry;
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 33e0b4f..70f6725 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -114,7 +114,7 @@ struct ftrace_event_field *
>   
>   static int __trace_define_field(struct list_head *head, const char *type,
>   				const char *name, int offset, int size,
> -				int is_signed, int filter_type)
> +				int is_signed, int filter_type, int len)
>   {
>   	struct ftrace_event_field *field;
>   
> @@ -133,6 +133,7 @@ static int __trace_define_field(struct list_head *head, const char *type,
>   	field->offset = offset;
>   	field->size = size;
>   	field->is_signed = is_signed;
> +	field->len = len;
>   
>   	list_add(&field->link, head);
>   
> @@ -150,14 +151,14 @@ int trace_define_field(struct trace_event_call *call, const char *type,
>   
>   	head = trace_get_fields(call);
>   	return __trace_define_field(head, type, name, offset, size,
> -				    is_signed, filter_type);
> +				    is_signed, filter_type, 0);
>   }
>   EXPORT_SYMBOL_GPL(trace_define_field);
>   
>   #define __generic_field(type, item, filter_type)			\
>   	ret = __trace_define_field(&ftrace_generic_fields, #type,	\
>   				   #item, 0, 0, is_signed_type(type),	\
> -				   filter_type);			\
> +				   filter_type, 0);			\
>   	if (ret)							\
>   		return ret;
>   
> @@ -166,7 +167,7 @@ int trace_define_field(struct trace_event_call *call, const char *type,
>   				   "common_" #item,			\
>   				   offsetof(typeof(ent), item),		\
>   				   sizeof(ent.item),			\
> -				   is_signed_type(type), FILTER_OTHER);	\
> +				   is_signed_type(type), FILTER_OTHER, 0);	\
>   	if (ret)							\
>   		return ret;
>   
> @@ -1589,10 +1590,10 @@ static int f_show(struct seq_file *m, void *v)
>   			   field->type, field->name, field->offset,
>   			   field->size, !!field->is_signed);
>   	else
> -		seq_printf(m, "\tfield:%.*s %s%s;\toffset:%u;\tsize:%u;\tsigned:%d;\n",
> +		seq_printf(m, "\tfield:%.*s %s[%d];\toffset:%u;\tsize:%u;\tsigned:%d;\n",
>   			   (int)(array_descriptor - field->type),
>   			   field->type, field->name,
> -			   array_descriptor, field->offset,
> +			   field->len, field->offset,
>   			   field->size, !!field->is_signed);
>   
>   	return 0;
> @@ -2371,6 +2372,7 @@ static int ftrace_event_release(struct inode *inode, struct file *file)
>   	if (list_empty(head)) {
>   		struct trace_event_fields *field = call->class->fields_array;
>   		unsigned int offset = sizeof(struct trace_entry);
> +		struct list_head *head;
>   
>   		for (; field->type; field++) {
>   			if (field->type == TRACE_FUNCTION_TYPE) {
> @@ -2379,9 +2381,15 @@ static int ftrace_event_release(struct inode *inode, struct file *file)
>   			}
>   
>   			offset = ALIGN(offset, field->align);
> -			ret = trace_define_field(call, field->type, field->name,
> +			if (WARN_ON(!call->class)) {
> +				offset += field->size;
> +				continue;
> +			}
> +			head = trace_get_fields(call);
> +			ret = __trace_define_field(head, field->type, field->name,
>   						 offset, field->size,
> -						 field->is_signed, field->filter_type);
> +						 field->is_signed, field->filter_type,
> +						 field->len);
>   			if (WARN_ON_ONCE(ret)) {
>   				pr_err("error code is %d\n", ret);
>   				break;

-- 
Mathieu Desnoyers
EfficiOS Inc.
https://www.efficios.com

