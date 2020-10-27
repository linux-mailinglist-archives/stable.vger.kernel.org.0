Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5948C29B51A
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1793760AbgJ0PIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:08:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:40306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1791399AbgJ0PGG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:06:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AE93F206E5;
        Tue, 27 Oct 2020 15:06:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811166;
        bh=VIvM5yUhfd3nrC/6/mPWDkxsAj/Qj4BEAy/aXDukdPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jfBTQ819lpin0ULIK8j1InffPOBYx+ZsC6XLl8EMGI28KL7f5Qe3jm+P0zWuIlIUH
         7qqe67Q0LURpTQ12cX5R8G+V8jFsffgt5ohHXhnl/UbSkCXdzXt8O7QDJqfaLdq68J
         sl3lWOskbQcwGmQkKs43mq5GuTRbhNvu7g3VLmSg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 379/633] RDMA/mlx5: Make mkeys always owned by the kernels PD when not enabled
Date:   Tue, 27 Oct 2020 14:52:02 +0100
Message-Id: <20201027135540.485898888@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 5eb29f0d13a66502b91954597270003c90fb66c5 ]

Any mkey that is not enabled and assigned to userspace should have the PD
set to a kernel owned PD.

When cache entries are created for the first time the PDN is set to 0,
which is probably a kernel PD, but be explicit.

When a MR is registered using the hybrid reg_create with UMR xlt & enable
the disabled mkey is pointing at the user PD, keep it pointing at the
kernel until a UMR enables it and sets the user PD.

Fixes: 9ec4483a3f0f ("IB/mlx5: Move MRs to a kernel PD when freeing them to the MR cache")
Link: https://lore.kernel.org/r/20200914112653.345244-4-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 51 +++++++++++++++++----------------
 1 file changed, 26 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 8d975c4d93060..85c9a1ffdbb64 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -50,6 +50,29 @@ enum {
 static void
 create_mkey_callback(int status, struct mlx5_async_work *context);
 
+static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
+					  struct ib_pd *pd)
+{
+	struct mlx5_ib_dev *dev = to_mdev(pd->device);
+
+	MLX5_SET(mkc, mkc, a, !!(acc & IB_ACCESS_REMOTE_ATOMIC));
+	MLX5_SET(mkc, mkc, rw, !!(acc & IB_ACCESS_REMOTE_WRITE));
+	MLX5_SET(mkc, mkc, rr, !!(acc & IB_ACCESS_REMOTE_READ));
+	MLX5_SET(mkc, mkc, lw, !!(acc & IB_ACCESS_LOCAL_WRITE));
+	MLX5_SET(mkc, mkc, lr, 1);
+
+	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write))
+		MLX5_SET(mkc, mkc, relaxed_ordering_write,
+			 !!(acc & IB_ACCESS_RELAXED_ORDERING));
+	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read))
+		MLX5_SET(mkc, mkc, relaxed_ordering_read,
+			 !!(acc & IB_ACCESS_RELAXED_ORDERING));
+
+	MLX5_SET(mkc, mkc, pd, to_mpd(pd)->pdn);
+	MLX5_SET(mkc, mkc, qpn, 0xffffff);
+	MLX5_SET64(mkc, mkc, start_addr, start_addr);
+}
+
 static void
 assign_mkey_variant(struct mlx5_ib_dev *dev, struct mlx5_core_mkey *mkey,
 		    u32 *in)
@@ -152,12 +175,12 @@ static struct mlx5_ib_mr *alloc_cache_mr(struct mlx5_cache_ent *ent, void *mkc)
 	mr->cache_ent = ent;
 	mr->dev = ent->dev;
 
+	set_mkc_access_pd_addr_fields(mkc, 0, 0, ent->dev->umrc.pd);
 	MLX5_SET(mkc, mkc, free, 1);
 	MLX5_SET(mkc, mkc, umr_en, 1);
 	MLX5_SET(mkc, mkc, access_mode_1_0, ent->access_mode & 0x3);
 	MLX5_SET(mkc, mkc, access_mode_4_2, (ent->access_mode >> 2) & 0x7);
 
-	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	MLX5_SET(mkc, mkc, translations_octword_size, ent->xlt);
 	MLX5_SET(mkc, mkc, log_page_size, ent->page);
 	return mr;
@@ -774,29 +797,6 @@ int mlx5_mr_cache_cleanup(struct mlx5_ib_dev *dev)
 	return 0;
 }
 
-static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
-					  struct ib_pd *pd)
-{
-	struct mlx5_ib_dev *dev = to_mdev(pd->device);
-
-	MLX5_SET(mkc, mkc, a, !!(acc & IB_ACCESS_REMOTE_ATOMIC));
-	MLX5_SET(mkc, mkc, rw, !!(acc & IB_ACCESS_REMOTE_WRITE));
-	MLX5_SET(mkc, mkc, rr, !!(acc & IB_ACCESS_REMOTE_READ));
-	MLX5_SET(mkc, mkc, lw, !!(acc & IB_ACCESS_LOCAL_WRITE));
-	MLX5_SET(mkc, mkc, lr, 1);
-
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write))
-		MLX5_SET(mkc, mkc, relaxed_ordering_write,
-			 !!(acc & IB_ACCESS_RELAXED_ORDERING));
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read))
-		MLX5_SET(mkc, mkc, relaxed_ordering_read,
-			 !!(acc & IB_ACCESS_RELAXED_ORDERING));
-
-	MLX5_SET(mkc, mkc, pd, to_mpd(pd)->pdn);
-	MLX5_SET(mkc, mkc, qpn, 0xffffff);
-	MLX5_SET64(mkc, mkc, start_addr, start_addr);
-}
-
 struct ib_mr *mlx5_ib_get_dma_mr(struct ib_pd *pd, int acc)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
@@ -1190,7 +1190,8 @@ static struct mlx5_ib_mr *reg_create(struct ib_mr *ibmr, struct ib_pd *pd,
 	MLX5_SET(create_mkey_in, in, pg_access, !!(pg_cap));
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
-	set_mkc_access_pd_addr_fields(mkc, access_flags, virt_addr, pd);
+	set_mkc_access_pd_addr_fields(mkc, access_flags, virt_addr,
+				      populate ? pd : dev->umrc.pd);
 	MLX5_SET(mkc, mkc, free, !populate);
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
 	MLX5_SET(mkc, mkc, umr_en, 1);
-- 
2.25.1



