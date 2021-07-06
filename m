Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B64D03BCD97
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhGFLWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233358AbhGFLUu (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:20:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D301E61C6F;
        Tue,  6 Jul 2021 11:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570249;
        bh=EfgEJylRHF1NQY/Yx5XZyMIOkbTSyQmMOC7KGA5XTKQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0U/x5FD34vz7MrPtBV4m3Figiwq4AazkjRgYXUxDnaLRbNhlVim6rI3BmNnW974i
         KhvuBixhJ1GvZI8SnpF0wsFmkyBdOHaden4RvtSmwEyflrtke3qr4z9QaeBNLfW7fK
         UQDlohCL/gv5nAZmU5Rc2Cpht92xtlE3AtFUcVf07kY3JEcuLA3NkHZh3VuSmIIpYQ
         XxfTBVeowCaRDyyYegdFmfm8LuKGGO8rYP7fV5uIjTMucd0cOLm/dywVucOhB+aEQJ
         1sxnkCG8r8kQ6pTmPPyapBUprqmnh8WwY2P/DxvS00WkAsHHVr1aiQExHGui4wMh/p
         lvoaJ5PuhrCcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiao Yang <yangx.jy@fujitsu.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 148/189] RDMA/rxe: Don't overwrite errno from ib_umem_get()
Date:   Tue,  6 Jul 2021 07:13:28 -0400
Message-Id: <20210706111409.2058071-148-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
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

