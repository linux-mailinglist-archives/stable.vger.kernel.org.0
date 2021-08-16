Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111F13ED014
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 10:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhHPIPx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 04:15:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:42196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234525AbhHPIPw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 04:15:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0E7B261AFB;
        Mon, 16 Aug 2021 08:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629101721;
        bh=3ic8+kZeuku3Se6T3jugyqPlML6h42K+Ef04JwpyKj0=;
        h=Subject:To:Cc:From:Date:From;
        b=kgMxu6YPL6gvL36vFJKlxIykNn7F8iFfHiVTmVNhEFd3KkfeNYYVgSp7BCs9i9RhW
         wudgI760J12HOW2AGuOGgVYUxIae+Ih8IKJE1m3GWsiT+ILhk4QY62vOLIrWjEvWr0
         SxNLypujNgMLUl4GjUK88rq6B9CEDsi/F7OdtfiA=
Subject: FAILED: patch "[PATCH] PCI/MSI: Mask all unused MSI-X entries" failed to apply to 4.14-stable tree
To:     tglx@linutronix.de, bhelgaas@google.com, maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 Aug 2021 10:15:15 +0200
Message-ID: <16291017154199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 7d5ec3d3612396dc6d4b76366d20ab9fc06f399f Mon Sep 17 00:00:00 2001
From: Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 29 Jul 2021 23:51:41 +0200
Subject: [PATCH] PCI/MSI: Mask all unused MSI-X entries

When MSI-X is enabled the ordering of calls is:

  msix_map_region();
  msix_setup_entries();
  pci_msi_setup_msi_irqs();
  msix_program_entries();

This has a few interesting issues:

 1) msix_setup_entries() allocates the MSI descriptors and initializes them
    except for the msi_desc:masked member which is left zero initialized.

 2) pci_msi_setup_msi_irqs() allocates the interrupt descriptors and sets
    up the MSI interrupts which ends up in pci_write_msi_msg() unless the
    interrupt chip provides its own irq_write_msi_msg() function.

 3) msix_program_entries() does not do what the name suggests. It solely
    updates the entries array (if not NULL) and initializes the masked
    member for each MSI descriptor by reading the hardware state and then
    masks the entry.

Obviously this has some issues:

 1) The uninitialized masked member of msi_desc prevents the enforcement
    of masking the entry in pci_write_msi_msg() depending on the cached
    masked bit. Aside of that half initialized data is a NONO in general

 2) msix_program_entries() only ensures that the actually allocated entries
    are masked. This is wrong as experimentation with crash testing and
    crash kernel kexec has shown.

    This limited testing unearthed that when the production kernel had more
    entries in use and unmasked when it crashed and the crash kernel
    allocated a smaller amount of entries, then a full scan of all entries
    found unmasked entries which were in use in the production kernel.

    This is obviously a device or emulation issue as the device reset
    should mask all MSI-X table entries, but obviously that's just part
    of the paper specification.

Cure this by:

 1) Masking all table entries in hardware
 2) Initializing msi_desc::masked in msix_setup_entries()
 3) Removing the mask dance in msix_program_entries()
 4) Renaming msix_program_entries() to msix_update_entries() to
    reflect the purpose of that function.

As the masking of unused entries has never been done the Fixes tag refers
to a commit in:
   git://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git

Fixes: f036d4ea5fa7 ("[PATCH] ia32 Message Signalled Interrupt support")
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210729222542.403833459@linutronix.de

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 5d39ed828085..57c9ec9b976b 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -691,6 +691,7 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 {
 	struct irq_affinity_desc *curmsk, *masks = NULL;
 	struct msi_desc *entry;
+	void __iomem *addr;
 	int ret, i;
 	int vec_count = pci_msix_vec_count(dev);
 
@@ -711,6 +712,7 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 
 		entry->msi_attrib.is_msix	= 1;
 		entry->msi_attrib.is_64		= 1;
+
 		if (entries)
 			entry->msi_attrib.entry_nr = entries[i].entry;
 		else
@@ -722,6 +724,10 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 		entry->msi_attrib.default_irq	= dev->irq;
 		entry->mask_base		= base;
 
+		addr = pci_msix_desc_addr(entry);
+		if (addr)
+			entry->masked = readl(addr + PCI_MSIX_ENTRY_VECTOR_CTRL);
+
 		list_add_tail(&entry->list, dev_to_msi_list(&dev->dev));
 		if (masks)
 			curmsk++;
@@ -732,26 +738,25 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 	return ret;
 }
 
-static void msix_program_entries(struct pci_dev *dev,
-				 struct msix_entry *entries)
+static void msix_update_entries(struct pci_dev *dev, struct msix_entry *entries)
 {
 	struct msi_desc *entry;
-	int i = 0;
-	void __iomem *desc_addr;
 
 	for_each_pci_msi_entry(entry, dev) {
-		if (entries)
-			entries[i++].vector = entry->irq;
+		if (entries) {
+			entries->vector = entry->irq;
+			entries++;
+		}
+	}
+}
 
-		desc_addr = pci_msix_desc_addr(entry);
-		if (desc_addr)
-			entry->masked = readl(desc_addr +
-					      PCI_MSIX_ENTRY_VECTOR_CTRL);
-		else
-			entry->masked = 0;
+static void msix_mask_all(void __iomem *base, int tsize)
+{
+	u32 ctrl = PCI_MSIX_ENTRY_CTRL_MASKBIT;
+	int i;
 
-		msix_mask_irq(entry, 1);
-	}
+	for (i = 0; i < tsize; i++, base += PCI_MSIX_ENTRY_SIZE)
+		writel(ctrl, base + PCI_MSIX_ENTRY_VECTOR_CTRL);
 }
 
 /**
@@ -768,9 +773,9 @@ static void msix_program_entries(struct pci_dev *dev,
 static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 				int nvec, struct irq_affinity *affd)
 {
-	int ret;
-	u16 control;
 	void __iomem *base;
+	int ret, tsize;
+	u16 control;
 
 	/*
 	 * Some devices require MSI-X to be enabled before the MSI-X
@@ -782,12 +787,16 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 
 	pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
 	/* Request & Map MSI-X table region */
-	base = msix_map_region(dev, msix_table_size(control));
+	tsize = msix_table_size(control);
+	base = msix_map_region(dev, tsize);
 	if (!base) {
 		ret = -ENOMEM;
 		goto out_disable;
 	}
 
+	/* Ensure that all table entries are masked. */
+	msix_mask_all(base, tsize);
+
 	ret = msix_setup_entries(dev, base, entries, nvec, affd);
 	if (ret)
 		goto out_disable;
@@ -801,7 +810,7 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 	if (ret)
 		goto out_free;
 
-	msix_program_entries(dev, entries);
+	msix_update_entries(dev, entries);
 
 	ret = populate_msi_sysfs(dev);
 	if (ret)

