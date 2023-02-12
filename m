Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 878D86937E3
	for <lists+stable@lfdr.de>; Sun, 12 Feb 2023 16:13:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjBLPNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Feb 2023 10:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBLPNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Feb 2023 10:13:37 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13B05113F4;
        Sun, 12 Feb 2023 07:13:35 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id d8so9967082plr.10;
        Sun, 12 Feb 2023 07:13:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FkU5JaLBYxqea7gQus9Yup8qzEXujmxqvJ+7aC0phTQ=;
        b=k3W7e38yDjoh2lF8QUgNnTaelGhsAwQPQ//GU8MnjwKhOAzeN2fzuwK9OKReuWNCZW
         qIsY0OxE6ZjIRDePE2mbkGgnxQ6wkijeGL9eG2wf8owIjfM0Frl+iFHL3uugzx5Yhzp3
         vn0B1jA27zMNGmKNeHCGun2qAZw5SEuilU9S8VImLoBy0olsL5h7MMGTawMsU/ajA4a5
         E/3Lbz3QV5ZNDP6gAMz/GyurbfyR3yHKWjKJApdKxTz2dnHYqK+i1oN/DY5mHWQlhLkR
         6CgMpuXawpAfvkSEUhtlkmbnNlEL6jB/5wlsRNBp/y/KpJHSif5Tp/VNX5yLfYS8Benf
         MgcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FkU5JaLBYxqea7gQus9Yup8qzEXujmxqvJ+7aC0phTQ=;
        b=aj435idXgszh51R/WIyk6Mdk6p+tG4Cmd6AMgSHLDZpdPnkpV3TWMuyVq6JIJrp7ww
         qij4TlilFnRMi6ylUoJ1DIaji4taikauAJqsLHvRxm8L/9n4IWyD5qNyFrHAIifUKFNN
         YU5Ww5B6OnFCh9xqO1Sel0/lV5iZhNZGb+2YElDBrxTAnm4BAUz16PFJNuUDDip0mNMi
         4VILrgvsuPgkspZ69Or/hwqore8zZPE27xCuqHkWtCNLcje+RcHbPS6s+/IqrXViwgl6
         r8vA37W70MHqj92riNDRjGxwiyZf5HHHLTMQEn1LwhUXxwwaQzLwbCJaKNxYAZBj4c/S
         MeWQ==
X-Gm-Message-State: AO0yUKX2vQdCh/n+qXQmzI+yCJp0DgfMb/vaNq885JDt1eX/tcwN4+6K
        7SOHtPgcVD8KB4iO73OXp+8=
X-Google-Smtp-Source: AK7set+GSFIQa2dwyWo6+B7ZzU4S0EzqRFasJMVJS/FPuDxUK+wCsundhYll2C7Ft2xyy2+D89GDGQ==
X-Received: by 2002:a17:902:ec82:b0:196:56ae:ed1d with SMTP id x2-20020a170902ec8200b0019656aeed1dmr21798932plg.69.1676214814533;
        Sun, 12 Feb 2023 07:13:34 -0800 (PST)
Received: from vultr.guest ([45.76.101.150])
        by smtp.gmail.com with ESMTPSA id k13-20020a170902ba8d00b001948cc9c2fbsm6499324pls.133.2023.02.12.07.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 07:13:34 -0800 (PST)
From:   Yafang Shao <laoar.shao@gmail.com>
To:     rostedt@goodmis.org, mhiramat@kernel.org
Cc:     linux-trace-kernel@vger.kernel.org,
        Yafang Shao <laoar.shao@gmail.com>,
        John Stultz <jstultz@google.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Kajetan Puchalski <kajetan.puchalski@arm.com>,
        Qais Yousef <qyousef@layalina.io>, stable@vger.kernel.org
Subject: [PATCH -trace v2] trace: fix TASK_COMM_LEN in trace event format file
Date:   Sun, 12 Feb 2023 15:13:03 +0000
Message-Id: <20230212151303.12353-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.39.1
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
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Kajetan Puchalski <kajetan.puchalski@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
CC: Qais Yousef <qyousef@layalina.io>
Cc: John Stultz <jstultz@google.com>
Cc: stable@vger.kernel.org # v5.17+
---
 include/linux/trace_events.h               |  1 +
 include/trace/stages/stage4_event_fields.h |  3 ++-
 kernel/trace/trace.h                       |  1 +
 kernel/trace/trace_events.c                | 39 +++++++++++++++++++++++-------
 kernel/trace/trace_export.c                |  3 ++-
 5 files changed, 36 insertions(+), 11 deletions(-)

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
index affd541..b6f679a 100644
--- a/include/trace/stages/stage4_event_fields.h
+++ b/include/trace/stages/stage4_event_fields.h
@@ -26,7 +26,8 @@
 #define __array(_type, _item, _len) {					\
 	.type = #_type"["__stringify(_len)"]", .name = #_item,		\
 	.size = sizeof(_type[_len]), .align = ALIGN_STRUCTFIELD(_type),	\
-	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER },
+	.is_signed = is_signed_type(_type), .filter_type = FILTER_OTHER,\
+	.len = _len },
 
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
index 33e0b4f..6a46967 100644
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
 
@@ -166,7 +181,7 @@ int trace_define_field(struct trace_event_call *call, const char *type,
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
+				(int)(array_descriptor - field->type),
+				field->type, field->name,
+				field->offset, field->size, !!field->is_signed);
 
 	return 0;
 }
@@ -2379,9 +2399,10 @@ static int ftrace_event_release(struct inode *inode, struct file *file)
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
index d960f6b..58f3946 100644
--- a/kernel/trace/trace_export.c
+++ b/kernel/trace/trace_export.c
@@ -111,7 +111,8 @@ struct ____ftrace_##name {						\
 #define __array(_type, _item, _len) {					\
 	.type = #_type"["__stringify(_len)"]", .name = #_item,		\
 	.size = sizeof(_type[_len]), .align = __alignof__(_type),	\
-	is_signed_type(_type), .filter_type = FILTER_OTHER },
+	is_signed_type(_type), .filter_type = FILTER_OTHER,			\
+	.len = _len },
 
 #undef __array_desc
 #define __array_desc(_type, _container, _item, _len) __array(_type, _item, _len)
-- 
1.8.3.1

