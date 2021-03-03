Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA7532BC25
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444375AbhCCNlQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:41:16 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:13421 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240598AbhCCHVX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 02:21:23 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4Dr5360CqdzjT8c;
        Wed,  3 Mar 2021 15:19:14 +0800 (CST)
Received: from ubuntu-82.huawei.com (10.175.104.82) by
 DGGEMS408-HUB.china.huawei.com (10.3.19.208) with Microsoft SMTP Server id
 14.3.498.0; Wed, 3 Mar 2021 15:20:26 +0800
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
To:     <gregkh@linuxfoundation.org>, <catalin.marinas@arm.com>,
        <will@kernel.org>, <akpm@linux-foundation.org>,
        <nsaenzjulienne@suse.de>, <paul.walmsley@sifive.com>,
        <palmer@dabbelt.com>, <aou@eecs.berkeley.edu>, <rppt@kernel.org>,
        <lorenzo.pieralisi@arm.com>, <guohanjun@huawei.com>,
        <sudeep.holla@arm.com>, <rjw@rjwysocki.net>, <lenb@kernel.org>,
        <song.bao.hua@hisilicon.com>, <ardb@kernel.org>,
        <anshuman.khandual@arm.com>, <bhelgaas@google.com>, <guro@fb.com>,
        <robh+dt@kernel.org>
CC:     <stable@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <frowand.list@gmail.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-riscv@lists.infradead.org>, <jingxiangfeng@huawei.com>,
        <wangkefeng.wang@huawei.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Christoph Hellwig <hch@lst.de>,
        Robin Murphy <robin.murphy@arm.com>
Subject: [PATCH stable v5.10 6/7] arm64: mm: Set ZONE_DMA size based on early IORT scan
Date:   Wed, 3 Mar 2021 15:33:18 +0800
Message-ID: <20210303073319.2215839-7-jingxiangfeng@huawei.com>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20210303073319.2215839-1-jingxiangfeng@huawei.com>
References: <20210303073319.2215839-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit 2b8652936f0ca9ca2e6c984ae76c7bfcda1b3f22 upstream

We recently introduced a 1 GB sized ZONE_DMA to cater for platforms
incorporating masters that can address less than 32 bits of DMA, in
particular the Raspberry Pi 4, which has 4 or 8 GB of DRAM, but has
peripherals that can only address up to 1 GB (and its PCIe host
bridge can only access the bottom 3 GB)

Instructing the DMA layer about these limitations is straight-forward,
even though we had to fix some issues regarding memory limits set in
the IORT for named components, and regarding the handling of ACPI _DMA
methods. However, the DMA layer also needs to be able to allocate
memory that is guaranteed to meet those DMA constraints, for bounce
buffering as well as allocating the backing for consistent mappings.

This is why the 1 GB ZONE_DMA was introduced recently. Unfortunately,
it turns out the having a 1 GB ZONE_DMA as well as a ZONE_DMA32 causes
problems with kdump, and potentially in other places where allocations
cannot cross zone boundaries. Therefore, we should avoid having two
separate DMA zones when possible.

So let's do an early scan of the IORT, and only create the ZONE_DMA
if we encounter any devices that need it. This puts the burden on
the firmware to describe such limitations in the IORT, which may be
redundant (and less precise) if _DMA methods are also being provided.
However, it should be noted that this situation is highly unusual for
arm64 ACPI machines. Also, the DMA subsystem still gives precedence to
the _DMA method if implemented, and so we will not lose the ability to
perform streaming DMA outside the ZONE_DMA if the _DMA method permits
it.

