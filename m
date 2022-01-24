Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A15497D9D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 12:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237201AbiAXLIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 06:08:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40986 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234207AbiAXLIp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 06:08:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BFCF2612F1
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 11:08:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99086C340E1;
        Mon, 24 Jan 2022 11:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643022524;
        bh=ZJ2V5grDEC7YALfxWvsXeWAUFznVq1StTDg+FMP5XrQ=;
        h=Subject:To:Cc:From:Date:From;
        b=nvC+//gAEzHQnJbyshbc3tMxQ2qkPx9Vd+Xu7dhAsP6aguK9gN4iG+DxOPxwcdM9f
         xDEuWWzMx4skROM8shpJekoPWT94jhidZFXlUn1DuX233f3fBio5nLI5Cl2IpKZRyQ
         B7o26tXqhfOV70JkEPBiTexpYTqqRbRH3SXQRVeU=
Subject: FAILED: patch "[PATCH] dmaengine: idxd: fix descriptor flushing locking" failed to apply to 5.16-stable tree
To:     dave.jiang@intel.com, vkoul@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 12:08:30 +0100
Message-ID: <1643022510202240@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.16-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 23a50c8035655c5a1d9b52c878b3ebf7b6b83eea Mon Sep 17 00:00:00 2001
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 13 Dec 2021 11:51:29 -0700
Subject: [PATCH] dmaengine: idxd: fix descriptor flushing locking

The descriptor flushing for shutdown is not holding the irq_entry list
lock. If there's ongoing interrupt completion handling, this can corrupt
the list. Add locking to protect list walking. Also refactor the code so
it's more compact.

Fixes: 8f47d1a5e545 ("dmaengine: idxd: connect idxd to dmaengine subsystem")
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/163942148935.2412839.18282664745572777280.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 29c732a94027..03c735727f68 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -689,26 +689,28 @@ static int idxd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	return rc;
 }
 
-static void idxd_flush_pending_llist(struct idxd_irq_entry *ie)
+static void idxd_flush_pending_descs(struct idxd_irq_entry *ie)
 {
 	struct idxd_desc *desc, *itr;
 	struct llist_node *head;
+	LIST_HEAD(flist);
+	enum idxd_complete_type ctype;
 
+	spin_lock(&ie->list_lock);
 	head = llist_del_all(&ie->pending_llist);
-	if (!head)
-		return;
-
-	llist_for_each_entry_safe(desc, itr, head, llnode)
-		idxd_dma_complete_txd(desc, IDXD_COMPLETE_ABORT, true);
-}
+	if (head) {
+		llist_for_each_entry_safe(desc, itr, head, llnode)
+			list_add_tail(&desc->list, &ie->work_list);
+	}
 
-static void idxd_flush_work_list(struct idxd_irq_entry *ie)
-{
-	struct idxd_desc *desc, *iter;
+	list_for_each_entry_safe(desc, itr, &ie->work_list, list)
+		list_move_tail(&desc->list, &flist);
+	spin_unlock(&ie->list_lock);
 
-	list_for_each_entry_safe(desc, iter, &ie->work_list, list) {
+	list_for_each_entry_safe(desc, itr, &flist, list) {
 		list_del(&desc->list);
-		idxd_dma_complete_txd(desc, IDXD_COMPLETE_ABORT, true);
+		ctype = desc->completion->status ? IDXD_COMPLETE_NORMAL : IDXD_COMPLETE_ABORT;
+		idxd_dma_complete_txd(desc, ctype, true);
 	}
 }
 
@@ -762,8 +764,7 @@ static void idxd_shutdown(struct pci_dev *pdev)
 		synchronize_irq(irq_entry->vector);
 		if (i == 0)
 			continue;
-		idxd_flush_pending_llist(irq_entry);
-		idxd_flush_work_list(irq_entry);
+		idxd_flush_pending_descs(irq_entry);
 	}
 	flush_workqueue(idxd->wq);
 }

