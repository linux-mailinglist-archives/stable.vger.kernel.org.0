Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDF76B5D73
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 16:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230139AbjCKPuA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 10:50:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230402AbjCKPt5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 10:49:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A51EFE41EE;
        Sat, 11 Mar 2023 07:49:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA728B82573;
        Sat, 11 Mar 2023 15:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E9EC433EF;
        Sat, 11 Mar 2023 15:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678549783;
        bh=yeffIxpsfup7ZtdmolOYhXaww0trOriTjQJID3P9H7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ik6lJjeM5ZtG3IRzI03VMHDueY0JLlbkibMhhSULupI8wqQa7uLbB8q8PLRdfrnH8
         YKL0UZIi8i5f/1BNz8B5Diw9O4oanFV3pWIRqH9tbtCjEIdTEfGNNvVNGBHwQYgm24
         UcSfn1n2LnUG1vYm7wE5O3e6Ripu+ugzG2lJYG7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 4.14.308
Date:   Sat, 11 Mar 2023 16:49:35 +0100
Message-Id: <167854977414184@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <1678549774167165@kroah.com>
References: <1678549774167165@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/hw-vuln/spectre.rst b/Documentation/admin-guide/hw-vuln/spectre.rst
index 7e061ed449aa..0fba3758d0da 100644
--- a/Documentation/admin-guide/hw-vuln/spectre.rst
+++ b/Documentation/admin-guide/hw-vuln/spectre.rst
@@ -479,8 +479,16 @@ Spectre variant 2
    On Intel Skylake-era systems the mitigation covers most, but not all,
    cases. See :ref:`[3] <spec_ref3>` for more details.
 
-   On CPUs with hardware mitigation for Spectre variant 2 (e.g. Enhanced
-   IBRS on x86), retpoline is automatically disabled at run time.
+   On CPUs with hardware mitigation for Spectre variant 2 (e.g. IBRS
+   or enhanced IBRS on x86), retpoline is automatically disabled at run time.
+
+   Systems which support enhanced IBRS (eIBRS) enable IBRS protection once at
+   boot, by setting the IBRS bit, and they're automatically protected against
+   Spectre v2 variant attacks, including cross-thread branch target injections
+   on SMT systems (STIBP). In other words, eIBRS enables STIBP too.
+
+   Legacy IBRS systems clear the IBRS bit on exit to userspace and
+   therefore explicitly enable STIBP for that
 
    The retpoline mitigation is turned on by default on vulnerable
    CPUs. It can be forced on or off by the administrator
@@ -504,9 +512,12 @@ Spectre variant 2
    For Spectre variant 2 mitigation, individual user programs
    can be compiled with return trampolines for indirect branches.
    This protects them from consuming poisoned entries in the branch
-   target buffer left by malicious software.  Alternatively, the
-   programs can disable their indirect branch speculation via prctl()
-   (See :ref:`Documentation/userspace-api/spec_ctrl.rst <set_spec_ctrl>`).
+   target buffer left by malicious software.
+
+   On legacy IBRS systems, at return to userspace, implicit STIBP is disabled
+   because the kernel clears the IBRS bit. In this case, the userspace programs
+   can disable indirect branch speculation via prctl() (See
+   :ref:`Documentation/userspace-api/spec_ctrl.rst <set_spec_ctrl>`).
    On x86, this will turn on STIBP to guard against attacks from the
    sibling thread when the user program is running, and use IBPB to
    flush the branch target buffer when switching to/from the program.
diff --git a/Documentation/dev-tools/gdb-kernel-debugging.rst b/Documentation/dev-tools/gdb-kernel-debugging.rst
index 19df79286f00..afe4bc206486 100644
--- a/Documentation/dev-tools/gdb-kernel-debugging.rst
+++ b/Documentation/dev-tools/gdb-kernel-debugging.rst
@@ -39,6 +39,10 @@ Setup
   this mode. In this case, you should build the kernel with
   CONFIG_RANDOMIZE_BASE disabled if the architecture supports KASLR.
 
+- Build the gdb scripts (required on kernels v5.1 and above)::
+
+    make scripts_gdb
+
 - Enable the gdb stub of QEMU/KVM, either
 
     - at VM startup time by appending "-s" to the QEMU command line
diff --git a/Makefile b/Makefile
index 64d12ed10b82..4ea29fcd48eb 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 4
 PATCHLEVEL = 14
-SUBLEVEL = 307
+SUBLEVEL = 308
 EXTRAVERSION =
 NAME = Petit Gorille
 
@@ -88,10 +88,17 @@ endif
 
 # If the user is running make -s (silent mode), suppress echoing of
 # commands
+# make-4.0 (and later) keep single letter options in the 1st word of MAKEFLAGS.
 
-ifneq ($(findstring s,$(filter-out --%,$(MAKEFLAGS))),)
-  quiet=silent_
-  tools_silent=s
+ifeq ($(filter 3.%,$(MAKE_VERSION)),)
+silence:=$(findstring s,$(firstword -$(MAKEFLAGS)))
+else
+silence:=$(findstring s,$(filter-out --%,$(MAKEFLAGS)))
+endif
+
+ifeq ($(silence),s)
+quiet=silent_
+tools_silent=s
 endif
 
 export quiet Q KBUILD_VERBOSE
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index 6a45f392c672..482c6369c9d5 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -241,7 +241,21 @@ do_entIF(unsigned long type, struct pt_regs *regs)
 	siginfo_t info;
 	int signo, code;
 
-	if ((regs->ps & ~IPL_MAX) == 0) {
+	if (type == 3) { /* FEN fault */
+		/* Irritating users can call PAL_clrfen to disable the
+		   FPU for the process.  The kernel will then trap in
+		   do_switch_stack and undo_switch_stack when we try
+		   to save and restore the FP registers.
+
+		   Given that GCC by default generates code that uses the
+		   FP registers, PAL_clrfen is not useful except for DoS
+		   attacks.  So turn the bleeding FPU back on and be done
+		   with it.  */
+		current_thread_info()->pcb.flags |= 1;
+		__reload_thread(&current_thread_info()->pcb);
+		return;
+	}
+	if (!user_mode(regs)) {
 		if (type == 1) {
 			const unsigned int *data
 			  = (const unsigned int *) regs->pc;
@@ -390,20 +404,6 @@ do_entIF(unsigned long type, struct pt_regs *regs)
 		}
 		break;
 
-	      case 3: /* FEN fault */
-		/* Irritating users can call PAL_clrfen to disable the
-		   FPU for the process.  The kernel will then trap in
-		   do_switch_stack and undo_switch_stack when we try
-		   to save and restore the FP registers.
-
-		   Given that GCC by default generates code that uses the
-		   FP registers, PAL_clrfen is not useful except for DoS
-		   attacks.  So turn the bleeding FPU back on and be done
-		   with it.  */
-		current_thread_info()->pcb.flags |= 1;
-		__reload_thread(&current_thread_info()->pcb);
-		return;
-
 	      case 5: /* illoc */
 	      default: /* unexpected instruction-fault type */
 		      ;
diff --git a/arch/arm/boot/dts/exynos3250-rinato.dts b/arch/arm/boot/dts/exynos3250-rinato.dts
index c0c3b185b731..2a945d04592b 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -258,7 +258,7 @@
 	i80-if-timings {
 		cs-setup = <0>;
 		wr-setup = <0>;
-		wr-act = <1>;
+		wr-active = <1>;
 		wr-hold = <0>;
 	};
 };
diff --git a/arch/arm/boot/dts/exynos4-cpu-thermal.dtsi b/arch/arm/boot/dts/exynos4-cpu-thermal.dtsi
index 735cb2f10817..4274224c07c5 100644
--- a/arch/arm/boot/dts/exynos4-cpu-thermal.dtsi
+++ b/arch/arm/boot/dts/exynos4-cpu-thermal.dtsi
@@ -14,7 +14,7 @@
 / {
 thermal-zones {
 	cpu_thermal: cpu-thermal {
-		thermal-sensors = <&tmu 0>;
+		thermal-sensors = <&tmu>;
 		polling-delay-passive = <0>;
 		polling-delay = <0>;
 		trips {
diff --git a/arch/arm/boot/dts/exynos5410-odroidxu.dts b/arch/arm/boot/dts/exynos5410-odroidxu.dts
index ba135b255b68..32f524569ade 100644
--- a/arch/arm/boot/dts/exynos5410-odroidxu.dts
+++ b/arch/arm/boot/dts/exynos5410-odroidxu.dts
@@ -116,7 +116,6 @@
 };
 
 &cpu0_thermal {
-	thermal-sensors = <&tmu_cpu0 0>;
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
 
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 02d2f898efa6..d07e2a94a9dd 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -536,7 +536,7 @@
 		};
 
 		mipi_phy: mipi-video-phy {
-			compatible = "samsung,s5pv210-mipi-video-phy";
+			compatible = "samsung,exynos5420-mipi-video-phy";
 			syscon = <&pmu_system_controller>;
 			#phy-cells = <1>;
 		};
diff --git a/arch/arm/boot/dts/rk3288.dtsi b/arch/arm/boot/dts/rk3288.dtsi
index 872e4e690beb..c3440adc763c 100644
--- a/arch/arm/boot/dts/rk3288.dtsi
+++ b/arch/arm/boot/dts/rk3288.dtsi
@@ -1096,6 +1096,7 @@
 		clock-names = "dp", "pclk";
 		phys = <&edp_phy>;
 		phy-names = "dp";
+		power-domains = <&power RK3288_PD_VIO>;
 		resets = <&cru SRST_EDP>;
 		reset-names = "dp";
 		rockchip,grf = <&grf>;
diff --git a/arch/arm/boot/dts/spear320-hmi.dts b/arch/arm/boot/dts/spear320-hmi.dts
index 0d0da1f65f0e..1e54748799a6 100644
--- a/arch/arm/boot/dts/spear320-hmi.dts
+++ b/arch/arm/boot/dts/spear320-hmi.dts
@@ -248,7 +248,7 @@
 					irq-trigger = <0x1>;
 
 					stmpegpio: stmpe-gpio {
-						compatible = "stmpe,gpio";
+						compatible = "st,stmpe-gpio";
 						reg = <0>;
 						gpio-controller;
 						#gpio-cells = <2>;
diff --git a/arch/arm/mach-omap1/timer.c b/arch/arm/mach-omap1/timer.c
index 8fb1ec6fa999..7654253bc63c 100644
--- a/arch/arm/mach-omap1/timer.c
+++ b/arch/arm/mach-omap1/timer.c
@@ -165,7 +165,7 @@ static int __init omap1_dm_timer_init(void)
 	kfree(pdata);
 
 err_free_pdev:
-	platform_device_unregister(pdev);
+	platform_device_put(pdev);
 
 	return ret;
 }
diff --git a/arch/arm/mach-omap2/timer.c b/arch/arm/mach-omap2/timer.c
index d61fbd7a2840..c421d12b3203 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -562,6 +562,7 @@ static void __init realtime_counter_init(void)
 	}
 
 	rate = clk_get_rate(sys_clk);
+	clk_put(sys_clk);
 
 	if (soc_is_dra7xx()) {
 		/*
diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index f0292a30e6f6..6b75ef7be3fd 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -222,6 +222,7 @@ int __init zynq_early_slcr_init(void)
 	zynq_slcr_regmap = syscon_regmap_lookup_by_compatible("xlnx,zynq-slcr");
 	if (IS_ERR(zynq_slcr_regmap)) {
 		pr_err("%s: failed to find zynq-slcr\n", __func__);
+		of_node_put(np);
 		return -ENODEV;
 	}
 
diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index f175db846286..735dd7f07aaa 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -174,7 +174,7 @@
 			reg = <0x14 0x10>;
 		};
 
-		eth_mac: eth_mac@34 {
+		eth_mac: eth-mac@34 {
 			reg = <0x34 0x10>;
 		};
 
@@ -191,7 +191,7 @@
 		scpi_clocks: clocks {
 			compatible = "arm,scpi-clocks";
 
-			scpi_dvfs: scpi_clocks@0 {
+			scpi_dvfs: clocks-0 {
 				compatible = "arm,scpi-dvfs-clocks";
 				#clock-cells = <1>;
 				clock-indices = <0>;
@@ -435,7 +435,7 @@
 			#size-cells = <2>;
 			ranges = <0x0 0x0 0x0 0xc8834000 0x0 0x2000>;
 
-			hwrng: rng {
+			hwrng: rng@0 {
 				compatible = "amlogic,meson-rng";
 				reg = <0x0 0x0 0x0 0x4>;
 			};
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index 3ee6c4bae08f..853da285929c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -609,7 +609,7 @@
 		};
 	};
 
-	eth-phy-mux {
+	eth-phy-mux@55c {
 		compatible = "mdio-mux-mmioreg", "mdio-mux";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/m68k/68000/entry.S b/arch/m68k/68000/entry.S
index 259b3661b614..94abf3d8afc5 100644
--- a/arch/m68k/68000/entry.S
+++ b/arch/m68k/68000/entry.S
@@ -47,6 +47,8 @@ do_trace:
 	jbsr	syscall_trace_enter
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
+	addql	#1,%d0
+	jeq	ret_from_exception
 	movel	%sp@(PT_OFF_ORIG_D0),%d1
 	movel	#-ENOSYS,%d0
 	cmpl	#NR_syscalls,%d1
diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
index 3e9b0b826f8a..6fb693bb0771 100644
--- a/arch/m68k/Kconfig.devices
+++ b/arch/m68k/Kconfig.devices
@@ -19,6 +19,7 @@ config HEARTBEAT
 # We have a dedicated heartbeat LED. :-)
 config PROC_HARDWARE
 	bool "/proc/hardware support"
+	depends on PROC_FS
 	help
 	  Say Y here to support the /proc/hardware file, which gives you
 	  access to information about the machine you're running on,
diff --git a/arch/m68k/coldfire/entry.S b/arch/m68k/coldfire/entry.S
index 52d312d5b4d4..fb3b06567745 100644
--- a/arch/m68k/coldfire/entry.S
+++ b/arch/m68k/coldfire/entry.S
@@ -92,6 +92,8 @@ ENTRY(system_call)
 	jbsr	syscall_trace_enter
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
+	addql	#1,%d0
+	jeq	ret_from_exception
 	movel	%d3,%a0
 	jbsr	%a0@
 	movel	%d0,%sp@(PT_OFF_D0)		/* save the return value */
diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index 97cd3ea5f10b..9a66657773be 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -160,9 +160,12 @@ do_trace_entry:
 	jbsr	syscall_trace
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
+	addql	#1,%d0			| optimization for cmpil #-1,%d0
+	jeq	ret_from_syscall
 	movel	%sp@(PT_OFF_ORIG_D0),%d0
 	cmpl	#NR_syscalls,%d0
 	jcs	syscall
+	jra	ret_from_syscall
 badsys:
 	movel	#-ENOSYS,%sp@(PT_OFF_D0)
 	jra	ret_from_syscall
diff --git a/arch/mips/include/asm/syscall.h b/arch/mips/include/asm/syscall.h
index 53ee82b1efa7..305597e26b13 100644
--- a/arch/mips/include/asm/syscall.h
+++ b/arch/mips/include/asm/syscall.h
@@ -29,7 +29,7 @@
 static inline long syscall_get_nr(struct task_struct *task,
 				  struct pt_regs *regs)
 {
-	return current_thread_info()->syscall;
+	return task_thread_info(task)->syscall;
 }
 
 static inline unsigned long mips_get_syscall_arg(unsigned long *arg,
diff --git a/arch/mips/include/asm/vpe.h b/arch/mips/include/asm/vpe.h
index 80e70dbd1f64..012731546cf6 100644
--- a/arch/mips/include/asm/vpe.h
+++ b/arch/mips/include/asm/vpe.h
@@ -104,7 +104,6 @@ struct vpe_control {
 	struct list_head tc_list;       /* Thread contexts */
 };
 
-extern unsigned long physical_memsize;
 extern struct vpe_control vpecontrol;
 extern const struct file_operations vpe_fops;
 
diff --git a/arch/mips/kernel/vpe-mt.c b/arch/mips/kernel/vpe-mt.c
index 9fd7cd48ea1d..496ed8f362f6 100644
--- a/arch/mips/kernel/vpe-mt.c
+++ b/arch/mips/kernel/vpe-mt.c
@@ -92,12 +92,11 @@ int vpe_run(struct vpe *v)
 	write_tc_c0_tchalt(read_tc_c0_tchalt() & ~TCHALT_H);
 
 	/*
-	 * The sde-kit passes 'memsize' to __start in $a3, so set something
-	 * here...  Or set $a3 to zero and define DFLT_STACK_SIZE and
-	 * DFLT_HEAP_SIZE when you compile your program
+	 * We don't pass the memsize here, so VPE programs need to be
+	 * compiled with DFLT_STACK_SIZE and DFLT_HEAP_SIZE defined.
 	 */
+	mttgpr(7, 0);
 	mttgpr(6, v->ntcs);
-	mttgpr(7, physical_memsize);
 
 	/* set up VPE1 */
 	/*
diff --git a/arch/mips/lantiq/prom.c b/arch/mips/lantiq/prom.c
index a26322ff57e0..8cf186854031 100644
--- a/arch/mips/lantiq/prom.c
+++ b/arch/mips/lantiq/prom.c
@@ -25,12 +25,6 @@
 DEFINE_SPINLOCK(ebu_lock);
 EXPORT_SYMBOL_GPL(ebu_lock);
 
-/*
- * This is needed by the VPE loader code, just set it to 0 and assume
- * that the firmware hardcodes this value to something useful.
- */
-unsigned long physical_memsize = 0L;
-
 /*
  * this struct is filled by the soc specific detection code and holds
  * information about the specific soc type, revision and name
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 36ef504eeab3..58798ced4dbb 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -3155,7 +3155,8 @@ static void pnv_ioda_setup_pe_res(struct pnv_ioda_pe *pe,
 	int index;
 	int64_t rc;
 
-	if (!res || !res->flags || res->start > res->end)
+	if (!res || !res->flags || res->start > res->end ||
+	    res->flags & IORESOURCE_UNSET)
 		return;
 
 	if (res->flags & IORESOURCE_IO) {
diff --git a/arch/powerpc/platforms/pseries/lparcfg.c b/arch/powerpc/platforms/pseries/lparcfg.c
index 779fc2a1c8f7..f40dabf7d163 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -289,6 +289,7 @@ static void parse_mpp_x_data(struct seq_file *m)
  */
 static void parse_system_parameter_string(struct seq_file *m)
 {
+	const s32 token = rtas_token("ibm,get-system-parameter");
 	int call_status;
 
 	unsigned char *local_buffer = kmalloc(SPLPAR_MAXLENGTH, GFP_KERNEL);
@@ -298,16 +299,15 @@ static void parse_system_parameter_string(struct seq_file *m)
 		return;
 	}
 
-	spin_lock(&rtas_data_buf_lock);
-	memset(rtas_data_buf, 0, SPLPAR_MAXLENGTH);
-	call_status = rtas_call(rtas_token("ibm,get-system-parameter"), 3, 1,
-				NULL,
-				SPLPAR_CHARACTERISTICS_TOKEN,
-				__pa(rtas_data_buf),
-				RTAS_DATA_BUF_SIZE);
-	memcpy(local_buffer, rtas_data_buf, SPLPAR_MAXLENGTH);
-	local_buffer[SPLPAR_MAXLENGTH - 1] = '\0';
-	spin_unlock(&rtas_data_buf_lock);
+	do {
+		spin_lock(&rtas_data_buf_lock);
+		memset(rtas_data_buf, 0, SPLPAR_MAXLENGTH);
+		call_status = rtas_call(token, 3, 1, NULL, SPLPAR_CHARACTERISTICS_TOKEN,
+					__pa(rtas_data_buf), RTAS_DATA_BUF_SIZE);
+		memcpy(local_buffer, rtas_data_buf, SPLPAR_MAXLENGTH);
+		local_buffer[SPLPAR_MAXLENGTH - 1] = '\0';
+		spin_unlock(&rtas_data_buf_lock);
+	} while (rtas_busy_delay(call_status));
 
 	if (call_status != 0) {
 		printk(KERN_INFO
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index 6842e4501e2e..582ef31efd3c 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -272,6 +272,7 @@ static void pop_kprobe(struct kprobe_ctlblk *kcb)
 {
 	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
+	kcb->prev_kprobe.kp = NULL;
 }
 NOKPROBE_SYMBOL(pop_kprobe);
 
@@ -546,12 +547,11 @@ static int post_kprobe_handler(struct pt_regs *regs)
 	if (!p)
 		return 0;
 
+	resume_execution(p, regs);
 	if (kcb->kprobe_status != KPROBE_REENTER && p->post_handler) {
 		kcb->kprobe_status = KPROBE_HIT_SSDONE;
 		p->post_handler(p, regs, 0);
 	}
-
-	resume_execution(p, regs);
 	pop_kprobe(kcb);
 	preempt_enable_no_resched();
 
diff --git a/arch/s390/kernel/setup.c b/arch/s390/kernel/setup.c
index b3343f093f67..3a0b5988f1b4 100644
--- a/arch/s390/kernel/setup.c
+++ b/arch/s390/kernel/setup.c
@@ -911,6 +911,7 @@ void __init setup_arch(char **cmdline_p)
 	if (IS_ENABLED(CONFIG_EXPOLINE_AUTO))
 		nospec_auto_detect();
 
+	jump_label_init();
 	parse_early_param();
 #ifdef CONFIG_CRASH_DUMP
 	/* Deactivate elfcorehdr= kernel parameter */
diff --git a/arch/s390/mm/maccess.c b/arch/s390/mm/maccess.c
index 7be06475809b..a40739ea3805 100644
--- a/arch/s390/mm/maccess.c
+++ b/arch/s390/mm/maccess.c
@@ -58,13 +58,19 @@ static notrace long s390_kernel_write_odd(void *dst, const void *src, size_t siz
  */
 void notrace s390_kernel_write(void *dst, const void *src, size_t size)
 {
+	unsigned long flags;
 	long copied;
 
-	while (size) {
-		copied = s390_kernel_write_odd(dst, src, size);
-		dst += copied;
-		src += copied;
-		size -= copied;
+	flags = arch_local_save_flags();
+	if (!(flags & PSW_MASK_DAT)) {
+		memcpy(dst, src, size);
+	} else {
+		while (size) {
+			copied = s390_kernel_write_odd(dst, src, size);
+			dst += copied;
+			src += copied;
+			size -= copied;
+		}
 	}
 }
 
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index c11755bddea2..7d37fff51df9 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -144,7 +144,7 @@ static inline unsigned int x86_cpuid_family(void)
 int __init microcode_init(void);
 extern void __init load_ucode_bsp(void);
 extern void load_ucode_ap(void);
-void reload_early_microcode(void);
+void reload_early_microcode(unsigned int cpu);
 extern bool get_builtin_firmware(struct cpio_data *cd, const char *name);
 extern bool initrd_gone;
 void microcode_bsp_resume(void);
@@ -152,7 +152,7 @@ void microcode_bsp_resume(void);
 static inline int __init microcode_init(void)			{ return 0; };
 static inline void __init load_ucode_bsp(void)			{ }
 static inline void load_ucode_ap(void)				{ }
-static inline void reload_early_microcode(void)			{ }
+static inline void reload_early_microcode(unsigned int cpu)	{ }
 static inline void microcode_bsp_resume(void)			{ }
 static inline bool
 get_builtin_firmware(struct cpio_data *cd, const char *name)	{ return false; }
diff --git a/arch/x86/include/asm/microcode_amd.h b/arch/x86/include/asm/microcode_amd.h
index 5c524d4f71cd..a645b25ee442 100644
--- a/arch/x86/include/asm/microcode_amd.h
+++ b/arch/x86/include/asm/microcode_amd.h
@@ -47,12 +47,12 @@ struct microcode_amd {
 extern void __init load_ucode_amd_bsp(unsigned int family);
 extern void load_ucode_amd_ap(unsigned int family);
 extern int __init save_microcode_in_initrd_amd(unsigned int family);
-void reload_ucode_amd(void);
+void reload_ucode_amd(unsigned int cpu);
 #else
 static inline void __init load_ucode_amd_bsp(unsigned int family) {}
 static inline void load_ucode_amd_ap(unsigned int family) {}
 static inline int __init
 save_microcode_in_initrd_amd(unsigned int family) { return -EINVAL; }
-void reload_ucode_amd(void) {}
+static inline void reload_ucode_amd(unsigned int cpu) {}
 #endif
 #endif /* _ASM_X86_MICROCODE_AMD_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index d7a344e0a851..c71862d34048 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -50,6 +50,10 @@
 #define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior */
 #define SPEC_CTRL_RRSBA_DIS_S		BIT(SPEC_CTRL_RRSBA_DIS_S_SHIFT)
 
+/* A mask for bits which the kernel toggles when controlling mitigations */
+#define SPEC_CTRL_MITIGATIONS_MASK	(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD \
+							| SPEC_CTRL_RRSBA_DIS_S)
+
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
 #define PRED_CMD_IBPB			BIT(0)	   /* Indirect Branch Prediction Barrier */
 
diff --git a/arch/x86/include/asm/reboot.h b/arch/x86/include/asm/reboot.h
index a671a1145906..9177b4354c3f 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,6 +25,8 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
+void cpu_emergency_disable_virtualization(void);
+
 typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
 void nmi_shootdown_cpus(nmi_shootdown_cb callback);
 void run_crash_ipi_callback(struct pt_regs *regs);
diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 0116b2ee9e64..4699acd602af 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -114,7 +114,21 @@ static inline void cpu_svm_disable(void)
 
 	wrmsrl(MSR_VM_HSAVE_PA, 0);
 	rdmsrl(MSR_EFER, efer);
-	wrmsrl(MSR_EFER, efer & ~EFER_SVME);
+	if (efer & EFER_SVME) {
+		/*
+		 * Force GIF=1 prior to disabling SVM to ensure INIT and NMI
+		 * aren't blocked, e.g. if a fatal error occurred between CLGI
+		 * and STGI.  Note, STGI may #UD if SVM is disabled from NMI
+		 * context between reading EFER and executing STGI.  In that
+		 * case, GIF must already be set, otherwise the NMI would have
+		 * been blocked, so just eat the fault.
+		 */
+		asm_volatile_goto("1: stgi\n\t"
+				  _ASM_EXTABLE(1b, %l[fault])
+				  ::: "memory" : fault);
+fault:
+		wrmsrl(MSR_EFER, efer & ~EFER_SVME);
+	}
 }
 
 /** Makes sure SVM is disabled, if it is supported on the CPU
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 80dfd84c3ca8..1f0bf85b0101 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -135,9 +135,17 @@ void __init check_bugs(void)
 	 * have unknown values. AMD64_LS_CFG MSR is cached in the early AMD
 	 * init code as it is not enumerated and depends on the family.
 	 */
-	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
+	if (cpu_feature_enabled(X86_FEATURE_MSR_SPEC_CTRL)) {
 		rdmsrl(MSR_IA32_SPEC_CTRL, x86_spec_ctrl_base);
 
+		/*
+		 * Previously running kernel (kexec), may have some controls
+		 * turned ON. Clear them and let the mitigations setup below
+		 * rediscover them based on configuration.
+		 */
+		x86_spec_ctrl_base &= ~SPEC_CTRL_MITIGATIONS_MASK;
+	}
+
 	/* Select the proper CPU mitigations before patching alternatives: */
 	spectre_v1_select_mitigation();
 	spectre_v2_select_mitigation();
@@ -973,14 +981,18 @@ spectre_v2_parse_user_cmdline(void)
 	return SPECTRE_V2_USER_CMD_AUTO;
 }
 
-static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
+static inline bool spectre_v2_in_eibrs_mode(enum spectre_v2_mitigation mode)
 {
-	return mode == SPECTRE_V2_IBRS ||
-	       mode == SPECTRE_V2_EIBRS ||
+	return mode == SPECTRE_V2_EIBRS ||
 	       mode == SPECTRE_V2_EIBRS_RETPOLINE ||
 	       mode == SPECTRE_V2_EIBRS_LFENCE;
 }
 
+static inline bool spectre_v2_in_ibrs_mode(enum spectre_v2_mitigation mode)
+{
+	return spectre_v2_in_eibrs_mode(mode) || mode == SPECTRE_V2_IBRS;
+}
+
 static void __init
 spectre_v2_user_select_mitigation(void)
 {
@@ -1043,12 +1055,19 @@ spectre_v2_user_select_mitigation(void)
 	}
 
 	/*
-	 * If no STIBP, IBRS or enhanced IBRS is enabled, or SMT impossible,
-	 * STIBP is not required.
+	 * If no STIBP, enhanced IBRS is enabled, or SMT impossible, STIBP
+	 * is not required.
+	 *
+	 * Enhanced IBRS also protects against cross-thread branch target
+	 * injection in user-mode as the IBRS bit remains always set which
+	 * implicitly enables cross-thread protections.  However, in legacy IBRS
+	 * mode, the IBRS bit is set only on kernel entry and cleared on return
+	 * to userspace. This disables the implicit cross-thread protection,
+	 * so allow for STIBP to be selected in that case.
 	 */
 	if (!boot_cpu_has(X86_FEATURE_STIBP) ||
 	    !smt_possible ||
-	    spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	    spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return;
 
 	/*
@@ -2100,7 +2119,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return "";
 
 	switch (spectre_v2_user_stibp) {
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 69dd0c9de460..22fb64951bb8 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -54,7 +54,9 @@ struct cont_desc {
 };
 
 static u32 ucode_new_rev;
-static u8 amd_ucode_patch[PATCH_MAX_SIZE];
+
+/* One blob per node. */
+static u8 amd_ucode_patch[MAX_NUMNODES][PATCH_MAX_SIZE];
 
 /*
  * Microcode patch container file is prepended to the initrd in cpio
@@ -210,7 +212,7 @@ apply_microcode_early_amd(u32 cpuid_1_eax, void *ucode, size_t size, bool save_p
 	patch	= (u8 (*)[PATCH_MAX_SIZE])__pa_nodebug(&amd_ucode_patch);
 #else
 	new_rev = &ucode_new_rev;
-	patch	= &amd_ucode_patch;
+	patch	= &amd_ucode_patch[0];
 #endif
 
 	desc.cpuid_1_eax = cpuid_1_eax;
@@ -329,8 +331,7 @@ void load_ucode_amd_ap(unsigned int cpuid_1_eax)
 	apply_microcode_early_amd(cpuid_1_eax, cp.data, cp.size, false);
 }
 
-static enum ucode_state
-load_microcode_amd(bool save, u8 family, const u8 *data, size_t size);
+static enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size);
 
 int __init save_microcode_in_initrd_amd(unsigned int cpuid_1_eax)
 {
@@ -348,19 +349,19 @@ int __init save_microcode_in_initrd_amd(unsigned int cpuid_1_eax)
 	if (!desc.mc)
 		return -EINVAL;
 
-	ret = load_microcode_amd(true, x86_family(cpuid_1_eax), desc.data, desc.size);
+	ret = load_microcode_amd(x86_family(cpuid_1_eax), desc.data, desc.size);
 	if (ret > UCODE_UPDATED)
 		return -EINVAL;
 
 	return 0;
 }
 
-void reload_ucode_amd(void)
+void reload_ucode_amd(unsigned int cpu)
 {
-	struct microcode_amd *mc;
 	u32 rev, dummy;
+	struct microcode_amd *mc;
 
-	mc = (struct microcode_amd *)amd_ucode_patch;
+	mc = (struct microcode_amd *)amd_ucode_patch[cpu_to_node(cpu)];
 
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
@@ -698,9 +699,10 @@ static enum ucode_state __load_microcode_amd(u8 family, const u8 *data,
 	return UCODE_OK;
 }
 
-static enum ucode_state
-load_microcode_amd(bool save, u8 family, const u8 *data, size_t size)
+static enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size)
 {
+	struct cpuinfo_x86 *c;
+	unsigned int nid, cpu;
 	struct ucode_patch *p;
 	enum ucode_state ret;
 
@@ -713,22 +715,22 @@ load_microcode_amd(bool save, u8 family, const u8 *data, size_t size)
 		return ret;
 	}
 
-	p = find_patch(0);
-	if (!p) {
-		return ret;
-	} else {
-		if (boot_cpu_data.microcode >= p->patch_id)
-			return ret;
+	for_each_node(nid) {
+		cpu = cpumask_first(cpumask_of_node(nid));
+		c = &cpu_data(cpu);
 
-		ret = UCODE_NEW;
-	}
+		p = find_patch(cpu);
+		if (!p)
+			continue;
 
-	/* save BSP's matching patch for early load */
-	if (!save)
-		return ret;
+		if (c->microcode >= p->patch_id)
+			continue;
 
-	memset(amd_ucode_patch, 0, PATCH_MAX_SIZE);
-	memcpy(amd_ucode_patch, p->data, min_t(u32, ksize(p->data), PATCH_MAX_SIZE));
+		ret = UCODE_NEW;
+
+		memset(&amd_ucode_patch[nid], 0, PATCH_MAX_SIZE);
+		memcpy(&amd_ucode_patch[nid], p->data, min_t(u32, ksize(p->data), PATCH_MAX_SIZE));
+	}
 
 	return ret;
 }
@@ -754,12 +756,11 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 {
 	char fw_name[36] = "amd-ucode/microcode_amd.bin";
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
-	bool bsp = c->cpu_index == boot_cpu_data.cpu_index;
 	enum ucode_state ret = UCODE_NFOUND;
 	const struct firmware *fw;
 
 	/* reload ucode container only on the boot cpu */
-	if (!refresh_fw || !bsp)
+	if (!refresh_fw)
 		return UCODE_OK;
 
 	if (c->x86 >= 0x15)
@@ -776,7 +777,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 		goto fw_release;
 	}
 
-	ret = load_microcode_amd(bsp, c->x86, fw->data, fw->size);
+	ret = load_microcode_amd(c->x86, fw->data, fw->size);
 
  fw_release:
 	release_firmware(fw);
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 78ac8c33a16e..cc3acb2ff99b 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -326,7 +326,7 @@ struct cpio_data find_microcode_in_initrd(const char *path, bool use_pa)
 #endif
 }
 
-void reload_early_microcode(void)
+void reload_early_microcode(unsigned int cpu)
 {
 	int vendor, family;
 
@@ -340,7 +340,7 @@ void reload_early_microcode(void)
 		break;
 	case X86_VENDOR_AMD:
 		if (family >= 0x10)
-			reload_ucode_amd();
+			reload_ucode_amd(cpu);
 		break;
 	default:
 		break;
@@ -783,7 +783,7 @@ void microcode_bsp_resume(void)
 	if (uci->valid && uci->mc)
 		microcode_ops->apply_microcode(cpu);
 	else if (!uci->mc)
-		reload_early_microcode();
+		reload_early_microcode(cpu);
 }
 
 static struct syscore_ops mc_syscore_ops = {
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index ce5f8e25f70d..37e4809a8e7b 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -36,7 +36,6 @@
 #include <linux/kdebug.h>
 #include <asm/cpu.h>
 #include <asm/reboot.h>
-#include <asm/virtext.h>
 #include <asm/intel_pt.h>
 
 /* Alignment required for elf header segment */
@@ -118,15 +117,6 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
 	 */
 	cpu_crash_vmclear_loaded_vmcss();
 
-	/* Disable VMX or SVM if needed.
-	 *
-	 * We need to disable virtualization on all CPUs.
-	 * Having VMX or SVM enabled on any CPU may break rebooting
-	 * after the kdump kernel has finished its task.
-	 */
-	cpu_emergency_vmxoff();
-	cpu_emergency_svm_disable();
-
 	/*
 	 * Disable Intel PT to stop its logging
 	 */
@@ -185,12 +175,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	 */
 	cpu_crash_vmclear_loaded_vmcss();
 
-	/* Booting kdump kernel with VMX or SVM enabled won't work,
-	 * because (among other limitations) we can't disable paging
-	 * with the virt flags.
-	 */
-	cpu_emergency_vmxoff();
-	cpu_emergency_svm_disable();
+	cpu_emergency_disable_virtualization();
 
 	/*
 	 * Disable Intel PT to stop its logging
diff --git a/arch/x86/kernel/kprobes/opt.c b/arch/x86/kernel/kprobes/opt.c
index f4e4db0cbd59..012e23b90e6a 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -56,8 +56,8 @@ unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf, unsigned long addr)
 		/* This function only handles jump-optimized kprobe */
 		if (kp && kprobe_optimized(kp)) {
 			op = container_of(kp, struct optimized_kprobe, kp);
-			/* If op->list is not empty, op is under optimizing */
-			if (list_empty(&op->list))
+			/* If op is optimized or under unoptimizing */
+			if (list_empty(&op->list) || optprobe_queued_unopt(op))
 				goto found;
 		}
 	}
@@ -330,7 +330,7 @@ int arch_check_optimized_kprobe(struct optimized_kprobe *op)
 
 	for (i = 1; i < op->optinsn.size; i++) {
 		p = get_kprobe(op->kp.addr + i);
-		if (p && !kprobe_disabled(p))
+		if (p && !kprobe_disarmed(p))
 			return -EEXIST;
 	}
 
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index aa08b7614ab0..a93de3047e46 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -536,33 +536,29 @@ static inline void kb_wait(void)
 	}
 }
 
-static void vmxoff_nmi(int cpu, struct pt_regs *regs)
-{
-	cpu_emergency_vmxoff();
-}
+static inline void nmi_shootdown_cpus_on_restart(void);
 
-/* Use NMIs as IPIs to tell all CPUs to disable virtualization */
-static void emergency_vmx_disable_all(void)
+static void emergency_reboot_disable_virtualization(void)
 {
 	/* Just make sure we won't change CPUs while doing this */
 	local_irq_disable();
 
 	/*
-	 * Disable VMX on all CPUs before rebooting, otherwise we risk hanging
-	 * the machine, because the CPU blocks INIT when it's in VMX root.
+	 * Disable virtualization on all CPUs before rebooting to avoid hanging
+	 * the system, as VMX and SVM block INIT when running in the host.
 	 *
 	 * We can't take any locks and we may be on an inconsistent state, so
-	 * use NMIs as IPIs to tell the other CPUs to exit VMX root and halt.
+	 * use NMIs as IPIs to tell the other CPUs to disable VMX/SVM and halt.
 	 *
-	 * Do the NMI shootdown even if VMX if off on _this_ CPU, as that
-	 * doesn't prevent a different CPU from being in VMX root operation.
+	 * Do the NMI shootdown even if virtualization is off on _this_ CPU, as
+	 * other CPUs may have virtualization enabled.
 	 */
-	if (cpu_has_vmx()) {
-		/* Safely force _this_ CPU out of VMX root operation. */
-		__cpu_emergency_vmxoff();
+	if (cpu_has_vmx() || cpu_has_svm(NULL)) {
+		/* Safely force _this_ CPU out of VMX/SVM operation. */
+		cpu_emergency_disable_virtualization();
 
-		/* Halt and exit VMX root operation on the other CPUs. */
-		nmi_shootdown_cpus(vmxoff_nmi);
+		/* Disable VMX/SVM and halt on other CPUs. */
+		nmi_shootdown_cpus_on_restart();
 
 	}
 }
@@ -599,7 +595,7 @@ static void native_machine_emergency_restart(void)
 	unsigned short mode;
 
 	if (reboot_emergency)
-		emergency_vmx_disable_all();
+		emergency_reboot_disable_virtualization();
 
 	tboot_shutdown(TB_SHUTDOWN_REBOOT);
 
@@ -803,6 +799,17 @@ void machine_crash_shutdown(struct pt_regs *regs)
 /* This is the CPU performing the emergency shutdown work. */
 int crashing_cpu = -1;
 
+/*
+ * Disable virtualization, i.e. VMX or SVM, to ensure INIT is recognized during
+ * reboot.  VMX blocks INIT if the CPU is post-VMXON, and SVM blocks INIT if
+ * GIF=0, i.e. if the crash occurred between CLGI and STGI.
+ */
+void cpu_emergency_disable_virtualization(void)
+{
+	cpu_emergency_vmxoff();
+	cpu_emergency_svm_disable();
+}
+
 #if defined(CONFIG_SMP)
 
 static nmi_shootdown_cb shootdown_callback;
@@ -825,7 +832,14 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 		return NMI_HANDLED;
 	local_irq_disable();
 
-	shootdown_callback(cpu, regs);
+	if (shootdown_callback)
+		shootdown_callback(cpu, regs);
+
+	/*
+	 * Prepare the CPU for reboot _after_ invoking the callback so that the
+	 * callback can safely use virtualization instructions, e.g. VMCLEAR.
+	 */
+	cpu_emergency_disable_virtualization();
 
 	atomic_dec(&waiting_for_crash_ipi);
 	/* Assume hlt works */
@@ -841,18 +855,32 @@ static void smp_send_nmi_allbutself(void)
 	apic->send_IPI_allbutself(NMI_VECTOR);
 }
 
-/*
- * Halt all other CPUs, calling the specified function on each of them
+/**
+ * nmi_shootdown_cpus - Stop other CPUs via NMI
+ * @callback:	Optional callback to be invoked from the NMI handler
+ *
+ * The NMI handler on the remote CPUs invokes @callback, if not
+ * NULL, first and then disables virtualization to ensure that
+ * INIT is recognized during reboot.
  *
- * This function can be used to halt all other CPUs on crash
- * or emergency reboot time. The function passed as parameter
- * will be called inside a NMI handler on all CPUs.
+ * nmi_shootdown_cpus() can only be invoked once. After the first
+ * invocation all other CPUs are stuck in crash_nmi_callback() and
+ * cannot respond to a second NMI.
  */
 void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 {
 	unsigned long msecs;
+
 	local_irq_disable();
 
+	/*
+	 * Avoid certain doom if a shootdown already occurred; re-registering
+	 * the NMI handler will cause list corruption, modifying the callback
+	 * will do who knows what, etc...
+	 */
+	if (WARN_ON_ONCE(crash_ipi_issued))
+		return;
+
 	/* Make a note of crashing cpu. Will be used in NMI callback. */
 	crashing_cpu = safe_smp_processor_id();
 
@@ -880,7 +908,17 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 		msecs--;
 	}
 
-	/* Leave the nmi callback set */
+	/*
+	 * Leave the nmi callback set, shootdown is a one-time thing.  Clearing
+	 * the callback could result in a NULL pointer dereference if a CPU
+	 * (finally) responds after the timeout expires.
+	 */
+}
+
+static inline void nmi_shootdown_cpus_on_restart(void)
+{
+	if (!crash_ipi_issued)
+		nmi_shootdown_cpus(NULL);
 }
 
 /*
@@ -910,6 +948,8 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 	/* No other CPUs to shoot down */
 }
 
+static inline void nmi_shootdown_cpus_on_restart(void) { }
+
 void run_crash_ipi_callback(struct pt_regs *regs)
 {
 }
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index b2b87b91f336..c94ed0b37bcd 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -33,7 +33,7 @@
 #include <asm/mce.h>
 #include <asm/trace/irq_vectors.h>
 #include <asm/kexec.h>
-#include <asm/virtext.h>
+#include <asm/reboot.h>
 
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
@@ -163,7 +163,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 	if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
 		return NMI_HANDLED;
 
-	cpu_emergency_vmxoff();
+	cpu_emergency_disable_virtualization();
 	stop_this_cpu(NULL);
 
 	return NMI_HANDLED;
@@ -176,7 +176,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 asmlinkage __visible void smp_reboot_interrupt(void)
 {
 	ipi_entering_ack_irq();
-	cpu_emergency_vmxoff();
+	cpu_emergency_disable_virtualization();
 	stop_this_cpu(NULL);
 	irq_exit();
 }
diff --git a/arch/x86/kernel/sysfb_efi.c b/arch/x86/kernel/sysfb_efi.c
index 897da526e40e..dd8d7636c542 100644
--- a/arch/x86/kernel/sysfb_efi.c
+++ b/arch/x86/kernel/sysfb_efi.c
@@ -265,6 +265,14 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
 					"Lenovo ideapad D330-10IGM"),
 		},
 	},
