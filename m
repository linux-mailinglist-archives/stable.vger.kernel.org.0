Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D10B6423F27
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 15:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238589AbhJFNah (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 09:30:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231403AbhJFNah (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 09:30:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 435F360E9C;
        Wed,  6 Oct 2021 13:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633526925;
        bh=hstO/NZoXOT8GdJ0uy6rQ/P8BktxKI0O8Vo/q90XhKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yu3H9NnW+w+1eOKFcspexiLyfiGVRSkEPO9tETzswIITEkk1AQF/dO6hZMXPm2Gom
         7j4I8JPSBWs/0qLw1ugVPKm/ZI4kqnWAqdOBtZ111a+2KCHcXpXvPZadySLJK7DBAq
         qAo4GplzTArUrsB1jUmQok3c0XpbvEt0AsDHuJT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.249
Date:   Wed,  6 Oct 2021 15:28:34 +0200
Message-Id: <163352691317934@kroah.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <163352691317581@kroah.com>
References: <163352691317581@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 7999f2fbd0f8..f7559e82d514 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 248
+SUBLEVEL = 249
 EXTRAVERSION =
 NAME = Petit Gorille
 
diff --git a/arch/alpha/include/asm/io.h b/arch/alpha/include/asm/io.h
index 9995bed6e92e..204c4fb69ee1 100644
--- a/arch/alpha/include/asm/io.h
+++ b/arch/alpha/include/asm/io.h
@@ -61,7 +61,7 @@ extern inline void set_hae(unsigned long new_hae)
  * Change virtual addresses to physical addresses and vv.
  */
 #ifdef USE_48_BIT_KSEG
-static inline unsigned long virt_to_phys(void *address)
+static inline unsigned long virt_to_phys(volatile void *address)
 {
 	return (unsigned long)address - IDENT_ADDR;
 }
@@ -71,7 +71,7 @@ static inline void * phys_to_virt(unsigned long address)
 	return (void *) (address + IDENT_ADDR);
 }
 #else
-static inline unsigned long virt_to_phys(void *address)
+static inline unsigned long virt_to_phys(volatile void *address)
 {
         unsigned long phys = (unsigned long)address;
 
@@ -112,7 +112,7 @@ static inline dma_addr_t __deprecated isa_page_to_bus(struct page *page)
 extern unsigned long __direct_map_base;
 extern unsigned long __direct_map_size;
 
-static inline unsigned long __deprecated virt_to_bus(void *address)
+static inline unsigned long __deprecated virt_to_bus(volatile void *address)
 {
 	unsigned long phys = virt_to_phys(address);
 	unsigned long bus = phys + __direct_map_base;
diff --git a/arch/arm/include/asm/ftrace.h b/arch/arm/include/asm/ftrace.h
index 9e842ff41768..faeb6b1c0089 100644
--- a/arch/arm/include/asm/ftrace.h
+++ b/arch/arm/include/asm/ftrace.h
@@ -19,6 +19,9 @@ struct dyn_arch_ftrace {
 #ifdef CONFIG_OLD_MCOUNT
 	bool	old_mcount;
 #endif
+#ifdef CONFIG_ARM_MODULE_PLTS
+	struct module *mod;
+#endif
 };
 
 static inline unsigned long ftrace_call_adjust(unsigned long addr)
diff --git a/arch/arm/include/asm/insn.h b/arch/arm/include/asm/insn.h
index f20e08ac85ae..5475cbf9fb6b 100644
--- a/arch/arm/include/asm/insn.h
+++ b/arch/arm/include/asm/insn.h
@@ -13,18 +13,18 @@ arm_gen_nop(void)
 }
 
 unsigned long
-__arm_gen_branch(unsigned long pc, unsigned long addr, bool link);
+__arm_gen_branch(unsigned long pc, unsigned long addr, bool link, bool warn);
 
 static inline unsigned long
 arm_gen_branch(unsigned long pc, unsigned long addr)
 {
-	return __arm_gen_branch(pc, addr, false);
+	return __arm_gen_branch(pc, addr, false, true);
 }
 
 static inline unsigned long
-arm_gen_branch_link(unsigned long pc, unsigned long addr)
+arm_gen_branch_link(unsigned long pc, unsigned long addr, bool warn)
 {
-	return __arm_gen_branch(pc, addr, true);
+	return __arm_gen_branch(pc, addr, true, warn);
 }
 
 #endif
diff --git a/arch/arm/include/asm/module.h b/arch/arm/include/asm/module.h
index 89ad0596033a..e3d7a51bcf9c 100644
--- a/arch/arm/include/asm/module.h
+++ b/arch/arm/include/asm/module.h
@@ -19,8 +19,18 @@ enum {
 };
 #endif
 
+#define PLT_ENT_STRIDE		L1_CACHE_BYTES
+#define PLT_ENT_COUNT		(PLT_ENT_STRIDE / sizeof(u32))
+#define PLT_ENT_SIZE		(sizeof(struct plt_entries) / PLT_ENT_COUNT)
+
+struct plt_entries {
+	u32	ldr[PLT_ENT_COUNT];
+	u32	lit[PLT_ENT_COUNT];
+};
+
 struct mod_plt_sec {
 	struct elf32_shdr	*plt;
+	struct plt_entries	*plt_ent;
 	int			plt_count;
 };
 
diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index 5617932a83df..1a5edcfb0306 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -96,9 +96,10 @@ int ftrace_arch_code_modify_post_process(void)
 	return 0;
 }
 
-static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr)
+static unsigned long ftrace_call_replace(unsigned long pc, unsigned long addr,
+					 bool warn)
 {
-	return arm_gen_branch_link(pc, addr);
+	return arm_gen_branch_link(pc, addr, warn);
 }
 
 static int ftrace_modify_code(unsigned long pc, unsigned long old,
@@ -137,14 +138,14 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 	int ret;
 
 	pc = (unsigned long)&ftrace_call;
-	new = ftrace_call_replace(pc, (unsigned long)func);
+	new = ftrace_call_replace(pc, (unsigned long)func, true);
 
 	ret = ftrace_modify_code(pc, 0, new, false);
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 	if (!ret) {
 		pc = (unsigned long)&ftrace_regs_call;
-		new = ftrace_call_replace(pc, (unsigned long)func);
+		new = ftrace_call_replace(pc, (unsigned long)func, true);
 
 		ret = ftrace_modify_code(pc, 0, new, false);
 	}
@@ -153,7 +154,7 @@ int ftrace_update_ftrace_func(ftrace_func_t func)
 #ifdef CONFIG_OLD_MCOUNT
 	if (!ret) {
 		pc = (unsigned long)&ftrace_call_old;
-		new = ftrace_call_replace(pc, (unsigned long)func);
+		new = ftrace_call_replace(pc, (unsigned long)func, true);
 
 		ret = ftrace_modify_code(pc, 0, new, false);
 	}
@@ -166,10 +167,22 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
 	unsigned long new, old;
 	unsigned long ip = rec->ip;
+	unsigned long aaddr = adjust_address(rec, addr);
+	struct module *mod = NULL;
+
+#ifdef CONFIG_ARM_MODULE_PLTS
+	mod = rec->arch.mod;
+#endif
 
 	old = ftrace_nop_replace(rec);
 
-	new = ftrace_call_replace(ip, adjust_address(rec, addr));
+	new = ftrace_call_replace(ip, aaddr, !mod);
+#ifdef CONFIG_ARM_MODULE_PLTS
+	if (!new && mod) {
+		aaddr = get_module_plt(mod, ip, aaddr);
+		new = ftrace_call_replace(ip, aaddr, true);
+	}
+#endif
 
 	return ftrace_modify_code(rec->ip, old, new, true);
 }
@@ -182,9 +195,9 @@ int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 	unsigned long new, old;
 	unsigned long ip = rec->ip;
 
-	old = ftrace_call_replace(ip, adjust_address(rec, old_addr));
+	old = ftrace_call_replace(ip, adjust_address(rec, old_addr), true);
 
-	new = ftrace_call_replace(ip, adjust_address(rec, addr));
+	new = ftrace_call_replace(ip, adjust_address(rec, addr), true);
 
 	return ftrace_modify_code(rec->ip, old, new, true);
 }
@@ -194,12 +207,29 @@ int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 int ftrace_make_nop(struct module *mod,
 		    struct dyn_ftrace *rec, unsigned long addr)
 {
+	unsigned long aaddr = adjust_address(rec, addr);
 	unsigned long ip = rec->ip;
 	unsigned long old;
 	unsigned long new;
 	int ret;
 
-	old = ftrace_call_replace(ip, adjust_address(rec, addr));
+#ifdef CONFIG_ARM_MODULE_PLTS
+	/* mod is only supplied during module loading */
+	if (!mod)
+		mod = rec->arch.mod;
+	else
+		rec->arch.mod = mod;
+#endif
+
+	old = ftrace_call_replace(ip, aaddr,
+				  !IS_ENABLED(CONFIG_ARM_MODULE_PLTS) || !mod);
+#ifdef CONFIG_ARM_MODULE_PLTS
+	if (!old && mod) {
+		aaddr = get_module_plt(mod, ip, aaddr);
+		old = ftrace_call_replace(ip, aaddr, true);
+	}
+#endif
+
 	new = ftrace_nop_replace(rec);
 	ret = ftrace_modify_code(ip, old, new, true);
 
@@ -207,7 +237,7 @@ int ftrace_make_nop(struct module *mod,
 	if (ret == -EINVAL && addr == MCOUNT_ADDR) {
 		rec->arch.old_mcount = true;
 
-		old = ftrace_call_replace(ip, adjust_address(rec, addr));
+		old = ftrace_call_replace(ip, adjust_address(rec, addr), true);
 		new = ftrace_nop_replace(rec);
 		ret = ftrace_modify_code(ip, old, new, true);
 	}
diff --git a/arch/arm/kernel/insn.c b/arch/arm/kernel/insn.c
index 2e844b70386b..db0acbb7d7a0 100644
--- a/arch/arm/kernel/insn.c
+++ b/arch/arm/kernel/insn.c
@@ -3,8 +3,9 @@
 #include <linux/kernel.h>
 #include <asm/opcodes.h>
 
-static unsigned long
-__arm_gen_branch_thumb2(unsigned long pc, unsigned long addr, bool link)
+static unsigned long __arm_gen_branch_thumb2(unsigned long pc,
+					     unsigned long addr, bool link,
+					     bool warn)
 {
 	unsigned long s, j1, j2, i1, i2, imm10, imm11;
 	unsigned long first, second;
@@ -12,7 +13,7 @@ __arm_gen_branch_thumb2(unsigned long pc, unsigned long addr, bool link)
 
 	offset = (long)addr - (long)(pc + 4);
 	if (offset < -16777216 || offset > 16777214) {
-		WARN_ON_ONCE(1);
+		WARN_ON_ONCE(warn);
 		return 0;
 	}
 
@@ -33,8 +34,8 @@ __arm_gen_branch_thumb2(unsigned long pc, unsigned long addr, bool link)
 	return __opcode_thumb32_compose(first, second);
 }
 
-static unsigned long
-__arm_gen_branch_arm(unsigned long pc, unsigned long addr, bool link)
+static unsigned long __arm_gen_branch_arm(unsigned long pc, unsigned long addr,
+					  bool link, bool warn)
 {
 	unsigned long opcode = 0xea000000;
 	long offset;
@@ -44,7 +45,7 @@ __arm_gen_branch_arm(unsigned long pc, unsigned long addr, bool link)
 
 	offset = (long)addr - (long)(pc + 8);
 	if (unlikely(offset < -33554432 || offset > 33554428)) {
-		WARN_ON_ONCE(1);
+		WARN_ON_ONCE(warn);
 		return 0;
 	}
 
@@ -54,10 +55,10 @@ __arm_gen_branch_arm(unsigned long pc, unsigned long addr, bool link)
 }
 
 unsigned long
-__arm_gen_branch(unsigned long pc, unsigned long addr, bool link)
+__arm_gen_branch(unsigned long pc, unsigned long addr, bool link, bool warn)
 {
 	if (IS_ENABLED(CONFIG_THUMB2_KERNEL))
-		return __arm_gen_branch_thumb2(pc, addr, link);
+		return __arm_gen_branch_thumb2(pc, addr, link, warn);
 	else
-		return __arm_gen_branch_arm(pc, addr, link);
+		return __arm_gen_branch_arm(pc, addr, link, warn);
 }
diff --git a/arch/arm/kernel/module-plts.c b/arch/arm/kernel/module-plts.c
index 3d0c2e4dda1d..ed0e09cc735f 100644
--- a/arch/arm/kernel/module-plts.c
+++ b/arch/arm/kernel/module-plts.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/elf.h>
+#include <linux/ftrace.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/sort.h>
@@ -14,10 +15,6 @@
 #include <asm/cache.h>
 #include <asm/opcodes.h>
 
-#define PLT_ENT_STRIDE		L1_CACHE_BYTES
-#define PLT_ENT_COUNT		(PLT_ENT_STRIDE / sizeof(u32))
-#define PLT_ENT_SIZE		(sizeof(struct plt_entries) / PLT_ENT_COUNT)
-
 #ifdef CONFIG_THUMB2_KERNEL
 #define PLT_ENT_LDR		__opcode_to_mem_thumb32(0xf8dff000 | \
 							(PLT_ENT_STRIDE - 4))
@@ -26,9 +23,11 @@
 						    (PLT_ENT_STRIDE - 8))
 #endif
 
