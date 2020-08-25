Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB69251E7A
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 19:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726497AbgHYRhI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 13:37:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726840AbgHYRg7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 13:36:59 -0400
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4005AC061755
        for <stable@vger.kernel.org>; Tue, 25 Aug 2020 10:36:59 -0700 (PDT)
Received: by mail-vs1-xe41.google.com with SMTP id u131so4209124vsu.11
        for <stable@vger.kernel.org>; Tue, 25 Aug 2020 10:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+855CmegM+DswyOpl/Szdp5ActwZ8DYUP58NTFD9vJU=;
        b=Pe23f4ExVOzYgrqtYwx2WgAVRZ5swZyB+ojamfXaxfvx7dyPw9+zF+/1R3tWrh62zs
         kk/fUQh8DCinymfeBmEXtLfdHVd5v2fRzrPZ8IugiMGSjLJp3h2BNP9Qe2L76dbqiOHm
         5Ky/VUmLumzpUYJVOMU51VfVov+Sh69DvbbNnjQuuYJNnxzB+I1bLlD1oB1w32LQT9Eh
         KeNd2+06XCSUP5/6tud+ZNSArngcoRgy8L/wrGlA8vDo8CAL3WDaKQWc8i0x2NTyB3qy
         lyopTTrN/t0iGQKqiVjwHqZ/amk9K4lNIXy0BOvWryD1mYTjQcH3FzLvMSLidUOWUaJt
         KU4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+855CmegM+DswyOpl/Szdp5ActwZ8DYUP58NTFD9vJU=;
        b=sKBjXCMqEKE7CM8uqgAJgcd3JPhO26npXl1f5ao6rYdhM5XRXEl7E4OuPYRrPwIqNt
         EyPfosyO+SYyM69P0CdNxEZZplPFFGoxxNAYfMEJr5Iq20N9S+970l4vcStXQMMcwoJD
         SNjUwOIHkUtcTmjqvHdnKhP9WGyGYw6+OY0dMGaCR3PuSAP+50w9dOFH0dwkF0HeWtNZ
         3atogkuFW5nHHZKBzIq6M7cIsnriQ6Ebv08abH0LWD+lGOJmMeAfp1Uimp7Rmoae1UF2
         q/spESN0syiFOCM9B4Q1FfCt7dsNesGH6N6Zizm6H6kN/+EiwpjmWN8VcjkGhlgfunuK
         qeAA==
X-Gm-Message-State: AOAM532vJWtLrs8Zm4C5Smc3GZdsOurZ6eSmzRmBedVW2pqY7ky3M3ez
        0xrCuyDPcRS8HrwnTxuakF0H+sZ4vMFiQ6bu0STVmA==
X-Google-Smtp-Source: ABdhPJxbywIoBPQZF125TFQpPJDrXpJj7CqAFrBMQcd2a5TQ1EuOhPPVFDMNkJC6B4coJKwZbj/Fn/5bvu2Aprsrsuk=
X-Received: by 2002:a67:efd4:: with SMTP id s20mr2401698vsp.221.1598377017637;
 Tue, 25 Aug 2020 10:36:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200824153036.3201505-1-surenb@google.com> <87imd6n0qk.fsf@x220.int.ebiederm.org>
In-Reply-To: <87imd6n0qk.fsf@x220.int.ebiederm.org>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Tue, 25 Aug 2020 10:36:45 -0700
Message-ID: <CAJuCfpG4emt9vT8qdakc8Myoc65XyxSgg30Am0Z67z+hc-Psbg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm, oom_adj: don't loop through tasks in
 __set_oom_adj when not necessary
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Michal Hocko <mhocko@suse.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        mingo@kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, esyr@redhat.com,
        christian@kellner.me, areber@redhat.com,
        Shakeel Butt <shakeelb@google.com>, cyphar@cyphar.com,
        Oleg Nesterov <oleg@redhat.com>, adobriyan@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        gladkov.alexey@gmail.com, Michel Lespinasse <walken@google.com>,
        daniel.m.jordan@oracle.com, avagin@gmail.com,
        bernd.edlinger@hotmail.de,
        John Johansen <john.johansen@canonical.com>,
        laoar.shao@gmail.com, Tim Murray <timmurray@google.com>,
        Minchan Kim <minchan@kernel.org>,
        kernel-team <kernel-team@android.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, stable <stable@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Michal Hocko <mhocko@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 25, 2020 at 9:38 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>
