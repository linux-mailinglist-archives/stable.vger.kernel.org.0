Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC8A45BE48
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244455AbhKXMqL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:46:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:50528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345748AbhKXMoG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:44:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0153E61250;
        Wed, 24 Nov 2021 12:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756768;
        bh=2NLdfpJ5IQdSA6EvccIBEiaYn7yUicCVP71I+nke8wo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yv8TtSEjSfxp8sBgvGRciaNFfdQeigSQrlz0aYL/A6CfddPULYoKNb8IqkLMznXyW
         TS/WqjNNwsFBTz8R7FiUQjr6MXIalLNf4kLMaNK8L0skshtKLBS6/sTKGB5q4Ra2XF
         y7CZLEqTLhmMxuJFKRvHDKWQnD7ln/V7YqDCt8p4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Joel Fernandes <joelaf@google.com>,
        Paul Burton <paulburton@google.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.14 199/251] tracing: Resize tgid_map to pid_max, not PID_MAX_DEFAULT
Date:   Wed, 24 Nov 2021 12:57:21 +0100
Message-Id: <20211124115717.182800413@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paulburton@google.com>

commit 4030a6e6a6a4a42ff8c18414c9e0c93e24cc70b8 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace.c |   62 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 15 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1723,8 +1723,15 @@ void tracing_reset_all_online_cpus(void)
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
@@ -1996,24 +2003,41 @@ void trace_find_cmdline(int pid, char co
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
 
@@ -4353,6 +4377,8 @@ int trace_keep_overwrite(struct tracer *
 
 int set_tracer_flag(struct trace_array *tr, unsigned int mask, int enabled)
 {
+	int *map;
+
 	if ((mask == TRACE_ITER_RECORD_TGID) ||
 	    (mask == TRACE_ITER_RECORD_CMD))
 		lockdep_assert_held(&event_mutex);
@@ -4375,9 +4401,19 @@ int set_tracer_flag(struct trace_array *
 		trace_event_enable_cmd_record(enabled);
 
 	if (mask == TRACE_ITER_RECORD_TGID) {
-		if (!tgid_map)
-			tgid_map = kzalloc((PID_MAX_DEFAULT + 1) * sizeof(*tgid_map),
-					   GFP_KERNEL);
+		if (!tgid_map) {
+			tgid_map_max = pid_max;
+			map = kzalloc((tgid_map_max + 1) * sizeof(*tgid_map),
+				      GFP_KERNEL);
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
@@ -4752,18 +4788,14 @@ static void *saved_tgids_next(struct seq
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


