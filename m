Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17BF43C543D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:53:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348175AbhGLH50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:57:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:42904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343605AbhGLHxk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:53:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0D40061158;
        Mon, 12 Jul 2021 07:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076251;
        bh=qsJPlvZ9MLtgytJ4rUnAQPTxglVaOFgQEH9TxIzoVpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oLadKlHDROEHyCna8/Ov2LshsYUqjspFSBLMFbpA1Au50YzAaDHOevImSzsfUGhWm
         x4H1hzqbf7/fAUu8Y1lTSw1cShcFRU1CpE1rVAmGfnEEqIJlstOdL54TRyUbvIi9ZT
         Vn/bpfxW9/aW1gLLoMO4B+EuzXIYqaTX9Vdo0ZY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixing Liu <liuyixing1@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 561/800] RDMA/hns: Add window selection field of congestion control
Date:   Mon, 12 Jul 2021 08:09:44 +0200
Message-Id: <20210712061027.100738483@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yixing Liu <liuyixing1@huawei.com>

[ Upstream commit 7ae61c5f16671ecaf23526feb6892c8249d0c2d7 ]

The window selection field is necessary for congestion control of HIP09,
it is got from firmware and then filled into QPC. Some algorithms need it
to decide whether to limit the number of windows.

Fixes: f91696f2f053 ("RDMA/hns: Support congestion control type selection according to the FW")
Link: https://lore.kernel.org/r/1624364163-44185-1-git-send-email-liweihang@huawei.com
Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 12 ++++++++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index f074e2e5a5c8..dcbe5e28a4f7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4777,6 +4777,11 @@ enum {
 	DIP_VALID,
 };
 
+enum {
+	WND_LIMIT,
+	WND_UNLIMIT,
+};
+
 static int check_cong_type(struct ib_qp *ibqp,
 			   struct hns_roce_congestion_algorithm *cong_alg)
 {
@@ -4788,21 +4793,25 @@ static int check_cong_type(struct ib_qp *ibqp,
 		cong_alg->alg_sel = CONG_DCQCN;
 		cong_alg->alg_sub_sel = UNSUPPORT_CONG_LEVEL;
 		cong_alg->dip_vld = DIP_INVALID;
+		cong_alg->wnd_mode_sel = WND_LIMIT;
 		break;
 	case CONG_TYPE_LDCP:
 		cong_alg->alg_sel = CONG_WINDOW;
 		cong_alg->alg_sub_sel = CONG_LDCP;
 		cong_alg->dip_vld = DIP_INVALID;
+		cong_alg->wnd_mode_sel = WND_UNLIMIT;
 		break;
 	case CONG_TYPE_HC3:
 		cong_alg->alg_sel = CONG_WINDOW;
 		cong_alg->alg_sub_sel = CONG_HC3;
 		cong_alg->dip_vld = DIP_INVALID;
+		cong_alg->wnd_mode_sel = WND_LIMIT;
 		break;
 	case CONG_TYPE_DIP:
 		cong_alg->alg_sel = CONG_DCQCN;
 		cong_alg->alg_sub_sel = UNSUPPORT_CONG_LEVEL;
 		cong_alg->dip_vld = DIP_VALID;
+		cong_alg->wnd_mode_sel = WND_LIMIT;
 		break;
 	default:
 		ibdev_err(&hr_dev->ib_dev,
@@ -4843,6 +4852,9 @@ static int fill_cong_field(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 	hr_reg_write(&qpc_mask->ext, QPCEX_CONG_ALG_SUB_SEL, 0);
 	hr_reg_write(&context->ext, QPCEX_DIP_CTX_IDX_VLD, cong_field.dip_vld);
 	hr_reg_write(&qpc_mask->ext, QPCEX_DIP_CTX_IDX_VLD, 0);
+	hr_reg_write(&context->ext, QPCEX_SQ_RQ_NOT_FORBID_EN,
+		     cong_field.wnd_mode_sel);
+	hr_reg_clear(&qpc_mask->ext, QPCEX_SQ_RQ_NOT_FORBID_EN);
 
 	/* if dip is disabled, there is no need to set dip idx */
 	if (cong_field.dip_vld == 0)
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 028bc41cb45c..23cf2f6bc7a5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -964,6 +964,7 @@ struct hns_roce_v2_qp_context {
 #define QPCEX_CONG_ALG_SUB_SEL QPCEX_FIELD_LOC(1, 1)
 #define QPCEX_DIP_CTX_IDX_VLD QPCEX_FIELD_LOC(2, 2)
 #define QPCEX_DIP_CTX_IDX QPCEX_FIELD_LOC(22, 3)
+#define QPCEX_SQ_RQ_NOT_FORBID_EN QPCEX_FIELD_LOC(23, 23)
 #define QPCEX_STASH QPCEX_FIELD_LOC(82, 82)
 
 #define	V2_QP_RWE_S 1 /* rdma write enable */
@@ -1643,6 +1644,7 @@ struct hns_roce_congestion_algorithm {
 	u8 alg_sel;
 	u8 alg_sub_sel;
 	u8 dip_vld;
+	u8 wnd_mode_sel;
 };
 
 #define V2_QUERY_PF_CAPS_D_CEQ_DEPTH_S 0
-- 
2.30.2



