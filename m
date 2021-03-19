Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72AD034209A
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 16:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbhCSPM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 11:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230051AbhCSPMP (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 11:12:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BEB961921;
        Fri, 19 Mar 2021 15:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616166734;
        bh=fjGi/QHNJfzDVR0Ld64w4sEfBS2lOPpHYD5KhaG3EYA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bpef4Uw3Lr477fj/ZHc9ZxRVQTAKxQpGi8l04SLfiZZhy/Xh6V0X1NxG6OHYuhq6P
         gvEzwmWKnGqNGx1ko0Wal4Zfd6OcsYK32k8UNjs7LGCxTr3Zh0UTP/zFpdxHbPGBG2
         fA3U9I8+TDrwFxSD2fNXJp/gmdXLWBTl8XMCgfb0=
Date:   Fri, 19 Mar 2021 15:29:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, Jiri Kosina <jikos@jikos.cz>
Subject: Re: [PATCH 5.11 13/31] net: bonding: fix error return code of
 bond_neigh_init()
Message-ID: <YFS1RZl3u80zy4pH@kroah.com>
References: <20210319121747.203523570@linuxfoundation.org>
 <20210319121747.622717971@linuxfoundation.org>
 <alpine.LRH.2.00.2103191511500.19651@gjva.wvxbf.pm>
 <nycvar.YFH.7.76.2103191524160.12405@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <nycvar.YFH.7.76.2103191524160.12405@cbobk.fhfr.pm>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 03:24:38PM +0100, Jiri Kosina wrote:
> On Fri, 19 Mar 2021, Jiri Kosina wrote:
> 
> > > [ Upstream commit 2055a99da8a253a357bdfd359b3338ef3375a26c ]
> > > 
> > > When slave is NULL or slave_ops->ndo_neigh_setup is NULL, no error
> > > return code of bond_neigh_init() is assigned.
> > > To fix this bug, ret is assigned with -EINVAL in these cases.
> > > 
> > > Fixes: 9e99bfefdbce ("bonding: fix bond_neigh_init()")
> > > Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> > > Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> > > Signed-off-by: David S. Miller <davem@davemloft.net>
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  drivers/net/bonding/bond_main.c | 8 ++++++--
> > >  1 file changed, 6 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > > index 5fe5232cc3f3..fba6b6d1b430 100644
> > > --- a/drivers/net/bonding/bond_main.c
> > > +++ b/drivers/net/bonding/bond_main.c
> > > @@ -3917,11 +3917,15 @@ static int bond_neigh_init(struct neighbour *n)
> > >  
> > >  	rcu_read_lock();
> > >  	slave = bond_first_slave_rcu(bond);
> > > -	if (!slave)
> > > +	if (!slave) {
> > > +		ret = -EINVAL;
> > >  		goto out;
> > > +	}
> > >  	slave_ops = slave->dev->netdev_ops;
> > > -	if (!slave_ops->ndo_neigh_setup)
> > > +	if (!slave_ops->ndo_neigh_setup) {
> > > +		ret = -EINVAL;
> > >  		goto out;
> > > +	}
> > 
> > This patch is completely broken and breaks bonding functionality 
> > altogether for me.
> 
> ... and I just found out that revert is already queued in netdev.git. So 
> please drop it from stable queue as well.

Ah, missed that, will go drop this now, thanks for letting me know.

greg k-h
