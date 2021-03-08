Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503F833107E
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 15:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhCHOMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 09:12:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:39884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231184AbhCHOLy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Mar 2021 09:11:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 80586650F2;
        Mon,  8 Mar 2021 14:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615212714;
        bh=7NQYViq1K/ArxZ0PMXgM0Mljqh1vleJSjOTVqm6z4SU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LMqKuem1vPWCxyhbPs5R71G600fCYN8q3kVVffh7HuPIYcB40JECDTJk9XRNJhYP/
         WOIPMlAQZhGCe4JkO5k9XTmaB1KQnX4IYNDSOZ0vSIRXz5+kRwhRYuURuwG7Y8Mad9
         BmIgiD81rtE4nAbJzRND5KuSPhbh2qNqVmWEJInM=
Date:   Mon, 8 Mar 2021 14:21:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Gong, Sishuai" <sishuai@purdue.edu>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 031/102] net: fix dev_ifsioc_locked() race condition
Message-ID: <YEYky4Lkd7CBWPT3@kroah.com>
References: <20210305120903.276489876@linuxfoundation.org>
 <20210305120904.814003997@linuxfoundation.org>
 <20210308125057.GA19538@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308125057.GA19538@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 08, 2021 at 01:50:57PM +0100, Pavel Machek wrote:
> Hi!
> 
> > commit 3b23a32a63219f51a5298bc55a65ecee866e79d0 upstream.
> > 
> > dev_ifsioc_locked() is called with only RCU read lock, so when
> > there is a parallel writer changing the mac address, it could
> > get a partially updated mac address, as shown below:
> > 
> > Thread 1			Thread 2
> > // eth_commit_mac_addr_change()
> > memcpy(dev->dev_addr, addr->sa_data, ETH_ALEN);
> > 				// dev_ifsioc_locked()
> > 				memcpy(ifr->ifr_hwaddr.sa_data,
> > 					dev->dev_addr,...);
> > 
> > Close this race condition by guarding them with a RW semaphore,
> > like netdev_get_name(). We can not use seqlock here as it does not
> 
> I guess it may fix a race, but... does it leak kernel stack data to
> userland?
> 
> 
> > +++ b/drivers/net/tap.c
> > @@ -1093,10 +1093,9 @@ static long tap_ioctl(struct file *file,
> >  			return -ENOLINK;
> >  		}
> >  		ret = 0;
> > -		u = tap->dev->type;
> > +		dev_get_mac_address(&sa, dev_net(tap->dev), tap->dev->name);
> >  		if (copy_to_user(&ifr->ifr_name, tap->dev->name, IFNAMSIZ) ||
> > -		    copy_to_user(&ifr->ifr_hwaddr.sa_data, tap->dev->dev_addr, ETH_ALEN) ||
> > -		    put_user(u, &ifr->ifr_hwaddr.sa_family))
> > +		    copy_to_user(&ifr->ifr_hwaddr, &sa, sizeof(sa)))
> >  			ret = -EFAULT;
> >  		tap_put_tap_dev(tap);
> >  		rtnl_unlock();
> 
> We copy whole "struct sockaddr".
> 
> > +int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_name)
> > +{
> > +	size_t size = sizeof(sa->sa_data);
> > +	struct net_device *dev;
> > +	int ret = 0;
> ...
> > +	if (!dev->addr_len)
> > +		memset(sa->sa_data, 0, size);
> > +	else
> > +		memcpy(sa->sa_data, dev->dev_addr,
> > +		       min_t(size_t, size, dev->addr_len));
> 
> But we only coppied dev->addr_len bytes in.
> 
> This would be very simple way to plug the leak.
> 
> Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index 75ca6c6d01d6..b67ff23a1f0d 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8714,11 +8714,9 @@ int dev_get_mac_address(struct sockaddr *sa, struct net *net, char *dev_name)
>  		ret = -ENODEV;
>  		goto unlock;
>  	}
> -	if (!dev->addr_len)
> -		memset(sa->sa_data, 0, size);
> -	else
> -		memcpy(sa->sa_data, dev->dev_addr,
> -		       min_t(size_t, size, dev->addr_len));
> +	memset(sa->sa_data, 0, size);
> +	memcpy(sa->sa_data, dev->dev_addr,
> +	       min_t(size_t, size, dev->addr_len));
>  	sa->sa_family = dev->type;
>  
>  unlock:
> 

Please submit this change properly to the networking developers, they
are not going to pick anything up this way.

greg k-h
