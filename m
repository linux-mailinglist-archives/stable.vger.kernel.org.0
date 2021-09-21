Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72CD8413C80
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 23:33:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbhIUVet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 17:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232088AbhIUVes (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 17:34:48 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED47FC061574;
        Tue, 21 Sep 2021 14:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZajkgWCi0yDRNW6H+n3ZFs1aW16iYhABZhxg/AoBYvw=; b=s5rg++9t1nqEFcw5oLCBxYRfeK
        NIbToqlfdAOBSouhSQTRtcCE7get7605g8ZAdPRdavXQMRFHJNcyBU6B5ReVWEKgPyi8qj1E7R++s
        5u1VEnytviDQa4z42NjFNkizc140FUNrBWz6s2hU31c1ywS29ulGrdR8/olvORJ64VyobMT+54BeN
        zfbclzEzYdVd8/hp9kYvV5Vlknv1qm3tH76aGU+G3yXnRcTHDu/CtEpPIrwv7GhFpiuuITBLAOTpV
        B0agmJDalimch/Pxgv6Wc4jgOn0reNU5h7n3GYqdE7F+MtL1UDO7/XOxTwVOZJ658lStkqR46ZUTv
        9x42J6wA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54718)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mSnO7-000368-Jj; Tue, 21 Sep 2021 22:33:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mSnO5-0003dF-Er; Tue, 21 Sep 2021 22:33:13 +0100
Date:   Tue, 21 Sep 2021 22:33:13 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 079/122] net: phylink: add suspend/resume support
Message-ID: <YUpPmRPczcLveKj4@shell.armlinux.org.uk>
References: <20210920163915.757887582@linuxfoundation.org>
 <20210920163918.373775935@linuxfoundation.org>
 <20210921212837.GA29170@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921212837.GA29170@duo.ucw.cz>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 11:28:37PM +0200, Pavel Machek wrote:
> Hi!
> 
> > Joakim Zhang reports that Wake-on-Lan with the stmmac ethernet driver broke
> > when moving the incorrect handling of mac link state out of mac_config().
> > This reason this breaks is because the stmmac's WoL is handled by the MAC
> > rather than the PHY, and phylink doesn't cater for that scenario.
> > 
> > This patch adds the necessary phylink code to handle suspend/resume events
> > according to whether the MAC still needs a valid link or not. This is the
> > barest minimum for this support.
> 
> This adds functions that end up being unused in 5.10. AFAICT we do not
> need this in 5.10.

It needs to be backported to any kernel that also has
"net: stmmac: fix MAC not working when system resume back with WoL active"
backported to. From what I can tell, the fixes line in that commit
refers to a commit (46f69ded988d) in v5.7-rc1.

If "net: stmmac: fix MAC not working when system resume back with WoL
active" is not being backported to 5.10, then there is no need to
backport this patch.

As I'm not being copied on the stmmac commit, I've no idea which kernels
this patch should be backported to.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
