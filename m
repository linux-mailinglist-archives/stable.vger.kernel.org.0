Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD7F417496
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 15:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345706AbhIXNIb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 09:08:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346002AbhIXNFz (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 09:05:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AF16861507;
        Fri, 24 Sep 2021 12:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632488166;
        bh=x7tAnjex4zAl3zrZUc7XTPz3VV0SdB1OWSSGfTDIAwc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/+IA0TrR5Hm9drHJklns5wags/8XC9S22urp/1Xzb9IliDmiKKhNGCGE56LiYyoI
         OK6RQjv0SP+q3p6/gjdogcEZQDLVosee+N2a7PGbGlMlC5UcNAicB2Ay4dqWzerEIf
         72sOwKVooHRZ/FoOeWa2PDkcbieYPP/wpVLkLj9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Patrick.Mclean@sony.com,
        Aya Levin <ayal@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH 5.10 10/63] [PATCH] Revert "net/mlx5: Register to devlink ingress VLAN filter trap"
Date:   Fri, 24 Sep 2021 14:44:10 +0200
Message-Id: <20210924124334.598145185@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124334.228235870@linuxfoundation.org>
References: <20210924124334.228235870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit fe6322774ca28669868a7e231e173e09f7422118 which was
commit 82e6c96f04e13c72d91777455836ffd012853caa upstream.

It has been reported to cause regressions so should be dropped.

Reported-by: <Patrick.Mclean@sony.com>
Link: https://lore.kernel.org/r/BY5PR13MB3604D3031E984CA34A57B7C9EEA09@BY5PR13MB3604.namprd13.prod.outlook.com
Cc: Aya Levin <ayal@nvidia.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
Cc: Tariq Toukan <tariqt@nvidia.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Sasha Levin <sashal@kernel.org>
Cc: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c |   51 ----------------------
 1 file changed, 51 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -376,48 +376,6 @@ static void mlx5_devlink_set_params_init
 #endif
 }
 
-#define MLX5_TRAP_DROP(_id, _group_id)					\
-	DEVLINK_TRAP_GENERIC(DROP, DROP, _id,				\
-			     DEVLINK_TRAP_GROUP_GENERIC_ID_##_group_id, \
-			     DEVLINK_TRAP_METADATA_TYPE_F_IN_PORT)
-
-static const struct devlink_trap mlx5_traps_arr[] = {
-	MLX5_TRAP_DROP(INGRESS_VLAN_FILTER, L2_DROPS),
-};
-
-static const struct devlink_trap_group mlx5_trap_groups_arr[] = {
-	DEVLINK_TRAP_GROUP_GENERIC(L2_DROPS, 0),
-};
-
-static int mlx5_devlink_traps_register(struct devlink *devlink)
-{
-	struct mlx5_core_dev *core_dev = devlink_priv(devlink);
-	int err;
-
-	err = devlink_trap_groups_register(devlink, mlx5_trap_groups_arr,
-					   ARRAY_SIZE(mlx5_trap_groups_arr));
-	if (err)
-		return err;
-
-	err = devlink_traps_register(devlink, mlx5_traps_arr, ARRAY_SIZE(mlx5_traps_arr),
-				     &core_dev->priv);
-	if (err)
-		goto err_trap_group;
-	return 0;
-
-err_trap_group:
-	devlink_trap_groups_unregister(devlink, mlx5_trap_groups_arr,
-				       ARRAY_SIZE(mlx5_trap_groups_arr));
-	return err;
-}
-
-static void mlx5_devlink_traps_unregister(struct devlink *devlink)
-{
-	devlink_traps_unregister(devlink, mlx5_traps_arr, ARRAY_SIZE(mlx5_traps_arr));
-	devlink_trap_groups_unregister(devlink, mlx5_trap_groups_arr,
-				       ARRAY_SIZE(mlx5_trap_groups_arr));
-}
-
 int mlx5_devlink_register(struct devlink *devlink, struct device *dev)
 {
 	int err;
@@ -432,16 +390,8 @@ int mlx5_devlink_register(struct devlink
 		goto params_reg_err;
 	mlx5_devlink_set_params_init_values(devlink);
 	devlink_params_publish(devlink);
-
-	err = mlx5_devlink_traps_register(devlink);
-	if (err)
-		goto traps_reg_err;
-
 	return 0;
 
-traps_reg_err:
-	devlink_params_unregister(devlink, mlx5_devlink_params,
-				  ARRAY_SIZE(mlx5_devlink_params));
 params_reg_err:
 	devlink_unregister(devlink);
 	return err;
@@ -449,7 +399,6 @@ params_reg_err:
 
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
-	mlx5_devlink_traps_unregister(devlink);
 	devlink_params_unpublish(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));


