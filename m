Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57D25396811
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 20:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231305AbhEaSrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 14:47:02 -0400
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:27641 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231652AbhEaSqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 May 2021 14:46:44 -0400
Received: from [192.168.1.18] ([86.243.172.93])
        by mwinf5d55 with ME
        id BWl22500F21Fzsu03Wl3FP; Mon, 31 May 2021 20:45:03 +0200
X-ME-Helo: [192.168.1.18]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Mon, 31 May 2021 20:45:03 +0200
X-ME-IP: 86.243.172.93
Subject: Re: [PATCH 4.14 63/79] net: netcp: Fix an error message
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <20210531130636.002722319@linuxfoundation.org>
 <20210531130638.013062405@linuxfoundation.org>
From:   Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <dbc2fdf6-af63-3a15-3ec5-8fade9eb2685@wanadoo.fr>
Date:   Mon, 31 May 2021 20:45:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210531130638.013062405@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: fr
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


Le 31/05/2021 à 15:14, Greg Kroah-Hartman a écrit :
> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>
> [ Upstream commit ddb6e00f8413e885ff826e32521cff7924661de0 ]
>
> 'ret' is known to be 0 here.
> The expected error code is stored in 'tx_pipe->dma_queue', so use it
> instead.
>
> While at it, switch from %d to %pe which is more user friendly.
>
> Fixes: 84640e27f230 ("net: netcp: Add Keystone NetCP core ethernet driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/net/ethernet/ti/netcp_core.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
> index 437d36289786..67167bc49a3a 100644
> --- a/drivers/net/ethernet/ti/netcp_core.c
> +++ b/drivers/net/ethernet/ti/netcp_core.c
> @@ -1364,8 +1364,8 @@ int netcp_txpipe_open(struct netcp_tx_pipe *tx_pipe)
>   	tx_pipe->dma_queue = knav_queue_open(name, tx_pipe->dma_queue_id,
>   					     KNAV_QUEUE_SHARED);
>   	if (IS_ERR(tx_pipe->dma_queue)) {
> -		dev_err(dev, "Could not open DMA queue for channel \"%s\": %d\n",
> -			name, ret);
> +		dev_err(dev, "Could not open DMA queue for channel \"%s\": %pe\n",
> +			name, tx_pipe->dma_queue);
>   		ret = PTR_ERR(tx_pipe->dma_queue);
>   		goto err;
>   	}


Hi,

Apparently %pe is only supported up to (including) 5.5. It is not part 
of 5.4.123.

So this patch should not be backported here or should be backported 
differently, ie:
    leave dev_err as-is
    move "ret = PTR_ERR(tx_pipe->dma_queue);" 1 line above

(or %pe should be backported first)


PS: adding Dan Carpenter because we had a small discussion about some 
potential backport issue when, using %pe

CJ

