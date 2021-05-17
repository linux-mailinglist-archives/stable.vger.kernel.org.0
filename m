Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3D33833F4
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242595AbhEQPD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:58728 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242182AbhEQPB4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:01:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8BDF9619B6;
        Mon, 17 May 2021 14:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261643;
        bh=NQg1tnb0xH5GCh6HF4sd5fqBx19laQgqfNw4hIxzJEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aLk7hWM6eNrkD2a/uT2eYMXfJCbkWL4QJ0SZmRavZc8spMJYpoQF+fNaTE8Jfjn6+
         wRCZWJDs2YrzG+5FAwPsU0p6Md7qfOVteyAyaqPy85ib1CXjZLcq2hSlpNMnTASwyn
         tDZ6z1NQ509QA2SxdyFm0TSt0UVUMUqZOKlzAdbI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kaike Wan <kaike.wan@intel.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/289] IB/hfi1: Correct oversized ring allocation
Date:   Mon, 17 May 2021 15:59:29 +0200
Message-Id: <20210517140306.679629898@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>

[ Upstream commit b536d4b2a279733f440c911dc831764690b90050 ]

The completion ring for tx is using the wrong size to size the ring,
oversizing the ring by two orders of magniture.

Correct the allocation size and use kcalloc_node() to allocate the ring.
Fix mistaken GFP defines in similar allocations.

Link: https://lore.kernel.org/r/1617026056-50483-4-git-send-email-dennis.dalessandro@cornelisnetworks.com
Reviewed-by: Kaike Wan <kaike.wan@intel.com>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/ipoib.h    |  3 ++-
 drivers/infiniband/hw/hfi1/ipoib_tx.c | 14 +++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/ipoib.h b/drivers/infiniband/hw/hfi1/ipoib.h
index b8c9d0a003fb..1ee361c6d11a 100644
--- a/drivers/infiniband/hw/hfi1/ipoib.h
+++ b/drivers/infiniband/hw/hfi1/ipoib.h
@@ -52,8 +52,9 @@ union hfi1_ipoib_flow {
  * @producer_lock: producer sync lock
  * @consumer_lock: consumer sync lock
  */
+struct ipoib_txreq;
 struct hfi1_ipoib_circ_buf {
-	void **items;
+	struct ipoib_txreq **items;
 	unsigned long head;
 	unsigned long tail;
 	unsigned long max_items;
diff --git a/drivers/infiniband/hw/hfi1/ipoib_tx.c b/drivers/infiniband/hw/hfi1/ipoib_tx.c
index 9df292b51a05..ab1eefffc14b 100644
--- a/drivers/infiniband/hw/hfi1/ipoib_tx.c
+++ b/drivers/infiniband/hw/hfi1/ipoib_tx.c
@@ -702,14 +702,14 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
 
 	priv->tx_napis = kcalloc_node(dev->num_tx_queues,
 				      sizeof(struct napi_struct),
-				      GFP_ATOMIC,
+				      GFP_KERNEL,
 				      priv->dd->node);
 	if (!priv->tx_napis)
 		goto free_txreq_cache;
 
 	priv->txqs = kcalloc_node(dev->num_tx_queues,
 				  sizeof(struct hfi1_ipoib_txq),
-				  GFP_ATOMIC,
+				  GFP_KERNEL,
 				  priv->dd->node);
 	if (!priv->txqs)
 		goto free_tx_napis;
@@ -741,9 +741,9 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
 					     priv->dd->node);
 
 		txq->tx_ring.items =
-			vzalloc_node(array_size(tx_ring_size,
-						sizeof(struct ipoib_txreq)),
-				     priv->dd->node);
+			kcalloc_node(tx_ring_size,
+				     sizeof(struct ipoib_txreq *),
+				     GFP_KERNEL, priv->dd->node);
 		if (!txq->tx_ring.items)
 			goto free_txqs;
 
@@ -764,7 +764,7 @@ free_txqs:
 		struct hfi1_ipoib_txq *txq = &priv->txqs[i];
 
 		netif_napi_del(txq->napi);
-		vfree(txq->tx_ring.items);
+		kfree(txq->tx_ring.items);
 	}
 
 	kfree(priv->txqs);
@@ -817,7 +817,7 @@ void hfi1_ipoib_txreq_deinit(struct hfi1_ipoib_dev_priv *priv)
 		hfi1_ipoib_drain_tx_list(txq);
 		netif_napi_del(txq->napi);
 		(void)hfi1_ipoib_drain_tx_ring(txq, txq->tx_ring.max_items);
-		vfree(txq->tx_ring.items);
+		kfree(txq->tx_ring.items);
 	}
 
 	kfree(priv->txqs);
-- 
2.30.2



