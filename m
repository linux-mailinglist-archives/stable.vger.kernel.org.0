Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2E13BCFAF
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234353AbhGFLbO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:31:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235470AbhGFLaG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B3DF61CE0;
        Tue,  6 Jul 2021 11:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570468;
        bh=EfgEJylRHF1NQY/Yx5XZyMIOkbTSyQmMOC7KGA5XTKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uC9J5F0vM8KZMBqMZqcol6gtRfFtmIeVHbLxKSsNxosj73SuIeEtYdDwlEEI1c5aE
         4PUmZoVwtXkYSpvu+bkphxmlLfgMSvCWZO8mpJcKHI6RjQxMluOiueKsFQZkxZtKrg
         vkGWF96jExyEp5Z9k0x6LJthMoxJqmxK+EiS1sTzgt4/Ji0Wf6/aaPJ5EJjdpZCQdC
         p10xORuc38O+j/5c23LxE6jwZP2buhfj8BRoVMdZbq5YFFQESKwJ9dGHmHdAWhfa/4
         w5a+irawtqOtwgnAqFczQ/bN6WTe2q4xDNxzourMjK7/bv+oC7on8OuEOvGCHZ+Z7t
         C+1hcqM1Ac5ag==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiao Yang <yangx.jy@fujitsu.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 120/160] RDMA/rxe: Don't overwrite errno from ib_umem_get()
Date:   Tue,  6 Jul 2021 07:17:46 -0400
Message-Id: <20210706111827.2060499-120-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111827.2060499-1-sashal@kernel.org>
References: <20210706111827.2060499-1-sashal@kernel.org>
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
index 9f63947bab12..fe2b7d223183 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -135,7 +135,7 @@ int rxe_mr_init_user(struct rxe_pd *pd, u64 start, u64 length, u64 iova,
 	if (IS_ERR(umem)) {
 		pr_warn("err %d from rxe_umem_get\n",
 			(int)PTR_ERR(umem));
-		err = -EINVAL;
+		err = PTR_ERR(umem);
 		goto err1;
 	}
 
-- 
2.30.2

