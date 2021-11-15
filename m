Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46734514DA
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 21:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349510AbhKOUOK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 15:14:10 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:46710 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347599AbhKOTkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Nov 2021 14:40:40 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1637005063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YPsM3HQSEslKJl3UBwlFSYmG+3f1PdRaG6swXObk6cI=;
        b=RtCxVMC/pOciEnfCcuj4UZg2cc0m9Bnp8coomjkfThH/PsSU2YakfVLgS28v6O1L3YUZyO
        /iPRkBrj8YzVHRhlEch5YeIW8h04CNQcPsH26FLcM/9OPM14oC+f/nvxcXXr1E2oTjJA+N
        jjlI7mWpuOXJQqfECillB2Ow7c6vpjLE7xnEOxpP3/e4lPq4fEKiwBJsK0ZQQYQTEt//Pa
        /VvH5ttxoN2Ll0z0tR5q1wxx+OKQQ2MjBfPcnbWEhDKd1r7JxmVUVL6wD1/MuXdN8HIs7i
        fz0tTSjxflMqmPAmwUHWeIsJnfW/ARoem4OR/LfRwZEMAEnwIjn+z8mVDoegdg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1637005063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YPsM3HQSEslKJl3UBwlFSYmG+3f1PdRaG6swXObk6cI=;
        b=3OxrEYe8w0bMRTXsmqDitDMzeYa0kE5TcbWt0izX1ID9lTS6x2h3v9gwmtJrevTb5BTb/h
        jAUjpCmEw/nIOGDw==
To:     gregkh@linuxfoundation.org, helgaas@kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v4.14y - v5.14y] PCI/MSI: Destroy sysfs before freeing entries
In-Reply-To: <163698010954101@kroah.com>
References: <163698010954101@kroah.com>
Date:   Mon, 15 Nov 2021 20:37:43 +0100
Message-ID: <87fsrx6whk.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 3735459037114d31e5acd9894fad9aed104231a0 uptream

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
Backport applies to 4.14.y up to 5.14.y series
---
 drivers/pci/msi.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -396,18 +396,6 @@ static void free_msi_irqs(struct pci_dev
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
-		free_msi_entry(entry);
-	}
-
 	if (dev->msi_irq_groups) {
 		sysfs_remove_groups(&dev->dev.kobj, dev->msi_irq_groups);
 		msi_attrs = dev->msi_irq_groups[0]->attrs;
@@ -423,6 +411,18 @@ static void free_msi_irqs(struct pci_dev
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
