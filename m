Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53571218802
	for <lists+stable@lfdr.de>; Wed,  8 Jul 2020 14:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbgGHMuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jul 2020 08:50:17 -0400
Received: from stargate.chelsio.com ([12.32.117.8]:53652 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbgGHMuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jul 2020 08:50:17 -0400
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 068Cnn5v011537;
        Wed, 8 Jul 2020 05:49:54 -0700
Date:   Wed, 8 Jul 2020 18:06:57 +0530
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, nirranjan@chelsio.com
Subject: Re: [PATCH 4.19 17/36] cxgb4: use correct type for all-mask IP
 address comparison
Message-ID: <20200708123656.GA13635@chelsio.com>
References: <20200707145749.130272978@linuxfoundation.org>
 <20200707145749.959174058@linuxfoundation.org>
 <20200707213326.GB11158@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200707213326.GB11158@amd>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tuesday, July 07/07/20, 2020 at 23:33:26 +0200, Pavel Machek wrote:
> Hi!
> 
> > From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
> > 
> > [ Upstream commit f286dd8eaad5a2758750f407ab079298e0bcc8a5 ]
> > 
> > Use correct type to check for all-mask exact match IP addresses.
> > 
> > Fixes following sparse warnings due to big endian value checks
> > against 0xffffffff in is_addr_all_mask():
> > cxgb4_filter.c:977:25: warning: restricted __be32 degrades to integer
> > cxgb4_filter.c:983:37: warning: restricted __be32 degrades to integer
> > cxgb4_filter.c:984:37: warning: restricted __be32 degrades to integer
> > cxgb4_filter.c:985:37: warning: restricted __be32 degrades to integer
> > cxgb4_filter.c:986:37: warning: restricted __be32 degrades to integer
> 
> > diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
> > index 7dddb9e748b81..86745f33a252d 100644
> > --- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
> > +++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c
> > @@ -810,16 +810,16 @@ static bool is_addr_all_mask(u8 *ipmask, int family)
> >  		struct in_addr *addr;
> >  
> >  		addr = (struct in_addr *)ipmask;
> > -		if (addr->s_addr == 0xffffffff)
> > +		if (ntohl(addr->s_addr) == 0xffffffff)
> 
> Endianity does not really matter for ~0, but can compiler figure it
> out?
> 
> would it be better to do these tests as 
> 
>       if (foo == htonl(0xffffffff))
> 
> to make it clear to the compiler?
> 

Sure, I'll update all checks to follow above approach. Will send a
patch.

> 
> >  	} else if (family == AF_INET6) {
> >  		struct in6_addr *addr6;
> >  
> >  		addr6 = (struct in6_addr *)ipmask;
> > -		if (addr6->s6_addr32[0] == 0xffffffff &&
> > -		    addr6->s6_addr32[1] == 0xffffffff &&
> > -		    addr6->s6_addr32[2] == 0xffffffff &&
> > -		    addr6->s6_addr32[3] == 0xffffffff)
> > +		if (ntohl(addr6->s6_addr32[0]) == 0xffffffff &&
> > +		    ntohl(addr6->s6_addr32[1]) == 0xffffffff &&
> > +		    ntohl(addr6->s6_addr32[2]) == 0xffffffff &&
> > +		    ntohl(addr6->s6_addr32[3]) == 0xffffffff)
> >  			return true;
> >  	}
> >  	return false;
> 

Thanks,
Rahul
