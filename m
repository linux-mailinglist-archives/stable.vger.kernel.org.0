Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17EA840E650
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241685AbhIPRUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:20:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240999AbhIPRRY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:17:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBDE361B68;
        Thu, 16 Sep 2021 16:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810439;
        bh=u3MTLEp+sdwGmRrY2/LeZpkiPJfV2IR5DNYyhxUL090=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmU+PBBWVOPyQSnaBQ19Fafu1nhQ/in6BUPAI4llC3ChPZqe1JSHToR6c1ebsb1q5
         HZZ4rwM1mkNBn16G8qH3HLSd3XlUW0vE0mNuezFtcj1khXhjtIKpv4ohFcEU6siYYF
         mVeGLMdsbRaAf/L0tw2djju37tbeHujStAjhct/M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 142/432] RDMA/hns: Fix query destination qpn
Date:   Thu, 16 Sep 2021 17:58:11 +0200
Message-Id: <20210916155815.575754284@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit e788a3cd5787aca74e0ee00202d4dca64b43f043 ]

The bit width of dqpn is 24 bits, using u8 will cause truncation error.

Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Link: https://lore.kernel.org/r/1629985056-57004-2-git-send-email-liangwenpeng@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 21c82f5aff04..bf4d9f6658ff 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -5136,7 +5136,7 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 
 	qp_attr->rq_psn = hr_reg_read(&context, QPC_RX_REQ_EPSN);
 	qp_attr->sq_psn = (u32)hr_reg_read(&context, QPC_SQ_CUR_PSN);
-	qp_attr->dest_qp_num = (u8)hr_reg_read(&context, QPC_DQPN);
+	qp_attr->dest_qp_num = hr_reg_read(&context, QPC_DQPN);
 	qp_attr->qp_access_flags =
 		((hr_reg_read(&context, QPC_RRE)) << V2_QP_RRE_S) |
 		((hr_reg_read(&context, QPC_RWE)) << V2_QP_RWE_S) |
-- 
2.30.2



