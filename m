Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44A6D38A909
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:57:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237505AbhETK4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:56:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238996AbhETKyW (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:54:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DE0C61CDA;
        Thu, 20 May 2021 10:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504859;
        bh=av9DmjoebbTWUF7CYq7cByhOureQOC3Y9LAAXT9fEeg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l5hi598eSgShzQVOQS5IIf8OuWxp5LUgAyWesRtEdfaKYvgZeqs3kx7wTKfz3CbuF
         CBC97sUNg+OHiYsEbjqqu1m6F6C5hEnWwtYSEB7ZeXZsi5xbvMUlcjZumPXlPdg1cF
         YzHE3wS2l97MO/36oTqUHGJWbmj05PVbxbmw7jo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 4.9 078/240] tracing: Map all PIDs to command lines
Date:   Thu, 20 May 2021 11:21:10 +0200
Message-Id: <20210520092111.300407392@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092108.587553970@linuxfoundation.org>
References: <20210520092108.587553970@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Rostedt (VMware) <rostedt@goodmis.org>

commit 785e3c0a3a870e72dc530856136ab4c8dd207128 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   41 +++++++++++++++--------------------------
 1 file changed, 15 insertions(+), 26 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1809,14 +1809,13 @@ void trace_stop_cmdline_recording(void);
 
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
@@ -1827,26 +1826,15 @@ static int trace_save_cmdline(struct tas
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
@@ -1857,6 +1845,7 @@ static int trace_save_cmdline(struct tas
 static void __trace_find_cmdline(int pid, char comm[])
 {
 	unsigned map;
+	int tpid;
 
 	if (!pid) {
 		strcpy(comm, "<idle>");
@@ -1868,16 +1857,16 @@ static void __trace_find_cmdline(int pid
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


