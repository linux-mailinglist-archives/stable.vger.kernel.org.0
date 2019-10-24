Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C58E0E33D7
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 15:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393548AbfJXNVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 09:21:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38776 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730061AbfJXNVo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 09:21:44 -0400
Received: from [213.220.153.21] (helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1iNd3Z-0002J4-Se; Thu, 24 Oct 2019 13:21:37 +0000
Date:   Thu, 24 Oct 2019 15:21:37 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bsingharora@gmail.com,
        Marco Elver <elver@google.com>,
        stable <stable@vger.kernel.org>,
        syzbot <syzbot+c5d03165a1bd1dead0c1@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Subject: Re: [PATCH v6] taskstats: fix data-race
Message-ID: <20191024132136.jknzt7rgjssgv5b6@wittgenstein>
References: <20191009114809.8643-1-christian.brauner@ubuntu.com>
 <20191021113327.22365-1-christian.brauner@ubuntu.com>
 <20191023121603.GA16344@andrea.guest.corp.microsoft.com>
 <CACT4Y+Y86HFnQGHyxv+f32tKDJXnRxmL7jQ3tGxVcksvtK3L7Q@mail.gmail.com>
 <20191024113155.GA7406@andrea.guest.corp.microsoft.com>
 <CACT4Y+Z2-mm6Qk0cecJdiA5B_VsQ1v8k2z+RWrDQv6dTNFXFog@mail.gmail.com>
 <20191024130502.GA11335@andrea.guest.corp.microsoft.com>
 <CACT4Y+ahUr11pQQ7=dw80Abj5owUPnPdufbMYvsKLM6iDg5QQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACT4Y+ahUr11pQQ7=dw80Abj5owUPnPdufbMYvsKLM6iDg5QQg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 24, 2019 at 03:13:48PM +0200, Dmitry Vyukov wrote:
> On Thu, Oct 24, 2019 at 3:05 PM Andrea Parri <parri.andrea@gmail.com> wrote:
> >
> > On Thu, Oct 24, 2019 at 01:51:20PM +0200, Dmitry Vyukov wrote:
> > > On Thu, Oct 24, 2019 at 1:32 PM Andrea Parri <parri.andrea@gmail.com> wrote:
> > > >
> > > > > How these later loads can be completely independent of the pointer
> > > > > value? They need to obtain the pointer value from somewhere. And this
> > > > > can only be done by loaded it. And if a thread loads a pointer and
> > > > > then dereferences that pointer, that's a data/address dependency and
> > > > > we assume this is now covered by READ_ONCE.
> > > >
> > > > The "dependency" I was considering here is a dependency _between the
> > > > load of sig->stats in taskstats_tgid_alloc() and the (program-order)
> > > > later loads of *(sig->stats) in taskstats_exit().  Roughly speaking,
> > > > such a dependency should correspond to a dependency chain at the asm
> > > > or registers level from the first load to the later loads; e.g., in:
> > > >
> > > >   Thread [register r0 contains the address of sig->stats]
> > > >
> > > >   A: LOAD r1,[r0]       // LOAD_ACQUIRE sig->stats
> > > >      ...
> > > >   B: LOAD r2,[r0]       // LOAD *(sig->stats)
> > > >   C: LOAD r3,[r2]
> > > >
> > > > there would be no such dependency from A to C.  Compare, e.g., with:
> > > >
> > > >   Thread [register r0 contains the address of sig->stats]
> > > >
> > > >   A: LOAD r1,[r0]       // LOAD_ACQUIRE sig->stats
> > > >      ...
> > > >   C: LOAD r3,[r1]       // LOAD *(sig->stats)
> > > >
> > > > AFAICT, there's no guarantee that the compilers will generate such a
> > > > dependency from the code under discussion.
> > >
> > > Fixing this by making A ACQUIRE looks like somewhat weird code pattern
> > > to me (though correct). B is what loads the address used to read
> > > indirect data, so B ought to be ACQUIRE (or LOAD-DEPENDS which we get
> > > from READ_ONCE).
> > >
> > > What you are suggesting is:
> > >
> > > addr = ptr.load(memory_order_acquire);
> > > if (addr) {
> > >   addr = ptr.load(memory_order_relaxed);
> > >   data = *addr;
> > > }
> > >
> > > whereas the canonical/non-convoluted form of this pattern is:
> > >
> > > addr = ptr.load(memory_order_consume);
> > > if (addr)
> > >   data = *addr;
> >
> > No, I'd rather be suggesting:
> >
> >   addr = ptr.load(memory_order_acquire);
> >   if (addr)
> >     data = *addr;
> >
> > since I'd not expect any form of encouragement to rely on "consume" or
> > on "READ_ONCE() + true-address-dependency" from myself.  ;-)
> 
> But why? I think kernel contains lots of such cases and it seems to be
> officially documented by the LKMM:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/explanation.txt
> address dependencies and ppo

You mean this section:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/explanation.txt#n955
and specifically:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/memory-model/Documentation/explanation.txt#n982
?
