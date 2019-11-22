Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4830106116
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 06:54:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfKVFyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:54:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59212 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728809AbfKVFxN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:53:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C76352072E;
        Fri, 22 Nov 2019 05:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401993;
        bh=pfDGKXJw3nG4tZ0fJyMwmMdPCGBmkSkiDYf0U28/+5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TEQKB8S+UPTX9SKUywy2aoKmBsgdPHIPDnK47g5Pn/UBjv1nqJfCsmpFdumwp2OTZ
         ugq3tPWvS0xp6b3bnnKbA9EzAMUk0anCIccCtyQMehd4gYckzASW1OTkO3BPoSzieI
         H47nARJX8Vd4F38xfFrXuuJ47UC6zNTRt9p+6mLA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijun Ou <oulijun@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 211/219] RDMA/hns: Fix the bug with updating rq head pointer when flush cqe
Date:   Fri, 22 Nov 2019 00:49:02 -0500
Message-Id: <20191122054911.1750-203-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index cf878e1b71fc1..587db5cf3be15 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3499,13 +3499,16 @@ static int hns_roce_v2_modify_qp(struct ib_qp *ibqp,
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
@@ -3967,7 +3970,8 @@ static void hns_roce_set_qps_to_err(struct hns_roce_dev *hr_dev, u32 qpn)
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

