Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D107579BCC
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240331AbiGSMcE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:32:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240340AbiGSMa2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:30:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63866D540;
        Tue, 19 Jul 2022 05:11:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D176B81B84;
        Tue, 19 Jul 2022 12:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC697C341CF;
        Tue, 19 Jul 2022 12:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232711;
        bh=Nb1vW5IQk2Vln6SQhixDVXvDjPnKh1njt1nUAEYqPVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vFChtpNIa7rzFzO7XhI8lZaGJrTcjXaHhSL/aot+OLuzGRd/Owk7w5dQ12GFwIiU8
         vhFVUUyubEnuvMW2XzUi7qLSJA1vtG6R/R3AsIMAr91Ed9oHIUj61W8SSYf6g2A03K
         jBuvLc73hFprgQM9pSwdr6Sp6pG4msruXc3qPkJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/167] net/mlx5e: Ring the TX doorbell on DMA errors
Date:   Tue, 19 Jul 2022 13:52:51 +0200
Message-Id: <20220719114700.464089487@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114656.750574879@linuxfoundation.org>
References: <20220719114656.750574879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

[ Upstream commit 5b759bf2f9d73db05369aef2344502095c4e5e73 ]

TX doorbells may be postponed, because sometimes the driver knows that
another packet follows (for example, when xmit_more is true, or when a
MPWQE session is closed before transmitting a packet).

However, the DMA mapping may fail for the next packet, in which case a
new WQE is not posted, the doorbell isn't updated either, and the
transmission of the previous packet will be delayed indefinitely.

This commit fixes the described rare error flow by posting a NOP and
ringing the doorbell on errors to flush all the previous packets. The
MPWQE session is closed before that. DMA mapping in the MPWQE flow is
moved to the beginning of mlx5e_sq_xmit_mpwqe, because empty sessions
are not allowed. Stop room always has enough space for a NOP, because
the actual TX WQE is not posted.

Fixes: e586b3b0baee ("net/mlx5: Ethernet Datapath files")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_tx.c   | 39 ++++++++++++++-----
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
index 7fd33b356cc8..1544d4c2c636 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tx.c
@@ -429,6 +429,26 @@ static void mlx5e_tx_check_stop(struct mlx5e_txqsq *sq)
 	}
 }
 
+static void mlx5e_tx_flush(struct mlx5e_txqsq *sq)
+{
+	struct mlx5e_tx_wqe_info *wi;
+	struct mlx5e_tx_wqe *wqe;
+	u16 pi;
+
+	/* Must not be called when a MPWQE session is active but empty. */
+	mlx5e_tx_mpwqe_ensure_complete(sq);
+
+	pi = mlx5_wq_cyc_ctr2ix(&sq->wq, sq->pc);
+	wi = &sq->db.wqe_info[pi];
+
+	*wi = (struct mlx5e_tx_wqe_info) {
+		.num_wqebbs = 1,
+	};
+
+	wqe = mlx5e_post_nop(&sq->wq, sq->sqn, &sq->pc);
+	mlx5e_notify_hw(&sq->wq, sq->pc, sq->uar_map, &wqe->ctrl);
+}
+
 static inline void
 mlx5e_txwqe_complete(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 		     const struct mlx5e_tx_attr *attr,
@@ -521,6 +541,7 @@ mlx5e_sq_xmit_wqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 err_drop:
 	stats->dropped++;
 	dev_kfree_skb_any(skb);
+	mlx5e_tx_flush(sq);
 }
 
 static bool mlx5e_tx_skb_supports_mpwqe(struct sk_buff *skb, struct mlx5e_tx_attr *attr)
@@ -622,6 +643,13 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	struct mlx5_wqe_ctrl_seg *cseg;
 	struct mlx5e_xmit_data txd;
 
+	txd.data = skb->data;
+	txd.len = skb->len;
+
+	txd.dma_addr = dma_map_single(sq->pdev, txd.data, txd.len, DMA_TO_DEVICE);
+	if (unlikely(dma_mapping_error(sq->pdev, txd.dma_addr)))
+		goto err_unmap;
+
 	if (!mlx5e_tx_mpwqe_session_is_active(sq)) {
 		mlx5e_tx_mpwqe_session_start(sq, eseg);
 	} else if (!mlx5e_tx_mpwqe_same_eseg(sq, eseg)) {
@@ -631,18 +659,9 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 
 	sq->stats->xmit_more += xmit_more;
 
-	txd.data = skb->data;
-	txd.len = skb->len;
-
-	txd.dma_addr = dma_map_single(sq->pdev, txd.data, txd.len, DMA_TO_DEVICE);
-	if (unlikely(dma_mapping_error(sq->pdev, txd.dma_addr)))
-		goto err_unmap;
 	mlx5e_dma_push(sq, txd.dma_addr, txd.len, MLX5E_DMA_MAP_SINGLE);
-
 	mlx5e_skb_fifo_push(&sq->db.skb_fifo, skb);
-
 	mlx5e_tx_mpwqe_add_dseg(sq, &txd);
-
 	mlx5e_tx_skb_update_hwts_flags(skb);
 
 	if (unlikely(mlx5e_tx_mpwqe_is_full(&sq->mpwqe))) {
@@ -664,6 +683,7 @@ mlx5e_sq_xmit_mpwqe(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 	mlx5e_dma_unmap_wqe_err(sq, 1);
 	sq->stats->dropped++;
 	dev_kfree_skb_any(skb);
+	mlx5e_tx_flush(sq);
 }
 
 void mlx5e_tx_mpwqe_ensure_complete(struct mlx5e_txqsq *sq)
@@ -1033,5 +1053,6 @@ void mlx5i_sq_xmit(struct mlx5e_txqsq *sq, struct sk_buff *skb,
 err_drop:
 	stats->dropped++;
 	dev_kfree_skb_any(skb);
+	mlx5e_tx_flush(sq);
 }
 #endif
-- 
2.35.1



