Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14AEC2065D0
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388860AbgFWVdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 17:33:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388677AbgFWULY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:11:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F0D7E20707;
        Tue, 23 Jun 2020 20:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943084;
        bh=QsDsrIuCNz9nnH17iOuQOCqtLaGXJvouEXfxf07aTyY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idK5vmLiWjmoId4zTc7nJbEScOSqZwr1lEjKSE/M/ZBIEmkPW1svPQN2xmCkO9Rti
         r4H9SBAhWHZE4q4x0QKuFP3+61KnXYQhLG9pz+5GyBB9nG3/mammljpyvRMnX2Gi5D
         i2/72SrEOkqtjvQrjvo5GpPOQZi+6FyX40Rq8/LE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Ou <oulijun@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 236/477] RDMA/hns: Bugfix for querying qkey
Date:   Tue, 23 Jun 2020 21:53:53 +0200
Message-Id: <20200623195418.730724554@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 349be276509455ac2f19fa4051ed773082c6a27e ]

The qkey queried through the query ud qp verb is a fixed value and it
should be read from qp context.

Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Link: https://lore.kernel.org/r/1588931159-56875-2-git-send-email-liweihang@huawei.com
Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index c3316672b70e6..96ff610bbdc4e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4639,7 +4639,7 @@ static int hns_roce_v2_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr,
 	qp_attr->path_mig_state = IB_MIG_ARMED;
 	qp_attr->ah_attr.type   = RDMA_AH_ATTR_TYPE_ROCE;
 	if (hr_qp->ibqp.qp_type == IB_QPT_UD)
-		qp_attr->qkey = V2_QKEY_VAL;
+		qp_attr->qkey = le32_to_cpu(context.qkey_xrcd);
 
 	qp_attr->rq_psn = roce_get_field(context.byte_108_rx_reqepsn,
 					 V2_QPC_BYTE_108_RX_REQ_EPSN_M,
-- 
2.25.1



