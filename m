Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67051491486
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233904AbiARCXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:23:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244774AbiARCVf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:21:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D894C06175F;
        Mon, 17 Jan 2022 18:21:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8AF7612EE;
        Tue, 18 Jan 2022 02:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2718FC36AE3;
        Tue, 18 Jan 2022 02:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472494;
        bh=SfqMuc3aiXwjjvVxKLQUhZJjbDkbq19eOpNOriETP+g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gJ3hdjv7v5BUEiZuopHZKe34PYbsDw4sFHJDOHBGJhoLT9lTiPMNB11kU/sQ4vk5+
         cyHXcW/WOZ20XKIb2+zXD3QiKw43hh4qv5ac3enhCgK0tN5SGfNBGMlXghHcfzqwZA
         iQMGaBMaENSg8ktGL2LsVrzTjRWNJiXiBHukGb+Z4OKKlBa603fs2p/ww/Kgp5fXOI
         hgeD4UDyC5TazKwVcpCQmxRWkfSZvEWDq69gP5PhAuVROyodXcQg6BSOmL1Xqh4dTG
         VTxGubr2xuETuEYNBqD47thKUkhbIDmpEesI0QzrcFceLL+rjhM++PSS7xH1+x0hq1
         pbiaJXM7wVwuA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Brian Chen <brianchen118@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sasha Levin <sashal@kernel.org>, mingo@redhat.com,
        juri.lelli@redhat.com, vincent.guittot@linaro.org
Subject: [PATCH AUTOSEL 5.16 032/217] psi: Fix PSI_MEM_FULL state when tasks are in memstall and doing reclaim
Date:   Mon, 17 Jan 2022 21:16:35 -0500
Message-Id: <20220118021940.1942199-32-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian Chen <brianchen118@gmail.com>

[ Upstream commit cb0e52b7748737b2cf6481fdd9b920ce7e1ebbdf ]

We've noticed cases where tasks in a cgroup are stalled on memory but
there is little memory FULL pressure since tasks stay on the runqueue
in reclaim.

A simple example involves a single threaded program that keeps leaking
and touching large amounts of memory. It runs in a cgroup with swap
enabled, memory.high set at 10M and cpu.max ratio set at 5%. Though
there is significant CPU pressure and memory SOME, there is barely any
memory FULL since the task enters reclaim and stays on the runqueue.
However, this memory-bound task is effectively stalled on memory and
we expect memory FULL to match memory SOME in this scenario.

The code is confused about memstall && running, thinking there is a
stalled task and a productive task when there's only one task: a
reclaimer that's counted as both. To fix this, we redefine the
condition for PSI_MEM_FULL to check that all running tasks are in an
active memstall instead of checking that there are no running tasks.

        case PSI_MEM_FULL:
-               return unlikely(tasks[NR_MEMSTALL] && !tasks[NR_RUNNING]);
+               return unlikely(tasks[NR_MEMSTALL] &&
+                       tasks[NR_RUNNING] == tasks[NR_MEMSTALL_RUNNING]);

This will capture reclaimers. It will also capture tasks that called
psi_memstall_enter() and are about to sleep, but this should be
negligible noise.

Signed-off-by: Brian Chen <brianchen118@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Link: https://lore.kernel.org/r/20211110213312.310243-1-brianchen118@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/psi_types.h | 13 ++++++++++-
 kernel/sched/psi.c        | 45 ++++++++++++++++++++++++---------------
 kernel/sched/stats.h      |  5 ++++-
 3 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
index 0a23300d49af7..0819c82dba920 100644
--- a/include/linux/psi_types.h
+++ b/include/linux/psi_types.h
@@ -21,7 +21,17 @@ enum psi_task_count {
 	 * don't have to special case any state tracking for it.
 	 */
 	NR_ONCPU,
-	NR_PSI_TASK_COUNTS = 4,
+	/*
+	 * For IO and CPU stalls the presence of running/oncpu tasks
+	 * in the domain means a partial rather than a full stall.
+	 * For memory it's not so simple because of page reclaimers:
+	 * they are running/oncpu while representing a stall. To tell
+	 * whether a domain has productivity left or not, we need to
+	 * distinguish between regular running (i.e. productive)
+	 * threads and memstall ones.
+	 */
+	NR_MEMSTALL_RUNNING,
+	NR_PSI_TASK_COUNTS = 5,
 };
 
 /* Task state bitmasks */
