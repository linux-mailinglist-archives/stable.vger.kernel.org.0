Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE3F92E6CE6
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 01:57:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729724AbgL2A5c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 19:57:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729895AbgL2A5c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 19:57:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2950B207D0
        for <stable@vger.kernel.org>; Tue, 29 Dec 2020 00:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609203411;
        bh=5ea1GP7R9ThOqNi8XEr5gxNXJU/ubpRT/SpIDHm2c0M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bOnhgK3ds/goNLDhJWb0r7fRqd65KN5BXdE4oYSm7k5zkRDAV/1pooaKncbxQMwqf
         fOUNJPfyVyB6nkeEQNc6maqX0cSIgI+eyBG9L1sgaBgPd6EuwaKhSYBROHQnL4TJGL
         Cq3PeZ3nvlkFmpumXZ6nt9sK04hHjLnE7fJk3gNqGhoR0Vn8m2i5GbX4pO+WXnbinV
         CGz/aqbTkNVecOveVLht/LqNxen/d+Me/6DXPqdBMRvND/LlObgSwJ3/9TqmR0Rtc4
         h04e4s9Al0uBq8gpPaU+BYRPynbzikeks9DGeoUdJshRNB307Y1HbkY/YqTEuVF/FC
         wa+4hCR8K1IBA==
Received: by mail-wm1-f48.google.com with SMTP id 190so806646wmz.0
        for <stable@vger.kernel.org>; Mon, 28 Dec 2020 16:56:51 -0800 (PST)
X-Gm-Message-State: AOAM5304qeCwTQPLDwqCoIcm/HKL9u1NRybRX800VGwza7c5gQtHxbJ5
        Hm58jd9E9HEsTvBC6FMHSy4b97b/xelfFRh/aSgfBg==
X-Google-Smtp-Source: ABdhPJwWLZzdWjQFkiOrEi0hD/sw8QEhosbYgv30yS3Mb/zDERHlmT9dUrmSuLKTMJNeve8TtWbk4bbcTCBfJLD539U=
X-Received: by 2002:a1c:6741:: with SMTP id b62mr1172357wmc.21.1609203409735;
 Mon, 28 Dec 2020 16:56:49 -0800 (PST)
MIME-Version: 1.0
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org>
 <1836294649.3345.1609100294833.JavaMail.zimbra@efficios.com>
 <CALCETrVdcn2r2Jvd1=-bM=FQ8KbX4aH-v4ytdojL7r7Nb6k8YQ@mail.gmail.com>
 <20201228102537.GG1551@shell.armlinux.org.uk> <CALCETrWQx0qwthBc5pJBxs2PWAQo-roAz-6g=7HOs+dsiokVsg@mail.gmail.com>
 <CAG48ez0YZ_iy6qZpdGUj38wqeg_NzLHHhU-mBCBf5hcopYGVPg@mail.gmail.com>
 <20201228190852.GI1551@shell.armlinux.org.uk> <CALCETrVpvrBufrJgXNY=ogtZQLo7zgxQmD7k9eVCFjcdcvarmA@mail.gmail.com>
 <1086654515.3607.1609187556216.JavaMail.zimbra@efficios.com>
 <CALCETrXx3Xe+4Y6WM-mp0cTUU=r3bW6PV2b25yA8bm1Gvak6wQ@mail.gmail.com> <1609200902.me5niwm2t6.astroid@bobo.none>
In-Reply-To: <1609200902.me5niwm2t6.astroid@bobo.none>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 28 Dec 2020 16:56:36 -0800
X-Gmail-Original-Message-ID: <CALCETrX6MOqmN5_jhyO1jJB7M3_T+hbomjxPYZLJmLVNmXAVzA@mail.gmail.com>
Message-ID: <CALCETrX6MOqmN5_jhyO1jJB7M3_T+hbomjxPYZLJmLVNmXAVzA@mail.gmail.com>
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jann Horn <jannh@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "Russell King, ARM Linux" <linux@armlinux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        paulmck <paulmck@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        x86 <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 4:36 PM Nicholas Piggin <npiggin@gmail.com> wrote:
>
> Excerpts from Andy Lutomirski's message of December 29, 2020 7:06 am:
> > On Mon, Dec 28, 2020 at 12:32 PM Mathieu Desnoyers
> > <mathieu.desnoyers@efficios.com> wrote:
> >>
> >> ----- On Dec 28, 2020, at 2:44 PM, Andy Lutomirski luto@kernel.org wrote:
> >>
> >> > On Mon, Dec 28, 2020 at 11:09 AM Russell King - ARM Linux admin
> >> > <linux@armlinux.org.uk> wrote:
> >> >>
> >> >> On Mon, Dec 28, 2020 at 07:29:34PM +0100, Jann Horn wrote:
> >> >> > After chatting with rmk about this (but without claiming that any of
> >> >> > this is his opinion), based on the manpage, I think membarrier()
> >> >> > currently doesn't really claim to be synchronizing caches? It just
> >> >> > serializes cores. So arguably if userspace wants to use membarrier()
> >> >> > to synchronize code changes, userspace should first do the code
> >> >> > change, then flush icache as appropriate for the architecture, and
> >> >> > then do the membarrier() to ensure that the old code is unused?
> >>
> >> ^ exactly, yes.
> >>
> >> >> >
> >> >> > For 32-bit arm, rmk pointed out that that would be the cacheflush()
> >> >> > syscall. That might cause you to end up with two IPIs instead of one
> >> >> > in total, but we probably don't care _that_ much about extra IPIs on
> >> >> > 32-bit arm?
> >>
> >> This was the original thinking, yes. The cacheflush IPI will flush specific
> >> regions of code, and the membarrier IPI issues context synchronizing
> >> instructions.
>
> APIs should be written in terms of the service they provide to
> userspace, and in highest level terms as possible, rather than directing
> hardware to do some low level operation. Unfortunately we're stuck with
> this for now. We could deprecate it and replace it though.
>
> If userspace wants to modify code and ensure that after the system call
> returns then no other thread will be executing the previous code, then
> there should be an API for that. It could actually combine the two IPIs
> into one for architectures that require both too.

