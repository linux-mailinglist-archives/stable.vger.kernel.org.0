Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8701C103F0A
	for <lists+stable@lfdr.de>; Wed, 20 Nov 2019 16:41:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731918AbfKTPkZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Nov 2019 10:40:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53346 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731906AbfKTPkZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Nov 2019 10:40:25 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5T-0004ZS-H7; Wed, 20 Nov 2019 15:40:11 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iXS5S-0004GE-Qv; Wed, 20 Nov 2019 15:40:10 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Will Deacon" <will@kernel.org>, "Petr Mladek" <pmladek@suse.com>,
        "Jann Horn" <jannh@google.com>, "Ingo Molnar" <mingo@kernel.org>,
        "Sergey Senozhatsky" <sergey.senozhatsky@gmail.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>
Date:   Wed, 20 Nov 2019 15:37:20 +0000
Message-ID: <lsq.1574264230.654885483@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 10/83] sched/fair: Don't free p->numa_faults with
 concurrent readers
In-Reply-To: <lsq.1574264230.280218497@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.78-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

commit 16d51a590a8ce3befb1308e0e7ab77f3b661af33 upstream.

When going through execve(), zero out the NUMA fault statistics instead of
freeing them.

During execve, the task is reachable through procfs and the scheduler. A
concurrent /proc/*/sched reader can read data from a freed ->numa_faults
allocation (confirmed by KASAN) and write it back to userspace.
I believe that it would also be possible for a use-after-free read to occur
through a race between a NUMA fault and execve(): task_numa_fault() can
lead to task_numa_compare(), which invokes task_weight() on the currently
running task of a different CPU.

Another way to fix this would be to make ->numa_faults RCU-managed or add
extra locking, but it seems easier to wipe the NUMA fault statistics on
execve.

Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Will Deacon <will@kernel.org>
Fixes: 82727018b0d3 ("sched/numa: Call task_numa_free() from do_execve()")
Link: https://lkml.kernel.org/r/20190716152047.14424-1-jannh@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.16: adjust filename, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1589,7 +1589,7 @@ static int do_execve_common(struct filen
 	current->fs->in_exec = 0;
 	current->in_execve = 0;
 	acct_update_integrals(current);
-	task_numa_free(current);
+	task_numa_free(current, false);
 	free_bprm(bprm);
 	putname(filename);
 	if (displaced)
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1671,7 +1671,7 @@ struct task_struct {
 extern void task_numa_fault(int last_node, int node, int pages, int flags);
 extern pid_t task_numa_group_id(struct task_struct *p);
 extern void set_numabalancing_state(bool enabled);
-extern void task_numa_free(struct task_struct *p);
+extern void task_numa_free(struct task_struct *p, bool final);
 extern bool should_numa_migrate_memory(struct task_struct *p, struct page *page,
 					int src_nid, int dst_cpu);
 #else
@@ -1686,7 +1686,7 @@ static inline pid_t task_numa_group_id(s
 static inline void set_numabalancing_state(bool enabled)
 {
 }
-static inline void task_numa_free(struct task_struct *p)
+static inline void task_numa_free(struct task_struct *p, bool final)
 {
 }
 static inline bool should_numa_migrate_memory(struct task_struct *p,
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -242,7 +242,7 @@ void __put_task_struct(struct task_struc
 	WARN_ON(atomic_read(&tsk->usage));
 	WARN_ON(tsk == current);
 
-	task_numa_free(tsk);
+	task_numa_free(tsk, true);
 	security_task_free(tsk);
 	exit_creds(tsk);
 	delayacct_tsk_free(tsk);
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1747,13 +1747,23 @@ no_join:
 	return;
 }
 
-void task_numa_free(struct task_struct *p)
+/*
+ * Get rid of NUMA staticstics associated with a task (either current or dead).
+ * If @final is set, the task is dead and has reached refcount zero, so we can
+ * safely free all relevant data structures. Otherwise, there might be
+ * concurrent reads from places like load balancing and procfs, and we should
+ * reset the data back to default state without freeing ->numa_faults.
+ */
+void task_numa_free(struct task_struct *p, bool final)
 {
 	struct numa_group *grp = p->numa_group;
-	void *numa_faults = p->numa_faults_memory;
+	unsigned long *numa_faults = p->numa_faults_memory;
 	unsigned long flags;
 	int i;
 
+	if (!numa_faults)
+		return;
+
 	if (grp) {
 		spin_lock_irqsave(&grp->lock, flags);
 		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
@@ -1767,11 +1777,17 @@ void task_numa_free(struct task_struct *
 		put_numa_group(grp);
 	}
 
-	p->numa_faults_memory = NULL;
-	p->numa_faults_buffer_memory = NULL;
-	p->numa_faults_cpu= NULL;
-	p->numa_faults_buffer_cpu = NULL;
-	kfree(numa_faults);
+	if (final) {
+		p->numa_faults_memory = NULL;
+		p->numa_faults_buffer_memory = NULL;
+		p->numa_faults_cpu = NULL;
+		p->numa_faults_buffer_cpu = NULL;
+		kfree(numa_faults);
+	} else {
+		p->total_numa_faults = 0;
+		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
+			numa_faults[i] = 0;
+	}
 }
 
 /*

