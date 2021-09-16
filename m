Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0C540E2B3
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244017AbhIPQlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:41:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:52388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235565AbhIPQiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:38:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B846261409;
        Thu, 16 Sep 2021 16:22:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809358;
        bh=Zh/G5Xqaj523wWnMSa1wm05xzCg7ZM7AILOsvKO3ddQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1tKl4Ajv/o5bOA/60Lnb2fwMYaLbAVAn/673Yf4w+aQ9JqMEgHa0EMDHuh9hQbfG3
         F38b0sipA2EBgVEzGF3ZCvkEIRWGm87NEGum/Dd08HTQ4dq541WnKFwuPwAci+B5GD
         +GBBPp0sw7VmsmOMnfpjX1Sf4/fVetmLHOjNDAF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 125/380] RDMA/hns: Fix QPs resp incomplete assignment
Date:   Thu, 16 Sep 2021 17:58:02 +0200
Message-Id: <20210916155808.292671168@linuxfoundation.org>
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

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit d2e0ccffcdd7209fc9881c8970d2a7e28dcb43b9 ]

The resp passed to the user space represents the enable flag of qp,
incomplete assignment will cause some features of the user space to be
disabled.

Fixes: 90ae0b57e4a5 ("RDMA/hns: Combine enable flags of qp")
Fixes: aba457ca890c ("RDMA/hns: Support owner mode doorbell")
Link: https://lore.kernel.org/r/1629985056-57004-3-git-send-email-liangwenpeng@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 80661d368860..5d5dd0b5d507 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -835,7 +835,6 @@ static int alloc_qp_db(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 				goto err_out;
 			}
 			hr_qp->en_flags |= HNS_ROCE_QP_CAP_SQ_RECORD_DB;
-			resp->cap_flags |= HNS_ROCE_QP_CAP_SQ_RECORD_DB;
 		}
 
 		if (user_qp_has_rdb(hr_dev, init_attr, udata, resp)) {
@@ -848,7 +847,6 @@ static int alloc_qp_db(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 				goto err_sdb;
 			}
 			hr_qp->en_flags |= HNS_ROCE_QP_CAP_RQ_RECORD_DB;
-			resp->cap_flags |= HNS_ROCE_QP_CAP_RQ_RECORD_DB;
 		}
 	} else {
 		if (hr_dev->pci_dev->revision >= PCI_REVISION_ID_HIP09)
@@ -1060,6 +1058,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 	}
 
 	if (udata) {
+		resp.cap_flags = hr_qp->en_flags;
 		ret = ib_copy_to_udata(udata, &resp,
 				       min(udata->outlen, sizeof(resp)));
 		if (ret) {
-- 
2.30.2



