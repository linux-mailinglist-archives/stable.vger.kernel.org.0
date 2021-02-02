Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD70130C05E
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233201AbhBBN4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:56:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233303AbhBBNyP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:54:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C97AA64FCA;
        Tue,  2 Feb 2021 13:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273466;
        bh=9QO3HAl5UzbunPjjIeZWjmefY4swh79TeXMZvM736GI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUppybkdzmgaHZZqRK9AAOjwb+WvsMWXodOftZnPvYrtyt5KGHuS20VUSJUvo1TjH
         flu8OZlaEqwrt6CHEY0GEiwok53c6qmTPW8pOeuhpvH8Si1HcCkIwak6Z6KQjD9d2Y
         E0uwFSDq+mgL0Q5VYIMvDAXZv4kL9ugYUxJkqKK4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Jurgens <danielj@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 118/142] net/mlx5: Maintain separate page trees for ECPF and PF functions
Date:   Tue,  2 Feb 2021 14:38:01 +0100
Message-Id: <20210202133002.577295730@linuxfoundation.org>
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

From: Daniel Jurgens <danielj@nvidia.com>

[ Upstream commit 0aa128475d33d2d0095947eeab6b3e4d22dbd578 ]

Pages for the host PF and ECPF were stored in the same tree, so the ECPF
pages were being freed along with the host PF's when the host driver
unloaded.

Combine the function ID and ECPF flag to use as an index into the
x-array containing the trees to get a different tree for the host PF and
ECPF.