+	{
+		/* Lenovo IdeaPad Duet 3 10IGL5 with 1200x1920 portrait screen */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_VERSION,
+					"IdeaPad Duet 3 10IGL5"),
+		},
+	},
 	{},
 };
 
diff --git a/arch/x86/um/vdso/um_vdso.c b/arch/x86/um/vdso/um_vdso.c
index 7c441b59d375..be99ff25c503 100644
--- a/arch/x86/um/vdso/um_vdso.c
+++ b/arch/x86/um/vdso/um_vdso.c
@@ -20,8 +20,10 @@ int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
 {
 	long ret;
 
-	asm("syscall" : "=a" (ret) :
-		"0" (__NR_clock_gettime), "D" (clock), "S" (ts) : "memory");
+	asm("syscall"
+		: "=a" (ret)
+		: "0" (__NR_clock_gettime), "D" (clock), "S" (ts)
+		: "rcx", "r11", "memory");
 
 	return ret;
 }
@@ -32,8 +34,10 @@ int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
 {
 	long ret;
 
-	asm("syscall" : "=a" (ret) :
-		"0" (__NR_gettimeofday), "D" (tv), "S" (tz) : "memory");
+	asm("syscall"
+		: "=a" (ret)
+		: "0" (__NR_gettimeofday), "D" (tv), "S" (tz)
+		: "rcx", "r11", "memory");
 
 	return ret;
 }
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 4cee9446ce58..d0cdfba3a4c4 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -462,6 +462,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	bip->bip_vcnt = bip_src->bip_vcnt;
 	bip->bip_iter = bip_src->bip_iter;
+	bip->bip_flags = bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
 
 	return 0;
 }
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 3279b457c4ed..0c70fbcd293d 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -216,16 +216,14 @@ static void pkcs1pad_encrypt_sign_complete_cb(
 		struct crypto_async_request *child_async_req, int err)
 {
 	struct akcipher_request *req = child_async_req->data;
-	struct crypto_async_request async_req;
 
 	if (err == -EINPROGRESS)
-		return;
+		goto out;
+
+	err = pkcs1pad_encrypt_sign_complete(req, err);
 
-	async_req.data = req->base.data;
-	async_req.tfm = crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
-	async_req.flags = child_async_req->flags;
-	req->base.complete(&async_req,
-			pkcs1pad_encrypt_sign_complete(req, err));
+out:
+	akcipher_request_complete(req, err);
 }
 
 static int pkcs1pad_encrypt(struct akcipher_request *req)
@@ -336,15 +334,14 @@ static void pkcs1pad_decrypt_complete_cb(
 		struct crypto_async_request *child_async_req, int err)
 {
 	struct akcipher_request *req = child_async_req->data;
-	struct crypto_async_request async_req;
 
 	if (err == -EINPROGRESS)
-		return;
+		goto out;
+
+	err = pkcs1pad_decrypt_complete(req, err);
 
-	async_req.data = req->base.data;
-	async_req.tfm = crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
-	async_req.flags = child_async_req->flags;
-	req->base.complete(&async_req, pkcs1pad_decrypt_complete(req, err));
+out:
+	akcipher_request_complete(req, err);
 }
 
 static int pkcs1pad_decrypt(struct akcipher_request *req)
