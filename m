Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EEE222A1E6
	for <lists+stable@lfdr.de>; Thu, 23 Jul 2020 00:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733229AbgGVWLw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jul 2020 18:11:52 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:52734 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733217AbgGVWLv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jul 2020 18:11:51 -0400
Date:   Wed, 22 Jul 2020 22:11:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1595455908;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dP8HeqyLz7VDtF0UFEdHeulQGqLfYt9frO8l1BcFuYc=;
        b=ZSqcsNX2FkwnS7GVdwjhHAWv+ols6orXfZ+RrELVFdDuciBRMOH71rFuuUK0c2WmvEgOIW
        uujGdDhcQ7Rzo3kBJU7d82bvJkmLKMQrVnfhXUcKhbNIyhmuwowvrV6yZPIEwMlxucIqNj
        N/GQ+QHAXoMFrHHyHL5CqR/aReE2Ng6DGYc5fF3cYBlOqnghKOV+PNka7PY3pGpuj6ZbGk
        rEB7ac69VZ/P0zeBuOpvK0PbiK0/t1JygekL6bDqwGhQAs4duda1JDqhlJQcO8TxJju9YS
        4/yXPvvNP2vpqdJB7wGN31CVaQeyM4dbEQbT8SO64WepYTKkZyecaeWDgcrhPg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1595455908;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dP8HeqyLz7VDtF0UFEdHeulQGqLfYt9frO8l1BcFuYc=;
        b=G7vctGfisL5uVJEhl1+HlGJ2o3IcctplHVbRjfoYBYz1UwUSJrfv3sfkDvvktA7Pa98A54
        LIwQm8i4JzZaflAw==
From:   "tip-bot2 for Jon Derrick" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] irqdomain/treewide: Free firmware node after domain removal
Cc:     Jon Derrick <jonathan.derrick@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1595363169-7157-1-git-send-email-jonathan.derrick@intel.com>
References: <1595363169-7157-1-git-send-email-jonathan.derrick@intel.com>
MIME-Version: 1.0
Message-ID: <159545590775.4006.12810097087701475191.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     ec0160891e387f4771f953b888b1fe951398e5d9
Gitweb:        https://git.kernel.org/tip/ec0160891e387f4771f953b888b1fe951398e5d9
Author:        Jon Derrick <jonathan.derrick@intel.com>
AuthorDate:    Tue, 21 Jul 2020 14:26:09 -06:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Thu, 23 Jul 2020 00:08:52 +02:00

irqdomain/treewide: Free firmware node after domain removal

Commit 711419e504eb ("irqdomain: Add the missing assignment of
domain->fwnode for named fwnode") unintentionally caused a dangling pointer
page fault issue on firmware nodes that were freed after IRQ domain
allocation. Commit e3beca48a45b fixed that dangling pointer issue by only
freeing the firmware node after an IRQ domain allocation failure. That fix
no longer frees the firmware node immediately, but leaves the firmware node
allocated after the domain is removed.

The firmware node must be kept around through irq_domain_remove, but should be
freed it afterwards.

Add the missing free operations after domain removal where where appropriate.

Fixes: e3beca48a45b ("irqdomain/treewide: Keep firmware node unconditionally allocated")
Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>	# drivers/pci
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/1595363169-7157-1-git-send-email-jonathan.derrick@intel.com

---
 arch/mips/pci/pci-xtalk-bridge.c    | 3 +++
 arch/x86/kernel/apic/io_apic.c      | 5 +++++
 drivers/iommu/intel/irq_remapping.c | 8 ++++++++
 drivers/mfd/ioc3.c                  | 6 ++++++
 drivers/pci/controller/vmd.c        | 3 +++
 5 files changed, 25 insertions(+)

diff --git a/arch/mips/pci/pci-xtalk-bridge.c b/arch/mips/pci/pci-xtalk-bridge.c
index 5958217..9b3cc77 100644
--- a/arch/mips/pci/pci-xtalk-bridge.c
+++ b/arch/mips/pci/pci-xtalk-bridge.c
@@ -728,6 +728,7 @@ err_free_resource:
 	pci_free_resource_list(&host->windows);
 err_remove_domain:
 	irq_domain_remove(domain);
+	irq_domain_free_fwnode(fn);
 	return err;
 }
 