-struct plt_entries {
-	u32	ldr[PLT_ENT_COUNT];
-	u32	lit[PLT_ENT_COUNT];
+static const u32 fixed_plts[] = {
+#ifdef CONFIG_DYNAMIC_FTRACE
+	FTRACE_ADDR,
+	MCOUNT_ADDR,
+#endif
 };
 
 static bool in_init(const struct module *mod, unsigned long loc)
@@ -36,14 +35,40 @@ static bool in_init(const struct module *mod, unsigned long loc)
 	return loc - (u32)mod->init_layout.base < mod->init_layout.size;
 }
 
+static void prealloc_fixed(struct mod_plt_sec *pltsec, struct plt_entries *plt)
+{
+	int i;
+
+	if (!ARRAY_SIZE(fixed_plts) || pltsec->plt_count)
+		return;
+	pltsec->plt_count = ARRAY_SIZE(fixed_plts);
+
+	for (i = 0; i < ARRAY_SIZE(plt->ldr); ++i)
+		plt->ldr[i] = PLT_ENT_LDR;
+
+	BUILD_BUG_ON(sizeof(fixed_plts) > sizeof(plt->lit));
+	memcpy(plt->lit, fixed_plts, sizeof(fixed_plts));
+}
+
 u32 get_module_plt(struct module *mod, unsigned long loc, Elf32_Addr val)
 {
 	struct mod_plt_sec *pltsec = !in_init(mod, loc) ? &mod->arch.core :
 							  &mod->arch.init;
+	struct plt_entries *plt;
+	int idx;
+
+	/* cache the address, ELF header is available only during module load */
+	if (!pltsec->plt_ent)
+		pltsec->plt_ent = (struct plt_entries *)pltsec->plt->sh_addr;
+	plt = pltsec->plt_ent;
 
-	struct plt_entries *plt = (struct plt_entries *)pltsec->plt->sh_addr;
-	int idx = 0;
+	prealloc_fixed(pltsec, plt);
+
+	for (idx = 0; idx < ARRAY_SIZE(fixed_plts); ++idx)
+		if (plt->lit[idx] == val)
+			return (u32)&plt->ldr[idx];
 
+	idx = 0;
 	/*
 	 * Look for an existing entry pointing to 'val'. Given that the
 	 * relocations are sorted, this will be the last entry we allocated.
@@ -191,8 +216,8 @@ static unsigned int count_plts(const Elf32_Sym *syms, Elf32_Addr base,
 int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 			      char *secstrings, struct module *mod)
 {
-	unsigned long core_plts = 0;
-	unsigned long init_plts = 0;
+	unsigned long core_plts = ARRAY_SIZE(fixed_plts);
+	unsigned long init_plts = ARRAY_SIZE(fixed_plts);
 	Elf32_Shdr *s, *sechdrs_end = sechdrs + ehdr->e_shnum;
 	Elf32_Sym *syms = NULL;
 
@@ -247,6 +272,7 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 	mod->arch.core.plt->sh_size = round_up(core_plts * PLT_ENT_SIZE,
 					       sizeof(struct plt_entries));
 	mod->arch.core.plt_count = 0;
+	mod->arch.core.plt_ent = NULL;
 
 	mod->arch.init.plt->sh_type = SHT_NOBITS;
 	mod->arch.init.plt->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
@@ -254,6 +280,7 @@ int module_frob_arch_sections(Elf_Ehdr *ehdr, Elf_Shdr *sechdrs,
 	mod->arch.init.plt->sh_size = round_up(init_plts * PLT_ENT_SIZE,
 					       sizeof(struct plt_entries));
 	mod->arch.init.plt_count = 0;
+	mod->arch.init.plt_ent = NULL;
 
 	pr_debug("%s: plt=%x, init.plt=%x\n", __func__,
 		 mod->arch.core.plt->sh_size, mod->arch.init.plt->sh_size);
diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e296ae3e20f4..e76f74874a42 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -450,7 +450,7 @@ config ARM64_ERRATUM_1024718
 	help
 	  This option adds work around for Arm Cortex-A55 Erratum 1024718.
 
-	  Affected Cortex-A55 cores (r0p0, r0p1, r1p0) could cause incorrect
+	  Affected Cortex-A55 cores (all revisions) could cause incorrect
 	  update of the hardware dirty bit when the DBM/AP bits are updated
 	  without a break-before-make. The work around is to disable the usage
 	  of hardware DBM locally on the affected cores. CPUs not affected by
diff --git a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
index b554cdaf5e53..257bfa811fe8 100644
--- a/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
+++ b/arch/arm64/boot/dts/marvell/armada-37xx.dtsi
@@ -347,8 +347,15 @@
 			#interrupt-cells = <1>;
 			msi-parent = <&pcie0>;
 			msi-controller;
-			ranges = <0x82000000 0 0xe8000000   0 0xe8000000 0 0x1000000 /* Port 0 MEM */
-				  0x81000000 0 0xe9000000   0 0xe9000000 0 0x10000>; /* Port 0 IO*/
+			/*
+			 * The 128 MiB address range [0xe8000000-0xf0000000] is
+			 * dedicated for PCIe and can be assigned to 8 windows
+			 * with size a power of two. Use one 64 KiB window for
+			 * IO at the end and the remaining seven windows
+			 * (totaling 127 MiB) for MEM.
+			 */
+			ranges = <0x82000000 0 0xe8000000   0 0xe8000000   0 0x07f00000   /* Port 0 MEM */
+				  0x81000000 0 0xefff0000   0 0xefff0000   0 0x00010000>; /* Port 0 IO */
 			interrupt-map-mask = <0 0 0 7>;
 			interrupt-map = <0 0 0 1 &pcie_intc 0>,
 					<0 0 0 2 &pcie_intc 1>,
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 2ff327651ebe..dac14125f8a2 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -61,7 +61,7 @@
 
 #ifdef CONFIG_CC_STACKPROTECTOR
 #include <linux/stackprotector.h>
-unsigned long __stack_chk_guard __read_mostly;
+unsigned long __stack_chk_guard __ro_after_init;
 EXPORT_SYMBOL(__stack_chk_guard);
 #endif
 
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index ecbc060807d2..a9ff7fb41832 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -455,8 +455,8 @@ ENTRY(__cpu_setup)
 	cmp	x9, #2
 	b.lt	1f
 #ifdef CONFIG_ARM64_ERRATUM_1024718
-	/* Disable hardware DBM on Cortex-A55 r0p0, r0p1 & r1p0 */
-	cpu_midr_match MIDR_CORTEX_A55, MIDR_CPU_VAR_REV(0, 0), MIDR_CPU_VAR_REV(1, 0), x1, x2, x3, x4
+	/* Disable hardware DBM on Cortex-A55 all versions */
+	cpu_midr_match MIDR_CORTEX_A55, MIDR_CPU_VAR_REV(0, 0), MIDR_CPU_VAR_REV(0xf, 0xf), x1, x2, x3, x4
 	cbnz	x1, 1f
 #endif
 	orr	x10, x10, #TCR_HD		// hardware Dirty flag update
diff --git a/arch/m68k/include/asm/raw_io.h b/arch/m68k/include/asm/raw_io.h
index 05e940c29b54..cbfff90c2a69 100644
--- a/arch/m68k/include/asm/raw_io.h
+++ b/arch/m68k/include/asm/raw_io.h
@@ -31,21 +31,21 @@ extern void __iounmap(void *addr, unsigned long size);
  * two accesses to memory, which may be undesirable for some devices.
  */
 #define in_8(addr) \
-    ({ u8 __v = (*(__force volatile u8 *) (addr)); __v; })
+    ({ u8 __v = (*(__force volatile u8 *) (unsigned long)(addr)); __v; })
 #define in_be16(addr) \
-    ({ u16 __v = (*(__force volatile u16 *) (addr)); __v; })
+    ({ u16 __v = (*(__force volatile u16 *) (unsigned long)(addr)); __v; })
 #define in_be32(addr) \
-    ({ u32 __v = (*(__force volatile u32 *) (addr)); __v; })
+    ({ u32 __v = (*(__force volatile u32 *) (unsigned long)(addr)); __v; })
 #define in_le16(addr) \
-    ({ u16 __v = le16_to_cpu(*(__force volatile __le16 *) (addr)); __v; })
+    ({ u16 __v = le16_to_cpu(*(__force volatile __le16 *) (unsigned long)(addr)); __v; })
 #define in_le32(addr) \
-    ({ u32 __v = le32_to_cpu(*(__force volatile __le32 *) (addr)); __v; })
+    ({ u32 __v = le32_to_cpu(*(__force volatile __le32 *) (unsigned long)(addr)); __v; })
 
-#define out_8(addr,b) (void)((*(__force volatile u8 *) (addr)) = (b))
-#define out_be16(addr,w) (void)((*(__force volatile u16 *) (addr)) = (w))
-#define out_be32(addr,l) (void)((*(__force volatile u32 *) (addr)) = (l))
-#define out_le16(addr,w) (void)((*(__force volatile __le16 *) (addr)) = cpu_to_le16(w))
-#define out_le32(addr,l) (void)((*(__force volatile __le32 *) (addr)) = cpu_to_le32(l))
+#define out_8(addr,b) (void)((*(__force volatile u8 *) (unsigned long)(addr)) = (b))
+#define out_be16(addr,w) (void)((*(__force volatile u16 *) (unsigned long)(addr)) = (w))
+#define out_be32(addr,l) (void)((*(__force volatile u32 *) (unsigned long)(addr)) = (l))
+#define out_le16(addr,w) (void)((*(__force volatile __le16 *) (unsigned long)(addr)) = cpu_to_le16(w))
+#define out_le32(addr,l) (void)((*(__force volatile __le32 *) (unsigned long)(addr)) = cpu_to_le32(l))
 
 #define raw_inb in_8
 #define raw_inw in_be16
diff --git a/arch/parisc/include/asm/page.h b/arch/parisc/include/asm/page.h
index af00fe9bf846..c631a8fd856a 100644
--- a/arch/parisc/include/asm/page.h
+++ b/arch/parisc/include/asm/page.h
@@ -179,7 +179,7 @@ extern int npmem_ranges;
 #include <asm-generic/getorder.h>
 #include <asm/pdc.h>
 
-#define PAGE0   ((struct zeropage *)__PAGE_OFFSET)
+#define PAGE0   ((struct zeropage *)absolute_pointer(__PAGE_OFFSET))
 
 /* DEFINITION OF THE ZERO-PAGE (PAG0) */
 /* based on work by Jason Eckhardt (jason@equator.com) */
diff --git a/arch/sparc/kernel/mdesc.c b/arch/sparc/kernel/mdesc.c
index 8f24f3d60b8c..bfc30439a41d 100644
--- a/arch/sparc/kernel/mdesc.c
+++ b/arch/sparc/kernel/mdesc.c
@@ -38,6 +38,7 @@ struct mdesc_hdr {
 	u32	node_sz; /* node block size */
 	u32	name_sz; /* name block size */
 	u32	data_sz; /* data block size */
+	char	data[];
 } __attribute__((aligned(16)));
 
 struct mdesc_elem {
@@ -611,7 +612,7 @@ EXPORT_SYMBOL(mdesc_get_node_info);
 
 static struct mdesc_elem *node_block(struct mdesc_hdr *mdesc)
 {
-	return (struct mdesc_elem *) (mdesc + 1);
+	return (struct mdesc_elem *) mdesc->data;
 }
 
 static void *name_block(struct mdesc_hdr *mdesc)
diff --git a/arch/x86/xen/enlighten_pv.c b/arch/x86/xen/enlighten_pv.c
index 3e6a08068b25..88d084a57b14 100644
--- a/arch/x86/xen/enlighten_pv.c
+++ b/arch/x86/xen/enlighten_pv.c
@@ -721,8 +721,8 @@ static void xen_write_idt_entry(gate_desc *dt, int entrynum, const gate_desc *g)
 	preempt_enable();
 }
 
-static void xen_convert_trap_info(const struct desc_ptr *desc,
-				  struct trap_info *traps)
+static unsigned xen_convert_trap_info(const struct desc_ptr *desc,
+				      struct trap_info *traps, bool full)
 {
 	unsigned in, out, count;
 
@@ -732,17 +732,18 @@ static void xen_convert_trap_info(const struct desc_ptr *desc,
 	for (in = out = 0; in < count; in++) {
 		gate_desc *entry = (gate_desc *)(desc->address) + in;
 
-		if (cvt_gate_to_trap(in, entry, &traps[out]))
+		if (cvt_gate_to_trap(in, entry, &traps[out]) || full)
 			out++;
 	}
-	traps[out].address = 0;
+
+	return out;
 }
 
 void xen_copy_trap_info(struct trap_info *traps)
 {
 	const struct desc_ptr *desc = this_cpu_ptr(&idt_desc);
 
-	xen_convert_trap_info(desc, traps);
+	xen_convert_trap_info(desc, traps, true);
 }
 
 /* Load a new IDT into Xen.  In principle this can be per-CPU, so we
@@ -752,6 +753,7 @@ static void xen_load_idt(const struct desc_ptr *desc)
 {
 	static DEFINE_SPINLOCK(lock);
 	static struct trap_info traps[257];
+	unsigned out;
 
 	trace_xen_cpu_load_idt(desc);
 
@@ -759,7 +761,8 @@ static void xen_load_idt(const struct desc_ptr *desc)
 
 	memcpy(this_cpu_ptr(&idt_desc), desc, sizeof(idt_desc));
 
-	xen_convert_trap_info(desc, traps);
+	out = xen_convert_trap_info(desc, traps, false);
+	memset(&traps[out], 0, sizeof(traps[0]));
 
 	xen_mc_flush();
 	if (HYPERVISOR_set_trap_table(traps))
diff --git a/drivers/cpufreq/cpufreq_governor_attr_set.c b/drivers/cpufreq/cpufreq_governor_attr_set.c
index 52841f807a7e..45fdf30cade3 100644
--- a/drivers/cpufreq/cpufreq_governor_attr_set.c
+++ b/drivers/cpufreq/cpufreq_governor_attr_set.c
@@ -77,8 +77,8 @@ unsigned int gov_attr_set_put(struct gov_attr_set *attr_set, struct list_head *l
 	if (count)
 		return count;
 
-	kobject_put(&attr_set->kobj);
 	mutex_destroy(&attr_set->update_lock);
+	kobject_put(&attr_set->kobj);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(gov_attr_set_put);
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 20ca9c9e109e..453d27d2a4ff 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -783,7 +783,7 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 				    in_place ? DMA_BIDIRECTIONAL
 					     : DMA_TO_DEVICE);
 		if (ret)
-			goto e_ctx;
+			goto e_aad;
 
 		if (in_place) {
 			dst = src;
@@ -868,7 +868,7 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 	op.u.aes.size = 0;
 	ret = cmd_q->ccp->vdata->perform->aes(&op);
 	if (ret)
-		goto e_dst;
+		goto e_final_wa;
 
 	if (aes->action == CCP_AES_ACTION_ENCRYPT) {
 		/* Put the ciphered tag after the ciphertext. */
@@ -878,17 +878,19 @@ ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
 		ret = ccp_init_dm_workarea(&tag, cmd_q, authsize,
 					   DMA_BIDIRECTIONAL);
 		if (ret)
-			goto e_tag;
+			goto e_final_wa;
 		ret = ccp_set_dm_area(&tag, 0, p_tag, 0, authsize);
-		if (ret)
-			goto e_tag;
+		if (ret) {
+			ccp_dm_free(&tag);
+			goto e_final_wa;
+		}
 
 		ret = crypto_memneq(tag.address, final_wa.address,
 				    authsize) ? -EBADMSG : 0;
 		ccp_dm_free(&tag);
 	}
 
-e_tag:
+e_final_wa:
 	ccp_dm_free(&final_wa);
 
 e_dst:
diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
index 0c9c59e2b5a3..ba9de54a701e 100644
--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -371,7 +371,7 @@ static int synps_edac_init_csrows(struct mem_ctl_info *mci)
 
 		for (j = 0; j < csi->nr_channels; j++) {
 			dimm            = csi->channels[j]->dimm;
-			dimm->edac_mode = EDAC_FLAG_SECDED;
+			dimm->edac_mode = EDAC_SECDED;
 			dimm->mtype     = synps_edac_get_mtype(priv->baseaddr);
 			dimm->nr_pages  = (size >> PAGE_SHIFT) / csi->nr_channels;
 			dimm->grain     = SYNPS_EDAC_ERR_GRAIN;
diff --git a/drivers/hid/hid-betopff.c b/drivers/hid/hid-betopff.c
index 69cfc8dc6af1..9b60efe6ec44 100644
--- a/drivers/hid/hid-betopff.c
+++ b/drivers/hid/hid-betopff.c
@@ -59,15 +59,22 @@ static int betopff_init(struct hid_device *hid)
 {
 	struct betopff_device *betopff;
 	struct hid_report *report;
-	struct hid_input *hidinput =
-			list_first_entry(&hid->inputs, struct hid_input, list);
+	struct hid_input *hidinput;
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	struct input_dev *dev = hidinput->input;
+	struct input_dev *dev;
 	int field_count = 0;
 	int error;
 	int i, j;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+
+	hidinput = list_first_entry(&hid->inputs, struct hid_input, list);
+	dev = hidinput->input;
+
 	if (list_empty(report_list)) {
 		hid_err(hid, "no output reports found\n");
 		return -ENODEV;
diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 46b8f4c353de..404e367fb8ab 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -501,7 +501,7 @@ static void hid_ctrl(struct urb *urb)
 
 	if (unplug) {
 		usbhid->ctrltail = usbhid->ctrlhead;
-	} else {
+	} else if (usbhid->ctrlhead != usbhid->ctrltail) {
 		usbhid->ctrltail = (usbhid->ctrltail + 1) & (HID_CONTROL_FIFO_SIZE - 1);
 
 		if (usbhid->ctrlhead != usbhid->ctrltail &&
@@ -1214,9 +1214,20 @@ static void usbhid_stop(struct hid_device *hid)
 	mutex_lock(&usbhid->mutex);
 
 	clear_bit(HID_STARTED, &usbhid->iofl);
+
 	spin_lock_irq(&usbhid->lock);	/* Sync with error and led handlers */
 	set_bit(HID_DISCONNECTED, &usbhid->iofl);
+	while (usbhid->ctrltail != usbhid->ctrlhead) {
+		if (usbhid->ctrl[usbhid->ctrltail].dir == USB_DIR_OUT) {
+			kfree(usbhid->ctrl[usbhid->ctrltail].raw_report);
+			usbhid->ctrl[usbhid->ctrltail].raw_report = NULL;
+		}
+
+		usbhid->ctrltail = (usbhid->ctrltail + 1) &
+			(HID_CONTROL_FIFO_SIZE - 1);
+	}
 	spin_unlock_irq(&usbhid->lock);
+
 	usb_kill_urb(usbhid->urbin);
 	usb_kill_urb(usbhid->urbout);
 	usb_kill_urb(usbhid->urbctrl);
diff --git a/drivers/hwmon/tmp421.c b/drivers/hwmon/tmp421.c
index ceb3db6f3fdd..c45968454110 100644
--- a/drivers/hwmon/tmp421.c
+++ b/drivers/hwmon/tmp421.c
@@ -109,23 +109,17 @@ struct tmp421_data {
 	s16 temp[4];
 };
 
-static int temp_from_s16(s16 reg)
+static int temp_from_raw(u16 reg, bool extended)
 {
 	/* Mask out status bits */
 	int temp = reg & ~0xf;
 
-	return (temp * 1000 + 128) / 256;
-}
-
-static int temp_from_u16(u16 reg)
-{
-	/* Mask out status bits */
-	int temp = reg & ~0xf;
-
-	/* Add offset for extended temperature range. */
-	temp -= 64 * 256;
+	if (extended)
+		temp = temp - 64 * 256;
+	else
+		temp = (s16)temp;
 
-	return (temp * 1000 + 128) / 256;
+	return DIV_ROUND_CLOSEST(temp * 1000, 256);
 }
 
 static struct tmp421_data *tmp421_update_device(struct device *dev)
@@ -162,10 +156,8 @@ static int tmp421_read(struct device *dev, enum hwmon_sensor_types type,
 
 	switch (attr) {
 	case hwmon_temp_input:
-		if (tmp421->config & TMP421_CONFIG_RANGE)
-			*val = temp_from_u16(tmp421->temp[channel]);
-		else
-			*val = temp_from_s16(tmp421->temp[channel]);
+		*val = temp_from_raw(tmp421->temp[channel],
+				     tmp421->config & TMP421_CONFIG_RANGE);
 		return 0;
 	case hwmon_temp_fault:
 		/*
diff --git a/drivers/ipack/devices/ipoctal.c b/drivers/ipack/devices/ipoctal.c
index 75dd15d66df6..f558aeb8f888 100644
--- a/drivers/ipack/devices/ipoctal.c
+++ b/drivers/ipack/devices/ipoctal.c
@@ -38,6 +38,7 @@ struct ipoctal_channel {
 	unsigned int			pointer_read;
 	unsigned int			pointer_write;
 	struct tty_port			tty_port;
+	bool				tty_registered;
 	union scc2698_channel __iomem	*regs;
 	union scc2698_block __iomem	*block_regs;
 	unsigned int			board_id;
@@ -86,22 +87,34 @@ static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
 	return 0;
 }
 
-static int ipoctal_open(struct tty_struct *tty, struct file *file)
+static int ipoctal_install(struct tty_driver *driver, struct tty_struct *tty)
 {
 	struct ipoctal_channel *channel = dev_get_drvdata(tty->dev);
 	struct ipoctal *ipoctal = chan_to_ipoctal(channel, tty->index);
-	int err;
-
-	tty->driver_data = channel;
+	int res;
 
 	if (!ipack_get_carrier(ipoctal->dev))
 		return -EBUSY;
 
-	err = tty_port_open(&channel->tty_port, tty, file);
-	if (err)
-		ipack_put_carrier(ipoctal->dev);
+	res = tty_standard_install(driver, tty);
+	if (res)
+		goto err_put_carrier;
+
+	tty->driver_data = channel;
+
+	return 0;
+
+err_put_carrier:
+	ipack_put_carrier(ipoctal->dev);
+
+	return res;
+}
+
+static int ipoctal_open(struct tty_struct *tty, struct file *file)
+{
+	struct ipoctal_channel *channel = tty->driver_data;
 
-	return err;
+	return tty_port_open(&channel->tty_port, tty, file);
 }
 
 static void ipoctal_reset_stats(struct ipoctal_stats *stats)
@@ -269,7 +282,6 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	int res;
 	int i;
 	struct tty_driver *tty;
-	char name[20];
 	struct ipoctal_channel *channel;
 	struct ipack_region *region;
 	void __iomem *addr;
@@ -360,8 +372,11 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	/* Fill struct tty_driver with ipoctal data */
 	tty->owner = THIS_MODULE;
 	tty->driver_name = KBUILD_MODNAME;
-	sprintf(name, KBUILD_MODNAME ".%d.%d.", bus_nr, slot);
-	tty->name = name;
+	tty->name = kasprintf(GFP_KERNEL, KBUILD_MODNAME ".%d.%d.", bus_nr, slot);
+	if (!tty->name) {
+		res = -ENOMEM;
+		goto err_put_driver;
+	}
 	tty->major = 0;
 
 	tty->minor_start = 0;
@@ -377,8 +392,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	res = tty_register_driver(tty);
 	if (res) {
 		dev_err(&ipoctal->dev->dev, "Can't register tty driver.\n");
-		put_tty_driver(tty);
-		return res;
+		goto err_free_name;
 	}
 
 	/* Save struct tty_driver for use it when uninstalling the device */
@@ -389,7 +403,9 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 
 		channel = &ipoctal->channel[i];
 		tty_port_init(&channel->tty_port);
-		tty_port_alloc_xmit_buf(&channel->tty_port);
+		res = tty_port_alloc_xmit_buf(&channel->tty_port);
+		if (res)
+			continue;
 		channel->tty_port.ops = &ipoctal_tty_port_ops;
 
 		ipoctal_reset_stats(&channel->stats);
@@ -397,13 +413,15 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		spin_lock_init(&channel->lock);
 		channel->pointer_read = 0;
 		channel->pointer_write = 0;
-		tty_dev = tty_port_register_device(&channel->tty_port, tty, i, NULL);
+		tty_dev = tty_port_register_device_attr(&channel->tty_port, tty,
+							i, NULL, channel, NULL);
 		if (IS_ERR(tty_dev)) {
 			dev_err(&ipoctal->dev->dev, "Failed to register tty device.\n");
+			tty_port_free_xmit_buf(&channel->tty_port);
 			tty_port_destroy(&channel->tty_port);
 			continue;
 		}
-		dev_set_drvdata(tty_dev, channel);
+		channel->tty_registered = true;
 	}
 
 	/*
@@ -415,6 +433,13 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 				       ipoctal_irq_handler, ipoctal);
 
 	return 0;
+
+err_free_name:
+	kfree(tty->name);
+err_put_driver:
+	put_tty_driver(tty);
+
+	return res;
 }
 
 static inline int ipoctal_copy_write_buffer(struct ipoctal_channel *channel,
@@ -655,6 +680,7 @@ static void ipoctal_cleanup(struct tty_struct *tty)
 
 static const struct tty_operations ipoctal_fops = {
 	.ioctl =		NULL,
+	.install =		ipoctal_install,
 	.open =			ipoctal_open,
 	.close =		ipoctal_close,
 	.write =		ipoctal_write_tty,
@@ -697,12 +723,17 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 
 	for (i = 0; i < NR_CHANNELS; i++) {
 		struct ipoctal_channel *channel = &ipoctal->channel[i];
+
+		if (!channel->tty_registered)
+			continue;
+
 		tty_unregister_device(ipoctal->tty_drv, i);
 		tty_port_free_xmit_buf(&channel->tty_port);
 		tty_port_destroy(&channel->tty_port);
 	}
 
 	tty_unregister_driver(ipoctal->tty_drv);
+	kfree(ipoctal->tty_drv->name);
 	put_tty_driver(ipoctal->tty_drv);
 	kfree(ipoctal);
 }
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 1d2267c6d31a..85b4610e6dc4 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2730,7 +2730,7 @@ static int its_vpe_irq_domain_alloc(struct irq_domain *domain, unsigned int virq
 
 	if (err) {
 		if (i > 0)
-			its_vpe_irq_domain_free(domain, virq, i - 1);
+			its_vpe_irq_domain_free(domain, virq, i);
 
 		its_lpi_free_chunks(bitmap, base, nr_ids);
 		its_free_prop_table(vprop_page);
diff --git a/drivers/mcb/mcb-core.c b/drivers/mcb/mcb-core.c
index bb5c5692dedc..118d27ee31c2 100644
--- a/drivers/mcb/mcb-core.c
+++ b/drivers/mcb/mcb-core.c
@@ -280,8 +280,8 @@ struct mcb_bus *mcb_alloc_bus(struct device *carrier)
 
 	bus_nr = ida_simple_get(&mcb_ida, 0, 0, GFP_KERNEL);
 	if (bus_nr < 0) {
-		rc = bus_nr;
-		goto err_free;
+		kfree(bus);
+		return ERR_PTR(bus_nr);
 	}
 
 	bus->bus_nr = bus_nr;
@@ -296,12 +296,12 @@ struct mcb_bus *mcb_alloc_bus(struct device *carrier)
 	dev_set_name(&bus->dev, "mcb:%d", bus_nr);
 	rc = device_add(&bus->dev);
 	if (rc)
-		goto err_free;
+		goto err_put;
 
 	return bus;
-err_free:
-	put_device(carrier);
-	kfree(bus);
+
+err_put:
+	put_device(&bus->dev);
 	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL_GPL(mcb_alloc_bus);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0af9aa187ce5..5e8706a66c31 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5375,10 +5375,6 @@ static int md_alloc(dev_t dev, char *name)
 	 */
 	disk->flags |= GENHD_FL_EXT_DEVT;
 	mddev->gendisk = disk;
-	/* As soon as we call add_disk(), another thread could get
-	 * through to md_open, so make sure it doesn't get too far
-	 */
-	mutex_lock(&mddev->open_mutex);
 	add_disk(disk);
 
 	error = kobject_init_and_add(&mddev->kobj, &md_ktype,
@@ -5394,7 +5390,6 @@ static int md_alloc(dev_t dev, char *name)
 	if (mddev->kobj.sd &&
 	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
 		pr_debug("pointless warning\n");
-	mutex_unlock(&mddev->open_mutex);
  abort:
 	mutex_unlock(&disks_mutex);
 	if (!error && mddev->kobj.sd) {
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index c4b0c35a270c..17592aeb2618 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -278,7 +278,7 @@ static bool bnxt_txr_netif_try_stop_queue(struct bnxt *bp,
 	 * netif_tx_queue_stopped().
 	 */
 	smp_mb();
-	if (bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh) {
+	if (bnxt_tx_avail(bp, txr) >= bp->tx_wake_thresh) {
 		netif_tx_wake_queue(txq);
 		return false;
 	}
@@ -609,7 +609,7 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
 	smp_mb();
 
 	if (unlikely(netif_tx_queue_stopped(txq)) &&
-	    bnxt_tx_avail(bp, txr) > bp->tx_wake_thresh &&
+	    bnxt_tx_avail(bp, txr) >= bp->tx_wake_thresh &&
 	    READ_ONCE(txr->dev_state) != BNXT_DEV_STATE_CLOSING)
 		netif_tx_wake_queue(txq);
 }
@@ -1888,7 +1888,7 @@ static int bnxt_poll_work(struct bnxt *bp, struct bnxt_napi *bnapi, int budget)
 		if (TX_CMP_TYPE(txcmp) == CMP_TYPE_TX_L2_CMP) {
 			tx_pkts++;
 			/* return full budget so NAPI will complete. */
-			if (unlikely(tx_pkts > bp->tx_wake_thresh)) {
+			if (unlikely(tx_pkts >= bp->tx_wake_thresh)) {
 				rx_pkts = budget;
 				raw_cons = NEXT_RAW_CMP(raw_cons);
 				break;
@@ -2662,7 +2662,7 @@ static int bnxt_init_tx_rings(struct bnxt *bp)
 	u16 i;
 
 	bp->tx_wake_thresh = max_t(int, bp->tx_ring_size / 2,
-				   MAX_SKB_FRAGS + 1);
+				   BNXT_MIN_TX_DESC_CNT);
 
 	for (i = 0; i < bp->tx_nr_rings; i++) {
 		struct bnxt_tx_ring_info *txr = &bp->tx_ring[i];
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 5aaf7f5a23dc..ad0a69a81f10 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -477,6 +477,11 @@ struct rx_tpa_end_cmp_ext {
 #define BNXT_MAX_RX_JUM_DESC_CNT	(RX_DESC_CNT * MAX_RX_AGG_PAGES - 1)
 #define BNXT_MAX_TX_DESC_CNT		(TX_DESC_CNT * MAX_TX_PAGES - 1)
 
+/* Minimum TX BDs for a TX packet with MAX_SKB_FRAGS + 1.  We need one extra
+ * BD because the first TX BD is always a long BD.
+ */
+#define BNXT_MIN_TX_DESC_CNT		(MAX_SKB_FRAGS + 2)
+
 #define RX_RING(x)	(((x) & ~(RX_DESC_CNT - 1)) >> (BNXT_PAGE_SHIFT - 4))
 #define RX_IDX(x)	((x) & (RX_DESC_CNT - 1))
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index e8544e8637db..e3123cb0fb70 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -348,7 +348,7 @@ static int bnxt_set_ringparam(struct net_device *dev,
 
 	if ((ering->rx_pending > BNXT_MAX_RX_DESC_CNT) ||
 	    (ering->tx_pending > BNXT_MAX_TX_DESC_CNT) ||
-	    (ering->tx_pending <= MAX_SKB_FRAGS))
+	    (ering->tx_pending < BNXT_MIN_TX_DESC_CNT))
 		return -EINVAL;
 
 	if (netif_running(dev))
diff --git a/drivers/net/ethernet/cadence/macb_pci.c b/drivers/net/ethernet/cadence/macb_pci.c
index 248a8fc45069..f06fddf9919b 100644
--- a/drivers/net/ethernet/cadence/macb_pci.c
+++ b/drivers/net/ethernet/cadence/macb_pci.c
@@ -123,9 +123,9 @@ static void macb_remove(struct pci_dev *pdev)
 	struct platform_device *plat_dev = pci_get_drvdata(pdev);
 	struct macb_platform_data *plat_data = dev_get_platdata(&plat_dev->dev);
 
-	platform_device_unregister(plat_dev);
 	clk_unregister(plat_data->pclk);
 	clk_unregister(plat_data->hclk);
+	platform_device_unregister(plat_dev);
 }
 
 static const struct pci_device_id dev_id_table[] = {
diff --git a/drivers/net/ethernet/i825xx/82596.c b/drivers/net/ethernet/i825xx/82596.c
index d719668a6684..8efcec305fc5 100644
--- a/drivers/net/ethernet/i825xx/82596.c
+++ b/drivers/net/ethernet/i825xx/82596.c
@@ -1155,7 +1155,7 @@ struct net_device * __init i82596_probe(int unit)
 			err = -ENODEV;
 			goto out;
 		}
-		memcpy(eth_addr, (void *) 0xfffc1f2c, ETH_ALEN);	/* YUCK! Get addr from NOVRAM */
+		memcpy(eth_addr, absolute_pointer(0xfffc1f2c), ETH_ALEN); /* YUCK! Get addr from NOVRAM */
 		dev->base_addr = MVME_I596_BASE;
 		dev->irq = (unsigned) MVME16x_IRQ_I596;
 		goto found;
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index a73102357bbd..20961985ed12 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -2459,11 +2459,15 @@ static void e100_get_drvinfo(struct net_device *netdev,
 		sizeof(info->bus_info));
 }
 
-#define E100_PHY_REGS 0x1C
+#define E100_PHY_REGS 0x1D
 static int e100_get_regs_len(struct net_device *netdev)
 {
 	struct nic *nic = netdev_priv(netdev);
-	return 1 + E100_PHY_REGS + sizeof(nic->mem->dump_buf);
+
+	/* We know the number of registers, and the size of the dump buffer.
+	 * Calculate the total size in bytes.
+	 */
+	return (1 + E100_PHY_REGS) * sizeof(u32) + sizeof(nic->mem->dump_buf);
 }
 
 static void e100_get_regs(struct net_device *netdev,
@@ -2477,14 +2481,18 @@ static void e100_get_regs(struct net_device *netdev,
 	buff[0] = ioread8(&nic->csr->scb.cmd_hi) << 24 |
 		ioread8(&nic->csr->scb.cmd_lo) << 16 |
 		ioread16(&nic->csr->scb.status);
-	for (i = E100_PHY_REGS; i >= 0; i--)
-		buff[1 + E100_PHY_REGS - i] =
-			mdio_read(netdev, nic->mii.phy_id, i);
+	for (i = 0; i < E100_PHY_REGS; i++)
+		/* Note that we read the registers in reverse order. This
+		 * ordering is the ABI apparently used by ethtool and other
+		 * applications.
+		 */
+		buff[1 + i] = mdio_read(netdev, nic->mii.phy_id,
+					E100_PHY_REGS - 1 - i);
 	memset(nic->mem->dump_buf, 0, sizeof(nic->mem->dump_buf));
 	e100_exec_cb(nic, NULL, e100_dump);
 	msleep(10);
-	memcpy(&buff[2 + E100_PHY_REGS], nic->mem->dump_buf,
-		sizeof(nic->mem->dump_buf));
+	memcpy(&buff[1 + E100_PHY_REGS], nic->mem->dump_buf,
+	       sizeof(nic->mem->dump_buf));
 }
 
 static void e100_get_wol(struct net_device *netdev, struct ethtool_wolinfo *wol)
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
index b27dbc34df02..5f8709aa0f4e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_netdev.c
@@ -363,6 +363,9 @@ mlx4_en_filter_rfs(struct net_device *net_dev, const struct sk_buff *skb,
 	int nhoff = skb_network_offset(skb);
 	int ret = 0;
 
+	if (skb->encapsulation)
+		return -EPROTONOSUPPORT;
+
 	if (skb->protocol != htons(ETH_P_IP))
 		return -EPROTONOSUPPORT;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index a7b30f060536..2be2b3055904 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -232,7 +232,7 @@ static void stmmac_clk_csr_set(struct stmmac_priv *priv)
 			priv->clk_csr = STMMAC_CSR_100_150M;
 		else if ((clk_rate >= CSR_F_150M) && (clk_rate < CSR_F_250M))
 			priv->clk_csr = STMMAC_CSR_150_250M;
-		else if ((clk_rate >= CSR_F_250M) && (clk_rate < CSR_F_300M))
+		else if ((clk_rate >= CSR_F_250M) && (clk_rate <= CSR_F_300M))
 			priv->clk_csr = STMMAC_CSR_250_300M;
 	}
 
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 231eaef29266..7e430300818e 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -68,9 +68,9 @@
 #define SIXP_DAMA_OFF		0
 
 /* default level 2 parameters */
-#define SIXP_TXDELAY			(HZ/4)	/* in 1 s */
+#define SIXP_TXDELAY			25	/* 250 ms */
 #define SIXP_PERSIST			50	/* in 256ths */
-#define SIXP_SLOTTIME			(HZ/10)	/* in 1 s */
+#define SIXP_SLOTTIME			10	/* 100 ms */
 #define SIXP_INIT_RESYNC_TIMEOUT	(3*HZ/2) /* in 1 s */
 #define SIXP_RESYNC_TIMEOUT		5*HZ	/* in 1 s */
 
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 3c3c6a8c37ee..e8574c6fd91e 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -2510,7 +2510,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 			   hso_net_init);
 	if (!net) {
 		dev_err(&interface->dev, "Unable to create ethernet device\n");
-		goto exit;
+		goto err_hso_dev;
 	}
 
 	hso_net = netdev_priv(net);
@@ -2523,13 +2523,13 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 				      USB_DIR_IN);
 	if (!hso_net->in_endp) {
 		dev_err(&interface->dev, "Can't find BULK IN endpoint\n");
-		goto exit;
+		goto err_net;
 	}
 	hso_net->out_endp = hso_get_ep(interface, USB_ENDPOINT_XFER_BULK,
 				       USB_DIR_OUT);
 	if (!hso_net->out_endp) {
 		dev_err(&interface->dev, "Can't find BULK OUT endpoint\n");
-		goto exit;
+		goto err_net;
 	}
 	SET_NETDEV_DEV(net, &interface->dev);
 	SET_NETDEV_DEVTYPE(net, &hso_type);
@@ -2538,18 +2538,18 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
 		hso_net->mux_bulk_rx_urb_pool[i] = usb_alloc_urb(0, GFP_KERNEL);
 		if (!hso_net->mux_bulk_rx_urb_pool[i])
-			goto exit;
+			goto err_mux_bulk_rx;
 		hso_net->mux_bulk_rx_buf_pool[i] = kzalloc(MUX_BULK_RX_BUF_SIZE,
 							   GFP_KERNEL);
 		if (!hso_net->mux_bulk_rx_buf_pool[i])
-			goto exit;
+			goto err_mux_bulk_rx;
 	}
 	hso_net->mux_bulk_tx_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!hso_net->mux_bulk_tx_urb)
-		goto exit;
+		goto err_mux_bulk_rx;
 	hso_net->mux_bulk_tx_buf = kzalloc(MUX_BULK_TX_BUF_SIZE, GFP_KERNEL);
 	if (!hso_net->mux_bulk_tx_buf)
-		goto exit;
+		goto err_free_tx_urb;
 
 	add_net_device(hso_dev);
 
@@ -2557,7 +2557,7 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	result = register_netdev(net);
 	if (result) {
 		dev_err(&interface->dev, "Failed to register device\n");
-		goto exit;
+		goto err_free_tx_buf;
 	}
 
 	hso_log_port(hso_dev);
@@ -2565,8 +2565,21 @@ static struct hso_device *hso_create_net_device(struct usb_interface *interface,
 	hso_create_rfkill(hso_dev, interface);
 
 	return hso_dev;
-exit:
-	hso_free_net_device(hso_dev);
+
+err_free_tx_buf:
+	remove_net_device(hso_dev);
+	kfree(hso_net->mux_bulk_tx_buf);
+err_free_tx_urb:
+	usb_free_urb(hso_net->mux_bulk_tx_urb);
+err_mux_bulk_rx:
+	for (i = 0; i < MUX_BULK_RX_BUF_COUNT; i++) {
+		usb_free_urb(hso_net->mux_bulk_rx_urb_pool[i]);
+		kfree(hso_net->mux_bulk_rx_buf_pool[i]);
+	}
+err_net:
+	free_netdev(net);
+err_hso_dev:
+	kfree(hso_dev);
 	return NULL;
 }
 
@@ -2713,14 +2726,14 @@ struct hso_device *hso_create_mux_serial_device(struct usb_interface *interface,
 
 	serial = kzalloc(sizeof(*serial), GFP_KERNEL);
 	if (!serial)
-		goto exit;
+		goto err_free_dev;
 
 	hso_dev->port_data.dev_serial = serial;
 	serial->parent = hso_dev;
 
 	if (hso_serial_common_create
 	    (serial, 1, CTRL_URB_RX_SIZE, CTRL_URB_TX_SIZE))
-		goto exit;
+		goto err_free_serial;
 
 	serial->tx_data_length--;
 	serial->write_data = hso_mux_serial_write_data;
@@ -2736,11 +2749,9 @@ struct hso_device *hso_create_mux_serial_device(struct usb_interface *interface,
 	/* done, return it */
 	return hso_dev;
 
-exit:
-	if (serial) {
-		tty_unregister_device(tty_drv, serial->minor);
-		kfree(serial);
-	}
+err_free_serial:
+	kfree(serial);
+err_free_dev:
 	kfree(hso_dev);
 	return NULL;
 
diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index f84166f99517..4214f66d405b 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -55,7 +55,8 @@
 #define   PIO_COMPLETION_STATUS_UR		1
 #define   PIO_COMPLETION_STATUS_CRS		2
 #define   PIO_COMPLETION_STATUS_CA		4
-#define   PIO_NON_POSTED_REQ			BIT(0)
+#define   PIO_NON_POSTED_REQ			BIT(10)
+#define   PIO_ERR_STATUS			BIT(11)
 #define PIO_ADDR_LS				(PIO_BASE_ADDR + 0x8)
 #define PIO_ADDR_MS				(PIO_BASE_ADDR + 0xc)
 #define PIO_WR_DATA				(PIO_BASE_ADDR + 0x10)
@@ -374,7 +375,7 @@ static void advk_pcie_setup_hw(struct advk_pcie *pcie)
 	advk_writel(pcie, reg, PCIE_CORE_CMD_STATUS_REG);
 }
 
-static void advk_pcie_check_pio_status(struct advk_pcie *pcie)
+static int advk_pcie_check_pio_status(struct advk_pcie *pcie, u32 *val)
 {
 	struct device *dev = &pcie->pdev->dev;
 	u32 reg;
@@ -385,14 +386,49 @@ static void advk_pcie_check_pio_status(struct advk_pcie *pcie)
 	status = (reg & PIO_COMPLETION_STATUS_MASK) >>
 		PIO_COMPLETION_STATUS_SHIFT;
 
-	if (!status)
-		return;
-
+	/*
+	 * According to HW spec, the PIO status check sequence as below:
+	 * 1) even if COMPLETION_STATUS(bit9:7) indicates successful,
+	 *    it still needs to check Error Status(bit11), only when this bit
+	 *    indicates no error happen, the operation is successful.
+	 * 2) value Unsupported Request(1) of COMPLETION_STATUS(bit9:7) only
+	 *    means a PIO write error, and for PIO read it is successful with
+	 *    a read value of 0xFFFFFFFF.
+	 * 3) value Completion Retry Status(CRS) of COMPLETION_STATUS(bit9:7)
+	 *    only means a PIO write error, and for PIO read it is successful
+	 *    with a read value of 0xFFFF0001.
+	 * 4) value Completer Abort (CA) of COMPLETION_STATUS(bit9:7) means
+	 *    error for both PIO read and PIO write operation.
+	 * 5) other errors are indicated as 'unknown'.
+	 */
 	switch (status) {
+	case PIO_COMPLETION_STATUS_OK:
+		if (reg & PIO_ERR_STATUS) {
+			strcomp_status = "COMP_ERR";
+			break;
+		}
+		/* Get the read result */
+		if (val)
+			*val = advk_readl(pcie, PIO_RD_DATA);
+		/* No error */
+		strcomp_status = NULL;
+		break;
 	case PIO_COMPLETION_STATUS_UR:
 		strcomp_status = "UR";
 		break;
 	case PIO_COMPLETION_STATUS_CRS:
+		/* PCIe r4.0, sec 2.3.2, says:
+		 * If CRS Software Visibility is not enabled, the Root Complex
+		 * must re-issue the Configuration Request as a new Request.
+		 * A Root Complex implementation may choose to limit the number
+		 * of Configuration Request/CRS Completion Status loops before
+		 * determining that something is wrong with the target of the
+		 * Request and taking appropriate action, e.g., complete the
+		 * Request to the host as a failed transaction.
+		 *
+		 * To simplify implementation do not re-issue the Configuration
+		 * Request and complete the Request as a failed transaction.
+		 */
 		strcomp_status = "CRS";
 		break;
 	case PIO_COMPLETION_STATUS_CA:
@@ -403,6 +439,9 @@ static void advk_pcie_check_pio_status(struct advk_pcie *pcie)
 		break;
 	}
 
+	if (!strcomp_status)
+		return 0;
+
 	if (reg & PIO_NON_POSTED_REQ)
 		str_posted = "Non-posted";
 	else
@@ -410,6 +449,8 @@ static void advk_pcie_check_pio_status(struct advk_pcie *pcie)
 
 	dev_err(dev, "%s PIO Response Status: %s, %#x @ %#x\n",
 		str_posted, strcomp_status, reg, advk_readl(pcie, PIO_ADDR_LS));
+
+	return -EFAULT;
 }
 
 static int advk_pcie_wait_pio(struct advk_pcie *pcie)
@@ -502,10 +543,13 @@ static int advk_pcie_rd_conf(struct pci_bus *bus, u32 devfn,
 	if (ret < 0)
 		return PCIBIOS_SET_FAILED;
 
-	advk_pcie_check_pio_status(pcie);
+	/* Check PIO status and get the read result */
+	ret = advk_pcie_check_pio_status(pcie, val);
+	if (ret < 0) {
+		*val = 0xffffffff;
+		return PCIBIOS_SET_FAILED;
+	}
 
-	/* Get the read result */
-	*val = advk_readl(pcie, PIO_RD_DATA);
 	if (size == 1)
 		*val = (*val >> (8 * (where & 3))) & 0xff;
 	else if (size == 2)
@@ -565,7 +609,9 @@ static int advk_pcie_wr_conf(struct pci_bus *bus, u32 devfn,
 	if (ret < 0)
 		return PCIBIOS_SET_FAILED;
 
-	advk_pcie_check_pio_status(pcie);
+	ret = advk_pcie_check_pio_status(pcie, NULL);
+	if (ret < 0)
+		return PCIBIOS_SET_FAILED;
 
 	return PCIBIOS_SUCCESSFUL;
 }
diff --git a/drivers/scsi/csiostor/csio_init.c b/drivers/scsi/csiostor/csio_init.c
index 03c7b1603dbc..c64db2047efc 100644
--- a/drivers/scsi/csiostor/csio_init.c
+++ b/drivers/scsi/csiostor/csio_init.c
@@ -1260,3 +1260,4 @@ MODULE_DEVICE_TABLE(pci, csio_pci_tbl);
 MODULE_VERSION(CSIO_DRV_VERSION);
 MODULE_FIRMWARE(FW_FNAME_T5);
 MODULE_FIRMWARE(FW_FNAME_T6);
+MODULE_SOFTDEP("pre: cxgb4");
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 064c941e5483..d276d84c0f7a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -429,9 +429,7 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 	struct iscsi_transport *t = iface->transport;
 	int param = -1;
 
-	if (attr == &dev_attr_iface_enabled.attr)
-		param = ISCSI_NET_PARAM_IFACE_ENABLE;
-	else if (attr == &dev_attr_iface_def_taskmgmt_tmo.attr)
+	if (attr == &dev_attr_iface_def_taskmgmt_tmo.attr)
 		param = ISCSI_IFACE_PARAM_DEF_TASKMGMT_TMO;
 	else if (attr == &dev_attr_iface_header_digest.attr)
 		param = ISCSI_IFACE_PARAM_HDRDGST_EN;
@@ -471,7 +469,9 @@ static umode_t iscsi_iface_attr_is_visible(struct kobject *kobj,
 	if (param != -1)
 		return t->attr_is_visible(ISCSI_IFACE_PARAM, param);
 
-	if (attr == &dev_attr_iface_vlan_id.attr)
+	if (attr == &dev_attr_iface_enabled.attr)
+		param = ISCSI_NET_PARAM_IFACE_ENABLE;
+	else if (attr == &dev_attr_iface_vlan_id.attr)
 		param = ISCSI_NET_PARAM_VLAN_ID;
 	else if (attr == &dev_attr_iface_vlan_priority.attr)
 		param = ISCSI_NET_PARAM_VLAN_PRIORITY;
diff --git a/drivers/spi/spi-tegra20-slink.c b/drivers/spi/spi-tegra20-slink.c
index c39bfcbda5f2..1548f7b738c1 100644
--- a/drivers/spi/spi-tegra20-slink.c
+++ b/drivers/spi/spi-tegra20-slink.c
@@ -1210,7 +1210,7 @@ static int tegra_slink_resume(struct device *dev)
 }
 #endif
 
-static int tegra_slink_runtime_suspend(struct device *dev)
+static int __maybe_unused tegra_slink_runtime_suspend(struct device *dev)
 {
 	struct spi_master *master = dev_get_drvdata(dev);
 	struct tegra_slink_data *tspi = spi_master_get_devdata(master);
@@ -1222,7 +1222,7 @@ static int tegra_slink_runtime_suspend(struct device *dev)
 	return 0;
 }
 
-static int tegra_slink_runtime_resume(struct device *dev)
+static int __maybe_unused tegra_slink_runtime_resume(struct device *dev)
 {
 	struct spi_master *master = dev_get_drvdata(dev);
 	struct tegra_slink_data *tspi = spi_master_get_devdata(master);
diff --git a/drivers/staging/greybus/uart.c b/drivers/staging/greybus/uart.c
index b0b7d4a1cee4..770fc7185ed5 100644
--- a/drivers/staging/greybus/uart.c
+++ b/drivers/staging/greybus/uart.c
@@ -800,6 +800,17 @@ static void gb_tty_port_shutdown(struct tty_port *port)
 	gbphy_runtime_put_autosuspend(gb_tty->gbphy_dev);
 }
 
+static void gb_tty_port_destruct(struct tty_port *port)
+{
+	struct gb_tty *gb_tty = container_of(port, struct gb_tty, port);
+
+	if (gb_tty->minor != GB_NUM_MINORS)
+		release_minor(gb_tty);
+	kfifo_free(&gb_tty->write_fifo);
+	kfree(gb_tty->buffer);
+	kfree(gb_tty);
+}
+
 static const struct tty_operations gb_ops = {
 	.install =		gb_tty_install,
 	.open =			gb_tty_open,
@@ -823,6 +834,7 @@ static const struct tty_port_operations gb_port_ops = {
 	.dtr_rts =		gb_tty_dtr_rts,
 	.activate =		gb_tty_port_activate,
 	.shutdown =		gb_tty_port_shutdown,
+	.destruct =		gb_tty_port_destruct,
 };
 
 static int gb_uart_probe(struct gbphy_device *gbphy_dev,
@@ -835,17 +847,11 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
 	int retval;
 	int minor;
 
-	gb_tty = kzalloc(sizeof(*gb_tty), GFP_KERNEL);
-	if (!gb_tty)
-		return -ENOMEM;
-
 	connection = gb_connection_create(gbphy_dev->bundle,
 					  le16_to_cpu(gbphy_dev->cport_desc->id),
 					  gb_uart_request_handler);
-	if (IS_ERR(connection)) {
-		retval = PTR_ERR(connection);
-		goto exit_tty_free;
-	}
+	if (IS_ERR(connection))
+		return PTR_ERR(connection);
 
 	max_payload = gb_operation_get_payload_size_max(connection);
 	if (max_payload < sizeof(struct gb_uart_send_data_request)) {
@@ -853,13 +859,23 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
 		goto exit_connection_destroy;
 	}
 
+	gb_tty = kzalloc(sizeof(*gb_tty), GFP_KERNEL);
+	if (!gb_tty) {
+		retval = -ENOMEM;
+		goto exit_connection_destroy;
+	}
+
+	tty_port_init(&gb_tty->port);
+	gb_tty->port.ops = &gb_port_ops;
+	gb_tty->minor = GB_NUM_MINORS;
+
 	gb_tty->buffer_payload_max = max_payload -
 			sizeof(struct gb_uart_send_data_request);
 
 	gb_tty->buffer = kzalloc(gb_tty->buffer_payload_max, GFP_KERNEL);
 	if (!gb_tty->buffer) {
 		retval = -ENOMEM;
-		goto exit_connection_destroy;
+		goto exit_put_port;
 	}
 
 	INIT_WORK(&gb_tty->tx_work, gb_uart_tx_write_work);
@@ -867,7 +883,7 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
 	retval = kfifo_alloc(&gb_tty->write_fifo, GB_UART_WRITE_FIFO_SIZE,
 			     GFP_KERNEL);
 	if (retval)
-		goto exit_buf_free;
+		goto exit_put_port;
 
 	gb_tty->credits = GB_UART_FIRMWARE_CREDITS;
 	init_completion(&gb_tty->credits_complete);
@@ -881,7 +897,7 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
 		} else {
 			retval = minor;
 		}
-		goto exit_kfifo_free;
+		goto exit_put_port;
 	}
 
 	gb_tty->minor = minor;
@@ -890,9 +906,6 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
 	init_waitqueue_head(&gb_tty->wioctl);
 	mutex_init(&gb_tty->mutex);
 
-	tty_port_init(&gb_tty->port);
-	gb_tty->port.ops = &gb_port_ops;
-
 	gb_tty->connection = connection;
 	gb_tty->gbphy_dev = gbphy_dev;
 	gb_connection_set_data(connection, gb_tty);
@@ -900,7 +913,7 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
 
 	retval = gb_connection_enable_tx(connection);
 	if (retval)
-		goto exit_release_minor;
+		goto exit_put_port;
 
 	send_control(gb_tty, gb_tty->ctrlout);
 
@@ -927,16 +940,10 @@ static int gb_uart_probe(struct gbphy_device *gbphy_dev,
 
 exit_connection_disable:
 	gb_connection_disable(connection);
-exit_release_minor:
-	release_minor(gb_tty);
-exit_kfifo_free:
-	kfifo_free(&gb_tty->write_fifo);
-exit_buf_free:
-	kfree(gb_tty->buffer);
+exit_put_port:
+	tty_port_put(&gb_tty->port);
 exit_connection_destroy:
 	gb_connection_destroy(connection);
-exit_tty_free:
-	kfree(gb_tty);
 
 	return retval;
 }
@@ -967,15 +974,10 @@ static void gb_uart_remove(struct gbphy_device *gbphy_dev)
 	gb_connection_disable_rx(connection);
 	tty_unregister_device(gb_tty_driver, gb_tty->minor);
 
-	/* FIXME - free transmit / receive buffers */
-
 	gb_connection_disable(connection);
-	tty_port_destroy(&gb_tty->port);
 	gb_connection_destroy(connection);
-	release_minor(gb_tty);
-	kfifo_free(&gb_tty->write_fifo);
-	kfree(gb_tty->buffer);
-	kfree(gb_tty);
+
+	tty_port_put(&gb_tty->port);
 }
 
 static int gb_tty_init(void)
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 2db83b555e59..94820f25a15f 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -231,15 +231,14 @@ int thermal_build_list_of_policies(char *buf)
 {
 	struct thermal_governor *pos;
 	ssize_t count = 0;
-	ssize_t size = PAGE_SIZE;
 
 	mutex_lock(&thermal_governor_lock);
 
 	list_for_each_entry(pos, &thermal_governor_list, governor_list) {
-		size = PAGE_SIZE - count;
-		count += scnprintf(buf + count, size, "%s ", pos->name);
+		count += scnprintf(buf + count, PAGE_SIZE - count, "%s ",
+				   pos->name);
 	}
-	count += scnprintf(buf + count, size, "\n");
+	count += scnprintf(buf + count, PAGE_SIZE - count, "\n");
 
 	mutex_unlock(&thermal_governor_lock);
 
diff --git a/drivers/tty/serial/mvebu-uart.c b/drivers/tty/serial/mvebu-uart.c
index a10e4aa9e18e..ffd454e4bacf 100644
--- a/drivers/tty/serial/mvebu-uart.c
+++ b/drivers/tty/serial/mvebu-uart.c
@@ -108,7 +108,7 @@ static unsigned int mvebu_uart_tx_empty(struct uart_port *port)
 	st = readl(port->membase + UART_STAT);
 	spin_unlock_irqrestore(&port->lock, flags);
 
-	return (st & STAT_TX_FIFO_EMP) ? TIOCSER_TEMT : 0;
+	return (st & STAT_TX_EMP) ? TIOCSER_TEMT : 0;
 }
 
 static unsigned int mvebu_uart_get_mctrl(struct uart_port *port)
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index d497208b43f4..f4ac5ec5dc02 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -883,8 +883,25 @@ static int vc_do_resize(struct tty_struct *tty, struct vc_data *vc,
 	new_row_size = new_cols << 1;
 	new_screen_size = new_row_size * new_rows;
 
-	if (new_cols == vc->vc_cols && new_rows == vc->vc_rows)
-		return 0;
+	if (new_cols == vc->vc_cols && new_rows == vc->vc_rows) {
+		/*
+		 * This function is being called here to cover the case
+		 * where the userspace calls the FBIOPUT_VSCREENINFO twice,
+		 * passing the same fb_var_screeninfo containing the fields
+		 * yres/xres equal to a number non-multiple of vc_font.height
+		 * and yres_virtual/xres_virtual equal to number lesser than the
+		 * vc_font.height and yres/xres.
+		 * In the second call, the struct fb_var_screeninfo isn't
+		 * being modified by the underlying driver because of the
+		 * if above, and this causes the fbcon_display->vrows to become
+		 * negative and it eventually leads to out-of-bound
+		 * access by the imageblit function.
+		 * To give the correct values to the struct and to not have
+		 * to deal with possible errors from the code below, we call
+		 * the resize_screen here as well.
+		 */
+		return resize_screen(vc, new_cols, new_rows, user);
+	}
 
 	if (new_screen_size > KMALLOC_MAX_SIZE || !new_screen_size)
 		return -EINVAL;
diff --git a/drivers/usb/gadget/udc/r8a66597-udc.c b/drivers/usb/gadget/udc/r8a66597-udc.c
index cf92f6aca433..1b21661cf504 100644
--- a/drivers/usb/gadget/udc/r8a66597-udc.c
+++ b/drivers/usb/gadget/udc/r8a66597-udc.c
@@ -1253,7 +1253,7 @@ static void set_feature(struct r8a66597 *r8a66597, struct usb_ctrlrequest *ctrl)
 			do {
 				tmp = r8a66597_read(r8a66597, INTSTS0) & CTSQ;
 				udelay(1);
-			} while (tmp != CS_IDST || timeout-- > 0);
+			} while (tmp != CS_IDST && timeout-- > 0);
 
 			if (tmp == CS_IDST)
 				r8a66597_bset(r8a66597,
diff --git a/drivers/usb/musb/tusb6010.c b/drivers/usb/musb/tusb6010.c
index 4eb640c54f2c..7d7cb1c5ec80 100644
--- a/drivers/usb/musb/tusb6010.c
+++ b/drivers/usb/musb/tusb6010.c
@@ -193,6 +193,7 @@ tusb_fifo_write_unaligned(void __iomem *fifo, const u8 *buf, u16 len)
 	}
 	if (len > 0) {
 		/* Write the rest 1 - 3 bytes to FIFO */
+		val = 0;
 		memcpy(&val, buf, len);
 		musb_writel(fifo, 0, val);
 	}
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index dd34ea3ef14e..6f00b11969c8 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -237,6 +237,7 @@ static const struct usb_device_id id_table[] = {
 	{ USB_DEVICE(0x1FB9, 0x0602) }, /* Lake Shore Model 648 Magnet Power Supply */
 	{ USB_DEVICE(0x1FB9, 0x0700) }, /* Lake Shore Model 737 VSM Controller */
 	{ USB_DEVICE(0x1FB9, 0x0701) }, /* Lake Shore Model 776 Hall Matrix */
+	{ USB_DEVICE(0x2184, 0x0030) }, /* GW Instek GDM-834x Digital Multimeter */
 	{ USB_DEVICE(0x2626, 0xEA60) }, /* Aruba Networks 7xxx USB Serial Console */
 	{ USB_DEVICE(0x3195, 0xF190) }, /* Link Instruments MSO-19 */
 	{ USB_DEVICE(0x3195, 0xF280) }, /* Link Instruments MSO-28 */
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index d30d7f585815..4480ef3d6fd2 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -126,7 +126,6 @@
 #define BANDB_DEVICE_ID_USOPTL4_2P       0xBC02
 #define BANDB_DEVICE_ID_USOPTL4_4        0xAC44
 #define BANDB_DEVICE_ID_USOPTL4_4P       0xBC03
-#define BANDB_DEVICE_ID_USOPTL2_4        0xAC24
 
 /* This driver also supports
  * ATEN UC2324 device using Moschip MCS7840
@@ -207,7 +206,6 @@ static const struct usb_device_id id_table[] = {
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_2P)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4)},
 	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL4_4P)},
-	{USB_DEVICE(USB_VENDOR_ID_BANDB, BANDB_DEVICE_ID_USOPTL2_4)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2324)},
 	{USB_DEVICE(USB_VENDOR_ID_ATENINTL, ATENINTL_DEVICE_ID_UC2322)},
 	{USB_DEVICE(USB_VENDOR_ID_MOXA, MOXA_DEVICE_ID_2210)},
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 655221780951..dabf7f2d8eb1 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -1208,6 +1208,14 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1056, 0xff),	/* Telit FD980 */
 	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1060, 0xff),	/* Telit LN920 (rmnet) */
+	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(2) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1061, 0xff),	/* Telit LN920 (MBIM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1062, 0xff),	/* Telit LN920 (RNDIS) */
+	  .driver_info = NCTRL(2) | RSVD(3) },
+	{ USB_DEVICE_INTERFACE_CLASS(TELIT_VENDOR_ID, 0x1063, 0xff),	/* Telit LN920 (ECM) */
+	  .driver_info = NCTRL(0) | RSVD(1) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910),
 	  .driver_info = NCTRL(0) | RSVD(1) | RSVD(3) },
 	{ USB_DEVICE(TELIT_VENDOR_ID, TELIT_PRODUCT_ME910_DUAL_MODEM),
@@ -1653,7 +1661,6 @@ static const struct usb_device_id option_ids[] = {
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0060, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0070, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0073, 0xff, 0xff, 0xff) },
-	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0094, 0xff, 0xff, 0xff) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0130, 0xff, 0xff, 0xff),
 	  .driver_info = RSVD(1) },
 	{ USB_DEVICE_AND_INTERFACE_INFO(ZTE_VENDOR_ID, 0x0133, 0xff, 0xff, 0xff),
@@ -2070,6 +2077,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
 	{ USB_DEVICE(0x0489, 0xe0b5),						/* Foxconn T77W968 ESIM */
 	  .driver_info = RSVD(0) | RSVD(1) | RSVD(6) },
+	{ USB_DEVICE_INTERFACE_CLASS(0x0489, 0xe0db, 0xff),			/* Foxconn T99W265 MBIM */
+	  .driver_info = RSVD(3) },
 	{ USB_DEVICE(0x1508, 0x1001),						/* Fibocom NL668 (IOT version) */
 	  .driver_info = RSVD(4) | RSVD(5) | RSVD(6) },
 	{ USB_DEVICE(0x2cb7, 0x0104),						/* Fibocom NL678 series */
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index a34818357caa..683830dd383f 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -435,9 +435,16 @@ UNUSUAL_DEV(  0x04cb, 0x0100, 0x0000, 0x2210,
 		USB_SC_UFI, USB_PR_DEVICE, NULL, US_FL_FIX_INQUIRY | US_FL_SINGLE_LUN),
 
 /*
- * Reported by Ondrej Zary <linux@rainbow-software.org>
+ * Reported by Ondrej Zary <linux@zary.sk>
  * The device reports one sector more and breaks when that sector is accessed
+ * Firmwares older than 2.6c (the latest one and the only that claims Linux
+ * support) have also broken tag handling
  */
+UNUSUAL_DEV(  0x04ce, 0x0002, 0x0000, 0x026b,
+		"ScanLogic",
+		"SL11R-IDE",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_FIX_CAPACITY | US_FL_BULK_IGNORE_TAG),
 UNUSUAL_DEV(  0x04ce, 0x0002, 0x026c, 0x026c,
 		"ScanLogic",
 		"SL11R-IDE",
diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 6f57fb0614fe..1effff26a2a6 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -63,7 +63,7 @@ UNUSUAL_DEV(0x059f, 0x1061, 0x0000, 0x9999,
 		"LaCie",
 		"Rugged USB3-FW",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_IGNORE_UAS),
+		US_FL_NO_REPORT_OPCODES | US_FL_NO_SAME),
 
 /*
  * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI
diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index a8e0836dffd4..a697c64a6506 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -43,6 +43,8 @@
 #include <linux/sched.h>
 #include <linux/cred.h>
 #include <linux/errno.h>
+#include <linux/freezer.h>
+#include <linux/kthread.h>
 #include <linux/mm.h>
 #include <linux/bootmem.h>
 #include <linux/pagemap.h>
@@ -119,7 +121,7 @@ static struct ctl_table xen_root[] = {
 #define EXTENT_ORDER (fls(XEN_PFN_PER_PAGE) - 1)
 
 /*
- * balloon_process() state:
+ * balloon_thread() state:
  *
  * BP_DONE: done or nothing to do,
  * BP_WAIT: wait to be rescheduled,
@@ -134,6 +136,8 @@ enum bp_state {
 	BP_ECANCELED
 };
 
+/* Main waiting point for xen-balloon thread. */
+static DECLARE_WAIT_QUEUE_HEAD(balloon_thread_wq);
 
 static DEFINE_MUTEX(balloon_mutex);
 
@@ -148,10 +152,6 @@ static xen_pfn_t frame_list[PAGE_SIZE / sizeof(xen_pfn_t)];
 static LIST_HEAD(ballooned_pages);
 static DECLARE_WAIT_QUEUE_HEAD(balloon_wq);
 
-/* Main work function, always executed in process context. */
-static void balloon_process(struct work_struct *work);
-static DECLARE_DELAYED_WORK(balloon_worker, balloon_process);
-
 /* When ballooning out (allocating memory to return to Xen) we don't really
    want the kernel to try too hard since that can trigger the oom killer. */
 #define GFP_BALLOON \
@@ -389,7 +389,7 @@ static void xen_online_page(struct page *page)
 static int xen_memory_notifier(struct notifier_block *nb, unsigned long val, void *v)
 {
 	if (val == MEM_ONLINE)
-		schedule_delayed_work(&balloon_worker, 0);
+		wake_up(&balloon_thread_wq);
 
 	return NOTIFY_OK;
 }
@@ -571,18 +571,43 @@ static enum bp_state decrease_reservation(unsigned long nr_pages, gfp_t gfp)
 }
 
 /*
- * As this is a work item it is guaranteed to run as a single instance only.
+ * Stop waiting if either state is not BP_EAGAIN and ballooning action is
+ * needed, or if the credit has changed while state is BP_EAGAIN.
+ */
+static bool balloon_thread_cond(enum bp_state state, long credit)
+{
+	if (state != BP_EAGAIN)
+		credit = 0;
+
+	return current_credit() != credit || kthread_should_stop();
+}
+
+/*
+ * As this is a kthread it is guaranteed to run as a single instance only.
  * We may of course race updates of the target counts (which are protected
  * by the balloon lock), or with changes to the Xen hard limit, but we will
  * recover from these in time.
  */
-static void balloon_process(struct work_struct *work)
+static int balloon_thread(void *unused)
 {
 	enum bp_state state = BP_DONE;
 	long credit;
+	unsigned long timeout;
+
+	set_freezable();
+	for (;;) {
+		if (state == BP_EAGAIN)
+			timeout = balloon_stats.schedule_delay * HZ;
+		else
+			timeout = 3600 * HZ;
+		credit = current_credit();
 
+		wait_event_freezable_timeout(balloon_thread_wq,
+			balloon_thread_cond(state, credit), timeout);
+
+		if (kthread_should_stop())
+			return 0;
 
-	do {
 		mutex_lock(&balloon_mutex);
 
 		credit = current_credit();
@@ -609,12 +634,7 @@ static void balloon_process(struct work_struct *work)
 		mutex_unlock(&balloon_mutex);
 
 		cond_resched();
-
-	} while (credit && state == BP_DONE);
-
-	/* Schedule more work if there is some still to be done. */
-	if (state == BP_EAGAIN)
-		schedule_delayed_work(&balloon_worker, balloon_stats.schedule_delay * HZ);
+	}
 }
 
 /* Resets the Xen limit, sets new target, and kicks off processing. */
@@ -622,7 +642,7 @@ void balloon_set_new_target(unsigned long target)
 {
 	/* No need for lock. Not read-modify-write updates. */
 	balloon_stats.target_pages = target;
-	schedule_delayed_work(&balloon_worker, 0);
+	wake_up(&balloon_thread_wq);
 }
 EXPORT_SYMBOL_GPL(balloon_set_new_target);
 
@@ -727,7 +747,7 @@ void free_xenballooned_pages(int nr_pages, struct page **pages)
 
 	/* The balloon may be too large now. Shrink it if needed. */
 	if (current_credit())
-		schedule_delayed_work(&balloon_worker, 0);
+		wake_up(&balloon_thread_wq);
 
 	mutex_unlock(&balloon_mutex);
 }
@@ -761,6 +781,8 @@ static void __init balloon_add_region(unsigned long start_pfn,
 
 static int __init balloon_init(void)
 {
+	struct task_struct *task;
+
 	if (!xen_domain())
 		return -ENODEV;
 
@@ -804,6 +826,12 @@ static int __init balloon_init(void)
 	}
 #endif
 
+	task = kthread_run(balloon_thread, NULL, "xen-balloon");
+	if (IS_ERR(task)) {
+		pr_err("xen-balloon thread could not be started, ballooning will not work!\n");
+		return PTR_ERR(task);
+	}
+
 	/* Init the xen-balloon driver. */
 	xen_balloon_init();
 
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 73be08ea135f..bc49cd04b725 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -3079,9 +3079,10 @@ cifs_match_super(struct super_block *sb, void *data)
 	spin_lock(&cifs_tcp_ses_lock);
 	cifs_sb = CIFS_SB(sb);
 	tlink = cifs_get_tlink(cifs_sb_master_tlink(cifs_sb));
-	if (IS_ERR(tlink)) {
+	if (tlink == NULL) {
+		/* can not match superblock if tlink were ever null */
 		spin_unlock(&cifs_tcp_ses_lock);
-		return rc;
+		return 0;
 	}
 	tcon = tlink_tcon(tlink);
 	ses = tcon->ses;
diff --git a/fs/ext4/dir.c b/fs/ext4/dir.c
index 90beca85c416..103bb9f1dc86 100644
--- a/fs/ext4/dir.c
+++ b/fs/ext4/dir.c
@@ -532,7 +532,7 @@ static int ext4_dx_readdir(struct file *file, struct dir_context *ctx)
 	struct dir_private_info *info = file->private_data;
 	struct inode *inode = file_inode(file);
 	struct fname *fname;
-	int	ret;
+	int ret = 0;
 
 	if (!info) {
 		info = ext4_htree_create_dir_info(file, ctx->pos);
@@ -580,7 +580,7 @@ static int ext4_dx_readdir(struct file *file, struct dir_context *ctx)
 						   info->curr_minor_hash,
 						   &info->next_hash);
 			if (ret < 0)
-				return ret;
+				goto finished;
 			if (ret == 0) {
 				ctx->pos = ext4_get_htree_eof(file);
 				break;
@@ -611,7 +611,7 @@ static int ext4_dx_readdir(struct file *file, struct dir_context *ctx)
 	}
 finished:
 	info->last_pos = ctx->pos;
-	return 0;
+	return ret < 0 ? ret : 0;
 }
 
 static int ext4_dir_open(struct inode * inode, struct file * filp)
diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index e961015fb484..3aff7dd3fd1a 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -3705,7 +3705,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
 		oi = OCFS2_I(inode);
 		oi->ip_dir_lock_gen++;
 		mlog(0, "generation: %u\n", oi->ip_dir_lock_gen);
-		goto out;
+		goto out_forget;
 	}
 
 	if (!S_ISREG(inode->i_mode))
@@ -3736,6 +3736,7 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
 		filemap_fdatawait(mapping);
 	}
 
+out_forget:
 	forget_all_cached_acls(inode);
 
 out:
diff --git a/fs/qnx4/dir.c b/fs/qnx4/dir.c
index a6ee23aadd28..66645a5a35f3 100644
--- a/fs/qnx4/dir.c
+++ b/fs/qnx4/dir.c
@@ -15,13 +15,48 @@
 #include <linux/buffer_head.h>
 #include "qnx4.h"
 
+/*
+ * A qnx4 directory entry is an inode entry or link info
+ * depending on the status field in the last byte. The
+ * first byte is where the name start either way, and a
+ * zero means it's empty.
+ *
+ * Also, due to a bug in gcc, we don't want to use the
+ * real (differently sized) name arrays in the inode and
+ * link entries, but always the 'de_name[]' one in the
+ * fake struct entry.
+ *
+ * See
+ *
+ *   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99578#c6
+ *
+ * for details, but basically gcc will take the size of the
+ * 'name' array from one of the used union entries randomly.
+ *
+ * This use of 'de_name[]' (48 bytes) avoids the false positive
+ * warnings that would happen if gcc decides to use 'inode.di_name'
+ * (16 bytes) even when the pointer and size were to come from
+ * 'link.dl_name' (48 bytes).
+ *
+ * In all cases the actual name pointer itself is the same, it's
+ * only the gcc internal 'what is the size of this field' logic
+ * that can get confused.
+ */
+union qnx4_directory_entry {
+	struct {
+		const char de_name[48];
+		u8 de_pad[15];
+		u8 de_status;
+	};
+	struct qnx4_inode_entry inode;
+	struct qnx4_link_info link;
+};
+
 static int qnx4_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
 	unsigned int offset;
 	struct buffer_head *bh;
-	struct qnx4_inode_entry *de;
-	struct qnx4_link_info *le;
 	unsigned long blknum;
 	int ix, ino;
 	int size;
@@ -38,27 +73,27 @@ static int qnx4_readdir(struct file *file, struct dir_context *ctx)
 		}
 		ix = (ctx->pos >> QNX4_DIR_ENTRY_SIZE_BITS) % QNX4_INODES_PER_BLOCK;
 		for (; ix < QNX4_INODES_PER_BLOCK; ix++, ctx->pos += QNX4_DIR_ENTRY_SIZE) {
+			union qnx4_directory_entry *de;
+
 			offset = ix * QNX4_DIR_ENTRY_SIZE;
-			de = (struct qnx4_inode_entry *) (bh->b_data + offset);
-			if (!de->di_fname[0])
+			de = (union qnx4_directory_entry *) (bh->b_data + offset);
+
+			if (!de->de_name[0])
 				continue;
-			if (!(de->di_status & (QNX4_FILE_USED|QNX4_FILE_LINK)))
+			if (!(de->de_status & (QNX4_FILE_USED|QNX4_FILE_LINK)))
 				continue;
-			if (!(de->di_status & QNX4_FILE_LINK))
-				size = QNX4_SHORT_NAME_MAX;
-			else
-				size = QNX4_NAME_MAX;
-			size = strnlen(de->di_fname, size);
-			QNX4DEBUG((KERN_INFO "qnx4_readdir:%.*s\n", size, de->di_fname));
-			if (!(de->di_status & QNX4_FILE_LINK))
+			if (!(de->de_status & QNX4_FILE_LINK)) {
+				size = sizeof(de->inode.di_fname);
 				ino = blknum * QNX4_INODES_PER_BLOCK + ix - 1;
-			else {
-				le  = (struct qnx4_link_info*)de;
-				ino = ( le32_to_cpu(le->dl_inode_blk) - 1 ) *
+			} else {
+				size = sizeof(de->link.dl_fname);
+				ino = ( le32_to_cpu(de->link.dl_inode_blk) - 1 ) *
 					QNX4_INODES_PER_BLOCK +
-					le->dl_inode_ndx;
+					de->link.dl_inode_ndx;
 			}
-			if (!dir_emit(ctx, de->di_fname, size, ino, DT_UNKNOWN)) {
+			size = strnlen(de->de_name, size);
+			QNX4DEBUG((KERN_INFO "qnx4_readdir:%.*s\n", size, name));
+			if (!dir_emit(ctx, de->de_name, size, ino, DT_UNKNOWN)) {
 				brelse(bh);
 				return 0;
 			}
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 3b6e6522e0ec..d29b68379223 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -152,6 +152,8 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
     (typeof(ptr)) (__ptr + (off)); })
 #endif
 
+#define absolute_pointer(val)	RELOC_HIDE((void *)(val), 0)
+
 #ifndef OPTIMIZER_HIDE_VAR
 #define OPTIMIZER_HIDE_VAR(var) barrier()
 #endif
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 2a0d4674294e..493516e97e45 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -235,7 +235,7 @@ static inline struct cred *get_new_cred(struct cred *cred)
  * @cred: The credentials to reference
  *
  * Get a reference on the specified set of credentials.  The caller must
- * release the reference.
+ * release the reference.  If %NULL is passed, it is returned with no action.
  *
  * This is used to deal with a committed set of credentials.  Although the
  * pointer is const, this will temporarily discard the const and increment the
@@ -246,6 +246,8 @@ static inline struct cred *get_new_cred(struct cred *cred)
 static inline const struct cred *get_cred(const struct cred *cred)
 {
 	struct cred *nonconst_cred = (struct cred *) cred;
+	if (!cred)
+		return cred;
 	validate_creds(cred);
 	nonconst_cred->non_rcu = 0;
 	return get_new_cred(nonconst_cred);
@@ -256,7 +258,7 @@ static inline const struct cred *get_cred(const struct cred *cred)
  * @cred: The credentials to release
  *
  * Release a reference to a set of credentials, deleting them when the last ref
- * is released.
+ * is released.  If %NULL is passed, nothing is done.
  *
  * This takes a const pointer to a set of credentials because the credentials
  * on task_struct are attached by const pointers to prevent accidental
@@ -266,9 +268,11 @@ static inline void put_cred(const struct cred *_cred)
 {
 	struct cred *cred = (struct cred *) _cred;
 
-	validate_creds(cred);
-	if (atomic_dec_and_test(&(cred)->usage))
-		__put_cred(cred);
+	if (cred) {
+		validate_creds(cred);
+		if (atomic_dec_and_test(&(cred)->usage))
+			__put_cred(cred);
+	}
 }
 
 /**
diff --git a/include/net/sock.h b/include/net/sock.h
index 70fe85bee4e5..029df5cdeaf1 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -454,8 +454,10 @@ struct sock {
 	u32			sk_ack_backlog;
 	u32			sk_max_ack_backlog;
 	kuid_t			sk_uid;
+	spinlock_t		sk_peer_lock;
 	struct pid		*sk_peer_pid;
 	const struct cred	*sk_peer_cred;
+
 	long			sk_rcvtimeo;
 	ktime_t			sk_stamp;
 #if BITS_PER_LONG==32
diff --git a/kernel/sched/cpufreq_schedutil.c b/kernel/sched/cpufreq_schedutil.c
index f8c45d30ec6d..90a998638bdd 100644
--- a/kernel/sched/cpufreq_schedutil.c
+++ b/kernel/sched/cpufreq_schedutil.c
@@ -441,9 +441,17 @@ static struct attribute *sugov_attributes[] = {
 	NULL
 };
 
+static void sugov_tunables_free(struct kobject *kobj)
+{
+	struct gov_attr_set *attr_set = container_of(kobj, struct gov_attr_set, kobj);
+
+	kfree(to_sugov_tunables(attr_set));
+}
+
 static struct kobj_type sugov_tunables_ktype = {
 	.default_attrs = sugov_attributes,
 	.sysfs_ops = &governor_sysfs_ops,
+	.release = &sugov_tunables_free,
 };
 
 /********************** cpufreq governor interface *********************/
@@ -534,12 +542,10 @@ static struct sugov_tunables *sugov_tunables_alloc(struct sugov_policy *sg_polic
 	return tunables;
 }
 
-static void sugov_tunables_free(struct sugov_tunables *tunables)
+static void sugov_clear_global_tunables(void)
 {
 	if (!have_governor_per_policy())
 		global_tunables = NULL;
-
-	kfree(tunables);
 }
 
 static int sugov_init(struct cpufreq_policy *policy)
@@ -602,7 +608,7 @@ static int sugov_init(struct cpufreq_policy *policy)
 fail:
 	kobject_put(&tunables->attr_set.kobj);
 	policy->governor_data = NULL;
-	sugov_tunables_free(tunables);
+	sugov_clear_global_tunables();
 
 stop_kthread:
 	sugov_kthread_stop(sg_policy);
@@ -629,7 +635,7 @@ static void sugov_exit(struct cpufreq_policy *policy)
 	count = gov_attr_set_put(&tunables->attr_set, &sg_policy->tunables_hook);
 	policy->governor_data = NULL;
 	if (!count)
-		sugov_tunables_free(tunables);
+		sugov_clear_global_tunables();
 
 	mutex_unlock(&global_tunables_lock);
 
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b06011b22185..0b22bf622397 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -1679,6 +1679,14 @@ static int blk_trace_remove_queue(struct request_queue *q)
 	if (bt == NULL)
 		return -EINVAL;
 
+	if (bt->trace_state == Blktrace_running) {
+		bt->trace_state = Blktrace_stopped;
+		spin_lock_irq(&running_trace_lock);
+		list_del_init(&bt->running_list);
+		spin_unlock_irq(&running_trace_lock);
+		relay_flush(bt->rchan);
+	}
+
 	put_probe_ref();
 	synchronize_rcu();
 	blk_trace_free(bt);
diff --git a/net/core/sock.c b/net/core/sock.c
index 699bd3052c61..427024597204 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1069,6 +1069,16 @@ int sock_setsockopt(struct socket *sock, int level, int optname,
 }
 EXPORT_SYMBOL(sock_setsockopt);
 
+static const struct cred *sk_get_peer_cred(struct sock *sk)
+{
+	const struct cred *cred;
+
+	spin_lock(&sk->sk_peer_lock);
+	cred = get_cred(sk->sk_peer_cred);
+	spin_unlock(&sk->sk_peer_lock);
+
+	return cred;
+}
 
 static void cred_to_ucred(struct pid *pid, const struct cred *cred,
 			  struct ucred *ucred)
@@ -1242,7 +1252,11 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 		struct ucred peercred;
 		if (len > sizeof(peercred))
 			len = sizeof(peercred);
+
+		spin_lock(&sk->sk_peer_lock);
 		cred_to_ucred(sk->sk_peer_pid, sk->sk_peer_cred, &peercred);
+		spin_unlock(&sk->sk_peer_lock);
+
 		if (copy_to_user(optval, &peercred, len))
 			return -EFAULT;
 		goto lenout;
@@ -1250,20 +1264,23 @@ int sock_getsockopt(struct socket *sock, int level, int optname,
 
 	case SO_PEERGROUPS:
 	{
+		const struct cred *cred;
 		int ret, n;
 
-		if (!sk->sk_peer_cred)
+		cred = sk_get_peer_cred(sk);
+		if (!cred)
 			return -ENODATA;
 
-		n = sk->sk_peer_cred->group_info->ngroups;
+		n = cred->group_info->ngroups;
 		if (len < n * sizeof(gid_t)) {
 			len = n * sizeof(gid_t);
+			put_cred(cred);
 			return put_user(len, optlen) ? -EFAULT : -ERANGE;
 		}
 		len = n * sizeof(gid_t);
 
-		ret = groups_to_user((gid_t __user *)optval,
-				     sk->sk_peer_cred->group_info);
+		ret = groups_to_user((gid_t __user *)optval, cred->group_info);
+		put_cred(cred);
 		if (ret)
 			return ret;
 		goto lenout;
@@ -1574,9 +1591,10 @@ static void __sk_destruct(struct rcu_head *head)
 		sk->sk_frag.page = NULL;
 	}
 
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	/* We do not need to acquire sk->sk_peer_lock, we are the last user. */
+	put_cred(sk->sk_peer_cred);
 	put_pid(sk->sk_peer_pid);
+
 	if (likely(sk->sk_net_refcnt))
 		put_net(sock_net(sk));
 	sk_prot_free(sk->sk_prot_creator, sk);
@@ -2753,6 +2771,8 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 
 	sk->sk_peer_pid 	=	NULL;
 	sk->sk_peer_cred	=	NULL;
+	spin_lock_init(&sk->sk_peer_lock);
+
 	sk->sk_write_pending	=	0;
 	sk->sk_rcvlowat		=	1;
 	sk->sk_rcvtimeo		=	MAX_SCHEDULE_TIMEOUT;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index cf5c4d2f68c1..4faeb698c33c 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -882,7 +882,7 @@ int udp_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	__be16 dport;
 	u8  tos;
 	int err, is_udplite = IS_UDPLITE(sk);
-	int corkreq = up->corkflag || msg->msg_flags&MSG_MORE;
+	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
 	int (*getfrag)(void *, char *, int, int, int, struct sk_buff *);
 	struct sk_buff *skb;
 	struct ip_options_data opt_copy;
@@ -1165,7 +1165,7 @@ int udp_sendpage(struct sock *sk, struct page *page, int offset,
 	}
 
 	up->len += size;
-	if (!(up->corkflag || (flags&MSG_MORE)))
+	if (!(READ_ONCE(up->corkflag) || (flags&MSG_MORE)))
 		ret = udp_push_pending_frames(sk);
 	if (!ret)
 		ret = size;
@@ -2373,9 +2373,9 @@ int udp_lib_setsockopt(struct sock *sk, int level, int optname,
 	switch (optname) {
 	case UDP_CORK:
 		if (val != 0) {
-			up->corkflag = 1;
+			WRITE_ONCE(up->corkflag, 1);
 		} else {
-			up->corkflag = 0;
+			WRITE_ONCE(up->corkflag, 0);
 			lock_sock(sk);
 			push_pending_frames(sk);
 			release_sock(sk);
@@ -2482,7 +2482,7 @@ int udp_lib_getsockopt(struct sock *sk, int level, int optname,
 
 	switch (optname) {
 	case UDP_CORK:
-		val = up->corkflag;
+		val = READ_ONCE(up->corkflag);
 		break;
 
 	case UDP_ENCAP:
diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index d9d25b9c07ae..3411b36b8a50 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -1135,7 +1135,7 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
 	struct ipcm6_cookie ipc6;
 	int addr_len = msg->msg_namelen;
 	int ulen = len;
-	int corkreq = up->corkflag || msg->msg_flags&MSG_MORE;
+	int corkreq = READ_ONCE(up->corkflag) || msg->msg_flags&MSG_MORE;
 	int err;
 	int connected = 0;
 	int is_udplite = IS_UDPLITE(sk);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e7b63ba8c184..7e62a55a03de 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -2068,7 +2068,11 @@ static bool ieee80211_parse_tx_radiotap(struct ieee80211_local *local,
 			}
 
 			vht_mcs = iterator.this_arg[4] >> 4;
+			if (vht_mcs > 11)
+				vht_mcs = 0;
 			vht_nss = iterator.this_arg[4] & 0xF;
+			if (!vht_nss || vht_nss > 8)
+				vht_nss = 1;
 			break;
 
 		/*
@@ -3202,6 +3206,14 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	if (!ieee80211_amsdu_prepare_head(sdata, fast_tx, head))
 		goto out;
 
+	/* If n == 2, the "while (*frag_tail)" loop above didn't execute
+	 * and  frag_tail should be &skb_shinfo(head)->frag_list.
+	 * However, ieee80211_amsdu_prepare_head() can reallocate it.
+	 * Reload frag_tail to have it pointing to the correct place.
+	 */
+	if (n == 2)
+		frag_tail = &skb_shinfo(head)->frag_list;
+
 	/*
 	 * Pad out the previous subframe to a multiple of 4 by adding the
 	 * padding to the next one, that's being added. Note that head->len
diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 09b4f913e20b..c90278e40656 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -514,6 +514,9 @@ ieee80211_crypto_ccmp_decrypt(struct ieee80211_rx_data *rx,
 			return RX_DROP_UNUSABLE;
 	}
 
+	/* reload hdr - skb might have been reallocated */
+	hdr = (void *)rx->skb->data;
+
 	data_len = skb->len - hdrlen - IEEE80211_CCMP_HDR_LEN - mic_len;
 	if (!rx->sta || data_len < 0)
 		return RX_DROP_UNUSABLE;
@@ -744,6 +747,9 @@ ieee80211_crypto_gcmp_decrypt(struct ieee80211_rx_data *rx)
 			return RX_DROP_UNUSABLE;
 	}
 
+	/* reload hdr - skb might have been reallocated */
+	hdr = (void *)rx->skb->data;
+
 	data_len = skb->len - hdrlen - IEEE80211_GCMP_HDR_LEN - mic_len;
 	if (!rx->sta || data_len < 0)
 		return RX_DROP_UNUSABLE;
diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index cd91c30f3e18..098764060a34 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -104,11 +104,11 @@ htable_size(u8 hbits)
 {
 	size_t hsize;
 
-	/* We must fit both into u32 in jhash and size_t */
+	/* We must fit both into u32 in jhash and INT_MAX in kvmalloc_node() */
 	if (hbits > 31)
 		return 0;
 	hsize = jhash_size(hbits);
-	if ((((size_t)-1) - sizeof(struct htable)) / sizeof(struct hbucket *)
+	if ((INT_MAX - sizeof(struct htable)) / sizeof(struct hbucket *)
 	    < hsize)
 		return 0;
 
diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs_conn.c
index 3d2ac71a83ec..620c865c230b 100644
--- a/net/netfilter/ipvs/ip_vs_conn.c
+++ b/net/netfilter/ipvs/ip_vs_conn.c
@@ -1406,6 +1406,10 @@ int __init ip_vs_conn_init(void)
 	int idx;
 
 	/* Compute size and mask */
+	if (ip_vs_conn_tab_bits < 8 || ip_vs_conn_tab_bits > 20) {
+		pr_info("conn_tab_bits not in [8, 20]. Using default value\n");
+		ip_vs_conn_tab_bits = CONFIG_IP_VS_TAB_BITS;
+	}
 	ip_vs_conn_tab_size = 1 << ip_vs_conn_tab_bits;
 	ip_vs_conn_tab_mask = ip_vs_conn_tab_size - 1;
 
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 89a24de23086..b20a1fbea8bf 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -679,7 +679,7 @@ static int sctp_rcv_ootb(struct sk_buff *skb)
 		ch = skb_header_pointer(skb, offset, sizeof(*ch), &_ch);
 
 		/* Break out if chunk length is less then minimal. */
-		if (ntohs(ch->length) < sizeof(_ch))
+		if (!ch || ntohs(ch->length) < sizeof(_ch))
 			break;
 
 		ch_end = offset + SCTP_PAD4(ntohs(ch->length));
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index f30509ff302e..0e494902fada 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -595,20 +595,42 @@ static void unix_release_sock(struct sock *sk, int embrion)
 
 static void init_peercred(struct sock *sk)
 {
-	put_pid(sk->sk_peer_pid);
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
+	spin_lock(&sk->sk_peer_lock);
+	old_pid = sk->sk_peer_pid;
+	old_cred = sk->sk_peer_cred;
 	sk->sk_peer_pid  = get_pid(task_tgid(current));
 	sk->sk_peer_cred = get_current_cred();
+	spin_unlock(&sk->sk_peer_lock);
+
+	put_pid(old_pid);
+	put_cred(old_cred);
 }
 
 static void copy_peercred(struct sock *sk, struct sock *peersk)
 {
-	put_pid(sk->sk_peer_pid);
-	if (sk->sk_peer_cred)
-		put_cred(sk->sk_peer_cred);
+	const struct cred *old_cred;
+	struct pid *old_pid;
+
+	if (sk < peersk) {
+		spin_lock(&sk->sk_peer_lock);
+		spin_lock_nested(&peersk->sk_peer_lock, SINGLE_DEPTH_NESTING);
+	} else {
+		spin_lock(&peersk->sk_peer_lock);
+		spin_lock_nested(&sk->sk_peer_lock, SINGLE_DEPTH_NESTING);
+	}
+	old_pid = sk->sk_peer_pid;
+	old_cred = sk->sk_peer_cred;
 	sk->sk_peer_pid  = get_pid(peersk->sk_peer_pid);
 	sk->sk_peer_cred = get_cred(peersk->sk_peer_cred);
+
+	spin_unlock(&sk->sk_peer_lock);
+	spin_unlock(&peersk->sk_peer_lock);
+
+	put_pid(old_pid);
+	put_cred(old_cred);
 }
 
 static int unix_listen(struct socket *sock, int backlog)
