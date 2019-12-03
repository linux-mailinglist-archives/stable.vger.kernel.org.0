Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 706C4111E38
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbfLCW4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:56:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:52170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730485AbfLCW4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:56:54 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C6CA2053B;
        Tue,  3 Dec 2019 22:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413813;
        bh=xxMKIAd52l3UGtr7HquE81FIuNbhoyeAEWFdLVXeFg4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TaLQFRVSqvIAFIEYDpMKROIvMR778ERpTgQpNN9svHx9KuxuhSIKHHfTKn4rpDtxU
         DvUW69Ramw8M9phGNs27F+aPwRfgeYaKl/ySdmDTU565y1VwrT8Dnurhw8xmwONX/d
         jgfURpEwu4nQOjYvKwArSqvZQ4+2FKWIxk2BFXew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Ou <oulijun@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 255/321] RDMA/hns: Fix the bug with updating rq head pointer when flush cqe
Date:   Tue,  3 Dec 2019 23:35:21 +0100
Message-Id: <20191203223440.401241073@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 9c6ccc035c209dda07685e8dba829a203ba17499 ]

When flush cqe with srq, the driver disable to update the rq head pointer
into the hardware.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 9e7923cf85773..1eda8a22a4252 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3503,13 +3503,16 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
 		roce_set_field(qpc_mask->byte_160_sq_ci_pi,
 			       V2_QPC_BYTE_160_SQ_PRODUCER_IDX_M,
 			       V2_QPC_BYTE_160_SQ_PRODUCER_IDX_S, 0);
-		roce_set_field(context->byte_84_rq_ci_pi,
+
+		if (!ibqp->srq) {
+			roce_set_field(context->byte_84_rq_ci_pi,
 			       V2_QPC_BYTE_84_RQ_PRODUCER_IDX_M,
 			       V2_QPC_BYTE_84_RQ_PRODUCER_IDX_S,
 			       hr_qp->rq.head);
-		roce_set_field(qpc_mask->byte_84_rq_ci_pi,
+			roce_set_field(qpc_mask->byte_84_rq_ci_pi,
 			       V2_QPC_BYTE_84_RQ_PRODUCER_IDX_M,
 			       V2_QPC_BYTE_84_RQ_PRODUCER_IDX_S, 0);
+		}
 	}
 
 	if (attr_mask & IB_QP_AV) {
@@ -3971,7 +3974,8 @@ static void hns_roce_set_qps_to_err(struct hns_roce_dev *hr_dev, u32 qpn)
 	if (hr_qp->ibqp.uobject) {
 		if (hr_qp->sdb_en == 1) {
 			hr_qp->sq.head = *(int *)(hr_qp->sdb.virt_addr);
-			hr_qp->rq.head = *(int *)(hr_qp->rdb.virt_addr);
+			if (hr_qp->rdb_en == 1)
+				hr_qp->rq.head = *(int *)(hr_qp->rdb.virt_addr);
 		} else {
 			dev_warn(hr_dev->dev, "flush cqe is unsupported in userspace!\n");
 			return;
-- 
2.20.1



