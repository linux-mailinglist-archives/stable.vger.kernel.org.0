Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3BEC27B9DC
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 03:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgI2BcG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 21:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:40914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727672AbgI2Bbm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Sep 2020 21:31:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C21D2075A;
        Tue, 29 Sep 2020 01:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601343087;
        bh=tZM0kI37tYwKys+Ekd2oBbRc2q4nSTPkupSZ2HLJKuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkVgj45s4cOGl3m9eVGZHza2KqdusgLjhk4FLtPHaewhPoBFbYi4FCd2v3keJGg6T
         8s5eXSMQD7cksEj4XuR4PaWqI+v3jii3E26VNZeLWQS7tI1X8P4lD5Of+CEKNPZagP
         sHb6RwfkwEQ9z1QXdBNgZmizGUe9uhJ1pVSh35Ao=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Xianting Tian <tian.xianting@h3c.com>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 17/18] nvme-pci: fix NULL req in completion handler
Date:   Mon, 28 Sep 2020 21:31:03 -0400
Message-Id: <20200929013105.2406634-17-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200929013105.2406634-1-sashal@kernel.org>
References: <20200929013105.2406634-1-sashal@kernel.org>
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
index a91433bdf5de4..fbfcded7a20d9 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -941,13 +941,6 @@ static inline void nvme_handle_cqe(struct nvme_queue *nvmeq, u16 idx)
 	volatile struct nvme_completion *cqe = &nvmeq->cqes[idx];
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

