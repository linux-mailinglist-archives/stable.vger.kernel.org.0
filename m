Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 619789E11C
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732389AbfH0IDv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:03:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:33102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732375AbfH0IDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 04:03:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C2EB206BA;
        Tue, 27 Aug 2019 08:03:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566893030;
        bh=0WztkM7xhbrKQ4NJ4fgJQ8SR2b4RPZScZv0aK7cZHz0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ai1Wp6Ds6NSojENQ4VXcc3osRRaNkg1Pl1EbJkek3d6ht6FvLdsyEWolGJhj0Zlp6
         3yn02eNu8KcREyc67Wmvl95ddyA+h6egYrrsEMqMdaALlcHTHFnLmzFaj5t0emCimA
         Z10llsZsV7gfZIjL+BZoUYJA8zzXcyF/9cZv70dE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiangfeng Xiao <xiaojiangfeng@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 095/162] net: hisilicon: Fix dma_map_single failed on arm64
Date:   Tue, 27 Aug 2019 09:50:23 +0200
Message-Id: <20190827072741.513269937@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072738.093683223@linuxfoundation.org>
References: <20190827072738.093683223@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 96a50c0d907ac8f5c3d6b051031a19eb8a2b53e3 ]

On the arm64 platform, executing "ifconfig eth0 up" will fail,
returning "ifconfig: SIOCSIFFLAGS: Input/output error."

ndev->dev is not initialized, dma_map_single->get_dma_ops->
dummy_dma_ops->__dummy_map_page will return DMA_ERROR_CODE
directly, so when we use dma_map_single, the first parameter
is to use the device of platform_device.

Signed-off-by: Jiangfeng Xiao <xiaojiangfeng@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hip04_eth.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hip04_eth.c b/drivers/net/ethernet/hisilicon/hip04_eth.c
index ee6da8d66cd31..51cf6b0db904b 100644
--- a/drivers/net/ethernet/hisilicon/hip04_eth.c
+++ b/drivers/net/ethernet/hisilicon/hip04_eth.c
@@ -153,6 +153,7 @@ struct hip04_priv {
 	unsigned int reg_inten;
 
 	struct napi_struct napi;
+	struct device *dev;
 	struct net_device *ndev;
 
 	struct tx_desc *tx_desc;
@@ -383,7 +384,7 @@ static int hip04_tx_reclaim(struct net_device *ndev, bool force)
 		}
 
 		if (priv->tx_phys[tx_tail]) {
-			dma_unmap_single(&ndev->dev, priv->tx_phys[tx_tail],
+			dma_unmap_single(priv->dev, priv->tx_phys[tx_tail],
 					 priv->tx_skb[tx_tail]->len,
 					 DMA_TO_DEVICE);
 			priv->tx_phys[tx_tail] = 0;
@@ -434,8 +435,8 @@ hip04_mac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 		return NETDEV_TX_BUSY;
 	}
 
-	phys = dma_map_single(&ndev->dev, skb->data, skb->len, DMA_TO_DEVICE);
-	if (dma_mapping_error(&ndev->dev, phys)) {
+	phys = dma_map_single(priv->dev, skb->data, skb->len, DMA_TO_DEVICE);
+	if (dma_mapping_error(priv->dev, phys)) {
 		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
@@ -505,7 +506,7 @@ static int hip04_rx_poll(struct napi_struct *napi, int budget)
 			goto refill;
 		}
 
-		dma_unmap_single(&ndev->dev, priv->rx_phys[priv->rx_head],
+		dma_unmap_single(priv->dev, priv->rx_phys[priv->rx_head],
 				 RX_BUF_SIZE, DMA_FROM_DEVICE);
 		priv->rx_phys[priv->rx_head] = 0;
 
@@ -534,9 +535,9 @@ refill:
 		buf = netdev_alloc_frag(priv->rx_buf_size);
 		if (!buf)
 			goto done;
-		phys = dma_map_single(&ndev->dev, buf,
+		phys = dma_map_single(priv->dev, buf,
 				      RX_BUF_SIZE, DMA_FROM_DEVICE);
-		if (dma_mapping_error(&ndev->dev, phys))
+		if (dma_mapping_error(priv->dev, phys))
 			goto done;
 		priv->rx_buf[priv->rx_head] = buf;
 		priv->rx_phys[priv->rx_head] = phys;
@@ -639,9 +640,9 @@ static int hip04_mac_open(struct net_device *ndev)
 	for (i = 0; i < RX_DESC_NUM; i++) {
 		dma_addr_t phys;
 
-		phys = dma_map_single(&ndev->dev, priv->rx_buf[i],
+		phys = dma_map_single(priv->dev, priv->rx_buf[i],
 				      RX_BUF_SIZE, DMA_FROM_DEVICE);
-		if (dma_mapping_error(&ndev->dev, phys))
+		if (dma_mapping_error(priv->dev, phys))
 			return -EIO;
 
 		priv->rx_phys[i] = phys;
@@ -675,7 +676,7 @@ static int hip04_mac_stop(struct net_device *ndev)
 
 	for (i = 0; i < RX_DESC_NUM; i++) {
 		if (priv->rx_phys[i]) {
-			dma_unmap_single(&ndev->dev, priv->rx_phys[i],
+			dma_unmap_single(priv->dev, priv->rx_phys[i],
 					 RX_BUF_SIZE, DMA_FROM_DEVICE);
 			priv->rx_phys[i] = 0;
 		}
@@ -819,6 +820,7 @@ static int hip04_mac_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	priv = netdev_priv(ndev);
+	priv->dev = d;
 	priv->ndev = ndev;
 	platform_set_drvdata(pdev, ndev);
 	SET_NETDEV_DEV(ndev, &pdev->dev);
-- 
2.20.1



