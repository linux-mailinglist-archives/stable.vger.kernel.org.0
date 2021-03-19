Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDE8A341F4F
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 15:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229875AbhCSOYv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 10:24:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230041AbhCSOYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 10:24:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89D9764F18;
        Fri, 19 Mar 2021 14:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616163882;
        bh=6VE/Fv/2axAsf6XkbkHcNpGmbbKCw1dChMao0h4cM4I=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=EimdWugc5Ax/BcaDLjSJ+JHN6yPKUfz0tBSZyLsik/HkJmfeh7+CxUSwqtA/uVWqJ
         qJ0rNwmCqVdxMBPBhHnT7KeP9aewb6EFGwctaUGwIgnuctqJ0wgE2ZtcJo/e0Filja
         ksx0iOiN8fmKV0qVk3QFWlp0Tcer8qc37hDSlF61V+Ba7iYCj4fgii4/JH45XkjZpc
         rrP2xA0Ea4+7UAxTL1rJzgf54grj2sZJHWPWIWzRst0etw511EK0Qt0MxaRA7BCODd
         NH9N7spmfleO44RhDUR+PhFMNU5aDenGhx/E8BXfTKf9PzXWRTgqEQVo+CL+3rPNL9
         D2DtYfIRUZkGg==
Date:   Fri, 19 Mar 2021 15:24:38 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, Jiri Kosina <jikos@jikos.cz>
Subject: Re: [PATCH 5.11 13/31] net: bonding: fix error return code of
 bond_neigh_init()
In-Reply-To: <alpine.LRH.2.00.2103191511500.19651@gjva.wvxbf.pm>
Message-ID: <nycvar.YFH.7.76.2103191524160.12405@cbobk.fhfr.pm>
References: <20210319121747.203523570@linuxfoundation.org> <20210319121747.622717971@linuxfoundation.org> <alpine.LRH.2.00.2103191511500.19651@gjva.wvxbf.pm>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Mar 2021, Jiri Kosina wrote:

> > [ Upstream commit 2055a99da8a253a357bdfd359b3338ef3375a26c ]
> > 
> > When slave is NULL or slave_ops->ndo_neigh_setup is NULL, no error
> > return code of bond_neigh_init() is assigned.
> > To fix this bug, ret is assigned with -EINVAL in these cases.
> > 
> > Fixes: 9e99bfefdbce ("bonding: fix bond_neigh_init()")
> > Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> > Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  drivers/net/bonding/bond_main.c | 8 ++++++--
> >  1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> > index 5fe5232cc3f3..fba6b6d1b430 100644
> > --- a/drivers/net/bonding/bond_main.c
> > +++ b/drivers/net/bonding/bond_main.c
> > @@ -3917,11 +3917,15 @@ static int bond_neigh_init(struct neighbour *n)
> >  
> >  	rcu_read_lock();
> >  	slave = bond_first_slave_rcu(bond);
> > -	if (!slave)
> > +	if (!slave) {
> > +		ret = -EINVAL;
> >  		goto out;
> > +	}
> >  	slave_ops = slave->dev->netdev_ops;
> > -	if (!slave_ops->ndo_neigh_setup)
> > +	if (!slave_ops->ndo_neigh_setup) {
> > +		ret = -EINVAL;
> >  		goto out;
> > +	}
> 
> This patch is completely broken and breaks bonding functionality 
> altogether for me.

... and I just found out that revert is already queued in netdev.git. So 
please drop it from stable queue as well.

-- 
Jiri Kosina
SUSE Labs

