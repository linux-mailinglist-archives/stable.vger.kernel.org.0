Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0E47F7DE7
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729391AbfKKSxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:53:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:47954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbfKKSxQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:53:16 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51990204EC;
        Mon, 11 Nov 2019 18:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498394;
        bh=75nxCkP4GlyGRbAdyu+S7SC5vvE0LOIIcJuAo5K9rww=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kne93LzYt6kfANG+zzckuycVkdVy7pYkbtBU5w/tA9Kg6YdsudTmLpPeUgMSvtsUS
         a6wJcoMeUuj3qQecko26AFXJ/cGwpJTRcpYRZG431L3rzk1U+eYQxjrYbLtPfIjENn
         d7rZYcVKLatNIxYLxSbIFpkBCCYsBC/IeMWIFytU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tariq Toukan <tariqt@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 105/193] net/mlx5e: kTLS, Release reference on DUMPed fragments in shutdown flow
Date:   Mon, 11 Nov 2019 19:28:07 +0100
Message-Id: <20191111181508.870963047@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>

[ Upstream commit 2c559361389b452ca23494080d0c65ab812706c1 ]

A call to kTLS completion handler was missing in the TXQSQ release
flow. Add it.

Fixes: d2ead1f360e8 ("net/mlx5e: Add kTLS TX HW offload support")
Signed-off-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/en_accel/ktls.h        |  7 ++++-
 .../mellanox/mlx5/core/en_accel/ktls_tx.c     | 11 ++++++--
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 28 ++++++++++---------
 3 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
index b7298f9ee3d3f..c4c128908b6e8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h
@@ -86,7 +86,7 @@ struct sk_buff *mlx5e_ktls_handle_tx_skb(struct net_device *netdev,
 					 struct mlx5e_tx_wqe **wqe, u16 *pi);
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
-					   struct mlx5e_sq_dma *dma);
+					   u32 *dma_fifo_cc);
 
 #else
 
@@ -94,6 +94,11 @@ static inline void mlx5e_ktls_build_netdev(struct mlx5e_priv *priv)
 {
 }
 
+static inline void
+mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
+				      struct mlx5e_tx_wqe_info *wi,
+				      u32 *dma_fifo_cc) {}
+
 #endif
 
 #endif /* __MLX5E_TLS_H__ */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
index 7833ddef04278..002245bb6b287 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c
@@ -304,9 +304,16 @@ tx_post_resync_dump(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
 void mlx5e_ktls_tx_handle_resync_dump_comp(struct mlx5e_txqsq *sq,
 					   struct mlx5e_tx_wqe_info *wi,
-					   struct mlx5e_sq_dma *dma)
+					   u32 *dma_fifo_cc)
 {
-	struct mlx5e_sq_stats *stats = sq->stats;
+	struct mlx5e_sq_stats *stats;
+	struct mlx5e_sq_dma *dma;
+
+	if (!wi->resync_dump_frag)
+		return;
+
+	dma = mlx5e_dma_get(sq, (*dma_fifo_cc)++);
+	stats = sq->stats;
 
 	mlx5e_tx_dma_unmap(sq->pdev, dma);
 	__skb_frag_unref(wi->resync_dump_frag);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 9aaf74407a11f..4eebf7946aca1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -480,14 +480,7 @@ bool mlx5e_poll_tx_cq(struct mlx5e_cq *cq, int napi_budget)
 			skb = wi->skb;
 
 			if (unlikely(!skb)) {
-#ifdef CONFIG_MLX5_EN_TLS
-				if (wi->resync_dump_frag) {
-					struct mlx5e_sq_dma *dma =
-						mlx5e_dma_get(sq, dma_fifo_cc++);
-
-					mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, dma);
-				}
-#endif
+				mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
 				sqcc += wi->num_wqebbs;
 				continue;
 			}
@@ -543,29 +536,38 @@ void mlx5e_free_txqsq_descs(struct mlx5e_txqsq *sq)
 {
 	struct mlx5e_tx_wqe_info *wi;
 	struct sk_buff *skb;
+	u32 dma_fifo_cc;
+	u16 sqcc;
 	u16 ci;
 	int i;
 
-	while (sq->cc != sq->pc) {
-		ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->cc);
+	sqcc = sq->cc;
+	dma_fifo_cc = sq->dma_fifo_cc;
+
+	while (sqcc != sq->pc) {
+		ci = mlx5_wq_cyc_ctr2ix(&sq->wq, sqcc);
 		wi = &sq->db.wqe_info[ci];
 		skb = wi->skb;
 
 		if (!skb) {
-			sq->cc += wi->num_wqebbs;
+			mlx5e_ktls_tx_handle_resync_dump_comp(sq, wi, &dma_fifo_cc);
+			sqcc += wi->num_wqebbs;
 			continue;
 		}
 
 		for (i = 0; i < wi->num_dma; i++) {
 			struct mlx5e_sq_dma *dma =
-				mlx5e_dma_get(sq, sq->dma_fifo_cc++);
+				mlx5e_dma_get(sq, dma_fifo_cc++);
 
 			mlx5e_tx_dma_unmap(sq->pdev, dma);
 		}
 
 		dev_kfree_skb_any(skb);
-		sq->cc += wi->num_wqebbs;
+		sqcc += wi->num_wqebbs;
 	}
+
+	sq->dma_fifo_cc = dma_fifo_cc;
+	sq->cc = sqcc;
 }
 
 #ifdef CONFIG_MLX5_CORE_IPOIB
-- 
2.20.1



