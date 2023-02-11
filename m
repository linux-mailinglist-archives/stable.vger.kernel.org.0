Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA0E76933A3
	for <lists+stable@lfdr.de>; Sat, 11 Feb 2023 21:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbjBKUX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Feb 2023 15:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbjBKUXZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Feb 2023 15:23:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D11125BE;
        Sat, 11 Feb 2023 12:23:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DD02B80064;
        Sat, 11 Feb 2023 20:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AED4C433EF;
        Sat, 11 Feb 2023 20:23:20 +0000 (UTC)
Date:   Sat, 11 Feb 2023 15:23:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yafang Shao <laoar.shao@gmail.com>
Cc:     mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org,
        John Stultz <jstultz@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH -trace] trace: fix TASK_COMM_LEN in trace event format
 file
Message-ID: <20230211152318.2c6b2389@gandalf.local.home>
In-Reply-To: <20230210155921.4610-1-laoar.shao@gmail.com>
References: <20230210155921.4610-1-laoar.shao@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 10 Feb 2023 15:59:21 +0000
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
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
> Cc: Kajetan Puchalski <kajetan.puchalski@arm.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: John Stultz <jstultz@google.com>
> Cc: stable@vger.kernel.org # v5.17+
> ---

The below patch appears to not break[*] anything, as I did a diff off
all events, before and after, and it looks like a nice clean up!

I had to cover the "ftrace events" which are not trace events (for example,
trace_printk, function, function_graph). They are created by their own
macros that are similar. But your original patch broke them.

Please use this patch, and resubmit. I'll push it through my tree after
it goes through all my normal testing. You can include:

Suggested-by: Steven Rostedt (Google) <rostedt@goodmis.org>

[*] I haven't run it through all my tests yet.

Thanks.

-- Steve

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 4342e996bcdb..0e373222a6df 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -270,6 +270,7 @@ struct trace_event_fields {
 			const int  align;
 			const int  is_signed;
 			const int  filter_type;
+			const int  len;
 		};
 		int (*define_fields)(struct trace_event_call *);
 	};
diff --git a/include/trace/stages/stage4_event_fields.h b/include/trace/stages/stage4_event_fields.h
index affd541fd25e..306f39aab480 100644
--- a/include/trace/stages/stage4_event_fields.h
+++ b/include/trace/stages/stage4_event_fields.h
@@ -26,7 +26,8 @@
 #define __array(_type, _item, _len) {					\
 	.type = #_type"["__stringify(_len)"]", .name = #_item,		\
 	.size = sizeof(_type[_len]), .align = ALIGN_STRUCTFIELD(_type),	\
-	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER },
+	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER, \
+	.len = _len },
 
 #undef __dynamic_array
 #define __dynamic_array(_type, _item, _len) {				\
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index f10bf804dd2b..f3aae2be1d53 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1286,6 +1286,7 @@ struct ftrace_event_field {
 	int			offset;
 	int			size;
 	int			is_signed;
+	int			len;
 };
 
 struct prog_entry;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index cf3fd74fa675..60ab2f2108fe 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -114,7 +114,7 @@ trace_find_event_field(struct trace_event_call *call, char *name)
 
 static int __trace_define_field(struct list_head *head, const char *type,
 				const char *name, int offset, int size,
-				int is_signed, int filter_type)
+				int is_signed, int filter_type, int len)
 {
 	struct ftrace_event_field *field;
 
@@ -133,6 +133,7 @@ static int __trace_define_field(struct list_head *head, const char *type,
 	field->offset = offset;
 	field->size = size;
 	field->is_signed = is_signed;
+	field->len = len;
 
 	list_add(&field->link, head);
 
@@ -150,14 +151,28 @@ int trace_define_field(struct trace_event_call *call, const char *type,
 
 	head = trace_get_fields(call);
 	return __trace_define_field(head, type, name, offset, size,
-				    is_signed, filter_type);
+				    is_signed, filter_type, 0);
 }
 EXPORT_SYMBOL_GPL(trace_define_field);
 
+int trace_define_field_ext(struct trace_event_call *call, const char *type,
+		       const char *name, int offset, int size, int is_signed,
+		       int filter_type, int len)
+{
+	struct list_head *head;
+
+	if (WARN_ON(!call->class))
+		return 0;
+
+	head = trace_get_fields(call);
+	return __trace_define_field(head, type, name, offset, size,
+				    is_signed, filter_type, len);
+}
+
 #define __generic_field(type, item, filter_type)			\
 	ret = __trace_define_field(&ftrace_generic_fields, #type,	\
 				   #item, 0, 0, is_signed_type(type),	\
-				   filter_type);			\
+				   filter_type, 0);			\
 	if (ret)							\
 		return ret;
 
@@ -166,7 +181,7 @@ EXPORT_SYMBOL_GPL(trace_define_field);
 				   "common_" #item,			\
 				   offsetof(typeof(ent), item),		\
 				   sizeof(ent.item),			\
-				   is_signed_type(type), FILTER_OTHER);	\
+				   is_signed_type(type), FILTER_OTHER, 0);	\
 	if (ret)							\
 		return ret;
 
@@ -1588,12 +1603,17 @@ static int f_show(struct seq_file *m, void *v)
 		seq_printf(m, "\tfield:%s %s;\toffset:%u;\tsize:%u;\tsigned:%d;\n",
 			   field->type, field->name, field->offset,
 			   field->size, !!field->is_signed);
-	else
-		seq_printf(m, "\tfield:%.*s %s%s;\toffset:%u;\tsize:%u;\tsigned:%d;\n",
+	else if (field->len)
+		seq_printf(m, "\tfield:%.*s %s[%d];\toffset:%u;\tsize:%u;\tsigned:%d;\n",
 			   (int)(array_descriptor - field->type),
 			   field->type, field->name,
-			   array_descriptor, field->offset,
+			   field->len, field->offset,
 			   field->size, !!field->is_signed);
+	else
+		seq_printf(m, "\tfield:%.*s %s[];\toffset:%u;\tsize:%u;\tsigned:%d;\n",
+			   (int)(array_descriptor - field->type),
+			   field->type, field->name,
+			   field->offset, field->size, !!field->is_signed);
 
 	return 0;
 }
@@ -2379,9 +2399,10 @@ event_define_fields(struct trace_event_call *call)
 			}
 
 			offset = ALIGN(offset, field->align);
-			ret = trace_define_field(call, field->type, field->name,
+			ret = trace_define_field_ext(call, field->type, field->name,
 						 offset, field->size,
-						 field->is_signed, field->filter_type);
+						 field->is_signed, field->filter_type,
+						 field->len);
 			if (WARN_ON_ONCE(ret)) {
 				pr_err("error code is %d\n", ret);
 				break;
diff --git a/kernel/trace/trace_export.c b/kernel/trace/trace_export.c
index d960f6b11b5e..9d0a6ea4c076 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -111,7 +111,8 @@ static void __always_unused ____ftrace_check_##name(void)		\
 #define __array(_type, _item, _len) {					\
 	.type = #_type"["__stringify(_len)"]", .name = #_item,		\
 	.size = sizeof(_type[_len]), .align = __alignof__(_type),	\
-	is_signed_type(_type), .filter_type = FILTER_OTHER },
+	is_signed_type(_type), .filter_type = FILTER_OTHER,		\
+	.len = _len },							\
 
 #undef __array_desc
 #define __array_desc(_type, _container, _item, _len) __array(_type, _item, _len)
