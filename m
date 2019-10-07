Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF3FCE43C
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 15:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfJGNvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 09:51:02 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:45577 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727715AbfJGNvB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 09:51:01 -0400
Received: by mail-qk1-f195.google.com with SMTP id z67so12562581qkb.12
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 06:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IYTQc9pkklqWHMouyJseXYf3fIK7lEf7q4Z1ZbUboWU=;
        b=DWoXSOXJ2+WloLrHOXlt4e17wDt7AR/niWGjAZjfVMddOsQ1wyWBYBhaosgPDbnc6v
         UyMg0Ny06xFOyH1RZj47SIcL51nYf7PbPsRVTrwd6YKcgUeXlCy6yVn615HYcKIz3Kci
         1u8tIvjVXsXQLoObbMxWI8p0fSXcI473Z2JoCieUc4rg54wNoltxZjQNr+Mj6pk0o8RZ
         f/W3q6CNJJRuLphdRpMzNw86lXvJ77IqyX6pEWJMAWO7WpRL7mGAGcp+ZkCrrdKFH3i2
         lYzr5NLCTSspZ3S4Amb+3i8JgIq0YAeRqlPbRnwbOy2lxJFqVzn4NmnHDUzdKM6h3+dG
         lo2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IYTQc9pkklqWHMouyJseXYf3fIK7lEf7q4Z1ZbUboWU=;
        b=GQBGOF3pgv+rlxR9uUM7+9z2xW6H4BtQOO9fb5a/flAZUxovo6KTcVigQeLwyi1YPg
         jaNpbVKMug4k3b0yacovTKMjE4N9UqwxPtpcXTa5gZHA5aNJrNCDa7c2HUeRw4es01Qk
         jKaUOXILxGaY97uizQKRCuuglstndQ5QY7m5/DsNva644f3Bjq/fbk0Ka5CUGf16sTTq
         EK4ZG9gnNhRNcZx5OAGa5ajmeq6/U2QYAjKffPATLQ9dZ7deTYZFwFBtHvXOIfsa8TGD
         DIz+VUI9LxW6M4IAc3wOvHaSo2/Qf4e9T0WISCs8TMEnpej1gyL0TW7fSjwx1U16DLuc
         LUVg==
X-Gm-Message-State: APjAAAWvGyWP72lYTbt/F2CYEbusmXyIfA4L2EQrMs8iOACC7a1xpAxk
        pKNTZH3RhBbVk/hgUbCPVrmH/1T+AqYKMdjrGrVkfA==
X-Google-Smtp-Source: APXvYqzh/OeSTjLyIs3Dc0YlIhCuQFyOlIjf37jONr3UqmFwJP6OBS+YmngvTj21e28J/XdDCSiEYCj4ZuEOOd361n0=
X-Received: by 2002:a37:985:: with SMTP id 127mr23035292qkj.43.1570456258406;
 Mon, 07 Oct 2019 06:50:58 -0700 (PDT)
MIME-Version: 1.0
References: <20191007104039.GA16085@andrea.guest.corp.microsoft.com>
 <20191007110117.1096-1-christian.brauner@ubuntu.com> <20191007131804.GA19242@andrea.guest.corp.microsoft.com>
In-Reply-To: <20191007131804.GA19242@andrea.guest.corp.microsoft.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 7 Oct 2019 15:50:47 +0200
Message-ID: <CACT4Y+YG23qbL16MYH3GTK4hOPsM9tDfbLzrTZ7k_ocR2ABa6A@mail.gmail.com>
Subject: Re: [PATCH v2] taskstats: fix data-race
To:     Andrea Parri <parri.andrea@gmail.com>
Cc:     Christian Brauner <christian.brauner@ubuntu.com>,
        bsingharora@gmail.com, Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 7, 2019 at 3:18 PM Andrea Parri <parri.andrea@gmail.com> wrote:
>
> On Mon, Oct 07, 2019 at 01:01:17PM +0200, Christian Brauner wrote:
> > When assiging and testing taskstats in taskstats_exit() there's a race
> > when writing and reading sig->stats when a thread-group with more than
> > one thread exits:
> >
> > cpu0:
> > thread catches fatal signal and whole thread-group gets taken down
> >  do_exit()
> >  do_group_exit()
> >  taskstats_exit()
> >  taskstats_tgid_alloc()
> > The tasks reads sig->stats holding sighand lock seeing garbage.
>
> You meant "without holding sighand lock" here, right?
>
>
> >
> > cpu1:
> > task calls exit_group()
> >  do_exit()
> >  do_group_exit()
> >  taskstats_exit()
> >  taskstats_tgid_alloc()
> > The task takes sighand lock and assigns new stats to sig->stats.
> >
> > Fix this by using READ_ONCE() and smp_store_release().
> >
> > Reported-by: syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com
> > Fixes: 34ec12349c8a ("taskstats: cleanup ->signal->stats allocation")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
> > Link: https://lore.kernel.org/r/20191006235216.7483-1-christian.brauner@ubuntu.com
> > ---
> > /* v1 */
> > Link: https://lore.kernel.org/r/20191005112806.13960-1-christian.brauner@ubuntu.com
> >
> > /* v2 */
> > - Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>:
> >   - fix the original double-checked locking using memory barriers
> >
> > /* v3 */
> > - Andrea Parri <parri.andrea@gmail.com>:
> >   - document memory barriers to make checkpatch happy
> > ---
> >  kernel/taskstats.c | 21 ++++++++++++---------
> >  1 file changed, 12 insertions(+), 9 deletions(-)
> >
> > diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> > index 13a0f2e6ebc2..978d7931fb65 100644
> > --- a/kernel/taskstats.c
> > +++ b/kernel/taskstats.c
> > @@ -554,24 +554,27 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
> >  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
> >  {
> >       struct signal_struct *sig = tsk->signal;
> > -     struct taskstats *stats;
> > +     struct taskstats *stats_new, *stats;
> >
> > -     if (sig->stats || thread_group_empty(tsk))
> > -             goto ret;
> > +     /* Pairs with smp_store_release() below. */
> > +     stats = READ_ONCE(sig->stats);
>
> This pairing suggests that the READ_ONCE() is heading an address
> dependency, but I fail to identify it: what is the target memory
> access of such a (putative) dependency?

I would assume callers of this function access *stats. So the
dependency is between loading stats and accessing *stats.

> > +     if (stats || thread_group_empty(tsk))
> > +             return stats;
> >
> >       /* No problem if kmem_cache_zalloc() fails */
> > -     stats = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
> > +     stats_new = kmem_cache_zalloc(taskstats_cache, GFP_KERNEL);
> >
> >       spin_lock_irq(&tsk->sighand->siglock);
> >       if (!sig->stats) {
> > -             sig->stats = stats;
> > -             stats = NULL;
> > +             /* Pairs with READ_ONCE() above. */
> > +             smp_store_release(&sig->stats, stats_new);
>
> This is intended to 'order' the _zalloc()  (zero initializazion)
> before the update of sig->stats, right?  what else am I missing?
>
> Thanks,
>   Andrea
>
>
> > +             stats_new = NULL;
> >       }
> >       spin_unlock_irq(&tsk->sighand->siglock);
> >
> > -     if (stats)
> > -             kmem_cache_free(taskstats_cache, stats);
> > -ret:
> > +     if (stats_new)
> > +             kmem_cache_free(taskstats_cache, stats_new);
> > +
> >       return sig->stats;
> >  }
> >
> > --
> > 2.23.0
> >
