Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A370B2E35E4
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 11:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgL1K0j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 05:26:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbgL1K0j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Dec 2020 05:26:39 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2F8C061795;
        Mon, 28 Dec 2020 02:25:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=KFHMNIJdJQgc7k2MpIWgEZIVRXKh/hl0VpPbl95Wj24=; b=h30/GxdgAhHlsBbJPSjlJ8Mug
        9M1YG6RYYa/gwy5tEt6qDesqLU2ezI2zY0VuJgJZS2sgz8cuBtJbDnH4HxigRXUUhDIx1hPBRuiTk
        lZxIdGgnk9leKNqn0Ez2tBKl8ZyUMTp+wcNjizIlk1FW1Cw9yOzCn5Q6cYRndJo51zAP6allXlrrU
        Oo7bDiUkZwnIBHqdr+VCfUn3qCmOUzN5Cd0UMG1P0wzdNyotxaag/94/kmDJOpznJlcfiWaoaRut0
        F76z3eNzY2KD85mOAGw14rTXAMSQ72umaaa6LpJrHqH3Ofaz3fy397PGK0IkueabDrOeV+UZ/fuXm
        V76NAbWCw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44598)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ktpig-0004Lr-Ob; Mon, 28 Dec 2020 10:25:42 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ktpib-0000CL-9P; Mon, 28 Dec 2020 10:25:37 +0000
Date:   Mon, 28 Dec 2020 10:25:37 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        x86 <x86@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [RFC please help] membarrier: Rewrite sync_core_before_usermode()
Message-ID: <20201228102537.GG1551@shell.armlinux.org.uk>
References: <bf59ecb5487171a852bcc8cdd553ec797aedc485.1609093476.git.luto@kernel.org>
 <1836294649.3345.1609100294833.JavaMail.zimbra@efficios.com>
 <CALCETrVdcn2r2Jvd1=-bM=FQ8KbX4aH-v4ytdojL7r7Nb6k8YQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVdcn2r2Jvd1=-bM=FQ8KbX4aH-v4ytdojL7r7Nb6k8YQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 27, 2020 at 01:36:13PM -0800, Andy Lutomirski wrote:
> On Sun, Dec 27, 2020 at 12:18 PM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
> >
> > ----- On Dec 27, 2020, at 1:28 PM, Andy Lutomirski luto@kernel.org wrote:
> >
> 
> > >
> > > I admit that I'm rather surprised that the code worked at all on arm64,
> > > and I'm suspicious that it has never been very well tested.  My apologies
> > > for not reviewing this more carefully in the first place.
> >
> > Please refer to Documentation/features/sched/membarrier-sync-core/arch-support.txt
> >
> > It clearly states that only arm, arm64, powerpc and x86 support the membarrier
> > sync core feature as of now:
> 
> Sigh, I missed arm (32).  Russell or ARM folks, what's the right
> incantation to make the CPU notice instruction changes initiated by
> other cores on 32-bit ARM?

You need to call flush_icache_range(), since the changes need to be
flushed from the data cache to the point of unification (of the Harvard
I and D), and the instruction cache needs to be invalidated so it can
then see those updated instructions. This will also take care of the
necessary barriers that the CPU requires for you.

... as documented in Documentation/core-api/cachetlb.rst and so
should be available on every kernel supported CPU.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
