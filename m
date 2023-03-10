Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE37B6B43C6
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbjCJORp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:17:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbjCJOR0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:17:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1834A1188FE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:16:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 899576182F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7983BC433EF;
        Fri, 10 Mar 2023 14:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457781;
        bh=NAYyOp9l31fNignv4+NUzaW1Dga8JnHxLw2Hy6z10rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOoGXj7EXywgmalIPACfbOalHqn68gTGblr6oPbh3t9GzObWHxY65ZrLILJaw7waV
         g7QB3+Wr5z8whh8r4apoK+ybFf5hKX6Ix51H1thIrAM2MeVbeRR9Xq9Lc8kehL26HS
         jAkGH5QBY4n7k/oigtPAJ5/h4ju41ejIuzz7kgL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 025/252] ipw2x00: switch from pci_ to dma_ API
Date:   Fri, 10 Mar 2023 14:36:35 +0100
Message-Id: <20230310133719.582132597@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e52525c0c320076deab35409a6b2cff6388959b8 ]

The wrappers in include/linux/pci-dma-compat.h should go away.

The patch has been generated with the coccinelle script below and has been
hand modified to replace GFP_ with a correct flag.
It has been compile tested.

When memory is allocated in 'ipw2100_msg_allocate()' (ipw2100.c),
GFP_KERNEL can be used because it is called from the probe function.
The call chain is:
   ipw2100_pci_init_one            (the probe function)
     --> ipw2100_queues_allocate
       --> ipw2100_msg_allocate
Moreover, 'ipw2100_msg_allocate()' already uses GFP_KERNEL for some other
memory allocations.

When memory is allocated in 'status_queue_allocate()' (ipw2100.c),
GFP_KERNEL can be used because it is called from the probe function.
The call chain is:
   ipw2100_pci_init_one            (the probe function)
     --> ipw2100_queues_allocate
       --> ipw2100_rx_allocate
         --> status_queue_allocate
Moreover, 'ipw2100_rx_allocate()' already uses GFP_KERNEL for some other
memory allocations.

When memory is allocated in 'bd_queue_allocate()' (ipw2100.c),
GFP_KERNEL can be used because it is called from the probe function.
The call chain is:
   ipw2100_pci_init_one            (the probe function)
     --> ipw2100_queues_allocate
       --> ipw2100_rx_allocate
         --> bd_queue_allocate
Moreover, 'ipw2100_rx_allocate()' already uses GFP_KERNEL for some other
memory allocations.

When memory is allocated in 'ipw2100_tx_allocate()' (ipw2100.c),
GFP_KERNEL can be used because it is called from the probe function.
The call chain is:
   ipw2100_pci_init_one            (the probe function)
     --> ipw2100_queues_allocate
       --> ipw2100_tx_allocate
Moreover, 'ipw2100_tx_allocate()' already uses GFP_KERNEL for some other
memory allocations.

When memory is allocated in 'ipw_queue_tx_init()' (ipw2200.c),
GFP_KERNEL can be used because it is called from a call chain that already
uses GFP_KERNEL and no spin_lock is taken in the between.
The call chain is:
   ipw_up
     --> ipw_load
       --> ipw_queue_reset
         --> ipw_queue_tx_init
'ipw_up()' already uses GFP_KERNEL for some other memory allocations.

@@
@@
-    PCI_DMA_BIDIRECTIONAL
+    DMA_BIDIRECTIONAL

@@
@@
-    PCI_DMA_TODEVICE
+    DMA_TO_DEVICE

@@
@@
-    PCI_DMA_FROMDEVICE
+    DMA_FROM_DEVICE

@@
@@
-    PCI_DMA_NONE
+    DMA_NONE

@@
expression e1, e2, e3;
@@
-    pci_alloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3;
@@
-    pci_zalloc_consistent(e1, e2, e3)
+    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)

