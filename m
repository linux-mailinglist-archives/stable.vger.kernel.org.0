Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD0703BD548
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237459AbhGFMTk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:19:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:47560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234984AbhGFLgd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:36:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F029C61F15;
        Tue,  6 Jul 2021 11:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570961;
        bh=E7wTSz+U1lpd+F+dd1pk3DvWWv9XGdvIxyggNW2n+N8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YHOXwTEqBCL4hU89Bt7U+vC/cnuutqTbsYoGv5fIXLZVmMLOybyxGC1K3ZK3cxlFA
         vPJVznYqBDngLAN1X9AxxnRfoxUEapLZEeGBLPGoMqWzV6kxQSrh+47u+WHQXucqVe
         uJ9jED9Yh9UDMXNABTkTggZcj7CiHOkfGjbnwwDJoDzoZQ2Ay1yl5zIpKWQzAuqC+d
         i4GdL0XFDDkpx+o/HkDnqn2gcoZmB0mFpa+Xk1lC0sAZlL3JuT/Rpkl/d4cuIBl6gs
         Zk5POHLsfrwmNsYo2jDzpJbJklJ9fTRf43CPU4tq8cbwM8BqityM3fIR96odnEYh0O
         aqoIJcS+qJuUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xiao Yang <yangx.jy@fujitsu.com>, Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 27/35] RDMA/rxe: Don't overwrite errno from ib_umem_get()
Date:   Tue,  6 Jul 2021 07:28:39 -0400
Message-Id: <20210706112848.2066036-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112848.2066036-1-sashal@kernel.org>
References: <20210706112848.2066036-1-sashal@kernel.org>
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
index 6d1ba75398a1..e23b322224ab 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -175,7 +175,7 @@ int rxe_mem_init_user(struct rxe_dev *rxe, struct rxe_pd *pd, u64 start,
 	if (IS_ERR(umem)) {
 		pr_warn("err %d from rxe_umem_get\n",
 			(int)PTR_ERR(umem));
-		err = -EINVAL;
+		err = PTR_ERR(umem);
 		goto err1;
 	}
 
-- 
2.30.2