@@ -506,15 +503,14 @@ static void pkcs1pad_verify_complete_cb(
 		struct crypto_async_request *child_async_req, int err)
 {
 	struct akcipher_request *req = child_async_req->data;
-	struct crypto_async_request async_req;
 
 	if (err == -EINPROGRESS)
-		return;
+		goto out;
 
-	async_req.data = req->base.data;
-	async_req.tfm = crypto_akcipher_tfm(crypto_akcipher_reqtfm(req));
-	async_req.flags = child_async_req->flags;
-	req->base.complete(&async_req, pkcs1pad_verify_complete(req, err));
+	err = pkcs1pad_verify_complete(req, err);
+
+out:
+	akcipher_request_complete(req, err);
 }
 
 /*
diff --git a/crypto/seqiv.c b/crypto/seqiv.c
index 570b7d1aa0ca..ce9214097bc9 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -30,7 +30,7 @@ static void seqiv_aead_encrypt_complete2(struct aead_request *req, int err)
 	struct aead_request *subreq = aead_request_ctx(req);
 	struct crypto_aead *geniv;
 
-	if (err == -EINPROGRESS)
+	if (err == -EINPROGRESS || err == -EBUSY)
 		return;
 
 	if (err)
diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
index e05232da0588..1e8e4e7a29cb 100644
--- a/drivers/acpi/acpica/Makefile
+++ b/drivers/acpi/acpica/Makefile
@@ -3,7 +3,7 @@
 # Makefile for ACPICA Core interpreter
 #
 
-ccflags-y			:= -Os -D_LINUX -DBUILDING_ACPICA
+ccflags-y			:= -D_LINUX -DBUILDING_ACPICA
 ccflags-$(CONFIG_ACPI_DEBUG)	+= -DACPI_DEBUG_OUTPUT
 
 # use acpi.o to put all files here into acpi.o modparam namespace
diff --git a/drivers/acpi/acpica/nsrepair.c b/drivers/acpi/acpica/nsrepair.c
index 418ef2ac82ab..9f95369772dd 100644
--- a/drivers/acpi/acpica/nsrepair.c
+++ b/drivers/acpi/acpica/nsrepair.c
@@ -215,8 +215,9 @@ acpi_ns_simple_repair(struct acpi_evaluate_info *info,
 	 * Try to fix if there was no return object. Warning if failed to fix.
 	 */
 	if (!return_object) {
-		if (expected_btypes && (!(expected_btypes & ACPI_RTYPE_NONE))) {
-			if (package_index != ACPI_NOT_PACKAGE_ELEMENT) {
+		if (expected_btypes) {
+			if (!(expected_btypes & ACPI_RTYPE_NONE) &&
+			    package_index != ACPI_NOT_PACKAGE_ELEMENT) {
 				ACPI_WARN_PREDEFINED((AE_INFO,
 						      info->full_pathname,
 						      ACPI_WARN_ALWAYS,
@@ -230,14 +231,15 @@ acpi_ns_simple_repair(struct acpi_evaluate_info *info,
 				if (ACPI_SUCCESS(status)) {
 					return (AE_OK);	/* Repair was successful */
 				}
-			} else {
+			}
+
+			if (expected_btypes != ACPI_RTYPE_NONE) {
 				ACPI_WARN_PREDEFINED((AE_INFO,
 						      info->full_pathname,
 						      ACPI_WARN_ALWAYS,
 						      "Missing expected return value"));
+				return (AE_AML_NO_RETURN_VALUE);
 			}
-
-			return (AE_AML_NO_RETURN_VALUE);
 		}
 	}
 
diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index 42fba8493854..96aeb0c8cc0e 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -415,7 +415,7 @@ static int extract_package(struct acpi_battery *battery,
 			u8 *ptr = (u8 *)battery + offsets[i].offset;
 			if (element->type == ACPI_TYPE_STRING ||
 			    element->type == ACPI_TYPE_BUFFER)
-				strncpy(ptr, element->string.pointer, 32);
+				strscpy(ptr, element->string.pointer, 32);
 			else if (element->type == ACPI_TYPE_INTEGER) {
 				strncpy(ptr, (u8 *)&element->integer.value,
 					sizeof(u64));
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 0ec74ab2a399..b4f16073ef43 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -300,7 +300,7 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 	 .ident = "Lenovo Ideapad Z570",
 	 .matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "102434U"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "Ideapad Z570"),
 		},
 	},
 	{
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index a4725ac1d409..859d227504f7 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4778,8 +4778,7 @@ static void rbd_dev_release(struct device *dev)
 		module_put(THIS_MODULE);
 }
 
-static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
-					   struct rbd_spec *spec)
+static struct rbd_device *__rbd_dev_create(struct rbd_spec *spec)
 {
 	struct rbd_device *rbd_dev;
 
@@ -4812,9 +4811,6 @@ static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
 	rbd_dev->dev.parent = &rbd_root_dev;
 	device_initialize(&rbd_dev->dev);
 
-	rbd_dev->rbd_client = rbdc;
-	rbd_dev->spec = spec;
-
 	return rbd_dev;
 }
 
@@ -4827,12 +4823,10 @@ static struct rbd_device *rbd_dev_create(struct rbd_client *rbdc,
 {
 	struct rbd_device *rbd_dev;
 
-	rbd_dev = __rbd_dev_create(rbdc, spec);
+	rbd_dev = __rbd_dev_create(spec);
 	if (!rbd_dev)
 		return NULL;
 
-	rbd_dev->opts = opts;
-
 	/* get an id and fill in device name */
 	rbd_dev->dev_id = ida_simple_get(&rbd_dev_id_ida, 0,
 					 minor_to_rbd_dev_id(1 << MINORBITS),
@@ -4849,6 +4843,10 @@ static struct rbd_device *rbd_dev_create(struct rbd_client *rbdc,
 	/* we have a ref from do_rbd_add() */
 	__module_get(THIS_MODULE);
 
+	rbd_dev->rbd_client = rbdc;
+	rbd_dev->spec = spec;
+	rbd_dev->opts = opts;
+
 	dout("%s rbd_dev %p dev_id %d\n", __func__, rbd_dev, rbd_dev->dev_id);
 	return rbd_dev;
 
@@ -5934,7 +5932,7 @@ static int rbd_dev_probe_parent(struct rbd_device *rbd_dev, int depth)
 		goto out_err;
 	}
 
-	parent = __rbd_dev_create(rbd_dev->rbd_client, rbd_dev->parent_spec);
+	parent = __rbd_dev_create(rbd_dev->parent_spec);
 	if (!parent) {
 		ret = -ENOMEM;
 		goto out_err;
@@ -5944,8 +5942,8 @@ static int rbd_dev_probe_parent(struct rbd_device *rbd_dev, int depth)
 	 * Images related by parent/child relationships always share
 	 * rbd_client and spec/parent_spec, so bump their refcounts.
 	 */
-	__rbd_get_client(rbd_dev->rbd_client);
-	rbd_spec_get(rbd_dev->parent_spec);
+	parent->rbd_client = __rbd_get_client(rbd_dev->rbd_client);
+	parent->spec = rbd_spec_get(rbd_dev->parent_spec);
 
 	ret = rbd_dev_image_probe(parent, depth);
 	if (ret < 0)
diff --git a/drivers/cpufreq/davinci-cpufreq.c b/drivers/cpufreq/davinci-cpufreq.c
index d54a27c99121..3dacfc53a80d 100644
--- a/drivers/cpufreq/davinci-cpufreq.c
+++ b/drivers/cpufreq/davinci-cpufreq.c
@@ -138,12 +138,14 @@ static int __init davinci_cpufreq_probe(struct platform_device *pdev)
 
 static int __exit davinci_cpufreq_remove(struct platform_device *pdev)
 {
+	cpufreq_unregister_driver(&davinci_driver);
+
 	clk_put(cpufreq.armclk);
 
 	if (cpufreq.asyncclk)
 		clk_put(cpufreq.asyncclk);
 
-	return cpufreq_unregister_driver(&davinci_driver);
+	return 0;
 }
 
 static struct platform_driver davinci_cpufreq_driver = {
diff --git a/drivers/dma/sh/rcar-dmac.c b/drivers/dma/sh/rcar-dmac.c
index e31fb3f91d07..8524306d7de6 100644
--- a/drivers/dma/sh/rcar-dmac.c
+++ b/drivers/dma/sh/rcar-dmac.c
@@ -1766,7 +1766,10 @@ static int rcar_dmac_probe(struct platform_device *pdev)
 	dmac->dev = &pdev->dev;
 	platform_set_drvdata(pdev, dmac);
 	dmac->dev->dma_parms = &dmac->parms;
-	dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
+	ret = dma_set_max_seg_size(dmac->dev, RCAR_DMATCR_MASK);
+	if (ret)
+		return ret;
+
 	ret = dma_set_mask_and_coherent(dmac->dev, DMA_BIT_MASK(40));
 	if (ret)
 		return ret;
diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index 91d6966c3d29..457ee42023f4 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -281,7 +281,7 @@ static int vf610_gpio_probe(struct platform_device *pdev)
 	gc = &port->gc;
 	gc->of_node = np;
 	gc->parent = dev;
-	gc->label = "vf610-gpio";
+	gc->label = dev_name(dev);
 	gc->ngpio = VF610_GPIO_PER_PORT;
 	gc->base = of_alias_get_id(np, "gpio") * VF610_GPIO_PER_PORT;
 
diff --git a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
index 313c80f29972..89454d1d2d99 100644
--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -437,7 +437,11 @@ static int __init stdpxxxx_ge_b850v3_init(void)
 	if (ret)
 		return ret;
 
-	return i2c_add_driver(&stdp2690_ge_b850v3_fw_driver);
+	ret = i2c_add_driver(&stdp2690_ge_b850v3_fw_driver);
+	if (ret)
+		i2c_del_driver(&stdp4028_ge_b850v3_fw_driver);
+
+	return ret;
 }
 module_init(stdpxxxx_ge_b850v3_init);
 
diff --git a/drivers/gpu/drm/drm_mipi_dsi.c b/drivers/gpu/drm/drm_mipi_dsi.c
index bd5e8661f826..6995bee5ad0f 100644
--- a/drivers/gpu/drm/drm_mipi_dsi.c
+++ b/drivers/gpu/drm/drm_mipi_dsi.c
@@ -1091,6 +1091,58 @@ int mipi_dsi_dcs_get_display_brightness(struct mipi_dsi_device *dsi,
 }
 EXPORT_SYMBOL(mipi_dsi_dcs_get_display_brightness);
 
+/**
+ * mipi_dsi_dcs_set_display_brightness_large() - sets the 16-bit brightness value
+ *    of the display
+ * @dsi: DSI peripheral device
+ * @brightness: brightness value
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int mipi_dsi_dcs_set_display_brightness_large(struct mipi_dsi_device *dsi,
+					     u16 brightness)
+{
+	u8 payload[2] = { brightness >> 8, brightness & 0xff };
+	ssize_t err;
+
+	err = mipi_dsi_dcs_write(dsi, MIPI_DCS_SET_DISPLAY_BRIGHTNESS,
+				 payload, sizeof(payload));
+	if (err < 0)
+		return err;
+
+	return 0;
+}
+EXPORT_SYMBOL(mipi_dsi_dcs_set_display_brightness_large);
+
+/**
+ * mipi_dsi_dcs_get_display_brightness_large() - gets the current 16-bit
+ *    brightness value of the display
+ * @dsi: DSI peripheral device
+ * @brightness: brightness value
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int mipi_dsi_dcs_get_display_brightness_large(struct mipi_dsi_device *dsi,
+					     u16 *brightness)
+{
+	u8 brightness_be[2];
+	ssize_t err;
+
+	err = mipi_dsi_dcs_read(dsi, MIPI_DCS_GET_DISPLAY_BRIGHTNESS,
+				brightness_be, sizeof(brightness_be));
+	if (err <= 0) {
+		if (err == 0)
+			err = -ENODATA;
+
+		return err;
+	}
+
+	*brightness = (brightness_be[0] << 8) | brightness_be[1];
+
+	return 0;
+}
+EXPORT_SYMBOL(mipi_dsi_dcs_get_display_brightness_large);
+
 static int mipi_dsi_drv_probe(struct device *dev)
 {
 	struct mipi_dsi_driver *drv = to_mipi_dsi_driver(dev->driver);
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_gem.c b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
index f595ac816b55..1818980dafce 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
@@ -148,8 +148,6 @@ static int mtk_drm_gem_object_mmap(struct drm_gem_object *obj,
 
 	ret = dma_mmap_attrs(priv->dma_dev, vma, mtk_gem->cookie,
 			     mtk_gem->dma_addr, obj->size, mtk_gem->dma_attrs);
-	if (ret)
-		drm_gem_vm_close(vma);
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index c9c8d2190515..43a3a48a15df 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1769,6 +1769,9 @@ int msm_dsi_host_init(struct msm_dsi *msm_dsi)
 
 	/* setup workqueue */
 	msm_host->workqueue = alloc_ordered_workqueue("dsi_drm_work", 0);
+	if (!msm_host->workqueue)
+		return -ENOMEM;
+
 	INIT_WORK(&msm_host->err_work, dsi_err_worker);
 	INIT_WORK(&msm_host->hpd_work, dsi_hpd_worker);
 
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index c55e1920bfde..4c02c057fc0d 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -246,6 +246,10 @@ static struct hdmi *msm_hdmi_init(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
 	hdmi->workq = alloc_ordered_workqueue("msm_hdmi", 0);
+	if (!hdmi->workq) {
+		ret = -ENOMEM;
+		goto fail;
+	}
 
 	hdmi->i2c = msm_hdmi_i2c_init(hdmi);
 	if (IS_ERR(hdmi->i2c)) {
diff --git a/drivers/gpu/drm/mxsfb/Kconfig b/drivers/gpu/drm/mxsfb/Kconfig
index 3ed6849d63cb..1a2805c7a0eb 100644
--- a/drivers/gpu/drm/mxsfb/Kconfig
+++ b/drivers/gpu/drm/mxsfb/Kconfig
@@ -7,6 +7,7 @@ config DRM_MXSFB
 	tristate "i.MX23/i.MX28/i.MX6SX MXSFB LCD controller"
 	depends on DRM && OF
 	depends on COMMON_CLK
+	depends on ARCH_MXS || ARCH_MXC || COMPILE_TEST
 	select DRM_MXS
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 79aef5c063fa..5f1b503def55 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -2188,11 +2188,12 @@ int radeon_atom_pick_dig_encoder(struct drm_encoder *encoder, int fe_idx)
 
 	/*
 	 * On DCE32 any encoder can drive any block so usually just use crtc id,
-	 * but Apple thinks different at least on iMac10,1, so there use linkb,
+	 * but Apple thinks different at least on iMac10,1 and iMac11,2, so there use linkb,
 	 * otherwise the internal eDP panel will stay dark.
 	 */
 	if (ASIC_IS_DCE32(rdev)) {
-		if (dmi_match(DMI_PRODUCT_NAME, "iMac10,1"))
+		if (dmi_match(DMI_PRODUCT_NAME, "iMac10,1") ||
+		    dmi_match(DMI_PRODUCT_NAME, "iMac11,2"))
 			enc_idx = (dig->linkb) ? 1 : 0;
 		else
 			enc_idx = radeon_crtc->crtc_id;
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 906547b229a9..e0fe21e7378b 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1045,6 +1045,7 @@ void radeon_atombios_fini(struct radeon_device *rdev)
 {
 	if (rdev->mode_info.atom_context) {
 		kfree(rdev->mode_info.atom_context->scratch);
+		kfree(rdev->mode_info.atom_context->iio);
 	}
 	kfree(rdev->mode_info.atom_context);
 	rdev->mode_info.atom_context = NULL;
diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index f3a57c0500f3..1a7ca888546f 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -1234,6 +1234,7 @@ static int ipu_add_client_devices(struct ipu_soc *ipu, unsigned long ipu_base)
 		pdev = platform_device_alloc(reg->name, id++);
 		if (!pdev) {
 			ret = -ENOMEM;
+			of_node_put(of_node);
 			goto err_register;
 		}
 
diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index a7a63abdea86..7cdbde2b114b 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -82,6 +82,7 @@ struct asus_kbd_leds {
 	struct hid_device *hdev;
 	struct work_struct work;
 	unsigned int brightness;
+	spinlock_t lock;
 	bool removed;
 };
 
@@ -293,24 +294,42 @@ static int asus_kbd_get_functions(struct hid_device *hdev,
 	return ret;
 }
 
+static void asus_schedule_work(struct asus_kbd_leds *led)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&led->lock, flags);
+	if (!led->removed)
+		schedule_work(&led->work);
+	spin_unlock_irqrestore(&led->lock, flags);
+}
+
 static void asus_kbd_backlight_set(struct led_classdev *led_cdev,
 				   enum led_brightness brightness)
 {
 	struct asus_kbd_leds *led = container_of(led_cdev, struct asus_kbd_leds,
 						 cdev);
-	if (led->brightness == brightness)
-		return;
+	unsigned long flags;
 
+	spin_lock_irqsave(&led->lock, flags);
 	led->brightness = brightness;
-	schedule_work(&led->work);
+	spin_unlock_irqrestore(&led->lock, flags);
+
+	asus_schedule_work(led);
 }
 
 static enum led_brightness asus_kbd_backlight_get(struct led_classdev *led_cdev)
 {
 	struct asus_kbd_leds *led = container_of(led_cdev, struct asus_kbd_leds,
 						 cdev);
+	enum led_brightness brightness;
+	unsigned long flags;
+
+	spin_lock_irqsave(&led->lock, flags);
+	brightness = led->brightness;
+	spin_unlock_irqrestore(&led->lock, flags);
 
-	return led->brightness;
+	return brightness;
 }
 
 static void asus_kbd_backlight_work(struct work_struct *work)
@@ -318,11 +337,11 @@ static void asus_kbd_backlight_work(struct work_struct *work)
 	struct asus_kbd_leds *led = container_of(work, struct asus_kbd_leds, work);
 	u8 buf[] = { FEATURE_KBD_REPORT_ID, 0xba, 0xc5, 0xc4, 0x00 };
 	int ret;
+	unsigned long flags;
 
-	if (led->removed)
-		return;
-
+	spin_lock_irqsave(&led->lock, flags);
 	buf[4] = led->brightness;
+	spin_unlock_irqrestore(&led->lock, flags);
 
 	ret = asus_kbd_set_report(led->hdev, buf, sizeof(buf));
 	if (ret < 0)
@@ -363,6 +382,7 @@ static int asus_kbd_register_leds(struct hid_device *hdev)
 	drvdata->kbd_backlight->cdev.brightness_set = asus_kbd_backlight_set;
 	drvdata->kbd_backlight->cdev.brightness_get = asus_kbd_backlight_get;
 	INIT_WORK(&drvdata->kbd_backlight->work, asus_kbd_backlight_work);
+	spin_lock_init(&drvdata->kbd_backlight->lock);
 
 	ret = devm_led_classdev_register(&hdev->dev, &drvdata->kbd_backlight->cdev);
 	if (ret < 0) {
@@ -661,9 +681,13 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
 static void asus_remove(struct hid_device *hdev)
 {
 	struct asus_drvdata *drvdata = hid_get_drvdata(hdev);
+	unsigned long flags;
 
 	if (drvdata->kbd_backlight) {
+		spin_lock_irqsave(&drvdata->kbd_backlight->lock, flags);
 		drvdata->kbd_backlight->removed = true;
+		spin_unlock_irqrestore(&drvdata->kbd_backlight->lock, flags);
+
 		cancel_work_sync(&drvdata->kbd_backlight->work);
 	}
 
diff --git a/drivers/hwmon/ltc2945.c b/drivers/hwmon/ltc2945.c
index 1b92e4f6e234..efabe514ec56 100644
--- a/drivers/hwmon/ltc2945.c
+++ b/drivers/hwmon/ltc2945.c
@@ -257,6 +257,8 @@ static ssize_t ltc2945_set_value(struct device *dev,
 
 	/* convert to register value, then clamp and write result */
 	regval = ltc2945_val_to_reg(dev, reg, val);
+	if (regval < 0)
+		return regval;
 	if (is_power_reg(reg)) {
 		regval = clamp_val(regval, 0, 0xffffff);
 		regbuf[0] = regval >> 16;
diff --git a/drivers/iio/accel/mma9551_core.c b/drivers/iio/accel/mma9551_core.c
index c34c5ce8123b..19b4fbc682e6 100644
--- a/drivers/iio/accel/mma9551_core.c
+++ b/drivers/iio/accel/mma9551_core.c
@@ -304,9 +304,12 @@ int mma9551_read_config_word(struct i2c_client *client, u8 app_id,
 
 	ret = mma9551_transfer(client, app_id, MMA9551_CMD_READ_CONFIG,
 			       reg, NULL, 0, (u8 *)&v, 2);
+	if (ret < 0)
+		return ret;
+
 	*val = be16_to_cpu(v);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(mma9551_read_config_word);
 
@@ -362,9 +365,12 @@ int mma9551_read_status_word(struct i2c_client *client, u8 app_id,
 
 	ret = mma9551_transfer(client, app_id, MMA9551_CMD_READ_STATUS,
 			       reg, NULL, 0, (u8 *)&v, 2);
+	if (ret < 0)
+		return ret;
+
 	*val = be16_to_cpu(v);
 
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(mma9551_read_status_word);
 
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index b17c1fc59f7e..1987bb8412a2 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -213,16 +213,11 @@ static void unpin_rcv_pages(struct hfi1_filedata *fd,
 static int pin_rcv_pages(struct hfi1_filedata *fd, struct tid_user_buf *tidbuf)
 {
 	int pinned;
-	unsigned int npages;
+	unsigned int npages = tidbuf->npages;
 	unsigned long vaddr = tidbuf->vaddr;
 	struct page **pages = NULL;
 	struct hfi1_devdata *dd = fd->uctxt->dd;
 
-	/* Get the number of pages the user buffer spans */
-	npages = num_user_pages(vaddr, tidbuf->length);
-	if (!npages)
-		return -EINVAL;
-
 	if (npages > fd->uctxt->expected_count) {
 		dd_dev_err(dd, "Expected buffer too big\n");
 		return -EINVAL;
@@ -256,7 +251,6 @@ static int pin_rcv_pages(struct hfi1_filedata *fd, struct tid_user_buf *tidbuf)
 		return pinned;
 	}
 	tidbuf->pages = pages;
-	tidbuf->npages = npages;
 	fd->tid_n_pinned += pinned;
 	return pinned;
 }
@@ -332,6 +326,7 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 
 	tidbuf->vaddr = tinfo->vaddr;
 	tidbuf->length = tinfo->length;
+	tidbuf->npages = num_user_pages(tidbuf->vaddr, tidbuf->length);
 	tidbuf->psets = kcalloc(uctxt->expected_count, sizeof(*tidbuf->psets),
 				GFP_KERNEL);
 	if (!tidbuf->psets) {
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index b536768234b7..fe6c9e187041 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -790,14 +790,8 @@ static void ads7846_report_state(struct ads7846 *ts)
 	if (x == MAX_12BIT)
 		x = 0;
 
-	if (ts->model == 7843) {
+	if (ts->model == 7843 || ts->model == 7845) {
 		Rt = ts->pressure_max / 2;
-	} else if (ts->model == 7845) {
-		if (get_pendown_state(ts))
-			Rt = ts->pressure_max / 2;
-		else
-			Rt = 0;
-		dev_vdbg(&ts->spi->dev, "x/y: %d/%d, PD %d\n", x, y, Rt);
 	} else if (likely(x && z1)) {
 		/* compute touch pressure resistance using equation #2 */
 		Rt = z2;
@@ -1374,8 +1368,9 @@ static int ads7846_probe(struct spi_device *spi)
 			pdata->y_min ? : 0,
 			pdata->y_max ? : MAX_12BIT,
 			0, 0);
-	input_set_abs_params(input_dev, ABS_PRESSURE,
-			pdata->pressure_min, pdata->pressure_max, 0, 0);
+	if (ts->model != 7845)
+		input_set_abs_params(input_dev, ABS_PRESSURE,
+				pdata->pressure_min, pdata->pressure_max, 0, 0);
 
 	ads7846_setup_spi_msg(ts, pdata);
 
diff --git a/drivers/irqchip/irq-alpine-msi.c b/drivers/irqchip/irq-alpine-msi.c
index ac431697ebe1..5e03574e1c5f 100644
--- a/drivers/irqchip/irq-alpine-msi.c
+++ b/drivers/irqchip/irq-alpine-msi.c
@@ -199,6 +199,7 @@ static int alpine_msix_init_domains(struct alpine_msix_data *priv,
 	}
 
 	gic_domain = irq_find_host(gic_node);
+	of_node_put(gic_node);
 	if (!gic_domain) {
 		pr_err("Failed to find the GIC domain\n");
 		return -ENXIO;
diff --git a/drivers/irqchip/irq-bcm7120-l2.c b/drivers/irqchip/irq-bcm7120-l2.c
index 983640eba418..80c52854d41b 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -271,7 +271,8 @@ static int __init bcm7120_l2_intc_probe(struct device_node *dn,
 		flags |= IRQ_GC_BE_IO;
 
 	ret = irq_alloc_domain_generic_chips(data->domain, IRQS_PER_WORD, 1,
-				dn->full_name, handle_level_irq, clr, 0, flags);
+				dn->full_name, handle_level_irq, clr,
+				IRQ_LEVEL, flags);
 	if (ret) {
 		pr_err("failed to allocate generic irq chip\n");
 		goto out_free_domain;
diff --git a/drivers/irqchip/irq-mvebu-gicp.c b/drivers/irqchip/irq-mvebu-gicp.c
index 17a4a7b6cdbb..6d9761423cbd 100644
--- a/drivers/irqchip/irq-mvebu-gicp.c
+++ b/drivers/irqchip/irq-mvebu-gicp.c
@@ -239,6 +239,7 @@ static int mvebu_gicp_probe(struct platform_device *pdev)
 	}
 
 	parent_domain = irq_find_host(irq_parent_dn);
+	of_node_put(irq_parent_dn);
 	if (!parent_domain) {
 		dev_err(&pdev->dev, "failed to find parent IRQ domain\n");
 		return -ENODEV;
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 5458a0697167..590aff275acb 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1952,6 +1952,7 @@ static void process_deferred_bios(struct work_struct *ws)
 
 		else
 			commit_needed = process_bio(cache, bio) || commit_needed;
+		cond_resched();
 	}
 
 	if (commit_needed)
@@ -1974,6 +1975,7 @@ static void requeue_deferred_bios(struct cache *cache)
 	while ((bio = bio_list_pop(&bios))) {
 		bio->bi_status = BLK_STS_DM_REQUEUE;
 		bio_endio(bio);
+		cond_resched();
 	}
 }
 
@@ -2014,6 +2016,8 @@ static void check_migrations(struct work_struct *ws)
 		r = mg_start(cache, op, NULL);
 		if (r)
 			break;
+
+		cond_resched();
 	}
 }
 
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 53cd31199f21..9bbadceaed91 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -301,8 +301,11 @@ static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
 	 */
 	bio_for_each_segment(bvec, bio, iter) {
 		if (bio_iter_len(bio, iter) > corrupt_bio_byte) {
-			char *segment = (page_address(bio_iter_page(bio, iter))
-					 + bio_iter_offset(bio, iter));
+			char *segment;
+			struct page *page = bio_iter_page(bio, iter);
+			if (unlikely(page == ZERO_PAGE(0)))
+				break;
+			segment = (page_address(page) + bio_iter_offset(bio, iter));
 			segment[corrupt_bio_byte] = fc->corrupt_bio_value;
 			DMDEBUG("Corrupting data bio=%p by writing %u to byte %u "
 				"(rw=%c bi_opf=%u bi_sector=%llu size=%u)\n",
@@ -364,9 +367,11 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 		/*
 		 * Corrupt matching writes.
 		 */
-		if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == WRITE)) {
-			if (all_corrupt_bio_flags_match(bio, fc))
-				corrupt_bio_data(bio, fc);
+		if (fc->corrupt_bio_byte) {
+			if (fc->corrupt_bio_rw == WRITE) {
+				if (all_corrupt_bio_flags_match(bio, fc))
+					corrupt_bio_data(bio, fc);
+			}
 			goto map_bio;
 		}
 
@@ -397,13 +402,14 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 	}
 
 	if (!*error && pb->bio_submitted && (bio_data_dir(bio) == READ)) {
-		if (fc->corrupt_bio_byte && (fc->corrupt_bio_rw == READ) &&
-		    all_corrupt_bio_flags_match(bio, fc)) {
-			/*
-			 * Corrupt successful matching READs while in down state.
-			 */
-			corrupt_bio_data(bio, fc);
-
+		if (fc->corrupt_bio_byte) {
+			if ((fc->corrupt_bio_rw == READ) &&
+			    all_corrupt_bio_flags_match(bio, fc)) {
+				/*
+				 * Corrupt successful matching READs while in down state.
+				 */
+				corrupt_bio_data(bio, fc);
+			}
 		} else if (!test_bit(DROP_WRITES, &fc->flags) &&
 			   !test_bit(ERROR_WRITES, &fc->flags)) {
 			/*
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 6c7fa790c8ae..fcf1eaafec72 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2233,6 +2233,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 			throttle_work_update(&pool->throttle);
 			dm_pool_issue_prefetches(pool->pmd);
 		}
+		cond_resched();
 	}
 	blk_finish_plug(&plug);
 }
@@ -2316,6 +2317,7 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 			else
 				pool->process_cell(tc, cell);
 		}
+		cond_resched();
 	} while (!list_empty(&cells));
 }
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9e6689fd2273..e3facf14f614 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -220,7 +220,6 @@ static int __init local_init(void)
 
 static void local_exit(void)
 {
-	flush_scheduled_work();
 	destroy_workqueue(deferred_remove_workqueue);
 
 	kmem_cache_destroy(_rq_cache);
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index c46402f3e88c..0df930c80916 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2286,7 +2286,16 @@ static int isp_probe(struct platform_device *pdev)
 
 	/* Regulators */
 	isp->isp_csiphy1.vdd = devm_regulator_get(&pdev->dev, "vdd-csiphy1");
+	if (IS_ERR(isp->isp_csiphy1.vdd)) {
+		ret = PTR_ERR(isp->isp_csiphy1.vdd);
+		goto error;
+	}
+
 	isp->isp_csiphy2.vdd = devm_regulator_get(&pdev->dev, "vdd-csiphy2");
+	if (IS_ERR(isp->isp_csiphy2.vdd)) {
+		ret = PTR_ERR(isp->isp_csiphy2.vdd);
+		goto error;
+	}
 
 	/* Clocks
 	 *
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index af7ba23e16e1..4761b2a72d8e 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1117,6 +1117,8 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
 	unsigned long flags;
 
+	rc_unregister_device(dev->rdev);
+	del_timer_sync(&dev->tx_sim_timer);
 	spin_lock_irqsave(&dev->hw_lock, flags);
 	ene_rx_disable(dev);
 	ene_rx_restore_hw_buffer(dev);
@@ -1124,7 +1126,6 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 
 	free_irq(dev->irq, dev);
 	release_region(dev->hw_io, ENE_IO_SIZE);
-	rc_unregister_device(dev->rdev);
 	kfree(dev);
 }
 
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index ec759f43c634..cdbc636e8ff8 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -191,6 +191,7 @@ static void smsusb_stop_streaming(struct smsusb_device_t *dev)
 
 	for (i = 0; i < MAX_URBS; i++) {
 		usb_kill_urb(&dev->surbs[i].urb);
+		cancel_work_sync(&dev->surbs[i].wq);
 
 		if (dev->surbs[i].cb) {
 			smscore_putbuffer(dev->coredev, dev->surbs[i].cb);
diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index f2457953f27c..0d5aaaa7e2d9 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -42,7 +42,7 @@ static int uvc_mc_create_links(struct uvc_video_chain *chain,
 			continue;
 
 		remote = uvc_entity_by_id(chain->dev, entity->baSourceID[i]);
-		if (remote == NULL)
+		if (remote == NULL || remote->num_pads == 0)
 			return -EINVAL;
 
 		source = (UVC_ENTITY_TYPE(remote) == UVC_TT_STREAMING)
diff --git a/drivers/mfd/pcf50633-adc.c b/drivers/mfd/pcf50633-adc.c
index c1984b0d1b65..a4a765055ee6 100644
--- a/drivers/mfd/pcf50633-adc.c
+++ b/drivers/mfd/pcf50633-adc.c
@@ -140,6 +140,7 @@ int pcf50633_adc_async_read(struct pcf50633 *pcf, int mux, int avg,
 			     void *callback_param)
 {
 	struct pcf50633_adc_request *req;
+	int ret;
 
 	/* req is freed when the result is ready, in interrupt handler */
 	req = kmalloc(sizeof(*req), GFP_KERNEL);
@@ -151,7 +152,11 @@ int pcf50633_adc_async_read(struct pcf50633 *pcf, int mux, int avg,
 	req->callback = callback;
 	req->callback_param = callback_param;
 
-	return adc_enqueue_request(pcf, req);
+	ret = adc_enqueue_request(pcf, req);
+	if (ret)
+		kfree(req);
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(pcf50633_adc_async_read);
 
diff --git a/drivers/mtd/nand/sunxi_nand.c b/drivers/mtd/nand/sunxi_nand.c
index 916e0ccd1e27..f8e98b1eaede 100644
--- a/drivers/mtd/nand/sunxi_nand.c
+++ b/drivers/mtd/nand/sunxi_nand.c
@@ -1786,7 +1786,7 @@ static int sunxi_nand_ooblayout_free(struct mtd_info *mtd, int section,
 	if (section < ecc->steps)
 		oobregion->length = 4;
 	else
-		oobregion->offset = mtd->oobsize - oobregion->offset;
+		oobregion->length = mtd->oobsize - oobregion->offset;
 
 	return 0;
 }
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 933c4de39dce..c6765210a6fc 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -480,6 +480,7 @@ static int uif_init(struct ubi_device *ubi)
 			err = ubi_add_volume(ubi, ubi->volumes[i]);
 			if (err) {
 				ubi_err(ubi, "cannot add volume %d", i);
+				ubi->volumes[i] = NULL;
 				goto out_volumes;
 			}
 		}
@@ -647,6 +648,12 @@ static int io_init(struct ubi_device *ubi, int max_beb_per1024)
 	ubi->ec_hdr_alsize = ALIGN(UBI_EC_HDR_SIZE, ubi->hdrs_min_io_size);
 	ubi->vid_hdr_alsize = ALIGN(UBI_VID_HDR_SIZE, ubi->hdrs_min_io_size);
 
+	if (ubi->vid_hdr_offset && ((ubi->vid_hdr_offset + UBI_VID_HDR_SIZE) >
+	    ubi->vid_hdr_alsize)) {
+		ubi_err(ubi, "VID header offset %d too large.", ubi->vid_hdr_offset);
+		return -EINVAL;
+	}
+
 	dbg_gen("min_io_size      %d", ubi->min_io_size);
 	dbg_gen("max_write_size   %d", ubi->max_write_size);
 	dbg_gen("hdrs_min_io_size %d", ubi->hdrs_min_io_size);
diff --git a/drivers/mtd/ubi/vmt.c b/drivers/mtd/ubi/vmt.c
index d32144c0098a..8815673e2e57 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -470,7 +470,7 @@ int ubi_resize_volume(struct ubi_volume_desc *desc, int reserved_pebs)
 		for (i = 0; i < -pebs; i++) {
 			err = ubi_eba_unmap_leb(ubi, vol, reserved_pebs + i);
 			if (err)
-				goto out_acc;
+				goto out_free;
 		}
 		spin_lock(&ubi->volumes_lock);
 		ubi->rsvd_pebs += pebs;
@@ -518,8 +518,10 @@ int ubi_resize_volume(struct ubi_volume_desc *desc, int reserved_pebs)
 		ubi->avail_pebs += pebs;
 		spin_unlock(&ubi->volumes_lock);
 	}
+	return err;
+
 out_free:
-	kfree(new_eba_tbl);
+	ubi_eba_destroy_table(new_eba_tbl);
 	return err;
 }
 
@@ -586,6 +588,7 @@ int ubi_add_volume(struct ubi_device *ubi, struct ubi_volume *vol)
 	if (err) {
 		ubi_err(ubi, "cannot add character device for volume %d, error %d",
 			vol_id, err);
+		vol_release(&vol->dev);
 		return err;
 	}
 
@@ -596,15 +599,14 @@ int ubi_add_volume(struct ubi_device *ubi, struct ubi_volume *vol)
 	vol->dev.groups = volume_dev_groups;
 	dev_set_name(&vol->dev, "%s_%d", ubi->ubi_name, vol->vol_id);
 	err = device_register(&vol->dev);
-	if (err)
-		goto out_cdev;
+	if (err) {
+		cdev_del(&vol->cdev);
+		put_device(&vol->dev);
+		return err;
+	}
 
 	self_check_volumes(ubi);
 	return err;
-
-out_cdev:
-	cdev_del(&vol->cdev);
-	return err;
 }
 
 /**
diff --git a/drivers/mtd/ubi/wl.c b/drivers/mtd/ubi/wl.c
index 545a92eb8f56..4411ce5d1c8f 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -878,8 +878,11 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 
 	err = do_sync_erase(ubi, e1, vol_id, lnum, 0);
 	if (err) {
-		if (e2)
+		if (e2) {
+			spin_lock(&ubi->wl_lock);
 			wl_entry_destroy(ubi, e2);
+			spin_unlock(&ubi->wl_lock);
+		}
 		goto out_ro;
 	}
 
@@ -961,11 +964,11 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 	spin_lock(&ubi->wl_lock);
 	ubi->move_from = ubi->move_to = NULL;
 	ubi->move_to_put = ubi->wl_scheduled = 0;
+	wl_entry_destroy(ubi, e1);
+	wl_entry_destroy(ubi, e2);
 	spin_unlock(&ubi->wl_lock);
 
 	ubi_free_vid_buf(vidb);
-	wl_entry_destroy(ubi, e1);
-	wl_entry_destroy(ubi, e2);
 
 out_ro:
 	ubi_ro_mode(ubi);
@@ -1103,14 +1106,18 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
 		/* Re-schedule the LEB for erasure */
 		err1 = schedule_erase(ubi, e, vol_id, lnum, 0, false);
 		if (err1) {
+			spin_lock(&ubi->wl_lock);
 			wl_entry_destroy(ubi, e);
+			spin_unlock(&ubi->wl_lock);
 			err = err1;
 			goto out_ro;
 		}
 		return err;
 	}
 
+	spin_lock(&ubi->wl_lock);
 	wl_entry_destroy(ubi, e);
+	spin_unlock(&ubi->wl_lock);
 	if (err != -EIO)
 		/*
 		 * If this is not %-EIO, we have no idea what to do. Scheduling
@@ -1226,6 +1233,18 @@ int ubi_wl_put_peb(struct ubi_device *ubi, int vol_id, int lnum,
 retry:
 	spin_lock(&ubi->wl_lock);
 	e = ubi->lookuptbl[pnum];
+	if (!e) {
+		/*
+		 * This wl entry has been removed for some errors by other
+		 * process (eg. wear leveling worker), corresponding process
+		 * (except __erase_worker, which cannot concurrent with
+		 * ubi_wl_put_peb) will set ubi ro_mode at the same time,
+		 * just ignore this wl entry.
+		 */
+		spin_unlock(&ubi->wl_lock);
+		up_read(&ubi->fm_protect);
+		return 0;
+	}
 	if (e == ubi->move_from) {
 		/*
 		 * User is putting the physical eraseblock which was selected to
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index fbe1173b2651..b15154a6c53e 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -284,7 +284,6 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 				cf->data[2] |= CAN_ERR_PROT_STUFF;
 				break;
 			default:
-				cf->data[3] = ecc & SJA1000_ECC_SEG;
 				break;
 			}
 
@@ -292,6 +291,9 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 			if (!(ecc & SJA1000_ECC_DIR))
 				cf->data[2] |= CAN_ERR_PROT_TX;
 
+			/* Bit stream position in CAN frame as the error was detected */
+			cf->data[3] = ecc & SJA1000_ECC_SEG;
+
 			if (priv->can.state == CAN_STATE_ERROR_WARNING ||
 			    priv->can.state == CAN_STATE_ERROR_PASSIVE) {
 				cf->data[1] = (txerr > rxerr) ?
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 9bb398d05837..e5e52c0c39a5 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1799,6 +1799,14 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
 			  __func__, p_index, ring->c_index,
 			  ring->read_ptr, dma_length_status);
 
+		if (unlikely(len > RX_BUF_LENGTH)) {
+			netif_err(priv, rx_status, dev, "oversized packet\n");
+			dev->stats.rx_length_errors++;
+			dev->stats.rx_errors++;
+			dev_kfree_skb_any(skb);
+			goto next;
+		}
+
 		if (unlikely(!(dma_flag & DMA_EOP) || !(dma_flag & DMA_SOP))) {
 			netif_err(priv, rx_status, dev,
 				  "dropping fragmented packet!\n");
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 9c3653e06886..fc880c02459d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -164,7 +164,8 @@ static int alloc_4k(struct mlx5_core_dev *dev, u64 *addr)
 	fp = list_entry(dev->priv.free_list.next, struct fw_page, list);
 	n = find_first_bit(&fp->bitmask, 8 * sizeof(fp->bitmask));
 	if (n >= MLX5_NUM_4K_IN_PAGE) {
-		mlx5_core_warn(dev, "alloc 4k bug\n");
+		mlx5_core_warn(dev, "alloc 4k bug: fw page = 0x%llx, n = %u, bitmask: %lu, max num of 4K pages: %d\n",
+			       fp->addr, n, fp->bitmask,  MLX5_NUM_4K_IN_PAGE);
 		return -ENOENT;
 	}
 	clear_bit(n, &fp->bitmask);
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 6d69cf69fd86..6331c98088e0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -394,7 +394,7 @@ static void ath9k_htc_fw_panic_report(struct htc_target *htc_handle,
  * HTC Messages are handled directly here and the obtained SKB
  * is freed.
  *
- * Service messages (Data, WMI) passed to the corresponding
+ * Service messages (Data, WMI) are passed to the corresponding
  * endpoint RX handlers, which have to free the SKB.
  */
 void ath9k_htc_rx_msg(struct htc_target *htc_handle,
@@ -481,6 +481,8 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 		if (endpoint->ep_callbacks.rx)
 			endpoint->ep_callbacks.rx(endpoint->ep_callbacks.priv,
 						  skb, epid);
+		else
+			goto invalid;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 4b68804f3742..9a17f7a07b1e 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -337,6 +337,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	if (!time_left) {
 		ath_dbg(common, WMI, "Timeout waiting for WMI command: %s\n",
 			wmi_cmd_to_name(cmd_id));
+		wmi->last_seq_id = 0;
 		mutex_unlock(&wmi->op_mutex);
 		kfree_skb(skb);
 		return -ETIMEDOUT;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index 7a2b49587b4d..b2f46685391c 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -157,6 +157,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 			  err);
 		goto done;
 	}
+	buf[sizeof(buf) - 1] = '\0';
 	ptr = (char *)buf;
 	strsep(&ptr, "\n");
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 9c8102be1d0b..55027886f404 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -226,6 +226,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 			brcmf_err("%s: failed to expand headroom\n",
 				  brcmf_ifname(ifp));
 			atomic_inc(&drvr->bus_if->stats.pktcow_failed);
+			dev_kfree_skb(skb);
 			goto done;
 		}
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 5f0af5fac343..19dad0a72753 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -337,8 +337,11 @@ brcmf_msgbuf_alloc_pktid(struct device *dev,
 		count++;
 	} while (count < pktids->array_size);
 
-	if (count == pktids->array_size)
+	if (count == pktids->array_size) {
+		dma_unmap_single(dev, *physaddr, skb->len - data_offset,
+				 pktids->direction);
 		return -ENOMEM;
+	}
 
 	array[*idx].data_offset = data_offset;
 	array[*idx].physaddr = *physaddr;
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index 2d0734ab3f74..3c447d6f84af 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -11437,9 +11437,14 @@ static int ipw_wdev_init(struct net_device *dev)
 	set_wiphy_dev(wdev->wiphy, &priv->pci_dev->dev);
 
 	/* With that information in place, we can now register the wiphy... */
-	if (wiphy_register(wdev->wiphy))
-		rc = -EIO;
+	rc = wiphy_register(wdev->wiphy);
+	if (rc)
+		goto out;
+
+	return 0;
 out:
+	kfree(priv->ieee->a_band.channels);
+	kfree(priv->ieee->bg_band.channels);
 	return rc;
 }
 
diff --git a/drivers/net/wireless/intersil/orinoco/hw.c b/drivers/net/wireless/intersil/orinoco/hw.c
index 61af5a28f269..af49aa421e47 100644
--- a/drivers/net/wireless/intersil/orinoco/hw.c
+++ b/drivers/net/wireless/intersil/orinoco/hw.c
@@ -931,6 +931,8 @@ int __orinoco_hw_setup_enc(struct orinoco_private *priv)
 			err = hermes_write_wordrec(hw, USER_BAP,
 					HERMES_RID_CNFAUTHENTICATION_AGERE,
 					auth_flag);
+			if (err)
+				return err;
 		}
 		err = hermes_write_wordrec(hw, USER_BAP,
 					   HERMES_RID_CNFWEPENABLED_AGERE,
diff --git a/drivers/net/wireless/marvell/libertas/cmdresp.c b/drivers/net/wireless/marvell/libertas/cmdresp.c
index b73d08381398..5908f07d62ed 100644
--- a/drivers/net/wireless/marvell/libertas/cmdresp.c
+++ b/drivers/net/wireless/marvell/libertas/cmdresp.c
@@ -48,7 +48,7 @@ void lbs_mac_event_disconnected(struct lbs_private *priv,
 
 	/* Free Tx and Rx packets */
 	spin_lock_irqsave(&priv->driver_lock, flags);
-	kfree_skb(priv->currenttxskb);
+	dev_kfree_skb_irq(priv->currenttxskb);
 	priv->currenttxskb = NULL;
 	priv->tx_pending_len = 0;
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
diff --git a/drivers/net/wireless/marvell/libertas/main.c b/drivers/net/wireless/marvell/libertas/main.c
index aefa88f4f29c..21816f0e9e93 100644
--- a/drivers/net/wireless/marvell/libertas/main.c
+++ b/drivers/net/wireless/marvell/libertas/main.c
@@ -216,7 +216,7 @@ int lbs_stop_iface(struct lbs_private *priv)
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	priv->iface_running = false;
-	kfree_skb(priv->currenttxskb);
+	dev_kfree_skb_irq(priv->currenttxskb);
 	priv->currenttxskb = NULL;
 	priv->tx_pending_len = 0;
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
@@ -872,6 +872,7 @@ static int lbs_init_adapter(struct lbs_private *priv)
 	ret = kfifo_alloc(&priv->event_fifo, sizeof(u32) * 16, GFP_KERNEL);
 	if (ret) {
 		pr_err("Out of memory allocating event FIFO buffer\n");
+		lbs_free_cmd_buffer(priv);
 		goto out;
 	}
 
diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index 2844f937cc65..1e4921d9061d 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -878,7 +878,7 @@ mwifiex_send_delba_txbastream_tbl(struct mwifiex_private *priv, u8 tid)
  */
 void mwifiex_update_ampdu_txwinsize(struct mwifiex_adapter *adapter)
 {
-	u8 i;
+	u8 i, j;
 	u32 tx_win_size;
 	struct mwifiex_private *priv;
 
@@ -909,8 +909,8 @@ void mwifiex_update_ampdu_txwinsize(struct mwifiex_adapter *adapter)
 		if (tx_win_size != priv->add_ba_param.tx_win_size) {
 			if (!priv->media_connected)
 				continue;
-			for (i = 0; i < MAX_NUM_TID; i++)
-				mwifiex_send_delba_txbastream_tbl(priv, i);
+			for (j = 0; j < MAX_NUM_TID; j++)
+				mwifiex_send_delba_txbastream_tbl(priv, j);
 		}
 	}
 }
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index 80fee699f58a..e202b67832e9 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1629,6 +1629,11 @@ static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
 	val8 = rtl8xxxu_read8(priv, REG_PAD_CTRL1);
 	val8 &= ~BIT(0);
 	rtl8xxxu_write8(priv, REG_PAD_CTRL1, val8);
+
+	/*
+	 * Fix transmission failure of rtl8192e.
+	 */
+	rtl8xxxu_write8(priv, REG_TXPAUSE, 0x00);
 }
 
 struct rtl8xxxu_fileops rtl8192eu_fops = {
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index f7c879a7a1be..1c9f7e1f63cf 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5101,7 +5101,7 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 		pending = priv->rx_urb_pending_count;
 	} else {
 		skb = (struct sk_buff *)rx_urb->urb.context;
-		dev_kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 		usb_free_urb(&rx_urb->urb);
 	}
 
@@ -5500,7 +5500,6 @@ static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct device *dev = &priv->udev->dev;
-	u16 val16;
 	int ret = 0, channel;
 	bool ht40;
 
@@ -5510,14 +5509,6 @@ static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
 			 __func__, hw->conf.chandef.chan->hw_value,
 			 changed, hw->conf.chandef.width);
 
-	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
-		val16 = ((hw->conf.long_frame_max_tx_count <<
-			  RETRY_LIMIT_LONG_SHIFT) & RETRY_LIMIT_LONG_MASK) |
-			((hw->conf.short_frame_max_tx_count <<
-			  RETRY_LIMIT_SHORT_SHIFT) & RETRY_LIMIT_SHORT_MASK);
-		rtl8xxxu_write16(priv, REG_RETRY_LIMIT, val16);
-	}
-
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		switch (hw->conf.chandef.width) {
 		case NL80211_CHAN_WIDTH_20_NOHT:
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index f33ece937047..cfde9b94b4b6 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1329,7 +1329,7 @@ static netdev_tx_t wl3501_hard_start_xmit(struct sk_buff *skb,
 	} else {
 		++dev->stats.tx_packets;
 		dev->stats.tx_bytes += skb->len;
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 
 		if (this->tx_buffer_cnt < 2)
 			netif_stop_queue(dev);
diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index b1d23b35aac4..c0fbd88651b1 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -676,6 +676,12 @@ int st_nci_se_io(struct nci_dev *ndev, u32 se_idx,
 					ST_NCI_EVT_TRANSMIT_DATA, apdu,
 					apdu_length);
 	default:
+		/* Need to free cb_context here as at the moment we can't
+		 * clearly indicate to the caller if the callback function
+		 * would be called (and free it) or not. In both cases a
+		 * negative value may be returned to the caller.
+		 */
+		kfree(cb_context);
 		return -ENODEV;
 	}
 }
diff --git a/drivers/nfc/st21nfca/se.c b/drivers/nfc/st21nfca/se.c
index 21ab3e678cf3..7946a2ee7bff 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -247,6 +247,12 @@ int st21nfca_hci_se_io(struct nfc_hci_dev *hdev, u32 se_idx,
 					ST21NFCA_EVT_TRANSMIT_DATA,
 					apdu, apdu_length);
 	default:
+		/* Need to free cb_context here as at the moment we can't
+		 * clearly indicate to the caller if the callback function
+		 * would be called (and free it) or not. In both cases a
+		 * negative value may be returned to the caller.
+		 */
+		kfree(cb_context);
 		return -ENODEV;
 	}
 }
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 0a116359b5c7..b9fedf9c77cb 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5064,6 +5064,7 @@ static void quirk_no_flr(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1487, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x148c, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x7901, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
 
diff --git a/drivers/phy/rockchip/phy-rockchip-typec.c b/drivers/phy/rockchip/phy-rockchip-typec.c
index a958c9bced01..6e3916424012 100644
--- a/drivers/phy/rockchip/phy-rockchip-typec.c
+++ b/drivers/phy/rockchip/phy-rockchip-typec.c
@@ -645,9 +645,8 @@ static int tcphy_get_mode(struct rockchip_typec_phy *tcphy)
 	struct extcon_dev *edev = tcphy->extcon;
 	union extcon_property_value property;
 	unsigned int id;
-	bool ufp, dp;
 	u8 mode;
-	int ret;
+	int ret, ufp, dp;
 
 	ufp = extcon_get_state(edev, EXTCON_USB);
 	dp = extcon_get_state(edev, EXTCON_DISP_DP);
diff --git a/drivers/pinctrl/pinctrl-at91-pio4.c b/drivers/pinctrl/pinctrl-at91-pio4.c
index e9d797707255..78aeb882f1ca 100644
--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -981,8 +981,8 @@ static int atmel_pinctrl_probe(struct platform_device *pdev)
 
 		pin_desc[i].number = i;
 		/* Pin naming convention: P(bank_name)(bank_pin_number). */
-		pin_desc[i].name = kasprintf(GFP_KERNEL, "P%c%d",
-					     bank + 'A', line);
+		pin_desc[i].name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "P%c%d",
+						  bank + 'A', line);
 
 		group->name = group_names[i] = pin_desc[i].name;
 		group->pin = pin_desc[i].number;
diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 404711f0985a..3173e1f5bcb6 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1774,7 +1774,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < chip->ngpio; i++)
-		names[i] = kasprintf(GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
+		names[i] = devm_kasprintf(&pdev->dev, GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
 
 	chip->names = (const char *const *)names;
 
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 0c237dd13f2f..1f4b9fc9e278 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2320,6 +2320,7 @@ static int rockchip_pinctrl_parse_groups(struct device_node *np,
 		np_config = of_find_node_by_phandle(be32_to_cpup(phandle));
 		ret = pinconf_generic_parse_dt_config(np_config, NULL,
 				&grp->data[j].configs, &grp->data[j].nconfigs);
+		of_node_put(np_config);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/pwm/pwm-stm32-lp.c b/drivers/pwm/pwm-stm32-lp.c
index 3f2e4ef695d7..ba0aa3b8076b 100644
--- a/drivers/pwm/pwm-stm32-lp.c
+++ b/drivers/pwm/pwm-stm32-lp.c
@@ -127,7 +127,7 @@ static int stm32_pwm_lp_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 	/* ensure CMP & ARR registers are properly written */
 	ret = regmap_read_poll_timeout(priv->regmap, STM32_LPTIM_ISR, val,
-				       (val & STM32_LPTIM_CMPOK_ARROK),
+				       (val & STM32_LPTIM_CMPOK_ARROK) == STM32_LPTIM_CMPOK_ARROK,
 				       100, 1000);
 	if (ret) {
 		dev_err(priv->chip.dev, "ARR/CMP registers write issue\n");
diff --git a/drivers/regulator/max77802-regulator.c b/drivers/regulator/max77802-regulator.c
index b6261903818c..e12bab733e18 100644
--- a/drivers/regulator/max77802-regulator.c
+++ b/drivers/regulator/max77802-regulator.c
@@ -107,9 +107,11 @@ static int max77802_set_suspend_disable(struct regulator_dev *rdev)
 {
 	unsigned int val = MAX77802_OFF_PWRREQ;
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 	int shift = max77802_get_opmode_shift(id);
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
 	max77802->opmode[id] = val;
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask, val << shift);
@@ -123,7 +125,7 @@ static int max77802_set_suspend_disable(struct regulator_dev *rdev)
 static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
 {
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 	unsigned int val;
 	int shift = max77802_get_opmode_shift(id);
 
@@ -140,6 +142,9 @@ static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
 		return -EINVAL;
 	}
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
+
 	max77802->opmode[id] = val;
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask, val << shift);
@@ -148,8 +153,10 @@ static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
 static unsigned max77802_get_mode(struct regulator_dev *rdev)
 {
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
 	return max77802_map_mode(max77802->opmode[id]);
 }
 
@@ -173,10 +180,13 @@ static int max77802_set_suspend_mode(struct regulator_dev *rdev,
 				     unsigned int mode)
 {
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 	unsigned int val;
 	int shift = max77802_get_opmode_shift(id);
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
+
 	/*
 	 * If the regulator has been disabled for suspend
 	 * then is invalid to try setting a suspend mode.
@@ -222,9 +232,11 @@ static int max77802_set_suspend_mode(struct regulator_dev *rdev,
 static int max77802_enable(struct regulator_dev *rdev)
 {
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 	int shift = max77802_get_opmode_shift(id);
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
 	if (max77802->opmode[id] == MAX77802_OFF_PWRREQ)
 		max77802->opmode[id] = MAX77802_OPMODE_NORMAL;
 
@@ -553,7 +565,7 @@ static int max77802_pmic_probe(struct platform_device *pdev)
 
 	for (i = 0; i < MAX77802_REG_MAX; i++) {
 		struct regulator_dev *rdev;
-		int id = regulators[i].id;
+		unsigned int id = regulators[i].id;
 		int shift = max77802_get_opmode_shift(id);
 		int ret;
 
@@ -571,10 +583,12 @@ static int max77802_pmic_probe(struct platform_device *pdev)
 		 * the hardware reports OFF as the regulator operating mode.
 		 * Default to operating mode NORMAL in that case.
 		 */
-		if (val == MAX77802_STATUS_OFF)
-			max77802->opmode[id] = MAX77802_OPMODE_NORMAL;
-		else
-			max77802->opmode[id] = val;
+		if (id < ARRAY_SIZE(max77802->opmode)) {
+			if (val == MAX77802_STATUS_OFF)
+				max77802->opmode[id] = MAX77802_OPMODE_NORMAL;
+			else
+				max77802->opmode[id] = val;
+		}
 
 		rdev = devm_regulator_register(&pdev->dev,
 					       &regulators[i], &config);
diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index d558f806a470..80e751759b70 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -918,10 +918,14 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 
 	for (i = 0; i < pdata->num_regulators; i++) {
 		const struct sec_voltage_desc *desc;
-		int id = pdata->regulators[i].id;
+		unsigned int id = pdata->regulators[i].id;
 		int enable_reg, enable_val;
 		struct regulator_dev *rdev;
 
+		BUILD_BUG_ON(ARRAY_SIZE(regulators) != ARRAY_SIZE(reg_voltage_map));
+		if (WARN_ON_ONCE(id >= ARRAY_SIZE(regulators)))
+			continue;
+
 		desc = reg_voltage_map[id];
 		if (desc) {
 			regulators[id].n_voltages =
diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 4c90364638f9..0fb185e0620a 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -928,6 +928,7 @@ static void qcom_glink_handle_intent(struct qcom_glink *glink,
 	spin_unlock_irqrestore(&glink->idr_lock, flags);
 	if (!channel) {
 		dev_err(glink->dev, "intents for non-existing channel\n");
+		qcom_glink_rx_advance(glink, ALIGN(msglen, 8));
 		return;
 	}
 
diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index 3b619b7b2c53..4938227e6c59 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -235,7 +235,6 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	int rc, i;
 	u8 value[NUM_8_BIT_RTC_REGS];
-	unsigned int ctrl_reg;
 	unsigned long secs, irq_flags;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 	const struct pm8xxx_rtc_regs *regs = rtc_dd->regs;
@@ -247,6 +246,11 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 		secs >>= 8;
 	}
 
+	rc = regmap_update_bits(rtc_dd->regmap, regs->alarm_ctrl,
+				regs->alarm_en, 0);
+	if (rc)
+		return rc;
+
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
 
 	rc = regmap_bulk_write(rtc_dd->regmap, regs->alarm_rw, value,
@@ -256,19 +260,11 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 		goto rtc_rw_fail;
 	}
 
-	rc = regmap_read(rtc_dd->regmap, regs->alarm_ctrl, &ctrl_reg);
-	if (rc)
-		goto rtc_rw_fail;
-
-	if (alarm->enabled)
-		ctrl_reg |= regs->alarm_en;
-	else
-		ctrl_reg &= ~regs->alarm_en;
-
-	rc = regmap_write(rtc_dd->regmap, regs->alarm_ctrl, ctrl_reg);
-	if (rc) {
-		dev_err(dev, "Write to RTC alarm control register failed\n");
-		goto rtc_rw_fail;
+	if (alarm->enabled) {
+		rc = regmap_update_bits(rtc_dd->regmap, regs->alarm_ctrl,
+					regs->alarm_en, regs->alarm_en);
+		if (rc)
+			goto rtc_rw_fail;
 	}
 
 	dev_dbg(dev, "Alarm Set for h:r:s=%d:%d:%d, d/m/y=%d/%d/%d\n",
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index cdd4ab683be9..4de4bbca1f92 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -68,6 +68,9 @@ static int asd_map_scatterlist(struct sas_task *task,
 		dma_addr_t dma = pci_map_single(asd_ha->pcidev, p,
 						task->total_xfer_len,
 						task->data_dir);
+		if (dma_mapping_error(&asd_ha->pcidev->dev, dma))
+			return -ENOMEM;
+
 		sg_arr[0].bus_addr = cpu_to_le64((u64)dma);
 		sg_arr[0].size = cpu_to_le32(task->total_xfer_len);
 		sg_arr[0].flags |= ASD_SG_EL_LIST_EOL;
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 86e2d3033a2d..030d26f7d50c 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -1531,23 +1531,22 @@ static void ipr_process_ccn(struct ipr_cmnd *ipr_cmd)
 }
 
 /**
- * strip_and_pad_whitespace - Strip and pad trailing whitespace.
- * @i:		index into buffer
- * @buf:		string to modify
+ * strip_whitespace - Strip and pad trailing whitespace.
+ * @i:		size of buffer
+ * @buf:	string to modify
  *
- * This function will strip all trailing whitespace, pad the end
- * of the string with a single space, and NULL terminate the string.
+ * This function will strip all trailing whitespace and
+ * NUL terminate the string.
  *
- * Return value:
- * 	new length of string
  **/
-static int strip_and_pad_whitespace(int i, char *buf)
+static void strip_whitespace(int i, char *buf)
 {
+	if (i < 1)
+		return;
+	i--;
 	while (i && buf[i] == ' ')
 		i--;
-	buf[i+1] = ' ';
-	buf[i+2] = '\0';
-	return i + 2;
+	buf[i+1] = '\0';
 }
 
 /**
@@ -1562,19 +1561,21 @@ static int strip_and_pad_whitespace(int i, char *buf)
 static void ipr_log_vpd_compact(char *prefix, struct ipr_hostrcb *hostrcb,
 				struct ipr_vpd *vpd)
 {
-	char buffer[IPR_VENDOR_ID_LEN + IPR_PROD_ID_LEN + IPR_SERIAL_NUM_LEN + 3];
-	int i = 0;
+	char vendor_id[IPR_VENDOR_ID_LEN + 1];
+	char product_id[IPR_PROD_ID_LEN + 1];
+	char sn[IPR_SERIAL_NUM_LEN + 1];
 
-	memcpy(buffer, vpd->vpids.vendor_id, IPR_VENDOR_ID_LEN);
-	i = strip_and_pad_whitespace(IPR_VENDOR_ID_LEN - 1, buffer);
+	memcpy(vendor_id, vpd->vpids.vendor_id, IPR_VENDOR_ID_LEN);
+	strip_whitespace(IPR_VENDOR_ID_LEN, vendor_id);
 
-	memcpy(&buffer[i], vpd->vpids.product_id, IPR_PROD_ID_LEN);
-	i = strip_and_pad_whitespace(i + IPR_PROD_ID_LEN - 1, buffer);
+	memcpy(product_id, vpd->vpids.product_id, IPR_PROD_ID_LEN);
+	strip_whitespace(IPR_PROD_ID_LEN, product_id);
 
-	memcpy(&buffer[i], vpd->sn, IPR_SERIAL_NUM_LEN);
-	buffer[IPR_SERIAL_NUM_LEN + i] = '\0';
+	memcpy(sn, vpd->sn, IPR_SERIAL_NUM_LEN);
+	strip_whitespace(IPR_SERIAL_NUM_LEN, sn);
 
-	ipr_hcam_err(hostrcb, "%s VPID/SN: %s\n", prefix, buffer);
+	ipr_hcam_err(hostrcb, "%s VPID/SN: %s %s %s\n", prefix,
+		     vendor_id, product_id, sn);
 }
 
 /**
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index d0f52c123bfb..043e88291667 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -5887,9 +5887,12 @@ qla2x00_do_dpc(void *data)
 			}
 		}
 loop_resync_check:
-		if (test_and_clear_bit(LOOP_RESYNC_NEEDED,
+		if (!qla2x00_reset_active(base_vha) &&
+		    test_and_clear_bit(LOOP_RESYNC_NEEDED,
 		    &base_vha->dpc_flags)) {
-
+			/*
+			 * Allow abort_isp to complete before moving on to scanning.
+			 */
 			ql_dbg(ql_dbg_dpc, base_vha, 0x400f,
 			    "Loop resync scheduled.\n");
 
@@ -6116,7 +6119,7 @@ qla2x00_timer(scsi_qla_host_t *vha)
 
 		/* if the loop has been down for 4 minutes, reinit adapter */
 		if (atomic_dec_and_test(&vha->loop_down_timer) != 0) {
-			if (!(vha->device_flags & DFLG_NO_CABLE)) {
+			if (!(vha->device_flags & DFLG_NO_CABLE) && !vha->vp_idx) {
 				ql_log(ql_log_warn, vha, 0x6009,
 				    "Loop down - aborting ISP.\n");
 
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 84b234bbd07d..70ae5247c9f7 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -449,8 +449,8 @@ int ses_match_host(struct enclosure_device *edev, void *data)
 }
 #endif  /*  0  */
 
-static void ses_process_descriptor(struct enclosure_component *ecomp,
-				   unsigned char *desc)
+static int ses_process_descriptor(struct enclosure_component *ecomp,
+				   unsigned char *desc, int max_desc_len)
 {
 	int eip = desc[0] & 0x10;
 	int invalid = desc[0] & 0x80;
@@ -461,22 +461,32 @@ static void ses_process_descriptor(struct enclosure_component *ecomp,
 	unsigned char *d;
 
 	if (invalid)
-		return;
+		return 0;
 
 	switch (proto) {
 	case SCSI_PROTOCOL_FCP:
 		if (eip) {
+			if (max_desc_len <= 7)
+				return 1;
 			d = desc + 4;
 			slot = d[3];
 		}
 		break;
 	case SCSI_PROTOCOL_SAS:
+
 		if (eip) {
+			if (max_desc_len <= 27)
+				return 1;
 			d = desc + 4;
 			slot = d[3];
 			d = desc + 8;
-		} else
+		} else {
+			if (max_desc_len <= 23)
+				return 1;
 			d = desc + 4;
+		}
+
+
 		/* only take the phy0 addr */
 		addr = (u64)d[12] << 56 |
 			(u64)d[13] << 48 |
@@ -493,6 +503,8 @@ static void ses_process_descriptor(struct enclosure_component *ecomp,
 	}
 	ecomp->slot = slot;
 	scomp->addr = addr;
+
+	return 0;
 }
 
 struct efd {
@@ -565,7 +577,7 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 		/* skip past overall descriptor */
 		desc_ptr += len + 4;
 	}
-	if (ses_dev->page10)
+	if (ses_dev->page10 && ses_dev->page10_len > 9)
 		addl_desc_ptr = ses_dev->page10 + 8;
 	type_ptr = ses_dev->page1_types;
 	components = 0;
@@ -573,17 +585,22 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 		for (j = 0; j < type_ptr[1]; j++) {
 			char *name = NULL;
 			struct enclosure_component *ecomp;
+			int max_desc_len;
 
 			if (desc_ptr) {
-				if (desc_ptr >= buf + page7_len) {
+				if (desc_ptr + 3 >= buf + page7_len) {
 					desc_ptr = NULL;
 				} else {
 					len = (desc_ptr[2] << 8) + desc_ptr[3];
 					desc_ptr += 4;
-					/* Add trailing zero - pushes into
-					 * reserved space */
-					desc_ptr[len] = '\0';
-					name = desc_ptr;
+					if (desc_ptr + len > buf + page7_len)
+						desc_ptr = NULL;
+					else {
+						/* Add trailing zero - pushes into
+						 * reserved space */
+						desc_ptr[len] = '\0';
+						name = desc_ptr;
+					}
 				}
 			}
 			if (type_ptr[0] == ENCLOSURE_COMPONENT_DEVICE ||
@@ -599,10 +616,14 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 					ecomp = &edev->component[components++];
 
 				if (!IS_ERR(ecomp)) {
-					if (addl_desc_ptr)
-						ses_process_descriptor(
-							ecomp,
-							addl_desc_ptr);
+					if (addl_desc_ptr) {
+						max_desc_len = ses_dev->page10_len -
+						    (addl_desc_ptr - ses_dev->page10);
+						if (ses_process_descriptor(ecomp,
+						    addl_desc_ptr,
+						    max_desc_len))
+							addl_desc_ptr = NULL;
+					}
 					if (create)
 						enclosure_component_register(
 							ecomp);
@@ -619,9 +640,11 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 			     /* these elements are optional */
 			     type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_TARGET_PORT ||
 			     type_ptr[0] == ENCLOSURE_COMPONENT_SCSI_INITIATOR_PORT ||
-			     type_ptr[0] == ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS))
+			     type_ptr[0] == ENCLOSURE_COMPONENT_CONTROLLER_ELECTRONICS)) {
 				addl_desc_ptr += addl_desc_ptr[1] + 2;
-
+				if (addl_desc_ptr + 1 >= ses_dev->page10 + ses_dev->page10_len)
+					addl_desc_ptr = NULL;
+			}
 		}
 	}
 	kfree(buf);
@@ -720,6 +743,12 @@ static int ses_intf_add(struct device *cdev,
 		    type_ptr[0] == ENCLOSURE_COMPONENT_ARRAY_DEVICE)
 			components += type_ptr[1];
 	}
+
+	if (components == 0) {
+		sdev_printk(KERN_WARNING, sdev, "enclosure has no enumerated components\n");
+		goto err_free;
+	}
+
 	ses_dev->page1 = buf;
 	ses_dev->page1_len = len;
 	buf = NULL;
@@ -843,7 +872,8 @@ static void ses_intf_remove_enclosure(struct scsi_device *sdev)
 	kfree(ses_dev->page2);
 	kfree(ses_dev);
 
-	kfree(edev->component[0].scratch);
+	if (edev->components)
+		kfree(edev->component[0].scratch);
 
 	put_device(&edev->edev);
 	enclosure_unregister(edev);
diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index cbcba614b253..d2c23d5797c4 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -160,6 +160,7 @@ static int bcm63xx_hsspi_do_txrx(struct spi_device *spi, struct spi_transfer *t)
 	int step_size = HSSPI_BUFFER_LEN;
 	const u8 *tx = t->tx_buf;
 	u8 *rx = t->rx_buf;
+	u32 val = 0;
 
 	bcm63xx_hsspi_set_clk(bs, spi, t->speed_hz);
 	bcm63xx_hsspi_set_cs(bs, spi->chip_select, true);
@@ -175,11 +176,16 @@ static int bcm63xx_hsspi_do_txrx(struct spi_device *spi, struct spi_transfer *t)
 		step_size -= HSSPI_OPCODE_LEN;
 
 	if ((opcode == HSSPI_OP_READ && t->rx_nbits == SPI_NBITS_DUAL) ||
-	    (opcode == HSSPI_OP_WRITE && t->tx_nbits == SPI_NBITS_DUAL))
+	    (opcode == HSSPI_OP_WRITE && t->tx_nbits == SPI_NBITS_DUAL)) {
 		opcode |= HSSPI_OP_MULTIBIT;
 
-	__raw_writel(1 << MODE_CTRL_MULTIDATA_WR_SIZE_SHIFT |
-		     1 << MODE_CTRL_MULTIDATA_RD_SIZE_SHIFT | 0xff,
+		if (t->rx_nbits == SPI_NBITS_DUAL)
+			val |= 1 << MODE_CTRL_MULTIDATA_RD_SIZE_SHIFT;
+		if (t->tx_nbits == SPI_NBITS_DUAL)
+			val |= 1 << MODE_CTRL_MULTIDATA_WR_SIZE_SHIFT;
+	}
+
+	__raw_writel(val | 0xff,
 		     bs->regs + HSSPI_PROFILE_MODE_CTRL_REG(chip_select));
 
 	while (pending > 0) {
diff --git a/drivers/thermal/intel_powerclamp.c b/drivers/thermal/intel_powerclamp.c
index 68cc88637e06..1f79eca3754e 100644
--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -72,6 +72,7 @@
 
 static unsigned int target_mwait;
 static struct dentry *debug_dir;
+static bool poll_pkg_cstate_enable;
 
 /* user selected target */
 static unsigned int set_target_ratio;
@@ -280,6 +281,9 @@ static unsigned int get_compensation(int ratio)
 {
 	unsigned int comp = 0;
 
+	if (!poll_pkg_cstate_enable)
+		return 0;
+
 	/* we only use compensation if all adjacent ones are good */
 	if (ratio == 1 &&
 		cal_data[ratio].confidence >= CONFIDENCE_OK &&
@@ -552,7 +556,8 @@ static int start_power_clamp(void)
 	control_cpu = cpumask_first(cpu_online_mask);
 
 	clamping = true;
-	schedule_delayed_work(&poll_pkg_cstate_work, 0);
+	if (poll_pkg_cstate_enable)
+		schedule_delayed_work(&poll_pkg_cstate_work, 0);
 
 	/* start one kthread worker per online cpu */
 	for_each_online_cpu(cpu) {
@@ -621,11 +626,15 @@ static int powerclamp_get_max_state(struct thermal_cooling_device *cdev,
 static int powerclamp_get_cur_state(struct thermal_cooling_device *cdev,
 				 unsigned long *state)
 {
-	if (true == clamping)
-		*state = pkg_cstate_ratio_cur;
-	else
+	if (clamping) {
+		if (poll_pkg_cstate_enable)
+			*state = pkg_cstate_ratio_cur;
+		else
+			*state = set_target_ratio;
+	} else {
 		/* to save power, do not poll idle ratio while not clamping */
 		*state = -1; /* indicates invalid state */
+	}
 
 	return 0;
 }
@@ -770,6 +779,9 @@ static int __init powerclamp_init(void)
 		goto exit_unregister;
 	}
 
+	if (topology_max_packages() == 1)
+		poll_pkg_cstate_enable = true;
+
 	cooling_dev = thermal_cooling_device_register("intel_powerclamp", NULL,
 						&powerclamp_cooling_ops);
 	if (IS_ERR(cooling_dev)) {
diff --git a/drivers/thermal/intel_quark_dts_thermal.c b/drivers/thermal/intel_quark_dts_thermal.c
index 5d33b350da1c..ad92d8f0add1 100644
--- a/drivers/thermal/intel_quark_dts_thermal.c
+++ b/drivers/thermal/intel_quark_dts_thermal.c
@@ -440,22 +440,14 @@ MODULE_DEVICE_TABLE(x86cpu, qrk_thermal_ids);
 
 static int __init intel_quark_thermal_init(void)
 {
-	int err = 0;
-
 	if (!x86_match_cpu(qrk_thermal_ids) || !iosf_mbi_available())
 		return -ENODEV;
 
 	soc_dts = alloc_soc_dts();
-	if (IS_ERR(soc_dts)) {
-		err = PTR_ERR(soc_dts);
-		goto err_free;
-	}
+	if (IS_ERR(soc_dts))
+		return PTR_ERR(soc_dts);
 
 	return 0;
-
-err_free:
-	free_soc_dts(soc_dts);
-	return err;
 }
 
 static void __exit intel_quark_thermal_exit(void)
diff --git a/drivers/thermal/intel_soc_dts_iosf.c b/drivers/thermal/intel_soc_dts_iosf.c
index e0813dfaa278..435a09399800 100644
--- a/drivers/thermal/intel_soc_dts_iosf.c
+++ b/drivers/thermal/intel_soc_dts_iosf.c
@@ -405,7 +405,7 @@ struct intel_soc_dts_sensors *intel_soc_dts_iosf_init(
 {
 	struct intel_soc_dts_sensors *sensors;
 	bool notification;
-	u32 tj_max;
+	int tj_max;
 	int ret;
 	int i;
 
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index cbbdb94592ce..20dd476e4d1a 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1199,12 +1199,32 @@ static void lpuart_break_ctl(struct uart_port *port, int break_state)
 
 static void lpuart32_break_ctl(struct uart_port *port, int break_state)
 {
-	unsigned long temp;
+	unsigned long temp, modem;
+	struct tty_struct *tty;
+	unsigned int cflag = 0;
+
+	tty = tty_port_tty_get(&port->state->port);
+	if (tty) {
+		cflag = tty->termios.c_cflag;
+		tty_kref_put(tty);
+	}
 
 	temp = lpuart32_read(port, UARTCTRL) & ~UARTCTRL_SBK;
+	modem = lpuart32_read(port, UARTMODIR);
 
-	if (break_state != 0)
+	if (break_state != 0) {
 		temp |= UARTCTRL_SBK;
+		/*
+		 * LPUART CTS has higher priority than SBK, need to disable CTS before
+		 * asserting SBK to avoid any interference if flow control is enabled.
+		 */
+		if (cflag & CRTSCTS && modem & UARTMODIR_TXCTSE)
+			lpuart32_write(port, modem & ~UARTMODIR_TXCTSE, UARTMODIR);
+	} else {
+		/* Re-enable the CTS when break off. */
+		if (cflag & CRTSCTS && !(modem & UARTMODIR_TXCTSE))
+			lpuart32_write(port, modem | UARTMODIR_TXCTSE, UARTMODIR);
+	}
 
 	lpuart32_write(port, temp, UARTCTRL);
 }
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 463f35273365..8cbd6fa6351f 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1154,14 +1154,16 @@ static struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
 {
 	struct tty_struct *tty;
 
-	if (driver->ops->lookup)
+	if (driver->ops->lookup) {
 		if (!file)
 			tty = ERR_PTR(-EIO);
 		else
 			tty = driver->ops->lookup(driver, file, idx);
-	else
+	} else {
+		if (idx >= driver->num)
+			return ERR_PTR(-EINVAL);
 		tty = driver->ttys[idx];
-
+	}
 	if (!IS_ERR(tty))
 		tty_kref_get(tty);
 	return tty;
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 8a33f1a2b82a..213ce28395d4 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2322,9 +2322,8 @@ static int usb_enumerate_device_otg(struct usb_device *udev)
  * usb_enumerate_device - Read device configs/intfs/otg (usbcore-internal)
  * @udev: newly addressed device (in ADDRESS state)
  *
- * This is only called by usb_new_device() and usb_authorize_device()
- * and FIXME -- all comments that apply to them apply here wrt to
- * environment.
+ * This is only called by usb_new_device() -- all comments that apply there
+ * apply here wrt to environment.
  *
  * If the device is WUSB and not authorized, we don't attempt to read
  * the string descriptors, as they will be errored out by the device
diff --git a/drivers/usb/core/sysfs.c b/drivers/usb/core/sysfs.c
index e97834c35092..15c19863f7b3 100644
--- a/drivers/usb/core/sysfs.c
+++ b/drivers/usb/core/sysfs.c
@@ -865,11 +865,7 @@ read_descriptors(struct file *filp, struct kobject *kobj,
 	size_t srclen, n;
 	int cfgno;
 	void *src;
-	int retval;
 
-	retval = usb_lock_device_interruptible(udev);
-	if (retval < 0)
-		return -EINTR;
 	/* The binary attribute begins with the device descriptor.
 	 * Following that are the raw descriptor entries for all the
 	 * configurations (config plus subsidiary descriptors).
@@ -894,7 +890,6 @@ read_descriptors(struct file *filp, struct kobject *kobj,
 			off -= srclen;
 		}
 	}
-	usb_unlock_device(udev);
 	return count - nleft;
 }
 
diff --git a/drivers/usb/host/xhci-mvebu.c b/drivers/usb/host/xhci-mvebu.c
index 85908a3ecb8f..285a5f75fe04 100644
--- a/drivers/usb/host/xhci-mvebu.c
+++ b/drivers/usb/host/xhci-mvebu.c
@@ -34,7 +34,7 @@ static void xhci_mvebu_mbus_config(void __iomem *base,
 
 	/* Program each DRAM CS in a seperate window */
 	for (win = 0; win < dram->num_cs; win++) {
-		const struct mbus_dram_window *cs = dram->cs + win;
+		const struct mbus_dram_window *cs = &dram->cs[win];
 
 		writel(((cs->size - 1) & 0xffff0000) | (cs->mbus_attr << 8) |
 		       (dram->mbus_dram_target_id << 4) | 1,
diff --git a/drivers/usb/serial/option.c b/drivers/usb/serial/option.c
index 5bc4ce5313c7..031832a77c68 100644
--- a/drivers/usb/serial/option.c
+++ b/drivers/usb/serial/option.c
@@ -405,6 +405,8 @@ static void option_instat_callback(struct urb *urb);
 #define LONGCHEER_VENDOR_ID			0x1c9e
 
 /* 4G Systems products */
+/* This one was sold as the VW and Skoda "Carstick LTE" */
+#define FOUR_G_SYSTEMS_PRODUCT_CARSTICK_LTE	0x7605
 /* This is the 4G XS Stick W14 a.k.a. Mobilcom Debitel Surf-Stick *
  * It seems to contain a Qualcomm QSC6240/6290 chipset            */
 #define FOUR_G_SYSTEMS_PRODUCT_W14		0x9603
@@ -1979,6 +1981,8 @@ static const struct usb_device_id option_ids[] = {
 	  .driver_info = RSVD(2) },
 	{ USB_DEVICE(AIRPLUS_VENDOR_ID, AIRPLUS_PRODUCT_MCD650) },
 	{ USB_DEVICE(TLAYTECH_VENDOR_ID, TLAYTECH_PRODUCT_TEU800) },
+	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_CARSTICK_LTE),
+	  .driver_info = RSVD(0) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W14),
 	  .driver_info = NCTRL(0) | NCTRL(1) },
 	{ USB_DEVICE(LONGCHEER_VENDOR_ID, FOUR_G_SYSTEMS_PRODUCT_W100),
diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 79f77179fd9b..08b946d27277 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -948,7 +948,7 @@ static int ms_lib_process_bootblock(struct us_data *us, u16 PhyBlock, u8 *PageDa
 	struct ms_lib_type_extdat ExtraData;
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
 
-	PageBuffer = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL);
+	PageBuffer = kzalloc(MS_BYTES_PER_PAGE * 2, GFP_KERNEL);
 	if (PageBuffer == NULL)
 		return (u32)-1;
 
diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 7e6acaf3ece4..f3d8ae8df7f6 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -209,10 +209,9 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
 			 "min heartbeat and max heartbeat might be too close for the system to handle it correctly\n");
 
 	if ((tmp & AT91_WDT_WDFIEN) && wdt->irq) {
-		err = request_irq(wdt->irq, wdt_interrupt,
-				  IRQF_SHARED | IRQF_IRQPOLL |
-				  IRQF_NO_SUSPEND,
-				  pdev->name, wdt);
+		err = devm_request_irq(dev, wdt->irq, wdt_interrupt,
+				       IRQF_SHARED | IRQF_IRQPOLL | IRQF_NO_SUSPEND,
+				       pdev->name, wdt);
 		if (err)
 			return err;
 	}
diff --git a/drivers/watchdog/pcwd_usb.c b/drivers/watchdog/pcwd_usb.c
index b9e376c8e2e3..277ecfdf09c0 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -330,7 +330,8 @@ static int usb_pcwd_set_heartbeat(struct usb_pcwd_private *usb_pcwd, int t)
 static int usb_pcwd_get_temperature(struct usb_pcwd_private *usb_pcwd,
 							int *temperature)
 {
-	unsigned char msb, lsb;
+	unsigned char msb = 0x00;
+	unsigned char lsb = 0x00;
 
 	usb_pcwd_send_command(usb_pcwd, CMD_READ_TEMP, &msb, &lsb);
 
@@ -346,7 +347,8 @@ static int usb_pcwd_get_temperature(struct usb_pcwd_private *usb_pcwd,
 static int usb_pcwd_get_timeleft(struct usb_pcwd_private *usb_pcwd,
 								int *time_left)
 {
-	unsigned char msb, lsb;
+	unsigned char msb = 0x00;
+	unsigned char lsb = 0x00;
 
 	/* Read the time that's left before rebooting */
 	/* Note: if the board is not yet armed then we will read 0xFFFF */
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 21c3ffdc8a09..337ca3690d62 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -965,8 +965,8 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 		if (wdd->id == 0) {
 			misc_deregister(&watchdog_miscdev);
 			old_wd_data = NULL;
-			put_device(&wd_data->dev);
 		}
+		put_device(&wd_data->dev);
 		return err;
 	}
 
diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index efab9446eac8..b08e7fcd8c34 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -6646,10 +6646,10 @@ long btrfs_ioctl_send(struct file *mnt_file, void __user *arg_)
 	/*
 	 * Check that we don't overflow at later allocations, we request
 	 * clone_sources_count + 1 items, and compare to unsigned long inside
-	 * access_ok.
+	 * access_ok. Also set an upper limit for allocation size so this can't
+	 * easily exhaust memory. Max number of clone sources is about 200K.
 	 */
-	if (arg->clone_sources_count >
-	    ULONG_MAX / sizeof(struct clone_root) - 1) {
+	if (arg->clone_sources_count > SZ_8M / sizeof(struct clone_root)) {
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 8a3f0e20c51e..d18901690319 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1426,6 +1426,13 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
 	uid_t owner[2] = { i_uid_read(inode), i_gid_read(inode) };
 	int err;
 
+	if (inode->i_sb->s_root == NULL) {
+		ext4_warning(inode->i_sb,
+			     "refuse to create EA inode when umounting");
+		WARN_ON(1);
+		return ERR_PTR(-EINVAL);
+	}
+
 	/*
 	 * Let the next inode be the goal, so we try and allocate the EA inode
 	 * in the same group, or nearby one.
@@ -2569,9 +2576,8 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 
 	is = kzalloc(sizeof(struct ext4_xattr_ibody_find), GFP_NOFS);
 	bs = kzalloc(sizeof(struct ext4_xattr_block_find), GFP_NOFS);
-	buffer = kvmalloc(value_size, GFP_NOFS);
 	b_entry_name = kmalloc(entry->e_name_len + 1, GFP_NOFS);
-	if (!is || !bs || !buffer || !b_entry_name) {
+	if (!is || !bs || !b_entry_name) {
 		error = -ENOMEM;
 		goto out;
 	}
@@ -2583,12 +2589,18 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 
 	/* Save the entry name and the entry value */
 	if (entry->e_value_inum) {
+		buffer = kvmalloc(value_size, GFP_NOFS);
+		if (!buffer) {
+			error = -ENOMEM;
+			goto out;
+		}
+
 		error = ext4_xattr_inode_get(inode, entry, buffer, value_size);
 		if (error)
 			goto out;
 	} else {
 		size_t value_offs = le16_to_cpu(entry->e_value_offs);
-		memcpy(buffer, (void *)IFIRST(header) + value_offs, value_size);
+		buffer = (void *)IFIRST(header) + value_offs;
 	}
 
 	memcpy(b_entry_name, entry->e_name, entry->e_name_len);
@@ -2603,25 +2615,26 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 	if (error)
 		goto out;
 
-	/* Remove the chosen entry from the inode */
-	error = ext4_xattr_ibody_set(handle, inode, &i, is);
-	if (error)
-		goto out;
-
 	i.value = buffer;
 	i.value_len = value_size;
 	error = ext4_xattr_block_find(inode, &i, bs);
 	if (error)
 		goto out;
 
-	/* Add entry which was removed from the inode into the block */
+	/* Move ea entry from the inode into the block */
 	error = ext4_xattr_block_set(handle, inode, &i, bs);
 	if (error)
 		goto out;
-	error = 0;
+
+	/* Remove the chosen entry from the inode */
+	i.value = NULL;
+	i.value_len = 0;
+	error = ext4_xattr_ibody_set(handle, inode, &i, is);
+
 out:
 	kfree(b_entry_name);
-	kvfree(buffer);
+	if (entry->e_value_inum && buffer)
+		kvfree(buffer);
 	if (is)
 		brelse(is->iloc.bh);
 	if (bs)
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index 74bc861bab39..2952d0e36cd9 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -392,18 +392,17 @@ static int f2fs_move_inline_dirents(struct inode *dir, struct page *ipage,
 
 	dentry_blk = kmap_atomic(page);
 
+	/*
+	 * Start by zeroing the full block, to ensure that all unused space is
+	 * zeroed and no uninitialized memory is leaked to disk.
+	 */
+	memset(dentry_blk, 0, F2FS_BLKSIZE);
+
 	make_dentry_ptr_inline(dir, &src, inline_dentry);
 	make_dentry_ptr_block(dir, &dst, dentry_blk);
 
 	/* copy data from inline dentry block to new dentry block */
 	memcpy(dst.bitmap, src.bitmap, src.nr_bitmap);
-	memset(dst.bitmap + src.nr_bitmap, 0, dst.nr_bitmap - src.nr_bitmap);
-	/*
-	 * we do not need to zero out remainder part of dentry and filename
-	 * field, since we have used bitmap for marking the usage status of
-	 * them, besides, we can also ignore copying/zeroing reserved space
-	 * of dentry block, because them haven't been used so far.
-	 */
 	memcpy(dst.dentry, src.dentry, SIZE_OF_DIR_ENTRY * src.max);
 	memcpy(dst.filename, src.filename, src.max * F2FS_SLOT_LEN);
 
diff --git a/fs/hfs/bnode.c b/fs/hfs/bnode.c
index bca3ea4137ee..5210bde4a0fa 100644
--- a/fs/hfs/bnode.c
+++ b/fs/hfs/bnode.c
@@ -285,6 +285,7 @@ static struct hfs_bnode *__hfs_bnode_create(struct hfs_btree *tree, u32 cnid)
 		tree->node_hash[hash] = node;
 		tree->node_hash_cnt++;
 	} else {
+		hfs_bnode_get(node2);
 		spin_unlock(&tree->hash_lock);
 		kfree(node);
 		wait_event(node2->lock_wq, !test_bit(HFS_BNODE_NEW, &node2->flags));
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 410f59372f19..660079263f5b 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -294,11 +294,11 @@ static void hfsplus_put_super(struct super_block *sb)
 		hfsplus_sync_fs(sb, 1);
 	}
 
+	iput(sbi->alloc_file);
+	iput(sbi->hidden_dir);
 	hfs_btree_close(sbi->attr_tree);
 	hfs_btree_close(sbi->cat_tree);
 	hfs_btree_close(sbi->ext_tree);
-	iput(sbi->alloc_file);
-	iput(sbi->hidden_dir);
 	kfree(sbi->s_vhdr_buf);
 	kfree(sbi->s_backup_vhdr_buf);
 	unload_nls(sbi->nls);
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 0ca1ad2610df..6a0f564e58dd 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -206,7 +206,8 @@ int dbMount(struct inode *ipbmap)
 	bmp->db_agwidth = le32_to_cpu(dbmp_le->dn_agwidth);
 	bmp->db_agstart = le32_to_cpu(dbmp_le->dn_agstart);
 	bmp->db_agl2size = le32_to_cpu(dbmp_le->dn_agl2size);
-	if (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG) {
+	if (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG ||
+	    bmp->db_agl2size < 0) {
 		err = -EINVAL;
 		goto err_release_metapage;
 	}
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 1565dd8e8856..fbbc30f20173 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -115,14 +115,6 @@ static int __ocfs2_move_extent(handle_t *handle,
 	 */
 	replace_rec.e_flags = ext_flags & ~OCFS2_EXT_REFCOUNTED;
 
-	ret = ocfs2_journal_access_di(handle, INODE_CACHE(inode),
-				      context->et.et_root_bh,
-				      OCFS2_JOURNAL_ACCESS_WRITE);
-	if (ret) {
-		mlog_errno(ret);
-		goto out;
-	}
-
 	ret = ocfs2_split_extent(handle, &context->et, path, index,
 				 &replace_rec, context->meta_ac,
 				 &context->dealloc);
@@ -131,8 +123,6 @@ static int __ocfs2_move_extent(handle_t *handle,
 		goto out;
 	}
 
-	ocfs2_journal_dirty(handle, context->et.et_root_bh);
-
 	context->new_phys_cpos = new_p_cpos;
 
 	/*
@@ -454,7 +444,7 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 			bg = (struct ocfs2_group_desc *)gd_bh->b_data;
 
 			if (vict_blkno < (le64_to_cpu(bg->bg_blkno) +
-						le16_to_cpu(bg->bg_bits))) {
+						(le16_to_cpu(bg->bg_bits) << bits_per_unit))) {
 
 				*ret_bh = gd_bh;
 				*vict_bit = (vict_blkno - blkno) >>
@@ -569,6 +559,7 @@ static void ocfs2_probe_alloc_group(struct inode *inode, struct buffer_head *bh,
 			last_free_bits++;
 
 		if (last_free_bits == move_len) {
+			i -= move_len;
 			*goal_bit = i;
 			*phys_cpos = base_cpos + i;
 			break;
@@ -1040,18 +1031,19 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 
 	context->range = &range;
 
+	/*
+	 * ok, the default theshold for the defragmentation
+	 * is 1M, since our maximum clustersize was 1M also.
+	 * any thought?
+	 */
+	if (!range.me_threshold)
+		range.me_threshold = 1024 * 1024;
+
+	if (range.me_threshold > i_size_read(inode))
+		range.me_threshold = i_size_read(inode);
+
 	if (range.me_flags & OCFS2_MOVE_EXT_FL_AUTO_DEFRAG) {
 		context->auto_defrag = 1;
-		/*
-		 * ok, the default theshold for the defragmentation
-		 * is 1M, since our maximum clustersize was 1M also.
-		 * any thought?
-		 */
-		if (!range.me_threshold)
-			range.me_threshold = 1024 * 1024;
-
-		if (range.me_threshold > i_size_read(inode))
-			range.me_threshold = i_size_read(inode);
 
 		if (range.me_flags & OCFS2_MOVE_EXT_FL_PART_DEFRAG)
 			context->partial = 1;
diff --git a/fs/ubifs/budget.c b/fs/ubifs/budget.c
index 11a11b32a2a9..a06f7f787074 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -224,11 +224,10 @@ long long ubifs_calc_available(const struct ubifs_info *c, int min_idx_lebs)
 	subtract_lebs += 1;
 
 	/*
-	 * The GC journal head LEB is not really accessible. And since
-	 * different write types go to different heads, we may count only on
-	 * one head's space.
+	 * Since different write types go to different heads, we should
+	 * reserve one leb for each head.
 	 */
-	subtract_lebs += c->jhead_cnt - 1;
+	subtract_lebs += c->jhead_cnt;
 
 	/* We also reserve one LEB for deletions, which bypass budgeting */
 	subtract_lebs += 1;
@@ -415,7 +414,7 @@ static int calc_dd_growth(const struct ubifs_info *c,
 	dd_growth = req->dirtied_page ? c->bi.page_budget : 0;
 
 	if (req->dirtied_ino)
-		dd_growth += c->bi.inode_budget << (req->dirtied_ino - 1);
+		dd_growth += c->bi.inode_budget * req->dirtied_ino;
 	if (req->mod_dent)
 		dd_growth += c->bi.dent_budget;
 	dd_growth += req->dirtied_ino_d;
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 299611052bbf..99e3692264ae 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1605,6 +1605,10 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 		return err;
 	}
 
+	err = ubifs_budget_space(c, &req);
+	if (err)
+		goto out;
+
 	lock_4_inodes(old_dir, new_dir, NULL, NULL);
 
 	time = current_time(old_dir);
@@ -1630,6 +1634,7 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	unlock_4_inodes(old_dir, new_dir, NULL, NULL);
 	ubifs_release_budget(c, &req);
 
+out:
 	fscrypt_free_filename(&fst_nm);
 	fscrypt_free_filename(&snd_nm);
 	return err;
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 46e5a58c4b05..0e9cfeca5daf 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1041,7 +1041,7 @@ static int ubifs_writepage(struct page *page, struct writeback_control *wbc)
 		if (page->index >= synced_i_size >> PAGE_SHIFT) {
 			err = inode->i_sb->s_op->write_inode(inode, NULL);
 			if (err)
-				goto out_unlock;
+				goto out_redirty;
 			/*
 			 * The inode has been written, but the write-buffer has
 			 * not been synchronized, so in case of an unclean
@@ -1069,11 +1069,17 @@ static int ubifs_writepage(struct page *page, struct writeback_control *wbc)
 	if (i_size > synced_i_size) {
 		err = inode->i_sb->s_op->write_inode(inode, NULL);
 		if (err)
-			goto out_unlock;
+			goto out_redirty;
 	}
 
 	return do_writepage(page, len);
-
+out_redirty:
+	/*
+	 * redirty_page_for_writepage() won't call ubifs_dirty_inode() because
+	 * it passes I_DIRTY_PAGES flag while calling __mark_inode_dirty(), so
+	 * there is no need to do space budget for dirty inode.
+	 */
+	redirty_page_for_writepage(wbc, page);
 out_unlock:
 	unlock_page(page);
 	return err;
diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index c7828db206bc..6c4af1cfce34 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -279,11 +279,18 @@ static struct ubifs_znode *dirty_cow_znode(struct ubifs_info *c,
 	if (zbr->len) {
 		err = insert_old_idx(c, zbr->lnum, zbr->offs);
 		if (unlikely(err))
-			return ERR_PTR(err);
+			/*
+			 * Obsolete znodes will be freed by tnc_destroy_cnext()
+			 * or free_obsolete_znodes(), copied up znodes should
+			 * be added back to tnc and freed by
+			 * ubifs_destroy_tnc_subtree().
+			 */
+			goto out;
 		err = add_idx_dirt(c, zbr->lnum, zbr->len);
 	} else
 		err = 0;
 
+out:
 	zbr->znode = zn;
 	zbr->lnum = 0;
 	zbr->offs = 0;
@@ -3044,6 +3051,21 @@ static void tnc_destroy_cnext(struct ubifs_info *c)
 		cnext = cnext->cnext;
 		if (ubifs_zn_obsolete(znode))
 			kfree(znode);
+		else if (!ubifs_zn_cow(znode)) {
+			/*
+			 * Don't forget to update clean znode count after
+			 * committing failed, because ubifs will check this
+			 * count while closing tnc. Non-obsolete znode could
+			 * be re-dirtied during committing process, so dirty
+			 * flag is untrustable. The flag 'COW_ZNODE' is set
+			 * for each dirty znode before committing, and it is
+			 * cleared as long as the znode become clean, so we
+			 * can statistic clean znode count according to this
+			 * flag.
+			 */
+			atomic_long_inc(&c->clean_zn_cnt);
+			atomic_long_inc(&ubifs_clean_zn_cnt);
+		}
 	} while (cnext && cnext != c->cnext);
 }
 
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 356c2bf148a5..1fa074ed06b7 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -148,26 +148,24 @@ static ssize_t udf_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
 		goto out;
 
 	down_write(&iinfo->i_data_sem);
-	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB) {
-		loff_t end = iocb->ki_pos + iov_iter_count(from);
-
-		if (inode->i_sb->s_blocksize <
-				(udf_file_entry_alloc_offset(inode) + end)) {
-			err = udf_expand_file_adinicb(inode);
-			if (err) {
-				inode_unlock(inode);
-				udf_debug("udf_expand_adinicb: err=%d\n", err);
-				return err;
-			}
-		} else {
-			iinfo->i_lenAlloc = max(end, inode->i_size);
-			up_write(&iinfo->i_data_sem);
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB &&
+	    inode->i_sb->s_blocksize < (udf_file_entry_alloc_offset(inode) +
+				 iocb->ki_pos + iov_iter_count(from))) {
+		err = udf_expand_file_adinicb(inode);
+		if (err) {
+			inode_unlock(inode);
+			udf_debug("udf_expand_adinicb: err=%d\n", err);
+			return err;
 		}
 	} else
 		up_write(&iinfo->i_data_sem);
 
 	retval = __generic_file_write_iter(iocb, from);
 out:
+	down_write(&iinfo->i_data_sem);
+	if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_IN_ICB && retval > 0)
+		iinfo->i_lenAlloc = inode->i_size;
+	up_write(&iinfo->i_data_sem);
 	inode_unlock(inode);
 
 	if (retval > 0) {
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 2da65989ae5d..c47b9c3a97ef 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -521,8 +521,10 @@ static int udf_do_extend_file(struct inode *inode,
 	}
 
 	if (fake) {
-		udf_add_aext(inode, last_pos, &last_ext->extLocation,
-			     last_ext->extLength, 1);
+		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
+				   last_ext->extLength, 1);
+		if (err < 0)
+			goto out_err;
 		count++;
 	} else {
 		struct kernel_lb_addr tmploc;
@@ -556,7 +558,7 @@ static int udf_do_extend_file(struct inode *inode,
 		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
-			return err;
+			goto out_err;
 		count++;
 	}
 	if (new_block_bytes) {
@@ -565,7 +567,7 @@ static int udf_do_extend_file(struct inode *inode,
 		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
-			return err;
+			goto out_err;
 		count++;
 	}
 
@@ -579,6 +581,11 @@ static int udf_do_extend_file(struct inode *inode,
 		return -EIO;
 
 	return count;
+out_err:
+	/* Remove extents we've created so far */
+	udf_clear_extent_cache(inode);
+	udf_truncate_extents(inode);
+	return err;
 }
 
 /* Extend the final block of the file to final_block_len bytes */
@@ -793,19 +800,17 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
 		c = 0;
 		offset = 0;
 		count += ret;
-		/* We are not covered by a preallocated extent? */
-		if ((laarr[0].extLength & UDF_EXTENT_FLAG_MASK) !=
-						EXT_NOT_RECORDED_ALLOCATED) {
-			/* Is there any real extent? - otherwise we overwrite
-			 * the fake one... */
-			if (count)
-				c = !c;
-			laarr[c].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
-				inode->i_sb->s_blocksize;
-			memset(&laarr[c].extLocation, 0x00,
-				sizeof(struct kernel_lb_addr));
-			count++;
-		}
+		/*
+		 * Is there any real extent? - otherwise we overwrite the fake
+		 * one...
+		 */
+		if (count)
+			c = !c;
+		laarr[c].extLength = EXT_NOT_RECORDED_NOT_ALLOCATED |
+			inode->i_sb->s_blocksize;
+		memset(&laarr[c].extLocation, 0x00,
+			sizeof(struct kernel_lb_addr));
+		count++;
 		endnum = c + 1;
 		lastblock = 1;
 	} else {
@@ -1082,23 +1087,8 @@ static void udf_merge_extents(struct inode *inode, struct kernel_long_ad *laarr,
 			blocksize - 1) >> blocksize_bits)))) {
 
 			if (((li->extLength & UDF_EXTENT_LENGTH_MASK) +
-				(lip1->extLength & UDF_EXTENT_LENGTH_MASK) +
-				blocksize - 1) & ~UDF_EXTENT_LENGTH_MASK) {
-				lip1->extLength = (lip1->extLength -
-						  (li->extLength &
-						   UDF_EXTENT_LENGTH_MASK) +
-						   UDF_EXTENT_LENGTH_MASK) &
-							~(blocksize - 1);
-				li->extLength = (li->extLength &
-						 UDF_EXTENT_FLAG_MASK) +
-						(UDF_EXTENT_LENGTH_MASK + 1) -
-						blocksize;
-				lip1->extLocation.logicalBlockNum =
-					li->extLocation.logicalBlockNum +
-					((li->extLength &
-						UDF_EXTENT_LENGTH_MASK) >>
-						blocksize_bits);
-			} else {
+			     (lip1->extLength & UDF_EXTENT_LENGTH_MASK) +
+			     blocksize - 1) <= UDF_EXTENT_LENGTH_MASK) {
 				li->extLength = lip1->extLength +
 					(((li->extLength &
 						UDF_EXTENT_LENGTH_MASK) +
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 68c9f1d618f5..796706d73feb 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -56,6 +56,8 @@
 #define MF_DUPLICATE_MD		0x01
 #define MF_MIRROR_FE_LOADED	0x02
 
+#define EFSCORRUPTED EUCLEAN
+
 struct udf_meta_data {
 	__u32	s_meta_file_loc;
 	__u32	s_mirror_file_loc;
diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
index 4fef19064b0f..689f615471ab 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -274,6 +274,10 @@ int mipi_dsi_dcs_set_display_brightness(struct mipi_dsi_device *dsi,
 					u16 brightness);
 int mipi_dsi_dcs_get_display_brightness(struct mipi_dsi_device *dsi,
 					u16 *brightness);
+int mipi_dsi_dcs_set_display_brightness_large(struct mipi_dsi_device *dsi,
+					     u16 brightness);
+int mipi_dsi_dcs_get_display_brightness_large(struct mipi_dsi_device *dsi,
+					     u16 *brightness);
 
 /**
  * struct mipi_dsi_driver - DSI driver
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 7c0e616362f0..55a639609070 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -67,6 +67,14 @@ struct bpf_prog_aux;
 
 /* ALU ops on registers, bpf_add|sub|...: dst_reg += src_reg */
 
+#define BPF_ALU_REG(CLASS, OP, DST, SRC)			\
+	((struct bpf_insn) {					\
+		.code  = CLASS | BPF_OP(OP) | BPF_X,		\
+		.dst_reg = DST,					\
+		.src_reg = SRC,					\
+		.off   = 0,					\
+		.imm   = 0 })
+
 #define BPF_ALU64_REG(OP, DST, SRC)				\
 	((struct bpf_insn) {					\
 		.code  = BPF_ALU64 | BPF_OP(OP) | BPF_X,	\
@@ -113,6 +121,14 @@ struct bpf_prog_aux;
 
 /* Short form of mov, dst_reg = src_reg */
 
+#define BPF_MOV_REG(CLASS, DST, SRC)				\
+	((struct bpf_insn) {					\
+		.code  = CLASS | BPF_MOV | BPF_X,		\
+		.dst_reg = DST,					\
+		.src_reg = SRC,					\
+		.off   = 0,					\
+		.imm   = 0 })
+
 #define BPF_MOV64_REG(DST, SRC)					\
 	((struct bpf_insn) {					\
 		.code  = BPF_ALU64 | BPF_MOV | BPF_X,		\
@@ -147,6 +163,14 @@ struct bpf_prog_aux;
 		.off   = 0,					\
 		.imm   = IMM })
 
+#define BPF_RAW_REG(insn, DST, SRC)				\
+	((struct bpf_insn) {					\
+		.code  = (insn).code,				\
+		.dst_reg = DST,					\
+		.src_reg = SRC,					\
+		.off   = (insn).off,				\
+		.imm   = (insn).imm })
+
 /* BPF_LD_IMM64 macro encodes single 'load 64-bit immediate' insn */
 #define BPF_LD_IMM64(DST, IMM)					\
 	BPF_LD_IMM64_RAW(DST, 0, IMM)
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 0e4647e0eb60..9a14e4d33a2d 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -18,7 +18,8 @@ struct linux_binprm;
 extern int ima_bprm_check(struct linux_binprm *bprm);
 extern int ima_file_check(struct file *file, int mask, int opened);
 extern void ima_file_free(struct file *file);
-extern int ima_file_mmap(struct file *file, unsigned long prot);
+extern int ima_file_mmap(struct file *file, unsigned long reqprot,
+			 unsigned long prot, unsigned long flags);
 extern int ima_read_file(struct file *file, enum kernel_read_file_id id);
 extern int ima_post_read_file(struct file *file, void *buf, loff_t size,
 			      enum kernel_read_file_id id);
@@ -44,7 +45,8 @@ static inline void ima_file_free(struct file *file)
 	return;
 }
 
-static inline int ima_file_mmap(struct file *file, unsigned long prot)
+static inline int ima_file_mmap(struct file *file, unsigned long reqprot,
+				unsigned long prot, unsigned long flags)
 {
 	return 0;
 }
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 7ee2bb43b251..f7f20cf1bd3b 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -73,7 +73,7 @@ extern unsigned int kstat_irqs_usr(unsigned int irq);
 /*
  * Number of interrupts per cpu, since bootup
  */
-static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
+static inline unsigned long kstat_cpu_irqs_sum(unsigned int cpu)
 {
 	return kstat_cpu(cpu).irqs_sum;
 }
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index 019444c04f58..a3b380899e5d 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -353,6 +353,8 @@ extern int proc_kprobes_optimization_handler(struct ctl_table *table,
 					     size_t *length, loff_t *ppos);
 #endif
 extern void wait_for_kprobe_optimizer(void);
+bool optprobe_queued_unopt(struct optimized_kprobe *op);
+bool kprobe_disarmed(struct kprobe *p);
 #else
 static inline void wait_for_kprobe_optimizer(void) { }
 #endif /* CONFIG_OPTPROBES */
diff --git a/include/uapi/linux/usb/video.h b/include/uapi/linux/usb/video.h
index ff6cc6cb4227..0c5087c39a9f 100644
--- a/include/uapi/linux/usb/video.h
+++ b/include/uapi/linux/usb/video.h
@@ -179,6 +179,36 @@
 #define UVC_CONTROL_CAP_AUTOUPDATE			(1 << 3)
 #define UVC_CONTROL_CAP_ASYNCHRONOUS			(1 << 4)
 
+/* 3.9.2.6 Color Matching Descriptor Values */
+enum uvc_color_primaries_values {
+	UVC_COLOR_PRIMARIES_UNSPECIFIED,
+	UVC_COLOR_PRIMARIES_BT_709_SRGB,
+	UVC_COLOR_PRIMARIES_BT_470_2_M,
+	UVC_COLOR_PRIMARIES_BT_470_2_B_G,
+	UVC_COLOR_PRIMARIES_SMPTE_170M,
+	UVC_COLOR_PRIMARIES_SMPTE_240M,
+};
+
+enum uvc_transfer_characteristics_values {
+	UVC_TRANSFER_CHARACTERISTICS_UNSPECIFIED,
+	UVC_TRANSFER_CHARACTERISTICS_BT_709,
+	UVC_TRANSFER_CHARACTERISTICS_BT_470_2_M,
+	UVC_TRANSFER_CHARACTERISTICS_BT_470_2_B_G,
+	UVC_TRANSFER_CHARACTERISTICS_SMPTE_170M,
+	UVC_TRANSFER_CHARACTERISTICS_SMPTE_240M,
+	UVC_TRANSFER_CHARACTERISTICS_LINEAR,
+	UVC_TRANSFER_CHARACTERISTICS_SRGB,
+};
+
+enum uvc_matrix_coefficients {
+	UVC_MATRIX_COEFFICIENTS_UNSPECIFIED,
+	UVC_MATRIX_COEFFICIENTS_BT_709,
+	UVC_MATRIX_COEFFICIENTS_FCC,
+	UVC_MATRIX_COEFFICIENTS_BT_470_2_B_G,
+	UVC_MATRIX_COEFFICIENTS_SMPTE_170M,
+	UVC_MATRIX_COEFFICIENTS_SMPTE_240M,
+};
+
 /* ------------------------------------------------------------------------
  * UVC structures
  */
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 5d649983de07..2ca36bb440de 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -663,9 +663,6 @@ static int bpf_jit_blind_insn(const struct bpf_insn *from,
 	 * below.
 	 *
 	 * Constant blinding is only used by JITs, not in the interpreter.
-	 * The interpreter uses AX in some occasions as a local temporary
-	 * register e.g. in DIV or MOD instructions.
-	 *
 	 * In restricted circumstances, the verifier can also use the AX
 	 * register for rewrites as long as they do not interfere with
 	 * the above cases!
@@ -1058,44 +1055,36 @@ static unsigned int ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn,
 		(*(s64 *) &DST) >>= IMM;
 		CONT;
 	ALU64_MOD_X:
-		if (unlikely(SRC == 0))
-			return 0;
-		div64_u64_rem(DST, SRC, &AX);
-		DST = AX;
+		div64_u64_rem(DST, SRC, &tmp);
+		DST = tmp;
 		CONT;
 	ALU_MOD_X:
-		if (unlikely((u32)SRC == 0))
-			return 0;
-		AX = (u32) DST;
-		DST = do_div(AX, (u32) SRC);
+		tmp = (u32) DST;
+		DST = do_div(tmp, (u32) SRC);
 		CONT;
 	ALU64_MOD_K:
-		div64_u64_rem(DST, IMM, &AX);
-		DST = AX;
+		div64_u64_rem(DST, IMM, &tmp);
+		DST = tmp;
 		CONT;
 	ALU_MOD_K:
-		AX = (u32) DST;
-		DST = do_div(AX, (u32) IMM);
+		tmp = (u32) DST;
+		DST = do_div(tmp, (u32) IMM);
 		CONT;
 	ALU64_DIV_X:
-		if (unlikely(SRC == 0))
-			return 0;
 		DST = div64_u64(DST, SRC);
 		CONT;
 	ALU_DIV_X:
-		if (unlikely((u32)SRC == 0))
-			return 0;
-		AX = (u32) DST;
-		do_div(AX, (u32) SRC);
-		DST = (u32) AX;
+		tmp = (u32) DST;
+		do_div(tmp, (u32) SRC);
+		DST = (u32) tmp;
 		CONT;
 	ALU64_DIV_K:
 		DST = div64_u64(DST, IMM);
 		CONT;
 	ALU_DIV_K:
-		AX = (u32) DST;
-		do_div(AX, (u32) IMM);
-		DST = (u32) AX;
+		tmp = (u32) DST;
+		do_div(tmp, (u32) IMM);
+		DST = (u32) tmp;
 		CONT;
 	ALU_END_TO_BE:
 		switch (IMM) {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e8d9ddd5cb18..a55e264cdb54 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4839,15 +4839,38 @@ static int fixup_bpf_calls(struct bpf_verifier_env *env)
 	struct bpf_insn_aux_data *aux;
 
 	for (i = 0; i < insn_cnt; i++, insn++) {
-		if (insn->code == (BPF_ALU | BPF_MOD | BPF_X) ||
+		if (insn->code == (BPF_ALU64 | BPF_MOD | BPF_X) ||
+		    insn->code == (BPF_ALU64 | BPF_DIV | BPF_X) ||
+		    insn->code == (BPF_ALU | BPF_MOD | BPF_X) ||
 		    insn->code == (BPF_ALU | BPF_DIV | BPF_X)) {
-			/* due to JIT bugs clear upper 32-bits of src register
-			 * before div/mod operation
-			 */
-			insn_buf[0] = BPF_MOV32_REG(insn->src_reg, insn->src_reg);
-			insn_buf[1] = *insn;
-			cnt = 2;
-			new_prog = bpf_patch_insn_data(env, i + delta, insn_buf, cnt);
+			bool is64 = BPF_CLASS(insn->code) == BPF_ALU64;
+			struct bpf_insn mask_and_div[] = {
+				BPF_MOV_REG(BPF_CLASS(insn->code), BPF_REG_AX, insn->src_reg),
+				/* [R,W]x div 0 -> 0 */
+				BPF_JMP_IMM(BPF_JEQ, BPF_REG_AX, 0, 2),
+				BPF_RAW_REG(*insn, insn->dst_reg, BPF_REG_AX),
+				BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+				BPF_ALU_REG(BPF_CLASS(insn->code), BPF_XOR, insn->dst_reg, insn->dst_reg),
+			};
+			struct bpf_insn mask_and_mod[] = {
+				BPF_MOV_REG(BPF_CLASS(insn->code), BPF_REG_AX, insn->src_reg),
+				BPF_JMP_IMM(BPF_JEQ, BPF_REG_AX, 0, 1 + (is64 ? 0 : 1)),
+				BPF_RAW_REG(*insn, insn->dst_reg, BPF_REG_AX),
+				BPF_JMP_IMM(BPF_JA, 0, 0, 1),
+				BPF_MOV32_REG(insn->dst_reg, insn->dst_reg),
+			};
+			struct bpf_insn *patchlet;
+
+			if (insn->code == (BPF_ALU64 | BPF_DIV | BPF_X) ||
+			    insn->code == (BPF_ALU | BPF_DIV | BPF_X)) {
+				patchlet = mask_and_div;
+				cnt = ARRAY_SIZE(mask_and_div);
+			} else {
+				patchlet = mask_and_mod;
+				cnt = ARRAY_SIZE(mask_and_mod) - (is64 ? 2 : 0);
+			}
+
+			new_prog = bpf_patch_insn_data(env, i + delta, patchlet, cnt);
 			if (!new_prog)
 				return -ENOMEM;
 
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index cafea68749e0..7e7cc2749f82 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -492,6 +492,9 @@ void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 		return;
 
 	hwirq = irq_data->hwirq;
+
+	mutex_lock(&irq_domain_mutex);
+
 	irq_set_status_flags(irq, IRQ_NOREQUEST);
 
 	/* remove chip and handler */
@@ -511,10 +514,12 @@ void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 
 	/* Clear reverse map for this hwirq */
 	irq_domain_clear_mapping(domain, hwirq);
+
+	mutex_unlock(&irq_domain_mutex);
 }
 
-int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
-			 irq_hw_number_t hwirq)
+static int irq_domain_associate_locked(struct irq_domain *domain, unsigned int virq,
+				       irq_hw_number_t hwirq)
 {
 	struct irq_data *irq_data = irq_get_irq_data(virq);
 	int ret;
@@ -527,7 +532,6 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 	if (WARN(irq_data->domain, "error: virq%i is already associated", virq))
 		return -EINVAL;
 
-	mutex_lock(&irq_domain_mutex);
 	irq_data->hwirq = hwirq;
 	irq_data->domain = domain;
 	if (domain->ops->map) {
@@ -544,7 +548,6 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 			}
 			irq_data->domain = NULL;
 			irq_data->hwirq = 0;
-			mutex_unlock(&irq_domain_mutex);
 			return ret;
 		}
 
@@ -555,12 +558,23 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 
 	domain->mapcount++;
 	irq_domain_set_mapping(domain, hwirq, irq_data);
-	mutex_unlock(&irq_domain_mutex);
 
 	irq_clear_status_flags(virq, IRQ_NOREQUEST);
 
 	return 0;
 }
+
+int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
+			 irq_hw_number_t hwirq)
+{
+	int ret;
+
+	mutex_lock(&irq_domain_mutex);
+	ret = irq_domain_associate_locked(domain, virq, hwirq);
+	mutex_unlock(&irq_domain_mutex);
+
+	return ret;
+}
 EXPORT_SYMBOL_GPL(irq_domain_associate);
 
 void irq_domain_associate_many(struct irq_domain *domain, unsigned int irq_base,
@@ -816,13 +830,8 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 	}
 
 	irq_data = irq_get_irq_data(virq);
-	if (!irq_data) {
-		if (irq_domain_is_hierarchy(domain))
-			irq_domain_free_irqs(virq, 1);
-		else
-			irq_dispose_mapping(virq);
+	if (WARN_ON(!irq_data))
 		return 0;
-	}
 
 	/* Store trigger type */
 	irqd_set_trigger_type(irq_data, type);
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 52058ff3ccbf..eeee76ba82ca 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -418,8 +418,8 @@ static inline int kprobe_optready(struct kprobe *p)
 	return 0;
 }
 
-/* Return true(!0) if the kprobe is disarmed. Note: p must be on hash list */
-static inline int kprobe_disarmed(struct kprobe *p)
+/* Return true if the kprobe is disarmed. Note: p must be on hash list */
+bool kprobe_disarmed(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -626,7 +626,7 @@ void wait_for_kprobe_optimizer(void)
 	mutex_unlock(&kprobe_mutex);
 }
 
-static bool optprobe_queued_unopt(struct optimized_kprobe *op)
+bool optprobe_queued_unopt(struct optimized_kprobe *op)
 {
 	struct optimized_kprobe *_op;
 
diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index f90d10c1c3c8..843399e98bb3 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -498,7 +498,9 @@ static void synchronize_sched_expedited_wait(struct rcu_state *rsp)
 				mask = leaf_node_cpu_bit(rnp, cpu);
 				if (!(rnp->expmask & mask))
 					continue;
+				preempt_disable(); // For smp_processor_id() in dump_cpu_task().
 				dump_cpu_task(cpu);
+				preempt_enable();
 			}
 		}
 		jiffies_stall = 3 * rcu_jiffies_till_stall_check() + 3;
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 94dd37e8890d..7a84c54219f3 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -1564,6 +1564,7 @@ SYSCALL_DEFINE2(nanosleep, struct timespec __user *, rqtp,
 	if (!timespec64_valid(&tu))
 		return -EINVAL;
 
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 	return hrtimer_nanosleep(&tu, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
@@ -1582,6 +1583,7 @@ COMPAT_SYSCALL_DEFINE2(nanosleep, struct compat_timespec __user *, rqtp,
 	if (!timespec64_valid(&tu))
 		return -EINVAL;
 
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
 	return hrtimer_nanosleep(&tu, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
diff --git a/kernel/time/posix-stubs.c b/kernel/time/posix-stubs.c
index 06f34feb635e..20117340c249 100644
--- a/kernel/time/posix-stubs.c
+++ b/kernel/time/posix-stubs.c
@@ -136,6 +136,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 	return hrtimer_nanosleep(&t64, flags & TIMER_ABSTIME ?
@@ -222,6 +223,7 @@ COMPAT_SYSCALL_DEFINE4(clock_nanosleep, clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
 	return hrtimer_nanosleep(&t64, flags & TIMER_ABSTIME ?
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index f46694850b44..8b90abd69073 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1227,6 +1227,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 
@@ -1253,6 +1254,7 @@ COMPAT_SYSCALL_DEFINE4(clock_nanosleep, clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 999dae39f12e..a7808f8b6f56 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4554,11 +4554,16 @@ EXPORT_SYMBOL_GPL(ring_buffer_alloc_read_page);
  */
 void ring_buffer_free_read_page(struct ring_buffer *buffer, int cpu, void *data)
 {
-	struct ring_buffer_per_cpu *cpu_buffer = buffer->buffers[cpu];
+	struct ring_buffer_per_cpu *cpu_buffer;
 	struct buffer_data_page *bpage = data;
 	struct page *page = virt_to_page(bpage);
 	unsigned long flags;
 
+	if (!buffer || !buffer->buffers || !buffer->buffers[cpu])
+		return;
+
+	cpu_buffer = buffer->buffers[cpu];
+
 	/* If the page is still in use someplace else, we can't reuse it */
 	if (page_ref_count(page) > 1)
 		goto out;
diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index eead4b339466..4f73db248009 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -397,7 +397,8 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 
 	while (sg_miter_next(&miter)) {
 		buff = miter.addr;
-		len = miter.length;
+		len = min_t(unsigned, miter.length, nbytes);
+		nbytes -= len;
 
 		for (x = 0; x < len; x++) {
 			a <<= 8;
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index ac6a69f6c5e2..ebe232fd45f7 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -380,19 +380,24 @@ static int xen_9pfs_front_alloc_dataring(struct xenbus_device *dev,
 	return ret;
 }
 
-static int xen_9pfs_front_probe(struct xenbus_device *dev,
-				const struct xenbus_device_id *id)
+static int xen_9pfs_front_init(struct xenbus_device *dev)
 {
 	int ret, i;
 	struct xenbus_transaction xbt;
-	struct xen_9pfs_front_priv *priv = NULL;
-	char *versions;
+	struct xen_9pfs_front_priv *priv = dev_get_drvdata(&dev->dev);
+	char *versions, *v;
 	unsigned int max_rings, max_ring_order, len = 0;
 
 	versions = xenbus_read(XBT_NIL, dev->otherend, "versions", &len);
 	if (IS_ERR(versions))
 		return PTR_ERR(versions);
-	if (strcmp(versions, "1")) {
+	for (v = versions; *v; v++) {
+		if (simple_strtoul(v, &v, 10) == 1) {
+			v = NULL;
+			break;
+		}
+	}
+	if (v) {
 		kfree(versions);
 		return -EINVAL;
 	}
@@ -405,11 +410,6 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
 	if (max_ring_order < XEN_9PFS_RING_ORDER)
 		return -EINVAL;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	priv->dev = dev;
 	priv->num_rings = XEN_9PFS_NUM_RINGS;
 	priv->rings = kcalloc(priv->num_rings, sizeof(*priv->rings),
 			      GFP_KERNEL);
@@ -467,23 +467,35 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
 		goto error;
 	}
 
-	write_lock(&xen_9pfs_lock);
-	list_add_tail(&priv->list, &xen_9pfs_devs);
-	write_unlock(&xen_9pfs_lock);
-	dev_set_drvdata(&dev->dev, priv);
-	xenbus_switch_state(dev, XenbusStateInitialised);
-
 	return 0;
 
  error_xenbus:
 	xenbus_transaction_end(xbt, 1);
 	xenbus_dev_fatal(dev, ret, "writing xenstore");
  error:
-	dev_set_drvdata(&dev->dev, NULL);
 	xen_9pfs_front_free(priv);
 	return ret;
 }
 
+static int xen_9pfs_front_probe(struct xenbus_device *dev,
+				const struct xenbus_device_id *id)
+{
+	struct xen_9pfs_front_priv *priv = NULL;
+
+	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
+
+	priv->dev = dev;
+	dev_set_drvdata(&dev->dev, priv);
+
+	write_lock(&xen_9pfs_lock);
+	list_add_tail(&priv->list, &xen_9pfs_devs);
+	write_unlock(&xen_9pfs_lock);
+
+	return 0;
+}
+
 static int xen_9pfs_front_resume(struct xenbus_device *dev)
 {
 	dev_warn(&dev->dev, "suspsend/resume unsupported\n");
@@ -502,6 +514,8 @@ static void xen_9pfs_front_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateInitWait:
+		if (!xen_9pfs_front_init(dev))
+			xenbus_switch_state(dev, XenbusStateInitialised);
 		break;
 
 	case XenbusStateConnected:
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 1ad569581165..ed6fcfe62f7c 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -876,10 +876,6 @@ static int hci_sock_release(struct socket *sock)
 	}
 
 	sock_orphan(sk);
-
-	skb_queue_purge(&sk->sk_receive_queue);
-	skb_queue_purge(&sk->sk_write_queue);
-
 	release_sock(sk);
 	sock_put(sk);
 	return 0;
@@ -1980,6 +1976,12 @@ static int hci_sock_getsockopt(struct socket *sock, int level, int optname,
 	return err;
 }
 
+static void hci_sock_destruct(struct sock *sk)
+{
+	skb_queue_purge(&sk->sk_receive_queue);
+	skb_queue_purge(&sk->sk_write_queue);
+}
+
 static const struct proto_ops hci_sock_ops = {
 	.family		= PF_BLUETOOTH,
 	.owner		= THIS_MODULE,
@@ -2030,6 +2032,7 @@ static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
 
 	sock->state = SS_UNCONNECTED;
 	sk->sk_state = BT_OPEN;
+	sk->sk_destruct = hci_sock_destruct;
 
 	bt_sock_link(&hci_sk_list, sk);
 	return 0;
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index a5a19be51aff..9fdd2260961e 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2517,14 +2517,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
 		if (IS_ERR(skb))
 			return PTR_ERR(skb);
 
-		/* Channel lock is released before requesting new skb and then
-		 * reacquired thus we need to recheck channel state.
-		 */
-		if (chan->state != BT_CONNECTED) {
-			kfree_skb(skb);
-			return -ENOTCONN;
-		}
-
 		l2cap_do_send(chan, skb);
 		return len;
 	}
@@ -2568,14 +2560,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
 		if (IS_ERR(skb))
 			return PTR_ERR(skb);
 
-		/* Channel lock is released before requesting new skb and then
-		 * reacquired thus we need to recheck channel state.
-		 */
-		if (chan->state != BT_CONNECTED) {
-			kfree_skb(skb);
-			return -ENOTCONN;
-		}
-
 		l2cap_do_send(chan, skb);
 		err = len;
 		break;
@@ -2596,14 +2580,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
 		 */
 		err = l2cap_segment_sdu(chan, &seg_queue, msg, len);
 
-		/* The channel could have been closed while segmenting,
-		 * check that it is still connected.
-		 */
-		if (chan->state != BT_CONNECTED) {
-			__skb_queue_purge(&seg_queue);
-			err = -ENOTCONN;
-		}
-
 		if (err)
 			break;
 
diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 13d070e7738d..47a16f6e741b 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1415,6 +1415,14 @@ static struct sk_buff *l2cap_sock_alloc_skb_cb(struct l2cap_chan *chan,
 	if (!skb)
 		return ERR_PTR(err);
 
+	/* Channel lock is released before requesting new skb and then
+	 * reacquired thus we need to recheck channel state.
+	 */
+	if (chan->state != BT_CONNECTED) {
+		kfree_skb(skb);
+		return ERR_PTR(-ENOTCONN);
+	}
+
 	skb->priority = sk->sk_priority;
 
 	bt_cb(skb)->l2cap.chan = chan;
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index c44ade1b1833..43ecbd2bbe1f 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -1022,6 +1022,7 @@ static void caif_sock_destructor(struct sock *sk)
 		return;
 	}
 	sk_stream_kill_queues(&cf_sk->sk);
+	WARN_ON(sk->sk_forward_alloc);
 	caif_free_client(&cf_sk->layer);
 }
 
diff --git a/net/core/dev.c b/net/core/dev.c
index 4741c239af17..86f762a1cf7a 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2525,8 +2525,10 @@ void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
 {
 	if (in_irq() || irqs_disabled())
 		__dev_kfree_skb_irq(skb, reason);
+	else if (unlikely(reason == SKB_REASON_DROPPED))
+		kfree_skb(skb);
 	else
-		dev_kfree_skb(skb);
+		consume_skb(skb);
 }
 EXPORT_SYMBOL(__dev_kfree_skb_any);
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 29d85a20f4fc..fc665885d57c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -458,8 +458,15 @@ static int bpf_convert_filter(struct sock_filter *prog, int len,
 				break;
 
 			if (fp->code == (BPF_ALU | BPF_DIV | BPF_X) ||
-			    fp->code == (BPF_ALU | BPF_MOD | BPF_X))
+			    fp->code == (BPF_ALU | BPF_MOD | BPF_X)) {
 				*insn++ = BPF_MOV32_REG(BPF_REG_X, BPF_REG_X);
+				/* Error with exception code on div/mod by 0.
+				 * For cBPF programs, this was always return 0.
+				 */
+				*insn++ = BPF_JMP_IMM(BPF_JNE, BPF_REG_X, 0, 2);
+				*insn++ = BPF_ALU32_REG(BPF_XOR, BPF_REG_A, BPF_REG_A);
+				*insn++ = BPF_EXIT_INSN();
+			}
 
 			*insn = BPF_RAW_INSN(fp->code, BPF_REG_A, BPF_REG_X, 0, fp->k);
 			break;
diff --git a/net/core/stream.c b/net/core/stream.c
index 448100f51bf4..0b10c2cc56b3 100644
--- a/net/core/stream.c
+++ b/net/core/stream.c
@@ -209,7 +209,6 @@ void sk_stream_kill_queues(struct sock *sk)
 	sk_mem_reclaim(sk);
 
 	WARN_ON(sk->sk_wmem_queued);
-	WARN_ON(sk->sk_forward_alloc);
 
 	/* It is _impossible_ for the backlog to contain anything
 	 * when we get here.  All user references to this socket
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 6a1774b4609b..c7306bbc13df 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -925,6 +925,7 @@ int inet_csk_listen_start(struct sock *sk, int backlog)
 	 * It is OK, because this socket enters to hash table only
 	 * after validation is complete.
 	 */
+	err = -EADDRINUSE;
 	sk_state_store(sk, TCP_LISTEN);
 	if (!sk->sk_prot->get_port(sk, inet->inet_num)) {
 		inet->inet_sport = htons(inet->inet_num);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 590801a7487f..c5092e2b5933 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -616,17 +616,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
 	u32 index;
 
 	if (port) {
-		head = &hinfo->bhash[inet_bhashfn(net, port,
-						  hinfo->bhash_size)];
-		tb = inet_csk(sk)->icsk_bind_hash;
-		spin_lock_bh(&head->lock);
-		if (sk_head(&tb->owners) == sk && !sk->sk_bind_node.next) {
-			inet_ehash_nolisten(sk, NULL, NULL);
-			spin_unlock_bh(&head->lock);
-			return 0;
-		}
-		spin_unlock(&head->lock);
-		/* No definite answer... Walk to established hash table */
+		local_bh_disable();
 		ret = check_established(death_row, sk, port, NULL);
 		local_bh_enable();
 		return ret;
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index 61584638dba7..21fe6f6a0e4f 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -557,6 +557,9 @@ EXPORT_SYMBOL(tcp_create_openreq_child);
  * validation and inside tcp_v4_reqsk_send_ack(). Can we do better?
  *
  * We don't need to initialize tmp_opt.sack_ok as we don't use the results
+ *
+ * Note: If @fastopen is true, this can be called from process context.
+ *       Otherwise, this is from BH context.
  */
 
 struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
@@ -709,7 +712,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 					  &tcp_rsk(req)->last_oow_ack_time))
 			req->rsk_ops->send_ack(sk, skb, req);
 		if (paws_reject)
-			__NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABREJECTED);
+			NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABREJECTED);
 		return NULL;
 	}
 
@@ -728,7 +731,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	 *	   "fourth, check the SYN bit"
 	 */
 	if (flg & (TCP_FLAG_RST|TCP_FLAG_SYN)) {
-		__TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
+		TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
 		goto embryonic_reset;
 	}
 
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index b084659bd34b..733e61fc5043 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1906,12 +1906,15 @@ ctnetlink_create_conntrack(struct net *net,
 
 	err = nf_conntrack_hash_check_insert(ct);
 	if (err < 0)
-		goto err2;
+		goto err3;
 
 	rcu_read_unlock();
 
 	return ct;
 
+err3:
+	if (ct->master)
+		nf_ct_put(ct->master);
 err2:
 	rcu_read_unlock();
 err1:
diff --git a/net/nfc/netlink.c b/net/nfc/netlink.c
index be06f4e37c43..9898b6a27fef 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1450,7 +1450,11 @@ static int nfc_se_io(struct nfc_dev *dev, u32 se_idx,
 	rc = dev->ops->se_io(dev, se_idx, apdu,
 			apdu_length, cb, cb_context);
 
+	device_unlock(&dev->dev);
+	return rc;
+
 error:
+	kfree(cb_context);
 	device_unlock(&dev->dev);
 	return rc;
 }
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index e70ed26485a2..704018c496d4 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -412,17 +412,6 @@ config NET_CLS_BASIC
 	  To compile this code as a module, choose M here: the
 	  module will be called cls_basic.
 
-config NET_CLS_TCINDEX
-	tristate "Traffic-Control Index (TCINDEX)"
-	select NET_CLS
-	---help---
-	  Say Y here if you want to be able to classify packets based on
-	  traffic control indices. You will want this feature if you want
-	  to implement Differentiated Services together with DSMARK.
-
-	  To compile this code as a module, choose M here: the
-	  module will be called cls_tcindex.
-
 config NET_CLS_ROUTE4
 	tristate "Routing decision (ROUTE)"
 	depends on INET
diff --git a/net/sched/Makefile b/net/sched/Makefile
index 9e43a4721ef8..3f3206e25156 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -58,7 +58,6 @@ obj-$(CONFIG_NET_CLS_U32)	+= cls_u32.o
 obj-$(CONFIG_NET_CLS_ROUTE4)	+= cls_route.o
 obj-$(CONFIG_NET_CLS_FW)	+= cls_fw.o
 obj-$(CONFIG_NET_CLS_RSVP)	+= cls_rsvp.o
-obj-$(CONFIG_NET_CLS_TCINDEX)	+= cls_tcindex.o
 obj-$(CONFIG_NET_CLS_RSVP6)	+= cls_rsvp6.o
 obj-$(CONFIG_NET_CLS_BASIC)	+= cls_basic.o
 obj-$(CONFIG_NET_CLS_FLOW)	+= cls_flow.o
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
deleted file mode 100644
index 9314a739c170..000000000000
--- a/net/sched/cls_tcindex.c
+++ /dev/null
@@ -1,690 +0,0 @@
-/*
- * net/sched/cls_tcindex.c	Packet classifier for skb->tc_index
- *
- * Written 1998,1999 by Werner Almesberger, EPFL ICA
- */
-
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/kernel.h>
-#include <linux/skbuff.h>
-#include <linux/errno.h>
-#include <linux/slab.h>
-#include <net/act_api.h>
-#include <net/netlink.h>
-#include <net/pkt_cls.h>
-
-/*
- * Passing parameters to the root seems to be done more awkwardly than really
- * necessary. At least, u32 doesn't seem to use such dirty hacks. To be
- * verified. FIXME.
- */
-
-#define PERFECT_HASH_THRESHOLD	64	/* use perfect hash if not bigger */
-#define DEFAULT_HASH_SIZE	64	/* optimized for diffserv */
-
-
-struct tcindex_filter_result {
-	struct tcf_exts		exts;
-	struct tcf_result	res;
-	union {
-		struct work_struct	work;
-		struct rcu_head		rcu;
-	};
-};
-
-struct tcindex_filter {
-	u16 key;
-	struct tcindex_filter_result result;
-	struct tcindex_filter __rcu *next;
-	union {
-		struct work_struct work;
-		struct rcu_head rcu;
-	};
-};
-
-
-struct tcindex_data {
-	struct tcindex_filter_result *perfect; /* perfect hash; NULL if none */
-	struct tcindex_filter __rcu **h; /* imperfect hash; */
-	struct tcf_proto *tp;
-	u16 mask;		/* AND key with mask */
-	u32 shift;		/* shift ANDed key to the right */
-	u32 hash;		/* hash table size; 0 if undefined */
-	u32 alloc_hash;		/* allocated size */
-	u32 fall_through;	/* 0: only classify if explicit match */
-	struct rcu_head rcu;
-};
-
-static inline int tcindex_filter_is_set(struct tcindex_filter_result *r)
-{
-	return tcf_exts_has_actions(&r->exts) || r->res.classid;
-}
-
-static struct tcindex_filter_result *tcindex_lookup(struct tcindex_data *p,
-						    u16 key)
-{
-	if (p->perfect) {
-		struct tcindex_filter_result *f = p->perfect + key;
-
-		return tcindex_filter_is_set(f) ? f : NULL;
-	} else if (p->h) {
-		struct tcindex_filter __rcu **fp;
-		struct tcindex_filter *f;
-
-		fp = &p->h[key % p->hash];
-		for (f = rcu_dereference_bh_rtnl(*fp);
-		     f;
-		     fp = &f->next, f = rcu_dereference_bh_rtnl(*fp))
-			if (f->key == key)
-				return &f->result;
-	}
-
-	return NULL;
-}
-
-
-static int tcindex_classify(struct sk_buff *skb, const struct tcf_proto *tp,
-			    struct tcf_result *res)
-{
-	struct tcindex_data *p = rcu_dereference_bh(tp->root);
-	struct tcindex_filter_result *f;
-	int key = (skb->tc_index & p->mask) >> p->shift;
-
-	pr_debug("tcindex_classify(skb %p,tp %p,res %p),p %p\n",
-		 skb, tp, res, p);
-
-	f = tcindex_lookup(p, key);
-	if (!f) {
-		if (!p->fall_through)
-			return -1;
-		res->classid = TC_H_MAKE(TC_H_MAJ(tp->q->handle), key);
-		res->class = 0;
-		pr_debug("alg 0x%x\n", res->classid);
-		return 0;
-	}
-	*res = f->res;
-	pr_debug("map 0x%x\n", res->classid);
-
-	return tcf_exts_exec(skb, &f->exts, res);
-}
-
-
-static void *tcindex_get(struct tcf_proto *tp, u32 handle)
-{
-	struct tcindex_data *p = rtnl_dereference(tp->root);
-	struct tcindex_filter_result *r;
-
-	pr_debug("tcindex_get(tp %p,handle 0x%08x)\n", tp, handle);
-	if (p->perfect && handle >= p->alloc_hash)
-		return NULL;
-	r = tcindex_lookup(p, handle);
-	return r && tcindex_filter_is_set(r) ? r : NULL;
-}
-
-static int tcindex_init(struct tcf_proto *tp)
-{
-	struct tcindex_data *p;
-
-	pr_debug("tcindex_init(tp %p)\n", tp);
-	p = kzalloc(sizeof(struct tcindex_data), GFP_KERNEL);
-	if (!p)
-		return -ENOMEM;
-
-	p->mask = 0xffff;
-	p->hash = DEFAULT_HASH_SIZE;
-	p->fall_through = 1;
-
-	rcu_assign_pointer(tp->root, p);
-	return 0;
-}
-
-static void __tcindex_destroy_rexts(struct tcindex_filter_result *r)
-{
-	tcf_exts_destroy(&r->exts);
-	tcf_exts_put_net(&r->exts);
-}
-
-static void tcindex_destroy_rexts_work(struct work_struct *work)
-{
-	struct tcindex_filter_result *r;
-
-	r = container_of(work, struct tcindex_filter_result, work);
-	rtnl_lock();
-	__tcindex_destroy_rexts(r);
-	rtnl_unlock();
-}
-
-static void tcindex_destroy_rexts(struct rcu_head *head)
-{
-	struct tcindex_filter_result *r;
-
-	r = container_of(head, struct tcindex_filter_result, rcu);
-	INIT_WORK(&r->work, tcindex_destroy_rexts_work);
-	tcf_queue_work(&r->work);
-}
-
-static void __tcindex_destroy_fexts(struct tcindex_filter *f)
-{
-	tcf_exts_destroy(&f->result.exts);
-	tcf_exts_put_net(&f->result.exts);
-	kfree(f);
-}
-
-static void tcindex_destroy_fexts_work(struct work_struct *work)
-{
-	struct tcindex_filter *f = container_of(work, struct tcindex_filter,
-						work);
-
-	rtnl_lock();
-	__tcindex_destroy_fexts(f);
-	rtnl_unlock();
-}
-
-static void tcindex_destroy_fexts(struct rcu_head *head)
-{
-	struct tcindex_filter *f = container_of(head, struct tcindex_filter,
-						rcu);
-
-	INIT_WORK(&f->work, tcindex_destroy_fexts_work);
-	tcf_queue_work(&f->work);
-}
-
-static int tcindex_delete(struct tcf_proto *tp, void *arg, bool *last)
-{
-	struct tcindex_data *p = rtnl_dereference(tp->root);
-	struct tcindex_filter_result *r = arg;
-	struct tcindex_filter __rcu **walk;
-	struct tcindex_filter *f = NULL;
-
-	pr_debug("tcindex_delete(tp %p,arg %p),p %p\n", tp, arg, p);
-	if (p->perfect) {
-		if (!r->res.class)
-			return -ENOENT;
-	} else {
-		int i;
-
-		for (i = 0; i < p->hash; i++) {
-			walk = p->h + i;
-			for (f = rtnl_dereference(*walk); f;
-			     walk = &f->next, f = rtnl_dereference(*walk)) {
-				if (&f->result == r)
-					goto found;
-			}
-		}
-		return -ENOENT;
-
-found:
-		rcu_assign_pointer(*walk, rtnl_dereference(f->next));
-	}
-	tcf_unbind_filter(tp, &r->res);
-	/* all classifiers are required to call tcf_exts_destroy() after rcu
-	 * grace period, since converted-to-rcu actions are relying on that
-	 * in cleanup() callback
-	 */
-	if (f) {
-		if (tcf_exts_get_net(&f->result.exts))
-			call_rcu(&f->rcu, tcindex_destroy_fexts);
-		else
-			__tcindex_destroy_fexts(f);
-	} else {
-		if (tcf_exts_get_net(&r->exts))
-			call_rcu(&r->rcu, tcindex_destroy_rexts);
-		else
-			__tcindex_destroy_rexts(r);
-	}
-
-	*last = false;
-	return 0;
-}
-
-static int tcindex_destroy_element(struct tcf_proto *tp,
-				   void *arg, struct tcf_walker *walker)
-{
-	bool last;
-
-	return tcindex_delete(tp, arg, &last);
-}
-
-static void __tcindex_destroy(struct rcu_head *head)
-{
-	struct tcindex_data *p = container_of(head, struct tcindex_data, rcu);
-
-	kfree(p->perfect);
-	kfree(p->h);
-	kfree(p);
-}
-
-static inline int
-valid_perfect_hash(struct tcindex_data *p)
-{
-	return  p->hash > (p->mask >> p->shift);
-}
-
-static const struct nla_policy tcindex_policy[TCA_TCINDEX_MAX + 1] = {
-	[TCA_TCINDEX_HASH]		= { .type = NLA_U32 },
-	[TCA_TCINDEX_MASK]		= { .type = NLA_U16 },
-	[TCA_TCINDEX_SHIFT]		= { .type = NLA_U32 },
-	[TCA_TCINDEX_FALL_THROUGH]	= { .type = NLA_U32 },
-	[TCA_TCINDEX_CLASSID]		= { .type = NLA_U32 },
-};
-
-static int tcindex_filter_result_init(struct tcindex_filter_result *r)
-{
-	memset(r, 0, sizeof(*r));
-	return tcf_exts_init(&r->exts, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
-}
-
-static void __tcindex_partial_destroy(struct rcu_head *head)
-{
-	struct tcindex_data *p = container_of(head, struct tcindex_data, rcu);
-
-	kfree(p->perfect);
-	kfree(p);
-}
-
-static void tcindex_free_perfect_hash(struct tcindex_data *cp)
-{
-	int i;
-
-	for (i = 0; i < cp->hash; i++)
-		tcf_exts_destroy(&cp->perfect[i].exts);
-	kfree(cp->perfect);
-}
-
-static int tcindex_alloc_perfect_hash(struct tcindex_data *cp)
-{
-	int i, err = 0;
-
-	cp->perfect = kcalloc(cp->hash, sizeof(struct tcindex_filter_result),
-			      GFP_KERNEL | __GFP_NOWARN);
-	if (!cp->perfect)
-		return -ENOMEM;
-
-	for (i = 0; i < cp->hash; i++) {
-		err = tcf_exts_init(&cp->perfect[i].exts,
-				    TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
-		if (err < 0)
-			goto errout;
-	}
-
-	return 0;
-
-errout:
-	tcindex_free_perfect_hash(cp);
-	return err;
-}
-
-static int
-tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
-		  u32 handle, struct tcindex_data *p,
-		  struct tcindex_filter_result *r, struct nlattr **tb,
-		  struct nlattr *est, bool ovr)
-{
-	struct tcindex_filter_result new_filter_result, *old_r = r;
-	struct tcindex_data *cp = NULL, *oldp;
-	struct tcindex_filter *f = NULL; /* make gcc behave */
-	struct tcf_result cr = {};
-	int err, balloc = 0;
-	struct tcf_exts e;
-
-	err = tcf_exts_init(&e, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
-	if (err < 0)
-		return err;
-	err = tcf_exts_validate(net, tp, tb, est, &e, ovr);
-	if (err < 0)
-		goto errout;
-
-	err = -ENOMEM;
-	/* tcindex_data attributes must look atomic to classifier/lookup so
-	 * allocate new tcindex data and RCU assign it onto root. Keeping
-	 * perfect hash and hash pointers from old data.
-	 */
-	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
-	if (!cp)
-		goto errout;
-
-	cp->mask = p->mask;
-	cp->shift = p->shift;
-	cp->hash = p->hash;
-	cp->alloc_hash = p->alloc_hash;
-	cp->fall_through = p->fall_through;
-	cp->tp = tp;
-
-	if (tb[TCA_TCINDEX_HASH])
-		cp->hash = nla_get_u32(tb[TCA_TCINDEX_HASH]);
-
-	if (tb[TCA_TCINDEX_MASK])
-		cp->mask = nla_get_u16(tb[TCA_TCINDEX_MASK]);
-
-	if (tb[TCA_TCINDEX_SHIFT]) {
-		cp->shift = nla_get_u32(tb[TCA_TCINDEX_SHIFT]);
-		if (cp->shift > 16) {
-			err = -EINVAL;
-			goto errout;
-		}
-	}
-	if (!cp->hash) {
-		/* Hash not specified, use perfect hash if the upper limit
-		 * of the hashing index is below the threshold.
-		 */
-		if ((cp->mask >> cp->shift) < PERFECT_HASH_THRESHOLD)
-			cp->hash = (cp->mask >> cp->shift) + 1;
-		else
-			cp->hash = DEFAULT_HASH_SIZE;
-	}
-
-	if (p->perfect) {
-		int i;
-
-		if (tcindex_alloc_perfect_hash(cp) < 0)
-			goto errout;
-		cp->alloc_hash = cp->hash;
-		for (i = 0; i < min(cp->hash, p->hash); i++)
-			cp->perfect[i].res = p->perfect[i].res;
-		balloc = 1;
-	}
-	cp->h = p->h;
-
-	err = tcindex_filter_result_init(&new_filter_result);
-	if (err < 0)
-		goto errout_alloc;
-	if (old_r)
-		cr = r->res;
-
-	err = -EBUSY;
-
-	/* Hash already allocated, make sure that we still meet the
-	 * requirements for the allocated hash.
-	 */
-	if (cp->perfect) {
-		if (!valid_perfect_hash(cp) ||
-		    cp->hash > cp->alloc_hash)
-			goto errout_alloc;
-	} else if (cp->h && cp->hash != cp->alloc_hash) {
-		goto errout_alloc;
-	}
-
-	err = -EINVAL;
-	if (tb[TCA_TCINDEX_FALL_THROUGH])
-		cp->fall_through = nla_get_u32(tb[TCA_TCINDEX_FALL_THROUGH]);
-
-	if (!cp->perfect && !cp->h)
-		cp->alloc_hash = cp->hash;
-
-	/* Note: this could be as restrictive as if (handle & ~(mask >> shift))
-	 * but then, we'd fail handles that may become valid after some future
-	 * mask change. While this is extremely unlikely to ever matter,
-	 * the check below is safer (and also more backwards-compatible).
-	 */
-	if (cp->perfect || valid_perfect_hash(cp))
-		if (handle >= cp->alloc_hash)
-			goto errout_alloc;
-
-
-	err = -ENOMEM;
-	if (!cp->perfect && !cp->h) {
-		if (valid_perfect_hash(cp)) {
-			if (tcindex_alloc_perfect_hash(cp) < 0)
-				goto errout_alloc;
-			balloc = 1;
-		} else {
-			struct tcindex_filter __rcu **hash;
-
-			hash = kcalloc(cp->hash,
-				       sizeof(struct tcindex_filter *),
-				       GFP_KERNEL);
-
-			if (!hash)
-				goto errout_alloc;
-
-			cp->h = hash;
-			balloc = 2;
-		}
-	}
-
-	if (cp->perfect)
-		r = cp->perfect + handle;
-	else
-		r = tcindex_lookup(cp, handle) ? : &new_filter_result;
-
-	if (r == &new_filter_result) {
-		f = kzalloc(sizeof(*f), GFP_KERNEL);
-		if (!f)
-			goto errout_alloc;
-		f->key = handle;
-		f->next = NULL;
-		err = tcindex_filter_result_init(&f->result);
-		if (err < 0) {
-			kfree(f);
-			goto errout_alloc;
-		}
-	}
-
-	if (tb[TCA_TCINDEX_CLASSID]) {
-		cr.classid = nla_get_u32(tb[TCA_TCINDEX_CLASSID]);
-		tcf_bind_filter(tp, &cr, base);
-	}
-
-	if (old_r && old_r != r) {
-		err = tcindex_filter_result_init(old_r);
-		if (err < 0) {
-			kfree(f);
-			goto errout_alloc;
-		}
-	}
-
-	oldp = p;
-	r->res = cr;
-	tcf_exts_change(&r->exts, &e);
-
-	rcu_assign_pointer(tp->root, cp);
-
-	if (r == &new_filter_result) {
-		struct tcindex_filter *nfp;
-		struct tcindex_filter __rcu **fp;
-
-		f->result.res = r->res;
-		tcf_exts_change(&f->result.exts, &r->exts);
-
-		fp = cp->h + (handle % cp->hash);
-		for (nfp = rtnl_dereference(*fp);
-		     nfp;
-		     fp = &nfp->next, nfp = rtnl_dereference(*fp))
-				; /* nothing */
-
-		rcu_assign_pointer(*fp, f);
-	} else {
-		tcf_exts_destroy(&new_filter_result.exts);
-	}
-
-	if (oldp)
-		call_rcu(&oldp->rcu, __tcindex_partial_destroy);
-	return 0;
-
-errout_alloc:
-	if (balloc == 1)
-		tcindex_free_perfect_hash(cp);
-	else if (balloc == 2)
-		kfree(cp->h);
-	tcf_exts_destroy(&new_filter_result.exts);
-errout:
-	kfree(cp);
-	tcf_exts_destroy(&e);
-	return err;
-}
-
-static int
-tcindex_change(struct net *net, struct sk_buff *in_skb,
-	       struct tcf_proto *tp, unsigned long base, u32 handle,
-	       struct nlattr **tca, void **arg, bool ovr)
-{
-	struct nlattr *opt = tca[TCA_OPTIONS];
-	struct nlattr *tb[TCA_TCINDEX_MAX + 1];
-	struct tcindex_data *p = rtnl_dereference(tp->root);
-	struct tcindex_filter_result *r = *arg;
-	int err;
-
-	pr_debug("tcindex_change(tp %p,handle 0x%08x,tca %p,arg %p),opt %p,"
-	    "p %p,r %p,*arg %p\n",
-	    tp, handle, tca, arg, opt, p, r, arg ? *arg : NULL);
-
-	if (!opt)
-		return 0;
-
-	err = nla_parse_nested(tb, TCA_TCINDEX_MAX, opt, tcindex_policy, NULL);
-	if (err < 0)
-		return err;
-
-	return tcindex_set_parms(net, tp, base, handle, p, r, tb,
-				 tca[TCA_RATE], ovr);
-}
-
-static void tcindex_walk(struct tcf_proto *tp, struct tcf_walker *walker)
-{
-	struct tcindex_data *p = rtnl_dereference(tp->root);
-	struct tcindex_filter *f, *next;
-	int i;
-
-	pr_debug("tcindex_walk(tp %p,walker %p),p %p\n", tp, walker, p);
-	if (p->perfect) {
-		for (i = 0; i < p->hash; i++) {
-			if (!p->perfect[i].res.class)
-				continue;
-			if (walker->count >= walker->skip) {
-				if (walker->fn(tp, p->perfect + i, walker) < 0) {
-					walker->stop = 1;
-					return;
-				}
-			}
-			walker->count++;
-		}
-	}
-	if (!p->h)
-		return;
-	for (i = 0; i < p->hash; i++) {
-		for (f = rtnl_dereference(p->h[i]); f; f = next) {
-			next = rtnl_dereference(f->next);
-			if (walker->count >= walker->skip) {
-				if (walker->fn(tp, &f->result, walker) < 0) {
-					walker->stop = 1;
-					return;
-				}
-			}
-			walker->count++;
-		}
-	}
-}
-
-static void tcindex_destroy(struct tcf_proto *tp)
-{
-	struct tcindex_data *p = rtnl_dereference(tp->root);
-	struct tcf_walker walker;
-
-	pr_debug("tcindex_destroy(tp %p),p %p\n", tp, p);
-	walker.count = 0;
-	walker.skip = 0;
-	walker.fn = tcindex_destroy_element;
-	tcindex_walk(tp, &walker);
-
-	call_rcu(&p->rcu, __tcindex_destroy);
-}
-
-
-static int tcindex_dump(struct net *net, struct tcf_proto *tp, void *fh,
-			struct sk_buff *skb, struct tcmsg *t)
-{
-	struct tcindex_data *p = rtnl_dereference(tp->root);
-	struct tcindex_filter_result *r = fh;
-	struct nlattr *nest;
-
-	pr_debug("tcindex_dump(tp %p,fh %p,skb %p,t %p),p %p,r %p\n",
-		 tp, fh, skb, t, p, r);
-	pr_debug("p->perfect %p p->h %p\n", p->perfect, p->h);
-
-	nest = nla_nest_start(skb, TCA_OPTIONS);
-	if (nest == NULL)
-		goto nla_put_failure;
-
-	if (!fh) {
-		t->tcm_handle = ~0; /* whatever ... */
-		if (nla_put_u32(skb, TCA_TCINDEX_HASH, p->hash) ||
-		    nla_put_u16(skb, TCA_TCINDEX_MASK, p->mask) ||
-		    nla_put_u32(skb, TCA_TCINDEX_SHIFT, p->shift) ||
-		    nla_put_u32(skb, TCA_TCINDEX_FALL_THROUGH, p->fall_through))
-			goto nla_put_failure;
-		nla_nest_end(skb, nest);
-	} else {
-		if (p->perfect) {
-			t->tcm_handle = r - p->perfect;
-		} else {
-			struct tcindex_filter *f;
-			struct tcindex_filter __rcu **fp;
-			int i;
-
-			t->tcm_handle = 0;
-			for (i = 0; !t->tcm_handle && i < p->hash; i++) {
-				fp = &p->h[i];
-				for (f = rtnl_dereference(*fp);
-				     !t->tcm_handle && f;
-				     fp = &f->next, f = rtnl_dereference(*fp)) {
-					if (&f->result == r)
-						t->tcm_handle = f->key;
-				}
-			}
-		}
-		pr_debug("handle = %d\n", t->tcm_handle);
-		if (r->res.class &&
-		    nla_put_u32(skb, TCA_TCINDEX_CLASSID, r->res.classid))
-			goto nla_put_failure;
-
-		if (tcf_exts_dump(skb, &r->exts) < 0)
-			goto nla_put_failure;
-		nla_nest_end(skb, nest);
-
-		if (tcf_exts_dump_stats(skb, &r->exts) < 0)
-			goto nla_put_failure;
-	}
-
-	return skb->len;
-
-nla_put_failure:
-	nla_nest_cancel(skb, nest);
-	return -1;
-}
-
-static void tcindex_bind_class(void *fh, u32 classid, unsigned long cl)
-{
-	struct tcindex_filter_result *r = fh;
-
-	if (r && r->res.classid == classid)
-		r->res.class = cl;
-}
-
-static struct tcf_proto_ops cls_tcindex_ops __read_mostly = {
-	.kind		=	"tcindex",
-	.classify	=	tcindex_classify,
-	.init		=	tcindex_init,
-	.destroy	=	tcindex_destroy,
-	.get		=	tcindex_get,
-	.change		=	tcindex_change,
-	.delete		=	tcindex_delete,
-	.walk		=	tcindex_walk,
-	.dump		=	tcindex_dump,
-	.bind_class	=	tcindex_bind_class,
-	.owner		=	THIS_MODULE,
-};
-
-static int __init init_tcindex(void)
-{
-	return register_tcf_proto_ops(&cls_tcindex_ops);
-}
-
-static void __exit exit_tcindex(void)
-{
-	unregister_tcf_proto_ops(&cls_tcindex_ops);
-}
-
-module_init(init_tcindex)
-module_exit(exit_tcindex)
-MODULE_LICENSE("GPL");
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index c9158360154a..4ae28d15e8ac 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -269,6 +269,15 @@ void cfg80211_conn_work(struct work_struct *work)
 	rtnl_unlock();
 }
 
+static void cfg80211_step_auth_next(struct cfg80211_conn *conn,
+				    struct cfg80211_bss *bss)
+{
+	memcpy(conn->bssid, bss->bssid, ETH_ALEN);
+	conn->params.bssid = conn->bssid;
+	conn->params.channel = bss->channel;
+	conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
+}
+
 /* Returned bss is reference counted and must be cleaned up appropriately. */
 static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 {
@@ -286,10 +295,7 @@ static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 	if (!bss)
 		return NULL;
 
-	memcpy(wdev->conn->bssid, bss->bssid, ETH_ALEN);
-	wdev->conn->params.bssid = wdev->conn->bssid;
-	wdev->conn->params.channel = bss->channel;
-	wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
+	cfg80211_step_auth_next(wdev->conn, bss);
 	schedule_work(&rdev->conn_work);
 
 	return bss;
@@ -568,7 +574,12 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 	wdev->conn->params.ssid_len = wdev->ssid_len;
 
 	/* see if we have the bss already */
-	bss = cfg80211_get_conn_bss(wdev);
+	bss = cfg80211_get_bss(wdev->wiphy, wdev->conn->params.channel,
+			       wdev->conn->params.bssid,
+			       wdev->conn->params.ssid,
+			       wdev->conn->params.ssid_len,
+			       wdev->conn_bss_type,
+			       IEEE80211_PRIVACY(wdev->conn->params.privacy));
 
 	if (prev_bssid) {
 		memcpy(wdev->conn->prev_bssid, prev_bssid, ETH_ALEN);
@@ -579,6 +590,7 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 	if (bss) {
 		enum nl80211_timeout_reason treason;
 
+		cfg80211_step_auth_next(wdev->conn, bss);
 		err = cfg80211_conn_do_work(wdev, &treason);
 		cfg80211_put_bss(wdev->wiphy, bss);
 	} else {
@@ -1128,6 +1140,15 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 	} else {
 		if (WARN_ON(connkeys))
 			return -EINVAL;
+
+		/* connect can point to wdev->wext.connect which
+		 * can hold key data from a previous connection
+		 */
+		connect->key = NULL;
+		connect->key_len = 0;
+		connect->key_idx = 0;
+		connect->crypto.cipher_group = 0;
+		connect->crypto.n_ciphers_pairwise = 0;
 	}
 
 	wdev->connect_keys = connkeys;
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 92d0ca7309f9..ba1098fe7ff5 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -303,7 +303,9 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
 /**
  * ima_file_mmap - based on policy, collect/store measurement.
  * @file: pointer to the file to be measured (May be NULL)
- * @prot: contains the protection that will be applied by the kernel.
+ * @reqprot: protection requested by the application
+ * @prot: protection that will be applied by the kernel
+ * @flags: operational flags
  *
  * Measure files being mmapped executable based on the ima_must_measure()
  * policy decision.
@@ -311,7 +313,8 @@ static int process_measurement(struct file *file, char *buf, loff_t size,
  * On success return 0.  On integrity appraisal error, assuming the file
  * is in policy and IMA-appraisal is in enforcing mode, return -EACCES.
  */
-int ima_file_mmap(struct file *file, unsigned long prot)
+int ima_file_mmap(struct file *file, unsigned long reqprot,
+		  unsigned long prot, unsigned long flags)
 {
 	if (file && (prot & PROT_EXEC))
 		return process_measurement(file, NULL, 0, MAY_EXEC,
diff --git a/security/security.c b/security/security.c
index 737a5985343c..b5e3d7a91b33 100644
--- a/security/security.c
+++ b/security/security.c
@@ -920,12 +920,13 @@ static inline unsigned long mmap_prot(struct file *file, unsigned long prot)
 int security_mmap_file(struct file *file, unsigned long prot,
 			unsigned long flags)
 {
+	unsigned long prot_adj = mmap_prot(file, prot);
 	int ret;
-	ret = call_int_hook(mmap_file, 0, file, prot,
-					mmap_prot(file, prot), flags);
+
+	ret = call_int_hook(mmap_file, 0, file, prot, prot_adj, flags);
 	if (ret)
 		return ret;
-	return ima_file_mmap(file, prot);
+	return ima_file_mmap(file, prot, prot_adj, flags);
 }
 
 int security_mmap_addr(unsigned long addr)
diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 369f812d7072..280643f72c6e 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -1523,7 +1523,7 @@ static int dspio_set_uint_param(struct hda_codec *codec, int mod_id,
 static int dspio_alloc_dma_chan(struct hda_codec *codec, unsigned int *dma_chan)
 {
 	int status = 0;
-	unsigned int size = sizeof(dma_chan);
+	unsigned int size = sizeof(*dma_chan);
 
 	codec_dbg(codec, "     dspio_alloc_dma_chan() -- begin\n");
 	status = dspio_scp(codec, MASTERCONTROL, MASTERCONTROL_ALLOC_DMA_CHAN,
diff --git a/sound/pci/ice1712/aureon.c b/sound/pci/ice1712/aureon.c
index c9411dfff5a4..3473f1040d92 100644
--- a/sound/pci/ice1712/aureon.c
+++ b/sound/pci/ice1712/aureon.c
@@ -1906,6 +1906,7 @@ static int aureon_add_controls(struct snd_ice1712 *ice)
 		unsigned char id;
 		snd_ice1712_save_gpio_status(ice);
 		id = aureon_cs8415_get(ice, CS8415_ID);
+		snd_ice1712_restore_gpio_status(ice);
 		if (id != 0x41)
 			dev_info(ice->card->dev,
 				 "No CS8415 chip. Skipping CS8415 controls.\n");
@@ -1923,7 +1924,6 @@ static int aureon_add_controls(struct snd_ice1712 *ice)
 					kctl->id.device = ice->pcm->device;
 			}
 		}
-		snd_ice1712_restore_gpio_status(ice);
 	}
 
 	return 0;
diff --git a/sound/soc/kirkwood/kirkwood-dma.c b/sound/soc/kirkwood/kirkwood-dma.c
index 35ca8e8bb5e5..9736fb36082f 100644
--- a/sound/soc/kirkwood/kirkwood-dma.c
+++ b/sound/soc/kirkwood/kirkwood-dma.c
@@ -90,7 +90,7 @@ kirkwood_dma_conf_mbus_windows(void __iomem *base, int win,
 
 	/* try to find matching cs for current dma address */
 	for (i = 0; i < dram->num_cs; i++) {
-		const struct mbus_dram_window *cs = dram->cs + i;
+		const struct mbus_dram_window *cs = &dram->cs[i];
 		if ((cs->base & 0xffff0000) < (dma & 0xffff0000)) {
 			writel(cs->base & 0xffff0000,
 				base + KIRKWOOD_AUDIO_WIN_BASE_REG(win));
diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
index 2cb8d3b55fbc..c00f21dbcf11 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -788,7 +788,7 @@ int snd_soc_new_compress(struct snd_soc_pcm_runtime *rtd, int num)
 		rtd->fe_compr = 1;
 		if (rtd->dai_link->dpcm_playback)
 			be_pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream->private_data = rtd;
-		else if (rtd->dai_link->dpcm_capture)
+		if (rtd->dai_link->dpcm_capture)
 			be_pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream->private_data = rtd;
 		memcpy(compr->ops, &soc_compr_dyn_ops, sizeof(soc_compr_dyn_ops));
 	} else {
diff --git a/tools/iio/iio_utils.c b/tools/iio/iio_utils.c
index d60a252577f0..d174487b2f22 100644
--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -265,6 +265,7 @@ int iioutils_get_param_float(float *output, const char *param_name,
 			if (fscanf(sysfsfp, "%f", output) != 1)
 				ret = errno ? -errno : -ENODATA;
 
+			fclose(sysfsfp);
 			break;
 		}
 error_free_filename:
@@ -345,9 +346,9 @@ int build_channel_array(const char *device_dir,
 			}
 
 			sysfsfp = fopen(filename, "r");
+			free(filename);
 			if (!sysfsfp) {
 				ret = -errno;
-				free(filename);
 				goto error_close_dir;
 			}
 
@@ -357,7 +358,6 @@ int build_channel_array(const char *device_dir,
 				if (fclose(sysfsfp))
 					perror("build_channel_array(): Failed to close file");
 
-				free(filename);
 				goto error_close_dir;
 			}
 			if (ret == 1)
@@ -365,11 +365,9 @@ int build_channel_array(const char *device_dir,
 
 			if (fclose(sysfsfp)) {
 				ret = -errno;
-				free(filename);
 				goto error_close_dir;
 			}
 
-			free(filename);
 		}
 
 	*ci_array = malloc(sizeof(**ci_array) * (*counter));
@@ -395,9 +393,9 @@ int build_channel_array(const char *device_dir,
 			}
 
 			sysfsfp = fopen(filename, "r");
+			free(filename);
 			if (!sysfsfp) {
 				ret = -errno;
-				free(filename);
 				count--;
 				goto error_cleanup_array;
 			}
@@ -405,20 +403,17 @@ int build_channel_array(const char *device_dir,
 			errno = 0;
 			if (fscanf(sysfsfp, "%i", &current_enabled) != 1) {
 				ret = errno ? -errno : -ENODATA;
-				free(filename);
 				count--;
 				goto error_cleanup_array;
 			}
 
 			if (fclose(sysfsfp)) {
 				ret = -errno;
-				free(filename);
 				count--;
 				goto error_cleanup_array;
 			}
 
 			if (!current_enabled) {
-				free(filename);
 				count--;
 				continue;
 			}
@@ -429,7 +424,6 @@ int build_channel_array(const char *device_dir,
 						strlen(ent->d_name) -
 						strlen("_en"));
 			if (!current->name) {
-				free(filename);
 				ret = -ENOMEM;
 				count--;
 				goto error_cleanup_array;
@@ -439,7 +433,6 @@ int build_channel_array(const char *device_dir,
 			ret = iioutils_break_up_name(current->name,
 						     &current->generic_name);
 			if (ret) {
-				free(filename);
 				free(current->name);
 				count--;
 				goto error_cleanup_array;
@@ -450,17 +443,16 @@ int build_channel_array(const char *device_dir,
 				       scan_el_dir,
 				       current->name);
 			if (ret < 0) {
-				free(filename);
 				ret = -ENOMEM;
 				goto error_cleanup_array;
 			}
 
 			sysfsfp = fopen(filename, "r");
+			free(filename);
 			if (!sysfsfp) {
 				ret = -errno;
-				fprintf(stderr, "failed to open %s\n",
-					filename);
-				free(filename);
+				fprintf(stderr, "failed to open %s/%s_index\n",
+					scan_el_dir, current->name);
 				goto error_cleanup_array;
 			}
 
@@ -470,17 +462,14 @@ int build_channel_array(const char *device_dir,
 				if (fclose(sysfsfp))
 					perror("build_channel_array(): Failed to close file");
 
-				free(filename);
 				goto error_cleanup_array;
 			}
 
 			if (fclose(sysfsfp)) {
 				ret = -errno;
-				free(filename);
 				goto error_cleanup_array;
 			}
 
-			free(filename);
 			/* Find the scale */
 			ret = iioutils_get_param_float(&current->scale,
 						       "scale",
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 6197d5049ffb..db7e40280e41 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1384,7 +1384,8 @@ sub reboot {
 
 	# Still need to wait for the reboot to finish
 	wait_for_monitor($time, $reboot_success_line);
-
+    }
+    if ($powercycle || $time) {
 	end_monitor;
     }
 }
