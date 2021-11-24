Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B337A45C36F
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:36:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353247AbhKXNjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:39:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:47486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1352096AbhKXNgL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:36:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 827DE611C7;
        Wed, 24 Nov 2021 12:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637758512;
        bh=KCkaO2adXd05WwFnSAxV74p+tqMrk7qXT5veMEWRSL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsHg3SUysLbGnhTtEVzoxaek62iQtU8qFLHjwr+8BFtBv0sAOxcj+5DIm41cvNadR
         IX38hxVVNq+iwf8+/1VxkYTOHGhrxSmzpJd6nhr8aP7sIBLc3cEtC5KQzb7QGqknZ5
         QNia8CBGbwpBQWAAJY1VXNfzbGqJz2pxb+Or+g00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/154] net/mlx5: E-Switch, Change mode lock from mutex to rw semaphore
Date:   Wed, 24 Nov 2021 12:58:10 +0100
Message-Id: <20211124115705.343978684@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
References: <20211124115702.361983534@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

[ Upstream commit c55479d0cb6a28029844d0e90730704a0fb5efd3 ]

E-Switch mode change routine will take the write lock to prevent any
consumer to access the E-Switch resources while E-Switch is going
through a mode change.

In the next patch
E-Switch consumers (e.g vport representors) will take read_lock prior to
accessing E-Switch resources to prevent E-Switch mode changing in the
middle of the operation.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Parav Pandit <parav@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 11 ++++----
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  2 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 26 +++++++++----------
 3 files changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 401b2f5128dd4..78cc6f0bbc72b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1663,7 +1663,7 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 	if (!ESW_ALLOWED(esw))
 		return 0;
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	if (esw->mode == MLX5_ESWITCH_NONE) {
 		ret = mlx5_eswitch_enable_locked(esw, MLX5_ESWITCH_LEGACY, num_vfs);
 	} else {
@@ -1675,7 +1675,7 @@ int mlx5_eswitch_enable(struct mlx5_eswitch *esw, int num_vfs)
 		if (!ret)
 			esw->esw_funcs.num_vfs = num_vfs;
 	}
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return ret;
 }
 
@@ -1719,10 +1719,10 @@ void mlx5_eswitch_disable(struct mlx5_eswitch *esw, bool clear_vf)
 	if (!ESW_ALLOWED(esw))
 		return;
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	mlx5_eswitch_disable_locked(esw, clear_vf);
 	esw->esw_funcs.num_vfs = 0;
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 }
 
 int mlx5_eswitch_init(struct mlx5_core_dev *dev)
@@ -1778,7 +1778,7 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 	atomic64_set(&esw->offloads.num_flows, 0);
 	ida_init(&esw->offloads.vport_metadata_ida);
 	mutex_init(&esw->state_lock);
-	mutex_init(&esw->mode_lock);
+	init_rwsem(&esw->mode_lock);
 
 	mlx5_esw_for_all_vports(esw, i, vport) {
 		vport->vport = mlx5_eswitch_index_to_vport_num(esw, i);
@@ -1813,7 +1813,6 @@ void mlx5_eswitch_cleanup(struct mlx5_eswitch *esw)
 	esw->dev->priv.eswitch = NULL;
 	destroy_workqueue(esw->work_queue);
 	esw_offloads_cleanup_reps(esw);
-	mutex_destroy(&esw->mode_lock);
 	mutex_destroy(&esw->state_lock);
 	ida_destroy(&esw->offloads.vport_metadata_ida);
 	mlx5e_mod_hdr_tbl_destroy(&esw->offloads.mod_hdr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index cf87de94418ff..59c674f157a8c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -262,7 +262,7 @@ struct mlx5_eswitch {
 	/* Protects eswitch mode change that occurs via one or more
 	 * user commands, i.e. sriov state change, devlink commands.
 	 */
-	struct mutex mode_lock;
+	struct rw_semaphore mode_lock;
 
 	struct {
 		bool            enabled;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 5801f55ff0771..164e8cd9ad4ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2508,7 +2508,7 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 	if (esw_mode_from_devlink(mode, &mlx5_mode))
 		return -EINVAL;
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	cur_mlx5_mode = esw->mode;
 	if (cur_mlx5_mode == mlx5_mode)
 		goto unlock;
@@ -2521,7 +2521,7 @@ int mlx5_devlink_eswitch_mode_set(struct devlink *devlink, u16 mode,
 		err = -EINVAL;
 
 unlock:
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return err;
 }
 
@@ -2534,14 +2534,14 @@ int mlx5_devlink_eswitch_mode_get(struct devlink *devlink, u16 *mode)
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto unlock;
 
 	err = esw_mode_to_devlink(esw->mode, mode);
 unlock:
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return err;
 }
 
@@ -2557,7 +2557,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto out;
@@ -2599,7 +2599,7 @@ int mlx5_devlink_eswitch_inline_mode_set(struct devlink *devlink, u8 mode,
 	}
 
 	esw->offloads.inline_mode = mlx5_mode;
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return 0;
 
 revert_inline_mode:
@@ -2609,7 +2609,7 @@ revert_inline_mode:
 						 vport,
 						 esw->offloads.inline_mode);
 out:
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return err;
 }
 
@@ -2622,14 +2622,14 @@ int mlx5_devlink_eswitch_inline_mode_get(struct devlink *devlink, u8 *mode)
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto unlock;
 
 	err = esw_inline_mode_to_devlink(esw->offloads.inline_mode, mode);
 unlock:
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return err;
 }
 
@@ -2645,7 +2645,7 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 	if (IS_ERR(esw))
 		return PTR_ERR(esw);
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto unlock;
@@ -2691,7 +2691,7 @@ int mlx5_devlink_eswitch_encap_mode_set(struct devlink *devlink,
 	}
 
 unlock:
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return err;
 }
 
@@ -2706,14 +2706,14 @@ int mlx5_devlink_eswitch_encap_mode_get(struct devlink *devlink,
 		return PTR_ERR(esw);
 
 
-	mutex_lock(&esw->mode_lock);
+	down_write(&esw->mode_lock);
 	err = eswitch_devlink_esw_mode_check(esw);
 	if (err)
 		goto unlock;
 
 	*encap = esw->offloads.encap;
 unlock:
-	mutex_unlock(&esw->mode_lock);
+	up_write(&esw->mode_lock);
 	return 0;
 }
 
-- 
2.33.0



