Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63FB329B53F
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1790005AbgJ0PJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:09:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:45318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2901143AbgJ0PJw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:09:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 192DB206E5;
        Tue, 27 Oct 2020 15:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603811391;
        bh=APSF6J6coTQGI4eyoIWf/KNYs9+w4hYz0qmA4xZKY7M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=akURkkMf9+FO6hd7ehFE0f3qD+IP8G6S383GbbPB+FrVsVdK0yf0FhpiMzyfEccmd
         DN5J3rRsyIU1vGQaRn+3GrOp2qmH4riJgSm7JeaeApQk+2nRpj8ZyIr/KglR9E0sFX
         wbK7M0DvgQfopQU4BARPisftBA8jX3WB6HzgLKls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Steve Capper <steve.capper@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 475/633] arm64: mm: use single quantity to represent the PA to VA translation
Date:   Tue, 27 Oct 2020 14:53:38 +0100
Message-Id: <20201027135545.020600091@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 7bc1a0f9e1765830e945669c99c59c35cf9bca82 ]

On arm64, the global variable memstart_addr represents the physical
address of PAGE_OFFSET, and so physical to virtual translations or
vice versa used to come down to simple additions or subtractions
involving the values of PAGE_OFFSET and memstart_addr.

When support for 52-bit virtual addressing was introduced, we had to
deal with PAGE_OFFSET potentially being outside of the region that
can be covered by the virtual range (as the 52-bit VA capable build
needs to be able to run on systems that are only 48-bit VA capable),
and for this reason, another translation was introduced, and recorded
in the global variable physvirt_offset.

However, if we go back to the original definition of memstart_addr,
i.e., the physical address of PAGE_OFFSET, it turns out that there is
no need for two separate translations: instead, we can simply subtract
the size of the unaddressable VA space from memstart_addr to make the
available physical memory appear in the 48-bit addressable VA region.

This simplifies things, but also fixes a bug on KASLR builds, which
may update memstart_addr later on in arm64_memblock_init(), but fails
to update vmemmap and physvirt_offset accordingly.

Fixes: 5383cc6efed1 ("arm64: mm: Introduce vabits_actual")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Steve Capper <steve.capper@arm.com>
Link: https://lore.kernel.org/r/20201008153602.9467-2-ardb@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/memory.h  |  5 ++---
 arch/arm64/include/asm/pgtable.h |  4 ++--
 arch/arm64/mm/init.c             | 30 ++++++++++--------------------
 3 files changed, 14 insertions(+), 25 deletions(-)

diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index a1871bb32bb17..d207f63eb68e1 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -163,7 +163,6 @@ extern u64			vabits_actual;
 #include <linux/bitops.h>
 #include <linux/mmdebug.h>
 
-extern s64			physvirt_offset;
 extern s64			memstart_addr;
 /* PHYS_OFFSET - the physical address of the start of memory. */
 #define PHYS_OFFSET		({ VM_BUG_ON(memstart_addr & 1); memstart_addr; })
@@ -239,7 +238,7 @@ static inline const void *__tag_set(const void *addr, u8 tag)
  */
 #define __is_lm_address(addr)	(!(((u64)addr) & BIT(vabits_actual - 1)))
 
-#define __lm_to_phys(addr)	(((addr) + physvirt_offset))
+#define __lm_to_phys(addr)	(((addr) & ~PAGE_OFFSET) + PHYS_OFFSET)
 #define __kimg_to_phys(addr)	((addr) - kimage_voffset)
 
 #define __virt_to_phys_nodebug(x) ({					\
@@ -257,7 +256,7 @@ extern phys_addr_t __phys_addr_symbol(unsigned long x);
 #define __phys_addr_symbol(x)	__pa_symbol_nodebug(x)
 #endif /* CONFIG_DEBUG_VIRTUAL */
 
-#define __phys_to_virt(x)	((unsigned long)((x) - physvirt_offset))
+#define __phys_to_virt(x)	((unsigned long)((x) - PHYS_OFFSET) | PAGE_OFFSET)
 #define __phys_to_kimg(x)	((unsigned long)((x) + kimage_voffset))
 
 /*
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 758e2d1577d0c..a1745d6ea4b58 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -23,6 +23,8 @@
 #define VMALLOC_START		(MODULES_END)
 #define VMALLOC_END		(- PUD_SIZE - VMEMMAP_SIZE - SZ_64K)
 
+#define vmemmap			((struct page *)VMEMMAP_START - (memstart_addr >> PAGE_SHIFT))
+
 #define FIRST_USER_ADDRESS	0UL
 
 #ifndef __ASSEMBLY__
@@ -33,8 +35,6 @@
 #include <linux/mm_types.h>
 #include <linux/sched.h>
 
-extern struct page *vmemmap;
-
 extern void __pte_error(const char *file, int line, unsigned long val);
 extern void __pmd_error(const char *file, int line, unsigned long val);
 extern void __pud_error(const char *file, int line, unsigned long val);
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 1e93cfc7c47ad..ca4410eb230a3 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -54,12 +54,6 @@
 s64 memstart_addr __ro_after_init = -1;
 EXPORT_SYMBOL(memstart_addr);
 
-s64 physvirt_offset __ro_after_init;
-EXPORT_SYMBOL(physvirt_offset);
-
-struct page *vmemmap __ro_after_init;
-EXPORT_SYMBOL(vmemmap);
-
 /*
  * We create both ZONE_DMA and ZONE_DMA32. ZONE_DMA covers the first 1G of
  * memory as some devices, namely the Raspberry Pi 4, have peripherals with
@@ -290,20 +284,6 @@ void __init arm64_memblock_init(void)
 	memstart_addr = round_down(memblock_start_of_DRAM(),
 				   ARM64_MEMSTART_ALIGN);
 
-	physvirt_offset = PHYS_OFFSET - PAGE_OFFSET;
-
-	vmemmap = ((struct page *)VMEMMAP_START - (memstart_addr >> PAGE_SHIFT));
-
-	/*
-	 * If we are running with a 52-bit kernel VA config on a system that
-	 * does not support it, we have to offset our vmemmap and physvirt_offset
-	 * s.t. we avoid the 52-bit portion of the direct linear map
-	 */
-	if (IS_ENABLED(CONFIG_ARM64_VA_BITS_52) && (vabits_actual != 52)) {
-		vmemmap += (_PAGE_OFFSET(48) - _PAGE_OFFSET(52)) >> PAGE_SHIFT;
-		physvirt_offset = PHYS_OFFSET - _PAGE_OFFSET(48);
-	}
-
 	/*
 	 * Remove the memory that we will not be able to cover with the
 	 * linear mapping. Take care not to clip the kernel which may be
@@ -318,6 +298,16 @@ void __init arm64_memblock_init(void)
 		memblock_remove(0, memstart_addr);
 	}
 
+	/*
+	 * If we are running with a 52-bit kernel VA config on a system that
+	 * does not support it, we have to place the available physical
+	 * memory in the 48-bit addressable part of the linear region, i.e.,
+	 * we have to move it upward. Since memstart_addr represents the
+	 * physical address of PAGE_OFFSET, we have to *subtract* from it.
+	 */
+	if (IS_ENABLED(CONFIG_ARM64_VA_BITS_52) && (vabits_actual != 52))
+		memstart_addr -= _PAGE_OFFSET(48) - _PAGE_OFFSET(52);
+
 	/*
 	 * Apply the memory limit if it was set. Since the kernel may be loaded
 	 * high up in memory, add back the kernel region that must be accessible
-- 
2.25.1



