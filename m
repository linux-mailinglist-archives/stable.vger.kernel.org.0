Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0D5F693A80
	for <lists+stable@lfdr.de>; Sun, 12 Feb 2023 23:38:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjBLWiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Feb 2023 17:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjBLWiz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Feb 2023 17:38:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E6D9EE0;
        Sun, 12 Feb 2023 14:38:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FBD260DF5;
        Sun, 12 Feb 2023 22:38:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC61C433EF;
        Sun, 12 Feb 2023 22:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676241531;
        bh=tHRqEvegtXFcgQT+AiyfDkrbLeeEV21tpa5G9byREZo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EQoeuV/JEYA33BRQ64FK9cUwB+krvVWrbhVL6Qlc54EZjqJfWbxIXF4eQ9a7jmxkC
         5ODG9y5qCb3uAHrrYT7w7kAgYOQ9nGaVZwQBCqiEPhF/w/sCe2BeLK7/Ee+dYHbSR6
         GlgkRD8c8zlxobTqbtCtmawJmGn86kkPLyMyqaprUDI7UmDIrjuCIB/UuuhgEjf50h
         1ALv32N3qJSnZ5dt2oo5XhWUcc9bgXK8G+V+sbMSu8qEIWE/YwR/lCorjvg1CcsFB9
         F/TxgO+pxMaRIWrcXfD3g6tdD66uYOmkVqQJUqwFdpjUhJ4eEB3QN1R+CedwYyp7rV
         9b8ak5ZWQtdLw==
Date:   Mon, 13 Feb 2023 07:38:47 +0900
From:   Masami Hiramatsu (Google) <mhiramat@kernel.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     rostedt@goodmis.org, linux-trace-kernel@vger.kernel.org,
        John Stultz <jstultz@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        Qais Yousef <qyousef@layalina.io>, stable@vger.kernel.org
Subject: Re: [PATCH -trace v2] trace: fix TASK_COMM_LEN in trace event
 format file
Message-Id: <20230213073847.35c140ed3e23585169b6fcaf@kernel.org>
In-Reply-To: <20230212151303.12353-1-laoar.shao@gmail.com>
References: <20230212151303.12353-1-laoar.shao@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 12 Feb 2023 15:13:03 +0000
Yafang Shao <laoar.shao@gmail.com> wrote:

> After commit 3087c61ed2c4 ("tools/testing/selftests/bpf: replace open-coded 16 with TASK_COMM_LEN"),
> the content of the format file under
> /sys/kernel/debug/tracing/events/task/task_newtask was changed from
>   field:char comm[16];    offset:12;    size:16;    signed:0;
> to
>   field:char comm[TASK_COMM_LEN];    offset:12;    size:16;    signed:0;
> 
> John reported that this change breaks older versions of perfetto.
> Then Mathieu pointed out that this behavioral change was caused by the
> use of __stringify(_len), which happens to work on macros, but not on enum
> labels. And he also gave the suggestion on how to fix it:
>   :One possible solution to make this more robust would be to extend
>   :struct trace_event_fields with one more field that indicates the length
>   :of an array as an actual integer, without storing it in its stringified
>   :form in the type, and do the formatting in f_show where it belongs.
> 
> The result as follows after this change,
> $ cat /sys/kernel/debug/tracing/events/task/task_newtask/format
>         field:char comm[16];    offset:12;      size:16;        signed:0;
> 
> Fixes: 3087c61ed2c4 ("tools/testing/selftests/bpf: replace open-coded 16 with TASK_COMM_LEN")
> Reported-by: John Stultz <jstultz@google.com>
> Debugged-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Suggested-by: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Kajetan Puchalski <kajetan.puchalski@arm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> CC: Qais Yousef <qyousef@layalina.io>
> Cc: John Stultz <jstultz@google.com>
> Cc: stable@vger.kernel.org # v5.17+

This looks good to me. 

Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>

Thanks!

