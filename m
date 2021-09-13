Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABCB408F54
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243150AbhIMNmC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:42:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243762AbhIMNkB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:40:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B299C6127A;
        Mon, 13 Sep 2021 13:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539741;
        bh=JvuB5ko9wrMvIn1mwuYuiMmamvdRVizbKxdxZM+s5Xo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wSSwj/arVfXG3NPFoBYSWFx0N3PnkBZVKxdFXs2LVCHjoVCGfe+eUisadNZw0WcMq
         1sakD0hid86lluillI6vzrgRUclh5/t9Ke2forAE2BHWAi2MjbMRRC/LoUbsQ16UXw
         te5iUDwTJLrtxffok/sgOTHtkwxp1N5xMmdtF7uM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aya Levin <ayal@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 143/236] net/mlx5: Register to devlink ingress VLAN filter trap
Date:   Mon, 13 Sep 2021 15:14:08 +0200
Message-Id: <20210913131105.222751786@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

[ Upstream commit 82e6c96f04e13c72d91777455836ffd012853caa ]

Add traps registration to mlx5_core devlink register/unregister flow.
This patch registers INGRESS_VLAN_FILTER trap.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 51 +++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index bf5cf022e279..2c7f2eff1e17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -376,6 +376,48 @@ static void mlx5_devlink_set_params_init_values(struct devlink *devlink)
 #endif
 }
 
+#define MLX5_TRAP_DROP(_id, _group_id)					\
+	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				\
+			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id, \
+			     DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT)
+
+static const struct devlink_trap mlx5_traps_arr[] = {
+	MLX5_TRAP_DROP(INGRESS_VLAN_FILTER, L2_DROPS),
+};
+
+static const struct devlink_trap_group mlx5_trap_groups_arr[] = {
+	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 0),
+};
+
+static int mlx5_devlink_traps_register(struct devlink *devlink)
+{
+	struct mlx5_core_dev *core_dev = devlink_priv(devlink);
+	int err;
+
+	err = devlink_trap_groups_register(devlink, mlx5_trap_groups_arr,
+					   ARRAY_SIZE(mlx5_trap_groups_arr));
+	if (err)
+		return err;
+
+	err = devlink_traps_register(devlink, mlx5_traps_arr, ARRAY_SIZE(mlx5_traps_arr),
+				     &core_dev->priv);
+	if (err)
+		goto err_trap_group;
+	return 0;
+
+err_trap_group:
+	devlink_trap_groups_unregister(devlink, mlx5_trap_groups_arr,
+				       ARRAY_SIZE(mlx5_trap_groups_arr));
+	return err;
+}
+
+static void mlx5_devlink_traps_unregister(struct devlink *devlink)
+{
+	devlink_traps_unregister(devlink, mlx5_traps_arr, ARRAY_SIZE(mlx5_traps_arr));
+	devlink_trap_groups_unregister(devlink, mlx5_trap_groups_arr,
+				       ARRAY_SIZE(mlx5_trap_groups_arr));
+}
+
 int mlx5_devlink_register(struct devlink *devlink, struct device *dev)
 {
 	int err;
@@ -390,8 +432,16 @@ int mlx5_devlink_register(struct devlink *devlink, struct device *dev)
 		goto params_reg_err;
 	mlx5_devlink_set_params_init_values(devlink);
 	devlink_params_publish(devlink);
+
+	err = mlx5_devlink_traps_register(devlink);
+	if (err)
+		goto traps_reg_err;
+
 	return 0;
 
+traps_reg_err:
+	devlink_params_unregister(devlink, mlx5_devlink_params,
+				  ARRAY_SIZE(mlx5_devlink_params));
 params_reg_err:
 	devlink_unregister(devlink);
 	return err;
@@ -399,6 +449,7 @@ params_reg_err:
 
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
+	mlx5_devlink_traps_unregister(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
 	devlink_unregister(devlink);
-- 
2.30.2



