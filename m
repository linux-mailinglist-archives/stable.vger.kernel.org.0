Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C24FE420E65
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236711AbhJDNYz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:24:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:36964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236791AbhJDNXM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:23:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A72C361B5D;
        Mon,  4 Oct 2021 13:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352999;
        bh=KSlL8iGdc3dWXz+AfDzxxW6RIYJTQIkEFCI2WmVNJwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFzvGD726g1YeWbCUWRzHEvRZxHXLD4C7DF3k2WnYvDSs/4/8ITqPN7ENSqrwpU+O
         Fn5lbPq+nlaOM0bUxlDPa0Ubxc56zzi3gVt6mzy6vHKC3j5JJqO0WfQuiBt7kharRZ
         Wz7yh6b3xVfdYhrJyyquHZ4Lbtg1rLor8MnjJtoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yixing Liu <liuyixing1@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 48/93] RDMA/hns: Fix inaccurate prints
Date:   Mon,  4 Oct 2021 14:52:46 +0200
Message-Id: <20211004125036.148352581@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125034.579439135@linuxfoundation.org>
References: <20211004125034.579439135@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yixing Liu <liuyixing1@huawei.com>

[ Upstream commit 61918e9b008492f48577692428aca3cebf56111a ]

Some %d in print format string should be %u, and some prints miss the
useful errno or are in nonstandard format. Just fix above issues.

Link: https://lore.kernel.org/r/1607650657-35992-11-git-send-email-liweihang@huawei.com
Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_alloc.c |  4 +-
 drivers/infiniband/hw/hns/hns_roce_cq.c    | 35 +++++++------
 drivers/infiniband/hw/hns/hns_roce_hem.c   | 18 +++----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 30 +++++------
 drivers/infiniband/hw/hns/hns_roce_mr.c    | 10 ++--
 drivers/infiniband/hw/hns/hns_roce_pd.c    |  2 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c    | 61 +++++++++++++---------
 drivers/infiniband/hw/hns/hns_roce_srq.c   | 37 +++++++------
 8 files changed, 107 insertions(+), 90 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_alloc.c b/drivers/infiniband/hw/hns/hns_roce_alloc.c
