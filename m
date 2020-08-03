Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CCF23A693
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgHCMtP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:48268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbgHCMYA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:24:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 97B35207FC;
        Mon,  3 Aug 2020 12:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457439;
        bh=DJkl6V20e7slHylin2S//r7OqYf61RZP7yp8UIEI24o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qbfBqcniZ8s0TcvmEE4b0Y87uxE3iUuSgVA2a5hHzN2q6ojD/Hmi1ceq15Iwtb+vU
         YZo35SRVbnllK80pMmHUerIjokzAJogit6JH9l1qXDF3vD3b1HDsfuf6E4XaYgcmeP
         mTk/AmeQ3DAylDCfpKb8Rgrj5kh9qmIDenB3WyUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ron Diskin <rondi@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 060/120] net/mlx5e: Modify uplink state on interface up/down
Date:   Mon,  3 Aug 2020 14:18:38 +0200
Message-Id: <20200803121905.723639100@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
References: <20200803121902.860751811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ron Diskin <rondi@mellanox.com>

[ Upstream commit 7d0314b11cdd92bca8b89684c06953bf114605fc ]

When setting the PF interface up/down, notify the firmware to update
uplink state via MODIFY_VPORT_STATE, when E-Switch is enabled.

This behavior will prevent sending traffic out on uplink port when PF is
down, such as sending traffic from a VF interface which is still up.
Currently when calling mlx5e_open/close(), the driver only sends PAOS
command to notify the firmware to set the physical port state to
up/down, however, it is not sufficient. When VF is in "auto" state, it
follows the uplink state, which was not updated on mlx5e_open/close()
before this patch.

When switchdev mode is enabled and uplink representor is first enabled,
set the uplink port state value back to its FW default "AUTO".

Fixes: 63bfd399de55 ("net/mlx5e: Send PAOS command on interface up/down")
Signed-off-by: Ron Diskin <rondi@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en_main.c | 25 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  2 ++
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 16 +++++++-----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 ++
 include/linux/mlx5/mlx5_ifc.h                 |  1 +
 5 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 5f8c69ea82539..b485eec812111 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -3041,6 +3041,25 @@ void mlx5e_timestamp_init(struct mlx5e_priv *priv)
 	priv->tstamp.rx_filter = HWTSTAMP_FILTER_NONE;
 }
 
+static void mlx5e_modify_admin_state(struct mlx5_core_dev *mdev,
+				     enum mlx5_port_status state)
+{
+	struct mlx5_eswitch *esw = mdev->priv.eswitch;
+	int vport_admin_state;
+
+	mlx5_set_port_admin_status(mdev, state);
+
+	if (!MLX5_ESWITCH_MANAGER(mdev) ||  mlx5_eswitch_mode(esw) == MLX5_ESWITCH_OFFLOADS)
+		return;
+
+	if (state == MLX5_PORT_UP)
+		vport_admin_state = MLX5_VPORT_ADMIN_STATE_AUTO;
+	else
+		vport_admin_state = MLX5_VPORT_ADMIN_STATE_DOWN;
+
+	mlx5_eswitch_set_vport_state(esw, MLX5_VPORT_UPLINK, vport_admin_state);
+}
+
 int mlx5e_open_locked(struct net_device *netdev)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -3073,7 +3092,7 @@ int mlx5e_open(struct net_device *netdev)
 	mutex_lock(&priv->state_lock);
 	err = mlx5e_open_locked(netdev);
 	if (!err)
-		mlx5_set_port_admin_status(priv->mdev, MLX5_PORT_UP);
+		mlx5e_modify_admin_state(priv->mdev, MLX5_PORT_UP);
 	mutex_unlock(&priv->state_lock);
 
 	return err;
@@ -3107,7 +3126,7 @@ int mlx5e_close(struct net_device *netdev)
 		return -ENODEV;
 
 	mutex_lock(&priv->state_lock);
