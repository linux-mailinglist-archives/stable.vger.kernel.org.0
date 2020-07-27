Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F34DF22EE9F
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 16:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728938AbgG0OJZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 10:09:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728446AbgG0OJY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 10:09:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B28320838;
        Mon, 27 Jul 2020 14:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595858963;
        bh=S/bM2SWtg8rsSnzMbrIeZ2D0uKfq/MRyIXX/J3so7J8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=13m4uowzCTk2l5wB6HgjhCK1x7Ts3XbTv0AFJu1ZkEQsfTmcnPGn6ScU8+KYWtoN5
         Y3xviN44rkPhjRb9EiJYR44yRvUNpNbyMNfsWEmmjGuCiKdzklChTiRW6qhIpl3fnt
         dn8s4zjINlb/Tvu4BMUZB5enr9xXRkXupao2BJUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/86] irqdomain/treewide: Keep firmware node unconditionally allocated
Date:   Mon, 27 Jul 2020 16:03:48 +0200
Message-Id: <20200727134915.048599494@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727134914.312934924@linuxfoundation.org>
References: <20200727134914.312934924@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit e3beca48a45b5e0e6e6a4e0124276b8248dcc9bb ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c      | 10 +++++-----
 arch/x86/kernel/apic/msi.c          | 18 ++++++++++++------
 arch/x86/kernel/apic/vector.c       |  1 -
 arch/x86/platform/uv/uv_irq.c       |  3 ++-
 drivers/iommu/amd_iommu.c           |  5 +++--
 drivers/iommu/intel_irq_remapping.c |  2 +-
 drivers/pci/controller/vmd.c        |  5 +++--
 7 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index fa3b85b222e31..08e2f3a5f1242 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2323,12 +2323,12 @@ static int mp_irqdomain_create(int ioapic)
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
index 1f5df339e48ff..fb26c956c4421 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -265,12 +265,13 @@ void __init arch_init_msi_domain(struct irq_domain *parent)
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
@@ -303,7 +304,8 @@ struct irq_domain *arch_create_remap_msi_irq_domain(struct irq_domain *parent,
 	if (!fn)
 		return NULL;
 	d = pci_msi_create_irq_domain(fn, &pci_msi_ir_domain_info, parent);
-	irq_domain_free_fwnode(fn);
+	if (!d)
+		irq_domain_free_fwnode(fn);
 	return d;
 }
 #endif
@@ -366,7 +368,8 @@ static struct irq_domain *dmar_get_irq_domain(void)
 	if (fn) {
 		dmar_domain = msi_create_irq_domain(fn, &dmar_msi_domain_info,
 						    x86_vector_domain);
-		irq_domain_free_fwnode(fn);
+		if (!dmar_domain)
+			irq_domain_free_fwnode(fn);
 	}
 out:
 	mutex_unlock(&dmar_lock);
@@ -491,7 +494,10 @@ struct irq_domain *hpet_create_irq_domain(int hpet_id)
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
index e41be2c25da81..99c28c02b7a54 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -703,7 +703,6 @@ int __init arch_early_irq_init(void)
 	x86_vector_domain = irq_domain_create_tree(fn, &x86_vector_domain_ops,
 						   NULL);
 	BUG_ON(x86_vector_domain == NULL);
-	irq_domain_free_fwnode(fn);
 	irq_set_default_host(x86_vector_domain);
 
 	arch_init_msi_domain(x86_vector_domain);
diff --git a/arch/x86/platform/uv/uv_irq.c b/arch/x86/platform/uv/uv_irq.c
index fc13cbbb2dce2..abb6075397f05 100644
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
 
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 0783f44e9afe5..d0cbe910ee9db 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4508,9 +4508,10 @@ int amd_iommu_create_irq_domain(struct amd_iommu *iommu)
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
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 967450bd421a1..852e2841395b4 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -536,8 +536,8 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu)
 					    0, INTR_REMAP_TABLE_ENTRIES,
 					    fn, &intel_ir_domain_ops,
 					    iommu);
-	irq_domain_free_fwnode(fn);
 	if (!iommu->ir_domain) {
+		irq_domain_free_fwnode(fn);
 		pr_err("IR%d: failed to allocate irqdomain\n", iommu->seq_id);
 		goto out_free_bitmap;
 	}
diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index c3ac7f094a394..ad39b404f10a4 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -704,9 +704,10 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 
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
-- 
2.25.1



