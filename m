Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E4C2A165B
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgJaLor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:45132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727471AbgJaLom (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:44:42 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A166020731;
        Sat, 31 Oct 2020 11:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144681;
        bh=67gyHFeMZTf7C/B1c78ETD2a4WD6TaLMhFQLFx5ZOk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t7lh+ciKpVLLG9wiOcr8trsdkD+8U6XxaOBD0FDLGvmxK2gBdj0N8BVhMQP5lsTjD
         kvMbgtDnZk9+26mm3rCYXUTt1Z8hPsDBnZ0RynwEeJp9OtN46qE9+Oh4F3rujIuAgf
         hzrj40B/zTGABb1SshM7vsxUxDroyke0Ndl0cAUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Amit Cohen <amcohen@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 40/74] mlxsw: Only advertise link modes supported by both driver and device
Date:   Sat, 31 Oct 2020 12:36:22 +0100
Message-Id: <20201031113501.964777551@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit 1601559be3e4213148b4cb4a1abe672b00bf4f67 ]

During port creation the driver instructs the device to advertise all
the supported link modes queried from the device.

Since cited commit not all the link modes supported by the device are
supported by the driver. This can result in the device negotiating a
link mode that is not recognized by the driver causing ethtool to show
an unsupported speed:

$ ethtool swp1
...
Speed: Unknown!

This is especially problematic when the netdev is enslaved to a bond, as
the bond driver uses unknown speed as an indication that the link is
down:

[13048.900895] net_ratelimit: 86 callbacks suppressed
[13048.900902] t_bond0: (slave swp52): failed to get link speed/duplex
[13048.912160] t_bond0: (slave swp49): failed to get link speed/duplex

Fix this by making sure that only link modes that are supported by both
the device and the driver are advertised.

Fixes: b97cd891268d ("mlxsw: Remove 56G speed support")
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c         |    9 +++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h         |    1 
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c |   30 +++++++++++++++++
 3 files changed, 38 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1546,11 +1546,14 @@ mlxsw_sp_port_speed_by_width_set(struct
 	u32 eth_proto_cap, eth_proto_admin, eth_proto_oper;
 	const struct mlxsw_sp_port_type_speed_ops *ops;
 	char ptys_pl[MLXSW_REG_PTYS_LEN];
+	u32 eth_proto_cap_masked;
 	int err;
 
 	ops = mlxsw_sp->port_type_speed_ops;
 
-	/* Set advertised speeds to supported speeds. */
+	/* Set advertised speeds to speeds supported by both the driver
+	 * and the device.
+	 */
 	ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl, mlxsw_sp_port->local_port,
 			       0, false);
 	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
@@ -1559,8 +1562,10 @@ mlxsw_sp_port_speed_by_width_set(struct
 
 	ops->reg_ptys_eth_unpack(mlxsw_sp, ptys_pl, &eth_proto_cap,
 				 &eth_proto_admin, &eth_proto_oper);
+	eth_proto_cap_masked = ops->ptys_proto_cap_masked_get(eth_proto_cap);
 	ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl, mlxsw_sp_port->local_port,
-			       eth_proto_cap, mlxsw_sp_port->link.autoneg);
+			       eth_proto_cap_masked,
+			       mlxsw_sp_port->link.autoneg);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
 }
 
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -340,6 +340,7 @@ struct mlxsw_sp_port_type_speed_ops {
 				    u32 *p_eth_proto_cap,
 				    u32 *p_eth_proto_admin,
 				    u32 *p_eth_proto_oper);
+	u32 (*ptys_proto_cap_masked_get)(u32 eth_proto_cap);
 };
 
 static inline struct net_device *
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -1208,6 +1208,20 @@ mlxsw_sp1_reg_ptys_eth_unpack(struct mlx
 				  p_eth_proto_oper);
 }
 
+static u32 mlxsw_sp1_ptys_proto_cap_masked_get(u32 eth_proto_cap)
+{
+	u32 ptys_proto_cap_masked = 0;
+	int i;
+
+	for (i = 0; i < MLXSW_SP1_PORT_LINK_MODE_LEN; i++) {
+		if (mlxsw_sp1_port_link_mode[i].mask & eth_proto_cap)
+			ptys_proto_cap_masked |=
+				mlxsw_sp1_port_link_mode[i].mask;
+	}
+
+	return ptys_proto_cap_masked;
+}
+
 const struct mlxsw_sp_port_type_speed_ops mlxsw_sp1_port_type_speed_ops = {
 	.from_ptys_supported_port	= mlxsw_sp1_from_ptys_supported_port,
 	.from_ptys_link			= mlxsw_sp1_from_ptys_link,
@@ -1217,6 +1231,7 @@ const struct mlxsw_sp_port_type_speed_op
 	.to_ptys_speed			= mlxsw_sp1_to_ptys_speed,
 	.reg_ptys_eth_pack		= mlxsw_sp1_reg_ptys_eth_pack,
 	.reg_ptys_eth_unpack		= mlxsw_sp1_reg_ptys_eth_unpack,
+	.ptys_proto_cap_masked_get	= mlxsw_sp1_ptys_proto_cap_masked_get,
 };
 
 static const enum ethtool_link_mode_bit_indices
@@ -1632,6 +1647,20 @@ mlxsw_sp2_reg_ptys_eth_unpack(struct mlx
 				      p_eth_proto_admin, p_eth_proto_oper);
 }
 
+static u32 mlxsw_sp2_ptys_proto_cap_masked_get(u32 eth_proto_cap)
+{
+	u32 ptys_proto_cap_masked = 0;
+	int i;
+
+	for (i = 0; i < MLXSW_SP2_PORT_LINK_MODE_LEN; i++) {
+		if (mlxsw_sp2_port_link_mode[i].mask & eth_proto_cap)
+			ptys_proto_cap_masked |=
+				mlxsw_sp2_port_link_mode[i].mask;
+	}
+
+	return ptys_proto_cap_masked;
+}
+
 const struct mlxsw_sp_port_type_speed_ops mlxsw_sp2_port_type_speed_ops = {
 	.from_ptys_supported_port	= mlxsw_sp2_from_ptys_supported_port,
 	.from_ptys_link			= mlxsw_sp2_from_ptys_link,
@@ -1641,4 +1670,5 @@ const struct mlxsw_sp_port_type_speed_op
 	.to_ptys_speed			= mlxsw_sp2_to_ptys_speed,
 	.reg_ptys_eth_pack		= mlxsw_sp2_reg_ptys_eth_pack,
 	.reg_ptys_eth_unpack		= mlxsw_sp2_reg_ptys_eth_unpack,
+	.ptys_proto_cap_masked_get	= mlxsw_sp2_ptys_proto_cap_masked_get,
 };


