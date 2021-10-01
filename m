Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B5941EFAF
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 16:38:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbhJAOkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 10:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353844AbhJAOkL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 10:40:11 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1E52C061775
        for <stable@vger.kernel.org>; Fri,  1 Oct 2021 07:38:26 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id ba1so35626372edb.4
        for <stable@vger.kernel.org>; Fri, 01 Oct 2021 07:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zmf5bHycEslzhJrqEtvPO4rl26bvdDHLmu6FXit3K00=;
        b=xSdLcHEHstBCW0XwCmCZHKI0LmErqmy4xzApHOoeQsw9Ey/RmGbMEUcvrYLBJmxIqr
         +sX+IWQ5cOZkLVs+KNItg5upOeDdti488Vl/k1xkmttk1DRFva0zM0lC5Hh+xh/yczpJ
         jUy7qYVjme9Ox+2jkewzjKZJkU1jAelUPfvslZt9E1wqDJNt0UCXDJs1pNHt6vFyOy+S
         tQNe7nB3aq67/gq6wluF6im3q/0Bt6lbl/IXfVa4Dke5YyrDcJoD9Ocz0vsNevuYs6qW
         mMAHBqaACuTXEdXWpErZAxa3THQTzgyuqbq1KbD5Os1u6da1oh2zQy2SYrJ2trQ7x1Oo
         YaxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zmf5bHycEslzhJrqEtvPO4rl26bvdDHLmu6FXit3K00=;
        b=5Qh0J7jVk2h7X7nppkzaEM8duC6+cgkH+sANJPo9ynTpUP7tiO1D7jPAGyxTozJusx
         BaQfh3l8acXZ3bFUNfHncSolzT5a8t+GKxOXg9eXvwaEI9micNpA/HBiVKosY3Q3g8cw
         dodFGbkwXnILv0bsb6NLO4kxUN7kJ8u/3EMMdNQQTZ7up0BPWx8rYA2Fhfaznmz1w3Se
         iyWLGG9iBQxvPR6E0519XxcsGsjESLCxaOU9ui34XkCHFNQbJUKLE/eAL3JsuiTA24NG
         vH7b20MmpHeus1I181AdmxLEliHW8HMTcVkOSP01poLQaCW3evnGyM5+YSdkz2M899rs
         XJZQ==
X-Gm-Message-State: AOAM531F/dWGBtf9pAkzD6h604N0/dKs/LrdYF+26t3G40mkrza5o27T
        FdJxWopmpkFC+NcMfCe8MYl0Cf7GjHMsT1hD1SX6
X-Google-Smtp-Source: ABdhPJzEvVvODu1yaZFSdK5tpYcIveXlY8zeFTPk2iUCD75467RBT4GINnz2yu22lrjdtA9Z7q7ifInwZsLH6/h5uac=
X-Received: by 2002:a05:6402:142e:: with SMTP id c14mr14718759edx.209.1633099103840;
 Fri, 01 Oct 2021 07:38:23 -0700 (PDT)
MIME-Version: 1.0
References: <20211001024506.3762647-1-tkjos@google.com>
In-Reply-To: <20211001024506.3762647-1-tkjos@google.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 1 Oct 2021 10:38:12 -0400
Message-ID: <CAHC9VhQ-uziaYRYWaah=RMmz7HUVvxGs+4F=g2sizVXR0ZSWVw@mail.gmail.com>
Subject: Re: [PATCH] binder: use cred instead of task for selinux checks
To:     Todd Kjos <tkjos@google.com>
Cc:     gregkh@linuxfoundation.org, arve@android.com, tkjos@android.com,
        maco@android.com, christian@brauner.io,
        James Morris <jmorris@namei.org>,
        Serge Hallyn <serge@hallyn.com>,
        Stephen Smalley <stephen.smalley.work@gmail.com>,
        Eric Paris <eparis@parisplace.org>, keescook@chromium.org,
        jannh@google.com, Jeffrey Vander Stoep <jeffv@google.com>,
        zohar@linux.ibm.com, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, joel@joelfernandes.org,
        kernel-team@android.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 30, 2021 at 10:45 PM Todd Kjos <tkjos@google.com> wrote:
