Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C275625A531
	for <lists+stable@lfdr.de>; Wed,  2 Sep 2020 07:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgIBFxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Sep 2020 01:53:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:55390 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgIBFxF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 2 Sep 2020 01:53:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5A3BBAF2B;
        Wed,  2 Sep 2020 05:53:04 +0000 (UTC)
Date:   Wed, 2 Sep 2020 07:53:02 +0200
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
Subject: Re: [PATCH v3 1/1] mm, oom_adj: don't loop through tasks in
 __set_oom_adj when not necessary
Message-ID: <20200902055302.GA6363@dhcp22.suse.cz>
References: <20200902012558.2335613-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200902012558.2335613-1-surenb@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 01-09-20 18:25:58, Suren Baghdasaryan wrote:
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
> Mark the mm with a new MMF_MULTIPROCESS flag bit when task is created with
> (CLONE_VM && !CLONE_THREAD && !CLONE_VFORK). Change __set_oom_adj to use
> MMF_MULTIPROCESS instead of mm_users to decide whether oom_score_adj
> update should be synchronized between multiple processes. To prevent
> races between clone() and __set_oom_adj(), when oom_score_adj of the
> process being cloned might be modified from userspace, we use
> oom_adj_mutex. Its scope is changed to global. The combination of
> (CLONE_VM && !CLONE_THREAD) is rarely used except for the case of vfork().
> To prevent performance regressions of vfork(), we skip taking oom_adj_mutex
> and setting MMF_MULTIPROCESS when CLONE_VFORK is specified. Clearing the
> MMF_MULTIPROCESS flag (when the last process sharing the mm exits) is left
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

> ---
> 
> v3:
> - Addressed Eric Biederman's comments from:
> https://lore.kernel.org/linux-mm/87imd6n0qk.fsf@x220.int.ebiederm.org/
> -- renabled oom_adj_lock back to oom_adj_mutex
> -- renamed MMF_PROC_SHARED into MMF_MULTIPROCESS and fixed its comment
> - Updated description to reflect the change
> 
> 
> v2:
> - https://lore.kernel.org/linux-mm/20200824153036.3201505-1-surenb@google.com/
> - Implemented proposal from Michal Hocko in:
> https://lore.kernel.org/linux-fsdevel/20200820124109.GI5033@dhcp22.suse.cz/
> - Updated description to reflect the change
> 
> v1:
> - https://lore.kernel.org/linux-mm/20200820002053.1424000-1-surenb@google.com/
> 
>  fs/proc/base.c                 |  3 +--
>  include/linux/oom.h            |  1 +
>  include/linux/sched/coredump.h |  1 +
>  kernel/fork.c                  | 21 +++++++++++++++++++++
>  mm/oom_kill.c                  |  2 ++
>  5 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 617db4e0faa0..aa69c35d904c 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1055,7 +1055,6 @@ static ssize_t oom_adj_read(struct file *file, char __user *buf, size_t count,
>  
>  static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
>  {
> -	static DEFINE_MUTEX(oom_adj_mutex);
>  	struct mm_struct *mm = NULL;
>  	struct task_struct *task;
>  	int err = 0;
> @@ -1095,7 +1094,7 @@ static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
>  		struct task_struct *p = find_lock_task_mm(task);
>  
>  		if (p) {
> -			if (atomic_read(&p->mm->mm_users) > 1) {
> +			if (test_bit(MMF_MULTIPROCESS, &p->mm->flags)) {
>  				mm = p->mm;
>  				mmgrab(mm);
>  			}
> diff --git a/include/linux/oom.h b/include/linux/oom.h
> index f022f581ac29..2db9a1432511 100644
> --- a/include/linux/oom.h
> +++ b/include/linux/oom.h
> @@ -55,6 +55,7 @@ struct oom_control {
>  };
>  
>  extern struct mutex oom_lock;
> +extern struct mutex oom_adj_mutex;
>  
>  static inline void set_current_oom_origin(void)
>  {
> diff --git a/include/linux/sched/coredump.h b/include/linux/sched/coredump.h
> index ecdc6542070f..dfd82eab2902 100644
> --- a/include/linux/sched/coredump.h
> +++ b/include/linux/sched/coredump.h
> @@ -72,6 +72,7 @@ static inline int get_dumpable(struct mm_struct *mm)
>  #define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
>  #define MMF_OOM_VICTIM		25	/* mm is the oom victim */
>  #define MMF_OOM_REAP_QUEUED	26	/* mm was queued for oom_reaper */
> +#define MMF_MULTIPROCESS	27	/* mm is shared between processes */
>  #define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
>  
>  #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 4d32190861bd..6129a88c19ad 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -1809,6 +1809,25 @@ static __always_inline void delayed_free_task(struct task_struct *tsk)
>  		free_task(tsk);
>  }
>  
> +static void copy_oom_score_adj(u64 clone_flags, struct task_struct *tsk)
> +{
> +	/* Skip if kernel thread */
> +	if (!tsk->mm)
> +		return;
> +
> +	/* Skip if spawning a thread or using vfork */
> +	if ((clone_flags & (CLONE_VM | CLONE_THREAD | CLONE_VFORK)) != CLONE_VM)
> +		return;
> +
> +	/* We need to synchronize with __set_oom_adj */
> +	mutex_lock(&oom_adj_mutex);
> +	set_bit(MMF_MULTIPROCESS, &tsk->mm->flags);
> +	/* Update the values in case they were changed after copy_signal */
> +	tsk->signal->oom_score_adj = current->signal->oom_score_adj;
> +	tsk->signal->oom_score_adj_min = current->signal->oom_score_adj_min;
> +	mutex_unlock(&oom_adj_mutex);
> +}
> +
>  /*
>   * This creates a new process as a copy of the old one,
>   * but does not actually start it yet.
> @@ -2281,6 +2300,8 @@ static __latent_entropy struct task_struct *copy_process(
>  	trace_task_newtask(p, clone_flags);
>  	uprobe_copy_process(p, clone_flags);
>  
> +	copy_oom_score_adj(clone_flags, p);
> +
>  	return p;
>  
>  bad_fork_cancel_cgroup:
> diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> index e90f25d6385d..8b84661a6410 100644
> --- a/mm/oom_kill.c
> +++ b/mm/oom_kill.c
> @@ -64,6 +64,8 @@ int sysctl_oom_dump_tasks = 1;
>   * and mark_oom_victim
>   */
>  DEFINE_MUTEX(oom_lock);
> +/* Serializes oom_score_adj and oom_score_adj_min updates */
> +DEFINE_MUTEX(oom_adj_mutex);
>  
>  static inline bool is_memcg_oom(struct oom_control *oc)
>  {
> -- 
> 2.28.0.526.ge36021eeef-goog

-- 
Michal Hocko
SUSE Labs
