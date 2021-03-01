Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8F4B328BC6
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240363AbhCASit (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:45194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239134AbhCASdv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:33:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B51C652FA;
        Mon,  1 Mar 2021 17:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620464;
        bh=p+L4q5ZOnepdIhERvdIVda9tfwSRZlN3UAXzIG+O5DQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fOtLfeGeOz2H9Jy4f9uhyMKr+Q0tYHrwo42ZHQWDbOjIJaIGX2MXHiAWEm7BWYIYG
         17Iwtoxg/A4q3USagm4rb7IDLNMeDJWAc5hXWC4Wm18Xg8jN/pb/XQ8zCsOma7RRP8
         /ypd+fljxqkIzkZv3NbIJor2CvAbUvzYo/KQscnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 162/775] net/mlx5e: Enable striding RQ for Connect-X IPsec capable devices
Date:   Mon,  1 Mar 2021 17:05:30 +0100
Message-Id: <20210301161209.645962633@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raed Salem <raeds@nvidia.com>

[ Upstream commit e4484d9df5000a18916e0bbcee50828eac8e293e ]

This limitation was inherited by previous Innova (FPGA) IPsec
implementation, it uses its private set of RQ handlers which does
not support striding rq, for Connect-X this is no longer true.

Fix by keeping this limitation only for Innova IPsec supporting devices,
as otherwise this limitation effectively wrongly blocks striding RQs for
all future Connect-X devices for all flows even if IPsec offload is not
used.

Fixes: 2d64663cd559 ("net/mlx5: IPsec: Add HW crypto offload support")
Signed-off-by: Raed Salem <raeds@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c    | 5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c      | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h | 2 ++
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 5fb0ab71d79ce..3edc826cc6bbe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -65,6 +65,7 @@
 #include "en/devlink.h"
 #include "lib/mlx5.h"
 #include "en/ptp.h"
+#include "fpga/ipsec.h"
 
 bool mlx5e_check_fragmented_striding_rq_cap(struct mlx5_core_dev *mdev)
 {
@@ -106,7 +107,7 @@ bool mlx5e_striding_rq_possible(struct mlx5_core_dev *mdev,
 	if (!mlx5e_check_fragmented_striding_rq_cap(mdev))
 		return false;
 
-	if (MLX5_IPSEC_DEV(mdev))
+	if (mlx5_fpga_is_ipsec_device(mdev))
 		return false;
 
 	if (params->xdp_prog) {
@@ -2069,7 +2070,7 @@ static void mlx5e_build_rq_frags_info(struct mlx5_core_dev *mdev,
 	int i;
 
 #ifdef CONFIG_MLX5_EN_IPSEC
-	if (MLX5_IPSEC_DEV(mdev))
+	if (mlx5_fpga_is_ipsec_device(mdev))
 		byte_count += MLX5E_METADATA_ETHER_LEN;
 #endif
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index ca4b55839a8a7..4864deed9dc94 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1795,8 +1795,8 @@ int mlx5e_rq_set_handlers(struct mlx5e_rq *rq, struct mlx5e_params *params, bool
 
 		rq->handle_rx_cqe = priv->profile->rx_handlers->handle_rx_cqe_mpwqe;
 #ifdef CONFIG_MLX5_EN_IPSEC
-		if (MLX5_IPSEC_DEV(mdev)) {
-			netdev_err(netdev, "MPWQE RQ with IPSec offload not supported\n");
+		if (mlx5_fpga_is_ipsec_device(mdev)) {
+			netdev_err(netdev, "MPWQE RQ with Innova IPSec offload not supported\n");
 			return -EINVAL;
 		}
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
index cc67366495b09..22bee49902327 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.c
@@ -124,7 +124,7 @@ struct mlx5_fpga_ipsec {
 	struct ida halloc;
 };
 
-static bool mlx5_fpga_is_ipsec_device(struct mlx5_core_dev *mdev)
+bool mlx5_fpga_is_ipsec_device(struct mlx5_core_dev *mdev)
 {
 	if (!mdev->fpga || !MLX5_CAP_GEN(mdev, fpga))
 		return false;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
index db88eb4c49e34..8931b55844773 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/ipsec.h
@@ -43,6 +43,7 @@ u32 mlx5_fpga_ipsec_device_caps(struct mlx5_core_dev *mdev);
 const struct mlx5_flow_cmds *
 mlx5_fs_cmd_get_default_ipsec_fpga_cmds(enum fs_flow_table_type type);
 void mlx5_fpga_ipsec_build_fs_cmds(void);
+bool mlx5_fpga_is_ipsec_device(struct mlx5_core_dev *mdev);
 #else
 static inline
 const struct mlx5_accel_ipsec_ops *mlx5_fpga_ipsec_ops(struct mlx5_core_dev *mdev)
@@ -55,6 +56,7 @@ mlx5_fs_cmd_get_default_ipsec_fpga_cmds(enum fs_flow_table_type type)
 }
 
 static inline void mlx5_fpga_ipsec_build_fs_cmds(void) {};
+static inline bool mlx5_fpga_is_ipsec_device(struct mlx5_core_dev *mdev) { return false; }
 
 #endif /* CONFIG_MLX5_FPGA_IPSEC */
 #endif	/* __MLX5_FPGA_IPSEC_H__ */
-- 
2.27.0



