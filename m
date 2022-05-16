Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC253528EC2
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345562AbiEPTrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346581AbiEPTqf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:46:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E0DB41625;
        Mon, 16 May 2022 12:43:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B34D4B815F8;
        Mon, 16 May 2022 19:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60D5C34100;
        Mon, 16 May 2022 19:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730227;
        bh=2ibETPKwgIIv2wrAoTN3HT1EeW+7C+vX3T16lvsfOZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nvbJJYytmXZNiDAKagW1fF0Cnp+hVrj6zfwwcKeopqZhGmnFJbFBALBdNgPY1SdF2
         8YAF+SOmDaf7C9DEcnGMUzpUbLB0QPwF33RKAU78/MGdS7+CXdZQGZWqLFwx9HI7dz
         gDf9O1RIa7VFceYsdmgK5mYpdP9CJ71GkHM/pQyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Rapoport <rppt@linux.ibm.com>,
        "kernelci.org bot" <bot@kernelci.org>,
        Mark Brown <broonie@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 41/43] arm[64]/memremap: dont abuse pfn_valid() to ensure presence of linear map
Date:   Mon, 16 May 2022 21:36:52 +0200
Message-Id: <20220516193615.931480012@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193614.714657361@linuxfoundation.org>
References: <20220516193614.714657361@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Mike Rapoport <rppt@linux.ibm.com>

commit 260364d112bc822005224667c0c9b1b17a53eafd upstream.

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
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/io.h   |    3 +++
 arch/arm/mm/ioremap.c       |    8 ++++++++
 arch/arm64/include/asm/io.h |    4 ++++
 arch/arm64/mm/ioremap.c     |    9 +++++++++
 4 files changed, 24 insertions(+)

--- a/arch/arm/include/asm/io.h
+++ b/arch/arm/include/asm/io.h
@@ -457,6 +457,9 @@ extern void pci_iounmap(struct pci_dev *
 extern int valid_phys_addr_range(phys_addr_t addr, size_t size);
 extern int valid_mmap_phys_addr_range(unsigned long pfn, size_t size);
 extern int devmem_is_allowed(unsigned long pfn);
+extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+					unsigned long flags);
+#define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
 #endif
 
 /*
--- a/arch/arm/mm/ioremap.c
+++ b/arch/arm/mm/ioremap.c
@@ -500,3 +500,11 @@ void __init early_ioremap_init(void)
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
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -204,4 +204,8 @@ extern int valid_mmap_phys_addr_range(un
 
 extern int devmem_is_allowed(unsigned long pfn);
 
+extern bool arch_memremap_can_ram_remap(resource_size_t offset, size_t size,
+					unsigned long flags);
+#define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
+
 #endif	/* __ASM_IO_H */
--- a/arch/arm64/mm/ioremap.c
+++ b/arch/arm64/mm/ioremap.c
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/vmalloc.h>
 #include <linux/io.h>
+#include <linux/memblock.h>
 
 #include <asm/fixmap.h>
 #include <asm/tlbflush.h>
@@ -100,3 +101,11 @@ void __init early_ioremap_init(void)
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


