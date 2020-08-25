Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0C7251AC1
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 16:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726306AbgHYOYu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 10:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYOYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 10:24:47 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32ACFC061756
        for <stable@vger.kernel.org>; Tue, 25 Aug 2020 07:24:47 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id u46so247970uau.6
        for <stable@vger.kernel.org>; Tue, 25 Aug 2020 07:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=okmSfG76Cm0/HZKPCuD/vD1jM1zwkcjUb4EgZODn79g=;
        b=r27VoB6zXP3SyOq+GAb2qPoC+yspqQgbSlRsjPKEneFqgA1vgEo4i6jAx5Z90G0zHs
         kckquU4h3UODmKcknAvvj9+sszBbxMNSCArj8yEQWl72XSLA/8sS3kRgaMRBNdf+L5q5
         8YSwrWmcWIa+RRuFvwegLLgIHM1xj0pQUywZ2igKlFw/jxJ/85SE1yUqPPhF1jrRh2oF
         NvINvwWr+bIqhUANCt9dOK8YX9nH/3hBCNY2kAVcuQXIti3moT8kZyp63ibcHxKlbRMu
         jYkpcmaop8mipKgPcfUZbHxO4wX+Oj3iz/OI2cbkyyQXMAMi7ekH+UFEPW64dngxum2K
         ufRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=okmSfG76Cm0/HZKPCuD/vD1jM1zwkcjUb4EgZODn79g=;
        b=Ki3+rB+fv9KCOjbdapu6K4CYdTSoq9J439RhDP8Q29geOF70XmnqznYN+lpz59YAH2
         M6yy2eBcZSArNrkXawLoXjoLLYgVuPkC9XPuhG1ShlO+InkdkzEBKcTkcOm/F9fhd4YL
         FuBtfzaqfrIL8dN6OmhMSKPfD1VCmpDxcmmjx0SDI283g4fNCkShwjKgDo0lzYDkLsGl
         UFyoEVfxkgyitI58axdniDcbHgH7A860ByqDY/m+OuI9Lwown2hzFpa1nc8jDVg1s1yH
         WPvafwfd7zlxHcH9W6HwuKvHg7aRJcICKkQh6HWtEKSilJxRbnDM3bI+itNSmdz0AFto
         T83w==
X-Gm-Message-State: AOAM530um4IQH5cKe0oumg/RUquKwrk2LLoAZJWVcJDTP0b61oATXxQc
        o/2bcyYfE/OIDYmxB7GTItzczGqkWJ4HnAHqKuMR+A==
X-Google-Smtp-Source: ABdhPJxyGvLAySOcaQE1wH6W+EB0e+NuFGdnu6GmpbNN0KBXRl9yKJ7k4uW3MLbqXivQ7RUIBJUxMXzjCDnCC7f2zpY=
X-Received: by 2002:ab0:3765:: with SMTP id o5mr3052916uat.92.1598365485422;
 Tue, 25 Aug 2020 07:24:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200824153036.3201505-1-surenb@google.com> <20200825111524.v2bnoya35spde3zt@wittgenstein>
In-Reply-To: <20200825111524.v2bnoya35spde3zt@wittgenstein>
From:   Suren Baghdasaryan <surenb@google.com>
Date:   Tue, 25 Aug 2020 07:24:34 -0700
Message-ID: <CAJuCfpE7YQjBJDKBcc-20qEDsu9koirFuGSO306NDuKz6_9Tsg@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] mm, oom_adj: don't loop through tasks in
 __set_oom_adj when not necessary
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Michal Hocko <mhocko@suse.com>, mingo@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, esyr@redhat.com,
        christian@kellner.me, areber@redhat.com,
        Shakeel Butt <shakeelb@google.com>, cyphar@cyphar.com,
        Oleg Nesterov <oleg@redhat.com>, adobriyan@gmail.com,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
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

On Tue, Aug 25, 2020 at 4:15 AM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
>
> On Mon, Aug 24, 2020 at 08:30:36AM -0700, Suren Baghdasaryan wrote:
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
> >
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
> >
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
>
> Hm, wouldn't
>
>         if (tsk->flags & PF_KTHREAD)
>                 return;
>
> be clearer and more future proof?

The check follows a similar pattern from copy_mm to detect when we are
cloning a kernel thread. Also IMHO this is a more obvious way to
protect from dereferencing a NULL tsk->mm, which is the important
point here. I can change or remove the comment if that makes things
more clear. Please LMK if that would help.

>
> Christian
