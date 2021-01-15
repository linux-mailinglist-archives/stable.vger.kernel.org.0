Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC6D2F7A3B
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732034AbhAOMr3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:47:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:44502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388006AbhAOMhf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A6D5235F8;
        Fri, 15 Jan 2021 12:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714239;
        bh=3D4ZQwUCjpcedf9bq0LqV2BCy9wTjj+qzk1kRdItDlw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T3USV0UeUKqEEccwjP4vdH8c3bynglciE6yZZ/g0AKco/jVKl8jRh+muSZ5NtZTIG
         jyGM4ph08LfMBzV0C5EvOO4e78G59eKxxqau1AZgP1RCKwf7HQhqO8FFR2Atvs1q9x
         vUHa8UKhzsqhWU7PYUMC2mPe2bg0V1CeNxB+vTdQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Zhang <markzhang@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.10 047/103] net/mlx5: Check if lag is supported before creating one
Date:   Fri, 15 Jan 2021 13:27:40 +0100
Message-Id: <20210115122008.334524406@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Zhang <markzhang@nvidia.com>

[ Upstream commit abf8ef953a43e74aac3c54a94975f21bd483199b ]

This patch fixes a memleak issue by preventing to create a lag and
add PFs if lag is not supported.

comm “python3”, pid 349349, jiffies 4296985507 (age 1446.976s)
hex dump (first 32 bytes):
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  …………….
  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  …………….
 backtrace:
  [<000000005b216ae7>] mlx5_lag_add+0x1d5/0×3f0 [mlx5_core]
  [<000000000445aa55>] mlx5e_nic_enable+0x66/0×1b0 [mlx5_core]
  [<00000000c56734c3>] mlx5e_attach_netdev+0x16e/0×200 [mlx5_core]
  [<0000000030439d1f>] mlx5e_attach+0x5c/0×90 [mlx5_core]
  [<0000000018fd8615>] mlx5e_add+0x1a4/0×410 [mlx5_core]
  [<0000000068bc504b>] mlx5_add_device+0x72/0×120 [mlx5_core]
  [<000000009fce51f9>] mlx5_register_device+0x77/0xb0 [mlx5_core]
  [<00000000d0d81ff3>] mlx5_load_one+0xc58/0×1eb0 [mlx5_core]
  [<0000000045077adc>] init_one+0x3ea/0×920 [mlx5_core]
  [<0000000043287674>] pci_device_probe+0xcd/0×150
  [<00000000dafd3279>] really_probe+0x1c9/0×4b0
  [<00000000f06bdd84>] driver_probe_device+0x5d/0×140
  [<00000000e3d508b6>] device_driver_attach+0x4f/0×60
  [<0000000084fba0f0>] bind_store+0xbf/0×120
  [<00000000bf6622b3>] kernfs_fop_write+0x114/0×1b0

Fixes: 9b412cc35f00 ("net/mlx5e: Add LAG warning if bond slave is not lag master")
Signed-off-by: Mark Zhang <markzhang@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -556,7 +556,9 @@ void mlx5_lag_add(struct mlx5_core_dev *
 	struct mlx5_core_dev *tmp_dev;
 	int i, err;
 
-	if (!MLX5_CAP_GEN(dev, vport_group_manager))
+	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
+	    !MLX5_CAP_GEN(dev, lag_master) ||
+	    MLX5_CAP_GEN(dev, num_lag_ports) != MLX5_MAX_PORTS)
 		return;
 
 	tmp_dev = mlx5_get_next_phys_dev(dev);
@@ -574,12 +576,9 @@ void mlx5_lag_add(struct mlx5_core_dev *
 	if (mlx5_lag_dev_add_pf(ldev, dev, netdev) < 0)
 		return;
 
-	for (i = 0; i < MLX5_MAX_PORTS; i++) {
-		tmp_dev = ldev->pf[i].dev;
-		if (!tmp_dev || !MLX5_CAP_GEN(tmp_dev, lag_master) ||
-		    MLX5_CAP_GEN(tmp_dev, num_lag_ports) != MLX5_MAX_PORTS)
+	for (i = 0; i < MLX5_MAX_PORTS; i++)
+		if (!ldev->pf[i].dev)
 			break;
-	}
 
 	if (i >= MLX5_MAX_PORTS)
 		ldev->flags |= MLX5_LAG_FLAG_READY;


