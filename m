Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D0E221F669
	for <lists+stable@lfdr.de>; Tue, 14 Jul 2020 17:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgGNPs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jul 2020 11:48:57 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:44614 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgGNPs5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jul 2020 11:48:57 -0400
Date:   Tue, 14 Jul 2020 15:48:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1594741733;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GDVdxpPETEUs4zpH/T1YOqdeyC4ELnzkOPaqKzWyq/0=;
        b=1DdPHBSIfxTtTROYTMAaEDBYS2RXD4d9KEHhOwUn5wziAXvOEhNgSUcpySwYcZe2v5ouDA
        eljOyNtxnpXVenRRY4stYHop/y/5PQJY/OBXHiNyyVeTku1sY6JKoTPXVYtYI4W4Uiu0Ym
        3eSgpk24I+PyJ8TZRm+xO4VME/9jGXeNH7YrDoK/DvQ820wrbT/bMOqVojwWy/7S2sQ15s
        m/6qm9B82XeD7W+SxVcTtTJbnmy/QcNdyTN5EjV0Vdvx3IGzOcCKsr3eIRPkSMm7d0kVFb
        1+skFbjuGfhYPi7znnOHWdUix2V67mmkmEFPWEjNSaVUaG2i8VFpr/tJ0/kRFQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1594741733;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GDVdxpPETEUs4zpH/T1YOqdeyC4ELnzkOPaqKzWyq/0=;
        b=BRkEJJGkVvKGprWY4FezRTtHvSHZEdqnb5tRiEMXzxWJ0Ma+uS2dAZ2d43/YeLwOdX/207
        PC9H5XQ0BaTHfWAQ==
From:   "tip-bot2 for Thomas Gleixner" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: irq/urgent] irqdomain/treewide: Keep firmware node
 unconditionally allocated
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <873661qakd.fsf@nanos.tec.linutronix.de>
References: <873661qakd.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Message-ID: <159474173226.4006.8854547347623536362.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the irq/urgent branch of tip:

Commit-ID:     e3beca48a45b5e0e6e6a4e0124276b8248dcc9bb
Gitweb:        https://git.kernel.org/tip/e3beca48a45b5e0e6e6a4e0124276b8248dcc9bb
Author:        Thomas Gleixner <tglx@linutronix.de>
AuthorDate:    Thu, 09 Jul 2020 11:53:06 +02:00
Committer:     Thomas Gleixner <tglx@linutronix.de>
CommitterDate: Tue, 14 Jul 2020 17:44:42 +02:00

irqdomain/treewide: Keep firmware node unconditionally allocated

Quite some non OF/ACPI users of irqdomains allocate firmware nodes of type
IRQCHIP_FWNODE_NAMED or IRQCHIP_FWNODE_NAMED_ID and free them right after
creating the irqdomain. The only purpose of these FW nodes is to convey
name information. When this was introduced the core code did not store the
pointer to the node in the irqdomain. A recent change stored the firmware
node pointer in irqdomain for other reasons and missed to notice that the
usage sites which do the alloc_fwnode/create_domain/free_fwnode sequence
are broken by this. Storing a dangling pointer is dangerous itself, but in
case that the domain is destroyed later on this leads to a double free.

Remove the freeing of the firmware node after creating the irqdomain from
all affected call sites to cure this.

Fixes: 711419e504eb ("irqdomain: Add the missing assignment of domain->fwnode for named fwnode")
Reported-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/873661qakd.fsf@nanos.tec.linutronix.de

---
 arch/mips/pci/pci-xtalk-bridge.c    |  5 +++--
 arch/x86/kernel/apic/io_apic.c      | 10 +++++-----
 arch/x86/kernel/apic/msi.c          | 18 ++++++++++++------
 arch/x86/kernel/apic/vector.c       |  1 -
 arch/x86/platform/uv/uv_irq.c       |  3 ++-
 drivers/iommu/amd/iommu.c           |  5 +++--
 drivers/iommu/hyperv-iommu.c        |  5 ++++-
 drivers/iommu/intel/irq_remapping.c |  2 +-
 drivers/mfd/ioc3.c                  |  5 +++--
 drivers/pci/controller/vmd.c        |  5 +++--
 10 files changed, 36 insertions(+), 23 deletions(-)

