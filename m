Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EED5D60BC65
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 23:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231238AbiJXVn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 17:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231138AbiJXVnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 17:43:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24BE02E8BA2;
        Mon, 24 Oct 2022 12:53:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8450AB818C7;
        Mon, 24 Oct 2022 12:47:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED98C433C1;
        Mon, 24 Oct 2022 12:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615623;
        bh=dwkb7640sqTxHGYCeQP/th744mYknK+tnTqiF1twgr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pC/r5T+ERfTDLIWmdTEqYrjJ9j0ttla3JKeLwPfMW580Mj9A4LQRSn3qE7a8/rWbO
         NLgE9nnvWi2lStaUVRKr7Pp7EajD/6g3i1pVsvxJI6DdJ43EKZZAVs7YMCn34oMmAI
         S8j7gKBaLwm8NTuvK4lOjdnKKFXQDoSqnGHNLpUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 321/530] IB: Set IOVA/LENGTH on IB_MR in core/uverbs layers
Date:   Mon, 24 Oct 2022 13:31:05 +0200
Message-Id: <20221024113059.564689629@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>

[ Upstream commit 241f9a27e0fc0eaf23e3d52c8450f10648cd11f1 ]

Set 'iova' and 'length' on ib_mr in ib_uverbs and ib_core layers to let all
drivers have the members filled. Also, this commit removes redundancy in
the respective drivers.

Previously, commit 04c0a5fcfcf65 ("IB/uverbs: Set IOVA on IB MR in uverbs
layer") changed to set 'iova', but seems to have missed 'length' and the
ib_core layer at that time.

Fixes: 04c0a5fcfcf65 ("IB/uverbs: Set IOVA on IB MR in uverbs layer")
Signed-off-by: Daisuke Matsuda <matsuda-daisuke@fujitsu.com>
Link: https://lore.kernel.org/r/20220921080844.1616883-1-matsuda-daisuke@fujitsu.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_cmd.c    | 5 ++++-
 drivers/infiniband/core/verbs.c         | 2 ++
 drivers/infiniband/hw/hns/hns_roce_mr.c | 1 -
 drivers/infiniband/hw/mlx4/mr.c         | 1 -
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index d1345d76d9b1..9f0e0402fbc0 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -739,6 +739,7 @@ static int ib_uverbs_reg_mr(struct uverbs_attr_bundle *attrs)
 	mr->uobject = uobj;
 	atomic_inc(&pd->usecnt);
 	mr->iova = cmd.hca_va;
+	mr->length = cmd.length;
 
 	rdma_restrack_new(&mr->res, RDMA_RESTRACK_MR);
 	rdma_restrack_set_name(&mr->res, NULL);
@@ -861,8 +862,10 @@ static int ib_uverbs_rereg_mr(struct uverbs_attr_bundle *attrs)
 			mr->pd = new_pd;
 			atomic_inc(&new_pd->usecnt);
 		}
-		if (cmd.flags & IB_MR_REREG_TRANS)
+		if (cmd.flags & IB_MR_REREG_TRANS) {
 			mr->iova = cmd.hca_va;
+			mr->length = cmd.length;
+		}
 	}
 
 	memset(&resp, 0, sizeof(resp));
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 59e20936b800..b721085bb597 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2157,6 +2157,8 @@ struct ib_mr *ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 	mr->pd = pd;
 	mr->dm = NULL;
 	atomic_inc(&pd->usecnt);
+	mr->iova =  virt_addr;
+	mr->length = length;
 
 	rdma_restrack_new(&mr->res, RDMA_RESTRACK_MR);
 	rdma_restrack_parent_name(&mr->res, &pd->res);
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 7089ac780291..20360df25771 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -272,7 +272,6 @@ struct ib_mr *hns_roce_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		goto err_alloc_pbl;
 
 	mr->ibmr.rkey = mr->ibmr.lkey = mr->key;
-	mr->ibmr.length = length;
 
 	return &mr->ibmr;
 
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 04a67b481608..a40bf58bcdd3 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -439,7 +439,6 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		goto err_mr;
 
 	mr->ibmr.rkey = mr->ibmr.lkey = mr->mmr.key;
-	mr->ibmr.length = length;
 	mr->ibmr.page_size = 1U << shift;
 
 	return &mr->ibmr;
-- 
2.35.1



