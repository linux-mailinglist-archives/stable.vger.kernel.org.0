Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D128535B88D
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236616AbhDLCXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236615AbhDLCX2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F380461209;
        Mon, 12 Apr 2021 02:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194191;
        bh=m/g0EQL2vGBeV5uuWtjZnWgOiu3V68tjjCsvmbjFu+o=;
        h=From:To:Cc:Subject:Date:From;
        b=KGDKL1mkLyU9EQLDMN6JOqAC/xMCPLpkpA9gdNZnKxkF3p3FjHGJvg9HY8v8ps5DR
         NQG2A7+rVT0Ez0tjAgqV7rRsJ7SNvf6XeqpNN5B7Q8gHt3iMeXt2x2FPxwwzuc7rcz
         KlTOs+lqleInRHV6GxJgxbEe025vanevtPOaORuJjrK4/5VOPWhQIeXMiPXOZec6Ee
         KAdm6OtsI7iguZ1PU9YFWy5KjI7Nsblmsj5r8zldwf7iqNVoZ9ei79/qeJNkR7CFGO
         +NXG6eqTtwanEVH4HbsaVPMsqcAlczcx38nXn46TOsqUBbe10U7Dmr+X6+2WqCBwib
         PrQgxB2MtA6vg==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, ayal@nvidia.com
Cc:     Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: FAILED: Patch "net/mlx5e: Fix ethtool indication of connector type" failed to apply to 4.19-stable tree
Date:   Sun, 11 Apr 2021 22:23:09 -0400
Message-Id: <20210412022309.283897-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 3211434dfe7a66fcf55e43961ea524b78336c04c Mon Sep 17 00:00:00 2001
From: Aya Levin <ayal@nvidia.com>
Date: Wed, 24 Mar 2021 12:25:06 +0200
Subject: [PATCH] net/mlx5e: Fix ethtool indication of connector type

Use connector_type read from PTYS register when it's valid, based on
corresponding capability bit.

Fixes: 5b4793f81745 ("net/mlx5e: Add support for reading connector type from PTYS")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index f5f2a8fd0046..53802e18af90 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -758,11 +758,11 @@ static int get_fec_supported_advertised(struct mlx5_core_dev *dev,
 	return 0;
 }
 
-static void ptys2ethtool_supported_advertised_port(struct ethtool_link_ksettings *link_ksettings,
-						   u32 eth_proto_cap,
-						   u8 connector_type, bool ext)
+static void ptys2ethtool_supported_advertised_port(struct mlx5_core_dev *mdev,
+						   struct ethtool_link_ksettings *link_ksettings,
+						   u32 eth_proto_cap, u8 connector_type)
 {
-	if ((!connector_type && !ext) || connector_type >= MLX5E_CONNECTOR_TYPE_NUMBER) {
+	if (!MLX5_CAP_PCAM_FEATURE(mdev, ptys_connector_type)) {
 		if (eth_proto_cap & (MLX5E_PROT_MASK(MLX5E_10GBASE_CR)
 				   | MLX5E_PROT_MASK(MLX5E_10GBASE_SR)
 				   | MLX5E_PROT_MASK(MLX5E_40GBASE_CR4)
@@ -898,9 +898,9 @@ static int ptys2connector_type[MLX5E_CONNECTOR_TYPE_NUMBER] = {
 		[MLX5E_PORT_OTHER]              = PORT_OTHER,
 	};
 
-static u8 get_connector_port(u32 eth_proto, u8 connector_type, bool ext)
+static u8 get_connector_port(struct mlx5_core_dev *mdev, u32 eth_proto, u8 connector_type)
 {
-	if ((connector_type || ext) && connector_type < MLX5E_CONNECTOR_TYPE_NUMBER)
+	if (MLX5_CAP_PCAM_FEATURE(mdev, ptys_connector_type))
 		return ptys2connector_type[connector_type];
 
 	if (eth_proto &
@@ -1001,11 +1001,11 @@ int mlx5e_ethtool_get_link_ksettings(struct mlx5e_priv *priv,
 			 data_rate_oper, link_ksettings);
 
 	eth_proto_oper = eth_proto_oper ? eth_proto_oper : eth_proto_cap;
-
-	link_ksettings->base.port = get_connector_port(eth_proto_oper,
-						       connector_type, ext);
-	ptys2ethtool_supported_advertised_port(link_ksettings, eth_proto_admin,
-					       connector_type, ext);
+	connector_type = connector_type < MLX5E_CONNECTOR_TYPE_NUMBER ?
+			 connector_type : MLX5E_PORT_UNKNOWN;
+	link_ksettings->base.port = get_connector_port(mdev, eth_proto_oper, connector_type);
+	ptys2ethtool_supported_advertised_port(mdev, link_ksettings, eth_proto_admin,
+					       connector_type);
 	get_lp_advertising(mdev, eth_proto_lp, link_ksettings);
 
 	if (an_status == MLX5_AN_COMPLETE)
-- 
2.30.2




