Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2815F3E4408
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 12:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234061AbhHIKmg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 06:42:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35224 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234201AbhHIKmf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 06:42:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAD5D60F9F;
        Mon,  9 Aug 2021 10:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628505735;
        bh=cYFsKQk03W4vbmQ5qtntXCtYQwJWIEu1lFpvH7SxxZ4=;
        h=Subject:To:Cc:From:Date:From;
        b=aCY36WCnKSvCF82YvIDHx5XJSWxZAYW9CE4cV2XehQgG9xFk8Kfi7EE1Fam6fPB+k
         hHC1E5bYHMytbLU8jwcwoPbSMpf8l3TH/HvCpTN7ysPF4XbFFw5c/0/Ale4DXUD225
         rPmbmRBTugHx+/+skpzn0OSc9jJaV5S61ayMlcr0=
Subject: FAILED: patch "[PATCH] riscv: Get rid of CONFIG_PHYS_RAM_BASE in kernel physical" failed to apply to 5.13-stable tree
To:     alex@ghiti.fr, jszhang@kernel.org, kernel@esmil.dk,
        palmerdabbelt@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 09 Aug 2021 12:42:13 +0200
Message-ID: <1628505733235131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6d7f91d914bc90a15ebc426440c26081337ceaa1 Mon Sep 17 00:00:00 2001
From: Alexandre Ghiti <alex@ghiti.fr>
Date: Wed, 21 Jul 2021 09:59:35 +0200
Subject: [PATCH] riscv: Get rid of CONFIG_PHYS_RAM_BASE in kernel physical
 address conversion

The usage of CONFIG_PHYS_RAM_BASE for all kernel types was a mistake:
this value is implementation-specific and this breaks the genericity of
the RISC-V kernel.

Fix this by introducing a new variable phys_ram_base that holds this
value at runtime and use it in the kernel physical address conversion
macro. Since this value is used only for XIP kernels, evaluate it only if
CONFIG_XIP_KERNEL is set which in addition optimizes this macro for
standard kernels at compile-time.

Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
Tested-by: Emil Renner Berthing <kernel@esmil.dk>
Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
Fixes: 44c922572952 ("RISC-V: enable XIP")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>

diff --git a/arch/riscv/include/asm/page.h b/arch/riscv/include/asm/page.h
index cca8764aed83..b0ca5058e7ae 100644
--- a/arch/riscv/include/asm/page.h
+++ b/arch/riscv/include/asm/page.h
@@ -103,6 +103,7 @@ struct kernel_mapping {
 };
 
 extern struct kernel_mapping kernel_map;
+extern phys_addr_t phys_ram_base;
 
 #ifdef CONFIG_64BIT
 #define is_kernel_mapping(x)	\
@@ -113,9 +114,9 @@ extern struct kernel_mapping kernel_map;
 #define linear_mapping_pa_to_va(x)	((void *)((unsigned long)(x) + kernel_map.va_pa_offset))
 #define kernel_mapping_pa_to_va(y)	({						\
 	unsigned long _y = y;								\
-	(_y >= CONFIG_PHYS_RAM_BASE) ?							\
-		(void *)((unsigned long)(_y) + kernel_map.va_kernel_pa_offset + XIP_OFFSET) :	\
-		(void *)((unsigned long)(_y) + kernel_map.va_kernel_xip_pa_offset);		\
+	(IS_ENABLED(CONFIG_XIP_KERNEL) && _y < phys_ram_base) ?					\
+		(void *)((unsigned long)(_y) + kernel_map.va_kernel_xip_pa_offset) :		\
+		(void *)((unsigned long)(_y) + kernel_map.va_kernel_pa_offset + XIP_OFFSET);	\
 	})
 #define __pa_to_va_nodebug(x)		linear_mapping_pa_to_va(x)
 
diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index a14bf3910eec..88134cc288d9 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -36,6 +36,9 @@ EXPORT_SYMBOL(kernel_map);
 #define kernel_map	(*(struct kernel_mapping *)XIP_FIXUP(&kernel_map))
 #endif
 
+phys_addr_t phys_ram_base __ro_after_init;
+EXPORT_SYMBOL(phys_ram_base);
+
 #ifdef CONFIG_XIP_KERNEL
 extern char _xiprom[], _exiprom[];
 #endif
@@ -160,7 +163,7 @@ static void __init setup_bootmem(void)
 	phys_addr_t vmlinux_end = __pa_symbol(&_end);
 	phys_addr_t vmlinux_start = __pa_symbol(&_start);
 	phys_addr_t __maybe_unused max_mapped_addr;
-	phys_addr_t dram_end;
+	phys_addr_t phys_ram_end;
 
 #ifdef CONFIG_XIP_KERNEL
 	vmlinux_start = __pa_symbol(&_sdata);
@@ -181,9 +184,12 @@ static void __init setup_bootmem(void)
 #endif
 	memblock_reserve(vmlinux_start, vmlinux_end - vmlinux_start);
 
-	dram_end = memblock_end_of_DRAM();
 
+	phys_ram_end = memblock_end_of_DRAM();
 #ifndef CONFIG_64BIT
+#ifndef CONFIG_XIP_KERNEL
+	phys_ram_base = memblock_start_of_DRAM();
+#endif
 	/*
 	 * memblock allocator is not aware of the fact that last 4K bytes of
 	 * the addressable memory can not be mapped because of IS_ERR_VALUE
@@ -194,12 +200,12 @@ static void __init setup_bootmem(void)
 	 * be done in create_kernel_page_table.
 	 */
 	max_mapped_addr = __pa(~(ulong)0);
-	if (max_mapped_addr == (dram_end - 1))
+	if (max_mapped_addr == (phys_ram_end - 1))
 		memblock_set_current_limit(max_mapped_addr - 4096);
 #endif
 
-	min_low_pfn = PFN_UP(memblock_start_of_DRAM());
-	max_low_pfn = max_pfn = PFN_DOWN(dram_end);
+	min_low_pfn = PFN_UP(phys_ram_base);
+	max_low_pfn = max_pfn = PFN_DOWN(phys_ram_end);
 
 	dma32_phys_limit = min(4UL * SZ_1G, (unsigned long)PFN_PHYS(max_low_pfn));
 	set_max_mapnr(max_low_pfn - ARCH_PFN_OFFSET);
@@ -558,6 +564,7 @@ asmlinkage void __init setup_vm(uintptr_t dtb_pa)
 	kernel_map.xiprom = (uintptr_t)CONFIG_XIP_PHYS_ADDR;
 	kernel_map.xiprom_sz = (uintptr_t)(&_exiprom) - (uintptr_t)(&_xiprom);
 
+	phys_ram_base = CONFIG_PHYS_RAM_BASE;
 	kernel_map.phys_addr = (uintptr_t)CONFIG_PHYS_RAM_BASE;
 	kernel_map.size = (uintptr_t)(&_end) - (uintptr_t)(&_sdata);
 

