Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA47352644C
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 16:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380809AbiEMO3s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 10:29:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380911AbiEMO2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 10:28:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590E05E758;
        Fri, 13 May 2022 07:27:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CC85B82F64;
        Fri, 13 May 2022 14:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A80C34100;
        Fri, 13 May 2022 14:27:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652452058;
        bh=eUszhfq5nFLIZvzwD0M3yu7ZSNAwQpUcPzv5e8oRDkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D7zL1AK8nkDuZSwweQRVIlil5Jh8K2J1NWVoIwJ7LX1FWWy/tCNZP8epJrYvQ+QqU
         N+OPDAU85L+Viiqb6LH5M56aIm96nD1xNwSbTa0hMuQl4hEr3Ctijie60GuDZz69Zn
         f+6WJHvfXz4WdMaZu6Kdr70d3WPKaq3qooL6hduQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Ungerer <gerg@linux-m68k.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Jonathan Corbet <corbet@lwn.net>,
        Matt Turner <mattst88@gmail.com>, Meelis Roos <mroos@linux.ee>,
        Michael Schmitz <schmitzmic@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Tony Luck <tony.luck@intel.com>,
        Vineet Gupta <vgupta@synopsys.com>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kernel test robot <lkp@intel.com>
Subject: [PATCH 5.10 06/10] arm: remove CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
Date:   Fri, 13 May 2022 16:23:50 +0200
Message-Id: <20220513142228.493055262@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513142228.303546319@linuxfoundation.org>
References: <20220513142228.303546319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

commit 5e545df3292fbd3d5963c68980f1527ead2a2b3f upstream.

ARM is the only architecture that defines CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
which in turn enables memmap_valid_within() function that is intended to
verify existence  of struct page associated with a pfn when there are holes
in the memory map.

However, the ARCH_HAS_HOLES_MEMORYMODEL also enables HAVE_ARCH_PFN_VALID
and arch-specific pfn_valid() implementation that also deals with the holes
in the memory map.

The only two users of memmap_valid_within() call this function after
a call to pfn_valid() so the memmap_valid_within() check becomes redundant.

Remove CONFIG_ARCH_HAS_HOLES_MEMORYMODEL and memmap_valid_within() and rely
entirely on ARM's implementation of pfn_valid() that is now enabled
unconditionally.

Link: https://lkml.kernel.org/r/20201101170454.9567-9-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Ungerer <gerg@linux-m68k.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Meelis Roos <mroos@linux.ee>
Cc: Michael Schmitz <schmitzmic@gmail.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Vineet Gupta <vgupta@synopsys.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Fixes: 8dd559d53b3b ("arm: ioremap: don't abuse pfn_valid() to check if pfn is in RAM")
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/vm/memory-model.rst |    3 +--
 arch/arm/Kconfig                  |    8 ++------
 arch/arm/mach-bcm/Kconfig         |    1 -
 arch/arm/mach-davinci/Kconfig     |    1 -
 arch/arm/mach-exynos/Kconfig      |    1 -
 arch/arm/mach-highbank/Kconfig    |    1 -
 arch/arm/mach-omap2/Kconfig       |    1 -
 arch/arm/mach-s5pv210/Kconfig     |    1 -
 arch/arm/mach-tango/Kconfig       |    1 -
 fs/proc/kcore.c                   |    2 --
 include/linux/mmzone.h            |   31 -------------------------------
 mm/mmzone.c                       |   14 --------------
 mm/vmstat.c                       |    4 ----
 13 files changed, 3 insertions(+), 66 deletions(-)

--- a/Documentation/vm/memory-model.rst
+++ b/Documentation/vm/memory-model.rst
@@ -51,8 +51,7 @@ call :c:func:`free_area_init` function.
 usable until the call to :c:func:`memblock_free_all` that hands all the
 memory to the page allocator.
 
