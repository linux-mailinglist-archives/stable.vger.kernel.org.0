Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19FC629B494
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790176AbgJ0PDx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:03:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1790100AbgJ0PDx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:03:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82456206E5;
        Tue, 27 Oct 2020 15:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811031;
        bh=R5rM+2qsqLBnwPM0AM0jcLv2iOyPQ5/YbEo/H0MkcJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmLhifqItylE4glZtGja48m+T260q7yR0NMS+h+oaJ8s8c3D6VTCYJIPc4revchcc
         zvISddhPsHU9ZsBAepOROrNB9END8cSKzqKwXk9t7oumRBmE4StFdRBzAVhFKGGK5x
         NfgwM4mde2CKF6v2nEBryKnems82uqIsvC4arWTQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tim Murray <timmurray@google.com>,
        Michal Hocko <mhocko@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Michal Hocko <mhocko@suse.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eugene Syromiatnikov <esyr@redhat.com>,
        Christian Kellner <christian@kellner.me>,
        Adrian Reber <areber@redhat.com>,
        Shakeel Butt <shakeelb@google.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Gladkov <gladkov.alexey@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Andrei Vagin <avagin@gmail.com>,
        Bernd Edlinger <bernd.edlinger@hotmail.de>,
        John Johansen <john.johansen@canonical.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 5.8 318/633] mm, oom_adj: dont loop through tasks in __set_oom_adj when not necessary
Date:   Tue, 27 Oct 2020 14:51:01 +0100
Message-Id: <20201027135537.591074414@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suren Baghdasaryan <surenb@google.com>

[ Upstream commit 67197a4f28d28d0b073ab0427b03cb2ee5382578 ]

Currently __set_oom_adj loops through all processes in the system to keep
oom_score_adj and oom_score_adj_min in sync between processes sharing
their mm.  This is done for any task with more that one mm_users, which
includes processes with multiple threads (sharing mm and signals).
However for such processes the loop is unnecessary because their signal
structure is shared as well.

Android updates oom_score_adj whenever a tasks changes its role
(background/foreground/...) or binds to/unbinds from a service, making it
more/less important.  Such operation can happen frequently.  We noticed
that updates to oom_score_adj became more expensive and after further
investigation found out that the patch mentioned in "Fixes" introduced a
regression.  Using Pixel 4 with a typical Android workload, write time to
oom_score_adj increased from ~3.57us to ~362us.  Moreover this regression
linearly depends on the number of multi-threaded processes running on the
system.

Mark the mm with a new MMF_MULTIPROCESS flag bit when task is created with
(CLONE_VM && !CLONE_THREAD && !CLONE_VFORK).  Change __set_oom_adj to use
MMF_MULTIPROCESS instead of mm_users to decide whether oom_score_adj
update should be synchronized between multiple processes.  To prevent
races between clone() and __set_oom_adj(), when oom_score_adj of the
process being cloned might be modified from userspace, we use
oom_adj_mutex.  Its scope is changed to global.

The combination of (CLONE_VM && !CLONE_THREAD) is rarely used except for
the case of vfork().  To prevent performance regressions of vfork(), we
skip taking oom_adj_mutex and setting MMF_MULTIPROCESS when CLONE_VFORK is
specified.  Clearing the MMF_MULTIPROCESS flag (when the last process
sharing the mm exits) is left out of this patch to keep it simple and
because it is believed that this threading model is rare.  Should there
ever be a need for optimizing that case as well, it can be done by hooking
into the exit path, likely following the mm_update_next_owner pattern.

With the combination of (CLONE_VM && !CLONE_THREAD && !CLONE_VFORK) being
quite rare, the regression is gone after the change is applied.

[surenb@google.com: v3]
  Link: https://lkml.kernel.org/r/20200902012558.2335613-1-surenb@google.com