@@
expression e1, e2, e3, e4;
@@
-    pci_free_consistent(e1, e2, e3, e4)
+    dma_free_coherent(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_single(e1, e2, e3, e4)
+    dma_map_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_single(e1, e2, e3, e4)
+    dma_unmap_single(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4, e5;
@@
-    pci_map_page(e1, e2, e3, e4, e5)
+    dma_map_page(&e1->dev, e2, e3, e4, e5)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_page(e1, e2, e3, e4)
+    dma_unmap_page(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_map_sg(e1, e2, e3, e4)
+    dma_map_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_unmap_sg(e1, e2, e3, e4)
+    dma_unmap_sg(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
+    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_single_for_device(e1, e2, e3, e4)
+    dma_sync_single_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
+    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)

@@
expression e1, e2, e3, e4;
@@
-    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
+    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)

@@
expression e1, e2;
@@
-    pci_dma_mapping_error(e1, e2)
+    dma_mapping_error(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_dma_mask(e1, e2)
+    dma_set_mask(&e1->dev, e2)

@@
expression e1, e2;
@@
-    pci_set_consistent_dma_mask(e1, e2)
+    dma_set_coherent_mask(&e1->dev, e2)

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200722101716.26185-1-christophe.jaillet@wanadoo.fr
Stable-dep-of: 45fc6d7461f1 ("wifi: ipw2x00: don't call dev_kfree_skb() under spin_lock_irqsave()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c | 121 +++++++++----------
 drivers/net/wireless/intel/ipw2x00/ipw2200.c |  56 ++++-----
 2 files changed, 88 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index a3a470976a5c7..68c4ce352b006 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -2308,10 +2308,11 @@ static int ipw2100_alloc_skb(struct ipw2100_priv *priv,
 		return -ENOMEM;
 
 	packet->rxp = (struct ipw2100_rx *)packet->skb->data;
-	packet->dma_addr = pci_map_single(priv->pci_dev, packet->skb->data,
+	packet->dma_addr = dma_map_single(&priv->pci_dev->dev,
+					  packet->skb->data,
 					  sizeof(struct ipw2100_rx),
-					  PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(priv->pci_dev, packet->dma_addr)) {
+					  DMA_FROM_DEVICE);
+	if (dma_mapping_error(&priv->pci_dev->dev, packet->dma_addr)) {
 		dev_kfree_skb(packet->skb);
 		return -ENOMEM;
 	}
@@ -2492,9 +2493,8 @@ static void isr_rx(struct ipw2100_priv *priv, int i,
 		return;
 	}
 
-	pci_unmap_single(priv->pci_dev,
-			 packet->dma_addr,
-			 sizeof(struct ipw2100_rx), PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&priv->pci_dev->dev, packet->dma_addr,
+			 sizeof(struct ipw2100_rx), DMA_FROM_DEVICE);
 
 	skb_put(packet->skb, status->frame_size);
 
@@ -2576,8 +2576,8 @@ static void isr_rx_monitor(struct ipw2100_priv *priv, int i,
 		return;
 	}
 
-	pci_unmap_single(priv->pci_dev, packet->dma_addr,
-			 sizeof(struct ipw2100_rx), PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&priv->pci_dev->dev, packet->dma_addr,
+			 sizeof(struct ipw2100_rx), DMA_FROM_DEVICE);
 	memmove(packet->skb->data + sizeof(struct ipw_rt_hdr),
 		packet->skb->data, status->frame_size);
 
@@ -2702,9 +2702,9 @@ static void __ipw2100_rx_process(struct ipw2100_priv *priv)
 
 		/* Sync the DMA for the RX buffer so CPU is sure to get
 		 * the correct values */
-		pci_dma_sync_single_for_cpu(priv->pci_dev, packet->dma_addr,
-					    sizeof(struct ipw2100_rx),
-					    PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&priv->pci_dev->dev, packet->dma_addr,
+					sizeof(struct ipw2100_rx),
+					DMA_FROM_DEVICE);
 
 		if (unlikely(ipw2100_corruption_check(priv, i))) {
 			ipw2100_corruption_detected(priv, i);
@@ -2936,9 +2936,8 @@ static int __ipw2100_tx_process(struct ipw2100_priv *priv)
 				     (packet->index + 1 + i) % txq->entries,
 				     tbd->host_addr, tbd->buf_length);
 
-			pci_unmap_single(priv->pci_dev,
-					 tbd->host_addr,
-					 tbd->buf_length, PCI_DMA_TODEVICE);
+			dma_unmap_single(&priv->pci_dev->dev, tbd->host_addr,
+					 tbd->buf_length, DMA_TO_DEVICE);
 		}
 
 		libipw_txb_free(packet->info.d_struct.txb);
@@ -3178,15 +3177,13 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
 			tbd->buf_length = packet->info.d_struct.txb->
 			    fragments[i]->len - LIBIPW_3ADDR_LEN;
 
-			tbd->host_addr = pci_map_single(priv->pci_dev,
+			tbd->host_addr = dma_map_single(&priv->pci_dev->dev,
 							packet->info.d_struct.
-							txb->fragments[i]->
-							data +
+							txb->fragments[i]->data +
 							LIBIPW_3ADDR_LEN,
 							tbd->buf_length,
-							PCI_DMA_TODEVICE);
-			if (pci_dma_mapping_error(priv->pci_dev,
-						  tbd->host_addr)) {
+							DMA_TO_DEVICE);
+			if (dma_mapping_error(&priv->pci_dev->dev, tbd->host_addr)) {
 				IPW_DEBUG_TX("dma mapping error\n");
 				break;
 			}
@@ -3195,10 +3192,10 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
 				     txq->next, tbd->host_addr,
 				     tbd->buf_length);
 
-			pci_dma_sync_single_for_device(priv->pci_dev,
-						       tbd->host_addr,
-						       tbd->buf_length,
-						       PCI_DMA_TODEVICE);
+			dma_sync_single_for_device(&priv->pci_dev->dev,
+						   tbd->host_addr,
+						   tbd->buf_length,
+						   DMA_TO_DEVICE);
 
 			txq->next++;
 			txq->next %= txq->entries;
@@ -3453,9 +3450,9 @@ static int ipw2100_msg_allocate(struct ipw2100_priv *priv)
 		return -ENOMEM;
 
 	for (i = 0; i < IPW_COMMAND_POOL_SIZE; i++) {
-		v = pci_zalloc_consistent(priv->pci_dev,
-					  sizeof(struct ipw2100_cmd_header),
-					  &p);
+		v = dma_alloc_coherent(&priv->pci_dev->dev,
+				       sizeof(struct ipw2100_cmd_header), &p,
+				       GFP_KERNEL);
 		if (!v) {
 			printk(KERN_ERR DRV_NAME ": "
 			       "%s: PCI alloc failed for msg "
@@ -3474,11 +3471,10 @@ static int ipw2100_msg_allocate(struct ipw2100_priv *priv)
 		return 0;
 
 	for (j = 0; j < i; j++) {
-		pci_free_consistent(priv->pci_dev,
-				    sizeof(struct ipw2100_cmd_header),
-				    priv->msg_buffers[j].info.c_struct.cmd,
-				    priv->msg_buffers[j].info.c_struct.
-				    cmd_phys);
+		dma_free_coherent(&priv->pci_dev->dev,
+				  sizeof(struct ipw2100_cmd_header),
+				  priv->msg_buffers[j].info.c_struct.cmd,
+				  priv->msg_buffers[j].info.c_struct.cmd_phys);
 	}
 
 	kfree(priv->msg_buffers);
@@ -3509,11 +3505,10 @@ static void ipw2100_msg_free(struct ipw2100_priv *priv)
 		return;
 
 	for (i = 0; i < IPW_COMMAND_POOL_SIZE; i++) {
-		pci_free_consistent(priv->pci_dev,
-				    sizeof(struct ipw2100_cmd_header),
-				    priv->msg_buffers[i].info.c_struct.cmd,
-				    priv->msg_buffers[i].info.c_struct.
-				    cmd_phys);
+		dma_free_coherent(&priv->pci_dev->dev,
+				  sizeof(struct ipw2100_cmd_header),
+				  priv->msg_buffers[i].info.c_struct.cmd,
+				  priv->msg_buffers[i].info.c_struct.cmd_phys);
 	}
 
 	kfree(priv->msg_buffers);
@@ -4336,7 +4331,8 @@ static int status_queue_allocate(struct ipw2100_priv *priv, int entries)
 	IPW_DEBUG_INFO("enter\n");
 
 	q->size = entries * sizeof(struct ipw2100_status);
-	q->drv = pci_zalloc_consistent(priv->pci_dev, q->size, &q->nic);
+	q->drv = dma_alloc_coherent(&priv->pci_dev->dev, q->size, &q->nic,
+				    GFP_KERNEL);
 	if (!q->drv) {
 		IPW_DEBUG_WARNING("Can not allocate status queue.\n");
 		return -ENOMEM;
@@ -4352,9 +4348,10 @@ static void status_queue_free(struct ipw2100_priv *priv)
 	IPW_DEBUG_INFO("enter\n");
 
 	if (priv->status_queue.drv) {
-		pci_free_consistent(priv->pci_dev, priv->status_queue.size,
-				    priv->status_queue.drv,
-				    priv->status_queue.nic);
+		dma_free_coherent(&priv->pci_dev->dev,
+				  priv->status_queue.size,
+				  priv->status_queue.drv,
+				  priv->status_queue.nic);
 		priv->status_queue.drv = NULL;
 	}
 
@@ -4370,7 +4367,8 @@ static int bd_queue_allocate(struct ipw2100_priv *priv,
 
 	q->entries = entries;
 	q->size = entries * sizeof(struct ipw2100_bd);
-	q->drv = pci_zalloc_consistent(priv->pci_dev, q->size, &q->nic);
+	q->drv = dma_alloc_coherent(&priv->pci_dev->dev, q->size, &q->nic,
+				    GFP_KERNEL);
 	if (!q->drv) {
 		IPW_DEBUG_INFO
 		    ("can't allocate shared memory for buffer descriptors\n");
@@ -4390,7 +4388,8 @@ static void bd_queue_free(struct ipw2100_priv *priv, struct ipw2100_bd_queue *q)
 		return;
 
 	if (q->drv) {
-		pci_free_consistent(priv->pci_dev, q->size, q->drv, q->nic);
+		dma_free_coherent(&priv->pci_dev->dev, q->size, q->drv,
+				  q->nic);
 		q->drv = NULL;
 	}
 
@@ -4450,9 +4449,9 @@ static int ipw2100_tx_allocate(struct ipw2100_priv *priv)
 	}
 
 	for (i = 0; i < TX_PENDED_QUEUE_LENGTH; i++) {
-		v = pci_alloc_consistent(priv->pci_dev,
-					 sizeof(struct ipw2100_data_header),
-					 &p);
+		v = dma_alloc_coherent(&priv->pci_dev->dev,
+				       sizeof(struct ipw2100_data_header), &p,
+				       GFP_KERNEL);
 		if (!v) {
 			printk(KERN_ERR DRV_NAME
 			       ": %s: PCI alloc failed for tx " "buffers.\n",
@@ -4472,11 +4471,10 @@ static int ipw2100_tx_allocate(struct ipw2100_priv *priv)
 		return 0;
 
 	for (j = 0; j < i; j++) {
-		pci_free_consistent(priv->pci_dev,
-				    sizeof(struct ipw2100_data_header),
-				    priv->tx_buffers[j].info.d_struct.data,
-				    priv->tx_buffers[j].info.d_struct.
-				    data_phys);
+		dma_free_coherent(&priv->pci_dev->dev,
+				  sizeof(struct ipw2100_data_header),
+				  priv->tx_buffers[j].info.d_struct.data,
+				  priv->tx_buffers[j].info.d_struct.data_phys);
 	}
 
 	kfree(priv->tx_buffers);
@@ -4553,12 +4551,10 @@ static void ipw2100_tx_free(struct ipw2100_priv *priv)
 			priv->tx_buffers[i].info.d_struct.txb = NULL;
 		}
 		if (priv->tx_buffers[i].info.d_struct.data)
-			pci_free_consistent(priv->pci_dev,
-					    sizeof(struct ipw2100_data_header),
-					    priv->tx_buffers[i].info.d_struct.
-					    data,
-					    priv->tx_buffers[i].info.d_struct.
-					    data_phys);
+			dma_free_coherent(&priv->pci_dev->dev,
+					  sizeof(struct ipw2100_data_header),
+					  priv->tx_buffers[i].info.d_struct.data,
+					  priv->tx_buffers[i].info.d_struct.data_phys);
 	}
 
 	kfree(priv->tx_buffers);
@@ -4621,9 +4617,10 @@ static int ipw2100_rx_allocate(struct ipw2100_priv *priv)
 		return 0;
 
 	for (j = 0; j < i; j++) {
-		pci_unmap_single(priv->pci_dev, priv->rx_buffers[j].dma_addr,
+		dma_unmap_single(&priv->pci_dev->dev,
+				 priv->rx_buffers[j].dma_addr,
 				 sizeof(struct ipw2100_rx_packet),
-				 PCI_DMA_FROMDEVICE);
+				 DMA_FROM_DEVICE);
 		dev_kfree_skb(priv->rx_buffers[j].skb);
 	}
 
@@ -4675,10 +4672,10 @@ static void ipw2100_rx_free(struct ipw2100_priv *priv)
 
 	for (i = 0; i < RX_QUEUE_LENGTH; i++) {
 		if (priv->rx_buffers[i].rxp) {
-			pci_unmap_single(priv->pci_dev,
+			dma_unmap_single(&priv->pci_dev->dev,
 					 priv->rx_buffers[i].dma_addr,
 					 sizeof(struct ipw2100_rx),
-					 PCI_DMA_FROMDEVICE);
+					 DMA_FROM_DEVICE);
 			dev_kfree_skb(priv->rx_buffers[i].skb);
 		}
 	}
@@ -6214,7 +6211,7 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 	pci_set_master(pci_dev);
 	pci_set_drvdata(pci_dev, priv);
 
-	err = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
+	err = dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(32));
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_set_dma_mask.\n");
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 04aee2fdba375..33deaa5cb4e88 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -3456,8 +3456,9 @@ static void ipw_rx_queue_reset(struct ipw_priv *priv,
 		/* In the reset function, these buffers may have been allocated
 		 * to an SKB, so we need to unmap and free potential storage */
 		if (rxq->pool[i].skb != NULL) {
-			pci_unmap_single(priv->pci_dev, rxq->pool[i].dma_addr,
-					 IPW_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&priv->pci_dev->dev,
+					 rxq->pool[i].dma_addr,
+					 IPW_RX_BUF_SIZE, DMA_FROM_DEVICE);
 			dev_kfree_skb(rxq->pool[i].skb);
 			rxq->pool[i].skb = NULL;
 		}
@@ -3790,7 +3791,8 @@ static int ipw_queue_tx_init(struct ipw_priv *priv,
 	}
 
 	q->bd =
-	    pci_alloc_consistent(dev, sizeof(q->bd[0]) * count, &q->q.dma_addr);
+	    dma_alloc_coherent(&dev->dev, sizeof(q->bd[0]) * count,
+			       &q->q.dma_addr, GFP_KERNEL);
 	if (!q->bd) {
 		IPW_ERROR("pci_alloc_consistent(%zd) failed\n",
 			  sizeof(q->bd[0]) * count);
@@ -3832,9 +3834,10 @@ static void ipw_queue_tx_free_tfd(struct ipw_priv *priv,
 
 	/* unmap chunks if any */
 	for (i = 0; i < le32_to_cpu(bd->u.data.num_chunks); i++) {
-		pci_unmap_single(dev, le32_to_cpu(bd->u.data.chunk_ptr[i]),
+		dma_unmap_single(&dev->dev,
+				 le32_to_cpu(bd->u.data.chunk_ptr[i]),
 				 le16_to_cpu(bd->u.data.chunk_len[i]),
-				 PCI_DMA_TODEVICE);
+				 DMA_TO_DEVICE);
 		if (txq->txb[txq->q.last_used]) {
 			libipw_txb_free(txq->txb[txq->q.last_used]);
 			txq->txb[txq->q.last_used] = NULL;
@@ -3866,8 +3869,8 @@ static void ipw_queue_tx_free(struct ipw_priv *priv, struct clx2_tx_queue *txq)
 	}
 
 	/* free buffers belonging to queue itself */
-	pci_free_consistent(dev, sizeof(txq->bd[0]) * q->n_bd, txq->bd,
-			    q->dma_addr);
+	dma_free_coherent(&dev->dev, sizeof(txq->bd[0]) * q->n_bd, txq->bd,
+			  q->dma_addr);
 	kfree(txq->txb);
 
 	/* 0 fill whole structure */
@@ -5212,8 +5215,8 @@ static void ipw_rx_queue_replenish(void *data)
 		list_del(element);
 
 		rxb->dma_addr =
-		    pci_map_single(priv->pci_dev, rxb->skb->data,
-				   IPW_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+		    dma_map_single(&priv->pci_dev->dev, rxb->skb->data,
+				   IPW_RX_BUF_SIZE, DMA_FROM_DEVICE);
 
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
@@ -5246,8 +5249,9 @@ static void ipw_rx_queue_free(struct ipw_priv *priv, struct ipw_rx_queue *rxq)
 
 	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
 		if (rxq->pool[i].skb != NULL) {
-			pci_unmap_single(priv->pci_dev, rxq->pool[i].dma_addr,
-					 IPW_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&priv->pci_dev->dev,
+					 rxq->pool[i].dma_addr,
+					 IPW_RX_BUF_SIZE, DMA_FROM_DEVICE);
 			dev_kfree_skb(rxq->pool[i].skb);
 		}
 	}
@@ -8285,9 +8289,8 @@ static void ipw_rx(struct ipw_priv *priv)
 		}
 		priv->rxq->queue[i] = NULL;
 
-		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->dma_addr,
-					    IPW_RX_BUF_SIZE,
-					    PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&priv->pci_dev->dev, rxb->dma_addr,
+					IPW_RX_BUF_SIZE, DMA_FROM_DEVICE);
 
 		pkt = (struct ipw_rx_packet *)rxb->skb->data;
 		IPW_DEBUG_RX("Packet: type=%02X seq=%02X bits=%02X\n",
@@ -8439,8 +8442,8 @@ static void ipw_rx(struct ipw_priv *priv)
 			rxb->skb = NULL;
 		}
 
-		pci_unmap_single(priv->pci_dev, rxb->dma_addr,
-				 IPW_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&priv->pci_dev->dev, rxb->dma_addr,
+				 IPW_RX_BUF_SIZE, DMA_FROM_DEVICE);
 		list_add_tail(&rxb->list, &priv->rxq->rx_used);
 
 		i = (i + 1) % RX_QUEUE_SIZE;
@@ -10239,11 +10242,10 @@ static int ipw_tx_skb(struct ipw_priv *priv, struct libipw_txb *txb,
 			   txb->fragments[i]->len - hdr_len);
 
 		tfd->u.data.chunk_ptr[i] =
-		    cpu_to_le32(pci_map_single
-				(priv->pci_dev,
-				 txb->fragments[i]->data + hdr_len,
-				 txb->fragments[i]->len - hdr_len,
-				 PCI_DMA_TODEVICE));
+		    cpu_to_le32(dma_map_single(&priv->pci_dev->dev,
+					       txb->fragments[i]->data + hdr_len,
+					       txb->fragments[i]->len - hdr_len,
+					       DMA_TO_DEVICE));
 		tfd->u.data.chunk_len[i] =
 		    cpu_to_le16(txb->fragments[i]->len - hdr_len);
 	}
@@ -10273,10 +10275,10 @@ static int ipw_tx_skb(struct ipw_priv *priv, struct libipw_txb *txb,
 			dev_kfree_skb_any(txb->fragments[i]);
 			txb->fragments[i] = skb;
 			tfd->u.data.chunk_ptr[i] =
-			    cpu_to_le32(pci_map_single
-					(priv->pci_dev, skb->data,
-					 remaining_bytes,
-					 PCI_DMA_TODEVICE));
+			    cpu_to_le32(dma_map_single(&priv->pci_dev->dev,
+						       skb->data,
+						       remaining_bytes,
+						       DMA_TO_DEVICE));
 
 			le32_add_cpu(&tfd->u.data.num_chunks, 1);
 		}
@@ -11649,9 +11651,9 @@ static int ipw_pci_probe(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (!err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (err) {
 		printk(KERN_WARNING DRV_NAME ": No suitable DMA available.\n");
 		goto out_pci_disable_device;
-- 
2.39.2



