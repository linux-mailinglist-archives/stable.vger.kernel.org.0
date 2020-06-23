Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F70E205F1F
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390999AbgFWU3f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:29:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:49612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390994AbgFWU3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:29:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4A09D2064B;
        Tue, 23 Jun 2020 20:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944173;
        bh=GrohkfbmeiXd0QzpT86snwSvZYnUkRryWc+YAvRBiq0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2MRKcZOiXtyABzj9imWDA3Nin3+esOIxNHk9qxkt3yAMX86+eOYi+XsRoeUuYC5b9
         5wRDBEl4cYXP+jbT69UgkCPMEqBS5t8mWDAkslvJCcrn+VyF8AmUf2L3hnliBaEvHF
         3PzJ2pvbXRJs9LUqtj5+ReDLuebRhxrA5Jg8WXo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Cheng <chenglang@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 161/314] RDMA/hns: Fix cmdq parameter of querying pf timer resource
Date:   Tue, 23 Jun 2020 21:55:56 +0200
Message-Id: <20200623195346.550128141@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lang Cheng <chenglang@huawei.com>

[ Upstream commit 441c88d5b3ff80108ff536c6cf80591187015403 ]

The firmware has reduced the number of descriptions of command
HNS_ROCE_OPC_QUERY_PF_TIMER_RES to 1. The driver needs to adapt, otherwise
the hardware will report error 4(CMD_NEXT_ERR).

Fixes: 0e40dc2f70cd ("RDMA/hns: Add timer allocation support for hip08")
Link: https://lore.kernel.org/r/1588931159-56875-3-git-send-email-liweihang@huawei.com
Signed-off-by: Lang Cheng <chenglang@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 32 ++++++++--------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 9a8053bd01e22..0502c90c83edd 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1349,34 +1349,26 @@ static int hns_roce_query_pf_resource(struct hns_roce_dev *hr_dev)
 static int hns_roce_query_pf_timer_resource(struct hns_roce_dev *hr_dev)
 {
 	struct hns_roce_pf_timer_res_a *req_a;
-	struct hns_roce_cmq_desc desc[2];
-	int ret, i;
+	struct hns_roce_cmq_desc desc;
+	int ret;
 
-	for (i = 0; i < 2; i++) {
-		hns_roce_cmq_setup_basic_desc(&desc[i],
-					      HNS_ROCE_OPC_QUERY_PF_TIMER_RES,
-					      true);
+	hns_roce_cmq_setup_basic_desc(&desc, HNS_ROCE_OPC_QUERY_PF_TIMER_RES,
+				      true);
 
-		if (i == 0)
-			desc[i].flag |= cpu_to_le16(HNS_ROCE_CMD_FLAG_NEXT);
-		else
-			desc[i].flag &= ~cpu_to_le16(HNS_ROCE_CMD_FLAG_NEXT);
-	}
-
-	ret = hns_roce_cmq_send(hr_dev, desc, 2);
+	ret = hns_roce_cmq_send(hr_dev, &desc, 1);
 	if (ret)
 		return ret;
 
-	req_a = (struct hns_roce_pf_timer_res_a *)desc[0].data;
+	req_a = (struct hns_roce_pf_timer_res_a *)desc.data;
 
 	hr_dev->caps.qpc_timer_bt_num =
-				roce_get_field(req_a->qpc_timer_bt_idx_num,
-					PF_RES_DATA_1_PF_QPC_TIMER_BT_NUM_M,
-					PF_RES_DATA_1_PF_QPC_TIMER_BT_NUM_S);
+		roce_get_field(req_a->qpc_timer_bt_idx_num,
+			       PF_RES_DATA_1_PF_QPC_TIMER_BT_NUM_M,
+			       PF_RES_DATA_1_PF_QPC_TIMER_BT_NUM_S);
 	hr_dev->caps.cqc_timer_bt_num =
-				roce_get_field(req_a->cqc_timer_bt_idx_num,
-					PF_RES_DATA_2_PF_CQC_TIMER_BT_NUM_M,
-					PF_RES_DATA_2_PF_CQC_TIMER_BT_NUM_S);
+		roce_get_field(req_a->cqc_timer_bt_idx_num,
+			       PF_RES_DATA_2_PF_CQC_TIMER_BT_NUM_M,
+			       PF_RES_DATA_2_PF_CQC_TIMER_BT_NUM_S);
 
 	return 0;
 }
-- 
2.25.1



