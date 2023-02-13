Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 180196948ED
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjBMOy0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjBMOyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:54:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D2FF5FE0
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:54:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4C26610A4
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0607AC433EF;
        Mon, 13 Feb 2023 14:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300062;
        bh=I9WX3NdhOf8W4nOc6FOqTXl65pSFe3A0z+4tD/SFhAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LnBIuKeHPEE5H/gYP/3NBzGMkYRlkA0XN2ArwBuTVQaEe0Z8KPqQ6poFtXriymvpO
         SlwgKHq3xjfKSeLFjF0Qk02Qf52SEvA1ZH7y6OEMsqEILjxqt46RBBYJeoxLP94Dmh
         AWTMpbhSpSF/u+fwolzy9vor6vhjfCEmqbNCcuf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maher Sanalla <msanalla@nvidia.com>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/114] net/mlx5: Store page counters in a single array
Date:   Mon, 13 Feb 2023 15:48:04 +0100
Message-Id: <20230213144744.725219419@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit c3bdbaea654d8df39112de33037106134a520dc7 ]

Currently, an independent page counter is used for tracking memory usage
for each function type such as VF, PF and host PF (DPU).

For better code-readibilty, use a single array that stores
the number of allocated memory pages for each function type.

Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 9965bbebae59 ("net/mlx5: Expose SF firmware pages counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/debugfs.c |  4 +-
 .../net/ethernet/mellanox/mlx5/core/ecpf.c    |  2 +-
 .../ethernet/mellanox/mlx5/core/pagealloc.c   | 37 +++++++++++--------
 .../net/ethernet/mellanox/mlx5/core/sriov.c   |  2 +-
 include/linux/mlx5/driver.h                   | 12 ++++--
 5 files changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
index 3e232a65a0c3e..c3e7c24a0971e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/debugfs.c
@@ -245,8 +245,8 @@ void mlx5_pages_debugfs_init(struct mlx5_core_dev *dev)
 	pages = dev->priv.dbg.pages_debugfs;
 
 	debugfs_create_u32("fw_pages_total", 0400, pages, &dev->priv.fw_pages);
-	debugfs_create_u32("fw_pages_vfs", 0400, pages, &dev->priv.vfs_pages);
-	debugfs_create_u32("fw_pages_host_pf", 0400, pages, &dev->priv.host_pf_pages);
+	debugfs_create_u32("fw_pages_vfs", 0400, pages, &dev->priv.page_counters[MLX5_VF]);
+	debugfs_create_u32("fw_pages_host_pf", 0400, pages, &dev->priv.page_counters[MLX5_HOST_PF]);
 	debugfs_create_u32("fw_pages_alloc_failed", 0400, pages, &dev->priv.fw_pages_alloc_failed);
 	debugfs_create_u32("fw_pages_give_dropped", 0400, pages, &dev->priv.give_pages_dropped);
 	debugfs_create_u32("fw_pages_reclaim_discard", 0400, pages,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
index 464eb3a184506..cdc87ecae5d39 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/ecpf.c
@@ -87,7 +87,7 @@ void mlx5_ec_cleanup(struct mlx5_core_dev *dev)
 
 	mlx5_host_pf_cleanup(dev);
 
-	err = mlx5_wait_for_pages(dev, &dev->priv.host_pf_pages);
+	err = mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_HOST_PF]);
 	if (err)
 		mlx5_core_warn(dev, "Timeout reclaiming external host PF pages err(%d)\n", err);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 60596357bfc7a..9f99292ab5ced 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -74,6 +74,14 @@ static u32 get_function(u16 func_id, bool ec_function)
 	return (u32)func_id | (ec_function << 16);
 }
 
+static u16 func_id_to_type(struct mlx5_core_dev *dev, u16 func_id, bool ec_function)
+{
+	if (!func_id)
+		return mlx5_core_is_ecpf(dev) && !ec_function ? MLX5_HOST_PF : MLX5_PF;
+
+	return MLX5_VF;
+}
+
 static struct rb_root *page_root_per_function(struct mlx5_core_dev *dev, u32 function)
 {
 	struct rb_root *root;
@@ -332,6 +340,7 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 	u32 out[MLX5_ST_SZ_DW(manage_pages_out)] = {0};
 	int inlen = MLX5_ST_SZ_BYTES(manage_pages_in);
 	int notify_fail = event;
+	u16 func_type;
 	u64 addr;
 	int err;
 	u32 *in;
@@ -383,11 +392,9 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 		goto out_dropped;
 	}
 
+	func_type = func_id_to_type(dev, func_id, ec_function);
+	dev->priv.page_counters[func_type] += npages;
 	dev->priv.fw_pages += npages;
