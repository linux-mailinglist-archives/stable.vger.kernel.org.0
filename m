Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00953AEE44
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231904AbhFUQ1a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232225AbhFUQZn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:25:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 76CA561374;
        Mon, 21 Jun 2021 16:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624292523;
        bh=Q+1jE1a5er5K2kQlP9wwCFdQ9LzihHf/tQUtOFDYV6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pjj+11f1UyVycymDksV5m/sSNwOTHRmJZp3semCxz8+VtiB+sjtBeCzAMUYJT9nRb
         2IcFL07Qb+crhcghtzwZg1SGFbyM4kCj7WyNUymc1es3jAeeaKtTTe08/kTCVAQ5tp
         JfbkdTMlsz0vYc4VdPxGiqndD3l6RyfzcEALcwrE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Vesker <valex@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/146] net/mlx5: DR, Allow SW steering for sw_owner_v2 devices
Date:   Mon, 21 Jun 2021 18:14:21 +0200
Message-Id: <20210621154912.341008053@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154911.244649123@linuxfoundation.org>
References: <20210621154911.244649123@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 64f45c0fc4c71f577506c5a7a7956ae3bc3388ea ]

Allow sw_owner_v2 based on sw_format_version.

Signed-off-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/dr_cmd.c        | 17 +++++++++++------
 .../mellanox/mlx5/core/steering/dr_domain.c     | 17 +++++++++--------
 .../mellanox/mlx5/core/steering/dr_types.h      |  6 +++++-
 .../mellanox/mlx5/core/steering/mlx5dr.h        |  5 ++++-
 4 files changed, 29 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
index 51bbd88ff021..fd56cae0d54f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_cmd.c
@@ -78,9 +78,9 @@ int mlx5dr_cmd_query_esw_caps(struct mlx5_core_dev *mdev,
 	caps->uplink_icm_address_tx =
 		MLX5_CAP64_ESW_FLOWTABLE(mdev,
 					 sw_steering_uplink_icm_address_tx);
-	caps->sw_owner =
-		MLX5_CAP_ESW_FLOWTABLE_FDB(mdev,
-					   sw_owner);
+	caps->sw_owner_v2 = MLX5_CAP_ESW_FLOWTABLE_FDB(mdev, sw_owner_v2);
+	if (!caps->sw_owner_v2)
+		caps->sw_owner = MLX5_CAP_ESW_FLOWTABLE_FDB(mdev, sw_owner);
 
 	return 0;
 }
