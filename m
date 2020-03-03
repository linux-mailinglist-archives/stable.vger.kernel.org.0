Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5325D177F66
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbgCCRud (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:50:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:58180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728615AbgCCRuc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:50:32 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E3C120CC7;
        Tue,  3 Mar 2020 17:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257830;
        bh=eHsNYiS8BfkX9qA8ffEl7jMHW4jucE1t/ZyyG5T/pTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZXje7dTM9Ba/GgOht9Nu3NVGGNSwbmVdGA2frdwBIOyr7nv6UqmCwiFHqQfAFKNM
         PxuYYdFDoCcJ2Iq8iisJQ+2qOHPeJkqaNNjxoGrpea68ytxNtqAO5ObWeWyAKx6pay
         bNPys9/fi1jawbMUlt38EsJUwfQuv6H+X4fSwkIo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Ou <oulijun@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Subject: [PATCH 5.5 146/176] RDMA/hns: Bugfix for posting a wqe with sge
Date:   Tue,  3 Mar 2020 18:43:30 +0100
Message-Id: <20200303174321.629798282@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

commit 468d020e2f02867b8ec561461a1689cd4365e493 upstream.

Driver should first check whether the sge is valid, then fill the valid
sge and the caculated total into hardware, otherwise invalid sges will
cause an error.

Fixes: 52e3b42a2f58 ("RDMA/hns: Filter for zero length of sge in hip08 kernel mode")
Fixes: 7bdee4158b37 ("RDMA/hns: Fill sq wqe context of ud type in hip08")
Link: https://lore.kernel.org/r/1578571852-13704-1-git-send-email-liweihang@huawei.com
Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c |   41 +++++++++++++++++------------
 1 file changed, 25 insertions(+), 16 deletions(-)

--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -110,7 +110,7 @@ static void set_atomic_seg(struct hns_ro
 }
 
 static void set_extend_sge(struct hns_roce_qp *qp, const struct ib_send_wr *wr,
-			   unsigned int *sge_ind)
+			   unsigned int *sge_ind, int valid_num_sge)
 {
 	struct hns_roce_v2_wqe_data_seg *dseg;
 	struct ib_sge *sg;
@@ -123,7 +123,7 @@ static void set_extend_sge(struct hns_ro
 
 	if (qp->ibqp.qp_type == IB_QPT_RC || qp->ibqp.qp_type == IB_QPT_UC)
 		num_in_wqe = HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE;
-	extend_sge_num = wr->num_sge - num_in_wqe;
+	extend_sge_num = valid_num_sge - num_in_wqe;
 	sg = wr->sg_list + num_in_wqe;
 	shift = qp->hr_buf.page_shift;
 
@@ -159,14 +159,16 @@ static void set_extend_sge(struct hns_ro
 static int set_rwqe_data_seg(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 			     struct hns_roce_v2_rc_send_wqe *rc_sq_wqe,
 			     void *wqe, unsigned int *sge_ind,
+			     int valid_num_sge,
 			     const struct ib_send_wr **bad_wr)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
 	struct hns_roce_v2_wqe_data_seg *dseg = wqe;
 	struct hns_roce_qp *qp = to_hr_qp(ibqp);
+	int j = 0;
 	int i;
 
-	if (wr->send_flags & IB_SEND_INLINE && wr->num_sge) {
+	if (wr->send_flags & IB_SEND_INLINE && valid_num_sge) {
 		if (le32_to_cpu(rc_sq_wqe->msg_len) >
 		    hr_dev->caps.max_sq_inline) {
 			*bad_wr = wr;
@@ -190,7 +192,7 @@ static int set_rwqe_data_seg(struct ib_q
 		roce_set_bit(rc_sq_wqe->byte_4, V2_RC_SEND_WQE_BYTE_4_INLINE_S,
 			     1);
 	} else {
-		if (wr->num_sge <= HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE) {
+		if (valid_num_sge <= HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE) {
 			for (i = 0; i < wr->num_sge; i++) {
 				if (likely(wr->sg_list[i].length)) {
 					set_data_seg_v2(dseg, wr->sg_list + i);
@@ -203,19 +205,21 @@ static int set_rwqe_data_seg(struct ib_q
 				     V2_RC_SEND_WQE_BYTE_20_MSG_START_SGE_IDX_S,
 				     (*sge_ind) & (qp->sge.sge_cnt - 1));
 
-			for (i = 0; i < HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE; i++) {
+			for (i = 0; i < wr->num_sge &&
+			     j < HNS_ROCE_V2_UC_RC_SGE_NUM_IN_WQE; i++) {
 				if (likely(wr->sg_list[i].length)) {
 					set_data_seg_v2(dseg, wr->sg_list + i);
 					dseg++;
+					j++;
 				}
 			}
 
-			set_extend_sge(qp, wr, sge_ind);
+			set_extend_sge(qp, wr, sge_ind, valid_num_sge);
 		}
 
 		roce_set_field(rc_sq_wqe->byte_16,
 			       V2_RC_SEND_WQE_BYTE_16_SGE_NUM_M,
-			       V2_RC_SEND_WQE_BYTE_16_SGE_NUM_S, wr->num_sge);
+			       V2_RC_SEND_WQE_BYTE_16_SGE_NUM_S, valid_num_sge);
 	}
 
 	return 0;
@@ -243,6 +247,7 @@ static int hns_roce_v2_post_send(struct
 	unsigned int sge_idx;
 	unsigned int wqe_idx;
 	unsigned long flags;
+	int valid_num_sge;
 	void *wqe = NULL;
 	bool loopback;
 	int attr_mask;
@@ -292,8 +297,16 @@ static int hns_roce_v2_post_send(struct
 		qp->sq.wrid[wqe_idx] = wr->wr_id;
 		owner_bit =
 		       ~(((qp->sq.head + nreq) >> ilog2(qp->sq.wqe_cnt)) & 0x1);
+		valid_num_sge = 0;
 		tmp_len = 0;
 
+		for (i = 0; i < wr->num_sge; i++) {
+			if (likely(wr->sg_list[i].length)) {
+				tmp_len += wr->sg_list[i].length;
+				valid_num_sge++;
+			}
+		}
+
 		/* Corresponding to the QP type, wqe process separately */
 		if (ibqp->qp_type == IB_QPT_GSI) {
 			ud_sq_wqe = wqe;
@@ -329,9 +342,6 @@ static int hns_roce_v2_post_send(struct
 				       V2_UD_SEND_WQE_BYTE_4_OPCODE_S,
 				       HNS_ROCE_V2_WQE_OP_SEND);
 
-			for (i = 0; i < wr->num_sge; i++)
-				tmp_len += wr->sg_list[i].length;
-
 			ud_sq_wqe->msg_len =
 			 cpu_to_le32(le32_to_cpu(ud_sq_wqe->msg_len) + tmp_len);
 
@@ -367,7 +377,7 @@ static int hns_roce_v2_post_send(struct
 			roce_set_field(ud_sq_wqe->byte_16,
 				       V2_UD_SEND_WQE_BYTE_16_SGE_NUM_M,
 				       V2_UD_SEND_WQE_BYTE_16_SGE_NUM_S,
-				       wr->num_sge);
+				       valid_num_sge);
 
 			roce_set_field(ud_sq_wqe->byte_20,
 				     V2_UD_SEND_WQE_BYTE_20_MSG_START_SGE_IDX_M,
@@ -422,12 +432,10 @@ static int hns_roce_v2_post_send(struct
 			memcpy(&ud_sq_wqe->dgid[0], &ah->av.dgid[0],
 			       GID_LEN_V2);
 
-			set_extend_sge(qp, wr, &sge_idx);
+			set_extend_sge(qp, wr, &sge_idx, valid_num_sge);
 		} else if (ibqp->qp_type == IB_QPT_RC) {
 			rc_sq_wqe = wqe;
 			memset(rc_sq_wqe, 0, sizeof(*rc_sq_wqe));
-			for (i = 0; i < wr->num_sge; i++)
-				tmp_len += wr->sg_list[i].length;
 
 			rc_sq_wqe->msg_len =
 			 cpu_to_le32(le32_to_cpu(rc_sq_wqe->msg_len) + tmp_len);
@@ -548,10 +556,11 @@ static int hns_roce_v2_post_send(struct
 				roce_set_field(rc_sq_wqe->byte_16,
 					       V2_RC_SEND_WQE_BYTE_16_SGE_NUM_M,
 					       V2_RC_SEND_WQE_BYTE_16_SGE_NUM_S,
-					       wr->num_sge);
+					       valid_num_sge);
 			} else if (wr->opcode != IB_WR_REG_MR) {
 				ret = set_rwqe_data_seg(ibqp, wr, rc_sq_wqe,
-							wqe, &sge_idx, bad_wr);
+							wqe, &sge_idx,
+							valid_num_sge, bad_wr);
 				if (ret)
 					goto out;
 			}


