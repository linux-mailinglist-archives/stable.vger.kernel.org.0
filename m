Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB1554F3812
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376281AbiDELVS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349342AbiDEJtl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB1C6334;
        Tue,  5 Apr 2022 02:44:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBCE061675;
        Tue,  5 Apr 2022 09:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E79C385A2;
        Tue,  5 Apr 2022 09:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151851;
        bh=yZ+WimmexbVpDWgdZiQrjWS7LEoQpVE2+xeHGJ7M12k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/56oO+u1GkTTDTNjzrBsFhyEqFuGsSy84UErdjGCERJiconwuSwp0yvjo9OgFBe4
         VtBc9FCS2yHfAMJET5KhphkRCcNXmYKPW9Is9HkbNEqx8cFW2MAAPL+ZoaUkh3vO7B
         o+08V4wFHWH5rrWbvfm8yX4j3vsnQvynAyZxUSks=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 537/913] RDMA/irdma: Prevent some integer underflows
Date:   Tue,  5 Apr 2022 09:26:39 +0200
Message-Id: <20220405070355.945964593@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 6f6dbb819dfc1a35bcb8b709b5c83a3ea8beff75 ]

My static checker complains that:

    drivers/infiniband/hw/irdma/ctrl.c:3605 irdma_sc_ceq_init()
    warn: can subtract underflow 'info->dev->hmc_fpm_misc.max_ceqs'?

It appears that "info->dev->hmc_fpm_misc.max_ceqs" comes from the firmware
in irdma_sc_parse_fpm_query_buf() so, yes, there is a chance that it could
be zero.  Even if we trust the firmware, it's easy enough to change the
condition just as a hardenning measure.

Fixes: 3f49d6842569 ("RDMA/irdma: Implement HW Admin Queue OPs")
Link: https://lore.kernel.org/r/20220307125928.GE16710@kili
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/ctrl.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index f1e5515256e0..1ac7067e21be 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -431,7 +431,7 @@ enum irdma_status_code irdma_sc_qp_create(struct irdma_sc_qp *qp, struct irdma_c
 
 	cqp = qp->dev->cqp;
 	if (qp->qp_uk.qp_id < cqp->dev->hw_attrs.min_hw_qp_id ||
-	    qp->qp_uk.qp_id > (cqp->dev->hmc_info->hmc_obj[IRDMA_HMC_IW_QP].max_cnt - 1))
+	    qp->qp_uk.qp_id >= (cqp->dev->hmc_info->hmc_obj[IRDMA_HMC_IW_QP].max_cnt))
 		return IRDMA_ERR_INVALID_QP_ID;
 
 	wqe = irdma_sc_cqp_get_next_send_wqe(cqp, scratch);
@@ -2551,10 +2551,10 @@ static enum irdma_status_code irdma_sc_cq_create(struct irdma_sc_cq *cq,
 	enum irdma_status_code ret_code = 0;
 
 	cqp = cq->dev->cqp;
-	if (cq->cq_uk.cq_id > (cqp->dev->hmc_info->hmc_obj[IRDMA_HMC_IW_CQ].max_cnt - 1))
+	if (cq->cq_uk.cq_id >= (cqp->dev->hmc_info->hmc_obj[IRDMA_HMC_IW_CQ].max_cnt))
 		return IRDMA_ERR_INVALID_CQ_ID;
 
-	if (cq->ceq_id > (cq->dev->hmc_fpm_misc.max_ceqs - 1))
+	if (cq->ceq_id >= (cq->dev->hmc_fpm_misc.max_ceqs))
 		return IRDMA_ERR_INVALID_CEQ_ID;
 
 	ceq = cq->dev->ceq[cq->ceq_id];
@@ -3656,7 +3656,7 @@ enum irdma_status_code irdma_sc_ceq_init(struct irdma_sc_ceq *ceq,
 	    info->elem_cnt > info->dev->hw_attrs.max_hw_ceq_size)
 		return IRDMA_ERR_INVALID_SIZE;
 
-	if (info->ceq_id > (info->dev->hmc_fpm_misc.max_ceqs - 1))
+	if (info->ceq_id >= (info->dev->hmc_fpm_misc.max_ceqs))
 		return IRDMA_ERR_INVALID_CEQ_ID;
 	pble_obj_cnt = info->dev->hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt;
 
@@ -4205,7 +4205,7 @@ enum irdma_status_code irdma_sc_ccq_init(struct irdma_sc_cq *cq,
 	    info->num_elem > info->dev->hw_attrs.uk_attrs.max_hw_cq_size)
 		return IRDMA_ERR_INVALID_SIZE;
 
-	if (info->ceq_id > (info->dev->hmc_fpm_misc.max_ceqs - 1))
+	if (info->ceq_id >= (info->dev->hmc_fpm_misc.max_ceqs ))
 		return IRDMA_ERR_INVALID_CEQ_ID;
 
 	pble_obj_cnt = info->dev->hmc_info->hmc_obj[IRDMA_HMC_IW_PBLE].cnt;
-- 
2.34.1



