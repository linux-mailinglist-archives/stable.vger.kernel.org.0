Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0006C3F6720
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241566AbhHXRbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:31:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:35802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230080AbhHXR3D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:29:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2215B61B72;
        Tue, 24 Aug 2021 17:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824723;
        bh=5RjDmvx7lpFCC+vMXxGxupG//Fs4+iKQDf0gdPXXnqY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yq1D21S08yaLP6CLahr4N/VUGaQpksfF7KRMWSZ5VJh8ZzF8Cs4myq7Ao2/0TrvCY
         a62wRSuLAJNmxNglrncmIATa71DH1zcForWBsNqpMnr8Jjuygd9MXxsXixbfV/TIM1
         Pw1Xgq/WFhIImQb86CxsRJqLCSeATTvVE6EFkH8ohFpbpfs5GgY5rnwjl2Jx9Q5Dus
         bM0ua8kooxRZSJPyvMnySCxRWvCj6YSem7B0Zp1ngiPT7ZDX62fZOsC3aUcfKSeY1Q
         Ym5dR+0I+9V0Cp83Sgw4wCvvU32hmIG6VYi5/a20GpakJLBREWXDda41lPia9MUwkH
         el65fJztKKMLA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.14 26/64] PCI/MSI: Mask all unused MSI-X entries
Date:   Tue, 24 Aug 2021 13:04:19 -0400
Message-Id: <20210824170457.710623-27-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170457.710623-1-sashal@kernel.org>
References: <20210824170457.710623-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.245-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.245-rc1
X-KernelTest-Deadline: 2021-08-26T17:04+00:00
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
 drivers/pci/msi.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index ecf15f0ea295..8a0c28906d8f 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -675,6 +675,7 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 {
 	struct cpumask *curmsk, *masks = NULL;
 	struct msi_desc *entry;
+	void __iomem *addr;
 	int ret, i;
 
 	if (affd)
@@ -694,6 +695,7 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 
 		entry->msi_attrib.is_msix	= 1;
 		entry->msi_attrib.is_64		= 1;
+
 		if (entries)
 			entry->msi_attrib.entry_nr = entries[i].entry;
 		else
@@ -701,6 +703,10 @@ static int msix_setup_entries(struct pci_dev *dev, void __iomem *base,
 		entry->msi_attrib.default_irq	= dev->irq;
 		entry->mask_base		= base;
 
+		addr = pci_msix_desc_addr(entry);
+		if (addr)
+			entry->masked = readl(addr + PCI_MSIX_ENTRY_VECTOR_CTRL);
+
 		list_add_tail(&entry->list, dev_to_msi_list(&dev->dev));
 		if (masks)
 			curmsk++;
@@ -711,21 +717,27 @@ out:
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
@@ -740,9 +752,9 @@ static void msix_program_entries(struct pci_dev *dev,
 static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 				int nvec, const struct irq_affinity *affd)
 {
-	int ret;
-	u16 control;
 	void __iomem *base;
+	int ret, tsize;
+	u16 control;
 
 	/*
 	 * Some devices require MSI-X to be enabled before the MSI-X
@@ -754,12 +766,16 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 
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
@@ -773,7 +789,7 @@ static int msix_capability_init(struct pci_dev *dev, struct msix_entry *entries,
 	if (ret)
 		goto out_free;
 
-	msix_program_entries(dev, entries);
+	msix_update_entries(dev, entries);
 
 	ret = populate_msi_sysfs(dev);
 	if (ret)
-- 
2.30.2

