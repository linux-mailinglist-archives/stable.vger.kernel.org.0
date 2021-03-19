Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77C33420A7
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 16:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230009AbhCSPOl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 11:14:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:47498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230015AbhCSPOL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 11:14:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E699F61923;
        Fri, 19 Mar 2021 15:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616166851;
        bh=GH7hAX0ML1TB3hqKN7F4JT+ch/V/41FZKni+vBimVcU=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=WsxV0urWkBEO7Xnds3YW+GCZa+vGG6Hmk/jhg+FPCdEfpAgyPXeuYfeALLbdknrrl
         AX3Vh4u3j331w/BR//83RF4Nny3gvn5VRDPn183BmsaX/T6/ORehGFFlUUlJwxVck0
         hWlwMQprP6BvZ0a4fqHh9ddw+IahdeF7Flhi7Gvn42QFMGKqJyBFe523X6Mzzz/VmB
         sXqmiwtcajcabDcF3WsFOcPxOztxl2aESFPALskPJq+FYEQirKPL8dcO+lZZzX2Bwq
         9IMDFBpD9O5Cri6tjgNmgy8y9/+uVvxWJt/pUWpgmcWaFFadwXLa4UOhLz3T1KmsYK
         sv7jK/84UX3MQ==
Date:   Fri, 19 Mar 2021 16:14:07 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.11 13/31] net: bonding: fix error return code of
 bond_neigh_init()
In-Reply-To: <YFS0dlTZN9ApED93@kroah.com>
Message-ID: <nycvar.YFH.7.76.2103191613470.12405@cbobk.fhfr.pm>
References: <20210319121747.203523570@linuxfoundation.org> <20210319121747.622717971@linuxfoundation.org> <alpine.LRH.2.00.2103191511500.19651@gjva.wvxbf.pm> <YFS0dlTZN9ApED93@kroah.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Mar 2021, Greg Kroah-Hartman wrote:

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
> Is Linus's tree also broken for you?  This showed up in 5.12-rc3.

Yes, it is.

-- 
Jiri Kosina
SUSE Labs

