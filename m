Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 954BB15F429
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:23:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394701AbgBNSTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:19:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730538AbgBNPui (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:50:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B016B2086A;
        Fri, 14 Feb 2020 15:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695437;
        bh=sCO2mfmq57t7Vcdbn2D61ddsref8LHV6RcKdnIeoenw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cfzHwjMWkGP9+vQBvNED64fJBq6Bpl0TJaPuX4ztPR9rUrCgtkUCKRX9bBaCSkthH
         UOF5p2AmkS8VbsRfNIN0WmaEYJHz4OOngJgW6cyOxQSIYAuJvdcumhIRa6gibAHjMZ
         iXwDcB/TkoJroi5KyDF6R2C46Y1i4Qofq2FWw5n0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Moni Shoua <monis@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 079/542] RDMA/mlx5: Fix handling of IOVA != user_va in ODP paths
Date:   Fri, 14 Feb 2020 10:41:11 -0500
Message-Id: <20200214154854.6746-79-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit 8ffc32485158528f870b62707077ab494ba31deb ]

Till recently it was not possible for userspace to specify a different
IOVA, but with the new ibv_reg_mr_iova() library call this can be done.

To compute the user_va we must compute:
  user_va = (iova - iova_start) + user_va_start

while being cautious of overflow and other math problems.

The iova is not reliably stored in the mmkey when the MR is created. Only
the cached creation path (the common one) set it, so it must also be set
when creating uncached MRs.

Fix the weird use of iova when computing the starting page index in the
MR. In the normal case, when iova == umem.address:
  iova & (~(BIT(page_shift) - 1)) ==
  ALIGN_DOWN(umem.address, odp->page_size) ==
  ib_umem_start(odp)

And when iova is different using it in math with a user_va is wrong.

Finally, do not allow an implicit ODP to be created with a non-zero IOVA
as we have no support for that.

Fixes: 7bdf65d411c1 ("IB/mlx5: Handle page faults")
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c  |  2 ++
 drivers/infiniband/hw/mlx5/odp.c | 19 +++++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index ea8bfc3e2d8d4..23c4529edf540 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1247,6 +1247,8 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 
 	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && !start &&
 	    length == U64_MAX) {
+		if (virt_addr != start)
+			return ERR_PTR(-EINVAL);
 		if (!(access_flags & IB_ACCESS_ON_DEMAND) ||
 		    !(dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
 			return ERR_PTR(-EINVAL);
diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index f924250f80c2e..8247c26a1ce92 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -624,11 +624,10 @@ static int pagefault_real_mr(struct mlx5_ib_mr *mr, struct ib_umem_odp *odp,
 	bool downgrade = flags & MLX5_PF_FLAGS_DOWNGRADE;
 	unsigned long current_seq;
 	u64 access_mask;
-	u64 start_idx, page_mask;
+	u64 start_idx;
 
 	page_shift = odp->page_shift;
-	page_mask = ~(BIT(page_shift) - 1);
-	start_idx = (user_va - (mr->mmkey.iova & page_mask)) >> page_shift;
+	start_idx = (user_va - ib_umem_start(odp)) >> page_shift;
 	access_mask = ODP_READ_ALLOWED_BIT;
 
 	if (odp->umem.writable && !downgrade)
@@ -767,11 +766,19 @@ static int pagefault_mr(struct mlx5_ib_mr *mr, u64 io_virt, size_t bcnt,
 {
 	struct ib_umem_odp *odp = to_ib_umem_odp(mr->umem);
 
+	if (unlikely(io_virt < mr->mmkey.iova))
+		return -EFAULT;
+
 	if (!odp->is_implicit_odp) {
-		if (unlikely(io_virt < ib_umem_start(odp) ||
-			     ib_umem_end(odp) - io_virt < bcnt))
+		u64 user_va;
+
+		if (check_add_overflow(io_virt - mr->mmkey.iova,
+				       (u64)odp->umem.address, &user_va))
+			return -EFAULT;
+		if (unlikely(user_va >= ib_umem_end(odp) ||
+			     ib_umem_end(odp) - user_va < bcnt))
 			return -EFAULT;
-		return pagefault_real_mr(mr, odp, io_virt, bcnt, bytes_mapped,
+		return pagefault_real_mr(mr, odp, user_va, bcnt, bytes_mapped,
 					 flags);
 	}
 	return pagefault_implicit_mr(mr, odp, io_virt, bcnt, bytes_mapped,
-- 
2.20.1