Fixes: 44a70adec910 ("mm, oom_adj: make sure processes sharing mm have same view of oom_score_adj")
Reported-by: Tim Murray <timmurray@google.com>
Suggested-by: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Eugene Syromiatnikov <esyr@redhat.com>
Cc: Christian Kellner <christian@kellner.me>
Cc: Adrian Reber <areber@redhat.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc: John Johansen <john.johansen@canonical.com>
Cc: Yafang Shao <laoar.shao@gmail.com>
Link: https://lkml.kernel.org/r/20200824153036.3201505-1-surenb@google.com
Debugged-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/base.c                 |  3 +--
 include/linux/oom.h            |  1 +
 include/linux/sched/coredump.h |  1 +
 kernel/fork.c                  | 21 +++++++++++++++++++++
 mm/oom_kill.c                  |  2 ++
 5 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index d86c0afc8a859..297ff606ae0f6 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1046,7 +1046,6 @@ static ssize_t oom_adj_read(struct file *file, char __user *buf, size_t count,
 
 static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
 {
-	static DEFINE_MUTEX(oom_adj_mutex);
 	struct mm_struct *mm = NULL;
 	struct task_struct *task;
 	int err = 0;
@@ -1086,7 +1085,7 @@ static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
 		struct task_struct *p = find_lock_task_mm(task);
 
 		if (p) {
-			if (atomic_read(&p->mm->mm_users) > 1) {
+			if (test_bit(MMF_MULTIPROCESS, &p->mm->flags)) {
 				mm = p->mm;
 				mmgrab(mm);
 			}
diff --git a/include/linux/oom.h b/include/linux/oom.h
index c696c265f0193..b9df34326772c 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -55,6 +55,7 @@ struct oom_control {
 };
 
 extern struct mutex oom_lock;
+extern struct mutex oom_adj_mutex;
 
 static inline void set_current_oom_origin(void)
 {
diff --git a/include/linux/sched/coredump.h b/include/linux/sched/coredump.h
index ecdc6542070f1..dfd82eab29025 100644
--- a/include/linux/sched/coredump.h
+++ b/include/linux/sched/coredump.h
@@ -72,6 +72,7 @@ static inline int get_dumpable(struct mm_struct *mm)
 #define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
 #define MMF_OOM_VICTIM		25	/* mm is the oom victim */
 #define MMF_OOM_REAP_QUEUED	26	/* mm was queued for oom_reaper */
+#define MMF_MULTIPROCESS	27	/* mm is shared between processes */
 #define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
diff --git a/kernel/fork.c b/kernel/fork.c
index efc5493203ae0..0074bbe8c66f1 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1830,6 +1830,25 @@ static __always_inline void delayed_free_task(struct task_struct *tsk)
 		free_task(tsk);
 }
 
+static void copy_oom_score_adj(u64 clone_flags, struct task_struct *tsk)
+{
+	/* Skip if kernel thread */
+	if (!tsk->mm)
+		return;
+
+	/* Skip if spawning a thread or using vfork */
+	if ((clone_flags & (CLONE_VM | CLONE_THREAD | CLONE_VFORK)) != CLONE_VM)
+		return;
+
+	/* We need to synchronize with __set_oom_adj */
+	mutex_lock(&oom_adj_mutex);
+	set_bit(MMF_MULTIPROCESS, &tsk->mm->flags);
+	/* Update the values in case they were changed after copy_signal */
+	tsk->signal->oom_score_adj = current->signal->oom_score_adj;
+	tsk->signal->oom_score_adj_min = current->signal->oom_score_adj_min;
+	mutex_unlock(&oom_adj_mutex);
+}
+
 /*
  * This creates a new process as a copy of the old one,
  * but does not actually start it yet.
@@ -2310,6 +2329,8 @@ static __latent_entropy struct task_struct *copy_process(
 	trace_task_newtask(p, clone_flags);
 	uprobe_copy_process(p, clone_flags);
 
+	copy_oom_score_adj(clone_flags, p);
+
 	return p;
 
 bad_fork_cancel_cgroup:
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 6e94962893ee8..67e5bb0900b37 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -64,6 +64,8 @@ int sysctl_oom_dump_tasks = 1;
  * and mark_oom_victim
  */
 DEFINE_MUTEX(oom_lock);
+/* Serializes oom_score_adj and oom_score_adj_min updates */
+DEFINE_MUTEX(oom_adj_mutex);
 
 static inline bool is_memcg_oom(struct oom_control *oc)
 {
-- 
2.25.1



