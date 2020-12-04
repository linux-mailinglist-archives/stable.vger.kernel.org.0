Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7A512CE74A
	for <lists+stable@lfdr.de>; Fri,  4 Dec 2020 06:08:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727805AbgLDFHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 00:07:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43918 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726485AbgLDFHx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Dec 2020 00:07:53 -0500
From:   Andy Lutomirski <luto@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     x86@kernel.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Anton Blanchard <anton@ozlabs.org>,
        Andy Lutomirski <luto@kernel.org>, stable@vger.kernel.org
Subject: [PATCH v3 4/4] membarrier: Execute SYNC_CORE on the calling thread
Date:   Thu,  3 Dec 2020 21:07:06 -0800
Message-Id: <250ded637696d490c69bef1877148db86066881c.1607058304.git.luto@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <cover.1607058304.git.luto@kernel.org>
References: <cover.1607058304.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

membarrier()'s MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE is documented
as syncing the core on all sibling threads but not necessarily the
calling thread.  This behavior is fundamentally buggy and cannot be used
safely.  Suppose a user program has two threads.  Thread A is on CPU 0
and thread B is on CPU 1.  Thread A modifies some text and calls
membarrier(MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE).  Then thread B
executes the modified code.  If, at any point after membarrier() decides
which CPUs to target, thread A could be preempted and replaced by thread
B on CPU 0.  This could even happen on exit from the membarrier()
syscall.  If this happens, thread B will end up running on CPU 0 without
having synced.

In principle, this could be fixed by arranging for the scheduler to
sync_core_before_usermode() whenever switching between two threads in
the same mm if there is any possibility of a concurrent membarrier()
call, but this would have considerable overhead.  Instead, make
membarrier() sync the calling CPU as well.

As an optimization, this avoids an extra smp_mb() in the default
barrier-only mode.

Cc: stable@vger.kernel.org
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 kernel/sched/membarrier.c | 51 +++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/kernel/sched/membarrier.c b/kernel/sched/membarrier.c
index 01538b31f27e..57266ab32ef9 100644
--- a/kernel/sched/membarrier.c
+++ b/kernel/sched/membarrier.c
@@ -333,7 +333,8 @@ static int membarrier_private_expedited(int flags, int cpu_id)
 			return -EPERM;
 	}
 
-	if (atomic_read(&mm->mm_users) == 1 || num_online_cpus() == 1)
+	if (flags != MEMBARRIER_FLAG_SYNC_CORE &&
+	    (atomic_read(&mm->mm_users) == 1 || num_online_cpus() == 1))
 		return 0;
 
 	/*
@@ -352,8 +353,6 @@ static int membarrier_private_expedited(int flags, int cpu_id)
 
 		if (cpu_id >= nr_cpu_ids || !cpu_online(cpu_id))
 			goto out;
-		if (cpu_id == raw_smp_processor_id())
-			goto out;
 		rcu_read_lock();
 		p = rcu_dereference(cpu_rq(cpu_id)->curr);
 		if (!p || p->mm != mm) {
@@ -368,16 +367,6 @@ static int membarrier_private_expedited(int flags, int cpu_id)
 		for_each_online_cpu(cpu) {
 			struct task_struct *p;
 
-			/*
-			 * Skipping the current CPU is OK even through we can be
-			 * migrated at any point. The current CPU, at the point
-			 * where we read raw_smp_processor_id(), is ensured to
-			 * be in program order with respect to the caller
-			 * thread. Therefore, we can skip this CPU from the
-			 * iteration.
-			 */
-			if (cpu == raw_smp_processor_id())
-				continue;
 			p = rcu_dereference(cpu_rq(cpu)->curr);
 			if (p && p->mm == mm)
 				__cpumask_set_cpu(cpu, tmpmask);
@@ -385,12 +374,38 @@ static int membarrier_private_expedited(int flags, int cpu_id)
 		rcu_read_unlock();
 	}
 
-	preempt_disable();
-	if (cpu_id >= 0)
+	if (cpu_id >= 0) {
+		/*
+		 * smp_call_function_single() will call ipi_func() if cpu_id
+		 * is the calling CPU.
+		 */
 		smp_call_function_single(cpu_id, ipi_func, NULL, 1);
-	else
-		smp_call_function_many(tmpmask, ipi_func, NULL, 1);
-	preempt_enable();
+	} else {
+		/*
+		 * For regular membarrier, we can save a few cycles by
+		 * skipping the current cpu -- we're about to do smp_mb()
+		 * below, and if we migrate to a different cpu, this cpu
+		 * and the new cpu will execute a full barrier in the
+		 * scheduler.
+		 *
+		 * For CORE_SYNC, we do need a barrier on the current cpu --
+		 * otherwise, if we are migrated and replaced by a different
+		 * task in the same mm just before, during, or after
+		 * membarrier, we will end up with some thread in the mm
+		 * running without a core sync.
+		 *
+		 * For RSEQ, don't rseq_preempt() the caller.  User code
+		 * is not supposed to issue syscalls at all from inside an
+		 * rseq critical section.
+		 */
+		if (flags != MEMBARRIER_FLAG_SYNC_CORE) {
+			preempt_disable();
+			smp_call_function_many(tmpmask, ipi_func, NULL, true);
+			preempt_enable();
+		} else {
+			on_each_cpu_mask(tmpmask, ipi_func, NULL, true);
+		}
+	}
 
 out:
 	if (cpu_id < 0)
-- 
2.28.0

