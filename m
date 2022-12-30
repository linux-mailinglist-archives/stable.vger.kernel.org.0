Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302D0658077
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:18:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbiL1QSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234762AbiL1QR0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:17:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576746456
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:16:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C2BD2B81730
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:15:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EA69C433D2;
        Wed, 28 Dec 2022 16:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244157;
        bh=JaoJJGF24PMZY/ohTlohxwoQYB2dc1xystDYug12ojY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H4ixAzYUt3wG5YJ64glPsuqCmQLlqvYtxZIQ9jTiwfhLIVujhAUeVwR2+GxUPUTGQ
         LGHpeJQ0ZmGYtSSJ2OjopFzf0UX3LfODHxsCcMUQipfQppryU/1+nTCA/ZYGJN99Cx
         2833MddoScldwcGVhhFSOi7gcBPR353OXVwkylO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yixing Liu <liuyixing1@huawei.com>,
        Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0647/1073] RDMA/hns: Fix the gid problem caused by free mr
Date:   Wed, 28 Dec 2022 15:37:15 +0100
Message-Id: <20221228144345.617341067@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Yixing Liu <liuyixing1@huawei.com>

[ Upstream commit 487d65090a3dce1ae54946aded55d0f8ac87cbab ]

After the hns roce driver is loaded, if you modify the mac address of the
network port, the following error will appear:

   __ib_cache_gid_add: unable to add gid fe80:0000:0000:0000:4600:4dff:fe22:abb5 error=-28
    hns3 0000:7d:00.0 hns_0: attr path_mtu(1) invalid while modify qp

The reason for the error is that the gid being occupied will cause the
failure to modify the gid. The gid is occupied by the loopback QP used by
free mr. When the mac address is modified, the gid will change. If there
is a busy QP at this time, the gid will not be released and the
modification will fail. The QP of free mr is created using the ib
interface. The ib interface will add a reference count to the gid,
resulting in this error scenario.

Considering that free mr is solving a bug in HIP08, not an actual
business, it is not necessary to use ib interfaces.

Fixes: 70f92521584f ("RDMA/hns: Use the reserved loopback QPs to free MR before destroying MPT")
Link: https://lore.kernel.org/r/20221126102911.2921820-2-xuhaoyue1@hisilicon.com
Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 175 ++++++++++++++++-----
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |   8 +-
 2 files changed, 137 insertions(+), 46 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index eb14df9fe70c..d242fa192f0d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -2633,31 +2633,124 @@ static void free_dip_list(struct hns_roce_dev *hr_dev)
 	spin_unlock_irqrestore(&hr_dev->dip_list_lock, flags);
 }
 
