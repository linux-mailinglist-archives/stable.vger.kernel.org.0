Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBB241F2C0
	for <lists+stable@lfdr.de>; Fri,  1 Oct 2021 19:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353537AbhJARQd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Oct 2021 13:16:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231815AbhJARQc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Oct 2021 13:16:32 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B686C06177E
        for <stable@vger.kernel.org>; Fri,  1 Oct 2021 10:14:48 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id m3so40904612lfu.2
        for <stable@vger.kernel.org>; Fri, 01 Oct 2021 10:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0XGy+GRK48SGGxR1ZCE+Ciu2OxM1nuqOBwlHN8oBD9U=;
        b=dLtBJrwYeEb7m8l51kN8I5xA2EeE3Dsu8p9BDuk1SrsxjeEvG5/uleGiLvQbFFC92g
         RD4vaTnfZQRHi4pqOjTLit9ltpn5kI3c0QumTpCcv1Po4n8Ts2MOt3KILylZ+9P5SdGP
         aoRbyvGQ8QEEBwZKtzcUDx52FRT7TdM+RMYmOog3f6tYJ/sGkgq27zxKKlnAJjW8VstJ
         BH0SN9qrivJjIsjpc6cuiCqQl51RYOosDjTww5eDFx4TnBumDxGBqE6sXLEq75IsZ+We
         udTzoCg21agxIeb5swqZnmgji7bzWuCDy8ALYDlWLfuH8l6mOPJN6tLTpE7xxQZmMZPu
         VGxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0XGy+GRK48SGGxR1ZCE+Ciu2OxM1nuqOBwlHN8oBD9U=;
        b=0xHnO9c4Vow3rDVpmHyeCqZ69wTNb6NKac4cC71sg+pxbfMmKVav5E/AHuvfzsehwy
         SeLpyCwbFe3SxDNkCyiF2I+puUZWQ4DcJxRker4CKBDx562PG7QfiXQW31lwgywxKkFQ
         sPO8bB33Hvv/DbN7kij4Yff5OzQoHRQPPmVP6Ec2l7VBrVH25Uyc5BdiD+bmxIreVw9F
         exhxRV0lS1zOjjyzkV01ipc9FtUIk9OZ0udKHBTtCqsNn5uMLjVoK6IN9xYTOoGG5Yud
         60sNe8n/mIvtVoD02xc5/H34/oaz7gX1SQRdmQsWoHbodLHdbLTu45URkxjKWDmq8f/N
         sztA==
X-Gm-Message-State: AOAM530nFQ4+V2ClwMadyw2B5mu3fwLYSgpf5iRuqYKUGDIVIo8zDQI9
        1rDptyO+vSviTng4bktCnIGOieNCpdDjGLzQT7SRTA==
X-Google-Smtp-Source: ABdhPJzG2fpX+4ES3rah/rrVmMzv/jiF6NJ2zEQzoLdi+59TjyjMidoiQzhXf5vKJHWd+QnCCW46WpFl5hztiSkqOw0=
X-Received: by 2002:a2e:1302:: with SMTP id 2mr13534028ljt.280.1633108486155;
 Fri, 01 Oct 2021 10:14:46 -0700 (PDT)
MIME-Version: 1.0
References: <20211001024506.3762647-1-tkjos@google.com> <CAHC9VhQ-uziaYRYWaah=RMmz7HUVvxGs+4F=g2sizVXR0ZSWVw@mail.gmail.com>
In-Reply-To: <CAHC9VhQ-uziaYRYWaah=RMmz7HUVvxGs+4F=g2sizVXR0ZSWVw@mail.gmail.com>
From:   Todd Kjos <tkjos@google.com>
Date:   Fri, 1 Oct 2021 10:14:34 -0700
Message-ID: <CAHRSSEyq2yUmznpr9G1kxoC_8RcGXzHo37h471uxygFUbD_nrg@mail.gmail.com>
Subject: Re: [PATCH] binder: use cred instead of task for selinux checks
To:     Paul Moore <paul@paul-moore.com>
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

