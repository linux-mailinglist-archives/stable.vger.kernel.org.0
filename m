Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC4230CC37
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240044AbhBBTr0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:47:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232846AbhBBNwY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:52:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2FD364FC2;
        Tue,  2 Feb 2021 13:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273428;
        bh=M3hMHsjq09ci8Qg/KUAlhjHMI2YUvYmm1qjx55veBsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TueGE/pj9WToekQnkQ0ajtn2pfHF4KQQAQKQRRMhHyyo3J92eqWkMRwq3Qr+xl56q
         INOlLUNeaCQjKCwuexo2rXkJaQQ7JQTzPAwGxpATsXWttv5DIj92+uzdAwAL2OsSS8
         Bw22rc1xEEgj6XcqGdmSU6CHksQaz8lYs+qiY2WY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH 5.10 076/142] Revert "RDMA/mlx5: Fix devlink deadlock on net namespace deletion"
Date:   Tue,  2 Feb 2021 14:37:19 +0100
Message-Id: <20210202133000.853368399@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

commit de641d74fb00f5b32f054ee154e31fb037e0db88 upstream.

This reverts commit fbdd0049d98d44914fc57d4b91f867f4996c787b.

Due to commit in fixes tag, netdevice events were received only in one net
namespace of mlx5_core_dev. Due to this when netdevice events arrive in
net namespace other than net namespace of mlx5_core_dev, they are missed.

This results in empty GID table due to RDMA device being detached from its
net device.

Hence, revert back to receive netdevice events in all net namespaces to
restore back RDMA functionality in non init_net net namespace. The
deadlock will have to be addressed in another patch.

Fixes: fbdd0049d98d ("RDMA/mlx5: Fix devlink deadlock on net namespace deletion")
Link: https://lore.kernel.org/r/20210117092633.10690-1-leon@kernel.org
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/main.c                  |    6 ++----
 drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h |    5 +++++
 include/linux/mlx5/driver.h                        |   18 ------------------
 3 files changed, 7 insertions(+), 22 deletions(-)

--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3305,8 +3305,7 @@ static int mlx5_add_netdev_notifier(stru
 	int err;
 
 	dev->port[port_num].roce.nb.notifier_call = mlx5_netdev_event;
-	err = register_netdevice_notifier_net(mlx5_core_net(dev->mdev),
-					      &dev->port[port_num].roce.nb);
+	err = register_netdevice_notifier(&dev->port[port_num].roce.nb);
 	if (err) {
 		dev->port[port_num].roce.nb.notifier_call = NULL;
 		return err;
@@ -3318,8 +3317,7 @@ static int mlx5_add_netdev_notifier(stru
 static void mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 {
 	if (dev->port[port_num].roce.nb.notifier_call) {
-		unregister_netdevice_notifier_net(mlx5_core_net(dev->mdev),
-						  &dev->port[port_num].roce.nb);
+		unregister_netdevice_notifier(&dev->port[port_num].roce.nb);
 		dev->port[port_num].roce.nb.notifier_call = NULL;
 	}
 }
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -90,4 +90,9 @@ int mlx5_create_encryption_key(struct ml
 			       u32 key_type, u32 *p_key_id);
 void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id);
 
+static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
+{
+	return devlink_net(priv_to_devlink(dev));
+}
+
 #endif
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1213,22 +1213,4 @@ static inline bool mlx5_is_roce_enabled(
 	return val.vbool;
 }
 
-/**
- * mlx5_core_net - Provide net namespace of the mlx5_core_dev
- * @dev: mlx5 core device
- *
- * mlx5_core_net() returns the net namespace of mlx5 core device.
- * This can be called only in below described limited context.
- * (a) When a devlink instance for mlx5_core is registered and
- *     when devlink reload operation is disabled.
- *     or
- * (b) during devlink reload reload_down() and reload_up callbacks
- *     where it is ensured that devlink instance's net namespace is
- *     stable.
- */
-static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
-{
-	return devlink_net(priv_to_devlink(dev));
-}
-
 #endif /* MLX5_DRIVER_H */


