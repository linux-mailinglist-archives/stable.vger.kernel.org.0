Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B10F37C681
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhELPvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:51:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236941AbhELPr2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:47:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5CB7A619AF;
        Wed, 12 May 2021 15:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833041;
        bh=8Jv1byH8pEDcCu6qLw4MDq80O6tOSl24r5mQrB4NFYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yjwUj0rOwiBRf/RMSKHS/8VFD9v8GEramw11vP40BAQ7rcUqG4fP9oIXGgB44biO+
         1oSUv/WuMFL3x+VB2E+hC8FFufzn2VyRSqiNhVItGxKabwBIWt5NuNWNIZo+AvNNcF
         0AZyv/rUsvr+DHfD8l6zyBwBvVLGyFLs813HFFxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Chen Zhou <chenzhou10@huawei.com>,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 5.10 526/530] arm64: Remove arm64_dma32_phys_limit and its uses
Date:   Wed, 12 May 2021 16:50:36 +0200
Message-Id: <20210512144837.032472076@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>

commit d78050ee35440d7879ed94011c52994b8932e96e upstream.

With the introduction of a dynamic ZONE_DMA range based on DT or IORT
information, there's no need for CMA allocations from the wider
ZONE_DMA32 since on most platforms ZONE_DMA will cover the 32-bit
addressable range. Remove the arm64_dma32_phys_limit and set
arm64_dma_phys_limit to cover the smallest DMA range required on the
platform. CMA allocation and crashkernel reservation now go in the
dynamically sized ZONE_DMA, allowing correct functionality on RPi4.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Zhou <chenzhou10@huawei.com>
Reviewed-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Tested-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de> # On RPi4B
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/processor.h |    3 +--
 arch/arm64/mm/init.c               |   33 ++++++++++++++++++---------------
 2 files changed, 19 insertions(+), 17 deletions(-)

--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -96,8 +96,7 @@
 #endif /* CONFIG_ARM64_FORCE_52BIT */
 
 extern phys_addr_t arm64_dma_phys_limit;
-extern phys_addr_t arm64_dma32_phys_limit;
-#define ARCH_LOW_ADDRESS_LIMIT	((arm64_dma_phys_limit ? : arm64_dma32_phys_limit) - 1)
+#define ARCH_LOW_ADDRESS_LIMIT	(arm64_dma_phys_limit - 1)
 
 struct debug_info {
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -53,13 +53,13 @@ s64 memstart_addr __ro_after_init = -1;
 EXPORT_SYMBOL(memstart_addr);
 
 /*
- * We create both ZONE_DMA and ZONE_DMA32. ZONE_DMA covers the first 1G of
- * memory as some devices, namely the Raspberry Pi 4, have peripherals with
- * this limited view of the memory. ZONE_DMA32 will cover the rest of the 32
- * bit addressable memory area.
+ * If the corresponding config options are enabled, we create both ZONE_DMA
+ * and ZONE_DMA32. By default ZONE_DMA covers the 32-bit addressable memory
+ * unless restricted on specific platforms (e.g. 30-bit on Raspberry Pi 4).
+ * In such case, ZONE_DMA32 covers the rest of the 32-bit addressable memory,
+ * otherwise it is empty.
  */
 phys_addr_t arm64_dma_phys_limit __ro_after_init;
-phys_addr_t arm64_dma32_phys_limit __ro_after_init;
 
 #ifdef CONFIG_KEXEC_CORE
 /*
@@ -84,7 +84,7 @@ static void __init reserve_crashkernel(v
 
 	if (crash_base == 0) {
 		/* Current arm64 boot protocol requires 2MB alignment */
-		crash_base = memblock_find_in_range(0, arm64_dma32_phys_limit,
+		crash_base = memblock_find_in_range(0, arm64_dma_phys_limit,
 				crash_size, SZ_2M);
 		if (crash_base == 0) {
 			pr_warn("cannot allocate crashkernel (size:0x%llx)\n",
@@ -189,6 +189,7 @@ static void __init zone_sizes_init(unsig
 	unsigned long max_zone_pfns[MAX_NR_ZONES]  = {0};
 	unsigned int __maybe_unused acpi_zone_dma_bits;
 	unsigned int __maybe_unused dt_zone_dma_bits;
+	phys_addr_t __maybe_unused dma32_phys_limit = max_zone_phys(32);
 
 #ifdef CONFIG_ZONE_DMA
 	acpi_zone_dma_bits = fls64(acpi_iort_dma_get_max_cpu_address());
@@ -198,8 +199,12 @@ static void __init zone_sizes_init(unsig
 	max_zone_pfns[ZONE_DMA] = PFN_DOWN(arm64_dma_phys_limit);
 #endif
 #ifdef CONFIG_ZONE_DMA32
-	max_zone_pfns[ZONE_DMA32] = PFN_DOWN(arm64_dma32_phys_limit);
+	max_zone_pfns[ZONE_DMA32] = PFN_DOWN(dma32_phys_limit);
+	if (!arm64_dma_phys_limit)
+		arm64_dma_phys_limit = dma32_phys_limit;
 #endif
+	if (!arm64_dma_phys_limit)
+		arm64_dma_phys_limit = PHYS_MASK + 1;
 	max_zone_pfns[ZONE_NORMAL] = max;
 
 	free_area_init(max_zone_pfns);
@@ -393,16 +398,9 @@ void __init arm64_memblock_init(void)
 
 	early_init_fdt_scan_reserved_mem();
 
-	if (IS_ENABLED(CONFIG_ZONE_DMA32))
-		arm64_dma32_phys_limit = max_zone_phys(32);
-	else
-		arm64_dma32_phys_limit = PHYS_MASK + 1;
-
 	reserve_elfcorehdr();
 
 	high_memory = __va(memblock_end_of_DRAM() - 1) + 1;
-
-	dma_contiguous_reserve(arm64_dma32_phys_limit);
 }
 
 void __init bootmem_init(void)
@@ -438,6 +436,11 @@ void __init bootmem_init(void)
 	zone_sizes_init(min, max);
 
 	/*
+	 * Reserve the CMA area after arm64_dma_phys_limit was initialised.
+	 */
+	dma_contiguous_reserve(arm64_dma_phys_limit);
+
+	/*
 	 * request_standard_resources() depends on crashkernel's memory being
 	 * reserved, so do it here.
 	 */
@@ -519,7 +522,7 @@ static void __init free_unused_memmap(vo
 void __init mem_init(void)
 {
 	if (swiotlb_force == SWIOTLB_FORCE ||
-	    max_pfn > PFN_DOWN(arm64_dma_phys_limit ? : arm64_dma32_phys_limit))
+	    max_pfn > PFN_DOWN(arm64_dma_phys_limit))
 		swiotlb_init(1);
 	else
 		swiotlb_force = SWIOTLB_NO_FORCE;


