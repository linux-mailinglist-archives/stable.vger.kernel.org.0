Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D86420EF7
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:28:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237121AbhJDN3z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:29:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237301AbhJDN2U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:28:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4833961CF1;
        Mon,  4 Oct 2021 13:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353148;
        bh=ACW6hK/bxBhrKoJRAmXCY1vQZLYwpA0ua52mYen6ehU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PlemMmIh65bRqw9KMQd0MYB2YFwh3pgu4UQzCJKfK+dLEqfUS0FEK6zAmiJtKZIWC
         bYUhd46n8IEaS1BOyBKP7pIpplDi/u3O34VzBEb46/PcbuL0o8qzBPxhm68I7mm+Dh
         4SSOt0NEKsx0ZNO879MMHyHjC9Twub3Q6sqOWndo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lama Kayal <lkayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 015/172] net/mlx4_en: Resolve bad operstate value
Date:   Mon,  4 Oct 2021 14:51:05 +0200
Message-Id: <20211004125045.460790743@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lama Kayal <lkayal@nvidia.com>

[ Upstream commit 72a3c58d18fd780eecd80178bb2132ce741a0a74 ]

Any link state change that's done prior to net device registration
isn't reflected on the state, thus the operational state is left
obsolete, with 'UNKNOWN' status.

To resolve the issue, query link state from FW upon open operations
to ensure operational state is updated.

Fixes: c27a02cd94d6 ("mlx4_en: Add driver for Mellanox ConnectX 10GbE NIC")
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx4/en_netdev.c    | 47 ++++++++++++-------
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h  |  1 -
 2 files changed, 29 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index 1e672bc36c4d..a6878e5f922a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -1272,7 +1272,6 @@ static void mlx4_en_do_set_rx_mode(struct work_struct *work)
 	if (!netif_carrier_ok(dev)) {
 		if (!mlx4_en_QUERY_PORT(mdev, priv->port)) {
 			if (priv->port_state.link_state) {
-				priv->last_link_state = MLX4_DEV_EVENT_PORT_UP;
 				netif_carrier_on(dev);
 				en_dbg(LINK, priv, "Link Up\n");
 			}
@@ -1560,26 +1559,36 @@ static void mlx4_en_service_task(struct work_struct *work)
 	mutex_unlock(&mdev->state_lock);
 }
 
-static void mlx4_en_linkstate(struct work_struct *work)
+static void mlx4_en_linkstate(struct mlx4_en_priv *priv)
+{
+	struct mlx4_en_port_state *port_state = &priv->port_state;
+	struct mlx4_en_dev *mdev = priv->mdev;
+	struct net_device *dev = priv->dev;
+	bool up;
+
+	if (mlx4_en_QUERY_PORT(mdev, priv->port))
+		port_state->link_state = MLX4_PORT_STATE_DEV_EVENT_PORT_DOWN;
+
+	up = port_state->link_state == MLX4_PORT_STATE_DEV_EVENT_PORT_UP;
+	if (up == netif_carrier_ok(dev))
+		netif_carrier_event(dev);
+	if (!up) {
+		en_info(priv, "Link Down\n");
+		netif_carrier_off(dev);
+	} else {
+		en_info(priv, "Link Up\n");
+		netif_carrier_on(dev);
+	}
+}
+
+static void mlx4_en_linkstate_work(struct work_struct *work)
 {
 	struct mlx4_en_priv *priv = container_of(work, struct mlx4_en_priv,
 						 linkstate_task);
 	struct mlx4_en_dev *mdev = priv->mdev;
-	int linkstate = priv->link_state;
 
 	mutex_lock(&mdev->state_lock);
-	/* If observable port state changed set carrier state and
-	 * report to system log */
-	if (priv->last_link_state != linkstate) {
-		if (linkstate == MLX4_DEV_EVENT_PORT_DOWN) {
-			en_info(priv, "Link Down\n");
-			netif_carrier_off(priv->dev);
-		} else {
-			en_info(priv, "Link Up\n");
-			netif_carrier_on(priv->dev);
-		}
-	}
-	priv->last_link_state = linkstate;
+	mlx4_en_linkstate(priv);
 	mutex_unlock(&mdev->state_lock);
 }
 
@@ -2082,9 +2091,11 @@ static int mlx4_en_open(struct net_device *dev)
 	mlx4_en_clear_stats(dev);
 
 	err = mlx4_en_start_port(dev);
-	if (err)
+	if (err) {
 		en_err(priv, "Failed starting port:%d\n", priv->port);
-
+		goto out;
+	}
+	mlx4_en_linkstate(priv);
 out:
 	mutex_unlock(&mdev->state_lock);
 	return err;
@@ -3171,7 +3182,7 @@ int mlx4_en_init_netdev(struct mlx4_en_dev *mdev, int port,
 	spin_lock_init(&priv->stats_lock);
 	INIT_WORK(&priv->rx_mode_task, mlx4_en_do_set_rx_mode);
 	INIT_WORK(&priv->restart_task, mlx4_en_restart);
-	INIT_WORK(&priv->linkstate_task, mlx4_en_linkstate);
+	INIT_WORK(&priv->linkstate_task, mlx4_en_linkstate_work);
 	INIT_DELAYED_WORK(&priv->stats_task, mlx4_en_do_get_stats);
 	INIT_DELAYED_WORK(&priv->service_task, mlx4_en_service_task);
 #ifdef CONFIG_RFS_ACCEL
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
index f3d1a20201ef..6bf558c5ec10 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4_en.h
@@ -552,7 +552,6 @@ struct mlx4_en_priv {
 
 	struct mlx4_hwq_resources res;
 	int link_state;
-	int last_link_state;
 	bool port_up;
 	int port;
 	int registered;
-- 
2.33.0



