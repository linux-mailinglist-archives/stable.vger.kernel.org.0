Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E78A451E6A
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355126AbhKPAgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344933AbhKOTZo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:25:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20A41636F0;
        Mon, 15 Nov 2021 19:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003220;
        bh=FdiH5q11sennce85XOIysZy1InxD/XNoC9HkDhjdYV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dTmeCtwBHJF4Qs2+wvvdfR0cP1MOrNF8i0nO79WJ+tWzoDkmCG6uU6yhy8R+h6NGJ
         QDv1jbphhCT+2GQwtUiWDnVDEMDnMx58PgA/qq4BoiYY4aVVRYevR9iccGAsMTKTDw
         QNJszx5xVXsCAkmXysNHJQgCp84fXHZj1JmHPYb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <helgaas@kernel.org>
Subject: [PATCH 5.15 856/917] PCI/MSI: Destroy sysfs before freeing entries
Date:   Mon, 15 Nov 2021 18:05:51 +0100
Message-Id: <20211115165458.050938053@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
 drivers/pci/msi.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -368,6 +368,11 @@ static void free_msi_irqs(struct pci_dev
 			for (i = 0; i < entry->nvec_used; i++)
 				BUG_ON(irq_has_action(entry->irq + i));
 
+	if (dev->msi_irq_groups) {
+		msi_destroy_sysfs(&dev->dev, dev->msi_irq_groups);
+		dev->msi_irq_groups = NULL;
+	}
+
 	pci_msi_teardown_msi_irqs(dev);
 
 	list_for_each_entry_safe(entry, tmp, msi_list, list) {
@@ -379,11 +384,6 @@ static void free_msi_irqs(struct pci_dev
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