-static void free_mr_exit(struct hns_roce_dev *hr_dev)
+static struct ib_pd *free_mr_init_pd(struct hns_roce_dev *hr_dev)
+{
+	struct hns_roce_v2_priv *priv = hr_dev->priv;
+	struct hns_roce_v2_free_mr *free_mr = &priv->free_mr;
+	struct ib_device *ibdev = &hr_dev->ib_dev;
+	struct hns_roce_pd *hr_pd;
+	struct ib_pd *pd;
+
+	hr_pd = kzalloc(sizeof(*hr_pd), GFP_KERNEL);
+	if (ZERO_OR_NULL_PTR(hr_pd))
+		return NULL;
+	pd = &hr_pd->ibpd;
+	pd->device = ibdev;
+
+	if (hns_roce_alloc_pd(pd, NULL)) {
+		ibdev_err(ibdev, "failed to create pd for free mr.\n");
+		kfree(hr_pd);
+		return NULL;
+	}
+	free_mr->rsv_pd = to_hr_pd(pd);
+	free_mr->rsv_pd->ibpd.device = &hr_dev->ib_dev;
+	free_mr->rsv_pd->ibpd.uobject = NULL;
+	free_mr->rsv_pd->ibpd.__internal_mr = NULL;
+	atomic_set(&free_mr->rsv_pd->ibpd.usecnt, 0);
+
+	return pd;
+}
+
+static struct ib_cq *free_mr_init_cq(struct hns_roce_dev *hr_dev)
+{
+	struct hns_roce_v2_priv *priv = hr_dev->priv;
+	struct hns_roce_v2_free_mr *free_mr = &priv->free_mr;
+	struct ib_device *ibdev = &hr_dev->ib_dev;
+	struct ib_cq_init_attr cq_init_attr = {};
+	struct hns_roce_cq *hr_cq;
+	struct ib_cq *cq;
+
+	cq_init_attr.cqe = HNS_ROCE_FREE_MR_USED_CQE_NUM;
+
+	hr_cq = kzalloc(sizeof(*hr_cq), GFP_KERNEL);
+	if (ZERO_OR_NULL_PTR(hr_cq))
+		return NULL;
+
+	cq = &hr_cq->ib_cq;
+	cq->device = ibdev;
+
+	if (hns_roce_create_cq(cq, &cq_init_attr, NULL)) {
+		ibdev_err(ibdev, "failed to create cq for free mr.\n");
+		kfree(hr_cq);
+		return NULL;
+	}
+	free_mr->rsv_cq = to_hr_cq(cq);
+	free_mr->rsv_cq->ib_cq.device = &hr_dev->ib_dev;
+	free_mr->rsv_cq->ib_cq.uobject = NULL;
+	free_mr->rsv_cq->ib_cq.comp_handler = NULL;
+	free_mr->rsv_cq->ib_cq.event_handler = NULL;
+	free_mr->rsv_cq->ib_cq.cq_context = NULL;
+	atomic_set(&free_mr->rsv_cq->ib_cq.usecnt, 0);
+
+	return cq;
+}
+
+static int free_mr_init_qp(struct hns_roce_dev *hr_dev, struct ib_cq *cq,
+			   struct ib_qp_init_attr *init_attr, int i)
 {
 	struct hns_roce_v2_priv *priv = hr_dev->priv;
 	struct hns_roce_v2_free_mr *free_mr = &priv->free_mr;
+	struct ib_device *ibdev = &hr_dev->ib_dev;
+	struct hns_roce_qp *hr_qp;
+	struct ib_qp *qp;
 	int ret;
+
+	hr_qp = kzalloc(sizeof(*hr_qp), GFP_KERNEL);
+	if (ZERO_OR_NULL_PTR(hr_qp))
+		return -ENOMEM;
+
+	qp = &hr_qp->ibqp;
+	qp->device = ibdev;
+
+	ret = hns_roce_create_qp(qp, init_attr, NULL);
+	if (ret) {
+		ibdev_err(ibdev, "failed to create qp for free mr.\n");
+		kfree(hr_qp);
+		return ret;
+	}
+
+	free_mr->rsv_qp[i] = hr_qp;
+	free_mr->rsv_qp[i]->ibqp.recv_cq = cq;
+	free_mr->rsv_qp[i]->ibqp.send_cq = cq;
+
+	return 0;
+}
+
+static void free_mr_exit(struct hns_roce_dev *hr_dev)
+{
+	struct hns_roce_v2_priv *priv = hr_dev->priv;
+	struct hns_roce_v2_free_mr *free_mr = &priv->free_mr;
+	struct ib_qp *qp;
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(free_mr->rsv_qp); i++) {
 		if (free_mr->rsv_qp[i]) {
-			ret = ib_destroy_qp(free_mr->rsv_qp[i]);
-			if (ret)
-				ibdev_err(&hr_dev->ib_dev,
-					  "failed to destroy qp in free mr.\n");
-
+			qp = &free_mr->rsv_qp[i]->ibqp;
+			hns_roce_v2_destroy_qp(qp, NULL);
+			kfree(free_mr->rsv_qp[i]);
 			free_mr->rsv_qp[i] = NULL;
 		}
 	}
 
 	if (free_mr->rsv_cq) {
-		ib_destroy_cq(free_mr->rsv_cq);
+		hns_roce_destroy_cq(&free_mr->rsv_cq->ib_cq, NULL);
+		kfree(free_mr->rsv_cq);
 		free_mr->rsv_cq = NULL;
 	}
 
 	if (free_mr->rsv_pd) {
-		ib_dealloc_pd(free_mr->rsv_pd);
+		hns_roce_dealloc_pd(&free_mr->rsv_pd->ibpd, NULL);
+		kfree(free_mr->rsv_pd);
 		free_mr->rsv_pd = NULL;
 	}
 }
