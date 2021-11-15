Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6569451E0F
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354731AbhKPAfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344519AbhKOTYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD901633A7;
        Mon, 15 Nov 2021 18:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002753;
        bh=8wV7+OBJV82c6b93Im8DGC8v6RjDnma5JVmqQY/tLaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Af1+qeMS07xwU+FCoAXZVJ1a5osz7BFUq8fQwKkfLYmk6gLh7H1wDXJAwXi/uNciJ
         LcvKJKz+1BZmfiA/nWz91SfRKPqGe/KxsL0ZHpSLe+kmsJwQUa/Piz9MSlQAioNQyw
         HYFaV3CFmqAFEjIGCCxD+JuMKogkAYTwClEEYSbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 684/917] RDMA/hns: Fix initial arm_st of CQ
Date:   Mon, 15 Nov 2021 18:02:59 +0100
Message-Id: <20211115165452.094772555@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haoyue Xu <xuhaoyue1@hisilicon.com>

[ Upstream commit 571fb4fb78a3bf0fcadbe65eca9ca4ccee885af4 ]

We set the init CQ status to ARMED before. As a result, an unexpected CEQE
would be reported. Therefore, the init CQ status should be set to no_armed
rather than REG_NXT_CEQE.

Fixes: a5073d6054f7 ("RDMA/hns: Add eq support of hip08")
Link: https://lore.kernel.org/r/20211029095846.26732-1-liangwenpeng@huawei.com
Signed-off-by: Haoyue Xu <xuhaoyue1@hisilicon.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index d5f3faa1627a4..8e5f0862896ee 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3328,7 +3328,7 @@ static void hns_roce_v2_write_cqc(struct hns_roce_dev *hr_dev,
 	memset(cq_context, 0, sizeof(*cq_context));
 
 	hr_reg_write(cq_context, CQC_CQ_ST, V2_CQ_STATE_VALID);
-	hr_reg_write(cq_context, CQC_ARM_ST, REG_NXT_CEQE);
+	hr_reg_write(cq_context, CQC_ARM_ST, NO_ARMED);
 	hr_reg_write(cq_context, CQC_SHIFT, ilog2(hr_cq->cq_depth));
 	hr_reg_write(cq_context, CQC_CEQN, hr_cq->vector);
 	hr_reg_write(cq_context, CQC_CQN, hr_cq->cqn);
-- 
2.33.0



