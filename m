Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B64C65808A
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233189AbiL1QSM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234767AbiL1QR1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:17:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBC94B65
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:16:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CF91B81886
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05FEC433EF;
        Wed, 28 Dec 2022 16:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244160;
        bh=/MrfJTHi7Bi4/kuGzTXSvEvQ7rFlXqWPJay6k6l/MpU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NeLXlwcb9SWsa+GgyI4Ttcy2Cqy9TeenEk0oVQzy+Izx6U4XF+DD+xQr0vIX82KAX
         KxJBAaObR1eBAACyQM8ykbTM/Us29H0cNGzAypyBWbDtB2MkUwgpzJ0u/3IvB7F1OI
         yeWPksH7KIKdKubrFYVw3IalZ6hvmCm8c6h7HVlY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Luoyouming <luoyouming@huawei.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0621/1146] RDMA/hns: Fix incorrect sge nums calculation
Date:   Wed, 28 Dec 2022 15:36:00 +0100
Message-Id: <20221228144347.037244729@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luoyouming <luoyouming@huawei.com>

[ Upstream commit 0c5e259b06a8efc69f929ad777ea49281bb58e37 ]

The user usually configures the number of sge through the max_send_sge
parameter when creating qp, and configures the maximum size of inline data
that can be sent through max_inline_data. Inline uses sge to fill data to
send. Expect the following:

1) When the sge space cannot hold inline data, the sge space needs to be
   expanded to accommodate all inline data

2) When the sge space is enough to accommodate inline data, the upper
   limit of inline data can be increased so that users can send larger
   inline data

Currently case one is not implemented. When the inline data is larger than
the sge space, an error of insufficient sge space occurs.  This part of
the code needs to be reimplemented according to the expected rules. The
calculation method of sge num is modified to take the maximum value of
max_send_sge and the sge for max_inline_data to solve this problem.

