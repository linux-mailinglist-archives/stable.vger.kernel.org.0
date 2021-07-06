Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9E33BD4F8
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236726AbhGFMS1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:18:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:47572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236794AbhGFLfk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:35:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A3C261E53;
        Tue,  6 Jul 2021 11:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570659;
        bh=a2TYuJh7PkCVniY4/fKjO/f6OUDpXJ887zt9Jfrveuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kidl8uT/9V/sdVuK6v3mTfzTNexhmaRtSWSJeQtK7Ws8upKbM2suTJsSBui1ccVm+
         uiQvHE244gq6GwVVKOjSOQvhAtXnUe5MnGgaMdQLJgLO15eiBSf23dsZlMqAdWjLt5
         UuLnM8AIWijfCwBvlcKkI2nD5Nit+CIFerb76wYe4pJc9dcgQkJ2AZsC6pgWLjwPky
         Z6WW+v3oT7GHxroK8RArDsbKByC/1JUcn/Ju/Rkb7vSXZXR+xrK00RyZYe8VmgXsfJ
         X5OsoHJtZjHRHF8QSYzqkWx1zSdVfpFiOGM4ArPv7Cd1d5fK8cIEH8tSCy81X07wOA
         9fT78vx4jRCFQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiao Yang <yangx.jy@fujitsu.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 104/137] RDMA/rxe: Don't overwrite errno from ib_umem_get()
Date:   Tue,  6 Jul 2021 07:21:30 -0400
Message-Id: <20210706112203.2062605-104-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiao Yang <yangx.jy@fujitsu.com>

[ Upstream commit 20ec0a6d6016aa28b9b3299be18baef1a0f91cd2 ]

rxe_mr_init_user() always returns the fixed -EINVAL when ib_umem_get()
fails so it's hard for user to know which actual error happens in
ib_umem_get(). For example, ib_umem_get() will return -EOPNOTSUPP when
trying to pin pages on a DAX file.

Return actual error as mlx4/mlx5 does.

Link: https://lore.kernel.org/r/20210621071456.4259-1-ice_yangxiao@163.com
Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index d2ce852447c1..026285f7f36a 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -139,7 +139,7 @@ int rxe_mem_init_user(struct rxe_pd *pd, u64 start,
 	if (IS_ERR(umem)) {
 		pr_warn("err %d from rxe_umem_get\n",
 			(int)PTR_ERR(umem));
-		err = -EINVAL;
+		err = PTR_ERR(umem);
 		goto err1;
 	}
 
-- 
2.30.2

