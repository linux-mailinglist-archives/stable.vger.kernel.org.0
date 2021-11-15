Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D39B4514DB
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349523AbhKOUOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:14:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347704AbhKOTmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 14:42:11 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9354DC061570
        for <stable@vger.kernel.org>; Mon, 15 Nov 2021 11:39:07 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637005144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XJO9gYoGt5mqSuwIa/rnHndt5xv5oBcPMqCdD5jxpG4=;
        b=uMMVPt+gsJVV9y2favUb3AZsOv5Ab5bNv1Fo2JnSAYGWhF+c6G7xo6tvyKFImhJ0hiFa3R
        nakOZgPvwKXVPjsOPyeavOXub8FD/5maHUi8niihDLUmfk6f1T0SLxoXj8G8zJ2ONd4aG3
        3GmFOfFi22kvGWgCBuESSbpL/xxU9+HMqYyhOsdOOlq+3gLt+JX8JXoimnWAeEW1XwVOG3
        ncn/8fzUUUMsA/tDYCN98Jdx1ArbYAg6SJk4DwHbBjwyLwj0k1Caz+yLzLna1ylk3ScJIJ
        5hETqet2JlxtfBM8J4ig3/RwSojv2DvQImo1h1d7fHJG1w4BVs/3qTb5eQ1ikw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637005144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XJO9gYoGt5mqSuwIa/rnHndt5xv5oBcPMqCdD5jxpG4=;
        b=JQ+LDqWGArL3TfM8ZlHRzcAaUAiWaL2nwVzwU/yaTtwEZIXmS0Rn+3oIcBDolbaAmcziwk
        sEt1/KlprvlOanBw==
To:     gregkh@linuxfoundation.org, helgaas@kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v4.4.y - v4.9.y] PCI/MSI: Destroy sysfs before freeing entries
In-Reply-To: <163698010742166@kroah.com>
References: <163698010742166@kroah.com>
Date:   Mon, 15 Nov 2021 20:39:04 +0100
Message-ID: <87czn16wfb.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 3735459037114d31e5acd9894fad9aed104231a0 upstream.

free_msi_irqs() frees the MSI entries before destroying the sysfs entries
which are exposing them. Nothing prevents a concurrent free while a sysfs
file is read and accesses the possibly freed entry.

Move the sysfs release ahead of freeing the entries.

Fixes: 1c51b50c2995 ("PCI/MSI: Export MSI mode using attributes, not kobjects")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87sfw5305m.ffs@tglx
---
Backport v4.4.y and v4.9.y
---
 drivers/pci/msi.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -390,18 +390,6 @@ static void free_msi_irqs(struct pci_dev
 			for (i = 0; i < entry->nvec_used; i++)
 				BUG_ON(irq_has_action(entry->irq + i));
 
-	pci_msi_teardown_msi_irqs(dev);
-
-	list_for_each_entry_safe(entry, tmp, msi_list, list) {
-		if (entry->msi_attrib.is_msix) {
-			if (list_is_last(&entry->list, msi_list))
-				iounmap(entry->mask_base);
-		}
-
-		list_del(&entry->list);
-		kfree(entry);
-	}
-
 	if (dev->msi_irq_groups) {
 		sysfs_remove_groups(&dev->dev.kobj, dev->msi_irq_groups);
 		msi_attrs = dev->msi_irq_groups[0]->attrs;
@@ -417,6 +405,18 @@ static void free_msi_irqs(struct pci_dev
 		kfree(dev->msi_irq_groups);
 		dev->msi_irq_groups = NULL;
 	}
+
+	pci_msi_teardown_msi_irqs(dev);
+
+	list_for_each_entry_safe(entry, tmp, msi_list, list) {
+		if (entry->msi_attrib.is_msix) {
+			if (list_is_last(&entry->list, msi_list))
+				iounmap(entry->mask_base);
+		}
+
+		list_del(&entry->list);
+		free_msi_entry(entry);
+	}
 }
 
 static void pci_intx_for_msi(struct pci_dev *dev, int enable)
