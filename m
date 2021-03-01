Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D319328E49
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:30:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241434AbhCAT10 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:27:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241544AbhCATYF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:24:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 364A664F4F;
        Mon,  1 Mar 2021 17:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620400;
        bh=wEx1sotZfEUS5WDRQaH7e4NzQqE4avaeU48lgJAIjrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B1mRoaXQ2X2HsQGd5ge9sy+VCoc3sYd0X7ceOpRNd45Tyoul5hy2wJpsdS+bwbK+I
         0FvLKWEnFSm7Y90AWy4pGpbOncMhEr2W7GIFYPHSYCk9b4riSf0d8hRx513E7EkPjt
         5U2x7p8IzxddrqnewcRfmbweaFOm3h7YJFDluoRM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 109/775] net/mlx5e: Replace synchronize_rcu with synchronize_net
Date:   Mon,  1 Mar 2021 17:04:37 +0100
Message-Id: <20210301161207.050740165@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

[ Upstream commit 4d6e6b0c6d4bed8a7128500701354e2dc6098fa3 ]

The commit cited below switched from using napi_synchronize to
synchronize_rcu to have a guarantee that it will finish in finite time.
However, on average, synchronize_rcu takes more time than
napi_synchronize. Given that it's called multiple times per channel on
deactivation, it accumulates to a significant amount, which causes
timeouts in some applications (for example, when using bonding with
NetworkManager).

This commit replaces synchronize_rcu with synchronize_net, which is
faster when called under rtnl_lock, allowing to speed up the described
flow.

Fixes: 9c25a22dfb00 ("net/mlx5e: Use synchronize_rcu to sync with NAPI")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h          | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c    | 2 +-
 .../net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c    | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c         | 8 ++++----
 4 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
index d487e5e371625..8d991c3b7a503 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.h
@@ -83,7 +83,7 @@ static inline void mlx5e_xdp_tx_disable(struct mlx5e_priv *priv)
 
 	clear_bit(MLX5E_STATE_XDP_TX_ENABLED, &priv->state);
 	/* Let other device's napi(s) and XSK wakeups see our new state. */
-	synchronize_rcu();
+	synchronize_net();
 }
 
 static inline bool mlx5e_xdp_tx_is_enabled(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index d87c345878d3d..f4bce1365639e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -111,7 +111,7 @@ err_free_cparam:
 void mlx5e_close_xsk(struct mlx5e_channel *c)
 {
 	clear_bit(MLX5E_CHANNEL_STATE_XSK, c->state);
-	synchronize_rcu(); /* Sync with the XSK wakeup and with NAPI. */
+	synchronize_net(); /* Sync with the XSK wakeup and with NAPI. */
 
 	mlx5e_close_rq(&c->xskrq);
 	mlx5e_close_cq(&c->xskrq.cq);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
index 6a1d82503ef8f..0f13b661f7f98 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c
@@ -663,7 +663,7 @@ void mlx5e_ktls_del_rx(struct net_device *netdev, struct tls_context *tls_ctx)
 	priv_rx = mlx5e_get_ktls_rx_priv_ctx(tls_ctx);
 	set_bit(MLX5E_PRIV_RX_FLAG_DELETING, priv_rx->flags);
 	mlx5e_set_ktls_rx_priv_ctx(tls_ctx, NULL);
-	synchronize_rcu(); /* Sync with NAPI */
+	synchronize_net(); /* Sync with NAPI */
 	if (!cancel_work_sync(&priv_rx->rule.work))
 		/* completion is needed, as the priv_rx in the add flow
 		 * is maintained on the wqe info (wi), not on the socket.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 92436569ce86b..5fb0ab71d79ce 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -914,7 +914,7 @@ void mlx5e_activate_rq(struct mlx5e_rq *rq)
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
 {
 	clear_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
-	synchronize_rcu(); /* Sync with NAPI to prevent mlx5e_post_rx_wqes. */
+	synchronize_net(); /* Sync with NAPI to prevent mlx5e_post_rx_wqes. */
 }
 
 void mlx5e_close_rq(struct mlx5e_rq *rq)
@@ -1348,7 +1348,7 @@ void mlx5e_deactivate_txqsq(struct mlx5e_txqsq *sq)
 	struct mlx5_wq_cyc *wq = &sq->wq;
 
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	synchronize_rcu(); /* Sync with NAPI to prevent netif_tx_wake_queue. */
+	synchronize_net(); /* Sync with NAPI to prevent netif_tx_wake_queue. */
 
 	mlx5e_tx_disable_queue(sq->txq);
 
@@ -1423,7 +1423,7 @@ void mlx5e_activate_icosq(struct mlx5e_icosq *icosq)
 void mlx5e_deactivate_icosq(struct mlx5e_icosq *icosq)
 {
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &icosq->state);
-	synchronize_rcu(); /* Sync with NAPI. */
+	synchronize_net(); /* Sync with NAPI. */
 }
 
 void mlx5e_close_icosq(struct mlx5e_icosq *sq)
@@ -1502,7 +1502,7 @@ void mlx5e_close_xdpsq(struct mlx5e_xdpsq *sq)
 	struct mlx5e_channel *c = sq->channel;
 
 	clear_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	synchronize_rcu(); /* Sync with NAPI. */
+	synchronize_net(); /* Sync with NAPI. */
 
 	mlx5e_destroy_sq(c->mdev, sq->sqn);
 	mlx5e_free_xdpsq_descs(sq);
-- 
2.27.0



