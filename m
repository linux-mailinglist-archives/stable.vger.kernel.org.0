Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F67E2E6A1B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 19:52:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgL1SvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 13:51:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:37994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbgL1SvP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 13:51:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BD4222B45
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 18:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609181434;
        bh=6YqwLVWGZ7ybOF3Ak7Rutxzpv/0P68frB/ABbtNRx2A=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=AaTJQGDx58ZoPUwIflwplFjWLnIFD807YZxgy/wYiFKWT1laWnPttoNEf6fcvtHHU
         +1CZ1iOYgjTejeFWS++DiH29gBHSy8svPa+lVVWyGWKVVVrLK0b4deZrIMXHHkUZav
         Cbh7w6P49o2HymZPH6nKYAV5V/DIz4ohgdngS6R+6FETrskhWBi87AJduXHvoFDd99
         f4+7QHkuPbqsmYqNWe6Q41r1iNa231xtvKSnlNbahIH/zwC+CDwxNnAeD2oXFPcWSf
         M9A+zrh7bnLWxYVHHSprHpra4oKbHl/w+xYPE2jSLv3Y/SWoptfm2qEu1lf6V4xPqh
         2uJEMxqBjqKBw==
Received: by mail-wm1-f52.google.com with SMTP id 3so256544wmg.4
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 10:50:34 -0800 (PST)
X-Gm-Message-State: AOAM530wKqSzJT4GJNjFqO00VFeH+5dFjCMH9bFhI/PsMtCfa6Y0cLlr
        4Au/yomnFynWwpDE40ApowHb8lCR9/EmO/RbZBAx6Q==
X-Google-Smtp-Source: ABdhPJy2pGQl+qZycpaVqhSpXhzX+qb6KsnFF26UHOwhZZYqp85PUh6OZSCBMuyYlamRKZ+/qeujbpFqUc9sglmMa5s=
X-Received: by 2002:a7b:c40b:: with SMTP id k11mr257558wmi.36.1609181432795;
 Mon, 28 Dec 2020 10:50:32 -0800 (PST)
MIME-Version: 1.0
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org>
 <1836294649.3345.1609100294833.JavaMail.zimbra@efficios.com>
 <CALCETrVdcn2r2Jvd1=-bM=FQ8KbX4aH-v4ytdojL7r7Nb6k8YQ@mail.gmail.com>
 <20201228102537.GG1551@shell.armlinux.org.uk> <CALCETrWQx0qwthBc5pJBxs2PWAQo-roAz-6g=7HOs+dsiokVsg@mail.gmail.com>
 <CAG48ez0YZ_iy6qZpdGUj38wqeg_NzLHHhU-mBCBf5hcopYGVPg@mail.gmail.com>
