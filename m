Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F00AF106D61
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730587AbfKVK7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:59:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:50984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730921AbfKVK7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:59:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BDD0A20721;
        Fri, 22 Nov 2019 10:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420380;
        bh=c86+t2Pau/6rMXsnImuEiH8ZWVcRyQ28R/oiS7P5xNo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2ZiwikPT/6IamcqPelHTtFLwvCaOW/E8iaL66lgXObspLeyENz+PQClDsmusxgY37
         BkqFzVSiQKrGTQX9YM7ZxLeBiZjofzZ4eFpEzeH40T95qJs9qRhQ+L+1lhttMpK7SO
         1KlFo8HkZ4TThZZyk9WAS7cczy6DOVP3+MjKiY2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lijun Ou <oulijun@huawei.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/220] RDMA/hns: Limit the size of extend sge of sq
Date:   Fri, 22 Nov 2019 11:27:33 +0100
Message-Id: <20191122100918.939448112@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lijun Ou <oulijun@huawei.com>

[ Upstream commit 05ad5482a5904c416bcfd74afd7193e206e563ce ]

The hip08 split two hardware version. The version id are 0x20 and 0x21
according to the PCI revison. The max size of extend sge of sq is limited
to 2M for 0x20 version and 8M for 0x21 version. It may be exceeded to 2M
according to the algorithm that compute the product of wqe count and
extend sge number of every wqe. But the product always less than 8M.

Signed-off-by: Lijun Ou <oulijun@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_device.h |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c  |  1 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h  |  1 +
 drivers/infiniband/hw/hns/hns_roce_qp.c     | 19 +++++++++++++++++++
 4 files changed, 22 insertions(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_device.h b/drivers/infiniband/hw/hns/hns_roce_device.h
index 0bf9949842177..ebfb0998bcedb 100644
--- a/drivers/infiniband/hw/hns/hns_roce_device.h
+++ b/drivers/infiniband/hw/hns/hns_roce_device.h
@@ -665,6 +665,7 @@ struct hns_roce_caps {
 	u32		max_sq_sg;	/* 2 */
 	u32		max_sq_inline;	/* 32 */
 	u32		max_rq_sg;	/* 2 */
+	u32		max_extend_sg;
 	int		num_qps;	/* 256k */
 	int             reserved_qps;
 	u32		max_wqes;	/* 16k */
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 7a7232927b126..9e7923cf85773 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -1194,6 +1194,7 @@ static int hns_roce_v2_profile(struct hns_roce_dev *hr_dev)
 	caps->num_cqs		= HNS_ROCE_V2_MAX_CQ_NUM;
 	caps->max_cqes		= HNS_ROCE_V2_MAX_CQE_NUM;
 	caps->max_sq_sg		= HNS_ROCE_V2_MAX_SQ_SGE_NUM;
+	caps->max_extend_sg	= HNS_ROCE_V2_MAX_EXTEND_SGE_NUM;
 	caps->max_rq_sg		= HNS_ROCE_V2_MAX_RQ_SGE_NUM;
 	caps->max_sq_inline	= HNS_ROCE_V2_MAX_SQ_INLINE;
 	caps->num_uars		= HNS_ROCE_V2_UAR_NUM;
diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
index cd276b0b16471..2c3e600db9ce7 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.h
@@ -50,6 +50,7 @@
 #define HNS_ROCE_V2_MAX_CQE_NUM			0x10000
 #define HNS_ROCE_V2_MAX_RQ_SGE_NUM		0x100
 #define HNS_ROCE_V2_MAX_SQ_SGE_NUM		0xff
+#define HNS_ROCE_V2_MAX_EXTEND_SGE_NUM		0x200000
 #define HNS_ROCE_V2_MAX_SQ_INLINE		0x20
 #define HNS_ROCE_V2_UAR_NUM			256
 #define HNS_ROCE_V2_PHY_UAR_NUM			1
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index cb926ced40219..54d22868ffba5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -31,6 +31,7 @@
  * SOFTWARE.
  */
 
+#include <linux/pci.h>
 #include <linux/platform_device.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_umem.h>
@@ -372,6 +373,16 @@ static int hns_roce_set_user_sq_size(struct hns_roce_dev *hr_dev,
 	if (hr_qp->sq.max_gs > 2)
 		hr_qp->sge.sge_cnt = roundup_pow_of_two(hr_qp->sq.wqe_cnt *
 							(hr_qp->sq.max_gs - 2));
+
+	if ((hr_qp->sq.max_gs > 2) && (hr_dev->pci_dev->revision == 0x20)) {
+		if (hr_qp->sge.sge_cnt > hr_dev->caps.max_extend_sg) {
+			dev_err(hr_dev->dev,
+				"The extended sge cnt error! sge_cnt=%d\n",
+				hr_qp->sge.sge_cnt);
+			return -EINVAL;
+		}
+	}
+
 	hr_qp->sge.sge_shift = 4;
 
 	/* Get buf size, SQ and RQ  are aligned to page_szie */
@@ -465,6 +476,14 @@ static int hns_roce_set_kernel_sq_size(struct hns_roce_dev *hr_dev,
 		hr_qp->sge.sge_shift = 4;
 	}
 
+	if ((hr_qp->sq.max_gs > 2) && hr_dev->pci_dev->revision == 0x20) {
+		if (hr_qp->sge.sge_cnt > hr_dev->caps.max_extend_sg) {
+			dev_err(dev, "The extended sge cnt error! sge_cnt=%d\n",
+				hr_qp->sge.sge_cnt);
+			return -EINVAL;
+		}
+	}
+
 	/* Get buf size, SQ and RQ are aligned to PAGE_SIZE */
 	page_size = 1 << (hr_dev->caps.mtt_buf_pg_sz + PAGE_SHIFT);
 	hr_qp->sq.offset = 0;
-- 
2.20.1



