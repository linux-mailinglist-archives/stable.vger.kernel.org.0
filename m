Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F9C63961B4
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:44:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233127AbhEaOpe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:45:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233313AbhEaOn2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:43:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10C606191B;
        Mon, 31 May 2021 13:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622469255;
        bh=uMF7+gPy7twIoaTGLUFuRpN4SVRDwXmZORFPJj9IrSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o/6KH25SO8tV4LVzQc0KhG9yE+b8J/nA0l1pqYAz42czh+TxXPNxPvY/H4BGWh1TT
         LkUHRP0RviBOzHKI3Za+mFHtnhmNRUSk4gBeNf0AyhAv+//Ikinwkh9pocOpMTQDMo
         zMWRkp48fQGEDOZbLkbWJW+QqLc5C1Xi8zTuJR1s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 5.12 127/296] {net, RDMA}/mlx5: Fix override of log_max_qp by other device
Date:   Mon, 31 May 2021 15:13:02 +0200
Message-Id: <20210531130708.168948818@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
References: <20210531130703.762129381@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

commit 3410fbcd47dc6479af4309febf760ccaa5efb472 upstream.

mlx5_core_dev holds pointer to static profile, hence when the
log_max_qp of the profile is override by some device, then it
effect all other mlx5 devices that share the same profile.
Fix it by having a profile instance for every mlx5 device.

Fixes: 883371c453b9 ("net/mlx5: Check FW limitations on log_max_qp before setting it")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/mr.c                |    4 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c |   11 ++----
 include/linux/mlx5/driver.h                    |   44 ++++++++++++-------------
 3 files changed, 29 insertions(+), 30 deletions(-)

--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -764,10 +764,10 @@ int mlx5_mr_cache_init(struct mlx5_ib_de
 		ent->xlt = (1 << ent->order) * sizeof(struct mlx5_mtt) /
 			   MLX5_IB_UMR_OCTOWORD;
 		ent->access_mode = MLX5_MKC_ACCESS_MODE_MTT;
-		if ((dev->mdev->profile->mask & MLX5_PROF_MASK_MR_CACHE) &&
+		if ((dev->mdev->profile.mask & MLX5_PROF_MASK_MR_CACHE) &&
 		    !dev->is_rep && mlx5_core_is_pf(dev->mdev) &&
 		    mlx5_ib_can_load_pas_with_umr(dev, 0))
-			ent->limit = dev->mdev->profile->mr_cache[i].limit;
+			ent->limit = dev->mdev->profile.mr_cache[i].limit;
 		else
 			ent->limit = 0;
 		spin_lock_irq(&ent->lock);
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -503,7 +503,7 @@ static int handle_hca_cap_odp(struct mlx
 
 static int handle_hca_cap(struct mlx5_core_dev *dev, void *set_ctx)
 {
-	struct mlx5_profile *prof = dev->profile;
+	struct mlx5_profile *prof = &dev->profile;
 	void *set_hca_cap;
 	int err;
 
@@ -524,11 +524,11 @@ static int handle_hca_cap(struct mlx5_co
 		 to_fw_pkey_sz(dev, 128));
 
 	/* Check log_max_qp from HCA caps to set in current profile */
-	if (MLX5_CAP_GEN_MAX(dev, log_max_qp) < profile[prof_sel].log_max_qp) {
+	if (MLX5_CAP_GEN_MAX(dev, log_max_qp) < prof->log_max_qp) {
 		mlx5_core_warn(dev, "log_max_qp value in current profile is %d, changing it to HCA capability limit (%d)\n",
-			       profile[prof_sel].log_max_qp,
+			       prof->log_max_qp,
 			       MLX5_CAP_GEN_MAX(dev, log_max_qp));
-		profile[prof_sel].log_max_qp = MLX5_CAP_GEN_MAX(dev, log_max_qp);
+		prof->log_max_qp = MLX5_CAP_GEN_MAX(dev, log_max_qp);
 	}
 	if (prof->mask & MLX5_PROF_MASK_QP_SIZE)
 		MLX5_SET(cmd_hca_cap, set_hca_cap, log_max_qp,
@@ -1335,8 +1335,7 @@ int mlx5_mdev_init(struct mlx5_core_dev
 	struct mlx5_priv *priv = &dev->priv;
 	int err;
 
-	dev->profile = &profile[profile_idx];
-
+	memcpy(&dev->profile, &profile[profile_idx], sizeof(dev->profile));
 	INIT_LIST_HEAD(&priv->ctx_list);
 	spin_lock_init(&priv->ctx_lock);
 	mutex_init(&dev->intf_state_mutex);
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -698,6 +698,27 @@ struct mlx5_hv_vhca;
 #define MLX5_LOG_SW_ICM_BLOCK_SIZE(dev) (MLX5_CAP_DEV_MEM(dev, log_sw_icm_alloc_granularity))
 #define MLX5_SW_ICM_BLOCK_SIZE(dev) (1 << MLX5_LOG_SW_ICM_BLOCK_SIZE(dev))
 
+enum {
+	MLX5_PROF_MASK_QP_SIZE		= (u64)1 << 0,
+	MLX5_PROF_MASK_MR_CACHE		= (u64)1 << 1,
+};
+
+enum {
+	MR_CACHE_LAST_STD_ENTRY = 20,
+	MLX5_IMR_MTT_CACHE_ENTRY,
+	MLX5_IMR_KSM_CACHE_ENTRY,
+	MAX_MR_CACHE_ENTRIES
+};
+
+struct mlx5_profile {
+	u64	mask;
+	u8	log_max_qp;
+	struct {
+		int	size;
+		int	limit;
+	} mr_cache[MAX_MR_CACHE_ENTRIES];
+};
+
 struct mlx5_core_dev {
 	struct device *device;
 	enum mlx5_coredev_type coredev_type;
@@ -726,7 +747,7 @@ struct mlx5_core_dev {
 	struct mutex		intf_state_mutex;
 	unsigned long		intf_state;
 	struct mlx5_priv	priv;
-	struct mlx5_profile	*profile;
+	struct mlx5_profile	profile;
 	u32			issi;
 	struct mlx5e_resources  mlx5e_res;
 	struct mlx5_dm          *dm;
@@ -1073,18 +1094,6 @@ static inline u8 mlx5_mkey_variant(u32 m
 	return mkey & 0xff;
 }
 
-enum {
-	MLX5_PROF_MASK_QP_SIZE		= (u64)1 << 0,
-	MLX5_PROF_MASK_MR_CACHE		= (u64)1 << 1,
-};
-
-enum {
-	MR_CACHE_LAST_STD_ENTRY = 20,
-	MLX5_IMR_MTT_CACHE_ENTRY,
-	MLX5_IMR_KSM_CACHE_ENTRY,
-	MAX_MR_CACHE_ENTRIES
-};
-
 /* Async-atomic event notifier used by mlx5 core to forward FW
  * evetns recived from event queue to mlx5 consumers.
  * Optimise event queue dipatching.
@@ -1138,15 +1147,6 @@ int mlx5_rdma_rn_get_params(struct mlx5_
 			    struct ib_device *device,
 			    struct rdma_netdev_alloc_params *params);
 
-struct mlx5_profile {
-	u64	mask;
-	u8	log_max_qp;
-	struct {
-		int	size;
-		int	limit;
-	} mr_cache[MAX_MR_CACHE_ENTRIES];
-};
-
 enum {
 	MLX5_PCI_DEV_IS_VF		= 1 << 0,
 };