@@ -735,8 +736,10 @@ static int bridge_remove(struct platform_device *pdev)
 {
 	struct pci_bus *bus = platform_get_drvdata(pdev);
 	struct bridge_controller *bc = BRIDGE_CONTROLLER(bus);
+	struct fwnode_handle *fn = bc->domain->fwnode;
 
 	irq_domain_remove(bc->domain);
+	irq_domain_free_fwnode(fn);
 	pci_lock_rescan_remove();
 	pci_stop_root_bus(bus);
 	pci_remove_root_bus(bus);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 81ffcfb..21325a4 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2335,8 +2335,13 @@ static int mp_irqdomain_create(int ioapic)
 
 static void ioapic_destroy_irqdomain(int idx)
 {
+	struct ioapic_domain_cfg *cfg = &ioapics[idx].irqdomain_cfg;
+	struct fwnode_handle *fn = ioapics[idx].irqdomain->fwnode;
+
 	if (ioapics[idx].irqdomain) {
 		irq_domain_remove(ioapics[idx].irqdomain);
+		if (!cfg->dev)
+			irq_domain_free_fwnode(fn);
 		ioapics[idx].irqdomain = NULL;
 	}
 }
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 9564d23..aa096b3 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -628,13 +628,21 @@ out_free_table:
 
 static void intel_teardown_irq_remapping(struct intel_iommu *iommu)
 {
+	struct fwnode_handle *fn;
+
 	if (iommu && iommu->ir_table) {
 		if (iommu->ir_msi_domain) {
+			fn = iommu->ir_msi_domain->fwnode;
+
 			irq_domain_remove(iommu->ir_msi_domain);
+			irq_domain_free_fwnode(fn);
 			iommu->ir_msi_domain = NULL;
 		}
 		if (iommu->ir_domain) {
+			fn = iommu->ir_domain->fwnode;
+
 			irq_domain_remove(iommu->ir_domain);
+			irq_domain_free_fwnode(fn);
 			iommu->ir_domain = NULL;
 		}
 		free_pages((unsigned long)iommu->ir_table->base,
diff --git a/drivers/mfd/ioc3.c b/drivers/mfd/ioc3.c
index 74cee7c..d939ccc 100644
--- a/drivers/mfd/ioc3.c
+++ b/drivers/mfd/ioc3.c
@@ -616,7 +616,10 @@ static int ioc3_mfd_probe(struct pci_dev *pdev,
 		/* Remove all already added MFD devices */
 		mfd_remove_devices(&ipd->pdev->dev);
 		if (ipd->domain) {
+			struct fwnode_handle *fn = ipd->domain->fwnode;
+
 			irq_domain_remove(ipd->domain);
+			irq_domain_free_fwnode(fn);
 			free_irq(ipd->domain_irq, (void *)ipd);
 		}
 		pci_iounmap(pdev, regs);
@@ -643,7 +646,10 @@ static void ioc3_mfd_remove(struct pci_dev *pdev)
 	/* Release resources */
 	mfd_remove_devices(&ipd->pdev->dev);
 	if (ipd->domain) {
+		struct fwnode_handle *fn = ipd->domain->fwnode;
+
 		irq_domain_remove(ipd->domain);
+		irq_domain_free_fwnode(fn);
 		free_irq(ipd->domain_irq, (void *)ipd);
 	}
 	pci_iounmap(pdev, ipd->regs);
diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index 9a64cf9..ebec0a6 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -560,6 +560,7 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 	if (!vmd->bus) {
 		pci_free_resource_list(&resources);
 		irq_domain_remove(vmd->irq_domain);
+		irq_domain_free_fwnode(fn);
 		return -ENODEV;
 	}
 
@@ -673,6 +674,7 @@ static void vmd_cleanup_srcu(struct vmd_dev *vmd)
 static void vmd_remove(struct pci_dev *dev)
 {
 	struct vmd_dev *vmd = pci_get_drvdata(dev);
+	struct fwnode_handle *fn = vmd->irq_domain->fwnode;
 
 	sysfs_remove_link(&vmd->dev->dev.kobj, "domain");
 	pci_stop_root_bus(vmd->bus);
@@ -680,6 +682,7 @@ static void vmd_remove(struct pci_dev *dev)
 	vmd_cleanup_srcu(vmd);
 	vmd_detach_resources(vmd);
 	irq_domain_remove(vmd->irq_domain);
+	irq_domain_free_fwnode(fn);
 }
 
 #ifdef CONFIG_PM_SLEEP