-	if (func_id)
-		dev->priv.vfs_pages += npages;
-	else if (mlx5_core_is_ecpf(dev) && !ec_function)
-		dev->priv.host_pf_pages += npages;
 
 	mlx5_core_dbg(dev, "npages %d, ec_function %d, func_id 0x%x, err %d\n",
 		      npages, ec_function, func_id, err);
@@ -414,6 +421,7 @@ static void release_all_pages(struct mlx5_core_dev *dev, u16 func_id,
 	struct rb_root *root;
 	struct rb_node *p;
 	int npages = 0;
+	u16 func_type;
 
 	root = xa_load(&dev->priv.page_root_xa, function);
 	if (WARN_ON_ONCE(!root))
@@ -428,11 +436,9 @@ static void release_all_pages(struct mlx5_core_dev *dev, u16 func_id,
 		free_fwp(dev, fwp, fwp->free_count);
 	}
 
+	func_type = func_id_to_type(dev, func_id, ec_function);
+	dev->priv.page_counters[func_type] -= npages;
 	dev->priv.fw_pages -= npages;
-	if (func_id)
-		dev->priv.vfs_pages -= npages;
-	else if (mlx5_core_is_ecpf(dev) && !ec_function)
-		dev->priv.host_pf_pages -= npages;
 
 	mlx5_core_dbg(dev, "npages %d, ec_function %d, func_id 0x%x\n",
 		      npages, ec_function, func_id);
@@ -498,6 +504,7 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 	int outlen = MLX5_ST_SZ_BYTES(manage_pages_out);
 	u32 in[MLX5_ST_SZ_DW(manage_pages_in)] = {};
 	int num_claimed;
+	u16 func_type;
 	u32 *out;
 	int err;
 	int i;
@@ -549,11 +556,9 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 	if (nclaimed)
 		*nclaimed = num_claimed;
 
+	func_type = func_id_to_type(dev, func_id, ec_function);
+	dev->priv.page_counters[func_type] -= num_claimed;
 	dev->priv.fw_pages -= num_claimed;
-	if (func_id)
-		dev->priv.vfs_pages -= num_claimed;
-	else if (mlx5_core_is_ecpf(dev) && !ec_function)
-		dev->priv.host_pf_pages -= num_claimed;
 
 out_free:
 	kvfree(out);
@@ -706,12 +711,12 @@ int mlx5_reclaim_startup_pages(struct mlx5_core_dev *dev)
 	WARN(dev->priv.fw_pages,
 	     "FW pages counter is %d after reclaiming all pages\n",
 	     dev->priv.fw_pages);
-	WARN(dev->priv.vfs_pages,
+	WARN(dev->priv.page_counters[MLX5_VF],
 	     "VFs FW pages counter is %d after reclaiming all pages\n",
-	     dev->priv.vfs_pages);
-	WARN(dev->priv.host_pf_pages,
+	     dev->priv.page_counters[MLX5_VF]);
+	WARN(dev->priv.page_counters[MLX5_HOST_PF],
 	     "External host PF FW pages counter is %d after reclaiming all pages\n",
-	     dev->priv.host_pf_pages);
+	     dev->priv.page_counters[MLX5_HOST_PF]);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
index c0e6c487c63c1..3008e9ce2bbff 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sriov.c
@@ -147,7 +147,7 @@ mlx5_device_disable_sriov(struct mlx5_core_dev *dev, int num_vfs, bool clear_vf)
 
 	mlx5_eswitch_disable_sriov(dev->priv.eswitch, clear_vf);
 
-	if (mlx5_wait_for_pages(dev, &dev->priv.vfs_pages))
+	if (mlx5_wait_for_pages(dev, &dev->priv.page_counters[MLX5_VF]))
 		mlx5_core_warn(dev, "timeout reclaiming VFs pages\n");
 }
 
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index ad55470a9fb97..9b300aa4eb953 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -573,6 +573,13 @@ struct mlx5_debugfs_entries {
 	struct dentry *lag_debugfs;
 };
 
+enum mlx5_func_type {
+	MLX5_PF,
+	MLX5_VF,
+	MLX5_HOST_PF,
+	MLX5_FUNC_TYPE_NUM,
+};
+
 struct mlx5_ft_pool;
 struct mlx5_priv {
 	/* IRQ table valid only for real pci devices PF or VF */
@@ -583,11 +590,10 @@ struct mlx5_priv {
 	struct mlx5_nb          pg_nb;
 	struct workqueue_struct *pg_wq;
 	struct xarray           page_root_xa;
-	u32			fw_pages;
 	atomic_t		reg_pages;
 	struct list_head	free_list;
-	u32			vfs_pages;
-	u32			host_pf_pages;
+	u32			fw_pages;
+	u32			page_counters[MLX5_FUNC_TYPE_NUM];
 	u32			fw_pages_alloc_failed;
 	u32			give_pages_dropped;
 	u32			reclaim_pages_discard;
-- 
2.39.0