> Suren Baghdasaryan <surenb@google.com> writes:
>
> > Currently __set_oom_adj loops through all processes in the system to
> > keep oom_score_adj and oom_score_adj_min in sync between processes
> > sharing their mm. This is done for any task with more that one mm_users,
> > which includes processes with multiple threads (sharing mm and signals).
> > However for such processes the loop is unnecessary because their signal
> > structure is shared as well.
> > Android updates oom_score_adj whenever a tasks changes its role
> > (background/foreground/...) or binds to/unbinds from a service, making
> > it more/less important. Such operation can happen frequently.
> > We noticed that updates to oom_score_adj became more expensive and after
> > further investigation found out that the patch mentioned in "Fixes"
> > introduced a regression. Using Pixel 4 with a typical Android workload,
> > write time to oom_score_adj increased from ~3.57us to ~362us. Moreover
> > this regression linearly depends on the number of multi-threaded
> > processes running on the system.
> > Mark the mm with a new MMF_PROC_SHARED flag bit when task is created with
> > (CLONE_VM && !CLONE_THREAD && !CLONE_VFORK). Change __set_oom_adj to use
> > MMF_PROC_SHARED instead of mm_users to decide whether oom_score_adj
> > update should be synchronized between multiple processes. To prevent
> > races between clone() and __set_oom_adj(), when oom_score_adj of the
> > process being cloned might be modified from userspace, we use
> > oom_adj_mutex. Its scope is changed to global and it is renamed into
> > oom_adj_lock for naming consistency with oom_lock. The combination of
> > (CLONE_VM && !CLONE_THREAD) is rarely used except for the case of vfork().
> > To prevent performance regressions of vfork(), we skip taking oom_adj_lock
> > and setting MMF_PROC_SHARED when CLONE_VFORK is specified. Clearing the
> > MMF_PROC_SHARED flag (when the last process sharing the mm exits) is left
> > out of this patch to keep it simple and because it is believed that this
> > threading model is rare. Should there ever be a need for optimizing that
> > case as well, it can be done by hooking into the exit path, likely
> > following the mm_update_next_owner pattern.
> > With the combination of (CLONE_VM && !CLONE_THREAD && !CLONE_VFORK) being
> > quite rare, the regression is gone after the change is applied.
>
> This patch still makes my head hurt.

Sorry about that. It was not my intention and I wish there was a
simpler way to do this.

