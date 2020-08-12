Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7387124303F
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 22:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbgHLUx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Aug 2020 16:53:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38018 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgHLUx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Aug 2020 16:53:28 -0400
Received: from 2.general.dannf.us.vpn ([10.172.65.1] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <dann.frazier@canonical.com>)
        id 1k5xkT-0007fx-ND; Wed, 12 Aug 2020 20:53:26 +0000
From:   dann frazier <dann.frazier@canonical.com>
To:     stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.4] tracing: Move pipe reference to trace array instead of current_tracer
Date:   Wed, 12 Aug 2020 14:53:22 -0600
Message-Id: <20200812205322.229101-1-dann.frazier@canonical.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

commit 7ef282e05132d56b6f6b71e3873f317664bea78b upstream

If a process has the trace_pipe open on a trace_array, the current tracer
for that trace array should not be changed. This was original enforced by a
global lock, but when instances were introduced, it was moved to the
current_trace. But this structure is shared by all instances, and a
trace_pipe is for a single instance. There's no reason that a process that
has trace_pipe open on one instance should prevent another instance from
changing its current tracer. Move the reference counter to the trace_array
instead.

This is marked as "Fixes" but is more of a clean up than a true fix.
Backport if you want, but its not critical.

Fixes: cf6ab6d9143b1 ("tracing: Add ref count to tracer for when they are being read by pipe")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: stable@vger.kernel.org # 5.4.x
[Resolved conflict in __remove_instance()]
Signed-off-by: dann frazier <dann.frazier@canonical.com>
---
This addresses an issue we've seen with users trying to change
current_tracer when they happen to have rasdaemon installed.
rasdaemon uses the trace_pipe interface at runtime, which therefore
blocks changing the current tracer. But of course, unless
you know about rasdaemon internals, it isn't exactly an obvious
failure mode.

Conflict in __remove_instance() was due to a change in reference counter
 semantics introduced later in v5.5 via commit 288797871473
 "tracing: Adding new functions for kernel access to Ftrace instances".
Resolved by leaving the first test in the if statement as it was in v5.4.

kernel/trace/trace.c | 12 ++++++------
 kernel/trace/trace.h |  2 +-
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 721947b9962d..f9c2bdbbd893 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5686,7 +5686,7 @@ static int tracing_set_tracer(struct trace_array *tr, const char *buf)
 	}
 
 	/* If trace pipe files are being read, we can't change the tracer */
-	if (tr->current_trace->ref) {
+	if (tr->trace_ref) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -5902,7 +5902,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
 
 	nonseekable_open(inode, filp);
 
-	tr->current_trace->ref++;
+	tr->trace_ref++;
 out:
 	mutex_unlock(&trace_types_lock);
 	return ret;
@@ -5921,7 +5921,7 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
 
 	mutex_lock(&trace_types_lock);
 
-	tr->current_trace->ref--;
+	tr->trace_ref--;
 
 	if (iter->trace->pipe_close)
 		iter->trace->pipe_close(iter);
@@ -7230,7 +7230,7 @@ static int tracing_buffers_open(struct inode *inode, struct file *filp)
 
 	filp->private_data = info;
 
-	tr->current_trace->ref++;
+	tr->trace_ref++;
 
 	mutex_unlock(&trace_types_lock);
 
@@ -7331,7 +7331,7 @@ static int tracing_buffers_release(struct inode *inode, struct file *file)
 
 	mutex_lock(&trace_types_lock);
 
-	iter->tr->current_trace->ref--;
+	iter->tr->trace_ref--;
 
 	__trace_array_put(iter->tr);
 
@@ -8470,7 +8470,7 @@ static int __remove_instance(struct trace_array *tr)
 {
 	int i;
 
-	if (tr->ref || (tr->current_trace && tr->current_trace->ref))
+	if (tr->ref || (tr->current_trace && tr->trace_ref))
 		return -EBUSY;
 
 	list_del(&tr->list);
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index a3c29d5fcc61..4055158c1dd2 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -309,6 +309,7 @@ struct trace_array {
 	struct trace_event_file *trace_marker_file;
 	cpumask_var_t		tracing_cpumask; /* only trace on set CPUs */
 	int			ref;
+	int			trace_ref;
 #ifdef CONFIG_FUNCTION_TRACER
 	struct ftrace_ops	*ops;
 	struct trace_pid_list	__rcu *function_pids;
@@ -498,7 +499,6 @@ struct tracer {
 	struct tracer		*next;
 	struct tracer_flags	*flags;
 	int			enabled;
-	int			ref;
 	bool			print_max;
 	bool			allow_instances;
 #ifdef CONFIG_TRACER_MAX_TRACE
-- 
2.28.0

