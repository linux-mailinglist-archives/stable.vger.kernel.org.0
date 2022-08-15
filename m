Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 821D0593919
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343928AbiHOTTC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344947AbiHOTRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:17:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C6FD558FB;
        Mon, 15 Aug 2022 11:39:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 337FFB81088;
        Mon, 15 Aug 2022 18:39:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8341BC433D6;
        Mon, 15 Aug 2022 18:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588742;
        bh=1/L9E/HWhXwNZo+8775NT4/HZHMFFz51S99HxU4lLJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3BrnLtWY4eYoSl18ZFtbAnspZbCAv2cCqgaM/2JPNOTmZiRXcgGZB4vn56ddxSxB
         OG1tcoGqQU3I2oIgyEAF8le5AtdwvjQySi+uwUFzA+Hfy5M5tNuJU8hOFs6HEYm+J8
         F3lGP6Pb/dPfuANSKopwo66PVAsazr0iiKHqCAFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mustafa Ismail <mustafa.ismail@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 501/779] RDMA/irdma: Fix setting of QP context err_rq_idx_valid field
Date:   Mon, 15 Aug 2022 20:02:25 +0200
Message-Id: <20220815180358.690324779@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 4f763e552eae..3d5d3f8d5ded 100644
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



