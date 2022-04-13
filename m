Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D82924FFE5D
	for <lists+stable@lfdr.de>; Wed, 13 Apr 2022 21:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237892AbiDMTFH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 15:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236657AbiDMTFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 15:05:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 176316AA48;
        Wed, 13 Apr 2022 12:02:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 635B461B1C;
        Wed, 13 Apr 2022 19:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D31C385A4;
        Wed, 13 Apr 2022 19:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649876558;
        bh=1pjWQkLSQWa+Jx/GRcuUm8jLlns46X9AikWLNJYRhjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r0roRNu4hlU81BjqeGs019QfabnEQTMtN013iLzpbiZMOqnbwf0tkdx+zhWwqZ1zj
         5L49+X8yw3wIi0LpUNHZ/Nb4eQ0ieC1h35Hwz+DAbZQJBvdPtzSyI3wXkM+7N9QUYv
         p7Zv/A45Q8RsjKSiOvIMzPsm5C/y6C7v1knzz6SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.34
Date:   Wed, 13 Apr 2022 21:02:30 +0200
Message-Id: <164987654919138@kroah.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <1649876549123197@kroah.com>
References: <1649876549123197@kroah.com>
MIME-Version: 1.0
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

diff --git a/Makefile b/Makefile
index a3e7c7683bac..b6920025dfa3 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 33
+SUBLEVEL = 34
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/alpha/kernel/rtc.c b/arch/alpha/kernel/rtc.c
index ce3077946e1d..fb3025396ac9 100644
--- a/arch/alpha/kernel/rtc.c
+++ b/arch/alpha/kernel/rtc.c
@@ -80,7 +80,12 @@ init_rtc_epoch(void)
 static int
 alpha_rtc_read_time(struct device *dev, struct rtc_time *tm)
 {
-	mc146818_get_time(tm);
+	int ret = mc146818_get_time(tm);
+
+	if (ret < 0) {
+		dev_err_ratelimited(dev, "unable to read current time\n");
+		return ret;
+	}
 
 	/* Adjust for non-default epochs.  It's easier to depend on the
 	   generic __get_rtc_time and adjust the epoch here than create
diff --git a/arch/arm64/include/asm/cputype.h b/arch/arm64/include/asm/cputype.h
index bfbf0c4c7c5e..39f5c1672f48 100644
--- a/arch/arm64/include/asm/cputype.h
+++ b/arch/arm64/include/asm/cputype.h
@@ -75,6 +75,7 @@
 #define ARM_CPU_PART_CORTEX_A77		0xD0D
 #define ARM_CPU_PART_NEOVERSE_V1	0xD40
 #define ARM_CPU_PART_CORTEX_A78		0xD41
+#define ARM_CPU_PART_CORTEX_A78AE	0xD42
 #define ARM_CPU_PART_CORTEX_X1		0xD44
 #define ARM_CPU_PART_CORTEX_A510	0xD46
 #define ARM_CPU_PART_CORTEX_A710	0xD47
@@ -123,6 +124,7 @@
 #define MIDR_CORTEX_A77	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A77)
 #define MIDR_NEOVERSE_V1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_NEOVERSE_V1)
 #define MIDR_CORTEX_A78	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78)
+#define MIDR_CORTEX_A78AE	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A78AE)
 #define MIDR_CORTEX_X1	MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_X1)
 #define MIDR_CORTEX_A510 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A510)
 #define MIDR_CORTEX_A710 MIDR_CPU_MODEL(ARM_CPU_IMP_ARM, ARM_CPU_PART_CORTEX_A710)
diff --git a/arch/arm64/kernel/patching.c b/arch/arm64/kernel/patching.c
index 771f543464e0..33e0fabc0b79 100644
--- a/arch/arm64/kernel/patching.c
+++ b/arch/arm64/kernel/patching.c
@@ -117,8 +117,8 @@ static int __kprobes aarch64_insn_patch_text_cb(void *arg)
 	int i, ret = 0;
 	struct aarch64_insn_patch *pp = arg;
 
-	/* The first CPU becomes master */
-	if (atomic_inc_return(&pp->cpu_count) == 1) {
+	/* The last CPU becomes master */
+	if (atomic_inc_return(&pp->cpu_count) == num_online_cpus()) {
 		for (i = 0; ret == 0 && i < pp->insn_cnt; i++)
 			ret = aarch64_insn_patch_text_nosync(pp->text_addrs[i],
 							     pp->new_insns[i]);
diff --git a/arch/arm64/kernel/proton-pack.c b/arch/arm64/kernel/proton-pack.c
index 5777929d35bf..40be3a7c2c53 100644
--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -853,6 +853,7 @@ u8 spectre_bhb_loop_affected(int scope)
 	if (scope == SCOPE_LOCAL_CPU) {
 		static const struct midr_range spectre_bhb_k32_list[] = {
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A78),
+			MIDR_ALL_VERSIONS(MIDR_CORTEX_A78AE),
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A78C),
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_X1),
 			MIDR_ALL_VERSIONS(MIDR_CORTEX_A710),
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 6f6ff072acbd..3beaa6640ab3 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -234,6 +234,7 @@ asmlinkage notrace void secondary_start_kernel(void)
 	 * Log the CPU info before it is marked online and might get read.
 	 */
 	cpuinfo_store_cpu();
+	store_cpu_topology(cpu);
 
 	/*
 	 * Enable GIC and timers.
@@ -242,7 +243,6 @@ asmlinkage notrace void secondary_start_kernel(void)
 
 	ipi_setup(cpu);
 
-	store_cpu_topology(cpu);
 	numa_add_cpu(cpu);
 
 	/*
diff --git a/arch/mips/boot/dts/ingenic/jz4780.dtsi b/arch/mips/boot/dts/ingenic/jz4780.dtsi
index 9e34f433b9b5..efbbddaf0fde 100644
--- a/arch/mips/boot/dts/ingenic/jz4780.dtsi
+++ b/arch/mips/boot/dts/ingenic/jz4780.dtsi
@@ -450,7 +450,7 @@ efuse: efuse@d0 {
 			#address-cells = <1>;
 			#size-cells = <1>;
 
-			eth0_addr: eth-mac-addr@0x22 {
+			eth0_addr: eth-mac-addr@22 {
 				reg = <0x22 0x6>;
 			};
 		};
diff --git a/arch/mips/include/asm/setup.h b/arch/mips/include/asm/setup.h
index bb36a400203d..8c56b862fd9c 100644
--- a/arch/mips/include/asm/setup.h
+++ b/arch/mips/include/asm/setup.h
@@ -16,7 +16,7 @@ static inline void setup_8250_early_printk_port(unsigned long base,
 	unsigned int reg_shift, unsigned int timeout) {}
 #endif
 
-extern void set_handler(unsigned long offset, void *addr, unsigned long len);
+void set_handler(unsigned long offset, const void *addr, unsigned long len);
 extern void set_uncached_handler(unsigned long offset, void *addr, unsigned long len);
 
 typedef void (*vi_handler_t)(void);
diff --git a/arch/mips/kernel/traps.c b/arch/mips/kernel/traps.c
index 6f07362de5ce..edd93430b954 100644
--- a/arch/mips/kernel/traps.c
+++ b/arch/mips/kernel/traps.c
@@ -2085,19 +2085,19 @@ static void *set_vi_srs_handler(int n, vi_handler_t addr, int srs)
 		 * If no shadow set is selected then use the default handler
 		 * that does normal register saving and standard interrupt exit
 		 */
-		extern char except_vec_vi, except_vec_vi_lui;
-		extern char except_vec_vi_ori, except_vec_vi_end;
-		extern char rollback_except_vec_vi;
-		char *vec_start = using_rollback_handler() ?
-			&rollback_except_vec_vi : &except_vec_vi;
+		extern const u8 except_vec_vi[], except_vec_vi_lui[];
+		extern const u8 except_vec_vi_ori[], except_vec_vi_end[];
+		extern const u8 rollback_except_vec_vi[];
+		const u8 *vec_start = using_rollback_handler() ?
+				      rollback_except_vec_vi : except_vec_vi;
 #if defined(CONFIG_CPU_MICROMIPS) || defined(CONFIG_CPU_BIG_ENDIAN)
-		const int lui_offset = &except_vec_vi_lui - vec_start + 2;
-		const int ori_offset = &except_vec_vi_ori - vec_start + 2;
+		const int lui_offset = except_vec_vi_lui - vec_start + 2;
+		const int ori_offset = except_vec_vi_ori - vec_start + 2;
 #else
-		const int lui_offset = &except_vec_vi_lui - vec_start;
-		const int ori_offset = &except_vec_vi_ori - vec_start;
+		const int lui_offset = except_vec_vi_lui - vec_start;
+		const int ori_offset = except_vec_vi_ori - vec_start;
 #endif
-		const int handler_len = &except_vec_vi_end - vec_start;
+		const int handler_len = except_vec_vi_end - vec_start;
 
 		if (handler_len > VECTORSPACING) {
 			/*
@@ -2305,7 +2305,7 @@ void per_cpu_trap_init(bool is_boot_cpu)
 }
 
 /* Install CPU exception handler */
-void set_handler(unsigned long offset, void *addr, unsigned long size)
+void set_handler(unsigned long offset, const void *addr, unsigned long size)
 {
 #ifdef CONFIG_CPU_MICROMIPS
 	memcpy((void *)(ebase + offset), ((unsigned char *)addr - 1), size);
diff --git a/arch/mips/ralink/ill_acc.c b/arch/mips/ralink/ill_acc.c
index bdf53807d7c2..bea857c9da8b 100644
--- a/arch/mips/ralink/ill_acc.c
+++ b/arch/mips/ralink/ill_acc.c
@@ -61,6 +61,7 @@ static int __init ill_acc_of_setup(void)
 	pdev = of_find_device_by_node(np);
 	if (!pdev) {
 		pr_err("%pOFn: failed to lookup pdev\n", np);
+		of_node_put(np);
 		return -EINVAL;
 	}
 
diff --git a/arch/parisc/kernel/patch.c b/arch/parisc/kernel/patch.c
index 80a0ab372802..e59574f65e64 100644
--- a/arch/parisc/kernel/patch.c
+++ b/arch/parisc/kernel/patch.c
@@ -40,10 +40,7 @@ static void __kprobes *patch_map(void *addr, int fixmap, unsigned long *flags,
 
 	*need_unmap = 1;
 	set_fixmap(fixmap, page_to_phys(page));
-	if (flags)
-		raw_spin_lock_irqsave(&patch_lock, *flags);
-	else
-		__acquire(&patch_lock);
+	raw_spin_lock_irqsave(&patch_lock, *flags);
 
 	return (void *) (__fix_to_virt(fixmap) + (uintaddr & ~PAGE_MASK));
 }
@@ -52,10 +49,7 @@ static void __kprobes patch_unmap(int fixmap, unsigned long *flags)
 {
 	clear_fixmap(fixmap);
 
-	if (flags)
-		raw_spin_unlock_irqrestore(&patch_lock, *flags);
-	else
-		__release(&patch_lock);
+	raw_spin_unlock_irqrestore(&patch_lock, *flags);
 }
 
 void __kprobes __patch_text_multiple(void *addr, u32 *insn, unsigned int len)
@@ -67,8 +61,9 @@ void __kprobes __patch_text_multiple(void *addr, u32 *insn, unsigned int len)
 	int mapped;
 
 	/* Make sure we don't have any aliases in cache */
-	flush_kernel_vmap_range(addr, len);
-	flush_icache_range(start, end);
+	flush_kernel_dcache_range_asm(start, end);
+	flush_kernel_icache_range_asm(start, end);
+	flush_tlb_kernel_range(start, end);
 
 	p = fixmap = patch_map(addr, FIX_TEXT_POKE0, &flags, &mapped);
 
@@ -81,8 +76,10 @@ void __kprobes __patch_text_multiple(void *addr, u32 *insn, unsigned int len)
 			 * We're crossing a page boundary, so
 			 * need to remap
 			 */
-			flush_kernel_vmap_range((void *)fixmap,
-						(p-fixmap) * sizeof(*p));
+			flush_kernel_dcache_range_asm((unsigned long)fixmap,
+						      (unsigned long)p);
+			flush_tlb_kernel_range((unsigned long)fixmap,
+					       (unsigned long)p);
 			if (mapped)
 				patch_unmap(FIX_TEXT_POKE0, &flags);
 			p = fixmap = patch_map(addr, FIX_TEXT_POKE0, &flags,
@@ -90,10 +87,10 @@ void __kprobes __patch_text_multiple(void *addr, u32 *insn, unsigned int len)
 		}
 	}
 
-	flush_kernel_vmap_range((void *)fixmap, (p-fixmap) * sizeof(*p));
+	flush_kernel_dcache_range_asm((unsigned long)fixmap, (unsigned long)p);
+	flush_tlb_kernel_range((unsigned long)fixmap, (unsigned long)p);
 	if (mapped)
 		patch_unmap(FIX_TEXT_POKE0, &flags);
-	flush_icache_range(start, end);
 }
 
 void __kprobes __patch_text(void *addr, u32 insn)
diff --git a/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi b/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi
index 099a598c74c0..bfe1ed5be337 100644
--- a/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi
+++ b/arch/powerpc/boot/dts/fsl/t104xrdb.dtsi
@@ -139,12 +139,12 @@ pca9546@77 {
 		fman@400000 {
 			ethernet@e6000 {
 				phy-handle = <&phy_rgmii_0>;
-				phy-connection-type = "rgmii";
+				phy-connection-type = "rgmii-id";
 			};
 
 			ethernet@e8000 {
 				phy-handle = <&phy_rgmii_1>;
-				phy-connection-type = "rgmii";
+				phy-connection-type = "rgmii-id";
 			};
 
 			mdio0: mdio@fc000 {
diff --git a/arch/powerpc/include/asm/interrupt.h b/arch/powerpc/include/asm/interrupt.h
index a1d238255f07..a07960066b5f 100644
--- a/arch/powerpc/include/asm/interrupt.h
+++ b/arch/powerpc/include/asm/interrupt.h
@@ -567,7 +567,7 @@ DECLARE_INTERRUPT_HANDLER_RAW(do_slb_fault);
 DECLARE_INTERRUPT_HANDLER(do_bad_slb_fault);
 
 /* hash_utils.c */
-DECLARE_INTERRUPT_HANDLER_RAW(do_hash_fault);
+DECLARE_INTERRUPT_HANDLER(do_hash_fault);
 
 /* fault.c */
 DECLARE_INTERRUPT_HANDLER(do_page_fault);
diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
index 254687258f42..f2c5c26869f1 100644
--- a/arch/powerpc/include/asm/page.h
+++ b/arch/powerpc/include/asm/page.h
@@ -132,7 +132,11 @@ static inline bool pfn_valid(unsigned long pfn)
 #define virt_to_page(kaddr)	pfn_to_page(virt_to_pfn(kaddr))
 #define pfn_to_kaddr(pfn)	__va((pfn) << PAGE_SHIFT)
 
-#define virt_addr_valid(kaddr)	pfn_valid(virt_to_pfn(kaddr))
+#define virt_addr_valid(vaddr)	({					\
+	unsigned long _addr = (unsigned long)vaddr;			\
+	_addr >= PAGE_OFFSET && _addr < (unsigned long)high_memory &&	\
+	pfn_valid(virt_to_pfn(_addr));					\
+})
 
 /*
  * On Book-E parts we need __va to parse the device tree and we can't
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index ff80bbad22a5..e18a725a8e5d 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -1235,6 +1235,12 @@ int __init early_init_dt_scan_rtas(unsigned long node,
 	entryp = of_get_flat_dt_prop(node, "linux,rtas-entry", NULL);
 	sizep  = of_get_flat_dt_prop(node, "rtas-size", NULL);
 
+#ifdef CONFIG_PPC64
+	/* need this feature to decide the crashkernel offset */
+	if (of_get_flat_dt_prop(node, "ibm,hypertas-functions", NULL))
+		powerpc_firmware_features |= FW_FEATURE_LPAR;
+#endif
+
 	if (basep && entryp && sizep) {
 		rtas.base = *basep;
 		rtas.entry = *entryp;
diff --git a/arch/powerpc/kernel/secvar-sysfs.c b/arch/powerpc/kernel/secvar-sysfs.c
index a0a78aba2083..1ee4640a2641 100644
--- a/arch/powerpc/kernel/secvar-sysfs.c
+++ b/arch/powerpc/kernel/secvar-sysfs.c
@@ -26,15 +26,18 @@ static ssize_t format_show(struct kobject *kobj, struct kobj_attribute *attr,
 	const char *format;
 
 	node = of_find_compatible_node(NULL, NULL, "ibm,secvar-backend");
-	if (!of_device_is_available(node))
-		return -ENODEV;
+	if (!of_device_is_available(node)) {
+		rc = -ENODEV;
+		goto out;
+	}
 
 	rc = of_property_read_string(node, "format", &format);
 	if (rc)
-		return rc;
+		goto out;
 
 	rc = sprintf(buf, "%s\n", format);
 
+out:
 	of_node_put(node);
 
 	return rc;
diff --git a/arch/powerpc/kexec/core.c b/arch/powerpc/kexec/core.c
index 48525e8b5730..71b1bfdadd76 100644
--- a/arch/powerpc/kexec/core.c
+++ b/arch/powerpc/kexec/core.c
@@ -147,11 +147,18 @@ void __init reserve_crashkernel(void)
 	if (!crashk_res.start) {
 #ifdef CONFIG_PPC64
 		/*
-		 * On 64bit we split the RMO in half but cap it at half of
-		 * a small SLB (128MB) since the crash kernel needs to place
-		 * itself and some stacks to be in the first segment.
+		 * On the LPAR platform place the crash kernel to mid of
+		 * RMA size (512MB or more) to ensure the crash kernel
+		 * gets enough space to place itself and some stack to be
+		 * in the first segment. At the same time normal kernel
+		 * also get enough space to allocate memory for essential
+		 * system resource in the first segment. Keep the crash
+		 * kernel starts at 128MB offset on other platforms.
 		 */
-		crashk_res.start = min(0x8000000ULL, (ppc64_rma_size / 2));
+		if (firmware_has_feature(FW_FEATURE_LPAR))
+			crashk_res.start = ppc64_rma_size / 2;
+		else
+			crashk_res.start = min(0x8000000ULL, (ppc64_rma_size / 2));
 #else
 		crashk_res.start = KDUMP_KERNELBASE;
 #endif
diff --git a/arch/powerpc/kvm/book3s_64_entry.S b/arch/powerpc/kvm/book3s_64_entry.S
index 983b8c18bc31..a644003603da 100644
--- a/arch/powerpc/kvm/book3s_64_entry.S
+++ b/arch/powerpc/kvm/book3s_64_entry.S
@@ -407,10 +407,16 @@ END_FTR_SECTION_IFSET(CPU_FTR_DAWR1)
 	 */
 	ld	r10,HSTATE_SCRATCH0(r13)
 	cmpwi	r10,BOOK3S_INTERRUPT_MACHINE_CHECK
-	beq	machine_check_common
+	beq	.Lcall_machine_check_common
 
 	cmpwi	r10,BOOK3S_INTERRUPT_SYSTEM_RESET
-	beq	system_reset_common
+	beq	.Lcall_system_reset_common
 
 	b	.
+
+.Lcall_machine_check_common:
+	b	machine_check_common
+
+.Lcall_system_reset_common:
+	b	system_reset_common
 #endif
diff --git a/arch/powerpc/mm/book3s64/hash_utils.c b/arch/powerpc/mm/book3s64/hash_utils.c
index c145776d3ae5..7bfd88c4b547 100644
--- a/arch/powerpc/mm/book3s64/hash_utils.c
+++ b/arch/powerpc/mm/book3s64/hash_utils.c
@@ -1522,8 +1522,7 @@ int hash_page(unsigned long ea, unsigned long access, unsigned long trap,
 }
 EXPORT_SYMBOL_GPL(hash_page);
 
-DECLARE_INTERRUPT_HANDLER(__do_hash_fault);
-DEFINE_INTERRUPT_HANDLER(__do_hash_fault)
+DEFINE_INTERRUPT_HANDLER(do_hash_fault)
 {
 	unsigned long ea = regs->dar;
 	unsigned long dsisr = regs->dsisr;
@@ -1582,35 +1581,6 @@ DEFINE_INTERRUPT_HANDLER(__do_hash_fault)
 	}
 }
 
-/*
- * The _RAW interrupt entry checks for the in_nmi() case before
- * running the full handler.
- */
-DEFINE_INTERRUPT_HANDLER_RAW(do_hash_fault)
-{
-	/*
-	 * If we are in an "NMI" (e.g., an interrupt when soft-disabled), then
-	 * don't call hash_page, just fail the fault. This is required to
-	 * prevent re-entrancy problems in the hash code, namely perf
-	 * interrupts hitting while something holds H_PAGE_BUSY, and taking a
-	 * hash fault. See the comment in hash_preload().
-	 *
-	 * We come here as a result of a DSI at a point where we don't want
-	 * to call hash_page, such as when we are accessing memory (possibly
-	 * user memory) inside a PMU interrupt that occurred while interrupts
-	 * were soft-disabled.  We want to invoke the exception handler for
-	 * the access, or panic if there isn't a handler.
-	 */
-	if (unlikely(in_nmi())) {
-		do_bad_page_fault_segv(regs);
-		return 0;
-	}
-
-	__do_hash_fault(regs);
-
-	return 0;
-}
-
 #ifdef CONFIG_PPC_MM_SLICES
 static bool should_hash_preload(struct mm_struct *mm, unsigned long ea)
 {
@@ -1677,26 +1647,18 @@ static void hash_preload(struct mm_struct *mm, pte_t *ptep, unsigned long ea,
 #endif /* CONFIG_PPC_64K_PAGES */
 
 	/*
-	 * __hash_page_* must run with interrupts off, as it sets the
-	 * H_PAGE_BUSY bit. It's possible for perf interrupts to hit at any
-	 * time and may take a hash fault reading the user stack, see
-	 * read_user_stack_slow() in the powerpc/perf code.
-	 *
-	 * If that takes a hash fault on the same page as we lock here, it
-	 * will bail out when seeing H_PAGE_BUSY set, and retry the access
-	 * leading to an infinite loop.
+	 * __hash_page_* must run with interrupts off, including PMI interrupts
+	 * off, as it sets the H_PAGE_BUSY bit.
 	 *
-	 * Disabling interrupts here does not prevent perf interrupts, but it
-	 * will prevent them taking hash faults (see the NMI test in
-	 * do_hash_page), then read_user_stack's copy_from_user_nofault will
-	 * fail and perf will fall back to read_user_stack_slow(), which
-	 * walks the Linux page tables.
+	 * It's otherwise possible for perf interrupts to hit at any time and
+	 * may take a hash fault reading the user stack, which could take a
+	 * hash miss and deadlock on the same H_PAGE_BUSY bit.
 	 *
 	 * Interrupts must also be off for the duration of the
 	 * mm_is_thread_local test and update, to prevent preempt running the
 	 * mm on another CPU (XXX: this may be racy vs kthread_use_mm).
 	 */
-	local_irq_save(flags);
+	powerpc_local_irq_pmu_save(flags);
 
 	/* Is that local to this CPU ? */
 	if (mm_is_thread_local(mm))
@@ -1721,7 +1683,7 @@ static void hash_preload(struct mm_struct *mm, pte_t *ptep, unsigned long ea,
 				   mm_ctx_user_psize(&mm->context),
 				   pte_val(*ptep));
 
-	local_irq_restore(flags);
+	powerpc_local_irq_pmu_restore(flags);
 }
 
 /*
diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
index 3bb9d168e3b3..85753e32a4de 100644
--- a/arch/powerpc/mm/pageattr.c
+++ b/arch/powerpc/mm/pageattr.c
@@ -15,12 +15,14 @@
 #include <asm/pgtable.h>
 
 
+static pte_basic_t pte_update_delta(pte_t *ptep, unsigned long addr,
+				    unsigned long old, unsigned long new)
+{
+	return pte_update(&init_mm, addr, ptep, old & ~new, new & ~old, 0);
+}
+
 /*
- * Updates the attributes of a page in three steps:
- *
- * 1. take the page_table_lock
- * 2. install the new entry with the updated attributes
- * 3. flush the TLB
+ * Updates the attributes of a page atomically.
  *
  * This sequence is safe against concurrent updates, and also allows updating the
  * attributes of a page currently being executed or accessed.
@@ -28,25 +30,21 @@
 static int change_page_attr(pte_t *ptep, unsigned long addr, void *data)
 {
 	long action = (long)data;
-	pte_t pte;
 
-	spin_lock(&init_mm.page_table_lock);
-
-	pte = ptep_get(ptep);
-
-	/* modify the PTE bits as desired, then apply */
+	/* modify the PTE bits as desired */
 	switch (action) {
 	case SET_MEMORY_RO:
-		pte = pte_wrprotect(pte);
+		/* Don't clear DIRTY bit */
+		pte_update_delta(ptep, addr, _PAGE_KERNEL_RW & ~_PAGE_DIRTY, _PAGE_KERNEL_RO);
 		break;
 	case SET_MEMORY_RW:
-		pte = pte_mkwrite(pte_mkdirty(pte));
+		pte_update_delta(ptep, addr, _PAGE_KERNEL_RO, _PAGE_KERNEL_RW);
 		break;
 	case SET_MEMORY_NX:
-		pte = pte_exprotect(pte);
+		pte_update_delta(ptep, addr, _PAGE_KERNEL_ROX, _PAGE_KERNEL_RO);
 		break;
 	case SET_MEMORY_X:
-		pte = pte_mkexec(pte);
+		pte_update_delta(ptep, addr, _PAGE_KERNEL_RO, _PAGE_KERNEL_ROX);
 		break;
 	case SET_MEMORY_NP:
 		pte_update(&init_mm, addr, ptep, _PAGE_PRESENT, 0, 0);
@@ -59,16 +57,12 @@ static int change_page_attr(pte_t *ptep, unsigned long addr, void *data)
 		break;
 	}
 
-	pte_update(&init_mm, addr, ptep, ~0UL, pte_val(pte), 0);
-
 	/* See ptesync comment in radix__set_pte_at() */
 	if (radix_enabled())
 		asm volatile("ptesync": : :"memory");
 
 	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
 
-	spin_unlock(&init_mm.page_table_lock);
-
 	return 0;
 }
 
diff --git a/arch/powerpc/perf/callchain.h b/arch/powerpc/perf/callchain.h
index d6fa6e25234f..19a8d051ddf1 100644
--- a/arch/powerpc/perf/callchain.h
+++ b/arch/powerpc/perf/callchain.h
@@ -2,7 +2,6 @@
 #ifndef _POWERPC_PERF_CALLCHAIN_H
 #define _POWERPC_PERF_CALLCHAIN_H
 
-int read_user_stack_slow(const void __user *ptr, void *buf, int nb);
 void perf_callchain_user_64(struct perf_callchain_entry_ctx *entry,
 			    struct pt_regs *regs);
 void perf_callchain_user_32(struct perf_callchain_entry_ctx *entry,
@@ -26,17 +25,11 @@ static inline int __read_user_stack(const void __user *ptr, void *ret,
 				    size_t size)
 {
 	unsigned long addr = (unsigned long)ptr;
-	int rc;
 
 	if (addr > TASK_SIZE - size || (addr & (size - 1)))
 		return -EFAULT;
 
-	rc = copy_from_user_nofault(ret, ptr, size);
-
-	if (IS_ENABLED(CONFIG_PPC64) && !radix_enabled() && rc)
-		return read_user_stack_slow(ptr, ret, size);
-
-	return rc;
+	return copy_from_user_nofault(ret, ptr, size);
 }
 
 #endif /* _POWERPC_PERF_CALLCHAIN_H */
diff --git a/arch/powerpc/perf/callchain_64.c b/arch/powerpc/perf/callchain_64.c
index 8d0df4226328..488e8a21a11e 100644
--- a/arch/powerpc/perf/callchain_64.c
+++ b/arch/powerpc/perf/callchain_64.c
@@ -18,33 +18,6 @@
 
 #include "callchain.h"
 
-/*
- * On 64-bit we don't want to invoke hash_page on user addresses from
- * interrupt context, so if the access faults, we read the page tables
- * to find which page (if any) is mapped and access it directly. Radix
- * has no need for this so it doesn't use read_user_stack_slow.
- */
-int read_user_stack_slow(const void __user *ptr, void *buf, int nb)
-{
-
-	unsigned long addr = (unsigned long) ptr;
-	unsigned long offset;
-	struct page *page;
-	void *kaddr;
-
-	if (get_user_page_fast_only(addr, FOLL_WRITE, &page)) {
-		kaddr = page_address(page);
-
-		/* align address to page boundary */
-		offset = addr & ~PAGE_MASK;
-
-		memcpy(buf, kaddr + offset, nb);
-		put_page(page);
-		return 0;
-	}
-	return -EFAULT;
-}
-
 static int read_user_stack_64(const unsigned long __user *ptr, unsigned long *ret)
 {
 	return __read_user_stack(ptr, ret, sizeof(*ret));
diff --git a/arch/powerpc/platforms/Kconfig.cputype b/arch/powerpc/platforms/Kconfig.cputype
index a208997ade88..87a95cbff2f3 100644
--- a/arch/powerpc/platforms/Kconfig.cputype
+++ b/arch/powerpc/platforms/Kconfig.cputype
@@ -111,6 +111,7 @@ config PPC_BOOK3S_64
 
 config PPC_BOOK3E_64
 	bool "Embedded processors"
+	select PPC_FSL_BOOK3E
 	select PPC_FPU # Make it a choice ?
 	select PPC_SMP_MUXED_IPI
 	select PPC_DOORBELL
@@ -287,7 +288,7 @@ config FSL_BOOKE
 config PPC_FSL_BOOK3E
 	bool
 	select ARCH_SUPPORTS_HUGETLBFS if PHYS_64BIT || PPC64
-	select FSL_EMB_PERFMON
+	imply FSL_EMB_PERFMON
 	select PPC_SMP_MUXED_IPI
 	select PPC_DOORBELL
 	default y if FSL_BOOKE
diff --git a/arch/riscv/lib/memmove.S b/arch/riscv/lib/memmove.S
index 07d1d2152ba5..e0609e1f0864 100644
--- a/arch/riscv/lib/memmove.S
+++ b/arch/riscv/lib/memmove.S
@@ -1,64 +1,316 @@
-/* SPDX-License-Identifier: GPL-2.0 */
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2022 Michael T. Kloos <michael@michaelkloos.com>
+ */
 
 #include <linux/linkage.h>
 #include <asm/asm.h>
 
-ENTRY(__memmove)
-WEAK(memmove)
-        move    t0, a0
-        move    t1, a1
-
-        beq     a0, a1, exit_memcpy
-        beqz    a2, exit_memcpy
-        srli    t2, a2, 0x2
-
-        slt     t3, a0, a1
-        beqz    t3, do_reverse
-
-        andi    a2, a2, 0x3
-        li      t4, 1
-        beqz    t2, byte_copy
-
-word_copy:
-        lw      t3, 0(a1)
-        addi    t2, t2, -1
-        addi    a1, a1, 4
-        sw      t3, 0(a0)
-        addi    a0, a0, 4
-        bnez    t2, word_copy
-        beqz    a2, exit_memcpy
-        j       byte_copy
-
-do_reverse:
-        add     a0, a0, a2
-        add     a1, a1, a2
-        andi    a2, a2, 0x3
-        li      t4, -1
-        beqz    t2, reverse_byte_copy
-
-reverse_word_copy:
-        addi    a1, a1, -4
-        addi    t2, t2, -1
-        lw      t3, 0(a1)
-        addi    a0, a0, -4
-        sw      t3, 0(a0)
-        bnez    t2, reverse_word_copy
-        beqz    a2, exit_memcpy
-
-reverse_byte_copy:
-        addi    a0, a0, -1
-        addi    a1, a1, -1
+SYM_FUNC_START(__memmove)
+SYM_FUNC_START_WEAK(memmove)
+	/*
+	 * Returns
+	 *   a0 - dest
+	 *
+	 * Parameters
+	 *   a0 - Inclusive first byte of dest
+	 *   a1 - Inclusive first byte of src
+	 *   a2 - Length of copy n
+	 *
+	 * Because the return matches the parameter register a0,
+	 * we will not clobber or modify that register.
+	 *
+	 * Note: This currently only works on little-endian.
+	 * To port to big-endian, reverse the direction of shifts
+	 * in the 2 misaligned fixup copy loops.
+	 */
 
+	/* Return if nothing to do */
+	beq a0, a1, return_from_memmove
+	beqz a2, return_from_memmove
+
+	/*
+	 * Register Uses
+	 *      Forward Copy: a1 - Index counter of src
+	 *      Reverse Copy: a4 - Index counter of src
+	 *      Forward Copy: t3 - Index counter of dest
+	 *      Reverse Copy: t4 - Index counter of dest
+	 *   Both Copy Modes: t5 - Inclusive first multibyte/aligned of dest
+	 *   Both Copy Modes: t6 - Non-Inclusive last multibyte/aligned of dest
+	 *   Both Copy Modes: t0 - Link / Temporary for load-store
+	 *   Both Copy Modes: t1 - Temporary for load-store
+	 *   Both Copy Modes: t2 - Temporary for load-store
+	 *   Both Copy Modes: a5 - dest to src alignment offset
+	 *   Both Copy Modes: a6 - Shift ammount
+	 *   Both Copy Modes: a7 - Inverse Shift ammount
+	 *   Both Copy Modes: a2 - Alternate breakpoint for unrolled loops
+	 */
+
+	/*
+	 * Solve for some register values now.
+	 * Byte copy does not need t5 or t6.
+	 */
+	mv   t3, a0
+	add  t4, a0, a2
+	add  a4, a1, a2
+
+	/*
+	 * Byte copy if copying less than (2 * SZREG) bytes. This can
+	 * cause problems with the bulk copy implementation and is
+	 * small enough not to bother.
+	 */
+	andi t0, a2, -(2 * SZREG)
+	beqz t0, byte_copy
+
+	/*
+	 * Now solve for t5 and t6.
+	 */
+	andi t5, t3, -SZREG
+	andi t6, t4, -SZREG
+	/*
+	 * If dest(Register t3) rounded down to the nearest naturally
+	 * aligned SZREG address, does not equal dest, then add SZREG
+	 * to find the low-bound of SZREG alignment in the dest memory
+	 * region.  Note that this could overshoot the dest memory
+	 * region if n is less than SZREG.  This is one reason why
+	 * we always byte copy if n is less than SZREG.
+	 * Otherwise, dest is already naturally aligned to SZREG.
+	 */
+	beq  t5, t3, 1f
+		addi t5, t5, SZREG
+	1:
+
+	/*
+	 * If the dest and src are co-aligned to SZREG, then there is
+	 * no need for the full rigmarole of a full misaligned fixup copy.
+	 * Instead, do a simpler co-aligned copy.
+	 */
+	xor  t0, a0, a1
+	andi t1, t0, (SZREG - 1)
+	beqz t1, coaligned_copy
+	/* Fall through to misaligned fixup copy */
+
+misaligned_fixup_copy:
+	bltu a1, a0, misaligned_fixup_copy_reverse
+
+misaligned_fixup_copy_forward:
+	jal  t0, byte_copy_until_aligned_forward
+
+	andi a5, a1, (SZREG - 1) /* Find the alignment offset of src (a1) */
+	slli a6, a5, 3 /* Multiply by 8 to convert that to bits to shift */
+	sub  a5, a1, t3 /* Find the difference between src and dest */
+	andi a1, a1, -SZREG /* Align the src pointer */
+	addi a2, t6, SZREG /* The other breakpoint for the unrolled loop*/
+
+	/*
+	 * Compute The Inverse Shift
+	 * a7 = XLEN - a6 = XLEN + -a6
+	 * 2s complement negation to find the negative: -a6 = ~a6 + 1
+	 * Add that to XLEN.  XLEN = SZREG * 8.
+	 */
+	not  a7, a6
+	addi a7, a7, (SZREG * 8 + 1)
+
+	/*
+	 * Fix Misalignment Copy Loop - Forward
+	 * load_val0 = load_ptr[0];
+	 * do {
+	 * 	load_val1 = load_ptr[1];
+	 * 	store_ptr += 2;
+	 * 	store_ptr[0 - 2] = (load_val0 >> {a6}) | (load_val1 << {a7});
+	 *
+	 * 	if (store_ptr == {a2})
+	 * 		break;
+	 *
+	 * 	load_val0 = load_ptr[2];
+	 * 	load_ptr += 2;
+	 * 	store_ptr[1 - 2] = (load_val1 >> {a6}) | (load_val0 << {a7});
+	 *
+	 * } while (store_ptr != store_ptr_end);
+	 * store_ptr = store_ptr_end;
+	 */
+
+	REG_L t0, (0 * SZREG)(a1)
+	1:
+	REG_L t1, (1 * SZREG)(a1)
+	addi  t3, t3, (2 * SZREG)
+	srl   t0, t0, a6
+	sll   t2, t1, a7
+	or    t2, t0, t2
+	REG_S t2, ((0 * SZREG) - (2 * SZREG))(t3)
+
+	beq   t3, a2, 2f
+
+	REG_L t0, (2 * SZREG)(a1)
+	addi  a1, a1, (2 * SZREG)
+	srl   t1, t1, a6
+	sll   t2, t0, a7
+	or    t2, t1, t2
+	REG_S t2, ((1 * SZREG) - (2 * SZREG))(t3)
+
+	bne   t3, t6, 1b
+	2:
+	mv    t3, t6 /* Fix the dest pointer in case the loop was broken */
+
+	add  a1, t3, a5 /* Restore the src pointer */
+	j byte_copy_forward /* Copy any remaining bytes */
+
+misaligned_fixup_copy_reverse:
+	jal  t0, byte_copy_until_aligned_reverse
+
+	andi a5, a4, (SZREG - 1) /* Find the alignment offset of src (a4) */
+	slli a6, a5, 3 /* Multiply by 8 to convert that to bits to shift */
+	sub  a5, a4, t4 /* Find the difference between src and dest */
+	andi a4, a4, -SZREG /* Align the src pointer */
+	addi a2, t5, -SZREG /* The other breakpoint for the unrolled loop*/
+
+	/*
+	 * Compute The Inverse Shift
+	 * a7 = XLEN - a6 = XLEN + -a6
+	 * 2s complement negation to find the negative: -a6 = ~a6 + 1
+	 * Add that to XLEN.  XLEN = SZREG * 8.
+	 */
+	not  a7, a6
+	addi a7, a7, (SZREG * 8 + 1)
+
+	/*
+	 * Fix Misalignment Copy Loop - Reverse
+	 * load_val1 = load_ptr[0];
+	 * do {
+	 * 	load_val0 = load_ptr[-1];
+	 * 	store_ptr -= 2;
+	 * 	store_ptr[1] = (load_val0 >> {a6}) | (load_val1 << {a7});
+	 *
+	 * 	if (store_ptr == {a2})
+	 * 		break;
+	 *
+	 * 	load_val1 = load_ptr[-2];
+	 * 	load_ptr -= 2;
+	 * 	store_ptr[0] = (load_val1 >> {a6}) | (load_val0 << {a7});
+	 *
+	 * } while (store_ptr != store_ptr_end);
+	 * store_ptr = store_ptr_end;
+	 */
+
+	REG_L t1, ( 0 * SZREG)(a4)
+	1:
+	REG_L t0, (-1 * SZREG)(a4)
+	addi  t4, t4, (-2 * SZREG)
+	sll   t1, t1, a7
+	srl   t2, t0, a6
+	or    t2, t1, t2
+	REG_S t2, ( 1 * SZREG)(t4)
+
+	beq   t4, a2, 2f
+
+	REG_L t1, (-2 * SZREG)(a4)
+	addi  a4, a4, (-2 * SZREG)
+	sll   t0, t0, a7
+	srl   t2, t1, a6
+	or    t2, t0, t2
+	REG_S t2, ( 0 * SZREG)(t4)
+
+	bne   t4, t5, 1b
+	2:
+	mv    t4, t5 /* Fix the dest pointer in case the loop was broken */
+
+	add  a4, t4, a5 /* Restore the src pointer */
+	j byte_copy_reverse /* Copy any remaining bytes */
+
+/*
+ * Simple copy loops for SZREG co-aligned memory locations.
+ * These also make calls to do byte copies for any unaligned
+ * data at their terminations.
+ */
+coaligned_copy:
+	bltu a1, a0, coaligned_copy_reverse
+
+coaligned_copy_forward:
+	jal t0, byte_copy_until_aligned_forward
+
+	1:
+	REG_L t1, ( 0 * SZREG)(a1)
+	addi  a1, a1, SZREG
+	addi  t3, t3, SZREG
+	REG_S t1, (-1 * SZREG)(t3)
+	bne   t3, t6, 1b
+
+	j byte_copy_forward /* Copy any remaining bytes */
+
+coaligned_copy_reverse:
+	jal t0, byte_copy_until_aligned_reverse
+
+	1:
+	REG_L t1, (-1 * SZREG)(a4)
+	addi  a4, a4, -SZREG
+	addi  t4, t4, -SZREG
+	REG_S t1, ( 0 * SZREG)(t4)
+	bne   t4, t5, 1b
+
+	j byte_copy_reverse /* Copy any remaining bytes */
+
+/*
+ * These are basically sub-functions within the function.  They
+ * are used to byte copy until the dest pointer is in alignment.
+ * At which point, a bulk copy method can be used by the
+ * calling code.  These work on the same registers as the bulk
+ * copy loops.  Therefore, the register values can be picked
+ * up from where they were left and we avoid code duplication
+ * without any overhead except the call in and return jumps.
+ */
+byte_copy_until_aligned_forward:
+	beq  t3, t5, 2f
+	1:
+	lb   t1,  0(a1)
+	addi a1, a1, 1
+	addi t3, t3, 1
+	sb   t1, -1(t3)
+	bne  t3, t5, 1b
+	2:
+	jalr zero, 0x0(t0) /* Return to multibyte copy loop */
+
+byte_copy_until_aligned_reverse:
+	beq  t4, t6, 2f
+	1:
+	lb   t1, -1(a4)
+	addi a4, a4, -1
+	addi t4, t4, -1
+	sb   t1,  0(t4)
+	bne  t4, t6, 1b
+	2:
+	jalr zero, 0x0(t0) /* Return to multibyte copy loop */
+
+/*
+ * Simple byte copy loops.
+ * These will byte copy until they reach the end of data to copy.
+ * At that point, they will call to return from memmove.
+ */
 byte_copy:
-        lb      t3, 0(a1)
-        addi    a2, a2, -1
-        sb      t3, 0(a0)
-        add     a1, a1, t4
-        add     a0, a0, t4
-        bnez    a2, byte_copy
-
-exit_memcpy:
-        move a0, t0
-        move a1, t1
-        ret
-END(__memmove)
+	bltu a1, a0, byte_copy_reverse
+
+byte_copy_forward:
+	beq  t3, t4, 2f
+	1:
+	lb   t1,  0(a1)
+	addi a1, a1, 1
+	addi t3, t3, 1
+	sb   t1, -1(t3)
+	bne  t3, t4, 1b
+	2:
+	ret
+
+byte_copy_reverse:
+	beq  t4, t3, 2f
+	1:
+	lb   t1, -1(a4)
+	addi a4, a4, -1
+	addi t4, t4, -1
+	sb   t1,  0(t4)
+	bne  t4, t3, 1b
+	2:
+
+return_from_memmove:
+	ret
+
+SYM_FUNC_END(memmove)
+SYM_FUNC_END(__memmove)
diff --git a/arch/um/include/asm/xor.h b/arch/um/include/asm/xor.h
index f512704a9ec7..22b39de73c24 100644
--- a/arch/um/include/asm/xor.h
+++ b/arch/um/include/asm/xor.h
@@ -4,8 +4,10 @@
 
 #ifdef CONFIG_64BIT
 #undef CONFIG_X86_32
+#define TT_CPU_INF_XOR_DEFAULT (AVX_SELECT(&xor_block_sse_pf64))
 #else
 #define CONFIG_X86_32 1
+#define TT_CPU_INF_XOR_DEFAULT (AVX_SELECT(&xor_block_8regs))
 #endif
 
 #include <asm/cpufeature.h>
@@ -16,7 +18,7 @@
 #undef XOR_SELECT_TEMPLATE
 /* pick an arbitrary one - measuring isn't possible with inf-cpu */
 #define XOR_SELECT_TEMPLATE(x)	\
-	(time_travel_mode == TT_MODE_INFCPU ? &xor_block_8regs : NULL)
+	(time_travel_mode == TT_MODE_INFCPU ? TT_CPU_INF_XOR_DEFAULT : x))
 #endif
 
 #endif
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1f96809606ac..819f8c2e2c67 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2798,6 +2798,11 @@ config IA32_AOUT
 config X86_X32
 	bool "x32 ABI for 64-bit mode"
 	depends on X86_64
+	# llvm-objcopy does not convert x86_64 .note.gnu.property or
+	# compressed debug sections to x86_x32 properly:
+	# https://github.com/ClangBuiltLinux/linux/issues/514
+	# https://github.com/ClangBuiltLinux/linux/issues/1141
+	depends on $(success,$(OBJCOPY) --version | head -n1 | grep -qv llvm)
 	help
 	  Include code to run binaries for the x32 native 32-bit ABI
 	  for 64-bit processors.  An x32 process gets access to the
diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index 97ede6fb15f2..265cb203d9d5 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -281,7 +281,7 @@ static struct extra_reg intel_spr_extra_regs[] __read_mostly = {
 	INTEL_UEVENT_EXTRA_REG(0x012a, MSR_OFFCORE_RSP_0, 0x3fffffffffull, RSP_0),
 	INTEL_UEVENT_EXTRA_REG(0x012b, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
 	INTEL_UEVENT_PEBS_LDLAT_EXTRA_REG(0x01cd),
-	INTEL_UEVENT_EXTRA_REG(0x01c6, MSR_PEBS_FRONTEND, 0x7fff17, FE),
+	INTEL_UEVENT_EXTRA_REG(0x01c6, MSR_PEBS_FRONTEND, 0x7fff1f, FE),
 	INTEL_UEVENT_EXTRA_REG(0x40ad, MSR_PEBS_FRONTEND, 0x7, FE),
 	INTEL_UEVENT_EXTRA_REG(0x04c2, MSR_PEBS_FRONTEND, 0x8, FE),
 	EVENT_EXTRA_END
@@ -5466,7 +5466,11 @@ static void intel_pmu_check_event_constraints(struct event_constraint *event_con
 			/* Disabled fixed counters which are not in CPUID */
 			c->idxmsk64 &= intel_ctrl;
 
-			if (c->idxmsk64 != INTEL_PMC_MSK_FIXED_REF_CYCLES)
+			/*
+			 * Don't extend the pseudo-encoding to the
+			 * generic counters
+			 */
+			if (!use_fixed_pseudo_encoding(c->code))
 				c->idxmsk64 |= (1ULL << num_counters) - 1;
 		}
 		c->idxmsk64 &=
diff --git a/arch/x86/include/asm/bug.h b/arch/x86/include/asm/bug.h
index bab883c0b6fe..66570e95af39 100644
--- a/arch/x86/include/asm/bug.h
+++ b/arch/x86/include/asm/bug.h
@@ -77,9 +77,9 @@ do {								\
  */
 #define __WARN_FLAGS(flags)					\
 do {								\
-	__auto_type f = BUGFLAG_WARNING|(flags);		\
+	__auto_type __flags = BUGFLAG_WARNING|(flags);		\
 	instrumentation_begin();				\
-	_BUG_FLAGS(ASM_UD2, f, ASM_REACHABLE);			\
+	_BUG_FLAGS(ASM_UD2, __flags, ASM_REACHABLE);		\
 	instrumentation_end();					\
 } while (0)
 
diff --git a/arch/x86/include/asm/irq_stack.h b/arch/x86/include/asm/irq_stack.h
index 8d55bd11848c..e087cd7837c3 100644
--- a/arch/x86/include/asm/irq_stack.h
+++ b/arch/x86/include/asm/irq_stack.h
@@ -99,7 +99,8 @@
 }
 
 #define ASM_CALL_ARG0							\
-	"call %P[__func]				\n"
+	"call %P[__func]				\n"		\
+	ASM_REACHABLE
 
 #define ASM_CALL_ARG1							\
 	"movq	%[arg1], %%rdi				\n"		\
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 01759199d723..d9bb5cdb5db2 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -505,6 +505,7 @@ struct kvm_pmu {
 	u64 global_ctrl_mask;
 	u64 global_ovf_ctrl_mask;
 	u64 reserved_bits;
+	u64 raw_event_mask;
 	u8 version;
 	struct kvm_pmc gp_counters[INTEL_PMC_MAX_GENERIC];
 	struct kvm_pmc fixed_counters[INTEL_PMC_MAX_FIXED];
diff --git a/arch/x86/include/asm/msi.h b/arch/x86/include/asm/msi.h
index b85147d75626..d71c7e8b738d 100644
--- a/arch/x86/include/asm/msi.h
+++ b/arch/x86/include/asm/msi.h
@@ -12,14 +12,17 @@ int pci_msi_prepare(struct irq_domain *domain, struct device *dev, int nvec,
 /* Structs and defines for the X86 specific MSI message format */
 
 typedef struct x86_msi_data {
-	u32	vector			:  8,
-		delivery_mode		:  3,
-		dest_mode_logical	:  1,
-		reserved		:  2,
-		active_low		:  1,
-		is_level		:  1;
-
-	u32	dmar_subhandle;
+	union {
+		struct {
+			u32	vector			:  8,
+				delivery_mode		:  3,
+				dest_mode_logical	:  1,
+				reserved		:  2,
+				active_low		:  1,
+				is_level		:  1;
+		};
+		u32	dmar_subhandle;
+	};
 } __attribute__ ((packed)) arch_msi_msg_data_t;
 #define arch_msi_msg_data	x86_msi_data
 
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 8fc1b5003713..a2b6626c681f 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -241,6 +241,11 @@ struct x86_pmu_capability {
 #define INTEL_PMC_IDX_FIXED_SLOTS	(INTEL_PMC_IDX_FIXED + 3)
 #define INTEL_PMC_MSK_FIXED_SLOTS	(1ULL << INTEL_PMC_IDX_FIXED_SLOTS)
 
+static inline bool use_fixed_pseudo_encoding(u64 code)
+{
+	return !(code & 0xff);
+}
+
 /*
  * We model BTS tracing as another fixed-mode PMC.
  *
diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 882213df3713..71f336425e58 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -1435,8 +1435,12 @@ irqreturn_t hpet_rtc_interrupt(int irq, void *dev_id)
 	hpet_rtc_timer_reinit();
 	memset(&curr_time, 0, sizeof(struct rtc_time));
 
-	if (hpet_rtc_flags & (RTC_UIE | RTC_AIE))
-		mc146818_get_time(&curr_time);
+	if (hpet_rtc_flags & (RTC_UIE | RTC_AIE)) {
+		if (unlikely(mc146818_get_time(&curr_time) < 0)) {
+			pr_err_ratelimited("unable to read current time from RTC\n");
+			return IRQ_HANDLED;
+		}
+	}
 
 	if (hpet_rtc_flags & RTC_UIE &&
 	    curr_time.tm_sec != hpet_prev_update_sec) {
diff --git a/arch/x86/kernel/static_call.c b/arch/x86/kernel/static_call.c
index ea028e736831..3d68dfb10aaa 100644
--- a/arch/x86/kernel/static_call.c
+++ b/arch/x86/kernel/static_call.c
@@ -12,10 +12,9 @@ enum insn_type {
 };
 
 /*
- * data16 data16 xorq %rax, %rax - a single 5 byte instruction that clears %rax
- * The REX.W cancels the effect of any data16.
+ * cs cs cs xorl %eax, %eax - a single 5 byte instruction that clears %[er]ax
  */
-static const u8 xor5rax[] = { 0x66, 0x66, 0x48, 0x31, 0xc0 };
+static const u8 xor5rax[] = { 0x2e, 0x2e, 0x2e, 0x31, 0xc0 };
 
 static void __ref __static_call_transform(void *insn, enum insn_type type, void *func)
 {
diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 4cf0938a876b..3747a754a8e8 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -3514,8 +3514,10 @@ static int em_rdpid(struct x86_emulate_ctxt *ctxt)
 {
 	u64 tsc_aux = 0;
 
-	if (ctxt->ops->get_msr(ctxt, MSR_TSC_AUX, &tsc_aux))
+	if (!ctxt->ops->guest_has_rdpid(ctxt))
 		return emulate_ud(ctxt);
+
+	ctxt->ops->get_msr(ctxt, MSR_TSC_AUX, &tsc_aux);
 	ctxt->dst.val = tsc_aux;
 	return X86EMUL_CONTINUE;
 }
diff --git a/arch/x86/kvm/kvm_emulate.h b/arch/x86/kvm/kvm_emulate.h
index 68b420289d7e..fb09cd22cb7f 100644
--- a/arch/x86/kvm/kvm_emulate.h
+++ b/arch/x86/kvm/kvm_emulate.h
@@ -226,6 +226,7 @@ struct x86_emulate_ops {
 	bool (*guest_has_long_mode)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_movbe)(struct x86_emulate_ctxt *ctxt);
 	bool (*guest_has_fxsr)(struct x86_emulate_ctxt *ctxt);
+	bool (*guest_has_rdpid)(struct x86_emulate_ctxt *ctxt);
 
 	void (*set_nmi_mask)(struct x86_emulate_ctxt *ctxt, bool masked);
 
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index f256f01056bd..62333f9756a3 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -96,8 +96,7 @@ static void kvm_perf_overflow_intr(struct perf_event *perf_event,
 
 static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 				  u64 config, bool exclude_user,
-				  bool exclude_kernel, bool intr,
-				  bool in_tx, bool in_tx_cp)
+				  bool exclude_kernel, bool intr)
 {
 	struct perf_event *event;
 	struct perf_event_attr attr = {
@@ -113,16 +112,14 @@ static void pmc_reprogram_counter(struct kvm_pmc *pmc, u32 type,
 
 	attr.sample_period = get_sample_period(pmc, pmc->counter);
 
-	if (in_tx)
-		attr.config |= HSW_IN_TX;
-	if (in_tx_cp) {
+	if ((attr.config & HSW_IN_TX_CHECKPOINTED) &&
+	    guest_cpuid_is_intel(pmc->vcpu)) {
 		/*
 		 * HSW_IN_TX_CHECKPOINTED is not supported with nonzero
 		 * period. Just clear the sample period so at least
 		 * allocating the counter doesn't fail.
 		 */
 		attr.sample_period = 0;
-		attr.config |= HSW_IN_TX_CHECKPOINTED;
 	}
 
 	event = perf_event_create_kernel_counter(&attr, -1, current,
@@ -178,6 +175,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	struct kvm *kvm = pmc->vcpu->kvm;
 	struct kvm_pmu_event_filter *filter;
 	int i;
+	struct kvm_pmu *pmu = vcpu_to_pmu(pmc->vcpu);
 	bool allow_event = true;
 
 	if (eventsel & ARCH_PERFMON_EVENTSEL_PIN_CONTROL)
@@ -217,7 +215,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	}
 
 	if (type == PERF_TYPE_RAW)
-		config = eventsel & AMD64_RAW_EVENT_MASK;
+		config = eventsel & pmu->raw_event_mask;
 
 	if (pmc->current_config == eventsel && pmc_resume_counter(pmc))
 		return;
@@ -228,9 +226,7 @@ void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	pmc_reprogram_counter(pmc, type, config,
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_USR),
 			      !(eventsel & ARCH_PERFMON_EVENTSEL_OS),
-			      eventsel & ARCH_PERFMON_EVENTSEL_INT,
-			      (eventsel & HSW_IN_TX),
-			      (eventsel & HSW_IN_TX_CHECKPOINTED));
+			      eventsel & ARCH_PERFMON_EVENTSEL_INT);
 }
 EXPORT_SYMBOL_GPL(reprogram_gp_counter);
 
@@ -266,7 +262,7 @@ void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 ctrl, int idx)
 			      kvm_x86_ops.pmu_ops->find_fixed_event(idx),
 			      !(en_field & 0x2), /* exclude user */
 			      !(en_field & 0x1), /* exclude kernel */
-			      pmi, false, false);
+			      pmi);
 }
 EXPORT_SYMBOL_GPL(reprogram_fixed_counter);
 
diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
index b9d21c526692..3d3f8dfb8045 100644
--- a/arch/x86/kvm/svm/avic.c
+++ b/arch/x86/kvm/svm/avic.c
@@ -947,15 +947,10 @@ avic_update_iommu_vcpu_affinity(struct kvm_vcpu *vcpu, int cpu, bool r)
 void avic_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 {
 	u64 entry;
-	/* ID = 0xff (broadcast), ID > 0xff (reserved) */
 	int h_physical_id = kvm_cpu_get_apicid(cpu);
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	/*
-	 * Since the host physical APIC id is 8 bits,
-	 * we can support host APIC ID upto 255.
-	 */
-	if (WARN_ON(h_physical_id > AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
+	if (WARN_ON(h_physical_id & ~AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK))
 		return;
 
 	entry = READ_ONCE(*(svm->avic_physical_id_cache));
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 06f8034f62e4..3faf1d9c6c91 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -261,12 +261,10 @@ static int amd_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	/* MSR_EVNTSELn */
 	pmc = get_gp_pmc_amd(pmu, msr, PMU_TYPE_EVNTSEL);
 	if (pmc) {
-		if (data == pmc->eventsel)
-			return 0;
-		if (!(data & pmu->reserved_bits)) {
+		data &= ~pmu->reserved_bits;
+		if (data != pmc->eventsel)
 			reprogram_gp_counter(pmc, data);
-			return 0;
-		}
+		return 0;
 	}
 
 	return 1;
@@ -283,6 +281,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 
 	pmu->counter_bitmask[KVM_PMC_GP] = ((u64)1 << 48) - 1;
 	pmu->reserved_bits = 0xfffffff000280000ull;
+	pmu->raw_event_mask = AMD64_RAW_EVENT_MASK;
 	pmu->version = 1;
 	/* not applicable to AMD; but clean them to prevent any fall out */
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index ff0855c03c91..cf2d8365aeb4 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -22,6 +22,8 @@
 #include <asm/svm.h>
 #include <asm/sev-common.h>
 
+#include "kvm_cache_regs.h"
+
 #define __sme_page_pa(x) __sme_set(page_to_pfn(x) << PAGE_SHIFT)
 
 #define	IOPM_SIZE PAGE_SIZE * 3
@@ -497,7 +499,7 @@ extern struct kvm_x86_nested_ops svm_nested_ops;
 #define AVIC_LOGICAL_ID_ENTRY_VALID_BIT			31
 #define AVIC_LOGICAL_ID_ENTRY_VALID_MASK		(1 << 31)
 
-#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	(0xFFULL)
+#define AVIC_PHYSICAL_ID_ENTRY_HOST_PHYSICAL_ID_MASK	GENMASK_ULL(11, 0)
 #define AVIC_PHYSICAL_ID_ENTRY_BACKING_PAGE_MASK	(0xFFFFFFFFFFULL << 12)
 #define AVIC_PHYSICAL_ID_ENTRY_IS_RUNNING_MASK		(1ULL << 62)
 #define AVIC_PHYSICAL_ID_ENTRY_VALID_MASK		(1ULL << 63)
diff --git a/arch/x86/kvm/svm/svm_onhyperv.c b/arch/x86/kvm/svm/svm_onhyperv.c
index 98aa981c04ec..8cdc62c74a96 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.c
+++ b/arch/x86/kvm/svm/svm_onhyperv.c
@@ -4,7 +4,6 @@
  */
 
 #include <linux/kvm_host.h>
-#include "kvm_cache_regs.h"
 
 #include <asm/mshyperv.h>
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 6427d95de01c..7abe77c8b5d0 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -396,6 +396,7 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	struct kvm_pmc *pmc;
 	u32 msr = msr_info->index;
 	u64 data = msr_info->data;
+	u64 reserved_bits;
 
 	switch (msr) {
 	case MSR_CORE_PERF_FIXED_CTR_CTRL:
@@ -451,7 +452,11 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		} else if ((pmc = get_gp_pmc(pmu, msr, MSR_P6_EVNTSEL0))) {
 			if (data == pmc->eventsel)
 				return 0;
-			if (!(data & pmu->reserved_bits)) {
+			reserved_bits = pmu->reserved_bits;
+			if ((pmc->idx == 2) &&
+			    (pmu->raw_event_mask & HSW_IN_TX_CHECKPOINTED))
+				reserved_bits ^= HSW_IN_TX_CHECKPOINTED;
+			if (!(data & reserved_bits)) {
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
@@ -478,6 +483,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	pmu->counter_bitmask[KVM_PMC_FIXED] = 0;
 	pmu->version = 0;
 	pmu->reserved_bits = 0xffffffff00200000ull;
+	pmu->raw_event_mask = X86_RAW_EVENT_MASK;
 
 	entry = kvm_find_cpuid_entry(vcpu, 0xa, 0);
 	if (!entry)
@@ -524,8 +530,10 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	entry = kvm_find_cpuid_entry(vcpu, 7, 0);
 	if (entry &&
 	    (boot_cpu_has(X86_FEATURE_HLE) || boot_cpu_has(X86_FEATURE_RTM)) &&
-	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM)))
-		pmu->reserved_bits ^= HSW_IN_TX|HSW_IN_TX_CHECKPOINTED;
+	    (entry->ebx & (X86_FEATURE_HLE|X86_FEATURE_RTM))) {
+		pmu->reserved_bits ^= HSW_IN_TX;
+		pmu->raw_event_mask |= (HSW_IN_TX|HSW_IN_TX_CHECKPOINTED);
+	}
 
 	bitmap_set(pmu->all_valid_pmc_idx,
 		0, pmu->nr_arch_gp_counters);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 3e606a6940dc..5e2983959f23 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7393,6 +7393,11 @@ static bool emulator_guest_has_fxsr(struct x86_emulate_ctxt *ctxt)
 	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_FXSR);
 }
 
+static bool emulator_guest_has_rdpid(struct x86_emulate_ctxt *ctxt)
+{
+	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_RDPID);
+}
+
 static ulong emulator_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg)
 {
 	return kvm_register_read_raw(emul_to_vcpu(ctxt), reg);
@@ -7475,6 +7480,7 @@ static const struct x86_emulate_ops emulate_ops = {
 	.guest_has_long_mode = emulator_guest_has_long_mode,
 	.guest_has_movbe     = emulator_guest_has_movbe,
 	.guest_has_fxsr      = emulator_guest_has_fxsr,
+	.guest_has_rdpid     = emulator_guest_has_rdpid,
 	.set_nmi_mask        = emulator_set_nmi_mask,
 	.get_hflags          = emulator_get_hflags,
 	.exiting_smm         = emulator_exiting_smm,
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c
index 59ba2968af1b..511172d70825 100644
--- a/arch/x86/mm/tlb.c
+++ b/arch/x86/mm/tlb.c
@@ -854,13 +854,11 @@ static void flush_tlb_func(void *info)
 			nr_invalidate);
 }
 
-static bool tlb_is_not_lazy(int cpu)
+static bool tlb_is_not_lazy(int cpu, void *data)
 {
 	return !per_cpu(cpu_tlbstate_shared.is_lazy, cpu);
 }
 
-static DEFINE_PER_CPU(cpumask_t, flush_tlb_mask);
-
 DEFINE_PER_CPU_SHARED_ALIGNED(struct tlb_state_shared, cpu_tlbstate_shared);
 EXPORT_PER_CPU_SYMBOL(cpu_tlbstate_shared);
 
@@ -889,36 +887,11 @@ STATIC_NOPV void native_flush_tlb_multi(const struct cpumask *cpumask,
 	 * up on the new contents of what used to be page tables, while
 	 * doing a speculative memory access.
 	 */
-	if (info->freed_tables) {
+	if (info->freed_tables)
 		on_each_cpu_mask(cpumask, flush_tlb_func, (void *)info, true);
-	} else {
-		/*
-		 * Although we could have used on_each_cpu_cond_mask(),
-		 * open-coding it has performance advantages, as it eliminates
-		 * the need for indirect calls or retpolines. In addition, it
-		 * allows to use a designated cpumask for evaluating the
-		 * condition, instead of allocating one.
-		 *
-		 * This code works under the assumption that there are no nested
-		 * TLB flushes, an assumption that is already made in
-		 * flush_tlb_mm_range().
-		 *
-		 * cond_cpumask is logically a stack-local variable, but it is
-		 * more efficient to have it off the stack and not to allocate
-		 * it on demand. Preemption is disabled and this code is
-		 * non-reentrant.
-		 */
-		struct cpumask *cond_cpumask = this_cpu_ptr(&flush_tlb_mask);
-		int cpu;
-
-		cpumask_clear(cond_cpumask);
-
-		for_each_cpu(cpu, cpumask) {
-			if (tlb_is_not_lazy(cpu))
-				__cpumask_set_cpu(cpu, cond_cpumask);
-		}
-		on_each_cpu_mask(cond_cpumask, flush_tlb_func, (void *)info, true);
-	}
+	else
+		on_each_cpu_cond_mask(tlb_is_not_lazy, flush_tlb_func,
+				(void *)info, 1, cpumask);
 }
 
 void flush_tlb_multi(const struct cpumask *cpumask,
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 6665f8802098..736008f2fccc 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -40,7 +40,8 @@ static void msr_save_context(struct saved_context *ctxt)
 	struct saved_msr *end = msr + ctxt->saved_msrs.num;
 
 	while (msr < end) {
-		msr->valid = !rdmsrl_safe(msr->info.msr_no, &msr->info.reg.q);
+		if (msr->valid)
+			rdmsrl(msr->info.msr_no, msr->info.reg.q);
 		msr++;
 	}
 }
@@ -424,8 +425,10 @@ static int msr_build_context(const u32 *msr_id, const int num)
 	}
 
 	for (i = saved_msrs->num, j = 0; i < total_num; i++, j++) {
+		u64 dummy;
+
 		msr_array[i].info.msr_no	= msr_id[j];
-		msr_array[i].valid		= false;
+		msr_array[i].valid		= !rdmsrl_safe(msr_id[j], &dummy);
 		msr_array[i].info.reg.q		= 0;
 	}
 	saved_msrs->num   = total_num;
@@ -500,10 +503,24 @@ static int pm_cpu_check(const struct x86_cpu_id *c)
 	return ret;
 }
 
+static void pm_save_spec_msr(void)
+{
+	u32 spec_msr_id[] = {
+		MSR_IA32_SPEC_CTRL,
+		MSR_IA32_TSX_CTRL,
+		MSR_TSX_FORCE_ABORT,
+		MSR_IA32_MCU_OPT_CTRL,
+		MSR_AMD64_LS_CFG,
+	};
+
+	msr_build_context(spec_msr_id, ARRAY_SIZE(spec_msr_id));
+}
+
 static int pm_check_save_msr(void)
 {
 	dmi_check_system(msr_save_dmi_table);
 	pm_cpu_check(msr_save_cpu_table);
+	pm_save_spec_msr();
 
 	return 0;
 }
diff --git a/arch/x86/xen/smp_hvm.c b/arch/x86/xen/smp_hvm.c
index 6ff3c887e0b9..b70afdff419c 100644
--- a/arch/x86/xen/smp_hvm.c
+++ b/arch/x86/xen/smp_hvm.c
@@ -19,6 +19,12 @@ static void __init xen_hvm_smp_prepare_boot_cpu(void)
 	 */
 	xen_vcpu_setup(0);
 
+	/*
+	 * Called again in case the kernel boots on vcpu >= MAX_VIRT_CPUS.
+	 * Refer to comments in xen_hvm_init_time_ops().
+	 */
+	xen_hvm_init_time_ops();
+
 	/*
 	 * The alternative logic (which patches the unlock/lock) runs before
 	 * the smp bootup up code is activated. Hence we need to set this up
diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
index d9c945ee1100..9ef0a5cca96e 100644
--- a/arch/x86/xen/time.c
+++ b/arch/x86/xen/time.c
@@ -558,6 +558,11 @@ static void xen_hvm_setup_cpu_clockevents(void)
 
 void __init xen_hvm_init_time_ops(void)
 {
+	static bool hvm_time_initialized;
+
+	if (hvm_time_initialized)
+		return;
+
 	/*
 	 * vector callback is needed otherwise we cannot receive interrupts
 	 * on cpu > 0 and at this point we don't know how many cpus are
@@ -567,7 +572,22 @@ void __init xen_hvm_init_time_ops(void)
 		return;
 
 	if (!xen_feature(XENFEAT_hvm_safe_pvclock)) {
-		pr_info("Xen doesn't support pvclock on HVM, disable pv timer");
+		pr_info_once("Xen doesn't support pvclock on HVM, disable pv timer");
+		return;
+	}
+
+	/*
+	 * Only MAX_VIRT_CPUS 'vcpu_info' are embedded inside 'shared_info'.
+	 * The __this_cpu_read(xen_vcpu) is still NULL when Xen HVM guest
+	 * boots on vcpu >= MAX_VIRT_CPUS (e.g., kexec), To access
+	 * __this_cpu_read(xen_vcpu) via xen_clocksource_read() will panic.
+	 *
+	 * The xen_hvm_init_time_ops() should be called again later after
+	 * __this_cpu_read(xen_vcpu) is available.
+	 */
+	if (!__this_cpu_read(xen_vcpu)) {
+		pr_info("Delay xen_init_time_common() as kernel is running on vcpu=%d\n",
+			xen_vcpu_nr(0));
 		return;
 	}
 
@@ -577,6 +597,8 @@ void __init xen_hvm_init_time_ops(void)
 	x86_cpuinit.setup_percpu_clockev = xen_hvm_setup_cpu_clockevents;
 
 	x86_platform.set_wallclock = xen_set_wallclock;
+
+	hvm_time_initialized = true;
 }
 #endif
 
diff --git a/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi b/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi
index 9bf8bad1dd18..c33932568aa7 100644
--- a/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi
+++ b/arch/xtensa/boot/dts/xtfpga-flash-128m.dtsi
@@ -8,19 +8,19 @@ flash: flash@00000000 {
 			reg = <0x00000000 0x08000000>;
 			bank-width = <2>;
 			device-width = <2>;
-			partition@0x0 {
+			partition@0 {
 				label = "data";
 				reg = <0x00000000 0x06000000>;
 			};
-			partition@0x6000000 {
+			partition@6000000 {
 				label = "boot loader area";
 				reg = <0x06000000 0x00800000>;
 			};
-			partition@0x6800000 {
+			partition@6800000 {
 				label = "kernel image";
 				reg = <0x06800000 0x017e0000>;
 			};
-			partition@0x7fe0000 {
+			partition@7fe0000 {
 				label = "boot environment";
 				reg = <0x07fe0000 0x00020000>;
 			};
diff --git a/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi b/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi
index 40c2f81f7cb6..7bde2ab2d6fb 100644
--- a/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi
+++ b/arch/xtensa/boot/dts/xtfpga-flash-16m.dtsi
@@ -8,19 +8,19 @@ flash: flash@08000000 {
 			reg = <0x08000000 0x01000000>;
 			bank-width = <2>;
 			device-width = <2>;
-			partition@0x0 {
+			partition@0 {
 				label = "boot loader area";
 				reg = <0x00000000 0x00400000>;
 			};
-			partition@0x400000 {
+			partition@400000 {
 				label = "kernel image";
 				reg = <0x00400000 0x00600000>;
 			};
-			partition@0xa00000 {
+			partition@a00000 {
 				label = "data";
 				reg = <0x00a00000 0x005e0000>;
 			};
-			partition@0xfe0000 {
+			partition@fe0000 {
 				label = "boot environment";
 				reg = <0x00fe0000 0x00020000>;
 			};
diff --git a/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi b/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi
index fb8d3a9f33c2..0655b868749a 100644
--- a/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi
+++ b/arch/xtensa/boot/dts/xtfpga-flash-4m.dtsi
@@ -8,11 +8,11 @@ flash: flash@08000000 {
 			reg = <0x08000000 0x00400000>;
 			bank-width = <2>;
 			device-width = <2>;
-			partition@0x0 {
+			partition@0 {
 				label = "boot loader area";
 				reg = <0x00000000 0x003f0000>;
 			};
-			partition@0x3f0000 {
+			partition@3f0000 {
 				label = "boot environment";
 				reg = <0x003f0000 0x00010000>;
 			};
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 338c2e50f759..29e2b0dfba30 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -145,7 +145,11 @@ struct sata_dwc_device {
 #endif
 };
 
-#define SATA_DWC_QCMD_MAX	32
+/*
+ * Allow one extra special slot for commands and DMA management
+ * to account for libata internal commands.
+ */
+#define SATA_DWC_QCMD_MAX	(ATA_MAX_QUEUE + 1)
 
 struct sata_dwc_device_port {
 	struct sata_dwc_device	*hsdev;
diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
index 94665037f4a3..72b7a92337b1 100644
--- a/drivers/base/power/trace.c
+++ b/drivers/base/power/trace.c
@@ -120,7 +120,11 @@ static unsigned int read_magic_time(void)
 	struct rtc_time time;
 	unsigned int val;
 
-	mc146818_get_time(&time);
+	if (mc146818_get_time(&time) < 0) {
+		pr_err("Unable to read current time from RTC\n");
+		return 0;
+	}
+
 	pr_info("RTC time: %ptRt, date: %ptRd\n", &time, &time);
 	val = time.tm_year;				/* 100 years */
 	if (val > 100)
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index 5d9181382ce1..0a5766a2f161 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1642,22 +1642,22 @@ struct sib_info {
 };
 void drbd_bcast_event(struct drbd_device *device, const struct sib_info *sib);
 
-extern void notify_resource_state(struct sk_buff *,
+extern int notify_resource_state(struct sk_buff *,
 				  unsigned int,
 				  struct drbd_resource *,
 				  struct resource_info *,
 				  enum drbd_notification_type);
-extern void notify_device_state(struct sk_buff *,
+extern int notify_device_state(struct sk_buff *,
 				unsigned int,
 				struct drbd_device *,
 				struct device_info *,
 				enum drbd_notification_type);
-extern void notify_connection_state(struct sk_buff *,
+extern int notify_connection_state(struct sk_buff *,
 				    unsigned int,
 				    struct drbd_connection *,
 				    struct connection_info *,
 				    enum drbd_notification_type);
-extern void notify_peer_device_state(struct sk_buff *,
+extern int notify_peer_device_state(struct sk_buff *,
 				     unsigned int,
 				     struct drbd_peer_device *,
 				     struct peer_device_info *,
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 44ccf8b4f4b2..69184cf17b6a 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -4617,7 +4617,7 @@ static int nla_put_notification_header(struct sk_buff *msg,
 	return drbd_notification_header_to_skb(msg, &nh, true);
 }
 
-void notify_resource_state(struct sk_buff *skb,
+int notify_resource_state(struct sk_buff *skb,
 			   unsigned int seq,
 			   struct drbd_resource *resource,
 			   struct resource_info *resource_info,
@@ -4659,16 +4659,17 @@ void notify_resource_state(struct sk_buff *skb,
 		if (err && err != -ESRCH)
 			goto failed;
 	}
-	return;
+	return 0;
 
 nla_put_failure:
 	nlmsg_free(skb);
 failed:
 	drbd_err(resource, "Error %d while broadcasting event. Event seq:%u\n",
 			err, seq);
+	return err;
 }
 
-void notify_device_state(struct sk_buff *skb,
+int notify_device_state(struct sk_buff *skb,
 			 unsigned int seq,
 			 struct drbd_device *device,
 			 struct device_info *device_info,
@@ -4708,16 +4709,17 @@ void notify_device_state(struct sk_buff *skb,
 		if (err && err != -ESRCH)
 			goto failed;
 	}
-	return;
+	return 0;
 
 nla_put_failure:
 	nlmsg_free(skb);
 failed:
 	drbd_err(device, "Error %d while broadcasting event. Event seq:%u\n",
 		 err, seq);
+	return err;
 }
 
-void notify_connection_state(struct sk_buff *skb,
+int notify_connection_state(struct sk_buff *skb,
 			     unsigned int seq,
 			     struct drbd_connection *connection,
 			     struct connection_info *connection_info,
@@ -4757,16 +4759,17 @@ void notify_connection_state(struct sk_buff *skb,
 		if (err && err != -ESRCH)
 			goto failed;
 	}
-	return;
+	return 0;
 
 nla_put_failure:
 	nlmsg_free(skb);
 failed:
 	drbd_err(connection, "Error %d while broadcasting event. Event seq:%u\n",
 		 err, seq);
+	return err;
 }
 
-void notify_peer_device_state(struct sk_buff *skb,
+int notify_peer_device_state(struct sk_buff *skb,
 			      unsigned int seq,
 			      struct drbd_peer_device *peer_device,
 			      struct peer_device_info *peer_device_info,
@@ -4807,13 +4810,14 @@ void notify_peer_device_state(struct sk_buff *skb,
 		if (err && err != -ESRCH)
 			goto failed;
 	}
-	return;
+	return 0;
 
 nla_put_failure:
 	nlmsg_free(skb);
 failed:
 	drbd_err(peer_device, "Error %d while broadcasting event. Event seq:%u\n",
 		 err, seq);
+	return err;
 }
 
 void notify_helper(enum drbd_notification_type type,
@@ -4864,7 +4868,7 @@ void notify_helper(enum drbd_notification_type type,
 		 err, seq);
 }
 
-static void notify_initial_state_done(struct sk_buff *skb, unsigned int seq)
+static int notify_initial_state_done(struct sk_buff *skb, unsigned int seq)
 {
 	struct drbd_genlmsghdr *dh;
 	int err;
@@ -4878,11 +4882,12 @@ static void notify_initial_state_done(struct sk_buff *skb, unsigned int seq)
 	if (nla_put_notification_header(skb, NOTIFY_EXISTS))
 		goto nla_put_failure;
 	genlmsg_end(skb, dh);
-	return;
+	return 0;
 
 nla_put_failure:
 	nlmsg_free(skb);
 	pr_err("Error %d sending event. Event seq:%u\n", err, seq);
+	return err;
 }
 
 static void free_state_changes(struct list_head *list)
@@ -4909,6 +4914,7 @@ static int get_initial_state(struct sk_buff *skb, struct netlink_callback *cb)
 	unsigned int seq = cb->args[2];
 	unsigned int n;
 	enum drbd_notification_type flags = 0;
+	int err = 0;
 
 	/* There is no need for taking notification_mutex here: it doesn't
 	   matter if the initial state events mix with later state chage
@@ -4917,32 +4923,32 @@ static int get_initial_state(struct sk_buff *skb, struct netlink_callback *cb)
 
 	cb->args[5]--;
 	if (cb->args[5] == 1) {
-		notify_initial_state_done(skb, seq);
+		err = notify_initial_state_done(skb, seq);
 		goto out;
 	}
 	n = cb->args[4]++;
 	if (cb->args[4] < cb->args[3])
 		flags |= NOTIFY_CONTINUES;
 	if (n < 1) {
-		notify_resource_state_change(skb, seq, state_change->resource,
+		err = notify_resource_state_change(skb, seq, state_change->resource,
 					     NOTIFY_EXISTS | flags);
 		goto next;
 	}
 	n--;
 	if (n < state_change->n_connections) {
-		notify_connection_state_change(skb, seq, &state_change->connections[n],
+		err = notify_connection_state_change(skb, seq, &state_change->connections[n],
 					       NOTIFY_EXISTS | flags);
 		goto next;
 	}
 	n -= state_change->n_connections;
 	if (n < state_change->n_devices) {
-		notify_device_state_change(skb, seq, &state_change->devices[n],
+		err = notify_device_state_change(skb, seq, &state_change->devices[n],
 					   NOTIFY_EXISTS | flags);
 		goto next;
 	}
 	n -= state_change->n_devices;
 	if (n < state_change->n_devices * state_change->n_connections) {
-		notify_peer_device_state_change(skb, seq, &state_change->peer_devices[n],
+		err = notify_peer_device_state_change(skb, seq, &state_change->peer_devices[n],
 						NOTIFY_EXISTS | flags);
 		goto next;
 	}
@@ -4957,7 +4963,10 @@ static int get_initial_state(struct sk_buff *skb, struct netlink_callback *cb)
 		cb->args[4] = 0;
 	}
 out:
-	return skb->len;
+	if (err)
+		return err;
+	else
+		return skb->len;
 }
 
 int drbd_adm_get_initial_state(struct sk_buff *skb, struct netlink_callback *cb)
diff --git a/drivers/block/drbd/drbd_state.c b/drivers/block/drbd/drbd_state.c
index b8a27818ab3f..4ee11aef6672 100644
--- a/drivers/block/drbd/drbd_state.c
+++ b/drivers/block/drbd/drbd_state.c
@@ -1537,7 +1537,7 @@ int drbd_bitmap_io_from_worker(struct drbd_device *device,
 	return rv;
 }
 
-void notify_resource_state_change(struct sk_buff *skb,
+int notify_resource_state_change(struct sk_buff *skb,
 				  unsigned int seq,
 				  struct drbd_resource_state_change *resource_state_change,
 				  enum drbd_notification_type type)
@@ -1550,10 +1550,10 @@ void notify_resource_state_change(struct sk_buff *skb,
 		.res_susp_fen = resource_state_change->susp_fen[NEW],
 	};
 
-	notify_resource_state(skb, seq, resource, &resource_info, type);
+	return notify_resource_state(skb, seq, resource, &resource_info, type);
 }
 
-void notify_connection_state_change(struct sk_buff *skb,
+int notify_connection_state_change(struct sk_buff *skb,
 				    unsigned int seq,
 				    struct drbd_connection_state_change *connection_state_change,
 				    enum drbd_notification_type type)
@@ -1564,10 +1564,10 @@ void notify_connection_state_change(struct sk_buff *skb,
 		.conn_role = connection_state_change->peer_role[NEW],
 	};
 
-	notify_connection_state(skb, seq, connection, &connection_info, type);
+	return notify_connection_state(skb, seq, connection, &connection_info, type);
 }
 
-void notify_device_state_change(struct sk_buff *skb,
+int notify_device_state_change(struct sk_buff *skb,
 				unsigned int seq,
 				struct drbd_device_state_change *device_state_change,
 				enum drbd_notification_type type)
@@ -1577,10 +1577,10 @@ void notify_device_state_change(struct sk_buff *skb,
 		.dev_disk_state = device_state_change->disk_state[NEW],
 	};
 
-	notify_device_state(skb, seq, device, &device_info, type);
+	return notify_device_state(skb, seq, device, &device_info, type);
 }
 
-void notify_peer_device_state_change(struct sk_buff *skb,
+int notify_peer_device_state_change(struct sk_buff *skb,
 				     unsigned int seq,
 				     struct drbd_peer_device_state_change *p,
 				     enum drbd_notification_type type)
@@ -1594,7 +1594,7 @@ void notify_peer_device_state_change(struct sk_buff *skb,
 		.peer_resync_susp_dependency = p->resync_susp_dependency[NEW],
 	};
 
-	notify_peer_device_state(skb, seq, peer_device, &peer_device_info, type);
+	return notify_peer_device_state(skb, seq, peer_device, &peer_device_info, type);
 }
 
 static void broadcast_state_change(struct drbd_state_change *state_change)
@@ -1602,7 +1602,7 @@ static void broadcast_state_change(struct drbd_state_change *state_change)
 	struct drbd_resource_state_change *resource_state_change = &state_change->resource[0];
 	bool resource_state_has_changed;
 	unsigned int n_device, n_connection, n_peer_device, n_peer_devices;
-	void (*last_func)(struct sk_buff *, unsigned int, void *,
+	int (*last_func)(struct sk_buff *, unsigned int, void *,
 			  enum drbd_notification_type) = NULL;
 	void *last_arg = NULL;
 
diff --git a/drivers/block/drbd/drbd_state_change.h b/drivers/block/drbd/drbd_state_change.h
index ba80f612d6ab..d5b0479bc9a6 100644
--- a/drivers/block/drbd/drbd_state_change.h
+++ b/drivers/block/drbd/drbd_state_change.h
@@ -44,19 +44,19 @@ extern struct drbd_state_change *remember_old_state(struct drbd_resource *, gfp_
 extern void copy_old_to_new_state_change(struct drbd_state_change *);
 extern void forget_state_change(struct drbd_state_change *);
 
-extern void notify_resource_state_change(struct sk_buff *,
+extern int notify_resource_state_change(struct sk_buff *,
 					 unsigned int,
 					 struct drbd_resource_state_change *,
 					 enum drbd_notification_type type);
-extern void notify_connection_state_change(struct sk_buff *,
+extern int notify_connection_state_change(struct sk_buff *,
 					   unsigned int,
 					   struct drbd_connection_state_change *,
 					   enum drbd_notification_type type);
-extern void notify_device_state_change(struct sk_buff *,
+extern int notify_device_state_change(struct sk_buff *,
 				       unsigned int,
 				       struct drbd_device_state_change *,
 				       enum drbd_notification_type type);
-extern void notify_peer_device_state_change(struct sk_buff *,
+extern int notify_peer_device_state_change(struct sk_buff *,
 					    unsigned int,
 					    struct drbd_peer_device_state_change *,
 					    enum drbd_notification_type type);
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 577c7dba5d78..582b23befb5c 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -254,7 +254,7 @@ static void nbd_dev_remove(struct nbd_device *nbd)
 	mutex_lock(&nbd_index_mutex);
 	idr_remove(&nbd_index_idr, nbd->index);
 	mutex_unlock(&nbd_index_mutex);
-
+	destroy_workqueue(nbd->recv_workq);
 	kfree(nbd);
 }
 
@@ -1260,10 +1260,6 @@ static void nbd_config_put(struct nbd_device *nbd)
 		kfree(nbd->config);
 		nbd->config = NULL;
 
-		if (nbd->recv_workq)
-			destroy_workqueue(nbd->recv_workq);
-		nbd->recv_workq = NULL;
-
 		nbd->tag_set.timeout = 0;
 		nbd->disk->queue->limits.discard_granularity = 0;
 		nbd->disk->queue->limits.discard_alignment = 0;
@@ -1292,14 +1288,6 @@ static int nbd_start_device(struct nbd_device *nbd)
 		return -EINVAL;
 	}
 
-	nbd->recv_workq = alloc_workqueue("knbd%d-recv",
-					  WQ_MEM_RECLAIM | WQ_HIGHPRI |
-					  WQ_UNBOUND, 0, nbd->index);
-	if (!nbd->recv_workq) {
-		dev_err(disk_to_dev(nbd->disk), "Could not allocate knbd recv work queue.\n");
-		return -ENOMEM;
-	}
-
 	blk_mq_update_nr_hw_queues(&nbd->tag_set, config->num_connections);
 	nbd->pid = task_pid_nr(current);
 
@@ -1725,6 +1713,15 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	}
 	nbd->disk = disk;
 
+	nbd->recv_workq = alloc_workqueue("nbd%d-recv",
+					  WQ_MEM_RECLAIM | WQ_HIGHPRI |
+					  WQ_UNBOUND, 0, nbd->index);
+	if (!nbd->recv_workq) {
+		dev_err(disk_to_dev(nbd->disk), "Could not allocate knbd recv work queue.\n");
+		err = -ENOMEM;
+		goto out_err_disk;
+	}
+
 	/*
 	 * Tell the block layer that we are not a rotational device
 	 */
@@ -1755,14 +1752,16 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	disk->first_minor = index << part_shift;
 	if (disk->first_minor < index || disk->first_minor > MINORMASK) {
 		err = -EINVAL;
-		goto out_free_idr;
+		goto out_free_work;
 	}
 
 	disk->minors = 1 << part_shift;
 	disk->fops = &nbd_fops;
 	disk->private_data = nbd;
 	sprintf(disk->disk_name, "nbd%d", index);
-	add_disk(disk);
+	err = add_disk(disk);
+	if (err)
+		goto out_free_work;
 
 	/*
 	 * Now publish the device.
@@ -1771,6 +1770,10 @@ static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
 	nbd_total_devices++;
 	return nbd;
 
+out_free_work:
+	destroy_workqueue(nbd->recv_workq);
+out_err_disk:
+	blk_cleanup_disk(disk);
 out_free_idr:
 	mutex_lock(&nbd_index_mutex);
 	idr_remove(&nbd_index_idr, index);
@@ -2024,13 +2027,10 @@ static void nbd_disconnect_and_put(struct nbd_device *nbd)
 	nbd_disconnect(nbd);
 	sock_shutdown(nbd);
 	/*
-	 * Make sure recv thread has finished, so it does not drop the last
-	 * config ref and try to destroy the workqueue from inside the work
-	 * queue. And this also ensure that we can safely call nbd_clear_que()
+	 * Make sure recv thread has finished, we can safely call nbd_clear_que()
 	 * to cancel the inflight I/Os.
 	 */
-	if (nbd->recv_workq)
-		flush_workqueue(nbd->recv_workq);
+	flush_workqueue(nbd->recv_workq);
 	nbd_clear_que(nbd);
 	nbd->task_setup = NULL;
 	mutex_unlock(&nbd->config_lock);
diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index 3adf04766e98..77bc993d7513 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -2236,7 +2236,7 @@ static struct virtio_driver virtio_rproc_serial = {
 	.remove =	virtcons_remove,
 };
 
-static int __init init(void)
+static int __init virtio_console_init(void)
 {
 	int err;
 
@@ -2271,7 +2271,7 @@ static int __init init(void)
 	return err;
 }
 
-static void __exit fini(void)
+static void __exit virtio_console_fini(void)
 {
 	reclaim_dma_bufs();
 
@@ -2281,8 +2281,8 @@ static void __exit fini(void)
 	class_destroy(pdrvdata.class);
 	debugfs_remove_recursive(pdrvdata.debugfs_dir);
 }
-module_init(init);
-module_exit(fini);
+module_init(virtio_console_init);
+module_exit(virtio_console_fini);
 
 MODULE_DESCRIPTION("Virtio console driver");
 MODULE_LICENSE("GPL");
diff --git a/drivers/clk/clk-si5341.c b/drivers/clk/clk-si5341.c
index f7b41366666e..4de098b6b0d4 100644
--- a/drivers/clk/clk-si5341.c
+++ b/drivers/clk/clk-si5341.c
@@ -798,6 +798,15 @@ static unsigned long si5341_output_clk_recalc_rate(struct clk_hw *hw,
 	u32 r_divider;
 	u8 r[3];
 
+	err = regmap_read(output->data->regmap,
+			SI5341_OUT_CONFIG(output), &val);
+	if (err < 0)
+		return err;
+
+	/* If SI5341_OUT_CFG_RDIV_FORCE2 is set, r_divider is 2 */
+	if (val & SI5341_OUT_CFG_RDIV_FORCE2)
+		return parent_rate / 2;
+
 	err = regmap_bulk_read(output->data->regmap,
 			SI5341_OUT_R_REG(output), r, 3);
 	if (err < 0)
@@ -814,13 +823,6 @@ static unsigned long si5341_output_clk_recalc_rate(struct clk_hw *hw,
 	r_divider += 1;
 	r_divider <<= 1;
 
-	err = regmap_read(output->data->regmap,
-			SI5341_OUT_CONFIG(output), &val);
-	if (err < 0)
-		return err;
-
-	if (val & SI5341_OUT_CFG_RDIV_FORCE2)
-		r_divider = 2;
 
 	return parent_rate / r_divider;
 }
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index 5cef73a85901..d6dc58bd07b3 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -631,6 +631,24 @@ static void clk_core_get_boundaries(struct clk_core *core,
 		*max_rate = min(*max_rate, clk_user->max_rate);
 }
 
+static bool clk_core_check_boundaries(struct clk_core *core,
+				      unsigned long min_rate,
+				      unsigned long max_rate)
+{
+	struct clk *user;
+
+	lockdep_assert_held(&prepare_lock);
+
+	if (min_rate > core->max_rate || max_rate < core->min_rate)
+		return false;
+
+	hlist_for_each_entry(user, &core->clks, clks_node)
+		if (min_rate > user->max_rate || max_rate < user->min_rate)
+			return false;
+
+	return true;
+}
+
 void clk_hw_set_rate_range(struct clk_hw *hw, unsigned long min_rate,
 			   unsigned long max_rate)
 {
@@ -2347,6 +2365,11 @@ int clk_set_rate_range(struct clk *clk, unsigned long min, unsigned long max)
 	clk->min_rate = min;
 	clk->max_rate = max;
 
+	if (!clk_core_check_boundaries(clk->core, min, max)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	rate = clk_core_get_rate_nolock(clk->core);
 	if (rate < min || rate > max) {
 		/*
@@ -2375,6 +2398,7 @@ int clk_set_rate_range(struct clk *clk, unsigned long min, unsigned long max)
 		}
 	}
 
+out:
 	if (clk->exclusive_count)
 		clk_core_rate_protect(clk->core);
 
diff --git a/drivers/clk/rockchip/clk-rk3568.c b/drivers/clk/rockchip/clk-rk3568.c
index 75ca855e720d..6e5440841d1e 100644
--- a/drivers/clk/rockchip/clk-rk3568.c
+++ b/drivers/clk/rockchip/clk-rk3568.c
@@ -1038,13 +1038,13 @@ static struct rockchip_clk_branch rk3568_clk_branches[] __initdata = {
 			RK3568_CLKGATE_CON(20), 8, GFLAGS),
 	GATE(HCLK_VOP, "hclk_vop", "hclk_vo", 0,
 			RK3568_CLKGATE_CON(20), 9, GFLAGS),
-	COMPOSITE(DCLK_VOP0, "dclk_vop0", hpll_vpll_gpll_cpll_p, CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
+	COMPOSITE(DCLK_VOP0, "dclk_vop0", hpll_vpll_gpll_cpll_p, CLK_SET_RATE_NO_REPARENT,
 			RK3568_CLKSEL_CON(39), 10, 2, MFLAGS, 0, 8, DFLAGS,
 			RK3568_CLKGATE_CON(20), 10, GFLAGS),
-	COMPOSITE(DCLK_VOP1, "dclk_vop1", hpll_vpll_gpll_cpll_p, CLK_SET_RATE_PARENT | CLK_SET_RATE_NO_REPARENT,
+	COMPOSITE(DCLK_VOP1, "dclk_vop1", hpll_vpll_gpll_cpll_p, CLK_SET_RATE_NO_REPARENT,
 			RK3568_CLKSEL_CON(40), 10, 2, MFLAGS, 0, 8, DFLAGS,
 			RK3568_CLKGATE_CON(20), 11, GFLAGS),
-	COMPOSITE(DCLK_VOP2, "dclk_vop2", hpll_vpll_gpll_cpll_p, 0,
+	COMPOSITE(DCLK_VOP2, "dclk_vop2", hpll_vpll_gpll_cpll_p, CLK_SET_RATE_NO_REPARENT,
 			RK3568_CLKSEL_CON(41), 10, 2, MFLAGS, 0, 8, DFLAGS,
 			RK3568_CLKGATE_CON(20), 12, GFLAGS),
 	GATE(CLK_VOP_PWM, "clk_vop_pwm", "xin24m", 0,
diff --git a/drivers/clk/ti/clk.c b/drivers/clk/ti/clk.c
index 3da33c786d77..29eafab4353e 100644
--- a/drivers/clk/ti/clk.c
+++ b/drivers/clk/ti/clk.c
@@ -131,7 +131,7 @@ int ti_clk_setup_ll_ops(struct ti_clk_ll_ops *ops)
 void __init ti_dt_clocks_register(struct ti_dt_clk oclks[])
 {
 	struct ti_dt_clk *c;
-	struct device_node *node, *parent;
+	struct device_node *node, *parent, *child;
 	struct clk *clk;
 	struct of_phandle_args clkspec;
 	char buf[64];
@@ -171,10 +171,13 @@ void __init ti_dt_clocks_register(struct ti_dt_clk oclks[])
 		node = of_find_node_by_name(NULL, buf);
 		if (num_args && compat_mode) {
 			parent = node;
-			node = of_get_child_by_name(parent, "clock");
-			if (!node)
-				node = of_get_child_by_name(parent, "clk");
-			of_node_put(parent);
+			child = of_get_child_by_name(parent, "clock");
+			if (!child)
+				child = of_get_child_by_name(parent, "clk");
+			if (child) {
+				of_node_put(parent);
+				node = child;
+			}
 		}
 
 		clkspec.np = node;
diff --git a/drivers/cpufreq/cppc_cpufreq.c b/drivers/cpufreq/cppc_cpufreq.c
index d4c27022b9c9..e0ff09d66c96 100644
--- a/drivers/cpufreq/cppc_cpufreq.c
+++ b/drivers/cpufreq/cppc_cpufreq.c
@@ -303,52 +303,48 @@ static u64 cppc_get_dmi_max_khz(void)
 
 /*
  * If CPPC lowest_freq and nominal_freq registers are exposed then we can
- * use them to convert perf to freq and vice versa
- *
- * If the perf/freq point lies between Nominal and Lowest, we can treat
- * (Low perf, Low freq) and (Nom Perf, Nom freq) as 2D co-ordinates of a line
- * and extrapolate the rest
- * For perf/freq > Nominal, we use the ratio perf:freq at Nominal for conversion
+ * use them to convert perf to freq and vice versa. The conversion is
+ * extrapolated as an affine function passing by the 2 points:
+ *  - (Low perf, Low freq)
+ *  - (Nominal perf, Nominal perf)
  */
 static unsigned int cppc_cpufreq_perf_to_khz(struct cppc_cpudata *cpu_data,
 					     unsigned int perf)
 {
 	struct cppc_perf_caps *caps = &cpu_data->perf_caps;
+	s64 retval, offset = 0;
 	static u64 max_khz;
 	u64 mul, div;
 
 	if (caps->lowest_freq && caps->nominal_freq) {
-		if (perf >= caps->nominal_perf) {
-			mul = caps->nominal_freq;
-			div = caps->nominal_perf;
-		} else {
-			mul = caps->nominal_freq - caps->lowest_freq;
-			div = caps->nominal_perf - caps->lowest_perf;
-		}
+		mul = caps->nominal_freq - caps->lowest_freq;
+		div = caps->nominal_perf - caps->lowest_perf;
+		offset = caps->nominal_freq - div64_u64(caps->nominal_perf * mul, div);
 	} else {
 		if (!max_khz)
 			max_khz = cppc_get_dmi_max_khz();
 		mul = max_khz;
 		div = caps->highest_perf;
 	}
-	return (u64)perf * mul / div;
+
+	retval = offset + div64_u64(perf * mul, div);
+	if (retval >= 0)
+		return retval;
+	return 0;
 }
 
 static unsigned int cppc_cpufreq_khz_to_perf(struct cppc_cpudata *cpu_data,
 					     unsigned int freq)
 {
 	struct cppc_perf_caps *caps = &cpu_data->perf_caps;
+	s64 retval, offset = 0;
 	static u64 max_khz;
 	u64  mul, div;
 
 	if (caps->lowest_freq && caps->nominal_freq) {
-		if (freq >= caps->nominal_freq) {
-			mul = caps->nominal_perf;
-			div = caps->nominal_freq;
-		} else {
-			mul = caps->lowest_perf;
-			div = caps->lowest_freq;
-		}
+		mul = caps->nominal_perf - caps->lowest_perf;
+		div = caps->nominal_freq - caps->lowest_freq;
+		offset = caps->nominal_perf - div64_u64(caps->nominal_freq * mul, div);
 	} else {
 		if (!max_khz)
 			max_khz = cppc_get_dmi_max_khz();
@@ -356,7 +352,10 @@ static unsigned int cppc_cpufreq_khz_to_perf(struct cppc_cpudata *cpu_data,
 		div = max_khz;
 	}
 
-	return (u64)freq * mul / div;
+	retval = offset + div64_u64(freq * mul, div);
+	if (retval >= 0)
+		return retval;
+	return 0;
 }
 
 static int cppc_cpufreq_set_target(struct cpufreq_policy *policy,
diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
index 19ac95c0098f..7f72b3f4cd1a 100644
--- a/drivers/dma/sh/shdma-base.c
+++ b/drivers/dma/sh/shdma-base.c
@@ -115,10 +115,8 @@ static dma_cookie_t shdma_tx_submit(struct dma_async_tx_descriptor *tx)
 		ret = pm_runtime_get(schan->dev);
 
 		spin_unlock_irq(&schan->chan_lock);
-		if (ret < 0) {
+		if (ret < 0)
 			dev_err(schan->dev, "%s(): GET = %d\n", __func__, ret);
-			pm_runtime_put(schan->dev);
-		}
 
 		pm_runtime_barrier(schan->dev);
 
diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 358f0ad9d0f8..91628edad2c6 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -1368,6 +1368,16 @@ static int gpiochip_to_irq(struct gpio_chip *gc, unsigned int offset)
 {
 	struct irq_domain *domain = gc->irq.domain;
 
+#ifdef CONFIG_GPIOLIB_IRQCHIP
+	/*
+	 * Avoid race condition with other code, which tries to lookup
+	 * an IRQ before the irqchip has been properly registered,
+	 * i.e. while gpiochip is still being brought up.
+	 */
+	if (!gc->irq.initialized)
+		return -EPROBE_DEFER;
+#endif
+
 	if (!gpiochip_irqchip_irq_valid(gc, offset))
 		return -ENXIO;
 
@@ -1552,6 +1562,15 @@ static int gpiochip_add_irqchip(struct gpio_chip *gc,
 
 	acpi_gpiochip_request_interrupts(gc);
 
+	/*
+	 * Using barrier() here to prevent compiler from reordering
+	 * gc->irq.initialized before initialization of above
+	 * GPIO chip irq members.
+	 */
+	barrier();
+
+	gc->irq.initialized = true;
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 913f9eaa9cd6..aa823f154199 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1508,6 +1508,7 @@ int amdgpu_cs_fence_to_handle_ioctl(struct drm_device *dev, void *data,
 		return 0;
 
 	default:
+		dma_fence_put(fence);
 		return -EINVAL;
 	}
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
index 1916ec84dd71..e7845df6cad2 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gfx.c
@@ -266,7 +266,7 @@ static int amdgpu_gfx_kiq_acquire(struct amdgpu_device *adev,
 		    * adev->gfx.mec.num_pipe_per_mec
 		    * adev->gfx.mec.num_queue_per_pipe;
 
-	while (queue_bit-- >= 0) {
+	while (--queue_bit >= 0) {
 		if (test_bit(queue_bit, adev->gfx.mec.queue_bitmap))
 			continue;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 01a78c786536..d62b770cc9dc 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1343,7 +1343,8 @@ void amdgpu_bo_release_notify(struct ttm_buffer_object *bo)
 	    !(abo->flags & AMDGPU_GEM_CREATE_VRAM_WIPE_ON_RELEASE))
 		return;
 
-	dma_resv_lock(bo->base.resv, NULL);
+	if (WARN_ON_ONCE(!dma_resv_trylock(bo->base.resv)))
+		return;
 
 	r = amdgpu_fill_buffer(abo, AMDGPU_POISON, bo->base.resv, &fence);
 	if (!WARN_ON(r)) {
diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index 3d18aab88b4e..54b405fc600d 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -601,8 +601,8 @@ static void vcn_v3_0_mc_resume_dpg_mode(struct amdgpu_device *adev, int inst_idx
 			AMDGPU_GPU_PAGE_ALIGN(sizeof(struct amdgpu_fw_shared)), 0, indirect);
 
 	/* VCN global tiling registers */
-	WREG32_SOC15_DPG_MODE(0, SOC15_DPG_MODE_OFFSET(
-		UVD, 0, mmUVD_GFX10_ADDR_CONFIG), adev->gfx.config.gb_addr_config, 0, indirect);
+	WREG32_SOC15_DPG_MODE(inst_idx, SOC15_DPG_MODE_OFFSET(
+		UVD, inst_idx, mmUVD_GFX10_ADDR_CONFIG), adev->gfx.config.gb_addr_config, 0, indirect);
 }
 
 static void vcn_v3_0_disable_static_power_gating(struct amdgpu_device *adev, int inst)
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
index 86afd37b098d..6688129df240 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_chardev.c
@@ -1807,13 +1807,9 @@ static int kfd_ioctl_svm(struct file *filep, struct kfd_process *p, void *data)
 	if (!args->start_addr || !args->size)
 		return -EINVAL;
 
-	mutex_lock(&p->mutex);
-
 	r = svm_ioctl(p, args->op, args->start_addr, args->size, args->nattr,
 		      args->attrs);
 
-	mutex_unlock(&p->mutex);
-
 	return r;
 }
 #else
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
index c33d689f29e8..e574aa32a111 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_crat.c
@@ -1563,7 +1563,7 @@ int kfd_create_crat_image_acpi(void **crat_image, size_t *size)
 	/* Fetch the CRAT table from ACPI */
 	status = acpi_get_table(CRAT_SIGNATURE, 0, &crat_table);
 	if (status == AE_NOT_FOUND) {
-		pr_warn("CRAT table not found\n");
+		pr_info("CRAT table not found\n");
 		return -ENODATA;
 	} else if (ACPI_FAILURE(status)) {
 		const char *err = acpi_format_exception(status);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
index ed4bc5f844ce..766b3660c8c8 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_smi_events.c
@@ -270,15 +270,6 @@ int kfd_smi_event_open(struct kfd_dev *dev, uint32_t *fd)
 		return ret;
 	}
 
-	ret = anon_inode_getfd(kfd_smi_name, &kfd_smi_ev_fops, (void *)client,
-			       O_RDWR);
-	if (ret < 0) {
-		kfifo_free(&client->fifo);
-		kfree(client);
-		return ret;
-	}
-	*fd = ret;
-
 	init_waitqueue_head(&client->wait_queue);
 	spin_lock_init(&client->lock);
 	client->events = 0;
@@ -288,5 +279,20 @@ int kfd_smi_event_open(struct kfd_dev *dev, uint32_t *fd)
 	list_add_rcu(&client->list, &dev->smi_clients);
 	spin_unlock(&dev->smi_lock);
 
+	ret = anon_inode_getfd(kfd_smi_name, &kfd_smi_ev_fops, (void *)client,
+			       O_RDWR);
+	if (ret < 0) {
+		spin_lock(&dev->smi_lock);
+		list_del_rcu(&client->list);
+		spin_unlock(&dev->smi_lock);
+
+		synchronize_rcu();
+
+		kfifo_free(&client->fifo);
+		kfree(client);
+		return ret;
+	}
+	*fd = ret;
+
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index b9859e52ad92..7e9e2eb85eca 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3522,7 +3522,7 @@ static u32 convert_brightness_to_user(const struct amdgpu_dm_backlight_caps *cap
 				 max - min);
 }
 
-static int amdgpu_dm_backlight_set_level(struct amdgpu_display_manager *dm,
+static void amdgpu_dm_backlight_set_level(struct amdgpu_display_manager *dm,
 					 int bl_idx,
 					 u32 user_brightness)
 {
@@ -3550,7 +3550,8 @@ static int amdgpu_dm_backlight_set_level(struct amdgpu_display_manager *dm,
 			DRM_DEBUG("DM: Failed to update backlight on eDP[%d]\n", bl_idx);
 	}
 
-	return rc ? 0 : 1;
+	if (rc)
+		dm->actual_brightness[bl_idx] = user_brightness;
 }
 
 static int amdgpu_dm_backlight_update_status(struct backlight_device *bd)
@@ -9316,7 +9317,7 @@ static void amdgpu_dm_atomic_commit_tail(struct drm_atomic_state *state)
 	/* restore the backlight level */
 	for (i = 0; i < dm->num_of_edps; i++) {
 		if (dm->backlight_dev[i] &&
-		    (amdgpu_dm_backlight_get_level(dm, i) != dm->brightness[i]))
+		    (dm->actual_brightness[i] != dm->brightness[i]))
 			amdgpu_dm_backlight_set_level(dm, i, dm->brightness[i]);
 	}
 #endif
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
index d1d353a7c77d..46d6e65f6bd4 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -446,6 +446,12 @@ struct amdgpu_display_manager {
 	 * cached backlight values.
 	 */
 	u32 brightness[AMDGPU_DM_MAX_NUM_EDP];
+	/**
+	 * @actual_brightness:
+	 *
+	 * last successfully applied backlight values.
+	 */
+	u32 actual_brightness[AMDGPU_DM_MAX_NUM_EDP];
 };
 
 enum dsc_clock_force_state {
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
index e94ddd5e7b63..5c9f5214bc4e 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -229,8 +229,10 @@ static ssize_t dp_link_settings_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -388,8 +390,10 @@ static ssize_t dp_phy_settings_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user((*(rd_buf + result)), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -1316,8 +1320,10 @@ static ssize_t dp_dsc_clock_en_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -1333,8 +1339,10 @@ static ssize_t dp_dsc_clock_en_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -1503,8 +1511,10 @@ static ssize_t dp_dsc_slice_width_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -1520,8 +1530,10 @@ static ssize_t dp_dsc_slice_width_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -1688,8 +1700,10 @@ static ssize_t dp_dsc_slice_height_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -1705,8 +1719,10 @@ static ssize_t dp_dsc_slice_height_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -1869,8 +1885,10 @@ static ssize_t dp_dsc_bits_per_pixel_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -1886,8 +1904,10 @@ static ssize_t dp_dsc_bits_per_pixel_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -2045,8 +2065,10 @@ static ssize_t dp_dsc_pic_width_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -2062,8 +2084,10 @@ static ssize_t dp_dsc_pic_width_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -2102,8 +2126,10 @@ static ssize_t dp_dsc_pic_height_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -2119,8 +2145,10 @@ static ssize_t dp_dsc_pic_height_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -2174,8 +2202,10 @@ static ssize_t dp_dsc_chunk_size_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -2191,8 +2221,10 @@ static ssize_t dp_dsc_chunk_size_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -2246,8 +2278,10 @@ static ssize_t dp_dsc_slice_bpg_offset_read(struct file *f, char __user *buf,
 				break;
 	}
 
-	if (!pipe_ctx)
+	if (!pipe_ctx) {
+		kfree(rd_buf);
 		return -ENXIO;
+	}
 
 	dsc = pipe_ctx->stream_res.dsc;
 	if (dsc)
@@ -2263,8 +2297,10 @@ static ssize_t dp_dsc_slice_bpg_offset_read(struct file *f, char __user *buf,
 			break;
 
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 
 		buf += 1;
 		size -= 1;
@@ -3254,8 +3290,10 @@ static ssize_t dcc_en_bits_read(
 	dc->hwss.get_dcc_en_bits(dc, dcc_en_bits);
 
 	rd_buf = kcalloc(rd_buf_size, sizeof(char), GFP_KERNEL);
-	if (!rd_buf)
+	if (!rd_buf) {
+		kfree(dcc_en_bits);
 		return -ENOMEM;
+	}
 
 	for (i = 0; i < num_pipes; i++)
 		offset += snprintf(rd_buf + offset, rd_buf_size - offset,
@@ -3268,8 +3306,10 @@ static ssize_t dcc_en_bits_read(
 		if (*pos >= rd_buf_size)
 			break;
 		r = put_user(*(rd_buf + result), buf);
-		if (r)
+		if (r) {
+			kfree(rd_buf);
 			return r; /* r = -EFAULT */
+		}
 		buf += 1;
 		size -= 1;
 		*pos += 1;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
index 70a554f1e725..7072fb2ec07f 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -74,10 +74,8 @@ bool amdgpu_dm_link_setup_psr(struct dc_stream_state *stream)
 
 	link = stream->link;
 
-	psr_config.psr_version = link->dpcd_caps.psr_caps.psr_version;
-
-	if (psr_config.psr_version > 0) {
-		psr_config.psr_exit_link_training_required = 0x1;
+	if (link->psr_settings.psr_version != DC_PSR_VERSION_UNSUPPORTED) {
+		psr_config.psr_version = link->psr_settings.psr_version;
 		psr_config.psr_frame_capture_indication_req = 0;
 		psr_config.psr_rfb_setup_time = 0x37;
 		psr_config.psr_sdp_transmit_line_num_deadline = 0x20;
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
index 7ae409f7dcf8..108f3854cd2a 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_resource.c
@@ -1599,6 +1599,9 @@ static bool are_stream_backends_same(
 	if (is_timing_changed(stream_a, stream_b))
 		return false;
 
+	if (stream_a->signal != stream_b->signal)
+		return false;
+
 	if (stream_a->dpms_off != stream_b->dpms_off)
 		return false;
 
diff --git a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
index 92a308ad1213..fbbdf9976183 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -874,7 +874,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 		.clock_trace = true,
 		.disable_pplib_clock_request = true,
 		.min_disp_clk_khz = 100000,
-		.pipe_split_policy = MPC_SPLIT_DYNAMIC,
+		.pipe_split_policy = MPC_SPLIT_AVOID_MULT_DISP,
 		.force_single_disp_pipe_split = false,
 		.disable_dcc = DCC_ENABLE,
 		.vsr_support = true,
diff --git a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
index 08362d506534..a68496b3f929 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_dpm.c
@@ -1045,6 +1045,17 @@ bool amdgpu_dpm_is_baco_supported(struct amdgpu_device *adev)
 
 	if (!pp_funcs || !pp_funcs->get_asic_baco_capability)
 		return false;
+	/* Don't use baco for reset in S3.
+	 * This is a workaround for some platforms
+	 * where entering BACO during suspend
+	 * seems to cause reboots or hangs.
+	 * This might be related to the fact that BACO controls
+	 * power to the whole GPU including devices like audio and USB.
+	 * Powering down/up everything may adversely affect these other
+	 * devices.  Needs more investigation.
+	 */
+	if (adev->in_s3)
+		return false;
 
 	if (pp_funcs->get_asic_baco_capability(pp_handle, &baco_cap))
 		return false;
diff --git a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
index 1f406f21b452..cf74621f94a7 100644
--- a/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
+++ b/drivers/gpu/drm/amd/pm/powerplay/hwmgr/smu10_hwmgr.c
@@ -773,13 +773,13 @@ static int smu10_dpm_force_dpm_level(struct pp_hwmgr *hwmgr,
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetHardMinFclkByFreq,
 						hwmgr->display_config->num_display > 3 ?
-						data->clock_vol_info.vdd_dep_on_fclk->entries[0].clk :
+						(data->clock_vol_info.vdd_dep_on_fclk->entries[0].clk / 100) :
 						min_mclk,
 						NULL);
 
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetHardMinSocclkByFreq,
-						data->clock_vol_info.vdd_dep_on_socclk->entries[0].clk,
+						data->clock_vol_info.vdd_dep_on_socclk->entries[0].clk / 100,
 						NULL);
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetHardMinVcn,
@@ -792,11 +792,11 @@ static int smu10_dpm_force_dpm_level(struct pp_hwmgr *hwmgr,
 						NULL);
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetSoftMaxFclkByFreq,
-						data->clock_vol_info.vdd_dep_on_fclk->entries[index_fclk].clk,
+						data->clock_vol_info.vdd_dep_on_fclk->entries[index_fclk].clk / 100,
 						NULL);
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetSoftMaxSocclkByFreq,
-						data->clock_vol_info.vdd_dep_on_socclk->entries[index_socclk].clk,
+						data->clock_vol_info.vdd_dep_on_socclk->entries[index_socclk].clk / 100,
 						NULL);
 		smum_send_msg_to_smc_with_parameter(hwmgr,
 						PPSMC_MSG_SetSoftMaxVcn,
diff --git a/drivers/gpu/drm/bridge/nwl-dsi.c b/drivers/gpu/drm/bridge/nwl-dsi.c
index 6e484d836cfe..691039aba87f 100644
--- a/drivers/gpu/drm/bridge/nwl-dsi.c
+++ b/drivers/gpu/drm/bridge/nwl-dsi.c
@@ -861,18 +861,19 @@ nwl_dsi_bridge_mode_set(struct drm_bridge *bridge,
 	memcpy(&dsi->mode, adjusted_mode, sizeof(dsi->mode));
 	drm_mode_debug_printmodeline(adjusted_mode);
 
-	pm_runtime_get_sync(dev);
+	if (pm_runtime_resume_and_get(dev) < 0)
+		return;
 
 	if (clk_prepare_enable(dsi->lcdif_clk) < 0)
-		return;
+		goto runtime_put;
 	if (clk_prepare_enable(dsi->core_clk) < 0)
-		return;
+		goto runtime_put;
 
 	/* Step 1 from DSI reset-out instructions */
 	ret = reset_control_deassert(dsi->rst_pclk);
 	if (ret < 0) {
 		DRM_DEV_ERROR(dev, "Failed to deassert PCLK: %d\n", ret);
-		return;
+		goto runtime_put;
 	}
 
 	/* Step 2 from DSI reset-out instructions */
@@ -882,13 +883,18 @@ nwl_dsi_bridge_mode_set(struct drm_bridge *bridge,
 	ret = reset_control_deassert(dsi->rst_esc);
 	if (ret < 0) {
 		DRM_DEV_ERROR(dev, "Failed to deassert ESC: %d\n", ret);
-		return;
+		goto runtime_put;
 	}
 	ret = reset_control_deassert(dsi->rst_byte);
 	if (ret < 0) {
 		DRM_DEV_ERROR(dev, "Failed to deassert BYTE: %d\n", ret);
-		return;
+		goto runtime_put;
 	}
+
+	return;
+
+runtime_put:
+	pm_runtime_put_sync(dev);
 }
 
 static void
diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 448c2f2d803a..f5ab891731d0 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -166,6 +166,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "MicroPC"),
 		},
 		.driver_data = (void *)&lcd720x1280_rightside_up,
+	}, {	/* GPD Win Max */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "GPD"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "G1619-01"),
+		},
+		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/*
 		 * GPD Pocket, note that the the DMI data is less generic then
 		 * it seems, devices with a board-vendor of "AMI Corporation"
diff --git a/drivers/gpu/drm/imx/dw_hdmi-imx.c b/drivers/gpu/drm/imx/dw_hdmi-imx.c
index 87428fb23d9f..a2277a0d6d06 100644
--- a/drivers/gpu/drm/imx/dw_hdmi-imx.c
+++ b/drivers/gpu/drm/imx/dw_hdmi-imx.c
@@ -222,6 +222,7 @@ static int dw_hdmi_imx_probe(struct platform_device *pdev)
 	struct device_node *np = pdev->dev.of_node;
 	const struct of_device_id *match = of_match_node(dw_hdmi_imx_dt_ids, np);
 	struct imx_hdmi *hdmi;
+	int ret;
 
 	hdmi = devm_kzalloc(&pdev->dev, sizeof(*hdmi), GFP_KERNEL);
 	if (!hdmi)
@@ -243,10 +244,15 @@ static int dw_hdmi_imx_probe(struct platform_device *pdev)
 	hdmi->bridge = of_drm_find_bridge(np);
 	if (!hdmi->bridge) {
 		dev_err(hdmi->dev, "Unable to find bridge\n");
+		dw_hdmi_remove(hdmi->hdmi);
 		return -ENODEV;
 	}
 
-	return component_add(&pdev->dev, &dw_hdmi_imx_ops);
+	ret = component_add(&pdev->dev, &dw_hdmi_imx_ops);
+	if (ret)
+		dw_hdmi_remove(hdmi->hdmi);
+
+	return ret;
 }
 
 static int dw_hdmi_imx_remove(struct platform_device *pdev)
diff --git a/drivers/gpu/drm/imx/imx-ldb.c b/drivers/gpu/drm/imx/imx-ldb.c
index e5078d03020d..fb0e951248f6 100644
--- a/drivers/gpu/drm/imx/imx-ldb.c
+++ b/drivers/gpu/drm/imx/imx-ldb.c
@@ -572,6 +572,8 @@ static int imx_ldb_panel_ddc(struct device *dev,
 		edidp = of_get_property(child, "edid", &edid_len);
 		if (edidp) {
 			channel->edid = kmemdup(edidp, edid_len, GFP_KERNEL);
+			if (!channel->edid)
+				return -ENOMEM;
 		} else if (!channel->panel) {
 			/* fallback to display-timings node */
 			ret = of_get_drm_display_mode(child,
diff --git a/drivers/gpu/drm/imx/parallel-display.c b/drivers/gpu/drm/imx/parallel-display.c
index 06cb1a59b9bc..63ba2ad84679 100644
--- a/drivers/gpu/drm/imx/parallel-display.c
+++ b/drivers/gpu/drm/imx/parallel-display.c
@@ -75,8 +75,10 @@ static int imx_pd_connector_get_modes(struct drm_connector *connector)
 		ret = of_get_drm_display_mode(np, &imxpd->mode,
 					      &imxpd->bus_flags,
 					      OF_USE_NATIVE_MODE);
-		if (ret)
+		if (ret) {
+			drm_mode_destroy(connector->dev, mode);
 			return ret;
+		}
 
 		drm_mode_copy(mode, &imxpd->mode);
 		mode->type |= DRM_MODE_TYPE_DRIVER | DRM_MODE_TYPE_PREFERRED;
diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index dc85974c7897..eea679a52e86 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1909,7 +1909,7 @@ int msm_dsi_host_init(struct msm_dsi *msm_dsi)
 
 	/* do not autoenable, will be enabled later */
 	ret = devm_request_irq(&pdev->dev, msm_host->irq, dsi_host_irq,
-			IRQF_TRIGGER_HIGH | IRQF_ONESHOT | IRQF_NO_AUTOEN,
+			IRQF_TRIGGER_HIGH | IRQF_NO_AUTOEN,
 			"dsi_isr", msm_host);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "failed to request IRQ%u: %d\n",
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c
index e1772211b0a4..612310d5d481 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gm20b.c
@@ -216,6 +216,7 @@ gm20b_pmu = {
 	.intr = gt215_pmu_intr,
 	.recv = gm20b_pmu_recv,
 	.initmsg = gm20b_pmu_initmsg,
+	.reset = gf100_pmu_reset,
 };
 
 #if IS_ENABLED(CONFIG_ARCH_TEGRA_210_SOC)
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c
index 6bf7fc1bd1e3..1a6f9c3af5ec 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp102.c
@@ -23,7 +23,7 @@
  */
 #include "priv.h"
 
-static void
+void
 gp102_pmu_reset(struct nvkm_pmu *pmu)
 {
 	struct nvkm_device *device = pmu->subdev.device;
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c
index ba1583bb618b..94cfb1791af6 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/gp10b.c
@@ -83,6 +83,7 @@ gp10b_pmu = {
 	.intr = gt215_pmu_intr,
 	.recv = gm20b_pmu_recv,
 	.initmsg = gm20b_pmu_initmsg,
+	.reset = gp102_pmu_reset,
 };
 
 #if IS_ENABLED(CONFIG_ARCH_TEGRA_210_SOC)
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h
index bcaade758ff7..21abf31f4442 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/pmu/priv.h
@@ -41,6 +41,7 @@ int gt215_pmu_send(struct nvkm_pmu *, u32[2], u32, u32, u32, u32);
 
 bool gf100_pmu_enabled(struct nvkm_pmu *);
 void gf100_pmu_reset(struct nvkm_pmu *);
+void gp102_pmu_reset(struct nvkm_pmu *pmu);
 
 void gk110_pmu_pgob(struct nvkm_pmu *, bool);
 
diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9341.c b/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
index 2c3378a259b1..e1542451ef9d 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
@@ -612,8 +612,10 @@ static int ili9341_dbi_probe(struct spi_device *spi, struct gpio_desc *dc,
 	int ret;
 
 	vcc = devm_regulator_get_optional(dev, "vcc");
-	if (IS_ERR(vcc))
+	if (IS_ERR(vcc)) {
 		dev_err(dev, "get optional vcc failed\n");
+		vcc = NULL;
+	}
 
 	dbidev = devm_drm_dev_alloc(dev, &ili9341_dbi_driver,
 				    struct mipi_dbi_dev, drm);
diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
index 772b5831bcc6..805d6f6cba0e 100644
--- a/drivers/gpu/drm/v3d/v3d_gem.c
+++ b/drivers/gpu/drm/v3d/v3d_gem.c
@@ -625,7 +625,7 @@ v3d_submit_cl_ioctl(struct drm_device *dev, void *data,
 
 		if (!render->base.perfmon) {
 			ret = -ENOENT;
-			goto fail;
+			goto fail_perfmon;
 		}
 	}
 
@@ -678,6 +678,7 @@ v3d_submit_cl_ioctl(struct drm_device *dev, void *data,
 
 fail_unreserve:
 	mutex_unlock(&v3d->sched_lock);
+fail_perfmon:
 	drm_gem_unlock_reservations(last_job->bo,
 				    last_job->bo_count, &acquire_ctx);
 fail:
@@ -854,7 +855,7 @@ v3d_submit_csd_ioctl(struct drm_device *dev, void *data,
 						     args->perfmon_id);
 		if (!job->base.perfmon) {
 			ret = -ENOENT;
-			goto fail;
+			goto fail_perfmon;
 		}
 	}
 
@@ -886,6 +887,7 @@ v3d_submit_csd_ioctl(struct drm_device *dev, void *data,
 
 fail_unreserve:
 	mutex_unlock(&v3d->sched_lock);
+fail_perfmon:
 	drm_gem_unlock_reservations(clean_job->bo, clean_job->bo_count,
 				    &acquire_ctx);
 fail:
diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
index 142308526ec6..ce76fc382799 100644
--- a/drivers/hv/channel_mgmt.c
+++ b/drivers/hv/channel_mgmt.c
@@ -380,7 +380,7 @@ void vmbus_channel_map_relid(struct vmbus_channel *channel)
 	 * execute:
 	 *
 	 *  (a) In the "normal (i.e., not resuming from hibernation)" path,
-	 *      the full barrier in smp_store_mb() guarantees that the store
+	 *      the full barrier in virt_store_mb() guarantees that the store
 	 *      is propagated to all CPUs before the add_channel_work work
 	 *      is queued.  In turn, add_channel_work is queued before the
 	 *      channel's ring buffer is allocated/initialized and the
@@ -392,14 +392,14 @@ void vmbus_channel_map_relid(struct vmbus_channel *channel)
 	 *      recv_int_page before retrieving the channel pointer from the
 	 *      array of channels.
 	 *
-	 *  (b) In the "resuming from hibernation" path, the smp_store_mb()
+	 *  (b) In the "resuming from hibernation" path, the virt_store_mb()
 	 *      guarantees that the store is propagated to all CPUs before
 	 *      the VMBus connection is marked as ready for the resume event
 	 *      (cf. check_ready_for_resume_event()).  The interrupt handler
 	 *      of the VMBus driver and vmbus_chan_sched() can not run before
 	 *      vmbus_bus_resume() has completed execution (cf. resume_noirq).
 	 */
-	smp_store_mb(
+	virt_store_mb(
 		vmbus_connection.channels[channel->offermsg.child_relid],
 		channel);
 }
diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index 44bd0b6ff505..a939ca1a8d54 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -2776,10 +2776,15 @@ static void __exit vmbus_exit(void)
 	if (ms_hyperv.misc_features & HV_FEATURE_GUEST_CRASH_MSR_AVAILABLE) {
 		kmsg_dump_unregister(&hv_kmsg_dumper);
 		unregister_die_notifier(&hyperv_die_block);
-		atomic_notifier_chain_unregister(&panic_notifier_list,
-						 &hyperv_panic_block);
 	}
 
+	/*
+	 * The panic notifier is always registered, hence we should
+	 * also unconditionally unregister it here as well.
+	 */
+	atomic_notifier_chain_unregister(&panic_notifier_list,
+					 &hyperv_panic_block);
+
 	free_page((unsigned long)hv_panic_page);
 	unregister_sysctl_table(hv_ctl_table_hdr);
 	hv_ctl_table_hdr = NULL;
diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 35f0d5e7533d..1c107d6d03b9 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -2824,6 +2824,7 @@ static int cm_dreq_handler(struct cm_work *work)
 	switch (cm_id_priv->id.state) {
 	case IB_CM_REP_SENT:
 	case IB_CM_DREQ_SENT:
+	case IB_CM_MRA_REP_RCVD:
 		ib_cancel_mad(cm_id_priv->msg);
 		break;
 	case IB_CM_ESTABLISHED:
@@ -2831,8 +2832,6 @@ static int cm_dreq_handler(struct cm_work *work)
 		    cm_id_priv->id.lap_state == IB_CM_MRA_LAP_RCVD)
 			ib_cancel_mad(cm_id_priv->msg);
 		break;
-	case IB_CM_MRA_REP_RCVD:
-		break;
 	case IB_CM_TIMEWAIT:
 		atomic_long_inc(&work->port->counters[CM_RECV_DUPLICATES]
 						     [CM_DREQ_COUNTER]);
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 876cc78a22cc..7333646021bb 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -80,6 +80,9 @@ void hfi1_mmu_rb_unregister(struct mmu_rb_handler *handler)
 	unsigned long flags;
 	struct list_head del_list;
 
+	/* Prevent freeing of mm until we are completely finished. */
+	mmgrab(handler->mn.mm);
+
 	/* Unregister first so we don't get any more notifications. */
 	mmu_notifier_unregister(&handler->mn, handler->mn.mm);
 
@@ -102,6 +105,9 @@ void hfi1_mmu_rb_unregister(struct mmu_rb_handler *handler)
 
 	do_remove(handler, &del_list);
 
+	/* Now the mm may be freed. */
+	mmdrop(handler->mn.mm);
+
 	kfree(handler);
 }
 
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 7bb1b9d0941c..cf203f879d34 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -536,8 +536,10 @@ static void __cache_work_func(struct mlx5_cache_ent *ent)
 		spin_lock_irq(&ent->lock);
 		if (ent->disabled)
 			goto out;
-		if (need_delay)
+		if (need_delay) {
 			queue_delayed_work(cache->wq, &ent->dwork, 300 * HZ);
+			goto out;
+		}
 		remove_cache_mr_locked(ent);
 		queue_adjust_cache_locked(ent);
 	}
@@ -633,6 +635,7 @@ static void mlx5_mr_cache_free(struct mlx5_ib_dev *dev, struct mlx5_ib_mr *mr)
 {
 	struct mlx5_cache_ent *ent = mr->cache_ent;
 
+	WRITE_ONCE(dev->cache.last_add, jiffies);
 	spin_lock_irq(&ent->lock);
 	list_add_tail(&mr->list, &ent->head);
 	ent->available_mrs++;
diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index ae50b56e8913..8ef112f883a7 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -3190,7 +3190,11 @@ void rvt_ruc_loopback(struct rvt_qp *sqp)
 	spin_lock_irqsave(&sqp->s_lock, flags);
 	rvt_send_complete(sqp, wqe, send_status);
 	if (sqp->ibqp.qp_type == IB_QPT_RC) {
-		int lastwqe = rvt_error_qp(sqp, IB_WC_WR_FLUSH_ERR);
+		int lastwqe;
+
+		spin_lock(&sqp->r_lock);
+		lastwqe = rvt_error_qp(sqp, IB_WC_WR_FLUSH_ERR);
+		spin_unlock(&sqp->r_lock);
 
 		sqp->s_flags &= ~RVT_S_BUSY;
 		spin_unlock_irqrestore(&sqp->s_lock, flags);
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index a388e318f86e..430315135cff 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -1552,6 +1552,7 @@ static irqreturn_t arm_smmu_evtq_thread(int irq, void *dev)
 				dev_info(smmu->dev, "\t0x%016llx\n",
 					 (unsigned long long)evt[i]);
 
+			cond_resched();
 		}
 
 		/*
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 91749654fd49..be60f6f3a265 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1661,7 +1661,7 @@ static struct iommu_device *omap_iommu_probe_device(struct device *dev)
 	num_iommus = of_property_count_elems_of_size(dev->of_node, "iommus",
 						     sizeof(phandle));
 	if (num_iommus < 0)
-		return 0;
+		return ERR_PTR(-ENODEV);
 
 	arch_data = kcalloc(num_iommus + 1, sizeof(*arch_data), GFP_KERNEL);
 	if (!arch_data)
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 0cb584d9815b..fc1bfffc468f 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3007,18 +3007,12 @@ static int __init allocate_lpi_tables(void)
 	return 0;
 }
 
-static u64 its_clear_vpend_valid(void __iomem *vlpi_base, u64 clr, u64 set)
+static u64 read_vpend_dirty_clear(void __iomem *vlpi_base)
 {
 	u32 count = 1000000;	/* 1s! */
 	bool clean;
 	u64 val;
 
-	val = gicr_read_vpendbaser(vlpi_base + GICR_VPENDBASER);
-	val &= ~GICR_VPENDBASER_Valid;
-	val &= ~clr;
-	val |= set;
-	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
-
 	do {
 		val = gicr_read_vpendbaser(vlpi_base + GICR_VPENDBASER);
 		clean = !(val & GICR_VPENDBASER_Dirty);
@@ -3029,10 +3023,26 @@ static u64 its_clear_vpend_valid(void __iomem *vlpi_base, u64 clr, u64 set)
 		}
 	} while (!clean && count);
 
-	if (unlikely(val & GICR_VPENDBASER_Dirty)) {
+	if (unlikely(!clean))
 		pr_err_ratelimited("ITS virtual pending table not cleaning\n");
+
+	return val;
+}
+
+static u64 its_clear_vpend_valid(void __iomem *vlpi_base, u64 clr, u64 set)
+{
+	u64 val;
+
+	/* Make sure we wait until the RD is done with the initial scan */
+	val = read_vpend_dirty_clear(vlpi_base);
+	val &= ~GICR_VPENDBASER_Valid;
+	val &= ~clr;
+	val |= set;
+	gicr_write_vpendbaser(val, vlpi_base + GICR_VPENDBASER);
+
+	val = read_vpend_dirty_clear(vlpi_base);
+	if (unlikely(val & GICR_VPENDBASER_Dirty))
 		val |= GICR_VPENDBASER_PendingLast;
-	}
 
 	return val;
 }
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 7bbccb13b896..1269284461da 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -206,11 +206,11 @@ static inline void __iomem *gic_dist_base(struct irq_data *d)
 	}
 }
 
-static void gic_do_wait_for_rwp(void __iomem *base)
+static void gic_do_wait_for_rwp(void __iomem *base, u32 bit)
 {
 	u32 count = 1000000;	/* 1s! */
 
-	while (readl_relaxed(base + GICD_CTLR) & GICD_CTLR_RWP) {
+	while (readl_relaxed(base + GICD_CTLR) & bit) {
 		count--;
 		if (!count) {
 			pr_err_ratelimited("RWP timeout, gone fishing\n");
@@ -224,13 +224,13 @@ static void gic_do_wait_for_rwp(void __iomem *base)
 /* Wait for completion of a distributor change */
 static void gic_dist_wait_for_rwp(void)
 {
-	gic_do_wait_for_rwp(gic_data.dist_base);
+	gic_do_wait_for_rwp(gic_data.dist_base, GICD_CTLR_RWP);
 }
 
 /* Wait for completion of a redistributor change */
 static void gic_redist_wait_for_rwp(void)
 {
-	gic_do_wait_for_rwp(gic_data_rdist_rd_base());
+	gic_do_wait_for_rwp(gic_data_rdist_rd_base(), GICR_CTLR_RWP);
 }
 
 #ifdef CONFIG_ARM64
@@ -1466,6 +1466,12 @@ static int gic_irq_domain_translate(struct irq_domain *d,
 		if(fwspec->param_count != 2)
 			return -EINVAL;
 
+		if (fwspec->param[0] < 16) {
+			pr_err(FW_BUG "Illegal GSI%d translation request\n",
+			       fwspec->param[0]);
+			return -EINVAL;
+		}
+
 		*hwirq = fwspec->param[0];
 		*type = fwspec->param[1];
 
diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
index 5f22c9d65e57..99077f30f699 100644
--- a/drivers/irqchip/irq-gic.c
+++ b/drivers/irqchip/irq-gic.c
@@ -1085,6 +1085,12 @@ static int gic_irq_domain_translate(struct irq_domain *d,
 		if(fwspec->param_count != 2)
 			return -EINVAL;
 
+		if (fwspec->param[0] < 16) {
+			pr_err(FW_BUG "Illegal GSI%d translation request\n",
+			       fwspec->param[0]);
+			return -EINVAL;
+		}
+
 		*hwirq = fwspec->param[0];
 		*type = fwspec->param[1];
 
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 21fe8652b095..901abd6dea41 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -18,6 +18,7 @@
 #include <linux/dm-ioctl.h>
 #include <linux/hdreg.h>
 #include <linux/compat.h>
+#include <linux/nospec.h>
 
 #include <linux/uaccess.h>
 #include <linux/ima.h>
@@ -1788,6 +1789,7 @@ static ioctl_fn lookup_ioctl(unsigned int cmd, int *ioctl_flags)
 	if (unlikely(cmd >= ARRAY_SIZE(_ioctls)))
 		return NULL;
 
+	cmd = array_index_nospec(cmd, ARRAY_SIZE(_ioctls));
 	*ioctl_flags = _ioctls[cmd].flags;
 	return _ioctls[cmd].fn;
 }
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index a896dea9750e..53a9b16c7b2e 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -500,8 +500,13 @@ static blk_status_t dm_mq_queue_rq(struct blk_mq_hw_ctx *hctx,
 
 	if (unlikely(!ti)) {
 		int srcu_idx;
-		struct dm_table *map = dm_get_live_table(md, &srcu_idx);
+		struct dm_table *map;
 
+		map = dm_get_live_table(md, &srcu_idx);
+		if (unlikely(!map)) {
+			dm_put_live_table(md, srcu_idx);
+			return BLK_STS_RESOURCE;
+		}
 		ti = dm_table_find_target(map, 0);
 		dm_put_live_table(md, srcu_idx);
 	}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 443478a08857..36449422e7e0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1594,15 +1594,10 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
 	struct dm_table *map;
 
 	map = dm_get_live_table(md, &srcu_idx);
-	if (unlikely(!map)) {
-		DMERR_LIMIT("%s: mapping table unavailable, erroring io",
-			    dm_device_name(md));
-		bio_io_error(bio);
-		goto out;
-	}
 
-	/* If suspended, queue this IO for later */
-	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
+	/* If suspended, or map not yet available, queue this IO for later */
+	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags)) ||
+	    unlikely(!map)) {
 		if (bio->bi_opf & REQ_NOWAIT)
 			bio_wouldblock_error(bio);
 		else if (bio->bi_opf & REQ_RAHEAD)
diff --git a/drivers/misc/habanalabs/common/mmu/mmu_v1.c b/drivers/misc/habanalabs/common/mmu/mmu_v1.c
index 0f536f79dd9c..e68e9f71c546 100644
--- a/drivers/misc/habanalabs/common/mmu/mmu_v1.c
+++ b/drivers/misc/habanalabs/common/mmu/mmu_v1.c
@@ -467,7 +467,7 @@ static void hl_mmu_v1_fini(struct hl_device *hdev)
 {
 	/* MMU H/W fini was already done in device hw_fini() */
 
-	if (!ZERO_OR_NULL_PTR(hdev->mmu_priv.hr.mmu_shadow_hop0)) {
+	if (!ZERO_OR_NULL_PTR(hdev->mmu_priv.dr.mmu_shadow_hop0)) {
 		kvfree(hdev->mmu_priv.dr.mmu_shadow_hop0);
 		gen_pool_destroy(hdev->mmu_priv.dr.mmu_pgt_pool);
 
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index b575d0bfd0d6..c4fcb1ad6d4d 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1880,6 +1880,31 @@ static inline bool mmc_blk_rq_error(struct mmc_blk_request *brq)
 	       brq->data.error || brq->cmd.resp[0] & CMD_ERRORS;
 }
 
+static int mmc_spi_err_check(struct mmc_card *card)
+{
+	u32 status = 0;
+	int err;
+
+	/*
+	 * SPI does not have a TRAN state we have to wait on, instead the
+	 * card is ready again when it no longer holds the line LOW.
+	 * We still have to ensure two things here before we know the write
+	 * was successful:
+	 * 1. The card has not disconnected during busy and we actually read our
+	 * own pull-up, thinking it was still connected, so ensure it
+	 * still responds.
+	 * 2. Check for any error bits, in particular R1_SPI_IDLE to catch a
+	 * just reconnected card after being disconnected during busy.
+	 */
+	err = __mmc_send_status(card, &status, 0);
+	if (err)
+		return err;
+	/* All R1 and R2 bits of SPI are errors in our case */
+	if (status)
+		return -EIO;
+	return 0;
+}
+
 static int mmc_blk_busy_cb(void *cb_data, bool *busy)
 {
 	struct mmc_blk_busy_data *data = cb_data;
@@ -1903,9 +1928,16 @@ static int mmc_blk_card_busy(struct mmc_card *card, struct request *req)
 	struct mmc_blk_busy_data cb_data;
 	int err;
 
-	if (mmc_host_is_spi(card->host) || rq_data_dir(req) == READ)
+	if (rq_data_dir(req) == READ)
 		return 0;
 
+	if (mmc_host_is_spi(card->host)) {
+		err = mmc_spi_err_check(card);
+		if (err)
+			mqrq->brq.data.bytes_xfered = 0;
+		return err;
+	}
+
 	cb_data.card = card;
 	cb_data.status = 0;
 	err = __mmc_poll_for_busy(card, MMC_BLK_TIMEOUT_MS, &mmc_blk_busy_cb,
@@ -2344,6 +2376,8 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 	struct mmc_blk_data *md;
 	int devidx, ret;
 	char cap_str[10];
+	bool cache_enabled = false;
+	bool fua_enabled = false;
 
 	devidx = ida_simple_get(&mmc_blk_ida, 0, max_devices, GFP_KERNEL);
 	if (devidx < 0) {
@@ -2425,13 +2459,17 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 			md->flags |= MMC_BLK_CMD23;
 	}
 
-	if (mmc_card_mmc(card) &&
-	    md->flags & MMC_BLK_CMD23 &&
+	if (md->flags & MMC_BLK_CMD23 &&
 	    ((card->ext_csd.rel_param & EXT_CSD_WR_REL_PARAM_EN) ||
 	     card->ext_csd.rel_sectors)) {
 		md->flags |= MMC_BLK_REL_WR;
-		blk_queue_write_cache(md->queue.queue, true, true);
+		fua_enabled = true;
+		cache_enabled = true;
 	}
+	if (mmc_cache_enabled(card->host))
+		cache_enabled  = true;
+
+	blk_queue_write_cache(md->queue.queue, cache_enabled, fua_enabled);
 
 	string_get_size((u64)size, 512, STRING_UNITS_2,
 			cap_str, sizeof(cap_str));
diff --git a/drivers/mmc/host/mmci_stm32_sdmmc.c b/drivers/mmc/host/mmci_stm32_sdmmc.c
index a75d3dd34d18..4cceb9bab036 100644
--- a/drivers/mmc/host/mmci_stm32_sdmmc.c
+++ b/drivers/mmc/host/mmci_stm32_sdmmc.c
@@ -62,8 +62,8 @@ static int sdmmc_idma_validate_data(struct mmci_host *host,
 	 * excepted the last element which has no constraint on idmasize
 	 */
 	for_each_sg(data->sg, sg, data->sg_len - 1, i) {
-		if (!IS_ALIGNED(data->sg->offset, sizeof(u32)) ||
-		    !IS_ALIGNED(data->sg->length, SDMMC_IDMA_BURST)) {
+		if (!IS_ALIGNED(sg->offset, sizeof(u32)) ||
+		    !IS_ALIGNED(sg->length, SDMMC_IDMA_BURST)) {
 			dev_err(mmc_dev(host->mmc),
 				"unaligned scatterlist: ofst:%x length:%d\n",
 				data->sg->offset, data->sg->length);
@@ -71,7 +71,7 @@ static int sdmmc_idma_validate_data(struct mmci_host *host,
 		}
 	}
 
-	if (!IS_ALIGNED(data->sg->offset, sizeof(u32))) {
+	if (!IS_ALIGNED(sg->offset, sizeof(u32))) {
 		dev_err(mmc_dev(host->mmc),
 			"unaligned last scatterlist: ofst:%x length:%d\n",
 			data->sg->offset, data->sg->length);
diff --git a/drivers/mmc/host/renesas_sdhi_core.c b/drivers/mmc/host/renesas_sdhi_core.c
index f5b2684ad805..ae689bf54686 100644
--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -382,10 +382,10 @@ static void renesas_sdhi_hs400_complete(struct mmc_host *mmc)
 			SH_MOBILE_SDHI_SCC_TMPPORT2_HS400OSEL) |
 			sd_scc_read32(host, priv, SH_MOBILE_SDHI_SCC_TMPPORT2));
 
-	/* Set the sampling clock selection range of HS400 mode */
 	sd_scc_write32(host, priv, SH_MOBILE_SDHI_SCC_DTCNTL,
 		       SH_MOBILE_SDHI_SCC_DTCNTL_TAPEN |
-		       0x4 << SH_MOBILE_SDHI_SCC_DTCNTL_TAPNUM_SHIFT);
+		       sd_scc_read32(host, priv,
+				     SH_MOBILE_SDHI_SCC_DTCNTL));
 
 	/* Avoid bad TAP */
 	if (bad_taps & BIT(priv->tap_set)) {
diff --git a/drivers/mmc/host/sdhci-xenon.c b/drivers/mmc/host/sdhci-xenon.c
index 666cee4c7f7c..08e838400b52 100644
--- a/drivers/mmc/host/sdhci-xenon.c
+++ b/drivers/mmc/host/sdhci-xenon.c
@@ -241,16 +241,6 @@ static void xenon_voltage_switch(struct sdhci_host *host)
 {
 	/* Wait for 5ms after set 1.8V signal enable bit */
 	usleep_range(5000, 5500);
-
-	/*
-	 * For some reason the controller's Host Control2 register reports
-	 * the bit representing 1.8V signaling as 0 when read after it was
-	 * written as 1. Subsequent read reports 1.
-	 *
-	 * Since this may cause some issues, do an empty read of the Host
-	 * Control2 register here to circumvent this.
-	 */
-	sdhci_readw(host, SDHCI_HOST_CONTROL2);
 }
 
 static unsigned int xenon_get_max_clock(struct sdhci_host *host)
diff --git a/drivers/net/can/usb/etas_es58x/es58x_fd.c b/drivers/net/can/usb/etas_es58x/es58x_fd.c
index af042aa55f59..26bf4775e884 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_fd.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_fd.c
@@ -171,12 +171,11 @@ static int es58x_fd_rx_event_msg(struct net_device *netdev,
 	const struct es58x_fd_rx_event_msg *rx_event_msg;
 	int ret;
 
+	rx_event_msg = &es58x_fd_urb_cmd->rx_event_msg;
 	ret = es58x_check_msg_len(es58x_dev->dev, *rx_event_msg, msg_len);
 	if (ret)
 		return ret;
 
-	rx_event_msg = &es58x_fd_urb_cmd->rx_event_msg;
-
 	return es58x_rx_err_msg(netdev, rx_event_msg->error_code,
 				rx_event_msg->event_code,
 				get_unaligned_le64(&rx_event_msg->timestamp));
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ce36ee5a250f..8b078c319872 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -3234,6 +3234,7 @@ static int bnxt_alloc_tx_rings(struct bnxt *bp)
 		}
 		qidx = bp->tc_to_qidx[j];
 		ring->queue_id = bp->q_info[qidx].queue_id;
+		spin_lock_init(&txr->xdp_tx_lock);
 		if (i < bp->tx_nr_rings_xdp)
 			continue;
 		if (i % bp->tx_nr_rings_per_tc == (bp->tx_nr_rings_per_tc - 1))
@@ -10246,6 +10247,12 @@ static int __bnxt_open_nic(struct bnxt *bp, bool irq_re_init, bool link_re_init)
 	if (irq_re_init)
 		udp_tunnel_nic_reset_ntf(bp->dev);
 
+	if (bp->tx_nr_rings_xdp < num_possible_cpus()) {
+		if (!static_key_enabled(&bnxt_xdp_locking_key))
+			static_branch_enable(&bnxt_xdp_locking_key);
+	} else if (static_key_enabled(&bnxt_xdp_locking_key)) {
+		static_branch_disable(&bnxt_xdp_locking_key);
+	}
 	set_bit(BNXT_STATE_OPEN, &bp->state);
 	bnxt_enable_int(bp);
 	/* Enable TX queues */
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index ca6fdf03e586..e5874c829226 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -584,7 +584,8 @@ struct nqe_cn {
 #define BNXT_MAX_MTU		9500
 #define BNXT_MAX_PAGE_MODE_MTU	\
 	((unsigned int)PAGE_SIZE - VLAN_ETH_HLEN - NET_IP_ALIGN -	\
-	 XDP_PACKET_HEADROOM)
+	 XDP_PACKET_HEADROOM - \
+	 SKB_DATA_ALIGN((unsigned int)sizeof(struct skb_shared_info)))
 
 #define BNXT_MIN_PKT_SIZE	52
 
@@ -791,6 +792,8 @@ struct bnxt_tx_ring_info {
 	u32			dev_state;
 
 	struct bnxt_ring_struct	tx_ring_struct;
+	/* Synchronize simultaneous xdp_xmit on same ring */
+	spinlock_t		xdp_tx_lock;
 };
 
 #define BNXT_LEGACY_COAL_CMPL_PARAMS					\
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index af7de9ee66cf..0f276ce2d1eb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -2074,9 +2074,7 @@ static int bnxt_set_pauseparam(struct net_device *dev,
 		}
 
 		link_info->autoneg |= BNXT_AUTONEG_FLOW_CTRL;
-		if (bp->hwrm_spec_code >= 0x10201)
-			link_info->req_flow_ctrl =
-				PORT_PHY_CFG_REQ_AUTO_PAUSE_AUTONEG_PAUSE;
+		link_info->req_flow_ctrl = 0;
 	} else {
 		/* when transition from auto pause to force pause,
 		 * force a link change
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index c8083df5e0ab..148b58f3468b 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -20,6 +20,8 @@
 #include "bnxt.h"
 #include "bnxt_xdp.h"
 
+DEFINE_STATIC_KEY_FALSE(bnxt_xdp_locking_key);
+
 struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 				   struct bnxt_tx_ring_info *txr,
 				   dma_addr_t mapping, u32 len)
@@ -227,11 +229,16 @@ int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
 	ring = smp_processor_id() % bp->tx_nr_rings_xdp;
 	txr = &bp->tx_ring[ring];
 
+	if (READ_ONCE(txr->dev_state) == BNXT_DEV_STATE_CLOSING)
+		return -EINVAL;
+
+	if (static_branch_unlikely(&bnxt_xdp_locking_key))
+		spin_lock(&txr->xdp_tx_lock);
+
 	for (i = 0; i < num_frames; i++) {
 		struct xdp_frame *xdp = frames[i];
 
-		if (!txr || !bnxt_tx_avail(bp, txr) ||
-		    !(bp->bnapi[ring]->flags & BNXT_NAPI_FLAG_XDP))
+		if (!bnxt_tx_avail(bp, txr))
 			break;
 
 		mapping = dma_map_single(&pdev->dev, xdp->data, xdp->len,
@@ -250,6 +257,9 @@ int bnxt_xdp_xmit(struct net_device *dev, int num_frames,
 		bnxt_db_write(bp, &txr->tx_db, txr->tx_prod);
 	}
 
+	if (static_branch_unlikely(&bnxt_xdp_locking_key))
+		spin_unlock(&txr->xdp_tx_lock);
+
 	return nxmit;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
index 0df40c3beb05..067bb5e821f5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.h
@@ -10,6 +10,8 @@
 #ifndef BNXT_XDP_H
 #define BNXT_XDP_H
 
+DECLARE_STATIC_KEY_FALSE(bnxt_xdp_locking_key);
+
 struct bnxt_sw_tx_bd *bnxt_xmit_bd(struct bnxt *bp,
 				   struct bnxt_tx_ring_info *txr,
 				   dma_addr_t mapping, u32 len);
diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
index 32b5faa87bb8..208a3459f2e2 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.c
@@ -168,7 +168,7 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 	base = of_iomap(node, 0);
 	if (!base) {
 		err = -ENOMEM;
-		goto err_close;
+		goto err_put;
 	}
 
 	err = fsl_mc_allocate_irqs(mc_dev);
@@ -212,6 +212,8 @@ static int dpaa2_ptp_probe(struct fsl_mc_device *mc_dev)
 	fsl_mc_free_irqs(mc_dev);
 err_unmap:
 	iounmap(base);
+err_put:
+	of_node_put(node);
 err_close:
 	dprtc_close(mc_dev->mc_io, 0, mc_dev->mc_handle);
 err_free_mcp:
diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 7e5daede3a2e..df65bb494695 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -552,7 +552,7 @@ static inline struct ice_pf *ice_netdev_to_pf(struct net_device *netdev)
 
 static inline bool ice_is_xdp_ena_vsi(struct ice_vsi *vsi)
 {
-	return !!vsi->xdp_prog;
+	return !!READ_ONCE(vsi->xdp_prog);
 }
 
 static inline void ice_set_ring_xdp(struct ice_ring *ring)
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 8c08997dcef6..653996e8fd30 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -1306,6 +1306,7 @@ static int ice_vsi_alloc_rings(struct ice_vsi *vsi)
 		ring->tx_tstamps = &pf->ptp.port.tx;
 		ring->dev = dev;
 		ring->count = vsi->num_tx_desc;
+		ring->txq_teid = ICE_INVAL_TEID;
 		WRITE_ONCE(vsi->tx_rings[i], ring);
 	}
 
@@ -2923,6 +2924,8 @@ int ice_vsi_release(struct ice_vsi *vsi)
 		}
 	}
 
+	if (ice_is_vsi_dflt_vsi(pf->first_sw, vsi))
+		ice_clear_dflt_vsi(pf->first_sw);
 	ice_fltr_remove_all(vsi);
 	ice_rm_vsi_lan_cfg(vsi->port_info, vsi->idx);
 	err = ice_rm_vsi_rdma_cfg(vsi->port_info, vsi->idx);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 7f68132b8a1f..f330bd0acf9f 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2612,8 +2612,10 @@ int ice_destroy_xdp_rings(struct ice_vsi *vsi)
 
 	for (i = 0; i < vsi->num_xdp_txq; i++)
 		if (vsi->xdp_rings[i]) {
-			if (vsi->xdp_rings[i]->desc)
+			if (vsi->xdp_rings[i]->desc) {
+				synchronize_rcu();
 				ice_free_tx_ring(vsi->xdp_rings[i]);
+			}
 			kfree_rcu(vsi->xdp_rings[i], rcu);
 			vsi->xdp_rings[i] = NULL;
 		}
diff --git a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
index 4338e4ff7e85..9d4d58757e04 100644
--- a/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/ice/ice_virtchnl_pf.c
@@ -3335,9 +3335,9 @@ static int ice_vc_dis_qs_msg(struct ice_vf *vf, u8 *msg)
 				goto error_param;
 			}
 
-			/* Skip queue if not enabled */
 			if (!test_bit(vf_q_id, vf->txq_ena))
-				continue;
+				dev_dbg(ice_pf_to_dev(vsi->back), "Queue %u on VSI %u is not enabled, but stopping it anyway\n",
+					vf_q_id, vsi->vsi_num);
 
 			ice_fill_txq_meta(vsi, ring, &txq_meta);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 37c7dc6b44a9..2b1873061912 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -36,8 +36,10 @@ static void ice_qp_reset_stats(struct ice_vsi *vsi, u16 q_idx)
 static void ice_qp_clean_rings(struct ice_vsi *vsi, u16 q_idx)
 {
 	ice_clean_tx_ring(vsi->tx_rings[q_idx]);
-	if (ice_is_xdp_ena_vsi(vsi))
+	if (ice_is_xdp_ena_vsi(vsi)) {
+		synchronize_rcu();
 		ice_clean_tx_ring(vsi->xdp_rings[q_idx]);
+	}
 	ice_clean_rx_ring(vsi->rx_rings[q_idx]);
 }
 
@@ -759,7 +761,7 @@ ice_xsk_wakeup(struct net_device *netdev, u32 queue_id,
 	struct ice_vsi *vsi = np->vsi;
 	struct ice_ring *ring;
 
-	if (test_bit(ICE_DOWN, vsi->state))
+	if (test_bit(ICE_VSI_DOWN, vsi->state))
 		return -ENETDOWN;
 
 	if (!ice_is_xdp_ena_vsi(vsi))
diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index 1b61fe2e9b4d..90fd5588e20d 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2747,7 +2747,7 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 	}
 
 	ret = of_get_mac_address(pnp, ppd.mac_addr);
-	if (ret)
+	if (ret == -EPROBE_DEFER)
 		return ret;
 
 	mv643xx_eth_property(pnp, "tx-queue-size", ppd.tx_queue_size);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
index d7576b6fa43b..7d56a927081d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -793,11 +793,14 @@ int mlx5_devlink_register(struct devlink *devlink)
 {
 	int err;
 
-	err = devlink_params_register(devlink, mlx5_devlink_params,
-				      ARRAY_SIZE(mlx5_devlink_params));
+	err = devlink_register(devlink);
 	if (err)
 		return err;
 
+	err = devlink_params_register(devlink, mlx5_devlink_params,
+				      ARRAY_SIZE(mlx5_devlink_params));
+	if (err)
+		goto params_reg_err;
 	mlx5_devlink_set_params_init_values(devlink);
 
 	err = mlx5_devlink_auxdev_params_register(devlink);
@@ -808,6 +811,7 @@ int mlx5_devlink_register(struct devlink *devlink)
 	if (err)
 		goto traps_reg_err;
 
+	devlink_params_publish(devlink);
 	return 0;
 
 traps_reg_err:
@@ -815,13 +819,17 @@ int mlx5_devlink_register(struct devlink *devlink)
 auxdev_reg_err:
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
+params_reg_err:
+	devlink_unregister(devlink);
 	return err;
 }
 
 void mlx5_devlink_unregister(struct devlink *devlink)
 {
+	devlink_params_unpublish(devlink);
 	mlx5_devlink_traps_unregister(devlink);
 	mlx5_devlink_auxdev_params_unregister(devlink);
 	devlink_params_unregister(devlink, mlx5_devlink_params,
 				  ARRAY_SIZE(mlx5_devlink_params));
+	devlink_unregister(devlink);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index f075bb8ccd00..01301bee420c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -4914,6 +4914,7 @@ mlx5e_create_netdev(struct mlx5_core_dev *mdev, const struct mlx5e_profile *prof
 	}
 
 	netif_carrier_off(netdev);
+	netif_tx_disable(netdev);
 	dev_net_set(netdev, mlx5_core_net(mdev));
 
 	return netdev;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 097ab6fe371c..4ed740994279 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1541,7 +1541,6 @@ static int probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 		dev_err(&pdev->dev, "mlx5_crdump_enable failed with error code %d\n", err);
 
 	pci_save_state(pdev);
-	devlink_register(devlink);
 	if (!mlx5_core_is_mp_slave(dev))
 		devlink_reload_enable(devlink);
 	return 0;
@@ -1564,7 +1563,6 @@ static void remove_one(struct pci_dev *pdev)
 	struct devlink *devlink = priv_to_devlink(dev);
 
 	devlink_reload_disable(devlink);
-	devlink_unregister(devlink);
 	mlx5_crdump_disable(dev);
 	mlx5_drain_health_wq(dev);
 	mlx5_uninit_one(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/port.c b/drivers/net/ethernet/mellanox/mlx5/core/port.c
index 7b16a1188aab..fd79860de723 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/port.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/port.c
@@ -433,35 +433,12 @@ int mlx5_query_module_eeprom_by_page(struct mlx5_core_dev *dev,
 				     struct mlx5_module_eeprom_query_params *params,
 				     u8 *data)
 {
-	u8 module_id;
 	int err;
 
 	err = mlx5_query_module_num(dev, &params->module_number);
 	if (err)
 		return err;
 
-	err = mlx5_query_module_id(dev, params->module_number, &module_id);
-	if (err)
-		return err;
-
-	switch (module_id) {
-	case MLX5_MODULE_ID_SFP:
-		if (params->page > 0)
-			return -EINVAL;
-		break;
-	case MLX5_MODULE_ID_QSFP:
-	case MLX5_MODULE_ID_QSFP28:
-	case MLX5_MODULE_ID_QSFP_PLUS:
-		if (params->page > 3)
-			return -EINVAL;
-		break;
-	case MLX5_MODULE_ID_DSFP:
-		break;
-	default:
-		mlx5_core_err(dev, "Module ID not recognized: 0x%x\n", module_id);
-		return -EINVAL;
-	}
-
 	if (params->i2c_address != MLX5_I2C_ADDR_HIGH &&
 	    params->i2c_address != MLX5_I2C_ADDR_LOW) {
 		mlx5_core_err(dev, "I2C address not recognized: 0x%x\n", params->i2c_address);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
index 3cf272fa2164..052f48068dc1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/dev/driver.c
@@ -46,7 +46,6 @@ static int mlx5_sf_dev_probe(struct auxiliary_device *adev, const struct auxilia
 		mlx5_core_warn(mdev, "mlx5_init_one err=%d\n", err);
 		goto init_one_err;
 	}
-	devlink_register(devlink);
 	devlink_reload_enable(devlink);
 	return 0;
 
@@ -66,7 +65,6 @@ static void mlx5_sf_dev_remove(struct auxiliary_device *adev)
 
 	devlink = priv_to_devlink(sf_dev->mdev);
 	devlink_reload_disable(devlink);
-	devlink_unregister(devlink);
 	mlx5_uninit_one(sf_dev->mdev);
 	iounmap(sf_dev->mdev->iseg);
 	mlx5_mdev_uninit(sf_dev->mdev);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_fp.c b/drivers/net/ethernet/qlogic/qede/qede_fp.c
index 999abcfe3310..17f895250e04 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_fp.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_fp.c
@@ -747,6 +747,9 @@ qede_build_skb(struct qede_rx_queue *rxq,
 	buf = page_address(bd->data) + bd->page_offset;
 	skb = build_skb(buf, rxq->rx_buf_seg_size);
 
+	if (unlikely(!skb))
+		return NULL;
+
 	skb_reserve(skb, pad);
 	skb_put(skb, len);
 
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 3dbea028b325..1f8cfd806008 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -763,6 +763,85 @@ void efx_remove_channels(struct efx_nic *efx)
 	kfree(efx->xdp_tx_queues);
 }
 
+static int efx_set_xdp_tx_queue(struct efx_nic *efx, int xdp_queue_number,
+				struct efx_tx_queue *tx_queue)
+{
+	if (xdp_queue_number >= efx->xdp_tx_queue_count)
+		return -EINVAL;
+
+	netif_dbg(efx, drv, efx->net_dev,
+		  "Channel %u TXQ %u is XDP %u, HW %u\n",
+		  tx_queue->channel->channel, tx_queue->label,
+		  xdp_queue_number, tx_queue->queue);
+	efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
+	return 0;
+}
+
+static void efx_set_xdp_channels(struct efx_nic *efx)
+{
+	struct efx_tx_queue *tx_queue;
+	struct efx_channel *channel;
+	unsigned int next_queue = 0;
+	int xdp_queue_number = 0;
+	int rc;
+
+	/* We need to mark which channels really have RX and TX
+	 * queues, and adjust the TX queue numbers if we have separate
+	 * RX-only and TX-only channels.
+	 */
+	efx_for_each_channel(channel, efx) {
+		if (channel->channel < efx->tx_channel_offset)
+			continue;
+
+		if (efx_channel_is_xdp_tx(channel)) {
+			efx_for_each_channel_tx_queue(tx_queue, channel) {
+				tx_queue->queue = next_queue++;
+				rc = efx_set_xdp_tx_queue(efx, xdp_queue_number,
+							  tx_queue);
+				if (rc == 0)
+					xdp_queue_number++;
+			}
+		} else {
+			efx_for_each_channel_tx_queue(tx_queue, channel) {
+				tx_queue->queue = next_queue++;
+				netif_dbg(efx, drv, efx->net_dev,
+					  "Channel %u TXQ %u is HW %u\n",
+					  channel->channel, tx_queue->label,
+					  tx_queue->queue);
+			}
+
+			/* If XDP is borrowing queues from net stack, it must
+			 * use the queue with no csum offload, which is the
+			 * first one of the channel
+			 * (note: tx_queue_by_type is not initialized yet)
+			 */
+			if (efx->xdp_txq_queues_mode ==
+			    EFX_XDP_TX_QUEUES_BORROWED) {
+				tx_queue = &channel->tx_queue[0];
+				rc = efx_set_xdp_tx_queue(efx, xdp_queue_number,
+							  tx_queue);
+				if (rc == 0)
+					xdp_queue_number++;
+			}
+		}
+	}
+	WARN_ON(efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_DEDICATED &&
+		xdp_queue_number != efx->xdp_tx_queue_count);
+	WARN_ON(efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED &&
+		xdp_queue_number > efx->xdp_tx_queue_count);
+
+	/* If we have more CPUs than assigned XDP TX queues, assign the already
+	 * existing queues to the exceeding CPUs
+	 */
+	next_queue = 0;
+	while (xdp_queue_number < efx->xdp_tx_queue_count) {
+		tx_queue = efx->xdp_tx_queues[next_queue++];
+		rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
+		if (rc == 0)
+			xdp_queue_number++;
+	}
+}
+
 int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 {
 	struct efx_channel *other_channel[EFX_MAX_CHANNELS], *channel;
@@ -837,6 +916,7 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 		efx_init_napi_channel(efx->channel[i]);
 	}
 
+	efx_set_xdp_channels(efx);
 out:
 	/* Destroy unused channel structures */
 	for (i = 0; i < efx->n_channels; i++) {
@@ -872,26 +952,9 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 	goto out;
 }
 
-static inline int
-efx_set_xdp_tx_queue(struct efx_nic *efx, int xdp_queue_number,
-		     struct efx_tx_queue *tx_queue)
-{
-	if (xdp_queue_number >= efx->xdp_tx_queue_count)
-		return -EINVAL;
-
-	netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is XDP %u, HW %u\n",
-		  tx_queue->channel->channel, tx_queue->label,
-		  xdp_queue_number, tx_queue->queue);
-	efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
-	return 0;
-}
-
 int efx_set_channels(struct efx_nic *efx)
 {
-	struct efx_tx_queue *tx_queue;
 	struct efx_channel *channel;
-	unsigned int next_queue = 0;
-	int xdp_queue_number;
 	int rc;
 
 	efx->tx_channel_offset =
@@ -909,61 +972,14 @@ int efx_set_channels(struct efx_nic *efx)
 			return -ENOMEM;
 	}
 
-	/* We need to mark which channels really have RX and TX
-	 * queues, and adjust the TX queue numbers if we have separate
-	 * RX-only and TX-only channels.
-	 */
-	xdp_queue_number = 0;
 	efx_for_each_channel(channel, efx) {
 		if (channel->channel < efx->n_rx_channels)
 			channel->rx_queue.core_index = channel->channel;
 		else
 			channel->rx_queue.core_index = -1;
-
-		if (channel->channel >= efx->tx_channel_offset) {
-			if (efx_channel_is_xdp_tx(channel)) {
-				efx_for_each_channel_tx_queue(tx_queue, channel) {
-					tx_queue->queue = next_queue++;
-					rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
-					if (rc == 0)
-						xdp_queue_number++;
-				}
-			} else {
-				efx_for_each_channel_tx_queue(tx_queue, channel) {
-					tx_queue->queue = next_queue++;
-					netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is HW %u\n",
-						  channel->channel, tx_queue->label,
-						  tx_queue->queue);
-				}
-
-				/* If XDP is borrowing queues from net stack, it must use the queue
-				 * with no csum offload, which is the first one of the channel
-				 * (note: channel->tx_queue_by_type is not initialized yet)
-				 */
-				if (efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_BORROWED) {
-					tx_queue = &channel->tx_queue[0];
-					rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
-					if (rc == 0)
-						xdp_queue_number++;
-				}
-			}
-		}
 	}
-	WARN_ON(efx->xdp_txq_queues_mode == EFX_XDP_TX_QUEUES_DEDICATED &&
-		xdp_queue_number != efx->xdp_tx_queue_count);
-	WARN_ON(efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED &&
-		xdp_queue_number > efx->xdp_tx_queue_count);
 
-	/* If we have more CPUs than assigned XDP TX queues, assign the already
-	 * existing queues to the exceeding CPUs
-	 */
-	next_queue = 0;
-	while (xdp_queue_number < efx->xdp_tx_queue_count) {
-		tx_queue = efx->xdp_tx_queues[next_queue++];
-		rc = efx_set_xdp_tx_queue(efx, xdp_queue_number, tx_queue);
-		if (rc == 0)
-			xdp_queue_number++;
-	}
+	efx_set_xdp_channels(efx);
 
 	rc = netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
 	if (rc)
@@ -1107,7 +1123,7 @@ void efx_start_channels(struct efx_nic *efx)
 	struct efx_rx_queue *rx_queue;
 	struct efx_channel *channel;
 
-	efx_for_each_channel(channel, efx) {
+	efx_for_each_channel_rev(channel, efx) {
 		efx_for_each_channel_tx_queue(tx_queue, channel) {
 			efx_init_tx_queue(tx_queue);
 			atomic_inc(&efx->active_queues);
diff --git a/drivers/net/ethernet/sfc/rx_common.c b/drivers/net/ethernet/sfc/rx_common.c
index 633ca77a26fd..b925de9b4302 100644
--- a/drivers/net/ethernet/sfc/rx_common.c
+++ b/drivers/net/ethernet/sfc/rx_common.c
@@ -166,6 +166,9 @@ static void efx_fini_rx_recycle_ring(struct efx_rx_queue *rx_queue)
 	struct efx_nic *efx = rx_queue->efx;
 	int i;
 
+	if (unlikely(!rx_queue->page_ring))
+		return;
+
 	/* Unmap and release the pages in the recycle ring. Remove the ring. */
 	for (i = 0; i <= rx_queue->page_ptr_mask; i++) {
 		struct page *page = rx_queue->page_ring[i];
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index d16e031e95f4..6983799e1c05 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -443,6 +443,9 @@ int efx_xdp_tx_buffers(struct efx_nic *efx, int n, struct xdp_frame **xdpfs,
 	if (unlikely(!tx_queue))
 		return -EINVAL;
 
+	if (!tx_queue->initialised)
+		return -EINVAL;
+
 	if (efx->xdp_txq_queues_mode != EFX_XDP_TX_QUEUES_DEDICATED)
 		HARD_TX_LOCK(efx->net_dev, tx_queue->core_txq, cpu);
 
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index d530cde2b864..9bc8281b7f5b 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -101,6 +101,8 @@ void efx_fini_tx_queue(struct efx_tx_queue *tx_queue)
 	netif_dbg(tx_queue->efx, drv, tx_queue->efx->net_dev,
 		  "shutting down TX queue %d\n", tx_queue->queue);
 
+	tx_queue->initialised = false;
+
 	if (!tx_queue->buffer)
 		return;
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 5d29f336315b..11e1055e8260 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -431,8 +431,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	plat->phylink_node = np;
 
 	/* Get max speed of operation from device tree */
-	if (of_property_read_u32(np, "max-speed", &plat->max_speed))
-		plat->max_speed = -1;
+	of_property_read_u32(np, "max-speed", &plat->max_speed);
 
 	plat->bus_id = of_alias_get_id(np, "ethernet");
 	if (plat->bus_id < 0)
diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 694e2f5dbbe5..39801c31e507 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -133,11 +133,17 @@ static void macvtap_setup(struct net_device *dev)
 	dev->tx_queue_len = TUN_READQ_SIZE;
 }
 
+static struct net *macvtap_link_net(const struct net_device *dev)
+{
+	return dev_net(macvlan_dev_real_dev(dev));
+}
+
 static struct rtnl_link_ops macvtap_link_ops __read_mostly = {
 	.kind		= "macvtap",
 	.setup		= macvtap_setup,
 	.newlink	= macvtap_newlink,
 	.dellink	= macvtap_dellink,
+	.get_link_net	= macvtap_link_net,
 	.priv_size      = sizeof(struct macvtap_dev),
 };
 
diff --git a/drivers/net/mdio/mdio-mscc-miim.c b/drivers/net/mdio/mdio-mscc-miim.c
index 17f98f609ec8..5070ca2f2637 100644
--- a/drivers/net/mdio/mdio-mscc-miim.c
+++ b/drivers/net/mdio/mdio-mscc-miim.c
@@ -76,6 +76,9 @@ static int mscc_miim_read(struct mii_bus *bus, int mii_id, int regnum)
 	u32 val;
 	int ret;
 
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
 	ret = mscc_miim_wait_pending(bus);
 	if (ret)
 		goto out;
@@ -105,6 +108,9 @@ static int mscc_miim_write(struct mii_bus *bus, int mii_id,
 	struct mscc_miim_dev *miim = bus->priv;
 	int ret;
 
+	if (regnum & MII_ADDR_C45)
+		return -EOPNOTSUPP;
+
 	ret = mscc_miim_wait_pending(bus);
 	if (ret < 0)
 		goto out;
diff --git a/drivers/net/phy/sfp-bus.c b/drivers/net/phy/sfp-bus.c
index ef2c6a09eb0f..4369d6249e7b 100644
--- a/drivers/net/phy/sfp-bus.c
+++ b/drivers/net/phy/sfp-bus.c
@@ -74,6 +74,12 @@ static const struct sfp_quirk sfp_quirks[] = {
 		.vendor = "HUAWEI",
 		.part = "MA5671A",
 		.modes = sfp_quirk_2500basex,
+	}, {
+		// Lantech 8330-262D-E can operate at 2500base-X, but
+		// incorrectly report 2500MBd NRZ in their EEPROM
+		.vendor = "Lantech",
+		.part = "8330-262D-E",
+		.modes = sfp_quirk_2500basex,
 	}, {
 		.vendor = "UBNT",
 		.part = "UF-INSTANT",
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 8e3a28ba6b28..ba2ef5437e16 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -1198,7 +1198,8 @@ static int tap_sendmsg(struct socket *sock, struct msghdr *m,
 	struct xdp_buff *xdp;
 	int i;
 
-	if (ctl && (ctl->type == TUN_MSG_PTR)) {
+	if (m->msg_controllen == sizeof(struct tun_msg_ctl) &&
+	    ctl && ctl->type == TUN_MSG_PTR) {
 		for (i = 0; i < ctl->num; i++) {
 			xdp = &((struct xdp_buff *)ctl->ptr)[i];
 			tap_get_user_xdp(q, xdp);
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 45a67e72a02c..02de8d998bfa 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2489,7 +2489,8 @@ static int tun_sendmsg(struct socket *sock, struct msghdr *m, size_t total_len)
 	if (!tun)
 		return -EBADFD;
 
-	if (ctl && (ctl->type == TUN_MSG_PTR)) {
+	if (m->msg_controllen == sizeof(struct tun_msg_ctl) &&
+	    ctl && ctl->type == TUN_MSG_PTR) {
 		struct tun_page tpage;
 		int n = ctl->num;
 		int flush = 0;
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index b2242a082431..091dd7caf10c 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -1265,6 +1265,7 @@ static int vrf_prepare_mac_header(struct sk_buff *skb,
 	eth = (struct ethhdr *)skb->data;
 
 	skb_reset_mac_header(skb);
+	skb_reset_mac_len(skb);
 
 	/* we set the ethernet destination and the source addresses to the
 	 * address of the VRF device.
@@ -1294,9 +1295,9 @@ static int vrf_prepare_mac_header(struct sk_buff *skb,
  */
 static int vrf_add_mac_header_if_unset(struct sk_buff *skb,
 				       struct net_device *vrf_dev,
-				       u16 proto)
+				       u16 proto, struct net_device *orig_dev)
 {
-	if (skb_mac_header_was_set(skb))
+	if (skb_mac_header_was_set(skb) && dev_has_header(orig_dev))
 		return 0;
 
 	return vrf_prepare_mac_header(skb, vrf_dev, proto);
@@ -1402,6 +1403,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 
 	/* if packet is NDISC then keep the ingress interface */
 	if (!is_ndisc) {
+		struct net_device *orig_dev = skb->dev;
+
 		vrf_rx_stats(vrf_dev, skb->len);
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
@@ -1410,7 +1413,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 			int err;
 
 			err = vrf_add_mac_header_if_unset(skb, vrf_dev,
-							  ETH_P_IPV6);
+							  ETH_P_IPV6,
+							  orig_dev);
 			if (likely(!err)) {
 				skb_push(skb, skb->mac_len);
 				dev_queue_xmit_nit(skb, vrf_dev);
@@ -1440,6 +1444,8 @@ static struct sk_buff *vrf_ip6_rcv(struct net_device *vrf_dev,
 static struct sk_buff *vrf_ip_rcv(struct net_device *vrf_dev,
 				  struct sk_buff *skb)
 {
+	struct net_device *orig_dev = skb->dev;
+
 	skb->dev = vrf_dev;
 	skb->skb_iif = vrf_dev->ifindex;
 	IPCB(skb)->flags |= IPSKB_L3SLAVE;
@@ -1460,7 +1466,8 @@ static struct sk_buff *vrf_ip_rcv(struct net_device *vrf_dev,
 	if (!list_empty(&vrf_dev->ptype_all)) {
 		int err;
 
-		err = vrf_add_mac_header_if_unset(skb, vrf_dev, ETH_P_IP);
+		err = vrf_add_mac_header_if_unset(skb, vrf_dev, ETH_P_IP,
+						  orig_dev);
 		if (likely(!err)) {
 			skb_push(skb, skb->mac_len);
 			dev_queue_xmit_nit(skb, vrf_dev);
diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 3fb0aa000825..24bd0520926b 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -391,6 +391,8 @@ static void ath11k_ahb_free_ext_irq(struct ath11k_base *ab)
 
 		for (j = 0; j < irq_grp->num_irq; j++)
 			free_irq(ab->irq_num[irq_grp->irqs[j]], irq_grp);
+
+		netif_napi_del(&irq_grp->napi);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath11k/mhi.c b/drivers/net/wireless/ath/ath11k/mhi.c
index 49c0b1ad40a0..f2149241fb13 100644
--- a/drivers/net/wireless/ath/ath11k/mhi.c
+++ b/drivers/net/wireless/ath/ath11k/mhi.c
@@ -519,7 +519,7 @@ static int ath11k_mhi_set_state(struct ath11k_pci *ab_pci,
 		ret = 0;
 		break;
 	case ATH11K_MHI_POWER_ON:
-		ret = mhi_async_power_up(ab_pci->mhi_ctrl);
+		ret = mhi_sync_power_up(ab_pci->mhi_ctrl);
 		break;
 	case ATH11K_MHI_POWER_OFF:
 		mhi_power_down(ab_pci->mhi_ctrl, true);
diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 54ce08f1c6e0..353a2d669fcd 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -1382,6 +1382,11 @@ static __maybe_unused int ath11k_pci_pm_suspend(struct device *dev)
 	struct ath11k_base *ab = dev_get_drvdata(dev);
 	int ret;
 
+	if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
+		ath11k_dbg(ab, ATH11K_DBG_BOOT, "boot skipping pci suspend as qmi is not initialised\n");
+		return 0;
+	}
+
 	ret = ath11k_core_suspend(ab);
 	if (ret)
 		ath11k_warn(ab, "failed to suspend core: %d\n", ret);
@@ -1394,6 +1399,11 @@ static __maybe_unused int ath11k_pci_pm_resume(struct device *dev)
 	struct ath11k_base *ab = dev_get_drvdata(dev);
 	int ret;
 
+	if (test_bit(ATH11K_FLAG_QMI_FAIL, &ab->dev_flags)) {
+		ath11k_dbg(ab, ATH11K_DBG_BOOT, "boot skipping pci resume as qmi is not initialised\n");
+		return 0;
+	}
+
 	ret = ath11k_core_resume(ab);
 	if (ret)
 		ath11k_warn(ab, "failed to resume core: %d\n", ret);
diff --git a/drivers/net/wireless/ath/ath5k/eeprom.c b/drivers/net/wireless/ath/ath5k/eeprom.c
index 1fbc2c19848f..d444b3d70ba2 100644
--- a/drivers/net/wireless/ath/ath5k/eeprom.c
+++ b/drivers/net/wireless/ath/ath5k/eeprom.c
@@ -746,6 +746,9 @@ ath5k_eeprom_convert_pcal_info_5111(struct ath5k_hw *ah, int mode,
 			}
 		}
 
+		if (idx == AR5K_EEPROM_N_PD_CURVES)
+			goto err_out;
+
 		ee->ee_pd_gains[mode] = 1;
 
 		pd = &chinfo[pier].pd_curves[idx];
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index 035336a9e755..6d82725cb87d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 /*
- * Copyright (C) 2012-2014, 2018-2021 Intel Corporation
+ * Copyright (C) 2012-2014, 2018-2022 Intel Corporation
  * Copyright (C) 2013-2014 Intel Mobile Communications GmbH
  * Copyright (C) 2017 Intel Deutschland GmbH
  */
@@ -295,18 +295,31 @@ void iwl_mvm_phy_ctxt_unref(struct iwl_mvm *mvm, struct iwl_mvm_phy_ctxt *ctxt)
 	 * otherwise we might not be able to reuse this phy.
 	 */
 	if (ctxt->ref == 0) {
-		struct ieee80211_channel *chan;
+		struct ieee80211_channel *chan = NULL;
 		struct cfg80211_chan_def chandef;
-		struct ieee80211_supported_band *sband = NULL;
-		enum nl80211_band band = NL80211_BAND_2GHZ;
+		struct ieee80211_supported_band *sband;
+		enum nl80211_band band;
+		int channel;
 
-		while (!sband && band < NUM_NL80211_BANDS)
-			sband = mvm->hw->wiphy->bands[band++];
+		for (band = NL80211_BAND_2GHZ; band < NUM_NL80211_BANDS; band++) {
+			sband = mvm->hw->wiphy->bands[band];
 
-		if (WARN_ON(!sband))
-			return;
+			if (!sband)
+				continue;
+
+			for (channel = 0; channel < sband->n_channels; channel++)
+				if (!(sband->channels[channel].flags &
+						IEEE80211_CHAN_DISABLED)) {
+					chan = &sband->channels[channel];
+					break;
+				}
 
-		chan = &sband->channels[0];
+			if (chan)
+				break;
+		}
+
+		if (WARN_ON(!chan))
+			return;
 
 		cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_NO_HT);
 		iwl_mvm_phy_ctxt_changed(mvm, ctxt, &chandef, 1, 1);
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 5461bf399959..65e382756de6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1890,7 +1890,10 @@ static u8 iwl_mvm_scan_umac_chan_flags_v2(struct iwl_mvm *mvm,
 			IWL_SCAN_CHANNEL_FLAG_CACHE_ADD;
 
 	/* set fragmented ebs for fragmented scan on HB channels */
-	if (iwl_mvm_is_scan_fragmented(params->hb_type))
+	if ((!iwl_mvm_is_cdb_supported(mvm) &&
+	     iwl_mvm_is_scan_fragmented(params->type)) ||
+	    (iwl_mvm_is_cdb_supported(mvm) &&
+	     iwl_mvm_is_scan_fragmented(params->hb_type)))
 		flags |= IWL_SCAN_CHANNEL_FLAG_EBS_FRAG;
 
 	return flags;
diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index 5e1c1506a4c6..7aecde35cb9a 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -465,6 +465,7 @@ mt76_dma_rx_fill(struct mt76_dev *dev, struct mt76_queue *q)
 
 		qbuf.addr = addr + offset;
 		qbuf.len = len - offset;
+		qbuf.skip_unmap = false;
 		mt76_dma_add_buf(dev, q, &qbuf, 1, 0, buf, NULL);
 		frames++;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 4d01fd85283d..6e4d69715927 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -19,7 +19,7 @@
 
 #define MT_MCU_RING_SIZE	32
 #define MT_RX_BUF_SIZE		2048
-#define MT_SKB_HEAD_LEN		128
+#define MT_SKB_HEAD_LEN		256
 
 #define MT_MAX_NON_AQL_PKT	16
 #define MT_TXQ_FREE_THR		32
diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
index eb7bda91f2b3..8f4a5d4929e0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mac.c
@@ -1732,7 +1732,7 @@ mt7615_mac_adjust_sensitivity(struct mt7615_phy *phy,
 	struct mt7615_dev *dev = phy->dev;
 	int false_cca = ofdm ? phy->false_cca_ofdm : phy->false_cca_cck;
 	bool ext_phy = phy != &dev->phy;
-	u16 def_th = ofdm ? -98 : -110;
+	s16 def_th = ofdm ? -98 : -110;
 	bool update = false;
 	s8 *sensitivity;
 	int signal;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index ff613d705611..7691292526e0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -899,6 +899,7 @@ mt7915_mac_write_txwi_80211(struct mt7915_dev *dev, __le32 *txwi,
 		val = MT_TXD3_SN_VALID |
 		      FIELD_PREP(MT_TXD3_SEQ, IEEE80211_SEQ_TO_SN(seqno));
 		txwi[3] |= cpu_to_le32(val);
+		txwi[7] &= ~cpu_to_le32(MT_TXD7_HW_AMSDU);
 	}
 
 	val = FIELD_PREP(MT_TXD7_TYPE, fc_type) |
diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/main.c b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
index 9eb90e6f0103..30252f408ddc 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/main.c
@@ -224,6 +224,7 @@ static void mt7921_stop(struct ieee80211_hw *hw)
 
 	cancel_delayed_work_sync(&dev->pm.ps_work);
 	cancel_work_sync(&dev->pm.wake_work);
+	cancel_work_sync(&dev->reset_work);
 	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
 
 	mt7921_mutex_acquire(dev);
diff --git a/drivers/opp/debugfs.c b/drivers/opp/debugfs.c
index 596c185b5dda..b5f2f9f39392 100644
--- a/drivers/opp/debugfs.c
+++ b/drivers/opp/debugfs.c
@@ -10,6 +10,7 @@
 #include <linux/debugfs.h>
 #include <linux/device.h>
 #include <linux/err.h>
+#include <linux/of.h>
 #include <linux/init.h>
 #include <linux/limits.h>
 #include <linux/slab.h>
@@ -131,9 +132,13 @@ void opp_debug_create_one(struct dev_pm_opp *opp, struct opp_table *opp_table)
 	debugfs_create_bool("suspend", S_IRUGO, d, &opp->suspend);
 	debugfs_create_u32("performance_state", S_IRUGO, d, &opp->pstate);
 	debugfs_create_ulong("rate_hz", S_IRUGO, d, &opp->rate);
+	debugfs_create_u32("level", S_IRUGO, d, &opp->level);
 	debugfs_create_ulong("clock_latency_ns", S_IRUGO, d,
 			     &opp->clock_latency_ns);
 
+	opp->of_name = of_node_full_name(opp->np);
+	debugfs_create_str("of_name", S_IRUGO, d, (char **)&opp->of_name);
+
 	opp_debug_create_supplies(opp, opp_table, d);
 	opp_debug_create_bw(opp, opp_table, d);
 
diff --git a/drivers/opp/opp.h b/drivers/opp/opp.h
index 407c3bfe51d9..45e3a55239a1 100644
--- a/drivers/opp/opp.h
+++ b/drivers/opp/opp.h
@@ -96,6 +96,7 @@ struct dev_pm_opp {
 
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *dentry;
+	const char *of_name;
 #endif
 };
 
diff --git a/drivers/parisc/dino.c b/drivers/parisc/dino.c
index 952a92504df6..e33036281327 100644
--- a/drivers/parisc/dino.c
+++ b/drivers/parisc/dino.c
@@ -142,9 +142,8 @@ struct dino_device
 {
 	struct pci_hba_data	hba;	/* 'C' inheritance - must be first */
 	spinlock_t		dinosaur_pen;
-	unsigned long		txn_addr; /* EIR addr to generate interrupt */ 
-	u32			txn_data; /* EIR data assign to each dino */ 
 	u32 			imr;	  /* IRQ's which are enabled */ 
+	struct gsc_irq		gsc_irq;
 	int			global_irq[DINO_LOCAL_IRQS]; /* map IMR bit to global irq */
 #ifdef DINO_DEBUG
 	unsigned int		dino_irr0; /* save most recent IRQ line stat */
@@ -339,14 +338,43 @@ static void dino_unmask_irq(struct irq_data *d)
 	if (tmp & DINO_MASK_IRQ(local_irq)) {
 		DBG(KERN_WARNING "%s(): IRQ asserted! (ILR 0x%x)\n",
 				__func__, tmp);
-		gsc_writel(dino_dev->txn_data, dino_dev->txn_addr);
+		gsc_writel(dino_dev->gsc_irq.txn_data, dino_dev->gsc_irq.txn_addr);
 	}
 }
 
+#ifdef CONFIG_SMP
+static int dino_set_affinity_irq(struct irq_data *d, const struct cpumask *dest,
+				bool force)
+{
+	struct dino_device *dino_dev = irq_data_get_irq_chip_data(d);
+	struct cpumask tmask;
+	int cpu_irq;
+	u32 eim;
+
+	if (!cpumask_and(&tmask, dest, cpu_online_mask))
+		return -EINVAL;
+
+	cpu_irq = cpu_check_affinity(d, &tmask);
+	if (cpu_irq < 0)
+		return cpu_irq;
+
+	dino_dev->gsc_irq.txn_addr = txn_affinity_addr(d->irq, cpu_irq);
+	eim = ((u32) dino_dev->gsc_irq.txn_addr) | dino_dev->gsc_irq.txn_data;
+	__raw_writel(eim, dino_dev->hba.base_addr+DINO_IAR0);
+
+	irq_data_update_effective_affinity(d, &tmask);
+
+	return IRQ_SET_MASK_OK;
+}
+#endif
+
 static struct irq_chip dino_interrupt_type = {
 	.name		= "GSC-PCI",
 	.irq_unmask	= dino_unmask_irq,
 	.irq_mask	= dino_mask_irq,
+#ifdef CONFIG_SMP
+	.irq_set_affinity = dino_set_affinity_irq,
+#endif
 };
 
 
@@ -806,7 +834,6 @@ static int __init dino_common_init(struct parisc_device *dev,
 {
 	int status;
 	u32 eim;
-	struct gsc_irq gsc_irq;
 	struct resource *res;
 
 	pcibios_register_hba(&dino_dev->hba);
@@ -821,10 +848,8 @@ static int __init dino_common_init(struct parisc_device *dev,
 	**   still only has 11 IRQ input lines - just map some of them
 	**   to a different processor.
 	*/
-	dev->irq = gsc_alloc_irq(&gsc_irq);
-	dino_dev->txn_addr = gsc_irq.txn_addr;
-	dino_dev->txn_data = gsc_irq.txn_data;
-	eim = ((u32) gsc_irq.txn_addr) | gsc_irq.txn_data;
+	dev->irq = gsc_alloc_irq(&dino_dev->gsc_irq);
+	eim = ((u32) dino_dev->gsc_irq.txn_addr) | dino_dev->gsc_irq.txn_data;
 
 	/* 
 	** Dino needs a PA "IRQ" to get a processor's attention.
diff --git a/drivers/parisc/gsc.c b/drivers/parisc/gsc.c
index ed9371acf37e..ec175ae99873 100644
--- a/drivers/parisc/gsc.c
+++ b/drivers/parisc/gsc.c
@@ -135,10 +135,41 @@ static void gsc_asic_unmask_irq(struct irq_data *d)
 	 */
 }
 
+#ifdef CONFIG_SMP
+static int gsc_set_affinity_irq(struct irq_data *d, const struct cpumask *dest,
+				bool force)
+{
+	struct gsc_asic *gsc_dev = irq_data_get_irq_chip_data(d);
+	struct cpumask tmask;
+	int cpu_irq;
+
+	if (!cpumask_and(&tmask, dest, cpu_online_mask))
+		return -EINVAL;
+
+	cpu_irq = cpu_check_affinity(d, &tmask);
+	if (cpu_irq < 0)
+		return cpu_irq;
+
+	gsc_dev->gsc_irq.txn_addr = txn_affinity_addr(d->irq, cpu_irq);
+	gsc_dev->eim = ((u32) gsc_dev->gsc_irq.txn_addr) | gsc_dev->gsc_irq.txn_data;
+
+	/* switch IRQ's for devices below LASI/WAX to other CPU */
+	gsc_writel(gsc_dev->eim, gsc_dev->hpa + OFFSET_IAR);
+
+	irq_data_update_effective_affinity(d, &tmask);
+
+	return IRQ_SET_MASK_OK;
+}
+#endif
+
+
 static struct irq_chip gsc_asic_interrupt_type = {
 	.name		=	"GSC-ASIC",
 	.irq_unmask	=	gsc_asic_unmask_irq,
 	.irq_mask	=	gsc_asic_mask_irq,
+#ifdef CONFIG_SMP
+	.irq_set_affinity =	gsc_set_affinity_irq,
+#endif
 };
 
 int gsc_assign_irq(struct irq_chip *type, void *data)
diff --git a/drivers/parisc/gsc.h b/drivers/parisc/gsc.h
index 86abad3fa215..73cbd0bb1975 100644
--- a/drivers/parisc/gsc.h
+++ b/drivers/parisc/gsc.h
@@ -31,6 +31,7 @@ struct gsc_asic {
 	int version;
 	int type;
 	int eim;
+	struct gsc_irq gsc_irq;
 	int global_irq[32];
 };
 
diff --git a/drivers/parisc/lasi.c b/drivers/parisc/lasi.c
index 4e4fd12c2112..6ef621adb63a 100644
--- a/drivers/parisc/lasi.c
+++ b/drivers/parisc/lasi.c
@@ -163,7 +163,6 @@ static int __init lasi_init_chip(struct parisc_device *dev)
 {
 	extern void (*chassis_power_off)(void);
 	struct gsc_asic *lasi;
-	struct gsc_irq gsc_irq;
 	int ret;
 
 	lasi = kzalloc(sizeof(*lasi), GFP_KERNEL);
@@ -185,7 +184,7 @@ static int __init lasi_init_chip(struct parisc_device *dev)
 	lasi_init_irq(lasi);
 
 	/* the IRQ lasi should use */
-	dev->irq = gsc_alloc_irq(&gsc_irq);
+	dev->irq = gsc_alloc_irq(&lasi->gsc_irq);
 	if (dev->irq < 0) {
 		printk(KERN_ERR "%s(): cannot get GSC irq\n",
 				__func__);
@@ -193,9 +192,9 @@ static int __init lasi_init_chip(struct parisc_device *dev)
 		return -EBUSY;
 	}
 
-	lasi->eim = ((u32) gsc_irq.txn_addr) | gsc_irq.txn_data;
+	lasi->eim = ((u32) lasi->gsc_irq.txn_addr) | lasi->gsc_irq.txn_data;
 
-	ret = request_irq(gsc_irq.irq, gsc_asic_intr, 0, "lasi", lasi);
+	ret = request_irq(lasi->gsc_irq.irq, gsc_asic_intr, 0, "lasi", lasi);
 	if (ret < 0) {
 		kfree(lasi);
 		return ret;
diff --git a/drivers/parisc/wax.c b/drivers/parisc/wax.c
index 5b6df1516235..73a2b01f8d9c 100644
--- a/drivers/parisc/wax.c
+++ b/drivers/parisc/wax.c
@@ -68,7 +68,6 @@ static int __init wax_init_chip(struct parisc_device *dev)
 {
 	struct gsc_asic *wax;
 	struct parisc_device *parent;
-	struct gsc_irq gsc_irq;
 	int ret;
 
 	wax = kzalloc(sizeof(*wax), GFP_KERNEL);
@@ -85,7 +84,7 @@ static int __init wax_init_chip(struct parisc_device *dev)
 	wax_init_irq(wax);
 
 	/* the IRQ wax should use */
-	dev->irq = gsc_claim_irq(&gsc_irq, WAX_GSC_IRQ);
+	dev->irq = gsc_claim_irq(&wax->gsc_irq, WAX_GSC_IRQ);
 	if (dev->irq < 0) {
 		printk(KERN_ERR "%s(): cannot get GSC irq\n",
 				__func__);
@@ -93,9 +92,9 @@ static int __init wax_init_chip(struct parisc_device *dev)
 		return -EBUSY;
 	}
 
-	wax->eim = ((u32) gsc_irq.txn_addr) | gsc_irq.txn_data;
+	wax->eim = ((u32) wax->gsc_irq.txn_addr) | wax->gsc_irq.txn_data;
 
-	ret = request_irq(gsc_irq.irq, gsc_asic_intr, 0, "wax", wax);
+	ret = request_irq(wax->gsc_irq.irq, gsc_asic_intr, 0, "wax", wax);
 	if (ret < 0) {
 		kfree(wax);
 		return ret;
diff --git a/drivers/pci/controller/pci-aardvark.c b/drivers/pci/controller/pci-aardvark.c
index a924564fdbbc..6277b3f3031a 100644
--- a/drivers/pci/controller/pci-aardvark.c
+++ b/drivers/pci/controller/pci-aardvark.c
@@ -1179,7 +1179,7 @@ static void advk_msi_irq_compose_msi_msg(struct irq_data *data,
 
 	msg->address_lo = lower_32_bits(msi_msg);
 	msg->address_hi = upper_32_bits(msi_msg);
-	msg->data = data->irq;
+	msg->data = data->hwirq;
 }
 
 static int advk_msi_set_affinity(struct irq_data *irq_data,
@@ -1196,15 +1196,11 @@ static int advk_msi_irq_domain_alloc(struct irq_domain *domain,
 	int hwirq, i;
 
 	mutex_lock(&pcie->msi_used_lock);
-	hwirq = bitmap_find_next_zero_area(pcie->msi_used, MSI_IRQ_NUM,
-					   0, nr_irqs, 0);
-	if (hwirq >= MSI_IRQ_NUM) {
-		mutex_unlock(&pcie->msi_used_lock);
-		return -ENOSPC;
-	}
-
-	bitmap_set(pcie->msi_used, hwirq, nr_irqs);
+	hwirq = bitmap_find_free_region(pcie->msi_used, MSI_IRQ_NUM,
+					order_base_2(nr_irqs));
 	mutex_unlock(&pcie->msi_used_lock);
+	if (hwirq < 0)
+		return -ENOSPC;
 
 	for (i = 0; i < nr_irqs; i++)
 		irq_domain_set_info(domain, virq + i, hwirq + i,
@@ -1222,7 +1218,7 @@ static void advk_msi_irq_domain_free(struct irq_domain *domain,
 	struct advk_pcie *pcie = domain->host_data;
 
 	mutex_lock(&pcie->msi_used_lock);
-	bitmap_clear(pcie->msi_used, d->hwirq, nr_irqs);
+	bitmap_release_region(pcie->msi_used, d->hwirq, order_base_2(nr_irqs));
 	mutex_unlock(&pcie->msi_used_lock);
 }
 
diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index 90d84d3bc868..5b833f00e980 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -285,7 +285,17 @@ static int pci_epf_test_copy(struct pci_epf_test *epf_test)
 		if (ret)
 			dev_err(dev, "Data transfer failed\n");
 	} else {
-		memcpy(dst_addr, src_addr, reg->size);
+		void *buf;
+
+		buf = kzalloc(reg->size, GFP_KERNEL);
+		if (!buf) {
+			ret = -ENOMEM;
+			goto err_map_addr;
+		}
+
+		memcpy_fromio(buf, src_addr, reg->size);
+		memcpy_toio(dst_addr, buf, reg->size);
+		kfree(buf);
 	}
 	ktime_get_ts64(&end);
 	pci_epf_test_print_rate("COPY", reg->size, &start, &end, use_dma);
@@ -441,7 +451,7 @@ static int pci_epf_test_write(struct pci_epf_test *epf_test)
 		if (!epf_test->dma_supported) {
 			dev_err(dev, "Cannot transfer data using DMA\n");
 			ret = -EINVAL;
-			goto err_map_addr;
+			goto err_dma_map;
 		}
 
 		src_phys_addr = dma_map_single(dma_dev, buf, reg->size,
diff --git a/drivers/pci/hotplug/pciehp_hpc.c b/drivers/pci/hotplug/pciehp_hpc.c
index c0985316649d..8bedbc77fe95 100644
--- a/drivers/pci/hotplug/pciehp_hpc.c
+++ b/drivers/pci/hotplug/pciehp_hpc.c
@@ -1060,6 +1060,8 @@ static void quirk_cmd_compl(struct pci_dev *pdev)
 }
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
 			      PCI_CLASS_BRIDGE_PCI, 8, quirk_cmd_compl);
+DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_QCOM, 0x0110,
+			      PCI_CLASS_BRIDGE_PCI, 8, quirk_cmd_compl);
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_QCOM, 0x0400,
 			      PCI_CLASS_BRIDGE_PCI, 8, quirk_cmd_compl);
 DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_VENDOR_ID_QCOM, 0x0401,
diff --git a/drivers/perf/qcom_l2_pmu.c b/drivers/perf/qcom_l2_pmu.c
index 5b093badd0f6..f60e79fac202 100644
--- a/drivers/perf/qcom_l2_pmu.c
+++ b/drivers/perf/qcom_l2_pmu.c
@@ -736,7 +736,7 @@ static struct cluster_pmu *l2_cache_associate_cpu_with_cluster(
 {
 	u64 mpidr;
 	int cpu_cluster_id;
-	struct cluster_pmu *cluster = NULL;
+	struct cluster_pmu *cluster;
 
 	/*
 	 * This assumes that the cluster_id is in MPIDR[aff1] for
@@ -758,10 +758,10 @@ static struct cluster_pmu *l2_cache_associate_cpu_with_cluster(
 			 cluster->cluster_id);
 		cpumask_set_cpu(cpu, &cluster->cluster_cpus);
 		*per_cpu_ptr(l2cache_pmu->pmu_cluster, cpu) = cluster;
-		break;
+		return cluster;
 	}
 
-	return cluster;
+	return NULL;
 }
 
 static int l2cache_pmu_online_cpu(unsigned int cpu, struct hlist_node *node)
diff --git a/drivers/phy/amlogic/phy-meson-gxl-usb2.c b/drivers/phy/amlogic/phy-meson-gxl-usb2.c
index 2b3c0d730f20..db17c3448bfe 100644
--- a/drivers/phy/amlogic/phy-meson-gxl-usb2.c
+++ b/drivers/phy/amlogic/phy-meson-gxl-usb2.c
@@ -114,8 +114,10 @@ static int phy_meson_gxl_usb2_init(struct phy *phy)
 		return ret;
 
 	ret = clk_prepare_enable(priv->clk);
-	if (ret)
+	if (ret) {
+		reset_control_rearm(priv->reset);
 		return ret;
+	}
 
 	return 0;
 }
@@ -125,6 +127,7 @@ static int phy_meson_gxl_usb2_exit(struct phy *phy)
 	struct phy_meson_gxl_usb2_priv *priv = phy_get_drvdata(phy);
 
 	clk_disable_unprepare(priv->clk);
+	reset_control_rearm(priv->reset);
 
 	return 0;
 }
diff --git a/drivers/phy/amlogic/phy-meson8b-usb2.c b/drivers/phy/amlogic/phy-meson8b-usb2.c
index cf10bed40528..dd96763911b8 100644
--- a/drivers/phy/amlogic/phy-meson8b-usb2.c
+++ b/drivers/phy/amlogic/phy-meson8b-usb2.c
@@ -154,6 +154,7 @@ static int phy_meson8b_usb2_power_on(struct phy *phy)
 	ret = clk_prepare_enable(priv->clk_usb_general);
 	if (ret) {
 		dev_err(&phy->dev, "Failed to enable USB general clock\n");
+		reset_control_rearm(priv->reset);
 		return ret;
 	}
 
@@ -161,6 +162,7 @@ static int phy_meson8b_usb2_power_on(struct phy *phy)
 	if (ret) {
 		dev_err(&phy->dev, "Failed to enable USB DDR clock\n");
 		clk_disable_unprepare(priv->clk_usb_general);
+		reset_control_rearm(priv->reset);
 		return ret;
 	}
 
@@ -199,6 +201,7 @@ static int phy_meson8b_usb2_power_on(struct phy *phy)
 				dev_warn(&phy->dev, "USB ID detect failed!\n");
 				clk_disable_unprepare(priv->clk_usb);
 				clk_disable_unprepare(priv->clk_usb_general);
+				reset_control_rearm(priv->reset);
 				return -EINVAL;
 			}
 		}
@@ -218,6 +221,7 @@ static int phy_meson8b_usb2_power_off(struct phy *phy)
 
 	clk_disable_unprepare(priv->clk_usb);
 	clk_disable_unprepare(priv->clk_usb_general);
+	reset_control_rearm(priv->reset);
 
 	/* power off the PHY by putting it into reset mode */
 	regmap_update_bits(priv->regmap, REG_CTRL, REG_CTRL_POWER_ON_RESET,
@@ -265,8 +269,9 @@ static int phy_meson8b_usb2_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->clk_usb);
 
 	priv->reset = devm_reset_control_get_optional_shared(&pdev->dev, NULL);
-	if (PTR_ERR(priv->reset) == -EPROBE_DEFER)
-		return PTR_ERR(priv->reset);
+	if (IS_ERR(priv->reset))
+		return dev_err_probe(&pdev->dev, PTR_ERR(priv->reset),
+				     "Failed to get the reset line");
 
 	priv->dr_mode = of_usb_get_dr_mode_by_phy(pdev->dev.of_node, -1);
 	if (priv->dr_mode == USB_DR_MODE_UNKNOWN) {
diff --git a/drivers/power/supply/axp20x_battery.c b/drivers/power/supply/axp20x_battery.c
index 18a9db0df4b1..335e12cc5e2f 100644
--- a/drivers/power/supply/axp20x_battery.c
+++ b/drivers/power/supply/axp20x_battery.c
@@ -186,7 +186,6 @@ static int axp20x_battery_get_prop(struct power_supply *psy,
 				   union power_supply_propval *val)
 {
 	struct axp20x_batt_ps *axp20x_batt = power_supply_get_drvdata(psy);
-	struct iio_channel *chan;
 	int ret = 0, reg, val1;
 
 	switch (psp) {
@@ -266,12 +265,12 @@ static int axp20x_battery_get_prop(struct power_supply *psy,
 		if (ret)
 			return ret;
 
-		if (reg & AXP20X_PWR_STATUS_BAT_CHARGING)
-			chan = axp20x_batt->batt_chrg_i;
-		else
-			chan = axp20x_batt->batt_dischrg_i;
-
-		ret = iio_read_channel_processed(chan, &val->intval);
+		if (reg & AXP20X_PWR_STATUS_BAT_CHARGING) {
+			ret = iio_read_channel_processed(axp20x_batt->batt_chrg_i, &val->intval);
+		} else {
+			ret = iio_read_channel_processed(axp20x_batt->batt_dischrg_i, &val1);
+			val->intval = -val1;
+		}
 		if (ret)
 			return ret;
 
diff --git a/drivers/power/supply/axp288_charger.c b/drivers/power/supply/axp288_charger.c
index b9553be9bed5..fb9db7f43895 100644
--- a/drivers/power/supply/axp288_charger.c
+++ b/drivers/power/supply/axp288_charger.c
@@ -41,11 +41,11 @@
 #define VBUS_ISPOUT_CUR_LIM_1500MA	0x1	/* 1500mA */
 #define VBUS_ISPOUT_CUR_LIM_2000MA	0x2	/* 2000mA */
 #define VBUS_ISPOUT_CUR_NO_LIM		0x3	/* 2500mA */
-#define VBUS_ISPOUT_VHOLD_SET_MASK	0x31
+#define VBUS_ISPOUT_VHOLD_SET_MASK	0x38
 #define VBUS_ISPOUT_VHOLD_SET_BIT_POS	0x3
 #define VBUS_ISPOUT_VHOLD_SET_OFFSET	4000	/* 4000mV */
 #define VBUS_ISPOUT_VHOLD_SET_LSB_RES	100	/* 100mV */
-#define VBUS_ISPOUT_VHOLD_SET_4300MV	0x3	/* 4300mV */
+#define VBUS_ISPOUT_VHOLD_SET_4400MV	0x4	/* 4400mV */
 #define VBUS_ISPOUT_VBUS_PATH_DIS	BIT(7)
 
 #define CHRG_CCCV_CC_MASK		0xf		/* 4 bits */
@@ -744,6 +744,16 @@ static int charger_init_hw_regs(struct axp288_chrg_info *info)
 		ret = axp288_charger_vbus_path_select(info, true);
 		if (ret < 0)
 			return ret;
+	} else {
+		/* Set Vhold to the factory default / recommended 4.4V */
+		val = VBUS_ISPOUT_VHOLD_SET_4400MV << VBUS_ISPOUT_VHOLD_SET_BIT_POS;
+		ret = regmap_update_bits(info->regmap, AXP20X_VBUS_IPSOUT_MGMT,
+					 VBUS_ISPOUT_VHOLD_SET_MASK, val);
+		if (ret < 0) {
+			dev_err(&info->pdev->dev, "register(%x) write error(%d)\n",
+				AXP20X_VBUS_IPSOUT_MGMT, ret);
+			return ret;
+		}
 	}
 
 	/* Read current charge voltage and current limit */
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 41b92dc2f011..9233bfedeb17 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -14,7 +14,7 @@ static ssize_t clock_name_show(struct device *dev,
 			       struct device_attribute *attr, char *page)
 {
 	struct ptp_clock *ptp = dev_get_drvdata(dev);
-	return snprintf(page, PAGE_SIZE-1, "%s\n", ptp->info->name);
+	return sysfs_emit(page, "%s\n", ptp->info->name);
 }
 static DEVICE_ATTR_RO(clock_name);
 
@@ -387,7 +387,7 @@ static ssize_t ptp_pin_show(struct device *dev, struct device_attribute *attr,
 
 	mutex_unlock(&ptp->pincfg_mux);
 
-	return snprintf(page, PAGE_SIZE, "%u %u\n", func, chan);
+	return sysfs_emit(page, "%u %u\n", func, chan);
 }
 
 static ssize_t ptp_pin_store(struct device *dev, struct device_attribute *attr,
diff --git a/drivers/regulator/atc260x-regulator.c b/drivers/regulator/atc260x-regulator.c
index 05147d2c3842..485e58b264c0 100644
--- a/drivers/regulator/atc260x-regulator.c
+++ b/drivers/regulator/atc260x-regulator.c
@@ -292,6 +292,7 @@ enum atc2603c_reg_ids {
 	.bypass_mask = BIT(5), \
 	.active_discharge_reg = ATC2603C_PMU_SWITCH_CTL, \
 	.active_discharge_mask = BIT(1), \
+	.active_discharge_on = BIT(1), \
 	.owner = THIS_MODULE, \
 }
 
diff --git a/drivers/regulator/rtq2134-regulator.c b/drivers/regulator/rtq2134-regulator.c
index f21e3f8b21f2..8e13dea354a2 100644
--- a/drivers/regulator/rtq2134-regulator.c
+++ b/drivers/regulator/rtq2134-regulator.c
@@ -285,6 +285,7 @@ static const unsigned int rtq2134_buck_ramp_delay_table[] = {
 		.enable_mask = RTQ2134_VOUTEN_MASK, \
 		.active_discharge_reg = RTQ2134_REG_BUCK##_id##_CFG0, \
 		.active_discharge_mask = RTQ2134_ACTDISCHG_MASK, \
+		.active_discharge_on = RTQ2134_ACTDISCHG_MASK, \
 		.ramp_reg = RTQ2134_REG_BUCK##_id##_RSPCFG, \
 		.ramp_mask = RTQ2134_RSPUP_MASK, \
 		.ramp_delay_table = rtq2134_buck_ramp_delay_table, \
diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index dc3f8b0dde98..b90a603d6b12 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -222,6 +222,8 @@ static inline void cmos_write_bank2(unsigned char val, unsigned char addr)
 
 static int cmos_read_time(struct device *dev, struct rtc_time *t)
 {
+	int ret;
+
 	/*
 	 * If pm_trace abused the RTC for storage, set the timespec to 0,
 	 * which tells the caller that this RTC value is unusable.
@@ -229,7 +231,12 @@ static int cmos_read_time(struct device *dev, struct rtc_time *t)
 	if (!pm_trace_rtc_valid())
 		return -EIO;
 
-	mc146818_get_time(t);
+	ret = mc146818_get_time(t);
+	if (ret < 0) {
+		dev_err_ratelimited(dev, "unable to read current time\n");
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -793,16 +800,14 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 
 	rename_region(ports, dev_name(&cmos_rtc.rtc->dev));
 
-	spin_lock_irq(&rtc_lock);
-
-	/* Ensure that the RTC is accessible. Bit 6 must be 0! */
-	if ((CMOS_READ(RTC_VALID) & 0x40) != 0) {
-		spin_unlock_irq(&rtc_lock);
-		dev_warn(dev, "not accessible\n");
+	if (!mc146818_does_rtc_work()) {
+		dev_warn(dev, "broken or not accessible\n");
 		retval = -ENXIO;
 		goto cleanup1;
 	}
 
+	spin_lock_irq(&rtc_lock);
+
 	if (!(flags & CMOS_RTC_FLAGS_NOFREQ)) {
 		/* force periodic irq to CMOS reset default of 1024Hz;
 		 *
diff --git a/drivers/rtc/rtc-mc146818-lib.c b/drivers/rtc/rtc-mc146818-lib.c
index 04b05e3b68cb..8abac672f3cb 100644
--- a/drivers/rtc/rtc-mc146818-lib.c
+++ b/drivers/rtc/rtc-mc146818-lib.c
@@ -8,10 +8,36 @@
 #include <linux/acpi.h>
 #endif
 
-unsigned int mc146818_get_time(struct rtc_time *time)
+/*
+ * If the UIP (Update-in-progress) bit of the RTC is set for more then
+ * 10ms, the RTC is apparently broken or not present.
+ */
+bool mc146818_does_rtc_work(void)
+{
+	int i;
+	unsigned char val;
+	unsigned long flags;
+
+	for (i = 0; i < 10; i++) {
+		spin_lock_irqsave(&rtc_lock, flags);
+		val = CMOS_READ(RTC_FREQ_SELECT);
+		spin_unlock_irqrestore(&rtc_lock, flags);
+
+		if ((val & RTC_UIP) == 0)
+			return true;
+
+		mdelay(1);
+	}
+
+	return false;
+}
+EXPORT_SYMBOL_GPL(mc146818_does_rtc_work);
+
+int mc146818_get_time(struct rtc_time *time)
 {
 	unsigned char ctrl;
 	unsigned long flags;
+	unsigned int iter_count = 0;
 	unsigned char century = 0;
 	bool retry;
 
@@ -20,13 +46,13 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 #endif
 
 again:
-	spin_lock_irqsave(&rtc_lock, flags);
-	/* Ensure that the RTC is accessible. Bit 6 must be 0! */
-	if (WARN_ON_ONCE((CMOS_READ(RTC_VALID) & 0x40) != 0)) {
-		spin_unlock_irqrestore(&rtc_lock, flags);
-		memset(time, 0xff, sizeof(*time));
-		return 0;
+	if (iter_count > 10) {
+		memset(time, 0, sizeof(*time));
+		return -EIO;
 	}
+	iter_count++;
+
+	spin_lock_irqsave(&rtc_lock, flags);
 
 	/*
 	 * Check whether there is an update in progress during which the
@@ -116,7 +142,7 @@ unsigned int mc146818_get_time(struct rtc_time *time)
 
 	time->tm_mon--;
 
-	return RTC_24H;
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mc146818_get_time);
 
diff --git a/drivers/rtc/rtc-wm8350.c b/drivers/rtc/rtc-wm8350.c
index 2018614f258f..6eaa9321c074 100644
--- a/drivers/rtc/rtc-wm8350.c
+++ b/drivers/rtc/rtc-wm8350.c
@@ -432,14 +432,21 @@ static int wm8350_rtc_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	wm8350_register_irq(wm8350, WM8350_IRQ_RTC_SEC,
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_RTC_SEC,
 			    wm8350_rtc_update_handler, 0,
 			    "RTC Seconds", wm8350);
+	if (ret)
+		return ret;
+
 	wm8350_mask_irq(wm8350, WM8350_IRQ_RTC_SEC);
 
-	wm8350_register_irq(wm8350, WM8350_IRQ_RTC_ALM,
+	ret = wm8350_register_irq(wm8350, WM8350_IRQ_RTC_ALM,
 			    wm8350_rtc_alarm_handler, 0,
 			    "RTC Alarm", wm8350);
+	if (ret) {
+		wm8350_free_irq(wm8350, WM8350_IRQ_RTC_SEC, wm8350);
+		return ret;
+	}
 
 	return 0;
 }
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index b13b5c85f3de..75a5a4765f42 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -3370,13 +3370,11 @@ static int __init aha152x_setup(char *str)
 	setup[setup_count].synchronous = ints[0] >= 6 ? ints[6] : 1;
 	setup[setup_count].delay       = ints[0] >= 7 ? ints[7] : DELAY_DEFAULT;
 	setup[setup_count].ext_trans   = ints[0] >= 8 ? ints[8] : 0;
-	if (ints[0] > 8) {                                                /*}*/
+	if (ints[0] > 8)
 		printk(KERN_NOTICE "aha152x: usage: aha152x=<IOBASE>[,<IRQ>[,<SCSI ID>"
 		       "[,<RECONNECT>[,<PARITY>[,<SYNCHRONOUS>[,<DELAY>[,<EXT_TRANS>]]]]]]]\n");
-	} else {
+	else
 		setup_count++;
-		return 0;
-	}
 
 	return 1;
 }
diff --git a/drivers/scsi/bfa/bfad_attr.c b/drivers/scsi/bfa/bfad_attr.c
index 5ae1e3f78910..e049cdb3c286 100644
--- a/drivers/scsi/bfa/bfad_attr.c
+++ b/drivers/scsi/bfa/bfad_attr.c
@@ -711,7 +711,7 @@ bfad_im_serial_num_show(struct device *dev, struct device_attribute *attr,
 	char serial_num[BFA_ADAPTER_SERIAL_NUM_LEN];
 
 	bfa_get_adapter_serial_num(&bfad->bfa, serial_num);
-	return snprintf(buf, PAGE_SIZE, "%s\n", serial_num);
+	return sysfs_emit(buf, "%s\n", serial_num);
 }
 
 static ssize_t
@@ -725,7 +725,7 @@ bfad_im_model_show(struct device *dev, struct device_attribute *attr,
 	char model[BFA_ADAPTER_MODEL_NAME_LEN];
 
 	bfa_get_adapter_model(&bfad->bfa, model);
-	return snprintf(buf, PAGE_SIZE, "%s\n", model);
+	return sysfs_emit(buf, "%s\n", model);
 }
 
 static ssize_t
@@ -805,7 +805,7 @@ bfad_im_model_desc_show(struct device *dev, struct device_attribute *attr,
 		snprintf(model_descr, BFA_ADAPTER_MODEL_DESCR_LEN,
 			"Invalid Model");
 
-	return snprintf(buf, PAGE_SIZE, "%s\n", model_descr);
+	return sysfs_emit(buf, "%s\n", model_descr);
 }
 
 static ssize_t
@@ -819,7 +819,7 @@ bfad_im_node_name_show(struct device *dev, struct device_attribute *attr,
 	u64        nwwn;
 
 	nwwn = bfa_fcs_lport_get_nwwn(port->fcs_port);
-	return snprintf(buf, PAGE_SIZE, "0x%llx\n", cpu_to_be64(nwwn));
+	return sysfs_emit(buf, "0x%llx\n", cpu_to_be64(nwwn));
 }
 
 static ssize_t
@@ -836,7 +836,7 @@ bfad_im_symbolic_name_show(struct device *dev, struct device_attribute *attr,
 	bfa_fcs_lport_get_attr(&bfad->bfa_fcs.fabric.bport, &port_attr);
 	strlcpy(symname, port_attr.port_cfg.sym_name.symname,
 			BFA_SYMNAME_MAXLEN);
-	return snprintf(buf, PAGE_SIZE, "%s\n", symname);
+	return sysfs_emit(buf, "%s\n", symname);
 }
 
 static ssize_t
@@ -850,14 +850,14 @@ bfad_im_hw_version_show(struct device *dev, struct device_attribute *attr,
 	char hw_ver[BFA_VERSION_LEN];
 
 	bfa_get_pci_chip_rev(&bfad->bfa, hw_ver);
-	return snprintf(buf, PAGE_SIZE, "%s\n", hw_ver);
+	return sysfs_emit(buf, "%s\n", hw_ver);
 }
 
 static ssize_t
 bfad_im_drv_version_show(struct device *dev, struct device_attribute *attr,
 				char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", BFAD_DRIVER_VERSION);
+	return sysfs_emit(buf, "%s\n", BFAD_DRIVER_VERSION);
 }
 
 static ssize_t
@@ -871,7 +871,7 @@ bfad_im_optionrom_version_show(struct device *dev,
 	char optrom_ver[BFA_VERSION_LEN];
 
 	bfa_get_adapter_optrom_ver(&bfad->bfa, optrom_ver);
-	return snprintf(buf, PAGE_SIZE, "%s\n", optrom_ver);
+	return sysfs_emit(buf, "%s\n", optrom_ver);
 }
 
 static ssize_t
@@ -885,7 +885,7 @@ bfad_im_fw_version_show(struct device *dev, struct device_attribute *attr,
 	char fw_ver[BFA_VERSION_LEN];
 
 	bfa_get_adapter_fw_ver(&bfad->bfa, fw_ver);
-	return snprintf(buf, PAGE_SIZE, "%s\n", fw_ver);
+	return sysfs_emit(buf, "%s\n", fw_ver);
 }
 
 static ssize_t
@@ -897,7 +897,7 @@ bfad_im_num_of_ports_show(struct device *dev, struct device_attribute *attr,
 			(struct bfad_im_port_s *) shost->hostdata[0];
 	struct bfad_s *bfad = im_port->bfad;
 
-	return snprintf(buf, PAGE_SIZE, "%d\n",
+	return sysfs_emit(buf, "%d\n",
 			bfa_get_nports(&bfad->bfa));
 }
 
@@ -905,7 +905,7 @@ static ssize_t
 bfad_im_drv_name_show(struct device *dev, struct device_attribute *attr,
 				char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%s\n", BFAD_DRIVER_NAME);
+	return sysfs_emit(buf, "%s\n", BFAD_DRIVER_NAME);
 }
 
 static ssize_t
@@ -924,14 +924,14 @@ bfad_im_num_of_discovered_ports_show(struct device *dev,
 	rports = kcalloc(nrports, sizeof(struct bfa_rport_qualifier_s),
 			 GFP_ATOMIC);
 	if (rports == NULL)
-		return snprintf(buf, PAGE_SIZE, "Failed\n");
+		return sysfs_emit(buf, "Failed\n");
 
 	spin_lock_irqsave(&bfad->bfad_lock, flags);
 	bfa_fcs_lport_get_rport_quals(port->fcs_port, rports, &nrports);
 	spin_unlock_irqrestore(&bfad->bfad_lock, flags);
 	kfree(rports);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", nrports);
+	return sysfs_emit(buf, "%d\n", nrports);
 }
 
 static          DEVICE_ATTR(serial_number, S_IRUGO,
diff --git a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
index 1942970f9eb7..1f5e0688c0c8 100644
--- a/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
+++ b/drivers/scsi/hisi_sas/hisi_sas_v3_hw.c
@@ -2392,17 +2392,25 @@ static irqreturn_t cq_interrupt_v3_hw(int irq_no, void *p)
 	return IRQ_WAKE_THREAD;
 }
 
+static void hisi_sas_v3_free_vectors(void *data)
+{
+	struct pci_dev *pdev = data;
+
+	pci_free_irq_vectors(pdev);
+}
+
 static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 {
 	int vectors;
 	int max_msi = HISI_SAS_MSI_COUNT_V3_HW, min_msi;
 	struct Scsi_Host *shost = hisi_hba->shost;
+	struct pci_dev *pdev = hisi_hba->pci_dev;
 	struct irq_affinity desc = {
 		.pre_vectors = BASE_VECTORS_V3_HW,
 	};
 
 	min_msi = MIN_AFFINE_VECTORS_V3_HW;
-	vectors = pci_alloc_irq_vectors_affinity(hisi_hba->pci_dev,
+	vectors = pci_alloc_irq_vectors_affinity(pdev,
 						 min_msi, max_msi,
 						 PCI_IRQ_MSI |
 						 PCI_IRQ_AFFINITY,
@@ -2414,6 +2422,7 @@ static int interrupt_preinit_v3_hw(struct hisi_hba *hisi_hba)
 	hisi_hba->cq_nvecs = vectors - BASE_VECTORS_V3_HW;
 	shost->nr_hw_queues = hisi_hba->cq_nvecs;
 
+	devm_add_action(&pdev->dev, hisi_sas_v3_free_vectors, pdev);
 	return 0;
 }
 
@@ -3959,6 +3968,54 @@ static const struct file_operations debugfs_bist_phy_v3_hw_fops = {
 	.owner = THIS_MODULE,
 };
 
+static ssize_t debugfs_bist_cnt_v3_hw_write(struct file *filp,
+					const char __user *buf,
+					size_t count, loff_t *ppos)
+{
+	struct seq_file *m = filp->private_data;
+	struct hisi_hba *hisi_hba = m->private;
+	unsigned int cnt;
+	int val;
+
+	if (hisi_hba->debugfs_bist_enable)
+		return -EPERM;
+
+	val = kstrtouint_from_user(buf, count, 0, &cnt);
+	if (val)
+		return val;
+
+	if (cnt)
+		return -EINVAL;
+
+	hisi_hba->debugfs_bist_cnt = 0;
+	return count;
+}
+
+static int debugfs_bist_cnt_v3_hw_show(struct seq_file *s, void *p)
+{
+	struct hisi_hba *hisi_hba = s->private;
+
+	seq_printf(s, "%u\n", hisi_hba->debugfs_bist_cnt);
+
+	return 0;
+}
+
+static int debugfs_bist_cnt_v3_hw_open(struct inode *inode,
+					  struct file *filp)
+{
+	return single_open(filp, debugfs_bist_cnt_v3_hw_show,
+			   inode->i_private);
+}
+
+static const struct file_operations debugfs_bist_cnt_v3_hw_ops = {
+	.open = debugfs_bist_cnt_v3_hw_open,
+	.read = seq_read,
+	.write = debugfs_bist_cnt_v3_hw_write,
+	.llseek = seq_lseek,
+	.release = single_release,
+	.owner = THIS_MODULE,
+};
+
 static const struct {
 	int		value;
 	char		*name;
@@ -4596,8 +4653,8 @@ static void debugfs_bist_init_v3_hw(struct hisi_hba *hisi_hba)
 	debugfs_create_file("phy_id", 0600, hisi_hba->debugfs_bist_dentry,
 			    hisi_hba, &debugfs_bist_phy_v3_hw_fops);
 
-	debugfs_create_u32("cnt", 0600, hisi_hba->debugfs_bist_dentry,
-			   &hisi_hba->debugfs_bist_cnt);
+	debugfs_create_file("cnt", 0600, hisi_hba->debugfs_bist_dentry,
+			    hisi_hba, &debugfs_bist_cnt_v3_hw_ops);
 
 	debugfs_create_file("loopback_mode", 0600,
 			    hisi_hba->debugfs_bist_dentry,
@@ -4763,7 +4820,7 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	dev_err(dev, "%d hw queues\n", shost->nr_hw_queues);
 	rc = scsi_add_host(shost, dev);
 	if (rc)
-		goto err_out_free_irq_vectors;
+		goto err_out_debugfs;
 
 	rc = sas_register_ha(sha);
 	if (rc)
@@ -4792,8 +4849,6 @@ hisi_sas_v3_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sas_unregister_ha(sha);
 err_out_register_ha:
 	scsi_remove_host(shost);
-err_out_free_irq_vectors:
-	pci_free_irq_vectors(pdev);
 err_out_debugfs:
 	debugfs_exit_v3_hw(hisi_hba);
 err_out_ha:
@@ -4821,7 +4876,6 @@ hisi_sas_v3_destroy_irqs(struct pci_dev *pdev, struct hisi_hba *hisi_hba)
 
 		devm_free_irq(&pdev->dev, pci_irq_vector(pdev, nr), cq);
 	}
-	pci_free_irq_vectors(pdev);
 }
 
 static void hisi_sas_v3_remove(struct pci_dev *pdev)
diff --git a/drivers/scsi/libfc/fc_exch.c b/drivers/scsi/libfc/fc_exch.c
index 841000445b9a..aa223db4cf53 100644
--- a/drivers/scsi/libfc/fc_exch.c
+++ b/drivers/scsi/libfc/fc_exch.c
@@ -1701,6 +1701,7 @@ static void fc_exch_abts_resp(struct fc_exch *ep, struct fc_frame *fp)
 	if (cancel_delayed_work_sync(&ep->timeout_work)) {
 		FC_EXCH_DBG(ep, "Exchange timer canceled due to ABTS response\n");
 		fc_exch_release(ep);	/* release from pending timer hold */
+		return;
 	}
 
 	spin_lock_bh(&ep->ex_lock);
diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 5af36c54cb59..3ef6b6edef46 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1275,7 +1275,7 @@ static void mpi3mr_free_op_req_q_segments(struct mpi3mr_ioc *mrioc, u16 q_idx)
 			    MPI3MR_MAX_SEG_LIST_SIZE,
 			    mrioc->req_qinfo[q_idx].q_segment_list,
 			    mrioc->req_qinfo[q_idx].q_segment_list_dma);
-			mrioc->op_reply_qinfo[q_idx].q_segment_list = NULL;
+			mrioc->req_qinfo[q_idx].q_segment_list = NULL;
 		}
 	} else
 		size = mrioc->req_qinfo[q_idx].segment_qd *
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 3cae8803383b..b2c650542bac 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2204,6 +2204,8 @@ void mpi3mr_process_op_reply_desc(struct mpi3mr_ioc *mrioc,
 		scmd->result = DID_OK << 16;
 		goto out_success;
 	}
+
+	scsi_set_resid(scmd, scsi_bufflen(scmd) - xfer_count);
 	if (ioc_status == MPI3_IOCSTATUS_SCSI_DATA_UNDERRUN &&
 	    xfer_count == 0 && (scsi_status == MPI3_SCSI_STATUS_BUSY ||
 	    scsi_status == MPI3_SCSI_STATUS_RESERVATION_CONFLICT ||
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index c1f900c6ea00..af275ac42795 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -11035,6 +11035,7 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
 {
 	struct _sas_port *mpt3sas_port, *next;
 	unsigned long flags;
+	int port_id;
 
 	/* remove sibling ports attached to this expander */
 	list_for_each_entry_safe(mpt3sas_port, next,
@@ -11055,6 +11056,8 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
 			    mpt3sas_port->hba_port);
 	}
 
+	port_id = sas_expander->port->port_id;
+
 	mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
 	    sas_expander->sas_address_parent, sas_expander->port);
 
@@ -11062,7 +11065,7 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
 	    "expander_remove: handle(0x%04x), sas_addr(0x%016llx), port:%d\n",
 	    sas_expander->handle, (unsigned long long)
 	    sas_expander->sas_address,
-	    sas_expander->port->port_id);
+	    port_id);
 
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	list_del(&sas_expander->list);
diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index f18dd9703595..787cf439ba57 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -696,7 +696,7 @@ static struct pci_driver mvs_pci_driver = {
 static ssize_t driver_version_show(struct device *cdev,
 				   struct device_attribute *attr, char *buffer)
 {
-	return snprintf(buffer, PAGE_SIZE, "%s\n", DRV_VERSION);
+	return sysfs_emit(buffer, "%s\n", DRV_VERSION);
 }
 
 static DEVICE_ATTR_RO(driver_version);
@@ -744,7 +744,7 @@ static ssize_t interrupt_coalescing_store(struct device *cdev,
 static ssize_t interrupt_coalescing_show(struct device *cdev,
 					 struct device_attribute *attr, char *buffer)
 {
-	return snprintf(buffer, PAGE_SIZE, "%d\n", interrupt_coalescing);
+	return sysfs_emit(buffer, "%d\n", interrupt_coalescing);
 }
 
 static DEVICE_ATTR_RW(interrupt_coalescing);
diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index bed06ed0f1cb..32fc450bf84b 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -1767,7 +1767,6 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	}
 
 	task = sas_alloc_slow_task(GFP_ATOMIC);
-
 	if (!task) {
 		pm8001_dbg(pm8001_ha, FAIL, "cannot allocate task\n");
 		return;
@@ -1776,8 +1775,10 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 	task->task_done = pm8001_task_done;
 
 	res = pm8001_tag_alloc(pm8001_ha, &ccb_tag);
-	if (res)
+	if (res) {
+		sas_free_task(task);
 		return;
+	}
 
 	ccb = &pm8001_ha->ccb_info[ccb_tag];
 	ccb->device = pm8001_ha_dev;
@@ -1794,8 +1795,10 @@ static void pm8001_send_abort_all(struct pm8001_hba_info *pm8001_ha,
 
 	ret = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &task_abort,
 			sizeof(task_abort), 0);
-	if (ret)
+	if (ret) {
+		sas_free_task(task);
 		pm8001_tag_free(pm8001_ha, ccb_tag);
+	}
 
 }
 
@@ -3713,12 +3716,11 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_info *pm8001_ha, void *piomb)
 	mb();
 
 	if (pm8001_dev->id & NCQ_ABORT_ALL_FLAG) {
-		pm8001_tag_free(pm8001_ha, tag);
 		sas_free_task(t);
-		/* clear the flag */
-		pm8001_dev->id &= 0xBFFFFFFF;
-	} else
+		pm8001_dev->id &= ~NCQ_ABORT_ALL_FLAG;
+	} else {
 		t->task_done(t);
+	}
 
 	return 0;
 }
@@ -4486,6 +4488,9 @@ static int pm8001_chip_reg_dev_req(struct pm8001_hba_info *pm8001_ha,
 		SAS_ADDR_SIZE);
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
 	return rc;
 }
 
@@ -4898,6 +4903,11 @@ pm8001_chip_fw_flash_update_req(struct pm8001_hba_info *pm8001_ha,
 	ccb->ccb_tag = tag;
 	rc = pm8001_chip_fw_flash_update_build(pm8001_ha, &flash_update_info,
 		tag);
+	if (rc) {
+		kfree(fw_control_context);
+		pm8001_tag_free(pm8001_ha, tag);
+	}
+
 	return rc;
 }
 
@@ -5002,6 +5012,9 @@ pm8001_chip_set_dev_state_req(struct pm8001_hba_info *pm8001_ha,
 	payload.nds = cpu_to_le32(state);
 	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
 			sizeof(payload), 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
 	return rc;
 
 }
diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 491cecbbe1aa..5fb08acbc0e5 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -831,10 +831,10 @@ pm8001_exec_internal_task_abort(struct pm8001_hba_info *pm8001_ha,
 
 		res = PM8001_CHIP_DISP->task_abort(pm8001_ha,
 			pm8001_dev, flag, task_tag, ccb_tag);
-
 		if (res) {
 			del_timer(&task->slow_task->timer);
 			pm8001_dbg(pm8001_ha, FAIL, "Executing internal task failed\n");
+			pm8001_tag_free(pm8001_ha, ccb_tag);
 			goto ex_err;
 		}
 		wait_for_completion(&task->slow_task->completion);
diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index b0a108e1a3d9..5561057109de 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -66,18 +66,16 @@ int pm80xx_bar4_shift(struct pm8001_hba_info *pm8001_ha, u32 shift_value)
 }
 
 static void pm80xx_pci_mem_copy(struct pm8001_hba_info  *pm8001_ha, u32 soffset,
-				const void *destination,
+				__le32 *destination,
 				u32 dw_count, u32 bus_base_number)
 {
 	u32 index, value, offset;
-	u32 *destination1;
-	destination1 = (u32 *)destination;
 
-	for (index = 0; index < dw_count; index += 4, destination1++) {
+	for (index = 0; index < dw_count; index += 4, destination++) {
 		offset = (soffset + index);
 		if (offset < (64 * 1024)) {
 			value = pm8001_cr32(pm8001_ha, bus_base_number, offset);
-			*destination1 =  cpu_to_le32(value);
+			*destination = cpu_to_le32(value);
 		}
 	}
 	return;
@@ -4922,8 +4920,13 @@ static int pm80xx_chip_phy_ctl_req(struct pm8001_hba_info *pm8001_ha,
 	payload.tag = cpu_to_le32(tag);
 	payload.phyop_phyid =
 		cpu_to_le32(((phy_op & 0xFF) << 8) | (phyId & 0xFF));
-	return pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
-			sizeof(payload), 0);
+
+	rc = pm8001_mpi_build_cmd(pm8001_ha, circularQ, opc, &payload,
+				  sizeof(payload), 0);
+	if (rc)
+		pm8001_tag_free(pm8001_ha, tag);
+
+	return rc;
 }
 
 static u32 pm80xx_chip_is_our_interrupt(struct pm8001_hba_info *pm8001_ha)
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 7266880c70c2..9466474ff01b 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -207,6 +207,8 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
 	int ret;
 	struct sbitmap sb_backup;
 
+	depth = min_t(unsigned int, depth, scsi_device_max_queue_depth(sdev));
+
 	/*
 	 * realloc if new shift is calculated, which is caused by setting
 	 * up one new default queue depth after calling ->slave_configure
@@ -229,6 +231,9 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
 				scsi_device_max_queue_depth(sdev),
 				new_shift, GFP_KERNEL,
 				sdev->request_queue->node, false, true);
+	if (!ret)
+		sbitmap_resize(&sdev->budget_map, depth);
+
 	if (need_free) {
 		if (ret)
 			sdev->budget_map = sb_backup;
diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index a5453f5e87c3..2e690d8a3444 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -7653,6 +7653,21 @@ static int pqi_force_sis_mode(struct pqi_ctrl_info *ctrl_info)
 	return pqi_revert_to_sis_mode(ctrl_info);
 }
 
+static void pqi_perform_lockup_action(void)
+{
+	switch (pqi_lockup_action) {
+	case PANIC:
+		panic("FATAL: Smart Family Controller lockup detected");
+		break;
+	case REBOOT:
+		emergency_restart();
+		break;
+	case NONE:
+	default:
+		break;
+	}
+}
+
 static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 {
 	int rc;
@@ -7677,8 +7692,15 @@ static int pqi_ctrl_init(struct pqi_ctrl_info *ctrl_info)
 	 * commands.
 	 */
 	rc = sis_wait_for_ctrl_ready(ctrl_info);
-	if (rc)
+	if (rc) {
+		if (reset_devices) {
+			dev_err(&ctrl_info->pci_dev->dev,
+				"kdump init failed with error %d\n", rc);
+			pqi_lockup_action = REBOOT;
+			pqi_perform_lockup_action();
+		}
 		return rc;
+	}
 
 	/*
 	 * Get the controller properties.  This allows us to determine
@@ -8402,21 +8424,6 @@ static int pqi_ofa_ctrl_restart(struct pqi_ctrl_info *ctrl_info, unsigned int de
 	return pqi_ctrl_init_resume(ctrl_info);
 }
 
-static void pqi_perform_lockup_action(void)
-{
-	switch (pqi_lockup_action) {
-	case PANIC:
-		panic("FATAL: Smart Family Controller lockup detected");
-		break;
-	case REBOOT:
-		emergency_restart();
-		break;
-	case NONE:
-	default:
-		break;
-	}
-}
-
 static struct pqi_raid_error_info pqi_ctrl_offline_raid_error_info = {
 	.data_out_result = PQI_DATA_IN_OUT_HARDWARE_ERROR,
 	.status = SAM_STAT_CHECK_CONDITION,
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 973d6e079b02..652cd81d7775 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -579,7 +579,7 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 
 	scsi_autopm_get_device(sdev);
 
-	if (ret != CDROMCLOSETRAY && ret != CDROMEJECT) {
+	if (cmd != CDROMCLOSETRAY && cmd != CDROMEJECT) {
 		ret = cdrom_ioctl(&cd->cdi, bdev, mode, cmd, arg);
 		if (ret != -ENOSYS)
 			goto put;
diff --git a/drivers/scsi/ufs/ufshcd-pci.c b/drivers/scsi/ufs/ufshcd-pci.c
index f76692053ca1..e892b9feffb1 100644
--- a/drivers/scsi/ufs/ufshcd-pci.c
+++ b/drivers/scsi/ufs/ufshcd-pci.c
@@ -428,6 +428,12 @@ static int ufs_intel_adl_init(struct ufs_hba *hba)
 	return ufs_intel_common_init(hba);
 }
 
+static int ufs_intel_mtl_init(struct ufs_hba *hba)
+{
+	hba->caps |= UFSHCD_CAP_CRYPTO | UFSHCD_CAP_WB_EN;
+	return ufs_intel_common_init(hba);
+}
+
 static struct ufs_hba_variant_ops ufs_intel_cnl_hba_vops = {
 	.name                   = "intel-pci",
 	.init			= ufs_intel_common_init,
@@ -465,6 +471,16 @@ static struct ufs_hba_variant_ops ufs_intel_adl_hba_vops = {
 	.device_reset		= ufs_intel_device_reset,
 };
 
+static struct ufs_hba_variant_ops ufs_intel_mtl_hba_vops = {
+	.name                   = "intel-pci",
+	.init			= ufs_intel_mtl_init,
+	.exit			= ufs_intel_common_exit,
+	.hce_enable_notify	= ufs_intel_hce_enable_notify,
+	.link_startup_notify	= ufs_intel_link_startup_notify,
+	.resume			= ufs_intel_resume,
+	.device_reset		= ufs_intel_device_reset,
+};
+
 #ifdef CONFIG_PM_SLEEP
 static int ufshcd_pci_restore(struct device *dev)
 {
@@ -579,6 +595,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x98FA), (kernel_ulong_t)&ufs_intel_lkf_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x51FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
 	{ PCI_VDEVICE(INTEL, 0x54FF), (kernel_ulong_t)&ufs_intel_adl_hba_vops },
+	{ PCI_VDEVICE(INTEL, 0x7E47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
 	{ }	/* terminate list */
 };
 
diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index a86d0cc50de2..f7eaf64293a4 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -870,12 +870,6 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
 	struct ufshpb_region *rgn, *victim_rgn = NULL;
 
 	list_for_each_entry(rgn, &lru_info->lh_lru_rgn, list_lru_rgn) {
-		if (!rgn) {
-			dev_err(&hpb->sdev_ufs_lu->sdev_dev,
-				"%s: no region allocated\n",
-				__func__);
-			return NULL;
-		}
 		if (ufshpb_check_srgns_issue_state(hpb, rgn))
 			continue;
 
@@ -891,6 +885,11 @@ static struct ufshpb_region *ufshpb_victim_lru_info(struct ufshpb_lu *hpb)
 		break;
 	}
 
+	if (!victim_rgn)
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+			"%s: no region allocated\n",
+			__func__);
+
 	return victim_rgn;
 }
 
diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 27b9e2baab1a..7acf9193a9e8 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -159,6 +159,8 @@ static void zorro7xx_remove_one(struct zorro_dev *z)
 	scsi_remove_host(host);
 
 	NCR_700_release(host);
+	if (host->base > 0x01000000)
+		iounmap(hostdata->base);
 	kfree(hostdata);
 	free_irq(host->irq, host);
 	zorro_release_device(z);
diff --git a/drivers/spi/spi-bcm-qspi.c b/drivers/spi/spi-bcm-qspi.c
index ae8c86be7786..bd7c7fc73961 100644
--- a/drivers/spi/spi-bcm-qspi.c
+++ b/drivers/spi/spi-bcm-qspi.c
@@ -1033,7 +1033,7 @@ static int bcm_qspi_exec_mem_op(struct spi_mem *mem,
 	addr = op->addr.val;
 	len = op->data.nbytes;
 
-	if (bcm_qspi_bspi_ver_three(qspi) == true) {
+	if (has_bspi(qspi) && bcm_qspi_bspi_ver_three(qspi) == true) {
 		/*
 		 * The address coming into this function is a raw flash offset.
 		 * But for BSPI <= V3, we need to convert it to a remapped BSPI
@@ -1052,7 +1052,7 @@ static int bcm_qspi_exec_mem_op(struct spi_mem *mem,
 	    len < 4)
 		mspi_read = true;
 
-	if (mspi_read)
+	if (!has_bspi(qspi) || mspi_read)
 		return bcm_qspi_mspi_exec_mem_op(spi, op);
 
 	ret = bcm_qspi_bspi_set_mode(qspi, op, 0);
diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index cb7eb1e2e0e9..d0bbf8f9414d 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -1072,11 +1072,15 @@ static int __spi_unmap_msg(struct spi_controller *ctlr, struct spi_message *msg)
 
 	if (ctlr->dma_tx)
 		tx_dev = ctlr->dma_tx->device->dev;
+	else if (ctlr->dma_map_dev)
+		tx_dev = ctlr->dma_map_dev;
 	else
 		tx_dev = ctlr->dev.parent;
 
 	if (ctlr->dma_rx)
 		rx_dev = ctlr->dma_rx->device->dev;
+	else if (ctlr->dma_map_dev)
+		rx_dev = ctlr->dma_map_dev;
 	else
 		rx_dev = ctlr->dev.parent;
 
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
index ea9a53bdb417..099359fc0115 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_arm.c
@@ -1189,6 +1189,9 @@ int vchiq_dump_platform_instances(void *dump_context)
 	int len;
 	int i;
 
+	if (!state)
+		return -ENOTCONN;
+
 	/*
 	 * There is no list of instances, so instead scan all services,
 	 * marking those that have been dumped.
diff --git a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
index 9429b8a642fb..630ed0dc24c3 100644
--- a/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
+++ b/drivers/staging/vc04_services/interface/vchiq_arm/vchiq_core.c
@@ -2421,6 +2421,9 @@ void vchiq_msg_queue_push(unsigned int handle, struct vchiq_header *header)
 	struct vchiq_service *service = find_service_by_handle(handle);
 	int pos;
 
+	if (!service)
+		return;
+
 	while (service->msg_queue_write == service->msg_queue_read +
 		VCHIQ_MAX_SLOTS) {
 		if (wait_for_completion_interruptible(&service->msg_queue_pop))
@@ -2441,6 +2444,9 @@ struct vchiq_header *vchiq_msg_hold(unsigned int handle)
 	struct vchiq_header *header;
 	int pos;
 
+	if (!service)
+		return NULL;
+
 	if (service->msg_queue_write == service->msg_queue_read)
 		return NULL;
 
diff --git a/drivers/staging/wfx/main.c b/drivers/staging/wfx/main.c
index 4b9fdf99981b..9ff69c5e0ae9 100644
--- a/drivers/staging/wfx/main.c
+++ b/drivers/staging/wfx/main.c
@@ -309,7 +309,8 @@ struct wfx_dev *wfx_init_common(struct device *dev,
 	wdev->pdata.gpio_wakeup = devm_gpiod_get_optional(dev, "wakeup",
 							  GPIOD_OUT_LOW);
 	if (IS_ERR(wdev->pdata.gpio_wakeup))
-		return NULL;
+		goto err;
+
 	if (wdev->pdata.gpio_wakeup)
 		gpiod_set_consumer_name(wdev->pdata.gpio_wakeup, "wfx wakeup");
 
@@ -328,6 +329,10 @@ struct wfx_dev *wfx_init_common(struct device *dev,
 		return NULL;
 
 	return wdev;
+
+err:
+	ieee80211_free_hw(hw);
+	return NULL;
 }
 
 int wfx_probe(struct wfx_dev *wdev)
diff --git a/drivers/tty/serial/samsung_tty.c b/drivers/tty/serial/samsung_tty.c
index e2f49863e9c2..319533b3c32a 100644
--- a/drivers/tty/serial/samsung_tty.c
+++ b/drivers/tty/serial/samsung_tty.c
@@ -922,11 +922,8 @@ static void s3c24xx_serial_tx_chars(struct s3c24xx_uart_port *ourport)
 		return;
 	}
 
-	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS) {
-		spin_unlock(&port->lock);
+	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
 		uart_write_wakeup(port);
-		spin_lock(&port->lock);
-	}
 
 	if (uart_circ_empty(xmit))
 		s3c24xx_serial_stop_tx(port);
diff --git a/drivers/usb/cdns3/cdnsp-debug.h b/drivers/usb/cdns3/cdnsp-debug.h
index a8776df2d4e0..f0ca865cce2a 100644
--- a/drivers/usb/cdns3/cdnsp-debug.h
+++ b/drivers/usb/cdns3/cdnsp-debug.h
@@ -182,208 +182,211 @@ static inline const char *cdnsp_decode_trb(char *str, size_t size, u32 field0,
 	int ep_id = TRB_TO_EP_INDEX(field3) - 1;
 	int type = TRB_FIELD_TO_TYPE(field3);
 	unsigned int ep_num;
-	int ret = 0;
+	int ret;
 	u32 temp;
 
 	ep_num = DIV_ROUND_UP(ep_id, 2);
 
 	switch (type) {
 	case TRB_LINK:
-		ret += snprintf(str, size,
-				"LINK %08x%08x intr %ld type '%s' flags %c:%c:%c:%c",
-				field1, field0, GET_INTR_TARGET(field2),
-				cdnsp_trb_type_string(type),
-				field3 & TRB_IOC ? 'I' : 'i',
-				field3 & TRB_CHAIN ? 'C' : 'c',
-				field3 & TRB_TC ? 'T' : 't',
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		ret = snprintf(str, size,
+			       "LINK %08x%08x intr %ld type '%s' flags %c:%c:%c:%c",
+			       field1, field0, GET_INTR_TARGET(field2),
+			       cdnsp_trb_type_string(type),
+			       field3 & TRB_IOC ? 'I' : 'i',
+			       field3 & TRB_CHAIN ? 'C' : 'c',
+			       field3 & TRB_TC ? 'T' : 't',
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_TRANSFER:
 	case TRB_COMPLETION:
 	case TRB_PORT_STATUS:
 	case TRB_HC_EVENT:
-		ret += snprintf(str, size,
-				"ep%d%s(%d) type '%s' TRB %08x%08x status '%s'"
-				" len %ld slot %ld flags %c:%c",
-				ep_num, ep_id % 2 ? "out" : "in",
-				TRB_TO_EP_INDEX(field3),
-				cdnsp_trb_type_string(type), field1, field0,
-				cdnsp_trb_comp_code_string(GET_COMP_CODE(field2)),
-				EVENT_TRB_LEN(field2), TRB_TO_SLOT_ID(field3),
-				field3 & EVENT_DATA ? 'E' : 'e',
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		ret = snprintf(str, size,
+			       "ep%d%s(%d) type '%s' TRB %08x%08x status '%s'"
+			       " len %ld slot %ld flags %c:%c",
+			       ep_num, ep_id % 2 ? "out" : "in",
+			       TRB_TO_EP_INDEX(field3),
+			       cdnsp_trb_type_string(type), field1, field0,
+			       cdnsp_trb_comp_code_string(GET_COMP_CODE(field2)),
+			       EVENT_TRB_LEN(field2), TRB_TO_SLOT_ID(field3),
+			       field3 & EVENT_DATA ? 'E' : 'e',
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_MFINDEX_WRAP:
-		ret += snprintf(str, size, "%s: flags %c",
-				cdnsp_trb_type_string(type),
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		ret = snprintf(str, size, "%s: flags %c",
+			       cdnsp_trb_type_string(type),
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_SETUP:
-		ret += snprintf(str, size,
-				"type '%s' bRequestType %02x bRequest %02x "
-				"wValue %02x%02x wIndex %02x%02x wLength %d "
-				"length %ld TD size %ld intr %ld Setup ID %ld "
-				"flags %c:%c:%c",
-				cdnsp_trb_type_string(type),
-				field0 & 0xff,
-				(field0 & 0xff00) >> 8,
-				(field0 & 0xff000000) >> 24,
-				(field0 & 0xff0000) >> 16,
-				(field1 & 0xff00) >> 8,
-				field1 & 0xff,
-				(field1 & 0xff000000) >> 16 |
-				(field1 & 0xff0000) >> 16,
-				TRB_LEN(field2), GET_TD_SIZE(field2),
-				GET_INTR_TARGET(field2),
-				TRB_SETUPID_TO_TYPE(field3),
-				field3 & TRB_IDT ? 'D' : 'd',
-				field3 & TRB_IOC ? 'I' : 'i',
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		ret = snprintf(str, size,
+			       "type '%s' bRequestType %02x bRequest %02x "
+			       "wValue %02x%02x wIndex %02x%02x wLength %d "
+			       "length %ld TD size %ld intr %ld Setup ID %ld "
+			       "flags %c:%c:%c",
+			       cdnsp_trb_type_string(type),
+			       field0 & 0xff,
+			       (field0 & 0xff00) >> 8,
+			       (field0 & 0xff000000) >> 24,
+			       (field0 & 0xff0000) >> 16,
+			       (field1 & 0xff00) >> 8,
+			       field1 & 0xff,
+			       (field1 & 0xff000000) >> 16 |
+			       (field1 & 0xff0000) >> 16,
+			       TRB_LEN(field2), GET_TD_SIZE(field2),
+			       GET_INTR_TARGET(field2),
+			       TRB_SETUPID_TO_TYPE(field3),
+			       field3 & TRB_IDT ? 'D' : 'd',
+			       field3 & TRB_IOC ? 'I' : 'i',
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_DATA:
-		ret += snprintf(str, size,
-				"type '%s' Buffer %08x%08x length %ld TD size %ld "
-				"intr %ld flags %c:%c:%c:%c:%c:%c:%c",
-				cdnsp_trb_type_string(type),
-				field1, field0, TRB_LEN(field2),
-				GET_TD_SIZE(field2),
-				GET_INTR_TARGET(field2),
-				field3 & TRB_IDT ? 'D' : 'i',
-				field3 & TRB_IOC ? 'I' : 'i',
-				field3 & TRB_CHAIN ? 'C' : 'c',
-				field3 & TRB_NO_SNOOP ? 'S' : 's',
-				field3 & TRB_ISP ? 'I' : 'i',
-				field3 & TRB_ENT ? 'E' : 'e',
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		ret = snprintf(str, size,
+			       "type '%s' Buffer %08x%08x length %ld TD size %ld "
+			       "intr %ld flags %c:%c:%c:%c:%c:%c:%c",
+			       cdnsp_trb_type_string(type),
+			       field1, field0, TRB_LEN(field2),
+			       GET_TD_SIZE(field2),
+			       GET_INTR_TARGET(field2),
+			       field3 & TRB_IDT ? 'D' : 'i',
+			       field3 & TRB_IOC ? 'I' : 'i',
+			       field3 & TRB_CHAIN ? 'C' : 'c',
+			       field3 & TRB_NO_SNOOP ? 'S' : 's',
+			       field3 & TRB_ISP ? 'I' : 'i',
+			       field3 & TRB_ENT ? 'E' : 'e',
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_STATUS:
-		ret += snprintf(str, size,
-				"Buffer %08x%08x length %ld TD size %ld intr"
-				"%ld type '%s' flags %c:%c:%c:%c",
-				field1, field0, TRB_LEN(field2),
-				GET_TD_SIZE(field2),
-				GET_INTR_TARGET(field2),
-				cdnsp_trb_type_string(type),
-				field3 & TRB_IOC ? 'I' : 'i',
-				field3 & TRB_CHAIN ? 'C' : 'c',
-				field3 & TRB_ENT ? 'E' : 'e',
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		ret = snprintf(str, size,
+			       "Buffer %08x%08x length %ld TD size %ld intr"
+			       "%ld type '%s' flags %c:%c:%c:%c",
+			       field1, field0, TRB_LEN(field2),
+			       GET_TD_SIZE(field2),
+			       GET_INTR_TARGET(field2),
+			       cdnsp_trb_type_string(type),
+			       field3 & TRB_IOC ? 'I' : 'i',
+			       field3 & TRB_CHAIN ? 'C' : 'c',
+			       field3 & TRB_ENT ? 'E' : 'e',
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_NORMAL:
 	case TRB_ISOC:
 	case TRB_EVENT_DATA:
 	case TRB_TR_NOOP:
-		ret += snprintf(str, size,
-				"type '%s' Buffer %08x%08x length %ld "
-				"TD size %ld intr %ld "
-				"flags %c:%c:%c:%c:%c:%c:%c:%c:%c",
-				cdnsp_trb_type_string(type),
-				field1, field0, TRB_LEN(field2),
-				GET_TD_SIZE(field2),
-				GET_INTR_TARGET(field2),
-				field3 & TRB_BEI ? 'B' : 'b',
-				field3 & TRB_IDT ? 'T' : 't',
-				field3 & TRB_IOC ? 'I' : 'i',
-				field3 & TRB_CHAIN ? 'C' : 'c',
-				field3 & TRB_NO_SNOOP ? 'S' : 's',
-				field3 & TRB_ISP ? 'I' : 'i',
-				field3 & TRB_ENT ? 'E' : 'e',
-				field3 & TRB_CYCLE ? 'C' : 'c',
-				!(field3 & TRB_EVENT_INVALIDATE) ? 'V' : 'v');
+		ret = snprintf(str, size,
+			       "type '%s' Buffer %08x%08x length %ld "
+			       "TD size %ld intr %ld "
+			       "flags %c:%c:%c:%c:%c:%c:%c:%c:%c",
+			       cdnsp_trb_type_string(type),
+			       field1, field0, TRB_LEN(field2),
+			       GET_TD_SIZE(field2),
+			       GET_INTR_TARGET(field2),
+			       field3 & TRB_BEI ? 'B' : 'b',
+			       field3 & TRB_IDT ? 'T' : 't',
+			       field3 & TRB_IOC ? 'I' : 'i',
+			       field3 & TRB_CHAIN ? 'C' : 'c',
+			       field3 & TRB_NO_SNOOP ? 'S' : 's',
+			       field3 & TRB_ISP ? 'I' : 'i',
+			       field3 & TRB_ENT ? 'E' : 'e',
+			       field3 & TRB_CYCLE ? 'C' : 'c',
+			       !(field3 & TRB_EVENT_INVALIDATE) ? 'V' : 'v');
 		break;
 	case TRB_CMD_NOOP:
 	case TRB_ENABLE_SLOT:
-		ret += snprintf(str, size, "%s: flags %c",
-				cdnsp_trb_type_string(type),
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		ret = snprintf(str, size, "%s: flags %c",
+			       cdnsp_trb_type_string(type),
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_DISABLE_SLOT:
-		ret += snprintf(str, size, "%s: slot %ld flags %c",
-				cdnsp_trb_type_string(type),
-				TRB_TO_SLOT_ID(field3),
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		ret = snprintf(str, size, "%s: slot %ld flags %c",
+			       cdnsp_trb_type_string(type),
+			       TRB_TO_SLOT_ID(field3),
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_ADDR_DEV:
-		ret += snprintf(str, size,
-				"%s: ctx %08x%08x slot %ld flags %c:%c",
-				cdnsp_trb_type_string(type), field1, field0,
-				TRB_TO_SLOT_ID(field3),
-				field3 & TRB_BSR ? 'B' : 'b',
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		ret = snprintf(str, size,
+			       "%s: ctx %08x%08x slot %ld flags %c:%c",
+			       cdnsp_trb_type_string(type), field1, field0,
+			       TRB_TO_SLOT_ID(field3),
+			       field3 & TRB_BSR ? 'B' : 'b',
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_CONFIG_EP:
-		ret += snprintf(str, size,
-				"%s: ctx %08x%08x slot %ld flags %c:%c",
-				cdnsp_trb_type_string(type), field1, field0,
-				TRB_TO_SLOT_ID(field3),
-				field3 & TRB_DC ? 'D' : 'd',
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		ret = snprintf(str, size,
+			       "%s: ctx %08x%08x slot %ld flags %c:%c",
+			       cdnsp_trb_type_string(type), field1, field0,
+			       TRB_TO_SLOT_ID(field3),
+			       field3 & TRB_DC ? 'D' : 'd',
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_EVAL_CONTEXT:
-		ret += snprintf(str, size,
-				"%s: ctx %08x%08x slot %ld flags %c",
-				cdnsp_trb_type_string(type), field1, field0,
-				TRB_TO_SLOT_ID(field3),
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		ret = snprintf(str, size,
+			       "%s: ctx %08x%08x slot %ld flags %c",
+			       cdnsp_trb_type_string(type), field1, field0,
+			       TRB_TO_SLOT_ID(field3),
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_RESET_EP:
 	case TRB_HALT_ENDPOINT:
 	case TRB_FLUSH_ENDPOINT:
-		ret += snprintf(str, size,
-				"%s: ep%d%s(%d) ctx %08x%08x slot %ld flags %c",
-				cdnsp_trb_type_string(type),
-				ep_num, ep_id % 2 ? "out" : "in",
-				TRB_TO_EP_INDEX(field3), field1, field0,
-				TRB_TO_SLOT_ID(field3),
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		ret = snprintf(str, size,
+			       "%s: ep%d%s(%d) ctx %08x%08x slot %ld flags %c",
+			       cdnsp_trb_type_string(type),
+			       ep_num, ep_id % 2 ? "out" : "in",
+			       TRB_TO_EP_INDEX(field3), field1, field0,
+			       TRB_TO_SLOT_ID(field3),
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_STOP_RING:
-		ret += snprintf(str, size,
-				"%s: ep%d%s(%d) slot %ld sp %d flags %c",
-				cdnsp_trb_type_string(type),
-				ep_num, ep_id % 2 ? "out" : "in",
-				TRB_TO_EP_INDEX(field3),
-				TRB_TO_SLOT_ID(field3),
-				TRB_TO_SUSPEND_PORT(field3),
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		ret = snprintf(str, size,
+			       "%s: ep%d%s(%d) slot %ld sp %d flags %c",
+			       cdnsp_trb_type_string(type),
+			       ep_num, ep_id % 2 ? "out" : "in",
+			       TRB_TO_EP_INDEX(field3),
+			       TRB_TO_SLOT_ID(field3),
+			       TRB_TO_SUSPEND_PORT(field3),
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_SET_DEQ:
-		ret += snprintf(str, size,
-				"%s: ep%d%s(%d) deq %08x%08x stream %ld slot %ld  flags %c",
-				cdnsp_trb_type_string(type),
-				ep_num, ep_id % 2 ? "out" : "in",
-				TRB_TO_EP_INDEX(field3), field1, field0,
-				TRB_TO_STREAM_ID(field2),
-				TRB_TO_SLOT_ID(field3),
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		ret = snprintf(str, size,
+			       "%s: ep%d%s(%d) deq %08x%08x stream %ld slot %ld  flags %c",
+			       cdnsp_trb_type_string(type),
+			       ep_num, ep_id % 2 ? "out" : "in",
+			       TRB_TO_EP_INDEX(field3), field1, field0,
+			       TRB_TO_STREAM_ID(field2),
+			       TRB_TO_SLOT_ID(field3),
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_RESET_DEV:
-		ret += snprintf(str, size, "%s: slot %ld flags %c",
-				cdnsp_trb_type_string(type),
-				TRB_TO_SLOT_ID(field3),
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		ret = snprintf(str, size, "%s: slot %ld flags %c",
+			       cdnsp_trb_type_string(type),
+			       TRB_TO_SLOT_ID(field3),
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	case TRB_ENDPOINT_NRDY:
-		temp  = TRB_TO_HOST_STREAM(field2);
-
-		ret += snprintf(str, size,
-				"%s: ep%d%s(%d) H_SID %x%s%s D_SID %lx flags %c:%c",
-				cdnsp_trb_type_string(type),
-				ep_num, ep_id % 2 ? "out" : "in",
-				TRB_TO_EP_INDEX(field3), temp,
-				temp == STREAM_PRIME_ACK ? "(PRIME)" : "",
-				temp == STREAM_REJECTED ? "(REJECTED)" : "",
-				TRB_TO_DEV_STREAM(field0),
-				field3 & TRB_STAT ? 'S' : 's',
-				field3 & TRB_CYCLE ? 'C' : 'c');
+		temp = TRB_TO_HOST_STREAM(field2);
+
+		ret = snprintf(str, size,
+			       "%s: ep%d%s(%d) H_SID %x%s%s D_SID %lx flags %c:%c",
+			       cdnsp_trb_type_string(type),
+			       ep_num, ep_id % 2 ? "out" : "in",
+			       TRB_TO_EP_INDEX(field3), temp,
+			       temp == STREAM_PRIME_ACK ? "(PRIME)" : "",
+			       temp == STREAM_REJECTED ? "(REJECTED)" : "",
+			       TRB_TO_DEV_STREAM(field0),
+			       field3 & TRB_STAT ? 'S' : 's',
+			       field3 & TRB_CYCLE ? 'C' : 'c');
 		break;
 	default:
-		ret += snprintf(str, size,
-				"type '%s' -> raw %08x %08x %08x %08x",
-				cdnsp_trb_type_string(type),
-				field0, field1, field2, field3);
+		ret = snprintf(str, size,
+			       "type '%s' -> raw %08x %08x %08x %08x",
+			       cdnsp_trb_type_string(type),
+			       field0, field1, field2, field3);
 	}
 
+	if (ret >= size)
+		pr_info("CDNSP: buffer overflowed.\n");
+
 	return str;
 }
 
diff --git a/drivers/usb/dwc3/dwc3-omap.c b/drivers/usb/dwc3/dwc3-omap.c
index e196673f5c64..efaf0db595f4 100644
--- a/drivers/usb/dwc3/dwc3-omap.c
+++ b/drivers/usb/dwc3/dwc3-omap.c
@@ -242,7 +242,7 @@ static void dwc3_omap_set_mailbox(struct dwc3_omap *omap,
 		break;
 
 	case OMAP_DWC3_ID_FLOAT:
-		if (omap->vbus_reg)
+		if (omap->vbus_reg && regulator_is_enabled(omap->vbus_reg))
 			regulator_disable(omap->vbus_reg);
 		val = dwc3_omap_read_utmi_ctrl(omap);
 		val |= USBOTGSS_UTMI_OTG_CTRL_IDDIG;
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index 06d0e88ec8af..4d9608cc55f7 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -185,7 +185,8 @@ static const struct software_node dwc3_pci_amd_mr_swnode = {
 	.properties = dwc3_pci_mr_properties,
 };
 
-static int dwc3_pci_quirks(struct dwc3_pci *dwc)
+static int dwc3_pci_quirks(struct dwc3_pci *dwc,
+			   const struct software_node *swnode)
 {
 	struct pci_dev			*pdev = dwc->pci;
 
@@ -242,7 +243,7 @@ static int dwc3_pci_quirks(struct dwc3_pci *dwc)
 		}
 	}
 
-	return 0;
+	return device_add_software_node(&dwc->dwc3->dev, swnode);
 }
 
 #ifdef CONFIG_PM
@@ -307,11 +308,7 @@ static int dwc3_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	dwc->dwc3->dev.parent = dev;
 	ACPI_COMPANION_SET(&dwc->dwc3->dev, ACPI_COMPANION(dev));
 
-	ret = device_add_software_node(&dwc->dwc3->dev, (void *)id->driver_data);
-	if (ret < 0)
-		goto err;
-
-	ret = dwc3_pci_quirks(dwc);
+	ret = dwc3_pci_quirks(dwc, (void *)id->driver_data);
 	if (ret)
 		goto err;
 
diff --git a/drivers/usb/gadget/udc/tegra-xudc.c b/drivers/usb/gadget/udc/tegra-xudc.c
index 43f1b0d461c1..be76f891b9c5 100644
--- a/drivers/usb/gadget/udc/tegra-xudc.c
+++ b/drivers/usb/gadget/udc/tegra-xudc.c
@@ -32,9 +32,6 @@
 #include <linux/workqueue.h>
 
 /* XUSB_DEV registers */
-#define SPARAM 0x000
-#define  SPARAM_ERSTMAX_MASK GENMASK(20, 16)
-#define  SPARAM_ERSTMAX(x) (((x) << 16) & SPARAM_ERSTMAX_MASK)
 #define DB 0x004
 #define  DB_TARGET_MASK GENMASK(15, 8)
 #define  DB_TARGET(x) (((x) << 8) & DB_TARGET_MASK)
@@ -275,8 +272,10 @@ BUILD_EP_CONTEXT_RW(deq_hi, deq_hi, 0, 0xffffffff)
 BUILD_EP_CONTEXT_RW(avg_trb_len, tx_info, 0, 0xffff)
 BUILD_EP_CONTEXT_RW(max_esit_payload, tx_info, 16, 0xffff)
 BUILD_EP_CONTEXT_RW(edtla, rsvd[0], 0, 0xffffff)
-BUILD_EP_CONTEXT_RW(seq_num, rsvd[0], 24, 0xff)
+BUILD_EP_CONTEXT_RW(rsvd, rsvd[0], 24, 0x1)
 BUILD_EP_CONTEXT_RW(partial_td, rsvd[0], 25, 0x1)
+BUILD_EP_CONTEXT_RW(splitxstate, rsvd[0], 26, 0x1)
+BUILD_EP_CONTEXT_RW(seq_num, rsvd[0], 27, 0x1f)
 BUILD_EP_CONTEXT_RW(cerrcnt, rsvd[1], 18, 0x3)
 BUILD_EP_CONTEXT_RW(data_offset, rsvd[2], 0, 0x1ffff)
 BUILD_EP_CONTEXT_RW(numtrbs, rsvd[2], 22, 0x1f)
@@ -1557,6 +1556,9 @@ static int __tegra_xudc_ep_set_halt(struct tegra_xudc_ep *ep, bool halt)
 		ep_reload(xudc, ep->index);
 
 		ep_ctx_write_state(ep->context, EP_STATE_RUNNING);
+		ep_ctx_write_rsvd(ep->context, 0);
+		ep_ctx_write_partial_td(ep->context, 0);
+		ep_ctx_write_splitxstate(ep->context, 0);
 		ep_ctx_write_seq_num(ep->context, 0);
 
 		ep_reload(xudc, ep->index);
@@ -2812,7 +2814,10 @@ static void tegra_xudc_reset(struct tegra_xudc *xudc)
 	xudc->setup_seq_num = 0;
 	xudc->queued_setup_packet = false;
 
-	ep_ctx_write_seq_num(ep0->context, xudc->setup_seq_num);
+	ep_ctx_write_rsvd(ep0->context, 0);
+	ep_ctx_write_partial_td(ep0->context, 0);
+	ep_ctx_write_splitxstate(ep0->context, 0);
+	ep_ctx_write_seq_num(ep0->context, 0);
 
 	deq_ptr = trb_virt_to_phys(ep0, &ep0->transfer_ring[ep0->deq_ptr]);
 
@@ -3295,11 +3300,6 @@ static void tegra_xudc_init_event_ring(struct tegra_xudc *xudc)
 	unsigned int i;
 	u32 val;
 
-	val = xudc_readl(xudc, SPARAM);
-	val &= ~(SPARAM_ERSTMAX_MASK);
-	val |= SPARAM_ERSTMAX(XUDC_NR_EVENT_RINGS);
-	xudc_writel(xudc, val, SPARAM);
-
 	for (i = 0; i < ARRAY_SIZE(xudc->event_ring); i++) {
 		memset(xudc->event_ring[i], 0, XUDC_EVENT_RING_SIZE *
 		       sizeof(*xudc->event_ring[i]));
diff --git a/drivers/usb/host/ehci-pci.c b/drivers/usb/host/ehci-pci.c
index e87cf3a00fa4..638f03b89739 100644
--- a/drivers/usb/host/ehci-pci.c
+++ b/drivers/usb/host/ehci-pci.c
@@ -21,6 +21,9 @@ static const char hcd_name[] = "ehci-pci";
 /* defined here to avoid adding to pci_ids.h for single instance use */
 #define PCI_DEVICE_ID_INTEL_CE4100_USB	0x2e70
 
+#define PCI_VENDOR_ID_ASPEED		0x1a03
+#define PCI_DEVICE_ID_ASPEED_EHCI	0x2603
+
 /*-------------------------------------------------------------------------*/
 #define PCI_DEVICE_ID_INTEL_QUARK_X1000_SOC		0x0939
 static inline bool is_intel_quark_x1000(struct pci_dev *pdev)
@@ -222,6 +225,12 @@ static int ehci_pci_setup(struct usb_hcd *hcd)
 			ehci->has_synopsys_hc_bug = 1;
 		}
 		break;
+	case PCI_VENDOR_ID_ASPEED:
+		if (pdev->device == PCI_DEVICE_ID_ASPEED_EHCI) {
+			ehci_info(ehci, "applying Aspeed HC workaround\n");
+			ehci->is_aspeed = 1;
+		}
+		break;
 	}
 
 	/* optional debug port, normally in the first BAR */
diff --git a/drivers/vdpa/mlx5/core/mlx5_vdpa.h b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
index 01a848adf590..81dc3d88d3dd 100644
--- a/drivers/vdpa/mlx5/core/mlx5_vdpa.h
+++ b/drivers/vdpa/mlx5/core/mlx5_vdpa.h
@@ -63,7 +63,7 @@ struct mlx5_control_vq {
 	unsigned short head;
 };
 
-struct mlx5_ctrl_wq_ent {
+struct mlx5_vdpa_wq_ent {
 	struct work_struct work;
 	struct mlx5_vdpa_dev *mvdev;
 };
diff --git a/drivers/vdpa/mlx5/net/mlx5_vnet.c b/drivers/vdpa/mlx5/net/mlx5_vnet.c
index f77a611f592f..e4258f40dcd7 100644
--- a/drivers/vdpa/mlx5/net/mlx5_vnet.c
+++ b/drivers/vdpa/mlx5/net/mlx5_vnet.c
@@ -161,6 +161,9 @@ struct mlx5_vdpa_net {
 	bool setup;
 	u16 mtu;
 	u32 cur_num_vqs;
+	struct notifier_block nb;
+	struct vdpa_callback config_cb;
+	struct mlx5_vdpa_wq_ent cvq_ent;
 };
 
 static void free_resources(struct mlx5_vdpa_net *ndev);
@@ -1573,22 +1576,22 @@ static void mlx5_cvq_kick_handler(struct work_struct *work)
 {
 	virtio_net_ctrl_ack status = VIRTIO_NET_ERR;
 	struct virtio_net_ctrl_hdr ctrl;
-	struct mlx5_ctrl_wq_ent *wqent;
+	struct mlx5_vdpa_wq_ent *wqent;
 	struct mlx5_vdpa_dev *mvdev;
 	struct mlx5_control_vq *cvq;
 	struct mlx5_vdpa_net *ndev;
 	size_t read, write;
 	int err;
 
-	wqent = container_of(work, struct mlx5_ctrl_wq_ent, work);
+	wqent = container_of(work, struct mlx5_vdpa_wq_ent, work);
 	mvdev = wqent->mvdev;
 	ndev = to_mlx5_vdpa_ndev(mvdev);
 	cvq = &mvdev->cvq;
 	if (!(ndev->mvdev.actual_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ)))
-		goto out;
+		return;
 
 	if (!cvq->ready)
-		goto out;
+		return;
 
 	while (true) {
 		err = vringh_getdesc_iotlb(&cvq->vring, &cvq->riov, &cvq->wiov, &cvq->head,
@@ -1622,9 +1625,10 @@ static void mlx5_cvq_kick_handler(struct work_struct *work)
 
 		if (vringh_need_notify_iotlb(&cvq->vring))
 			vringh_notify(&cvq->vring);
+
+		queue_work(mvdev->wq, &wqent->work);
+		break;
 	}
-out:
-	kfree(wqent);
 }
 
 static void mlx5_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
@@ -1632,7 +1636,6 @@ static void mlx5_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
 	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
 	struct mlx5_vdpa_virtqueue *mvq;
-	struct mlx5_ctrl_wq_ent *wqent;
 
 	if (!is_index_valid(mvdev, idx))
 		return;
@@ -1641,13 +1644,7 @@ static void mlx5_vdpa_kick_vq(struct vdpa_device *vdev, u16 idx)
 		if (!mvdev->cvq.ready)
 			return;
 
-		wqent = kzalloc(sizeof(*wqent), GFP_ATOMIC);
-		if (!wqent)
-			return;
-
-		wqent->mvdev = mvdev;
-		INIT_WORK(&wqent->work, mlx5_cvq_kick_handler);
-		queue_work(mvdev->wq, &wqent->work);
+		queue_work(mvdev->wq, &ndev->cvq_ent.work);
 		return;
 	}
 
@@ -1868,6 +1865,7 @@ static u64 mlx5_vdpa_get_features(struct vdpa_device *vdev)
 	ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_NET_F_CTRL_VQ);
 	ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_NET_F_CTRL_MAC_ADDR);
 	ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_NET_F_MQ);
+	ndev->mvdev.mlx_features |= BIT_ULL(VIRTIO_NET_F_STATUS);
 
 	print_features(mvdev, ndev->mvdev.mlx_features, false);
 	return ndev->mvdev.mlx_features;
@@ -1980,8 +1978,10 @@ static int mlx5_vdpa_set_features(struct vdpa_device *vdev, u64 features)
 
 static void mlx5_vdpa_set_config_cb(struct vdpa_device *vdev, struct vdpa_callback *cb)
 {
-	/* not implemented */
-	mlx5_vdpa_warn(to_mvdev(vdev), "set config callback not supported\n");
+	struct mlx5_vdpa_dev *mvdev = to_mvdev(vdev);
+	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
+
+	ndev->config_cb = *cb;
 }
 
 #define MLX5_VDPA_MAX_VQ_ENTRIES 256
@@ -2433,6 +2433,82 @@ struct mlx5_vdpa_mgmtdev {
 	struct mlx5_vdpa_net *ndev;
 };
 
+static u8 query_vport_state(struct mlx5_core_dev *mdev, u8 opmod, u16 vport)
+{
+	u32 out[MLX5_ST_SZ_DW(query_vport_state_out)] = {};
+	u32 in[MLX5_ST_SZ_DW(query_vport_state_in)] = {};
+	int err;
+
+	MLX5_SET(query_vport_state_in, in, opcode, MLX5_CMD_OP_QUERY_VPORT_STATE);
+	MLX5_SET(query_vport_state_in, in, op_mod, opmod);
+	MLX5_SET(query_vport_state_in, in, vport_number, vport);
+	if (vport)
+		MLX5_SET(query_vport_state_in, in, other_vport, 1);
+
+	err = mlx5_cmd_exec_inout(mdev, query_vport_state, in, out);
+	if (err)
+		return 0;
+
+	return MLX5_GET(query_vport_state_out, out, state);
+}
+
+static bool get_link_state(struct mlx5_vdpa_dev *mvdev)
+{
+	if (query_vport_state(mvdev->mdev, MLX5_VPORT_STATE_OP_MOD_VNIC_VPORT, 0) ==
+	    VPORT_STATE_UP)
+		return true;
+
+	return false;
+}
+
+static void update_carrier(struct work_struct *work)
+{
+	struct mlx5_vdpa_wq_ent *wqent;
+	struct mlx5_vdpa_dev *mvdev;
+	struct mlx5_vdpa_net *ndev;
+
+	wqent = container_of(work, struct mlx5_vdpa_wq_ent, work);
+	mvdev = wqent->mvdev;
+	ndev = to_mlx5_vdpa_ndev(mvdev);
+	if (get_link_state(mvdev))
+		ndev->config.status |= cpu_to_mlx5vdpa16(mvdev, VIRTIO_NET_S_LINK_UP);
+	else
+		ndev->config.status &= cpu_to_mlx5vdpa16(mvdev, ~VIRTIO_NET_S_LINK_UP);
+
+	if (ndev->config_cb.callback)
+		ndev->config_cb.callback(ndev->config_cb.private);
+
+	kfree(wqent);
+}
+
+static int event_handler(struct notifier_block *nb, unsigned long event, void *param)
+{
+	struct mlx5_vdpa_net *ndev = container_of(nb, struct mlx5_vdpa_net, nb);
+	struct mlx5_eqe *eqe = param;
+	int ret = NOTIFY_DONE;
+	struct mlx5_vdpa_wq_ent *wqent;
+
+	if (event == MLX5_EVENT_TYPE_PORT_CHANGE) {
+		switch (eqe->sub_type) {
+		case MLX5_PORT_CHANGE_SUBTYPE_DOWN:
+		case MLX5_PORT_CHANGE_SUBTYPE_ACTIVE:
+			wqent = kzalloc(sizeof(*wqent), GFP_ATOMIC);
+			if (!wqent)
+				return NOTIFY_DONE;
+
+			wqent->mvdev = &ndev->mvdev;
+			INIT_WORK(&wqent->work, update_carrier);
+			queue_work(ndev->mvdev.wq, &wqent->work);
+			ret = NOTIFY_OK;
+			break;
+		default:
+			return NOTIFY_DONE;
+		}
+		return ret;
+	}
+	return ret;
+}
+
 static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 {
 	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
@@ -2477,6 +2553,11 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 	if (err)
 		goto err_mtu;
 
+	if (get_link_state(mvdev))
+		ndev->config.status |= cpu_to_mlx5vdpa16(mvdev, VIRTIO_NET_S_LINK_UP);
+	else
+		ndev->config.status &= cpu_to_mlx5vdpa16(mvdev, ~VIRTIO_NET_S_LINK_UP);
+
 	if (!is_zero_ether_addr(config->mac)) {
 		pfmdev = pci_get_drvdata(pci_physfn(mdev->pdev));
 		err = mlx5_mpfs_add_mac(pfmdev, config->mac);
@@ -2502,12 +2583,16 @@ static int mlx5_vdpa_dev_add(struct vdpa_mgmt_dev *v_mdev, const char *name)
 	if (err)
 		goto err_mr;
 
-	mvdev->wq = create_singlethread_workqueue("mlx5_vdpa_ctrl_wq");
+	ndev->cvq_ent.mvdev = mvdev;
+	INIT_WORK(&ndev->cvq_ent.work, mlx5_cvq_kick_handler);
+	mvdev->wq = create_singlethread_workqueue("mlx5_vdpa_wq");
 	if (!mvdev->wq) {
 		err = -ENOMEM;
 		goto err_res2;
 	}
 
+	ndev->nb.notifier_call = event_handler;
+	mlx5_notifier_register(mdev, &ndev->nb);
 	ndev->cur_num_vqs = 2 * mlx5_vdpa_max_qps(max_vqs);
 	mvdev->vdev.mdev = &mgtdev->mgtdev;
 	err = _vdpa_register_device(&mvdev->vdev, ndev->cur_num_vqs + 1);
@@ -2538,7 +2623,9 @@ static void mlx5_vdpa_dev_del(struct vdpa_mgmt_dev *v_mdev, struct vdpa_device *
 {
 	struct mlx5_vdpa_mgmtdev *mgtdev = container_of(v_mdev, struct mlx5_vdpa_mgmtdev, mgtdev);
 	struct mlx5_vdpa_dev *mvdev = to_mvdev(dev);
+	struct mlx5_vdpa_net *ndev = to_mlx5_vdpa_ndev(mvdev);
 
+	mlx5_notifier_unregister(mvdev->mdev, &ndev->nb);
 	destroy_workqueue(mvdev->wq);
 	_vdpa_unregister_device(dev);
 	mgtdev->ndev = NULL;
diff --git a/drivers/vfio/pci/vfio_pci_rdwr.c b/drivers/vfio/pci/vfio_pci_rdwr.c
index 57d3b2cbbd8e..82ac1569deb0 100644
--- a/drivers/vfio/pci/vfio_pci_rdwr.c
+++ b/drivers/vfio/pci/vfio_pci_rdwr.c
@@ -288,6 +288,7 @@ ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	return done;
 }
 
+#ifdef CONFIG_VFIO_PCI_VGA
 ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite)
 {
@@ -355,6 +356,7 @@ ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 
 	return done;
 }
+#endif
 
 static void vfio_pci_ioeventfd_do_write(struct vfio_pci_ioeventfd *ioeventfd,
 					bool test_mem)
diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 28ef323882fb..792ab5f23647 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -473,6 +473,7 @@ static void vhost_tx_batch(struct vhost_net *net,
 		goto signal_used;
 
 	msghdr->msg_control = &ctl;
+	msghdr->msg_controllen = sizeof(ctl);
 	err = sock->ops->sendmsg(sock, msghdr, 0);
 	if (unlikely(err < 0)) {
 		vq_err(&nvq->vq, "Fail to batch sending packets\n");
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 91145d93990a..0371ad233fdf 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1581,7 +1581,14 @@ static void do_remove_conflicting_framebuffers(struct apertures_struct *a,
 			 * If it's not a platform device, at least print a warning. A
 			 * fix would add code to remove the device from the system.
 			 */
-			if (dev_is_platform(device)) {
+			if (!device) {
+				/* TODO: Represent each OF framebuffer as its own
+				 * device in the device hierarchy. For now, offb
+				 * doesn't have such a device, so unregister the
+				 * framebuffer as before without warning.
+				 */
+				do_unregister_framebuffer(registered_fb[i]);
+			} else if (dev_is_platform(device)) {
 				registered_fb[i]->forced_out = true;
 				platform_device_unregister(to_platform_device(device));
 			} else {
diff --git a/drivers/w1/slaves/w1_therm.c b/drivers/w1/slaves/w1_therm.c
index ca70c5f03206..9cbeeb4923ec 100644
--- a/drivers/w1/slaves/w1_therm.c
+++ b/drivers/w1/slaves/w1_therm.c
@@ -2090,16 +2090,20 @@ static ssize_t w1_seq_show(struct device *device,
 		if (sl->reg_num.id == reg_num->id)
 			seq = i;
 
+		if (w1_reset_bus(sl->master))
+			goto error;
+
+		/* Put the device into chain DONE state */
+		w1_write_8(sl->master, W1_MATCH_ROM);
+		w1_write_block(sl->master, (u8 *)&rn, 8);
 		w1_write_8(sl->master, W1_42_CHAIN);
 		w1_write_8(sl->master, W1_42_CHAIN_DONE);
 		w1_write_8(sl->master, W1_42_CHAIN_DONE_INV);
-		w1_read_block(sl->master, &ack, sizeof(ack));
 
 		/* check for acknowledgment */
 		ack = w1_read_8(sl->master);
 		if (ack != W1_42_SUCCESS_CONFIRM_BYTE)
 			goto error;
-
 	}
 
 	/* Exit from CHAIN state */
diff --git a/fs/btrfs/extent_io.h b/fs/btrfs/extent_io.h
index 53abdc280451..f7ab6ba8238e 100644
--- a/fs/btrfs/extent_io.h
+++ b/fs/btrfs/extent_io.h
@@ -117,7 +117,7 @@ struct btrfs_bio_ctrl {
  */
 struct extent_changeset {
 	/* How many bytes are set/cleared in this operation */
-	unsigned int bytes_changed;
+	u64 bytes_changed;
 
 	/* Changed ranges */
 	struct ulist range_changed;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 58053b5f0ce1..e478fd916216 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4450,6 +4450,13 @@ int btrfs_delete_subvolume(struct inode *dir, struct dentry *dentry)
 			   dest->root_key.objectid);
 		return -EPERM;
 	}
+	if (atomic_read(&dest->nr_swapfiles)) {
+		spin_unlock(&dest->root_item_lock);
+		btrfs_warn(fs_info,
+			   "attempt to delete subvolume %llu with active swapfile",
+			   root->root_key.objectid);
+		return -EPERM;
+	}
 	root_flags = btrfs_root_flags(&dest->root_item);
 	btrfs_set_root_flags(&dest->root_item,
 			     root_flags | BTRFS_ROOT_SUBVOL_DEAD);
@@ -10721,8 +10728,23 @@ static int btrfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 	 * set. We use this counter to prevent snapshots. We must increment it
 	 * before walking the extents because we don't want a concurrent
 	 * snapshot to run after we've already checked the extents.
+	 *
+	 * It is possible that subvolume is marked for deletion but still not
+	 * removed yet. To prevent this race, we check the root status before
+	 * activating the swapfile.
 	 */
+	spin_lock(&root->root_item_lock);
+	if (btrfs_root_dead(root)) {
+		spin_unlock(&root->root_item_lock);
+
+		btrfs_exclop_finish(fs_info);
+		btrfs_warn(fs_info,
+		"cannot activate swapfile because subvolume %llu is being deleted",
+			root->root_key.objectid);
+		return -EPERM;
+	}
 	atomic_inc(&root->nr_swapfiles);
+	spin_unlock(&root->root_item_lock);
 
 	isize = ALIGN_DOWN(inode->i_size, fs_info->sectorsize);
 
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 133dbd9338e7..d91fa53e12b3 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -478,8 +478,11 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 					2 : (fpos_off(rde->offset) + 1);
 			err = note_last_dentry(dfi, rde->name, rde->name_len,
 					       next_offset);
-			if (err)
+			if (err) {
+				ceph_mdsc_put_request(dfi->last_readdir);
+				dfi->last_readdir = NULL;
 				return err;
+			}
 		} else if (req->r_reply_info.dir_end) {
 			dfi->next_offset = 2;
 			/* keep last name */
@@ -520,6 +523,12 @@ static int ceph_readdir(struct file *file, struct dir_context *ctx)
 		if (!dir_emit(ctx, rde->name, rde->name_len,
 			      ceph_present_ino(inode->i_sb, le64_to_cpu(rde->inode.in->ino)),
 			      le32_to_cpu(rde->inode.in->mode) >> 12)) {
+			/*
+			 * NOTE: Here no need to put the 'dfi->last_readdir',
+			 * because when dir_emit stops us it's most likely
+			 * doesn't have enough memory, etc. So for next readdir
+			 * it will continue.
+			 */
 			dout("filldir stopping us...\n");
 			return 0;
 		}
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index 1c7574105478..42e449d3f18b 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -87,13 +87,13 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 	if (!S_ISDIR(parent->i_mode)) {
 		pr_warn_once("bad snapdir parent type (mode=0%o)\n",
 			     parent->i_mode);
-		return ERR_PTR(-ENOTDIR);
+		goto err;
 	}
 
 	if (!(inode->i_state & I_NEW) && !S_ISDIR(inode->i_mode)) {
 		pr_warn_once("bad snapdir inode type (mode=0%o)\n",
 			     inode->i_mode);
-		return ERR_PTR(-ENOTDIR);
+		goto err;
 	}
 
 	inode->i_mode = parent->i_mode;
@@ -113,6 +113,12 @@ struct inode *ceph_get_snapdir(struct inode *parent)
 	}
 
 	return inode;
+err:
+	if ((inode->i_state & I_NEW))
+		discard_new_inode(inode);
+	else
+		iput(inode);
+	return ERR_PTR(-ENOTDIR);
 }
 
 const struct inode_operations ceph_file_iops = {
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5fc3a62eae72..3d44d48b35ea 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -623,10 +623,10 @@ struct io_epoll {
 
 struct io_splice {
 	struct file			*file_out;
-	struct file			*file_in;
 	loff_t				off_out;
 	loff_t				off_in;
 	u64				len;
+	int				splice_fd_in;
 	unsigned int			flags;
 };
 
@@ -1452,14 +1452,6 @@ static void io_prep_async_work(struct io_kiocb *req)
 		if (def->unbound_nonreg_file)
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
-
-	switch (req->opcode) {
-	case IORING_OP_SPLICE:
-	case IORING_OP_TEE:
-		if (!S_ISREG(file_inode(req->splice.file_in)->i_mode))
-			req->work.flags |= IO_WQ_WORK_UNBOUND;
-		break;
-	}
 }
 
 static void io_prep_async_link(struct io_kiocb *req)
@@ -1546,12 +1538,11 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->completion_lock)
 {
 	u32 seq = ctx->cached_cq_tail - atomic_read(&ctx->cq_timeouts);
+	struct io_kiocb *req, *tmp;
 
 	spin_lock_irq(&ctx->timeout_lock);
-	while (!list_empty(&ctx->timeout_list)) {
+	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
 		u32 events_needed, events_got;
-		struct io_kiocb *req = list_first_entry(&ctx->timeout_list,
-						struct io_kiocb, timeout.list);
 
 		if (io_is_timeout_noseq(req))
 			break;
@@ -1568,7 +1559,6 @@ static void io_flush_timeouts(struct io_ring_ctx *ctx)
 		if (events_got < events_needed)
 			break;
 
-		list_del_init(&req->timeout.list);
 		io_kill_timeout(req, 0);
 	}
 	ctx->cq_last_tm_flush = seq;
@@ -4027,18 +4017,11 @@ static int __io_splice_prep(struct io_kiocb *req,
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
-	sp->file_in = NULL;
 	sp->len = READ_ONCE(sqe->len);
 	sp->flags = READ_ONCE(sqe->splice_flags);
-
 	if (unlikely(sp->flags & ~valid_flags))
 		return -EINVAL;
-
-	sp->file_in = io_file_get(req->ctx, req, READ_ONCE(sqe->splice_fd_in),
-				  (sp->flags & SPLICE_F_FD_IN_FIXED));
-	if (!sp->file_in)
-		return -EBADF;
-	req->flags |= REQ_F_NEED_CLEANUP;
+	sp->splice_fd_in = READ_ONCE(sqe->splice_fd_in);
 	return 0;
 }
 
@@ -4053,20 +4036,27 @@ static int io_tee_prep(struct io_kiocb *req,
 static int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_splice *sp = &req->splice;
-	struct file *in = sp->file_in;
 	struct file *out = sp->file_out;
 	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
+	struct file *in;
 	long ret = 0;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
+
+	in = io_file_get(req->ctx, req, sp->splice_fd_in,
+				  (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (!in) {
+		ret = -EBADF;
+		goto done;
+	}
+
 	if (sp->len)
 		ret = do_tee(in, out, sp->len, flags);
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
 		io_put_file(in);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-
+done:
 	if (ret != sp->len)
 		req_set_fail(req);
 	io_req_complete(req, ret);
@@ -4085,15 +4075,22 @@ static int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_splice *sp = &req->splice;
-	struct file *in = sp->file_in;
 	struct file *out = sp->file_out;
 	unsigned int flags = sp->flags & ~SPLICE_F_FD_IN_FIXED;
 	loff_t *poff_in, *poff_out;
+	struct file *in;
 	long ret = 0;
 
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		return -EAGAIN;
 
+	in = io_file_get(req->ctx, req, sp->splice_fd_in,
+				  (sp->flags & SPLICE_F_FD_IN_FIXED));
+	if (!in) {
+		ret = -EBADF;
+		goto done;
+	}
+
 	poff_in = (sp->off_in == -1) ? NULL : &sp->off_in;
 	poff_out = (sp->off_out == -1) ? NULL : &sp->off_out;
 
@@ -4102,8 +4099,7 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
 		io_put_file(in);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-
+done:
 	if (ret != sp->len)
 		req_set_fail(req);
 	io_req_complete(req, ret);
@@ -4128,9 +4124,6 @@ static int io_fsync_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (!req->file)
-		return -EBADF;
-
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (unlikely(sqe->addr || sqe->ioprio || sqe->buf_index ||
@@ -6210,6 +6203,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (get_timespec64(&data->ts, u64_to_user_ptr(sqe->addr)))
 		return -EFAULT;
 
+	INIT_LIST_HEAD(&req->timeout.list);
 	data->mode = io_translate_timeout_mode(flags);
 	hrtimer_init(&data->timer, io_timeout_get_clock(data), data->mode);
 
@@ -6652,11 +6646,6 @@ static void io_clean_op(struct io_kiocb *req)
 			kfree(io->free_iov);
 			break;
 			}
-		case IORING_OP_SPLICE:
-		case IORING_OP_TEE:
-			if (!(req->splice.flags & SPLICE_F_FD_IN_FIXED))
-				io_put_file(req->splice.file_in);
-			break;
 		case IORING_OP_OPENAT:
 		case IORING_OP_OPENAT2:
 			if (req->open.filename)
@@ -8126,8 +8115,12 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 		refcount_add(skb->truesize, &sk->sk_wmem_alloc);
 		skb_queue_head(&sk->sk_receive_queue, skb);
 
-		for (i = 0; i < nr_files; i++)
-			fput(fpl->fp[i]);
+		for (i = 0; i < nr; i++) {
+			struct file *file = io_file_from_index(ctx, i + offset);
+
+			if (file)
+				fput(file);
+		}
 	} else {
 		kfree_skb(skb);
 		free_uid(fpl->user);
@@ -8589,7 +8582,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				err = -EBADF;
 				break;
 			}
-			*io_get_tag_slot(data, up->offset + done) = tag;
+			*io_get_tag_slot(data, i) = tag;
 			io_fixed_file_set(file_slot, file);
 			err = io_sqe_file_register(ctx, file, i);
 			if (err) {
@@ -10689,7 +10682,15 @@ static int io_register_iowq_aff(struct io_ring_ctx *ctx, void __user *arg,
 	if (len > cpumask_size())
 		len = cpumask_size();
 
-	if (copy_from_user(new_mask, arg, len)) {
+	if (in_compat_syscall()) {
+		ret = compat_get_bitmap(cpumask_bits(new_mask),
+					(const compat_ulong_t __user *)arg,
+					len * 8 /* CHAR_BIT */);
+	} else {
+		ret = copy_from_user(new_mask, arg, len);
+	}
+
+	if (ret) {
 		free_cpumask_var(new_mask);
 		return -EFAULT;
 	}
diff --git a/fs/jfs/inode.c b/fs/jfs/inode.c
index 57ab424c05ff..072821b50ab9 100644
--- a/fs/jfs/inode.c
+++ b/fs/jfs/inode.c
@@ -146,12 +146,13 @@ void jfs_evict_inode(struct inode *inode)
 		dquot_initialize(inode);
 
 		if (JFS_IP(inode)->fileset == FILESYSTEM_I) {
+			struct inode *ipimap = JFS_SBI(inode->i_sb)->ipimap;
 			truncate_inode_pages_final(&inode->i_data);
 
 			if (test_cflag(COMMIT_Freewmap, inode))
 				jfs_free_zero_link(inode);
 
-			if (JFS_SBI(inode->i_sb)->ipimap)
+			if (ipimap && JFS_IP(ipimap)->i_imap)
 				diFree(inode);
 
 			/*
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index a71f1cf894b9..d4bd94234ef7 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -447,7 +447,8 @@ static const struct address_space_operations minix_aops = {
 	.writepage = minix_writepage,
 	.write_begin = minix_write_begin,
 	.write_end = generic_write_end,
-	.bmap = minix_bmap
+	.bmap = minix_bmap,
+	.direct_IO = noop_direct_IO
 };
 
 static const struct inode_operations minix_symlink_inode_operations = {
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index 9adc6f57a008..78219396788b 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1835,16 +1835,6 @@ const struct dentry_operations nfs4_dentry_operations = {
 };
 EXPORT_SYMBOL_GPL(nfs4_dentry_operations);
 
-static fmode_t flags_to_mode(int flags)
-{
-	fmode_t res = (__force fmode_t)flags & FMODE_EXEC;
-	if ((flags & O_ACCMODE) != O_WRONLY)
-		res |= FMODE_READ;
-	if ((flags & O_ACCMODE) != O_RDONLY)
-		res |= FMODE_WRITE;
-	return res;
-}
-
 static struct nfs_open_context *create_nfs_open_context(struct dentry *dentry, int open_flags, struct file *filp)
 {
 	return alloc_nfs_open_context(dentry, flags_to_mode(open_flags), filp);
diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 3c0335c15a73..c220810c61d1 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -172,8 +172,8 @@ ssize_t nfs_direct_IO(struct kiocb *iocb, struct iov_iter *iter)
 	VM_BUG_ON(iov_iter_count(iter) != PAGE_SIZE);
 
 	if (iov_iter_rw(iter) == READ)
-		return nfs_file_direct_read(iocb, iter);
-	return nfs_file_direct_write(iocb, iter);
+		return nfs_file_direct_read(iocb, iter, true);
+	return nfs_file_direct_write(iocb, iter, true);
 }
 
 static void nfs_direct_release_pages(struct page **pages, unsigned int npages)
@@ -424,6 +424,7 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
  * nfs_file_direct_read - file direct read operation for NFS files
  * @iocb: target I/O control block
  * @iter: vector of user buffers into which to read data
+ * @swap: flag indicating this is swap IO, not O_DIRECT IO
  *
  * We use this function for direct reads instead of calling
  * generic_file_aio_read() in order to avoid gfar's check to see if
@@ -439,7 +440,8 @@ static ssize_t nfs_direct_read_schedule_iovec(struct nfs_direct_req *dreq,
  * client must read the updated atime from the server back into its
  * cache.
  */
-ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter)
+ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter,
+			     bool swap)
 {
 	struct file *file = iocb->ki_filp;
 	struct address_space *mapping = file->f_mapping;
@@ -481,12 +483,14 @@ ssize_t nfs_file_direct_read(struct kiocb *iocb, struct iov_iter *iter)
 	if (iter_is_iovec(iter))
 		dreq->flags = NFS_ODIRECT_SHOULD_DIRTY;
 
-	nfs_start_io_direct(inode);
+	if (!swap)
+		nfs_start_io_direct(inode);
 
 	NFS_I(inode)->read_io += count;
 	requested = nfs_direct_read_schedule_iovec(dreq, iter, iocb->ki_pos);
 
-	nfs_end_io_direct(inode);
+	if (!swap)
+		nfs_end_io_direct(inode);
 
 	if (requested > 0) {
 		result = nfs_direct_wait(dreq);
@@ -789,7 +793,7 @@ static const struct nfs_pgio_completion_ops nfs_direct_write_completion_ops = {
  */
 static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 					       struct iov_iter *iter,
-					       loff_t pos)
+					       loff_t pos, int ioflags)
 {
 	struct nfs_pageio_descriptor desc;
 	struct inode *inode = dreq->inode;
@@ -797,7 +801,7 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 	size_t requested_bytes = 0;
 	size_t wsize = max_t(size_t, NFS_SERVER(inode)->wsize, PAGE_SIZE);
 
-	nfs_pageio_init_write(&desc, inode, FLUSH_COND_STABLE, false,
+	nfs_pageio_init_write(&desc, inode, ioflags, false,
 			      &nfs_direct_write_completion_ops);
 	desc.pg_dreq = dreq;
 	get_dreq(dreq);
@@ -875,6 +879,7 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
  * nfs_file_direct_write - file direct write operation for NFS files
  * @iocb: target I/O control block
  * @iter: vector of user buffers from which to write data
+ * @swap: flag indicating this is swap IO, not O_DIRECT IO
  *
  * We use this function for direct writes instead of calling
  * generic_file_aio_write() in order to avoid taking the inode
@@ -891,7 +896,8 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
  * Note that O_APPEND is not supported for NFS direct writes, as there
  * is no atomic O_APPEND write facility in the NFS protocol.
  */
-ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter)
+ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter,
+			      bool swap)
 {
 	ssize_t result, requested;
 	size_t count;
@@ -905,7 +911,11 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter)
 	dfprintk(FILE, "NFS: direct write(%pD2, %zd@%Ld)\n",
 		file, iov_iter_count(iter), (long long) iocb->ki_pos);
 
-	result = generic_write_checks(iocb, iter);
+	if (swap)
+		/* bypass generic checks */
+		result =  iov_iter_count(iter);
+	else
+		result = generic_write_checks(iocb, iter);
 	if (result <= 0)
 		return result;
 	count = result;
@@ -936,16 +946,22 @@ ssize_t nfs_file_direct_write(struct kiocb *iocb, struct iov_iter *iter)
 		dreq->iocb = iocb;
 	pnfs_init_ds_commit_info_ops(&dreq->ds_cinfo, inode);
 
-	nfs_start_io_direct(inode);
+	if (swap) {
+		requested = nfs_direct_write_schedule_iovec(dreq, iter, pos,
+							    FLUSH_STABLE);
+	} else {
+		nfs_start_io_direct(inode);
 
-	requested = nfs_direct_write_schedule_iovec(dreq, iter, pos);
+		requested = nfs_direct_write_schedule_iovec(dreq, iter, pos,
+							    FLUSH_COND_STABLE);
 
-	if (mapping->nrpages) {
-		invalidate_inode_pages2_range(mapping,
-					      pos >> PAGE_SHIFT, end);
-	}
+		if (mapping->nrpages) {
+			invalidate_inode_pages2_range(mapping,
+						      pos >> PAGE_SHIFT, end);
+		}
 
-	nfs_end_io_direct(inode);
+		nfs_end_io_direct(inode);
+	}
 
 	if (requested > 0) {
 		result = nfs_direct_wait(dreq);
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index aa353fd58240..42a16993913a 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -161,7 +161,7 @@ nfs_file_read(struct kiocb *iocb, struct iov_iter *to)
 	ssize_t result;
 
 	if (iocb->ki_flags & IOCB_DIRECT)
-		return nfs_file_direct_read(iocb, to);
+		return nfs_file_direct_read(iocb, to, false);
 
 	dprintk("NFS: read(%pD2, %zu@%lu)\n",
 		iocb->ki_filp,
@@ -616,7 +616,7 @@ ssize_t nfs_file_write(struct kiocb *iocb, struct iov_iter *from)
 		return result;
 
 	if (iocb->ki_flags & IOCB_DIRECT)
-		return nfs_file_direct_write(iocb, from);
+		return nfs_file_direct_write(iocb, from, false);
 
 	dprintk("NFS: write(%pD2, %zu@%Ld)\n",
 		file, iov_iter_count(from), (long long) iocb->ki_pos);
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 410f87bc48cc..f4f75db7a825 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1167,7 +1167,6 @@ int nfs_open(struct inode *inode, struct file *filp)
 	nfs_fscache_open_file(inode, filp);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(nfs_open);
 
 /*
  * This function is called whenever some part of NFS notices that
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 66fc936834f2..c8845242d422 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -42,6 +42,16 @@ static inline bool nfs_lookup_is_soft_revalidate(const struct dentry *dentry)
 	return true;
 }
 
+static inline fmode_t flags_to_mode(int flags)
+{
+	fmode_t res = (__force fmode_t)flags & FMODE_EXEC;
+	if ((flags & O_ACCMODE) != O_WRONLY)
+		res |= FMODE_READ;
+	if ((flags & O_ACCMODE) != O_RDONLY)
+		res |= FMODE_WRITE;
+	return res;
+}
+
 /*
  * Note: RFC 1813 doesn't limit the number of auth flavors that
  * a server can return, so make something up.
@@ -580,6 +590,13 @@ nfs_write_match_verf(const struct nfs_writeverf *verf,
 		!nfs_write_verifier_cmp(&req->wb_verf, &verf->verifier);
 }
 
+static inline gfp_t nfs_io_gfp_mask(void)
+{
+	if (current->flags & PF_WQ_WORKER)
+		return GFP_KERNEL | __GFP_NORETRY | __GFP_NOWARN;
+	return GFP_KERNEL;
+}
+
 /* unlink.c */
 extern struct rpc_task *
 nfs_async_rename(struct inode *old_dir, struct inode *new_dir,
diff --git a/fs/nfs/nfs42proc.c b/fs/nfs/nfs42proc.c
index 9865b5c37d88..93f4d8257525 100644
--- a/fs/nfs/nfs42proc.c
+++ b/fs/nfs/nfs42proc.c
@@ -586,8 +586,10 @@ static int _nfs42_proc_copy_notify(struct file *src, struct file *dst,
 
 	ctx = get_nfs_open_context(nfs_file_open_context(src));
 	l_ctx = nfs_get_lock_context(ctx);
-	if (IS_ERR(l_ctx))
-		return PTR_ERR(l_ctx);
+	if (IS_ERR(l_ctx)) {
+		status = PTR_ERR(l_ctx);
+		goto out;
+	}
 
 	status = nfs4_set_rw_stateid(&args->cna_src_stateid, ctx, l_ctx,
 				     FMODE_READ);
@@ -595,7 +597,7 @@ static int _nfs42_proc_copy_notify(struct file *src, struct file *dst,
 	if (status) {
 		if (status == -EAGAIN)
 			status = -NFS4ERR_BAD_STATEID;
-		return status;
+		goto out;
 	}
 
 	status = nfs4_call_sync(src_server->client, src_server, &msg,
@@ -603,6 +605,7 @@ static int _nfs42_proc_copy_notify(struct file *src, struct file *dst,
 	if (status == -ENOTSUPP)
 		src_server->caps &= ~NFS_CAP_COPY_NOTIFY;
 
+out:
 	put_nfs_open_context(nfs_file_open_context(src));
 	return status;
 }
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index c91565227ea2..4120e1cb3fee 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -32,6 +32,7 @@ nfs4_file_open(struct inode *inode, struct file *filp)
 	struct dentry *parent = NULL;
 	struct inode *dir;
 	unsigned openflags = filp->f_flags;
+	fmode_t f_mode;
 	struct iattr attr;
 	int err;
 
@@ -50,8 +51,9 @@ nfs4_file_open(struct inode *inode, struct file *filp)
 	if (err)
 		return err;
 
+	f_mode = filp->f_mode;
 	if ((openflags & O_ACCMODE) == 3)
-		return nfs_open(inode, filp);
+		f_mode |= flags_to_mode(openflags);
 
 	/* We can't create new files here */
 	openflags &= ~(O_CREAT|O_EXCL);
@@ -59,7 +61,7 @@ nfs4_file_open(struct inode *inode, struct file *filp)
 	parent = dget_parent(dentry);
 	dir = d_inode(parent);
 
-	ctx = alloc_nfs_open_context(file_dentry(filp), filp->f_mode, filp);
+	ctx = alloc_nfs_open_context(file_dentry(filp), f_mode, filp);
 	err = PTR_ERR(ctx);
 	if (IS_ERR(ctx))
 		goto out;
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 51f5cb41e87a..57ea63e2cdb4 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -49,6 +49,7 @@
 #include <linux/workqueue.h>
 #include <linux/bitops.h>
 #include <linux/jiffies.h>
+#include <linux/sched/mm.h>
 
 #include <linux/sunrpc/clnt.h>
 
@@ -2559,9 +2560,17 @@ static void nfs4_layoutreturn_any_run(struct nfs_client *clp)
 
 static void nfs4_state_manager(struct nfs_client *clp)
 {
+	unsigned int memflags;
 	int status = 0;
 	const char *section = "", *section_sep = "";
 
+	/*
+	 * State recovery can deadlock if the direct reclaim code tries
+	 * start NFS writeback. So ensure memory allocations are all
+	 * GFP_NOFS.
+	 */
+	memflags = memalloc_nofs_save();
+
 	/* Ensure exclusive access to NFSv4 state */
 	do {
 		trace_nfs4_state_mgr(clp);
@@ -2656,6 +2665,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			clear_bit(NFS4CLNT_RECLAIM_NOGRACE, &clp->cl_state);
 		}
 
+		memalloc_nofs_restore(memflags);
 		nfs4_end_drain_session(clp);
 		nfs4_clear_state_manager_bit(clp);
 
@@ -2673,6 +2683,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			return;
 		if (test_and_set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state) != 0)
 			return;
+		memflags = memalloc_nofs_save();
 	} while (refcount_read(&clp->cl_count) > 1 && !signalled());
 	goto out_drain;
 
@@ -2685,6 +2696,7 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			clp->cl_hostname, -status);
 	ssleep(1);
 out_drain:
+	memalloc_nofs_restore(memflags);
 	nfs4_end_drain_session(clp);
 	nfs4_clear_state_manager_bit(clp);
 }
diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
index b1130dc200d2..f2fe23e6c51f 100644
--- a/fs/nfs/pagelist.c
+++ b/fs/nfs/pagelist.c
@@ -90,10 +90,10 @@ void nfs_set_pgio_error(struct nfs_pgio_header *hdr, int error, loff_t pos)
 	}
 }
 
-static inline struct nfs_page *
-nfs_page_alloc(void)
+static inline struct nfs_page *nfs_page_alloc(void)
 {
-	struct nfs_page	*p = kmem_cache_zalloc(nfs_page_cachep, GFP_KERNEL);
+	struct nfs_page *p =
+		kmem_cache_zalloc(nfs_page_cachep, nfs_io_gfp_mask());
 	if (p)
 		INIT_LIST_HEAD(&p->wb_list);
 	return p;
@@ -901,7 +901,7 @@ int nfs_generic_pgio(struct nfs_pageio_descriptor *desc,
 	struct nfs_commit_info cinfo;
 	struct nfs_page_array *pg_array = &hdr->page_array;
 	unsigned int pagecount, pageused;
-	gfp_t gfp_flags = GFP_KERNEL;
+	gfp_t gfp_flags = nfs_io_gfp_mask();
 
 	pagecount = nfs_page_array_len(mirror->pg_base, mirror->pg_count);
 	pg_array->npages = pagecount;
@@ -988,7 +988,7 @@ nfs_pageio_alloc_mirrors(struct nfs_pageio_descriptor *desc,
 	desc->pg_mirrors_dynamic = NULL;
 	if (mirror_count == 1)
 		return desc->pg_mirrors_static;
-	ret = kmalloc_array(mirror_count, sizeof(*ret), GFP_KERNEL);
+	ret = kmalloc_array(mirror_count, sizeof(*ret), nfs_io_gfp_mask());
 	if (ret != NULL) {
 		for (i = 0; i < mirror_count; i++)
 			nfs_pageio_mirror_init(&ret[i], desc->pg_bsize);
diff --git a/fs/nfs/pnfs_nfs.c b/fs/nfs/pnfs_nfs.c
index 316f68f96e57..657c242a18ff 100644
--- a/fs/nfs/pnfs_nfs.c
+++ b/fs/nfs/pnfs_nfs.c
@@ -419,7 +419,7 @@ static struct nfs_commit_data *
 pnfs_bucket_fetch_commitdata(struct pnfs_commit_bucket *bucket,
 			     struct nfs_commit_info *cinfo)
 {
-	struct nfs_commit_data *data = nfs_commitdata_alloc(false);
+	struct nfs_commit_data *data = nfs_commitdata_alloc();
 
 	if (!data)
 		return NULL;
@@ -515,7 +515,11 @@ pnfs_generic_commit_pagelist(struct inode *inode, struct list_head *mds_pages,
 	unsigned int nreq = 0;
 
 	if (!list_empty(mds_pages)) {
-		data = nfs_commitdata_alloc(true);
+		data = nfs_commitdata_alloc();
+		if (!data) {
+			nfs_retry_commit(mds_pages, NULL, cinfo, -1);
+			return -ENOMEM;
+		}
 		data->ds_commit_index = -1;
 		list_splice_init(mds_pages, &data->pages);
 		list_add_tail(&data->list, &list);
diff --git a/fs/nfs/write.c b/fs/nfs/write.c
index 0691b0b02147..d21b25511499 100644
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -70,27 +70,17 @@ static mempool_t *nfs_wdata_mempool;
 static struct kmem_cache *nfs_cdata_cachep;
 static mempool_t *nfs_commit_mempool;
 
-struct nfs_commit_data *nfs_commitdata_alloc(bool never_fail)
+struct nfs_commit_data *nfs_commitdata_alloc(void)
 {
 	struct nfs_commit_data *p;
 
-	if (never_fail)
-		p = mempool_alloc(nfs_commit_mempool, GFP_NOIO);
-	else {
-		/* It is OK to do some reclaim, not no safe to wait
-		 * for anything to be returned to the pool.
-		 * mempool_alloc() cannot handle that particular combination,
-		 * so we need two separate attempts.
-		 */
+	p = kmem_cache_zalloc(nfs_cdata_cachep, nfs_io_gfp_mask());
+	if (!p) {
 		p = mempool_alloc(nfs_commit_mempool, GFP_NOWAIT);
-		if (!p)
-			p = kmem_cache_alloc(nfs_cdata_cachep, GFP_NOIO |
-					     __GFP_NOWARN | __GFP_NORETRY);
 		if (!p)
 			return NULL;
+		memset(p, 0, sizeof(*p));
 	}
-
-	memset(p, 0, sizeof(*p));
 	INIT_LIST_HEAD(&p->pages);
 	return p;
 }
@@ -104,9 +94,15 @@ EXPORT_SYMBOL_GPL(nfs_commit_free);
 
 static struct nfs_pgio_header *nfs_writehdr_alloc(void)
 {
-	struct nfs_pgio_header *p = mempool_alloc(nfs_wdata_mempool, GFP_KERNEL);
+	struct nfs_pgio_header *p;
 
-	memset(p, 0, sizeof(*p));
+	p = kmem_cache_zalloc(nfs_wdata_cachep, nfs_io_gfp_mask());
+	if (!p) {
+		p = mempool_alloc(nfs_wdata_mempool, GFP_NOWAIT);
+		if (!p)
+			return NULL;
+		memset(p, 0, sizeof(*p));
+	}
 	p->rw_mode = FMODE_WRITE;
 	return p;
 }
@@ -1809,7 +1805,11 @@ nfs_commit_list(struct inode *inode, struct list_head *head, int how,
 	if (list_empty(head))
 		return 0;
 
-	data = nfs_commitdata_alloc(true);
+	data = nfs_commitdata_alloc();
+	if (!data) {
+		nfs_retry_commit(head, NULL, cinfo, -1);
+		return -ENOMEM;
+	}
 
 	/* Set up the argument struct */
 	nfs_init_commit(data, head, NULL, cinfo);
diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
index a0f9901dcae6..e3c29d2e6826 100644
--- a/include/linux/gpio/driver.h
+++ b/include/linux/gpio/driver.h
@@ -224,6 +224,15 @@ struct gpio_irq_chip {
 				unsigned long *valid_mask,
 				unsigned int ngpios);
 
+	/**
+	 * @initialized:
+	 *
+	 * Flag to track GPIO chip irq member's initialization.
+	 * This flag will make sure GPIO chip irq members are not used
+	 * before they are initialized.
+	 */
+	bool initialized;
+
 	/**
 	 * @valid_mask:
 	 *
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index 07cba0b3496d..d1f386430795 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -51,7 +51,7 @@ struct ipv6_devconf {
 	__s32		use_optimistic;
 #endif
 #ifdef CONFIG_IPV6_MROUTE
-	__s32		mc_forwarding;
+	atomic_t	mc_forwarding;
 #endif
 	__s32		disable_ipv6;
 	__s32		drop_unicast_in_l2_multicast;
diff --git a/include/linux/mc146818rtc.h b/include/linux/mc146818rtc.h
index 0661af17a758..37c74e25f53d 100644
--- a/include/linux/mc146818rtc.h
+++ b/include/linux/mc146818rtc.h
@@ -123,7 +123,8 @@ struct cmos_rtc_board_info {
 #define RTC_IO_EXTENT_USED      RTC_IO_EXTENT
 #endif /* ARCH_RTC_LOCATION */
 
-unsigned int mc146818_get_time(struct rtc_time *time);
+bool mc146818_does_rtc_work(void);
+int mc146818_get_time(struct rtc_time *time);
 int mc146818_set_time(struct rtc_time *time);
 
 #endif /* _MC146818RTC_H */
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index fa1ef98614bc..6ba100216530 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1351,13 +1351,16 @@ static inline unsigned long *section_to_usemap(struct mem_section *ms)
 
 static inline struct mem_section *__nr_to_section(unsigned long nr)
 {
+	unsigned long root = SECTION_NR_TO_ROOT(nr);
+
+	if (unlikely(root >= NR_SECTION_ROOTS))
+		return NULL;
+
 #ifdef CONFIG_SPARSEMEM_EXTREME
-	if (!mem_section)
+	if (!mem_section || !mem_section[root])
 		return NULL;
 #endif
-	if (!mem_section[SECTION_NR_TO_ROOT(nr)])
-		return NULL;
-	return &mem_section[SECTION_NR_TO_ROOT(nr)][nr & SECTION_ROOT_MASK];
+	return &mem_section[root][nr & SECTION_ROOT_MASK];
 }
 extern size_t mem_section_usage_size(void);
 
diff --git a/include/linux/nfs_fs.h b/include/linux/nfs_fs.h
index 4a733f140939..5ffcde9ac413 100644
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -494,10 +494,10 @@ static inline const struct cred *nfs_file_cred(struct file *file)
  * linux/fs/nfs/direct.c
  */
 extern ssize_t nfs_direct_IO(struct kiocb *, struct iov_iter *);
-extern ssize_t nfs_file_direct_read(struct kiocb *iocb,
-			struct iov_iter *iter);
-extern ssize_t nfs_file_direct_write(struct kiocb *iocb,
-			struct iov_iter *iter);
+ssize_t nfs_file_direct_read(struct kiocb *iocb,
+			     struct iov_iter *iter, bool swap);
+ssize_t nfs_file_direct_write(struct kiocb *iocb,
+			      struct iov_iter *iter, bool swap);
 
 /*
  * linux/fs/nfs/dir.c
@@ -567,7 +567,7 @@ extern int nfs_wb_all(struct inode *inode);
 extern int nfs_wb_page(struct inode *inode, struct page *page);
 extern int nfs_wb_page_cancel(struct inode *inode, struct page* page);
 extern int  nfs_commit_inode(struct inode *, int);
-extern struct nfs_commit_data *nfs_commitdata_alloc(bool never_fail);
+extern struct nfs_commit_data *nfs_commitdata_alloc(void);
 extern void nfs_commit_free(struct nfs_commit_data *data);
 bool nfs_commit_end(struct nfs_mds_commit_info *cinfo);
 
diff --git a/include/linux/stackdepot.h b/include/linux/stackdepot.h
index 6bb4bc1a5f54..22919a94ca19 100644
--- a/include/linux/stackdepot.h
+++ b/include/linux/stackdepot.h
@@ -19,8 +19,6 @@ depot_stack_handle_t stack_depot_save(unsigned long *entries,
 unsigned int stack_depot_fetch(depot_stack_handle_t handle,
 			       unsigned long **entries);
 
-unsigned int filter_irq_stacks(unsigned long *entries, unsigned int nr_entries);
-
 #ifdef CONFIG_STACKDEPOT
 int stack_depot_init(void);
 #else
diff --git a/include/linux/stacktrace.h b/include/linux/stacktrace.h
index 9edecb494e9e..bef158815e83 100644
--- a/include/linux/stacktrace.h
+++ b/include/linux/stacktrace.h
@@ -21,6 +21,7 @@ unsigned int stack_trace_save_tsk(struct task_struct *task,
 unsigned int stack_trace_save_regs(struct pt_regs *regs, unsigned long *store,
 				   unsigned int size, unsigned int skipnr);
 unsigned int stack_trace_save_user(unsigned long *store, unsigned int size);
+unsigned int filter_irq_stacks(unsigned long *entries, unsigned int nr_entries);
 
 /* Internal interfaces. Do not use in generic code */
 #ifdef CONFIG_ARCH_STACKWALK
diff --git a/include/linux/static_call.h b/include/linux/static_call.h
index 3e56a9751c06..fcc5b48989b3 100644
--- a/include/linux/static_call.h
+++ b/include/linux/static_call.h
@@ -248,10 +248,7 @@ static inline int static_call_text_reserved(void *start, void *end)
 	return 0;
 }
 
-static inline long __static_call_return0(void)
-{
-	return 0;
-}
+extern long __static_call_return0(void);
 
 #define EXPORT_STATIC_CALL(name)					\
 	EXPORT_SYMBOL(STATIC_CALL_KEY(name));				\
diff --git a/include/linux/sunrpc/xprtsock.h b/include/linux/sunrpc/xprtsock.h
index 8c2a712cb242..689062afdd61 100644
--- a/include/linux/sunrpc/xprtsock.h
+++ b/include/linux/sunrpc/xprtsock.h
@@ -89,5 +89,6 @@ struct sock_xprt {
 #define XPRT_SOCK_WAKE_WRITE	(5)
 #define XPRT_SOCK_WAKE_PENDING	(6)
 #define XPRT_SOCK_WAKE_DISCONNECT	(7)
+#define XPRT_SOCK_CONNECT_SENT	(8)
 
 #endif /* _LINUX_SUNRPC_XPRTSOCK_H */
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index ef9a44b6cf5d..ae6f4838ab75 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -159,8 +159,17 @@ extern ssize_t vfio_pci_config_rw(struct vfio_pci_core_device *vdev,
 extern ssize_t vfio_pci_bar_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite);
 
+#ifdef CONFIG_VFIO_PCI_VGA
 extern ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 			       size_t count, loff_t *ppos, bool iswrite);
+#else
+static inline ssize_t vfio_pci_vga_rw(struct vfio_pci_core_device *vdev,
+				      char __user *buf, size_t count,
+				      loff_t *ppos, bool iswrite)
+{
+	return -EINVAL;
+}
+#endif
 
 extern long vfio_pci_ioeventfd(struct vfio_pci_core_device *vdev, loff_t offset,
 			       uint64_t data, int count, int fd);
diff --git a/include/net/arp.h b/include/net/arp.h
index 4950191f6b2b..4a23a97195f3 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -71,6 +71,7 @@ void arp_send(int type, int ptype, __be32 dest_ip,
 	      const unsigned char *src_hw, const unsigned char *th);
 int arp_mc_map(__be32 addr, u8 *haddr, struct net_device *dev, int dir);
 void arp_ifdown(struct net_device *dev);
+int arp_invalidate(struct net_device *dev, __be32 ip, bool force);
 
 struct sk_buff *arp_create(int type, int ptype, __be32 dest_ip,
 			   struct net_device *dev, __be32 src_ip,
diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 9125effbf448..3fecc4a411a1 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -180,19 +180,21 @@ void bt_err_ratelimited(const char *fmt, ...);
 #define BT_DBG(fmt, ...)	pr_debug(fmt "\n", ##__VA_ARGS__)
 #endif
 
+#define bt_dev_name(hdev) ((hdev) ? (hdev)->name : "null")
+
 #define bt_dev_info(hdev, fmt, ...)				\
-	BT_INFO("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	BT_INFO("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 #define bt_dev_warn(hdev, fmt, ...)				\
-	BT_WARN("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	BT_WARN("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 #define bt_dev_err(hdev, fmt, ...)				\
-	BT_ERR("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	BT_ERR("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 #define bt_dev_dbg(hdev, fmt, ...)				\
-	BT_DBG("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	BT_DBG("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 
 #define bt_dev_warn_ratelimited(hdev, fmt, ...)			\
-	bt_warn_ratelimited("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	bt_warn_ratelimited("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 #define bt_dev_err_ratelimited(hdev, fmt, ...)			\
-	bt_err_ratelimited("%s: " fmt, (hdev)->name, ##__VA_ARGS__)
+	bt_err_ratelimited("%s: " fmt, bt_dev_name(hdev), ##__VA_ARGS__)
 
 /* Connection and socket states */
 enum {
diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index bb5fa5914032..2ba326f9e004 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -479,4 +479,10 @@ static inline void fnhe_genid_bump(struct net *net)
 	atomic_inc(&net->fnhe_genid);
 }
 
+#ifdef CONFIG_NET
+void net_ns_init(void);
+#else
+static inline void net_ns_init(void) {}
+#endif
+
 #endif /* __NET_NET_NAMESPACE_H */
diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
index e3fb5e520511..a887e582f0e7 100644
--- a/include/uapi/linux/bpf.h
+++ b/include/uapi/linux/bpf.h
@@ -5347,7 +5347,8 @@ struct bpf_sock {
 	__u32 src_ip4;
 	__u32 src_ip6[4];
 	__u32 src_port;		/* host byte order */
-	__u32 dst_port;		/* network byte order */
+	__be16 dst_port;	/* network byte order */
+	__u16 :16;		/* zero padding */
 	__u32 dst_ip4;
 	__u32 dst_ip6[4];
 	__u32 state;
@@ -6222,7 +6223,8 @@ struct bpf_sk_lookup {
 	__u32 protocol;		/* IP protocol (IPPROTO_TCP, IPPROTO_UDP) */
 	__u32 remote_ip4;	/* Network byte order */
 	__u32 remote_ip6[4];	/* Network byte order */
-	__u32 remote_port;	/* Network byte order */
+	__be16 remote_port;	/* Network byte order */
+	__u16 :16;		/* Zero padding */
 	__u32 local_ip4;	/* Network byte order */
 	__u32 local_ip6[4];	/* Network byte order */
 	__u32 local_port;	/* Host byte order */
diff --git a/include/uapi/linux/can/isotp.h b/include/uapi/linux/can/isotp.h
index c55935b64ccc..590f8aea2b6d 100644
--- a/include/uapi/linux/can/isotp.h
+++ b/include/uapi/linux/can/isotp.h
@@ -137,20 +137,16 @@ struct can_isotp_ll_options {
 #define CAN_ISOTP_WAIT_TX_DONE	0x400	/* wait for tx completion */
 #define CAN_ISOTP_SF_BROADCAST	0x800	/* 1-to-N functional addressing */
 
-/* default values */
+/* protocol machine default values */
 
 #define CAN_ISOTP_DEFAULT_FLAGS		0
 #define CAN_ISOTP_DEFAULT_EXT_ADDRESS	0x00
 #define CAN_ISOTP_DEFAULT_PAD_CONTENT	0xCC /* prevent bit-stuffing */
-#define CAN_ISOTP_DEFAULT_FRAME_TXTIME	0
+#define CAN_ISOTP_DEFAULT_FRAME_TXTIME	50000 /* 50 micro seconds */
 #define CAN_ISOTP_DEFAULT_RECV_BS	0
 #define CAN_ISOTP_DEFAULT_RECV_STMIN	0x00
 #define CAN_ISOTP_DEFAULT_RECV_WFTMAX	0
 
-#define CAN_ISOTP_DEFAULT_LL_MTU	CAN_MTU
-#define CAN_ISOTP_DEFAULT_LL_TX_DL	CAN_MAX_DLEN
-#define CAN_ISOTP_DEFAULT_LL_TX_FLAGS	0
-
 /*
  * Remark on CAN_ISOTP_DEFAULT_RECV_* values:
  *
@@ -162,4 +158,24 @@ struct can_isotp_ll_options {
  * consistency and copied directly into the flow control (FC) frame.
  */
 
+/* link layer default values => make use of Classical CAN frames */
+
+#define CAN_ISOTP_DEFAULT_LL_MTU	CAN_MTU
+#define CAN_ISOTP_DEFAULT_LL_TX_DL	CAN_MAX_DLEN
+#define CAN_ISOTP_DEFAULT_LL_TX_FLAGS	0
+
+/*
+ * The CAN_ISOTP_DEFAULT_FRAME_TXTIME has become a non-zero value as
+ * it only makes sense for isotp implementation tests to run without
+ * a N_As value. As user space applications usually do not set the
+ * frame_txtime element of struct can_isotp_options the new in-kernel
+ * default is very likely overwritten with zero when the sockopt()
+ * CAN_ISOTP_OPTS is invoked.
+ * To make sure that a N_As value of zero is only set intentional the
+ * value '0' is now interpreted as 'do not change the current value'.
+ * When a frame_txtime of zero is required for testing purposes this
+ * CAN_ISOTP_FRAME_TXTIME_ZERO u32 value has to be set in frame_txtime.
+ */
+#define CAN_ISOTP_FRAME_TXTIME_ZERO	0xFFFFFFFF
+
 #endif /* !_UAPI_CAN_ISOTP_H */
diff --git a/init/main.c b/init/main.c
index bcd132d4e7bd..06b98350ebd2 100644
--- a/init/main.c
+++ b/init/main.c
@@ -100,6 +100,7 @@
 #include <linux/kcsan.h>
 #include <linux/init_syscalls.h>
 #include <linux/stackdepot.h>
+#include <net/net_namespace.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -1122,6 +1123,7 @@ asmlinkage __visible void __init __no_sanitize_address start_kernel(void)
 	key_init();
 	security_init();
 	dbg_late_init();
+	net_ns_init();
 	vfs_caches_init();
 	pagecache_init();
 	signals_init();
@@ -1196,7 +1198,7 @@ static int __init initcall_blacklist(char *str)
 		}
 	} while (str_entry);
 
-	return 0;
+	return 1;
 }
 
 static bool __init_or_module initcall_blacklisted(initcall_t fn)
@@ -1458,7 +1460,9 @@ static noinline void __init kernel_init_freeable(void);
 bool rodata_enabled __ro_after_init = true;
 static int __init set_debug_rodata(char *str)
 {
-	return strtobool(str, &rodata_enabled);
+	if (strtobool(str, &rodata_enabled))
+		pr_warn("Invalid option string for rodata: '%s'\n", str);
+	return 1;
 }
 __setup("rodata=", set_debug_rodata);
 #endif
diff --git a/kernel/Makefile b/kernel/Makefile
index 4df609be42d0..0e119c52a2cd 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -113,7 +113,8 @@ obj-$(CONFIG_CPU_PM) += cpu_pm.o
 obj-$(CONFIG_BPF) += bpf/
 obj-$(CONFIG_KCSAN) += kcsan/
 obj-$(CONFIG_SHADOW_CALL_STACK) += scs.o
-obj-$(CONFIG_HAVE_STATIC_CALL_INLINE) += static_call.o
+obj-$(CONFIG_HAVE_STATIC_CALL) += static_call.o
+obj-$(CONFIG_HAVE_STATIC_CALL_INLINE) += static_call_inline.o
 obj-$(CONFIG_CFI_CLANG) += cfi.o
 
 obj-$(CONFIG_PERF_EVENTS) += events/
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 62022380ad8d..699446d60b6b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11596,6 +11596,9 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 	event->state		= PERF_EVENT_STATE_INACTIVE;
 
+	if (parent_event)
+		event->event_caps = parent_event->event_caps;
+
 	if (event->attr.sigtrap)
 		atomic_set(&event->event_limit, 1);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c51bd3692316..779f3198b17d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5927,7 +5927,7 @@ static bool try_steal_cookie(int this, int that)
 		if (p == src->core_pick || p == src->curr)
 			goto next;
 
-		if (!cpumask_test_cpu(this, &p->cpus_mask))
+		if (!is_cpu_allowed(p, this))
 			goto next;
 
 		if (p->core_occupation > dst->idle->core_occupation)
diff --git a/kernel/stacktrace.c b/kernel/stacktrace.c
index 9f8117c7cfdd..9c625257023d 100644
--- a/kernel/stacktrace.c
+++ b/kernel/stacktrace.c
@@ -13,6 +13,7 @@
 #include <linux/export.h>
 #include <linux/kallsyms.h>
 #include <linux/stacktrace.h>
+#include <linux/interrupt.h>
 
 /**
  * stack_trace_print - Print the entries in the stack trace
@@ -373,3 +374,32 @@ unsigned int stack_trace_save_user(unsigned long *store, unsigned int size)
 #endif /* CONFIG_USER_STACKTRACE_SUPPORT */
 
 #endif /* !CONFIG_ARCH_STACKWALK */
+
+static inline bool in_irqentry_text(unsigned long ptr)
+{
+	return (ptr >= (unsigned long)&__irqentry_text_start &&
+		ptr < (unsigned long)&__irqentry_text_end) ||
+		(ptr >= (unsigned long)&__softirqentry_text_start &&
+		 ptr < (unsigned long)&__softirqentry_text_end);
+}
+
+/**
+ * filter_irq_stacks - Find first IRQ stack entry in trace
+ * @entries:	Pointer to stack trace array
+ * @nr_entries:	Number of entries in the storage array
+ *
+ * Return: Number of trace entries until IRQ stack starts.
+ */
+unsigned int filter_irq_stacks(unsigned long *entries, unsigned int nr_entries)
+{
+	unsigned int i;
+
+	for (i = 0; i < nr_entries; i++) {
+		if (in_irqentry_text(entries[i])) {
+			/* Include the irqentry function into the stack. */
+			return i + 1;
+		}
+	}
+	return nr_entries;
+}
+EXPORT_SYMBOL_GPL(filter_irq_stacks);
diff --git a/kernel/static_call.c b/kernel/static_call.c
index 43ba0b1e0edb..e9c3e69f3837 100644
--- a/kernel/static_call.c
+++ b/kernel/static_call.c
@@ -1,548 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
-#include <linux/init.h>
 #include <linux/static_call.h>
-#include <linux/bug.h>
-#include <linux/smp.h>
-#include <linux/sort.h>
-#include <linux/slab.h>
-#include <linux/module.h>
-#include <linux/cpu.h>
-#include <linux/processor.h>
-#include <asm/sections.h>
-
-extern struct static_call_site __start_static_call_sites[],
-			       __stop_static_call_sites[];
-extern struct static_call_tramp_key __start_static_call_tramp_key[],
-				    __stop_static_call_tramp_key[];
-
-static bool static_call_initialized;
-
-/* mutex to protect key modules/sites */
-static DEFINE_MUTEX(static_call_mutex);
-
-static void static_call_lock(void)
-{
-	mutex_lock(&static_call_mutex);
-}
-
-static void static_call_unlock(void)
-{
-	mutex_unlock(&static_call_mutex);
-}
-
-static inline void *static_call_addr(struct static_call_site *site)
-{
-	return (void *)((long)site->addr + (long)&site->addr);
-}
-
-static inline unsigned long __static_call_key(const struct static_call_site *site)
-{
-	return (long)site->key + (long)&site->key;
-}
-
-static inline struct static_call_key *static_call_key(const struct static_call_site *site)
-{
-	return (void *)(__static_call_key(site) & ~STATIC_CALL_SITE_FLAGS);
-}
-
-/* These assume the key is word-aligned. */
-static inline bool static_call_is_init(struct static_call_site *site)
-{
-	return __static_call_key(site) & STATIC_CALL_SITE_INIT;
-}
-
-static inline bool static_call_is_tail(struct static_call_site *site)
-{
-	return __static_call_key(site) & STATIC_CALL_SITE_TAIL;
-}
-
-static inline void static_call_set_init(struct static_call_site *site)
-{
-	site->key = (__static_call_key(site) | STATIC_CALL_SITE_INIT) -
-		    (long)&site->key;
-}
-
-static int static_call_site_cmp(const void *_a, const void *_b)
-{
-	const struct static_call_site *a = _a;
-	const struct static_call_site *b = _b;
-	const struct static_call_key *key_a = static_call_key(a);
-	const struct static_call_key *key_b = static_call_key(b);
-
-	if (key_a < key_b)
-		return -1;
-
-	if (key_a > key_b)
-		return 1;
-
-	return 0;
-}
-
-static void static_call_site_swap(void *_a, void *_b, int size)
-{
-	long delta = (unsigned long)_a - (unsigned long)_b;
-	struct static_call_site *a = _a;
-	struct static_call_site *b = _b;
-	struct static_call_site tmp = *a;
-
-	a->addr = b->addr  - delta;
-	a->key  = b->key   - delta;
-
-	b->addr = tmp.addr + delta;
-	b->key  = tmp.key  + delta;
-}
-
-static inline void static_call_sort_entries(struct static_call_site *start,
-					    struct static_call_site *stop)
-{
-	sort(start, stop - start, sizeof(struct static_call_site),
-	     static_call_site_cmp, static_call_site_swap);
-}
-
-static inline bool static_call_key_has_mods(struct static_call_key *key)
-{
-	return !(key->type & 1);
-}
-
-static inline struct static_call_mod *static_call_key_next(struct static_call_key *key)
-{
-	if (!static_call_key_has_mods(key))
-		return NULL;
-
-	return key->mods;
-}
-
-static inline struct static_call_site *static_call_key_sites(struct static_call_key *key)
-{
-	if (static_call_key_has_mods(key))
-		return NULL;
-
-	return (struct static_call_site *)(key->type & ~1);
-}
-
-void __static_call_update(struct static_call_key *key, void *tramp, void *func)
-{
-	struct static_call_site *site, *stop;
-	struct static_call_mod *site_mod, first;
-
-	cpus_read_lock();
-	static_call_lock();
-
-	if (key->func == func)
-		goto done;
-
-	key->func = func;
-
-	arch_static_call_transform(NULL, tramp, func, false);
-
-	/*
-	 * If uninitialized, we'll not update the callsites, but they still
-	 * point to the trampoline and we just patched that.
-	 */
-	if (WARN_ON_ONCE(!static_call_initialized))
-		goto done;
-
-	first = (struct static_call_mod){
-		.next = static_call_key_next(key),
-		.mod = NULL,
-		.sites = static_call_key_sites(key),
-	};
-
-	for (site_mod = &first; site_mod; site_mod = site_mod->next) {
-		bool init = system_state < SYSTEM_RUNNING;
-		struct module *mod = site_mod->mod;
-
-		if (!site_mod->sites) {
-			/*
-			 * This can happen if the static call key is defined in
-			 * a module which doesn't use it.
-			 *
-			 * It also happens in the has_mods case, where the
-			 * 'first' entry has no sites associated with it.
-			 */
-			continue;
-		}
-
-		stop = __stop_static_call_sites;
-
-		if (mod) {
-#ifdef CONFIG_MODULES
-			stop = mod->static_call_sites +
-			       mod->num_static_call_sites;
-			init = mod->state == MODULE_STATE_COMING;
-#endif
-		}
-
-		for (site = site_mod->sites;
-		     site < stop && static_call_key(site) == key; site++) {
-			void *site_addr = static_call_addr(site);
-
-			if (!init && static_call_is_init(site))
-				continue;
-
-			if (!kernel_text_address((unsigned long)site_addr)) {
-				/*
-				 * This skips patching built-in __exit, which
-				 * is part of init_section_contains() but is
-				 * not part of kernel_text_address().
-				 *
-				 * Skipping built-in __exit is fine since it
-				 * will never be executed.
-				 */
-				WARN_ONCE(!static_call_is_init(site),
-					  "can't patch static call site at %pS",
-					  site_addr);
-				continue;
-			}
-
-			arch_static_call_transform(site_addr, NULL, func,
-						   static_call_is_tail(site));
-		}
-	}
-
-done:
-	static_call_unlock();
-	cpus_read_unlock();
-}
-EXPORT_SYMBOL_GPL(__static_call_update);
-
-static int __static_call_init(struct module *mod,
-			      struct static_call_site *start,
-			      struct static_call_site *stop)
-{
-	struct static_call_site *site;
-	struct static_call_key *key, *prev_key = NULL;
-	struct static_call_mod *site_mod;
-
-	if (start == stop)
-		return 0;
-
-	static_call_sort_entries(start, stop);
-
-	for (site = start; site < stop; site++) {
-		void *site_addr = static_call_addr(site);
-
-		if ((mod && within_module_init((unsigned long)site_addr, mod)) ||
-		    (!mod && init_section_contains(site_addr, 1)))
-			static_call_set_init(site);
-
-		key = static_call_key(site);
-		if (key != prev_key) {
-			prev_key = key;
-
-			/*
-			 * For vmlinux (!mod) avoid the allocation by storing
-			 * the sites pointer in the key itself. Also see
-			 * __static_call_update()'s @first.
-			 *
-			 * This allows architectures (eg. x86) to call
-			 * static_call_init() before memory allocation works.
-			 */
-			if (!mod) {
-				key->sites = site;
-				key->type |= 1;
-				goto do_transform;
-			}
-
-			site_mod = kzalloc(sizeof(*site_mod), GFP_KERNEL);
-			if (!site_mod)
-				return -ENOMEM;
-
-			/*
-			 * When the key has a direct sites pointer, extract
-			 * that into an explicit struct static_call_mod, so we
-			 * can have a list of modules.
-			 */
-			if (static_call_key_sites(key)) {
-				site_mod->mod = NULL;
-				site_mod->next = NULL;
-				site_mod->sites = static_call_key_sites(key);
-
-				key->mods = site_mod;
-
-				site_mod = kzalloc(sizeof(*site_mod), GFP_KERNEL);
-				if (!site_mod)
-					return -ENOMEM;
-			}
-
-			site_mod->mod = mod;
-			site_mod->sites = site;
-			site_mod->next = static_call_key_next(key);
-			key->mods = site_mod;
-		}
-
-do_transform:
-		arch_static_call_transform(site_addr, NULL, key->func,
-				static_call_is_tail(site));
-	}
-
-	return 0;
-}
-
-static int addr_conflict(struct static_call_site *site, void *start, void *end)
-{
-	unsigned long addr = (unsigned long)static_call_addr(site);
-
-	if (addr <= (unsigned long)end &&
-	    addr + CALL_INSN_SIZE > (unsigned long)start)
-		return 1;
-
-	return 0;
-}
-
-static int __static_call_text_reserved(struct static_call_site *iter_start,
-				       struct static_call_site *iter_stop,
-				       void *start, void *end, bool init)
-{
-	struct static_call_site *iter = iter_start;
-
-	while (iter < iter_stop) {
-		if (init || !static_call_is_init(iter)) {
-			if (addr_conflict(iter, start, end))
-				return 1;
-		}
-		iter++;
-	}
-
-	return 0;
-}
-
-#ifdef CONFIG_MODULES
-
-static int __static_call_mod_text_reserved(void *start, void *end)
-{
-	struct module *mod;
-	int ret;
-
-	preempt_disable();
-	mod = __module_text_address((unsigned long)start);
-	WARN_ON_ONCE(__module_text_address((unsigned long)end) != mod);
-	if (!try_module_get(mod))
-		mod = NULL;
-	preempt_enable();
-
-	if (!mod)
-		return 0;
-
-	ret = __static_call_text_reserved(mod->static_call_sites,
-			mod->static_call_sites + mod->num_static_call_sites,
-			start, end, mod->state == MODULE_STATE_COMING);
-
-	module_put(mod);
-
-	return ret;
-}
-
-static unsigned long tramp_key_lookup(unsigned long addr)
-{
-	struct static_call_tramp_key *start = __start_static_call_tramp_key;
-	struct static_call_tramp_key *stop = __stop_static_call_tramp_key;
-	struct static_call_tramp_key *tramp_key;
-
-	for (tramp_key = start; tramp_key != stop; tramp_key++) {
-		unsigned long tramp;
-
-		tramp = (long)tramp_key->tramp + (long)&tramp_key->tramp;
-		if (tramp == addr)
-			return (long)tramp_key->key + (long)&tramp_key->key;
-	}
-
-	return 0;
-}
-
-static int static_call_add_module(struct module *mod)
-{
-	struct static_call_site *start = mod->static_call_sites;
-	struct static_call_site *stop = start + mod->num_static_call_sites;
-	struct static_call_site *site;
-
-	for (site = start; site != stop; site++) {
-		unsigned long s_key = __static_call_key(site);
-		unsigned long addr = s_key & ~STATIC_CALL_SITE_FLAGS;
-		unsigned long key;
-
-		/*
-		 * Is the key is exported, 'addr' points to the key, which
-		 * means modules are allowed to call static_call_update() on
-		 * it.
-		 *
-		 * Otherwise, the key isn't exported, and 'addr' points to the
-		 * trampoline so we need to lookup the key.
-		 *
-		 * We go through this dance to prevent crazy modules from
-		 * abusing sensitive static calls.
-		 */
-		if (!kernel_text_address(addr))
-			continue;
-
-		key = tramp_key_lookup(addr);
-		if (!key) {
-			pr_warn("Failed to fixup __raw_static_call() usage at: %ps\n",
-				static_call_addr(site));
-			return -EINVAL;
-		}
-
-		key |= s_key & STATIC_CALL_SITE_FLAGS;
-		site->key = key - (long)&site->key;
-	}
-
-	return __static_call_init(mod, start, stop);
-}
-
-static void static_call_del_module(struct module *mod)
-{
-	struct static_call_site *start = mod->static_call_sites;
-	struct static_call_site *stop = mod->static_call_sites +
-					mod->num_static_call_sites;
-	struct static_call_key *key, *prev_key = NULL;
-	struct static_call_mod *site_mod, **prev;
-	struct static_call_site *site;
-
-	for (site = start; site < stop; site++) {
-		key = static_call_key(site);
-		if (key == prev_key)
-			continue;
-
-		prev_key = key;
-
-		for (prev = &key->mods, site_mod = key->mods;
-		     site_mod && site_mod->mod != mod;
-		     prev = &site_mod->next, site_mod = site_mod->next)
-			;
-
-		if (!site_mod)
-			continue;
-
-		*prev = site_mod->next;
-		kfree(site_mod);
-	}
-}
-
-static int static_call_module_notify(struct notifier_block *nb,
-				     unsigned long val, void *data)
-{
-	struct module *mod = data;
-	int ret = 0;
-
-	cpus_read_lock();
-	static_call_lock();
-
-	switch (val) {
-	case MODULE_STATE_COMING:
-		ret = static_call_add_module(mod);
-		if (ret) {
-			WARN(1, "Failed to allocate memory for static calls");
-			static_call_del_module(mod);
-		}
-		break;
-	case MODULE_STATE_GOING:
-		static_call_del_module(mod);
-		break;
-	}
-
-	static_call_unlock();
-	cpus_read_unlock();
-
-	return notifier_from_errno(ret);
-}
-
-static struct notifier_block static_call_module_nb = {
-	.notifier_call = static_call_module_notify,
-};
-
-#else
-
-static inline int __static_call_mod_text_reserved(void *start, void *end)
-{
-	return 0;
-}
-
-#endif /* CONFIG_MODULES */
-
-int static_call_text_reserved(void *start, void *end)
-{
-	bool init = system_state < SYSTEM_RUNNING;
-	int ret = __static_call_text_reserved(__start_static_call_sites,
-			__stop_static_call_sites, start, end, init);
-
-	if (ret)
-		return ret;
-
-	return __static_call_mod_text_reserved(start, end);
-}
-
-int __init static_call_init(void)
-{
-	int ret;
-
-	if (static_call_initialized)
-		return 0;
-
-	cpus_read_lock();
-	static_call_lock();
-	ret = __static_call_init(NULL, __start_static_call_sites,
-				 __stop_static_call_sites);
-	static_call_unlock();
-	cpus_read_unlock();
-
-	if (ret) {
-		pr_err("Failed to allocate memory for static_call!\n");
-		BUG();
-	}
-
-	static_call_initialized = true;
-
-#ifdef CONFIG_MODULES
-	register_module_notifier(&static_call_module_nb);
-#endif
-	return 0;
-}
-early_initcall(static_call_init);
 
 long __static_call_return0(void)
 {
 	return 0;
 }
-
-#ifdef CONFIG_STATIC_CALL_SELFTEST
-
-static int func_a(int x)
-{
-	return x+1;
-}
-
-static int func_b(int x)
-{
-	return x+2;
-}
-
-DEFINE_STATIC_CALL(sc_selftest, func_a);
-
-static struct static_call_data {
-      int (*func)(int);
-      int val;
-      int expect;
-} static_call_data [] __initdata = {
-      { NULL,   2, 3 },
-      { func_b, 2, 4 },
-      { func_a, 2, 3 }
-};
-
-static int __init test_static_call_init(void)
-{
-      int i;
-
-      for (i = 0; i < ARRAY_SIZE(static_call_data); i++ ) {
-	      struct static_call_data *scd = &static_call_data[i];
-
-              if (scd->func)
-                      static_call_update(sc_selftest, scd->func);
-
-              WARN_ON(static_call(sc_selftest)(scd->val) != scd->expect);
-      }
-
-      return 0;
-}
-early_initcall(test_static_call_init);
-
-#endif /* CONFIG_STATIC_CALL_SELFTEST */
+EXPORT_SYMBOL_GPL(__static_call_return0);
diff --git a/kernel/static_call_inline.c b/kernel/static_call_inline.c
new file mode 100644
index 000000000000..dc5665b62814
--- /dev/null
+++ b/kernel/static_call_inline.c
@@ -0,0 +1,543 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/init.h>
+#include <linux/static_call.h>
+#include <linux/bug.h>
+#include <linux/smp.h>
+#include <linux/sort.h>
+#include <linux/slab.h>
+#include <linux/module.h>
+#include <linux/cpu.h>
+#include <linux/processor.h>
+#include <asm/sections.h>
+
+extern struct static_call_site __start_static_call_sites[],
+			       __stop_static_call_sites[];
+extern struct static_call_tramp_key __start_static_call_tramp_key[],
+				    __stop_static_call_tramp_key[];
+
+static bool static_call_initialized;
+
+/* mutex to protect key modules/sites */
+static DEFINE_MUTEX(static_call_mutex);
+
+static void static_call_lock(void)
+{
+	mutex_lock(&static_call_mutex);
+}
+
+static void static_call_unlock(void)
+{
+	mutex_unlock(&static_call_mutex);
+}
+
+static inline void *static_call_addr(struct static_call_site *site)
+{
+	return (void *)((long)site->addr + (long)&site->addr);
+}
+
+static inline unsigned long __static_call_key(const struct static_call_site *site)
+{
+	return (long)site->key + (long)&site->key;
+}
+
+static inline struct static_call_key *static_call_key(const struct static_call_site *site)
+{
+	return (void *)(__static_call_key(site) & ~STATIC_CALL_SITE_FLAGS);
+}
+
+/* These assume the key is word-aligned. */
+static inline bool static_call_is_init(struct static_call_site *site)
+{
+	return __static_call_key(site) & STATIC_CALL_SITE_INIT;
+}
+
+static inline bool static_call_is_tail(struct static_call_site *site)
+{
+	return __static_call_key(site) & STATIC_CALL_SITE_TAIL;
+}
+
+static inline void static_call_set_init(struct static_call_site *site)
+{
+	site->key = (__static_call_key(site) | STATIC_CALL_SITE_INIT) -
+		    (long)&site->key;
+}
+
+static int static_call_site_cmp(const void *_a, const void *_b)
+{
+	const struct static_call_site *a = _a;
+	const struct static_call_site *b = _b;
+	const struct static_call_key *key_a = static_call_key(a);
+	const struct static_call_key *key_b = static_call_key(b);
+
+	if (key_a < key_b)
+		return -1;
+
+	if (key_a > key_b)
+		return 1;
+
+	return 0;
+}
+
+static void static_call_site_swap(void *_a, void *_b, int size)
+{
+	long delta = (unsigned long)_a - (unsigned long)_b;
+	struct static_call_site *a = _a;
+	struct static_call_site *b = _b;
+	struct static_call_site tmp = *a;
+
+	a->addr = b->addr  - delta;
+	a->key  = b->key   - delta;
+
+	b->addr = tmp.addr + delta;
+	b->key  = tmp.key  + delta;
+}
+
+static inline void static_call_sort_entries(struct static_call_site *start,
+					    struct static_call_site *stop)
+{
+	sort(start, stop - start, sizeof(struct static_call_site),
+	     static_call_site_cmp, static_call_site_swap);
+}
+
+static inline bool static_call_key_has_mods(struct static_call_key *key)
+{
+	return !(key->type & 1);
+}
+
+static inline struct static_call_mod *static_call_key_next(struct static_call_key *key)
+{
+	if (!static_call_key_has_mods(key))
+		return NULL;
+
+	return key->mods;
+}
+
+static inline struct static_call_site *static_call_key_sites(struct static_call_key *key)
+{
+	if (static_call_key_has_mods(key))
+		return NULL;
+
+	return (struct static_call_site *)(key->type & ~1);
+}
+
+void __static_call_update(struct static_call_key *key, void *tramp, void *func)
+{
+	struct static_call_site *site, *stop;
+	struct static_call_mod *site_mod, first;
+
+	cpus_read_lock();
+	static_call_lock();
+
+	if (key->func == func)
+		goto done;
+
+	key->func = func;
+
+	arch_static_call_transform(NULL, tramp, func, false);
+
+	/*
+	 * If uninitialized, we'll not update the callsites, but they still
+	 * point to the trampoline and we just patched that.
+	 */
+	if (WARN_ON_ONCE(!static_call_initialized))
+		goto done;
+
+	first = (struct static_call_mod){
+		.next = static_call_key_next(key),
+		.mod = NULL,
+		.sites = static_call_key_sites(key),
+	};
+
+	for (site_mod = &first; site_mod; site_mod = site_mod->next) {
+		bool init = system_state < SYSTEM_RUNNING;
+		struct module *mod = site_mod->mod;
+
+		if (!site_mod->sites) {
+			/*
+			 * This can happen if the static call key is defined in
+			 * a module which doesn't use it.
+			 *
+			 * It also happens in the has_mods case, where the
+			 * 'first' entry has no sites associated with it.
+			 */
+			continue;
+		}
+
+		stop = __stop_static_call_sites;
+
+		if (mod) {
+#ifdef CONFIG_MODULES
+			stop = mod->static_call_sites +
+			       mod->num_static_call_sites;
+			init = mod->state == MODULE_STATE_COMING;
+#endif
+		}
+
+		for (site = site_mod->sites;
+		     site < stop && static_call_key(site) == key; site++) {
+			void *site_addr = static_call_addr(site);
+
+			if (!init && static_call_is_init(site))
+				continue;
+
+			if (!kernel_text_address((unsigned long)site_addr)) {
+				/*
+				 * This skips patching built-in __exit, which
+				 * is part of init_section_contains() but is
+				 * not part of kernel_text_address().
+				 *
+				 * Skipping built-in __exit is fine since it
+				 * will never be executed.
+				 */
+				WARN_ONCE(!static_call_is_init(site),
+					  "can't patch static call site at %pS",
+					  site_addr);
+				continue;
+			}
+
+			arch_static_call_transform(site_addr, NULL, func,
+						   static_call_is_tail(site));
+		}
+	}
+
+done:
+	static_call_unlock();
+	cpus_read_unlock();
+}
+EXPORT_SYMBOL_GPL(__static_call_update);
+
+static int __static_call_init(struct module *mod,
+			      struct static_call_site *start,
+			      struct static_call_site *stop)
+{
+	struct static_call_site *site;
+	struct static_call_key *key, *prev_key = NULL;
+	struct static_call_mod *site_mod;
+
+	if (start == stop)
+		return 0;
+
+	static_call_sort_entries(start, stop);
+
+	for (site = start; site < stop; site++) {
+		void *site_addr = static_call_addr(site);
+
+		if ((mod && within_module_init((unsigned long)site_addr, mod)) ||
+		    (!mod && init_section_contains(site_addr, 1)))
+			static_call_set_init(site);
+
+		key = static_call_key(site);
+		if (key != prev_key) {
+			prev_key = key;
+
+			/*
+			 * For vmlinux (!mod) avoid the allocation by storing
+			 * the sites pointer in the key itself. Also see
+			 * __static_call_update()'s @first.
+			 *
+			 * This allows architectures (eg. x86) to call
+			 * static_call_init() before memory allocation works.
+			 */
+			if (!mod) {
+				key->sites = site;
+				key->type |= 1;
+				goto do_transform;
+			}
+
+			site_mod = kzalloc(sizeof(*site_mod), GFP_KERNEL);
+			if (!site_mod)
+				return -ENOMEM;
+
+			/*
+			 * When the key has a direct sites pointer, extract
+			 * that into an explicit struct static_call_mod, so we
+			 * can have a list of modules.
+			 */
+			if (static_call_key_sites(key)) {
+				site_mod->mod = NULL;
+				site_mod->next = NULL;
+				site_mod->sites = static_call_key_sites(key);
+
+				key->mods = site_mod;
+
+				site_mod = kzalloc(sizeof(*site_mod), GFP_KERNEL);
+				if (!site_mod)
+					return -ENOMEM;
+			}
+
+			site_mod->mod = mod;
+			site_mod->sites = site;
+			site_mod->next = static_call_key_next(key);
+			key->mods = site_mod;
+		}
+
+do_transform:
+		arch_static_call_transform(site_addr, NULL, key->func,
+				static_call_is_tail(site));
+	}
+
+	return 0;
+}
+
+static int addr_conflict(struct static_call_site *site, void *start, void *end)
+{
+	unsigned long addr = (unsigned long)static_call_addr(site);
+
+	if (addr <= (unsigned long)end &&
+	    addr + CALL_INSN_SIZE > (unsigned long)start)
+		return 1;
+
+	return 0;
+}
+
+static int __static_call_text_reserved(struct static_call_site *iter_start,
+				       struct static_call_site *iter_stop,
+				       void *start, void *end, bool init)
+{
+	struct static_call_site *iter = iter_start;
+
+	while (iter < iter_stop) {
+		if (init || !static_call_is_init(iter)) {
+			if (addr_conflict(iter, start, end))
+				return 1;
+		}
+		iter++;
+	}
+
+	return 0;
+}
+
+#ifdef CONFIG_MODULES
+
+static int __static_call_mod_text_reserved(void *start, void *end)
+{
+	struct module *mod;
+	int ret;
+
+	preempt_disable();
+	mod = __module_text_address((unsigned long)start);
+	WARN_ON_ONCE(__module_text_address((unsigned long)end) != mod);
+	if (!try_module_get(mod))
+		mod = NULL;
+	preempt_enable();
+
+	if (!mod)
+		return 0;
+
+	ret = __static_call_text_reserved(mod->static_call_sites,
+			mod->static_call_sites + mod->num_static_call_sites,
+			start, end, mod->state == MODULE_STATE_COMING);
+
+	module_put(mod);
+
+	return ret;
+}
+
+static unsigned long tramp_key_lookup(unsigned long addr)
+{
+	struct static_call_tramp_key *start = __start_static_call_tramp_key;
+	struct static_call_tramp_key *stop = __stop_static_call_tramp_key;
+	struct static_call_tramp_key *tramp_key;
+
+	for (tramp_key = start; tramp_key != stop; tramp_key++) {
+		unsigned long tramp;
+
+		tramp = (long)tramp_key->tramp + (long)&tramp_key->tramp;
+		if (tramp == addr)
+			return (long)tramp_key->key + (long)&tramp_key->key;
+	}
+
+	return 0;
+}
+
+static int static_call_add_module(struct module *mod)
+{
+	struct static_call_site *start = mod->static_call_sites;
+	struct static_call_site *stop = start + mod->num_static_call_sites;
+	struct static_call_site *site;
+
+	for (site = start; site != stop; site++) {
+		unsigned long s_key = __static_call_key(site);
+		unsigned long addr = s_key & ~STATIC_CALL_SITE_FLAGS;
+		unsigned long key;
+
+		/*
+		 * Is the key is exported, 'addr' points to the key, which
+		 * means modules are allowed to call static_call_update() on
+		 * it.
+		 *
+		 * Otherwise, the key isn't exported, and 'addr' points to the
+		 * trampoline so we need to lookup the key.
+		 *
+		 * We go through this dance to prevent crazy modules from
+		 * abusing sensitive static calls.
+		 */
+		if (!kernel_text_address(addr))
+			continue;
+
+		key = tramp_key_lookup(addr);
+		if (!key) {
+			pr_warn("Failed to fixup __raw_static_call() usage at: %ps\n",
+				static_call_addr(site));
+			return -EINVAL;
+		}
+
+		key |= s_key & STATIC_CALL_SITE_FLAGS;
+		site->key = key - (long)&site->key;
+	}
+
+	return __static_call_init(mod, start, stop);
+}
+
+static void static_call_del_module(struct module *mod)
+{
+	struct static_call_site *start = mod->static_call_sites;
+	struct static_call_site *stop = mod->static_call_sites +
+					mod->num_static_call_sites;
+	struct static_call_key *key, *prev_key = NULL;
+	struct static_call_mod *site_mod, **prev;
+	struct static_call_site *site;
+
+	for (site = start; site < stop; site++) {
+		key = static_call_key(site);
+		if (key == prev_key)
+			continue;
+
+		prev_key = key;
+
+		for (prev = &key->mods, site_mod = key->mods;
+		     site_mod && site_mod->mod != mod;
+		     prev = &site_mod->next, site_mod = site_mod->next)
+			;
+
+		if (!site_mod)
+			continue;
+
+		*prev = site_mod->next;
+		kfree(site_mod);
+	}
+}
+
+static int static_call_module_notify(struct notifier_block *nb,
+				     unsigned long val, void *data)
+{
+	struct module *mod = data;
+	int ret = 0;
+
+	cpus_read_lock();
+	static_call_lock();
+
+	switch (val) {
+	case MODULE_STATE_COMING:
+		ret = static_call_add_module(mod);
+		if (ret) {
+			WARN(1, "Failed to allocate memory for static calls");
+			static_call_del_module(mod);
+		}
+		break;
+	case MODULE_STATE_GOING:
+		static_call_del_module(mod);
+		break;
+	}
+
+	static_call_unlock();
+	cpus_read_unlock();
+
+	return notifier_from_errno(ret);
+}
+
+static struct notifier_block static_call_module_nb = {
+	.notifier_call = static_call_module_notify,
+};
+
+#else
+
+static inline int __static_call_mod_text_reserved(void *start, void *end)
+{
+	return 0;
+}
+
+#endif /* CONFIG_MODULES */
+
+int static_call_text_reserved(void *start, void *end)
+{
+	bool init = system_state < SYSTEM_RUNNING;
+	int ret = __static_call_text_reserved(__start_static_call_sites,
+			__stop_static_call_sites, start, end, init);
+
+	if (ret)
+		return ret;
+
+	return __static_call_mod_text_reserved(start, end);
+}
+
+int __init static_call_init(void)
+{
+	int ret;
+
+	if (static_call_initialized)
+		return 0;
+
+	cpus_read_lock();
+	static_call_lock();
+	ret = __static_call_init(NULL, __start_static_call_sites,
+				 __stop_static_call_sites);
+	static_call_unlock();
+	cpus_read_unlock();
+
+	if (ret) {
+		pr_err("Failed to allocate memory for static_call!\n");
+		BUG();
+	}
+
+	static_call_initialized = true;
+
+#ifdef CONFIG_MODULES
+	register_module_notifier(&static_call_module_nb);
+#endif
+	return 0;
+}
+early_initcall(static_call_init);
+
+#ifdef CONFIG_STATIC_CALL_SELFTEST
+
+static int func_a(int x)
+{
+	return x+1;
+}
+
+static int func_b(int x)
+{
+	return x+2;
+}
+
+DEFINE_STATIC_CALL(sc_selftest, func_a);
+
+static struct static_call_data {
+      int (*func)(int);
+      int val;
+      int expect;
+} static_call_data [] __initdata = {
+      { NULL,   2, 3 },
+      { func_b, 2, 4 },
+      { func_a, 2, 3 }
+};
+
+static int __init test_static_call_init(void)
+{
+      int i;
+
+      for (i = 0; i < ARRAY_SIZE(static_call_data); i++ ) {
+	      struct static_call_data *scd = &static_call_data[i];
+
+              if (scd->func)
+                      static_call_update(sc_selftest, scd->func);
+
+              WARN_ON(static_call(sc_selftest)(scd->val) != scd->expect);
+      }
+
+      return 0;
+}
+early_initcall(test_static_call_init);
+
+#endif /* CONFIG_STATIC_CALL_SELFTEST */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 2a9b6dcdac4f..55e89b237b6f 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -414,7 +414,8 @@ config SECTION_MISMATCH_WARN_ONLY
 	  If unsure, say Y.
 
 config DEBUG_FORCE_FUNCTION_ALIGN_64B
-	bool "Force all function address 64B aligned" if EXPERT
+	bool "Force all function address 64B aligned"
+	depends on EXPERT && (X86_64 || ARM64 || PPC32 || PPC64 || ARC)
 	help
 	  There are cases that a commit from one domain changes the function
 	  address alignment of other domains, and cause magic performance
diff --git a/lib/Kconfig.ubsan b/lib/Kconfig.ubsan
index e5372a13511d..236c5cefc4cc 100644
--- a/lib/Kconfig.ubsan
+++ b/lib/Kconfig.ubsan
@@ -112,19 +112,6 @@ config UBSAN_UNREACHABLE
 	  This option enables -fsanitize=unreachable which checks for control
 	  flow reaching an expected-to-be-unreachable position.
 
-config UBSAN_OBJECT_SIZE
-	bool "Perform checking for accesses beyond the end of objects"
-	default UBSAN
-	# gcc hugely expands stack usage with -fsanitize=object-size
-	# https://lore.kernel.org/lkml/CAHk-=wjPasyJrDuwDnpHJS2TuQfExwe=px-SzLeN8GFMAQJPmQ@mail.gmail.com/
-	depends on !CC_IS_GCC
-	depends on $(cc-option,-fsanitize=object-size)
-	help
-	  This option enables -fsanitize=object-size which checks for accesses
-	  beyond the end of objects where the optimizer can determine both the
-	  object being operated on and its size, usually seen with bad downcasts,
-	  or access to struct members from NULL pointers.
-
 config UBSAN_BOOL
 	bool "Perform checking for non-boolean values used as boolean"
 	default UBSAN
diff --git a/lib/logic_iomem.c b/lib/logic_iomem.c
index 549b22d4bcde..e7ea9b28d8db 100644
--- a/lib/logic_iomem.c
+++ b/lib/logic_iomem.c
@@ -68,7 +68,7 @@ int logic_iomem_add_region(struct resource *resource,
 }
 EXPORT_SYMBOL(logic_iomem_add_region);
 
-#ifndef CONFIG_LOGIC_IOMEM_FALLBACK
+#ifndef CONFIG_INDIRECT_IOMEM_FALLBACK
 static void __iomem *real_ioremap(phys_addr_t offset, size_t size)
 {
 	WARN(1, "invalid ioremap(0x%llx, 0x%zx)\n",
@@ -81,7 +81,7 @@ static void real_iounmap(void __iomem *addr)
 	WARN(1, "invalid iounmap for addr 0x%llx\n",
 	     (unsigned long long)(uintptr_t __force)addr);
 }
-#endif /* CONFIG_LOGIC_IOMEM_FALLBACK */
+#endif /* CONFIG_INDIRECT_IOMEM_FALLBACK */
 
 void __iomem *ioremap(phys_addr_t offset, size_t size)
 {
@@ -168,7 +168,7 @@ void iounmap(void __iomem *addr)
 }
 EXPORT_SYMBOL(iounmap);
 
-#ifndef CONFIG_LOGIC_IOMEM_FALLBACK
+#ifndef CONFIG_INDIRECT_IOMEM_FALLBACK
 #define MAKE_FALLBACK(op, sz) 						\
 static u##sz real_raw_read ## op(const volatile void __iomem *addr)	\
 {									\
@@ -213,7 +213,7 @@ static void real_memcpy_toio(volatile void __iomem *addr, const void *buffer,
 	WARN(1, "Invalid memcpy_toio at address 0x%llx\n",
 	     (unsigned long long)(uintptr_t __force)addr);
 }
-#endif /* CONFIG_LOGIC_IOMEM_FALLBACK */
+#endif /* CONFIG_INDIRECT_IOMEM_FALLBACK */
 
 #define MAKE_OP(op, sz) 						\
 u##sz __raw_read ## op(const volatile void __iomem *addr)		\
diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
index 926f4823d5ea..fd1728d94bab 100644
--- a/lib/lz4/lz4_decompress.c
+++ b/lib/lz4/lz4_decompress.c
@@ -271,8 +271,12 @@ static FORCE_INLINE int LZ4_decompress_generic(
 			ip += length;
 			op += length;
 
-			/* Necessarily EOF, due to parsing restrictions */
-			if (!partialDecoding || (cpy == oend))
+			/* Necessarily EOF when !partialDecoding.
+			 * When partialDecoding, it is EOF if we've either
+			 * filled the output buffer or
+			 * can't proceed with reading an offset for following match.
+			 */
+			if (!partialDecoding || (cpy == oend) || (ip >= (iend - 2)))
 				break;
 		} else {
 			/* may overwrite up to WILDCOPYLENGTH beyond cpy */
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index 0a2e417f83cb..e90f0f19e77f 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -20,7 +20,6 @@
  */
 
 #include <linux/gfp.h>
-#include <linux/interrupt.h>
 #include <linux/jhash.h>
 #include <linux/kernel.h>
 #include <linux/mm.h>
@@ -341,26 +340,3 @@ depot_stack_handle_t stack_depot_save(unsigned long *entries,
 	return retval;
 }
 EXPORT_SYMBOL_GPL(stack_depot_save);
-
-static inline int in_irqentry_text(unsigned long ptr)
-{
-	return (ptr >= (unsigned long)&__irqentry_text_start &&
-		ptr < (unsigned long)&__irqentry_text_end) ||
-		(ptr >= (unsigned long)&__softirqentry_text_start &&
-		 ptr < (unsigned long)&__softirqentry_text_end);
-}
-
-unsigned int filter_irq_stacks(unsigned long *entries,
-					     unsigned int nr_entries)
-{
-	unsigned int i;
-
-	for (i = 0; i < nr_entries; i++) {
-		if (in_irqentry_text(entries[i])) {
-			/* Include the irqentry function into the stack. */
-			return i + 1;
-		}
-	}
-	return nr_entries;
-}
-EXPORT_SYMBOL_GPL(filter_irq_stacks);
diff --git a/lib/test_ubsan.c b/lib/test_ubsan.c
index 7e7bbd0f3fd2..2062be1f2e80 100644
--- a/lib/test_ubsan.c
+++ b/lib/test_ubsan.c
@@ -79,15 +79,6 @@ static void test_ubsan_load_invalid_value(void)
 	eval2 = eval;
 }
 
-static void test_ubsan_null_ptr_deref(void)
-{
-	volatile int *ptr = NULL;
-	int val;
-
-	UBSAN_TEST(CONFIG_UBSAN_OBJECT_SIZE);
-	val = *ptr;
-}
-
 static void test_ubsan_misaligned_access(void)
 {
 	volatile char arr[5] __aligned(4) = {1, 2, 3, 4, 5};
@@ -98,29 +89,16 @@ static void test_ubsan_misaligned_access(void)
 	*ptr = val;
 }
 
-static void test_ubsan_object_size_mismatch(void)
-{
-	/* "((aligned(8)))" helps this not into be misaligned for ptr-access. */
-	volatile int val __aligned(8) = 4;
-	volatile long long *ptr, val2;
-
-	UBSAN_TEST(CONFIG_UBSAN_OBJECT_SIZE);
-	ptr = (long long *)&val;
-	val2 = *ptr;
-}
-
 static const test_ubsan_fp test_ubsan_array[] = {
 	test_ubsan_shift_out_of_bounds,
 	test_ubsan_out_of_bounds,
 	test_ubsan_load_invalid_value,
 	test_ubsan_misaligned_access,
-	test_ubsan_object_size_mismatch,
 };
 
 /* Excluded because they Oops the module. */
 static const test_ubsan_fp skip_ubsan_array[] = {
 	test_ubsan_divrem_overflow,
-	test_ubsan_null_ptr_deref,
 };
 
 static int __init test_ubsan_init(void)
diff --git a/mm/highmem.c b/mm/highmem.c
index 1f0c8a52fd80..4f942678e9da 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -627,7 +627,7 @@ void __kmap_local_sched_out(void)
 
 		/* With debug all even slots are unmapped and act as guard */
 		if (IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL) && !(i & 0x01)) {
-			WARN_ON_ONCE(!pte_none(pteval));
+			WARN_ON_ONCE(pte_val(pteval) != 0);
 			continue;
 		}
 		if (WARN_ON_ONCE(pte_none(pteval)))
@@ -664,7 +664,7 @@ void __kmap_local_sched_in(void)
 
 		/* With debug all even slots are unmapped and act as guard */
 		if (IS_ENABLED(CONFIG_DEBUG_KMAP_LOCAL) && !(i & 0x01)) {
-			WARN_ON_ONCE(!pte_none(pteval));
+			WARN_ON_ONCE(pte_val(pteval) != 0);
 			continue;
 		}
 		if (WARN_ON_ONCE(pte_none(pteval)))
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 84555b8233ef..51ea9193cecb 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -10,12 +10,15 @@
 #include <linux/atomic.h>
 #include <linux/bug.h>
 #include <linux/debugfs.h>
+#include <linux/hash.h>
 #include <linux/irq_work.h>
+#include <linux/jhash.h>
 #include <linux/kcsan-checks.h>
 #include <linux/kfence.h>
 #include <linux/kmemleak.h>
 #include <linux/list.h>
 #include <linux/lockdep.h>
+#include <linux/log2.h>
 #include <linux/memblock.h>
 #include <linux/moduleparam.h>
 #include <linux/random.h>
@@ -82,6 +85,10 @@ static const struct kernel_param_ops sample_interval_param_ops = {
 };
 module_param_cb(sample_interval, &sample_interval_param_ops, &kfence_sample_interval, 0600);
 
+/* Pool usage% threshold when currently covered allocations are skipped. */
+static unsigned long kfence_skip_covered_thresh __read_mostly = 75;
+module_param_named(skip_covered_thresh, kfence_skip_covered_thresh, ulong, 0644);
+
 /* The pool of pages used for guard pages and objects. */
 char *__kfence_pool __ro_after_init;
 EXPORT_SYMBOL(__kfence_pool); /* Export for test modules. */
@@ -106,6 +113,32 @@ DEFINE_STATIC_KEY_FALSE(kfence_allocation_key);
 /* Gates the allocation, ensuring only one succeeds in a given period. */
 atomic_t kfence_allocation_gate = ATOMIC_INIT(1);
 
+/*
+ * A Counting Bloom filter of allocation coverage: limits currently covered
+ * allocations of the same source filling up the pool.
+ *
+ * Assuming a range of 15%-85% unique allocations in the pool at any point in
+ * time, the below parameters provide a probablity of 0.02-0.33 for false
+ * positive hits respectively:
+ *
+ *	P(alloc_traces) = (1 - e^(-HNUM * (alloc_traces / SIZE)) ^ HNUM
+ */
+#define ALLOC_COVERED_HNUM	2
+#define ALLOC_COVERED_ORDER	(const_ilog2(CONFIG_KFENCE_NUM_OBJECTS) + 2)
+#define ALLOC_COVERED_SIZE	(1 << ALLOC_COVERED_ORDER)
+#define ALLOC_COVERED_HNEXT(h)	hash_32(h, ALLOC_COVERED_ORDER)
+#define ALLOC_COVERED_MASK	(ALLOC_COVERED_SIZE - 1)
+static atomic_t alloc_covered[ALLOC_COVERED_SIZE];
+
+/* Stack depth used to determine uniqueness of an allocation. */
+#define UNIQUE_ALLOC_STACK_DEPTH ((size_t)8)
+
+/*
+ * Randomness for stack hashes, making the same collisions across reboots and
+ * different machines less likely.
+ */
+static u32 stack_hash_seed __ro_after_init;
+
 /* Statistics counters for debugfs. */
 enum kfence_counter_id {
 	KFENCE_COUNTER_ALLOCATED,
@@ -113,6 +146,9 @@ enum kfence_counter_id {
 	KFENCE_COUNTER_FREES,
 	KFENCE_COUNTER_ZOMBIES,
 	KFENCE_COUNTER_BUGS,
+	KFENCE_COUNTER_SKIP_INCOMPAT,
+	KFENCE_COUNTER_SKIP_CAPACITY,
+	KFENCE_COUNTER_SKIP_COVERED,
 	KFENCE_COUNTER_COUNT,
 };
 static atomic_long_t counters[KFENCE_COUNTER_COUNT];
@@ -122,11 +158,59 @@ static const char *const counter_names[] = {
 	[KFENCE_COUNTER_FREES]		= "total frees",
 	[KFENCE_COUNTER_ZOMBIES]	= "zombie allocations",
 	[KFENCE_COUNTER_BUGS]		= "total bugs",
+	[KFENCE_COUNTER_SKIP_INCOMPAT]	= "skipped allocations (incompatible)",
+	[KFENCE_COUNTER_SKIP_CAPACITY]	= "skipped allocations (capacity)",
+	[KFENCE_COUNTER_SKIP_COVERED]	= "skipped allocations (covered)",
 };
 static_assert(ARRAY_SIZE(counter_names) == KFENCE_COUNTER_COUNT);
 
 /* === Internals ============================================================ */
 
+static inline bool should_skip_covered(void)
+{
+	unsigned long thresh = (CONFIG_KFENCE_NUM_OBJECTS * kfence_skip_covered_thresh) / 100;
+
+	return atomic_long_read(&counters[KFENCE_COUNTER_ALLOCATED]) > thresh;
+}
+
+static u32 get_alloc_stack_hash(unsigned long *stack_entries, size_t num_entries)
+{
+	num_entries = min(num_entries, UNIQUE_ALLOC_STACK_DEPTH);
+	num_entries = filter_irq_stacks(stack_entries, num_entries);
+	return jhash(stack_entries, num_entries * sizeof(stack_entries[0]), stack_hash_seed);
+}
+
+/*
+ * Adds (or subtracts) count @val for allocation stack trace hash
+ * @alloc_stack_hash from Counting Bloom filter.
+ */
+static void alloc_covered_add(u32 alloc_stack_hash, int val)
+{
+	int i;
+
+	for (i = 0; i < ALLOC_COVERED_HNUM; i++) {
+		atomic_add(val, &alloc_covered[alloc_stack_hash & ALLOC_COVERED_MASK]);
+		alloc_stack_hash = ALLOC_COVERED_HNEXT(alloc_stack_hash);
+	}
+}
+
+/*
+ * Returns true if the allocation stack trace hash @alloc_stack_hash is
+ * currently contained (non-zero count) in Counting Bloom filter.
+ */
+static bool alloc_covered_contains(u32 alloc_stack_hash)
+{
+	int i;
+
+	for (i = 0; i < ALLOC_COVERED_HNUM; i++) {
+		if (!atomic_read(&alloc_covered[alloc_stack_hash & ALLOC_COVERED_MASK]))
+			return false;
+		alloc_stack_hash = ALLOC_COVERED_HNEXT(alloc_stack_hash);
+	}
+
+	return true;
+}
+
 static bool kfence_protect(unsigned long addr)
 {
 	return !KFENCE_WARN_ON(!kfence_protect_page(ALIGN_DOWN(addr, PAGE_SIZE), true));
@@ -184,19 +268,26 @@ static inline unsigned long metadata_to_pageaddr(const struct kfence_metadata *m
  * Update the object's metadata state, including updating the alloc/free stacks
  * depending on the state transition.
  */
-static noinline void metadata_update_state(struct kfence_metadata *meta,
-					   enum kfence_object_state next)
+static noinline void
+metadata_update_state(struct kfence_metadata *meta, enum kfence_object_state next,
+		      unsigned long *stack_entries, size_t num_stack_entries)
 {
 	struct kfence_track *track =
 		next == KFENCE_OBJECT_FREED ? &meta->free_track : &meta->alloc_track;
 
 	lockdep_assert_held(&meta->lock);
 
-	/*
-	 * Skip over 1 (this) functions; noinline ensures we do not accidentally
-	 * skip over the caller by never inlining.
-	 */
-	track->num_stack_entries = stack_trace_save(track->stack_entries, KFENCE_STACK_DEPTH, 1);
+	if (stack_entries) {
+		memcpy(track->stack_entries, stack_entries,
+		       num_stack_entries * sizeof(stack_entries[0]));
+	} else {
+		/*
+		 * Skip over 1 (this) functions; noinline ensures we do not
+		 * accidentally skip over the caller by never inlining.
+		 */
+		num_stack_entries = stack_trace_save(track->stack_entries, KFENCE_STACK_DEPTH, 1);
+	}
+	track->num_stack_entries = num_stack_entries;
 	track->pid = task_pid_nr(current);
 	track->cpu = raw_smp_processor_id();
 	track->ts_nsec = local_clock(); /* Same source as printk timestamps. */
@@ -258,7 +349,9 @@ static __always_inline void for_each_canary(const struct kfence_metadata *meta,
 	}
 }
 
-static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t gfp)
+static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t gfp,
+				  unsigned long *stack_entries, size_t num_stack_entries,
+				  u32 alloc_stack_hash)
 {
 	struct kfence_metadata *meta = NULL;
 	unsigned long flags;
@@ -272,8 +365,10 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 		list_del_init(&meta->list);
 	}
 	raw_spin_unlock_irqrestore(&kfence_freelist_lock, flags);
-	if (!meta)
+	if (!meta) {
+		atomic_long_inc(&counters[KFENCE_COUNTER_SKIP_CAPACITY]);
 		return NULL;
+	}
 
 	if (unlikely(!raw_spin_trylock_irqsave(&meta->lock, flags))) {
 		/*
@@ -315,10 +410,12 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 	addr = (void *)meta->addr;
 
 	/* Update remaining metadata. */
-	metadata_update_state(meta, KFENCE_OBJECT_ALLOCATED);
+	metadata_update_state(meta, KFENCE_OBJECT_ALLOCATED, stack_entries, num_stack_entries);
 	/* Pairs with READ_ONCE() in kfence_shutdown_cache(). */
 	WRITE_ONCE(meta->cache, cache);
 	meta->size = size;
+	meta->alloc_stack_hash = alloc_stack_hash;
+
 	for_each_canary(meta, set_canary_byte);
 
 	/* Set required struct page fields. */
@@ -331,6 +428,8 @@ static void *kfence_guarded_alloc(struct kmem_cache *cache, size_t size, gfp_t g
 
 	raw_spin_unlock_irqrestore(&meta->lock, flags);
 
+	alloc_covered_add(alloc_stack_hash, 1);
+
 	/* Memory initialization. */
 
 	/*
@@ -395,10 +494,12 @@ static void kfence_guarded_free(void *addr, struct kfence_metadata *meta, bool z
 		memzero_explicit(addr, meta->size);
 
 	/* Mark the object as freed. */
-	metadata_update_state(meta, KFENCE_OBJECT_FREED);
+	metadata_update_state(meta, KFENCE_OBJECT_FREED, NULL, 0);
 
 	raw_spin_unlock_irqrestore(&meta->lock, flags);
 
+	alloc_covered_add(meta->alloc_stack_hash, -1);
+
 	/* Protect to detect use-after-frees. */
 	kfence_protect((unsigned long)addr);
 
@@ -665,6 +766,7 @@ void __init kfence_init(void)
 	if (!kfence_sample_interval)
 		return;
 
+	stack_hash_seed = (u32)random_get_entropy();
 	if (!kfence_init_pool()) {
 		pr_err("%s failed\n", __func__);
 		return;
@@ -740,12 +842,18 @@ void kfence_shutdown_cache(struct kmem_cache *s)
 
 void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 {
+	unsigned long stack_entries[KFENCE_STACK_DEPTH];
+	size_t num_stack_entries;
+	u32 alloc_stack_hash;
+
 	/*
 	 * Perform size check before switching kfence_allocation_gate, so that
 	 * we don't disable KFENCE without making an allocation.
 	 */
-	if (size > PAGE_SIZE)
+	if (size > PAGE_SIZE) {
+		atomic_long_inc(&counters[KFENCE_COUNTER_SKIP_INCOMPAT]);
 		return NULL;
+	}
 
 	/*
 	 * Skip allocations from non-default zones, including DMA. We cannot
@@ -753,8 +861,10 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 	 * properties (e.g. reside in DMAable memory).
 	 */
 	if ((flags & GFP_ZONEMASK) ||
-	    (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32)))
+	    (s->flags & (SLAB_CACHE_DMA | SLAB_CACHE_DMA32))) {
+		atomic_long_inc(&counters[KFENCE_COUNTER_SKIP_INCOMPAT]);
 		return NULL;
+	}
 
 	if (atomic_inc_return(&kfence_allocation_gate) > 1)
 		return NULL;
@@ -775,7 +885,25 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 	if (!READ_ONCE(kfence_enabled))
 		return NULL;
 
-	return kfence_guarded_alloc(s, size, flags);
+	num_stack_entries = stack_trace_save(stack_entries, KFENCE_STACK_DEPTH, 0);
+
+	/*
+	 * Do expensive check for coverage of allocation in slow-path after
+	 * allocation_gate has already become non-zero, even though it might
+	 * mean not making any allocation within a given sample interval.
+	 *
+	 * This ensures reasonable allocation coverage when the pool is almost
+	 * full, including avoiding long-lived allocations of the same source
+	 * filling up the pool (e.g. pagecache allocations).
+	 */
+	alloc_stack_hash = get_alloc_stack_hash(stack_entries, num_stack_entries);
+	if (should_skip_covered() && alloc_covered_contains(alloc_stack_hash)) {
+		atomic_long_inc(&counters[KFENCE_COUNTER_SKIP_COVERED]);
+		return NULL;
+	}
+
+	return kfence_guarded_alloc(s, size, flags, stack_entries, num_stack_entries,
+				    alloc_stack_hash);
 }
 
 size_t kfence_ksize(const void *addr)
diff --git a/mm/kfence/kfence.h b/mm/kfence/kfence.h
index c1f23c61e5f9..2a2d5de9d379 100644
--- a/mm/kfence/kfence.h
+++ b/mm/kfence/kfence.h
@@ -87,6 +87,8 @@ struct kfence_metadata {
 	/* Allocation and free stack information. */
 	struct kfence_track alloc_track;
 	struct kfence_track free_track;
+	/* For updating alloc_covered on frees. */
+	u32 alloc_stack_hash;
 };
 
 extern struct kfence_metadata kfence_metadata[CONFIG_KFENCE_NUM_OBJECTS];
diff --git a/mm/memory.c b/mm/memory.c
index c267a9957537..bdf7185f1bf2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1301,6 +1301,17 @@ copy_page_range(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 	return ret;
 }
 
+/* Whether we should zap all COWed (private) pages too */
+static inline bool should_zap_cows(struct zap_details *details)
+{
+	/* By default, zap all pages */
+	if (!details)
+		return true;
+
+	/* Or, we zap COWed pages only if the caller wants to */
+	return !details->check_mapping;
+}
+
 static unsigned long zap_pte_range(struct mmu_gather *tlb,
 				struct vm_area_struct *vma, pmd_t *pmd,
 				unsigned long addr, unsigned long end,
@@ -1396,16 +1407,18 @@ static unsigned long zap_pte_range(struct mmu_gather *tlb,
 			continue;
 		}
 
-		/* If details->check_mapping, we leave swap entries. */
-		if (unlikely(details))
-			continue;
-
-		if (!non_swap_entry(entry))
+		if (!non_swap_entry(entry)) {
+			/* Genuine swap entry, hence a private anon page */
+			if (!should_zap_cows(details))
+				continue;
 			rss[MM_SWAPENTS]--;
-		else if (is_migration_entry(entry)) {
+		} else if (is_migration_entry(entry)) {
 			struct page *page;
 
 			page = pfn_swap_entry_to_page(entry);
+			if (details && details->check_mapping &&
+			    details->check_mapping != page_rmapping(page))
+				continue;
 			rss[mm_counter(page)]--;
 		}
 		if (unlikely(!free_swap_and_cache(entry)))
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index dd4eddf1d35f..e75872035c76 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2561,6 +2561,7 @@ static int shared_policy_replace(struct shared_policy *sp, unsigned long start,
 	mpol_new = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!mpol_new)
 		goto err_out;
+	atomic_set(&mpol_new->refcnt, 1);
 	goto restart;
 }
 
diff --git a/mm/mremap.c b/mm/mremap.c
index badfe17ade1f..3a3cf4cc2c63 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -486,6 +486,9 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 	pmd_t *old_pmd, *new_pmd;
 	pud_t *old_pud, *new_pud;
 
+	if (!len)
+		return 0;
+
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
diff --git a/mm/rmap.c b/mm/rmap.c
index 6aebd1747251..3e340ee380cb 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1570,7 +1570,30 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 
 			/* MADV_FREE page check */
 			if (!PageSwapBacked(page)) {
-				if (!PageDirty(page)) {
+				int ref_count, map_count;
+
+				/*
+				 * Synchronize with gup_pte_range():
+				 * - clear PTE; barrier; read refcount
+				 * - inc refcount; barrier; read PTE
+				 */
+				smp_mb();
+
+				ref_count = page_ref_count(page);
+				map_count = page_mapcount(page);
+
+				/*
+				 * Order reads for page refcount and dirty flag
+				 * (see comments in __remove_mapping()).
+				 */
+				smp_rmb();
+
+				/*
+				 * The only page refs must be one from isolation
+				 * plus the rmap(s) (dropped by discard:).
+				 */
+				if (ref_count == 1 + map_count &&
+				    !PageDirty(page)) {
 					/* Invalidate as we cleared the pte */
 					mmu_notifier_invalidate_range(mm,
 						address, address + PAGE_SIZE);
diff --git a/net/batman-adv/multicast.c b/net/batman-adv/multicast.c
index 6e3419beca09..2853634a3979 100644
--- a/net/batman-adv/multicast.c
+++ b/net/batman-adv/multicast.c
@@ -134,7 +134,7 @@ static u8 batadv_mcast_mla_rtr_flags_softif_get_ipv6(struct net_device *dev)
 {
 	struct inet6_dev *in6_dev = __in6_dev_get(dev);
 
-	if (in6_dev && in6_dev->cnf.mc_forwarding)
+	if (in6_dev && atomic_read(&in6_dev->cnf.mc_forwarding))
 		return BATADV_NO_FLAGS;
 	else
 		return BATADV_MCAST_WANT_NO_RTR6;
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 868a22df3285..e984a8b4b914 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5153,8 +5153,9 @@ static void hci_disconn_phylink_complete_evt(struct hci_dev *hdev,
 	hci_dev_lock(hdev);
 
 	hcon = hci_conn_hash_lookup_handle(hdev, ev->phy_handle);
-	if (hcon) {
+	if (hcon && hcon->type == AMP_LINK) {
 		hcon->state = BT_CLOSED;
+		hci_disconn_cfm(hcon, ev->reason);
 		hci_conn_del(hcon);
 	}
 
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 77ba68209dbd..c57a45df7a26 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1436,6 +1436,7 @@ static void l2cap_ecred_connect(struct l2cap_chan *chan)
 
 	l2cap_ecred_init(chan, 0);
 
+	memset(&data, 0, sizeof(data));
 	data.pdu.req.psm     = chan->psm;
 	data.pdu.req.mtu     = cpu_to_le16(chan->imtu);
 	data.pdu.req.mps     = cpu_to_le16(chan->mps);
diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index b5f4ef35357c..655ee0e2de86 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -954,7 +954,7 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
 	if (!range_is_zero(user_ctx, offsetofend(typeof(*user_ctx), local_port), sizeof(*user_ctx)))
 		goto out;
 
-	if (user_ctx->local_port > U16_MAX || user_ctx->remote_port > U16_MAX) {
+	if (user_ctx->local_port > U16_MAX) {
 		ret = -ERANGE;
 		goto out;
 	}
@@ -962,7 +962,7 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
 	ctx.family = (u16)user_ctx->family;
 	ctx.protocol = (u16)user_ctx->protocol;
 	ctx.dport = (u16)user_ctx->local_port;
-	ctx.sport = (__force __be16)user_ctx->remote_port;
+	ctx.sport = user_ctx->remote_port;
 
 	switch (ctx.family) {
 	case AF_INET:
diff --git a/net/can/isotp.c b/net/can/isotp.c
index a95d171b3a64..5bce7c66c121 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -141,6 +141,7 @@ struct isotp_sock {
 	struct can_isotp_options opt;
 	struct can_isotp_fc_options rxfc, txfc;
 	struct can_isotp_ll_options ll;
+	u32 frame_txtime;
 	u32 force_tx_stmin;
 	u32 force_rx_stmin;
 	struct tpcon rx, tx;
@@ -360,7 +361,7 @@ static int isotp_rcv_fc(struct isotp_sock *so, struct canfd_frame *cf, int ae)
 
 		so->tx_gap = ktime_set(0, 0);
 		/* add transmission time for CAN frame N_As */
-		so->tx_gap = ktime_add_ns(so->tx_gap, so->opt.frame_txtime);
+		so->tx_gap = ktime_add_ns(so->tx_gap, so->frame_txtime);
 		/* add waiting time for consecutive frames N_Cs */
 		if (so->opt.flags & CAN_ISOTP_FORCE_TXSTMIN)
 			so->tx_gap = ktime_add_ns(so->tx_gap,
@@ -1247,6 +1248,14 @@ static int isotp_setsockopt_locked(struct socket *sock, int level, int optname,
 		/* no separate rx_ext_address is given => use ext_address */
 		if (!(so->opt.flags & CAN_ISOTP_RX_EXT_ADDR))
 			so->opt.rx_ext_address = so->opt.ext_address;
+
+		/* check for frame_txtime changes (0 => no changes) */
+		if (so->opt.frame_txtime) {
+			if (so->opt.frame_txtime == CAN_ISOTP_FRAME_TXTIME_ZERO)
+				so->frame_txtime = 0;
+			else
+				so->frame_txtime = so->opt.frame_txtime;
+		}
 		break;
 
 	case CAN_ISOTP_RECV_FC:
@@ -1448,6 +1457,7 @@ static int isotp_init(struct sock *sk)
 	so->opt.rxpad_content = CAN_ISOTP_DEFAULT_PAD_CONTENT;
 	so->opt.txpad_content = CAN_ISOTP_DEFAULT_PAD_CONTENT;
 	so->opt.frame_txtime = CAN_ISOTP_DEFAULT_FRAME_TXTIME;
+	so->frame_txtime = CAN_ISOTP_DEFAULT_FRAME_TXTIME;
 	so->rxfc.bs = CAN_ISOTP_DEFAULT_RECV_BS;
 	so->rxfc.stmin = CAN_ISOTP_DEFAULT_RECV_STMIN;
 	so->rxfc.wftmax = CAN_ISOTP_DEFAULT_RECV_WFTMAX;
diff --git a/net/core/dev.c b/net/core/dev.c
index 33dc2a3ff7d7..804aba2228c2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -11378,8 +11378,7 @@ static int __net_init netdev_init(struct net *net)
 	BUILD_BUG_ON(GRO_HASH_BUCKETS >
 		     8 * sizeof_field(struct napi_struct, gro_bitmask));
 
-	if (net != &init_net)
-		INIT_LIST_HEAD(&net->dev_base_head);
+	INIT_LIST_HEAD(&net->dev_base_head);
 
 	net->dev_name_head = netdev_create_hash();
 	if (net->dev_name_head == NULL)
diff --git a/net/core/filter.c b/net/core/filter.c
index 76e406965b6f..cdd7e92db303 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6719,24 +6719,33 @@ BPF_CALL_5(bpf_tcp_check_syncookie, struct sock *, sk, void *, iph, u32, iph_len
 	if (!th->ack || th->rst || th->syn)
 		return -ENOENT;
 
+	if (unlikely(iph_len < sizeof(struct iphdr)))
+		return -EINVAL;
+
 	if (tcp_synq_no_recent_overflow(sk))
 		return -ENOENT;
 
 	cookie = ntohl(th->ack_seq) - 1;
 
-	switch (sk->sk_family) {
-	case AF_INET:
-		if (unlikely(iph_len < sizeof(struct iphdr)))
+	/* Both struct iphdr and struct ipv6hdr have the version field at the
+	 * same offset so we can cast to the shorter header (struct iphdr).
+	 */
+	switch (((struct iphdr *)iph)->version) {
+	case 4:
+		if (sk->sk_family == AF_INET6 && ipv6_only_sock(sk))
 			return -EINVAL;
 
 		ret = __cookie_v4_check((struct iphdr *)iph, th, cookie);
 		break;
 
 #if IS_BUILTIN(CONFIG_IPV6)
-	case AF_INET6:
+	case 6:
 		if (unlikely(iph_len < sizeof(struct ipv6hdr)))
 			return -EINVAL;
 
+		if (sk->sk_family != AF_INET6)
+			return -EINVAL;
+
 		ret = __cookie_v6_check((struct ipv6hdr *)iph, th, cookie);
 		break;
 #endif /* CONFIG_IPV6 */
@@ -7966,6 +7975,7 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 			      struct bpf_insn_access_aux *info)
 {
 	const int size_default = sizeof(__u32);
+	int field_size;
 
 	if (off < 0 || off >= sizeof(struct bpf_sock))
 		return false;
@@ -7977,7 +7987,6 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 	case offsetof(struct bpf_sock, family):
 	case offsetof(struct bpf_sock, type):
 	case offsetof(struct bpf_sock, protocol):
-	case offsetof(struct bpf_sock, dst_port):
 	case offsetof(struct bpf_sock, src_port):
 	case offsetof(struct bpf_sock, rx_queue_mapping):
 	case bpf_ctx_range(struct bpf_sock, src_ip4):
@@ -7986,6 +7995,14 @@ bool bpf_sock_is_valid_access(int off, int size, enum bpf_access_type type,
 	case bpf_ctx_range_till(struct bpf_sock, dst_ip6[0], dst_ip6[3]):
 		bpf_ctx_record_field_size(info, size_default);
 		return bpf_ctx_narrow_access_ok(off, size, size_default);
+	case bpf_ctx_range(struct bpf_sock, dst_port):
+		field_size = size == size_default ?
+			size_default : sizeof_field(struct bpf_sock, dst_port);
+		bpf_ctx_record_field_size(info, field_size);
+		return bpf_ctx_narrow_access_ok(off, size, field_size);
+	case offsetofend(struct bpf_sock, dst_port) ...
+	     offsetof(struct bpf_sock, dst_ip4) - 1:
+		return false;
 	}
 
 	return size == size_default;
@@ -10523,7 +10540,8 @@ static bool sk_lookup_is_valid_access(int off, int size,
 	case bpf_ctx_range(struct bpf_sk_lookup, local_ip4):
 	case bpf_ctx_range_till(struct bpf_sk_lookup, remote_ip6[0], remote_ip6[3]):
 	case bpf_ctx_range_till(struct bpf_sk_lookup, local_ip6[0], local_ip6[3]):
-	case bpf_ctx_range(struct bpf_sk_lookup, remote_port):
+	case offsetof(struct bpf_sk_lookup, remote_port) ...
+	     offsetof(struct bpf_sk_lookup, local_ip4) - 1:
 	case bpf_ctx_range(struct bpf_sk_lookup, local_port):
 		bpf_ctx_record_field_size(info, sizeof(__u32));
 		return bpf_ctx_narrow_access_ok(off, size, sizeof(__u32));
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 9702d2b0d920..9745cb6fdf51 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -44,13 +44,7 @@ EXPORT_SYMBOL_GPL(net_rwsem);
 static struct key_tag init_net_key_domain = { .usage = REFCOUNT_INIT(1) };
 #endif
 
-struct net init_net = {
-	.ns.count	= REFCOUNT_INIT(1),
-	.dev_base_head	= LIST_HEAD_INIT(init_net.dev_base_head),
-#ifdef CONFIG_KEYS
-	.key_domain	= &init_net_key_domain,
-#endif
-};
+struct net init_net;
 EXPORT_SYMBOL(init_net);
 
 static bool init_net_initialized;
@@ -1081,7 +1075,7 @@ static void rtnl_net_notifyid(struct net *net, int cmd, int id, u32 portid,
 	rtnl_set_sk_err(net, RTNLGRP_NSID, err);
 }
 
-static int __init net_ns_init(void)
+void __init net_ns_init(void)
 {
 	struct net_generic *ng;
 
@@ -1102,6 +1096,9 @@ static int __init net_ns_init(void)
 
 	rcu_assign_pointer(init_net.gen, ng);
 
+#ifdef CONFIG_KEYS
+	init_net.key_domain = &init_net_key_domain;
+#endif
 	down_write(&pernet_ops_rwsem);
 	if (setup_net(&init_net, &init_user_ns))
 		panic("Could not setup the initial network namespace");
@@ -1116,12 +1113,8 @@ static int __init net_ns_init(void)
 		      RTNL_FLAG_DOIT_UNLOCKED);
 	rtnl_register(PF_UNSPEC, RTM_GETNSID, rtnl_net_getid, rtnl_net_dumpid,
 		      RTNL_FLAG_DOIT_UNLOCKED);
-
-	return 0;
 }
 
-pure_initcall(net_ns_init);
-
 static void free_exit_list(struct pernet_operations *ops, struct list_head *net_exit_list)
 {
 	ops_pre_exit_list(ops, net_exit_list);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 91d7a5a5a08d..9c0e8ccf9bc5 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3631,13 +3631,24 @@ static int rtnl_alt_ifname(int cmd, struct net_device *dev, struct nlattr *attr,
 			   bool *changed, struct netlink_ext_ack *extack)
 {
 	char *alt_ifname;
+	size_t size;
 	int err;
 
 	err = nla_validate(attr, attr->nla_len, IFLA_MAX, ifla_policy, extack);
 	if (err)
 		return err;
 
-	alt_ifname = nla_strdup(attr, GFP_KERNEL);
+	if (cmd == RTM_NEWLINKPROP) {
+		size = rtnl_prop_list_size(dev);
+		size += nla_total_size(ALTIFNAMSIZ);
+		if (size >= U16_MAX) {
+			NL_SET_ERR_MSG(extack,
+				       "effective property list too long");
+			return -EINVAL;
+		}
+	}
+
+	alt_ifname = nla_strdup(attr, GFP_KERNEL_ACCOUNT);
 	if (!alt_ifname)
 		return -ENOMEM;
 
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 5956c84cb274..e4badc189e37 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5390,11 +5390,18 @@ bool skb_try_coalesce(struct sk_buff *to, struct sk_buff *from,
 	if (skb_cloned(to))
 		return false;
 
-	/* The page pool signature of struct page will eventually figure out
-	 * which pages can be recycled or not but for now let's prohibit slab
-	 * allocated and page_pool allocated SKBs from being coalesced.
+	/* In general, avoid mixing slab allocated and page_pool allocated
+	 * pages within the same SKB. However when @to is not pp_recycle and
+	 * @from is cloned, we can transition frag pages from page_pool to
+	 * reference counted.
+	 *
+	 * On the other hand, don't allow coalescing two pp_recycle SKBs if
+	 * @from is cloned, in case the SKB is using page_pool fragment
+	 * references (PP_FLAG_PAGE_FRAG). Since we only take full page
+	 * references for cloned SKBs at the moment that would result in
+	 * inconsistent reference counts.
 	 */
-	if (to->pp_recycle != from->pp_recycle)
+	if (to->pp_recycle != (from->pp_recycle && !skb_cloned(from)))
 		return false;
 
 	if (len <= skb_tailroom(to)) {
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 922dd73e5740..83a47998c4b1 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1116,13 +1116,18 @@ static int arp_req_get(struct arpreq *r, struct net_device *dev)
 	return err;
 }
 
-static int arp_invalidate(struct net_device *dev, __be32 ip)
+int arp_invalidate(struct net_device *dev, __be32 ip, bool force)
 {
 	struct neighbour *neigh = neigh_lookup(&arp_tbl, &ip, dev);
 	int err = -ENXIO;
 	struct neigh_table *tbl = &arp_tbl;
 
 	if (neigh) {
+		if ((neigh->nud_state & NUD_VALID) && !force) {
+			neigh_release(neigh);
+			return 0;
+		}
+
 		if (neigh->nud_state & ~NUD_NOARP)
 			err = neigh_update(neigh, NULL, NUD_FAILED,
 					   NEIGH_UPDATE_F_OVERRIDE|
@@ -1169,7 +1174,7 @@ static int arp_req_delete(struct net *net, struct arpreq *r,
 		if (!dev)
 			return -EINVAL;
 	}
-	return arp_invalidate(dev, ip);
+	return arp_invalidate(dev, ip, true);
 }
 
 /*
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index 4d61ddd8a0ec..1eb7795edb9d 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1112,9 +1112,11 @@ void fib_add_ifaddr(struct in_ifaddr *ifa)
 		return;
 
 	/* Add broadcast address, if it is explicitly assigned. */
-	if (ifa->ifa_broadcast && ifa->ifa_broadcast != htonl(0xFFFFFFFF))
+	if (ifa->ifa_broadcast && ifa->ifa_broadcast != htonl(0xFFFFFFFF)) {
 		fib_magic(RTM_NEWROUTE, RTN_BROADCAST, ifa->ifa_broadcast, 32,
 			  prim, 0);
+		arp_invalidate(dev, ifa->ifa_broadcast, false);
+	}
 
 	if (!ipv4_is_zeronet(prefix) && !(ifa->ifa_flags & IFA_F_SECONDARY) &&
 	    (prefix != addr || ifa->ifa_prefixlen < 32)) {
@@ -1128,6 +1130,7 @@ void fib_add_ifaddr(struct in_ifaddr *ifa)
 		if (ifa->ifa_prefixlen < 31) {
 			fib_magic(RTM_NEWROUTE, RTN_BROADCAST, prefix | ~mask,
 				  32, prim, 0);
+			arp_invalidate(dev, prefix | ~mask, false);
 		}
 	}
 }
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index d244c57b7303..b5563f5ff176 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -887,8 +887,13 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 	}
 
 	if (cfg->fc_oif || cfg->fc_gw_family) {
-		struct fib_nh *nh = fib_info_nh(fi, 0);
+		struct fib_nh *nh;
+
+		/* cannot match on nexthop object attributes */
+		if (fi->nh)
+			return 1;
 
+		nh = fib_info_nh(fi, 0);
 		if (cfg->fc_encap) {
 			if (fib_encap_match(net, cfg->fc_encap_type,
 					    cfg->fc_encap, nh, cfg, extack))
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 75737267746f..7bd1e10086f0 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -637,7 +637,9 @@ int __inet_hash(struct sock *sk, struct sock *osk)
 	int err = 0;
 
 	if (sk->sk_state != TCP_LISTEN) {
+		local_bh_disable();
 		inet_ehash_nolisten(sk, osk, NULL);
+		local_bh_enable();
 		return 0;
 	}
 	WARN_ON(!sk_unhashed(sk));
@@ -669,45 +671,54 @@ int inet_hash(struct sock *sk)
 {
 	int err = 0;
 
-	if (sk->sk_state != TCP_CLOSE) {
-		local_bh_disable();
+	if (sk->sk_state != TCP_CLOSE)
 		err = __inet_hash(sk, NULL);
-		local_bh_enable();
-	}
 
 	return err;
 }
 EXPORT_SYMBOL_GPL(inet_hash);
 
-void inet_unhash(struct sock *sk)
+static void __inet_unhash(struct sock *sk, struct inet_listen_hashbucket *ilb)
 {
-	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
-	struct inet_listen_hashbucket *ilb = NULL;
-	spinlock_t *lock;
-
 	if (sk_unhashed(sk))
 		return;
 
-	if (sk->sk_state == TCP_LISTEN) {
-		ilb = &hashinfo->listening_hash[inet_sk_listen_hashfn(sk)];
-		lock = &ilb->lock;
-	} else {
-		lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
-	}
-	spin_lock_bh(lock);
-	if (sk_unhashed(sk))
-		goto unlock;
-
 	if (rcu_access_pointer(sk->sk_reuseport_cb))
 		reuseport_stop_listen_sock(sk);
 	if (ilb) {
+		struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
+
 		inet_unhash2(hashinfo, sk);
 		ilb->count--;
 	}
 	__sk_nulls_del_node_init_rcu(sk);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, -1);
-unlock:
-	spin_unlock_bh(lock);
+}
+
+void inet_unhash(struct sock *sk)
+{
+	struct inet_hashinfo *hashinfo = sk->sk_prot->h.hashinfo;
+
+	if (sk_unhashed(sk))
+		return;
+
+	if (sk->sk_state == TCP_LISTEN) {
+		struct inet_listen_hashbucket *ilb;
+
+		ilb = &hashinfo->listening_hash[inet_sk_listen_hashfn(sk)];
+		/* Don't disable bottom halves while acquiring the lock to
+		 * avoid circular locking dependency on PREEMPT_RT.
+		 */
+		spin_lock(&ilb->lock);
+		__inet_unhash(sk, ilb);
+		spin_unlock(&ilb->lock);
+	} else {
+		spinlock_t *lock = inet_ehash_lockp(hashinfo, sk->sk_hash);
+
+		spin_lock_bh(lock);
+		__inet_unhash(sk, NULL);
+		spin_unlock_bh(lock);
+	}
 }
 EXPORT_SYMBOL_GPL(inet_unhash);
 
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 1fe27807e471..3a8838b79bb6 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -552,7 +552,7 @@ static int inet6_netconf_fill_devconf(struct sk_buff *skb, int ifindex,
 #ifdef CONFIG_IPV6_MROUTE
 	if ((all || type == NETCONFA_MC_FORWARDING) &&
 	    nla_put_s32(skb, NETCONFA_MC_FORWARDING,
-			devconf->mc_forwarding) < 0)
+			atomic_read(&devconf->mc_forwarding)) < 0)
 		goto nla_put_failure;
 #endif
 	if ((all || type == NETCONFA_PROXY_NEIGH) &&
@@ -5537,7 +5537,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
 	array[DEVCONF_USE_OPTIMISTIC] = cnf->use_optimistic;
 #endif
 #ifdef CONFIG_IPV6_MROUTE
-	array[DEVCONF_MC_FORWARDING] = cnf->mc_forwarding;
+	array[DEVCONF_MC_FORWARDING] = atomic_read(&cnf->mc_forwarding);
 #endif
 	array[DEVCONF_DISABLE_IPV6] = cnf->disable_ipv6;
 	array[DEVCONF_ACCEPT_DAD] = cnf->accept_dad;
diff --git a/net/ipv6/inet6_hashtables.c b/net/ipv6/inet6_hashtables.c
index 67c9114835c8..0a2e7f228391 100644
--- a/net/ipv6/inet6_hashtables.c
+++ b/net/ipv6/inet6_hashtables.c
@@ -333,11 +333,8 @@ int inet6_hash(struct sock *sk)
 {
 	int err = 0;
 
-	if (sk->sk_state != TCP_CLOSE) {
-		local_bh_disable();
+	if (sk->sk_state != TCP_CLOSE)
 		err = __inet_hash(sk, NULL);
-		local_bh_enable();
-	}
 
 	return err;
 }
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 80256717868e..d4b1e2c5aa76 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -508,7 +508,7 @@ int ip6_mc_input(struct sk_buff *skb)
 	/*
 	 *      IPv6 multicast router mode is now supported ;)
 	 */
-	if (dev_net(skb->dev)->ipv6.devconf_all->mc_forwarding &&
+	if (atomic_read(&dev_net(skb->dev)->ipv6.devconf_all->mc_forwarding) &&
 	    !(ipv6_addr_type(&hdr->daddr) &
 	      (IPV6_ADDR_LOOPBACK|IPV6_ADDR_LINKLOCAL)) &&
 	    likely(!(IP6CB(skb)->flags & IP6SKB_FORWARDED))) {
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index 6a4065d81aa9..91f1c5f56d5f 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -739,7 +739,7 @@ static int mif6_delete(struct mr_table *mrt, int vifi, int notify,
 
 	in6_dev = __in6_dev_get(dev);
 	if (in6_dev) {
-		in6_dev->cnf.mc_forwarding--;
+		atomic_dec(&in6_dev->cnf.mc_forwarding);
 		inet6_netconf_notify_devconf(dev_net(dev), RTM_NEWNETCONF,
 					     NETCONFA_MC_FORWARDING,
 					     dev->ifindex, &in6_dev->cnf);
@@ -907,7 +907,7 @@ static int mif6_add(struct net *net, struct mr_table *mrt,
 
 	in6_dev = __in6_dev_get(dev);
 	if (in6_dev) {
-		in6_dev->cnf.mc_forwarding++;
+		atomic_inc(&in6_dev->cnf.mc_forwarding);
 		inet6_netconf_notify_devconf(dev_net(dev), RTM_NEWNETCONF,
 					     NETCONFA_MC_FORWARDING,
 					     dev->ifindex, &in6_dev->cnf);
@@ -1557,7 +1557,7 @@ static int ip6mr_sk_init(struct mr_table *mrt, struct sock *sk)
 	} else {
 		rcu_assign_pointer(mrt->mroute_sk, sk);
 		sock_set_flag(sk, SOCK_RCU_FREE);
-		net->ipv6.devconf_all->mc_forwarding++;
+		atomic_inc(&net->ipv6.devconf_all->mc_forwarding);
 	}
 	write_unlock_bh(&mrt_lock);
 
@@ -1590,7 +1590,7 @@ int ip6mr_sk_done(struct sock *sk)
 			 * so the RCU grace period before sk freeing
 			 * is guaranteed by sk_destruct()
 			 */
-			net->ipv6.devconf_all->mc_forwarding--;
+			atomic_dec(&net->ipv6.devconf_all->mc_forwarding);
 			write_unlock_bh(&mrt_lock);
 			inet6_netconf_notify_devconf(net, RTM_NEWNETCONF,
 						     NETCONFA_MC_FORWARDING,
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e0766bdf20e7..6b269595efaa 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4509,7 +4509,7 @@ static int ip6_pkt_drop(struct sk_buff *skb, u8 code, int ipstats_mib_noroutes)
 	struct inet6_dev *idev;
 	int type;
 
-	if (netif_is_l3_master(skb->dev) &&
+	if (netif_is_l3_master(skb->dev) ||
 	    dst->dev == net->loopback_dev)
 		idev = __in6_dev_get_safely(dev_get_by_index_rcu(net, IP6CB(skb)->iif));
 	else
diff --git a/net/mctp/route.c b/net/mctp/route.c
index fb1bf4ec8529..bbb13dbc9227 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -396,7 +396,7 @@ static int mctp_route_output(struct mctp_route *route, struct sk_buff *skb)
 
 	rc = dev_hard_header(skb, skb->dev, ntohs(skb->protocol),
 			     daddr, skb->dev->dev_addr, skb->len);
-	if (rc) {
+	if (rc < 0) {
 		kfree_skb(skb);
 		return -EHOSTUNREACH;
 	}
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 917e708a4561..3a98a1316307 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -66,6 +66,8 @@ EXPORT_SYMBOL_GPL(nf_conntrack_hash);
 struct conntrack_gc_work {
 	struct delayed_work	dwork;
 	u32			next_bucket;
+	u32			avg_timeout;
+	u32			start_time;
 	bool			exiting;
 	bool			early_drop;
 };
@@ -77,8 +79,19 @@ static __read_mostly bool nf_conntrack_locks_all;
 /* serialize hash resizes and nf_ct_iterate_cleanup */
 static DEFINE_MUTEX(nf_conntrack_mutex);
 
-#define GC_SCAN_INTERVAL	(120u * HZ)
+#define GC_SCAN_INTERVAL_MAX	(60ul * HZ)
+#define GC_SCAN_INTERVAL_MIN	(1ul * HZ)
+
+/* clamp timeouts to this value (TCP unacked) */
+#define GC_SCAN_INTERVAL_CLAMP	(300ul * HZ)
+
+/* large initial bias so that we don't scan often just because we have
+ * three entries with a 1s timeout.
+ */
+#define GC_SCAN_INTERVAL_INIT	INT_MAX
+
 #define GC_SCAN_MAX_DURATION	msecs_to_jiffies(10)
+#define GC_SCAN_EXPIRED_MAX	(64000u / HZ)
 
 #define MIN_CHAINLEN	8u
 #define MAX_CHAINLEN	(32u - MIN_CHAINLEN)
@@ -1420,16 +1433,28 @@ static bool gc_worker_can_early_drop(const struct nf_conn *ct)
 
 static void gc_worker(struct work_struct *work)
 {
-	unsigned long end_time = jiffies + GC_SCAN_MAX_DURATION;
 	unsigned int i, hashsz, nf_conntrack_max95 = 0;
-	unsigned long next_run = GC_SCAN_INTERVAL;
+	u32 end_time, start_time = nfct_time_stamp;
 	struct conntrack_gc_work *gc_work;
+	unsigned int expired_count = 0;
+	unsigned long next_run;
+	s32 delta_time;
+
 	gc_work = container_of(work, struct conntrack_gc_work, dwork.work);
 
 	i = gc_work->next_bucket;
 	if (gc_work->early_drop)
 		nf_conntrack_max95 = nf_conntrack_max / 100u * 95u;
 
+	if (i == 0) {
+		gc_work->avg_timeout = GC_SCAN_INTERVAL_INIT;
+		gc_work->start_time = start_time;
+	}
+
+	next_run = gc_work->avg_timeout;
+
+	end_time = start_time + GC_SCAN_MAX_DURATION;
+
 	do {
 		struct nf_conntrack_tuple_hash *h;
 		struct hlist_nulls_head *ct_hash;
@@ -1446,6 +1471,7 @@ static void gc_worker(struct work_struct *work)
 
 		hlist_nulls_for_each_entry_rcu(h, n, &ct_hash[i], hnnode) {
 			struct nf_conntrack_net *cnet;
+			unsigned long expires;
 			struct net *net;
 
 			tmp = nf_ct_tuplehash_to_ctrack(h);
@@ -1455,11 +1481,29 @@ static void gc_worker(struct work_struct *work)
 				continue;
 			}
 
+			if (expired_count > GC_SCAN_EXPIRED_MAX) {
+				rcu_read_unlock();
+
+				gc_work->next_bucket = i;
+				gc_work->avg_timeout = next_run;
+
+				delta_time = nfct_time_stamp - gc_work->start_time;
+
+				/* re-sched immediately if total cycle time is exceeded */
+				next_run = delta_time < (s32)GC_SCAN_INTERVAL_MAX;
+				goto early_exit;
+			}
+
 			if (nf_ct_is_expired(tmp)) {
 				nf_ct_gc_expired(tmp);
+				expired_count++;
 				continue;
 			}
 
+			expires = clamp(nf_ct_expires(tmp), GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_CLAMP);
+			next_run += expires;
+			next_run /= 2u;
+
 			if (nf_conntrack_max95 == 0 || gc_worker_skip_ct(tmp))
 				continue;
 
@@ -1477,8 +1521,10 @@ static void gc_worker(struct work_struct *work)
 				continue;
 			}
 
-			if (gc_worker_can_early_drop(tmp))
+			if (gc_worker_can_early_drop(tmp)) {
 				nf_ct_kill(tmp);
+				expired_count++;
+			}
 
 			nf_ct_put(tmp);
 		}
@@ -1491,33 +1537,38 @@ static void gc_worker(struct work_struct *work)
 		cond_resched();
 		i++;
 
-		if (time_after(jiffies, end_time) && i < hashsz) {
+		delta_time = nfct_time_stamp - end_time;
+		if (delta_time > 0 && i < hashsz) {
+			gc_work->avg_timeout = next_run;
 			gc_work->next_bucket = i;
 			next_run = 0;
-			break;
+			goto early_exit;
 		}
 	} while (i < hashsz);
 
+	gc_work->next_bucket = 0;
+
+	next_run = clamp(next_run, GC_SCAN_INTERVAL_MIN, GC_SCAN_INTERVAL_MAX);
+
+	delta_time = max_t(s32, nfct_time_stamp - gc_work->start_time, 1);
+	if (next_run > (unsigned long)delta_time)
+		next_run -= delta_time;
+	else
+		next_run = 1;
+
+early_exit:
 	if (gc_work->exiting)
 		return;
 
-	/*
-	 * Eviction will normally happen from the packet path, and not
-	 * from this gc worker.
-	 *
-	 * This worker is only here to reap expired entries when system went
-	 * idle after a busy period.
-	 */
-	if (next_run) {
+	if (next_run)
 		gc_work->early_drop = false;
-		gc_work->next_bucket = 0;
-	}
+
 	queue_delayed_work(system_power_efficient_wq, &gc_work->dwork, next_run);
 }
 
 static void conntrack_gc_work_init(struct conntrack_gc_work *gc_work)
 {
-	INIT_DEFERRABLE_WORK(&gc_work->dwork, gc_worker);
+	INIT_DELAYED_WORK(&gc_work->dwork, gc_worker);
 	gc_work->exiting = false;
 }
 
diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
index beb0e573266d..54c083003947 100644
--- a/net/netlabel/netlabel_kapi.c
+++ b/net/netlabel/netlabel_kapi.c
@@ -885,6 +885,8 @@ int netlbl_bitmap_walk(const unsigned char *bitmap, u32 bitmap_len,
 	unsigned char bitmask;
 	unsigned char byte;
 
+	if (offset >= bitmap_len)
+		return -1;
 	byte_offset = offset / 8;
 	byte = bitmap[byte_offset];
 	bit_spot = offset;
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 780d9e2246f3..8955f31fa47e 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -1051,7 +1051,7 @@ static int clone(struct datapath *dp, struct sk_buff *skb,
 	int rem = nla_len(attr);
 	bool dont_clone_flow_key;
 
-	/* The first action is always 'OVS_CLONE_ATTR_ARG'. */
+	/* The first action is always 'OVS_CLONE_ATTR_EXEC'. */
 	clone_arg = nla_data(attr);
 	dont_clone_flow_key = nla_get_u32(clone_arg);
 	actions = nla_next(clone_arg, &rem);
diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index 0d677c9c2c80..c591b923016a 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2288,6 +2288,62 @@ static struct sw_flow_actions *nla_alloc_flow_actions(int size)
 	return sfa;
 }
 
+static void ovs_nla_free_nested_actions(const struct nlattr *actions, int len);
+
+static void ovs_nla_free_check_pkt_len_action(const struct nlattr *action)
+{
+	const struct nlattr *a;
+	int rem;
+
+	nla_for_each_nested(a, action, rem) {
+		switch (nla_type(a)) {
+		case OVS_CHECK_PKT_LEN_ATTR_ACTIONS_IF_LESS_EQUAL:
+		case OVS_CHECK_PKT_LEN_ATTR_ACTIONS_IF_GREATER:
+			ovs_nla_free_nested_actions(nla_data(a), nla_len(a));
+			break;
+		}
+	}
+}
+
+static void ovs_nla_free_clone_action(const struct nlattr *action)
+{
+	const struct nlattr *a = nla_data(action);
+	int rem = nla_len(action);
+
+	switch (nla_type(a)) {
+	case OVS_CLONE_ATTR_EXEC:
+		/* The real list of actions follows this attribute. */
+		a = nla_next(a, &rem);
+		ovs_nla_free_nested_actions(a, rem);
+		break;
+	}
+}
+
+static void ovs_nla_free_dec_ttl_action(const struct nlattr *action)
+{
+	const struct nlattr *a = nla_data(action);
+
+	switch (nla_type(a)) {
+	case OVS_DEC_TTL_ATTR_ACTION:
+		ovs_nla_free_nested_actions(nla_data(a), nla_len(a));
+		break;
+	}
+}
+
+static void ovs_nla_free_sample_action(const struct nlattr *action)
+{
+	const struct nlattr *a = nla_data(action);
+	int rem = nla_len(action);
+
+	switch (nla_type(a)) {
+	case OVS_SAMPLE_ATTR_ARG:
+		/* The real list of actions follows this attribute. */
+		a = nla_next(a, &rem);
+		ovs_nla_free_nested_actions(a, rem);
+		break;
+	}
+}
+
 static void ovs_nla_free_set_action(const struct nlattr *a)
 {
 	const struct nlattr *ovs_key = nla_data(a);
@@ -2301,25 +2357,54 @@ static void ovs_nla_free_set_action(const struct nlattr *a)
 	}
 }
 
-void ovs_nla_free_flow_actions(struct sw_flow_actions *sf_acts)
+static void ovs_nla_free_nested_actions(const struct nlattr *actions, int len)
 {
 	const struct nlattr *a;
 	int rem;
 
-	if (!sf_acts)
+	/* Whenever new actions are added, the need to update this
+	 * function should be considered.
+	 */
+	BUILD_BUG_ON(OVS_ACTION_ATTR_MAX != 23);
+
+	if (!actions)
 		return;
 
-	nla_for_each_attr(a, sf_acts->actions, sf_acts->actions_len, rem) {
+	nla_for_each_attr(a, actions, len, rem) {
 		switch (nla_type(a)) {
-		case OVS_ACTION_ATTR_SET:
-			ovs_nla_free_set_action(a);
+		case OVS_ACTION_ATTR_CHECK_PKT_LEN:
+			ovs_nla_free_check_pkt_len_action(a);
+			break;
+
+		case OVS_ACTION_ATTR_CLONE:
+			ovs_nla_free_clone_action(a);
 			break;
+
 		case OVS_ACTION_ATTR_CT:
 			ovs_ct_free_action(a);
 			break;
+
+		case OVS_ACTION_ATTR_DEC_TTL:
+			ovs_nla_free_dec_ttl_action(a);
+			break;
+
+		case OVS_ACTION_ATTR_SAMPLE:
+			ovs_nla_free_sample_action(a);
+			break;
+
+		case OVS_ACTION_ATTR_SET:
+			ovs_nla_free_set_action(a);
+			break;
 		}
 	}
+}
+
+void ovs_nla_free_flow_actions(struct sw_flow_actions *sf_acts)
+{
+	if (!sf_acts)
+		return;
 
+	ovs_nla_free_nested_actions(sf_acts->actions, sf_acts->actions_len);
 	kfree(sf_acts);
 }
 
@@ -3429,7 +3514,9 @@ static int clone_action_to_attr(const struct nlattr *attr,
 	if (!start)
 		return -EMSGSIZE;
 
-	err = ovs_nla_put_actions(nla_data(attr), rem, skb);
+	/* Skipping the OVS_CLONE_ATTR_EXEC that is always the first attribute. */
+	attr = nla_next(nla_data(attr), &rem);
+	err = ovs_nla_put_actions(attr, rem, skb);
 
 	if (err)
 		nla_nest_cancel(skb, start);
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index 25bbc4cc8b13..f15d6942da45 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -113,8 +113,8 @@ static __net_exit void rxrpc_exit_net(struct net *net)
 	struct rxrpc_net *rxnet = rxrpc_net(net);
 
 	rxnet->live = false;
-	del_timer_sync(&rxnet->peer_keepalive_timer);
 	cancel_work_sync(&rxnet->peer_keepalive_work);
+	del_timer_sync(&rxnet->peer_keepalive_timer);
 	rxrpc_destroy_all_calls(rxnet);
 	rxrpc_destroy_all_connections(rxnet);
 	rxrpc_destroy_all_peers(rxnet);
diff --git a/net/sctp/outqueue.c b/net/sctp/outqueue.c
index ff47091c385e..b3950963fc8f 100644
--- a/net/sctp/outqueue.c
+++ b/net/sctp/outqueue.c
@@ -911,6 +911,7 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 				ctx->asoc->base.sk->sk_err = -error;
 				return;
 			}
+			ctx->asoc->stats.octrlchunks++;
 			break;
 
 		case SCTP_CID_ABORT:
@@ -935,7 +936,10 @@ static void sctp_outq_flush_ctrl(struct sctp_flush_ctx *ctx)
 
 		case SCTP_CID_HEARTBEAT:
 			if (chunk->pmtu_probe) {
-				sctp_packet_singleton(ctx->transport, chunk, ctx->gfp);
+				error = sctp_packet_singleton(ctx->transport,
+							      chunk, ctx->gfp);
+				if (!error)
+					ctx->asoc->stats.octrlchunks++;
 				break;
 			}
 			fallthrough;
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index 5c4c0320e822..fa8897497dcc 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2419,8 +2419,8 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		    sk->sk_state != SMC_CLOSED) {
 			if (val) {
 				SMC_STAT_INC(smc, ndly_cnt);
-				mod_delayed_work(smc->conn.lgr->tx_wq,
-						 &smc->conn.tx_work, 0);
+				smc_tx_pending(&smc->conn);
+				cancel_delayed_work(&smc->conn.tx_work);
 			}
 		}
 		break;
@@ -2430,8 +2430,8 @@ static int smc_setsockopt(struct socket *sock, int level, int optname,
 		    sk->sk_state != SMC_CLOSED) {
 			if (!val) {
 				SMC_STAT_INC(smc, cork_cnt);
-				mod_delayed_work(smc->conn.lgr->tx_wq,
-						 &smc->conn.tx_work, 0);
+				smc_tx_pending(&smc->conn);
+				cancel_delayed_work(&smc->conn.tx_work);
 			}
 		}
 		break;
diff --git a/net/smc/smc_core.c b/net/smc/smc_core.c
index dee336eef6d2..7401ec67ebcf 100644
--- a/net/smc/smc_core.c
+++ b/net/smc/smc_core.c
@@ -1822,7 +1822,7 @@ static struct smc_buf_desc *smc_buf_get_slot(int compressed_bufsize,
  */
 static inline int smc_rmb_wnd_update_limit(int rmbe_size)
 {
-	return min_t(int, rmbe_size / 10, SOCK_MIN_SNDBUF / 2);
+	return max_t(int, rmbe_size / 10, SOCK_MIN_SNDBUF / 2);
 }
 
 /* map an rmb buf to a link */
diff --git a/net/smc/smc_tx.c b/net/smc/smc_tx.c
index 738a4a99c827..31ee76131a79 100644
--- a/net/smc/smc_tx.c
+++ b/net/smc/smc_tx.c
@@ -594,27 +594,32 @@ int smc_tx_sndbuf_nonempty(struct smc_connection *conn)
 	return rc;
 }
 
-/* Wakeup sndbuf consumers from process context
- * since there is more data to transmit
- */
-void smc_tx_work(struct work_struct *work)
+void smc_tx_pending(struct smc_connection *conn)
 {
-	struct smc_connection *conn = container_of(to_delayed_work(work),
-						   struct smc_connection,
-						   tx_work);
 	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 	int rc;
 
-	lock_sock(&smc->sk);
 	if (smc->sk.sk_err)
-		goto out;
+		return;
 
 	rc = smc_tx_sndbuf_nonempty(conn);
 	if (!rc && conn->local_rx_ctrl.prod_flags.write_blocked &&
 	    !atomic_read(&conn->bytes_to_rcv))
 		conn->local_rx_ctrl.prod_flags.write_blocked = 0;
+}
+
+/* Wakeup sndbuf consumers from process context
+ * since there is more data to transmit
+ */
+void smc_tx_work(struct work_struct *work)
+{
+	struct smc_connection *conn = container_of(to_delayed_work(work),
+						   struct smc_connection,
+						   tx_work);
+	struct smc_sock *smc = container_of(conn, struct smc_sock, conn);
 
-out:
+	lock_sock(&smc->sk);
+	smc_tx_pending(conn);
 	release_sock(&smc->sk);
 }
 
diff --git a/net/smc/smc_tx.h b/net/smc/smc_tx.h
index 07e6ad76224a..a59f370b8b43 100644
--- a/net/smc/smc_tx.h
+++ b/net/smc/smc_tx.h
@@ -27,6 +27,7 @@ static inline int smc_tx_prepared_sends(struct smc_connection *conn)
 	return smc_curs_diff(conn->sndbuf_desc->len, &sent, &prep);
 }
 
+void smc_tx_pending(struct smc_connection *conn);
 void smc_tx_work(struct work_struct *work);
 void smc_tx_init(struct smc_sock *smc);
 int smc_tx_sendmsg(struct smc_sock *smc, struct msghdr *msg, size_t len);
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 5d5627bf3b18..3286add1a958 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2202,6 +2202,7 @@ call_transmit_status(struct rpc_task *task)
 		 * socket just returned a connection error,
 		 * then hold onto the transport lock.
 		 */
+	case -ENOMEM:
 	case -ENOBUFS:
 		rpc_delay(task, HZ>>2);
 		fallthrough;
@@ -2285,6 +2286,7 @@ call_bc_transmit_status(struct rpc_task *task)
 	case -ENOTCONN:
 	case -EPIPE:
 		break;
+	case -ENOMEM:
 	case -ENOBUFS:
 		rpc_delay(task, HZ>>2);
 		fallthrough;
@@ -2367,6 +2369,11 @@ call_status(struct rpc_task *task)
 	case -EPIPE:
 	case -EAGAIN:
 		break;
+	case -ENFILE:
+	case -ENOBUFS:
+	case -ENOMEM:
+		rpc_delay(task, HZ>>2);
+		break;
 	case -EIO:
 		/* shutdown or soft timeout */
 		goto out_exit;
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index c045f63d11fa..f0f55fbd1375 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -186,11 +186,6 @@ static void __rpc_add_wait_queue_priority(struct rpc_wait_queue *queue,
 
 /*
  * Add new request to wait queue.
- *
- * Swapper tasks always get inserted at the head of the queue.
- * This should avoid many nasty memory deadlocks and hopefully
- * improve overall performance.
- * Everyone else gets appended to the queue to ensure proper FIFO behavior.
  */
 static void __rpc_add_wait_queue(struct rpc_wait_queue *queue,
 		struct rpc_task *task,
@@ -199,8 +194,6 @@ static void __rpc_add_wait_queue(struct rpc_wait_queue *queue,
 	INIT_LIST_HEAD(&task->u.tk_wait.timer_list);
 	if (RPC_IS_PRIORITY(queue))
 		__rpc_add_wait_queue_priority(queue, task, queue_priority);
-	else if (RPC_IS_SWAPPER(task))
-		list_add(&task->u.tk_wait.list, &queue->tasks[0]);
 	else
 		list_add_tail(&task->u.tk_wait.list, &queue->tasks[0]);
 	task->tk_waitqueue = queue;
@@ -1012,8 +1005,10 @@ int rpc_malloc(struct rpc_task *task)
 	struct rpc_buffer *buf;
 	gfp_t gfp = GFP_NOFS;
 
+	if (RPC_IS_ASYNC(task))
+		gfp = GFP_NOWAIT | __GFP_NOWARN;
 	if (RPC_IS_SWAPPER(task))
-		gfp = __GFP_MEMALLOC | GFP_NOWAIT | __GFP_NOWARN;
+		gfp |= __GFP_MEMALLOC;
 
 	size += sizeof(struct rpc_buffer);
 	if (size <= RPC_BUFFER_MAXSIZE)
diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 478f857cdaed..6ea3d87e1147 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1096,7 +1096,9 @@ static int svc_tcp_sendmsg(struct socket *sock, struct xdr_buf *xdr,
 	int ret;
 
 	*sentp = 0;
-	xdr_alloc_bvec(xdr, GFP_KERNEL);
+	ret = xdr_alloc_bvec(xdr, GFP_KERNEL);
+	if (ret < 0)
+		return ret;
 
 	ret = kernel_sendmsg(sock, &msg, &rm, 1, rm.iov_len);
 	if (ret < 0)
diff --git a/net/sunrpc/xprt.c b/net/sunrpc/xprt.c
index d95426c0bd3a..e4adb780b69e 100644
--- a/net/sunrpc/xprt.c
+++ b/net/sunrpc/xprt.c
@@ -767,7 +767,8 @@ EXPORT_SYMBOL_GPL(xprt_disconnect_done);
  */
 static void xprt_schedule_autoclose_locked(struct rpc_xprt *xprt)
 {
-	set_bit(XPRT_CLOSE_WAIT, &xprt->state);
+	if (test_and_set_bit(XPRT_CLOSE_WAIT, &xprt->state))
+		return;
 	if (test_and_set_bit(XPRT_LOCKED, &xprt->state) == 0)
 		queue_work(xprtiod_workqueue, &xprt->task_cleanup);
 	else if (xprt->snd_task && !test_bit(XPRT_SND_IS_COOKIE, &xprt->state))
@@ -1353,17 +1354,6 @@ xprt_request_enqueue_transmit(struct rpc_task *task)
 				INIT_LIST_HEAD(&req->rq_xmit2);
 				goto out;
 			}
-		} else if (RPC_IS_SWAPPER(task)) {
-			list_for_each_entry(pos, &xprt->xmit_queue, rq_xmit) {
-				if (pos->rq_cong || pos->rq_bytes_sent)
-					continue;
-				if (RPC_IS_SWAPPER(pos->rq_task))
-					continue;
-				/* Note: req is added _before_ pos */
-				list_add_tail(&req->rq_xmit, &pos->rq_xmit);
-				INIT_LIST_HEAD(&req->rq_xmit2);
-				goto out;
-			}
 		} else if (!req->rq_seqno) {
 			list_for_each_entry(pos, &xprt->xmit_queue, rq_xmit) {
 				if (pos->rq_task->tk_owner != task->tk_owner)
@@ -1686,12 +1676,15 @@ static bool xprt_throttle_congested(struct rpc_xprt *xprt, struct rpc_task *task
 static struct rpc_rqst *xprt_dynamic_alloc_slot(struct rpc_xprt *xprt)
 {
 	struct rpc_rqst *req = ERR_PTR(-EAGAIN);
+	gfp_t gfp_mask = GFP_KERNEL;
 
 	if (xprt->num_reqs >= xprt->max_reqs)
 		goto out;
 	++xprt->num_reqs;
 	spin_unlock(&xprt->reserve_lock);
-	req = kzalloc(sizeof(struct rpc_rqst), GFP_NOFS);
+	if (current->flags & PF_WQ_WORKER)
+		gfp_mask |= __GFP_NORETRY | __GFP_NOWARN;
+	req = kzalloc(sizeof(*req), gfp_mask);
 	spin_lock(&xprt->reserve_lock);
 	if (req != NULL)
 		goto out;
diff --git a/net/sunrpc/xprtrdma/transport.c b/net/sunrpc/xprtrdma/transport.c
index 16e5696314a4..32df23796747 100644
--- a/net/sunrpc/xprtrdma/transport.c
+++ b/net/sunrpc/xprtrdma/transport.c
@@ -521,7 +521,7 @@ xprt_rdma_alloc_slot(struct rpc_xprt *xprt, struct rpc_task *task)
 	return;
 
 out_sleep:
-	task->tk_status = -EAGAIN;
+	task->tk_status = -ENOMEM;
 	xprt_add_backlog(xprt, task);
 }
 
@@ -574,8 +574,10 @@ xprt_rdma_allocate(struct rpc_task *task)
 	gfp_t flags;
 
 	flags = RPCRDMA_DEF_GFP;
+	if (RPC_IS_ASYNC(task))
+		flags = GFP_NOWAIT | __GFP_NOWARN;
 	if (RPC_IS_SWAPPER(task))
-		flags = __GFP_MEMALLOC | GFP_NOWAIT | __GFP_NOWARN;
+		flags |= __GFP_MEMALLOC;
 
 	if (!rpcrdma_check_regbuf(r_xprt, req->rl_sendbuf, rqst->rq_callsize,
 				  flags))
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 04f1b78bcbca..c2f7819827b6 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -763,12 +763,12 @@ xs_stream_start_connect(struct sock_xprt *transport)
 /**
  * xs_nospace - handle transmit was incomplete
  * @req: pointer to RPC request
+ * @transport: pointer to struct sock_xprt
  *
  */
-static int xs_nospace(struct rpc_rqst *req)
+static int xs_nospace(struct rpc_rqst *req, struct sock_xprt *transport)
 {
-	struct rpc_xprt *xprt = req->rq_xprt;
-	struct sock_xprt *transport = container_of(xprt, struct sock_xprt, xprt);
+	struct rpc_xprt *xprt = &transport->xprt;
 	struct sock *sk = transport->inet;
 	int ret = -EAGAIN;
 
@@ -779,25 +779,49 @@ static int xs_nospace(struct rpc_rqst *req)
 
 	/* Don't race with disconnect */
 	if (xprt_connected(xprt)) {
+		struct socket_wq *wq;
+
+		rcu_read_lock();
+		wq = rcu_dereference(sk->sk_wq);
+		set_bit(SOCKWQ_ASYNC_NOSPACE, &wq->flags);
+		rcu_read_unlock();
+
 		/* wait for more buffer space */
+		set_bit(SOCK_NOSPACE, &sk->sk_socket->flags);
 		sk->sk_write_pending++;
 		xprt_wait_for_buffer_space(xprt);
 	} else
 		ret = -ENOTCONN;
 
 	spin_unlock(&xprt->transport_lock);
+	return ret;
+}
 
-	/* Race breaker in case memory is freed before above code is called */
-	if (ret == -EAGAIN) {
-		struct socket_wq *wq;
+static int xs_sock_nospace(struct rpc_rqst *req)
+{
+	struct sock_xprt *transport =
+		container_of(req->rq_xprt, struct sock_xprt, xprt);
+	struct sock *sk = transport->inet;
+	int ret = -EAGAIN;
 
-		rcu_read_lock();
-		wq = rcu_dereference(sk->sk_wq);
-		set_bit(SOCKWQ_ASYNC_NOSPACE, &wq->flags);
-		rcu_read_unlock();
+	lock_sock(sk);
+	if (!sock_writeable(sk))
+		ret = xs_nospace(req, transport);
+	release_sock(sk);
+	return ret;
+}
 
-		sk->sk_write_space(sk);
-	}
+static int xs_stream_nospace(struct rpc_rqst *req)
+{
+	struct sock_xprt *transport =
+		container_of(req->rq_xprt, struct sock_xprt, xprt);
+	struct sock *sk = transport->inet;
+	int ret = -EAGAIN;
+
+	lock_sock(sk);
+	if (!sk_stream_memory_free(sk))
+		ret = xs_nospace(req, transport);
+	release_sock(sk);
 	return ret;
 }
 
@@ -887,7 +911,7 @@ static int xs_local_send_request(struct rpc_rqst *req)
 	case -ENOBUFS:
 		break;
 	case -EAGAIN:
-		status = xs_nospace(req);
+		status = xs_stream_nospace(req);
 		break;
 	default:
 		dprintk("RPC:       sendmsg returned unrecognized error %d\n",
@@ -963,7 +987,7 @@ static int xs_udp_send_request(struct rpc_rqst *req)
 		/* Should we call xs_close() here? */
 		break;
 	case -EAGAIN:
-		status = xs_nospace(req);
+		status = xs_sock_nospace(req);
 		break;
 	case -ENETUNREACH:
 	case -ENOBUFS:
@@ -1083,7 +1107,7 @@ static int xs_tcp_send_request(struct rpc_rqst *req)
 		/* Should we call xs_close() here? */
 		break;
 	case -EAGAIN:
-		status = xs_nospace(req);
+		status = xs_stream_nospace(req);
 		break;
 	case -ECONNRESET:
 	case -ECONNREFUSED:
@@ -2233,6 +2257,7 @@ static int xs_tcp_finish_connecting(struct rpc_xprt *xprt, struct socket *sock)
 		fallthrough;
 	case -EINPROGRESS:
 		/* SYN_SENT! */
+		set_bit(XPRT_SOCK_CONNECT_SENT, &transport->sock_state);
 		if (xprt->reestablish_timeout < XS_TCP_INIT_REEST_TO)
 			xprt->reestablish_timeout = XS_TCP_INIT_REEST_TO;
 		break;
@@ -2258,10 +2283,14 @@ static void xs_tcp_setup_socket(struct work_struct *work)
 	struct rpc_xprt *xprt = &transport->xprt;
 	int status = -EIO;
 
-	if (!sock) {
-		sock = xs_create_sock(xprt, transport,
-				xs_addr(xprt)->sa_family, SOCK_STREAM,
-				IPPROTO_TCP, true);
+	if (xprt_connected(xprt))
+		goto out;
+	if (test_and_clear_bit(XPRT_SOCK_CONNECT_SENT,
+			       &transport->sock_state) ||
+	    !sock) {
+		xs_reset_transport(transport);
+		sock = xs_create_sock(xprt, transport, xs_addr(xprt)->sa_family,
+				      SOCK_STREAM, IPPROTO_TCP, true);
 		if (IS_ERR(sock)) {
 			status = PTR_ERR(sock);
 			goto out;
@@ -2343,11 +2372,7 @@ static void xs_connect(struct rpc_xprt *xprt, struct rpc_task *task)
 
 	if (transport->sock != NULL) {
 		dprintk("RPC:       xs_connect delayed xprt %p for %lu "
-				"seconds\n",
-				xprt, xprt->reestablish_timeout / HZ);
-
-		/* Start by resetting any existing state */
-		xs_reset_transport(transport);
+			"seconds\n", xprt, xprt->reestablish_timeout / HZ);
 
 		delay = xprt_reconnect_delay(xprt);
 		xprt_reconnect_backoff(xprt, XS_TCP_INIT_REEST_TO);
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index bd96ec26f4f9..794ef3b3d7d4 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1483,7 +1483,7 @@ static int decrypt_internal(struct sock *sk, struct sk_buff *skb,
 	if (prot->version == TLS_1_3_VERSION ||
 	    prot->cipher_type == TLS_CIPHER_CHACHA20_POLY1305)
 		memcpy(iv + iv_offset, tls_ctx->rx.iv,
-		       crypto_aead_ivsize(ctx->aead_recv));
+		       prot->iv_size + prot->salt_size);
 	else
 		memcpy(iv + iv_offset, tls_ctx->rx.iv, prot->salt_size);
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index adc0d14cfd86..8e1e578d64bc 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -702,8 +702,12 @@ static bool cfg80211_find_ssid_match(struct cfg80211_colocated_ap *ap,
 
 	for (i = 0; i < request->n_ssids; i++) {
 		/* wildcard ssid in the scan request */
-		if (!request->ssids[i].ssid_len)
+		if (!request->ssids[i].ssid_len) {
+			if (ap->multi_bss && !ap->transmitted_bssid)
+				continue;
+
 			return true;
+		}
 
 		if (ap->ssid_len &&
 		    ap->ssid_len == request->ssids[i].ssid_len) {
@@ -829,6 +833,9 @@ static int cfg80211_scan_6ghz(struct cfg80211_registered_device *rdev)
 		    !cfg80211_find_ssid_match(ap, request))
 			continue;
 
+		if (!request->n_ssids && ap->multi_bss && !ap->transmitted_bssid)
+			continue;
+
 		cfg80211_scan_req_add_chan(request, chan, true);
 		memcpy(scan_6ghz_params->bssid, ap->bssid, ETH_ALEN);
 		scan_6ghz_params->short_ssid = ap->short_ssid;
diff --git a/scripts/Makefile.ubsan b/scripts/Makefile.ubsan
index 9e2092fd5206..7099c603ff0a 100644
--- a/scripts/Makefile.ubsan
+++ b/scripts/Makefile.ubsan
@@ -8,7 +8,6 @@ ubsan-cflags-$(CONFIG_UBSAN_LOCAL_BOUNDS)	+= -fsanitize=local-bounds
 ubsan-cflags-$(CONFIG_UBSAN_SHIFT)		+= -fsanitize=shift
 ubsan-cflags-$(CONFIG_UBSAN_DIV_ZERO)		+= -fsanitize=integer-divide-by-zero
 ubsan-cflags-$(CONFIG_UBSAN_UNREACHABLE)	+= -fsanitize=unreachable
-ubsan-cflags-$(CONFIG_UBSAN_OBJECT_SIZE)	+= -fsanitize=object-size
 ubsan-cflags-$(CONFIG_UBSAN_BOOL)		+= -fsanitize=bool
 ubsan-cflags-$(CONFIG_UBSAN_ENUM)		+= -fsanitize=enum
 ubsan-cflags-$(CONFIG_UBSAN_TRAP)		+= -fsanitize-undefined-trap-on-error
diff --git a/tools/build/feature/Makefile b/tools/build/feature/Makefile
index e1e670014bd0..0e6d685b8617 100644
--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -213,9 +213,16 @@ strip-libs = $(filter-out -l%,$(1))
 PERL_EMBED_LDOPTS = $(shell perl -MExtUtils::Embed -e ldopts 2>/dev/null)
 PERL_EMBED_LDFLAGS = $(call strip-libs,$(PERL_EMBED_LDOPTS))
 PERL_EMBED_LIBADD = $(call grep-libs,$(PERL_EMBED_LDOPTS))
-PERL_EMBED_CCOPTS = `perl -MExtUtils::Embed -e ccopts 2>/dev/null`
+PERL_EMBED_CCOPTS = $(shell perl -MExtUtils::Embed -e ccopts 2>/dev/null)
 FLAGS_PERL_EMBED=$(PERL_EMBED_CCOPTS) $(PERL_EMBED_LDOPTS)
 
+ifeq ($(CC_NO_CLANG), 0)
+  PERL_EMBED_LDOPTS := $(filter-out -specs=%,$(PERL_EMBED_LDOPTS))
+  PERL_EMBED_CCOPTS := $(filter-out -flto=auto -ffat-lto-objects, $(PERL_EMBED_CCOPTS))
+  PERL_EMBED_CCOPTS := $(filter-out -specs=%,$(PERL_EMBED_CCOPTS))
+  FLAGS_PERL_EMBED += -Wno-compound-token-split-by-macro
+endif
+
 $(OUTPUT)test-libperl.bin:
 	$(BUILD) $(FLAGS_PERL_EMBED)
 
diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
index 74c3b73a5fbe..089b73b3cb37 100644
--- a/tools/lib/bpf/Makefile
+++ b/tools/lib/bpf/Makefile
@@ -126,7 +126,7 @@ GLOBAL_SYM_COUNT = $(shell readelf -s --wide $(BPF_IN_SHARED) | \
 			   sort -u | wc -l)
 VERSIONED_SYM_COUNT = $(shell readelf --dyn-syms --wide $(OUTPUT)libbpf.so | \
 			      sed 's/\[.*\]//' | \
-			      awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}' | \
+			      awk '/GLOBAL/ && /DEFAULT/ && !/UND|ABS/ {print $$NF}' | \
 			      grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 | sort -u | wc -l)
 
 CMD_TARGETS = $(LIB_TARGET) $(PC_FILE)
@@ -195,7 +195,7 @@ check_abi: $(OUTPUT)libbpf.so $(VERSION_SCRIPT)
 		    sort -u > $(OUTPUT)libbpf_global_syms.tmp;		 \
 		readelf --dyn-syms --wide $(OUTPUT)libbpf.so |		 \
 		    sed 's/\[.*\]//' |					 \
-		    awk '/GLOBAL/ && /DEFAULT/ && !/UND/ {print $$NF}'|  \
+		    awk '/GLOBAL/ && /DEFAULT/ && !/UND|ABS/ {print $$NF}'|  \
 		    grep -Eo '[^ ]+@LIBBPF_' | cut -d@ -f1 |		 \
 		    sort -u > $(OUTPUT)libbpf_versioned_syms.tmp; 	 \
 		diff -u $(OUTPUT)libbpf_global_syms.tmp			 \
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 71772b20ea73..a92f0f025ec7 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -270,6 +270,9 @@ ifdef PYTHON_CONFIG
   PYTHON_EMBED_LIBADD := $(call grep-libs,$(PYTHON_EMBED_LDOPTS)) -lutil
   PYTHON_EMBED_CCOPTS := $(shell $(PYTHON_CONFIG_SQ) --includes 2>/dev/null)
   FLAGS_PYTHON_EMBED := $(PYTHON_EMBED_CCOPTS) $(PYTHON_EMBED_LDOPTS)
+  ifeq ($(CC_NO_CLANG), 0)
+    PYTHON_EMBED_CCOPTS := $(filter-out -ffat-lto-objects, $(PYTHON_EMBED_CCOPTS))
+  endif
 endif
 
 FEATURE_CHECK_CFLAGS-libpython := $(PYTHON_EMBED_CCOPTS)
@@ -785,6 +788,9 @@ else
     LDFLAGS += $(PERL_EMBED_LDFLAGS)
     EXTLIBS += $(PERL_EMBED_LIBADD)
     CFLAGS += -DHAVE_LIBPERL_SUPPORT
+    ifeq ($(CC_NO_CLANG), 0)
+      CFLAGS += -Wno-compound-token-split-by-macro
+    endif
     $(call detected,CONFIG_LIBPERL)
   endif
 endif
diff --git a/tools/perf/arch/arm64/util/arm-spe.c b/tools/perf/arch/arm64/util/arm-spe.c
index a4420d4df503..7d589a705fc8 100644
--- a/tools/perf/arch/arm64/util/arm-spe.c
+++ b/tools/perf/arch/arm64/util/arm-spe.c
@@ -154,6 +154,12 @@ static int arm_spe_recording_options(struct auxtrace_record *itr,
 		arm_spe_set_timestamp(itr, arm_spe_evsel);
 	}
 
+	/*
+	 * Set this only so that perf report knows that SPE generates memory info. It has no effect
+	 * on the opening of the event or the SPE data produced.
+	 */
+	evsel__set_sample_bit(arm_spe_evsel, DATA_SRC);
+
 	/* Add dummy event to keep tracking */
 	err = parse_events(evlist, "dummy:u", NULL);
 	if (err)
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 2f6b67189b42..6aae7b6c376b 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -434,7 +434,7 @@ void pthread__unblock_sigwinch(void)
 static int libperf_print(enum libperf_print_level level,
 			 const char *fmt, va_list ap)
 {
-	return eprintf(level, verbose, fmt, ap);
+	return veprintf(level, verbose, fmt, ap);
 }
 
 int main(int argc, const char **argv)
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 352f16076e01..562e9b808027 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -2076,6 +2076,7 @@ prefetch_event(char *buf, u64 head, size_t mmap_size,
 	       bool needs_swap, union perf_event *error)
 {
 	union perf_event *event;
+	u16 event_size;
 
 	/*
 	 * Ensure we have enough space remaining to read
@@ -2088,15 +2089,23 @@ prefetch_event(char *buf, u64 head, size_t mmap_size,
 	if (needs_swap)
 		perf_event_header__bswap(&event->header);
 
-	if (head + event->header.size <= mmap_size)
+	event_size = event->header.size;
+	if (head + event_size <= mmap_size)
 		return event;
 
 	/* We're not fetching the event so swap back again */
 	if (needs_swap)
 		perf_event_header__bswap(&event->header);
 
-	pr_debug("%s: head=%#" PRIx64 " event->header_size=%#x, mmap_size=%#zx:"
-		 " fuzzed or compressed perf.data?\n",__func__, head, event->header.size, mmap_size);
+	/* Check if the event fits into the next mmapped buf. */
+	if (event_size <= mmap_size - head % page_size) {
+		/* Remap buf and fetch again. */
+		return NULL;
+	}
+
+	/* Invalid input. Event size should never exceed mmap_size. */
+	pr_debug("%s: head=%#" PRIx64 " event->header.size=%#x, mmap_size=%#zx:"
+		 " fuzzed or compressed perf.data?\n", __func__, head, event_size, mmap_size);
 
 	return error;
 }
diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index 483f05004e68..c255a2c90cd6 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -1,12 +1,14 @@
-from os import getenv
+from os import getenv, path
 from subprocess import Popen, PIPE
 from re import sub
 
 cc = getenv("CC")
 cc_is_clang = b"clang version" in Popen([cc.split()[0], "-v"], stderr=PIPE).stderr.readline()
+src_feature_tests  = getenv('srctree') + '/tools/build/feature'
 
 def clang_has_option(option):
-    return [o for o in Popen([cc, option], stderr=PIPE).stderr.readlines() if b"unknown argument" in o] == [ ]
+    cc_output = Popen([cc, option, path.join(src_feature_tests, "test-hello.c") ], stderr=PIPE).stderr.readlines()
+    return [o for o in cc_output if ((b"unknown argument" in o) or (b"is not supported" in o))] == [ ]
 
 if cc_is_clang:
     from distutils.sysconfig import get_config_vars
@@ -23,6 +25,8 @@ if cc_is_clang:
             vars[var] = sub("-fstack-protector-strong", "", vars[var])
         if not clang_has_option("-fno-semantic-interposition"):
             vars[var] = sub("-fno-semantic-interposition", "", vars[var])
+        if not clang_has_option("-ffat-lto-objects"):
+            vars[var] = sub("-ffat-lto-objects", "", vars[var])
 
 from distutils.core import setup, Extension
 
diff --git a/tools/testing/selftests/bpf/progs/test_sk_lookup.c b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
index ac6f7f205e25..cb0aa46b20d1 100644
--- a/tools/testing/selftests/bpf/progs/test_sk_lookup.c
+++ b/tools/testing/selftests/bpf/progs/test_sk_lookup.c
@@ -404,8 +404,7 @@ int ctx_narrow_access(struct bpf_sk_lookup *ctx)
 
 	/* Narrow loads from remote_port field. Expect SRC_PORT. */
 	if (LSB(ctx->remote_port, 0) != ((SRC_PORT >> 0) & 0xff) ||
-	    LSB(ctx->remote_port, 1) != ((SRC_PORT >> 8) & 0xff) ||
-	    LSB(ctx->remote_port, 2) != 0 || LSB(ctx->remote_port, 3) != 0)
+	    LSB(ctx->remote_port, 1) != ((SRC_PORT >> 8) & 0xff))
 		return SK_DROP;
 	if (LSW(ctx->remote_port, 0) != SRC_PORT)
 		return SK_DROP;
diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 623cec04ad42..0cf7e90c0052 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -221,7 +221,7 @@ int cg_find_unified_root(char *root, size_t len)
 
 int cg_create(const char *cgroup)
 {
-	return mkdir(cgroup, 0644);
+	return mkdir(cgroup, 0755);
 }
 
 int cg_wait_for_proc_count(const char *cgroup, int count)
diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index 3df648c37876..600123503063 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -1,11 +1,14 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
+#define _GNU_SOURCE
 #include <linux/limits.h>
+#include <linux/sched.h>
 #include <sys/types.h>
 #include <sys/mman.h>
 #include <sys/wait.h>
 #include <unistd.h>
 #include <fcntl.h>
+#include <sched.h>
 #include <stdio.h>
 #include <errno.h>
 #include <signal.h>
@@ -674,6 +677,166 @@ static int test_cgcore_thread_migration(const char *root)
 	return ret;
 }
 
+/*
+ * cgroup migration permission check should be performed based on the
+ * credentials at the time of open instead of write.
+ */
+static int test_cgcore_lesser_euid_open(const char *root)
+{
+	const uid_t test_euid = 65534;	/* usually nobody, any !root is fine */
+	int ret = KSFT_FAIL;
+	char *cg_test_a = NULL, *cg_test_b = NULL;
+	char *cg_test_a_procs = NULL, *cg_test_b_procs = NULL;
+	int cg_test_b_procs_fd = -1;
+	uid_t saved_uid;
+
+	cg_test_a = cg_name(root, "cg_test_a");
+	cg_test_b = cg_name(root, "cg_test_b");
+
+	if (!cg_test_a || !cg_test_b)
+		goto cleanup;
+
+	cg_test_a_procs = cg_name(cg_test_a, "cgroup.procs");
+	cg_test_b_procs = cg_name(cg_test_b, "cgroup.procs");
+
+	if (!cg_test_a_procs || !cg_test_b_procs)
+		goto cleanup;
+
+	if (cg_create(cg_test_a) || cg_create(cg_test_b))
+		goto cleanup;
+
+	if (cg_enter_current(cg_test_a))
+		goto cleanup;
+
+	if (chown(cg_test_a_procs, test_euid, -1) ||
+	    chown(cg_test_b_procs, test_euid, -1))
+		goto cleanup;
+
+	saved_uid = geteuid();
+	if (seteuid(test_euid))
+		goto cleanup;
+
+	cg_test_b_procs_fd = open(cg_test_b_procs, O_RDWR);
+
+	if (seteuid(saved_uid))
+		goto cleanup;
+
+	if (cg_test_b_procs_fd < 0)
+		goto cleanup;
+
+	if (write(cg_test_b_procs_fd, "0", 1) >= 0 || errno != EACCES)
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	cg_enter_current(root);
+	if (cg_test_b_procs_fd >= 0)
+		close(cg_test_b_procs_fd);
+	if (cg_test_b)
+		cg_destroy(cg_test_b);
+	if (cg_test_a)
+		cg_destroy(cg_test_a);
+	free(cg_test_b_procs);
+	free(cg_test_a_procs);
+	free(cg_test_b);
+	free(cg_test_a);
+	return ret;
+}
+
+struct lesser_ns_open_thread_arg {
+	const char	*path;
+	int		fd;
+	int		err;
+};
+
+static int lesser_ns_open_thread_fn(void *arg)
+{
+	struct lesser_ns_open_thread_arg *targ = arg;
+
+	targ->fd = open(targ->path, O_RDWR);
+	targ->err = errno;
+	return 0;
+}
+
+/*
+ * cgroup migration permission check should be performed based on the cgroup
+ * namespace at the time of open instead of write.
+ */
+static int test_cgcore_lesser_ns_open(const char *root)
+{
+	static char stack[65536];
+	const uid_t test_euid = 65534;	/* usually nobody, any !root is fine */
+	int ret = KSFT_FAIL;
+	char *cg_test_a = NULL, *cg_test_b = NULL;
+	char *cg_test_a_procs = NULL, *cg_test_b_procs = NULL;
+	int cg_test_b_procs_fd = -1;
+	struct lesser_ns_open_thread_arg targ = { .fd = -1 };
+	pid_t pid;
+	int status;
+
+	cg_test_a = cg_name(root, "cg_test_a");
+	cg_test_b = cg_name(root, "cg_test_b");
+
+	if (!cg_test_a || !cg_test_b)
+		goto cleanup;
+
+	cg_test_a_procs = cg_name(cg_test_a, "cgroup.procs");
+	cg_test_b_procs = cg_name(cg_test_b, "cgroup.procs");
+
+	if (!cg_test_a_procs || !cg_test_b_procs)
+		goto cleanup;
+
+	if (cg_create(cg_test_a) || cg_create(cg_test_b))
+		goto cleanup;
+
+	if (cg_enter_current(cg_test_b))
+		goto cleanup;
+
+	if (chown(cg_test_a_procs, test_euid, -1) ||
+	    chown(cg_test_b_procs, test_euid, -1))
+		goto cleanup;
+
+	targ.path = cg_test_b_procs;
+	pid = clone(lesser_ns_open_thread_fn, stack + sizeof(stack),
+		    CLONE_NEWCGROUP | CLONE_FILES | CLONE_VM | SIGCHLD,
+		    &targ);
+	if (pid < 0)
+		goto cleanup;
+
+	if (waitpid(pid, &status, 0) < 0)
+		goto cleanup;
+
+	if (!WIFEXITED(status))
+		goto cleanup;
+
+	cg_test_b_procs_fd = targ.fd;
+	if (cg_test_b_procs_fd < 0)
+		goto cleanup;
+
+	if (cg_enter_current(cg_test_a))
+		goto cleanup;
+
+	if ((status = write(cg_test_b_procs_fd, "0", 1)) >= 0 || errno != ENOENT)
+		goto cleanup;
+
+	ret = KSFT_PASS;
+
+cleanup:
+	cg_enter_current(root);
+	if (cg_test_b_procs_fd >= 0)
+		close(cg_test_b_procs_fd);
+	if (cg_test_b)
+		cg_destroy(cg_test_b);
+	if (cg_test_a)
+		cg_destroy(cg_test_a);
+	free(cg_test_b_procs);
+	free(cg_test_a_procs);
+	free(cg_test_b);
+	free(cg_test_a);
+	return ret;
+}
+
 #define T(x) { x, #x }
 struct corecg_test {
 	int (*fn)(const char *root);
@@ -689,6 +852,8 @@ struct corecg_test {
 	T(test_cgcore_proc_migration),
 	T(test_cgcore_thread_migration),
 	T(test_cgcore_destroy),
+	T(test_cgcore_lesser_euid_open),
+	T(test_cgcore_lesser_ns_open),
 };
 #undef T
 
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 6cad7dea5d0b..fefdf3a6dae3 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -431,8 +431,8 @@ static void kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
 
 void kvm_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
-	kvm_dirty_ring_free(&vcpu->dirty_ring);
 	kvm_arch_vcpu_destroy(vcpu);
+	kvm_dirty_ring_free(&vcpu->dirty_ring);
 
 	/*
 	 * No need for rcu_read_lock as VCPU_RUN is the only place that changes
