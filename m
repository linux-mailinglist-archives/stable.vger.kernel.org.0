Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64BC4A6FBD
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730964AbfICQ2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:49644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730528AbfICQ17 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:27:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C6B9F238C6;
        Tue,  3 Sep 2019 16:27:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528078;
        bh=tUGdMBJf65IiFRyiMd6tSnbbwmB1wNqA8i8OFvyBO9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CY3XEip6PGTrxekHChuxHvldQmPbs5LU0quYXHi4SHgtVlSGK4FuHI91smmHlpLUS
         ttZdEKkUBPn4om+dk5qGH9oUaA7Gb2QVbfL6HRfoenYMaqU1zXU5HFcPlq8RsBPr8R
         VUnmo4te8qLC/LFRawLbXA8PC5HCjm6TYQlOOx9U=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Moni Shoua <monis@mellanox.com>,
        Jerome Glisse <jglisse@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 091/167] IB/mlx5: Reset access mask when looping inside page fault handler
Date:   Tue,  3 Sep 2019 12:24:03 -0400
Message-Id: <20190903162519.7136-91-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moni Shoua <monis@mellanox.com>

[ Upstream commit 1abe186ed8a6593069bc122da55fc684383fdc1c ]

If page-fault handler spans multiple MRs then the access mask needs to
be reset before each MR handling or otherwise write access will be
granted to mapped pages instead of read-only.

Cc: <stable@vger.kernel.org> # 3.19
Fixes: 7bdf65d411c1 ("IB/mlx5: Handle page faults")
Reported-by: Jerome Glisse <jglisse@redhat.com>
Signed-off-by: Moni Shoua <monis@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 9e1cac8cb2609..453e5c4ac19f4 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -497,7 +497,7 @@ void mlx5_ib_free_implicit_mr(struct mlx5_ib_mr *imr)
 static int pagefault_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
 			u64 io_virt, size_t bcnt, u32 *bytes_mapped)
 {
-	u64 access_mask = ODP_READ_ALLOWED_BIT;
+	u64 access_mask;
 	int npages = 0, page_shift, np;
 	u64 start_idx, page_mask;
 	struct ib_umem_odp *odp;
@@ -522,6 +522,7 @@ static int pagefault_mr(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr,
 	page_shift = mr->umem->page_shift;
 	page_mask = ~(BIT(page_shift) - 1);
 	start_idx = (io_virt - (mr->mmkey.iova & page_mask)) >> page_shift;
+	access_mask = ODP_READ_ALLOWED_BIT;
 
 	if (mr->umem->writable)
 		access_mask |= ODP_WRITE_ALLOWED_BIT;
-- 
2.20.1

