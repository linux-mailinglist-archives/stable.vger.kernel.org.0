Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B25535B893
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 04:23:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236620AbhDLCXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Apr 2021 22:23:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236622AbhDLCXl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 11 Apr 2021 22:23:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 082DB6121E;
        Mon, 12 Apr 2021 02:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618194204;
        bh=4/UB0xUA97yUQVo3fhilkcnWQua6jO3dnvNhQwU+1dA=;
        h=From:To:Cc:Subject:Date:From;
        b=YiHuI/oYvBTPjZFpaZiFXQlPeIY/8pkeA6NtDHhvN2GnlvZxWZMmQPF25xcbQM3Vx
         i28OcWWzMQIs2pAV47cVZbK/HPQ6Z4NSYug6JwoZEgrUP3O9qiDYCobp4x5TVrdCK2
         iAPBpE6zLNFyueJ48CfBJmwkXBCjzfNWxgmol/m/12SNcXCszhKuD4XR78TBL4b00F
         Qn1itNxtL7o6ZWwkJqWs4ZF4kbA8uRYaCePnBpsK6zdaaTJCf7mtcwOpMsim8RrQPA
         VR4+FR/7/W/gsA9jkS9zkTYcipgeuwW6Or7Ciu4peoKdrLRlBjv6rdq9PpDPJOrEzc
         8JFvYXQOfPiaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     stable@vger.kernel.org, ayal@nvidia.com
Cc:     Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: FAILED: Patch "net/mlx5e: Fix ethtool indication of connector type" failed to apply to 4.14-stable tree
Date:   Sun, 11 Apr 2021 22:23:22 -0400
Message-Id: <20210412022322.284316-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch below does not apply to the 4.14-stable tree.
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




