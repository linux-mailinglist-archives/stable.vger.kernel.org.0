Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0E041445E
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 10:59:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234002AbhIVJB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 05:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233969AbhIVJBZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 05:01:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C559561368;
        Wed, 22 Sep 2021 08:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632301196;
        bh=4BMfuYlQysTkUjlq7HXmb0FDccg17l+1XphnCQDkGJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U15mH2HKNYTAdB3FiuLxeicmXo7IYg07k2t+NB2K7utIobEQHUMKYDHHXaAqVe6kk
         8OWLWm76jj+EtsoH5znKbeMoeDYzhXYaeOXRgoiYQHssMTKRnXS/u7LyelRHCBr3eu
         0ZvCJx89CO1jQXSDWwJrOWd83KLUnMZ2MD4T4kyE=
Date:   Wed, 22 Sep 2021 10:59:53 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 079/122] net: phylink: add suspend/resume support
Message-ID: <YUrwibj8wmQmJRMV@kroah.com>
References: <20210920163915.757887582@linuxfoundation.org>
 <20210920163918.373775935@linuxfoundation.org>
 <20210921212837.GA29170@duo.ucw.cz>
 <YUpPmRPczcLveKj4@shell.armlinux.org.uk>
 <20210921214528.GA30221@duo.ucw.cz>
 <YUpWjKZyqHImRaix@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUpWjKZyqHImRaix@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 21, 2021 at 11:02:52PM +0100, Russell King (Oracle) wrote:
> On Tue, Sep 21, 2021 at 11:45:28PM +0200, Pavel Machek wrote:
> > Hi!
> > 
> > > > > Joakim Zhang reports that Wake-on-Lan with the stmmac ethernet driver broke
> > > > > when moving the incorrect handling of mac link state out of mac_config().
> > > > > This reason this breaks is because the stmmac's WoL is handled by the MAC
> > > > > rather than the PHY, and phylink doesn't cater for that scenario.
> > > > > 
> > > > > This patch adds the necessary phylink code to handle suspend/resume events
> > > > > according to whether the MAC still needs a valid link or not. This is the
> > > > > barest minimum for this support.
> > > > 
> > > > This adds functions that end up being unused in 5.10. AFAICT we do not
> > > > need this in 5.10.
> > > 
> > > It needs to be backported to any kernel that also has
> > > "net: stmmac: fix MAC not working when system resume back with WoL active"
> > > backported to. From what I can tell, the fixes line in that commit
> > > refers to a commit (46f69ded988d) in v5.7-rc1.
> > > 
> > > If "net: stmmac: fix MAC not working when system resume back with WoL
> > > active" is not being backported to 5.10, then there is no need to
> > > backport this patch.
> > 
> > Agreed.
> > 
> > > As I'm not being copied on the stmmac commit, I've no idea which kernels
> > > this patch should be backported to.
> > 
> > AFAICT "net: stmmac: fix MAC not working when..." is not queued for
> > 5.10.68-rc1 or 5.14.7-rc1.
> 
> Okay, this is madness. What is going on with stable's patch selection?
> The logic seems completely reversed.
> 
> "net: phylink: Update SFP selected interface on advertising changes"
> does not have a Fixes tag, and is not a fix in itself, yet has been
> picked up by the stable team. It lays the necessary work for its
> counter-part patch, which is...
> 
> "net: stmmac: fix system hang caused by eee_ctrl_timer during
> suspend/resume" _has_ a Fixes tag, but has *not* been picked up by
> the stable team.
> 
> It seems there's something very wrong process-wise here. Why would
> a patch _without_ a Fixes line and isn't a fix in itself be picked
> out for stable backport when patches with a Fixes line are ignored?

Because they came in through two different sets of processes.  And
during the -rc1 merge window madness, we have lots to still catch up on
because of all of the "fixes" that people wait to get into the tree
then.

> Not unless the stable plan is to apply "net: phylink: Update SFP
> selected interface on advertising changes" and then sometime later
> apply "net: stmmac: fix system hang caused by eee_ctrl_timer during
> suspend/resume". No idea.
> 
> It all seems very weird and the process seems broken to me.

Help is always gladly accepted.  Marking patches explicitly for stable
with a cc: stable is always the easiest way into the tree.  Otherwise we
have to do hueristics in looking at changelog text and Fixes: tags to
try to guess what is, and is not, valid for stable trees.

thanks,

greg k-h
