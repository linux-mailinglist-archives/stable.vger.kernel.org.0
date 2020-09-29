Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D153327B982
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727562AbgI2BbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:31:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727410AbgI2BbB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:31:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF2EE216C4;
        Tue, 29 Sep 2020 01:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343060;
        bh=m8yyWdT17sxwA4pTD6kXD50OTjR8orcJ4BiXJpbqZAw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYkzoyBcyzw7/oUVGksf/HHaiD73FNOvm3M4iMhq3Jvj93XtB1v78jO9Hv5WTQMwL
         gxBQsgK2i5I/dzc/UorKlYJw8BBXMZ/1lzDeKPlXztD8LemyvW7866ZQDm9jTiYlvV
         IL5bvwzhdwhPZNrTMu7xQIocPmd6Eoc69hQrn2oA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xianting Tian <tian.xianting@h3c.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.8 26/29] nvme-pci: fix NULL req in completion handler
Date:   Mon, 28 Sep 2020 21:30:23 -0400
Message-Id: <20200929013027.2406344-26-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013027.2406344-1-sashal@kernel.org>
References: <20200929013027.2406344-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xianting Tian <tian.xianting@h3c.com>

[ Upstream commit 50b7c24390a53c78de546215282fb52980f1d7b7 ]

Currently, we use nvmeq->q_depth as the upper limit for a valid tag in
nvme_handle_cqe(), it is not correct. Because the available tag number
is recorded in tagset, which is not equal to nvmeq->q_depth.

The nvme driver registers interrupts for queues before initializing the
tagset, because it uses the number of successful request_irq() calls to
configure the tagset parameters. This allows a race condition with the
current tag validity check if the controller happens to produce an
interrupt with a corrupted CQE before the tagset is initialized.

Replace the driver's indirect tag check with the one already provided by
the block layer.

Signed-off-by: Xianting Tian <tian.xianting@h3c.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 90346cba87d1e..cc3ae9c63a01b 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -942,13 +942,6 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq, u16 idx)
 	struct nvme_completion *cqe = &nvmeq->cqes[idx];
 	struct request *req;
 
-	if (unlikely(cqe->command_id >= nvmeq->q_depth)) {
-		dev_warn(nvmeq->dev->ctrl.device,
-			"invalid id %d completed on queue %d\n",
-			cqe->command_id, le16_to_cpu(cqe->sq_id));
-		return;
-	}
-
 	/*
 	 * AEN requests are special as they don't time out and can
 	 * survive any kind of queue freeze and often don't respond to
@@ -962,6 +955,13 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq, u16 idx)
 	}
 
 	req = blk_mq_tag_to_rq(nvme_queue_tagset(nvmeq), cqe->command_id);
+	if (unlikely(!req)) {
+		dev_warn(nvmeq->dev->ctrl.device,
+			"invalid id %d completed on queue %d\n",
+			cqe->command_id, le16_to_cpu(cqe->sq_id));
+		return;
+	}
+
 	trace_nvme_sq(req, cqe->sq_head, nvmeq->sq_tail);
 	nvme_end_request(req, cqe->status, cqe->result);
 }
-- 
2.25.1

