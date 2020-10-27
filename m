Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFC029B957
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766405AbgJ0Prv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:58934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801312AbgJ0Pja (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:39:30 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D9F92225E;
        Tue, 27 Oct 2020 15:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813169;
        bh=WaaiZfKODcM9Bu4Iyr7nvRfT1XVC9seI9DbJYNnyxn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1ZDSam6mEGFwMwPU7wIJ4dSj3uXLRrB7LkB0IYTT2KozRhvNzdl19DPu2WegeiZBm
         aM8IuotdfQo2e23HmghG19939av+TamSbKQwdsBfXrMe0+6Ak39S8VOaZ7gMSvf7e+
         Sv5YBZjzdqdS3KaTx7O4x7l1rkYvnojgEiLSxKzE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 460/757] RDMA/mlx5: Use set_mkc_access_pd_addr_fields() in reg_create()
Date:   Tue, 27 Oct 2020 14:51:50 +0100
Message-Id: <20201027135512.092477537@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 1c97ca3da0d12e0156a177f48ed3184c3f202002 ]

reg_create() open codes this helper, use the shared code.

Link: https://lore.kernel.org/r/20200914112653.345244-3-leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 3e6f2f9c66555..8f5d36f32529e 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1190,29 +1190,16 @@ static struct mlx5_ib_mr *reg_create(struct ib_mr *ibmr, struct ib_pd *pd,
 	MLX5_SET(create_mkey_in, in, pg_access, !!(pg_cap));
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	set_mkc_access_pd_addr_fields(mkc, access_flags, virt_addr, pd);
 	MLX5_SET(mkc, mkc, free, !populate);
 	MLX5_SET(mkc, mkc, access_mode_1_0, MLX5_MKC_ACCESS_MODE_MTT);
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_write))
-		MLX5_SET(mkc, mkc, relaxed_ordering_write,
-			 !!(access_flags & IB_ACCESS_RELAXED_ORDERING));
-	if (MLX5_CAP_GEN(dev->mdev, relaxed_ordering_read))
-		MLX5_SET(mkc, mkc, relaxed_ordering_read,
-			 !!(access_flags & IB_ACCESS_RELAXED_ORDERING));
-	MLX5_SET(mkc, mkc, a, !!(access_flags & IB_ACCESS_REMOTE_ATOMIC));
-	MLX5_SET(mkc, mkc, rw, !!(access_flags & IB_ACCESS_REMOTE_WRITE));
-	MLX5_SET(mkc, mkc, rr, !!(access_flags & IB_ACCESS_REMOTE_READ));
-	MLX5_SET(mkc, mkc, lw, !!(access_flags & IB_ACCESS_LOCAL_WRITE));
-	MLX5_SET(mkc, mkc, lr, 1);
 	MLX5_SET(mkc, mkc, umr_en, 1);
 
-	MLX5_SET64(mkc, mkc, start_addr, virt_addr);
 	MLX5_SET64(mkc, mkc, len, length);
-	MLX5_SET(mkc, mkc, pd, to_mpd(pd)->pdn);
 	MLX5_SET(mkc, mkc, bsf_octword_size, 0);
 	MLX5_SET(mkc, mkc, translations_octword_size,
 		 get_octo_len(virt_addr, length, page_shift));
 	MLX5_SET(mkc, mkc, log_page_size, page_shift);
-	MLX5_SET(mkc, mkc, qpn, 0xffffff);
 	if (populate) {
 		MLX5_SET(create_mkey_in, in, translations_octword_actual_size,
 			 get_octo_len(virt_addr, length, page_shift));
-- 
2.25.1



