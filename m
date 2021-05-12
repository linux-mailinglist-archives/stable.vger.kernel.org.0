Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEB4437CA6A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237316AbhELQaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:30:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231733AbhELQV6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:21:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D1CD2613C1;
        Wed, 12 May 2021 15:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834410;
        bh=/eUJkXkBmOsXOpykiOeBOrZfPsjIwNMYCY4YJqVHwhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w273FAhg3073KHqTeSp8UuHgPu3EmgCWT93+nKc7sY5j25+O2L5PNS+AurrPa8st+
         UxFcJjRdUKJobkSwNgO0AsRQhIzjVFodNamoiR5G3K0iTkmARcMBvTC3M6hr3Xozr+
         LFtdu05Nb1jqm30pa4Qqa97htDUmho0n2sRKafnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 533/601] net: ethernet: ixp4xx: Set the DMA masks explicitly
Date:   Wed, 12 May 2021 16:50:10 +0200
Message-Id: <20210512144845.405156971@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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
index 2e5202923510..403358f2c853 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1086,7 +1086,7 @@ static int init_queues(struct port *port)
 	int i;
 
 	if (!ports_open) {
-		dma_pool = dma_pool_create(DRV_NAME, port->netdev->dev.parent,
+		dma_pool = dma_pool_create(DRV_NAME, &port->netdev->dev,
 					   POOL_ALLOC_SIZE, 32, 0);
 		if (!dma_pool)
 			return -ENOMEM;
@@ -1436,6 +1436,9 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 	ndev->netdev_ops = &ixp4xx_netdev_ops;
 	ndev->ethtool_ops = &ixp4xx_ethtool_ops;
 	ndev->tx_queue_len = 100;
+	/* Inherit the DMA masks from the platform device */
+	ndev->dev.dma_mask = dev->dma_mask;
+	ndev->dev.coherent_dma_mask = dev->coherent_dma_mask;
 
 	netif_napi_add(ndev, &port->napi, eth_poll, NAPI_WEIGHT);
 
-- 
2.30.2



