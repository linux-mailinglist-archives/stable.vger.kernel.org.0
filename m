Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A233AEFE5
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbhFUQnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:43:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232747AbhFUQlU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:41:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DDC3F61443;
        Mon, 21 Jun 2021 16:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293043;
        bh=PWyAofjo/tiPpJ3UOrmLuyAavbAesjZ8yhnKPvd76Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pD9nI3AAqlufawPNGJSMvP3Vev/+JcRCDRdFYAN9MLXWGckpRlDF1T8jG+z3/szR5
         KrwOzOA6brtuhWcY6Q9tXUFWooRnfGG9uPC6tE9SKRL1WKkWCdZXGYvRP6KAaP3P14
         G50lNQFGPZPeqjqcMJuFChhZwkEMBNF87O/pJR4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmytro Linkin <dlinkin@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Roi Dayan <roid@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 077/178] net/mlx5e: Dont create devices during unload flow
Date:   Mon, 21 Jun 2021 18:14:51 +0200
Message-Id: <20210621154925.215524026@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmytro Linkin <dlinkin@nvidia.com>

[ Upstream commit a5ae8fc9058e37437c8c1f82b3d412b4abd1b9e6 ]

Running devlink reload command for port in switchdev mode cause
resources to corrupt: driver can't release allocated EQ and reclaim
memory pages, because "rdma" auxiliary device had add CQs which blocks
EQ from deletion.
Erroneous sequence happens during reload-down phase, and is following:

1. detach device - suspends auxiliary devices which support it, destroys
   others. During this step "eth-rep" and "rdma-rep" are destroyed,
   "eth" - suspended.
2. disable SRIOV - moves device to legacy mode; as part of disablement -
   rescans drivers. This step adds "rdma" auxiliary device.
3. destroy EQ table - <failure>.

Driver shouldn't create any device during unload flows. To handle that
implement MLX5_PRIV_FLAGS_DETACH flag, set it on device detach and unset
on device attach. If flag is set do no-op on drivers rescan.

Fixes: a925b5e309c9 ("net/mlx5: Register mlx5 devices to auxiliary virtual bus")
Signed-off-by: Dmytro Linkin <dlinkin@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/dev.c | 4 ++++
 include/linux/mlx5/driver.h                   | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index f0623e94716b..897853a68cd0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -306,6 +306,7 @@ int mlx5_attach_device(struct mlx5_core_dev *dev)
 	int ret = 0, i;
 
 	mutex_lock(&mlx5_intf_mutex);
+	priv->flags &= ~MLX5_PRIV_FLAGS_DETACH;
 	for (i = 0; i < ARRAY_SIZE(mlx5_adev_devices); i++) {
 		if (!priv->adev[i]) {
 			bool is_supported = false;
@@ -378,6 +379,7 @@ skip_suspend:
 		del_adev(&priv->adev[i]->adev);
 		priv->adev[i] = NULL;
 	}
+	priv->flags |= MLX5_PRIV_FLAGS_DETACH;
 	mutex_unlock(&mlx5_intf_mutex);
 }
 
@@ -466,6 +468,8 @@ int mlx5_rescan_drivers_locked(struct mlx5_core_dev *dev)
 	struct mlx5_priv *priv = &dev->priv;
 
 	lockdep_assert_held(&mlx5_intf_mutex);
+	if (priv->flags & MLX5_PRIV_FLAGS_DETACH)
+		return 0;
 
 	delete_drivers(dev);
 	if (priv->flags & MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV)
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 133967c40214..6a31bbba1b6f 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -541,6 +541,10 @@ struct mlx5_core_roce {
 enum {
 	MLX5_PRIV_FLAGS_DISABLE_IB_ADEV = 1 << 0,
 	MLX5_PRIV_FLAGS_DISABLE_ALL_ADEV = 1 << 1,
+	/* Set during device detach to block any further devices
+	 * creation/deletion on drivers rescan. Unset during device attach.
+	 */
+	MLX5_PRIV_FLAGS_DETACH = 1 << 2,
 };
 
 struct mlx5_adev {
-- 
2.30.2



