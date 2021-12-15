Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7D0475E8C
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245380AbhLORXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:23:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245330AbhLORWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:22:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B99C061574;
        Wed, 15 Dec 2021 09:22:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2EC8B619E1;
        Wed, 15 Dec 2021 17:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 182C2C36AE2;
        Wed, 15 Dec 2021 17:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588970;
        bh=UqL2YXfY29DZ3sC0LVdMqZH8PCsag9Z23JDlXJ4fnf8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cuBCLVC64xVJdt3iQYl6rafTw85swWHL7xzAzfwYbOZ0hjMPkoxPMnt7WVQEXd24c
         fYyJY1JDTr0MEf5c84NP1kHgLSVlo8mzlQCNBlR3SxunpYmiPmim4QkEj1WwZpsEvf
         313IC8sRgJKJBcCWMJq7XQ55n5z8SH37o+vj6qnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alaa Hleihel <alaa@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 04/42] RDMA/mlx5: Fix releasing unallocated memory in dereg MR flow
Date:   Wed, 15 Dec 2021 18:20:45 +0100
Message-Id: <20211215172026.789963312@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alaa Hleihel <alaa@nvidia.com>

[ Upstream commit f0ae4afe3d35e67db042c58a52909e06262b740f ]

For the case of IB_MR_TYPE_DM the mr does doesn't have a umem, even though
it is a user MR. This causes function mlx5_free_priv_descs() to think that
it is a kernel MR, leading to wrongly accessing mr->descs that will get
wrong values in the union which leads to attempt to release resources that
were not allocated in the first place.

For example:
 DMA-API: mlx5_core 0000:08:00.1: device driver tries to free DMA memory it has not allocated [device address=0x0000000000000000] [size=0 bytes]
 WARNING: CPU: 8 PID: 1021 at kernel/dma/debug.c:961 check_unmap+0x54f/0x8b0
 RIP: 0010:check_unmap+0x54f/0x8b0
 Call Trace:
  debug_dma_unmap_page+0x57/0x60
  mlx5_free_priv_descs+0x57/0x70 [mlx5_ib]
  mlx5_ib_dereg_mr+0x1fb/0x3d0 [mlx5_ib]
  ib_dereg_mr_user+0x60/0x140 [ib_core]
  uverbs_destroy_uobject+0x59/0x210 [ib_uverbs]
  uobj_destroy+0x3f/0x80 [ib_uverbs]
  ib_uverbs_cmd_verbs+0x435/0xd10 [ib_uverbs]
  ? uverbs_finalize_object+0x50/0x50 [ib_uverbs]
  ? lock_acquire+0xc4/0x2e0
  ? lock_acquired+0x12/0x380
  ? lock_acquire+0xc4/0x2e0
  ? lock_acquire+0xc4/0x2e0
  ? ib_uverbs_ioctl+0x7c/0x140 [ib_uverbs]
  ? lock_release+0x28a/0x400
  ib_uverbs_ioctl+0xc0/0x140 [ib_uverbs]
  ? ib_uverbs_ioctl+0x7c/0x140 [ib_uverbs]
  __x64_sys_ioctl+0x7f/0xb0
  do_syscall_64+0x38/0x90

Fix it by reorganizing the dereg flow and mlx5_ib_mr structure:
 - Move the ib_umem field into the user MRs structure in the union as it's
   applicable only there.
 - Function mlx5_ib_dereg_mr() will now call mlx5_free_priv_descs() only
   in case there isn't udata, which indicates that this isn't a user MR.

Fixes: f18ec4223117 ("RDMA/mlx5: Use a union inside mlx5_ib_mr")
Link: https://lore.kernel.org/r/66bb1dd253c1fd7ceaa9fc411061eefa457b86fb.1637581144.git.leonro@nvidia.com
Signed-off-by: Alaa Hleihel <alaa@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 +++---
 drivers/infiniband/hw/mlx5/mr.c      | 26 ++++++++++++--------------
 2 files changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index bf20a388eabe1..6204ae2caef58 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -641,7 +641,6 @@ struct mlx5_ib_mr {
 
 	/* User MR data */
 	struct mlx5_cache_ent *cache_ent;
-	struct ib_umem *umem;
 
 	/* This is zero'd when the MR is allocated */
 	union {
@@ -653,7 +652,7 @@ struct mlx5_ib_mr {
 			struct list_head list;
 		};
 
-		/* Used only by kernel MRs (umem == NULL) */
+		/* Used only by kernel MRs */
 		struct {
 			void *descs;
 			void *descs_alloc;
@@ -675,8 +674,9 @@ struct mlx5_ib_mr {
 			int data_length;
 		};
 
-		/* Used only by User MRs (umem != NULL) */
+		/* Used only by User MRs */
 		struct {
+			struct ib_umem *umem;
 			unsigned int page_shift;
 			/* Current access_flags */
 			int access_flags;
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 22e2f4d79743d..69b2ce4c292ae 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1911,19 +1911,18 @@ mlx5_alloc_priv_descs(struct ib_device *device,
 	return ret;
 }
 
-static void
-mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
+static void mlx5_free_priv_descs(struct mlx5_ib_mr *mr)
 {
-	if (!mr->umem && mr->descs) {
-		struct ib_device *device = mr->ibmr.device;
-		int size = mr->max_descs * mr->desc_size;
-		struct mlx5_ib_dev *dev = to_mdev(device);
+	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
+	int size = mr->max_descs * mr->desc_size;
 
-		dma_unmap_single(&dev->mdev->pdev->dev, mr->desc_map, size,
-				 DMA_TO_DEVICE);
-		kfree(mr->descs_alloc);
-		mr->descs = NULL;
-	}
+	if (!mr->descs)
+		return;
+
+	dma_unmap_single(&dev->mdev->pdev->dev, mr->desc_map, size,
+			 DMA_TO_DEVICE);
+	kfree(mr->descs_alloc);
+	mr->descs = NULL;
 }
 
 int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
@@ -1999,7 +1998,8 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 	if (mr->cache_ent) {
 		mlx5_mr_cache_free(dev, mr);
 	} else {
-		mlx5_free_priv_descs(mr);
+		if (!udata)
+			mlx5_free_priv_descs(mr);
 		kfree(mr);
 	}
 	return 0;
@@ -2086,7 +2086,6 @@ static struct mlx5_ib_mr *mlx5_ib_alloc_pi_mr(struct ib_pd *pd,
 	if (err)
 		goto err_free_in;
 
-	mr->umem = NULL;
 	kfree(in);
 
 	return mr;
@@ -2213,7 +2212,6 @@ static struct ib_mr *__mlx5_ib_alloc_mr(struct ib_pd *pd,
 	}
 
 	mr->ibmr.device = pd->device;
-	mr->umem = NULL;
 
 	switch (mr_type) {
 	case IB_MR_TYPE_MEM_REG:
-- 
2.33.0



