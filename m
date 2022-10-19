Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEC7F6047A8
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbiJSNn2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbiJSNmv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:42:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60CD4000E;
        Wed, 19 Oct 2022 06:29:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3044CB82464;
        Wed, 19 Oct 2022 09:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F89DC433D6;
        Wed, 19 Oct 2022 09:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170214;
        bh=dGxpgPpxv2upwt6DOdrkuPto6gj0JiwAD2NSZhFByPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LD5y8ho44nZBFwqNsOocXz5AI7ggRhfVctMEIAPveP25Wj8tSLO63DEecJ38uqvCS
         excAWeNP7R1YprGA/srWbpMxWf4TqlLRl4pZNlhIjyaHkqIm1xcHpMAsylaJmJsl+O
         lzPdIAQ5Do/8hnu6W/iiq2QVnBgnp5gG8FX4sds0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Pearson <rpearsonhpe@gmail.com>,
        Li Zhijian <lizhijian@fujitsu.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 571/862] RDMA/rxe: Set pd early in mr alloc routines
Date:   Wed, 19 Oct 2022 10:30:58 +0200
Message-Id: <20221019083315.211477935@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 58651bbb30f87dab474eff31ab564391aa6ea1f3 ]

Move setting of pd in mr objects ahead of any possible errors so that it
will always be set in rxe_mr_cleanup() to avoid seg faults when
rxe_put(mr_pd(mr)) is called.

Fixes: cf40367961d8 ("RDMA/rxe: Move mr cleanup code to rxe_mr_cleanup()")
Link: https://lore.kernel.org/r/20220805183153.32007-2-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Reviewed-by: Li Zhijian <lizhijian@fujitsu.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_loc.h   |  6 +++---
 drivers/infiniband/sw/rxe/rxe_mr.c    | 11 ++++-------
 drivers/infiniband/sw/rxe/rxe_verbs.c | 12 +++++++-----
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 22f6cc31d1d6..c2a5c8814a48 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -64,10 +64,10 @@ int rxe_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
 
 /* rxe_mr.c */
 u8 rxe_get_next_key(u32 last_key);
-void rxe_mr_init_dma(struct rxe_pd *pd, int access, struct rxe_mr *mr);
-int rxe_mr_init_user(struct rxe_pd *pd, u64 start, u64 length, u64 iova,
+void rxe_mr_init_dma(int access, struct rxe_mr *mr);
+int rxe_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length, u64 iova,
 		     int access, struct rxe_mr *mr);
-int rxe_mr_init_fast(struct rxe_pd *pd, int max_pages, struct rxe_mr *mr);
+int rxe_mr_init_fast(int max_pages, struct rxe_mr *mr);
 int rxe_mr_copy(struct rxe_mr *mr, u64 iova, void *addr, int length,
 		enum rxe_mr_copy_dir dir);
 int copy_data(struct rxe_pd *pd, int access, struct rxe_dma_info *dma,
diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 850b80f5ad8b..af34f198e645 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -103,17 +103,16 @@ static int rxe_mr_alloc(struct rxe_mr *mr, int num_buf)
 	return -ENOMEM;
 }
 
-void rxe_mr_init_dma(struct rxe_pd *pd, int access, struct rxe_mr *mr)
+void rxe_mr_init_dma(int access, struct rxe_mr *mr)
 {
 	rxe_mr_init(access, mr);
 
-	mr->ibmr.pd = &pd->ibpd;
 	mr->access = access;
 	mr->state = RXE_MR_STATE_VALID;
 	mr->type = IB_MR_TYPE_DMA;
 }
 
-int rxe_mr_init_user(struct rxe_pd *pd, u64 start, u64 length, u64 iova,
+int rxe_mr_init_user(struct rxe_dev *rxe, u64 start, u64 length, u64 iova,
 		     int access, struct rxe_mr *mr)
 {
 	struct rxe_map		**map;
@@ -125,7 +124,7 @@ int rxe_mr_init_user(struct rxe_pd *pd, u64 start, u64 length, u64 iova,
 	int err;
 	int i;
 
-	umem = ib_umem_get(pd->ibpd.device, start, length, access);
+	umem = ib_umem_get(&rxe->ib_dev, start, length, access);
 	if (IS_ERR(umem)) {
 		pr_warn("%s: Unable to pin memory region err = %d\n",
 			__func__, (int)PTR_ERR(umem));
@@ -175,7 +174,6 @@ int rxe_mr_init_user(struct rxe_pd *pd, u64 start, u64 length, u64 iova,
 		}
 	}
 
-	mr->ibmr.pd = &pd->ibpd;
 	mr->umem = umem;
 	mr->access = access;
 	mr->length = length;
@@ -197,7 +195,7 @@ int rxe_mr_init_user(struct rxe_pd *pd, u64 start, u64 length, u64 iova,
 	return err;
 }
 
-int rxe_mr_init_fast(struct rxe_pd *pd, int max_pages, struct rxe_mr *mr)
+int rxe_mr_init_fast(int max_pages, struct rxe_mr *mr)
 {
 	int err;
 
@@ -208,7 +206,6 @@ int rxe_mr_init_fast(struct rxe_pd *pd, int max_pages, struct rxe_mr *mr)
 	if (err)
 		goto err1;
 
-	mr->ibmr.pd = &pd->ibpd;
 	mr->max_buf = max_pages;
 	mr->state = RXE_MR_STATE_FREE;
 	mr->type = IB_MR_TYPE_MEM_REG;
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index e264cf69bf55..f54a3eba652f 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -903,7 +903,9 @@ static struct ib_mr *rxe_get_dma_mr(struct ib_pd *ibpd, int access)
 		return ERR_PTR(-ENOMEM);
 
 	rxe_get(pd);
-	rxe_mr_init_dma(pd, access, mr);
+	mr->ibmr.pd = ibpd;
+
+	rxe_mr_init_dma(access, mr);
 	rxe_finalize(mr);
 
 	return &mr->ibmr;
@@ -928,8 +930,9 @@ static struct ib_mr *rxe_reg_user_mr(struct ib_pd *ibpd,
 
 
 	rxe_get(pd);
+	mr->ibmr.pd = ibpd;
 
-	err = rxe_mr_init_user(pd, start, length, iova, access, mr);
+	err = rxe_mr_init_user(rxe, start, length, iova, access, mr);
 	if (err)
 		goto err3;
 
@@ -938,7 +941,6 @@ static struct ib_mr *rxe_reg_user_mr(struct ib_pd *ibpd,
 	return &mr->ibmr;
 
 err3:
-	rxe_put(pd);
 	rxe_cleanup(mr);
 err2:
 	return ERR_PTR(err);
@@ -962,8 +964,9 @@ static struct ib_mr *rxe_alloc_mr(struct ib_pd *ibpd, enum ib_mr_type mr_type,
 	}
 
 	rxe_get(pd);
+	mr->ibmr.pd = ibpd;
 
-	err = rxe_mr_init_fast(pd, max_num_sg, mr);
+	err = rxe_mr_init_fast(max_num_sg, mr);
 	if (err)
 		goto err2;
 
@@ -972,7 +975,6 @@ static struct ib_mr *rxe_alloc_mr(struct ib_pd *ibpd, enum ib_mr_type mr_type,
 	return &mr->ibmr;
 
 err2:
-	rxe_put(pd);
 	rxe_cleanup(mr);
 err1:
 	return ERR_PTR(err);
-- 
2.35.1