I agree.  The membarrier API for SYNC_CORE is pretty nasty.  I would
much prefer a real API for JITs to use.

>
> >>
> >> Architectures with coherent i/d caches don't need the cacheflush step.
> >
> > There are different levels of coherency -- VIVT architectures may have
> > differing requirements compared to PIPT, etc.
> >
> > In any case, I feel like the approach taken by the documentation is
> > fundamentally confusing.  Architectures don't all speak the same
> > language  How about something like:
> >
> > The SYNC_CORE operation causes all threads in the caller's address
> > space (including the caller) to execute an architecture-defined
> > barrier operation.  membarrier() will ensure that this barrier is
> > executed at a time such that all data writes done by the calling
> > thread before membarrier() are made visible by the barrier.
> > Additional architecture-dependent cache management operations may be
> > required to use this for JIT code.
>
> As said this isn't what SYNC_CORE does, and it's not what powerpc
> context synchronizing instructions do either, it will very much
> re-order visibility of stores around such an instruction.

Perhaps the docs should be entirely arch-specific.  It may well be
impossible to state what it does in an arch-neutral way.

>
> A thread completes store instructions into a store queue, which is
> as far as a context synchronizing event goes. Visibility comes at
> some indeterminite time later.

As currently implemented, it has the same visibility semantics as
regular membarrier, too.  So if I do:

a = 1;
membarrier(SYNC_CORE);
b = 1;

and another thread does:

while (READ_ONCE(b) != 1)
  ;
barrier();
assert(a == 1);

then the assertion will pass.  Similarly, one can do this, I hope:

memcpy(codeptr, [some new instructions], len);
arch_dependent_cache_flush(codeptr, len);
membarrier(SYNC_CORE);
ready = 1;

and another thread does:

while (READ_ONCE(ready) != 1)
  ;
barrier();
(*codeptr)();

arch_dependent_cache_flush is a nop on x86.  On arm and arm64, it
appears to be a syscall, although maybe arm64 can do it from
userspace.  I still don't know what it is on powerpc.

Even using the term "cache" here is misleading.  x86 chips have all
kinds of barely-documented instruction caches, and they have varying
degrees of coherency.  The architecture actually promises that, if you
do a certain incantation, then you get the desired result.
membarrier() allows a user to do this incantation.  But trying to
replicate the incantation verbatim on an architecture like ARM is
insufficient, and trying to flush the things that are documented as
being caches on x86 is expensive and a complete waste of time on x86.
When you write some JIT code, you do *not* want to flush it all the
way to main memory, especially on CPUs don't have the ability to write
back invalidating.  (That's most CPUs.)

Even on x86, I suspect that the various decoded insn caches are rather
more coherent than documented, and I have questions in to Intel about
this.  No answers yet.

So perhaps the right approach is to say that membarrier() helps you
perform the architecture-specific sequence of steps needed to safely
modify code.  On x86, you use it like this.  On arm64, you do this
other thing.  On powerpc, you do something else.

>
> I would be surprised if x86's serializing instructions were different
> than powerpc. rdtsc ordering or flushing stores to cache would be
> surprising.
>

At the very least, x86 has several levels of what ARM might call
"context synchronization" AFAICT.  STAC, CLAC, and POPF do a form of
context synchronization in that the changes they cause to the MMU take
effect immediately, but they are not documented as synchronizing the
instruction stream.  "Serializing" instructions do all kinds of
things, not all of which may be architecturally visible at all.
MFENCE and LFENCE do various complicated things, and LFENCE has magic
retroactive capabilities on old CPUs that were not documented when
those CPUs were released.  SFENCE does a different form of
synchronization entirely.  LOCK does something else.  (The
relationship between LOCK and MFENCE is confusing at best.)  RDTSC
doesn't serialize anything at all, but RDTSCP does provide a form of
serialization that's kind of ilke LFENCE.  It's a mess.  Even the
manuals are inconsistent about what "serialize" means.  JMP has its
own magic on x86, but only on very very old CPUs.

The specific instruction that flushes everything into the coherency
domain is SFENCE, and SFENCE is not, for normal purposes, needed for
self- or cross-modifying code.
