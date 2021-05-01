Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A597737045E
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 02:27:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbhEAA1w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 20:27:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:51296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230226AbhEAA1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 20:27:51 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E243A61407;
        Sat,  1 May 2021 00:27:02 +0000 (UTC)
Received: from rostedt by gandalf.local.home with local (Exim 4.94)
        (envelope-from <rostedt@goodmis.org>)
        id 1lcdTJ-008tDa-V2; Fri, 30 Apr 2021 20:27:01 -0400
Message-ID: <20210501002701.802048464@goodmis.org>
User-Agent: quilt/0.66
Date:   Fri, 30 Apr 2021 20:26:26 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [for-next][PATCH 1/2] tracing: Map all PIDs to command lines
References: <20210501002625.540979896@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

The default max PID is set by PID_MAX_DEFAULT, and the tracing
infrastructure uses this number to map PIDs to the comm names of the
tasks, such output of the trace can show names from the recorded PIDs in
the ring buffer. This mapping is also exported to user space via the
"saved_cmdlines" file in the tracefs directory.

But currently the mapping expects the PIDs to be less than
PID_MAX_DEFAULT, which is the default maximum and not the real maximum.
Recently, systemd will increases the maximum value of a PID on the system,
and when tasks are traced that have a PID higher than PID_MAX_DEFAULT, its
comm is not recorded. This leads to the entire trace to have "<...>" as
the comm name, which is pretty useless.

Instead, keep the array mapping the size of PID_MAX_DEFAULT, but instead
of just mapping the index to the comm, map a mask of the PID
(PID_MAX_DEFAULT - 1) to the comm, and find the full PID from the
map_cmdline_to_pid array (that already exists).

This bug goes back to the beginning of ftrace, but hasn't been an issue
until user space started increasing the maximum value of PIDs.

Link: https://lkml.kernel.org/r/20210427113207.3c601884@gandalf.local.home

Cc: stable@vger.kernel.org
Fixes: bc0c38d139ec7 ("ftrace: latency tracer infrastructure")
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
---
 kernel/trace/trace.c | 41 +++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 66a4ad93b5e9..e28d08905124 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2390,14 +2390,13 @@ static void tracing_stop_tr(struct trace_array *tr)
 
 static int trace_save_cmdline(struct task_struct *tsk)
 {
-	unsigned pid, idx;
+	unsigned tpid, idx;
 
 	/* treat recording of idle task as a success */
 	if (!tsk->pid)
 		return 1;
 
-	if (unlikely(tsk->pid > PID_MAX_DEFAULT))
-		return 0;
+	tpid = tsk->pid & (PID_MAX_DEFAULT - 1);
 
 	/*
 	 * It's not the end of the world if we don't get
@@ -2408,26 +2407,15 @@ static int trace_save_cmdline(struct task_struct *tsk)
 	if (!arch_spin_trylock(&trace_cmdline_lock))
 		return 0;
 
-	idx = savedcmd->map_pid_to_cmdline[tsk->pid];
+	idx = savedcmd->map_pid_to_cmdline[tpid];
 	if (idx == NO_CMDLINE_MAP) {
 		idx = (savedcmd->cmdline_idx + 1) % savedcmd->cmdline_num;
 
-		/*
-		 * Check whether the cmdline buffer at idx has a pid
-		 * mapped. We are going to overwrite that entry so we
-		 * need to clear the map_pid_to_cmdline. Otherwise we
-		 * would read the new comm for the old pid.
-		 */
-		pid = savedcmd->map_cmdline_to_pid[idx];
-		if (pid != NO_CMDLINE_MAP)
-			savedcmd->map_pid_to_cmdline[pid] = NO_CMDLINE_MAP;
-
-		savedcmd->map_cmdline_to_pid[idx] = tsk->pid;
-		savedcmd->map_pid_to_cmdline[tsk->pid] = idx;
-
+		savedcmd->map_pid_to_cmdline[tpid] = idx;
 		savedcmd->cmdline_idx = idx;
 	}
 
+	savedcmd->map_cmdline_to_pid[idx] = tsk->pid;
 	set_cmdline(idx, tsk->comm);
 
 	arch_spin_unlock(&trace_cmdline_lock);
@@ -2438,6 +2426,7 @@ static int trace_save_cmdline(struct task_struct *tsk)
 static void __trace_find_cmdline(int pid, char comm[])
 {
 	unsigned map;
+	int tpid;
 
 	if (!pid) {
 		strcpy(comm, "<idle>");
@@ -2449,16 +2438,16 @@ static void __trace_find_cmdline(int pid, char comm[])
 		return;
 	}
 
-	if (pid > PID_MAX_DEFAULT) {
-		strcpy(comm, "<...>");
-		return;
+	tpid = pid & (PID_MAX_DEFAULT - 1);
+	map = savedcmd->map_pid_to_cmdline[tpid];
+	if (map != NO_CMDLINE_MAP) {
+		tpid = savedcmd->map_cmdline_to_pid[map];
+		if (tpid == pid) {
+			strlcpy(comm, get_saved_cmdlines(map), TASK_COMM_LEN);
+			return;
+		}
 	}
-
-	map = savedcmd->map_pid_to_cmdline[pid];
-	if (map != NO_CMDLINE_MAP)
-		strlcpy(comm, get_saved_cmdlines(map), TASK_COMM_LEN);
-	else
-		strcpy(comm, "<...>");
+	strcpy(comm, "<...>");
 }
 
 void trace_find_cmdline(int pid, char comm[])
-- 
2.30.1


