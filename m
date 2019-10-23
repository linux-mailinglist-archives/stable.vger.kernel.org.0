Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8C6E1BEB
	for <lists+stable@lfdr.de>; Wed, 23 Oct 2019 15:12:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405668AbfJWNL5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Oct 2019 09:11:57 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32898 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405664AbfJWNL5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Oct 2019 09:11:57 -0400
Received: from [79.140.115.187] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iNGQa-0001WN-Gw; Wed, 23 Oct 2019 13:11:52 +0000
Date:   Wed, 23 Oct 2019 15:11:51 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Dmitry Vyukov <dvyukov@google.com>, Will Deacon <will@kernel.org>
Cc:     Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bsingharora@gmail.com,
        Marco Elver <elver@google.com>,
        stable <stable@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH v6] taskstats: fix data-race
Message-ID: <20191023131151.ajgnbcvnec3ouc6y@wittgenstein>
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com>
 <20191023121603.GA16344@andrea.guest.corp.microsoft.com>
 <CACT4Y+Y86HFnQGHyxv+f32tKDJXnRxmL7jQ3tGxVcksvtK3L7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACT4Y+Y86HFnQGHyxv+f32tKDJXnRxmL7jQ3tGxVcksvtK3L7Q@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 23, 2019 at 02:39:55PM +0200, Dmitry Vyukov wrote:
> On Wed, Oct 23, 2019 at 2:16 PM Andrea Parri <parri.andrea@gmail.com> wrote:
> >
> > On Mon, Oct 21, 2019 at 01:33:27PM +0200, Christian Brauner wrote:
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
> > > The tasks reads sig->stats without holding sighand lock.
> > >
> > > cpu1:
> > > task calls exit_group()
> > >  do_exit()
> > >  do_group_exit()
> > >  taskstats_exit()
> > >  taskstats_tgid_alloc()
> > > The task takes sighand lock and assigns new stats to sig->stats.
> > >
> > > The first approach used smp_load_acquire() and smp_store_release().
> > > However, after having discussed this it seems that the data dependency
> > > for kmem_cache_alloc() would be fixed by WRITE_ONCE().
> > > Furthermore, the smp_load_acquire() would only manage to order the stats
> > > check before the thread_group_empty() check. So it seems just using
> > > READ_ONCE() and WRITE_ONCE() will do the job and I wanted to bring this
> > > up for discussion at least.
> >
> > Mmh, the RELEASE was intended to order the memory initialization in
> > kmem_cache_zalloc() with the later ->stats pointer assignment; AFAICT,
> > there is no data dependency between such memory accesses.
> 
> I agree. This needs smp_store_release. The latest version that I
> looked at contained:
> smp_store_release(&sig->stats, stats_new);

This is what really makes me wonder. Can the compiler really re-order
the kmem_cache_zalloc() call with the assignment. If that's really the
case then shouldn't all allocation functions have compiler barriers in
them? This then seems like a very generic problem.

> 
> > Correspondingly, the ACQUIRE was intended to order the ->stats pointer
> > load with later, _independent dereferences of the same pointer; the
> > latter are, e.g., in taskstats_exit() (but not thread_group_empty()).
> 
> How these later loads can be completely independent of the pointer
> value? They need to obtain the pointer value from somewhere. And this
> can only be done by loaded it. And if a thread loads a pointer and
> then dereferences that pointer, that's a data/address dependency and
> we assume this is now covered by READ_ONCE.
> Or these later loads of the pointer can also race with the store? If

To clarify, later loads as in taskstats_exit() and thread_group_empty(),
not the later load in the double-checked locking case.

> so, I think they also need to use READ_ONCE (rather than turn this earlier
> pointer load into acquire).

Using READ_ONCE() in the alloc, taskstat_exit(), and
thread_group_empty() case.

Christian