[nsaenz: unified implementation with DT's counterpart]

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Tested-by: Jeremy Linton <jeremy.linton@arm.com>
Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Acked-by: Hanjun Guo <guohanjun@huawei.com>
Cc: Jeremy Linton <jeremy.linton@arm.com>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Cc: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Sudeep Holla <sudeep.holla@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Link: https://lore.kernel.org/r/20201119175400.9995-7-nsaenzjulienne@suse.de
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 arch/arm64/mm/init.c      |  5 +++-
 drivers/acpi/arm64/iort.c | 55 +++++++++++++++++++++++++++++++++++++++
 include/linux/acpi_iort.h |  4 +++
 3 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 05a1c2773629..b913844ab740 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -29,6 +29,7 @@
 #include <linux/kexec.h>
 #include <linux/crash_dump.h>
 #include <linux/hugetlb.h>
+#include <linux/acpi_iort.h>
 
 #include <asm/boot.h>
 #include <asm/fixmap.h>
@@ -186,11 +187,13 @@ static phys_addr_t __init max_zone_phys(unsigned int zone_bits)
 static void __init zone_sizes_init(unsigned long min, unsigned long max)
 {
 	unsigned long max_zone_pfns[MAX_NR_ZONES]  = {0};
+	unsigned int __maybe_unused acpi_zone_dma_bits;
 	unsigned int __maybe_unused dt_zone_dma_bits;
 
 #ifdef CONFIG_ZONE_DMA
+	acpi_zone_dma_bits = fls64(acpi_iort_dma_get_max_cpu_address());
 	dt_zone_dma_bits = fls64(of_dma_get_max_cpu_address(NULL));
-	zone_dma_bits = min(32U, dt_zone_dma_bits);
+	zone_dma_bits = min3(32U, dt_zone_dma_bits, acpi_zone_dma_bits);
 	arm64_dma_phys_limit = max_zone_phys(zone_dma_bits);
 	max_zone_pfns[ZONE_DMA] = PFN_DOWN(arm64_dma_phys_limit);
 #endif
diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 94f34109695c..2494138a6905 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -1730,3 +1730,58 @@ void __init acpi_iort_init(void)
 
 	iort_init_platform_devices();
 }
+
+#ifdef CONFIG_ZONE_DMA
+/*
+ * Extract the highest CPU physical address accessible to all DMA masters in
+ * the system. PHYS_ADDR_MAX is returned when no constrained device is found.
+ */
+phys_addr_t __init acpi_iort_dma_get_max_cpu_address(void)
+{
+	phys_addr_t limit = PHYS_ADDR_MAX;
+	struct acpi_iort_node *node, *end;
+	struct acpi_table_iort *iort;
+	acpi_status status;
+	int i;
+
+	if (acpi_disabled)
+		return limit;
+
+	status = acpi_get_table(ACPI_SIG_IORT, 0,
+				(struct acpi_table_header **)&iort);
+	if (ACPI_FAILURE(status))
+		return limit;
+
+	node = ACPI_ADD_PTR(struct acpi_iort_node, iort, iort->node_offset);
+	end = ACPI_ADD_PTR(struct acpi_iort_node, iort, iort->header.length);
+
+	for (i = 0; i < iort->node_count; i++) {
+		if (node >= end)
+			break;
+
+		switch (node->type) {
+			struct acpi_iort_named_component *ncomp;
+			struct acpi_iort_root_complex *rc;
+			phys_addr_t local_limit;
+
+		case ACPI_IORT_NODE_NAMED_COMPONENT:
+			ncomp = (struct acpi_iort_named_component *)node->node_data;
+			local_limit = DMA_BIT_MASK(ncomp->memory_address_limit);
+			limit = min_not_zero(limit, local_limit);
+			break;
+
+		case ACPI_IORT_NODE_PCI_ROOT_COMPLEX:
+			if (node->revision < 1)
+				break;
+
+			rc = (struct acpi_iort_root_complex *)node->node_data;
+			local_limit = DMA_BIT_MASK(rc->memory_address_limit);
+			limit = min_not_zero(limit, local_limit);
+			break;
+		}
+		node = ACPI_ADD_PTR(struct acpi_iort_node, node, node->length);
+	}
+	acpi_put_table(&iort->header);
+	return limit;
+}
+#endif
diff --git a/include/linux/acpi_iort.h b/include/linux/acpi_iort.h
index 20a32120bb88..1a12baa58e40 100644
--- a/include/linux/acpi_iort.h
+++ b/include/linux/acpi_iort.h
@@ -38,6 +38,7 @@ void iort_dma_setup(struct device *dev, u64 *dma_addr, u64 *size);
 const struct iommu_ops *iort_iommu_configure_id(struct device *dev,
 						const u32 *id_in);
 int iort_iommu_msi_get_resv_regions(struct device *dev, struct list_head *head);
+phys_addr_t acpi_iort_dma_get_max_cpu_address(void);
 #else
 static inline void acpi_iort_init(void) { }
 static inline u32 iort_msi_map_id(struct device *dev, u32 id)
@@ -55,6 +56,9 @@ static inline const struct iommu_ops *iort_iommu_configure_id(
 static inline
 int iort_iommu_msi_get_resv_regions(struct device *dev, struct list_head *head)
 { return 0; }
+
+static inline phys_addr_t acpi_iort_dma_get_max_cpu_address(void)
+{ return PHYS_ADDR_MAX; }
 #endif
 
 #endif /* __ACPI_IORT_H__ */
-- 
2.25.1

