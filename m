Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93F98F8870
	for <lists+stable@lfdr.de>; Tue, 12 Nov 2019 07:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726188AbfKLGU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 01:20:28 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:6202 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725298AbfKLGU2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 01:20:28 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 190D4EE9B7CD59F8D004;
        Tue, 12 Nov 2019 14:20:26 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.439.0; Tue, 12 Nov 2019 14:20:16 +0800
From:   Kefeng Wang <wangkefeng.wang@huawei.com>
To:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Steven Rostedt <rostedt@goodmis.org>, <wangkefeng.wang@huawei.com>
Subject: [PATCH stable 4.4] tracing: Have trace_buffer_unlock_commit() call the _regs version with NULL
Date:   Tue, 12 Nov 2019 14:18:50 +0800
Message-ID: <20191112061850.71600-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>

Commit 33fddff24d05d71f97722cb7deec4964d39d10dc upstream

There's no real difference between trace_buffer_unlock_commit() and
trace_buffer_unlock_commit_regs() except that the former passes NULL to
ftrace_stack_trace() instead of regs. Have the former be a static inline of
the latter which passes NULL for regs.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[backport: modify trace_buffer_unlock_commit() in include/linux/trace_events.h]
Fixes: c5e0535fe67b ("tracing: Skip more functions when doing stack tracing of events")
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/trace_events.h | 13 +++++++++----
 kernel/trace/trace.c         | 12 ------------
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 311176f290b2..3c752a9928e4 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -168,15 +168,20 @@ struct ring_buffer_event *
 trace_current_buffer_lock_reserve(struct ring_buffer **current_buffer,
 				  int type, unsigned long len,
 				  unsigned long flags, int pc);
-void trace_buffer_unlock_commit(struct trace_array *tr,
-				struct ring_buffer *buffer,
-				struct ring_buffer_event *event,
-				unsigned long flags, int pc);
 void trace_buffer_unlock_commit_regs(struct trace_array *tr,
 				     struct ring_buffer *buffer,
 				     struct ring_buffer_event *event,
 				     unsigned long flags, int pc,
 				     struct pt_regs *regs);
+
+static inline void trace_buffer_unlock_commit(struct trace_array *tr,
+					      struct ring_buffer *buffer,
+					      struct ring_buffer_event *event,
+					      unsigned long flags, int pc)
+{
+	trace_buffer_unlock_commit_regs(tr, buffer, event, flags, pc, NULL);
+}
+
 void trace_current_buffer_discard_commit(struct ring_buffer *buffer,
 					 struct ring_buffer_event *event);
 
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 29fc55b89491..4cd6d4092e67 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1698,18 +1698,6 @@ __buffer_unlock_commit(struct ring_buffer *buffer, struct ring_buffer_event *eve
 	ring_buffer_unlock_commit(buffer, event);
 }
 
-void trace_buffer_unlock_commit(struct trace_array *tr,
-				struct ring_buffer *buffer,
-				struct ring_buffer_event *event,
-				unsigned long flags, int pc)
-{
-	__buffer_unlock_commit(buffer, event);
-
-	ftrace_trace_stack(tr, buffer, flags, 6, pc, NULL);
-	ftrace_trace_userstack(buffer, flags, pc);
-}
-EXPORT_SYMBOL_GPL(trace_buffer_unlock_commit);
-
 static struct ring_buffer *temp_buffer;
 
 struct ring_buffer_event *
-- 
2.20.1

