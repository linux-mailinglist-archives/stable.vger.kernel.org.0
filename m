Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5DC50F091
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 08:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243357AbiDZGE1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 02:04:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243283AbiDZGE0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 02:04:26 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFEAC483A4;
        Mon, 25 Apr 2022 23:01:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4832BCE1A7D;
        Tue, 26 Apr 2022 06:01:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C2D9C385A4;
        Tue, 26 Apr 2022 06:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650952876;
        bh=stLEuDXX75MDqjxXONL4N5v+IrSw0sqB7MdOVePbc1Y=;
        h=From:To:Cc:Subject:Date:From;
        b=NRl338cF79FV/h0d5uo38dZiCwHYSURL2dseO3EvJ1RGeZlZ+Sz+1rDkgmFTSv+HQ
         atl6PKDjE4OrFYTugXkSQVdqYDA0kLkMmm6jvE4XOwbvAO/Jib0YUqDJzMoPnSG8P7
         uQFGW5aQJjDhwZqxaz3pm/8DYjLwGvIwQUsPlAgHa2Y5RBqNTsh9MVoIt5zBGJ404M
         auFA3I/Y/msuS3jKE/J9L0f6R+nEfYs0PLEcoKC8hRt8jfHR+3caoJdyi6nSI7oa8R
         XsMbeEPiBiyEKVcbexBYqlsn71ar48pSKWyQ1wO0Ff+8lxoP+ai/CEoge4lDjCS7qg
         Bs2aqvr/RnzIw==
From:   Mike Rapoport <rppt@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guillaume Tucker <gtucker@collabora.com>,
        Mark Brown <broonie@kernel.org>,
        Mark-PK Tsai <mark-pk.tsai@mediatek.com>,
        Mike Rapoport <rppt@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Russell King <linux@armlinux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Will Deacon <will@kernel.org>, bot@kernelci.org,
        kernelci-results@groups.io, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Subject: [PATCH v2] arm[64]/memremap: don't abuse pfn_valid() to ensure presence of linear map
Date:   Tue, 26 Apr 2022 09:01:07 +0300
Message-Id: <20220426060107.7618-1-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>

The semantics of pfn_valid() is to check presence of the memory map for a
PFN and not whether a PFN is covered by the linear map. The memory map may
be present for NOMAP memory regions, but they won't be mapped in the linear
mapping.  Accessing such regions via __va() when they are memremap()'ed
will cause a crash.

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
for_each_mem_range()") changed the way memory regions are registered in the
resource tree, but that merely covers up the problem.

On ARM64 memory resources registered in yet another way and there the
issue of wrong usage of pfn_valid() to ensure availability of the linear
map is also covered.

Implement arch_memremap_can_ram_remap() on ARM and ARM64 to prevent access
to NOMAP regions via the linear mapping in memremap().

Link: https://lore.kernel.org/all/Yl65zxGgFzF1Okac@sirena.org.uk
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Tested-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org	# 5.4+
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
v2: don't remove pfn_valid() from try_ram_remap(), per Ard

 arch/arm/include/asm/io.h   | 3 +++
 arch/arm/mm/ioremap.c       | 8 ++++++++
 arch/arm64/include/asm/io.h | 4 ++++
 arch/arm64/mm/ioremap.c     | 8 ++++++++
 4 files changed, 23 insertions(+)

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

base-commit: b2d229d4ddb17db541098b83524d901257e93845
-- 
2.28.0