>
> The obvious wrong things I have mentioned below.
>
>
> > Fixes: 44a70adec910 ("mm, oom_adj: make sure processes sharing mm have same view of oom_score_adj")
> > Reported-by: Tim Murray <timmurray@google.com>
> > Debugged-by: Minchan Kim <minchan@kernel.org>
> > Suggested-by: Michal Hocko <mhocko@kernel.org>
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> > ---
> >
> > v2:
> > - Implemented proposal from Michal Hocko in:
> > https://lore.kernel.org/linux-fsdevel/20200820124109.GI5033@dhcp22.suse.cz/
> > - Updated description to reflect the change
> >
> > v1:
> > - https://lore.kernel.org/linux-mm/20200820002053.1424000-1-surenb@google.com/
> >
> >  fs/proc/base.c                 |  7 +++----
> >  include/linux/oom.h            |  1 +
> >  include/linux/sched/coredump.h |  1 +
> >  kernel/fork.c                  | 21 +++++++++++++++++++++
> >  mm/oom_kill.c                  |  2 ++
> >  5 files changed, 28 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index 617db4e0faa0..cff1a58a236c 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -1055,7 +1055,6 @@ static ssize_t oom_adj_read(struct file *file, char __user *buf, size_t count,
> >
> >  static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
> >  {
> > -     static DEFINE_MUTEX(oom_adj_mutex);
> >       struct mm_struct *mm = NULL;
> >       struct task_struct *task;
> >       int err = 0;
> > @@ -1064,7 +1063,7 @@ static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
> >       if (!task)
> >               return -ESRCH;
> >
> > -     mutex_lock(&oom_adj_mutex);
> > +     mutex_lock(&oom_adj_lock);
> >       if (legacy) {
> >               if (oom_adj < task->signal->oom_score_adj &&
> >                               !capable(CAP_SYS_RESOURCE)) {
> > @@ -1095,7 +1094,7 @@ static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
> >               struct task_struct *p = find_lock_task_mm(task);
> >
> >               if (p) {
> > -                     if (atomic_read(&p->mm->mm_users) > 1) {
> > +                     if (test_bit(MMF_PROC_SHARED, &p->mm->flags)) {
> >                               mm = p->mm;
> >                               mmgrab(mm);
> >                       }
> > @@ -1132,7 +1131,7 @@ static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
> >               mmdrop(mm);
> >       }
> >  err_unlock:
> > -     mutex_unlock(&oom_adj_mutex);
> > +     mutex_unlock(&oom_adj_lock);
> >       put_task_struct(task);
> >       return err;
> >  }
> > diff --git a/include/linux/oom.h b/include/linux/oom.h
> > index f022f581ac29..861f22bd4706 100644
> > --- a/include/linux/oom.h
> > +++ b/include/linux/oom.h
> > @@ -55,6 +55,7 @@ struct oom_control {
> >  };
> >
> >  extern struct mutex oom_lock;
> > +extern struct mutex oom_adj_lock;
>                        ^^^^^^^^^^^^^^
>
> I understand moving this lock by why renaming it?

To be consistent with the mutex name right above it. I'm ok keeping it
as before if this is too much additional churn. I guess Michal deals
with this code more than anyone else, so I'll wait for him to comment
on this one.

>
> >  static inline void set_current_oom_origin(void)
> >  {
> > diff --git a/include/linux/sched/coredump.h b/include/linux/sched/coredump.h
> > index ecdc6542070f..070629b722df 100644
> > --- a/include/linux/sched/coredump.h
> > +++ b/include/linux/sched/coredump.h
> > @@ -72,6 +72,7 @@ static inline int get_dumpable(struct mm_struct *mm)
> >  #define MMF_DISABLE_THP              24      /* disable THP for all VMAs */
> >  #define MMF_OOM_VICTIM               25      /* mm is the oom victim */
> >  #define MMF_OOM_REAP_QUEUED  26      /* mm was queued for oom_reaper */
> > +#define MMF_PROC_SHARED      27      /* mm is shared while sighand is not */
>            ^^^^^^^^^^^^^^^              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> Arguably this is misnamed MMF_MULTIPROCESS is probably better.

SGTM. Thanks for the suggestion.

> The comment is definitely wrong.

Agree. Will change to "mm is shared while signal_struct is not"

>
> >  #define MMF_DISABLE_THP_MASK (1 << MMF_DISABLE_THP)
> >
> >  #define MMF_INIT_MASK                (MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
> > diff --git a/kernel/fork.c b/kernel/fork.c
> > index 4d32190861bd..6fce8ffa9b8b 100644
> > --- a/kernel/fork.c
> > +++ b/kernel/fork.c
> > @@ -1809,6 +1809,25 @@ static __always_inline void delayed_free_task(struct task_struct *tsk)
> >               free_task(tsk);
> >  }
> >
> > +static void copy_oom_score_adj(u64 clone_flags, struct task_struct *tsk)
> > +{
> > +     /* Skip if kernel thread */
> > +     if (!tsk->mm)
> > +             return;
> > +
> > +     /* Skip if spawning a thread or using vfork */
> > +     if ((clone_flags & (CLONE_VM | CLONE_THREAD | CLONE_VFORK)) != CLONE_VM)
> > +             return;
> > +
> > +     /* We need to synchronize with __set_oom_adj */
> > +     mutex_lock(&oom_adj_lock);
> > +     set_bit(MMF_PROC_SHARED, &tsk->mm->flags);
> > +     /* Update the values in case they were changed after copy_signal */
> > +     tsk->signal->oom_score_adj = current->signal->oom_score_adj;
> > +     tsk->signal->oom_score_adj_min = current->signal->oom_score_adj_min;
> > +     mutex_unlock(&oom_adj_lock);
>
> The copying and the setting of a bit on a mm should be logically
> separate things.
>
> This really makes my head hurt because the functionality is not
> separated out.  I don't have a clue how we could maintain this
> copy_oom_score_adj function.
>

Copying oom_score_adj here is necessary to prevent a possible race
from creating inconsistent oom_score_adj for the cloned process. The
race this protects from is when __set_oom_adj happens after
copy_signal but before copy_oom_score_adj. In that case __set_oom_adj
will not see MMF_PROC_SHARED and therefore will not update
oom_score_adj of the cloned process. Copying oom_score_adj again
inside copy_oom_score_adj will fix such inconsistency. This is the
simplest way I see to keep things in sync until mm->oom_score_adj is
implemented (which I agree should happen but it's also a much bigger
change).

>
> > +}
> > +
> >  /*
> >   * This creates a new process as a copy of the old one,
> >   * but does not actually start it yet.
> > @@ -2281,6 +2300,8 @@ static __latent_entropy struct task_struct *copy_process(
> >       trace_task_newtask(p, clone_flags);
> >       uprobe_copy_process(p, clone_flags);
> >
> > +     copy_oom_score_adj(clone_flags, p);
> > +
> >       return p;
> >
> >  bad_fork_cancel_cgroup:
> > diff --git a/mm/oom_kill.c b/mm/oom_kill.c
> > index e90f25d6385d..c22f07c986cb 100644
> > --- a/mm/oom_kill.c
> > +++ b/mm/oom_kill.c
> > @@ -64,6 +64,8 @@ int sysctl_oom_dump_tasks = 1;
> >   * and mark_oom_victim
> >   */
> >  DEFINE_MUTEX(oom_lock);
> > +/* Serializes oom_score_adj and oom_score_adj_min updates */
> > +DEFINE_MUTEX(oom_adj_lock);
> >
> >  static inline bool is_memcg_oom(struct oom_control *oc)
> >  {
>
> Eric

Thanks everyone for the reviews and feedback! I'll wait for a couple
days to see if any other comments come in and will send a version with
fixes addressing Eric's concerns.
