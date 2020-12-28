Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F1562E4267
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436854AbgL1OC1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:02:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436847AbgL1OC0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6048205CB;
        Mon, 28 Dec 2020 14:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164105;
        bh=//iPZgv/5Oxgw1Aje6SwUHOyp5G+5YVWCoZLgb+CgJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kMt/OhMHSLkILedfqtPVZw0yKxSUkxv4roHcBi9j+EenofBQt8jKfhZwqQ6sSVHtX
         s62R7HS2u5eyi4JScPB4x0Iea1O6nCvDp8fS1YPtJR3ghPeLf2mlJRkfbQh+XuKOMA
         Vt2HyPeDf/Ug20rcRpwmGeDn5r20pJ8n/6+Y5j7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/717] RDMA/mlx5: Fix corruption of reg_pages in mlx5_ib_rereg_user_mr()
Date:   Mon, 28 Dec 2020 13:40:42 +0100
Message-Id: <20201228125023.098950328@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit fc3325701a6353594083f08e297d4c1965c601aa ]

reg_pages should always contain mr->npage since when the mr is finally
de-reg'd it is always subtracted out.

If there were any error exits then mlx5_ib_rereg_user_mr() would leave the
reg_pages adjusted and this will cause it to be double subtracted
eventually.

The manipulation of reg_pages is inherently connected to the umem, so lift
it out of set_mr_fields() and only adjust it around creating/destroying a
umem.

reg_pages is only used for diagnostics in sysfs.

Fixes: 7d0cc6edcc70 ("IB/mlx5: Add MR cache for large UMR regions")
Link: https://lore.kernel.org/r/20201026131936.1335664-3-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index b261797b258fd..3468ae804eaee 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1247,10 +1247,8 @@ err_1:
 }
 
 static void set_mr_fields(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
-			  int npages, u64 length, int access_flags)
+			  u64 length, int access_flags)
 {
-	mr->npages = npages;
-	atomic_add(npages, &dev->mdev->priv.reg_pages);
 	mr->ibmr.lkey = mr->mmkey.key;
 	mr->ibmr.rkey = mr->mmkey.key;
 	mr->ibmr.length = length;
@@ -1290,8 +1288,7 @@ static struct ib_mr *mlx5_ib_get_dm_mr(struct ib_pd *pd, u64 start_addr,
 
 	kfree(in);
 
-	mr->umem = NULL;
-	set_mr_fields(dev, mr, 0, length, acc);
+	set_mr_fields(dev, mr, length, acc);
 
 	return &mr->ibmr;
 
@@ -1419,7 +1416,9 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mlx5_ib_dbg(dev, "mkey 0x%x\n", mr->mmkey.key);
 
 	mr->umem = umem;
-	set_mr_fields(dev, mr, npages, length, access_flags);
+	mr->npages = npages;
+	atomic_add(mr->npages, &dev->mdev->priv.reg_pages);
+	set_mr_fields(dev, mr, length, access_flags);
 
 	if (xlt_with_umr && !(access_flags & IB_ACCESS_ON_DEMAND)) {
 		/*
@@ -1531,8 +1530,6 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 	mlx5_ib_dbg(dev, "start 0x%llx, virt_addr 0x%llx, length 0x%llx, access_flags 0x%x\n",
 		    start, virt_addr, length, access_flags);
 
-	atomic_sub(mr->npages, &dev->mdev->priv.reg_pages);
-
 	if (!mr->umem)
 		return -EINVAL;
 
@@ -1553,12 +1550,17 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		 * used.
 		 */
 		flags |= IB_MR_REREG_TRANS;
+		atomic_sub(mr->npages, &dev->mdev->priv.reg_pages);
+		mr->npages = 0;
 		ib_umem_release(mr->umem);
 		mr->umem = NULL;
+
 		err = mr_umem_get(dev, addr, len, access_flags, &mr->umem,
 				  &npages, &page_shift, &ncont, &order);
 		if (err)
 			goto err;
+		mr->npages = ncont;
+		atomic_add(mr->npages, &dev->mdev->priv.reg_pages);
 	}
 
 	if (!mlx5_ib_can_reconfig_with_umr(dev, mr->access_flags,
@@ -1609,7 +1611,7 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 			goto err;
 	}
 
-	set_mr_fields(dev, mr, npages, len, access_flags);
+	set_mr_fields(dev, mr, len, access_flags);
 
 	return 0;
 
-- 
2.27.0



