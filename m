Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0BCB527F69
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 10:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241551AbiEPIRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 04:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241560AbiEPIRO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 04:17:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A285736E1E
        for <stable@vger.kernel.org>; Mon, 16 May 2022 01:17:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 40821611CA
        for <stable@vger.kernel.org>; Mon, 16 May 2022 08:17:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E2BC385AA;
        Mon, 16 May 2022 08:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652689032;
        bh=IWEjrWwezYjFz5VfnoZbaCdDIVqlEcPBjlaqo3/sg9s=;
        h=Subject:To:Cc:From:Date:From;
        b=PajFnxgXbdOgdSt2SGgiJ3EeIdDey5+I9+rx6c/bNQUtBQwrIlxW4i7P6KP28IYdN
         KkhQdJcaFBo0Po6auGZW39hkuzk5nOHYPOS2+A1xbc79l/odwt3AvicytYAl+uBbsO
         OUHrllbZoUy2zpVF9w2lDmIZQovjd8Q4rjyLcGKs=
Subject: FAILED: patch "[PATCH] arm[64]/memremap: don't abuse pfn_valid() to ensure presence" failed to apply to 4.9-stable tree
To:     rppt@kernel.org, akpm@linux-foundation.org, ardb@kernel.org,
        bot@kernelci.org, broonie@kernel.org, catalin.marinas@arm.com,
        gregkh@linuxfoundation.org, linux@armlinux.org.uk,
        mark-pk.tsai@mediatek.com, rppt@linux.ibm.com,
        stable@vger.kernel.org, tony@atomide.com, will@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 16 May 2022 10:17:02 +0200
Message-ID: <165268902225046@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 260364d112bc822005224667c0c9b1b17a53eafd Mon Sep 17 00:00:00 2001
From: Mike Rapoport <rppt@kernel.org>
Date: Mon, 9 May 2022 17:34:28 -0700
Subject: [PATCH] arm[64]/memremap: don't abuse pfn_valid() to ensure presence
 of linear map

The semantics of pfn_valid() is to check presence of the memory map for a
PFN and not whether a PFN is covered by the linear map.  The memory map
may be present for NOMAP memory regions, but they won't be mapped in the
linear mapping.  Accessing such regions via __va() when they are
memremap()'ed will cause a crash.

On v5.4.y the crash happens on qemu-arm with UEFI [1]:

<1>[    0.084476] 8<--- cut here ---
<1>[    0.084595] Unable to handle kernel paging request at virtual address dfb76000
<1>[    0.084938] pgd = (ptrval)
<1>[    0.085038] [dfb76000] *pgd=5f7fe801, *pte=00000000, *ppte=00000000

...

<4>[    0.093923] [<c0ed6ce8>] (memcpy) from [<c16a06f8>] (dmi_setup+0x60/0x418)
<4>[    0.094204] [<c16a06f8>] (dmi_setup) from [<c16a38d4>] (arm_dmi_init+0x8/0x10)
<4>[    0.094408] [<c16a38d4>] (arm_dmi_init) from [<c0302e9c>] (do_one_initcall+0x50/0x228)
<4>[    0.094619] [<c0302e9c>] (do_one_initcall) from [<c16011e4>] (kernel_init_freeable+0x15c/0x1f8)
<4>[    0.094841] [<c16011e4>] (kernel_init_freeable) from [<c0f028cc>] (kernel_init+0x8/0x10c)
<4>[    0.095057] [<c0f028cc>] (kernel_init) from [<c03010e8>] (ret_from_fork+0x14/0x2c)

On kernels v5.10.y and newer the same crash won't reproduce on ARM because
commit b10d6bca8720 ("arch, drivers: replace for_each_membock() with
for_each_mem_range()") changed the way memory regions are registered in
the resource tree, but that merely covers up the problem.

On ARM64 memory resources registered in yet another way and there the
issue of wrong usage of pfn_valid() to ensure availability of the linear
map is also covered.

Implement arch_memremap_can_ram_remap() on ARM and ARM64 to prevent access
to NOMAP regions via the linear mapping in memremap().

Link: https://lore.kernel.org/all/Yl65zxGgFzF1Okac@sirena.org.uk
Link: https://lkml.kernel.org/r/20220426060107.7618-1-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Tested-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Mark-PK Tsai <mark-pk.tsai@mediatek.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Tony Lindgren <tony@atomide.com>
Cc: Will Deacon <will@kernel.org>
Cc: <stable@vger.kernel.org>	[5.4+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/arch/arm/include/asm/io.h b/arch/arm/include/asm/io.h
index 0c70eb688a00..2a0739a2350b 100644
--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -440,6 +440,9 @@ extern void pci_iounmap(struct pci_dev *dev, void __iomem *addr);
 #define ARCH_HAS_VALID_PHYS_ADDR_RANGE
 extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
 extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
+extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+					unsigned long flags);
+#define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
 #endif
 
 /*
diff --git a/arch/arm/mm/ioremap.c b/arch/arm/mm/ioremap.c
index aa08bcb72db9..290702328a33 100644
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -493,3 +493,11 @@ void __init early_ioremap_init(void)
 {
 	early_ioremap_setup();
 }
+
+bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+				 unsigned long flags)
+{
+	unsigned long pfn = PHYS_PFN(offset);
+
+	return memblock_is_map_memory(pfn);
+}
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 7fd836bea7eb..3995652daf81 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -192,4 +192,8 @@ extern void __iomem *ioremap_cache(phys_addr_t phys_addr, size_t size);
 extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
 extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
 
+extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+					unsigned long flags);
+#define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
+
 #endif	/* __ASM_IO_H */
diff --git a/arch/arm64/mm/ioremap.c b/arch/arm64/mm/ioremap.c
index b7c81dacabf0..b21f91cd830d 100644
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -99,3 +99,11 @@ void __init early_ioremap_init(void)
 {
 	early_ioremap_setup();
 }
+
+bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+				 unsigned long flags)
+{
+	unsigned long pfn = PHYS_PFN(offset);
+
+	return pfn_is_map_memory(pfn);
+}

