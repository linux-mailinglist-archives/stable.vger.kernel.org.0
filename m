Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2385D341F0D
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 15:13:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbhCSOM4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 10:12:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:59584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230024AbhCSOM2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 10:12:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EE6964F1C;
        Fri, 19 Mar 2021 14:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616163148;
        bh=KXrGBUZMFLNiZaXs6Vj0EbHwh4Z0nzxPzhvXI/SodMk=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=Pyt6Qdr3WqCIu0e6GqHh45t9pGVNMM59AxCBgOyGSKQ55RtKA/59m2AyZ7+8jIxiR
         goZM3PXaii0xSNLa6U0Hv27Ebq/7+RikB/jd/qRoltIb4zP+/ALXVcK42r63oNwX74
         DQdaTZ3VO7dZsj9LfRQrmcwiFperaIluCmuyOJC0HExcv7QwUcGymmKCBJBIzZ+Na1
         wDtosKhmlgvb7qQXB93DkvFtG9Edth++PVg0fwcdorDwSQFa6xMrRFGZ5WbxgNPuWU
         7zERUls3brSy2Ur3Q9ZXHmuyFBMktv0WMHbHFM2NIdnYxRkRFO44xVuoB2yxYi5Juf
         xjPG2oJZ2dgqQ==
Date:   Fri, 19 Mar 2021 15:12:12 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        TOTE Robot <oslab@tsinghua.edu.cn>,
        Jia-Ju Bai <baijiaju1990@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.11 13/31] net: bonding: fix error return code of
 bond_neigh_init()
In-Reply-To: <20210319121747.622717971@linuxfoundation.org>
Message-ID: <alpine.LRH.2.00.2103191511500.19651@gjva.wvxbf.pm>
References: <20210319121747.203523570@linuxfoundation.org> <20210319121747.622717971@linuxfoundation.org>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 19 Mar 2021, Greg Kroah-Hartman wrote:

> From: Jia-Ju Bai <baijiaju1990@gmail.com>
> 
> [ Upstream commit 2055a99da8a253a357bdfd359b3338ef3375a26c ]
> 
> When slave is NULL or slave_ops->ndo_neigh_setup is NULL, no error
> return code of bond_neigh_init() is assigned.
> To fix this bug, ret is assigned with -EINVAL in these cases.
> 
> Fixes: 9e99bfefdbce ("bonding: fix bond_neigh_init()")
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/net/bonding/bond_main.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
> index 5fe5232cc3f3..fba6b6d1b430 100644
> --- a/drivers/net/bonding/bond_main.c
> +++ b/drivers/net/bonding/bond_main.c
> @@ -3917,11 +3917,15 @@ static int bond_neigh_init(struct neighbour *n)
>  
>  	rcu_read_lock();
>  	slave = bond_first_slave_rcu(bond);
> -	if (!slave)
> +	if (!slave) {
> +		ret = -EINVAL;
>  		goto out;
> +	}
>  	slave_ops = slave->dev->netdev_ops;
> -	if (!slave_ops->ndo_neigh_setup)
> +	if (!slave_ops->ndo_neigh_setup) {
> +		ret = -EINVAL;
>  		goto out;
> +	}

This patch is completely broken and breaks bonding functionality 
altogether for me.

-- 
Jiri Kosina
SUSE Labs
