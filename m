Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB8F02E4042
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:51:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392053AbgL1OUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:20:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:54492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392050AbgL1OT6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 504362063A;
        Mon, 28 Dec 2020 14:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165177;
        bh=fvN/XZ2n5D6gRpYIFYl/cHckEs4tpp9ZV7jkXmARuy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qWyxHz7FmKoS2kblyZAy+Dy6dFlp3bCeM22iyQeafv9X3DeAlQywYQVBcRIVOuSLo
         YEESVDPJJyPy126+lolrm3pWaJvPqOKNfIITwtWYdTNIoHP2dV1V3A1WatNXrsGU0g
         GEmI69IXLYwXdYhLypdOPWTjVpu48srr41M0htXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maor Gottlieb <maorg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 438/717] RDMA/mlx5: Fix MR cache memory leak
Date:   Mon, 28 Dec 2020 13:47:16 +0100
Message-Id: <20201228125041.953875660@linuxfoundation.org>
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

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit e89938902927a54abebccc9537991aca5237dfaf ]

If the MR cache entry invalidation failed, then we detach this entry from
the cache, therefore we must to free the memory as well.

Allcation backtrace for the leaker:

    [<00000000d8e423b0>] alloc_cache_mr+0x23/0xc0 [mlx5_ib]
    [<000000001f21304c>] create_cache_mr+0x3f/0xf0 [mlx5_ib]
    [<000000009d6b45dc>] mlx5_ib_alloc_implicit_mr+0x41/0×210 [mlx5_ib]
    [<00000000879d0d68>] mlx5_ib_reg_user_mr+0x9e/0×6e0 [mlx5_ib]
    [<00000000be74bf89>] create_qp+0x2fc/0xf00 [ib_uverbs]
    [<000000001a532d22>] ib_uverbs_handler_UVERBS_METHOD_COUNTERS_READ+0x1d9/0×230 [ib_uverbs]
    [<0000000070f46001>] rdma_alloc_commit_uobject+0xb5/0×120 [ib_uverbs]
    [<000000006d8a0b38>] uverbs_alloc+0x2b/0xf0 [ib_uverbs]
    [<00000000075217c9>] ksysioctl+0x234/0×7d0
    [<00000000eb5c120b>] __x64_sys_ioctl+0x16/0×20
    [<00000000db135b48>] do_syscall_64+0x59/0×2e0

Fixes: 1769c4c57548 ("RDMA/mlx5: Always remove MRs from the cache before destroying them")
Link: https://lore.kernel.org/r/20201213132940.345554-2-leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 3468ae804eaee..971694e781b65 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -642,6 +642,7 @@ void mlx5_mr_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 	if (mlx5_mr_cache_invalidate(mr)) {
 		detach_mr_from_cache(mr);
 		destroy_mkey(dev, mr);
+		kfree(mr);
 		return;
 	}
 
-- 
2.27.0



