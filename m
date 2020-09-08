Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2CA8261D26
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 21:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731882AbgIHTdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 15:33:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47738 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731011AbgIHP6F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 11:58:05 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF336246A6;
        Tue,  8 Sep 2020 15:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579596;
        bh=ddQcpMnvAZGtTHFiyyqUjbjAJDkGs5EZL3Y+Zd5nYRc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Ta4w3eCcXTrmKK9d4vRJabW8tgLY2CSr+mBTO7EDt6X/9uQSayt1yB5rLZG4rQcc
         uoZ1Qpu1NcII2VOTVw8VF0mTLLrKpayCE8XvhzfelnObWpn7uFXvFovNnsyDTNOFzD
         lQ3k+vKH5M8ciszdidj5vTDsX+VREfdBc8kE0nNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Osborne <sean.m.osborne@oracle.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Erik Rockstrom <erik.rockstrom@oracle.com>,
        Joao Martins <joao.m.martins@oracle.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 114/186] iommu/amd: Use cmpxchg_double() when updating 128-bit IRTE
Date:   Tue,  8 Sep 2020 17:24:16 +0200
Message-Id: <20200908152247.161016479@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit e52d58d54a321d4fe9d0ecdabe4f8774449f0d6e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/Kconfig     |  2 +-
 drivers/iommu/amd/init.c  | 21 +++++++++++++++++++--
 drivers/iommu/amd/iommu.c | 17 +++++++++++++----
 3 files changed, 33 insertions(+), 7 deletions(-)

diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
index b0f308cb7f7c2..201b2718f0755 100644
--- a/drivers/iommu/Kconfig
+++ b/drivers/iommu/Kconfig
@@ -143,7 +143,7 @@ config AMD_IOMMU
 	select IOMMU_API
 	select IOMMU_IOVA
 	select IOMMU_DMA
-	depends on X86_64 && PCI && ACPI
+	depends on X86_64 && PCI && ACPI && HAVE_CMPXCHG_DOUBLE
 	help
 	  With this option you can enable support for AMD IOMMU hardware in
 	  your system. An IOMMU is a hardware component which provides
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 6ebd4825e3206..bf45f8e2c7edd 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -1518,7 +1518,14 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
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
@@ -1527,8 +1534,18 @@ static int __init init_iommu_one(struct amd_iommu *iommu, struct ivhd_header *h)
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
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index d7b037891fb7e..200ee948f6ec1 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3283,6 +3283,7 @@ out:
 static int modify_irte_ga(u16 devid, int index, struct irte_ga *irte,
 			  struct amd_ir_data *data)
 {
+	bool ret;
 	struct irq_remap_table *table;
 	struct amd_iommu *iommu;
 	unsigned long flags;
@@ -3300,10 +3301,18 @@ static int modify_irte_ga(u16 devid, int index, struct irte_ga *irte,
 
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
 
-- 
2.25.1



