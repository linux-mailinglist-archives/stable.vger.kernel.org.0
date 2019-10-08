Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8BAF7CFC56
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 16:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbfJHOYU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 10:24:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57079 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbfJHOYU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 10:24:20 -0400
Received: from p2e585ebf.dip0.t-ipconnect.de ([46.88.94.191] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iHqPP-0007Ee-SD; Tue, 08 Oct 2019 14:24:15 +0000
Date:   Tue, 8 Oct 2019 16:24:14 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Andrea Parri <parri.andrea@gmail.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>, bsingharora@gmail.com,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] taskstats: fix data-race
Message-ID: <20191008142413.h5kczta7jo4ado6u@wittgenstein>
References: <20191007104039.GA16085@andrea.guest.corp.microsoft.com>
 <20191007110117.1096-1-christian.brauner@ubuntu.com>
 <20191007131804.GA19242@andrea.guest.corp.microsoft.com>
 <CACT4Y+YG23qbL16MYH3GTK4hOPsM9tDfbLzrTZ7k_ocR2ABa6A@mail.gmail.com>
 <20191007141432.GA22083@andrea.guest.corp.microsoft.com>
 <CACT4Y+avbYvtF9mHiX=R8Y2=YsP1_QsN6i_FpjLM7UxCKv6vxA@mail.gmail.com>
 <20191008142035.GA13564@andrea.guest.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191008142035.GA13564@andrea.guest.corp.microsoft.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 08, 2019 at 04:20:35PM +0200, Andrea Parri wrote:
> On Mon, Oct 07, 2019 at 04:18:26PM +0200, Dmitry Vyukov wrote:
> > On Mon, Oct 7, 2019 at 4:14 PM Andrea Parri <parri.andrea@gmail.com> wrote:
> > >
> > > > > >  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
> > > > > >  {
> > > > > >       struct signal_struct *sig = tsk->signal;
> > > > > > -     struct taskstats *stats;
> > > > > > +     struct taskstats *stats_new, *stats;
> > > > > >
> > > > > > -     if (sig->stats || thread_group_empty(tsk))
> > > > > > -             goto ret;
> > > > > > +     /* Pairs with smp_store_release() below. */
> > > > > > +     stats = READ_ONCE(sig->stats);
> > > > >
> > > > > This pairing suggests that the READ_ONCE() is heading an address
> > > > > dependency, but I fail to identify it: what is the target memory
> > > > > access of such a (putative) dependency?
> > > >
> > > > I would assume callers of this function access *stats. So the
> > > > dependency is between loading stats and accessing *stats.
> > >
> > > AFAICT, the only caller of the function in 5.4-rc2 is taskstats_exit(),
> > > which 'casts' the return value to a boolean (so I really don't see how
> > > any address dependency could be carried over/relied upon here).
> > 
> > This does not make sense.
> > 
> > But later taskstats_exit does:
> > 
> > memcpy(stats, tsk->signal->stats, sizeof(*stats));
> > 
> > Perhaps it's supposed to use stats returned by taskstats_tgid_alloc?
> 
> Seems reasonable to me.  If so, replacing the READ_ONCE() in question
> with an smp_load_acquire() might be the solution.  Thoughts?

I've done that already in my tree yesterday. I can resend for another
review if you'd prefer.

Christian
