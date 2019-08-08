Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0641E8697B
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:07:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404756AbfHHTHu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:07:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41690 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404355AbfHHTHu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:07:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17DC321882;
        Thu,  8 Aug 2019 19:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291269;
        bh=vwITCSGikeICWvUzt5e1E3wwo+vGJLDOMpFwh8ucRrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iA/Zm8qF2fkGwgWjs3NOybZFe1QGY3+ew1x1NRNCKW27rZVG157Mt/chw+6Ukf4SK
         E3sPOLRD0W3P3RY2C0WNiACrrl/a151d4pFr6wOYxari7fdHezICVxichj9gennY43
         Sd3By1QRILqZ2YikQ3OecyfuV3XPCnUmg/lKeNiM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH 5.2 52/56] net/mlx5e: Fix matching of speed to PRM link modes
Date:   Thu,  8 Aug 2019 21:05:18 +0200
Message-Id: <20190808190455.347243359@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190452.867062037@linuxfoundation.org>
References: <20190808190452.867062037@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

[ Upstream commit 4b95840a6ced0634082f6d962ba9aa0ce797f12f ]

Speed translation is performed based on legacy or extended PTYS
register. Translate speed with respect to:
1) Capability bit of extended PTYS table.
2) User request:
 a) When auto-negotiation is turned on, inspect advertisement whether it
 contains extended link modes.
 b) When auto-negotiation is turned off, speed > 100Gbps (maximal
 speed supported in legacy mode).
With both conditions fulfilled translation is done with extended PTYS
table otherwise use legacy PTYS table.
Without this patch 25/50/100 Gbps speed cannot be set, since try to
configure in extended mode but read from legacy mode.

Fixes: dd1b9e09c12b ("net/mlx5: ethtool, Allow legacy link-modes configuration via non-extended ptys")
Signed-off-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c    |   27 +++++--
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h    |    6 +
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c |   67 +++++++++++++------
 3 files changed, 68 insertions(+), 32 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.c
@@ -78,9 +78,10 @@ static const u32 mlx5e_ext_link_speed[ML
 };
 
 static void mlx5e_port_get_speed_arr(struct mlx5_core_dev *mdev,
-				     const u32 **arr, u32 *size)
+				     const u32 **arr, u32 *size,
+				     bool force_legacy)
 {
-	bool ext = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
+	bool ext = force_legacy ? false : MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
 
 	*size = ext ? ARRAY_SIZE(mlx5e_ext_link_speed) :
 		      ARRAY_SIZE(mlx5e_link_speed);
@@ -152,7 +153,8 @@ int mlx5_port_set_eth_ptys(struct mlx5_c
 			    sizeof(out), MLX5_REG_PTYS, 0, 1);
 }
 
