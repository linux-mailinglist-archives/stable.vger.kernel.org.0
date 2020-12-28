Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526142E3DBF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441639AbgL1OT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:19:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:54796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441635AbgL1OT2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:19:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0C5B82245C;
        Mon, 28 Dec 2020 14:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165127;
        bh=473GlbrqqYrf5qztBNlQMElMWOAaR3QPNrjWoDOeHdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CWxps1Q54eeGBg0x8NEBI0xVNcinvWedNyxhNm2Q+UEgCqDwf+gkx5JemeGDPH6qu
         h2P9J6CjMG+WLP+2ecBC9D5MVdajItTRsteVlS1eaUlQfIpDkrYK1p98uVsJ2mRJ7G
         5sYKGA+IbwPG8BEXUO54idIUTkIB5Q69BYv0QYSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 422/717] RDMA/hns: Limit the length of data copied between kernel and userspace
Date:   Mon, 28 Dec 2020 13:47:00 +0100
Message-Id: <20201228125041.182667076@linuxfoundation.org>
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

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit 1c0ca9cd1741687f529498ddb899805fc2c51caa ]

For ib_copy_from_user(), the length of udata may not be the same as that
of cmd. For ib_copy_to_user(), the length of udata may not be the same as
that of resp. So limit the length to prevent out-of-bounds read and write
operations from ib_copy_from_user() and ib_copy_to_user().

Fixes: de77503a5940 ("RDMA/hns: RDMA/hns: Assign rq head pointer when enable rq record db")
Fixes: 633fb4d9fdaa ("RDMA/hns: Use structs to describe the uABI instead of opencoding")
Fixes: ae85bf92effc ("RDMA/hns: Optimize qp param setup flow")
Fixes: 6fd610c5733d ("RDMA/hns: Support 0 hop addressing for SRQ buffer")
Fixes: 9d9d4ff78884 ("RDMA/hns: Update the kernel header file of hns")
Link: https://lore.kernel.org/r/1607650657-35992-2-git-send-email-liweihang@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c   |  5 +++--
 drivers/infiniband/hw/hns/hns_roce_main.c |  3 ++-
 drivers/infiniband/hw/hns/hns_roce_pd.c   | 11 ++++++-----
 drivers/infiniband/hw/hns/hns_roce_qp.c   |  9 ++++++---
 drivers/infiniband/hw/hns/hns_roce_srq.c  | 10 +++++-----
 5 files changed, 22 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 809b22aa5056c..da346129f6e9e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -274,7 +274,7 @@ int hns_roce_create_cq(struct ib_cq *ib_cq, const struct ib_cq_init_attr *attr,
 
 	if (udata) {
 		ret = ib_copy_from_udata(&ucmd, udata,
-					 min(sizeof(ucmd), udata->inlen));
+					 min(udata->inlen, sizeof(ucmd)));
 		if (ret) {
 			ibdev_err(ibdev, "Failed to copy CQ udata, err %d\n",
 				  ret);
@@ -313,7 +313,8 @@ int hns_roce_create_cq(struct ib_cq *ib_cq, const struct ib_cq_init_attr *attr,
 
 	if (udata) {
 		resp.cqn = hr_cq->cqn;
-		ret = ib_copy_to_udata(udata, &resp, sizeof(resp));
+		ret = ib_copy_to_udata(udata, &resp,
+				       min(udata->outlen, sizeof(resp)));
 		if (ret)
 			goto err_cqc;
 	}
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index afeffafc59f90..a6277d1c36ba9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -325,7 +325,8 @@ static int hns_roce_alloc_ucontext(struct ib_ucontext *uctx,
 
 	resp.cqe_size = hr_dev->caps.cqe_sz;
 
-	ret = ib_copy_to_udata(udata, &resp, sizeof(resp));
+	ret = ib_copy_to_udata(udata, &resp,
+			       min(udata->outlen, sizeof(resp)));
 	if (ret)
 		goto error_fail_copy_to_udata;
 
diff --git a/drivers/infiniband/hw/hns/hns_roce_pd.c b/drivers/infiniband/hw/hns/hns_roce_pd.c
index 98f69496adb49..f78fa1d3d8075 100644
--- a/drivers/infiniband/hw/hns/hns_roce_pd.c
+++ b/drivers/infiniband/hw/hns/hns_roce_pd.c
@@ -70,16 +70,17 @@ int hns_roce_alloc_pd(struct ib_pd *ibpd, struct ib_udata *udata)
 	}
 
 	if (udata) {
-		struct hns_roce_ib_alloc_pd_resp uresp = {.pdn = pd->pdn};
+		struct hns_roce_ib_alloc_pd_resp resp = {.pdn = pd->pdn};
 
-		if (ib_copy_to_udata(udata, &uresp, sizeof(uresp))) {
+		ret = ib_copy_to_udata(udata, &resp,
+				       min(udata->outlen, sizeof(resp)));
+		if (ret) {
 			hns_roce_pd_free(to_hr_dev(ib_dev), pd->pdn);
-			ibdev_err(ib_dev, "failed to copy to udata\n");
-			return -EFAULT;
+			ibdev_err(ib_dev, "failed to copy to udata, ret = %d\n", ret);
 		}
 	}
 
-	return 0;
+	return ret;
 }
 
 int hns_roce_dealloc_pd(struct ib_pd *pd, struct ib_udata *udata)
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 71ea8fd9041b9..800141ab643a3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -865,9 +865,12 @@ static int set_qp_param(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 	}
 
 	if (udata) {
-		if (ib_copy_from_udata(ucmd, udata, sizeof(*ucmd))) {
-			ibdev_err(ibdev, "Failed to copy QP ucmd\n");
-			return -EFAULT;
+		ret = ib_copy_from_udata(ucmd, udata,
+					 min(udata->inlen, sizeof(*ucmd)));
+		if (ret) {
+			ibdev_err(ibdev,
+				  "failed to copy QP ucmd, ret = %d\n", ret);
+			return ret;
 		}
 
 		ret = set_user_sq_size(hr_dev, &init_attr->cap, hr_qp, ucmd);
diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 8caf74e44efd9..75d74f4bb52c9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -300,7 +300,8 @@ int hns_roce_create_srq(struct ib_srq *ib_srq,
 	srq->max_gs = init_attr->attr.max_sge;
 
 	if (udata) {
-		ret = ib_copy_from_udata(&ucmd, udata, sizeof(ucmd));
+		ret = ib_copy_from_udata(&ucmd, udata,
+					 min(udata->inlen, sizeof(ucmd)));
 		if (ret) {
 			ibdev_err(ibdev, "Failed to copy SRQ udata, err %d\n",
 				  ret);
@@ -343,11 +344,10 @@ int hns_roce_create_srq(struct ib_srq *ib_srq,
 	resp.srqn = srq->srqn;
 
 	if (udata) {
-		if (ib_copy_to_udata(udata, &resp,
-				     min(udata->outlen, sizeof(resp)))) {
-			ret = -EFAULT;
+		ret = ib_copy_to_udata(udata, &resp,
+				       min(udata->outlen, sizeof(resp)));
+		if (ret)
 			goto err_srqc_alloc;
-		}
 	}
 
 	return 0;
-- 
2.27.0



