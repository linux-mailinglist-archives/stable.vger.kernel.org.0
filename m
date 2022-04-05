Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD29B4F2549
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231284AbiDEHs5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233467AbiDEHrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:47:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77402A1462;
        Tue,  5 Apr 2022 00:44:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C86C8B81A22;
        Tue,  5 Apr 2022 07:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33397C340EE;
        Tue,  5 Apr 2022 07:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144651;
        bh=QcVwkp7O9+jJeRmlPsB9ykrIZBzzp/L241o1BMnZ4n8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AOGg/UggbgEI3ML9PdT/3jptExhoTUH3c5clIY4032T25+vz3jAAjWrjhkzYcyCit
         PECW5Fw6CCAJQLIdTiUbgQjanaig0gL322WSJKiSNHsESWDsrCx1DmgsaL7eZaQjBF
         urGHGaTEl7i2vOtXPVAK9TxJkhd48zfGX4erV06Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vijay Balakrishna <vijayb@linux.microsoft.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.17 0121/1126] arm64: Do not defer reserve_crashkernel() for platforms with no DMA memory zones
Date:   Tue,  5 Apr 2022 09:14:28 +0200
Message-Id: <20220405070411.126012691@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vijay Balakrishna <vijayb@linux.microsoft.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/mm/init.c |   36 ++++++++++++++++++++++++++++++++----
 arch/arm64/mm/mmu.c  |   32 +++++++++++++++++++++++++++++++-
 2 files changed, 63 insertions(+), 5 deletions(-)

--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -61,8 +61,34 @@ EXPORT_SYMBOL(memstart_addr);
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
+const phys_addr_t arm64_dma_phys_limit = PHYS_MASK + 1;
+#endif
 
 #ifdef CONFIG_KEXEC_CORE
 /*
@@ -153,8 +179,6 @@ static void __init zone_sizes_init(unsig
 	if (!arm64_dma_phys_limit)
 		arm64_dma_phys_limit = dma32_phys_limit;
 #endif
-	if (!arm64_dma_phys_limit)
-		arm64_dma_phys_limit = PHYS_MASK + 1;
 	max_zone_pfns[ZONE_NORMAL] = max;
 
 	free_area_init(max_zone_pfns);
@@ -315,6 +339,9 @@ void __init arm64_memblock_init(void)
 
 	early_init_fdt_scan_reserved_mem();
 
+	if (!IS_ENABLED(CONFIG_ZONE_DMA) && !IS_ENABLED(CONFIG_ZONE_DMA32))
+		reserve_crashkernel();
+
 	high_memory = __va(memblock_end_of_DRAM() - 1) + 1;
 }
 
@@ -361,7 +388,8 @@ void __init bootmem_init(void)
 	 * request_standard_resources() depends on crashkernel's memory being
 	 * reserved, so do it here.
 	 */
-	reserve_crashkernel();
+	if (IS_ENABLED(CONFIG_ZONE_DMA) || IS_ENABLED(CONFIG_ZONE_DMA32))
+		reserve_crashkernel();
 
 	memblock_dump_all();
 }
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -517,7 +517,7 @@ static void __init map_mem(pgd_t *pgdp)
 	 */
 	BUILD_BUG_ON(pgd_index(direct_map_end - 1) == pgd_index(direct_map_end));
 
-	if (can_set_direct_map() || crash_mem_map || IS_ENABLED(CONFIG_KFENCE))
+	if (can_set_direct_map() || IS_ENABLED(CONFIG_KFENCE))
 		flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
 
 	/*
@@ -528,6 +528,17 @@ static void __init map_mem(pgd_t *pgdp)
 	 */
 	memblock_mark_nomap(kernel_start, kernel_end - kernel_start);
 
+#ifdef CONFIG_KEXEC_CORE
+	if (crash_mem_map) {
+		if (IS_ENABLED(CONFIG_ZONE_DMA) ||
+		    IS_ENABLED(CONFIG_ZONE_DMA32))
+			flags |= NO_BLOCK_MAPPINGS | NO_CONT_MAPPINGS;
+		else if (crashk_res.end)
+			memblock_mark_nomap(crashk_res.start,
+			    resource_size(&crashk_res));
+	}
+#endif
+
 	/* map all the memory banks */
 	for_each_mem_range(i, &start, &end) {
 		if (start >= end)
@@ -554,6 +565,25 @@ static void __init map_mem(pgd_t *pgdp)
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


