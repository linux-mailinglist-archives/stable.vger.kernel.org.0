Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD8AA59E26D
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358628AbiHWL4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:56:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358820AbiHWLyg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:54:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37977E0FD;
        Tue, 23 Aug 2022 02:33:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B40EB81C89;
        Tue, 23 Aug 2022 09:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC73FC4347C;
        Tue, 23 Aug 2022 09:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247167;
        bh=5YsuL1rXMFxHroUtJboMymafT37h5Z12yG4GQBInd8Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IJ1M4DCTcOB8LldiqnjMN8fraQEIG9rPuyEMRPHWtxELvkGWXLyEaWtkp0ob0BFct
         IqesnqNA6KmQQ6Gp+aeNfaPHR2Nyj6n0mvrYXKfqRLVy9GojMJqoi1Q3lRwber0dQe
         KbNpPw389cgPoYn1ejuOm9oUJuWZWj5bgMtrBLp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Antonov <saproj@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 340/389] net: moxa: pass pdev instead of ndev to DMA functions
Date:   Tue, 23 Aug 2022 10:26:58 +0200
Message-Id: <20220823080129.732696842@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Sergei Antonov <saproj@gmail.com>

commit 3a12df22a8f68954a4ba48435c06b3d1791c87c4 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/moxa/moxart_ether.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/net/ethernet/moxa/moxart_ether.c
+++ b/drivers/net/ethernet/moxa/moxart_ether.c
@@ -77,7 +77,7 @@ static void moxart_mac_free_memory(struc
 	int i;
 
 	for (i = 0; i < RX_DESC_NUM; i++)
-		dma_unmap_single(&ndev->dev, priv->rx_mapping[i],
+		dma_unmap_single(&priv->pdev->dev, priv->rx_mapping[i],
 				 priv->rx_buf_size, DMA_FROM_DEVICE);
 
 	if (priv->tx_desc_base)
@@ -147,11 +147,11 @@ static void moxart_mac_setup_desc_ring(s
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
@@ -240,7 +240,7 @@ static int moxart_rx_poll(struct napi_st
 		if (len > RX_BUF_SIZE)
 			len = RX_BUF_SIZE;
 
-		dma_sync_single_for_cpu(&ndev->dev,
+		dma_sync_single_for_cpu(&priv->pdev->dev,
 					priv->rx_mapping[rx_head],
 					priv->rx_buf_size, DMA_FROM_DEVICE);
 		skb = netdev_alloc_skb_ip_align(ndev, len);
@@ -294,7 +294,7 @@ static void moxart_tx_finished(struct ne
 	unsigned int tx_tail = priv->tx_tail;
 
 	while (tx_tail != tx_head) {
-		dma_unmap_single(&ndev->dev, priv->tx_mapping[tx_tail],
+		dma_unmap_single(&priv->pdev->dev, priv->tx_mapping[tx_tail],
 				 priv->tx_len[tx_tail], DMA_TO_DEVICE);
 
 		ndev->stats.tx_packets++;
@@ -357,9 +357,9 @@ static int moxart_mac_start_xmit(struct
 
 	len = skb->len > TX_BUF_SIZE ? TX_BUF_SIZE : skb->len;
 
-	priv->tx_mapping[tx_head] = dma_map_single(&ndev->dev, skb->data,
+	priv->tx_mapping[tx_head] = dma_map_single(&priv->pdev->dev, skb->data,
 						   len, DMA_TO_DEVICE);
-	if (dma_mapping_error(&ndev->dev, priv->tx_mapping[tx_head])) {
+	if (dma_mapping_error(&priv->pdev->dev, priv->tx_mapping[tx_head])) {
 		netdev_err(ndev, "DMA mapping error\n");
 		goto out_unlock;
 	}
@@ -378,7 +378,7 @@ static int moxart_mac_start_xmit(struct
 		len = ETH_ZLEN;
 	}
 
-	dma_sync_single_for_device(&ndev->dev, priv->tx_mapping[tx_head],
+	dma_sync_single_for_device(&priv->pdev->dev, priv->tx_mapping[tx_head],
 				   priv->tx_buf_size, DMA_TO_DEVICE);
 
 	txdes1 = TX_DESC1_LTS | TX_DESC1_FTS | (len & TX_DESC1_BUF_SIZE_MASK);
@@ -498,7 +498,7 @@ static int moxart_mac_probe(struct platf
 	priv->tx_buf_size = TX_BUF_SIZE;
 	priv->rx_buf_size = RX_BUF_SIZE;
 
-	priv->tx_desc_base = dma_alloc_coherent(&pdev->dev, TX_REG_DESC_SIZE *
+	priv->tx_desc_base = dma_alloc_coherent(p_dev, TX_REG_DESC_SIZE *
 						TX_DESC_NUM, &priv->tx_base,
 						GFP_DMA | GFP_KERNEL);
 	if (!priv->tx_desc_base) {
@@ -506,7 +506,7 @@ static int moxart_mac_probe(struct platf
 		goto init_fail;
 	}
 
-	priv->rx_desc_base = dma_alloc_coherent(&pdev->dev, RX_REG_DESC_SIZE *
+	priv->rx_desc_base = dma_alloc_coherent(p_dev, RX_REG_DESC_SIZE *
 						RX_DESC_NUM, &priv->rx_base,
 						GFP_DMA | GFP_KERNEL);
 	if (!priv->rx_desc_base) {


