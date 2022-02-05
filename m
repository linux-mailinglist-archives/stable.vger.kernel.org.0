Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD6E74AA90A
	for <lists+stable@lfdr.de>; Sat,  5 Feb 2022 14:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233802AbiBENLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 08:11:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56836 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbiBENLM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 08:11:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C1D4B80925
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 13:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42444C340E8;
        Sat,  5 Feb 2022 13:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644066669;
        bh=MKsioazBT3uwPa9swLTI6W+MIVYTgrXU/EYFm7gS7dE=;
        h=Subject:To:Cc:From:Date:From;
        b=qOMBopdTaoXmSYayEjI+VnmMC7jRFcpI4bV+uldZvNxq564jjBe9oK95g+Zc0gN/G
         nWIcQZ07ukqgmubYWx24S/ehS7RyF35HmCmTIZ8FEe2KSQoGNYIvYlKw8eRwC8UAd0
         fWL7IaQspe5+6kqKVgPINVsdLXjJwOhZ+cpbuCMQ=
Subject: FAILED: patch "[PATCH] IB/hfi1: Fix alloc failure with larger txqueuelen" failed to apply to 5.10-stable tree
To:     mike.marciniszyn@cornelisnetworks.com,
        dennis.dalessandro@cornelisnetworks.com, jgg@nvidia.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 05 Feb 2022 14:11:07 +0100
Message-ID: <16440666672524@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From b1151b74ff68cc83c2a8e1a618efe7d056e4f237 Mon Sep 17 00:00:00 2001
From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Date: Sat, 15 Jan 2022 18:02:34 -0500
Subject: [PATCH] IB/hfi1: Fix alloc failure with larger txqueuelen

The following allocation with large txqueuelen will result in the
following warning:

  Call Trace:
   __alloc_pages_nodemask+0x283/0x2c0
   kmalloc_large_node+0x3c/0xa0
   __kmalloc_node+0x22a/0x2f0
   hfi1_ipoib_txreq_init+0x19f/0x330 [hfi1]
   hfi1_ipoib_setup_rn+0xd3/0x1a0 [hfi1]
   rdma_init_netdev+0x5a/0x80 [ib_core]
   ipoib_intf_init+0x6c/0x350 [ib_ipoib]
   ipoib_intf_alloc+0x5c/0xc0 [ib_ipoib]
   ipoib_add_one+0xbe/0x300 [ib_ipoib]
   add_client_context+0x12c/0x1a0 [ib_core]
   ib_register_client+0x147/0x190 [ib_core]
   ipoib_init_module+0xdd/0x132 [ib_ipoib]
   do_one_initcall+0x46/0x1c3
   do_init_module+0x5a/0x220
   load_module+0x14c5/0x17f0
   __do_sys_init_module+0x13b/0x180
   do_syscall_64+0x5b/0x1a0
   entry_SYSCALL_64_after_hwframe+0x65/0xca

For ipoib, the txqueuelen is modified with the module parameter
send_queue_size.

Fix by changing to use kv versions of the same allocator to handle the
large allocations.  The allocation embeds a hdr struct that is dma mapped.
Change that struct to a pointer to a kzalloced struct.

Cc: stable@vger.kernel.org
Fixes: d99dc602e2a5 ("IB/hfi1: Add functions to transmit datagram ipoib packets")
Link: https://lore.kernel.org/r/1642287756-182313-3-git-send-email-mike.marciniszyn@cornelisnetworks.com
Reviewed-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

