Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EB721F2D42
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbgFIAb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:31:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:36308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728520AbgFHXPX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ABA7C2076C;
        Mon,  8 Jun 2020 23:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658122;
        bh=/6Yym6/jbfvFrev0s9zJQ2WWMadt26Bf3Cl6vOMcbv8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SIz8AeGMU8C4IOQV66I3L+KYRVHggI96+wucJesvSfOvtN0gdzFw1p0JZkbsyBChw
         KiZ+D87xrWK2K18hCrcaDWtFcrx1SY4QqpWCDj2KOF91jxSdP63+nfxD8xRcAZVMzl
         DCA8fdLk4kGLJ35XFiTQeD1wDj8ct2mKWN3pbTvw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dave Jiang <dave.jiang@intel.com>,
        Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Vinod Koul <vkoul@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        dmaengine@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 159/606] dmaengine: idxd: fix interrupt completion after unmasking
Date:   Mon,  8 Jun 2020 19:04:44 -0400
Message-Id: <20200608231211.3363633-159-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dave Jiang <dave.jiang@intel.com>

commit 4f302642b70c1348773fe7e3ded9fc315fa92990 upstream.

The current implementation may miss completions after we unmask the
interrupt. In order to make sure we process all competions, we need to:
1. Do an MMIO read from the device as a barrier to ensure that all PCI
   writes for completions have arrived.
2. Check for any additional completions that we missed.

Fixes: 8f47d1a5e545 ("dmaengine: idxd: connect idxd to dmaengine subsystem")

Reported-by: Sanjay Kumar <sanjay.k.kumar@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/158834641769.35613.1341160109892008587.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/idxd/device.c |  7 +++++++
 drivers/dma/idxd/irq.c    | 26 +++++++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index f6f49f0f6fae..8d79a8787104 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -62,6 +62,13 @@ int idxd_unmask_msix_vector(struct idxd_device *idxd, int vec_id)
 	perm.ignore = 0;
 	iowrite32(perm.bits, idxd->reg_base + offset);
 
+	/*
+	 * A readback from the device ensures that any previously generated
+	 * completion record writes are visible to software based on PCI
+	 * ordering rules.
+	 */
+	perm.bits = ioread32(idxd->reg_base + offset);
+
 	return 0;
 }
 
diff --git a/drivers/dma/idxd/irq.c b/drivers/dma/idxd/irq.c
index d6fcd2e60103..6510791b9921 100644
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -173,6 +173,7 @@ static int irq_process_pending_llist(struct idxd_irq_entry *irq_entry,
 	struct llist_node *head;
 	int queued = 0;
 
+	*processed = 0;
 	head = llist_del_all(&irq_entry->pending_llist);
 	if (!head)
 		return 0;
@@ -197,6 +198,7 @@ static int irq_process_work_list(struct idxd_irq_entry *irq_entry,
 	struct list_head *node, *next;
 	int queued = 0;
 
+	*processed = 0;
 	if (list_empty(&irq_entry->work_list))
 		return 0;
 
@@ -218,10 +220,9 @@ static int irq_process_work_list(struct idxd_irq_entry *irq_entry,
 	return queued;
 }
 
-irqreturn_t idxd_wq_thread(int irq, void *data)
+static int idxd_desc_process(struct idxd_irq_entry *irq_entry)
 {
-	struct idxd_irq_entry *irq_entry = data;
-	int rc, processed = 0, retry = 0;
+	int rc, processed, total = 0;
 
 	/*
 	 * There are two lists we are processing. The pending_llist is where
@@ -244,15 +245,26 @@ irqreturn_t idxd_wq_thread(int irq, void *data)
 	 */
 	do {
 		rc = irq_process_work_list(irq_entry, &processed);
-		if (rc != 0) {
-			retry++;
+		total += processed;
+		if (rc != 0)
 			continue;
-		}
 
 		rc = irq_process_pending_llist(irq_entry, &processed);
-	} while (rc != 0 && retry != 10);
+		total += processed;
+	} while (rc != 0);
+
+	return total;
+}
+
+irqreturn_t idxd_wq_thread(int irq, void *data)
+{
+	struct idxd_irq_entry *irq_entry = data;
+	int processed;
 
+	processed = idxd_desc_process(irq_entry);
 	idxd_unmask_msix_vector(irq_entry->idxd, irq_entry->id);
+	/* catch anything unprocessed after unmasking */
+	processed += idxd_desc_process(irq_entry);
 
 	if (processed == 0)
 		return IRQ_NONE;
-- 
2.25.1

