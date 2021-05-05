Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2EAA3743F7
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236275AbhEEQxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234606AbhEEQu4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:50:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 210F761961;
        Wed,  5 May 2021 16:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232663;
        bh=B7C2uLl3oCAR7UoLAPkYETn4E+GUgmyrJG3uXjPqceU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TAkQqnokJUoSJb0CA4LzDoasjk+hrp9KPjFm9X/v9SmVFahFYiG0iyUTdaBq4fUNc
         0o8pThkAgamRgoEiIcVhK+YeQ8zN1vKCaoFvloiQuMxVdTJwvFzTfP2gDo6iLYskWu
         z6e7GM4d8S+ImgLr/nVIDZcNuqheM7skYBwXhDPB7V6n2U+NPKP2iikDSq44ZCKNsP
         J2TYMAodouHPpxp+MTf81oo0xCgziX3IuwLz9cqg6z8JGfCgPVJ7Z3s48JP6/tugyl
         ylVc45sYA6vVR3hdw4qSE38sgHjPcIV5dOLt0OLMM0pXrH+hZYz5wwe43pj3mAogbS
         X7tZpg1f0aEIw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Kaike Wan <kaike.wan@intel.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 37/85] IB/hfi1: Correct oversized ring allocation
Date:   Wed,  5 May 2021 12:36:00 -0400
Message-Id: <20210505163648.3462507-37-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 
@@ -764,7 +764,7 @@ int hfi1_ipoib_txreq_init(struct hfi1_ipoib_dev_priv *priv)
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

