Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 575DE3F67A6
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241361AbhHXRg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241400AbhHXReF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:34:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B404661B74;
        Tue, 24 Aug 2021 17:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824792;
        bh=laNNs0h2Bwioqg8va5LPzK8T1ahoUWNVDUxKhdE0idQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T9V4IWBhz9M2YrTsXpDaQ8Sihs+8E7SYt3OCmVpnHDLFSZWtczjp/sGyGVw2DPMka
         CQTGCMjfObc+dKgbRe4k/SfBAhj79tYCQHJ/A6yC4qOe7PA7bqU3bI+uQiPGaPCPvi
         BC9DyxQanKg/C/+e1crrFi3VQS6QTlcWXmSpeXpgXvf+E+AnbCX67wa1htopoEpLT9
         V6+YsbcL52ZSNjxueu4uVD0g43bXBKkygCpAB48629uX5tvIAlcq9k22uADxb2k5Wg
         Wazy1YdYXfhIW0y+r5L7GuCmbYFn3d8cUYeLaAreSZdiQSzmIkDlKBUGtewqsD0ZF1
         g9/FOAc7YYNRQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 16/43] PCI/MSI: Mask all unused MSI-X entries
Date:   Tue, 24 Aug 2021 13:05:47 -0400
Message-Id: <20210824170614.710813-17-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170614.710813-1-sashal@kernel.org>
References: <20210824170614.710813-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.281-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.281-rc1
X-KernelTest-Deadline: 2021-08-26T17:06+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

commit 7d5ec3d3612396dc6d4b76366d20ab9fc06f399f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/msi.c | 39 ++++++++++++++++++++++++++++-----------
 1 file changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 79b36f1bde0d..a4873c7fea72 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -695,6 +695,7 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 {
 	struct cpumask *curmsk, *masks = NULL;
 	struct msi_desc *entry;
+	void __iomem *addr;
 	int ret, i;
 
 	if (affinity) {
@@ -717,6 +718,7 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 
 		entry->msi_attrib.is_msix	= 1;
 		entry->msi_attrib.is_64		= 1;
+
 		if (entries)
 			entry->msi_attrib.entry_nr = entries[i].entry;
 		else
@@ -724,6 +726,10 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 		entry->msi_attrib.default_irq	= dev->irq;
 		entry->mask_base		= base;
 
+		addr = pci_msix_desc_addr(entry);
+		if (addr)
+			entry->masked = readl(addr + PCI_MSIX_ENTRY_VECTOR_CTRL);
+
 		list_add_tail(&entry->list, dev_to_msi_list(&dev->dev));
 		if (masks)
 			curmsk++;
@@ -734,21 +740,27 @@ out:
 	return ret;
 }
 
-static void msix_program_entries(struct pci_dev *dev,
-				 struct msix_entry *entries)
+static void msix_update_entries(struct pci_dev *dev, struct msix_entry *entries)
 {
 	struct msi_desc *entry;
-	int i = 0;
 
 	for_each_pci_msi_entry(entry, dev) {
-		if (entries)
-			entries[i++].vector = entry->irq;
-		entry->masked = readl(pci_msix_desc_addr(entry) +
-				PCI_MSIX_ENTRY_VECTOR_CTRL);
-		msix_mask_irq(entry, 1);
+		if (entries) {
+			entries->vector = entry->irq;
+			entries++;
+		}
 	}
 }
 
+static void msix_mask_all(void __iomem *base, int tsize)
+{
+	u32 ctrl = PCI_MSIX_ENTRY_CTRL_MASKBIT;
+	int i;
+
+	for (i = 0; i < tsize; i++, base += PCI_MSIX_ENTRY_SIZE)
+		writel(ctrl, base + PCI_MSIX_ENTRY_VECTOR_CTRL);
+}
+
 /**
  * msix_capability_init - configure device's MSI-X capability
  * @dev: pointer to the pci_dev data structure of MSI-X device function
@@ -763,9 +775,9 @@ static void msix_program_entries(struct pci_dev *dev,
 static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 				int nvec, bool affinity)
 {
-	int ret;
-	u16 control;
 	void __iomem *base;
+	int ret, tsize;
+	u16 control;
 
 	/*
 	 * Some devices require MSI-X to be enabled before the MSI-X
@@ -777,12 +789,17 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 
 	pci_read_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, &control);
 	/* Request & Map MSI-X table region */
+	tsize = msix_table_size(control);
+	base = msix_map_region(dev, tsize);
 	base = msix_map_region(dev, msix_table_size(control));
 	if (!base) {
 		ret = -ENOMEM;
 		goto out_disable;
 	}
 
+	/* Ensure that all table entries are masked. */
+	msix_mask_all(base, tsize);
+
 	ret = msix_setup_entries(dev, base, entries, nvec, affinity);
 	if (ret)
 		goto out_disable;
@@ -796,7 +813,7 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 	if (ret)
 		goto out_free;
 
-	msix_program_entries(dev, entries);
+	msix_update_entries(dev, entries);
 
 	ret = populate_msi_sysfs(dev);
 	if (ret)
-- 
2.30.2

