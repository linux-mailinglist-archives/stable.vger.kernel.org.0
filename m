Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FDFA21FB86
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 21:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731236AbgGNS6m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 14:58:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:57212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730634AbgGNS6m (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 14 Jul 2020 14:58:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9558229CA;
        Tue, 14 Jul 2020 18:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594753121;
        bh=vscYnN+/yBVE31sL8YMMRDuaN+dE6TLRG3B4dgMLsPU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TluxcQilUCNPi8/Tv6IuQGHcCV5bs8X4LMCKIfVZXjClqYV+HzK0osDDPKyr/OBtL
         3lBSlbORohMxNo4E5BFLpt9RS7kx9JORGH4awtyWJztkUlGOdnMCeNPfPzAXoOuJFO
         WZ8V8WaP8CoCN402aiAv8cbjTTe6ARqZ/4A42nec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 097/166] net/mlx5e: Fix 50G per lane indication
Date:   Tue, 14 Jul 2020 20:44:22 +0200
Message-Id: <20200714184120.491647800@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714184115.844176932@linuxfoundation.org>
References: <20200714184115.844176932@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit 6a1cf4e443a3b0a4d690d3c93b84b1e9cbfcb1bd ]

Some released FW versions mistakenly don't set the capability that 50G
per lane link-modes are supported for VFs (ptys_extended_ethernet
capability bit). When the capability is unset, read
PTYS.ext_eth_proto_capability (always reliable).
If PTYS.ext_eth_proto_capability is valid (has a non-zero value)
conclude that the HCA supports 50G per lane. Otherwise, conclude that
the HCA doesn't support 50G per lane.

Fixes: a08b4ed1373d ("net/mlx5: Add support to ext_* fields introduced in Port Type and Speed register")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/port.c | 21 ++++++++++++++++---
 .../net/ethernet/mellanox/mlx5/core/en/port.h |  2 +-
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  |  8 +++----
 3 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
index 2a8950b3056f9..3cf3e35053f77 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -78,11 +78,26 @@ static const u32 mlx5e_ext_link_speed[MLX5E_EXT_LINK_MODES_NUMBER] = {
 	[MLX5E_400GAUI_8]			= 400000,
 };
 
+bool mlx5e_ptys_ext_supported(struct mlx5_core_dev *mdev)
+{
+	struct mlx5e_port_eth_proto eproto;
+	int err;
+
+	if (MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet))
+		return true;
+
+	err = mlx5_port_query_eth_proto(mdev, 1, true, &eproto);
+	if (err)
+		return false;
+
+	return !!eproto.cap;
+}
+
 static void mlx5e_port_get_speed_arr(struct mlx5_core_dev *mdev,
 				     const u32 **arr, u32 *size,
 				     bool force_legacy)
 {
-	bool ext = force_legacy ? false : MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	bool ext = force_legacy ? false : mlx5e_ptys_ext_supported(mdev);
 
 	*size = ext ? ARRAY_SIZE(mlx5e_ext_link_speed) :
 		      ARRAY_SIZE(mlx5e_link_speed);
@@ -177,7 +192,7 @@ int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
 	bool ext;
 	int err;
 
-	ext = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	ext = mlx5e_ptys_ext_supported(mdev);
 	err = mlx5_port_query_eth_proto(mdev, 1, ext, &eproto);
 	if (err)
 		goto out;
@@ -205,7 +220,7 @@ int mlx5e_port_max_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
 	int err;
 	int i;
 
-	ext = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	ext = mlx5e_ptys_ext_supported(mdev);
 	err = mlx5_port_query_eth_proto(mdev, 1, ext, &eproto);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
index a2ddd446dd59e..7a7defe607926 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
@@ -54,7 +54,7 @@ int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
 int mlx5e_port_max_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
 u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed,
 			       bool force_legacy);
-
+bool mlx5e_ptys_ext_supported(struct mlx5_core_dev *mdev);
 int mlx5e_port_query_pbmc(struct mlx5_core_dev *mdev, void *out);
 int mlx5e_port_set_pbmc(struct mlx5_core_dev *mdev, void *in);
 int mlx5e_port_query_priority2buffer(struct mlx5_core_dev *mdev, u8 *buffer);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index bc290ae80a531..1c491acd48f32 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -200,7 +200,7 @@ static void mlx5e_ethtool_get_speed_arr(struct mlx5_core_dev *mdev,
 					struct ptys2ethtool_config **arr,
 					u32 *size)
 {
-	bool ext = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	bool ext = mlx5e_ptys_ext_supported(mdev);
 
 	*arr = ext ? ptys2ext_ethtool_table : ptys2legacy_ethtool_table;
 	*size = ext ? ARRAY_SIZE(ptys2ext_ethtool_table) :
@@ -883,7 +883,7 @@ static void get_lp_advertising(struct mlx5_core_dev *mdev, u32 eth_proto_lp,
 			       struct ethtool_link_ksettings *link_ksettings)
 {
 	unsigned long *lp_advertising = link_ksettings->link_modes.lp_advertising;
-	bool ext = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	bool ext = mlx5e_ptys_ext_supported(mdev);
 
 	ptys2ethtool_adver_link(lp_advertising, eth_proto_lp, ext);
 }
@@ -913,7 +913,7 @@ int mlx5e_ethtool_get_link_ksettings(struct mlx5e_priv *priv,
 			   __func__, err);
 		goto err_query_regs;
 	}
-	ext = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	ext = !!MLX5_GET_ETH_PROTO(ptys_reg, out, true, eth_proto_capability);
 	eth_proto_cap    = MLX5_GET_ETH_PROTO(ptys_reg, out, ext,
 					      eth_proto_capability);
 	eth_proto_admin  = MLX5_GET_ETH_PROTO(ptys_reg, out, ext,
@@ -1066,7 +1066,7 @@ int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 	autoneg = link_ksettings->base.autoneg;
 	speed = link_ksettings->base.speed;
 
-	ext_supported = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	ext_supported = mlx5e_ptys_ext_supported(mdev);
 	ext = ext_requested(autoneg, adver, ext_supported);
 	if (!ext_supported && ext)
 		return -EOPNOTSUPP;
-- 
2.25.1



