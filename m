Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 863E5405A3B
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 17:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbhIIPic (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 11:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhIIPib (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Sep 2021 11:38:31 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31933C061574;
        Thu,  9 Sep 2021 08:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=F73x7V3d25UjGf7zf/PPlbbc+cYf+/nqqVeEZWo13SE=; b=Cm6MI7CiUa/dp8wnVLYXEEu18x
        drH9hdKleBUpv6awCYZzVsWfntCJUQIl1sku82key36p8QR5laJs32LdWmZgBE2SGflBuqw8dqLpv
        IW53hKQzfvsLdyVlGrRKlclscA7IWhrFgTPihWc2AflEijeC9ZFp6jcMH838BK0NLrrWSldWFrFjC
        MS7sCTgAlEoDcrB03qSVZ4iLbvq4UDjfff+AFexeS3K+XM+spiFHNy9VOZRkemqmaWGivr8iNfh+p
        QbIxszILfFhtIgIU7xCENPxOm0VWiR6sTfNUyKSY6lS6zp0+6YRtKDPskXGHsOI9txrHiRcSxEPgr
        CLoiF+oQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45018)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mOM6t-0006iP-WB; Thu, 09 Sep 2021 16:37:06 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mOM6p-0006P9-2l; Thu, 09 Sep 2021 16:37:03 +0100
Date:   Thu, 9 Sep 2021 16:37:03 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Marc Zyngier <maz@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>,
        Sumit Garg <sumit.garg@linaro.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Android Kernel Team <kernel-team@android.com>,
        stable <stable@vger.kernel.org>,
        Magnus Damm <damm+renesas@opensource.se>,
        Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund+renesas@ragnatech.se>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: Re: [PATCH v2 07/17] irqchip/gic: Atomically update affinity
Message-ID: <YToqH4phGwq4/MPQ@shell.armlinux.org.uk>
References: <20200624195811.435857-1-maz@kernel.org>
 <20200624195811.435857-8-maz@kernel.org>
 <CAMuHMdV+Ev47K5NO8XHsanSq5YRMCHn2gWAQyV-q2LpJVy9HiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdV+Ev47K5NO8XHsanSq5YRMCHn2gWAQyV-q2LpJVy9HiQ@mail.gmail.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 05:22:01PM +0200, Geert Uytterhoeven wrote:
> Despite the ARM Generic Interrupt Controller Architecture Specification
> (both version 1.0 and 2.0) stating that the Interrupt Processor Targets
> Registers are byte-accessible, the EMMA Mobile EV2 User's Manual
> states that the interrupt registers can be accessed via the APB bus,
> in 32-bit units.  Using byte accesses locks up the system.

Fun. Seems someone can't read ARMs documentation. Even the old
ARM IHI 0048B.b document I have for the GIC from 2013 states
"In addition, the GICD_IPRIORITYRn, GICD_ITARGETSRn, GICD_CPENDSGIRn,
and GICD_SPENDSGIRn registers support byte accesses."

However, this kind of thing is sadly not uncommon. There's been a
similar issue with the PL011 UART driver as well - some platforms
require 16-bit accesses instead of normal 32-bit accesses.

> Unfortunately I only have remote access to the board showing the
> issue.  I did check that adding the writeb_relaxed() before the
> writel_relaxed() that was used before also causes a lock-up, so the
> issue is not an endian mismatch.
> Looking at the driver history, these registers have always been
> accessed using 32-bit accesses before.  As byte accesses lead
> indeed to simpler code, I'm wondering if they had been tried before,
> and caused issues before?
> 
> Since you said the locking was bogus before, due to the reliance on
> the BL_SWITCHER option, I'm not suggesting a plain revert, but I'm
> wondering what kind of locking you suggest to use instead?

If byte accesses are not going to be workable, then the only
answer _is_ a read-modify-write with working locking.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