-u32 mlx5e_port_ptys2speed(struct mlx5_core_dev *mdev, u32 eth_proto_oper)
+u32 mlx5e_port_ptys2speed(struct mlx5_core_dev *mdev, u32 eth_proto_oper,
+			  bool force_legacy)
 {
 	unsigned long temp = eth_proto_oper;
 	const u32 *table;
@@ -160,7 +162,7 @@ u32 mlx5e_port_ptys2speed(struct mlx5_co
 	u32 max_size;
 	int i;
 
-	mlx5e_port_get_speed_arr(mdev, &table, &max_size);
+	mlx5e_port_get_speed_arr(mdev, &table, &max_size, force_legacy);
 	i = find_first_bit(&temp, max_size);
 	if (i < max_size)
 		speed = table[i];
@@ -170,6 +172,7 @@ u32 mlx5e_port_ptys2speed(struct mlx5_co
 int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed)
 {
 	struct mlx5e_port_eth_proto eproto;
+	bool force_legacy = false;
 	bool ext;
 	int err;
 
@@ -177,8 +180,13 @@ int mlx5e_port_linkspeed(struct mlx5_cor
 	err = mlx5_port_query_eth_proto(mdev, 1, ext, &eproto);
 	if (err)
 		goto out;
-
-	*speed = mlx5e_port_ptys2speed(mdev, eproto.oper);
+	if (ext && !eproto.admin) {
+		force_legacy = true;
+		err = mlx5_port_query_eth_proto(mdev, 1, false, &eproto);
+		if (err)
+			goto out;
+	}
+	*speed = mlx5e_port_ptys2speed(mdev, eproto.oper, force_legacy);
 	if (!(*speed))
 		err = -EINVAL;
 
@@ -201,7 +209,7 @@ int mlx5e_port_max_linkspeed(struct mlx5
 	if (err)
 		return err;
 
-	mlx5e_port_get_speed_arr(mdev, &table, &max_size);
+	mlx5e_port_get_speed_arr(mdev, &table, &max_size, false);
 	for (i = 0; i < max_size; ++i)
 		if (eproto.cap & MLX5E_PROT_MASK(i))
 			max_speed = max(max_speed, table[i]);
@@ -210,14 +218,15 @@ int mlx5e_port_max_linkspeed(struct mlx5
 	return 0;
 }
 
-u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed)
+u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed,
+			       bool force_legacy)
 {
 	u32 link_modes = 0;
 	const u32 *table;
 	u32 max_size;
 	int i;
 
-	mlx5e_port_get_speed_arr(mdev, &table, &max_size);
+	mlx5e_port_get_speed_arr(mdev, &table, &max_size, force_legacy);
 	for (i = 0; i < max_size; ++i) {
 		if (table[i] == speed)
 			link_modes |= MLX5E_PROT_MASK(i);
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/port.h
@@ -48,10 +48,12 @@ void mlx5_port_query_eth_autoneg(struct
 				 u8 *an_disable_cap, u8 *an_disable_admin);
 int mlx5_port_set_eth_ptys(struct mlx5_core_dev *dev, bool an_disable,
 			   u32 proto_admin, bool ext);
-u32 mlx5e_port_ptys2speed(struct mlx5_core_dev *mdev, u32 eth_proto_oper);
+u32 mlx5e_port_ptys2speed(struct mlx5_core_dev *mdev, u32 eth_proto_oper,
+			  bool force_legacy);
 int mlx5e_port_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
 int mlx5e_port_max_linkspeed(struct mlx5_core_dev *mdev, u32 *speed);
-u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed);
+u32 mlx5e_port_speed2linkmodes(struct mlx5_core_dev *mdev, u32 speed,
+			       bool force_legacy);
 
 int mlx5e_port_query_pbmc(struct mlx5_core_dev *mdev, void *out);
 int mlx5e_port_set_pbmc(struct mlx5_core_dev *mdev, void *in);
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -764,7 +764,7 @@ static void ptys2ethtool_supported_adver
 }
 
 static void get_speed_duplex(struct net_device *netdev,
-			     u32 eth_proto_oper,
+			     u32 eth_proto_oper, bool force_legacy,
 			     struct ethtool_link_ksettings *link_ksettings)
 {
 	struct mlx5e_priv *priv = netdev_priv(netdev);
@@ -774,7 +774,7 @@ static void get_speed_duplex(struct net_
 	if (!netif_carrier_ok(netdev))
 		goto out;
 
-	speed = mlx5e_port_ptys2speed(priv->mdev, eth_proto_oper);
+	speed = mlx5e_port_ptys2speed(priv->mdev, eth_proto_oper, force_legacy);
 	if (!speed) {
 		speed = SPEED_UNKNOWN;
 		goto out;
@@ -893,8 +893,8 @@ int mlx5e_ethtool_get_link_ksettings(str
 	/* Fields: eth_proto_admin and ext_eth_proto_admin  are
 	 * mutually exclusive. Hence try reading legacy advertising
 	 * when extended advertising is zero.
-	 * admin_ext indicates how eth_proto_admin should be
-	 * interpreted
+	 * admin_ext indicates which proto_admin (ext vs. legacy)
+	 * should be read and interpreted
 	 */
 	admin_ext = ext;
 	if (ext && !eth_proto_admin) {
@@ -903,7 +903,7 @@ int mlx5e_ethtool_get_link_ksettings(str
 		admin_ext = false;
 	}
 
-	eth_proto_oper   = MLX5_GET_ETH_PROTO(ptys_reg, out, ext,
+	eth_proto_oper   = MLX5_GET_ETH_PROTO(ptys_reg, out, admin_ext,
 					      eth_proto_oper);
 	eth_proto_lp	    = MLX5_GET(ptys_reg, out, eth_proto_lp_advertise);
 	an_disable_admin    = MLX5_GET(ptys_reg, out, an_disable_admin);
@@ -918,7 +918,8 @@ int mlx5e_ethtool_get_link_ksettings(str
 	get_supported(mdev, eth_proto_cap, link_ksettings);
 	get_advertising(eth_proto_admin, tx_pause, rx_pause, link_ksettings,
 			admin_ext);
-	get_speed_duplex(priv->netdev, eth_proto_oper, link_ksettings);
+	get_speed_duplex(priv->netdev, eth_proto_oper, !admin_ext,
+			 link_ksettings);
 
 	eth_proto_oper = eth_proto_oper ? eth_proto_oper : eth_proto_cap;
 
@@ -995,45 +996,69 @@ static u32 mlx5e_ethtool2ptys_ext_adver_
 	return ptys_modes;
 }
 
+static bool ext_link_mode_requested(const unsigned long *adver)
+{
+#define MLX5E_MIN_PTYS_EXT_LINK_MODE_BIT ETHTOOL_LINK_MODE_50000baseKR_Full_BIT
+	int size = __ETHTOOL_LINK_MODE_MASK_NBITS - MLX5E_MIN_PTYS_EXT_LINK_MODE_BIT;
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(modes);
+
+	bitmap_set(modes, MLX5E_MIN_PTYS_EXT_LINK_MODE_BIT, size);
+	return bitmap_intersects(modes, adver, __ETHTOOL_LINK_MODE_MASK_NBITS);
+}
+
+static bool ext_speed_requested(u32 speed)
+{
+#define MLX5E_MAX_PTYS_LEGACY_SPEED 100000
+	return !!(speed > MLX5E_MAX_PTYS_LEGACY_SPEED);
+}
+
+static bool ext_requested(u8 autoneg, const unsigned long *adver, u32 speed)
+{
+	bool ext_link_mode = ext_link_mode_requested(adver);
+	bool ext_speed = ext_speed_requested(speed);
+
+	return  autoneg == AUTONEG_ENABLE ? ext_link_mode : ext_speed;
+}
+
 int mlx5e_ethtool_set_link_ksettings(struct mlx5e_priv *priv,
 				     const struct ethtool_link_ksettings *link_ksettings)
 {
 	struct mlx5_core_dev *mdev = priv->mdev;
 	struct mlx5e_port_eth_proto eproto;
+	const unsigned long *adver;
 	bool an_changes = false;
 	u8 an_disable_admin;
 	bool ext_supported;
-	bool ext_requested;
 	u8 an_disable_cap;
 	bool an_disable;
 	u32 link_modes;
 	u8 an_status;
+	u8 autoneg;
 	u32 speed;
+	bool ext;
 	int err;
 
 	u32 (*ethtool2ptys_adver_func)(const unsigned long *adver);
 
-#define MLX5E_PTYS_EXT ((1ULL << ETHTOOL_LINK_MODE_50000baseKR_Full_BIT) - 1)
+	adver = link_ksettings->link_modes.advertising;
+	autoneg = link_ksettings->base.autoneg;
+	speed = link_ksettings->base.speed;
 
-	ext_requested = !!(link_ksettings->link_modes.advertising[0] >
-			MLX5E_PTYS_EXT ||
-			link_ksettings->link_modes.advertising[1]);
+	ext = ext_requested(autoneg, adver, speed),
 	ext_supported = MLX5_CAP_PCAM_FEATURE(mdev, ptys_extended_ethernet);
-	ext_requested &= ext_supported;
+	if (!ext_supported && ext)
+		return -EOPNOTSUPP;
 
-	speed = link_ksettings->base.speed;
-	ethtool2ptys_adver_func = ext_requested ?
-				  mlx5e_ethtool2ptys_ext_adver_link :
+	ethtool2ptys_adver_func = ext ? mlx5e_ethtool2ptys_ext_adver_link :
 				  mlx5e_ethtool2ptys_adver_link;
-	err = mlx5_port_query_eth_proto(mdev, 1, ext_requested, &eproto);
+	err = mlx5_port_query_eth_proto(mdev, 1, ext, &eproto);
 	if (err) {
 		netdev_err(priv->netdev, "%s: query port eth proto failed: %d\n",
 			   __func__, err);
 		goto out;
 	}
-	link_modes = link_ksettings->base.autoneg == AUTONEG_ENABLE ?
-		ethtool2ptys_adver_func(link_ksettings->link_modes.advertising) :
-		mlx5e_port_speed2linkmodes(mdev, speed);
+	link_modes = autoneg == AUTONEG_ENABLE ? ethtool2ptys_adver_func(adver) :
+		mlx5e_port_speed2linkmodes(mdev, speed, !ext);
 
 	link_modes = link_modes & eproto.cap;
 	if (!link_modes) {
@@ -1046,14 +1071,14 @@ int mlx5e_ethtool_set_link_ksettings(str
 	mlx5_port_query_eth_autoneg(mdev, &an_status, &an_disable_cap,
 				    &an_disable_admin);
 
-	an_disable = link_ksettings->base.autoneg == AUTONEG_DISABLE;
+	an_disable = autoneg == AUTONEG_DISABLE;
 	an_changes = ((!an_disable && an_disable_admin) ||
 		      (an_disable && !an_disable_admin));
 
 	if (!an_changes && link_modes == eproto.admin)
 		goto out;
 
-	mlx5_port_set_eth_ptys(mdev, an_disable, link_modes, ext_requested);
+	mlx5_port_set_eth_ptys(mdev, an_disable, link_modes, ext);
 	mlx5_toggle_port_link(mdev);
 
 out:


