Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577DA3BCD43
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 13:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232335AbhGFLVF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 07:21:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232531AbhGFLS2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:18:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9789A61C3E;
        Tue,  6 Jul 2021 11:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570150;
        bh=XM0qc8OEyEQoRAXRwwR3NOU253deuvnzcoUFNMEsi9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tloBdTBbDutvYwEC/zaLifm43d1qly7grNx3HVDmyYvtTiDMuSN3hJ0+4MtYUgMsp
         Mr3nZevyku0bahAdt3796/HB3K88swLFoSos4AObS3lA6ntZAPy9ehjvoi8PFUJjZP
         db05zztR2gDOFUMzQ2JIGM2pSiXywlsQoutntaZnRLpfkpzZFvPOG2CBsc8L9g0yBs
         g+gmxCABRq0JCOoC4e4MySi52Z3bOCUv4QIOwPrUZUJa/0kupZCpK7+VFQqi1k39k0
         JSQiEtua0lkOu0ao3oMHkPaK1wVHW+Zx48VqiUpXa+3NgkovVvPM3dYr6n2R25Gp9W
         I2V05vNnHIUGQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 073/189] RDMA/cxgb4: Fix missing error code in create_qp()
Date:   Tue,  6 Jul 2021 07:12:13 -0400
Message-Id: <20210706111409.2058071-73-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706111409.2058071-1-sashal@kernel.org>
References: <20210706111409.2058071-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

[ Upstream commit aeb27bb76ad8197eb47890b1ff470d5faf8ec9a5 ]

The error code is missing in this code scenario so 0 will be returned. Add
the error code '-EINVAL' to the return value 'ret'.

Eliminates the follow smatch warning:

drivers/infiniband/hw/cxgb4/qp.c:298 create_qp() warn: missing error code 'ret'.

Link: https://lore.kernel.org/r/1622545669-20625-1-git-send-email-jiapeng.chong@linux.alibaba.com
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/cxgb4/qp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index d109bb3822a5..c9403743346e 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -295,6 +295,7 @@ static int create_qp(struct c4iw_rdev *rdev, struct t4_wq *wq,
 	if (user && (!wq->sq.bar2_pa || (need_rq && !wq->rq.bar2_pa))) {
 		pr_warn("%s: sqid %u or rqid %u not in BAR2 range\n",
 			pci_name(rdev->lldi.pdev), wq->sq.qid, wq->rq.qid);
+		ret = -EINVAL;
 		goto free_dma;
 	}
 
-- 
2.30.2

