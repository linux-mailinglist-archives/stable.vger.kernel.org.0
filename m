Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F85B2A59A2
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbgKCWJC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:09:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730139AbgKCUkE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:40:04 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 423E922226;
        Tue,  3 Nov 2020 20:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436003;
        bh=7AF2N+LL9w+SpBkEsJAI+AA6EvA3kZ7rmOiRUHC64aQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eViIDaZXDxjdzb7MgAdj6p2LGGQYls47OM2NWUHIXfs5BWoRj/p0FQK8qyq/5N77O
         C4/Xu3mtohf3RfgRSTQEk8p7+Je+dSUw6XhMbTiOeM85FXxd7lxwfG5tk/WekxtVic
         T+UqgaFjZooK5l84CEp4n1GTSkhGAzeWbbv1iq7s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Parav Pandit <parav@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 023/391] RDMA/mlx5: Fix devlink deadlock on net namespace deletion
Date:   Tue,  3 Nov 2020 21:31:14 +0100
Message-Id: <20201103203349.433098992@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit fbdd0049d98d44914fc57d4b91f867f4996c787b ]

When a mlx5 core devlink instance is reloaded in different net namespace,
its associated IB device is deleted and recreated.

Example sequence is:
$ ip netns add foo
$ devlink dev reload pci/0000:00:08.0 netns foo
$ ip netns del foo

mlx5 IB device needs to attach and detach the netdevice to it through the
netdev notifier chain during load and unload sequence.  A below call graph
of the unload flow.

cleanup_net()
   down_read(&pernet_ops_rwsem); <- first sem acquired
     ops_pre_exit_list()
       pre_exit()
         devlink_pernet_pre_exit()
           devlink_reload()
             mlx5_devlink_reload_down()
               mlx5_unload_one()
               [...]
                 mlx5_ib_remove()
                   mlx5_ib_unbind_slave_port()
                     mlx5_remove_netdev_notifier()
                       unregister_netdevice_notifier()
                         down_write(&pernet_ops_rwsem);<- recurrsive lock

Hence, when net namespace is deleted, mlx5 reload results in deadlock.

When deadlock occurs, devlink mutex is also held. This not only deadlocks
the mlx5 device under reload, but all the processes which attempt to
access unrelated devlink devices are deadlocked.

Hence, fix this by mlx5 ib driver to register for per net netdev notifier
instead of global one, which operats on the net namespace without holding
the pernet_ops_rwsem.

Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
Link: https://lore.kernel.org/r/20201026134359.23150-1-parav@nvidia.com
Signed-off-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c              |  6 ++++--
 .../net/ethernet/mellanox/mlx5/core/lib/mlx5.h |  5 -----
 include/linux/mlx5/driver.h                    | 18 ++++++++++++++++++
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b805cc8124657..2a7b5ffb2a2ef 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3318,7 +3318,8 @@ static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 	int err;
 
 	dev->port[port_num].roce.nb.notifier_call = mlx5_netdev_event;
-	err = register_netdevice_notifier(&dev->port[port_num].roce.nb);
+	err = register_netdevice_notifier_net(mlx5_core_net(dev->mdev),
+					      &dev->port[port_num].roce.nb);
 	if (err) {
 		dev->port[port_num].roce.nb.notifier_call = NULL;
 		return err;
@@ -3330,7 +3331,8 @@ static int mlx5_add_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 static void mlx5_remove_netdev_notifier(struct mlx5_ib_dev *dev, u8 port_num)
 {
 	if (dev->port[port_num].roce.nb.notifier_call) {
-		unregister_netdevice_notifier(&dev->port[port_num].roce.nb);
+		unregister_netdevice_notifier_net(mlx5_core_net(dev->mdev),
+						  &dev->port[port_num].roce.nb);
 		dev->port[port_num].roce.nb.notifier_call = NULL;
 	}
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
index d046db7bb047d..3a9fa629503f0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mlx5.h
@@ -90,9 +90,4 @@ int mlx5_create_encryption_key(struct mlx5_core_dev *mdev,
 			       u32 key_type, u32 *p_key_id);
 void mlx5_destroy_encryption_key(struct mlx5_core_dev *mdev, u32 key_id);
 
-static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
-{
-	return devlink_net(priv_to_devlink(dev));
-}
-
 #endif
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 372100c755e7f..e30be3dd5be0e 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1212,4 +1212,22 @@ static inline bool mlx5_is_roce_enabled(struct mlx5_core_dev *dev)
 	return val.vbool;
 }
 
+/**
+ * mlx5_core_net - Provide net namespace of the mlx5_core_dev
+ * @dev: mlx5 core device
+ *
+ * mlx5_core_net() returns the net namespace of mlx5 core device.
+ * This can be called only in below described limited context.
+ * (a) When a devlink instance for mlx5_core is registered and
+ *     when devlink reload operation is disabled.
+ *     or
+ * (b) during devlink reload reload_down() and reload_up callbacks
+ *     where it is ensured that devlink instance's net namespace is
+ *     stable.
+ */
+static inline struct net *mlx5_core_net(struct mlx5_core_dev *dev)
+{
+	return devlink_net(priv_to_devlink(dev));
+}
+
 #endif /* MLX5_DRIVER_H */
-- 
2.27.0