On Fri, Oct 1, 2021 at 7:38 AM Paul Moore <paul@paul-moore.com> wrote:
>
> On Thu, Sep 30, 2021 at 10:45 PM Todd Kjos <tkjos@google.com> wrote:
> >
> > Save the struct cred associated with a binder process
> > at initial open to avoid potential race conditions
> > when converting to a security ID.
> >
> > Since binder was integrated with selinux, it has passed
> > 'struct task_struct' associated with the binder_proc
> > to represent the source and target of transactions.
> > The conversion of task to SID was then done in the hook
> > implementations. It turns out that there are race conditions
> > which can result in an incorrect security context being used.
> >
> > Fix by saving the 'struct cred' during binder_open and pass
> > it to the selinux subsystem.
> >
> > Fixes: 79af73079d75 ("Add security hooks to binder and implement the
> > hooks for SELinux.")
> > Signed-off-by: Todd Kjos <tkjos@google.com>
> > Cc: stable@vger.kernel.org # 5.14 (need backport for earlier stables)
> > ---
> >  drivers/android/binder.c          | 14 +++++----
> >  drivers/android/binder_internal.h |  3 ++
> >  include/linux/lsm_hook_defs.h     | 14 ++++-----
> >  include/linux/security.h          | 28 +++++++++---------
> >  security/security.c               | 14 ++++-----
> >  security/selinux/hooks.c          | 48 +++++++++----------------------
> >  6 files changed, 52 insertions(+), 69 deletions(-)
>
> Thanks Todd, I'm happy to see someone with a better understanding of
> binder than me pitch in to clean this up :)  A couple of quick
> comments/questions below ...
>
> > diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> > index 9edacc8b9768..ca599ebdea4a 100644
> > --- a/drivers/android/binder.c
> > +++ b/drivers/android/binder.c
> > @@ -5055,6 +5056,7 @@ static int binder_open(struct inode *nodp, struct file *filp)
> >         spin_lock_init(&proc->outer_lock);
> >         get_task_struct(current->group_leader);
> >         proc->tsk = current->group_leader;
> > +       proc->cred = get_cred(filp->f_cred);
>
> Is it *always* true that filp->f_cred is going to be the same as
> current->group_leader->cred?

Not necessarily -- it is current->cred of the task in binder_open()
(not group_leader). This is fine. We used to set proc->tsk to current,
but switched to group_leader a few years ago to make it easier to
detect the same process with multiple opens during mmap (to solve some
unrelated issues). We still use group_leader for that purpose, but for
the cred, the current cred in binder_open() is sufficient.

> Or rather does this help resolve the
> issue of wanting the subjective creds but not being able to access
> them mentioned in the task_sid_binder() comment?  If the latter, it
> might be nice to add something to the related comment in struct
> binder_ref (below).

Yes, we want the subjective cred so that is part of the point. I
started with "proc->cred = get_task_cred(current->group_leader)" and
got feedback that the "subjective" cred is preferred to avoid some
subtle races that could be introduced, for example, if /dev/binder is
opened through io_uring.

>
> >         INIT_LIST_HEAD(&proc->todo);
> >         init_waitqueue_head(&proc->freeze_wait);
> >         proc->default_priority = task_nice(current);
> > diff --git a/drivers/android/binder_internal.h b/drivers/android/binder_internal.h
> > index 402c4d4362a8..886fc327a534 100644
> > --- a/drivers/android/binder_internal.h
> > +++ b/drivers/android/binder_internal.h
> > @@ -364,6 +364,8 @@ struct binder_ref {
> >   *                        (invariant after initialized)
> >   * @tsk                   task_struct for group_leader of process
> >   *                        (invariant after initialized)
> > + * @cred                  struct cred for group_leader of process
> > + *                        (invariant after initialized)
>
> Related to the question above.  At the very least the comment should
> probably be changed to indicate to make it clear the creds are coming
> directly from the binder file/device and not always the group_leader.

Good catch. Will update the comment (it's actually struct binder_proc).

>
> > diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> > index e7ebd45ca345..c8bf3db90c8b 100644
> > --- a/security/selinux/hooks.c
> > +++ b/security/selinux/hooks.c
> > @@ -255,29 +255,6 @@ static inline u32 task_sid_obj(const struct task_struct *task)
> >         return sid;
> >  }
> >
> > -/*
> > - * get the security ID of a task for use with binder
> > - */
> > -static inline u32 task_sid_binder(const struct task_struct *task)
> > -{
> > -       /*
> > -        * In many case where this function is used we should be using the
> > -        * task's subjective SID, but we can't reliably access the subjective
> > -        * creds of a task other than our own so we must use the objective
> > -        * creds/SID, which are safe to access.  The downside is that if a task
> > -        * is temporarily overriding it's creds it will not be reflected here;
> > -        * however, it isn't clear that binder would handle that case well
> > -        * anyway.
> > -        *
> > -        * If this ever changes and we can safely reference the subjective
> > -        * creds/SID of another task, this function will make it easier to
> > -        * identify the various places where we make use of the task SIDs in
> > -        * the binder code.  It is also likely that we will need to adjust
> > -        * the main drivers/android binder code as well.
> > -        */
> > -       return task_sid_obj(task);
> > -}
>
> --
> paul moore
> www.paul-moore.com

and from your next response:

> Ooops, I was a little over zealous when trimming my response and I
> accidentally cut off my comment that the associated comment blocks in
> include/linux/lsm_hooks.h should also be updated to reflect the binder
> LSM hook changes.

Thanks for pointing this out! I didn't notice these comment blocks.

-Todd
