Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE96B6922D3
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 16:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbjBJP7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 10:59:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232940AbjBJP7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 10:59:48 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8278578D6E;
        Fri, 10 Feb 2023 07:59:29 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id nn4-20020a17090b38c400b00233a6f118d0so3234339pjb.2;
        Fri, 10 Feb 2023 07:59:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/2yZsou7AT3LrMXyTCd+FTdTvhKynWuAdyAqvzx2oio=;
        b=OE1gNB2U9IG5FxBDrs2PSL5SrsKcq92aM2lfBfMi6y3r9UMgvLxcfGC774dNfOlOX8
         h9MdLawItbwCnmPZY/0HOc759mnKLI6SIThEtCxq9sVw0FcxumE8u2ZM9Y6wcG+gx0Ey
         I3c4vPBIia2ZMR/GzhShIYCMe/ASgdODKEVF8CsRnJkTvGFZfsiJh7prbg/bdu11fNrm
         A4oMZDa+1rJ6VT6FiVuf9qkf16ELu9Qi4ZxhNh4OSTtECoD3G1IlgslGXSfp+tlbUWu3
         sQoZLdZVVjV2oe4oB5rEbHOudAdohCLLx/KlMicpz8oydiB6Fh8O7vP8ELQAvl8sWYmJ
         mYGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/2yZsou7AT3LrMXyTCd+FTdTvhKynWuAdyAqvzx2oio=;
        b=0fv+W21vTe7XA3B7mqh/p9XNPnA4R3BIJtQDITPaIa8l2OKCb9fW6tMN8x8+7qHnpN
         dv28u9trlT9ff+IYwYBl5KjrDDw/s/7FJUlRg4yFmuiukdOqIS5++Ywrh4Ux02ycmLMq
         kRKiapzIb2jreVB881qV8R9vNG3e/gMJ2D9H6150YyNJY41l9lAQcxrnt6iyNjjRA0V3
         UfvjsvEj5YACgRtBzctig+WRyDXTyEZKvYrruAyDjhe/cthSXHttiaJFwBAcqW2Kweex
         +nGA/kL59YriTGoHz398769PW9C021V4EY+BMzggjchoxo92mTM5QsMiVDRd114tnBGQ
         0uCA==
X-Gm-Message-State: AO0yUKUoDXVByFfq+2xx5+6jOgQqOzK8F8R1GsLcvP2lwF2g/CZekE43
        lVFPIU7JzekLQhP/jFxkR98=
X-Google-Smtp-Source: AK7set9iwZ3F0t4fKaGDqF1cHBT7zMho1KP7lsqsOEmvqebRDq8QmZUpT9aj84IEu1nrp4GaHLd6FA==
X-Received: by 2002:a17:90a:1908:b0:230:7a2b:da9c with SMTP id 8-20020a17090a190800b002307a2bda9cmr17294693pjg.30.1676044766961;
        Fri, 10 Feb 2023 07:59:26 -0800 (PST)
Received: from vultr.guest ([2001:19f0:7001:2f6a:5400:4ff:fe4c:e050])
        by smtp.gmail.com with ESMTPSA id v13-20020a17090ac90d00b00232cd5171e1sm3252891pjt.52.2023.02.10.07.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Feb 2023 07:59:26 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org
Cc:     linux-trace-kernel@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>,
        John Stultz <jstultz@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        stable@vger.kernel.org
Subject: [PATCH -trace] trace: fix TASK_COMM_LEN in trace event format file
Date:   Fri, 10 Feb 2023 15:59:21 +0000
Message-Id: <20230210155921.4610-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit 3087c61ed2c4 ("tools/testing/selftests/bpf: replace open-coded 16 with TASK_COMM_LEN"),
the content of the format file under
/sys/kernel/debug/tracing/events/task/task_newtask was changed from
  field:char comm[16];    offset:12;    size:16;    signed:0;
to
  field:char comm[TASK_COMM_LEN];    offset:12;    size:16;    signed:0;

John reported that this change breaks older versions of perfetto.
Then Mathieu pointed out that this behavioral change was caused by the
use of __stringify(_len), which happens to work on macros, but not on enum
labels. And he also gave the suggestion on how to fix it:
  :One possible solution to make this more robust would be to extend
  :struct trace_event_fields with one more field that indicates the length
  :of an array as an actual integer, without storing it in its stringified
  :form in the type, and do the formatting in f_show where it belongs.

The result as follows after this change,
$ cat /sys/kernel/debug/tracing/events/task/task_newtask/format
        field:char comm[16];    offset:12;      size:16;        signed:0;

