Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1C08594562
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345048AbiHOW3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:29:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351093AbiHOW1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:27:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E8E36D57F;
        Mon, 15 Aug 2022 12:47:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C44F61206;
        Mon, 15 Aug 2022 19:47:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C35AC433C1;
        Mon, 15 Aug 2022 19:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592832;
        bh=FBaTAHb0GzBnCauJyhCdmmS9bjHyhSpV9lskJm3Xp3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOcYtE896RzQuyAkUr9D4+X4uOFeRRPqmAiBa4Tm7TLJpAeiipArGN+/E6CKIm/7r
         IoPUhN7fw1wpckTqbTkrKbZYKDncF0wPdWQ37q1jp5Xwsufgenhf8z+rWfZaUhVS9p
         03iDPZyIR9kkK7iDohYqMgBokeXtIsSxKZUgGr1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yishai Hadas <yishaih@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0851/1095] net/mlx5: Expose mlx5_sriov_blocking_notifier_register / unregister APIs
Date:   Mon, 15 Aug 2022 20:04:10 +0200
Message-Id: <20220815180504.535928600@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 846e437387e74c44ddc9f3eeec472fd37ca3cdb9 ]

Expose mlx5_sriov_blocking_notifier_register / unregister APIs to let a
VF register to be notified for its enablement / disablement by the PF.

Upon VF probe it will call mlx5_sriov_blocking_notifier_register() with
its notifier block and upon VF remove it will call
mlx5_sriov_blocking_notifier_unregister() to drop its registration.

This can give a VF the ability to clean some resources upon disable
before that the command interface goes down and on the other hand sets
some stuff before that it's enabled.

This may be used by a VF which is migration capable in few cases.(e.g.
PF load/unload upon an health recovery).

