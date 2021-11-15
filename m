Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EBE45049C
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 13:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230306AbhKOMpS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 07:45:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:38710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231466AbhKOMpM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 07:45:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 140C361A09;
        Mon, 15 Nov 2021 12:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636980130;
        bh=yKzIXTdgCvf/sQNJQm/bQxrdED1idICfk8ttqGjr5/o=;
        h=Subject:To:Cc:From:Date:From;
        b=DTv9MtNd6wxCv6cDptlCBUVH7X9JSzcCKCgiISqmCb5zuynAWdtTF7arx4utfqEEJ
         OyljLCHGQC6senarsuOhZeVSfA+XMcHeFfhZX0dFY8WFd7vaiNeS8kw/eyS4te3tHG
         pnvEZyVswtvlB0tCMCVEHdFILbLGR4mXURzwEYxc=
Subject: FAILED: patch "[PATCH] PCI/MSI: Destroy sysfs before freeing entries" failed to apply to 5.14-stable tree
To:     tglx@linutronix.de, gregkh@linuxfoundation.org, helgaas@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 15 Nov 2021 13:41:49 +0100
Message-ID: <163698010954101@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3735459037114d31e5acd9894fad9aed104231a0 Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Tue, 9 Nov 2021 14:53:57 +0100
Subject: [PATCH] PCI/MSI: Destroy sysfs before freeing entries

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

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 70433013897b..48e3f4e47b29 100644
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

