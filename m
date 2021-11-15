Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D034522BD
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354253AbhKPBP5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:15:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:42974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244387AbhKOTOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:14:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61081634B9;
        Mon, 15 Nov 2021 18:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000428;
        bh=/FuRj4ws3VovqQvN2tM6OisxzeXfv89tKaz+vhWXbnU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N3rOXfYxutsIgMwFtvQlmoBmpwAidEN0i3V0ZKDmRyNbyPE5c4/xFGEUm+FqamZTy
         EBhOYbYsAzBlelxCgSC12lp5n1Rv1hty7ubqul0XSwRs0MHF5lbj+n8+AyoPuXbjFs
         /0SBFemIyQa8eqGThBJjEYj7GhbNy7/gTAFUSZ90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haoyue Xu <xuhaoyue1@hisilicon.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 656/849] RDMA/hns: Fix initial arm_st of CQ
Date:   Mon, 15 Nov 2021 18:02:19 +0100
Message-Id: <20211115165442.456918777@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 0ccb0c453f6a2..a77732c218dcb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -3335,7 +3335,7 @@ static void hns_roce_v2_write_cqc(struct hns_roce_dev *hr_dev,
 	memset(cq_context, 0, sizeof(*cq_context));
 
 	hr_reg_write(cq_context, CQC_CQ_ST, V2_CQ_STATE_VALID);
-	hr_reg_write(cq_context, CQC_ARM_ST, REG_NXT_CEQE);
+	hr_reg_write(cq_context, CQC_ARM_ST, NO_ARMED);
 	hr_reg_write(cq_context, CQC_SHIFT, ilog2(hr_cq->cq_depth));
 	hr_reg_write(cq_context, CQC_CEQN, hr_cq->vector);
 	hr_reg_write(cq_context, CQC_CQN, hr_cq->cqn);
-- 
2.33.0



