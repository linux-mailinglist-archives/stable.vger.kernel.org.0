Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E246D6E640E
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbjDRMpv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbjDRMpv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:45:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CB114F42
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04D0063398
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C68C433EF;
        Tue, 18 Apr 2023 12:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821948;
        bh=54vFzB7Zn9o1J6Zd/SMBvMATVSUT3DykuXs/AZCyD0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kGladqdaY249vOdciAyUnL43EDhvRXpOqO6btTtLt7KaE756n1dxoUTH+PgRwOQrh
         RVcO6DrDVeQFemHMq+aUnKM7djpk4U53wDef8MMZz1skwAvDfAxT+KEEvflbWQA+LU
         dyufwt9Zbnsu24v0cs5hL5WnokiGrhVYbAWvqHBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Masami Hiramatsu <mhiramat@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ross Zwisler <zwisler@google.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/134] tracing: Add trace_array_puts() to write into instance
Date:   Tue, 18 Apr 2023 14:22:35 +0200
Message-Id: <20230418120316.633547449@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.001025904@linuxfoundation.org>
References: <20230418120313.001025904@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit d503b8f7474fe7ac616518f7fc49773cbab49f36 ]

Add a generic trace_array_puts() that can be used to "trace_puts()" into
an allocated trace_array instance. This is just another variant of
trace_array_printk().

Link: https://lkml.kernel.org/r/20230207173026.584717290@goodmis.org

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 9d52727f8043 ("tracing: Have tracing_snapshot_instance_cond() write errors to the appropriate instance")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/trace.h | 12 ++++++++++++
 kernel/trace/trace.c  | 27 +++++++++++++++++----------
 2 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/include/linux/trace.h b/include/linux/trace.h
index 80ffda8717491..2a70a447184c9 100644
--- a/include/linux/trace.h
+++ b/include/linux/trace.h
@@ -33,6 +33,18 @@ struct trace_array;
 int register_ftrace_export(struct trace_export *export);
 int unregister_ftrace_export(struct trace_export *export);
 
+/**
+ * trace_array_puts - write a constant string into the trace buffer.
+ * @tr:    The trace array to write to
+ * @str:   The constant string to write
+ */
+#define trace_array_puts(tr, str)					\
+	({								\
+		str ? __trace_array_puts(tr, _THIS_IP_, str, strlen(str)) : -1;	\
+	})
+int __trace_array_puts(struct trace_array *tr, unsigned long ip,
+		       const char *str, int size);
+
 void trace_printk_init_buffers(void);
 __printf(3, 4)
 int trace_array_printk(struct trace_array *tr, unsigned long ip,
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 78855e74e355f..5016ae826c463 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1002,13 +1002,8 @@ __buffer_unlock_commit(struct trace_buffer *buffer, struct ring_buffer_event *ev
 		ring_buffer_unlock_commit(buffer, event);
 }
 
-/**
- * __trace_puts - write a constant string into the trace buffer.
- * @ip:	   The address of the caller
- * @str:   The constant string to write
- * @size:  The size of the string.
- */
-int __trace_puts(unsigned long ip, const char *str, int size)
+int __trace_array_puts(struct trace_array *tr, unsigned long ip,
+		       const char *str, int size)
 {
 	struct ring_buffer_event *event;
 	struct trace_buffer *buffer;
@@ -1016,7 +1011,7 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	unsigned int trace_ctx;
 	int alloc;
 
-	if (!(global_trace.trace_flags & TRACE_ITER_PRINTK))
+	if (!(tr->trace_flags & TRACE_ITER_PRINTK))
 		return 0;
 
 	if (unlikely(tracing_selftest_running || tracing_disabled))
@@ -1025,7 +1020,7 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 	alloc = sizeof(*entry) + size + 2; /* possible \n added */
 
 	trace_ctx = tracing_gen_ctx();
-	buffer = global_trace.array_buffer.buffer;
+	buffer = tr->array_buffer.buffer;
 	ring_buffer_nest_start(buffer);
 	event = __trace_buffer_lock_reserve(buffer, TRACE_PRINT, alloc,
 					    trace_ctx);
@@ -1047,11 +1042,23 @@ int __trace_puts(unsigned long ip, const char *str, int size)
 		entry->buf[size] = '\0';
 
 	__buffer_unlock_commit(buffer, event);
-	ftrace_trace_stack(&global_trace, buffer, trace_ctx, 4, NULL);
+	ftrace_trace_stack(tr, buffer, trace_ctx, 4, NULL);
  out:
 	ring_buffer_nest_end(buffer);
 	return size;
 }
+EXPORT_SYMBOL_GPL(__trace_array_puts);
+
+/**
+ * __trace_puts - write a constant string into the trace buffer.
+ * @ip:	   The address of the caller
+ * @str:   The constant string to write
+ * @size:  The size of the string.
+ */
+int __trace_puts(unsigned long ip, const char *str, int size)
+{
+	return __trace_array_puts(&global_trace, ip, str, size);
+}
 EXPORT_SYMBOL_GPL(__trace_puts);
 
 /**
-- 
2.39.2



