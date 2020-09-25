Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8BE27882F
	for <lists+stable@lfdr.de>; Fri, 25 Sep 2020 14:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgIYMxa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Sep 2020 08:53:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:59052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729428AbgIYMx3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 25 Sep 2020 08:53:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BC002075E;
        Fri, 25 Sep 2020 12:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601038408;
        bh=qC9ePJqVM6O/UDP/PBFMXUmoC2b6haSl8b3d9uN1XWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTGvWM/hfiHY6GRRvFW5KI/0PY0eRrrVsxTAFZGYnN0ymB7fwU3H22oHOAnK/xzgQ
         YGtb0upESSVRdYU3Z5WPTqNAo3wZJjmKvE3NZVKJRXZ4XPnba4ZyTyn1FBWf1Sw+Np
         f39eX2zIjPgeh0DYSx9HSA2+VwuyPFRGA2USGWBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Osborne <sean.m.osborne@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Erik Rockstrom <erik.rockstrom@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.4 43/43] iommu/amd: Use cmpxchg_double() when updating 128-bit IRTE
Date:   Fri, 25 Sep 2020 14:48:55 +0200
Message-Id: <20200925124730.028817920@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200925124723.575329814@linuxfoundation.org>
References: <20200925124723.575329814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

commit e52d58d54a321d4fe9d0ecdabe4f8774449f0d6e upstream.

When using 128-bit interrupt-remapping table entry (IRTE) (a.k.a GA mode),
current driver disables interrupt remapping when it updates the IRTE
so that the upper and lower 64-bit values can be updated safely.

However, this creates a small window, where the interrupt could
arrive and result in IO_PAGE_FAULT (for interrupt) as shown below.

  IOMMU Driver            Device IRQ
  ============            ===========
  irte.RemapEn=0
       ...
   change IRTE            IRQ from device ==> IO_PAGE_FAULT !!
       ...
  irte.RemapEn=1

This scenario has been observed when changing irq affinity on a system
running I/O-intensive workload, in which the destination APIC ID
in the IRTE is updated.

Instead, use cmpxchg_double() to update the 128-bit IRTE at once without
disabling the interrupt remapping. However, this means several features,
which require GA (128-bit IRTE) support will also be affected if cmpxchg16b
is not supported (which is unprecedented for AMD processors w/ IOMMU).

Fixes: 880ac60e2538 ("iommu/amd: Introduce interrupt remapping ops structure")
Reported-by: Sean Osborne <sean.m.osborne@oracle.com>
Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Tested-by: Erik Rockstrom <erik.rockstrom@oracle.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Link: https://lore.kernel.org/r/20200903093822.52012-3-suravee.suthikulpanit@amd.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/Kconfig          |    2 +-
 drivers/iommu/amd_iommu.c      |   17 +++++++++++++----
 drivers/iommu/amd_iommu_init.c |   21 +++++++++++++++++++--
 3 files changed, 33 insertions(+), 7 deletions(-)

--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -138,7 +138,7 @@ config AMD_IOMMU
 	select PCI_PASID
 	select IOMMU_API
 	select IOMMU_IOVA
-	depends on X86_64 && PCI && ACPI
+	depends on X86_64 && PCI && ACPI && HAVE_CMPXCHG_DOUBLE
 	---help---
 	  With this option you can enable support for AMD IOMMU hardware in
 	  your system. An IOMMU is a hardware component which provides
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3873,6 +3873,7 @@ out:
 static int modify_irte_ga(u16 devid, int index, struct irte_ga *irte,
 			  struct amd_ir_data *data)
 {
+	bool ret;
 	struct irq_remap_table *table;
 	struct amd_iommu *iommu;
 	unsigned long flags;
@@ -3890,10 +3891,18 @@ static int modify_irte_ga(u16 devid, int
 
 	entry = (struct irte_ga *)table->table;
 	entry = &entry[index];
-	entry->lo.fields_remap.valid = 0;
-	entry->hi.val = irte->hi.val;
-	entry->lo.val = irte->lo.val;
-	entry->lo.fields_remap.valid = 1;
+
+	ret = cmpxchg_double(&entry->lo.val, &entry->hi.val,
+			     entry->lo.val, entry->hi.val,
+			     irte->lo.val, irte->hi.val);
+	/*
+	 * We use cmpxchg16 to atomically update the 128-bit IRTE,
+	 * and it cannot be updated by the hardware or other processors
+	 * behind us, so the return value of cmpxchg16 should be the
+	 * same as the old value.
+	 */
+	WARN_ON(!ret);
+
 	if (data)
 		data->ref = entry;
 
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1522,7 +1522,14 @@ static int __init init_iommu_one(struct
 			iommu->mmio_phys_end = MMIO_REG_END_OFFSET;
 		else
 			iommu->mmio_phys_end = MMIO_CNTR_CONF_OFFSET;
-		if (((h->efr_attr & (0x1 << IOMMU_FEAT_GASUP_SHIFT)) == 0))
+
+		/*
+		 * Note: GA (128-bit IRTE) mode requires cmpxchg16b supports.
+		 * GAM also requires GA mode. Therefore, we need to
+		 * check cmpxchg16b support before enabling it.
+		 */
+		if (!boot_cpu_has(X86_FEATURE_CX16) ||
+		    ((h->efr_attr & (0x1 << IOMMU_FEAT_GASUP_SHIFT)) == 0))
 			amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY;
 		break;
 	case 0x11:
@@ -1531,8 +1538,18 @@ static int __init init_iommu_one(struct
 			iommu->mmio_phys_end = MMIO_REG_END_OFFSET;
 		else
 			iommu->mmio_phys_end = MMIO_CNTR_CONF_OFFSET;
-		if (((h->efr_reg & (0x1 << IOMMU_EFR_GASUP_SHIFT)) == 0))
+
+		/*
+		 * Note: GA (128-bit IRTE) mode requires cmpxchg16b supports.
+		 * XT, GAM also requires GA mode. Therefore, we need to
+		 * check cmpxchg16b support before enabling them.
+		 */
+		if (!boot_cpu_has(X86_FEATURE_CX16) ||
+		    ((h->efr_reg & (0x1 << IOMMU_EFR_GASUP_SHIFT)) == 0)) {
 			amd_iommu_guest_ir = AMD_IOMMU_GUEST_IR_LEGACY;
+			break;
+		}
+
 		/*
 		 * Note: Since iommu_update_intcapxt() leverages
 		 * the IOMMU MMIO access to MSI capability block registers


