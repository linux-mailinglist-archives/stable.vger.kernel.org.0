Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38AB113EDE6
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393534AbgAPRjs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:39:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:56334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393519AbgAPRjo (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:39:44 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 50D812470D;
        Thu, 16 Jan 2020 17:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196384;
        bh=1L+Uh7jj68z+yjjo5rQZ/oiCiuQZRMJEugTJpqgN8wc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EuDO5KvHfsdMP2hEmBHrcrnJWClJIFMoxgGoAcsXgCmJ+cxEhIngioPL0VDKyYE3T
         MuHWzNr1CbI9K5+1nieZFaTjg7NQY315A2TALarX+lpeLSMk9i2LdGnsmP+328nb4a
         fyu84xA/GSlc5wRFcdvNGSogCaJfrVgsuacV23kQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xi Wang <wangxi11@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 166/251] RDMA/hns: Fixs hw access invalid dma memory error
Date:   Thu, 16 Jan 2020 12:35:15 -0500
Message-Id: <20200116173641.22137-126-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xi Wang <wangxi11@huawei.com>

[ Upstream commit ec5bc2cc69b4fc494e04d10fc5226f6f9cf67c56 ]

When smmu is enable, if execute the perftest command and then use 'kill
-9' to exit, follow this operation repeatedly, the kernel will have a high
probability to print the following smmu event:

  arm-smmu-v3 arm-smmu-v3.1.auto: event 0x10 received:
  arm-smmu-v3 arm-smmu-v3.1.auto:  0x00007d0000000010
  arm-smmu-v3 arm-smmu-v3.1.auto:  0x0000020900000080
  arm-smmu-v3 arm-smmu-v3.1.auto:  0x00000000f47cf000
  arm-smmu-v3 arm-smmu-v3.1.auto:  0x00000000f47cf000

This is because the hw will periodically refresh the qpc cache until the
next reset.

This patch fixed it by removing the action that release qpc memory in the
'hns_roce_qp_free' function.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Xi Wang <wangxi11@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 33cf1035030b..6f3c0ea99dd0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -241,7 +241,6 @@ void hns_roce_qp_free(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp)
 
 	if ((hr_qp->ibqp.qp_type) != IB_QPT_GSI) {
 		hns_roce_table_put(hr_dev, &qp_table->irrl_table, hr_qp->qpn);
-		hns_roce_table_put(hr_dev, &qp_table->qp_table, hr_qp->qpn);
 	}
 }
 
-- 
2.20.1

