Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B06F45BE4D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245064AbhKXMqQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:46:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345855AbhKXMoO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:44:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0FA2161221;
        Wed, 24 Nov 2021 12:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756773;
        bh=KOE7QOMhpEINvh2hGUqlrpZHncZ0wr/2/1qNtEkU/Xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LAMMZgnb7mmKQTE6zDaqXcKfkZNIExa8+nGBHd418EHbUehFFdJlDjrbRLolATxZW
         eYKg6D1iqpPoCdwhN5x9+gu1GIYItj/DSzxA9c/kszXFKZR9H4CGHPk+UlAOcSvvhR
         q43lC0H6a4zpi47/WL5MhQrzt2utlw+krXEsG+1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: [PATCH 4.14 201/251] PCI/MSI: Destroy sysfs before freeing entries
Date:   Wed, 24 Nov 2021 12:57:23 +0100
Message-Id: <20211124115717.252469172@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 3735459037114d31e5acd9894fad9aed104231a0 upstream.

free_msi_irqs() frees the MSI entries before destroying the sysfs entries
which are exposing them. Nothing prevents a concurrent free while a sysfs
file is read and accesses the possibly freed entry.

Move the sysfs release ahead of freeing the entries.

Fixes: 1c51b50c2995 ("PCI/MSI: Export MSI mode using attributes, not kobjects")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <helgaas@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/87sfw5305m.ffs@tglx
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/msi.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -372,18 +372,6 @@ static void free_msi_irqs(struct pci_dev
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
@@ -399,6 +387,18 @@ static void free_msi_irqs(struct pci_dev
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