@@ -113,10 +113,15 @@ int mlx5dr_cmd_query_device(struct mlx5_core_dev *mdev,
 	caps->nic_tx_allow_address =
 		MLX5_CAP64_FLOWTABLE(mdev, sw_steering_nic_tx_action_allow_icm_address);
 
-	caps->rx_sw_owner = MLX5_CAP_FLOWTABLE_NIC_RX(mdev, sw_owner);
-	caps->max_ft_level = MLX5_CAP_FLOWTABLE_NIC_RX(mdev, max_ft_level);
+	caps->rx_sw_owner_v2 = MLX5_CAP_FLOWTABLE_NIC_RX(mdev, sw_owner_v2);
+	caps->tx_sw_owner_v2 = MLX5_CAP_FLOWTABLE_NIC_TX(mdev, sw_owner_v2);
+
+	if (!caps->rx_sw_owner_v2)
+		caps->rx_sw_owner = MLX5_CAP_FLOWTABLE_NIC_RX(mdev, sw_owner);
+	if (!caps->tx_sw_owner_v2)
+		caps->tx_sw_owner = MLX5_CAP_FLOWTABLE_NIC_TX(mdev, sw_owner);
 
-	caps->tx_sw_owner = MLX5_CAP_FLOWTABLE_NIC_TX(mdev, sw_owner);
+	caps->max_ft_level = MLX5_CAP_FLOWTABLE_NIC_RX(mdev, max_ft_level);
 
 	caps->log_icm_size = MLX5_CAP_DEV_MEM(mdev, log_steering_sw_icm_size);
 	caps->hdr_modify_icm_addr =
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
index aa2c2d6c44e6..00d861361428 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_domain.c
@@ -4,6 +4,11 @@
 #include <linux/mlx5/eswitch.h>
 #include "dr_types.h"
 
+#define DR_DOMAIN_SW_STEERING_SUPPORTED(dmn, dmn_type)	\
+	((dmn)->info.caps.dmn_type##_sw_owner ||	\
+	 ((dmn)->info.caps.dmn_type##_sw_owner_v2 &&	\
+	  (dmn)->info.caps.sw_format_ver <= MLX5_STEERING_FORMAT_CONNECTX_6DX))
+
 static int dr_domain_init_cache(struct mlx5dr_domain *dmn)
 {
 	/* Per vport cached FW FT for checksum recalculation, this
@@ -181,6 +186,7 @@ static int dr_domain_query_fdb_caps(struct mlx5_core_dev *mdev,
 		return ret;
 
 	dmn->info.caps.fdb_sw_owner = dmn->info.caps.esw_caps.sw_owner;
+	dmn->info.caps.fdb_sw_owner_v2 = dmn->info.caps.esw_caps.sw_owner_v2;
 	dmn->info.caps.esw_rx_drop_address = dmn->info.caps.esw_caps.drop_icm_address_rx;
 	dmn->info.caps.esw_tx_drop_address = dmn->info.caps.esw_caps.drop_icm_address_tx;
 
@@ -223,18 +229,13 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 	if (ret)
 		return ret;
 
-	if (dmn->info.caps.sw_format_ver != MLX5_STEERING_FORMAT_CONNECTX_5) {
-		mlx5dr_err(dmn, "SW steering is not supported on this device\n");
-		return -EOPNOTSUPP;
-	}
-
 	ret = dr_domain_query_fdb_caps(mdev, dmn);
 	if (ret)
 		return ret;
 
 	switch (dmn->type) {
 	case MLX5DR_DOMAIN_TYPE_NIC_RX:
-		if (!dmn->info.caps.rx_sw_owner)
+		if (!DR_DOMAIN_SW_STEERING_SUPPORTED(dmn, rx))
 			return -ENOTSUPP;
 
 		dmn->info.supp_sw_steering = true;
@@ -243,7 +244,7 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 		dmn->info.rx.drop_icm_addr = dmn->info.caps.nic_rx_drop_address;
 		break;
 	case MLX5DR_DOMAIN_TYPE_NIC_TX:
-		if (!dmn->info.caps.tx_sw_owner)
+		if (!DR_DOMAIN_SW_STEERING_SUPPORTED(dmn, tx))
 			return -ENOTSUPP;
 
 		dmn->info.supp_sw_steering = true;
@@ -255,7 +256,7 @@ static int dr_domain_caps_init(struct mlx5_core_dev *mdev,
 		if (!dmn->info.caps.eswitch_manager)
 			return -ENOTSUPP;
 
-		if (!dmn->info.caps.fdb_sw_owner)
+		if (!DR_DOMAIN_SW_STEERING_SUPPORTED(dmn, fdb))
 			return -ENOTSUPP;
 
 		dmn->info.rx.ste_type = MLX5DR_STE_TYPE_RX;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index cf62ea4f882e..42c49f09e9d3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -597,7 +597,8 @@ struct mlx5dr_esw_caps {
 	u64 drop_icm_address_tx;
 	u64 uplink_icm_address_rx;
 	u64 uplink_icm_address_tx;
-	bool sw_owner;
+	u8 sw_owner:1;
+	u8 sw_owner_v2:1;
 };
 
 struct mlx5dr_cmd_vport_cap {
@@ -630,6 +631,9 @@ struct mlx5dr_cmd_caps {
 	bool rx_sw_owner;
 	bool tx_sw_owner;
 	bool fdb_sw_owner;
+	u8 rx_sw_owner_v2:1;
+	u8 tx_sw_owner_v2:1;
+	u8 fdb_sw_owner_v2:1;
 	u32 num_vports;
 	struct mlx5dr_esw_caps esw_caps;
 	struct mlx5dr_cmd_vport_cap *vports_caps;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
index 7914fe3fc68d..6f3db8dc896c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/mlx5dr.h
@@ -124,7 +124,10 @@ int mlx5dr_action_destroy(struct mlx5dr_action *action);
 static inline bool
 mlx5dr_is_supported(struct mlx5_core_dev *dev)
 {
-	return MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner);
+	return MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner) ||
+	       (MLX5_CAP_ESW_FLOWTABLE_FDB(dev, sw_owner_v2) &&
+		(MLX5_CAP_GEN(dev, steering_format_version) <=
+		 MLX5_STEERING_FORMAT_CONNECTX_6DX));
 }
 
 #endif /* _MLX5DR_H_ */
-- 
2.30.2