Fixes: c6168161f693 ("net/mlx5: Add support for release all pages event")
Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/pagealloc.c   | 58 +++++++++++--------
 1 file changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 4d7f8a357df76..a3e0c71831928 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -58,7 +58,7 @@ struct fw_page {
 	struct rb_node		rb_node;
 	u64			addr;
 	struct page	       *page;
-	u16			func_id;
+	u32			function;
 	unsigned long		bitmask;
 	struct list_head	list;
 	unsigned		free_count;
@@ -74,12 +74,17 @@ enum {
 	MLX5_NUM_4K_IN_PAGE		= PAGE_SIZE / MLX5_ADAPTER_PAGE_SIZE,
 };
 
-static struct rb_root *page_root_per_func_id(struct mlx5_core_dev *dev, u16 func_id)
+static u32 get_function(u16 func_id, bool ec_function)
+{
+	return func_id & (ec_function << 16);
+}
+
+static struct rb_root *page_root_per_function(struct mlx5_core_dev *dev, u32 function)
 {
 	struct rb_root *root;
 	int err;
 
-	root = xa_load(&dev->priv.page_root_xa, func_id);
+	root = xa_load(&dev->priv.page_root_xa, function);
 	if (root)
 		return root;
 
@@ -87,7 +92,7 @@ static struct rb_root *page_root_per_func_id(struct mlx5_core_dev *dev, u16 func
 	if (!root)
 		return ERR_PTR(-ENOMEM);
 
-	err = xa_insert(&dev->priv.page_root_xa, func_id, root, GFP_KERNEL);
+	err = xa_insert(&dev->priv.page_root_xa, function, root, GFP_KERNEL);
 	if (err) {
 		kfree(root);
 		return ERR_PTR(err);
@@ -98,7 +103,7 @@ static struct rb_root *page_root_per_func_id(struct mlx5_core_dev *dev, u16 func
 	return root;
 }
 
-static int insert_page(struct mlx5_core_dev *dev, u64 addr, struct page *page, u16 func_id)
+static int insert_page(struct mlx5_core_dev *dev, u64 addr, struct page *page, u32 function)
 {
 	struct rb_node *parent = NULL;
 	struct rb_root *root;
@@ -107,7 +112,7 @@ static int insert_page(struct mlx5_core_dev *dev, u64 addr, struct page *page, u
 	struct fw_page *tfp;
 	int i;
 
-	root = page_root_per_func_id(dev, func_id);
+	root = page_root_per_function(dev, function);
 	if (IS_ERR(root))
 		return PTR_ERR(root);
 
@@ -130,7 +135,7 @@ static int insert_page(struct mlx5_core_dev *dev, u64 addr, struct page *page, u
 
 	nfp->addr = addr;
 	nfp->page = page;
-	nfp->func_id = func_id;
+	nfp->function = function;
 	nfp->free_count = MLX5_NUM_4K_IN_PAGE;
 	for (i = 0; i < MLX5_NUM_4K_IN_PAGE; i++)
 		set_bit(i, &nfp->bitmask);
@@ -143,14 +148,14 @@ static int insert_page(struct mlx5_core_dev *dev, u64 addr, struct page *page, u
 }
 
 static struct fw_page *find_fw_page(struct mlx5_core_dev *dev, u64 addr,
-				    u32 func_id)
+				    u32 function)
 {
 	struct fw_page *result = NULL;
 	struct rb_root *root;
 	struct rb_node *tmp;
 	struct fw_page *tfp;
 
-	root = xa_load(&dev->priv.page_root_xa, func_id);
+	root = xa_load(&dev->priv.page_root_xa, function);
 	if (WARN_ON_ONCE(!root))
 		return NULL;
 
@@ -194,14 +199,14 @@ static int mlx5_cmd_query_pages(struct mlx5_core_dev *dev, u16 *func_id,
 	return err;
 }
 
-static int alloc_4k(struct mlx5_core_dev *dev, u64 *addr, u16 func_id)
+static int alloc_4k(struct mlx5_core_dev *dev, u64 *addr, u32 function)
 {
 	struct fw_page *fp = NULL;
 	struct fw_page *iter;
 	unsigned n;
 
 	list_for_each_entry(iter, &dev->priv.free_list, list) {
-		if (iter->func_id != func_id)
+		if (iter->function != function)
 			continue;
 		fp = iter;
 	}
@@ -231,7 +236,7 @@ static void free_fwp(struct mlx5_core_dev *dev, struct fw_page *fwp,
 {
 	struct rb_root *root;
 
-	root = xa_load(&dev->priv.page_root_xa, fwp->func_id);
+	root = xa_load(&dev->priv.page_root_xa, fwp->function);
 	if (WARN_ON_ONCE(!root))
 		return;
 
@@ -244,12 +249,12 @@ static void free_fwp(struct mlx5_core_dev *dev, struct fw_page *fwp,
 	kfree(fwp);
 }
 
-static void free_4k(struct mlx5_core_dev *dev, u64 addr, u32 func_id)
+static void free_4k(struct mlx5_core_dev *dev, u64 addr, u32 function)
 {
 	struct fw_page *fwp;
 	int n;
 
-	fwp = find_fw_page(dev, addr & MLX5_U64_4K_PAGE_MASK, func_id);
+	fwp = find_fw_page(dev, addr & MLX5_U64_4K_PAGE_MASK, function);
 	if (!fwp) {
 		mlx5_core_warn_rl(dev, "page not found\n");
 		return;
@@ -263,7 +268,7 @@ static void free_4k(struct mlx5_core_dev *dev, u64 addr, u32 func_id)
 		list_add(&fwp->list, &dev->priv.free_list);
 }
 
-static int alloc_system_page(struct mlx5_core_dev *dev, u16 func_id)
+static int alloc_system_page(struct mlx5_core_dev *dev, u32 function)
 {
 	struct device *device = mlx5_core_dma_dev(dev);
 	int nid = dev_to_node(device);
@@ -291,7 +296,7 @@ map:
 		goto map;
 	}
 
-	err = insert_page(dev, addr, page, func_id);
+	err = insert_page(dev, addr, page, function);
 	if (err) {
 		mlx5_core_err(dev, "failed to track allocated page\n");
 		dma_unmap_page(device, addr, PAGE_SIZE, DMA_BIDIRECTIONAL);
@@ -328,6 +333,7 @@ static void page_notify_fail(struct mlx5_core_dev *dev, u16 func_id,
 static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 		      int notify_fail, bool ec_function)
 {
+	u32 function = get_function(func_id, ec_function);
 	u32 out[MLX5_ST_SZ_DW(manage_pages_out)] = {0};
 	int inlen = MLX5_ST_SZ_BYTES(manage_pages_in);
 	u64 addr;
@@ -345,10 +351,10 @@ static int give_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 
 	for (i = 0; i < npages; i++) {
 retry:
-		err = alloc_4k(dev, &addr, func_id);
+		err = alloc_4k(dev, &addr, function);
 		if (err) {
 			if (err == -ENOMEM)
-				err = alloc_system_page(dev, func_id);
+				err = alloc_system_page(dev, function);
 			if (err)
 				goto out_4k;
 
@@ -384,7 +390,7 @@ retry:
 
 out_4k:
 	for (i--; i >= 0; i--)
-		free_4k(dev, MLX5_GET64(manage_pages_in, in, pas[i]), func_id);
+		free_4k(dev, MLX5_GET64(manage_pages_in, in, pas[i]), function);
 out_free:
 	kvfree(in);
 	if (notify_fail)
@@ -392,14 +398,15 @@ out_free:
 	return err;
 }
 
-static void release_all_pages(struct mlx5_core_dev *dev, u32 func_id,
+static void release_all_pages(struct mlx5_core_dev *dev, u16 func_id,
 			      bool ec_function)
 {
+	u32 function = get_function(func_id, ec_function);
 	struct rb_root *root;
 	struct rb_node *p;
 	int npages = 0;
 
-	root = xa_load(&dev->priv.page_root_xa, func_id);
+	root = xa_load(&dev->priv.page_root_xa, function);
 	if (WARN_ON_ONCE(!root))
 		return;
 
@@ -446,6 +453,7 @@ static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 	struct rb_root *root;
 	struct fw_page *fwp;
 	struct rb_node *p;
+	bool ec_function;
 	u32 func_id;
 	u32 npages;
 	u32 i = 0;
@@ -456,8 +464,9 @@ static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 	/* No hard feelings, we want our pages back! */
 	npages = MLX5_GET(manage_pages_in, in, input_num_entries);
 	func_id = MLX5_GET(manage_pages_in, in, function_id);
+	ec_function = MLX5_GET(manage_pages_in, in, embedded_cpu_function);
 
-	root = xa_load(&dev->priv.page_root_xa, func_id);
+	root = xa_load(&dev->priv.page_root_xa, get_function(func_id, ec_function));
 	if (WARN_ON_ONCE(!root))
 		return -EEXIST;
 
@@ -473,9 +482,10 @@ static int reclaim_pages_cmd(struct mlx5_core_dev *dev,
 	return 0;
 }
 
-static int reclaim_pages(struct mlx5_core_dev *dev, u32 func_id, int npages,
+static int reclaim_pages(struct mlx5_core_dev *dev, u16 func_id, int npages,
 			 int *nclaimed, bool ec_function)
 {
+	u32 function = get_function(func_id, ec_function);
 	int outlen = MLX5_ST_SZ_BYTES(manage_pages_out);
 	u32 in[MLX5_ST_SZ_DW(manage_pages_in)] = {};
 	int num_claimed;
@@ -514,7 +524,7 @@ static int reclaim_pages(struct mlx5_core_dev *dev, u32 func_id, int npages,
 	}
 
 	for (i = 0; i < num_claimed; i++)
-		free_4k(dev, MLX5_GET64(manage_pages_out, out, pas[i]), func_id);
+		free_4k(dev, MLX5_GET64(manage_pages_out, out, pas[i]), function);
 
 	if (nclaimed)
 		*nclaimed = num_claimed;
-- 
2.27.0



