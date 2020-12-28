Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA92F2E67A3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730907AbgL1Q1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:27:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:36018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730893AbgL1NIT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:08:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FD232242A;
        Mon, 28 Dec 2020 13:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160857;
        bh=pm2huu2Z72gk00xjWAXQG5QhEIA27tHDi5N8MBYVjPo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PdXw0x9ns5UWUn0K+Mr+jLBSH27HfLCYQfiH3kGFdF6aCBNsu+1E5zRmr5oZDUOl7
         bvlq254bM6pCr1Vd4HCHQCPdnl7A9TjrWXWfGfrHIh1Amz7gEn2qWfGW2jhkY4yHIM
         Dm38ZT+mi6j0+59gOb7oHr7gAUozVh79tk9AbouQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 019/242] net/mlx4_en: Avoid scheduling restart task if it is already running
Date:   Mon, 28 Dec 2020 13:47:04 +0100
Message-Id: <20201228124905.612749029@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124904.654293249@linuxfoundation.org>
References: <20201228124904.654293249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

[ Upstream commit fed91613c9dd455dd154b22fa8e11b8526466082 ]

Add restarting state flag to avoid scheduling another restart task while
such task is already running. Change task name from watchdog_task to
restart_task to better fit the task role.

Fixes: 1e338db56e5a ("mlx4_en: Fix a race at restart task")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |   20 +++++++++++++-------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |    7 ++++++-
 2 files changed, 19 insertions(+), 8 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1389,8 +1389,10 @@ static void mlx4_en_tx_timeout(struct ne
 	}
 
 	priv->port_stats.tx_timeout++;
-	en_dbg(DRV, priv, "Scheduling watchdog\n");
-	queue_work(mdev->workqueue, &priv->watchdog_task);
+	if (!test_and_set_bit(MLX4_EN_STATE_FLAG_RESTARTING, &priv->state)) {
+		en_dbg(DRV, priv, "Scheduling port restart\n");
+		queue_work(mdev->workqueue, &priv->restart_task);
+	}
 }
 
 
@@ -1839,6 +1841,7 @@ int mlx4_en_start_port(struct net_device
 		local_bh_enable();
 	}
 
+	clear_bit(MLX4_EN_STATE_FLAG_RESTARTING, &priv->state);
 	netif_tx_start_all_queues(dev);
 	netif_device_attach(dev);
 
@@ -2009,7 +2012,7 @@ void mlx4_en_stop_port(struct net_device
 static void mlx4_en_restart(struct work_struct *work)
 {
 	struct mlx4_en_priv *priv = container_of(work, struct mlx4_en_priv,
-						 watchdog_task);
+						 restart_task);
 	struct mlx4_en_dev *mdev = priv->mdev;
 	struct net_device *dev = priv->dev;
 
@@ -2388,7 +2391,7 @@ static int mlx4_en_change_mtu(struct net
 	if (netif_running(dev)) {
 		mutex_lock(&mdev->state_lock);
 		if (!mdev->device_up) {
-			/* NIC is probably restarting - let watchdog task reset
+			/* NIC is probably restarting - let restart task reset
 			 * the port */
 			en_dbg(DRV, priv, "Change MTU called with card down!?\n");
 		} else {
@@ -2397,7 +2400,9 @@ static int mlx4_en_change_mtu(struct net
 			if (err) {
 				en_err(priv, "Failed restarting port:%d\n",
 					 priv->port);
-				queue_work(mdev->workqueue, &priv->watchdog_task);
+				if (!test_and_set_bit(MLX4_EN_STATE_FLAG_RESTARTING,
+						      &priv->state))
+					queue_work(mdev->workqueue, &priv->restart_task);
 			}
 		}
 		mutex_unlock(&mdev->state_lock);
@@ -2883,7 +2888,8 @@ static int mlx4_xdp_set(struct net_devic
 		if (err) {
 			en_err(priv, "Failed starting port %d for XDP change\n",
 			       priv->port);
-			queue_work(mdev->workqueue, &priv->watchdog_task);
+			if (!test_and_set_bit(MLX4_EN_STATE_FLAG_RESTARTING, &priv->state))
+				queue_work(mdev->workqueue, &priv->restart_task);
 		}
 	}
 
@@ -3284,7 +3290,7 @@ int mlx4_en_init_netdev(struct mlx4_en_d
 	priv->counter_index = MLX4_SINK_COUNTER_INDEX(mdev->dev);
 	spin_lock_init(&priv->stats_lock);
 	INIT_WORK(&priv->rx_mode_task, mlx4_en_do_set_rx_mode);
-	INIT_WORK(&priv->watchdog_task, mlx4_en_restart);
+	INIT_WORK(&priv->restart_task, mlx4_en_restart);
 	INIT_WORK(&priv->linkstate_task, mlx4_en_linkstate);
 	INIT_DELAYED_WORK(&priv->stats_task, mlx4_en_do_get_stats);
 	INIT_DELAYED_WORK(&priv->service_task, mlx4_en_service_task);
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -525,6 +525,10 @@ struct mlx4_en_stats_bitmap {
 	struct mutex mutex; /* for mutual access to stats bitmap */
 };
 
+enum {
+	MLX4_EN_STATE_FLAG_RESTARTING,
+};
+
 struct mlx4_en_priv {
 	struct mlx4_en_dev *mdev;
 	struct mlx4_en_port_profile *prof;
@@ -590,7 +594,7 @@ struct mlx4_en_priv {
 	struct mlx4_en_cq *rx_cq[MAX_RX_RINGS];
 	struct mlx4_qp drop_qp;
 	struct work_struct rx_mode_task;
-	struct work_struct watchdog_task;
+	struct work_struct restart_task;
 	struct work_struct linkstate_task;
 	struct delayed_work stats_task;
 	struct delayed_work service_task;
@@ -637,6 +641,7 @@ struct mlx4_en_priv {
 	u32 pflags;
 	u8 rss_key[MLX4_EN_RSS_KEY_SIZE];
 	u8 rss_hash_fn;
+	unsigned long state;
 };
 
 enum mlx4_en_wol {


