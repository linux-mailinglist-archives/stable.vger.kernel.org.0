Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A5739695C
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 23:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232057AbhEaVoL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 17:44:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:33896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232042AbhEaVoK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 17:44:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CC6E86101C;
        Mon, 31 May 2021 21:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622497350;
        bh=7xqVdJ6VbiQeEU+7EPsKt6LFV9qCZNw0B2oWnGh0sFM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Dv2L+3SysDrZhPc45UFKLI5WmZtzuoO91R84zSJ9SX6VeUDdb8K9WA+RyG2qcoLXE
         oedyKP8WX7sbO5uM3VZpFkGxdmRvzRLK+E8vUBWA8Blb+47yUdT78Id9OyUWRQCvJY
         nrm6G8raeKaZhiuNNnmcWxmhcOoA8wjYXEjyvl3AxZ6NLRvlk5KrrMVnE9Ju9UsLdn
         8FYWnKGB269awrra1Lj0vtWwrADRXIT34m2cokfq+76srU6IBJSDUt2bmIUmUI1r5O
         LDA/NGIvHVtcIMdbVbo0/YnxinkgBmni/RBgLGQ+DUuZaYBD5yZdMQd8PhrPr8cq/f
         A3y1V+obuFssA==
Date:   Mon, 31 May 2021 17:42:28 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 5.4 135/177] net: netcp: Fix an error message
Message-ID: <YLVYRMy9DTEsco+d@sashalap>
References: <20210531130647.887605866@linuxfoundation.org>
 <20210531130652.606363904@linuxfoundation.org>
 <60ba11bd-acc0-d48d-ad80-6987847e6e79@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <60ba11bd-acc0-d48d-ad80-6987847e6e79@wanadoo.fr>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 08:46:03PM +0200, Marion & Christophe JAILLET wrote:
>
>Le 31/05/2021 à 15:14, Greg Kroah-Hartman a écrit :
>>From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>
>>[ Upstream commit ddb6e00f8413e885ff826e32521cff7924661de0 ]
>>
>>'ret' is known to be 0 here.
>>The expected error code is stored in 'tx_pipe->dma_queue', so use it
>>instead.
>>
>>While at it, switch from %d to %pe which is more user friendly.
>>
>>Fixes: 84640e27f230 ("net: netcp: Add Keystone NetCP core ethernet driver")
>>Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>>Signed-off-by: David S. Miller <davem@davemloft.net>
>>Signed-off-by: Sasha Levin <sashal@kernel.org>
>>---
>>  drivers/net/ethernet/ti/netcp_core.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>>diff --git a/drivers/net/ethernet/ti/netcp_core.c b/drivers/net/ethernet/ti/netcp_core.c
>>index 1b2702f74455..c0025bb8a584 100644
>>--- a/drivers/net/ethernet/ti/netcp_core.c
>>+++ b/drivers/net/ethernet/ti/netcp_core.c
>>@@ -1350,8 +1350,8 @@ int netcp_txpipe_open(struct netcp_tx_pipe *tx_pipe)
>>  	tx_pipe->dma_queue = knav_queue_open(name, tx_pipe->dma_queue_id,
>>  					     KNAV_QUEUE_SHARED);
>>  	if (IS_ERR(tx_pipe->dma_queue)) {
>>-		dev_err(dev, "Could not open DMA queue for channel \"%s\": %d\n",
>>-			name, ret);
>>+		dev_err(dev, "Could not open DMA queue for channel \"%s\": %pe\n",
>>+			name, tx_pipe->dma_queue);
>>  		ret = PTR_ERR(tx_pipe->dma_queue);
>>  		goto err;
>>  	}
>
>
>Hi,
>
>Apparently %pe is only supported up to (including) 5.5. It is not part 
>of 5.4.123.
>
>So this patch should not be backported here or should be backported 
>differently, ie:
>   leave dev_err as-is
>   move "ret = PTR_ERR(tx_pipe->dma_queue);" 1 line above

I'll fix it up the way you've described above. Thanks!

-- 
Thanks,
Sasha
