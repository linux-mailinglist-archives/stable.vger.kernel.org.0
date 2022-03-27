Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 867AE4E88E5
	for <lists+stable@lfdr.de>; Sun, 27 Mar 2022 18:38:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236044AbiC0QkT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 12:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236072AbiC0QkQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 12:40:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51370261C;
        Sun, 27 Mar 2022 09:38:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1E38B80D89;
        Sun, 27 Mar 2022 16:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2073DC340EC;
        Sun, 27 Mar 2022 16:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648399115;
        bh=QAaO5L4NqAlCNulmy+O4X6kte3dGuHZtQf0q+5vG9Qo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NaExAObnJMFh1sJitxjXppDB/9ElBotMK5GD0/eid3FDbRstW/pDNiOgJCtWb6Pqz
         Ns+KJ2LXDiLa6ZPD1MHOTwp1+Z7NYq1NiJV9y8YzFTNPzvEIJlXMzyWTs7ihsQj82n
         OX0TWneJKcPu8TNPQEhdnuYXjB52FCNrQbxk+9VUXEQuS5avJHDf5DRRvQUOyTahEh
         f0vJp2ZQDbE3KCWO5aQzfkBH1C+Mh8ifZ9ZkHWtEIkupQwKERGr6naB9DouslmY5fC
         g9pRskkbzDpoKk5Y5szo177EDOU/Nxeew1yEewo6pnVfqwlnEw4n2uRHDJKnEGQwh2
         2MWWO/QKxm7Jw==
Date:   Sun, 27 Mar 2022 19:38:31 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     bharat@chelsio.com, jgg@ziepe.ca, vipul@chelsio.com,
        roland@purestorage.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] cxgb4: cm: fix a incorrect NULL check on list iterator
Message-ID: <YkCTB/F4jc3DWRo8@unreal>
References: <20220327073542.10990-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220327073542.10990-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Mar 27, 2022 at 03:35:42PM +0800, Xiaomeng Tong wrote:
> The bug is here:
> 	if (!pdev) {
> 
> The list iterator value 'pdev' will *always* be set and non-NULL
> by for_each_netdev(), so it is incorrect to assume that the
> iterator value will be NULL if the list is empty or no element
> found (in this case, the check 'if (!pdev)' can be bypassed as
> it always be false unexpectly).
> 
> To fix the bug, use a new variable 'iter' as the list iterator,
> while use the original variable 'pdev' as a dedicated pointer to
> point to the found element.

I don't think that the description is correct.
We are talking about loopback interface which received packet, the pdev will always exist.
Most likely. the check of "if (!pdev)" is to catch impossible situation where IPV6 packet
was sent over loopback, but IPV6 is not enabled.

Thanks

> 
> Cc: stable@vger.kernel.org
> Fixes: 830662f6f032f ("RDMA/cxgb4: Add support for active and passive open connection with IPv6 address")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  drivers/infiniband/hw/cxgb4/cm.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
> index c16017f6e8db..870d8517310b 100644
> --- a/drivers/infiniband/hw/cxgb4/cm.c
> +++ b/drivers/infiniband/hw/cxgb4/cm.c
> @@ -2071,7 +2071,7 @@ static int import_ep(struct c4iw_ep *ep, int iptype, __u8 *peer_ip,
>  {
>  	struct neighbour *n;
>  	int err, step;
> -	struct net_device *pdev;
> +	struct net_device *pdev = NULL, *iter;
>  
>  	n = dst_neigh_lookup(dst, peer_ip);
>  	if (!n)
> @@ -2083,14 +2083,14 @@ static int import_ep(struct c4iw_ep *ep, int iptype, __u8 *peer_ip,
>  		if (iptype == 4)
>  			pdev = ip_dev_find(&init_net, *(__be32 *)peer_ip);
>  		else if (IS_ENABLED(CONFIG_IPV6))
> -			for_each_netdev(&init_net, pdev) {
> +			for_each_netdev(&init_net, iter) {
>  				if (ipv6_chk_addr(&init_net,
>  						  (struct in6_addr *)peer_ip,
> -						  pdev, 1))
> +						  iter, 1)) {
> +					pdev = iter;
>  					break;
> +				}
>  			}
> -		else
> -			pdev = NULL;
>  
>  		if (!pdev) {
>  			err = -ENODEV;
> -- 
> 2.17.1
> 
