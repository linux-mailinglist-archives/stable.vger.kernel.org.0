Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE5024F2100
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 06:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbiDEChB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 22:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbiDEChA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 22:37:00 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41E1120035E
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 18:34:00 -0700 (PDT)
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
        by linux.microsoft.com (Postfix) with ESMTPSA id 44AE220DFD52;
        Mon,  4 Apr 2022 17:46:19 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 44AE220DFD52
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1649119579;
        bh=5aA/vTQUXUFqUfEHeY9nMqS4L5W1ZuZWh5nMb07rDo8=;
        h=From:To:Cc:Subject:Date:From;
        b=H7zHIjbE/l4OJTGU2ZyzNwmXfjrxb/5Gn38V058fSnVVr+nQ9uCT5SRuY1/vreZDd
         UdsdFbQbdu5oMnfPbbsCEaxlraYrXffeTKnPvBlLjgOPMdwV6S/NzKcdiAKcTWGD9h
         D+13vIVmF98l8oNudh8WMgyIdmLOnBBJ1sNtoFR8=
From:   Vijay Balakrishna <vijayb@linux.microsoft.com>
To:     <stable@vger.kernel.org>
Cc:     Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Pavel Tatashin <pasha.tatashin@soleen.com>,
        Vijay Balakrishna <vijayb@linux.microsoft.com>
Subject: [PATCH 5.10] arm64: Do not defer reserve_crashkernel() for platforms with no DMA memory zones
Date:   Mon,  4 Apr 2022 17:46:10 -0700
Message-Id: <1649119570-26089-1-git-send-email-vijayb@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-16.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DOS_RCVD_IP_TWICE_B,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 031495635b4668f94e964e037ca93d0d38bfde58 upstream.

The following patches resulted in deferring crash kernel reservation to
mem_init(), mainly aimed at platforms with DMA memory zones (no IOMMU),
in particular Raspberry Pi 4.

commit 1a8e1cef7603 ("arm64: use both ZONE_DMA and ZONE_DMA32")
commit 8424ecdde7df ("arm64: mm: Set ZONE_DMA size based on devicetree's dma-ranges")
commit 0a30c53573b0 ("arm64: mm: Move reserve_crashkernel() into mem_init()")
commit 2687275a5843 ("arm64: Force NO_BLOCK_MAPPINGS if crashkernel reservation is required")

Above changes introduced boot slowdown due to linear map creation for
all the memory banks with NO_BLOCK_MAPPINGS, see discussion[1].  The proposed
changes restore crash kernel reservation to earlier behavior thus avoids
slow boot, particularly for platforms with IOMMU (no DMA memory zones).

Tested changes to confirm no ~150ms boot slowdown on our SoC with IOMMU
and 8GB memory.  Also tested with ZONE_DMA and/or ZONE_DMA32 configs to confirm
no regression to deferring scheme of crash kernel memory reservation.
In both cases successfully collected kernel crash dump.

[1] https://lore.kernel.org/all/9436d033-579b-55fa-9b00-6f4b661c2dd7@linux.microsoft.com/