@@ -2666,55 +2759,46 @@ static int free_mr_alloc_res(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_v2_priv *priv = hr_dev->priv;
 	struct hns_roce_v2_free_mr *free_mr = &priv->free_mr;
-	struct ib_device *ibdev = &hr_dev->ib_dev;
-	struct ib_cq_init_attr cq_init_attr = {};
 	struct ib_qp_init_attr qp_init_attr = {};
 	struct ib_pd *pd;
 	struct ib_cq *cq;
-	struct ib_qp *qp;
 	int ret;
 	int i;
 
-	pd = ib_alloc_pd(ibdev, 0);
-	if (IS_ERR(pd)) {
-		ibdev_err(ibdev, "failed to create pd for free mr.\n");
-		return PTR_ERR(pd);
-	}
-	free_mr->rsv_pd = pd;
+	pd = free_mr_init_pd(hr_dev);
+	if (!pd)
+		return -ENOMEM;
 
-	cq_init_attr.cqe = HNS_ROCE_FREE_MR_USED_CQE_NUM;
-	cq = ib_create_cq(ibdev, NULL, NULL, NULL, &cq_init_attr);
-	if (IS_ERR(cq)) {
-		ibdev_err(ibdev, "failed to create cq for free mr.\n");
-		ret = PTR_ERR(cq);
-		goto create_failed;
+	cq = free_mr_init_cq(hr_dev);
+	if (!cq) {
+		ret = -ENOMEM;
+		goto create_failed_cq;
 	}
-	free_mr->rsv_cq = cq;
 
 	qp_init_attr.qp_type = IB_QPT_RC;
 	qp_init_attr.sq_sig_type = IB_SIGNAL_ALL_WR;
-	qp_init_attr.send_cq = free_mr->rsv_cq;
-	qp_init_attr.recv_cq = free_mr->rsv_cq;
+	qp_init_attr.send_cq = cq;
+	qp_init_attr.recv_cq = cq;
 	for (i = 0; i < ARRAY_SIZE(free_mr->rsv_qp); i++) {
 		qp_init_attr.cap.max_send_wr = HNS_ROCE_FREE_MR_USED_SQWQE_NUM;
 		qp_init_attr.cap.max_send_sge = HNS_ROCE_FREE_MR_USED_SQSGE_NUM;
 		qp_init_attr.cap.max_recv_wr = HNS_ROCE_FREE_MR_USED_RQWQE_NUM;
 		qp_init_attr.cap.max_recv_sge = HNS_ROCE_FREE_MR_USED_RQSGE_NUM;
 
-		qp = ib_create_qp(free_mr->rsv_pd, &qp_init_attr);
-		if (IS_ERR(qp)) {
-			ibdev_err(ibdev, "failed to create qp for free mr.\n");
-			ret = PTR_ERR(qp);
-			goto create_failed;
-		}
-
-		free_mr->rsv_qp[i] = qp;
+		ret = free_mr_init_qp(hr_dev, cq, &qp_init_attr, i);
+		if (ret)
+			goto create_failed_qp;
 	}
 
 	return 0;
 
-create_failed:
-	free_mr_exit(hr_dev);
+create_failed_qp:
+	hns_roce_destroy_cq(cq, NULL);
+	kfree(cq);
+
+create_failed_cq:
+	hns_roce_dealloc_pd(pd, NULL);
+	kfree(pd);
 
 	return ret;
 }
@@ -2730,14 +2814,17 @@ static int free_mr_modify_rsv_qp(struct hns_roce_dev *hr_dev,
 	int mask;
 	int ret;
 
-	hr_qp = to_hr_qp(free_mr->rsv_qp[sl_num]);
+	hr_qp = to_hr_qp(&free_mr->rsv_qp[sl_num]->ibqp);
 	hr_qp->free_mr_en = 1;
+	hr_qp->ibqp.device = ibdev;
+	hr_qp->ibqp.qp_type = IB_QPT_RC;
 
 	mask = IB_QP_STATE | IB_QP_PKEY_INDEX | IB_QP_PORT | IB_QP_ACCESS_FLAGS;
 	attr->qp_state = IB_QPS_INIT;
 	attr->port_num = 1;
 	attr->qp_access_flags = IB_ACCESS_REMOTE_WRITE;
-	ret = ib_modify_qp(&hr_qp->ibqp, attr, mask);
+	ret = hr_dev->hw->modify_qp(&hr_qp->ibqp, attr, mask, IB_QPS_INIT,
+				    IB_QPS_INIT);
 	if (ret) {
 		ibdev_err(ibdev, "failed to modify qp to init, ret = %d.\n",
 			  ret);
@@ -2758,7 +2845,8 @@ static int free_mr_modify_rsv_qp(struct hns_roce_dev *hr_dev,
 
 	rdma_ah_set_sl(&attr->ah_attr, (u8)sl_num);
 
-	ret = ib_modify_qp(&hr_qp->ibqp, attr, mask);
+	ret = hr_dev->hw->modify_qp(&hr_qp->ibqp, attr, mask, IB_QPS_INIT,
+				    IB_QPS_RTR);
 	hr_dev->loop_idc = loopback;
 	if (ret) {
 		ibdev_err(ibdev, "failed to modify qp to rtr, ret = %d.\n",
@@ -2772,7 +2860,8 @@ static int free_mr_modify_rsv_qp(struct hns_roce_dev *hr_dev,
 	attr->sq_psn = HNS_ROCE_FREE_MR_USED_PSN;
 	attr->retry_cnt = HNS_ROCE_FREE_MR_USED_QP_RETRY_CNT;
 	attr->timeout = HNS_ROCE_FREE_MR_USED_QP_TIMEOUT;
-	ret = ib_modify_qp(&hr_qp->ibqp, attr, mask);
+	ret = hr_dev->hw->modify_qp(&hr_qp->ibqp, attr, mask, IB_QPS_RTR,
+				    IB_QPS_RTS);
 	if (ret)
 		ibdev_err(ibdev, "failed to modify qp to rts, ret = %d.\n",
 			  ret);
@@ -3416,7 +3505,7 @@ static void free_mr_send_cmd_to_hw(struct hns_roce_dev *hr_dev)
 	mutex_lock(&free_mr->mutex);
 
 	for (i = 0; i < ARRAY_SIZE(free_mr->rsv_qp); i++) {
-		hr_qp = to_hr_qp(free_mr->rsv_qp[i]);
+		hr_qp = free_mr->rsv_qp[i];
 
 		ret = free_mr_post_send_lp_wqe(hr_qp);
 		if (ret) {
@@ -3431,7 +3520,7 @@ static void free_mr_send_cmd_to_hw(struct hns_roce_dev *hr_dev)
 
 	end = msecs_to_jiffies(HNS_ROCE_V2_FREE_MR_TIMEOUT) + jiffies;
 	while (cqe_cnt) {
-		npolled = hns_roce_v2_poll_cq(free_mr->rsv_cq, cqe_cnt, wc);
+		npolled = hns_roce_v2_poll_cq(&free_mr->rsv_cq->ib_cq, cqe_cnt, wc);
 		if (npolled < 0) {
 			ibdev_err(ibdev,
 				  "failed to poll cqe for free mr, remain %d cqe.\n",
@@ -5474,7 +5563,7 @@ static int hns_roce_v2_destroy_qp_common(struct hns_roce_dev *hr_dev,
 	return ret;
 }
 
-static int hns_roce_v2_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
+int hns_roce_v2_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(ibqp->device);
 	struct hns_roce_qp *hr_qp = to_hr_qp(ibqp);
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 12d54bf6d954..5abea0416f5b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -1328,9 +1328,9 @@ struct hns_roce_link_table {
 #define HNS_ROCE_EXT_LLM_MIN_PAGES(que_num) ((que_num) * 4 + 2)
 
 struct hns_roce_v2_free_mr {
-	struct ib_qp *rsv_qp[HNS_ROCE_FREE_MR_USED_QP_NUM];
-	struct ib_cq *rsv_cq;
-	struct ib_pd *rsv_pd;
+	struct hns_roce_qp *rsv_qp[HNS_ROCE_FREE_MR_USED_QP_NUM];
+	struct hns_roce_cq *rsv_cq;
+	struct hns_roce_pd *rsv_pd;
 	struct mutex mutex;
 };
 
@@ -1460,6 +1460,8 @@ struct hns_roce_sccc_clr_done {
 	__le32 rsv[5];
 };
 
+int hns_roce_v2_destroy_qp(struct ib_qp *ibqp, struct ib_udata *udata);
+
 static inline void hns_roce_write64(struct hns_roce_dev *hr_dev, __le32 val[2],
 				    void __iomem *dest)
 {
-- 
2.35.1



