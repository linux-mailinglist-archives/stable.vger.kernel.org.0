Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7E324759E
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:27:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbgHQPds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:33:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:36536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730394AbgHQPdi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:33:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C47BE22D2B;
        Mon, 17 Aug 2020 15:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678418;
        bh=OizNdolFqPCsXRkXdorZxU6XFRZXjLoM4x3IYzceCvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KcgOr1hqzBjrdljkThPO6/e495vq7efYhmsZrYYuhrXBhHeszjnwDXYPgWJegGEV/
         nkXr0fPUfNrgUw9iJWVG5EWOg24z/694RD+SDEgG4RiU2LZ9W+Z3IFkySRtpEYNnq5
         sdkKsemIimi8JZt9uKKUR1ukMfztvqFt/rzD041k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xi Wang <wangxi11@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 328/464] RDMA/hns: Fix the unneeded process when getting a general type of CQE error
Date:   Mon, 17 Aug 2020 17:14:41 +0200
Message-Id: <20200817143849.501869614@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xi Wang <wangxi11@huawei.com>

[ Upstream commit 395f2e8fd340c5bfad026f5968b56ec34cf20dd1 ]

If the hns ROCEE reports a general error CQE (types not specified by the IB
General Specifications), it's no need to change the QP state to error, and
the driver should just skip it.

Fixes: 7c044adca272 ("RDMA/hns: Simplify the cqe code of poll cq")
Link: https://lore.kernel.org/r/1595932941-40613-8-git-send-email-liweihang@huawei.com
Signed-off-by: Xi Wang <wangxi11@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 9 +++++++++
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 9833ce3e21f9e..eb71b941d21b7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3053,6 +3053,7 @@ static void get_cqe_status(struct hns_roce_dev *hr_dev, struct hns_roce_qp *qp,
 		  IB_WC_RETRY_EXC_ERR },
 		{ HNS_ROCE_CQE_V2_RNR_RETRY_EXC_ERR, IB_WC_RNR_RETRY_EXC_ERR },
 		{ HNS_ROCE_CQE_V2_REMOTE_ABORT_ERR, IB_WC_REM_ABORT_ERR },
+		{ HNS_ROCE_CQE_V2_GENERAL_ERR, IB_WC_GENERAL_ERR}
 	};
 
 	u32 cqe_status = roce_get_field(cqe->byte_4, V2_CQE_BYTE_4_STATUS_M,
@@ -3074,6 +3075,14 @@ static void get_cqe_status(struct hns_roce_dev *hr_dev, struct hns_roce_qp *qp,
 	print_hex_dump(KERN_ERR, "", DUMP_PREFIX_NONE, 16, 4, cqe,
 		       sizeof(*cqe), false);
 
+	/*
+	 * For hns ROCEE, GENERAL_ERR is an error type that is not defined in
+	 * the standard protocol, the driver must ignore it and needn't to set
+	 * the QP to an error state.
+	 */
+	if (cqe_status == HNS_ROCE_CQE_V2_GENERAL_ERR)
+		return;
+
 	/*
 	 * Hip08 hardware cannot flush the WQEs in SQ/RQ if the QP state gets
 	 * into errored mode. Hence, as a workaround to this hardware
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index e176b0aaa4ac2..e6c385ced1872 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -230,6 +230,7 @@ enum {
 	HNS_ROCE_CQE_V2_TRANSPORT_RETRY_EXC_ERR		= 0x15,
 	HNS_ROCE_CQE_V2_RNR_RETRY_EXC_ERR		= 0x16,
 	HNS_ROCE_CQE_V2_REMOTE_ABORT_ERR		= 0x22,
+	HNS_ROCE_CQE_V2_GENERAL_ERR			= 0x23,
 
 	HNS_ROCE_V2_CQE_STATUS_MASK			= 0xff,
 };
-- 
2.25.1



