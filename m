Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 321292A2827
	for <lists+stable@lfdr.de>; Mon,  2 Nov 2020 11:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728347AbgKBKXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Nov 2020 05:23:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728297AbgKBKXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 2 Nov 2020 05:23:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E63C0617A6;
        Mon,  2 Nov 2020 02:23:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=T4edEfzDUp94a5geNCa69OK/7pLd8nv3AuvG+qE7Gx8=; b=kQFchl4ezQ8E5WVCay0B/CFxi
        mpOZ2oXboumTunBiZLsnLmmEhQJ9lVJ72eVnXe0eD5kMeFTooDo/VetJeR2Ifz6IzPpuVR7pgsH8W
        FOfjZner98iLKZ+ztDyLs0Nwc3JjiXofOUqiG/wEoQHqZgP1ENF9252KXi5PK1q9OGyCsLv/CxDlm
        6lDTsJQneU93+R7qWyvF8D4mOl7/FT1JFbbOCMWcQ3M2PgVBUxoRWTdoz8oz0MOywKZObNIdqY0IK
        lVGgUHWHlUSq6HpVP9m8czF3l4VNxMAnc80a1FgirNF5bqc8nraNjSGso9rbmdrdXoIgfDIarVjqI
        nVba+1n9Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54086)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kZX04-0000QP-7N; Mon, 02 Nov 2020 10:23:44 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kZX03-0001gX-7p; Mon, 02 Nov 2020 10:23:43 +0000
Date:   Mon, 2 Nov 2020 10:23:43 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     daniel.vetter@ffwll.ch, gregkh@linuxfoundation.org,
        yepeilin.cs@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/1] Fonts: font_acorn_8x8: Replace discarded const
 qualifier
Message-ID: <20201102102343.GK1551@shell.armlinux.org.uk>
References: <20201030181822.570402-1-lee.jones@linaro.org>
 <20201031102709.GH1551@shell.armlinux.org.uk>
 <20201101131122.GD4127@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101131122.GD4127@dell>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 01, 2020 at 01:11:22PM +0000, Lee Jones wrote:
> On Sat, 31 Oct 2020, Russell King - ARM Linux admin wrote:
> 
> > On Fri, Oct 30, 2020 at 06:18:22PM +0000, Lee Jones wrote:
> > > Commit 09e5b3fd5672 ("Fonts: Support FONT_EXTRA_WORDS macros for
> > 
> > Your commit ID does not exist in mainline kernels, which makes this
> > confusing. The commit ID you should be using is 6735b4632def.
> 
> Ah yes, quite right.  That is the ID from android-3.18 where this
> issue was first seen and fixed against.  I will fix it up for
> Mainline.
> 
> Does the fix look okay to you though Russell?

Frankly, I don't know. Looking at the commit itself, it looks safe,
but it depends what this "extra" data is being used for. From what
I can see, the commit in question just adds the additional opaque
data as a member named "extra", and one is left to guess what it's
use as.

I'd have thought a small structure with named members would have
been the minimum given our standards for in-kernel code.

Why was the "const" dropped in the first place? Does this "extra"
member get written to somewhere?

So, sorry, no idea. This looks to me like a very unsatisfactory
commit, and probably something that got a very poor review.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
