Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2F72E6BF2
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729372AbgL1Wzt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:49 -0500
Received: from mail.efficios.com ([167.114.26.124]:55130 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729432AbgL1Uku (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 15:40:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 292AF276205;
        Mon, 28 Dec 2020 15:40:09 -0500 (EST)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id d0T0fMId4ntj; Mon, 28 Dec 2020 15:40:08 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 69EA2276204;
        Mon, 28 Dec 2020 15:40:08 -0500 (EST)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com 69EA2276204
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1609188008;
        bh=UgWmbg2EX8zTOBr1CwHnUnmu/w1dT3XRq5U7SJqAVeA=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=ES/62h0wCyG1JfiEAbAzGiR73TCRhhXns6cV1Q6DDaaehwrJf9Hl9RikiqFhW1/dp
         d/X0Yb6JScC4Q0van6sPkU+vGrA0E+Qa8uL37o+Lsz0YwsONkYyKdupR3+rEonw4Bm
         EdVubWkJF/dhgVf7zkr4tDk0dpbqQETpCIxDiQ0dISFbWDvxbiieK29kHxsqMaPba5
         14Iz4mGfmywqGNIhWiW4kyWvEsG11qYlFT9gayoxE8yywcq5fIxNNdgbRgcAimEC/l
         Q4rcT+qEN3bG3cpc0qNuHGlE5A51HfqS7Nxa4ibmQQ++M0ty/9eutIuL7J2wozeHCr
         K+XCqQP+yCmgA==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 0iOmawGnLXnC; Mon, 28 Dec 2020 15:40:08 -0500 (EST)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id 4C97327609C;
        Mon, 28 Dec 2020 15:40:08 -0500 (EST)
Date:   Mon, 28 Dec 2020 15:40:08 -0500 (EST)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     "Russell King, ARM Linux" <linux@armlinux.org.uk>
Cc:     Andy Lutomirski <luto@kernel.org>, Jann Horn <jannh@google.com>,
        Will Deacon <will@kernel.org>, x86 <x86@kernel.org>,
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
Message-ID: <1353323563.3624.1609188008201.JavaMail.zimbra@efficios.com>
In-Reply-To: <20201228202451.GJ1551@shell.armlinux.org.uk>
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org> <CALCETrVdcn2r2Jvd1=-bM=FQ8KbX4aH-v4ytdojL7r7Nb6k8YQ@mail.gmail.com> <20201228102537.GG1551@shell.armlinux.org.uk> <CALCETrWQx0qwthBc5pJBxs2PWAQo-roAz-6g=7HOs+dsiokVsg@mail.gmail.com> <CAG48ez0YZ_iy6qZpdGUj38wqeg_NzLHHhU-mBCBf5hcopYGVPg@mail.gmail.com> <20201228190852.GI1551@shell.armlinux.org.uk> <CALCETrVpvrBufrJgXNY=ogtZQLo7zgxQmD7k9eVCFjcdcvarmA@mail.gmail.com> <20201228202451.GJ1551@shell.armlinux.org.uk>
Subject: Re: [RFC please help] membarrier: Rewrite
 sync_core_before_usermode()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3991 (ZimbraWebClient - FF84 (Linux)/8.8.15_GA_3980)
Thread-Topic: membarrier: Rewrite sync_core_before_usermode()
Thread-Index: s76Adj09DxnFzilBjlT7pOTaN9zYpQ==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- On Dec 28, 2020, at 3:24 PM, Russell King, ARM Linux linux@armlinux.o=
rg.uk wrote:

> On Mon, Dec 28, 2020 at 11:44:33AM -0800, Andy Lutomirski wrote:
>> On Mon, Dec 28, 2020 at 11:09 AM Russell King - ARM Linux admin
>> <linux@armlinux.org.uk> wrote:
>> >
>> > On Mon, Dec 28, 2020 at 07:29:34PM +0100, Jann Horn wrote:
>> > > After chatting with rmk about this (but without claiming that any of
>> > > this is his opinion), based on the manpage, I think membarrier()
>> > > currently doesn't really claim to be synchronizing caches? It just
>> > > serializes cores. So arguably if userspace wants to use membarrier()
>> > > to synchronize code changes, userspace should first do the code
>> > > change, then flush icache as appropriate for the architecture, and
>> > > then do the membarrier() to ensure that the old code is unused?
>> > >
>> > > For 32-bit arm, rmk pointed out that that would be the cacheflush()
>> > > syscall. That might cause you to end up with two IPIs instead of one
>> > > in total, but we probably don't care _that_ much about extra IPIs on
>> > > 32-bit arm?
>> > >
>> > > For arm64, I believe userspace can flush icache across the entire
>> > > system with some instructions from userspace - "DC CVAU" followed by
>> > > "DSB ISH", or something like that, I think? (See e.g.
>> > > compat_arm_syscall(), the arm64 compat code that implements the 32-b=
it
>> > > arm cacheflush() syscall.)
>> >
>> > Note that the ARM cacheflush syscall calls flush_icache_user_range()
>> > over the range of addresses that userspace has passed - it's intention
>> > since day one is to support cases where userspace wants to change
>> > executable code.
>> >
>> > It will issue the appropriate write-backs to the data cache (DCCMVAU),
>> > the invalidates to the instruction cache (ICIMVAU), invalidate the
>> > branch target buffer (BPIALLIS or BPIALL as appropriate), and issue
>> > the appropriate barriers (DSB ISHST, ISB).
>> >
>> > Note that neither flush_icache_user_range() nor flush_icache_range()
>> > result in IPIs; cache operations are broadcast across all CPUs (which
>> > is one of the minimums we require for SMP systems.)
>> >
>> > Now, that all said, I think the question that has to be asked is...
>> >
>> >         What is the basic purpose of membarrier?
>> >
>> > Is the purpose of it to provide memory barriers, or is it to provide
>> > memory coherence?
>> >
>> > If it's the former and not the latter, then cache flushes are out of
>> > scope, and expecting memory written to be visible to the instruction
>> > stream is totally out of scope of the membarrier interface, whether
>> > or not the writes happen on the same or a different CPU to the one
>> > executing the rewritten code.
>> >
>> > The documentation in the kernel does not seem to describe what it's
>> > supposed to be doing - the only thing I could find is this:
>> > Documentation/features/sched/membarrier-sync-core/arch-support.txt
>> > which describes it as "arch supports core serializing membarrier"
>> > whatever that means.
>> >
>> > Seems to be the standard and usual case of utterly poor to non-existen=
t
>> > documentation within the kernel tree, or even a pointer to where any
>> > useful documentation can be found.
>> >
>> > Reading the membarrier(2) man page, I find nothing in there that talks
>> > about any kind of cache coherency for self-modifying code - it only
>> > seems to be about _barriers_ and nothing more, and barriers alone do
>> > precisely nothing to save you from non-coherent Harvard caches.
>> >
>> > So, either Andy has a misunderstanding, or the man page is wrong, or
>> > my rudimentary understanding of what membarrier is supposed to be
>> > doing is wrong...
>>=20
>> Look at the latest man page:
>>=20
>> https://man7.org/linux/man-pages/man2/membarrier.2.html
>>=20
>> for MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE.  The result may not be
>> all that enlightening.
>=20
>       MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE (since Linux 4.16)
>              In  addition  to  providing  the  memory ordering guarantees=
 de=E2=96=A0
>              scribed in MEMBARRIER_CMD_PRIVATE_EXPEDITED,  upon  return  =
from
>              system call the calling thread has a guarantee that all its =
run=E2=96=A0
>              ning thread siblings have executed a core  serializing  inst=
ruc=E2=96=A0
>              tion.   This  guarantee is provided only for threads in the =
same
>              process as the calling thread.
>=20
>              The "expedited" commands complete faster than the  non-exped=
ited
>              ones,  they  never block, but have the downside of causing e=
xtra
>              overhead.
>=20
>              A process must register its intent to use the private  exped=
ited
>              sync core command prior to using it.
>=20
> This just says that the siblings have executed a serialising
> instruction, in other words a barrier. It makes no claims concerning
> cache coherency - and without some form of cache maintenance, there
> can be no expectation that the I and D streams to be coherent with
> each other.

Right, membarrier is not doing anything wrt I/D caches. On architectures
without coherent caches, users should use other system calls or instruction=
s
provided by the architecture to synchronize the appropriate address ranges.=
=20

> This description is also weird in another respect. "guarantee that
> all its running thread siblings have executed a core serializing
> instruction" ... "The expedited commands ... never block".
>=20
> So, the core executing this call is not allowed to block, but the
> other part indicates that the other CPUs _have_ executed a serialising
> instruction before this call returns... one wonders how that happens
> without blocking. Maybe the CPU spins waiting for completion instead?

Membarrier expedited sync-core issues IPIs to all CPUs running sibling
threads. AFAIR the IPI mechanism uses the "csd lock" which is basically
busy waiting. So it does not "block", it busy-waits.

For completeness of the explanation, other (non-running) threads acting
on the same mm will eventually issue the context synchronizing instruction
before returning to user-space whenever they are scheduled back.

Thanks,

Mathieu


>=20
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
