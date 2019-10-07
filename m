Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11625CE458
	for <lists+stable@lfdr.de>; Mon,  7 Oct 2019 15:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfJGNze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Oct 2019 09:55:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50164 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727442AbfJGNze (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Oct 2019 09:55:34 -0400
Received: from [185.66.195.251] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iHTU1-00010o-QS; Mon, 07 Oct 2019 13:55:29 +0000
Date:   Mon, 7 Oct 2019 15:55:28 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Andrea Parri <parri.andrea@gmail.com>, bsingharora@gmail.com,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH v2] taskstats: fix data-race
Message-ID: <20191007135527.qd5ibfyajnihsrsh@wittgenstein>
References: <20191007104039.GA16085@andrea.guest.corp.microsoft.com>
 <20191007110117.1096-1-christian.brauner@ubuntu.com>
 <20191007131804.GA19242@andrea.guest.corp.microsoft.com>
 <CACT4Y+YG23qbL16MYH3GTK4hOPsM9tDfbLzrTZ7k_ocR2ABa6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACT4Y+YG23qbL16MYH3GTK4hOPsM9tDfbLzrTZ7k_ocR2ABa6A@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 07, 2019 at 03:50:47PM +0200, Dmitry Vyukov wrote:
> On Mon, Oct 7, 2019 at 3:18 PM Andrea Parri <parri.andrea@gmail.com> wrote:
> >
> > On Mon, Oct 07, 2019 at 01:01:17PM +0200, Christian Brauner wrote:
> > > When assiging and testing taskstats in taskstats_exit() there's a race
> > > when writing and reading sig->stats when a thread-group with more than
> > > one thread exits:
> > >
> > > cpu0:
> > > thread catches fatal signal and whole thread-group gets taken down
> > >  do_exit()
> > >  do_group_exit()
> > >  taskstats_exit()
> > >  taskstats_tgid_alloc()
> > > The tasks reads sig->stats holding sighand lock seeing garbage.
> >
> > You meant "without holding sighand lock" here, right?
> >
> >
> > >
> > > cpu1:
> > > task calls exit_group()
> > >  do_exit()
> > >  do_group_exit()
> > >  taskstats_exit()
> > >  taskstats_tgid_alloc()
> > > The task takes sighand lock and assigns new stats to sig->stats.
> > >
> > > Fix this by using READ_ONCE() and smp_store_release().
> > >
> > > Reported-by: syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com
> > > Fixes: 34ec12349c8a ("taskstats: cleanup ->signal->stats allocation")
> > > Cc: stable@vger.kernel.org
> > > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > > Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
> > > Link: https://lore.kernel.org/r/20191006235216.7483-1-christian.brauner@ubuntu.com
> > > ---
> > > /* v1 */
> > > Link: https://lore.kernel.org/r/20191005112806.13960-1-christian.brauner@ubuntu.com
> > >
> > > /* v2 */
> > > - Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>:
> > >   - fix the original double-checked locking using memory barriers
> > >
> > > /* v3 */
> > > - Andrea Parri <parri.andrea@gmail.com>:
> > >   - document memory barriers to make checkpatch happy
> > > ---
> > >  kernel/taskstats.c | 21 ++++++++++++---------
> > >  1 file changed, 12 insertions(+), 9 deletions(-)
> > >
> > > diff --git a/kernel/taskstats.c b/kernel/taskstats.c
> > > index 13a0f2e6ebc2..978d7931fb65 100644
> > > --- a/kernel/taskstats.c
> > > +++ b/kernel/taskstats.c
> > > @@ -554,24 +554,27 @@ static int taskstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
> > >  static struct taskstats *taskstats_tgid_alloc(struct task_struct *tsk)
> > >  {
> > >       struct signal_struct *sig = tsk->signal;
> > > -     struct taskstats *stats;
> > > +     struct taskstats *stats_new, *stats;
> > >
> > > -     if (sig->stats || thread_group_empty(tsk))
> > > -             goto ret;
> > > +     /* Pairs with smp_store_release() below. */
> > > +     stats = READ_ONCE(sig->stats);
> >
> > This pairing suggests that the READ_ONCE() is heading an address
> > dependency, but I fail to identify it: what is the target memory
> > access of such a (putative) dependency?
> 
> I would assume callers of this function access *stats. So the
> dependency is between loading stats and accessing *stats.

Right, but why READ_ONCE() and not smp_load_acquire here?

Christian
