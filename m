Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223DA59436A
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 00:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347425AbiHOWTf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:19:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350351AbiHOWRq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:17:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A34108978;
        Mon, 15 Aug 2022 12:40:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1E2AB80EA9;
        Mon, 15 Aug 2022 19:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3516DC433C1;
        Mon, 15 Aug 2022 19:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592448;
        bh=l4lXvZEXXOSETi6/YJDc4cxoVT+OkLmsyME2xliMa0g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QwrQcloQWQtISI9tpJjMxSny0+k6ATNzQyZHzIHeM84WfGf3uOc8HbAhWZ9k6sHYt
         Y10vNV7aq8oPkXWybSx3gjy6RsMxYI4dap+Xts7aGUOX3wU4yTXst01l50RDqUp8R/
         xoqfulMeoFa2B8AIPKIBZHq076d51yz5VGz0ERBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Md Haris Iqbal <haris.phnx@gmail.com>,
        Bob Pearson <rpearsonhpe@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0788/1095] RDMA/rxe: For invalidate compare according to set keys in mr
Date:   Mon, 15 Aug 2022 20:03:07 +0200
Message-Id: <20220815180501.846579817@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Md Haris Iqbal <haris.phnx@gmail.com>

[ Upstream commit 174e7b137042f19b5ce88beb4fc0ff4ec6b0c72a ]

The 'rkey' input can be an lkey or rkey, and in rxe the lkey or rkey have
the same value, including the variant bits.

So, if mr->rkey is set, compare the invalidate key with it, otherwise
compare with the mr->lkey.

Since we already did a lookup on the non-varient bits to get this far, the
check's only purpose is to confirm that the wqe has the correct variant
bits.

Fixes: 001345339f4c ("RDMA/rxe: Separate HW and SW l/rkeys")
Link: https://lore.kernel.org/r/20220707073006.328737-1-haris.phnx@gmail.com
Signed-off-by: Md Haris Iqbal <haris.phnx@gmail.com>
Reviewed-by: Bob Pearson <rpearsonhpe@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_loc.h |  2 +-
 drivers/infiniband/sw/rxe/rxe_mr.c  | 12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 2ffbe3390668..2b0edf360474 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -77,7 +77,7 @@ struct rxe_mr *lookup_mr(struct rxe_pd *pd, int access, u32 key,
 			 enum rxe_mr_lookup_type type);
 int mr_check_range(struct rxe_mr *mr, u64 iova, size_t length);
 int advance_dma_data(struct rxe_dma_info *dma, unsigned int length);
-int rxe_invalidate_mr(struct rxe_qp *qp, u32 rkey);
+int rxe_invalidate_mr(struct rxe_qp *qp, u32 key);
 int rxe_reg_fast_mr(struct rxe_qp *qp, struct rxe_send_wqe *wqe);
 int rxe_mr_set_page(struct ib_mr *ibmr, u64 addr);
 int rxe_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata);
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 60a31b718774..76d6498e83f9 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -576,22 +576,22 @@ struct rxe_mr *lookup_mr(struct rxe_pd *pd, int access, u32 key,
 	return mr;
 }
 
-int rxe_invalidate_mr(struct rxe_qp *qp, u32 rkey)
+int rxe_invalidate_mr(struct rxe_qp *qp, u32 key)
 {
 	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
 	struct rxe_mr *mr;
 	int ret;
 
-	mr = rxe_pool_get_index(&rxe->mr_pool, rkey >> 8);
+	mr = rxe_pool_get_index(&rxe->mr_pool, key >> 8);
 	if (!mr) {
-		pr_err("%s: No MR for rkey %#x\n", __func__, rkey);
+		pr_err("%s: No MR for key %#x\n", __func__, key);
 		ret = -EINVAL;
 		goto err;
 	}
 
-	if (rkey != mr->rkey) {
-		pr_err("%s: rkey (%#x) doesn't match mr->rkey (%#x)\n",
-			__func__, rkey, mr->rkey);
+	if (mr->rkey ? (key != mr->rkey) : (key != mr->lkey)) {
+		pr_err("%s: wr key (%#x) doesn't match mr key (%#x)\n",
+			__func__, key, (mr->rkey ? mr->rkey : mr->lkey));
 		ret = -EINVAL;
 		goto err_drop_ref;
 	}
-- 
2.35.1