-If an architecture enables `CONFIG_ARCH_HAS_HOLES_MEMORYMODEL` option,
-it may free parts of the `mem_map` array that do not cover the
+An architecture may free parts of the `mem_map` array that do not cover the
 actual physical pages. In such case, the architecture specific
 :c:func:`pfn_valid` implementation should take the holes in the
 `mem_map` into account.
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -25,7 +25,7 @@ config ARM
 	select ARCH_HAS_TICK_BROADCAST if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAVE_CUSTOM_GPIO_H
 	select ARCH_HAS_GCOV_PROFILE_ALL
-	select ARCH_KEEP_MEMBLOCK if HAVE_ARCH_PFN_VALID || KEXEC
+	select ARCH_KEEP_MEMBLOCK
 	select ARCH_MIGHT_HAVE_PC_PARPORT
 	select ARCH_NO_SG_CHAIN if !ARM_HAS_SG_CHAIN
 	select ARCH_OPTIONAL_KERNEL_RWX if ARCH_HAS_STRICT_KERNEL_RWX
@@ -521,7 +521,6 @@ config ARCH_S3C24XX
 config ARCH_OMAP1
 	bool "TI OMAP1"
 	depends on MMU
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_OMAP
 	select CLKDEV_LOOKUP
 	select CLKSRC_MMIO
@@ -1481,9 +1480,6 @@ config OABI_COMPAT
 	  UNPREDICTABLE (in fact it can be predicted that it won't work
 	  at all). If in doubt say N.
 
-config ARCH_HAS_HOLES_MEMORYMODEL
-	bool
-
 config ARCH_SELECT_MEMORY_MODEL
 	bool
 
@@ -1495,7 +1491,7 @@ config ARCH_SPARSEMEM_ENABLE
 	select SPARSEMEM_STATIC if SPARSEMEM
 
 config HAVE_ARCH_PFN_VALID
-	def_bool ARCH_HAS_HOLES_MEMORYMODEL || !SPARSEMEM
+	def_bool y
 
 config HIGHMEM
 	bool "High Memory Support"
--- a/arch/arm/mach-bcm/Kconfig
+++ b/arch/arm/mach-bcm/Kconfig
@@ -211,7 +211,6 @@ config ARCH_BRCMSTB
 	select BCM7038_L1_IRQ
 	select BRCMSTB_L2_IRQ
 	select BCM7120_L2_IRQ
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ZONE_DMA if ARM_LPAE
 	select SOC_BRCMSTB
 	select SOC_BUS
--- a/arch/arm/mach-davinci/Kconfig
+++ b/arch/arm/mach-davinci/Kconfig
@@ -5,7 +5,6 @@ menuconfig ARCH_DAVINCI
 	depends on ARCH_MULTI_V5
 	select DAVINCI_TIMER
 	select ZONE_DMA
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select PM_GENERIC_DOMAINS if PM
 	select PM_GENERIC_DOMAINS_OF if PM && OF
 	select REGMAP_MMIO
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -8,7 +8,6 @@
 menuconfig ARCH_EXYNOS
 	bool "Samsung Exynos"
 	depends on ARCH_MULTI_V7
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ARM_AMBA
 	select ARM_GIC
--- a/arch/arm/mach-highbank/Kconfig
+++ b/arch/arm/mach-highbank/Kconfig
@@ -2,7 +2,6 @@
 config ARCH_HIGHBANK
 	bool "Calxeda ECX-1000/2000 (Highbank/Midway)"
 	depends on ARCH_MULTI_V7
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_SUPPORTS_BIG_ENDIAN
 	select ARM_AMBA
 	select ARM_ERRATA_764369 if SMP
--- a/arch/arm/mach-omap2/Kconfig
+++ b/arch/arm/mach-omap2/Kconfig
@@ -93,7 +93,6 @@ config SOC_DRA7XX
 config ARCH_OMAP2PLUS
 	bool
 	select ARCH_HAS_BANDGAP
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARCH_HAS_RESET_CONTROLLER
 	select ARCH_OMAP
 	select CLKSRC_MMIO
