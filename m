Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29AA2142CF1
	for <lists+stable@lfdr.de>; Mon, 20 Jan 2020 15:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgATOKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jan 2020 09:10:36 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:37767 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbgATOKg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jan 2020 09:10:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1579529436; x=1611065436;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tMbR+zwbnwrqNj/5R4nACUpuaJ5wbu5W2LdSuFKO3PQ=;
  b=sWk7okqp9slqb7277FYzoaH3lZ39AJdmck0F3FPRVFnY+emYp8m/G1iy
   811pcHQ7OGbG65cS0Bnju8lq6c0elTp0udJQRnKlE+m1i1DCY8jPisSQV
   uFbiQP5hjus47sYq8DTI0OHgdecyq1wFq/V4bWyirMJHztRI3iaLAx/ai
   c=;
IronPort-SDR: 0vMI7DALfS8A11eBAz4vK76mSO0WXJBE2HJPmQiNdxasLYcwEp4rPfD6ZCvyXFTSbhD8DPZCV5
 63lQIXI0l3Tg==
X-IronPort-AV: E=Sophos;i="5.70,342,1574121600"; 
   d="scan'208";a="11371564"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 20 Jan 2020 14:10:25 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-6f38efd9.us-west-2.amazon.com (Postfix) with ESMTPS id AA9D1A206E;
        Mon, 20 Jan 2020 14:10:24 +0000 (UTC)
Received: from EX13D02EUC003.ant.amazon.com (10.43.164.10) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Mon, 20 Jan 2020 14:10:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (10.43.161.207) by
 EX13D02EUC003.ant.amazon.com (10.43.164.10) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Mon, 20 Jan 2020 14:10:22 +0000
Received: from 8c85908914bf.ant.amazon.com.com (10.218.69.131) by
 mail-relay.amazon.com (10.43.161.249) with Microsoft SMTP Server id
 15.0.1367.3 via Frontend Transport; Mon, 20 Jan 2020 14:10:19 +0000
From:   Gal Pressman <galpress@amazon.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Doug Ledford <dledford@redhat.com>
CC:     <linux-rdma@vger.kernel.org>,
        Alexander Matushevsky <matua@amazon.com>,
        Gal Pressman <galpress@amazon.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        <stable@vger.kernel.org>
Subject: [PATCH for-rc] Revert "RDMA/efa: Use API to get contiguous memory blocks aligned to device supported page size"
Date:   Mon, 20 Jan 2020 16:10:01 +0200
Message-ID: <20200120141001.63544-1-galpress@amazon.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The cited commit leads to register MR failures and random hangs when
running different MPI applications. The exact root cause for the issue
is still not clear, this revert brings us back to a stable state.

This reverts commit 40ddb3f020834f9afb7aab31385994811f4db259.

Fixes: 40ddb3f02083 ("RDMA/efa: Use API to get contiguous memory blocks aligned to device supported page size")
Cc: Shiraz Saleem <shiraz.saleem@intel.com>
Cc: stable@vger.kernel.org # 5.3
Signed-off-by: Gal Pressman <galpress@amazon.com>
---
 drivers/infiniband/hw/efa/efa_verbs.c | 88 ++++++++++++++++++++-------
 1 file changed, 67 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 50c22575aed6..567797a919e8 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -1005,15 +1005,21 @@ static int umem_to_page_list(struct efa_dev *dev,
 			     u8 hp_shift)
 {
 	u32 pages_in_hp = BIT(hp_shift - PAGE_SHIFT);
-	struct ib_block_iter biter;
+	struct sg_dma_page_iter sg_iter;
+	unsigned int page_idx = 0;
 	unsigned int hp_idx = 0;
 
 	ibdev_dbg(&dev->ibdev, "hp_cnt[%u], pages_in_hp[%u]\n",
 		  hp_cnt, pages_in_hp);
 
-	rdma_for_each_block(umem->sg_head.sgl, &biter, umem->nmap,
-			    BIT(hp_shift))
-		page_list[hp_idx++] = rdma_block_iter_dma_address(&biter);
+	for_each_sg_dma_page(umem->sg_head.sgl, &sg_iter, umem->nmap, 0) {
+		if (page_idx % pages_in_hp == 0) {
+			page_list[hp_idx] = sg_page_iter_dma_address(&sg_iter);
+			hp_idx++;
+		}
+
+		page_idx++;
+	}
 
 	return 0;
 }
