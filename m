Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8276134209B
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 16:13:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhCSPM1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 11:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229941AbhCSPMK (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 11:12:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A51296191F;
        Fri, 19 Mar 2021 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616166730;
        bh=mQfvAacVftP/9rxB0Bwj0zfV3W5kSK30ddHaBDA+3zA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yZgOtT2e+ibya6YLcKw6Ifz4PHUoAFEILOP/4NuZw2lLMgBDJoySWg+yz8Qkax0Sm
         PHH4hIFy2atpPMNPyQLc7ndh467LdAIJULQKaWviYVvPEujmQCyod8e2KDEm3qxVn0
         +KX6SLgIo6eWdKEU0XQd4pGEnLkUI31cPd0cvL5w=
Date:   Fri, 19 Mar 2021 15:25:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.11 13/31] net: bonding: fix error return code of
 bond_neigh_init()
Message-ID: <YFS0dlTZN9ApED93@kroah.com>
References: <20210319121747.203523570@linuxfoundation.org>
 <20210319121747.622717971@linuxfoundation.org>
 <alpine.LRH.2.00.2103191511500.19651@gjva.wvxbf.pm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.2103191511500.19651@gjva.wvxbf.pm>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 03:12:12PM +0100, Jiri Kosina wrote:
> On Fri, 19 Mar 2021, Greg Kroah-Hartman wrote:
> 
> > From: Jia-Ju Bai <baijiaju1990@gmail.com>
> > 
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

Is Linus's tree also broken for you?  This showed up in 5.12-rc3.

thanks,

greg k-h
