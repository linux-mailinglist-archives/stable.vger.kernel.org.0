Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E137413D3D
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 00:02:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235610AbhIUWE0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 18:04:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbhIUWEZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 18:04:25 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AEAEC061574;
        Tue, 21 Sep 2021 15:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FU6MY8NmNybF1VNxHGRHG+itNOVLUqsfTUSxIQnDAr4=; b=UwPAWmgFstTetbHhj4I61Tc2DJ
        YDFbU4oW+MDi34a7Nt5wKwhbJQHFMCpFXx2V808JPTjLmNsp962/CeQ1oVxJMGlPjXLNwmmZDx4bx
        9mLPMdXqUswgRC2BMNJg+hTOnMs7j6/WxBftgGHyHdzIbmbL/k7xw4s4vgMuQ8Z7i6W1B8xHRKoJU
        Br8+JBsKiuAq7+Y3j7GQxRFRjzHF97PIhWcLMpLmqqCCzdHGh9GqAAUsCMaJrCLuMttp01iV4rOGs
        LhIzz09XH0JW3FnJsqncaxeSOr8EaIocyWXiM2kFLp9MrYcS+XtQrk76ap4wLKBQWIPmpdYtUH3u7
        x69taE0g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:54722)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mSnqn-00038s-UG; Tue, 21 Sep 2021 23:02:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mSnqm-0003eY-RF; Tue, 21 Sep 2021 23:02:52 +0100
Date:   Tue, 21 Sep 2021 23:02:52 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 079/122] net: phylink: add suspend/resume support
Message-ID: <YUpWjKZyqHImRaix@shell.armlinux.org.uk>
References: <20210920163915.757887582@linuxfoundation.org>
 <20210920163918.373775935@linuxfoundation.org>
 <20210921212837.GA29170@duo.ucw.cz>
 <YUpPmRPczcLveKj4@shell.armlinux.org.uk>
 <20210921214528.GA30221@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921214528.GA30221@duo.ucw.cz>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 11:45:28PM +0200, Pavel Machek wrote:
> Hi!
> 
> > > > Joakim Zhang reports that Wake-on-Lan with the stmmac ethernet driver broke
> > > > when moving the incorrect handling of mac link state out of mac_config().
> > > > This reason this breaks is because the stmmac's WoL is handled by the MAC
> > > > rather than the PHY, and phylink doesn't cater for that scenario.
> > > > 
> > > > This patch adds the necessary phylink code to handle suspend/resume events
> > > > according to whether the MAC still needs a valid link or not. This is the
> > > > barest minimum for this support.
> > > 
> > > This adds functions that end up being unused in 5.10. AFAICT we do not
> > > need this in 5.10.
> > 
> > It needs to be backported to any kernel that also has
> > "net: stmmac: fix MAC not working when system resume back with WoL active"
> > backported to. From what I can tell, the fixes line in that commit
> > refers to a commit (46f69ded988d) in v5.7-rc1.
> > 
> > If "net: stmmac: fix MAC not working when system resume back with WoL
> > active" is not being backported to 5.10, then there is no need to
> > backport this patch.
> 
> Agreed.
> 
> > As I'm not being copied on the stmmac commit, I've no idea which kernels
> > this patch should be backported to.
> 
> AFAICT "net: stmmac: fix MAC not working when..." is not queued for
> 5.10.68-rc1 or 5.14.7-rc1.

Okay, this is madness. What is going on with stable's patch selection?
The logic seems completely reversed.

"net: phylink: Update SFP selected interface on advertising changes"
does not have a Fixes tag, and is not a fix in itself, yet has been
picked up by the stable team. It lays the necessary work for its
counter-part patch, which is...

"net: stmmac: fix system hang caused by eee_ctrl_timer during
suspend/resume" _has_ a Fixes tag, but has *not* been picked up by
the stable team.

It seems there's something very wrong process-wise here. Why would
a patch _without_ a Fixes line and isn't a fix in itself be picked
out for stable backport when patches with a Fixes line are ignored?

Not unless the stable plan is to apply "net: phylink: Update SFP
selected interface on advertising changes" and then sometime later
apply "net: stmmac: fix system hang caused by eee_ctrl_timer during
suspend/resume". No idea.

It all seems very weird and the process seems broken to me.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
