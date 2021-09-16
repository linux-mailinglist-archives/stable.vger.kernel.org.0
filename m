Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBEA40E62F
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346021AbhIPRSx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:18:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350816AbhIPRQw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:16:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C45361BA7;
        Thu, 16 Sep 2021 16:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810425;
        bh=Pl4jT/1pzimdql52fgjmzbZnSvgTJ6qtKEL9aVJzT3A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jn3s30sdRhXU3GkWuFJr6dYp4HmfTB26LBmmZ0IW5JQoQq9d7YziPG8UBsCIUMwtn
         5XRoIjdL4kISJymm2/5Im7Ok0ssnJNXFEVi/F7YZBseLiFk14RQ8KarbmLXltkVktQ
         j/5B+mIOEx4gqoieb21uN6Cja1Sf+2+EtvWwxy74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Junxian Huang <huangjunxian4@hisilicon.com>,
        Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 137/432] RDMA/hns: Bugfix for the missing assignment for dip_idx
Date:   Thu, 16 Sep 2021 17:58:06 +0200
Message-Id: <20210916155815.405682126@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
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
index f4cea6dcec2f..d9e330a383b2 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4514,8 +4514,10 @@ static int get_dip_ctx_idx(struct ib_qp *ibqp, const struct ib_qp_attr *attr,
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