-	mlx5_set_port_admin_status(priv->mdev, MLX5_PORT_DOWN);
+	mlx5e_modify_admin_state(priv->mdev, MLX5_PORT_DOWN);
 	err = mlx5e_close_locked(netdev);
 	mutex_unlock(&priv->state_lock);
 
@@ -5185,7 +5204,7 @@ static void mlx5e_nic_enable(struct mlx5e_priv *priv)
 
 	/* Marking the link as currently not needed by the Driver */
 	if (!netif_running(netdev))
-		mlx5_set_port_admin_status(mdev, MLX5_PORT_DOWN);
+		mlx5e_modify_admin_state(mdev, MLX5_PORT_DOWN);
 
 	mlx5e_set_netdev_mtu_boundaries(priv);
 	mlx5e_set_dev_port_mtu(priv);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 4a8e0dfdc5f2c..e93d7430c1a31 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -1922,6 +1922,8 @@ static void mlx5e_uplink_rep_enable(struct mlx5e_priv *priv)
 	INIT_WORK(&rpriv->uplink_priv.reoffload_flows_work,
 		  mlx5e_tc_reoffload_flows_work);
 
+	mlx5_modify_vport_admin_state(mdev, MLX5_VPORT_STATE_OP_MOD_UPLINK,
+				      0, 0, MLX5_VPORT_ADMIN_STATE_AUTO);
 	mlx5_lag_add(mdev, netdev);
 	priv->events_nb.notifier_call = uplink_rep_async_event;
 	mlx5_notifier_register(mdev, &priv->events_nb);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 3bb4f72b76da2..577a5b3b841ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2374,6 +2374,8 @@ int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 				 u16 vport, int link_state)
 {
 	struct mlx5_vport *evport = mlx5_eswitch_get_vport(esw, vport);
+	int opmod = MLX5_VPORT_STATE_OP_MOD_ESW_VPORT;
+	int other_vport = 1;
 	int err = 0;
 
 	if (!ESW_ALLOWED(esw))
@@ -2381,15 +2383,17 @@ int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw,
 	if (IS_ERR(evport))
 		return PTR_ERR(evport);
 
+	if (vport == MLX5_VPORT_UPLINK) {
+		opmod = MLX5_VPORT_STATE_OP_MOD_UPLINK;
+		other_vport = 0;
+		vport = 0;
+	}
 	mutex_lock(&esw->state_lock);
 
-	err = mlx5_modify_vport_admin_state(esw->dev,
-					    MLX5_VPORT_STATE_OP_MOD_ESW_VPORT,
-					    vport, 1, link_state);
+	err = mlx5_modify_vport_admin_state(esw->dev, opmod, vport, other_vport, link_state);
 	if (err) {
-		mlx5_core_warn(esw->dev,
-			       "Failed to set vport %d link state, err = %d",
-			       vport, err);
+		mlx5_core_warn(esw->dev, "Failed to set vport %d link state, opmod = %d, err = %d",
+			       vport, opmod, err);
 		goto unlock;
 	}
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index c1848b57f61c8..56d2a1ab9378e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -684,6 +684,8 @@ static inline int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs) { r
 static inline void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf) {}
 static inline bool mlx5_esw_lag_prereq(struct mlx5_core_dev *dev0, struct mlx5_core_dev *dev1) { return true; }
 static inline bool mlx5_eswitch_is_funcs_handler(struct mlx5_core_dev *dev) { return false; }
+static inline
+int mlx5_eswitch_set_vport_state(struct mlx5_eswitch *esw, u16 vport, int link_state) { return 0; }
 static inline const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 {
 	return ERR_PTR(-EOPNOTSUPP);
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 69b27c7dfc3e2..fb7fa1fc8e010 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -4347,6 +4347,7 @@ struct mlx5_ifc_query_vport_state_out_bits {
 enum {
 	MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT  = 0x0,
 	MLX5_VPORT_STATE_OP_MOD_ESW_VPORT   = 0x1,
+	MLX5_VPORT_STATE_OP_MOD_UPLINK      = 0x2,
 };
 
 struct mlx5_ifc_arm_monitor_counter_in_bits {
-- 
2.25.1



