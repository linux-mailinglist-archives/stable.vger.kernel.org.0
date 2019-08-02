Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF697F32A
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406431AbfHBJyY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:54:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:60914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406433AbfHBJyX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:54:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2BC222064A;
        Fri,  2 Aug 2019 09:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739662;
        bh=1zaRJ0PSqFj4MBSHcHO/rf7/p9uaM/nj57iaOmBpCzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tW6wSFHM2ONlkWhoOjskwgEakORVYS182wwa7BLQKaVuKUWanWuZE0dkBUFMauqhC
         1fL6TG5tvydr/T+qjg2glusw/lRSMZpDlOPkHgDut+v8p2LYEOuAH+NEkg3sLy06nw
         b7DwW+Sz/jQBWmdkzJqWl15DL3y2k1SV9GMa4nug=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Petr Mladek <pmladek@suse.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 4.14 21/25] sched/fair: Dont free p->numa_faults with concurrent readers
Date:   Fri,  2 Aug 2019 11:39:53 +0200
Message-Id: <20190802092106.472311427@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092058.428079740@linuxfoundation.org>
References: <20190802092058.428079740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/exec.c                            |    2 +-
 include/linux/sched/numa_balancing.h |    4 ++--
 kernel/fork.c                        |    2 +-
 kernel/sched/fair.c                  |   24 ++++++++++++++++++++----
 4 files changed, 24 insertions(+), 8 deletions(-)

--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1808,7 +1808,7 @@ static int do_execveat_common(int fd, st
 	current->in_execve = 0;
 	membarrier_execve(current);
 	acct_update_integrals(current);
-	task_numa_free(current);
+	task_numa_free(current, false);
 	free_bprm(bprm);
 	kfree(pathbuf);
 	putname(filename);
--- a/include/linux/sched/numa_balancing.h
+++ b/include/linux/sched/numa_balancing.h
@@ -19,7 +19,7 @@
 extern void task_numa_fault(int last_node, int node, int pages, int flags);
 extern pid_t task_numa_group_id(struct task_struct *p);
 extern void set_numabalancing_state(bool enabled);
-extern void task_numa_free(struct task_struct *p);
+extern void task_numa_free(struct task_struct *p, bool final);
 extern bool should_numa_migrate_memory(struct task_struct *p, struct page *page,
 					int src_nid, int dst_cpu);
 #else
@@ -34,7 +34,7 @@ static inline pid_t task_numa_group_id(s
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
@@ -415,7 +415,7 @@ void __put_task_struct(struct task_struc
 	WARN_ON(tsk == current);
 
 	cgroup_free(tsk);
-	task_numa_free(tsk);
+	task_numa_free(tsk, true);
 	security_task_free(tsk);
 	exit_creds(tsk);
 	delayacct_tsk_free(tsk);
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2358,13 +2358,23 @@ no_join:
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
-	void *numa_faults = p->numa_faults;
+	unsigned long *numa_faults = p->numa_faults;
 	unsigned long flags;
 	int i;
 
+	if (!numa_faults)
+		return;
+
 	if (grp) {
 		spin_lock_irqsave(&grp->lock, flags);
 		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
@@ -2377,8 +2387,14 @@ void task_numa_free(struct task_struct *
 		put_numa_group(grp);
 	}
 
-	p->numa_faults = NULL;
-	kfree(numa_faults);
+	if (final) {
+		p->numa_faults = NULL;
+		kfree(numa_faults);
+	} else {
+		p->total_numa_faults = 0;
+		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
+			numa_faults[i] = 0;
+	}
 }
 
 /*


