Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B42F859BFD4
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 14:55:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiHVMzf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 08:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234965AbiHVMzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 08:55:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6B0C1BEBF
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 05:55:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61F0161152
        for <stable@vger.kernel.org>; Mon, 22 Aug 2022 12:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68662C433D6;
        Mon, 22 Aug 2022 12:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661172930;
        bh=LJMe86dltAbusPJ1eHLHOHN9KFg+fhq1ZHw6X7mYYgI=;
        h=Subject:To:Cc:From:Date:From;
        b=j3UTRsNrYau4VOqHPbfhvdio9dr97NQzRSXfd8ZjEPbfZ0mdNKY0Z3ESg7SVth10F
         AF8KAWmDGVvrzXAKFi1YjsdIFGTt0flM/rJGRM39MSdA7Kr0ptIBximFFYWE6QdjCN
         BPZ3B1xXAzDyw0fgPvucPhwHVRNjFg7ivTPnqOxk=
Subject: FAILED: patch "[PATCH] net: moxa: pass pdev instead of ndev to DMA functions" failed to apply to 4.14-stable tree
To:     saproj@gmail.com, andrew@lunn.ch, kuba@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 22 Aug 2022 14:55:17 +0200
Message-ID: <166117291796235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3a12df22a8f68954a4ba48435c06b3d1791c87c4 Mon Sep 17 00:00:00 2001
From: Sergei Antonov <saproj@gmail.com>
Date: Fri, 12 Aug 2022 20:13:39 +0300
Subject: [PATCH] net: moxa: pass pdev instead of ndev to DMA functions

dma_map_single() calls fail in moxart_mac_setup_desc_ring() and
moxart_mac_start_xmit() which leads to an incessant output of this:

[   16.043925] moxart-ethernet 92000000.mac eth0: DMA mapping error
[   16.050957] moxart-ethernet 92000000.mac eth0: DMA mapping error
[   16.058229] moxart-ethernet 92000000.mac eth0: DMA mapping error

Passing pdev to DMA is a common approach among net drivers.

Fixes: 6c821bd9edc9 ("net: Add MOXA ART SoCs ethernet driver")
Signed-off-by: Sergei Antonov <saproj@gmail.com>
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20220812171339.2271788-1-saproj@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/drivers/net/ethernet/moxa/moxart_ether.c b/drivers/net/ethernet/moxa/moxart_ether.c
index a3214a762e4b..f11f1cb92025 100644
--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -77,7 +77,7 @@ static void moxart_mac_free_memory(struct net_device *ndev)
 	int i;
 
 	for (i = 0; i < RX_DESC_NUM; i++)
-		dma_unmap_single(&ndev->dev, priv->rx_mapping[i],
+		dma_unmap_single(&priv->pdev->dev, priv->rx_mapping[i],
 				 priv->rx_buf_size, DMA_FROM_DEVICE);
 
 	if (priv->tx_desc_base)
@@ -147,11 +147,11 @@ static void moxart_mac_setup_desc_ring(struct net_device *ndev)
 		       desc + RX_REG_OFFSET_DESC1);
 
 		priv->rx_buf[i] = priv->rx_buf_base + priv->rx_buf_size * i;
-		priv->rx_mapping[i] = dma_map_single(&ndev->dev,
+		priv->rx_mapping[i] = dma_map_single(&priv->pdev->dev,
 						     priv->rx_buf[i],
 						     priv->rx_buf_size,
 						     DMA_FROM_DEVICE);
-		if (dma_mapping_error(&ndev->dev, priv->rx_mapping[i]))
+		if (dma_mapping_error(&priv->pdev->dev, priv->rx_mapping[i]))
 			netdev_err(ndev, "DMA mapping error\n");
 
 		moxart_desc_write(priv->rx_mapping[i],
@@ -240,7 +240,7 @@ static int moxart_rx_poll(struct napi_struct *napi, int budget)
 		if (len > RX_BUF_SIZE)
 			len = RX_BUF_SIZE;
 
-		dma_sync_single_for_cpu(&ndev->dev,
+		dma_sync_single_for_cpu(&priv->pdev->dev,
 					priv->rx_mapping[rx_head],
 					priv->rx_buf_size, DMA_FROM_DEVICE);
 		skb = netdev_alloc_skb_ip_align(ndev, len);
@@ -294,7 +294,7 @@ static void moxart_tx_finished(struct net_device *ndev)
 	unsigned int tx_tail = priv->tx_tail;
 
 	while (tx_tail != tx_head) {
-		dma_unmap_single(&ndev->dev, priv->tx_mapping[tx_tail],
+		dma_unmap_single(&priv->pdev->dev, priv->tx_mapping[tx_tail],
 				 priv->tx_len[tx_tail], DMA_TO_DEVICE);
 
 		ndev->stats.tx_packets++;
@@ -358,9 +358,9 @@ static netdev_tx_t moxart_mac_start_xmit(struct sk_buff *skb,
 
 	len = skb->len > TX_BUF_SIZE ? TX_BUF_SIZE : skb->len;
 
-	priv->tx_mapping[tx_head] = dma_map_single(&ndev->dev, skb->data,
+	priv->tx_mapping[tx_head] = dma_map_single(&priv->pdev->dev, skb->data,
 						   len, DMA_TO_DEVICE);
-	if (dma_mapping_error(&ndev->dev, priv->tx_mapping[tx_head])) {
+	if (dma_mapping_error(&priv->pdev->dev, priv->tx_mapping[tx_head])) {
 		netdev_err(ndev, "DMA mapping error\n");
 		goto out_unlock;
 	}
@@ -379,7 +379,7 @@ static netdev_tx_t moxart_mac_start_xmit(struct sk_buff *skb,
 		len = ETH_ZLEN;
 	}
 
-	dma_sync_single_for_device(&ndev->dev, priv->tx_mapping[tx_head],
+	dma_sync_single_for_device(&priv->pdev->dev, priv->tx_mapping[tx_head],
 				   priv->tx_buf_size, DMA_TO_DEVICE);
 
 	txdes1 = TX_DESC1_LTS | TX_DESC1_FTS | (len & TX_DESC1_BUF_SIZE_MASK);
@@ -493,7 +493,7 @@ static int moxart_mac_probe(struct platform_device *pdev)
 	priv->tx_buf_size = TX_BUF_SIZE;
 	priv->rx_buf_size = RX_BUF_SIZE;
 
-	priv->tx_desc_base = dma_alloc_coherent(&pdev->dev, TX_REG_DESC_SIZE *
+	priv->tx_desc_base = dma_alloc_coherent(p_dev, TX_REG_DESC_SIZE *
 						TX_DESC_NUM, &priv->tx_base,
 						GFP_DMA | GFP_KERNEL);
 	if (!priv->tx_desc_base) {
@@ -501,7 +501,7 @@ static int moxart_mac_probe(struct platform_device *pdev)
 		goto init_fail;
 	}
 
-	priv->rx_desc_base = dma_alloc_coherent(&pdev->dev, RX_REG_DESC_SIZE *
+	priv->rx_desc_base = dma_alloc_coherent(p_dev, RX_REG_DESC_SIZE *
 						RX_DESC_NUM, &priv->rx_base,
 						GFP_DMA | GFP_KERNEL);
 	if (!priv->rx_desc_base) {

