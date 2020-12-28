Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22E912E413D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:04:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439715AbgL1OLs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:11:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:46114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438262AbgL1OLe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:34 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E0FC2063A;
        Mon, 28 Dec 2020 14:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164653;
        bh=J7uXcimMyrLG0k4XiOsYBhJdZDeCruM9JJ28bnHkbC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQ1YjirWUeWa4TNZBmh20mtANg/P4yKV45omUv/3ulL4BnaUqWxl/7Ws0hg9+2Zq8
         alyx0XSK2zjpG3zpePtS1sGEJRfeJUwVC5N24whGh7lQ/YMm7SPZ7STegwi/y4ZBOr
         ixmJ1I4lcW9BYkR/6NKyKib07BRr5tATjtHXFd3Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Cheng <chenglang@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 251/717] RDMA/hns: Fix 0-length sge calculation error
Date:   Mon, 28 Dec 2020 13:44:09 +0100
Message-Id: <20201228125033.014391388@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

[ Upstream commit 0fd0175e30e487f8d70ecb2cdd67fbb514fdf50f ]

One RC SQ WQE can store 2 sges but UD can't, so ignore 2 valid sges of
wr.sglist for RC which have been filled in WQE before setting extended
sge.  Either of RC and UD can not contain 0-length sges, so these 0-length
sges should be skipped.

Fixes: 54d6638765b0 ("RDMA/hns: Optimize WQE buffer size calculating process")
Link: https://lore.kernel.org/r/1606558959-48510-2-git-send-email-liweihang@huawei.com
Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 24 +++++++++-------------
 1 file changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 4db7eea3dcec5..c287dbd2f384d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -214,25 +214,20 @@ static int fill_ext_sge_inl_data(struct hns_roce_qp *qp,
 	return 0;
 }
 
-static void set_extend_sge(struct hns_roce_qp *qp, const struct ib_send_wr *wr,
-			   unsigned int *sge_ind, unsigned int valid_num_sge)
+static void set_extend_sge(struct hns_roce_qp *qp, struct ib_sge *sge,
+			   unsigned int *sge_ind, unsigned int cnt)
 {
 	struct hns_roce_v2_wqe_data_seg *dseg;
-	unsigned int cnt = valid_num_sge;
-	struct ib_sge *sge = wr->sg_list;
 	unsigned int idx = *sge_ind;
 
-	if (qp->ibqp.qp_type == IB_QPT_RC || qp->ibqp.qp_type == IB_QPT_UC) {
-		cnt -= HNS_ROCE_SGE_IN_WQE;
-		sge += HNS_ROCE_SGE_IN_WQE;
-	}
-
 	while (cnt > 0) {
 		dseg = hns_roce_get_extend_sge(qp, idx & (qp->sge.sge_cnt - 1));
-		set_data_seg_v2(dseg, sge);
-		idx++;
+		if (likely(sge->length)) {
+			set_data_seg_v2(dseg, sge);
+			idx++;
+			cnt--;
+		}
 		sge++;
-		cnt--;
 	}
 
 	*sge_ind = idx;
@@ -340,7 +335,8 @@ static int set_rwqe_data_seg(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 			}
 		}
 
-		set_extend_sge(qp, wr, sge_ind, valid_num_sge);
+		set_extend_sge(qp, wr->sg_list + i, sge_ind,
+			       valid_num_sge - HNS_ROCE_SGE_IN_WQE);
 	}
 
 	roce_set_field(rc_sq_wqe->byte_16,
@@ -511,7 +507,7 @@ static inline int set_ud_wqe(struct hns_roce_qp *qp,
 
 	memcpy(&ud_sq_wqe->dgid[0], &ah->av.dgid[0], GID_LEN_V2);
 
-	set_extend_sge(qp, wr, &curr_idx, valid_num_sge);
+	set_extend_sge(qp, wr->sg_list, &curr_idx, valid_num_sge);
 
 	*sge_idx = curr_idx;
 
-- 
2.27.0



