Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2534D1E2CDA
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392355AbgEZTR7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:17:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392004AbgEZTN5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:13:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 950E5208C3;
        Tue, 26 May 2020 19:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520437;
        bh=aE1R5VaeXY/7No8XOaYL5qSng5iIu55Y54sVmyyaUHE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UP2EUTK4B9XlJBT0JUfxvnE1SFU8npAcLciRhHZYraElh8gSQ/zjDkzUD9ReNzS3B
         T7lU3QmRvva5zHDu6qSF+tgA8kCVwm6Oyzs5iH8jy78PcwI8vW/OBYKfgGt5Crazwj
         vyrCXHzui19Y4byx+wsJbX6u37h8YHZ6Z/SJJQh8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sanjay Kumar <sanjay.k.kumar@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.6 080/126] dmaengine: idxd: fix interrupt completion after unmasking
Date:   Tue, 26 May 2020 20:53:37 +0200
Message-Id: <20200526183944.843946067@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
 drivers/dma/idxd/device.c |    7 +++++++
 drivers/dma/idxd/irq.c    |   26 +++++++++++++++++++-------
 2 files changed, 26 insertions(+), 7 deletions(-)

--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -62,6 +62,13 @@ int idxd_unmask_msix_vector(struct idxd_
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
 
--- a/drivers/dma/idxd/irq.c
+++ b/drivers/dma/idxd/irq.c
@@ -173,6 +173,7 @@ static int irq_process_pending_llist(str
 	struct llist_node *head;
 	int queued = 0;
 
+	*processed = 0;
 	head = llist_del_all(&irq_entry->pending_llist);
 	if (!head)
 		return 0;
@@ -197,6 +198,7 @@ static int irq_process_work_list(struct
 	struct list_head *node, *next;
 	int queued = 0;
 
+	*processed = 0;
 	if (list_empty(&irq_entry->work_list))
 		return 0;
 
@@ -218,10 +220,9 @@ static int irq_process_work_list(struct
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
@@ -244,15 +245,26 @@ irqreturn_t idxd_wq_thread(int irq, void
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


