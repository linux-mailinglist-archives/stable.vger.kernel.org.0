Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD9A45C588
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:56:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347595AbhKXN7Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:59:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349646AbhKXNyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:54:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4805F611AE;
        Wed, 24 Nov 2021 13:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759140;
        bh=S4im4fJv67/iG+EaX7zYhOe7YAU6nFcHSIpgJCzzBxw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vS36HD6jo98JxJ8CRLVJzyJGbAyBNnW1inYXkqOozXJ24Tk/J3f6W5wMVioT0RfxC
         YUHwItS/YTiayK1STaYp0cobLvnNqthl5jpKeUNPfzbYS1OYebC99RpzLgDScSsvaV
         DLC4/RvwWhRwM+s/qUD4+rZHSqinYDzVOxIP5zxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/279] net/mlx5: E-Switch, Fix resetting of encap mode when entering switchdev
Date:   Wed, 24 Nov 2021 12:57:12 +0100
Message-Id: <20211124115723.786358308@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Blakey <paulb@nvidia.com>

[ Upstream commit d7751d6476185ff754b9dad2cba0c0a6e43ecadc ]

E-Switch encap mode is relevant only when in switchdev mode.
The RDMA driver can query the encap configuration via
mlx5_eswitch_get_encap_mode(). Make sure it returns the currently
used mode and not the set one.

This reverts the cited commit which reset the encap mode
on entering switchdev and fixes the original issue properly.

Fixes: 9a64144d683a ("net/mlx5: E-Switch, Fix default encap mode")
Signed-off-by: Paul Blakey <paulb@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c        | 9 +++++++--
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c   | 7 -------
 include/linux/mlx5/eswitch.h                             | 4 ++--
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index ec136b4992045..5872cc8bf9532 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1572,6 +1572,11 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	esw->enabled_vports = 0;
 	esw->mode = MLX5_ESWITCH_NONE;
 	esw->offloads.inline_mode = MLX5_INLINE_MODE_NONE;
+	if (MLX5_CAP_ESW_FLOWTABLE_FDB(dev, reformat) &&
+	    MLX5_CAP_ESW_FLOWTABLE_FDB(dev, decap))
+		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_BASIC;
+	else
+		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 
 	dev->priv.eswitch = esw;
 	BLOCKING_INIT_NOTIFIER_HEAD(&esw->n_head);
@@ -1934,7 +1939,7 @@ free_out:
 	return err;
 }
 
-u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev)
+u8 mlx5_eswitch_mode(const struct mlx5_core_dev *dev)
 {
 	struct mlx5_eswitch *esw = dev->priv.eswitch;
 
@@ -1948,7 +1953,7 @@ mlx5_eswitch_get_encap_mode(const struct mlx5_core_dev *dev)
 	struct mlx5_eswitch *esw;
 
 	esw = dev->priv.eswitch;
-	return mlx5_esw_allowed(esw) ? esw->offloads.encap :
+	return (mlx5_eswitch_mode(dev) == MLX5_ESWITCH_OFFLOADS)  ? esw->offloads.encap :
 		DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 }
 EXPORT_SYMBOL(mlx5_eswitch_get_encap_mode);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 0d461e38add37..08534d562d5a9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -3141,12 +3141,6 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	u64 mapping_id;
 	int err;
 
-	if (MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, reformat) &&
-	    MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, decap))
-		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_BASIC;
-	else
-		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
-
 	mutex_init(&esw->offloads.termtbl_mutex);
 	mlx5_rdma_enable_roce(esw->dev);
 
@@ -3244,7 +3238,6 @@ void esw_offloads_disable(struct mlx5_eswitch *esw)
 	esw_offloads_metadata_uninit(esw);
 	mlx5_rdma_disable_roce(esw->dev);
 	mutex_destroy(&esw->offloads.termtbl_mutex);
-	esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 }
 
 static int esw_mode_from_devlink(u16 mode, u16 *mlx5_mode)
diff --git a/include/linux/mlx5/eswitch.h b/include/linux/mlx5/eswitch.h
index 4ab5c1fc1270d..a09ed4c8361b6 100644
--- a/include/linux/mlx5/eswitch.h
+++ b/include/linux/mlx5/eswitch.h
@@ -136,13 +136,13 @@ u32 mlx5_eswitch_get_vport_metadata_for_set(struct mlx5_eswitch *esw,
 				       ESW_TUN_OPTS_SLOW_TABLE_GOTO_VPORT)
 #define ESW_TUN_SLOW_TABLE_GOTO_VPORT_MARK ESW_TUN_OPTS_MASK
 
-u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev);
+u8 mlx5_eswitch_mode(const struct mlx5_core_dev *dev);
 u16 mlx5_eswitch_get_total_vports(const struct mlx5_core_dev *dev);
 struct mlx5_core_dev *mlx5_eswitch_get_core_dev(struct mlx5_eswitch *esw);
 
 #else  /* CONFIG_MLX5_ESWITCH */
 
-static inline u8 mlx5_eswitch_mode(struct mlx5_core_dev *dev)
+static inline u8 mlx5_eswitch_mode(const struct mlx5_core_dev *dev)
 {
 	return MLX5_ESWITCH_NONE;
 }
-- 
2.33.0



