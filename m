Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36DB9251BCC
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 17:05:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgHYPFU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 11:05:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:53514 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbgHYPFS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Aug 2020 11:05:18 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id F2602AEBB;
        Tue, 25 Aug 2020 15:05:47 +0000 (UTC)
Date:   Tue, 25 Aug 2020 17:05:16 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Suren Baghdasaryan <surenb@google.com>
Cc:     christian.brauner@ubuntu.com, mingo@kernel.org,
        peterz@infradead.org, tglx@linutronix.de, esyr@redhat.com,
        christian@kellner.me, areber@redhat.com, shakeelb@google.com,
        cyphar@cyphar.com, oleg@redhat.com, adobriyan@gmail.com,
        akpm@linux-foundation.org, ebiederm@xmission.com,
        gladkov.alexey@gmail.com, walken@google.com,
        daniel.m.jordan@oracle.com, avagin@gmail.com,
        bernd.edlinger@hotmail.de, john.johansen@canonical.com,
        laoar.shao@gmail.com, timmurray@google.com, minchan@kernel.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v2 1/1] mm, oom_adj: don't loop through tasks in
 __set_oom_adj when not necessary
Message-ID: <20200825150516.GJ22869@dhcp22.suse.cz>
References: <20200824153036.3201505-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824153036.3201505-1-surenb@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon 24-08-20 08:30:36, Suren Baghdasaryan wrote:
> Currently __set_oom_adj loops through all processes in the system to
> keep oom_score_adj and oom_score_adj_min in sync between processes
> sharing their mm. This is done for any task with more that one mm_users,
> which includes processes with multiple threads (sharing mm and signals).
> However for such processes the loop is unnecessary because their signal
> structure is shared as well.
> Android updates oom_score_adj whenever a tasks changes its role
> (background/foreground/...) or binds to/unbinds from a service, making
> it more/less important. Such operation can happen frequently.
> We noticed that updates to oom_score_adj became more expensive and after
> further investigation found out that the patch mentioned in "Fixes"
> introduced a regression. Using Pixel 4 with a typical Android workload,
> write time to oom_score_adj increased from ~3.57us to ~362us. Moreover
> this regression linearly depends on the number of multi-threaded
> processes running on the system.
> Mark the mm with a new MMF_PROC_SHARED flag bit when task is created with
> (CLONE_VM && !CLONE_THREAD && !CLONE_VFORK). Change __set_oom_adj to use
> MMF_PROC_SHARED instead of mm_users to decide whether oom_score_adj
> update should be synchronized between multiple processes. To prevent
> races between clone() and __set_oom_adj(), when oom_score_adj of the
> process being cloned might be modified from userspace, we use
> oom_adj_mutex. Its scope is changed to global and it is renamed into
> oom_adj_lock for naming consistency with oom_lock. The combination of
> (CLONE_VM && !CLONE_THREAD) is rarely used except for the case of vfork().
> To prevent performance regressions of vfork(), we skip taking oom_adj_lock
> and setting MMF_PROC_SHARED when CLONE_VFORK is specified. Clearing the
> MMF_PROC_SHARED flag (when the last process sharing the mm exits) is left
> out of this patch to keep it simple and because it is believed that this
> threading model is rare. Should there ever be a need for optimizing that
> case as well, it can be done by hooking into the exit path, likely
> following the mm_update_next_owner pattern.
> With the combination of (CLONE_VM && !CLONE_THREAD && !CLONE_VFORK) being
> quite rare, the regression is gone after the change is applied.
> 
> Fixes: 44a70adec910 ("mm, oom_adj: make sure processes sharing mm have same view of oom_score_adj")
> Reported-by: Tim Murray <timmurray@google.com>
> Debugged-by: Minchan Kim <minchan@kernel.org>
> Suggested-by: Michal Hocko <mhocko@kernel.org>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Michal Hocko <mhocko@suse.com>

I hope we can build on top of this and move oom_core* stuff to the
mm_struct to remove all this cruft but I still think that this is
conceptually easier to backport to older kernels than a completely new
approach.

Btw. now that the flag is in place we can optimize __oom_kill_process as
well. Not that this particular path is performance sensitive. But it
could show up in group oom killing in memcgs. It should be as simple as
(I can prepare an official patch unless somebody beat me to it)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index c22f07c986cb..04cf958d0c29 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -906,29 +906,31 @@ static void __oom_kill_process(struct task_struct *victim, const char *message)
 	 * That thread will now get access to memory reserves since it has a
 	 * pending fatal signal.
 	 */
-	rcu_read_lock();
-	for_each_process(p) {
-		if (!process_shares_mm(p, mm))
-			continue;
-		if (same_thread_group(p, victim))
-			continue;
-		if (is_global_init(p)) {
-			can_oom_reap = false;
-			set_bit(MMF_OOM_SKIP, &mm->flags);
-			pr_info("oom killer %d (%s) has mm pinned by %d (%s)\n",
-					task_pid_nr(victim), victim->comm,
-					task_pid_nr(p), p->comm);
-			continue;
+	if (test_bit(MMF_PROC_SHARED, &p->mm->flags)) {
+		rcu_read_lock();
+		for_each_process(p) {
+			if (!process_shares_mm(p, mm))
+				continue;
+			if (same_thread_group(p, victim))
+				continue;
+			if (is_global_init(p)) {
+				can_oom_reap = false;
+				set_bit(MMF_OOM_SKIP, &mm->flags);
+				pr_info("oom killer %d (%s) has mm pinned by %d (%s)\n",
+						task_pid_nr(victim), victim->comm,
+						task_pid_nr(p), p->comm);
+				continue;
+			}
+			/*
+			 * No kthead_use_mm() user needs to read from the userspace so
+			 * we are ok to reap it.
+			 */
+			if (unlikely(p->flags & PF_KTHREAD))
+				continue;
+			do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
 		}
-		/*
-		 * No kthead_use_mm() user needs to read from the userspace so
-		 * we are ok to reap it.
-		 */
-		if (unlikely(p->flags & PF_KTHREAD))
-			continue;
-		do_send_sig_info(SIGKILL, SEND_SIG_PRIV, p, PIDTYPE_TGID);
+		rcu_read_unlock();
 	}
-	rcu_read_unlock();
 
 	if (can_oom_reap)
 		wake_oom_reaper(victim);
-- 
Michal Hocko
SUSE Labs
