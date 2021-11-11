Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEE144D397
	for <lists+stable@lfdr.de>; Thu, 11 Nov 2021 09:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhKKJAh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Nov 2021 04:00:37 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:48230 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbhKKJAh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Nov 2021 04:00:37 -0500
Date:   Thu, 11 Nov 2021 08:57:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636621067;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DbcwKz3W3qN9osp6n/72imrTqJ43KA0UAlr6lcDjls0=;
        b=ATev9VUTGEhsUSCsAKfnGbjk6v5rkVse1ZynDcR6smx4PuH745NPk6Rj3nvtvajz0NiCon
        l5EuXWxIxyqtLsDkJkyaxrw93YBFvifpu247JEkMunneeaZL/6GBlYZjbmV31g973dcBPX
        I0ZtXa4YCQo65NygwueJ155RHtjOs+teu38UzTryhiHCErXaO/5Jzt9I44JC5dR0m4Tp+F
        eQDbnK0DkxTVz0IbNWdoQV/8+Sla6wQvEyCfV3DlZSXNZTEQu26ie2ZP5rk69pgfvjyqKg
        qmQtXTRuP4RZpIqX5x4wrAZLt24ACFLRPsUy7+3AD/NdPKZwiPq7urdB06DSuQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636621067;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DbcwKz3W3qN9osp6n/72imrTqJ43KA0UAlr6lcDjls0=;
        b=VPENRKzIanxu8WC9rVuWg1Cze5LR+qGyPazoK3VVYpA/vwZxzp+7gXCNSWbUXFS1F2GzB2
        wqmIaXw5tuIhoADw==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] PCI/MSI: Destroy sysfs before freeing entries
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <helgaas@kernel.org>, stable@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, maz@kernel.org
In-Reply-To: <87sfw5305m.ffs@tglx>
References: <87sfw5305m.ffs@tglx>
MIME-Version: 1.0
Message-ID: <163662106535.414.10271441206287447086.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     3735459037114d31e5acd9894fad9aed104231a0
Gitweb:        https://git.kernel.org/tip/3735459037114d31e5acd9894fad9aed104231a0
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Tue, 09 Nov 2021 14:53:57 +01:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 11 Nov 2021 09:50:31 +01:00

PCI/MSI: Destroy sysfs before freeing entries

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

---
 drivers/pci/msi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 7043301..48e3f4e 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -368,6 +368,11 @@ static void free_msi_irqs(struct pci_dev *dev)
 			for (i = 0; i < entry->nvec_used; i++)
 				BUG_ON(irq_has_action(entry->irq + i));
 
+	if (dev->msi_irq_groups) {
+		msi_destroy_sysfs(&dev->dev, dev->msi_irq_groups);
+		dev->msi_irq_groups = NULL;
+	}
+
 	pci_msi_teardown_msi_irqs(dev);
 
 	list_for_each_entry_safe(entry, tmp, msi_list, list) {
@@ -379,11 +384,6 @@ static void free_msi_irqs(struct pci_dev *dev)
 		list_del(&entry->list);
 		free_msi_entry(entry);
 	}
-
-	if (dev->msi_irq_groups) {
-		msi_destroy_sysfs(&dev->dev, dev->msi_irq_groups);
-		dev->msi_irq_groups = NULL;
-	}
 }
 
 static void pci_intx_for_msi(struct pci_dev *dev, int enable)
