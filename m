Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F725DD4B0
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406089AbfJRW0a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:26:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:35860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727892AbfJRWEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:04:14 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67519222C5;
        Fri, 18 Oct 2019 22:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436254;
        bh=ZsYsQjET2eBXHpj8p6+4hCJCBPZ/9D9ILF5vWY4Tb/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sihkb84tWGRLulaBQrLLWsFR4vYB/fcBquZnhSvdspHWXabFXcb2aZkUCANtGG/Wm
         9LuxElrnAJyJ8clmogaU4dOUDnfO0NYxkjbJKYI2eNU4iTWjlruGHki502WE/ZQjpo
         JF2EVLp7aSbVIilgMO5h6TUa/YSrMxeaYVHmsdI8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jason Gunthorpe <jgg@mellanox.com>,
        Artemy Kovalyov <artemyko@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 37/89] RDMA/mlx5: Do not allow rereg of a ODP MR
Date:   Fri, 18 Oct 2019 18:02:32 -0400
Message-Id: <20191018220324.8165-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220324.8165-1-sashal@kernel.org>
References: <20191018220324.8165-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

[ Upstream commit 880505cfef1d086d18b59d2920eb2160429ffa1f ]

This code is completely broken, the umem of a ODP MR simply cannot be
discarded without a lot more locking, nor can an ODP mkey be blithely
destroyed via destroy_mkey().

Fixes: 6aec21f6a832 ("IB/mlx5: Page faults handling infrastructure")
Link: https://lore.kernel.org/r/20191001153821.23621-2-jgg@ziepe.ca
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 3401f5f6792e6..c4ba8838d2c46 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1423,6 +1423,9 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 	if (!mr->umem)
 		return -EINVAL;
 
+	if (is_odp_mr(mr))
+		return -EOPNOTSUPP;
+
 	if (flags & IB_MR_REREG_TRANS) {
 		addr = virt_addr;
 		len = length;
@@ -1468,8 +1471,6 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 		}
 
 		mr->allocated_from_cache = 0;
-		if (IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING))
-			mr->live = 1;
 	} else {
 		/*
 		 * Send a UMR WQE
@@ -1498,7 +1499,6 @@ int mlx5_ib_rereg_user_mr(struct ib_mr *ib_mr, int flags, u64 start,
 
 	set_mr_fields(dev, mr, npages, len, access_flags);
 
-	update_odp_mr(mr);
 	return 0;
 
 err:
-- 
2.20.1