@@ -29,6 +39,7 @@ enum psi_task_count {
 #define TSK_MEMSTALL	(1 << NR_MEMSTALL)
 #define TSK_RUNNING	(1 << NR_RUNNING)
 #define TSK_ONCPU	(1 << NR_ONCPU)
+#define TSK_MEMSTALL_RUNNING	(1 << NR_MEMSTALL_RUNNING)
 
 /* Resources that workloads could be stalled on */
 enum psi_res {
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 1652f2bb54b79..69b19d3af690f 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -34,13 +34,19 @@
  * delayed on that resource such that nobody is advancing and the CPU
  * goes idle. This leaves both workload and CPU unproductive.
  *
- * Naturally, the FULL state doesn't exist for the CPU resource at the
- * system level, but exist at the cgroup level, means all non-idle tasks
- * in a cgroup are delayed on the CPU resource which used by others outside
- * of the cgroup or throttled by the cgroup cpu.max configuration.
- *
  *	SOME = nr_delayed_tasks != 0
- *	FULL = nr_delayed_tasks != 0 && nr_running_tasks == 0
+ *	FULL = nr_delayed_tasks != 0 && nr_productive_tasks == 0
+ *
+ * What it means for a task to be productive is defined differently
+ * for each resource. For IO, productive means a running task. For
+ * memory, productive means a running task that isn't a reclaimer. For
+ * CPU, productive means an oncpu task.
+ *
+ * Naturally, the FULL state doesn't exist for the CPU resource at the
+ * system level, but exist at the cgroup level. At the cgroup level,
+ * FULL means all non-idle tasks in the cgroup are delayed on the CPU
+ * resource which is being used by others outside of the cgroup or
+ * throttled by the cgroup cpu.max configuration.
  *
  * The percentage of wallclock time spent in those compound stall
  * states gives pressure numbers between 0 and 100 for each resource,
@@ -81,13 +87,13 @@
  *
  *	threads = min(nr_nonidle_tasks, nr_cpus)
  *	   SOME = min(nr_delayed_tasks / threads, 1)
- *	   FULL = (threads - min(nr_running_tasks, threads)) / threads
+ *	   FULL = (threads - min(nr_productive_tasks, threads)) / threads
  *
  * For the 257 number crunchers on 256 CPUs, this yields:
  *
  *	threads = min(257, 256)
  *	   SOME = min(1 / 256, 1)             = 0.4%
- *	   FULL = (256 - min(257, 256)) / 256 = 0%
+ *	   FULL = (256 - min(256, 256)) / 256 = 0%
  *
  * For the 1 out of 4 memory-delayed tasks, this yields:
  *
@@ -112,7 +118,7 @@
  * For each runqueue, we track:
  *
  *	   tSOME[cpu] = time(nr_delayed_tasks[cpu] != 0)
- *	   tFULL[cpu] = time(nr_delayed_tasks[cpu] && !nr_running_tasks[cpu])
+ *	   tFULL[cpu] = time(nr_delayed_tasks[cpu] && !nr_productive_tasks[cpu])
  *	tNONIDLE[cpu] = time(nr_nonidle_tasks[cpu] != 0)
  *
  * and then periodically aggregate:
@@ -233,7 +239,8 @@ static bool test_state(unsigned int *tasks, enum psi_states state)
 	case PSI_MEM_SOME:
 		return unlikely(tasks[NR_MEMSTALL]);
 	case PSI_MEM_FULL:
-		return unlikely(tasks[NR_MEMSTALL] && !tasks[NR_RUNNING]);
+		return unlikely(tasks[NR_MEMSTALL] &&
+			tasks[NR_RUNNING] == tasks[NR_MEMSTALL_RUNNING]);
 	case PSI_CPU_SOME:
 		return unlikely(tasks[NR_RUNNING] > tasks[NR_ONCPU]);
 	case PSI_CPU_FULL:
@@ -710,10 +717,11 @@ static void psi_group_change(struct psi_group *group, int cpu,
 		if (groupc->tasks[t]) {
 			groupc->tasks[t]--;
 		} else if (!psi_bug) {
-			printk_deferred(KERN_ERR "psi: task underflow! cpu=%d t=%d tasks=[%u %u %u %u] clear=%x set=%x\n",
+			printk_deferred(KERN_ERR "psi: task underflow! cpu=%d t=%d tasks=[%u %u %u %u %u] clear=%x set=%x\n",
 					cpu, t, groupc->tasks[0],
 					groupc->tasks[1], groupc->tasks[2],
-					groupc->tasks[3], clear, set);
+					groupc->tasks[3], groupc->tasks[4],
+					clear, set);
 			psi_bug = 1;
 		}
 	}
@@ -854,12 +862,15 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
 		int clear = TSK_ONCPU, set = 0;
 
 		/*
-		 * When we're going to sleep, psi_dequeue() lets us handle
-		 * TSK_RUNNING and TSK_IOWAIT here, where we can combine it
-		 * with TSK_ONCPU and save walking common ancestors twice.
+		 * When we're going to sleep, psi_dequeue() lets us
+		 * handle TSK_RUNNING, TSK_MEMSTALL_RUNNING and
+		 * TSK_IOWAIT here, where we can combine it with
+		 * TSK_ONCPU and save walking common ancestors twice.
 		 */
 		if (sleep) {
 			clear |= TSK_RUNNING;
+			if (prev->in_memstall)
+				clear |= TSK_MEMSTALL_RUNNING;
 			if (prev->in_iowait)
 				set |= TSK_IOWAIT;
 		}
@@ -908,7 +919,7 @@ void psi_memstall_enter(unsigned long *flags)
 	rq = this_rq_lock_irq(&rf);
 
 	current->in_memstall = 1;
-	psi_task_change(current, 0, TSK_MEMSTALL);
+	psi_task_change(current, 0, TSK_MEMSTALL | TSK_MEMSTALL_RUNNING);
 
 	rq_unlock_irq(rq, &rf);
 }
@@ -937,7 +948,7 @@ void psi_memstall_leave(unsigned long *flags)
 	rq = this_rq_lock_irq(&rf);
 
 	current->in_memstall = 0;
-	psi_task_change(current, TSK_MEMSTALL, 0);
+	psi_task_change(current, TSK_MEMSTALL | TSK_MEMSTALL_RUNNING, 0);
 
 	rq_unlock_irq(rq, &rf);
 }
diff --git a/kernel/sched/stats.h b/kernel/sched/stats.h
index cfb0893a83d45..3a3c826dd83a7 100644
--- a/kernel/sched/stats.h
+++ b/kernel/sched/stats.h
@@ -118,6 +118,9 @@ static inline void psi_enqueue(struct task_struct *p, bool wakeup)
 	if (static_branch_likely(&psi_disabled))
 		return;
 
+	if (p->in_memstall)
+		set |= TSK_MEMSTALL_RUNNING;
+
 	if (!wakeup || p->sched_psi_wake_requeue) {
 		if (p->in_memstall)
 			set |= TSK_MEMSTALL;
@@ -148,7 +151,7 @@ static inline void psi_dequeue(struct task_struct *p, bool sleep)
 		return;
 
 	if (p->in_memstall)
-		clear |= TSK_MEMSTALL;
+		clear |= (TSK_MEMSTALL | TSK_MEMSTALL_RUNNING);
 
 	psi_task_change(p, clear, 0);
 }
-- 
2.34.1

