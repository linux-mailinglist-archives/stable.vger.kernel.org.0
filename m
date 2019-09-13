Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A488BB2032
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389606AbfIMNSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390159AbfIMNSJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:18:09 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBA44206A5;
        Fri, 13 Sep 2019 13:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380688;
        bh=Mq16pXPlu4E1qSNNsJtz9KChW6TIknEWstPnqmQ7nJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zvbsVjBLZL7CKYyB2SVhUy4m/f5hLvkKR6XAofLcoGE6n36do+wl/BcFqSzV8gopY
         FK7SbGqJXomsYrIW+RYiwKPEmTs2tEtmRoTaKe8IxbjxbPGqixh3tas58cW2EdmX4G
         LaoEbkdyOp/pyZx3giM1Gq8Ml2G6SbPWBjajISqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jerome Glisse <jglisse@redhat.com>,
        Moni Shoua <monis@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/190] IB/mlx5: Reset access mask when looping inside page fault handler
Date:   Fri, 13 Sep 2019 14:06:07 +0100
Message-Id: <20190913130608.701812612@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
@@ -522,6 +522,7 @@ next_mr:
 	page_shift = mr->umem->page_shift;
 	page_mask = ~(BIT(page_shift) - 1);
 	start_idx = (io_virt - (mr->mmkey.iova & page_mask)) >> page_shift;
+	access_mask = ODP_READ_ALLOWED_BIT;
 
 	if (mr->umem->writable)
 		access_mask |= ODP_WRITE_ALLOWED_BIT;
-- 
2.20.1



