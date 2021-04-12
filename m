Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F68535C061
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238958AbhDLJNF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:60966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240238AbhDLJKH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:10:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E381061386;
        Mon, 12 Apr 2021 09:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218296;
        bh=8W7i6D/xr8S/QPe2JElxfNaYlPRN3nB1NO+xxOAzBX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QD+j7ZDTKHVUtXU4STpPAeLRuPQpPVqXkB2XZBUVxnesq2J9B22y/I2gYGMd5bUUk
         bi5pLF9HWu0e/7vVPYzONNclV5uI7BN5oqzgF/vqugyFTqKMuGUzW11/oC9SHkMy9i
         0Pbi3XW1J99cPj1kWTTm/e/KOzKfwjyWb6SNFC9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Eran Ben Elisha <eranbe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 145/210] net/mlx5e: Fix ethtool indication of connector type
Date:   Mon, 12 Apr 2021 10:40:50 +0200
Message-Id: <20210412084020.823825909@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 3211434dfe7a66fcf55e43961ea524b78336c04c ]

Use connector_type read from PTYS register when it's valid, based on
corresponding capability bit.

Fixes: 5b4793f81745 ("net/mlx5e: Add support for reading connector type from PTYS")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en_ethtool.c  | 22 +++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index c9d01e705ab2..d3d532fdf04e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -747,11 +747,11 @@ static int get_fec_supported_advertised(struct mlx5_core_dev *dev,
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
@@ -887,9 +887,9 @@ static int ptys2connector_type[MLX5E_CONNECTOR_TYPE_NUMBER] = {
 		[MLX5E_PORT_OTHER]              = PORT_OTHER,
 	};
 
-static u8 get_connector_port(u32 eth_proto, u8 connector_type, bool ext)
+static u8 get_connector_port(struct mlx5_core_dev *mdev, u32 eth_proto, u8 connector_type)
 {
-	if ((connector_type || ext) && connector_type < MLX5E_CONNECTOR_TYPE_NUMBER)
+	if (MLX5_CAP_PCAM_FEATURE(mdev, ptys_connector_type))
 		return ptys2connector_type[connector_type];
 
 	if (eth_proto &
@@ -990,11 +990,11 @@ int mlx5e_ethtool_get_link_ksettings(struct mlx5e_priv *priv,
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