In-Reply-To: <CAG48ez0YZ_iy6qZpdGUj38wqeg_NzLHHhU-mBCBf5hcopYGVPg@mail.gmail.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 28 Dec 2020 10:50:20 -0800
X-Gmail-Original-Message-ID: <CALCETrV_0+1S6PTxY20ex5au8oNz5TVxn+HXvxta-ZVv03nckQ@mail.gmail.com>
Message-ID: <CALCETrV_0+1S6PTxY20ex5au8oNz5TVxn+HXvxta-ZVv03nckQ@mail.gmail.com>
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
To:     Jann Horn <jannh@google.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Will Deacon <will@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        x86 <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 10:30 AM Jann Horn <jannh@google.com> wrote:
>
> On Mon, Dec 28, 2020 at 6:14 PM Andy Lutomirski <luto@kernel.org> wrote:
> > On Mon, Dec 28, 2020 at 2:25 AM Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Sun, Dec 27, 2020 at 01:36:13PM -0800, Andy Lutomirski wrote:
> > > > On Sun, Dec 27, 2020 at 12:18 PM Mathieu Desnoyers
> > > > <mathieu.desnoyers@efficios.com> wrote:
> > > > >
> > > > > ----- On Dec 27, 2020, at 1:28 PM, Andy Lutomirski luto@kernel.org wrote:
> > > > >
> > > >
> > > > > >
> > > > > > I admit that I'm rather surprised that the code worked at all on arm64,
> > > > > > and I'm suspicious that it has never been very well tested.  My apologies
> > > > > > for not reviewing this more carefully in the first place.
> > > > >
> > > > > Please refer to Documentation/features/sched/membarrier-sync-core/arch-support.txt
> > > > >
> > > > > It clearly states that only arm, arm64, powerpc and x86 support the membarrier
> > > > > sync core feature as of now:
> > > >
> > > > Sigh, I missed arm (32).  Russell or ARM folks, what's the right
> > > > incantation to make the CPU notice instruction changes initiated by
> > > > other cores on 32-bit ARM?
> > >
> > > You need to call flush_icache_range(), since the changes need to be
> > > flushed from the data cache to the point of unification (of the Harvard
> > > I and D), and the instruction cache needs to be invalidated so it can
> > > then see those updated instructions. This will also take care of the
> > > necessary barriers that the CPU requires for you.
> >
> > With what parameters?   From looking at the header, this is for the
> > case in which the kernel writes some memory and then intends to
> > execute it.  That's not what membarrier() does at all.  membarrier()
> > works like this:
> >
> > User thread 1:
> >
> > write to RWX memory *or* write to an RW alias of an X region.
> > membarrier(...);
> > somehow tell thread 2 that we're ready (with a store release, perhaps,
> > or even just a relaxed store.)
> >
> > User thread 2:
> >
> > wait for the indication from thread 1.
> > barrier();
> > jump to the code.
> >
> > membarrier() is, for better or for worse, not given a range of addresses.
> >
> > On x86, the documentation is a bit weak, but a strict reading
> > indicates that thread 2 must execute a serializing instruction at some
> > point after thread 1 writes the code and before thread 2 runs it.
> > membarrier() does this by sending an IPI and ensuring that a
> > "serializing" instruction (thanks for great terminology, Intel) is
> > executed.  Note that flush_icache_range() is a no-op on x86, and I've
> > asked Intel's architects to please clarify their precise rules.  No
> > response yet.
> >
> > On arm64, flush_icache_range() seems to send an IPI, and that's not
> > what I want.  membarrier() already does an IPI.
>
> After chatting with rmk about this (but without claiming that any of
> this is his opinion), based on the manpage, I think membarrier()
> currently doesn't really claim to be synchronizing caches? It just
> serializes cores. So arguably if userspace wants to use membarrier()
> to synchronize code changes, userspace should first do the code
> change, then flush icache as appropriate for the architecture, and
> then do the membarrier() to ensure that the old code is unused?

I haven't the faintest clue what "serializes cores" means.  It seems
to be a bit of a mishmash of x86 SDM terminology and Linux x86
"sync_core" terminology.  The latter means very little to me, even as
an x86 person.

I'm moderately confident that the *intent* is that a multithreaded
program can write some JIT code to memory, do this membarrier()
operation, and then execute the code, and it will work.  Maybe it's
even intended to work cross-architecture without any additional help
from the program.  But maybe the existing API is simply incorrect for
this.

>
> For 32-bit arm, rmk pointed out that that would be the cacheflush()
> syscall. That might cause you to end up with two IPIs instead of one
> in total, but we probably don't care _that_ much about extra IPIs on
> 32-bit arm?
>
> For arm64, I believe userspace can flush icache across the entire
> system with some instructions from userspace - "DC CVAU" followed by
> "DSB ISH", or something like that, I think? (See e.g.
> compat_arm_syscall(), the arm64 compat code that implements the 32-bit
> arm cacheflush() syscall.)

I have no idea what DC anything does.   Based on my very cursory
reading of the manual, ISB is the right approach, but I don't pretend
I understand all the details.
