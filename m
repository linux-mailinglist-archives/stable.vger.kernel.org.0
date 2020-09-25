Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F9C2787D2
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729103AbgIYMur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:54766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729099AbgIYMuq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:50:46 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A2BD21741;
        Fri, 25 Sep 2020 12:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038245;
        bh=YYQ5Up/FgDQ4ljcJmaf40O2BFBHGwxomsu5b/zL/ELo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x8nRa16EAJ1i/NR6LsRD7Z3//Pv1XHJH+dvWlvEF+XrNUSXA32Pa6IqlcZcg2ZO+U
         6v+4NN3U1E75rEMIUw24Gxjo3a5lfUEnYbazO4pErDmTEh02FYAPdwnvswznIorEad
         VvZslFHRkqOhrQ5/kpdSu1mmE06QHyomQfoD4MCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.8 55/56] net/mlx5e: Use synchronize_rcu to sync with NAPI
Date:   Fri, 25 Sep 2020 14:48:45 +0200
Message-Id: <20200925124736.038852803@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124727.878494124@linuxfoundation.org>
References: <20200925124727.878494124@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 9c25a22dfb00270372224721fed646965420323a ]

As described in the previous commit, napi_synchronize doesn't quite fit
the purpose when we just need to wait until the currently running NAPI
quits. Its implementation waits until NAPI is not running by polling and
waiting for 1ms in between. In cases where we need to deactivate one
queue (e.g., recovery flows) or where we deactivate them one-by-one
(deactivate channel flow), we may get stuck in napi_synchronize forever
if other queues keep NAPI active, causing a soft lockup. Depending on
kernel configuration (CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC), it may result
in a kernel panic.

To fix the issue, use synchronize_rcu to wait for NAPI to quit, and wrap
the whole NAPI in rcu_read_lock.

Fixes: acc6c5953af1 ("net/mlx5e: Split open/close channels to stages")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c    |   14 ++------------
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |    3 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c      |   12 ++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c        |   12 ++----------
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c      |   17 +++++++++++++----
 5 files changed, 22 insertions(+), 36 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/rx.c
