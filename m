Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCCC5BAABD
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 12:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231232AbiIPKZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 06:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbiIPKXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 06:23:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECABFB14D6;
        Fri, 16 Sep 2022 03:14:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3011B82487;
        Fri, 16 Sep 2022 10:13:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A83BC433C1;
        Fri, 16 Sep 2022 10:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663323238;
        bh=qs9u5QgU1hQoapxpzRh4SOV4cfuacJ0RXliE6Pz+CGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yihF15lsBDcAPrN/qp/fkUqt48LwZ7lWAxNkB5b/iKq7qcvEEoqDqaIDnVT2IZC+R
         p6+/eK+G4rA5mtn99DfPCiLZ6FFfNORazUkvTpTfyM3e1qzm8gz5F1LoX4u+RlZ/cr
         RQ5KkE96a/RTV4IY4bldgBBZ41/cX45FMusdjLJI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shay Drory <shayd@nvidia.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Maher Sanalla <msanalla@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 04/38] RDMA/mlx5: Rely on RoCE fw cap instead of devlink when setting profile
Date:   Fri, 16 Sep 2022 12:08:38 +0200
Message-Id: <20220916100448.622064836@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220916100448.431016349@linuxfoundation.org>
References: <20220916100448.431016349@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 9ca05b0f27de928be121cccf07735819dc9e1ed3 ]

When the RDMA auxiliary driver probes, it sets its profile based on
devlink driverinit value. The latter might not be in sync with FW yet
(In case devlink reload is not performed), thus causing a mismatch
between RDMA driver and FW. This results in the following FW syndrome
when the RDMA driver tries to adjust RoCE state, which fails the probe:

"0xC1F678 | modify_nic_vport_context: roce_en set on a vport that
doesn't support roce"

To prevent this, select the PF profile based on FW RoCE capability
instead of relying on devlink driverinit value.
To provide backward compatibility of the RoCE disable feature, on older
FW's where roce_rw is not set (FW RoCE capability is read-only), keep
the current behavior e.g., rely on devlink driverinit value.

Fixes: fbfa97b4d79f ("net/mlx5: Disable roce at HCA level")
Reviewed-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Link: https://lore.kernel.org/r/cb34ce9a1df4a24c135cb804db87f7d2418bd6cc.1661763459.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c             |  2 +-
 .../net/ethernet/mellanox/mlx5/core/main.c    | 23 +++++++++++++++++--
 include/linux/mlx5/driver.h                   | 19 +++++++--------
 3 files changed, 32 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 63c89a72cc352..bb13164124fdb 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4336,7 +4336,7 @@ static int mlx5r_probe(struct auxiliary_device *adev,
 	dev->mdev = mdev;
 	dev->num_ports = num_ports;
 
-	if (ll == IB_LINK_LAYER_ETHERNET && !mlx5_is_roce_init_enabled(mdev))
+	if (ll == IB_LINK_LAYER_ETHERNET && !mlx5_get_roce_state(mdev))
 		profile = &raw_eth_profile;
 	else
 		profile = &pf_profile;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 64d54bba91f69..6c8bb74bd8fc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -501,6 +501,24 @@ static int max_uc_list_get_devlink_param(struct mlx5_core_dev *dev)
 	return err;
 }
 
+bool mlx5_is_roce_on(struct mlx5_core_dev *dev)
+{
+	struct devlink *devlink = priv_to_devlink(dev);
+	union devlink_param_value val;
+	int err;
+
+	err = devlink_param_driverinit_value_get(devlink,
+						 DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
+						 &val);
+
+	if (!err)
+		return val.vbool;
+
+	mlx5_core_dbg(dev, "Failed to get param. err = %d\n", err);
+	return MLX5_CAP_GEN(dev, roce);
+}
+EXPORT_SYMBOL(mlx5_is_roce_on);
+
 static int handle_hca_cap_2(struct mlx5_core_dev *dev, void *set_ctx)
 {
 	void *set_hca_cap;
@@ -604,7 +622,8 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 			 MLX5_CAP_GEN_MAX(dev, num_total_dynamic_vf_msix));
 
 	if (MLX5_CAP_GEN(dev, roce_rw_supported))
-		MLX5_SET(cmd_hca_cap, set_hca_cap, roce, mlx5_is_roce_init_enabled(dev));
+		MLX5_SET(cmd_hca_cap, set_hca_cap, roce,
+			 mlx5_is_roce_on(dev));
 
 	max_uc_list = max_uc_list_get_devlink_param(dev);
 	if (max_uc_list > 0)
@@ -630,7 +649,7 @@ static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
  */
 static bool is_roce_fw_disabled(struct mlx5_core_dev *dev)
 {
-	return (MLX5_CAP_GEN(dev, roce_rw_supported) && !mlx5_is_roce_init_enabled(dev)) ||
+	return (MLX5_CAP_GEN(dev, roce_rw_supported) && !mlx5_is_roce_on(dev)) ||
 		(!MLX5_CAP_GEN(dev, roce_rw_supported) && !MLX5_CAP_GEN(dev, roce));
 }
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 0015a08ddbd24..b3ea245faa515 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1275,16 +1275,17 @@ enum {
 	MLX5_TRIGGERED_CMD_COMP = (u64)1 << 32,
 };
 
-static inline bool mlx5_is_roce_init_enabled(struct mlx5_core_dev *dev)
+bool mlx5_is_roce_on(struct mlx5_core_dev *dev);
+
+static inline bool mlx5_get_roce_state(struct mlx5_core_dev *dev)
 {
-	struct devlink *devlink = priv_to_devlink(dev);
-	union devlink_param_value val;
-	int err;
-
-	err = devlink_param_driverinit_value_get(devlink,
-						 DEVLINK_PARAM_GENERIC_ID_ENABLE_ROCE,
-						 &val);
-	return err ? MLX5_CAP_GEN(dev, roce) : val.vbool;
+	if (MLX5_CAP_GEN(dev, roce_rw_supported))
+		return MLX5_CAP_GEN(dev, roce);
+
+	/* If RoCE cap is read-only in FW, get RoCE state from devlink
+	 * in order to support RoCE enable/disable feature
+	 */
+	return mlx5_is_roce_on(dev);
 }
 
 #endif /* MLX5_DRIVER_H */
-- 
2.35.1