> ---
>  include/linux/trace_events.h               |  1 +
>  include/trace/stages/stage4_event_fields.h |  3 ++-
>  kernel/trace/trace.h                       |  1 +
>  kernel/trace/trace_events.c                | 39 +++++++++++++++++++++++-------
>  kernel/trace/trace_export.c                |  3 ++-
>  5 files changed, 36 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
> index 4342e99..0e37322 100644
> --- a/include/linux/trace_events.h
> +++ b/include/linux/trace_events.h
> @@ -270,6 +270,7 @@ struct trace_event_fields {
>  			const int  align;
>  			const int  is_signed;
>  			const int  filter_type;
> +			const int  len;
>  		};
>  		int (*define_fields)(struct trace_event_call *);
>  	};
> diff --git a/include/trace/stages/stage4_event_fields.h b/include/trace/stages/stage4_event_fields.h
> index affd541..b6f679a 100644
> --- a/include/trace/stages/stage4_event_fields.h
> +++ b/include/trace/stages/stage4_event_fields.h
> @@ -26,7 +26,8 @@
>  #define __array(_type, _item, _len) {					\
>  	.type = #_type"["__stringify(_len)"]", .name = #_item,		\
>  	.size = sizeof(_type[_len]), .align = ALIGN_STRUCTFIELD(_type),	\
> -	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER },
> +	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER,\
> +	.len = _len },
>  
>  #undef __dynamic_array
>  #define __dynamic_array(_type, _item, _len) {				\
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index e46a492..19caf15 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -1282,6 +1282,7 @@ struct ftrace_event_field {
>  	int			offset;
>  	int			size;
>  	int			is_signed;
> +	int			len;
>  };
>  
>  struct prog_entry;
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 33e0b4f..6a46967 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -114,7 +114,7 @@ struct ftrace_event_field *
>  
>  static int __trace_define_field(struct list_head *head, const char *type,
>  				const char *name, int offset, int size,
> -				int is_signed, int filter_type)
> +				int is_signed, int filter_type, int len)
>  {
>  	struct ftrace_event_field *field;
>  
> @@ -133,6 +133,7 @@ static int __trace_define_field(struct list_head *head, const char *type,
>  	field->offset = offset;
>  	field->size = size;
>  	field->is_signed = is_signed;
> +	field->len = len;
>  
>  	list_add(&field->link, head);
>  
> @@ -150,14 +151,28 @@ int trace_define_field(struct trace_event_call *call, const char *type,
>  
>  	head = trace_get_fields(call);
>  	return __trace_define_field(head, type, name, offset, size,
> -				    is_signed, filter_type);
> +				    is_signed, filter_type, 0);
>  }
>  EXPORT_SYMBOL_GPL(trace_define_field);
>  
> +int trace_define_field_ext(struct trace_event_call *call, const char *type,
> +		       const char *name, int offset, int size, int is_signed,
> +		       int filter_type, int len)
> +{
> +	struct list_head *head;
> +
> +	if (WARN_ON(!call->class))
> +		return 0;
> +
> +	head = trace_get_fields(call);
> +	return __trace_define_field(head, type, name, offset, size,
> +				    is_signed, filter_type, len);
> +}
> +
>  #define __generic_field(type, item, filter_type)			\
>  	ret = __trace_define_field(&ftrace_generic_fields, #type,	\
>  				   #item, 0, 0, is_signed_type(type),	\
> -				   filter_type);			\
> +				   filter_type, 0);			\
>  	if (ret)							\
>  		return ret;
>  
> @@ -166,7 +181,7 @@ int trace_define_field(struct trace_event_call *call, const char *type,
>  				   "common_" #item,			\
>  				   offsetof(typeof(ent), item),		\
>  				   sizeof(ent.item),			\
> -				   is_signed_type(type), FILTER_OTHER);	\
> +				   is_signed_type(type), FILTER_OTHER, 0);	\
>  	if (ret)							\
>  		return ret;
>  
> @@ -1588,12 +1603,17 @@ static int f_show(struct seq_file *m, void *v)
>  		seq_printf(m, "\tfield:%s %s;\toffset:%u;\tsize:%u;\tsigned:%d;\n",
>  			   field->type, field->name, field->offset,
>  			   field->size, !!field->is_signed);
> -	else
> -		seq_printf(m, "\tfield:%.*s %s%s;\toffset:%u;\tsize:%u;\tsigned:%d;\n",
> +	else if (field->len)
> +		seq_printf(m, "\tfield:%.*s %s[%d];\toffset:%u;\tsize:%u;\tsigned:%d;\n",
>  			   (int)(array_descriptor - field->type),
>  			   field->type, field->name,
> -			   array_descriptor, field->offset,
> +			   field->len, field->offset,
>  			   field->size, !!field->is_signed);
> +	else
> +		seq_printf(m, "\tfield:%.*s %s[];\toffset:%u;\tsize:%u;\tsigned:%d;\n",
> +				(int)(array_descriptor - field->type),
> +				field->type, field->name,
> +				field->offset, field->size, !!field->is_signed);
>  
>  	return 0;
>  }
> @@ -2379,9 +2399,10 @@ static int ftrace_event_release(struct inode *inode, struct file *file)
>  			}
>  
>  			offset = ALIGN(offset, field->align);
> -			ret = trace_define_field(call, field->type, field->name,
> +			ret = trace_define_field_ext(call, field->type, field->name,
>  						 offset, field->size,
> -						 field->is_signed, field->filter_type);
> +						 field->is_signed, field->filter_type,
> +						 field->len);
>  			if (WARN_ON_ONCE(ret)) {
>  				pr_err("error code is %d\n", ret);
>  				break;
> diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
> index d960f6b..58f3946 100644
> --- a/kernel/trace/trace_export.c
> +++ b/kernel/trace/trace_export.c
> @@ -111,7 +111,8 @@ struct ____ftrace_##name {						\
>  #define __array(_type, _item, _len) {					\
>  	.type = #_type"["__stringify(_len)"]", .name = #_item,		\
>  	.size = sizeof(_type[_len]), .align = __alignof__(_type),	\
> -	is_signed_type(_type), .filter_type = FILTER_OTHER },
> +	is_signed_type(_type), .filter_type = FILTER_OTHER,			\
> +	.len = _len },
>  
>  #undef __array_desc
>  #define __array_desc(_type, _container, _item, _len) __array(_type, _item, _len)
> -- 
> 1.8.3.1
> 


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>
