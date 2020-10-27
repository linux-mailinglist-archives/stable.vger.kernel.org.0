Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8EE29BFD2
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1816425AbgJ0RGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:41498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1793548AbgJ0PG5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:06:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D24821707;
        Tue, 27 Oct 2020 15:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811215;
        bh=itabdAOHIjDy2Kc13rZObK+cjVVQL84T9NIove7k6t4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w0/Qj8oM7okWsNsVLYeF6de9mbAVWbIaigFKrY75Xf2Ukh0949n0hkuq9E7/8ImK4
         jeZ+U7dB30kqKfIaojn/a9AVkRB2nSZEU/vez/MRLP1DLY+1dZ43OSxl6gZuc2HOY1
         68wvufwYXJuW4OQGli+6fwpIlp3a58F8NArDs+2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiaran Zhang <zhangjiaran@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 383/633] RDMA/hns: Add check for the validity of sl configuration
Date:   Tue, 27 Oct 2020 14:52:06 +0100
Message-Id: <20201027135540.671652261@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiaran Zhang <zhangjiaran@huawei.com>

[ Upstream commit 172505cfa3a8ee98acaa569fd3be97697b333958 ]

According to the RoCE v1 specification, the sl (service level) 0-7 are
mapped directly to priorities 0-7 respectively, sl 8-15 are reserved. The
driver should verify whether the the value of sl is larger than 7, if so,
an exception should be returned.

Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Link: https://lore.kernel.org/r/1600509802-44382-5-git-send-email-liweihang@huawei.com
Signed-off-by: Jiaran Zhang <zhangjiaran@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 12 ++++++++++--
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h |  2 ++
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 38a48ab3e1d02..0f995aa23b9a9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4287,11 +4287,19 @@ static int hns_roce_v2_set_path(struct ib_qp *ibqp,
 		       V2_QPC_BYTE_28_FL_S, 0);
 	memcpy(context->dgid, grh->dgid.raw, sizeof(grh->dgid.raw));
 	memset(qpc_mask->dgid, 0, sizeof(grh->dgid.raw));
+
+	hr_qp->sl = rdma_ah_get_sl(&attr->ah_attr);
+	if (unlikely(hr_qp->sl > MAX_SERVICE_LEVEL)) {
+		ibdev_err(ibdev,
+			  "failed to fill QPC, sl (%d) shouldn't be larger than %d.\n",
+			  hr_qp->sl, MAX_SERVICE_LEVEL);
+		return -EINVAL;
+	}
+
 	roce_set_field(context->byte_28_at_fl, V2_QPC_BYTE_28_SL_M,
-		       V2_QPC_BYTE_28_SL_S, rdma_ah_get_sl(&attr->ah_attr));
+		       V2_QPC_BYTE_28_SL_S, hr_qp->sl);
 	roce_set_field(qpc_mask->byte_28_at_fl, V2_QPC_BYTE_28_SL_M,
 		       V2_QPC_BYTE_28_SL_S, 0);
-	hr_qp->sl = rdma_ah_get_sl(&attr->ah_attr);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index 4f840997c6c73..c6a280bdbfaaf 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -1957,6 +1957,8 @@ struct hns_roce_eq_context {
 #define HNS_ROCE_V2_AEQE_EVENT_QUEUE_NUM_S 0
 #define HNS_ROCE_V2_AEQE_EVENT_QUEUE_NUM_M GENMASK(23, 0)
 
+#define MAX_SERVICE_LEVEL 0x7
+
 struct hns_roce_wqe_atomic_seg {
 	__le64          fetchadd_swap_data;
 	__le64          cmp_data;
-- 
2.25.1