@@ -31,7 +31,6 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_m
 {
 	struct xdp_buff *xdp = wi->umr.dma_info[page_idx].xsk;
 	u32 cqe_bcnt32 = cqe_bcnt;
-	bool consumed;
 
 	/* Check packet size. Note LRO doesn't use linear SKB */
 	if (unlikely(cqe_bcnt > rq->hw_mtu)) {
@@ -51,10 +50,6 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_m
 	xsk_buff_dma_sync_for_cpu(xdp);
 	prefetch(xdp->data);
 
-	rcu_read_lock();
-	consumed = mlx5e_xdp_handle(rq, NULL, &cqe_bcnt32, xdp);
-	rcu_read_unlock();
-
 	/* Possible flows:
 	 * - XDP_REDIRECT to XSKMAP:
 	 *   The page is owned by the userspace from now.
@@ -70,7 +65,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_m
 	 * allocated first from the Reuse Ring, so it has enough space.
 	 */
 
-	if (likely(consumed)) {
+	if (likely(mlx5e_xdp_handle(rq, NULL, &cqe_bcnt32, xdp))) {
 		if (likely(__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags)))
 			__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
 		return NULL; /* page/packet was consumed by XDP */
@@ -88,7 +83,6 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_l
 					      u32 cqe_bcnt)
 {
 	struct xdp_buff *xdp = wi->di->xsk;
-	bool consumed;
 
 	/* wi->offset is not used in this function, because xdp->data and the
 	 * DMA address point directly to the necessary place. Furthermore, the
@@ -107,11 +101,7 @@ struct sk_buff *mlx5e_xsk_skb_from_cqe_l
 		return NULL;
 	}
 
-	rcu_read_lock();
-	consumed = mlx5e_xdp_handle(rq, NULL, &cqe_bcnt, xdp);
-	rcu_read_unlock();
-
-	if (likely(consumed))
+	if (likely(mlx5e_xdp_handle(rq, NULL, &cqe_bcnt, xdp)))
 		return NULL; /* page/packet was consumed by XDP */
 
 	/* XDP_PASS: copy the data from the UMEM to a new SKB. The frame reuse
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -143,8 +143,7 @@ err_free_cparam:
 void mlx5e_close_xsk(struct mlx5e_channel *c)
 {
 	clear_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
-	napi_synchronize(&c->napi);
-	synchronize_rcu(); /* Sync with the XSK wakeup. */
+	synchronize_rcu(); /* Sync with the XSK wakeup and with NAPI. */
 
 	mlx5e_close_rq(&c->xskrq);
 	mlx5e_close_cq(&c->xskrq.cq);
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -911,7 +911,7 @@ void mlx5e_activate_rq(struct mlx5e_rq *
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
 {
 	clear_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
-	napi_synchronize(&rq->channel->napi); /* prevent mlx5e_post_rx_wqes */
+	synchronize_rcu(); /* Sync with NAPI to prevent mlx5e_post_rx_wqes. */
 }
 
 void mlx5e_close_rq(struct mlx5e_rq *rq)
@@ -1356,12 +1356,10 @@ void mlx5e_tx_disable_queue(struct netde
 
 static void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq)
 {
-	struct mlx5e_channel *c = sq->channel;
 	struct mlx5_wq_cyc *wq = &sq->wq;
 
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	/* prevent netif_tx_wake_queue */
-	napi_synchronize(&c->napi);
+	synchronize_rcu(); /* Sync with NAPI to prevent netif_tx_wake_queue. */
 
 	mlx5e_tx_disable_queue(sq->txq);
 
@@ -1436,10 +1434,8 @@ void mlx5e_activate_icosq(struct mlx5e_i
 
 void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
 {
-	struct mlx5e_channel *c = icosq->channel;
-
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
-	napi_synchronize(&c->napi);
+	synchronize_rcu(); /* Sync with NAPI. */
 }
 
 void mlx5e_close_icosq(struct mlx5e_icosq *sq)
@@ -1517,7 +1513,7 @@ void mlx5e_close_xdpsq(struct mlx5e_xdps
 	struct mlx5e_channel *c = sq->channel;
 
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	napi_synchronize(&c->napi);
+	synchronize_rcu(); /* Sync with NAPI. */
 
 	mlx5e_destroy_sq(c->mdev, sq->sqn);
 	mlx5e_free_xdpsq_descs(sq);
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1072,7 +1072,6 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_r
 	struct xdp_buff xdp;
 	struct sk_buff *skb;
 	void *va, *data;
-	bool consumed;
 	u32 frag_size;
 
 	va             = page_address(di->page) + wi->offset;
@@ -1084,11 +1083,8 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_r
 	prefetchw(va); /* xdp_frame data area */
 	prefetch(data);
 
-	rcu_read_lock();
 	mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt, &xdp);
-	consumed = mlx5e_xdp_handle(rq, di, &cqe_bcnt, &xdp);
-	rcu_read_unlock();
-	if (consumed)
+	if (mlx5e_xdp_handle(rq, di, &cqe_bcnt, &xdp))
 		return NULL; /* page/packet was consumed by XDP */
 
 	rx_headroom = xdp.data - xdp.data_hard_start;
@@ -1369,7 +1365,6 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct m
 	struct sk_buff *skb;
 	void *va, *data;
 	u32 frag_size;
-	bool consumed;
 
 	/* Check packet size. Note LRO doesn't use linear SKB */
 	if (unlikely(cqe_bcnt > rq->hw_mtu)) {
@@ -1386,11 +1381,8 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct m
 	prefetchw(va); /* xdp_frame data area */
 	prefetch(data);
 
-	rcu_read_lock();
 	mlx5e_fill_xdp_buff(rq, va, rx_headroom, cqe_bcnt32, &xdp);
-	consumed = mlx5e_xdp_handle(rq, di, &cqe_bcnt32, &xdp);
-	rcu_read_unlock();
-	if (consumed) {
+	if (mlx5e_xdp_handle(rq, di, &cqe_bcnt32, &xdp)) {
 		if (__test_and_clear_bit(MLX5E_RQ_FLAG_XDP_XMIT, rq->flags))
 			__set_bit(page_idx, wi->xdp_xmit_bitmap); /* non-atomic */
 		return NULL; /* page/packet was consumed by XDP */
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -121,13 +121,17 @@ int mlx5e_napi_poll(struct napi_struct *
 	struct mlx5e_xdpsq *xsksq = &c->xsksq;
 	struct mlx5e_rq *xskrq = &c->xskrq;
 	struct mlx5e_rq *rq = &c->rq;
-	bool xsk_open = test_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
 	bool aff_change = false;
 	bool busy_xsk = false;
 	bool busy = false;
 	int work_done = 0;
+	bool xsk_open;
 	int i;
 
+	rcu_read_lock();
+
+	xsk_open = test_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
+
 	ch_stats->poll++;
 
 	for (i = 0; i < c->num_tc; i++)
@@ -167,8 +171,10 @@ int mlx5e_napi_poll(struct napi_struct *
 	busy |= busy_xsk;
 
 	if (busy) {
-		if (likely(mlx5e_channel_no_affinity_change(c)))
-			return budget;
+		if (likely(mlx5e_channel_no_affinity_change(c))) {
+			work_done = budget;
+			goto out;
+		}
 		ch_stats->aff_change++;
 		aff_change = true;
 		if (budget && work_done == budget)
@@ -176,7 +182,7 @@ int mlx5e_napi_poll(struct napi_struct *
 	}
 
 	if (unlikely(!napi_complete_done(napi, work_done)))
-		return work_done;
+		goto out;
 
 	ch_stats->arm++;
 
@@ -203,6 +209,9 @@ int mlx5e_napi_poll(struct napi_struct *
 		ch_stats->force_irq++;
 	}
 
+out:
+	rcu_read_unlock();
+
 	return work_done;
 }
 