diff --git a/drivers/infiniband/hw/hfi1/ipoib.h b/drivers/infiniband/hw/hfi1/ipoib.h
index 909122934246..aec60d4888eb 100644
--- a/drivers/infiniband/hw/hfi1/ipoib.h
+++ b/drivers/infiniband/hw/hfi1/ipoib.h
@@ -55,7 +55,7 @@ union hfi1_ipoib_flow {
  */
 struct ipoib_txreq {
 	struct sdma_txreq           txreq;
-	struct hfi1_sdma_header     sdma_hdr;
+	struct hfi1_sdma_header     *sdma_hdr;
 	int                         sdma_status;
 	int                         complete;
 	struct hfi1_ipoib_dev_priv *priv;
diff --git a/drivers/infiniband/hw/hfi1/ipoib_tx.c b/drivers/infiniband/hw/hfi1/ipoib_tx.c
index bf62956c8667..d6bbdb8fcb50 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_tx.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_tx.c
@@ -122,7 +122,7 @@ static void hfi1_ipoib_free_tx(struct ipoib_txreq *tx, int budget)
 		dd_dev_warn(priv->dd,
 			    "%s: Status = 0x%x pbc 0x%llx txq = %d sde = %d\n",
 			    __func__, tx->sdma_status,
-			    le64_to_cpu(tx->sdma_hdr.pbc), tx->txq->q_idx,
+			    le64_to_cpu(tx->sdma_hdr->pbc), tx->txq->q_idx,
 			    tx->txq->sde->this_idx);
 	}
 
@@ -231,7 +231,7 @@ static int hfi1_ipoib_build_tx_desc(struct ipoib_txreq *tx,
 {
 	struct hfi1_devdata *dd = txp->dd;
 	struct sdma_txreq *txreq = &tx->txreq;
-	struct hfi1_sdma_header *sdma_hdr = &tx->sdma_hdr;
+	struct hfi1_sdma_header *sdma_hdr = tx->sdma_hdr;
 	u16 pkt_bytes =
 		sizeof(sdma_hdr->pbc) + (txp->hdr_dwords << 2) + tx->skb->len;
 	int ret;
@@ -256,7 +256,7 @@ static void hfi1_ipoib_build_ib_tx_headers(struct ipoib_txreq *tx,
 					   struct ipoib_txparms *txp)
 {
 	struct hfi1_ipoib_dev_priv *priv = tx->txq->priv;
-	struct hfi1_sdma_header *sdma_hdr = &tx->sdma_hdr;
+	struct hfi1_sdma_header *sdma_hdr = tx->sdma_hdr;
 	struct sk_buff *skb = tx->skb;
 	struct hfi1_pportdata *ppd = ppd_from_ibp(txp->ibp);
 	struct rdma_ah_attr *ah_attr = txp->ah_attr;
@@ -483,7 +483,7 @@ static int hfi1_ipoib_send_dma_single(struct net_device *dev,
 	if (likely(!ret)) {
 tx_ok:
 		trace_sdma_output_ibhdr(txq->priv->dd,
-					&tx->sdma_hdr.hdr,
+					&tx->sdma_hdr->hdr,
 					ib_is_sc5(txp->flow.sc5));
 		hfi1_ipoib_check_queue_depth(txq);
 		return NETDEV_TX_OK;
@@ -547,7 +547,7 @@ static int hfi1_ipoib_send_dma_list(struct net_device *dev,
 	hfi1_ipoib_check_queue_depth(txq);
 
 	trace_sdma_output_ibhdr(txq->priv->dd,
-				&tx->sdma_hdr.hdr,
+				&tx->sdma_hdr->hdr,
 				ib_is_sc5(txp->flow.sc5));
 
 	if (!netdev_xmit_more())
@@ -683,7 +683,8 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
 {
 	struct net_device *dev = priv->netdev;
 	u32 tx_ring_size, tx_item_size;
-	int i;
+	struct hfi1_ipoib_circ_buf *tx_ring;
+	int i, j;
 
 	/*
 	 * Ring holds 1 less than tx_ring_size
@@ -701,7 +702,9 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
 
 	for (i = 0; i < dev->num_tx_queues; i++) {
 		struct hfi1_ipoib_txq *txq = &priv->txqs[i];
+		struct ipoib_txreq *tx;
 
+		tx_ring = &txq->tx_ring;
 		iowait_init(&txq->wait,
 			    0,
 			    hfi1_ipoib_flush_txq,
@@ -725,14 +728,19 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
 					     priv->dd->node);
 
 		txq->tx_ring.items =
-			kcalloc_node(tx_ring_size, tx_item_size,
-				     GFP_KERNEL, priv->dd->node);
+			kvzalloc_node(array_size(tx_ring_size, tx_item_size),
+				      GFP_KERNEL, priv->dd->node);
 		if (!txq->tx_ring.items)
 			goto free_txqs;
 
 		txq->tx_ring.max_items = tx_ring_size;
 		txq->tx_ring.shift = ilog2(tx_item_size);
 		txq->tx_ring.avail = hfi1_ipoib_ring_hwat(txq);
+		tx_ring = &txq->tx_ring;
+		for (j = 0; j < tx_ring_size; j++)
+			hfi1_txreq_from_idx(tx_ring, j)->sdma_hdr =
+				kzalloc_node(sizeof(*tx->sdma_hdr),
+					     GFP_KERNEL, priv->dd->node);
 
 		netif_tx_napi_add(dev, &txq->napi,
 				  hfi1_ipoib_poll_tx_ring,
@@ -746,7 +754,10 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
 		struct hfi1_ipoib_txq *txq = &priv->txqs[i];
 
 		netif_napi_del(&txq->napi);
-		kfree(txq->tx_ring.items);
+		tx_ring = &txq->tx_ring;
+		for (j = 0; j < tx_ring_size; j++)
+			kfree(hfi1_txreq_from_idx(tx_ring, j)->sdma_hdr);
+		kvfree(tx_ring->items);
 	}
 
 	kfree(priv->txqs);
@@ -780,17 +791,20 @@ static void hfi1_ipoib_drain_tx_list(struct hfi1_ipoib_txq *txq)
 
 void hfi1_ipoib_txreq_deinit(struct hfi1_ipoib_dev_priv *priv)
 {
-	int i;
+	int i, j;
 
 	for (i = 0; i < priv->netdev->num_tx_queues; i++) {
 		struct hfi1_ipoib_txq *txq = &priv->txqs[i];
+		struct hfi1_ipoib_circ_buf *tx_ring = &txq->tx_ring;
 
 		iowait_cancel_work(&txq->wait);
 		iowait_sdma_drain(&txq->wait);
 		hfi1_ipoib_drain_tx_list(txq);
 		netif_napi_del(&txq->napi);
 		hfi1_ipoib_drain_tx_ring(txq);
-		kfree(txq->tx_ring.items);
+		for (j = 0; j < tx_ring->max_items; j++)
+			kfree(hfi1_txreq_from_idx(tx_ring, j)->sdma_hdr);
+		kvfree(tx_ring->items);
 	}
 
 	kfree(priv->txqs);