>
> Save the struct cred associated with a binder process
> at initial open to avoid potential race conditions
> when converting to a security ID.
>
> Since binder was integrated with selinux, it has passed
> 'struct task_struct' associated with the binder_proc
> to represent the source and target of transactions.
> The conversion of task to SID was then done in the hook
> implementations. It turns out that there are race conditions
> which can result in an incorrect security context being used.
>
> Fix by saving the 'struct cred' during binder_open and pass
> it to the selinux subsystem.
>
> Fixes: 79af73079d75 ("Add security hooks to binder and implement the
> hooks for SELinux.")
> Signed-off-by: Todd Kjos <tkjos@google.com>
> Cc: stable@vger.kernel.org # 5.14 (need backport for earlier stables)
> ---
>  drivers/android/binder.c          | 14 +++++----
>  drivers/android/binder_internal.h |  3 ++
>  include/linux/lsm_hook_defs.h     | 14 ++++-----
>  include/linux/security.h          | 28 +++++++++---------
>  security/security.c               | 14 ++++-----
>  security/selinux/hooks.c          | 48 +++++++++----------------------
>  6 files changed, 52 insertions(+), 69 deletions(-)

Thanks Todd, I'm happy to see someone with a better understanding of
binder than me pitch in to clean this up :)  A couple of quick
comments/questions below ...

> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> index 9edacc8b9768..ca599ebdea4a 100644
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -5055,6 +5056,7 @@ static int binder_open(struct inode *nodp, struct file *filp)
>         spin_lock_init(&proc->outer_lock);
>         get_task_struct(current->group_leader);
>         proc->tsk = current->group_leader;
> +       proc->cred = get_cred(filp->f_cred);

Is it *always* true that filp->f_cred is going to be the same as
current->group_leader->cred?  Or rather does this help resolve the
issue of wanting the subjective creds but not being able to access
them mentioned in the task_sid_binder() comment?  If the latter, it
might be nice to add something to the related comment in struct
binder_ref (below).

>         INIT_LIST_HEAD(&proc->todo);
>         init_waitqueue_head(&proc->freeze_wait);
>         proc->default_priority = task_nice(current);
> diff --git a/drivers/android/binder_internal.h b/drivers/android/binder_internal.h
> index 402c4d4362a8..886fc327a534 100644
> --- a/drivers/android/binder_internal.h
> +++ b/drivers/android/binder_internal.h
> @@ -364,6 +364,8 @@ struct binder_ref {
>   *                        (invariant after initialized)
>   * @tsk                   task_struct for group_leader of process
>   *                        (invariant after initialized)
> + * @cred                  struct cred for group_leader of process
> + *                        (invariant after initialized)

Related to the question above.  At the very least the comment should
probably be changed to indicate to make it clear the creds are coming
directly from the binder file/device and not always the group_leader.

> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index e7ebd45ca345..c8bf3db90c8b 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -255,29 +255,6 @@ static inline u32 task_sid_obj(const struct task_struct *task)
>         return sid;
>  }
>
> -/*
> - * get the security ID of a task for use with binder
> - */
> -static inline u32 task_sid_binder(const struct task_struct *task)
> -{
> -       /*
> -        * In many case where this function is used we should be using the
> -        * task's subjective SID, but we can't reliably access the subjective
> -        * creds of a task other than our own so we must use the objective
> -        * creds/SID, which are safe to access.  The downside is that if a task
> -        * is temporarily overriding it's creds it will not be reflected here;
> -        * however, it isn't clear that binder would handle that case well
> -        * anyway.
> -        *
> -        * If this ever changes and we can safely reference the subjective
> -        * creds/SID of another task, this function will make it easier to
> -        * identify the various places where we make use of the task SIDs in
> -        * the binder code.  It is also likely that we will need to adjust
> -        * the main drivers/android binder code as well.
> -        */
> -       return task_sid_obj(task);
> -}

-- 
paul moore
www.paul-moore.com
