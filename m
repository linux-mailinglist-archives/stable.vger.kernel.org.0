Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 860C078FEF
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 17:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387619AbfG2P4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 11:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387583AbfG2P4b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 11:56:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF2CF206A2;
        Mon, 29 Jul 2019 15:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564415790;
        bh=gSiwmMZeDxBmjCQhQ31Kh5M5endBGQbunFxircdJAiE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1vwfgnBNH840FAWsT7OQn/l0fnKrciLclRg6XM+//H3aqKtgCzX4DRagqIwqFCxhO
         Ejo5oPhqT+C67CZ1UCel1q+eluTiK2xowNoK9x7HMMjEoX8FWJPjv27UKzBJsKuB4j
         klA0FsqL+BAij2stwhwxtkIZkjslhcbzg6YjhquU=
Date:   Mon, 29 Jul 2019 17:56:27 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        dsahern@gmail.com, davem@davemloft.net
Subject: Re: Back-porting request
Message-ID: <20190729155627.GA15584@kroah.com>
References: <20190729154234.GA3508@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190729154234.GA3508@ubuntu>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 29, 2019 at 11:42:34AM -0400, Stephen Suryaputra wrote:
> Hello,
> 
> I'm requesting this commit to be back-ported to v4.14:
> ---
> commit 5b18f1289808fee5d04a7e6ecf200189f41a4db6
> Author: Stephen Suryaputra <ssuryaextr@gmail.com>
> Date:   Wed Jun 26 02:21:16 2019 -0400
> 
>     ipv4: reset rt_iif for recirculated mcast/bcast out pkts
> 
>     Multicast or broadcast egress packets have rt_iif set to the oif. These
>     packets might be recirculated back as input and lookup to the raw
>     sockets may fail because they are bound to the incoming interface
>     (skb_iif). If rt_iif is not zero, during the lookup, inet_iif() function
>     returns rt_iif instead of skb_iif. Hence, the lookup fails.
> 
>     v2: Make it non vrf specific (David Ahern). Reword the changelog to
>         reflect it.
>     Signed-off-by: Stephen Suryaputra <ssuryaextr@gmail.com>
>     Reviewed-by: David Ahern <dsahern@gmail.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
> 
> We found the issue in that release and the above commit is on
> linux-stable. On the discussion behind this commit, please see:
> https://www.spinics.net/lists/netdev/msg581045.html
> 
> I think after the following diff is needed on top of the above commit
> for v4.14:
> 
> ---
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 4d85a4fdfdb0..ad2718c1624e 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -1623,11 +1623,8 @@ struct rtable *rt_dst_clone(struct net_device *dev, struct rtable *rt)
>  		new_rt->rt_iif = rt->rt_iif;
>  		new_rt->rt_pmtu = rt->rt_pmtu;
>  		new_rt->rt_mtu_locked = rt->rt_mtu_locked;
> -		new_rt->rt_gw_family = rt->rt_gw_family;
> -		if (rt->rt_gw_family == AF_INET)
> -			new_rt->rt_gw4 = rt->rt_gw4;
> -		else if (rt->rt_gw_family == AF_INET6)
> -			new_rt->rt_gw6 = rt->rt_gw6;
> +		new_rt->rt_gateway = rt->rt_gateway;
> +		new_rt->rt_table_id = rt->rt_table_id;
>  		INIT_LIST_HEAD(&new_rt->rt_uncached);
>  
>  		new_rt->dst.flags |= DST_HOST;
> ---
> 
> Thank you,

For networking patches to be applied to the stable kernel tree(s),
please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

There is a section for how to do this for networking patches as they are
accepted a bit differently from other patches.

thanks,

greg k-h
