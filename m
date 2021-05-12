Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CAFE37CE8A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344990AbhELRFh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244447AbhELQqG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:46:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C415A6101B;
        Wed, 12 May 2021 16:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836096;
        bh=HLYi6aLt9FcfHvOVe52fF2AvTbB+esq6orx1a3UQmTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PBaG6bulvn/SMOIm8c+X/f52CdJvwwUwUQwnjXvIl4/ACHq+rS3w5Dh6J3oedzR6v
         iYIy5GG9ko62cLkr2yGaXP5ML+D7AxiEM3uWEmPfq0KYpGCUKPDk6+ISRhzy7an8fL
         KySCS0UioidoaJtIDMVw/x/a4n8ycHPuMNHh3wqY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 601/677] net: ethernet: ixp4xx: Set the DMA masks explicitly
Date:   Wed, 12 May 2021 16:50:47 +0200
Message-Id: <20210512144857.337079756@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 8d892d60941b00c86d2029c8a99db24ab4979673 ]

The former fix only papered over the actual problem: the
ethernet core expects the netdev .dev member to have the
proper DMA masks set, or there will be BUG_ON() triggered
in kernel/dma/mapping.c.

Fix this by simply copying dma_mask and dma_mask_coherent
from the parent device.

Fixes: e45d0fad4a5f ("net: ethernet: ixp4xx: Use parent dev for DMA pool")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 0152f1e70783..9defaa21a1a9 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1085,7 +1085,7 @@ static int init_queues(struct port *port)
 	int i;
 
 	if (!ports_open) {
-		dma_pool = dma_pool_create(DRV_NAME, port->netdev->dev.parent,
+		dma_pool = dma_pool_create(DRV_NAME, &port->netdev->dev,
 					   POOL_ALLOC_SIZE, 32, 0);
 		if (!dma_pool)
 			return -ENOMEM;
@@ -1435,6 +1435,9 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	ndev->netdev_ops = &ixp4xx_netdev_ops;
 	ndev->ethtool_ops = &ixp4xx_ethtool_ops;
 	ndev->tx_queue_len = 100;
+	/* Inherit the DMA masks from the platform device */
+	ndev->dev.dma_mask = dev->dma_mask;
+	ndev->dev.coherent_dma_mask = dev->coherent_dma_mask;
 
 	netif_napi_add(ndev, &port->napi, eth_poll, NAPI_WEIGHT);
 
-- 
2.30.2



