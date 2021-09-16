Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05F9640E2AD
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243998AbhIPQlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:41:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:51974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243277AbhIPQhs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:37:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 042C66140B;
        Thu, 16 Sep 2021 16:22:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809344;
        bh=pAeQNPdjb3okbSJzeanpg3WlxyCln949BMGJMt/KhsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RtlQAC5SgKhqiof16T2/nDZhdTqAmJBqOKHNr4A4/YPWKRwG1O7lV8BhKGQd+VNUm
         wbNbS0+ztsX9dFHofdEHgwY4Z740w3UFJlV0BJLwTFNYWI+li+g03V9luFCYPrFrD6
         2612Zaeq9ctTqRaSOacdKOtbdc37VTaIjjq363Ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Junxian Huang <huangjunxian4@hisilicon.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 121/380] RDMA/hns: Bugfix for the missing assignment for dip_idx
Date:   Thu, 16 Sep 2021 17:57:58 +0200
Message-Id: <20210916155808.165146683@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Junxian Huang <huangjunxian4@hisilicon.com>

[ Upstream commit 074f315fc54a9ce45559a44ca36d9fa1ee1ea2cd ]

When the dgid-dip_idx mapping relationship exists, dip should be assigned.

Fixes: f91696f2f053 ("RDMA/hns: Support congestion control type selection according to the FW")
Link: https://lore.kernel.org/r/1629884592-23424-3-git-send-email-liangwenpeng@huawei.com
Signed-off-by: Junxian Huang <huangjunxian4@hisilicon.com>
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index dcbe5e28a4f7..90945e664f5d 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4735,8 +4735,10 @@ static int get_dip_ctx_idx(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
 	spin_lock_irqsave(&hr_dev->dip_list_lock, flags);
 
 	list_for_each_entry(hr_dip, &hr_dev->dip_list, node) {
-		if (!memcmp(grh->dgid.raw, hr_dip->dgid, 16))
+		if (!memcmp(grh->dgid.raw, hr_dip->dgid, 16)) {
+			*dip_idx = hr_dip->dip_idx;
 			goto out;
+		}
 	}
 
 	/* If no dgid is found, a new dip and a mapping between dgid and
-- 
2.30.2



