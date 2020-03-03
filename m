Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAC99177F1D
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 19:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731624AbgCCRst (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 12:48:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731672AbgCCRsr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 12:48:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1685320870;
        Tue,  3 Mar 2020 17:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583257726;
        bh=h8NmjxNAA6sNUld5Zi/eWJX1DH9dYR8b7OV6seT5V/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0kn5d5Nre4rWm3MdZKjpsaDN4m5yPiw0hZopWVufet61NcbXzPjK4gRg5taxEnm4L
         EWXvIM/4xwACn2XKecxjHr/f3xklSqPVEDcnjP1y0ISt8Mw3iD/i4A6t3W8KZ3/VDN
         288qvSaDHCol60wT1Ka5CXE/BCjYWarkULfXiPCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 080/176] nvme/pci: move cqe check after device shutdown
Date:   Tue,  3 Mar 2020 18:42:24 +0100
Message-Id: <20200303174313.900188561@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174304.593872177@linuxfoundation.org>
References: <20200303174304.593872177@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index da392b50f73e7..9c80f9f081496 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1401,6 +1401,23 @@ static void nvme_disable_admin_queue(struct nvme_dev *dev, bool shutdown)
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
@@ -2235,11 +2252,6 @@ static bool __nvme_disable_io_queues(struct nvme_dev *dev, u8 opcode)
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
@@ -2428,6 +2440,7 @@ static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown)
 	nvme_suspend_io_queues(dev);
 	nvme_suspend_queue(&dev->queues[0]);
 	nvme_pci_disable(dev);
+	nvme_reap_pending_cqes(dev);
 
 	blk_mq_tagset_busy_iter(&dev->tagset, nvme_cancel_request, &dev->ctrl);
 	blk_mq_tagset_busy_iter(&dev->admin_tagset, nvme_cancel_request, &dev->ctrl);
-- 
2.20.1



