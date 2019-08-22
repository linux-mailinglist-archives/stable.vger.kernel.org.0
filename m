Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C08999F6
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 19:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390617AbfHVRJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 13:09:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:59084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388965AbfHVRI7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 13:08:59 -0400
Received: from sasha-vm.mshome.net (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EC382341E;
        Thu, 22 Aug 2019 17:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566493738;
        bh=gHKN6VO5FHUT4n/WevuPBAN7VBwc4Wg2WGpEHcz+kKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sub19L+3xTto1xgiFeElnjz0hGjgd8GO27LjLl9QGeQmtNE3+oXowbwRmXla3vhbv
         WQtKnqgkezLc35Wh7xkWIyAchPSTIrl8IcUfVgLJUYUckgeWkfxbDdwVyqk02R0CwD
         +5ziD/Mc8N72yv793TPO2fw5g2WoRpcfDYf2osBI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 082/135] RDMA/hns: Fix error return code in hns_roce_v1_rsv_lp_qp()
Date:   Thu, 22 Aug 2019 13:07:18 -0400
Message-Id: <20190822170811.13303-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190822170811.13303-1-sashal@kernel.org>
References: <20190822170811.13303-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.2.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.2.10-rc1
X-KernelTest-Deadline: 2019-08-24T17:07+00:00
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

