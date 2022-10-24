Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 851F260B071
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbiJXQFb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:05:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232870AbiJXQDy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:03:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA03A1A5;
        Mon, 24 Oct 2022 07:56:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D80DB81674;
        Mon, 24 Oct 2022 12:26:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7017AC433C1;
        Mon, 24 Oct 2022 12:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614360;
        bh=foAPenZ8SsA1CjuNhOHXs496SxCV1R2U2jrLY5lLoVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EN2DvwFGkRrSyBWtpLDDTyfkd7uOKHiQ0rBEMajM3GbTqPcPWzvMKdWUHGWSPQOUl
         YOyouBPi3ZNvSakrEObBUW8MpWEmtdc0RhEUBNdSN3J14OeCGLKARv02vP9fMKndtv
         CfHlctXRdoOdk0IccS6x39OATAey6bqaVgBOVlMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daisuke Matsuda <matsuda-daisuke@fujitsu.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 232/390] IB: Set IOVA/LENGTH on IB_MR in core/uverbs layers
Date:   Mon, 24 Oct 2022 13:30:29 +0200
Message-Id: <20221024113032.663259593@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/core/uverbs_cmd.c    |    5 ++++-
 drivers/infiniband/core/verbs.c         |    2 ++
 drivers/infiniband/hw/hns/hns_roce_mr.c |    1 -
 drivers/infiniband/hw/mlx4/mr.c         |    1 -
 4 files changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -749,6 +749,7 @@ static int ib_uverbs_reg_mr(struct uverb
 	mr->uobject = uobj;
 	atomic_inc(&pd->usecnt);
 	mr->iova = cmd.hca_va;
+	mr->length = cmd.length;
 
 	rdma_restrack_new(&mr->res, RDMA_RESTRACK_MR);
 	rdma_restrack_set_name(&mr->res, NULL);
@@ -832,8 +833,10 @@ static int ib_uverbs_rereg_mr(struct uve
 		atomic_dec(&old_pd->usecnt);
 	}
 
-	if (cmd.flags & IB_MR_REREG_TRANS)
+	if (cmd.flags & IB_MR_REREG_TRANS) {
 		mr->iova = cmd.hca_va;
+		mr->length = cmd.length;
+	}
 
 	memset(&resp, 0, sizeof(resp));
 	resp.lkey      = mr->lkey;
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2082,6 +2082,8 @@ struct ib_mr *ib_reg_user_mr(struct ib_p
 	mr->pd = pd;
 	mr->dm = NULL;
 	atomic_inc(&pd->usecnt);
+	mr->iova =  virt_addr;
+	mr->length = length;
 
 	rdma_restrack_new(&mr->res, RDMA_RESTRACK_MR);
 	rdma_restrack_parent_name(&mr->res, &pd->res);
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -286,7 +286,6 @@ struct ib_mr *hns_roce_reg_user_mr(struc
 		goto err_alloc_pbl;
 
 	mr->ibmr.rkey = mr->ibmr.lkey = mr->key;
-	mr->ibmr.length = length;
 
 	return &mr->ibmr;
 
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -439,7 +439,6 @@ struct ib_mr *mlx4_ib_reg_user_mr(struct
 		goto err_mr;
 
 	mr->ibmr.rkey = mr->ibmr.lkey = mr->mmr.key;
-	mr->ibmr.length = length;
 	mr->ibmr.page_size = 1U << shift;
 
 	return &mr->ibmr;


