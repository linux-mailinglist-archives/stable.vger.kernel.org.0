Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CC71FE71F
	for <lists+stable@lfdr.de>; Thu, 18 Jun 2020 04:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgFRCim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 22:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:42494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727938AbgFRBNV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jun 2020 21:13:21 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D574321D7B;
        Thu, 18 Jun 2020 01:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592442800;
        bh=Y3voCUNEE+8e7P/ucqa7SNePS020clMv3FTzPzYTypI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UTylEEICqeSyMzbyHwrmwG/ahxbmzT7/QO9ZmRu7QUjT00SUZT/qFGuUYeYF89+ee
         tRbsTF55qMoFK0e7oX2HHu0GX8VN64sZEtQpw9yisNzZcQlQ5Fg/eLPGs+Sa7Z1xtv
         5DuR6cstsYsFuUpk8powuQyyy00PximX5/MPW+JE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lang Cheng <chenglang@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 241/388] RDMA/hns: Fix cmdq parameter of querying pf timer resource
Date:   Wed, 17 Jun 2020 21:05:38 -0400
Message-Id: <20200618010805.600873-241-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 96ff610bbdc4..f9fa80ae5560 100644
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

