Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1581C1193B6
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728248AbfLJVJj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:09:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728245AbfLJVJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 02C8D246AB;
        Tue, 10 Dec 2019 21:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012177;
        bh=TXOjcJ55rsjrjIq01c8fBm2rN0iwB/1z+jhNZ8jUdSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j8yYXpWJEw09QAcLlHyrVpjp+ngtc1qfoECVmPmJasshLGqoJ0dw9nTFqNVUr3Xtp
         V7ZQ3NfjKwJClpcLVmXkFQ+20seSh/JErFHATaYBJLcJpaN35SwN+sBMA2I2aFQ9tT
         wmvD+zvR9RcSdPBml0N9OqKv+mPNGlOp0f1RNKa8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Weihang Li <liweihang@hisilicon.com>,
        Doug Ledford <dledford@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 135/350] RDMA/hns: Fix wrong parameters when initial mtt of srq->idx_que
Date:   Tue, 10 Dec 2019 16:04:00 -0500
Message-Id: <20191210210735.9077-96-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

[ Upstream commit e8a07de57ea4ca7c2d604871c52826e66899fc70 ]

The parameters npages used to initial mtt of srq->idx_que shouldn't be
same with srq's. And page_shift should be calculated from idx_buf_pg_sz.
This patch fixes above issues and use field named npage and page_shift
in hns_roce_buf instead of two temporary variables to let us use them
anywhere.

Fixes: 18df508c7970 ("RDMA/hns: Remove if-else judgment statements for creating srq")
Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Link: https://lore.kernel.org/r/1567566885-23088-3-git-send-email-liweihang@hisilicon.com
Signed-off-by: Doug Ledford <dledford@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_srq.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 43ea2c13b2122..108667ae6b14c 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -180,8 +180,7 @@ static int create_user_srq(struct hns_roce_srq *srq, struct ib_udata *udata,
 {
 	struct hns_roce_dev *hr_dev = to_hr_dev(srq->ibsrq.device);
 	struct hns_roce_ib_create_srq  ucmd;
-	u32 page_shift;
-	u32 npages;
+	struct hns_roce_buf *buf;
 	int ret;
 
 	if (ib_copy_from_udata(&ucmd, udata, sizeof(ucmd)))
@@ -191,11 +190,13 @@ static int create_user_srq(struct hns_roce_srq *srq, struct ib_udata *udata,
 	if (IS_ERR(srq->umem))
 		return PTR_ERR(srq->umem);
 
-	npages = (ib_umem_page_count(srq->umem) +
-		(1 << hr_dev->caps.srqwqe_buf_pg_sz) - 1) /
-		(1 << hr_dev->caps.srqwqe_buf_pg_sz);
-	page_shift = PAGE_SHIFT + hr_dev->caps.srqwqe_buf_pg_sz;
-	ret = hns_roce_mtt_init(hr_dev, npages, page_shift, &srq->mtt);
+	buf = &srq->buf;
+	buf->npages = (ib_umem_page_count(srq->umem) +
+		       (1 << hr_dev->caps.srqwqe_buf_pg_sz) - 1) /
+		      (1 << hr_dev->caps.srqwqe_buf_pg_sz);
+	buf->page_shift = PAGE_SHIFT + hr_dev->caps.srqwqe_buf_pg_sz;
+	ret = hns_roce_mtt_init(hr_dev, buf->npages, buf->page_shift,
+				&srq->mtt);
 	if (ret)
 		goto err_user_buf;
 
@@ -212,9 +213,12 @@ static int create_user_srq(struct hns_roce_srq *srq, struct ib_udata *udata,
 		goto err_user_srq_mtt;
 	}
 
-	ret = hns_roce_mtt_init(hr_dev, ib_umem_page_count(srq->idx_que.umem),
-				PAGE_SHIFT, &srq->idx_que.mtt);
-
+	buf = &srq->idx_que.idx_buf;
+	buf->npages = DIV_ROUND_UP(ib_umem_page_count(srq->idx_que.umem),
+				   1 << hr_dev->caps.idx_buf_pg_sz);
+	buf->page_shift = PAGE_SHIFT + hr_dev->caps.idx_buf_pg_sz;
+	ret = hns_roce_mtt_init(hr_dev, buf->npages, buf->page_shift,
+				&srq->idx_que.mtt);
 	if (ret) {
 		dev_err(hr_dev->dev, "hns_roce_mtt_init error for idx que\n");
 		goto err_user_idx_mtt;
-- 
2.20.1

