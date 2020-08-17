Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADBC2474B3
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbgHQTNq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:13:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730653AbgHQPkT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:40:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3A3623357;
        Mon, 17 Aug 2020 15:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678818;
        bh=T16y4neqUck9t4k3D+k9lbBI/BbD8ANb1+46NGkLFrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OdVQ0w0O3N4LMCzKtHgDgaeD5M1g8D2smrAxmrxGzBGkRlhDtQ8Wj0jtZJsiYejuW
         qt1+EmgW2YtbVLYXIZpkCLJfSbwN05G6NoBuWkgW1irIkmgbJkipWveOrSPnUcuzsa
         J4NkkRxD7yBrtoqzmr0LDm8/kHnOnMFXLdLKctFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.8 451/464] irqdomain/treewide: Free firmware node after domain removal
Date:   Mon, 17 Aug 2020 17:16:44 +0200
Message-Id: <20200817143855.371457192@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

commit ec0160891e387f4771f953b888b1fe951398e5d9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/pci/pci-xtalk-bridge.c    |    3 +++
 arch/x86/kernel/apic/io_apic.c      |    5 +++++
 drivers/iommu/intel/irq_remapping.c |    8 ++++++++
 drivers/mfd/ioc3.c                  |    6 ++++++
 drivers/pci/controller/vmd.c        |    3 +++
 5 files changed, 25 insertions(+)

--- a/arch/mips/pci/pci-xtalk-bridge.c
+++ b/arch/mips/pci/pci-xtalk-bridge.c
@@ -728,6 +728,7 @@ err_free_resource:
 	pci_free_resource_list(&host->windows);
 err_remove_domain:
 	irq_domain_remove(domain);
+	irq_domain_free_fwnode(fn);
 	return err;
 }
 
@@ -735,8 +736,10 @@ static int bridge_remove(struct platform
 {
 	struct pci_bus *bus = platform_get_drvdata(pdev);
 	struct bridge_controller *bc = BRIDGE_CONTROLLER(bus);
+	struct fwnode_handle *fn = bc->domain->fwnode;
 
 	irq_domain_remove(bc->domain);
+	irq_domain_free_fwnode(fn);
 	pci_lock_rescan_remove();
 	pci_stop_root_bus(bus);
 	pci_remove_root_bus(bus);
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2335,8 +2335,13 @@ static int mp_irqdomain_create(int ioapi
 
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
--- a/drivers/mfd/ioc3.c
+++ b/drivers/mfd/ioc3.c
@@ -616,7 +616,10 @@ static int ioc3_mfd_probe(struct pci_dev
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
@@ -643,7 +646,10 @@ static void ioc3_mfd_remove(struct pci_d
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
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -560,6 +560,7 @@ static int vmd_enable_domain(struct vmd_
 	if (!vmd->bus) {
 		pci_free_resource_list(&resources);
 		irq_domain_remove(vmd->irq_domain);
+		irq_domain_free_fwnode(fn);
 		return -ENODEV;
 	}
 
@@ -673,6 +674,7 @@ static void vmd_cleanup_srcu(struct vmd_
 static void vmd_remove(struct pci_dev *dev)
 {
 	struct vmd_dev *vmd = pci_get_drvdata(dev);
+	struct fwnode_handle *fn = vmd->irq_domain->fwnode;
 
 	sysfs_remove_link(&vmd->dev->dev.kobj, "domain");
 	pci_stop_root_bus(vmd->bus);
@@ -680,6 +682,7 @@ static void vmd_remove(struct pci_dev *d
 	vmd_cleanup_srcu(vmd);
 	vmd_detach_resources(vmd);
 	irq_domain_remove(vmd->irq_domain);
+	irq_domain_free_fwnode(fn);
 }
 
 #ifdef CONFIG_PM_SLEEP


