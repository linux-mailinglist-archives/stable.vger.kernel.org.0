Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B25A92DEF64
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:04:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgLSNDI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 08:03:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728076AbgLSNDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 08:03:07 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moshe Shemesh <moshe@mellanox.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 13/34] net/mlx4_en: Avoid scheduling restart task if it is already running
Date:   Sat, 19 Dec 2020 14:03:10 +0100
Message-Id: <20201219125342.034050096@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125341.384025953@linuxfoundation.org>
References: <20201219125341.384025953@linuxfoundation.org>
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
@@ -1383,8 +1383,10 @@ static void mlx4_en_tx_timeout(struct ne
 	}
 
 	priv->port_stats.tx_timeout++;
-	en_dbg(DRV, priv, "Scheduling watchdog\n");
-	queue_work(mdev->workqueue, &priv->watchdog_task);
+	if (!test_and_set_bit(MLX4_EN_STATE_FLAG_RESTARTING, &priv->state)) {
+		en_dbg(DRV, priv, "Scheduling port restart\n");
+		queue_work(mdev->workqueue, &priv->restart_task);
+	}
 }
 
 
@@ -1834,6 +1836,7 @@ int mlx4_en_start_port(struct net_device
 		local_bh_enable();
 	}
 
+	clear_bit(MLX4_EN_STATE_FLAG_RESTARTING, &priv->state);
 	netif_tx_start_all_queues(dev);
 	netif_device_attach(dev);
 
@@ -2004,7 +2007,7 @@ void mlx4_en_stop_port(struct net_device
 static void mlx4_en_restart(struct work_struct *work)
 {
 	struct mlx4_en_priv *priv = container_of(work, struct mlx4_en_priv,
-						 watchdog_task);
+						 restart_task);
 	struct mlx4_en_dev *mdev = priv->mdev;
 	struct net_device *dev = priv->dev;
 
@@ -2386,7 +2389,7 @@ static int mlx4_en_change_mtu(struct net
 	if (netif_running(dev)) {
 		mutex_lock(&mdev->state_lock);
 		if (!mdev->device_up) {
-			/* NIC is probably restarting - let watchdog task reset
+			/* NIC is probably restarting - let restart task reset
 			 * the port */
 			en_dbg(DRV, priv, "Change MTU called with card down!?\n");
 		} else {
@@ -2395,7 +2398,9 @@ static int mlx4_en_change_mtu(struct net
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
@@ -2865,7 +2870,8 @@ static int mlx4_xdp_set(struct net_devic
 		if (err) {
 			en_err(priv, "Failed starting port %d for XDP change\n",
 			       priv->port);
-			queue_work(mdev->workqueue, &priv->watchdog_task);
+			if (!test_and_set_bit(MLX4_EN_STATE_FLAG_RESTARTING, &priv->state))
+				queue_work(mdev->workqueue, &priv->restart_task);
 		}
 	}
 
@@ -3263,7 +3269,7 @@ int mlx4_en_init_netdev(struct mlx4_en_d
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
@@ -530,6 +530,10 @@ struct mlx4_en_stats_bitmap {
 	struct mutex mutex; /* for mutual access to stats bitmap */
 };
 
+enum {
+	MLX4_EN_STATE_FLAG_RESTARTING,
+};
+
 struct mlx4_en_priv {
 	struct mlx4_en_dev *mdev;
 	struct mlx4_en_port_profile *prof;
@@ -595,7 +599,7 @@ struct mlx4_en_priv {
 	struct mlx4_en_cq *rx_cq[MAX_RX_RINGS];
 	struct mlx4_qp drop_qp;
 	struct work_struct rx_mode_task;
-	struct work_struct watchdog_task;
+	struct work_struct restart_task;
 	struct work_struct linkstate_task;
 	struct delayed_work stats_task;
 	struct delayed_work service_task;
@@ -643,6 +647,7 @@ struct mlx4_en_priv {
 	u32 pflags;
 	u8 rss_key[MLX4_EN_RSS_KEY_SIZE];
 	u8 rss_hash_fn;
+	unsigned long state;
 };
 
 enum mlx4_en_wol {


