Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C340ACE4F6
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 16:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727903AbfJGOSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 10:18:39 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34061 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727490AbfJGOSj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 10:18:39 -0400
Received: by mail-qt1-f195.google.com with SMTP id 3so19378469qta.1
        for <stable@vger.kernel.org>; Mon, 07 Oct 2019 07:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L0aGd5iGzy7oTR3viDB2jBKpSZXW/T11Qmx88FocAp0=;
        b=BLIJFSTB/G0hTxSyuUcChHQTUG4TktVTAMCyTFc/UM7op4sD0B69rpMXeOIiGf6kRI
         Z1zzsxjlfbahk/UR802rSVa+3rdsfua1CFa44/pN48dPKOoNoEx8PZVnmS4QBu1yA53o
         4HvslXk7uZ8b75qpxBOGtgVZLEuVRfY1ZoBu/2z3PxABOv3H3/r0ZIqoMMaJr85jAPxI
         al7Mm3ECcO+MVagXddXp6mQFUludyxrKGHF6IqEhA5qe8VwsK5a/NOOUtYcl+Hv6KVAl
         6gvDtZsTbtfIH7ZBl5+HUZtwiwVEjYu6kSq9BRnUvKZzNcRksoDGCvQBYI/dJkAulJjV
         6z1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L0aGd5iGzy7oTR3viDB2jBKpSZXW/T11Qmx88FocAp0=;
        b=pm2xYGlE64t/yx+IMm7oK0N8bP39KHQj1FUVLmBJ8dDrblRjflCiXWhlkDw969EJoA
         8OI8wlXdKnb/pwY9CG7TnBKt8wXADTk7RqKVgwAy/TBICy9eMwPOhJOtyfnnnhWmO488
         HgMsBiARNmEVbkuiPtdJ9Tto69ufenznQlLbAVi3Iio/CsAhb7rwhzKsoDw6AUFaDmVb
         AD/HEIoF3TEIqYN8aEdKJ7H//WjttqDcj+eVSImHrHzg0uPrAVIWIu/g+eL8n+kmn1Mi
         xDepfjrpLG1z72SW0FnXnR6AKeD+xQ3DdKOUF922wP2ygfuVuoae+UTW7oq0BU2OD81C
         pItA==
X-Gm-Message-State: APjAAAVceGfrSFol17LkgJep6rOq4W+xJPPhIJAjCgy/yS4N7j5xe0wb
        +Z2CsytveV6+9JdBbse64usvpABF5fogIVVYFCwmbQ==
X-Google-Smtp-Source: APXvYqyCkMof+lfWuP5KA6qlI2H3Fjv46/wLvsY4rIyhiAcrcHG0FOMjuLe5Y/7mZugp/EJEMPLLjieK3rPinWTysy4=
X-Received: by 2002:ac8:7646:: with SMTP id i6mr30548962qtr.50.1570457917819;
 Mon, 07 Oct 2019 07:18:37 -0700 (PDT)
MIME-Version: 1.0
References: <20191007104039.GA16085@andrea.guest.corp.microsoft.com>
 <20191007110117.1096-1-christian.brauner@ubuntu.com> <20191007131804.GA19242@andrea.guest.corp.microsoft.com>
 <CACT4Y+YG23qbL16MYH3GTK4hOPsM9tDfbLzrTZ7k_ocR2ABa6A@mail.gmail.com> <20191007141432.GA22083@andrea.guest.corp.microsoft.com>
In-Reply-To: <20191007141432.GA22083@andrea.guest.corp.microsoft.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 7 Oct 2019 16:18:26 +0200
Message-ID: <CACT4Y+avbYvtF9mHiX=R8Y2=YsP1_QsN6i_FpjLM7UxCKv6vxA@mail.gmail.com>
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

On Mon, Oct 7, 2019 at 4:14 PM Andrea Parri <parri.andrea@gmail.com> wrote:
>
> > > >  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
> > > >  {
> > > >       struct signal_struct *sig = tsk->signal;
> > > > -     struct taskstats *stats;
> > > > +     struct taskstats *stats_new, *stats;
> > > >
> > > > -     if (sig->stats || thread_group_empty(tsk))
> > > > -             goto ret;
> > > > +     /* Pairs with smp_store_release() below. */
> > > > +     stats = READ_ONCE(sig->stats);
> > >
> > > This pairing suggests that the READ_ONCE() is heading an address
> > > dependency, but I fail to identify it: what is the target memory
> > > access of such a (putative) dependency?
> >
> > I would assume callers of this function access *stats. So the
> > dependency is between loading stats and accessing *stats.
>
> AFAICT, the only caller of the function in 5.4-rc2 is taskstats_exit(),
> which 'casts' the return value to a boolean (so I really don't see how
> any address dependency could be carried over/relied upon here).

This does not make sense.

But later taskstats_exit does:

memcpy(stats, tsk->signal->stats, sizeof(*stats));

Perhaps it's supposed to use stats returned by taskstats_tgid_alloc?
