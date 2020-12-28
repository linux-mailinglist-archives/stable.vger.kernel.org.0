Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADD4D2E4113
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440035AbgL1ONG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:13:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:45022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439522AbgL1OLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 334E8206C3;
        Mon, 28 Dec 2020 14:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164656;
        bh=dc5OAZpa9xNIsOyxCytIC9WiWqe3rcRfKFLxic3kvz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ShLSdvCEHqugpwQc3UHfo5nn8ugKxLVKWeAS/JJxOGocfUHMBlWuQpe32s+xsuuj+
         RDsxmSO16vbZsjeVhsWYnfRSyGAdhG8Ois9/OUBGoKbApu3gHEJNHw4UCpGcGxktGa
         xVnSfo0RpcytQKgUFpxjwDudTnnbokH7lSNXN12s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yangyang Li <liyangyang20@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 252/717] RDMA/hns: Bugfix for calculation of extended sge
Date:   Mon, 28 Dec 2020 13:44:10 +0100
Message-Id: <20201228125033.060064393@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangyang Li <liyangyang20@huawei.com>

[ Upstream commit d34895c319faa1e0fc1a48c3b06bba6a8a39ba44 ]

Page alignment is required when setting the number of extended sge
according to the hardware's achivement. If the space of needed extended
sge is greater than one page, the roundup_pow_of_two() can ensure
that. But if the needed extended sge isn't 0 and can not be filled in a
whole page, the driver should align it specifically.

Fixes: 54d6638765b0 ("RDMA/hns: Optimize WQE buffer size calculating process")
Link: https://lore.kernel.org/r/1606558959-48510-3-git-send-email-liweihang@huawei.com
Signed-off-by: Yangyang Li <liyangyang20@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 6c081dd985fc9..71ea8fd9041b9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -432,7 +432,12 @@ static int set_extend_sge_param(struct hns_roce_dev *hr_dev, u32 sq_wqe_cnt,
 	}
 
 	hr_qp->sge.sge_shift = HNS_ROCE_SGE_SHIFT;
-	hr_qp->sge.sge_cnt = cnt;
+
+	/* If the number of extended sge is not zero, they MUST use the
+	 * space of HNS_HW_PAGE_SIZE at least.
+	 */
+	hr_qp->sge.sge_cnt = cnt ?
+			max(cnt, (u32)HNS_HW_PAGE_SIZE / HNS_ROCE_SGE_SIZE) : 0;
 
 	return 0;
 }
-- 
2.27.0



