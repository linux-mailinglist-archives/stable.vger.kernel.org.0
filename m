Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D57119103
	for <lists+stable@lfdr.de>; Thu,  9 May 2019 20:52:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727457AbfEISv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 May 2019 14:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:45862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728407AbfEISv6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 May 2019 14:51:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 69E3F217F5;
        Thu,  9 May 2019 18:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557427917;
        bh=EIj2AvKW7YazLOBX54kvYtEyz4pLnRNVIg9bEqWJRXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUp4VAxUiDJKT6IpFi0dVaQXYrJcDTg0TaE8HIZsJ4MiT5joNBRsuqgpvajAi8CY0
         m8lGmt9ixxwNeXa9MlA/+1aWYh7z8W6J4ygIPM1IQPClLKZ2E01iZX0jd4uPQc1Lac
         E1YrelWrtcexAgOBZus0xyRdpHVlfYfVl0NPM22c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, chenglang <chenglang@huawei.com>,
        Lijun Ou <oulijun@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 52/95] RDMA/hns: Fix bug that caused srq creation to fail
Date:   Thu,  9 May 2019 20:42:09 +0200
Message-Id: <20190509181313.138801659@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509181309.180685671@linuxfoundation.org>
References: <20190509181309.180685671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4772e03d239484f3461e33c79d721c8ea03f7416 ]

Due to the incorrect use of the seg and obj information, the position of
the mtt is calculated incorrectly, and the free space of the page is not
enough to store the entire mtt, resulting in access to the next page. This
patch fixes this problem.

 Unable to handle kernel paging request at virtual address ffff00006e3cd000
 ...
 Call trace:
  hns_roce_write_mtt+0x154/0x2f0 [hns_roce]
  hns_roce_buf_write_mtt+0xa8/0xd8 [hns_roce]
  hns_roce_create_srq+0x74c/0x808 [hns_roce]
  ib_create_srq+0x28/0xc8

Fixes: 0203b14c4f32 ("RDMA/hns: Unify the calculation for hem index in hip08")
Signed-off-by: chenglang <chenglang@huawei.com>
Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hem.c | 6 ++++--
 drivers/infiniband/hw/hns/hns_roce_mr.c  | 4 ++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hem.c b/drivers/infiniband/hw/hns/hns_roce_hem.c
index 4cdbcafa59155..cae23364cfea9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hem.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hem.c
@@ -763,6 +763,8 @@ void *hns_roce_table_find(struct hns_roce_dev *hr_dev,
 		idx_offset = (obj & (table->num_obj - 1)) % obj_per_chunk;
 		dma_offset = offset = idx_offset * table->obj_size;
 	} else {
+		u32 seg_size = 64; /* 8 bytes per BA and 8 BA per segment */
+
 		hns_roce_calc_hem_mhop(hr_dev, table, &mhop_obj, &mhop);
 		/* mtt mhop */
 		i = mhop.l0_idx;
@@ -774,8 +776,8 @@ void *hns_roce_table_find(struct hns_roce_dev *hr_dev,
 			hem_idx = i;
 
 		hem = table->hem[hem_idx];
-		dma_offset = offset = (obj & (table->num_obj - 1)) *
-				       table->obj_size % mhop.bt_chunk_size;
+		dma_offset = offset = (obj & (table->num_obj - 1)) * seg_size %
+				       mhop.bt_chunk_size;
 		if (mhop.hop_num == 2)
 			dma_offset = offset = 0;
 	}
diff --git a/drivers/infiniband/hw/hns/hns_roce_mr.c b/drivers/infiniband/hw/hns/hns_roce_mr.c
index ee5991bd4171c..dd4bb0ec6113b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_mr.c
+++ b/drivers/infiniband/hw/hns/hns_roce_mr.c
@@ -746,7 +746,6 @@ static int hns_roce_write_mtt_chunk(struct hns_roce_dev *hr_dev,
 	struct hns_roce_hem_table *table;
 	dma_addr_t dma_handle;
 	__le64 *mtts;
-	u32 s = start_index * sizeof(u64);
 	u32 bt_page_size;
 	u32 i;
 
@@ -780,7 +779,8 @@ static int hns_roce_write_mtt_chunk(struct hns_roce_dev *hr_dev,
 		return -EINVAL;
 
 	mtts = hns_roce_table_find(hr_dev, table,
-				mtt->first_seg + s / hr_dev->caps.mtt_entry_sz,
+				mtt->first_seg +
+				start_index / HNS_ROCE_MTT_ENTRY_PER_SEG,
 				&dma_handle);
 	if (!mtts)
 		return -ENOMEM;
-- 
2.20.1



