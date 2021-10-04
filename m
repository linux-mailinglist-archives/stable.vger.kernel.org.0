Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8422A420FD5
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237802AbhJDNiz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:38:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237149AbhJDNhC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:37:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F21A261215;
        Mon,  4 Oct 2021 13:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353400;
        bh=8ofguC9CtQHUSM4/k/g9gXqsobh2j3qKHdJ08Hij9uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VP6lK/1UBx93bw+lnCBIWQkmZfc32fHyLWYsl1S9duCeBgc3knj9Qt0OnNGSx1ILD
         aqJ/OmddnUKCNonHmndIWoLWlr2vMBHv5EWKA5wWZTR7KBSU8ukAhRKBfGpVUYEXxx
         +AgWRzoC/CB5wWl/pFy7PS04HcuNJW29aNfqFVpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wenpeng Liang <liangwenpeng@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 113/172] RDMA/hns: Add the check of the CQE size of the user space
Date:   Mon,  4 Oct 2021 14:52:43 +0200
Message-Id: <20211004125048.632020201@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wenpeng Liang <liangwenpeng@huawei.com>

[ Upstream commit e671f0ecfece14940a9bb81981098910ea278cf7 ]

If the CQE size of the user space is not the size supported by the
hardware, the creation of CQ should be stopped.

Fixes: 09a5f210f67e ("RDMA/hns: Add support for CQE in size of 64 Bytes")
Link: https://lore.kernel.org/r/20210927125557.15031-3-liangwenpeng@huawei.com
Signed-off-by: Wenpeng Liang <liangwenpeng@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c | 31 ++++++++++++++++++-------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 1e9c3c5bee68..d763f097599f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -326,19 +326,30 @@ static void set_cq_param(struct hns_roce_cq *hr_cq, u32 cq_entries, int vector,
 	INIT_LIST_HEAD(&hr_cq->rq_list);
 }
 
-static void set_cqe_size(struct hns_roce_cq *hr_cq, struct ib_udata *udata,
-			 struct hns_roce_ib_create_cq *ucmd)
+static int set_cqe_size(struct hns_roce_cq *hr_cq, struct ib_udata *udata,
+			struct hns_roce_ib_create_cq *ucmd)
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(hr_cq->ib_cq.device);
 
-	if (udata) {
-		if (udata->inlen >= offsetofend(typeof(*ucmd), cqe_size))
-			hr_cq->cqe_size = ucmd->cqe_size;
-		else
-			hr_cq->cqe_size = HNS_ROCE_V2_CQE_SIZE;
-	} else {
+	if (!udata) {
 		hr_cq->cqe_size = hr_dev->caps.cqe_sz;
+		return 0;
+	}
+
+	if (udata->inlen >= offsetofend(typeof(*ucmd), cqe_size)) {
+		if (ucmd->cqe_size != HNS_ROCE_V2_CQE_SIZE &&
+		    ucmd->cqe_size != HNS_ROCE_V3_CQE_SIZE) {
+			ibdev_err(&hr_dev->ib_dev,
+				  "invalid cqe size %u.\n", ucmd->cqe_size);
+			return -EINVAL;
+		}
+
+		hr_cq->cqe_size = ucmd->cqe_size;
+	} else {
+		hr_cq->cqe_size = HNS_ROCE_V2_CQE_SIZE;
 	}
+
+	return 0;
 }
 
 int hns_roce_create_cq(struct ib_cq *ib_cq, const struct ib_cq_init_attr *attr,
@@ -366,7 +377,9 @@ int hns_roce_create_cq(struct ib_cq *ib_cq, const struct ib_cq_init_attr *attr,
 
 	set_cq_param(hr_cq, attr->cqe, attr->comp_vector, &ucmd);
 
-	set_cqe_size(hr_cq, udata, &ucmd);
+	ret = set_cqe_size(hr_cq, udata, &ucmd);
+	if (ret)
+		return ret;
 
 	ret = alloc_cq_buf(hr_dev, hr_cq, udata, ucmd.buf_addr);
 	if (ret) {
-- 
2.33.0



