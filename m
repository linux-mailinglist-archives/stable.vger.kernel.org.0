Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F94C3CDDF0
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343640AbhGSPBX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:01:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:52610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344141AbhGSO7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A496061221;
        Mon, 19 Jul 2021 15:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709128;
        bh=5Z5yOYQ0o8pG1pSfroH3j/bq5+6tKzgx0kwokEttSOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P3B89tuetYYJi8ZOm6lFM81t4Yd7j87KU3IbQdGjHHWI1Dgw+WV5OstcCpN9+RQOv
         mwZmuHIORX3uKuXR1LpMN2K92okXxXp7tcxJkWV3cKErpgh4P2KUmVuHLxxkqjEnXg
         ic4ap3mRmAOm4fQQ0qNIQhcfEIcykQFhwq11DmHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiao Yang <yangx.jy@fujitsu.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 264/421] RDMA/rxe: Dont overwrite errno from ib_umem_get()
Date:   Mon, 19 Jul 2021 16:51:15 +0200
Message-Id: <20210719144955.540818045@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 2cca89ca08cd..375e5520865e 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -175,7 +175,7 @@ int rxe_mem_init_user(struct rxe_pd *pd, u64 start,
 	if (IS_ERR(umem)) {
 		pr_warn("err %d from rxe_umem_get\n",
 			(int)PTR_ERR(umem));
-		err = -EINVAL;
+		err = PTR_ERR(umem);
 		goto err1;
 	}
 
-- 
2.30.2