Signed-off-by: Vijay Balakrishna <vijayb@linux.microsoft.com>
Cc: stable@vger.kernel.org
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Link: https://lore.kernel.org/r/1646242689-20744-1-git-send-email-vijayb@linux.microsoft.com
[will: Add #ifdef CONFIG_KEXEC_CORE guards to fix 'crashk_res' references in allnoconfig build]
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/mm/init.c | 36 ++++++++++++++++++++++++++++++++----
 arch/arm64/mm/mmu.c  | 32 +++++++++++++++++++++++++++++++-
 2 files changed, 63 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index c0a7f0d90b39..80cc79760e8e 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -58,8 +58,34 @@ EXPORT_SYMBOL(memstart_addr);
  * unless restricted on specific platforms (e.g. 30-bit on Raspberry Pi 4).
  * In such case, ZONE_DMA32 covers the rest of the 32-bit addressable memory,
  * otherwise it is empty.
+ *
+ * Memory reservation for crash kernel either done early or deferred
+ * depending on DMA memory zones configs (ZONE_DMA) --
+ *
+ * In absence of ZONE_DMA configs arm64_dma_phys_limit initialized
+ * here instead of max_zone_phys().  This lets early reservation of
+ * crash kernel memory which has a dependency on arm64_dma_phys_limit.
+ * Reserving memory early for crash kernel allows linear creation of block
+ * mappings (greater than page-granularity) for all the memory bank rangs.
+ * In this scheme a comparatively quicker boot is observed.
+ *
+ * If ZONE_DMA configs are defined, crash kernel memory reservation
+ * is delayed until DMA zone memory range size initilazation performed in
+ * zone_sizes_init().  The defer is necessary to steer clear of DMA zone
+ * memory range to avoid overlap allocation.  So crash kernel memory boundaries
+ * are not known when mapping all bank memory ranges, which otherwise means
+ * not possible to exclude crash kernel range from creating block mappings
+ * so page-granularity mappings are created for the entire memory range.
+ * Hence a slightly slower boot is observed.
+ *
+ * Note: Page-granularity mapppings are necessary for crash kernel memory
+ * range for shrinking its size via /sys/kernel/kexec_crash_size interface.
  */
-phys_addr_t arm64_dma_phys_limit __ro_after_init;
+#if IS_ENABLED(CONFIG_ZONE_DMA) || IS_ENABLED(CONFIG_ZONE_DMA32)
+phys_addr_t __ro_after_init arm64_dma_phys_limit;
+#else
+phys_addr_t __ro_after_init arm64_dma_phys_limit = PHYS_MASK + 1;
+#endif
 
 #ifdef CONFIG_KEXEC_CORE
 /*
@@ -210,8 +236,6 @@ static void __init zone_sizes_init(unsigned long min, unsigned long max)
 	if (!arm64_dma_phys_limit)
 		arm64_dma_phys_limit = dma32_phys_limit;
 #endif
-	if (!arm64_dma_phys_limit)
-		arm64_dma_phys_limit = PHYS_MASK + 1;
 	max_zone_pfns[ZONE_NORMAL] = max;
 
 	free_area_init(max_zone_pfns);
@@ -407,6 +431,9 @@ void __init arm64_memblock_init(void)
 
 	reserve_elfcorehdr();
 
+	if (!IS_ENABLED(CONFIG_ZONE_DMA) && !IS_ENABLED(CONFIG_ZONE_DMA32))
+		reserve_crashkernel();
+
 	high_memory = __va(memblock_end_of_DRAM() - 1) + 1;
 }
 
@@ -451,7 +478,8 @@ void __init bootmem_init(void)
 	 * request_standard_resources() depends on crashkernel's memory being
 	 * reserved, so do it here.
 	 */
-	reserve_crashkernel();
+	if (IS_ENABLED(CONFIG_ZONE_DMA) || IS_ENABLED(CONFIG_ZONE_DMA32))
+		reserve_crashkernel();
 
 	memblock_dump_all();
 }
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 991e599f7057..993be1e31c49 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -492,7 +492,7 @@ static void __init map_mem(pgd_t *pgdp)
 	int flags = 0;
 	u64 i;
 
-	if (rodata_full || crash_mem_map || debug_pagealloc_enabled())
+	if (rodata_full || debug_pagealloc_enabled())
 		flags = NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
@@ -503,6 +503,17 @@ static void __init map_mem(pgd_t *pgdp)
 	 */
 	memblock_mark_nomap(kernel_start, kernel_end - kernel_start);
 
+#ifdef CONFIG_KEXEC_CORE
+	if (crash_mem_map) {
+		if (IS_ENABLED(CONFIG_ZONE_DMA) ||
+		    IS_ENABLED(CONFIG_ZONE_DMA32))
+			flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
+		else if (crashk_res.end)
+			memblock_mark_nomap(crashk_res.start,
+					    resource_size(&crashk_res));
+	}
+#endif
+
 	/* map all the memory banks */
 	for_each_mem_range(i, &start, &end) {
 		if (start >= end)
@@ -529,6 +540,25 @@ static void __init map_mem(pgd_t *pgdp)
 	__map_memblock(pgdp, kernel_start, kernel_end,
 		       PAGE_KERNEL, NO_CONT_MAPPINGS);
 	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
+
+	/*
+	 * Use page-level mappings here so that we can shrink the region
+	 * in page granularity and put back unused memory to buddy system
+	 * through /sys/kernel/kexec_crash_size interface.
+	 */
+#ifdef CONFIG_KEXEC_CORE
+	if (crash_mem_map &&
+	    !IS_ENABLED(CONFIG_ZONE_DMA) && !IS_ENABLED(CONFIG_ZONE_DMA32)) {
+		if (crashk_res.end) {
+			__map_memblock(pgdp, crashk_res.start,
+				       crashk_res.end + 1,
+				       PAGE_KERNEL,
+				       NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS);
+			memblock_clear_nomap(crashk_res.start,
+					     resource_size(&crashk_res));
+		}
+	}
+#endif
 }
 
 void mark_rodata_ro(void)
-- 
2.35.1

