Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966932A2841
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 11:30:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgKBKaf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 05:30:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728132AbgKBKae (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 05:30:34 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853F4C0617A6;
        Mon,  2 Nov 2020 02:30:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gH6cU0WjGIcLU1WLwkM2Gr2ClysO1THsAmJqx+M+7fA=; b=V0s1igeCcWjchc3yKAAw+HG+S
        Y+vuhHjJul7EwUWak7bzSsvc8pQKqvZYJHEuETqek8B+nwPHsr7/b1FRqQamr2sm5A4cJnhmmW4yK
        vM+vZKRpyyDBqAlEEVw3CU279DQ//50Dffb/rcs4HhFApBiqNBmIlqY+esNPDHtyjannYD3Lm20a6
        vBFQc0QwE4NTnyx5XxJjxdq4KJOBj4e/4c9j2pHf904vWwHrKKWuU+YPjd5oIOpwSdBMNY34K6R+G
        Mg6ZEesLOFvHUnHybGZuUI3QmqG2jcCFwnMcuEaI3zsR4/RFId8fQYKAHG7HH/F5ldxsb1szNI7Hy
        RzieoJ2zw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54096)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kZX6e-0000RB-Ld; Mon, 02 Nov 2020 10:30:32 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kZX6d-0001gp-TX; Mon, 02 Nov 2020 10:30:32 +0000
Date:   Mon, 2 Nov 2020 10:30:31 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     daniel.vetter@ffwll.ch, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gregkh@linuxfoundation.org,
        yepeilin.cs@gmail.com, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/1] Fonts: font_acorn_8x8: Replace discarded const
 qualifier
Message-ID: <20201102103031.GL1551@shell.armlinux.org.uk>
References: <20201030181822.570402-1-lee.jones@linaro.org>
 <20201031102709.GH1551@shell.armlinux.org.uk>
 <20201101131122.GD4127@dell>
 <20201102102343.GK1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201102102343.GK1551@shell.armlinux.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 02, 2020 at 10:23:43AM +0000, Russell King - ARM Linux admin wrote:
> On Sun, Nov 01, 2020 at 01:11:22PM +0000, Lee Jones wrote:
> > On Sat, 31 Oct 2020, Russell King - ARM Linux admin wrote:
> > 
> > > On Fri, Oct 30, 2020 at 06:18:22PM +0000, Lee Jones wrote:
> > > > Commit 09e5b3fd5672 ("Fonts: Support FONT_EXTRA_WORDS macros for
> > > 
> > > Your commit ID does not exist in mainline kernels, which makes this
> > > confusing. The commit ID you should be using is 6735b4632def.
> > 
> > Ah yes, quite right.  That is the ID from android-3.18 where this
> > issue was first seen and fixed against.  I will fix it up for
> > Mainline.
> > 
> > Does the fix look okay to you though Russell?
> 
> Frankly, I don't know. Looking at the commit itself, it looks safe,
> but it depends what this "extra" data is being used for. From what
> I can see, the commit in question just adds the additional opaque
> data as a member named "extra", and one is left to guess what it's
> use as.
> 
> I'd have thought a small structure with named members would have
> been the minimum given our standards for in-kernel code.
> 
> Why was the "const" dropped in the first place? Does this "extra"
> member get written to somewhere?
> 
> So, sorry, no idea. This looks to me like a very unsatisfactory
> commit, and probably something that got a very poor review.

Also, the commit description is missing a chunk:

    For user-provided fonts, the framebuffer layer resolves this issue by
    reserving four extra words at the beginning of data buffers. Later,
    whenever a function needs to access them, it simply uses the following
    macros:

    Recently we have gathered all the above macros to <linux/font.h>.

So what were these macros that have been nicely removed from the commit
description? I guess they started with a '#' character and git thought
they were a comment.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