diff --git a/arch/mips/pci/pci-xtalk-bridge.c b/arch/mips/pci/pci-xtalk-bridge.c
index 3b2552f..5958217 100644
--- a/arch/mips/pci/pci-xtalk-bridge.c
+++ b/arch/mips/pci/pci-xtalk-bridge.c
@@ -627,9 +627,10 @@ static int bridge_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	domain = irq_domain_create_hierarchy(parent, 0, 8, fn,
 					     &bridge_domain_ops, NULL);
-	irq_domain_free_fwnode(fn);
-	if (!domain)
+	if (!domain) {
+		irq_domain_free_fwnode(fn);
 		return -ENOMEM;
+	}
 
 	pci_set_flags(PCI_PROBE_ONLY);
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index ce61e3e..81ffcfb 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2316,12 +2316,12 @@ static int mp_irqdomain_create(int ioapic)
 	ip->irqdomain = irq_domain_create_linear(fn, hwirqs, cfg->ops,
 						 (void *)(long)ioapic);
 
-	/* Release fw handle if it was allocated above */
-	if (!cfg->dev)
-		irq_domain_free_fwnode(fn);
-
-	if (!ip->irqdomain)
+	if (!ip->irqdomain) {
+		/* Release fw handle if it was allocated above */
+		if (!cfg->dev)
+			irq_domain_free_fwnode(fn);
 		return -ENOMEM;
+	}
 
 	ip->irqdomain->parent = parent;
 
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 5cbaca5..c2b2911 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -263,12 +263,13 @@ void __init arch_init_msi_domain(struct irq_domain *parent)
 		msi_default_domain =
 			pci_msi_create_irq_domain(fn, &pci_msi_domain_info,
 						  parent);
-		irq_domain_free_fwnode(fn);
 	}
-	if (!msi_default_domain)
+	if (!msi_default_domain) {
+		irq_domain_free_fwnode(fn);
 		pr_warn("failed to initialize irqdomain for MSI/MSI-x.\n");
-	else
+	} else {
 		msi_default_domain->flags |= IRQ_DOMAIN_MSI_NOMASK_QUIRK;
+	}
 }
 
 #ifdef CONFIG_IRQ_REMAP
@@ -301,7 +302,8 @@ struct irq_domain *arch_create_remap_msi_irq_domain(struct irq_domain *parent,
 	if (!fn)
 		return NULL;
 	d = pci_msi_create_irq_domain(fn, &pci_msi_ir_domain_info, parent);
-	irq_domain_free_fwnode(fn);
+	if (!d)
+		irq_domain_free_fwnode(fn);
 	return d;
 }
 #endif
@@ -364,7 +366,8 @@ static struct irq_domain *dmar_get_irq_domain(void)
 	if (fn) {
 		dmar_domain = msi_create_irq_domain(fn, &dmar_msi_domain_info,
 						    x86_vector_domain);
-		irq_domain_free_fwnode(fn);
+		if (!dmar_domain)
+			irq_domain_free_fwnode(fn);
 	}
 out:
 	mutex_unlock(&dmar_lock);
@@ -489,7 +492,10 @@ struct irq_domain *hpet_create_irq_domain(int hpet_id)
 	}
 
 	d = msi_create_irq_domain(fn, domain_info, parent);
-	irq_domain_free_fwnode(fn);
+	if (!d) {
+		irq_domain_free_fwnode(fn);
+		kfree(domain_info);
+	}
 	return d;
 }
 
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index c48be6e..cc8b16f 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -709,7 +709,6 @@ int __init arch_early_irq_init(void)
 	x86_vector_domain = irq_domain_create_tree(fn, &x86_vector_domain_ops,
 						   NULL);
 	BUG_ON(x86_vector_domain == NULL);
