Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFB971675B8
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:31:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732281AbgBUIas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:30:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52324 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733312AbgBUIPa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:15:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 117DA24680;
        Fri, 21 Feb 2020 08:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272929;
        bh=21U/1a7d6mQjvZS+p4suqgModgU1QDnOz+aloeZnv8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yxHamMdBjC8Wb7cQJxsCGvYyJHDi/XiUmO9+eMCsD5yOaVD6haI8aRxxNQk6obtf3
         TGoMKVBV/1wPYuDwsKHEa1cvZ/a39LKXKBUkLxbEhaGeoYNsEWPb/C0FLTBD+HIF45
         YKLgk9epfbfVWAKRM4vNxBXUNV+w/xCPntdEsenA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Edmund Nadolski <edmund.nadolski@intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 327/344] nvme-pci: remove nvmeq->tags
Date:   Fri, 21 Feb 2020 08:42:06 +0100
Message-Id: <20200221072419.956367258@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit cfa27356f835dc7755192e7b941d4f4851acbcc7 ]

There is no real need to have a pointer to the tagset in
struct nvme_queue, as we only need it in a single place, and that place
can derive the used tagset from the device and qid trivially.  This
fixes a problem with stale pointer exposure when tagsets are reset,
and also shrinks the nvme_queue structure.  It also matches what most
other transports have done since day 1.

Reported-by: Edmund Nadolski <edmund.nadolski@intel.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 14d513087a14b..f34a56d588d31 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -167,7 +167,6 @@ struct nvme_queue {
 	 /* only used for poll queues: */
 	spinlock_t cq_poll_lock ____cacheline_aligned_in_smp;
 	volatile struct nvme_completion *cqes;
-	struct blk_mq_tags **tags;
 	dma_addr_t sq_dma_addr;
 	dma_addr_t cq_dma_addr;
 	u32 __iomem *q_db;
@@ -377,29 +376,17 @@ static int nvme_admin_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
 
 	WARN_ON(hctx_idx != 0);
 	WARN_ON(dev->admin_tagset.tags[0] != hctx->tags);
-	WARN_ON(nvmeq->tags);
 
 	hctx->driver_data = nvmeq;
-	nvmeq->tags = &dev->admin_tagset.tags[0];
 	return 0;
 }
 
-static void nvme_admin_exit_hctx(struct blk_mq_hw_ctx *hctx, unsigned int hctx_idx)
-{
-	struct nvme_queue *nvmeq = hctx->driver_data;
-
-	nvmeq->tags = NULL;
-}
-
 static int nvme_init_hctx(struct blk_mq_hw_ctx *hctx, void *data,
 			  unsigned int hctx_idx)
 {
 	struct nvme_dev *dev = data;
 	struct nvme_queue *nvmeq = &dev->queues[hctx_idx + 1];
 
-	if (!nvmeq->tags)
-		nvmeq->tags = &dev->tagset.tags[hctx_idx];
-
 	WARN_ON(dev->tagset.tags[hctx_idx] != hctx->tags);
 	hctx->driver_data = nvmeq;
 	return 0;
@@ -950,6 +937,13 @@ static inline void nvme_ring_cq_doorbell(struct nvme_queue *nvmeq)
 		writel(head, nvmeq->q_db + nvmeq->dev->db_stride);
 }
 
+static inline struct blk_mq_tags *nvme_queue_tagset(struct nvme_queue *nvmeq)
+{
+	if (!nvmeq->qid)
+		return nvmeq->dev->admin_tagset.tags[0];
+	return nvmeq->dev->tagset.tags[nvmeq->qid - 1];
+}
+
 static inline void nvme_handle_cqe(struct nvme_queue *nvmeq, u16 idx)
 {
 	volatile struct nvme_completion *cqe = &nvmeq->cqes[idx];
@@ -975,7 +969,7 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq, u16 idx)
 		return;
 	}
 
-	req = blk_mq_tag_to_rq(*nvmeq->tags, cqe->command_id);
+	req = blk_mq_tag_to_rq(nvme_queue_tagset(nvmeq), cqe->command_id);
 	trace_nvme_sq(req, cqe->sq_head, nvmeq->sq_tail);
 	nvme_end_request(req, cqe->status, cqe->result);
 }
@@ -1578,7 +1572,6 @@ static const struct blk_mq_ops nvme_mq_admin_ops = {
 	.queue_rq	= nvme_queue_rq,
 	.complete	= nvme_pci_complete_rq,
 	.init_hctx	= nvme_admin_init_hctx,
-	.exit_hctx      = nvme_admin_exit_hctx,
 	.init_request	= nvme_init_request,
 	.timeout	= nvme_timeout,
 };
-- 
2.20.1



