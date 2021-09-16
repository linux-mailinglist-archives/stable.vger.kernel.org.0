Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0A640DF7E
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237228AbhIPQKf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:10:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:47416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235566AbhIPQJJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:09:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B62D61357;
        Thu, 16 Sep 2021 16:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808456;
        bh=B7hmzROZ2q5FW/UnPmYrUguLrogA8mOrEXTRK0wGW/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gy8FmY/5Ap8HxjsniLVm1W8Rm24EzTHXAPkp/pMZ+ALnre9GwWlfsXqqx02RtGHRZ
         J/ZLfdwxBGBqTo2/QJLMxPSVtGwoQaqmKXOa2Bh0Z96Ygt8sBZ+PVE+iMEctMIYkgE
         DvtHSqnwn6A4essL6hp6bB1NKEMMiUTtUoBRog4A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 097/306] RDMA/hns: Fix QPs resp incomplete assignment
Date:   Thu, 16 Sep 2021 17:57:22 +0200
Message-Id: <20210916155757.372842193@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
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
index ef1452215b17..7ce9ad8aee1e 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -740,7 +740,6 @@ static int alloc_qp_db(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 				goto err_out;
 			}
 			hr_qp->en_flags |= HNS_ROCE_QP_CAP_SQ_RECORD_DB;
-			resp->cap_flags |= HNS_ROCE_QP_CAP_SQ_RECORD_DB;
 		}
 
 		if (user_qp_has_rdb(hr_dev, init_attr, udata, resp)) {
@@ -752,7 +751,6 @@ static int alloc_qp_db(struct hns_roce_dev *hr_dev, struct hns_roce_qp *hr_qp,
 				goto err_sdb;
 			}
 			hr_qp->en_flags |= HNS_ROCE_QP_CAP_RQ_RECORD_DB;
-			resp->cap_flags |= HNS_ROCE_QP_CAP_RQ_RECORD_DB;
 		}
 	} else {
 		/* QP doorbell register address */
@@ -959,6 +957,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 	}
 
 	if (udata) {
+		resp.cap_flags = hr_qp->en_flags;
 		ret = ib_copy_to_udata(udata, &resp,
 				       min(udata->outlen, sizeof(resp)));
 		if (ret) {
-- 
2.30.2