-	irq_domain_free_fwnode(fn);
 	irq_set_default_host(x86_vector_domain);
 
 	arch_init_msi_domain(x86_vector_domain);
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index fc13cbb..abb6075 100644
--- a/arch/x86/platform/uv/uv_irq.c
+++ b/arch/x86/platform/uv/uv_irq.c
@@ -167,9 +167,10 @@ static struct irq_domain *uv_get_irq_domain(void)
 		goto out;
 
 	uv_domain = irq_domain_create_tree(fn, &uv_domain_ops, NULL);
-	irq_domain_free_fwnode(fn);
 	if (uv_domain)
 		uv_domain->parent = x86_vector_domain;
+	else
+		irq_domain_free_fwnode(fn);
 out:
 	mutex_unlock(&uv_lock);
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 74cca17..2f22326 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3985,9 +3985,10 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
 	if (!fn)
 		return -ENOMEM;
 	iommu->ir_domain = irq_domain_create_tree(fn, &amd_ir_domain_ops, iommu);
-	irq_domain_free_fwnode(fn);
-	if (!iommu->ir_domain)
+	if (!iommu->ir_domain) {
+		irq_domain_free_fwnode(fn);
 		return -ENOMEM;
+	}
 
 	iommu->ir_domain->parent = arch_get_ir_parent_domain();
 	iommu->msi_domain = arch_create_remap_msi_irq_domain(iommu->ir_domain,
diff --git a/drivers/iommu/hyperv-iommu.c b/drivers/iommu/hyperv-iommu.c
index 3c0c67a..8919c1c 100644
--- a/drivers/iommu/hyperv-iommu.c
+++ b/drivers/iommu/hyperv-iommu.c
@@ -155,7 +155,10 @@ static int __init hyperv_prepare_irq_remapping(void)
 				0, IOAPIC_REMAPPING_ENTRY, fn,
 				&hyperv_ir_domain_ops, NULL);
 
-	irq_domain_free_fwnode(fn);
+	if (!ioapic_ir_domain) {
+		irq_domain_free_fwnode(fn);
+		return -ENOMEM;
+	}
 
 	/*
 	 * Hyper-V doesn't provide irq remapping function for
diff --git a/drivers/iommu/intel/irq_remapping.c b/drivers/iommu/intel/irq_remapping.c
index 7f87698..9564d23 100644
--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -563,8 +563,8 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 					    0, INTR_REMAP_TABLE_ENTRIES,
 					    fn, &intel_ir_domain_ops,
 					    iommu);
-	irq_domain_free_fwnode(fn);
 	if (!iommu->ir_domain) {
+		irq_domain_free_fwnode(fn);
 		pr_err("IR%d: failed to allocate irqdomain\n", iommu->seq_id);
 		goto out_free_bitmap;
 	}
diff --git a/drivers/mfd/ioc3.c b/drivers/mfd/ioc3.c
index 02998d4..74cee7c 100644
--- a/drivers/mfd/ioc3.c
+++ b/drivers/mfd/ioc3.c
@@ -142,10 +142,11 @@ static int ioc3_irq_domain_setup(struct ioc3_priv_data *ipd, int irq)
 		goto err;
 
 	domain = irq_domain_create_linear(fn, 24, &ioc3_irq_domain_ops, ipd);
-	if (!domain)
+	if (!domain) {
+		irq_domain_free_fwnode(fn);
 		goto err;
+	}
 
-	irq_domain_free_fwnode(fn);
 	ipd->domain = domain;
 
 	irq_set_chained_handler_and_data(irq, ioc3_irq_handler, domain);
diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index e386d4e..9a64cf9 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -546,9 +546,10 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 
 	vmd->irq_domain = pci_msi_create_irq_domain(fn, &vmd_msi_domain_info,
 						    x86_vector_domain);
-	irq_domain_free_fwnode(fn);
-	if (!vmd->irq_domain)
+	if (!vmd->irq_domain) {
+		irq_domain_free_fwnode(fn);
 		return -ENODEV;
+	}
 
 	pci_add_resource(&resources, &vmd->resources[0]);
 	pci_add_resource_offset(&resources, &vmd->resources[1], offset[0]);
