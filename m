Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF4F395E58
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbhEaN5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:57:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:60040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232193AbhEaNz3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:55:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6DC2361924;
        Mon, 31 May 2021 13:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468057;
        bh=7WgkO20LrHRYlAl8QcfAb1m7VKD8H87duGx703AHGPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twaJYKD2svLVGlrsmPh/DDfdU/ZahG3JeXE15N4P7NCD/IFDmHLCS8FWv2vcWubuZ
         wHH94hSROpc6CyQacuacN/783GYadTCcNGs70l254GDHYr79/vgbHaHJHQvyutVG5W
         Ij+3G5RtURtf9XSNzwZByfdkxoJG4HGEN4byNmWo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org,
        Eli Cohen <elic@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 100/252] {net,vdpa}/mlx5: Configure interface MAC into mpfs L2 table
Date:   Mon, 31 May 2021 15:12:45 +0200
Message-Id: <20210531130701.391622704@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130657.971257589@linuxfoundation.org>
References: <20210531130657.971257589@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eli Cohen <elic@nvidia.com>

commit 7c9f131f366ab414691907fa0407124ea2b2f3bc upstream.

net/mlx5: Expose MPFS configuration API

MPFS is the multi physical function switch that bridges traffic between
the physical port and any physical functions associated with it. The
driver is required to add or remove MAC entries to properly forward
incoming traffic to the correct physical function.

We export the API to control MPFS so that other drivers, such as
mlx5_vdpa are able to add MAC addresses of their network interfaces.

The MAC address of the vdpa interface must be configured into the MPFS L2
address. Failing to do so could cause, in some NIC configurations, failure
to forward packets to the vdpa network device instance.

Fix this by adding calls to update the MPFS table.

CC: <mst@redhat.com>
CC: <jasowang@redhat.com>
CC: <virtualization@lists.linux-foundation.org>
Fixes: 1a86b377aa21 ("vdpa/mlx5: Add VDPA driver for supported mlx5 devices")
Signed-off-by: Eli Cohen <elic@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |    1 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c |    3 +++
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.h |    5 +----
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |   19 ++++++++++++++++++-
 include/linux/mlx5/mpfs.h                          |   18 ++++++++++++++++++
 6 files changed, 42 insertions(+), 5 deletions(-)
 create mode 100644 include/linux/mlx5/mpfs.h

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -35,6 +35,7 @@
 #include <linux/ipv6.h>
 #include <linux/tcp.h>
 #include <linux/mlx5/fs.h>
+#include <linux/mlx5/mpfs.h>
 #include "en.h"
 #include "lib/mpfs.h"
 
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -35,6 +35,7 @@
 #include <linux/mlx5/mlx5_ifc.h>
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
+#include <linux/mlx5/mpfs.h>
 #include "esw/acl/lgcy.h"
 #include "mlx5_core.h"
 #include "lib/eq.h"
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c
@@ -33,6 +33,7 @@
 #include <linux/etherdevice.h>
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/mlx5_ifc.h>
+#include <linux/mlx5/mpfs.h>
 #include <linux/mlx5/eswitch.h>
 #include "mlx5_core.h"
 #include "lib/mpfs.h"
@@ -175,6 +176,7 @@ out:
 	mutex_unlock(&mpfs->lock);
 	return err;
 }
+EXPORT_SYMBOL(mlx5_mpfs_add_mac);
 
 int mlx5_mpfs_del_mac(struct mlx5_core_dev *dev, u8 *mac)
 {
@@ -206,3 +208,4 @@ unlock:
 	mutex_unlock(&mpfs->lock);
 	return err;
 }
