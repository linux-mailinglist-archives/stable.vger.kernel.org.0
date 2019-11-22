Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEFAF106660
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfKVGaI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:30:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:53894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727187AbfKVFtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 950EF2068F;
        Fri, 22 Nov 2019 05:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401781;
        bh=cWK1kp03Or15lWIONAwKQIPs6G7BvNiBb99QgZGfv+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U1Zq/gUady675QHBAsgz8mYGjpDqTpQ3Ri7R08Ey2N4oZVy/Pj/CILrCh37rfif7T
         9ueabRrMTg5D9tkKRCuiSJPRrj67Riwq6GjWG6s1tQ4ED6pzA7WI/YoxAPBOVgmEhr
         ut7fq7XXTSgyFbj/PRlHGWg0ysBBFAucvzgNr0pk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijun Ou <oulijun@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 030/219] RDMA/hns: Fix the bug while use multi-hop of pbl
Date:   Fri, 22 Nov 2019 00:46:02 -0500
Message-Id: <20191122054911.1750-23-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 4af07f01f7a787ba5158352b98c9e3cb74995a1c ]

It will prevent multiply overflow when defines the pbl for u64 type.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_mr.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 41a538d23b802..c68596d4e8037 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -1017,14 +1017,14 @@ struct ib_mr *hns_roce_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 			goto err_umem;
 		}
 	} else {
-		int pbl_size = 1;
+		u64 pbl_size = 1;
 
 		bt_size = (1 << (hr_dev->caps.pbl_ba_pg_sz + PAGE_SHIFT)) / 8;
 		for (i = 0; i < hr_dev->caps.pbl_hop_num; i++)
 			pbl_size *= bt_size;
 		if (n > pbl_size) {
 			dev_err(dev,
-			    " MR len %lld err. MR page num is limited to %d!\n",
+			    " MR len %lld err. MR page num is limited to %lld!\n",
 			    length, pbl_size);
 			ret = -EINVAL;
 			goto err_umem;
-- 
2.20.1

