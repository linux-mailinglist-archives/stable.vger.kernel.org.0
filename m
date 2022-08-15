Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE3C594DC6
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344678AbiHPAYs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346164AbiHPAW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:22:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEEDBD292C;
        Mon, 15 Aug 2022 13:34:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 698A3B80EA8;
        Mon, 15 Aug 2022 20:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86AEC433D6;
        Mon, 15 Aug 2022 20:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595625;
        bh=a6wrct/1vSDzdFquYxq7riEPjS5BzhdSsMye/0NyqSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZDtsXlfvSUO28VfjnKMmtPzgM7oS5Wr8PCz2d+36pTLpW5Jr3U8S24NwsK/Z7cgH
         bvzNC3pZ6oPdFb92VSac24wJ9B7LqfMHBjr/1ABO5iPopNpK5GOfl/jThvuyrIgmVx
         xpiC5rQqlb6z6EUAKYFe/gpDE74ToYmHtLD9DGd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0822/1157] RDMA/irdma: Fix setting of QP context err_rq_idx_valid field
Date:   Mon, 15 Aug 2022 20:02:58 +0200
Message-Id: <20220815180512.375371344@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Mustafa Ismail <mustafa.ismail@intel.com>

[ Upstream commit 3a844596ed71b7c12ac602f6f6b7b0f17e4d6a90 ]

Setting err_rq_idx_valid field in QP context when the AE source of the
AEQE is not associated with an RQ causes the firmware flush to fail.

Set err_rq_idx_valid field in QP context only if it is associated with an
RQ. Additionally, cleanup the redundant setting of this field in
irdma_process_aeq.

Fixes: 44d9e52977a1 ("RDMA/irdma: Implement device initialization definitions")
Link: https://lore.kernel.org/r/20220705230815.265-8-shiraz.saleem@intel.com
Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/hw.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index dd3943d22dc6..6bba1335993a 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -257,10 +257,6 @@ static void irdma_process_aeq(struct irdma_pci_f *rf)
 				iwqp->last_aeq = info->ae_id;
 			spin_unlock_irqrestore(&iwqp->lock, flags);
 			ctx_info = &iwqp->ctx_info;
-			if (rdma_protocol_roce(&iwqp->iwdev->ibdev, 1))
-				ctx_info->roce_info->err_rq_idx_valid = true;
-			else
-				ctx_info->iwarp_info->err_rq_idx_valid = true;
 		} else {
 			if (info->ae_id != IRDMA_AE_CQ_OPERATION_ERROR)
 				continue;
@@ -370,16 +366,12 @@ static void irdma_process_aeq(struct irdma_pci_f *rf)
 		case IRDMA_AE_LCE_FUNCTION_CATASTROPHIC:
 		case IRDMA_AE_LCE_CQ_CATASTROPHIC:
 		case IRDMA_AE_UDA_XMIT_DGRAM_TOO_LONG:
-			if (rdma_protocol_roce(&iwdev->ibdev, 1))
-				ctx_info->roce_info->err_rq_idx_valid = false;
-			else
-				ctx_info->iwarp_info->err_rq_idx_valid = false;
-			fallthrough;
 		default:
 			ibdev_err(&iwdev->ibdev, "abnormal ae_id = 0x%x bool qp=%d qp_id = %d\n",
 				  info->ae_id, info->qp, info->qp_cq_id);
 			if (rdma_protocol_roce(&iwdev->ibdev, 1)) {
-				if (!info->sq && ctx_info->roce_info->err_rq_idx_valid) {
+				ctx_info->roce_info->err_rq_idx_valid = info->rq;
+				if (info->rq) {
 					ctx_info->roce_info->err_rq_idx = info->wqe_idx;
 					irdma_sc_qp_setctx_roce(&iwqp->sc_qp, iwqp->host_ctx.va,
 								ctx_info);
@@ -388,7 +380,8 @@ static void irdma_process_aeq(struct irdma_pci_f *rf)
 				irdma_cm_disconn(iwqp);
 				break;
 			}
-			if (!info->sq && ctx_info->iwarp_info->err_rq_idx_valid) {
+			ctx_info->iwarp_info->err_rq_idx_valid = info->rq;
+			if (info->rq) {
 				ctx_info->iwarp_info->err_rq_idx = info->wqe_idx;
 				ctx_info->tcp_info_valid = false;
 				ctx_info->iwarp_info_valid = true;
-- 
2.35.1