Fixes: 05201e01be93 ("RDMA/hns: Refactor process of setting extended sge")
Fixes: 30b707886aeb ("RDMA/hns: Support inline data in extented sge space for RC")
Link: https://lore.kernel.org/r/20221108133847.2304539-3-xuhaoyue1@hisilicon.com
Signed-off-by: Luoyouming <luoyouming@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |   3 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  12 +--
 drivers/infiniband/hw/hns/hns_roce_main.c   |  18 +++-
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 107 ++++++++++++++++----
 include/uapi/rdma/hns-abi.h                 |  15 +++
 5 files changed, 125 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 723e55a7de8d..f701cc86896b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -202,6 +202,7 @@ struct hns_roce_ucontext {
 	struct list_head	page_list;
 	struct mutex		page_mutex;
 	struct hns_user_mmap_entry *db_mmap_entry;
+	u32			config;
 };
 
 struct hns_roce_pd {
@@ -334,6 +335,7 @@ struct hns_roce_wq {
 	u32		head;
 	u32		tail;
 	void __iomem	*db_reg;
+	u32		ext_sge_cnt;
 };
 
 struct hns_roce_sge {
@@ -635,6 +637,7 @@ struct hns_roce_qp {
 	struct list_head	rq_node; /* all recv qps are on a list */
 	struct list_head	sq_node; /* all send qps are on a list */
 	struct hns_user_mmap_entry *dwqe_mmap_entry;
+	u32			config;
 };
 
 struct hns_roce_ib_iboe {
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 0937db738be7..65875b4cff13 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -187,14 +187,6 @@ static void set_atomic_seg(const struct ib_send_wr *wr,
 	hr_reg_write(rc_sq_wqe, RC_SEND_WQE_SGE_NUM, valid_num_sge);
 }
 
-static unsigned int get_std_sge_num(struct hns_roce_qp *qp)
-{
-	if (qp->ibqp.qp_type == IB_QPT_GSI || qp->ibqp.qp_type == IB_QPT_UD)
-		return 0;
-
-	return HNS_ROCE_SGE_IN_WQE;
-}
-
 static int fill_ext_sge_inl_data(struct hns_roce_qp *qp,
 				 const struct ib_send_wr *wr,
 				 unsigned int *sge_idx, u32 msg_len)
@@ -202,14 +194,12 @@ static int fill_ext_sge_inl_data(struct hns_roce_qp *qp,
 	struct ib_device *ibdev = &(to_hr_dev(qp->ibqp.device))->ib_dev;
 	unsigned int left_len_in_pg;
 	unsigned int idx = *sge_idx;
-	unsigned int std_sge_num;
 	unsigned int i = 0;
 	unsigned int len;
 	void *addr;
 	void *dseg;
 
-	std_sge_num = get_std_sge_num(qp);
-	if (msg_len > (qp->sq.max_gs - std_sge_num) * HNS_ROCE_SGE_SIZE) {
+	if (msg_len > qp->sq.ext_sge_cnt * HNS_ROCE_SGE_SIZE) {
 		ibdev_err(ibdev,
 			  "no enough extended sge space for inline data.\n");
 		return -EINVAL;
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index dcf89689a4c6..8ba68ac12388 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -354,10 +354,11 @@ static int hns_roce_alloc_uar_entry(struct ib_ucontext *uctx)
 static int hns_roce_alloc_ucontext(struct ib_ucontext *uctx,
 				   struct ib_udata *udata)
 {
-	int ret;
 	struct hns_roce_ucontext *context = to_hr_ucontext(uctx);
-	struct hns_roce_ib_alloc_ucontext_resp resp = {};
 	struct hns_roce_dev *hr_dev = to_hr_dev(uctx->device);
+	struct hns_roce_ib_alloc_ucontext_resp resp = {};
+	struct hns_roce_ib_alloc_ucontext ucmd = {};
+	int ret;
 
 	if (!hr_dev->active)
 		return -EAGAIN;
@@ -365,6 +366,19 @@ static int hns_roce_alloc_ucontext(struct ib_ucontext *uctx,
 	resp.qp_tab_size = hr_dev->caps.num_qps;
 	resp.srq_tab_size = hr_dev->caps.num_srqs;
 
+	ret = ib_copy_from_udata(&ucmd, udata,
+				 min(udata->inlen, sizeof(ucmd)));
+	if (ret)
+		return ret;
+
+	if (hr_dev->pci_dev->revision >= PCI_REVISION_ID_HIP09)
+		context->config = ucmd.config & HNS_ROCE_EXSGE_FLAGS;
+
+	if (context->config & HNS_ROCE_EXSGE_FLAGS) {
+		resp.config |= HNS_ROCE_RSP_EXSGE_FLAGS;
+		resp.max_inline_data = hr_dev->caps.max_sq_inline;
+	}
+
 	ret = hns_roce_uar_alloc(hr_dev, &context->uar);
 	if (ret)
 		goto error_fail_uar_alloc;
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index f0bd82a18069..0ae335fb205c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -476,38 +476,109 @@ static int set_rq_size(struct hns_roce_dev *hr_dev, struct ib_qp_cap *cap,
 	return 0;
 }
 
-static u32 get_wqe_ext_sge_cnt(struct hns_roce_qp *qp)
+static u32 get_max_inline_data(struct hns_roce_dev *hr_dev,
+			       struct ib_qp_cap *cap)
 {
-	/* GSI/UD QP only has extended sge */
-	if (qp->ibqp.qp_type == IB_QPT_GSI || qp->ibqp.qp_type == IB_QPT_UD)
-		return qp->sq.max_gs;
-
-	if (qp->sq.max_gs > HNS_ROCE_SGE_IN_WQE)
-		return qp->sq.max_gs - HNS_ROCE_SGE_IN_WQE;
+	if (cap->max_inline_data) {
+		cap->max_inline_data = roundup_pow_of_two(cap->max_inline_data);
+		return min(cap->max_inline_data,
+			   hr_dev->caps.max_sq_inline);
+	}
 
 	return 0;
 }
 
+static void update_inline_data(struct hns_roce_qp *hr_qp,
+			       struct ib_qp_cap *cap)
+{
+	u32 sge_num = hr_qp->sq.ext_sge_cnt;
+
+	if (hr_qp->config & HNS_ROCE_EXSGE_FLAGS) {
+		if (!(hr_qp->ibqp.qp_type == IB_QPT_GSI ||
+		      hr_qp->ibqp.qp_type == IB_QPT_UD))
+			sge_num = max((u32)HNS_ROCE_SGE_IN_WQE, sge_num);
+
+		cap->max_inline_data = max(cap->max_inline_data,
+					   sge_num * HNS_ROCE_SGE_SIZE);
+	}
+
+	hr_qp->max_inline_data = cap->max_inline_data;
+}
+
+static u32 get_sge_num_from_max_send_sge(bool is_ud_or_gsi,
+					 u32 max_send_sge)
+{
+	unsigned int std_sge_num;
+	unsigned int min_sge;
+
+	std_sge_num = is_ud_or_gsi ? 0 : HNS_ROCE_SGE_IN_WQE;
+	min_sge = is_ud_or_gsi ? 1 : 0;
+	return max_send_sge > std_sge_num ? (max_send_sge - std_sge_num) :
+				min_sge;
+}
+
+static unsigned int get_sge_num_from_max_inl_data(bool is_ud_or_gsi,
+						  u32 max_inline_data)
+{
+	unsigned int inline_sge;
+
+	inline_sge = roundup_pow_of_two(max_inline_data) / HNS_ROCE_SGE_SIZE;
+
+	/*
+	 * if max_inline_data less than
+	 * HNS_ROCE_SGE_IN_WQE * HNS_ROCE_SGE_SIZE,
+	 * In addition to ud's mode, no need to extend sge.
+	 */
+	if (!is_ud_or_gsi && inline_sge <= HNS_ROCE_SGE_IN_WQE)
+		inline_sge = 0;
+
+	return inline_sge;
+}
+
 static void set_ext_sge_param(struct hns_roce_dev *hr_dev, u32 sq_wqe_cnt,
 			      struct hns_roce_qp *hr_qp, struct ib_qp_cap *cap)
 {
+	bool is_ud_or_gsi = (hr_qp->ibqp.qp_type == IB_QPT_GSI ||
+				hr_qp->ibqp.qp_type == IB_QPT_UD);
+	unsigned int std_sge_num;
+	u32 inline_ext_sge = 0;
+	u32 ext_wqe_sge_cnt;
 	u32 total_sge_cnt;
-	u32 wqe_sge_cnt;
+
+	cap->max_inline_data = get_max_inline_data(hr_dev, cap);
 
 	hr_qp->sge.sge_shift = HNS_ROCE_SGE_SHIFT;
+	std_sge_num = is_ud_or_gsi ? 0 : HNS_ROCE_SGE_IN_WQE;
+	ext_wqe_sge_cnt = get_sge_num_from_max_send_sge(is_ud_or_gsi,
+							cap->max_send_sge);
 
-	hr_qp->sq.max_gs = max(1U, cap->max_send_sge);
+	if (hr_qp->config & HNS_ROCE_EXSGE_FLAGS) {
+		inline_ext_sge = max(ext_wqe_sge_cnt,
+				     get_sge_num_from_max_inl_data(is_ud_or_gsi,
+							 cap->max_inline_data));
+		hr_qp->sq.ext_sge_cnt = inline_ext_sge ?
+					roundup_pow_of_two(inline_ext_sge) : 0;
 
-	wqe_sge_cnt = get_wqe_ext_sge_cnt(hr_qp);
+		hr_qp->sq.max_gs = max(1U, (hr_qp->sq.ext_sge_cnt + std_sge_num));
+		hr_qp->sq.max_gs = min(hr_qp->sq.max_gs, hr_dev->caps.max_sq_sg);
+
+		ext_wqe_sge_cnt = hr_qp->sq.ext_sge_cnt;
+	} else {
+		hr_qp->sq.max_gs = max(1U, cap->max_send_sge);
+		hr_qp->sq.max_gs = min(hr_qp->sq.max_gs, hr_dev->caps.max_sq_sg);
+		hr_qp->sq.ext_sge_cnt = hr_qp->sq.max_gs;
+	}
 
 	/* If the number of extended sge is not zero, they MUST use the
 	 * space of HNS_HW_PAGE_SIZE at least.
 	 */
-	if (wqe_sge_cnt) {
-		total_sge_cnt = roundup_pow_of_two(sq_wqe_cnt * wqe_sge_cnt);
+	if (ext_wqe_sge_cnt) {
+		total_sge_cnt = roundup_pow_of_two(sq_wqe_cnt * ext_wqe_sge_cnt);
 		hr_qp->sge.sge_cnt = max(total_sge_cnt,
 				(u32)HNS_HW_PAGE_SIZE / HNS_ROCE_SGE_SIZE);
 	}
+
+	update_inline_data(hr_qp, cap);
 }
 
 static int check_sq_size_with_integrity(struct hns_roce_dev *hr_dev,
@@ -556,6 +627,7 @@ static int set_user_sq_size(struct hns_roce_dev *hr_dev,
 
 	hr_qp->sq.wqe_shift = ucmd->log_sq_stride;
 	hr_qp->sq.wqe_cnt = cnt;
+	cap->max_send_sge = hr_qp->sq.max_gs;
 
 	return 0;
 }
@@ -986,13 +1058,9 @@ static int set_qp_param(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 			struct hns_roce_ib_create_qp *ucmd)
 {
 	struct ib_device *ibdev = &hr_dev->ib_dev;
+	struct hns_roce_ucontext *uctx;
 	int ret;
 
-	if (init_attr->cap.max_inline_data > hr_dev->caps.max_sq_inline)
-		init_attr->cap.max_inline_data = hr_dev->caps.max_sq_inline;
-
-	hr_qp->max_inline_data = init_attr->cap.max_inline_data;
-
 	if (init_attr->sq_sig_type == IB_SIGNAL_ALL_WR)
 		hr_qp->sq_signal_bits = IB_SIGNAL_ALL_WR;
 	else
@@ -1015,12 +1083,17 @@ static int set_qp_param(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 			return ret;
 		}
 
+		uctx = rdma_udata_to_drv_context(udata, struct hns_roce_ucontext,
+						 ibucontext);
+		hr_qp->config = uctx->config;
 		ret = set_user_sq_size(hr_dev, &init_attr->cap, hr_qp, ucmd);
 		if (ret)
 			ibdev_err(ibdev,
 				  "failed to set user SQ size, ret = %d.\n",
 				  ret);
 	} else {
+		if (hr_dev->pci_dev->revision >= PCI_REVISION_ID_HIP09)
+			hr_qp->config = HNS_ROCE_EXSGE_FLAGS;
 		ret = set_kernel_sq_size(hr_dev, &init_attr->cap, hr_qp);
 		if (ret)
 			ibdev_err(ibdev,
diff --git a/include/uapi/rdma/hns-abi.h b/include/uapi/rdma/hns-abi.h
index f6fde06db4b4..745790ce3c26 100644
--- a/include/uapi/rdma/hns-abi.h
+++ b/include/uapi/rdma/hns-abi.h
@@ -85,11 +85,26 @@ struct hns_roce_ib_create_qp_resp {
 	__aligned_u64 dwqe_mmap_key;
 };
 
+enum {
+	HNS_ROCE_EXSGE_FLAGS = 1 << 0,
+};
+
+enum {
+	HNS_ROCE_RSP_EXSGE_FLAGS = 1 << 0,
+};
+
 struct hns_roce_ib_alloc_ucontext_resp {
 	__u32	qp_tab_size;
 	__u32	cqe_size;
 	__u32	srq_tab_size;
 	__u32	reserved;
+	__u32	config;
+	__u32	max_inline_data;
+};
+
+struct hns_roce_ib_alloc_ucontext {
+	__u32 config;
+	__u32 reserved;
 };
 
 struct hns_roce_ib_alloc_pd_resp {
-- 
2.35.1



