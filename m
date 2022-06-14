Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA8654B703
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 18:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344566AbiFNQ6E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 12:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352233AbiFNQ6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 12:58:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C862A240;
        Tue, 14 Jun 2022 09:57:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F60EB81A07;
        Tue, 14 Jun 2022 16:57:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463ADC3411B;
        Tue, 14 Jun 2022 16:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655225872;
        bh=Oh50LZl2B9+Nycc1QzgBgqn8hle2REyE5JBMJIi53vg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGR+vFdUuPbGqKsYL44CNUB2HBxZ/TgaunT1YjDyeadPOdD52f/NNuZIeBxabQEUd
         zYUXLvhegJ8FVI7LHALRKSZf1IrMYP8PhlfDwD1lnfFcnfjx3y+qksRvDokqXEktCy
         X6wxS57V/brB1OPuASt6tUmI1sYYiLLikpFu1d2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.17.15
Date:   Tue, 14 Jun 2022 18:57:40 +0200
Message-Id: <165522580880176@kroah.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <165522580839104@kroah.com>
References: <165522580839104@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/ABI/testing/sysfs-ata b/Documentation/ABI/testing/sysfs-ata
index 2f726c914752..3daecac48964 100644
--- a/Documentation/ABI/testing/sysfs-ata
+++ b/Documentation/ABI/testing/sysfs-ata
@@ -107,13 +107,14 @@ Description:
 				described in ATA8 7.16 and 7.17. Only valid if
 				the device is not a PM.
 
-		pio_mode:	(RO) Transfer modes supported by the device when
-				in PIO mode. Mostly used by PATA device.
+		pio_mode:	(RO) PIO transfer mode used by the device.
+				Mostly used by PATA devices.
 
-		xfer_mode:	(RO) Current transfer mode
+		xfer_mode:	(RO) Current transfer mode. Mostly used by
+				PATA devices.
 
-		dma_mode:	(RO) Transfer modes supported by the device when
-				in DMA mode. Mostly used by PATA device.
+		dma_mode:	(RO) DMA transfer mode used by the device.
+				Mostly used by PATA devices.
 
 		class:		(RO) Device class. Can be "ata" for disk,
 				"atapi" for packet device, "pmp" for PM, or
diff --git a/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml b/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
index 5d2d989de893..37402c370fbb 100644
--- a/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
+++ b/Documentation/devicetree/bindings/regulator/mt6315-regulator.yaml
@@ -55,7 +55,7 @@ examples:
           regulator-min-microvolt = <300000>;
           regulator-max-microvolt = <1193750>;
           regulator-enable-ramp-delay = <256>;
-          regulator-allowed-modes = <0 1 2 4>;
+          regulator-allowed-modes = <0 1 2>;
         };
 
         vbuck3 {
@@ -63,7 +63,7 @@ examples:
           regulator-min-microvolt = <300000>;
           regulator-max-microvolt = <1193750>;
           regulator-enable-ramp-delay = <256>;
-          regulator-allowed-modes = <0 1 2 4>;
+          regulator-allowed-modes = <0 1 2>;
         };
       };
     };
diff --git a/Documentation/devicetree/bindings/remoteproc/mtk,scp.yaml b/Documentation/devicetree/bindings/remoteproc/mtk,scp.yaml
index d21a25ee96e6..8b2c0f1f8550 100644
--- a/Documentation/devicetree/bindings/remoteproc/mtk,scp.yaml
+++ b/Documentation/devicetree/bindings/remoteproc/mtk,scp.yaml
@@ -22,11 +22,13 @@ properties:
 
   reg:
     description:
-      Should contain the address ranges for memory regions SRAM, CFG, and
-      L1TCM.
+      Should contain the address ranges for memory regions SRAM, CFG, and,
+      on some platforms, L1TCM.
+    minItems: 2
     maxItems: 3
 
   reg-names:
+    minItems: 2
     items:
       - const: sram
       - const: cfg
@@ -46,16 +48,30 @@ required:
   - reg
   - reg-names
 
-if:
-  properties:
-    compatible:
-      enum:
-        - mediatek,mt8183-scp
-        - mediatek,mt8192-scp
-then:
-  required:
-    - clocks
-    - clock-names
+allOf:
+  - if:
+      properties:
+        compatible:
+          enum:
+            - mediatek,mt8183-scp
+            - mediatek,mt8192-scp
+    then:
+      required:
+        - clocks
+        - clock-names
+
+  - if:
+      properties:
+        compatible:
+          enum:
+            - mediatek,mt8183-scp
+            - mediatek,mt8186-scp
+    then:
+      properties:
+        reg:
+          maxItems: 2
+        reg-names:
+          maxItems: 2
 
 additionalProperties:
   type: object
@@ -75,10 +91,10 @@ additionalProperties:
 
 examples:
   - |
-    #include <dt-bindings/clock/mt8183-clk.h>
+    #include <dt-bindings/clock/mt8192-clk.h>
 
     scp@10500000 {
-        compatible = "mediatek,mt8183-scp";
+        compatible = "mediatek,mt8192-scp";
         reg = <0x10500000 0x80000>,
               <0x10700000 0x8000>,
               <0x10720000 0xe0000>;
diff --git a/Documentation/tools/rtla/Makefile b/Documentation/tools/rtla/Makefile
index 9f2b84af1a6c..093af6d7a0e9 100644
--- a/Documentation/tools/rtla/Makefile
+++ b/Documentation/tools/rtla/Makefile
@@ -17,9 +17,21 @@ DOC_MAN1	= $(addprefix $(OUTPUT),$(_DOC_MAN1))
 RST2MAN_DEP	:= $(shell command -v rst2man 2>/dev/null)
 RST2MAN_OPTS	+= --verbose
 
+TEST_RST2MAN = $(shell sh -c "rst2man --version > /dev/null 2>&1 || echo n")
+
 $(OUTPUT)%.1: %.rst
 ifndef RST2MAN_DEP
-	$(error "rst2man not found, but required to generate man pages")
+	$(info ********************************************)
+	$(info ** NOTICE: rst2man not found)
+	$(info **)
+	$(info ** Consider installing the latest rst2man from your)
+	$(info ** distribution, e.g., 'dnf install python3-docutils' on Fedora,)
+	$(info ** or from source:)
+	$(info **)
+	$(info **  https://docutils.sourceforge.io/docs/dev/repository.html )
+	$(info **)
+	$(info ********************************************)
+	$(error NOTICE: rst2man required to generate man pages)
 endif
 	rst2man $(RST2MAN_OPTS) $< > $@
 
diff --git a/Makefile b/Makefile
index 5450a2c9efa6..c3676b04ca38 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 17
-SUBLEVEL = 14
+SUBLEVEL = 15
 EXTRAVERSION =
 NAME = Superb Owl
 
diff --git a/arch/arm/boot/dts/aspeed-ast2600-evb.dts b/arch/arm/boot/dts/aspeed-ast2600-evb.dts
index b7eb552640cb..788448cdd6b3 100644
--- a/arch/arm/boot/dts/aspeed-ast2600-evb.dts
+++ b/arch/arm/boot/dts/aspeed-ast2600-evb.dts
@@ -103,7 +103,7 @@ ethphy3: ethernet-phy@0 {
 &mac0 {
 	status = "okay";
 
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-rxid";
 	phy-handle = <&ethphy0>;
 
 	pinctrl-names = "default";
@@ -114,7 +114,7 @@ &mac0 {
 &mac1 {
 	status = "okay";
 
-	phy-mode = "rgmii";
+	phy-mode = "rgmii-rxid";
 	phy-handle = <&ethphy1>;
 
 	pinctrl-names = "default";
diff --git a/arch/arm/mach-ep93xx/clock.c b/arch/arm/mach-ep93xx/clock.c
index 28e0ae6e890e..00c2db101ce5 100644
--- a/arch/arm/mach-ep93xx/clock.c
+++ b/arch/arm/mach-ep93xx/clock.c
@@ -345,9 +345,10 @@ static struct clk_hw *clk_hw_register_ddiv(const char *name,
 	psc->hw.init = &init;
 
 	clk = clk_register(NULL, &psc->hw);
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
 		kfree(psc);
-
+		return ERR_CAST(clk);
+	}
 	return &psc->hw;
 }
 
@@ -452,9 +453,10 @@ static struct clk_hw *clk_hw_register_div(const char *name,
 	psc->hw.init = &init;
 
 	clk = clk_register(NULL, &psc->hw);
-	if (IS_ERR(clk))
+	if (IS_ERR(clk)) {
 		kfree(psc);
-
+		return ERR_CAST(clk);
+	}
 	return &psc->hw;
 }
 
diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index cbc41e261f1e..c679c57ec76e 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1120,6 +1120,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 			bpf_jit_binary_free(header);
 			prog->bpf_func = NULL;
 			prog->jited = 0;
+			prog->jited_len = 0;
 			goto out_off;
 		}
 		bpf_jit_binary_lock_ro(header);
diff --git a/arch/m68k/Kconfig.machine b/arch/m68k/Kconfig.machine
index eeab4f3e6c19..946853a08502 100644
--- a/arch/m68k/Kconfig.machine
+++ b/arch/m68k/Kconfig.machine
@@ -335,6 +335,7 @@ comment "Machine Options"
 
 config UBOOT
 	bool "Support for U-Boot command line parameters"
+	depends on COLDFIRE
 	help
 	  If you say Y here kernel will try to collect command
 	  line parameters from the initial u-boot stack.
diff --git a/arch/m68k/include/asm/pgtable_no.h b/arch/m68k/include/asm/pgtable_no.h
index 87151d67d91e..bce5ca56c388 100644
--- a/arch/m68k/include/asm/pgtable_no.h
+++ b/arch/m68k/include/asm/pgtable_no.h
@@ -42,7 +42,8 @@ extern void paging_init(void);
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
  */
-#define ZERO_PAGE(vaddr)	(virt_to_page(0))
+extern void *empty_zero_page;
+#define ZERO_PAGE(vaddr)	(virt_to_page(empty_zero_page))
 
 /*
  * All 32bit addresses are effectively valid for vmalloc...
diff --git a/arch/m68k/kernel/setup_mm.c b/arch/m68k/kernel/setup_mm.c
index 49e573b94326..811c7b85db87 100644
--- a/arch/m68k/kernel/setup_mm.c
+++ b/arch/m68k/kernel/setup_mm.c
@@ -87,15 +87,8 @@ void (*mach_sched_init) (void) __initdata = NULL;
 void (*mach_init_IRQ) (void) __initdata = NULL;
 void (*mach_get_model) (char *model);
 void (*mach_get_hardware_list) (struct seq_file *m);
-/* machine dependent timer functions */
-int (*mach_hwclk) (int, struct rtc_time*);
-EXPORT_SYMBOL(mach_hwclk);
 unsigned int (*mach_get_ss)(void);
-int (*mach_get_rtc_pll)(struct rtc_pll_info *);
-int (*mach_set_rtc_pll)(struct rtc_pll_info *);
 EXPORT_SYMBOL(mach_get_ss);
-EXPORT_SYMBOL(mach_get_rtc_pll);
-EXPORT_SYMBOL(mach_set_rtc_pll);
 void (*mach_reset)( void );
 void (*mach_halt)( void );
 void (*mach_power_off)( void );
diff --git a/arch/m68k/kernel/setup_no.c b/arch/m68k/kernel/setup_no.c
index 5e4104f07a44..19eea73d3c17 100644
--- a/arch/m68k/kernel/setup_no.c
+++ b/arch/m68k/kernel/setup_no.c
@@ -50,7 +50,6 @@ char __initdata command_line[COMMAND_LINE_SIZE];
 
 /* machine dependent timer functions */
 void (*mach_sched_init)(void) __initdata = NULL;
-int (*mach_hwclk) (int, struct rtc_time*);
 
 /* machine dependent reboot functions */
 void (*mach_reset)(void);
diff --git a/arch/m68k/kernel/time.c b/arch/m68k/kernel/time.c
index 340ffeea0a9d..a97600b2af50 100644
--- a/arch/m68k/kernel/time.c
+++ b/arch/m68k/kernel/time.c
@@ -63,6 +63,15 @@ void timer_heartbeat(void)
 #endif /* CONFIG_HEARTBEAT */
 
 #ifdef CONFIG_M68KCLASSIC
+/* machine dependent timer functions */
+int (*mach_hwclk) (int, struct rtc_time*);
+EXPORT_SYMBOL(mach_hwclk);
+
+int (*mach_get_rtc_pll)(struct rtc_pll_info *);
+int (*mach_set_rtc_pll)(struct rtc_pll_info *);
+EXPORT_SYMBOL(mach_get_rtc_pll);
+EXPORT_SYMBOL(mach_set_rtc_pll);
+
 #if !IS_BUILTIN(CONFIG_RTC_DRV_GENERIC)
 void read_persistent_clock64(struct timespec64 *ts)
 {
diff --git a/arch/mips/kernel/mips-cpc.c b/arch/mips/kernel/mips-cpc.c
index 17aff13cd7ce..3e386f7e1545 100644
--- a/arch/mips/kernel/mips-cpc.c
+++ b/arch/mips/kernel/mips-cpc.c
@@ -28,6 +28,7 @@ phys_addr_t __weak mips_cpc_default_phys_base(void)
 	cpc_node = of_find_compatible_node(of_root, NULL, "mti,mips-cpc");
 	if (cpc_node) {
 		err = of_address_to_resource(cpc_node, 0, &res);
+		of_node_put(cpc_node);
 		if (!err)
 			return res.start;
 	}
diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index b779603978e1..e49ef5b1857e 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -211,7 +211,6 @@ config PPC
 	select HAVE_HARDLOCKUP_DETECTOR_PERF	if PERF_EVENTS && HAVE_PERF_EVENTS_NMI && !HAVE_HARDLOCKUP_DETECTOR_ARCH
 	select HAVE_HW_BREAKPOINT		if PERF_EVENTS && (PPC_BOOK3S || PPC_8xx)
 	select HAVE_IOREMAP_PROT
-	select HAVE_IRQ_EXIT_ON_IRQ_STACK
 	select HAVE_IRQ_TIME_ACCOUNTING
 	select HAVE_KERNEL_GZIP
 	select HAVE_KERNEL_LZMA			if DEFAULT_UIMAGE
@@ -764,7 +763,6 @@ config THREAD_SHIFT
 	range 13 15
 	default "15" if PPC_256K_PAGES
 	default "14" if PPC64
-	default "14" if KASAN
 	default "13"
 	help
 	  Used to define the stack size. The default is almost always what you
diff --git a/arch/powerpc/include/asm/thread_info.h b/arch/powerpc/include/asm/thread_info.h
index d6e649b3c70b..bc3e1de9d08b 100644
--- a/arch/powerpc/include/asm/thread_info.h
+++ b/arch/powerpc/include/asm/thread_info.h
@@ -14,10 +14,16 @@
 
 #ifdef __KERNEL__
 
-#if defined(CONFIG_VMAP_STACK) && CONFIG_THREAD_SHIFT < PAGE_SHIFT
+#ifdef CONFIG_KASAN
+#define MIN_THREAD_SHIFT	(CONFIG_THREAD_SHIFT + 1)
+#else
+#define MIN_THREAD_SHIFT	CONFIG_THREAD_SHIFT
+#endif
+
+#if defined(CONFIG_VMAP_STACK) && MIN_THREAD_SHIFT < PAGE_SHIFT
 #define THREAD_SHIFT		PAGE_SHIFT
 #else
-#define THREAD_SHIFT		CONFIG_THREAD_SHIFT
+#define THREAD_SHIFT		MIN_THREAD_SHIFT
 #endif
 
 #define THREAD_SIZE		(1 << THREAD_SHIFT)
diff --git a/arch/powerpc/kernel/ptrace/ptrace-fpu.c b/arch/powerpc/kernel/ptrace/ptrace-fpu.c
index 5dca19361316..09c49632bfe5 100644
--- a/arch/powerpc/kernel/ptrace/ptrace-fpu.c
+++ b/arch/powerpc/kernel/ptrace/ptrace-fpu.c
@@ -17,9 +17,13 @@ int ptrace_get_fpr(struct task_struct *child, int index, unsigned long *data)
 
 #ifdef CONFIG_PPC_FPU_REGS
 	flush_fp_to_thread(child);
-	if (fpidx < (PT_FPSCR - PT_FPR0))
-		memcpy(data, &child->thread.TS_FPR(fpidx), sizeof(long));
-	else
+	if (fpidx < (PT_FPSCR - PT_FPR0)) {
+		if (IS_ENABLED(CONFIG_PPC32))
+			// On 32-bit the index we are passed refers to 32-bit words
+			*data = ((u32 *)child->thread.fp_state.fpr)[fpidx];
+		else
+			memcpy(data, &child->thread.TS_FPR(fpidx), sizeof(long));
+	} else
 		*data = child->thread.fp_state.fpscr;
 #else
 	*data = 0;
@@ -39,9 +43,13 @@ int ptrace_put_fpr(struct task_struct *child, int index, unsigned long data)
 
 #ifdef CONFIG_PPC_FPU_REGS
 	flush_fp_to_thread(child);
-	if (fpidx < (PT_FPSCR - PT_FPR0))
-		memcpy(&child->thread.TS_FPR(fpidx), &data, sizeof(long));
-	else
+	if (fpidx < (PT_FPSCR - PT_FPR0)) {
+		if (IS_ENABLED(CONFIG_PPC32))
+			// On 32-bit the index we are passed refers to 32-bit words
+			((u32 *)child->thread.fp_state.fpr)[fpidx] = data;
+		else
+			memcpy(&child->thread.TS_FPR(fpidx), &data, sizeof(long));
+	} else
 		child->thread.fp_state.fpscr = data;
 #endif
 
diff --git a/arch/powerpc/kernel/ptrace/ptrace.c b/arch/powerpc/kernel/ptrace/ptrace.c
index c43f77e2ac31..6d45fa288015 100644
--- a/arch/powerpc/kernel/ptrace/ptrace.c
+++ b/arch/powerpc/kernel/ptrace/ptrace.c
@@ -445,4 +445,7 @@ void __init pt_regs_check(void)
 	 * real registers.
 	 */
 	BUILD_BUG_ON(PT_DSCR < sizeof(struct user_pt_regs) / sizeof(unsigned long));
+
+	// ptrace_get/put_fpr() rely on PPC32 and VSX being incompatible
+	BUILD_BUG_ON(IS_ENABLED(CONFIG_PPC32) && IS_ENABLED(CONFIG_VSX));
 }
diff --git a/arch/riscv/kernel/efi.c b/arch/riscv/kernel/efi.c
index 024159298231..1aa540350abd 100644
--- a/arch/riscv/kernel/efi.c
+++ b/arch/riscv/kernel/efi.c
@@ -65,7 +65,7 @@ static int __init set_permissions(pte_t *ptep, unsigned long addr, void *data)
 
 	if (md->attribute & EFI_MEMORY_RO) {
 		val = pte_val(pte) & ~_PAGE_WRITE;
-		val = pte_val(pte) | _PAGE_READ;
+		val |= _PAGE_READ;
 		pte = __pte(val);
 	}
 	if (md->attribute & EFI_MEMORY_XP) {
diff --git a/arch/riscv/kernel/machine_kexec.c b/arch/riscv/kernel/machine_kexec.c
index cbef0fc73afa..df8e24559035 100644
--- a/arch/riscv/kernel/machine_kexec.c
+++ b/arch/riscv/kernel/machine_kexec.c
@@ -65,7 +65,9 @@ machine_kexec_prepare(struct kimage *image)
 		if (image->segment[i].memsz <= sizeof(fdt))
 			continue;
 
-		if (copy_from_user(&fdt, image->segment[i].buf, sizeof(fdt)))
+		if (image->file_mode)
+			memcpy(&fdt, image->segment[i].buf, sizeof(fdt));
+		else if (copy_from_user(&fdt, image->segment[i].buf, sizeof(fdt)))
 			continue;
 
 		if (fdt_check_header(&fdt))
diff --git a/arch/s390/crypto/aes_s390.c b/arch/s390/crypto/aes_s390.c
index 54c7536f2482..1023e9d43d44 100644
--- a/arch/s390/crypto/aes_s390.c
+++ b/arch/s390/crypto/aes_s390.c
@@ -701,7 +701,7 @@ static inline void _gcm_sg_unmap_and_advance(struct gcm_sg_walk *gw,
 					     unsigned int nbytes)
 {
 	gw->walk_bytes_remain -= nbytes;
-	scatterwalk_unmap(&gw->walk);
+	scatterwalk_unmap(gw->walk_ptr);
 	scatterwalk_advance(&gw->walk, nbytes);
 	scatterwalk_done(&gw->walk, 0, gw->walk_bytes_remain);
 	gw->walk_ptr = NULL;
@@ -776,7 +776,7 @@ static int gcm_out_walk_go(struct gcm_sg_walk *gw, unsigned int minbytesneeded)
 		goto out;
 	}
 
-	scatterwalk_unmap(&gw->walk);
+	scatterwalk_unmap(gw->walk_ptr);
 	gw->walk_ptr = NULL;
 
 	gw->ptr = gw->buf;
diff --git a/arch/s390/kernel/entry.S b/arch/s390/kernel/entry.S
index 01bae1d51113..3bf8aeeec96f 100644
--- a/arch/s390/kernel/entry.S
+++ b/arch/s390/kernel/entry.S
@@ -264,6 +264,10 @@ ENTRY(sie64a)
 	BPEXIT	__SF_SIE_FLAGS(%r15),(_TIF_ISOLATE_BP|_TIF_ISOLATE_BP_GUEST)
 .Lsie_entry:
 	sie	0(%r14)
+# Let the next instruction be NOP to avoid triggering a machine check
+# and handling it in a guest as result of the instruction execution.
+	nopr	7
+.Lsie_leave:
 	BPOFF
 	BPENTER	__SF_SIE_FLAGS(%r15),(_TIF_ISOLATE_BP|_TIF_ISOLATE_BP_GUEST)
 .Lsie_skip:
@@ -563,7 +567,7 @@ ENTRY(mcck_int_handler)
 	jno	.Lmcck_panic
 #if IS_ENABLED(CONFIG_KVM)
 	OUTSIDE	%r9,.Lsie_gmap,.Lsie_done,6f
-	OUTSIDE	%r9,.Lsie_entry,.Lsie_skip,4f
+	OUTSIDE	%r9,.Lsie_entry,.Lsie_leave,4f
 	oi	__LC_CPU_FLAGS+7, _CIF_MCCK_GUEST
 	j	5f
 4:	CHKSTG	.Lmcck_panic
diff --git a/arch/s390/mm/gmap.c b/arch/s390/mm/gmap.c
index dfee0ebb2fac..88f6d923ee45 100644
--- a/arch/s390/mm/gmap.c
+++ b/arch/s390/mm/gmap.c
@@ -2601,6 +2601,18 @@ static int __s390_enable_skey_pte(pte_t *pte, unsigned long addr,
 	return 0;
 }
 
+/*
+ * Give a chance to schedule after setting a key to 256 pages.
+ * We only hold the mm lock, which is a rwsem and the kvm srcu.
+ * Both can sleep.
+ */
+static int __s390_enable_skey_pmd(pmd_t *pmd, unsigned long addr,
+				  unsigned long next, struct mm_walk *walk)
+{
+	cond_resched();
+	return 0;
+}
+
 static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
 				      unsigned long hmask, unsigned long next,
 				      struct mm_walk *walk)
@@ -2623,12 +2635,14 @@ static int __s390_enable_skey_hugetlb(pte_t *pte, unsigned long addr,
 	end = start + HPAGE_SIZE - 1;
 	__storage_key_init_range(start, end);
 	set_bit(PG_arch_1, &page->flags);
+	cond_resched();
 	return 0;
 }
 
 static const struct mm_walk_ops enable_skey_walk_ops = {
 	.hugetlb_entry		= __s390_enable_skey_hugetlb,
 	.pte_entry		= __s390_enable_skey_pte,
+	.pmd_entry		= __s390_enable_skey_pmd,
 };
 
 int s390_enable_skey(void)
diff --git a/arch/um/drivers/chan_kern.c b/arch/um/drivers/chan_kern.c
index 62997055c454..26a702a06515 100644
--- a/arch/um/drivers/chan_kern.c
+++ b/arch/um/drivers/chan_kern.c
@@ -133,7 +133,7 @@ static void line_timer_cb(struct work_struct *work)
 	struct line *line = container_of(work, struct line, task.work);
 
 	if (!line->throttled)
-		chan_interrupt(line, line->driver->read_irq);
+		chan_interrupt(line, line->read_irq);
 }
 
 int enable_chan(struct line *line)
@@ -195,9 +195,9 @@ void free_irqs(void)
 		chan = list_entry(ele, struct chan, free_list);
 
 		if (chan->input && chan->enabled)
-			um_free_irq(chan->line->driver->read_irq, chan);
+			um_free_irq(chan->line->read_irq, chan);
 		if (chan->output && chan->enabled)
-			um_free_irq(chan->line->driver->write_irq, chan);
+			um_free_irq(chan->line->write_irq, chan);
 		chan->enabled = 0;
 	}
 }
@@ -215,9 +215,9 @@ static void close_one_chan(struct chan *chan, int delay_free_irq)
 		spin_unlock_irqrestore(&irqs_to_free_lock, flags);
 	} else {
 		if (chan->input && chan->enabled)
-			um_free_irq(chan->line->driver->read_irq, chan);
+			um_free_irq(chan->line->read_irq, chan);
 		if (chan->output && chan->enabled)
-			um_free_irq(chan->line->driver->write_irq, chan);
+			um_free_irq(chan->line->write_irq, chan);
 		chan->enabled = 0;
 	}
 	if (chan->ops->close != NULL)
diff --git a/arch/um/drivers/line.c b/arch/um/drivers/line.c
index 8febf95da96e..02b0befd6763 100644
--- a/arch/um/drivers/line.c
+++ b/arch/um/drivers/line.c
@@ -139,7 +139,7 @@ static int flush_buffer(struct line *line)
 		count = line->buffer + LINE_BUFSIZE - line->head;
 
 		n = write_chan(line->chan_out, line->head, count,
-			       line->driver->write_irq);
+			       line->write_irq);
 		if (n < 0)
 			return n;
 		if (n == count) {
@@ -156,7 +156,7 @@ static int flush_buffer(struct line *line)
 
 	count = line->tail - line->head;
 	n = write_chan(line->chan_out, line->head, count,
-		       line->driver->write_irq);
+		       line->write_irq);
 
 	if (n < 0)
 		return n;
@@ -195,7 +195,7 @@ int line_write(struct tty_struct *tty, const unsigned char *buf, int len)
 		ret = buffer_data(line, buf, len);
 	else {
 		n = write_chan(line->chan_out, buf, len,
-			       line->driver->write_irq);
+			       line->write_irq);
 		if (n < 0) {
 			ret = n;
 			goto out_up;
@@ -215,7 +215,7 @@ void line_throttle(struct tty_struct *tty)
 {
 	struct line *line = tty->driver_data;
 
-	deactivate_chan(line->chan_in, line->driver->read_irq);
+	deactivate_chan(line->chan_in, line->read_irq);
 	line->throttled = 1;
 }
 
@@ -224,7 +224,7 @@ void line_unthrottle(struct tty_struct *tty)
 	struct line *line = tty->driver_data;
 
 	line->throttled = 0;
-	chan_interrupt(line, line->driver->read_irq);
+	chan_interrupt(line, line->read_irq);
 }
 
 static irqreturn_t line_write_interrupt(int irq, void *data)
@@ -260,19 +260,23 @@ int line_setup_irq(int fd, int input, int output, struct line *line, void *data)
 	int err;
 
 	if (input) {
-		err = um_request_irq(driver->read_irq, fd, IRQ_READ,
-				     line_interrupt, IRQF_SHARED,
+		err = um_request_irq(UM_IRQ_ALLOC, fd, IRQ_READ,
+				     line_interrupt, 0,
 				     driver->read_irq_name, data);
 		if (err < 0)
 			return err;
+
+		line->read_irq = err;
 	}
 
 	if (output) {
-		err = um_request_irq(driver->write_irq, fd, IRQ_WRITE,
-				     line_write_interrupt, IRQF_SHARED,
+		err = um_request_irq(UM_IRQ_ALLOC, fd, IRQ_WRITE,
+				     line_write_interrupt, 0,
 				     driver->write_irq_name, data);
 		if (err < 0)
 			return err;
+
+		line->write_irq = err;
 	}
 
 	return 0;
diff --git a/arch/um/drivers/line.h b/arch/um/drivers/line.h
index bdb16b96e76f..f15be75a3bf3 100644
--- a/arch/um/drivers/line.h
+++ b/arch/um/drivers/line.h
@@ -23,9 +23,7 @@ struct line_driver {
 	const short minor_start;
 	const short type;
 	const short subtype;
-	const int read_irq;
 	const char *read_irq_name;
-	const int write_irq;
 	const char *write_irq_name;
 	struct mc_device mc;
 	struct tty_driver *driver;
@@ -35,6 +33,8 @@ struct line {
 	struct tty_port port;
 	int valid;
 
+	int read_irq, write_irq;
+
 	char *init_str;
 	struct list_head chan_list;
 	struct chan *chan_in, *chan_out;
diff --git a/arch/um/drivers/ssl.c b/arch/um/drivers/ssl.c
index 41eae2e8fb65..8514966778d5 100644
--- a/arch/um/drivers/ssl.c
+++ b/arch/um/drivers/ssl.c
@@ -47,9 +47,7 @@ static struct line_driver driver = {
 	.minor_start 		= 64,
 	.type 		 	= TTY_DRIVER_TYPE_SERIAL,
 	.subtype 	 	= 0,
-	.read_irq 		= SSL_IRQ,
 	.read_irq_name 		= "ssl",
-	.write_irq 		= SSL_WRITE_IRQ,
 	.write_irq_name 	= "ssl-write",
 	.mc  = {
 		.list		= LIST_HEAD_INIT(driver.mc.list),
diff --git a/arch/um/drivers/stdio_console.c b/arch/um/drivers/stdio_console.c
index e8b762f4d8c2..489d5a746ed3 100644
--- a/arch/um/drivers/stdio_console.c
+++ b/arch/um/drivers/stdio_console.c
@@ -53,9 +53,7 @@ static struct line_driver driver = {
 	.minor_start 		= 0,
 	.type 		 	= TTY_DRIVER_TYPE_CONSOLE,
 	.subtype 	 	= SYSTEM_TYPE_CONSOLE,
-	.read_irq 		= CONSOLE_IRQ,
 	.read_irq_name 		= "console",
-	.write_irq 		= CONSOLE_WRITE_IRQ,
 	.write_irq_name 	= "console-write",
 	.mc  = {
 		.list		= LIST_HEAD_INIT(driver.mc.list),
diff --git a/arch/um/include/asm/irq.h b/arch/um/include/asm/irq.h
index e187c789369d..749dfe8512e8 100644
--- a/arch/um/include/asm/irq.h
+++ b/arch/um/include/asm/irq.h
@@ -4,19 +4,15 @@
 
 #define TIMER_IRQ		0
 #define UMN_IRQ			1
-#define CONSOLE_IRQ		2
-#define CONSOLE_WRITE_IRQ	3
-#define UBD_IRQ			4
-#define UM_ETH_IRQ		5
-#define SSL_IRQ			6
-#define SSL_WRITE_IRQ		7
-#define ACCEPT_IRQ		8
-#define MCONSOLE_IRQ		9
-#define WINCH_IRQ		10
-#define SIGIO_WRITE_IRQ 	11
-#define TELNETD_IRQ 		12
-#define XTERM_IRQ 		13
-#define RANDOM_IRQ 		14
+#define UBD_IRQ			2
+#define UM_ETH_IRQ		3
+#define ACCEPT_IRQ		4
+#define MCONSOLE_IRQ		5
+#define WINCH_IRQ		6
+#define SIGIO_WRITE_IRQ 	7
+#define TELNETD_IRQ 		8
+#define XTERM_IRQ 		9
+#define RANDOM_IRQ 		10
 
 #ifdef CONFIG_UML_NET_VECTOR
 
diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index 1261842d006c..49a3b122279e 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -51,7 +51,7 @@ extern const char * const x86_power_flags[32];
 extern const char * const x86_bug_flags[NBUGINTS*32];
 
 #define test_cpu_cap(c, bit)						\
-	 test_bit(bit, (unsigned long *)((c)->x86_capability))
+	 arch_test_bit(bit, (unsigned long *)((c)->x86_capability))
 
 /*
  * There are 32 bits/features in each mask word.  The high bits
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 1c14bcce88f2..729ecf1e546c 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -466,7 +466,7 @@ do {									\
 		       [ptr] "+m" (*_ptr),				\
 		       [old] "+a" (__old)				\
 		     : [new] ltype (__new)				\
-		     : "memory", "cc");					\
+		     : "memory");					\
 	if (unlikely(__err))						\
 		goto label;						\
 	if (unlikely(!success))						\
diff --git a/block/bio.c b/block/bio.c
index 342b1cf5d713..dc6940621d7d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -668,6 +668,7 @@ static void bio_alloc_cache_destroy(struct bio_set *bs)
 		bio_alloc_cache_prune(cache, -1U);
 	}
 	free_percpu(bs->cache);
+	bs->cache = NULL;
 }
 
 /**
@@ -1308,10 +1309,12 @@ void bio_copy_data_iter(struct bio *dst, struct bvec_iter *dst_iter,
 		struct bio_vec src_bv = bio_iter_iovec(src, *src_iter);
 		struct bio_vec dst_bv = bio_iter_iovec(dst, *dst_iter);
 		unsigned int bytes = min(src_bv.bv_len, dst_bv.bv_len);
-		void *src_buf;
+		void *src_buf = bvec_kmap_local(&src_bv);
+		void *dst_buf = bvec_kmap_local(&dst_bv);
 
-		src_buf = bvec_kmap_local(&src_bv);
-		memcpy_to_bvec(&dst_bv, src_buf);
+		memcpy(dst_buf, src_buf, bytes);
+
+		kunmap_local(dst_buf);
 		kunmap_local(src_buf);
 
 		bio_advance_iter_single(src, src_iter, bytes);
diff --git a/block/blk-core.c b/block/blk-core.c
index 779b4a1f66ac..45d750eb2628 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -992,7 +992,7 @@ int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int flags)
 	if (current->plug)
 		blk_flush_plug(current->plug, false);
 
-	if (blk_queue_enter(q, BLK_MQ_REQ_NOWAIT))
+	if (bio_queue_enter(bio))
 		return 0;
 	if (WARN_ON_ONCE(!queue_is_mq(q)))
 		ret = 0;	/* not yet implemented, should not happen */
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0aa20df31e36..f18e1c9c3f4a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -132,7 +132,8 @@ static bool blk_mq_check_inflight(struct request *rq, void *priv,
 {
 	struct mq_inflight *mi = priv;
 
-	if ((!mi->part->bd_partno || rq->part == mi->part) &&
+	if (rq->part && blk_do_io_stat(rq) &&
+	    (!mi->part->bd_partno || rq->part == mi->part) &&
 	    blk_mq_rq_state(rq) == MQ_RQ_IN_FLIGHT)
 		mi->inflight[rq_data_dir(rq)]++;
 
@@ -2114,8 +2115,7 @@ static bool blk_mq_has_sqsched(struct request_queue *q)
  */
 static struct blk_mq_hw_ctx *blk_mq_get_sq_hctx(struct request_queue *q)
 {
-	struct blk_mq_hw_ctx *hctx;
-
+	struct blk_mq_ctx *ctx = blk_mq_get_ctx(q);
 	/*
 	 * If the IO scheduler does not respect hardware queues when
 	 * dispatching, we just don't bother with multiple HW queues and
@@ -2123,8 +2123,8 @@ static struct blk_mq_hw_ctx *blk_mq_get_sq_hctx(struct request_queue *q)
 	 * just causes lock contention inside the scheduler and pointless cache
 	 * bouncing.
 	 */
-	hctx = blk_mq_map_queue_type(q, HCTX_TYPE_DEFAULT,
-				     raw_smp_processor_id());
+	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, 0, ctx);
+
 	if (!blk_mq_hctx_stopped(hctx))
 		return hctx;
 	return NULL;
diff --git a/block/genhd.c b/block/genhd.c
index 9d9d702d0778..c284c1cf3396 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -380,6 +380,8 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 
 	if (disk->flags & (GENHD_FL_NO_PART | GENHD_FL_HIDDEN))
 		return -EINVAL;
+	if (test_bit(GD_SUPPRESS_PART_SCAN, &disk->state))
+		return -EINVAL;
 	if (disk->open_partitions)
 		return -EBUSY;
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 760c0d81d148..a3a547ed0eb0 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2003,16 +2003,16 @@ unsigned int ata_read_log_page(struct ata_device *dev, u8 log,
 	return err_mask;
 }
 
-static bool ata_log_supported(struct ata_device *dev, u8 log)
+static int ata_log_supported(struct ata_device *dev, u8 log)
 {
 	struct ata_port *ap = dev->link->ap;
 
 	if (dev->horkage & ATA_HORKAGE_NO_LOG_DIR)
-		return false;
+		return 0;
 
 	if (ata_read_log_page(dev, ATA_LOG_DIRECTORY, 0, ap->sector_buf, 1))
-		return false;
-	return get_unaligned_le16(&ap->sector_buf[log * 2]) ? true : false;
+		return 0;
+	return get_unaligned_le16(&ap->sector_buf[log * 2]);
 }
 
 static bool ata_identify_page_supported(struct ata_device *dev, u8 page)
@@ -2448,15 +2448,20 @@ static void ata_dev_config_cpr(struct ata_device *dev)
 	struct ata_cpr_log *cpr_log = NULL;
 	u8 *desc, *buf = NULL;
 
-	if (ata_id_major_version(dev->id) < 11 ||
-	    !ata_log_supported(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES))
+	if (ata_id_major_version(dev->id) < 11)
+		goto out;
+
+	buf_len = ata_log_supported(dev, ATA_LOG_CONCURRENT_POSITIONING_RANGES);
+	if (buf_len == 0)
 		goto out;
 
 	/*
 	 * Read the concurrent positioning ranges log (0x47). We can have at
-	 * most 255 32B range descriptors plus a 64B header.
+	 * most 255 32B range descriptors plus a 64B header. This log varies in
+	 * size, so use the size reported in the GPL directory. Reading beyond
+	 * the supported length will result in an error.
 	 */
-	buf_len = (64 + 255 * 32 + 511) & ~511;
+	buf_len <<= 9;
 	buf = kzalloc(buf_len, GFP_KERNEL);
 	if (!buf)
 		goto out;
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index ed8be585a98f..673f95a21eb2 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2119,7 +2119,7 @@ static unsigned int ata_scsiop_inq_b9(struct ata_scsi_args *args, u8 *rbuf)
 
 	/* SCSI Concurrent Positioning Ranges VPD page: SBC-5 rev 1 or later */
 	rbuf[1] = 0xb9;
-	put_unaligned_be16(64 + (int)cpr_log->nr_cpr * 32 - 4, &rbuf[3]);
+	put_unaligned_be16(64 + (int)cpr_log->nr_cpr * 32 - 4, &rbuf[2]);
 
 	for (i = 0; i < cpr_log->nr_cpr; i++, desc += 32) {
 		desc[0] = cpr_log->cpr[i].num;
diff --git a/drivers/ata/libata-transport.c b/drivers/ata/libata-transport.c
index ca129854a88c..c38027887499 100644
--- a/drivers/ata/libata-transport.c
+++ b/drivers/ata/libata-transport.c
@@ -196,7 +196,7 @@ static struct {
 	{ XFER_PIO_0,			"XFER_PIO_0" },
 	{ XFER_PIO_SLOW,		"XFER_PIO_SLOW" }
 };
-ata_bitfield_name_match(xfer,ata_xfer_names)
+ata_bitfield_name_search(xfer, ata_xfer_names)
 
 /*
  * ATA Port attributes
diff --git a/drivers/ata/pata_octeon_cf.c b/drivers/ata/pata_octeon_cf.c
index 05c2ab375756..a2abf6c9a085 100644
--- a/drivers/ata/pata_octeon_cf.c
+++ b/drivers/ata/pata_octeon_cf.c
@@ -856,12 +856,14 @@ static int octeon_cf_probe(struct platform_device *pdev)
 				int i;
 				res_dma = platform_get_resource(dma_dev, IORESOURCE_MEM, 0);
 				if (!res_dma) {
+					put_device(&dma_dev->dev);
 					of_node_put(dma_node);
 					return -EINVAL;
 				}
 				cf_port->dma_base = (u64)devm_ioremap(&pdev->dev, res_dma->start,
 									 resource_size(res_dma));
 				if (!cf_port->dma_base) {
+					put_device(&dma_dev->dev);
 					of_node_put(dma_node);
 					return -EINVAL;
 				}
@@ -871,6 +873,7 @@ static int octeon_cf_probe(struct platform_device *pdev)
 					irq = i;
 					irq_handler = octeon_cf_interrupt;
 				}
+				put_device(&dma_dev->dev);
 			}
 			of_node_put(dma_node);
 		}
diff --git a/drivers/base/bus.c b/drivers/base/bus.c
index 97936ec49bde..7ca47e5b3c1f 100644
--- a/drivers/base/bus.c
+++ b/drivers/base/bus.c
@@ -617,7 +617,7 @@ int bus_add_driver(struct device_driver *drv)
 	if (drv->bus->p->drivers_autoprobe) {
 		error = driver_attach(drv);
 		if (error)
-			goto out_unregister;
+			goto out_del_list;
 	}
 	module_add_driver(drv->owner, drv);
 
@@ -644,6 +644,8 @@ int bus_add_driver(struct device_driver *drv)
 
 	return 0;
 
+out_del_list:
+	klist_del(&priv->knode_bus);
 out_unregister:
 	kobject_put(&priv->kobj);
 	/* drv->p is freed in driver_release()  */
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 7e079fa3795b..86fd2ea35656 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -257,7 +257,6 @@ DEFINE_SHOW_ATTRIBUTE(deferred_devs);
 
 int driver_deferred_probe_timeout;
 EXPORT_SYMBOL_GPL(driver_deferred_probe_timeout);
-static DECLARE_WAIT_QUEUE_HEAD(probe_timeout_waitqueue);
 
 static int __init deferred_probe_timeout_setup(char *str)
 {
@@ -312,7 +311,6 @@ static void deferred_probe_timeout_work_func(struct work_struct *work)
 	list_for_each_entry(p, &deferred_probe_pending_list, deferred_probe)
 		dev_info(p->device, "deferred probe pending\n");
 	mutex_unlock(&deferred_probe_mutex);
-	wake_up_all(&probe_timeout_waitqueue);
 }
 static DECLARE_DELAYED_WORK(deferred_probe_timeout_work, deferred_probe_timeout_work_func);
 
@@ -720,9 +718,6 @@ int driver_probe_done(void)
  */
 void wait_for_device_probe(void)
 {
-	/* wait for probe timeout */
-	wait_event(probe_timeout_waitqueue, !driver_deferred_probe_timeout);
-
 	/* wait for the deferred probe workqueue to finish */
 	flush_work(&deferred_probe_work);
 
@@ -945,6 +940,7 @@ static void __device_attach_async_helper(void *_dev, async_cookie_t cookie)
 static int __device_attach(struct device *dev, bool allow_async)
 {
 	int ret = 0;
+	bool async = false;
 
 	device_lock(dev);
 	if (dev->p->dead) {
@@ -983,7 +979,7 @@ static int __device_attach(struct device *dev, bool allow_async)
 			 */
 			dev_dbg(dev, "scheduling asynchronous probe\n");
 			get_device(dev);
-			async_schedule_dev(__device_attach_async_helper, dev);
+			async = true;
 		} else {
 			pm_request_idle(dev);
 		}
@@ -993,6 +989,8 @@ static int __device_attach(struct device *dev, bool allow_async)
 	}
 out_unlock:
 	device_unlock(dev);
+	if (async)
+		async_schedule_dev(__device_attach_async_helper, dev);
 	return ret;
 }
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index d46a3d5d0c2e..3411d3c0a5b0 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1067,7 +1067,7 @@ static int loop_configure(struct loop_device *lo, fmode_t mode,
 		lo->lo_flags |= LO_FLAGS_PARTSCAN;
 	partscan = lo->lo_flags & LO_FLAGS_PARTSCAN;
 	if (partscan)
-		lo->lo_disk->flags &= ~GENHD_FL_NO_PART;
+		clear_bit(GD_SUPPRESS_PART_SCAN, &lo->lo_disk->state);
 
 	loop_global_unlock(lo, is_loop);
 	if (partscan)
@@ -1186,7 +1186,7 @@ static void __loop_clr_fd(struct loop_device *lo, bool release)
 	 */
 	lo->lo_flags = 0;
 	if (!part_shift)
-		lo->lo_disk->flags |= GENHD_FL_NO_PART;
+		set_bit(GD_SUPPRESS_PART_SCAN, &lo->lo_disk->state);
 	mutex_lock(&lo->lo_mutex);
 	lo->lo_state = Lo_unbound;
 	mutex_unlock(&lo->lo_mutex);
@@ -1296,7 +1296,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 
 	if (!err && (lo->lo_flags & LO_FLAGS_PARTSCAN) &&
 	     !(prev_lo_flags & LO_FLAGS_PARTSCAN)) {
-		lo->lo_disk->flags &= ~GENHD_FL_NO_PART;
+		clear_bit(GD_SUPPRESS_PART_SCAN, &lo->lo_disk->state);
 		partscan = true;
 	}
 out_unlock:
@@ -2028,7 +2028,7 @@ static int loop_add(int i)
 	 * userspace tools. Parameters like this in general should be avoided.
 	 */
 	if (!part_shift)
-		disk->flags |= GENHD_FL_NO_PART;
+		set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
 	atomic_set(&lo->lo_refcnt, 0);
 	mutex_init(&lo->lo_mutex);
 	lo->lo_number		= i;
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 284557041336..151264a4be36 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -404,13 +404,14 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req,
 	if (!mutex_trylock(&cmd->lock))
 		return BLK_EH_RESET_TIMER;
 
-	if (!__test_and_clear_bit(NBD_CMD_INFLIGHT, &cmd->flags)) {
+	if (!test_bit(NBD_CMD_INFLIGHT, &cmd->flags)) {
 		mutex_unlock(&cmd->lock);
 		return BLK_EH_DONE;
 	}
 
 	if (!refcount_inc_not_zero(&nbd->config_refs)) {
 		cmd->status = BLK_STS_TIMEOUT;
+		__clear_bit(NBD_CMD_INFLIGHT, &cmd->flags);
 		mutex_unlock(&cmd->lock);
 		goto done;
 	}
@@ -479,6 +480,7 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req,
 	dev_err_ratelimited(nbd_to_dev(nbd), "Connection timed out\n");
 	set_bit(NBD_RT_TIMEDOUT, &config->runtime_flags);
 	cmd->status = BLK_STS_IOERR;
+	__clear_bit(NBD_CMD_INFLIGHT, &cmd->flags);
 	mutex_unlock(&cmd->lock);
 	sock_shutdown(nbd);
 	nbd_config_put(nbd);
@@ -746,7 +748,7 @@ static struct nbd_cmd *nbd_handle_reply(struct nbd_device *nbd, int index,
 	cmd = blk_mq_rq_to_pdu(req);
 
 	mutex_lock(&cmd->lock);
-	if (!__test_and_clear_bit(NBD_CMD_INFLIGHT, &cmd->flags)) {
+	if (!test_bit(NBD_CMD_INFLIGHT, &cmd->flags)) {
 		dev_err(disk_to_dev(nbd->disk), "Suspicious reply %d (status %u flags %lu)",
 			tag, cmd->status, cmd->flags);
 		ret = -ENOENT;
@@ -855,8 +857,16 @@ static void recv_work(struct work_struct *work)
 		}
 
 		rq = blk_mq_rq_from_pdu(cmd);
-		if (likely(!blk_should_fake_timeout(rq->q)))
-			blk_mq_complete_request(rq);
+		if (likely(!blk_should_fake_timeout(rq->q))) {
+			bool complete;
+
+			mutex_lock(&cmd->lock);
+			complete = __test_and_clear_bit(NBD_CMD_INFLIGHT,
+							&cmd->flags);
+			mutex_unlock(&cmd->lock);
+			if (complete)
+				blk_mq_complete_request(rq);
+		}
 		percpu_ref_put(&q->q_usage_counter);
 	}
 
@@ -1424,7 +1434,7 @@ static int nbd_start_device_ioctl(struct nbd_device *nbd, struct block_device *b
 static void nbd_clear_sock_ioctl(struct nbd_device *nbd,
 				 struct block_device *bdev)
 {
-	sock_shutdown(nbd);
+	nbd_clear_sock(nbd);
 	__invalidate_device(bdev, true);
 	nbd_bdev_reset(bdev);
 	if (test_and_clear_bit(NBD_RT_HAS_CONFIG_REF,
@@ -1523,15 +1533,20 @@ static struct nbd_config *nbd_alloc_config(void)
 {
 	struct nbd_config *config;
 
+	if (!try_module_get(THIS_MODULE))
+		return ERR_PTR(-ENODEV);
+
 	config = kzalloc(sizeof(struct nbd_config), GFP_NOFS);
-	if (!config)
-		return NULL;
+	if (!config) {
+		module_put(THIS_MODULE);
+		return ERR_PTR(-ENOMEM);
+	}
+
 	atomic_set(&config->recv_threads, 0);
 	init_waitqueue_head(&config->recv_wq);
 	init_waitqueue_head(&config->conn_wait);
 	config->blksize_bits = NBD_DEF_BLKSIZE_BITS;
 	atomic_set(&config->live_connections, 0);
-	try_module_get(THIS_MODULE);
 	return config;
 }
 
@@ -1558,12 +1573,13 @@ static int nbd_open(struct block_device *bdev, fmode_t mode)
 			mutex_unlock(&nbd->config_lock);
 			goto out;
 		}
-		config = nbd->config = nbd_alloc_config();
-		if (!config) {
-			ret = -ENOMEM;
+		config = nbd_alloc_config();
+		if (IS_ERR(config)) {
+			ret = PTR_ERR(config);
 			mutex_unlock(&nbd->config_lock);
 			goto out;
 		}
+		nbd->config = config;
 		refcount_set(&nbd->config_refs, 1);
 		refcount_inc(&nbd->refs);
 		mutex_unlock(&nbd->config_lock);
@@ -1970,13 +1986,14 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
 		nbd_put(nbd);
 		return -EINVAL;
 	}
-	config = nbd->config = nbd_alloc_config();
-	if (!nbd->config) {
+	config = nbd_alloc_config();
+	if (IS_ERR(config)) {
 		mutex_unlock(&nbd->config_lock);
 		nbd_put(nbd);
 		printk(KERN_ERR "nbd: couldn't allocate config\n");
-		return -ENOMEM;
+		return PTR_ERR(config);
 	}
+	nbd->config = config;
 	refcount_set(&nbd->config_refs, 1);
 	set_bit(NBD_RT_BOUND, &config->runtime_flags);
 
@@ -2534,6 +2551,12 @@ static void __exit nbd_cleanup(void)
 	struct nbd_device *nbd;
 	LIST_HEAD(del_list);
 
+	/*
+	 * Unregister netlink interface prior to waiting
+	 * for the completion of netlink commands.
+	 */
+	genl_unregister_family(&nbd_genl_family);
+
 	nbd_dbg_close();
 
 	mutex_lock(&nbd_index_mutex);
@@ -2543,6 +2566,9 @@ static void __exit nbd_cleanup(void)
 	while (!list_empty(&del_list)) {
 		nbd = list_first_entry(&del_list, struct nbd_device, list);
 		list_del_init(&nbd->list);
+		if (refcount_read(&nbd->config_refs))
+			printk(KERN_ERR "nbd: possibly leaking nbd_config (ref %d)\n",
+					refcount_read(&nbd->config_refs));
 		if (refcount_read(&nbd->refs) != 1)
 			printk(KERN_ERR "nbd: possibly leaking a device\n");
 		nbd_put(nbd);
@@ -2552,7 +2578,6 @@ static void __exit nbd_cleanup(void)
 	destroy_workqueue(nbd_del_wq);
 
 	idr_destroy(&nbd_index_idr);
-	genl_unregister_family(&nbd_genl_family);
 	unregister_blkdev(NBD_MAJOR, "nbd");
 }
 
diff --git a/drivers/bus/ti-sysc.c b/drivers/bus/ti-sysc.c
index 7a1b1f9e4933..70d00cea9d22 100644
--- a/drivers/bus/ti-sysc.c
+++ b/drivers/bus/ti-sysc.c
@@ -3395,7 +3395,9 @@ static int sysc_remove(struct platform_device *pdev)
 	struct sysc *ddata = platform_get_drvdata(pdev);
 	int error;
 
-	cancel_delayed_work_sync(&ddata->idle_work);
+	/* Device can still be enabled, see deferred idle quirk in probe */
+	if (cancel_delayed_work_sync(&ddata->idle_work))
+		ti_sysc_idle(&ddata->idle_work.work);
 
 	error = pm_runtime_resume_and_get(ddata->dev);
 	if (error < 0) {
diff --git a/drivers/char/hw_random/virtio-rng.c b/drivers/char/hw_random/virtio-rng.c
index e856df7e285c..a6f3a8a2aca6 100644
--- a/drivers/char/hw_random/virtio-rng.c
+++ b/drivers/char/hw_random/virtio-rng.c
@@ -159,6 +159,8 @@ static int probe_common(struct virtio_device *vdev)
 		goto err_find;
 	}
 
+	virtio_device_ready(vdev);
+
 	/* we always have a pending entropy request */
 	request_entropy(vi);
 
diff --git a/drivers/char/random.c b/drivers/char/random.c
index d6aa4b57d985..634b980c47b7 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -789,8 +789,8 @@ static void __cold _credit_init_bits(size_t bits)
  *
  **********************************************************************/
 
-static bool trust_cpu __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
-static bool trust_bootloader __ro_after_init = IS_ENABLED(CONFIG_RANDOM_TRUST_BOOTLOADER);
+static bool trust_cpu __initdata = IS_ENABLED(CONFIG_RANDOM_TRUST_CPU);
+static bool trust_bootloader __initdata = IS_ENABLED(CONFIG_RANDOM_TRUST_BOOTLOADER);
 static int __init parse_trust_cpu(char *arg)
 {
 	return kstrtobool(arg, &trust_cpu);
@@ -813,7 +813,7 @@ early_param("random.trust_bootloader", parse_trust_bootloader);
 int __init random_init(const char *command_line)
 {
 	ktime_t now = ktime_get_real();
-	unsigned int i, arch_bytes;
+	unsigned int i, arch_bits;
 	unsigned long entropy;
 
 #if defined(LATENT_ENTROPY_PLUGIN)
@@ -821,12 +821,12 @@ int __init random_init(const char *command_line)
 	_mix_pool_bytes(compiletime_seed, sizeof(compiletime_seed));
 #endif
 
-	for (i = 0, arch_bytes = BLAKE2S_BLOCK_SIZE;
+	for (i = 0, arch_bits = BLAKE2S_BLOCK_SIZE * 8;
 	     i < BLAKE2S_BLOCK_SIZE; i += sizeof(entropy)) {
 		if (!arch_get_random_seed_long_early(&entropy) &&
 		    !arch_get_random_long_early(&entropy)) {
 			entropy = random_get_entropy();
-			arch_bytes -= sizeof(entropy);
+			arch_bits -= sizeof(entropy) * 8;
 		}
 		_mix_pool_bytes(&entropy, sizeof(entropy));
 	}
@@ -838,7 +838,7 @@ int __init random_init(const char *command_line)
 	if (crng_ready())
 		crng_reseed();
 	else if (trust_cpu)
-		credit_init_bits(arch_bytes * 8);
+		_credit_init_bits(arch_bits);
 
 	return 0;
 }
@@ -886,13 +886,12 @@ EXPORT_SYMBOL_GPL(add_hwgenerator_randomness);
  * Handle random seed passed by bootloader, and credit it if
  * CONFIG_RANDOM_TRUST_BOOTLOADER is set.
  */
-void __cold add_bootloader_randomness(const void *buf, size_t len)
+void __init add_bootloader_randomness(const void *buf, size_t len)
 {
 	mix_pool_bytes(buf, len);
 	if (trust_bootloader)
 		credit_init_bits(len * 8);
 }
-EXPORT_SYMBOL_GPL(add_bootloader_randomness);
 
 struct fast_pool {
 	struct work_struct mix;
diff --git a/drivers/char/xillybus/xillyusb.c b/drivers/char/xillybus/xillyusb.c
index dc3551796e5e..39bcbfd908b4 100644
--- a/drivers/char/xillybus/xillyusb.c
+++ b/drivers/char/xillybus/xillyusb.c
@@ -549,6 +549,7 @@ static void cleanup_dev(struct kref *kref)
 	if (xdev->workq)
 		destroy_workqueue(xdev->workq);
 
+	usb_put_dev(xdev->udev);
 	kfree(xdev->channels); /* Argument may be NULL, and that's fine */
 	kfree(xdev);
 }
diff --git a/drivers/clocksource/timer-oxnas-rps.c b/drivers/clocksource/timer-oxnas-rps.c
index 56c0cc32d0ac..d514b44e67dd 100644
--- a/drivers/clocksource/timer-oxnas-rps.c
+++ b/drivers/clocksource/timer-oxnas-rps.c
@@ -236,7 +236,7 @@ static int __init oxnas_rps_timer_init(struct device_node *np)
 	}
 
 	rps->irq = irq_of_parse_and_map(np, 0);
-	if (rps->irq < 0) {
+	if (!rps->irq) {
 		ret = -EINVAL;
 		goto err_iomap;
 	}
diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index 1767f8bf2013..593d5a957b69 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -34,7 +34,7 @@ static int riscv_clock_next_event(unsigned long delta,
 static unsigned int riscv_clock_event_irq;
 static DEFINE_PER_CPU(struct clock_event_device, riscv_clock_event) = {
 	.name			= "riscv_timer_clockevent",
-	.features		= CLOCK_EVT_FEAT_ONESHOT,
+	.features		= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP,
 	.rating			= 100,
 	.set_next_event		= riscv_clock_next_event,
 };
diff --git a/drivers/clocksource/timer-sp804.c b/drivers/clocksource/timer-sp804.c
index 401d592e85f5..e6a87f4af2b5 100644
--- a/drivers/clocksource/timer-sp804.c
+++ b/drivers/clocksource/timer-sp804.c
@@ -259,6 +259,11 @@ static int __init sp804_of_init(struct device_node *np, struct sp804_timer *time
 	struct clk *clk1, *clk2;
 	const char *name = of_get_property(np, "compatible", NULL);
 
+	if (initialized) {
+		pr_debug("%pOF: skipping further SP804 timer device\n", np);
+		return 0;
+	}
+
 	base = of_iomap(np, 0);
 	if (!base)
 		return -ENXIO;
@@ -270,11 +275,6 @@ static int __init sp804_of_init(struct device_node *np, struct sp804_timer *time
 	writel(0, timer1_base + timer->ctrl);
 	writel(0, timer2_base + timer->ctrl);
 
-	if (initialized || !of_device_is_available(np)) {
-		ret = -EINVAL;
-		goto err;
-	}
-
 	clk1 = of_clk_get(np, 0);
 	if (IS_ERR(clk1))
 		clk1 = NULL;
diff --git a/drivers/dma/idxd/dma.c b/drivers/dma/idxd/dma.c
index bfff59617d04..f9ed55011775 100644
--- a/drivers/dma/idxd/dma.c
+++ b/drivers/dma/idxd/dma.c
@@ -87,6 +87,27 @@ static inline void idxd_prep_desc_common(struct idxd_wq *wq,
 	hw->completion_addr = compl;
 }
 
+static struct dma_async_tx_descriptor *
+idxd_dma_prep_interrupt(struct dma_chan *c, unsigned long flags)
+{
+	struct idxd_wq *wq = to_idxd_wq(c);
+	u32 desc_flags;
+	struct idxd_desc *desc;
+
+	if (wq->state != IDXD_WQ_ENABLED)
+		return NULL;
+
+	op_flag_setup(flags, &desc_flags);
+	desc = idxd_alloc_desc(wq, IDXD_OP_BLOCK);
+	if (IS_ERR(desc))
+		return NULL;
+
+	idxd_prep_desc_common(wq, desc->hw, DSA_OPCODE_NOOP,
+			      0, 0, 0, desc->compl_dma, desc_flags);
+	desc->txd.flags = flags;
+	return &desc->txd;
+}
+
 static struct dma_async_tx_descriptor *
 idxd_dma_submit_memcpy(struct dma_chan *c, dma_addr_t dma_dest,
 		       dma_addr_t dma_src, size_t len, unsigned long flags)
@@ -193,10 +214,12 @@ int idxd_register_dma_device(struct idxd_device *idxd)
 	INIT_LIST_HEAD(&dma->channels);
 	dma->dev = dev;
 
+	dma_cap_set(DMA_INTERRUPT, dma->cap_mask);
 	dma_cap_set(DMA_PRIVATE, dma->cap_mask);
 	dma_cap_set(DMA_COMPLETION_NO_ORDER, dma->cap_mask);
 	dma->device_release = idxd_dma_release;
 
+	dma->device_prep_dma_interrupt = idxd_dma_prep_interrupt;
 	if (idxd->hw.opcap.bits[0] & IDXD_OPCAP_MEMMOVE) {
 		dma_cap_set(DMA_MEMCPY, dma->cap_mask);
 		dma->device_prep_dma_memcpy = idxd_dma_submit_memcpy;
diff --git a/drivers/dma/xilinx/zynqmp_dma.c b/drivers/dma/xilinx/zynqmp_dma.c
index 7aa63b652027..3ffa7f37c701 100644
--- a/drivers/dma/xilinx/zynqmp_dma.c
+++ b/drivers/dma/xilinx/zynqmp_dma.c
@@ -229,7 +229,7 @@ struct zynqmp_dma_chan {
 	bool is_dmacoherent;
 	struct tasklet_struct tasklet;
 	bool idle;
-	u32 desc_size;
+	size_t desc_size;
 	bool err;
 	u32 bus_width;
 	u32 src_burst_len;
@@ -486,7 +486,8 @@ static int zynqmp_dma_alloc_chan_resources(struct dma_chan *dchan)
 	}
 
 	chan->desc_pool_v = dma_alloc_coherent(chan->dev,
-					       (2 * chan->desc_size * ZYNQMP_DMA_NUM_DESCS),
+					       (2 * ZYNQMP_DMA_DESC_SIZE(chan) *
+					       ZYNQMP_DMA_NUM_DESCS),
 					       &chan->desc_pool_p, GFP_KERNEL);
 	if (!chan->desc_pool_v)
 		return -ENOMEM;
diff --git a/drivers/extcon/extcon-axp288.c b/drivers/extcon/extcon-axp288.c
index 7c6d5857ff25..180be768c215 100644
--- a/drivers/extcon/extcon-axp288.c
+++ b/drivers/extcon/extcon-axp288.c
@@ -394,8 +394,8 @@ static int axp288_extcon_probe(struct platform_device *pdev)
 		if (adev) {
 			info->id_extcon = extcon_get_extcon_dev(acpi_dev_name(adev));
 			put_device(&adev->dev);
-			if (!info->id_extcon)
-				return -EPROBE_DEFER;
+			if (IS_ERR(info->id_extcon))
+				return PTR_ERR(info->id_extcon);
 
 			dev_info(dev, "controlling USB role\n");
 		} else {
diff --git a/drivers/extcon/extcon-ptn5150.c b/drivers/extcon/extcon-ptn5150.c
index 5b9a3cf8df26..2a7874108df8 100644
--- a/drivers/extcon/extcon-ptn5150.c
+++ b/drivers/extcon/extcon-ptn5150.c
@@ -194,6 +194,13 @@ static int ptn5150_init_dev_type(struct ptn5150_info *info)
 	return 0;
 }
 
+static void ptn5150_work_sync_and_put(void *data)
+{
+	struct ptn5150_info *info = data;
+
+	cancel_work_sync(&info->irq_work);
+}
+
 static int ptn5150_i2c_probe(struct i2c_client *i2c)
 {
 	struct device *dev = &i2c->dev;
@@ -284,6 +291,10 @@ static int ptn5150_i2c_probe(struct i2c_client *i2c)
 	if (ret)
 		return -EINVAL;
 
+	ret = devm_add_action_or_reset(dev, ptn5150_work_sync_and_put, info);
+	if (ret)
+		return ret;
+
 	/*
 	 * Update current extcon state if for example OTG connection was there
 	 * before the probe
diff --git a/drivers/extcon/extcon.c b/drivers/extcon/extcon.c
index a09e704fd0fa..97e35c32bfa5 100644
--- a/drivers/extcon/extcon.c
+++ b/drivers/extcon/extcon.c
@@ -851,6 +851,8 @@ EXPORT_SYMBOL_GPL(extcon_set_property_capability);
  * @extcon_name:	the extcon name provided with extcon_dev_register()
  *
  * Return the pointer of extcon device if success or ERR_PTR(err) if fail.
+ * NOTE: This function returns -EPROBE_DEFER so it may only be called from
+ * probe() functions.
  */
 struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name)
 {
@@ -864,7 +866,7 @@ struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name)
 		if (!strcmp(sd->name, extcon_name))
 			goto out;
 	}
-	sd = NULL;
+	sd = ERR_PTR(-EPROBE_DEFER);
 out:
 	mutex_unlock(&extcon_dev_list_lock);
 	return sd;
@@ -1218,19 +1220,14 @@ int extcon_dev_register(struct extcon_dev *edev)
 		edev->dev.type = &edev->extcon_dev_type;
 	}
 
-	ret = device_register(&edev->dev);
-	if (ret) {
-		put_device(&edev->dev);
-		goto err_dev;
-	}
-
 	spin_lock_init(&edev->lock);
-	edev->nh = devm_kcalloc(&edev->dev, edev->max_supported,
-				sizeof(*edev->nh), GFP_KERNEL);
-	if (!edev->nh) {
-		ret = -ENOMEM;
-		device_unregister(&edev->dev);
-		goto err_dev;
+	if (edev->max_supported) {
+		edev->nh = kcalloc(edev->max_supported, sizeof(*edev->nh),
+				GFP_KERNEL);
+		if (!edev->nh) {
+			ret = -ENOMEM;
+			goto err_alloc_nh;
+		}
 	}
 
 	for (index = 0; index < edev->max_supported; index++)
@@ -1241,6 +1238,12 @@ int extcon_dev_register(struct extcon_dev *edev)
 	dev_set_drvdata(&edev->dev, edev);
 	edev->state = 0;
 
+	ret = device_register(&edev->dev);
+	if (ret) {
+		put_device(&edev->dev);
+		goto err_dev;
+	}
+
 	mutex_lock(&extcon_dev_list_lock);
 	list_add(&edev->entry, &extcon_dev_list);
 	mutex_unlock(&extcon_dev_list_lock);
@@ -1248,6 +1251,9 @@ int extcon_dev_register(struct extcon_dev *edev)
 	return 0;
 
 err_dev:
+	if (edev->max_supported)
+		kfree(edev->nh);
+err_alloc_nh:
 	if (edev->max_supported)
 		kfree(edev->extcon_dev_type.groups);
 err_alloc_groups:
@@ -1308,6 +1314,7 @@ void extcon_dev_unregister(struct extcon_dev *edev)
 	if (edev->max_supported) {
 		kfree(edev->extcon_dev_type.groups);
 		kfree(edev->cables);
+		kfree(edev->nh);
 	}
 
 	put_device(&edev->dev);
diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index 3a353776bd34..66727ad3361b 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -604,7 +604,7 @@ static void __init dmi_sysfs_register_handle(const struct dmi_header *dh,
 				    "%d-%d", dh->type, entry->instance);
 
 	if (*ret) {
-		kfree(entry);
+		kobject_put(&entry->kobj);
 		return;
 	}
 
diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index c4bf934e3553..33ab24cfd600 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -941,17 +941,17 @@ EXPORT_SYMBOL_GPL(stratix10_svc_allocate_memory);
 void stratix10_svc_free_memory(struct stratix10_svc_chan *chan, void *kaddr)
 {
 	struct stratix10_svc_data_mem *pmem;
-	size_t size = 0;
 
 	list_for_each_entry(pmem, &svc_data_mem, node)
 		if (pmem->vaddr == kaddr) {
-			size = pmem->size;
-			break;
+			gen_pool_free(chan->ctrl->genpool,
+				       (unsigned long)kaddr, pmem->size);
+			pmem->vaddr = NULL;
+			list_del(&pmem->node);
+			return;
 		}
 
-	gen_pool_free(chan->ctrl->genpool, (unsigned long)kaddr, size);
-	pmem->vaddr = NULL;
-	list_del(&pmem->node);
+	list_del(&svc_data_mem);
 }
 EXPORT_SYMBOL_GPL(stratix10_svc_free_memory);
 
diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index 8726921a1129..33683295a0bf 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -1108,20 +1108,21 @@ static int pca953x_regcache_sync(struct device *dev)
 {
 	struct pca953x_chip *chip = dev_get_drvdata(dev);
 	int ret;
+	u8 regaddr;
 
 	/*
 	 * The ordering between direction and output is important,
 	 * sync these registers first and only then sync the rest.
 	 */
-	ret = regcache_sync_region(chip->regmap, chip->regs->direction,
-				   chip->regs->direction + NBANK(chip));
+	regaddr = pca953x_recalc_addr(chip, chip->regs->direction, 0);
+	ret = regcache_sync_region(chip->regmap, regaddr, regaddr + NBANK(chip));
 	if (ret) {
 		dev_err(dev, "Failed to sync GPIO dir registers: %d\n", ret);
 		return ret;
 	}
 
-	ret = regcache_sync_region(chip->regmap, chip->regs->output,
-				   chip->regs->output + NBANK(chip));
+	regaddr = pca953x_recalc_addr(chip, chip->regs->output, 0);
+	ret = regcache_sync_region(chip->regmap, regaddr, regaddr + NBANK(chip));
 	if (ret) {
 		dev_err(dev, "Failed to sync GPIO out registers: %d\n", ret);
 		return ret;
@@ -1129,16 +1130,18 @@ static int pca953x_regcache_sync(struct device *dev)
 
 #ifdef CONFIG_GPIO_PCA953X_IRQ
 	if (chip->driver_data & PCA_PCAL) {
-		ret = regcache_sync_region(chip->regmap, PCAL953X_IN_LATCH,
-					   PCAL953X_IN_LATCH + NBANK(chip));
+		regaddr = pca953x_recalc_addr(chip, PCAL953X_IN_LATCH, 0);
+		ret = regcache_sync_region(chip->regmap, regaddr,
+					   regaddr + NBANK(chip));
 		if (ret) {
 			dev_err(dev, "Failed to sync INT latch registers: %d\n",
 				ret);
 			return ret;
 		}
 
-		ret = regcache_sync_region(chip->regmap, PCAL953X_INT_MASK,
-					   PCAL953X_INT_MASK + NBANK(chip));
+		regaddr = pca953x_recalc_addr(chip, PCAL953X_INT_MASK, 0);
+		ret = regcache_sync_region(chip->regmap, regaddr,
+					   regaddr + NBANK(chip));
 		if (ret) {
 			dev_err(dev, "Failed to sync INT mask registers: %d\n",
 				ret);
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
index 299de1d131d8..5ac1a43a16b4 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -535,6 +535,10 @@ void jpeg_v2_0_dec_ring_emit_ib(struct amdgpu_ring *ring,
 {
 	unsigned vmid = AMDGPU_JOB_GET_VMID(job);
 
+	amdgpu_ring_write(ring,	PACKETJ(mmUVD_JPEG_IH_CTRL_INTERNAL_OFFSET,
+		0, 0, PACKETJ_TYPE0));
+	amdgpu_ring_write(ring, (vmid << JPEG_IH_CTRL__IH_VMID__SHIFT));
+
 	amdgpu_ring_write(ring, PACKETJ(mmUVD_LMI_JRBC_IB_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
 	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
@@ -768,7 +772,7 @@ static const struct amdgpu_ring_funcs jpeg_v2_0_dec_ring_vm_funcs = {
 		8 + /* jpeg_v2_0_dec_ring_emit_vm_flush */
 		18 + 18 + /* jpeg_v2_0_dec_ring_emit_fence x2 vm fence */
 		8 + 16,
-	.emit_ib_size = 22, /* jpeg_v2_0_dec_ring_emit_ib */
+	.emit_ib_size = 24, /* jpeg_v2_0_dec_ring_emit_ib */
 	.emit_ib = jpeg_v2_0_dec_ring_emit_ib,
 	.emit_fence = jpeg_v2_0_dec_ring_emit_fence,
 	.emit_vm_flush = jpeg_v2_0_dec_ring_emit_vm_flush,
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h
index 1a03baa59755..654e43e83e2c 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h
@@ -41,6 +41,7 @@
 #define mmUVD_JRBC_RB_REF_DATA_INTERNAL_OFFSET				0x4084
 #define mmUVD_JRBC_STATUS_INTERNAL_OFFSET				0x4089
 #define mmUVD_JPEG_PITCH_INTERNAL_OFFSET				0x401f
+#define mmUVD_JPEG_IH_CTRL_INTERNAL_OFFSET				0x4149
 
 #define JRBC_DEC_EXTERNAL_REG_WRITE_ADDR				0x18000
 
diff --git a/drivers/gpu/drm/amd/amdgpu/nv.c b/drivers/gpu/drm/amd/amdgpu/nv.c
index 2ec1ffb36b1f..07fc591a6565 100644
--- a/drivers/gpu/drm/amd/amdgpu/nv.c
+++ b/drivers/gpu/drm/amd/amdgpu/nv.c
@@ -170,6 +170,7 @@ static const struct amdgpu_video_codec_info yc_video_codecs_decode_array[] = {
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_HEVC, 8192, 4352, 186)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_VP9, 8192, 4352, 0)},
 	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_JPEG, 4096, 4096, 0)},
+	{codec_info_build(AMDGPU_INFO_VIDEO_CAPS_CODEC_IDX_AV1, 8192, 4352, 0)},
 };
 
 static const struct amdgpu_video_codecs yc_video_codecs_decode = {
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 24db2297857b..edb5e72aeb66 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -767,7 +767,7 @@ static void dm_dmub_outbox1_low_irq(void *interrupt_params)
 
 		do {
 			dc_stat_get_dmub_notification(adev->dm.dc, &notify);
-			if (notify.type > ARRAY_SIZE(dm->dmub_thread_offload)) {
+			if (notify.type >= ARRAY_SIZE(dm->dmub_thread_offload)) {
 				DRM_ERROR("DM: notify type %d invalid!", notify.type);
 				continue;
 			}
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
index 2c7eb982eabc..054823d12403 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
@@ -1013,9 +1013,12 @@ static bool get_pixel_clk_frequency_100hz(
 			 * not be programmed equal to DPREFCLK
 			 */
 			modulo_hz = REG_READ(MODULO[inst]);
-			*pixel_clk_khz = div_u64((uint64_t)clock_hz*
-				clock_source->ctx->dc->clk_mgr->dprefclk_khz*10,
-				modulo_hz);
+			if (modulo_hz)
+				*pixel_clk_khz = div_u64((uint64_t)clock_hz*
+					clock_source->ctx->dc->clk_mgr->dprefclk_khz*10,
+					modulo_hz);
+			else
+				*pixel_clk_khz = 0;
 		} else {
 			/* NOTE: There is agreement with VBIOS here that MODULO is
 			 * programmed equal to DPREFCLK, in which case PHASE will be
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
index 4e9e2cf39859..5fcbec9dd45d 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c
@@ -777,7 +777,7 @@ int smu_v11_0_set_allowed_mask(struct smu_context *smu)
 		goto failed;
 	}
 
-	bitmap_copy((unsigned long *)feature_mask, feature->allowed, 64);
+	bitmap_to_arr32(feature_mask, feature->allowed, 64);
 
 	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetAllowedFeaturesMaskHigh,
 					  feature_mask[1], NULL);
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index 4885c4ae78b7..27a54145d352 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1643,6 +1643,7 @@ static const struct throttling_logging_label {
 	uint32_t feature_mask;
 	const char *label;
 } logging_label[] = {
+	{(1U << THROTTLER_TEMP_GPU_BIT), "GPU"},
 	{(1U << THROTTLER_TEMP_MEM_BIT), "HBM"},
 	{(1U << THROTTLER_TEMP_VR_GFX_BIT), "VR of GFX rail"},
 	{(1U << THROTTLER_TEMP_VR_MEM_BIT), "VR of HBM rail"},
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index b54790d3483e..4a5e91b59f0c 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -726,7 +726,7 @@ int smu_v13_0_set_allowed_mask(struct smu_context *smu)
 	if (bitmap_empty(feature->allowed, SMU_FEATURE_MAX) || feature->feature_num < 64)
 		goto failed;
 
-	bitmap_copy((unsigned long *)feature_mask, feature->allowed, 64);
+	bitmap_to_arr32(feature_mask, feature->allowed, 64);
 
 	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_SetAllowedFeaturesMaskHigh,
 					      feature_mask[1], NULL);
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
index d0715927b07f..13461e28aeed 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
@@ -190,6 +190,9 @@ static int yellow_carp_fini_smc_tables(struct smu_context *smu)
 	kfree(smu_table->watermarks_table);
 	smu_table->watermarks_table = NULL;
 
+	kfree(smu_table->gpu_metrics_table);
+	smu_table->gpu_metrics_table = NULL;
+
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/ast/ast_mode.c b/drivers/gpu/drm/ast/ast_mode.c
index 956c8982192b..ab52efb15670 100644
--- a/drivers/gpu/drm/ast/ast_mode.c
+++ b/drivers/gpu/drm/ast/ast_mode.c
@@ -471,7 +471,10 @@ static void ast_set_color_reg(struct ast_private *ast,
 static void ast_set_crtthd_reg(struct ast_private *ast)
 {
 	/* Set Threshold */
-	if (ast->chip == AST2300 || ast->chip == AST2400 ||
+	if (ast->chip == AST2600) {
+		ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa7, 0xe0);
+		ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa6, 0xa0);
+	} else if (ast->chip == AST2300 || ast->chip == AST2400 ||
 	    ast->chip == AST2500) {
 		ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa7, 0x78);
 		ast_set_index_reg(ast, AST_IO_CRTC_PORT, 0xa6, 0x60);
diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index 235c7ee5258f..873cf6882bd3 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1268,6 +1268,25 @@ static int analogix_dp_bridge_attach(struct drm_bridge *bridge,
 	return 0;
 }
 
+static
+struct drm_crtc *analogix_dp_get_old_crtc(struct analogix_dp_device *dp,
+					  struct drm_atomic_state *state)
+{
+	struct drm_encoder *encoder = dp->encoder;
+	struct drm_connector *connector;
+	struct drm_connector_state *conn_state;
+
+	connector = drm_atomic_get_old_connector_for_encoder(state, encoder);
+	if (!connector)
+		return NULL;
+
+	conn_state = drm_atomic_get_old_connector_state(state, connector);
+	if (!conn_state)
+		return NULL;
+
+	return conn_state->crtc;
+}
+
 static
 struct drm_crtc *analogix_dp_get_new_crtc(struct analogix_dp_device *dp,
 					  struct drm_atomic_state *state)
@@ -1448,14 +1467,16 @@ analogix_dp_bridge_atomic_disable(struct drm_bridge *bridge,
 {
 	struct drm_atomic_state *old_state = old_bridge_state->base.state;
 	struct analogix_dp_device *dp = bridge->driver_private;
-	struct drm_crtc *crtc;
+	struct drm_crtc *old_crtc, *new_crtc;
+	struct drm_crtc_state *old_crtc_state = NULL;
 	struct drm_crtc_state *new_crtc_state = NULL;
+	int ret;
 
-	crtc = analogix_dp_get_new_crtc(dp, old_state);
-	if (!crtc)
+	new_crtc = analogix_dp_get_new_crtc(dp, old_state);
+	if (!new_crtc)
 		goto out;
 
-	new_crtc_state = drm_atomic_get_new_crtc_state(old_state, crtc);
+	new_crtc_state = drm_atomic_get_new_crtc_state(old_state, new_crtc);
 	if (!new_crtc_state)
 		goto out;
 
@@ -1464,6 +1485,19 @@ analogix_dp_bridge_atomic_disable(struct drm_bridge *bridge,
 		return;
 
 out:
+	old_crtc = analogix_dp_get_old_crtc(dp, old_state);
+	if (old_crtc) {
+		old_crtc_state = drm_atomic_get_old_crtc_state(old_state,
+							       old_crtc);
+
+		/* When moving from PSR to fully disabled, exit PSR first. */
+		if (old_crtc_state && old_crtc_state->self_refresh_active) {
+			ret = analogix_dp_disable_psr(dp);
+			if (ret)
+				DRM_ERROR("Failed to disable psr (%d)\n", ret);
+		}
+	}
+
 	analogix_dp_bridge_disable(bridge);
 }
 
diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi83.c b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
index 314a84ffcea3..1b7eeefe6784 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -560,7 +560,7 @@ static int sn65dsi83_parse_dt(struct sn65dsi83 *ctx, enum sn65dsi83_model model)
 	ctx->host_node = of_graph_get_remote_port_parent(endpoint);
 	of_node_put(endpoint);
 
-	if (ctx->dsi_lanes < 0 || ctx->dsi_lanes > 4) {
+	if (ctx->dsi_lanes <= 0 || ctx->dsi_lanes > 4) {
 		ret = -EINVAL;
 		goto err_put_node;
 	}
diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 9603193d2fa1..987e4b212e9f 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -1011,9 +1011,19 @@ crtc_needs_disable(struct drm_crtc_state *old_state,
 		return drm_atomic_crtc_effectively_active(old_state);
 
 	/*
-	 * We need to run through the crtc_funcs->disable() function if the CRTC
-	 * is currently on, if it's transitioning to self refresh mode, or if
-	 * it's in self refresh mode and needs to be fully disabled.
+	 * We need to disable bridge(s) and CRTC if we're transitioning out of
+	 * self-refresh and changing CRTCs at the same time, because the
+	 * bridge tracks self-refresh status via CRTC state.
+	 */
+	if (old_state->self_refresh_active &&
+	    old_state->crtc != new_state->crtc)
+		return true;
+
+	/*
+	 * We also need to run through the crtc_funcs->disable() function if
+	 * the CRTC is currently on, if it's transitioning to self refresh
+	 * mode, or if it's in self refresh mode and needs to be fully
+	 * disabled.
 	 */
 	return old_state->active ||
 	       (old_state->self_refresh_active && !new_state->active) ||
diff --git a/drivers/gpu/drm/imx/ipuv3-crtc.c b/drivers/gpu/drm/imx/ipuv3-crtc.c
index 9c8829f945b2..f7863d6dea80 100644
--- a/drivers/gpu/drm/imx/ipuv3-crtc.c
+++ b/drivers/gpu/drm/imx/ipuv3-crtc.c
@@ -69,7 +69,7 @@ static void ipu_crtc_disable_planes(struct ipu_crtc *ipu_crtc,
 	drm_atomic_crtc_state_for_each_plane(plane, old_crtc_state) {
 		if (plane == &ipu_crtc->plane[0]->base)
 			disable_full = true;
-		if (&ipu_crtc->plane[1] && plane == &ipu_crtc->plane[1]->base)
+		if (ipu_crtc->plane[1] && plane == &ipu_crtc->plane[1]->base)
 			disable_partial = true;
 	}
 
diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
index 6eb176872a17..7ae74bd05924 100644
--- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
+++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
@@ -1373,8 +1373,13 @@ void dp_ctrl_reset_irq_ctrl(struct dp_ctrl *dp_ctrl, bool enable)
 
 	dp_catalog_ctrl_reset(ctrl->catalog);
 
-	if (enable)
-		dp_catalog_ctrl_enable_irq(ctrl->catalog, enable);
+	/*
+	 * all dp controller programmable registers will not
+	 * be reset to default value after DP_SW_RESET
+	 * therefore interrupt mask bits have to be updated
+	 * to enable/disable interrupts
+	 */
+	dp_catalog_ctrl_enable_irq(ctrl->catalog, enable);
 }
 
 void dp_ctrl_phy_init(struct dp_ctrl *dp_ctrl)
diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index 96bb5a465627..012af6eaaf62 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -233,6 +233,7 @@ static int panfrost_ioctl_submit(struct drm_device *dev, void *data,
 		struct drm_file *file)
 {
 	struct panfrost_device *pfdev = dev->dev_private;
+	struct panfrost_file_priv *file_priv = file->driver_priv;
 	struct drm_panfrost_submit *args = data;
 	struct drm_syncobj *sync_out = NULL;
 	struct panfrost_job *job;
@@ -262,12 +263,12 @@ static int panfrost_ioctl_submit(struct drm_device *dev, void *data,
 	job->jc = args->jc;
 	job->requirements = args->requirements;
 	job->flush_id = panfrost_gpu_get_latest_flush_id(pfdev);
-	job->file_priv = file->driver_priv;
+	job->mmu = file_priv->mmu;
 
 	slot = panfrost_job_get_slot(job);
 
 	ret = drm_sched_job_init(&job->base,
-				 &job->file_priv->sched_entity[slot],
+				 &file_priv->sched_entity[slot],
 				 NULL);
 	if (ret)
 		goto out_put_job;
diff --git a/drivers/gpu/drm/panfrost/panfrost_job.c b/drivers/gpu/drm/panfrost/panfrost_job.c
index 908d79520853..016bec72b7ce 100644
--- a/drivers/gpu/drm/panfrost/panfrost_job.c
+++ b/drivers/gpu/drm/panfrost/panfrost_job.c
@@ -201,7 +201,7 @@ static void panfrost_job_hw_submit(struct panfrost_job *job, int js)
 		return;
 	}
 
-	cfg = panfrost_mmu_as_get(pfdev, job->file_priv->mmu);
+	cfg = panfrost_mmu_as_get(pfdev, job->mmu);
 
 	job_write(pfdev, JS_HEAD_NEXT_LO(js), lower_32_bits(jc_head));
 	job_write(pfdev, JS_HEAD_NEXT_HI(js), upper_32_bits(jc_head));
@@ -431,7 +431,7 @@ static void panfrost_job_handle_err(struct panfrost_device *pfdev,
 		job->jc = 0;
 	}
 
-	panfrost_mmu_as_put(pfdev, job->file_priv->mmu);
+	panfrost_mmu_as_put(pfdev, job->mmu);
 	panfrost_devfreq_record_idle(&pfdev->pfdevfreq);
 
 	if (signal_fence)
@@ -452,7 +452,7 @@ static void panfrost_job_handle_done(struct panfrost_device *pfdev,
 	 * happen when we receive the DONE interrupt while doing a GPU reset).
 	 */
 	job->jc = 0;
-	panfrost_mmu_as_put(pfdev, job->file_priv->mmu);
+	panfrost_mmu_as_put(pfdev, job->mmu);
 	panfrost_devfreq_record_idle(&pfdev->pfdevfreq);
 
 	dma_fence_signal_locked(job->done_fence);
diff --git a/drivers/gpu/drm/panfrost/panfrost_job.h b/drivers/gpu/drm/panfrost/panfrost_job.h
index 77e6d0e6f612..8becc1ba0eb9 100644
--- a/drivers/gpu/drm/panfrost/panfrost_job.h
+++ b/drivers/gpu/drm/panfrost/panfrost_job.h
@@ -17,7 +17,7 @@ struct panfrost_job {
 	struct kref refcount;
 
 	struct panfrost_device *pfdev;
-	struct panfrost_file_priv *file_priv;
+	struct panfrost_mmu *mmu;
 
 	/* Fence to be signaled by IRQ handler when the job is complete. */
 	struct dma_fence *done_fence;
diff --git a/drivers/gpu/drm/radeon/radeon_connectors.c b/drivers/gpu/drm/radeon/radeon_connectors.c
index 1546abcadacf..d157bb9072e8 100644
--- a/drivers/gpu/drm/radeon/radeon_connectors.c
+++ b/drivers/gpu/drm/radeon/radeon_connectors.c
@@ -473,6 +473,8 @@ static struct drm_display_mode *radeon_fp_native_mode(struct drm_encoder *encode
 	    native_mode->vdisplay != 0 &&
 	    native_mode->clock != 0) {
 		mode = drm_mode_duplicate(dev, native_mode);
+		if (!mode)
+			return NULL;
 		mode->type = DRM_MODE_TYPE_PREFERRED | DRM_MODE_TYPE_DRIVER;
 		drm_mode_set_name(mode);
 
@@ -487,6 +489,8 @@ static struct drm_display_mode *radeon_fp_native_mode(struct drm_encoder *encode
 		 * simpler.
 		 */
 		mode = drm_cvt_mode(dev, native_mode->hdisplay, native_mode->vdisplay, 60, true, false, false);
+		if (!mode)
+			return NULL;
 		mode->type = DRM_MODE_TYPE_PREFERRED | DRM_MODE_TYPE_DRIVER;
 		DRM_DEBUG_KMS("Adding cvt approximation of native panel mode %s\n", mode->name);
 	}
diff --git a/drivers/hwtracing/coresight/coresight-cpu-debug.c b/drivers/hwtracing/coresight/coresight-cpu-debug.c
index 8845ec4b4402..1874df7c6a73 100644
--- a/drivers/hwtracing/coresight/coresight-cpu-debug.c
+++ b/drivers/hwtracing/coresight/coresight-cpu-debug.c
@@ -380,9 +380,10 @@ static int debug_notifier_call(struct notifier_block *self,
 	int cpu;
 	struct debug_drvdata *drvdata;
 
-	mutex_lock(&debug_lock);
+	/* Bail out if we can't acquire the mutex or the functionality is off */
+	if (!mutex_trylock(&debug_lock))
+		return NOTIFY_DONE;
 
-	/* Bail out if the functionality is disabled */
 	if (!debug_enable)
 		goto skip_dump;
 
@@ -401,7 +402,7 @@ static int debug_notifier_call(struct notifier_block *self,
 
 skip_dump:
 	mutex_unlock(&debug_lock);
-	return 0;
+	return NOTIFY_DONE;
 }
 
 static struct notifier_block debug_notifier = {
diff --git a/drivers/i2c/busses/i2c-cadence.c b/drivers/i2c/busses/i2c-cadence.c
index 805c77143a0f..b4c1ad19cdae 100644
--- a/drivers/i2c/busses/i2c-cadence.c
+++ b/drivers/i2c/busses/i2c-cadence.c
@@ -760,7 +760,7 @@ static void cdns_i2c_master_reset(struct i2c_adapter *adap)
 static int cdns_i2c_process_msg(struct cdns_i2c *id, struct i2c_msg *msg,
 		struct i2c_adapter *adap)
 {
-	unsigned long time_left;
+	unsigned long time_left, msg_timeout;
 	u32 reg;
 
 	id->p_msg = msg;
@@ -785,8 +785,16 @@ static int cdns_i2c_process_msg(struct cdns_i2c *id, struct i2c_msg *msg,
 	else
 		cdns_i2c_msend(id);
 
+	/* Minimal time to execute this message */
+	msg_timeout = msecs_to_jiffies((1000 * msg->len * BITS_PER_BYTE) / id->i2c_clk);
+	/* Plus some wiggle room */
+	msg_timeout += msecs_to_jiffies(500);
+
+	if (msg_timeout < adap->timeout)
+		msg_timeout = adap->timeout;
+
 	/* Wait for the signal of completion */
-	time_left = wait_for_completion_timeout(&id->xfer_done, adap->timeout);
+	time_left = wait_for_completion_timeout(&id->xfer_done, msg_timeout);
 	if (time_left == 0) {
 		cdns_i2c_master_reset(adap);
 		dev_err(id->adap.dev.parent,
diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
index 0b66e25c0e2d..b2565bb05c79 100644
--- a/drivers/idle/intel_idle.c
+++ b/drivers/idle/intel_idle.c
@@ -109,6 +109,18 @@ static unsigned int mwait_substates __initdata;
 #define flg2MWAIT(flags) (((flags) >> 24) & 0xFF)
 #define MWAIT2flg(eax) ((eax & 0xFF) << 24)
 
+static __always_inline int __intel_idle(struct cpuidle_device *dev,
+					struct cpuidle_driver *drv, int index)
+{
+	struct cpuidle_state *state = &drv->states[index];
+	unsigned long eax = flg2MWAIT(state->flags);
+	unsigned long ecx = 1; /* break on interrupt flag */
+
+	mwait_idle_with_hints(eax, ecx);
+
+	return index;
+}
+
 /**
  * intel_idle - Ask the processor to enter the given idle state.
  * @dev: cpuidle device of the target CPU.
@@ -129,16 +141,19 @@ static unsigned int mwait_substates __initdata;
 static __cpuidle int intel_idle(struct cpuidle_device *dev,
 				struct cpuidle_driver *drv, int index)
 {
-	struct cpuidle_state *state = &drv->states[index];
-	unsigned long eax = flg2MWAIT(state->flags);
-	unsigned long ecx = 1; /* break on interrupt flag */
+	return __intel_idle(dev, drv, index);
+}
 
-	if (state->flags & CPUIDLE_FLAG_IRQ_ENABLE)
-		local_irq_enable();
+static __cpuidle int intel_idle_irq(struct cpuidle_device *dev,
+				    struct cpuidle_driver *drv, int index)
+{
+	int ret;
 
-	mwait_idle_with_hints(eax, ecx);
+	raw_local_irq_enable();
+	ret = __intel_idle(dev, drv, index);
+	raw_local_irq_disable();
 
-	return index;
+	return ret;
 }
 
 /**
@@ -1583,6 +1598,9 @@ static void __init intel_idle_init_cstates_icpu(struct cpuidle_driver *drv)
 		/* Structure copy. */
 		drv->states[drv->state_count] = cpuidle_state_table[cstate];
 
+		if (cpuidle_state_table[cstate].flags & CPUIDLE_FLAG_IRQ_ENABLE)
+			drv->states[drv->state_count].enter = intel_idle_irq;
+
 		if ((disabled_states_mask & BIT(drv->state_count)) ||
 		    ((icpu->use_acpi || force_use_acpi) &&
 		     intel_idle_off_by_default(mwait_hint) &&
diff --git a/drivers/iio/adc/ad7124.c b/drivers/iio/adc/ad7124.c
index b400bbe291aa..c22d8dcaa100 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -188,7 +188,6 @@ static const struct iio_chan_spec ad7124_channel_template = {
 		.sign = 'u',
 		.realbits = 24,
 		.storagebits = 32,
-		.shift = 8,
 		.endianness = IIO_BE,
 	},
 };
diff --git a/drivers/iio/adc/sc27xx_adc.c b/drivers/iio/adc/sc27xx_adc.c
index 00098caf6d9e..cfe003cc4f0b 100644
--- a/drivers/iio/adc/sc27xx_adc.c
+++ b/drivers/iio/adc/sc27xx_adc.c
@@ -36,8 +36,8 @@
 
 /* Bits and mask definition for SC27XX_ADC_CH_CFG register */
 #define SC27XX_ADC_CHN_ID_MASK		GENMASK(4, 0)
-#define SC27XX_ADC_SCALE_MASK		GENMASK(10, 8)
-#define SC27XX_ADC_SCALE_SHIFT		8
+#define SC27XX_ADC_SCALE_MASK		GENMASK(10, 9)
+#define SC27XX_ADC_SCALE_SHIFT		9
 
 /* Bits definitions for SC27XX_ADC_INT_EN registers */
 #define SC27XX_ADC_IRQ_EN		BIT(0)
@@ -103,14 +103,14 @@ static struct sc27xx_adc_linear_graph small_scale_graph = {
 	100, 341,
 };
 
-static const struct sc27xx_adc_linear_graph big_scale_graph_calib = {
-	4200, 856,
-	3600, 733,
+static const struct sc27xx_adc_linear_graph sc2731_big_scale_graph_calib = {
+	4200, 850,
+	3600, 728,
 };
 
-static const struct sc27xx_adc_linear_graph small_scale_graph_calib = {
-	1000, 833,
-	100, 80,
+static const struct sc27xx_adc_linear_graph sc2731_small_scale_graph_calib = {
+	1000, 838,
+	100, 84,
 };
 
 static int sc27xx_adc_get_calib_data(u32 calib_data, int calib_adc)
@@ -130,11 +130,11 @@ static int sc27xx_adc_scale_calibration(struct sc27xx_adc_data *data,
 	size_t len;
 
 	if (big_scale) {
-		calib_graph = &big_scale_graph_calib;
+		calib_graph = &sc2731_big_scale_graph_calib;
 		graph = &big_scale_graph;
 		cell_name = "big_scale_calib";
 	} else {
-		calib_graph = &small_scale_graph_calib;
+		calib_graph = &sc2731_small_scale_graph_calib;
 		graph = &small_scale_graph;
 		cell_name = "small_scale_calib";
 	}
diff --git a/drivers/iio/adc/stmpe-adc.c b/drivers/iio/adc/stmpe-adc.c
index d2d405388499..83e0ac4467ca 100644
--- a/drivers/iio/adc/stmpe-adc.c
+++ b/drivers/iio/adc/stmpe-adc.c
@@ -61,7 +61,7 @@ struct stmpe_adc {
 static int stmpe_read_voltage(struct stmpe_adc *info,
 		struct iio_chan_spec const *chan, int *val)
 {
-	long ret;
+	unsigned long ret;
 
 	mutex_lock(&info->lock);
 
@@ -79,7 +79,7 @@ static int stmpe_read_voltage(struct stmpe_adc *info,
 
 	ret = wait_for_completion_timeout(&info->completion, STMPE_ADC_TIMEOUT);
 
-	if (ret <= 0) {
+	if (ret == 0) {
 		stmpe_reg_write(info->stmpe, STMPE_REG_ADC_INT_STA,
 				STMPE_ADC_CH(info->channel));
 		mutex_unlock(&info->lock);
@@ -96,7 +96,7 @@ static int stmpe_read_voltage(struct stmpe_adc *info,
 static int stmpe_read_temp(struct stmpe_adc *info,
 		struct iio_chan_spec const *chan, int *val)
 {
-	long ret;
+	unsigned long ret;
 
 	mutex_lock(&info->lock);
 
@@ -114,7 +114,7 @@ static int stmpe_read_temp(struct stmpe_adc *info,
 
 	ret = wait_for_completion_timeout(&info->completion, STMPE_ADC_TIMEOUT);
 
-	if (ret <= 0) {
+	if (ret == 0) {
 		mutex_unlock(&info->lock);
 		return -ETIMEDOUT;
 	}
diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
index eb452d0c423c..5c7e4e725819 100644
--- a/drivers/iio/common/st_sensors/st_sensors_core.c
+++ b/drivers/iio/common/st_sensors/st_sensors_core.c
@@ -71,16 +71,18 @@ static int st_sensors_match_odr(struct st_sensor_settings *sensor_settings,
 
 int st_sensors_set_odr(struct iio_dev *indio_dev, unsigned int odr)
 {
-	int err;
+	int err = 0;
 	struct st_sensor_odr_avl odr_out = {0, 0};
 	struct st_sensor_data *sdata = iio_priv(indio_dev);
 
+	mutex_lock(&sdata->odr_lock);
+
 	if (!sdata->sensor_settings->odr.mask)
-		return 0;
+		goto unlock_mutex;
 
 	err = st_sensors_match_odr(sdata->sensor_settings, odr, &odr_out);
 	if (err < 0)
-		goto st_sensors_match_odr_error;
+		goto unlock_mutex;
 
 	if ((sdata->sensor_settings->odr.addr ==
 					sdata->sensor_settings->pw.addr) &&
@@ -103,7 +105,9 @@ int st_sensors_set_odr(struct iio_dev *indio_dev, unsigned int odr)
 	if (err >= 0)
 		sdata->odr = odr_out.hz;
 
-st_sensors_match_odr_error:
+unlock_mutex:
+	mutex_unlock(&sdata->odr_lock);
+
 	return err;
 }
 EXPORT_SYMBOL(st_sensors_set_odr);
@@ -361,6 +365,8 @@ int st_sensors_init_sensor(struct iio_dev *indio_dev,
 	struct st_sensors_platform_data *of_pdata;
 	int err = 0;
 
+	mutex_init(&sdata->odr_lock);
+
 	/* If OF/DT pdata exists, it will take precedence of anything else */
 	of_pdata = st_sensors_dev_probe(indio_dev->dev.parent, pdata);
 	if (IS_ERR(of_pdata))
@@ -554,18 +560,24 @@ int st_sensors_read_info_raw(struct iio_dev *indio_dev,
 		err = -EBUSY;
 		goto out;
 	} else {
+		mutex_lock(&sdata->odr_lock);
 		err = st_sensors_set_enable(indio_dev, true);
-		if (err < 0)
+		if (err < 0) {
+			mutex_unlock(&sdata->odr_lock);
 			goto out;
+		}
 
 		msleep((sdata->sensor_settings->bootime * 1000) / sdata->odr);
 		err = st_sensors_read_axis_data(indio_dev, ch, val);
-		if (err < 0)
+		if (err < 0) {
+			mutex_unlock(&sdata->odr_lock);
 			goto out;
+		}
 
 		*val = *val >> ch->scan_type.shift;
 
 		err = st_sensors_set_enable(indio_dev, false);
+		mutex_unlock(&sdata->odr_lock);
 	}
 out:
 	mutex_unlock(&indio_dev->mlock);
diff --git a/drivers/iio/dummy/iio_simple_dummy.c b/drivers/iio/dummy/iio_simple_dummy.c
index c0b7ef900735..c24f609c2ade 100644
--- a/drivers/iio/dummy/iio_simple_dummy.c
+++ b/drivers/iio/dummy/iio_simple_dummy.c
@@ -575,10 +575,9 @@ static struct iio_sw_device *iio_dummy_probe(const char *name)
 	 */
 
 	swd = kzalloc(sizeof(*swd), GFP_KERNEL);
-	if (!swd) {
-		ret = -ENOMEM;
-		goto error_kzalloc;
-	}
+	if (!swd)
+		return ERR_PTR(-ENOMEM);
+
 	/*
 	 * Allocate an IIO device.
 	 *
@@ -590,7 +589,7 @@ static struct iio_sw_device *iio_dummy_probe(const char *name)
 	indio_dev = iio_device_alloc(parent, sizeof(*st));
 	if (!indio_dev) {
 		ret = -ENOMEM;
-		goto error_ret;
+		goto error_free_swd;
 	}
 
 	st = iio_priv(indio_dev);
@@ -616,6 +615,10 @@ static struct iio_sw_device *iio_dummy_probe(const char *name)
 	 *    indio_dev->name = spi_get_device_id(spi)->name;
 	 */
 	indio_dev->name = kstrdup(name, GFP_KERNEL);
+	if (!indio_dev->name) {
+		ret = -ENOMEM;
+		goto error_free_device;
+	}
 
 	/* Provide description of available channels */
 	indio_dev->channels = iio_dummy_channels;
@@ -632,7 +635,7 @@ static struct iio_sw_device *iio_dummy_probe(const char *name)
 
 	ret = iio_simple_dummy_events_register(indio_dev);
 	if (ret < 0)
-		goto error_free_device;
+		goto error_free_name;
 
 	ret = iio_simple_dummy_configure_buffer(indio_dev);
 	if (ret < 0)
@@ -649,11 +652,12 @@ static struct iio_sw_device *iio_dummy_probe(const char *name)
 	iio_simple_dummy_unconfigure_buffer(indio_dev);
 error_unregister_events:
 	iio_simple_dummy_events_unregister(indio_dev);
+error_free_name:
+	kfree(indio_dev->name);
 error_free_device:
 	iio_device_free(indio_dev);
-error_ret:
+error_free_swd:
 	kfree(swd);
-error_kzalloc:
 	return ERR_PTR(ret);
 }
 
diff --git a/drivers/iio/proximity/vl53l0x-i2c.c b/drivers/iio/proximity/vl53l0x-i2c.c
index cf38144b6f95..13a87d3e3544 100644
--- a/drivers/iio/proximity/vl53l0x-i2c.c
+++ b/drivers/iio/proximity/vl53l0x-i2c.c
@@ -104,6 +104,7 @@ static int vl53l0x_read_proximity(struct vl53l0x_data *data,
 	u16 tries = 20;
 	u8 buffer[12];
 	int ret;
+	unsigned long time_left;
 
 	ret = i2c_smbus_write_byte_data(client, VL_REG_SYSRANGE_START, 1);
 	if (ret < 0)
@@ -112,10 +113,8 @@ static int vl53l0x_read_proximity(struct vl53l0x_data *data,
 	if (data->client->irq) {
 		reinit_completion(&data->completion);
 
-		ret = wait_for_completion_timeout(&data->completion, HZ/10);
-		if (ret < 0)
-			return ret;
-		else if (ret == 0)
+		time_left = wait_for_completion_timeout(&data->completion, HZ/10);
+		if (time_left == 0)
 			return -ETIMEDOUT;
 
 		vl53l0x_clear_irq(data);
diff --git a/drivers/input/mouse/bcm5974.c b/drivers/input/mouse/bcm5974.c
index 59a14505b9cd..ca150618d32f 100644
--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -942,17 +942,22 @@ static int bcm5974_probe(struct usb_interface *iface,
 	if (!dev->tp_data)
 		goto err_free_bt_buffer;
 
-	if (dev->bt_urb)
+	if (dev->bt_urb) {
 		usb_fill_int_urb(dev->bt_urb, udev,
 				 usb_rcvintpipe(udev, cfg->bt_ep),
 				 dev->bt_data, dev->cfg.bt_datalen,
 				 bcm5974_irq_button, dev, 1);
 
+		dev->bt_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+	}
+
 	usb_fill_int_urb(dev->tp_urb, udev,
 			 usb_rcvintpipe(udev, cfg->tp_ep),
 			 dev->tp_data, dev->cfg.tp_datalen,
 			 bcm5974_irq_trackpad, dev, 1);
 
+	dev->tp_urb->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
 	/* create bcm5974 device */
 	usb_make_path(udev, dev->phys, sizeof(dev->phys));
 	strlcat(dev->phys, "/input0", sizeof(dev->phys));
diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
index f60381cdf1c4..a009a3dd762b 100644
--- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
+++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
@@ -3780,6 +3780,8 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 
 	/* Base address */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 	if (resource_size(res) < arm_smmu_resource_size(smmu)) {
 		dev_err(dev, "MMIO region too small (%pr)\n", res);
 		return -EINVAL;
diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu.c b/drivers/iommu/arm/arm-smmu/arm-smmu.c
index 4bc75c4ce402..324e8f32962a 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu.c
@@ -2090,11 +2090,10 @@ static int arm_smmu_device_probe(struct platform_device *pdev)
 	if (err)
 		return err;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	ioaddr = res->start;
-	smmu->base = devm_ioremap_resource(dev, res);
+	smmu->base = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
 	if (IS_ERR(smmu->base))
 		return PTR_ERR(smmu->base);
+	ioaddr = res->start;
 	/*
 	 * The resource size should effectively match the value of SMMU_TOP;
 	 * stash that temporarily until we know PAGESIZE to validate it with.
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 43c5890dc9f3..79d64640240b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7962,17 +7962,22 @@ EXPORT_SYMBOL(md_register_thread);
 
 void md_unregister_thread(struct md_thread **threadp)
 {
-	struct md_thread *thread = *threadp;
-	if (!thread)
-		return;
-	pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
-	/* Locking ensures that mddev_unlock does not wake_up a
+	struct md_thread *thread;
+
+	/*
+	 * Locking ensures that mddev_unlock does not wake_up a
 	 * non-existent thread
 	 */
 	spin_lock(&pers_lock);
+	thread = *threadp;
+	if (!thread) {
+		spin_unlock(&pers_lock);
+		return;
+	}
 	*threadp = NULL;
 	spin_unlock(&pers_lock);
 
+	pr_debug("interrupting MD-thread pid %d\n", task_pid_nr(thread->tsk));
 	kthread_stop(thread->tsk);
 	kfree(thread);
 }
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index bccc741b9382..8495045eb989 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -128,21 +128,6 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 	pr_debug("md/raid0:%s: FINAL %d zones\n",
 		 mdname(mddev), conf->nr_strip_zones);
 
-	if (conf->nr_strip_zones == 1) {
-		conf->layout = RAID0_ORIG_LAYOUT;
-	} else if (mddev->layout == RAID0_ORIG_LAYOUT ||
-		   mddev->layout == RAID0_ALT_MULTIZONE_LAYOUT) {
-		conf->layout = mddev->layout;
-	} else if (default_layout == RAID0_ORIG_LAYOUT ||
-		   default_layout == RAID0_ALT_MULTIZONE_LAYOUT) {
-		conf->layout = default_layout;
-	} else {
-		pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 with default_layout setting\n",
-		       mdname(mddev));
-		pr_err("md/raid0: please set raid0.default_layout to 1 or 2\n");
-		err = -ENOTSUPP;
-		goto abort;
-	}
 	/*
 	 * now since we have the hard sector sizes, we can make sure
 	 * chunk size is a multiple of that sector size
@@ -273,6 +258,22 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
 			 (unsigned long long)smallest->sectors);
 	}
 
+	if (conf->nr_strip_zones == 1 || conf->strip_zone[1].nb_dev == 1) {
+		conf->layout = RAID0_ORIG_LAYOUT;
+	} else if (mddev->layout == RAID0_ORIG_LAYOUT ||
+		   mddev->layout == RAID0_ALT_MULTIZONE_LAYOUT) {
+		conf->layout = mddev->layout;
+	} else if (default_layout == RAID0_ORIG_LAYOUT ||
+		   default_layout == RAID0_ALT_MULTIZONE_LAYOUT) {
+		conf->layout = default_layout;
+	} else {
+		pr_err("md/raid0:%s: cannot assemble multi-zone RAID0 with default_layout setting\n",
+		       mdname(mddev));
+		pr_err("md/raid0: please set raid0.default_layout to 1 or 2\n");
+		err = -EOPNOTSUPP;
+		goto abort;
+	}
+
 	pr_debug("md/raid0:%s: done.\n", mdname(mddev));
 	*private_conf = conf;
 
diff --git a/drivers/misc/cardreader/rtsx_usb.c b/drivers/misc/cardreader/rtsx_usb.c
index 59eda55d92a3..1ef9b61077c4 100644
--- a/drivers/misc/cardreader/rtsx_usb.c
+++ b/drivers/misc/cardreader/rtsx_usb.c
@@ -667,6 +667,7 @@ static int rtsx_usb_probe(struct usb_interface *intf,
 	return 0;
 
 out_init_fail:
+	usb_set_intfdata(ucr->pusb_intf, NULL);
 	usb_free_coherent(ucr->pusb_dev, IOBUF_SIZE, ucr->iobuf,
 			ucr->iobuf_dma);
 	return ret;
diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index aa1682b94a23..45aaf54a7560 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -1353,17 +1353,18 @@ static int fastrpc_req_munmap_impl(struct fastrpc_user *fl,
 				   struct fastrpc_req_munmap *req)
 {
 	struct fastrpc_invoke_args args[1] = { [0] = { 0 } };
-	struct fastrpc_buf *buf, *b;
+	struct fastrpc_buf *buf = NULL, *iter, *b;
 	struct fastrpc_munmap_req_msg req_msg;
 	struct device *dev = fl->sctx->dev;
 	int err;
 	u32 sc;
 
 	spin_lock(&fl->lock);
-	list_for_each_entry_safe(buf, b, &fl->mmaps, node) {
-		if ((buf->raddr == req->vaddrout) && (buf->size == req->size))
+	list_for_each_entry_safe(iter, b, &fl->mmaps, node) {
+		if ((iter->raddr == req->vaddrout) && (iter->size == req->size)) {
+			buf = iter;
 			break;
-		buf = NULL;
+		}
 	}
 	spin_unlock(&fl->lock);
 
diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index f21854ac5cc2..8cb342c562af 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -327,6 +327,11 @@ void lkdtm_ARRAY_BOUNDS(void)
 
 	not_checked = kmalloc(sizeof(*not_checked) * 2, GFP_KERNEL);
 	checked = kmalloc(sizeof(*checked) * 2, GFP_KERNEL);
+	if (!not_checked || !checked) {
+		kfree(not_checked);
+		kfree(checked);
+		return;
+	}
 
 	pr_info("Array access within bounds ...\n");
 	/* For both, touch all bytes in the actual member size. */
@@ -346,7 +351,10 @@ void lkdtm_ARRAY_BOUNDS(void)
 	kfree(not_checked);
 	kfree(checked);
 	pr_err("FAIL: survived array bounds overflow!\n");
-	pr_expected_config(CONFIG_UBSAN_BOUNDS);
+	if (IS_ENABLED(CONFIG_UBSAN_BOUNDS))
+		pr_expected_config(CONFIG_UBSAN_TRAP);
+	else
+		pr_expected_config(CONFIG_UBSAN_BOUNDS);
 }
 
 void lkdtm_CORRUPT_LIST_ADD(void)
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index d6137c70ebbe..cc76ebcca4c7 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -9,19 +9,19 @@
 extern char *lkdtm_kernel_info;
 
 #define pr_expected_config(kconfig)				\
-{								\
+do {								\
 	if (IS_ENABLED(kconfig)) 				\
 		pr_err("Unexpected! This %s was built with " #kconfig "=y\n", \
 			lkdtm_kernel_info);			\
 	else							\
 		pr_warn("This is probably expected, since this %s was built *without* " #kconfig "=y\n", \
 			lkdtm_kernel_info);			\
-}
+} while (0)
 
 #ifndef MODULE
 int lkdtm_check_bool_cmdline(const char *param);
 #define pr_expected_config_param(kconfig, param)		\
-{								\
+do {								\
 	if (IS_ENABLED(kconfig)) {				\
 		switch (lkdtm_check_bool_cmdline(param)) {	\
 		case 0:						\
@@ -52,7 +52,7 @@ int lkdtm_check_bool_cmdline(const char *param);
 			break;					\
 		}						\
 	}							\
-}
+} while (0)
 #else
 #define pr_expected_config_param(kconfig, param) pr_expected_config(kconfig)
 #endif
diff --git a/drivers/misc/lkdtm/usercopy.c b/drivers/misc/lkdtm/usercopy.c
index 9161ce7ed47a..3fead5efe523 100644
--- a/drivers/misc/lkdtm/usercopy.c
+++ b/drivers/misc/lkdtm/usercopy.c
@@ -30,12 +30,12 @@ static const unsigned char test_text[] = "This is a test.\n";
  */
 static noinline unsigned char *trick_compiler(unsigned char *stack)
 {
-	return stack + 0;
+	return stack + unconst;
 }
 
 static noinline unsigned char *do_usercopy_stack_callee(int value)
 {
-	unsigned char buf[32];
+	unsigned char buf[128];
 	int i;
 
 	/* Exercise stack to avoid everything living in registers. */
@@ -43,7 +43,12 @@ static noinline unsigned char *do_usercopy_stack_callee(int value)
 		buf[i] = value & 0xff;
 	}
 
-	return trick_compiler(buf);
+	/*
+	 * Put the target buffer in the middle of stack allocation
+	 * so that we don't step on future stack users regardless
+	 * of stack growth direction.
+	 */
+	return trick_compiler(&buf[(128/2)-32]);
 }
 
 static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
@@ -66,6 +71,12 @@ static noinline void do_usercopy_stack(bool to_user, bool bad_frame)
 		bad_stack -= sizeof(unsigned long);
 	}
 
+#ifdef ARCH_HAS_CURRENT_STACK_POINTER
+	pr_info("stack     : %px\n", (void *)current_stack_pointer);
+#endif
+	pr_info("good_stack: %px-%px\n", good_stack, good_stack + sizeof(good_stack));
+	pr_info("bad_stack : %px-%px\n", bad_stack, bad_stack + sizeof(good_stack));
+
 	user_addr = vm_mmap(NULL, 0, PAGE_SIZE,
 			    PROT_READ | PROT_WRITE | PROT_EXEC,
 			    MAP_ANONYMOUS | MAP_PRIVATE, 0);
diff --git a/drivers/misc/pvpanic/pvpanic.c b/drivers/misc/pvpanic/pvpanic.c
index 4b8f1c7d726d..049a12006348 100644
--- a/drivers/misc/pvpanic/pvpanic.c
+++ b/drivers/misc/pvpanic/pvpanic.c
@@ -34,7 +34,9 @@ pvpanic_send_event(unsigned int event)
 {
 	struct pvpanic_instance *pi_cur;
 
-	spin_lock(&pvpanic_lock);
+	if (!spin_trylock(&pvpanic_lock))
+		return;
+
 	list_for_each_entry(pi_cur, &pvpanic_list, list) {
 		if (event & pi_cur->capability & pi_cur->events)
 			iowrite8(event, pi_cur->base);
@@ -55,9 +57,13 @@ pvpanic_panic_notify(struct notifier_block *nb, unsigned long code, void *unused
 	return NOTIFY_DONE;
 }
 
+/*
+ * Call our notifier very early on panic, deferring the
+ * action taken to the hypervisor.
+ */
 static struct notifier_block pvpanic_panic_nb = {
 	.notifier_call = pvpanic_panic_notify,
-	.priority = 1, /* let this called before broken drm_fb_helper() */
+	.priority = INT_MAX,
 };
 
 static void pvpanic_remove(void *param)
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 52e4106bcb6e..57f5e0a4d7d7 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1482,8 +1482,7 @@ void mmc_blk_cqe_recovery(struct mmc_queue *mq)
 	err = mmc_cqe_recovery(host);
 	if (err)
 		mmc_blk_reset(mq->blkdata, host, MMC_BLK_CQE_RECOVERY);
-	else
-		mmc_blk_reset_success(mq->blkdata, MMC_BLK_CQE_RECOVERY);
+	mmc_blk_reset_success(mq->blkdata, MMC_BLK_CQE_RECOVERY);
 
 	pr_debug("%s: CQE recovery done\n", mmc_hostname(host));
 }
diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index 28f55f9cf715..053ab52668e8 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -97,6 +97,33 @@ struct ubi_wl_entry *ubi_wl_get_fm_peb(struct ubi_device *ubi, int anchor)
 	return e;
 }
 
+/*
+ * has_enough_free_count - whether ubi has enough free pebs to fill fm pools
+ * @ubi: UBI device description object
+ * @is_wl_pool: whether UBI is filling wear leveling pool
+ *
+ * This helper function checks whether there are enough free pebs (deducted
+ * by fastmap pebs) to fill fm_pool and fm_wl_pool, above rule works after
+ * there is at least one of free pebs is filled into fm_wl_pool.
+ * For wear leveling pool, UBI should also reserve free pebs for bad pebs
+ * handling, because there maybe no enough free pebs for user volumes after
+ * producing new bad pebs.
+ */
+static bool has_enough_free_count(struct ubi_device *ubi, bool is_wl_pool)
+{
+	int fm_used = 0;	// fastmap non anchor pebs.
+	int beb_rsvd_pebs;
+
+	if (!ubi->free.rb_node)
+		return false;
+
+	beb_rsvd_pebs = is_wl_pool ? ubi->beb_rsvd_pebs : 0;
+	if (ubi->fm_wl_pool.size > 0 && !(ubi->ro_mode || ubi->fm_disabled))
+		fm_used = ubi->fm_size / ubi->leb_size - 1;
+
+	return ubi->free_count - beb_rsvd_pebs > fm_used;
+}
+
 /**
  * ubi_refill_pools - refills all fastmap PEB pools.
  * @ubi: UBI device description object
@@ -120,21 +147,17 @@ void ubi_refill_pools(struct ubi_device *ubi)
 		wl_tree_add(ubi->fm_anchor, &ubi->free);
 		ubi->free_count++;
 	}
-	if (ubi->fm_next_anchor) {
-		wl_tree_add(ubi->fm_next_anchor, &ubi->free);
-		ubi->free_count++;
-	}
 
-	/* All available PEBs are in ubi->free, now is the time to get
+	/*
+	 * All available PEBs are in ubi->free, now is the time to get
 	 * the best anchor PEBs.
 	 */
 	ubi->fm_anchor = ubi_wl_get_fm_peb(ubi, 1);
-	ubi->fm_next_anchor = ubi_wl_get_fm_peb(ubi, 1);
 
 	for (;;) {
 		enough = 0;
 		if (pool->size < pool->max_size) {
-			if (!ubi->free.rb_node)
+			if (!has_enough_free_count(ubi, false))
 				break;
 
 			e = wl_get_wle(ubi);
@@ -147,8 +170,7 @@ void ubi_refill_pools(struct ubi_device *ubi)
 			enough++;
 
 		if (wl_pool->size < wl_pool->max_size) {
-			if (!ubi->free.rb_node ||
-			   (ubi->free_count - ubi->beb_rsvd_pebs < 5))
+			if (!has_enough_free_count(ubi, true))
 				break;
 
 			e = find_wl_entry(ubi, &ubi->free, WL_FREE_MAX_DIFF);
@@ -286,20 +308,26 @@ static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
 int ubi_ensure_anchor_pebs(struct ubi_device *ubi)
 {
 	struct ubi_work *wrk;
+	struct ubi_wl_entry *anchor;
 
 	spin_lock(&ubi->wl_lock);
 
-	/* Do we have a next anchor? */
-	if (!ubi->fm_next_anchor) {
-		ubi->fm_next_anchor = ubi_wl_get_fm_peb(ubi, 1);
-		if (!ubi->fm_next_anchor)
-			/* Tell wear leveling to produce a new anchor PEB */
-			ubi->fm_do_produce_anchor = 1;
+	/* Do we already have an anchor? */
+	if (ubi->fm_anchor) {
+		spin_unlock(&ubi->wl_lock);
+		return 0;
 	}
 
-	/* Do wear leveling to get a new anchor PEB or check the
-	 * existing next anchor candidate.
-	 */
+	/* See if we can find an anchor PEB on the list of free PEBs */
+	anchor = ubi_wl_get_fm_peb(ubi, 1);
+	if (anchor) {
+		ubi->fm_anchor = anchor;
+		spin_unlock(&ubi->wl_lock);
+		return 0;
+	}
+
+	ubi->fm_do_produce_anchor = 1;
+	/* No luck, trigger wear leveling to produce a new anchor PEB. */
 	if (ubi->wl_scheduled) {
 		spin_unlock(&ubi->wl_lock);
 		return 0;
@@ -381,11 +409,6 @@ static void ubi_fastmap_close(struct ubi_device *ubi)
 		ubi->fm_anchor = NULL;
 	}
 
-	if (ubi->fm_next_anchor) {
-		return_unused_peb(ubi, ubi->fm_next_anchor);
-		ubi->fm_next_anchor = NULL;
-	}
-
 	if (ubi->fm) {
 		for (i = 0; i < ubi->fm->used_blocks; i++)
 			kfree(ubi->fm->e[i]);
diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 6b5f1ffd961b..6e95c4b1473e 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1230,17 +1230,6 @@ static int ubi_write_fastmap(struct ubi_device *ubi,
 		fm_pos += sizeof(*fec);
 		ubi_assert(fm_pos <= ubi->fm_size);
 	}
-	if (ubi->fm_next_anchor) {
-		fec = (struct ubi_fm_ec *)(fm_raw + fm_pos);
-
-		fec->pnum = cpu_to_be32(ubi->fm_next_anchor->pnum);
-		set_seen(ubi, ubi->fm_next_anchor->pnum, seen_pebs);
-		fec->ec = cpu_to_be32(ubi->fm_next_anchor->ec);
-
-		free_peb_count++;
-		fm_pos += sizeof(*fec);
-		ubi_assert(fm_pos <= ubi->fm_size);
-	}
 	fmh->free_peb_count = cpu_to_be32(free_peb_count);
 
 	ubi_for_each_used_peb(ubi, wl_e, tmp_rb) {
diff --git a/drivers/mtd/ubi/ubi.h b/drivers/mtd/ubi/ubi.h
index 7c083ad58274..078112e23dfd 100644
--- a/drivers/mtd/ubi/ubi.h
+++ b/drivers/mtd/ubi/ubi.h
@@ -489,8 +489,7 @@ struct ubi_debug_info {
  * @fm_work: fastmap work queue
  * @fm_work_scheduled: non-zero if fastmap work was scheduled
  * @fast_attach: non-zero if UBI was attached by fastmap
- * @fm_anchor: The new anchor PEB used during fastmap update
- * @fm_next_anchor: An anchor PEB candidate for the next time fastmap is updated
+ * @fm_anchor: The next anchor PEB to use for fastmap
  * @fm_do_produce_anchor: If true produce an anchor PEB in wl
  *
  * @used: RB-tree of used physical eraseblocks
@@ -601,7 +600,6 @@ struct ubi_device {
 	int fm_work_scheduled;
 	int fast_attach;
 	struct ubi_wl_entry *fm_anchor;
-	struct ubi_wl_entry *fm_next_anchor;
 	int fm_do_produce_anchor;
 
 	/* Wear-leveling sub-system's stuff */
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index 1bc7b3a05604..6ea95ade4ca6 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -309,7 +309,6 @@ int ubi_create_volume(struct ubi_device *ubi, struct ubi_mkvol_req *req)
 	ubi->volumes[vol_id] = NULL;
 	ubi->vol_count -= 1;
 	spin_unlock(&ubi->volumes_lock);
-	ubi_eba_destroy_table(eba_tbl);
 out_acc:
 	spin_lock(&ubi->volumes_lock);
 	ubi->rsvd_pebs -= vol->reserved_pebs;
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 8455f1d47f3c..afcdacb9d0e9 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -689,16 +689,16 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 
 #ifdef CONFIG_MTD_UBI_FASTMAP
 	e1 = find_anchor_wl_entry(&ubi->used);
-	if (e1 && ubi->fm_next_anchor &&
-	    (ubi->fm_next_anchor->ec - e1->ec >= UBI_WL_THRESHOLD)) {
+	if (e1 && ubi->fm_anchor &&
+	    (ubi->fm_anchor->ec - e1->ec >= UBI_WL_THRESHOLD)) {
 		ubi->fm_do_produce_anchor = 1;
-		/* fm_next_anchor is no longer considered a good anchor
-		 * candidate.
+		/*
+		 * fm_anchor is no longer considered a good anchor.
 		 * NULL assignment also prevents multiple wear level checks
 		 * of this PEB.
 		 */
-		wl_tree_add(ubi->fm_next_anchor, &ubi->free);
-		ubi->fm_next_anchor = NULL;
+		wl_tree_add(ubi->fm_anchor, &ubi->free);
+		ubi->fm_anchor = NULL;
 		ubi->free_count++;
 	}
 
@@ -1085,12 +1085,13 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
 	if (!err) {
 		spin_lock(&ubi->wl_lock);
 
-		if (!ubi->fm_disabled && !ubi->fm_next_anchor &&
+		if (!ubi->fm_disabled && !ubi->fm_anchor &&
 		    e->pnum < UBI_FM_MAX_START) {
-			/* Abort anchor production, if needed it will be
+			/*
+			 * Abort anchor production, if needed it will be
 			 * enabled again in the wear leveling started below.
 			 */
-			ubi->fm_next_anchor = e;
+			ubi->fm_anchor = e;
 			ubi->fm_do_produce_anchor = 0;
 		} else {
 			wl_tree_add(e, &ubi->free);
diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index fb774d568baa..83e5fe784f5c 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -51,6 +51,7 @@ static char *status_str[] = {
 };
 
 static char *type_str[] = {
+	"", /* Type 0 is not defined */
 	"AMT_MSG_DISCOVERY",
 	"AMT_MSG_ADVERTISEMENT",
 	"AMT_MSG_REQUEST",
@@ -2220,8 +2221,7 @@ static bool amt_advertisement_handler(struct amt_dev *amt, struct sk_buff *skb)
 	struct amt_header_advertisement *amta;
 	int hdr_size;
 
-	hdr_size = sizeof(*amta) - sizeof(struct amt_header);
-
+	hdr_size = sizeof(*amta) + sizeof(struct udphdr);
 	if (!pskb_may_pull(skb, hdr_size))
 		return true;
 
@@ -2251,19 +2251,27 @@ static bool amt_multicast_data_handler(struct amt_dev *amt, struct sk_buff *skb)
 	struct ethhdr *eth;
 	struct iphdr *iph;
 
+	hdr_size = sizeof(*amtmd) + sizeof(struct udphdr);
+	if (!pskb_may_pull(skb, hdr_size))
+		return true;
+
 	amtmd = (struct amt_header_mcast_data *)(udp_hdr(skb) + 1);
 	if (amtmd->reserved || amtmd->version)
 		return true;
 
-	hdr_size = sizeof(*amtmd) + sizeof(struct udphdr);
 	if (iptunnel_pull_header(skb, hdr_size, htons(ETH_P_IP), false))
 		return true;
+
 	skb_reset_network_header(skb);
 	skb_push(skb, sizeof(*eth));
 	skb_reset_mac_header(skb);
 	skb_pull(skb, sizeof(*eth));
 	eth = eth_hdr(skb);
+
+	if (!pskb_may_pull(skb, sizeof(*iph)))
+		return true;
 	iph = ip_hdr(skb);
+
 	if (iph->version == 4) {
 		if (!ipv4_is_multicast(iph->daddr))
 			return true;
@@ -2274,6 +2282,9 @@ static bool amt_multicast_data_handler(struct amt_dev *amt, struct sk_buff *skb)
 	} else if (iph->version == 6) {
 		struct ipv6hdr *ip6h;
 
+		if (!pskb_may_pull(skb, sizeof(*ip6h)))
+			return true;
+
 		ip6h = ipv6_hdr(skb);
 		if (!ipv6_addr_is_multicast(&ip6h->daddr))
 			return true;
@@ -2306,8 +2317,7 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 	struct iphdr *iph;
 	int hdr_size, len;
 
-	hdr_size = sizeof(*amtmq) - sizeof(struct amt_header);
-
+	hdr_size = sizeof(*amtmq) + sizeof(struct udphdr);
 	if (!pskb_may_pull(skb, hdr_size))
 		return true;
 
@@ -2315,22 +2325,27 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 	if (amtmq->reserved || amtmq->version)
 		return true;
 
-	hdr_size = sizeof(*amtmq) + sizeof(struct udphdr) - sizeof(*eth);
+	hdr_size -= sizeof(*eth);
 	if (iptunnel_pull_header(skb, hdr_size, htons(ETH_P_TEB), false))
 		return true;
+
 	oeth = eth_hdr(skb);
 	skb_reset_mac_header(skb);
 	skb_pull(skb, sizeof(*eth));
 	skb_reset_network_header(skb);
 	eth = eth_hdr(skb);
+	if (!pskb_may_pull(skb, sizeof(*iph)))
+		return true;
+
 	iph = ip_hdr(skb);
 	if (iph->version == 4) {
-		if (!ipv4_is_multicast(iph->daddr))
-			return true;
 		if (!pskb_may_pull(skb, sizeof(*iph) + AMT_IPHDR_OPTS +
 				   sizeof(*ihv3)))
 			return true;
 
+		if (!ipv4_is_multicast(iph->daddr))
+			return true;
+
 		ihv3 = skb_pull(skb, sizeof(*iph) + AMT_IPHDR_OPTS);
 		skb_reset_transport_header(skb);
 		skb_push(skb, sizeof(*iph) + AMT_IPHDR_OPTS);
@@ -2345,15 +2360,17 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 		ip_eth_mc_map(iph->daddr, eth->h_dest);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (iph->version == 6) {
-		struct ipv6hdr *ip6h = ipv6_hdr(skb);
 		struct mld2_query *mld2q;
+		struct ipv6hdr *ip6h;
 
-		if (!ipv6_addr_is_multicast(&ip6h->daddr))
-			return true;
 		if (!pskb_may_pull(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS +
 				   sizeof(*mld2q)))
 			return true;
 
+		ip6h = ipv6_hdr(skb);
+		if (!ipv6_addr_is_multicast(&ip6h->daddr))
+			return true;
+
 		mld2q = skb_pull(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
 		skb_reset_transport_header(skb);
 		skb_push(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
@@ -2389,23 +2406,23 @@ static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
 {
 	struct amt_header_membership_update *amtmu;
 	struct amt_tunnel_list *tunnel;
-	struct udphdr *udph;
 	struct ethhdr *eth;
 	struct iphdr *iph;
-	int len;
+	int len, hdr_size;
 
 	iph = ip_hdr(skb);
-	udph = udp_hdr(skb);
 
-	if (__iptunnel_pull_header(skb, sizeof(*udph), skb->protocol,
-				   false, false))
+	hdr_size = sizeof(*amtmu) + sizeof(struct udphdr);
+	if (!pskb_may_pull(skb, hdr_size))
 		return true;
 
-	amtmu = (struct amt_header_membership_update *)skb->data;
+	amtmu = (struct amt_header_membership_update *)(udp_hdr(skb) + 1);
 	if (amtmu->reserved || amtmu->version)
 		return true;
 
-	skb_pull(skb, sizeof(*amtmu));
+	if (iptunnel_pull_header(skb, hdr_size, skb->protocol, false))
+		return true;
+
 	skb_reset_network_header(skb);
 
 	list_for_each_entry_rcu(tunnel, &amt->tunnel_list, list) {
@@ -2423,9 +2440,12 @@ static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
 		}
 	}
 
-	return false;
+	return true;
 
 report:
+	if (!pskb_may_pull(skb, sizeof(*iph)))
+		return true;
+
 	iph = ip_hdr(skb);
 	if (iph->version == 4) {
 		if (ip_mc_check_igmp(skb)) {
@@ -2679,6 +2699,7 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 	amt = rcu_dereference_sk_user_data(sk);
 	if (!amt) {
 		err = true;
+		kfree_skb(skb);
 		goto out;
 	}
 
diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index 8acec33a4702..9d8db457599c 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -2021,8 +2021,10 @@ static int gswip_gphy_fw_list(struct gswip_priv *priv,
 	for_each_available_child_of_node(gphy_fw_list_np, gphy_fw_np) {
 		err = gswip_gphy_fw_probe(priv, &priv->gphy_fw[i],
 					  gphy_fw_np, i);
-		if (err)
+		if (err) {
+			of_node_put(gphy_fw_np);
 			goto remove_gphy;
+		}
 		i++;
 	}
 
diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index cf7754dddad7..283ae376f469 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -3482,6 +3482,7 @@ static int mv88e6xxx_mdios_register(struct mv88e6xxx_chip *chip,
 	 */
 	child = of_get_child_by_name(np, "mdio");
 	err = mv88e6xxx_mdio_register(chip, child, false);
+	of_node_put(child);
 	if (err)
 		return err;
 
diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 2b05ead515cd..6ae7a0ed9e0b 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -50,22 +50,17 @@ static int mv88e6390_serdes_write(struct mv88e6xxx_chip *chip,
 }
 
 static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
-					  u16 ctrl, u16 status, u16 lpa,
+					  u16 bmsr, u16 lpa, u16 status,
 					  struct phylink_link_state *state)
 {
 	state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
+	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
 
 	if (status & MV88E6390_SGMII_PHY_STATUS_SPD_DPL_VALID) {
 		/* The Spped and Duplex Resolved register is 1 if AN is enabled
 		 * and complete, or if AN is disabled. So with disabled AN we
-		 * still get here on link up. But we want to set an_complete
-		 * only if AN was enabled, thus we look at BMCR_ANENABLE.
-		 * (According to 802.3-2008 section 22.2.4.2.10, we should be
-		 *  able to get this same value from BMSR_ANEGCAPABLE, but tests
-		 *  show that these Marvell PHYs don't conform to this part of
-		 *  the specificaion - BMSR_ANEGCAPABLE is simply always 1.)
+		 * still get here on link up.
 		 */
-		state->an_complete = !!(ctrl & BMCR_ANENABLE);
 		state->duplex = status &
 				MV88E6390_SGMII_PHY_STATUS_DUPLEX_FULL ?
 			                         DUPLEX_FULL : DUPLEX_HALF;
@@ -191,12 +186,12 @@ int mv88e6352_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 				   int lane, struct phylink_link_state *state)
 {
-	u16 lpa, status, ctrl;
+	u16 bmsr, lpa, status;
 	int err;
 
-	err = mv88e6352_serdes_read(chip, MII_BMCR, &ctrl);
+	err = mv88e6352_serdes_read(chip, MII_BMSR, &bmsr);
 	if (err) {
-		dev_err(chip->dev, "can't read Serdes PHY control: %d\n", err);
+		dev_err(chip->dev, "can't read Serdes BMSR: %d\n", err);
 		return err;
 	}
 
@@ -212,7 +207,7 @@ int mv88e6352_serdes_pcs_get_state(struct mv88e6xxx_chip *chip, int port,
 		return err;
 	}
 
-	return mv88e6xxx_serdes_pcs_get_state(chip, ctrl, status, lpa, state);
+	return mv88e6xxx_serdes_pcs_get_state(chip, bmsr, lpa, status, state);
 }
 
 int mv88e6352_serdes_pcs_an_restart(struct mv88e6xxx_chip *chip, int port,
@@ -915,13 +910,13 @@ int mv88e6390_serdes_pcs_config(struct mv88e6xxx_chip *chip, int port,
 static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
 	int port, int lane, struct phylink_link_state *state)
 {
-	u16 lpa, status, ctrl;
+	u16 bmsr, lpa, status;
 	int err;
 
 	err = mv88e6390_serdes_read(chip, lane, MDIO_MMD_PHYXS,
-				    MV88E6390_SGMII_BMCR, &ctrl);
+				    MV88E6390_SGMII_BMSR, &bmsr);
 	if (err) {
-		dev_err(chip->dev, "can't read Serdes PHY control: %d\n", err);
+		dev_err(chip->dev, "can't read Serdes PHY BMSR: %d\n", err);
 		return err;
 	}
 
@@ -939,7 +934,7 @@ static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *chip,
 		return err;
 	}
 
-	return mv88e6xxx_serdes_pcs_get_state(chip, ctrl, status, lpa, state);
+	return mv88e6xxx_serdes_pcs_get_state(chip, bmsr, lpa, status, state);
 }
 
 static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip,
diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 993b2fb42961..36bf3ce545c9 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -163,7 +163,8 @@ static int altera_tse_mdio_create(struct net_device *dev, unsigned int id)
 	mdio = mdiobus_alloc();
 	if (mdio == NULL) {
 		netdev_err(dev, "Error allocating MDIO bus\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto put_node;
 	}
 
 	mdio->name = ALTERA_TSE_RESOURCE_NAME;
@@ -180,6 +181,7 @@ static int altera_tse_mdio_create(struct net_device *dev, unsigned int id)
 			   mdio->id);
 		goto out_free_mdio;
 	}
+	of_node_put(mdio_node);
 
 	if (netif_msg_drv(priv))
 		netdev_info(dev, "MDIO bus %s: created\n", mdio->id);
@@ -189,6 +191,8 @@ static int altera_tse_mdio_create(struct net_device *dev, unsigned int id)
 out_free_mdio:
 	mdiobus_free(mdio);
 	mdio = NULL;
+put_node:
+	of_node_put(mdio_node);
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c b/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
index 086739e4f40a..9b83d5361699 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma-mdio.c
@@ -234,6 +234,7 @@ struct mii_bus *bcma_mdio_mii_register(struct bgmac *bgmac)
 	np = of_get_child_by_name(core->dev.of_node, "mdio");
 
 	err = of_mdiobus_register(mii_bus, np);
+	of_node_put(np);
 	if (err) {
 		dev_err(&core->dev, "Registration of mii bus failed\n");
 		goto err_free_bus;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
index 66cc79500c10..af9c88e71452 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
@@ -830,8 +830,6 @@ void i40e_free_tx_resources(struct i40e_ring *tx_ring)
 	i40e_clean_tx_ring(tx_ring);
 	kfree(tx_ring->tx_bi);
 	tx_ring->tx_bi = NULL;
-	kfree(tx_ring->xsk_descs);
-	tx_ring->xsk_descs = NULL;
 
 	if (tx_ring->desc) {
 		dma_free_coherent(tx_ring->dev, tx_ring->size,
@@ -1433,13 +1431,6 @@ int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
 	if (!tx_ring->tx_bi)
 		goto err;
 
-	if (ring_is_xdp(tx_ring)) {
-		tx_ring->xsk_descs = kcalloc(I40E_MAX_NUM_DESCRIPTORS, sizeof(*tx_ring->xsk_descs),
-					     GFP_KERNEL);
-		if (!tx_ring->xsk_descs)
-			goto err;
-	}
-
 	u64_stats_init(&tx_ring->syncp);
 
 	/* round up to nearest 4K */
@@ -1463,8 +1454,6 @@ int i40e_setup_tx_descriptors(struct i40e_ring *tx_ring)
 	return 0;
 
 err:
-	kfree(tx_ring->xsk_descs);
-	tx_ring->xsk_descs = NULL;
 	kfree(tx_ring->tx_bi);
 	tx_ring->tx_bi = NULL;
 	return -ENOMEM;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
index bfc2845c99d1..f6d91fa1562e 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
+++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
@@ -390,7 +390,6 @@ struct i40e_ring {
 	u16 rx_offset;
 	struct xdp_rxq_info xdp_rxq;
 	struct xsk_buff_pool *xsk_pool;
-	struct xdp_desc *xsk_descs;      /* For storing descriptors in the AF_XDP ZC path */
 } ____cacheline_internodealigned_in_smp;
 
 static inline bool ring_uses_build_skb(struct i40e_ring *ring)
diff --git a/drivers/net/ethernet/intel/i40e/i40e_xsk.c b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
index e5e72b5bb619..c1d25b0b0ca2 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_xsk.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_xsk.c
@@ -470,11 +470,11 @@ static void i40e_set_rs_bit(struct i40e_ring *xdp_ring)
  **/
 static bool i40e_xmit_zc(struct i40e_ring *xdp_ring, unsigned int budget)
 {
-	struct xdp_desc *descs = xdp_ring->xsk_descs;
+	struct xdp_desc *descs = xdp_ring->xsk_pool->tx_descs;
 	u32 nb_pkts, nb_processed = 0;
 	unsigned int total_bytes = 0;
 
-	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, descs, budget);
+	nb_pkts = xsk_tx_peek_release_desc_batch(xdp_ring->xsk_pool, budget);
 	if (!nb_pkts)
 		return true;
 
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
index 214a38de3f41..aaebdae8b5ff 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c
@@ -1157,9 +1157,9 @@ static int ixgbe_update_vf_xcast_mode(struct ixgbe_adapter *adapter,
 
 	switch (xcast_mode) {
 	case IXGBEVF_XCAST_MODE_NONE:
-		disable = IXGBE_VMOLR_BAM | IXGBE_VMOLR_ROMPE |
+		disable = IXGBE_VMOLR_ROMPE |
 			  IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE | IXGBE_VMOLR_VPE;
-		enable = 0;
+		enable = IXGBE_VMOLR_BAM;
 		break;
 	case IXGBEVF_XCAST_MODE_MULTI:
 		disable = IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE | IXGBE_VMOLR_VPE;
@@ -1181,9 +1181,9 @@ static int ixgbe_update_vf_xcast_mode(struct ixgbe_adapter *adapter,
 			return -EPERM;
 		}
 
-		disable = 0;
+		disable = IXGBE_VMOLR_VPE;
 		enable = IXGBE_VMOLR_BAM | IXGBE_VMOLR_ROMPE |
-			 IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE | IXGBE_VMOLR_VPE;
+			 IXGBE_VMOLR_MPE | IXGBE_VMOLR_UPE;
 		break;
 	default:
 		return -EOPNOTSUPP;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
index a73a8017e0ee..e3a317442c8c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cpt.c
@@ -579,7 +579,7 @@ static bool is_valid_offset(struct rvu *rvu, struct cpt_rd_wr_reg_msg *req)
 
 	blkaddr = validate_and_get_cpt_blkaddr(req->blkaddr);
 	if (blkaddr < 0)
-		return blkaddr;
+		return false;
 
 	/* Registers that can be accessed from PF/VF */
 	if ((offset & 0xFF000) ==  CPT_AF_LFX_CTL(0) ||
diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index f02d07ec5ccb..a50090e62c8f 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1949,6 +1949,9 @@ static int mtk_hwlro_get_fdir_entry(struct net_device *dev,
 	struct ethtool_rx_flow_spec *fsp =
 		(struct ethtool_rx_flow_spec *)&cmd->fs;
 
+	if (fsp->location >= ARRAY_SIZE(mac->hwlro_ip))
+		return -EINVAL;
+
 	/* only tcp dst ipv4 is meaningful, others are meaningless */
 	fsp->flow_type = TCP_V4_FLOW;
 	fsp->h_u.tcp_ip4_spec.ip4dst = ntohl(mac->hwlro_ip[fsp->location]);
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
index ed5038d98ef6..6400a827173c 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
@@ -2110,7 +2110,7 @@ static int mlx4_en_get_module_eeprom(struct net_device *dev,
 			en_err(priv,
 			       "mlx4_get_module_info i(%d) offset(%d) bytes_to_read(%d) - FAILED (0x%x)\n",
 			       i, offset, ee->len - i, ret);
-			return 0;
+			return ret;
 		}
 
 		i += ret;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dev.c b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
index ba6dad97e308..c4ca4e157ff7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dev.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dev.c
@@ -555,12 +555,9 @@ static u32 mlx5_gen_pci_id(const struct mlx5_core_dev *dev)
 		     PCI_SLOT(dev->pdev->devfn));
 }
 
-static int next_phys_dev(struct device *dev, const void *data)
+static int _next_phys_dev(struct mlx5_core_dev *mdev,
+			  const struct mlx5_core_dev *curr)
 {
-	struct mlx5_adev *madev = container_of(dev, struct mlx5_adev, adev.dev);
-	struct mlx5_core_dev *mdev = madev->mdev;
-	const struct mlx5_core_dev *curr = data;
-
 	if (!mlx5_core_is_pf(mdev))
 		return 0;
 
@@ -574,22 +571,51 @@ static int next_phys_dev(struct device *dev, const void *data)
 	return 1;
 }
 
-/* Must be called with intf_mutex held */
-struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev)
+static void *pci_get_other_drvdata(struct device *this, struct device *other)
 {
-	struct auxiliary_device *adev;
-	struct mlx5_adev *madev;
+	if (this->driver != other->driver)
+		return NULL;
+
+	return pci_get_drvdata(to_pci_dev(other));
+}
+
+static int next_phys_dev_lag(struct device *dev, const void *data)
+{
+	struct mlx5_core_dev *mdev, *this = (struct mlx5_core_dev *)data;
+
+	mdev = pci_get_other_drvdata(this->device, dev);
+	if (!mdev)
+		return 0;
+
+	if (!MLX5_CAP_GEN(mdev, vport_group_manager) ||
+	    !MLX5_CAP_GEN(mdev, lag_master) ||
+	    MLX5_CAP_GEN(mdev, num_lag_ports) != MLX5_MAX_PORTS)
+		return 0;
+
+	return _next_phys_dev(mdev, data);
+}
+
+static struct mlx5_core_dev *mlx5_get_next_dev(struct mlx5_core_dev *dev,
+					       int (*match)(struct device *dev, const void *data))
+{
+	struct device *next;
 
 	if (!mlx5_core_is_pf(dev))
 		return NULL;
 
-	adev = auxiliary_find_device(NULL, dev, &next_phys_dev);
-	if (!adev)
+	next = bus_find_device(&pci_bus_type, NULL, dev, match);
+	if (!next)
 		return NULL;
 
-	madev = container_of(adev, struct mlx5_adev, adev);
-	put_device(&adev->dev);
-	return madev->mdev;
+	put_device(next);
+	return pci_get_drvdata(to_pci_dev(next));
+}
+
+/* Must be called with intf_mutex held */
+struct mlx5_core_dev *mlx5_get_next_phys_dev_lag(struct mlx5_core_dev *dev)
+{
+	lockdep_assert_held(&mlx5_intf_mutex);
+	return mlx5_get_next_dev(dev, &next_phys_dev_lag);
 }
 
 void mlx5_dev_list_lock(void)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index eae9aa9c0811..978a2bb8e122 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -675,6 +675,9 @@ static void mlx5_fw_tracer_handle_traces(struct work_struct *work)
 	if (!tracer->owner)
 		return;
 
+	if (unlikely(!tracer->str_db.loaded))
+		goto arm;
+
 	block_count = tracer->buff.size / TRACER_BLOCK_SIZE_BYTE;
 	start_offset = tracer->buff.consumer_index * TRACER_BLOCK_SIZE_BYTE;
 
@@ -732,6 +735,7 @@ static void mlx5_fw_tracer_handle_traces(struct work_struct *work)
 						      &tmp_trace_block[TRACES_PER_BLOCK - 1]);
 	}
 
+arm:
 	mlx5_fw_tracer_arm(dev);
 }
 
@@ -1136,8 +1140,7 @@ static int fw_tracer_event(struct notifier_block *nb, unsigned long action, void
 		queue_work(tracer->work_queue, &tracer->ownership_change_work);
 		break;
 	case MLX5_TRACER_SUBTYPE_TRACES_AVAILABLE:
-		if (likely(tracer->str_db.loaded))
-			queue_work(tracer->work_queue, &tracer->handle_traces_work);
+		queue_work(tracer->work_queue, &tracer->handle_traces_work);
 		break;
 	default:
 		mlx5_core_dbg(dev, "FWTracer: Event with unrecognized subtype: sub_type %d\n",
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 5ccd6c634274..4c8c8e4c1ef3 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -730,6 +730,7 @@ struct mlx5e_rq {
 	u8                     wq_type;
 	u32                    rqn;
 	struct mlx5_core_dev  *mdev;
+	struct mlx5e_channel  *channel;
 	u32  umr_mkey;
 	struct mlx5e_dma_info  wqe_overflow;
 
@@ -1044,6 +1045,9 @@ void mlx5e_close_cq(struct mlx5e_cq *cq);
 int mlx5e_open_locked(struct net_device *netdev);
 int mlx5e_close_locked(struct net_device *netdev);
 
+void mlx5e_trigger_napi_icosq(struct mlx5e_channel *c);
+void mlx5e_trigger_napi_sched(struct napi_struct *napi);
+
 int mlx5e_open_channels(struct mlx5e_priv *priv,
 			struct mlx5e_channels *chs);
 void mlx5e_close_channels(struct mlx5e_channels *chs);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 678ffbb48a25..e3e8c1c3ff24 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -12,6 +12,7 @@ struct mlx5e_post_act;
 enum {
 	MLX5E_TC_FT_LEVEL = 0,
 	MLX5E_TC_TTC_FT_LEVEL,
+	MLX5E_TC_MISS_LEVEL,
 };
 
 struct mlx5e_tc_table {
@@ -20,6 +21,7 @@ struct mlx5e_tc_table {
 	 */
 	struct mutex			t_lock;
 	struct mlx5_flow_table		*t;
+	struct mlx5_flow_table		*miss_t;
 	struct mlx5_fs_chains           *chains;
 	struct mlx5e_post_act		*post_act;
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
index 82baafd3c00c..fdb82f2b0130 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/ptp.c
@@ -737,6 +737,7 @@ void mlx5e_ptp_activate_channel(struct mlx5e_ptp *c)
 	if (test_bit(MLX5E_PTP_STATE_RX, c->state)) {
 		mlx5e_ptp_rx_set_fs(c->priv);
 		mlx5e_activate_rq(&c->rq);
+		mlx5e_trigger_napi_sched(&c->napi);
 	}
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
index 2684e9da9f41..fc366e66d0b0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_rx.c
@@ -123,6 +123,8 @@ static int mlx5e_rx_reporter_err_icosq_cqe_recover(void *ctx)
 		xskrq->stats->recover++;
 	}
 
+	mlx5e_trigger_napi_icosq(icosq->channel);
+
 	mutex_unlock(&icosq->channel->icosq_recovery_lock);
 
 	return 0;
@@ -166,6 +168,10 @@ static int mlx5e_rx_reporter_err_rq_cqe_recover(void *ctx)
 	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
 	mlx5e_activate_rq(rq);
 	rq->stats->recover++;
+	if (rq->channel)
+		mlx5e_trigger_napi_icosq(rq->channel);
+	else
+		mlx5e_trigger_napi_sched(rq->cq.napi);
 	return 0;
 out:
 	clear_bit(MLX5E_RQ_STATE_RECOVERING, &rq->state);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 9028e9958c72..cf9d48d934ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -692,7 +692,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 				struct mlx5_flow_attr *attr,
 				struct flow_rule *flow_rule,
 				struct mlx5e_mod_hdr_handle **mh,
-				u8 zone_restore_id, bool nat)
+				u8 zone_restore_id, bool nat_table, bool has_nat)
 {
 	DECLARE_MOD_HDR_ACTS_ACTIONS(actions_arr, MLX5_CT_MIN_MOD_ACTS);
 	DECLARE_MOD_HDR_ACTS(mod_acts, actions_arr);
@@ -708,11 +708,12 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 				     &attr->ct_attr.ct_labels_id);
 	if (err)
 		return -EOPNOTSUPP;
-	if (nat) {
-		err = mlx5_tc_ct_entry_create_nat(ct_priv, flow_rule,
-						  &mod_acts);
-		if (err)
-			goto err_mapping;
+	if (nat_table) {
+		if (has_nat) {
+			err = mlx5_tc_ct_entry_create_nat(ct_priv, flow_rule, &mod_acts);
+			if (err)
+				goto err_mapping;
+		}
 
 		ct_state |= MLX5_CT_STATE_NAT_BIT;
 	}
@@ -727,7 +728,7 @@ mlx5_tc_ct_entry_create_mod_hdr(struct mlx5_tc_ct_priv *ct_priv,
 	if (err)
 		goto err_mapping;
 
-	if (nat) {
+	if (nat_table && has_nat) {
 		attr->modify_hdr = mlx5_modify_header_alloc(ct_priv->dev, ct_priv->ns_type,
 							    mod_acts.num_actions,
 							    mod_acts.actions);
@@ -795,7 +796,9 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 
 	err = mlx5_tc_ct_entry_create_mod_hdr(ct_priv, attr, flow_rule,
 					      &zone_rule->mh,
-					      zone_restore_id, nat);
+					      zone_restore_id,
+					      nat,
+					      mlx5_tc_ct_entry_has_nat(entry));
 	if (err) {
 		ct_dbg("Failed to create ct entry mod hdr");
 		goto err_mod_hdr;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
index a55b066746cb..6dd36e3cf425 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/trap.c
@@ -172,6 +172,7 @@ static void mlx5e_activate_trap(struct mlx5e_trap *trap)
 {
 	napi_enable(&trap->napi);
 	mlx5e_activate_rq(&trap->rq);
+	mlx5e_trigger_napi_sched(&trap->napi);
 }
 
 void mlx5e_deactivate_trap(struct mlx5e_priv *priv)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
index 279cd8f4e79f..2c520394aa1d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/pool.c
@@ -117,6 +117,7 @@ static int mlx5e_xsk_enable_locked(struct mlx5e_priv *priv,
 		goto err_remove_pool;
 
 	mlx5e_activate_xsk(c);
+	mlx5e_trigger_napi_icosq(c);
 
 	/* Don't wait for WQEs, because the newer xdpsock sample doesn't provide
 	 * any Fill Ring entries at the setup stage.
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index 25eac9e20342..5a2cd15e245d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -64,6 +64,7 @@ static int mlx5e_init_xsk_rq(struct mlx5e_channel *c,
 	rq->clock        = &mdev->clock;
 	rq->icosq        = &c->icosq;
 	rq->ix           = c->ix;
+	rq->channel      = c;
 	rq->mdev         = mdev;
 	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	rq->xdpsq        = &c->rq_xdpsq;
@@ -179,10 +180,6 @@ void mlx5e_activate_xsk(struct mlx5e_channel *c)
 	mlx5e_reporter_icosq_resume_recovery(c);
 
 	/* TX queue is created active. */
-
-	spin_lock_bh(&c->async_icosq_lock);
-	mlx5e_trigger_irq(&c->async_icosq);
-	spin_unlock_bh(&c->async_icosq_lock);
 }
 
 void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 531fffe1abe3..352b5c8ae24e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -477,6 +477,7 @@ static int mlx5e_init_rxq_rq(struct mlx5e_channel *c, struct mlx5e_params *param
 	rq->clock        = &mdev->clock;
 	rq->icosq        = &c->icosq;
 	rq->ix           = c->ix;
+	rq->channel      = c;
 	rq->mdev         = mdev;
 	rq->hw_mtu       = MLX5E_SW2HW_MTU(params, params->sw_mtu);
 	rq->xdpsq        = &c->rq_xdpsq;
@@ -1070,13 +1071,6 @@ int mlx5e_open_rq(struct mlx5e_params *params, struct mlx5e_rq_param *param,
 void mlx5e_activate_rq(struct mlx5e_rq *rq)
 {
 	set_bit(MLX5E_RQ_STATE_ENABLED, &rq->state);
-	if (rq->icosq) {
-		mlx5e_trigger_irq(rq->icosq);
-	} else {
-		local_bh_disable();
-		napi_schedule(rq->cq.napi);
-		local_bh_enable();
-	}
 }
 
 void mlx5e_deactivate_rq(struct mlx5e_rq *rq)
@@ -2218,6 +2212,20 @@ static int mlx5e_channel_stats_alloc(struct mlx5e_priv *priv, int ix, int cpu)
 	return 0;
 }
 
+void mlx5e_trigger_napi_icosq(struct mlx5e_channel *c)
+{
+	spin_lock_bh(&c->async_icosq_lock);
+	mlx5e_trigger_irq(&c->async_icosq);
+	spin_unlock_bh(&c->async_icosq_lock);
+}
+
+void mlx5e_trigger_napi_sched(struct napi_struct *napi)
+{
+	local_bh_disable();
+	napi_schedule(napi);
+	local_bh_enable();
+}
+
 static int mlx5e_open_channel(struct mlx5e_priv *priv, int ix,
 			      struct mlx5e_params *params,
 			      struct mlx5e_channel_param *cparam,
@@ -2299,6 +2307,8 @@ static void mlx5e_activate_channel(struct mlx5e_channel *c)
 
 	if (test_bit(MLX5E_CHANNEL_STATE_XSK, c->state))
 		mlx5e_activate_xsk(c);
+
+	mlx5e_trigger_napi_icosq(c);
 }
 
 static void mlx5e_deactivate_channel(struct mlx5e_channel *c)
@@ -4521,6 +4531,11 @@ static int mlx5e_xdp_set(struct net_device *netdev, struct bpf_prog *prog)
 
 unlock:
 	mutex_unlock(&priv->state_lock);
+
+	/* Need to fix some features. */
+	if (!err)
+		netdev_update_features(netdev);
+
 	return err;
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index e0f45cef97c3..deff6698f395 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4284,6 +4284,33 @@ static int mlx5e_tc_nic_get_ft_size(struct mlx5_core_dev *dev)
 	return tc_tbl_size;
 }
 
+static int mlx5e_tc_nic_create_miss_table(struct mlx5e_priv *priv)
+{
+	struct mlx5_flow_table **ft = &priv->fs.tc.miss_t;
+	struct mlx5_flow_table_attr ft_attr = {};
+	struct mlx5_flow_namespace *ns;
+	int err = 0;
+
+	ft_attr.max_fte = 1;
+	ft_attr.autogroup.max_num_groups = 1;
+	ft_attr.level = MLX5E_TC_MISS_LEVEL;
+	ft_attr.prio = 0;
+	ns = mlx5_get_flow_namespace(priv->mdev, MLX5_FLOW_NAMESPACE_KERNEL);
+
+	*ft = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
+	if (IS_ERR(*ft)) {
+		err = PTR_ERR(*ft);
+		netdev_err(priv->netdev, "failed to create tc nic miss table err=%d\n", err);
+	}
+
+	return err;
+}
+
+static void mlx5e_tc_nic_destroy_miss_table(struct mlx5e_priv *priv)
+{
+	mlx5_destroy_flow_table(priv->fs.tc.miss_t);
+}
+
 int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 {
 	struct mlx5e_tc_table *tc = &priv->fs.tc;
@@ -4316,19 +4343,23 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	}
 	tc->mapping = chains_mapping;
 
+	err = mlx5e_tc_nic_create_miss_table(priv);
+	if (err)
+		goto err_chains;
+
 	if (MLX5_CAP_FLOWTABLE_NIC_RX(priv->mdev, ignore_flow_level))
 		attr.flags = MLX5_CHAINS_AND_PRIOS_SUPPORTED |
 			MLX5_CHAINS_IGNORE_FLOW_LEVEL_SUPPORTED;
 	attr.ns = MLX5_FLOW_NAMESPACE_KERNEL;
 	attr.max_ft_sz = mlx5e_tc_nic_get_ft_size(dev);
 	attr.max_grp_num = MLX5E_TC_TABLE_NUM_GROUPS;
-	attr.default_ft = mlx5e_vlan_get_flowtable(priv->fs.vlan);
+	attr.default_ft = priv->fs.tc.miss_t;
 	attr.mapping = chains_mapping;
 
 	tc->chains = mlx5_chains_create(dev, &attr);
 	if (IS_ERR(tc->chains)) {
 		err = PTR_ERR(tc->chains);
-		goto err_chains;
+		goto err_miss;
 	}
 
 	tc->post_act = mlx5e_tc_post_act_init(priv, tc->chains, MLX5_FLOW_NAMESPACE_KERNEL);
@@ -4351,6 +4382,8 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
 	mlx5_tc_ct_clean(tc->ct);
 	mlx5e_tc_post_act_destroy(tc->post_act);
 	mlx5_chains_destroy(tc->chains);
+err_miss:
+	mlx5e_tc_nic_destroy_miss_table(priv);
 err_chains:
 	mapping_destroy(chains_mapping);
 err_mapping:
@@ -4391,6 +4424,7 @@ void mlx5e_tc_nic_cleanup(struct mlx5e_priv *priv)
 	mlx5e_tc_post_act_destroy(tc->post_act);
 	mapping_destroy(tc->mapping);
 	mlx5_chains_destroy(tc->chains);
+	mlx5e_tc_nic_destroy_miss_table(priv);
 }
 
 int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index cebfa8565c9d..c70cefbcd9ea 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -49,6 +49,7 @@
 #include "en_tc.h"
 #include "en/mapping.h"
 #include "devlink.h"
+#include "lag/lag.h"
 
 #define mlx5_esw_for_each_rep(esw, i, rep) \
 	xa_for_each(&((esw)->offloads.vport_reps), i, rep)
@@ -2749,9 +2750,6 @@ static int mlx5_esw_offloads_devcom_event(int event,
 
 	switch (event) {
 	case ESW_OFFLOADS_DEVCOM_PAIR:
-		if (mlx5_get_next_phys_dev(esw->dev) != peer_esw->dev)
-			break;
-
 		if (mlx5_eswitch_vport_match_metadata_enabled(esw) !=
 		    mlx5_eswitch_vport_match_metadata_enabled(peer_esw))
 			break;
@@ -2803,6 +2801,9 @@ static void esw_offloads_devcom_init(struct mlx5_eswitch *esw)
 	if (!MLX5_CAP_ESW(esw->dev, merged_eswitch))
 		return;
 
+	if (!mlx5_is_lag_supported(esw->dev))
+		return;
+
 	mlx5_devcom_register_component(devcom,
 				       MLX5_DEVCOM_ESW_OFFLOADS,
 				       mlx5_esw_offloads_devcom_event,
@@ -2820,6 +2821,9 @@ static void esw_offloads_devcom_cleanup(struct mlx5_eswitch *esw)
 	if (!MLX5_CAP_ESW(esw->dev, merged_eswitch))
 		return;
 
+	if (!mlx5_is_lag_supported(esw->dev))
+		return;
+
 	mlx5_devcom_send_event(devcom, MLX5_DEVCOM_ESW_OFFLOADS,
 			       ESW_OFFLOADS_DEVCOM_UNPAIR, esw);
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 298c614c631b..add55195335c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -116,7 +116,7 @@
 #define KERNEL_MIN_LEVEL (KERNEL_NIC_PRIO_NUM_LEVELS + 1)
 
 #define KERNEL_NIC_TC_NUM_PRIOS  1
-#define KERNEL_NIC_TC_NUM_LEVELS 2
+#define KERNEL_NIC_TC_NUM_LEVELS 3
 
 #define ANCHOR_NUM_LEVELS 1
 #define ANCHOR_NUM_PRIOS 1
@@ -1560,9 +1560,22 @@ static struct mlx5_flow_rule *find_flow_rule(struct fs_fte *fte,
 	return NULL;
 }
 
-static bool check_conflicting_actions(u32 action1, u32 action2)
+static bool check_conflicting_actions_vlan(const struct mlx5_fs_vlan *vlan0,
+					   const struct mlx5_fs_vlan *vlan1)
 {
-	u32 xored_actions = action1 ^ action2;
+	return vlan0->ethtype != vlan1->ethtype ||
+	       vlan0->vid != vlan1->vid ||
+	       vlan0->prio != vlan1->prio;
+}
+
+static bool check_conflicting_actions(const struct mlx5_flow_act *act1,
+				      const struct mlx5_flow_act *act2)
+{
+	u32 action1 = act1->action;
+	u32 action2 = act2->action;
+	u32 xored_actions;
+
+	xored_actions = action1 ^ action2;
 
 	/* if one rule only wants to count, it's ok */
 	if (action1 == MLX5_FLOW_CONTEXT_ACTION_COUNT ||
@@ -1579,6 +1592,22 @@ static bool check_conflicting_actions(u32 action1, u32 action2)
 			     MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2))
 		return true;
 
+	if (action1 & MLX5_FLOW_CONTEXT_ACTION_PACKET_REFORMAT &&
+	    act1->pkt_reformat != act2->pkt_reformat)
+		return true;
+
+	if (action1 & MLX5_FLOW_CONTEXT_ACTION_MOD_HDR &&
+	    act1->modify_hdr != act2->modify_hdr)
+		return true;
+
+	if (action1 & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH &&
+	    check_conflicting_actions_vlan(&act1->vlan[0], &act2->vlan[0]))
+		return true;
+
+	if (action1 & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH_2 &&
+	    check_conflicting_actions_vlan(&act1->vlan[1], &act2->vlan[1]))
+		return true;
+
 	return false;
 }
 
@@ -1586,7 +1615,7 @@ static int check_conflicting_ftes(struct fs_fte *fte,
 				  const struct mlx5_flow_context *flow_context,
 				  const struct mlx5_flow_act *flow_act)
 {
-	if (check_conflicting_actions(flow_act->action, fte->action.action)) {
+	if (check_conflicting_actions(flow_act, &fte->action)) {
 		mlx5_core_warn(get_dev(&fte->node),
 			       "Found two FTEs with conflicting actions\n");
 		return -EEXIST;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
index 4ddf6b330a44..d4629f9bdab1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.c
@@ -804,12 +804,7 @@ static int __mlx5_lag_dev_add_mdev(struct mlx5_core_dev *dev)
 	struct mlx5_lag *ldev = NULL;
 	struct mlx5_core_dev *tmp_dev;
 
-	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
-	    !MLX5_CAP_GEN(dev, lag_master) ||
-	    MLX5_CAP_GEN(dev, num_lag_ports) != MLX5_MAX_PORTS)
-		return 0;
-
-	tmp_dev = mlx5_get_next_phys_dev(dev);
+	tmp_dev = mlx5_get_next_phys_dev_lag(dev);
 	if (tmp_dev)
 		ldev = tmp_dev->priv.lag;
 
@@ -854,6 +849,11 @@ void mlx5_lag_add_mdev(struct mlx5_core_dev *dev)
 {
 	int err;
 
+	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
+	    !MLX5_CAP_GEN(dev, lag_master) ||
+	    MLX5_CAP_GEN(dev, num_lag_ports) != MLX5_MAX_PORTS)
+		return;
+
 recheck:
 	mlx5_dev_list_lock();
 	err = __mlx5_lag_dev_add_mdev(dev);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
index e5d231c31b54..b5edf0c8b0ed 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag/lag.h
@@ -56,6 +56,16 @@ struct mlx5_lag {
 	struct mlx5_lag_port_sel  port_sel;
 };
 
+static inline bool mlx5_is_lag_supported(struct mlx5_core_dev *dev)
+{
+	if (!MLX5_CAP_GEN(dev, vport_group_manager) ||
+	    !MLX5_CAP_GEN(dev, lag_master) ||
+	    MLX5_CAP_GEN(dev, num_lag_ports) < 2 ||
+	    MLX5_CAP_GEN(dev, num_lag_ports) > MLX5_MAX_PORTS)
+		return false;
+	return true;
+}
+
 static inline struct mlx5_lag *
 mlx5_lag_dev(struct mlx5_core_dev *dev)
 {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
index 2d2150fc7a0f..83b52bc5cefd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.h
@@ -209,7 +209,7 @@ int mlx5_attach_device(struct mlx5_core_dev *dev);
 void mlx5_detach_device(struct mlx5_core_dev *dev);
 int mlx5_register_device(struct mlx5_core_dev *dev);
 void mlx5_unregister_device(struct mlx5_core_dev *dev);
-struct mlx5_core_dev *mlx5_get_next_phys_dev(struct mlx5_core_dev *dev);
+struct mlx5_core_dev *mlx5_get_next_phys_dev_lag(struct mlx5_core_dev *dev);
 void mlx5_dev_list_lock(void);
 void mlx5_dev_list_unlock(void);
 int mlx5_dev_list_trylock(void);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
index 05393fe11132..caeaa3c29353 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/fs_dr.c
@@ -44,11 +44,10 @@ static int set_miss_action(struct mlx5_flow_root_namespace *ns,
 	err = mlx5dr_table_set_miss_action(ft->fs_dr_table.dr_table, action);
 	if (err && action) {
 		err = mlx5dr_action_destroy(action);
-		if (err) {
-			action = NULL;
-			mlx5_core_err(ns->dev, "Failed to destroy action (%d)\n",
-				      err);
-		}
+		if (err)
+			mlx5_core_err(ns->dev,
+				      "Failed to destroy action (%d)\n", err);
+		action = NULL;
 	}
 	ft->fs_dr_table.miss_action = action;
 	if (old_miss_action) {
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index fee148bbf13e..b0cb3b65cd5b 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -948,8 +948,13 @@ static int lan966x_probe(struct platform_device *pdev)
 		lan966x->ports[p]->fwnode = fwnode_handle_get(portnp);
 
 		serdes = devm_of_phy_get(lan966x->dev, to_of_node(portnp), NULL);
-		if (!IS_ERR(serdes))
-			lan966x->ports[p]->serdes = serdes;
+		if (PTR_ERR(serdes) == -ENODEV)
+			serdes = NULL;
+		if (IS_ERR(serdes)) {
+			err = PTR_ERR(serdes);
+			goto cleanup_ports;
+		}
+		lan966x->ports[p]->serdes = serdes;
 
 		lan966x_port_init(lan966x->ports[p]);
 	}
diff --git a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
index bfd7d1c35076..7e9fcc16286e 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/conntrack.c
@@ -442,6 +442,11 @@ nfp_fl_calc_key_layers_sz(struct nfp_fl_key_ls in_key_ls, uint16_t *map)
 		key_size += sizeof(struct nfp_flower_ipv6);
 	}
 
+	if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_QINQ) {
+		map[FLOW_PAY_QINQ] = key_size;
+		key_size += sizeof(struct nfp_flower_vlan);
+	}
+
 	if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_GRE) {
 		map[FLOW_PAY_GRE] = key_size;
 		if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6)
@@ -450,11 +455,6 @@ nfp_fl_calc_key_layers_sz(struct nfp_fl_key_ls in_key_ls, uint16_t *map)
 			key_size += sizeof(struct nfp_flower_ipv4_gre_tun);
 	}
 
-	if (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_QINQ) {
-		map[FLOW_PAY_QINQ] = key_size;
-		key_size += sizeof(struct nfp_flower_vlan);
-	}
-
 	if ((in_key_ls.key_layer & NFP_FLOWER_LAYER_VXLAN) ||
 	    (in_key_ls.key_layer_two & NFP_FLOWER_LAYER2_GENEVE)) {
 		map[FLOW_PAY_UDP_TUN] = key_size;
@@ -693,6 +693,17 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 		}
 	}
 
+	if (NFP_FLOWER_LAYER2_QINQ & key_layer.key_layer_two) {
+		offset = key_map[FLOW_PAY_QINQ];
+		key = kdata + offset;
+		msk = mdata + offset;
+		for (i = 0; i < _CT_TYPE_MAX; i++) {
+			nfp_flower_compile_vlan((struct nfp_flower_vlan *)key,
+						(struct nfp_flower_vlan *)msk,
+						rules[i]);
+		}
+	}
+
 	if (key_layer.key_layer_two & NFP_FLOWER_LAYER2_GRE) {
 		offset = key_map[FLOW_PAY_GRE];
 		key = kdata + offset;
@@ -733,17 +744,6 @@ static int nfp_fl_ct_add_offload(struct nfp_fl_nft_tc_merge *m_entry)
 		}
 	}
 
-	if (NFP_FLOWER_LAYER2_QINQ & key_layer.key_layer_two) {
-		offset = key_map[FLOW_PAY_QINQ];
-		key = kdata + offset;
-		msk = mdata + offset;
-		for (i = 0; i < _CT_TYPE_MAX; i++) {
-			nfp_flower_compile_vlan((struct nfp_flower_vlan *)key,
-						(struct nfp_flower_vlan *)msk,
-						rules[i]);
-		}
-	}
-
 	if (key_layer.key_layer & NFP_FLOWER_LAYER_VXLAN ||
 	    key_layer.key_layer_two & NFP_FLOWER_LAYER2_GENEVE) {
 		offset = key_map[FLOW_PAY_UDP_TUN];
diff --git a/drivers/net/ethernet/netronome/nfp/flower/match.c b/drivers/net/ethernet/netronome/nfp/flower/match.c
index 9d86eea4dc16..fb8bd2135c63 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/match.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/match.c
@@ -602,6 +602,14 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 		msk += sizeof(struct nfp_flower_ipv6);
 	}
 
+	if (NFP_FLOWER_LAYER2_QINQ & key_ls->key_layer_two) {
+		nfp_flower_compile_vlan((struct nfp_flower_vlan *)ext,
+					(struct nfp_flower_vlan *)msk,
+					rule);
+		ext += sizeof(struct nfp_flower_vlan);
+		msk += sizeof(struct nfp_flower_vlan);
+	}
+
 	if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_GRE) {
 		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6) {
 			struct nfp_flower_ipv6_gre_tun *gre_match;
@@ -637,14 +645,6 @@ int nfp_flower_compile_flow_match(struct nfp_app *app,
 		}
 	}
 
-	if (NFP_FLOWER_LAYER2_QINQ & key_ls->key_layer_two) {
-		nfp_flower_compile_vlan((struct nfp_flower_vlan *)ext,
-					(struct nfp_flower_vlan *)msk,
-					rule);
-		ext += sizeof(struct nfp_flower_vlan);
-		msk += sizeof(struct nfp_flower_vlan);
-	}
-
 	if (key_ls->key_layer & NFP_FLOWER_LAYER_VXLAN ||
 	    key_ls->key_layer_two & NFP_FLOWER_LAYER2_GENEVE) {
 		if (key_ls->key_layer_two & NFP_FLOWER_LAYER2_TUN_IPV6) {
diff --git a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
index e0c27471bcdb..5e2631aafdb6 100644
--- a/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
+++ b/drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c
@@ -287,8 +287,6 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 
 	/* Init to unknowns */
 	ethtool_link_ksettings_add_link_mode(cmd, supported, FIBRE);
-	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
 	cmd->base.port = PORT_OTHER;
 	cmd->base.speed = SPEED_UNKNOWN;
 	cmd->base.duplex = DUPLEX_UNKNOWN;
@@ -296,6 +294,8 @@ nfp_net_get_link_ksettings(struct net_device *netdev,
 	port = nfp_port_from_netdev(netdev);
 	eth_port = nfp_port_get_eth_port(port);
 	if (eth_port) {
+		ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
+		ethtool_link_ksettings_add_link_mode(cmd, advertising, Pause);
 		cmd->base.autoneg = eth_port->aneg != NFP_ANEG_DISABLED ?
 			AUTONEG_ENABLE : AUTONEG_DISABLE;
 		nfp_net_set_fec_link_mode(eth_port, cmd);
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index eec0db76d888..8ab9358a1c3d 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -309,6 +309,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1;
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
+		efx->tx_channel_offset = 0;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		rc = pci_enable_msi(efx->pci_dev);
@@ -329,6 +330,7 @@ int efx_probe_interrupts(struct efx_nic *efx)
 		efx->n_channels = 1 + (efx_separate_tx_channels ? 1 : 0);
 		efx->n_rx_channels = 1;
 		efx->n_tx_channels = 1;
+		efx->tx_channel_offset = 1;
 		efx->n_xdp_channels = 0;
 		efx->xdp_channel_offset = efx->n_channels;
 		efx->legacy_irq = efx->pci_dev->irq;
@@ -957,10 +959,6 @@ int efx_set_channels(struct efx_nic *efx)
 	struct efx_channel *channel;
 	int rc;
 
-	efx->tx_channel_offset =
-		efx_separate_tx_channels ?
-		efx->n_channels - efx->n_tx_channels : 0;
-
 	if (efx->xdp_tx_queue_count) {
 		EFX_WARN_ON_PARANOID(efx->xdp_tx_queues);
 
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index cc15ee8812d9..8a9eedec177a 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1533,7 +1533,7 @@ static inline bool efx_channel_is_xdp_tx(struct efx_channel *channel)
 
 static inline bool efx_channel_has_tx_queues(struct efx_channel *channel)
 {
-	return true;
+	return channel && channel->channel >= channel->efx->tx_channel_offset;
 }
 
 static inline unsigned int efx_channel_num_tx_queues(struct efx_channel *channel)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 6f87e296a410..502fbbc082fb 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -1073,13 +1073,11 @@ static int intel_eth_pci_probe(struct pci_dev *pdev,
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat, &res);
 	if (ret) {
-		goto err_dvr_probe;
+		goto err_alloc_irq;
 	}
 
 	return 0;
 
-err_dvr_probe:
-	pci_free_irq_vectors(pdev);
 err_alloc_irq:
 	clk_disable_unprepare(plat->stmmac_clk);
 	clk_unregister_fixed_rate(plat->stmmac_clk);
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 8251d7eb001b..eda91336c9f6 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1802,6 +1802,7 @@ static int am65_cpsw_init_cpts(struct am65_cpsw_common *common)
 	if (IS_ERR(cpts)) {
 		int ret = PTR_ERR(cpts);
 
+		of_node_put(node);
 		if (ret == -EOPNOTSUPP) {
 			dev_info(dev, "cpts disabled\n");
 			return 0;
@@ -2669,9 +2670,9 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	if (!node)
 		return -ENOENT;
 	common->port_num = of_get_child_count(node);
+	of_node_put(node);
 	if (common->port_num < 1 || common->port_num > AM65_CPSW_MAX_PORTS)
 		return -ENOENT;
-	of_node_put(node);
 
 	common->rx_flow_id_base = -1;
 	init_completion(&common->tdown_complete);
diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 3d0874331763..b901acca098b 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -99,6 +99,7 @@ struct pcpu_secy_stats {
  * struct macsec_dev - private data
  * @secy: SecY config
  * @real_dev: pointer to underlying netdevice
+ * @dev_tracker: refcount tracker for @real_dev reference
  * @stats: MACsec device stats
  * @secys: linked list of SecY's on the underlying device
  * @gro_cells: pointer to the Generic Receive Offload cell
@@ -107,6 +108,7 @@ struct pcpu_secy_stats {
 struct macsec_dev {
 	struct macsec_secy secy;
 	struct net_device *real_dev;
+	netdevice_tracker dev_tracker;
 	struct pcpu_secy_stats __percpu *stats;
 	struct list_head secys;
 	struct gro_cells gro_cells;
@@ -3459,6 +3461,9 @@ static int macsec_dev_init(struct net_device *dev)
 	if (is_zero_ether_addr(dev->broadcast))
 		memcpy(dev->broadcast, real_dev->broadcast, dev->addr_len);
 
+	/* Get macsec's reference to real_dev */
+	dev_hold_track(real_dev, &macsec->dev_tracker, GFP_KERNEL);
+
 	return 0;
 }
 
@@ -3704,6 +3709,8 @@ static void macsec_free_netdev(struct net_device *dev)
 	free_percpu(macsec->stats);
 	free_percpu(macsec->secy.tx_sc.stats);
 
+	/* Get rid of the macsec's reference to real_dev */
+	dev_put_track(macsec->real_dev, &macsec->dev_tracker);
 }
 
 static void macsec_setup(struct net_device *dev)
diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
index 8561f2d4443b..13dafe7a29bd 100644
--- a/drivers/net/phy/dp83867.c
+++ b/drivers/net/phy/dp83867.c
@@ -137,6 +137,7 @@
 #define DP83867_DOWNSHIFT_2_COUNT	2
 #define DP83867_DOWNSHIFT_4_COUNT	4
 #define DP83867_DOWNSHIFT_8_COUNT	8
+#define DP83867_SGMII_AUTONEG_EN	BIT(7)
 
 /* CFG3 bits */
 #define DP83867_CFG3_INT_OE			BIT(7)
@@ -855,6 +856,32 @@ static int dp83867_phy_reset(struct phy_device *phydev)
 			 DP83867_PHYCR_FORCE_LINK_GOOD, 0);
 }
 
+static void dp83867_link_change_notify(struct phy_device *phydev)
+{
+	/* There is a limitation in DP83867 PHY device where SGMII AN is
+	 * only triggered once after the device is booted up. Even after the
+	 * PHY TPI is down and up again, SGMII AN is not triggered and
+	 * hence no new in-band message from PHY to MAC side SGMII.
+	 * This could cause an issue during power up, when PHY is up prior
+	 * to MAC. At this condition, once MAC side SGMII is up, MAC side
+	 * SGMII wouldn`t receive new in-band message from TI PHY with
+	 * correct link status, speed and duplex info.
+	 * Thus, implemented a SW solution here to retrigger SGMII Auto-Neg
+	 * whenever there is a link change.
+	 */
+	if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
+		int val = 0;
+
+		val = phy_clear_bits(phydev, DP83867_CFG2,
+				     DP83867_SGMII_AUTONEG_EN);
+		if (val < 0)
+			return;
+
+		phy_set_bits(phydev, DP83867_CFG2,
+			     DP83867_SGMII_AUTONEG_EN);
+	}
+}
+
 static struct phy_driver dp83867_driver[] = {
 	{
 		.phy_id		= DP83867_PHY_ID,
@@ -879,6 +906,8 @@ static struct phy_driver dp83867_driver[] = {
 
 		.suspend	= genphy_suspend,
 		.resume		= genphy_resume,
+
+		.link_change_notify = dp83867_link_change_notify,
 	},
 };
 module_phy_driver(dp83867_driver);
diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 58d602985877..8a2dbe849866 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -1046,7 +1046,6 @@ int __init mdio_bus_init(void)
 
 	return ret;
 }
-EXPORT_SYMBOL_GPL(mdio_bus_init);
 
 #if IS_ENABLED(CONFIG_PHYLIB)
 void mdio_bus_exit(void)
diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index 7e213f8ddc98..df8d27cf2956 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -300,6 +300,8 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 	int r = 0;
 	struct device *dev = &hdev->ndev->dev;
 	struct nfc_evt_transaction *transaction;
+	u32 aid_len;
+	u8 params_len;
 
 	pr_debug("connectivity gate event: %x\n", event);
 
@@ -308,43 +310,48 @@ int st21nfca_connectivity_event_received(struct nfc_hci_dev *hdev, u8 host,
 		r = nfc_se_connectivity(hdev->ndev, host);
 	break;
 	case ST21NFCA_EVT_TRANSACTION:
-		/*
-		 * According to specification etsi 102 622
+		/* According to specification etsi 102 622
 		 * 11.2.2.4 EVT_TRANSACTION Table 52
 		 * Description	Tag	Length
 		 * AID		81	5 to 16
 		 * PARAMETERS	82	0 to 255
+		 *
+		 * The key differences are aid storage length is variably sized
+		 * in the packet, but fixed in nfc_evt_transaction, and that the aid_len
+		 * is u8 in the packet, but u32 in the structure, and the tags in
+		 * the packet are not included in nfc_evt_transaction.
+		 *
+		 * size in bytes: 1          1       5-16 1             1           0-255
+		 * offset:        0          1       2    aid_len + 2   aid_len + 3 aid_len + 4
+		 * member name:   aid_tag(M) aid_len aid  params_tag(M) params_len  params
+		 * example:       0x81       5-16    X    0x82 0-255    X
 		 */
-		if (skb->len < NFC_MIN_AID_LENGTH + 2 &&
-		    skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
+		if (skb->len < 2 || skb->data[0] != NFC_EVT_TRANSACTION_AID_TAG)
 			return -EPROTO;
 
-		transaction = devm_kzalloc(dev, skb->len - 2, GFP_KERNEL);
-		if (!transaction)
-			return -ENOMEM;
-
-		transaction->aid_len = skb->data[1];
+		aid_len = skb->data[1];
 
-		/* Checking if the length of the AID is valid */
-		if (transaction->aid_len > sizeof(transaction->aid))
-			return -EINVAL;
+		if (skb->len < aid_len + 4 || aid_len > sizeof(transaction->aid))
+			return -EPROTO;
 
-		memcpy(transaction->aid, &skb->data[2],
-		       transaction->aid_len);
+		params_len = skb->data[aid_len + 3];
 
-		/* Check next byte is PARAMETERS tag (82) */
-		if (skb->data[transaction->aid_len + 2] !=
-		    NFC_EVT_TRANSACTION_PARAMS_TAG)
+		/* Verify PARAMETERS tag is (82), and final check that there is enough
+		 * space in the packet to read everything.
+		 */
+		if ((skb->data[aid_len + 2] != NFC_EVT_TRANSACTION_PARAMS_TAG) ||
+		    (skb->len < aid_len + 4 + params_len))
 			return -EPROTO;
 
-		transaction->params_len = skb->data[transaction->aid_len + 3];
+		transaction = devm_kzalloc(dev, sizeof(*transaction) + params_len, GFP_KERNEL);
+		if (!transaction)
+			return -ENOMEM;
 
-		/* Total size is allocated (skb->len - 2) minus fixed array members */
-		if (transaction->params_len > ((skb->len - 2) - sizeof(struct nfc_evt_transaction)))
-			return -EINVAL;
+		transaction->aid_len = aid_len;
+		transaction->params_len = params_len;
 
-		memcpy(transaction->params, skb->data +
-		       transaction->aid_len + 4, transaction->params_len);
+		memcpy(transaction->aid, &skb->data[2], aid_len);
+		memcpy(transaction->params, &skb->data[aid_len + 4], params_len);
 
 		r = nfc_se_transaction(hdev->ndev, host, transaction);
 	break;
diff --git a/drivers/pci/controller/dwc/pcie-qcom.c b/drivers/pci/controller/dwc/pcie-qcom.c
index 1bbce48e301e..a84216f4cd58 100644
--- a/drivers/pci/controller/dwc/pcie-qcom.c
+++ b/drivers/pci/controller/dwc/pcie-qcom.c
@@ -1230,12 +1230,6 @@ static int qcom_pcie_init_2_7_0(struct qcom_pcie *pcie)
 		goto err_disable_clocks;
 	}
 
-	ret = clk_prepare_enable(res->pipe_clk);
-	if (ret) {
-		dev_err(dev, "cannot prepare/enable pipe clock\n");
-		goto err_disable_clocks;
-	}
-
 	/* configure PCIe to RC mode */
 	writel(DEVICE_TYPE_RC, pcie->parf + PCIE20_PARF_DEVICE_TYPE);
 
diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index 375c0c40bbf8..e61058e13818 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -24,7 +24,6 @@
 #include <linux/pci.h>
 #include <linux/pci-ecam.h>
 #include <linux/printk.h>
-#include <linux/regulator/consumer.h>
 #include <linux/reset.h>
 #include <linux/sizes.h>
 #include <linux/slab.h>
@@ -196,8 +195,6 @@ static inline void brcm_pcie_bridge_sw_init_set_generic(struct brcm_pcie *pcie,
 static inline void brcm_pcie_perst_set_4908(struct brcm_pcie *pcie, u32 val);
 static inline void brcm_pcie_perst_set_7278(struct brcm_pcie *pcie, u32 val);
 static inline void brcm_pcie_perst_set_generic(struct brcm_pcie *pcie, u32 val);
-static int brcm_pcie_linkup(struct brcm_pcie *pcie);
-static int brcm_pcie_add_bus(struct pci_bus *bus);
 
 enum {
 	RGR1_SW_INIT_1,
@@ -286,14 +283,6 @@ static const struct pcie_cfg_data bcm2711_cfg = {
 	.bridge_sw_init_set = brcm_pcie_bridge_sw_init_set_generic,
 };
 
-struct subdev_regulators {
-	unsigned int num_supplies;
-	struct regulator_bulk_data supplies[];
-};
-
-static int pci_subdev_regulators_add_bus(struct pci_bus *bus);
-static void pci_subdev_regulators_remove_bus(struct pci_bus *bus);
-
 struct brcm_msi {
 	struct device		*dev;
 	void __iomem		*base;
@@ -331,9 +320,6 @@ struct brcm_pcie {
 	u32			hw_rev;
 	void			(*perst_set)(struct brcm_pcie *pcie, u32 val);
 	void			(*bridge_sw_init_set)(struct brcm_pcie *pcie, u32 val);
-	bool			refusal_mode;
-	struct subdev_regulators *sr;
-	bool			ep_wakeup_capable;
 };
 
 static inline bool is_bmips(const struct brcm_pcie *pcie)
@@ -450,99 +436,6 @@ static int brcm_pcie_set_ssc(struct brcm_pcie *pcie)
 	return ssc && pll ? 0 : -EIO;
 }
 
-static void *alloc_subdev_regulators(struct device *dev)
-{
-	static const char * const supplies[] = {
-		"vpcie3v3",
-		"vpcie3v3aux",
-		"vpcie12v",
-	};
-	const size_t size = sizeof(struct subdev_regulators)
-		+ sizeof(struct regulator_bulk_data) * ARRAY_SIZE(supplies);
-	struct subdev_regulators *sr;
-	int i;
-
-	sr = devm_kzalloc(dev, size, GFP_KERNEL);
-	if (sr) {
-		sr->num_supplies = ARRAY_SIZE(supplies);
-		for (i = 0; i < ARRAY_SIZE(supplies); i++)
-			sr->supplies[i].supply = supplies[i];
-	}
-
-	return sr;
-}
-
-static int pci_subdev_regulators_add_bus(struct pci_bus *bus)
-{
-	struct device *dev = &bus->dev;
-	struct subdev_regulators *sr;
-	int ret;
-
-	if (!dev->of_node || !bus->parent || !pci_is_root_bus(bus->parent))
-		return 0;
-
-	if (dev->driver_data)
-		dev_err(dev, "dev.driver_data unexpectedly non-NULL\n");
-
-	sr = alloc_subdev_regulators(dev);
-	if (!sr)
-		return -ENOMEM;
-
-	dev->driver_data = sr;
-	ret = regulator_bulk_get(dev, sr->num_supplies, sr->supplies);
-	if (ret)
-		return ret;
-
-	ret = regulator_bulk_enable(sr->num_supplies, sr->supplies);
-	if (ret) {
-		dev_err(dev, "failed to enable regulators for downstream device\n");
-		return ret;
-	}
-
-	return 0;
-}
-
-static int brcm_pcie_add_bus(struct pci_bus *bus)
-{
-	struct device *dev = &bus->dev;
-	struct brcm_pcie *pcie = (struct brcm_pcie *) bus->sysdata;
-	int ret;
-
-	if (!dev->of_node || !bus->parent || !pci_is_root_bus(bus->parent))
-		return 0;
-
-	ret = pci_subdev_regulators_add_bus(bus);
-	if (ret)
-		return ret;
-
-	/* Grab the regulators for suspend/resume */
-	pcie->sr = bus->dev.driver_data;
-
-	/*
-	 * If we have failed linkup there is no point to return an error as
-	 * currently it will cause a WARNING() from pci_alloc_child_bus().
-	 * We return 0 and turn on the "refusal_mode" so that any further
-	 * accesses to the pci_dev just get 0xffffffff
-	 */
-	if (brcm_pcie_linkup(pcie) != 0)
-		pcie->refusal_mode = true;
-
-	return 0;
-}
-
-static void pci_subdev_regulators_remove_bus(struct pci_bus *bus)
-{
-	struct device *dev = &bus->dev;
-	struct subdev_regulators *sr = dev->driver_data;
-
-	if (!sr || !bus->parent || !pci_is_root_bus(bus->parent))
-		return;
-
-	if (regulator_bulk_disable(sr->num_supplies, sr->supplies))
-		dev_err(dev, "failed to disable regulators for downstream device\n");
-	dev->driver_data = NULL;
-}
-
 /* Limits operation to a specific generation (1, 2, or 3) */
 static void brcm_pcie_set_gen(struct brcm_pcie *pcie, int gen)
 {
@@ -858,18 +751,6 @@ static void __iomem *brcm_pcie_map_conf(struct pci_bus *bus, unsigned int devfn,
 	/* Accesses to the RC go right to the RC registers if slot==0 */
 	if (pci_is_root_bus(bus))
 		return PCI_SLOT(devfn) ? NULL : base + where;
-	if (pcie->refusal_mode) {
-		/*
-		 * At this point we do not have link.  There will be a CPU
-		 * abort -- a quirk with this controller --if Linux tries
-		 * to read any config-space registers besides those
-		 * targeting the host bridge.  To prevent this we hijack
-		 * the address to point to a safe access that will return
-		 * 0xffffffff.
-		 */
-		writel(0xffffffff, base + PCIE_MISC_RC_BAR2_CONFIG_HI);
-		return base + PCIE_MISC_RC_BAR2_CONFIG_HI + (where & 0x3);
-	}
 
 	/* For devices, write to the config space index register */
 	idx = PCIE_ECAM_OFFSET(bus->number, devfn, 0);
@@ -898,8 +779,6 @@ static struct pci_ops brcm_pcie_ops = {
 	.map_bus = brcm_pcie_map_conf,
 	.read = pci_generic_config_read,
 	.write = pci_generic_config_write,
-	.add_bus = brcm_pcie_add_bus,
-	.remove_bus = pci_subdev_regulators_remove_bus,
 };
 
 static struct pci_ops brcm_pcie_ops32 = {
@@ -1047,9 +926,16 @@ static inline int brcm_pcie_get_rc_bar2_size_and_offset(struct brcm_pcie *pcie,
 
 static int brcm_pcie_setup(struct brcm_pcie *pcie)
 {
+	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
 	u64 rc_bar2_offset, rc_bar2_size;
 	void __iomem *base = pcie->base;
-	int ret, memc;
+	struct device *dev = pcie->dev;
+	struct resource_entry *entry;
+	bool ssc_good = false;
+	struct resource *res;
+	int num_out_wins = 0;
+	u16 nlw, cls, lnksta;
+	int i, ret, memc;
 	u32 tmp, burst, aspm_support;
 
 	/* Reset the bridge */
@@ -1139,40 +1025,6 @@ static int brcm_pcie_setup(struct brcm_pcie *pcie)
 	if (pcie->gen)
 		brcm_pcie_set_gen(pcie, pcie->gen);
 
-	/* Don't advertise L0s capability if 'aspm-no-l0s' */
-	aspm_support = PCIE_LINK_STATE_L1;
-	if (!of_property_read_bool(pcie->np, "aspm-no-l0s"))
-		aspm_support |= PCIE_LINK_STATE_L0S;
-	tmp = readl(base + PCIE_RC_CFG_PRIV1_LINK_CAPABILITY);
-	u32p_replace_bits(&tmp, aspm_support,
-		PCIE_RC_CFG_PRIV1_LINK_CAPABILITY_ASPM_SUPPORT_MASK);
-	writel(tmp, base + PCIE_RC_CFG_PRIV1_LINK_CAPABILITY);
-
-	/*
-	 * For config space accesses on the RC, show the right class for
-	 * a PCIe-PCIe bridge (the default setting is to be EP mode).
-	 */
-	tmp = readl(base + PCIE_RC_CFG_PRIV1_ID_VAL3);
-	u32p_replace_bits(&tmp, 0x060400,
-			  PCIE_RC_CFG_PRIV1_ID_VAL3_CLASS_CODE_MASK);
-	writel(tmp, base + PCIE_RC_CFG_PRIV1_ID_VAL3);
-
-	return 0;
-}
-
-static int brcm_pcie_linkup(struct brcm_pcie *pcie)
-{
-	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
-	struct device *dev = pcie->dev;
-	void __iomem *base = pcie->base;
-	struct resource_entry *entry;
-	struct resource *res;
-	int num_out_wins = 0;
-	u16 nlw, cls, lnksta;
-	bool ssc_good = false;
-	u32 tmp;
-	int ret, i;
-
 	/* Unassert the fundamental reset */
 	pcie->perst_set(pcie, 0);
 
@@ -1223,6 +1075,24 @@ static int brcm_pcie_linkup(struct brcm_pcie *pcie)
 		num_out_wins++;
 	}
 
+	/* Don't advertise L0s capability if 'aspm-no-l0s' */
+	aspm_support = PCIE_LINK_STATE_L1;
+	if (!of_property_read_bool(pcie->np, "aspm-no-l0s"))
+		aspm_support |= PCIE_LINK_STATE_L0S;
+	tmp = readl(base + PCIE_RC_CFG_PRIV1_LINK_CAPABILITY);
+	u32p_replace_bits(&tmp, aspm_support,
+		PCIE_RC_CFG_PRIV1_LINK_CAPABILITY_ASPM_SUPPORT_MASK);
+	writel(tmp, base + PCIE_RC_CFG_PRIV1_LINK_CAPABILITY);
+
+	/*
+	 * For config space accesses on the RC, show the right class for
+	 * a PCIe-PCIe bridge (the default setting is to be EP mode).
+	 */
+	tmp = readl(base + PCIE_RC_CFG_PRIV1_ID_VAL3);
+	u32p_replace_bits(&tmp, 0x060400,
+			  PCIE_RC_CFG_PRIV1_ID_VAL3_CLASS_CODE_MASK);
+	writel(tmp, base + PCIE_RC_CFG_PRIV1_ID_VAL3);
+
 	if (pcie->ssc) {
 		ret = brcm_pcie_set_ssc(pcie);
 		if (ret == 0)
@@ -1351,21 +1221,9 @@ static void brcm_pcie_turn_off(struct brcm_pcie *pcie)
 	pcie->bridge_sw_init_set(pcie, 1);
 }
 
-static int pci_dev_may_wakeup(struct pci_dev *dev, void *data)
-{
-	bool *ret = data;
-
-	if (device_may_wakeup(&dev->dev)) {
-		*ret = true;
-		dev_info(&dev->dev, "disable cancelled for wake-up device\n");
-	}
-	return (int) *ret;
-}
-
 static int brcm_pcie_suspend(struct device *dev)
 {
 	struct brcm_pcie *pcie = dev_get_drvdata(dev);
-	struct pci_host_bridge *bridge = pci_host_bridge_from_priv(pcie);
 	int ret;
 
 	brcm_pcie_turn_off(pcie);
@@ -1383,25 +1241,6 @@ static int brcm_pcie_suspend(struct device *dev)
 		return ret;
 	}
 
-	if (pcie->sr) {
-		/*
-		 * Now turn off the regulators, but if at least one
-		 * downstream device is enabled as a wake-up source, do not
-		 * turn off regulators.
-		 */
-		pcie->ep_wakeup_capable = false;
-		pci_walk_bus(bridge->bus, pci_dev_may_wakeup,
-			     &pcie->ep_wakeup_capable);
-		if (!pcie->ep_wakeup_capable) {
-			ret = regulator_bulk_disable(pcie->sr->num_supplies,
-						     pcie->sr->supplies);
-			if (ret) {
-				dev_err(dev, "Could not turn off regulators\n");
-				reset_control_reset(pcie->rescal);
-				return ret;
-			}
-		}
-	}
 	clk_disable_unprepare(pcie->clk);
 
 	return 0;
@@ -1419,28 +1258,9 @@ static int brcm_pcie_resume(struct device *dev)
 	if (ret)
 		return ret;
 
-	if (pcie->sr) {
-		if (pcie->ep_wakeup_capable) {
-			/*
-			 * We are resuming from a suspend.  In the suspend we
-			 * did not disable the power supplies, so there is
-			 * no need to enable them (and falsely increase their
-			 * usage count).
-			 */
-			pcie->ep_wakeup_capable = false;
-		} else {
-			ret = regulator_bulk_enable(pcie->sr->num_supplies,
-						    pcie->sr->supplies);
-			if (ret) {
-				dev_err(dev, "Could not turn on regulators\n");
-				goto err_disable_clk;
-			}
-		}
-	}
-
 	ret = reset_control_reset(pcie->rescal);
 	if (ret)
-		goto err_regulator;
+		goto err_disable_clk;
 
 	ret = brcm_phy_start(pcie);
 	if (ret)
@@ -1461,10 +1281,6 @@ static int brcm_pcie_resume(struct device *dev)
 	if (ret)
 		goto err_reset;
 
-	ret = brcm_pcie_linkup(pcie);
-	if (ret)
-		goto err_reset;
-
 	if (pcie->msi)
 		brcm_msi_set_regs(pcie->msi);
 
@@ -1472,9 +1288,6 @@ static int brcm_pcie_resume(struct device *dev)
 
 err_reset:
 	reset_control_rearm(pcie->rescal);
-err_regulator:
-	if (pcie->sr)
-		regulator_bulk_disable(pcie->sr->num_supplies, pcie->sr->supplies);
 err_disable_clk:
 	clk_disable_unprepare(pcie->clk);
 	return ret;
@@ -1606,17 +1419,7 @@ static int brcm_pcie_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, pcie);
 
-	ret = pci_host_probe(bridge);
-	if (!ret && !brcm_pcie_link_up(pcie))
-		ret = -ENODEV;
-
-	if (ret) {
-		brcm_pcie_remove(pdev);
-		return ret;
-	}
-
-	return 0;
-
+	return pci_host_probe(bridge);
 fail:
 	__brcm_pcie_remove(pcie);
 	return ret;
@@ -1625,8 +1428,8 @@ static int brcm_pcie_probe(struct platform_device *pdev)
 MODULE_DEVICE_TABLE(of, brcm_pcie_match);
 
 static const struct dev_pm_ops brcm_pcie_pm_ops = {
-	.suspend_noirq = brcm_pcie_suspend,
-	.resume_noirq = brcm_pcie_resume,
+	.suspend = brcm_pcie_suspend,
+	.resume = brcm_pcie_resume,
 };
 
 static struct platform_driver brcm_pcie_driver = {
diff --git a/drivers/pcmcia/Kconfig b/drivers/pcmcia/Kconfig
index ab53eab635f6..1740a63b814d 100644
--- a/drivers/pcmcia/Kconfig
+++ b/drivers/pcmcia/Kconfig
@@ -151,7 +151,7 @@ config TCIC
 
 config PCMCIA_ALCHEMY_DEVBOARD
 	tristate "Alchemy Db/Pb1xxx PCMCIA socket services"
-	depends on MIPS_ALCHEMY && PCMCIA
+	depends on MIPS_DB1XXX && PCMCIA
 	help
 	  Enable this driver of you want PCMCIA support on your Alchemy
 	  Db1000, Db/Pb1100, Db/Pb1500, Db/Pb1550, Db/Pb1200, DB1300
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
index c2b878128e2c..7493fd634c1d 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
@@ -5246,7 +5246,7 @@ static int qcom_qmp_phy_power_on(struct phy *phy)
 
 	ret = reset_control_deassert(qmp->ufs_reset);
 	if (ret)
-		goto err_lane_rst;
+		goto err_pcs_ready;
 
 	qcom_qmp_phy_configure(pcs_misc, cfg->regs, cfg->pcs_misc_tbl,
 			       cfg->pcs_misc_tbl_num);
diff --git a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
index eca77e44a4c1..cba5c32cbaee 100644
--- a/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
+++ b/drivers/phy/rockchip/phy-rockchip-inno-usb2.c
@@ -940,8 +940,14 @@ static irqreturn_t rockchip_usb2phy_irq(int irq, void *data)
 		if (!rport->phy)
 			continue;
 
-		/* Handle linestate irq for both otg port and host port */
-		ret = rockchip_usb2phy_linestate_irq(irq, rport);
+		switch (rport->port_id) {
+		case USB2PHY_PORT_OTG:
+			ret |= rockchip_usb2phy_otg_mux_irq(irq, rport);
+			break;
+		case USB2PHY_PORT_HOST:
+			ret |= rockchip_usb2phy_linestate_irq(irq, rport);
+			break;
+		}
 	}
 
 	return ret;
diff --git a/drivers/platform/x86/barco-p50-gpio.c b/drivers/platform/x86/barco-p50-gpio.c
index f5c72e33f9ae..f8b796820ef4 100644
--- a/drivers/platform/x86/barco-p50-gpio.c
+++ b/drivers/platform/x86/barco-p50-gpio.c
@@ -406,11 +406,14 @@ MODULE_DEVICE_TABLE(dmi, dmi_ids);
 static int __init p50_module_init(void)
 {
 	struct resource res = DEFINE_RES_IO(P50_GPIO_IO_PORT_BASE, P50_PORT_CMD + 1);
+	int ret;
 
 	if (!dmi_first_match(dmi_ids))
 		return -ENODEV;
 
-	platform_driver_register(&p50_gpio_driver);
+	ret = platform_driver_register(&p50_gpio_driver);
+	if (ret)
+		return ret;
 
 	gpio_pdev = platform_device_register_simple(DRIVER_NAME, PLATFORM_DEVID_NONE, &res, 1);
 	if (IS_ERR(gpio_pdev)) {
diff --git a/drivers/platform/x86/hp-wmi.c b/drivers/platform/x86/hp-wmi.c
index 88f0bfd6ecf1..c573bfd9ab0e 100644
--- a/drivers/platform/x86/hp-wmi.c
+++ b/drivers/platform/x86/hp-wmi.c
@@ -38,6 +38,7 @@ MODULE_ALIAS("wmi:5FB7F034-2C63-45e9-BE91-3D44E2C707E4");
 #define HPWMI_EVENT_GUID "95F24279-4D7B-4334-9387-ACCDC67EF61C"
 #define HPWMI_BIOS_GUID "5FB7F034-2C63-45e9-BE91-3D44E2C707E4"
 #define HP_OMEN_EC_THERMAL_PROFILE_OFFSET 0x95
+#define zero_if_sup(tmp) (zero_insize_support?0:sizeof(tmp)) // use when zero insize is required
 
 /* DMI board names of devices that should use the omen specific path for
  * thermal profiles.
@@ -200,6 +201,7 @@ static struct input_dev *hp_wmi_input_dev;
 static struct platform_device *hp_wmi_platform_dev;
 static struct platform_profile_handler platform_profile_handler;
 static bool platform_profile_support;
+static bool zero_insize_support;
 
 static struct rfkill *wifi_rfkill;
 static struct rfkill *bluetooth_rfkill;
@@ -347,7 +349,7 @@ static int hp_wmi_read_int(int query)
 	int val = 0, ret;
 
 	ret = hp_wmi_perform_query(query, HPWMI_READ, &val,
-				   sizeof(val), sizeof(val));
+				   zero_if_sup(val), sizeof(val));
 
 	if (ret)
 		return ret < 0 ? ret : -EINVAL;
@@ -383,7 +385,8 @@ static int hp_wmi_get_tablet_mode(void)
 		return -ENODEV;
 
 	ret = hp_wmi_perform_query(HPWMI_SYSTEM_DEVICE_MODE, HPWMI_READ,
-				   system_device_mode, 0, sizeof(system_device_mode));
+				   system_device_mode, zero_if_sup(system_device_mode),
+				   sizeof(system_device_mode));
 	if (ret < 0)
 		return ret;
 
@@ -449,7 +452,7 @@ static int hp_wmi_fan_speed_max_get(void)
 	int val = 0, ret;
 
 	ret = hp_wmi_perform_query(HPWMI_FAN_SPEED_MAX_GET_QUERY, HPWMI_GM,
-				   &val, 0, sizeof(val));
+				   &val, zero_if_sup(val), sizeof(val));
 
 	if (ret)
 		return ret < 0 ? ret : -EINVAL;
@@ -461,7 +464,7 @@ static int __init hp_wmi_bios_2008_later(void)
 {
 	int state = 0;
 	int ret = hp_wmi_perform_query(HPWMI_FEATURE_QUERY, HPWMI_READ, &state,
-				       0, sizeof(state));
+				       zero_if_sup(state), sizeof(state));
 	if (!ret)
 		return 1;
 
@@ -472,7 +475,7 @@ static int __init hp_wmi_bios_2009_later(void)
 {
 	u8 state[128];
 	int ret = hp_wmi_perform_query(HPWMI_FEATURE2_QUERY, HPWMI_READ, &state,
-				       0, sizeof(state));
+				       zero_if_sup(state), sizeof(state));
 	if (!ret)
 		return 1;
 
@@ -550,7 +553,7 @@ static int hp_wmi_rfkill2_refresh(void)
 	int err, i;
 
 	err = hp_wmi_perform_query(HPWMI_WIRELESS2_QUERY, HPWMI_READ, &state,
-				   0, sizeof(state));
+				   zero_if_sup(state), sizeof(state));
 	if (err)
 		return err;
 
@@ -952,7 +955,7 @@ static int __init hp_wmi_rfkill2_setup(struct platform_device *device)
 	int err, i;
 
 	err = hp_wmi_perform_query(HPWMI_WIRELESS2_QUERY, HPWMI_READ, &state,
-				   0, sizeof(state));
+				   zero_if_sup(state), sizeof(state));
 	if (err)
 		return err < 0 ? err : -EINVAL;
 
@@ -1410,11 +1413,15 @@ static int __init hp_wmi_init(void)
 {
 	int event_capable = wmi_has_guid(HPWMI_EVENT_GUID);
 	int bios_capable = wmi_has_guid(HPWMI_BIOS_GUID);
-	int err;
+	int err, tmp = 0;
 
 	if (!bios_capable && !event_capable)
 		return -ENODEV;
 
+	if (hp_wmi_perform_query(HPWMI_HARDWARE_QUERY, HPWMI_READ, &tmp,
+				 sizeof(tmp), sizeof(tmp)) == HPWMI_RET_INVALID_PARAMETERS)
+		zero_insize_support = true;
+
 	if (event_capable) {
 		err = hp_wmi_input_setup();
 		if (err)
diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 09a4cbd69676..23adcb597ff9 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -2995,13 +2995,6 @@ static int ab8500_fg_bind(struct device *dev, struct device *master,
 {
 	struct ab8500_fg *di = dev_get_drvdata(dev);
 
-	/* Create a work queue for running the FG algorithm */
-	di->fg_wq = alloc_ordered_workqueue("ab8500_fg_wq", WQ_MEM_RECLAIM);
-	if (di->fg_wq == NULL) {
-		dev_err(dev, "failed to create work queue\n");
-		return -ENOMEM;
-	}
-
 	di->bat_cap.max_mah_design = di->bm->bi->charge_full_design_uah;
 	di->bat_cap.max_mah = di->bat_cap.max_mah_design;
 	di->vbat_nom_uv = di->bm->bi->voltage_max_design_uv;
@@ -3025,8 +3018,7 @@ static void ab8500_fg_unbind(struct device *dev, struct device *master,
 	if (ret)
 		dev_err(dev, "failed to disable coulomb counter\n");
 
-	destroy_workqueue(di->fg_wq);
-	flush_scheduled_work();
+	flush_workqueue(di->fg_wq);
 }
 
 static const struct component_ops ab8500_fg_component_ops = {
@@ -3070,6 +3062,13 @@ static int ab8500_fg_probe(struct platform_device *pdev)
 	ab8500_fg_charge_state_to(di, AB8500_FG_CHARGE_INIT);
 	ab8500_fg_discharge_state_to(di, AB8500_FG_DISCHARGE_INIT);
 
+	/* Create a work queue for running the FG algorithm */
+	di->fg_wq = alloc_ordered_workqueue("ab8500_fg_wq", WQ_MEM_RECLAIM);
+	if (di->fg_wq == NULL) {
+		dev_err(dev, "failed to create work queue\n");
+		return -ENOMEM;
+	}
+
 	/* Init work for running the fg algorithm instantly */
 	INIT_WORK(&di->fg_work, ab8500_fg_instant_work);
 
@@ -3181,6 +3180,8 @@ static int ab8500_fg_remove(struct platform_device *pdev)
 	int ret = 0;
 	struct ab8500_fg *di = platform_get_drvdata(pdev);
 
+	destroy_workqueue(di->fg_wq);
+	flush_scheduled_work();
 	component_del(&pdev->dev, &ab8500_fg_component_ops);
 	list_del(&di->node);
 	ab8500_fg_sysfs_exit(di);
diff --git a/drivers/power/supply/axp288_charger.c b/drivers/power/supply/axp288_charger.c
index 19746e658a6a..15219ed43ce9 100644
--- a/drivers/power/supply/axp288_charger.c
+++ b/drivers/power/supply/axp288_charger.c
@@ -865,17 +865,20 @@ static int axp288_charger_probe(struct platform_device *pdev)
 	info->regmap_irqc = axp20x->regmap_irqc;
 
 	info->cable.edev = extcon_get_extcon_dev(AXP288_EXTCON_DEV_NAME);
-	if (info->cable.edev == NULL) {
-		dev_dbg(dev, "%s is not ready, probe deferred\n",
-			AXP288_EXTCON_DEV_NAME);
-		return -EPROBE_DEFER;
+	if (IS_ERR(info->cable.edev)) {
+		dev_err_probe(dev, PTR_ERR(info->cable.edev),
+			      "extcon_get_extcon_dev(%s) failed\n",
+			      AXP288_EXTCON_DEV_NAME);
+		return PTR_ERR(info->cable.edev);
 	}
 
 	if (acpi_dev_present(USB_HOST_EXTCON_HID, NULL, -1)) {
 		info->otg.cable = extcon_get_extcon_dev(USB_HOST_EXTCON_NAME);
-		if (info->otg.cable == NULL) {
-			dev_dbg(dev, "EXTCON_USB_HOST is not ready, probe deferred\n");
-			return -EPROBE_DEFER;
+		if (IS_ERR(info->otg.cable)) {
+			dev_err_probe(dev, PTR_ERR(info->otg.cable),
+				      "extcon_get_extcon_dev(%s) failed\n",
+				      USB_HOST_EXTCON_NAME);
+			return PTR_ERR(info->otg.cable);
 		}
 		dev_info(dev, "Using " USB_HOST_EXTCON_HID " extcon for usb-id\n");
 	}
diff --git a/drivers/power/supply/axp288_fuel_gauge.c b/drivers/power/supply/axp288_fuel_gauge.c
index ce8ffd0a41b5..68595897e72d 100644
--- a/drivers/power/supply/axp288_fuel_gauge.c
+++ b/drivers/power/supply/axp288_fuel_gauge.c
@@ -600,7 +600,6 @@ static const struct dmi_system_id axp288_no_battery_list[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "T3 MRD"),
 			DMI_MATCH(DMI_CHASSIS_TYPE, "3"),
 			DMI_MATCH(DMI_BIOS_VENDOR, "American Megatrends Inc."),
-			DMI_MATCH(DMI_BIOS_VERSION, "5.11"),
 		},
 	},
 	{}
diff --git a/drivers/power/supply/charger-manager.c b/drivers/power/supply/charger-manager.c
index d67edb760c94..92db79400a6a 100644
--- a/drivers/power/supply/charger-manager.c
+++ b/drivers/power/supply/charger-manager.c
@@ -985,13 +985,10 @@ static int charger_extcon_init(struct charger_manager *cm,
 	cable->nb.notifier_call = charger_extcon_notifier;
 
 	cable->extcon_dev = extcon_get_extcon_dev(cable->extcon_name);
-	if (IS_ERR_OR_NULL(cable->extcon_dev)) {
+	if (IS_ERR(cable->extcon_dev)) {
 		pr_err("Cannot find extcon_dev for %s (cable: %s)\n",
 			cable->extcon_name, cable->name);
-		if (cable->extcon_dev == NULL)
-			return -EPROBE_DEFER;
-		else
-			return PTR_ERR(cable->extcon_dev);
+		return PTR_ERR(cable->extcon_dev);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(extcon_mapping); i++) {
diff --git a/drivers/power/supply/max8997_charger.c b/drivers/power/supply/max8997_charger.c
index 25207fe2aa68..bfa7a576523d 100644
--- a/drivers/power/supply/max8997_charger.c
+++ b/drivers/power/supply/max8997_charger.c
@@ -248,10 +248,10 @@ static int max8997_battery_probe(struct platform_device *pdev)
 		dev_info(&pdev->dev, "couldn't get charger regulator\n");
 	}
 	charger->edev = extcon_get_extcon_dev("max8997-muic");
-	if (IS_ERR_OR_NULL(charger->edev)) {
-		if (!charger->edev)
-			return -EPROBE_DEFER;
-		dev_info(charger->dev, "couldn't get extcon device\n");
+	if (IS_ERR(charger->edev)) {
+		dev_err_probe(charger->dev, PTR_ERR(charger->edev),
+			      "couldn't get extcon device: max8997-muic\n");
+		return PTR_ERR(charger->edev);
 	}
 
 	if (!IS_ERR(charger->reg) && !IS_ERR_OR_NULL(charger->edev)) {
diff --git a/drivers/pwm/pwm-lp3943.c b/drivers/pwm/pwm-lp3943.c
index ea17d446a627..2bd04ecb508c 100644
--- a/drivers/pwm/pwm-lp3943.c
+++ b/drivers/pwm/pwm-lp3943.c
@@ -125,6 +125,7 @@ static int lp3943_pwm_config(struct pwm_chip *chip, struct pwm_device *pwm,
 	if (err)
 		return err;
 
+	duty_ns = min(duty_ns, period_ns);
 	val = (u8)(duty_ns * LP3943_MAX_DUTY / period_ns);
 
 	return lp3943_write_byte(lp3943, reg_duty, val);
diff --git a/drivers/pwm/pwm-raspberrypi-poe.c b/drivers/pwm/pwm-raspberrypi-poe.c
index 579a15240e0a..c877de37734d 100644
--- a/drivers/pwm/pwm-raspberrypi-poe.c
+++ b/drivers/pwm/pwm-raspberrypi-poe.c
@@ -66,7 +66,7 @@ static int raspberrypi_pwm_get_property(struct rpi_firmware *firmware,
 					u32 reg, u32 *val)
 {
 	struct raspberrypi_pwm_prop msg = {
-		.reg = reg
+		.reg = cpu_to_le32(reg),
 	};
 	int ret;
 
diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index 7a096f1891e6..91eb037089ef 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -423,6 +423,9 @@ static int imx_rproc_prepare(struct rproc *rproc)
 		if (!strcmp(it.node->name, "vdev0buffer"))
 			continue;
 
+		if (!strcmp(it.node->name, "rsc-table"))
+			continue;
+
 		rmem = of_reserved_mem_lookup(it.node);
 		if (!rmem) {
 			dev_err(priv->dev, "unable to acquire memory-region\n");
diff --git a/drivers/rpmsg/qcom_smd.c b/drivers/rpmsg/qcom_smd.c
index 540e027f08c4..4ad90945518f 100644
--- a/drivers/rpmsg/qcom_smd.c
+++ b/drivers/rpmsg/qcom_smd.c
@@ -1404,9 +1404,9 @@ static int qcom_smd_parse_edge(struct device *dev,
 		edge->name = node->name;
 
 	irq = irq_of_parse_and_map(node, 0);
-	if (irq < 0) {
+	if (!irq) {
 		dev_err(dev, "required smd interrupt missing\n");
-		ret = irq;
+		ret = -EINVAL;
 		goto put_node;
 	}
 
diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
index ac764e04c898..ed26e9226834 100644
--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -851,7 +851,7 @@ static struct rpmsg_device *rpmsg_virtio_add_ctrl_dev(struct virtio_device *vdev
 
 	err = rpmsg_chrdev_register_device(rpdev_ctrl);
 	if (err) {
-		kfree(vch);
+		/* vch will be free in virtio_rpmsg_release_device() */
 		return ERR_PTR(err);
 	}
 
@@ -862,7 +862,7 @@ static void rpmsg_virtio_del_ctrl_dev(struct rpmsg_device *rpdev_ctrl)
 {
 	if (!rpdev_ctrl)
 		return;
-	kfree(to_virtio_rpmsg_channel(rpdev_ctrl));
+	device_unregister(&rpdev_ctrl->dev);
 }
 
 static int rpmsg_probe(struct virtio_device *vdev)
@@ -973,7 +973,8 @@ static int rpmsg_probe(struct virtio_device *vdev)
 
 		err = rpmsg_ns_register_device(rpdev_ns);
 		if (err)
-			goto free_vch;
+			/* vch will be free in virtio_rpmsg_release_device() */
+			goto free_ctrldev;
 	}
 
 	/*
@@ -997,8 +998,6 @@ static int rpmsg_probe(struct virtio_device *vdev)
 
 	return 0;
 
-free_vch:
-	kfree(vch);
 free_ctrldev:
 	rpmsg_virtio_del_ctrl_dev(rpdev_ctrl);
 free_coherent:
diff --git a/drivers/rtc/rtc-ftrtc010.c b/drivers/rtc/rtc-ftrtc010.c
index 53bb08fe1cd4..25c6e7d9570f 100644
--- a/drivers/rtc/rtc-ftrtc010.c
+++ b/drivers/rtc/rtc-ftrtc010.c
@@ -137,26 +137,34 @@ static int ftrtc010_rtc_probe(struct platform_device *pdev)
 		ret = clk_prepare_enable(rtc->extclk);
 		if (ret) {
 			dev_err(dev, "failed to enable EXTCLK\n");
-			return ret;
+			goto err_disable_pclk;
 		}
 	}
 
 	rtc->rtc_irq = platform_get_irq(pdev, 0);
-	if (rtc->rtc_irq < 0)
-		return rtc->rtc_irq;
+	if (rtc->rtc_irq < 0) {
+		ret = rtc->rtc_irq;
+		goto err_disable_extclk;
+	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENODEV;
+	if (!res) {
+		ret = -ENODEV;
+		goto err_disable_extclk;
+	}
 
 	rtc->rtc_base = devm_ioremap(dev, res->start,
 				     resource_size(res));
-	if (!rtc->rtc_base)
-		return -ENOMEM;
+	if (!rtc->rtc_base) {
+		ret = -ENOMEM;
+		goto err_disable_extclk;
+	}
 
 	rtc->rtc_dev = devm_rtc_allocate_device(dev);
-	if (IS_ERR(rtc->rtc_dev))
-		return PTR_ERR(rtc->rtc_dev);
+	if (IS_ERR(rtc->rtc_dev)) {
+		ret = PTR_ERR(rtc->rtc_dev);
+		goto err_disable_extclk;
+	}
 
 	rtc->rtc_dev->ops = &ftrtc010_rtc_ops;
 
@@ -172,9 +180,15 @@ static int ftrtc010_rtc_probe(struct platform_device *pdev)
 	ret = devm_request_irq(dev, rtc->rtc_irq, ftrtc010_rtc_interrupt,
 			       IRQF_SHARED, pdev->name, dev);
 	if (unlikely(ret))
-		return ret;
+		goto err_disable_extclk;
 
 	return devm_rtc_register_device(rtc->rtc_dev);
+
+err_disable_extclk:
+	clk_disable_unprepare(rtc->extclk);
+err_disable_pclk:
+	clk_disable_unprepare(rtc->pclk);
+	return ret;
 }
 
 static int ftrtc010_rtc_remove(struct platform_device *pdev)
diff --git a/drivers/rtc/rtc-mt6397.c b/drivers/rtc/rtc-mt6397.c
index 80dc479a6ff0..1d297af80f87 100644
--- a/drivers/rtc/rtc-mt6397.c
+++ b/drivers/rtc/rtc-mt6397.c
@@ -269,6 +269,8 @@ static int mtk_rtc_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 	rtc->addr_base = res->start;
 
 	rtc->data = of_device_get_match_data(&pdev->dev);
diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index 71585528e8db..e885c1dbf61f 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -1239,7 +1239,8 @@ static void myrb_cleanup(struct myrb_hba *cb)
 	myrb_unmap(cb);
 
 	if (cb->mmio_base) {
-		cb->disable_intr(cb->io_base);
+		if (cb->disable_intr)
+			cb->disable_intr(cb->io_base);
 		iounmap(cb->mmio_base);
 	}
 	if (cb->irq)
@@ -3413,9 +3414,13 @@ static struct myrb_hba *myrb_detect(struct pci_dev *pdev,
 	mutex_init(&cb->dcmd_mutex);
 	mutex_init(&cb->dma_mutex);
 	cb->pdev = pdev;
+	cb->host = shost;
 
-	if (pci_enable_device(pdev))
-		goto failure;
+	if (pci_enable_device(pdev)) {
+		dev_err(&pdev->dev, "Failed to enable PCI device\n");
+		scsi_host_put(shost);
+		return NULL;
+	}
 
 	if (privdata->hw_init == DAC960_PD_hw_init ||
 	    privdata->hw_init == DAC960_P_hw_init) {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8b5d2a4076c2..b0922c521d61 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3171,7 +3171,7 @@ static void sd_read_cpr(struct scsi_disk *sdkp)
 		goto out;
 
 	/* We must have at least a 64B header and one 32B range descriptor */
-	vpd_len = get_unaligned_be16(&buffer[2]) + 3;
+	vpd_len = get_unaligned_be16(&buffer[2]) + 4;
 	if (vpd_len > buf_len || vpd_len < 64 + 32 || (vpd_len & 31)) {
 		sd_printk(KERN_ERR, sdkp,
 			  "Invalid Concurrent Positioning Ranges VPD page\n");
@@ -3605,7 +3605,6 @@ static int sd_probe(struct device *dev)
  out_put:
 	put_disk(gd);
  out_free:
-	sd_zbc_release_disk(sdkp);
 	kfree(sdkp);
  out:
 	scsi_autopm_put_device(sdp);
diff --git a/drivers/soc/rockchip/grf.c b/drivers/soc/rockchip/grf.c
index 494cf2b5bf7b..343ff61ccccb 100644
--- a/drivers/soc/rockchip/grf.c
+++ b/drivers/soc/rockchip/grf.c
@@ -148,12 +148,14 @@ static int __init rockchip_grf_init(void)
 		return -ENODEV;
 	if (!match || !match->data) {
 		pr_err("%s: missing grf data\n", __func__);
+		of_node_put(np);
 		return -EINVAL;
 	}
 
 	grf_info = match->data;
 
 	grf = syscon_node_to_regmap(np);
+	of_node_put(np);
 	if (IS_ERR(grf)) {
 		pr_err("%s: could not get grf syscon\n", __func__);
 		return PTR_ERR(grf);
diff --git a/drivers/soundwire/intel.c b/drivers/soundwire/intel.c
index 63101f1ba271..32e5fdb823c4 100644
--- a/drivers/soundwire/intel.c
+++ b/drivers/soundwire/intel.c
@@ -1293,6 +1293,9 @@ static int intel_link_probe(struct auxiliary_device *auxdev,
 	/* use generic bandwidth allocation algorithm */
 	sdw->cdns.bus.compute_params = sdw_compute_params;
 
+	/* avoid resuming from pm_runtime suspend if it's not required */
+	dev_pm_set_driver_flags(dev, DPM_FLAG_SMART_SUSPEND);
+
 	ret = sdw_bus_master_add(bus, dev, dev->fwnode);
 	if (ret) {
 		dev_err(dev, "sdw_bus_master_add fail: %d\n", ret);
diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index 54813417ef8e..249f1b69ec94 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -99,7 +99,7 @@
 
 #define SWRM_SPECIAL_CMD_ID	0xF
 #define MAX_FREQ_NUM		1
-#define TIMEOUT_MS		(2 * HZ)
+#define TIMEOUT_MS		100
 #define QCOM_SWRM_MAX_RD_LEN	0x1
 #define QCOM_SDW_MAX_PORTS	14
 #define DEFAULT_CLK_FREQ	9600000
diff --git a/drivers/spi/spi-fsi.c b/drivers/spi/spi-fsi.c
index d403a7a3021d..72ab066ce552 100644
--- a/drivers/spi/spi-fsi.c
+++ b/drivers/spi/spi-fsi.c
@@ -319,12 +319,12 @@ static int fsi_spi_transfer_data(struct fsi_spi *ctx,
 
 			end = jiffies + msecs_to_jiffies(SPI_FSI_STATUS_TIMEOUT_MS);
 			do {
+				if (time_after(jiffies, end))
+					return -ETIMEDOUT;
+
 				rc = fsi_spi_status(ctx, &status, "TX");
 				if (rc)
 					return rc;
-
-				if (time_after(jiffies, end))
-					return -ETIMEDOUT;
 			} while (status & SPI_FSI_STATUS_TDR_FULL);
 
 			sent += nb;
@@ -337,12 +337,12 @@ static int fsi_spi_transfer_data(struct fsi_spi *ctx,
 		while (transfer->len > recv) {
 			end = jiffies + msecs_to_jiffies(SPI_FSI_STATUS_TIMEOUT_MS);
 			do {
+				if (time_after(jiffies, end))
+					return -ETIMEDOUT;
+
 				rc = fsi_spi_status(ctx, &status, "RX");
 				if (rc)
 					return rc;
-
-				if (time_after(jiffies, end))
-					return -ETIMEDOUT;
 			} while (!(status & SPI_FSI_STATUS_RDR_FULL));
 
 			rc = fsi_spi_read_reg(ctx, SPI_FSI_DATA_RX, &in);
diff --git a/drivers/staging/fieldbus/anybuss/host.c b/drivers/staging/fieldbus/anybuss/host.c
index a344410e48fe..cd86b9c9e345 100644
--- a/drivers/staging/fieldbus/anybuss/host.c
+++ b/drivers/staging/fieldbus/anybuss/host.c
@@ -1384,7 +1384,7 @@ anybuss_host_common_probe(struct device *dev,
 		goto err_device;
 	return cd;
 err_device:
-	device_unregister(&cd->client->dev);
+	put_device(&cd->client->dev);
 err_kthread:
 	kthread_stop(cd->qthread);
 err_reset:
diff --git a/drivers/staging/greybus/audio_codec.c b/drivers/staging/greybus/audio_codec.c
index b589cf6b1d03..e19b91e7a72e 100644
--- a/drivers/staging/greybus/audio_codec.c
+++ b/drivers/staging/greybus/audio_codec.c
@@ -599,8 +599,8 @@ static int gbcodec_mute_stream(struct snd_soc_dai *dai, int mute, int stream)
 			break;
 	}
 	if (!data) {
-		dev_err(dai->dev, "%s:%s DATA connection missing\n",
-			dai->name, module->name);
+		dev_err(dai->dev, "%s DATA connection missing\n",
+			dai->name);
 		mutex_unlock(&codec->lock);
 		return -ENODEV;
 	}
diff --git a/drivers/staging/r8188eu/core/rtw_xmit.c b/drivers/staging/r8188eu/core/rtw_xmit.c
index 8503059edc46..f4e9f6102539 100644
--- a/drivers/staging/r8188eu/core/rtw_xmit.c
+++ b/drivers/staging/r8188eu/core/rtw_xmit.c
@@ -179,7 +179,12 @@ s32	_rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter)
 
 	pxmitpriv->free_xmit_extbuf_cnt = num_xmit_extbuf;
 
-	rtw_alloc_hwxmits(padapter);
+	res = rtw_alloc_hwxmits(padapter);
+	if (res) {
+		res = _FAIL;
+		goto exit;
+	}
+
 	rtw_init_hwxmits(pxmitpriv->hwxmits, pxmitpriv->hwxmit_entry);
 
 	for (i = 0; i < 4; i++)
@@ -1496,7 +1501,7 @@ s32 rtw_xmit_classifier(struct adapter *padapter, struct xmit_frame *pxmitframe)
 	return res;
 }
 
-void rtw_alloc_hwxmits(struct adapter *padapter)
+int rtw_alloc_hwxmits(struct adapter *padapter)
 {
 	struct hw_xmit *hwxmits;
 	struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
@@ -1504,6 +1509,8 @@ void rtw_alloc_hwxmits(struct adapter *padapter)
 	pxmitpriv->hwxmit_entry = HWXMIT_ENTRY;
 
 	pxmitpriv->hwxmits = kzalloc(sizeof(struct hw_xmit) * pxmitpriv->hwxmit_entry, GFP_KERNEL);
+	if (!pxmitpriv->hwxmits)
+		return -ENOMEM;
 
 	hwxmits = pxmitpriv->hwxmits;
 
@@ -1520,6 +1527,8 @@ void rtw_alloc_hwxmits(struct adapter *padapter)
 		hwxmits[3] .sta_queue = &pxmitpriv->bk_pending;
 	} else {
 	}
+
+	return 0;
 }
 
 void rtw_free_hwxmits(struct adapter *padapter)
diff --git a/drivers/staging/r8188eu/include/rtw_xmit.h b/drivers/staging/r8188eu/include/rtw_xmit.h
index b2df1480d66b..e73632972900 100644
--- a/drivers/staging/r8188eu/include/rtw_xmit.h
+++ b/drivers/staging/r8188eu/include/rtw_xmit.h
@@ -341,7 +341,7 @@ s32 rtw_txframes_sta_ac_pending(struct adapter *padapter,
 void rtw_init_hwxmits(struct hw_xmit *phwxmit, int entry);
 s32 _rtw_init_xmit_priv(struct xmit_priv *pxmitpriv, struct adapter *padapter);
 void _rtw_free_xmit_priv(struct xmit_priv *pxmitpriv);
-void rtw_alloc_hwxmits(struct adapter *padapter);
+int rtw_alloc_hwxmits(struct adapter *padapter);
 void rtw_free_hwxmits(struct adapter *padapter);
 s32 rtw_xmit(struct adapter *padapter, struct sk_buff **pkt);
 
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index 4b6c2295a3cf..b5a38f0a8d79 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -651,9 +651,9 @@ static void rtllib_beacons_stop(struct rtllib_device *ieee)
 	spin_lock_irqsave(&ieee->beacon_lock, flags);
 
 	ieee->beacon_txing = 0;
-	del_timer_sync(&ieee->beacon_timer);
 
 	spin_unlock_irqrestore(&ieee->beacon_lock, flags);
+	del_timer_sync(&ieee->beacon_timer);
 
 }
 
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
index 1a43979939a8..79f3fbe25556 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -528,9 +528,9 @@ static void ieee80211_beacons_stop(struct ieee80211_device *ieee)
 	spin_lock_irqsave(&ieee->beacon_lock, flags);
 
 	ieee->beacon_txing = 0;
-	del_timer_sync(&ieee->beacon_timer);
 
 	spin_unlock_irqrestore(&ieee->beacon_lock, flags);
+	del_timer_sync(&ieee->beacon_timer);
 }
 
 void ieee80211_stop_send_beacons(struct ieee80211_device *ieee)
diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index d15d52c0d1a7..003e97205124 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -332,7 +332,6 @@ void r8712_free_drv_sw(struct _adapter *padapter)
 	r8712_free_evt_priv(&padapter->evtpriv);
 	r8712_DeInitSwLeds(padapter);
 	r8712_free_mlme_priv(&padapter->mlmepriv);
-	r8712_free_io_queue(padapter);
 	_free_xmit_priv(&padapter->xmitpriv);
 	_r8712_free_sta_priv(&padapter->stapriv);
 	_r8712_free_recv_priv(&padapter->recvpriv);
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index ee4c61f85a07..1ff3e2658e77 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -265,6 +265,7 @@ static uint r8712_usb_dvobj_init(struct _adapter *padapter)
 
 static void r8712_usb_dvobj_deinit(struct _adapter *padapter)
 {
+	r8712_free_io_queue(padapter);
 }
 
 void rtl871x_intf_stop(struct _adapter *padapter)
@@ -302,9 +303,6 @@ void r871x_dev_unload(struct _adapter *padapter)
 			rtl8712_hal_deinit(padapter);
 		}
 
-		/*s6.*/
-		if (padapter->dvobj_deinit)
-			padapter->dvobj_deinit(padapter);
 		padapter->bup = false;
 	}
 }
@@ -538,13 +536,13 @@ static int r871xu_drv_init(struct usb_interface *pusb_intf,
 		} else {
 			AutoloadFail = false;
 		}
-		if (((mac[0] == 0xff) && (mac[1] == 0xff) &&
+		if ((!AutoloadFail) ||
+		    ((mac[0] == 0xff) && (mac[1] == 0xff) &&
 		     (mac[2] == 0xff) && (mac[3] == 0xff) &&
 		     (mac[4] == 0xff) && (mac[5] == 0xff)) ||
 		    ((mac[0] == 0x00) && (mac[1] == 0x00) &&
 		     (mac[2] == 0x00) && (mac[3] == 0x00) &&
-		     (mac[4] == 0x00) && (mac[5] == 0x00)) ||
-		     (!AutoloadFail)) {
+		     (mac[4] == 0x00) && (mac[5] == 0x00))) {
 			mac[0] = 0x00;
 			mac[1] = 0xe0;
 			mac[2] = 0x4c;
@@ -607,6 +605,8 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 	/* Stop driver mlme relation timer */
 	r8712_stop_drv_timers(padapter);
 	r871x_dev_unload(padapter);
+	if (padapter->dvobj_deinit)
+		padapter->dvobj_deinit(padapter);
 	r8712_free_drv_sw(padapter);
 	free_netdev(pnetdev);
 
diff --git a/drivers/staging/rtl8712/usb_ops.c b/drivers/staging/rtl8712/usb_ops.c
index e64845e6adf3..af9966d03979 100644
--- a/drivers/staging/rtl8712/usb_ops.c
+++ b/drivers/staging/rtl8712/usb_ops.c
@@ -29,7 +29,8 @@ static u8 usb_read8(struct intf_hdl *intfhdl, u32 addr)
 	u16 wvalue;
 	u16 index;
 	u16 len;
-	__le32 data;
+	int status;
+	__le32 data = 0;
 	struct intf_priv *intfpriv = intfhdl->pintfpriv;
 
 	request = 0x05;
@@ -37,8 +38,10 @@ static u8 usb_read8(struct intf_hdl *intfhdl, u32 addr)
 	index = 0;
 	wvalue = (u16)(addr & 0x0000ffff);
 	len = 1;
-	r8712_usbctrl_vendorreq(intfpriv, request, wvalue, index, &data, len,
-				requesttype);
+	status = r8712_usbctrl_vendorreq(intfpriv, request, wvalue, index,
+					 &data, len, requesttype);
+	if (status < 0)
+		return 0;
 	return (u8)(le32_to_cpu(data) & 0x0ff);
 }
 
@@ -49,7 +52,8 @@ static u16 usb_read16(struct intf_hdl *intfhdl, u32 addr)
 	u16 wvalue;
 	u16 index;
 	u16 len;
-	__le32 data;
+	int status;
+	__le32 data = 0;
 	struct intf_priv *intfpriv = intfhdl->pintfpriv;
 
 	request = 0x05;
@@ -57,8 +61,10 @@ static u16 usb_read16(struct intf_hdl *intfhdl, u32 addr)
 	index = 0;
 	wvalue = (u16)(addr & 0x0000ffff);
 	len = 2;
-	r8712_usbctrl_vendorreq(intfpriv, request, wvalue, index, &data, len,
-				requesttype);
+	status = r8712_usbctrl_vendorreq(intfpriv, request, wvalue, index,
+					 &data, len, requesttype);
+	if (status < 0)
+		return 0;
 	return (u16)(le32_to_cpu(data) & 0xffff);
 }
 
@@ -69,7 +75,8 @@ static u32 usb_read32(struct intf_hdl *intfhdl, u32 addr)
 	u16 wvalue;
 	u16 index;
 	u16 len;
-	__le32 data;
+	int status;
+	__le32 data = 0;
 	struct intf_priv *intfpriv = intfhdl->pintfpriv;
 
 	request = 0x05;
@@ -77,8 +84,10 @@ static u32 usb_read32(struct intf_hdl *intfhdl, u32 addr)
 	index = 0;
 	wvalue = (u16)(addr & 0x0000ffff);
 	len = 4;
-	r8712_usbctrl_vendorreq(intfpriv, request, wvalue, index, &data, len,
-				requesttype);
+	status = r8712_usbctrl_vendorreq(intfpriv, request, wvalue, index,
+					 &data, len, requesttype);
+	if (status < 0)
+		return 0;
 	return le32_to_cpu(data);
 }
 
diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme.c b/drivers/staging/rtl8723bs/core/rtw_mlme.c
index 9202223ebc0c..c29e3c68e61e 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme.c
@@ -751,7 +751,9 @@ void rtw_surveydone_event_callback(struct adapter	*adapter, u8 *pbuf)
 	}
 
 	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY)) {
+		spin_unlock_bh(&pmlmepriv->lock);
 		del_timer_sync(&pmlmepriv->scan_to_timer);
+		spin_lock_bh(&pmlmepriv->lock);
 		_clr_fwstate_(pmlmepriv, _FW_UNDER_SURVEY);
 	}
 
@@ -1238,8 +1240,10 @@ void rtw_joinbss_event_prehandle(struct adapter *adapter, u8 *pbuf)
 
 			spin_unlock_bh(&pmlmepriv->scanned_queue.lock);
 
+			spin_unlock_bh(&pmlmepriv->lock);
 			/* s5. Cancel assoc_timer */
 			del_timer_sync(&pmlmepriv->assoc_timer);
+			spin_lock_bh(&pmlmepriv->lock);
 		} else {
 			spin_unlock_bh(&(pmlmepriv->scanned_queue.lock));
 		}
@@ -1545,7 +1549,7 @@ void _rtw_join_timeout_handler(struct timer_list *t)
 	if (adapter->bDriverStopped || adapter->bSurpriseRemoved)
 		return;
 
-	spin_lock_bh(&pmlmepriv->lock);
+	spin_lock_irq(&pmlmepriv->lock);
 
 	if (rtw_to_roam(adapter) > 0) { /* join timeout caused by roaming */
 		while (1) {
@@ -1573,7 +1577,7 @@ void _rtw_join_timeout_handler(struct timer_list *t)
 
 	}
 
-	spin_unlock_bh(&pmlmepriv->lock);
+	spin_unlock_irq(&pmlmepriv->lock);
 }
 
 /*
@@ -1586,11 +1590,11 @@ void rtw_scan_timeout_handler(struct timer_list *t)
 						  mlmepriv.scan_to_timer);
 	struct	mlme_priv *pmlmepriv = &adapter->mlmepriv;
 
-	spin_lock_bh(&pmlmepriv->lock);
+	spin_lock_irq(&pmlmepriv->lock);
 
 	_clr_fwstate_(pmlmepriv, _FW_UNDER_SURVEY);
 
-	spin_unlock_bh(&pmlmepriv->lock);
+	spin_unlock_irq(&pmlmepriv->lock);
 
 	rtw_indicate_scan_done(adapter, true);
 }
diff --git a/drivers/thunderbolt/tb.c b/drivers/thunderbolt/tb.c
index cbd0ad85ffb1..a1f5d1842811 100644
--- a/drivers/thunderbolt/tb.c
+++ b/drivers/thunderbolt/tb.c
@@ -867,7 +867,7 @@ static struct tb_port *tb_find_dp_out(struct tb *tb, struct tb_port *in)
 
 static void tb_tunnel_dp(struct tb *tb)
 {
-	int available_up, available_down, ret;
+	int available_up, available_down, ret, link_nr;
 	struct tb_cm *tcm = tb_priv(tb);
 	struct tb_port *port, *in, *out;
 	struct tb_tunnel *tunnel;
@@ -912,6 +912,20 @@ static void tb_tunnel_dp(struct tb *tb)
 		return;
 	}
 
+	/*
+	 * This is only applicable to links that are not bonded (so
+	 * when Thunderbolt 1 hardware is involved somewhere in the
+	 * topology). For these try to share the DP bandwidth between
+	 * the two lanes.
+	 */
+	link_nr = 1;
+	list_for_each_entry(tunnel, &tcm->tunnel_list, list) {
+		if (tb_tunnel_is_dp(tunnel)) {
+			link_nr = 0;
+			break;
+		}
+	}
+
 	/*
 	 * DP stream needs the domain to be active so runtime resume
 	 * both ends of the tunnel.
@@ -943,7 +957,8 @@ static void tb_tunnel_dp(struct tb *tb)
 	tb_dbg(tb, "available bandwidth for new DP tunnel %u/%u Mb/s\n",
 	       available_up, available_down);
 
-	tunnel = tb_tunnel_alloc_dp(tb, in, out, available_up, available_down);
+	tunnel = tb_tunnel_alloc_dp(tb, in, out, link_nr, available_up,
+				    available_down);
 	if (!tunnel) {
 		tb_port_dbg(out, "could not allocate DP tunnel\n");
 		goto err_reclaim;
diff --git a/drivers/thunderbolt/test.c b/drivers/thunderbolt/test.c
index 1f69bab236ee..66b6e665e96f 100644
--- a/drivers/thunderbolt/test.c
+++ b/drivers/thunderbolt/test.c
@@ -1348,7 +1348,7 @@ static void tb_test_tunnel_dp(struct kunit *test)
 	in = &host->ports[5];
 	out = &dev->ports[13];
 
-	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
 	KUNIT_EXPECT_EQ(test, tunnel->type, TB_TUNNEL_DP);
 	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, in);
@@ -1394,7 +1394,7 @@ static void tb_test_tunnel_dp_chain(struct kunit *test)
 	in = &host->ports[5];
 	out = &dev4->ports[14];
 
-	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
 	KUNIT_EXPECT_EQ(test, tunnel->type, TB_TUNNEL_DP);
 	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, in);
@@ -1444,7 +1444,7 @@ static void tb_test_tunnel_dp_tree(struct kunit *test)
 	in = &dev2->ports[13];
 	out = &dev5->ports[13];
 
-	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
 	KUNIT_EXPECT_EQ(test, tunnel->type, TB_TUNNEL_DP);
 	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, in);
@@ -1509,7 +1509,7 @@ static void tb_test_tunnel_dp_max_length(struct kunit *test)
 	in = &dev6->ports[13];
 	out = &dev12->ports[13];
 
-	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
 	KUNIT_EXPECT_EQ(test, tunnel->type, TB_TUNNEL_DP);
 	KUNIT_EXPECT_PTR_EQ(test, tunnel->src_port, in);
@@ -1627,7 +1627,7 @@ static void tb_test_tunnel_port_on_path(struct kunit *test)
 	in = &dev2->ports[13];
 	out = &dev5->ports[13];
 
-	dp_tunnel = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	dp_tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, dp_tunnel != NULL);
 
 	KUNIT_EXPECT_TRUE(test, tb_tunnel_port_on_path(dp_tunnel, in));
@@ -2009,7 +2009,7 @@ static void tb_test_credit_alloc_dp(struct kunit *test)
 	in = &host->ports[5];
 	out = &dev->ports[14];
 
-	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	tunnel = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, tunnel != NULL);
 	KUNIT_ASSERT_EQ(test, tunnel->npaths, (size_t)3);
 
@@ -2245,7 +2245,7 @@ static struct tb_tunnel *TB_TEST_DP_TUNNEL1(struct kunit *test,
 
 	in = &host->ports[5];
 	out = &dev->ports[13];
-	dp_tunnel1 = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	dp_tunnel1 = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, dp_tunnel1 != NULL);
 	KUNIT_ASSERT_EQ(test, dp_tunnel1->npaths, (size_t)3);
 
@@ -2282,7 +2282,7 @@ static struct tb_tunnel *TB_TEST_DP_TUNNEL2(struct kunit *test,
 
 	in = &host->ports[6];
 	out = &dev->ports[14];
-	dp_tunnel2 = tb_tunnel_alloc_dp(NULL, in, out, 0, 0);
+	dp_tunnel2 = tb_tunnel_alloc_dp(NULL, in, out, 1, 0, 0);
 	KUNIT_ASSERT_TRUE(test, dp_tunnel2 != NULL);
 	KUNIT_ASSERT_EQ(test, dp_tunnel2->npaths, (size_t)3);
 
diff --git a/drivers/thunderbolt/tunnel.c b/drivers/thunderbolt/tunnel.c
index a473cc7d9a8d..500a0afe3073 100644
--- a/drivers/thunderbolt/tunnel.c
+++ b/drivers/thunderbolt/tunnel.c
@@ -848,6 +848,7 @@ struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in,
  * @tb: Pointer to the domain structure
  * @in: DP in adapter port
  * @out: DP out adapter port
+ * @link_nr: Preferred lane adapter when the link is not bonded
  * @max_up: Maximum available upstream bandwidth for the DP tunnel (%0
  *	    if not limited)
  * @max_down: Maximum available downstream bandwidth for the DP tunnel
@@ -859,8 +860,8 @@ struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in,
  * Return: Returns a tb_tunnel on success or NULL on failure.
  */
 struct tb_tunnel *tb_tunnel_alloc_dp(struct tb *tb, struct tb_port *in,
-				     struct tb_port *out, int max_up,
-				     int max_down)
+				     struct tb_port *out, int link_nr,
+				     int max_up, int max_down)
 {
 	struct tb_tunnel *tunnel;
 	struct tb_path **paths;
@@ -884,21 +885,21 @@ struct tb_tunnel *tb_tunnel_alloc_dp(struct tb *tb, struct tb_port *in,
 	paths = tunnel->paths;
 
 	path = tb_path_alloc(tb, in, TB_DP_VIDEO_HOPID, out, TB_DP_VIDEO_HOPID,
-			     1, "Video");
+			     link_nr, "Video");
 	if (!path)
 		goto err_free;
 	tb_dp_init_video_path(path);
 	paths[TB_DP_VIDEO_PATH_OUT] = path;
 
 	path = tb_path_alloc(tb, in, TB_DP_AUX_TX_HOPID, out,
-			     TB_DP_AUX_TX_HOPID, 1, "AUX TX");
+			     TB_DP_AUX_TX_HOPID, link_nr, "AUX TX");
 	if (!path)
 		goto err_free;
 	tb_dp_init_aux_path(path);
 	paths[TB_DP_AUX_PATH_OUT] = path;
 
 	path = tb_path_alloc(tb, out, TB_DP_AUX_RX_HOPID, in,
-			     TB_DP_AUX_RX_HOPID, 1, "AUX RX");
+			     TB_DP_AUX_RX_HOPID, link_nr, "AUX RX");
 	if (!path)
 		goto err_free;
 	tb_dp_init_aux_path(path);
diff --git a/drivers/thunderbolt/tunnel.h b/drivers/thunderbolt/tunnel.h
index 03e56076b5bc..bb4d1f1d6d0b 100644
--- a/drivers/thunderbolt/tunnel.h
+++ b/drivers/thunderbolt/tunnel.h
@@ -71,8 +71,8 @@ struct tb_tunnel *tb_tunnel_alloc_pci(struct tb *tb, struct tb_port *up,
 struct tb_tunnel *tb_tunnel_discover_dp(struct tb *tb, struct tb_port *in,
 					bool alloc_hopid);
 struct tb_tunnel *tb_tunnel_alloc_dp(struct tb *tb, struct tb_port *in,
-				     struct tb_port *out, int max_up,
-				     int max_down);
+				     struct tb_port *out, int link_nr,
+				     int max_up, int max_down);
 struct tb_tunnel *tb_tunnel_alloc_dma(struct tb *tb, struct tb_port *nhi,
 				      struct tb_port *dst, int transmit_path,
 				      int transmit_ring, int receive_path,
diff --git a/drivers/tty/goldfish.c b/drivers/tty/goldfish.c
index 10c13b93ed52..9355d97ff591 100644
--- a/drivers/tty/goldfish.c
+++ b/drivers/tty/goldfish.c
@@ -405,6 +405,7 @@ static int goldfish_tty_probe(struct platform_device *pdev)
 err_tty_register_device_failed:
 	free_irq(irq, qtty);
 err_dec_line_count:
+	tty_port_destroy(&qtty->port);
 	goldfish_tty_current_line_count--;
 	if (goldfish_tty_current_line_count == 0)
 		goldfish_tty_delete_driver();
@@ -426,6 +427,7 @@ static int goldfish_tty_remove(struct platform_device *pdev)
 	iounmap(qtty->base);
 	qtty->base = NULL;
 	free_irq(qtty->irq, pdev);
+	tty_port_destroy(&qtty->port);
 	goldfish_tty_current_line_count--;
 	if (goldfish_tty_current_line_count == 0)
 		goldfish_tty_delete_driver();
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index efc72104c840..bdc314aeab88 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1975,6 +1975,35 @@ static bool canon_copy_from_read_buf(struct tty_struct *tty,
 	return ldata->read_tail != canon_head;
 }
 
+/*
+ * If we finished a read at the exact location of an
+ * EOF (special EOL character that's a __DISABLED_CHAR)
+ * in the stream, silently eat the EOF.
+ */
+static void canon_skip_eof(struct tty_struct *tty)
+{
+	struct n_tty_data *ldata = tty->disc_data;
+	size_t tail, canon_head;
+
+	canon_head = smp_load_acquire(&ldata->canon_head);
+	tail = ldata->read_tail;
+
+	// No data?
+	if (tail == canon_head)
+		return;
+
+	// See if the tail position is EOF in the circular buffer
+	tail &= (N_TTY_BUF_SIZE - 1);
+	if (!test_bit(tail, ldata->read_flags))
+		return;
+	if (read_buf(ldata, tail) != __DISABLED_CHAR)
+		return;
+
+	// Clear the EOL bit, skip the EOF char.
+	clear_bit(tail, ldata->read_flags);
+	smp_store_release(&ldata->read_tail, ldata->read_tail + 1);
+}
+
 /**
  * job_control		-	check job control
  * @tty: tty
@@ -2045,7 +2074,14 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 	 */
 	if (*cookie) {
 		if (ldata->icanon && !L_EXTPROC(tty)) {
-			if (canon_copy_from_read_buf(tty, &kb, &nr))
+			/*
+			 * If we have filled the user buffer, see
+			 * if we should skip an EOF character before
+			 * releasing the lock and returning done.
+			 */
+			if (!nr)
+				canon_skip_eof(tty);
+			else if (canon_copy_from_read_buf(tty, &kb, &nr))
 				return kb - kbuf;
 		} else {
 			if (copy_from_read_buf(tty, &kb, &nr))
diff --git a/drivers/tty/serial/8250/8250_aspeed_vuart.c b/drivers/tty/serial/8250/8250_aspeed_vuart.c
index c2cecc6f47db..179bb1375636 100644
--- a/drivers/tty/serial/8250/8250_aspeed_vuart.c
+++ b/drivers/tty/serial/8250/8250_aspeed_vuart.c
@@ -429,6 +429,8 @@ static int aspeed_vuart_probe(struct platform_device *pdev)
 	timer_setup(&vuart->unthrottle_timer, aspeed_vuart_unthrottle_exp, 0);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	if (!res)
+		return -EINVAL;
 
 	memset(&port, 0, sizeof(port));
 	port.port.private_data = vuart;
diff --git a/drivers/tty/serial/8250/8250_fintek.c b/drivers/tty/serial/8250/8250_fintek.c
index 251f0018ae8c..dba5950b8d0e 100644
--- a/drivers/tty/serial/8250/8250_fintek.c
+++ b/drivers/tty/serial/8250/8250_fintek.c
@@ -200,12 +200,12 @@ static int fintek_8250_rs485_config(struct uart_port *port,
 	if (!pdata)
 		return -EINVAL;
 
-	/* Hardware do not support same RTS level on send and receive */
-	if (!(rs485->flags & SER_RS485_RTS_ON_SEND) ==
-			!(rs485->flags & SER_RS485_RTS_AFTER_SEND))
-		return -EINVAL;
 
 	if (rs485->flags & SER_RS485_ENABLED) {
+		/* Hardware do not support same RTS level on send and receive */
+		if (!(rs485->flags & SER_RS485_RTS_ON_SEND) ==
+		    !(rs485->flags & SER_RS485_RTS_AFTER_SEND))
+			return -EINVAL;
 		memset(rs485->padding, 0, sizeof(rs485->padding));
 		config |= RS485_URA;
 	} else {
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index d6d3db9c3b1f..db07d6a5d764 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1247,7 +1247,7 @@ static int cpm_uart_init_port(struct device_node *np,
 	}
 
 #ifdef CONFIG_PPC_EARLY_DEBUG_CPM
-#ifdef CONFIG_CONSOLE_POLL
+#if defined(CONFIG_CONSOLE_POLL) && defined(CONFIG_SERIAL_CPM_CONSOLE)
 	if (!udbg_port)
 #endif
 		udbg_putc = NULL;
diff --git a/drivers/tty/serial/digicolor-usart.c b/drivers/tty/serial/digicolor-usart.c
index c7f81aa1ce91..5fea9bf86e85 100644
--- a/drivers/tty/serial/digicolor-usart.c
+++ b/drivers/tty/serial/digicolor-usart.c
@@ -309,6 +309,8 @@ static void digicolor_uart_set_termios(struct uart_port *port,
 	case CS8:
 	default:
 		config |= UA_CONFIG_CHAR_LEN;
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= CS8;
 		break;
 	}
 
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index d32c25bc973b..b1307ef34468 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -239,8 +239,6 @@
 /* IMX lpuart has four extra unused regs located at the beginning */
 #define IMX_REG_OFF	0x10
 
-static DEFINE_IDA(fsl_lpuart_ida);
-
 enum lpuart_type {
 	VF610_LPUART,
 	LS1021A_LPUART,
@@ -276,7 +274,6 @@ struct lpuart_port {
 	int			rx_dma_rng_buf_len;
 	unsigned int		dma_tx_nents;
 	wait_queue_head_t	dma_wait;
-	bool			id_allocated;
 };
 
 struct lpuart_soc_data {
@@ -2711,23 +2708,18 @@ static int lpuart_probe(struct platform_device *pdev)
 
 	ret = of_alias_get_id(np, "serial");
 	if (ret < 0) {
-		ret = ida_simple_get(&fsl_lpuart_ida, 0, UART_NR, GFP_KERNEL);
-		if (ret < 0) {
-			dev_err(&pdev->dev, "port line is full, add device failed\n");
-			return ret;
-		}
-		sport->id_allocated = true;
+		dev_err(&pdev->dev, "failed to get alias id, errno %d\n", ret);
+		return ret;
 	}
 	if (ret >= ARRAY_SIZE(lpuart_ports)) {
 		dev_err(&pdev->dev, "serial%d out of range\n", ret);
-		ret = -EINVAL;
-		goto failed_out_of_range;
+		return -EINVAL;
 	}
 	sport->port.line = ret;
 
 	ret = lpuart_enable_clks(sport);
 	if (ret)
-		goto failed_clock_enable;
+		return ret;
 	sport->port.uartclk = lpuart_get_baud_clk_rate(sport);
 
 	lpuart_ports[sport->port.line] = sport;
@@ -2775,10 +2767,6 @@ static int lpuart_probe(struct platform_device *pdev)
 	uart_remove_one_port(&lpuart_reg, &sport->port);
 failed_attach_port:
 	lpuart_disable_clks(sport);
-failed_clock_enable:
-failed_out_of_range:
-	if (sport->id_allocated)
-		ida_simple_remove(&fsl_lpuart_ida, sport->port.line);
 	return ret;
 }
 
@@ -2788,9 +2776,6 @@ static int lpuart_remove(struct platform_device *pdev)
 
 	uart_remove_one_port(&lpuart_reg, &sport->port);
 
-	if (sport->id_allocated)
-		ida_simple_remove(&fsl_lpuart_ida, sport->port.line);
-
 	lpuart_disable_clks(sport);
 
 	if (sport->dma_tx_chan)
@@ -2920,7 +2905,6 @@ static int __init lpuart_serial_init(void)
 
 static void __exit lpuart_serial_exit(void)
 {
-	ida_destroy(&fsl_lpuart_ida);
 	platform_driver_unregister(&lpuart_driver);
 	uart_unregister_driver(&lpuart_reg);
 }
diff --git a/drivers/tty/serial/icom.c b/drivers/tty/serial/icom.c
index 03a2fe9f4c9a..02b375ba2f07 100644
--- a/drivers/tty/serial/icom.c
+++ b/drivers/tty/serial/icom.c
@@ -1501,7 +1501,7 @@ static int icom_probe(struct pci_dev *dev,
 	retval = pci_read_config_dword(dev, PCI_COMMAND, &command_reg);
 	if (retval) {
 		dev_err(&dev->dev, "PCI Config read FAILED\n");
-		return retval;
+		goto probe_exit0;
 	}
 
 	pci_write_config_dword(dev, PCI_COMMAND,
diff --git a/drivers/tty/serial/meson_uart.c b/drivers/tty/serial/meson_uart.c
index 45e00d928253..54a6b488bc8c 100644
--- a/drivers/tty/serial/meson_uart.c
+++ b/drivers/tty/serial/meson_uart.c
@@ -253,6 +253,14 @@ static const char *meson_uart_type(struct uart_port *port)
 	return (port->type == PORT_MESON) ? "meson_uart" : NULL;
 }
 
+/*
+ * This function is called only from probe() using a temporary io mapping
+ * in order to perform a reset before setting up the device. Since the
+ * temporarily mapped region was successfully requested, there can be no
+ * console on this port at this time. Hence it is not necessary for this
+ * function to acquire the port->lock. (Since there is no console on this
+ * port at this time, the port->lock is not initialized yet.)
+ */
 static void meson_uart_reset(struct uart_port *port)
 {
 	u32 val;
@@ -267,9 +275,12 @@ static void meson_uart_reset(struct uart_port *port)
 
 static int meson_uart_startup(struct uart_port *port)
 {
+	unsigned long flags;
 	u32 val;
 	int ret = 0;
 
+	spin_lock_irqsave(&port->lock, flags);
+
 	val = readl(port->membase + AML_UART_CONTROL);
 	val |= AML_UART_CLEAR_ERR;
 	writel(val, port->membase + AML_UART_CONTROL);
@@ -285,6 +296,8 @@ static int meson_uart_startup(struct uart_port *port)
 	val = (AML_UART_RECV_IRQ(1) | AML_UART_XMIT_IRQ(port->fifosize / 2));
 	writel(val, port->membase + AML_UART_MISC);
 
+	spin_unlock_irqrestore(&port->lock, flags);
+
 	ret = request_irq(port->irq, meson_uart_interrupt, 0,
 			  port->name, port);
 
diff --git a/drivers/tty/serial/msm_serial.c b/drivers/tty/serial/msm_serial.c
index 23c94b927776..e676ec761f18 100644
--- a/drivers/tty/serial/msm_serial.c
+++ b/drivers/tty/serial/msm_serial.c
@@ -1599,6 +1599,7 @@ static inline struct uart_port *msm_get_port_from_line(unsigned int line)
 static void __msm_console_write(struct uart_port *port, const char *s,
 				unsigned int count, bool is_uartdm)
 {
+	unsigned long flags;
 	int i;
 	int num_newlines = 0;
 	bool replaced = false;
@@ -1616,6 +1617,8 @@ static void __msm_console_write(struct uart_port *port, const char *s,
 			num_newlines++;
 	count += num_newlines;
 
+	local_irq_save(flags);
+
 	if (port->sysrq)
 		locked = 0;
 	else if (oops_in_progress)
@@ -1661,6 +1664,8 @@ static void __msm_console_write(struct uart_port *port, const char *s,
 
 	if (locked)
 		spin_unlock(&port->lock);
+
+	local_irq_restore(flags);
 }
 
 static void msm_console_write(struct console *co, const char *s,
diff --git a/drivers/tty/serial/owl-uart.c b/drivers/tty/serial/owl-uart.c
index 91f1eb0058d7..9a6611cfc18e 100644
--- a/drivers/tty/serial/owl-uart.c
+++ b/drivers/tty/serial/owl-uart.c
@@ -731,6 +731,7 @@ static int owl_uart_probe(struct platform_device *pdev)
 	owl_port->port.uartclk = clk_get_rate(owl_port->clk);
 	if (owl_port->port.uartclk == 0) {
 		dev_err(&pdev->dev, "clock rate is zero\n");
+		clk_disable_unprepare(owl_port->clk);
 		return -EINVAL;
 	}
 	owl_port->port.flags = UPF_BOOT_AUTOCONF | UPF_IOREMAP | UPF_LOW_LATENCY;
diff --git a/drivers/tty/serial/rda-uart.c b/drivers/tty/serial/rda-uart.c
index d550d8fa2fab..a8fe1c3ebcd9 100644
--- a/drivers/tty/serial/rda-uart.c
+++ b/drivers/tty/serial/rda-uart.c
@@ -262,6 +262,8 @@ static void rda_uart_set_termios(struct uart_port *port,
 		fallthrough;
 	case CS7:
 		ctrl &= ~RDA_UART_DBITS_8;
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= CS7;
 		break;
 	default:
 		ctrl |= RDA_UART_DBITS_8;
diff --git a/drivers/tty/serial/sa1100.c b/drivers/tty/serial/sa1100.c
index 697b6a002a16..4ddcc985621a 100644
--- a/drivers/tty/serial/sa1100.c
+++ b/drivers/tty/serial/sa1100.c
@@ -446,6 +446,8 @@ sa1100_set_termios(struct uart_port *port, struct ktermios *termios,
 	baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk/16); 
 	quot = uart_get_divisor(port, baud);
 
+	del_timer_sync(&sport->timer);
+
 	spin_lock_irqsave(&sport->port.lock, flags);
 
 	sport->port.read_status_mask &= UTSR0_TO_SM(UTSR0_TFS);
@@ -476,8 +478,6 @@ sa1100_set_termios(struct uart_port *port, struct ktermios *termios,
 				UTSR1_TO_SM(UTSR1_ROR);
 	}
 
-	del_timer_sync(&sport->timer);
-
 	/*
 	 * Update the per-port timeout.
 	 */
diff --git a/drivers/tty/serial/serial_txx9.c b/drivers/tty/serial/serial_txx9.c
index aaca4fe38486..1f8362d5e3b9 100644
--- a/drivers/tty/serial/serial_txx9.c
+++ b/drivers/tty/serial/serial_txx9.c
@@ -644,6 +644,8 @@ serial_txx9_set_termios(struct uart_port *port, struct ktermios *termios,
 	case CS6:	/* not supported */
 	case CS8:
 		cval |= TXX9_SILCR_UMODE_8BIT;
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= CS8;
 		break;
 	}
 
diff --git a/drivers/tty/serial/sh-sci.c b/drivers/tty/serial/sh-sci.c
index 968967d722d4..e55895f0a4ff 100644
--- a/drivers/tty/serial/sh-sci.c
+++ b/drivers/tty/serial/sh-sci.c
@@ -2379,8 +2379,12 @@ static void sci_set_termios(struct uart_port *port, struct ktermios *termios,
 	int best_clk = -1;
 	unsigned long flags;
 
-	if ((termios->c_cflag & CSIZE) == CS7)
+	if ((termios->c_cflag & CSIZE) == CS7) {
 		smr_val |= SCSMR_CHR;
+	} else {
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= CS8;
+	}
 	if (termios->c_cflag & PARENB)
 		smr_val |= SCSMR_PE;
 	if (termios->c_cflag & PARODD)
diff --git a/drivers/tty/serial/sifive.c b/drivers/tty/serial/sifive.c
index b79900d0e91a..cba44483cb03 100644
--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -666,12 +666,16 @@ static void sifive_serial_set_termios(struct uart_port *port,
 	int rate;
 	char nstop;
 
-	if ((termios->c_cflag & CSIZE) != CS8)
+	if ((termios->c_cflag & CSIZE) != CS8) {
 		dev_err_once(ssp->port.dev, "only 8-bit words supported\n");
+		termios->c_cflag &= ~CSIZE;
+		termios->c_cflag |= CS8;
+	}
 	if (termios->c_iflag & (INPCK | PARMRK))
 		dev_err_once(ssp->port.dev, "parity checking not supported\n");
 	if (termios->c_iflag & BRKINT)
 		dev_err_once(ssp->port.dev, "BREAK detection not supported\n");
+	termios->c_iflag &= ~(INPCK|PARMRK|BRKINT);
 
 	/* Set number of stop bits */
 	nstop = (termios->c_cflag & CSTOPB) ? 2 : 1;
@@ -998,7 +1002,7 @@ static int sifive_serial_probe(struct platform_device *pdev)
 	/* Set up clock divider */
 	ssp->clkin_rate = clk_get_rate(ssp->clk);
 	ssp->baud_rate = SIFIVE_DEFAULT_BAUD_RATE;
-	ssp->port.uartclk = ssp->baud_rate * 16;
+	ssp->port.uartclk = ssp->clkin_rate;
 	__ssp_update_div(ssp);
 
 	platform_set_drvdata(pdev, ssp);
diff --git a/drivers/tty/serial/st-asc.c b/drivers/tty/serial/st-asc.c
index 87e480cc8206..5a45633aaea8 100644
--- a/drivers/tty/serial/st-asc.c
+++ b/drivers/tty/serial/st-asc.c
@@ -535,10 +535,14 @@ static void asc_set_termios(struct uart_port *port, struct ktermios *termios,
 	/* set character length */
 	if ((cflag & CSIZE) == CS7) {
 		ctrl_val |= ASC_CTL_MODE_7BIT_PAR;
+		cflag |= PARENB;
 	} else {
 		ctrl_val |= (cflag & PARENB) ?  ASC_CTL_MODE_8BIT_PAR :
 						ASC_CTL_MODE_8BIT;
+		cflag &= ~CSIZE;
+		cflag |= CS8;
 	}
+	termios->c_cflag = cflag;
 
 	/* set stop bit */
 	ctrl_val |= (cflag & CSTOPB) ? ASC_CTL_STOP_2BIT : ASC_CTL_STOP_1BIT;
diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
index 9570002d07e7..9bc970be59ba 100644
--- a/drivers/tty/serial/stm32-usart.c
+++ b/drivers/tty/serial/stm32-usart.c
@@ -1037,13 +1037,22 @@ static void stm32_usart_set_termios(struct uart_port *port,
 	 * CS8 or (CS7 + parity), 8 bits word aka [M1:M0] = 0b00
 	 * M0 and M1 already cleared by cr1 initialization.
 	 */
-	if (bits == 9)
+	if (bits == 9) {
 		cr1 |= USART_CR1_M0;
-	else if ((bits == 7) && cfg->has_7bits_data)
+	} else if ((bits == 7) && cfg->has_7bits_data) {
 		cr1 |= USART_CR1_M1;
-	else if (bits != 8)
+	} else if (bits != 8) {
 		dev_dbg(port->dev, "Unsupported data bits config: %u bits\n"
 			, bits);
+		cflag &= ~CSIZE;
+		cflag |= CS8;
+		termios->c_cflag = cflag;
+		bits = 8;
+		if (cflag & PARENB) {
+			bits++;
+			cr1 |= USART_CR1_M0;
+		}
+	}
 
 	if (ofs->rtor != UNDEF_REG && (stm32_port->rx_ch ||
 				       (stm32_port->fifoen &&
diff --git a/drivers/tty/serial/uartlite.c b/drivers/tty/serial/uartlite.c
index e1fa52d31474..7c788c697f3e 100644
--- a/drivers/tty/serial/uartlite.c
+++ b/drivers/tty/serial/uartlite.c
@@ -321,7 +321,8 @@ static void ulite_set_termios(struct uart_port *port, struct ktermios *termios,
 	struct uartlite_data *pdata = port->private_data;
 
 	/* Set termios to what the hardware supports */
-	termios->c_cflag &= ~(BRKINT | CSTOPB | PARENB | PARODD | CSIZE);
+	termios->c_iflag &= ~BRKINT;
+	termios->c_cflag &= ~(CSTOPB | PARENB | PARODD | CSIZE);
 	termios->c_cflag |= pdata->cflags & (PARENB | PARODD | CSIZE);
 	tty_termios_encode_baud_rate(termios, pdata->baud, pdata->baud);
 
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index 25c558e65ece..9bc2a9265277 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -1746,6 +1746,8 @@ static int hdlcdev_init(struct slgt_info *info)
  */
 static void hdlcdev_exit(struct slgt_info *info)
 {
+	if (!info->netdev)
+		return;
 	unregister_hdlc_device(info->netdev);
 	free_netdev(info->netdev);
 	info->netdev = NULL;
diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index bbfd004449b5..34cfdda4aff5 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -232,8 +232,10 @@ static void showacpu(void *dummy)
 	unsigned long flags;
 
 	/* Idle CPUs have no interesting backtrace. */
-	if (idle_cpu(smp_processor_id()))
+	if (idle_cpu(smp_processor_id())) {
+		pr_info("CPU%d: backtrace skipped as idling\n", smp_processor_id());
 		return;
+	}
 
 	raw_spin_lock_irqsave(&show_lock, flags);
 	pr_info("CPU%d:\n", smp_processor_id());
@@ -260,10 +262,13 @@ static void sysrq_handle_showallcpus(int key)
 
 		if (in_hardirq())
 			regs = get_irq_regs();
-		if (regs) {
-			pr_info("CPU%d:\n", smp_processor_id());
+
+		pr_info("CPU%d:\n", smp_processor_id());
+		if (regs)
 			show_regs(regs);
-		}
+		else
+			show_stack(NULL, NULL, KERN_INFO);
+
 		schedule_work(&sysrq_showallcpus);
 	}
 }
diff --git a/drivers/usb/core/hcd-pci.c b/drivers/usb/core/hcd-pci.c
index d630cccd2e6e..5af810cd8a58 100644
--- a/drivers/usb/core/hcd-pci.c
+++ b/drivers/usb/core/hcd-pci.c
@@ -616,10 +616,10 @@ const struct dev_pm_ops usb_hcd_pci_pm_ops = {
 	.suspend_noirq	= hcd_pci_suspend_noirq,
 	.resume_noirq	= hcd_pci_resume_noirq,
 	.resume		= hcd_pci_resume,
-	.freeze		= check_root_hub_suspended,
+	.freeze		= hcd_pci_suspend,
 	.freeze_noirq	= check_root_hub_suspended,
 	.thaw_noirq	= NULL,
-	.thaw		= NULL,
+	.thaw		= hcd_pci_resume,
 	.poweroff	= hcd_pci_suspend,
 	.poweroff_noirq	= hcd_pci_suspend_noirq,
 	.restore_noirq	= hcd_pci_resume_noirq,
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index eee3504397e6..fe2a58c75861 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -4544,7 +4544,6 @@ static int dwc2_hsotg_udc_start(struct usb_gadget *gadget,
 
 	WARN_ON(hsotg->driver);
 
-	driver->driver.bus = NULL;
 	hsotg->driver = driver;
 	hsotg->gadget.dev.of_node = hsotg->dev->of_node;
 	hsotg->gadget.speed = USB_SPEED_UNKNOWN;
diff --git a/drivers/usb/dwc3/drd.c b/drivers/usb/dwc3/drd.c
index f148b0370f82..81ff21bd405a 100644
--- a/drivers/usb/dwc3/drd.c
+++ b/drivers/usb/dwc3/drd.c
@@ -454,13 +454,8 @@ static struct extcon_dev *dwc3_get_extcon(struct dwc3 *dwc)
 	 * This device property is for kernel internal use only and
 	 * is expected to be set by the glue code.
 	 */
-	if (device_property_read_string(dev, "linux,extcon-name", &name) == 0) {
-		edev = extcon_get_extcon_dev(name);
-		if (!edev)
-			return ERR_PTR(-EPROBE_DEFER);
-
-		return edev;
-	}
+	if (device_property_read_string(dev, "linux,extcon-name", &name) == 0)
+		return extcon_get_extcon_dev(name);
 
 	/*
 	 * Try to get an extcon device from the USB PHY controller's "port"
diff --git a/drivers/usb/dwc3/dwc3-pci.c b/drivers/usb/dwc3/dwc3-pci.c
index f08b2178fd32..9c8887615701 100644
--- a/drivers/usb/dwc3/dwc3-pci.c
+++ b/drivers/usb/dwc3/dwc3-pci.c
@@ -256,7 +256,7 @@ static void dwc3_pci_resume_work(struct work_struct *work)
 	int ret;
 
 	ret = pm_runtime_get_sync(&dwc3->dev);
-	if (ret) {
+	if (ret < 0) {
 		pm_runtime_put_sync_autosuspend(&dwc3->dev);
 		return;
 	}
diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 78ec6af79c7f..5c1ae0d0ed47 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1978,10 +1978,10 @@ static void dwc3_gadget_ep_skip_trbs(struct dwc3_ep *dep, struct dwc3_request *r
 static void dwc3_gadget_ep_cleanup_cancelled_requests(struct dwc3_ep *dep)
 {
 	struct dwc3_request		*req;
-	struct dwc3_request		*tmp;
 	struct dwc3			*dwc = dep->dwc;
 
-	list_for_each_entry_safe(req, tmp, &dep->cancelled_list, list) {
+	while (!list_empty(&dep->cancelled_list)) {
+		req = next_request(&dep->cancelled_list);
 		dwc3_gadget_ep_skip_trbs(dep, req);
 		switch (req->status) {
 		case DWC3_REQUEST_STATUS_DISCONNECTED:
@@ -1998,6 +1998,12 @@ static void dwc3_gadget_ep_cleanup_cancelled_requests(struct dwc3_ep *dep)
 			dwc3_gadget_giveback(dep, req, -ECONNRESET);
 			break;
 		}
+		/*
+		 * The endpoint is disabled, let the dwc3_remove_requests()
+		 * handle the cleanup.
+		 */
+		if (!dep->endpoint.desc)
+			break;
 	}
 }
 
@@ -3288,15 +3294,21 @@ static void dwc3_gadget_ep_cleanup_completed_requests(struct dwc3_ep *dep,
 		const struct dwc3_event_depevt *event, int status)
 {
 	struct dwc3_request	*req;
-	struct dwc3_request	*tmp;
 
-	list_for_each_entry_safe(req, tmp, &dep->started_list, list) {
+	while (!list_empty(&dep->started_list)) {
 		int ret;
 
+		req = next_request(&dep->started_list);
 		ret = dwc3_gadget_ep_cleanup_completed_request(dep, event,
 				req, status);
 		if (ret)
 			break;
+		/*
+		 * The endpoint is disabled, let the dwc3_remove_requests()
+		 * handle the cleanup.
+		 */
+		if (!dep->endpoint.desc)
+			break;
 	}
 }
 
diff --git a/drivers/usb/dwc3/host.c b/drivers/usb/dwc3/host.c
index eda871973d6c..f56c30cf151e 100644
--- a/drivers/usb/dwc3/host.c
+++ b/drivers/usb/dwc3/host.c
@@ -7,7 +7,6 @@
  * Authors: Felipe Balbi <balbi@ti.com>,
  */
 
-#include <linux/acpi.h>
 #include <linux/irq.h>
 #include <linux/of.h>
 #include <linux/platform_device.h>
@@ -83,7 +82,6 @@ int dwc3_host_init(struct dwc3 *dwc)
 	}
 
 	xhci->dev.parent	= dwc->dev;
-	ACPI_COMPANION_SET(&xhci->dev, ACPI_COMPANION(dwc->dev));
 
 	dwc->xhci = xhci;
 
diff --git a/drivers/usb/host/isp116x-hcd.c b/drivers/usb/host/isp116x-hcd.c
index 8835f6bd528e..8c7f0991c21b 100644
--- a/drivers/usb/host/isp116x-hcd.c
+++ b/drivers/usb/host/isp116x-hcd.c
@@ -1541,10 +1541,12 @@ static int isp116x_remove(struct platform_device *pdev)
 
 	iounmap(isp116x->data_reg);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
-	release_mem_region(res->start, 2);
+	if (res)
+		release_mem_region(res->start, 2);
 	iounmap(isp116x->addr_reg);
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	release_mem_region(res->start, 2);
+	if (res)
+		release_mem_region(res->start, 2);
 
 	usb_put_hcd(hcd);
 	return 0;
diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-hcd.c
index e82ff2a49672..4f5498521e1b 100644
--- a/drivers/usb/host/oxu210hp-hcd.c
+++ b/drivers/usb/host/oxu210hp-hcd.c
@@ -3909,8 +3909,10 @@ static int oxu_bus_suspend(struct usb_hcd *hcd)
 		}
 	}
 
+	spin_unlock_irq(&oxu->lock);
 	/* turn off now-idle HC */
 	del_timer_sync(&oxu->watchdog);
+	spin_lock_irq(&oxu->lock);
 	ehci_halt(oxu);
 	hcd->state = HC_STATE_SUSPENDED;
 
diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
index d2b7e613eb34..f571a65ae6ee 100644
--- a/drivers/usb/musb/omap2430.c
+++ b/drivers/usb/musb/omap2430.c
@@ -362,6 +362,7 @@ static int omap2430_probe(struct platform_device *pdev)
 	control_node = of_parse_phandle(np, "ctrl-module", 0);
 	if (control_node) {
 		control_pdev = of_find_device_by_node(control_node);
+		of_node_put(control_node);
 		if (!control_pdev) {
 			dev_err(&pdev->dev, "Failed to get control device\n");
 			ret = -EINVAL;
diff --git a/drivers/usb/phy/phy-omap-otg.c b/drivers/usb/phy/phy-omap-otg.c
index ee0863c6553e..6e6ef8c0bc7e 100644
--- a/drivers/usb/phy/phy-omap-otg.c
+++ b/drivers/usb/phy/phy-omap-otg.c
@@ -95,8 +95,8 @@ static int omap_otg_probe(struct platform_device *pdev)
 		return -ENODEV;
 
 	extcon = extcon_get_extcon_dev(config->extcon);
-	if (!extcon)
-		return -EPROBE_DEFER;
+	if (IS_ERR(extcon))
+		return PTR_ERR(extcon);
 
 	otg_dev = devm_kzalloc(&pdev->dev, sizeof(*otg_dev), GFP_KERNEL);
 	if (!otg_dev)
diff --git a/drivers/usb/storage/karma.c b/drivers/usb/storage/karma.c
index 05cec81dcd3f..38ddfedef629 100644
--- a/drivers/usb/storage/karma.c
+++ b/drivers/usb/storage/karma.c
@@ -174,24 +174,25 @@ static void rio_karma_destructor(void *extra)
 
 static int rio_karma_init(struct us_data *us)
 {
-	int ret = 0;
 	struct karma_data *data = kzalloc(sizeof(struct karma_data), GFP_NOIO);
 
 	if (!data)
-		goto out;
+		return -ENOMEM;
 
 	data->recv = kmalloc(RIO_RECV_LEN, GFP_NOIO);
 	if (!data->recv) {
 		kfree(data);
-		goto out;
+		return -ENOMEM;
 	}
 
 	us->extra = data;
 	us->extra_destructor = rio_karma_destructor;
-	ret = rio_karma_send_command(RIO_ENTER_STORAGE, us);
-	data->in_storage = (ret == 0);
-out:
-	return ret;
+	if (rio_karma_send_command(RIO_ENTER_STORAGE, us))
+		return -EIO;
+
+	data->in_storage = 1;
+
+	return 0;
 }
 
 static struct scsi_host_template karma_host_template;
diff --git a/drivers/usb/typec/mux.c b/drivers/usb/typec/mux.c
index c8340de0ed49..d2aaf294b649 100644
--- a/drivers/usb/typec/mux.c
+++ b/drivers/usb/typec/mux.c
@@ -131,8 +131,11 @@ typec_switch_register(struct device *parent,
 	sw->dev.class = &typec_mux_class;
 	sw->dev.type = &typec_switch_dev_type;
 	sw->dev.driver_data = desc->drvdata;
-	dev_set_name(&sw->dev, "%s-switch",
-		     desc->name ? desc->name : dev_name(parent));
+	ret = dev_set_name(&sw->dev, "%s-switch", desc->name ? desc->name : dev_name(parent));
+	if (ret) {
+		put_device(&sw->dev);
+		return ERR_PTR(ret);
+	}
 
 	ret = device_add(&sw->dev);
 	if (ret) {
@@ -338,8 +341,11 @@ typec_mux_register(struct device *parent, const struct typec_mux_desc *desc)
 	mux->dev.class = &typec_mux_class;
 	mux->dev.type = &typec_mux_dev_type;
 	mux->dev.driver_data = desc->drvdata;
-	dev_set_name(&mux->dev, "%s-mux",
-		     desc->name ? desc->name : dev_name(parent));
+	ret = dev_set_name(&mux->dev, "%s-mux", desc->name ? desc->name : dev_name(parent));
+	if (ret) {
+		put_device(&mux->dev);
+		return ERR_PTR(ret);
+	}
 
 	ret = device_add(&mux->dev);
 	if (ret) {
diff --git a/drivers/usb/typec/tcpm/fusb302.c b/drivers/usb/typec/tcpm/fusb302.c
index 72f9001b0792..96c55eaf3f80 100644
--- a/drivers/usb/typec/tcpm/fusb302.c
+++ b/drivers/usb/typec/tcpm/fusb302.c
@@ -1708,8 +1708,8 @@ static int fusb302_probe(struct i2c_client *client,
 	 */
 	if (device_property_read_string(dev, "linux,extcon-name", &name) == 0) {
 		chip->extcon = extcon_get_extcon_dev(name);
-		if (!chip->extcon)
-			return -EPROBE_DEFER;
+		if (IS_ERR(chip->extcon))
+			return PTR_ERR(chip->extcon);
 	}
 
 	chip->vbus = devm_regulator_get(chip->dev, "vbus");
diff --git a/drivers/usb/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
index d8d3892e5a69..3c6d452e3bf4 100644
--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -393,7 +393,6 @@ static int stub_probe(struct usb_device *udev)
 
 err_port:
 	dev_set_drvdata(&udev->dev, NULL);
-	usb_put_dev(udev);
 
 	/* we already have busid_priv, just lock busid_lock */
 	spin_lock(&busid_priv->busid_lock);
@@ -408,6 +407,7 @@ static int stub_probe(struct usb_device *udev)
 	put_busid_priv(busid_priv);
 
 sdev_free:
+	usb_put_dev(udev);
 	stub_device_free(sdev);
 
 	return rc;
diff --git a/drivers/usb/usbip/stub_rx.c b/drivers/usb/usbip/stub_rx.c
index 325c22008e53..5dd41e8215e0 100644
--- a/drivers/usb/usbip/stub_rx.c
+++ b/drivers/usb/usbip/stub_rx.c
@@ -138,7 +138,9 @@ static int tweak_set_configuration_cmd(struct urb *urb)
 	req = (struct usb_ctrlrequest *) urb->setup_packet;
 	config = le16_to_cpu(req->wValue);
 
+	usb_lock_device(sdev->udev);
 	err = usb_set_configuration(sdev->udev, config);
+	usb_unlock_device(sdev->udev);
 	if (err && err != -ENODEV)
 		dev_err(&sdev->udev->dev, "can't set config #%d, error %d\n",
 			config, err);
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index d1a6b5ab543c..474c6120c955 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -514,7 +514,6 @@ static int ifcvf_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
 	}
 
 	ifcvf_mgmt_dev->adapter = adapter;
-	pci_set_drvdata(pdev, ifcvf_mgmt_dev);
 
 	vf = &adapter->vf;
 	vf->dev_type = get_dev_type(pdev);
@@ -629,6 +628,8 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err;
 	}
 
+	pci_set_drvdata(pdev, ifcvf_mgmt_dev);
+
 	return 0;
 
 err:
diff --git a/drivers/vdpa/vdpa.c b/drivers/vdpa/vdpa.c
index 1ea525433a5c..4e7351110e43 100644
--- a/drivers/vdpa/vdpa.c
+++ b/drivers/vdpa/vdpa.c
@@ -756,14 +756,19 @@ static int vdpa_nl_cmd_dev_get_doit(struct sk_buff *skb, struct genl_info *info)
 		goto mdev_err;
 	}
 	err = vdpa_dev_fill(vdev, msg, info->snd_portid, info->snd_seq, 0, info->extack);
-	if (!err)
-		err = genlmsg_reply(msg, info);
+	if (err)
+		goto mdev_err;
+
+	err = genlmsg_reply(msg, info);
+	put_device(dev);
+	mutex_unlock(&vdpa_dev_mutex);
+	return err;
+
 mdev_err:
 	put_device(dev);
 err:
 	mutex_unlock(&vdpa_dev_mutex);
-	if (err)
-		nlmsg_free(msg);
+	nlmsg_free(msg);
 	return err;
 }
 
diff --git a/drivers/vdpa/vdpa_user/vduse_dev.c b/drivers/vdpa/vdpa_user/vduse_dev.c
index f85d1a08ed87..160e40d03084 100644
--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -1344,9 +1344,9 @@ static int vduse_create_dev(struct vduse_dev_config *config,
 
 	dev->minor = ret;
 	dev->msg_timeout = VDUSE_MSG_DEFAULT_TIMEOUT;
-	dev->dev = device_create(vduse_class, NULL,
-				 MKDEV(MAJOR(vduse_major), dev->minor),
-				 dev, "%s", config->name);
+	dev->dev = device_create_with_groups(vduse_class, NULL,
+				MKDEV(MAJOR(vduse_major), dev->minor),
+				dev, vduse_dev_groups, "%s", config->name);
 	if (IS_ERR(dev->dev)) {
 		ret = PTR_ERR(dev->dev);
 		goto err_dev;
@@ -1595,7 +1595,6 @@ static int vduse_init(void)
 		return PTR_ERR(vduse_class);
 
 	vduse_class->devnode = vduse_devnode;
-	vduse_class->dev_groups = vduse_dev_groups;
 
 	ret = alloc_chrdev_region(&vduse_major, 0, VDUSE_DEV_MAX, "vduse");
 	if (ret)
diff --git a/drivers/vhost/vringh.c b/drivers/vhost/vringh.c
index 14e2043d7685..eab55accf381 100644
--- a/drivers/vhost/vringh.c
+++ b/drivers/vhost/vringh.c
@@ -292,7 +292,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 	     int (*copy)(const struct vringh *vrh,
 			 void *dst, const void *src, size_t len))
 {
-	int err, count = 0, up_next, desc_max;
+	int err, count = 0, indirect_count = 0, up_next, desc_max;
 	struct vring_desc desc, *descs;
 	struct vringh_range range = { -1ULL, 0 }, slowrange;
 	bool slow = false;
@@ -349,7 +349,12 @@ __vringh_iov(struct vringh *vrh, u16 i,
 			continue;
 		}
 
-		if (count++ == vrh->vring.num) {
+		if (up_next == -1)
+			count++;
+		else
+			indirect_count++;
+
+		if (count > vrh->vring.num || indirect_count > desc_max) {
 			vringh_bad("Descriptor loop in %p", descs);
 			err = -ELOOP;
 			goto fail;
@@ -411,6 +416,7 @@ __vringh_iov(struct vringh *vrh, u16 i,
 				i = return_from_indirect(vrh, &up_next,
 							 &descs, &desc_max);
 				slow = false;
+				indirect_count = 0;
 			} else
 				break;
 		}
diff --git a/drivers/video/fbdev/hyperv_fb.c b/drivers/video/fbdev/hyperv_fb.c
index c8e0ea27caf1..58c304a3b7c4 100644
--- a/drivers/video/fbdev/hyperv_fb.c
+++ b/drivers/video/fbdev/hyperv_fb.c
@@ -1009,7 +1009,6 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 	struct pci_dev *pdev  = NULL;
 	void __iomem *fb_virt;
 	int gen2vm = efi_enabled(EFI_BOOT);
-	resource_size_t pot_start, pot_end;
 	phys_addr_t paddr;
 	int ret;
 
@@ -1060,23 +1059,7 @@ static int hvfb_getmem(struct hv_device *hdev, struct fb_info *info)
 	dio_fb_size =
 		screen_width * screen_height * screen_depth / 8;
 
-	if (gen2vm) {
-		pot_start = 0;
-		pot_end = -1;
-	} else {
-		if (!(pci_resource_flags(pdev, 0) & IORESOURCE_MEM) ||
-		    pci_resource_len(pdev, 0) < screen_fb_size) {
-			pr_err("Resource not available or (0x%lx < 0x%lx)\n",
-			       (unsigned long) pci_resource_len(pdev, 0),
-			       (unsigned long) screen_fb_size);
-			goto err1;
-		}
-
-		pot_end = pci_resource_end(pdev, 0);
-		pot_start = pot_end - screen_fb_size + 1;
-	}
-
-	ret = vmbus_allocate_mmio(&par->mem, hdev, pot_start, pot_end,
+	ret = vmbus_allocate_mmio(&par->mem, hdev, 0, -1,
 				  screen_fb_size, 0x100000, true);
 	if (ret != 0) {
 		pr_err("Unable to allocate framebuffer memory\n");
diff --git a/drivers/video/fbdev/pxa3xx-gcu.c b/drivers/video/fbdev/pxa3xx-gcu.c
index 4279e13a3b58..9421d14d0eb0 100644
--- a/drivers/video/fbdev/pxa3xx-gcu.c
+++ b/drivers/video/fbdev/pxa3xx-gcu.c
@@ -650,6 +650,7 @@ static int pxa3xx_gcu_probe(struct platform_device *pdev)
 	for (i = 0; i < 8; i++) {
 		ret = pxa3xx_gcu_add_buffer(dev, priv);
 		if (ret) {
+			pxa3xx_gcu_free_buffers(dev, priv);
 			dev_err(dev, "failed to allocate DMA memory\n");
 			goto err_disable_clk;
 		}
@@ -666,15 +667,15 @@ static int pxa3xx_gcu_probe(struct platform_device *pdev)
 			SHARED_SIZE, irq);
 	return 0;
 
-err_free_dma:
-	dma_free_coherent(dev, SHARED_SIZE,
-			priv->shared, priv->shared_phys);
+err_disable_clk:
+	clk_disable_unprepare(priv->clk);
 
 err_misc_deregister:
 	misc_deregister(&priv->misc_dev);
 
-err_disable_clk:
-	clk_disable_unprepare(priv->clk);
+err_free_dma:
+	dma_free_coherent(dev, SHARED_SIZE,
+			  priv->shared, priv->shared_phys);
 
 	return ret;
 }
@@ -687,6 +688,7 @@ static int pxa3xx_gcu_remove(struct platform_device *pdev)
 	pxa3xx_gcu_wait_idle(priv);
 	misc_deregister(&priv->misc_dev);
 	dma_free_coherent(dev, SHARED_SIZE, priv->shared, priv->shared_phys);
+	clk_disable_unprepare(priv->clk);
 	pxa3xx_gcu_free_buffers(dev, priv);
 
 	return 0;
diff --git a/drivers/virtio/virtio_pci_modern_dev.c b/drivers/virtio/virtio_pci_modern_dev.c
index e8b3ff2b9fbc..6f6187fe8893 100644
--- a/drivers/virtio/virtio_pci_modern_dev.c
+++ b/drivers/virtio/virtio_pci_modern_dev.c
@@ -340,6 +340,7 @@ int vp_modern_probe(struct virtio_pci_modern_device *mdev)
 err_map_isr:
 	pci_iounmap(pci_dev, mdev->common);
 err_map_common:
+	pci_release_selected_regions(pci_dev, mdev->modern_bars);
 	return err;
 }
 EXPORT_SYMBOL_GPL(vp_modern_probe);
diff --git a/drivers/watchdog/rti_wdt.c b/drivers/watchdog/rti_wdt.c
index db843f825860..00ebeffc674f 100644
--- a/drivers/watchdog/rti_wdt.c
+++ b/drivers/watchdog/rti_wdt.c
@@ -226,7 +226,7 @@ static int rti_wdt_probe(struct platform_device *pdev)
 
 	pm_runtime_enable(dev);
 	ret = pm_runtime_get_sync(dev);
-	if (ret) {
+	if (ret < 0) {
 		pm_runtime_put_noidle(dev);
 		pm_runtime_disable(&pdev->dev);
 		return dev_err_probe(dev, ret, "runtime pm failed\n");
diff --git a/drivers/watchdog/rzg2l_wdt.c b/drivers/watchdog/rzg2l_wdt.c
index 6b426df34fd6..88274704b260 100644
--- a/drivers/watchdog/rzg2l_wdt.c
+++ b/drivers/watchdog/rzg2l_wdt.c
@@ -43,6 +43,8 @@ struct rzg2l_wdt_priv {
 	struct reset_control *rstc;
 	unsigned long osc_clk_rate;
 	unsigned long delay;
+	struct clk *pclk;
+	struct clk *osc_clk;
 };
 
 static void rzg2l_wdt_wait_delay(struct rzg2l_wdt_priv *priv)
@@ -53,7 +55,7 @@ static void rzg2l_wdt_wait_delay(struct rzg2l_wdt_priv *priv)
 
 static u32 rzg2l_wdt_get_cycle_usec(unsigned long cycle, u32 wdttime)
 {
-	u64 timer_cycle_us = 1024 * 1024 * (wdttime + 1) * MICRO;
+	u64 timer_cycle_us = 1024 * 1024ULL * (wdttime + 1) * MICRO;
 
 	return div64_ul(timer_cycle_us, cycle);
 }
@@ -86,7 +88,6 @@ static int rzg2l_wdt_start(struct watchdog_device *wdev)
 {
 	struct rzg2l_wdt_priv *priv = watchdog_get_drvdata(wdev);
 
-	reset_control_deassert(priv->rstc);
 	pm_runtime_get_sync(wdev->parent);
 
 	/* Initialize time out */
@@ -106,7 +107,7 @@ static int rzg2l_wdt_stop(struct watchdog_device *wdev)
 	struct rzg2l_wdt_priv *priv = watchdog_get_drvdata(wdev);
 
 	pm_runtime_put(wdev->parent);
-	reset_control_assert(priv->rstc);
+	reset_control_reset(priv->rstc);
 
 	return 0;
 }
@@ -118,7 +119,9 @@ static int rzg2l_wdt_restart(struct watchdog_device *wdev,
 
 	/* Reset the module before we modify any register */
 	reset_control_reset(priv->rstc);
-	pm_runtime_get_sync(wdev->parent);
+
+	clk_prepare_enable(priv->pclk);
+	clk_prepare_enable(priv->osc_clk);
 
 	/* smallest counter value to reboot soon */
 	rzg2l_wdt_write(priv, WDTSET_COUNTER_VAL(1), WDTSET);
@@ -151,12 +154,11 @@ static const struct watchdog_ops rzg2l_wdt_ops = {
 	.restart = rzg2l_wdt_restart,
 };
 
-static void rzg2l_wdt_reset_assert_pm_disable_put(void *data)
+static void rzg2l_wdt_reset_assert_pm_disable(void *data)
 {
 	struct watchdog_device *wdev = data;
 	struct rzg2l_wdt_priv *priv = watchdog_get_drvdata(wdev);
 
-	pm_runtime_put(wdev->parent);
 	pm_runtime_disable(wdev->parent);
 	reset_control_assert(priv->rstc);
 }
@@ -166,7 +168,6 @@ static int rzg2l_wdt_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct rzg2l_wdt_priv *priv;
 	unsigned long pclk_rate;
-	struct clk *wdt_clk;
 	int ret;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
@@ -178,22 +179,20 @@ static int rzg2l_wdt_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->base);
 
 	/* Get watchdog main clock */
-	wdt_clk = clk_get(&pdev->dev, "oscclk");
-	if (IS_ERR(wdt_clk))
-		return dev_err_probe(&pdev->dev, PTR_ERR(wdt_clk), "no oscclk");
+	priv->osc_clk = devm_clk_get(&pdev->dev, "oscclk");
+	if (IS_ERR(priv->osc_clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(priv->osc_clk), "no oscclk");
 
-	priv->osc_clk_rate = clk_get_rate(wdt_clk);
-	clk_put(wdt_clk);
+	priv->osc_clk_rate = clk_get_rate(priv->osc_clk);
 	if (!priv->osc_clk_rate)
 		return dev_err_probe(&pdev->dev, -EINVAL, "oscclk rate is 0");
 
 	/* Get Peripheral clock */
-	wdt_clk = clk_get(&pdev->dev, "pclk");
-	if (IS_ERR(wdt_clk))
-		return dev_err_probe(&pdev->dev, PTR_ERR(wdt_clk), "no pclk");
+	priv->pclk = devm_clk_get(&pdev->dev, "pclk");
+	if (IS_ERR(priv->pclk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(priv->pclk), "no pclk");
 
-	pclk_rate = clk_get_rate(wdt_clk);
-	clk_put(wdt_clk);
+	pclk_rate = clk_get_rate(priv->pclk);
 	if (!pclk_rate)
 		return dev_err_probe(&pdev->dev, -EINVAL, "pclk rate is 0");
 
@@ -206,11 +205,6 @@ static int rzg2l_wdt_probe(struct platform_device *pdev)
 
 	reset_control_deassert(priv->rstc);
 	pm_runtime_enable(&pdev->dev);
-	ret = pm_runtime_resume_and_get(&pdev->dev);
-	if (ret < 0) {
-		dev_err(dev, "pm_runtime_resume_and_get failed ret=%pe", ERR_PTR(ret));
-		goto out_pm_get;
-	}
 
 	priv->wdev.info = &rzg2l_wdt_ident;
 	priv->wdev.ops = &rzg2l_wdt_ops;
@@ -222,7 +216,7 @@ static int rzg2l_wdt_probe(struct platform_device *pdev)
 
 	watchdog_set_drvdata(&priv->wdev, priv);
 	ret = devm_add_action_or_reset(&pdev->dev,
-				       rzg2l_wdt_reset_assert_pm_disable_put,
+				       rzg2l_wdt_reset_assert_pm_disable,
 				       &priv->wdev);
 	if (ret < 0)
 		return ret;
@@ -235,12 +229,6 @@ static int rzg2l_wdt_probe(struct platform_device *pdev)
 		dev_warn(dev, "Specified timeout invalid, using default");
 
 	return devm_watchdog_register_device(&pdev->dev, &priv->wdev);
-
-out_pm_get:
-	pm_runtime_disable(dev);
-	reset_control_assert(priv->rstc);
-
-	return ret;
 }
 
 static const struct of_device_id rzg2l_wdt_ids[] = {
diff --git a/drivers/watchdog/ts4800_wdt.c b/drivers/watchdog/ts4800_wdt.c
index c137ad2bd5c3..0ea554c7cda5 100644
--- a/drivers/watchdog/ts4800_wdt.c
+++ b/drivers/watchdog/ts4800_wdt.c
@@ -125,13 +125,16 @@ static int ts4800_wdt_probe(struct platform_device *pdev)
 	ret = of_property_read_u32_index(np, "syscon", 1, &reg);
 	if (ret < 0) {
 		dev_err(dev, "no offset in syscon\n");
+		of_node_put(syscon_np);
 		return ret;
 	}
 
 	/* allocate memory for watchdog struct */
 	wdt = devm_kzalloc(dev, sizeof(*wdt), GFP_KERNEL);
-	if (!wdt)
+	if (!wdt) {
+		of_node_put(syscon_np);
 		return -ENOMEM;
+	}
 
 	/* set regmap and offset to know where to write */
 	wdt->feed_offset = reg;
diff --git a/drivers/watchdog/wdat_wdt.c b/drivers/watchdog/wdat_wdt.c
index 195c8c004b69..4fac8148a8e6 100644
--- a/drivers/watchdog/wdat_wdt.c
+++ b/drivers/watchdog/wdat_wdt.c
@@ -462,6 +462,7 @@ static int wdat_wdt_probe(struct platform_device *pdev)
 		return ret;
 
 	watchdog_set_nowayout(&wdat->wdd, nowayout);
+	watchdog_stop_on_reboot(&wdat->wdd);
 	return devm_watchdog_register_device(dev, &wdat->wdd);
 }
 
diff --git a/drivers/xen/xlate_mmu.c b/drivers/xen/xlate_mmu.c
index 34742c6e189e..f17c4c03db30 100644
--- a/drivers/xen/xlate_mmu.c
+++ b/drivers/xen/xlate_mmu.c
@@ -261,7 +261,6 @@ int __init xen_xlate_map_ballooned_pages(xen_pfn_t **gfns, void **virt,
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(xen_xlate_map_ballooned_pages);
 
 struct remap_pfn {
 	struct mm_struct *mm;
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index da9b4f8577a1..7f1cb3b73874 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -462,8 +462,11 @@ static int afs_dir_iterate_block(struct afs_vnode *dvnode,
 		}
 
 		/* skip if starts before the current position */
-		if (offset < curr)
+		if (offset < curr) {
+			if (next > curr)
+				ctx->pos = blkoff + next * sizeof(union afs_xdr_dirent);
 			continue;
+		}
 
 		/* found the next entry */
 		if (!dir_emit(ctx, dire->u.name, nlen,
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index b34d6286ee90..7744db8f5bb0 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -4709,15 +4709,17 @@ void ceph_mdsc_pre_umount(struct ceph_mds_client *mdsc)
 }
 
 /*
- * wait for all write mds requests to flush.
+ * flush the mdlog and wait for all write mds requests to flush.
  */
-static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
+static void flush_mdlog_and_wait_mdsc_unsafe_requests(struct ceph_mds_client *mdsc,
+						 u64 want_tid)
 {
 	struct ceph_mds_request *req = NULL, *nextreq;
+	struct ceph_mds_session *last_session = NULL;
 	struct rb_node *n;
 
 	mutex_lock(&mdsc->mutex);
-	dout("wait_unsafe_requests want %lld\n", want_tid);
+	dout("%s want %lld\n", __func__, want_tid);
 restart:
 	req = __get_oldest_req(mdsc);
 	while (req && req->r_tid <= want_tid) {
@@ -4729,14 +4731,32 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
 			nextreq = NULL;
 		if (req->r_op != CEPH_MDS_OP_SETFILELOCK &&
 		    (req->r_op & CEPH_MDS_OP_WRITE)) {
+			struct ceph_mds_session *s = req->r_session;
+
+			if (!s) {
+				req = nextreq;
+				continue;
+			}
+
 			/* write op */
 			ceph_mdsc_get_request(req);
 			if (nextreq)
 				ceph_mdsc_get_request(nextreq);
+			s = ceph_get_mds_session(s);
 			mutex_unlock(&mdsc->mutex);
-			dout("wait_unsafe_requests  wait on %llu (want %llu)\n",
+
+			/* send flush mdlog request to MDS */
+			if (last_session != s) {
+				send_flush_mdlog(s);
+				ceph_put_mds_session(last_session);
+				last_session = s;
+			} else {
+				ceph_put_mds_session(s);
+			}
+			dout("%s wait on %llu (want %llu)\n", __func__,
 			     req->r_tid, want_tid);
 			wait_for_completion(&req->r_safe_completion);
+
 			mutex_lock(&mdsc->mutex);
 			ceph_mdsc_put_request(req);
 			if (!nextreq)
@@ -4751,7 +4771,8 @@ static void wait_unsafe_requests(struct ceph_mds_client *mdsc, u64 want_tid)
 		req = nextreq;
 	}
 	mutex_unlock(&mdsc->mutex);
-	dout("wait_unsafe_requests done\n");
+	ceph_put_mds_session(last_session);
+	dout("%s done\n", __func__);
 }
 
 void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
@@ -4780,7 +4801,7 @@ void ceph_mdsc_sync(struct ceph_mds_client *mdsc)
 	dout("sync want tid %lld flush_seq %lld\n",
 	     want_tid, want_flush);
 
-	wait_unsafe_requests(mdsc, want_tid);
+	flush_mdlog_and_wait_mdsc_unsafe_requests(mdsc, want_tid);
 	wait_caps_flush(mdsc, want_flush);
 }
 
diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
index fcf7dfdecf96..e41b22bd66ce 100644
--- a/fs/ceph/xattr.c
+++ b/fs/ceph/xattr.c
@@ -366,6 +366,14 @@ static ssize_t ceph_vxattrcb_auth_mds(struct ceph_inode_info *ci,
 	}
 #define XATTR_RSTAT_FIELD(_type, _name)			\
 	XATTR_NAME_CEPH(_type, _name, VXATTR_FLAG_RSTAT)
+#define XATTR_RSTAT_FIELD_UPDATABLE(_type, _name)			\
+	{								\
+		.name = CEPH_XATTR_NAME(_type, _name),			\
+		.name_size = sizeof (CEPH_XATTR_NAME(_type, _name)),	\
+		.getxattr_cb = ceph_vxattrcb_ ## _type ## _ ## _name,	\
+		.exists_cb = NULL,					\
+		.flags = VXATTR_FLAG_RSTAT,				\
+	}
 #define XATTR_LAYOUT_FIELD(_type, _name, _field)			\
 	{								\
 		.name = CEPH_XATTR_NAME2(_type, _name, _field),	\
@@ -404,7 +412,7 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
 	XATTR_RSTAT_FIELD(dir, rsubdirs),
 	XATTR_RSTAT_FIELD(dir, rsnaps),
 	XATTR_RSTAT_FIELD(dir, rbytes),
-	XATTR_RSTAT_FIELD(dir, rctime),
+	XATTR_RSTAT_FIELD_UPDATABLE(dir, rctime),
 	{
 		.name = "ceph.dir.pin",
 		.name_size = sizeof("ceph.dir.pin"),
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index a6363d362c48..12829b62fcc9 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1084,7 +1084,7 @@ struct file_system_type cifs_fs_type = {
 };
 MODULE_ALIAS_FS("cifs");
 
-static struct file_system_type smb3_fs_type = {
+struct file_system_type smb3_fs_type = {
 	.owner = THIS_MODULE,
 	.name = "smb3",
 	.init_fs_context = smb3_init_fs_context,
diff --git a/fs/cifs/cifsfs.h b/fs/cifs/cifsfs.h
index 15a5c5db038b..6e1791afcd87 100644
--- a/fs/cifs/cifsfs.h
+++ b/fs/cifs/cifsfs.h
@@ -38,7 +38,7 @@ static inline unsigned long cifs_get_time(struct dentry *dentry)
 	return (unsigned long) dentry->d_fsdata;
 }
 
-extern struct file_system_type cifs_fs_type;
+extern struct file_system_type cifs_fs_type, smb3_fs_type;
 extern const struct address_space_operations cifs_addr_ops;
 extern const struct address_space_operations cifs_addr_ops_smallbuf;
 
diff --git a/fs/cifs/cifsglob.h b/fs/cifs/cifsglob.h
index 7f28fe8f6ba7..bf6cc128436a 100644
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -1915,11 +1915,13 @@ extern mempool_t *cifs_mid_poolp;
 
 /* Operations for different SMB versions */
 #define SMB1_VERSION_STRING	"1.0"
+#define SMB20_VERSION_STRING    "2.0"
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 extern struct smb_version_operations smb1_operations;
 extern struct smb_version_values smb1_values;
-#define SMB20_VERSION_STRING	"2.0"
 extern struct smb_version_operations smb20_operations;
 extern struct smb_version_values smb20_values;
+#endif /* CIFS_ALLOW_INSECURE_LEGACY */
 #define SMB21_VERSION_STRING	"2.1"
 extern struct smb_version_operations smb21_operations;
 extern struct smb_version_values smb21_values;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index faf4587804d9..9dc0c7ccd5e8 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -97,6 +97,10 @@ static int reconn_set_ipaddr_from_hostname(struct TCP_Server_Info *server)
 	if (!server->hostname)
 		return -EINVAL;
 
+	/* if server hostname isn't populated, there's nothing to do here */
+	if (server->hostname[0] == '\0')
+		return 0;
+
 	len = strlen(server->hostname) + 3;
 
 	unc = kmalloc(len, GFP_KERNEL);
diff --git a/fs/cifs/misc.c b/fs/cifs/misc.c
index 5a803d686146..4abf36b3b345 100644
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -1209,18 +1209,23 @@ static struct super_block *__cifs_get_super(void (*f)(struct super_block *, void
 		.data = data,
 		.sb = NULL,
 	};
+	struct file_system_type **fs_type = (struct file_system_type *[]) {
+		&cifs_fs_type, &smb3_fs_type, NULL,
+	};
 
-	iterate_supers_type(&cifs_fs_type, f, &sd);
-
-	if (!sd.sb)
-		return ERR_PTR(-EINVAL);
-	/*
-	 * Grab an active reference in order to prevent automounts (DFS links)
-	 * of expiring and then freeing up our cifs superblock pointer while
-	 * we're doing failover.
-	 */
-	cifs_sb_active(sd.sb);
-	return sd.sb;
+	for (; *fs_type; fs_type++) {
+		iterate_supers_type(*fs_type, f, &sd);
+		if (sd.sb) {
+			/*
+			 * Grab an active reference in order to prevent automounts (DFS links)
+			 * of expiring and then freeing up our cifs superblock pointer while
+			 * we're doing failover.
+			 */
+			cifs_sb_active(sd.sb);
+			return sd.sb;
+		}
+	}
+	return ERR_PTR(-EINVAL);
 }
 
 static void __cifs_put_super(struct super_block *sb)
diff --git a/fs/cifs/sess.c b/fs/cifs/sess.c
index 1a0995bb5d90..822da5689166 100644
--- a/fs/cifs/sess.c
+++ b/fs/cifs/sess.c
@@ -274,7 +274,10 @@ cifs_ses_add_channel(struct cifs_sb_info *cifs_sb, struct cifs_ses *ses,
 	/* Auth */
 	ctx.domainauto = ses->domainAuto;
 	ctx.domainname = ses->domainName;
-	ctx.server_hostname = ses->server->hostname;
+
+	/* no hostname for extra channels */
+	ctx.server_hostname = "";
+
 	ctx.username = ses->user_name;
 	ctx.password = ses->password;
 	ctx.sectype = ses->sectype;
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index ab74a678fb93..e0a1cb4b9f19 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -4297,11 +4297,13 @@ smb3_set_oplock_level(struct cifsInodeInfo *cinode, __u32 oplock,
 	}
 }
 
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 static bool
 smb2_is_read_op(__u32 oplock)
 {
 	return oplock == SMB2_OPLOCK_LEVEL_II;
 }
+#endif /* CIFS_ALLOW_INSECURE_LEGACY */
 
 static bool
 smb21_is_read_op(__u32 oplock)
@@ -5400,7 +5402,7 @@ smb2_make_node(unsigned int xid, struct inode *inode,
 	return rc;
 }
 
-
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 struct smb_version_operations smb20_operations = {
 	.compare_fids = smb2_compare_fids,
 	.setup_request = smb2_setup_request,
@@ -5499,6 +5501,7 @@ struct smb_version_operations smb20_operations = {
 	.is_status_io_timeout = smb2_is_status_io_timeout,
 	.is_network_name_deleted = smb2_is_network_name_deleted,
 };
+#endif /* CIFS_ALLOW_INSECURE_LEGACY */
 
 struct smb_version_operations smb21_operations = {
 	.compare_fids = smb2_compare_fids,
@@ -5830,6 +5833,7 @@ struct smb_version_operations smb311_operations = {
 	.is_network_name_deleted = smb2_is_network_name_deleted,
 };
 
+#ifdef CONFIG_CIFS_ALLOW_INSECURE_LEGACY
 struct smb_version_values smb20_values = {
 	.version_string = SMB20_VERSION_STRING,
 	.protocol_id = SMB20_PROT_ID,
@@ -5850,6 +5854,7 @@ struct smb_version_values smb20_values = {
 	.signing_required = SMB2_NEGOTIATE_SIGNING_REQUIRED,
 	.create_lease_size = sizeof(struct create_lease),
 };
+#endif /* ALLOW_INSECURE_LEGACY */
 
 struct smb_version_values smb21_values = {
 	.version_string = SMB21_VERSION_STRING,
diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 55e6879ef18b..4cdc54ffa366 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -288,6 +288,9 @@ smb2_reconnect(__le16 smb2_command, struct cifs_tcon *tcon,
 			mutex_unlock(&ses->session_mutex);
 			rc = -EHOSTDOWN;
 			goto failed;
+		} else if (rc) {
+			mutex_unlock(&ses->session_mutex);
+			goto out;
 		}
 	} else {
 		mutex_unlock(&ses->session_mutex);
diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index bf3ba85cf325..1438ae53c73c 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -151,7 +151,7 @@ static bool __is_bitmap_valid(struct f2fs_sb_info *sbi, block_t blkaddr,
 		f2fs_err(sbi, "Inconsistent error blkaddr:%u, sit bitmap:%d",
 			 blkaddr, exist);
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
-		WARN_ON(1);
+		dump_stack();
 	}
 	return exist;
 }
@@ -189,7 +189,7 @@ bool f2fs_is_valid_blkaddr(struct f2fs_sb_info *sbi,
 			f2fs_warn(sbi, "access invalid blkaddr:%u",
 				  blkaddr);
 			set_sbi_flag(sbi, SBI_NEED_FSCK);
-			WARN_ON(1);
+			dump_stack();
 			return false;
 		} else {
 			return __is_bitmap_valid(sbi, blkaddr, type);
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 29cd65f7c9eb..a2b7dead68e0 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -2679,6 +2679,7 @@ static int f2fs_defragment_range(struct f2fs_sb_info *sbi,
 			}
 
 			set_page_dirty(page);
+			set_page_private_gcing(page);
 			f2fs_put_page(page, 1);
 
 			idx++;
diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index d6cb4b52758b..69d1d8ad0903 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -120,6 +120,7 @@ static bool inode_io_list_move_locked(struct inode *inode,
 				      struct list_head *head)
 {
 	assert_spin_locked(&wb->list_lock);
+	assert_spin_locked(&inode->i_lock);
 
 	list_move(&inode->i_io_list, head);
 
@@ -1402,9 +1403,9 @@ static int move_expired_inodes(struct list_head *delaying_queue,
 		inode = wb_inode(delaying_queue->prev);
 		if (inode_dirtied_after(inode, dirtied_before))
 			break;
+		spin_lock(&inode->i_lock);
 		list_move(&inode->i_io_list, &tmp);
 		moved++;
-		spin_lock(&inode->i_lock);
 		inode->i_state |= I_SYNC_QUEUED;
 		spin_unlock(&inode->i_lock);
 		if (sb_is_blkdev_sb(inode->i_sb))
@@ -1420,7 +1421,12 @@ static int move_expired_inodes(struct list_head *delaying_queue,
 		goto out;
 	}
 
-	/* Move inodes from one superblock together */
+	/*
+	 * Although inode's i_io_list is moved from 'tmp' to 'dispatch_queue',
+	 * we don't take inode->i_lock here because it is just a pointless overhead.
+	 * Inode is already marked as I_SYNC_QUEUED so writeback list handling is
+	 * fully under our control.
+	 */
 	while (!list_empty(&tmp)) {
 		sb = wb_inode(tmp.prev)->i_sb;
 		list_for_each_prev_safe(pos, node, &tmp) {
@@ -1863,8 +1869,8 @@ static long writeback_sb_inodes(struct super_block *sb,
 			 * We'll have another go at writing back this inode
 			 * when we completed a full scan of b_io.
 			 */
-			spin_unlock(&inode->i_lock);
 			requeue_io(inode, wb);
+			spin_unlock(&inode->i_lock);
 			trace_writeback_sb_inodes_requeue(inode);
 			continue;
 		}
@@ -2400,6 +2406,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 {
 	struct super_block *sb = inode->i_sb;
 	int dirtytime = 0;
+	struct bdi_writeback *wb = NULL;
 
 	trace_writeback_mark_inode_dirty(inode, flags);
 
@@ -2451,6 +2458,17 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 			inode->i_state &= ~I_DIRTY_TIME;
 		inode->i_state |= flags;
 
+		/*
+		 * Grab inode's wb early because it requires dropping i_lock and we
+		 * need to make sure following checks happen atomically with dirty
+		 * list handling so that we don't move inodes under flush worker's
+		 * hands.
+		 */
+		if (!was_dirty) {
+			wb = locked_inode_to_wb_and_lock_list(inode);
+			spin_lock(&inode->i_lock);
+		}
+
 		/*
 		 * If the inode is queued for writeback by flush worker, just
 		 * update its dirty state. Once the flush worker is done with
@@ -2458,7 +2476,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 * list, based upon its state.
 		 */
 		if (inode->i_state & I_SYNC_QUEUED)
-			goto out_unlock_inode;
+			goto out_unlock;
 
 		/*
 		 * Only add valid (hashed) inodes to the superblock's
@@ -2466,22 +2484,19 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 		 */
 		if (!S_ISBLK(inode->i_mode)) {
 			if (inode_unhashed(inode))
-				goto out_unlock_inode;
+				goto out_unlock;
 		}
 		if (inode->i_state & I_FREEING)
-			goto out_unlock_inode;
+			goto out_unlock;
 
 		/*
 		 * If the inode was already on b_dirty/b_io/b_more_io, don't
 		 * reposition it (that would break b_dirty time-ordering).
 		 */
 		if (!was_dirty) {
-			struct bdi_writeback *wb;
 			struct list_head *dirty_list;
 			bool wakeup_bdi = false;
 
-			wb = locked_inode_to_wb_and_lock_list(inode);
-
 			inode->dirtied_when = jiffies;
 			if (dirtytime)
 				inode->dirtied_time_when = jiffies;
@@ -2495,6 +2510,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 							       dirty_list);
 
 			spin_unlock(&wb->list_lock);
+			spin_unlock(&inode->i_lock);
 			trace_writeback_dirty_inode_enqueue(inode);
 
 			/*
@@ -2509,6 +2525,9 @@ void __mark_inode_dirty(struct inode *inode, int flags)
 			return;
 		}
 	}
+out_unlock:
+	if (wb)
+		spin_unlock(&wb->list_lock);
 out_unlock_inode:
 	spin_unlock(&inode->i_lock);
 }
diff --git a/fs/inode.c b/fs/inode.c
index 63324df6fa27..a5b45dac0083 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -27,7 +27,7 @@
  * Inode locking rules:
  *
  * inode->i_lock protects:
- *   inode->i_state, inode->i_hash, __iget()
+ *   inode->i_state, inode->i_hash, __iget(), inode->i_io_list
  * Inode LRU list locks protect:
  *   inode->i_sb->s_inode_lru, inode->i_lru
  * inode->i_sb->s_inode_list_lock protects:
diff --git a/fs/jffs2/fs.c b/fs/jffs2/fs.c
index 71f03a5d36ed..f83a468b6488 100644
--- a/fs/jffs2/fs.c
+++ b/fs/jffs2/fs.c
@@ -604,6 +604,7 @@ int jffs2_do_fill_super(struct super_block *sb, struct fs_context *fc)
 	jffs2_free_raw_node_refs(c);
 	kvfree(c->blocks);
 	jffs2_clear_xattr_subsystem(c);
+	jffs2_sum_exit(c);
  out_inohash:
 	kfree(c->inocache_list);
  out_wbuf:
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 4096953390b4..52f3afeed612 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -18,7 +18,15 @@
 #include "kernfs-internal.h"
 
 static DEFINE_SPINLOCK(kernfs_rename_lock);	/* kn->parent and ->name */
-static char kernfs_pr_cont_buf[PATH_MAX];	/* protected by rename_lock */
+/*
+ * Don't use rename_lock to piggy back on pr_cont_buf. We don't want to
+ * call pr_cont() while holding rename_lock. Because sometimes pr_cont()
+ * will perform wakeups when releasing console_sem. Holding rename_lock
+ * will introduce deadlock if the scheduler reads the kernfs_name in the
+ * wakeup path.
+ */
+static DEFINE_SPINLOCK(kernfs_pr_cont_lock);
+static char kernfs_pr_cont_buf[PATH_MAX];	/* protected by pr_cont_lock */
 static DEFINE_SPINLOCK(kernfs_idr_lock);	/* root->ino_idr */
 
 #define rb_to_kn(X) rb_entry((X), struct kernfs_node, rb)
@@ -229,12 +237,12 @@ void pr_cont_kernfs_name(struct kernfs_node *kn)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&kernfs_rename_lock, flags);
+	spin_lock_irqsave(&kernfs_pr_cont_lock, flags);
 
-	kernfs_name_locked(kn, kernfs_pr_cont_buf, sizeof(kernfs_pr_cont_buf));
+	kernfs_name(kn, kernfs_pr_cont_buf, sizeof(kernfs_pr_cont_buf));
 	pr_cont("%s", kernfs_pr_cont_buf);
 
-	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
+	spin_unlock_irqrestore(&kernfs_pr_cont_lock, flags);
 }
 
 /**
@@ -248,10 +256,10 @@ void pr_cont_kernfs_path(struct kernfs_node *kn)
 	unsigned long flags;
 	int sz;
 
-	spin_lock_irqsave(&kernfs_rename_lock, flags);
+	spin_lock_irqsave(&kernfs_pr_cont_lock, flags);
 
-	sz = kernfs_path_from_node_locked(kn, NULL, kernfs_pr_cont_buf,
-					  sizeof(kernfs_pr_cont_buf));
+	sz = kernfs_path_from_node(kn, NULL, kernfs_pr_cont_buf,
+				   sizeof(kernfs_pr_cont_buf));
 	if (sz < 0) {
 		pr_cont("(error)");
 		goto out;
@@ -265,7 +273,7 @@ void pr_cont_kernfs_path(struct kernfs_node *kn)
 	pr_cont("%s", kernfs_pr_cont_buf);
 
 out:
-	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
+	spin_unlock_irqrestore(&kernfs_pr_cont_lock, flags);
 }
 
 /**
@@ -823,13 +831,12 @@ static struct kernfs_node *kernfs_walk_ns(struct kernfs_node *parent,
 
 	lockdep_assert_held_read(&kernfs_root(parent)->kernfs_rwsem);
 
-	/* grab kernfs_rename_lock to piggy back on kernfs_pr_cont_buf */
-	spin_lock_irq(&kernfs_rename_lock);
+	spin_lock_irq(&kernfs_pr_cont_lock);
 
 	len = strlcpy(kernfs_pr_cont_buf, path, sizeof(kernfs_pr_cont_buf));
 
 	if (len >= sizeof(kernfs_pr_cont_buf)) {
-		spin_unlock_irq(&kernfs_rename_lock);
+		spin_unlock_irq(&kernfs_pr_cont_lock);
 		return NULL;
 	}
 
@@ -841,7 +848,7 @@ static struct kernfs_node *kernfs_walk_ns(struct kernfs_node *parent,
 		parent = kernfs_find_ns(parent, name, ns);
 	}
 
-	spin_unlock_irq(&kernfs_rename_lock);
+	spin_unlock_irq(&kernfs_pr_cont_lock);
 
 	return parent;
 }
diff --git a/fs/ksmbd/smbacl.c b/fs/ksmbd/smbacl.c
index 6ecf55ea1fed..38f23bf981ac 100644
--- a/fs/ksmbd/smbacl.c
+++ b/fs/ksmbd/smbacl.c
@@ -1261,6 +1261,7 @@ int smb_check_perm_dacl(struct ksmbd_conn *conn, struct path *path,
 					if (!access_bits)
 						access_bits =
 							SET_MINIMUM_RIGHTS;
+					posix_acl_release(posix_acls);
 					goto check_access_bits;
 				}
 			}
diff --git a/fs/ksmbd/transport_rdma.c b/fs/ksmbd/transport_rdma.c
index ba5a22bc2e6d..d3b60b833a81 100644
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -569,6 +569,7 @@ static void recv_done(struct ib_cq *cq, struct ib_wc *wc)
 		}
 		t->negotiation_requested = true;
 		t->full_packet_received = true;
+		t->status = SMB_DIRECT_CS_CONNECTED;
 		enqueue_reassembly(t, recvmsg, 0);
 		wake_up_interruptible(&t->wait_status);
 		break;
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 1db686509a3e..e9761f55ac9c 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3101,6 +3101,10 @@ static int _nfs4_open_and_get_state(struct nfs4_opendata *opendata,
 	}
 
 out:
+	if (opendata->lgp) {
+		nfs4_lgopen_release(opendata->lgp);
+		opendata->lgp = NULL;
+	}
 	if (!opendata->cancelled)
 		nfs4_sequence_free_slot(&opendata->o_res.seq_res);
 	return ret;
diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
index 63e09caf19b8..61c1d0bc22e7 100644
--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -1694,11 +1694,6 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
 	sbi->s_mount_opts = ZONEFS_MNTOPT_ERRORS_RO;
 	sbi->s_max_open_zones = bdev_max_open_zones(sb->s_bdev);
 	atomic_set(&sbi->s_open_zones, 0);
-	if (!sbi->s_max_open_zones &&
-	    sbi->s_mount_opts & ZONEFS_MNTOPT_EXPLICIT_OPEN) {
-		zonefs_info(sb, "No open zones limit. Ignoring explicit_open mount option\n");
-		sbi->s_mount_opts &= ~ZONEFS_MNTOPT_EXPLICIT_OPEN;
-	}
 
 	ret = zonefs_read_super(sb);
 	if (ret)
@@ -1717,6 +1712,12 @@ static int zonefs_fill_super(struct super_block *sb, void *data, int silent)
 	zonefs_info(sb, "Mounting %u zones",
 		    blkdev_nr_zones(sb->s_bdev->bd_disk));
 
+	if (!sbi->s_max_open_zones &&
+	    sbi->s_mount_opts & ZONEFS_MNTOPT_EXPLICIT_OPEN) {
+		zonefs_info(sb, "No open zones limit. Ignoring explicit_open mount option\n");
+		sbi->s_mount_opts &= ~ZONEFS_MNTOPT_EXPLICIT_OPEN;
+	}
+
 	/* Create root directory inode */
 	ret = -ENOMEM;
 	inode = new_inode(sb);
diff --git a/include/linux/export.h b/include/linux/export.h
index 27d848712b90..5910ccb66ca2 100644
--- a/include/linux/export.h
+++ b/include/linux/export.h
@@ -2,6 +2,8 @@
 #ifndef _LINUX_EXPORT_H
 #define _LINUX_EXPORT_H
 
+#include <linux/stringify.h>
+
 /*
  * Export symbols from the kernel to modules.  Forked from module.h
  * to reduce the amount of pointless cruft we feed to gcc when only
@@ -154,7 +156,6 @@ struct kernel_symbol {
 #endif /* CONFIG_MODULES */
 
 #ifdef DEFAULT_SYMBOL_NAMESPACE
-#include <linux/stringify.h>
 #define _EXPORT_SYMBOL(sym, sec)	__EXPORT_SYMBOL(sym, sec, __stringify(DEFAULT_SYMBOL_NAMESPACE))
 #else
 #define _EXPORT_SYMBOL(sym, sec)	__EXPORT_SYMBOL(sym, sec, "")
@@ -162,8 +163,8 @@ struct kernel_symbol {
 
 #define EXPORT_SYMBOL(sym)		_EXPORT_SYMBOL(sym, "")
 #define EXPORT_SYMBOL_GPL(sym)		_EXPORT_SYMBOL(sym, "_gpl")
-#define EXPORT_SYMBOL_NS(sym, ns)	__EXPORT_SYMBOL(sym, "", #ns)
-#define EXPORT_SYMBOL_NS_GPL(sym, ns)	__EXPORT_SYMBOL(sym, "_gpl", #ns)
+#define EXPORT_SYMBOL_NS(sym, ns)	__EXPORT_SYMBOL(sym, "", __stringify(ns))
+#define EXPORT_SYMBOL_NS_GPL(sym, ns)	__EXPORT_SYMBOL(sym, "_gpl", __stringify(ns))
 
 #endif /* !__ASSEMBLY__ */
 
diff --git a/include/linux/extcon.h b/include/linux/extcon.h
index 0c19010da77f..685401d94d39 100644
--- a/include/linux/extcon.h
+++ b/include/linux/extcon.h
@@ -296,7 +296,7 @@ static inline void devm_extcon_unregister_notifier_all(struct device *dev,
 
 static inline struct extcon_dev *extcon_get_extcon_dev(const char *extcon_name)
 {
-	return ERR_PTR(-ENODEV);
+	return NULL;
 }
 
 static inline struct extcon_dev *extcon_find_edev_by_node(struct device_node *node)
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 6906a45bc761..2cb105f12028 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -110,6 +110,7 @@ struct gendisk {
 #define GD_READ_ONLY			1
 #define GD_DEAD				2
 #define GD_NATIVE_CAPACITY		3
+#define GD_SUPPRESS_PART_SCAN		5
 
 	struct mutex open_mutex;	/* open/close mutex */
 	unsigned open_partitions;	/* number of open partitions */
diff --git a/include/linux/iio/common/st_sensors.h b/include/linux/iio/common/st_sensors.h
index 22f67845cdd3..db4a1b260348 100644
--- a/include/linux/iio/common/st_sensors.h
+++ b/include/linux/iio/common/st_sensors.h
@@ -237,6 +237,7 @@ struct st_sensor_settings {
  * @hw_irq_trigger: if we're using the hardware interrupt on the sensor.
  * @hw_timestamp: Latest timestamp from the interrupt handler, when in use.
  * @buffer_data: Data used by buffer part.
+ * @odr_lock: Local lock for preventing concurrent ODR accesses/changes
  */
 struct st_sensor_data {
 	struct iio_trigger *trig;
@@ -261,6 +262,8 @@ struct st_sensor_data {
 	s64 hw_timestamp;
 
 	char buffer_data[ST_SENSORS_MAX_BUFFER_SIZE] ____cacheline_aligned;
+
+	struct mutex odr_lock;
 };
 
 #ifdef CONFIG_IIO_BUFFER
diff --git a/include/linux/jump_label.h b/include/linux/jump_label.h
index 48b9b2a82767..019e55c13248 100644
--- a/include/linux/jump_label.h
+++ b/include/linux/jump_label.h
@@ -261,9 +261,9 @@ extern void static_key_disable_cpuslocked(struct static_key *key);
 #include <linux/atomic.h>
 #include <linux/bug.h>
 
-static inline int static_key_count(struct static_key *key)
+static __always_inline int static_key_count(struct static_key *key)
 {
-	return atomic_read(&key->enabled);
+	return arch_atomic_read(&key->enabled);
 }
 
 static __always_inline void jump_label_init(void)
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 49a48d7709ac..4cd54277d5d9 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -5175,12 +5175,11 @@ struct mlx5_ifc_query_qp_out_bits {
 
 	u8         syndrome[0x20];
 
-	u8         reserved_at_40[0x20];
-	u8         ece[0x20];
+	u8         reserved_at_40[0x40];
 
 	u8         opt_param_mask[0x20];
 
-	u8         reserved_at_a0[0x20];
+	u8         ece[0x20];
 
 	struct mlx5_ifc_qpc_bits qpc;
 
diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index c6199dbe2591..0f233b76c9ce 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -42,11 +42,11 @@
  * void nodes_shift_right(dst, src, n)	Shift right
  * void nodes_shift_left(dst, src, n)	Shift left
  *
- * int first_node(mask)			Number lowest set bit, or MAX_NUMNODES
- * int next_node(node, mask)		Next node past 'node', or MAX_NUMNODES
- * int next_node_in(node, mask)		Next node past 'node', or wrap to first,
+ * unsigned int first_node(mask)	Number lowest set bit, or MAX_NUMNODES
+ * unsigend int next_node(node, mask)	Next node past 'node', or MAX_NUMNODES
+ * unsigned int next_node_in(node, mask) Next node past 'node', or wrap to first,
  *					or MAX_NUMNODES
- * int first_unset_node(mask)		First node not set in mask, or 
+ * unsigned int first_unset_node(mask)	First node not set in mask, or
  *					MAX_NUMNODES
  *
  * nodemask_t nodemask_of_node(node)	Return nodemask with bit 'node' set
@@ -153,7 +153,7 @@ static inline void __nodes_clear(nodemask_t *dstp, unsigned int nbits)
 
 #define node_test_and_set(node, nodemask) \
 			__node_test_and_set((node), &(nodemask))
-static inline int __node_test_and_set(int node, nodemask_t *addr)
+static inline bool __node_test_and_set(int node, nodemask_t *addr)
 {
 	return test_and_set_bit(node, addr->bits);
 }
@@ -200,7 +200,7 @@ static inline void __nodes_complement(nodemask_t *dstp,
 
 #define nodes_equal(src1, src2) \
 			__nodes_equal(&(src1), &(src2), MAX_NUMNODES)
-static inline int __nodes_equal(const nodemask_t *src1p,
+static inline bool __nodes_equal(const nodemask_t *src1p,
 					const nodemask_t *src2p, unsigned int nbits)
 {
 	return bitmap_equal(src1p->bits, src2p->bits, nbits);
@@ -208,7 +208,7 @@ static inline int __nodes_equal(const nodemask_t *src1p,
 
 #define nodes_intersects(src1, src2) \
 			__nodes_intersects(&(src1), &(src2), MAX_NUMNODES)
-static inline int __nodes_intersects(const nodemask_t *src1p,
+static inline bool __nodes_intersects(const nodemask_t *src1p,
 					const nodemask_t *src2p, unsigned int nbits)
 {
 	return bitmap_intersects(src1p->bits, src2p->bits, nbits);
@@ -216,20 +216,20 @@ static inline int __nodes_intersects(const nodemask_t *src1p,
 
 #define nodes_subset(src1, src2) \
 			__nodes_subset(&(src1), &(src2), MAX_NUMNODES)
-static inline int __nodes_subset(const nodemask_t *src1p,
+static inline bool __nodes_subset(const nodemask_t *src1p,
 					const nodemask_t *src2p, unsigned int nbits)
 {
 	return bitmap_subset(src1p->bits, src2p->bits, nbits);
 }
 
 #define nodes_empty(src) __nodes_empty(&(src), MAX_NUMNODES)
-static inline int __nodes_empty(const nodemask_t *srcp, unsigned int nbits)
+static inline bool __nodes_empty(const nodemask_t *srcp, unsigned int nbits)
 {
 	return bitmap_empty(srcp->bits, nbits);
 }
 
 #define nodes_full(nodemask) __nodes_full(&(nodemask), MAX_NUMNODES)
-static inline int __nodes_full(const nodemask_t *srcp, unsigned int nbits)
+static inline bool __nodes_full(const nodemask_t *srcp, unsigned int nbits)
 {
 	return bitmap_full(srcp->bits, nbits);
 }
@@ -260,15 +260,15 @@ static inline void __nodes_shift_left(nodemask_t *dstp,
           > MAX_NUMNODES, then the silly min_ts could be dropped. */
 
 #define first_node(src) __first_node(&(src))
-static inline int __first_node(const nodemask_t *srcp)
+static inline unsigned int __first_node(const nodemask_t *srcp)
 {
-	return min_t(int, MAX_NUMNODES, find_first_bit(srcp->bits, MAX_NUMNODES));
+	return min_t(unsigned int, MAX_NUMNODES, find_first_bit(srcp->bits, MAX_NUMNODES));
 }
 
 #define next_node(n, src) __next_node((n), &(src))
-static inline int __next_node(int n, const nodemask_t *srcp)
+static inline unsigned int __next_node(int n, const nodemask_t *srcp)
 {
-	return min_t(int,MAX_NUMNODES,find_next_bit(srcp->bits, MAX_NUMNODES, n+1));
+	return min_t(unsigned int, MAX_NUMNODES, find_next_bit(srcp->bits, MAX_NUMNODES, n+1));
 }
 
 /*
@@ -276,7 +276,7 @@ static inline int __next_node(int n, const nodemask_t *srcp)
  * the first node in src if needed.  Returns MAX_NUMNODES if src is empty.
  */
 #define next_node_in(n, src) __next_node_in((n), &(src))
-int __next_node_in(int node, const nodemask_t *srcp);
+unsigned int __next_node_in(int node, const nodemask_t *srcp);
 
 static inline void init_nodemask_of_node(nodemask_t *mask, int node)
 {
@@ -296,9 +296,9 @@ static inline void init_nodemask_of_node(nodemask_t *mask, int node)
 })
 
 #define first_unset_node(mask) __first_unset_node(&(mask))
-static inline int __first_unset_node(const nodemask_t *maskp)
+static inline unsigned int __first_unset_node(const nodemask_t *maskp)
 {
-	return min_t(int,MAX_NUMNODES,
+	return min_t(unsigned int, MAX_NUMNODES,
 			find_first_zero_bit(maskp->bits, MAX_NUMNODES));
 }
 
@@ -435,11 +435,11 @@ static inline int num_node_state(enum node_states state)
 
 #define first_online_node	first_node(node_states[N_ONLINE])
 #define first_memory_node	first_node(node_states[N_MEMORY])
-static inline int next_online_node(int nid)
+static inline unsigned int next_online_node(int nid)
 {
 	return next_node(nid, node_states[N_ONLINE]);
 }
-static inline int next_memory_node(int nid)
+static inline unsigned int next_memory_node(int nid)
 {
 	return next_node(nid, node_states[N_MEMORY]);
 }
diff --git a/include/linux/random.h b/include/linux/random.h
index 917470c4490a..3feafab498ad 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -13,7 +13,7 @@
 struct notifier_block;
 
 void add_device_randomness(const void *buf, size_t len);
-void add_bootloader_randomness(const void *buf, size_t len);
+void __init add_bootloader_randomness(const void *buf, size_t len);
 void add_input_randomness(unsigned int type, unsigned int code,
 			  unsigned int value) __latent_entropy;
 void add_interrupt_randomness(int irq) __latent_entropy;
diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 66e28bc1a023..9409a3d26dfd 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -1506,6 +1506,7 @@ void *xas_find_marked(struct xa_state *, unsigned long max, xa_mark_t);
 void xas_init_marks(const struct xa_state *);
 
 bool xas_nomem(struct xa_state *, gfp_t);
+void xas_destroy(struct xa_state *);
 void xas_pause(struct xa_state *);
 
 void xas_create_range(struct xa_state *);
diff --git a/include/net/ax25.h b/include/net/ax25.h
index 8221af1811df..5253692db9eb 100644
--- a/include/net/ax25.h
+++ b/include/net/ax25.h
@@ -240,6 +240,7 @@ typedef struct ax25_dev {
 	ax25_dama_info		dama;
 #endif
 	refcount_t		refcount;
+	bool device_up;
 } ax25_dev;
 
 typedef struct ax25_cb {
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 4524920e4895..f397b0a3d631 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -155,21 +155,18 @@ struct bdaddr_list_with_irk {
 	u8 local_irk[16];
 };
 
+/* Bitmask of connection flags */
 enum hci_conn_flags {
-	HCI_CONN_FLAG_REMOTE_WAKEUP,
-	HCI_CONN_FLAG_DEVICE_PRIVACY,
-
-	__HCI_CONN_NUM_FLAGS,
+	HCI_CONN_FLAG_REMOTE_WAKEUP = 1,
+	HCI_CONN_FLAG_DEVICE_PRIVACY = 2,
 };
-
-/* Make sure number of flags doesn't exceed sizeof(current_flags) */
-static_assert(__HCI_CONN_NUM_FLAGS < 32);
+typedef u8 hci_conn_flags_t;
 
 struct bdaddr_list_with_flags {
 	struct list_head list;
 	bdaddr_t bdaddr;
 	u8 bdaddr_type;
-	DECLARE_BITMAP(flags, __HCI_CONN_NUM_FLAGS);
+	hci_conn_flags_t flags;
 };
 
 struct bt_uuid {
@@ -567,7 +564,7 @@ struct hci_dev {
 	struct rfkill		*rfkill;
 
 	DECLARE_BITMAP(dev_flags, __HCI_NUM_FLAGS);
-	DECLARE_BITMAP(conn_flags, __HCI_CONN_NUM_FLAGS);
+	hci_conn_flags_t	conn_flags;
 
 	__s8			adv_tx_power;
 	__u8			adv_data[HCI_MAX_EXT_AD_LENGTH];
@@ -763,7 +760,7 @@ struct hci_conn_params {
 
 	struct hci_conn *conn;
 	bool explicit_connect;
-	DECLARE_BITMAP(flags, __HCI_CONN_NUM_FLAGS);
+	hci_conn_flags_t flags;
 	u8  privacy_mode;
 };
 
diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 5b8c54eb7a6b..7a10e4ed5540 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -591,5 +591,6 @@ int flow_indr_dev_setup_offload(struct net_device *dev, struct Qdisc *sch,
 				enum tc_setup_type type, void *data,
 				struct flow_block_offload *bo,
 				void (*cleanup)(struct flow_block_cb *block_cb));
+bool flow_indr_dev_exists(void);
 
 #endif /* _NET_FLOW_OFFLOAD_H */
diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index c4c0861deac1..c3fdd9f71c05 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1089,7 +1089,6 @@ struct nft_stats {
 
 struct nft_hook {
 	struct list_head	list;
-	bool			inactive;
 	struct nf_hook_ops	ops;
 	struct rcu_head		rcu;
 };
diff --git a/include/net/netfilter/nf_tables_offload.h b/include/net/netfilter/nf_tables_offload.h
index 797147843958..3568b6a2f5f0 100644
--- a/include/net/netfilter/nf_tables_offload.h
+++ b/include/net/netfilter/nf_tables_offload.h
@@ -92,7 +92,7 @@ int nft_flow_rule_offload_commit(struct net *net);
 	NFT_OFFLOAD_MATCH(__key, __base, __field, __len, __reg)		\
 	memset(&(__reg)->mask, 0xff, (__reg)->len);
 
-int nft_chain_offload_priority(struct nft_base_chain *basechain);
+bool nft_chain_offload_support(const struct nft_base_chain *basechain);
 
 int nft_offload_init(void);
 void nft_offload_exit(void);
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 472843eedbae..6764fc265745 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -187,37 +187,17 @@ static inline bool qdisc_run_begin(struct Qdisc *qdisc)
 		if (spin_trylock(&qdisc->seqlock))
 			return true;
 
-		/* Paired with smp_mb__after_atomic() to make sure
-		 * STATE_MISSED checking is synchronized with clearing
-		 * in pfifo_fast_dequeue().
+		/* No need to insist if the MISSED flag was already set.
+		 * Note that test_and_set_bit() also gives us memory ordering
+		 * guarantees wrt potential earlier enqueue() and below
+		 * spin_trylock(), both of which are necessary to prevent races
 		 */
-		smp_mb__before_atomic();
-
-		/* If the MISSED flag is set, it means other thread has
-		 * set the MISSED flag before second spin_trylock(), so
-		 * we can return false here to avoid multi cpus doing
-		 * the set_bit() and second spin_trylock() concurrently.
-		 */
-		if (test_bit(__QDISC_STATE_MISSED, &qdisc->state))
+		if (test_and_set_bit(__QDISC_STATE_MISSED, &qdisc->state))
 			return false;
 
-		/* Set the MISSED flag before the second spin_trylock(),
-		 * if the second spin_trylock() return false, it means
-		 * other cpu holding the lock will do dequeuing for us
-		 * or it will see the MISSED flag set after releasing
-		 * lock and reschedule the net_tx_action() to do the
-		 * dequeuing.
-		 */
-		set_bit(__QDISC_STATE_MISSED, &qdisc->state);
-
-		/* spin_trylock() only has load-acquire semantic, so use
-		 * smp_mb__after_atomic() to ensure STATE_MISSED is set
-		 * before doing the second spin_trylock().
-		 */
-		smp_mb__after_atomic();
-
-		/* Retry again in case other CPU may not see the new flag
-		 * after it releases the lock at the end of qdisc_run_end().
+		/* Try to take the lock again to make sure that we will either
+		 * grab it or the CPU that still has it will see MISSED set
+		 * when testing it in qdisc_run_end()
 		 */
 		return spin_trylock(&qdisc->seqlock);
 	}
@@ -229,6 +209,12 @@ static inline void qdisc_run_end(struct Qdisc *qdisc)
 	if (qdisc->flags & TCQ_F_NOLOCK) {
 		spin_unlock(&qdisc->seqlock);
 
+		/* spin_unlock() only has store-release semantic. The unlock
+		 * and test_bit() ordering is a store-load ordering, so a full
+		 * memory barrier is needed here.
+		 */
+		smp_mb();
+
 		if (unlikely(test_bit(__QDISC_STATE_MISSED,
 				      &qdisc->state)))
 			__netif_schedule(qdisc);
diff --git a/include/net/tcp.h b/include/net/tcp.h
index a3fe2f9bc01c..818ac8077381 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1215,9 +1215,20 @@ static inline unsigned int tcp_packets_in_flight(const struct tcp_sock *tp)
 
 #define TCP_INFINITE_SSTHRESH	0x7fffffff
 
+static inline u32 tcp_snd_cwnd(const struct tcp_sock *tp)
+{
+	return tp->snd_cwnd;
+}
+
+static inline void tcp_snd_cwnd_set(struct tcp_sock *tp, u32 val)
+{
+	WARN_ON_ONCE((int)val <= 0);
+	tp->snd_cwnd = val;
+}
+
 static inline bool tcp_in_slow_start(const struct tcp_sock *tp)
 {
-	return tp->snd_cwnd < tp->snd_ssthresh;
+	return tcp_snd_cwnd(tp) < tp->snd_ssthresh;
 }
 
 static inline bool tcp_in_initial_slowstart(const struct tcp_sock *tp)
@@ -1243,8 +1254,8 @@ static inline __u32 tcp_current_ssthresh(const struct sock *sk)
 		return tp->snd_ssthresh;
 	else
 		return max(tp->snd_ssthresh,
-			   ((tp->snd_cwnd >> 1) +
-			    (tp->snd_cwnd >> 2)));
+			   ((tcp_snd_cwnd(tp) >> 1) +
+			    (tcp_snd_cwnd(tp) >> 2)));
 }
 
 /* Use define here intentionally to get WARN_ON location shown at the caller */
@@ -1286,7 +1297,7 @@ static inline bool tcp_is_cwnd_limited(const struct sock *sk)
 
 	/* If in slow start, ensure cwnd grows to twice what was ACKed. */
 	if (tcp_in_slow_start(tp))
-		return tp->snd_cwnd < 2 * tp->max_packets_out;
+		return tcp_snd_cwnd(tp) < 2 * tp->max_packets_out;
 
 	return tp->is_cwnd_limited;
 }
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 443d45951564..4aa031849668 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -13,7 +13,7 @@
 
 void xsk_tx_completed(struct xsk_buff_pool *pool, u32 nb_entries);
 bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc);
-u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *desc, u32 max);
+u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max);
 void xsk_tx_release(struct xsk_buff_pool *pool);
 struct xsk_buff_pool *xsk_get_pool_from_qid(struct net_device *dev,
 					    u16 queue_id);
@@ -142,8 +142,7 @@ static inline bool xsk_tx_peek_desc(struct xsk_buff_pool *pool,
 	return false;
 }
 
-static inline u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *desc,
-						 u32 max)
+static inline u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max)
 {
 	return 0;
 }
diff --git a/include/net/xsk_buff_pool.h b/include/net/xsk_buff_pool.h
index ddeefc4a1040..647722e847b4 100644
--- a/include/net/xsk_buff_pool.h
+++ b/include/net/xsk_buff_pool.h
@@ -60,6 +60,7 @@ struct xsk_buff_pool {
 	 */
 	dma_addr_t *dma_pages;
 	struct xdp_buff_xsk *heads;
+	struct xdp_desc *tx_descs;
 	u64 chunk_mask;
 	u64 addrs_cnt;
 	u32 free_list_cnt;
@@ -96,6 +97,7 @@ int xp_assign_dev(struct xsk_buff_pool *pool, struct net_device *dev,
 		  u16 queue_id, u16 flags);
 int xp_assign_dev_shared(struct xsk_buff_pool *pool, struct xdp_umem *umem,
 			 struct net_device *dev, u16 queue_id);
+int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs);
 void xp_destroy(struct xsk_buff_pool *pool);
 void xp_get_pool(struct xsk_buff_pool *pool);
 bool xp_put_pool(struct xsk_buff_pool *pool);
diff --git a/include/trace/events/tcp.h b/include/trace/events/tcp.h
index 521059d8dc0a..edcd6369de10 100644
--- a/include/trace/events/tcp.h
+++ b/include/trace/events/tcp.h
@@ -279,7 +279,7 @@ TRACE_EVENT(tcp_probe,
 		__entry->data_len = skb->len - __tcp_hdrlen(th);
 		__entry->snd_nxt = tp->snd_nxt;
 		__entry->snd_una = tp->snd_una;
-		__entry->snd_cwnd = tp->snd_cwnd;
+		__entry->snd_cwnd = tcp_snd_cwnd(tp);
 		__entry->snd_wnd = tp->snd_wnd;
 		__entry->rcv_wnd = tp->rcv_wnd;
 		__entry->ssthresh = tcp_current_ssthresh(sk);
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 64c44eed8c07..10c4a2028e07 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -1671,6 +1671,11 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 		CONT;							\
 	LDX_MEM_##SIZEOP:						\
 		DST = *(SIZE *)(unsigned long) (SRC + insn->off);	\
+		CONT;							\
+	LDX_PROBE_MEM_##SIZEOP:						\
+		bpf_probe_read_kernel(&DST, sizeof(SIZE),		\
+				      (const void *)(long) (SRC + insn->off));	\
+		DST = *((SIZE *)&DST);					\
 		CONT;
 
 	LDST(B,   u8)
@@ -1678,15 +1683,6 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
 	LDST(W,  u32)
 	LDST(DW, u64)
 #undef LDST
-#define LDX_PROBE(SIZEOP, SIZE)							\
-	LDX_PROBE_MEM_##SIZEOP:							\
-		bpf_probe_read_kernel(&DST, SIZE, (const void *)(long) (SRC + insn->off));	\
-		CONT;
-	LDX_PROBE(B,  1)
-	LDX_PROBE(H,  2)
-	LDX_PROBE(W,  4)
-	LDX_PROBE(DW, 8)
-#undef LDX_PROBE
 
 #define ATOMIC_ALU_OP(BOP, KOP)						\
 		case BOP:						\
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 8bc7beea10c7..7ebf42607505 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2827,7 +2827,7 @@ trace_event_buffer_lock_reserve(struct trace_buffer **current_rb,
 }
 EXPORT_SYMBOL_GPL(trace_event_buffer_lock_reserve);
 
-static DEFINE_SPINLOCK(tracepoint_iter_lock);
+static DEFINE_RAW_SPINLOCK(tracepoint_iter_lock);
 static DEFINE_MUTEX(tracepoint_printk_mutex);
 
 static void output_printk(struct trace_event_buffer *fbuffer)
@@ -2855,14 +2855,14 @@ static void output_printk(struct trace_event_buffer *fbuffer)
 
 	event = &fbuffer->trace_file->event_call->event;
 
-	spin_lock_irqsave(&tracepoint_iter_lock, flags);
+	raw_spin_lock_irqsave(&tracepoint_iter_lock, flags);
 	trace_seq_init(&iter->seq);
 	iter->ent = fbuffer->entry;
 	event_call->event.funcs->trace(iter, 0, event);
 	trace_seq_putc(&iter->seq, 0);
 	printk("%s", iter->seq.buffer);
 
-	spin_unlock_irqrestore(&tracepoint_iter_lock, flags);
+	raw_spin_unlock_irqrestore(&tracepoint_iter_lock, flags);
 }
 
 int tracepoint_printk_sysctl(struct ctl_table *table, int write,
@@ -6324,12 +6324,18 @@ static void tracing_set_nop(struct trace_array *tr)
 	tr->current_trace = &nop_trace;
 }
 
+static bool tracer_options_updated;
+
 static void add_tracer_options(struct trace_array *tr, struct tracer *t)
 {
 	/* Only enable if the directory has been created already. */
 	if (!tr->dir)
 		return;
 
+	/* Only create trace option files after update_tracer_options finish */
+	if (!tracer_options_updated)
+		return;
+
 	create_trace_option_files(tr, t);
 }
 
@@ -9139,6 +9145,7 @@ static void __update_tracer_options(struct trace_array *tr)
 static void update_tracer_options(struct trace_array *tr)
 {
 	mutex_lock(&trace_types_lock);
+	tracer_options_updated = true;
 	__update_tracer_options(tr);
 	mutex_unlock(&trace_types_lock);
 }
diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
index f755bde42fd0..b69e207012c9 100644
--- a/kernel/trace/trace_syscalls.c
+++ b/kernel/trace/trace_syscalls.c
@@ -154,7 +154,7 @@ print_syscall_enter(struct trace_iterator *iter, int flags,
 			goto end;
 
 		/* parameter types */
-		if (tr->trace_flags & TRACE_ITER_VERBOSE)
+		if (tr && tr->trace_flags & TRACE_ITER_VERBOSE)
 			trace_seq_printf(s, "%s ", entry->types[i]);
 
 		/* parameter values */
@@ -296,9 +296,7 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 	struct trace_event_file *trace_file;
 	struct syscall_trace_enter *entry;
 	struct syscall_metadata *sys_data;
-	struct ring_buffer_event *event;
-	struct trace_buffer *buffer;
-	unsigned int trace_ctx;
+	struct trace_event_buffer fbuffer;
 	unsigned long args[6];
 	int syscall_nr;
 	int size;
@@ -321,20 +319,16 @@ static void ftrace_syscall_enter(void *data, struct pt_regs *regs, long id)
 
 	size = sizeof(*entry) + sizeof(unsigned long) * sys_data->nb_args;
 
-	trace_ctx = tracing_gen_ctx();
-
-	event = trace_event_buffer_lock_reserve(&buffer, trace_file,
-			sys_data->enter_event->event.type, size, trace_ctx);
-	if (!event)
+	entry = trace_event_buffer_reserve(&fbuffer, trace_file, size);
+	if (!entry)
 		return;
 
-	entry = ring_buffer_event_data(event);
+	entry = ring_buffer_event_data(fbuffer.event);
 	entry->nr = syscall_nr;
 	syscall_get_arguments(current, regs, args);
 	memcpy(entry->args, args, sizeof(unsigned long) * sys_data->nb_args);
 
-	event_trigger_unlock_commit(trace_file, buffer, event, entry,
-				    trace_ctx);
+	trace_event_buffer_commit(&fbuffer);
 }
 
 static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
@@ -343,9 +337,7 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	struct trace_event_file *trace_file;
 	struct syscall_trace_exit *entry;
 	struct syscall_metadata *sys_data;
-	struct ring_buffer_event *event;
-	struct trace_buffer *buffer;
-	unsigned int trace_ctx;
+	struct trace_event_buffer fbuffer;
 	int syscall_nr;
 
 	syscall_nr = trace_get_syscall_nr(current, regs);
@@ -364,20 +356,15 @@ static void ftrace_syscall_exit(void *data, struct pt_regs *regs, long ret)
 	if (!sys_data)
 		return;
 
-	trace_ctx = tracing_gen_ctx();
-
-	event = trace_event_buffer_lock_reserve(&buffer, trace_file,
-			sys_data->exit_event->event.type, sizeof(*entry),
-			trace_ctx);
-	if (!event)
+	entry = trace_event_buffer_reserve(&fbuffer, trace_file, sizeof(*entry));
+	if (!entry)
 		return;
 
-	entry = ring_buffer_event_data(event);
+	entry = ring_buffer_event_data(fbuffer.event);
 	entry->nr = syscall_nr;
 	entry->ret = syscall_get_return_value(current, regs);
 
-	event_trigger_unlock_commit(trace_file, buffer, event, entry,
-				    trace_ctx);
+	trace_event_buffer_commit(&fbuffer);
 }
 
 static int reg_event_syscall_enter(struct trace_event_file *file,
diff --git a/lib/Makefile b/lib/Makefile
index 300f569c626b..4c0220cb4329 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -279,7 +279,7 @@ $(foreach file, $(libfdt_files), \
 	$(eval CFLAGS_$(file) = -I $(srctree)/scripts/dtc/libfdt))
 lib-$(CONFIG_LIBFDT) += $(libfdt_files)
 
-lib-$(CONFIG_BOOT_CONFIG) += bootconfig.o
+obj-$(CONFIG_BOOT_CONFIG) += bootconfig.o
 
 obj-$(CONFIG_RBTREE_TEST) += rbtree_test.o
 obj-$(CONFIG_INTERVAL_TREE_TEST) += interval_tree_test.o
diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 6dd5330f7a99..0b64695ab632 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1434,7 +1434,7 @@ static ssize_t iter_xarray_get_pages(struct iov_iter *i,
 {
 	unsigned nr, offset;
 	pgoff_t index, count;
-	size_t size = maxsize, actual;
+	size_t size = maxsize;
 	loff_t pos;
 
 	if (!size || !maxpages)
@@ -1461,13 +1461,7 @@ static ssize_t iter_xarray_get_pages(struct iov_iter *i,
 	if (nr == 0)
 		return 0;
 
-	actual = PAGE_SIZE * nr;
-	actual -= offset;
-	if (nr == count && size > 0) {
-		unsigned last_offset = (nr > 1) ? 0 : offset;
-		actual -= PAGE_SIZE - (last_offset + size);
-	}
-	return actual;
+	return min_t(size_t, nr * PAGE_SIZE - offset, maxsize);
 }
 
 /* must be done on non-empty ITER_IOVEC one */
@@ -1602,7 +1596,7 @@ static ssize_t iter_xarray_get_pages_alloc(struct iov_iter *i,
 	struct page **p;
 	unsigned nr, offset;
 	pgoff_t index, count;
-	size_t size = maxsize, actual;
+	size_t size = maxsize;
 	loff_t pos;
 
 	if (!size)
@@ -1631,13 +1625,7 @@ static ssize_t iter_xarray_get_pages_alloc(struct iov_iter *i,
 	if (nr == 0)
 		return 0;
 
-	actual = PAGE_SIZE * nr;
-	actual -= offset;
-	if (nr == count && size > 0) {
-		unsigned last_offset = (nr > 1) ? 0 : offset;
-		actual -= PAGE_SIZE - (last_offset + size);
-	}
-	return actual;
+	return min_t(size_t, nr * PAGE_SIZE - offset, maxsize);
 }
 
 ssize_t iov_iter_get_pages_alloc(struct iov_iter *i,
diff --git a/lib/nodemask.c b/lib/nodemask.c
index 3aa454c54c0d..e22647f5181b 100644
--- a/lib/nodemask.c
+++ b/lib/nodemask.c
@@ -3,9 +3,9 @@
 #include <linux/module.h>
 #include <linux/random.h>
 
-int __next_node_in(int node, const nodemask_t *srcp)
+unsigned int __next_node_in(int node, const nodemask_t *srcp)
 {
-	int ret = __next_node(node, srcp);
+	unsigned int ret = __next_node(node, srcp);
 
 	if (ret == MAX_NUMNODES)
 		ret = __first_node(srcp);
diff --git a/lib/xarray.c b/lib/xarray.c
index 32e1669d5b64..276d56bd19a2 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -264,9 +264,10 @@ static void xa_node_free(struct xa_node *node)
  * xas_destroy() - Free any resources allocated during the XArray operation.
  * @xas: XArray operation state.
  *
- * This function is now internal-only.
+ * Most users will not need to call this function; it is called for you
+ * by xas_nomem().
  */
-static void xas_destroy(struct xa_state *xas)
+void xas_destroy(struct xa_state *xas)
 {
 	struct xa_node *next, *node = xas->xa_alloc;
 
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index fb9163691705..33be0864aeba 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2736,8 +2736,7 @@ int split_huge_page_to_list(struct page *page, struct list_head *list)
 	if (mapping)
 		i_mmap_unlock_read(mapping);
 out:
-	/* Free any memory we didn't use */
-	xas_nomem(&xas, 0);
+	xas_destroy(&xas);
 	count_vm_event(!ret ? THP_SPLIT_PAGE : THP_SPLIT_PAGE_FAILED);
 	return ret;
 }
diff --git a/net/ax25/af_ax25.c b/net/ax25/af_ax25.c
index 363d47f94532..289f355e1853 100644
--- a/net/ax25/af_ax25.c
+++ b/net/ax25/af_ax25.c
@@ -62,12 +62,12 @@ static void ax25_free_sock(struct sock *sk)
  */
 static void ax25_cb_del(ax25_cb *ax25)
 {
+	spin_lock_bh(&ax25_list_lock);
 	if (!hlist_unhashed(&ax25->ax25_node)) {
-		spin_lock_bh(&ax25_list_lock);
 		hlist_del_init(&ax25->ax25_node);
-		spin_unlock_bh(&ax25_list_lock);
 		ax25_cb_put(ax25);
 	}
+	spin_unlock_bh(&ax25_list_lock);
 }
 
 /*
@@ -81,6 +81,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 
 	if ((ax25_dev = ax25_dev_ax25dev(dev)) == NULL)
 		return;
+	ax25_dev->device_up = false;
 
 	spin_lock_bh(&ax25_list_lock);
 again:
@@ -91,6 +92,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 				spin_unlock_bh(&ax25_list_lock);
 				ax25_disconnect(s, ENETUNREACH);
 				s->ax25_dev = NULL;
+				ax25_cb_del(s);
 				spin_lock_bh(&ax25_list_lock);
 				goto again;
 			}
@@ -103,6 +105,7 @@ static void ax25_kill_by_device(struct net_device *dev)
 				dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
 				ax25_dev_put(ax25_dev);
 			}
+			ax25_cb_del(s);
 			release_sock(sk);
 			spin_lock_bh(&ax25_list_lock);
 			sock_put(sk);
@@ -995,9 +998,11 @@ static int ax25_release(struct socket *sock)
 	if (sk->sk_type == SOCK_SEQPACKET) {
 		switch (ax25->state) {
 		case AX25_STATE_0:
-			release_sock(sk);
-			ax25_disconnect(ax25, 0);
-			lock_sock(sk);
+			if (!sock_flag(ax25->sk, SOCK_DEAD)) {
+				release_sock(sk);
+				ax25_disconnect(ax25, 0);
+				lock_sock(sk);
+			}
 			ax25_destroy_socket(ax25);
 			break;
 
@@ -1053,11 +1058,13 @@ static int ax25_release(struct socket *sock)
 		ax25_destroy_socket(ax25);
 	}
 	if (ax25_dev) {
-		del_timer_sync(&ax25->timer);
-		del_timer_sync(&ax25->t1timer);
-		del_timer_sync(&ax25->t2timer);
-		del_timer_sync(&ax25->t3timer);
-		del_timer_sync(&ax25->idletimer);
+		if (!ax25_dev->device_up) {
+			del_timer_sync(&ax25->timer);
+			del_timer_sync(&ax25->t1timer);
+			del_timer_sync(&ax25->t2timer);
+			del_timer_sync(&ax25->t3timer);
+			del_timer_sync(&ax25->idletimer);
+		}
 		dev_put_track(ax25_dev->dev, &ax25_dev->dev_tracker);
 		ax25_dev_put(ax25_dev);
 	}
diff --git a/net/ax25/ax25_dev.c b/net/ax25/ax25_dev.c
index d2a244e1c260..5451be15e072 100644
--- a/net/ax25/ax25_dev.c
+++ b/net/ax25/ax25_dev.c
@@ -62,6 +62,7 @@ void ax25_dev_device_up(struct net_device *dev)
 	ax25_dev->dev     = dev;
 	dev_hold_track(dev, &ax25_dev->dev_tracker, GFP_ATOMIC);
 	ax25_dev->forward = NULL;
+	ax25_dev->device_up = true;
 
 	ax25_dev->values[AX25_VALUES_IPDEFMODE] = AX25_DEF_IPDEFMODE;
 	ax25_dev->values[AX25_VALUES_AXDEFMODE] = AX25_DEF_AXDEFMODE;
diff --git a/net/ax25/ax25_subr.c b/net/ax25/ax25_subr.c
index 3a476e4f6cd0..9ff98f46dc6b 100644
--- a/net/ax25/ax25_subr.c
+++ b/net/ax25/ax25_subr.c
@@ -268,7 +268,7 @@ void ax25_disconnect(ax25_cb *ax25, int reason)
 		del_timer_sync(&ax25->t3timer);
 		del_timer_sync(&ax25->idletimer);
 	} else {
-		if (!ax25->sk || !sock_flag(ax25->sk, SOCK_DESTROY))
+		if (ax25->sk && !sock_flag(ax25->sk, SOCK_DESTROY))
 			ax25_stop_heartbeat(ax25);
 		ax25_stop_t1timer(ax25);
 		ax25_stop_t2timer(ax25);
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 9e9713f7ddb8..f1feb9204063 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2153,7 +2153,7 @@ int hci_bdaddr_list_add_with_flags(struct list_head *list, bdaddr_t *bdaddr,
 
 	bacpy(&entry->bdaddr, bdaddr);
 	entry->bdaddr_type = type;
-	bitmap_from_u64(entry->flags, flags);
+	entry->flags = flags;
 
 	list_add(&entry->list, list);
 
@@ -2633,7 +2633,7 @@ int hci_register_dev(struct hci_dev *hdev)
 	 * callback.
 	 */
 	if (hdev->wakeup)
-		set_bit(HCI_CONN_FLAG_REMOTE_WAKEUP, hdev->conn_flags);
+		hdev->conn_flags |= HCI_CONN_FLAG_REMOTE_WAKEUP;
 
 	hci_sock_dev_event(hdev, HCI_DEV_REG);
 	hci_dev_hold(hdev);
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index f4afe482e300..95689982eedb 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -482,7 +482,7 @@ static int add_to_accept_list(struct hci_request *req,
 
 	/* During suspend, only wakeable devices can be in accept list */
 	if (hdev->suspended &&
-	    !test_bit(HCI_CONN_FLAG_REMOTE_WAKEUP, params->flags))
+	    !(params->flags & HCI_CONN_FLAG_REMOTE_WAKEUP))
 		return 0;
 
 	*num_entries += 1;
diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
index 13600bf120b0..351c2390164d 100644
--- a/net/bluetooth/hci_sync.c
+++ b/net/bluetooth/hci_sync.c
@@ -1637,7 +1637,7 @@ static int hci_le_set_privacy_mode_sync(struct hci_dev *hdev,
 	 * indicates that LL Privacy has been enabled and
 	 * HCI_OP_LE_SET_PRIVACY_MODE is supported.
 	 */
-	if (!test_bit(HCI_CONN_FLAG_DEVICE_PRIVACY, params->flags))
+	if (!(params->flags & HCI_CONN_FLAG_DEVICE_PRIVACY))
 		return 0;
 
 	irk = hci_find_irk_by_addr(hdev, &params->addr, params->addr_type);
@@ -1664,20 +1664,19 @@ static int hci_le_add_accept_list_sync(struct hci_dev *hdev,
 	struct hci_cp_le_add_to_accept_list cp;
 	int err;
 
+	/* During suspend, only wakeable devices can be in acceptlist */
+	if (hdev->suspended &&
+	    !(params->flags & HCI_CONN_FLAG_REMOTE_WAKEUP))
+		return 0;
+
 	/* Select filter policy to accept all advertising */
 	if (*num_entries >= hdev->le_accept_list_size)
 		return -ENOSPC;
 
 	/* Accept list can not be used with RPAs */
 	if (!use_ll_privacy(hdev) &&
-	    hci_find_irk_by_addr(hdev, &params->addr, params->addr_type)) {
+	    hci_find_irk_by_addr(hdev, &params->addr, params->addr_type))
 		return -EINVAL;
-	}
-
-	/* During suspend, only wakeable devices can be in acceptlist */
-	if (hdev->suspended &&
-	    !test_bit(HCI_CONN_FLAG_REMOTE_WAKEUP, params->flags))
-		return 0;
 
 	/* Attempt to program the device in the resolving list first to avoid
 	 * having to rollback in case it fails since the resolving list is
@@ -4857,7 +4856,7 @@ static int hci_update_event_filter_sync(struct hci_dev *hdev)
 	hci_clear_event_filter_sync(hdev);
 
 	list_for_each_entry(b, &hdev->accept_list, list) {
-		if (!test_bit(HCI_CONN_FLAG_REMOTE_WAKEUP, b->flags))
+		if (!(b->flags & HCI_CONN_FLAG_REMOTE_WAKEUP))
 			continue;
 
 		bt_dev_dbg(hdev, "Adding event filters for %pMR", &b->bdaddr);
@@ -4881,10 +4880,28 @@ static int hci_update_event_filter_sync(struct hci_dev *hdev)
 	return 0;
 }
 
+/* This function disables scan (BR and LE) and mark it as paused */
+static int hci_pause_scan_sync(struct hci_dev *hdev)
+{
+	if (hdev->scanning_paused)
+		return 0;
+
+	/* Disable page scan if enabled */
+	if (test_bit(HCI_PSCAN, &hdev->flags))
+		hci_write_scan_enable_sync(hdev, SCAN_DISABLED);
+
+	hci_scan_disable_sync(hdev);
+
+	hdev->scanning_paused = true;
+
+	return 0;
+}
+
 /* This function performs the HCI suspend procedures in the follow order:
  *
  * Pause discovery (active scanning/inquiry)
  * Pause Directed Advertising/Advertising
+ * Pause Scanning (passive scanning in case discovery was not active)
  * Disconnect all connections
  * Set suspend_status to BT_SUSPEND_DISCONNECT if hdev cannot wakeup
  * otherwise:
@@ -4910,15 +4927,11 @@ int hci_suspend_sync(struct hci_dev *hdev)
 	/* Pause other advertisements */
 	hci_pause_advertising_sync(hdev);
 
-	/* Disable page scan if enabled */
-	if (test_bit(HCI_PSCAN, &hdev->flags))
-		hci_write_scan_enable_sync(hdev, SCAN_DISABLED);
-
 	/* Suspend monitor filters */
 	hci_suspend_monitor_sync(hdev);
 
 	/* Prevent disconnects from causing scanning to be re-enabled */
-	hdev->scanning_paused = true;
+	hci_pause_scan_sync(hdev);
 
 	/* Soft disconnect everything (power off) */
 	err = hci_disconnect_all_sync(hdev, HCI_ERROR_REMOTE_POWER_OFF);
@@ -4989,6 +5002,22 @@ static void hci_resume_monitor_sync(struct hci_dev *hdev)
 	}
 }
 
+/* This function resume scan and reset paused flag */
+static int hci_resume_scan_sync(struct hci_dev *hdev)
+{
+	if (!hdev->scanning_paused)
+		return 0;
+
+	hci_update_scan_sync(hdev);
+
+	/* Reset passive scanning to normal */
+	hci_update_passive_scan_sync(hdev);
+
+	hdev->scanning_paused = false;
+
+	return 0;
+}
+
 /* This function performs the HCI suspend procedures in the follow order:
  *
  * Restore event mask
@@ -5011,10 +5040,9 @@ int hci_resume_sync(struct hci_dev *hdev)
 
 	/* Clear any event filters and restore scan state */
 	hci_clear_event_filter_sync(hdev);
-	hci_update_scan_sync(hdev);
 
-	/* Reset passive scanning to normal */
-	hci_update_passive_scan_sync(hdev);
+	/* Resume scanning */
+	hci_resume_scan_sync(hdev);
 
 	/* Resume monitor filters */
 	hci_resume_monitor_sync(hdev);
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 15eab8b968ce..943cdc9ec763 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4009,10 +4009,11 @@ static int exp_ll_privacy_feature_changed(bool enabled, struct hci_dev *hdev,
 	memcpy(ev.uuid, rpa_resolution_uuid, 16);
 	ev.flags = cpu_to_le32((enabled ? BIT(0) : 0) | BIT(1));
 
+	// Do we need to be atomic with the conn_flags?
 	if (enabled && privacy_mode_capable(hdev))
-		set_bit(HCI_CONN_FLAG_DEVICE_PRIVACY, hdev->conn_flags);
+		hdev->conn_flags |= HCI_CONN_FLAG_DEVICE_PRIVACY;
 	else
-		clear_bit(HCI_CONN_FLAG_DEVICE_PRIVACY, hdev->conn_flags);
+		hdev->conn_flags &= ~HCI_CONN_FLAG_DEVICE_PRIVACY;
 
 	return mgmt_limited_event(MGMT_EV_EXP_FEATURE_CHANGED, hdev,
 				  &ev, sizeof(ev),
@@ -4431,8 +4432,7 @@ static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 
 	hci_dev_lock(hdev);
 
-	bitmap_to_arr32(&supported_flags, hdev->conn_flags,
-			__HCI_CONN_NUM_FLAGS);
+	supported_flags = hdev->conn_flags;
 
 	memset(&rp, 0, sizeof(rp));
 
@@ -4443,8 +4443,7 @@ static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 		if (!br_params)
 			goto done;
 
-		bitmap_to_arr32(&current_flags, br_params->flags,
-				__HCI_CONN_NUM_FLAGS);
+		current_flags = br_params->flags;
 	} else {
 		params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
 						le_addr_type(cp->addr.type));
@@ -4452,8 +4451,7 @@ static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 		if (!params)
 			goto done;
 
-		bitmap_to_arr32(&current_flags, params->flags,
-				__HCI_CONN_NUM_FLAGS);
+		current_flags = params->flags;
 	}
 
 	bacpy(&rp.addr.bdaddr, &cp->addr.bdaddr);
@@ -4498,8 +4496,8 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 		   &cp->addr.bdaddr, cp->addr.type,
 		   __le32_to_cpu(current_flags));
 
-	bitmap_to_arr32(&supported_flags, hdev->conn_flags,
-			__HCI_CONN_NUM_FLAGS);
+	// We should take hci_dev_lock() early, I think.. conn_flags can change
+	supported_flags = hdev->conn_flags;
 
 	if ((supported_flags | current_flags) != supported_flags) {
 		bt_dev_warn(hdev, "Bad flag given (0x%x) vs supported (0x%0x)",
@@ -4515,7 +4513,7 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 							      cp->addr.type);
 
 		if (br_params) {
-			bitmap_from_u64(br_params->flags, current_flags);
+			br_params->flags = current_flags;
 			status = MGMT_STATUS_SUCCESS;
 		} else {
 			bt_dev_warn(hdev, "No such BR/EDR device %pMR (0x%x)",
@@ -4525,14 +4523,26 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 		params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
 						le_addr_type(cp->addr.type));
 		if (params) {
-			bitmap_from_u64(params->flags, current_flags);
+			/* Devices using RPAs can only be programmed in the
+			 * acceptlist LL Privacy has been enable otherwise they
+			 * cannot mark HCI_CONN_FLAG_REMOTE_WAKEUP.
+			 */
+			if ((current_flags & HCI_CONN_FLAG_REMOTE_WAKEUP) &&
+			    !use_ll_privacy(hdev) &&
+			    hci_find_irk_by_addr(hdev, &params->addr,
+						 params->addr_type)) {
+				bt_dev_warn(hdev,
+					    "Cannot set wakeable for RPA");
+				goto unlock;
+			}
+
+			params->flags = current_flags;
 			status = MGMT_STATUS_SUCCESS;
 
 			/* Update passive scan if HCI_CONN_FLAG_DEVICE_PRIVACY
 			 * has been set.
 			 */
-			if (test_bit(HCI_CONN_FLAG_DEVICE_PRIVACY,
-				     params->flags))
+			if (params->flags & HCI_CONN_FLAG_DEVICE_PRIVACY)
 				hci_update_passive_scan(hdev);
 		} else {
 			bt_dev_warn(hdev, "No such LE device %pMR (0x%x)",
@@ -4541,6 +4551,7 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 		}
 	}
 
+unlock:
 	hci_dev_unlock(hdev);
 
 done:
@@ -7132,8 +7143,7 @@ static int add_device(struct sock *sk, struct hci_dev *hdev,
 		params = hci_conn_params_lookup(hdev, &cp->addr.bdaddr,
 						addr_type);
 		if (params)
-			bitmap_to_arr32(&current_flags, params->flags,
-					__HCI_CONN_NUM_FLAGS);
+			current_flags = params->flags;
 	}
 
 	err = hci_cmd_sync_queue(hdev, add_device_sync, NULL, NULL);
@@ -7142,8 +7152,7 @@ static int add_device(struct sock *sk, struct hci_dev *hdev,
 
 added:
 	device_added(sk, hdev, &cp->addr.bdaddr, cp->addr.type, cp->action);
-	bitmap_to_arr32(&supported_flags, hdev->conn_flags,
-			__HCI_CONN_NUM_FLAGS);
+	supported_flags = hdev->conn_flags;
 	device_flags_changed(NULL, hdev, &cp->addr.bdaddr, cp->addr.type,
 			     supported_flags, current_flags);
 
diff --git a/net/core/filter.c b/net/core/filter.c
index f8fbb5fa74f3..4210b127c5f5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4937,7 +4937,7 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 				if (val <= 0 || tp->data_segs_out > tp->syn_data)
 					ret = -EINVAL;
 				else
-					tp->snd_cwnd = val;
+					tcp_snd_cwnd_set(tp, val);
 				break;
 			case TCP_BPF_SNDCWND_CLAMP:
 				if (val <= 0) {
diff --git a/net/core/flow_offload.c b/net/core/flow_offload.c
index 73f68d4625f3..929f6379a279 100644
--- a/net/core/flow_offload.c
+++ b/net/core/flow_offload.c
@@ -595,3 +595,9 @@ int flow_indr_dev_setup_offload(struct net_device *dev,	struct Qdisc *sch,
 	return (bo && list_empty(&bo->cb_list)) ? -EOPNOTSUPP : count;
 }
 EXPORT_SYMBOL(flow_indr_dev_setup_offload);
+
+bool flow_indr_dev_exists(void)
+{
+	return !list_empty(&flow_block_indr_dev_list);
+}
+EXPORT_SYMBOL(flow_indr_dev_exists);
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index ec0bf737b076..a252f4090d75 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1579,7 +1579,7 @@ static void neigh_managed_work(struct work_struct *work)
 	list_for_each_entry(neigh, &tbl->managed_list, managed_list)
 		neigh_event_send_probe(neigh, NULL, false);
 	queue_delayed_work(system_power_efficient_wq, &tbl->managed_work,
-			   NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME));
+			   max(NEIGH_VAR(&tbl->parms, DELAY_PROBE_TIME), HZ));
 	write_unlock_bh(&tbl->lock);
 }
 
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index a5d57fa679ca..55654e335d43 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -917,10 +917,12 @@ void __init inet_hashinfo2_init(struct inet_hashinfo *h, const char *name,
 	init_hashinfo_lhash2(h);
 
 	/* this one is used for source ports of outgoing connections */
-	table_perturb = kmalloc_array(INET_TABLE_PERTURB_SIZE,
-				      sizeof(*table_perturb), GFP_KERNEL);
-	if (!table_perturb)
-		panic("TCP: failed to alloc table_perturb");
+	table_perturb = alloc_large_system_hash("Table-perturb",
+						sizeof(*table_perturb),
+						INET_TABLE_PERTURB_SIZE,
+						0, 0, NULL, NULL,
+						INET_TABLE_PERTURB_SIZE,
+						INET_TABLE_PERTURB_SIZE);
 }
 
 int inet_hashinfo2_init_mod(struct inet_hashinfo *h)
diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 8cf86e42c1d1..65b6d4c1698e 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -629,21 +629,20 @@ static netdev_tx_t ipgre_xmit(struct sk_buff *skb,
 	}
 
 	if (dev->header_ops) {
-		const int pull_len = tunnel->hlen + sizeof(struct iphdr);
-
 		if (skb_cow_head(skb, 0))
 			goto free_skb;
 
 		tnl_params = (const struct iphdr *)skb->data;
 
-		if (pull_len > skb_transport_offset(skb))
-			goto free_skb;
-
 		/* Pull skb since ip_tunnel_xmit() needs skb->data pointing
 		 * to gre header.
 		 */
-		skb_pull(skb, pull_len);
+		skb_pull(skb, tunnel->hlen + sizeof(struct iphdr));
 		skb_reset_mac_header(skb);
+
+		if (skb->ip_summed == CHECKSUM_PARTIAL &&
+		    skb_checksum_start(skb) < skb->data)
+			goto free_skb;
 	} else {
 		if (skb_cow_head(skb, dev->needed_headroom))
 			goto free_skb;
diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
index 28ff2a820f7c..c9ad372f8edb 100644
--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -429,7 +429,7 @@ void tcp_init_sock(struct sock *sk)
 	 * algorithms that we must have the following bandaid to talk
 	 * efficiently to them.  -DaveM
 	 */
-	tp->snd_cwnd = TCP_INIT_CWND;
+	tcp_snd_cwnd_set(tp, TCP_INIT_CWND);
 
 	/* There's a bubble in the pipe until at least the first ACK. */
 	tp->app_limited = ~0U;
@@ -3033,7 +3033,7 @@ int tcp_disconnect(struct sock *sk, int flags)
 	icsk->icsk_rto_min = TCP_RTO_MIN;
 	icsk->icsk_delack_max = TCP_DELACK_MAX;
 	tp->snd_ssthresh = TCP_INFINITE_SSTHRESH;
-	tp->snd_cwnd = TCP_INIT_CWND;
+	tcp_snd_cwnd_set(tp, TCP_INIT_CWND);
 	tp->snd_cwnd_cnt = 0;
 	tp->window_clamp = 0;
 	tp->delivered = 0;
@@ -3744,7 +3744,7 @@ void tcp_get_info(struct sock *sk, struct tcp_info *info)
 	info->tcpi_max_pacing_rate = rate64;
 
 	info->tcpi_reordering = tp->reordering;
-	info->tcpi_snd_cwnd = tp->snd_cwnd;
+	info->tcpi_snd_cwnd = tcp_snd_cwnd(tp);
 
 	if (info->tcpi_state == TCP_LISTEN) {
 		/* listeners aliased fields :
@@ -3915,7 +3915,7 @@ struct sk_buff *tcp_get_timestamping_opt_stats(const struct sock *sk,
 	rate64 = tcp_compute_delivery_rate(tp);
 	nla_put_u64_64bit(stats, TCP_NLA_DELIVERY_RATE, rate64, TCP_NLA_PAD);
 
-	nla_put_u32(stats, TCP_NLA_SND_CWND, tp->snd_cwnd);
+	nla_put_u32(stats, TCP_NLA_SND_CWND, tcp_snd_cwnd(tp));
 	nla_put_u32(stats, TCP_NLA_REORDERING, tp->reordering);
 	nla_put_u32(stats, TCP_NLA_MIN_RTT, tcp_min_rtt(tp));
 
diff --git a/net/ipv4/tcp_bbr.c b/net/ipv4/tcp_bbr.c
index ec5550089b4d..aefe12b7dbf7 100644
--- a/net/ipv4/tcp_bbr.c
+++ b/net/ipv4/tcp_bbr.c
@@ -276,7 +276,7 @@ static void bbr_init_pacing_rate_from_rtt(struct sock *sk)
 	} else {			 /* no RTT sample yet */
 		rtt_us = USEC_PER_MSEC;	 /* use nominal default RTT */
 	}
-	bw = (u64)tp->snd_cwnd * BW_UNIT;
+	bw = (u64)tcp_snd_cwnd(tp) * BW_UNIT;
 	do_div(bw, rtt_us);
 	sk->sk_pacing_rate = bbr_bw_to_pacing_rate(sk, bw, bbr_high_gain);
 }
@@ -323,9 +323,9 @@ static void bbr_save_cwnd(struct sock *sk)
 	struct bbr *bbr = inet_csk_ca(sk);
 
 	if (bbr->prev_ca_state < TCP_CA_Recovery && bbr->mode != BBR_PROBE_RTT)
-		bbr->prior_cwnd = tp->snd_cwnd;  /* this cwnd is good enough */
+		bbr->prior_cwnd = tcp_snd_cwnd(tp);  /* this cwnd is good enough */
 	else  /* loss recovery or BBR_PROBE_RTT have temporarily cut cwnd */
-		bbr->prior_cwnd = max(bbr->prior_cwnd, tp->snd_cwnd);
+		bbr->prior_cwnd = max(bbr->prior_cwnd, tcp_snd_cwnd(tp));
 }
 
 static void bbr_cwnd_event(struct sock *sk, enum tcp_ca_event event)
@@ -482,7 +482,7 @@ static bool bbr_set_cwnd_to_recover_or_restore(
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct bbr *bbr = inet_csk_ca(sk);
 	u8 prev_state = bbr->prev_ca_state, state = inet_csk(sk)->icsk_ca_state;
-	u32 cwnd = tp->snd_cwnd;
+	u32 cwnd = tcp_snd_cwnd(tp);
 
 	/* An ACK for P pkts should release at most 2*P packets. We do this
 	 * in two steps. First, here we deduct the number of lost packets.
@@ -520,7 +520,7 @@ static void bbr_set_cwnd(struct sock *sk, const struct rate_sample *rs,
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct bbr *bbr = inet_csk_ca(sk);
-	u32 cwnd = tp->snd_cwnd, target_cwnd = 0;
+	u32 cwnd = tcp_snd_cwnd(tp), target_cwnd = 0;
 
 	if (!acked)
 		goto done;  /* no packet fully ACKed; just apply caps */
@@ -544,9 +544,9 @@ static void bbr_set_cwnd(struct sock *sk, const struct rate_sample *rs,
 	cwnd = max(cwnd, bbr_cwnd_min_target);
 
 done:
-	tp->snd_cwnd = min(cwnd, tp->snd_cwnd_clamp);	/* apply global cap */
+	tcp_snd_cwnd_set(tp, min(cwnd, tp->snd_cwnd_clamp));	/* apply global cap */
 	if (bbr->mode == BBR_PROBE_RTT)  /* drain queue, refresh min_rtt */
-		tp->snd_cwnd = min(tp->snd_cwnd, bbr_cwnd_min_target);
+		tcp_snd_cwnd_set(tp, min(tcp_snd_cwnd(tp), bbr_cwnd_min_target));
 }
 
 /* End cycle phase if it's time and/or we hit the phase's in-flight target. */
@@ -856,7 +856,7 @@ static void bbr_update_ack_aggregation(struct sock *sk,
 	bbr->ack_epoch_acked = min_t(u32, 0xFFFFF,
 				     bbr->ack_epoch_acked + rs->acked_sacked);
 	extra_acked = bbr->ack_epoch_acked - expected_acked;
-	extra_acked = min(extra_acked, tp->snd_cwnd);
+	extra_acked = min(extra_acked, tcp_snd_cwnd(tp));
 	if (extra_acked > bbr->extra_acked[bbr->extra_acked_win_idx])
 		bbr->extra_acked[bbr->extra_acked_win_idx] = extra_acked;
 }
@@ -914,7 +914,7 @@ static void bbr_check_probe_rtt_done(struct sock *sk)
 		return;
 
 	bbr->min_rtt_stamp = tcp_jiffies32;  /* wait a while until PROBE_RTT */
-	tp->snd_cwnd = max(tp->snd_cwnd, bbr->prior_cwnd);
+	tcp_snd_cwnd_set(tp, max(tcp_snd_cwnd(tp), bbr->prior_cwnd));
 	bbr_reset_mode(sk);
 }
 
@@ -1093,7 +1093,7 @@ static u32 bbr_undo_cwnd(struct sock *sk)
 	bbr->full_bw = 0;   /* spurious slow-down; reset full pipe detection */
 	bbr->full_bw_cnt = 0;
 	bbr_reset_lt_bw_sampling(sk);
-	return tcp_sk(sk)->snd_cwnd;
+	return tcp_snd_cwnd(tcp_sk(sk));
 }
 
 /* Entering loss recovery, so save cwnd for when we exit or undo recovery. */
diff --git a/net/ipv4/tcp_bic.c b/net/ipv4/tcp_bic.c
index f5f588b1f6e9..58358bf92e1b 100644
--- a/net/ipv4/tcp_bic.c
+++ b/net/ipv4/tcp_bic.c
@@ -150,7 +150,7 @@ static void bictcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		if (!acked)
 			return;
 	}
-	bictcp_update(ca, tp->snd_cwnd);
+	bictcp_update(ca, tcp_snd_cwnd(tp));
 	tcp_cong_avoid_ai(tp, ca->cnt, acked);
 }
 
@@ -166,16 +166,16 @@ static u32 bictcp_recalc_ssthresh(struct sock *sk)
 	ca->epoch_start = 0;	/* end of epoch */
 
 	/* Wmax and fast convergence */
-	if (tp->snd_cwnd < ca->last_max_cwnd && fast_convergence)
-		ca->last_max_cwnd = (tp->snd_cwnd * (BICTCP_BETA_SCALE + beta))
+	if (tcp_snd_cwnd(tp) < ca->last_max_cwnd && fast_convergence)
+		ca->last_max_cwnd = (tcp_snd_cwnd(tp) * (BICTCP_BETA_SCALE + beta))
 			/ (2 * BICTCP_BETA_SCALE);
 	else
-		ca->last_max_cwnd = tp->snd_cwnd;
+		ca->last_max_cwnd = tcp_snd_cwnd(tp);
 
-	if (tp->snd_cwnd <= low_window)
-		return max(tp->snd_cwnd >> 1U, 2U);
+	if (tcp_snd_cwnd(tp) <= low_window)
+		return max(tcp_snd_cwnd(tp) >> 1U, 2U);
 	else
-		return max((tp->snd_cwnd * beta) / BICTCP_BETA_SCALE, 2U);
+		return max((tcp_snd_cwnd(tp) * beta) / BICTCP_BETA_SCALE, 2U);
 }
 
 static void bictcp_state(struct sock *sk, u8 new_state)
diff --git a/net/ipv4/tcp_cdg.c b/net/ipv4/tcp_cdg.c
index 709d23801823..ddc7ba0554bd 100644
--- a/net/ipv4/tcp_cdg.c
+++ b/net/ipv4/tcp_cdg.c
@@ -161,8 +161,8 @@ static void tcp_cdg_hystart_update(struct sock *sk)
 					      LINUX_MIB_TCPHYSTARTTRAINDETECT);
 				NET_ADD_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTTRAINCWND,
-					      tp->snd_cwnd);
-				tp->snd_ssthresh = tp->snd_cwnd;
+					      tcp_snd_cwnd(tp));
+				tp->snd_ssthresh = tcp_snd_cwnd(tp);
 				return;
 			}
 		}
@@ -180,8 +180,8 @@ static void tcp_cdg_hystart_update(struct sock *sk)
 					      LINUX_MIB_TCPHYSTARTDELAYDETECT);
 				NET_ADD_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTDELAYCWND,
-					      tp->snd_cwnd);
-				tp->snd_ssthresh = tp->snd_cwnd;
+					      tcp_snd_cwnd(tp));
+				tp->snd_ssthresh = tcp_snd_cwnd(tp);
 			}
 		}
 	}
@@ -252,7 +252,7 @@ static bool tcp_cdg_backoff(struct sock *sk, u32 grad)
 			return false;
 	}
 
-	ca->shadow_wnd = max(ca->shadow_wnd, tp->snd_cwnd);
+	ca->shadow_wnd = max(ca->shadow_wnd, tcp_snd_cwnd(tp));
 	ca->state = CDG_BACKOFF;
 	tcp_enter_cwr(sk);
 	return true;
@@ -285,14 +285,14 @@ static void tcp_cdg_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 	}
 
 	if (!tcp_is_cwnd_limited(sk)) {
-		ca->shadow_wnd = min(ca->shadow_wnd, tp->snd_cwnd);
+		ca->shadow_wnd = min(ca->shadow_wnd, tcp_snd_cwnd(tp));
 		return;
 	}
 
-	prior_snd_cwnd = tp->snd_cwnd;
+	prior_snd_cwnd = tcp_snd_cwnd(tp);
 	tcp_reno_cong_avoid(sk, ack, acked);
 
-	incr = tp->snd_cwnd - prior_snd_cwnd;
+	incr = tcp_snd_cwnd(tp) - prior_snd_cwnd;
 	ca->shadow_wnd = max(ca->shadow_wnd, ca->shadow_wnd + incr);
 }
 
@@ -331,15 +331,15 @@ static u32 tcp_cdg_ssthresh(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 
 	if (ca->state == CDG_BACKOFF)
-		return max(2U, (tp->snd_cwnd * min(1024U, backoff_beta)) >> 10);
+		return max(2U, (tcp_snd_cwnd(tp) * min(1024U, backoff_beta)) >> 10);
 
 	if (ca->state == CDG_NONFULL && use_tolerance)
-		return tp->snd_cwnd;
+		return tcp_snd_cwnd(tp);
 
-	ca->shadow_wnd = min(ca->shadow_wnd >> 1, tp->snd_cwnd);
+	ca->shadow_wnd = min(ca->shadow_wnd >> 1, tcp_snd_cwnd(tp));
 	if (use_shadow)
-		return max3(2U, ca->shadow_wnd, tp->snd_cwnd >> 1);
-	return max(2U, tp->snd_cwnd >> 1);
+		return max3(2U, ca->shadow_wnd, tcp_snd_cwnd(tp) >> 1);
+	return max(2U, tcp_snd_cwnd(tp) >> 1);
 }
 
 static void tcp_cdg_cwnd_event(struct sock *sk, const enum tcp_ca_event ev)
@@ -357,7 +357,7 @@ static void tcp_cdg_cwnd_event(struct sock *sk, const enum tcp_ca_event ev)
 
 		ca->gradients = gradients;
 		ca->rtt_seq = tp->snd_nxt;
-		ca->shadow_wnd = tp->snd_cwnd;
+		ca->shadow_wnd = tcp_snd_cwnd(tp);
 		break;
 	case CA_EVENT_COMPLETE_CWR:
 		ca->state = CDG_UNKNOWN;
@@ -380,7 +380,7 @@ static void tcp_cdg_init(struct sock *sk)
 		ca->gradients = kcalloc(window, sizeof(ca->gradients[0]),
 					GFP_NOWAIT | __GFP_NOWARN);
 	ca->rtt_seq = tp->snd_nxt;
-	ca->shadow_wnd = tp->snd_cwnd;
+	ca->shadow_wnd = tcp_snd_cwnd(tp);
 }
 
 static void tcp_cdg_release(struct sock *sk)
diff --git a/net/ipv4/tcp_cong.c b/net/ipv4/tcp_cong.c
index db5831e6c136..f43db30a7195 100644
--- a/net/ipv4/tcp_cong.c
+++ b/net/ipv4/tcp_cong.c
@@ -395,10 +395,10 @@ int tcp_set_congestion_control(struct sock *sk, const char *name, bool load,
  */
 u32 tcp_slow_start(struct tcp_sock *tp, u32 acked)
 {
-	u32 cwnd = min(tp->snd_cwnd + acked, tp->snd_ssthresh);
+	u32 cwnd = min(tcp_snd_cwnd(tp) + acked, tp->snd_ssthresh);
 
-	acked -= cwnd - tp->snd_cwnd;
-	tp->snd_cwnd = min(cwnd, tp->snd_cwnd_clamp);
+	acked -= cwnd - tcp_snd_cwnd(tp);
+	tcp_snd_cwnd_set(tp, min(cwnd, tp->snd_cwnd_clamp));
 
 	return acked;
 }
@@ -412,7 +412,7 @@ void tcp_cong_avoid_ai(struct tcp_sock *tp, u32 w, u32 acked)
 	/* If credits accumulated at a higher w, apply them gently now. */
 	if (tp->snd_cwnd_cnt >= w) {
 		tp->snd_cwnd_cnt = 0;
-		tp->snd_cwnd++;
+		tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 	}
 
 	tp->snd_cwnd_cnt += acked;
@@ -420,9 +420,9 @@ void tcp_cong_avoid_ai(struct tcp_sock *tp, u32 w, u32 acked)
 		u32 delta = tp->snd_cwnd_cnt / w;
 
 		tp->snd_cwnd_cnt -= delta * w;
-		tp->snd_cwnd += delta;
+		tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + delta);
 	}
-	tp->snd_cwnd = min(tp->snd_cwnd, tp->snd_cwnd_clamp);
+	tcp_snd_cwnd_set(tp, min(tcp_snd_cwnd(tp), tp->snd_cwnd_clamp));
 }
 EXPORT_SYMBOL_GPL(tcp_cong_avoid_ai);
 
@@ -447,7 +447,7 @@ void tcp_reno_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 			return;
 	}
 	/* In dangerous area, increase slowly. */
-	tcp_cong_avoid_ai(tp, tp->snd_cwnd, acked);
+	tcp_cong_avoid_ai(tp, tcp_snd_cwnd(tp), acked);
 }
 EXPORT_SYMBOL_GPL(tcp_reno_cong_avoid);
 
@@ -456,7 +456,7 @@ u32 tcp_reno_ssthresh(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
-	return max(tp->snd_cwnd >> 1U, 2U);
+	return max(tcp_snd_cwnd(tp) >> 1U, 2U);
 }
 EXPORT_SYMBOL_GPL(tcp_reno_ssthresh);
 
@@ -464,7 +464,7 @@ u32 tcp_reno_undo_cwnd(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
-	return max(tp->snd_cwnd, tp->prior_cwnd);
+	return max(tcp_snd_cwnd(tp), tp->prior_cwnd);
 }
 EXPORT_SYMBOL_GPL(tcp_reno_undo_cwnd);
 
diff --git a/net/ipv4/tcp_cubic.c b/net/ipv4/tcp_cubic.c
index e07837e23b3f..f0a240792ff9 100644
--- a/net/ipv4/tcp_cubic.c
+++ b/net/ipv4/tcp_cubic.c
@@ -334,7 +334,7 @@ static void cubictcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		if (!acked)
 			return;
 	}
-	bictcp_update(ca, tp->snd_cwnd, acked);
+	bictcp_update(ca, tcp_snd_cwnd(tp), acked);
 	tcp_cong_avoid_ai(tp, ca->cnt, acked);
 }
 
@@ -346,13 +346,13 @@ static u32 cubictcp_recalc_ssthresh(struct sock *sk)
 	ca->epoch_start = 0;	/* end of epoch */
 
 	/* Wmax and fast convergence */
-	if (tp->snd_cwnd < ca->last_max_cwnd && fast_convergence)
-		ca->last_max_cwnd = (tp->snd_cwnd * (BICTCP_BETA_SCALE + beta))
+	if (tcp_snd_cwnd(tp) < ca->last_max_cwnd && fast_convergence)
+		ca->last_max_cwnd = (tcp_snd_cwnd(tp) * (BICTCP_BETA_SCALE + beta))
 			/ (2 * BICTCP_BETA_SCALE);
 	else
-		ca->last_max_cwnd = tp->snd_cwnd;
+		ca->last_max_cwnd = tcp_snd_cwnd(tp);
 
-	return max((tp->snd_cwnd * beta) / BICTCP_BETA_SCALE, 2U);
+	return max((tcp_snd_cwnd(tp) * beta) / BICTCP_BETA_SCALE, 2U);
 }
 
 static void cubictcp_state(struct sock *sk, u8 new_state)
@@ -413,13 +413,13 @@ static void hystart_update(struct sock *sk, u32 delay)
 				ca->found = 1;
 				pr_debug("hystart_ack_train (%u > %u) delay_min %u (+ ack_delay %u) cwnd %u\n",
 					 now - ca->round_start, threshold,
-					 ca->delay_min, hystart_ack_delay(sk), tp->snd_cwnd);
+					 ca->delay_min, hystart_ack_delay(sk), tcp_snd_cwnd(tp));
 				NET_INC_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTTRAINDETECT);
 				NET_ADD_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTTRAINCWND,
-					      tp->snd_cwnd);
-				tp->snd_ssthresh = tp->snd_cwnd;
+					      tcp_snd_cwnd(tp));
+				tp->snd_ssthresh = tcp_snd_cwnd(tp);
 			}
 		}
 	}
@@ -438,8 +438,8 @@ static void hystart_update(struct sock *sk, u32 delay)
 					      LINUX_MIB_TCPHYSTARTDELAYDETECT);
 				NET_ADD_STATS(sock_net(sk),
 					      LINUX_MIB_TCPHYSTARTDELAYCWND,
-					      tp->snd_cwnd);
-				tp->snd_ssthresh = tp->snd_cwnd;
+					      tcp_snd_cwnd(tp));
+				tp->snd_ssthresh = tcp_snd_cwnd(tp);
 			}
 		}
 	}
@@ -469,7 +469,7 @@ static void cubictcp_acked(struct sock *sk, const struct ack_sample *sample)
 
 	/* hystart triggers when cwnd is larger than some threshold */
 	if (!ca->found && tcp_in_slow_start(tp) && hystart &&
-	    tp->snd_cwnd >= hystart_low_window)
+	    tcp_snd_cwnd(tp) >= hystart_low_window)
 		hystart_update(sk, delay);
 }
 
diff --git a/net/ipv4/tcp_dctcp.c b/net/ipv4/tcp_dctcp.c
index 0d7ab3cc7b61..d0bf7bb4b140 100644
--- a/net/ipv4/tcp_dctcp.c
+++ b/net/ipv4/tcp_dctcp.c
@@ -106,8 +106,8 @@ static u32 dctcp_ssthresh(struct sock *sk)
 	struct dctcp *ca = inet_csk_ca(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	ca->loss_cwnd = tp->snd_cwnd;
-	return max(tp->snd_cwnd - ((tp->snd_cwnd * ca->dctcp_alpha) >> 11U), 2U);
+	ca->loss_cwnd = tcp_snd_cwnd(tp);
+	return max(tcp_snd_cwnd(tp) - ((tcp_snd_cwnd(tp) * ca->dctcp_alpha) >> 11U), 2U);
 }
 
 static void dctcp_update_alpha(struct sock *sk, u32 flags)
@@ -148,8 +148,8 @@ static void dctcp_react_to_loss(struct sock *sk)
 	struct dctcp *ca = inet_csk_ca(sk);
 	struct tcp_sock *tp = tcp_sk(sk);
 
-	ca->loss_cwnd = tp->snd_cwnd;
-	tp->snd_ssthresh = max(tp->snd_cwnd >> 1U, 2U);
+	ca->loss_cwnd = tcp_snd_cwnd(tp);
+	tp->snd_ssthresh = max(tcp_snd_cwnd(tp) >> 1U, 2U);
 }
 
 static void dctcp_state(struct sock *sk, u8 new_state)
@@ -211,8 +211,9 @@ static size_t dctcp_get_info(struct sock *sk, u32 ext, int *attr,
 static u32 dctcp_cwnd_undo(struct sock *sk)
 {
 	const struct dctcp *ca = inet_csk_ca(sk);
+	struct tcp_sock *tp = tcp_sk(sk);
 
-	return max(tcp_sk(sk)->snd_cwnd, ca->loss_cwnd);
+	return max(tcp_snd_cwnd(tp), ca->loss_cwnd);
 }
 
 static struct tcp_congestion_ops dctcp __read_mostly = {
diff --git a/net/ipv4/tcp_highspeed.c b/net/ipv4/tcp_highspeed.c
index 349069d6cd0a..c6de5ce79ad3 100644
--- a/net/ipv4/tcp_highspeed.c
+++ b/net/ipv4/tcp_highspeed.c
@@ -127,22 +127,22 @@ static void hstcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		 *     snd_cwnd <=
 		 *     hstcp_aimd_vals[ca->ai].cwnd
 		 */
-		if (tp->snd_cwnd > hstcp_aimd_vals[ca->ai].cwnd) {
-			while (tp->snd_cwnd > hstcp_aimd_vals[ca->ai].cwnd &&
+		if (tcp_snd_cwnd(tp) > hstcp_aimd_vals[ca->ai].cwnd) {
+			while (tcp_snd_cwnd(tp) > hstcp_aimd_vals[ca->ai].cwnd &&
 			       ca->ai < HSTCP_AIMD_MAX - 1)
 				ca->ai++;
-		} else if (ca->ai && tp->snd_cwnd <= hstcp_aimd_vals[ca->ai-1].cwnd) {
-			while (ca->ai && tp->snd_cwnd <= hstcp_aimd_vals[ca->ai-1].cwnd)
+		} else if (ca->ai && tcp_snd_cwnd(tp) <= hstcp_aimd_vals[ca->ai-1].cwnd) {
+			while (ca->ai && tcp_snd_cwnd(tp) <= hstcp_aimd_vals[ca->ai-1].cwnd)
 				ca->ai--;
 		}
 
 		/* Do additive increase */
-		if (tp->snd_cwnd < tp->snd_cwnd_clamp) {
+		if (tcp_snd_cwnd(tp) < tp->snd_cwnd_clamp) {
 			/* cwnd = cwnd + a(w) / cwnd */
 			tp->snd_cwnd_cnt += ca->ai + 1;
-			if (tp->snd_cwnd_cnt >= tp->snd_cwnd) {
-				tp->snd_cwnd_cnt -= tp->snd_cwnd;
-				tp->snd_cwnd++;
+			if (tp->snd_cwnd_cnt >= tcp_snd_cwnd(tp)) {
+				tp->snd_cwnd_cnt -= tcp_snd_cwnd(tp);
+				tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 			}
 		}
 	}
@@ -154,7 +154,7 @@ static u32 hstcp_ssthresh(struct sock *sk)
 	struct hstcp *ca = inet_csk_ca(sk);
 
 	/* Do multiplicative decrease */
-	return max(tp->snd_cwnd - ((tp->snd_cwnd * hstcp_aimd_vals[ca->ai].md) >> 8), 2U);
+	return max(tcp_snd_cwnd(tp) - ((tcp_snd_cwnd(tp) * hstcp_aimd_vals[ca->ai].md) >> 8), 2U);
 }
 
 static struct tcp_congestion_ops tcp_highspeed __read_mostly = {
diff --git a/net/ipv4/tcp_htcp.c b/net/ipv4/tcp_htcp.c
index 55adcfcf96fe..52b1f2665dfa 100644
--- a/net/ipv4/tcp_htcp.c
+++ b/net/ipv4/tcp_htcp.c
@@ -124,7 +124,7 @@ static void measure_achieved_throughput(struct sock *sk,
 
 	ca->packetcount += sample->pkts_acked;
 
-	if (ca->packetcount >= tp->snd_cwnd - (ca->alpha >> 7 ? : 1) &&
+	if (ca->packetcount >= tcp_snd_cwnd(tp) - (ca->alpha >> 7 ? : 1) &&
 	    now - ca->lasttime >= ca->minRTT &&
 	    ca->minRTT > 0) {
 		__u32 cur_Bi = ca->packetcount * HZ / (now - ca->lasttime);
@@ -225,7 +225,7 @@ static u32 htcp_recalc_ssthresh(struct sock *sk)
 	const struct htcp *ca = inet_csk_ca(sk);
 
 	htcp_param_update(sk);
-	return max((tp->snd_cwnd * ca->beta) >> 7, 2U);
+	return max((tcp_snd_cwnd(tp) * ca->beta) >> 7, 2U);
 }
 
 static void htcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
@@ -242,9 +242,9 @@ static void htcp_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		/* In dangerous area, increase slowly.
 		 * In theory this is tp->snd_cwnd += alpha / tp->snd_cwnd
 		 */
-		if ((tp->snd_cwnd_cnt * ca->alpha)>>7 >= tp->snd_cwnd) {
-			if (tp->snd_cwnd < tp->snd_cwnd_clamp)
-				tp->snd_cwnd++;
+		if ((tp->snd_cwnd_cnt * ca->alpha)>>7 >= tcp_snd_cwnd(tp)) {
+			if (tcp_snd_cwnd(tp) < tp->snd_cwnd_clamp)
+				tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 			tp->snd_cwnd_cnt = 0;
 			htcp_alpha_update(ca);
 		} else
diff --git a/net/ipv4/tcp_hybla.c b/net/ipv4/tcp_hybla.c
index be39327e04e6..abd7d91807e5 100644
--- a/net/ipv4/tcp_hybla.c
+++ b/net/ipv4/tcp_hybla.c
@@ -54,7 +54,7 @@ static void hybla_init(struct sock *sk)
 	ca->rho2_7ls = 0;
 	ca->snd_cwnd_cents = 0;
 	ca->hybla_en = true;
-	tp->snd_cwnd = 2;
+	tcp_snd_cwnd_set(tp, 2);
 	tp->snd_cwnd_clamp = 65535;
 
 	/* 1st Rho measurement based on initial srtt */
@@ -62,7 +62,7 @@ static void hybla_init(struct sock *sk)
 
 	/* set minimum rtt as this is the 1st ever seen */
 	ca->minrtt_us = tp->srtt_us;
-	tp->snd_cwnd = ca->rho;
+	tcp_snd_cwnd_set(tp, ca->rho);
 }
 
 static void hybla_state(struct sock *sk, u8 ca_state)
@@ -137,31 +137,31 @@ static void hybla_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		 * as long as increment is estimated as (rho<<7)/window
 		 * it already is <<7 and we can easily count its fractions.
 		 */
-		increment = ca->rho2_7ls / tp->snd_cwnd;
+		increment = ca->rho2_7ls / tcp_snd_cwnd(tp);
 		if (increment < 128)
 			tp->snd_cwnd_cnt++;
 	}
 
 	odd = increment % 128;
-	tp->snd_cwnd += increment >> 7;
+	tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + (increment >> 7));
 	ca->snd_cwnd_cents += odd;
 
 	/* check when fractions goes >=128 and increase cwnd by 1. */
 	while (ca->snd_cwnd_cents >= 128) {
-		tp->snd_cwnd++;
+		tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 		ca->snd_cwnd_cents -= 128;
 		tp->snd_cwnd_cnt = 0;
 	}
 	/* check when cwnd has not been incremented for a while */
-	if (increment == 0 && odd == 0 && tp->snd_cwnd_cnt >= tp->snd_cwnd) {
-		tp->snd_cwnd++;
+	if (increment == 0 && odd == 0 && tp->snd_cwnd_cnt >= tcp_snd_cwnd(tp)) {
+		tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 		tp->snd_cwnd_cnt = 0;
 	}
 	/* clamp down slowstart cwnd to ssthresh value. */
 	if (is_slowstart)
-		tp->snd_cwnd = min(tp->snd_cwnd, tp->snd_ssthresh);
+		tcp_snd_cwnd_set(tp, min(tcp_snd_cwnd(tp), tp->snd_ssthresh));
 
-	tp->snd_cwnd = min_t(u32, tp->snd_cwnd, tp->snd_cwnd_clamp);
+	tcp_snd_cwnd_set(tp, min(tcp_snd_cwnd(tp), tp->snd_cwnd_clamp));
 }
 
 static struct tcp_congestion_ops tcp_hybla __read_mostly = {
diff --git a/net/ipv4/tcp_illinois.c b/net/ipv4/tcp_illinois.c
index 00e54873213e..c0c81a2c77fa 100644
--- a/net/ipv4/tcp_illinois.c
+++ b/net/ipv4/tcp_illinois.c
@@ -224,7 +224,7 @@ static void update_params(struct sock *sk)
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct illinois *ca = inet_csk_ca(sk);
 
-	if (tp->snd_cwnd < win_thresh) {
+	if (tcp_snd_cwnd(tp) < win_thresh) {
 		ca->alpha = ALPHA_BASE;
 		ca->beta = BETA_BASE;
 	} else if (ca->cnt_rtt > 0) {
@@ -284,9 +284,9 @@ static void tcp_illinois_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		 * tp->snd_cwnd += alpha/tp->snd_cwnd
 		*/
 		delta = (tp->snd_cwnd_cnt * ca->alpha) >> ALPHA_SHIFT;
-		if (delta >= tp->snd_cwnd) {
-			tp->snd_cwnd = min(tp->snd_cwnd + delta / tp->snd_cwnd,
-					   (u32)tp->snd_cwnd_clamp);
+		if (delta >= tcp_snd_cwnd(tp)) {
+			tcp_snd_cwnd_set(tp, min(tcp_snd_cwnd(tp) + delta / tcp_snd_cwnd(tp),
+						 (u32)tp->snd_cwnd_clamp));
 			tp->snd_cwnd_cnt = 0;
 		}
 	}
@@ -296,9 +296,11 @@ static u32 tcp_illinois_ssthresh(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct illinois *ca = inet_csk_ca(sk);
+	u32 decr;
 
 	/* Multiplicative decrease */
-	return max(tp->snd_cwnd - ((tp->snd_cwnd * ca->beta) >> BETA_SHIFT), 2U);
+	decr = (tcp_snd_cwnd(tp) * ca->beta) >> BETA_SHIFT;
+	return max(tcp_snd_cwnd(tp) - decr, 2U);
 }
 
 /* Extract info for Tcp socket info provided via netlink. */
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 96c25c97ee56..c2552b6e9322 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -414,7 +414,7 @@ static void tcp_sndbuf_expand(struct sock *sk)
 	per_mss = roundup_pow_of_two(per_mss) +
 		  SKB_DATA_ALIGN(sizeof(struct sk_buff));
 
-	nr_segs = max_t(u32, TCP_INIT_CWND, tp->snd_cwnd);
+	nr_segs = max_t(u32, TCP_INIT_CWND, tcp_snd_cwnd(tp));
 	nr_segs = max_t(u32, nr_segs, tp->reordering + 1);
 
 	/* Fast Recovery (RFC 5681 3.2) :
@@ -909,12 +909,12 @@ static void tcp_update_pacing_rate(struct sock *sk)
 	 *	 If snd_cwnd >= (tp->snd_ssthresh / 2), we are approaching
 	 *	 end of slow start and should slow down.
 	 */
-	if (tp->snd_cwnd < tp->snd_ssthresh / 2)
+	if (tcp_snd_cwnd(tp) < tp->snd_ssthresh / 2)
 		rate *= sock_net(sk)->ipv4.sysctl_tcp_pacing_ss_ratio;
 	else
 		rate *= sock_net(sk)->ipv4.sysctl_tcp_pacing_ca_ratio;
 
-	rate *= max(tp->snd_cwnd, tp->packets_out);
+	rate *= max(tcp_snd_cwnd(tp), tp->packets_out);
 
 	if (likely(tp->srtt_us))
 		do_div(rate, tp->srtt_us);
@@ -2147,12 +2147,12 @@ void tcp_enter_loss(struct sock *sk)
 	    !after(tp->high_seq, tp->snd_una) ||
 	    (icsk->icsk_ca_state == TCP_CA_Loss && !icsk->icsk_retransmits)) {
 		tp->prior_ssthresh = tcp_current_ssthresh(sk);
-		tp->prior_cwnd = tp->snd_cwnd;
+		tp->prior_cwnd = tcp_snd_cwnd(tp);
 		tp->snd_ssthresh = icsk->icsk_ca_ops->ssthresh(sk);
 		tcp_ca_event(sk, CA_EVENT_LOSS);
 		tcp_init_undo(tp);
 	}
-	tp->snd_cwnd	   = tcp_packets_in_flight(tp) + 1;
+	tcp_snd_cwnd_set(tp, tcp_packets_in_flight(tp) + 1);
 	tp->snd_cwnd_cnt   = 0;
 	tp->snd_cwnd_stamp = tcp_jiffies32;
 
@@ -2458,7 +2458,7 @@ static void DBGUNDO(struct sock *sk, const char *msg)
 		pr_debug("Undo %s %pI4/%u c%u l%u ss%u/%u p%u\n",
 			 msg,
 			 &inet->inet_daddr, ntohs(inet->inet_dport),
-			 tp->snd_cwnd, tcp_left_out(tp),
+			 tcp_snd_cwnd(tp), tcp_left_out(tp),
 			 tp->snd_ssthresh, tp->prior_ssthresh,
 			 tp->packets_out);
 	}
@@ -2467,7 +2467,7 @@ static void DBGUNDO(struct sock *sk, const char *msg)
 		pr_debug("Undo %s %pI6/%u c%u l%u ss%u/%u p%u\n",
 			 msg,
 			 &sk->sk_v6_daddr, ntohs(inet->inet_dport),
-			 tp->snd_cwnd, tcp_left_out(tp),
+			 tcp_snd_cwnd(tp), tcp_left_out(tp),
 			 tp->snd_ssthresh, tp->prior_ssthresh,
 			 tp->packets_out);
 	}
@@ -2492,7 +2492,7 @@ static void tcp_undo_cwnd_reduction(struct sock *sk, bool unmark_loss)
 	if (tp->prior_ssthresh) {
 		const struct inet_connection_sock *icsk = inet_csk(sk);
 
-		tp->snd_cwnd = icsk->icsk_ca_ops->undo_cwnd(sk);
+		tcp_snd_cwnd_set(tp, icsk->icsk_ca_ops->undo_cwnd(sk));
 
 		if (tp->prior_ssthresh > tp->snd_ssthresh) {
 			tp->snd_ssthresh = tp->prior_ssthresh;
@@ -2599,7 +2599,7 @@ static void tcp_init_cwnd_reduction(struct sock *sk)
 	tp->high_seq = tp->snd_nxt;
 	tp->tlp_high_seq = 0;
 	tp->snd_cwnd_cnt = 0;
-	tp->prior_cwnd = tp->snd_cwnd;
+	tp->prior_cwnd = tcp_snd_cwnd(tp);
 	tp->prr_delivered = 0;
 	tp->prr_out = 0;
 	tp->snd_ssthresh = inet_csk(sk)->icsk_ca_ops->ssthresh(sk);
@@ -2629,7 +2629,7 @@ void tcp_cwnd_reduction(struct sock *sk, int newly_acked_sacked, int newly_lost,
 	}
 	/* Force a fast retransmit upon entering fast recovery */
 	sndcnt = max(sndcnt, (tp->prr_out ? 0 : 1));
-	tp->snd_cwnd = tcp_packets_in_flight(tp) + sndcnt;
+	tcp_snd_cwnd_set(tp, tcp_packets_in_flight(tp) + sndcnt);
 }
 
 static inline void tcp_end_cwnd_reduction(struct sock *sk)
@@ -2642,7 +2642,7 @@ static inline void tcp_end_cwnd_reduction(struct sock *sk)
 	/* Reset cwnd to ssthresh in CWR or Recovery (unless it's undone) */
 	if (tp->snd_ssthresh < TCP_INFINITE_SSTHRESH &&
 	    (inet_csk(sk)->icsk_ca_state == TCP_CA_CWR || tp->undo_marker)) {
-		tp->snd_cwnd = tp->snd_ssthresh;
+		tcp_snd_cwnd_set(tp, tp->snd_ssthresh);
 		tp->snd_cwnd_stamp = tcp_jiffies32;
 	}
 	tcp_ca_event(sk, CA_EVENT_COMPLETE_CWR);
@@ -2706,12 +2706,15 @@ static void tcp_mtup_probe_success(struct sock *sk)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct inet_connection_sock *icsk = inet_csk(sk);
+	u64 val;
 
-	/* FIXME: breaks with very large cwnd */
 	tp->prior_ssthresh = tcp_current_ssthresh(sk);
-	tp->snd_cwnd = tp->snd_cwnd *
-		       tcp_mss_to_mtu(sk, tp->mss_cache) /
-		       icsk->icsk_mtup.probe_size;
+
+	val = (u64)tcp_snd_cwnd(tp) * tcp_mss_to_mtu(sk, tp->mss_cache);
+	do_div(val, icsk->icsk_mtup.probe_size);
+	WARN_ON_ONCE((u32)val != val);
+	tcp_snd_cwnd_set(tp, max_t(u32, 1U, val));
+
 	tp->snd_cwnd_cnt = 0;
 	tp->snd_cwnd_stamp = tcp_jiffies32;
 	tp->snd_ssthresh = tcp_current_ssthresh(sk);
@@ -3034,7 +3037,7 @@ static void tcp_fastretrans_alert(struct sock *sk, const u32 prior_snd_una,
 		    tp->snd_una == tp->mtu_probe.probe_seq_start) {
 			tcp_mtup_probe_failed(sk);
 			/* Restores the reduction we did in tcp_mtup_probe() */
-			tp->snd_cwnd++;
+			tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 			tcp_simple_retransmit(sk);
 			return;
 		}
@@ -5420,7 +5423,7 @@ static bool tcp_should_expand_sndbuf(struct sock *sk)
 		return false;
 
 	/* If we filled the congestion window, do not expand.  */
-	if (tcp_packets_in_flight(tp) >= tp->snd_cwnd)
+	if (tcp_packets_in_flight(tp) >= tcp_snd_cwnd(tp))
 		return false;
 
 	return true;
@@ -5991,9 +5994,9 @@ void tcp_init_transfer(struct sock *sk, int bpf_op, struct sk_buff *skb)
 	 * retransmission has occurred.
 	 */
 	if (tp->total_retrans > 1 && tp->undo_marker)
-		tp->snd_cwnd = 1;
+		tcp_snd_cwnd_set(tp, 1);
 	else
-		tp->snd_cwnd = tcp_init_cwnd(tp, __sk_dst_get(sk));
+		tcp_snd_cwnd_set(tp, tcp_init_cwnd(tp, __sk_dst_get(sk)));
 	tp->snd_cwnd_stamp = tcp_jiffies32;
 
 	bpf_skops_established(sk, bpf_op, skb);
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index fec656f5a39e..79f9a6187a01 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -2665,7 +2665,7 @@ static void get_tcp4_sock(struct sock *sk, struct seq_file *f, int i)
 		jiffies_to_clock_t(icsk->icsk_rto),
 		jiffies_to_clock_t(icsk->icsk_ack.ato),
 		(icsk->icsk_ack.quick << 1) | inet_csk_in_pingpong_mode(sk),
-		tp->snd_cwnd,
+		tcp_snd_cwnd(tp),
 		state == TCP_LISTEN ?
 		    fastopenq->max_qlen :
 		    (tcp_in_initial_slowstart(tp) ? -1 : tp->snd_ssthresh));
diff --git a/net/ipv4/tcp_lp.c b/net/ipv4/tcp_lp.c
index 82b36ec3f2f8..ae36780977d2 100644
--- a/net/ipv4/tcp_lp.c
+++ b/net/ipv4/tcp_lp.c
@@ -297,7 +297,7 @@ static void tcp_lp_pkts_acked(struct sock *sk, const struct ack_sample *sample)
 		lp->flag &= ~LP_WITHIN_THR;
 
 	pr_debug("TCP-LP: %05o|%5u|%5u|%15u|%15u|%15u\n", lp->flag,
-		 tp->snd_cwnd, lp->remote_hz, lp->owd_min, lp->owd_max,
+		 tcp_snd_cwnd(tp), lp->remote_hz, lp->owd_min, lp->owd_max,
 		 lp->sowd >> 3);
 
 	if (lp->flag & LP_WITHIN_THR)
@@ -313,12 +313,12 @@ static void tcp_lp_pkts_acked(struct sock *sk, const struct ack_sample *sample)
 	/* happened within inference
 	 * drop snd_cwnd into 1 */
 	if (lp->flag & LP_WITHIN_INF)
-		tp->snd_cwnd = 1U;
+		tcp_snd_cwnd_set(tp, 1U);
 
 	/* happened after inference
 	 * cut snd_cwnd into half */
 	else
-		tp->snd_cwnd = max(tp->snd_cwnd >> 1U, 1U);
+		tcp_snd_cwnd_set(tp, max(tcp_snd_cwnd(tp) >> 1U, 1U));
 
 	/* record this drop time */
 	lp->last_drop = now;
diff --git a/net/ipv4/tcp_metrics.c b/net/ipv4/tcp_metrics.c
index 0588b004ddac..7029b0e98edb 100644
--- a/net/ipv4/tcp_metrics.c
+++ b/net/ipv4/tcp_metrics.c
@@ -388,15 +388,15 @@ void tcp_update_metrics(struct sock *sk)
 		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH)) {
 			val = tcp_metric_get(tm, TCP_METRIC_SSTHRESH);
-			if (val && (tp->snd_cwnd >> 1) > val)
+			if (val && (tcp_snd_cwnd(tp) >> 1) > val)
 				tcp_metric_set(tm, TCP_METRIC_SSTHRESH,
-					       tp->snd_cwnd >> 1);
+					       tcp_snd_cwnd(tp) >> 1);
 		}
 		if (!tcp_metric_locked(tm, TCP_METRIC_CWND)) {
 			val = tcp_metric_get(tm, TCP_METRIC_CWND);
-			if (tp->snd_cwnd > val)
+			if (tcp_snd_cwnd(tp) > val)
 				tcp_metric_set(tm, TCP_METRIC_CWND,
-					       tp->snd_cwnd);
+					       tcp_snd_cwnd(tp));
 		}
 	} else if (!tcp_in_slow_start(tp) &&
 		   icsk->icsk_ca_state == TCP_CA_Open) {
@@ -404,10 +404,10 @@ void tcp_update_metrics(struct sock *sk)
 		if (!net->ipv4.sysctl_tcp_no_ssthresh_metrics_save &&
 		    !tcp_metric_locked(tm, TCP_METRIC_SSTHRESH))
 			tcp_metric_set(tm, TCP_METRIC_SSTHRESH,
-				       max(tp->snd_cwnd >> 1, tp->snd_ssthresh));
+				       max(tcp_snd_cwnd(tp) >> 1, tp->snd_ssthresh));
 		if (!tcp_metric_locked(tm, TCP_METRIC_CWND)) {
 			val = tcp_metric_get(tm, TCP_METRIC_CWND);
-			tcp_metric_set(tm, TCP_METRIC_CWND, (val + tp->snd_cwnd) >> 1);
+			tcp_metric_set(tm, TCP_METRIC_CWND, (val + tcp_snd_cwnd(tp)) >> 1);
 		}
 	} else {
 		/* Else slow start did not finish, cwnd is non-sense,
diff --git a/net/ipv4/tcp_nv.c b/net/ipv4/tcp_nv.c
index ab552356bdba..a60662f4bdf9 100644
--- a/net/ipv4/tcp_nv.c
+++ b/net/ipv4/tcp_nv.c
@@ -197,10 +197,10 @@ static void tcpnv_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 	}
 
 	if (ca->cwnd_growth_factor < 0) {
-		cnt = tp->snd_cwnd << -ca->cwnd_growth_factor;
+		cnt = tcp_snd_cwnd(tp) << -ca->cwnd_growth_factor;
 		tcp_cong_avoid_ai(tp, cnt, acked);
 	} else {
-		cnt = max(4U, tp->snd_cwnd >> ca->cwnd_growth_factor);
+		cnt = max(4U, tcp_snd_cwnd(tp) >> ca->cwnd_growth_factor);
 		tcp_cong_avoid_ai(tp, cnt, acked);
 	}
 }
@@ -209,7 +209,7 @@ static u32 tcpnv_recalc_ssthresh(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
-	return max((tp->snd_cwnd * nv_loss_dec_factor) >> 10, 2U);
+	return max((tcp_snd_cwnd(tp) * nv_loss_dec_factor) >> 10, 2U);
 }
 
 static void tcpnv_state(struct sock *sk, u8 new_state)
@@ -257,7 +257,7 @@ static void tcpnv_acked(struct sock *sk, const struct ack_sample *sample)
 		return;
 
 	/* Stop cwnd growth if we were in catch up mode */
-	if (ca->nv_catchup && tp->snd_cwnd >= nv_min_cwnd) {
+	if (ca->nv_catchup && tcp_snd_cwnd(tp) >= nv_min_cwnd) {
 		ca->nv_catchup = 0;
 		ca->nv_allow_cwnd_growth = 0;
 	}
@@ -371,7 +371,7 @@ static void tcpnv_acked(struct sock *sk, const struct ack_sample *sample)
 		 * if cwnd < max_win, grow cwnd
 		 * else leave the same
 		 */
-		if (tp->snd_cwnd > max_win) {
+		if (tcp_snd_cwnd(tp) > max_win) {
 			/* there is congestion, check that it is ok
 			 * to make a CA decision
 			 * 1. We should have at least nv_dec_eval_min_calls
@@ -398,20 +398,20 @@ static void tcpnv_acked(struct sock *sk, const struct ack_sample *sample)
 			ca->nv_allow_cwnd_growth = 0;
 			tp->snd_ssthresh =
 				(nv_ssthresh_factor * max_win) >> 3;
-			if (tp->snd_cwnd - max_win > 2) {
+			if (tcp_snd_cwnd(tp) - max_win > 2) {
 				/* gap > 2, we do exponential cwnd decrease */
 				int dec;
 
-				dec = max(2U, ((tp->snd_cwnd - max_win) *
+				dec = max(2U, ((tcp_snd_cwnd(tp) - max_win) *
 					       nv_cong_dec_mult) >> 7);
-				tp->snd_cwnd -= dec;
+				tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) - dec);
 			} else if (nv_cong_dec_mult > 0) {
-				tp->snd_cwnd = max_win;
+				tcp_snd_cwnd_set(tp, max_win);
 			}
 			if (ca->cwnd_growth_factor > 0)
 				ca->cwnd_growth_factor = 0;
 			ca->nv_no_cong_cnt = 0;
-		} else if (tp->snd_cwnd <= max_win - nv_pad_buffer) {
+		} else if (tcp_snd_cwnd(tp) <= max_win - nv_pad_buffer) {
 			/* There is no congestion, grow cwnd if allowed*/
 			if (ca->nv_eval_call_cnt < nv_inc_eval_min_calls)
 				return;
@@ -444,8 +444,8 @@ static void tcpnv_acked(struct sock *sk, const struct ack_sample *sample)
 		 * (it wasn't before, if it is now is because nv
 		 *  decreased it).
 		 */
-		if (tp->snd_cwnd < nv_min_cwnd)
-			tp->snd_cwnd = nv_min_cwnd;
+		if (tcp_snd_cwnd(tp) < nv_min_cwnd)
+			tcp_snd_cwnd_set(tp, nv_min_cwnd);
 	}
 }
 
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index 0b5eab685154..2adff4877cd6 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -143,7 +143,7 @@ void tcp_cwnd_restart(struct sock *sk, s32 delta)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	u32 restart_cwnd = tcp_init_cwnd(tp, __sk_dst_get(sk));
-	u32 cwnd = tp->snd_cwnd;
+	u32 cwnd = tcp_snd_cwnd(tp);
 
 	tcp_ca_event(sk, CA_EVENT_CWND_RESTART);
 
@@ -152,7 +152,7 @@ void tcp_cwnd_restart(struct sock *sk, s32 delta)
 
 	while ((delta -= inet_csk(sk)->icsk_rto) > 0 && cwnd > restart_cwnd)
 		cwnd >>= 1;
-	tp->snd_cwnd = max(cwnd, restart_cwnd);
+	tcp_snd_cwnd_set(tp, max(cwnd, restart_cwnd));
 	tp->snd_cwnd_stamp = tcp_jiffies32;
 	tp->snd_cwnd_used = 0;
 }
@@ -1014,7 +1014,7 @@ static void tcp_tsq_write(struct sock *sk)
 		struct tcp_sock *tp = tcp_sk(sk);
 
 		if (tp->lost_out > tp->retrans_out &&
-		    tp->snd_cwnd > tcp_packets_in_flight(tp)) {
+		    tcp_snd_cwnd(tp) > tcp_packets_in_flight(tp)) {
 			tcp_mstamp_refresh(tp);
 			tcp_xmit_retransmit_queue(sk);
 		}
@@ -1861,9 +1861,9 @@ static void tcp_cwnd_application_limited(struct sock *sk)
 		/* Limited by application or receiver window. */
 		u32 init_win = tcp_init_cwnd(tp, __sk_dst_get(sk));
 		u32 win_used = max(tp->snd_cwnd_used, init_win);
-		if (win_used < tp->snd_cwnd) {
+		if (win_used < tcp_snd_cwnd(tp)) {
 			tp->snd_ssthresh = tcp_current_ssthresh(sk);
-			tp->snd_cwnd = (tp->snd_cwnd + win_used) >> 1;
+			tcp_snd_cwnd_set(tp, (tcp_snd_cwnd(tp) + win_used) >> 1);
 		}
 		tp->snd_cwnd_used = 0;
 	}
@@ -2035,7 +2035,7 @@ static inline unsigned int tcp_cwnd_test(const struct tcp_sock *tp,
 		return 1;
 
 	in_flight = tcp_packets_in_flight(tp);
-	cwnd = tp->snd_cwnd;
+	cwnd = tcp_snd_cwnd(tp);
 	if (in_flight >= cwnd)
 		return 0;
 
@@ -2188,12 +2188,12 @@ static bool tcp_tso_should_defer(struct sock *sk, struct sk_buff *skb,
 	in_flight = tcp_packets_in_flight(tp);
 
 	BUG_ON(tcp_skb_pcount(skb) <= 1);
-	BUG_ON(tp->snd_cwnd <= in_flight);
+	BUG_ON(tcp_snd_cwnd(tp) <= in_flight);
 
 	send_win = tcp_wnd_end(tp) - TCP_SKB_CB(skb)->seq;
 
 	/* From in_flight test above, we know that cwnd > in_flight.  */
-	cong_win = (tp->snd_cwnd - in_flight) * tp->mss_cache;
+	cong_win = (tcp_snd_cwnd(tp) - in_flight) * tp->mss_cache;
 
 	limit = min(send_win, cong_win);
 
@@ -2207,7 +2207,7 @@ static bool tcp_tso_should_defer(struct sock *sk, struct sk_buff *skb,
 
 	win_divisor = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_tso_win_divisor);
 	if (win_divisor) {
-		u32 chunk = min(tp->snd_wnd, tp->snd_cwnd * tp->mss_cache);
+		u32 chunk = min(tp->snd_wnd, tcp_snd_cwnd(tp) * tp->mss_cache);
 
 		/* If at least some fraction of a window is available,
 		 * just use it.
@@ -2337,7 +2337,7 @@ static int tcp_mtu_probe(struct sock *sk)
 	if (likely(!icsk->icsk_mtup.enabled ||
 		   icsk->icsk_mtup.probe_size ||
 		   inet_csk(sk)->icsk_ca_state != TCP_CA_Open ||
-		   tp->snd_cwnd < 11 ||
+		   tcp_snd_cwnd(tp) < 11 ||
 		   tp->rx_opt.num_sacks || tp->rx_opt.dsack))
 		return -1;
 
@@ -2373,7 +2373,7 @@ static int tcp_mtu_probe(struct sock *sk)
 		return 0;
 
 	/* Do we need to wait to drain cwnd? With none in flight, don't stall */
-	if (tcp_packets_in_flight(tp) + 2 > tp->snd_cwnd) {
+	if (tcp_packets_in_flight(tp) + 2 > tcp_snd_cwnd(tp)) {
 		if (!tcp_packets_in_flight(tp))
 			return -1;
 		else
@@ -2442,7 +2442,7 @@ static int tcp_mtu_probe(struct sock *sk)
 	if (!tcp_transmit_skb(sk, nskb, 1, GFP_ATOMIC)) {
 		/* Decrement cwnd here because we are sending
 		 * effectively two packets. */
-		tp->snd_cwnd--;
+		tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) - 1);
 		tcp_event_new_data_sent(sk, nskb);
 
 		icsk->icsk_mtup.probe_size = tcp_mss_to_mtu(sk, nskb->len);
@@ -2699,7 +2699,7 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 	else
 		tcp_chrono_stop(sk, TCP_CHRONO_RWND_LIMITED);
 
-	is_cwnd_limited |= (tcp_packets_in_flight(tp) >= tp->snd_cwnd);
+	is_cwnd_limited |= (tcp_packets_in_flight(tp) >= tcp_snd_cwnd(tp));
 	if (likely(sent_pkts || is_cwnd_limited))
 		tcp_cwnd_validate(sk, is_cwnd_limited);
 
@@ -2809,7 +2809,7 @@ void tcp_send_loss_probe(struct sock *sk)
 	if (unlikely(!skb)) {
 		WARN_ONCE(tp->packets_out,
 			  "invalid inflight: %u state %u cwnd %u mss %d\n",
-			  tp->packets_out, sk->sk_state, tp->snd_cwnd, mss);
+			  tp->packets_out, sk->sk_state, tcp_snd_cwnd(tp), mss);
 		inet_csk(sk)->icsk_pending = 0;
 		return;
 	}
@@ -3293,7 +3293,7 @@ void tcp_xmit_retransmit_queue(struct sock *sk)
 		if (!hole)
 			tp->retransmit_skb_hint = skb;
 
-		segs = tp->snd_cwnd - tcp_packets_in_flight(tp);
+		segs = tcp_snd_cwnd(tp) - tcp_packets_in_flight(tp);
 		if (segs <= 0)
 			break;
 		sacked = TCP_SKB_CB(skb)->sacked;
@@ -4100,8 +4100,8 @@ int tcp_rtx_synack(const struct sock *sk, struct request_sock *req)
 	res = af_ops->send_synack(sk, NULL, &fl, req, NULL, TCP_SYNACK_NORMAL,
 				  NULL);
 	if (!res) {
-		__TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
-		__NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
+		TCP_INC_STATS(sock_net(sk), TCP_MIB_RETRANSSEGS);
+		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPSYNRETRANS);
 		if (unlikely(tcp_passive_fastopen(sk)))
 			tcp_sk(sk)->total_retrans++;
 		trace_tcp_retransmit_synack(sk, req);
diff --git a/net/ipv4/tcp_rate.c b/net/ipv4/tcp_rate.c
index 9a8e014d9b5b..a8f6d9d06f2e 100644
--- a/net/ipv4/tcp_rate.c
+++ b/net/ipv4/tcp_rate.c
@@ -200,7 +200,7 @@ void tcp_rate_check_app_limited(struct sock *sk)
 	    /* Nothing in sending host's qdisc queues or NIC tx queue. */
 	    sk_wmem_alloc_get(sk) < SKB_TRUESIZE(1) &&
 	    /* We are not limited by CWND. */
-	    tcp_packets_in_flight(tp) < tp->snd_cwnd &&
+	    tcp_packets_in_flight(tp) < tcp_snd_cwnd(tp) &&
 	    /* All lost packets have been retransmitted. */
 	    tp->lost_out <= tp->retrans_out)
 		tp->app_limited =
diff --git a/net/ipv4/tcp_scalable.c b/net/ipv4/tcp_scalable.c
index 5842081bc8a2..862b96248a92 100644
--- a/net/ipv4/tcp_scalable.c
+++ b/net/ipv4/tcp_scalable.c
@@ -27,7 +27,7 @@ static void tcp_scalable_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		if (!acked)
 			return;
 	}
-	tcp_cong_avoid_ai(tp, min(tp->snd_cwnd, TCP_SCALABLE_AI_CNT),
+	tcp_cong_avoid_ai(tp, min(tcp_snd_cwnd(tp), TCP_SCALABLE_AI_CNT),
 			  acked);
 }
 
@@ -35,7 +35,7 @@ static u32 tcp_scalable_ssthresh(struct sock *sk)
 {
 	const struct tcp_sock *tp = tcp_sk(sk);
 
-	return max(tp->snd_cwnd - (tp->snd_cwnd>>TCP_SCALABLE_MD_SCALE), 2U);
+	return max(tcp_snd_cwnd(tp) - (tcp_snd_cwnd(tp)>>TCP_SCALABLE_MD_SCALE), 2U);
 }
 
 static struct tcp_congestion_ops tcp_scalable __read_mostly = {
diff --git a/net/ipv4/tcp_vegas.c b/net/ipv4/tcp_vegas.c
index c8003c8aad2c..786848ad37ea 100644
--- a/net/ipv4/tcp_vegas.c
+++ b/net/ipv4/tcp_vegas.c
@@ -159,7 +159,7 @@ EXPORT_SYMBOL_GPL(tcp_vegas_cwnd_event);
 
 static inline u32 tcp_vegas_ssthresh(struct tcp_sock *tp)
 {
-	return  min(tp->snd_ssthresh, tp->snd_cwnd);
+	return  min(tp->snd_ssthresh, tcp_snd_cwnd(tp));
 }
 
 static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 acked)
@@ -217,14 +217,14 @@ static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 			 * This is:
 			 *     (actual rate in segments) * baseRTT
 			 */
-			target_cwnd = (u64)tp->snd_cwnd * vegas->baseRTT;
+			target_cwnd = (u64)tcp_snd_cwnd(tp) * vegas->baseRTT;
 			do_div(target_cwnd, rtt);
 
 			/* Calculate the difference between the window we had,
 			 * and the window we would like to have. This quantity
 			 * is the "Diff" from the Arizona Vegas papers.
 			 */
-			diff = tp->snd_cwnd * (rtt-vegas->baseRTT) / vegas->baseRTT;
+			diff = tcp_snd_cwnd(tp) * (rtt-vegas->baseRTT) / vegas->baseRTT;
 
 			if (diff > gamma && tcp_in_slow_start(tp)) {
 				/* Going too fast. Time to slow down
@@ -238,7 +238,8 @@ static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 				 * truncation robs us of full link
 				 * utilization.
 				 */
-				tp->snd_cwnd = min(tp->snd_cwnd, (u32)target_cwnd+1);
+				tcp_snd_cwnd_set(tp, min(tcp_snd_cwnd(tp),
+							 (u32)target_cwnd + 1));
 				tp->snd_ssthresh = tcp_vegas_ssthresh(tp);
 
 			} else if (tcp_in_slow_start(tp)) {
@@ -254,14 +255,14 @@ static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 					/* The old window was too fast, so
 					 * we slow down.
 					 */
-					tp->snd_cwnd--;
+					tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) - 1);
 					tp->snd_ssthresh
 						= tcp_vegas_ssthresh(tp);
 				} else if (diff < alpha) {
 					/* We don't have enough extra packets
 					 * in the network, so speed up.
 					 */
-					tp->snd_cwnd++;
+					tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 				} else {
 					/* Sending just as fast as we
 					 * should be.
@@ -269,10 +270,10 @@ static void tcp_vegas_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 				}
 			}
 
-			if (tp->snd_cwnd < 2)
-				tp->snd_cwnd = 2;
-			else if (tp->snd_cwnd > tp->snd_cwnd_clamp)
-				tp->snd_cwnd = tp->snd_cwnd_clamp;
+			if (tcp_snd_cwnd(tp) < 2)
+				tcp_snd_cwnd_set(tp, 2);
+			else if (tcp_snd_cwnd(tp) > tp->snd_cwnd_clamp)
+				tcp_snd_cwnd_set(tp, tp->snd_cwnd_clamp);
 
 			tp->snd_ssthresh = tcp_current_ssthresh(sk);
 		}
diff --git a/net/ipv4/tcp_veno.c b/net/ipv4/tcp_veno.c
index cd50a61c9976..366ff6f214b2 100644
--- a/net/ipv4/tcp_veno.c
+++ b/net/ipv4/tcp_veno.c
@@ -146,11 +146,11 @@ static void tcp_veno_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 
 		rtt = veno->minrtt;
 
-		target_cwnd = (u64)tp->snd_cwnd * veno->basertt;
+		target_cwnd = (u64)tcp_snd_cwnd(tp) * veno->basertt;
 		target_cwnd <<= V_PARAM_SHIFT;
 		do_div(target_cwnd, rtt);
 
-		veno->diff = (tp->snd_cwnd << V_PARAM_SHIFT) - target_cwnd;
+		veno->diff = (tcp_snd_cwnd(tp) << V_PARAM_SHIFT) - target_cwnd;
 
 		if (tcp_in_slow_start(tp)) {
 			/* Slow start. */
@@ -164,15 +164,15 @@ static void tcp_veno_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 			/* In the "non-congestive state", increase cwnd
 			 * every rtt.
 			 */
-			tcp_cong_avoid_ai(tp, tp->snd_cwnd, acked);
+			tcp_cong_avoid_ai(tp, tcp_snd_cwnd(tp), acked);
 		} else {
 			/* In the "congestive state", increase cwnd
 			 * every other rtt.
 			 */
-			if (tp->snd_cwnd_cnt >= tp->snd_cwnd) {
+			if (tp->snd_cwnd_cnt >= tcp_snd_cwnd(tp)) {
 				if (veno->inc &&
-				    tp->snd_cwnd < tp->snd_cwnd_clamp) {
-					tp->snd_cwnd++;
+				    tcp_snd_cwnd(tp) < tp->snd_cwnd_clamp) {
+					tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) + 1);
 					veno->inc = 0;
 				} else
 					veno->inc = 1;
@@ -181,10 +181,10 @@ static void tcp_veno_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 				tp->snd_cwnd_cnt += acked;
 		}
 done:
-		if (tp->snd_cwnd < 2)
-			tp->snd_cwnd = 2;
-		else if (tp->snd_cwnd > tp->snd_cwnd_clamp)
-			tp->snd_cwnd = tp->snd_cwnd_clamp;
+		if (tcp_snd_cwnd(tp) < 2)
+			tcp_snd_cwnd_set(tp, 2);
+		else if (tcp_snd_cwnd(tp) > tp->snd_cwnd_clamp)
+			tcp_snd_cwnd_set(tp, tp->snd_cwnd_clamp);
 	}
 	/* Wipe the slate clean for the next rtt. */
 	/* veno->cntrtt = 0; */
@@ -199,10 +199,10 @@ static u32 tcp_veno_ssthresh(struct sock *sk)
 
 	if (veno->diff < beta)
 		/* in "non-congestive state", cut cwnd by 1/5 */
-		return max(tp->snd_cwnd * 4 / 5, 2U);
+		return max(tcp_snd_cwnd(tp) * 4 / 5, 2U);
 	else
 		/* in "congestive state", cut cwnd by 1/2 */
-		return max(tp->snd_cwnd >> 1U, 2U);
+		return max(tcp_snd_cwnd(tp) >> 1U, 2U);
 }
 
 static struct tcp_congestion_ops tcp_veno __read_mostly = {
diff --git a/net/ipv4/tcp_westwood.c b/net/ipv4/tcp_westwood.c
index b2e05c4cea00..c6e97141eef2 100644
--- a/net/ipv4/tcp_westwood.c
+++ b/net/ipv4/tcp_westwood.c
@@ -244,7 +244,8 @@ static void tcp_westwood_event(struct sock *sk, enum tcp_ca_event event)
 
 	switch (event) {
 	case CA_EVENT_COMPLETE_CWR:
-		tp->snd_cwnd = tp->snd_ssthresh = tcp_westwood_bw_rttmin(sk);
+		tp->snd_ssthresh = tcp_westwood_bw_rttmin(sk);
+		tcp_snd_cwnd_set(tp, tp->snd_ssthresh);
 		break;
 	case CA_EVENT_LOSS:
 		tp->snd_ssthresh = tcp_westwood_bw_rttmin(sk);
diff --git a/net/ipv4/tcp_yeah.c b/net/ipv4/tcp_yeah.c
index 07c4c93b9fdb..18b07ff5d20e 100644
--- a/net/ipv4/tcp_yeah.c
+++ b/net/ipv4/tcp_yeah.c
@@ -71,11 +71,11 @@ static void tcp_yeah_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 
 	if (!yeah->doing_reno_now) {
 		/* Scalable */
-		tcp_cong_avoid_ai(tp, min(tp->snd_cwnd, TCP_SCALABLE_AI_CNT),
+		tcp_cong_avoid_ai(tp, min(tcp_snd_cwnd(tp), TCP_SCALABLE_AI_CNT),
 				  acked);
 	} else {
 		/* Reno */
-		tcp_cong_avoid_ai(tp, tp->snd_cwnd, acked);
+		tcp_cong_avoid_ai(tp, tcp_snd_cwnd(tp), acked);
 	}
 
 	/* The key players are v_vegas.beg_snd_una and v_beg_snd_nxt.
@@ -130,7 +130,7 @@ static void tcp_yeah_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 			/* Compute excess number of packets above bandwidth
 			 * Avoid doing full 64 bit divide.
 			 */
-			bw = tp->snd_cwnd;
+			bw = tcp_snd_cwnd(tp);
 			bw *= rtt - yeah->vegas.baseRTT;
 			do_div(bw, rtt);
 			queue = bw;
@@ -138,20 +138,20 @@ static void tcp_yeah_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 			if (queue > TCP_YEAH_ALPHA ||
 			    rtt - yeah->vegas.baseRTT > (yeah->vegas.baseRTT / TCP_YEAH_PHY)) {
 				if (queue > TCP_YEAH_ALPHA &&
-				    tp->snd_cwnd > yeah->reno_count) {
+				    tcp_snd_cwnd(tp) > yeah->reno_count) {
 					u32 reduction = min(queue / TCP_YEAH_GAMMA ,
-							    tp->snd_cwnd >> TCP_YEAH_EPSILON);
+							    tcp_snd_cwnd(tp) >> TCP_YEAH_EPSILON);
 
-					tp->snd_cwnd -= reduction;
+					tcp_snd_cwnd_set(tp, tcp_snd_cwnd(tp) - reduction);
 
-					tp->snd_cwnd = max(tp->snd_cwnd,
-							   yeah->reno_count);
+					tcp_snd_cwnd_set(tp, max(tcp_snd_cwnd(tp),
+								 yeah->reno_count));
 
-					tp->snd_ssthresh = tp->snd_cwnd;
+					tp->snd_ssthresh = tcp_snd_cwnd(tp);
 				}
 
 				if (yeah->reno_count <= 2)
-					yeah->reno_count = max(tp->snd_cwnd>>1, 2U);
+					yeah->reno_count = max(tcp_snd_cwnd(tp)>>1, 2U);
 				else
 					yeah->reno_count++;
 
@@ -176,7 +176,7 @@ static void tcp_yeah_cong_avoid(struct sock *sk, u32 ack, u32 acked)
 		 */
 		yeah->vegas.beg_snd_una  = yeah->vegas.beg_snd_nxt;
 		yeah->vegas.beg_snd_nxt  = tp->snd_nxt;
-		yeah->vegas.beg_snd_cwnd = tp->snd_cwnd;
+		yeah->vegas.beg_snd_cwnd = tcp_snd_cwnd(tp);
 
 		/* Wipe the slate clean for the next RTT. */
 		yeah->vegas.cntRTT = 0;
@@ -193,16 +193,16 @@ static u32 tcp_yeah_ssthresh(struct sock *sk)
 	if (yeah->doing_reno_now < TCP_YEAH_RHO) {
 		reduction = yeah->lastQ;
 
-		reduction = min(reduction, max(tp->snd_cwnd>>1, 2U));
+		reduction = min(reduction, max(tcp_snd_cwnd(tp)>>1, 2U));
 
-		reduction = max(reduction, tp->snd_cwnd >> TCP_YEAH_DELTA);
+		reduction = max(reduction, tcp_snd_cwnd(tp) >> TCP_YEAH_DELTA);
 	} else
-		reduction = max(tp->snd_cwnd>>1, 2U);
+		reduction = max(tcp_snd_cwnd(tp)>>1, 2U);
 
 	yeah->fast_count = 0;
 	yeah->reno_count = max(yeah->reno_count>>1, 2U);
 
-	return max_t(int, tp->snd_cwnd - reduction, 2);
+	return max_t(int, tcp_snd_cwnd(tp) - reduction, 2);
 }
 
 static struct tcp_congestion_ops tcp_yeah __read_mostly = {
diff --git a/net/ipv4/xfrm4_protocol.c b/net/ipv4/xfrm4_protocol.c
index 2fe5860c21d6..b146ce88c5d0 100644
--- a/net/ipv4/xfrm4_protocol.c
+++ b/net/ipv4/xfrm4_protocol.c
@@ -304,4 +304,3 @@ void __init xfrm4_protocol_init(void)
 {
 	xfrm_input_register_afinfo(&xfrm4_input_afinfo);
 }
-EXPORT_SYMBOL(xfrm4_protocol_init);
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 29bc4e7c3046..6de01185cc68 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -399,7 +399,6 @@ int __init seg6_hmac_init(void)
 {
 	return seg6_hmac_init_algo();
 }
-EXPORT_SYMBOL(seg6_hmac_init);
 
 int __net_init seg6_hmac_net_init(struct net *net)
 {
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 075ee8a2df3b..29a4fc92580e 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -2074,7 +2074,7 @@ static void get_tcp6_sock(struct seq_file *seq, struct sock *sp, int i)
 		   jiffies_to_clock_t(icsk->icsk_rto),
 		   jiffies_to_clock_t(icsk->icsk_ack.ato),
 		   (icsk->icsk_ack.quick << 1) | inet_csk_in_pingpong_mode(sp),
-		   tp->snd_cwnd,
+		   tcp_snd_cwnd(tp),
 		   state == TCP_LISTEN ?
 			fastopenq->max_qlen :
 			(tcp_in_initial_slowstart(tp) ? -1 : tp->snd_ssthresh)
diff --git a/net/key/af_key.c b/net/key/af_key.c
index 339d95df19d3..d93bde657359 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -2826,10 +2826,12 @@ static int pfkey_process(struct sock *sk, struct sk_buff *skb, const struct sadb
 	void *ext_hdrs[SADB_EXT_MAX];
 	int err;
 
-	err = pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
-			      BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
-	if (err)
-		return err;
+	/* Non-zero return value of pfkey_broadcast() does not always signal
+	 * an error and even on an actual error we may still want to process
+	 * the message so rather ignore the return value.
+	 */
+	pfkey_broadcast(skb_clone(skb, GFP_KERNEL), GFP_KERNEL,
+			BROADCAST_PROMISC_ONLY, NULL, sock_net(sk));
 
 	memset(ext_hdrs, 0, sizeof(ext_hdrs));
 	err = parse_exthdrs(skb, hdr, ext_hdrs);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 42cc703a68e5..8eac1915ec73 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -544,6 +544,7 @@ static int nft_trans_flowtable_add(struct nft_ctx *ctx, int msg_type,
 	if (msg_type == NFT_MSG_NEWFLOWTABLE)
 		nft_activate_next(ctx->net, flowtable);
 
+	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
 	nft_trans_flowtable(trans) = flowtable;
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 
@@ -1835,7 +1836,6 @@ static struct nft_hook *nft_netdev_hook_alloc(struct net *net,
 		goto err_hook_dev;
 	}
 	hook->ops.dev = dev;
-	hook->inactive = false;
 
 	return hook;
 
@@ -2087,7 +2087,7 @@ static int nft_basechain_init(struct nft_base_chain *basechain, u8 family,
 	chain->flags |= NFT_CHAIN_BASE | flags;
 	basechain->policy = NF_ACCEPT;
 	if (chain->flags & NFT_CHAIN_HW_OFFLOAD &&
-	    nft_chain_offload_priority(basechain) < 0)
+	    !nft_chain_offload_support(basechain))
 		return -EOPNOTSUPP;
 
 	flow_block_init(&basechain->flow_block);
@@ -7247,7 +7247,7 @@ static void __nft_unregister_flowtable_net_hooks(struct net *net,
 		nf_unregister_net_hook(net, &hook->ops);
 		if (release_netdev) {
 			list_del(&hook->list);
-			kfree_rcu(hook);
+			kfree_rcu(hook, rcu);
 		}
 	}
 }
@@ -7348,11 +7348,15 @@ static int nft_flowtable_update(struct nft_ctx *ctx, const struct nlmsghdr *nlh,
 
 	if (nla[NFTA_FLOWTABLE_FLAGS]) {
 		flags = ntohl(nla_get_be32(nla[NFTA_FLOWTABLE_FLAGS]));
-		if (flags & ~NFT_FLOWTABLE_MASK)
-			return -EOPNOTSUPP;
+		if (flags & ~NFT_FLOWTABLE_MASK) {
+			err = -EOPNOTSUPP;
+			goto err_flowtable_update_hook;
+		}
 		if ((flowtable->data.flags & NFT_FLOWTABLE_HW_OFFLOAD) ^
-		    (flags & NFT_FLOWTABLE_HW_OFFLOAD))
-			return -EOPNOTSUPP;
+		    (flags & NFT_FLOWTABLE_HW_OFFLOAD)) {
+			err = -EOPNOTSUPP;
+			goto err_flowtable_update_hook;
+		}
 	} else {
 		flags = flowtable->data.flags;
 	}
@@ -7533,6 +7537,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
+	LIST_HEAD(flowtable_del_list);
 	struct nft_hook *this, *hook;
 	struct nft_trans *trans;
 	int err;
@@ -7548,7 +7553,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 			err = -ENOENT;
 			goto err_flowtable_del_hook;
 		}
-		hook->inactive = true;
+		list_move(&hook->list, &flowtable_del_list);
 	}
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_DELFLOWTABLE,
@@ -7561,6 +7566,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	nft_trans_flowtable(trans) = flowtable;
 	nft_trans_flowtable_update(trans) = true;
 	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
+	list_splice(&flowtable_del_list, &nft_trans_flowtable_hooks(trans));
 	nft_flowtable_hook_release(&flowtable_hook);
 
 	nft_trans_commit_list_add_tail(ctx->net, trans);
@@ -7568,13 +7574,7 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	return 0;
 
 err_flowtable_del_hook:
-	list_for_each_entry(this, &flowtable_hook.list, list) {
-		hook = nft_hook_list_find(&flowtable->hook_list, this);
-		if (!hook)
-			break;
-
-		hook->inactive = false;
-	}
+	list_splice(&flowtable_del_list, &flowtable->hook_list);
 	nft_flowtable_hook_release(&flowtable_hook);
 
 	return err;
@@ -8244,6 +8244,9 @@ static void nft_commit_release(struct nft_trans *trans)
 		nf_tables_chain_destroy(&trans->ctx);
 		break;
 	case NFT_MSG_DELRULE:
+		if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+			nft_flow_rule_destroy(nft_trans_flow_rule(trans));
+
 		nf_tables_rule_destroy(&trans->ctx, nft_trans_rule(trans));
 		break;
 	case NFT_MSG_DELSET:
@@ -8480,17 +8483,6 @@ void nft_chain_del(struct nft_chain *chain)
 	list_del_rcu(&chain->list);
 }
 
-static void nft_flowtable_hooks_del(struct nft_flowtable *flowtable,
-				    struct list_head *hook_list)
-{
-	struct nft_hook *hook, *next;
-
-	list_for_each_entry_safe(hook, next, &flowtable->hook_list, list) {
-		if (hook->inactive)
-			list_move(&hook->list, hook_list);
-	}
-}
-
 static void nf_tables_module_autoload_cleanup(struct net *net)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -8745,6 +8737,9 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			nf_tables_rule_notify(&trans->ctx,
 					      nft_trans_rule(trans),
 					      NFT_MSG_NEWRULE);
+			if (trans->ctx.chain->flags & NFT_CHAIN_HW_OFFLOAD)
+				nft_flow_rule_destroy(nft_trans_flow_rule(trans));
+
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_DELRULE:
@@ -8835,8 +8830,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			break;
 		case NFT_MSG_DELFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
-				nft_flowtable_hooks_del(nft_trans_flowtable(trans),
-							&nft_trans_flowtable_hooks(trans));
 				nf_tables_flowtable_notify(&trans->ctx,
 							   nft_trans_flowtable(trans),
 							   &nft_trans_flowtable_hooks(trans),
@@ -8917,7 +8910,6 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
-	struct nft_hook *hook;
 
 	if (action == NFNL_ABORT_VALIDATE &&
 	    nf_tables_validate(net) < 0)
@@ -9048,8 +9040,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			break;
 		case NFT_MSG_DELFLOWTABLE:
 			if (nft_trans_flowtable_update(trans)) {
-				list_for_each_entry(hook, &nft_trans_flowtable(trans)->hook_list, list)
-					hook->inactive = false;
+				list_splice(&nft_trans_flowtable_hooks(trans),
+					    &nft_trans_flowtable(trans)->hook_list);
 			} else {
 				trans->ctx.table->use++;
 				nft_clear(trans->ctx.net, nft_trans_flowtable(trans));
diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
index 2d36952b1392..910ef881c3b8 100644
--- a/net/netfilter/nf_tables_offload.c
+++ b/net/netfilter/nf_tables_offload.c
@@ -208,7 +208,7 @@ static int nft_setup_cb_call(enum tc_setup_type type, void *type_data,
 	return 0;
 }
 
-int nft_chain_offload_priority(struct nft_base_chain *basechain)
+static int nft_chain_offload_priority(const struct nft_base_chain *basechain)
 {
 	if (basechain->ops.priority <= 0 ||
 	    basechain->ops.priority > USHRT_MAX)
@@ -217,6 +217,27 @@ int nft_chain_offload_priority(struct nft_base_chain *basechain)
 	return 0;
 }
 
+bool nft_chain_offload_support(const struct nft_base_chain *basechain)
+{
+	struct net_device *dev;
+	struct nft_hook *hook;
+
+	if (nft_chain_offload_priority(basechain) < 0)
+		return false;
+
+	list_for_each_entry(hook, &basechain->hook_list, list) {
+		if (hook->ops.pf != NFPROTO_NETDEV ||
+		    hook->ops.hooknum != NF_NETDEV_INGRESS)
+			return false;
+
+		dev = hook->ops.dev;
+		if (!dev->netdev_ops->ndo_setup_tc && !flow_indr_dev_exists())
+			return false;
+	}
+
+	return true;
+}
+
 static void nft_flow_cls_offload_setup(struct flow_cls_offload *cls_flow,
 				       const struct nft_base_chain *basechain,
 				       const struct nft_rule *rule,
diff --git a/net/netfilter/nft_nat.c b/net/netfilter/nft_nat.c
index be1595d6979d..db8f9116eeb4 100644
--- a/net/netfilter/nft_nat.c
+++ b/net/netfilter/nft_nat.c
@@ -334,7 +334,8 @@ static void nft_nat_inet_eval(const struct nft_expr *expr,
 {
 	const struct nft_nat *priv = nft_expr_priv(expr);
 
-	if (priv->family == nft_pf(pkt))
+	if (priv->family == nft_pf(pkt) ||
+	    priv->family == NFPROTO_INET)
 		nft_nat_eval(expr, regs, pkt);
 }
 
diff --git a/net/openvswitch/actions.c b/net/openvswitch/actions.c
index 8955f31fa47e..aca6e2b599c8 100644
--- a/net/openvswitch/actions.c
+++ b/net/openvswitch/actions.c
@@ -373,6 +373,7 @@ static void set_ip_addr(struct sk_buff *skb, struct iphdr *nh,
 	update_ip_l4_checksum(skb, nh, *addr, new_addr);
 	csum_replace4(&nh->check, *addr, new_addr);
 	skb_clear_hash(skb);
+	ovs_ct_clear(skb, NULL);
 	*addr = new_addr;
 }
 
@@ -420,6 +421,7 @@ static void set_ipv6_addr(struct sk_buff *skb, u8 l4_proto,
 		update_ipv6_checksum(skb, l4_proto, addr, new_addr);
 
 	skb_clear_hash(skb);
+	ovs_ct_clear(skb, NULL);
 	memcpy(addr, new_addr, sizeof(__be32[4]));
 }
 
@@ -660,6 +662,7 @@ static int set_nsh(struct sk_buff *skb, struct sw_flow_key *flow_key,
 static void set_tp_port(struct sk_buff *skb, __be16 *port,
 			__be16 new_port, __sum16 *check)
 {
+	ovs_ct_clear(skb, NULL);
 	inet_proto_csum_replace2(check, skb, *port, new_port, false);
 	*port = new_port;
 }
@@ -699,6 +702,7 @@ static int set_udp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 		uh->dest = dst;
 		flow_key->tp.src = src;
 		flow_key->tp.dst = dst;
+		ovs_ct_clear(skb, NULL);
 	}
 
 	skb_clear_hash(skb);
@@ -761,6 +765,8 @@ static int set_sctp(struct sk_buff *skb, struct sw_flow_key *flow_key,
 	sh->checksum = old_csum ^ old_correct_csum ^ new_csum;
 
 	skb_clear_hash(skb);
+	ovs_ct_clear(skb, NULL);
+
 	flow_key->tp.src = sh->source;
 	flow_key->tp.dst = sh->dest;
 
diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4a947c13c813..4e70df91d0f2 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1342,7 +1342,9 @@ int ovs_ct_clear(struct sk_buff *skb, struct sw_flow_key *key)
 
 	nf_ct_put(ct);
 	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
-	ovs_ct_fill_key(skb, key, false);
+
+	if (key)
+		ovs_ct_fill_key(skb, key, false);
 
 	return 0;
 }
diff --git a/net/sched/act_police.c b/net/sched/act_police.c
index 0923aa2b8f8a..899fe025df77 100644
--- a/net/sched/act_police.c
+++ b/net/sched/act_police.c
@@ -239,6 +239,20 @@ static int tcf_police_init(struct net *net, struct nlattr *nla,
 	return err;
 }
 
+static bool tcf_police_mtu_check(struct sk_buff *skb, u32 limit)
+{
+	u32 len;
+
+	if (skb_is_gso(skb))
+		return skb_gso_validate_mac_len(skb, limit);
+
+	len = qdisc_pkt_len(skb);
+	if (skb_at_tc_ingress(skb))
+		len += skb->mac_len;
+
+	return len <= limit;
+}
+
 static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
 			  struct tcf_result *res)
 {
@@ -261,7 +275,7 @@ static int tcf_police_act(struct sk_buff *skb, const struct tc_action *a,
 			goto inc_overlimits;
 	}
 
-	if (qdisc_pkt_len(skb) <= p->tcfp_mtu) {
+	if (tcf_police_mtu_check(skb, p->tcfp_mtu)) {
 		if (!p->rate_present && !p->pps_present) {
 			ret = p->tcfp_result;
 			goto end;
diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index b9fe31834354..4bc6b16669f3 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -1973,6 +1973,7 @@ static void smc_find_rdma_v2_device_serv(struct smc_sock *new_smc,
 
 not_found:
 	ini->smcr_version &= ~SMC_V2;
+	ini->smcrv2.ib_dev_v2 = NULL;
 	ini->check_smcrv2 = false;
 }
 
diff --git a/net/smc/smc_cdc.c b/net/smc/smc_cdc.c
index 9d5a97168969..93042ef6869b 100644
--- a/net/smc/smc_cdc.c
+++ b/net/smc/smc_cdc.c
@@ -72,7 +72,7 @@ int smc_cdc_get_free_slot(struct smc_connection *conn,
 		/* abnormal termination */
 		if (!rc)
 			smc_wr_tx_put_slot(link,
-					   (struct smc_wr_tx_pend_priv *)pend);
+					   (struct smc_wr_tx_pend_priv *)(*pend));
 		rc = -EPIPE;
 	}
 	return rc;
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index df194cc07035..b57cf9df4de8 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -979,7 +979,11 @@ static __be32 *xdr_get_next_encode_buffer(struct xdr_stream *xdr,
 	 */
 	xdr->p = (void *)p + frag2bytes;
 	space_left = xdr->buf->buflen - xdr->buf->len;
-	xdr->end = (void *)p + min_t(int, space_left, PAGE_SIZE);
+	if (space_left - nbytes >= PAGE_SIZE)
+		xdr->end = (void *)p + PAGE_SIZE;
+	else
+		xdr->end = (void *)p + space_left - frag1bytes;
+
 	xdr->buf->page_len += frag2bytes;
 	xdr->buf->len += nbytes;
 	return p;
diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index 281ddb87ac8d..190a4de239c8 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1121,6 +1121,7 @@ static bool
 rpcrdma_is_bcall(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep)
 #if defined(CONFIG_SUNRPC_BACKCHANNEL)
 {
+	struct rpc_xprt *xprt = &r_xprt->rx_xprt;
 	struct xdr_stream *xdr = &rep->rr_stream;
 	__be32 *p;
 
@@ -1144,6 +1145,10 @@ rpcrdma_is_bcall(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep)
 	if (*p != cpu_to_be32(RPC_CALL))
 		return false;
 
+	/* No bc service. */
+	if (xprt->bc_serv == NULL)
+		return false;
+
 	/* Now that we are sure this is a backchannel call,
 	 * advance to the RPC header.
 	 */
diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index 5f0155fdefc7..11cf7c646644 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -478,10 +478,10 @@ svc_rdma_build_writes(struct svc_rdma_write_info *info,
 		unsigned int write_len;
 		u64 offset;
 
-		seg = &info->wi_chunk->ch_segments[info->wi_seg_no];
-		if (!seg)
+		if (info->wi_seg_no >= info->wi_chunk->ch_segcount)
 			goto out_overflow;
 
+		seg = &info->wi_chunk->ch_segments[info->wi_seg_no];
 		write_len = min(remaining, seg->rs_length - info->wi_seg_off);
 		if (!write_len)
 			goto out_overflow;
diff --git a/net/tipc/bearer.c b/net/tipc/bearer.c
index a2f9c9640716..91d9c815a406 100644
--- a/net/tipc/bearer.c
+++ b/net/tipc/bearer.c
@@ -259,9 +259,8 @@ static int tipc_enable_bearer(struct net *net, const char *name,
 	u32 i;
 
 	if (!bearer_name_validate(name, &b_names)) {
-		errstr = "illegal name";
 		NL_SET_ERR_MSG(extack, "Illegal name");
-		goto rejected;
+		return res;
 	}
 
 	if (prio > TIPC_MAX_LINK_PRI && prio != TIPC_MEDIA_LINK_PRI) {
diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 1e7ed5829ed5..99c56922abf5 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -490,7 +490,7 @@ static int unix_dgram_peer_wake_me(struct sock *sk, struct sock *other)
 	 * -ECONNREFUSED. Otherwise, if we haven't queued any skbs
 	 * to other and its full, we will hang waiting for POLLOUT.
 	 */
-	if (unix_recvq_full(other) && !sock_flag(other, SOCK_DEAD))
+	if (unix_recvq_full_lockless(other) && !sock_flag(other, SOCK_DEAD))
 		return 1;
 
 	if (connected)
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 39a82bfb5caa..d6bcdbfd0fc5 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -343,9 +343,9 @@ bool xsk_tx_peek_desc(struct xsk_buff_pool *pool, struct xdp_desc *desc)
 }
 EXPORT_SYMBOL(xsk_tx_peek_desc);
 
-static u32 xsk_tx_peek_release_fallback(struct xsk_buff_pool *pool, struct xdp_desc *descs,
-					u32 max_entries)
+static u32 xsk_tx_peek_release_fallback(struct xsk_buff_pool *pool, u32 max_entries)
 {
+	struct xdp_desc *descs = pool->tx_descs;
 	u32 nb_pkts = 0;
 
 	while (nb_pkts < max_entries && xsk_tx_peek_desc(pool, &descs[nb_pkts]))
@@ -355,8 +355,7 @@ static u32 xsk_tx_peek_release_fallback(struct xsk_buff_pool *pool, struct xdp_d
 	return nb_pkts;
 }
 
-u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *descs,
-				   u32 max_entries)
+u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, u32 max_entries)
 {
 	struct xdp_sock *xs;
 	u32 nb_pkts;
@@ -365,7 +364,7 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
 	if (!list_is_singular(&pool->xsk_tx_list)) {
 		/* Fallback to the non-batched version */
 		rcu_read_unlock();
-		return xsk_tx_peek_release_fallback(pool, descs, max_entries);
+		return xsk_tx_peek_release_fallback(pool, max_entries);
 	}
 
 	xs = list_first_or_null_rcu(&pool->xsk_tx_list, struct xdp_sock, tx_list);
@@ -374,7 +373,8 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
 		goto out;
 	}
 
-	nb_pkts = xskq_cons_peek_desc_batch(xs->tx, descs, pool, max_entries);
+	max_entries = xskq_cons_nb_entries(xs->tx, max_entries);
+	nb_pkts = xskq_cons_read_desc_batch(xs->tx, pool, max_entries);
 	if (!nb_pkts) {
 		xs->tx->queue_empty_descs++;
 		goto out;
@@ -386,11 +386,11 @@ u32 xsk_tx_peek_release_desc_batch(struct xsk_buff_pool *pool, struct xdp_desc *
 	 * packets. This avoids having to implement any buffering in
 	 * the Tx path.
 	 */
-	nb_pkts = xskq_prod_reserve_addr_batch(pool->cq, descs, nb_pkts);
+	nb_pkts = xskq_prod_reserve_addr_batch(pool->cq, pool->tx_descs, nb_pkts);
 	if (!nb_pkts)
 		goto out;
 
-	xskq_cons_release_n(xs->tx, nb_pkts);
+	xskq_cons_release_n(xs->tx, max_entries);
 	__xskq_cons_release(xs->tx);
 	xs->sk.sk_write_space(&xs->sk);
 
@@ -968,6 +968,19 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
 
 			xp_get_pool(umem_xs->pool);
 			xs->pool = umem_xs->pool;
+
+			/* If underlying shared umem was created without Tx
+			 * ring, allocate Tx descs array that Tx batching API
+			 * utilizes
+			 */
+			if (xs->tx && !xs->pool->tx_descs) {
+				err = xp_alloc_tx_descs(xs->pool, xs);
+				if (err) {
+					xp_put_pool(xs->pool);
+					sockfd_put(sock);
+					goto out_unlock;
+				}
+			}
 		}
 
 		xdp_get_umem(umem_xs->umem);
diff --git a/net/xdp/xsk_buff_pool.c b/net/xdp/xsk_buff_pool.c
index 0202a90b65e3..87bdd71c7bb6 100644
--- a/net/xdp/xsk_buff_pool.c
+++ b/net/xdp/xsk_buff_pool.c
@@ -37,10 +37,21 @@ void xp_destroy(struct xsk_buff_pool *pool)
 	if (!pool)
 		return;
 
+	kvfree(pool->tx_descs);
 	kvfree(pool->heads);
 	kvfree(pool);
 }
 
+int xp_alloc_tx_descs(struct xsk_buff_pool *pool, struct xdp_sock *xs)
+{
+	pool->tx_descs = kvcalloc(xs->tx->nentries, sizeof(*pool->tx_descs),
+				  GFP_KERNEL);
+	if (!pool->tx_descs)
+		return -ENOMEM;
+
+	return 0;
+}
+
 struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 						struct xdp_umem *umem)
 {
@@ -58,6 +69,10 @@ struct xsk_buff_pool *xp_create_and_assign_umem(struct xdp_sock *xs,
 	if (!pool->heads)
 		goto out;
 
+	if (xs->tx)
+		if (xp_alloc_tx_descs(pool, xs))
+			goto out;
+
 	pool->chunk_mask = ~((u64)umem->chunk_size - 1);
 	pool->addrs_cnt = umem->size;
 	pool->heads_cnt = umem->chunks;
diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
index e9aa2c236356..4d092e7a33d1 100644
--- a/net/xdp/xsk_queue.h
+++ b/net/xdp/xsk_queue.h
@@ -205,11 +205,11 @@ static inline bool xskq_cons_read_desc(struct xsk_queue *q,
 	return false;
 }
 
-static inline u32 xskq_cons_read_desc_batch(struct xsk_queue *q,
-					    struct xdp_desc *descs,
-					    struct xsk_buff_pool *pool, u32 max)
+static inline u32 xskq_cons_read_desc_batch(struct xsk_queue *q, struct xsk_buff_pool *pool,
+					    u32 max)
 {
 	u32 cached_cons = q->cached_cons, nb_entries = 0;
+	struct xdp_desc *descs = pool->tx_descs;
 
 	while (cached_cons != q->cached_prod && nb_entries < max) {
 		struct xdp_rxtx_ring *ring = (struct xdp_rxtx_ring *)q->ring;
@@ -282,14 +282,6 @@ static inline bool xskq_cons_peek_desc(struct xsk_queue *q,
 	return xskq_cons_read_desc(q, desc, pool);
 }
 
-static inline u32 xskq_cons_peek_desc_batch(struct xsk_queue *q, struct xdp_desc *descs,
-					    struct xsk_buff_pool *pool, u32 max)
-{
-	u32 entries = xskq_cons_nb_entries(q, max);
-
-	return xskq_cons_read_desc_batch(q, descs, pool, entries);
-}
-
 /* To improve performance in the xskq_cons_release functions, only update local state here.
  * Reflect this to global state when we get new entries from the ring in
  * xskq_cons_get_entries() and whenever Rx or Tx processing are completed in the NAPI loop.
diff --git a/scripts/gdb/linux/config.py b/scripts/gdb/linux/config.py
index 90e1565b1967..8843ab3cbadd 100644
--- a/scripts/gdb/linux/config.py
+++ b/scripts/gdb/linux/config.py
@@ -24,9 +24,9 @@ class LxConfigDump(gdb.Command):
             filename = arg
 
         try:
-            py_config_ptr = gdb.parse_and_eval("kernel_config_data + 8")
-            py_config_size = gdb.parse_and_eval(
-                    "sizeof(kernel_config_data) - 1 - 8 * 2")
+            py_config_ptr = gdb.parse_and_eval("&kernel_config_data")
+            py_config_ptr_end = gdb.parse_and_eval("&kernel_config_data_end")
+            py_config_size = py_config_ptr_end - py_config_ptr
         except gdb.error as e:
             raise gdb.GdbError("Can't find config, enable CONFIG_IKCONFIG?")
 
diff --git a/scripts/get_abi.pl b/scripts/get_abi.pl
index 6212f58b69c6..0cf501285204 100755
--- a/scripts/get_abi.pl
+++ b/scripts/get_abi.pl
@@ -980,11 +980,11 @@ __END__
 
 =head1 NAME
 
-abi_book.pl - parse the Linux ABI files and produce a ReST book.
+get_abi.pl - parse the Linux ABI files and produce a ReST book.
 
 =head1 SYNOPSIS
 
-B<abi_book.pl> [--debug <level>] [--enable-lineno] [--man] [--help]
+B<get_abi.pl> [--debug <level>] [--enable-lineno] [--man] [--help]
 	       [--(no-)rst-source] [--dir=<dir>] [--show-hints]
 	       [--search-string <regex>]
 	       <COMAND> [<ARGUMENT>]
diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index e04ae56931e2..eae6ae9d3c3b 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1260,7 +1260,8 @@ static int secref_whitelist(const struct sectioncheck *mismatch,
 
 static inline int is_arm_mapping_symbol(const char *str)
 {
-	return str[0] == '$' && strchr("axtd", str[1])
+	return str[0] == '$' &&
+	       (str[1] == 'a' || str[1] == 'd' || str[1] == 't' || str[1] == 'x')
 	       && (str[2] == '\0' || str[2] == '.');
 }
 
@@ -1986,7 +1987,7 @@ static char *remove_dot(char *s)
 
 	if (n && s[n]) {
 		size_t m = strspn(s + n + 1, "0123456789");
-		if (m && (s[n + m] == '.' || s[n + m] == 0))
+		if (m && (s[n + m + 1] == '.' || s[n + m + 1] == 0))
 			s[n] = 0;
 
 		/* strip trailing .lto */
diff --git a/security/keys/trusted-keys/trusted_tpm2.c b/security/keys/trusted-keys/trusted_tpm2.c
index 0165da386289..2b2c8eb258d5 100644
--- a/security/keys/trusted-keys/trusted_tpm2.c
+++ b/security/keys/trusted-keys/trusted_tpm2.c
@@ -283,8 +283,8 @@ int tpm2_seal_trusted(struct tpm_chip *chip,
 	/* key properties */
 	flags = 0;
 	flags |= options->policydigest_len ? 0 : TPM2_OA_USER_WITH_AUTH;
-	flags |= payload->migratable ? (TPM2_OA_FIXED_TPM |
-					TPM2_OA_FIXED_PARENT) : 0;
+	flags |= payload->migratable ? 0 : (TPM2_OA_FIXED_TPM |
+					    TPM2_OA_FIXED_PARENT);
 	tpm_buf_append_u32(&buf, flags);
 
 	/* policy */
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 0515137a75b0..bce2cef80000 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1052,6 +1052,13 @@ static int patch_conexant_auto(struct hda_codec *codec)
 		snd_hda_pick_fixup(codec, cxt5051_fixup_models,
 				   cxt5051_fixups, cxt_fixups);
 		break;
+	case 0x14f15098:
+		codec->pin_amp_workaround = 1;
+		spec->gen.mixer_nid = 0x22;
+		spec->gen.add_stereo_mix_input = HDA_HINT_STEREO_MIX_AUTO;
+		snd_hda_pick_fixup(codec, cxt5066_fixup_models,
+				   cxt5066_fixups, cxt_fixups);
+		break;
 	case 0x14f150f2:
 		codec->power_save_node = 1;
 		fallthrough;
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 112ecc256b14..4a9cddc04045 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9056,6 +9056,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x103c, 0x88d0, "HP Pavilion 15-eh1xxx (mainboard 88D0)", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89c3, "HP", ALC285_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x89ca, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
+	SND_PCI_QUIRK(0x103c, 0x8a78, "HP Dev One", ALC285_FIXUP_HP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x1043, 0x103e, "ASUS X540SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x103f, "ASUS TX300", ALC282_FIXUP_ASUS_TX300),
 	SND_PCI_QUIRK(0x1043, 0x106d, "Asus K53BE", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
@@ -9255,6 +9256,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3176, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x3178, "ThinkCentre Station", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x17aa, 0x31af, "ThinkCentre Station", ALC623_FIXUP_LENOVO_THINKSTATION_P340),
+	SND_PCI_QUIRK(0x17aa, 0x3802, "Lenovo Yoga DuetITL 2021", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3813, "Legion 7i 15IMHG05", ALC287_FIXUP_LEGION_15IMHG05_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3818, "Lenovo C940", ALC298_FIXUP_LENOVO_SPK_VOLUME),
 	SND_PCI_QUIRK(0x17aa, 0x3819, "Lenovo 13s Gen2 ITL", ALC287_FIXUP_13S_GEN2_SPEAKERS),
diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index e7a82565b905..f078463346e8 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2097,12 +2097,14 @@ EXPORT_SYMBOL_GPL(rt5640_sel_asrc_clk_src);
 void rt5640_enable_micbias1_for_ovcd(struct snd_soc_component *component)
 {
 	struct snd_soc_dapm_context *dapm = snd_soc_component_get_dapm(component);
+	struct rt5640_priv *rt5640 = snd_soc_component_get_drvdata(component);
 
 	snd_soc_dapm_mutex_lock(dapm);
 	snd_soc_dapm_force_enable_pin_unlocked(dapm, "LDO2");
 	snd_soc_dapm_force_enable_pin_unlocked(dapm, "MICBIAS1");
 	/* OVCD is unreliable when used with RCCLK as sysclk-source */
-	snd_soc_dapm_force_enable_pin_unlocked(dapm, "Platform Clock");
+	if (rt5640->use_platform_clock)
+		snd_soc_dapm_force_enable_pin_unlocked(dapm, "Platform Clock");
 	snd_soc_dapm_sync_unlocked(dapm);
 	snd_soc_dapm_mutex_unlock(dapm);
 }
@@ -2111,9 +2113,11 @@ EXPORT_SYMBOL_GPL(rt5640_enable_micbias1_for_ovcd);
 void rt5640_disable_micbias1_for_ovcd(struct snd_soc_component *component)
 {
 	struct snd_soc_dapm_context *dapm = snd_soc_component_get_dapm(component);
+	struct rt5640_priv *rt5640 = snd_soc_component_get_drvdata(component);
 
 	snd_soc_dapm_mutex_lock(dapm);
-	snd_soc_dapm_disable_pin_unlocked(dapm, "Platform Clock");
+	if (rt5640->use_platform_clock)
+		snd_soc_dapm_disable_pin_unlocked(dapm, "Platform Clock");
 	snd_soc_dapm_disable_pin_unlocked(dapm, "MICBIAS1");
 	snd_soc_dapm_disable_pin_unlocked(dapm, "LDO2");
 	snd_soc_dapm_sync_unlocked(dapm);
@@ -2538,6 +2542,9 @@ static void rt5640_enable_jack_detect(struct snd_soc_component *component,
 		rt5640->jd_gpio_irq_requested = true;
 	}
 
+	if (jack_data && jack_data->use_platform_clock)
+		rt5640->use_platform_clock = jack_data->use_platform_clock;
+
 	ret = request_irq(rt5640->irq, rt5640_irq,
 			  IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 			  "rt5640", rt5640);
diff --git a/sound/soc/codecs/rt5640.h b/sound/soc/codecs/rt5640.h
index 9e49b9a0ccaa..505c93514051 100644
--- a/sound/soc/codecs/rt5640.h
+++ b/sound/soc/codecs/rt5640.h
@@ -2155,11 +2155,13 @@ struct rt5640_priv {
 	bool jd_inverted;
 	unsigned int ovcd_th;
 	unsigned int ovcd_sf;
+	bool use_platform_clock;
 };
 
 struct rt5640_set_jack_data {
 	int codec_irq_override;
 	struct gpio_desc *jd_gpio;
+	bool use_platform_clock;
 };
 
 int rt5640_dmic_enable(struct snd_soc_component *component,
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index 9aaf231bc024..93da86009c75 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -80,8 +80,8 @@
 #define FSL_SAI_xCR3(tx, ofs)	(tx ? FSL_SAI_TCR3(ofs) : FSL_SAI_RCR3(ofs))
 #define FSL_SAI_xCR4(tx, ofs)	(tx ? FSL_SAI_TCR4(ofs) : FSL_SAI_RCR4(ofs))
 #define FSL_SAI_xCR5(tx, ofs)	(tx ? FSL_SAI_TCR5(ofs) : FSL_SAI_RCR5(ofs))
-#define FSL_SAI_xDR(tx, ofs)	(tx ? FSL_SAI_TDR(ofs) : FSL_SAI_RDR(ofs))
-#define FSL_SAI_xFR(tx, ofs)	(tx ? FSL_SAI_TFR(ofs) : FSL_SAI_RFR(ofs))
+#define FSL_SAI_xDR0(tx)	(tx ? FSL_SAI_TDR0 : FSL_SAI_RDR0)
+#define FSL_SAI_xFR0(tx)	(tx ? FSL_SAI_TFR0 : FSL_SAI_RFR0)
 #define FSL_SAI_xMR(tx)		(tx ? FSL_SAI_TMR : FSL_SAI_RMR)
 
 /* SAI Transmit/Receive Control Register */
diff --git a/sound/soc/intel/boards/bytcr_rt5640.c b/sound/soc/intel/boards/bytcr_rt5640.c
index b5ac226c59e1..754cc4fc706d 100644
--- a/sound/soc/intel/boards/bytcr_rt5640.c
+++ b/sound/soc/intel/boards/bytcr_rt5640.c
@@ -1191,12 +1191,14 @@ static int byt_rt5640_init(struct snd_soc_pcm_runtime *runtime)
 {
 	struct snd_soc_card *card = runtime->card;
 	struct byt_rt5640_private *priv = snd_soc_card_get_drvdata(card);
+	struct rt5640_set_jack_data *jack_data = &priv->jack_data;
 	struct snd_soc_component *component = asoc_rtd_to_codec(runtime, 0)->component;
 	const struct snd_soc_dapm_route *custom_map = NULL;
 	int num_routes = 0;
 	int ret;
 
 	card->dapm.idle_bias_off = true;
+	jack_data->use_platform_clock = true;
 
 	/* Start with RC clk for jack-detect (we disable MCLK below) */
 	if (byt_rt5640_quirk & BYT_RT5640_MCLK_EN)
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index b470404a5376..e692ae04436a 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -291,6 +291,9 @@ int snd_usb_audioformat_set_sync_ep(struct snd_usb_audio *chip,
 	bool is_playback;
 	int err;
 
+	if (fmt->sync_ep)
+		return 0; /* already set up */
+
 	alts = snd_usb_get_host_interface(chip, fmt->iface, fmt->altsetting);
 	if (!alts)
 		return 0;
@@ -304,7 +307,7 @@ int snd_usb_audioformat_set_sync_ep(struct snd_usb_audio *chip,
 	 * Generic sync EP handling
 	 */
 
-	if (altsd->bNumEndpoints < 2)
+	if (fmt->ep_idx > 0 || altsd->bNumEndpoints < 2)
 		return 0;
 
 	is_playback = !(get_endpoint(alts, 0)->bEndpointAddress & USB_DIR_IN);
diff --git a/sound/usb/quirks-table.h b/sound/usb/quirks-table.h
index 78eb41b621d6..4f56e1784932 100644
--- a/sound/usb/quirks-table.h
+++ b/sound/usb/quirks-table.h
@@ -2658,7 +2658,12 @@ YAMAHA_DEVICE(0x7010, "UB99"),
 					.nr_rates = 2,
 					.rate_table = (unsigned int[]) {
 						44100, 48000
-					}
+					},
+					.sync_ep = 0x82,
+					.sync_iface = 0,
+					.sync_altsetting = 1,
+					.sync_ep_idx = 1,
+					.implicit_fb = 1,
 				}
 			},
 			{
diff --git a/tools/perf/arch/x86/util/evlist.c b/tools/perf/arch/x86/util/evlist.c
index 75564a7df15b..68f681ad54c1 100644
--- a/tools/perf/arch/x86/util/evlist.c
+++ b/tools/perf/arch/x86/util/evlist.c
@@ -3,6 +3,7 @@
 #include "util/pmu.h"
 #include "util/evlist.h"
 #include "util/parse-events.h"
+#include "topdown.h"
 
 #define TOPDOWN_L1_EVENTS	"{slots,topdown-retiring,topdown-bad-spec,topdown-fe-bound,topdown-be-bound}"
 #define TOPDOWN_L2_EVENTS	"{slots,topdown-retiring,topdown-bad-spec,topdown-fe-bound,topdown-be-bound,topdown-heavy-ops,topdown-br-mispredict,topdown-fetch-lat,topdown-mem-bound}"
@@ -25,12 +26,12 @@ struct evsel *arch_evlist__leader(struct list_head *list)
 
 	first = list_first_entry(list, struct evsel, core.node);
 
-	if (!pmu_have_event("cpu", "slots"))
+	if (!topdown_sys_has_perf_metrics())
 		return first;
 
 	/* If there is a slots event and a topdown event then the slots event comes first. */
 	__evlist__for_each_entry(list, evsel) {
-		if (evsel->pmu_name && !strcmp(evsel->pmu_name, "cpu") && evsel->name) {
+		if (evsel->pmu_name && !strncmp(evsel->pmu_name, "cpu", 3) && evsel->name) {
 			if (strcasestr(evsel->name, "slots")) {
 				slots = evsel;
 				if (slots == first)
diff --git a/tools/perf/arch/x86/util/evsel.c b/tools/perf/arch/x86/util/evsel.c
index 0c9e56ab07b5..3501399cef35 100644
--- a/tools/perf/arch/x86/util/evsel.c
+++ b/tools/perf/arch/x86/util/evsel.c
@@ -5,6 +5,7 @@
 #include "util/env.h"
 #include "util/pmu.h"
 #include "linux/string.h"
+#include "evsel.h"
 
 void arch_evsel__set_sample_weight(struct evsel *evsel)
 {
@@ -31,10 +32,29 @@ void arch_evsel__fixup_new_cycles(struct perf_event_attr *attr)
 	free(env.cpuid);
 }
 
+/* Check whether the evsel's PMU supports the perf metrics */
+bool evsel__sys_has_perf_metrics(const struct evsel *evsel)
+{
+	const char *pmu_name = evsel->pmu_name ? evsel->pmu_name : "cpu";
+
+	/*
+	 * The PERF_TYPE_RAW type is the core PMU type, e.g., "cpu" PMU
+	 * on a non-hybrid machine, "cpu_core" PMU on a hybrid machine.
+	 * The slots event is only available for the core PMU, which
+	 * supports the perf metrics feature.
+	 * Checking both the PERF_TYPE_RAW type and the slots event
+	 * should be good enough to detect the perf metrics feature.
+	 */
+	if ((evsel->core.attr.type == PERF_TYPE_RAW) &&
+	    pmu_have_event(pmu_name, "slots"))
+		return true;
+
+	return false;
+}
+
 bool arch_evsel__must_be_in_group(const struct evsel *evsel)
 {
-	if ((evsel->pmu_name && strcmp(evsel->pmu_name, "cpu")) ||
-	    !pmu_have_event("cpu", "slots"))
+	if (!evsel__sys_has_perf_metrics(evsel))
 		return false;
 
 	return evsel->name &&
diff --git a/tools/perf/arch/x86/util/evsel.h b/tools/perf/arch/x86/util/evsel.h
new file mode 100644
index 000000000000..19ad1691374d
--- /dev/null
+++ b/tools/perf/arch/x86/util/evsel.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _EVSEL_H
+#define _EVSEL_H 1
+
+bool evsel__sys_has_perf_metrics(const struct evsel *evsel);
+
+#endif
diff --git a/tools/perf/arch/x86/util/topdown.c b/tools/perf/arch/x86/util/topdown.c
index 2f3d96aa92a5..f81a7cfe4d63 100644
--- a/tools/perf/arch/x86/util/topdown.c
+++ b/tools/perf/arch/x86/util/topdown.c
@@ -3,6 +3,32 @@
 #include "api/fs/fs.h"
 #include "util/pmu.h"
 #include "util/topdown.h"
+#include "topdown.h"
+#include "evsel.h"
+
+/* Check whether there is a PMU which supports the perf metrics. */
+bool topdown_sys_has_perf_metrics(void)
+{
+	static bool has_perf_metrics;
+	static bool cached;
+	struct perf_pmu *pmu;
+
+	if (cached)
+		return has_perf_metrics;
+
+	/*
+	 * The perf metrics feature is a core PMU feature.
+	 * The PERF_TYPE_RAW type is the type of a core PMU.
+	 * The slots event is only available when the core PMU
+	 * supports the perf metrics feature.
+	 */
+	pmu = perf_pmu__find_by_type(PERF_TYPE_RAW);
+	if (pmu && pmu_have_event(pmu->name, "slots"))
+		has_perf_metrics = true;
+
+	cached = true;
+	return has_perf_metrics;
+}
 
 /*
  * Check whether we can use a group for top down.
@@ -30,33 +56,19 @@ void arch_topdown_group_warn(void)
 
 #define TOPDOWN_SLOTS		0x0400
 
-static bool is_topdown_slots_event(struct evsel *counter)
-{
-	if (!counter->pmu_name)
-		return false;
-
-	if (strcmp(counter->pmu_name, "cpu"))
-		return false;
-
-	if (counter->core.attr.config == TOPDOWN_SLOTS)
-		return true;
-
-	return false;
-}
-
 /*
  * Check whether a topdown group supports sample-read.
  *
- * Only Topdown metic supports sample-read. The slots
+ * Only Topdown metric supports sample-read. The slots
  * event must be the leader of the topdown group.
  */
 
 bool arch_topdown_sample_read(struct evsel *leader)
 {
-	if (!pmu_have_event("cpu", "slots"))
+	if (!evsel__sys_has_perf_metrics(leader))
 		return false;
 
-	if (is_topdown_slots_event(leader))
+	if (leader->core.attr.config == TOPDOWN_SLOTS)
 		return true;
 
 	return false;
diff --git a/tools/perf/arch/x86/util/topdown.h b/tools/perf/arch/x86/util/topdown.h
new file mode 100644
index 000000000000..46bf9273e572
--- /dev/null
+++ b/tools/perf/arch/x86/util/topdown.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _TOPDOWN_H
+#define _TOPDOWN_H 1
+
+bool topdown_sys_has_perf_metrics(void);
+
+#endif
diff --git a/tools/perf/builtin-c2c.c b/tools/perf/builtin-c2c.c
index d8ec683b06a5..4e0c385427a4 100644
--- a/tools/perf/builtin-c2c.c
+++ b/tools/perf/builtin-c2c.c
@@ -924,8 +924,8 @@ percent_rmt_hitm_cmp(struct perf_hpp_fmt *fmt __maybe_unused,
 	double per_left;
 	double per_right;
 
-	per_left  = PERCENT(left, lcl_hitm);
-	per_right = PERCENT(right, lcl_hitm);
+	per_left  = PERCENT(left, rmt_hitm);
+	per_right = PERCENT(right, rmt_hitm);
 
 	return per_left - per_right;
 }
diff --git a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
index 36a707e7c7a7..0c4426592a26 100644
--- a/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
+++ b/tools/testing/selftests/bpf/progs/test_stacktrace_build_id.c
@@ -39,16 +39,8 @@ struct {
 	__type(value, stack_trace_t);
 } stack_amap SEC(".maps");
 
-/* taken from /sys/kernel/debug/tracing/events/random/urandom_read/format */
-struct random_urandom_args {
-	unsigned long long pad;
-	int got_bits;
-	int pool_left;
-	int input_left;
-};
-
-SEC("tracepoint/random/urandom_read")
-int oncpu(struct random_urandom_args *args)
+SEC("kprobe/urandom_read_iter")
+int oncpu(struct pt_regs *args)
 {
 	__u32 max_len = sizeof(struct bpf_stack_build_id)
 			* PERF_MAX_STACK_DEPTH;
diff --git a/tools/testing/selftests/net/forwarding/tc_police.sh b/tools/testing/selftests/net/forwarding/tc_police.sh
index 4f9f17cb45d6..0a51eef21b9e 100755
--- a/tools/testing/selftests/net/forwarding/tc_police.sh
+++ b/tools/testing/selftests/net/forwarding/tc_police.sh
@@ -37,6 +37,8 @@ ALL_TESTS="
 	police_tx_mirror_test
 	police_pps_rx_test
 	police_pps_tx_test
+	police_mtu_rx_test
+	police_mtu_tx_test
 "
 NUM_NETIFS=6
 source tc_common.sh
@@ -346,6 +348,56 @@ police_pps_tx_test()
 	tc filter del dev $rp2 egress protocol ip pref 1 handle 101 flower
 }
 
+police_mtu_common_test() {
+	RET=0
+
+	local test_name=$1; shift
+	local dev=$1; shift
+	local direction=$1; shift
+
+	tc filter add dev $dev $direction protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action police mtu 1042 conform-exceed drop/ok
+
+	# to count "conform" packets
+	tc filter add dev $h2 ingress protocol ip pref 1 handle 101 flower \
+		dst_ip 198.51.100.1 ip_proto udp dst_port 54321 \
+		action drop
+
+	mausezahn $h1 -a own -b $(mac_get $rp1) -A 192.0.2.1 -B 198.51.100.1 \
+		-t udp sp=12345,dp=54321 -p 1001 -c 10 -q
+
+	mausezahn $h1 -a own -b $(mac_get $rp1) -A 192.0.2.1 -B 198.51.100.1 \
+		-t udp sp=12345,dp=54321 -p 1000 -c 3 -q
+
+	tc_check_packets "dev $dev $direction" 101 13
+	check_err $? "wrong packet counter"
+
+	# "exceed" packets
+	local overlimits_t0=$(tc_rule_stats_get ${dev} 1 ${direction} .overlimits)
+	test ${overlimits_t0} = 10
+	check_err $? "wrong overlimits, expected 10 got ${overlimits_t0}"
+
+	# "conform" packets
+	tc_check_packets "dev $h2 ingress" 101 3
+	check_err $? "forwarding error"
+
+	tc filter del dev $h2 ingress protocol ip pref 1 handle 101 flower
+	tc filter del dev $dev $direction protocol ip pref 1 handle 101 flower
+
+	log_test "$test_name"
+}
+
+police_mtu_rx_test()
+{
+	police_mtu_common_test "police mtu (rx)" $rp1 ingress
+}
+
+police_mtu_tx_test()
+{
+	police_mtu_common_test "police mtu (tx)" $rp2 egress
+}
+
 setup_prepare()
 {
 	h1=${NETIFS[p1]}
diff --git a/tools/testing/selftests/netfilter/nft_nat.sh b/tools/testing/selftests/netfilter/nft_nat.sh
index eb8543b9a5c4..924ecb3f1f73 100755
--- a/tools/testing/selftests/netfilter/nft_nat.sh
+++ b/tools/testing/selftests/netfilter/nft_nat.sh
@@ -374,6 +374,45 @@ EOF
 	return $lret
 }
 
+test_local_dnat_portonly()
+{
+	local family=$1
+	local daddr=$2
+	local lret=0
+	local sr_s
+	local sr_r
+
+ip netns exec "$ns0" nft -f /dev/stdin <<EOF
+table $family nat {
+	chain output {
+		type nat hook output priority 0; policy accept;
+		meta l4proto tcp dnat to :2000
+
+	}
+}
+EOF
+	if [ $? -ne 0 ]; then
+		if [ $family = "inet" ];then
+			echo "SKIP: inet port test"
+			test_inet_nat=false
+			return
+		fi
+		echo "SKIP: Could not add $family dnat hook"
+		return
+	fi
+
+	echo SERVER-$family | ip netns exec "$ns1" timeout 5 socat -u STDIN TCP-LISTEN:2000 &
+	sc_s=$!
+
+	result=$(ip netns exec "$ns0" timeout 1 socat TCP:$daddr:2000 STDOUT)
+
+	if [ "$result" = "SERVER-inet" ];then
+		echo "PASS: inet port rewrite without l3 address"
+	else
+		echo "ERROR: inet port rewrite"
+		ret=1
+	fi
+}
 
 test_masquerade6()
 {
@@ -1148,6 +1187,10 @@ fi
 reset_counters
 test_local_dnat ip
 test_local_dnat6 ip6
+
+reset_counters
+test_local_dnat_portonly inet 10.0.1.99
+
 reset_counters
 $test_inet_nat && test_local_dnat inet
 $test_inet_nat && test_local_dnat6 inet
diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
index 4b635d4de018..32ed2e7535c5 100644
--- a/tools/tracing/rtla/Makefile
+++ b/tools/tracing/rtla/Makefile
@@ -58,6 +58,41 @@ else
 DOCSRC	=	$(SRCTREE)/../../../Documentation/tools/rtla/
 endif
 
+LIBTRACEEVENT_MIN_VERSION = 1.5
+LIBTRACEFS_MIN_VERSION = 1.3
+
+TEST_LIBTRACEEVENT = $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEEVENT_MIN_VERSION) libtraceevent > /dev/null 2>&1 || echo n")
+ifeq ("$(TEST_LIBTRACEEVENT)", "n")
+.PHONY: warning_traceevent
+warning_traceevent:
+	@echo "********************************************"
+	@echo "** NOTICE: libtraceevent version $(LIBTRACEEVENT_MIN_VERSION) or higher not found"
+	@echo "**"
+	@echo "** Consider installing the latest libtraceevent from your"
+	@echo "** distribution, e.g., 'dnf install libtraceevent' on Fedora,"
+	@echo "** or from source:"
+	@echo "**"
+	@echo "**  https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/ "
+	@echo "**"
+	@echo "********************************************"
+endif
+
+TEST_LIBTRACEFS = $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEFS_MIN_VERSION) libtracefs > /dev/null 2>&1 || echo n")
+ifeq ("$(TEST_LIBTRACEFS)", "n")
+.PHONY: warning_tracefs
+warning_tracefs:
+	@echo "********************************************"
+	@echo "** NOTICE: libtracefs version $(LIBTRACEFS_MIN_VERSION) or higher not found"
+	@echo "**"
+	@echo "** Consider installing the latest libtracefs from your"
+	@echo "** distribution, e.g., 'dnf install libtracefs' on Fedora,"
+	@echo "** or from source:"
+	@echo "**"
+	@echo "**  https://git.kernel.org/pub/scm/libs/libtrace/libtracefs.git/ "
+	@echo "**"
+	@echo "********************************************"
+endif
+
 .PHONY:	all
 all:	rtla
 
