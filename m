Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D9383CA0
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 23:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbfHFVm6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 17:42:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:52772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728048AbfHFVe7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 17:34:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D2B3217D7;
        Tue,  6 Aug 2019 21:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565127299;
        bh=gHKN6VO5FHUT4n/WevuPBAN7VBwc4Wg2WGpEHcz+kKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JrK4dhXdy+dtCt41psVtswv87CiLNPLx2+eU17rUJ/YaMZCGfK+P7hJwfaqISetvL
         pfYyVMwPvxgKfSRYJwQkHPZo+/AeezdrXJYUKWRx3Mqe253G8hvccSEtC6l8eACSIy
         5B6p2XwQFJN8yDAUXaF4fDyWTGh5WwXmpbZohkrg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 50/59] RDMA/hns: Fix error return code in hns_roce_v1_rsv_lp_qp()
Date:   Tue,  6 Aug 2019 17:33:10 -0400
Message-Id: <20190806213319.19203-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190806213319.19203-1-sashal@kernel.org>
References: <20190806213319.19203-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 020fb3bebc224dfe9353a56ecbe2d5fac499dffc ]

Fix to return error code -ENOMEM from the rdma_zalloc_drv_obj() error
handling case instead of 0, as done elsewhere in this function.

Fixes: e8ac9389f0d7 ("RDMA: Fix allocation failure on pointer pd")
Fixes: 21a428a019c9 ("RDMA: Handle PD allocations by IB/core")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
Link: https://lore.kernel.org/r/20190801012725.150493-1-weiyongjun1@huawei.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index e068a02122f5e..9496c69fff3a2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -745,8 +745,10 @@ static int hns_roce_v1_rsv_lp_qp(struct hns_roce_dev *hr_dev)
 
 	ibdev = &hr_dev->ib_dev;
 	pd = rdma_zalloc_drv_obj(ibdev, ib_pd);
-	if (!pd)
+	if (!pd) {
+		ret = -ENOMEM;
 		goto alloc_mem_failed;
+	}
 
 	pd->device  = ibdev;
 	ret = hns_roce_alloc_pd(pd, NULL);
-- 
2.20.1

