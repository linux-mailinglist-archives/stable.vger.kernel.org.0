Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47FF3C9FED
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 15:42:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhGONpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 09:45:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237491AbhGONpN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 09:45:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE90861167;
        Thu, 15 Jul 2021 13:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626356539;
        bh=OIqpL8iO/ub2lGKDXkZisMMIpb4/6jGEiGv7y3Iiltg=;
        h=Subject:To:Cc:From:Date:From;
        b=R+Rlebmd577jiYVP1dUqntX+qmNugefc6dIG6yR4SU4An5i08z59vyIEqwp1M8SQ6
         z8ENTNj6CTQQw9dQQNkKIpq6ZJnsN4pe3hZgWUN4jRUoxPIL1xk0ruLfchOnIwnNRA
         T+Lpv+ctM2BNQXkYamaK2FZpaa3yFATzS5uPoynQ=
Subject: FAILED: patch "[PATCH] tracing: Resize tgid_map to pid_max, not PID_MAX_DEFAULT" failed to apply to 4.14-stable tree
To:     paulburton@google.com, joelaf@google.com, mingo@redhat.com,
        rostedt@goodmis.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 15 Jul 2021 15:42:17 +0200
Message-ID: <162635653777192@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4030a6e6a6a4a42ff8c18414c9e0c93e24cc70b8 Mon Sep 17 00:00:00 2001
From: Paul Burton <paulburton@google.com>
Date: Thu, 1 Jul 2021 10:24:07 -0700
Subject: [PATCH] tracing: Resize tgid_map to pid_max, not PID_MAX_DEFAULT

Currently tgid_map is sized at PID_MAX_DEFAULT entries, which means that
on systems where pid_max is configured higher than PID_MAX_DEFAULT the
ftrace record-tgid option doesn't work so well. Any tasks with PIDs
higher than PID_MAX_DEFAULT are simply not recorded in tgid_map, and
don't show up in the saved_tgids file.

In particular since systemd v243 & above configure pid_max to its
highest possible 1<<22 value by default on 64 bit systems this renders
the record-tgids option of little use.

Increase the size of tgid_map to the configured pid_max instead,
allowing it to cover the full range of PIDs up to the maximum value of
PID_MAX_LIMIT if the system is configured that way.

On 64 bit systems with pid_max == PID_MAX_LIMIT this will increase the
size of tgid_map from 256KiB to 16MiB. Whilst this 64x increase in
memory overhead sounds significant 64 bit systems are presumably best
placed to accommodate it, and since tgid_map is only allocated when the
record-tgid option is actually used presumably the user would rather it
spends sufficient memory to actually record the tgids they expect.

The size of tgid_map could also increase for CONFIG_BASE_SMALL=y
configurations, but these seem unlikely to be systems upon which people
are both configuring a large pid_max and running ftrace with record-tgid
anyway.

Of note is that we only allocate tgid_map once, the first time that the
record-tgid option is enabled. Therefore its size is only set once, to
the value of pid_max at the time the record-tgid option is first
enabled. If a user increases pid_max after that point, the saved_tgids
file will not contain entries for any tasks with pids beyond the earlier
value of pid_max.

Link: https://lkml.kernel.org/r/20210701172407.889626-2-paulburton@google.com

Fixes: d914ba37d714 ("tracing: Add support for recording tgid of tasks")
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Joel Fernandes <joelaf@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Paul Burton <paulburton@google.com>
[ Fixed comment coding style ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 4843076d67d3..14f56e9fa001 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2191,8 +2191,15 @@ void tracing_reset_all_online_cpus(void)
 	}
 }
 
+/*
+ * The tgid_map array maps from pid to tgid; i.e. the value stored at index i
+ * is the tgid last observed corresponding to pid=i.
+ */
 static int *tgid_map;
 
+/* The maximum valid index into tgid_map. */
+static size_t tgid_map_max;
+
 #define SAVED_CMDLINES_DEFAULT 128
 #define NO_CMDLINE_MAP UINT_MAX
 static arch_spinlock_t trace_cmdline_lock = __ARCH_SPIN_LOCK_UNLOCKED;
@@ -2468,24 +2475,41 @@ void trace_find_cmdline(int pid, char comm[])
 	preempt_enable();
 }
 
+static int *trace_find_tgid_ptr(int pid)
+{
+	/*
+	 * Pairs with the smp_store_release in set_tracer_flag() to ensure that
+	 * if we observe a non-NULL tgid_map then we also observe the correct
+	 * tgid_map_max.
+	 */
+	int *map = smp_load_acquire(&tgid_map);
+
+	if (unlikely(!map || pid > tgid_map_max))
+		return NULL;
+
+	return &map[pid];
+}
+
 int trace_find_tgid(int pid)
 {
-	if (unlikely(!tgid_map || !pid || pid > PID_MAX_DEFAULT))
-		return 0;
+	int *ptr = trace_find_tgid_ptr(pid);
 
-	return tgid_map[pid];
+	return ptr ? *ptr : 0;
 }
 
 static int trace_save_tgid(struct task_struct *tsk)
 {
+	int *ptr;
+
 	/* treat recording of idle task as a success */
 	if (!tsk->pid)
 		return 1;
 
-	if (unlikely(!tgid_map || tsk->pid > PID_MAX_DEFAULT))
+	ptr = trace_find_tgid_ptr(tsk->pid);
+	if (!ptr)
 		return 0;
 
-	tgid_map[tsk->pid] = tsk->tgid;
+	*ptr = tsk->tgid;
 	return 1;
 }
 
@@ -5225,6 +5249,8 @@ int trace_keep_overwrite(struct tracer *tracer, u32 mask, int set)
 
 int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
 {
+	int *map;
+
 	if ((mask == TRACE_ITER_RECORD_TGID) ||
 	    (mask == TRACE_ITER_RECORD_CMD))
 		lockdep_assert_held(&event_mutex);
@@ -5247,10 +5273,19 @@ int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
 		trace_event_enable_cmd_record(enabled);
 
 	if (mask == TRACE_ITER_RECORD_TGID) {
-		if (!tgid_map)
-			tgid_map = kvcalloc(PID_MAX_DEFAULT + 1,
-					   sizeof(*tgid_map),
-					   GFP_KERNEL);
+		if (!tgid_map) {
+			tgid_map_max = pid_max;
+			map = kvcalloc(tgid_map_max + 1, sizeof(*tgid_map),
+				       GFP_KERNEL);
+
+			/*
+			 * Pairs with smp_load_acquire() in
+			 * trace_find_tgid_ptr() to ensure that if it observes
+			 * the tgid_map we just allocated then it also observes
+			 * the corresponding tgid_map_max value.
+			 */
+			smp_store_release(&tgid_map, map);
+		}
 		if (!tgid_map) {
 			tr->trace_flags &= ~TRACE_ITER_RECORD_TGID;
 			return -ENOMEM;
@@ -5664,18 +5699,14 @@ static void *saved_tgids_next(struct seq_file *m, void *v, loff_t *pos)
 {
 	int pid = ++(*pos);
 
-	if (pid > PID_MAX_DEFAULT)
-		return NULL;
-
-	return &tgid_map[pid];
+	return trace_find_tgid_ptr(pid);
 }
 
 static void *saved_tgids_start(struct seq_file *m, loff_t *pos)
 {
-	if (!tgid_map || *pos > PID_MAX_DEFAULT)
-		return NULL;
+	int pid = *pos;
 
-	return &tgid_map[*pos];
+	return trace_find_tgid_ptr(pid);
 }
 
 static void saved_tgids_stop(struct seq_file *m, void *v)

