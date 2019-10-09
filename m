Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E9F1D0E04
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 13:53:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbfJILx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 07:53:28 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58907 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfJILx2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Oct 2019 07:53:28 -0400
Received: from [79.140.115.128] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iIAX0-00013X-4J; Wed, 09 Oct 2019 11:53:26 +0000
Date:   Wed, 9 Oct 2019 13:53:25 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Marco Elver <elver@google.com>
Cc:     Andrea Parri <parri.andrea@gmail.com>, bsingharora@gmail.com,
        Dmitry Vyukov <dvyukov@google.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] taskstats: fix data-race
Message-ID: <20191009115324.iczitezqqkotpocj@wittgenstein>
References: <20191008154418.GA16972@andrea>
 <20191009113134.5171-1-christian.brauner@ubuntu.com>
 <CANpmjNMgVub_pSGVfjBOtXg1ufdBvpXC_XUTnvNyQeF17JSCSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CANpmjNMgVub_pSGVfjBOtXg1ufdBvpXC_XUTnvNyQeF17JSCSw@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 09, 2019 at 01:48:27PM +0200, Marco Elver wrote:
> On Wed, 9 Oct 2019 at 13:31, Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> >
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
> > The tasks reads sig->stats without holding sighand lock seeing garbage.
> >
> > cpu1:
> > task calls exit_group()
> >  do_exit()
> >  do_group_exit()
> >  taskstats_exit()
> >  taskstats_tgid_alloc()
> > The task takes sighand lock and assigns new stats to sig->stats.
> >
> > Fix this by using smp_load_acquire() and smp_store_release().
> >
> > Reported-by: syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com
> > Fixes: 34ec12349c8a ("taskstats: cleanup ->signal->stats allocation")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
> > Reviewed-by: Dmitry Vyukov <dvyukov@google.com>
> > ---
> > /* v1 */
> > Link: https://lore.kernel.org/r/20191005112806.13960-1-christian.brauner@ubuntu.com
> >
> > /* v2 */
> > Link: https://lore.kernel.org/r/20191006235216.7483-1-christian.brauner@ubuntu.com
> > - Dmitry Vyukov <dvyukov@google.com>, Marco Elver <elver@google.com>:
> >   - fix the original double-checked locking using memory barriers
> >
> > /* v3 */
> > Link: https://lore.kernel.org/r/20191007110117.1096-1-christian.brauner@ubuntu.com/
> > - Andrea Parri <parri.andrea@gmail.com>:
> >   - document memory barriers to make checkpatch happy
> >
> > /* v4 */
> > - Andrea Parri <parri.andrea@gmail.com>:
> >   - use smp_load_acquire(), not READ_ONCE()
> >   - update commit message
> 
> Acked-by: Marco Elver <elver@google.com>
> 
> Note that this now looks almost like what I suggested, except the

Right, I think we all just needed to get our heads clear about what
exactly is happening here. This codepath is not a very prominent one. :)

> return at the end of the function is accessing sig->stats again. In
> this case, it seems it's fine assuming sig->stats cannot be written
> elsewhere. Just wanted to point it out to make sure it's considered.

Yes, I considered that but thanks for mentioning it.

Note that this patch has a bug. It should be
smp_load_acquire(&sig->stats) and not smp_load_acquire(sig->stats).
I accidently didn't automatically recompile the patchset after the last
change I made. Andrea thankfully caught this.

Thanks!
Christian
