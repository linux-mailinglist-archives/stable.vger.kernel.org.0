Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC95D169388
	for <lists+stable@lfdr.de>; Sun, 23 Feb 2020 03:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbgBWCXi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 21:23:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbgBWCXh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 21:23:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D818227BF;
        Sun, 23 Feb 2020 02:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582424617;
        bh=z6zUjYv03o/ZBQbMjsGF1EYgUSVBYR0phVp6qM4MZ/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FmVtGLUYOSd3nrpn2uBsGbCRQPrloEn1rbO9f2E1ZhpkxDgSL/2W9GLb5dF+4NPTV
         L/9JWpOD+vkalWxzjk5/2AZHI5hPEDcYlgB3Bl5oCIbP2XGifq3ewyXDmIqY56z8x3
         FRs+dy8KigGP/cerQkJrWYJ/Jj78UeMfdP3HRLSk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 50/50] nvme/pci: move cqe check after device shutdown
Date:   Sat, 22 Feb 2020 21:22:35 -0500
Message-Id: <20200223022235.1404-50-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200223022235.1404-1-sashal@kernel.org>
References: <20200223022235.1404-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit fa46c6fb5d61b1f17b06d7c6ef75478b576304c7 ]

Many users have reported nvme triggered irq_startup() warnings during
shutdown. The driver uses the nvme queue's irq to synchronize scanning
for completions, and enabling an interrupt affined to only offline CPUs
triggers the alarming warning.

Move the final CQE check to after disabling the device and all
registered interrupts have been torn down so that we do not have any
IRQ to synchronize.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206509
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 14d513087a14b..858805929b2cd 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1413,6 +1413,23 @@ static void nvme_disable_admin_queue(struct nvme_dev *dev, bool shutdown)
 	nvme_poll_irqdisable(nvmeq, -1);
 }
 
+/*
+ * Called only on a device that has been disabled and after all other threads
+ * that can check this device's completion queues have synced. This is the
+ * last chance for the driver to see a natural completion before
+ * nvme_cancel_request() terminates all incomplete requests.
+ */
+static void nvme_reap_pending_cqes(struct nvme_dev *dev)
+{
+	u16 start, end;
+	int i;
+
+	for (i = dev->ctrl.queue_count - 1; i > 0; i--) {
+		nvme_process_cq(&dev->queues[i], &start, &end, -1);
+		nvme_complete_cqes(&dev->queues[i], start, end);
+	}
+}
+
 static int nvme_cmb_qdepth(struct nvme_dev *dev, int nr_io_queues,
 				int entry_size)
 {
@@ -2248,11 +2265,6 @@ static bool __nvme_disable_io_queues(struct nvme_dev *dev, u8 opcode)
 		if (timeout == 0)
 			return false;
 
-		/* handle any remaining CQEs */
-		if (opcode == nvme_admin_delete_cq &&
-		    !test_bit(NVMEQ_DELETE_ERROR, &nvmeq->flags))
-			nvme_poll_irqdisable(nvmeq, -1);
-
 		sent--;
 		if (nr_queues)
 			goto retry;
@@ -2441,6 +2453,7 @@ static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown)
 	nvme_suspend_io_queues(dev);
 	nvme_suspend_queue(&dev->queues[0]);
 	nvme_pci_disable(dev);
+	nvme_reap_pending_cqes(dev);
 
 	blk_mq_tagset_busy_iter(&dev->tagset, nvme_cancel_request, &dev->ctrl);
 	blk_mq_tagset_busy_iter(&dev->admin_tagset, nvme_cancel_request, &dev->ctrl);
-- 
2.20.1

