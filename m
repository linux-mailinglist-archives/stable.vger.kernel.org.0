Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24422660E10
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 11:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbjAGKqn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 05:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236762AbjAGKpi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 05:45:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39CC76262;
        Sat,  7 Jan 2023 02:45:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1F9A7B81707;
        Sat,  7 Jan 2023 10:45:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C5BC433F0;
        Sat,  7 Jan 2023 10:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673088324;
        bh=MA+bNZmrF5gJlo7do5cNTdfXyiPHD1U61T+ikpICkBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a5XenGsV/Y5BkvifbdROY0QcaVS56NExYV03tXnVIMeb58JK71GqqMicgXVbbqRPO
         FYSNiI4WxoK7ImSjohHsYQv+v9jR7UEjG2ol0b4Z7WB2aZBpchSZcE7y5r6bNMQ6h4
         1Q+QY0fYA4m7XNfLrirzSYY3Pwx1yMjIW7DXB15k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.1.4
Date:   Sat,  7 Jan 2023 11:45:13 +0100
Message-Id: <1673088312205135@kroah.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <16730883124073@kroah.com>
References: <16730883124073@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 42af9ca0127e..6b838869554b 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2300,7 +2300,13 @@
 			Provide an override to the IOAPIC-ID<->DEVICE-ID
 			mapping provided in the IVRS ACPI table.
 			By default, PCI segment is 0, and can be omitted.
-			For example:
+
+			For example, to map IOAPIC-ID decimal 10 to
+			PCI segment 0x1 and PCI device 00:14.0,
+			write the parameter as:
+				ivrs_ioapic=10@0001:00:14.0
+
+			Deprecated formats:
 			* To map IOAPIC-ID decimal 10 to PCI device 00:14.0
 			  write the parameter as:
 				ivrs_ioapic[10]=00:14.0
@@ -2312,7 +2318,13 @@
 			Provide an override to the HPET-ID<->DEVICE-ID
 			mapping provided in the IVRS ACPI table.
 			By default, PCI segment is 0, and can be omitted.
-			For example:
+
+			For example, to map HPET-ID decimal 10 to
+			PCI segment 0x1 and PCI device 00:14.0,
+			write the parameter as:
+				ivrs_hpet=10@0001:00:14.0
+
+			Deprecated formats:
 			* To map HPET-ID decimal 0 to PCI device 00:14.0
 			  write the parameter as:
 				ivrs_hpet[0]=00:14.0
@@ -2323,15 +2335,20 @@
 	ivrs_acpihid	[HW,X86-64]
 			Provide an override to the ACPI-HID:UID<->DEVICE-ID
 			mapping provided in the IVRS ACPI table.
+			By default, PCI segment is 0, and can be omitted.
 
 			For example, to map UART-HID:UID AMD0020:0 to
 			PCI segment 0x1 and PCI device ID 00:14.5,
 			write the parameter as:
-				ivrs_acpihid[0001:00:14.5]=AMD0020:0
+				ivrs_acpihid=AMD0020:0@0001:00:14.5
 
-			By default, PCI segment is 0, and can be omitted.
-			For example, PCI device 00:14.5 write the parameter as:
+			Deprecated formats:
+			* To map UART-HID:UID AMD0020:0 to PCI segment is 0,
+			  PCI device ID 00:14.5, write the parameter as:
 				ivrs_acpihid[00:14.5]=AMD0020:0
+			* To map UART-HID:UID AMD0020:0 to PCI segment 0x1 and
+			  PCI device ID 00:14.5, write the parameter as:
+				ivrs_acpihid[0001:00:14.5]=AMD0020:0
 
 	js=		[HW,JOY] Analog joystick
 			See Documentation/input/joydev/joystick.rst.
diff --git a/Documentation/filesystems/mount_api.rst b/Documentation/filesystems/mount_api.rst
index eb358a00be27..1d16787a00e9 100644
--- a/Documentation/filesystems/mount_api.rst
+++ b/Documentation/filesystems/mount_api.rst
@@ -814,6 +814,7 @@ process the parameters it is given.
        int fs_lookup_param(struct fs_context *fc,
 			   struct fs_parameter *value,
 			   bool want_bdev,
+			   unsigned int flags,
 			   struct path *_path);
 
      This takes a parameter that carries a string or filename type and attempts
diff --git a/Makefile b/Makefile
index a69d14983a48..56afd1509c74 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 1
-SUBLEVEL = 3
+SUBLEVEL = 4
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/arm/nwfpe/Makefile b/arch/arm/nwfpe/Makefile
index 303400fa2cdf..2aec85ab1e8b 100644
--- a/arch/arm/nwfpe/Makefile
+++ b/arch/arm/nwfpe/Makefile
@@ -11,3 +11,9 @@ nwfpe-y				+= fpa11.o fpa11_cpdo.o fpa11_cpdt.o \
 				   entry.o
 
 nwfpe-$(CONFIG_FPE_NWFPE_XP)	+= extended_cpdo.o
+
+# Try really hard to avoid generating calls to __aeabi_uldivmod() from
+# float64_rem() due to loop elision.
+ifdef CONFIG_CC_IS_CLANG
+CFLAGS_softfloat.o	+= -mllvm -replexitval=never
+endif
diff --git a/arch/arm64/boot/dts/mediatek/mt8195-demo.dts b/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
index 4fbd99eb496a..dec85d254838 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8195-demo.dts
@@ -56,10 +56,10 @@ reserved-memory {
 		#size-cells = <2>;
 		ranges;
 
-		/* 192 KiB reserved for ARM Trusted Firmware (BL31) */
+		/* 2 MiB reserved for ARM Trusted Firmware (BL31) */
 		bl31_secmon_reserved: secmon@54600000 {
 			no-map;
-			reg = <0 0x54600000 0x0 0x30000>;
+			reg = <0 0x54600000 0x0 0x200000>;
 		};
 
 		/* 12 MiB reserved for OP-TEE (BL32)
diff --git a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
index 212d63d5cbf2..9f2a136d5cbc 100644
--- a/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc8280xp.dtsi
@@ -855,12 +855,13 @@ ufs_mem_hc: ufs@1d84000 {
 			required-opps = <&rpmhpd_opp_nom>;
 
 			iommus = <&apps_smmu 0xe0 0x0>;
+			dma-coherent;
 
 			clocks = <&gcc GCC_UFS_PHY_AXI_CLK>,
 				 <&gcc GCC_AGGRE_UFS_PHY_AXI_CLK>,
 				 <&gcc GCC_UFS_PHY_AHB_CLK>,
 				 <&gcc GCC_UFS_PHY_UNIPRO_CORE_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_REF_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_TX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_PHY_RX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_PHY_RX_SYMBOL_1_CLK>;
@@ -891,7 +892,7 @@ ufs_mem_phy: phy@1d87000 {
 			ranges;
 			clock-names = "ref",
 				      "ref_aux";
-			clocks = <&gcc GCC_UFS_REF_CLKREF_CLK>,
+			clocks = <&gcc GCC_UFS_CARD_CLKREF_CLK>,
 				 <&gcc GCC_UFS_PHY_PHY_AUX_CLK>;
 
 			resets = <&ufs_mem_hc 0>;
@@ -923,12 +924,13 @@ ufs_card_hc: ufs@1da4000 {
 			power-domains = <&gcc UFS_CARD_GDSC>;
 
 			iommus = <&apps_smmu 0x4a0 0x0>;
+			dma-coherent;
 
 			clocks = <&gcc GCC_UFS_CARD_AXI_CLK>,
 				 <&gcc GCC_AGGRE_UFS_CARD_AXI_CLK>,
 				 <&gcc GCC_UFS_CARD_AHB_CLK>,
 				 <&gcc GCC_UFS_CARD_UNIPRO_CORE_CLK>,
-				 <&rpmhcc RPMH_CXO_CLK>,
+				 <&gcc GCC_UFS_REF_CLKREF_CLK>,
 				 <&gcc GCC_UFS_CARD_TX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_CARD_RX_SYMBOL_0_CLK>,
 				 <&gcc GCC_UFS_CARD_RX_SYMBOL_1_CLK>;
@@ -959,7 +961,7 @@ ufs_card_phy: phy@1da7000 {
 			ranges;
 			clock-names = "ref",
 				      "ref_aux";
-			clocks = <&gcc GCC_UFS_REF_CLKREF_CLK>,
+			clocks = <&gcc GCC_UFS_1_CARD_CLKREF_CLK>,
 				 <&gcc GCC_UFS_CARD_PHY_AUX_CLK>;
 
 			resets = <&ufs_card_hc 0>;
diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index 132417e2d11e..a3e15dedd60c 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -1123,7 +1123,10 @@ &wifi {
 
 /* PINCTRL - additions to nodes defined in sdm845.dtsi */
 &qup_spi2_default {
-	drive-strength = <16>;
+	pinconf {
+		pins = "gpio27", "gpio28", "gpio29", "gpio30";
+		drive-strength = <16>;
+	};
 };
 
 &qup_uart3_default{
diff --git a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
index be59a8ba9c1f..74f43da51fa5 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-lenovo-yoga-c630.dts
@@ -487,8 +487,10 @@ pinconf {
 };
 
 &qup_i2c12_default {
-	drive-strength = <2>;
-	bias-disable;
+	pinmux {
+		drive-strength = <2>;
+		bias-disable;
+	};
 };
 
 &qup_uart6_default {
diff --git a/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts b/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts
index f954fe5cb61a..d028a7eb364a 100644
--- a/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts
+++ b/arch/arm64/boot/dts/qcom/sdm850-samsung-w737.dts
@@ -415,8 +415,10 @@ pinconf {
 };
 
 &qup_i2c12_default {
-	drive-strength = <2>;
-	bias-disable;
+	pinmux {
+		drive-strength = <2>;
+		bias-disable;
+	};
 };
 
 &qup_uart6_default {
diff --git a/arch/arm64/kernel/stacktrace.c b/arch/arm64/kernel/stacktrace.c
index 634279b3b03d..117e2c180f3c 100644
--- a/arch/arm64/kernel/stacktrace.c
+++ b/arch/arm64/kernel/stacktrace.c
@@ -23,8 +23,8 @@
  *
  * The regs must be on a stack currently owned by the calling task.
  */
-static inline void unwind_init_from_regs(struct unwind_state *state,
-					 struct pt_regs *regs)
+static __always_inline void unwind_init_from_regs(struct unwind_state *state,
+						  struct pt_regs *regs)
 {
 	unwind_init_common(state, current);
 
@@ -58,8 +58,8 @@ static __always_inline void unwind_init_from_caller(struct unwind_state *state)
  * duration of the unwind, or the unwind will be bogus. It is never valid to
  * call this for the current task.
  */
-static inline void unwind_init_from_task(struct unwind_state *state,
-					 struct task_struct *task)
+static __always_inline void unwind_init_from_task(struct unwind_state *state,
+						  struct task_struct *task)
 {
 	unwind_init_common(state, task);
 
@@ -186,7 +186,7 @@ void show_stack(struct task_struct *tsk, unsigned long *sp, const char *loglvl)
 			: stackinfo_get_unknown();		\
 	})
 
-noinline notrace void arch_stack_walk(stack_trace_consume_fn consume_entry,
+noinline noinstr void arch_stack_walk(stack_trace_consume_fn consume_entry,
 			      void *cookie, struct task_struct *task,
 			      struct pt_regs *regs)
 {
diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
index ecd028854469..68ae77069d23 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -166,8 +166,8 @@ extern void __update_cache(pte_t pte);
 
 /* This calculates the number of initial pages we need for the initial
  * page tables */
-#if (KERNEL_INITIAL_ORDER) >= (PMD_SHIFT)
-# define PT_INITIAL	(1 << (KERNEL_INITIAL_ORDER - PMD_SHIFT))
+#if (KERNEL_INITIAL_ORDER) >= (PLD_SHIFT + BITS_PER_PTE)
+# define PT_INITIAL	(1 << (KERNEL_INITIAL_ORDER - PLD_SHIFT - BITS_PER_PTE))
 #else
 # define PT_INITIAL	(1)  /* all initial PTEs fit into one page */
 #endif
diff --git a/arch/parisc/kernel/firmware.c b/arch/parisc/kernel/firmware.c
index 6a7e315bcc2e..a115315d88e6 100644
--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -1288,9 +1288,8 @@ void pdc_io_reset_devices(void)
 
 #endif /* defined(BOOTLOADER) */
 
-/* locked by pdc_console_lock */
-static int __attribute__((aligned(8)))   iodc_retbuf[32];
-static char __attribute__((aligned(64))) iodc_dbuf[4096];
+/* locked by pdc_lock */
+static char iodc_dbuf[4096] __page_aligned_bss;
 
 /**
  * pdc_iodc_print - Console print using IODC.
@@ -1307,6 +1306,9 @@ int pdc_iodc_print(const unsigned char *str, unsigned count)
 	unsigned int i;
 	unsigned long flags;
 
+	count = min_t(unsigned int, count, sizeof(iodc_dbuf));
+
+	spin_lock_irqsave(&pdc_lock, flags);
 	for (i = 0; i < count;) {
 		switch(str[i]) {
 		case '\n':
@@ -1322,12 +1324,11 @@ int pdc_iodc_print(const unsigned char *str, unsigned count)
 	}
 
 print:
-        spin_lock_irqsave(&pdc_lock, flags);
-        real32_call(PAGE0->mem_cons.iodc_io,
-                    (unsigned long)PAGE0->mem_cons.hpa, ENTRY_IO_COUT,
-                    PAGE0->mem_cons.spa, __pa(PAGE0->mem_cons.dp.layers),
-                    __pa(iodc_retbuf), 0, __pa(iodc_dbuf), i, 0);
-        spin_unlock_irqrestore(&pdc_lock, flags);
+	real32_call(PAGE0->mem_cons.iodc_io,
+		(unsigned long)PAGE0->mem_cons.hpa, ENTRY_IO_COUT,
+		PAGE0->mem_cons.spa, __pa(PAGE0->mem_cons.dp.layers),
+		__pa(pdc_result), 0, __pa(iodc_dbuf), i, 0);
+	spin_unlock_irqrestore(&pdc_lock, flags);
 
 	return i;
 }
@@ -1354,10 +1355,11 @@ int pdc_iodc_getc(void)
 	real32_call(PAGE0->mem_kbd.iodc_io,
 		    (unsigned long)PAGE0->mem_kbd.hpa, ENTRY_IO_CIN,
 		    PAGE0->mem_kbd.spa, __pa(PAGE0->mem_kbd.dp.layers), 
-		    __pa(iodc_retbuf), 0, __pa(iodc_dbuf), 1, 0);
+		    __pa(pdc_result), 0, __pa(iodc_dbuf), 1, 0);
 
 	ch = *iodc_dbuf;
-	status = *iodc_retbuf;
+	/* like convert_to_wide() but for first return value only: */
+	status = *(int *)&pdc_result;
 	spin_unlock_irqrestore(&pdc_lock, flags);
 
 	if (status == 0)
diff --git a/arch/parisc/kernel/kgdb.c b/arch/parisc/kernel/kgdb.c
index ab7620f695be..b16fa9bac5f4 100644
--- a/arch/parisc/kernel/kgdb.c
+++ b/arch/parisc/kernel/kgdb.c
@@ -208,23 +208,3 @@ int kgdb_arch_handle_exception(int trap, int signo,
 	}
 	return -1;
 }
-
-/* KGDB console driver which uses PDC to read chars from keyboard */
-
-static void kgdb_pdc_write_char(u8 chr)
-{
-	/* no need to print char. kgdb will do it. */
-}
-
-static struct kgdb_io kgdb_pdc_io_ops = {
-	.name		= "kgdb_pdc",
-	.read_char	= pdc_iodc_getc,
-	.write_char	= kgdb_pdc_write_char,
-};
-
-static int __init kgdb_pdc_init(void)
-{
-	kgdb_register_io_module(&kgdb_pdc_io_ops);
-	return 0;
-}
-early_initcall(kgdb_pdc_init);
diff --git a/arch/parisc/kernel/pdc_cons.c b/arch/parisc/kernel/pdc_cons.c
index 7d0989f523d0..cf3bf8232374 100644
--- a/arch/parisc/kernel/pdc_cons.c
+++ b/arch/parisc/kernel/pdc_cons.c
@@ -12,37 +12,27 @@
 #include <asm/page.h>		/* for PAGE0 */
 #include <asm/pdc.h>		/* for iodc_call() proto and friends */
 
-static DEFINE_SPINLOCK(pdc_console_lock);
-
 static void pdc_console_write(struct console *co, const char *s, unsigned count)
 {
 	int i = 0;
-	unsigned long flags;
 
-	spin_lock_irqsave(&pdc_console_lock, flags);
 	do {
 		i += pdc_iodc_print(s + i, count - i);
 	} while (i < count);
-	spin_unlock_irqrestore(&pdc_console_lock, flags);
 }
 
 #ifdef CONFIG_KGDB
 static int kgdb_pdc_read_char(void)
 {
-	int c;
-	unsigned long flags;
-
-	spin_lock_irqsave(&pdc_console_lock, flags);
-	c = pdc_iodc_getc();
-	spin_unlock_irqrestore(&pdc_console_lock, flags);
+	int c = pdc_iodc_getc();
 
 	return (c <= 0) ? NO_POLL_CHAR : c;
 }
 
 static void kgdb_pdc_write_char(u8 chr)
 {
-	if (PAGE0->mem_cons.cl_class != CL_DUPLEX)
-		pdc_console_write(NULL, &chr, 1);
+	/* no need to print char as it's shown on standard console */
+	/* pdc_iodc_print(&chr, 1); */
 }
 
 static struct kgdb_io kgdb_pdc_io_ops = {
diff --git a/arch/parisc/kernel/vdso32/Makefile b/arch/parisc/kernel/vdso32/Makefile
index 85b1c6d261d1..4459a48d2303 100644
--- a/arch/parisc/kernel/vdso32/Makefile
+++ b/arch/parisc/kernel/vdso32/Makefile
@@ -26,7 +26,7 @@ $(obj)/vdso32_wrapper.o : $(obj)/vdso32.so FORCE
 
 # Force dependency (incbin is bad)
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso32.so: $(src)/vdso32.lds $(obj-vdso32) $(obj-cvdso32) $(VDSO_LIBGCC)
+$(obj)/vdso32.so: $(src)/vdso32.lds $(obj-vdso32) $(obj-cvdso32) $(VDSO_LIBGCC) FORCE
 	$(call if_changed,vdso32ld)
 
 # assembly rules for the .S files
@@ -38,7 +38,7 @@ $(obj-cvdso32): %.o: %.c FORCE
 
 # actual build commands
 quiet_cmd_vdso32ld = VDSO32L $@
-      cmd_vdso32ld = $(CROSS32CC) $(c_flags) -Wl,-T $^ -o $@
+      cmd_vdso32ld = $(CROSS32CC) $(c_flags) -Wl,-T $(filter-out FORCE, $^) -o $@
 quiet_cmd_vdso32as = VDSO32A $@
       cmd_vdso32as = $(CROSS32CC) $(a_flags) -c -o $@ $<
 quiet_cmd_vdso32cc = VDSO32C $@
diff --git a/arch/parisc/kernel/vdso64/Makefile b/arch/parisc/kernel/vdso64/Makefile
index a30f5ec5eb4b..f3d6045793f4 100644
--- a/arch/parisc/kernel/vdso64/Makefile
+++ b/arch/parisc/kernel/vdso64/Makefile
@@ -26,7 +26,7 @@ $(obj)/vdso64_wrapper.o : $(obj)/vdso64.so FORCE
 
 # Force dependency (incbin is bad)
 # link rule for the .so file, .lds has to be first
-$(obj)/vdso64.so: $(src)/vdso64.lds $(obj-vdso64) $(VDSO_LIBGCC)
+$(obj)/vdso64.so: $(src)/vdso64.lds $(obj-vdso64) $(VDSO_LIBGCC) FORCE
 	$(call if_changed,vdso64ld)
 
 # assembly rules for the .S files
@@ -35,7 +35,7 @@ $(obj-vdso64): %.o: %.S FORCE
 
 # actual build commands
 quiet_cmd_vdso64ld = VDSO64L $@
-      cmd_vdso64ld = $(CC) $(c_flags) -Wl,-T $^ -o $@
+      cmd_vdso64ld = $(CC) $(c_flags) -Wl,-T $(filter-out FORCE, $^) -o $@
 quiet_cmd_vdso64as = VDSO64A $@
       cmd_vdso64as = $(CC) $(a_flags) -c -o $@ $<
 
diff --git a/arch/powerpc/include/asm/ftrace.h b/arch/powerpc/include/asm/ftrace.h
index 3cee7115441b..e3d1f377bc5b 100644
--- a/arch/powerpc/include/asm/ftrace.h
+++ b/arch/powerpc/include/asm/ftrace.h
@@ -64,17 +64,6 @@ void ftrace_graph_func(unsigned long ip, unsigned long parent_ip,
  * those.
  */
 #define ARCH_HAS_SYSCALL_MATCH_SYM_NAME
-#ifdef CONFIG_PPC64_ELF_ABI_V1
-static inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
-{
-	/* We need to skip past the initial dot, and the __se_sys alias */
-	return !strcmp(sym + 1, name) ||
-		(!strncmp(sym, ".__se_sys", 9) && !strcmp(sym + 6, name)) ||
-		(!strncmp(sym, ".ppc_", 5) && !strcmp(sym + 5, name + 4)) ||
-		(!strncmp(sym, ".ppc32_", 7) && !strcmp(sym + 7, name + 4)) ||
-		(!strncmp(sym, ".ppc64_", 7) && !strcmp(sym + 7, name + 4));
-}
-#else
 static inline bool arch_syscall_match_sym_name(const char *sym, const char *name)
 {
 	return !strcmp(sym, name) ||
@@ -83,7 +72,6 @@ static inline bool arch_syscall_match_sym_name(const char *sym, const char *name
 		(!strncmp(sym, "ppc32_", 6) && !strcmp(sym + 6, name + 4)) ||
 		(!strncmp(sym, "ppc64_", 6) && !strcmp(sym + 6, name + 4));
 }
-#endif /* CONFIG_PPC64_ELF_ABI_V1 */
 #endif /* CONFIG_FTRACE_SYSCALLS */
 
 #if defined(CONFIG_PPC64) && defined(CONFIG_FUNCTION_TRACER)
diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 593cf09264d8..8e5fd5682018 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -502,7 +502,7 @@ config KEXEC_FILE
 	select KEXEC_CORE
 	select KEXEC_ELF
 	select HAVE_IMA_KEXEC if IMA
-	depends on 64BIT
+	depends on 64BIT && MMU
 	help
 	  This is new version of kexec system call. This system call is
 	  file based and takes file descriptors as system call argument
diff --git a/arch/riscv/include/asm/kexec.h b/arch/riscv/include/asm/kexec.h
index eee260e8ab30..2b56769cb530 100644
--- a/arch/riscv/include/asm/kexec.h
+++ b/arch/riscv/include/asm/kexec.h
@@ -39,6 +39,7 @@ crash_setup_regs(struct pt_regs *newregs,
 #define ARCH_HAS_KIMAGE_ARCH
 
 struct kimage_arch {
+	void *fdt; /* For CONFIG_KEXEC_FILE */
 	unsigned long fdt_addr;
 };
 
@@ -62,6 +63,10 @@ int arch_kexec_apply_relocations_add(struct purgatory_info *pi,
 				     const Elf_Shdr *relsec,
 				     const Elf_Shdr *symtab);
 #define arch_kexec_apply_relocations_add arch_kexec_apply_relocations_add
+
+struct kimage;
+int arch_kimage_file_post_load_cleanup(struct kimage *image);
+#define arch_kimage_file_post_load_cleanup arch_kimage_file_post_load_cleanup
 #endif
 
 #endif
diff --git a/arch/riscv/include/asm/mmu.h b/arch/riscv/include/asm/mmu.h
index 0099dc116168..5ff1f19fd45c 100644
--- a/arch/riscv/include/asm/mmu.h
+++ b/arch/riscv/include/asm/mmu.h
@@ -19,6 +19,8 @@ typedef struct {
 #ifdef CONFIG_SMP
 	/* A local icache flush is needed before user execution can resume. */
 	cpumask_t icache_stale_mask;
+	/* A local tlb flush is needed before user execution can resume. */
+	cpumask_t tlb_stale_mask;
 #endif
 } mm_context_t;
 
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 92ec2d9d7273..ec6fb83349ce 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -415,7 +415,7 @@ static inline void update_mmu_cache(struct vm_area_struct *vma,
 	 * Relying on flush_tlb_fix_spurious_fault would suffice, but
 	 * the extra traps reduce performance.  So, eagerly SFENCE.VMA.
 	 */
-	local_flush_tlb_page(address);
+	flush_tlb_page(vma, address);
 }
 
 static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
diff --git a/arch/riscv/include/asm/tlbflush.h b/arch/riscv/include/asm/tlbflush.h
index 801019381dea..907b9efd39a8 100644
--- a/arch/riscv/include/asm/tlbflush.h
+++ b/arch/riscv/include/asm/tlbflush.h
@@ -22,6 +22,24 @@ static inline void local_flush_tlb_page(unsigned long addr)
 {
 	ALT_FLUSH_TLB_PAGE(__asm__ __volatile__ ("sfence.vma %0" : : "r" (addr) : "memory"));
 }
+
+static inline void local_flush_tlb_all_asid(unsigned long asid)
+{
+	__asm__ __volatile__ ("sfence.vma x0, %0"
+			:
+			: "r" (asid)
+			: "memory");
+}
+
+static inline void local_flush_tlb_page_asid(unsigned long addr,
+		unsigned long asid)
+{
+	__asm__ __volatile__ ("sfence.vma %0, %1"
+			:
+			: "r" (addr), "r" (asid)
+			: "memory");
+}
+
 #else /* CONFIG_MMU */
 #define local_flush_tlb_all()			do { } while (0)
 #define local_flush_tlb_page(addr)		do { } while (0)
diff --git a/arch/riscv/kernel/elf_kexec.c b/arch/riscv/kernel/elf_kexec.c
index 0cb94992c15b..5372b708fae2 100644
--- a/arch/riscv/kernel/elf_kexec.c
+++ b/arch/riscv/kernel/elf_kexec.c
@@ -21,6 +21,18 @@
 #include <linux/memblock.h>
 #include <asm/setup.h>
 
+int arch_kimage_file_post_load_cleanup(struct kimage *image)
+{
+	kvfree(image->arch.fdt);
+	image->arch.fdt = NULL;
+
+	vfree(image->elf_headers);
+	image->elf_headers = NULL;
+	image->elf_headers_sz = 0;
+
+	return kexec_image_post_load_cleanup_default(image);
+}
+
 static int riscv_kexec_elf_load(struct kimage *image, struct elfhdr *ehdr,
 				struct kexec_elf_info *elf_info, unsigned long old_pbase,
 				unsigned long new_pbase)
@@ -298,6 +310,8 @@ static void *elf_kexec_load(struct kimage *image, char *kernel_buf,
 		pr_err("Error add DTB kbuf ret=%d\n", ret);
 		goto out_free_fdt;
 	}
+	/* Cache the fdt buffer address for memory cleanup */
+	image->arch.fdt = fdt;
 	pr_notice("Loaded device tree at 0x%lx\n", kbuf.mem);
 	goto out;
 
diff --git a/arch/riscv/kernel/stacktrace.c b/arch/riscv/kernel/stacktrace.c
index 08d11a53f39e..bcfe9eb55f80 100644
--- a/arch/riscv/kernel/stacktrace.c
+++ b/arch/riscv/kernel/stacktrace.c
@@ -58,7 +58,7 @@ void notrace walk_stackframe(struct task_struct *task, struct pt_regs *regs,
 		} else {
 			fp = frame->fp;
 			pc = ftrace_graph_ret_addr(current, NULL, frame->ra,
-						   (unsigned long *)(fp - 8));
+						   &frame->ra);
 		}
 
 	}
diff --git a/arch/riscv/mm/context.c b/arch/riscv/mm/context.c
index 7acbfbd14557..80ce9caba8d2 100644
--- a/arch/riscv/mm/context.c
+++ b/arch/riscv/mm/context.c
@@ -196,6 +196,16 @@ static void set_mm_asid(struct mm_struct *mm, unsigned int cpu)
 
 	if (need_flush_tlb)
 		local_flush_tlb_all();
+#ifdef CONFIG_SMP
+	else {
+		cpumask_t *mask = &mm->context.tlb_stale_mask;
+
+		if (cpumask_test_cpu(cpu, mask)) {
+			cpumask_clear_cpu(cpu, mask);
+			local_flush_tlb_all_asid(cntx & asid_mask);
+		}
+	}
+#endif
 }
 
 static void set_mm_noasid(struct mm_struct *mm)
diff --git a/arch/riscv/mm/tlbflush.c b/arch/riscv/mm/tlbflush.c
index 37ed760d007c..ce7dfc81bb3f 100644
--- a/arch/riscv/mm/tlbflush.c
+++ b/arch/riscv/mm/tlbflush.c
@@ -5,23 +5,7 @@
 #include <linux/sched.h>
 #include <asm/sbi.h>
 #include <asm/mmu_context.h>
-
-static inline void local_flush_tlb_all_asid(unsigned long asid)
-{
-	__asm__ __volatile__ ("sfence.vma x0, %0"
-			:
-			: "r" (asid)
-			: "memory");
-}
-
-static inline void local_flush_tlb_page_asid(unsigned long addr,
-		unsigned long asid)
-{
-	__asm__ __volatile__ ("sfence.vma %0, %1"
-			:
-			: "r" (addr), "r" (asid)
-			: "memory");
-}
+#include <asm/tlbflush.h>
 
 void flush_tlb_all(void)
 {
@@ -31,6 +15,7 @@ void flush_tlb_all(void)
 static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 				  unsigned long size, unsigned long stride)
 {
+	struct cpumask *pmask = &mm->context.tlb_stale_mask;
 	struct cpumask *cmask = mm_cpumask(mm);
 	unsigned int cpuid;
 	bool broadcast;
@@ -44,6 +29,15 @@ static void __sbi_tlb_flush_range(struct mm_struct *mm, unsigned long start,
 	if (static_branch_unlikely(&use_asid_allocator)) {
 		unsigned long asid = atomic_long_read(&mm->context.id);
 
+		/*
+		 * TLB will be immediately flushed on harts concurrently
+		 * executing this MM context. TLB flush on other harts
+		 * is deferred until this MM context migrates there.
+		 */
+		cpumask_setall(pmask);
+		cpumask_clear_cpu(cpuid, pmask);
+		cpumask_andnot(pmask, pmask, cmask);
+
 		if (broadcast) {
 			sbi_remote_sfence_vma_asid(cmask, start, size, asid);
 		} else if (size <= stride) {
diff --git a/arch/um/drivers/virt-pci.c b/arch/um/drivers/virt-pci.c
index acb55b302b14..3ac220dafec4 100644
--- a/arch/um/drivers/virt-pci.c
+++ b/arch/um/drivers/virt-pci.c
@@ -97,7 +97,8 @@ static int um_pci_send_cmd(struct um_pci_device *dev,
 	}
 
 	buf = get_cpu_var(um_pci_msg_bufs);
-	memcpy(buf, cmd, cmd_size);
+	if (buf)
+		memcpy(buf, cmd, cmd_size);
 
 	if (posted) {
 		u8 *ncmd = kmalloc(cmd_size + extra_size, GFP_ATOMIC);
@@ -182,6 +183,7 @@ static unsigned long um_pci_cfgspace_read(void *priv, unsigned int offset,
 	struct um_pci_message_buffer *buf;
 	u8 *data;
 	unsigned long ret = ULONG_MAX;
+	size_t bytes = sizeof(buf->data);
 
 	if (!dev)
 		return ULONG_MAX;
@@ -189,7 +191,8 @@ static unsigned long um_pci_cfgspace_read(void *priv, unsigned int offset,
 	buf = get_cpu_var(um_pci_msg_bufs);
 	data = buf->data;
 
-	memset(buf->data, 0xff, sizeof(buf->data));
+	if (buf)
+		memset(data, 0xff, bytes);
 
 	switch (size) {
 	case 1:
@@ -204,7 +207,7 @@ static unsigned long um_pci_cfgspace_read(void *priv, unsigned int offset,
 		goto out;
 	}
 
-	if (um_pci_send_cmd(dev, &hdr, sizeof(hdr), NULL, 0, data, 8))
+	if (um_pci_send_cmd(dev, &hdr, sizeof(hdr), NULL, 0, data, bytes))
 		goto out;
 
 	switch (size) {
diff --git a/arch/x86/events/intel/uncore.h b/arch/x86/events/intel/uncore.h
index 2adeaf4de4df..b363fddc2a89 100644
--- a/arch/x86/events/intel/uncore.h
+++ b/arch/x86/events/intel/uncore.h
@@ -2,6 +2,7 @@
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <asm/apicdef.h>
+#include <asm/intel-family.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 
 #include <linux/perf_event.h>
diff --git a/arch/x86/events/intel/uncore_snbep.c b/arch/x86/events/intel/uncore_snbep.c
index fcd95e93f479..8f371f3cbbd2 100644
--- a/arch/x86/events/intel/uncore_snbep.c
+++ b/arch/x86/events/intel/uncore_snbep.c
@@ -3804,6 +3804,21 @@ static const struct attribute_group *skx_iio_attr_update[] = {
 	NULL,
 };
 
+static void pmu_clear_mapping_attr(const struct attribute_group **groups,
+				   struct attribute_group *ag)
+{
+	int i;
+
+	for (i = 0; groups[i]; i++) {
+		if (groups[i] == ag) {
+			for (i++; groups[i]; i++)
+				groups[i - 1] = groups[i];
+			groups[i - 1] = NULL;
+			break;
+		}
+	}
+}
+
 static int
 pmu_iio_set_mapping(struct intel_uncore_type *type, struct attribute_group *ag)
 {
@@ -3852,7 +3867,7 @@ pmu_iio_set_mapping(struct intel_uncore_type *type, struct attribute_group *ag)
 clear_topology:
 	kfree(type->topology);
 clear_attr_update:
-	type->attr_update = NULL;
+	pmu_clear_mapping_attr(type->attr_update, ag);
 	return ret;
 }
 
@@ -5144,6 +5159,11 @@ static int icx_iio_get_topology(struct intel_uncore_type *type)
 
 static int icx_iio_set_mapping(struct intel_uncore_type *type)
 {
+	/* Detect ICX-D system. This case is not supported */
+	if (boot_cpu_data.x86_model == INTEL_FAM6_ICELAKE_D) {
+		pmu_clear_mapping_attr(type->attr_update, &icx_iio_mapping_group);
+		return -EPERM;
+	}
 	return pmu_iio_set_mapping(type, &icx_iio_mapping_group);
 }
 
diff --git a/arch/x86/kernel/cpu/mce/amd.c b/arch/x86/kernel/cpu/mce/amd.c
index 1c87501e0fa3..10fb5b5c9efa 100644
--- a/arch/x86/kernel/cpu/mce/amd.c
+++ b/arch/x86/kernel/cpu/mce/amd.c
@@ -788,6 +788,24 @@ _log_error_bank(unsigned int bank, u32 msr_stat, u32 msr_addr, u64 misc)
 	return status & MCI_STATUS_DEFERRED;
 }
 
+static bool _log_error_deferred(unsigned int bank, u32 misc)
+{
+	if (!_log_error_bank(bank, mca_msr_reg(bank, MCA_STATUS),
+			     mca_msr_reg(bank, MCA_ADDR), misc))
+		return false;
+
+	/*
+	 * Non-SMCA systems don't have MCA_DESTAT/MCA_DEADDR registers.
+	 * Return true here to avoid accessing these registers.
+	 */
+	if (!mce_flags.smca)
+		return true;
+
+	/* Clear MCA_DESTAT if the deferred error was logged from MCA_STATUS. */
+	wrmsrl(MSR_AMD64_SMCA_MCx_DESTAT(bank), 0);
+	return true;
+}
+
 /*
  * We have three scenarios for checking for Deferred errors:
  *
@@ -799,19 +817,8 @@ _log_error_bank(unsigned int bank, u32 msr_stat, u32 msr_addr, u64 misc)
  */
 static void log_error_deferred(unsigned int bank)
 {
-	bool defrd;
-
-	defrd = _log_error_bank(bank, mca_msr_reg(bank, MCA_STATUS),
-				mca_msr_reg(bank, MCA_ADDR), 0);
-
-	if (!mce_flags.smca)
-		return;
-
-	/* Clear MCA_DESTAT if we logged the deferred error from MCA_STATUS. */
-	if (defrd) {
-		wrmsrl(MSR_AMD64_SMCA_MCx_DESTAT(bank), 0);
+	if (_log_error_deferred(bank, 0))
 		return;
-	}
 
 	/*
 	 * Only deferred errors are logged in MCA_DE{STAT,ADDR} so just check
@@ -832,7 +839,7 @@ static void amd_deferred_error_interrupt(void)
 
 static void log_error_thresholding(unsigned int bank, u64 misc)
 {
-	_log_error_bank(bank, mca_msr_reg(bank, MCA_STATUS), mca_msr_reg(bank, MCA_ADDR), misc);
+	_log_error_deferred(bank, misc);
 }
 
 static void log_and_reset_block(struct threshold_block *block)
diff --git a/arch/x86/kernel/cpu/microcode/intel.c b/arch/x86/kernel/cpu/microcode/intel.c
index 1fcbd671f1df..048e38ec99e7 100644
--- a/arch/x86/kernel/cpu/microcode/intel.c
+++ b/arch/x86/kernel/cpu/microcode/intel.c
@@ -621,7 +621,6 @@ void load_ucode_intel_ap(void)
 	else
 		iup = &intel_ucode_patch;
 
-reget:
 	if (!*iup) {
 		patch = __load_ucode_intel(&uci);
 		if (!patch)
@@ -632,12 +631,7 @@ void load_ucode_intel_ap(void)
 
 	uci.mc = *iup;
 
-	if (apply_microcode_early(&uci, true)) {
-		/* Mixed-silicon system? Try to refetch the proper patch: */
-		*iup = NULL;
-
-		goto reget;
-	}
+	apply_microcode_early(&uci, true);
 }
 
 static struct microcode_intel *find_patch(struct ucode_cpu_info *uci)
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 59e543b95a3c..c2dde46a538e 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -440,8 +440,8 @@ static void __init __xstate_dump_leaves(void)
 	}
 }
 
-#define XSTATE_WARN_ON(x) do {							\
-	if (WARN_ONCE(x, "XSAVE consistency problem, dumping leaves")) {	\
+#define XSTATE_WARN_ON(x, fmt, ...) do {					\
+	if (WARN_ONCE(x, "XSAVE consistency problem: " fmt, ##__VA_ARGS__)) {	\
 		__xstate_dump_leaves();						\
 	}									\
 } while (0)
@@ -554,8 +554,7 @@ static bool __init check_xstate_against_struct(int nr)
 	    (nr >= XFEATURE_MAX) ||
 	    (nr == XFEATURE_PT_UNIMPLEMENTED_SO_FAR) ||
 	    ((nr >= XFEATURE_RSRVD_COMP_11) && (nr <= XFEATURE_RSRVD_COMP_16))) {
-		WARN_ONCE(1, "no structure for xstate: %d\n", nr);
-		XSTATE_WARN_ON(1);
+		XSTATE_WARN_ON(1, "No structure for xstate: %d\n", nr);
 		return false;
 	}
 	return true;
@@ -598,12 +597,13 @@ static bool __init paranoid_xstate_size_valid(unsigned int kernel_size)
 		 * XSAVES.
 		 */
 		if (!xsaves && xfeature_is_supervisor(i)) {
-			XSTATE_WARN_ON(1);
+			XSTATE_WARN_ON(1, "Got supervisor feature %d, but XSAVES not advertised\n", i);
 			return false;
 		}
 	}
 	size = xstate_calculate_size(fpu_kernel_cfg.max_features, compacted);
-	XSTATE_WARN_ON(size != kernel_size);
+	XSTATE_WARN_ON(size != kernel_size,
+		       "size %u != kernel_size %u\n", size, kernel_size);
 	return size == kernel_size;
 }
 
diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index bd165004776d..e07234ec7e23 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -217,7 +217,9 @@ void ftrace_replace_code(int enable)
 
 		ret = ftrace_verify_code(rec->ip, old);
 		if (ret) {
+			ftrace_expected = old;
 			ftrace_bug(ret, rec);
+			ftrace_expected = NULL;
 			return;
 		}
 	}
diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index eb8bc82846b9..5be7f23099e1 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -37,6 +37,7 @@
 #include <linux/extable.h>
 #include <linux/kdebug.h>
 #include <linux/kallsyms.h>
+#include <linux/kgdb.h>
 #include <linux/ftrace.h>
 #include <linux/kasan.h>
 #include <linux/moduleloader.h>
@@ -281,12 +282,15 @@ static int can_probe(unsigned long paddr)
 		if (ret < 0)
 			return 0;
 
+#ifdef CONFIG_KGDB
 		/*
-		 * Another debugging subsystem might insert this breakpoint.
-		 * In that case, we can't recover it.
+		 * If there is a dynamically installed kgdb sw breakpoint,
+		 * this function should not be probed.
 		 */
-		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE)
+		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE &&
+		    kgdb_has_hit_break(addr))
 			return 0;
+#endif
 		addr += insn.length;
 	}
 
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index e6b8c5362b94..e57e07b0edb6 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -15,6 +15,7 @@
 #include <linux/extable.h>
 #include <linux/kdebug.h>
 #include <linux/kallsyms.h>
+#include <linux/kgdb.h>
 #include <linux/ftrace.h>
 #include <linux/objtool.h>
 #include <linux/pgtable.h>
@@ -279,19 +280,6 @@ static int insn_is_indirect_jump(struct insn *insn)
 	return ret;
 }
 
-static bool is_padding_int3(unsigned long addr, unsigned long eaddr)
-{
-	unsigned char ops;
-
-	for (; addr < eaddr; addr++) {
-		if (get_kernel_nofault(ops, (void *)addr) < 0 ||
-		    ops != INT3_INSN_OPCODE)
-			return false;
-	}
-
-	return true;
-}
-
 /* Decode whole function to ensure any instructions don't jump into target */
 static int can_optimize(unsigned long paddr)
 {
@@ -334,15 +322,15 @@ static int can_optimize(unsigned long paddr)
 		ret = insn_decode_kernel(&insn, (void *)recovered_insn);
 		if (ret < 0)
 			return 0;
-
+#ifdef CONFIG_KGDB
 		/*
-		 * In the case of detecting unknown breakpoint, this could be
-		 * a padding INT3 between functions. Let's check that all the
-		 * rest of the bytes are also INT3.
+		 * If there is a dynamically installed kgdb sw breakpoint,
+		 * this function should not be probed.
 		 */
-		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE)
-			return is_padding_int3(addr, paddr - offset + size) ? 1 : 0;
-
+		if (insn.opcode.bytes[0] == INT3_INSN_OPCODE &&
+		    kgdb_has_hit_break(addr))
+			return 0;
+#endif
 		/* Recover address */
 		insn.kaddr = (void *)addr;
 		insn.next_byte = (void *)(addr + insn.length);
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index d7639d126e6c..bf5ce862c4da 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2722,8 +2722,6 @@ static int kvm_apic_state_fixup(struct kvm_vcpu *vcpu,
 			icr = __kvm_lapic_get_reg64(s->regs, APIC_ICR);
 			__kvm_lapic_set_reg(s->regs, APIC_ICR2, icr >> 32);
 		}
-	} else {
-		kvm_lapic_xapic_id_updated(vcpu->arch.apic);
 	}
 
 	return 0;
@@ -2759,6 +2757,9 @@ int kvm_apic_set_state(struct kvm_vcpu *vcpu, struct kvm_lapic_state *s)
 	}
 	memcpy(vcpu->arch.apic->regs, s->regs, sizeof(*s));
 
+	if (!apic_x2apic_mode(apic))
+		kvm_lapic_xapic_id_updated(apic);
+
 	atomic_set_release(&apic->vcpu->kvm->arch.apic_map_dirty, DIRTY);
 	kvm_recalculate_apic_map(vcpu->kvm);
 	kvm_apic_set_version(vcpu);
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 5b0d4859e4b7..10c63b1bf92f 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -5100,24 +5100,35 @@ static int handle_vmxon(struct kvm_vcpu *vcpu)
 		| FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
 
 	/*
-	 * Note, KVM cannot rely on hardware to perform the CR0/CR4 #UD checks
-	 * that have higher priority than VM-Exit (see Intel SDM's pseudocode
-	 * for VMXON), as KVM must load valid CR0/CR4 values into hardware while
-	 * running the guest, i.e. KVM needs to check the _guest_ values.
+	 * Manually check CR4.VMXE checks, KVM must force CR4.VMXE=1 to enter
+	 * the guest and so cannot rely on hardware to perform the check,
+	 * which has higher priority than VM-Exit (see Intel SDM's pseudocode
+	 * for VMXON).
 	 *
-	 * Rely on hardware for the other two pre-VM-Exit checks, !VM86 and
-	 * !COMPATIBILITY modes.  KVM may run the guest in VM86 to emulate Real
-	 * Mode, but KVM will never take the guest out of those modes.
+	 * Rely on hardware for the other pre-VM-Exit checks, CR0.PE=1, !VM86
+	 * and !COMPATIBILITY modes.  For an unrestricted guest, KVM doesn't
+	 * force any of the relevant guest state.  For a restricted guest, KVM
+	 * does force CR0.PE=1, but only to also force VM86 in order to emulate
+	 * Real Mode, and so there's no need to check CR0.PE manually.
 	 */
-	if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
-	    !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
+	if (!kvm_read_cr4_bits(vcpu, X86_CR4_VMXE)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
 
 	/*
-	 * CPL=0 and all other checks that are lower priority than VM-Exit must
-	 * be checked manually.
+	 * The CPL is checked for "not in VMX operation" and for "in VMX root",
+	 * and has higher priority than the VM-Fail due to being post-VMXON,
+	 * i.e. VMXON #GPs outside of VMX non-root if CPL!=0.  In VMX non-root,
+	 * VMXON causes VM-Exit and KVM unconditionally forwards VMXON VM-Exits
+	 * from L2 to L1, i.e. there's no need to check for the vCPU being in
+	 * VMX non-root.
+	 *
+	 * Forwarding the VM-Exit unconditionally, i.e. without performing the
+	 * #UD checks (see above), is functionally ok because KVM doesn't allow
+	 * L1 to run L2 without CR4.VMXE=0, and because KVM never modifies L2's
+	 * CR0 or CR4, i.e. it's L2's responsibility to emulate #UDs that are
+	 * missed by hardware due to shadowing CR0 and/or CR4.
 	 */
 	if (vmx_get_cpl(vcpu)) {
 		kvm_inject_gp(vcpu, 0);
@@ -5127,6 +5138,17 @@ static int handle_vmxon(struct kvm_vcpu *vcpu)
 	if (vmx->nested.vmxon)
 		return nested_vmx_fail(vcpu, VMXERR_VMXON_IN_VMX_ROOT_OPERATION);
 
+	/*
+	 * Invalid CR0/CR4 generates #GP.  These checks are performed if and
+	 * only if the vCPU isn't already in VMX operation, i.e. effectively
+	 * have lower priority than the VM-Fail above.
+	 */
+	if (!nested_host_cr0_valid(vcpu, kvm_read_cr0(vcpu)) ||
+	    !nested_host_cr4_valid(vcpu, kvm_read_cr4(vcpu))) {
+		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
+
 	if ((vmx->msr_ia32_feature_control & VMXON_NEEDED_FEATURES)
 			!= VMXON_NEEDED_FEATURES) {
 		kvm_inject_gp(vcpu, 0);
@@ -6808,7 +6830,8 @@ void nested_vmx_setup_ctls_msrs(struct vmcs_config *vmcs_conf, u32 ept_caps)
 		SECONDARY_EXEC_ENABLE_INVPCID |
 		SECONDARY_EXEC_RDSEED_EXITING |
 		SECONDARY_EXEC_XSAVES |
-		SECONDARY_EXEC_TSC_SCALING;
+		SECONDARY_EXEC_TSC_SCALING |
+		SECONDARY_EXEC_ENABLE_USR_WAIT_PAUSE;
 
 	/*
 	 * We can emulate "VMCS shadowing," even if the hardware
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 8f95c7c01433..b12da2a6dec9 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -182,8 +182,10 @@ static int __handle_encls_ecreate(struct kvm_vcpu *vcpu,
 	/* Enforce CPUID restriction on max enclave size. */
 	max_size_log2 = (attributes & SGX_ATTR_MODE64BIT) ? sgx_12_0->edx >> 8 :
 							    sgx_12_0->edx;
-	if (size >= BIT_ULL(max_size_log2))
+	if (size >= BIT_ULL(max_size_log2)) {
 		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
 
 	/*
 	 * sgx_virt_ecreate() returns:
diff --git a/arch/xtensa/kernel/xtensa_ksyms.c b/arch/xtensa/kernel/xtensa_ksyms.c
index b0bc8897c924..2a31b1ab0c9f 100644
--- a/arch/xtensa/kernel/xtensa_ksyms.c
+++ b/arch/xtensa/kernel/xtensa_ksyms.c
@@ -62,6 +62,7 @@ extern int __modsi3(int, int);
 extern int __mulsi3(int, int);
 extern unsigned int __udivsi3(unsigned int, unsigned int);
 extern unsigned int __umodsi3(unsigned int, unsigned int);
+extern unsigned long long __umulsidi3(unsigned int, unsigned int);
 
 EXPORT_SYMBOL(__ashldi3);
 EXPORT_SYMBOL(__ashrdi3);
@@ -71,6 +72,7 @@ EXPORT_SYMBOL(__modsi3);
 EXPORT_SYMBOL(__mulsi3);
 EXPORT_SYMBOL(__udivsi3);
 EXPORT_SYMBOL(__umodsi3);
+EXPORT_SYMBOL(__umulsidi3);
 
 unsigned int __sync_fetch_and_and_4(volatile void *p, unsigned int v)
 {
diff --git a/arch/xtensa/lib/Makefile b/arch/xtensa/lib/Makefile
index d4e9c397e3fd..7ecef0519a27 100644
--- a/arch/xtensa/lib/Makefile
+++ b/arch/xtensa/lib/Makefile
@@ -5,7 +5,7 @@
 
 lib-y	+= memcopy.o memset.o checksum.o \
 	   ashldi3.o ashrdi3.o lshrdi3.o \
-	   divsi3.o udivsi3.o modsi3.o umodsi3.o mulsi3.o \
+	   divsi3.o udivsi3.o modsi3.o umodsi3.o mulsi3.o umulsidi3.o \
 	   usercopy.o strncpy_user.o strnlen_user.o
 lib-$(CONFIG_PCI) += pci-auto.o
 lib-$(CONFIG_KCSAN) += kcsan-stubs.o
diff --git a/arch/xtensa/lib/umulsidi3.S b/arch/xtensa/lib/umulsidi3.S
new file mode 100644
index 000000000000..136081647942
--- /dev/null
+++ b/arch/xtensa/lib/umulsidi3.S
@@ -0,0 +1,230 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later WITH GCC-exception-2.0 */
+#include <linux/linkage.h>
+#include <asm/asmmacro.h>
+#include <asm/core.h>
+
+#if !XCHAL_HAVE_MUL16 && !XCHAL_HAVE_MUL32 && !XCHAL_HAVE_MAC16
+#define XCHAL_NO_MUL 1
+#endif
+
+ENTRY(__umulsidi3)
+
+#ifdef __XTENSA_CALL0_ABI__
+	abi_entry(32)
+	s32i	a12, sp, 16
+	s32i	a13, sp, 20
+	s32i	a14, sp, 24
+	s32i	a15, sp, 28
+#elif XCHAL_NO_MUL
+	/* This is not really a leaf function; allocate enough stack space
+	   to allow CALL12s to a helper function.  */
+	abi_entry(32)
+#else
+	abi_entry_default
+#endif
+
+#ifdef __XTENSA_EB__
+#define wh a2
+#define wl a3
+#else
+#define wh a3
+#define wl a2
+#endif /* __XTENSA_EB__ */
+
+	/* This code is taken from the mulsf3 routine in ieee754-sf.S.
+	   See more comments there.  */
+
+#if XCHAL_HAVE_MUL32_HIGH
+	mull	a6, a2, a3
+	muluh	wh, a2, a3
+	mov	wl, a6
+
+#else /* ! MUL32_HIGH */
+
+#if defined(__XTENSA_CALL0_ABI__) && XCHAL_NO_MUL
+	/* a0 and a8 will be clobbered by calling the multiply function
+	   but a8 is not used here and need not be saved.  */
+	s32i	a0, sp, 0
+#endif
+
+#if XCHAL_HAVE_MUL16 || XCHAL_HAVE_MUL32
+
+#define a2h a4
+#define a3h a5
+
+	/* Get the high halves of the inputs into registers.  */
+	srli	a2h, a2, 16
+	srli	a3h, a3, 16
+
+#define a2l a2
+#define a3l a3
+
+#if XCHAL_HAVE_MUL32 && !XCHAL_HAVE_MUL16
+	/* Clear the high halves of the inputs.  This does not matter
+	   for MUL16 because the high bits are ignored.  */
+	extui	a2, a2, 0, 16
+	extui	a3, a3, 0, 16
+#endif
+#endif /* MUL16 || MUL32 */
+
+
+#if XCHAL_HAVE_MUL16
+
+#define do_mul(dst, xreg, xhalf, yreg, yhalf) \
+	mul16u	dst, xreg ## xhalf, yreg ## yhalf
+
+#elif XCHAL_HAVE_MUL32
+
+#define do_mul(dst, xreg, xhalf, yreg, yhalf) \
+	mull	dst, xreg ## xhalf, yreg ## yhalf
+
+#elif XCHAL_HAVE_MAC16
+
+/* The preprocessor insists on inserting a space when concatenating after
+   a period in the definition of do_mul below.  These macros are a workaround
+   using underscores instead of periods when doing the concatenation.  */
+#define umul_aa_ll umul.aa.ll
+#define umul_aa_lh umul.aa.lh
+#define umul_aa_hl umul.aa.hl
+#define umul_aa_hh umul.aa.hh
+
+#define do_mul(dst, xreg, xhalf, yreg, yhalf) \
+	umul_aa_ ## xhalf ## yhalf	xreg, yreg; \
+	rsr	dst, ACCLO
+
+#else /* no multiply hardware */
+
+#define set_arg_l(dst, src) \
+	extui	dst, src, 0, 16
+#define set_arg_h(dst, src) \
+	srli	dst, src, 16
+
+#ifdef __XTENSA_CALL0_ABI__
+#define do_mul(dst, xreg, xhalf, yreg, yhalf) \
+	set_arg_ ## xhalf (a13, xreg); \
+	set_arg_ ## yhalf (a14, yreg); \
+	call0	.Lmul_mulsi3; \
+	mov	dst, a12
+#else
+#define do_mul(dst, xreg, xhalf, yreg, yhalf) \
+	set_arg_ ## xhalf (a14, xreg); \
+	set_arg_ ## yhalf (a15, yreg); \
+	call12	.Lmul_mulsi3; \
+	mov	dst, a14
+#endif /* __XTENSA_CALL0_ABI__ */
+
+#endif /* no multiply hardware */
+
+	/* Add pp1 and pp2 into a6 with carry-out in a9.  */
+	do_mul(a6, a2, l, a3, h)	/* pp 1 */
+	do_mul(a11, a2, h, a3, l)	/* pp 2 */
+	movi	a9, 0
+	add	a6, a6, a11
+	bgeu	a6, a11, 1f
+	addi	a9, a9, 1
+1:
+	/* Shift the high half of a9/a6 into position in a9.  Note that
+	   this value can be safely incremented without any carry-outs.  */
+	ssai	16
+	src	a9, a9, a6
+
+	/* Compute the low word into a6.  */
+	do_mul(a11, a2, l, a3, l)	/* pp 0 */
+	sll	a6, a6
+	add	a6, a6, a11
+	bgeu	a6, a11, 1f
+	addi	a9, a9, 1
+1:
+	/* Compute the high word into wh.  */
+	do_mul(wh, a2, h, a3, h)	/* pp 3 */
+	add	wh, wh, a9
+	mov	wl, a6
+
+#endif /* !MUL32_HIGH */
+
+#if defined(__XTENSA_CALL0_ABI__) && XCHAL_NO_MUL
+	/* Restore the original return address.  */
+	l32i	a0, sp, 0
+#endif
+#ifdef __XTENSA_CALL0_ABI__
+	l32i	a12, sp, 16
+	l32i	a13, sp, 20
+	l32i	a14, sp, 24
+	l32i	a15, sp, 28
+	abi_ret(32)
+#else
+	abi_ret_default
+#endif
+
+#if XCHAL_NO_MUL
+
+	.macro	do_addx2 dst, as, at, tmp
+#if XCHAL_HAVE_ADDX
+	addx2	\dst, \as, \at
+#else
+	slli	\tmp, \as, 1
+	add	\dst, \tmp, \at
+#endif
+	.endm
+
+	.macro	do_addx4 dst, as, at, tmp
+#if XCHAL_HAVE_ADDX
+	addx4	\dst, \as, \at
+#else
+	slli	\tmp, \as, 2
+	add	\dst, \tmp, \at
+#endif
+	.endm
+
+	.macro	do_addx8 dst, as, at, tmp
+#if XCHAL_HAVE_ADDX
+	addx8	\dst, \as, \at
+#else
+	slli	\tmp, \as, 3
+	add	\dst, \tmp, \at
+#endif
+	.endm
+
+	/* For Xtensa processors with no multiply hardware, this simplified
+	   version of _mulsi3 is used for multiplying 16-bit chunks of
+	   the floating-point mantissas.  When using CALL0, this function
+	   uses a custom ABI: the inputs are passed in a13 and a14, the
+	   result is returned in a12, and a8 and a15 are clobbered.  */
+	.align	4
+.Lmul_mulsi3:
+	abi_entry_default
+
+	.macro mul_mulsi3_body dst, src1, src2, tmp1, tmp2
+	movi	\dst, 0
+1:	add	\tmp1, \src2, \dst
+	extui	\tmp2, \src1, 0, 1
+	movnez	\dst, \tmp1, \tmp2
+
+	do_addx2 \tmp1, \src2, \dst, \tmp1
+	extui	\tmp2, \src1, 1, 1
+	movnez	\dst, \tmp1, \tmp2
+
+	do_addx4 \tmp1, \src2, \dst, \tmp1
+	extui	\tmp2, \src1, 2, 1
+	movnez	\dst, \tmp1, \tmp2
+
+	do_addx8 \tmp1, \src2, \dst, \tmp1
+	extui	\tmp2, \src1, 3, 1
+	movnez	\dst, \tmp1, \tmp2
+
+	srli	\src1, \src1, 4
+	slli	\src2, \src2, 4
+	bnez	\src1, 1b
+	.endm
+
+#ifdef __XTENSA_CALL0_ABI__
+	mul_mulsi3_body a12, a13, a14, a15, a8
+#else
+	/* The result will be written into a2, so save that argument in a4.  */
+	mov	a4, a2
+	mul_mulsi3_body a2, a4, a3, a5, a6
+#endif
+	abi_ret_default
+#endif /* XCHAL_NO_MUL */
+
+ENDPROC(__umulsidi3)
diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 5639921dfa92..6672f1bce379 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -130,6 +130,20 @@ static u8 dd_rq_ioclass(struct request *rq)
 	return IOPRIO_PRIO_CLASS(req_get_ioprio(rq));
 }
 
+/*
+ * get the request before `rq' in sector-sorted order
+ */
+static inline struct request *
+deadline_earlier_request(struct request *rq)
+{
+	struct rb_node *node = rb_prev(&rq->rb_node);
+
+	if (node)
+		return rb_entry_rq(node);
+
+	return NULL;
+}
+
 /*
  * get the request after `rq' in sector-sorted order
  */
@@ -277,6 +291,39 @@ static inline int deadline_check_fifo(struct dd_per_prio *per_prio,
 	return 0;
 }
 
+/*
+ * Check if rq has a sequential request preceding it.
+ */
+static bool deadline_is_seq_writes(struct deadline_data *dd, struct request *rq)
+{
+	struct request *prev = deadline_earlier_request(rq);
+
+	if (!prev)
+		return false;
+
+	return blk_rq_pos(prev) + blk_rq_sectors(prev) == blk_rq_pos(rq);
+}
+
+/*
+ * Skip all write requests that are sequential from @rq, even if we cross
+ * a zone boundary.
+ */
+static struct request *deadline_skip_seq_writes(struct deadline_data *dd,
+						struct request *rq)
+{
+	sector_t pos = blk_rq_pos(rq);
+	sector_t skipped_sectors = 0;
+
+	while (rq) {
+		if (blk_rq_pos(rq) != pos + skipped_sectors)
+			break;
+		skipped_sectors += blk_rq_sectors(rq);
+		rq = deadline_latter_request(rq);
+	}
+
+	return rq;
+}
+
 /*
  * For the specified data direction, return the next request to
  * dispatch using arrival ordered lists.
@@ -297,11 +344,16 @@ deadline_fifo_request(struct deadline_data *dd, struct dd_per_prio *per_prio,
 
 	/*
 	 * Look for a write request that can be dispatched, that is one with
-	 * an unlocked target zone.
+	 * an unlocked target zone. For some HDDs, breaking a sequential
+	 * write stream can lead to lower throughput, so make sure to preserve
+	 * sequential write streams, even if that stream crosses into the next
+	 * zones and these zones are unlocked.
 	 */
 	spin_lock_irqsave(&dd->zone_lock, flags);
 	list_for_each_entry(rq, &per_prio->fifo_list[DD_WRITE], queuelist) {
-		if (blk_req_can_dispatch_to_zone(rq))
+		if (blk_req_can_dispatch_to_zone(rq) &&
+		    (blk_queue_nonrot(rq->q) ||
+		     !deadline_is_seq_writes(dd, rq)))
 			goto out;
 	}
 	rq = NULL;
@@ -331,13 +383,19 @@ deadline_next_request(struct deadline_data *dd, struct dd_per_prio *per_prio,
 
 	/*
 	 * Look for a write request that can be dispatched, that is one with
-	 * an unlocked target zone.
+	 * an unlocked target zone. For some HDDs, breaking a sequential
+	 * write stream can lead to lower throughput, so make sure to preserve
+	 * sequential write streams, even if that stream crosses into the next
+	 * zones and these zones are unlocked.
 	 */
 	spin_lock_irqsave(&dd->zone_lock, flags);
 	while (rq) {
 		if (blk_req_can_dispatch_to_zone(rq))
 			break;
-		rq = deadline_latter_request(rq);
+		if (blk_queue_nonrot(rq->q))
+			rq = deadline_latter_request(rq);
+		else
+			rq = deadline_skip_seq_writes(dd, rq);
 	}
 	spin_unlock_irqrestore(&dd->zone_lock, flags);
 
@@ -789,6 +847,18 @@ static void dd_prepare_request(struct request *rq)
 	rq->elv.priv[0] = NULL;
 }
 
+static bool dd_has_write_work(struct blk_mq_hw_ctx *hctx)
+{
+	struct deadline_data *dd = hctx->queue->elevator->elevator_data;
+	enum dd_prio p;
+
+	for (p = 0; p <= DD_PRIO_MAX; p++)
+		if (!list_empty_careful(&dd->per_prio[p].fifo_list[DD_WRITE]))
+			return true;
+
+	return false;
+}
+
 /*
  * Callback from inside blk_mq_free_request().
  *
@@ -828,9 +898,10 @@ static void dd_finish_request(struct request *rq)
 
 		spin_lock_irqsave(&dd->zone_lock, flags);
 		blk_req_zone_write_unlock(rq);
-		if (!list_empty(&per_prio->fifo_list[DD_WRITE]))
-			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
 		spin_unlock_irqrestore(&dd->zone_lock, flags);
+
+		if (dd_has_write_work(rq->mq_hctx))
+			blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
 	}
 }
 
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 13f10fbcd7f0..76b7e7f8894e 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -734,6 +734,16 @@ static bool google_cros_ec_present(void)
 	return acpi_dev_found("GOOG0004") || acpi_dev_found("GOOG000C");
 }
 
+/*
+ * Windows 8 and newer no longer use the ACPI video interface, so it often
+ * does not work. So on win8+ systems prefer native brightness control.
+ * Chromebooks should always prefer native backlight control.
+ */
+static bool prefer_native_over_acpi_video(void)
+{
+	return acpi_osi_is_win8() || google_cros_ec_present();
+}
+
 /*
  * Determine which type of backlight interface to use on this system,
  * First check cmdline, then dmi quirks, then do autodetect.
@@ -779,28 +789,16 @@ static enum acpi_backlight_type __acpi_video_get_backlight_type(bool native)
 	if (apple_gmux_backlight_present())
 		return acpi_backlight_apple_gmux;
 
-	/* Chromebooks should always prefer native backlight control. */
-	if (google_cros_ec_present() && native_available)
-		return acpi_backlight_native;
+	/* Use ACPI video if available, except when native should be preferred. */
+	if ((video_caps & ACPI_VIDEO_BACKLIGHT) &&
+	     !(native_available && prefer_native_over_acpi_video()))
+		return acpi_backlight_video;
 
-	/* On systems with ACPI video use either native or ACPI video. */
-	if (video_caps & ACPI_VIDEO_BACKLIGHT) {
-		/*
-		 * Windows 8 and newer no longer use the ACPI video interface,
-		 * so it often does not work. If the ACPI tables are written
-		 * for win8 and native brightness ctl is available, use that.
-		 *
-		 * The native check deliberately is inside the if acpi-video
-		 * block on older devices without acpi-video support native
-		 * is usually not the best choice.
-		 */
-		if (acpi_osi_is_win8() && native_available)
-			return acpi_backlight_native;
-		else
-			return acpi_backlight_video;
-	}
+	/* Use native if available */
+	if (native_available)
+		return acpi_backlight_native;
 
-	/* No ACPI video (old hw), use vendor specific fw methods. */
+	/* No ACPI video/native (old hw), use vendor specific fw methods. */
 	return acpi_backlight_vendor;
 }
 
@@ -812,18 +810,6 @@ EXPORT_SYMBOL(acpi_video_get_backlight_type);
 
 bool acpi_video_backlight_use_native(void)
 {
-	/*
-	 * Call __acpi_video_get_backlight_type() to let it know that
-	 * a native backlight is available.
-	 */
-	__acpi_video_get_backlight_type(true);
-
-	/*
-	 * For now just always return true. There is a whole bunch of laptop
-	 * models where (video_caps & ACPI_VIDEO_BACKLIGHT) is false causing
-	 * __acpi_video_get_backlight_type() to return vendor, while these
-	 * models only have a native backlight control.
-	 */
-	return true;
+	return __acpi_video_get_backlight_type(true) == acpi_backlight_native;
 }
 EXPORT_SYMBOL(acpi_video_backlight_use_native);
diff --git a/drivers/ata/ahci.h b/drivers/ata/ahci.h
index 7add8e79912b..ff8e6ae1c636 100644
--- a/drivers/ata/ahci.h
+++ b/drivers/ata/ahci.h
@@ -24,6 +24,7 @@
 #include <linux/libata.h>
 #include <linux/phy/phy.h>
 #include <linux/regulator/consumer.h>
+#include <linux/bits.h>
 
 /* Enclosure Management Control */
 #define EM_CTRL_MSG_TYPE              0x000f0000
@@ -53,12 +54,12 @@ enum {
 	AHCI_PORT_PRIV_FBS_DMA_SZ	= AHCI_CMD_SLOT_SZ +
 					  AHCI_CMD_TBL_AR_SZ +
 					  (AHCI_RX_FIS_SZ * 16),
-	AHCI_IRQ_ON_SG		= (1 << 31),
-	AHCI_CMD_ATAPI		= (1 << 5),
-	AHCI_CMD_WRITE		= (1 << 6),
-	AHCI_CMD_PREFETCH	= (1 << 7),
-	AHCI_CMD_RESET		= (1 << 8),
-	AHCI_CMD_CLR_BUSY	= (1 << 10),
+	AHCI_IRQ_ON_SG		= BIT(31),
+	AHCI_CMD_ATAPI		= BIT(5),
+	AHCI_CMD_WRITE		= BIT(6),
+	AHCI_CMD_PREFETCH	= BIT(7),
+	AHCI_CMD_RESET		= BIT(8),
+	AHCI_CMD_CLR_BUSY	= BIT(10),
 
 	RX_FIS_PIO_SETUP	= 0x20,	/* offset of PIO Setup FIS data */
 	RX_FIS_D2H_REG		= 0x40,	/* offset of D2H Register FIS data */
@@ -76,37 +77,37 @@ enum {
 	HOST_CAP2		= 0x24, /* host capabilities, extended */
 
 	/* HOST_CTL bits */
-	HOST_RESET		= (1 << 0),  /* reset controller; self-clear */
-	HOST_IRQ_EN		= (1 << 1),  /* global IRQ enable */
-	HOST_MRSM		= (1 << 2),  /* MSI Revert to Single Message */
-	HOST_AHCI_EN		= (1 << 31), /* AHCI enabled */
+	HOST_RESET		= BIT(0),  /* reset controller; self-clear */
+	HOST_IRQ_EN		= BIT(1),  /* global IRQ enable */
+	HOST_MRSM		= BIT(2),  /* MSI Revert to Single Message */
+	HOST_AHCI_EN		= BIT(31), /* AHCI enabled */
 
 	/* HOST_CAP bits */
-	HOST_CAP_SXS		= (1 << 5),  /* Supports External SATA */
-	HOST_CAP_EMS		= (1 << 6),  /* Enclosure Management support */
-	HOST_CAP_CCC		= (1 << 7),  /* Command Completion Coalescing */
-	HOST_CAP_PART		= (1 << 13), /* Partial state capable */
-	HOST_CAP_SSC		= (1 << 14), /* Slumber state capable */
-	HOST_CAP_PIO_MULTI	= (1 << 15), /* PIO multiple DRQ support */
-	HOST_CAP_FBS		= (1 << 16), /* FIS-based switching support */
-	HOST_CAP_PMP		= (1 << 17), /* Port Multiplier support */
-	HOST_CAP_ONLY		= (1 << 18), /* Supports AHCI mode only */
-	HOST_CAP_CLO		= (1 << 24), /* Command List Override support */
-	HOST_CAP_LED		= (1 << 25), /* Supports activity LED */
-	HOST_CAP_ALPM		= (1 << 26), /* Aggressive Link PM support */
-	HOST_CAP_SSS		= (1 << 27), /* Staggered Spin-up */
-	HOST_CAP_MPS		= (1 << 28), /* Mechanical presence switch */
-	HOST_CAP_SNTF		= (1 << 29), /* SNotification register */
-	HOST_CAP_NCQ		= (1 << 30), /* Native Command Queueing */
-	HOST_CAP_64		= (1 << 31), /* PCI DAC (64-bit DMA) support */
+	HOST_CAP_SXS		= BIT(5),  /* Supports External SATA */
+	HOST_CAP_EMS		= BIT(6),  /* Enclosure Management support */
+	HOST_CAP_CCC		= BIT(7),  /* Command Completion Coalescing */
+	HOST_CAP_PART		= BIT(13), /* Partial state capable */
+	HOST_CAP_SSC		= BIT(14), /* Slumber state capable */
+	HOST_CAP_PIO_MULTI	= BIT(15), /* PIO multiple DRQ support */
+	HOST_CAP_FBS		= BIT(16), /* FIS-based switching support */
+	HOST_CAP_PMP		= BIT(17), /* Port Multiplier support */
+	HOST_CAP_ONLY		= BIT(18), /* Supports AHCI mode only */
+	HOST_CAP_CLO		= BIT(24), /* Command List Override support */
+	HOST_CAP_LED		= BIT(25), /* Supports activity LED */
+	HOST_CAP_ALPM		= BIT(26), /* Aggressive Link PM support */
+	HOST_CAP_SSS		= BIT(27), /* Staggered Spin-up */
+	HOST_CAP_MPS		= BIT(28), /* Mechanical presence switch */
+	HOST_CAP_SNTF		= BIT(29), /* SNotification register */
+	HOST_CAP_NCQ		= BIT(30), /* Native Command Queueing */
+	HOST_CAP_64		= BIT(31), /* PCI DAC (64-bit DMA) support */
 
 	/* HOST_CAP2 bits */
-	HOST_CAP2_BOH		= (1 << 0),  /* BIOS/OS handoff supported */
-	HOST_CAP2_NVMHCI	= (1 << 1),  /* NVMHCI supported */
-	HOST_CAP2_APST		= (1 << 2),  /* Automatic partial to slumber */
-	HOST_CAP2_SDS		= (1 << 3),  /* Support device sleep */
-	HOST_CAP2_SADM		= (1 << 4),  /* Support aggressive DevSlp */
-	HOST_CAP2_DESO		= (1 << 5),  /* DevSlp from slumber only */
+	HOST_CAP2_BOH		= BIT(0),  /* BIOS/OS handoff supported */
+	HOST_CAP2_NVMHCI	= BIT(1),  /* NVMHCI supported */
+	HOST_CAP2_APST		= BIT(2),  /* Automatic partial to slumber */
+	HOST_CAP2_SDS		= BIT(3),  /* Support device sleep */
+	HOST_CAP2_SADM		= BIT(4),  /* Support aggressive DevSlp */
+	HOST_CAP2_DESO		= BIT(5),  /* DevSlp from slumber only */
 
 	/* registers for each SATA port */
 	PORT_LST_ADDR		= 0x00, /* command list DMA addr */
@@ -128,24 +129,24 @@ enum {
 	PORT_DEVSLP		= 0x44, /* device sleep */
 
 	/* PORT_IRQ_{STAT,MASK} bits */
-	PORT_IRQ_COLD_PRES	= (1 << 31), /* cold presence detect */
-	PORT_IRQ_TF_ERR		= (1 << 30), /* task file error */
-	PORT_IRQ_HBUS_ERR	= (1 << 29), /* host bus fatal error */
-	PORT_IRQ_HBUS_DATA_ERR	= (1 << 28), /* host bus data error */
-	PORT_IRQ_IF_ERR		= (1 << 27), /* interface fatal error */
-	PORT_IRQ_IF_NONFATAL	= (1 << 26), /* interface non-fatal error */
-	PORT_IRQ_OVERFLOW	= (1 << 24), /* xfer exhausted available S/G */
-	PORT_IRQ_BAD_PMP	= (1 << 23), /* incorrect port multiplier */
-
-	PORT_IRQ_PHYRDY		= (1 << 22), /* PhyRdy changed */
-	PORT_IRQ_DMPS		= (1 << 7), /* mechanical presence status */
-	PORT_IRQ_CONNECT	= (1 << 6), /* port connect change status */
-	PORT_IRQ_SG_DONE	= (1 << 5), /* descriptor processed */
-	PORT_IRQ_UNK_FIS	= (1 << 4), /* unknown FIS rx'd */
-	PORT_IRQ_SDB_FIS	= (1 << 3), /* Set Device Bits FIS rx'd */
-	PORT_IRQ_DMAS_FIS	= (1 << 2), /* DMA Setup FIS rx'd */
-	PORT_IRQ_PIOS_FIS	= (1 << 1), /* PIO Setup FIS rx'd */
-	PORT_IRQ_D2H_REG_FIS	= (1 << 0), /* D2H Register FIS rx'd */
+	PORT_IRQ_COLD_PRES	= BIT(31), /* cold presence detect */
+	PORT_IRQ_TF_ERR		= BIT(30), /* task file error */
+	PORT_IRQ_HBUS_ERR	= BIT(29), /* host bus fatal error */
+	PORT_IRQ_HBUS_DATA_ERR	= BIT(28), /* host bus data error */
+	PORT_IRQ_IF_ERR		= BIT(27), /* interface fatal error */
+	PORT_IRQ_IF_NONFATAL	= BIT(26), /* interface non-fatal error */
+	PORT_IRQ_OVERFLOW	= BIT(24), /* xfer exhausted available S/G */
+	PORT_IRQ_BAD_PMP	= BIT(23), /* incorrect port multiplier */
+
+	PORT_IRQ_PHYRDY		= BIT(22), /* PhyRdy changed */
+	PORT_IRQ_DMPS		= BIT(7),  /* mechanical presence status */
+	PORT_IRQ_CONNECT	= BIT(6),  /* port connect change status */
+	PORT_IRQ_SG_DONE	= BIT(5),  /* descriptor processed */
+	PORT_IRQ_UNK_FIS	= BIT(4),  /* unknown FIS rx'd */
+	PORT_IRQ_SDB_FIS	= BIT(3),  /* Set Device Bits FIS rx'd */
+	PORT_IRQ_DMAS_FIS	= BIT(2),  /* DMA Setup FIS rx'd */
+	PORT_IRQ_PIOS_FIS	= BIT(1),  /* PIO Setup FIS rx'd */
+	PORT_IRQ_D2H_REG_FIS	= BIT(0),  /* D2H Register FIS rx'd */
 
 	PORT_IRQ_FREEZE		= PORT_IRQ_HBUS_ERR |
 				  PORT_IRQ_IF_ERR |
@@ -161,27 +162,27 @@ enum {
 				  PORT_IRQ_PIOS_FIS | PORT_IRQ_D2H_REG_FIS,
 
 	/* PORT_CMD bits */
-	PORT_CMD_ASP		= (1 << 27), /* Aggressive Slumber/Partial */
-	PORT_CMD_ALPE		= (1 << 26), /* Aggressive Link PM enable */
-	PORT_CMD_ATAPI		= (1 << 24), /* Device is ATAPI */
-	PORT_CMD_FBSCP		= (1 << 22), /* FBS Capable Port */
-	PORT_CMD_ESP		= (1 << 21), /* External Sata Port */
-	PORT_CMD_CPD		= (1 << 20), /* Cold Presence Detection */
-	PORT_CMD_MPSP		= (1 << 19), /* Mechanical Presence Switch */
-	PORT_CMD_HPCP		= (1 << 18), /* HotPlug Capable Port */
-	PORT_CMD_PMP		= (1 << 17), /* PMP attached */
-	PORT_CMD_LIST_ON	= (1 << 15), /* cmd list DMA engine running */
-	PORT_CMD_FIS_ON		= (1 << 14), /* FIS DMA engine running */
-	PORT_CMD_FIS_RX		= (1 << 4), /* Enable FIS receive DMA engine */
-	PORT_CMD_CLO		= (1 << 3), /* Command list override */
-	PORT_CMD_POWER_ON	= (1 << 2), /* Power up device */
-	PORT_CMD_SPIN_UP	= (1 << 1), /* Spin up device */
-	PORT_CMD_START		= (1 << 0), /* Enable port DMA engine */
-
-	PORT_CMD_ICC_MASK	= (0xf << 28), /* i/f ICC state mask */
-	PORT_CMD_ICC_ACTIVE	= (0x1 << 28), /* Put i/f in active state */
-	PORT_CMD_ICC_PARTIAL	= (0x2 << 28), /* Put i/f in partial state */
-	PORT_CMD_ICC_SLUMBER	= (0x6 << 28), /* Put i/f in slumber state */
+	PORT_CMD_ASP		= BIT(27), /* Aggressive Slumber/Partial */
+	PORT_CMD_ALPE		= BIT(26), /* Aggressive Link PM enable */
+	PORT_CMD_ATAPI		= BIT(24), /* Device is ATAPI */
+	PORT_CMD_FBSCP		= BIT(22), /* FBS Capable Port */
+	PORT_CMD_ESP		= BIT(21), /* External Sata Port */
+	PORT_CMD_CPD		= BIT(20), /* Cold Presence Detection */
+	PORT_CMD_MPSP		= BIT(19), /* Mechanical Presence Switch */
+	PORT_CMD_HPCP		= BIT(18), /* HotPlug Capable Port */
+	PORT_CMD_PMP		= BIT(17), /* PMP attached */
+	PORT_CMD_LIST_ON	= BIT(15), /* cmd list DMA engine running */
+	PORT_CMD_FIS_ON		= BIT(14), /* FIS DMA engine running */
+	PORT_CMD_FIS_RX		= BIT(4),  /* Enable FIS receive DMA engine */
+	PORT_CMD_CLO		= BIT(3),  /* Command list override */
+	PORT_CMD_POWER_ON	= BIT(2),  /* Power up device */
+	PORT_CMD_SPIN_UP	= BIT(1),  /* Spin up device */
+	PORT_CMD_START		= BIT(0),  /* Enable port DMA engine */
+
+	PORT_CMD_ICC_MASK	= (0xfu << 28), /* i/f ICC state mask */
+	PORT_CMD_ICC_ACTIVE	= (0x1u << 28), /* Put i/f in active state */
+	PORT_CMD_ICC_PARTIAL	= (0x2u << 28), /* Put i/f in partial state */
+	PORT_CMD_ICC_SLUMBER	= (0x6u << 28), /* Put i/f in slumber state */
 
 	/* PORT_CMD capabilities mask */
 	PORT_CMD_CAP		= PORT_CMD_HPCP | PORT_CMD_MPSP |
@@ -192,9 +193,9 @@ enum {
 	PORT_FBS_ADO_OFFSET	= 12, /* FBS active dev optimization offset */
 	PORT_FBS_DEV_OFFSET	= 8,  /* FBS device to issue offset */
 	PORT_FBS_DEV_MASK	= (0xf << PORT_FBS_DEV_OFFSET),  /* FBS.DEV */
-	PORT_FBS_SDE		= (1 << 2), /* FBS single device error */
-	PORT_FBS_DEC		= (1 << 1), /* FBS device error clear */
-	PORT_FBS_EN		= (1 << 0), /* Enable FBS */
+	PORT_FBS_SDE		= BIT(2), /* FBS single device error */
+	PORT_FBS_DEC		= BIT(1), /* FBS device error clear */
+	PORT_FBS_EN		= BIT(0), /* Enable FBS */
 
 	/* PORT_DEVSLP bits */
 	PORT_DEVSLP_DM_OFFSET	= 25,             /* DITO multiplier offset */
@@ -202,50 +203,50 @@ enum {
 	PORT_DEVSLP_DITO_OFFSET	= 15,             /* DITO offset */
 	PORT_DEVSLP_MDAT_OFFSET	= 10,             /* Minimum assertion time */
 	PORT_DEVSLP_DETO_OFFSET	= 2,              /* DevSlp exit timeout */
-	PORT_DEVSLP_DSP		= (1 << 1),       /* DevSlp present */
-	PORT_DEVSLP_ADSE	= (1 << 0),       /* Aggressive DevSlp enable */
+	PORT_DEVSLP_DSP		= BIT(1),         /* DevSlp present */
+	PORT_DEVSLP_ADSE	= BIT(0),         /* Aggressive DevSlp enable */
 
 	/* hpriv->flags bits */
 
 #define AHCI_HFLAGS(flags)		.private_data	= (void *)(flags)
 
-	AHCI_HFLAG_NO_NCQ		= (1 << 0),
-	AHCI_HFLAG_IGN_IRQ_IF_ERR	= (1 << 1), /* ignore IRQ_IF_ERR */
-	AHCI_HFLAG_IGN_SERR_INTERNAL	= (1 << 2), /* ignore SERR_INTERNAL */
-	AHCI_HFLAG_32BIT_ONLY		= (1 << 3), /* force 32bit */
-	AHCI_HFLAG_MV_PATA		= (1 << 4), /* PATA port */
-	AHCI_HFLAG_NO_MSI		= (1 << 5), /* no PCI MSI */
-	AHCI_HFLAG_NO_PMP		= (1 << 6), /* no PMP */
-	AHCI_HFLAG_SECT255		= (1 << 8), /* max 255 sectors */
-	AHCI_HFLAG_YES_NCQ		= (1 << 9), /* force NCQ cap on */
-	AHCI_HFLAG_NO_SUSPEND		= (1 << 10), /* don't suspend */
-	AHCI_HFLAG_SRST_TOUT_IS_OFFLINE	= (1 << 11), /* treat SRST timeout as
-							link offline */
-	AHCI_HFLAG_NO_SNTF		= (1 << 12), /* no sntf */
-	AHCI_HFLAG_NO_FPDMA_AA		= (1 << 13), /* no FPDMA AA */
-	AHCI_HFLAG_YES_FBS		= (1 << 14), /* force FBS cap on */
-	AHCI_HFLAG_DELAY_ENGINE		= (1 << 15), /* do not start engine on
-						        port start (wait until
-						        error-handling stage) */
-	AHCI_HFLAG_NO_DEVSLP		= (1 << 17), /* no device sleep */
-	AHCI_HFLAG_NO_FBS		= (1 << 18), /* no FBS */
+	AHCI_HFLAG_NO_NCQ		= BIT(0),
+	AHCI_HFLAG_IGN_IRQ_IF_ERR	= BIT(1), /* ignore IRQ_IF_ERR */
+	AHCI_HFLAG_IGN_SERR_INTERNAL	= BIT(2), /* ignore SERR_INTERNAL */
+	AHCI_HFLAG_32BIT_ONLY		= BIT(3), /* force 32bit */
+	AHCI_HFLAG_MV_PATA		= BIT(4), /* PATA port */
+	AHCI_HFLAG_NO_MSI		= BIT(5), /* no PCI MSI */
+	AHCI_HFLAG_NO_PMP		= BIT(6), /* no PMP */
+	AHCI_HFLAG_SECT255		= BIT(8), /* max 255 sectors */
+	AHCI_HFLAG_YES_NCQ		= BIT(9), /* force NCQ cap on */
+	AHCI_HFLAG_NO_SUSPEND		= BIT(10), /* don't suspend */
+	AHCI_HFLAG_SRST_TOUT_IS_OFFLINE	= BIT(11), /* treat SRST timeout as
+						      link offline */
+	AHCI_HFLAG_NO_SNTF		= BIT(12), /* no sntf */
+	AHCI_HFLAG_NO_FPDMA_AA		= BIT(13), /* no FPDMA AA */
+	AHCI_HFLAG_YES_FBS		= BIT(14), /* force FBS cap on */
+	AHCI_HFLAG_DELAY_ENGINE		= BIT(15), /* do not start engine on
+						      port start (wait until
+						      error-handling stage) */
+	AHCI_HFLAG_NO_DEVSLP		= BIT(17), /* no device sleep */
+	AHCI_HFLAG_NO_FBS		= BIT(18), /* no FBS */
 
 #ifdef CONFIG_PCI_MSI
-	AHCI_HFLAG_MULTI_MSI		= (1 << 20), /* per-port MSI(-X) */
+	AHCI_HFLAG_MULTI_MSI		= BIT(20), /* per-port MSI(-X) */
 #else
 	/* compile out MSI infrastructure */
 	AHCI_HFLAG_MULTI_MSI		= 0,
 #endif
-	AHCI_HFLAG_WAKE_BEFORE_STOP	= (1 << 22), /* wake before DMA stop */
-	AHCI_HFLAG_YES_ALPM		= (1 << 23), /* force ALPM cap on */
-	AHCI_HFLAG_NO_WRITE_TO_RO	= (1 << 24), /* don't write to read
-							only registers */
-	AHCI_HFLAG_USE_LPM_POLICY	= (1 << 25), /* chipset that should use
-							SATA_MOBILE_LPM_POLICY
-							as default lpm_policy */
-	AHCI_HFLAG_SUSPEND_PHYS		= (1 << 26), /* handle PHYs during
-							suspend/resume */
-	AHCI_HFLAG_NO_SXS		= (1 << 28), /* SXS not supported */
+	AHCI_HFLAG_WAKE_BEFORE_STOP	= BIT(22), /* wake before DMA stop */
+	AHCI_HFLAG_YES_ALPM		= BIT(23), /* force ALPM cap on */
+	AHCI_HFLAG_NO_WRITE_TO_RO	= BIT(24), /* don't write to read
+						      only registers */
+	AHCI_HFLAG_USE_LPM_POLICY	= BIT(25), /* chipset that should use
+						      SATA_MOBILE_LPM_POLICY
+						      as default lpm_policy */
+	AHCI_HFLAG_SUSPEND_PHYS		= BIT(26), /* handle PHYs during
+						      suspend/resume */
+	AHCI_HFLAG_NO_SXS		= BIT(28), /* SXS not supported */
 
 	/* ap->flags bits */
 
@@ -261,22 +262,22 @@ enum {
 	EM_MAX_RETRY			= 5,
 
 	/* em_ctl bits */
-	EM_CTL_RST		= (1 << 9), /* Reset */
-	EM_CTL_TM		= (1 << 8), /* Transmit Message */
-	EM_CTL_MR		= (1 << 0), /* Message Received */
-	EM_CTL_ALHD		= (1 << 26), /* Activity LED */
-	EM_CTL_XMT		= (1 << 25), /* Transmit Only */
-	EM_CTL_SMB		= (1 << 24), /* Single Message Buffer */
-	EM_CTL_SGPIO		= (1 << 19), /* SGPIO messages supported */
-	EM_CTL_SES		= (1 << 18), /* SES-2 messages supported */
-	EM_CTL_SAFTE		= (1 << 17), /* SAF-TE messages supported */
-	EM_CTL_LED		= (1 << 16), /* LED messages supported */
+	EM_CTL_RST		= BIT(9), /* Reset */
+	EM_CTL_TM		= BIT(8), /* Transmit Message */
+	EM_CTL_MR		= BIT(0), /* Message Received */
+	EM_CTL_ALHD		= BIT(26), /* Activity LED */
+	EM_CTL_XMT		= BIT(25), /* Transmit Only */
+	EM_CTL_SMB		= BIT(24), /* Single Message Buffer */
+	EM_CTL_SGPIO		= BIT(19), /* SGPIO messages supported */
+	EM_CTL_SES		= BIT(18), /* SES-2 messages supported */
+	EM_CTL_SAFTE		= BIT(17), /* SAF-TE messages supported */
+	EM_CTL_LED		= BIT(16), /* LED messages supported */
 
 	/* em message type */
-	EM_MSG_TYPE_LED		= (1 << 0), /* LED */
-	EM_MSG_TYPE_SAFTE	= (1 << 1), /* SAF-TE */
-	EM_MSG_TYPE_SES2	= (1 << 2), /* SES-2 */
-	EM_MSG_TYPE_SGPIO	= (1 << 3), /* SGPIO */
+	EM_MSG_TYPE_LED		= BIT(0), /* LED */
+	EM_MSG_TYPE_SAFTE	= BIT(1), /* SAF-TE */
+	EM_MSG_TYPE_SES2	= BIT(2), /* SES-2 */
+	EM_MSG_TYPE_SGPIO	= BIT(3), /* SGPIO */
 };
 
 struct ahci_cmd_hdr {
diff --git a/drivers/base/dd.c b/drivers/base/dd.c
index 3dda62503102..9ae2b5c4fc49 100644
--- a/drivers/base/dd.c
+++ b/drivers/base/dd.c
@@ -1162,7 +1162,11 @@ static int __driver_attach(struct device *dev, void *data)
 		return 0;
 	} else if (ret < 0) {
 		dev_dbg(dev, "Bus failed to match device: %d\n", ret);
-		return ret;
+		/*
+		 * Driver could not match with device, but may match with
+		 * another device on the bus.
+		 */
+		return 0;
 	} /* ret > 0 means positive match */
 
 	if (driver_allows_async_probing(drv)) {
diff --git a/drivers/bus/mhi/host/pm.c b/drivers/bus/mhi/host/pm.c
index 4a42186ff111..083459028a4b 100644
--- a/drivers/bus/mhi/host/pm.c
+++ b/drivers/bus/mhi/host/pm.c
@@ -301,7 +301,8 @@ int mhi_pm_m0_transition(struct mhi_controller *mhi_cntrl)
 		read_lock_irq(&mhi_chan->lock);
 
 		/* Only ring DB if ring is not empty */
-		if (tre_ring->base && tre_ring->wp  != tre_ring->rp)
+		if (tre_ring->base && tre_ring->wp  != tre_ring->rp &&
+		    mhi_chan->ch_state == MHI_CH_STATE_ENABLED)
 			mhi_ring_chan_db(mhi_cntrl, mhi_chan);
 		read_unlock_irq(&mhi_chan->lock);
 	}
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index d5ee52be176d..5d403fb5bd92 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -1330,6 +1330,7 @@ static void _ipmi_destroy_user(struct ipmi_user *user)
 	unsigned long    flags;
 	struct cmd_rcvr  *rcvr;
 	struct cmd_rcvr  *rcvrs = NULL;
+	struct module    *owner;
 
 	if (!acquire_ipmi_user(user, &i)) {
 		/*
@@ -1392,8 +1393,9 @@ static void _ipmi_destroy_user(struct ipmi_user *user)
 		kfree(rcvr);
 	}
 
+	owner = intf->owner;
 	kref_put(&intf->refcount, intf_free);
-	module_put(intf->owner);
+	module_put(owner);
 }
 
 int ipmi_destroy_user(struct ipmi_user *user)
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 6e357ad76f2e..abddd7e43a9a 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2153,6 +2153,20 @@ static int __init init_ipmi_si(void)
 }
 module_init(init_ipmi_si);
 
+static void wait_msg_processed(struct smi_info *smi_info)
+{
+	unsigned long jiffies_now;
+	long time_diff;
+
+	while (smi_info->curr_msg || (smi_info->si_state != SI_NORMAL)) {
+		jiffies_now = jiffies;
+		time_diff = (((long)jiffies_now - (long)smi_info->last_timeout_jiffies)
+		     * SI_USEC_PER_JIFFY);
+		smi_event_handler(smi_info, time_diff);
+		schedule_timeout_uninterruptible(1);
+	}
+}
+
 static void shutdown_smi(void *send_info)
 {
 	struct smi_info *smi_info = send_info;
@@ -2187,16 +2201,13 @@ static void shutdown_smi(void *send_info)
 	 * in the BMC.  Note that timers and CPU interrupts are off,
 	 * so no need for locks.
 	 */
-	while (smi_info->curr_msg || (smi_info->si_state != SI_NORMAL)) {
-		poll(smi_info);
-		schedule_timeout_uninterruptible(1);
-	}
+	wait_msg_processed(smi_info);
+
 	if (smi_info->handlers)
 		disable_si_irq(smi_info);
-	while (smi_info->curr_msg || (smi_info->si_state != SI_NORMAL)) {
-		poll(smi_info);
-		schedule_timeout_uninterruptible(1);
-	}
+
+	wait_msg_processed(smi_info);
+
 	if (smi_info->handlers)
 		smi_info->handlers->cleanup(smi_info->si_sm);
 
diff --git a/drivers/char/random.c b/drivers/char/random.c
index 69754155300e..f5868dddbb61 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -160,6 +160,9 @@ EXPORT_SYMBOL(wait_for_random_bytes);
  *	u8 get_random_u8()
  *	u16 get_random_u16()
  *	u32 get_random_u32()
+ *	u32 get_random_u32_below(u32 ceil)
+ *	u32 get_random_u32_above(u32 floor)
+ *	u32 get_random_u32_inclusive(u32 floor, u32 ceil)
  *	u64 get_random_u64()
  *	unsigned long get_random_long()
  *
@@ -510,6 +513,41 @@ DEFINE_BATCHED_ENTROPY(u16)
 DEFINE_BATCHED_ENTROPY(u32)
 DEFINE_BATCHED_ENTROPY(u64)
 
+u32 __get_random_u32_below(u32 ceil)
+{
+	/*
+	 * This is the slow path for variable ceil. It is still fast, most of
+	 * the time, by doing traditional reciprocal multiplication and
+	 * opportunistically comparing the lower half to ceil itself, before
+	 * falling back to computing a larger bound, and then rejecting samples
+	 * whose lower half would indicate a range indivisible by ceil. The use
+	 * of `-ceil % ceil` is analogous to `2^32 % ceil`, but is computable
+	 * in 32-bits.
+	 */
+	u32 rand = get_random_u32();
+	u64 mult;
+
+	/*
+	 * This function is technically undefined for ceil == 0, and in fact
+	 * for the non-underscored constant version in the header, we build bug
+	 * on that. But for the non-constant case, it's convenient to have that
+	 * evaluate to being a straight call to get_random_u32(), so that
+	 * get_random_u32_inclusive() can work over its whole range without
+	 * undefined behavior.
+	 */
+	if (unlikely(!ceil))
+		return rand;
+
+	mult = (u64)ceil * rand;
+	if (unlikely((u32)mult < ceil)) {
+		u32 bound = -ceil % ceil;
+		while (unlikely((u32)mult < bound))
+			mult = (u64)ceil * get_random_u32();
+	}
+	return mult >> 32;
+}
+EXPORT_SYMBOL(__get_random_u32_below);
+
 #ifdef CONFIG_SMP
 /*
  * This function is called when the CPU is coming up, with entry
diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 69b3d61852ac..7e56a42750ea 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -1207,6 +1207,7 @@ static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
 	if (!zalloc_cpumask_var(&policy->real_cpus, GFP_KERNEL))
 		goto err_free_rcpumask;
 
+	init_completion(&policy->kobj_unregister);
 	ret = kobject_init_and_add(&policy->kobj, &ktype_cpufreq,
 				   cpufreq_global_kobject, "policy%u", cpu);
 	if (ret) {
@@ -1245,7 +1246,6 @@ static struct cpufreq_policy *cpufreq_policy_alloc(unsigned int cpu)
 	init_rwsem(&policy->rwsem);
 	spin_lock_init(&policy->transition_lock);
 	init_waitqueue_head(&policy->transition_wait);
-	init_completion(&policy->kobj_unregister);
 	INIT_WORK(&policy->update, handle_update);
 
 	policy->cpu = cpu;
diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
index c30b5a39c2ac..4a618d80e106 100644
--- a/drivers/crypto/Kconfig
+++ b/drivers/crypto/Kconfig
@@ -790,8 +790,8 @@ config CRYPTO_DEV_CCREE
 	select CRYPTO_ECB
 	select CRYPTO_CTR
 	select CRYPTO_XTS
-	select CRYPTO_SM4
-	select CRYPTO_SM3
+	select CRYPTO_SM4_GENERIC
+	select CRYPTO_SM3_GENERIC
 	help
 	  Say 'Y' to enable a driver for the REE interface of the Arm
 	  TrustZone CryptoCell family of processors. Currently the
diff --git a/drivers/crypto/ccp/sp-pci.c b/drivers/crypto/ccp/sp-pci.c
index 792d6da7f0c0..084d052fddcc 100644
--- a/drivers/crypto/ccp/sp-pci.c
+++ b/drivers/crypto/ccp/sp-pci.c
@@ -381,6 +381,15 @@ static const struct psp_vdata pspv3 = {
 	.inten_reg		= 0x10690,
 	.intsts_reg		= 0x10694,
 };
+
+static const struct psp_vdata pspv4 = {
+	.sev			= &sevv2,
+	.tee			= &teev1,
+	.feature_reg		= 0x109fc,
+	.inten_reg		= 0x10690,
+	.intsts_reg		= 0x10694,
+};
+
 #endif
 
 static const struct sp_dev_vdata dev_vdata[] = {
@@ -426,7 +435,7 @@ static const struct sp_dev_vdata dev_vdata[] = {
 	{	/* 5 */
 		.bar = 2,
 #ifdef CONFIG_CRYPTO_DEV_SP_PSP
-		.psp_vdata = &pspv2,
+		.psp_vdata = &pspv4,
 #endif
 	},
 	{	/* 6 */
diff --git a/drivers/crypto/hisilicon/Kconfig b/drivers/crypto/hisilicon/Kconfig
index 27e1fa912063..743ce4fc3158 100644
--- a/drivers/crypto/hisilicon/Kconfig
+++ b/drivers/crypto/hisilicon/Kconfig
@@ -26,7 +26,7 @@ config CRYPTO_DEV_HISI_SEC2
 	select CRYPTO_SHA1
 	select CRYPTO_SHA256
 	select CRYPTO_SHA512
-	select CRYPTO_SM4
+	select CRYPTO_SM4_GENERIC
 	depends on PCI && PCI_MSI
 	depends on UACCE || UACCE=n
 	depends on ARM64 || (COMPILE_TEST && 64BIT)
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 31e24df18877..20d0dcd50344 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -1229,6 +1229,7 @@ struct n2_hash_tmpl {
 	const u8	*hash_init;
 	u8		hw_op_hashsz;
 	u8		digest_size;
+	u8		statesize;
 	u8		block_size;
 	u8		auth_type;
 	u8		hmac_type;
@@ -1260,6 +1261,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_HMAC_MD5,
 	  .hw_op_hashsz	= MD5_DIGEST_SIZE,
 	  .digest_size	= MD5_DIGEST_SIZE,
+	  .statesize	= sizeof(struct md5_state),
 	  .block_size	= MD5_HMAC_BLOCK_SIZE },
 	{ .name		= "sha1",
 	  .hash_zero	= sha1_zero_message_hash,
@@ -1268,6 +1270,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA1,
 	  .hw_op_hashsz	= SHA1_DIGEST_SIZE,
 	  .digest_size	= SHA1_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha1_state),
 	  .block_size	= SHA1_BLOCK_SIZE },
 	{ .name		= "sha256",
 	  .hash_zero	= sha256_zero_message_hash,
@@ -1276,6 +1279,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_HMAC_SHA256,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA256_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha256_state),
 	  .block_size	= SHA256_BLOCK_SIZE },
 	{ .name		= "sha224",
 	  .hash_zero	= sha224_zero_message_hash,
@@ -1284,6 +1288,7 @@ static const struct n2_hash_tmpl hash_tmpls[] = {
 	  .hmac_type	= AUTH_TYPE_RESERVED,
 	  .hw_op_hashsz	= SHA256_DIGEST_SIZE,
 	  .digest_size	= SHA224_DIGEST_SIZE,
+	  .statesize	= sizeof(struct sha256_state),
 	  .block_size	= SHA224_BLOCK_SIZE },
 };
 #define NUM_HASH_TMPLS ARRAY_SIZE(hash_tmpls)
@@ -1424,6 +1429,7 @@ static int __n2_register_one_ahash(const struct n2_hash_tmpl *tmpl)
 
 	halg = &ahash->halg;
 	halg->digestsize = tmpl->digest_size;
+	halg->statesize = tmpl->statesize;
 
 	base = &halg->base;
 	snprintf(base->cra_name, CRYPTO_MAX_ALG_NAME, "%s", tmpl->name);
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index f9ae5ad284ff..c4f32c32dfd5 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -1226,7 +1226,7 @@ static int cxl_region_attach(struct cxl_region *cxlr,
 		struct cxl_endpoint_decoder *cxled_target;
 		struct cxl_memdev *cxlmd_target;
 
-		cxled_target = p->targets[pos];
+		cxled_target = p->targets[i];
 		if (!cxled_target)
 			continue;
 
@@ -1923,6 +1923,9 @@ static int cxl_region_probe(struct device *dev)
 	 */
 	up_read(&cxl_region_rwsem);
 
+	if (rc)
+		return rc;
+
 	switch (cxlr->mode) {
 	case CXL_DECODER_PMEM:
 		return devm_cxl_add_pmem_region(cxlr);
diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 63347a5ae599..8c5f6f7fca11 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -776,8 +776,7 @@ static void remove_sysfs_files(struct devfreq *devfreq,
  * @dev:	the device to add devfreq feature.
  * @profile:	device-specific profile to run devfreq.
  * @governor_name:	name of the policy to choose frequency.
- * @data:	private data for the governor. The devfreq framework does not
- *		touch this value.
+ * @data:	devfreq driver pass to governors, governor should not change it.
  */
 struct devfreq *devfreq_add_device(struct device *dev,
 				   struct devfreq_dev_profile *profile,
@@ -1011,8 +1010,7 @@ static void devm_devfreq_dev_release(struct device *dev, void *res)
  * @dev:	the device to add devfreq feature.
  * @profile:	device-specific profile to run devfreq.
  * @governor_name:	name of the policy to choose frequency.
- * @data:	private data for the governor. The devfreq framework does not
- *		touch this value.
+ * @data:	 devfreq driver pass to governors, governor should not change it.
  *
  * This function manages automatically the memory of devfreq device using device
  * resource management and simplify the free operation for memory of devfreq
diff --git a/drivers/devfreq/governor_userspace.c b/drivers/devfreq/governor_userspace.c
index ab9db7adb3ad..d69672ccacc4 100644
--- a/drivers/devfreq/governor_userspace.c
+++ b/drivers/devfreq/governor_userspace.c
@@ -21,7 +21,7 @@ struct userspace_data {
 
 static int devfreq_userspace_func(struct devfreq *df, unsigned long *freq)
 {
-	struct userspace_data *data = df->data;
+	struct userspace_data *data = df->governor_data;
 
 	if (data->valid)
 		*freq = data->user_frequency;
@@ -40,7 +40,7 @@ static ssize_t set_freq_store(struct device *dev, struct device_attribute *attr,
 	int err = 0;
 
 	mutex_lock(&devfreq->lock);
-	data = devfreq->data;
+	data = devfreq->governor_data;
 
 	sscanf(buf, "%lu", &wanted);
 	data->user_frequency = wanted;
@@ -60,7 +60,7 @@ static ssize_t set_freq_show(struct device *dev,
 	int err = 0;
 
 	mutex_lock(&devfreq->lock);
-	data = devfreq->data;
+	data = devfreq->governor_data;
 
 	if (data->valid)
 		err = sprintf(buf, "%lu\n", data->user_frequency);
@@ -91,7 +91,7 @@ static int userspace_init(struct devfreq *devfreq)
 		goto out;
 	}
 	data->valid = false;
-	devfreq->data = data;
+	devfreq->governor_data = data;
 
 	err = sysfs_create_group(&devfreq->dev.kobj, &dev_attr_group);
 out:
@@ -107,8 +107,8 @@ static void userspace_exit(struct devfreq *devfreq)
 	if (devfreq->dev.kobj.sd)
 		sysfs_remove_group(&devfreq->dev.kobj, &dev_attr_group);
 
-	kfree(devfreq->data);
-	devfreq->data = NULL;
+	kfree(devfreq->governor_data);
+	devfreq->governor_data = NULL;
 }
 
 static int devfreq_userspace_handler(struct devfreq *devfreq,
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 0a638c97702a..15f63452a9be 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -298,6 +298,14 @@ DEVICE_CHANNEL(ch6_dimm_label, S_IRUGO | S_IWUSR,
 	channel_dimm_label_show, channel_dimm_label_store, 6);
 DEVICE_CHANNEL(ch7_dimm_label, S_IRUGO | S_IWUSR,
 	channel_dimm_label_show, channel_dimm_label_store, 7);
+DEVICE_CHANNEL(ch8_dimm_label, S_IRUGO | S_IWUSR,
+	channel_dimm_label_show, channel_dimm_label_store, 8);
+DEVICE_CHANNEL(ch9_dimm_label, S_IRUGO | S_IWUSR,
+	channel_dimm_label_show, channel_dimm_label_store, 9);
+DEVICE_CHANNEL(ch10_dimm_label, S_IRUGO | S_IWUSR,
+	channel_dimm_label_show, channel_dimm_label_store, 10);
+DEVICE_CHANNEL(ch11_dimm_label, S_IRUGO | S_IWUSR,
+	channel_dimm_label_show, channel_dimm_label_store, 11);
 
 /* Total possible dynamic DIMM Label attribute file table */
 static struct attribute *dynamic_csrow_dimm_attr[] = {
@@ -309,6 +317,10 @@ static struct attribute *dynamic_csrow_dimm_attr[] = {
 	&dev_attr_legacy_ch5_dimm_label.attr.attr,
 	&dev_attr_legacy_ch6_dimm_label.attr.attr,
 	&dev_attr_legacy_ch7_dimm_label.attr.attr,
+	&dev_attr_legacy_ch8_dimm_label.attr.attr,
+	&dev_attr_legacy_ch9_dimm_label.attr.attr,
+	&dev_attr_legacy_ch10_dimm_label.attr.attr,
+	&dev_attr_legacy_ch11_dimm_label.attr.attr,
 	NULL
 };
 
@@ -329,6 +341,14 @@ DEVICE_CHANNEL(ch6_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 6);
 DEVICE_CHANNEL(ch7_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 7);
+DEVICE_CHANNEL(ch8_ce_count, S_IRUGO,
+		   channel_ce_count_show, NULL, 8);
+DEVICE_CHANNEL(ch9_ce_count, S_IRUGO,
+		   channel_ce_count_show, NULL, 9);
+DEVICE_CHANNEL(ch10_ce_count, S_IRUGO,
+		   channel_ce_count_show, NULL, 10);
+DEVICE_CHANNEL(ch11_ce_count, S_IRUGO,
+		   channel_ce_count_show, NULL, 11);
 
 /* Total possible dynamic ce_count attribute file table */
 static struct attribute *dynamic_csrow_ce_count_attr[] = {
@@ -340,6 +360,10 @@ static struct attribute *dynamic_csrow_ce_count_attr[] = {
 	&dev_attr_legacy_ch5_ce_count.attr.attr,
 	&dev_attr_legacy_ch6_ce_count.attr.attr,
 	&dev_attr_legacy_ch7_ce_count.attr.attr,
+	&dev_attr_legacy_ch8_ce_count.attr.attr,
+	&dev_attr_legacy_ch9_ce_count.attr.attr,
+	&dev_attr_legacy_ch10_ce_count.attr.attr,
+	&dev_attr_legacy_ch11_ce_count.attr.attr,
 	NULL
 };
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 913f22d41673..0be85d19a6f3 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3005,14 +3005,15 @@ static int amdgpu_device_ip_suspend_phase2(struct amdgpu_device *adev)
 			continue;
 		}
 
-		/* skip suspend of gfx and psp for S0ix
+		/* skip suspend of gfx/mes and psp for S0ix
 		 * gfx is in gfxoff state, so on resume it will exit gfxoff just
 		 * like at runtime. PSP is also part of the always on hardware
 		 * so no need to suspend it.
 		 */
 		if (adev->in_s0ix &&
 		    (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_PSP ||
-		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GFX))
+		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_GFX ||
+		     adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_MES))
 			continue;
 
 		/* XXX handle errors */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index bf2d50c8c92a..d8dfbb9b735d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2040,6 +2040,15 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
 			 "See modparam exp_hw_support\n");
 		return -ENODEV;
 	}
+	/* differentiate between P10 and P11 asics with the same DID */
+	if (pdev->device == 0x67FF &&
+	    (pdev->revision == 0xE3 ||
+	     pdev->revision == 0xE7 ||
+	     pdev->revision == 0xF3 ||
+	     pdev->revision == 0xF7)) {
+		flags &= ~AMD_ASIC_MASK;
+		flags |= CHIP_POLARIS10;
+	}
 
 	/* Due to hardware bugs, S/G Display on raven requires a 1:1 IOMMU mapping,
 	 * however, SME requires an indirect IOMMU mapping because the encryption
@@ -2109,12 +2118,12 @@ static int amdgpu_pci_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, ddev);
 
-	ret = amdgpu_driver_load_kms(adev, ent->driver_data);
+	ret = amdgpu_driver_load_kms(adev, flags);
 	if (ret)
 		goto err_pci;
 
 retry_init:
-	ret = drm_dev_register(ddev, ent->driver_data);
+	ret = drm_dev_register(ddev, flags);
 	if (ret == -EAGAIN && ++retry <= 3) {
 		DRM_INFO("retry init %d\n", retry);
 		/* Don't request EX mode too frequently which is attacking */
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
index 2e8f6cd7a729..3df13d841e4d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_object.c
@@ -1509,7 +1509,8 @@ u64 amdgpu_bo_gpu_offset_no_check(struct amdgpu_bo *bo)
 uint32_t amdgpu_bo_get_preferred_domain(struct amdgpu_device *adev,
 					    uint32_t domain)
 {
-	if (domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) {
+	if ((domain == (AMDGPU_GEM_DOMAIN_VRAM | AMDGPU_GEM_DOMAIN_GTT)) &&
+	    ((adev->asic_type == CHIP_CARRIZO) || (adev->asic_type == CHIP_STONEY))) {
 		domain = AMDGPU_GEM_DOMAIN_VRAM;
 		if (adev->gmc.real_vram_size <= AMDGPU_SG_THRESHOLD)
 			domain = AMDGPU_GEM_DOMAIN_GTT;
diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
index f141fadd2d86..725876b4f02e 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -1339,7 +1339,8 @@ static int mes_v11_0_late_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
-	if (!amdgpu_in_reset(adev) &&
+	/* it's only intended for use in mes_self_test case, not for s0ix and reset */
+	if (!amdgpu_in_reset(adev) && !adev->in_s0ix &&
 	    (adev->ip_versions[GC_HWIP][0] != IP_VERSION(11, 0, 3)))
 		amdgpu_mes_self_test(adev);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
index 998b5d17b271..0e664d0cc8d5 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_0.c
@@ -319,7 +319,7 @@ static void mmhub_v2_0_init_cache_regs(struct amdgpu_device *adev)
 
 	tmp = mmMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, mmMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, mmMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v2_0_enable_system_domain(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
index 1b027d069ab4..4638ea7c2eec 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v2_3.c
@@ -243,7 +243,7 @@ static void mmhub_v2_3_init_cache_regs(struct amdgpu_device *adev)
 
 	tmp = mmMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, mmMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, mmMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v2_3_enable_system_domain(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c
index a1d26c4d80b8..16cc82215e2e 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0.c
@@ -275,7 +275,7 @@ static void mmhub_v3_0_init_cache_regs(struct amdgpu_device *adev)
 
 	tmp = regMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, regMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, regMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v3_0_enable_system_domain(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
index e8058edc1d10..6bdf2ef0298d 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_1.c
@@ -269,7 +269,7 @@ static void mmhub_v3_0_1_init_cache_regs(struct amdgpu_device *adev)
 
 	tmp = regMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, regMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, regMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v3_0_1_enable_system_domain(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c
index 770be0a8f7ce..45465acaa943 100644
--- a/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c
+++ b/drivers/gpu/drm/amd/amdgpu/mmhub_v3_0_2.c
@@ -268,7 +268,7 @@ static void mmhub_v3_0_2_init_cache_regs(struct amdgpu_device *adev)
 
 	tmp = regMMVM_L2_CNTL5_DEFAULT;
 	tmp = REG_SET_FIELD(tmp, MMVM_L2_CNTL5, L2_CACHE_SMALLK_FRAGMENT_SIZE, 0);
-	WREG32_SOC15(GC, 0, regMMVM_L2_CNTL5, tmp);
+	WREG32_SOC15(MMHUB, 0, regMMVM_L2_CNTL5, tmp);
 }
 
 static void mmhub_v3_0_2_enable_system_domain(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 512c32327eb1..c2c26fbea512 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1512,6 +1512,7 @@ static int amdgpu_dm_init(struct amdgpu_device *adev)
 		case IP_VERSION(3, 0, 1):
 		case IP_VERSION(3, 1, 2):
 		case IP_VERSION(3, 1, 3):
+		case IP_VERSION(3, 1, 4):
 		case IP_VERSION(3, 1, 5):
 		case IP_VERSION(3, 1, 6):
 			init_data.flags.gpu_vm_support = true;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
index b76f0f7e4299..d6b964cf73bd 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/pmfw_if/smu13_driver_if_v13_0_0.h
@@ -522,9 +522,9 @@ typedef enum  {
   TEMP_HOTSPOT_M,
   TEMP_MEM,
   TEMP_VR_GFX,
+  TEMP_VR_SOC,
   TEMP_VR_MEM0,
   TEMP_VR_MEM1,
-  TEMP_VR_SOC,
   TEMP_VR_U,
   TEMP_LIQUID0,
   TEMP_LIQUID1,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
index 865d6358918d..a9122b3b1532 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
+++ b/drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h
@@ -28,6 +28,7 @@
 #define SMU13_DRIVER_IF_VERSION_INV 0xFFFFFFFF
 #define SMU13_DRIVER_IF_VERSION_YELLOW_CARP 0x04
 #define SMU13_DRIVER_IF_VERSION_ALDE 0x08
+#define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_0 0x34
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_4 0x07
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_5 0x04
 #define SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_10 0x32
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
index 89f0f6eb19f3..8e4830a311bd 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -289,6 +289,8 @@ int smu_v13_0_check_fw_version(struct smu_context *smu)
 		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_ALDE;
 		break;
 	case IP_VERSION(13, 0, 0):
+		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_0;
+		break;
 	case IP_VERSION(13, 0, 10):
 		smu->smc_driver_if_version = SMU13_DRIVER_IF_VERSION_SMU_V13_0_0_10;
 		break;
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
index f0121d171630..b8430601304f 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c
@@ -187,6 +187,8 @@ static struct cmn2asic_mapping smu_v13_0_0_feature_mask_map[SMU_FEATURE_COUNT] =
 	FEA_MAP(MEM_TEMP_READ),
 	FEA_MAP(ATHUB_MMHUB_PG),
 	FEA_MAP(SOC_PCC),
+	[SMU_FEATURE_DPM_VCLK_BIT] = {1, FEATURE_MM_DPM_BIT},
+	[SMU_FEATURE_DPM_DCLK_BIT] = {1, FEATURE_MM_DPM_BIT},
 };
 
 static struct cmn2asic_mapping smu_v13_0_0_table_map[SMU_TABLE_COUNT] = {
@@ -517,6 +519,23 @@ static int smu_v13_0_0_set_default_dpm_table(struct smu_context *smu)
 						     dpm_table);
 		if (ret)
 			return ret;
+
+		/*
+		 * Update the reported maximum shader clock to the value
+		 * which can be guarded to be achieved on all cards. This
+		 * is aligned with Window setting. And considering that value
+		 * might be not the peak frequency the card can achieve, it
+		 * is normal some real-time clock frequency can overtake this
+		 * labelled maximum clock frequency(for example in pp_dpm_sclk
+		 * sysfs output).
+		 */
+		if (skutable->DriverReportedClocks.GameClockAc &&
+		    (dpm_table->dpm_levels[dpm_table->count - 1].value >
+		    skutable->DriverReportedClocks.GameClockAc)) {
+			dpm_table->dpm_levels[dpm_table->count - 1].value =
+				skutable->DriverReportedClocks.GameClockAc;
+			dpm_table->max = skutable->DriverReportedClocks.GameClockAc;
+		}
 	} else {
 		dpm_table->count = 1;
 		dpm_table->dpm_levels[0].value = smu->smu_table.boot_values.gfxclk / 100;
@@ -779,6 +798,57 @@ static int smu_v13_0_0_get_smu_metrics_data(struct smu_context *smu,
 	return ret;
 }
 
+static int smu_v13_0_0_get_dpm_ultimate_freq(struct smu_context *smu,
+					     enum smu_clk_type clk_type,
+					     uint32_t *min,
+					     uint32_t *max)
+{
+	struct smu_13_0_dpm_context *dpm_context =
+		smu->smu_dpm.dpm_context;
+	struct smu_13_0_dpm_table *dpm_table;
+
+	switch (clk_type) {
+	case SMU_MCLK:
+	case SMU_UCLK:
+		/* uclk dpm table */
+		dpm_table = &dpm_context->dpm_tables.uclk_table;
+		break;
+	case SMU_GFXCLK:
+	case SMU_SCLK:
+		/* gfxclk dpm table */
+		dpm_table = &dpm_context->dpm_tables.gfx_table;
+		break;
+	case SMU_SOCCLK:
+		/* socclk dpm table */
+		dpm_table = &dpm_context->dpm_tables.soc_table;
+		break;
+	case SMU_FCLK:
+		/* fclk dpm table */
+		dpm_table = &dpm_context->dpm_tables.fclk_table;
+		break;
+	case SMU_VCLK:
+	case SMU_VCLK1:
+		/* vclk dpm table */
+		dpm_table = &dpm_context->dpm_tables.vclk_table;
+		break;
+	case SMU_DCLK:
+	case SMU_DCLK1:
+		/* dclk dpm table */
+		dpm_table = &dpm_context->dpm_tables.dclk_table;
+		break;
+	default:
+		dev_err(smu->adev->dev, "Unsupported clock type!\n");
+		return -EINVAL;
+	}
+
+	if (min)
+		*min = dpm_table->min;
+	if (max)
+		*max = dpm_table->max;
+
+	return 0;
+}
+
 static int smu_v13_0_0_read_sensor(struct smu_context *smu,
 				   enum amd_pp_sensors sensor,
 				   void *data,
@@ -1281,9 +1351,17 @@ static int smu_v13_0_0_populate_umd_state_clk(struct smu_context *smu)
 				&dpm_context->dpm_tables.fclk_table;
 	struct smu_umd_pstate_table *pstate_table =
 				&smu->pstate_table;
+	struct smu_table_context *table_context = &smu->smu_table;
+	PPTable_t *pptable = table_context->driver_pptable;
+	DriverReportedClocks_t driver_clocks =
+			pptable->SkuTable.DriverReportedClocks;
 
 	pstate_table->gfxclk_pstate.min = gfx_table->min;
-	pstate_table->gfxclk_pstate.peak = gfx_table->max;
+	if (driver_clocks.GameClockAc &&
+	    (driver_clocks.GameClockAc < gfx_table->max))
+		pstate_table->gfxclk_pstate.peak = driver_clocks.GameClockAc;
+	else
+		pstate_table->gfxclk_pstate.peak = gfx_table->max;
 
 	pstate_table->uclk_pstate.min = mem_table->min;
 	pstate_table->uclk_pstate.peak = mem_table->max;
@@ -1300,12 +1378,12 @@ static int smu_v13_0_0_populate_umd_state_clk(struct smu_context *smu)
 	pstate_table->fclk_pstate.min = fclk_table->min;
 	pstate_table->fclk_pstate.peak = fclk_table->max;
 
-	/*
-	 * For now, just use the mininum clock frequency.
-	 * TODO: update them when the real pstate settings available
-	 */
-	pstate_table->gfxclk_pstate.standard = gfx_table->min;
-	pstate_table->uclk_pstate.standard = mem_table->min;
+	if (driver_clocks.BaseClockAc &&
+	    driver_clocks.BaseClockAc < gfx_table->max)
+		pstate_table->gfxclk_pstate.standard = driver_clocks.BaseClockAc;
+	else
+		pstate_table->gfxclk_pstate.standard = gfx_table->max;
+	pstate_table->uclk_pstate.standard = mem_table->max;
 	pstate_table->socclk_pstate.standard = soc_table->min;
 	pstate_table->vclk_pstate.standard = vclk_table->min;
 	pstate_table->dclk_pstate.standard = dclk_table->min;
@@ -1339,12 +1417,23 @@ static void smu_v13_0_0_get_unique_id(struct smu_context *smu)
 static int smu_v13_0_0_get_fan_speed_pwm(struct smu_context *smu,
 					 uint32_t *speed)
 {
+	int ret;
+
 	if (!speed)
 		return -EINVAL;
 
-	return smu_v13_0_0_get_smu_metrics_data(smu,
-						METRICS_CURR_FANPWM,
-						speed);
+	ret = smu_v13_0_0_get_smu_metrics_data(smu,
+					       METRICS_CURR_FANPWM,
+					       speed);
+	if (ret) {
+		dev_err(smu->adev->dev, "Failed to get fan speed(PWM)!");
+		return ret;
+	}
+
+	/* Convert the PMFW output which is in percent to pwm(255) based */
+	*speed = MIN(*speed * 255 / 100, 255);
+
+	return 0;
 }
 
 static int smu_v13_0_0_get_fan_speed_rpm(struct smu_context *smu,
@@ -1813,7 +1902,7 @@ static const struct pptable_funcs smu_v13_0_0_ppt_funcs = {
 	.get_enabled_mask = smu_cmn_get_enabled_mask,
 	.dpm_set_vcn_enable = smu_v13_0_set_vcn_enable,
 	.dpm_set_jpeg_enable = smu_v13_0_set_jpeg_enable,
-	.get_dpm_ultimate_freq = smu_v13_0_get_dpm_ultimate_freq,
+	.get_dpm_ultimate_freq = smu_v13_0_0_get_dpm_ultimate_freq,
 	.get_vbios_bootup_values = smu_v13_0_get_vbios_bootup_values,
 	.read_sensor = smu_v13_0_0_read_sensor,
 	.feature_is_enabled = smu_cmn_feature_is_enabled,
diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
index 39deb06a86ba..222924363a68 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c
@@ -189,6 +189,8 @@ static struct cmn2asic_mapping smu_v13_0_7_feature_mask_map[SMU_FEATURE_COUNT] =
 	FEA_MAP(MEM_TEMP_READ),
 	FEA_MAP(ATHUB_MMHUB_PG),
 	FEA_MAP(SOC_PCC),
+	[SMU_FEATURE_DPM_VCLK_BIT] = {1, FEATURE_MM_DPM_BIT},
+	[SMU_FEATURE_DPM_DCLK_BIT] = {1, FEATURE_MM_DPM_BIT},
 };
 
 static struct cmn2asic_mapping smu_v13_0_7_table_map[SMU_TABLE_COUNT] = {
@@ -1359,12 +1361,23 @@ static int smu_v13_0_7_populate_umd_state_clk(struct smu_context *smu)
 static int smu_v13_0_7_get_fan_speed_pwm(struct smu_context *smu,
 					 uint32_t *speed)
 {
+	int ret;
+
 	if (!speed)
 		return -EINVAL;
 
-	return smu_v13_0_7_get_smu_metrics_data(smu,
-						METRICS_CURR_FANPWM,
-						speed);
+	ret = smu_v13_0_7_get_smu_metrics_data(smu,
+					       METRICS_CURR_FANPWM,
+					       speed);
+	if (ret) {
+		dev_err(smu->adev->dev, "Failed to get fan speed(PWM)!");
+		return ret;
+	}
+
+	/* Convert the PMFW output which is in percent to pwm(255) based */
+	*speed = MIN(*speed * 255 / 100, 255);
+
+	return 0;
 }
 
 static int smu_v13_0_7_get_fan_speed_rpm(struct smu_context *smu,
diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index 61c29ce74b03..27de2a97f1d1 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -582,6 +582,9 @@ void drm_connector_cleanup(struct drm_connector *connector)
 	mutex_destroy(&connector->mutex);
 
 	memset(connector, 0, sizeof(*connector));
+
+	if (dev->registered)
+		drm_sysfs_hotplug_event(dev);
 }
 EXPORT_SYMBOL(drm_connector_cleanup);
 
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem.c b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
index cc386f8a7116..5cf13e52f7c9 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem.c
@@ -258,7 +258,12 @@ struct etnaviv_vram_mapping *etnaviv_gem_mapping_get(
 		if (mapping->use == 0) {
 			mutex_lock(&mmu_context->lock);
 			if (mapping->context == mmu_context)
-				mapping->use += 1;
+				if (va && mapping->iova != va) {
+					etnaviv_iommu_reap_mapping(mapping);
+					mapping = NULL;
+				} else {
+					mapping->use += 1;
+				}
 			else
 				mapping = NULL;
 			mutex_unlock(&mmu_context->lock);
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
index dc1aa738c4f1..55479cb8b1ac 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.c
@@ -135,6 +135,19 @@ static void etnaviv_iommu_remove_mapping(struct etnaviv_iommu_context *context,
 	drm_mm_remove_node(&mapping->vram_node);
 }
 
+void etnaviv_iommu_reap_mapping(struct etnaviv_vram_mapping *mapping)
+{
+	struct etnaviv_iommu_context *context = mapping->context;
+
+	lockdep_assert_held(&context->lock);
+	WARN_ON(mapping->use);
+
+	etnaviv_iommu_remove_mapping(context, mapping);
+	etnaviv_iommu_context_put(mapping->context);
+	mapping->context = NULL;
+	list_del_init(&mapping->mmu_node);
+}
+
 static int etnaviv_iommu_find_iova(struct etnaviv_iommu_context *context,
 				   struct drm_mm_node *node, size_t size)
 {
@@ -202,10 +215,7 @@ static int etnaviv_iommu_find_iova(struct etnaviv_iommu_context *context,
 		 * this mapping.
 		 */
 		list_for_each_entry_safe(m, n, &list, scan_node) {
-			etnaviv_iommu_remove_mapping(context, m);
-			etnaviv_iommu_context_put(m->context);
-			m->context = NULL;
-			list_del_init(&m->mmu_node);
+			etnaviv_iommu_reap_mapping(m);
 			list_del_init(&m->scan_node);
 		}
 
@@ -257,10 +267,7 @@ static int etnaviv_iommu_insert_exact(struct etnaviv_iommu_context *context,
 	}
 
 	list_for_each_entry_safe(m, n, &scan_list, scan_node) {
-		etnaviv_iommu_remove_mapping(context, m);
-		etnaviv_iommu_context_put(m->context);
-		m->context = NULL;
-		list_del_init(&m->mmu_node);
+		etnaviv_iommu_reap_mapping(m);
 		list_del_init(&m->scan_node);
 	}
 
diff --git a/drivers/gpu/drm/etnaviv/etnaviv_mmu.h b/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
index e4a0b7d09c2e..c01a147f0dfd 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
+++ b/drivers/gpu/drm/etnaviv/etnaviv_mmu.h
@@ -91,6 +91,7 @@ int etnaviv_iommu_map_gem(struct etnaviv_iommu_context *context,
 	struct etnaviv_vram_mapping *mapping, u64 va);
 void etnaviv_iommu_unmap_gem(struct etnaviv_iommu_context *context,
 	struct etnaviv_vram_mapping *mapping);
+void etnaviv_iommu_reap_mapping(struct etnaviv_vram_mapping *mapping);
 
 int etnaviv_iommu_get_suballoc_va(struct etnaviv_iommu_context *ctx,
 				  struct etnaviv_vram_mapping *mapping,
diff --git a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
index 75e8cc4337c9..fce69fa446d5 100644
--- a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
+++ b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
@@ -137,9 +137,9 @@ static enum port intel_dsi_seq_port_to_port(struct intel_dsi *intel_dsi,
 		return ffs(intel_dsi->ports) - 1;
 
 	if (seq_port) {
-		if (intel_dsi->ports & PORT_B)
+		if (intel_dsi->ports & BIT(PORT_B))
 			return PORT_B;
-		else if (intel_dsi->ports & PORT_C)
+		else if (intel_dsi->ports & BIT(PORT_C))
 			return PORT_C;
 	}
 
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
index 845023c14eb3..f461e34cc5f0 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -729,32 +729,69 @@ static int eb_reserve(struct i915_execbuffer *eb)
 	bool unpinned;
 
 	/*
-	 * Attempt to pin all of the buffers into the GTT.
-	 * This is done in 2 phases:
+	 * We have one more buffers that we couldn't bind, which could be due to
+	 * various reasons. To resolve this we have 4 passes, with every next
+	 * level turning the screws tighter:
 	 *
-	 * 1. Unbind all objects that do not match the GTT constraints for
-	 *    the execbuffer (fenceable, mappable, alignment etc).
-	 * 2. Bind new objects.
+	 * 0. Unbind all objects that do not match the GTT constraints for the
+	 * execbuffer (fenceable, mappable, alignment etc). Bind all new
+	 * objects.  This avoids unnecessary unbinding of later objects in order
+	 * to make room for the earlier objects *unless* we need to defragment.
 	 *
-	 * This avoid unnecessary unbinding of later objects in order to make
-	 * room for the earlier objects *unless* we need to defragment.
+	 * 1. Reorder the buffers, where objects with the most restrictive
+	 * placement requirements go first (ignoring fixed location buffers for
+	 * now).  For example, objects needing the mappable aperture (the first
+	 * 256M of GTT), should go first vs objects that can be placed just
+	 * about anywhere. Repeat the previous pass.
 	 *
-	 * Defragmenting is skipped if all objects are pinned at a fixed location.
+	 * 2. Consider buffers that are pinned at a fixed location. Also try to
+	 * evict the entire VM this time, leaving only objects that we were
+	 * unable to lock. Try again to bind the buffers. (still using the new
+	 * buffer order).
+	 *
+	 * 3. We likely have object lock contention for one or more stubborn
+	 * objects in the VM, for which we need to evict to make forward
+	 * progress (perhaps we are fighting the shrinker?). When evicting the
+	 * VM this time around, anything that we can't lock we now track using
+	 * the busy_bo, using the full lock (after dropping the vm->mutex to
+	 * prevent deadlocks), instead of trylock. We then continue to evict the
+	 * VM, this time with the stubborn object locked, which we can now
+	 * hopefully unbind (if still bound in the VM). Repeat until the VM is
+	 * evicted. Finally we should be able bind everything.
 	 */
-	for (pass = 0; pass <= 2; pass++) {
+	for (pass = 0; pass <= 3; pass++) {
 		int pin_flags = PIN_USER | PIN_VALIDATE;
 
 		if (pass == 0)
 			pin_flags |= PIN_NONBLOCK;
 
 		if (pass >= 1)
-			unpinned = eb_unbind(eb, pass == 2);
+			unpinned = eb_unbind(eb, pass >= 2);
 
 		if (pass == 2) {
 			err = mutex_lock_interruptible(&eb->context->vm->mutex);
 			if (!err) {
-				err = i915_gem_evict_vm(eb->context->vm, &eb->ww);
+				err = i915_gem_evict_vm(eb->context->vm, &eb->ww, NULL);
+				mutex_unlock(&eb->context->vm->mutex);
+			}
+			if (err)
+				return err;
+		}
+
+		if (pass == 3) {
+retry:
+			err = mutex_lock_interruptible(&eb->context->vm->mutex);
+			if (!err) {
+				struct drm_i915_gem_object *busy_bo = NULL;
+
+				err = i915_gem_evict_vm(eb->context->vm, &eb->ww, &busy_bo);
 				mutex_unlock(&eb->context->vm->mutex);
+				if (err && busy_bo) {
+					err = i915_gem_object_lock(busy_bo, &eb->ww);
+					i915_gem_object_put(busy_bo);
+					if (!err)
+						goto retry;
+				}
 			}
 			if (err)
 				return err;
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index e63329bc8065..354c1d6dab84 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -369,7 +369,7 @@ static vm_fault_t vm_fault_gtt(struct vm_fault *vmf)
 		if (vma == ERR_PTR(-ENOSPC)) {
 			ret = mutex_lock_interruptible(&ggtt->vm.mutex);
 			if (!ret) {
-				ret = i915_gem_evict_vm(&ggtt->vm, &ww);
+				ret = i915_gem_evict_vm(&ggtt->vm, &ww, NULL);
 				mutex_unlock(&ggtt->vm.mutex);
 			}
 			if (ret)
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.c b/drivers/gpu/drm/i915/gem/i915_gem_object.c
index 369006c5317f..a40bc17acead 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.c
@@ -761,6 +761,9 @@ bool i915_gem_object_needs_ccs_pages(struct drm_i915_gem_object *obj)
 	if (!HAS_FLAT_CCS(to_i915(obj->base.dev)))
 		return false;
 
+	if (obj->flags & I915_BO_ALLOC_CCS_AUX)
+		return true;
+
 	for (i = 0; i < obj->mm.n_placements; i++) {
 		/* Compression is not allowed for the objects with smem placement */
 		if (obj->mm.placements[i]->type == INTEL_MEMORY_SYSTEM)
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
index d0d6772e6f36..ab4c2f90a564 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
@@ -327,16 +327,18 @@ struct drm_i915_gem_object {
  * dealing with userspace objects the CPU fault handler is free to ignore this.
  */
 #define I915_BO_ALLOC_GPU_ONLY	  BIT(6)
+#define I915_BO_ALLOC_CCS_AUX	  BIT(7)
 #define I915_BO_ALLOC_FLAGS (I915_BO_ALLOC_CONTIGUOUS | \
 			     I915_BO_ALLOC_VOLATILE | \
 			     I915_BO_ALLOC_CPU_CLEAR | \
 			     I915_BO_ALLOC_USER | \
 			     I915_BO_ALLOC_PM_VOLATILE | \
 			     I915_BO_ALLOC_PM_EARLY | \
-			     I915_BO_ALLOC_GPU_ONLY)
-#define I915_BO_READONLY          BIT(7)
-#define I915_TILING_QUIRK_BIT     8 /* unknown swizzling; do not release! */
-#define I915_BO_PROTECTED         BIT(9)
+			     I915_BO_ALLOC_GPU_ONLY | \
+			     I915_BO_ALLOC_CCS_AUX)
+#define I915_BO_READONLY          BIT(8)
+#define I915_TILING_QUIRK_BIT     9 /* unknown swizzling; do not release! */
+#define I915_BO_PROTECTED         BIT(10)
 	/**
 	 * @mem_flags - Mutable placement-related flags
 	 *
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c b/drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c
index 07e49f22f2de..7e67742bc65e 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm_pm.c
@@ -50,6 +50,7 @@ static int i915_ttm_backup(struct i915_gem_apply_to_region *apply,
 		container_of(bo->bdev, typeof(*i915), bdev);
 	struct drm_i915_gem_object *backup;
 	struct ttm_operation_ctx ctx = {};
+	unsigned int flags;
 	int err = 0;
 
 	if (bo->resource->mem_type == I915_PL_SYSTEM || obj->ttm.backup)
@@ -65,7 +66,22 @@ static int i915_ttm_backup(struct i915_gem_apply_to_region *apply,
 	if (obj->flags & I915_BO_ALLOC_PM_VOLATILE)
 		return 0;
 
-	backup = i915_gem_object_create_shmem(i915, obj->base.size);
+	/*
+	 * It seems that we might have some framebuffers still pinned at this
+	 * stage, but for such objects we might also need to deal with the CCS
+	 * aux state. Make sure we force the save/restore of the CCS state,
+	 * otherwise we might observe display corruption, when returning from
+	 * suspend.
+	 */
+	flags = 0;
+	if (i915_gem_object_needs_ccs_pages(obj)) {
+		WARN_ON_ONCE(!i915_gem_object_is_framebuffer(obj));
+		WARN_ON_ONCE(!pm_apply->allow_gpu);
+
+		flags = I915_BO_ALLOC_CCS_AUX;
+	}
+	backup = i915_gem_object_create_region(i915->mm.regions[INTEL_REGION_SMEM],
+					       obj->base.size, 0, flags);
 	if (IS_ERR(backup))
 		return PTR_ERR(backup);
 
diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
index aaaf1906026c..ee072c7d62eb 100644
--- a/drivers/gpu/drm/i915/gt/intel_migrate.c
+++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
@@ -341,6 +341,16 @@ static int emit_no_arbitration(struct i915_request *rq)
 	return 0;
 }
 
+static int max_pte_pkt_size(struct i915_request *rq, int pkt)
+{
+	struct intel_ring *ring = rq->ring;
+
+	pkt = min_t(int, pkt, (ring->space - rq->reserved_space) / sizeof(u32) + 5);
+	pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
+
+	return pkt;
+}
+
 static int emit_pte(struct i915_request *rq,
 		    struct sgt_dma *it,
 		    enum i915_cache_level cache_level,
@@ -387,8 +397,7 @@ static int emit_pte(struct i915_request *rq,
 		return PTR_ERR(cs);
 
 	/* Pack as many PTE updates as possible into a single MI command */
-	pkt = min_t(int, dword_length, ring->space / sizeof(u32) + 5);
-	pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
+	pkt = max_pte_pkt_size(rq, dword_length);
 
 	hdr = cs;
 	*cs++ = MI_STORE_DATA_IMM | REG_BIT(21); /* as qword elements */
@@ -421,8 +430,7 @@ static int emit_pte(struct i915_request *rq,
 				}
 			}
 
-			pkt = min_t(int, dword_rem, ring->space / sizeof(u32) + 5);
-			pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
+			pkt = max_pte_pkt_size(rq, dword_rem);
 
 			hdr = cs;
 			*cs++ = MI_STORE_DATA_IMM | REG_BIT(21);
diff --git a/drivers/gpu/drm/i915/i915_gem_evict.c b/drivers/gpu/drm/i915/i915_gem_evict.c
index f025ee4fa526..a4b4d9b7d26c 100644
--- a/drivers/gpu/drm/i915/i915_gem_evict.c
+++ b/drivers/gpu/drm/i915/i915_gem_evict.c
@@ -416,6 +416,11 @@ int i915_gem_evict_for_node(struct i915_address_space *vm,
  * @vm: Address space to cleanse
  * @ww: An optional struct i915_gem_ww_ctx. If not NULL, i915_gem_evict_vm
  * will be able to evict vma's locked by the ww as well.
+ * @busy_bo: Optional pointer to struct drm_i915_gem_object. If not NULL, then
+ * in the event i915_gem_evict_vm() is unable to trylock an object for eviction,
+ * then @busy_bo will point to it. -EBUSY is also returned. The caller must drop
+ * the vm->mutex, before trying again to acquire the contended lock. The caller
+ * also owns a reference to the object.
  *
  * This function evicts all vmas from a vm.
  *
@@ -425,7 +430,8 @@ int i915_gem_evict_for_node(struct i915_address_space *vm,
  * To clarify: This is for freeing up virtual address space, not for freeing
  * memory in e.g. the shrinker.
  */
-int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww)
+int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww,
+		      struct drm_i915_gem_object **busy_bo)
 {
 	int ret = 0;
 
@@ -457,15 +463,22 @@ int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww)
 			 * the resv is shared among multiple objects, we still
 			 * need the object ref.
 			 */
-			if (dying_vma(vma) ||
+			if (!i915_gem_object_get_rcu(vma->obj) ||
 			    (ww && (dma_resv_locking_ctx(vma->obj->base.resv) == &ww->ctx))) {
 				__i915_vma_pin(vma);
 				list_add(&vma->evict_link, &locked_eviction_list);
 				continue;
 			}
 
-			if (!i915_gem_object_trylock(vma->obj, ww))
+			if (!i915_gem_object_trylock(vma->obj, ww)) {
+				if (busy_bo) {
+					*busy_bo = vma->obj; /* holds ref */
+					ret = -EBUSY;
+					break;
+				}
+				i915_gem_object_put(vma->obj);
 				continue;
+			}
 
 			__i915_vma_pin(vma);
 			list_add(&vma->evict_link, &eviction_list);
@@ -473,25 +486,29 @@ int i915_gem_evict_vm(struct i915_address_space *vm, struct i915_gem_ww_ctx *ww)
 		if (list_empty(&eviction_list) && list_empty(&locked_eviction_list))
 			break;
 
-		ret = 0;
 		/* Unbind locked objects first, before unlocking the eviction_list */
 		list_for_each_entry_safe(vma, vn, &locked_eviction_list, evict_link) {
 			__i915_vma_unpin(vma);
 
-			if (ret == 0)
+			if (ret == 0) {
 				ret = __i915_vma_unbind(vma);
-			if (ret != -EINTR) /* "Get me out of here!" */
-				ret = 0;
+				if (ret != -EINTR) /* "Get me out of here!" */
+					ret = 0;
+			}
+			if (!dying_vma(vma))
+				i915_gem_object_put(vma->obj);
 		}
 
 		list_for_each_entry_safe(vma, vn, &eviction_list, evict_link) {
 			__i915_vma_unpin(vma);
-			if (ret == 0)
+			if (ret == 0) {
 				ret = __i915_vma_unbind(vma);
-			if (ret != -EINTR) /* "Get me out of here!" */
-				ret = 0;
+				if (ret != -EINTR) /* "Get me out of here!" */
+					ret = 0;
+			}
 
 			i915_gem_object_unlock(vma->obj);
+			i915_gem_object_put(vma->obj);
 		}
 	} while (ret == 0);
 
diff --git a/drivers/gpu/drm/i915/i915_gem_evict.h b/drivers/gpu/drm/i915/i915_gem_evict.h
index e593c530f9bd..bf0ee0e4fe60 100644
--- a/drivers/gpu/drm/i915/i915_gem_evict.h
+++ b/drivers/gpu/drm/i915/i915_gem_evict.h
@@ -11,6 +11,7 @@
 struct drm_mm_node;
 struct i915_address_space;
 struct i915_gem_ww_ctx;
+struct drm_i915_gem_object;
 
 int __must_check i915_gem_evict_something(struct i915_address_space *vm,
 					  struct i915_gem_ww_ctx *ww,
@@ -23,6 +24,7 @@ int __must_check i915_gem_evict_for_node(struct i915_address_space *vm,
 					 struct drm_mm_node *node,
 					 unsigned int flags);
 int i915_gem_evict_vm(struct i915_address_space *vm,
-		      struct i915_gem_ww_ctx *ww);
+		      struct i915_gem_ww_ctx *ww,
+		      struct drm_i915_gem_object **busy_bo);
 
 #endif /* __I915_GEM_EVICT_H__ */
diff --git a/drivers/gpu/drm/i915/i915_vma.c b/drivers/gpu/drm/i915/i915_vma.c
index f17c09ead7d7..4d06875de14a 100644
--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -1569,7 +1569,7 @@ static int __i915_ggtt_pin(struct i915_vma *vma, struct i915_gem_ww_ctx *ww,
 			 * locked objects when called from execbuf when pinning
 			 * is removed. This would probably regress badly.
 			 */
-			i915_gem_evict_vm(vm, NULL);
+			i915_gem_evict_vm(vm, NULL, NULL);
 			mutex_unlock(&vm->mutex);
 		}
 	} while (1);
diff --git a/drivers/gpu/drm/i915/selftests/i915_gem_evict.c b/drivers/gpu/drm/i915/selftests/i915_gem_evict.c
index 8c6517d29b8e..37068542aafe 100644
--- a/drivers/gpu/drm/i915/selftests/i915_gem_evict.c
+++ b/drivers/gpu/drm/i915/selftests/i915_gem_evict.c
@@ -344,7 +344,7 @@ static int igt_evict_vm(void *arg)
 
 	/* Everything is pinned, nothing should happen */
 	mutex_lock(&ggtt->vm.mutex);
-	err = i915_gem_evict_vm(&ggtt->vm, NULL);
+	err = i915_gem_evict_vm(&ggtt->vm, NULL, NULL);
 	mutex_unlock(&ggtt->vm.mutex);
 	if (err) {
 		pr_err("i915_gem_evict_vm on a full GGTT returned err=%d]\n",
@@ -356,7 +356,7 @@ static int igt_evict_vm(void *arg)
 
 	for_i915_gem_ww(&ww, err, false) {
 		mutex_lock(&ggtt->vm.mutex);
-		err = i915_gem_evict_vm(&ggtt->vm, &ww);
+		err = i915_gem_evict_vm(&ggtt->vm, &ww, NULL);
 		mutex_unlock(&ggtt->vm.mutex);
 	}
 
diff --git a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
index ab0515d2c420..4499a04f7c13 100644
--- a/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
+++ b/drivers/gpu/drm/ingenic/ingenic-drm-drv.c
@@ -1629,7 +1629,11 @@ static int ingenic_drm_init(void)
 			return err;
 	}
 
-	return platform_driver_register(&ingenic_drm_driver);
+	err = platform_driver_register(&ingenic_drm_driver);
+	if (IS_ENABLED(CONFIG_DRM_INGENIC_IPU) && err)
+		platform_driver_unregister(ingenic_ipu_driver_ptr);
+
+	return err;
 }
 module_init(ingenic_drm_init);
 
diff --git a/drivers/gpu/drm/mgag200/mgag200_g200se.c b/drivers/gpu/drm/mgag200/mgag200_g200se.c
index be389ed91cbd..bd6e573c9a1a 100644
--- a/drivers/gpu/drm/mgag200/mgag200_g200se.c
+++ b/drivers/gpu/drm/mgag200/mgag200_g200se.c
@@ -284,7 +284,8 @@ static void mgag200_g200se_04_pixpllc_atomic_update(struct drm_crtc *crtc,
 	pixpllcp = pixpllc->p - 1;
 	pixpllcs = pixpllc->s;
 
-	xpixpllcm = pixpllcm | ((pixpllcn & BIT(8)) >> 1);
+	// For G200SE A, BIT(7) should be set unconditionally.
+	xpixpllcm = BIT(7) | pixpllcm;
 	xpixpllcn = pixpllcn;
 	xpixpllcp = (pixpllcs << 3) | pixpllcp;
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 214829c32ed8..7a2f262414ad 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -308,7 +308,8 @@ void vmw_kms_cursor_snoop(struct vmw_surface *srf,
 	if (cmd->dma.guest.ptr.offset % PAGE_SIZE ||
 	    box->x != 0    || box->y != 0    || box->z != 0    ||
 	    box->srcx != 0 || box->srcy != 0 || box->srcz != 0 ||
-	    box->d != 1    || box_count != 1) {
+	    box->d != 1    || box_count != 1 ||
+	    box->w > 64 || box->h > 64) {
 		/* TODO handle none page aligned offsets */
 		/* TODO handle more dst & src != 0 */
 		/* TODO handle more then one copy */
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index e27fb27a36bf..82713ef3aaa6 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -412,6 +412,7 @@
 #define USB_DEVICE_ID_HP_X2_10_COVER	0x0755
 #define I2C_DEVICE_ID_HP_ENVY_X360_15	0x2d05
 #define I2C_DEVICE_ID_HP_ENVY_X360_15T_DR100	0x29CF
+#define I2C_DEVICE_ID_HP_ENVY_X360_EU0009NV	0x2CF9
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_15	0x2817
 #define USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN	0x2544
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index d728a94c642e..3ee5a9fea20e 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -380,6 +380,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15T_DR100),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_EU0009NV),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_SPECTRE_X360_15),
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN),
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index 1a2d425bf568..34029d116107 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -3402,18 +3402,24 @@ static int __init parse_amd_iommu_options(char *str)
 static int __init parse_ivrs_ioapic(char *str)
 {
 	u32 seg = 0, bus, dev, fn;
-	int ret, id, i;
+	int id, i;
 	u32 devid;
 
-	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
-	if (ret != 4) {
-		ret = sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn);
-		if (ret != 5) {
-			pr_err("Invalid command line: ivrs_ioapic%s\n", str);
-			return 1;
-		}
+	if (sscanf(str, "=%d@%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "=%d@%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5)
+		goto found;
+
+	if (sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5) {
+		pr_warn("ivrs_ioapic%s option format deprecated; use ivrs_ioapic=%d@%04x:%02x:%02x.%d instead\n",
+			str, id, seg, bus, dev, fn);
+		goto found;
 	}
 
+	pr_err("Invalid command line: ivrs_ioapic%s\n", str);
+	return 1;
+
+found:
 	if (early_ioapic_map_size == EARLY_MAP_SIZE) {
 		pr_err("Early IOAPIC map overflow - ignoring ivrs_ioapic%s\n",
 			str);
@@ -3434,18 +3440,24 @@ static int __init parse_ivrs_ioapic(char *str)
 static int __init parse_ivrs_hpet(char *str)
 {
 	u32 seg = 0, bus, dev, fn;
-	int ret, id, i;
+	int id, i;
 	u32 devid;
 
-	ret = sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn);
-	if (ret != 4) {
-		ret = sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn);
-		if (ret != 5) {
-			pr_err("Invalid command line: ivrs_hpet%s\n", str);
-			return 1;
-		}
+	if (sscanf(str, "=%d@%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "=%d@%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5)
+		goto found;
+
+	if (sscanf(str, "[%d]=%x:%x.%x", &id, &bus, &dev, &fn) == 4 ||
+	    sscanf(str, "[%d]=%x:%x:%x.%x", &id, &seg, &bus, &dev, &fn) == 5) {
+		pr_warn("ivrs_hpet%s option format deprecated; use ivrs_hpet=%d@%04x:%02x:%02x.%d instead\n",
+			str, id, seg, bus, dev, fn);
+		goto found;
 	}
 
+	pr_err("Invalid command line: ivrs_hpet%s\n", str);
+	return 1;
+
+found:
 	if (early_hpet_map_size == EARLY_MAP_SIZE) {
 		pr_err("Early HPET map overflow - ignoring ivrs_hpet%s\n",
 			str);
@@ -3466,19 +3478,36 @@ static int __init parse_ivrs_hpet(char *str)
 static int __init parse_ivrs_acpihid(char *str)
 {
 	u32 seg = 0, bus, dev, fn;
-	char *hid, *uid, *p;
+	char *hid, *uid, *p, *addr;
 	char acpiid[ACPIHID_UID_LEN + ACPIHID_HID_LEN] = {0};
-	int ret, i;
-
-	ret = sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid);
-	if (ret != 4) {
-		ret = sscanf(str, "[%x:%x:%x.%x]=%s", &seg, &bus, &dev, &fn, acpiid);
-		if (ret != 5) {
-			pr_err("Invalid command line: ivrs_acpihid(%s)\n", str);
-			return 1;
+	int i;
+
+	addr = strchr(str, '@');
+	if (!addr) {
+		if (sscanf(str, "[%x:%x.%x]=%s", &bus, &dev, &fn, acpiid) == 4 ||
+		    sscanf(str, "[%x:%x:%x.%x]=%s", &seg, &bus, &dev, &fn, acpiid) == 5) {
+			pr_warn("ivrs_acpihid%s option format deprecated; use ivrs_acpihid=%s@%04x:%02x:%02x.%d instead\n",
+				str, acpiid, seg, bus, dev, fn);
+			goto found;
 		}
+		goto not_found;
 	}
 
+	/* We have the '@', make it the terminator to get just the acpiid */
+	*addr++ = 0;
+
+	if (sscanf(str, "=%s", acpiid) != 1)
+		goto not_found;
+
+	if (sscanf(addr, "%x:%x.%x", &bus, &dev, &fn) == 3 ||
+	    sscanf(addr, "%x:%x:%x.%x", &seg, &bus, &dev, &fn) == 4)
+		goto found;
+
+not_found:
+	pr_err("Invalid command line: ivrs_acpihid%s\n", str);
+	return 1;
+
+found:
 	p = acpiid;
 	hid = strsep(&p, ":");
 	uid = p;
@@ -3488,6 +3517,13 @@ static int __init parse_ivrs_acpihid(char *str)
 		return 1;
 	}
 
+	/*
+	 * Ignore leading zeroes after ':', so e.g., AMDI0095:00
+	 * will match AMDI0095:0 in the second strcmp in acpi_dev_hid_uid_match
+	 */
+	while (*uid == '0' && *(uid + 1))
+		uid++;
+
 	i = early_acpihid_map_size++;
 	memcpy(early_acpihid_map[i].hid, hid, strlen(hid));
 	memcpy(early_acpihid_map[i].uid, uid, strlen(uid));
diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index ab13b7380265..83a5975bcc72 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -551,11 +551,13 @@ static int __create_persistent_data_objects(struct dm_cache_metadata *cmd,
 	return r;
 }
 
-static void __destroy_persistent_data_objects(struct dm_cache_metadata *cmd)
+static void __destroy_persistent_data_objects(struct dm_cache_metadata *cmd,
+					      bool destroy_bm)
 {
 	dm_sm_destroy(cmd->metadata_sm);
 	dm_tm_destroy(cmd->tm);
-	dm_block_manager_destroy(cmd->bm);
+	if (destroy_bm)
+		dm_block_manager_destroy(cmd->bm);
 }
 
 typedef unsigned long (*flags_mutator)(unsigned long);
@@ -826,7 +828,7 @@ static struct dm_cache_metadata *lookup_or_open(struct block_device *bdev,
 		cmd2 = lookup(bdev);
 		if (cmd2) {
 			mutex_unlock(&table_lock);
-			__destroy_persistent_data_objects(cmd);
+			__destroy_persistent_data_objects(cmd, true);
 			kfree(cmd);
 			return cmd2;
 		}
@@ -874,7 +876,7 @@ void dm_cache_metadata_close(struct dm_cache_metadata *cmd)
 		mutex_unlock(&table_lock);
 
 		if (!cmd->fail_io)
-			__destroy_persistent_data_objects(cmd);
+			__destroy_persistent_data_objects(cmd, true);
 		kfree(cmd);
 	}
 }
@@ -1807,14 +1809,52 @@ int dm_cache_metadata_needs_check(struct dm_cache_metadata *cmd, bool *result)
 
 int dm_cache_metadata_abort(struct dm_cache_metadata *cmd)
 {
-	int r;
+	int r = -EINVAL;
+	struct dm_block_manager *old_bm = NULL, *new_bm = NULL;
+
+	/* fail_io is double-checked with cmd->root_lock held below */
+	if (unlikely(cmd->fail_io))
+		return r;
+
+	/*
+	 * Replacement block manager (new_bm) is created and old_bm destroyed outside of
+	 * cmd root_lock to avoid ABBA deadlock that would result (due to life-cycle of
+	 * shrinker associated with the block manager's bufio client vs cmd root_lock).
+	 * - must take shrinker_rwsem without holding cmd->root_lock
+	 */
+	new_bm = dm_block_manager_create(cmd->bdev, DM_CACHE_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
+					 CACHE_MAX_CONCURRENT_LOCKS);
 
 	WRITE_LOCK(cmd);
-	__destroy_persistent_data_objects(cmd);
-	r = __create_persistent_data_objects(cmd, false);
+	if (cmd->fail_io) {
+		WRITE_UNLOCK(cmd);
+		goto out;
+	}
+
+	__destroy_persistent_data_objects(cmd, false);
+	old_bm = cmd->bm;
+	if (IS_ERR(new_bm)) {
+		DMERR("could not create block manager during abort");
+		cmd->bm = NULL;
+		r = PTR_ERR(new_bm);
+		goto out_unlock;
+	}
+
+	cmd->bm = new_bm;
+	r = __open_or_format_metadata(cmd, false);
+	if (r) {
+		cmd->bm = NULL;
+		goto out_unlock;
+	}
+	new_bm = NULL;
+out_unlock:
 	if (r)
 		cmd->fail_io = true;
 	WRITE_UNLOCK(cmd);
+	dm_block_manager_destroy(old_bm);
+out:
+	if (new_bm && !IS_ERR(new_bm))
+		dm_block_manager_destroy(new_bm);
 
 	return r;
 }
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 54a8d5c9a44e..5e92fac90b67 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -907,16 +907,16 @@ static void abort_transaction(struct cache *cache)
 	if (get_cache_mode(cache) >= CM_READ_ONLY)
 		return;
 
-	if (dm_cache_metadata_set_needs_check(cache->cmd)) {
-		DMERR("%s: failed to set 'needs_check' flag in metadata", dev_name);
-		set_cache_mode(cache, CM_FAIL);
-	}
-
 	DMERR_LIMIT("%s: aborting current metadata transaction", dev_name);
 	if (dm_cache_metadata_abort(cache->cmd)) {
 		DMERR("%s: failed to abort metadata transaction", dev_name);
 		set_cache_mode(cache, CM_FAIL);
 	}
+
+	if (dm_cache_metadata_set_needs_check(cache->cmd)) {
+		DMERR("%s: failed to set 'needs_check' flag in metadata", dev_name);
+		set_cache_mode(cache, CM_FAIL);
+	}
 }
 
 static void metadata_operation_failed(struct cache *cache, const char *op, int r)
@@ -1887,6 +1887,7 @@ static void destroy(struct cache *cache)
 	if (cache->prison)
 		dm_bio_prison_destroy_v2(cache->prison);
 
+	cancel_delayed_work_sync(&cache->waker);
 	if (cache->wq)
 		destroy_workqueue(cache->wq);
 
diff --git a/drivers/md/dm-clone-target.c b/drivers/md/dm-clone-target.c
index 2f1cc66d2641..29e0b85eeaf0 100644
--- a/drivers/md/dm-clone-target.c
+++ b/drivers/md/dm-clone-target.c
@@ -1958,6 +1958,7 @@ static void clone_dtr(struct dm_target *ti)
 
 	mempool_exit(&clone->hydration_pool);
 	dm_kcopyd_client_destroy(clone->kcopyd_client);
+	cancel_delayed_work_sync(&clone->waker);
 	destroy_workqueue(clone->wq);
 	hash_table_exit(clone);
 	dm_clone_metadata_close(clone->cmd);
diff --git a/drivers/md/dm-integrity.c b/drivers/md/dm-integrity.c
index e97e9f97456d..1388ee35571e 100644
--- a/drivers/md/dm-integrity.c
+++ b/drivers/md/dm-integrity.c
@@ -4558,6 +4558,8 @@ static void dm_integrity_dtr(struct dm_target *ti)
 	BUG_ON(!RB_EMPTY_ROOT(&ic->in_progress));
 	BUG_ON(!list_empty(&ic->wait_list));
 
+	if (ic->mode == 'B')
+		cancel_delayed_work_sync(&ic->bitmap_flush_work);
 	if (ic->metadata_wq)
 		destroy_workqueue(ic->metadata_wq);
 	if (ic->wait_wq)
diff --git a/drivers/md/dm-thin-metadata.c b/drivers/md/dm-thin-metadata.c
index a27395c8621f..6bcc4c4786d8 100644
--- a/drivers/md/dm-thin-metadata.c
+++ b/drivers/md/dm-thin-metadata.c
@@ -724,6 +724,15 @@ static int __open_metadata(struct dm_pool_metadata *pmd)
 		goto bad_cleanup_data_sm;
 	}
 
+	/*
+	 * For pool metadata opening process, root setting is redundant
+	 * because it will be set again in __begin_transaction(). But dm
+	 * pool aborting process really needs to get last transaction's
+	 * root to avoid accessing broken btree.
+	 */
+	pmd->root = le64_to_cpu(disk_super->data_mapping_root);
+	pmd->details_root = le64_to_cpu(disk_super->device_details_root);
+
 	__setup_btree_details(pmd);
 	dm_bm_unlock(sblock);
 
@@ -776,13 +785,15 @@ static int __create_persistent_data_objects(struct dm_pool_metadata *pmd, bool f
 	return r;
 }
 
-static void __destroy_persistent_data_objects(struct dm_pool_metadata *pmd)
+static void __destroy_persistent_data_objects(struct dm_pool_metadata *pmd,
+					      bool destroy_bm)
 {
 	dm_sm_destroy(pmd->data_sm);
 	dm_sm_destroy(pmd->metadata_sm);
 	dm_tm_destroy(pmd->nb_tm);
 	dm_tm_destroy(pmd->tm);
-	dm_block_manager_destroy(pmd->bm);
+	if (destroy_bm)
+		dm_block_manager_destroy(pmd->bm);
 }
 
 static int __begin_transaction(struct dm_pool_metadata *pmd)
@@ -989,7 +1000,7 @@ int dm_pool_metadata_close(struct dm_pool_metadata *pmd)
 	}
 	pmd_write_unlock(pmd);
 	if (!pmd->fail_io)
-		__destroy_persistent_data_objects(pmd);
+		__destroy_persistent_data_objects(pmd, true);
 
 	kfree(pmd);
 	return 0;
@@ -1860,19 +1871,52 @@ static void __set_abort_with_changes_flags(struct dm_pool_metadata *pmd)
 int dm_pool_abort_metadata(struct dm_pool_metadata *pmd)
 {
 	int r = -EINVAL;
+	struct dm_block_manager *old_bm = NULL, *new_bm = NULL;
+
+	/* fail_io is double-checked with pmd->root_lock held below */
+	if (unlikely(pmd->fail_io))
+		return r;
+
+	/*
+	 * Replacement block manager (new_bm) is created and old_bm destroyed outside of
+	 * pmd root_lock to avoid ABBA deadlock that would result (due to life-cycle of
+	 * shrinker associated with the block manager's bufio client vs pmd root_lock).
+	 * - must take shrinker_rwsem without holding pmd->root_lock
+	 */
+	new_bm = dm_block_manager_create(pmd->bdev, THIN_METADATA_BLOCK_SIZE << SECTOR_SHIFT,
+					 THIN_MAX_CONCURRENT_LOCKS);
 
 	pmd_write_lock(pmd);
-	if (pmd->fail_io)
+	if (pmd->fail_io) {
+		pmd_write_unlock(pmd);
 		goto out;
+	}
 
 	__set_abort_with_changes_flags(pmd);
-	__destroy_persistent_data_objects(pmd);
-	r = __create_persistent_data_objects(pmd, false);
+	__destroy_persistent_data_objects(pmd, false);
+	old_bm = pmd->bm;
+	if (IS_ERR(new_bm)) {
+		DMERR("could not create block manager during abort");
+		pmd->bm = NULL;
+		r = PTR_ERR(new_bm);
+		goto out_unlock;
+	}
+
+	pmd->bm = new_bm;
+	r = __open_or_format_metadata(pmd, false);
+	if (r) {
+		pmd->bm = NULL;
+		goto out_unlock;
+	}
+	new_bm = NULL;
+out_unlock:
 	if (r)
 		pmd->fail_io = true;
-
-out:
 	pmd_write_unlock(pmd);
+	dm_block_manager_destroy(old_bm);
+out:
+	if (new_bm && !IS_ERR(new_bm))
+		dm_block_manager_destroy(new_bm);
 
 	return r;
 }
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index e76c96c760a9..196f82559ad6 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2889,6 +2889,8 @@ static void __pool_destroy(struct pool *pool)
 	dm_bio_prison_destroy(pool->prison);
 	dm_kcopyd_client_destroy(pool->copier);
 
+	cancel_delayed_work_sync(&pool->waker);
+	cancel_delayed_work_sync(&pool->no_space_timeout);
 	if (pool->wq)
 		destroy_workqueue(pool->wq);
 
@@ -3540,20 +3542,28 @@ static int pool_preresume(struct dm_target *ti)
 	 */
 	r = bind_control_target(pool, ti);
 	if (r)
-		return r;
+		goto out;
 
 	r = maybe_resize_data_dev(ti, &need_commit1);
 	if (r)
-		return r;
+		goto out;
 
 	r = maybe_resize_metadata_dev(ti, &need_commit2);
 	if (r)
-		return r;
+		goto out;
 
 	if (need_commit1 || need_commit2)
 		(void) commit(pool);
+out:
+	/*
+	 * When a thin-pool is PM_FAIL, it cannot be rebuilt if
+	 * bio is in deferred list. Therefore need to return 0
+	 * to allow pool_resume() to flush IO.
+	 */
+	if (r && get_pool_mode(pool) == PM_FAIL)
+		r = 0;
 
-	return 0;
+	return r;
 }
 
 static void pool_suspend_active_thins(struct pool *pool)
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 63ece30114e5..e7cc6ba1b657 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -486,7 +486,7 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
 	sb = kmap_atomic(bitmap->storage.sb_page);
 	pr_debug("%s: bitmap file superblock:\n", bmname(bitmap));
 	pr_debug("         magic: %08x\n", le32_to_cpu(sb->magic));
-	pr_debug("       version: %d\n", le32_to_cpu(sb->version));
+	pr_debug("       version: %u\n", le32_to_cpu(sb->version));
 	pr_debug("          uuid: %08x.%08x.%08x.%08x\n",
 		 le32_to_cpu(*(__le32 *)(sb->uuid+0)),
 		 le32_to_cpu(*(__le32 *)(sb->uuid+4)),
@@ -497,11 +497,11 @@ void md_bitmap_print_sb(struct bitmap *bitmap)
 	pr_debug("events cleared: %llu\n",
 		 (unsigned long long) le64_to_cpu(sb->events_cleared));
 	pr_debug("         state: %08x\n", le32_to_cpu(sb->state));
-	pr_debug("     chunksize: %d B\n", le32_to_cpu(sb->chunksize));
-	pr_debug("  daemon sleep: %ds\n", le32_to_cpu(sb->daemon_sleep));
+	pr_debug("     chunksize: %u B\n", le32_to_cpu(sb->chunksize));
+	pr_debug("  daemon sleep: %us\n", le32_to_cpu(sb->daemon_sleep));
 	pr_debug("     sync size: %llu KB\n",
 		 (unsigned long long)le64_to_cpu(sb->sync_size)/2);
-	pr_debug("max write behind: %d\n", le32_to_cpu(sb->write_behind));
+	pr_debug("max write behind: %u\n", le32_to_cpu(sb->write_behind));
 	kunmap_atomic(sb);
 }
 
@@ -2105,7 +2105,8 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 			bytes = DIV_ROUND_UP(chunks, 8);
 			if (!bitmap->mddev->bitmap_info.external)
 				bytes += sizeof(bitmap_super_t);
-		} while (bytes > (space << 9));
+		} while (bytes > (space << 9) && (chunkshift + BITMAP_BLOCK_SHIFT) <
+			(BITS_PER_BYTE * sizeof(((bitmap_super_t *)0)->chunksize) - 1));
 	} else
 		chunkshift = ffz(~chunksize) - BITMAP_BLOCK_SHIFT;
 
@@ -2150,7 +2151,7 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	bitmap->counts.missing_pages = pages;
 	bitmap->counts.chunkshift = chunkshift;
 	bitmap->counts.chunks = chunks;
-	bitmap->mddev->bitmap_info.chunksize = 1 << (chunkshift +
+	bitmap->mddev->bitmap_info.chunksize = 1UL << (chunkshift +
 						     BITMAP_BLOCK_SHIFT);
 
 	blocks = min(old_counts.chunks << old_counts.chunkshift,
@@ -2176,8 +2177,8 @@ int md_bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 				bitmap->counts.missing_pages = old_counts.pages;
 				bitmap->counts.chunkshift = old_counts.chunkshift;
 				bitmap->counts.chunks = old_counts.chunks;
-				bitmap->mddev->bitmap_info.chunksize = 1 << (old_counts.chunkshift +
-									     BITMAP_BLOCK_SHIFT);
+				bitmap->mddev->bitmap_info.chunksize =
+					1UL << (old_counts.chunkshift + BITMAP_BLOCK_SHIFT);
 				blocks = old_counts.chunks << old_counts.chunkshift;
 				pr_warn("Could not pre-allocate in-memory bitmap for cluster raid\n");
 				break;
@@ -2537,6 +2538,9 @@ chunksize_store(struct mddev *mddev, const char *buf, size_t len)
 	if (csize < 512 ||
 	    !is_power_of_2(csize))
 		return -EINVAL;
+	if (BITS_PER_LONG > 32 && csize >= (1ULL << (BITS_PER_BYTE *
+		sizeof(((bitmap_super_t *)0)->chunksize))))
+		return -EOVERFLOW;
 	mddev->bitmap_info.chunksize = csize;
 	return len;
 }
diff --git a/drivers/media/dvb-core/dmxdev.c b/drivers/media/dvb-core/dmxdev.c
index f6ee678107d3..9ce5f010de3f 100644
--- a/drivers/media/dvb-core/dmxdev.c
+++ b/drivers/media/dvb-core/dmxdev.c
@@ -790,6 +790,11 @@ static int dvb_demux_open(struct inode *inode, struct file *file)
 	if (mutex_lock_interruptible(&dmxdev->mutex))
 		return -ERESTARTSYS;
 
+	if (dmxdev->exit) {
+		mutex_unlock(&dmxdev->mutex);
+		return -ENODEV;
+	}
+
 	for (i = 0; i < dmxdev->filternum; i++)
 		if (dmxdev->filter[i].state == DMXDEV_STATE_FREE)
 			break;
@@ -1448,7 +1453,10 @@ EXPORT_SYMBOL(dvb_dmxdev_init);
 
 void dvb_dmxdev_release(struct dmxdev *dmxdev)
 {
+	mutex_lock(&dmxdev->mutex);
 	dmxdev->exit = 1;
+	mutex_unlock(&dmxdev->mutex);
+
 	if (dmxdev->dvbdev->users > 1) {
 		wait_event(dmxdev->dvbdev->wait_queue,
 				dmxdev->dvbdev->users == 1);
diff --git a/drivers/media/dvb-core/dvbdev.c b/drivers/media/dvb-core/dvbdev.c
index 9934728734af..a31d52cb6d62 100644
--- a/drivers/media/dvb-core/dvbdev.c
+++ b/drivers/media/dvb-core/dvbdev.c
@@ -335,6 +335,7 @@ static int dvb_create_media_entity(struct dvb_device *dvbdev,
 				       GFP_KERNEL);
 		if (!dvbdev->pads) {
 			kfree(dvbdev->entity);
+			dvbdev->entity = NULL;
 			return -ENOMEM;
 		}
 	}
diff --git a/drivers/media/dvb-frontends/stv0288.c b/drivers/media/dvb-frontends/stv0288.c
index 3d54a0ec86af..3ae1f3a2f142 100644
--- a/drivers/media/dvb-frontends/stv0288.c
+++ b/drivers/media/dvb-frontends/stv0288.c
@@ -440,9 +440,8 @@ static int stv0288_set_frontend(struct dvb_frontend *fe)
 	struct stv0288_state *state = fe->demodulator_priv;
 	struct dtv_frontend_properties *c = &fe->dtv_property_cache;
 
-	char tm;
-	unsigned char tda[3];
-	u8 reg, time_out = 0;
+	u8 tda[3], reg, time_out = 0;
+	s8 tm;
 
 	dprintk("%s : FE_SET_FRONTEND\n", __func__);
 
diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_ctrl.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_ctrl.c
index 72d70984e99a..6d3c92045c05 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_ctrl.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_ctrl.c
@@ -468,8 +468,10 @@ void s5p_mfc_close_mfc_inst(struct s5p_mfc_dev *dev, struct s5p_mfc_ctx *ctx)
 	s5p_mfc_hw_call(dev->mfc_ops, try_run, dev);
 	/* Wait until instance is returned or timeout occurred */
 	if (s5p_mfc_wait_for_done_ctx(ctx,
-				S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0))
+				S5P_MFC_R2H_CMD_CLOSE_INSTANCE_RET, 0)){
+		clear_work_bit_irqsave(ctx);
 		mfc_err("Err returning instance\n");
+	}
 
 	/* Free resources */
 	s5p_mfc_hw_call(dev->mfc_ops, release_codec_buffers, ctx);
diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c
index b65e506665af..f62703cebb77 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_enc.c
@@ -1218,6 +1218,7 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 	unsigned long mb_y_addr, mb_c_addr;
 	int slice_type;
 	unsigned int strm_size;
+	bool src_ready;
 
 	slice_type = s5p_mfc_hw_call(dev->mfc_ops, get_enc_slice_type, dev);
 	strm_size = s5p_mfc_hw_call(dev->mfc_ops, get_enc_strm_size, dev);
@@ -1257,7 +1258,8 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 			}
 		}
 	}
-	if ((ctx->src_queue_cnt > 0) && (ctx->state == MFCINST_RUNNING)) {
+	if (ctx->src_queue_cnt > 0 && (ctx->state == MFCINST_RUNNING ||
+				       ctx->state == MFCINST_FINISHING)) {
 		mb_entry = list_entry(ctx->src_queue.next, struct s5p_mfc_buf,
 									list);
 		if (mb_entry->flags & MFC_BUF_FLAG_USED) {
@@ -1288,7 +1290,13 @@ static int enc_post_frame_start(struct s5p_mfc_ctx *ctx)
 		vb2_set_plane_payload(&mb_entry->b->vb2_buf, 0, strm_size);
 		vb2_buffer_done(&mb_entry->b->vb2_buf, VB2_BUF_STATE_DONE);
 	}
-	if ((ctx->src_queue_cnt == 0) || (ctx->dst_queue_cnt == 0))
+
+	src_ready = true;
+	if (ctx->state == MFCINST_RUNNING && ctx->src_queue_cnt == 0)
+		src_ready = false;
+	if (ctx->state == MFCINST_FINISHING && ctx->ref_queue_cnt == 0)
+		src_ready = false;
+	if (!src_ready || ctx->dst_queue_cnt == 0)
 		clear_work_bit(ctx);
 
 	return 0;
diff --git a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c
index 8227004f6746..c0df5ac9fcff 100644
--- a/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c
+++ b/drivers/media/platform/samsung/s5p-mfc/s5p_mfc_opr_v6.c
@@ -1060,7 +1060,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	}
 
 	/* aspect ratio VUI */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 5);
 	reg |= ((p_h264->vui_sar & 0x1) << 5);
 	writel(reg, mfc_regs->e_h264_options);
@@ -1083,7 +1083,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 
 	/* intra picture period for H.264 open GOP */
 	/* control */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 4);
 	reg |= ((p_h264->open_gop & 0x1) << 4);
 	writel(reg, mfc_regs->e_h264_options);
@@ -1097,23 +1097,23 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	}
 
 	/* 'WEIGHTED_BI_PREDICTION' for B is disable */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x3 << 9);
 	writel(reg, mfc_regs->e_h264_options);
 
 	/* 'CONSTRAINED_INTRA_PRED_ENABLE' is disable */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 14);
 	writel(reg, mfc_regs->e_h264_options);
 
 	/* ASO */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 6);
 	reg |= ((p_h264->aso & 0x1) << 6);
 	writel(reg, mfc_regs->e_h264_options);
 
 	/* hier qp enable */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 8);
 	reg |= ((p_h264->open_gop & 0x1) << 8);
 	writel(reg, mfc_regs->e_h264_options);
@@ -1134,7 +1134,7 @@ static int s5p_mfc_set_enc_params_h264(struct s5p_mfc_ctx *ctx)
 	writel(reg, mfc_regs->e_h264_num_t_layer);
 
 	/* frame packing SEI generation */
-	readl(mfc_regs->e_h264_options);
+	reg = readl(mfc_regs->e_h264_options);
 	reg &= ~(0x1 << 25);
 	reg |= ((p_h264->sei_frame_packing & 0x1) << 25);
 	writel(reg, mfc_regs->e_h264_options);
diff --git a/drivers/mmc/host/sdhci-sprd.c b/drivers/mmc/host/sdhci-sprd.c
index bec3f9e3cd3f..525f979e2a97 100644
--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -228,13 +228,15 @@ static inline void _sdhci_sprd_set_clock(struct sdhci_host *host,
 	div = ((div & 0x300) >> 2) | ((div & 0xFF) << 8);
 	sdhci_enable_clk(host, div);
 
-	/* enable auto gate sdhc_enable_auto_gate */
-	val = sdhci_readl(host, SDHCI_SPRD_REG_32_BUSY_POSI);
-	mask = SDHCI_SPRD_BIT_OUTR_CLK_AUTO_EN |
-	       SDHCI_SPRD_BIT_INNR_CLK_AUTO_EN;
-	if (mask != (val & mask)) {
-		val |= mask;
-		sdhci_writel(host, val, SDHCI_SPRD_REG_32_BUSY_POSI);
+	/* Enable CLK_AUTO when the clock is greater than 400K. */
+	if (clk > 400000) {
+		val = sdhci_readl(host, SDHCI_SPRD_REG_32_BUSY_POSI);
+		mask = SDHCI_SPRD_BIT_OUTR_CLK_AUTO_EN |
+			SDHCI_SPRD_BIT_INNR_CLK_AUTO_EN;
+		if (mask != (val & mask)) {
+			val |= mask;
+			sdhci_writel(host, val, SDHCI_SPRD_REG_32_BUSY_POSI);
+		}
 	}
 }
 
diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 0cf1a1797ea3..2e0655c0b606 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1184,6 +1184,8 @@ spi_nor_find_best_erase_type(const struct spi_nor_erase_map *map,
 			continue;
 
 		erase = &map->erase_type[i];
+		if (!erase->size)
+			continue;
 
 		/* Alignment is not mandatory for overlaid regions */
 		if (region->offset & SNOR_OVERLAID_REGION &&
diff --git a/drivers/mtd/spi-nor/gigadevice.c b/drivers/mtd/spi-nor/gigadevice.c
index 119b38e6fc2a..d57ddaf1525b 100644
--- a/drivers/mtd/spi-nor/gigadevice.c
+++ b/drivers/mtd/spi-nor/gigadevice.c
@@ -8,19 +8,29 @@
 
 #include "core.h"
 
-static void gd25q256_default_init(struct spi_nor *nor)
+static int
+gd25q256_post_bfpt(struct spi_nor *nor,
+		   const struct sfdp_parameter_header *bfpt_header,
+		   const struct sfdp_bfpt *bfpt)
 {
 	/*
-	 * Some manufacturer like GigaDevice may use different
-	 * bit to set QE on different memories, so the MFR can't
-	 * indicate the quad_enable method for this case, we need
-	 * to set it in the default_init fixup hook.
+	 * GD25Q256C supports the first version of JESD216 which does not define
+	 * the Quad Enable methods. Overwrite the default Quad Enable method.
+	 *
+	 * GD25Q256 GENERATION | SFDP MAJOR VERSION | SFDP MINOR VERSION
+	 *      GD25Q256C      | SFDP_JESD216_MAJOR | SFDP_JESD216_MINOR
+	 *      GD25Q256D      | SFDP_JESD216_MAJOR | SFDP_JESD216B_MINOR
+	 *      GD25Q256E      | SFDP_JESD216_MAJOR | SFDP_JESD216B_MINOR
 	 */
-	nor->params->quad_enable = spi_nor_sr1_bit6_quad_enable;
+	if (bfpt_header->major == SFDP_JESD216_MAJOR &&
+	    bfpt_header->minor == SFDP_JESD216_MINOR)
+		nor->params->quad_enable = spi_nor_sr1_bit6_quad_enable;
+
+	return 0;
 }
 
 static const struct spi_nor_fixups gd25q256_fixups = {
-	.default_init = gd25q256_default_init,
+	.post_bfpt = gd25q256_post_bfpt,
 };
 
 static const struct flash_info gigadevice_nor_parts[] = {
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index 33f723a9f471..b4e0fc7f65bd 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2903,12 +2903,12 @@ static int ravb_remove(struct platform_device *pdev)
 			  priv->desc_bat_dma);
 	/* Set reset mode */
 	ravb_write(ndev, CCC_OPC_RESET, CCC);
-	pm_runtime_put_sync(&pdev->dev);
 	unregister_netdev(ndev);
 	if (info->nc_queues)
 		netif_napi_del(&priv->napi[RAVB_NC]);
 	netif_napi_del(&priv->napi[RAVB_BE]);
 	ravb_mdio_release(priv);
+	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 	reset_control_assert(priv->rstc);
 	free_netdev(ndev);
diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index 7390f94cd4ca..a05bda7b9a3b 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -20,6 +20,7 @@ static const struct sdio_device_id wilc_sdio_ids[] = {
 	{ SDIO_DEVICE(SDIO_VENDOR_ID_MICROCHIP_WILC, SDIO_DEVICE_ID_MICROCHIP_WILC1000) },
 	{ },
 };
+MODULE_DEVICE_TABLE(sdio, wilc_sdio_ids);
 
 #define WILC_SDIO_BLOCK_SIZE 512
 
diff --git a/drivers/of/kexec.c b/drivers/of/kexec.c
index e6c01db393f9..f26d2ba8a371 100644
--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -281,7 +281,7 @@ void *of_kexec_alloc_and_setup_fdt(const struct kimage *image,
 				   const char *cmdline, size_t extra_fdt_size)
 {
 	void *fdt;
-	int ret, chosen_node;
+	int ret, chosen_node, len;
 	const void *prop;
 	size_t fdt_size;
 
@@ -324,19 +324,19 @@ void *of_kexec_alloc_and_setup_fdt(const struct kimage *image,
 		goto out;
 
 	/* Did we boot using an initrd? */
-	prop = fdt_getprop(fdt, chosen_node, "linux,initrd-start", NULL);
+	prop = fdt_getprop(fdt, chosen_node, "linux,initrd-start", &len);
 	if (prop) {
 		u64 tmp_start, tmp_end, tmp_size;
 
-		tmp_start = fdt64_to_cpu(*((const fdt64_t *) prop));
+		tmp_start = of_read_number(prop, len / 4);
 
-		prop = fdt_getprop(fdt, chosen_node, "linux,initrd-end", NULL);
+		prop = fdt_getprop(fdt, chosen_node, "linux,initrd-end", &len);
 		if (!prop) {
 			ret = -EINVAL;
 			goto out;
 		}
 
-		tmp_end = fdt64_to_cpu(*((const fdt64_t *) prop));
+		tmp_end = of_read_number(prop, len / 4);
 
 		/*
 		 * kexec reserves exact initrd size, while firmware may
diff --git a/drivers/parisc/led.c b/drivers/parisc/led.c
index d4be9d2ee74d..8bdc5e043831 100644
--- a/drivers/parisc/led.c
+++ b/drivers/parisc/led.c
@@ -137,6 +137,9 @@ static int start_task(void)
 
 	/* Create the work queue and queue the LED task */
 	led_wq = create_singlethread_workqueue("led_wq");	
+	if (!led_wq)
+		return -ENOMEM;
+
 	queue_delayed_work(led_wq, &led_task, 0);
 
 	return 0;
diff --git a/drivers/pci/doe.c b/drivers/pci/doe.c
index e402f05068a5..66d9ab288646 100644
--- a/drivers/pci/doe.c
+++ b/drivers/pci/doe.c
@@ -29,6 +29,9 @@
 #define PCI_DOE_FLAG_CANCEL	0
 #define PCI_DOE_FLAG_DEAD	1
 
+/* Max data object length is 2^18 dwords */
+#define PCI_DOE_MAX_LENGTH	(1 << 18)
+
 /**
  * struct pci_doe_mb - State for a single DOE mailbox
  *
@@ -107,6 +110,7 @@ static int pci_doe_send_req(struct pci_doe_mb *doe_mb,
 {
 	struct pci_dev *pdev = doe_mb->pdev;
 	int offset = doe_mb->cap_offset;
+	size_t length;
 	u32 val;
 	int i;
 
@@ -123,15 +127,20 @@ static int pci_doe_send_req(struct pci_doe_mb *doe_mb,
 	if (FIELD_GET(PCI_DOE_STATUS_ERROR, val))
 		return -EIO;
 
+	/* Length is 2 DW of header + length of payload in DW */
+	length = 2 + task->request_pl_sz / sizeof(u32);
+	if (length > PCI_DOE_MAX_LENGTH)
+		return -EIO;
+	if (length == PCI_DOE_MAX_LENGTH)
+		length = 0;
+
 	/* Write DOE Header */
 	val = FIELD_PREP(PCI_DOE_DATA_OBJECT_HEADER_1_VID, task->prot.vid) |
 		FIELD_PREP(PCI_DOE_DATA_OBJECT_HEADER_1_TYPE, task->prot.type);
 	pci_write_config_dword(pdev, offset + PCI_DOE_WRITE, val);
-	/* Length is 2 DW of header + length of payload in DW */
 	pci_write_config_dword(pdev, offset + PCI_DOE_WRITE,
 			       FIELD_PREP(PCI_DOE_DATA_OBJECT_HEADER_2_LENGTH,
-					  2 + task->request_pl_sz /
-						sizeof(u32)));
+					  length));
 	for (i = 0; i < task->request_pl_sz / sizeof(u32); i++)
 		pci_write_config_dword(pdev, offset + PCI_DOE_WRITE,
 				       task->request_pl[i]);
@@ -178,7 +187,10 @@ static int pci_doe_recv_resp(struct pci_doe_mb *doe_mb, struct pci_doe_task *tas
 	pci_write_config_dword(pdev, offset + PCI_DOE_READ, 0);
 
 	length = FIELD_GET(PCI_DOE_DATA_OBJECT_HEADER_2_LENGTH, val);
-	if (length > SZ_1M || length < 2)
+	/* A value of 0x0 indicates max data object length */
+	if (!length)
+		length = PCI_DOE_MAX_LENGTH;
+	if (length < 2)
 		return -EIO;
 
 	/* First 2 dwords have already been read */
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 0a2eeb82cebd..ba38fc47d35e 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1175,11 +1175,9 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 
 	sysfs_bin_attr_init(res_attr);
 	if (write_combine) {
-		pdev->res_attr_wc[num] = res_attr;
 		sprintf(res_attr_name, "resource%d_wc", num);
 		res_attr->mmap = pci_mmap_resource_wc;
 	} else {
-		pdev->res_attr[num] = res_attr;
 		sprintf(res_attr_name, "resource%d", num);
 		if (pci_resource_flags(pdev, num) & IORESOURCE_IO) {
 			res_attr->read = pci_read_resource_io;
@@ -1197,10 +1195,17 @@ static int pci_create_attr(struct pci_dev *pdev, int num, int write_combine)
 	res_attr->size = pci_resource_len(pdev, num);
 	res_attr->private = (void *)(unsigned long)num;
 	retval = sysfs_create_bin_file(&pdev->dev.kobj, res_attr);
-	if (retval)
+	if (retval) {
 		kfree(res_attr);
+		return retval;
+	}
+
+	if (write_combine)
+		pdev->res_attr_wc[num] = res_attr;
+	else
+		pdev->res_attr[num] = res_attr;
 
-	return retval;
+	return 0;
 }
 
 /**
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 2127aba3550b..ab615ab4e440 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -6447,6 +6447,8 @@ bool pci_device_is_present(struct pci_dev *pdev)
 {
 	u32 v;
 
+	/* Check PF if pdev is a VF, since VF Vendor/Device IDs are 0xffff */
+	pdev = pci_physfn(pdev);
 	if (pci_dev_is_disconnected(pdev))
 		return false;
 	return pci_bus_read_dev_vendor_id(pdev->bus, pdev->devfn, &v, 0);
diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index ba9d761ec49a..91f8ee79000d 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -1121,9 +1121,46 @@ static const struct qmp_phy_cfg sdm845_usb3phy_cfg = {
 	.pwrdn_delay_max	= POWER_DOWN_DELAY_US_MAX,
 };
 
+static const struct qmp_phy_cfg sdm845_dpphy_cfg = {
+	.type			= PHY_TYPE_DP,
+	.lanes			= 2,
+
+	.serdes_tbl		= qmp_v3_dp_serdes_tbl,
+	.serdes_tbl_num		= ARRAY_SIZE(qmp_v3_dp_serdes_tbl),
+	.tx_tbl			= qmp_v3_dp_tx_tbl,
+	.tx_tbl_num		= ARRAY_SIZE(qmp_v3_dp_tx_tbl),
+
+	.serdes_tbl_rbr		= qmp_v3_dp_serdes_tbl_rbr,
+	.serdes_tbl_rbr_num	= ARRAY_SIZE(qmp_v3_dp_serdes_tbl_rbr),
+	.serdes_tbl_hbr		= qmp_v3_dp_serdes_tbl_hbr,
+	.serdes_tbl_hbr_num	= ARRAY_SIZE(qmp_v3_dp_serdes_tbl_hbr),
+	.serdes_tbl_hbr2	= qmp_v3_dp_serdes_tbl_hbr2,
+	.serdes_tbl_hbr2_num	= ARRAY_SIZE(qmp_v3_dp_serdes_tbl_hbr2),
+	.serdes_tbl_hbr3	= qmp_v3_dp_serdes_tbl_hbr3,
+	.serdes_tbl_hbr3_num	= ARRAY_SIZE(qmp_v3_dp_serdes_tbl_hbr3),
+
+	.swing_hbr_rbr		= &qmp_dp_v3_voltage_swing_hbr_rbr,
+	.pre_emphasis_hbr_rbr	= &qmp_dp_v3_pre_emphasis_hbr_rbr,
+	.swing_hbr3_hbr2	= &qmp_dp_v3_voltage_swing_hbr3_hbr2,
+	.pre_emphasis_hbr3_hbr2 = &qmp_dp_v3_pre_emphasis_hbr3_hbr2,
+
+	.clk_list		= qmp_v3_phy_clk_l,
+	.num_clks		= ARRAY_SIZE(qmp_v3_phy_clk_l),
+	.reset_list		= msm8996_usb3phy_reset_l,
+	.num_resets		= ARRAY_SIZE(msm8996_usb3phy_reset_l),
+	.vreg_list		= qmp_phy_vreg_l,
+	.num_vregs		= ARRAY_SIZE(qmp_phy_vreg_l),
+	.regs			= qmp_v3_usb3phy_regs_layout,
+
+	.dp_aux_init = qcom_qmp_v3_phy_dp_aux_init,
+	.configure_dp_tx = qcom_qmp_v3_phy_configure_dp_tx,
+	.configure_dp_phy = qcom_qmp_v3_phy_configure_dp_phy,
+	.calibrate_dp_phy = qcom_qmp_v3_dp_phy_calibrate,
+};
+
 static const struct qmp_phy_combo_cfg sdm845_usb3dpphy_cfg = {
 	.usb_cfg                = &sdm845_usb3phy_cfg,
-	.dp_cfg                 = &sc7180_dpphy_cfg,
+	.dp_cfg                 = &sdm845_dpphy_cfg,
 };
 
 static const struct qmp_phy_cfg sm8150_usb3phy_cfg = {
@@ -1184,8 +1221,8 @@ static const struct qmp_phy_cfg sc8180x_dpphy_cfg = {
 
 	.clk_list		= qmp_v3_phy_clk_l,
 	.num_clks		= ARRAY_SIZE(qmp_v3_phy_clk_l),
-	.reset_list		= sc7180_usb3phy_reset_l,
-	.num_resets		= ARRAY_SIZE(sc7180_usb3phy_reset_l),
+	.reset_list		= msm8996_usb3phy_reset_l,
+	.num_resets		= ARRAY_SIZE(msm8996_usb3phy_reset_l),
 	.vreg_list		= qmp_phy_vreg_l,
 	.num_vregs		= ARRAY_SIZE(qmp_phy_vreg_l),
 	.regs			= qmp_v3_usb3phy_regs_layout,
@@ -1328,8 +1365,8 @@ static const struct qmp_phy_cfg sm8250_dpphy_cfg = {
 	.swing_hbr3_hbr2	= &qmp_dp_v3_voltage_swing_hbr3_hbr2,
 	.pre_emphasis_hbr3_hbr2 = &qmp_dp_v3_pre_emphasis_hbr3_hbr2,
 
-	.clk_list		= qmp_v4_phy_clk_l,
-	.num_clks		= ARRAY_SIZE(qmp_v4_phy_clk_l),
+	.clk_list		= qmp_v4_sm8250_usbphy_clk_l,
+	.num_clks		= ARRAY_SIZE(qmp_v4_sm8250_usbphy_clk_l),
 	.reset_list		= msm8996_usb3phy_reset_l,
 	.num_resets		= ARRAY_SIZE(msm8996_usb3phy_reset_l),
 	.vreg_list		= qmp_phy_vreg_l,
diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 3ea8fc6a9ca3..fc3d47a75944 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -30,6 +30,7 @@
 #include <linux/seq_file.h>
 #include <linux/sysfs.h>
 #include <linux/types.h>
+#include <linux/wmi.h>
 
 #include <acpi/video.h>
 
@@ -37,20 +38,23 @@
 
 #define IDEAPAD_RFKILL_DEV_NUM	3
 
-#if IS_ENABLED(CONFIG_ACPI_WMI)
-static const char *const ideapad_wmi_fnesc_events[] = {
-	"26CAB2E5-5CF1-46AE-AAC3-4A12B6BA50E6", /* Yoga 3 */
-	"56322276-8493-4CE8-A783-98C991274F5E", /* Yoga 700 */
-	"8FC0DE0C-B4E4-43FD-B0F3-8871711C1294", /* Legion 5 */
-};
-#endif
-
 enum {
 	CFG_CAP_BT_BIT       = 16,
 	CFG_CAP_3G_BIT       = 17,
 	CFG_CAP_WIFI_BIT     = 18,
 	CFG_CAP_CAM_BIT      = 19,
-	CFG_CAP_TOUCHPAD_BIT = 30,
+
+	/*
+	 * These are OnScreenDisplay support bits that can be useful to determine
+	 * whether a hotkey exists/should show OSD. But they aren't particularly
+	 * meaningful since they were introduced later, i.e. 2010 IdeaPads
+	 * don't have these, but they still have had OSD for hotkeys.
+	 */
+	CFG_OSD_NUMLK_BIT    = 27,
+	CFG_OSD_CAPSLK_BIT   = 28,
+	CFG_OSD_MICMUTE_BIT  = 29,
+	CFG_OSD_TOUCHPAD_BIT = 30,
+	CFG_OSD_CAM_BIT      = 31,
 };
 
 enum {
@@ -130,7 +134,7 @@ struct ideapad_private {
 	struct ideapad_dytc_priv *dytc;
 	struct dentry *debug;
 	unsigned long cfg;
-	const char *fnesc_guid;
+	unsigned long r_touchpad_val;
 	struct {
 		bool conservation_mode    : 1;
 		bool dytc                 : 1;
@@ -140,6 +144,7 @@ struct ideapad_private {
 		bool hw_rfkill_switch     : 1;
 		bool kbd_bl               : 1;
 		bool touchpad_ctrl_via_ec : 1;
+		bool ctrl_ps2_aux_port    : 1;
 		bool usb_charging         : 1;
 	} features;
 	struct {
@@ -171,6 +176,48 @@ MODULE_PARM_DESC(set_fn_lock_led,
 	"Enable driver based updates of the fn-lock LED on fn-lock changes. "
 	"If you need this please report this to: platform-driver-x86@vger.kernel.org");
 
+static bool ctrl_ps2_aux_port;
+module_param(ctrl_ps2_aux_port, bool, 0444);
+MODULE_PARM_DESC(ctrl_ps2_aux_port,
+	"Enable driver based PS/2 aux port en-/dis-abling on touchpad on/off toggle. "
+	"If you need this please report this to: platform-driver-x86@vger.kernel.org");
+
+/*
+ * shared data
+ */
+
+static struct ideapad_private *ideapad_shared;
+static DEFINE_MUTEX(ideapad_shared_mutex);
+
+static int ideapad_shared_init(struct ideapad_private *priv)
+{
+	int ret;
+
+	mutex_lock(&ideapad_shared_mutex);
+
+	if (!ideapad_shared) {
+		ideapad_shared = priv;
+		ret = 0;
+	} else {
+		dev_warn(&priv->adev->dev, "found multiple platform devices\n");
+		ret = -EINVAL;
+	}
+
+	mutex_unlock(&ideapad_shared_mutex);
+
+	return ret;
+}
+
+static void ideapad_shared_exit(struct ideapad_private *priv)
+{
+	mutex_lock(&ideapad_shared_mutex);
+
+	if (ideapad_shared == priv)
+		ideapad_shared = NULL;
+
+	mutex_unlock(&ideapad_shared_mutex);
+}
+
 /*
  * ACPI Helpers
  */
@@ -386,8 +433,19 @@ static int debugfs_cfg_show(struct seq_file *s, void *data)
 		seq_puts(s, " wifi");
 	if (test_bit(CFG_CAP_CAM_BIT, &priv->cfg))
 		seq_puts(s, " camera");
-	if (test_bit(CFG_CAP_TOUCHPAD_BIT, &priv->cfg))
+	seq_puts(s, "\n");
+
+	seq_puts(s, "OSD support:");
+	if (test_bit(CFG_OSD_NUMLK_BIT, &priv->cfg))
+		seq_puts(s, " num-lock");
+	if (test_bit(CFG_OSD_CAPSLK_BIT, &priv->cfg))
+		seq_puts(s, " caps-lock");
+	if (test_bit(CFG_OSD_MICMUTE_BIT, &priv->cfg))
+		seq_puts(s, " mic-mute");
+	if (test_bit(CFG_OSD_TOUCHPAD_BIT, &priv->cfg))
 		seq_puts(s, " touchpad");
+	if (test_bit(CFG_OSD_CAM_BIT, &priv->cfg))
+		seq_puts(s, " camera");
 	seq_puts(s, "\n");
 
 	seq_puts(s, "Graphics: ");
@@ -593,6 +651,8 @@ static ssize_t touchpad_show(struct device *dev,
 	if (err)
 		return err;
 
+	priv->r_touchpad_val = result;
+
 	return sysfs_emit(buf, "%d\n", !!result);
 }
 
@@ -612,6 +672,8 @@ static ssize_t touchpad_store(struct device *dev,
 	if (err)
 		return err;
 
+	priv->r_touchpad_val = state;
+
 	return count;
 }
 
@@ -680,8 +742,7 @@ static umode_t ideapad_is_visible(struct kobject *kobj,
 	else if (attr == &dev_attr_fn_lock.attr)
 		supported = priv->features.fn_lock;
 	else if (attr == &dev_attr_touchpad.attr)
-		supported = priv->features.touchpad_ctrl_via_ec &&
-			    test_bit(CFG_CAP_TOUCHPAD_BIT, &priv->cfg);
+		supported = priv->features.touchpad_ctrl_via_ec;
 	else if (attr == &dev_attr_usb_charging.attr)
 		supported = priv->features.usb_charging;
 
@@ -1089,6 +1150,8 @@ static void ideapad_sysfs_exit(struct ideapad_private *priv)
 /*
  * input device
  */
+#define IDEAPAD_WMI_KEY 0x100
+
 static const struct key_entry ideapad_keymap[] = {
 	{ KE_KEY,   6, { KEY_SWITCHVIDEOMODE } },
 	{ KE_KEY,   7, { KEY_CAMERA } },
@@ -1101,7 +1164,30 @@ static const struct key_entry ideapad_keymap[] = {
 	{ KE_KEY,  65, { KEY_PROG4 } },
 	{ KE_KEY,  66, { KEY_TOUCHPAD_OFF } },
 	{ KE_KEY,  67, { KEY_TOUCHPAD_ON } },
+	{ KE_KEY,  68, { KEY_TOUCHPAD_TOGGLE } },
 	{ KE_KEY, 128, { KEY_ESC } },
+
+	/*
+	 * WMI keys
+	 */
+
+	/* FnLock (handled by the firmware) */
+	{ KE_IGNORE,	0x02 | IDEAPAD_WMI_KEY },
+	/* Esc (handled by the firmware) */
+	{ KE_IGNORE,	0x03 | IDEAPAD_WMI_KEY },
+	/* Customizable Lenovo Hotkey ("star" with 'S' inside) */
+	{ KE_KEY,	0x01 | IDEAPAD_WMI_KEY, { KEY_FAVORITES } },
+	/* Dark mode toggle */
+	{ KE_KEY,	0x13 | IDEAPAD_WMI_KEY, { KEY_PROG1 } },
+	/* Sound profile switch */
+	{ KE_KEY,	0x12 | IDEAPAD_WMI_KEY, { KEY_PROG2 } },
+	/* Lenovo Virtual Background application */
+	{ KE_KEY,	0x28 | IDEAPAD_WMI_KEY, { KEY_PROG3 } },
+	/* Lenovo Support */
+	{ KE_KEY,	0x27 | IDEAPAD_WMI_KEY, { KEY_HELP } },
+	/* Refresh Rate Toggle */
+	{ KE_KEY,	0x0a | IDEAPAD_WMI_KEY, { KEY_DISPLAYTOGGLE } },
+
 	{ KE_END },
 };
 
@@ -1414,26 +1500,41 @@ static void ideapad_kbd_bl_exit(struct ideapad_private *priv)
 /*
  * module init/exit
  */
-static void ideapad_sync_touchpad_state(struct ideapad_private *priv)
+static void ideapad_sync_touchpad_state(struct ideapad_private *priv, bool send_events)
 {
 	unsigned long value;
+	unsigned char param;
+	int ret;
 
-	if (!priv->features.touchpad_ctrl_via_ec)
+	/* Without reading from EC touchpad LED doesn't switch state */
+	ret = read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &value);
+	if (ret)
 		return;
 
-	/* Without reading from EC touchpad LED doesn't switch state */
-	if (!read_ec_data(priv->adev->handle, VPCCMD_R_TOUCHPAD, &value)) {
-		unsigned char param;
+	/*
+	 * Some IdeaPads don't really turn off touchpad - they only
+	 * switch the LED state. We (de)activate KBC AUX port to turn
+	 * touchpad off and on. We send KEY_TOUCHPAD_OFF and
+	 * KEY_TOUCHPAD_ON to not to get out of sync with LED
+	 */
+	if (priv->features.ctrl_ps2_aux_port)
+		i8042_command(&param, value ? I8042_CMD_AUX_ENABLE : I8042_CMD_AUX_DISABLE);
+
+	if (send_events) {
 		/*
-		 * Some IdeaPads don't really turn off touchpad - they only
-		 * switch the LED state. We (de)activate KBC AUX port to turn
-		 * touchpad off and on. We send KEY_TOUCHPAD_OFF and
-		 * KEY_TOUCHPAD_ON to not to get out of sync with LED
+		 * On older models the EC controls the touchpad and toggles it
+		 * on/off itself, in this case we report KEY_TOUCHPAD_ON/_OFF.
+		 * If the EC did not toggle, report KEY_TOUCHPAD_TOGGLE.
 		 */
-		i8042_command(&param, value ? I8042_CMD_AUX_ENABLE : I8042_CMD_AUX_DISABLE);
-		ideapad_input_report(priv, value ? 67 : 66);
-		sysfs_notify(&priv->platform_device->dev.kobj, NULL, "touchpad");
+		if (value != priv->r_touchpad_val) {
+			ideapad_input_report(priv, value ? 67 : 66);
+			sysfs_notify(&priv->platform_device->dev.kobj, NULL, "touchpad");
+		} else {
+			ideapad_input_report(priv, 68);
+		}
 	}
+
+	priv->r_touchpad_val = value;
 }
 
 static void ideapad_acpi_notify(acpi_handle handle, u32 event, void *data)
@@ -1474,7 +1575,7 @@ static void ideapad_acpi_notify(acpi_handle handle, u32 event, void *data)
 			ideapad_sync_rfk_state(priv);
 			break;
 		case 5:
-			ideapad_sync_touchpad_state(priv);
+			ideapad_sync_touchpad_state(priv, true);
 			break;
 		case 4:
 			ideapad_backlight_notify_brightness(priv);
@@ -1505,33 +1606,6 @@ static void ideapad_acpi_notify(acpi_handle handle, u32 event, void *data)
 	}
 }
 
-#if IS_ENABLED(CONFIG_ACPI_WMI)
-static void ideapad_wmi_notify(u32 value, void *context)
-{
-	struct ideapad_private *priv = context;
-	unsigned long result;
-
-	switch (value) {
-	case 128:
-		ideapad_input_report(priv, value);
-		break;
-	case 208:
-		if (!priv->features.set_fn_lock_led)
-			break;
-
-		if (!eval_hals(priv->adev->handle, &result)) {
-			bool state = test_bit(HALS_FNLOCK_STATE_BIT, &result);
-
-			exec_sals(priv->adev->handle, state ? SALS_FNLOCK_ON : SALS_FNLOCK_OFF);
-		}
-		break;
-	default:
-		dev_info(&priv->platform_device->dev,
-			 "Unknown WMI event: %u\n", value);
-	}
-}
-#endif
-
 /* On some models we need to call exec_sals(SALS_FNLOCK_ON/OFF) to set the LED */
 static const struct dmi_system_id set_fn_lock_led_list[] = {
 	{
@@ -1563,6 +1637,23 @@ static const struct dmi_system_id hw_rfkill_list[] = {
 	{}
 };
 
+/*
+ * On some models the EC toggles the touchpad muted LED on touchpad toggle
+ * hotkey presses, but the EC does not actually disable the touchpad itself.
+ * On these models the driver needs to explicitly enable/disable the i8042
+ * (PS/2) aux port.
+ */
+static const struct dmi_system_id ctrl_ps2_aux_port_list[] = {
+	{
+	/* Lenovo Ideapad Z570 */
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "Ideapad Z570"),
+		},
+	},
+	{}
+};
+
 static const struct dmi_system_id no_touchpad_switch_list[] = {
 	{
 	.ident = "Lenovo Yoga 3 Pro 1370",
@@ -1590,6 +1681,8 @@ static void ideapad_check_features(struct ideapad_private *priv)
 		set_fn_lock_led || dmi_check_system(set_fn_lock_led_list);
 	priv->features.hw_rfkill_switch =
 		hw_rfkill_switch || dmi_check_system(hw_rfkill_list);
+	priv->features.ctrl_ps2_aux_port =
+		ctrl_ps2_aux_port || dmi_check_system(ctrl_ps2_aux_port_list);
 
 	/* Most ideapads with ELAN0634 touchpad don't use EC touchpad switch */
 	if (acpi_dev_present("ELAN0634", NULL, -1))
@@ -1622,6 +1715,118 @@ static void ideapad_check_features(struct ideapad_private *priv)
 	}
 }
 
+#if IS_ENABLED(CONFIG_ACPI_WMI)
+/*
+ * WMI driver
+ */
+enum ideapad_wmi_event_type {
+	IDEAPAD_WMI_EVENT_ESC,
+	IDEAPAD_WMI_EVENT_FN_KEYS,
+};
+
+struct ideapad_wmi_private {
+	enum ideapad_wmi_event_type event;
+};
+
+static int ideapad_wmi_probe(struct wmi_device *wdev, const void *context)
+{
+	struct ideapad_wmi_private *wpriv;
+
+	wpriv = devm_kzalloc(&wdev->dev, sizeof(*wpriv), GFP_KERNEL);
+	if (!wpriv)
+		return -ENOMEM;
+
+	*wpriv = *(const struct ideapad_wmi_private *)context;
+
+	dev_set_drvdata(&wdev->dev, wpriv);
+	return 0;
+}
+
+static void ideapad_wmi_notify(struct wmi_device *wdev, union acpi_object *data)
+{
+	struct ideapad_wmi_private *wpriv = dev_get_drvdata(&wdev->dev);
+	struct ideapad_private *priv;
+	unsigned long result;
+
+	mutex_lock(&ideapad_shared_mutex);
+
+	priv = ideapad_shared;
+	if (!priv)
+		goto unlock;
+
+	switch (wpriv->event) {
+	case IDEAPAD_WMI_EVENT_ESC:
+		ideapad_input_report(priv, 128);
+		break;
+	case IDEAPAD_WMI_EVENT_FN_KEYS:
+		if (priv->features.set_fn_lock_led &&
+		    !eval_hals(priv->adev->handle, &result)) {
+			bool state = test_bit(HALS_FNLOCK_STATE_BIT, &result);
+
+			exec_sals(priv->adev->handle, state ? SALS_FNLOCK_ON : SALS_FNLOCK_OFF);
+		}
+
+		if (data->type != ACPI_TYPE_INTEGER) {
+			dev_warn(&wdev->dev,
+				 "WMI event data is not an integer\n");
+			break;
+		}
+
+		dev_dbg(&wdev->dev, "WMI fn-key event: 0x%llx\n",
+			data->integer.value);
+
+		ideapad_input_report(priv,
+				     data->integer.value | IDEAPAD_WMI_KEY);
+
+		break;
+	}
+unlock:
+	mutex_unlock(&ideapad_shared_mutex);
+}
+
+static const struct ideapad_wmi_private ideapad_wmi_context_esc = {
+	.event = IDEAPAD_WMI_EVENT_ESC
+};
+
+static const struct ideapad_wmi_private ideapad_wmi_context_fn_keys = {
+	.event = IDEAPAD_WMI_EVENT_FN_KEYS
+};
+
+static const struct wmi_device_id ideapad_wmi_ids[] = {
+	{ "26CAB2E5-5CF1-46AE-AAC3-4A12B6BA50E6", &ideapad_wmi_context_esc }, /* Yoga 3 */
+	{ "56322276-8493-4CE8-A783-98C991274F5E", &ideapad_wmi_context_esc }, /* Yoga 700 */
+	{ "8FC0DE0C-B4E4-43FD-B0F3-8871711C1294", &ideapad_wmi_context_fn_keys }, /* Legion 5 */
+	{},
+};
+MODULE_DEVICE_TABLE(wmi, ideapad_wmi_ids);
+
+static struct wmi_driver ideapad_wmi_driver = {
+	.driver = {
+		.name = "ideapad_wmi",
+	},
+	.id_table = ideapad_wmi_ids,
+	.probe = ideapad_wmi_probe,
+	.notify = ideapad_wmi_notify,
+};
+
+static int ideapad_wmi_driver_register(void)
+{
+	return wmi_driver_register(&ideapad_wmi_driver);
+}
+
+static void ideapad_wmi_driver_unregister(void)
+{
+	return wmi_driver_unregister(&ideapad_wmi_driver);
+}
+
+#else
+static inline int ideapad_wmi_driver_register(void) { return 0; }
+static inline void ideapad_wmi_driver_unregister(void) { }
+#endif
+
+/*
+ * ACPI driver
+ */
 static int ideapad_acpi_add(struct platform_device *pdev)
 {
 	struct acpi_device *adev = ACPI_COMPANION(&pdev->dev);
@@ -1670,16 +1875,12 @@ static int ideapad_acpi_add(struct platform_device *pdev)
 	if (!priv->features.hw_rfkill_switch)
 		write_ec_cmd(priv->adev->handle, VPCCMD_W_RF, 1);
 
-	/* The same for Touchpad */
-	if (!priv->features.touchpad_ctrl_via_ec)
-		write_ec_cmd(priv->adev->handle, VPCCMD_W_TOUCHPAD, 1);
-
 	for (i = 0; i < IDEAPAD_RFKILL_DEV_NUM; i++)
 		if (test_bit(ideapad_rfk_data[i].cfgbit, &priv->cfg))
 			ideapad_register_rfkill(priv, i);
 
 	ideapad_sync_rfk_state(priv);
-	ideapad_sync_touchpad_state(priv);
+	ideapad_sync_touchpad_state(priv, false);
 
 	err = ideapad_dytc_profile_init(priv);
 	if (err) {
@@ -1703,30 +1904,16 @@ static int ideapad_acpi_add(struct platform_device *pdev)
 		goto notification_failed;
 	}
 
-#if IS_ENABLED(CONFIG_ACPI_WMI)
-	for (i = 0; i < ARRAY_SIZE(ideapad_wmi_fnesc_events); i++) {
-		status = wmi_install_notify_handler(ideapad_wmi_fnesc_events[i],
-						    ideapad_wmi_notify, priv);
-		if (ACPI_SUCCESS(status)) {
-			priv->fnesc_guid = ideapad_wmi_fnesc_events[i];
-			break;
-		}
-	}
-
-	if (ACPI_FAILURE(status) && status != AE_NOT_EXIST) {
-		err = -EIO;
-		goto notification_failed_wmi;
-	}
-#endif
+	err = ideapad_shared_init(priv);
+	if (err)
+		goto shared_init_failed;
 
 	return 0;
 
-#if IS_ENABLED(CONFIG_ACPI_WMI)
-notification_failed_wmi:
+shared_init_failed:
 	acpi_remove_notify_handler(priv->adev->handle,
 				   ACPI_DEVICE_NOTIFY,
 				   ideapad_acpi_notify);
-#endif
 
 notification_failed:
 	ideapad_backlight_exit(priv);
@@ -1752,10 +1939,7 @@ static int ideapad_acpi_remove(struct platform_device *pdev)
 	struct ideapad_private *priv = dev_get_drvdata(&pdev->dev);
 	int i;
 
-#if IS_ENABLED(CONFIG_ACPI_WMI)
-	if (priv->fnesc_guid)
-		wmi_remove_notify_handler(priv->fnesc_guid);
-#endif
+	ideapad_shared_exit(priv);
 
 	acpi_remove_notify_handler(priv->adev->handle,
 				   ACPI_DEVICE_NOTIFY,
@@ -1781,7 +1965,7 @@ static int ideapad_acpi_resume(struct device *dev)
 	struct ideapad_private *priv = dev_get_drvdata(dev);
 
 	ideapad_sync_rfk_state(priv);
-	ideapad_sync_touchpad_state(priv);
+	ideapad_sync_touchpad_state(priv, false);
 
 	if (priv->dytc)
 		dytc_profile_refresh(priv);
@@ -1807,7 +1991,30 @@ static struct platform_driver ideapad_acpi_driver = {
 	},
 };
 
-module_platform_driver(ideapad_acpi_driver);
+static int __init ideapad_laptop_init(void)
+{
+	int err;
+
+	err = ideapad_wmi_driver_register();
+	if (err)
+		return err;
+
+	err = platform_driver_register(&ideapad_acpi_driver);
+	if (err) {
+		ideapad_wmi_driver_unregister();
+		return err;
+	}
+
+	return 0;
+}
+module_init(ideapad_laptop_init)
+
+static void __exit ideapad_laptop_exit(void)
+{
+	ideapad_wmi_driver_unregister();
+	platform_driver_unregister(&ideapad_acpi_driver);
+}
+module_exit(ideapad_laptop_exit)
 
 MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
 MODULE_DESCRIPTION("IdeaPad ACPI Extras");
diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
index 8f9c571d7257..00ac7e381441 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
@@ -203,6 +203,7 @@ static const struct x86_cpu_id intel_uncore_cpu_ids[] = {
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_X,	NULL),
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D,	NULL),
 	X86_MATCH_INTEL_FAM6_MODEL(SAPPHIRERAPIDS_X, NULL),
+	X86_MATCH_INTEL_FAM6_MODEL(EMERALDRAPIDS_X, NULL),
 	{}
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_uncore_cpu_ids);
diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 8476dfef4e62..a1d91736a03b 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -5572,6 +5572,7 @@ static enum led_brightness light_sysfs_get(struct led_classdev *led_cdev)
 static struct tpacpi_led_classdev tpacpi_led_thinklight = {
 	.led_classdev = {
 		.name		= "tpacpi::thinklight",
+		.max_brightness	= 1,
 		.brightness_set_blocking = &light_sysfs_set,
 		.brightness_get	= &light_sysfs_get,
 	}
diff --git a/drivers/platform/x86/x86-android-tablets.c b/drivers/platform/x86/x86-android-tablets.c
index 4acd6fa8d43b..123a4618db55 100644
--- a/drivers/platform/x86/x86-android-tablets.c
+++ b/drivers/platform/x86/x86-android-tablets.c
@@ -5,7 +5,7 @@
  * devices typically have a bunch of things hardcoded, rather than specified
  * in their DSDT.
  *
- * Copyright (C) 2021 Hans de Goede <hdegoede@redhat.com>
+ * Copyright (C) 2021-2022 Hans de Goede <hdegoede@redhat.com>
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
@@ -265,6 +265,56 @@ static struct gpiod_lookup_table int3496_gpo2_pin22_gpios = {
 	},
 };
 
+/*
+ * Advantech MICA-071
+ * This is a standard Windows tablet, but it has an extra "quick launch" button
+ * which is not described in the ACPI tables in anyway.
+ * Use the x86-android-tablets infra to create a gpio-button device for this.
+ */
+static struct gpio_keys_button advantech_mica_071_button = {
+	.code = KEY_PROG1,
+	/* .gpio gets filled in by advantech_mica_071_init() */
+	.active_low = true,
+	.desc = "prog1_key",
+	.type = EV_KEY,
+	.wakeup = false,
+	.debounce_interval = 50,
+};
+
+static const struct gpio_keys_platform_data advantech_mica_071_button_pdata __initconst = {
+	.buttons = &advantech_mica_071_button,
+	.nbuttons = 1,
+	.name = "prog1_key",
+};
+
+static const struct platform_device_info advantech_mica_071_pdevs[] __initconst = {
+	{
+		.name = "gpio-keys",
+		.id = PLATFORM_DEVID_AUTO,
+		.data = &advantech_mica_071_button_pdata,
+		.size_data = sizeof(advantech_mica_071_button_pdata),
+	},
+};
+
+static int __init advantech_mica_071_init(void)
+{
+	struct gpio_desc *gpiod;
+	int ret;
+
+	ret = x86_android_tablet_get_gpiod("INT33FC:00", 2, &gpiod);
+	if (ret < 0)
+		return ret;
+	advantech_mica_071_button.gpio = desc_to_gpio(gpiod);
+
+	return 0;
+}
+
+static const struct x86_dev_info advantech_mica_071_info __initconst = {
+	.pdev_info = advantech_mica_071_pdevs,
+	.pdev_count = ARRAY_SIZE(advantech_mica_071_pdevs),
+	.init = advantech_mica_071_init,
+};
+
 /* Asus ME176C and TF103C tablets shared data */
 static struct gpio_keys_button asus_me176c_tf103c_lid = {
 	.code = SW_LID,
@@ -987,6 +1037,212 @@ static void lenovo_yoga_tab2_830_1050_exit(void)
 	}
 }
 
+/* Lenovo Yoga Tab 3 Pro YT3-X90F */
+
+/*
+ * There are 2 batteries, with 2 bq27500 fuel-gauges and 2 bq25892 chargers,
+ * "bq25890-charger-1" is instantiated from: drivers/i2c/busses/i2c-cht-wc.c.
+ */
+static const char * const lenovo_yt3_bq25892_0_suppliers[] = { "cht_wcove_pwrsrc" };
+static const char * const bq25890_1_psy[] = { "bq25890-charger-1" };
+
+static const struct property_entry fg_bq25890_1_supply_props[] = {
+	PROPERTY_ENTRY_STRING_ARRAY("supplied-from", bq25890_1_psy),
+	{ }
+};
+
+static const struct software_node fg_bq25890_1_supply_node = {
+	.properties = fg_bq25890_1_supply_props,
+};
+
+/* bq25892 charger settings for the flat lipo battery behind the screen */
+static const struct property_entry lenovo_yt3_bq25892_0_props[] = {
+	PROPERTY_ENTRY_STRING_ARRAY("supplied-from", lenovo_yt3_bq25892_0_suppliers),
+	PROPERTY_ENTRY_STRING("linux,power-supply-name", "bq25892-second-chrg"),
+	PROPERTY_ENTRY_U32("linux,iinlim-percentage", 40),
+	PROPERTY_ENTRY_BOOL("linux,skip-reset"),
+	/* Values taken from Android Factory Image */
+	PROPERTY_ENTRY_U32("ti,charge-current", 2048000),
+	PROPERTY_ENTRY_U32("ti,battery-regulation-voltage", 4352000),
+	PROPERTY_ENTRY_U32("ti,termination-current", 128000),
+	PROPERTY_ENTRY_U32("ti,precharge-current", 128000),
+	PROPERTY_ENTRY_U32("ti,minimum-sys-voltage", 3700000),
+	PROPERTY_ENTRY_U32("ti,boost-voltage", 4998000),
+	PROPERTY_ENTRY_U32("ti,boost-max-current", 500000),
+	PROPERTY_ENTRY_BOOL("ti,use-ilim-pin"),
+	{ }
+};
+
+static const struct software_node lenovo_yt3_bq25892_0_node = {
+	.properties = lenovo_yt3_bq25892_0_props,
+};
+
+static const struct x86_i2c_client_info lenovo_yt3_i2c_clients[] __initconst = {
+	{
+		/* bq27500 fuel-gauge for the flat lipo battery behind the screen */
+		.board_info = {
+			.type = "bq27500",
+			.addr = 0x55,
+			.dev_name = "bq27500_0",
+			.swnode = &fg_bq25890_supply_node,
+		},
+		.adapter_path = "\\_SB_.PCI0.I2C1",
+	}, {
+		/* bq25892 charger for the flat lipo battery behind the screen */
+		.board_info = {
+			.type = "bq25892",
+			.addr = 0x6b,
+			.dev_name = "bq25892_0",
+			.swnode = &lenovo_yt3_bq25892_0_node,
+		},
+		.adapter_path = "\\_SB_.PCI0.I2C1",
+		.irq_data = {
+			.type = X86_ACPI_IRQ_TYPE_GPIOINT,
+			.chip = "INT33FF:01",
+			.index = 5,
+			.trigger = ACPI_EDGE_SENSITIVE,
+			.polarity = ACPI_ACTIVE_LOW,
+		},
+	}, {
+		/* bq27500 fuel-gauge for the round li-ion cells in the hinge */
+		.board_info = {
+			.type = "bq27500",
+			.addr = 0x55,
+			.dev_name = "bq27500_1",
+			.swnode = &fg_bq25890_1_supply_node,
+		},
+		.adapter_path = "\\_SB_.PCI0.I2C2",
+	}
+};
+
+static int __init lenovo_yt3_init(void)
+{
+	struct gpio_desc *gpiod;
+	int ret;
+
+	/*
+	 * The "bq25892_0" charger IC has its /CE (Charge-Enable) and OTG pins
+	 * connected to GPIOs, rather then having them hardwired to the correct
+	 * values as is normally done.
+	 *
+	 * The bq25890_charger driver controls these through I2C, but this only
+	 * works if not overridden by the pins. Set these pins here:
+	 * 1. Set /CE to 0 to allow charging.
+	 * 2. Set OTG to 0 disable V5 boost output since the 5V boost output of
+	 *    the main "bq25892_1" charger is used when necessary.
+	 */
+
+	/* /CE pin */
+	ret = x86_android_tablet_get_gpiod("INT33FF:02", 22, &gpiod);
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * The gpio_desc returned by x86_android_tablet_get_gpiod() is a "raw"
+	 * gpio_desc, that is there is no way to pass lookup-flags like
+	 * GPIO_ACTIVE_LOW. Set the GPIO to 0 here to enable charging since
+	 * the /CE pin is active-low, but not marked as such in the gpio_desc.
+	 */
+	gpiod_set_value(gpiod, 0);
+
+	/* OTG pin */
+	ret = x86_android_tablet_get_gpiod("INT33FF:03", 19, &gpiod);
+	if (ret < 0)
+		return ret;
+
+	gpiod_set_value(gpiod, 0);
+
+	return 0;
+}
+
+static const struct x86_dev_info lenovo_yt3_info __initconst = {
+	.i2c_client_info = lenovo_yt3_i2c_clients,
+	.i2c_client_count = ARRAY_SIZE(lenovo_yt3_i2c_clients),
+	.init = lenovo_yt3_init,
+};
+
+/* Medion Lifetab S10346 tablets have an Android factory img with everything hardcoded */
+static const char * const medion_lifetab_s10346_accel_mount_matrix[] = {
+	"0", "1", "0",
+	"1", "0", "0",
+	"0", "0", "1"
+};
+
+static const struct property_entry medion_lifetab_s10346_accel_props[] = {
+	PROPERTY_ENTRY_STRING_ARRAY("mount-matrix", medion_lifetab_s10346_accel_mount_matrix),
+	{ }
+};
+
+static const struct software_node medion_lifetab_s10346_accel_node = {
+	.properties = medion_lifetab_s10346_accel_props,
+};
+
+/* Note the LCD panel is mounted upside down, this is correctly indicated in the VBT */
+static const struct property_entry medion_lifetab_s10346_touchscreen_props[] = {
+	PROPERTY_ENTRY_BOOL("touchscreen-inverted-x"),
+	PROPERTY_ENTRY_BOOL("touchscreen-swapped-x-y"),
+	{ }
+};
+
+static const struct software_node medion_lifetab_s10346_touchscreen_node = {
+	.properties = medion_lifetab_s10346_touchscreen_props,
+};
+
+static const struct x86_i2c_client_info medion_lifetab_s10346_i2c_clients[] __initconst = {
+	{
+		/* kxtj21009 accel */
+		.board_info = {
+			.type = "kxtj21009",
+			.addr = 0x0f,
+			.dev_name = "kxtj21009",
+			.swnode = &medion_lifetab_s10346_accel_node,
+		},
+		.adapter_path = "\\_SB_.I2C3",
+		.irq_data = {
+			.type = X86_ACPI_IRQ_TYPE_GPIOINT,
+			.chip = "INT33FC:02",
+			.index = 23,
+			.trigger = ACPI_EDGE_SENSITIVE,
+			.polarity = ACPI_ACTIVE_HIGH,
+		},
+	}, {
+		/* goodix touchscreen */
+		.board_info = {
+			.type = "GDIX1001:00",
+			.addr = 0x14,
+			.dev_name = "goodix_ts",
+			.swnode = &medion_lifetab_s10346_touchscreen_node,
+		},
+		.adapter_path = "\\_SB_.I2C4",
+		.irq_data = {
+			.type = X86_ACPI_IRQ_TYPE_APIC,
+			.index = 0x44,
+			.trigger = ACPI_EDGE_SENSITIVE,
+			.polarity = ACPI_ACTIVE_LOW,
+		},
+	},
+};
+
+static struct gpiod_lookup_table medion_lifetab_s10346_goodix_gpios = {
+	.dev_id = "i2c-goodix_ts",
+	.table = {
+		GPIO_LOOKUP("INT33FC:01", 26, "reset", GPIO_ACTIVE_HIGH),
+		GPIO_LOOKUP("INT33FC:02", 3, "irq", GPIO_ACTIVE_HIGH),
+		{ }
+	},
+};
+
+static struct gpiod_lookup_table * const medion_lifetab_s10346_gpios[] = {
+	&medion_lifetab_s10346_goodix_gpios,
+	NULL
+};
+
+static const struct x86_dev_info medion_lifetab_s10346_info __initconst = {
+	.i2c_client_info = medion_lifetab_s10346_i2c_clients,
+	.i2c_client_count = ARRAY_SIZE(medion_lifetab_s10346_i2c_clients),
+	.gpiod_lookup_tables = medion_lifetab_s10346_gpios,
+};
+
 /* Nextbook Ares 8 tablets have an Android factory img with everything hardcoded */
 static const char * const nextbook_ares8_accel_mount_matrix[] = {
 	"0", "-1", "0",
@@ -1179,6 +1435,14 @@ static const struct x86_dev_info xiaomi_mipad2_info __initconst = {
 };
 
 static const struct dmi_system_id x86_android_tablet_ids[] __initconst = {
+	{
+		/* Advantech MICA-071 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Advantech"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "MICA-071"),
+		},
+		.driver_data = (void *)&advantech_mica_071_info,
+	},
 	{
 		/* Asus MeMO Pad 7 ME176C */
 		.matches = {
@@ -1245,6 +1509,25 @@ static const struct dmi_system_id x86_android_tablet_ids[] __initconst = {
 		},
 		.driver_data = (void *)&lenovo_yoga_tab2_830_1050_info,
 	},
+	{
+		/* Lenovo Yoga Tab 3 Pro YT3-X90F */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+			DMI_MATCH(DMI_PRODUCT_VERSION, "Blade3-10A-001"),
+		},
+		.driver_data = (void *)&lenovo_yt3_info,
+	},
+	{
+		/* Medion Lifetab S10346 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "AMI Corporation"),
+			DMI_MATCH(DMI_BOARD_NAME, "Aptio CRB"),
+			/* Above strings are much too generic, also match on BIOS date */
+			DMI_MATCH(DMI_BIOS_DATE, "10/22/2015"),
+		},
+		.driver_data = (void *)&medion_lifetab_s10346_info,
+	},
 	{
 		/* Nextbook Ares 8 */
 		.matches = {
diff --git a/drivers/remoteproc/imx_dsp_rproc.c b/drivers/remoteproc/imx_dsp_rproc.c
index 899aa8dd12f0..95da1cbefacf 100644
--- a/drivers/remoteproc/imx_dsp_rproc.c
+++ b/drivers/remoteproc/imx_dsp_rproc.c
@@ -347,9 +347,6 @@ static int imx_dsp_rproc_stop(struct rproc *rproc)
 	struct device *dev = rproc->dev.parent;
 	int ret = 0;
 
-	/* Make sure work is finished */
-	flush_work(&priv->rproc_work);
-
 	if (rproc->state == RPROC_CRASHED) {
 		priv->flags &= ~REMOTE_IS_READY;
 		return 0;
@@ -432,9 +429,18 @@ static void imx_dsp_rproc_vq_work(struct work_struct *work)
 {
 	struct imx_dsp_rproc *priv = container_of(work, struct imx_dsp_rproc,
 						  rproc_work);
+	struct rproc *rproc = priv->rproc;
+
+	mutex_lock(&rproc->lock);
+
+	if (rproc->state != RPROC_RUNNING)
+		goto unlock_mutex;
 
 	rproc_vq_interrupt(priv->rproc, 0);
 	rproc_vq_interrupt(priv->rproc, 1);
+
+unlock_mutex:
+	mutex_unlock(&rproc->lock);
 }
 
 /**
diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index 7cc4fd207e2d..596e1440cca5 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -113,8 +113,8 @@ static const struct imx_rproc_att imx_rproc_att_imx93[] = {
 	{ 0x80000000, 0x80000000, 0x10000000, 0 },
 	{ 0x90000000, 0x80000000, 0x10000000, 0 },
 
-	{ 0xC0000000, 0xa0000000, 0x10000000, 0 },
-	{ 0xD0000000, 0xa0000000, 0x10000000, 0 },
+	{ 0xC0000000, 0xC0000000, 0x10000000, 0 },
+	{ 0xD0000000, 0xC0000000, 0x10000000, 0 },
 };
 
 static const struct imx_rproc_att imx_rproc_att_imx8mn[] = {
diff --git a/drivers/remoteproc/remoteproc_core.c b/drivers/remoteproc/remoteproc_core.c
index cb1d414a2389..c3f194d9384d 100644
--- a/drivers/remoteproc/remoteproc_core.c
+++ b/drivers/remoteproc/remoteproc_core.c
@@ -1868,12 +1868,18 @@ static void rproc_crash_handler_work(struct work_struct *work)
 
 	mutex_lock(&rproc->lock);
 
-	if (rproc->state == RPROC_CRASHED || rproc->state == RPROC_OFFLINE) {
+	if (rproc->state == RPROC_CRASHED) {
 		/* handle only the first crash detected */
 		mutex_unlock(&rproc->lock);
 		return;
 	}
 
+	if (rproc->state == RPROC_OFFLINE) {
+		/* Don't recover if the remote processor was stopped */
+		mutex_unlock(&rproc->lock);
+		goto out;
+	}
+
 	rproc->state = RPROC_CRASHED;
 	dev_err(dev, "handling crash #%u in %s\n", ++rproc->crash_cnt,
 		rproc->name);
@@ -1883,6 +1889,7 @@ static void rproc_crash_handler_work(struct work_struct *work)
 	if (!rproc->recovery_disabled)
 		rproc_trigger_recovery(rproc);
 
+out:
 	pm_relax(rproc->dev.parent);
 }
 
diff --git a/drivers/rtc/rtc-ds1347.c b/drivers/rtc/rtc-ds1347.c
index 157bf5209ac4..a40c1a52df65 100644
--- a/drivers/rtc/rtc-ds1347.c
+++ b/drivers/rtc/rtc-ds1347.c
@@ -112,7 +112,7 @@ static int ds1347_set_time(struct device *dev, struct rtc_time *dt)
 		return err;
 
 	century = (dt->tm_year / 100) + 19;
-	err = regmap_write(map, DS1347_CENTURY_REG, century);
+	err = regmap_write(map, DS1347_CENTURY_REG, bin2bcd(century));
 	if (err)
 		return err;
 
diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 024e420f1bb7..ae504c43d9e7 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -63,6 +63,7 @@ config QCOM_GSBI
 config QCOM_LLCC
 	tristate "Qualcomm Technologies, Inc. LLCC driver"
 	depends on ARCH_QCOM || COMPILE_TEST
+	select REGMAP_MMIO
 	help
 	  Qualcomm Technologies, Inc. platform specific
 	  Last Level Cache Controller(LLCC) driver for platforms such as,
@@ -236,6 +237,7 @@ config QCOM_ICC_BWMON
 	tristate "QCOM Interconnect Bandwidth Monitor driver"
 	depends on ARCH_QCOM || COMPILE_TEST
 	select PM_OPP
+	select REGMAP_MMIO
 	help
 	  Sets up driver monitoring bandwidth on various interconnects and
 	  based on that voting for interconnect bandwidth, adjusting their
diff --git a/drivers/soc/ux500/ux500-soc-id.c b/drivers/soc/ux500/ux500-soc-id.c
index a9472e0e5d61..27d6e25a0115 100644
--- a/drivers/soc/ux500/ux500-soc-id.c
+++ b/drivers/soc/ux500/ux500-soc-id.c
@@ -167,20 +167,18 @@ ATTRIBUTE_GROUPS(ux500_soc);
 static const char *db8500_read_soc_id(struct device_node *backupram)
 {
 	void __iomem *base;
-	void __iomem *uid;
 	const char *retstr;
+	u32 uid[5];
 
 	base = of_iomap(backupram, 0);
 	if (!base)
 		return NULL;
-	uid = base + 0x1fc0;
+	memcpy_fromio(uid, base + 0x1fc0, sizeof(uid));
 
 	/* Throw these device-specific numbers into the entropy pool */
-	add_device_randomness(uid, 0x14);
+	add_device_randomness(uid, sizeof(uid));
 	retstr = kasprintf(GFP_KERNEL, "%08x%08x%08x%08x%08x",
-			 readl((u32 *)uid+0),
-			 readl((u32 *)uid+1), readl((u32 *)uid+2),
-			 readl((u32 *)uid+3), readl((u32 *)uid+4));
+			   uid[0], uid[1], uid[2], uid[3], uid[4]);
 	iounmap(base);
 	return retstr;
 }
diff --git a/drivers/staging/media/ipu3/ipu3-v4l2.c b/drivers/staging/media/ipu3/ipu3-v4l2.c
index ce13e746c15f..e530767e80a5 100644
--- a/drivers/staging/media/ipu3/ipu3-v4l2.c
+++ b/drivers/staging/media/ipu3/ipu3-v4l2.c
@@ -188,6 +188,28 @@ static int imgu_subdev_set_fmt(struct v4l2_subdev *sd,
 	return 0;
 }
 
+static struct v4l2_rect *
+imgu_subdev_get_crop(struct imgu_v4l2_subdev *sd,
+		     struct v4l2_subdev_state *sd_state, unsigned int pad,
+		     enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_crop(&sd->subdev, sd_state, pad);
+	else
+		return &sd->rect.eff;
+}
+
+static struct v4l2_rect *
+imgu_subdev_get_compose(struct imgu_v4l2_subdev *sd,
+			struct v4l2_subdev_state *sd_state, unsigned int pad,
+			enum v4l2_subdev_format_whence which)
+{
+	if (which == V4L2_SUBDEV_FORMAT_TRY)
+		return v4l2_subdev_get_try_compose(&sd->subdev, sd_state, pad);
+	else
+		return &sd->rect.bds;
+}
+
 static int imgu_subdev_get_selection(struct v4l2_subdev *sd,
 				     struct v4l2_subdev_state *sd_state,
 				     struct v4l2_subdev_selection *sel)
@@ -200,18 +222,12 @@ static int imgu_subdev_get_selection(struct v4l2_subdev *sd,
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
-		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-			sel->r = *v4l2_subdev_get_try_crop(sd, sd_state,
-							   sel->pad);
-		else
-			sel->r = imgu_sd->rect.eff;
+		sel->r = *imgu_subdev_get_crop(imgu_sd, sd_state, sel->pad,
+					       sel->which);
 		return 0;
 	case V4L2_SEL_TGT_COMPOSE:
-		if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-			sel->r = *v4l2_subdev_get_try_compose(sd, sd_state,
-							      sel->pad);
-		else
-			sel->r = imgu_sd->rect.bds;
+		sel->r = *imgu_subdev_get_compose(imgu_sd, sd_state, sel->pad,
+						  sel->which);
 		return 0;
 	default:
 		return -EINVAL;
@@ -223,10 +239,9 @@ static int imgu_subdev_set_selection(struct v4l2_subdev *sd,
 				     struct v4l2_subdev_selection *sel)
 {
 	struct imgu_device *imgu = v4l2_get_subdevdata(sd);
-	struct imgu_v4l2_subdev *imgu_sd = container_of(sd,
-							struct imgu_v4l2_subdev,
-							subdev);
-	struct v4l2_rect *rect, *try_sel;
+	struct imgu_v4l2_subdev *imgu_sd =
+		container_of(sd, struct imgu_v4l2_subdev, subdev);
+	struct v4l2_rect *rect;
 
 	dev_dbg(&imgu->pci_dev->dev,
 		 "set subdev %u sel which %u target 0x%4x rect [%ux%u]",
@@ -238,22 +253,18 @@ static int imgu_subdev_set_selection(struct v4l2_subdev *sd,
 
 	switch (sel->target) {
 	case V4L2_SEL_TGT_CROP:
-		try_sel = v4l2_subdev_get_try_crop(sd, sd_state, sel->pad);
-		rect = &imgu_sd->rect.eff;
+		rect = imgu_subdev_get_crop(imgu_sd, sd_state, sel->pad,
+					    sel->which);
 		break;
 	case V4L2_SEL_TGT_COMPOSE:
-		try_sel = v4l2_subdev_get_try_compose(sd, sd_state, sel->pad);
-		rect = &imgu_sd->rect.bds;
+		rect = imgu_subdev_get_compose(imgu_sd, sd_state, sel->pad,
+					       sel->which);
 		break;
 	default:
 		return -EINVAL;
 	}
 
-	if (sel->which == V4L2_SUBDEV_FORMAT_TRY)
-		*try_sel = sel->r;
-	else
-		*rect = sel->r;
-
+	*rect = sel->r;
 	return 0;
 }
 
diff --git a/drivers/staging/media/tegra-video/csi.c b/drivers/staging/media/tegra-video/csi.c
index b26e44adb2be..426e653bd55d 100644
--- a/drivers/staging/media/tegra-video/csi.c
+++ b/drivers/staging/media/tegra-video/csi.c
@@ -433,7 +433,7 @@ static int tegra_csi_channel_alloc(struct tegra_csi *csi,
 	for (i = 0; i < chan->numgangports; i++)
 		chan->csi_port_nums[i] = port_num + i * CSI_PORTS_PER_BRICK;
 
-	chan->of_node = node;
+	chan->of_node = of_node_get(node);
 	chan->numpads = num_pads;
 	if (num_pads & 0x2) {
 		chan->pads[0].flags = MEDIA_PAD_FL_SINK;
@@ -448,6 +448,7 @@ static int tegra_csi_channel_alloc(struct tegra_csi *csi,
 	chan->mipi = tegra_mipi_request(csi->dev, node);
 	if (IS_ERR(chan->mipi)) {
 		ret = PTR_ERR(chan->mipi);
+		chan->mipi = NULL;
 		dev_err(csi->dev, "failed to get mipi device: %d\n", ret);
 	}
 
@@ -640,6 +641,7 @@ static void tegra_csi_channels_cleanup(struct tegra_csi *csi)
 			media_entity_cleanup(&subdev->entity);
 		}
 
+		of_node_put(chan->of_node);
 		list_del(&chan->list);
 		kfree(chan);
 	}
diff --git a/drivers/staging/media/tegra-video/csi.h b/drivers/staging/media/tegra-video/csi.h
index 4ee05a1785cf..6960ea2e3d36 100644
--- a/drivers/staging/media/tegra-video/csi.h
+++ b/drivers/staging/media/tegra-video/csi.h
@@ -56,7 +56,7 @@ struct tegra_csi;
  * @framerate: active framerate for TPG
  * @h_blank: horizontal blanking for TPG active format
  * @v_blank: vertical blanking for TPG active format
- * @mipi: mipi device for corresponding csi channel pads
+ * @mipi: mipi device for corresponding csi channel pads, or NULL if not applicable (TPG, error)
  * @pixel_rate: active pixel rate from the sensor on this channel
  */
 struct tegra_csi_channel {
diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 18374a6d05bd..18cf801ab590 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -433,6 +433,7 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 	u64 wanted_disk_byte = ref->wanted_disk_byte;
 	u64 count = 0;
 	u64 data_offset;
+	u8 type;
 
 	if (level != 0) {
 		eb = path->nodes[level];
@@ -487,6 +488,9 @@ static int add_all_parents(struct btrfs_root *root, struct btrfs_path *path,
 			continue;
 		}
 		fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
+		type = btrfs_file_extent_type(eb, fi);
+		if (type == BTRFS_FILE_EXTENT_INLINE)
+			goto next;
 		disk_byte = btrfs_file_extent_disk_bytenr(eb, fi);
 		data_offset = btrfs_file_extent_offset(eb, fi);
 
diff --git a/fs/btrfs/extent-io-tree.c b/fs/btrfs/extent-io-tree.c
index 3676580c2d97..7b93719a486c 100644
--- a/fs/btrfs/extent-io-tree.c
+++ b/fs/btrfs/extent-io-tree.c
@@ -397,7 +397,7 @@ static int insert_state(struct extent_io_tree *tree,
 			u32 bits, struct extent_changeset *changeset)
 {
 	struct rb_node **node;
-	struct rb_node *parent;
+	struct rb_node *parent = NULL;
 	const u64 end = state->end;
 
 	set_state_bits(tree, state, bits, changeset);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 635f45f1a2ef..dba087ad40ea 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -7241,8 +7241,9 @@ static int read_one_chunk(struct btrfs_key *key, struct extent_buffer *leaf,
 			map->stripes[i].dev = handle_missing_device(fs_info,
 								    devid, uuid);
 			if (IS_ERR(map->stripes[i].dev)) {
+				ret = PTR_ERR(map->stripes[i].dev);
 				free_extent_map(em);
-				return PTR_ERR(map->stripes[i].dev);
+				return ret;
 			}
 		}
 
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 712a43161448..6094cb2ff099 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -678,9 +678,15 @@ cifs_show_options(struct seq_file *s, struct dentry *root)
 	seq_printf(s, ",echo_interval=%lu",
 			tcon->ses->server->echo_interval / HZ);
 
-	/* Only display max_credits if it was overridden on mount */
+	/* Only display the following if overridden on mount */
 	if (tcon->ses->server->max_credits != SMB2_MAX_CREDITS_AVAILABLE)
 		seq_printf(s, ",max_credits=%u", tcon->ses->server->max_credits);
+	if (tcon->ses->server->tcp_nodelay)
+		seq_puts(s, ",tcpnodelay");
+	if (tcon->ses->server->noautotune)
+		seq_puts(s, ",noautotune");
+	if (tcon->ses->server->noblocksnd)
+		seq_puts(s, ",noblocksend");
 
 	if (tcon->snapshot_time)
 		seq_printf(s, ",snapshot=%llu", tcon->snapshot_time);
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 9db9527c61cf..7e7f712f97fd 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -279,8 +279,10 @@ cifs_mark_tcp_ses_conns_for_reconnect(struct TCP_Server_Info *server,
 			tcon->need_reconnect = true;
 			tcon->status = TID_NEED_RECON;
 		}
-		if (ses->tcon_ipc)
+		if (ses->tcon_ipc) {
 			ses->tcon_ipc->need_reconnect = true;
+			ses->tcon_ipc->status = TID_NEED_RECON;
+		}
 
 next_session:
 		spin_unlock(&ses->chan_lock);
@@ -1871,6 +1873,9 @@ cifs_setup_ipc(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 
 	cifs_dbg(FYI, "IPC tcon rc=%d ipc tid=0x%x\n", rc, tcon->tid);
 
+	spin_lock(&tcon->tc_lock);
+	tcon->status = TID_GOOD;
+	spin_unlock(&tcon->tc_lock);
 	ses->tcon_ipc = tcon;
 out:
 	return rc;
@@ -2157,7 +2162,7 @@ cifs_set_cifscreds(struct smb3_fs_context *ctx __attribute__((unused)),
 struct cifs_ses *
 cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 {
-	int rc = -ENOMEM;
+	int rc = 0;
 	unsigned int xid;
 	struct cifs_ses *ses;
 	struct sockaddr_in *addr = (struct sockaddr_in *)&server->dstaddr;
@@ -2206,6 +2211,8 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 		return ses;
 	}
 
+	rc = -ENOMEM;
+
 	cifs_dbg(FYI, "Existing smb sess not found\n");
 	ses = sesInfoAlloc();
 	if (ses == NULL)
@@ -2278,10 +2285,10 @@ cifs_get_smb_ses(struct TCP_Server_Info *server, struct smb3_fs_context *ctx)
 	list_add(&ses->smb_ses_list, &server->smb_ses_list);
 	spin_unlock(&cifs_tcp_ses_lock);
 
-	free_xid(xid);
-
 	cifs_setup_ipc(ses, ctx);
 
+	free_xid(xid);
+
 	return ses;
 
 get_ses_fail:
@@ -2600,6 +2607,7 @@ cifs_get_tcon(struct cifs_ses *ses, struct smb3_fs_context *ctx)
 	tcon->nodelete = ctx->nodelete;
 	tcon->local_lease = ctx->local_lease;
 	INIT_LIST_HEAD(&tcon->pending_opens);
+	tcon->status = TID_GOOD;
 
 	/* schedule query interfaces poll */
 	INIT_DELAYED_WORK(&tcon->query_interfaces,
diff --git a/fs/dlm/lowcomms.c b/fs/dlm/lowcomms.c
index 59f64c596233..871d4e9f49fb 100644
--- a/fs/dlm/lowcomms.c
+++ b/fs/dlm/lowcomms.c
@@ -1543,7 +1543,11 @@ static void process_recv_sockets(struct work_struct *work)
 
 static void process_listen_recv_socket(struct work_struct *work)
 {
-	accept_from_sock(&listen_con);
+	int ret;
+
+	do {
+		ret = accept_from_sock(&listen_con);
+	} while (!ret);
 }
 
 static void dlm_connect(struct connection *con)
@@ -1820,7 +1824,7 @@ static int dlm_listen_for_all(void)
 	result = sock->ops->listen(sock, 5);
 	if (result < 0) {
 		dlm_close_sock(&listen_con.sock);
-		goto out;
+		return result;
 	}
 
 	return 0;
@@ -2023,7 +2027,6 @@ int dlm_lowcomms_start(void)
 	dlm_proto_ops = NULL;
 fail_proto_ops:
 	dlm_allow_conn = 0;
-	dlm_close_sock(&listen_con.sock);
 	work_stop();
 fail_local:
 	deinit_local();
diff --git a/fs/ext2/dir.c b/fs/ext2/dir.c
index 8f597753ac12..5202eddfc3c0 100644
--- a/fs/ext2/dir.c
+++ b/fs/ext2/dir.c
@@ -679,7 +679,7 @@ int ext2_empty_dir (struct inode * inode)
 		page = ext2_get_page(inode, i, 0, &page_addr);
 
 		if (IS_ERR(page))
-			goto not_empty;
+			return 0;
 
 		kaddr = page_addr;
 		de = (ext2_dirent *)kaddr;
diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8d5453852f98..4e739902dc03 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -558,7 +558,7 @@ enum {
  *
  * It's not paranoia if the Murphy's Law really *is* out to get you.  :-)
  */
-#define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1 << EXT4_INODE_##FLAG))
+#define TEST_FLAG_VALUE(FLAG) (EXT4_##FLAG##_FL == (1U << EXT4_INODE_##FLAG))
 #define CHECK_FLAG_VALUE(FLAG) BUILD_BUG_ON(!TEST_FLAG_VALUE(FLAG))
 
 static inline void ext4_check_flag_values(void)
@@ -2964,7 +2964,8 @@ int do_journal_get_write_access(handle_t *handle, struct inode *inode,
 typedef enum {
 	EXT4_IGET_NORMAL =	0,
 	EXT4_IGET_SPECIAL =	0x0001, /* OK to iget a system inode */
-	EXT4_IGET_HANDLE = 	0x0002	/* Inode # is from a handle */
+	EXT4_IGET_HANDLE = 	0x0002,	/* Inode # is from a handle */
+	EXT4_IGET_BAD =		0x0004  /* Allow to iget a bad inode */
 } ext4_iget_flags;
 
 extern struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
@@ -3619,8 +3620,8 @@ extern void ext4_initialize_dirent_tail(struct buffer_head *bh,
 					unsigned int blocksize);
 extern int ext4_handle_dirty_dirblock(handle_t *handle, struct inode *inode,
 				      struct buffer_head *bh);
-extern int __ext4_unlink(handle_t *handle, struct inode *dir, const struct qstr *d_name,
-			 struct inode *inode);
+extern int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
+			 struct inode *inode, struct dentry *dentry);
 extern int __ext4_link(struct inode *dir, struct inode *inode,
 		       struct dentry *dentry);
 
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index 6c399a8b22b3..36225ef56b0c 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -5799,6 +5799,14 @@ int ext4_clu_mapped(struct inode *inode, ext4_lblk_t lclu)
 	struct ext4_extent *extent;
 	ext4_lblk_t first_lblk, first_lclu, last_lclu;
 
+	/*
+	 * if data can be stored inline, the logical cluster isn't
+	 * mapped - no physical clusters have been allocated, and the
+	 * file has no extents
+	 */
+	if (ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
+		return 0;
+
 	/* search for the extent closest to the first block in the cluster */
 	path = ext4_find_extent(inode, EXT4_C2B(sbi, lclu), NULL, 0);
 	if (IS_ERR(path)) {
diff --git a/fs/ext4/extents_status.c b/fs/ext4/extents_status.c
index cd0a861853e3..7ada374ff27d 100644
--- a/fs/ext4/extents_status.c
+++ b/fs/ext4/extents_status.c
@@ -1371,7 +1371,7 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 		if (count_reserved)
 			count_rsvd(inode, lblk, orig_es.es_len - len1 - len2,
 				   &orig_es, &rc);
-		goto out;
+		goto out_get_reserved;
 	}
 
 	if (len1 > 0) {
@@ -1413,6 +1413,7 @@ static int __es_remove_extent(struct inode *inode, ext4_lblk_t lblk,
 		}
 	}
 
+out_get_reserved:
 	if (count_reserved)
 		*reserved = get_rsvd(inode, end, es, &rc);
 out:
diff --git a/fs/ext4/fast_commit.c b/fs/ext4/fast_commit.c
index 0f6d0a80467d..7ed71c652f67 100644
--- a/fs/ext4/fast_commit.c
+++ b/fs/ext4/fast_commit.c
@@ -420,25 +420,34 @@ static int __track_dentry_update(struct inode *inode, void *arg, bool update)
 	struct __track_dentry_update_args *dentry_update =
 		(struct __track_dentry_update_args *)arg;
 	struct dentry *dentry = dentry_update->dentry;
-	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
+	struct inode *dir = dentry->d_parent->d_inode;
+	struct super_block *sb = inode->i_sb;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
 
 	mutex_unlock(&ei->i_fc_lock);
+
+	if (IS_ENCRYPTED(dir)) {
+		ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_ENCRYPTED_FILENAME,
+					NULL);
+		mutex_lock(&ei->i_fc_lock);
+		return -EOPNOTSUPP;
+	}
+
 	node = kmem_cache_alloc(ext4_fc_dentry_cachep, GFP_NOFS);
 	if (!node) {
-		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM, NULL);
+		ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_NOMEM, NULL);
 		mutex_lock(&ei->i_fc_lock);
 		return -ENOMEM;
 	}
 
 	node->fcd_op = dentry_update->op;
-	node->fcd_parent = dentry->d_parent->d_inode->i_ino;
+	node->fcd_parent = dir->i_ino;
 	node->fcd_ino = inode->i_ino;
 	if (dentry->d_name.len > DNAME_INLINE_LEN) {
 		node->fcd_name.name = kmalloc(dentry->d_name.len, GFP_NOFS);
 		if (!node->fcd_name.name) {
 			kmem_cache_free(ext4_fc_dentry_cachep, node);
-			ext4_fc_mark_ineligible(inode->i_sb,
-				EXT4_FC_REASON_NOMEM, NULL);
+			ext4_fc_mark_ineligible(sb, EXT4_FC_REASON_NOMEM, NULL);
 			mutex_lock(&ei->i_fc_lock);
 			return -ENOMEM;
 		}
@@ -666,6 +675,15 @@ static void ext4_fc_submit_bh(struct super_block *sb, bool is_tail)
 
 /* Ext4 commit path routines */
 
+/* memcpy to fc reserved space and update CRC */
+static void *ext4_fc_memcpy(struct super_block *sb, void *dst, const void *src,
+				int len, u32 *crc)
+{
+	if (crc)
+		*crc = ext4_chksum(EXT4_SB(sb), *crc, src, len);
+	return memcpy(dst, src, len);
+}
+
 /* memzero and update CRC */
 static void *ext4_fc_memzero(struct super_block *sb, void *dst, int len,
 				u32 *crc)
@@ -691,62 +709,59 @@ static void *ext4_fc_memzero(struct super_block *sb, void *dst, int len,
  */
 static u8 *ext4_fc_reserve_space(struct super_block *sb, int len, u32 *crc)
 {
-	struct ext4_fc_tl *tl;
+	struct ext4_fc_tl tl;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct buffer_head *bh;
 	int bsize = sbi->s_journal->j_blocksize;
 	int ret, off = sbi->s_fc_bytes % bsize;
-	int pad_len;
+	int remaining;
+	u8 *dst;
 
 	/*
-	 * After allocating len, we should have space at least for a 0 byte
-	 * padding.
+	 * If 'len' is too long to fit in any block alongside a PAD tlv, then we
+	 * cannot fulfill the request.
 	 */
-	if (len + EXT4_FC_TAG_BASE_LEN > bsize)
+	if (len > bsize - EXT4_FC_TAG_BASE_LEN)
 		return NULL;
 
-	if (bsize - off - 1 > len + EXT4_FC_TAG_BASE_LEN) {
-		/*
-		 * Only allocate from current buffer if we have enough space for
-		 * this request AND we have space to add a zero byte padding.
-		 */
-		if (!sbi->s_fc_bh) {
-			ret = jbd2_fc_get_buf(EXT4_SB(sb)->s_journal, &bh);
-			if (ret)
-				return NULL;
-			sbi->s_fc_bh = bh;
-		}
+	if (!sbi->s_fc_bh) {
+		ret = jbd2_fc_get_buf(EXT4_SB(sb)->s_journal, &bh);
+		if (ret)
+			return NULL;
+		sbi->s_fc_bh = bh;
+	}
+	dst = sbi->s_fc_bh->b_data + off;
+
+	/*
+	 * Allocate the bytes in the current block if we can do so while still
+	 * leaving enough space for a PAD tlv.
+	 */
+	remaining = bsize - EXT4_FC_TAG_BASE_LEN - off;
+	if (len <= remaining) {
 		sbi->s_fc_bytes += len;
-		return sbi->s_fc_bh->b_data + off;
+		return dst;
 	}
-	/* Need to add PAD tag */
-	tl = (struct ext4_fc_tl *)(sbi->s_fc_bh->b_data + off);
-	tl->fc_tag = cpu_to_le16(EXT4_FC_TAG_PAD);
-	pad_len = bsize - off - 1 - EXT4_FC_TAG_BASE_LEN;
-	tl->fc_len = cpu_to_le16(pad_len);
-	if (crc)
-		*crc = ext4_chksum(sbi, *crc, tl, EXT4_FC_TAG_BASE_LEN);
-	if (pad_len > 0)
-		ext4_fc_memzero(sb, tl + 1, pad_len, crc);
+
+	/*
+	 * Else, terminate the current block with a PAD tlv, then allocate a new
+	 * block and allocate the bytes at the start of that new block.
+	 */
+
+	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_PAD);
+	tl.fc_len = cpu_to_le16(remaining);
+	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, crc);
+	ext4_fc_memzero(sb, dst + EXT4_FC_TAG_BASE_LEN, remaining, crc);
+
 	ext4_fc_submit_bh(sb, false);
 
 	ret = jbd2_fc_get_buf(EXT4_SB(sb)->s_journal, &bh);
 	if (ret)
 		return NULL;
 	sbi->s_fc_bh = bh;
-	sbi->s_fc_bytes = (sbi->s_fc_bytes / bsize + 1) * bsize + len;
+	sbi->s_fc_bytes += bsize - off + len;
 	return sbi->s_fc_bh->b_data;
 }
 
-/* memcpy to fc reserved space and update CRC */
-static void *ext4_fc_memcpy(struct super_block *sb, void *dst, const void *src,
-				int len, u32 *crc)
-{
-	if (crc)
-		*crc = ext4_chksum(EXT4_SB(sb), *crc, src, len);
-	return memcpy(dst, src, len);
-}
-
 /*
  * Complete a fast commit by writing tail tag.
  *
@@ -774,7 +789,7 @@ static int ext4_fc_write_tail(struct super_block *sb, u32 crc)
 	off = sbi->s_fc_bytes % bsize;
 
 	tl.fc_tag = cpu_to_le16(EXT4_FC_TAG_TAIL);
-	tl.fc_len = cpu_to_le16(bsize - off - 1 + sizeof(struct ext4_fc_tail));
+	tl.fc_len = cpu_to_le16(bsize - off + sizeof(struct ext4_fc_tail));
 	sbi->s_fc_bytes = round_up(sbi->s_fc_bytes, bsize);
 
 	ext4_fc_memcpy(sb, dst, &tl, EXT4_FC_TAG_BASE_LEN, &crc);
@@ -784,6 +799,8 @@ static int ext4_fc_write_tail(struct super_block *sb, u32 crc)
 	dst += sizeof(tail.fc_tid);
 	tail.fc_crc = cpu_to_le32(crc);
 	ext4_fc_memcpy(sb, dst, &tail.fc_crc, sizeof(tail.fc_crc), NULL);
+	dst += sizeof(tail.fc_crc);
+	memset(dst, 0, bsize - off); /* Don't leak uninitialized memory. */
 
 	ext4_fc_submit_bh(sb, true);
 
@@ -1388,7 +1405,7 @@ static int ext4_fc_replay_unlink(struct super_block *sb, struct ext4_fc_tl *tl,
 		return 0;
 	}
 
-	ret = __ext4_unlink(NULL, old_parent, &entry, inode);
+	ret = __ext4_unlink(old_parent, &entry, inode, NULL);
 	/* -ENOENT ok coz it might not exist anymore. */
 	if (ret == -ENOENT)
 		ret = 0;
@@ -1977,32 +1994,31 @@ void ext4_fc_replay_cleanup(struct super_block *sb)
 	kfree(sbi->s_fc_replay_state.fc_modified_inodes);
 }
 
-static inline bool ext4_fc_tag_len_isvalid(struct ext4_fc_tl *tl,
-					   u8 *val, u8 *end)
+static bool ext4_fc_value_len_isvalid(struct ext4_sb_info *sbi,
+				      int tag, int len)
 {
-	if (val + tl->fc_len > end)
-		return false;
-
-	/* Here only check ADD_RANGE/TAIL/HEAD which will read data when do
-	 * journal rescan before do CRC check. Other tags length check will
-	 * rely on CRC check.
-	 */
-	switch (tl->fc_tag) {
+	switch (tag) {
 	case EXT4_FC_TAG_ADD_RANGE:
-		return (sizeof(struct ext4_fc_add_range) == tl->fc_len);
-	case EXT4_FC_TAG_TAIL:
-		return (sizeof(struct ext4_fc_tail) <= tl->fc_len);
-	case EXT4_FC_TAG_HEAD:
-		return (sizeof(struct ext4_fc_head) == tl->fc_len);
+		return len == sizeof(struct ext4_fc_add_range);
 	case EXT4_FC_TAG_DEL_RANGE:
+		return len == sizeof(struct ext4_fc_del_range);
+	case EXT4_FC_TAG_CREAT:
 	case EXT4_FC_TAG_LINK:
 	case EXT4_FC_TAG_UNLINK:
-	case EXT4_FC_TAG_CREAT:
+		len -= sizeof(struct ext4_fc_dentry_info);
+		return len >= 1 && len <= EXT4_NAME_LEN;
 	case EXT4_FC_TAG_INODE:
+		len -= sizeof(struct ext4_fc_inode);
+		return len >= EXT4_GOOD_OLD_INODE_SIZE &&
+			len <= sbi->s_inode_size;
 	case EXT4_FC_TAG_PAD:
-	default:
-		return true;
+		return true; /* padding can have any length */
+	case EXT4_FC_TAG_TAIL:
+		return len >= sizeof(struct ext4_fc_tail);
+	case EXT4_FC_TAG_HEAD:
+		return len == sizeof(struct ext4_fc_head);
 	}
+	return false;
 }
 
 /*
@@ -2040,7 +2056,7 @@ static int ext4_fc_replay_scan(journal_t *journal,
 	state = &sbi->s_fc_replay_state;
 
 	start = (u8 *)bh->b_data;
-	end = (__u8 *)bh->b_data + journal->j_blocksize - 1;
+	end = start + journal->j_blocksize;
 
 	if (state->fc_replay_expected_off == 0) {
 		state->fc_cur_tag = 0;
@@ -2061,11 +2077,12 @@ static int ext4_fc_replay_scan(journal_t *journal,
 	}
 
 	state->fc_replay_expected_off++;
-	for (cur = start; cur < end - EXT4_FC_TAG_BASE_LEN;
+	for (cur = start; cur <= end - EXT4_FC_TAG_BASE_LEN;
 	     cur = cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
 		ext4_fc_get_tl(&tl, cur);
 		val = cur + EXT4_FC_TAG_BASE_LEN;
-		if (!ext4_fc_tag_len_isvalid(&tl, val, end)) {
+		if (tl.fc_len > end - val ||
+		    !ext4_fc_value_len_isvalid(sbi, tl.fc_tag, tl.fc_len)) {
 			ret = state->fc_replay_num_tags ?
 				JBD2_FC_REPLAY_STOP : -ECANCELED;
 			goto out_err;
@@ -2178,9 +2195,9 @@ static int ext4_fc_replay(journal_t *journal, struct buffer_head *bh,
 #endif
 
 	start = (u8 *)bh->b_data;
-	end = (__u8 *)bh->b_data + journal->j_blocksize - 1;
+	end = start + journal->j_blocksize;
 
-	for (cur = start; cur < end - EXT4_FC_TAG_BASE_LEN;
+	for (cur = start; cur <= end - EXT4_FC_TAG_BASE_LEN;
 	     cur = cur + EXT4_FC_TAG_BASE_LEN + tl.fc_len) {
 		ext4_fc_get_tl(&tl, cur);
 		val = cur + EXT4_FC_TAG_BASE_LEN;
@@ -2249,17 +2266,17 @@ void ext4_fc_init(struct super_block *sb, journal_t *journal)
 	journal->j_fc_cleanup_callback = ext4_fc_cleanup;
 }
 
-static const char *fc_ineligible_reasons[] = {
-	"Extended attributes changed",
-	"Cross rename",
-	"Journal flag changed",
-	"Insufficient memory",
-	"Swap boot",
-	"Resize",
-	"Dir renamed",
-	"Falloc range op",
-	"Data journalling",
-	"FC Commit Failed"
+static const char * const fc_ineligible_reasons[] = {
+	[EXT4_FC_REASON_XATTR] = "Extended attributes changed",
+	[EXT4_FC_REASON_CROSS_RENAME] = "Cross rename",
+	[EXT4_FC_REASON_JOURNAL_FLAG_CHANGE] = "Journal flag changed",
+	[EXT4_FC_REASON_NOMEM] = "Insufficient memory",
+	[EXT4_FC_REASON_SWAP_BOOT] = "Swap boot",
+	[EXT4_FC_REASON_RESIZE] = "Resize",
+	[EXT4_FC_REASON_RENAME_DIR] = "Dir renamed",
+	[EXT4_FC_REASON_FALLOC_RANGE] = "Falloc range op",
+	[EXT4_FC_REASON_INODE_JOURNAL_DATA] = "Data journalling",
+	[EXT4_FC_REASON_ENCRYPTED_FILENAME] = "Encrypted filename",
 };
 
 int ext4_fc_info_show(struct seq_file *seq, void *v)
diff --git a/fs/ext4/fast_commit.h b/fs/ext4/fast_commit.h
index a6154c3ed135..2fadb2c4780c 100644
--- a/fs/ext4/fast_commit.h
+++ b/fs/ext4/fast_commit.h
@@ -58,7 +58,7 @@ struct ext4_fc_dentry_info {
 	__u8 fc_dname[];
 };
 
-/* Value structure for EXT4_FC_TAG_INODE and EXT4_FC_TAG_INODE_PARTIAL. */
+/* Value structure for EXT4_FC_TAG_INODE. */
 struct ext4_fc_inode {
 	__le32 fc_ino;
 	__u8 fc_raw_inode[];
@@ -96,6 +96,7 @@ enum {
 	EXT4_FC_REASON_RENAME_DIR,
 	EXT4_FC_REASON_FALLOC_RANGE,
 	EXT4_FC_REASON_INODE_JOURNAL_DATA,
+	EXT4_FC_REASON_ENCRYPTED_FILENAME,
 	EXT4_FC_REASON_MAX
 };
 
diff --git a/fs/ext4/indirect.c b/fs/ext4/indirect.c
index 860fc5119009..c68bebe7ff4b 100644
--- a/fs/ext4/indirect.c
+++ b/fs/ext4/indirect.c
@@ -148,6 +148,7 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 	struct super_block *sb = inode->i_sb;
 	Indirect *p = chain;
 	struct buffer_head *bh;
+	unsigned int key;
 	int ret = -EIO;
 
 	*err = 0;
@@ -156,7 +157,13 @@ static Indirect *ext4_get_branch(struct inode *inode, int depth,
 	if (!p->key)
 		goto no_block;
 	while (--depth) {
-		bh = sb_getblk(sb, le32_to_cpu(p->key));
+		key = le32_to_cpu(p->key);
+		if (key > ext4_blocks_count(EXT4_SB(sb)->s_es)) {
+			/* the block was out of range */
+			ret = -EFSCORRUPTED;
+			goto failure;
+		}
+		bh = sb_getblk(sb, key);
 		if (unlikely(!bh)) {
 			ret = -ENOMEM;
 			goto failure;
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 2b5ef1b64249..283afda26d9c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -222,13 +222,13 @@ void ext4_evict_inode(struct inode *inode)
 
 	/*
 	 * For inodes with journalled data, transaction commit could have
-	 * dirtied the inode. Flush worker is ignoring it because of I_FREEING
-	 * flag but we still need to remove the inode from the writeback lists.
+	 * dirtied the inode. And for inodes with dioread_nolock, unwritten
+	 * extents converting worker could merge extents and also have dirtied
+	 * the inode. Flush worker is ignoring it because of I_FREEING flag but
+	 * we still need to remove the inode from the writeback lists.
 	 */
-	if (!list_empty_careful(&inode->i_io_list)) {
-		WARN_ON_ONCE(!ext4_should_journal_data(inode));
+	if (!list_empty_careful(&inode->i_io_list))
 		inode_io_list_del(inode);
-	}
 
 	/*
 	 * Protect us against freezing - iput() caller didn't have to have any
@@ -335,6 +335,12 @@ void ext4_evict_inode(struct inode *inode)
 	ext4_xattr_inode_array_free(ea_inode_array);
 	return;
 no_delete:
+	/*
+	 * Check out some where else accidentally dirty the evicting inode,
+	 * which may probably cause inode use-after-free issues later.
+	 */
+	WARN_ON_ONCE(!list_empty_careful(&inode->i_io_list));
+
 	if (!list_empty(&EXT4_I(inode)->i_fc_list))
 		ext4_fc_mark_ineligible(inode->i_sb, EXT4_FC_REASON_NOMEM, NULL);
 	ext4_clear_inode(inode);	/* We must guarantee clearing of inode... */
@@ -1309,7 +1315,8 @@ static int ext4_write_end(struct file *file,
 
 	trace_ext4_write_end(inode, pos, len, copied);
 
-	if (ext4_has_inline_data(inode))
+	if (ext4_has_inline_data(inode) &&
+	    ext4_test_inode_state(inode, EXT4_STATE_MAY_INLINE_DATA))
 		return ext4_write_inline_data_end(inode, pos, len, copied, page);
 
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
@@ -4225,7 +4232,8 @@ int ext4_truncate(struct inode *inode)
 
 	/* If we zero-out tail of the page, we have to create jinode for jbd2 */
 	if (inode->i_size & (inode->i_sb->s_blocksize - 1)) {
-		if (ext4_inode_attach_jinode(inode) < 0)
+		err = ext4_inode_attach_jinode(inode);
+		if (err)
 			goto out_trace;
 	}
 
@@ -4473,9 +4481,17 @@ static int __ext4_get_inode_loc(struct super_block *sb, unsigned long ino,
 	inodes_per_block = EXT4_SB(sb)->s_inodes_per_block;
 	inode_offset = ((ino - 1) %
 			EXT4_INODES_PER_GROUP(sb));
-	block = ext4_inode_table(sb, gdp) + (inode_offset / inodes_per_block);
 	iloc->offset = (inode_offset % inodes_per_block) * EXT4_INODE_SIZE(sb);
 
+	block = ext4_inode_table(sb, gdp);
+	if ((block <= le32_to_cpu(EXT4_SB(sb)->s_es->s_first_data_block)) ||
+	    (block >= ext4_blocks_count(EXT4_SB(sb)->s_es))) {
+		ext4_error(sb, "Invalid inode table block %llu in "
+			   "block_group %u", block, iloc->block_group);
+		return -EFSCORRUPTED;
+	}
+	block += (inode_offset / inodes_per_block);
+
 	bh = sb_getblk(sb, block);
 	if (unlikely(!bh))
 		return -ENOMEM;
@@ -5044,8 +5060,14 @@ struct inode *__ext4_iget(struct super_block *sb, unsigned long ino,
 	if (IS_CASEFOLDED(inode) && !ext4_has_feature_casefold(inode->i_sb))
 		ext4_error_inode(inode, function, line, 0,
 				 "casefold flag without casefold feature");
-	brelse(iloc.bh);
+	if (is_bad_inode(inode) && !(flags & EXT4_IGET_BAD)) {
+		ext4_error_inode(inode, function, line, 0,
+				 "bad inode without EXT4_IGET_BAD flag");
+		ret = -EUCLEAN;
+		goto bad_inode;
+	}
 
+	brelse(iloc.bh);
 	unlock_new_inode(inode);
 	return inode;
 
@@ -5853,6 +5875,14 @@ static int __ext4_expand_extra_isize(struct inode *inode,
 		return 0;
 	}
 
+	/*
+	 * We may need to allocate external xattr block so we need quotas
+	 * initialized. Here we can be called with various locks held so we
+	 * cannot affort to initialize quotas ourselves. So just bail.
+	 */
+	if (dquot_initialize_needed(inode))
+		return -EAGAIN;
+
 	/* try to expand with EAs present */
 	error = ext4_expand_extra_isize_ea(inode, new_extra_isize,
 					   raw_inode, handle);
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 95dfea28bf4e..8067ccda34e4 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -374,7 +374,8 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	blkcnt_t blocks;
 	unsigned short bytes;
 
-	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO, EXT4_IGET_SPECIAL);
+	inode_bl = ext4_iget(sb, EXT4_BOOT_LOADER_INO,
+			EXT4_IGET_SPECIAL | EXT4_IGET_BAD);
 	if (IS_ERR(inode_bl))
 		return PTR_ERR(inode_bl);
 	ei_bl = EXT4_I(inode_bl);
@@ -424,7 +425,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	/* Protect extent tree against block allocations via delalloc */
 	ext4_double_down_write_data_sem(inode, inode_bl);
 
-	if (inode_bl->i_nlink == 0) {
+	if (is_bad_inode(inode_bl) || !S_ISREG(inode_bl->i_mode)) {
 		/* this inode has never been used as a BOOT_LOADER */
 		set_nlink(inode_bl, 1);
 		i_uid_write(inode_bl, 0);
@@ -731,6 +732,10 @@ static int ext4_ioctl_setproject(struct inode *inode, __u32 projid)
 	if (ext4_is_quota_file(inode))
 		return err;
 
+	err = dquot_initialize(inode);
+	if (err)
+		return err;
+
 	err = ext4_get_inode_loc(inode, &iloc);
 	if (err)
 		return err;
@@ -746,10 +751,6 @@ static int ext4_ioctl_setproject(struct inode *inode, __u32 projid)
 		brelse(iloc.bh);
 	}
 
-	err = dquot_initialize(inode);
-	if (err)
-		return err;
-
 	handle = ext4_journal_start(inode, EXT4_HT_QUOTA,
 		EXT4_QUOTA_INIT_BLOCKS(sb) +
 		EXT4_QUOTA_DEL_BLOCKS(sb) + 3);
@@ -1153,19 +1154,22 @@ static int ext4_ioctl_getuuid(struct ext4_sb_info *sbi,
 
 	if (fsuuid.fsu_len == 0) {
 		fsuuid.fsu_len = UUID_SIZE;
-		if (copy_to_user(ufsuuid, &fsuuid, sizeof(fsuuid.fsu_len)))
+		if (copy_to_user(&ufsuuid->fsu_len, &fsuuid.fsu_len,
+					sizeof(fsuuid.fsu_len)))
 			return -EFAULT;
-		return -EINVAL;
+		return 0;
 	}
 
-	if (fsuuid.fsu_len != UUID_SIZE || fsuuid.fsu_flags != 0)
+	if (fsuuid.fsu_len < UUID_SIZE || fsuuid.fsu_flags != 0)
 		return -EINVAL;
 
 	lock_buffer(sbi->s_sbh);
 	memcpy(uuid, sbi->s_es->s_uuid, UUID_SIZE);
 	unlock_buffer(sbi->s_sbh);
 
-	if (copy_to_user(&ufsuuid->fsu_uuid[0], uuid, UUID_SIZE))
+	fsuuid.fsu_len = UUID_SIZE;
+	if (copy_to_user(ufsuuid, &fsuuid, sizeof(fsuuid)) ||
+	    copy_to_user(&ufsuuid->fsu_uuid[0], uuid, UUID_SIZE))
 		return -EFAULT;
 	return 0;
 }
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index c08c0aba1883..1c5518a4bdf9 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3204,14 +3204,20 @@ static int ext4_rmdir(struct inode *dir, struct dentry *dentry)
 	return retval;
 }
 
-int __ext4_unlink(handle_t *handle, struct inode *dir, const struct qstr *d_name,
-		  struct inode *inode)
+int __ext4_unlink(struct inode *dir, const struct qstr *d_name,
+		  struct inode *inode,
+		  struct dentry *dentry /* NULL during fast_commit recovery */)
 {
 	int retval = -ENOENT;
 	struct buffer_head *bh;
 	struct ext4_dir_entry_2 *de;
+	handle_t *handle;
 	int skip_remove_dentry = 0;
 
+	/*
+	 * Keep this outside the transaction; it may have to set up the
+	 * directory's encryption key, which isn't GFP_NOFS-safe.
+	 */
 	bh = ext4_find_entry(dir, d_name, &de, NULL);
 	if (IS_ERR(bh))
 		return PTR_ERR(bh);
@@ -3228,7 +3234,14 @@ int __ext4_unlink(handle_t *handle, struct inode *dir, const struct qstr *d_name
 		if (EXT4_SB(inode->i_sb)->s_mount_state & EXT4_FC_REPLAY)
 			skip_remove_dentry = 1;
 		else
-			goto out;
+			goto out_bh;
+	}
+
+	handle = ext4_journal_start(dir, EXT4_HT_DIR,
+				    EXT4_DATA_TRANS_BLOCKS(dir->i_sb));
+	if (IS_ERR(handle)) {
+		retval = PTR_ERR(handle);
+		goto out_bh;
 	}
 
 	if (IS_DIRSYNC(dir))
@@ -3237,12 +3250,12 @@ int __ext4_unlink(handle_t *handle, struct inode *dir, const struct qstr *d_name
 	if (!skip_remove_dentry) {
 		retval = ext4_delete_entry(handle, dir, de, bh);
 		if (retval)
-			goto out;
+			goto out_handle;
 		dir->i_ctime = dir->i_mtime = current_time(dir);
 		ext4_update_dx_flag(dir);
 		retval = ext4_mark_inode_dirty(handle, dir);
 		if (retval)
-			goto out;
+			goto out_handle;
 	} else {
 		retval = 0;
 	}
@@ -3255,15 +3268,17 @@ int __ext4_unlink(handle_t *handle, struct inode *dir, const struct qstr *d_name
 		ext4_orphan_add(handle, inode);
 	inode->i_ctime = current_time(inode);
 	retval = ext4_mark_inode_dirty(handle, inode);
-
-out:
+	if (dentry && !retval)
+		ext4_fc_track_unlink(handle, dentry);
+out_handle:
+	ext4_journal_stop(handle);
+out_bh:
 	brelse(bh);
 	return retval;
 }
 
 static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 {
-	handle_t *handle;
 	int retval;
 
 	if (unlikely(ext4_forced_shutdown(EXT4_SB(dir->i_sb))))
@@ -3281,16 +3296,7 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	if (retval)
 		goto out_trace;
 
-	handle = ext4_journal_start(dir, EXT4_HT_DIR,
-				    EXT4_DATA_TRANS_BLOCKS(dir->i_sb));
-	if (IS_ERR(handle)) {
-		retval = PTR_ERR(handle);
-		goto out_trace;
-	}
-
-	retval = __ext4_unlink(handle, dir, &dentry->d_name, d_inode(dentry));
-	if (!retval)
-		ext4_fc_track_unlink(handle, dentry);
+	retval = __ext4_unlink(dir, &dentry->d_name, d_inode(dentry), dentry);
 #if IS_ENABLED(CONFIG_UNICODE)
 	/* VFS negative dentries are incompatible with Encoding and
 	 * Case-insensitiveness. Eventually we'll want avoid
@@ -3301,8 +3307,6 @@ static int ext4_unlink(struct inode *dir, struct dentry *dentry)
 	if (IS_CASEFOLDED(dir))
 		d_invalidate(dentry);
 #endif
-	if (handle)
-		ext4_journal_stop(handle);
 
 out_trace:
 	trace_ext4_unlink_exit(dentry, retval);
@@ -3792,6 +3796,9 @@ static int ext4_rename(struct user_namespace *mnt_userns, struct inode *old_dir,
 		return -EXDEV;
 
 	retval = dquot_initialize(old.dir);
+	if (retval)
+		return retval;
+	retval = dquot_initialize(old.inode);
 	if (retval)
 		return retval;
 	retval = dquot_initialize(new.dir);
diff --git a/fs/ext4/orphan.c b/fs/ext4/orphan.c
index 69a9cf9137a6..e5b47dda3317 100644
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -412,7 +412,7 @@ void ext4_orphan_cleanup(struct super_block *sb, struct ext4_super_block *es)
 		/* don't clear list on RO mount w/ errors */
 		if (es->s_last_orphan && !(s_flags & SB_RDONLY)) {
 			ext4_msg(sb, KERN_INFO, "Errors on filesystem, "
-				  "clearing orphan list.\n");
+				  "clearing orphan list.");
 			es->s_last_orphan = 0;
 		}
 		ext4_debug("Skipping orphan recovery on fs with errors.\n");
diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
index 46b87ffeb304..b493233750ab 100644
--- a/fs/ext4/resize.c
+++ b/fs/ext4/resize.c
@@ -1110,6 +1110,16 @@ static int reserve_backup_gdb(handle_t *handle, struct inode *inode,
 	return err;
 }
 
+static inline void ext4_set_block_group_nr(struct super_block *sb, char *data,
+					   ext4_group_t group)
+{
+	struct ext4_super_block *es = (struct ext4_super_block *) data;
+
+	es->s_block_group_nr = cpu_to_le16(group);
+	if (ext4_has_metadata_csum(sb))
+		es->s_checksum = ext4_superblock_csum(sb, es);
+}
+
 /*
  * Update the backup copies of the ext4 metadata.  These don't need to be part
  * of the main resize transaction, because e2fsck will re-write them if there
@@ -1158,7 +1168,8 @@ static void update_backups(struct super_block *sb, sector_t blk_off, char *data,
 	while (group < sbi->s_groups_count) {
 		struct buffer_head *bh;
 		ext4_fsblk_t backup_block;
-		struct ext4_super_block *es;
+		int has_super = ext4_bg_has_super(sb, group);
+		ext4_fsblk_t first_block = ext4_group_first_block_no(sb, group);
 
 		/* Out of journal space, and can't get more - abort - so sad */
 		err = ext4_resize_ensure_credits_batch(handle, 1);
@@ -1168,8 +1179,7 @@ static void update_backups(struct super_block *sb, sector_t blk_off, char *data,
 		if (meta_bg == 0)
 			backup_block = ((ext4_fsblk_t)group) * bpg + blk_off;
 		else
-			backup_block = (ext4_group_first_block_no(sb, group) +
-					ext4_bg_has_super(sb, group));
+			backup_block = first_block + has_super;
 
 		bh = sb_getblk(sb, backup_block);
 		if (unlikely(!bh)) {
@@ -1187,10 +1197,8 @@ static void update_backups(struct super_block *sb, sector_t blk_off, char *data,
 		memcpy(bh->b_data, data, size);
 		if (rest)
 			memset(bh->b_data + size, 0, rest);
-		es = (struct ext4_super_block *) bh->b_data;
-		es->s_block_group_nr = cpu_to_le16(group);
-		if (ext4_has_metadata_csum(sb))
-			es->s_checksum = ext4_superblock_csum(sb, es);
+		if (has_super && (backup_block == first_block))
+			ext4_set_block_group_nr(sb, bh->b_data, group);
 		set_buffer_uptodate(bh);
 		unlock_buffer(bh);
 		err = ext4_handle_dirty_metadata(handle, NULL, bh);
@@ -1476,8 +1484,6 @@ static void ext4_update_super(struct super_block *sb,
 	 * active. */
 	ext4_r_blocks_count_set(es, ext4_r_blocks_count(es) +
 				reserved_blocks);
-	ext4_superblock_csum_set(sb);
-	unlock_buffer(sbi->s_sbh);
 
 	/* Update the free space counts */
 	percpu_counter_add(&sbi->s_freeclusters_counter,
@@ -1513,6 +1519,8 @@ static void ext4_update_super(struct super_block *sb,
 		ext4_calculate_overhead(sb);
 	es->s_overhead_clusters = cpu_to_le32(sbi->s_overhead);
 
+	ext4_superblock_csum_set(sb);
+	unlock_buffer(sbi->s_sbh);
 	if (test_opt(sb, DEBUG))
 		printk(KERN_DEBUG "EXT4-fs: added group %u:"
 		       "%llu blocks(%llu free %llu reserved)\n", flex_gd->count,
@@ -1596,8 +1604,8 @@ static int ext4_flex_group_add(struct super_block *sb,
 		int meta_bg = ext4_has_feature_meta_bg(sb);
 		sector_t old_gdb = 0;
 
-		update_backups(sb, sbi->s_sbh->b_blocknr, (char *)es,
-			       sizeof(struct ext4_super_block), 0);
+		update_backups(sb, ext4_group_first_block_no(sb, 0),
+			       (char *)es, sizeof(struct ext4_super_block), 0);
 		for (; gdb_num <= gdb_num_end; gdb_num++) {
 			struct buffer_head *gdb_bh;
 
@@ -1808,7 +1816,7 @@ static int ext4_group_extend_no_check(struct super_block *sb,
 		if (test_opt(sb, DEBUG))
 			printk(KERN_DEBUG "EXT4-fs: extended group to %llu "
 			       "blocks\n", ext4_blocks_count(es));
-		update_backups(sb, EXT4_SB(sb)->s_sbh->b_blocknr,
+		update_backups(sb, ext4_group_first_block_no(sb, 0),
 			       (char *)es, sizeof(struct ext4_super_block), 0);
 	}
 	return err;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 7cdd2138c897..aa4f65663fad 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1323,6 +1323,7 @@ static struct inode *ext4_alloc_inode(struct super_block *sb)
 		return NULL;
 
 	inode_set_iversion(&ei->vfs_inode, 1);
+	ei->i_flags = 0;
 	spin_lock_init(&ei->i_raw_lock);
 	INIT_LIST_HEAD(&ei->i_prealloc_list);
 	atomic_set(&ei->i_prealloc_active, 0);
@@ -2247,7 +2248,7 @@ static int ext4_parse_param(struct fs_context *fc, struct fs_parameter *param)
 			return -EINVAL;
 		}
 
-		error = fs_lookup_param(fc, param, 1, &path);
+		error = fs_lookup_param(fc, param, 1, LOOKUP_FOLLOW, &path);
 		if (error) {
 			ext4_msg(NULL, KERN_ERR, "error: could not find "
 				 "journal device path");
@@ -5287,14 +5288,15 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 		goto failed_mount3a;
 	} else {
 		/* Nojournal mode, all journal mount options are illegal */
-		if (test_opt2(sb, EXPLICIT_JOURNAL_CHECKSUM)) {
+		if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "journal_checksum, fs mounted w/o journal");
+				 "journal_async_commit, fs mounted w/o journal");
 			goto failed_mount3a;
 		}
-		if (test_opt(sb, JOURNAL_ASYNC_COMMIT)) {
+
+		if (test_opt2(sb, EXPLICIT_JOURNAL_CHECKSUM)) {
 			ext4_msg(sb, KERN_ERR, "can't mount with "
-				 "journal_async_commit, fs mounted w/o journal");
+				 "journal_checksum, fs mounted w/o journal");
 			goto failed_mount3a;
 		}
 		if (sbi->s_commit_interval != JBD2_DEFAULT_MAX_COMMIT_AGE*HZ) {
@@ -5723,7 +5725,7 @@ static struct inode *ext4_get_journal_inode(struct super_block *sb,
 
 	ext4_debug("Journal inode found at %p: %lld bytes\n",
 		  journal_inode, journal_inode->i_size);
-	if (!S_ISREG(journal_inode->i_mode)) {
+	if (!S_ISREG(journal_inode->i_mode) || IS_ENCRYPTED(journal_inode)) {
 		ext4_msg(sb, KERN_ERR, "invalid journal inode");
 		iput(journal_inode);
 		return NULL;
@@ -6886,6 +6888,20 @@ static int ext4_quota_on(struct super_block *sb, int type, int format_id,
 	return err;
 }
 
+static inline bool ext4_check_quota_inum(int type, unsigned long qf_inum)
+{
+	switch (type) {
+	case USRQUOTA:
+		return qf_inum == EXT4_USR_QUOTA_INO;
+	case GRPQUOTA:
+		return qf_inum == EXT4_GRP_QUOTA_INO;
+	case PRJQUOTA:
+		return qf_inum >= EXT4_GOOD_OLD_FIRST_INO;
+	default:
+		BUG();
+	}
+}
+
 static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 			     unsigned int flags)
 {
@@ -6902,9 +6918,16 @@ static int ext4_quota_enable(struct super_block *sb, int type, int format_id,
 	if (!qf_inums[type])
 		return -EPERM;
 
+	if (!ext4_check_quota_inum(type, qf_inums[type])) {
+		ext4_error(sb, "Bad quota inum: %lu, type: %d",
+				qf_inums[type], type);
+		return -EUCLEAN;
+	}
+
 	qf_inode = ext4_iget(sb, qf_inums[type], EXT4_IGET_SPECIAL);
 	if (IS_ERR(qf_inode)) {
-		ext4_error(sb, "Bad quota inode # %lu", qf_inums[type]);
+		ext4_error(sb, "Bad quota inode: %lu, type: %d",
+				qf_inums[type], type);
 		return PTR_ERR(qf_inode);
 	}
 
@@ -6943,8 +6966,9 @@ int ext4_enable_quotas(struct super_block *sb)
 			if (err) {
 				ext4_warning(sb,
 					"Failed to enable quota tracking "
-					"(type=%d, err=%d). Please run "
-					"e2fsck to fix.", type, err);
+					"(type=%d, err=%d, ino=%lu). "
+					"Please run e2fsck to fix.", type,
+					err, qf_inums[type]);
 				for (type--; type >= 0; type--) {
 					struct inode *inode;
 
diff --git a/fs/ext4/verity.c b/fs/ext4/verity.c
index 3c640bd7ecae..30e3b65798b5 100644
--- a/fs/ext4/verity.c
+++ b/fs/ext4/verity.c
@@ -79,7 +79,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		size_t n = min_t(size_t, count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
-		void *fsdata;
+		void *fsdata = NULL;
 		int res;
 
 		res = aops->write_begin(NULL, mapping, pos, n, &page, &fsdata);
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 36d6ba7190b6..866772a2e068 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1281,7 +1281,7 @@ ext4_xattr_release_block(handle_t *handle, struct inode *inode,
 				ce = mb_cache_entry_get(ea_block_cache, hash,
 							bh->b_blocknr);
 				if (ce) {
-					ce->e_reusable = 1;
+					set_bit(MBE_REUSABLE_B, &ce->e_flags);
 					mb_cache_entry_put(ea_block_cache, ce);
 				}
 			}
@@ -1441,6 +1441,9 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
 		if (!err)
 			err = ext4_inode_attach_jinode(ea_inode);
 		if (err) {
+			if (ext4_xattr_inode_dec_ref(handle, ea_inode))
+				ext4_warning_inode(ea_inode,
+					"cleanup dec ref error %d", err);
 			iput(ea_inode);
 			return ERR_PTR(err);
 		}
@@ -2042,7 +2045,7 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 				}
 				BHDR(new_bh)->h_refcount = cpu_to_le32(ref);
 				if (ref == EXT4_XATTR_REFCOUNT_MAX)
-					ce->e_reusable = 0;
+					clear_bit(MBE_REUSABLE_B, &ce->e_flags);
 				ea_bdebug(new_bh, "reusing; refcount now=%d",
 					  ref);
 				ext4_xattr_block_csum_set(inode, new_bh);
@@ -2070,19 +2073,11 @@ ext4_xattr_block_set(handle_t *handle, struct inode *inode,
 
 			goal = ext4_group_first_block_no(sb,
 						EXT4_I(inode)->i_block_group);
-
-			/* non-extent files can't have physical blocks past 2^32 */
-			if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-				goal = goal & EXT4_MAX_BLOCK_FILE_PHYS;
-
 			block = ext4_new_meta_blocks(handle, inode, goal, 0,
 						     NULL, &error);
 			if (error)
 				goto cleanup;
 
-			if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-				BUG_ON(block > EXT4_MAX_BLOCK_FILE_PHYS);
-
 			ea_idebug(inode, "creating block %llu",
 				  (unsigned long long)block);
 
@@ -2555,7 +2550,7 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 
 	is = kzalloc(sizeof(struct ext4_xattr_ibody_find), GFP_NOFS);
 	bs = kzalloc(sizeof(struct ext4_xattr_block_find), GFP_NOFS);
-	buffer = kmalloc(value_size, GFP_NOFS);
+	buffer = kvmalloc(value_size, GFP_NOFS);
 	b_entry_name = kmalloc(entry->e_name_len + 1, GFP_NOFS);
 	if (!is || !bs || !buffer || !b_entry_name) {
 		error = -ENOMEM;
@@ -2607,7 +2602,7 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 	error = 0;
 out:
 	kfree(b_entry_name);
-	kfree(buffer);
+	kvfree(buffer);
 	if (is)
 		brelse(is->iloc.bh);
 	if (bs)
diff --git a/fs/fs_parser.c b/fs/fs_parser.c
index ed40ce5742fd..edb3712dcfa5 100644
--- a/fs/fs_parser.c
+++ b/fs/fs_parser.c
@@ -138,15 +138,16 @@ EXPORT_SYMBOL(__fs_parse);
  * @fc: The filesystem context to log errors through.
  * @param: The parameter.
  * @want_bdev: T if want a blockdev
+ * @flags: Pathwalk flags passed to filename_lookup()
  * @_path: The result of the lookup
  */
 int fs_lookup_param(struct fs_context *fc,
 		    struct fs_parameter *param,
 		    bool want_bdev,
+		    unsigned int flags,
 		    struct path *_path)
 {
 	struct filename *f;
-	unsigned int flags = 0;
 	bool put_f;
 	int ret;
 
diff --git a/fs/mbcache.c b/fs/mbcache.c
index e272ad738faf..2a4b8b549e93 100644
--- a/fs/mbcache.c
+++ b/fs/mbcache.c
@@ -100,8 +100,9 @@ int mb_cache_entry_create(struct mb_cache *cache, gfp_t mask, u32 key,
 	atomic_set(&entry->e_refcnt, 2);
 	entry->e_key = key;
 	entry->e_value = value;
-	entry->e_reusable = reusable;
-	entry->e_referenced = 0;
+	entry->e_flags = 0;
+	if (reusable)
+		set_bit(MBE_REUSABLE_B, &entry->e_flags);
 	head = mb_cache_entry_head(cache, key);
 	hlist_bl_lock(head);
 	hlist_bl_for_each_entry(dup, dup_node, head, e_hash_list) {
@@ -165,7 +166,8 @@ static struct mb_cache_entry *__entry_find(struct mb_cache *cache,
 	while (node) {
 		entry = hlist_bl_entry(node, struct mb_cache_entry,
 				       e_hash_list);
-		if (entry->e_key == key && entry->e_reusable &&
+		if (entry->e_key == key &&
+		    test_bit(MBE_REUSABLE_B, &entry->e_flags) &&
 		    atomic_inc_not_zero(&entry->e_refcnt))
 			goto out;
 		node = node->next;
@@ -284,7 +286,7 @@ EXPORT_SYMBOL(mb_cache_entry_delete_or_get);
 void mb_cache_entry_touch(struct mb_cache *cache,
 			  struct mb_cache_entry *entry)
 {
-	entry->e_referenced = 1;
+	set_bit(MBE_REFERENCED_B, &entry->e_flags);
 }
 EXPORT_SYMBOL(mb_cache_entry_touch);
 
@@ -309,9 +311,9 @@ static unsigned long mb_cache_shrink(struct mb_cache *cache,
 		entry = list_first_entry(&cache->c_list,
 					 struct mb_cache_entry, e_list);
 		/* Drop initial hash reference if there is no user */
-		if (entry->e_referenced ||
+		if (test_bit(MBE_REFERENCED_B, &entry->e_flags) ||
 		    atomic_cmpxchg(&entry->e_refcnt, 1, 0) != 1) {
-			entry->e_referenced = 0;
+			clear_bit(MBE_REFERENCED_B, &entry->e_flags);
 			list_move_tail(&entry->e_list, &cache->c_list);
 			continue;
 		}
diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index 0427b44bfee5..f27faf5db554 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2324,6 +2324,8 @@ static int vfs_setup_quota_inode(struct inode *inode, int type)
 	struct super_block *sb = inode->i_sb;
 	struct quota_info *dqopt = sb_dqopt(sb);
 
+	if (is_bad_inode(inode))
+		return -EUCLEAN;
 	if (!S_ISREG(inode->i_mode))
 		return -EACCES;
 	if (IS_RDONLY(inode))
diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 9e1e6965f407..0eb8f035b3d9 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -642,7 +642,7 @@ static inline u32 type_flag(u32 type)
 }
 
 /* only use after check_attach_btf_id() */
-static inline enum bpf_prog_type resolve_prog_type(struct bpf_prog *prog)
+static inline enum bpf_prog_type resolve_prog_type(const struct bpf_prog *prog)
 {
 	return prog->type == BPF_PROG_TYPE_EXT ?
 		prog->aux->dst_prog->type : prog->type;
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index 34aab4dd336c..4dc7cda4fd46 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -152,8 +152,8 @@ struct devfreq_stats {
  * @max_state:		count of entry present in the frequency table.
  * @previous_freq:	previously configured frequency value.
  * @last_status:	devfreq user device info, performance statistics
- * @data:	Private data of the governor. The devfreq framework does not
- *		touch this.
+ * @data:	devfreq driver pass to governors, governor should not change it.
+ * @governor_data:	private data for governors, devfreq core doesn't touch it.
  * @user_min_freq_req:	PM QoS minimum frequency request from user (via sysfs)
  * @user_max_freq_req:	PM QoS maximum frequency request from user (via sysfs)
  * @scaling_min_freq:	Limit minimum frequency requested by OPP interface
@@ -193,7 +193,8 @@ struct devfreq {
 	unsigned long previous_freq;
 	struct devfreq_dev_status last_status;
 
-	void *data; /* private data for governors */
+	void *data;
+	void *governor_data;
 
 	struct dev_pm_qos_request user_min_freq_req;
 	struct dev_pm_qos_request user_max_freq_req;
diff --git a/include/linux/fs_parser.h b/include/linux/fs_parser.h
index f103c91139d4..01542c4b87a2 100644
--- a/include/linux/fs_parser.h
+++ b/include/linux/fs_parser.h
@@ -76,6 +76,7 @@ static inline int fs_parse(struct fs_context *fc,
 extern int fs_lookup_param(struct fs_context *fc,
 			   struct fs_parameter *param,
 			   bool want_bdev,
+			   unsigned int flags,
 			   struct path *_path);
 
 extern int lookup_constant(const struct constant_table tbl[], const char *name, int not_found);
diff --git a/include/linux/mbcache.h b/include/linux/mbcache.h
index 2da63fd7b98f..97e64184767d 100644
--- a/include/linux/mbcache.h
+++ b/include/linux/mbcache.h
@@ -10,6 +10,12 @@
 
 struct mb_cache;
 
+/* Cache entry flags */
+enum {
+	MBE_REFERENCED_B = 0,
+	MBE_REUSABLE_B
+};
+
 struct mb_cache_entry {
 	/* List of entries in cache - protected by cache->c_list_lock */
 	struct list_head	e_list;
@@ -26,8 +32,7 @@ struct mb_cache_entry {
 	atomic_t		e_refcnt;
 	/* Key in hash - stable during lifetime of the entry */
 	u32			e_key;
-	u32			e_referenced:1;
-	u32			e_reusable:1;
+	unsigned long		e_flags;
 	/* User provided value - stable during lifetime of the entry */
 	u64			e_value;
 };
diff --git a/include/linux/prandom.h b/include/linux/prandom.h
index e0a0759dd09c..1f4a0de7b019 100644
--- a/include/linux/prandom.h
+++ b/include/linux/prandom.h
@@ -23,24 +23,10 @@ void prandom_seed_full_state(struct rnd_state __percpu *pcpu_state);
 #define prandom_init_once(pcpu_state)			\
 	DO_ONCE(prandom_seed_full_state, (pcpu_state))
 
-/**
- * prandom_u32_max - returns a pseudo-random number in interval [0, ep_ro)
- * @ep_ro: right open interval endpoint
- *
- * Returns a pseudo-random number that is in interval [0, ep_ro). This is
- * useful when requesting a random index of an array containing ep_ro elements,
- * for example. The result is somewhat biased when ep_ro is not a power of 2,
- * so do not use this for cryptographic purposes.
- *
- * Returns: pseudo-random number in interval [0, ep_ro)
- */
+/* Deprecated: use get_random_u32_below() instead. */
 static inline u32 prandom_u32_max(u32 ep_ro)
 {
-	if (__builtin_constant_p(ep_ro <= 1U << 8) && ep_ro <= 1U << 8)
-		return (get_random_u8() * ep_ro) >> 8;
-	if (__builtin_constant_p(ep_ro <= 1U << 16) && ep_ro <= 1U << 16)
-		return (get_random_u16() * ep_ro) >> 16;
-	return ((u64)get_random_u32() * ep_ro) >> 32;
+	return get_random_u32_below(ep_ro);
 }
 
 /*
diff --git a/include/linux/random.h b/include/linux/random.h
index 147a5e0d0b8e..bd954ecbef90 100644
--- a/include/linux/random.h
+++ b/include/linux/random.h
@@ -51,6 +51,71 @@ static inline unsigned long get_random_long(void)
 #endif
 }
 
+u32 __get_random_u32_below(u32 ceil);
+
+/*
+ * Returns a random integer in the interval [0, ceil), with uniform
+ * distribution, suitable for all uses. Fastest when ceil is a constant, but
+ * still fast for variable ceil as well.
+ */
+static inline u32 get_random_u32_below(u32 ceil)
+{
+	if (!__builtin_constant_p(ceil))
+		return __get_random_u32_below(ceil);
+
+	/*
+	 * For the fast path, below, all operations on ceil are precomputed by
+	 * the compiler, so this incurs no overhead for checking pow2, doing
+	 * divisions, or branching based on integer size. The resultant
+	 * algorithm does traditional reciprocal multiplication (typically
+	 * optimized by the compiler into shifts and adds), rejecting samples
+	 * whose lower half would indicate a range indivisible by ceil.
+	 */
+	BUILD_BUG_ON_MSG(!ceil, "get_random_u32_below() must take ceil > 0");
+	if (ceil <= 1)
+		return 0;
+	for (;;) {
+		if (ceil <= 1U << 8) {
+			u32 mult = ceil * get_random_u8();
+			if (likely(is_power_of_2(ceil) || (u8)mult >= (1U << 8) % ceil))
+				return mult >> 8;
+		} else if (ceil <= 1U << 16) {
+			u32 mult = ceil * get_random_u16();
+			if (likely(is_power_of_2(ceil) || (u16)mult >= (1U << 16) % ceil))
+				return mult >> 16;
+		} else {
+			u64 mult = (u64)ceil * get_random_u32();
+			if (likely(is_power_of_2(ceil) || (u32)mult >= -ceil % ceil))
+				return mult >> 32;
+		}
+	}
+}
+
+/*
+ * Returns a random integer in the interval (floor, U32_MAX], with uniform
+ * distribution, suitable for all uses. Fastest when floor is a constant, but
+ * still fast for variable floor as well.
+ */
+static inline u32 get_random_u32_above(u32 floor)
+{
+	BUILD_BUG_ON_MSG(__builtin_constant_p(floor) && floor == U32_MAX,
+			 "get_random_u32_above() must take floor < U32_MAX");
+	return floor + 1 + get_random_u32_below(U32_MAX - floor);
+}
+
+/*
+ * Returns a random integer in the interval [floor, ceil], with uniform
+ * distribution, suitable for all uses. Fastest when floor and ceil are
+ * constant, but still fast for variable floor and ceil as well.
+ */
+static inline u32 get_random_u32_inclusive(u32 floor, u32 ceil)
+{
+	BUILD_BUG_ON_MSG(__builtin_constant_p(floor) && __builtin_constant_p(ceil) &&
+			 (floor > ceil || ceil - floor == U32_MAX),
+			 "get_random_u32_inclusive() must take floor <= ceil");
+	return floor + get_random_u32_below(ceil - floor + 1);
+}
+
 /*
  * On 64-bit architectures, protect against non-terminated C string overflows
  * by zeroing out the first byte of the canary; this leaves 56 bits of entropy.
diff --git a/include/net/mptcp.h b/include/net/mptcp.h
index 412479ebf5ad..3c5c68618fcc 100644
--- a/include/net/mptcp.h
+++ b/include/net/mptcp.h
@@ -97,8 +97,6 @@ struct mptcp_out_options {
 };
 
 #ifdef CONFIG_MPTCP
-extern struct request_sock_ops mptcp_subflow_request_sock_ops;
-
 void mptcp_init(void);
 
 static inline bool sk_is_mptcp(const struct sock *sk)
@@ -188,6 +186,9 @@ void mptcp_seq_show(struct seq_file *seq);
 int mptcp_subflow_init_cookie_req(struct request_sock *req,
 				  const struct sock *sk_listener,
 				  struct sk_buff *skb);
+struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
+					       struct sock *sk_listener,
+					       bool attach_listener);
 
 __be32 mptcp_get_reset_option(const struct sk_buff *skb);
 
@@ -274,6 +275,13 @@ static inline int mptcp_subflow_init_cookie_req(struct request_sock *req,
 	return 0; /* TCP fallback */
 }
 
+static inline struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
+							     struct sock *sk_listener,
+							     bool attach_listener)
+{
+	return NULL;
+}
+
 static inline __be32 mptcp_reset_option(const struct sk_buff *skb)  { return htonl(0u); }
 #endif /* CONFIG_MPTCP */
 
diff --git a/include/trace/events/ext4.h b/include/trace/events/ext4.h
index 229e8fae66a3..ced95fec3367 100644
--- a/include/trace/events/ext4.h
+++ b/include/trace/events/ext4.h
@@ -104,6 +104,7 @@ TRACE_DEFINE_ENUM(EXT4_FC_REASON_RESIZE);
 TRACE_DEFINE_ENUM(EXT4_FC_REASON_RENAME_DIR);
 TRACE_DEFINE_ENUM(EXT4_FC_REASON_FALLOC_RANGE);
 TRACE_DEFINE_ENUM(EXT4_FC_REASON_INODE_JOURNAL_DATA);
+TRACE_DEFINE_ENUM(EXT4_FC_REASON_ENCRYPTED_FILENAME);
 TRACE_DEFINE_ENUM(EXT4_FC_REASON_MAX);
 
 #define show_fc_reason(reason)						\
@@ -116,7 +117,8 @@ TRACE_DEFINE_ENUM(EXT4_FC_REASON_MAX);
 		{ EXT4_FC_REASON_RESIZE,	"RESIZE"},		\
 		{ EXT4_FC_REASON_RENAME_DIR,	"RENAME_DIR"},		\
 		{ EXT4_FC_REASON_FALLOC_RANGE,	"FALLOC_RANGE"},	\
-		{ EXT4_FC_REASON_INODE_JOURNAL_DATA,	"INODE_JOURNAL_DATA"})
+		{ EXT4_FC_REASON_INODE_JOURNAL_DATA,	"INODE_JOURNAL_DATA"}, \
+		{ EXT4_FC_REASON_ENCRYPTED_FILENAME,	"ENCRYPTED_FILENAME"})
 
 TRACE_EVENT(ext4_other_inode_update_time,
 	TP_PROTO(struct inode *inode, ino_t orig_ino),
@@ -2764,7 +2766,7 @@ TRACE_EVENT(ext4_fc_stats,
 	),
 
 	TP_printk("dev %d,%d fc ineligible reasons:\n"
-		  "%s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u "
+		  "%s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u, %s:%u"
 		  "num_commits:%lu, ineligible: %lu, numblks: %lu",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_XATTR),
@@ -2776,6 +2778,7 @@ TRACE_EVENT(ext4_fc_stats,
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_RENAME_DIR),
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_FALLOC_RANGE),
 		  FC_REASON_NAME_STAT(EXT4_FC_REASON_INODE_JOURNAL_DATA),
+		  FC_REASON_NAME_STAT(EXT4_FC_REASON_ENCRYPTED_FILENAME),
 		  __entry->fc_commits, __entry->fc_ineligible_commits,
 		  __entry->fc_numblks)
 );
diff --git a/include/trace/events/jbd2.h b/include/trace/events/jbd2.h
index 99f783c384bb..8f5ee380d309 100644
--- a/include/trace/events/jbd2.h
+++ b/include/trace/events/jbd2.h
@@ -40,7 +40,7 @@ DECLARE_EVENT_CLASS(jbd2_commit,
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	char,	sync_commit		  )
-		__field(	int,	transaction		  )
+		__field(	tid_t,	transaction		  )
 	),
 
 	TP_fast_assign(
@@ -49,7 +49,7 @@ DECLARE_EVENT_CLASS(jbd2_commit,
 		__entry->transaction	= commit_transaction->t_tid;
 	),
 
-	TP_printk("dev %d,%d transaction %d sync %d",
+	TP_printk("dev %d,%d transaction %u sync %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->transaction, __entry->sync_commit)
 );
@@ -97,8 +97,8 @@ TRACE_EVENT(jbd2_end_commit,
 	TP_STRUCT__entry(
 		__field(	dev_t,	dev			)
 		__field(	char,	sync_commit		  )
-		__field(	int,	transaction		  )
-		__field(	int,	head		  	  )
+		__field(	tid_t,	transaction		  )
+		__field(	tid_t,	head		  	  )
 	),
 
 	TP_fast_assign(
@@ -108,7 +108,7 @@ TRACE_EVENT(jbd2_end_commit,
 		__entry->head		= journal->j_tail_sequence;
 	),
 
-	TP_printk("dev %d,%d transaction %d sync %d head %d",
+	TP_printk("dev %d,%d transaction %u sync %d head %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->transaction, __entry->sync_commit, __entry->head)
 );
@@ -134,14 +134,14 @@ TRACE_EVENT(jbd2_submit_inode_data,
 );
 
 DECLARE_EVENT_CLASS(jbd2_handle_start_class,
-	TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
+	TP_PROTO(dev_t dev, tid_t tid, unsigned int type,
 		 unsigned int line_no, int requested_blocks),
 
 	TP_ARGS(dev, tid, type, line_no, requested_blocks),
 
 	TP_STRUCT__entry(
 		__field(		dev_t,	dev		)
-		__field(	unsigned long,	tid		)
+		__field(		tid_t,	tid		)
 		__field(	 unsigned int,	type		)
 		__field(	 unsigned int,	line_no		)
 		__field(		  int,	requested_blocks)
@@ -155,28 +155,28 @@ DECLARE_EVENT_CLASS(jbd2_handle_start_class,
 		__entry->requested_blocks = requested_blocks;
 	),
 
-	TP_printk("dev %d,%d tid %lu type %u line_no %u "
+	TP_printk("dev %d,%d tid %u type %u line_no %u "
 		  "requested_blocks %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
 		  __entry->type, __entry->line_no, __entry->requested_blocks)
 );
 
 DEFINE_EVENT(jbd2_handle_start_class, jbd2_handle_start,
-	TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
+	TP_PROTO(dev_t dev, tid_t tid, unsigned int type,
 		 unsigned int line_no, int requested_blocks),
 
 	TP_ARGS(dev, tid, type, line_no, requested_blocks)
 );
 
 DEFINE_EVENT(jbd2_handle_start_class, jbd2_handle_restart,
-	TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
+	TP_PROTO(dev_t dev, tid_t tid, unsigned int type,
 		 unsigned int line_no, int requested_blocks),
 
 	TP_ARGS(dev, tid, type, line_no, requested_blocks)
 );
 
 TRACE_EVENT(jbd2_handle_extend,
-	TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
+	TP_PROTO(dev_t dev, tid_t tid, unsigned int type,
 		 unsigned int line_no, int buffer_credits,
 		 int requested_blocks),
 
@@ -184,7 +184,7 @@ TRACE_EVENT(jbd2_handle_extend,
 
 	TP_STRUCT__entry(
 		__field(		dev_t,	dev		)
-		__field(	unsigned long,	tid		)
+		__field(		tid_t,	tid		)
 		__field(	 unsigned int,	type		)
 		__field(	 unsigned int,	line_no		)
 		__field(		  int,	buffer_credits  )
@@ -200,7 +200,7 @@ TRACE_EVENT(jbd2_handle_extend,
 		__entry->requested_blocks = requested_blocks;
 	),
 
-	TP_printk("dev %d,%d tid %lu type %u line_no %u "
+	TP_printk("dev %d,%d tid %u type %u line_no %u "
 		  "buffer_credits %d requested_blocks %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
 		  __entry->type, __entry->line_no, __entry->buffer_credits,
@@ -208,7 +208,7 @@ TRACE_EVENT(jbd2_handle_extend,
 );
 
 TRACE_EVENT(jbd2_handle_stats,
-	TP_PROTO(dev_t dev, unsigned long tid, unsigned int type,
+	TP_PROTO(dev_t dev, tid_t tid, unsigned int type,
 		 unsigned int line_no, int interval, int sync,
 		 int requested_blocks, int dirtied_blocks),
 
@@ -217,7 +217,7 @@ TRACE_EVENT(jbd2_handle_stats,
 
 	TP_STRUCT__entry(
 		__field(		dev_t,	dev		)
-		__field(	unsigned long,	tid		)
+		__field(		tid_t,	tid		)
 		__field(	 unsigned int,	type		)
 		__field(	 unsigned int,	line_no		)
 		__field(		  int,	interval	)
@@ -237,7 +237,7 @@ TRACE_EVENT(jbd2_handle_stats,
 		__entry->dirtied_blocks	  = dirtied_blocks;
 	),
 
-	TP_printk("dev %d,%d tid %lu type %u line_no %u interval %d "
+	TP_printk("dev %d,%d tid %u type %u line_no %u interval %d "
 		  "sync %d requested_blocks %d dirtied_blocks %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
 		  __entry->type, __entry->line_no, __entry->interval,
@@ -246,14 +246,14 @@ TRACE_EVENT(jbd2_handle_stats,
 );
 
 TRACE_EVENT(jbd2_run_stats,
-	TP_PROTO(dev_t dev, unsigned long tid,
+	TP_PROTO(dev_t dev, tid_t tid,
 		 struct transaction_run_stats_s *stats),
 
 	TP_ARGS(dev, tid, stats),
 
 	TP_STRUCT__entry(
 		__field(		dev_t,	dev		)
-		__field(	unsigned long,	tid		)
+		__field(		tid_t,	tid		)
 		__field(	unsigned long,	wait		)
 		__field(	unsigned long,	request_delay	)
 		__field(	unsigned long,	running		)
@@ -279,7 +279,7 @@ TRACE_EVENT(jbd2_run_stats,
 		__entry->blocks_logged	= stats->rs_blocks_logged;
 	),
 
-	TP_printk("dev %d,%d tid %lu wait %u request_delay %u running %u "
+	TP_printk("dev %d,%d tid %u wait %u request_delay %u running %u "
 		  "locked %u flushing %u logging %u handle_count %u "
 		  "blocks %u blocks_logged %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
@@ -294,14 +294,14 @@ TRACE_EVENT(jbd2_run_stats,
 );
 
 TRACE_EVENT(jbd2_checkpoint_stats,
-	TP_PROTO(dev_t dev, unsigned long tid,
+	TP_PROTO(dev_t dev, tid_t tid,
 		 struct transaction_chp_stats_s *stats),
 
 	TP_ARGS(dev, tid, stats),
 
 	TP_STRUCT__entry(
 		__field(		dev_t,	dev		)
-		__field(	unsigned long,	tid		)
+		__field(		tid_t,	tid		)
 		__field(	unsigned long,	chp_time	)
 		__field(		__u32,	forced_to_close	)
 		__field(		__u32,	written		)
@@ -317,7 +317,7 @@ TRACE_EVENT(jbd2_checkpoint_stats,
 		__entry->dropped	= stats->cs_dropped;
 	),
 
-	TP_printk("dev %d,%d tid %lu chp_time %u forced_to_close %u "
+	TP_printk("dev %d,%d tid %u chp_time %u forced_to_close %u "
 		  "written %u dropped %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->tid,
 		  jiffies_to_msecs(__entry->chp_time),
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 25a54e04560e..17ab3e15ac25 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -2088,6 +2088,7 @@ static unsigned int __bpf_prog_ret0_warn(const void *ctx,
 bool bpf_prog_map_compatible(struct bpf_map *map,
 			     const struct bpf_prog *fp)
 {
+	enum bpf_prog_type prog_type = resolve_prog_type(fp);
 	bool ret;
 
 	if (fp->kprobe_override)
@@ -2098,12 +2099,12 @@ bool bpf_prog_map_compatible(struct bpf_map *map,
 		/* There's no owner yet where we could check for
 		 * compatibility.
 		 */
-		map->owner.type  = fp->type;
+		map->owner.type  = prog_type;
 		map->owner.jited = fp->jited;
 		map->owner.xdp_has_frags = fp->aux->xdp_has_frags;
 		ret = true;
 	} else {
-		ret = map->owner.type  == fp->type &&
+		ret = map->owner.type  == prog_type &&
 		      map->owner.jited == fp->jited &&
 		      map->owner.xdp_has_frags == fp->aux->xdp_has_frags;
 	}
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 732b392fc5c6..3b9e86108f43 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12231,12 +12231,12 @@ SYSCALL_DEFINE5(perf_event_open,
 	if (flags & ~PERF_FLAG_ALL)
 		return -EINVAL;
 
-	/* Do we allow access to perf_event_open(2) ? */
-	err = security_perf_event_open(&attr, PERF_SECURITY_OPEN);
+	err = perf_copy_attr(attr_uptr, &attr);
 	if (err)
 		return err;
 
-	err = perf_copy_attr(attr_uptr, &attr);
+	/* Do we allow access to perf_event_open(2) ? */
+	err = security_perf_event_open(&attr, PERF_SECURITY_OPEN);
 	if (err)
 		return err;
 
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index e9e95c790b8e..93d724996283 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -375,6 +375,7 @@ config SCHED_TRACER
 config HWLAT_TRACER
 	bool "Tracer to detect hardware latencies (like SMIs)"
 	select GENERIC_TRACER
+	select TRACER_MAX_TRACE
 	help
 	 This tracer, when enabled will create one or more kernel threads,
 	 depending on what the cpumask file is set to, which each thread
@@ -410,6 +411,7 @@ config HWLAT_TRACER
 config OSNOISE_TRACER
 	bool "OS Noise tracer"
 	select GENERIC_TRACER
+	select TRACER_MAX_TRACE
 	help
 	  In the context of high-performance computing (HPC), the Operating
 	  System Noise (osnoise) refers to the interference experienced by an
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 5cfc95a52bc3..3076af8dbf32 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1421,6 +1421,7 @@ int tracing_snapshot_cond_disable(struct trace_array *tr)
 	return false;
 }
 EXPORT_SYMBOL_GPL(tracing_snapshot_cond_disable);
+#define free_snapshot(tr)	do { } while (0)
 #endif /* CONFIG_TRACER_SNAPSHOT */
 
 void tracer_tracing_off(struct trace_array *tr)
@@ -1692,6 +1693,8 @@ static ssize_t trace_seq_to_buffer(struct trace_seq *s, void *buf, size_t cnt)
 }
 
 unsigned long __read_mostly	tracing_thresh;
+
+#ifdef CONFIG_TRACER_MAX_TRACE
 static const struct file_operations tracing_max_lat_fops;
 
 #ifdef LATENCY_FS_NOTIFY
@@ -1748,18 +1751,14 @@ void latency_fsnotify(struct trace_array *tr)
 	irq_work_queue(&tr->fsnotify_irqwork);
 }
 
-#elif defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER)	\
-	|| defined(CONFIG_OSNOISE_TRACER)
+#else /* !LATENCY_FS_NOTIFY */
 
 #define trace_create_maxlat_file(tr, d_tracer)				\
 	trace_create_file("tracing_max_latency", TRACE_MODE_WRITE,	\
 			  d_tracer, &tr->max_latency, &tracing_max_lat_fops)
 
-#else
-#define trace_create_maxlat_file(tr, d_tracer)	 do { } while (0)
 #endif
 
-#ifdef CONFIG_TRACER_MAX_TRACE
 /*
  * Copy the new maximum trace into the separate maximum-trace
  * structure. (this way the maximum trace is permanently saved,
@@ -1834,14 +1833,15 @@ update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu,
 		ring_buffer_record_off(tr->max_buffer.buffer);
 
 #ifdef CONFIG_TRACER_SNAPSHOT
-	if (tr->cond_snapshot && !tr->cond_snapshot->update(tr, cond_data))
-		goto out_unlock;
+	if (tr->cond_snapshot && !tr->cond_snapshot->update(tr, cond_data)) {
+		arch_spin_unlock(&tr->max_lock);
+		return;
+	}
 #endif
 	swap(tr->array_buffer.buffer, tr->max_buffer.buffer);
 
 	__update_max_tr(tr, tsk, cpu);
 
- out_unlock:
 	arch_spin_unlock(&tr->max_lock);
 }
 
@@ -1888,6 +1888,7 @@ update_max_tr_single(struct trace_array *tr, struct task_struct *tsk, int cpu)
 	__update_max_tr(tr, tsk, cpu);
 	arch_spin_unlock(&tr->max_lock);
 }
+
 #endif /* CONFIG_TRACER_MAX_TRACE */
 
 static int wait_on_pipe(struct trace_iterator *iter, int full)
@@ -6572,7 +6573,7 @@ tracing_thresh_write(struct file *filp, const char __user *ubuf,
 	return ret;
 }
 
-#if defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER)
+#ifdef CONFIG_TRACER_MAX_TRACE
 
 static ssize_t
 tracing_max_lat_read(struct file *filp, char __user *ubuf,
@@ -6796,7 +6797,20 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 
 		ret = print_trace_line(iter);
 		if (ret == TRACE_TYPE_PARTIAL_LINE) {
-			/* don't print partial lines */
+			/*
+			 * If one print_trace_line() fills entire trace_seq in one shot,
+			 * trace_seq_to_user() will returns -EBUSY because save_len == 0,
+			 * In this case, we need to consume it, otherwise, loop will peek
+			 * this event next time, resulting in an infinite loop.
+			 */
+			if (save_len == 0) {
+				iter->seq.full = 0;
+				trace_seq_puts(&iter->seq, "[LINE TOO BIG]\n");
+				trace_consume(iter);
+				break;
+			}
+
+			/* In other cases, don't print partial lines */
 			iter->seq.seq.len = save_len;
 			break;
 		}
@@ -7587,7 +7601,7 @@ static const struct file_operations tracing_thresh_fops = {
 	.llseek		= generic_file_llseek,
 };
 
-#if defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER)
+#ifdef CONFIG_TRACER_MAX_TRACE
 static const struct file_operations tracing_max_lat_fops = {
 	.open		= tracing_open_generic,
 	.read		= tracing_max_lat_read,
@@ -9601,7 +9615,9 @@ init_tracer_tracefs(struct trace_array *tr, struct dentry *d_tracer)
 
 	create_trace_options_dir(tr);
 
+#ifdef CONFIG_TRACER_MAX_TRACE
 	trace_create_maxlat_file(tr, d_tracer);
+#endif
 
 	if (ftrace_create_function_files(tr, d_tracer))
 		MEM_FAIL(1, "Could not allocate function filter files");
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index d42e24507152..5581754d9762 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -308,8 +308,7 @@ struct trace_array {
 	struct array_buffer	max_buffer;
 	bool			allocated_snapshot;
 #endif
-#if defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER) \
-	|| defined(CONFIG_OSNOISE_TRACER)
+#ifdef CONFIG_TRACER_MAX_TRACE
 	unsigned long		max_latency;
 #ifdef CONFIG_FSNOTIFY
 	struct dentry		*d_max_latency;
@@ -688,12 +687,11 @@ void update_max_tr(struct trace_array *tr, struct task_struct *tsk, int cpu,
 		   void *cond_data);
 void update_max_tr_single(struct trace_array *tr,
 			  struct task_struct *tsk, int cpu);
-#endif /* CONFIG_TRACER_MAX_TRACE */
 
-#if (defined(CONFIG_TRACER_MAX_TRACE) || defined(CONFIG_HWLAT_TRACER) \
-	|| defined(CONFIG_OSNOISE_TRACER)) && defined(CONFIG_FSNOTIFY)
+#ifdef CONFIG_FSNOTIFY
 #define LATENCY_FS_NOTIFY
 #endif
+#endif /* CONFIG_TRACER_MAX_TRACE */
 
 #ifdef LATENCY_FS_NOTIFY
 void latency_fsnotify(struct trace_array *tr);
@@ -1956,17 +1954,30 @@ static __always_inline void trace_iterator_reset(struct trace_iterator *iter)
 }
 
 /* Check the name is good for event/group/fields */
-static inline bool is_good_name(const char *name)
+static inline bool __is_good_name(const char *name, bool hash_ok)
 {
-	if (!isalpha(*name) && *name != '_')
+	if (!isalpha(*name) && *name != '_' && (!hash_ok || *name != '-'))
 		return false;
 	while (*++name != '\0') {
-		if (!isalpha(*name) && !isdigit(*name) && *name != '_')
+		if (!isalpha(*name) && !isdigit(*name) && *name != '_' &&
+		    (!hash_ok || *name != '-'))
 			return false;
 	}
 	return true;
 }
 
+/* Check the name is good for event/group/fields */
+static inline bool is_good_name(const char *name)
+{
+	return __is_good_name(name, false);
+}
+
+/* Check the name is good for system */
+static inline bool is_good_system_name(const char *name)
+{
+	return __is_good_name(name, true);
+}
+
 /* Convert certain expected symbols into '_' when generating event names */
 static inline void sanitize_event_name(char *name)
 {
diff --git a/kernel/trace/trace_eprobe.c b/kernel/trace/trace_eprobe.c
index 352b65e2b910..753fc536525d 100644
--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -564,6 +564,9 @@ static void eprobe_trigger_func(struct event_trigger_data *data,
 {
 	struct eprobe_data *edata = data->private_data;
 
+	if (unlikely(!rec))
+		return;
+
 	if (unlikely(!rec))
 		return;
 
diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index b6e5724a9ea3..c6e406995c11 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -617,7 +617,7 @@ struct action_data {
 	 * event param, and is passed to the synthetic event
 	 * invocation.
 	 */
-	unsigned int		var_ref_idx[TRACING_MAP_VARS_MAX];
+	unsigned int		var_ref_idx[SYNTH_FIELDS_MAX];
 	struct synth_event	*synth_event;
 	bool			use_trace_keyword;
 	char			*synth_event_name;
@@ -2173,7 +2173,9 @@ static struct hist_field *create_var_ref(struct hist_trigger_data *hist_data,
 			return ref_field;
 		}
 	}
-
+	/* Sanity check to avoid out-of-bound write on 'hist_data->var_refs' */
+	if (hist_data->n_var_refs >= TRACING_MAP_VARS_MAX)
+		return NULL;
 	ref_field = create_hist_field(var_field->hist_data, NULL, flags, NULL);
 	if (ref_field) {
 		if (init_var_ref(ref_field, var_field, system, event_name)) {
@@ -3586,6 +3588,7 @@ static int parse_action_params(struct trace_array *tr, char *params,
 	while (params) {
 		if (data->n_params >= SYNTH_FIELDS_MAX) {
 			hist_err(tr, HIST_ERR_TOO_MANY_PARAMS, 0);
+			ret = -EINVAL;
 			goto out;
 		}
 
@@ -3922,6 +3925,10 @@ static int trace_action_create(struct hist_trigger_data *hist_data,
 
 	lockdep_assert_held(&event_mutex);
 
+	/* Sanity check to avoid out-of-bound write on 'data->var_ref_idx' */
+	if (data->n_params > SYNTH_FIELDS_MAX)
+		return -EINVAL;
+
 	if (data->use_trace_keyword)
 		synth_event_name = data->synth_event_name;
 	else
diff --git a/kernel/trace/trace_events_synth.c b/kernel/trace/trace_events_synth.c
index c3b582d19b62..67592eed0be8 100644
--- a/kernel/trace/trace_events_synth.c
+++ b/kernel/trace/trace_events_synth.c
@@ -1282,12 +1282,12 @@ static int __create_synth_event(const char *name, const char *raw_fields)
 				goto err_free_arg;
 			}
 
-			fields[n_fields++] = field;
 			if (n_fields == SYNTH_FIELDS_MAX) {
 				synth_err(SYNTH_ERR_TOO_MANY_FIELDS, 0);
 				ret = -EINVAL;
 				goto err_free_arg;
 			}
+			fields[n_fields++] = field;
 
 			n_fields_this_loop++;
 		}
diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 36dff277de46..bb2f95d7175c 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -246,7 +246,7 @@ int traceprobe_parse_event_name(const char **pevent, const char **pgroup,
 			return -EINVAL;
 		}
 		strlcpy(buf, event, slash - event + 1);
-		if (!is_good_name(buf)) {
+		if (!is_good_system_name(buf)) {
 			trace_probe_log_err(offset, BAD_GROUP_NAME);
 			return -EINVAL;
 		}
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 3638b3424be5..12dfe6691dd5 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -2092,6 +2092,7 @@ config TEST_MIN_HEAP
 config TEST_SORT
 	tristate "Array-based sort test" if !KUNIT_ALL_TESTS
 	depends on KUNIT
+	select STACKTRACE if ARCH_CORRECT_STACKTRACE_ON_KRETPROBE
 	default KUNIT_ALL_TESTS
 	help
 	  This option enables the self-test function of 'sort()' at boot,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e36ca75311a5..9c251faeb6f5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -255,6 +255,152 @@ static inline struct hugepage_subpool *subpool_vma(struct vm_area_struct *vma)
 	return subpool_inode(file_inode(vma->vm_file));
 }
 
+/*
+ * hugetlb vma_lock helper routines
+ */
+static bool __vma_shareable_lock(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & (VM_MAYSHARE | VM_SHARED) &&
+		vma->vm_private_data;
+}
+
+void hugetlb_vma_lock_read(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		down_read(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_unlock_read(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		up_read(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_lock_write(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		down_write(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_unlock_write(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		up_write(&vma_lock->rw_sema);
+	}
+}
+
+int hugetlb_vma_trylock_write(struct vm_area_struct *vma)
+{
+	struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+	if (!__vma_shareable_lock(vma))
+		return 1;
+
+	return down_write_trylock(&vma_lock->rw_sema);
+}
+
+void hugetlb_vma_assert_locked(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		lockdep_assert_held(&vma_lock->rw_sema);
+	}
+}
+
+void hugetlb_vma_lock_release(struct kref *kref)
+{
+	struct hugetlb_vma_lock *vma_lock = container_of(kref,
+			struct hugetlb_vma_lock, refs);
+
+	kfree(vma_lock);
+}
+
+static void __hugetlb_vma_unlock_write_put(struct hugetlb_vma_lock *vma_lock)
+{
+	struct vm_area_struct *vma = vma_lock->vma;
+
+	/*
+	 * vma_lock structure may or not be released as a result of put,
+	 * it certainly will no longer be attached to vma so clear pointer.
+	 * Semaphore synchronizes access to vma_lock->vma field.
+	 */
+	vma_lock->vma = NULL;
+	vma->vm_private_data = NULL;
+	up_write(&vma_lock->rw_sema);
+	kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
+}
+
+static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma)
+{
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		__hugetlb_vma_unlock_write_put(vma_lock);
+	}
+}
+
+static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
+{
+	/*
+	 * Only present in sharable vmas.
+	 */
+	if (!vma || !__vma_shareable_lock(vma))
+		return;
+
+	if (vma->vm_private_data) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
+
+		down_write(&vma_lock->rw_sema);
+		__hugetlb_vma_unlock_write_put(vma_lock);
+	}
+}
+
+static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
+{
+	struct hugetlb_vma_lock *vma_lock;
+
+	/* Only establish in (flags) sharable vmas */
+	if (!vma || !(vma->vm_flags & VM_MAYSHARE))
+		return;
+
+	/* Should never get here with non-NULL vm_private_data */
+	if (vma->vm_private_data)
+		return;
+
+	vma_lock = kmalloc(sizeof(*vma_lock), GFP_KERNEL);
+	if (!vma_lock) {
+		/*
+		 * If we can not allocate structure, then vma can not
+		 * participate in pmd sharing.  This is only a possible
+		 * performance enhancement and memory saving issue.
+		 * However, the lock is also used to synchronize page
+		 * faults with truncation.  If the lock is not present,
+		 * unlikely races could leave pages in a file past i_size
+		 * until the file is removed.  Warn in the unlikely case of
+		 * allocation failure.
+		 */
+		pr_warn_once("HugeTLB: unable to allocate vma specific lock\n");
+		return;
+	}
+
+	kref_init(&vma_lock->refs);
+	init_rwsem(&vma_lock->rw_sema);
+	vma_lock->vma = vma;
+	vma->vm_private_data = vma_lock;
+}
+
 /* Helper that removes a struct file_region from the resv_map cache and returns
  * it for use.
  */
@@ -6557,7 +6703,8 @@ bool hugetlb_reserve_pages(struct inode *inode,
 	}
 
 	/*
-	 * vma specific semaphore used for pmd sharing synchronization
+	 * vma specific semaphore used for pmd sharing and fault/truncation
+	 * synchronization
 	 */
 	hugetlb_vma_lock_alloc(vma);
 
@@ -6813,149 +6960,6 @@ void adjust_range_if_pmd_sharing_possible(struct vm_area_struct *vma,
 		*end = ALIGN(*end, PUD_SIZE);
 }
 
-static bool __vma_shareable_flags_pmd(struct vm_area_struct *vma)
-{
-	return vma->vm_flags & (VM_MAYSHARE | VM_SHARED) &&
-		vma->vm_private_data;
-}
-
-void hugetlb_vma_lock_read(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		down_read(&vma_lock->rw_sema);
-	}
-}
-
-void hugetlb_vma_unlock_read(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		up_read(&vma_lock->rw_sema);
-	}
-}
-
-void hugetlb_vma_lock_write(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		down_write(&vma_lock->rw_sema);
-	}
-}
-
-void hugetlb_vma_unlock_write(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		up_write(&vma_lock->rw_sema);
-	}
-}
-
-int hugetlb_vma_trylock_write(struct vm_area_struct *vma)
-{
-	struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-	if (!__vma_shareable_flags_pmd(vma))
-		return 1;
-
-	return down_write_trylock(&vma_lock->rw_sema);
-}
-
-void hugetlb_vma_assert_locked(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		lockdep_assert_held(&vma_lock->rw_sema);
-	}
-}
-
-void hugetlb_vma_lock_release(struct kref *kref)
-{
-	struct hugetlb_vma_lock *vma_lock = container_of(kref,
-			struct hugetlb_vma_lock, refs);
-
-	kfree(vma_lock);
-}
-
-static void __hugetlb_vma_unlock_write_put(struct hugetlb_vma_lock *vma_lock)
-{
-	struct vm_area_struct *vma = vma_lock->vma;
-
-	/*
-	 * vma_lock structure may or not be released as a result of put,
-	 * it certainly will no longer be attached to vma so clear pointer.
-	 * Semaphore synchronizes access to vma_lock->vma field.
-	 */
-	vma_lock->vma = NULL;
-	vma->vm_private_data = NULL;
-	up_write(&vma_lock->rw_sema);
-	kref_put(&vma_lock->refs, hugetlb_vma_lock_release);
-}
-
-static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma)
-{
-	if (__vma_shareable_flags_pmd(vma)) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		__hugetlb_vma_unlock_write_put(vma_lock);
-	}
-}
-
-static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
-{
-	/*
-	 * Only present in sharable vmas.
-	 */
-	if (!vma || !__vma_shareable_flags_pmd(vma))
-		return;
-
-	if (vma->vm_private_data) {
-		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
-
-		down_write(&vma_lock->rw_sema);
-		__hugetlb_vma_unlock_write_put(vma_lock);
-	}
-}
-
-static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
-{
-	struct hugetlb_vma_lock *vma_lock;
-
-	/* Only establish in (flags) sharable vmas */
-	if (!vma || !(vma->vm_flags & VM_MAYSHARE))
-		return;
-
-	/* Should never get here with non-NULL vm_private_data */
-	if (vma->vm_private_data)
-		return;
-
-	vma_lock = kmalloc(sizeof(*vma_lock), GFP_KERNEL);
-	if (!vma_lock) {
-		/*
-		 * If we can not allocate structure, then vma can not
-		 * participate in pmd sharing.  This is only a possible
-		 * performance enhancement and memory saving issue.
-		 * However, the lock is also used to synchronize page
-		 * faults with truncation.  If the lock is not present,
-		 * unlikely races could leave pages in a file past i_size
-		 * until the file is removed.  Warn in the unlikely case of
-		 * allocation failure.
-		 */
-		pr_warn_once("HugeTLB: unable to allocate vma specific lock\n");
-		return;
-	}
-
-	kref_init(&vma_lock->refs);
-	init_rwsem(&vma_lock->rw_sema);
-	vma_lock->vma = vma;
-	vma->vm_private_data = vma_lock;
-}
-
 /*
  * Search for a shareable pmd page for hugetlb. In any case calls pmd_alloc()
  * and returns the corresponding pte. While this is not necessary for the
@@ -7044,47 +7048,6 @@ int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
 
 #else /* !CONFIG_ARCH_WANT_HUGE_PMD_SHARE */
 
-void hugetlb_vma_lock_read(struct vm_area_struct *vma)
-{
-}
-
-void hugetlb_vma_unlock_read(struct vm_area_struct *vma)
-{
-}
-
-void hugetlb_vma_lock_write(struct vm_area_struct *vma)
-{
-}
-
-void hugetlb_vma_unlock_write(struct vm_area_struct *vma)
-{
-}
-
-int hugetlb_vma_trylock_write(struct vm_area_struct *vma)
-{
-	return 1;
-}
-
-void hugetlb_vma_assert_locked(struct vm_area_struct *vma)
-{
-}
-
-void hugetlb_vma_lock_release(struct kref *kref)
-{
-}
-
-static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma)
-{
-}
-
-static void hugetlb_vma_lock_free(struct vm_area_struct *vma)
-{
-}
-
-static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma)
-{
-}
-
 pte_t *huge_pmd_share(struct mm_struct *mm, struct vm_area_struct *vma,
 		      unsigned long addr, pud_t *pud)
 {
diff --git a/net/ipv4/syncookies.c b/net/ipv4/syncookies.c
index 942d2dfa1115..26fb97d1d4d9 100644
--- a/net/ipv4/syncookies.c
+++ b/net/ipv4/syncookies.c
@@ -288,12 +288,11 @@ struct request_sock *cookie_tcp_reqsk_alloc(const struct request_sock_ops *ops,
 	struct tcp_request_sock *treq;
 	struct request_sock *req;
 
-#ifdef CONFIG_MPTCP
 	if (sk_is_mptcp(sk))
-		ops = &mptcp_subflow_request_sock_ops;
-#endif
+		req = mptcp_subflow_reqsk_alloc(ops, sk, false);
+	else
+		req = inet_reqsk_alloc(ops, sk, false);
 
-	req = inet_reqsk_alloc(ops, sk, false);
 	if (!req)
 		return NULL;
 
diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 9e82250cbb70..0430415357ba 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -156,6 +156,7 @@ int mptcp_nl_cmd_announce(struct sk_buff *skb, struct genl_info *info)
 
 	if (addr_val.addr.id == 0 || !(addr_val.flags & MPTCP_PM_ADDR_FLAG_SIGNAL)) {
 		GENL_SET_ERR_MSG(info, "invalid addr id or flags");
+		err = -EINVAL;
 		goto announce_err;
 	}
 
@@ -282,6 +283,7 @@ int mptcp_nl_cmd_sf_create(struct sk_buff *skb, struct genl_info *info)
 
 	if (addr_l.id == 0) {
 		NL_SET_ERR_MSG_ATTR(info->extack, laddr, "missing local addr id");
+		err = -EINVAL;
 		goto create_err;
 	}
 
@@ -395,11 +397,13 @@ int mptcp_nl_cmd_sf_destroy(struct sk_buff *skb, struct genl_info *info)
 
 	if (addr_l.family != addr_r.family) {
 		GENL_SET_ERR_MSG(info, "address families do not match");
+		err = -EINVAL;
 		goto destroy_err;
 	}
 
 	if (!addr_l.port || !addr_r.port) {
 		GENL_SET_ERR_MSG(info, "missing local or remote port");
+		err = -EINVAL;
 		goto destroy_err;
 	}
 
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 2159b5f9988f..613f515fedf0 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -45,7 +45,6 @@ static void subflow_req_destructor(struct request_sock *req)
 		sock_put((struct sock *)subflow_req->msk);
 
 	mptcp_token_destroy_request(req);
-	tcp_request_sock_ops.destructor(req);
 }
 
 static void subflow_generate_hmac(u64 key1, u64 key2, u32 nonce1, u32 nonce2,
@@ -529,7 +528,7 @@ static int subflow_v6_rebuild_header(struct sock *sk)
 }
 #endif
 
-struct request_sock_ops mptcp_subflow_request_sock_ops;
+static struct request_sock_ops mptcp_subflow_v4_request_sock_ops __ro_after_init;
 static struct tcp_request_sock_ops subflow_request_sock_ipv4_ops __ro_after_init;
 
 static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
@@ -542,7 +541,7 @@ static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 	if (skb_rtable(skb)->rt_flags & (RTCF_BROADCAST | RTCF_MULTICAST))
 		goto drop;
 
-	return tcp_conn_request(&mptcp_subflow_request_sock_ops,
+	return tcp_conn_request(&mptcp_subflow_v4_request_sock_ops,
 				&subflow_request_sock_ipv4_ops,
 				sk, skb);
 drop:
@@ -550,7 +549,14 @@ static int subflow_v4_conn_request(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
+static void subflow_v4_req_destructor(struct request_sock *req)
+{
+	subflow_req_destructor(req);
+	tcp_request_sock_ops.destructor(req);
+}
+
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
+static struct request_sock_ops mptcp_subflow_v6_request_sock_ops __ro_after_init;
 static struct tcp_request_sock_ops subflow_request_sock_ipv6_ops __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6_specific __ro_after_init;
 static struct inet_connection_sock_af_ops subflow_v6m_specific __ro_after_init;
@@ -573,15 +579,36 @@ static int subflow_v6_conn_request(struct sock *sk, struct sk_buff *skb)
 		return 0;
 	}
 
-	return tcp_conn_request(&mptcp_subflow_request_sock_ops,
+	return tcp_conn_request(&mptcp_subflow_v6_request_sock_ops,
 				&subflow_request_sock_ipv6_ops, sk, skb);
 
 drop:
 	tcp_listendrop(sk);
 	return 0; /* don't send reset */
 }
+
+static void subflow_v6_req_destructor(struct request_sock *req)
+{
+	subflow_req_destructor(req);
+	tcp6_request_sock_ops.destructor(req);
+}
+#endif
+
+struct request_sock *mptcp_subflow_reqsk_alloc(const struct request_sock_ops *ops,
+					       struct sock *sk_listener,
+					       bool attach_listener)
+{
+	if (ops->family == AF_INET)
+		ops = &mptcp_subflow_v4_request_sock_ops;
+#if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	else if (ops->family == AF_INET6)
+		ops = &mptcp_subflow_v6_request_sock_ops;
 #endif
 
+	return inet_reqsk_alloc(ops, sk_listener, attach_listener);
+}
+EXPORT_SYMBOL(mptcp_subflow_reqsk_alloc);
+
 /* validate hmac received in third ACK */
 static bool subflow_hmac_valid(const struct request_sock *req,
 			       const struct mptcp_options_received *mp_opt)
@@ -1904,7 +1931,6 @@ static struct tcp_ulp_ops subflow_ulp_ops __read_mostly = {
 static int subflow_ops_init(struct request_sock_ops *subflow_ops)
 {
 	subflow_ops->obj_size = sizeof(struct mptcp_subflow_request_sock);
-	subflow_ops->slab_name = "request_sock_subflow";
 
 	subflow_ops->slab = kmem_cache_create(subflow_ops->slab_name,
 					      subflow_ops->obj_size, 0,
@@ -1914,16 +1940,17 @@ static int subflow_ops_init(struct request_sock_ops *subflow_ops)
 	if (!subflow_ops->slab)
 		return -ENOMEM;
 
-	subflow_ops->destructor = subflow_req_destructor;
-
 	return 0;
 }
 
 void __init mptcp_subflow_init(void)
 {
-	mptcp_subflow_request_sock_ops = tcp_request_sock_ops;
-	if (subflow_ops_init(&mptcp_subflow_request_sock_ops) != 0)
-		panic("MPTCP: failed to init subflow request sock ops\n");
+	mptcp_subflow_v4_request_sock_ops = tcp_request_sock_ops;
+	mptcp_subflow_v4_request_sock_ops.slab_name = "request_sock_subflow_v4";
+	mptcp_subflow_v4_request_sock_ops.destructor = subflow_v4_req_destructor;
+
+	if (subflow_ops_init(&mptcp_subflow_v4_request_sock_ops) != 0)
+		panic("MPTCP: failed to init subflow v4 request sock ops\n");
 
 	subflow_request_sock_ipv4_ops = tcp_request_sock_ipv4_ops;
 	subflow_request_sock_ipv4_ops.route_req = subflow_v4_route_req;
@@ -1938,6 +1965,20 @@ void __init mptcp_subflow_init(void)
 	tcp_prot_override.release_cb = tcp_release_cb_override;
 
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
+	/* In struct mptcp_subflow_request_sock, we assume the TCP request sock
+	 * structures for v4 and v6 have the same size. It should not changed in
+	 * the future but better to make sure to be warned if it is no longer
+	 * the case.
+	 */
+	BUILD_BUG_ON(sizeof(struct tcp_request_sock) != sizeof(struct tcp6_request_sock));
+
+	mptcp_subflow_v6_request_sock_ops = tcp6_request_sock_ops;
+	mptcp_subflow_v6_request_sock_ops.slab_name = "request_sock_subflow_v6";
+	mptcp_subflow_v6_request_sock_ops.destructor = subflow_v6_req_destructor;
+
+	if (subflow_ops_init(&mptcp_subflow_v6_request_sock_ops) != 0)
+		panic("MPTCP: failed to init subflow v6 request sock ops\n");
+
 	subflow_request_sock_ipv6_ops = tcp_request_sock_ipv6_ops;
 	subflow_request_sock_ipv6_ops.route_req = subflow_v6_route_req;
 
diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index a9f8c63a96d1..bef2b9285fb3 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -82,6 +82,17 @@ static int dev_exceptions_copy(struct list_head *dest, struct list_head *orig)
 	return -ENOMEM;
 }
 
+static void dev_exceptions_move(struct list_head *dest, struct list_head *orig)
+{
+	struct dev_exception_item *ex, *tmp;
+
+	lockdep_assert_held(&devcgroup_mutex);
+
+	list_for_each_entry_safe(ex, tmp, orig, list) {
+		list_move_tail(&ex->list, dest);
+	}
+}
+
 /*
  * called under devcgroup_mutex
  */
@@ -604,11 +615,13 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 	int count, rc = 0;
 	struct dev_exception_item ex;
 	struct dev_cgroup *parent = css_to_devcgroup(devcgroup->css.parent);
+	struct dev_cgroup tmp_devcgrp;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	memset(&ex, 0, sizeof(ex));
+	memset(&tmp_devcgrp, 0, sizeof(tmp_devcgrp));
 	b = buffer;
 
 	switch (*b) {
@@ -620,15 +633,27 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
 
 			if (!may_allow_all(parent))
 				return -EPERM;
-			dev_exception_clean(devcgroup);
-			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
-			if (!parent)
+			if (!parent) {
+				devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
+				dev_exception_clean(devcgroup);
 				break;
+			}
 
+			INIT_LIST_HEAD(&tmp_devcgrp.exceptions);
+			rc = dev_exceptions_copy(&tmp_devcgrp.exceptions,
+						 &devcgroup->exceptions);
+			if (rc)
+				return rc;
+			dev_exception_clean(devcgroup);
 			rc = dev_exceptions_copy(&devcgroup->exceptions,
 						 &parent->exceptions);
-			if (rc)
+			if (rc) {
+				dev_exceptions_move(&devcgroup->exceptions,
+						    &tmp_devcgrp.exceptions);
 				return rc;
+			}
+			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
+			dev_exception_clean(&tmp_devcgrp);
 			break;
 		case DEVCG_DENY:
 			if (css_has_online_children(&devcgroup->css))
diff --git a/security/integrity/ima/Kconfig b/security/integrity/ima/Kconfig
index 7249f16257c7..39caeca47444 100644
--- a/security/integrity/ima/Kconfig
+++ b/security/integrity/ima/Kconfig
@@ -112,7 +112,7 @@ choice
 
 	config IMA_DEFAULT_HASH_SM3
 		bool "SM3"
-		depends on CRYPTO_SM3=y
+		depends on CRYPTO_SM3_GENERIC=y
 endchoice
 
 config IMA_DEFAULT_HASH
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 040b03ddc1c7..4a207a3ef7ef 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -542,8 +542,13 @@ static int __ima_inode_hash(struct inode *inode, struct file *file, char *buf,
 
 		rc = ima_collect_measurement(&tmp_iint, file, NULL, 0,
 					     ima_hash_algo, NULL);
-		if (rc < 0)
+		if (rc < 0) {
+			/* ima_hash could be allocated in case of failure. */
+			if (rc != -ENOMEM)
+				kfree(tmp_iint.ima_hash);
+
 			return -EOPNOTSUPP;
+		}
 
 		iint = &tmp_iint;
 		mutex_lock(&iint->mutex);
diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index 195ac18f0927..04c49f05cb74 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -340,8 +340,11 @@ static struct ima_template_desc *restore_template_fmt(char *template_name)
 
 	template_desc->name = "";
 	template_desc->fmt = kstrdup(template_name, GFP_KERNEL);
-	if (!template_desc->fmt)
+	if (!template_desc->fmt) {
+		kfree(template_desc);
+		template_desc = NULL;
 		goto out;
+	}
 
 	spin_lock(&template_list);
 	list_add_tail_rcu(&template_desc->list, &defined_templates);
diff --git a/security/integrity/platform_certs/load_uefi.c b/security/integrity/platform_certs/load_uefi.c
index b78753d27d8e..d1fdd113450a 100644
--- a/security/integrity/platform_certs/load_uefi.c
+++ b/security/integrity/platform_certs/load_uefi.c
@@ -35,6 +35,7 @@ static const struct dmi_system_id uefi_skip_cert[] = {
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "MacPro7,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,1") },
 	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMac20,2") },
+	{ UEFI_QUIRK_SKIP_CERT("Apple Inc.", "iMacPro1,1") },
 	{ }
 };
 
diff --git a/sound/pci/hda/patch_cs8409.c b/sound/pci/hda/patch_cs8409.c
index 754aa8ddd2e4..0ba1fbcbb21e 100644
--- a/sound/pci/hda/patch_cs8409.c
+++ b/sound/pci/hda/patch_cs8409.c
@@ -888,7 +888,7 @@ static void cs42l42_resume(struct sub_codec *cs42l42)
 
 	/* Initialize CS42L42 companion codec */
 	cs8409_i2c_bulk_write(cs42l42, cs42l42->init_seq, cs42l42->init_seq_num);
-	usleep_range(20000, 25000);
+	usleep_range(30000, 35000);
 
 	/* Clear interrupts, by reading interrupt status registers */
 	cs8409_i2c_bulk_read(cs42l42, irq_regs, ARRAY_SIZE(irq_regs));
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f5f640851fdc..3794b522c222 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -6903,6 +6903,34 @@ static void alc287_fixup_yoga9_14iap7_bass_spk_pin(struct hda_codec *codec,
 	}
 }
 
+static void alc295_fixup_dell_inspiron_top_speakers(struct hda_codec *codec,
+					  const struct hda_fixup *fix, int action)
+{
+	static const struct hda_pintbl pincfgs[] = {
+		{ 0x14, 0x90170151 },
+		{ 0x17, 0x90170150 },
+		{ }
+	};
+	static const hda_nid_t conn[] = { 0x02, 0x03 };
+	static const hda_nid_t preferred_pairs[] = {
+		0x14, 0x02,
+		0x17, 0x03,
+		0x21, 0x02,
+		0
+	};
+	struct alc_spec *spec = codec->spec;
+
+	alc_fixup_no_shutup(codec, fix, action);
+
+	switch (action) {
+	case HDA_FIXUP_ACT_PRE_PROBE:
+		snd_hda_apply_pincfgs(codec, pincfgs);
+		snd_hda_override_conn_list(codec, 0x17, ARRAY_SIZE(conn), conn);
+		spec->gen.preferred_dacs = preferred_pairs;
+		break;
+	}
+}
+
 enum {
 	ALC269_FIXUP_GPIO2,
 	ALC269_FIXUP_SONY_VAIO,
@@ -7146,6 +7174,8 @@ enum {
 	ALC287_FIXUP_LEGION_16ITHG6,
 	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK,
 	ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN,
+	ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS,
+	ALC236_FIXUP_DELL_DUAL_CODECS,
 };
 
 /* A special fixup for Lenovo C940 and Yoga Duet 7;
@@ -9095,6 +9125,18 @@ static const struct hda_fixup alc269_fixups[] = {
 		.chained = true,
 		.chain_id = ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK,
 	},
+	[ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS] = {
+		.type = HDA_FIXUP_FUNC,
+		.v.func = alc295_fixup_dell_inspiron_top_speakers,
+		.chained = true,
+		.chain_id = ALC269_FIXUP_DELL4_MIC_NO_PRESENCE,
+	},
+	[ALC236_FIXUP_DELL_DUAL_CODECS] = {
+		.type = HDA_FIXUP_PINS,
+		.v.func = alc1220_fixup_gb_dual_codecs,
+		.chained = true,
+		.chain_id = ALC255_FIXUP_DELL1_MIC_NO_PRESENCE,
+	},
 };
 
 static const struct snd_pci_quirk alc269_fixup_tbl[] = {
@@ -9195,6 +9237,14 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0a9e, "Dell Latitude 5430", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x0b19, "Dell XPS 15 9520", ALC289_FIXUP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0b1a, "Dell Precision 5570", ALC289_FIXUP_DUAL_SPK),
+	SND_PCI_QUIRK(0x1028, 0x0b37, "Dell Inspiron 16 Plus 7620 2-in-1", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
+	SND_PCI_QUIRK(0x1028, 0x0b71, "Dell Inspiron 16 Plus 7620", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
+	SND_PCI_QUIRK(0x1028, 0x0c19, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c1a, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c1b, "Dell Precision 3440", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c1c, "Dell Precision 3540", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c1d, "Dell Precision 3440", ALC236_FIXUP_DELL_DUAL_CODECS),
+	SND_PCI_QUIRK(0x1028, 0x0c1e, "Dell Precision 3540", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x164a, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x164b, "Dell", ALC293_FIXUP_DELL1_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1586, "HP", ALC269_FIXUP_HP_MUTE_LED_MIC2),
diff --git a/sound/soc/jz4740/jz4740-i2s.c b/sound/soc/jz4740/jz4740-i2s.c
index c4c1e89b47c1..83cb81999c6f 100644
--- a/sound/soc/jz4740/jz4740-i2s.c
+++ b/sound/soc/jz4740/jz4740-i2s.c
@@ -55,7 +55,8 @@
 #define JZ_AIC_CTRL_MONO_TO_STEREO BIT(11)
 #define JZ_AIC_CTRL_SWITCH_ENDIANNESS BIT(10)
 #define JZ_AIC_CTRL_SIGNED_TO_UNSIGNED BIT(9)
-#define JZ_AIC_CTRL_FLUSH		BIT(8)
+#define JZ_AIC_CTRL_TFLUSH		BIT(8)
+#define JZ_AIC_CTRL_RFLUSH		BIT(7)
 #define JZ_AIC_CTRL_ENABLE_ROR_INT BIT(6)
 #define JZ_AIC_CTRL_ENABLE_TUR_INT BIT(5)
 #define JZ_AIC_CTRL_ENABLE_RFS_INT BIT(4)
@@ -90,6 +91,8 @@ enum jz47xx_i2s_version {
 struct i2s_soc_info {
 	enum jz47xx_i2s_version version;
 	struct snd_soc_dai_driver *dai;
+
+	bool shared_fifo_flush;
 };
 
 struct jz4740_i2s {
@@ -116,19 +119,44 @@ static inline void jz4740_i2s_write(const struct jz4740_i2s *i2s,
 	writel(value, i2s->base + reg);
 }
 
+static inline void jz4740_i2s_set_bits(const struct jz4740_i2s *i2s,
+	unsigned int reg, uint32_t bits)
+{
+	uint32_t value = jz4740_i2s_read(i2s, reg);
+	value |= bits;
+	jz4740_i2s_write(i2s, reg, value);
+}
+
 static int jz4740_i2s_startup(struct snd_pcm_substream *substream,
 	struct snd_soc_dai *dai)
 {
 	struct jz4740_i2s *i2s = snd_soc_dai_get_drvdata(dai);
-	uint32_t conf, ctrl;
+	uint32_t conf;
 	int ret;
 
+	/*
+	 * When we can flush FIFOs independently, only flush the FIFO
+	 * that is starting up. We can do this when the DAI is active
+	 * because it does not disturb other active substreams.
+	 */
+	if (!i2s->soc_info->shared_fifo_flush) {
+		if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK)
+			jz4740_i2s_set_bits(i2s, JZ_REG_AIC_CTRL, JZ_AIC_CTRL_TFLUSH);
+		else
+			jz4740_i2s_set_bits(i2s, JZ_REG_AIC_CTRL, JZ_AIC_CTRL_RFLUSH);
+	}
+
 	if (snd_soc_dai_active(dai))
 		return 0;
 
-	ctrl = jz4740_i2s_read(i2s, JZ_REG_AIC_CTRL);
-	ctrl |= JZ_AIC_CTRL_FLUSH;
-	jz4740_i2s_write(i2s, JZ_REG_AIC_CTRL, ctrl);
+	/*
+	 * When there is a shared flush bit for both FIFOs, the TFLUSH
+	 * bit flushes both FIFOs. Flushing while the DAI is active would
+	 * cause FIFO underruns in other active substreams so we have to
+	 * guard this behind the snd_soc_dai_active() check.
+	 */
+	if (i2s->soc_info->shared_fifo_flush)
+		jz4740_i2s_set_bits(i2s, JZ_REG_AIC_CTRL, JZ_AIC_CTRL_TFLUSH);
 
 	ret = clk_prepare_enable(i2s->clk_i2s);
 	if (ret)
@@ -443,6 +471,7 @@ static struct snd_soc_dai_driver jz4740_i2s_dai = {
 static const struct i2s_soc_info jz4740_i2s_soc_info = {
 	.version = JZ_I2S_JZ4740,
 	.dai = &jz4740_i2s_dai,
+	.shared_fifo_flush = true,
 };
 
 static const struct i2s_soc_info jz4760_i2s_soc_info = {
diff --git a/sound/usb/card.h b/sound/usb/card.h
index 40061550105a..6ec95b2edf86 100644
--- a/sound/usb/card.h
+++ b/sound/usb/card.h
@@ -131,6 +131,7 @@ struct snd_usb_endpoint {
 	bool lowlatency_playback;	/* low-latency playback mode */
 	bool need_setup;		/* (re-)need for hw_params? */
 	bool need_prepare;		/* (re-)need for prepare? */
+	bool fixed_rate;		/* skip rate setup */
 
 	/* for hw constraints */
 	const struct audioformat *cur_audiofmt;
diff --git a/sound/usb/endpoint.c b/sound/usb/endpoint.c
index 4aaf0784940b..419302e2057e 100644
--- a/sound/usb/endpoint.c
+++ b/sound/usb/endpoint.c
@@ -769,7 +769,8 @@ struct snd_usb_endpoint *
 snd_usb_endpoint_open(struct snd_usb_audio *chip,
 		      const struct audioformat *fp,
 		      const struct snd_pcm_hw_params *params,
-		      bool is_sync_ep)
+		      bool is_sync_ep,
+		      bool fixed_rate)
 {
 	struct snd_usb_endpoint *ep;
 	int ep_num = is_sync_ep ? fp->sync_ep : fp->endpoint;
@@ -825,6 +826,7 @@ snd_usb_endpoint_open(struct snd_usb_audio *chip,
 		ep->implicit_fb_sync = fp->implicit_fb;
 		ep->need_setup = true;
 		ep->need_prepare = true;
+		ep->fixed_rate = fixed_rate;
 
 		usb_audio_dbg(chip, "  channels=%d, rate=%d, format=%s, period_bytes=%d, periods=%d, implicit_fb=%d\n",
 			      ep->cur_channels, ep->cur_rate,
@@ -1413,11 +1415,13 @@ static int init_sample_rate(struct snd_usb_audio *chip,
 	if (clock && !clock->need_setup)
 		return 0;
 
-	err = snd_usb_init_sample_rate(chip, ep->cur_audiofmt, rate);
-	if (err < 0) {
-		if (clock)
-			clock->rate = 0; /* reset rate */
-		return err;
+	if (!ep->fixed_rate) {
+		err = snd_usb_init_sample_rate(chip, ep->cur_audiofmt, rate);
+		if (err < 0) {
+			if (clock)
+				clock->rate = 0; /* reset rate */
+			return err;
+		}
 	}
 
 	if (clock)
diff --git a/sound/usb/endpoint.h b/sound/usb/endpoint.h
index e67ea28faa54..924f4351588c 100644
--- a/sound/usb/endpoint.h
+++ b/sound/usb/endpoint.h
@@ -14,7 +14,8 @@ struct snd_usb_endpoint *
 snd_usb_endpoint_open(struct snd_usb_audio *chip,
 		      const struct audioformat *fp,
 		      const struct snd_pcm_hw_params *params,
-		      bool is_sync_ep);
+		      bool is_sync_ep,
+		      bool fixed_rate);
 void snd_usb_endpoint_close(struct snd_usb_audio *chip,
 			    struct snd_usb_endpoint *ep);
 int snd_usb_endpoint_set_params(struct snd_usb_audio *chip,
diff --git a/sound/usb/implicit.c b/sound/usb/implicit.c
index f3e8484b3d9c..41ac7185b42b 100644
--- a/sound/usb/implicit.c
+++ b/sound/usb/implicit.c
@@ -15,6 +15,7 @@
 #include "usbaudio.h"
 #include "card.h"
 #include "helper.h"
+#include "pcm.h"
 #include "implicit.h"
 
 enum {
@@ -455,7 +456,8 @@ const struct audioformat *
 snd_usb_find_implicit_fb_sync_format(struct snd_usb_audio *chip,
 				     const struct audioformat *target,
 				     const struct snd_pcm_hw_params *params,
-				     int stream)
+				     int stream,
+				     bool *fixed_rate)
 {
 	struct snd_usb_substream *subs;
 	const struct audioformat *fp, *sync_fmt = NULL;
@@ -483,6 +485,8 @@ snd_usb_find_implicit_fb_sync_format(struct snd_usb_audio *chip,
 		}
 	}
 
+	if (fixed_rate)
+		*fixed_rate = snd_usb_pcm_has_fixed_rate(subs);
 	return sync_fmt;
 }
 
diff --git a/sound/usb/implicit.h b/sound/usb/implicit.h
index ccb415a0ea86..7f1577b6c4d3 100644
--- a/sound/usb/implicit.h
+++ b/sound/usb/implicit.h
@@ -9,6 +9,6 @@ const struct audioformat *
 snd_usb_find_implicit_fb_sync_format(struct snd_usb_audio *chip,
 				     const struct audioformat *target,
 				     const struct snd_pcm_hw_params *params,
-				     int stream);
+				     int stream, bool *fixed_rate);
 
 #endif /* __USBAUDIO_IMPLICIT_H */
diff --git a/sound/usb/pcm.c b/sound/usb/pcm.c
index 9557bd4d1bbc..99a66d0ef5b2 100644
--- a/sound/usb/pcm.c
+++ b/sound/usb/pcm.c
@@ -157,6 +157,31 @@ find_substream_format(struct snd_usb_substream *subs,
 			   true, subs);
 }
 
+bool snd_usb_pcm_has_fixed_rate(struct snd_usb_substream *subs)
+{
+	const struct audioformat *fp;
+	struct snd_usb_audio *chip = subs->stream->chip;
+	int rate = -1;
+
+	if (!(chip->quirk_flags & QUIRK_FLAG_FIXED_RATE))
+		return false;
+	list_for_each_entry(fp, &subs->fmt_list, list) {
+		if (fp->rates & SNDRV_PCM_RATE_CONTINUOUS)
+			return false;
+		if (fp->nr_rates < 1)
+			continue;
+		if (fp->nr_rates > 1)
+			return false;
+		if (rate < 0) {
+			rate = fp->rate_table[0];
+			continue;
+		}
+		if (rate != fp->rate_table[0])
+			return false;
+	}
+	return true;
+}
+
 static int init_pitch_v1(struct snd_usb_audio *chip, int ep)
 {
 	struct usb_device *dev = chip->dev;
@@ -450,12 +475,14 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 	struct snd_usb_audio *chip = subs->stream->chip;
 	const struct audioformat *fmt;
 	const struct audioformat *sync_fmt;
+	bool fixed_rate, sync_fixed_rate;
 	int ret;
 
 	ret = snd_media_start_pipeline(subs);
 	if (ret)
 		return ret;
 
+	fixed_rate = snd_usb_pcm_has_fixed_rate(subs);
 	fmt = find_substream_format(subs, hw_params);
 	if (!fmt) {
 		usb_audio_dbg(chip,
@@ -469,7 +496,8 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 	if (fmt->implicit_fb) {
 		sync_fmt = snd_usb_find_implicit_fb_sync_format(chip, fmt,
 								hw_params,
-								!substream->stream);
+								!substream->stream,
+								&sync_fixed_rate);
 		if (!sync_fmt) {
 			usb_audio_dbg(chip,
 				      "cannot find sync format: ep=0x%x, iface=%d:%d, format=%s, rate=%d, channels=%d\n",
@@ -482,6 +510,7 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 		}
 	} else {
 		sync_fmt = fmt;
+		sync_fixed_rate = fixed_rate;
 	}
 
 	ret = snd_usb_lock_shutdown(chip);
@@ -499,7 +528,7 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 		close_endpoints(chip, subs);
 	}
 
-	subs->data_endpoint = snd_usb_endpoint_open(chip, fmt, hw_params, false);
+	subs->data_endpoint = snd_usb_endpoint_open(chip, fmt, hw_params, false, fixed_rate);
 	if (!subs->data_endpoint) {
 		ret = -EINVAL;
 		goto unlock;
@@ -508,7 +537,8 @@ static int snd_usb_hw_params(struct snd_pcm_substream *substream,
 	if (fmt->sync_ep) {
 		subs->sync_endpoint = snd_usb_endpoint_open(chip, sync_fmt,
 							    hw_params,
-							    fmt == sync_fmt);
+							    fmt == sync_fmt,
+							    sync_fixed_rate);
 		if (!subs->sync_endpoint) {
 			ret = -EINVAL;
 			goto unlock;
diff --git a/sound/usb/pcm.h b/sound/usb/pcm.h
index 493a4e34d78d..388fe2ba346d 100644
--- a/sound/usb/pcm.h
+++ b/sound/usb/pcm.h
@@ -6,6 +6,8 @@ void snd_usb_set_pcm_ops(struct snd_pcm *pcm, int stream);
 int snd_usb_pcm_suspend(struct snd_usb_stream *as);
 int snd_usb_pcm_resume(struct snd_usb_stream *as);
 
+bool snd_usb_pcm_has_fixed_rate(struct snd_usb_substream *as);
+
 int snd_usb_init_pitch(struct snd_usb_audio *chip,
 		       const struct audioformat *fmt);
 void snd_usb_preallocate_buffer(struct snd_usb_substream *subs);
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 58b37bfc885c..3d13fdf7590c 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2152,6 +2152,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x0525, 0xa4ad, /* Hamedal C20 usb camero */
 		   QUIRK_FLAG_IFACE_SKIP_CLOSE),
+	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */
+		   QUIRK_FLAG_FIXED_RATE),
 
 	/* Vendor matches */
 	VENDOR_FLG(0x045e, /* MS Lifecam */
diff --git a/sound/usb/usbaudio.h b/sound/usb/usbaudio.h
index 2aba508a4831..f5a8dca66457 100644
--- a/sound/usb/usbaudio.h
+++ b/sound/usb/usbaudio.h
@@ -175,6 +175,9 @@ extern bool snd_usb_skip_validation;
  * QUIRK_FLAG_FORCE_IFACE_RESET
  *  Force an interface reset whenever stopping & restarting a stream
  *  (e.g. after xrun)
+ * QUIRK_FLAG_FIXED_RATE
+ *  Do not set PCM rate (frequency) when only one rate is available
+ *  for the given endpoint.
  */
 
 #define QUIRK_FLAG_GET_SAMPLE_RATE	(1U << 0)
@@ -198,5 +201,6 @@ extern bool snd_usb_skip_validation;
 #define QUIRK_FLAG_SKIP_IMPLICIT_FB	(1U << 18)
 #define QUIRK_FLAG_IFACE_SKIP_CLOSE	(1U << 19)
 #define QUIRK_FLAG_FORCE_IFACE_RESET	(1U << 20)
+#define QUIRK_FLAG_FIXED_RATE		(1U << 21)
 
 #endif /* __USBAUDIO_H */
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 09d1578f9d66..1737c59e4ff6 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1963,7 +1963,7 @@ sub run_scp_mod {
 
 sub _get_grub_index {
 
-    my ($command, $target, $skip) = @_;
+    my ($command, $target, $skip, $submenu) = @_;
 
     return if (defined($grub_number) && defined($last_grub_menu) &&
 	$last_grub_menu eq $grub_menu && defined($last_machine) &&
@@ -1980,11 +1980,16 @@ sub _get_grub_index {
 
     my $found = 0;
 
+    my $submenu_number = 0;
+
     while (<IN>) {
 	if (/$target/) {
 	    $grub_number++;
 	    $found = 1;
 	    last;
+	} elsif (defined($submenu) && /$submenu/) {
+		$submenu_number++;
+		$grub_number = -1;
 	} elsif (/$skip/) {
 	    $grub_number++;
 	}
@@ -1993,6 +1998,9 @@ sub _get_grub_index {
 
     dodie "Could not find '$grub_menu' through $command on $machine"
 	if (!$found);
+    if ($submenu_number > 0) {
+	$grub_number = "$submenu_number>$grub_number";
+    }
     doprint "$grub_number\n";
     $last_grub_menu = $grub_menu;
     $last_machine = $machine;
@@ -2003,6 +2011,7 @@ sub get_grub_index {
     my $command;
     my $target;
     my $skip;
+    my $submenu;
     my $grub_menu_qt;
 
     if ($reboot_type !~ /^grub/) {
@@ -2017,8 +2026,9 @@ sub get_grub_index {
 	$skip = '^\s*title\s';
     } elsif ($reboot_type eq "grub2") {
 	$command = "cat $grub_file";
-	$target = '^menuentry.*' . $grub_menu_qt;
-	$skip = '^menuentry\s|^submenu\s';
+	$target = '^\s*menuentry.*' . $grub_menu_qt;
+	$skip = '^\s*menuentry';
+	$submenu = '^\s*submenu\s';
     } elsif ($reboot_type eq "grub2bls") {
 	$command = $grub_bls_get;
 	$target = '^title=.*' . $grub_menu_qt;
@@ -2027,7 +2037,7 @@ sub get_grub_index {
 	return;
     }
 
-    _get_grub_index($command, $target, $skip);
+    _get_grub_index($command, $target, $skip, $submenu);
 }
 
 sub wait_for_input {
@@ -2090,7 +2100,7 @@ sub reboot_to {
     if ($reboot_type eq "grub") {
 	run_ssh "'(echo \"savedefault --default=$grub_number --once\" | grub --batch)'";
     } elsif (($reboot_type eq "grub2") or ($reboot_type eq "grub2bls")) {
-	run_ssh "$grub_reboot $grub_number";
+	run_ssh "$grub_reboot \"'$grub_number'\"";
     } elsif ($reboot_type eq "syslinux") {
 	run_ssh "$syslinux --once \\\"$syslinux_label\\\" $syslinux_path";
     } elsif (defined $reboot_script) {
@@ -3768,9 +3778,10 @@ sub test_this_config {
     # .config to make sure it is missing the config that
     # we had before
     my %configs = %min_configs;
-    delete $configs{$config};
+    $configs{$config} = "# $config is not set";
     make_new_config ((values %configs), (values %keep_configs));
     make_oldconfig;
+    delete $configs{$config};
     undef %configs;
     assign_configs \%configs, $output_config;
 
diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index a3ea3d4a206d..291144c284fb 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -123,6 +123,11 @@ endef
 clean:
 	$(CLEAN)
 
+# Enables to extend CFLAGS and LDFLAGS from command line, e.g.
+# make USERCFLAGS=-Werror USERLDFLAGS=-static
+CFLAGS += $(USERCFLAGS)
+LDFLAGS += $(USERLDFLAGS)
+
 # When make O= with kselftest target from main level
 # the following aren't defined.
 #
