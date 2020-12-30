Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EA082E779A
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 11:01:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbgL3KBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 05:01:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgL3KBf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 05:01:35 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9DEBC061799;
        Wed, 30 Dec 2020 02:00:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RLGcTHha1iBi5RnrUOHhCpmRRdZbNNy9N9/LhkhCawU=; b=p2p0MbfKm1c8qLl/oYqAdf1c5
        NSwPA81w4cjPSXGUfrJlixIAMI1qiuQ7JBKa9c5vBh4YgHdF0Jl+25BUYsCjR0frTf+ZCFe2U4LXA
        dPkGzPHZHMTMAbMr0rdcSUFc44dMCYe763lJr/QUsH4+0HztLsn3Mjq68nAJQMyuTict5YCIztQzI
        n6s+eLub2njYRmf+cXWAP4agnwvAjzJYz0xYFSrMDd/o9ZbURf5A95R8hC7HTrd+iP5UnwJDv+b98
        3djV2uepw2kuTFjy5+kUg2ogjoiIwI7jdLtlQ7Vt2c5/VPzEVR1Z68PxpY1/p4sFkU2xtuRUu/Sz5
        1tzF0cYVg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44902)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kuYHP-0005bt-HE; Wed, 30 Dec 2020 10:00:31 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kuYHM-00026D-M2; Wed, 30 Dec 2020 10:00:28 +0000
Date:   Wed, 30 Dec 2020 10:00:28 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     paulmck <paulmck@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        x86 <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Andy Lutomirski <luto@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
Message-ID: <20201230100028.GP1551@shell.armlinux.org.uk>
References: <CAG48ez0YZ_iy6qZpdGUj38wqeg_NzLHHhU-mBCBf5hcopYGVPg@mail.gmail.com>
 <20201228190852.GI1551@shell.armlinux.org.uk>
 <CALCETrVpvrBufrJgXNY=ogtZQLo7zgxQmD7k9eVCFjcdcvarmA@mail.gmail.com>
 <1086654515.3607.1609187556216.JavaMail.zimbra@efficios.com>
 <CALCETrXx3Xe+4Y6WM-mp0cTUU=r3bW6PV2b25yA8bm1Gvak6wQ@mail.gmail.com>
 <1609200902.me5niwm2t6.astroid@bobo.none>
 <CALCETrX6MOqmN5_jhyO1jJB7M3_T+hbomjxPYZLJmLVNmXAVzA@mail.gmail.com>
 <1609210162.4d8dqilke6.astroid@bobo.none>
 <20201229104456.GK1551@shell.armlinux.org.uk>
 <1609290821.wrfh89v23a.astroid@bobo.none>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1609290821.wrfh89v23a.astroid@bobo.none>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 30, 2020 at 12:33:02PM +1000, Nicholas Piggin wrote:
> Excerpts from Russell King - ARM Linux admin's message of December 29, 2020 8:44 pm:
> > On Tue, Dec 29, 2020 at 01:09:12PM +1000, Nicholas Piggin wrote:
> >> I think it should certainly be documented in terms of what guarantees
> >> it provides to application, _not_ the kinds of instructions it may or
> >> may not induce the core to execute. And if existing API can't be
> >> re-documented sanely, then deprecatd and new ones added that DTRT.
> >> Possibly under a new system call, if arch's like ARM want a range
> >> flush and we don't want to expand the multiplexing behaviour of
> >> membarrier even more (sigh).
> > 
> > The 32-bit ARM sys_cacheflush() is there only to support self-modifying
> > code, and takes whatever actions are necessary to support that.
> > Exactly what actions it takes are cache implementation specific, and
> > should be of no concern to the caller, but the underlying thing is...
> > it's to support self-modifying code.
> 
>    Caveat
>        cacheflush()  should  not  be used in programs intended to be portable.
>        On Linux, this call first appeared on the MIPS architecture, but  nowa‐
>        days, Linux provides a cacheflush() system call on some other architec‐
>        tures, but with different arguments.
> 
> What a disaster. Another badly designed interface, although it didn't 
> originate in Linux it sounds like we weren't to be outdone so
> we messed it up even worse.
> 
> flushing caches is neither necessary nor sufficient for code modification
> on many processors. Maybe some old MIPS specific private thing was fine,
> but certainly before it grew to other architectures, somebody should 
> have thought for more than 2 minutes about it. Sigh.

WARNING: You are bordering on being objectionable and offensive with
that comment.

The ARM interface was designed by me back in the very early days of
Linux, probably while you were still in dypers, based on what was
known at the time.  Back in the early 2000s, ideas such as relaxed
memory ordering were not known.  All there was was one level of
harvard cache.

So, juts shut up with your insults.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
