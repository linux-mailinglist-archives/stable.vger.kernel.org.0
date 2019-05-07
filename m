Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC0E015BB5
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbfEGFhx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:37:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:57658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727878AbfEGFhw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:37:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E03C21655;
        Tue,  7 May 2019 05:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207471;
        bh=IppytvYArZuXTW2szNeE2hJxNI5S5UlMeksAx99e3SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0MJDAe+Q8BtWOa7ZcE5Nhrwv8fVlVdUDKrBBA5uyN8ewee5qPYeFEICzUwTICkzc9
         nmaKmRp5CU321IEBBuL08It6AEwLyC3Bv+GHNjQPCRvK1A4shsMxUHKsII6Je9iH/F
         q749X/MzBagkRVB1LWR/excuDnMx+wSrEjwCmdYU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijun Ou <oulijun@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 62/81] RDMA/hns: Bugfix for mapping user db
Date:   Tue,  7 May 2019 01:35:33 -0400
Message-Id: <20190507053554.30848-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053554.30848-1-sashal@kernel.org>
References: <20190507053554.30848-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 2557fabd6e29f349bfa0ac13f38ac98aa5eafc74 ]

When the maximum send wr delivered by the user is zero, the qp does not
have a sq.

When allocating the sq db buffer to store the user sq pi pointer and map
it to the kernel mode, max_send_wr is used as the trigger condition, while
the kernel does not consider the max_send_wr trigger condition when
mapmping db. It will cause sq record doorbell map fail and create qp fail.

The failed print information as follows:

 hns3 0000:7d:00.1: Send cmd: tail - 418, opcode - 0x8504, flag - 0x0011, retval - 0x0000
 hns3 0000:7d:00.1: Send cmd: 0xe59dc000 0x00000000 0x00000000 0x00000000 0x00000116 0x0000ffff
 hns3 0000:7d:00.1: sq record doorbell map failed!
 hns3 0000:7d:00.1: Create RC QP failed

Fixes: 0425e3e6e0c7 ("RDMA/hns: Support flush cqe for hip08 in kernel space")
Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index efb7e961ca65..2fa4fb17f6d3 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -494,7 +494,7 @@ static int hns_roce_set_kernel_sq_size(struct hns_roce_dev *hr_dev,
 
 static int hns_roce_qp_has_sq(struct ib_qp_init_attr *attr)
 {
-	if (attr->qp_type == IB_QPT_XRC_TGT)
+	if (attr->qp_type == IB_QPT_XRC_TGT || !attr->cap.max_send_wr)
 		return 0;
 
 	return 1;
-- 
2.20.1