Link: https://lore.kernel.org/r/20220510090206.90374-2-yishaih@nvidia.com
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/sriov.c   | 65 ++++++++++++++++++-
 include/linux/mlx5/driver.h                   | 12 ++++
 2 files changed, 76 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index 887ee0f729d1..2935614f6fa9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -87,6 +87,11 @@ static int mlx5_device_enable_sriov(struct mlx5_core_dev *dev, int num_vfs)
 enable_vfs_hca:
 	num_msix_count = mlx5_get_default_msix_vec_count(dev, num_vfs);
 	for (vf = 0; vf < num_vfs; vf++) {
+		/* Notify the VF before its enablement to let it set
+		 * some stuff.
+		 */
+		blocking_notifier_call_chain(&sriov->vfs_ctx[vf].notifier,
+					     MLX5_PF_NOTIFY_ENABLE_VF, dev);
 		err = mlx5_core_enable_hca(dev, vf + 1);
 		if (err) {
 			mlx5_core_warn(dev, "failed to enable VF %d (%d)\n", vf, err);
@@ -127,6 +132,11 @@ mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
 	for (vf = num_vfs - 1; vf >= 0; vf--) {
 		if (!sriov->vfs_ctx[vf].enabled)
 			continue;
+		/* Notify the VF before its disablement to let it clean
+		 * some resources.
+		 */
+		blocking_notifier_call_chain(&sriov->vfs_ctx[vf].notifier,
+					     MLX5_PF_NOTIFY_DISABLE_VF, dev);
 		err = mlx5_core_disable_hca(dev, vf + 1);
 		if (err) {
 			mlx5_core_warn(dev, "failed to disable VF %d\n", vf);
@@ -257,7 +267,7 @@ int mlx5_sriov_init(struct mlx5_core_dev *dev)
 {
 	struct mlx5_core_sriov *sriov = &dev->priv.sriov;
 	struct pci_dev *pdev = dev->pdev;
-	int total_vfs;
+	int total_vfs, i;
 
 	if (!mlx5_core_is_pf(dev))
 		return 0;
@@ -269,6 +279,9 @@ int mlx5_sriov_init(struct mlx5_core_dev *dev)
 	if (!sriov->vfs_ctx)
 		return -ENOMEM;
 
+	for (i = 0; i < total_vfs; i++)
+		BLOCKING_INIT_NOTIFIER_HEAD(&sriov->vfs_ctx[i].notifier);
+
 	return 0;
 }
 
@@ -281,3 +294,53 @@ void mlx5_sriov_cleanup(struct mlx5_core_dev *dev)
 
 	kfree(sriov->vfs_ctx);
 }
+
+/**
+ * mlx5_sriov_blocking_notifier_unregister - Unregister a VF from
+ * a notification block chain.
+ *
+ * @mdev: The mlx5 core device.
+ * @vf_id: The VF id.
+ * @nb: The notifier block to be unregistered.
+ */
+void mlx5_sriov_blocking_notifier_unregister(struct mlx5_core_dev *mdev,
+					     int vf_id,
+					     struct notifier_block *nb)
+{
+	struct mlx5_vf_context *vfs_ctx;
+	struct mlx5_core_sriov *sriov;
+
+	sriov = &mdev->priv.sriov;
+	if (WARN_ON(vf_id < 0 || vf_id >= sriov->num_vfs))
+		return;
+
+	vfs_ctx = &sriov->vfs_ctx[vf_id];
+	blocking_notifier_chain_unregister(&vfs_ctx->notifier, nb);
+}
+EXPORT_SYMBOL(mlx5_sriov_blocking_notifier_unregister);
+
+/**
+ * mlx5_sriov_blocking_notifier_register - Register a VF notification
+ * block chain.
+ *
+ * @mdev: The mlx5 core device.
+ * @vf_id: The VF id.
+ * @nb: The notifier block to be called upon the VF events.
+ *
+ * Returns 0 on success or an error code.
+ */
+int mlx5_sriov_blocking_notifier_register(struct mlx5_core_dev *mdev,
+					  int vf_id,
+					  struct notifier_block *nb)
+{
+	struct mlx5_vf_context *vfs_ctx;
+	struct mlx5_core_sriov *sriov;
+
+	sriov = &mdev->priv.sriov;
+	if (vf_id < 0 || vf_id >= sriov->num_vfs)
+		return -EINVAL;
+
+	vfs_ctx = &sriov->vfs_ctx[vf_id];
+	return blocking_notifier_chain_register(&vfs_ctx->notifier, nb);
+}
+EXPORT_SYMBOL(mlx5_sriov_blocking_notifier_register);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 9424503eb8d3..3d1594bad4ec 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -445,6 +445,11 @@ struct mlx5_qp_table {
 	struct radix_tree_root	tree;
 };
 
+enum {
+	MLX5_PF_NOTIFY_DISABLE_VF,
+	MLX5_PF_NOTIFY_ENABLE_VF,
+};
+
 struct mlx5_vf_context {
 	int	enabled;
 	u64	port_guid;
@@ -455,6 +460,7 @@ struct mlx5_vf_context {
 	u8	port_guid_valid:1;
 	u8	node_guid_valid:1;
 	enum port_state_policy	policy;
+	struct blocking_notifier_head notifier;
 };
 
 struct mlx5_core_sriov {
@@ -1155,6 +1161,12 @@ int mlx5_dm_sw_icm_dealloc(struct mlx5_core_dev *dev, enum mlx5_sw_icm_type type
 struct mlx5_core_dev *mlx5_vf_get_core_dev(struct pci_dev *pdev);
 void mlx5_vf_put_core_dev(struct mlx5_core_dev *mdev);
 
+int mlx5_sriov_blocking_notifier_register(struct mlx5_core_dev *mdev,
+					  int vf_id,
+					  struct notifier_block *nb);
+void mlx5_sriov_blocking_notifier_unregister(struct mlx5_core_dev *mdev,
+					     int vf_id,
+					     struct notifier_block *nb);
 #ifdef CONFIG_MLX5_CORE_IPOIB
 struct net_device *mlx5_rdma_netdev_alloc(struct mlx5_core_dev *mdev,
 					  struct ib_device *ibdev,
-- 
2.35.1