+EXPORT_SYMBOL(mlx5_mpfs_del_mac);
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.h
@@ -84,12 +84,9 @@ struct l2addr_node {
 #ifdef CONFIG_MLX5_MPFS
 int  mlx5_mpfs_init(struct mlx5_core_dev *dev);
 void mlx5_mpfs_cleanup(struct mlx5_core_dev *dev);
-int  mlx5_mpfs_add_mac(struct mlx5_core_dev *dev, u8 *mac);
-int  mlx5_mpfs_del_mac(struct mlx5_core_dev *dev, u8 *mac);
 #else /* #ifndef CONFIG_MLX5_MPFS */
 static inline int  mlx5_mpfs_init(struct mlx5_core_dev *dev) { return 0; }
 static inline void mlx5_mpfs_cleanup(struct mlx5_core_dev *dev) {}
-static inline int  mlx5_mpfs_add_mac(struct mlx5_core_dev *dev, u8 *mac) { return 0; }
-static inline int  mlx5_mpfs_del_mac(struct mlx5_core_dev *dev, u8 *mac) { return 0; }
 #endif
+
 #endif
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -9,6 +9,7 @@
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/device.h>
+#include <linux/mlx5/mpfs.h>
 #include "mlx5_vnet.h"
 #include "mlx5_vdpa_ifc.h"
 #include "mlx5_vdpa.h"
@@ -1839,11 +1840,16 @@ static int mlx5_vdpa_set_map(struct vdpa
 static void mlx5_vdpa_free(struct vdpa_device *vdev)
 {
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
+	struct mlx5_core_dev *pfmdev;
 	struct mlx5_vdpa_net *ndev;
 
 	ndev = to_mlx5_vdpa_ndev(mvdev);
 
 	free_resources(ndev);
+	if (!is_zero_ether_addr(ndev->config.mac)) {
+		pfmdev = pci_get_drvdata(pci_physfn(mvdev->mdev->pdev));
+		mlx5_mpfs_del_mac(pfmdev, ndev->config.mac);
+	}
 	mlx5_vdpa_free_resources(&ndev->mvdev);
 	mutex_destroy(&ndev->reslock);
 }
@@ -1962,6 +1968,7 @@ static void init_mvqs(struct mlx5_vdpa_n
 void *mlx5_vdpa_add_dev(struct mlx5_core_dev *mdev)
 {
 	struct virtio_net_config *config;
+	struct mlx5_core_dev *pfmdev;
 	struct mlx5_vdpa_dev *mvdev;
 	struct mlx5_vdpa_net *ndev;
 	u32 max_vqs;
@@ -1990,10 +1997,17 @@ void *mlx5_vdpa_add_dev(struct mlx5_core
 	if (err)
 		goto err_mtu;
 
+	if (!is_zero_ether_addr(config->mac)) {
+		pfmdev = pci_get_drvdata(pci_physfn(mdev->pdev));
+		err = mlx5_mpfs_add_mac(pfmdev, config->mac);
+		if (err)
+			goto err_mtu;
+	}
+
 	mvdev->vdev.dma_dev = mdev->device;
 	err = mlx5_vdpa_alloc_resources(&ndev->mvdev);
 	if (err)
-		goto err_mtu;
+		goto err_mpfs;
 
 	err = alloc_resources(ndev);
 	if (err)
@@ -2009,6 +2023,9 @@ err_reg:
 	free_resources(ndev);
 err_res:
 	mlx5_vdpa_free_resources(&ndev->mvdev);
+err_mpfs:
+	if (!is_zero_ether_addr(config->mac))
+		mlx5_mpfs_del_mac(pfmdev, config->mac);
 err_mtu:
 	mutex_destroy(&ndev->reslock);
 	put_device(&mvdev->vdev.dev);
--- /dev/null
+++ b/include/linux/mlx5/mpfs.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+ * Copyright (c) 2021 Mellanox Technologies Ltd.
+ */
+
+#ifndef _MLX5_MPFS_
+#define _MLX5_MPFS_
+
+struct mlx5_core_dev;
+
+#ifdef CONFIG_MLX5_MPFS
+int  mlx5_mpfs_add_mac(struct mlx5_core_dev *dev, u8 *mac);
+int  mlx5_mpfs_del_mac(struct mlx5_core_dev *dev, u8 *mac);
+#else /* #ifndef CONFIG_MLX5_MPFS */
+static inline int  mlx5_mpfs_add_mac(struct mlx5_core_dev *dev, u8 *mac) { return 0; }
+static inline int  mlx5_mpfs_del_mac(struct mlx5_core_dev *dev, u8 *mac) { return 0; }
+#endif
+
+#endif