Fixes: 3087c61ed2c4 ("tools/testing/selftests/bpf: replace open-coded 16 with TASK_COMM_LEN")
Reported-by: John Stultz <jstultz@google.com>
Debugged-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Suggested-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Kajetan Puchalski <kajetan.puchalski@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: John Stultz <jstultz@google.com>
Cc: stable@vger.kernel.org # v5.17+
---
 include/linux/trace_events.h               |  1 +
 include/trace/stages/stage4_event_fields.h |  3 ++-
 kernel/trace/trace.h                       |  1 +
 kernel/trace/trace_events.c                | 24 ++++++++++++++++--------
 4 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 4342e99..0e37322 100644
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
index affd541..306f39a 100644
--- a/include/trace/stages/stage4_event_fields.h
+++ b/include/trace/stages/stage4_event_fields.h
@@ -26,7 +26,8 @@
 #define __array(_type, _item, _len) {					\
 	.type = #_type"["__stringify(_len)"]", .name = #_item,		\
 	.size = sizeof(_type[_len]), .align = ALIGN_STRUCTFIELD(_type),	\
-	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER },
+	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER, \
+	.len = _len},
 
 #undef __dynamic_array
 #define __dynamic_array(_type, _item, _len) {				\
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index e46a492..19caf15 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1282,6 +1282,7 @@ struct ftrace_event_field {
 	int			offset;
 	int			size;
 	int			is_signed;
+	int			len;
 };
 
 struct prog_entry;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 33e0b4f..70f6725 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -114,7 +114,7 @@ struct ftrace_event_field *
 
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
 
@@ -150,14 +151,14 @@ int trace_define_field(struct trace_event_call *call, const char *type,
 
 	head = trace_get_fields(call);
 	return __trace_define_field(head, type, name, offset, size,
-				    is_signed, filter_type);
+				    is_signed, filter_type, 0);
 }
 EXPORT_SYMBOL_GPL(trace_define_field);
 
 #define __generic_field(type, item, filter_type)			\
 	ret = __trace_define_field(&ftrace_generic_fields, #type,	\
 				   #item, 0, 0, is_signed_type(type),	\
-				   filter_type);			\
+				   filter_type, 0);			\
 	if (ret)							\
 		return ret;
 
@@ -166,7 +167,7 @@ int trace_define_field(struct trace_event_call *call, const char *type,
 				   "common_" #item,			\
 				   offsetof(typeof(ent), item),		\
 				   sizeof(ent.item),			\
-				   is_signed_type(type), FILTER_OTHER);	\
+				   is_signed_type(type), FILTER_OTHER, 0);	\
 	if (ret)							\
 		return ret;
 
@@ -1589,10 +1590,10 @@ static int f_show(struct seq_file *m, void *v)
 			   field->type, field->name, field->offset,
 			   field->size, !!field->is_signed);
 	else
-		seq_printf(m, "\tfield:%.*s %s%s;\toffset:%u;\tsize:%u;\tsigned:%d;\n",
+		seq_printf(m, "\tfield:%.*s %s[%d];\toffset:%u;\tsize:%u;\tsigned:%d;\n",
 			   (int)(array_descriptor - field->type),
 			   field->type, field->name,
-			   array_descriptor, field->offset,
+			   field->len, field->offset,
 			   field->size, !!field->is_signed);
 
 	return 0;
@@ -2371,6 +2372,7 @@ static int ftrace_event_release(struct inode *inode, struct file *file)
 	if (list_empty(head)) {
 		struct trace_event_fields *field = call->class->fields_array;
 		unsigned int offset = sizeof(struct trace_entry);
+		struct list_head *head;
 
 		for (; field->type; field++) {
 			if (field->type == TRACE_FUNCTION_TYPE) {
@@ -2379,9 +2381,15 @@ static int ftrace_event_release(struct inode *inode, struct file *file)
 			}
 
 			offset = ALIGN(offset, field->align);
-			ret = trace_define_field(call, field->type, field->name,
+			if (WARN_ON(!call->class)) {
+				offset += field->size;
+				continue;
+			}
+			head = trace_get_fields(call);
+			ret = __trace_define_field(head, field->type, field->name,
 						 offset, field->size,
-						 field->is_signed, field->filter_type);
+						 field->is_signed, field->filter_type,
+						 field->len);
 			if (WARN_ON_ONCE(ret)) {
 				pr_err("error code is %d\n", ret);
 				break;
-- 
1.8.3.1

