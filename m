Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9064329035
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242741AbhCAUDk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:58660 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242500AbhCATxp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:53:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B28DA652AE;
        Mon,  1 Mar 2021 17:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621224;
        bh=S3OPKh6Yl+vUufZxbhBL4Q2WnsL4MgIOgA44f9hYOAg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tnb7rvx8Onmk+VbtAxE4jVeBLd6E72cqD7j8sQ311wHgfEDw2giS70hPCPG+TuzEb
         Z41WY4s4WIpk4EAsVKbdOkF6h9WUhU0V+mhRgXK6uwiOG5IHyzydznXElPe8qeFIgi
         L1HuK4lnxhQvJyUFzvwH/KqsKWqVhiLIMn1FKBK0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xi Wang <wangxi11@huawei.com>,
        Weihang Li <liweihang@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 439/775] RDMA/hns: Add mapped page count checking for MTR
Date:   Mon,  1 Mar 2021 17:10:07 +0100
Message-Id: <20210301161223.255563273@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xi Wang <wangxi11@huawei.com>

[ Upstream commit 9ea9a53ea93be1cc66729ceb920f0d07285d6bfd ]

Add the mapped page count checking flow to avoid invalid page size when
creating MTR.

Fixes: 38389eaa4db1 ("RDMA/hns: Add mtr support for mixed multihop addressing")
Link: https://lore.kernel.org/r/1612517974-31867-4-git-send-email-liweihang@huawei.com
Signed-off-by: Xi Wang <wangxi11@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c |  9 ++--
 drivers/infiniband/hw/hns/hns_roce_mr.c  | 56 ++++++++++++++----------
 2 files changed, 40 insertions(+), 25 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index edc9d6b98d954..cfd2e1b60c7f0 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -1075,9 +1075,8 @@ static struct roce_hem_item *hem_list_alloc_item(struct hns_roce_dev *hr_dev,
 		return NULL;
 
 	if (exist_bt) {
-		hem->addr = dma_alloc_coherent(hr_dev->dev,
-						   count * BA_BYTE_LEN,
-						   &hem->dma_addr, GFP_KERNEL);
+		hem->addr = dma_alloc_coherent(hr_dev->dev, count * BA_BYTE_LEN,
+					       &hem->dma_addr, GFP_KERNEL);
 		if (!hem->addr) {
 			kfree(hem);
 			return NULL;
@@ -1336,6 +1335,10 @@ static int hem_list_alloc_root_bt(struct hns_roce_dev *hr_dev,
 	if (ba_num < 1)
 		return -ENOMEM;
 
+	if (ba_num > unit)
+		return -ENOBUFS;
+
+	ba_num = min_t(int, ba_num, unit);
 	INIT_LIST_HEAD(&temp_root);
 	offset = r->offset;
 	/* indicate to last region */
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index 1bcffd93ff3e3..1e0465f05b7da 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -631,30 +631,26 @@ int hns_roce_dealloc_mw(struct ib_mw *ibmw)
 }
 
 static int mtr_map_region(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
-			  dma_addr_t *pages, struct hns_roce_buf_region *region)
+			  struct hns_roce_buf_region *region, dma_addr_t *pages,
+			  int max_count)
 {
+	int count, npage;
+	int offset, end;
 	__le64 *mtts;
-	int offset;
-	int count;
-	int npage;
 	u64 addr;
-	int end;
 	int i;
 
-	/* if hopnum is 0, buffer cannot store BAs, so skip write mtt */
-	if (!region->hopnum)
-		return 0;
-
 	offset = region->offset;
 	end = offset + region->count;
 	npage = 0;
-	while (offset < end) {
+	while (offset < end && npage < max_count) {
+		count = 0;
 		mtts = hns_roce_hem_list_find_mtt(hr_dev, &mtr->hem_list,
 						  offset, &count, NULL);
 		if (!mtts)
 			return -ENOBUFS;
 
-		for (i = 0; i < count; i++) {
+		for (i = 0; i < count && npage < max_count; i++) {
 			if (hr_dev->hw_rev == HNS_ROCE_HW_VER1)
 				addr = to_hr_hw_page_addr(pages[npage]);
 			else
@@ -666,7 +662,7 @@ static int mtr_map_region(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 		offset += count;
 	}
 
-	return 0;
+	return npage;
 }
 
 static inline bool mtr_has_mtt(struct hns_roce_buf_attr *attr)
@@ -833,8 +829,8 @@ int hns_roce_mtr_map(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 {
 	struct ib_device *ibdev = &hr_dev->ib_dev;
 	struct hns_roce_buf_region *r;
-	unsigned int i;
-	int err;
+	unsigned int i, mapped_cnt;
+	int ret;
 
 	/*
 	 * Only use the first page address as root ba when hopnum is 0, this
@@ -845,26 +841,42 @@ int hns_roce_mtr_map(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
 		return 0;
 	}
 
-	for (i = 0; i < mtr->hem_cfg.region_count; i++) {
+	for (i = 0, mapped_cnt = 0; i < mtr->hem_cfg.region_count &&
+	     mapped_cnt < page_cnt; i++) {
 		r = &mtr->hem_cfg.region[i];
+		/* if hopnum is 0, no need to map pages in this region */
+		if (!r->hopnum) {
+			mapped_cnt += r->count;
+			continue;
+		}
+
 		if (r->offset + r->count > page_cnt) {
-			err = -EINVAL;
+			ret = -EINVAL;
 			ibdev_err(ibdev,
 				  "failed to check mtr%u end %u + %u, max %u.\n",
 				  i, r->offset, r->count, page_cnt);
-			return err;
+			return ret;
 		}
 
-		err = mtr_map_region(hr_dev, mtr, &pages[r->offset], r);
-		if (err) {
+		ret = mtr_map_region(hr_dev, mtr, r, &pages[r->offset],
+				     page_cnt - mapped_cnt);
+		if (ret < 0) {
 			ibdev_err(ibdev,
 				  "failed to map mtr%u offset %u, ret = %d.\n",
-				  i, r->offset, err);
-			return err;
+				  i, r->offset, ret);
+			return ret;
 		}
+		mapped_cnt += ret;
+		ret = 0;
 	}
 
-	return 0;
+	if (mapped_cnt < page_cnt) {
+		ret = -ENOBUFS;
+		ibdev_err(ibdev, "failed to map mtr pages count: %u < %u.\n",
+			  mapped_cnt, page_cnt);
+	}
+
+	return ret;
 }
 
 int hns_roce_mtr_find(struct hns_roce_dev *hr_dev, struct hns_roce_mtr *mtr,
-- 
2.27.0