--- a/arch/arm/mach-s5pv210/Kconfig
+++ b/arch/arm/mach-s5pv210/Kconfig
@@ -8,7 +8,6 @@
 config ARCH_S5PV210
 	bool "Samsung S5PV210/S5PC110"
 	depends on ARCH_MULTI_V7
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARM_VIC
 	select CLKSRC_SAMSUNG_PWM
 	select COMMON_CLK_SAMSUNG
--- a/arch/arm/mach-tango/Kconfig
+++ b/arch/arm/mach-tango/Kconfig
@@ -3,7 +3,6 @@ config ARCH_TANGO
 	bool "Sigma Designs Tango4 (SMP87xx)"
 	depends on ARCH_MULTI_V7
 	# Cortex-A9 MPCore r3p0, PL310 r3p2
-	select ARCH_HAS_HOLES_MEMORYMODEL
 	select ARM_ERRATA_754322
 	select ARM_ERRATA_764369 if SMP
 	select ARM_ERRATA_775420
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -193,8 +193,6 @@ kclist_add_private(unsigned long pfn, un
 		return 1;
 
 	p = pfn_to_page(pfn);
-	if (!memmap_valid_within(pfn, p, page_zone(p)))
-		return 1;
 
 	ent = kmalloc(sizeof(*ent), GFP_KERNEL);
 	if (!ent)
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1443,37 +1443,6 @@ struct mminit_pfnnid_cache {
 #define pfn_valid_within(pfn) (1)
 #endif
 
-#ifdef CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
-/*
- * pfn_valid() is meant to be able to tell if a given PFN has valid memmap
- * associated with it or not. This means that a struct page exists for this
- * pfn. The caller cannot assume the page is fully initialized in general.
- * Hotplugable pages might not have been onlined yet. pfn_to_online_page()
- * will ensure the struct page is fully online and initialized. Special pages
- * (e.g. ZONE_DEVICE) are never onlined and should be treated accordingly.
- *
- * In FLATMEM, it is expected that holes always have valid memmap as long as
- * there is valid PFNs either side of the hole. In SPARSEMEM, it is assumed
- * that a valid section has a memmap for the entire section.
- *
- * However, an ARM, and maybe other embedded architectures in the future
- * free memmap backing holes to save memory on the assumption the memmap is
- * never used. The page_zone linkages are then broken even though pfn_valid()
- * returns true. A walker of the full memmap must then do this additional
- * check to ensure the memmap they are looking at is sane by making sure
- * the zone and PFN linkages are still valid. This is expensive, but walkers
- * of the full memmap are extremely rare.
- */
-bool memmap_valid_within(unsigned long pfn,
-					struct page *page, struct zone *zone);
-#else
-static inline bool memmap_valid_within(unsigned long pfn,
-					struct page *page, struct zone *zone)
-{
-	return true;
-}
-#endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
-
 #endif /* !__GENERATING_BOUNDS.H */
 #endif /* !__ASSEMBLY__ */
 #endif /* _LINUX_MMZONE_H */
--- a/mm/mmzone.c
+++ b/mm/mmzone.c
@@ -72,20 +72,6 @@ struct zoneref *__next_zones_zonelist(st
 	return z;
 }
 
-#ifdef CONFIG_ARCH_HAS_HOLES_MEMORYMODEL
-bool memmap_valid_within(unsigned long pfn,
-					struct page *page, struct zone *zone)
-{
-	if (page_to_pfn(page) != pfn)
-		return false;
-
-	if (page_zone(page) != zone)
-		return false;
-
-	return true;
-}
-#endif /* CONFIG_ARCH_HAS_HOLES_MEMORYMODEL */
-
 void lruvec_init(struct lruvec *lruvec)
 {
 	enum lru_list lru;
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1503,10 +1503,6 @@ static void pagetypeinfo_showblockcount_
 		if (!page)
 			continue;
 
-		/* Watch for unexpected holes punched in the memmap */
-		if (!memmap_valid_within(pfn, page, zone))
-			continue;
-
 		if (page_zone(page) != zone)
 			continue;
 


