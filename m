Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09852E6C3A
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbgL1Wzs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 17:55:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729415AbgL1UZl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 15:25:41 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6AFC061796;
        Mon, 28 Dec 2020 12:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=aXiztOLVDI1xQ0cgx87QbDrwMbVe0SKDRuOye74fEvg=; b=qu34zBWTNFCGapiNvzkB0lQRr
        BKwxHW3PEiplLNcr8ZBFrF1PnKkCoS2SrTM7Mas5assUmmgvlu0GDn7DXicumZ8o8HlCBeyew5nPZ
        cIiXyk9NaJUBGnGpWwZpnurevAG9CwY0q0D77xGnfpsIoLRMVTyEoXY3FZjMQgsrKEzKNzPeqigVE
        VJxcYb21gQTcj4pZeA3SHCfe0hGy2G/U79AbGUEAjDTY2jn5C8HxuHvp0cV3GGnKbDv3gUK8BCdIj
        2mfWeEfNyLbgrvPcoPBmc/0WTtYMuScVaC0I7QllSrp6Za0U4vQfJOG+0DH5PNV+TduGJ0OdLuBwg
        nn00bsjHA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44614)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ktz4Y-0004g3-6K; Mon, 28 Dec 2020 20:24:54 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ktz4V-0000Yw-DR; Mon, 28 Dec 2020 20:24:51 +0000
Date:   Mon, 28 Dec 2020 20:24:51 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jann Horn <jannh@google.com>, Will Deacon <will@kernel.org>,
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
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
Message-ID: <20201228202451.GJ1551@shell.armlinux.org.uk>
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org>
 <1836294649.3345.1609100294833.JavaMail.zimbra@efficios.com>
 <CALCETrVdcn2r2Jvd1=-bM=FQ8KbX4aH-v4ytdojL7r7Nb6k8YQ@mail.gmail.com>
 <20201228102537.GG1551@shell.armlinux.org.uk>
 <CALCETrWQx0qwthBc5pJBxs2PWAQo-roAz-6g=7HOs+dsiokVsg@mail.gmail.com>
 <CAG48ez0YZ_iy6qZpdGUj38wqeg_NzLHHhU-mBCBf5hcopYGVPg@mail.gmail.com>
 <20201228190852.GI1551@shell.armlinux.org.uk>
 <CALCETrVpvrBufrJgXNY=ogtZQLo7zgxQmD7k9eVCFjcdcvarmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrVpvrBufrJgXNY=ogtZQLo7zgxQmD7k9eVCFjcdcvarmA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 11:44:33AM -0800, Andy Lutomirski wrote:
> On Mon, Dec 28, 2020 at 11:09 AM Russell King - ARM Linux admin
> <linux@armlinux.org.uk> wrote:
> >
> > On Mon, Dec 28, 2020 at 07:29:34PM +0100, Jann Horn wrote:
> > > After chatting with rmk about this (but without claiming that any of
> > > this is his opinion), based on the manpage, I think membarrier()
> > > currently doesn't really claim to be synchronizing caches? It just
> > > serializes cores. So arguably if userspace wants to use membarrier()
> > > to synchronize code changes, userspace should first do the code
> > > change, then flush icache as appropriate for the architecture, and
> > > then do the membarrier() to ensure that the old code is unused?
> > >
> > > For 32-bit arm, rmk pointed out that that would be the cacheflush()
> > > syscall. That might cause you to end up with two IPIs instead of one
> > > in total, but we probably don't care _that_ much about extra IPIs on
> > > 32-bit arm?
> > >
> > > For arm64, I believe userspace can flush icache across the entire
> > > system with some instructions from userspace - "DC CVAU" followed by
> > > "DSB ISH", or something like that, I think? (See e.g.
> > > compat_arm_syscall(), the arm64 compat code that implements the 32-bit
> > > arm cacheflush() syscall.)
> >
> > Note that the ARM cacheflush syscall calls flush_icache_user_range()
> > over the range of addresses that userspace has passed - it's intention
> > since day one is to support cases where userspace wants to change
> > executable code.
> >
> > It will issue the appropriate write-backs to the data cache (DCCMVAU),
> > the invalidates to the instruction cache (ICIMVAU), invalidate the
> > branch target buffer (BPIALLIS or BPIALL as appropriate), and issue
> > the appropriate barriers (DSB ISHST, ISB).
> >
> > Note that neither flush_icache_user_range() nor flush_icache_range()
> > result in IPIs; cache operations are broadcast across all CPUs (which
> > is one of the minimums we require for SMP systems.)
> >
> > Now, that all said, I think the question that has to be asked is...
> >
> >         What is the basic purpose of membarrier?
> >
> > Is the purpose of it to provide memory barriers, or is it to provide
> > memory coherence?
> >
> > If it's the former and not the latter, then cache flushes are out of
> > scope, and expecting memory written to be visible to the instruction
> > stream is totally out of scope of the membarrier interface, whether
> > or not the writes happen on the same or a different CPU to the one
> > executing the rewritten code.
> >
> > The documentation in the kernel does not seem to describe what it's
> > supposed to be doing - the only thing I could find is this:
> > Documentation/features/sched/membarrier-sync-core/arch-support.txt
> > which describes it as "arch supports core serializing membarrier"
> > whatever that means.
> >
> > Seems to be the standard and usual case of utterly poor to non-existent
> > documentation within the kernel tree, or even a pointer to where any
> > useful documentation can be found.
> >
> > Reading the membarrier(2) man page, I find nothing in there that talks
> > about any kind of cache coherency for self-modifying code - it only
> > seems to be about _barriers_ and nothing more, and barriers alone do
> > precisely nothing to save you from non-coherent Harvard caches.
> >
> > So, either Andy has a misunderstanding, or the man page is wrong, or
> > my rudimentary understanding of what membarrier is supposed to be
> > doing is wrong...
> 
> Look at the latest man page:
> 
> https://man7.org/linux/man-pages/man2/membarrier.2.html
> 
> for MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE.  The result may not be
> all that enlightening.

       MEMBARRIER_CMD_PRIVATE_EXPEDITED_SYNC_CORE (since Linux 4.16)
              In  addition  to  providing  the  memory ordering guarantees de■
              scribed in MEMBARRIER_CMD_PRIVATE_EXPEDITED,  upon  return  from
              system call the calling thread has a guarantee that all its run■
              ning thread siblings have executed a core  serializing  instruc■
              tion.   This  guarantee is provided only for threads in the same
              process as the calling thread.

              The "expedited" commands complete faster than the  non-expedited
              ones,  they  never block, but have the downside of causing extra
              overhead.

              A process must register its intent to use the private  expedited
              sync core command prior to using it.

This just says that the siblings have executed a serialising
instruction, in other words a barrier. It makes no claims concerning
cache coherency - and without some form of cache maintenance, there
can be no expectation that the I and D streams to be coherent with
each other.

This description is also weird in another respect. "guarantee that
all its running thread siblings have executed a core serializing
instruction" ... "The expedited commands ... never block".

So, the core executing this call is not allowed to block, but the
other part indicates that the other CPUs _have_ executed a serialising
instruction before this call returns... one wonders how that happens
without blocking. Maybe the CPU spins waiting for completion instead?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
