Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1119C414451
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 10:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233792AbhIVI7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 04:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233741AbhIVI7e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Sep 2021 04:59:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2CB9B61360;
        Wed, 22 Sep 2021 08:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632301084;
        bh=gBqvV0EENIIM+NYF7MVdZ8Ay41tw5OWArMEE1eebWks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FuhDgsMieGf5uJSQ7FacVPy/TzDXJ9tFdxHipJKkfQvUXrFAUAPt7jYPtuVIZarY/
         VIkVA6jK39EjXrqxJWxteDSmpDoU3XlhoJGeDh40ez0/ecL9MuKqhQ0+BJBmQvFezf
         E8EhE/szt4+eLJ2i5C2NAgjk9eL7zf0Ihv4Wbh+Q=
Date:   Wed, 22 Sep 2021 10:58:02 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 079/122] net: phylink: add suspend/resume support
Message-ID: <YUrwGs6H0eNmaJTE@kroah.com>
References: <20210920163915.757887582@linuxfoundation.org>
 <20210920163918.373775935@linuxfoundation.org>
 <20210921212837.GA29170@duo.ucw.cz>
 <YUpPmRPczcLveKj4@shell.armlinux.org.uk>
 <20210921214528.GA30221@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210921214528.GA30221@duo.ucw.cz>
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

I can easily do that, thanks!

greg k-h