index a6b23dec1adc..5b2baf89d110 100644
--- a/drivers/infiniband/hw/hns/hns_roce_alloc.c
+++ b/drivers/infiniband/hw/hns/hns_roce_alloc.c
@@ -240,7 +240,7 @@ int hns_roce_get_kmem_bufs(struct hns_roce_dev *hr_dev, dma_addr_t *bufs,
 	end = start + buf_cnt;
 	if (end > buf->npages) {
 		dev_err(hr_dev->dev,
-			"Failed to check kmem bufs, end %d + %d total %d!\n",
+			"failed to check kmem bufs, end %d + %d total %u!\n",
 			start, buf_cnt, buf->npages);
 		return -EINVAL;
 	}
@@ -262,7 +262,7 @@ int hns_roce_get_umem_bufs(struct hns_roce_dev *hr_dev, dma_addr_t *bufs,
 	u64 addr;
 
 	if (page_shift < HNS_HW_PAGE_SHIFT) {
-		dev_err(hr_dev->dev, "Failed to check umem page shift %d!\n",
+		dev_err(hr_dev->dev, "failed to check umem page shift %u!\n",
 			page_shift);
 		return -EINVAL;
 	}
diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index da346129f6e9..8a6bded9c11c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -50,29 +50,29 @@ static int alloc_cqc(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
 
 	ret = hns_roce_mtr_find(hr_dev, &hr_cq->mtr, 0, mtts, ARRAY_SIZE(mtts),
 				&dma_handle);
-	if (ret < 1) {
-		ibdev_err(ibdev, "Failed to find CQ mtr\n");
+	if (!ret) {
+		ibdev_err(ibdev, "failed to find CQ mtr, ret = %d.\n", ret);
 		return -EINVAL;
 	}
 
 	cq_table = &hr_dev->cq_table;
 	ret = hns_roce_bitmap_alloc(&cq_table->bitmap, &hr_cq->cqn);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to alloc CQ bitmap, err %d\n", ret);
+		ibdev_err(ibdev, "failed to alloc CQ bitmap, ret = %d.\n", ret);
 		return ret;
 	}
 
 	/* Get CQC memory HEM(Hardware Entry Memory) table */
 	ret = hns_roce_table_get(hr_dev, &cq_table->table, hr_cq->cqn);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to get CQ(0x%lx) context, err %d\n",
+		ibdev_err(ibdev, "failed to get CQ(0x%lx) context, ret = %d.\n",
 			  hr_cq->cqn, ret);
 		goto err_out;
 	}
 
 	ret = xa_err(xa_store(&cq_table->array, hr_cq->cqn, hr_cq, GFP_KERNEL));
 	if (ret) {
-		ibdev_err(ibdev, "Failed to xa_store CQ\n");
+		ibdev_err(ibdev, "failed to xa_store CQ, ret = %d.\n", ret);
 		goto err_put;
 	}
 
@@ -91,7 +91,7 @@ static int alloc_cqc(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
 	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
 	if (ret) {
 		ibdev_err(ibdev,
-			  "Failed to send create cmd for CQ(0x%lx), err %d\n",
+			  "failed to send create cmd for CQ(0x%lx), ret = %d.\n",
 			  hr_cq->cqn, ret);
 		goto err_xa;
 	}
@@ -147,7 +147,7 @@ static int alloc_cq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq,
 {
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	struct hns_roce_buf_attr buf_attr = {};
-	int err;
+	int ret;
 
 	buf_attr.page_shift = hr_dev->caps.cqe_buf_pg_sz + HNS_HW_PAGE_SHIFT;
 	buf_attr.region[0].size = hr_cq->cq_depth * hr_cq->cqe_size;
@@ -155,13 +155,13 @@ static int alloc_cq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq,
 	buf_attr.region_count = 1;
 	buf_attr.fixed_page = true;
 
-	err = hns_roce_mtr_create(hr_dev, &hr_cq->mtr, &buf_attr,
+	ret = hns_roce_mtr_create(hr_dev, &hr_cq->mtr, &buf_attr,
 				  hr_dev->caps.cqe_ba_pg_sz + HNS_HW_PAGE_SHIFT,
 				  udata, addr);
-	if (err)
-		ibdev_err(ibdev, "Failed to alloc CQ mtr, err %d\n", err);
+	if (ret)
+		ibdev_err(ibdev, "failed to alloc CQ mtr, ret = %d.\n", ret);
 
-	return err;
+	return ret;
 }
 
 static void free_cq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_cq *hr_cq)
@@ -252,13 +252,13 @@ int hns_roce_create_cq(struct ib_cq *ib_cq, const struct ib_cq_init_attr *attr,
 	int ret;
 
 	if (cq_entries < 1 || cq_entries > hr_dev->caps.max_cqes) {
-		ibdev_err(ibdev, "Failed to check CQ count %d max=%d\n",
+		ibdev_err(ibdev, "failed to check CQ count %u, max = %u.\n",
 			  cq_entries, hr_dev->caps.max_cqes);
 		return -EINVAL;
 	}
 
 	if (vector >= hr_dev->caps.num_comp_vectors) {
-		ibdev_err(ibdev, "Failed to check CQ vector=%d max=%d\n",
+		ibdev_err(ibdev, "failed to check CQ vector = %d, max = %d.\n",
 			  vector, hr_dev->caps.num_comp_vectors);
 		return -EINVAL;
 	}
@@ -276,7 +276,7 @@ int hns_roce_create_cq(struct ib_cq *ib_cq, const struct ib_cq_init_attr *attr,
 		ret = ib_copy_from_udata(&ucmd, udata,
 					 min(udata->inlen, sizeof(ucmd)));
 		if (ret) {
-			ibdev_err(ibdev, "Failed to copy CQ udata, err %d\n",
+			ibdev_err(ibdev, "failed to copy CQ udata, ret = %d.\n",
 				  ret);
 			return ret;
 		}
@@ -286,19 +286,20 @@ int hns_roce_create_cq(struct ib_cq *ib_cq, const struct ib_cq_init_attr *attr,
 
 	ret = alloc_cq_buf(hr_dev, hr_cq, udata, ucmd.buf_addr);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to alloc CQ buf, err %d\n", ret);
+		ibdev_err(ibdev, "failed to alloc CQ buf, ret = %d.\n", ret);
 		return ret;
 	}
 
 	ret = alloc_cq_db(hr_dev, hr_cq, udata, ucmd.db_addr, &resp);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to alloc CQ db, err %d\n", ret);
+		ibdev_err(ibdev, "failed to alloc CQ db, ret = %d.\n", ret);
 		goto err_cq_buf;
 	}
 
 	ret = alloc_cqc(hr_dev, hr_cq);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to alloc CQ context, err %d\n", ret);
+		ibdev_err(ibdev,
+			  "failed to alloc CQ context, ret = %d.\n", ret);
 		goto err_cq_db;
 	}
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 66f9f036ef94..c880a8be7e3c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -184,7 +184,7 @@ static int get_hem_table_config(struct hns_roce_dev *hr_dev,
 		mhop->hop_num = hr_dev->caps.srqc_hop_num;
 		break;
 	default:
-		dev_err(dev, "Table %d not support multi-hop addressing!\n",
+		dev_err(dev, "table %u not support multi-hop addressing!\n",
 			type);
 		return -EINVAL;
 	}
@@ -232,8 +232,8 @@ int hns_roce_calc_hem_mhop(struct hns_roce_dev *hr_dev,
 		mhop->l0_idx = table_idx;
 		break;
 	default:
-		dev_err(dev, "Table %d not support hop_num = %d!\n",
-			     table->type, mhop->hop_num);
+		dev_err(dev, "table %u not support hop_num = %u!\n",
+			table->type, mhop->hop_num);
 		return -EINVAL;
 	}
 	if (mhop->l0_idx >= mhop->ba_l0_num)
@@ -438,13 +438,13 @@ static int calc_hem_config(struct hns_roce_dev *hr_dev,
 		index->buf = l0_idx;
 		break;
 	default:
-		ibdev_err(ibdev, "Table %d not support mhop.hop_num = %d!\n",
+		ibdev_err(ibdev, "table %u not support mhop.hop_num = %u!\n",
 			  table->type, mhop->hop_num);
 		return -EINVAL;
 	}
 
 	if (unlikely(index->buf >= table->num_hem)) {
-		ibdev_err(ibdev, "Table %d exceed hem limt idx %llu,max %lu!\n",
+		ibdev_err(ibdev, "table %u exceed hem limt idx %llu, max %lu!\n",
 			  table->type, index->buf, table->num_hem);
 		return -EINVAL;
 	}
@@ -714,15 +714,15 @@ static void clear_mhop_hem(struct hns_roce_dev *hr_dev,
 			step_idx = hop_num;
 
 		if (hr_dev->hw->clear_hem(hr_dev, table, obj, step_idx))
-			ibdev_warn(ibdev, "Clear hop%d HEM failed.\n", hop_num);
+			ibdev_warn(ibdev, "failed to clear hop%u HEM.\n", hop_num);
 
 		if (index->inited & HEM_INDEX_L1)
 			if (hr_dev->hw->clear_hem(hr_dev, table, obj, 1))
-				ibdev_warn(ibdev, "Clear HEM step 1 failed.\n");
+				ibdev_warn(ibdev, "failed to clear HEM step 1.\n");
 
 		if (index->inited & HEM_INDEX_L0)
 			if (hr_dev->hw->clear_hem(hr_dev, table, obj, 0))
-				ibdev_warn(ibdev, "Clear HEM step 0 failed.\n");
+				ibdev_warn(ibdev, "failed to clear HEM step 0.\n");
 	}
 }
 
@@ -1234,7 +1234,7 @@ static int hem_list_alloc_mid_bt(struct hns_roce_dev *hr_dev,
 	}
 
 	if (offset < r->offset) {
-		dev_err(hr_dev->dev, "invalid offset %d,min %d!\n",
+		dev_err(hr_dev->dev, "invalid offset %d, min %u!\n",
 			offset, r->offset);
 		return -EINVAL;
 	}
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index ebcf26dec1e3..c29ba8ee51e2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -361,7 +361,7 @@ static int check_send_valid(struct hns_roce_dev *hr_dev,
 	} else if (unlikely(hr_qp->state == IB_QPS_RESET ||
 		   hr_qp->state == IB_QPS_INIT ||
 		   hr_qp->state == IB_QPS_RTR)) {
-		ibdev_err(ibdev, "failed to post WQE, QP state %d!\n",
+		ibdev_err(ibdev, "failed to post WQE, QP state %hhu!\n",
 			  hr_qp->state);
 		return -EINVAL;
 	} else if (unlikely(hr_dev->state >= HNS_ROCE_DEVICE_STATE_RST_DOWN)) {
@@ -665,7 +665,7 @@ static int hns_roce_v2_post_send(struct ib_qp *ibqp,
 		wqe_idx = (qp->sq.head + nreq) & (qp->sq.wqe_cnt - 1);
 
 		if (unlikely(wr->num_sge > qp->sq.max_gs)) {
-			ibdev_err(ibdev, "num_sge=%d > qp->sq.max_gs=%d\n",
+			ibdev_err(ibdev, "num_sge = %d > qp->sq.max_gs = %u.\n",
 				  wr->num_sge, qp->sq.max_gs);
 			ret = -EINVAL;
 			*bad_wr = wr;
@@ -750,7 +750,7 @@ static int hns_roce_v2_post_recv(struct ib_qp *ibqp,
 		wqe_idx = (hr_qp->rq.head + nreq) & (hr_qp->rq.wqe_cnt - 1);
 
 		if (unlikely(wr->num_sge > hr_qp->rq.max_gs)) {
-			ibdev_err(ibdev, "rq:num_sge=%d >= qp->sq.max_gs=%d\n",
+			ibdev_err(ibdev, "num_sge = %d >= max_sge = %u.\n",
 				  wr->num_sge, hr_qp->rq.max_gs);
 			ret = -EINVAL;
 			*bad_wr = wr;
@@ -1920,8 +1920,8 @@ static void calc_pg_sz(int obj_num, int obj_size, int hop_num, int ctx_bt_num,
 		obj_per_chunk = ctx_bt_num * obj_per_chunk_default;
 		break;
 	default:
-		pr_err("Table %d not support hop_num = %d!\n", hem_type,
-			hop_num);
+		pr_err("table %u not support hop_num = %u!\n", hem_type,
+		       hop_num);
 		return;
 	}
 
@@ -3562,7 +3562,7 @@ static int get_op_for_set_hem(struct hns_roce_dev *hr_dev, u32 type,
 		break;
 	default:
 		dev_warn(hr_dev->dev,
-			 "Table %d not to be written by mailbox!\n", type);
+			 "table %u not to be written by mailbox!\n", type);
 		return -EINVAL;
 	}
 
@@ -3681,7 +3681,7 @@ static int hns_roce_v2_clear_hem(struct hns_roce_dev *hr_dev,
 		op = HNS_ROCE_CMD_DESTROY_SRQC_BT0;
 		break;
 	default:
-		dev_warn(dev, "Table %d not to be destroyed by mailbox!\n",
+		dev_warn(dev, "table %u not to be destroyed by mailbox!\n",
 			 table->type);
 		return 0;
 	}
@@ -4318,7 +4318,7 @@ static int modify_qp_rtr_to_rts(struct ib_qp *ibqp,
 
 	ret = config_qp_sq_buf(hr_dev, hr_qp, context, qpc_mask);
 	if (ret) {
-		ibdev_err(ibdev, "failed to config sq buf, ret %d\n", ret);
+		ibdev_err(ibdev, "failed to config sq buf, ret = %d.\n", ret);
 		return ret;
 	}
 
@@ -4804,7 +4804,7 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 	/* SW pass context to HW */
 	ret = hns_roce_v2_qp_modify(hr_dev, context, qpc_mask, hr_qp);
 	if (ret) {
-		ibdev_err(ibdev, "failed to modify QP, ret = %d\n", ret);
+		ibdev_err(ibdev, "failed to modify QP, ret = %d.\n", ret);
 		goto out;
 	}
 
@@ -4897,7 +4897,7 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 
 	ret = hns_roce_v2_query_qpc(hr_dev, hr_qp, &context);
 	if (ret) {
-		ibdev_err(ibdev, "failed to query QPC, ret = %d\n", ret);
+		ibdev_err(ibdev, "failed to query QPC, ret = %d.\n", ret);
 		ret = -EINVAL;
 		goto out;
 	}
@@ -5018,7 +5018,7 @@ static int hns_roce_v2_destroy_qp_common(struct hns_roce_dev *hr_dev,
 					    hr_qp->state, IB_QPS_RESET);
 		if (ret)
 			ibdev_err(ibdev,
-				  "failed to modify QP to RST, ret = %d\n",
+				  "failed to modify QP to RST, ret = %d.\n",
 				  ret);
 	}
 
@@ -5057,7 +5057,7 @@ static int hns_roce_v2_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 	ret = hns_roce_v2_destroy_qp_common(hr_dev, hr_qp, udata);
 	if (ret)
 		ibdev_err(&hr_dev->ib_dev,
-			  "failed to destroy QP 0x%06lx, ret = %d\n",
+			  "failed to destroy QP, QPN = 0x%06lx, ret = %d.\n",
 			  hr_qp->qpn, ret);
 
 	hns_roce_qp_destroy(hr_dev, hr_qp, udata);
@@ -5080,7 +5080,7 @@ static int hns_roce_v2_qp_flow_control_init(struct hns_roce_dev *hr_dev,
 	hns_roce_cmq_setup_basic_desc(&desc, HNS_ROCE_OPC_RESET_SCCC, false);
 	ret =  hns_roce_cmq_send(hr_dev, &desc, 1);
 	if (ret) {
-		ibdev_err(ibdev, "failed to reset SCC ctx, ret = %d\n", ret);
+		ibdev_err(ibdev, "failed to reset SCC ctx, ret = %d.\n", ret);
 		goto out;
 	}
 
@@ -5090,7 +5090,7 @@ static int hns_roce_v2_qp_flow_control_init(struct hns_roce_dev *hr_dev,
 	clr->qpn = cpu_to_le32(hr_qp->qpn);
 	ret =  hns_roce_cmq_send(hr_dev, &desc, 1);
 	if (ret) {
-		ibdev_err(ibdev, "failed to clear SCC ctx, ret = %d\n", ret);
+		ibdev_err(ibdev, "failed to clear SCC ctx, ret = %d.\n", ret);
 		goto out;
 	}
 
@@ -5339,7 +5339,7 @@ static int hns_roce_v2_modify_cq(struct ib_cq *cq, u16 cq_count, u16 cq_period)
 	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
 	if (ret)
 		ibdev_err(&hr_dev->ib_dev,
-			  "failed to process cmd when modifying CQ, ret = %d\n",
+			  "failed to process cmd when modifying CQ, ret = %d.\n",
 			  ret);
 
 	return ret;
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 7f81a695e9af..027ec8413ac2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -185,14 +185,14 @@ static int hns_roce_mr_enable(struct hns_roce_dev *hr_dev,
 	else
 		ret = hr_dev->hw->frmr_write_mtpt(hr_dev, mailbox->buf, mr);
 	if (ret) {
-		dev_err(dev, "Write mtpt fail!\n");
+		dev_err(dev, "failed to write mtpt, ret = %d.\n", ret);
 		goto err_page;
 	}
 
 	ret = hns_roce_hw_create_mpt(hr_dev, mailbox,
 				     mtpt_idx & (hr_dev->caps.num_mtpts - 1));
 	if (ret) {
-		dev_err(dev, "CREATE_MPT failed (%d)\n", ret);
+		dev_err(dev, "failed to create mpt, ret = %d.\n", ret);
 		goto err_page;
 	}
 
@@ -495,7 +495,7 @@ int hns_roce_map_mr_sg(struct ib_mr *ibmr, struct scatterlist *sg, int sg_nents,
 
 	ret = ib_sg_to_pages(ibmr, sg, sg_nents, sg_offset, hns_roce_set_page);
 	if (ret < 1) {
-		ibdev_err(ibdev, "failed to store sg pages %d %d, cnt = %d.\n",
+		ibdev_err(ibdev, "failed to store sg pages %u %u, cnt = %d.\n",
 			  mr->npages, mr->pbl_mtr.hem_cfg.buf_pg_count, ret);
 		goto err_page_list;
 	}
@@ -862,7 +862,7 @@ int hns_roce_mtr_map(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 		if (r->offset + r->count > page_cnt) {
 			err = -EINVAL;
 			ibdev_err(ibdev,
-				  "Failed to check mtr%d end %d + %d, max %d\n",
+				  "failed to check mtr%u end %u + %u, max %u.\n",
 				  i, r->offset, r->count, page_cnt);
 			return err;
 		}
@@ -870,7 +870,7 @@ int hns_roce_mtr_map(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 		err = mtr_map_region(hr_dev, mtr, &pages[r->offset], r);
 		if (err) {
 			ibdev_err(ibdev,
-				  "Failed to map mtr%d offset %d, err %d\n",
+				  "failed to map mtr%u offset %u, ret = %d.\n",
 				  i, r->offset, err);
 			return err;
 		}
diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
index f78fa1d3d807..012a769d6a6a 100644
--- a/drivers/infiniband/hw/hns/hns_roce_pd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
@@ -65,7 +65,7 @@ int hns_roce_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 
 	ret = hns_roce_pd_alloc(to_hr_dev(ib_dev), &pd->pdn);
 	if (ret) {
-		ibdev_err(ib_dev, "failed to alloc pd, ret = %d\n", ret);
+		ibdev_err(ib_dev, "failed to alloc pd, ret = %d.\n", ret);
 		return ret;
 	}
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 7ce9ad8aee1e..291e06d63150 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -452,12 +452,12 @@ static int check_sq_size_with_integrity(struct hns_roce_dev *hr_dev,
 	/* Sanity check SQ size before proceeding */
 	if (ucmd->log_sq_stride > max_sq_stride ||
 	    ucmd->log_sq_stride < HNS_ROCE_IB_MIN_SQ_STRIDE) {
-		ibdev_err(&hr_dev->ib_dev, "Failed to check SQ stride size\n");
+		ibdev_err(&hr_dev->ib_dev, "failed to check SQ stride size.\n");
 		return -EINVAL;
 	}
 
 	if (cap->max_send_sge > hr_dev->caps.max_sq_sg) {
-		ibdev_err(&hr_dev->ib_dev, "Failed to check SQ SGE size %d\n",
+		ibdev_err(&hr_dev->ib_dev, "failed to check SQ SGE size %u.\n",
 			  cap->max_send_sge);
 		return -EINVAL;
 	}
@@ -563,7 +563,7 @@ static int set_kernel_sq_size(struct hns_roce_dev *hr_dev,
 
 	cnt = roundup_pow_of_two(max(cap->max_send_wr, hr_dev->caps.min_wqes));
 	if (cnt > hr_dev->caps.max_wqes) {
-		ibdev_err(ibdev, "failed to check WQE num, WQE num = %d.\n",
+		ibdev_err(ibdev, "failed to check WQE num, WQE num = %u.\n",
 			  cnt);
 		return -EINVAL;
 	}
@@ -736,7 +736,8 @@ static int alloc_qp_db(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 						   &hr_qp->sdb);
 			if (ret) {
 				ibdev_err(ibdev,
-					  "Failed to map user SQ doorbell\n");
+					  "failed to map user SQ doorbell, ret = %d.\n",
+					  ret);
 				goto err_out;
 			}
 			hr_qp->en_flags |= HNS_ROCE_QP_CAP_SQ_RECORD_DB;
@@ -747,7 +748,8 @@ static int alloc_qp_db(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 						   &hr_qp->rdb);
 			if (ret) {
 				ibdev_err(ibdev,
-					  "Failed to map user RQ doorbell\n");
+					  "failed to map user RQ doorbell, ret = %d.\n",
+					  ret);
 				goto err_sdb;
 			}
 			hr_qp->en_flags |= HNS_ROCE_QP_CAP_RQ_RECORD_DB;
@@ -763,7 +765,8 @@ static int alloc_qp_db(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 			ret = hns_roce_alloc_db(hr_dev, &hr_qp->rdb, 0);
 			if (ret) {
 				ibdev_err(ibdev,
-					  "Failed to alloc kernel RQ doorbell\n");
+					  "failed to alloc kernel RQ doorbell, ret = %d.\n",
+					  ret);
 				goto err_out;
 			}
 			*hr_qp->rdb.db_record = 0;
@@ -806,14 +809,14 @@ static int alloc_kernel_wrid(struct hns_roce_dev *hr_dev,
 
 	sq_wrid = kcalloc(hr_qp->sq.wqe_cnt, sizeof(u64), GFP_KERNEL);
 	if (ZERO_OR_NULL_PTR(sq_wrid)) {
-		ibdev_err(ibdev, "Failed to alloc SQ wrid\n");
+		ibdev_err(ibdev, "failed to alloc SQ wrid.\n");
 		return -ENOMEM;
 	}
 
 	if (hr_qp->rq.wqe_cnt) {
 		rq_wrid = kcalloc(hr_qp->rq.wqe_cnt, sizeof(u64), GFP_KERNEL);
 		if (ZERO_OR_NULL_PTR(rq_wrid)) {
-			ibdev_err(ibdev, "Failed to alloc RQ wrid\n");
+			ibdev_err(ibdev, "failed to alloc RQ wrid.\n");
 			ret = -ENOMEM;
 			goto err_sq;
 		}
@@ -873,7 +876,9 @@ static int set_qp_param(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 
 		ret = set_user_sq_size(hr_dev, &init_attr->cap, hr_qp, ucmd);
 		if (ret)
-			ibdev_err(ibdev, "Failed to set user SQ size\n");
+			ibdev_err(ibdev,
+				  "failed to set user SQ size, ret = %d.\n",
+				  ret);
 	} else {
 		if (init_attr->create_flags &
 		    IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK) {
@@ -888,7 +893,9 @@ static int set_qp_param(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 
 		ret = set_kernel_sq_size(hr_dev, &init_attr->cap, hr_qp);
 		if (ret)
-			ibdev_err(ibdev, "Failed to set kernel SQ size\n");
+			ibdev_err(ibdev,
+				  "failed to set kernel SQ size, ret = %d.\n",
+				  ret);
 	}
 
 	return ret;
@@ -914,45 +921,48 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 
 	ret = set_qp_param(hr_dev, hr_qp, init_attr, udata, &ucmd);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to set QP param\n");
+		ibdev_err(ibdev, "failed to set QP param, ret = %d.\n", ret);
 		return ret;
 	}
 
 	if (!udata) {
 		ret = alloc_kernel_wrid(hr_dev, hr_qp);
 		if (ret) {
-			ibdev_err(ibdev, "Failed to alloc wrid\n");
+			ibdev_err(ibdev, "failed to alloc wrid, ret = %d.\n",
+				  ret);
 			return ret;
 		}
 	}
 
 	ret = alloc_qp_db(hr_dev, hr_qp, init_attr, udata, &ucmd, &resp);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to alloc QP doorbell\n");
+		ibdev_err(ibdev, "failed to alloc QP doorbell, ret = %d.\n",
+			  ret);
 		goto err_wrid;
 	}
 
 	ret = alloc_qp_buf(hr_dev, hr_qp, init_attr, udata, ucmd.buf_addr);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to alloc QP buffer\n");
+		ibdev_err(ibdev, "failed to alloc QP buffer, ret = %d.\n", ret);
 		goto err_db;
 	}
 
 	ret = alloc_qpn(hr_dev, hr_qp);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to alloc QPN\n");
+		ibdev_err(ibdev, "failed to alloc QPN, ret = %d.\n", ret);
 		goto err_buf;
 	}
 
 	ret = alloc_qpc(hr_dev, hr_qp);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to alloc QP context\n");
+		ibdev_err(ibdev, "failed to alloc QP context, ret = %d.\n",
+			  ret);
 		goto err_qpn;
 	}
 
 	ret = hns_roce_qp_store(hr_dev, hr_qp, init_attr);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to store QP\n");
+		ibdev_err(ibdev, "failed to store QP, ret = %d.\n", ret);
 		goto err_qpc;
 	}
 
@@ -1098,9 +1108,8 @@ static int hns_roce_check_qp_attr(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 
 	if ((attr_mask & IB_QP_PORT) &&
 	    (attr->port_num == 0 || attr->port_num > hr_dev->caps.num_ports)) {
-		ibdev_err(&hr_dev->ib_dev,
-			"attr port_num invalid.attr->port_num=%d\n",
-			attr->port_num);
+		ibdev_err(&hr_dev->ib_dev, "invalid attr, port_num = %u.\n",
+			  attr->port_num);
 		return -EINVAL;
 	}
 
@@ -1108,8 +1117,8 @@ static int hns_roce_check_qp_attr(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		p = attr_mask & IB_QP_PORT ? (attr->port_num - 1) : hr_qp->port;
 		if (attr->pkey_index >= hr_dev->caps.pkey_table_len[p]) {
 			ibdev_err(&hr_dev->ib_dev,
-				"attr pkey_index invalid.attr->pkey_index=%d\n",
-				attr->pkey_index);
+				  "invalid attr, pkey_index = %u.\n",
+				  attr->pkey_index);
 			return -EINVAL;
 		}
 	}
@@ -1117,16 +1126,16 @@ static int hns_roce_check_qp_attr(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	if (attr_mask & IB_QP_MAX_QP_RD_ATOMIC &&
 	    attr->max_rd_atomic > hr_dev->caps.max_qp_init_rdma) {
 		ibdev_err(&hr_dev->ib_dev,
-			"attr max_rd_atomic invalid.attr->max_rd_atomic=%d\n",
-			attr->max_rd_atomic);
+			  "invalid attr, max_rd_atomic = %u.\n",
+			  attr->max_rd_atomic);
 		return -EINVAL;
 	}
 
 	if (attr_mask & IB_QP_MAX_DEST_RD_ATOMIC &&
 	    attr->max_dest_rd_atomic > hr_dev->caps.max_qp_dest_rdma) {
 		ibdev_err(&hr_dev->ib_dev,
-			"attr max_dest_rd_atomic invalid.attr->max_dest_rd_atomic=%d\n",
-			attr->max_dest_rd_atomic);
+			  "invalid attr, max_dest_rd_atomic = %u.\n",
+			  attr->max_dest_rd_atomic);
 		return -EINVAL;
 	}
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 75d74f4bb52c..f27523e1a12d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -93,7 +93,8 @@ static int alloc_srqc(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq,
 	ret = hns_roce_mtr_find(hr_dev, &srq->buf_mtr, 0, mtts_wqe,
 				ARRAY_SIZE(mtts_wqe), &dma_handle_wqe);
 	if (ret < 1) {
-		ibdev_err(ibdev, "Failed to find mtr for SRQ WQE\n");
+		ibdev_err(ibdev, "failed to find mtr for SRQ WQE, ret = %d.\n",
+			  ret);
 		return -ENOBUFS;
 	}
 
@@ -101,32 +102,34 @@ static int alloc_srqc(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq,
 	ret = hns_roce_mtr_find(hr_dev, &srq->idx_que.mtr, 0, mtts_idx,
 				ARRAY_SIZE(mtts_idx), &dma_handle_idx);
 	if (ret < 1) {
-		ibdev_err(ibdev, "Failed to find mtr for SRQ idx\n");
+		ibdev_err(ibdev, "failed to find mtr for SRQ idx, ret = %d.\n",
+			  ret);
 		return -ENOBUFS;
 	}
 
 	ret = hns_roce_bitmap_alloc(&srq_table->bitmap, &srq->srqn);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to alloc SRQ number, err %d\n", ret);
+		ibdev_err(ibdev,
+			  "failed to alloc SRQ number, ret = %d.\n", ret);
 		return -ENOMEM;
 	}
 
 	ret = hns_roce_table_get(hr_dev, &srq_table->table, srq->srqn);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to get SRQC table, err %d\n", ret);
+		ibdev_err(ibdev, "failed to get SRQC table, ret = %d.\n", ret);
 		goto err_out;
 	}
 
 	ret = xa_err(xa_store(&srq_table->xa, srq->srqn, srq, GFP_KERNEL));
 	if (ret) {
-		ibdev_err(ibdev, "Failed to store SRQC, err %d\n", ret);
+		ibdev_err(ibdev, "failed to store SRQC, ret = %d.\n", ret);
 		goto err_put;
 	}
 
 	mailbox = hns_roce_alloc_cmd_mailbox(hr_dev);
 	if (IS_ERR_OR_NULL(mailbox)) {
 		ret = -ENOMEM;
-		ibdev_err(ibdev, "Failed to alloc mailbox for SRQC\n");
+		ibdev_err(ibdev, "failed to alloc mailbox for SRQC.\n");
 		goto err_xa;
 	}
 
@@ -137,7 +140,7 @@ static int alloc_srqc(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq,
 	ret = hns_roce_hw_create_srq(hr_dev, mailbox, srq->srqn);
 	hns_roce_free_cmd_mailbox(hr_dev, mailbox);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to config SRQC, err %d\n", ret);
+		ibdev_err(ibdev, "failed to config SRQC, ret = %d.\n", ret);
 		goto err_xa;
 	}
 
@@ -198,7 +201,8 @@ static int alloc_srq_buf(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq,
 				  hr_dev->caps.srqwqe_ba_pg_sz +
 				  HNS_HW_PAGE_SHIFT, udata, addr);
 	if (err)
-		ibdev_err(ibdev, "Failed to alloc SRQ buf mtr, err %d\n", err);
+		ibdev_err(ibdev,
+			  "failed to alloc SRQ buf mtr, ret = %d.\n", err);
 
 	return err;
 }
@@ -229,14 +233,15 @@ static int alloc_srq_idx(struct hns_roce_dev *hr_dev, struct hns_roce_srq *srq,
 				  hr_dev->caps.idx_ba_pg_sz + HNS_HW_PAGE_SHIFT,
 				  udata, addr);
 	if (err) {
-		ibdev_err(ibdev, "Failed to alloc SRQ idx mtr, err %d\n", err);
+		ibdev_err(ibdev,
+			  "failed to alloc SRQ idx mtr, ret = %d.\n", err);
 		return err;
 	}
 
 	if (!udata) {
 		idx_que->bitmap = bitmap_zalloc(srq->wqe_cnt, GFP_KERNEL);
 		if (!idx_que->bitmap) {
-			ibdev_err(ibdev, "Failed to alloc SRQ idx bitmap\n");
+			ibdev_err(ibdev, "failed to alloc SRQ idx bitmap.\n");
 			err = -ENOMEM;
 			goto err_idx_mtr;
 		}
@@ -303,7 +308,7 @@ int hns_roce_create_srq(struct ib_srq *ib_srq,
 		ret = ib_copy_from_udata(&ucmd, udata,
 					 min(udata->inlen, sizeof(ucmd)));
 		if (ret) {
-			ibdev_err(ibdev, "Failed to copy SRQ udata, err %d\n",
+			ibdev_err(ibdev, "failed to copy SRQ udata, ret = %d.\n",
 				  ret);
 			return ret;
 		}
@@ -311,20 +316,21 @@ int hns_roce_create_srq(struct ib_srq *ib_srq,
 
 	ret = alloc_srq_buf(hr_dev, srq, udata, ucmd.buf_addr);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to alloc SRQ buffer, err %d\n", ret);
+		ibdev_err(ibdev,
+			  "failed to alloc SRQ buffer, ret = %d.\n", ret);
 		return ret;
 	}
 
 	ret = alloc_srq_idx(hr_dev, srq, udata, ucmd.que_addr);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to alloc SRQ idx, err %d\n", ret);
+		ibdev_err(ibdev, "failed to alloc SRQ idx, ret = %d.\n", ret);
 		goto err_buf_alloc;
 	}
 
 	if (!udata) {
 		ret = alloc_srq_wrid(hr_dev, srq);
 		if (ret) {
-			ibdev_err(ibdev, "Failed to alloc SRQ wrid, err %d\n",
+			ibdev_err(ibdev, "failed to alloc SRQ wrid, ret = %d.\n",
 				  ret);
 			goto err_idx_alloc;
 		}
@@ -336,7 +342,8 @@ int hns_roce_create_srq(struct ib_srq *ib_srq,
 
 	ret = alloc_srqc(hr_dev, srq, to_hr_pd(ib_srq->pd)->pdn, cqn, 0, 0);
 	if (ret) {
-		ibdev_err(ibdev, "Failed to alloc SRQ context, err %d\n", ret);
+		ibdev_err(ibdev,
+			  "failed to alloc SRQ context, ret = %d.\n", ret);
 		goto err_wrid_alloc;
 	}
 
-- 
2.33.0