@@ -1344,6 +1350,56 @@ static int efa_create_pbl(struct efa_dev *dev,
 	return 0;
 }
 
+static void efa_cont_pages(struct ib_umem *umem, u64 addr,
+			   unsigned long max_page_shift,
+			   int *count, u8 *shift, u32 *ncont)
+{
+	struct scatterlist *sg;
+	u64 base = ~0, p = 0;
+	unsigned long tmp;
+	unsigned long m;
+	u64 len, pfn;
+	int i = 0;
+	int entry;
+
+	addr = addr >> PAGE_SHIFT;
+	tmp = (unsigned long)addr;
+	m = find_first_bit(&tmp, BITS_PER_LONG);
+	if (max_page_shift)
+		m = min_t(unsigned long, max_page_shift - PAGE_SHIFT, m);
+
+	for_each_sg(umem->sg_head.sgl, sg, umem->nmap, entry) {
+		len = DIV_ROUND_UP(sg_dma_len(sg), PAGE_SIZE);
+		pfn = sg_dma_address(sg) >> PAGE_SHIFT;
+		if (base + p != pfn) {
+			/*
+			 * If either the offset or the new
+			 * base are unaligned update m
+			 */
+			tmp = (unsigned long)(pfn | p);
+			if (!IS_ALIGNED(tmp, 1 << m))
+				m = find_first_bit(&tmp, BITS_PER_LONG);
+
+			base = pfn;
+			p = 0;
+		}
+
+		p += len;
+		i += len;
+	}
+
+	if (i) {
+		m = min_t(unsigned long, ilog2(roundup_pow_of_two(i)), m);
+		*ncont = DIV_ROUND_UP(i, (1 << m));
+	} else {
+		m = 0;
+		*ncont = 0;
+	}
+
+	*shift = PAGE_SHIFT + m;
+	*count = i;
+}
+
 struct ib_mr *efa_reg_mr(struct ib_pd *ibpd, u64 start, u64 length,
 			 u64 virt_addr, int access_flags,
 			 struct ib_udata *udata)
@@ -1351,11 +1407,12 @@ struct ib_mr *efa_reg_mr(struct ib_pd *ibpd, u64 start, u64 length,
 	struct efa_dev *dev = to_edev(ibpd->device);
 	struct efa_com_reg_mr_params params = {};
 	struct efa_com_reg_mr_result result = {};
+	unsigned long max_page_shift;
 	struct pbl_context pbl;
 	int supp_access_flags;
-	unsigned int pg_sz;
 	struct efa_mr *mr;
 	int inline_size;
+	int npages;
 	int err;
 
 	if (udata->inlen &&
@@ -1396,24 +1453,13 @@ struct ib_mr *efa_reg_mr(struct ib_pd *ibpd, u64 start, u64 length,
 	params.iova = virt_addr;
 	params.mr_length_in_bytes = length;
 	params.permissions = access_flags;
+	max_page_shift = fls64(dev->dev_attr.page_size_cap);
 
-	pg_sz = ib_umem_find_best_pgsz(mr->umem,
-				       dev->dev_attr.page_size_cap,
-				       virt_addr);
-	if (!pg_sz) {
-		err = -EOPNOTSUPP;
-		ibdev_dbg(&dev->ibdev, "Failed to find a suitable page size in page_size_cap %#llx\n",
-			  dev->dev_attr.page_size_cap);
-		goto err_unmap;
-	}
-
-	params.page_shift = __ffs(pg_sz);
-	params.page_num = DIV_ROUND_UP(length + (start & (pg_sz - 1)),
-				       pg_sz);
-
+	efa_cont_pages(mr->umem, start, max_page_shift, &npages,
+		       &params.page_shift, &params.page_num);
 	ibdev_dbg(&dev->ibdev,
-		  "start %#llx length %#llx params.page_shift %u params.page_num %u\n",
-		  start, length, params.page_shift, params.page_num);
+		  "start %#llx length %#llx npages %d params.page_shift %u params.page_num %u\n",
+		  start, length, npages, params.page_shift, params.page_num);
 
 	inline_size = ARRAY_SIZE(params.pbl.inline_pbl_array);
 	if (params.page_num <= inline_size) {
-- 
2.24.1

