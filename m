Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95AA6C1907
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232643AbjCTPaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbjCTP3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:29:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 102203865A
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:22:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6C926CE12F9
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2C2C433EF;
        Mon, 20 Mar 2023 15:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325745;
        bh=Ni8Z1ZlKn7EI803JA2UDDFE06j2UcC85v+ImFSY+3Rg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YrHWC5qss9tsrrBlMdBPP0TeVzYShCqcDRNWi9Q/M5T5JonN/NHaISvOfdFS9ldHO
         jA/kFhZ5+RvQJYlNVqdwIrii2hB7vw+tYmi5rXRJ20Qi4cS6ROPg/a+/GtFbJx8dpY
         QSpsWsPBeeMTQHAPvRqb0GZVK7fK4WqQC1vPJJCo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 094/211] net: renesas: rswitch: Rename rings in struct rswitch_gwca_queue
Date:   Mon, 20 Mar 2023 15:53:49 +0100
Message-Id: <20230320145517.231730552@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit 251eadcc640a0b5fd2767aaeb22a6f1ebf9b3c96 ]

To add a new ring which is really related to timestamp (ts_ring)
in the future, rename the following members to improve readability:

    ring --> tx_ring
    ts_ring --> rx_ring

Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: e05bb97d9c9d ("net: renesas: rswitch: Fix the output value of quote from rswitch_rx()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/rswitch.c | 64 +++++++++++++-------------
 drivers/net/ethernet/renesas/rswitch.h |  4 +-
 2 files changed, 34 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/renesas/rswitch.c b/drivers/net/ethernet/renesas/rswitch.c
index 2370c7797a0aa..847b1f161fc66 100644
--- a/drivers/net/ethernet/renesas/rswitch.c
+++ b/drivers/net/ethernet/renesas/rswitch.c
@@ -241,7 +241,7 @@ static int rswitch_get_num_cur_queues(struct rswitch_gwca_queue *gq)
 
 static bool rswitch_is_queue_rxed(struct rswitch_gwca_queue *gq)
 {
-	struct rswitch_ext_ts_desc *desc = &gq->ts_ring[gq->dirty];
+	struct rswitch_ext_ts_desc *desc = &gq->rx_ring[gq->dirty];
 
 	if ((desc->desc.die_dt & DT_MASK) != DT_FEMPTY)
 		return true;
@@ -284,13 +284,13 @@ static void rswitch_gwca_queue_free(struct net_device *ndev,
 	if (gq->gptp) {
 		dma_free_coherent(ndev->dev.parent,
 				  sizeof(struct rswitch_ext_ts_desc) *
-				  (gq->ring_size + 1), gq->ts_ring, gq->ring_dma);
-		gq->ts_ring = NULL;
+				  (gq->ring_size + 1), gq->rx_ring, gq->ring_dma);
+		gq->rx_ring = NULL;
 	} else {
 		dma_free_coherent(ndev->dev.parent,
 				  sizeof(struct rswitch_ext_desc) *
-				  (gq->ring_size + 1), gq->ring, gq->ring_dma);
-		gq->ring = NULL;
+				  (gq->ring_size + 1), gq->tx_ring, gq->ring_dma);
+		gq->tx_ring = NULL;
 	}
 
 	if (!gq->dir_tx) {
@@ -322,14 +322,14 @@ static int rswitch_gwca_queue_alloc(struct net_device *ndev,
 		rswitch_gwca_queue_alloc_skb(gq, 0, gq->ring_size);
 
 	if (gptp)
-		gq->ts_ring = dma_alloc_coherent(ndev->dev.parent,
+		gq->rx_ring = dma_alloc_coherent(ndev->dev.parent,
 						 sizeof(struct rswitch_ext_ts_desc) *
 						 (gq->ring_size + 1), &gq->ring_dma, GFP_KERNEL);
 	else
-		gq->ring = dma_alloc_coherent(ndev->dev.parent,
-					      sizeof(struct rswitch_ext_desc) *
-					      (gq->ring_size + 1), &gq->ring_dma, GFP_KERNEL);
-	if (!gq->ts_ring && !gq->ring)
+		gq->tx_ring = dma_alloc_coherent(ndev->dev.parent,
+						 sizeof(struct rswitch_ext_desc) *
+						 (gq->ring_size + 1), &gq->ring_dma, GFP_KERNEL);
+	if (!gq->rx_ring && !gq->tx_ring)
 		goto out;
 
 	i = gq->index / 32;
@@ -362,14 +362,14 @@ static int rswitch_gwca_queue_format(struct net_device *ndev,
 				     struct rswitch_private *priv,
 				     struct rswitch_gwca_queue *gq)
 {
-	int tx_ring_size = sizeof(struct rswitch_ext_desc) * gq->ring_size;
+	int ring_size = sizeof(struct rswitch_ext_desc) * gq->ring_size;
 	struct rswitch_ext_desc *desc;
 	struct rswitch_desc *linkfix;
 	dma_addr_t dma_addr;
 	int i;
 
-	memset(gq->ring, 0, tx_ring_size);
-	for (i = 0, desc = gq->ring; i < gq->ring_size; i++, desc++) {
+	memset(gq->tx_ring, 0, ring_size);
+	for (i = 0, desc = gq->tx_ring; i < gq->ring_size; i++, desc++) {
 		if (!gq->dir_tx) {
 			dma_addr = dma_map_single(ndev->dev.parent,
 						  gq->skbs[i]->data, PKT_BUF_SZ,
@@ -398,7 +398,7 @@ static int rswitch_gwca_queue_format(struct net_device *ndev,
 
 err:
 	if (!gq->dir_tx) {
-		for (i--, desc = gq->ring; i >= 0; i--, desc++) {
+		for (i--, desc = gq->tx_ring; i >= 0; i--, desc++) {
 			dma_addr = rswitch_desc_get_dptr(&desc->desc);
 			dma_unmap_single(ndev->dev.parent, dma_addr, PKT_BUF_SZ,
 					 DMA_FROM_DEVICE);
@@ -408,9 +408,9 @@ static int rswitch_gwca_queue_format(struct net_device *ndev,
 	return -ENOMEM;
 }
 
-static int rswitch_gwca_queue_ts_fill(struct net_device *ndev,
-				      struct rswitch_gwca_queue *gq,
-				      int start_index, int num)
+static int rswitch_gwca_queue_ext_ts_fill(struct net_device *ndev,
+					  struct rswitch_gwca_queue *gq,
+					  int start_index, int num)
 {
 	struct rswitch_device *rdev = netdev_priv(ndev);
 	struct rswitch_ext_ts_desc *desc;
@@ -419,7 +419,7 @@ static int rswitch_gwca_queue_ts_fill(struct net_device *ndev,
 
 	for (i = 0; i < num; i++) {
 		index = (i + start_index) % gq->ring_size;
-		desc = &gq->ts_ring[index];
+		desc = &gq->rx_ring[index];
 		if (!gq->dir_tx) {
 			dma_addr = dma_map_single(ndev->dev.parent,
 						  gq->skbs[index]->data, PKT_BUF_SZ,
@@ -443,7 +443,7 @@ static int rswitch_gwca_queue_ts_fill(struct net_device *ndev,
 	if (!gq->dir_tx) {
 		for (i--; i >= 0; i--) {
 			index = (i + start_index) % gq->ring_size;
-			desc = &gq->ts_ring[index];
+			desc = &gq->rx_ring[index];
 			dma_addr = rswitch_desc_get_dptr(&desc->desc);
 			dma_unmap_single(ndev->dev.parent, dma_addr, PKT_BUF_SZ,
 					 DMA_FROM_DEVICE);
@@ -453,21 +453,21 @@ static int rswitch_gwca_queue_ts_fill(struct net_device *ndev,
 	return -ENOMEM;
 }
 
-static int rswitch_gwca_queue_ts_format(struct net_device *ndev,
-					struct rswitch_private *priv,
-					struct rswitch_gwca_queue *gq)
+static int rswitch_gwca_queue_ext_ts_format(struct net_device *ndev,
+					    struct rswitch_private *priv,
+					    struct rswitch_gwca_queue *gq)
 {
-	int tx_ts_ring_size = sizeof(struct rswitch_ext_ts_desc) * gq->ring_size;
+	int ring_size = sizeof(struct rswitch_ext_ts_desc) * gq->ring_size;
 	struct rswitch_ext_ts_desc *desc;
 	struct rswitch_desc *linkfix;
 	int err;
 
-	memset(gq->ts_ring, 0, tx_ts_ring_size);
-	err = rswitch_gwca_queue_ts_fill(ndev, gq, 0, gq->ring_size);
+	memset(gq->rx_ring, 0, ring_size);
+	err = rswitch_gwca_queue_ext_ts_fill(ndev, gq, 0, gq->ring_size);
 	if (err < 0)
 		return err;
 
-	desc = &gq->ts_ring[gq->ring_size];	/* Last */
+	desc = &gq->rx_ring[gq->ring_size];	/* Last */
 	rswitch_desc_set_dptr(&desc->desc, gq->ring_dma);
 	desc->desc.die_dt = DT_LINKFIX;
 
@@ -595,7 +595,7 @@ static int rswitch_rxdmac_init(struct rswitch_private *priv, int index)
 	struct rswitch_device *rdev = priv->rdev[index];
 	struct net_device *ndev = rdev->ndev;
 
-	return rswitch_gwca_queue_ts_format(ndev, priv, rdev->rx_queue);
+	return rswitch_gwca_queue_ext_ts_format(ndev, priv, rdev->rx_queue);
 }
 
 static int rswitch_gwca_hw_init(struct rswitch_private *priv)
@@ -676,7 +676,7 @@ static bool rswitch_rx(struct net_device *ndev, int *quota)
 	boguscnt = min_t(int, gq->ring_size, *quota);
 	limit = boguscnt;
 
-	desc = &gq->ts_ring[gq->cur];
+	desc = &gq->rx_ring[gq->cur];
 	while ((desc->desc.die_dt & DT_MASK) != DT_FEMPTY) {
 		if (--boguscnt < 0)
 			break;
@@ -704,14 +704,14 @@ static bool rswitch_rx(struct net_device *ndev, int *quota)
 		rdev->ndev->stats.rx_bytes += pkt_len;
 
 		gq->cur = rswitch_next_queue_index(gq, true, 1);
-		desc = &gq->ts_ring[gq->cur];
+		desc = &gq->rx_ring[gq->cur];
 	}
 
 	num = rswitch_get_num_cur_queues(gq);
 	ret = rswitch_gwca_queue_alloc_skb(gq, gq->dirty, num);
 	if (ret < 0)
 		goto err;
-	ret = rswitch_gwca_queue_ts_fill(ndev, gq, gq->dirty, num);
+	ret = rswitch_gwca_queue_ext_ts_fill(ndev, gq, gq->dirty, num);
 	if (ret < 0)
 		goto err;
 	gq->dirty = rswitch_next_queue_index(gq, false, num);
@@ -738,7 +738,7 @@ static int rswitch_tx_free(struct net_device *ndev, bool free_txed_only)
 
 	for (; rswitch_get_num_cur_queues(gq) > 0;
 	     gq->dirty = rswitch_next_queue_index(gq, false, 1)) {
-		desc = &gq->ring[gq->dirty];
+		desc = &gq->tx_ring[gq->dirty];
 		if (free_txed_only && (desc->desc.die_dt & DT_MASK) != DT_FEMPTY)
 			break;
 
@@ -1416,7 +1416,7 @@ static netdev_tx_t rswitch_start_xmit(struct sk_buff *skb, struct net_device *nd
 	}
 
 	gq->skbs[gq->cur] = skb;
-	desc = &gq->ring[gq->cur];
+	desc = &gq->tx_ring[gq->cur];
 	rswitch_desc_set_dptr(&desc->desc, dma_addr);
 	desc->desc.info_ds = cpu_to_le16(skb->len);
 
diff --git a/drivers/net/ethernet/renesas/rswitch.h b/drivers/net/ethernet/renesas/rswitch.h
index 49efb0f31c77a..0584670abead5 100644
--- a/drivers/net/ethernet/renesas/rswitch.h
+++ b/drivers/net/ethernet/renesas/rswitch.h
@@ -915,8 +915,8 @@ struct rswitch_gwca_queue {
 	bool dir_tx;
 	bool gptp;
 	union {
-		struct rswitch_ext_desc *ring;
-		struct rswitch_ext_ts_desc *ts_ring;
+		struct rswitch_ext_desc *tx_ring;
+		struct rswitch_ext_ts_desc *rx_ring;
 	};
 	dma_addr_t ring_dma;
 	int ring_size;
-- 
2.39.2



