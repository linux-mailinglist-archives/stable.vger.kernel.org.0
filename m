Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B241B3F5636
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 04:59:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbhHXC75 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 22:59:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:56798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234550AbhHXC72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Aug 2021 22:59:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1CE2611C8;
        Tue, 24 Aug 2021 02:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629773924;
        bh=AA48YNAetgw38HVVuSBAQwb2hmqd/RNZntpxmdFhx2c=;
        h=From:To:Cc:Subject:Date:From;
        b=WywU9JydC/3rbeV+w7eqGR1+CN8FyCbJaHjvAXhMH8bVn8PGkb6lBDnWUPa6WRFp+
         XbJ4X+T3mxeoePRlCKKJz73glcM0d3EiM63w8FavJO9KM9WL77HKL9YWlyVVDEk+rT
         fCzj7W6+g/6TVyV8kErVrw1YlWHSjZmngkFMH5jclmXfQ/K0h5SWCdsi9djLQr97kR
         Zn/BCyr5/vhvLJPLmhRPiiUuFaYsAUkZQ4p331MRB2y1hTJSH/zwpXOeMd67aCIdwG
         4Mv33xjV8ChT8GYdc1fcjBXfuZRLorU+PF5OXvpH5AgMQy8T8J9OMfpAp+wULFpyKq
         aDzA5EJzNkQZg==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, kernelfans@gmail.com
Cc:     Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: FAILED: Patch "tracing: Apply trace filters on all output channels" failed to apply to 4.9-stable tree
Date:   Mon, 23 Aug 2021 22:58:42 -0400
Message-Id: <20210824025842.659799-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 6c34df6f350df9579ce99d887a2b5fa14cc13b32 Mon Sep 17 00:00:00 2001
From: Pingfan Liu <kernelfans@gmail.com>
Date: Sat, 14 Aug 2021 11:45:38 +0800
Subject: [PATCH] tracing: Apply trace filters on all output channels

The event filters are not applied on all of the output, which results in
the flood of printk when using tp_printk. Unfolding
event_trigger_unlock_commit_regs() into trace_event_buffer_commit(), so
the filters can be applied on every output.

Link: https://lkml.kernel.org/r/20210814034538.8428-1-kernelfans@gmail.com

Cc: stable@vger.kernel.org
Fixes: 0daa2302968c1 ("tracing: Add tp_printk cmdline to have tracepoints go to printk()")
Signed-off-by: Pingfan Liu <kernelfans@gmail.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 18 +++++++++++++++---
 kernel/trace/trace.h | 32 --------------------------------
 2 files changed, 15 insertions(+), 35 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 33899a71fdc1..a1adb29ef5c1 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2897,14 +2897,26 @@ int tracepoint_printk_sysctl(struct ctl_table *table, int write,
 
 void trace_event_buffer_commit(struct trace_event_buffer *fbuffer)
 {
+	enum event_trigger_type tt = ETT_NONE;
+	struct trace_event_file *file = fbuffer->trace_file;
+
+	if (__event_trigger_test_discard(file, fbuffer->buffer, fbuffer->event,
+			fbuffer->entry, &tt))
+		goto discard;
+
 	if (static_key_false(&tracepoint_printk_key.key))
 		output_printk(fbuffer);
 
 	if (static_branch_unlikely(&trace_event_exports_enabled))
 		ftrace_exports(fbuffer->event, TRACE_EXPORT_EVENT);
-	event_trigger_unlock_commit_regs(fbuffer->trace_file, fbuffer->buffer,
-				    fbuffer->event, fbuffer->entry,
-				    fbuffer->trace_ctx, fbuffer->regs);
+
+	trace_buffer_unlock_commit_regs(file->tr, fbuffer->buffer,
+			fbuffer->event, fbuffer->trace_ctx, fbuffer->regs);
+
+discard:
+	if (tt)
+		event_triggers_post_call(file, tt);
+
 }
 EXPORT_SYMBOL_GPL(trace_event_buffer_commit);
 
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a180abf76d4e..4a0e693000c6 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1389,38 +1389,6 @@ event_trigger_unlock_commit(struct trace_event_file *file,
 		event_triggers_post_call(file, tt);
 }
 
-/**
- * event_trigger_unlock_commit_regs - handle triggers and finish event commit
- * @file: The file pointer associated with the event
- * @buffer: The ring buffer that the event is being written to
- * @event: The event meta data in the ring buffer
- * @entry: The event itself
- * @trace_ctx: The tracing context flags.
- *
- * This is a helper function to handle triggers that require data
- * from the event itself. It also tests the event against filters and
- * if the event is soft disabled and should be discarded.
- *
- * Same as event_trigger_unlock_commit() but calls
- * trace_buffer_unlock_commit_regs() instead of trace_buffer_unlock_commit().
- */
-static inline void
-event_trigger_unlock_commit_regs(struct trace_event_file *file,
-				 struct trace_buffer *buffer,
-				 struct ring_buffer_event *event,
-				 void *entry, unsigned int trace_ctx,
-				 struct pt_regs *regs)
-{
-	enum event_trigger_type tt = ETT_NONE;
-
-	if (!__event_trigger_test_discard(file, buffer, event, entry, &tt))
-		trace_buffer_unlock_commit_regs(file->tr, buffer, event,
-						trace_ctx, regs);
-
-	if (tt)
-		event_triggers_post_call(file, tt);
-}
-
 #define FILTER_PRED_INVALID	((unsigned short)-1)
 #define FILTER_PRED_IS_RIGHT	(1 << 15)
 #define FILTER_PRED_FOLD	(1 << 15)
-- 
2.30.2




