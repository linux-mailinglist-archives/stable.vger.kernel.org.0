Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5D415EAFB
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 18:18:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391734AbgBNQLN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:11:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390995AbgBNQLM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 11:11:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CD66424697;
        Fri, 14 Feb 2020 16:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581696671;
        bh=21U/1a7d6mQjvZS+p4suqgModgU1QDnOz+aloeZnv8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BMkv1/1jGk4fi43Qg7AXjzOrRfUZ+4JlTtXBk1UGU1K4q7Vt61Cx6/vpudHigtK/+
         q4P4WxwibqqJ5AB2dUaZhE52bJrG/THNHb4TkrseLFN0waMx0enuL1G/oC1btZafcJ
         EyreEl+uLl3vWyaTsMFq+DmFGIyYVAIZ5HM0gcFQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Edmund Nadolski <edmund.nadolski@intel.com>,
        Keith Busch <kbusch@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 441/459] nvme-pci: remove nvmeq->tags
Date:   Fri, 14 Feb 2020 11:01:31 -0500
Message-Id: <20200214160149.11681-441-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214160149.11681-1-sashal@kernel.org>
References: <20200214160149.11681-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

