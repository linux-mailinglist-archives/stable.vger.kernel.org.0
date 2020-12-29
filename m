Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 832D92E6FB2
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 11:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725986AbgL2KqZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Dec 2020 05:46:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725866AbgL2KqY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Dec 2020 05:46:24 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF34AC0613D6;
        Tue, 29 Dec 2020 02:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sLVNBE9zyTYAthGu+etXkcsigZHEGQY14KM0ZFpK8Ks=; b=tJaQAYl5MhdbAUuZxJUvvf/6+
        BywodXRteRy+nLWoft6DR2sGfOQd59X3VyVctEs/Rk543wGE27d8KIDIUUR0xb+8RvBPpMiYhIDId
        DJ8WMXE8JC0hf+nwxMmqwnPnIJxDV8kCcVYgkaGgZhhR7Xr8rtxmCUd9ZlcHRQ0fE41y3kHGFk/Er
        FYf0bEjfmW+XNhRMgzohrDvoQ6tvTDgd6WDamHxjS+kacdfdJ0BSTHP7OGsoMMeb6Vep/oPnajfy0
        VHk/AuhaYBOcU4MPbA0qP5KMj5Vve4exTpL6MvsJ6aA9/KqTn40See6T7YrHQAodGuT/ARJI2tV2c
        9SFU4hWIg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44864)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kuCUx-00052n-4L; Tue, 29 Dec 2020 10:45:03 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kuCUq-0001AR-Qf; Tue, 29 Dec 2020 10:44:56 +0000
Date:   Tue, 29 Dec 2020 10:44:56 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Nicholas Piggin <npiggin@gmail.com>
Cc:     Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Jann Horn <jannh@google.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        paulmck <paulmck@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        stable <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        x86 <x86@kernel.org>
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
Message-ID: <20201229104456.GK1551@shell.armlinux.org.uk>
References: <20201228102537.GG1551@shell.armlinux.org.uk>
 <CALCETrWQx0qwthBc5pJBxs2PWAQo-roAz-6g=7HOs+dsiokVsg@mail.gmail.com>
 <CAG48ez0YZ_iy6qZpdGUj38wqeg_NzLHHhU-mBCBf5hcopYGVPg@mail.gmail.com>
 <20201228190852.GI1551@shell.armlinux.org.uk>
 <CALCETrVpvrBufrJgXNY=ogtZQLo7zgxQmD7k9eVCFjcdcvarmA@mail.gmail.com>
 <1086654515.3607.1609187556216.JavaMail.zimbra@efficios.com>
 <CALCETrXx3Xe+4Y6WM-mp0cTUU=r3bW6PV2b25yA8bm1Gvak6wQ@mail.gmail.com>
 <1609200902.me5niwm2t6.astroid@bobo.none>
 <CALCETrX6MOqmN5_jhyO1jJB7M3_T+hbomjxPYZLJmLVNmXAVzA@mail.gmail.com>
 <1609210162.4d8dqilke6.astroid@bobo.none>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1609210162.4d8dqilke6.astroid@bobo.none>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 29, 2020 at 01:09:12PM +1000, Nicholas Piggin wrote:
> I think it should certainly be documented in terms of what guarantees
> it provides to application, _not_ the kinds of instructions it may or
> may not induce the core to execute. And if existing API can't be
> re-documented sanely, then deprecatd and new ones added that DTRT.
> Possibly under a new system call, if arch's like ARM want a range
> flush and we don't want to expand the multiplexing behaviour of
> membarrier even more (sigh).

The 32-bit ARM sys_cacheflush() is there only to support self-modifying
code, and takes whatever actions are necessary to support that.
Exactly what actions it takes are cache implementation specific, and
should be of no concern to the caller, but the underlying thing is...
it's to support self-modifying code.

Sadly, because it's existed for 20+ years, and it has historically been
sufficient for other purposes too, it has seen quite a bit of abuse
despite its design purpose not changing - it's been used by graphics
drivers for example. They quickly learnt the error of their ways with
ARMv6+, since it does not do sufficient for their purposes given the
cache architectures found there.

Let's not go around redesigning this after twenty odd years, requiring
a hell of a lot of pain to users. This interface is called by code
generated by GCC, so to change it you're looking at patching GCC as
well as the kernel, and you basically will make new programs
incompatible with older kernels - very bad news for users.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
