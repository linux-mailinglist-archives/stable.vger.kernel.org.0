Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99773FA5A1
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:24:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbfKMBwO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 20:52:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:40714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728114AbfKMBwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:52:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 542C5204EC;
        Wed, 13 Nov 2019 01:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573609931;
        bh=6JY+c1jkFPre5uPRUf93f5KuCDr9J1UHHusxR0p6dnM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eqfFypNpCiFrqsq2qC6d4gTYQeU1F9ac3yL/I09pPJU2kYkoTXvqVWKMNHbCoYhKG
         3nqAldHnn1yc7HmTISwDYmXzfYOhV4CbW2BGAQ/qhtOAiyxGiSqrGn/z75WdMfybcX
         +Npv652rfXSgxLKLC2khLyXul51bCglWeBJGuTVM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijun Ou <oulijun@huawei.com>, Jason Gunthorpe <jgg@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 076/209] RDMA/hns: Limit the size of extend sge of sq
Date:   Tue, 12 Nov 2019 20:48:12 -0500
Message-Id: <20191113015025.9685-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b5150d7b953bd..2f091be7a7916 100644
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

