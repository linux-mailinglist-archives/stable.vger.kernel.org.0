Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4C8115C31D
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729557AbgBMP2G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:28:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:54198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729548AbgBMP2F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:28:05 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCCDF20661;
        Thu, 13 Feb 2020 15:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607684;
        bh=D0VFgF0KUyoRWh3UyMx5s9aPCETw1nMcu79+b7qUyDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bSp4W2oyTtusP9+LOgTsmv0OwH3W3KGfTK10Z/blervckgdiKR3XrJXrylcWsAM75
         D1Gft2c3UoeQ+nerm9s4aynYsbe3VWeL/i8CjMPQGQXybN+hB1liptr/UwFnsr1ToA
         iDaFl+P3/ywf/tM18iq6JlFzcGrB4bj7aHUbBkHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moni Shoua <monis@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Subject: [PATCH 5.5 009/120] RDMA/mlx5: Fix handling of IOVA != user_va in ODP paths
Date:   Thu, 13 Feb 2020 07:20:05 -0800
Message-Id: <20200213151904.724551439@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151901.039700531@linuxfoundation.org>
References: <20200213151901.039700531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

commit 8ffc32485158528f870b62707077ab494ba31deb upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/mlx5/mr.c  |    2 ++
 drivers/infiniband/hw/mlx5/odp.c |   19 +++++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1247,6 +1247,8 @@ struct ib_mr *mlx5_ib_reg_user_mr(struct
 
 	if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && !start &&
 	    length == U64_MAX) {
+		if (virt_addr != start)
+			return ERR_PTR(-EINVAL);
 		if (!(access_flags & IB_ACCESS_ON_DEMAND) ||
 		    !(dev->odp_caps.general_caps & IB_ODP_SUPPORT_IMPLICIT))
 			return ERR_PTR(-EINVAL);
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -624,11 +624,10 @@ static int pagefault_real_mr(struct mlx5
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
@@ -767,11 +766,19 @@ static int pagefault_mr(struct mlx5_ib_m
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


