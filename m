Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C963738386E
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343697AbhEQPwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:52:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:46280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243367AbhEQPun (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:50:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 832BB61964;
        Mon, 17 May 2021 14:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262761;
        bh=WKdTFeahLlw2TRgqW++OGJYrUZHY5jcBxDyfvwbzW28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vaJEuKoMip64YC7yEZtS6+9QUA7NTBMCUjay3QbzGgJpA4R7rPqfvDhno339nUz5A
         36YGyJ6HdMTdmi94/FIj0kFLMbL44XIxPoA8+nFq8qWIFUMY00Rd80Z5l3mmPjIKCb
         NgrZpExZAQjmhVc/seUeakpQNGTceEYgj6uUrPeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.10 271/289] ARM: 9011/1: centralize phys-to-virt conversion of DT/ATAGS address
Date:   Mon, 17 May 2021 16:03:16 +0200
Message-Id: <20210517140314.266914888@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit e9a2f8b599d0bc22a1b13e69527246ac39c697b4 upstream

Before moving the DT mapping out of the linear region, let's prepare
for this change by removing all the phys-to-virt translations of the
__atags_pointer variable, and perform this translation only once at
setup time.

Tested-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Nicolas Pitre <nico@fluxnic.net>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/prom.h   |    4 ++--
 arch/arm/kernel/atags.h       |    4 ++--
 arch/arm/kernel/atags_parse.c |    6 +++---
 arch/arm/kernel/devtree.c     |    6 +++---
 arch/arm/kernel/setup.c       |   14 +++++++++-----
 arch/arm/mm/mmu.c             |    4 ++--
 6 files changed, 21 insertions(+), 17 deletions(-)

--- a/arch/arm/include/asm/prom.h
+++ b/arch/arm/include/asm/prom.h
@@ -9,12 +9,12 @@
 
 #ifdef CONFIG_OF
 
-extern const struct machine_desc *setup_machine_fdt(unsigned int dt_phys);
+extern const struct machine_desc *setup_machine_fdt(void *dt_virt);
 extern void __init arm_dt_init_cpu_maps(void);
 
 #else /* CONFIG_OF */
 
-static inline const struct machine_desc *setup_machine_fdt(unsigned int dt_phys)
+static inline const struct machine_desc *setup_machine_fdt(void *dt_virt)
 {
 	return NULL;
 }
--- a/arch/arm/kernel/atags.h
+++ b/arch/arm/kernel/atags.h
@@ -2,11 +2,11 @@
 void convert_to_tag_list(struct tag *tags);
 
 #ifdef CONFIG_ATAGS
-const struct machine_desc *setup_machine_tags(phys_addr_t __atags_pointer,
+const struct machine_desc *setup_machine_tags(void *__atags_vaddr,
 	unsigned int machine_nr);
 #else
 static inline const struct machine_desc * __init __noreturn
-setup_machine_tags(phys_addr_t __atags_pointer, unsigned int machine_nr)
+setup_machine_tags(void *__atags_vaddr, unsigned int machine_nr)
 {
 	early_print("no ATAGS support: can't continue\n");
 	while (true);
--- a/arch/arm/kernel/atags_parse.c
+++ b/arch/arm/kernel/atags_parse.c
@@ -174,7 +174,7 @@ static void __init squash_mem_tags(struc
 }
 
 const struct machine_desc * __init
-setup_machine_tags(phys_addr_t __atags_pointer, unsigned int machine_nr)
+setup_machine_tags(void *atags_vaddr, unsigned int machine_nr)
 {
 	struct tag *tags = (struct tag *)&default_tags;
 	const struct machine_desc *mdesc = NULL, *p;
@@ -195,8 +195,8 @@ setup_machine_tags(phys_addr_t __atags_p
 	if (!mdesc)
 		return NULL;
 
-	if (__atags_pointer)
-		tags = phys_to_virt(__atags_pointer);
+	if (atags_vaddr)
+		tags = atags_vaddr;
 	else if (mdesc->atag_offset)
 		tags = (void *)(PAGE_OFFSET + mdesc->atag_offset);
 
--- a/arch/arm/kernel/devtree.c
+++ b/arch/arm/kernel/devtree.c
@@ -203,12 +203,12 @@ static const void * __init arch_get_next
 
 /**
  * setup_machine_fdt - Machine setup when an dtb was passed to the kernel
- * @dt_phys: physical address of dt blob
+ * @dt_virt: virtual address of dt blob
  *
  * If a dtb was passed to the kernel in r2, then use it to choose the
  * correct machine_desc and to setup the system.
  */
-const struct machine_desc * __init setup_machine_fdt(unsigned int dt_phys)
+const struct machine_desc * __init setup_machine_fdt(void *dt_virt)
 {
 	const struct machine_desc *mdesc, *mdesc_best = NULL;
 
@@ -221,7 +221,7 @@ const struct machine_desc * __init setup
 	mdesc_best = &__mach_desc_GENERIC_DT;
 #endif
 
-	if (!dt_phys || !early_init_dt_verify(phys_to_virt(dt_phys)))
+	if (!dt_virt || !early_init_dt_verify(dt_virt))
 		return NULL;
 
 	mdesc = of_flat_dt_match_machine(mdesc_best, arch_get_next_mach);
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -89,6 +89,7 @@ unsigned int cacheid __read_mostly;
 EXPORT_SYMBOL(cacheid);
 
 unsigned int __atags_pointer __initdata;
+void *atags_vaddr __initdata;
 
 unsigned int system_rev;
 EXPORT_SYMBOL(system_rev);
@@ -1081,19 +1082,22 @@ void __init hyp_mode_check(void)
 
 void __init setup_arch(char **cmdline_p)
 {
-	const struct machine_desc *mdesc;
+	const struct machine_desc *mdesc = NULL;
+
+	if (__atags_pointer)
+		atags_vaddr = phys_to_virt(__atags_pointer);
 
 	setup_processor();
-	mdesc = setup_machine_fdt(__atags_pointer);
+	if (atags_vaddr)
+		mdesc = setup_machine_fdt(atags_vaddr);
 	if (!mdesc)
-		mdesc = setup_machine_tags(__atags_pointer, __machine_arch_type);
+		mdesc = setup_machine_tags(atags_vaddr, __machine_arch_type);
 	if (!mdesc) {
 		early_print("\nError: invalid dtb and unrecognized/unsupported machine ID\n");
 		early_print("  r1=0x%08x, r2=0x%08x\n", __machine_arch_type,
 			    __atags_pointer);
 		if (__atags_pointer)
-			early_print("  r2[]=%*ph\n", 16,
-				    phys_to_virt(__atags_pointer));
+			early_print("  r2[]=%*ph\n", 16, atags_vaddr);
 		dump_machine_table();
 	}
 
--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1489,7 +1489,7 @@ static void __init map_lowmem(void)
 }
 
 #ifdef CONFIG_ARM_PV_FIXUP
-extern unsigned long __atags_pointer;
+extern void *atags_vaddr;
 typedef void pgtables_remap(long long offset, unsigned long pgd, void *bdata);
 pgtables_remap lpae_pgtables_remap_asm;
 
@@ -1520,7 +1520,7 @@ static void __init early_paging_init(con
 	 */
 	lpae_pgtables_remap = (pgtables_remap *)(unsigned long)__pa(lpae_pgtables_remap_asm);
 	pa_pgd = __pa(swapper_pg_dir);
-	boot_data = __va(__atags_pointer);
+	boot_data = atags_vaddr;
 	barrier();
 
 	pr_info("Switching physical address space to 0x%08llx\n",


