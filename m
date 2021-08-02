Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6613DD987
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235814AbhHBOBI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:01:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236443AbhHBN7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 675166120D;
        Mon,  2 Aug 2021 13:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912541;
        bh=+c53tSanS34N+6wuyCQziUeyxAyUg7S5Doy2u4NJt2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Woi4gjkuYPmPB0jtKWeaAdkz+uMzt9fx6qpC4Y93Re2A8Upn50wxVAmvszl4patWL
         ft8hKBvqLuS5bMd14gYDJhnkLVlWQI0DlMRELDULkd3GxBS/iMNOi0eIdzGDzFOFf7
         bZMlc9lhJ/cSjI75/dCg2wKdYSbRIexxg8PnNEfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearsonhpe@gmail.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>,
        =?UTF-8?q?H=C3=A5kon=20Bugge?= <haakon.bugge@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 039/104] RDMA/rxe: Fix memory leak in error path code
Date:   Mon,  2 Aug 2021 15:44:36 +0200
Message-Id: <20210802134345.303620063@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit b18c7da63fcb46e2f9a093cc18d7c219e13a887c ]

In rxe_mr_init_user() at the third error the driver fails to free the
memory at mr->map. This patch adds code to do that.  This error only
occurs if page_address() fails to return a non zero address which should
never happen for 64 bit architectures.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Link: https://lore.kernel.org/r/20210705164153.17652-1-rpearsonhpe@gmail.com
Reported by: Haakon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Reviewed-by: Zhu Yanjun <zyjzyj2000@gmail.com>
Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index fe2b7d223183..fa3d29825ef6 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -130,13 +130,14 @@ int rxe_mr_init_user(struct rxe_pd *pd, u64 start, u64 length, u64 iova,
 	int			num_buf;
 	void			*vaddr;
 	int err;
+	int i;
 
 	umem = ib_umem_get(pd->ibpd.device, start, length, access);
 	if (IS_ERR(umem)) {
-		pr_warn("err %d from rxe_umem_get\n",
-			(int)PTR_ERR(umem));
+		pr_warn("%s: Unable to pin memory region err = %d\n",
+			__func__, (int)PTR_ERR(umem));
 		err = PTR_ERR(umem);
-		goto err1;
+		goto err_out;
 	}
 
 	mr->umem = umem;
@@ -146,9 +147,9 @@ int rxe_mr_init_user(struct rxe_pd *pd, u64 start, u64 length, u64 iova,
 
 	err = rxe_mr_alloc(mr, num_buf);
 	if (err) {
-		pr_warn("err %d from rxe_mr_alloc\n", err);
-		ib_umem_release(umem);
-		goto err1;
+		pr_warn("%s: Unable to allocate memory for map\n",
+				__func__);
+		goto err_release_umem;
 	}
 
 	mr->page_shift = PAGE_SHIFT;
@@ -168,10 +169,10 @@ int rxe_mr_init_user(struct rxe_pd *pd, u64 start, u64 length, u64 iova,
 
 			vaddr = page_address(sg_page_iter_page(&sg_iter));
 			if (!vaddr) {
-				pr_warn("null vaddr\n");
-				ib_umem_release(umem);
+				pr_warn("%s: Unable to get virtual address\n",
+						__func__);
 				err = -ENOMEM;
-				goto err1;
+				goto err_cleanup_map;
 			}
 
 			buf->addr = (uintptr_t)vaddr;
@@ -194,7 +195,13 @@ int rxe_mr_init_user(struct rxe_pd *pd, u64 start, u64 length, u64 iova,
 
 	return 0;
 
-err1:
+err_cleanup_map:
+	for (i = 0; i < mr->num_map; i++)
+		kfree(mr->map[i]);
+	kfree(mr->map);
+err_release_umem:
+	ib_umem_release(umem);
+err_out:
 	return err;
 }
 
-- 
2.30.2



