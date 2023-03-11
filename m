Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB8DA6B5D7E
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 16:51:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjCKPvK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 10:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbjCKPvG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 10:51:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BAEE9198;
        Sat, 11 Mar 2023 07:49:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6222BB82573;
        Sat, 11 Mar 2023 15:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15430C433EF;
        Sat, 11 Mar 2023 15:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678549795;
        bh=RPYyNRWpr8b41Im8b7AVi2REVcDUdtoqAIe7H6P9Tm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WHYEEPHY0Vml1hcuET+iiJDsRdmSYF9zTMv11ZkNgsVhSo9Z/qe+YIDzevsSwlMO5
         8eJDiQk7CGsgDxlP7bKa/PZrl72GJFCqXyl4aUs5xEqiwjgvxZPso2CeuAPJ2GInVM
         4CwsnQfnfuE3GgvjMBm2JRzalKejYKLvZGoeMtRA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.4.235
Date:   Sat, 11 Mar 2023 16:49:44 +0100
Message-Id: <167854978413101@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <1678549784248239@kroah.com>
References: <1678549784248239@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 0ae4f564c2d6..6ec63c239616 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -82,6 +82,8 @@ Brief summary of control files.
  memory.swappiness		     set/show swappiness parameter of vmscan
 				     (See sysctl's vm.swappiness)
  memory.move_charge_at_immigrate     set/show controls of moving charges
+                                     This knob is deprecated and shouldn't be
+                                     used.
  memory.oom_control		     set/show oom controls.
  memory.numa_stat		     show the number of memory usage per numa
 				     node
@@ -745,8 +747,15 @@ NOTE2:
        It is recommended to set the soft limit always below the hard limit,
        otherwise the hard limit will take precedence.
 
-8. Move charges at task migration
-=================================
+8. Move charges at task migration (DEPRECATED!)
+===============================================
+
+THIS IS DEPRECATED!
+
+It's expensive and unreliable! It's better practice to launch workload
+tasks directly from inside their target cgroup. Use dedicated workload
+cgroups to allow fine-grained policy adjustments without having to
+move physical pages between control domains.
 
 Users can move charges associated with a task along with task migration, that
 is, uncharge task's pages from the old cgroup and charge them to the new cgroup.
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
diff --git a/Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml b/Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml
index d7a57ec4a640..140793050df3 100644
--- a/Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml
+++ b/Documentation/devicetree/bindings/rtc/allwinner,sun6i-a31-rtc.yaml
@@ -128,7 +128,6 @@ required:
   - compatible
   - reg
   - interrupts
-  - clocks
   - clock-output-names
 
 additionalProperties: false
diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
index fd22224853e5..180475bcd671 100644
--- a/Documentation/virt/kvm/api.txt
+++ b/Documentation/virt/kvm/api.txt
@@ -3615,6 +3615,18 @@ Type: vm ioctl
 Parameters: struct kvm_s390_cmma_log (in, out)
 Returns: 0 on success, a negative value on error
 
+Errors:
+
+  ======     =============================================================
+  ENOMEM     not enough memory can be allocated to complete the task
+  ENXIO      if CMMA is not enabled
+  EINVAL     if KVM_S390_CMMA_PEEK is not set but migration mode was not enabled
+  EINVAL     if KVM_S390_CMMA_PEEK is not set but dirty tracking has been
+             disabled (and thus migration mode was automatically disabled)
+  EFAULT     if the userspace address is invalid or if no page table is
+             present for the addresses (e.g. when using hugepages).
+  ======     =============================================================
+
 This ioctl is used to get the values of the CMMA bits on the s390
 architecture. It is meant to be used in two scenarios:
 - During live migration to save the CMMA values. Live migration needs
@@ -3691,12 +3703,6 @@ mask is unused.
 
 values points to the userspace buffer where the result will be stored.
 
-This ioctl can fail with -ENOMEM if not enough memory can be allocated to
-complete the task, with -ENXIO if CMMA is not enabled, with -EINVAL if
-KVM_S390_CMMA_PEEK is not set but migration mode was not enabled, with
--EFAULT if the userspace address is invalid or if no page table is
-present for the addresses (e.g. when using hugepages).
-
 4.108 KVM_S390_SET_CMMA_BITS
 
 Capability: KVM_CAP_S390_CMMA_MIGRATION
diff --git a/Documentation/virt/kvm/devices/vm.txt b/Documentation/virt/kvm/devices/vm.txt
index 4ffb82b02468..38ec142a4a84 100644
--- a/Documentation/virt/kvm/devices/vm.txt
+++ b/Documentation/virt/kvm/devices/vm.txt
@@ -254,6 +254,10 @@ Allows userspace to start migration mode, needed for PGSTE migration.
 Setting this attribute when migration mode is already active will have
 no effects.
 
+Dirty tracking must be enabled on all memslots, else -EINVAL is returned. When
+dirty tracking is disabled on any memslot, migration mode is automatically
+stopped.
+
 Parameters: none
 Returns:    -ENOMEM if there is not enough free memory to start migration mode
 	    -EINVAL if the state of the VM is invalid (e.g. no memory defined)
diff --git a/Makefile b/Makefile
index 7688832a51d2..f75275728ce8 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 234
+SUBLEVEL = 235
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
@@ -89,9 +89,16 @@ endif
 
 # If the user is running make -s (silent mode), suppress echoing of
 # commands
+# make-4.0 (and later) keep single letter options in the 1st word of MAKEFLAGS.
 
-ifneq ($(findstring s,$(filter-out --%,$(MAKEFLAGS))),)
-  quiet=silent_
+ifeq ($(filter 3.%,$(MAKE_VERSION)),)
+silence:=$(findstring s,$(firstword -$(MAKEFLAGS)))
+else
+silence:=$(findstring s,$(filter-out --%,$(MAKEFLAGS)))
+endif
+
+ifeq ($(silence),s)
+quiet=silent_
 endif
 
 export quiet Q KBUILD_VERBOSE
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index f87d8e1fcfe4..1a0a98cfdae7 100644
--- a/arch/alpha/kernel/traps.c
+++ b/arch/alpha/kernel/traps.c
@@ -235,7 +235,21 @@ do_entIF(unsigned long type, struct pt_regs *regs)
 {
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
@@ -368,20 +382,6 @@ do_entIF(unsigned long type, struct pt_regs *regs)
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
index 468932f45289..72d6b7c27151 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -239,7 +239,7 @@
 	i80-if-timings {
 		cs-setup = <0>;
 		wr-setup = <0>;
-		wr-act = <1>;
+		wr-active = <1>;
 		wr-hold = <0>;
 	};
 };
diff --git a/arch/arm/boot/dts/exynos4-cpu-thermal.dtsi b/arch/arm/boot/dts/exynos4-cpu-thermal.dtsi
index 021d9fc1b492..27a1a8952665 100644
--- a/arch/arm/boot/dts/exynos4-cpu-thermal.dtsi
+++ b/arch/arm/boot/dts/exynos4-cpu-thermal.dtsi
@@ -10,7 +10,7 @@
 / {
 thermal-zones {
 	cpu_thermal: cpu-thermal {
-		thermal-sensors = <&tmu 0>;
+		thermal-sensors = <&tmu>;
 		polling-delay-passive = <0>;
 		polling-delay = <0>;
 		trips {
diff --git a/arch/arm/boot/dts/exynos4.dtsi b/arch/arm/boot/dts/exynos4.dtsi
index 433f109d97ca..1dd009c4dc91 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -605,7 +605,7 @@
 			status = "disabled";
 
 			hdmi_i2c_phy: hdmiphy@38 {
-				compatible = "exynos4210-hdmiphy";
+				compatible = "samsung,exynos4210-hdmiphy";
 				reg = <0x38>;
 			};
 		};
diff --git a/arch/arm/boot/dts/exynos5410-odroidxu.dts b/arch/arm/boot/dts/exynos5410-odroidxu.dts
index f68baaf58f9e..51b1a7f19471 100644
--- a/arch/arm/boot/dts/exynos5410-odroidxu.dts
+++ b/arch/arm/boot/dts/exynos5410-odroidxu.dts
@@ -116,7 +116,6 @@
 };
 
 &cpu0_thermal {
-	thermal-sensors = <&tmu_cpu0 0>;
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
 
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 7d51e0f4ab79..5da434ccf12a 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -539,7 +539,7 @@
 		};
 
 		mipi_phy: mipi-video-phy {
-			compatible = "samsung,s5pv210-mipi-video-phy";
+			compatible = "samsung,exynos5420-mipi-video-phy";
 			syscon = <&pmu_system_controller>;
 			#phy-cells = <1>;
 		};
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index e2e604d6ba0b..1ef076b64de2 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -504,7 +504,7 @@
 
 				mux: mux-controller {
 					compatible = "mmio-mux";
-					#mux-control-cells = <0>;
+					#mux-control-cells = <1>;
 					mux-reg-masks = <0x14 0x00000010>;
 				};
 
diff --git a/arch/arm/boot/dts/spear320-hmi.dts b/arch/arm/boot/dts/spear320-hmi.dts
index 367ba48aac3e..5c562fb4886f 100644
--- a/arch/arm/boot/dts/spear320-hmi.dts
+++ b/arch/arm/boot/dts/spear320-hmi.dts
@@ -242,7 +242,7 @@
 					irq-trigger = <0x1>;
 
 					stmpegpio: stmpe-gpio {
-						compatible = "stmpe,gpio";
+						compatible = "st,stmpe-gpio";
 						reg = <0>;
 						gpio-controller;
 						#gpio-cells = <2>;
diff --git a/arch/arm/mach-imx/mmdc.c b/arch/arm/mach-imx/mmdc.c
index af12668d0bf5..b9efe9da06e0 100644
--- a/arch/arm/mach-imx/mmdc.c
+++ b/arch/arm/mach-imx/mmdc.c
@@ -99,6 +99,7 @@ struct mmdc_pmu {
 	cpumask_t cpu;
 	struct hrtimer hrtimer;
 	unsigned int active_events;
+	int id;
 	struct device *dev;
 	struct perf_event *mmdc_events[MMDC_NUM_COUNTERS];
 	struct hlist_node node;
@@ -433,8 +434,6 @@ static enum hrtimer_restart mmdc_pmu_timer_handler(struct hrtimer *hrtimer)
 static int mmdc_pmu_init(struct mmdc_pmu *pmu_mmdc,
 		void __iomem *mmdc_base, struct device *dev)
 {
-	int mmdc_num;
-
 	*pmu_mmdc = (struct mmdc_pmu) {
 		.pmu = (struct pmu) {
 			.task_ctx_nr    = perf_invalid_context,
@@ -452,15 +451,16 @@ static int mmdc_pmu_init(struct mmdc_pmu *pmu_mmdc,
 		.active_events = 0,
 	};
 
-	mmdc_num = ida_simple_get(&mmdc_ida, 0, 0, GFP_KERNEL);
+	pmu_mmdc->id = ida_simple_get(&mmdc_ida, 0, 0, GFP_KERNEL);
 
-	return mmdc_num;
+	return pmu_mmdc->id;
 }
 
 static int imx_mmdc_remove(struct platform_device *pdev)
 {
 	struct mmdc_pmu *pmu_mmdc = platform_get_drvdata(pdev);
 
+	ida_simple_remove(&mmdc_ida, pmu_mmdc->id);
 	cpuhp_state_remove_instance_nocalls(cpuhp_mmdc_state, &pmu_mmdc->node);
 	perf_pmu_unregister(&pmu_mmdc->pmu);
 	iounmap(pmu_mmdc->mmdc_base);
@@ -474,7 +474,6 @@ static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_b
 {
 	struct mmdc_pmu *pmu_mmdc;
 	char *name;
-	int mmdc_num;
 	int ret;
 	const struct of_device_id *of_id =
 		of_match_device(imx_mmdc_dt_ids, &pdev->dev);
@@ -497,14 +496,14 @@ static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_b
 		cpuhp_mmdc_state = ret;
 	}
 
-	mmdc_num = mmdc_pmu_init(pmu_mmdc, mmdc_base, &pdev->dev);
-	pmu_mmdc->mmdc_ipg_clk = mmdc_ipg_clk;
-	if (mmdc_num == 0)
-		name = "mmdc";
-	else
-		name = devm_kasprintf(&pdev->dev,
-				GFP_KERNEL, "mmdc%d", mmdc_num);
+	ret = mmdc_pmu_init(pmu_mmdc, mmdc_base, &pdev->dev);
+	if (ret < 0)
+		goto  pmu_free;
 
+	name = devm_kasprintf(&pdev->dev,
+				GFP_KERNEL, "mmdc%d", ret);
+
+	pmu_mmdc->mmdc_ipg_clk = mmdc_ipg_clk;
 	pmu_mmdc->devtype_data = (struct fsl_mmdc_devtype_data *)of_id->data;
 
 	hrtimer_init(&pmu_mmdc->hrtimer, CLOCK_MONOTONIC,
@@ -525,6 +524,7 @@ static int imx_mmdc_perf_init(struct platform_device *pdev, void __iomem *mmdc_b
 
 pmu_register_err:
 	pr_warn("MMDC Perf PMU failed (%d), disabled\n", ret);
+	ida_simple_remove(&mmdc_ida, pmu_mmdc->id);
 	cpuhp_state_remove_instance_nocalls(cpuhp_mmdc_state, &pmu_mmdc->node);
 	hrtimer_cancel(&pmu_mmdc->hrtimer);
 pmu_free:
diff --git a/arch/arm/mach-omap1/timer.c b/arch/arm/mach-omap1/timer.c
index 4447210c9b0d..291bc376d30e 100644
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
index 1defb838eae3..a5da85b73461 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -700,6 +700,7 @@ static void __init realtime_counter_init(void)
 	}
 
 	rate = clk_get_rate(sys_clk);
+	clk_put(sys_clk);
 
 	if (soc_is_dra7xx()) {
 		/*
diff --git a/arch/arm/mach-zynq/slcr.c b/arch/arm/mach-zynq/slcr.c
index 37707614885a..9765b3f4c2fc 100644
--- a/arch/arm/mach-zynq/slcr.c
+++ b/arch/arm/mach-zynq/slcr.c
@@ -213,6 +213,7 @@ int __init zynq_early_slcr_init(void)
 	zynq_slcr_regmap = syscon_regmap_lookup_by_compatible("xlnx,zynq-slcr");
 	if (IS_ERR(zynq_slcr_regmap)) {
 		pr_err("%s: failed to find zynq-slcr\n", __func__);
+		of_node_put(np);
 		return -ENODEV;
 	}
 
diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index 8732229f0588..72255898081c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -150,7 +150,7 @@
 		scpi_clocks: clocks {
 			compatible = "arm,scpi-clocks";
 
-			scpi_dvfs: clock-controller {
+			scpi_dvfs: clocks-0 {
 				compatible = "arm,scpi-dvfs-clocks";
 				#clock-cells = <1>;
 				clock-indices = <0>;
@@ -159,7 +159,7 @@
 		};
 
 		scpi_sensors: sensors {
-			compatible = "amlogic,meson-gxbb-scpi-sensors";
+			compatible = "amlogic,meson-gxbb-scpi-sensors", "arm,scpi-sensors";
 			#thermal-sensor-cells = <1>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 6b495587eee2..937b27549d56 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1783,7 +1783,7 @@
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-					internal_ephy: ethernet_phy@8 {
+					internal_ephy: ethernet-phy@8 {
 						compatible = "ethernet-phy-id0180.3301",
 							     "ethernet-phy-ieee802.3-c22";
 						interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12a.dtsi
index eb5d177d7a99..c8c438c0b429 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a.dtsi
@@ -54,26 +54,6 @@
 		compatible = "operating-points-v2";
 		opp-shared;
 
-		opp-100000000 {
-			opp-hz = /bits/ 64 <100000000>;
-			opp-microvolt = <731000>;
-		};
-
-		opp-250000000 {
-			opp-hz = /bits/ 64 <250000000>;
-			opp-microvolt = <731000>;
-		};
-
-		opp-500000000 {
-			opp-hz = /bits/ 64 <500000000>;
-			opp-microvolt = <731000>;
-		};
-
-		opp-667000000 {
-			opp-hz = /bits/ 64 <666666666>;
-			opp-microvolt = <731000>;
-		};
-
 		opp-1000000000 {
 			opp-hz = /bits/ 64 <1000000000>;
 			opp-microvolt = <731000>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index 0c667ec15f8c..e9f9ddd27ad7 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -172,7 +172,7 @@
 			reg = <0x14 0x10>;
 		};
 
-		eth_mac: eth_mac@34 {
+		eth_mac: eth-mac@34 {
 			reg = <0x34 0x10>;
 		};
 
@@ -189,7 +189,7 @@
 		scpi_clocks: clocks {
 			compatible = "arm,scpi-clocks";
 
-			scpi_dvfs: scpi_clocks@0 {
+			scpi_dvfs: clocks-0 {
 				compatible = "arm,scpi-dvfs-clocks";
 				#clock-cells = <1>;
 				clock-indices = <0>;
@@ -464,7 +464,7 @@
 			#size-cells = <2>;
 			ranges = <0x0 0x0 0x0 0xc8834000 0x0 0x2000>;
 
-			hwrng: rng {
+			hwrng: rng@0 {
 				compatible = "amlogic,meson-rng";
 				reg = <0x0 0x0 0x0 0x4>;
 			};
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts
index b5667f1fb2c8..22fb3e324da5 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts
@@ -18,7 +18,7 @@
 	leds {
 		compatible = "gpio-leds";
 
-		status {
+		led {
 			label = "n1:white:status";
 			gpios = <&gpio_ao GPIOAO_9 GPIO_ACTIVE_HIGH>;
 			default-state = "on";
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index e3cfa24dca5a..6809f495a503 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -700,7 +700,7 @@
 		};
 	};
 
-	eth-phy-mux {
+	eth-phy-mux@55c {
 		compatible = "mdio-mux-mmioreg", "mdio-mux";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index e7e002d8b108..3bfe9f5d2a14 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -428,6 +428,7 @@
 	pwm: pwm@11006000 {
 		compatible = "mediatek,mt7622-pwm";
 		reg = <0 0x11006000 0 0x1000>;
+		#pwm-cells = <2>;
 		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_LOW>;
 		clocks = <&topckgen CLK_TOP_PWM_SEL>,
 			 <&pericfg CLK_PERI_PWM_PD>,
diff --git a/arch/arm64/boot/dts/qcom/qcs404.dtsi b/arch/arm64/boot/dts/qcom/qcs404.dtsi
index a97eeb4569c0..1eb51b12cfac 100644
--- a/arch/arm64/boot/dts/qcom/qcs404.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404.dtsi
@@ -533,7 +533,7 @@
 
 			clocks = <&gcc GCC_PCIE_0_PIPE_CLK>;
 			resets = <&gcc GCC_PCIEPHY_0_PHY_BCR>,
-				 <&gcc 21>;
+				 <&gcc GCC_PCIE_0_PIPE_ARES>;
 			reset-names = "phy", "pipe";
 
 			clock-output-names = "pcie_0_pipe_clk";
@@ -991,12 +991,12 @@
 				 <&gcc GCC_PCIE_0_SLV_AXI_CLK>;
 			clock-names = "iface", "aux", "master_bus", "slave_bus";
 
-			resets = <&gcc 18>,
-				 <&gcc 17>,
-				 <&gcc 15>,
-				 <&gcc 19>,
+			resets = <&gcc GCC_PCIE_0_AXI_MASTER_ARES>,
+				 <&gcc GCC_PCIE_0_AXI_SLAVE_ARES>,
+				 <&gcc GCC_PCIE_0_AXI_MASTER_STICKY_ARES>,
+				 <&gcc GCC_PCIE_0_CORE_STICKY_ARES>,
 				 <&gcc GCC_PCIE_0_BCR>,
-				 <&gcc 16>;
+				 <&gcc GCC_PCIE_0_AHB_ARES>;
 			reset-names = "axi_m",
 				      "axi_s",
 				      "axi_m_sticky",
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
index 25fa651c937d..ebdf4d910af2 100644
--- a/arch/mips/include/asm/syscall.h
+++ b/arch/mips/include/asm/syscall.h
@@ -38,7 +38,7 @@ static inline bool mips_syscall_is_indirect(struct task_struct *task,
 static inline long syscall_get_nr(struct task_struct *task,
 				  struct pt_regs *regs)
 {
-	return current_thread_info()->syscall;
+	return task_thread_info(task)->syscall;
 }
 
 static inline void mips_syscall_update_nr(struct task_struct *task,
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
 
diff --git a/arch/mips/kernel/smp-cps.c b/arch/mips/kernel/smp-cps.c
index dbb3f1fc71ab..f659adb681bc 100644
--- a/arch/mips/kernel/smp-cps.c
+++ b/arch/mips/kernel/smp-cps.c
@@ -423,9 +423,11 @@ static void cps_shutdown_this_cpu(enum cpu_death death)
 			wmb();
 		}
 	} else {
-		pr_debug("Gating power to core %d\n", core);
-		/* Power down the core */
-		cps_pm_enter_state(CPS_PM_POWER_GATED);
+		if (IS_ENABLED(CONFIG_HOTPLUG_CPU)) {
+			pr_debug("Gating power to core %d\n", core);
+			/* Power down the core */
+			cps_pm_enter_state(CPS_PM_POWER_GATED);
+		}
 	}
 }
 
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
index 3f568f5aae2d..2729a4b63e18 100644
--- a/arch/mips/lantiq/prom.c
+++ b/arch/mips/lantiq/prom.c
@@ -22,12 +22,6 @@
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
diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 95183a717eb6..6c32ea6dc755 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -93,7 +93,7 @@ aflags-$(CONFIG_CPU_LITTLE_ENDIAN)	+= -mlittle-endian
 
 ifeq ($(HAS_BIARCH),y)
 KBUILD_CFLAGS	+= -m$(BITS)
-KBUILD_AFLAGS	+= -m$(BITS) -Wl,-a$(BITS)
+KBUILD_AFLAGS	+= -m$(BITS)
 KBUILD_LDFLAGS	+= -m elf$(BITS)$(LDEMULATION)
 endif
 
diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index 4fd7efdf2a53..68decc2bf42b 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -1072,45 +1072,46 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
 		}
 
 		pr_info("EEH: Recovery successful.\n");
-	} else  {
-		/*
-		 * About 90% of all real-life EEH failures in the field
-		 * are due to poorly seated PCI cards. Only 10% or so are
-		 * due to actual, failed cards.
-		 */
-		pr_err("EEH: Unable to recover from failure from PHB#%x-PE#%x.\n"
-		       "Please try reseating or replacing it\n",
-			pe->phb->global_number, pe->addr);
+		goto out;
+	}
 
-		eeh_slot_error_detail(pe, EEH_LOG_PERM);
+	/*
+	 * About 90% of all real-life EEH failures in the field
+	 * are due to poorly seated PCI cards. Only 10% or so are
+	 * due to actual, failed cards.
+	 */
+	pr_err("EEH: Unable to recover from failure from PHB#%x-PE#%x.\n"
+		"Please try reseating or replacing it\n",
+		pe->phb->global_number, pe->addr);
 
-		/* Notify all devices that they're about to go down. */
-		eeh_set_channel_state(pe, pci_channel_io_perm_failure);
-		eeh_set_irq_state(pe, false);
-		eeh_pe_report("error_detected(permanent failure)", pe,
-			      eeh_report_failure, NULL);
+	eeh_slot_error_detail(pe, EEH_LOG_PERM);
 
-		/* Mark the PE to be removed permanently */
-		eeh_pe_state_mark(pe, EEH_PE_REMOVED);
+	/* Notify all devices that they're about to go down. */
+	eeh_set_irq_state(pe, false);
+	eeh_pe_report("error_detected(permanent failure)", pe,
+		      eeh_report_failure, NULL);
+	eeh_set_channel_state(pe, pci_channel_io_perm_failure);
 
-		/*
-		 * Shut down the device drivers for good. We mark
-		 * all removed devices correctly to avoid access
-		 * the their PCI config any more.
-		 */
-		if (pe->type & EEH_PE_VF) {
-			eeh_pe_dev_traverse(pe, eeh_rmv_device, NULL);
-			eeh_pe_dev_mode_mark(pe, EEH_DEV_REMOVED);
-		} else {
-			eeh_pe_state_clear(pe, EEH_PE_PRI_BUS, true);
-			eeh_pe_dev_mode_mark(pe, EEH_DEV_REMOVED);
+	/* Mark the PE to be removed permanently */
+	eeh_pe_state_mark(pe, EEH_PE_REMOVED);
 
-			pci_lock_rescan_remove();
-			pci_hp_remove_devices(bus);
-			pci_unlock_rescan_remove();
-			/* The passed PE should no longer be used */
-			return;
-		}
+	/*
+	 * Shut down the device drivers for good. We mark
+	 * all removed devices correctly to avoid access
+	 * the their PCI config any more.
+	 */
+	if (pe->type & EEH_PE_VF) {
+		eeh_pe_dev_traverse(pe, eeh_rmv_device, NULL);
+		eeh_pe_dev_mode_mark(pe, EEH_DEV_REMOVED);
+	} else {
+		eeh_pe_state_clear(pe, EEH_PE_PRI_BUS, true);
+		eeh_pe_dev_mode_mark(pe, EEH_DEV_REMOVED);
+
+		pci_lock_rescan_remove();
+		pci_hp_remove_devices(bus);
+		pci_unlock_rescan_remove();
+		/* The passed PE should no longer be used */
+		return;
 	}
 
 out:
@@ -1206,10 +1207,10 @@ void eeh_handle_special_event(void)
 
 			/* Notify all devices to be down */
 			eeh_pe_state_clear(pe, EEH_PE_PRI_BUS, true);
-			eeh_set_channel_state(pe, pci_channel_io_perm_failure);
 			eeh_pe_report(
 				"error_detected(permanent failure)", pe,
 				eeh_report_failure, NULL);
+			eeh_set_channel_state(pe, pci_channel_io_perm_failure);
 
 			pci_lock_rescan_remove();
 			list_for_each_entry(hose, &hose_list, list_node) {
diff --git a/arch/powerpc/kernel/rtas.c b/arch/powerpc/kernel/rtas.c
index 139377f37b74..ee810df7d522 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -51,10 +51,10 @@ struct rtas_t rtas = {
 EXPORT_SYMBOL(rtas);
 
 DEFINE_SPINLOCK(rtas_data_buf_lock);
-EXPORT_SYMBOL(rtas_data_buf_lock);
+EXPORT_SYMBOL_GPL(rtas_data_buf_lock);
 
-char rtas_data_buf[RTAS_DATA_BUF_SIZE] __cacheline_aligned;
-EXPORT_SYMBOL(rtas_data_buf);
+char rtas_data_buf[RTAS_DATA_BUF_SIZE] __aligned(SZ_4K);
+EXPORT_SYMBOL_GPL(rtas_data_buf);
 
 unsigned long rtas_rmo_buf;
 
@@ -63,7 +63,7 @@ unsigned long rtas_rmo_buf;
  * This is done like this so rtas_flash can be a module.
  */
 void (*rtas_flash_term_hook)(int);
-EXPORT_SYMBOL(rtas_flash_term_hook);
+EXPORT_SYMBOL_GPL(rtas_flash_term_hook);
 
 /* RTAS use home made raw locking instead of spin_lock_irqsave
  * because those can be called from within really nasty contexts
@@ -311,7 +311,7 @@ void rtas_progress(char *s, unsigned short hex)
  
 	spin_unlock(&progress_lock);
 }
-EXPORT_SYMBOL(rtas_progress);		/* needed by rtas_flash module */
+EXPORT_SYMBOL_GPL(rtas_progress);		/* needed by rtas_flash module */
 
 int rtas_token(const char *service)
 {
@@ -321,7 +321,7 @@ int rtas_token(const char *service)
 	tokp = of_get_property(rtas.dev, service, NULL);
 	return tokp ? be32_to_cpu(*tokp) : RTAS_UNKNOWN_SERVICE;
 }
-EXPORT_SYMBOL(rtas_token);
+EXPORT_SYMBOL_GPL(rtas_token);
 
 int rtas_service_present(const char *service)
 {
@@ -481,7 +481,7 @@ int rtas_call(int token, int nargs, int nret, int *outputs, ...)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(rtas_call);
+EXPORT_SYMBOL_GPL(rtas_call);
 
 /* For RTAS_BUSY (-2), delay for 1 millisecond.  For an extended busy status
  * code of 990n, perform the hinted delay of 10^n (last digit) milliseconds.
@@ -516,7 +516,7 @@ unsigned int rtas_busy_delay(int status)
 
 	return ms;
 }
-EXPORT_SYMBOL(rtas_busy_delay);
+EXPORT_SYMBOL_GPL(rtas_busy_delay);
 
 static int rtas_error_rc(int rtas_rc)
 {
@@ -562,7 +562,7 @@ int rtas_get_power_level(int powerdomain, int *level)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_get_power_level);
+EXPORT_SYMBOL_GPL(rtas_get_power_level);
 
 int rtas_set_power_level(int powerdomain, int level, int *setlevel)
 {
@@ -580,7 +580,7 @@ int rtas_set_power_level(int powerdomain, int level, int *setlevel)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_set_power_level);
+EXPORT_SYMBOL_GPL(rtas_set_power_level);
 
 int rtas_get_sensor(int sensor, int index, int *state)
 {
@@ -598,7 +598,7 @@ int rtas_get_sensor(int sensor, int index, int *state)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_get_sensor);
+EXPORT_SYMBOL_GPL(rtas_get_sensor);
 
 int rtas_get_sensor_fast(int sensor, int index, int *state)
 {
@@ -659,7 +659,7 @@ int rtas_set_indicator(int indicator, int index, int new_value)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_set_indicator);
+EXPORT_SYMBOL_GPL(rtas_set_indicator);
 
 /*
  * Ignoring RTAS extended delay
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 058223233088..df4457e743d3 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -3008,7 +3008,8 @@ static void pnv_ioda_setup_pe_res(struct pnv_ioda_pe *pe,
 	int index;
 	int64_t rc;
 
-	if (!res || !res->flags || res->start > res->end)
+	if (!res || !res->flags || res->start > res->end ||
+	    res->flags & IORESOURCE_UNSET)
 		return;
 
 	if (res->flags & IORESOURCE_IO) {
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index c93b9a3bf237..55af0e4cf355 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -1416,22 +1416,22 @@ static inline void __init check_lp_set_hblkrm(unsigned int lp,
 
 void __init pseries_lpar_read_hblkrm_characteristics(void)
 {
+	const s32 token = rtas_token("ibm,get-system-parameter");
 	unsigned char local_buffer[SPLPAR_TLB_BIC_MAXLENGTH];
 	int call_status, len, idx, bpsize;
 
 	if (!firmware_has_feature(FW_FEATURE_BLOCK_REMOVE))
 		return;
 
-	spin_lock(&rtas_data_buf_lock);
-	memset(rtas_data_buf, 0, RTAS_DATA_BUF_SIZE);
-	call_status = rtas_call(rtas_token("ibm,get-system-parameter"), 3, 1,
-				NULL,
-				SPLPAR_TLB_BIC_TOKEN,
-				__pa(rtas_data_buf),
-				RTAS_DATA_BUF_SIZE);
-	memcpy(local_buffer, rtas_data_buf, SPLPAR_TLB_BIC_MAXLENGTH);
-	local_buffer[SPLPAR_TLB_BIC_MAXLENGTH - 1] = '\0';
-	spin_unlock(&rtas_data_buf_lock);
+	do {
+		spin_lock(&rtas_data_buf_lock);
+		memset(rtas_data_buf, 0, RTAS_DATA_BUF_SIZE);
+		call_status = rtas_call(token, 3, 1, NULL, SPLPAR_TLB_BIC_TOKEN,
+					__pa(rtas_data_buf), RTAS_DATA_BUF_SIZE);
+		memcpy(local_buffer, rtas_data_buf, SPLPAR_TLB_BIC_MAXLENGTH);
+		local_buffer[SPLPAR_TLB_BIC_MAXLENGTH - 1] = '\0';
+		spin_unlock(&rtas_data_buf_lock);
+	} while (rtas_busy_delay(call_status));
 
 	if (call_status != 0) {
 		pr_warn("%s %s Error calling get-system-parameter (0x%x)\n",
diff --git a/arch/powerpc/platforms/pseries/lparcfg.c b/arch/powerpc/platforms/pseries/lparcfg.c
index 38c306551f76..e12cf62357f2 100644
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
diff --git a/arch/riscv/kernel/time.c b/arch/riscv/kernel/time.c
index 8aa70b519e04..726860a490f3 100644
--- a/arch/riscv/kernel/time.c
+++ b/arch/riscv/kernel/time.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/of_clk.h>
+#include <linux/clockchips.h>
 #include <linux/clocksource.h>
 #include <linux/delay.h>
 #include <asm/sbi.h>
@@ -28,4 +29,6 @@ void __init time_init(void)
 
 	of_clk_init(NULL);
 	timer_probe();
+
+	tick_setup_hrtimer_broadcast();
 }
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index 6f1388391620..a97c1755517e 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -255,6 +255,7 @@ static void pop_kprobe(struct kprobe_ctlblk *kcb)
 {
 	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
+	kcb->prev_kprobe.kp = NULL;
 }
 NOKPROBE_SYMBOL(pop_kprobe);
 
@@ -509,12 +510,11 @@ static int post_kprobe_handler(struct pt_regs *regs)
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
 
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 4df41695caec..99053c80388e 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -189,5 +189,6 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(.eh_frame)
+		*(.interp)
 	}
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 49dc00d82e5e..9ade970b4232 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4527,6 +4527,22 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	if (mem->guest_phys_addr + mem->memory_size > kvm->arch.mem_limit)
 		return -EINVAL;
 
+	if (!kvm->arch.migration_mode)
+		return 0;
+
+	/*
+	 * Turn off migration mode when:
+	 * - userspace creates a new memslot with dirty logging off,
+	 * - userspace modifies an existing memslot (MOVE or FLAGS_ONLY) and
+	 *   dirty logging is turned off.
+	 * Migration mode expects dirty page logging being enabled to store
+	 * its dirty bitmap.
+	 */
+	if (change != KVM_MR_DELETE &&
+	    !(mem->flags & KVM_MEM_LOG_DIRTY_PAGES))
+		WARN(kvm_s390_vm_stop_migration(kvm),
+		     "Failed to stop migration mode");
+
 	return 0;
 }
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 349e27771cea..8cb5bb020b4b 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -321,7 +321,7 @@ config FORCE_MAX_ZONEORDER
 	  This config option is actually maximum order plus one. For example,
 	  a value of 13 means that the largest free memory block is 2^12 pages.
 
-if SPARC64
+if SPARC64 || COMPILE_TEST
 source "kernel/power/Kconfig"
 endif
 
diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 769ffbd9e9a6..eb9dba8dcf95 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -746,6 +746,7 @@ static int vector_config(char *str, char **error_out)
 
 	if (parsed == NULL) {
 		*error_out = "vector_config failed to parse parameters";
+		kfree(params);
 		return -EINVAL;
 	}
 
diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 04d72a5a8ce9..c9864ac9c014 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -19,6 +19,7 @@
 #include <crypto/internal/simd.h>
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
+#include <asm/unaligned.h>
 
 #define GHASH_BLOCK_SIZE	16
 #define GHASH_DIGEST_SIZE	16
@@ -54,7 +55,6 @@ static int ghash_setkey(struct crypto_shash *tfm,
 			const u8 *key, unsigned int keylen)
 {
 	struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
-	be128 *x = (be128 *)key;
 	u64 a, b;
 
 	if (keylen != GHASH_BLOCK_SIZE) {
@@ -63,8 +63,8 @@ static int ghash_setkey(struct crypto_shash *tfm,
 	}
 
 	/* perform multiplication by 'x' in GF(2^128) */
-	a = be64_to_cpu(x->a);
-	b = be64_to_cpu(x->b);
+	a = get_unaligned_be64(key);
+	b = get_unaligned_be64(key + 8);
 
 	ctx->shash.a = (b << 1) | (a >> 63);
 	ctx->shash.b = (a << 1) | (b >> 63);
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index f73327397b89..509cc0262fdc 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -131,7 +131,7 @@ static inline unsigned int x86_cpuid_family(void)
 int __init microcode_init(void);
 extern void __init load_ucode_bsp(void);
 extern void load_ucode_ap(void);
-void reload_early_microcode(void);
+void reload_early_microcode(unsigned int cpu);
 extern bool get_builtin_firmware(struct cpio_data *cd, const char *name);
 extern bool initrd_gone;
 void microcode_bsp_resume(void);
@@ -139,7 +139,7 @@ void microcode_bsp_resume(void);
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
index 7fa0b213b007..67d43645a2b6 100644
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
index 04c17be9b5fd..bc5b4d788c08 100644
--- a/arch/x86/include/asm/reboot.h
+++ b/arch/x86/include/asm/reboot.h
@@ -25,6 +25,8 @@ void __noreturn machine_real_restart(unsigned int type);
 #define MRR_BIOS	0
 #define MRR_APM		1
 
+void cpu_emergency_disable_virtualization(void);
+
 typedef void (*nmi_shootdown_cb)(int, struct pt_regs*);
 void nmi_panic_self_stop(struct pt_regs *regs);
 void nmi_shootdown_cpus(nmi_shootdown_cb callback);
diff --git a/arch/x86/include/asm/resctrl_sched.h b/arch/x86/include/asm/resctrl_sched.h
index f6b7fe2833cc..79b648743b84 100644
--- a/arch/x86/include/asm/resctrl_sched.h
+++ b/arch/x86/include/asm/resctrl_sched.h
@@ -51,24 +51,27 @@ DECLARE_STATIC_KEY_FALSE(rdt_mon_enable_key);
  *   simple as possible.
  * Must be called with preemption disabled.
  */
-static void __resctrl_sched_in(void)
+static inline void __resctrl_sched_in(struct task_struct *tsk)
 {
 	struct resctrl_pqr_state *state = this_cpu_ptr(&pqr_state);
 	u32 closid = state->default_closid;
 	u32 rmid = state->default_rmid;
+	u32 tmp;
 
 	/*
 	 * If this task has a closid/rmid assigned, use it.
 	 * Else use the closid/rmid assigned to this cpu.
 	 */
 	if (static_branch_likely(&rdt_alloc_enable_key)) {
-		if (current->closid)
-			closid = current->closid;
+		tmp = READ_ONCE(tsk->closid);
+		if (tmp)
+			closid = tmp;
 	}
 
 	if (static_branch_likely(&rdt_mon_enable_key)) {
-		if (current->rmid)
-			rmid = current->rmid;
+		tmp = READ_ONCE(tsk->rmid);
+		if (tmp)
+			rmid = tmp;
 	}
 
 	if (closid != state->cur_closid || rmid != state->cur_rmid) {
@@ -78,15 +81,15 @@ static void __resctrl_sched_in(void)
 	}
 }
 
-static inline void resctrl_sched_in(void)
+static inline void resctrl_sched_in(struct task_struct *tsk)
 {
 	if (static_branch_likely(&rdt_enable_key))
-		__resctrl_sched_in();
+		__resctrl_sched_in(tsk);
 }
 
 #else
 
-static inline void resctrl_sched_in(void) {}
+static inline void resctrl_sched_in(struct task_struct *tsk) {}
 
 #endif /* CONFIG_X86_CPU_RESCTRL */
 
diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index fda3e7747c22..8eefa3386d8c 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -120,7 +120,21 @@ static inline void cpu_svm_disable(void)
 
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
index 8dca326a9e78..75ca28bb267c 100644
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
@@ -975,14 +983,18 @@ spectre_v2_parse_user_cmdline(void)
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
@@ -1045,12 +1057,19 @@ spectre_v2_user_select_mitigation(void)
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
@@ -2113,7 +2132,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return "";
 
 	switch (spectre_v2_user_stibp) {
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index addaaf31ac0a..7fff0afa5246 100644
--- a/arch/x86/kernel/cpu/microcode/amd.c
+++ b/arch/x86/kernel/cpu/microcode/amd.c
@@ -55,7 +55,9 @@ struct cont_desc {
 };
 
 static u32 ucode_new_rev;
-static u8 amd_ucode_patch[PATCH_MAX_SIZE];
+
+/* One blob per node. */
+static u8 amd_ucode_patch[MAX_NUMNODES][PATCH_MAX_SIZE];
 
 /*
  * Microcode patch container file is prepended to the initrd in cpio
@@ -429,7 +431,7 @@ apply_microcode_early_amd(u32 cpuid_1_eax, void *ucode, size_t size, bool save_p
 	patch	= (u8 (*)[PATCH_MAX_SIZE])__pa_nodebug(&amd_ucode_patch);
 #else
 	new_rev = &ucode_new_rev;
-	patch	= &amd_ucode_patch;
+	patch	= &amd_ucode_patch[0];
 #endif
 
 	desc.cpuid_1_eax = cpuid_1_eax;
@@ -548,8 +550,7 @@ void load_ucode_amd_ap(unsigned int cpuid_1_eax)
 	apply_microcode_early_amd(cpuid_1_eax, cp.data, cp.size, false);
 }
 
-static enum ucode_state
-load_microcode_amd(bool save, u8 family, const u8 *data, size_t size);
+static enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size);
 
 int __init save_microcode_in_initrd_amd(unsigned int cpuid_1_eax)
 {
@@ -567,19 +568,19 @@ int __init save_microcode_in_initrd_amd(unsigned int cpuid_1_eax)
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
 
@@ -845,9 +846,10 @@ static enum ucode_state __load_microcode_amd(u8 family, const u8 *data,
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
 
@@ -860,22 +862,22 @@ load_microcode_amd(bool save, u8 family, const u8 *data, size_t size)
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
-	memcpy(amd_ucode_patch, p->data, min_t(u32, p->size, PATCH_MAX_SIZE));
+		ret = UCODE_NEW;
+
+		memset(&amd_ucode_patch[nid], 0, PATCH_MAX_SIZE);
+		memcpy(&amd_ucode_patch[nid], p->data, min_t(u32, p->size, PATCH_MAX_SIZE));
+	}
 
 	return ret;
 }
@@ -901,12 +903,11 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
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
@@ -921,7 +922,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 	if (!verify_container(fw->data, fw->size, false))
 		goto fw_release;
 
-	ret = load_microcode_amd(bsp, c->x86, fw->data, fw->size);
+	ret = load_microcode_amd(c->x86, fw->data, fw->size);
 
  fw_release:
 	release_firmware(fw);
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index c95a27513a30..834c5f723dae 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -322,7 +322,7 @@ struct cpio_data find_microcode_in_initrd(const char *path, bool use_pa)
 #endif
 }
 
-void reload_early_microcode(void)
+void reload_early_microcode(unsigned int cpu)
 {
 	int vendor, family;
 
@@ -336,7 +336,7 @@ void reload_early_microcode(void)
 		break;
 	case X86_VENDOR_AMD:
 		if (family >= 0x10)
-			reload_ucode_amd();
+			reload_ucode_amd(cpu);
 		break;
 	default:
 		break;
@@ -782,7 +782,7 @@ void microcode_bsp_resume(void)
 	if (uci->valid && uci->mc)
 		microcode_ops->apply_microcode(cpu);
 	else if (!uci->mc)
-		reload_early_microcode();
+		reload_early_microcode(cpu);
 }
 
 static struct syscore_ops mc_syscore_ops = {
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 8d6023e6ad9e..0e4f14dae1c0 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -311,7 +311,7 @@ static void update_cpu_closid_rmid(void *info)
 	 * executing task might have its own closid selected. Just reuse
 	 * the context switch code.
 	 */
-	resctrl_sched_in();
+	resctrl_sched_in(current);
 }
 
 /*
@@ -532,7 +532,7 @@ static void _update_task_closid_rmid(void *task)
 	 * Otherwise, the MSR is updated when the task is scheduled in.
 	 */
 	if (task == current)
-		resctrl_sched_in();
+		resctrl_sched_in(task);
 }
 
 static void update_task_closid_rmid(struct task_struct *t)
@@ -563,11 +563,11 @@ static int __rdtgroup_move_task(struct task_struct *tsk,
 	 */
 
 	if (rdtgrp->type == RDTCTRL_GROUP) {
-		tsk->closid = rdtgrp->closid;
-		tsk->rmid = rdtgrp->mon.rmid;
+		WRITE_ONCE(tsk->closid, rdtgrp->closid);
+		WRITE_ONCE(tsk->rmid, rdtgrp->mon.rmid);
 	} else if (rdtgrp->type == RDTMON_GROUP) {
 		if (rdtgrp->mon.parent->closid == tsk->closid) {
-			tsk->rmid = rdtgrp->mon.rmid;
+			WRITE_ONCE(tsk->rmid, rdtgrp->mon.rmid);
 		} else {
 			rdt_last_cmd_puts("Can't move task to different control group\n");
 			return -EINVAL;
@@ -2177,8 +2177,8 @@ static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
 	for_each_process_thread(p, t) {
 		if (!from || is_closid_match(t, from) ||
 		    is_rmid_match(t, from)) {
-			t->closid = to->closid;
-			t->rmid = to->mon.rmid;
+			WRITE_ONCE(t->closid, to->closid);
+			WRITE_ONCE(t->rmid, to->mon.rmid);
 
 			/*
 			 * Order the closid/rmid stores above before the loads
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 0c319d09378d..539d8cf5904d 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -37,7 +37,6 @@
 #include <linux/kdebug.h>
 #include <asm/cpu.h>
 #include <asm/reboot.h>
-#include <asm/virtext.h>
 #include <asm/intel_pt.h>
 #include <asm/crash.h>
 #include <asm/cmdline.h>
@@ -94,15 +93,6 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
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
@@ -161,12 +151,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
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
index b348dd506d58..90d41b22c5c2 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -43,8 +43,8 @@ unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf, unsigned long addr)
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
@@ -314,7 +314,7 @@ int arch_check_optimized_kprobe(struct optimized_kprobe *op)
 
 	for (i = 1; i < op->optinsn.size; i++) {
 		p = get_kprobe(op->kp.addr + i);
-		if (p && !kprobe_disabled(p))
+		if (p && !kprobe_disarmed(p))
 			return -EEXIST;
 	}
 
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 352f876950ab..8ef71fa91ff8 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -293,7 +293,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	switch_fpu_finish(next_p);
 
 	/* Load the Intel cache allocation PQR MSR. */
-	resctrl_sched_in();
+	resctrl_sched_in(next_p);
 
 	return prev_p;
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 633788362906..b77f0d9dad55 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -610,7 +610,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	}
 
 	/* Load the Intel cache allocation PQR MSR. */
-	resctrl_sched_in();
+	resctrl_sched_in(next_p);
 
 	return prev_p;
 }
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index fdef27a84d71..6fede2f00104 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -528,33 +528,29 @@ static inline void kb_wait(void)
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
@@ -591,7 +587,7 @@ static void native_machine_emergency_restart(void)
 	unsigned short mode;
 
 	if (reboot_emergency)
-		emergency_vmx_disable_all();
+		emergency_reboot_disable_virtualization();
 
 	tboot_shutdown(TB_SHUTDOWN_REBOOT);
 
@@ -796,6 +792,17 @@ void machine_crash_shutdown(struct pt_regs *regs)
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
@@ -818,7 +825,14 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
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
@@ -829,18 +843,32 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
 	return NMI_HANDLED;
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
 
@@ -868,7 +896,17 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
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
@@ -898,6 +936,8 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 	/* No other CPUs to shoot down */
 }
 
+static inline void nmi_shootdown_cpus_on_restart(void) { }
+
 void run_crash_ipi_callback(struct pt_regs *regs)
 {
 }
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index b8d4e9c3c070..31ee37f87b2b 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -31,7 +31,7 @@
 #include <asm/mce.h>
 #include <asm/trace/irq_vectors.h>
 #include <asm/kexec.h>
-#include <asm/virtext.h>
+#include <asm/reboot.h>
 
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
@@ -121,7 +121,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 	if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
 		return NMI_HANDLED;
 
-	cpu_emergency_vmxoff();
+	cpu_emergency_disable_virtualization();
 	stop_this_cpu(NULL);
 
 	return NMI_HANDLED;
@@ -134,7 +134,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 asmlinkage __visible void smp_reboot_interrupt(void)
 {
 	ipi_entering_ack_irq();
-	cpu_emergency_vmxoff();
+	cpu_emergency_disable_virtualization();
 	stop_this_cpu(NULL);
 	irq_exit();
 }
diff --git a/arch/x86/kernel/sysfb_efi.c b/arch/x86/kernel/sysfb_efi.c
index 653b7f617b61..9ea65611fba0 100644
--- a/arch/x86/kernel/sysfb_efi.c
+++ b/arch/x86/kernel/sysfb_efi.c
@@ -264,6 +264,14 @@ static const struct dmi_system_id efifb_dmi_swap_width_height[] __initconst = {
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
index 891868756a51..6d5269093f7c 100644
--- a/arch/x86/um/vdso/um_vdso.c
+++ b/arch/x86/um/vdso/um_vdso.c
@@ -17,8 +17,10 @@ int __vdso_clock_gettime(clockid_t clock, struct timespec *ts)
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
@@ -29,8 +31,10 @@ int __vdso_gettimeofday(struct timeval *tv, struct timezone *tz)
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
index ec295be93ca0..247f7c480e66 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -424,6 +424,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	bip->bip_vcnt = bip_src->bip_vcnt;
 	bip->bip_iter = bip_src->bip_iter;
+	bip->bip_flags = bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
 
 	return 0;
 }
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index ef287c33d6d9..4fdc8858a69a 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -785,9 +785,14 @@ static void calc_lcoefs(u64 bps, u64 seqiops, u64 randiops,
 
 	*page = *seqio = *randio = 0;
 
-	if (bps)
-		*page = DIV64_U64_ROUND_UP(VTIME_PER_SEC,
-					   DIV_ROUND_UP_ULL(bps, IOC_PAGE_SIZE));
+	if (bps) {
+		u64 bps_pages = DIV_ROUND_UP_ULL(bps, IOC_PAGE_SIZE);
+
+		if (bps_pages)
+			*page = DIV64_U64_ROUND_UP(VTIME_PER_SEC, bps_pages);
+		else
+			*page = 1;
+	}
 
 	if (seqiops) {
 		v = DIV64_U64_ROUND_UP(VTIME_PER_SEC, seqiops);
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index f422c7feea7e..126a9a635594 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -59,8 +59,7 @@ void blk_mq_sched_assign_ioc(struct request *rq)
 }
 
 /*
- * Mark a hardware queue as needing a restart. For shared queues, maintain
- * a count of how many hardware queues are marked for restart.
+ * Mark a hardware queue as needing a restart.
  */
 void blk_mq_sched_mark_restart_hctx(struct blk_mq_hw_ctx *hctx)
 {
@@ -92,13 +91,17 @@ void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx)
 /*
  * Only SCSI implements .get_budget and .put_budget, and SCSI restarts
  * its queue by itself in its completion handler, so we don't need to
- * restart queue if .get_budget() returns BLK_STS_NO_RESOURCE.
+ * restart queue if .get_budget() fails to get the budget.
+ *
+ * Returns -EAGAIN if hctx->dispatch was found non-empty and run_work has to
+ * be run again.  This is necessary to avoid starving flushes.
  */
-static void blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
+static int blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q = hctx->queue;
 	struct elevator_queue *e = q->elevator;
 	LIST_HEAD(rq_list);
+	int ret = 0;
 
 	do {
 		struct request *rq;
@@ -106,6 +109,11 @@ static void blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
 		if (e->type->ops.has_work && !e->type->ops.has_work(hctx))
 			break;
 
+		if (!list_empty_careful(&hctx->dispatch)) {
+			ret = -EAGAIN;
+			break;
+		}
+
 		if (!blk_mq_get_dispatch_budget(hctx))
 			break;
 
@@ -122,6 +130,8 @@ static void blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
 		 */
 		list_add(&rq->queuelist, &rq_list);
 	} while (blk_mq_dispatch_rq_list(q, &rq_list, true));
+
+	return ret;
 }
 
 static struct blk_mq_ctx *blk_mq_next_ctx(struct blk_mq_hw_ctx *hctx,
@@ -138,17 +148,26 @@ static struct blk_mq_ctx *blk_mq_next_ctx(struct blk_mq_hw_ctx *hctx,
 /*
  * Only SCSI implements .get_budget and .put_budget, and SCSI restarts
  * its queue by itself in its completion handler, so we don't need to
- * restart queue if .get_budget() returns BLK_STS_NO_RESOURCE.
+ * restart queue if .get_budget() fails to get the budget.
+ *
+ * Returns -EAGAIN if hctx->dispatch was found non-empty and run_work has to
+ * to be run again.  This is necessary to avoid starving flushes.
  */
-static void blk_mq_do_dispatch_ctx(struct blk_mq_hw_ctx *hctx)
+static int blk_mq_do_dispatch_ctx(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q = hctx->queue;
 	LIST_HEAD(rq_list);
 	struct blk_mq_ctx *ctx = READ_ONCE(hctx->dispatch_from);
+	int ret = 0;
 
 	do {
 		struct request *rq;
 
+		if (!list_empty_careful(&hctx->dispatch)) {
+			ret = -EAGAIN;
+			break;
+		}
+
 		if (!sbitmap_any_bit_set(&hctx->ctx_map))
 			break;
 
@@ -174,21 +193,17 @@ static void blk_mq_do_dispatch_ctx(struct blk_mq_hw_ctx *hctx)
 	} while (blk_mq_dispatch_rq_list(q, &rq_list, true));
 
 	WRITE_ONCE(hctx->dispatch_from, ctx);
+	return ret;
 }
 
-void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
+int __blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q = hctx->queue;
 	struct elevator_queue *e = q->elevator;
 	const bool has_sched_dispatch = e && e->type->ops.dispatch_request;
+	int ret = 0;
 	LIST_HEAD(rq_list);
 
-	/* RCU or SRCU read lock is needed before checking quiesced flag */
-	if (unlikely(blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(q)))
-		return;
-
-	hctx->run++;
-
 	/*
 	 * If we have previous entries on our dispatch list, grab them first for
 	 * more fair dispatch.
@@ -217,19 +232,41 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
 		blk_mq_sched_mark_restart_hctx(hctx);
 		if (blk_mq_dispatch_rq_list(q, &rq_list, false)) {
 			if (has_sched_dispatch)
-				blk_mq_do_dispatch_sched(hctx);
+				ret = blk_mq_do_dispatch_sched(hctx);
 			else
-				blk_mq_do_dispatch_ctx(hctx);
+				ret = blk_mq_do_dispatch_ctx(hctx);
 		}
 	} else if (has_sched_dispatch) {
-		blk_mq_do_dispatch_sched(hctx);
+		ret = blk_mq_do_dispatch_sched(hctx);
 	} else if (hctx->dispatch_busy) {
 		/* dequeue request one by one from sw queue if queue is busy */
-		blk_mq_do_dispatch_ctx(hctx);
+		ret = blk_mq_do_dispatch_ctx(hctx);
 	} else {
 		blk_mq_flush_busy_ctxs(hctx, &rq_list);
 		blk_mq_dispatch_rq_list(q, &rq_list, false);
 	}
+
+	return ret;
+}
+
+void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
+{
+	struct request_queue *q = hctx->queue;
+
+	/* RCU or SRCU read lock is needed before checking quiesced flag */
+	if (unlikely(blk_mq_hctx_stopped(hctx) || blk_queue_quiesced(q)))
+		return;
+
+	hctx->run++;
+
+	/*
+	 * A return of -EAGAIN is an indication that hctx->dispatch is not
+	 * empty and we must run again in order to avoid starving flushes.
+	 */
+	if (__blk_mq_sched_dispatch_requests(hctx) == -EAGAIN) {
+		if (__blk_mq_sched_dispatch_requests(hctx) == -EAGAIN)
+			blk_mq_run_hw_queue(hctx, true);
+	}
 }
 
 bool blk_mq_sched_try_merge(struct request_queue *q, struct bio *bio,
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 84798d09ca46..325a5944b4cb 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1112,7 +1112,7 @@ static int blk_mq_dispatch_wake(wait_queue_entry_t *wait, unsigned mode,
 static bool blk_mq_mark_tag_wait(struct blk_mq_hw_ctx *hctx,
 				 struct request *rq)
 {
-	struct sbitmap_queue *sbq = &hctx->tags->bitmap_tags;
+	struct sbitmap_queue *sbq;
 	struct wait_queue_head *wq;
 	wait_queue_entry_t *wait;
 	bool ret;
@@ -1135,6 +1135,10 @@ static bool blk_mq_mark_tag_wait(struct blk_mq_hw_ctx *hctx,
 	if (!list_empty_careful(&wait->entry))
 		return false;
 
+	if (blk_mq_tag_is_reserved(rq->mq_hctx->sched_tags, rq->internal_tag))
+		sbq = &hctx->tags->breserved_tags;
+	else
+		sbq = &hctx->tags->bitmap_tags;
 	wq = &bt_wait_ptr(sbq, hctx)->wait;
 
 	spin_lock_irq(&wq->lock);
diff --git a/crypto/essiv.c b/crypto/essiv.c
index a8befc8fb06e..aa6b89e91ac8 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -188,8 +188,12 @@ static void essiv_aead_done(struct crypto_async_request *areq, int err)
 	struct aead_request *req = areq->data;
 	struct essiv_aead_request_ctx *rctx = aead_request_ctx(req);
 
-	if (rctx->assoc)
-		kfree(rctx->assoc);
+	if (err == -EINPROGRESS)
+		goto out;
+
+	kfree(rctx->assoc);
+
+out:
 	aead_request_complete(req, err);
 }
 
@@ -265,7 +269,7 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
 	err = enc ? crypto_aead_encrypt(subreq) :
 		    crypto_aead_decrypt(subreq);
 
-	if (rctx->assoc && err != -EINPROGRESS)
+	if (rctx->assoc && err != -EINPROGRESS && err != -EBUSY)
 		kfree(rctx->assoc);
 	return err;
 }
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 9cbafaf6dd85..5b4b12b8a71a 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -213,16 +213,14 @@ static void pkcs1pad_encrypt_sign_complete_cb(
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
@@ -331,15 +329,14 @@ static void pkcs1pad_decrypt_complete_cb(
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
@@ -511,15 +508,14 @@ static void pkcs1pad_verify_complete_cb(
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
index 96d222c32acc..ae1d67d03625 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -25,7 +25,7 @@ static void seqiv_aead_encrypt_complete2(struct aead_request *req, int err)
 	struct aead_request *subreq = aead_request_ctx(req);
 	struct crypto_aead *geniv;
 
-	if (err == -EINPROGRESS)
+	if (err == -EINPROGRESS || err == -EBUSY)
 		return;
 
 	if (err)
diff --git a/drivers/acpi/acpica/Makefile b/drivers/acpi/acpica/Makefile
index 59700433a96e..f919811156b1 100644
--- a/drivers/acpi/acpica/Makefile
+++ b/drivers/acpi/acpica/Makefile
@@ -3,7 +3,7 @@
 # Makefile for ACPICA Core interpreter
 #
 
-ccflags-y			:= -Os -D_LINUX -DBUILDING_ACPICA
+ccflags-y			:= -D_LINUX -DBUILDING_ACPICA
 ccflags-$(CONFIG_ACPI_DEBUG)	+= -DACPI_DEBUG_OUTPUT
 
 # use acpi.o to put all files here into acpi.o modparam namespace
diff --git a/drivers/acpi/acpica/hwvalid.c b/drivers/acpi/acpica/hwvalid.c
index cd576153257c..f1495b88bf13 100644
--- a/drivers/acpi/acpica/hwvalid.c
+++ b/drivers/acpi/acpica/hwvalid.c
@@ -23,8 +23,8 @@ acpi_hw_validate_io_request(acpi_io_address address, u32 bit_width);
  *
  * The table is used to implement the Microsoft port access rules that
  * first appeared in Windows XP. Some ports are always illegal, and some
- * ports are only illegal if the BIOS calls _OSI with a win_XP string or
- * later (meaning that the BIOS itelf is post-XP.)
+ * ports are only illegal if the BIOS calls _OSI with nothing newer than
+ * the specific _OSI strings.
  *
  * This provides ACPICA with the desired port protections and
  * Microsoft compatibility.
@@ -145,7 +145,8 @@ acpi_hw_validate_io_request(acpi_io_address address, u32 bit_width)
 
 			/* Port illegality may depend on the _OSI calls made by the BIOS */
 
-			if (acpi_gbl_osi_data >= port_info->osi_dependency) {
+			if (port_info->osi_dependency == ACPI_ALWAYS_ILLEGAL ||
+			    acpi_gbl_osi_data == port_info->osi_dependency) {
 				ACPI_DEBUG_PRINT((ACPI_DB_VALUES,
 						  "Denied AML access to port 0x%8.8X%8.8X/%X (%s 0x%.4X-0x%.4X)\n",
 						  ACPI_FORMAT_UINT64(address),
diff --git a/drivers/acpi/acpica/nsrepair.c b/drivers/acpi/acpica/nsrepair.c
index be86fea8e4d4..57e6488f6933 100644
--- a/drivers/acpi/acpica/nsrepair.c
+++ b/drivers/acpi/acpica/nsrepair.c
@@ -181,8 +181,9 @@ acpi_ns_simple_repair(struct acpi_evaluate_info *info,
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
@@ -196,14 +197,15 @@ acpi_ns_simple_repair(struct acpi_evaluate_info *info,
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
index 974c2df13da1..a49a09e3de1b 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -465,7 +465,7 @@ static int extract_package(struct acpi_battery *battery,
 			u8 *ptr = (u8 *)battery + offsets[i].offset;
 			if (element->type == ACPI_TYPE_STRING ||
 			    element->type == ACPI_TYPE_BUFFER)
-				strncpy(ptr, element->string.pointer, 32);
+				strscpy(ptr, element->string.pointer, 32);
 			else if (element->type == ACPI_TYPE_INTEGER) {
 				strncpy(ptr, (u8 *)&element->integer.value,
 					sizeof(u64));
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index e5518b88f710..ef40cd7f36eb 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -316,7 +316,7 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 	 .ident = "Lenovo Ideapad Z570",
 	 .matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "102434U"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "Ideapad Z570"),
 		},
 	},
 	{
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 55745d6953f0..0c74daf6e2c9 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5529,8 +5529,7 @@ static void rbd_dev_release(struct device *dev)
 		module_put(THIS_MODULE);
 }
 
-static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
-					   struct rbd_spec *spec)
+static struct rbd_device *__rbd_dev_create(struct rbd_spec *spec)
 {
 	struct rbd_device *rbd_dev;
 
@@ -5575,9 +5574,6 @@ static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
 	rbd_dev->dev.parent = &rbd_root_dev;
 	device_initialize(&rbd_dev->dev);
 
-	rbd_dev->rbd_client = rbdc;
-	rbd_dev->spec = spec;
-
 	return rbd_dev;
 }
 
@@ -5590,12 +5586,10 @@ static struct rbd_device *rbd_dev_create(struct rbd_client *rbdc,
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
@@ -5612,6 +5606,10 @@ static struct rbd_device *rbd_dev_create(struct rbd_client *rbdc,
 	/* we have a ref from do_rbd_add() */
 	__module_get(THIS_MODULE);
 
+	rbd_dev->rbd_client = rbdc;
+	rbd_dev->spec = spec;
+	rbd_dev->opts = opts;
+
 	dout("%s rbd_dev %p dev_id %d\n", __func__, rbd_dev, rbd_dev->dev_id);
 	return rbd_dev;
 
@@ -6827,7 +6825,7 @@ static int rbd_dev_probe_parent(struct rbd_device *rbd_dev, int depth)
 		goto out_err;
 	}
 
-	parent = __rbd_dev_create(rbd_dev->rbd_client, rbd_dev->parent_spec);
+	parent = __rbd_dev_create(rbd_dev->parent_spec);
 	if (!parent) {
 		ret = -ENOMEM;
 		goto out_err;
@@ -6837,8 +6835,8 @@ static int rbd_dev_probe_parent(struct rbd_device *rbd_dev, int depth)
 	 * Images related by parent/child relationships always share
 	 * rbd_client and spec/parent_spec, so bump their refcounts.
 	 */
-	__rbd_get_client(rbd_dev->rbd_client);
-	rbd_spec_get(rbd_dev->parent_spec);
+	parent->rbd_client = __rbd_get_client(rbd_dev->rbd_client);
+	parent->spec = rbd_spec_get(rbd_dev->parent_spec);
 
 	ret = rbd_dev_image_probe(parent, depth);
 	if (ret < 0)
diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 60fb6c62f224..d6b69e19f78a 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -97,7 +97,7 @@
 #define SSIF_WATCH_WATCHDOG_TIMEOUT	msecs_to_jiffies(250)
 
 enum ssif_intf_state {
-	SSIF_NORMAL,
+	SSIF_IDLE,
 	SSIF_GETTING_FLAGS,
 	SSIF_GETTING_EVENTS,
 	SSIF_CLEARING_FLAGS,
@@ -105,8 +105,8 @@ enum ssif_intf_state {
 	/* FIXME - add watchdog stuff. */
 };
 
-#define SSIF_IDLE(ssif)	 ((ssif)->ssif_state == SSIF_NORMAL \
-			  && (ssif)->curr_msg == NULL)
+#define IS_SSIF_IDLE(ssif) ((ssif)->ssif_state == SSIF_IDLE \
+			    && (ssif)->curr_msg == NULL)
 
 /*
  * Indexes into stats[] in ssif_info below.
@@ -353,9 +353,9 @@ static void return_hosed_msg(struct ssif_info *ssif_info,
 
 /*
  * Must be called with the message lock held.  This will release the
- * message lock.  Note that the caller will check SSIF_IDLE and start a
- * new operation, so there is no need to check for new messages to
- * start in here.
+ * message lock.  Note that the caller will check IS_SSIF_IDLE and
+ * start a new operation, so there is no need to check for new
+ * messages to start in here.
  */
 static void start_clear_flags(struct ssif_info *ssif_info, unsigned long *flags)
 {
@@ -372,7 +372,7 @@ static void start_clear_flags(struct ssif_info *ssif_info, unsigned long *flags)
 
 	if (start_send(ssif_info, msg, 3) != 0) {
 		/* Error, just go to normal state. */
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 	}
 }
 
@@ -387,7 +387,7 @@ static void start_flag_fetch(struct ssif_info *ssif_info, unsigned long *flags)
 	mb[0] = (IPMI_NETFN_APP_REQUEST << 2);
 	mb[1] = IPMI_GET_MSG_FLAGS_CMD;
 	if (start_send(ssif_info, mb, 2) != 0)
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 }
 
 static void check_start_send(struct ssif_info *ssif_info, unsigned long *flags,
@@ -398,7 +398,7 @@ static void check_start_send(struct ssif_info *ssif_info, unsigned long *flags,
 
 		flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
 		ssif_info->curr_msg = NULL;
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		ipmi_free_smi_msg(msg);
 	}
@@ -412,7 +412,7 @@ static void start_event_fetch(struct ssif_info *ssif_info, unsigned long *flags)
 
 	msg = ipmi_alloc_smi_msg();
 	if (!msg) {
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -435,7 +435,7 @@ static void start_recv_msg_fetch(struct ssif_info *ssif_info,
 
 	msg = ipmi_alloc_smi_msg();
 	if (!msg) {
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -453,9 +453,9 @@ static void start_recv_msg_fetch(struct ssif_info *ssif_info,
 
 /*
  * Must be called with the message lock held.  This will release the
- * message lock.  Note that the caller will check SSIF_IDLE and start a
- * new operation, so there is no need to check for new messages to
- * start in here.
+ * message lock.  Note that the caller will check IS_SSIF_IDLE and
+ * start a new operation, so there is no need to check for new
+ * messages to start in here.
  */
 static void handle_flags(struct ssif_info *ssif_info, unsigned long *flags)
 {
@@ -471,7 +471,7 @@ static void handle_flags(struct ssif_info *ssif_info, unsigned long *flags)
 		/* Events available. */
 		start_event_fetch(ssif_info, flags);
 	else {
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 	}
 }
@@ -584,7 +584,7 @@ static void watch_timeout(struct timer_list *t)
 	if (ssif_info->watch_timeout) {
 		mod_timer(&ssif_info->watch_timer,
 			  jiffies + ssif_info->watch_timeout);
-		if (SSIF_IDLE(ssif_info)) {
+		if (IS_SSIF_IDLE(ssif_info)) {
 			start_flag_fetch(ssif_info, flags); /* Releases lock */
 			return;
 		}
@@ -787,7 +787,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 	}
 
 	switch (ssif_info->ssif_state) {
-	case SSIF_NORMAL:
+	case SSIF_IDLE:
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		if (!msg)
 			break;
@@ -805,7 +805,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 			 * Error fetching flags, or invalid length,
 			 * just give up for now.
 			 */
-			ssif_info->ssif_state = SSIF_NORMAL;
+			ssif_info->ssif_state = SSIF_IDLE;
 			ipmi_ssif_unlock_cond(ssif_info, flags);
 			dev_warn(&ssif_info->client->dev,
 				 "Error getting flags: %d %d, %x\n",
@@ -840,7 +840,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 				 "Invalid response clearing flags: %x %x\n",
 				 data[0], data[1]);
 		}
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		break;
 
@@ -918,7 +918,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 	}
 
 	flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
-	if (SSIF_IDLE(ssif_info) && !ssif_info->stopping) {
+	if (IS_SSIF_IDLE(ssif_info) && !ssif_info->stopping) {
 		if (ssif_info->req_events)
 			start_event_fetch(ssif_info, flags);
 		else if (ssif_info->req_flags)
@@ -1092,7 +1092,7 @@ static void start_next_msg(struct ssif_info *ssif_info, unsigned long *flags)
 	unsigned long oflags;
 
  restart:
-	if (!SSIF_IDLE(ssif_info)) {
+	if (!IS_SSIF_IDLE(ssif_info)) {
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -1315,7 +1315,7 @@ static void shutdown_ssif(void *send_info)
 	dev_set_drvdata(&ssif_info->client->dev, NULL);
 
 	/* make sure the driver is not looking for flags any more. */
-	while (ssif_info->ssif_state != SSIF_NORMAL)
+	while (ssif_info->ssif_state != SSIF_IDLE)
 		schedule_timeout(1);
 
 	ssif_info->stopping = true;
@@ -1886,7 +1886,7 @@ static int ssif_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	spin_lock_init(&ssif_info->lock);
-	ssif_info->ssif_state = SSIF_NORMAL;
+	ssif_info->ssif_state = SSIF_IDLE;
 	timer_setup(&ssif_info->retry_timer, retry_timeout, 0);
 	timer_setup(&ssif_info->watch_timer, watch_timeout, 0);
 
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index c002f83adf57..1c73668b4375 100644
--- a/drivers/clk/clk.c
+++ b/drivers/clk/clk.c
@@ -251,6 +251,17 @@ static bool clk_core_is_enabled(struct clk_core *core)
 		}
 	}
 
+	/*
+	 * This could be called with the enable lock held, or from atomic
+	 * context. If the parent isn't enabled already, we can't do
+	 * anything here. We can also assume this clock isn't enabled.
+	 */
+	if ((core->flags & CLK_OPS_PARENT_ENABLE) && core->parent)
+		if (!clk_core_is_enabled(core->parent)) {
+			ret = false;
+			goto done;
+		}
+
 	ret = core->ops->is_enabled(core->hw);
 done:
 	if (core->rpm_enabled)
diff --git a/drivers/clk/qcom/gcc-qcs404.c b/drivers/clk/qcom/gcc-qcs404.c
index bd32212f37e6..5982253b0330 100644
--- a/drivers/clk/qcom/gcc-qcs404.c
+++ b/drivers/clk/qcom/gcc-qcs404.c
@@ -25,11 +25,9 @@ enum {
 	P_CORE_BI_PLL_TEST_SE,
 	P_DSI0_PHY_PLL_OUT_BYTECLK,
 	P_DSI0_PHY_PLL_OUT_DSICLK,
-	P_GPLL0_OUT_AUX,
 	P_GPLL0_OUT_MAIN,
 	P_GPLL1_OUT_MAIN,
 	P_GPLL3_OUT_MAIN,
-	P_GPLL4_OUT_AUX,
 	P_GPLL4_OUT_MAIN,
 	P_GPLL6_OUT_AUX,
 	P_HDMI_PHY_PLL_CLK,
@@ -109,28 +107,24 @@ static const char * const gcc_parent_names_4[] = {
 static const struct parent_map gcc_parent_map_5[] = {
 	{ P_XO, 0 },
 	{ P_DSI0_PHY_PLL_OUT_BYTECLK, 1 },
-	{ P_GPLL0_OUT_AUX, 2 },
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
 static const char * const gcc_parent_names_5[] = {
 	"cxo",
-	"dsi0pll_byteclk_src",
-	"gpll0_out_aux",
+	"dsi0pllbyte",
 	"core_bi_pll_test_se",
 };
 
 static const struct parent_map gcc_parent_map_6[] = {
 	{ P_XO, 0 },
 	{ P_DSI0_PHY_PLL_OUT_BYTECLK, 2 },
-	{ P_GPLL0_OUT_AUX, 3 },
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
 static const char * const gcc_parent_names_6[] = {
 	"cxo",
-	"dsi0_phy_pll_out_byteclk",
-	"gpll0_out_aux",
+	"dsi0pllbyte",
 	"core_bi_pll_test_se",
 };
 
@@ -139,7 +133,6 @@ static const struct parent_map gcc_parent_map_7[] = {
 	{ P_GPLL0_OUT_MAIN, 1 },
 	{ P_GPLL3_OUT_MAIN, 2 },
 	{ P_GPLL6_OUT_AUX, 3 },
-	{ P_GPLL4_OUT_AUX, 4 },
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
@@ -148,7 +141,6 @@ static const char * const gcc_parent_names_7[] = {
 	"gpll0_out_main",
 	"gpll3_out_main",
 	"gpll6_out_aux",
-	"gpll4_out_aux",
 	"core_bi_pll_test_se",
 };
 
@@ -175,7 +167,7 @@ static const struct parent_map gcc_parent_map_9[] = {
 static const char * const gcc_parent_names_9[] = {
 	"cxo",
 	"gpll0_out_main",
-	"dsi0_phy_pll_out_dsiclk",
+	"dsi0pll",
 	"gpll6_out_aux",
 	"core_bi_pll_test_se",
 };
@@ -207,14 +199,12 @@ static const char * const gcc_parent_names_11[] = {
 static const struct parent_map gcc_parent_map_12[] = {
 	{ P_XO, 0 },
 	{ P_DSI0_PHY_PLL_OUT_DSICLK, 1 },
-	{ P_GPLL0_OUT_AUX, 2 },
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
 static const char * const gcc_parent_names_12[] = {
 	"cxo",
-	"dsi0pll_pclk_src",
-	"gpll0_out_aux",
+	"dsi0pll",
 	"core_bi_pll_test_se",
 };
 
@@ -237,40 +227,34 @@ static const char * const gcc_parent_names_13[] = {
 static const struct parent_map gcc_parent_map_14[] = {
 	{ P_XO, 0 },
 	{ P_GPLL0_OUT_MAIN, 1 },
-	{ P_GPLL4_OUT_AUX, 2 },
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
 static const char * const gcc_parent_names_14[] = {
 	"cxo",
 	"gpll0_out_main",
-	"gpll4_out_aux",
 	"core_bi_pll_test_se",
 };
 
 static const struct parent_map gcc_parent_map_15[] = {
 	{ P_XO, 0 },
-	{ P_GPLL0_OUT_AUX, 2 },
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
 static const char * const gcc_parent_names_15[] = {
 	"cxo",
-	"gpll0_out_aux",
 	"core_bi_pll_test_se",
 };
 
 static const struct parent_map gcc_parent_map_16[] = {
 	{ P_XO, 0 },
 	{ P_GPLL0_OUT_MAIN, 1 },
-	{ P_GPLL0_OUT_AUX, 2 },
 	{ P_CORE_BI_PLL_TEST_SE, 7 },
 };
 
 static const char * const gcc_parent_names_16[] = {
 	"cxo",
 	"gpll0_out_main",
-	"gpll0_out_aux",
 	"core_bi_pll_test_se",
 };
 
diff --git a/drivers/clk/qcom/gpucc-sdm845.c b/drivers/clk/qcom/gpucc-sdm845.c
index e40efba1bf7d..7a116f62168b 100644
--- a/drivers/clk/qcom/gpucc-sdm845.c
+++ b/drivers/clk/qcom/gpucc-sdm845.c
@@ -22,8 +22,6 @@
 #define CX_GMU_CBCR_SLEEP_SHIFT		4
 #define CX_GMU_CBCR_WAKE_MASK		0xf
 #define CX_GMU_CBCR_WAKE_SHIFT		8
-#define CLK_DIS_WAIT_SHIFT		12
-#define CLK_DIS_WAIT_MASK		(0xf << CLK_DIS_WAIT_SHIFT)
 
 enum {
 	P_BI_TCXO,
@@ -124,6 +122,7 @@ static struct clk_branch gpu_cc_cxo_clk = {
 static struct gdsc gpu_cx_gdsc = {
 	.gdscr = 0x106c,
 	.gds_hw_ctrl = 0x1540,
+	.clk_dis_wait_val = 0x8,
 	.pd = {
 		.name = "gpu_cx_gdsc",
 	},
@@ -221,10 +220,6 @@ static int gpu_cc_sdm845_probe(struct platform_device *pdev)
 	value = 0xf << CX_GMU_CBCR_WAKE_SHIFT | 0xf << CX_GMU_CBCR_SLEEP_SHIFT;
 	regmap_update_bits(regmap, 0x1098, mask, value);
 
-	/* Configure clk_dis_wait for gpu_cx_gdsc */
-	regmap_update_bits(regmap, 0x106c, CLK_DIS_WAIT_MASK,
-						8 << CLK_DIS_WAIT_SHIFT);
-
 	return qcom_cc_really_probe(pdev, &gpu_cc_sdm845_desc, regmap);
 }
 
diff --git a/drivers/clk/renesas/r7s9210-cpg-mssr.c b/drivers/clk/renesas/r7s9210-cpg-mssr.c
index cf65d4e0e116..2772eb0b8ba7 100644
--- a/drivers/clk/renesas/r7s9210-cpg-mssr.c
+++ b/drivers/clk/renesas/r7s9210-cpg-mssr.c
@@ -213,7 +213,7 @@ const struct cpg_mssr_info r7s9210_cpg_mssr_info __initconst = {
 	.cpg_clk_register = rza2_cpg_clk_register,
 
 	/* RZ/A2 has Standby Control Registers */
-	.stbyctrl = true,
+	.reg_layout = CLK_REG_LAYOUT_RZ_A,
 };
 
 static void __init r7s9210_cpg_mssr_early_init(struct device_node *np)
diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 6f9612c169af..d0ccb52b0270 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -111,12 +111,12 @@ static const u16 srcr[] = {
  * @rcdev: Optional reset controller entity
  * @dev: CPG/MSSR device
  * @base: CPG/MSSR register block base address
+ * @reg_layout: CPG/MSSR register layout
  * @rmw_lock: protects RMW register accesses
  * @np: Device node in DT for this CPG/MSSR module
  * @num_core_clks: Number of Core Clocks in clks[]
  * @num_mod_clks: Number of Module Clocks in clks[]
  * @last_dt_core_clk: ID of the last Core Clock exported to DT
- * @stbyctrl: This device has Standby Control Registers
  * @notifiers: Notifier chain to save/restore clock state for system resume
  * @smstpcr_saved[].mask: Mask of SMSTPCR[] bits under our control
  * @smstpcr_saved[].val: Saved values of SMSTPCR[]
@@ -128,13 +128,13 @@ struct cpg_mssr_priv {
 #endif
 	struct device *dev;
 	void __iomem *base;
+	enum clk_reg_layout reg_layout;
 	spinlock_t rmw_lock;
 	struct device_node *np;
 
 	unsigned int num_core_clks;
 	unsigned int num_mod_clks;
 	unsigned int last_dt_core_clk;
-	bool stbyctrl;
 
 	struct raw_notifier_head notifiers;
 	struct {
@@ -177,7 +177,7 @@ static int cpg_mstp_clock_endisable(struct clk_hw *hw, bool enable)
 		enable ? "ON" : "OFF");
 	spin_lock_irqsave(&priv->rmw_lock, flags);
 
-	if (priv->stbyctrl) {
+	if (priv->reg_layout == CLK_REG_LAYOUT_RZ_A) {
 		value = readb(priv->base + STBCR(reg));
 		if (enable)
 			value &= ~bitmask;
@@ -199,7 +199,7 @@ static int cpg_mstp_clock_endisable(struct clk_hw *hw, bool enable)
 
 	spin_unlock_irqrestore(&priv->rmw_lock, flags);
 
-	if (!enable || priv->stbyctrl)
+	if (!enable || priv->reg_layout == CLK_REG_LAYOUT_RZ_A)
 		return 0;
 
 	for (i = 1000; i > 0; --i) {
@@ -233,7 +233,7 @@ static int cpg_mstp_clock_is_enabled(struct clk_hw *hw)
 	struct cpg_mssr_priv *priv = clock->priv;
 	u32 value;
 
-	if (priv->stbyctrl)
+	if (priv->reg_layout == CLK_REG_LAYOUT_RZ_A)
 		value = readb(priv->base + STBCR(clock->index / 32));
 	else
 		value = readl(priv->base + MSTPSR(clock->index / 32));
@@ -272,7 +272,7 @@ struct clk *cpg_mssr_clk_src_twocell_get(struct of_phandle_args *clkspec,
 
 	case CPG_MOD:
 		type = "module";
-		if (priv->stbyctrl) {
+		if (priv->reg_layout == CLK_REG_LAYOUT_RZ_A) {
 			idx = MOD_CLK_PACK_10(clkidx);
 			range_check = 7 - (clkidx % 10);
 		} else {
@@ -800,7 +800,8 @@ static int cpg_mssr_suspend_noirq(struct device *dev)
 	/* Save module registers with bits under our control */
 	for (reg = 0; reg < ARRAY_SIZE(priv->smstpcr_saved); reg++) {
 		if (priv->smstpcr_saved[reg].mask)
-			priv->smstpcr_saved[reg].val = priv->stbyctrl ?
+			priv->smstpcr_saved[reg].val =
+				priv->reg_layout == CLK_REG_LAYOUT_RZ_A ?
 				readb(priv->base + STBCR(reg)) :
 				readl(priv->base + SMSTPCR(reg));
 	}
@@ -830,7 +831,7 @@ static int cpg_mssr_resume_noirq(struct device *dev)
 		if (!mask)
 			continue;
 
-		if (priv->stbyctrl)
+		if (priv->reg_layout == CLK_REG_LAYOUT_RZ_A)
 			oldval = readb(priv->base + STBCR(reg));
 		else
 			oldval = readl(priv->base + SMSTPCR(reg));
@@ -839,7 +840,7 @@ static int cpg_mssr_resume_noirq(struct device *dev)
 		if (newval == oldval)
 			continue;
 
-		if (priv->stbyctrl) {
+		if (priv->reg_layout == CLK_REG_LAYOUT_RZ_A) {
 			writeb(newval, priv->base + STBCR(reg));
 			/* dummy read to ensure write has completed */
 			readb(priv->base + STBCR(reg));
@@ -861,8 +862,7 @@ static int cpg_mssr_resume_noirq(struct device *dev)
 		}
 
 		if (!i)
-			dev_warn(dev, "Failed to enable %s%u[0x%x]\n",
-				 priv->stbyctrl ? "STB" : "SMSTP", reg,
+			dev_warn(dev, "Failed to enable SMSTP%u[0x%x]\n", reg,
 				 oldval & mask);
 	}
 
@@ -907,12 +907,11 @@ static int __init cpg_mssr_common_init(struct device *dev,
 		goto out_err;
 	}
 
-	cpg_mssr_priv = priv;
 	priv->num_core_clks = info->num_total_core_clks;
 	priv->num_mod_clks = info->num_hw_mod_clks;
 	priv->last_dt_core_clk = info->last_dt_core_clk;
 	RAW_INIT_NOTIFIER_HEAD(&priv->notifiers);
-	priv->stbyctrl = info->stbyctrl;
+	priv->reg_layout = info->reg_layout;
 
 	for (i = 0; i < nclks; i++)
 		priv->clks[i] = ERR_PTR(-ENOENT);
@@ -921,6 +920,8 @@ static int __init cpg_mssr_common_init(struct device *dev,
 	if (error)
 		goto out_err;
 
+	cpg_mssr_priv = priv;
+
 	return 0;
 
 out_err:
@@ -990,7 +991,7 @@ static int __init cpg_mssr_probe(struct platform_device *pdev)
 		return error;
 
 	/* Reset Controller not supported for Standby Control SoCs */
-	if (info->stbyctrl)
+	if (priv->reg_layout == CLK_REG_LAYOUT_RZ_A)
 		return 0;
 
 	error = cpg_mssr_reset_controller_register(priv);
diff --git a/drivers/clk/renesas/renesas-cpg-mssr.h b/drivers/clk/renesas/renesas-cpg-mssr.h
index 4ddcdf3bfb95..f05521b5fa6e 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.h
+++ b/drivers/clk/renesas/renesas-cpg-mssr.h
@@ -85,6 +85,11 @@ struct mssr_mod_clk {
 
 struct device_node;
 
+enum clk_reg_layout {
+	CLK_REG_LAYOUT_RCAR_GEN2_AND_GEN3 = 0,
+	CLK_REG_LAYOUT_RZ_A,
+};
+
     /**
      * SoC-specific CPG/MSSR Description
      *
@@ -105,6 +110,7 @@ struct device_node;
      * @crit_mod_clks: Array with Module Clock IDs of critical clocks that
      *                 should not be disabled without a knowledgeable driver
      * @num_crit_mod_clks: Number of entries in crit_mod_clks[]
+     * @reg_layout: CPG/MSSR register layout from enum clk_reg_layout
      *
      * @core_pm_clks: Array with IDs of Core Clocks that are suitable for Power
      *                Management, in addition to Module Clocks
@@ -112,10 +118,6 @@ struct device_node;
      *
      * @init: Optional callback to perform SoC-specific initialization
      * @cpg_clk_register: Optional callback to handle special Core Clock types
-     *
-     * @stbyctrl: This device has Standby Control Registers which are 8-bits
-     *            wide, no status registers (MSTPSR) and have different address
-     *            offsets.
      */
 
 struct cpg_mssr_info {
@@ -130,7 +132,7 @@ struct cpg_mssr_info {
 	unsigned int num_core_clks;
 	unsigned int last_dt_core_clk;
 	unsigned int num_total_core_clks;
-	bool stbyctrl;
+	enum clk_reg_layout reg_layout;
 
 	/* Module Clocks */
 	const struct mssr_mod_clk *mod_clks;
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 230e8902c727..b58f21dd3fed 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -521,7 +521,6 @@ static void crypto4xx_cipher_done(struct crypto4xx_device *dev,
 {
 	struct skcipher_request *req;
 	struct scatterlist *dst;
-	dma_addr_t addr;
 
 	req = skcipher_request_cast(pd_uinfo->async_req);
 
@@ -530,8 +529,8 @@ static void crypto4xx_cipher_done(struct crypto4xx_device *dev,
 					  req->cryptlen, req->dst);
 	} else {
 		dst = pd_uinfo->dest_va;
-		addr = dma_map_page(dev->core_dev->device, sg_page(dst),
-				    dst->offset, dst->length, DMA_FROM_DEVICE);
+		dma_unmap_page(dev->core_dev->device, pd->dest, dst->length,
+			       DMA_FROM_DEVICE);
 	}
 
 	if (pd_uinfo->sa_va->sa_command_0.bf.save_iv == SA_SAVE_IV) {
@@ -556,10 +555,9 @@ static void crypto4xx_ahash_done(struct crypto4xx_device *dev,
 	struct ahash_request *ahash_req;
 
 	ahash_req = ahash_request_cast(pd_uinfo->async_req);
-	ctx  = crypto_tfm_ctx(ahash_req->base.tfm);
+	ctx = crypto_ahash_ctx(crypto_ahash_reqtfm(ahash_req));
 
-	crypto4xx_copy_digest_to_dst(ahash_req->result, pd_uinfo,
-				     crypto_tfm_ctx(ahash_req->base.tfm));
+	crypto4xx_copy_digest_to_dst(ahash_req->result, pd_uinfo, ctx);
 	crypto4xx_ret_sg_desc(dev, pd_uinfo);
 
 	if (pd_uinfo->state & PD_ENTRY_BUSY)
diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
index b9299defb431..e416456b2b8a 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -643,14 +643,26 @@ static void ccp_dma_release(struct ccp_device *ccp)
 		chan = ccp->ccp_dma_chan + i;
 		dma_chan = &chan->dma_chan;
 
-		if (dma_chan->client_count)
-			dma_release_channel(dma_chan);
-
 		tasklet_kill(&chan->cleanup_tasklet);
 		list_del_rcu(&dma_chan->device_node);
 	}
 }
 
+static void ccp_dma_release_channels(struct ccp_device *ccp)
+{
+	struct ccp_dma_chan *chan;
+	struct dma_chan *dma_chan;
+	unsigned int i;
+
+	for (i = 0; i < ccp->cmd_q_count; i++) {
+		chan = ccp->ccp_dma_chan + i;
+		dma_chan = &chan->dma_chan;
+
+		if (dma_chan->client_count)
+			dma_release_channel(dma_chan);
+	}
+}
+
 int ccp_dmaengine_register(struct ccp_device *ccp)
 {
 	struct ccp_dma_chan *chan;
@@ -771,8 +783,9 @@ void ccp_dmaengine_unregister(struct ccp_device *ccp)
 	if (!dmaengine)
 		return;
 
-	ccp_dma_release(ccp);
+	ccp_dma_release_channels(ccp);
 	dma_async_device_unregister(dma_dev);
+	ccp_dma_release(ccp);
 
 	kmem_cache_destroy(ccp->dma_desc_cache);
 	kmem_cache_destroy(ccp->dma_cmd_cache);
diff --git a/drivers/firmware/google/framebuffer-coreboot.c b/drivers/firmware/google/framebuffer-coreboot.c
index 916f26adc595..922c079d13c8 100644
--- a/drivers/firmware/google/framebuffer-coreboot.c
+++ b/drivers/firmware/google/framebuffer-coreboot.c
@@ -43,9 +43,7 @@ static int framebuffer_probe(struct coreboot_device *dev)
 		    fb->green_mask_pos     == formats[i].green.offset &&
 		    fb->green_mask_size    == formats[i].green.length &&
 		    fb->blue_mask_pos      == formats[i].blue.offset &&
-		    fb->blue_mask_size     == formats[i].blue.length &&
-		    fb->reserved_mask_pos  == formats[i].transp.offset &&
-		    fb->reserved_mask_size == formats[i].transp.length)
+		    fb->blue_mask_size     == formats[i].blue.length)
 			pdata.format = formats[i].name;
 	}
 	if (!pdata.format)
diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index 1ae612c796ee..396a687e020f 100644
--- a/drivers/gpio/gpio-vf610.c
+++ b/drivers/gpio/gpio-vf610.c
@@ -304,7 +304,7 @@ static int vf610_gpio_probe(struct platform_device *pdev)
 	gc = &port->gc;
 	gc->of_node = np;
 	gc->parent = dev;
-	gc->label = "vf610-gpio";
+	gc->label = dev_name(dev);
 	gc->ngpio = VF610_GPIO_PER_PORT;
 	gc->base = of_alias_get_id(np, "gpio") * VF610_GPIO_PER_PORT;
 
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 9fd711005c1f..1e7083bc8a52 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1206,12 +1206,14 @@ static int dm_resume(void *handle)
 	list_for_each_entry(connector, &ddev->mode_config.connector_list, head) {
 		aconnector = to_amdgpu_dm_connector(connector);
 
+		if (!aconnector->dc_link)
+			continue;
+
 		/*
 		 * this is the case when traversing through already created
 		 * MST connectors, should be skipped
 		 */
-		if (aconnector->dc_link &&
-		    aconnector->dc_link->type == dc_connection_mst_branch)
+		if (aconnector->dc_link->type == dc_connection_mst_branch)
 			continue;
 
 		mutex_lock(&aconnector->hpd_lock);
diff --git a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
index b72f6f541d4e..14d578fce09f 100644
--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -426,7 +426,11 @@ static int __init stdpxxxx_ge_b850v3_init(void)
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
 
diff --git a/drivers/gpu/drm/drm_atomic_helper.c b/drivers/gpu/drm/drm_atomic_helper.c
index 5e906ea6df67..62b77f3a950b 100644
--- a/drivers/gpu/drm/drm_atomic_helper.c
+++ b/drivers/gpu/drm/drm_atomic_helper.c
@@ -445,8 +445,9 @@ mode_fixup(struct drm_atomic_state *state)
 		encoder = new_conn_state->best_encoder;
 		funcs = encoder->helper_private;
 
-		ret = drm_bridge_mode_fixup(encoder->bridge, &new_crtc_state->mode,
-				&new_crtc_state->adjusted_mode);
+		ret = drm_bridge_chain_mode_fixup(encoder->bridge,
+					&new_crtc_state->mode,
+					&new_crtc_state->adjusted_mode);
 		if (!ret) {
 			DRM_DEBUG_ATOMIC("Bridge fixup failed\n");
 			return -EINVAL;
@@ -511,7 +512,7 @@ static enum drm_mode_status mode_valid_path(struct drm_connector *connector,
 		return ret;
 	}
 
-	ret = drm_bridge_mode_valid(encoder->bridge, mode);
+	ret = drm_bridge_chain_mode_valid(encoder->bridge, mode);
 	if (ret != MODE_OK) {
 		DRM_DEBUG_ATOMIC("[BRIDGE] mode_valid() failed\n");
 		return ret;
@@ -588,6 +589,7 @@ mode_valid(struct drm_atomic_state *state)
  * &drm_crtc_state.connectors_changed is set when a connector is added or
  * removed from the crtc.  &drm_crtc_state.active_changed is set when
  * &drm_crtc_state.active changes, which is used for DPMS.
+ * &drm_crtc_state.no_vblank is set from the result of drm_dev_has_vblank().
  * See also: drm_atomic_crtc_needs_modeset()
  *
  * IMPORTANT:
@@ -654,6 +656,11 @@ drm_atomic_helper_check_modeset(struct drm_device *dev,
 
 			return -EINVAL;
 		}
+
+		if (drm_dev_has_vblank(dev))
+			new_crtc_state->no_vblank = false;
+		else
+			new_crtc_state->no_vblank = true;
 	}
 
 	ret = handle_conflicting_encoders(state, false);
@@ -1030,7 +1037,7 @@ disable_outputs(struct drm_device *dev, struct drm_atomic_state *old_state)
 		 * Each encoder has at most one connector (since we always steal
 		 * it away), so we won't call disable hooks twice.
 		 */
-		drm_atomic_bridge_disable(encoder->bridge, old_state);
+		drm_atomic_bridge_chain_disable(encoder->bridge, old_state);
 
 		/* Right function depends upon target state. */
 		if (funcs) {
@@ -1044,7 +1051,8 @@ disable_outputs(struct drm_device *dev, struct drm_atomic_state *old_state)
 				funcs->dpms(encoder, DRM_MODE_DPMS_OFF);
 		}
 
-		drm_atomic_bridge_post_disable(encoder->bridge, old_state);
+		drm_atomic_bridge_chain_post_disable(encoder->bridge,
+						     old_state);
 	}
 
 	for_each_oldnew_crtc_in_state(old_state, crtc, old_crtc_state, new_crtc_state, i) {
@@ -1225,7 +1233,8 @@ crtc_set_mode(struct drm_device *dev, struct drm_atomic_state *old_state)
 			funcs->mode_set(encoder, mode, adjusted_mode);
 		}
 
-		drm_bridge_mode_set(encoder->bridge, mode, adjusted_mode);
+		drm_bridge_chain_mode_set(encoder->bridge, mode,
+					  adjusted_mode);
 	}
 }
 
@@ -1342,7 +1351,7 @@ void drm_atomic_helper_commit_modeset_enables(struct drm_device *dev,
 		 * Each encoder has at most one connector (since we always steal
 		 * it away), so we won't call enable hooks twice.
 		 */
-		drm_atomic_bridge_pre_enable(encoder->bridge, old_state);
+		drm_atomic_bridge_chain_pre_enable(encoder->bridge, old_state);
 
 		if (funcs) {
 			if (funcs->atomic_enable)
@@ -1353,7 +1362,7 @@ void drm_atomic_helper_commit_modeset_enables(struct drm_device *dev,
 				funcs->commit(encoder);
 		}
 
-		drm_atomic_bridge_enable(encoder->bridge, old_state);
+		drm_atomic_bridge_chain_enable(encoder->bridge, old_state);
 	}
 
 	drm_atomic_helper_commit_writebacks(dev, old_state);
@@ -2202,7 +2211,9 @@ EXPORT_SYMBOL(drm_atomic_helper_wait_for_dependencies);
  * when a job is queued, and any change to the pipeline that does not touch the
  * connector is leading to timeouts when calling
  * drm_atomic_helper_wait_for_vblanks() or
- * drm_atomic_helper_wait_for_flip_done().
+ * drm_atomic_helper_wait_for_flip_done(). In addition to writeback
+ * connectors, this function can also fake VBLANK events for CRTCs without
+ * VBLANK interrupt.
  *
  * This is part of the atomic helper support for nonblocking commits, see
  * drm_atomic_helper_setup_commit() for an overview.
diff --git a/drivers/gpu/drm/drm_bridge.c b/drivers/gpu/drm/drm_bridge.c
index cba537c99e43..54c874493c57 100644
--- a/drivers/gpu/drm/drm_bridge.c
+++ b/drivers/gpu/drm/drm_bridge.c
@@ -172,8 +172,8 @@ void drm_bridge_detach(struct drm_bridge *bridge)
  */
 
 /**
- * drm_bridge_mode_fixup - fixup proposed mode for all bridges in the
- *			   encoder chain
+ * drm_bridge_chain_mode_fixup - fixup proposed mode for all bridges in the
+ *				 encoder chain
  * @bridge: bridge control structure
  * @mode: desired mode to be set for the bridge
  * @adjusted_mode: updated mode that works for this bridge
@@ -186,9 +186,9 @@ void drm_bridge_detach(struct drm_bridge *bridge)
  * RETURNS:
  * true on success, false on failure
  */
-bool drm_bridge_mode_fixup(struct drm_bridge *bridge,
-			const struct drm_display_mode *mode,
-			struct drm_display_mode *adjusted_mode)
+bool drm_bridge_chain_mode_fixup(struct drm_bridge *bridge,
+				 const struct drm_display_mode *mode,
+				 struct drm_display_mode *adjusted_mode)
 {
 	bool ret = true;
 
@@ -198,15 +198,16 @@ bool drm_bridge_mode_fixup(struct drm_bridge *bridge,
 	if (bridge->funcs->mode_fixup)
 		ret = bridge->funcs->mode_fixup(bridge, mode, adjusted_mode);
 
-	ret = ret && drm_bridge_mode_fixup(bridge->next, mode, adjusted_mode);
+	ret = ret && drm_bridge_chain_mode_fixup(bridge->next, mode,
+						 adjusted_mode);
 
 	return ret;
 }
-EXPORT_SYMBOL(drm_bridge_mode_fixup);
+EXPORT_SYMBOL(drm_bridge_chain_mode_fixup);
 
 /**
- * drm_bridge_mode_valid - validate the mode against all bridges in the
- * 			   encoder chain.
+ * drm_bridge_chain_mode_valid - validate the mode against all bridges in the
+ *				 encoder chain.
  * @bridge: bridge control structure
  * @mode: desired mode to be validated
  *
@@ -219,8 +220,9 @@ EXPORT_SYMBOL(drm_bridge_mode_fixup);
  * RETURNS:
  * MODE_OK on success, drm_mode_status Enum error code on failure
  */
-enum drm_mode_status drm_bridge_mode_valid(struct drm_bridge *bridge,
-					   const struct drm_display_mode *mode)
+enum drm_mode_status
+drm_bridge_chain_mode_valid(struct drm_bridge *bridge,
+			    const struct drm_display_mode *mode)
 {
 	enum drm_mode_status ret = MODE_OK;
 
@@ -233,12 +235,12 @@ enum drm_mode_status drm_bridge_mode_valid(struct drm_bridge *bridge,
 	if (ret != MODE_OK)
 		return ret;
 
-	return drm_bridge_mode_valid(bridge->next, mode);
+	return drm_bridge_chain_mode_valid(bridge->next, mode);
 }
-EXPORT_SYMBOL(drm_bridge_mode_valid);
+EXPORT_SYMBOL(drm_bridge_chain_mode_valid);
 
 /**
- * drm_bridge_disable - disables all bridges in the encoder chain
+ * drm_bridge_chain_disable - disables all bridges in the encoder chain
  * @bridge: bridge control structure
  *
  * Calls &drm_bridge_funcs.disable op for all the bridges in the encoder
@@ -247,20 +249,21 @@ EXPORT_SYMBOL(drm_bridge_mode_valid);
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_bridge_disable(struct drm_bridge *bridge)
+void drm_bridge_chain_disable(struct drm_bridge *bridge)
 {
 	if (!bridge)
 		return;
 
-	drm_bridge_disable(bridge->next);
+	drm_bridge_chain_disable(bridge->next);
 
 	if (bridge->funcs->disable)
 		bridge->funcs->disable(bridge);
 }
-EXPORT_SYMBOL(drm_bridge_disable);
+EXPORT_SYMBOL(drm_bridge_chain_disable);
 
 /**
- * drm_bridge_post_disable - cleans up after disabling all bridges in the encoder chain
+ * drm_bridge_chain_post_disable - cleans up after disabling all bridges in the
+ *				   encoder chain
  * @bridge: bridge control structure
  *
  * Calls &drm_bridge_funcs.post_disable op for all the bridges in the
@@ -269,7 +272,7 @@ EXPORT_SYMBOL(drm_bridge_disable);
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_bridge_post_disable(struct drm_bridge *bridge)
+void drm_bridge_chain_post_disable(struct drm_bridge *bridge)
 {
 	if (!bridge)
 		return;
@@ -277,25 +280,25 @@ void drm_bridge_post_disable(struct drm_bridge *bridge)
 	if (bridge->funcs->post_disable)
 		bridge->funcs->post_disable(bridge);
 
-	drm_bridge_post_disable(bridge->next);
+	drm_bridge_chain_post_disable(bridge->next);
 }
-EXPORT_SYMBOL(drm_bridge_post_disable);
+EXPORT_SYMBOL(drm_bridge_chain_post_disable);
 
 /**
- * drm_bridge_mode_set - set proposed mode for all bridges in the
- *			 encoder chain
+ * drm_bridge_chain_mode_set - set proposed mode for all bridges in the
+ *			       encoder chain
  * @bridge: bridge control structure
- * @mode: desired mode to be set for the bridge
- * @adjusted_mode: updated mode that works for this bridge
+ * @mode: desired mode to be set for the encoder chain
+ * @adjusted_mode: updated mode that works for this encoder chain
  *
  * Calls &drm_bridge_funcs.mode_set op for all the bridges in the
  * encoder chain, starting from the first bridge to the last.
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_bridge_mode_set(struct drm_bridge *bridge,
-			 const struct drm_display_mode *mode,
-			 const struct drm_display_mode *adjusted_mode)
+void drm_bridge_chain_mode_set(struct drm_bridge *bridge,
+			       const struct drm_display_mode *mode,
+			       const struct drm_display_mode *adjusted_mode)
 {
 	if (!bridge)
 		return;
@@ -303,13 +306,13 @@ void drm_bridge_mode_set(struct drm_bridge *bridge,
 	if (bridge->funcs->mode_set)
 		bridge->funcs->mode_set(bridge, mode, adjusted_mode);
 
-	drm_bridge_mode_set(bridge->next, mode, adjusted_mode);
+	drm_bridge_chain_mode_set(bridge->next, mode, adjusted_mode);
 }
-EXPORT_SYMBOL(drm_bridge_mode_set);
+EXPORT_SYMBOL(drm_bridge_chain_mode_set);
 
 /**
- * drm_bridge_pre_enable - prepares for enabling all
- *			   bridges in the encoder chain
+ * drm_bridge_chain_pre_enable - prepares for enabling all bridges in the
+ *				 encoder chain
  * @bridge: bridge control structure
  *
  * Calls &drm_bridge_funcs.pre_enable op for all the bridges in the encoder
@@ -318,20 +321,20 @@ EXPORT_SYMBOL(drm_bridge_mode_set);
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_bridge_pre_enable(struct drm_bridge *bridge)
+void drm_bridge_chain_pre_enable(struct drm_bridge *bridge)
 {
 	if (!bridge)
 		return;
 
-	drm_bridge_pre_enable(bridge->next);
+	drm_bridge_chain_pre_enable(bridge->next);
 
 	if (bridge->funcs->pre_enable)
 		bridge->funcs->pre_enable(bridge);
 }
-EXPORT_SYMBOL(drm_bridge_pre_enable);
+EXPORT_SYMBOL(drm_bridge_chain_pre_enable);
 
 /**
- * drm_bridge_enable - enables all bridges in the encoder chain
+ * drm_bridge_chain_enable - enables all bridges in the encoder chain
  * @bridge: bridge control structure
  *
  * Calls &drm_bridge_funcs.enable op for all the bridges in the encoder
@@ -340,7 +343,7 @@ EXPORT_SYMBOL(drm_bridge_pre_enable);
  *
  * Note that the bridge passed should be the one closest to the encoder
  */
-void drm_bridge_enable(struct drm_bridge *bridge)
+void drm_bridge_chain_enable(struct drm_bridge *bridge)
 {
 	if (!bridge)
 		return;
@@ -348,12 +351,12 @@ void drm_bridge_enable(struct drm_bridge *bridge)
 	if (bridge->funcs->enable)
 		bridge->funcs->enable(bridge);
 
-	drm_bridge_enable(bridge->next);
+	drm_bridge_chain_enable(bridge->next);
 }
-EXPORT_SYMBOL(drm_bridge_enable);
+EXPORT_SYMBOL(drm_bridge_chain_enable);
 
 /**
- * drm_atomic_bridge_disable - disables all bridges in the encoder chain
+ * drm_atomic_bridge_chain_disable - disables all bridges in the encoder chain
  * @bridge: bridge control structure
  * @state: atomic state being committed
  *
@@ -364,24 +367,24 @@ EXPORT_SYMBOL(drm_bridge_enable);
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_atomic_bridge_disable(struct drm_bridge *bridge,
-			       struct drm_atomic_state *state)
+void drm_atomic_bridge_chain_disable(struct drm_bridge *bridge,
+				     struct drm_atomic_state *state)
 {
 	if (!bridge)
 		return;
 
-	drm_atomic_bridge_disable(bridge->next, state);
+	drm_atomic_bridge_chain_disable(bridge->next, state);
 
 	if (bridge->funcs->atomic_disable)
 		bridge->funcs->atomic_disable(bridge, state);
 	else if (bridge->funcs->disable)
 		bridge->funcs->disable(bridge);
 }
-EXPORT_SYMBOL(drm_atomic_bridge_disable);
+EXPORT_SYMBOL(drm_atomic_bridge_chain_disable);
 
 /**
- * drm_atomic_bridge_post_disable - cleans up after disabling all bridges in the
- *				    encoder chain
+ * drm_atomic_bridge_chain_post_disable - cleans up after disabling all bridges
+ *					  in the encoder chain
  * @bridge: bridge control structure
  * @state: atomic state being committed
  *
@@ -392,8 +395,8 @@ EXPORT_SYMBOL(drm_atomic_bridge_disable);
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_atomic_bridge_post_disable(struct drm_bridge *bridge,
-				    struct drm_atomic_state *state)
+void drm_atomic_bridge_chain_post_disable(struct drm_bridge *bridge,
+					  struct drm_atomic_state *state)
 {
 	if (!bridge)
 		return;
@@ -403,13 +406,13 @@ void drm_atomic_bridge_post_disable(struct drm_bridge *bridge,
 	else if (bridge->funcs->post_disable)
 		bridge->funcs->post_disable(bridge);
 
-	drm_atomic_bridge_post_disable(bridge->next, state);
+	drm_atomic_bridge_chain_post_disable(bridge->next, state);
 }
-EXPORT_SYMBOL(drm_atomic_bridge_post_disable);
+EXPORT_SYMBOL(drm_atomic_bridge_chain_post_disable);
 
 /**
- * drm_atomic_bridge_pre_enable - prepares for enabling all bridges in the
- *				  encoder chain
+ * drm_atomic_bridge_chain_pre_enable - prepares for enabling all bridges in
+ *					the encoder chain
  * @bridge: bridge control structure
  * @state: atomic state being committed
  *
@@ -420,23 +423,23 @@ EXPORT_SYMBOL(drm_atomic_bridge_post_disable);
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_atomic_bridge_pre_enable(struct drm_bridge *bridge,
-				  struct drm_atomic_state *state)
+void drm_atomic_bridge_chain_pre_enable(struct drm_bridge *bridge,
+					struct drm_atomic_state *state)
 {
 	if (!bridge)
 		return;
 
-	drm_atomic_bridge_pre_enable(bridge->next, state);
+	drm_atomic_bridge_chain_pre_enable(bridge->next, state);
 
 	if (bridge->funcs->atomic_pre_enable)
 		bridge->funcs->atomic_pre_enable(bridge, state);
 	else if (bridge->funcs->pre_enable)
 		bridge->funcs->pre_enable(bridge);
 }
-EXPORT_SYMBOL(drm_atomic_bridge_pre_enable);
+EXPORT_SYMBOL(drm_atomic_bridge_chain_pre_enable);
 
 /**
- * drm_atomic_bridge_enable - enables all bridges in the encoder chain
+ * drm_atomic_bridge_chain_enable - enables all bridges in the encoder chain
  * @bridge: bridge control structure
  * @state: atomic state being committed
  *
@@ -447,8 +450,8 @@ EXPORT_SYMBOL(drm_atomic_bridge_pre_enable);
  *
  * Note: the bridge passed should be the one closest to the encoder
  */
-void drm_atomic_bridge_enable(struct drm_bridge *bridge,
-			      struct drm_atomic_state *state)
+void drm_atomic_bridge_chain_enable(struct drm_bridge *bridge,
+				    struct drm_atomic_state *state)
 {
 	if (!bridge)
 		return;
@@ -458,9 +461,9 @@ void drm_atomic_bridge_enable(struct drm_bridge *bridge,
 	else if (bridge->funcs->enable)
 		bridge->funcs->enable(bridge);
 
-	drm_atomic_bridge_enable(bridge->next, state);
+	drm_atomic_bridge_chain_enable(bridge->next, state);
 }
-EXPORT_SYMBOL(drm_atomic_bridge_enable);
+EXPORT_SYMBOL(drm_atomic_bridge_chain_enable);
 
 #ifdef CONFIG_OF
 /**
diff --git a/drivers/gpu/drm/drm_encoder.c b/drivers/gpu/drm/drm_encoder.c
index 7fb47b7b8b44..80ce9e1040de 100644
--- a/drivers/gpu/drm/drm_encoder.c
+++ b/drivers/gpu/drm/drm_encoder.c
@@ -170,7 +170,7 @@ void drm_encoder_cleanup(struct drm_encoder *encoder)
 		struct drm_bridge *next;
 
 		while (bridge) {
-			next = bridge->next;
+			next = drm_bridge_get_next_bridge(bridge);
 			drm_bridge_detach(bridge);
 			bridge = next;
 		}
diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index c630064ccf41..d88a312962b3 100644
--- a/drivers/gpu/drm/drm_fourcc.c
+++ b/drivers/gpu/drm/drm_fourcc.c
@@ -178,6 +178,10 @@ const struct drm_format_info *__drm_format_info(u32 format)
 		{ .format = DRM_FORMAT_BGRA5551,	.depth = 15, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1, .has_alpha = true },
 		{ .format = DRM_FORMAT_RGB565,		.depth = 16, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
 		{ .format = DRM_FORMAT_BGR565,		.depth = 16, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
+#ifdef __BIG_ENDIAN
+		{ .format = DRM_FORMAT_XRGB1555 | DRM_FORMAT_BIG_ENDIAN, .depth = 15, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
+		{ .format = DRM_FORMAT_RGB565 | DRM_FORMAT_BIG_ENDIAN, .depth = 16, .num_planes = 1, .cpp = { 2, 0, 0 }, .hsub = 1, .vsub = 1 },
+#endif
 		{ .format = DRM_FORMAT_RGB888,		.depth = 24, .num_planes = 1, .cpp = { 3, 0, 0 }, .hsub = 1, .vsub = 1 },
 		{ .format = DRM_FORMAT_BGR888,		.depth = 24, .num_planes = 1, .cpp = { 3, 0, 0 }, .hsub = 1, .vsub = 1 },
 		{ .format = DRM_FORMAT_XRGB8888,	.depth = 24, .num_planes = 1, .cpp = { 4, 0, 0 }, .hsub = 1, .vsub = 1 },
diff --git a/drivers/gpu/drm/drm_mipi_dsi.c b/drivers/gpu/drm/drm_mipi_dsi.c
index bb7f72ade628..b942c69e9b48 100644
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
diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index ce739ba45c55..8768073794fb 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -278,6 +278,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad D330-10IGL"),
 		},
 		.driver_data = (void *)&lcd800x1280_rightside_up,
+	}, {	/* Lenovo IdeaPad Duet 3 10IGL5 */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "IdeaPad Duet 3 10IGL5"),
+		},
+		.driver_data = (void *)&lcd1200x1920_rightside_up,
 	}, {	/* Lenovo Yoga Book X90F / X91F / X91L */
 		.matches = {
 		  /* Non exact match to match all versions */
diff --git a/drivers/gpu/drm/drm_probe_helper.c b/drivers/gpu/drm/drm_probe_helper.c
index ef2c468205a2..d45f43feaf86 100644
--- a/drivers/gpu/drm/drm_probe_helper.c
+++ b/drivers/gpu/drm/drm_probe_helper.c
@@ -112,7 +112,7 @@ drm_mode_validate_pipeline(struct drm_display_mode *mode,
 			continue;
 		}
 
-		ret = drm_bridge_mode_valid(encoder->bridge, mode);
+		ret = drm_bridge_chain_mode_valid(encoder->bridge, mode);
 		if (ret != MODE_OK) {
 			/* There is also no point in continuing for crtc check
 			 * here. */
diff --git a/drivers/gpu/drm/drm_vblank.c b/drivers/gpu/drm/drm_vblank.c
index 552ec82e9bc5..c98ed8146242 100644
--- a/drivers/gpu/drm/drm_vblank.c
+++ b/drivers/gpu/drm/drm_vblank.c
@@ -69,6 +69,12 @@
  * &drm_driver.max_vblank_count. In that case the vblank core only disables the
  * vblanks after a timer has expired, which can be configured through the
  * ``vblankoffdelay`` module parameter.
+ *
+ * Drivers for hardware without support for vertical-blanking interrupts
+ * must not call drm_vblank_init(). For such drivers, atomic helpers will
+ * automatically generate fake vblank events as part of the display update.
+ * This functionality also can be controlled by the driver by enabling and
+ * disabling struct drm_crtc_state.no_vblank.
  */
 
 /* Retry timestamp calculation up to 3 times to satisfy
@@ -488,6 +494,28 @@ int drm_vblank_init(struct drm_device *dev, unsigned int num_crtcs)
 }
 EXPORT_SYMBOL(drm_vblank_init);
 
+/**
+ * drm_dev_has_vblank - test if vblanking has been initialized for
+ *                      a device
+ * @dev: the device
+ *
+ * Drivers may call this function to test if vblank support is
+ * initialized for a device. For most hardware this means that vblanking
+ * can also be enabled.
+ *
+ * Atomic helpers use this function to initialize
+ * &drm_crtc_state.no_vblank. See also drm_atomic_helper_check_modeset().
+ *
+ * Returns:
+ * True if vblanking has been initialized for the given device, false
+ * otherwise.
+ */
+bool drm_dev_has_vblank(const struct drm_device *dev)
+{
+	return dev->num_crtcs != 0;
+}
+EXPORT_SYMBOL(drm_dev_has_vblank);
+
 /**
  * drm_crtc_vblank_waitqueue - get vblank waitqueue for the CRTC
  * @crtc: which CRTC's vblank waitqueue to retrieve
diff --git a/drivers/gpu/drm/exynos/exynos_dp.c b/drivers/gpu/drm/exynos/exynos_dp.c
index e0cfae744afc..01c5fbf9083a 100644
--- a/drivers/gpu/drm/exynos/exynos_dp.c
+++ b/drivers/gpu/drm/exynos/exynos_dp.c
@@ -109,7 +109,6 @@ static int exynos_dp_bridge_attach(struct analogix_dp_plat_data *plat_data,
 		if (ret) {
 			DRM_DEV_ERROR(dp->dev,
 				      "Failed to attach bridge to drm\n");
-			bridge->next = NULL;
 			return ret;
 		}
 	}
diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index b83acd696774..babf3db82ce3 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -1389,7 +1389,7 @@ static void exynos_dsi_enable(struct drm_encoder *encoder)
 		if (ret < 0)
 			goto err_put_sync;
 	} else {
-		drm_bridge_pre_enable(dsi->out_bridge);
+		drm_bridge_chain_pre_enable(dsi->out_bridge);
 	}
 
 	exynos_dsi_set_display_mode(dsi);
@@ -1400,7 +1400,7 @@ static void exynos_dsi_enable(struct drm_encoder *encoder)
 		if (ret < 0)
 			goto err_display_disable;
 	} else {
-		drm_bridge_enable(dsi->out_bridge);
+		drm_bridge_chain_enable(dsi->out_bridge);
 	}
 
 	dsi->state |= DSIM_STATE_VIDOUT_AVAILABLE;
@@ -1425,10 +1425,10 @@ static void exynos_dsi_disable(struct drm_encoder *encoder)
 	dsi->state &= ~DSIM_STATE_VIDOUT_AVAILABLE;
 
 	drm_panel_disable(dsi->panel);
-	drm_bridge_disable(dsi->out_bridge);
+	drm_bridge_chain_disable(dsi->out_bridge);
 	exynos_dsi_set_display_enable(dsi, false);
 	drm_panel_unprepare(dsi->panel);
-	drm_bridge_post_disable(dsi->out_bridge);
+	drm_bridge_chain_post_disable(dsi->out_bridge);
 	dsi->state &= ~DSIM_STATE_ENABLED;
 	pm_runtime_put_sync(dsi->dev);
 }
diff --git a/drivers/gpu/drm/i915/display/intel_quirks.c b/drivers/gpu/drm/i915/display/intel_quirks.c
index d79314992ada..59f02f39e952 100644
--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -149,6 +149,8 @@ static struct intel_quirk intel_quirks[] = {
 	/* ECS Liva Q2 */
 	{ 0x3185, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
 	{ 0x3184, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
+	/* HP Notebook - 14-r206nv */
+	{ 0x0f31, 0x103c, 0x220f, quirk_invert_brightness },
 };
 
 void intel_init_quirks(struct drm_i915_private *i915)
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index f98bb2e26372..5569454ad9e4 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -417,6 +417,7 @@ static int mtk_drm_bind(struct device *dev)
 err_deinit:
 	mtk_drm_kms_deinit(drm);
 err_free:
+	private->drm = NULL;
 	drm_dev_put(drm);
 	return ret;
 }
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_gem.c b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
index ca672f1d140d..2fa432287d69 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
@@ -142,8 +142,6 @@ static int mtk_drm_gem_object_mmap(struct drm_gem_object *obj,
 
 	ret = dma_mmap_attrs(priv->dma_dev, vma, mtk_gem->cookie,
 			     mtk_gem->dma_addr, obj->size, mtk_gem->dma_attrs);
-	if (ret)
-		drm_gem_vm_close(vma);
 
 	return ret;
 }
@@ -271,7 +269,7 @@ void *mtk_drm_gem_prime_vmap(struct drm_gem_object *obj)
 			       pgprot_writecombine(PAGE_KERNEL));
 
 out:
-	kfree((void *)sgt);
+	kfree(sgt);
 
 	return mtk_gem->kvaddr;
 }
@@ -284,6 +282,6 @@ void mtk_drm_gem_prime_vunmap(struct drm_gem_object *obj, void *vaddr)
 		return;
 
 	vunmap(vaddr);
-	mtk_gem->kvaddr = 0;
-	kfree((void *)mtk_gem->pages);
+	mtk_gem->kvaddr = NULL;
+	kfree(mtk_gem->pages);
 }
diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi.c b/drivers/gpu/drm/mediatek/mtk_hdmi.c
index 6b22fd63c3f5..74a54a9e3533 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi.c
@@ -1237,17 +1237,19 @@ static int mtk_hdmi_conn_mode_valid(struct drm_connector *conn,
 				    struct drm_display_mode *mode)
 {
 	struct mtk_hdmi *hdmi = hdmi_ctx_from_conn(conn);
+	struct drm_bridge *next_bridge;
 
 	dev_dbg(hdmi->dev, "xres=%d, yres=%d, refresh=%d, intl=%d clock=%d\n",
 		mode->hdisplay, mode->vdisplay, mode->vrefresh,
 		!!(mode->flags & DRM_MODE_FLAG_INTERLACE), mode->clock * 1000);
 
-	if (hdmi->bridge.next) {
+	next_bridge = drm_bridge_get_next_bridge(&hdmi->bridge);
+	if (next_bridge) {
 		struct drm_display_mode adjusted_mode;
 
 		drm_mode_copy(&adjusted_mode, mode);
-		if (!drm_bridge_mode_fixup(hdmi->bridge.next, mode,
-					   &adjusted_mode))
+		if (!drm_bridge_chain_mode_fixup(next_bridge, mode,
+						 &adjusted_mode))
 			return MODE_BAD;
 	}
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index 4aed5e9a84a4..2e28db60f4d2 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -651,7 +651,10 @@ static void dpu_crtc_reset(struct drm_crtc *crtc)
 	if (crtc->state)
 		dpu_crtc_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &cstate->base);
+	if (cstate)
+		__drm_atomic_helper_crtc_reset(crtc, &cstate->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 }
 
 /**
@@ -833,6 +836,8 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
 	}
 
 	pstates = kzalloc(sizeof(*pstates) * DPU_STAGE_MAX * 4, GFP_KERNEL);
+	if (!pstates)
+		return -ENOMEM;
 
 	dpu_crtc = to_dpu_crtc(crtc);
 	cstate = to_dpu_crtc_state(state);
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
index 03d60eb09257..cc60842b47e9 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
@@ -1050,7 +1050,10 @@ static void mdp5_crtc_reset(struct drm_crtc *crtc)
 	if (crtc->state)
 		mdp5_crtc_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &mdp5_cstate->base);
+	if (mdp5_cstate)
+		__drm_atomic_helper_crtc_reset(crtc, &mdp5_cstate->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 
 	drm_crtc_vblank_reset(crtc);
 }
diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 743142e15b4c..c59764f156f9 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1877,6 +1877,9 @@ int msm_dsi_host_init(struct msm_dsi *msm_dsi)
 
 	/* setup workqueue */
 	msm_host->workqueue = alloc_ordered_workqueue("dsi_drm_work", 0);
+	if (!msm_host->workqueue)
+		return -ENOMEM;
+
 	INIT_WORK(&msm_host->err_work, dsi_err_worker);
 	INIT_WORK(&msm_host->hpd_work, dsi_hpd_worker);
 
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index 74759bcc68ff..74b806b3e65f 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -248,6 +248,10 @@ static struct hdmi *msm_hdmi_init(struct platform_device *pdev)
 	pm_runtime_enable(&pdev->dev);
 
 	hdmi->workq = alloc_ordered_workqueue("msm_hdmi", 0);
+	if (!hdmi->workq) {
+		ret = -ENOMEM;
+		goto fail;
+	}
 
 	hdmi->i2c = msm_hdmi_i2c_init(hdmi);
 	if (IS_ERR(hdmi->i2c)) {
diff --git a/drivers/gpu/drm/msm/msm_fence.c b/drivers/gpu/drm/msm/msm_fence.c
index cd59a5918038..50a25c119f4d 100644
--- a/drivers/gpu/drm/msm/msm_fence.c
+++ b/drivers/gpu/drm/msm/msm_fence.c
@@ -20,7 +20,7 @@ msm_fence_context_alloc(struct drm_device *dev, const char *name)
 		return ERR_PTR(-ENOMEM);
 
 	fctx->dev = dev;
-	strncpy(fctx->name, name, sizeof(fctx->name));
+	strscpy(fctx->name, name, sizeof(fctx->name));
 	fctx->context = dma_fence_context_alloc(1);
 	init_waitqueue_head(&fctx->event);
 	spin_lock_init(&fctx->spinlock);
diff --git a/drivers/gpu/drm/mxsfb/Kconfig b/drivers/gpu/drm/mxsfb/Kconfig
index 33916b7b2c50..e8cb02803d9b 100644
--- a/drivers/gpu/drm/mxsfb/Kconfig
+++ b/drivers/gpu/drm/mxsfb/Kconfig
@@ -8,6 +8,7 @@ config DRM_MXSFB
 	tristate "i.MX23/i.MX28/i.MX6SX MXSFB LCD controller"
 	depends on DRM && OF
 	depends on COMMON_CLK
+	depends on ARCH_MXS || ARCH_MXC || COMPILE_TEST
 	select DRM_MXS
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
diff --git a/drivers/gpu/drm/omapdrm/dss/dsi.c b/drivers/gpu/drm/omapdrm/dss/dsi.c
index b30fcaa2d0f5..993d48fb8064 100644
--- a/drivers/gpu/drm/omapdrm/dss/dsi.c
+++ b/drivers/gpu/drm/omapdrm/dss/dsi.c
@@ -1444,22 +1444,26 @@ static int dsi_dump_dsi_irqs(struct seq_file *s, void *p)
 {
 	struct dsi_data *dsi = s->private;
 	unsigned long flags;
-	struct dsi_irq_stats stats;
+	struct dsi_irq_stats *stats;
+
+	stats = kmalloc(sizeof(*stats), GFP_KERNEL);
+	if (!stats)
+		return -ENOMEM;
 
 	spin_lock_irqsave(&dsi->irq_stats_lock, flags);
 
-	stats = dsi->irq_stats;
+	*stats = dsi->irq_stats;
 	memset(&dsi->irq_stats, 0, sizeof(dsi->irq_stats));
 	dsi->irq_stats.last_reset = jiffies;
 
 	spin_unlock_irqrestore(&dsi->irq_stats_lock, flags);
 
 	seq_printf(s, "period %u ms\n",
-			jiffies_to_msecs(jiffies - stats.last_reset));
+			jiffies_to_msecs(jiffies - stats->last_reset));
 
-	seq_printf(s, "irqs %d\n", stats.irq_count);
+	seq_printf(s, "irqs %d\n", stats->irq_count);
 #define PIS(x) \
-	seq_printf(s, "%-20s %10d\n", #x, stats.dsi_irqs[ffs(DSI_IRQ_##x)-1]);
+	seq_printf(s, "%-20s %10d\n", #x, stats->dsi_irqs[ffs(DSI_IRQ_##x)-1]);
 
 	seq_printf(s, "-- DSI%d interrupts --\n", dsi->module_id + 1);
 	PIS(VC0);
@@ -1483,10 +1487,10 @@ static int dsi_dump_dsi_irqs(struct seq_file *s, void *p)
 
 #define PIS(x) \
 	seq_printf(s, "%-20s %10d %10d %10d %10d\n", #x, \
-			stats.vc_irqs[0][ffs(DSI_VC_IRQ_##x)-1], \
-			stats.vc_irqs[1][ffs(DSI_VC_IRQ_##x)-1], \
-			stats.vc_irqs[2][ffs(DSI_VC_IRQ_##x)-1], \
-			stats.vc_irqs[3][ffs(DSI_VC_IRQ_##x)-1]);
+			stats->vc_irqs[0][ffs(DSI_VC_IRQ_##x)-1], \
+			stats->vc_irqs[1][ffs(DSI_VC_IRQ_##x)-1], \
+			stats->vc_irqs[2][ffs(DSI_VC_IRQ_##x)-1], \
+			stats->vc_irqs[3][ffs(DSI_VC_IRQ_##x)-1]);
 
 	seq_printf(s, "-- VC interrupts --\n");
 	PIS(CS);
@@ -1502,7 +1506,7 @@ static int dsi_dump_dsi_irqs(struct seq_file *s, void *p)
 
 #define PIS(x) \
 	seq_printf(s, "%-20s %10d\n", #x, \
-			stats.cio_irqs[ffs(DSI_CIO_IRQ_##x)-1]);
+			stats->cio_irqs[ffs(DSI_CIO_IRQ_##x)-1]);
 
 	seq_printf(s, "-- CIO interrupts --\n");
 	PIS(ERRSYNCESC1);
@@ -1527,6 +1531,8 @@ static int dsi_dump_dsi_irqs(struct seq_file *s, void *p)
 	PIS(ULPSACTIVENOT_ALL1);
 #undef PIS
 
+	kfree(stats);
+
 	return 0;
 }
 #endif
diff --git a/drivers/gpu/drm/omapdrm/omap_drv.c b/drivers/gpu/drm/omapdrm/omap_drv.c
index 2983c003698e..a4645b78f737 100644
--- a/drivers/gpu/drm/omapdrm/omap_drv.c
+++ b/drivers/gpu/drm/omapdrm/omap_drv.c
@@ -216,8 +216,8 @@ static int omap_display_id(struct omap_dss_device *output)
 	} else if (output->bridge) {
 		struct drm_bridge *bridge = output->bridge;
 
-		while (bridge->next)
-			bridge = bridge->next;
+		while (drm_bridge_get_next_bridge(bridge))
+			bridge = drm_bridge_get_next_bridge(bridge);
 
 		node = bridge->of_node;
 	} else if (output->panel) {
diff --git a/drivers/gpu/drm/omapdrm/omap_encoder.c b/drivers/gpu/drm/omapdrm/omap_encoder.c
index 6fe14111cd95..b626b543a992 100644
--- a/drivers/gpu/drm/omapdrm/omap_encoder.c
+++ b/drivers/gpu/drm/omapdrm/omap_encoder.c
@@ -125,7 +125,8 @@ static void omap_encoder_mode_set(struct drm_encoder *encoder,
 	for (dssdev = output; dssdev; dssdev = dssdev->next)
 		omap_encoder_update_videomode_flags(&vm, dssdev->bus_flags);
 
-	for (bridge = output->bridge; bridge; bridge = bridge->next) {
+	for (bridge = output->bridge; bridge;
+	     bridge = drm_bridge_get_next_bridge(bridge)) {
 		if (!bridge->timings)
 			continue;
 
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 92ffed5c1d69..857fdf7b314e 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -2192,11 +2192,12 @@ int radeon_atom_pick_dig_encoder(struct drm_encoder *encoder, int fe_idx)
 
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
index e892582e847b..0d0ae89a8568 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -1022,6 +1022,7 @@ void radeon_atombios_fini(struct radeon_device *rdev)
 {
 	if (rdev->mode_info.atom_context) {
 		kfree(rdev->mode_info.atom_context->scratch);
+		kfree(rdev->mode_info.atom_context->iio);
 	}
 	kfree(rdev->mode_info.atom_context);
 	rdev->mode_info.atom_context = NULL;
diff --git a/drivers/gpu/drm/vc4/vc4_dpi.c b/drivers/gpu/drm/vc4/vc4_dpi.c
index 8a27a6acee61..9ea2e7beef0c 100644
--- a/drivers/gpu/drm/vc4/vc4_dpi.c
+++ b/drivers/gpu/drm/vc4/vc4_dpi.c
@@ -151,35 +151,45 @@ static void vc4_dpi_encoder_enable(struct drm_encoder *encoder)
 	}
 	drm_connector_list_iter_end(&conn_iter);
 
-	if (connector && connector->display_info.num_bus_formats) {
-		u32 bus_format = connector->display_info.bus_formats[0];
-
-		switch (bus_format) {
-		case MEDIA_BUS_FMT_RGB888_1X24:
-			dpi_c |= VC4_SET_FIELD(DPI_FORMAT_24BIT_888_RGB,
-					       DPI_FORMAT);
-			break;
-		case MEDIA_BUS_FMT_BGR888_1X24:
-			dpi_c |= VC4_SET_FIELD(DPI_FORMAT_24BIT_888_RGB,
-					       DPI_FORMAT);
-			dpi_c |= VC4_SET_FIELD(DPI_ORDER_BGR, DPI_ORDER);
-			break;
-		case MEDIA_BUS_FMT_RGB666_1X24_CPADHI:
-			dpi_c |= VC4_SET_FIELD(DPI_FORMAT_18BIT_666_RGB_2,
-					       DPI_FORMAT);
-			break;
-		case MEDIA_BUS_FMT_RGB666_1X18:
-			dpi_c |= VC4_SET_FIELD(DPI_FORMAT_18BIT_666_RGB_1,
-					       DPI_FORMAT);
-			break;
-		case MEDIA_BUS_FMT_RGB565_1X16:
-			dpi_c |= VC4_SET_FIELD(DPI_FORMAT_16BIT_565_RGB_3,
-					       DPI_FORMAT);
-			break;
-		default:
-			DRM_ERROR("Unknown media bus format %d\n", bus_format);
-			break;
+	if (connector) {
+		if (connector->display_info.num_bus_formats) {
+			u32 bus_format = connector->display_info.bus_formats[0];
+
+			switch (bus_format) {
+			case MEDIA_BUS_FMT_RGB888_1X24:
+				dpi_c |= VC4_SET_FIELD(DPI_FORMAT_24BIT_888_RGB,
+						       DPI_FORMAT);
+				break;
+			case MEDIA_BUS_FMT_BGR888_1X24:
+				dpi_c |= VC4_SET_FIELD(DPI_FORMAT_24BIT_888_RGB,
+						       DPI_FORMAT);
+				dpi_c |= VC4_SET_FIELD(DPI_ORDER_BGR,
+						       DPI_ORDER);
+				break;
+			case MEDIA_BUS_FMT_RGB666_1X24_CPADHI:
+				dpi_c |= VC4_SET_FIELD(DPI_FORMAT_18BIT_666_RGB_2,
+						       DPI_FORMAT);
+				break;
+			case MEDIA_BUS_FMT_RGB666_1X18:
+				dpi_c |= VC4_SET_FIELD(DPI_FORMAT_18BIT_666_RGB_1,
+						       DPI_FORMAT);
+				break;
+			case MEDIA_BUS_FMT_RGB565_1X16:
+				dpi_c |= VC4_SET_FIELD(DPI_FORMAT_16BIT_565_RGB_1,
+						       DPI_FORMAT);
+				break;
+			default:
+				DRM_ERROR("Unknown media bus format %d\n",
+					  bus_format);
+				break;
+			}
 		}
+
+		if (connector->display_info.bus_flags & DRM_BUS_FLAG_PIXDATA_DRIVE_NEGEDGE)
+			dpi_c |= DPI_PIXEL_CLK_INVERT;
+
+		if (connector->display_info.bus_flags & DRM_BUS_FLAG_DE_LOW)
+			dpi_c |= DPI_OUTPUT_ENABLE_INVERT;
 	} else {
 		/* Default to 24bit if no connector found. */
 		dpi_c |= VC4_SET_FIELD(DPI_FORMAT_24BIT_888_RGB, DPI_FORMAT);
diff --git a/drivers/gpu/drm/vc4/vc4_dsi.c b/drivers/gpu/drm/vc4/vc4_dsi.c
index e249ab378700..67bfbffdb65c 100644
--- a/drivers/gpu/drm/vc4/vc4_dsi.c
+++ b/drivers/gpu/drm/vc4/vc4_dsi.c
@@ -752,9 +752,9 @@ static void vc4_dsi_encoder_disable(struct drm_encoder *encoder)
 	struct vc4_dsi *dsi = vc4_encoder->dsi;
 	struct device *dev = &dsi->pdev->dev;
 
-	drm_bridge_disable(dsi->bridge);
+	drm_bridge_chain_disable(dsi->bridge);
 	vc4_dsi_ulps(dsi, true);
-	drm_bridge_post_disable(dsi->bridge);
+	drm_bridge_chain_post_disable(dsi->bridge);
 
 	clk_disable_unprepare(dsi->pll_phy_clock);
 	clk_disable_unprepare(dsi->escape_clock);
@@ -1052,7 +1052,7 @@ static void vc4_dsi_encoder_enable(struct drm_encoder *encoder)
 
 	vc4_dsi_ulps(dsi, false);
 
-	drm_bridge_pre_enable(dsi->bridge);
+	drm_bridge_chain_pre_enable(dsi->bridge);
 
 	if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO) {
 		DSI_PORT_WRITE(DISP0_CTRL,
@@ -1069,7 +1069,7 @@ static void vc4_dsi_encoder_enable(struct drm_encoder *encoder)
 			       DSI_DISP0_ENABLE);
 	}
 
-	drm_bridge_enable(dsi->bridge);
+	drm_bridge_chain_enable(dsi->bridge);
 
 	if (debug_dump_regs) {
 		struct drm_printer p = drm_info_printer(&dsi->pdev->dev);
diff --git a/drivers/gpu/host1x/hw/syncpt_hw.c b/drivers/gpu/host1x/hw/syncpt_hw.c
index dd39d67ccec3..8cf35b2eff3d 100644
--- a/drivers/gpu/host1x/hw/syncpt_hw.c
+++ b/drivers/gpu/host1x/hw/syncpt_hw.c
@@ -106,9 +106,6 @@ static void syncpt_assign_to_channel(struct host1x_syncpt *sp,
 #if HOST1X_HW >= 6
 	struct host1x *host = sp->host;
 
-	if (!host->hv_regs)
-		return;
-
 	host1x_sync_writel(host,
 			   HOST1X_SYNC_SYNCPT_CH_APP_CH(ch ? ch->id : 0xff),
 			   HOST1X_SYNC_SYNCPT_CH_APP(sp->id));
diff --git a/drivers/gpu/ipu-v3/ipu-common.c b/drivers/gpu/ipu-v3/ipu-common.c
index b3dae9ec1a38..528812bf84da 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -1235,6 +1235,7 @@ static int ipu_add_client_devices(struct ipu_soc *ipu, unsigned long ipu_base)
 		pdev = platform_device_alloc(reg->name, id++);
 		if (!pdev) {
 			ret = -ENOMEM;
+			of_node_put(of_node);
 			goto err_register;
 		}
 
diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index 7f84ed0afdfe..e15ba7f5fe0a 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -40,7 +40,9 @@ MODULE_AUTHOR("Frederik Wenigwieser <frederik.wenigwieser@gmail.com>");
 MODULE_DESCRIPTION("Asus HID Keyboard and TouchPad");
 
 #define T100_TPAD_INTF 2
+#define MEDION_E1239T_TPAD_INTF 1
 
+#define E1239T_TP_TOGGLE_REPORT_ID 0x05
 #define T100CHI_MOUSE_REPORT_ID 0x06
 #define FEATURE_REPORT_ID 0x0d
 #define INPUT_REPORT_ID 0x5d
@@ -77,6 +79,7 @@ MODULE_DESCRIPTION("Asus HID Keyboard and TouchPad");
 #define QUIRK_G752_KEYBOARD		BIT(8)
 #define QUIRK_T101HA_DOCK		BIT(9)
 #define QUIRK_T90CHI			BIT(10)
+#define QUIRK_MEDION_E1239T		BIT(11)
 
 #define I2C_KEYBOARD_QUIRKS			(QUIRK_FIX_NOTEBOOK_REPORT | \
 						 QUIRK_NO_INIT_REPORTS | \
@@ -92,6 +95,7 @@ struct asus_kbd_leds {
 	struct hid_device *hdev;
 	struct work_struct work;
 	unsigned int brightness;
+	spinlock_t lock;
 	bool removed;
 };
 
@@ -102,12 +106,14 @@ struct asus_touchpad_info {
 	int res_y;
 	int contact_size;
 	int max_contacts;
+	int report_size;
 };
 
 struct asus_drvdata {
 	unsigned long quirks;
 	struct hid_device *hdev;
 	struct input_dev *input;
+	struct input_dev *tp_kbd_input;
 	struct asus_kbd_leds *kbd_backlight;
 	const struct asus_touchpad_info *tp;
 	bool enable_backlight;
@@ -126,6 +132,7 @@ static const struct asus_touchpad_info asus_i2c_tp = {
 	.max_y = 1758,
 	.contact_size = 5,
 	.max_contacts = 5,
+	.report_size = 28 /* 2 byte header + 5 * 5 + 1 byte footer */,
 };
 
 static const struct asus_touchpad_info asus_t100ta_tp = {
@@ -135,6 +142,7 @@ static const struct asus_touchpad_info asus_t100ta_tp = {
 	.res_y = 27, /* units/mm */
 	.contact_size = 5,
 	.max_contacts = 5,
+	.report_size = 28 /* 2 byte header + 5 * 5 + 1 byte footer */,
 };
 
 static const struct asus_touchpad_info asus_t100ha_tp = {
@@ -144,6 +152,7 @@ static const struct asus_touchpad_info asus_t100ha_tp = {
 	.res_y = 29, /* units/mm */
 	.contact_size = 5,
 	.max_contacts = 5,
+	.report_size = 28 /* 2 byte header + 5 * 5 + 1 byte footer */,
 };
 
 static const struct asus_touchpad_info asus_t200ta_tp = {
@@ -153,6 +162,7 @@ static const struct asus_touchpad_info asus_t200ta_tp = {
 	.res_y = 28, /* units/mm */
 	.contact_size = 5,
 	.max_contacts = 5,
+	.report_size = 28 /* 2 byte header + 5 * 5 + 1 byte footer */,
 };
 
 static const struct asus_touchpad_info asus_t100chi_tp = {
@@ -162,6 +172,17 @@ static const struct asus_touchpad_info asus_t100chi_tp = {
 	.res_y = 29, /* units/mm */
 	.contact_size = 3,
 	.max_contacts = 4,
+	.report_size = 15 /* 2 byte header + 3 * 4 + 1 byte footer */,
+};
+
+static const struct asus_touchpad_info medion_e1239t_tp = {
+	.max_x = 2640,
+	.max_y = 1380,
+	.res_x = 29, /* units/mm */
+	.res_y = 28, /* units/mm */
+	.contact_size = 5,
+	.max_contacts = 5,
+	.report_size = 32 /* 2 byte header + 5 * 5 + 5 byte footer */,
 };
 
 static void asus_report_contact_down(struct asus_drvdata *drvdat,
@@ -229,7 +250,7 @@ static int asus_report_input(struct asus_drvdata *drvdat, u8 *data, int size)
 	int i, toolType = MT_TOOL_FINGER;
 	u8 *contactData = data + 2;
 
-	if (size != 3 + drvdat->tp->contact_size * drvdat->tp->max_contacts)
+	if (size != drvdat->tp->report_size)
 		return 0;
 
 	for (i = 0; i < drvdat->tp->max_contacts; i++) {
@@ -257,6 +278,34 @@ static int asus_report_input(struct asus_drvdata *drvdat, u8 *data, int size)
 	return 1;
 }
 
+static int asus_e1239t_event(struct asus_drvdata *drvdat, u8 *data, int size)
+{
+	if (size != 3)
+		return 0;
+
+	/* Handle broken mute key which only sends press events */
+	if (!drvdat->tp &&
+	    data[0] == 0x02 && data[1] == 0xe2 && data[2] == 0x00) {
+		input_report_key(drvdat->input, KEY_MUTE, 1);
+		input_sync(drvdat->input);
+		input_report_key(drvdat->input, KEY_MUTE, 0);
+		input_sync(drvdat->input);
+		return 1;
+	}
+
+	/* Handle custom touchpad toggle key which only sends press events */
+	if (drvdat->tp_kbd_input &&
+	    data[0] == 0x05 && data[1] == 0x02 && data[2] == 0x28) {
+		input_report_key(drvdat->tp_kbd_input, KEY_F21, 1);
+		input_sync(drvdat->tp_kbd_input);
+		input_report_key(drvdat->tp_kbd_input, KEY_F21, 0);
+		input_sync(drvdat->tp_kbd_input);
+		return 1;
+	}
+
+	return 0;
+}
+
 static int asus_event(struct hid_device *hdev, struct hid_field *field,
 		      struct hid_usage *usage, __s32 value)
 {
@@ -281,6 +330,9 @@ static int asus_raw_event(struct hid_device *hdev,
 	if (drvdata->tp && data[0] == INPUT_REPORT_ID)
 		return asus_report_input(drvdata, data, size);
 
+	if (drvdata->quirks & QUIRK_MEDION_E1239T)
+		return asus_e1239t_event(drvdata, data, size);
+
 	return 0;
 }
 
@@ -346,24 +398,42 @@ static int asus_kbd_get_functions(struct hid_device *hdev,
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
@@ -371,11 +441,11 @@ static void asus_kbd_backlight_work(struct work_struct *work)
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
@@ -437,6 +507,7 @@ static int asus_kbd_register_leds(struct hid_device *hdev)
 	drvdata->kbd_backlight->cdev.brightness_set = asus_kbd_backlight_set;
 	drvdata->kbd_backlight->cdev.brightness_get = asus_kbd_backlight_get;
 	INIT_WORK(&drvdata->kbd_backlight->work, asus_kbd_backlight_work);
+	spin_lock_init(&drvdata->kbd_backlight->lock);
 
 	ret = devm_led_classdev_register(&hdev->dev, &drvdata->kbd_backlight->cdev);
 	if (ret < 0) {
@@ -615,6 +686,21 @@ static int asus_input_configured(struct hid_device *hdev, struct hid_input *hi)
 	    hi->report->id != T100CHI_MOUSE_REPORT_ID)
 		return 0;
 
+	/* Handle MULTI_INPUT on E1239T mouse/touchpad USB interface */
+	if (drvdata->tp && (drvdata->quirks & QUIRK_MEDION_E1239T)) {
+		switch (hi->report->id) {
+		case E1239T_TP_TOGGLE_REPORT_ID:
+			input_set_capability(input, EV_KEY, KEY_F21);
+			input->name = "Asus Touchpad Keys";
+			drvdata->tp_kbd_input = input;
+			return 0;
+		case INPUT_REPORT_ID:
+			break; /* Touchpad report, handled below */
+		default:
+			return 0; /* Ignore other reports */
+		}
+	}
+
 	if (drvdata->tp) {
 		int ret;
 
@@ -694,7 +780,6 @@ static int asus_input_mapping(struct hid_device *hdev,
 
 	/* ASUS-specific keyboard hotkeys */
 	if ((usage->hid & HID_USAGE_PAGE) == 0xff310000) {
-		set_bit(EV_REP, hi->input->evbit);
 		switch (usage->hid & HID_USAGE) {
 		case 0x10: asus_map_key_clear(KEY_BRIGHTNESSDOWN);	break;
 		case 0x20: asus_map_key_clear(KEY_BRIGHTNESSUP);		break;
@@ -737,11 +822,11 @@ static int asus_input_mapping(struct hid_device *hdev,
 		if (drvdata->quirks & QUIRK_USE_KBD_BACKLIGHT)
 			drvdata->enable_backlight = true;
 
+		set_bit(EV_REP, hi->input->evbit);
 		return 1;
 	}
 
 	if ((usage->hid & HID_USAGE_PAGE) == HID_UP_MSVENDOR) {
-		set_bit(EV_REP, hi->input->evbit);
 		switch (usage->hid & HID_USAGE) {
 		case 0xff01: asus_map_key_clear(BTN_1);	break;
 		case 0xff02: asus_map_key_clear(BTN_2);	break;
@@ -764,6 +849,7 @@ static int asus_input_mapping(struct hid_device *hdev,
 			return 0;
 		}
 
+		set_bit(EV_REP, hi->input->evbit);
 		return 1;
 	}
 
@@ -782,6 +868,16 @@ static int asus_input_mapping(struct hid_device *hdev,
 		}
 	}
 
+	/*
+	 * The mute button is broken and only sends press events, we
+	 * deal with this in our raw_event handler, so do not map it.
+	 */
+	if ((drvdata->quirks & QUIRK_MEDION_E1239T) &&
+	    usage->hid == (HID_UP_CONSUMER | 0xe2)) {
+		input_set_capability(hi->input, EV_KEY, KEY_MUTE);
+		return -1;
+	}
+
 	return 0;
 }
 
@@ -877,6 +973,19 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
 		drvdata->tp = &asus_t100chi_tp;
 	}
 
+	if ((drvdata->quirks & QUIRK_MEDION_E1239T) &&
+	    hid_is_using_ll_driver(hdev, &usb_hid_driver)) {
+		struct usb_host_interface *alt =
+			to_usb_interface(hdev->dev.parent)->altsetting;
+
+		if (alt->desc.bInterfaceNumber == MEDION_E1239T_TPAD_INTF) {
+			/* For separate input-devs for tp and tp toggle key */
+			hdev->quirks |= HID_QUIRK_MULTI_INPUT;
+			drvdata->quirks |= QUIRK_SKIP_INPUT_MAPPING;
+			drvdata->tp = &medion_e1239t_tp;
+		}
+	}
+
 	if (drvdata->quirks & QUIRK_NO_INIT_REPORTS)
 		hdev->quirks |= HID_QUIRK_NO_INIT_REPORTS;
 
@@ -935,9 +1044,13 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
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
 
@@ -1056,7 +1169,8 @@ static const struct hid_device_id asus_devices[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_JESS, USB_DEVICE_ID_ASUS_MD_5112) },
 	{ HID_BLUETOOTH_DEVICE(USB_VENDOR_ID_ASUSTEK,
 		USB_DEVICE_ID_ASUSTEK_T100CHI_KEYBOARD), QUIRK_T100CHI },
-
+	{ HID_USB_DEVICE(USB_VENDOR_ID_ITE, USB_DEVICE_ID_ITE_MEDION_E1239T),
+		QUIRK_MEDION_E1239T },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, asus_devices);
diff --git a/drivers/hid/hid-bigbenff.c b/drivers/hid/hid-bigbenff.c
index e8b16665860d..a02cb517b4c4 100644
--- a/drivers/hid/hid-bigbenff.c
+++ b/drivers/hid/hid-bigbenff.c
@@ -174,6 +174,7 @@ static __u8 pid0902_rdesc_fixed[] = {
 struct bigben_device {
 	struct hid_device *hid;
 	struct hid_report *report;
+	spinlock_t lock;
 	bool removed;
 	u8 led_state;         /* LED1 = 1 .. LED4 = 8 */
 	u8 right_motor_on;    /* right motor off/on 0/1 */
@@ -184,18 +185,39 @@ struct bigben_device {
 	struct work_struct worker;
 };
 
+static inline void bigben_schedule_work(struct bigben_device *bigben)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&bigben->lock, flags);
+	if (!bigben->removed)
+		schedule_work(&bigben->worker);
+	spin_unlock_irqrestore(&bigben->lock, flags);
+}
 
 static void bigben_worker(struct work_struct *work)
 {
 	struct bigben_device *bigben = container_of(work,
 		struct bigben_device, worker);
 	struct hid_field *report_field = bigben->report->field[0];
-
-	if (bigben->removed || !report_field)
+	bool do_work_led = false;
+	bool do_work_ff = false;
+	u8 *buf;
+	u32 len;
+	unsigned long flags;
+
+	buf = hid_alloc_report_buf(bigben->report, GFP_KERNEL);
+	if (!buf)
 		return;
 
+	len = hid_report_len(bigben->report);
+
+	/* LED work */
+	spin_lock_irqsave(&bigben->lock, flags);
+
 	if (bigben->work_led) {
 		bigben->work_led = false;
+		do_work_led = true;
 		report_field->value[0] = 0x01; /* 1 = led message */
 		report_field->value[1] = 0x08; /* reserved value, always 8 */
 		report_field->value[2] = bigben->led_state;
@@ -204,11 +226,22 @@ static void bigben_worker(struct work_struct *work)
 		report_field->value[5] = 0x00; /* padding */
 		report_field->value[6] = 0x00; /* padding */
 		report_field->value[7] = 0x00; /* padding */
-		hid_hw_request(bigben->hid, bigben->report, HID_REQ_SET_REPORT);
+		hid_output_report(bigben->report, buf);
+	}
+
+	spin_unlock_irqrestore(&bigben->lock, flags);
+
+	if (do_work_led) {
+		hid_hw_raw_request(bigben->hid, bigben->report->id, buf, len,
+				   bigben->report->type, HID_REQ_SET_REPORT);
 	}
 
+	/* FF work */
+	spin_lock_irqsave(&bigben->lock, flags);
+
 	if (bigben->work_ff) {
 		bigben->work_ff = false;
+		do_work_ff = true;
 		report_field->value[0] = 0x02; /* 2 = rumble effect message */
 		report_field->value[1] = 0x08; /* reserved value, always 8 */
 		report_field->value[2] = bigben->right_motor_on;
@@ -217,8 +250,17 @@ static void bigben_worker(struct work_struct *work)
 		report_field->value[5] = 0x00; /* padding */
 		report_field->value[6] = 0x00; /* padding */
 		report_field->value[7] = 0x00; /* padding */
-		hid_hw_request(bigben->hid, bigben->report, HID_REQ_SET_REPORT);
+		hid_output_report(bigben->report, buf);
+	}
+
+	spin_unlock_irqrestore(&bigben->lock, flags);
+
+	if (do_work_ff) {
+		hid_hw_raw_request(bigben->hid, bigben->report->id, buf, len,
+				   bigben->report->type, HID_REQ_SET_REPORT);
 	}
+
+	kfree(buf);
 }
 
 static int hid_bigben_play_effect(struct input_dev *dev, void *data,
@@ -228,6 +270,7 @@ static int hid_bigben_play_effect(struct input_dev *dev, void *data,
 	struct bigben_device *bigben = hid_get_drvdata(hid);
 	u8 right_motor_on;
 	u8 left_motor_force;
+	unsigned long flags;
 
 	if (!bigben) {
 		hid_err(hid, "no device data\n");
@@ -242,10 +285,13 @@ static int hid_bigben_play_effect(struct input_dev *dev, void *data,
 
 	if (right_motor_on != bigben->right_motor_on ||
 			left_motor_force != bigben->left_motor_force) {
+		spin_lock_irqsave(&bigben->lock, flags);
 		bigben->right_motor_on   = right_motor_on;
 		bigben->left_motor_force = left_motor_force;
 		bigben->work_ff = true;
-		schedule_work(&bigben->worker);
+		spin_unlock_irqrestore(&bigben->lock, flags);
+
+		bigben_schedule_work(bigben);
 	}
 
 	return 0;
@@ -259,6 +305,7 @@ static void bigben_set_led(struct led_classdev *led,
 	struct bigben_device *bigben = hid_get_drvdata(hid);
 	int n;
 	bool work;
+	unsigned long flags;
 
 	if (!bigben) {
 		hid_err(hid, "no device data\n");
@@ -267,6 +314,7 @@ static void bigben_set_led(struct led_classdev *led,
 
 	for (n = 0; n < NUM_LEDS; n++) {
 		if (led == bigben->leds[n]) {
+			spin_lock_irqsave(&bigben->lock, flags);
 			if (value == LED_OFF) {
 				work = (bigben->led_state & BIT(n));
 				bigben->led_state &= ~BIT(n);
@@ -274,10 +322,11 @@ static void bigben_set_led(struct led_classdev *led,
 				work = !(bigben->led_state & BIT(n));
 				bigben->led_state |= BIT(n);
 			}
+			spin_unlock_irqrestore(&bigben->lock, flags);
 
 			if (work) {
 				bigben->work_led = true;
-				schedule_work(&bigben->worker);
+				bigben_schedule_work(bigben);
 			}
 			return;
 		}
@@ -307,8 +356,12 @@ static enum led_brightness bigben_get_led(struct led_classdev *led)
 static void bigben_remove(struct hid_device *hid)
 {
 	struct bigben_device *bigben = hid_get_drvdata(hid);
+	unsigned long flags;
 
+	spin_lock_irqsave(&bigben->lock, flags);
 	bigben->removed = true;
+	spin_unlock_irqrestore(&bigben->lock, flags);
+
 	cancel_work_sync(&bigben->worker);
 	hid_hw_stop(hid);
 }
@@ -318,7 +371,6 @@ static int bigben_probe(struct hid_device *hid,
 {
 	struct bigben_device *bigben;
 	struct hid_input *hidinput;
-	struct list_head *report_list;
 	struct led_classdev *led;
 	char *name;
 	size_t name_sz;
@@ -343,14 +395,12 @@ static int bigben_probe(struct hid_device *hid,
 		return error;
 	}
 
-	report_list = &hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	if (list_empty(report_list)) {
+	bigben->report = hid_validate_values(hid, HID_OUTPUT_REPORT, 0, 0, 8);
+	if (!bigben->report) {
 		hid_err(hid, "no output report found\n");
 		error = -ENODEV;
 		goto error_hw_stop;
 	}
-	bigben->report = list_entry(report_list->next,
-		struct hid_report, list);
 
 	if (list_empty(&hid->inputs)) {
 		hid_err(hid, "no inputs found\n");
@@ -362,6 +412,7 @@ static int bigben_probe(struct hid_device *hid,
 	set_bit(FF_RUMBLE, hidinput->input->ffbit);
 
 	INIT_WORK(&bigben->worker, bigben_worker);
+	spin_lock_init(&bigben->lock);
 
 	error = input_ff_create_memless(hidinput->input, NULL,
 		hid_bigben_play_effect);
@@ -402,7 +453,7 @@ static int bigben_probe(struct hid_device *hid,
 	bigben->left_motor_force = 0;
 	bigben->work_led = true;
 	bigben->work_ff = true;
-	schedule_work(&bigben->worker);
+	bigben_schedule_work(bigben);
 
 	hid_info(hid, "LED and force feedback support for BigBen gamepad\n");
 
diff --git a/drivers/hid/hid-debug.c b/drivers/hid/hid-debug.c
index 419d8dec7e49..0066eab60576 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -933,6 +933,7 @@ static const char *keys[KEY_MAX + 1] = {
 	[KEY_VOICECOMMAND] = "VoiceCommand",
 	[KEY_EMOJI_PICKER] = "EmojiPicker",
 	[KEY_DICTATE] = "Dictate",
+	[KEY_MICMUTE] = "MicrophoneMute",
 	[KEY_BRIGHTNESS_MIN] = "BrightnessMin",
 	[KEY_BRIGHTNESS_MAX] = "BrightnessMax",
 	[KEY_BRIGHTNESS_AUTO] = "BrightnessAuto",
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 1c034c397e3e..b883423a89c5 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -650,6 +650,7 @@
 #define I2C_DEVICE_ID_ITE_LENOVO_LEGION_Y720	0x837a
 #define USB_DEVICE_ID_ITE_LENOVO_YOGA900	0x8396
 #define USB_DEVICE_ID_ITE8595		0x8595
+#define USB_DEVICE_ID_ITE_MEDION_E1239T	0xce50
 
 #define USB_VENDOR_ID_JABRA		0x0b0e
 #define USB_DEVICE_ID_JABRA_SPEAK_410	0x0412
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index d1ba6fafe960..004aa3cdeacc 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -671,6 +671,14 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
 			break;
 		}
 
+		if ((usage->hid & 0xf0) == 0xa0) {	/* SystemControl */
+			switch (usage->hid & 0xf) {
+			case 0x9: map_key_clear(KEY_MICMUTE); break;
+			default: goto ignore;
+			}
+			break;
+		}
+
 		if ((usage->hid & 0xf0) == 0xb0) {	/* SC - Display */
 			switch (usage->hid & 0xf) {
 			case 0x05: map_key_clear(KEY_SWITCHVIDEOMODE); break;
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 7a64ff6a8779..e232f44f6c9a 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -550,66 +550,49 @@ static void coretemp_remove_core(struct platform_data *pdata, int indx)
 		ida_free(&pdata->ida, indx - BASE_SYSFS_ATTR_NO);
 }
 
-static int coretemp_probe(struct platform_device *pdev)
+static int coretemp_device_add(int zoneid)
 {
-	struct device *dev = &pdev->dev;
+	struct platform_device *pdev;
 	struct platform_data *pdata;
+	int err;
 
 	/* Initialize the per-zone data structures */
-	pdata = devm_kzalloc(dev, sizeof(struct platform_data), GFP_KERNEL);
+	pdata = kzalloc(sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
 		return -ENOMEM;
 
-	pdata->pkg_id = pdev->id;
+	pdata->pkg_id = zoneid;
 	ida_init(&pdata->ida);
-	platform_set_drvdata(pdev, pdata);
 
-	pdata->hwmon_dev = devm_hwmon_device_register_with_groups(dev, DRVNAME,
-								  pdata, NULL);
-	return PTR_ERR_OR_ZERO(pdata->hwmon_dev);
-}
-
-static int coretemp_remove(struct platform_device *pdev)
-{
-	struct platform_data *pdata = platform_get_drvdata(pdev);
-	int i;
+	pdev = platform_device_alloc(DRVNAME, zoneid);
+	if (!pdev) {
+		err = -ENOMEM;
+		goto err_free_pdata;
+	}
 
-	for (i = MAX_CORE_DATA - 1; i >= 0; --i)
-		if (pdata->core_data[i])
-			coretemp_remove_core(pdata, i);
+	err = platform_device_add(pdev);
+	if (err)
+		goto err_put_dev;
 
-	ida_destroy(&pdata->ida);
+	platform_set_drvdata(pdev, pdata);
+	zone_devices[zoneid] = pdev;
 	return 0;
-}
 
-static struct platform_driver coretemp_driver = {
-	.driver = {
-		.name = DRVNAME,
-	},
-	.probe = coretemp_probe,
-	.remove = coretemp_remove,
-};
+err_put_dev:
+	platform_device_put(pdev);
+err_free_pdata:
+	kfree(pdata);
+	return err;
+}
 
-static struct platform_device *coretemp_device_add(unsigned int cpu)
+static void coretemp_device_remove(int zoneid)
 {
-	int err, zoneid = topology_logical_die_id(cpu);
-	struct platform_device *pdev;
-
-	if (zoneid < 0)
-		return ERR_PTR(-ENOMEM);
-
-	pdev = platform_device_alloc(DRVNAME, zoneid);
-	if (!pdev)
-		return ERR_PTR(-ENOMEM);
-
-	err = platform_device_add(pdev);
-	if (err) {
-		platform_device_put(pdev);
-		return ERR_PTR(err);
-	}
+	struct platform_device *pdev = zone_devices[zoneid];
+	struct platform_data *pdata = platform_get_drvdata(pdev);
 
-	zone_devices[zoneid] = pdev;
-	return pdev;
+	ida_destroy(&pdata->ida);
+	kfree(pdata);
+	platform_device_unregister(pdev);
 }
 
 static int coretemp_cpu_online(unsigned int cpu)
@@ -633,7 +616,10 @@ static int coretemp_cpu_online(unsigned int cpu)
 	if (!cpu_has(c, X86_FEATURE_DTHERM))
 		return -ENODEV;
 
-	if (!pdev) {
+	pdata = platform_get_drvdata(pdev);
+	if (!pdata->hwmon_dev) {
+		struct device *hwmon;
+
 		/* Check the microcode version of the CPU */
 		if (chk_ucode_version(cpu))
 			return -EINVAL;
@@ -644,9 +630,11 @@ static int coretemp_cpu_online(unsigned int cpu)
 		 * online. So, initialize per-pkg data structures and
 		 * then bring this core online.
 		 */
-		pdev = coretemp_device_add(cpu);
-		if (IS_ERR(pdev))
-			return PTR_ERR(pdev);
+		hwmon = hwmon_device_register_with_groups(&pdev->dev, DRVNAME,
+							  pdata, NULL);
+		if (IS_ERR(hwmon))
+			return PTR_ERR(hwmon);
+		pdata->hwmon_dev = hwmon;
 
 		/*
 		 * Check whether pkgtemp support is available.
@@ -656,7 +644,6 @@ static int coretemp_cpu_online(unsigned int cpu)
 			coretemp_add_core(pdev, cpu, 1);
 	}
 
-	pdata = platform_get_drvdata(pdev);
 	/*
 	 * Check whether a thread sibling is already online. If not add the
 	 * interface for this CPU core.
@@ -675,18 +662,14 @@ static int coretemp_cpu_offline(unsigned int cpu)
 	struct temp_data *tdata;
 	int i, indx = -1, target;
 
-	/*
-	 * Don't execute this on suspend as the device remove locks
-	 * up the machine.
-	 */
+	/* No need to tear down any interfaces for suspend */
 	if (cpuhp_tasks_frozen)
 		return 0;
 
 	/* If the physical CPU device does not exist, just return */
-	if (!pdev)
-		return 0;
-
 	pd = platform_get_drvdata(pdev);
+	if (!pd->hwmon_dev)
+		return 0;
 
 	for (i = 0; i < NUM_REAL_CORES; i++) {
 		if (pd->cpu_map[i] == topology_core_id(cpu)) {
@@ -718,13 +701,14 @@ static int coretemp_cpu_offline(unsigned int cpu)
 	}
 
 	/*
-	 * If all cores in this pkg are offline, remove the device. This
-	 * will invoke the platform driver remove function, which cleans up
-	 * the rest.
+	 * If all cores in this pkg are offline, remove the interface.
 	 */
+	tdata = pd->core_data[PKG_SYSFS_ATTR_NO];
 	if (cpumask_empty(&pd->cpumask)) {
-		zone_devices[topology_logical_die_id(cpu)] = NULL;
-		platform_device_unregister(pdev);
+		if (tdata)
+			coretemp_remove_core(pd, PKG_SYSFS_ATTR_NO);
+		hwmon_device_unregister(pd->hwmon_dev);
+		pd->hwmon_dev = NULL;
 		return 0;
 	}
 
@@ -732,7 +716,6 @@ static int coretemp_cpu_offline(unsigned int cpu)
 	 * Check whether this core is the target for the package
 	 * interface. We need to assign it to some other cpu.
 	 */
-	tdata = pd->core_data[PKG_SYSFS_ATTR_NO];
 	if (tdata && tdata->cpu == cpu) {
 		target = cpumask_first(&pd->cpumask);
 		mutex_lock(&tdata->update_lock);
@@ -751,7 +734,7 @@ static enum cpuhp_state coretemp_hp_online;
 
 static int __init coretemp_init(void)
 {
-	int err;
+	int i, err;
 
 	/*
 	 * CPUID.06H.EAX[0] indicates whether the CPU has thermal
@@ -767,20 +750,22 @@ static int __init coretemp_init(void)
 	if (!zone_devices)
 		return -ENOMEM;
 
-	err = platform_driver_register(&coretemp_driver);
-	if (err)
-		goto outzone;
+	for (i = 0; i < max_zones; i++) {
+		err = coretemp_device_add(i);
+		if (err)
+			goto outzone;
+	}
 
 	err = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN, "hwmon/coretemp:online",
 				coretemp_cpu_online, coretemp_cpu_offline);
 	if (err < 0)
-		goto outdrv;
+		goto outzone;
 	coretemp_hp_online = err;
 	return 0;
 
-outdrv:
-	platform_driver_unregister(&coretemp_driver);
 outzone:
+	while (i--)
+		coretemp_device_remove(i);
 	kfree(zone_devices);
 	return err;
 }
@@ -788,8 +773,11 @@ module_init(coretemp_init)
 
 static void __exit coretemp_exit(void)
 {
+	int i;
+
 	cpuhp_remove_state(coretemp_hp_online);
-	platform_driver_unregister(&coretemp_driver);
+	for (i = 0; i < max_zones; i++)
+		coretemp_device_remove(i);
 	kfree(zone_devices);
 }
 module_exit(coretemp_exit)
diff --git a/drivers/hwmon/ltc2945.c b/drivers/hwmon/ltc2945.c
index 2818276ed3d6..a1dd1ef40b56 100644
--- a/drivers/hwmon/ltc2945.c
+++ b/drivers/hwmon/ltc2945.c
@@ -248,6 +248,8 @@ static ssize_t ltc2945_value_store(struct device *dev,
 
 	/* convert to register value, then clamp and write result */
 	regval = ltc2945_val_to_reg(dev, reg, val);
+	if (regval < 0)
+		return regval;
 	if (is_power_reg(reg)) {
 		regval = clamp_val(regval, 0, 0xffffff);
 		regbuf[0] = regval >> 16;
diff --git a/drivers/hwmon/mlxreg-fan.c b/drivers/hwmon/mlxreg-fan.c
index bd8f5a3aaad9..052c897a635d 100644
--- a/drivers/hwmon/mlxreg-fan.c
+++ b/drivers/hwmon/mlxreg-fan.c
@@ -127,6 +127,12 @@ mlxreg_fan_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 			if (err)
 				return err;
 
+			if (MLXREG_FAN_GET_FAULT(regval, tacho->mask)) {
+				/* FAN is broken - return zero for FAN speed. */
+				*val = 0;
+				return 0;
+			}
+
 			*val = MLXREG_FAN_GET_RPM(regval, fan->divider,
 						  fan->samples);
 			break;
diff --git a/drivers/iio/accel/mma9551_core.c b/drivers/iio/accel/mma9551_core.c
index 666e7a04a7d7..9bb5c2fea08c 100644
--- a/drivers/iio/accel/mma9551_core.c
+++ b/drivers/iio/accel/mma9551_core.c
@@ -296,9 +296,12 @@ int mma9551_read_config_word(struct i2c_client *client, u8 app_id,
 
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
 
@@ -354,9 +357,12 @@ int mma9551_read_status_word(struct i2c_client *client, u8 app_id,
 
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
 
diff --git a/drivers/input/keyboard/omap-keypad.c b/drivers/input/keyboard/omap-keypad.c
index 5fe7a5633e33..dbe836c7ff47 100644
--- a/drivers/input/keyboard/omap-keypad.c
+++ b/drivers/input/keyboard/omap-keypad.c
@@ -46,7 +46,7 @@ struct omap_kp {
 	unsigned short keymap[];
 };
 
-static DECLARE_TASKLET_DISABLED(kp_tasklet, omap_kp_tasklet, 0);
+static DECLARE_TASKLET_DISABLED_OLD(kp_tasklet, omap_kp_tasklet);
 
 static unsigned int *row_gpios;
 static unsigned int *col_gpios;
diff --git a/drivers/input/serio/hil_mlc.c b/drivers/input/serio/hil_mlc.c
index 4c039e4125d9..d36e89d6fc54 100644
--- a/drivers/input/serio/hil_mlc.c
+++ b/drivers/input/serio/hil_mlc.c
@@ -77,7 +77,7 @@ static struct timer_list	hil_mlcs_kicker;
 static int			hil_mlcs_probe, hil_mlc_stop;
 
 static void hil_mlcs_process(unsigned long unused);
-static DECLARE_TASKLET_DISABLED(hil_mlcs_tasklet, hil_mlcs_process, 0);
+static DECLARE_TASKLET_DISABLED_OLD(hil_mlcs_tasklet, hil_mlcs_process);
 
 
 /* #define HIL_MLC_DEBUG */
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index d247d0ae82d2..0506115211dd 100644
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
@@ -1376,8 +1370,9 @@ static int ads7846_probe(struct spi_device *spi)
 			pdata->y_min ? : 0,
 			pdata->y_max ? : MAX_12BIT,
 			0, 0);
-	input_set_abs_params(input_dev, ABS_PRESSURE,
-			pdata->pressure_min, pdata->pressure_max, 0, 0);
+	if (ts->model != 7845)
+		input_set_abs_params(input_dev, ABS_PRESSURE,
+				pdata->pressure_min, pdata->pressure_max, 0, 0);
 
 	/*
 	 * Parse common framework properties. Must be done here to ensure the
diff --git a/drivers/irqchip/irq-alpine-msi.c b/drivers/irqchip/irq-alpine-msi.c
index ede02dc2bcd0..1819bb1d2723 100644
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
index 586df3587be0..d308bbe6f528 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -268,7 +268,8 @@ static int __init bcm7120_l2_intc_probe(struct device_node *dn,
 		flags |= IRQ_GC_BE_IO;
 
 	ret = irq_alloc_domain_generic_chips(data->domain, IRQS_PER_WORD, 1,
-				dn->full_name, handle_level_irq, clr, 0, flags);
+				dn->full_name, handle_level_irq, clr,
+				IRQ_LEVEL, flags);
 	if (ret) {
 		pr_err("failed to allocate generic irq chip\n");
 		goto out_free_domain;
diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
index 0298ede67e51..f803ecb6a0fa 100644
--- a/drivers/irqchip/irq-brcmstb-l2.c
+++ b/drivers/irqchip/irq-brcmstb-l2.c
@@ -161,6 +161,7 @@ static int __init brcmstb_l2_intc_of_init(struct device_node *np,
 					  *init_params)
 {
 	unsigned int clr = IRQ_NOREQUEST | IRQ_NOPROBE | IRQ_NOAUTOEN;
+	unsigned int set = 0;
 	struct brcmstb_l2_intc_data *data;
 	struct irq_chip_type *ct;
 	int ret;
@@ -208,9 +209,12 @@ static int __init brcmstb_l2_intc_of_init(struct device_node *np,
 	if (IS_ENABLED(CONFIG_MIPS) && IS_ENABLED(CONFIG_CPU_BIG_ENDIAN))
 		flags |= IRQ_GC_BE_IO;
 
+	if (init_params->handler == handle_level_irq)
+		set |= IRQ_LEVEL;
+
 	/* Allocate a single Generic IRQ chip for this node */
 	ret = irq_alloc_domain_generic_chips(data->domain, 32, 1,
-			np->full_name, init_params->handler, clr, 0, flags);
+			np->full_name, init_params->handler, clr, set, flags);
 	if (ret) {
 		pr_err("failed to allocate generic irq chip\n");
 		goto out_free_domain;
diff --git a/drivers/irqchip/irq-mvebu-gicp.c b/drivers/irqchip/irq-mvebu-gicp.c
index 3be5c5dba1da..5caec411059f 100644
--- a/drivers/irqchip/irq-mvebu-gicp.c
+++ b/drivers/irqchip/irq-mvebu-gicp.c
@@ -223,6 +223,7 @@ static int mvebu_gicp_probe(struct platform_device *pdev)
 	}
 
 	parent_domain = irq_find_host(irq_parent_dn);
+	of_node_put(irq_parent_dn);
 	if (!parent_domain) {
 		dev_err(&pdev->dev, "failed to find parent IRQ domain\n");
 		return -ENODEV;
diff --git a/drivers/irqchip/irq-ti-sci-intr.c b/drivers/irqchip/irq-ti-sci-intr.c
index 59d51a20bbd8..7d0163d85fb9 100644
--- a/drivers/irqchip/irq-ti-sci-intr.c
+++ b/drivers/irqchip/irq-ti-sci-intr.c
@@ -205,6 +205,7 @@ static int ti_sci_intr_irq_domain_probe(struct platform_device *pdev)
 	}
 
 	parent_domain = irq_find_host(parent_node);
+	of_node_put(parent_node);
 	if (!parent_domain) {
 		dev_err(dev, "Failed to find IRQ parent domain\n");
 		return -ENODEV;
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 10b2a4e10a46..08b5e44df324 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1910,6 +1910,7 @@ static void process_deferred_bios(struct work_struct *ws)
 
 		else
 			commit_needed = process_bio(cache, bio) || commit_needed;
+		cond_resched();
 	}
 
 	if (commit_needed)
@@ -1932,6 +1933,7 @@ static void requeue_deferred_bios(struct cache *cache)
 	while ((bio = bio_list_pop(&bios))) {
 		bio->bi_status = BLK_STS_DM_REQUEUE;
 		bio_endio(bio);
+		cond_resched();
 	}
 }
 
@@ -1972,6 +1974,8 @@ static void check_migrations(struct work_struct *ws)
 		r = mg_start(cache, op, NULL);
 		if (r)
 			break;
+
+		cond_resched();
 	}
 }
 
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 2900fbde89b3..bed263267323 100644
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
@@ -360,9 +363,11 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
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
 
@@ -388,13 +393,14 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 		return DM_ENDIO_DONE;
 
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
index 4f161725dda0..999447bde820 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2224,6 +2224,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 			throttle_work_update(&pool->throttle);
 			dm_pool_issue_prefetches(pool->pmd);
 		}
+		cond_resched();
 	}
 	blk_finish_plug(&plug);
 }
@@ -2307,6 +2308,7 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 			else
 				pool->process_cell(tc, cell);
 		}
+		cond_resched();
 	} while (!list_empty(&cells));
 }
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d4cebb38709b..b58ff1a0fda7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -263,7 +263,6 @@ static int __init local_init(void)
 
 static void local_exit(void)
 {
-	flush_scheduled_work();
 	destroy_workqueue(deferred_remove_workqueue);
 
 	unregister_blkdev(_major, _name);
diff --git a/drivers/media/i2c/ov5675.c b/drivers/media/i2c/ov5675.c
index 1ae252378799..477f61b8559c 100644
--- a/drivers/media/i2c/ov5675.c
+++ b/drivers/media/i2c/ov5675.c
@@ -722,8 +722,10 @@ static int ov5675_init_controls(struct ov5675 *ov5675)
 				     V4L2_CID_TEST_PATTERN,
 				     ARRAY_SIZE(ov5675_test_pattern_menu) - 1,
 				     0, 0, ov5675_test_pattern_menu);
-	if (ctrl_hdlr->error)
+	if (ctrl_hdlr->error) {
+		v4l2_ctrl_handler_free(ctrl_hdlr);
 		return ctrl_hdlr->error;
+	}
 
 	ov5675->sd.ctrl_handler = ctrl_hdlr;
 
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 154776d0069e..e47800cb6c0f 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1824,7 +1824,7 @@ static int ov7670_parse_dt(struct device *dev,
 
 	if (bus_cfg.bus_type != V4L2_MBUS_PARALLEL) {
 		dev_err(dev, "Unsupported media bus type\n");
-		return ret;
+		return -EINVAL;
 	}
 	info->mbus_config = bus_cfg.bus.parallel.flags;
 
diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 2cc6a678069a..5033950a48ab 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -1397,7 +1397,7 @@ static int ov772x_probe(struct i2c_client *client)
 	priv->subdev.ctrl_handler = &priv->hdl;
 	if (priv->hdl.error) {
 		ret = priv->hdl.error;
-		goto error_mutex_destroy;
+		goto error_ctrl_free;
 	}
 
 	priv->clk = clk_get(&client->dev, NULL);
@@ -1446,7 +1446,6 @@ static int ov772x_probe(struct i2c_client *client)
 	clk_put(priv->clk);
 error_ctrl_free:
 	v4l2_ctrl_handler_free(&priv->hdl);
-error_mutex_destroy:
 	mutex_destroy(&priv->lock);
 
 	return ret;
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2.c b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
index 7808ec1052bf..3457f0f545c4 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1871,6 +1871,9 @@ static void cio2_pci_remove(struct pci_dev *pci_dev)
 	v4l2_device_unregister(&cio2->v4l2_dev);
 	media_device_cleanup(&cio2->media_dev);
 	mutex_destroy(&cio2->lock);
+
+	pm_runtime_forbid(&pci_dev->dev);
+	pm_runtime_get_noresume(&pci_dev->dev);
 }
 
 static int __maybe_unused cio2_runtime_suspend(struct device *dev)
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index dce6b3685e13..88d491a8e326 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2312,7 +2312,16 @@ static int isp_probe(struct platform_device *pdev)
 
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
index 82867a2a60b0..20cadff242cf 100644
--- a/drivers/media/rc/ene_ir.c
+++ b/drivers/media/rc/ene_ir.c
@@ -1106,6 +1106,8 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 	struct ene_device *dev = pnp_get_drvdata(pnp_dev);
 	unsigned long flags;
 
+	rc_unregister_device(dev->rdev);
+	del_timer_sync(&dev->tx_sim_timer);
 	spin_lock_irqsave(&dev->hw_lock, flags);
 	ene_rx_disable(dev);
 	ene_rx_restore_hw_buffer(dev);
@@ -1113,7 +1115,6 @@ static void ene_remove(struct pnp_dev *pnp_dev)
 
 	free_irq(dev->irq, dev);
 	release_region(dev->hw_io, ENE_IO_SIZE);
-	rc_unregister_device(dev->rdev);
 	kfree(dev);
 }
 
diff --git a/drivers/media/usb/siano/smsusb.c b/drivers/media/usb/siano/smsusb.c
index 9ba3a2ae36e5..1db232a1063b 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -179,6 +179,7 @@ static void smsusb_stop_streaming(struct smsusb_device_t *dev)
 
 	for (i = 0; i < MAX_URBS; i++) {
 		usb_kill_urb(&dev->surbs[i].urb);
+		cancel_work_sync(&dev->surbs[i].wq);
 
 		if (dev->surbs[i].cb) {
 			smscore_putbuffer(dev->coredev, dev->surbs[i].cb);
diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 36abe47997b0..e0d894c61f4b 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -6,6 +6,7 @@
  *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  */
 
+#include <asm/barrier.h>
 #include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/module.h>
@@ -1275,17 +1276,12 @@ static void uvc_ctrl_send_slave_event(struct uvc_video_chain *chain,
 	uvc_ctrl_send_event(chain, handle, ctrl, mapping, val, changes);
 }
 
-static void uvc_ctrl_status_event_work(struct work_struct *work)
+void uvc_ctrl_status_event(struct uvc_video_chain *chain,
+			   struct uvc_control *ctrl, const u8 *data)
 {
-	struct uvc_device *dev = container_of(work, struct uvc_device,
-					      async_ctrl.work);
-	struct uvc_ctrl_work *w = &dev->async_ctrl;
-	struct uvc_video_chain *chain = w->chain;
 	struct uvc_control_mapping *mapping;
-	struct uvc_control *ctrl = w->ctrl;
 	struct uvc_fh *handle;
 	unsigned int i;
-	int ret;
 
 	mutex_lock(&chain->ctrl_mutex);
 
@@ -1293,7 +1289,7 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 	ctrl->handle = NULL;
 
 	list_for_each_entry(mapping, &ctrl->info.mappings, list) {
-		s32 value = __uvc_ctrl_get_value(mapping, w->data);
+		s32 value = __uvc_ctrl_get_value(mapping, data);
 
 		/*
 		 * handle may be NULL here if the device sends auto-update
@@ -1312,6 +1308,20 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 	}
 
 	mutex_unlock(&chain->ctrl_mutex);
+}
+
+static void uvc_ctrl_status_event_work(struct work_struct *work)
+{
+	struct uvc_device *dev = container_of(work, struct uvc_device,
+					      async_ctrl.work);
+	struct uvc_ctrl_work *w = &dev->async_ctrl;
+	int ret;
+
+	uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
+
+	/* The barrier is needed to synchronize with uvc_status_stop(). */
+	if (smp_load_acquire(&dev->flush_status))
+		return;
 
 	/* Resubmit the URB. */
 	w->urb->interval = dev->int_ep->desc.bInterval;
@@ -1321,8 +1331,8 @@ static void uvc_ctrl_status_event_work(struct work_struct *work)
 			   ret);
 }
 
-bool uvc_ctrl_status_event(struct urb *urb, struct uvc_video_chain *chain,
-			   struct uvc_control *ctrl, const u8 *data)
+bool uvc_ctrl_status_event_async(struct urb *urb, struct uvc_video_chain *chain,
+				 struct uvc_control *ctrl, const u8 *data)
 {
 	struct uvc_device *dev = chain->dev;
 	struct uvc_ctrl_work *w = &dev->async_ctrl;
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 40ca1d4e0348..0caa57a6782a 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1060,10 +1060,8 @@ static int uvc_parse_vendor_control(struct uvc_device *dev,
 					       + n;
 		memcpy(unit->extension.bmControls, &buffer[23+p], 2*n);
 
-		if (buffer[24+p+2*n] != 0)
-			usb_string(udev, buffer[24+p+2*n], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[24+p+2*n] == 0 ||
+		    usb_string(udev, buffer[24+p+2*n], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Extension %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -1188,15 +1186,15 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 			memcpy(term->media.bmTransportModes, &buffer[10+n], p);
 		}
 
-		if (buffer[7] != 0)
-			usb_string(udev, buffer[7], term->name,
-				   sizeof(term->name));
-		else if (UVC_ENTITY_TYPE(term) == UVC_ITT_CAMERA)
-			sprintf(term->name, "Camera %u", buffer[3]);
-		else if (UVC_ENTITY_TYPE(term) == UVC_ITT_MEDIA_TRANSPORT_INPUT)
-			sprintf(term->name, "Media %u", buffer[3]);
-		else
-			sprintf(term->name, "Input %u", buffer[3]);
+		if (buffer[7] == 0 ||
+		    usb_string(udev, buffer[7], term->name, sizeof(term->name)) < 0) {
+			if (UVC_ENTITY_TYPE(term) == UVC_ITT_CAMERA)
+				sprintf(term->name, "Camera %u", buffer[3]);
+			if (UVC_ENTITY_TYPE(term) == UVC_ITT_MEDIA_TRANSPORT_INPUT)
+				sprintf(term->name, "Media %u", buffer[3]);
+			else
+				sprintf(term->name, "Input %u", buffer[3]);
+		}
 
 		list_add_tail(&term->list, &dev->entities);
 		break;
@@ -1228,10 +1226,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		memcpy(term->baSourceID, &buffer[7], 1);
 
-		if (buffer[8] != 0)
-			usb_string(udev, buffer[8], term->name,
-				   sizeof(term->name));
-		else
+		if (buffer[8] == 0 ||
+		    usb_string(udev, buffer[8], term->name, sizeof(term->name)) < 0)
 			sprintf(term->name, "Output %u", buffer[3]);
 
 		list_add_tail(&term->list, &dev->entities);
@@ -1253,10 +1249,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		memcpy(unit->baSourceID, &buffer[5], p);
 
-		if (buffer[5+p] != 0)
-			usb_string(udev, buffer[5+p], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[5+p] == 0 ||
+		    usb_string(udev, buffer[5+p], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Selector %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -1286,10 +1280,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		if (dev->uvc_version >= 0x0110)
 			unit->processing.bmVideoStandards = buffer[9+n];
 
-		if (buffer[8+n] != 0)
-			usb_string(udev, buffer[8+n], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[8+n] == 0 ||
+		    usb_string(udev, buffer[8+n], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Processing %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -1317,10 +1309,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 		unit->extension.bmControls = (u8 *)unit + sizeof(*unit);
 		memcpy(unit->extension.bmControls, &buffer[23+p], n);
 
-		if (buffer[23+p+n] != 0)
-			usb_string(udev, buffer[23+p+n], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[23+p+n] == 0 ||
+		    usb_string(udev, buffer[23+p+n], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Extension %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -2472,6 +2462,24 @@ static const struct usb_device_id uvc_ids[] = {
 	  .bInterfaceSubClass	= 1,
 	  .bInterfaceProtocol	= 0,
 	  .driver_info		= (kernel_ulong_t)&uvc_quirk_probe_minmax },
+	/* Logitech, Webcam C910 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x046d,
+	  .idProduct		= 0x0821,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_WAKE_AUTOSUSPEND)},
+	/* Logitech, Webcam B910 */
+	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
+				| USB_DEVICE_ID_MATCH_INT_INFO,
+	  .idVendor		= 0x046d,
+	  .idProduct		= 0x0823,
+	  .bInterfaceClass	= USB_CLASS_VIDEO,
+	  .bInterfaceSubClass	= 1,
+	  .bInterfaceProtocol	= 0,
+	  .driver_info		= UVC_INFO_QUIRK(UVC_QUIRK_WAKE_AUTOSUSPEND)},
 	/* Logitech Quickcam Fusion */
 	{ .match_flags		= USB_DEVICE_ID_MATCH_DEVICE
 				| USB_DEVICE_ID_MATCH_INT_INFO,
diff --git a/drivers/media/usb/uvc/uvc_entity.c b/drivers/media/usb/uvc/uvc_entity.c
index ca3a9c2eec27..7c9895377118 100644
--- a/drivers/media/usb/uvc/uvc_entity.c
+++ b/drivers/media/usb/uvc/uvc_entity.c
@@ -37,7 +37,7 @@ static int uvc_mc_create_links(struct uvc_video_chain *chain,
 			continue;
 
 		remote = uvc_entity_by_id(chain->dev, entity->baSourceID[i]);
-		if (remote == NULL)
+		if (remote == NULL || remote->num_pads == 0)
 			return -EINVAL;
 
 		source = (UVC_ENTITY_TYPE(remote) == UVC_TT_STREAMING)
diff --git a/drivers/media/usb/uvc/uvc_status.c b/drivers/media/usb/uvc/uvc_status.c
index 2bdb0ff203f8..73725051cc16 100644
--- a/drivers/media/usb/uvc/uvc_status.c
+++ b/drivers/media/usb/uvc/uvc_status.c
@@ -6,6 +6,7 @@
  *          Laurent Pinchart (laurent.pinchart@ideasonboard.com)
  */
 
+#include <asm/barrier.h>
 #include <linux/kernel.h>
 #include <linux/input.h>
 #include <linux/slab.h>
@@ -179,7 +180,8 @@ static bool uvc_event_control(struct urb *urb,
 
 	switch (status->bAttribute) {
 	case UVC_CTRL_VALUE_CHANGE:
-		return uvc_ctrl_status_event(urb, chain, ctrl, status->bValue);
+		return uvc_ctrl_status_event_async(urb, chain, ctrl,
+						   status->bValue);
 
 	case UVC_CTRL_INFO_CHANGE:
 	case UVC_CTRL_FAILURE_CHANGE:
@@ -309,5 +311,41 @@ int uvc_status_start(struct uvc_device *dev, gfp_t flags)
 
 void uvc_status_stop(struct uvc_device *dev)
 {
+	struct uvc_ctrl_work *w = &dev->async_ctrl;
+
+	/*
+	 * Prevent the asynchronous control handler from requeing the URB. The
+	 * barrier is needed so the flush_status change is visible to other
+	 * CPUs running the asynchronous handler before usb_kill_urb() is
+	 * called below.
+	 */
+	smp_store_release(&dev->flush_status, true);
+
+	/*
+	 * Cancel any pending asynchronous work. If any status event was queued,
+	 * process it synchronously.
+	 */
+	if (cancel_work_sync(&w->work))
+		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
+
+	/* Kill the urb. */
 	usb_kill_urb(dev->int_urb);
+
+	/*
+	 * The URB completion handler may have queued asynchronous work. This
+	 * won't resubmit the URB as flush_status is set, but it needs to be
+	 * cancelled before returning or it could then race with a future
+	 * uvc_status_start() call.
+	 */
+	if (cancel_work_sync(&w->work))
+		uvc_ctrl_status_event(w->chain, w->ctrl, w->data);
+
+	/*
+	 * From this point, there are no events on the queue and the status URB
+	 * is dead. No events will be queued until uvc_status_start() is called.
+	 * The barrier is needed to make sure that flush_status is visible to
+	 * uvc_ctrl_status_event_work() when uvc_status_start() will be called
+	 * again.
+	 */
+	smp_store_release(&dev->flush_status, false);
 }
diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
index fe58723fc5ac..e676a9ef6f0d 100644
--- a/drivers/media/usb/uvc/uvc_video.c
+++ b/drivers/media/usb/uvc/uvc_video.c
@@ -1308,7 +1308,9 @@ static void uvc_video_decode_meta(struct uvc_streaming *stream,
 	if (has_scr)
 		memcpy(stream->clock.last_scr, scr, 6);
 
-	memcpy(&meta->length, mem, length);
+	meta->length = mem[0];
+	meta->flags  = mem[1];
+	memcpy(meta->buf, &mem[2], length - 2);
 	meta_buf->bytesused += length + sizeof(meta->ns) + sizeof(meta->sof);
 
 	uvc_trace(UVC_TRACE_FRAME,
@@ -1903,6 +1905,17 @@ static int uvc_video_start_transfer(struct uvc_streaming *stream,
 		uvc_trace(UVC_TRACE_VIDEO, "Selecting alternate setting %u "
 			"(%u B/frame bandwidth).\n", altsetting, best_psize);
 
+		/*
+		 * Some devices, namely the Logitech C910 and B910, are unable
+		 * to recover from a USB autosuspend, unless the alternate
+		 * setting of the streaming interface is toggled.
+		 */
+		if (stream->dev->quirks & UVC_QUIRK_WAKE_AUTOSUSPEND) {
+			usb_set_interface(stream->dev->udev, intfnum,
+					  altsetting);
+			usb_set_interface(stream->dev->udev, intfnum, 0);
+		}
+
 		ret = usb_set_interface(stream->dev->udev, intfnum, altsetting);
 		if (ret < 0)
 			return ret;
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 5f137400bebd..9f5b9601eadc 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -199,6 +199,7 @@
 #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
 #define UVC_QUIRK_FORCE_Y8		0x00000800
 #define UVC_QUIRK_FORCE_BPP		0x00001000
+#define UVC_QUIRK_WAKE_AUTOSUSPEND	0x00002000
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
@@ -663,6 +664,7 @@ struct uvc_device {
 	/* Status Interrupt Endpoint */
 	struct usb_host_endpoint *int_ep;
 	struct urb *int_urb;
+	bool flush_status;
 	u8 *status;
 	struct input_dev *input;
 	char input_phys[64];
@@ -832,7 +834,9 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 int uvc_ctrl_init_device(struct uvc_device *dev);
 void uvc_ctrl_cleanup_device(struct uvc_device *dev);
 int uvc_ctrl_restore_values(struct uvc_device *dev);
-bool uvc_ctrl_status_event(struct urb *urb, struct uvc_video_chain *chain,
+bool uvc_ctrl_status_event_async(struct urb *urb, struct uvc_video_chain *chain,
+				 struct uvc_control *ctrl, const u8 *data);
+void uvc_ctrl_status_event(struct uvc_video_chain *chain,
 			   struct uvc_control *ctrl, const u8 *data);
 
 int uvc_ctrl_begin(struct uvc_video_chain *chain);
diff --git a/drivers/mfd/arizona-core.c b/drivers/mfd/arizona-core.c
index 3ff872c205ee..07d256e6875c 100644
--- a/drivers/mfd/arizona-core.c
+++ b/drivers/mfd/arizona-core.c
@@ -45,7 +45,7 @@ int arizona_clk32k_enable(struct arizona *arizona)
 	if (arizona->clk32k_ref == 1) {
 		switch (arizona->pdata.clk32k_src) {
 		case ARIZONA_32KZ_MCLK1:
-			ret = pm_runtime_get_sync(arizona->dev);
+			ret = pm_runtime_resume_and_get(arizona->dev);
 			if (ret != 0)
 				goto err_ref;
 			ret = clk_prepare_enable(arizona->mclk[ARIZONA_MCLK1]);
diff --git a/drivers/mfd/pcf50633-adc.c b/drivers/mfd/pcf50633-adc.c
index 5cd653e61512..191b1bc6141c 100644
--- a/drivers/mfd/pcf50633-adc.c
+++ b/drivers/mfd/pcf50633-adc.c
@@ -136,6 +136,7 @@ int pcf50633_adc_async_read(struct pcf50633 *pcf, int mux, int avg,
 			     void *callback_param)
 {
 	struct pcf50633_adc_request *req;
+	int ret;
 
 	/* req is freed when the result is ready, in interrupt handler */
 	req = kmalloc(sizeof(*req), GFP_KERNEL);
@@ -147,7 +148,11 @@ int pcf50633_adc_async_read(struct pcf50633 *pcf, int mux, int avg,
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
 
diff --git a/drivers/misc/mei/bus-fixup.c b/drivers/misc/mei/bus-fixup.c
index 0a2b99e1af45..27262e701f30 100644
--- a/drivers/misc/mei/bus-fixup.c
+++ b/drivers/misc/mei/bus-fixup.c
@@ -178,7 +178,7 @@ static int mei_fwver(struct mei_cl_device *cldev)
 	ret = __mei_cl_send(cldev->cl, buf, sizeof(struct mkhi_msg_hdr),
 			    MEI_CL_IO_TX_BLOCKING);
 	if (ret < 0) {
-		dev_err(&cldev->dev, "Could not send ReqFWVersion cmd\n");
+		dev_err(&cldev->dev, "Could not send ReqFWVersion cmd ret = %d\n", ret);
 		return ret;
 	}
 
@@ -190,7 +190,7 @@ static int mei_fwver(struct mei_cl_device *cldev)
 		 * Should be at least one version block,
 		 * error out if nothing found
 		 */
-		dev_err(&cldev->dev, "Could not read FW version\n");
+		dev_err(&cldev->dev, "Could not read FW version ret = %d\n", bytes_recv);
 		return -EIO;
 	}
 
@@ -339,7 +339,7 @@ static int mei_nfc_if_version(struct mei_cl *cl,
 	ret = __mei_cl_send(cl, (u8 *)&cmd, sizeof(struct mei_nfc_cmd),
 			    MEI_CL_IO_TX_BLOCKING);
 	if (ret < 0) {
-		dev_err(bus->dev, "Could not send IF version cmd\n");
+		dev_err(bus->dev, "Could not send IF version cmd ret = %d\n", ret);
 		return ret;
 	}
 
@@ -354,7 +354,7 @@ static int mei_nfc_if_version(struct mei_cl *cl,
 	ret = 0;
 	bytes_recv = __mei_cl_recv(cl, (u8 *)reply, if_version_length, 0, 0);
 	if (bytes_recv < 0 || (size_t)bytes_recv < if_version_length) {
-		dev_err(bus->dev, "Could not read IF version\n");
+		dev_err(bus->dev, "Could not read IF version ret = %d\n", bytes_recv);
 		ret = -EIO;
 		goto err;
 	}
diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 45c376fc571a..0f3bce3fb00b 100644
--- a/drivers/mtd/nand/raw/sunxi_nand.c
+++ b/drivers/mtd/nand/raw/sunxi_nand.c
@@ -1587,7 +1587,7 @@ static int sunxi_nand_ooblayout_free(struct mtd_info *mtd, int section,
 	if (section < ecc->steps)
 		oobregion->length = 4;
 	else
-		oobregion->offset = mtd->oobsize - oobregion->offset;
+		oobregion->length = mtd->oobsize - oobregion->offset;
 
 	return 0;
 }
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index df521ff0b328..13f8292ceea5 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -467,6 +467,7 @@ static int uif_init(struct ubi_device *ubi)
 			err = ubi_add_volume(ubi, ubi->volumes[i]);
 			if (err) {
 				ubi_err(ubi, "cannot add volume %d", i);
+				ubi->volumes[i] = NULL;
 				goto out_volumes;
 			}
 		}
@@ -643,6 +644,12 @@ static int io_init(struct ubi_device *ubi, int max_beb_per1024)
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
index 6ea95ade4ca6..d79323e8ea29 100644
--- a/drivers/mtd/ubi/vmt.c
+++ b/drivers/mtd/ubi/vmt.c
@@ -464,7 +464,7 @@ int ubi_resize_volume(struct ubi_volume_desc *desc, int reserved_pebs)
 		for (i = 0; i < -pebs; i++) {
 			err = ubi_eba_unmap_leb(ubi, vol, reserved_pebs + i);
 			if (err)
-				goto out_acc;
+				goto out_free;
 		}
 		spin_lock(&ubi->volumes_lock);
 		ubi->rsvd_pebs += pebs;
@@ -512,8 +512,10 @@ int ubi_resize_volume(struct ubi_volume_desc *desc, int reserved_pebs)
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
 
@@ -580,6 +582,7 @@ int ubi_add_volume(struct ubi_device *ubi, struct ubi_volume *vol)
 	if (err) {
 		ubi_err(ubi, "cannot add character device for volume %d, error %d",
 			vol_id, err);
+		vol_release(&vol->dev);
 		return err;
 	}
 
@@ -590,15 +593,14 @@ int ubi_add_volume(struct ubi_device *ubi, struct ubi_volume *vol)
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
index 7def041bbe48..4f88433d4adc 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -879,8 +879,11 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 
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
 
@@ -962,11 +965,11 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
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
@@ -1110,14 +1113,18 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
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
@@ -1233,6 +1240,18 @@ int ubi_wl_put_peb(struct ubi_device *ubi, int vol_id, int lnum,
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
index 73c5343e609b..c9ccce6c60b4 100644
--- a/drivers/net/can/usb/esd_usb2.c
+++ b/drivers/net/can/usb/esd_usb2.c
@@ -278,7 +278,6 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 				cf->data[2] |= CAN_ERR_PROT_STUFF;
 				break;
 			default:
-				cf->data[3] = ecc & SJA1000_ECC_SEG;
 				break;
 			}
 
@@ -286,6 +285,9 @@ static void esd_usb2_rx_event(struct esd_usb2_net_priv *priv,
 			if (!(ecc & SJA1000_ECC_DIR))
 				cf->data[2] |= CAN_ERR_PROT_TX;
 
+			/* Bit stream position in CAN frame as the error was detected */
+			cf->data[3] = ecc & SJA1000_ECC_SEG;
+
 			if (priv->can.state == CAN_STATE_ERROR_WARNING ||
 			    priv->can.state == CAN_STATE_ERROR_PASSIVE) {
 				cf->data[1] = (txerr > rxerr) ?
diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index e03e2bfcc6a1..1b725a021455 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -1823,6 +1823,14 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
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
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index ae1d30567225..209ae9687584 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -3492,15 +3492,12 @@ int ice_vsi_cfg(struct ice_vsi *vsi)
 {
 	int err;
 
-	if (vsi->netdev) {
+	if (vsi->netdev && vsi->type == ICE_VSI_PF) {
 		ice_set_rx_mode(vsi->netdev);
 
-		if (vsi->type != ICE_VSI_LB) {
-			err = ice_vsi_vlan_setup(vsi);
-
-			if (err)
-				return err;
-		}
+		err = ice_vsi_vlan_setup(vsi);
+		if (err)
+			return err;
 	}
 	ice_vsi_cfg_dcb_rings(vsi);
 
@@ -3557,7 +3554,7 @@ static int ice_up_complete(struct ice_vsi *vsi)
 
 	if (vsi->port_info &&
 	    (vsi->port_info->phy.link_info.link_info & ICE_AQ_LINK_UP) &&
-	    vsi->netdev) {
+	    vsi->netdev && vsi->type == ICE_VSI_PF) {
 		ice_print_link_msg(vsi, true);
 		netif_tx_start_all_queues(vsi->netdev);
 		netif_carrier_on(vsi->netdev);
@@ -3567,7 +3564,9 @@ static int ice_up_complete(struct ice_vsi *vsi)
 	 * set the baseline so counters are ready when interface is up
 	 */
 	ice_update_eth_stats(vsi);
-	ice_service_task_schedule(pf);
+
+	if (vsi->type == ICE_VSI_PF)
+		ice_service_task_schedule(pf);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index db9ecc3a8c67..fcf5fef7c195 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -600,7 +600,7 @@ static int mlx5_tracer_handle_string_trace(struct mlx5_fw_tracer *tracer,
 	} else {
 		cur_string = mlx5_tracer_message_get(tracer, tracer_event);
 		if (!cur_string) {
-			pr_debug("%s Got string event for unknown string tdsm: %d\n",
+			pr_debug("%s Got string event for unknown string tmsn: %d\n",
 				 __func__, tracer_event->string_event.tmsn);
 			return -1;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c
index 23361a9ae4fa..6dc83e871cd7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/geneve.c
@@ -105,6 +105,7 @@ int mlx5_geneve_tlv_option_add(struct mlx5_geneve *geneve, struct geneve_opt *op
 		geneve->opt_type = opt->type;
 		geneve->obj_id = res;
 		geneve->refcount++;
+		res = 0;
 	}
 
 unlock:
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index db76c92b75e2..7f7693b709d7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -167,7 +167,8 @@ static int alloc_4k(struct mlx5_core_dev *dev, u64 *addr)
 	fp = list_entry(dev->priv.free_list.next, struct fw_page, list);
 	n = find_first_bit(&fp->bitmask, 8 * sizeof(fp->bitmask));
 	if (n >= MLX5_NUM_4K_IN_PAGE) {
-		mlx5_core_warn(dev, "alloc 4k bug\n");
+		mlx5_core_warn(dev, "alloc 4k bug: fw page = 0x%llx, n = %u, bitmask: %lu, max num of 4K pages: %d\n",
+			       fp->addr, n, fp->bitmask,  MLX5_NUM_4K_IN_PAGE);
 		return -ENOENT;
 	}
 	clear_bit(n, &fp->bitmask);
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index f870d08bb1f8..a522d1673fa8 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -525,7 +525,7 @@ static int tap_open(struct inode *inode, struct file *file)
 	q->sock.state = SS_CONNECTED;
 	q->sock.file = file;
 	q->sock.ops = &tap_socket_ops;
-	sock_init_data(&q->sock, &q->sk);
+	sock_init_data_uid(&q->sock, &q->sk, inode->i_uid);
 	q->sk.sk_write_space = tap_sock_write_space;
 	q->sk.sk_destruct = tap_sock_destruct;
 	q->flags = IFF_VNET_HDR | IFF_NO_PI | IFF_TAP;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 957e6051c535..5d94ac0250ec 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3525,7 +3525,7 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 	tfile->socket.file = file;
 	tfile->socket.ops = &tun_socket_ops;
 
-	sock_init_data(&tfile->socket, &tfile->sk);
+	sock_init_data_uid(&tfile->socket, &tfile->sk, inode->i_uid);
 
 	tfile->sk.sk_write_space = tun_sock_write_space;
 	tfile->sk.sk_sndbuf = INT_MAX;
diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index a2527351f8a7..6ac6a649d4c2 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -569,8 +569,8 @@ static void do_bottom_half_rx(struct fst_card_info *card);
 static void fst_process_tx_work_q(unsigned long work_q);
 static void fst_process_int_work_q(unsigned long work_q);
 
-static DECLARE_TASKLET(fst_tx_task, fst_process_tx_work_q, 0);
-static DECLARE_TASKLET(fst_int_task, fst_process_int_work_q, 0);
+static DECLARE_TASKLET_OLD(fst_tx_task, fst_process_tx_work_q);
+static DECLARE_TASKLET_OLD(fst_int_task, fst_process_int_work_q);
 
 static struct fst_card_info *fst_card_array[FST_MAX_CARDS];
 static spinlock_t fst_work_q_lock;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 796bd93c599b..4adbe3ab9c87 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -9462,7 +9462,5 @@ void ath10k_wmi_detach(struct ath10k *ar)
 	}
 
 	cancel_work_sync(&ar->svc_rdy_work);
-
-	if (ar->svc_rdy_skb)
-		dev_kfree_skb(ar->svc_rdy_skb);
+	dev_kfree_skb(ar->svc_rdy_skb);
 }
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 8a18a33b5b59..e23d58f83dd6 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -244,11 +244,11 @@ static inline void ath9k_skb_queue_complete(struct hif_device_usb *hif_dev,
 		ath9k_htc_txcompletion_cb(hif_dev->htc_handle,
 					  skb, txok);
 		if (txok) {
-			TX_STAT_INC(skb_success);
-			TX_STAT_ADD(skb_success_bytes, ln);
+			TX_STAT_INC(hif_dev, skb_success);
+			TX_STAT_ADD(hif_dev, skb_success_bytes, ln);
 		}
 		else
-			TX_STAT_INC(skb_failed);
+			TX_STAT_INC(hif_dev, skb_failed);
 	}
 }
 
@@ -302,7 +302,7 @@ static void hif_usb_tx_cb(struct urb *urb)
 	hif_dev->tx.tx_buf_cnt++;
 	if (!(hif_dev->tx.flags & HIF_USB_TX_STOP))
 		__hif_usb_tx(hif_dev); /* Check for pending SKBs */
-	TX_STAT_INC(buf_completed);
+	TX_STAT_INC(hif_dev, buf_completed);
 	spin_unlock(&hif_dev->tx.tx_lock);
 }
 
@@ -353,7 +353,7 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 			tx_buf->len += tx_buf->offset;
 
 		__skb_queue_tail(&tx_buf->skb_queue, nskb);
-		TX_STAT_INC(skb_queued);
+		TX_STAT_INC(hif_dev, skb_queued);
 	}
 
 	usb_fill_bulk_urb(tx_buf->urb, hif_dev->udev,
@@ -368,11 +368,10 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 		__skb_queue_head_init(&tx_buf->skb_queue);
 		list_move_tail(&tx_buf->list, &hif_dev->tx.tx_buf);
 		hif_dev->tx.tx_buf_cnt++;
+	} else {
+		TX_STAT_INC(hif_dev, buf_queued);
 	}
 
-	if (!ret)
-		TX_STAT_INC(buf_queued);
-
 	return ret;
 }
 
@@ -515,7 +514,7 @@ static void hif_usb_sta_drain(void *hif_handle, u8 idx)
 			ath9k_htc_txcompletion_cb(hif_dev->htc_handle,
 						  skb, false);
 			hif_dev->tx.tx_skb_cnt--;
-			TX_STAT_INC(skb_failed);
+			TX_STAT_INC(hif_dev, skb_failed);
 		}
 	}
 
@@ -562,11 +561,11 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 			memcpy(ptr, skb->data, rx_remain_len);
 
 			rx_pkt_len += rx_remain_len;
-			hif_dev->rx_remain_len = 0;
 			skb_put(remain_skb, rx_pkt_len);
 
 			skb_pool[pool_index++] = remain_skb;
-
+			hif_dev->remain_skb = NULL;
+			hif_dev->rx_remain_len = 0;
 		} else {
 			index = rx_remain_len;
 		}
@@ -585,16 +584,21 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 		pkt_len = get_unaligned_le16(ptr + index);
 		pkt_tag = get_unaligned_le16(ptr + index + 2);
 
+		/* It is supposed that if we have an invalid pkt_tag or
+		 * pkt_len then the whole input SKB is considered invalid
+		 * and dropped; the associated packets already in skb_pool
+		 * are dropped, too.
+		 */
 		if (pkt_tag != ATH_USB_RX_STREAM_MODE_TAG) {
-			RX_STAT_INC(skb_dropped);
-			return;
+			RX_STAT_INC(hif_dev, skb_dropped);
+			goto invalid_pkt;
 		}
 
 		if (pkt_len > 2 * MAX_RX_BUF_SIZE) {
 			dev_err(&hif_dev->udev->dev,
 				"ath9k_htc: invalid pkt_len (%x)\n", pkt_len);
-			RX_STAT_INC(skb_dropped);
-			return;
+			RX_STAT_INC(hif_dev, skb_dropped);
+			goto invalid_pkt;
 		}
 
 		pad_len = 4 - (pkt_len & 0x3);
@@ -606,11 +610,6 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 
 		if (index > MAX_RX_BUF_SIZE) {
 			spin_lock(&hif_dev->rx_lock);
-			hif_dev->rx_remain_len = index - MAX_RX_BUF_SIZE;
-			hif_dev->rx_transfer_len =
-				MAX_RX_BUF_SIZE - chk_idx - 4;
-			hif_dev->rx_pad_len = pad_len;
-
 			nskb = __dev_alloc_skb(pkt_len + 32, GFP_ATOMIC);
 			if (!nskb) {
 				dev_err(&hif_dev->udev->dev,
@@ -618,8 +617,14 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 				spin_unlock(&hif_dev->rx_lock);
 				goto err;
 			}
+
+			hif_dev->rx_remain_len = index - MAX_RX_BUF_SIZE;
+			hif_dev->rx_transfer_len =
+				MAX_RX_BUF_SIZE - chk_idx - 4;
+			hif_dev->rx_pad_len = pad_len;
+
 			skb_reserve(nskb, 32);
-			RX_STAT_INC(skb_allocated);
+			RX_STAT_INC(hif_dev, skb_allocated);
 
 			memcpy(nskb->data, &(skb->data[chk_idx+4]),
 			       hif_dev->rx_transfer_len);
@@ -640,7 +645,7 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 				goto err;
 			}
 			skb_reserve(nskb, 32);
-			RX_STAT_INC(skb_allocated);
+			RX_STAT_INC(hif_dev, skb_allocated);
 
 			memcpy(nskb->data, &(skb->data[chk_idx+4]), pkt_len);
 			skb_put(nskb, pkt_len);
@@ -650,11 +655,18 @@ static void ath9k_hif_usb_rx_stream(struct hif_device_usb *hif_dev,
 
 err:
 	for (i = 0; i < pool_index; i++) {
-		RX_STAT_ADD(skb_completed_bytes, skb_pool[i]->len);
+		RX_STAT_ADD(hif_dev, skb_completed_bytes, skb_pool[i]->len);
 		ath9k_htc_rx_msg(hif_dev->htc_handle, skb_pool[i],
 				 skb_pool[i]->len, USB_WLAN_RX_PIPE);
-		RX_STAT_INC(skb_completed);
+		RX_STAT_INC(hif_dev, skb_completed);
 	}
+	return;
+invalid_pkt:
+	for (i = 0; i < pool_index; i++) {
+		dev_kfree_skb_any(skb_pool[i]);
+		RX_STAT_INC(hif_dev, skb_dropped);
+	}
+	return;
 }
 
 static void ath9k_hif_usb_rx_cb(struct urb *urb)
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index 81107100e368..232e93dfbc83 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -325,14 +325,18 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
 }
 
 #ifdef CONFIG_ATH9K_HTC_DEBUGFS
-#define __STAT_SAFE(expr) (hif_dev->htc_handle->drv_priv ? (expr) : 0)
-#define TX_STAT_INC(c) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c++)
-#define TX_STAT_ADD(c, a) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.tx_stats.c += a)
-#define RX_STAT_INC(c) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c++)
-#define RX_STAT_ADD(c, a) __STAT_SAFE(hif_dev->htc_handle->drv_priv->debug.skbrx_stats.c += a)
-#define CAB_STAT_INC   priv->debug.tx_stats.cab_queued++
-
-#define TX_QSTAT_INC(q) (priv->debug.tx_stats.queue_stats[q]++)
+#define __STAT_SAFE(hif_dev, expr)	do { ((hif_dev)->htc_handle->drv_priv ? (expr) : 0); } while (0)
+#define CAB_STAT_INC(priv)		do { ((priv)->debug.tx_stats.cab_queued++); } while (0)
+#define TX_QSTAT_INC(priv, q)		do { ((priv)->debug.tx_stats.queue_stats[q]++); } while (0)
+
+#define TX_STAT_INC(hif_dev, c) \
+		__STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.tx_stats.c++)
+#define TX_STAT_ADD(hif_dev, c, a) \
+		__STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.tx_stats.c += a)
+#define RX_STAT_INC(hif_dev, c) \
+		__STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.skbrx_stats.c++)
+#define RX_STAT_ADD(hif_dev, c, a) \
+		__STAT_SAFE((hif_dev), (hif_dev)->htc_handle->drv_priv->debug.skbrx_stats.c += a)
 
 void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
 			   struct ath_rx_status *rs);
@@ -372,13 +376,13 @@ void ath9k_htc_get_et_stats(struct ieee80211_hw *hw,
 			    struct ethtool_stats *stats, u64 *data);
 #else
 
-#define TX_STAT_INC(c) do { } while (0)
-#define TX_STAT_ADD(c, a) do { } while (0)
-#define RX_STAT_INC(c) do { } while (0)
-#define RX_STAT_ADD(c, a) do { } while (0)
-#define CAB_STAT_INC   do { } while (0)
+#define TX_STAT_INC(hif_dev, c)		do { } while (0)
+#define TX_STAT_ADD(hif_dev, c, a)	do { } while (0)
+#define RX_STAT_INC(hif_dev, c)		do { } while (0)
+#define RX_STAT_ADD(hif_dev, c, a)	do { } while (0)
 
-#define TX_QSTAT_INC(c) do { } while (0)
+#define CAB_STAT_INC(priv)
+#define TX_QSTAT_INC(priv, c)
 
 static inline void ath9k_htc_err_stat_rx(struct ath9k_htc_priv *priv,
 					 struct ath_rx_status *rs)
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index eeaf63de71bf..ee021738bef0 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -106,20 +106,20 @@ static inline enum htc_endpoint_id get_htc_epid(struct ath9k_htc_priv *priv,
 
 	switch (qnum) {
 	case 0:
-		TX_QSTAT_INC(IEEE80211_AC_VO);
+		TX_QSTAT_INC(priv, IEEE80211_AC_VO);
 		epid = priv->data_vo_ep;
 		break;
 	case 1:
-		TX_QSTAT_INC(IEEE80211_AC_VI);
+		TX_QSTAT_INC(priv, IEEE80211_AC_VI);
 		epid = priv->data_vi_ep;
 		break;
 	case 2:
-		TX_QSTAT_INC(IEEE80211_AC_BE);
+		TX_QSTAT_INC(priv, IEEE80211_AC_BE);
 		epid = priv->data_be_ep;
 		break;
 	case 3:
 	default:
-		TX_QSTAT_INC(IEEE80211_AC_BK);
+		TX_QSTAT_INC(priv, IEEE80211_AC_BK);
 		epid = priv->data_bk_ep;
 		break;
 	}
@@ -323,7 +323,7 @@ static void ath9k_htc_tx_data(struct ath9k_htc_priv *priv,
 	memcpy(tx_fhdr, (u8 *) &tx_hdr, sizeof(tx_hdr));
 
 	if (is_cab) {
-		CAB_STAT_INC;
+		CAB_STAT_INC(priv);
 		tx_ctl->epid = priv->cab_ep;
 		return;
 	}
diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index ca05b07a45e6..fe62ff668f75 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -391,7 +391,7 @@ static void ath9k_htc_fw_panic_report(struct htc_target *htc_handle,
  * HTC Messages are handled directly here and the obtained SKB
  * is freed.
  *
- * Service messages (Data, WMI) passed to the corresponding
+ * Service messages (Data, WMI) are passed to the corresponding
  * endpoint RX handlers, which have to free the SKB.
  */
 void ath9k_htc_rx_msg(struct htc_target *htc_handle,
@@ -478,6 +478,8 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 		if (endpoint->ep_callbacks.rx)
 			endpoint->ep_callbacks.rx(endpoint->ep_callbacks.priv,
 						  skb, epid);
+		else
+			goto invalid;
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index e7a3127395be..deb22b8c2065 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -338,6 +338,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	if (!time_left) {
 		ath_dbg(common, WMI, "Timeout waiting for WMI command: %s\n",
 			wmi_cmd_to_name(cmd_id));
+		wmi->last_seq_id = 0;
 		mutex_unlock(&wmi->op_mutex);
 		return -ETIMEDOUT;
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index dec25e415619..e7c97dfd6928 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
@@ -264,6 +264,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 			 err);
 		goto done;
 	}
+	buf[sizeof(buf) - 1] = '\0';
 	ptr = (char *)buf;
 	strsep(&ptr, "\n");
 
@@ -280,15 +281,17 @@ int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 	if (err) {
 		brcmf_dbg(TRACE, "retrieving clmver failed, %d\n", err);
 	} else {
+		buf[sizeof(buf) - 1] = '\0';
 		clmver = (char *)buf;
-		/* store CLM version for adding it to revinfo debugfs file */
-		memcpy(ifp->drvr->clmver, clmver, sizeof(ifp->drvr->clmver));
 
 		/* Replace all newline/linefeed characters with space
 		 * character
 		 */
 		strreplace(clmver, '\n', ' ');
 
+		/* store CLM version for adding it to revinfo debugfs file */
+		memcpy(ifp->drvr->clmver, clmver, sizeof(ifp->drvr->clmver));
+
 		brcmf_dbg(INFO, "CLM version = %s\n", clmver);
 	}
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 5b7c1b99273d..4907a667f963 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -333,6 +333,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 			bphy_err(drvr, "%s: failed to expand headroom\n",
 				 brcmf_ifname(ifp));
 			atomic_inc(&drvr->bus_if->stats.pktcow_failed);
+			dev_kfree_skb(skb);
 			goto done;
 		}
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index c2705d7a4247..fd54acb85924 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -345,8 +345,11 @@ brcmf_msgbuf_alloc_pktid(struct device *dev,
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
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index a162146a43a7..752489331e1e 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -2294,10 +2294,11 @@ static int ipw2100_alloc_skb(struct ipw2100_priv *priv,
 		return -ENOMEM;
 
 	packet->rxp = (struct ipw2100_rx *)packet->skb->data;
-	packet->dma_addr = pci_map_single(priv->pci_dev, packet->skb->data,
+	packet->dma_addr = dma_map_single(&priv->pci_dev->dev,
+					  packet->skb->data,
 					  sizeof(struct ipw2100_rx),
-					  PCI_DMA_FROMDEVICE);
-	if (pci_dma_mapping_error(priv->pci_dev, packet->dma_addr)) {
+					  DMA_FROM_DEVICE);
+	if (dma_mapping_error(&priv->pci_dev->dev, packet->dma_addr)) {
 		dev_kfree_skb(packet->skb);
 		return -ENOMEM;
 	}
@@ -2478,9 +2479,8 @@ static void isr_rx(struct ipw2100_priv *priv, int i,
 		return;
 	}
 
-	pci_unmap_single(priv->pci_dev,
-			 packet->dma_addr,
-			 sizeof(struct ipw2100_rx), PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&priv->pci_dev->dev, packet->dma_addr,
+			 sizeof(struct ipw2100_rx), DMA_FROM_DEVICE);
 
 	skb_put(packet->skb, status->frame_size);
 
@@ -2562,8 +2562,8 @@ static void isr_rx_monitor(struct ipw2100_priv *priv, int i,
 		return;
 	}
 
-	pci_unmap_single(priv->pci_dev, packet->dma_addr,
-			 sizeof(struct ipw2100_rx), PCI_DMA_FROMDEVICE);
+	dma_unmap_single(&priv->pci_dev->dev, packet->dma_addr,
+			 sizeof(struct ipw2100_rx), DMA_FROM_DEVICE);
 	memmove(packet->skb->data + sizeof(struct ipw_rt_hdr),
 		packet->skb->data, status->frame_size);
 
@@ -2688,9 +2688,9 @@ static void __ipw2100_rx_process(struct ipw2100_priv *priv)
 
 		/* Sync the DMA for the RX buffer so CPU is sure to get
 		 * the correct values */
-		pci_dma_sync_single_for_cpu(priv->pci_dev, packet->dma_addr,
-					    sizeof(struct ipw2100_rx),
-					    PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&priv->pci_dev->dev, packet->dma_addr,
+					sizeof(struct ipw2100_rx),
+					DMA_FROM_DEVICE);
 
 		if (unlikely(ipw2100_corruption_check(priv, i))) {
 			ipw2100_corruption_detected(priv, i);
@@ -2922,9 +2922,8 @@ static int __ipw2100_tx_process(struct ipw2100_priv *priv)
 				     (packet->index + 1 + i) % txq->entries,
 				     tbd->host_addr, tbd->buf_length);
 
-			pci_unmap_single(priv->pci_dev,
-					 tbd->host_addr,
-					 tbd->buf_length, PCI_DMA_TODEVICE);
+			dma_unmap_single(&priv->pci_dev->dev, tbd->host_addr,
+					 tbd->buf_length, DMA_TO_DEVICE);
 		}
 
 		libipw_txb_free(packet->info.d_struct.txb);
@@ -3164,15 +3163,13 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
 			tbd->buf_length = packet->info.d_struct.txb->
 			    fragments[i]->len - LIBIPW_3ADDR_LEN;
 
-			tbd->host_addr = pci_map_single(priv->pci_dev,
+			tbd->host_addr = dma_map_single(&priv->pci_dev->dev,
 							packet->info.d_struct.
-							txb->fragments[i]->
-							data +
+							txb->fragments[i]->data +
 							LIBIPW_3ADDR_LEN,
 							tbd->buf_length,
-							PCI_DMA_TODEVICE);
-			if (pci_dma_mapping_error(priv->pci_dev,
-						  tbd->host_addr)) {
+							DMA_TO_DEVICE);
+			if (dma_mapping_error(&priv->pci_dev->dev, tbd->host_addr)) {
 				IPW_DEBUG_TX("dma mapping error\n");
 				break;
 			}
@@ -3181,10 +3178,10 @@ static void ipw2100_tx_send_data(struct ipw2100_priv *priv)
 				     txq->next, tbd->host_addr,
 				     tbd->buf_length);
 
-			pci_dma_sync_single_for_device(priv->pci_dev,
-						       tbd->host_addr,
-						       tbd->buf_length,
-						       PCI_DMA_TODEVICE);
+			dma_sync_single_for_device(&priv->pci_dev->dev,
+						   tbd->host_addr,
+						   tbd->buf_length,
+						   DMA_TO_DEVICE);
 
 			txq->next++;
 			txq->next %= txq->entries;
@@ -3439,9 +3436,9 @@ static int ipw2100_msg_allocate(struct ipw2100_priv *priv)
 		return -ENOMEM;
 
 	for (i = 0; i < IPW_COMMAND_POOL_SIZE; i++) {
-		v = pci_zalloc_consistent(priv->pci_dev,
-					  sizeof(struct ipw2100_cmd_header),
-					  &p);
+		v = dma_alloc_coherent(&priv->pci_dev->dev,
+				       sizeof(struct ipw2100_cmd_header), &p,
+				       GFP_KERNEL);
 		if (!v) {
 			printk(KERN_ERR DRV_NAME ": "
 			       "%s: PCI alloc failed for msg "
@@ -3460,11 +3457,10 @@ static int ipw2100_msg_allocate(struct ipw2100_priv *priv)
 		return 0;
 
 	for (j = 0; j < i; j++) {
-		pci_free_consistent(priv->pci_dev,
-				    sizeof(struct ipw2100_cmd_header),
-				    priv->msg_buffers[j].info.c_struct.cmd,
-				    priv->msg_buffers[j].info.c_struct.
-				    cmd_phys);
+		dma_free_coherent(&priv->pci_dev->dev,
+				  sizeof(struct ipw2100_cmd_header),
+				  priv->msg_buffers[j].info.c_struct.cmd,
+				  priv->msg_buffers[j].info.c_struct.cmd_phys);
 	}
 
 	kfree(priv->msg_buffers);
@@ -3495,11 +3491,10 @@ static void ipw2100_msg_free(struct ipw2100_priv *priv)
 		return;
 
 	for (i = 0; i < IPW_COMMAND_POOL_SIZE; i++) {
-		pci_free_consistent(priv->pci_dev,
-				    sizeof(struct ipw2100_cmd_header),
-				    priv->msg_buffers[i].info.c_struct.cmd,
-				    priv->msg_buffers[i].info.c_struct.
-				    cmd_phys);
+		dma_free_coherent(&priv->pci_dev->dev,
+				  sizeof(struct ipw2100_cmd_header),
+				  priv->msg_buffers[i].info.c_struct.cmd,
+				  priv->msg_buffers[i].info.c_struct.cmd_phys);
 	}
 
 	kfree(priv->msg_buffers);
@@ -4322,7 +4317,8 @@ static int status_queue_allocate(struct ipw2100_priv *priv, int entries)
 	IPW_DEBUG_INFO("enter\n");
 
 	q->size = entries * sizeof(struct ipw2100_status);
-	q->drv = pci_zalloc_consistent(priv->pci_dev, q->size, &q->nic);
+	q->drv = dma_alloc_coherent(&priv->pci_dev->dev, q->size, &q->nic,
+				    GFP_KERNEL);
 	if (!q->drv) {
 		IPW_DEBUG_WARNING("Can not allocate status queue.\n");
 		return -ENOMEM;
@@ -4338,9 +4334,10 @@ static void status_queue_free(struct ipw2100_priv *priv)
 	IPW_DEBUG_INFO("enter\n");
 
 	if (priv->status_queue.drv) {
-		pci_free_consistent(priv->pci_dev, priv->status_queue.size,
-				    priv->status_queue.drv,
-				    priv->status_queue.nic);
+		dma_free_coherent(&priv->pci_dev->dev,
+				  priv->status_queue.size,
+				  priv->status_queue.drv,
+				  priv->status_queue.nic);
 		priv->status_queue.drv = NULL;
 	}
 
@@ -4356,7 +4353,8 @@ static int bd_queue_allocate(struct ipw2100_priv *priv,
 
 	q->entries = entries;
 	q->size = entries * sizeof(struct ipw2100_bd);
-	q->drv = pci_zalloc_consistent(priv->pci_dev, q->size, &q->nic);
+	q->drv = dma_alloc_coherent(&priv->pci_dev->dev, q->size, &q->nic,
+				    GFP_KERNEL);
 	if (!q->drv) {
 		IPW_DEBUG_INFO
 		    ("can't allocate shared memory for buffer descriptors\n");
@@ -4376,7 +4374,8 @@ static void bd_queue_free(struct ipw2100_priv *priv, struct ipw2100_bd_queue *q)
 		return;
 
 	if (q->drv) {
-		pci_free_consistent(priv->pci_dev, q->size, q->drv, q->nic);
+		dma_free_coherent(&priv->pci_dev->dev, q->size, q->drv,
+				  q->nic);
 		q->drv = NULL;
 	}
 
@@ -4436,9 +4435,9 @@ static int ipw2100_tx_allocate(struct ipw2100_priv *priv)
 	}
 
 	for (i = 0; i < TX_PENDED_QUEUE_LENGTH; i++) {
-		v = pci_alloc_consistent(priv->pci_dev,
-					 sizeof(struct ipw2100_data_header),
-					 &p);
+		v = dma_alloc_coherent(&priv->pci_dev->dev,
+				       sizeof(struct ipw2100_data_header), &p,
+				       GFP_KERNEL);
 		if (!v) {
 			printk(KERN_ERR DRV_NAME
 			       ": %s: PCI alloc failed for tx " "buffers.\n",
@@ -4458,11 +4457,10 @@ static int ipw2100_tx_allocate(struct ipw2100_priv *priv)
 		return 0;
 
 	for (j = 0; j < i; j++) {
-		pci_free_consistent(priv->pci_dev,
-				    sizeof(struct ipw2100_data_header),
-				    priv->tx_buffers[j].info.d_struct.data,
-				    priv->tx_buffers[j].info.d_struct.
-				    data_phys);
+		dma_free_coherent(&priv->pci_dev->dev,
+				  sizeof(struct ipw2100_data_header),
+				  priv->tx_buffers[j].info.d_struct.data,
+				  priv->tx_buffers[j].info.d_struct.data_phys);
 	}
 
 	kfree(priv->tx_buffers);
@@ -4539,12 +4537,10 @@ static void ipw2100_tx_free(struct ipw2100_priv *priv)
 			priv->tx_buffers[i].info.d_struct.txb = NULL;
 		}
 		if (priv->tx_buffers[i].info.d_struct.data)
-			pci_free_consistent(priv->pci_dev,
-					    sizeof(struct ipw2100_data_header),
-					    priv->tx_buffers[i].info.d_struct.
-					    data,
-					    priv->tx_buffers[i].info.d_struct.
-					    data_phys);
+			dma_free_coherent(&priv->pci_dev->dev,
+					  sizeof(struct ipw2100_data_header),
+					  priv->tx_buffers[i].info.d_struct.data,
+					  priv->tx_buffers[i].info.d_struct.data_phys);
 	}
 
 	kfree(priv->tx_buffers);
@@ -4607,9 +4603,10 @@ static int ipw2100_rx_allocate(struct ipw2100_priv *priv)
 		return 0;
 
 	for (j = 0; j < i; j++) {
-		pci_unmap_single(priv->pci_dev, priv->rx_buffers[j].dma_addr,
+		dma_unmap_single(&priv->pci_dev->dev,
+				 priv->rx_buffers[j].dma_addr,
 				 sizeof(struct ipw2100_rx_packet),
-				 PCI_DMA_FROMDEVICE);
+				 DMA_FROM_DEVICE);
 		dev_kfree_skb(priv->rx_buffers[j].skb);
 	}
 
@@ -4661,10 +4658,10 @@ static void ipw2100_rx_free(struct ipw2100_priv *priv)
 
 	for (i = 0; i < RX_QUEUE_LENGTH; i++) {
 		if (priv->rx_buffers[i].rxp) {
-			pci_unmap_single(priv->pci_dev,
+			dma_unmap_single(&priv->pci_dev->dev,
 					 priv->rx_buffers[i].dma_addr,
 					 sizeof(struct ipw2100_rx),
-					 PCI_DMA_FROMDEVICE);
+					 DMA_FROM_DEVICE);
 			dev_kfree_skb(priv->rx_buffers[i].skb);
 		}
 	}
@@ -6196,7 +6193,7 @@ static int ipw2100_pci_init_one(struct pci_dev *pci_dev,
 	pci_set_master(pci_dev);
 	pci_set_drvdata(pci_dev, priv);
 
-	err = pci_set_dma_mask(pci_dev, DMA_BIT_MASK(32));
+	err = dma_set_mask(&pci_dev->dev, DMA_BIT_MASK(32));
 	if (err) {
 		printk(KERN_WARNING DRV_NAME
 		       "Error calling pci_set_dma_mask.\n");
diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2200.c b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
index ac5f797fb1ad..5ce1a4d8fcee 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -3442,9 +3442,10 @@ static void ipw_rx_queue_reset(struct ipw_priv *priv,
 		/* In the reset function, these buffers may have been allocated
 		 * to an SKB, so we need to unmap and free potential storage */
 		if (rxq->pool[i].skb != NULL) {
-			pci_unmap_single(priv->pci_dev, rxq->pool[i].dma_addr,
-					 IPW_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
-			dev_kfree_skb(rxq->pool[i].skb);
+			dma_unmap_single(&priv->pci_dev->dev,
+					 rxq->pool[i].dma_addr,
+					 IPW_RX_BUF_SIZE, DMA_FROM_DEVICE);
+			dev_kfree_skb_irq(rxq->pool[i].skb);
 			rxq->pool[i].skb = NULL;
 		}
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
@@ -3776,7 +3777,8 @@ static int ipw_queue_tx_init(struct ipw_priv *priv,
 	}
 
 	q->bd =
-	    pci_alloc_consistent(dev, sizeof(q->bd[0]) * count, &q->q.dma_addr);
+	    dma_alloc_coherent(&dev->dev, sizeof(q->bd[0]) * count,
+			       &q->q.dma_addr, GFP_KERNEL);
 	if (!q->bd) {
 		IPW_ERROR("pci_alloc_consistent(%zd) failed\n",
 			  sizeof(q->bd[0]) * count);
@@ -3818,9 +3820,10 @@ static void ipw_queue_tx_free_tfd(struct ipw_priv *priv,
 
 	/* unmap chunks if any */
 	for (i = 0; i < le32_to_cpu(bd->u.data.num_chunks); i++) {
-		pci_unmap_single(dev, le32_to_cpu(bd->u.data.chunk_ptr[i]),
+		dma_unmap_single(&dev->dev,
+				 le32_to_cpu(bd->u.data.chunk_ptr[i]),
 				 le16_to_cpu(bd->u.data.chunk_len[i]),
-				 PCI_DMA_TODEVICE);
+				 DMA_TO_DEVICE);
 		if (txq->txb[txq->q.last_used]) {
 			libipw_txb_free(txq->txb[txq->q.last_used]);
 			txq->txb[txq->q.last_used] = NULL;
@@ -3852,8 +3855,8 @@ static void ipw_queue_tx_free(struct ipw_priv *priv, struct clx2_tx_queue *txq)
 	}
 
 	/* free buffers belonging to queue itself */
-	pci_free_consistent(dev, sizeof(txq->bd[0]) * q->n_bd, txq->bd,
-			    q->dma_addr);
+	dma_free_coherent(&dev->dev, sizeof(txq->bd[0]) * q->n_bd, txq->bd,
+			  q->dma_addr);
 	kfree(txq->txb);
 
 	/* 0 fill whole structure */
@@ -5198,8 +5201,8 @@ static void ipw_rx_queue_replenish(void *data)
 		list_del(element);
 
 		rxb->dma_addr =
-		    pci_map_single(priv->pci_dev, rxb->skb->data,
-				   IPW_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+		    dma_map_single(&priv->pci_dev->dev, rxb->skb->data,
+				   IPW_RX_BUF_SIZE, DMA_FROM_DEVICE);
 
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
@@ -5232,8 +5235,9 @@ static void ipw_rx_queue_free(struct ipw_priv *priv, struct ipw_rx_queue *rxq)
 
 	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
 		if (rxq->pool[i].skb != NULL) {
-			pci_unmap_single(priv->pci_dev, rxq->pool[i].dma_addr,
-					 IPW_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+			dma_unmap_single(&priv->pci_dev->dev,
+					 rxq->pool[i].dma_addr,
+					 IPW_RX_BUF_SIZE, DMA_FROM_DEVICE);
 			dev_kfree_skb(rxq->pool[i].skb);
 		}
 	}
@@ -8271,9 +8275,8 @@ static void ipw_rx(struct ipw_priv *priv)
 		}
 		priv->rxq->queue[i] = NULL;
 
-		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->dma_addr,
-					    IPW_RX_BUF_SIZE,
-					    PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_cpu(&priv->pci_dev->dev, rxb->dma_addr,
+					IPW_RX_BUF_SIZE, DMA_FROM_DEVICE);
 
 		pkt = (struct ipw_rx_packet *)rxb->skb->data;
 		IPW_DEBUG_RX("Packet: type=%02X seq=%02X bits=%02X\n",
@@ -8425,8 +8428,8 @@ static void ipw_rx(struct ipw_priv *priv)
 			rxb->skb = NULL;
 		}
 
-		pci_unmap_single(priv->pci_dev, rxb->dma_addr,
-				 IPW_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
+		dma_unmap_single(&priv->pci_dev->dev, rxb->dma_addr,
+				 IPW_RX_BUF_SIZE, DMA_FROM_DEVICE);
 		list_add_tail(&rxb->list, &priv->rxq->rx_used);
 
 		i = (i + 1) % RX_QUEUE_SIZE;
@@ -10225,11 +10228,10 @@ static int ipw_tx_skb(struct ipw_priv *priv, struct libipw_txb *txb,
 			   txb->fragments[i]->len - hdr_len);
 
 		tfd->u.data.chunk_ptr[i] =
-		    cpu_to_le32(pci_map_single
-				(priv->pci_dev,
-				 txb->fragments[i]->data + hdr_len,
-				 txb->fragments[i]->len - hdr_len,
-				 PCI_DMA_TODEVICE));
+		    cpu_to_le32(dma_map_single(&priv->pci_dev->dev,
+					       txb->fragments[i]->data + hdr_len,
+					       txb->fragments[i]->len - hdr_len,
+					       DMA_TO_DEVICE));
 		tfd->u.data.chunk_len[i] =
 		    cpu_to_le16(txb->fragments[i]->len - hdr_len);
 	}
@@ -10259,10 +10261,10 @@ static int ipw_tx_skb(struct ipw_priv *priv, struct libipw_txb *txb,
 			dev_kfree_skb_any(txb->fragments[i]);
 			txb->fragments[i] = skb;
 			tfd->u.data.chunk_ptr[i] =
-			    cpu_to_le32(pci_map_single
-					(priv->pci_dev, skb->data,
-					 remaining_bytes,
-					 PCI_DMA_TODEVICE));
+			    cpu_to_le32(dma_map_single(&priv->pci_dev->dev,
+						       skb->data,
+						       remaining_bytes,
+						       DMA_TO_DEVICE));
 
 			le32_add_cpu(&tfd->u.data.num_chunks, 1);
 		}
@@ -11412,9 +11414,14 @@ static int ipw_wdev_init(struct net_device *dev)
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
 
@@ -11632,9 +11639,9 @@ static int ipw_pci_probe(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
-	err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (!err)
-		err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
+		err = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(32));
 	if (err) {
 		printk(KERN_WARNING DRV_NAME ": No suitable DMA available.\n");
 		goto out_pci_disable_device;
diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index e2e9c3e8fff5..a1bd61d5e024 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -2302,9 +2302,7 @@ __il3945_down(struct il_priv *il)
 	il3945_hw_txq_ctx_free(il);
 exit:
 	memset(&il->card_alive, 0, sizeof(struct il_alive_resp));
-
-	if (il->beacon_skb)
-		dev_kfree_skb(il->beacon_skb);
+	dev_kfree_skb(il->beacon_skb);
 	il->beacon_skb = NULL;
 
 	/* clear out any free frames */
@@ -3384,10 +3382,12 @@ static DEVICE_ATTR(dump_errors, 0200, NULL, il3945_dump_error_log);
  *
  *****************************************************************************/
 
-static void
+static int
 il3945_setup_deferred_work(struct il_priv *il)
 {
 	il->workqueue = create_singlethread_workqueue(DRV_NAME);
+	if (!il->workqueue)
+		return -ENOMEM;
 
 	init_waitqueue_head(&il->wait_command_queue);
 
@@ -3406,6 +3406,8 @@ il3945_setup_deferred_work(struct il_priv *il)
 	tasklet_init(&il->irq_tasklet,
 		     il3945_irq_tasklet,
 		     (unsigned long)il);
+
+	return 0;
 }
 
 static void
@@ -3727,7 +3729,10 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	il_set_rxon_channel(il, &il->bands[NL80211_BAND_2GHZ].channels[5]);
-	il3945_setup_deferred_work(il);
+	err = il3945_setup_deferred_work(il);
+	if (err)
+		goto out_remove_sysfs;
+
 	il3945_setup_handlers(il);
 	il_power_initialize(il);
 
@@ -3739,7 +3744,7 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = il3945_setup_mac(il);
 	if (err)
-		goto out_remove_sysfs;
+		goto out_destroy_workqueue;
 
 	il_dbgfs_register(il, DRV_NAME);
 
@@ -3748,9 +3753,10 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
-out_remove_sysfs:
+out_destroy_workqueue:
 	destroy_workqueue(il->workqueue);
 	il->workqueue = NULL;
+out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &il3945_attribute_group);
 out_release_irq:
 	free_irq(il->pci_dev->irq, il);
@@ -3847,9 +3853,7 @@ il3945_pci_remove(struct pci_dev *pdev)
 	il_free_channel_map(il);
 	il_free_geos(il);
 	kfree(il->scan_cmd);
-	if (il->beacon_skb)
-		dev_kfree_skb(il->beacon_skb);
-
+	dev_kfree_skb(il->beacon_skb);
 	ieee80211_free_hw(il->hw);
 }
 
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 5fe17039a337..feeb57cadc1c 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -6217,10 +6217,12 @@ il4965_bg_txpower_work(struct work_struct *work)
 	mutex_unlock(&il->mutex);
 }
 
-static void
+static int
 il4965_setup_deferred_work(struct il_priv *il)
 {
 	il->workqueue = create_singlethread_workqueue(DRV_NAME);
+	if (!il->workqueue)
+		return -ENOMEM;
 
 	init_waitqueue_head(&il->wait_command_queue);
 
@@ -6241,6 +6243,8 @@ il4965_setup_deferred_work(struct il_priv *il)
 	tasklet_init(&il->irq_tasklet,
 		     il4965_irq_tasklet,
 		     (unsigned long)il);
+
+	return 0;
 }
 
 static void
@@ -6630,7 +6634,10 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_disable_msi;
 	}
 
-	il4965_setup_deferred_work(il);
+	err = il4965_setup_deferred_work(il);
+	if (err)
+		goto out_free_irq;
+
 	il4965_setup_handlers(il);
 
 	/*********************************************
@@ -6668,6 +6675,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_destroy_workqueue:
 	destroy_workqueue(il->workqueue);
 	il->workqueue = NULL;
+out_free_irq:
 	free_irq(il->pci_dev->irq, il);
 out_disable_msi:
 	pci_disable_msi(il->pci_dev);
diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 1107b96a8a88..7cfd80d40a65 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -5182,8 +5182,7 @@ il_mac_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	memset(&il->current_ht_config, 0, sizeof(struct il_ht_config));
 
 	/* new association get rid of ibss beacon skb */
-	if (il->beacon_skb)
-		dev_kfree_skb(il->beacon_skb);
+	dev_consume_skb_irq(il->beacon_skb);
 	il->beacon_skb = NULL;
 	il->timestamp = 0;
 
@@ -5302,10 +5301,7 @@ il_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 	spin_lock_irqsave(&il->lock, flags);
-
-	if (il->beacon_skb)
-		dev_kfree_skb(il->beacon_skb);
-
+	dev_consume_skb_irq(il->beacon_skb);
 	il->beacon_skb = skb;
 
 	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
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
diff --git a/drivers/net/wireless/marvell/libertas/if_usb.c b/drivers/net/wireless/marvell/libertas/if_usb.c
index 32fdc4150b60..2240b4db8c03 100644
--- a/drivers/net/wireless/marvell/libertas/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas/if_usb.c
@@ -637,7 +637,7 @@ static inline void process_cmdrequest(int recvlength, uint8_t *recvbuff,
 	priv->resp_len[i] = (recvlength - MESSAGE_HEADER_LEN);
 	memcpy(priv->resp_buf[i], recvbuff + MESSAGE_HEADER_LEN,
 		priv->resp_len[i]);
-	kfree_skb(skb);
+	dev_kfree_skb_irq(skb);
 	lbs_notify_command_response(priv, i);
 
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
diff --git a/drivers/net/wireless/marvell/libertas/main.c b/drivers/net/wireless/marvell/libertas/main.c
index 2233b59cdf44..ff0b3a0e9dcd 100644
--- a/drivers/net/wireless/marvell/libertas/main.c
+++ b/drivers/net/wireless/marvell/libertas/main.c
@@ -217,7 +217,7 @@ int lbs_stop_iface(struct lbs_private *priv)
 
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	priv->iface_running = false;
-	kfree_skb(priv->currenttxskb);
+	dev_kfree_skb_irq(priv->currenttxskb);
 	priv->currenttxskb = NULL;
 	priv->tx_pending_len = 0;
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
@@ -870,6 +870,7 @@ static int lbs_init_adapter(struct lbs_private *priv)
 	ret = kfifo_alloc(&priv->event_fifo, sizeof(u32) * 16, GFP_KERNEL);
 	if (ret) {
 		pr_err("Out of memory allocating event FIFO buffer\n");
+		lbs_free_cmd_buffer(priv);
 		goto out;
 	}
 
diff --git a/drivers/net/wireless/marvell/libertas_tf/if_usb.c b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
index b30bcb28503a..f47db95299f3 100644
--- a/drivers/net/wireless/marvell/libertas_tf/if_usb.c
+++ b/drivers/net/wireless/marvell/libertas_tf/if_usb.c
@@ -613,7 +613,7 @@ static inline void process_cmdrequest(int recvlength, uint8_t *recvbuff,
 	spin_lock_irqsave(&priv->driver_lock, flags);
 	memcpy(priv->cmd_resp_buff, recvbuff + MESSAGE_HEADER_LEN,
 	       recvlength - MESSAGE_HEADER_LEN);
-	kfree_skb(skb);
+	dev_kfree_skb_irq(skb);
 	lbtf_cmd_response_rx(priv);
 	spin_unlock_irqrestore(&priv->driver_lock, flags);
 }
diff --git a/drivers/net/wireless/marvell/mwifiex/11n.c b/drivers/net/wireless/marvell/mwifiex/11n.c
index acbef9f1a83b..b397a7e85e6b 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n.c
@@ -890,7 +890,7 @@ mwifiex_send_delba_txbastream_tbl(struct mwifiex_private *priv, u8 tid)
  */
 void mwifiex_update_ampdu_txwinsize(struct mwifiex_adapter *adapter)
 {
-	u8 i;
+	u8 i, j;
 	u32 tx_win_size;
 	struct mwifiex_private *priv;
 
@@ -921,8 +921,8 @@ void mwifiex_update_ampdu_txwinsize(struct mwifiex_adapter *adapter)
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
diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index d3efcbd48ee1..50a92aaa221f 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -411,6 +411,7 @@ mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
 	bool more;
 
 	spin_lock_bh(&q->lock);
+
 	do {
 		buf = mt76_dma_dequeue(dev, q, true, NULL, NULL, &more);
 		if (!buf)
@@ -418,6 +419,12 @@ mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
 
 		skb_free_frag(buf);
 	} while (1);
+
+	if (q->rx_head) {
+		dev_kfree_skb(q->rx_head);
+		q->rx_head = NULL;
+	}
+
 	spin_unlock_bh(&q->lock);
 
 	if (!q->rx_page.va)
@@ -440,12 +447,6 @@ mt76_dma_rx_reset(struct mt76_dev *dev, enum mt76_rxq_id qid)
 	mt76_dma_rx_cleanup(dev, q);
 	mt76_dma_sync_idx(dev, q);
 	mt76_dma_rx_fill(dev, q);
-
-	if (!q->rx_head)
-		return;
-
-	dev_kfree_skb(q->rx_head);
-	q->rx_head = NULL;
 }
 
 static void
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
index 92305bd31aa1..4209209ac940 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_beacon.c
@@ -77,10 +77,7 @@ int mt76x02_mac_set_beacon(struct mt76x02_dev *dev, u8 vif_idx,
 	for (i = 0; i < ARRAY_SIZE(dev->beacons); i++) {
 		if (vif_idx == i) {
 			force_update = !!dev->beacons[i] ^ !!skb;
-
-			if (dev->beacons[i])
-				dev_kfree_skb(dev->beacons[i]);
-
+			dev_kfree_skb(dev->beacons[i]);
 			dev->beacons[i] = skb;
 			__mt76x02_mac_set_beacon(dev, bcn_idx, skb);
 		} else if (force_update && dev->beacons[i]) {
diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index 6f2172be7b66..072888072b0d 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -118,7 +118,8 @@ static u16 mt7601u_rx_next_seg_len(u8 *data, u32 data_len)
 	if (data_len < min_seg_len ||
 	    WARN_ON_ONCE(!dma_len) ||
 	    WARN_ON_ONCE(dma_len + MT_DMA_HDRS > data_len) ||
-	    WARN_ON_ONCE(dma_len & 0x3))
+	    WARN_ON_ONCE(dma_len & 0x3) ||
+	    WARN_ON_ONCE(dma_len < min_seg_len))
 		return 0;
 
 	return MT_DMA_HDRS + dma_len;
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index 02ca80501c3a..edd2960c109a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1671,6 +1671,11 @@ static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
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
index 0bc747489c55..bdccc84278d8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5095,7 +5095,7 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 		pending = priv->rx_urb_pending_count;
 	} else {
 		skb = (struct sk_buff *)rx_urb->urb.context;
-		dev_kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 		usb_free_urb(&rx_urb->urb);
 	}
 
@@ -5494,7 +5494,6 @@ static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct device *dev = &priv->udev->dev;
-	u16 val16;
 	int ret = 0, channel;
 	bool ht40;
 
@@ -5504,14 +5503,6 @@ static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index 979e434a4e73..8647db044366 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -1587,7 +1587,7 @@ static void _rtl8821ae_phy_txpower_by_rate_configuration(struct ieee80211_hw *hw
 }
 
 /* string is in decimal */
-static bool _rtl8812ae_get_integer_from_string(char *str, u8 *pint)
+static bool _rtl8812ae_get_integer_from_string(const char *str, u8 *pint)
 {
 	u16 i = 0;
 	*pint = 0;
@@ -1605,18 +1605,6 @@ static bool _rtl8812ae_get_integer_from_string(char *str, u8 *pint)
 	return true;
 }
 
-static bool _rtl8812ae_eq_n_byte(u8 *str1, u8 *str2, u32 num)
-{
-	if (num == 0)
-		return false;
-	while (num > 0) {
-		num--;
-		if (str1[num] != str2[num])
-			return false;
-	}
-	return true;
-}
-
 static s8 _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(struct ieee80211_hw *hw,
 					      u8 band, u8 channel)
 {
@@ -1643,10 +1631,11 @@ static s8 _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(struct ieee80211_hw *hw,
 	return channel_index;
 }
 
-static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw, u8 *pregulation,
-				      u8 *pband, u8 *pbandwidth,
-				      u8 *prate_section, u8 *prf_path,
-				      u8 *pchannel, u8 *ppower_limit)
+static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw,
+				      const char *pregulation,
+				      const char *pband, const char *pbandwidth,
+				      const char *prate_section, const char *prf_path,
+				      const char *pchannel, const char *ppower_limit)
 {
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_phy *rtlphy = &rtlpriv->phy;
@@ -1654,8 +1643,8 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw, u8 *pregul
 	u8 channel_index;
 	s8 power_limit = 0, prev_power_limit, ret;
 
-	if (!_rtl8812ae_get_integer_from_string((char *)pchannel, &channel) ||
-	    !_rtl8812ae_get_integer_from_string((char *)ppower_limit,
+	if (!_rtl8812ae_get_integer_from_string(pchannel, &channel) ||
+	    !_rtl8812ae_get_integer_from_string(ppower_limit,
 						&power_limit)) {
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_TRACE,
 			 "Illegal index of pwr_lmt table [chnl %d][val %d]\n",
@@ -1665,42 +1654,42 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw, u8 *pregul
 	power_limit = power_limit > MAX_POWER_INDEX ?
 		      MAX_POWER_INDEX : power_limit;
 
-	if (_rtl8812ae_eq_n_byte(pregulation, (u8 *)("FCC"), 3))
+	if (strcmp(pregulation, "FCC") == 0)
 		regulation = 0;
-	else if (_rtl8812ae_eq_n_byte(pregulation, (u8 *)("MKK"), 3))
+	else if (strcmp(pregulation, "MKK") == 0)
 		regulation = 1;
-	else if (_rtl8812ae_eq_n_byte(pregulation, (u8 *)("ETSI"), 4))
+	else if (strcmp(pregulation, "ETSI") == 0)
 		regulation = 2;
-	else if (_rtl8812ae_eq_n_byte(pregulation, (u8 *)("WW13"), 4))
+	else if (strcmp(pregulation, "WW13") == 0)
 		regulation = 3;
 
-	if (_rtl8812ae_eq_n_byte(prate_section, (u8 *)("CCK"), 3))
+	if (strcmp(prate_section, "CCK") == 0)
 		rate_section = 0;
-	else if (_rtl8812ae_eq_n_byte(prate_section, (u8 *)("OFDM"), 4))
+	else if (strcmp(prate_section, "OFDM") == 0)
 		rate_section = 1;
-	else if (_rtl8812ae_eq_n_byte(prate_section, (u8 *)("HT"), 2) &&
-		 _rtl8812ae_eq_n_byte(prf_path, (u8 *)("1T"), 2))
+	else if (strcmp(prate_section, "HT") == 0 &&
+		 strcmp(prf_path, "1T") == 0)
 		rate_section = 2;
-	else if (_rtl8812ae_eq_n_byte(prate_section, (u8 *)("HT"), 2) &&
-		 _rtl8812ae_eq_n_byte(prf_path, (u8 *)("2T"), 2))
+	else if (strcmp(prate_section, "HT") == 0 &&
+		 strcmp(prf_path, "2T") == 0)
 		rate_section = 3;
-	else if (_rtl8812ae_eq_n_byte(prate_section, (u8 *)("VHT"), 3) &&
-		 _rtl8812ae_eq_n_byte(prf_path, (u8 *)("1T"), 2))
+	else if (strcmp(prate_section, "VHT") == 0 &&
+		 strcmp(prf_path, "1T") == 0)
 		rate_section = 4;
-	else if (_rtl8812ae_eq_n_byte(prate_section, (u8 *)("VHT"), 3) &&
-		 _rtl8812ae_eq_n_byte(prf_path, (u8 *)("2T"), 2))
+	else if (strcmp(prate_section, "VHT") == 0 &&
+		 strcmp(prf_path, "2T") == 0)
 		rate_section = 5;
 
-	if (_rtl8812ae_eq_n_byte(pbandwidth, (u8 *)("20M"), 3))
+	if (strcmp(pbandwidth, "20M") == 0)
 		bandwidth = 0;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, (u8 *)("40M"), 3))
+	else if (strcmp(pbandwidth, "40M") == 0)
 		bandwidth = 1;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, (u8 *)("80M"), 3))
+	else if (strcmp(pbandwidth, "80M") == 0)
 		bandwidth = 2;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, (u8 *)("160M"), 4))
+	else if (strcmp(pbandwidth, "160M") == 0)
 		bandwidth = 3;
 
-	if (_rtl8812ae_eq_n_byte(pband, (u8 *)("2.4G"), 4)) {
+	if (strcmp(pband, "2.4G") == 0) {
 		ret = _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(hw,
 							       BAND_ON_2_4G,
 							       channel);
@@ -1724,7 +1713,7 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw, u8 *pregul
 			  regulation, bandwidth, rate_section, channel_index,
 			  rtlphy->txpwr_limit_2_4g[regulation][bandwidth]
 				[rate_section][channel_index][RF90_PATH_A]);
-	} else if (_rtl8812ae_eq_n_byte(pband, (u8 *)("5G"), 2)) {
+	} else if (strcmp(pband, "5G") == 0) {
 		ret = _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(hw,
 							       BAND_ON_5G,
 							       channel);
@@ -1755,10 +1744,10 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw, u8 *pregul
 }
 
 static void _rtl8812ae_phy_config_bb_txpwr_lmt(struct ieee80211_hw *hw,
-					  u8 *regulation, u8 *band,
-					  u8 *bandwidth, u8 *rate_section,
-					  u8 *rf_path, u8 *channel,
-					  u8 *power_limit)
+					  const char *regulation, const char *band,
+					  const char *bandwidth, const char *rate_section,
+					  const char *rf_path, const char *channel,
+					  const char *power_limit)
 {
 	_rtl8812ae_phy_set_txpower_limit(hw, regulation, band, bandwidth,
 					 rate_section, rf_path, channel,
@@ -1771,7 +1760,7 @@ static void _rtl8821ae_phy_read_and_config_txpwr_lmt(struct ieee80211_hw *hw)
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u32 i = 0;
 	u32 array_len;
-	u8 **array;
+	const char **array;
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE) {
 		array_len = RTL8812AE_TXPWR_LMT_ARRAY_LEN;
@@ -1785,13 +1774,13 @@ static void _rtl8821ae_phy_read_and_config_txpwr_lmt(struct ieee80211_hw *hw)
 		 "\n");
 
 	for (i = 0; i < array_len; i += 7) {
-		u8 *regulation = array[i];
-		u8 *band = array[i+1];
-		u8 *bandwidth = array[i+2];
-		u8 *rate = array[i+3];
-		u8 *rf_path = array[i+4];
-		u8 *chnl = array[i+5];
-		u8 *val = array[i+6];
+		const char *regulation = array[i];
+		const char *band = array[i+1];
+		const char *bandwidth = array[i+2];
+		const char *rate = array[i+3];
+		const char *rf_path = array[i+4];
+		const char *chnl = array[i+5];
+		const char *val = array[i+6];
 
 		_rtl8812ae_phy_config_bb_txpwr_lmt(hw, regulation, band,
 						   bandwidth, rate, rf_path,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
index ed72a2aeb6c8..fcaaf664cbec 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.c
@@ -2894,7 +2894,7 @@ u32 RTL8821AE_AGC_TAB_1TARRAYLEN = ARRAY_SIZE(RTL8821AE_AGC_TAB_ARRAY);
 *                           TXPWR_LMT.TXT
 ******************************************************************************/
 
-u8 *RTL8812AE_TXPWR_LMT[] = {
+const char *RTL8812AE_TXPWR_LMT[] = {
 	"FCC", "2.4G", "20M", "CCK", "1T", "01", "36",
 	"ETSI", "2.4G", "20M", "CCK", "1T", "01", "32",
 	"MKK", "2.4G", "20M", "CCK", "1T", "01", "32",
@@ -3463,7 +3463,7 @@ u8 *RTL8812AE_TXPWR_LMT[] = {
 
 u32 RTL8812AE_TXPWR_LMT_ARRAY_LEN = ARRAY_SIZE(RTL8812AE_TXPWR_LMT);
 
-u8 *RTL8821AE_TXPWR_LMT[] = {
+const char *RTL8821AE_TXPWR_LMT[] = {
 	"FCC", "2.4G", "20M", "CCK", "1T", "01", "32",
 	"ETSI", "2.4G", "20M", "CCK", "1T", "01", "32",
 	"MKK", "2.4G", "20M", "CCK", "1T", "01", "32",
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h
index 540159c25078..76c62b7c0fb2 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/table.h
@@ -28,7 +28,7 @@ extern u32 RTL8821AE_AGC_TAB_ARRAY[];
 extern u32 RTL8812AE_AGC_TAB_1TARRAYLEN;
 extern u32 RTL8812AE_AGC_TAB_ARRAY[];
 extern u32 RTL8812AE_TXPWR_LMT_ARRAY_LEN;
-extern u8 *RTL8812AE_TXPWR_LMT[];
+extern const char *RTL8812AE_TXPWR_LMT[];
 extern u32 RTL8821AE_TXPWR_LMT_ARRAY_LEN;
-extern u8 *RTL8821AE_TXPWR_LMT[];
+extern const char *RTL8821AE_TXPWR_LMT[];
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_91x_coex.c b/drivers/net/wireless/rsi/rsi_91x_coex.c
index c8ba148f8c6c..acf4d8cb4b47 100644
--- a/drivers/net/wireless/rsi/rsi_91x_coex.c
+++ b/drivers/net/wireless/rsi/rsi_91x_coex.c
@@ -160,6 +160,7 @@ int rsi_coex_attach(struct rsi_common *common)
 			       rsi_coex_scheduler_thread,
 			       "Coex-Tx-Thread")) {
 		rsi_dbg(ERR_ZONE, "%s: Unable to init tx thrd\n", __func__);
+		kfree(coex_cb);
 		return -EINVAL;
 	}
 	return 0;
diff --git a/drivers/net/wireless/st/cw1200/scan.c b/drivers/net/wireless/st/cw1200/scan.c
index c46b044b7f7b..988581cc134b 100644
--- a/drivers/net/wireless/st/cw1200/scan.c
+++ b/drivers/net/wireless/st/cw1200/scan.c
@@ -120,8 +120,7 @@ int cw1200_hw_scan(struct ieee80211_hw *hw,
 		++priv->scan.n_ssids;
 	}
 
-	if (frame.skb)
-		dev_kfree_skb(frame.skb);
+	dev_kfree_skb(frame.skb);
 	mutex_unlock(&priv->conf_mutex);
 	queue_work(priv->workqueue, &priv->scan.work);
 	return 0;
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 122d36439319..8638c7c72bc3 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1328,7 +1328,7 @@ static netdev_tx_t wl3501_hard_start_xmit(struct sk_buff *skb,
 	} else {
 		++dev->stats.tx_packets;
 		dev->stats.tx_bytes += skb->len;
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 
 		if (this->tx_buffer_cnt < 2)
 			netif_stop_queue(dev);
diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 0cd70cd680dc..17793f6888e1 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -665,6 +665,12 @@ int st_nci_se_io(struct nci_dev *ndev, u32 se_idx,
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
index d41636504246..6a1d3b2752fb 100644
--- a/drivers/nfc/st21nfca/se.c
+++ b/drivers/nfc/st21nfca/se.c
@@ -236,6 +236,12 @@ int st21nfca_hci_se_io(struct nfc_hci_dev *hdev, u32 se_idx,
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
diff --git a/drivers/opp/debugfs.c b/drivers/opp/debugfs.c
index 609665e339b6..c7647410316e 100644
--- a/drivers/opp/debugfs.c
+++ b/drivers/opp/debugfs.c
@@ -162,7 +162,7 @@ static void opp_migrate_dentry(struct opp_device *opp_dev,
 
 	dentry = debugfs_rename(rootdir, opp_dev->dentry, rootdir,
 				opp_table->dentry_name);
-	if (!dentry) {
+	if (IS_ERR(dentry)) {
 		dev_err(dev, "%s: Failed to rename link from: %s to %s\n",
 			__func__, dev_name(opp_dev->dev), dev_name(dev));
 		return;
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b7ca261f5e75..365b9ed6d815 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4743,7 +4743,7 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 	if (pci_dev_is_disconnected(dev))
 		return;
 
-	if (!pci_is_bridge(dev) || !dev->bridge_d3)
+	if (!pci_is_bridge(dev))
 		return;
 
 	down_read(&pci_bus_sem);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 572c2f0a2f0c..2db1e2bee215 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -346,53 +346,36 @@ struct pci_sriov {
  * @dev - pci device to set new error_state
  * @new - the state we want dev to be in
  *
- * Must be called with device_lock held.
+ * If the device is experiencing perm_failure, it has to remain in that state.
+ * Any other transition is allowed.
  *
  * Returns true if state has been changed to the requested state.
  */
 static inline bool pci_dev_set_io_state(struct pci_dev *dev,
 					pci_channel_state_t new)
 {
-	bool changed = false;
+	pci_channel_state_t old;
 
-	device_lock_assert(&dev->dev);
 	switch (new) {
 	case pci_channel_io_perm_failure:
-		switch (dev->error_state) {
-		case pci_channel_io_frozen:
-		case pci_channel_io_normal:
-		case pci_channel_io_perm_failure:
-			changed = true;
-			break;
-		}
-		break;
+		xchg(&dev->error_state, pci_channel_io_perm_failure);
+		return true;
 	case pci_channel_io_frozen:
-		switch (dev->error_state) {
-		case pci_channel_io_frozen:
-		case pci_channel_io_normal:
-			changed = true;
-			break;
-		}
-		break;
+		old = cmpxchg(&dev->error_state, pci_channel_io_normal,
+			      pci_channel_io_frozen);
+		return old != pci_channel_io_perm_failure;
 	case pci_channel_io_normal:
-		switch (dev->error_state) {
-		case pci_channel_io_frozen:
-		case pci_channel_io_normal:
-			changed = true;
-			break;
-		}
-		break;
+		old = cmpxchg(&dev->error_state, pci_channel_io_frozen,
+			      pci_channel_io_normal);
+		return old != pci_channel_io_perm_failure;
+	default:
+		return false;
 	}
-	if (changed)
-		dev->error_state = new;
-	return changed;
 }
 
 static inline int pci_dev_set_disconnected(struct pci_dev *dev, void *unused)
 {
-	device_lock(&dev->dev);
 	pci_dev_set_io_state(dev, pci_channel_io_perm_failure);
-	device_unlock(&dev->dev);
 
 	return 0;
 }
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 8b98b7f3eb24..449d4ed611a6 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4843,6 +4843,26 @@ static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
 		PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
 }
 
+/*
+ * Wangxun 10G/1G NICs have no ACS capability, and on multi-function
+ * devices, peer-to-peer transactions are not be used between the functions.
+ * So add an ACS quirk for below devices to isolate functions.
+ * SFxxx 1G NICs(em).
+ * RP1000/RP2000 10G NICs(sp).
+ */
+static int  pci_quirk_wangxun_nic_acs(struct pci_dev *dev, u16 acs_flags)
+{
+	switch (dev->device) {
+	case 0x0100 ... 0x010F:
+	case 0x1001:
+	case 0x2001:
+		return pci_acs_ctrl_enabled(acs_flags,
+			PCI_ACS_SV | PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_UF);
+	}
+
+	return false;
+}
+
 static const struct pci_dev_acs_enabled {
 	u16 vendor;
 	u16 device;
@@ -4988,6 +5008,8 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_NXP, 0x8d9b, pci_quirk_nxp_rp_acs },
 	/* Zhaoxin Root/Downstream Ports */
 	{ PCI_VENDOR_ID_ZHAOXIN, PCI_ANY_ID, pci_quirk_zhaoxin_pcie_ports_acs },
+	/* Wangxun nics */
+	{ PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID, pci_quirk_wangxun_nic_acs },
 	{ 0 }
 };
 
@@ -5338,6 +5360,7 @@ static void quirk_no_flr(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1487, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x148c, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x7901, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
 
diff --git a/drivers/phy/rockchip/phy-rockchip-typec.c b/drivers/phy/rockchip/phy-rockchip-typec.c
index 24563160197f..ba805f1d4f6a 100644
--- a/drivers/phy/rockchip/phy-rockchip-typec.c
+++ b/drivers/phy/rockchip/phy-rockchip-typec.c
@@ -808,9 +808,8 @@ static int tcphy_get_mode(struct rockchip_typec_phy *tcphy)
 	struct extcon_dev *edev = tcphy->extcon;
 	union extcon_property_value property;
 	unsigned int id;
-	bool ufp, dp;
 	u8 mode;
-	int ret;
+	int ret, ufp, dp;
 
 	if (!edev)
 		return MODE_DFP_USB;
diff --git a/drivers/pinctrl/pinctrl-at91-pio4.c b/drivers/pinctrl/pinctrl-at91-pio4.c
index d6de4d360cd4..4ee3fcc6c91f 100644
--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -1011,8 +1011,8 @@ static int atmel_pinctrl_probe(struct platform_device *pdev)
 
 		pin_desc[i].number = i;
 		/* Pin naming convention: P(bank_name)(bank_pin_number). */
-		pin_desc[i].name = kasprintf(GFP_KERNEL, "P%c%d",
-					     bank + 'A', line);
+		pin_desc[i].name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "P%c%d",
+						  bank + 'A', line);
 
 		group->name = group_names[i] = pin_desc[i].name;
 		group->pin = pin_desc[i].number;
diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index d6e7e9f0ddec..39a55fd85b19 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1891,7 +1891,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < chip->ngpio; i++)
-		names[i] = kasprintf(GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
+		names[i] = devm_kasprintf(&pdev->dev, GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
 
 	chip->names = (const char *const *)names;
 
diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index e8149ff1d401..10595b43360b 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1250,6 +1250,7 @@ static struct irq_domain *stm32_pctrl_get_irq_domain(struct device_node *np)
 		return ERR_PTR(-ENXIO);
 
 	domain = irq_find_host(parent);
+	of_node_put(parent);
 	if (!domain)
 		/* domain not registered yet */
 		return ERR_PTR(-EPROBE_DEFER);
diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index 3f0b8e2ef3d4..7a3109a53881 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -530,9 +530,6 @@ struct powercap_zone *powercap_register_zone(
 	power_zone->name = kstrdup(name, GFP_KERNEL);
 	if (!power_zone->name)
 		goto err_name_alloc;
-	dev_set_name(&power_zone->dev, "%s:%x",
-					dev_name(power_zone->dev.parent),
-					power_zone->id);
 	power_zone->constraints = kcalloc(nr_constraints,
 					  sizeof(*power_zone->constraints),
 					  GFP_KERNEL);
@@ -555,9 +552,16 @@ struct powercap_zone *powercap_register_zone(
 	power_zone->dev_attr_groups[0] = &power_zone->dev_zone_attr_group;
 	power_zone->dev_attr_groups[1] = NULL;
 	power_zone->dev.groups = power_zone->dev_attr_groups;
+	dev_set_name(&power_zone->dev, "%s:%x",
+					dev_name(power_zone->dev.parent),
+					power_zone->id);
 	result = device_register(&power_zone->dev);
-	if (result)
-		goto err_dev_ret;
+	if (result) {
+		put_device(&power_zone->dev);
+		mutex_unlock(&control_type->lock);
+
+		return ERR_PTR(result);
+	}
 
 	control_type->nr_zones++;
 	mutex_unlock(&control_type->lock);
diff --git a/drivers/pwm/pwm-sifive.c b/drivers/pwm/pwm-sifive.c
index 538297ef8255..16c70147ec40 100644
--- a/drivers/pwm/pwm-sifive.c
+++ b/drivers/pwm/pwm-sifive.c
@@ -43,7 +43,7 @@
 
 struct pwm_sifive_ddata {
 	struct pwm_chip	chip;
-	struct mutex lock; /* lock to protect user_count */
+	struct mutex lock; /* lock to protect user_count and approx_period */
 	struct notifier_block notifier;
 	struct clk *clk;
 	void __iomem *regs;
@@ -78,6 +78,7 @@ static void pwm_sifive_free(struct pwm_chip *chip, struct pwm_device *pwm)
 	mutex_unlock(&ddata->lock);
 }
 
+/* Called holding ddata->lock */
 static void pwm_sifive_update_clock(struct pwm_sifive_ddata *ddata,
 				    unsigned long rate)
 {
@@ -166,7 +167,6 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 		return ret;
 	}
 
-	mutex_lock(&ddata->lock);
 	cur_state = pwm->state;
 	enabled = cur_state.enabled;
 
@@ -185,14 +185,23 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 	/* The hardware cannot generate a 100% duty cycle */
 	frac = min(frac, (1U << PWM_SIFIVE_CMPWIDTH) - 1);
 
+	mutex_lock(&ddata->lock);
 	if (state->period != ddata->approx_period) {
-		if (ddata->user_count != 1) {
+		/*
+		 * Don't let a 2nd user change the period underneath the 1st user.
+		 * However if ddate->approx_period == 0 this is the first time we set
+		 * any period, so let whoever gets here first set the period so other
+		 * users who agree on the period won't fail.
+		 */
+		if (ddata->user_count != 1 && ddata->approx_period) {
+			mutex_unlock(&ddata->lock);
 			ret = -EBUSY;
 			goto exit;
 		}
 		ddata->approx_period = state->period;
 		pwm_sifive_update_clock(ddata, clk_get_rate(ddata->clk));
 	}
+	mutex_unlock(&ddata->lock);
 
 	writel(frac, ddata->regs + PWM_SIFIVE_PWMCMP0 +
 	       pwm->hwpwm * PWM_SIFIVE_SIZE_PWMCMP);
@@ -202,7 +211,6 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 exit:
 	clk_disable(ddata->clk);
-	mutex_unlock(&ddata->lock);
 	return ret;
 }
 
diff --git a/drivers/pwm/pwm-stm32-lp.c b/drivers/pwm/pwm-stm32-lp.c
index 05bb1f95a773..20657c649c65 100644
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
index 7b8ec8c0bd15..660e179a82a2 100644
--- a/drivers/regulator/max77802-regulator.c
+++ b/drivers/regulator/max77802-regulator.c
@@ -95,9 +95,11 @@ static int max77802_set_suspend_disable(struct regulator_dev *rdev)
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
@@ -111,7 +113,7 @@ static int max77802_set_suspend_disable(struct regulator_dev *rdev)
 static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
 {
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 	unsigned int val;
 	int shift = max77802_get_opmode_shift(id);
 
@@ -128,6 +130,9 @@ static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
 		return -EINVAL;
 	}
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
+
 	max77802->opmode[id] = val;
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask, val << shift);
@@ -136,8 +141,10 @@ static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
 static unsigned max77802_get_mode(struct regulator_dev *rdev)
 {
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
 	return max77802_map_mode(max77802->opmode[id]);
 }
 
@@ -161,10 +168,13 @@ static int max77802_set_suspend_mode(struct regulator_dev *rdev,
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
@@ -210,9 +220,11 @@ static int max77802_set_suspend_mode(struct regulator_dev *rdev,
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
 
@@ -541,7 +553,7 @@ static int max77802_pmic_probe(struct platform_device *pdev)
 
 	for (i = 0; i < MAX77802_REG_MAX; i++) {
 		struct regulator_dev *rdev;
-		int id = regulators[i].id;
+		unsigned int id = regulators[i].id;
 		int shift = max77802_get_opmode_shift(id);
 		int ret;
 
@@ -559,10 +571,12 @@ static int max77802_pmic_probe(struct platform_device *pdev)
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
index 1e9f03a2ea1c..7ff480810cfa 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -924,10 +924,14 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 
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
diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index 5e54e6f5edb1..49faa90da93f 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
+#include <linux/of_reserved_mem.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
@@ -175,6 +176,9 @@ struct q6v5 {
 	void *mba_region;
 	size_t mba_size;
 
+	phys_addr_t mdata_phys;
+	size_t mdata_size;
+
 	phys_addr_t mpss_phys;
 	phys_addr_t mpss_reloc;
 	void *mpss_region;
@@ -679,15 +683,35 @@ static int q6v5_mpss_init_image(struct q6v5 *qproc, const struct firmware *fw)
 	if (IS_ERR(metadata))
 		return PTR_ERR(metadata);
 
-	ptr = dma_alloc_attrs(qproc->dev, size, &phys, GFP_KERNEL, dma_attrs);
-	if (!ptr) {
-		kfree(metadata);
-		dev_err(qproc->dev, "failed to allocate mdt buffer\n");
-		return -ENOMEM;
+	if (qproc->mdata_phys) {
+		if (size > qproc->mdata_size) {
+			ret = -EINVAL;
+			dev_err(qproc->dev, "metadata size outside memory range\n");
+			goto free_metadata;
+		}
+
+		phys = qproc->mdata_phys;
+		ptr = memremap(qproc->mdata_phys, size, MEMREMAP_WC);
+		if (!ptr) {
+			ret = -EBUSY;
+			dev_err(qproc->dev, "unable to map memory region: %pa+%zx\n",
+				&qproc->mdata_phys, size);
+			goto free_metadata;
+		}
+	} else {
+		ptr = dma_alloc_attrs(qproc->dev, size, &phys, GFP_KERNEL, dma_attrs);
+		if (!ptr) {
+			ret = -ENOMEM;
+			dev_err(qproc->dev, "failed to allocate mdt buffer\n");
+			goto free_metadata;
+		}
 	}
 
 	memcpy(ptr, metadata, size);
 
+	if (qproc->mdata_phys)
+		memunmap(ptr);
+
 	/* Hypervisor mapping to access metadata by modem */
 	mdata_perm = BIT(QCOM_SCM_VMID_HLOS);
 	ret = q6v5_xfer_mem_ownership(qproc, &mdata_perm, true, phys, size);
@@ -714,7 +738,9 @@ static int q6v5_mpss_init_image(struct q6v5 *qproc, const struct firmware *fw)
 			 "mdt buffer not reclaimed system may become unstable\n");
 
 free_dma_attrs:
-	dma_free_attrs(qproc->dev, size, ptr, phys, dma_attrs);
+	if (!qproc->mdata_phys)
+		dma_free_attrs(qproc->dev, size, ptr, phys, dma_attrs);
+free_metadata:
 	kfree(metadata);
 
 	return ret < 0 ? ret : 0;
@@ -1383,6 +1409,7 @@ static int q6v5_init_reset(struct q6v5 *qproc)
 static int q6v5_alloc_memory_region(struct q6v5 *qproc)
 {
 	struct device_node *child;
+	struct reserved_mem *rmem;
 	struct device_node *node;
 	struct resource r;
 	int ret;
@@ -1417,6 +1444,26 @@ static int q6v5_alloc_memory_region(struct q6v5 *qproc)
 	qproc->mpss_phys = qproc->mpss_reloc = r.start;
 	qproc->mpss_size = resource_size(&r);
 
+	if (!child) {
+		node = of_parse_phandle(qproc->dev->of_node, "memory-region", 2);
+	} else {
+		child = of_get_child_by_name(qproc->dev->of_node, "metadata");
+		node = of_parse_phandle(child, "memory-region", 0);
+		of_node_put(child);
+	}
+
+	if (!node)
+		return 0;
+
+	rmem = of_reserved_mem_lookup(node);
+	if (!rmem) {
+		dev_err(qproc->dev, "unable to resolve metadata region\n");
+		return -EINVAL;
+	}
+
+	qproc->mdata_phys = rmem->base;
+	qproc->mdata_size = rmem->size;
+
 	return 0;
 }
 
diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index b240830a0aab..11ba44dc551e 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -929,6 +929,7 @@ static void qcom_glink_handle_intent(struct qcom_glink *glink,
 	spin_unlock_irqrestore(&glink->idr_lock, flags);
 	if (!channel) {
 		dev_err(glink->dev, "intents for non-existing channel\n");
+		qcom_glink_rx_advance(glink, ALIGN(msglen, 8));
 		return;
 	}
 
diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
index f5a30e0f16c2..c22a79550071 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -219,7 +219,6 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	int rc, i;
 	u8 value[NUM_8_BIT_RTC_REGS];
-	unsigned int ctrl_reg;
 	unsigned long secs, irq_flags;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 	const struct pm8xxx_rtc_regs *regs = rtc_dd->regs;
@@ -231,6 +230,11 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 		secs >>= 8;
 	}
 
+	rc = regmap_update_bits(rtc_dd->regmap, regs->alarm_ctrl,
+				regs->alarm_en, 0);
+	if (rc)
+		return rc;
+
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
 
 	rc = regmap_bulk_write(rtc_dd->regmap, regs->alarm_rw, value,
@@ -240,19 +244,11 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
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
 
 	dev_dbg(dev, "Alarm Set for h:m:s=%ptRt, y-m-d=%ptRdr\n",
diff --git a/drivers/rtc/rtc-sun6i.c b/drivers/rtc/rtc-sun6i.c
index c41bc8084d7c..5bef4148c623 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -129,7 +129,6 @@ struct sun6i_rtc_clk_data {
 	unsigned int fixed_prescaler : 16;
 	unsigned int has_prescaler : 1;
 	unsigned int has_out_clk : 1;
-	unsigned int export_iosc : 1;
 	unsigned int has_losc_en : 1;
 	unsigned int has_auto_swt : 1;
 };
@@ -251,23 +250,19 @@ static void __init sun6i_rtc_clk_init(struct device_node *node,
 		writel(reg, rtc->base + SUN6I_LOSC_CTRL);
 	}
 
-	/* Switch to the external, more precise, oscillator */
-	reg |= SUN6I_LOSC_CTRL_EXT_OSC;
-	if (rtc->data->has_losc_en)
-		reg |= SUN6I_LOSC_CTRL_EXT_LOSC_EN;
+	/* Switch to the external, more precise, oscillator, if present */
+	if (of_get_property(node, "clocks", NULL)) {
+		reg |= SUN6I_LOSC_CTRL_EXT_OSC;
+		if (rtc->data->has_losc_en)
+			reg |= SUN6I_LOSC_CTRL_EXT_LOSC_EN;
+	}
 	writel(reg, rtc->base + SUN6I_LOSC_CTRL);
 
 	/* Yes, I know, this is ugly. */
 	sun6i_rtc = rtc;
 
-	/* Deal with old DTs */
-	if (!of_get_property(node, "clocks", NULL))
-		goto err;
-
-	/* Only read IOSC name from device tree if it is exported */
-	if (rtc->data->export_iosc)
-		of_property_read_string_index(node, "clock-output-names", 2,
-					      &iosc_name);
+	of_property_read_string_index(node, "clock-output-names", 2,
+				      &iosc_name);
 
 	rtc->int_osc = clk_hw_register_fixed_rate_with_accuracy(NULL,
 								iosc_name,
@@ -280,11 +275,13 @@ static void __init sun6i_rtc_clk_init(struct device_node *node,
 	}
 
 	parents[0] = clk_hw_get_name(rtc->int_osc);
+	/* If there is no external oscillator, this will be NULL and ... */
 	parents[1] = of_clk_get_parent_name(node, 0);
 
 	rtc->hw.init = &init;
 
 	init.parent_names = parents;
+	/* ... number of clock parents will be 1. */
 	init.num_parents = of_clk_get_parent_count(node) + 1;
 	of_property_read_string_index(node, "clock-output-names", 0,
 				      &init.name);
@@ -306,13 +303,10 @@ static void __init sun6i_rtc_clk_init(struct device_node *node,
 		goto err_register;
 	}
 
-	clk_data->num = 2;
+	clk_data->num = 3;
 	clk_data->hws[0] = &rtc->hw;
 	clk_data->hws[1] = __clk_get_hw(rtc->ext_losc);
-	if (rtc->data->export_iosc) {
-		clk_data->hws[2] = rtc->int_osc;
-		clk_data->num = 3;
-	}
+	clk_data->hws[2] = rtc->int_osc;
 	of_clk_add_hw_provider(node, of_clk_hw_onecell_get, clk_data);
 	return;
 
@@ -352,7 +346,6 @@ static const struct sun6i_rtc_clk_data sun8i_h3_rtc_data = {
 	.fixed_prescaler = 32,
 	.has_prescaler = 1,
 	.has_out_clk = 1,
-	.export_iosc = 1,
 };
 
 static void __init sun8i_h3_rtc_clk_init(struct device_node *node)
@@ -370,7 +363,6 @@ static const struct sun6i_rtc_clk_data sun50i_h6_rtc_data = {
 	.fixed_prescaler = 32,
 	.has_prescaler = 1,
 	.has_out_clk = 1,
-	.export_iosc = 1,
 	.has_losc_en = 1,
 	.has_auto_swt = 1,
 };
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index e0570cd0e520..3362f235e891 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2128,8 +2128,8 @@ static void __dasd_device_check_path_events(struct dasd_device *device)
 	if (device->stopped &
 	    ~(DASD_STOPPED_DC_WAIT | DASD_UNRESUMED_PM))
 		return;
-	rc = device->discipline->verify_path(device,
-					     dasd_path_get_tbvpm(device));
+	rc = device->discipline->pe_handler(device,
+					    dasd_path_get_tbvpm(device));
 	if (rc)
 		dasd_device_set_timer(device, 50);
 	else
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 53d22975a32f..c6930c159d2a 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -103,7 +103,7 @@ struct ext_pool_exhaust_work_data {
 };
 
 /* definitions for the path verification worker */
-struct path_verification_work_data {
+struct pe_handler_work_data {
 	struct work_struct worker;
 	struct dasd_device *device;
 	struct dasd_ccw_req cqr;
@@ -112,8 +112,8 @@ struct path_verification_work_data {
 	int isglobal;
 	__u8 tbvpm;
 };
-static struct path_verification_work_data *path_verification_worker;
-static DEFINE_MUTEX(dasd_path_verification_mutex);
+static struct pe_handler_work_data *pe_handler_worker;
+static DEFINE_MUTEX(dasd_pe_handler_mutex);
 
 struct check_attention_work_data {
 	struct work_struct worker;
@@ -1219,7 +1219,7 @@ static int verify_fcx_max_data(struct dasd_device *device, __u8 lpm)
 }
 
 static int rebuild_device_uid(struct dasd_device *device,
-			      struct path_verification_work_data *data)
+			      struct pe_handler_work_data *data)
 {
 	struct dasd_eckd_private *private = device->private;
 	__u8 lpm, opm = dasd_path_get_opm(device);
@@ -1257,10 +1257,9 @@ static int rebuild_device_uid(struct dasd_device *device,
 	return rc;
 }
 
-static void do_path_verification_work(struct work_struct *work)
+static void dasd_eckd_path_available_action(struct dasd_device *device,
+					    struct pe_handler_work_data *data)
 {
-	struct path_verification_work_data *data;
-	struct dasd_device *device;
 	struct dasd_eckd_private path_private;
 	struct dasd_uid *uid;
 	__u8 path_rcd_buf[DASD_ECKD_RCD_DATA_SIZE];
@@ -1269,19 +1268,6 @@ static void do_path_verification_work(struct work_struct *work)
 	char print_uid[60];
 	int rc;
 
-	data = container_of(work, struct path_verification_work_data, worker);
-	device = data->device;
-
-	/* delay path verification until device was resumed */
-	if (test_bit(DASD_FLAG_SUSPENDED, &device->flags)) {
-		schedule_work(work);
-		return;
-	}
-	/* check if path verification already running and delay if so */
-	if (test_and_set_bit(DASD_FLAG_PATH_VERIFY, &device->flags)) {
-		schedule_work(work);
-		return;
-	}
 	opm = 0;
 	npm = 0;
 	ppm = 0;
@@ -1418,30 +1404,54 @@ static void do_path_verification_work(struct work_struct *work)
 		dasd_path_add_nohpfpm(device, hpfpm);
 		spin_unlock_irqrestore(get_ccwdev_lock(device->cdev), flags);
 	}
+}
+
+static void do_pe_handler_work(struct work_struct *work)
+{
+	struct pe_handler_work_data *data;
+	struct dasd_device *device;
+
+	data = container_of(work, struct pe_handler_work_data, worker);
+	device = data->device;
+
+	/* delay path verification until device was resumed */
+	if (test_bit(DASD_FLAG_SUSPENDED, &device->flags)) {
+		schedule_work(work);
+		return;
+	}
+	/* check if path verification already running and delay if so */
+	if (test_and_set_bit(DASD_FLAG_PATH_VERIFY, &device->flags)) {
+		schedule_work(work);
+		return;
+	}
+
+	dasd_eckd_path_available_action(device, data);
+
 	clear_bit(DASD_FLAG_PATH_VERIFY, &device->flags);
 	dasd_put_device(device);
 	if (data->isglobal)
-		mutex_unlock(&dasd_path_verification_mutex);
+		mutex_unlock(&dasd_pe_handler_mutex);
 	else
 		kfree(data);
 }
 
-static int dasd_eckd_verify_path(struct dasd_device *device, __u8 lpm)
+static int dasd_eckd_pe_handler(struct dasd_device *device, __u8 lpm)
 {
-	struct path_verification_work_data *data;
+	struct pe_handler_work_data *data;
 
 	data = kmalloc(sizeof(*data), GFP_ATOMIC | GFP_DMA);
 	if (!data) {
-		if (mutex_trylock(&dasd_path_verification_mutex)) {
-			data = path_verification_worker;
+		if (mutex_trylock(&dasd_pe_handler_mutex)) {
+			data = pe_handler_worker;
 			data->isglobal = 1;
-		} else
+		} else {
 			return -ENOMEM;
+		}
 	} else {
 		memset(data, 0, sizeof(*data));
 		data->isglobal = 0;
 	}
-	INIT_WORK(&data->worker, do_path_verification_work);
+	INIT_WORK(&data->worker, do_pe_handler_work);
 	dasd_get_device(device);
 	data->device = device;
 	data->tbvpm = lpm;
@@ -6694,7 +6704,7 @@ static struct dasd_discipline dasd_eckd_discipline = {
 	.check_device = dasd_eckd_check_characteristics,
 	.uncheck_device = dasd_eckd_uncheck_device,
 	.do_analysis = dasd_eckd_do_analysis,
-	.verify_path = dasd_eckd_verify_path,
+	.pe_handler = dasd_eckd_pe_handler,
 	.basic_to_ready = dasd_eckd_basic_to_ready,
 	.online_to_ready = dasd_eckd_online_to_ready,
 	.basic_to_known = dasd_eckd_basic_to_known,
@@ -6753,18 +6763,20 @@ dasd_eckd_init(void)
 		return -ENOMEM;
 	dasd_vol_info_req = kmalloc(sizeof(*dasd_vol_info_req),
 				    GFP_KERNEL | GFP_DMA);
-	if (!dasd_vol_info_req)
+	if (!dasd_vol_info_req) {
+		kfree(dasd_reserve_req);
 		return -ENOMEM;
-	path_verification_worker = kmalloc(sizeof(*path_verification_worker),
-				   GFP_KERNEL | GFP_DMA);
-	if (!path_verification_worker) {
+	}
+	pe_handler_worker = kmalloc(sizeof(*pe_handler_worker),
+				    GFP_KERNEL | GFP_DMA);
+	if (!pe_handler_worker) {
 		kfree(dasd_reserve_req);
 		kfree(dasd_vol_info_req);
 		return -ENOMEM;
 	}
 	rawpadpage = (void *)__get_free_page(GFP_KERNEL);
 	if (!rawpadpage) {
-		kfree(path_verification_worker);
+		kfree(pe_handler_worker);
 		kfree(dasd_reserve_req);
 		kfree(dasd_vol_info_req);
 		return -ENOMEM;
@@ -6773,7 +6785,7 @@ dasd_eckd_init(void)
 	if (!ret)
 		wait_for_device_probe();
 	else {
-		kfree(path_verification_worker);
+		kfree(pe_handler_worker);
 		kfree(dasd_reserve_req);
 		kfree(dasd_vol_info_req);
 		free_page((unsigned long)rawpadpage);
@@ -6785,7 +6797,7 @@ static void __exit
 dasd_eckd_cleanup(void)
 {
 	ccw_driver_unregister(&dasd_eckd_driver);
-	kfree(path_verification_worker);
+	kfree(pe_handler_worker);
 	kfree(dasd_reserve_req);
 	free_page((unsigned long)rawpadpage);
 }
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index 9d9685c25253..e8a06d85d6f7 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -299,6 +299,7 @@ struct dasd_discipline {
 	 * configuration.
 	 */
 	int (*verify_path)(struct dasd_device *, __u8);
+	int (*pe_handler)(struct dasd_device *, __u8);
 
 	/*
 	 * Last things to do when a device is set online, and first things
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 5256e3ce84e5..fb1de363fb28 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -91,7 +91,7 @@ static DECLARE_WORK(ap_scan_work, ap_scan_bus);
  * Tasklet & timer for AP request polling and interrupts
  */
 static void ap_tasklet_fn(unsigned long);
-static DECLARE_TASKLET(ap_tasklet, ap_tasklet_fn, 0);
+static DECLARE_TASKLET_OLD(ap_tasklet, ap_tasklet_fn);
 static DECLARE_WAIT_QUEUE_HEAD(ap_poll_wait);
 static struct task_struct *ap_poll_kthread;
 static DEFINE_MUTEX(ap_poll_thread_mutex);
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index f923ed019d4a..593b167ceefe 100644
--- a/drivers/scsi/aic94xx/aic94xx_task.c
+++ b/drivers/scsi/aic94xx/aic94xx_task.c
@@ -50,6 +50,9 @@ static int asd_map_scatterlist(struct sas_task *task,
 		dma_addr_t dma = dma_map_single(&asd_ha->pcidev->dev, p,
 						task->total_xfer_len,
 						task->data_dir);
+		if (dma_mapping_error(&asd_ha->pcidev->dev, dma))
+			return -ENOMEM;
+
 		sg_arr[0].bus_addr = cpu_to_le64((u64)dma);
 		sg_arr[0].size = cpu_to_le32(task->total_xfer_len);
 		sg_arr[0].flags |= ASD_SG_EL_LIST_EOL;
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index a42837340edf..205ab65c3e28 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -1517,23 +1517,22 @@ static void ipr_process_ccn(struct ipr_cmnd *ipr_cmd)
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
@@ -1548,19 +1547,21 @@ static int strip_and_pad_whitespace(int i, char *buf)
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
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index f0de7089e9ae..ab9dcbd2006c 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -152,18 +152,6 @@ static void qla_nvme_release_fcp_cmd_kref(struct kref *kref)
 	qla2xxx_rel_qpair_sp(sp->qpair, sp);
 }
 
-static void qla_nvme_ls_unmap(struct srb *sp, struct nvmefc_ls_req *fd)
-{
-	if (sp->flags & SRB_DMA_VALID) {
-		struct srb_iocb *nvme = &sp->u.iocb_cmd;
-		struct qla_hw_data *ha = sp->fcport->vha->hw;
-
-		dma_unmap_single(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
-				 fd->rqstlen, DMA_TO_DEVICE);
-		sp->flags &= ~SRB_DMA_VALID;
-	}
-}
-
 static void qla_nvme_release_ls_cmd_kref(struct kref *kref)
 {
 	struct srb *sp = container_of(kref, struct srb, cmd_kref);
@@ -181,7 +169,6 @@ static void qla_nvme_release_ls_cmd_kref(struct kref *kref)
 
 	fd = priv->fd;
 
-	qla_nvme_ls_unmap(sp, fd);
 	fd->done(fd, priv->comp_status);
 out:
 	qla2x00_rel_sp(sp);
@@ -323,13 +310,10 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 	nvme->u.nvme.rsp_len = fd->rsplen;
 	nvme->u.nvme.rsp_dma = fd->rspdma;
 	nvme->u.nvme.timeout_sec = fd->timeout;
-	nvme->u.nvme.cmd_dma = dma_map_single(&ha->pdev->dev, fd->rqstaddr,
-	    fd->rqstlen, DMA_TO_DEVICE);
+	nvme->u.nvme.cmd_dma = fd->rqstdma;
 	dma_sync_single_for_device(&ha->pdev->dev, nvme->u.nvme.cmd_dma,
 	    fd->rqstlen, DMA_TO_DEVICE);
 
-	sp->flags |= SRB_DMA_VALID;
-
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
 		ql_log(ql_log_warn, vha, 0x700e,
@@ -337,7 +321,6 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 		wake_up(&sp->nvme_ls_waitq);
 		sp->priv = NULL;
 		priv->sp = NULL;
-		qla_nvme_ls_unmap(sp, fd);
 		qla2x00_rel_sp(sp);
 		return rval;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index a5dbaa3491f8..636571d3e820 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6361,9 +6361,12 @@ qla2x00_do_dpc(void *data)
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
 
@@ -6607,7 +6610,7 @@ qla2x00_timer(struct timer_list *t)
 
 		/* if the loop has been down for 4 minutes, reinit adapter */
 		if (atomic_dec_and_test(&vha->loop_down_timer) != 0) {
-			if (!(vha->device_flags & DFLG_NO_CABLE)) {
+			if (!(vha->device_flags & DFLG_NO_CABLE) && !vha->vp_idx) {
 				ql_log(ql_log_warn, vha, 0x6009,
 				    "Loop down - aborting ISP.\n");
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 98e363d0025b..490d6c72d8bd 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1645,12 +1645,7 @@ static bool scsi_mq_get_budget(struct blk_mq_hw_ctx *hctx)
 	struct request_queue *q = hctx->queue;
 	struct scsi_device *sdev = q->queuedata;
 
-	if (scsi_dev_queue_ready(q, sdev))
-		return true;
-
-	if (atomic_read(&sdev->device_busy) == 0 && !scsi_device_blocked(sdev))
-		blk_mq_delay_run_hw_queue(hctx, SCSI_QUEUE_DELAY);
-	return false;
+	return scsi_dev_queue_ready(q, sdev);
 }
 
 static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
diff --git a/drivers/scsi/ses.c b/drivers/scsi/ses.c
index 0a1734f34587..1707d6d144d2 100644
--- a/drivers/scsi/ses.c
+++ b/drivers/scsi/ses.c
@@ -433,8 +433,8 @@ int ses_match_host(struct enclosure_device *edev, void *data)
 }
 #endif  /*  0  */
 
-static void ses_process_descriptor(struct enclosure_component *ecomp,
-				   unsigned char *desc)
+static int ses_process_descriptor(struct enclosure_component *ecomp,
+				   unsigned char *desc, int max_desc_len)
 {
 	int eip = desc[0] & 0x10;
 	int invalid = desc[0] & 0x80;
@@ -445,22 +445,32 @@ static void ses_process_descriptor(struct enclosure_component *ecomp,
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
@@ -477,6 +487,8 @@ static void ses_process_descriptor(struct enclosure_component *ecomp,
 	}
 	ecomp->slot = slot;
 	scomp->addr = addr;
+
+	return 0;
 }
 
 struct efd {
@@ -549,7 +561,7 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
 		/* skip past overall descriptor */
 		desc_ptr += len + 4;
 	}
-	if (ses_dev->page10)
+	if (ses_dev->page10 && ses_dev->page10_len > 9)
 		addl_desc_ptr = ses_dev->page10 + 8;
 	type_ptr = ses_dev->page1_types;
 	components = 0;
@@ -557,17 +569,22 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
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
@@ -583,10 +600,14 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
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
@@ -603,9 +624,11 @@ static void ses_enclosure_data_process(struct enclosure_device *edev,
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
@@ -704,6 +727,12 @@ static int ses_intf_add(struct device *cdev,
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
@@ -827,7 +856,8 @@ static void ses_intf_remove_enclosure(struct scsi_device *sdev)
 	kfree(ses_dev->page2);
 	kfree(ses_dev);
 
-	kfree(edev->component[0].scratch);
+	if (edev->components)
+		kfree(edev->component[0].scratch);
 
 	put_device(&edev->edev);
 	enclosure_unregister(edev);
diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index 509476a2d79b..2ddace15c0f8 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -20,6 +20,8 @@
 #include <linux/spi/spi.h>
 #include <linux/mutex.h>
 #include <linux/of.h>
+#include <linux/reset.h>
+#include <linux/pm_runtime.h>
 
 #define HSSPI_GLOBAL_CTRL_REG			0x0
 #define GLOBAL_CTRL_CS_POLARITY_SHIFT		0
@@ -161,6 +163,7 @@ static int bcm63xx_hsspi_do_txrx(struct spi_device *spi, struct spi_transfer *t)
 	int step_size = HSSPI_BUFFER_LEN;
 	const u8 *tx = t->tx_buf;
 	u8 *rx = t->rx_buf;
+	u32 val = 0;
 
 	bcm63xx_hsspi_set_clk(bs, spi, t->speed_hz);
 	bcm63xx_hsspi_set_cs(bs, spi->chip_select, true);
@@ -176,11 +179,16 @@ static int bcm63xx_hsspi_do_txrx(struct spi_device *spi, struct spi_transfer *t)
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
@@ -428,13 +436,17 @@ static int bcm63xx_hsspi_probe(struct platform_device *pdev)
 	if (ret)
 		goto out_put_master;
 
+	pm_runtime_enable(&pdev->dev);
+
 	/* register and we are done */
 	ret = devm_spi_register_master(dev, master);
 	if (ret)
-		goto out_put_master;
+		goto out_pm_disable;
 
 	return 0;
 
+out_pm_disable:
+	pm_runtime_disable(&pdev->dev);
 out_put_master:
 	spi_master_put(master);
 out_disable_pll_clk:
diff --git a/drivers/spi/spi-synquacer.c b/drivers/spi/spi-synquacer.c
index 1e10af6e10a9..5d6e4a59ce29 100644
--- a/drivers/spi/spi-synquacer.c
+++ b/drivers/spi/spi-synquacer.c
@@ -472,10 +472,9 @@ static int synquacer_spi_transfer_one(struct spi_master *master,
 		read_fifo(sspi);
 	}
 
-	if (status < 0) {
-		dev_err(sspi->dev, "failed to transfer. status: 0x%x\n",
-			status);
-		return status;
+	if (status == 0) {
+		dev_err(sspi->dev, "failed to transfer. Timeout.\n");
+		return -ETIMEDOUT;
 	}
 
 	return 0;
diff --git a/drivers/staging/emxx_udc/emxx_udc.c b/drivers/staging/emxx_udc/emxx_udc.c
index cc4c18c3fb36..7d18ad68be26 100644
--- a/drivers/staging/emxx_udc/emxx_udc.c
+++ b/drivers/staging/emxx_udc/emxx_udc.c
@@ -2593,10 +2593,15 @@ static int nbu2ss_ep_queue(struct usb_ep *_ep,
 		req->unaligned = false;
 
 	if (req->unaligned) {
-		if (!ep->virt_buf)
+		if (!ep->virt_buf) {
 			ep->virt_buf = dma_alloc_coherent(udc->dev, PAGE_SIZE,
 							  &ep->phys_buf,
 							  GFP_ATOMIC | GFP_DMA);
+			if (!ep->virt_buf) {
+				spin_unlock_irqrestore(&udc->lock, flags);
+				return -ENOMEM;
+			}
+		}
 		if (ep->epnum > 0)  {
 			if (ep->direct == USB_DIR_IN)
 				memcpy(ep->virt_buf, req->req.buf,
diff --git a/drivers/staging/most/dim2/dim2.c b/drivers/staging/most/dim2/dim2.c
index 64c979155a49..774abedad987 100644
--- a/drivers/staging/most/dim2/dim2.c
+++ b/drivers/staging/most/dim2/dim2.c
@@ -47,7 +47,7 @@ MODULE_PARM_DESC(fcnt, "Num of frames per sub-buffer for sync channels as a powe
 static DEFINE_SPINLOCK(dim_lock);
 
 static void dim2_tasklet_fn(unsigned long data);
-static DECLARE_TASKLET(dim2_tasklet, dim2_tasklet_fn, 0);
+static DECLARE_TASKLET_OLD(dim2_tasklet, dim2_tasklet_fn);
 
 /**
  * struct hdm_channel - private structure to keep channel specific data
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index fe6e1ae73460..100b235b5688 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -41,7 +41,7 @@
 #endif
 
 static void cvm_oct_tx_do_cleanup(unsigned long arg);
-static DECLARE_TASKLET(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_cleanup, 0);
+static DECLARE_TASKLET_OLD(cvm_oct_tx_cleanup_tasklet, cvm_oct_tx_do_cleanup);
 
 /* Maximum number of SKBs to try to free per xmit packet. */
 #define MAX_SKB_TO_FREE (MAX_OUT_QUEUE_DEPTH * 2)
diff --git a/drivers/staging/wilc1000/wilc_netdev.c b/drivers/staging/wilc1000/wilc_netdev.c
index 508acb8bb089..f34b1f0d3a80 100644
--- a/drivers/staging/wilc1000/wilc_netdev.c
+++ b/drivers/staging/wilc1000/wilc_netdev.c
@@ -717,14 +717,15 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	if (skb->dev != ndev) {
 		netdev_err(ndev, "Packet not destined to this device\n");
-		return 0;
+		dev_kfree_skb(skb);
+		return NETDEV_TX_OK;
 	}
 
 	tx_data = kmalloc(sizeof(*tx_data), GFP_ATOMIC);
 	if (!tx_data) {
 		dev_kfree_skb(skb);
 		netif_wake_queue(ndev);
-		return 0;
+		return NETDEV_TX_OK;
 	}
 
 	tx_data->buff = skb->data;
@@ -748,7 +749,7 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 		mutex_unlock(&wilc->vif_mutex);
 	}
 
-	return 0;
+	return NETDEV_TX_OK;
 }
 
 static int wilc_mac_close(struct net_device *ndev)
diff --git a/drivers/thermal/hisi_thermal.c b/drivers/thermal/hisi_thermal.c
index 2d26ae80e202..bee6d3524e52 100644
--- a/drivers/thermal/hisi_thermal.c
+++ b/drivers/thermal/hisi_thermal.c
@@ -435,10 +435,6 @@ static int hi3660_thermal_probe(struct hisi_thermal_data *data)
 	data->sensor[0].irq_name = "tsensor_a73";
 	data->sensor[0].data = data;
 
-	data->sensor[1].id = HI3660_LITTLE_SENSOR;
-	data->sensor[1].irq_name = "tsensor_a53";
-	data->sensor[1].data = data;
-
 	return 0;
 }
 
diff --git a/drivers/thermal/intel/Kconfig b/drivers/thermal/intel/Kconfig
index 8025b21f43fa..b5427579fae5 100644
--- a/drivers/thermal/intel/Kconfig
+++ b/drivers/thermal/intel/Kconfig
@@ -60,7 +60,8 @@ endmenu
 
 config INTEL_BXT_PMIC_THERMAL
 	tristate "Intel Broxton PMIC thermal driver"
-	depends on X86 && INTEL_SOC_PMIC_BXTWC && REGMAP
+	depends on X86 && INTEL_SOC_PMIC_BXTWC
+	select REGMAP
 	help
 	  Select this driver for Intel Broxton PMIC with ADC channels monitoring
 	  system temperature measurements and alerts.
diff --git a/drivers/thermal/intel/intel_powerclamp.c b/drivers/thermal/intel/intel_powerclamp.c
index a717cce4aca4..d24f637a6a1e 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -57,6 +57,7 @@
 
 static unsigned int target_mwait;
 static struct dentry *debug_dir;
+static bool poll_pkg_cstate_enable;
 
 /* user selected target */
 static unsigned int set_target_ratio;
@@ -265,6 +266,9 @@ static unsigned int get_compensation(int ratio)
 {
 	unsigned int comp = 0;
 
+	if (!poll_pkg_cstate_enable)
+		return 0;
+
 	/* we only use compensation if all adjacent ones are good */
 	if (ratio == 1 &&
 		cal_data[ratio].confidence >= CONFIDENCE_OK &&
@@ -537,7 +541,8 @@ static int start_power_clamp(void)
 	control_cpu = cpumask_first(cpu_online_mask);
 
 	clamping = true;
-	schedule_delayed_work(&poll_pkg_cstate_work, 0);
+	if (poll_pkg_cstate_enable)
+		schedule_delayed_work(&poll_pkg_cstate_work, 0);
 
 	/* start one kthread worker per online cpu */
 	for_each_online_cpu(cpu) {
@@ -606,11 +611,15 @@ static int powerclamp_get_max_state(struct thermal_cooling_device *cdev,
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
@@ -735,6 +744,9 @@ static int __init powerclamp_init(void)
 		goto exit_unregister;
 	}
 
+	if (topology_max_packages() == 1 && topology_max_die_per_package() == 1)
+		poll_pkg_cstate_enable = true;
+
 	cooling_dev = thermal_cooling_device_register("intel_powerclamp", NULL,
 						&powerclamp_cooling_ops);
 	if (IS_ERR(cooling_dev)) {
diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
index 5d33b350da1c..ad92d8f0add1 100644
--- a/drivers/thermal/intel/intel_quark_dts_thermal.c
+++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
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
diff --git a/drivers/thermal/intel/intel_soc_dts_iosf.c b/drivers/thermal/intel/intel_soc_dts_iosf.c
index 5716b62e0f73..410f13f6cba4 100644
--- a/drivers/thermal/intel/intel_soc_dts_iosf.c
+++ b/drivers/thermal/intel/intel_soc_dts_iosf.c
@@ -396,7 +396,7 @@ struct intel_soc_dts_sensors *intel_soc_dts_iosf_init(
 {
 	struct intel_soc_dts_sensors *sensors;
 	bool notification;
-	u32 tj_max;
+	int tj_max;
 	int ret;
 	int i;
 
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index e84cef42f4b7..790e48262579 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1370,12 +1370,32 @@ static void lpuart_break_ctl(struct uart_port *port, int break_state)
 
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
index ddfe873b5fcc..37c46c65a65f 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1156,14 +1156,16 @@ static struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
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
diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
index 68643f61f6f9..0da9e0ab045b 100644
--- a/drivers/tty/vt/keyboard.c
+++ b/drivers/tty/vt/keyboard.c
@@ -1241,7 +1241,7 @@ static void kbd_bh(unsigned long dummy)
 	}
 }
 
-DECLARE_TASKLET_DISABLED(keyboard_tasklet, kbd_bh, 0);
+DECLARE_TASKLET_DISABLED_OLD(keyboard_tasklet, kbd_bh);
 
 #if defined(CONFIG_X86) || defined(CONFIG_IA64) || defined(CONFIG_ALPHA) ||\
     defined(CONFIG_MIPS) || defined(CONFIG_PPC) || defined(CONFIG_SPARC) ||\
diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index eb7208f07345..90de3331e4a5 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -296,10 +296,8 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		 */
 		size = vcs_size(inode);
 		if (size < 0) {
-			if (read)
-				break;
 			ret = size;
-			goto unlock_out;
+			break;
 		}
 		if (pos >= size)
 			break;
diff --git a/drivers/usb/gadget/udc/snps_udc_core.c b/drivers/usb/gadget/udc/snps_udc_core.c
index 3fcded31405a..e76f1a50b0fc 100644
--- a/drivers/usb/gadget/udc/snps_udc_core.c
+++ b/drivers/usb/gadget/udc/snps_udc_core.c
@@ -96,9 +96,7 @@ static int stop_pollstall_timer;
 static DECLARE_COMPLETION(on_pollstall_exit);
 
 /* tasklet for usb disconnect */
-static DECLARE_TASKLET(disconnect_tasklet, udc_tasklet_disconnect,
-		(unsigned long) &udc);
-
+static DECLARE_TASKLET_OLD(disconnect_tasklet, udc_tasklet_disconnect);
 
 /* endpoint names used for print */
 static const char ep0_string[] = "ep0in";
@@ -1661,7 +1659,7 @@ static void usb_disconnect(struct udc *dev)
 /* Tasklet for disconnect to be outside of interrupt context */
 static void udc_tasklet_disconnect(unsigned long par)
 {
-	struct udc *dev = (struct udc *)(*((struct udc **) par));
+	struct udc *dev = udc;
 	u32 tmp;
 
 	DBG(dev, "Tasklet disconnect\n");
diff --git a/drivers/usb/host/fhci-sched.c b/drivers/usb/host/fhci-sched.c
index 3235d5307403..5c423f240a1f 100644
--- a/drivers/usb/host/fhci-sched.c
+++ b/drivers/usb/host/fhci-sched.c
@@ -677,7 +677,7 @@ static void process_done_list(unsigned long data)
 	enable_irq(fhci_to_hcd(fhci)->irq);
 }
 
-DECLARE_TASKLET(fhci_tasklet, process_done_list, 0);
+DECLARE_TASKLET_OLD(fhci_tasklet, process_done_list);
 
 /* transfer complted callback */
 u32 fhci_transfer_confirm_callback(struct fhci_hcd *fhci)
diff --git a/drivers/usb/host/xhci-mvebu.c b/drivers/usb/host/xhci-mvebu.c
index f27d5c2c42f3..bb70dcc2f84f 100644
--- a/drivers/usb/host/xhci-mvebu.c
+++ b/drivers/usb/host/xhci-mvebu.c
@@ -33,7 +33,7 @@ static void xhci_mvebu_mbus_config(void __iomem *base,
 
 	/* Program each DRAM CS in a seperate window */
 	for (win = 0; win < dram->num_cs; win++) {
-		const struct mbus_dram_window *cs = dram->cs + win;
+		const struct mbus_dram_window *cs = &dram->cs[win];
 
 		writel(((cs->size - 1) & 0xffff0000) | (cs->mbus_attr << 8) |
 		       (dram->mbus_dram_target_id << 4) | 1,
diff --git a/drivers/usb/storage/ene_ub6250.c b/drivers/usb/storage/ene_ub6250.c
index 9c984f3c7248..b076260a2ca4 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -938,7 +938,7 @@ static int ms_lib_process_bootblock(struct us_data *us, u16 PhyBlock, u8 *PageDa
 	struct ms_lib_type_extdat ExtraData;
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
 
-	PageBuffer = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL);
+	PageBuffer = kzalloc(MS_BYTES_PER_PAGE * 2, GFP_KERNEL);
 	if (PageBuffer == NULL)
 		return (u32)-1;
 
diff --git a/drivers/watchdog/at91sam9_wdt.c b/drivers/watchdog/at91sam9_wdt.c
index 292b5a1ca831..fed7be246442 100644
--- a/drivers/watchdog/at91sam9_wdt.c
+++ b/drivers/watchdog/at91sam9_wdt.c
@@ -206,10 +206,9 @@ static int at91_wdt_init(struct platform_device *pdev, struct at91wdt *wdt)
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
index 6727f8ab2d18..ce94b6f35488 100644
--- a/drivers/watchdog/pcwd_usb.c
+++ b/drivers/watchdog/pcwd_usb.c
@@ -325,7 +325,8 @@ static int usb_pcwd_set_heartbeat(struct usb_pcwd_private *usb_pcwd, int t)
 static int usb_pcwd_get_temperature(struct usb_pcwd_private *usb_pcwd,
 							int *temperature)
 {
-	unsigned char msb, lsb;
+	unsigned char msb = 0x00;
+	unsigned char lsb = 0x00;
 
 	usb_pcwd_send_command(usb_pcwd, CMD_READ_TEMP, &msb, &lsb);
 
@@ -341,7 +342,8 @@ static int usb_pcwd_get_temperature(struct usb_pcwd_private *usb_pcwd,
 static int usb_pcwd_get_timeleft(struct usb_pcwd_private *usb_pcwd,
 								int *time_left)
 {
-	unsigned char msb, lsb;
+	unsigned char msb = 0x00;
+	unsigned char lsb = 0x00;
 
 	/* Read the time that's left before rebooting */
 	/* Note: if the board is not yet armed then we will read 0xFFFF */
diff --git a/drivers/watchdog/watchdog_dev.c b/drivers/watchdog/watchdog_dev.c
index 8494846ccdc5..c670d13ab3d9 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -1016,8 +1016,8 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 		if (wdd->id == 0) {
 			misc_deregister(&watchdog_miscdev);
 			old_wd_data = NULL;
-			put_device(&wd_data->dev);
 		}
+		put_device(&wd_data->dev);
 		return err;
 	}
 
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index 2cea6c25d1b0..2f2a1d980cdf 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1784,6 +1784,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 allocate_mr_failed:
 	/* At this point, need to a full transport shutdown */
+	server->smbd_conn = info;
 	smbd_destroy(server);
 	return NULL;
 
@@ -2347,6 +2348,7 @@ static int allocate_mr_list(struct smbd_connection *info)
 	atomic_set(&info->mr_ready_count, 0);
 	atomic_set(&info->mr_used_count, 0);
 	init_waitqueue_head(&info->wait_for_mr_cleanup);
+	INIT_WORK(&info->mr_recovery_work, smbd_mr_recovery_work);
 	/* Allocate more MRs (2x) than hardware responder_resources */
 	for (i = 0; i < info->responder_resources * 2; i++) {
 		smbdirect_mr = kzalloc(sizeof(*smbdirect_mr), GFP_KERNEL);
@@ -2375,13 +2377,13 @@ static int allocate_mr_list(struct smbd_connection *info)
 		list_add_tail(&smbdirect_mr->list, &info->mr_list);
 		atomic_inc(&info->mr_ready_count);
 	}
-	INIT_WORK(&info->mr_recovery_work, smbd_mr_recovery_work);
 	return 0;
 
 out:
 	kfree(smbdirect_mr);
 
 	list_for_each_entry_safe(smbdirect_mr, tmp, &info->mr_list, list) {
+		list_del(&smbdirect_mr->list);
 		ib_dereg_mr(smbdirect_mr->mr);
 		kfree(smbdirect_mr->sgl);
 		kfree(smbdirect_mr);
diff --git a/fs/coda/upcall.c b/fs/coda/upcall.c
index eb3b1898da46..610484c90260 100644
--- a/fs/coda/upcall.c
+++ b/fs/coda/upcall.c
@@ -790,7 +790,7 @@ static int coda_upcall(struct venus_comm *vcp,
 	sig_req = kmalloc(sizeof(struct upc_req), GFP_KERNEL);
 	if (!sig_req) goto exit;
 
-	sig_inputArgs = kvzalloc(sizeof(struct coda_in_hdr), GFP_KERNEL);
+	sig_inputArgs = kvzalloc(sizeof(*sig_inputArgs), GFP_KERNEL);
 	if (!sig_inputArgs) {
 		kfree(sig_req);
 		goto exit;
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index 78df2d65998e..cf794afbd52f 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1432,6 +1432,13 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
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
@@ -2579,9 +2586,8 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 
 	is = kzalloc(sizeof(struct ext4_xattr_ibody_find), GFP_NOFS);
 	bs = kzalloc(sizeof(struct ext4_xattr_block_find), GFP_NOFS);
-	buffer = kvmalloc(value_size, GFP_NOFS);
 	b_entry_name = kmalloc(entry->e_name_len + 1, GFP_NOFS);
-	if (!is || !bs || !buffer || !b_entry_name) {
+	if (!is || !bs || !b_entry_name) {
 		error = -ENOMEM;
 		goto out;
 	}
@@ -2593,12 +2599,18 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 
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
@@ -2613,25 +2625,26 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
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
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 773028921c48..03dffb126d5c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -496,7 +496,7 @@ int f2fs_submit_page_bio(struct f2fs_io_info *fio)
 	}
 
 	if (fio->io_wbc && !is_read_io(fio->op))
-		wbc_account_cgroup_owner(fio->io_wbc, page, PAGE_SIZE);
+		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	bio_set_op_attrs(bio, fio->op, fio->op_flags);
 
@@ -575,7 +575,7 @@ int f2fs_merge_page_bio(struct f2fs_io_info *fio)
 	}
 
 	if (fio->io_wbc)
-		wbc_account_cgroup_owner(fio->io_wbc, page, PAGE_SIZE);
+		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	inc_page_count(fio->sbi, WB_DATA_TYPE(page));
 
@@ -652,7 +652,7 @@ void f2fs_submit_page_write(struct f2fs_io_info *fio)
 	}
 
 	if (fio->io_wbc)
-		wbc_account_cgroup_owner(fio->io_wbc, bio_page, PAGE_SIZE);
+		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	io->last_block_in_bio = fio->new_blkaddr;
 	f2fs_trace_ios(fio, 0);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index c6bd669f4b4e..a700df05cd18 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -43,7 +43,6 @@ bool f2fs_may_inline_dentry(struct inode *inode)
 void f2fs_do_read_inline_data(struct page *page, struct page *ipage)
 {
 	struct inode *inode = page->mapping->host;
-	void *src_addr, *dst_addr;
 
 	if (PageUptodate(page))
 		return;
@@ -53,11 +52,8 @@ void f2fs_do_read_inline_data(struct page *page, struct page *ipage)
 	zero_user_segment(page, MAX_INLINE_DATA(inode), PAGE_SIZE);
 
 	/* Copy the whole inline data block */
-	src_addr = inline_data_addr(inode, ipage);
-	dst_addr = kmap_atomic(page);
-	memcpy(dst_addr, src_addr, MAX_INLINE_DATA(inode));
-	flush_dcache_page(page);
-	kunmap_atomic(dst_addr);
+	memcpy_to_page(page, 0, inline_data_addr(inode, ipage),
+		       MAX_INLINE_DATA(inode));
 	if (!PageUptodate(page))
 		SetPageUptodate(page);
 }
@@ -224,7 +220,6 @@ int f2fs_convert_inline_inode(struct inode *inode)
 
 int f2fs_write_inline_data(struct inode *inode, struct page *page)
 {
-	void *src_addr, *dst_addr;
 	struct dnode_of_data dn;
 	int err;
 
@@ -241,10 +236,8 @@ int f2fs_write_inline_data(struct inode *inode, struct page *page)
 	f2fs_bug_on(F2FS_I_SB(inode), page->index);
 
 	f2fs_wait_on_page_writeback(dn.inode_page, NODE, true, true);
-	src_addr = kmap_atomic(page);
-	dst_addr = inline_data_addr(inode, dn.inode_page);
-	memcpy(dst_addr, src_addr, MAX_INLINE_DATA(inode));
-	kunmap_atomic(src_addr);
+	memcpy_from_page(inline_data_addr(inode, dn.inode_page),
+			 page, 0, MAX_INLINE_DATA(inode));
 	set_page_dirty(dn.inode_page);
 
 	f2fs_clear_page_cache_dirty_tag(page);
@@ -402,18 +395,17 @@ static int f2fs_move_inline_dirents(struct inode *dir, struct page *ipage,
 
 	dentry_blk = page_address(page);
 
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
 
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 3f2fe6034640..401bc0e7f6eb 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1824,7 +1824,6 @@ static ssize_t f2fs_quota_read(struct super_block *sb, int type, char *data,
 	size_t toread;
 	loff_t i_size = i_size_read(inode);
 	struct page *page;
-	char *kaddr;
 
 	if (off > i_size)
 		return 0;
@@ -1857,9 +1856,7 @@ static ssize_t f2fs_quota_read(struct super_block *sb, int type, char *data,
 			return -EIO;
 		}
 
-		kaddr = kmap_atomic(page);
-		memcpy(data, kaddr + offset, tocopy);
-		kunmap_atomic(kaddr);
+		memcpy_from_page(data, page, offset, tocopy);
 		f2fs_put_page(page, 1);
 
 		offset = 0;
@@ -1881,7 +1878,6 @@ static ssize_t f2fs_quota_write(struct super_block *sb, int type,
 	size_t towrite = len;
 	struct page *page;
 	void *fsdata = NULL;
-	char *kaddr;
 	int err = 0;
 	int tocopy;
 
@@ -1900,10 +1896,7 @@ static ssize_t f2fs_quota_write(struct super_block *sb, int type,
 			break;
 		}
 
-		kaddr = kmap_atomic(page);
-		memcpy(kaddr + offset, data, tocopy);
-		kunmap_atomic(kaddr);
-		flush_dcache_page(page);
+		memcpy_to_page(page, offset, data, tocopy);
 
 		a_ops->write_end(NULL, mapping, off, tocopy, tocopy,
 						page, fsdata);
diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
index 7944a08a3977..c4bd5a154252 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -45,16 +45,13 @@ static int pagecache_read(struct inode *inode, void *buf, size_t count,
 		size_t n = min_t(size_t, count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
-		void *addr;
 
 		page = read_mapping_page(inode->i_mapping, pos >> PAGE_SHIFT,
 					 NULL);
 		if (IS_ERR(page))
 			return PTR_ERR(page);
 
-		addr = kmap_atomic(page);
-		memcpy(buf, addr + offset_in_page(pos), n);
-		kunmap_atomic(addr);
+		memcpy_from_page(buf, page, offset_in_page(pos), n);
 
 		put_page(page);
 
@@ -79,8 +76,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		size_t n = min_t(size_t, count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
-		void *fsdata;
-		void *addr;
+		void *fsdata = NULL;
 		int res;
 
 		res = pagecache_write_begin(NULL, inode->i_mapping, pos, n, 0,
@@ -88,9 +84,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		if (res)
 			return res;
 
-		addr = kmap_atomic(page);
-		memcpy(addr + offset_in_page(pos), buf, n);
-		kunmap_atomic(addr);
+		memcpy_to_page(page, offset_in_page(pos), buf, n);
 
 		res = pagecache_write_end(NULL, inode->i_mapping, pos, n, n,
 					  page, fsdata);
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index b9fe975d7625..c21383fab33b 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -156,7 +156,6 @@ static int __gfs2_jdata_writepage(struct page *page, struct writeback_control *w
 {
 	struct inode *inode = page->mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
 
 	if (PageChecked(page)) {
 		ClearPageChecked(page);
@@ -164,7 +163,7 @@ static int __gfs2_jdata_writepage(struct page *page, struct writeback_control *w
 			create_empty_buffers(page, inode->i_sb->s_blocksize,
 					     BIT(BH_Dirty)|BIT(BH_Uptodate));
 		}
-		gfs2_page_add_databufs(ip, page, 0, sdp->sd_vfs->s_blocksize);
+		gfs2_page_add_databufs(ip, page, 0, PAGE_SIZE);
 	}
 	return gfs2_write_full_page(page, gfs2_get_block_noalloc, wbc);
 }
diff --git a/fs/hfs/bnode.c b/fs/hfs/bnode.c
index c0a73a6ffb28..397e02a56697 100644
--- a/fs/hfs/bnode.c
+++ b/fs/hfs/bnode.c
@@ -281,6 +281,7 @@ static struct hfs_bnode *__hfs_bnode_create(struct hfs_btree *tree, u32 cnid)
 		tree->node_hash[hash] = node;
 		tree->node_hash_cnt++;
 	} else {
+		hfs_bnode_get(node2);
 		spin_unlock(&tree->hash_lock);
 		kfree(node);
 		wait_event(node2->lock_wq, !test_bit(HFS_BNODE_NEW, &node2->flags));
diff --git a/fs/hfsplus/super.c b/fs/hfsplus/super.c
index 2b9e5743105e..29a39afe2653 100644
--- a/fs/hfsplus/super.c
+++ b/fs/hfsplus/super.c
@@ -295,11 +295,11 @@ static void hfsplus_put_super(struct super_block *sb)
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
index aa4643854f94..cc1fed285b2d 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -193,7 +193,8 @@ int dbMount(struct inode *ipbmap)
 	bmp->db_agwidth = le32_to_cpu(dbmp_le->dn_agwidth);
 	bmp->db_agstart = le32_to_cpu(dbmp_le->dn_agstart);
 	bmp->db_agl2size = le32_to_cpu(dbmp_le->dn_agl2size);
-	if (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG) {
+	if (bmp->db_agl2size > L2MAXL2SIZE - L2MAXAG ||
+	    bmp->db_agl2size < 0) {
 		err = -EINVAL;
 		goto err_release_metapage;
 	}
diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index e12409eca7cc..215362144aec 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -322,11 +322,11 @@ nfsd4_recall_file_layout(struct nfs4_layout_stateid *ls)
 	if (ls->ls_recalled)
 		goto out_unlock;
 
-	ls->ls_recalled = true;
-	atomic_inc(&ls->ls_stid.sc_file->fi_lo_recalls);
 	if (list_empty(&ls->ls_layouts))
 		goto out_unlock;
 
+	ls->ls_recalled = true;
+	atomic_inc(&ls->ls_stid.sc_file->fi_lo_recalls);
 	trace_nfsd_layout_recall(&ls->ls_stid.sc_stateid);
 
 	refcount_inc(&ls->ls_stid.sc_count);
diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 452ed633a2c7..bd7846758947 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1059,8 +1059,10 @@ nfsd4_verify_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 	return status;
 out_put_dst:
 	nfsd_file_put(*dst);
+	*dst = NULL;
 out_put_src:
 	nfsd_file_put(*src);
+	*src = NULL;
 	goto out;
 }
 
diff --git a/fs/ocfs2/move_extents.c b/fs/ocfs2/move_extents.c
index 758d9661ef1e..98e77ea957ff 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -107,14 +107,6 @@ static int __ocfs2_move_extent(handle_t *handle,
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
@@ -123,8 +115,6 @@ static int __ocfs2_move_extent(handle_t *handle,
 		goto out;
 	}
 
-	ocfs2_journal_dirty(handle, context->et.et_root_bh);
-
 	context->new_phys_cpos = new_p_cpos;
 
 	/*
@@ -446,7 +436,7 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 			bg = (struct ocfs2_group_desc *)gd_bh->b_data;
 
 			if (vict_blkno < (le64_to_cpu(bg->bg_blkno) +
-						le16_to_cpu(bg->bg_bits))) {
+						(le16_to_cpu(bg->bg_bits) << bits_per_unit))) {
 
 				*ret_bh = gd_bh;
 				*vict_bit = (vict_blkno - blkno) >>
@@ -561,6 +551,7 @@ static void ocfs2_probe_alloc_group(struct inode *inode, struct buffer_head *bh,
 			last_free_bits++;
 
 		if (last_free_bits == move_len) {
+			i -= move_len;
 			*goal_bit = i;
 			*phys_cpos = base_cpos + i;
 			break;
@@ -1032,18 +1023,19 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 
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
index c0b84e960b20..9cb05ef9b9dd 100644
--- a/fs/ubifs/budget.c
+++ b/fs/ubifs/budget.c
@@ -212,11 +212,10 @@ long long ubifs_calc_available(const struct ubifs_info *c, int min_idx_lebs)
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
@@ -403,7 +402,7 @@ static int calc_dd_growth(const struct ubifs_info *c,
 	dd_growth = req->dirtied_page ? c->bi.page_budget : 0;
 
 	if (req->dirtied_ino)
-		dd_growth += c->bi.inode_budget << (req->dirtied_ino - 1);
+		dd_growth += c->bi.inode_budget * req->dirtied_ino;
 	if (req->mod_dent)
 		dd_growth += c->bi.dent_budget;
 	dd_growth += req->dirtied_ino_d;
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 83a173feb698..332c0b02a0ad 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1125,7 +1125,6 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
 	int err, sz_change, len = strlen(symname);
 	struct fscrypt_str disk_link;
 	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
-					.new_ino_d = ALIGN(len, 8),
 					.dirtied_ino = 1 };
 	struct fscrypt_name nm;
 
@@ -1141,6 +1140,7 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
 	 * Budget request settings: new inode, new direntry and changing parent
 	 * directory inode.
 	 */
+	req.new_ino_d = ALIGN(disk_link.len - 1, 8);
 	err = ubifs_budget_space(c, &req);
 	if (err)
 		return err;
@@ -1296,6 +1296,8 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (unlink) {
 		ubifs_assert(c, inode_is_locked(new_inode));
 
+		/* Budget for old inode's data when its nlink > 1. */
+		req.dirtied_ino_d = ALIGN(ubifs_inode(new_inode)->data_len, 8);
 		err = ubifs_purge_xattrs(new_inode);
 		if (err)
 			return err;
@@ -1538,6 +1540,10 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 		return err;
 	}
 
+	err = ubifs_budget_space(c, &req);
+	if (err)
+		goto out;
+
 	lock_4_inodes(old_dir, new_dir, NULL, NULL);
 
 	time = current_time(old_dir);
@@ -1563,6 +1569,7 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	unlock_4_inodes(old_dir, new_dir, NULL, NULL);
 	ubifs_release_budget(c, &req);
 
+out:
 	fscrypt_free_filename(&fst_nm);
 	fscrypt_free_filename(&snd_nm);
 	return err;
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 6069c63d833a..177cd4a751eb 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1031,7 +1031,7 @@ static int ubifs_writepage(struct page *page, struct writeback_control *wbc)
 		if (page->index >= synced_i_size >> PAGE_SHIFT) {
 			err = inode->i_sb->s_op->write_inode(inode, NULL);
 			if (err)
-				goto out_unlock;
+				goto out_redirty;
 			/*
 			 * The inode has been written, but the write-buffer has
 			 * not been synchronized, so in case of an unclean
@@ -1059,11 +1059,17 @@ static int ubifs_writepage(struct page *page, struct writeback_control *wbc)
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
diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
index b37c6b1e3325..29526040ad77 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -815,7 +815,7 @@ static int alloc_wbufs(struct ubifs_info *c)
 		INIT_LIST_HEAD(&c->jheads[i].buds_list);
 		err = ubifs_wbuf_init(c, &c->jheads[i].wbuf);
 		if (err)
-			return err;
+			goto out_wbuf;
 
 		c->jheads[i].wbuf.sync_callback = &bud_wbuf_callback;
 		c->jheads[i].wbuf.jhead = i;
@@ -823,7 +823,7 @@ static int alloc_wbufs(struct ubifs_info *c)
 		c->jheads[i].log_hash = ubifs_hash_get_desc(c);
 		if (IS_ERR(c->jheads[i].log_hash)) {
 			err = PTR_ERR(c->jheads[i].log_hash);
-			goto out;
+			goto out_log_hash;
 		}
 	}
 
@@ -836,9 +836,18 @@ static int alloc_wbufs(struct ubifs_info *c)
 
 	return 0;
 
-out:
-	while (i--)
+out_log_hash:
+	kfree(c->jheads[i].wbuf.buf);
+	kfree(c->jheads[i].wbuf.inodes);
+
+out_wbuf:
+	while (i--) {
+		kfree(c->jheads[i].wbuf.buf);
+		kfree(c->jheads[i].wbuf.inodes);
 		kfree(c->jheads[i].log_hash);
+	}
+	kfree(c->jheads);
+	c->jheads = NULL;
 
 	return err;
 }
diff --git a/fs/ubifs/tnc.c b/fs/ubifs/tnc.c
index 33742ee3945b..6461f61449b1 100644
--- a/fs/ubifs/tnc.c
+++ b/fs/ubifs/tnc.c
@@ -267,11 +267,18 @@ static struct ubifs_znode *dirty_cow_znode(struct ubifs_info *c,
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
@@ -3054,6 +3061,21 @@ static void tnc_destroy_cnext(struct ubifs_info *c)
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
 
diff --git a/fs/ubifs/ubifs.h b/fs/ubifs/ubifs.h
index b3b7e3576e98..85e84138649b 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1593,8 +1593,13 @@ static inline int ubifs_check_hmac(const struct ubifs_info *c,
 	return crypto_memneq(expected, got, c->hmac_desc_len);
 }
 
+#ifdef CONFIG_UBIFS_FS_AUTHENTICATION
 void ubifs_bad_hash(const struct ubifs_info *c, const void *node,
 		    const u8 *hash, int lnum, int offs);
+#else
+static inline void ubifs_bad_hash(const struct ubifs_info *c, const void *node,
+				  const u8 *hash, int lnum, int offs) {};
+#endif
 
 int __ubifs_node_check_hash(const struct ubifs_info *c, const void *buf,
 			  const u8 *expected);
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 628941a6b79a..3b3729771915 100644
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
index 37a6bbd5a19c..6b3531f55ee8 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -528,8 +528,10 @@ static int udf_do_extend_file(struct inode *inode,
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
@@ -563,7 +565,7 @@ static int udf_do_extend_file(struct inode *inode,
 		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
-			return err;
+			goto out_err;
 		count++;
 	}
 	if (new_block_bytes) {
@@ -572,7 +574,7 @@ static int udf_do_extend_file(struct inode *inode,
 		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
-			return err;
+			goto out_err;
 		count++;
 	}
 
@@ -586,6 +588,11 @@ static int udf_do_extend_file(struct inode *inode,
 		return -EIO;
 
 	return count;
+out_err:
+	/* Remove extents we've created so far */
+	udf_clear_extent_cache(inode);
+	udf_truncate_extents(inode);
+	return err;
 }
 
 /* Extend the final block of the file to final_block_len bytes */
@@ -800,19 +807,17 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
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
@@ -1089,23 +1094,8 @@ static void udf_merge_extents(struct inode *inode, struct kernel_long_ad *laarr,
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
@@ -1396,6 +1386,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		ret = -EIO;
 		goto out;
 	}
+	iinfo->i_hidden = hidden_inode;
 	iinfo->i_unique = 0;
 	iinfo->i_lenEAttr = 0;
 	iinfo->i_lenExtents = 0;
@@ -1731,8 +1722,12 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 
 	if (S_ISDIR(inode->i_mode) && inode->i_nlink > 0)
 		fe->fileLinkCount = cpu_to_le16(inode->i_nlink - 1);
-	else
-		fe->fileLinkCount = cpu_to_le16(inode->i_nlink);
+	else {
+		if (iinfo->i_hidden)
+			fe->fileLinkCount = cpu_to_le16(0);
+		else
+			fe->fileLinkCount = cpu_to_le16(inode->i_nlink);
+	}
 
 	fe->informationLength = cpu_to_le64(inode->i_size);
 
@@ -1903,8 +1898,13 @@ struct inode *__udf_iget(struct super_block *sb, struct kernel_lb_addr *ino,
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 
-	if (!(inode->i_state & I_NEW))
+	if (!(inode->i_state & I_NEW)) {
+		if (UDF_I(inode)->i_hidden != hidden_inode) {
+			iput(inode);
+			return ERR_PTR(-EFSCORRUPTED);
+		}
 		return inode;
+	}
 
 	memcpy(&UDF_I(inode)->i_location, ino, sizeof(struct kernel_lb_addr));
 	err = udf_read_inode(inode, hidden_inode);
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 5193b94c0683..0f8b3cb35585 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -147,6 +147,7 @@ static struct inode *udf_alloc_inode(struct super_block *sb)
 	ei->i_next_alloc_goal = 0;
 	ei->i_strat4096 = 0;
 	ei->i_streamdir = 0;
+	ei->i_hidden = 0;
 	init_rwsem(&ei->i_data_sem);
 	ei->cached_extent.lstart = -1;
 	spin_lock_init(&ei->i_extent_cache_lock);
diff --git a/fs/udf/udf_i.h b/fs/udf/udf_i.h
index 4245d1f63258..0372d0d14f72 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -44,7 +44,8 @@ struct udf_inode_info {
 	unsigned		i_use : 1;	/* unallocSpaceEntry */
 	unsigned		i_strat4096 : 1;
 	unsigned		i_streamdir : 1;
-	unsigned		reserved : 25;
+	unsigned		i_hidden : 1;	/* hidden system inode */
+	unsigned		reserved : 24;
 	union {
 		struct short_ad	*i_sad;
 		struct long_ad		*i_lad;
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 8eace7a633d3..d91cbfb08983 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -51,6 +51,8 @@
 #define MF_DUPLICATE_MD		0x01
 #define MF_MIRROR_FE_LOADED	0x02
 
+#define EFSCORRUPTED EUCLEAN
+
 struct udf_meta_data {
 	__u32	s_meta_file_loc;
 	__u32	s_mirror_file_loc;
diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
index 7616f6562fe4..9f7192366cfb 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -254,9 +254,10 @@ struct drm_bridge_funcs {
 	 * there is one) when this callback is called.
 	 *
 	 * Note that this function will only be invoked in the context of an
-	 * atomic commit. It will not be invoked from &drm_bridge_pre_enable. It
-	 * would be prudent to also provide an implementation of @pre_enable if
-	 * you are expecting driver calls into &drm_bridge_pre_enable.
+	 * atomic commit. It will not be invoked from
+	 * &drm_bridge_chain_pre_enable. It would be prudent to also provide an
+	 * implementation of @pre_enable if you are expecting driver calls into
+	 * &drm_bridge_chain_pre_enable.
 	 *
 	 * The @atomic_pre_enable callback is optional.
 	 */
@@ -279,9 +280,9 @@ struct drm_bridge_funcs {
 	 * chain if there is one.
 	 *
 	 * Note that this function will only be invoked in the context of an
-	 * atomic commit. It will not be invoked from &drm_bridge_enable. It
-	 * would be prudent to also provide an implementation of @enable if
-	 * you are expecting driver calls into &drm_bridge_enable.
+	 * atomic commit. It will not be invoked from &drm_bridge_chain_enable.
+	 * It would be prudent to also provide an implementation of @enable if
+	 * you are expecting driver calls into &drm_bridge_chain_enable.
 	 *
 	 * The enable callback is optional.
 	 */
@@ -301,9 +302,10 @@ struct drm_bridge_funcs {
 	 * signals) feeding it is still running when this callback is called.
 	 *
 	 * Note that this function will only be invoked in the context of an
-	 * atomic commit. It will not be invoked from &drm_bridge_disable. It
-	 * would be prudent to also provide an implementation of @disable if
-	 * you are expecting driver calls into &drm_bridge_disable.
+	 * atomic commit. It will not be invoked from
+	 * &drm_bridge_chain_disable. It would be prudent to also provide an
+	 * implementation of @disable if you are expecting driver calls into
+	 * &drm_bridge_chain_disable.
 	 *
 	 * The disable callback is optional.
 	 */
@@ -325,10 +327,11 @@ struct drm_bridge_funcs {
 	 * called.
 	 *
 	 * Note that this function will only be invoked in the context of an
-	 * atomic commit. It will not be invoked from &drm_bridge_post_disable.
+	 * atomic commit. It will not be invoked from
+	 * &drm_bridge_chain_post_disable.
 	 * It would be prudent to also provide an implementation of
 	 * @post_disable if you are expecting driver calls into
-	 * &drm_bridge_post_disable.
+	 * &drm_bridge_chain_post_disable.
 	 *
 	 * The post_disable callback is optional.
 	 */
@@ -406,27 +409,41 @@ struct drm_bridge *of_drm_find_bridge(struct device_node *np);
 int drm_bridge_attach(struct drm_encoder *encoder, struct drm_bridge *bridge,
 		      struct drm_bridge *previous);
 
-bool drm_bridge_mode_fixup(struct drm_bridge *bridge,
-			   const struct drm_display_mode *mode,
-			   struct drm_display_mode *adjusted_mode);
-enum drm_mode_status drm_bridge_mode_valid(struct drm_bridge *bridge,
-					   const struct drm_display_mode *mode);
-void drm_bridge_disable(struct drm_bridge *bridge);
-void drm_bridge_post_disable(struct drm_bridge *bridge);
-void drm_bridge_mode_set(struct drm_bridge *bridge,
-			 const struct drm_display_mode *mode,
-			 const struct drm_display_mode *adjusted_mode);
-void drm_bridge_pre_enable(struct drm_bridge *bridge);
-void drm_bridge_enable(struct drm_bridge *bridge);
+/**
+ * drm_bridge_get_next_bridge() - Get the next bridge in the chain
+ * @bridge: bridge object
+ *
+ * RETURNS:
+ * the next bridge in the chain after @bridge, or NULL if @bridge is the last.
+ */
+static inline struct drm_bridge *
+drm_bridge_get_next_bridge(struct drm_bridge *bridge)
+{
+	return bridge->next;
+}
 
-void drm_atomic_bridge_disable(struct drm_bridge *bridge,
-			       struct drm_atomic_state *state);
-void drm_atomic_bridge_post_disable(struct drm_bridge *bridge,
+bool drm_bridge_chain_mode_fixup(struct drm_bridge *bridge,
+				 const struct drm_display_mode *mode,
+				 struct drm_display_mode *adjusted_mode);
+enum drm_mode_status
+drm_bridge_chain_mode_valid(struct drm_bridge *bridge,
+			    const struct drm_display_mode *mode);
+void drm_bridge_chain_disable(struct drm_bridge *bridge);
+void drm_bridge_chain_post_disable(struct drm_bridge *bridge);
+void drm_bridge_chain_mode_set(struct drm_bridge *bridge,
+			       const struct drm_display_mode *mode,
+			       const struct drm_display_mode *adjusted_mode);
+void drm_bridge_chain_pre_enable(struct drm_bridge *bridge);
+void drm_bridge_chain_enable(struct drm_bridge *bridge);
+
+void drm_atomic_bridge_chain_disable(struct drm_bridge *bridge,
+				     struct drm_atomic_state *state);
+void drm_atomic_bridge_chain_post_disable(struct drm_bridge *bridge,
+					  struct drm_atomic_state *state);
+void drm_atomic_bridge_chain_pre_enable(struct drm_bridge *bridge,
+					struct drm_atomic_state *state);
+void drm_atomic_bridge_chain_enable(struct drm_bridge *bridge,
 				    struct drm_atomic_state *state);
-void drm_atomic_bridge_pre_enable(struct drm_bridge *bridge,
-				  struct drm_atomic_state *state);
-void drm_atomic_bridge_enable(struct drm_bridge *bridge,
-			      struct drm_atomic_state *state);
 
 #ifdef CONFIG_DRM_PANEL_BRIDGE
 struct drm_bridge *drm_panel_bridge_add(struct drm_panel *panel,
diff --git a/include/drm/drm_crtc.h b/include/drm/drm_crtc.h
index 408b6f4e63c0..ebcce95f9da6 100644
--- a/include/drm/drm_crtc.h
+++ b/include/drm/drm_crtc.h
@@ -175,12 +175,25 @@ struct drm_crtc_state {
 	 * @no_vblank:
 	 *
 	 * Reflects the ability of a CRTC to send VBLANK events. This state
-	 * usually depends on the pipeline configuration, and the main usuage
-	 * is CRTCs feeding a writeback connector operating in oneshot mode.
-	 * In this case the VBLANK event is only generated when a job is queued
-	 * to the writeback connector, and we want the core to fake VBLANK
-	 * events when this part of the pipeline hasn't changed but others had
-	 * or when the CRTC and connectors are being disabled.
+	 * usually depends on the pipeline configuration. If set to true, DRM
+	 * atomic helpers will send out a fake VBLANK event during display
+	 * updates after all hardware changes have been committed. This is
+	 * implemented in drm_atomic_helper_fake_vblank().
+	 *
+	 * One usage is for drivers and/or hardware without support for VBLANK
+	 * interrupts. Such drivers typically do not initialize vblanking
+	 * (i.e., call drm_vblank_init() with the number of CRTCs). For CRTCs
+	 * without initialized vblanking, this field is set to true in
+	 * drm_atomic_helper_check_modeset(), and a fake VBLANK event will be
+	 * send out on each update of the display pipeline by
+	 * drm_atomic_helper_fake_vblank().
+	 *
+	 * Another usage is CRTCs feeding a writeback connector operating in
+	 * oneshot mode. In this case the fake VBLANK event is only generated
+	 * when a job is queued to the writeback connector, and we want the
+	 * core to fake VBLANK events when this part of the pipeline hasn't
+	 * changed but others had or when the CRTC and connectors are being
+	 * disabled.
 	 *
 	 * __drm_atomic_helper_crtc_duplicate_state() will not reset the value
 	 * from the current state, the CRTC driver is then responsible for
@@ -336,7 +349,14 @@ struct drm_crtc_state {
 	 *  - Events for disabled CRTCs are not allowed, and drivers can ignore
 	 *    that case.
 	 *
-	 * This can be handled by the drm_crtc_send_vblank_event() function,
+	 * For very simple hardware without VBLANK interrupt, enabling
+	 * &struct drm_crtc_state.no_vblank makes DRM's atomic commit helpers
+	 * send a fake VBLANK event at the end of the display update after all
+	 * hardware changes have been applied. See
+	 * drm_atomic_helper_fake_vblank().
+	 *
+	 * For more complex hardware this
+	 * can be handled by the drm_crtc_send_vblank_event() function,
 	 * which the driver should call on the provided event upon completion of
 	 * the atomic commit. Note that if the driver supports vblank signalling
 	 * and timestamping the vblank counters and timestamps must agree with
diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
index 13cf2ae59f6c..3057511c88e6 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -279,6 +279,10 @@ int mipi_dsi_dcs_set_display_brightness(struct mipi_dsi_device *dsi,
 					u16 brightness);
 int mipi_dsi_dcs_get_display_brightness(struct mipi_dsi_device *dsi,
 					u16 *brightness);
+int mipi_dsi_dcs_set_display_brightness_large(struct mipi_dsi_device *dsi,
+					     u16 brightness);
+int mipi_dsi_dcs_get_display_brightness_large(struct mipi_dsi_device *dsi,
+					     u16 *brightness);
 
 /**
  * struct mipi_dsi_driver - DSI driver
diff --git a/include/drm/drm_simple_kms_helper.h b/include/drm/drm_simple_kms_helper.h
index 4d89cd0a60db..df615eb92b09 100644
--- a/include/drm/drm_simple_kms_helper.h
+++ b/include/drm/drm_simple_kms_helper.h
@@ -100,8 +100,11 @@ struct drm_simple_display_pipe_funcs {
 	 * This is the function drivers should submit the
 	 * &drm_pending_vblank_event from. Using either
 	 * drm_crtc_arm_vblank_event(), when the driver supports vblank
-	 * interrupt handling, or drm_crtc_send_vblank_event() directly in case
-	 * the hardware lacks vblank support entirely.
+	 * interrupt handling, or drm_crtc_send_vblank_event() for more
+	 * complex case. In case the hardware lacks vblank support entirely,
+	 * drivers can set &struct drm_crtc_state.no_vblank in
+	 * &struct drm_simple_display_pipe_funcs.check and let DRM's
+	 * atomic helper fake a vblank event.
 	 */
 	void (*update)(struct drm_simple_display_pipe *pipe,
 		       struct drm_plane_state *old_plane_state);
diff --git a/include/drm/drm_vblank.h b/include/drm/drm_vblank.h
index 9fe4ba8bc622..2559fb921869 100644
--- a/include/drm/drm_vblank.h
+++ b/include/drm/drm_vblank.h
@@ -195,6 +195,7 @@ struct drm_vblank_crtc {
 };
 
 int drm_vblank_init(struct drm_device *dev, unsigned int num_crtcs);
+bool drm_dev_has_vblank(const struct drm_device *dev);
 u64 drm_crtc_vblank_count(struct drm_crtc *crtc);
 u64 drm_crtc_vblank_count_and_time(struct drm_crtc *crtc,
 				   ktime_t *vblanktime);
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 1c37f17f7203..5d52478c22c4 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -17,7 +17,8 @@ extern int ima_bprm_check(struct linux_binprm *bprm);
 extern int ima_file_check(struct file *file, int mask);
 extern void ima_post_create_tmpfile(struct inode *inode);
 extern void ima_file_free(struct file *file);
-extern int ima_file_mmap(struct file *file, unsigned long prot);
+extern int ima_file_mmap(struct file *file, unsigned long reqprot,
+			 unsigned long prot, unsigned long flags);
 extern int ima_load_data(enum kernel_load_data_id id);
 extern int ima_read_file(struct file *file, enum kernel_read_file_id id);
 extern int ima_post_read_file(struct file *file, void *buf, loff_t size,
@@ -64,7 +65,8 @@ static inline void ima_file_free(struct file *file)
 	return;
 }
 
-static inline int ima_file_mmap(struct file *file, unsigned long prot)
+static inline int ima_file_mmap(struct file *file, unsigned long reqprot,
+				unsigned long prot, unsigned long flags)
 {
 	return 0;
 }
diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
index 89fc59dab57d..30e92536c78c 100644
--- a/include/linux/interrupt.h
+++ b/include/linux/interrupt.h
@@ -598,12 +598,17 @@ struct tasklet_struct
 	unsigned long data;
 };
 
-#define DECLARE_TASKLET(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
-
-#define DECLARE_TASKLET_DISABLED(name, func, data) \
-struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(1), func, data }
+#define DECLARE_TASKLET_OLD(name, _func)		\
+struct tasklet_struct name = {				\
+	.count = ATOMIC_INIT(0),			\
+	.func = _func,					\
+}
 
+#define DECLARE_TASKLET_DISABLED_OLD(name, _func)	\
+struct tasklet_struct name = {				\
+	.count = ATOMIC_INIT(1),			\
+	.func = _func,					\
+}
 
 enum
 {
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
index c7764d9e6f39..0be024dffa0c 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -318,6 +318,8 @@ extern int proc_kprobes_optimization_handler(struct ctl_table *table,
 					     size_t *length, loff_t *ppos);
 #endif
 extern void wait_for_kprobe_optimizer(void);
+bool optprobe_queued_unopt(struct optimized_kprobe *op);
+bool kprobe_disarmed(struct kprobe *p);
 #else
 static inline void wait_for_kprobe_optimizer(void) { }
 #endif /* CONFIG_OPTPROBES */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 526d423740eb..a31aa3ac4219 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3024,6 +3024,8 @@
 #define PCI_DEVICE_ID_INTEL_VMD_9A0B	0x9a0b
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
 
+#define PCI_VENDOR_ID_WANGXUN		0x8088
+
 #define PCI_VENDOR_ID_SCALEMP		0x8686
 #define PCI_DEVICE_ID_SCALEMP_VSMP_CTL	0x1010
 
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 38555435a64a..70941f49d66e 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -287,6 +287,10 @@ copy_struct_from_user(void *dst, size_t ksize, const void __user *src,
 	size_t size = min(ksize, usize);
 	size_t rest = max(ksize, usize) - size;
 
+	/* Double check if ksize is larger than a known object size. */
+	if (WARN_ON_ONCE(ksize > __builtin_object_size(dst, 1)))
+		return -E2BIG;
+
 	/* Deal with trailing bytes. */
 	if (usize < ksize) {
 		memset(dst + size, 0, rest);
diff --git a/include/net/sctp/structs.h b/include/net/sctp/structs.h
index cb05e503c9cd..48cbf3352042 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1400,6 +1400,7 @@ struct sctp_stream_priorities {
 	/* The next stream stream in line */
 	struct sctp_stream_out_ext *next;
 	__u16 prio;
+	__u16 users;
 };
 
 struct sctp_stream_out_ext {
diff --git a/include/net/sock.h b/include/net/sock.h
index 976433438c6f..26dd07e47a7c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1706,7 +1706,12 @@ void sk_common_release(struct sock *sk);
  *	Default socket callbacks and setup code
  */
 
-/* Initialise core socket variables */
+/* Initialise core socket variables using an explicit uid. */
+void sock_init_data_uid(struct socket *sock, struct sock *sk, kuid_t uid);
+
+/* Initialise core socket variables.
+ * Assumes struct socket *sock is embedded in a struct socket_alloc.
+ */
 void sock_init_data(struct socket *sock, struct sock *sk);
 
 /*
@@ -2185,6 +2190,8 @@ void sk_reset_timer(struct sock *sk, struct timer_list *timer,
 
 void sk_stop_timer(struct sock *sk, struct timer_list *timer);
 
+void sk_stop_timer_sync(struct sock *sk, struct timer_list *timer);
+
 int __sk_queue_drop_skb(struct sock *sk, struct sk_buff_head *sk_queue,
 			struct sk_buff *skb, unsigned int flags,
 			void (*destructor)(struct sock *sk,
diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index 6e8a31225383..659400d40873 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -16,6 +16,9 @@
 #include <sound/asoc.h>
 
 struct device;
+struct snd_pcm_substream;
+struct snd_soc_pcm_runtime;
+struct soc_enum;
 
 /* widget has no PM register bit */
 #define SND_SOC_NOPM	-1
diff --git a/include/uapi/linux/usb/video.h b/include/uapi/linux/usb/video.h
index bfdae12cdacf..c58854fb7d94 100644
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
diff --git a/include/uapi/linux/uvcvideo.h b/include/uapi/linux/uvcvideo.h
index f80f05b3c423..214092366193 100644
--- a/include/uapi/linux/uvcvideo.h
+++ b/include/uapi/linux/uvcvideo.h
@@ -86,7 +86,7 @@ struct uvc_xu_control_query {
  * struct. The first two fields are added by the driver, they can be used for
  * clock synchronisation. The rest is an exact copy of a UVC payload header.
  * Only complete objects with complete buffers are included. Therefore it's
- * always sizeof(meta->ts) + sizeof(meta->sof) + meta->length bytes large.
+ * always sizeof(meta->ns) + sizeof(meta->sof) + meta->length bytes large.
  */
 struct uvc_meta_buf {
 	__u64 ns;
diff --git a/kernel/backtracetest.c b/kernel/backtracetest.c
index a2a97fa3071b..370217dd7e39 100644
--- a/kernel/backtracetest.c
+++ b/kernel/backtracetest.c
@@ -29,7 +29,7 @@ static void backtrace_test_irq_callback(unsigned long data)
 	complete(&backtrace_work);
 }
 
-static DECLARE_TASKLET(backtrace_tasklet, &backtrace_test_irq_callback, 0);
+static DECLARE_TASKLET_OLD(backtrace_tasklet, &backtrace_test_irq_callback);
 
 static void backtrace_test_irq(void)
 {
diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
index 565987557ad8..f88611fadb19 100644
--- a/kernel/debug/debug_core.c
+++ b/kernel/debug/debug_core.c
@@ -1043,7 +1043,7 @@ static void kgdb_tasklet_bpt(unsigned long ing)
 	atomic_set(&kgdb_break_tasklet_var, 0);
 }
 
-static DECLARE_TASKLET(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt, 0);
+static DECLARE_TASKLET_OLD(kgdb_tasklet_breakpoint, kgdb_tasklet_bpt);
 
 void kgdb_schedule_breakpoint(void)
 {
diff --git a/kernel/fail_function.c b/kernel/fail_function.c
index b0b1ad93fa95..8f3795d8ac5b 100644
--- a/kernel/fail_function.c
+++ b/kernel/fail_function.c
@@ -163,10 +163,7 @@ static void fei_debugfs_add_attr(struct fei_attr *attr)
 
 static void fei_debugfs_remove_attr(struct fei_attr *attr)
 {
-	struct dentry *dir;
-
-	dir = debugfs_lookup(attr->kp.symbol_name, fei_debugfs_dir);
-	debugfs_remove_recursive(dir);
+	debugfs_lookup_and_remove(attr->kp.symbol_name, fei_debugfs_dir);
 }
 
 static int fei_kprobe_handler(struct kprobe *kp, struct pt_regs *regs)
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index 5e03cbee70d6..3d1b570a1dad 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -509,6 +509,9 @@ void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 		return;
 
 	hwirq = irq_data->hwirq;
+
+	mutex_lock(&irq_domain_mutex);
+
 	irq_set_status_flags(irq, IRQ_NOREQUEST);
 
 	/* remove chip and handler */
@@ -528,10 +531,12 @@ void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 
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
@@ -544,7 +549,6 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 	if (WARN(irq_data->domain, "error: virq%i is already associated", virq))
 		return -EINVAL;
 
-	mutex_lock(&irq_domain_mutex);
 	irq_data->hwirq = hwirq;
 	irq_data->domain = domain;
 	if (domain->ops->map) {
@@ -561,7 +565,6 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 			}
 			irq_data->domain = NULL;
 			irq_data->hwirq = 0;
-			mutex_unlock(&irq_domain_mutex);
 			return ret;
 		}
 
@@ -572,12 +575,23 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 
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
@@ -837,13 +851,8 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
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
diff --git a/kernel/irq/resend.c b/kernel/irq/resend.c
index 98c04ca5fa43..b7af39e36341 100644
--- a/kernel/irq/resend.c
+++ b/kernel/irq/resend.c
@@ -45,7 +45,7 @@ static void resend_irqs(unsigned long arg)
 }
 
 /* Tasklet to handle resend: */
-static DECLARE_TASKLET(resend_tasklet, resend_irqs, 0);
+static DECLARE_TASKLET_OLD(resend_tasklet, resend_irqs);
 
 #endif
 
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 3de56ca28017..aecf4342f67c 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -406,8 +406,8 @@ static inline int kprobe_optready(struct kprobe *p)
 	return 0;
 }
 
-/* Return true(!0) if the kprobe is disarmed. Note: p must be on hash list */
-static inline int kprobe_disarmed(struct kprobe *p)
+/* Return true if the kprobe is disarmed. Note: p must be on hash list */
+bool kprobe_disarmed(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -614,7 +614,7 @@ void wait_for_kprobe_optimizer(void)
 	mutex_unlock(&kprobe_mutex);
 }
 
-static bool optprobe_queued_unopt(struct optimized_kprobe *op)
+bool optprobe_queued_unopt(struct optimized_kprobe *op)
 {
 	struct optimized_kprobe *_op;
 
diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index 173e3ce60790..eca3df7f041c 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -523,7 +523,9 @@ static void synchronize_sched_expedited_wait(void)
 				mask = leaf_node_cpu_bit(rnp, cpu);
 				if (!(READ_ONCE(rnp->expmask) & mask))
 					continue;
+				preempt_disable(); // For smp_processor_id() in dump_cpu_task().
 				dump_cpu_task(cpu);
+				preempt_enable();
 			}
 		}
 		jiffies_stall = 3 * rcu_jiffies_till_stall_check() + 3;
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index d8052c2d87e4..ba3d7c223999 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1793,8 +1793,7 @@ static void set_next_task_dl(struct rq *rq, struct task_struct *p, bool first)
 	deadline_queue_push_tasks(rq);
 }
 
-static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
-						   struct dl_rq *dl_rq)
+static struct sched_dl_entity *pick_next_dl_entity(struct dl_rq *dl_rq)
 {
 	struct rb_node *left = rb_first_cached(&dl_rq->root);
 
@@ -1816,7 +1815,7 @@ pick_next_task_dl(struct rq *rq, struct task_struct *prev, struct rq_flags *rf)
 	if (!sched_dl_runnable(rq))
 		return NULL;
 
-	dl_se = pick_next_dl_entity(rq, dl_rq);
+	dl_se = pick_next_dl_entity(dl_rq);
 	BUG_ON(!dl_se);
 	p = dl_task_of(dl_se);
 	set_next_task_dl(rq, p, true);
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index c11d3d79d4c3..186e7d78ded5 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1550,8 +1550,7 @@ static inline void set_next_task_rt(struct rq *rq, struct task_struct *p, bool f
 	rt_queue_push_tasks(rq);
 }
 
-static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
-						   struct rt_rq *rt_rq)
+static struct sched_rt_entity *pick_next_rt_entity(struct rt_rq *rt_rq)
 {
 	struct rt_prio_array *array = &rt_rq->active;
 	struct sched_rt_entity *next = NULL;
@@ -1562,6 +1561,8 @@ static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
 	BUG_ON(idx >= MAX_RT_PRIO);
 
 	queue = array->queue + idx;
+	if (SCHED_WARN_ON(list_empty(queue)))
+		return NULL;
 	next = list_entry(queue->next, struct sched_rt_entity, run_list);
 
 	return next;
@@ -1573,8 +1574,9 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	struct rt_rq *rt_rq  = &rq->rt;
 
 	do {
-		rt_se = pick_next_rt_entity(rq, rt_rq);
-		BUG_ON(!rt_se);
+		rt_se = pick_next_rt_entity(rt_rq);
+		if (unlikely(!rt_se))
+			return NULL;
 		rt_rq = group_rt_rq(rt_se);
 	} while (rt_rq);
 
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index e1e8d5dab0c5..8e3c9228aec9 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2020,6 +2020,7 @@ SYSCALL_DEFINE2(nanosleep, struct __kernel_timespec __user *, rqtp,
 	if (!timespec64_valid(&tu))
 		return -EINVAL;
 
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 	return hrtimer_nanosleep(&tu, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
@@ -2040,6 +2041,7 @@ SYSCALL_DEFINE2(nanosleep_time32, struct old_timespec32 __user *, rqtp,
 	if (!timespec64_valid(&tu))
 		return -EINVAL;
 
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
 	return hrtimer_nanosleep(&tu, HRTIMER_MODE_REL, CLOCK_MONOTONIC);
diff --git a/kernel/time/posix-stubs.c b/kernel/time/posix-stubs.c
index 67df65f887ac..8ddb35d9779c 100644
--- a/kernel/time/posix-stubs.c
+++ b/kernel/time/posix-stubs.c
@@ -142,6 +142,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 	return hrtimer_nanosleep(&t, flags & TIMER_ABSTIME ?
@@ -228,6 +229,7 @@ SYSCALL_DEFINE4(clock_nanosleep_time32, clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
 	return hrtimer_nanosleep(&t, flags & TIMER_ABSTIME ?
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 97d4a9dcf339..efe3873021a3 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1224,6 +1224,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 
@@ -1251,6 +1252,7 @@ SYSCALL_DEFINE4(clock_nanosleep_time32, clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 11e8189dd8ae..58809fffc817 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4769,11 +4769,16 @@ EXPORT_SYMBOL_GPL(ring_buffer_alloc_read_page);
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
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e50799d7002e..03b57323c53b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2912,6 +2912,9 @@ void deferred_split_huge_page(struct page *page)
 	if (PageSwapCache(page))
 		return;
 
+	if (!list_empty(page_deferred_list(page)))
+		return;
+
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (list_empty(page_deferred_list(page))) {
 		count_vm_event(THP_DEFERRED_SPLIT_PAGE);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 62861daf3589..16beae167d8c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3775,6 +3775,10 @@ static int mem_cgroup_move_charge_write(struct cgroup_subsys_state *css,
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
+	pr_warn_once("Cgroup memory moving (move_charge_at_immigrate) is deprecated. "
+		     "Please report your usecase to linux-mm@kvack.org if you "
+		     "depend on this functionality.\n");
+
 	if (val & ~MOVE_MASK)
 		return -EINVAL;
 
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index b21c3c209815..c00e965c082b 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -385,6 +385,7 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	struct p9_trans_rdma *rdma = client->trans;
 	struct ib_recv_wr wr;
 	struct ib_sge sge;
+	int ret;
 
 	c->busa = ib_dma_map_single(rdma->cm_id->device,
 				    c->rc.sdata, client->msize,
@@ -402,7 +403,12 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	wr.wr_cqe = &c->cqe;
 	wr.sg_list = &sge;
 	wr.num_sge = 1;
-	return ib_post_recv(rdma->qp, &wr, NULL);
+
+	ret = ib_post_recv(rdma->qp, &wr, NULL);
+	if (ret)
+		ib_dma_unmap_single(rdma->cm_id->device, c->busa,
+				    client->msize, DMA_FROM_DEVICE);
+	return ret;
 
  error:
 	p9_debug(P9_DEBUG_ERROR, "EIO\n");
@@ -499,7 +505,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 
 	if (down_interruptible(&rdma->sq_sem)) {
 		err = -EINTR;
-		goto send_error;
+		goto dma_unmap;
 	}
 
 	/* Mark request as `sent' *before* we actually send it,
@@ -509,11 +515,14 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 	req->status = REQ_STATUS_SENT;
 	err = ib_post_send(rdma->qp, &wr, NULL);
 	if (err)
-		goto send_error;
+		goto dma_unmap;
 
 	/* Success */
 	return 0;
 
+dma_unmap:
+	ib_dma_unmap_single(rdma->cm_id->device, c->busa,
+			    c->req->tc.size, DMA_TO_DEVICE);
  /* Handle errors that happened during or while preparing the send: */
  send_error:
 	req->status = REQ_STATUS_ERROR;
diff --git a/net/9p/trans_xen.c b/net/9p/trans_xen.c
index f043938ae782..67e9a7085e13 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -389,19 +389,24 @@ static int xen_9pfs_front_alloc_dataring(struct xenbus_device *dev,
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
@@ -414,11 +419,6 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
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
@@ -476,23 +476,35 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
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
 	dev_warn(&dev->dev, "suspend/resume unsupported\n");
@@ -511,6 +523,8 @@ static void xen_9pfs_front_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateInitWait:
+		if (!xen_9pfs_front_init(dev))
+			xenbus_switch_state(dev, XenbusStateInitialised);
 		break;
 
 	case XenbusStateConnected:
diff --git a/net/atm/pppoatm.c b/net/atm/pppoatm.c
index 45d8e1d5d033..579b66da1d95 100644
--- a/net/atm/pppoatm.c
+++ b/net/atm/pppoatm.c
@@ -393,7 +393,7 @@ static int pppoatm_assign_vcc(struct atm_vcc *atmvcc, void __user *arg)
 	 * Each PPPoATM instance has its own tasklet - this is just a
 	 * prototypical one used to initialize them
 	 */
-	static const DECLARE_TASKLET(tasklet_proto, pppoatm_wakeup_sender, 0);
+	static const DECLARE_TASKLET_OLD(tasklet_proto, pppoatm_wakeup_sender);
 	if (copy_from_user(&be, arg, sizeof be))
 		return -EFAULT;
 	if (be.encaps != PPPOATM_ENCAPS_AUTODETECT &&
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index befab857a39b..a5205dc95e8f 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -881,10 +881,6 @@ static int hci_sock_release(struct socket *sock)
 	}
 
 	sock_orphan(sk);
-
-	skb_queue_purge(&sk->sk_receive_queue);
-	skb_queue_purge(&sk->sk_write_queue);
-
 	release_sock(sk);
 	sock_put(sk);
 	return 0;
@@ -1985,6 +1981,12 @@ static int hci_sock_getsockopt(struct socket *sock, int level, int optname,
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
@@ -2035,6 +2037,7 @@ static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
 
 	sock->state = SS_UNCONNECTED;
 	sk->sk_state = BT_OPEN;
+	sk->sk_destruct = hci_sock_destruct;
 
 	bt_sock_link(&hci_sk_list, sk);
 	return 0;
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 0e51ed3412ef..4f286c76a50d 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2526,14 +2526,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
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
@@ -2577,14 +2569,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
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
@@ -2605,14 +2589,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
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
index 08e9f332adad..0fa5ced767a2 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1433,6 +1433,14 @@ static struct sk_buff *l2cap_sock_alloc_skb_cb(struct l2cap_chan *chan,
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
diff --git a/net/core/dev.c b/net/core/dev.c
index 615cdaac3e72..1a4e20c4ba05 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2735,8 +2735,10 @@ void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
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
 
diff --git a/net/core/sock.c b/net/core/sock.c
index a2b12a5cf42b..7f6f1a0bf8a1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2882,7 +2882,14 @@ void sk_stop_timer(struct sock *sk, struct timer_list* timer)
 }
 EXPORT_SYMBOL(sk_stop_timer);
 
-void sock_init_data(struct socket *sock, struct sock *sk)
+void sk_stop_timer_sync(struct sock *sk, struct timer_list *timer)
+{
+	if (del_timer_sync(timer))
+		__sock_put(sk);
+}
+EXPORT_SYMBOL(sk_stop_timer_sync);
+
+void sock_init_data_uid(struct socket *sock, struct sock *sk, kuid_t uid)
 {
 	sk_init_common(sk);
 	sk->sk_send_head	=	NULL;
@@ -2901,11 +2908,10 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 		sk->sk_type	=	sock->type;
 		RCU_INIT_POINTER(sk->sk_wq, &sock->wq);
 		sock->sk	=	sk;
-		sk->sk_uid	=	SOCK_INODE(sock)->i_uid;
 	} else {
 		RCU_INIT_POINTER(sk->sk_wq, NULL);
-		sk->sk_uid	=	make_kuid(sock_net(sk)->user_ns, 0);
 	}
+	sk->sk_uid	=	uid;
 
 	rwlock_init(&sk->sk_callback_lock);
 	if (sk->sk_kern_sock)
@@ -2963,6 +2969,16 @@ void sock_init_data(struct socket *sock, struct sock *sk)
 	refcount_set(&sk->sk_refcnt, 1);
 	atomic_set(&sk->sk_drops, 0);
 }
+EXPORT_SYMBOL(sock_init_data_uid);
+
+void sock_init_data(struct socket *sock, struct sock *sk)
+{
+	kuid_t uid = sock ?
+		SOCK_INODE(sock)->i_uid :
+		make_kuid(sock_net(sk)->user_ns, 0);
+
+	sock_init_data_uid(sock, sk, uid);
+}
 EXPORT_SYMBOL(sock_init_data);
 
 void lock_sock_nested(struct sock *sk, int subclass)
diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
index 9ef69c975b15..04593893e0c6 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -932,6 +932,7 @@ int inet_csk_listen_start(struct sock *sk, int backlog)
 	 * It is OK, because this socket enters to hash table only
 	 * after validation is complete.
 	 */
+	err = -EADDRINUSE;
 	inet_sk_state_store(sk, TCP_LISTEN);
 	if (!sk->sk_prot->get_port(sk, inet->inet_num)) {
 		inet->inet_sport = htons(inet->inet_num);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 33292983b8cf..9d14b3289f00 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -714,17 +714,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
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
index 324f43fadb37..e5dc08579cf5 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -563,6 +563,9 @@ EXPORT_SYMBOL(tcp_create_openreq_child);
  * validation and inside tcp_v4_reqsk_send_ack(). Can we do better?
  *
  * We don't need to initialize tmp_opt.sack_ok as we don't use the results
+ *
+ * Note: If @fastopen is true, this can be called from process context.
+ *       Otherwise, this is from BH context.
  */
 
 struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
@@ -715,7 +718,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 					  &tcp_rsk(req)->last_oow_ack_time))
 			req->rsk_ops->send_ack(sk, skb, req);
 		if (paws_reject)
-			__NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABREJECTED);
+			NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABREJECTED);
 		return NULL;
 	}
 
@@ -734,7 +737,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	 *	   "fourth, check the SYN bit"
 	 */
 	if (flg & (TCP_FLAG_RST|TCP_FLAG_SYN)) {
-		__TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
+		TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
 		goto embryonic_reset;
 	}
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index badfe6939638..209d52ebbd19 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5408,16 +5408,17 @@ static size_t rt6_nlmsg_size(struct fib6_info *f6i)
 		nexthop_for_each_fib6_nh(f6i->nh, rt6_nh_nlmsg_size,
 					 &nexthop_len);
 	} else {
+		struct fib6_info *sibling, *next_sibling;
 		struct fib6_nh *nh = f6i->fib6_nh;
 
 		nexthop_len = 0;
 		if (f6i->fib6_nsiblings) {
-			nexthop_len = nla_total_size(0)	 /* RTA_MULTIPATH */
-				    + NLA_ALIGN(sizeof(struct rtnexthop))
-				    + nla_total_size(16) /* RTA_GATEWAY */
-				    + lwtunnel_get_encap_size(nh->fib_nh_lws);
+			rt6_nh_nlmsg_size(nh, &nexthop_len);
 
-			nexthop_len *= f6i->fib6_nsiblings;
+			list_for_each_entry_safe(sibling, next_sibling,
+						 &f6i->fib6_siblings, fib6_siblings) {
+				rt6_nh_nlmsg_size(sibling->fib6_nh, &nexthop_len);
+			}
 		}
 		nexthop_len += lwtunnel_get_encap_size(nh->fib_nh_lws);
 	}
diff --git a/net/iucv/iucv.c b/net/iucv/iucv.c
index 9a2d023842fe..a4d1b5b7a154 100644
--- a/net/iucv/iucv.c
+++ b/net/iucv/iucv.c
@@ -128,7 +128,7 @@ static LIST_HEAD(iucv_task_queue);
  * The tasklet for fast delivery of iucv interrupts.
  */
 static void iucv_tasklet_fn(unsigned long);
-static DECLARE_TASKLET(iucv_tasklet, iucv_tasklet_fn,0);
+static DECLARE_TASKLET_OLD(iucv_tasklet, iucv_tasklet_fn);
 
 /*
  * Queue of interrupt buffers for delivery via a work queue
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 7b2e8c890381..4d6890250337 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2121,7 +2121,7 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u32 rate,
 
 static int sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 {
-	u16 rate = READ_ONCE(sta_get_last_rx_stats(sta)->last_rate);
+	u32 rate = READ_ONCE(sta_get_last_rx_stats(sta)->last_rate);
 
 	if (rate == STA_STATS_RATE_INVALID)
 		return -EINVAL;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index bc6f0c8874f8..4747daf901e7 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2086,12 +2086,15 @@ ctnetlink_create_conntrack(struct net *net,
 
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
index b53d5eb86864..c4c57830e963 100644
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
diff --git a/net/rds/message.c b/net/rds/message.c
index be6a0a073b12..75043742d243 100644
--- a/net/rds/message.c
+++ b/net/rds/message.c
@@ -118,7 +118,7 @@ static void rds_rm_zerocopy_callback(struct rds_sock *rs,
 	ck = &info->zcookies;
 	memset(ck, 0, sizeof(*ck));
 	WARN_ON(!rds_zcookie_add(info, cookie));
-	list_add_tail(&q->zcookie_head, &info->rs_zcookie_next);
+	list_add_tail(&info->rs_zcookie_next, &q->zcookie_head);
 
 	spin_unlock_irqrestore(&q->lock, flags);
 	/* caller invokes rds_wake_sk_sleep() */
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 2985509147a2..2e4604cdaf23 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -469,17 +469,6 @@ config NET_CLS_BASIC
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
index 415d1e1f237e..9e1f904d0c18 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -66,7 +66,6 @@ obj-$(CONFIG_NET_CLS_U32)	+= cls_u32.o
 obj-$(CONFIG_NET_CLS_ROUTE4)	+= cls_route.o
 obj-$(CONFIG_NET_CLS_FW)	+= cls_fw.o
 obj-$(CONFIG_NET_CLS_RSVP)	+= cls_rsvp.o
-obj-$(CONFIG_NET_CLS_TCINDEX)	+= cls_tcindex.o
 obj-$(CONFIG_NET_CLS_RSVP6)	+= cls_rsvp6.o
 obj-$(CONFIG_NET_CLS_BASIC)	+= cls_basic.o
 obj-$(CONFIG_NET_CLS_FLOW)	+= cls_flow.o
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 214f4efdd992..909a685b9162 100644
--- a/net/sched/act_sample.c
+++ b/net/sched/act_sample.c
@@ -54,8 +54,8 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 					  sample_policy, NULL);
 	if (ret < 0)
 		return ret;
-	if (!tb[TCA_SAMPLE_PARMS] || !tb[TCA_SAMPLE_RATE] ||
-	    !tb[TCA_SAMPLE_PSAMPLE_GROUP])
+
+	if (!tb[TCA_SAMPLE_PARMS])
 		return -EINVAL;
 
 	parm = nla_data(tb[TCA_SAMPLE_PARMS]);
@@ -79,6 +79,13 @@ static int tcf_sample_init(struct net *net, struct nlattr *nla,
 		tcf_idr_release(*a, bind);
 		return -EEXIST;
 	}
+
+	if (!tb[TCA_SAMPLE_RATE] || !tb[TCA_SAMPLE_PSAMPLE_GROUP]) {
+		NL_SET_ERR_MSG(extack, "sample rate and group are required");
+		err = -EINVAL;
+		goto release_idr;
+	}
+
 	err = tcf_action_check_ctrlact(parm->action, tp, &goto_ch, extack);
 	if (err < 0)
 		goto release_idr;
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
deleted file mode 100644
index 768cf7cf65b4..000000000000
--- a/net/sched/cls_tcindex.c
+++ /dev/null
@@ -1,730 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
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
-#include <linux/refcount.h>
-#include <net/act_api.h>
-#include <net/netlink.h>
-#include <net/pkt_cls.h>
-#include <net/sch_generic.h>
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
-struct tcindex_data;
-
-struct tcindex_filter_result {
-	struct tcf_exts		exts;
-	struct tcf_result	res;
-	struct tcindex_data	*p;
-	struct rcu_work		rwork;
-};
-
-struct tcindex_filter {
-	u16 key;
-	struct tcindex_filter_result result;
-	struct tcindex_filter __rcu *next;
-	struct rcu_work rwork;
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
-	refcount_t refcnt;	/* a temporary refcnt for perfect hash */
-	struct rcu_work rwork;
-};
-
-static inline int tcindex_filter_is_set(struct tcindex_filter_result *r)
-{
-	return tcf_exts_has_actions(&r->exts) || r->res.classid;
-}
-
-static void tcindex_data_get(struct tcindex_data *p)
-{
-	refcount_inc(&p->refcnt);
-}
-
-static void tcindex_data_put(struct tcindex_data *p)
-{
-	if (refcount_dec_and_test(&p->refcnt)) {
-		kfree(p->perfect);
-		kfree(p->h);
-		kfree(p);
-	}
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
-		struct Qdisc *q = tcf_block_q(tp->chain->block);
-
-		if (!p->fall_through)
-			return -1;
-		res->classid = TC_H_MAKE(TC_H_MAJ(q->handle), key);
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
-	refcount_set(&p->refcnt, 1); /* Paired with tcindex_destroy_work() */
-
-	rcu_assign_pointer(tp->root, p);
-	return 0;
-}
-
-static void __tcindex_destroy_rexts(struct tcindex_filter_result *r)
-{
-	tcf_exts_destroy(&r->exts);
-	tcf_exts_put_net(&r->exts);
-	tcindex_data_put(r->p);
-}
-
-static void tcindex_destroy_rexts_work(struct work_struct *work)
-{
-	struct tcindex_filter_result *r;
-
-	r = container_of(to_rcu_work(work),
-			 struct tcindex_filter_result,
-			 rwork);
-	rtnl_lock();
-	__tcindex_destroy_rexts(r);
-	rtnl_unlock();
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
-	struct tcindex_filter *f = container_of(to_rcu_work(work),
-						struct tcindex_filter,
-						rwork);
-
-	rtnl_lock();
-	__tcindex_destroy_fexts(f);
-	rtnl_unlock();
-}
-
-static int tcindex_delete(struct tcf_proto *tp, void *arg, bool *last,
-			  bool rtnl_held, struct netlink_ext_ack *extack)
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
-			tcf_queue_work(&f->rwork, tcindex_destroy_fexts_work);
-		else
-			__tcindex_destroy_fexts(f);
-	} else {
-		tcindex_data_get(p);
-
-		if (tcf_exts_get_net(&r->exts))
-			tcf_queue_work(&r->rwork, tcindex_destroy_rexts_work);
-		else
-			__tcindex_destroy_rexts(r);
-	}
-
-	*last = false;
-	return 0;
-}
-
-static void tcindex_destroy_work(struct work_struct *work)
-{
-	struct tcindex_data *p = container_of(to_rcu_work(work),
-					      struct tcindex_data,
-					      rwork);
-
-	tcindex_data_put(p);
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
-static int tcindex_filter_result_init(struct tcindex_filter_result *r,
-				      struct tcindex_data *p,
-				      struct net *net)
-{
-	memset(r, 0, sizeof(*r));
-	r->p = p;
-	return tcf_exts_init(&r->exts, net, TCA_TCINDEX_ACT,
-			     TCA_TCINDEX_POLICE);
-}
-
-static void tcindex_free_perfect_hash(struct tcindex_data *cp);
-
-static void tcindex_partial_destroy_work(struct work_struct *work)
-{
-	struct tcindex_data *p = container_of(to_rcu_work(work),
-					      struct tcindex_data,
-					      rwork);
-
-	rtnl_lock();
-	if (p->perfect)
-		tcindex_free_perfect_hash(p);
-	kfree(p);
-	rtnl_unlock();
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
-static int tcindex_alloc_perfect_hash(struct net *net, struct tcindex_data *cp)
-{
-	int i, err = 0;
-
-	cp->perfect = kcalloc(cp->hash, sizeof(struct tcindex_filter_result),
-			      GFP_KERNEL | __GFP_NOWARN);
-	if (!cp->perfect)
-		return -ENOMEM;
-
-	for (i = 0; i < cp->hash; i++) {
-		err = tcf_exts_init(&cp->perfect[i].exts, net,
-				    TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
-		if (err < 0)
-			goto errout;
-		cp->perfect[i].p = cp;
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
-		  struct nlattr *est, bool ovr, struct netlink_ext_ack *extack)
-{
-	struct tcindex_filter_result new_filter_result;
-	struct tcindex_data *cp = NULL, *oldp;
-	struct tcindex_filter *f = NULL; /* make gcc behave */
-	struct tcf_result cr = {};
-	int err, balloc = 0;
-	struct tcf_exts e;
-
-	err = tcf_exts_init(&e, net, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
-	if (err < 0)
-		return err;
-	err = tcf_exts_validate(net, tp, tb, est, &e, ovr, true, extack);
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
-	refcount_set(&cp->refcnt, 1); /* Paired with tcindex_destroy_work() */
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
-		if (tcindex_alloc_perfect_hash(net, cp) < 0)
-			goto errout;
-		cp->alloc_hash = cp->hash;
-		for (i = 0; i < min(cp->hash, p->hash); i++)
-			cp->perfect[i].res = p->perfect[i].res;
-		balloc = 1;
-	}
-	cp->h = p->h;
-
-	err = tcindex_filter_result_init(&new_filter_result, cp, net);
-	if (err < 0)
-		goto errout_alloc;
-	if (r)
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
-			if (tcindex_alloc_perfect_hash(net, cp) < 0)
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
-		err = tcindex_filter_result_init(&f->result, cp, net);
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
-		tcf_queue_work(&oldp->rwork, tcindex_partial_destroy_work);
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
-	       struct nlattr **tca, void **arg, bool ovr,
-	       bool rtnl_held, struct netlink_ext_ack *extack)
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
-	err = nla_parse_nested_deprecated(tb, TCA_TCINDEX_MAX, opt,
-					  tcindex_policy, NULL);
-	if (err < 0)
-		return err;
-
-	return tcindex_set_parms(net, tp, base, handle, p, r, tb,
-				 tca[TCA_RATE], ovr, extack);
-}
-
-static void tcindex_walk(struct tcf_proto *tp, struct tcf_walker *walker,
-			 bool rtnl_held)
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
-static void tcindex_destroy(struct tcf_proto *tp, bool rtnl_held,
-			    struct netlink_ext_ack *extack)
-{
-	struct tcindex_data *p = rtnl_dereference(tp->root);
-	int i;
-
-	pr_debug("tcindex_destroy(tp %p),p %p\n", tp, p);
-
-	if (p->perfect) {
-		for (i = 0; i < p->hash; i++) {
-			struct tcindex_filter_result *r = p->perfect + i;
-
-			/* tcf_queue_work() does not guarantee the ordering we
-			 * want, so we have to take this refcnt temporarily to
-			 * ensure 'p' is freed after all tcindex_filter_result
-			 * here. Imperfect hash does not need this, because it
-			 * uses linked lists rather than an array.
-			 */
-			tcindex_data_get(p);
-
-			tcf_unbind_filter(tp, &r->res);
-			if (tcf_exts_get_net(&r->exts))
-				tcf_queue_work(&r->rwork,
-					       tcindex_destroy_rexts_work);
-			else
-				__tcindex_destroy_rexts(r);
-		}
-	}
-
-	for (i = 0; p->h && i < p->hash; i++) {
-		struct tcindex_filter *f, *next;
-		bool last;
-
-		for (f = rtnl_dereference(p->h[i]); f; f = next) {
-			next = rtnl_dereference(f->next);
-			tcindex_delete(tp, &f->result, &last, rtnl_held, NULL);
-		}
-	}
-
-	tcf_queue_work(&p->rwork, tcindex_destroy_work);
-}
-
-
-static int tcindex_dump(struct net *net, struct tcf_proto *tp, void *fh,
-			struct sk_buff *skb, struct tcmsg *t, bool rtnl_held)
-{
-	struct tcindex_data *p = rtnl_dereference(tp->root);
-	struct tcindex_filter_result *r = fh;
-	struct nlattr *nest;
-
-	pr_debug("tcindex_dump(tp %p,fh %p,skb %p,t %p),p %p,r %p\n",
-		 tp, fh, skb, t, p, r);
-	pr_debug("p->perfect %p p->h %p\n", p->perfect, p->h);
-
-	nest = nla_nest_start_noflag(skb, TCA_OPTIONS);
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
-static void tcindex_bind_class(void *fh, u32 classid, unsigned long cl,
-			       void *q, unsigned long base)
-{
-	struct tcindex_filter_result *r = fh;
-
-	if (r && r->res.classid == classid) {
-		if (cl)
-			__tcf_bind_filter(q, &r->res, base);
-		else
-			__tcf_unbind_filter(q, &r->res);
-	}
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
diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
index 4fc9f2923ed1..7dd9f8b387cc 100644
--- a/net/sctp/stream_sched_prio.c
+++ b/net/sctp/stream_sched_prio.c
@@ -25,6 +25,18 @@
 
 static void sctp_sched_prio_unsched_all(struct sctp_stream *stream);
 
+static struct sctp_stream_priorities *sctp_sched_prio_head_get(struct sctp_stream_priorities *p)
+{
+	p->users++;
+	return p;
+}
+
+static void sctp_sched_prio_head_put(struct sctp_stream_priorities *p)
+{
+	if (p && --p->users == 0)
+		kfree(p);
+}
+
 static struct sctp_stream_priorities *sctp_sched_prio_new_head(
 			struct sctp_stream *stream, int prio, gfp_t gfp)
 {
@@ -38,6 +50,7 @@ static struct sctp_stream_priorities *sctp_sched_prio_new_head(
 	INIT_LIST_HEAD(&p->active);
 	p->next = NULL;
 	p->prio = prio;
+	p->users = 1;
 
 	return p;
 }
@@ -53,7 +66,7 @@ static struct sctp_stream_priorities *sctp_sched_prio_get_head(
 	 */
 	list_for_each_entry(p, &stream->prio_list, prio_sched) {
 		if (p->prio == prio)
-			return p;
+			return sctp_sched_prio_head_get(p);
 		if (p->prio > prio)
 			break;
 	}
@@ -70,7 +83,7 @@ static struct sctp_stream_priorities *sctp_sched_prio_get_head(
 			 */
 			break;
 		if (p->prio == prio)
-			return p;
+			return sctp_sched_prio_head_get(p);
 	}
 
 	/* If not even there, allocate a new one. */
@@ -154,32 +167,21 @@ static int sctp_sched_prio_set(struct sctp_stream *stream, __u16 sid,
 	struct sctp_stream_out_ext *soute = sout->ext;
 	struct sctp_stream_priorities *prio_head, *old;
 	bool reschedule = false;
-	int i;
+
+	old = soute->prio_head;
+	if (old && old->prio == prio)
+		return 0;
 
 	prio_head = sctp_sched_prio_get_head(stream, prio, gfp);
 	if (!prio_head)
 		return -ENOMEM;
 
 	reschedule = sctp_sched_prio_unsched(soute);
-	old = soute->prio_head;
 	soute->prio_head = prio_head;
 	if (reschedule)
 		sctp_sched_prio_sched(stream, soute);
 
-	if (!old)
-		/* Happens when we set the priority for the first time */
-		return 0;
-
-	for (i = 0; i < stream->outcnt; i++) {
-		soute = SCTP_SO(stream, i)->ext;
-		if (soute && soute->prio_head == old)
-			/* It's still in use, nothing else to do here. */
-			return 0;
-	}
-
-	/* No hits, we are good to free it. */
-	kfree(old);
-
+	sctp_sched_prio_head_put(old);
 	return 0;
 }
 
@@ -206,20 +208,8 @@ static int sctp_sched_prio_init_sid(struct sctp_stream *stream, __u16 sid,
 
 static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
 {
-	struct sctp_stream_priorities *prio = SCTP_SO(stream, sid)->ext->prio_head;
-	int i;
-
-	if (!prio)
-		return;
-
+	sctp_sched_prio_head_put(SCTP_SO(stream, sid)->ext->prio_head);
 	SCTP_SO(stream, sid)->ext->prio_head = NULL;
-	for (i = 0; i < stream->outcnt; i++) {
-		if (SCTP_SO(stream, i)->ext &&
-		    SCTP_SO(stream, i)->ext->prio_head == prio)
-			return;
-	}
-
-	kfree(prio);
 }
 
 static void sctp_sched_prio_free(struct sctp_stream *stream)
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index af3be9a29d6d..7614dec1e60c 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -945,7 +945,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 	if (msg->msg_flags & ~(MSG_MORE | MSG_DONTWAIT | MSG_NOSIGNAL))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 
 	if (unlikely(msg->msg_controllen)) {
@@ -1279,7 +1281,9 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 	ret = tls_sw_do_sendpage(sk, page, offset, size, flags);
 	release_sock(sk);
@@ -2263,11 +2267,19 @@ static void tx_work_handler(struct work_struct *work)
 
 	if (!test_and_clear_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask))
 		return;
-	mutex_lock(&tls_ctx->tx_lock);
-	lock_sock(sk);
-	tls_tx_records(sk, -1);
-	release_sock(sk);
-	mutex_unlock(&tls_ctx->tx_lock);
+
+	if (mutex_trylock(&tls_ctx->tx_lock)) {
+		lock_sock(sk);
+		tls_tx_records(sk, -1);
+		release_sock(sk);
+		mutex_unlock(&tls_ctx->tx_lock);
+	} else if (!test_and_set_bit(BIT_TX_SCHEDULED, &ctx->tx_bitmask)) {
+		/* Someone is holding the tx_lock, they will likely run Tx
+		 * and cancel the work on their way out of the lock section.
+		 * Schedule a long delay just in case.
+		 */
+		schedule_delayed_work(&ctx->tx_work.work, msecs_to_jiffies(10));
+	}
 }
 
 void tls_sw_write_space(struct sock *sk, struct tls_context *ctx)
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 63f89687a018..89b81d4c1095 100644
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
@@ -1233,6 +1245,15 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
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
index ce9d594ddbcd..6a2377eee03d 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -370,7 +370,9 @@ static int process_measurement(struct file *file, const struct cred *cred,
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
@@ -378,7 +380,8 @@ static int process_measurement(struct file *file, const struct cred *cred,
  * On success return 0.  On integrity appraisal error, assuming the file
  * is in policy and IMA-appraisal is in enforcing mode, return -EACCES.
  */
-int ima_file_mmap(struct file *file, unsigned long prot)
+int ima_file_mmap(struct file *file, unsigned long reqprot,
+		  unsigned long prot, unsigned long flags)
 {
 	u32 secid;
 
diff --git a/security/security.c b/security/security.c
index f633717311a3..460c3826f640 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1458,12 +1458,13 @@ static inline unsigned long mmap_prot(struct file *file, unsigned long prot)
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
diff --git a/sound/drivers/pcsp/pcsp_lib.c b/sound/drivers/pcsp/pcsp_lib.c
index 8f0f05bbc081..ce5bab7425d5 100644
--- a/sound/drivers/pcsp/pcsp_lib.c
+++ b/sound/drivers/pcsp/pcsp_lib.c
@@ -36,7 +36,7 @@ static void pcsp_call_pcm_elapsed(unsigned long priv)
 	}
 }
 
-static DECLARE_TASKLET(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed, 0);
+static DECLARE_TASKLET_OLD(pcsp_pcm_tasklet, pcsp_call_pcm_elapsed);
 
 /* write the port and returns the next expire time in ns;
  * called at the trigger-start and in hrtimer callback
diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 3ef1084b6688..574c39120df8 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -2047,7 +2047,7 @@ static int dspio_set_uint_param_no_source(struct hda_codec *codec, int mod_id,
 static int dspio_alloc_dma_chan(struct hda_codec *codec, unsigned int *dma_chan)
 {
 	int status = 0;
-	unsigned int size = sizeof(dma_chan);
+	unsigned int size = sizeof(*dma_chan);
 
 	codec_dbg(codec, "     dspio_alloc_dma_chan() -- begin\n");
 	status = dspio_scp(codec, MASTERCONTROL, 0x20,
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 75c1645dd5c1..13238cf7aa52 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10339,6 +10339,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0698, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x069f, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
+	SND_PCI_QUIRK(0x103c, 0x870c, "HP", ALC897_FIXUP_HP_HSMIC_VERB),
 	SND_PCI_QUIRK(0x103c, 0x8719, "HP", ALC897_FIXUP_HP_HSMIC_VERB),
 	SND_PCI_QUIRK(0x103c, 0x873e, "HP", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x103c, 0x877e, "HP 288 Pro G6", ALC671_FIXUP_HP_HEADSET_MIC2),
diff --git a/sound/pci/ice1712/aureon.c b/sound/pci/ice1712/aureon.c
index 4556ba76b791..71752618a7af 100644
--- a/sound/pci/ice1712/aureon.c
+++ b/sound/pci/ice1712/aureon.c
@@ -1892,6 +1892,7 @@ static int aureon_add_controls(struct snd_ice1712 *ice)
 		unsigned char id;
 		snd_ice1712_save_gpio_status(ice);
 		id = aureon_cs8415_get(ice, CS8415_ID);
+		snd_ice1712_restore_gpio_status(ice);
 		if (id != 0x41)
 			dev_info(ice->card->dev,
 				 "No CS8415 chip. Skipping CS8415 controls.\n");
@@ -1909,7 +1910,6 @@ static int aureon_add_controls(struct snd_ice1712 *ice)
 					kctl->id.device = ice->pcm->device;
 			}
 		}
-		snd_ice1712_restore_gpio_status(ice);
 	}
 
 	return 0;
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 027259695551..f8445231ad78 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -212,6 +212,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 	if (!sai->is_lsb_first)
 		val_cr4 |= FSL_SAI_CR4_MF;
 
+	sai->is_dsp_mode = false;
 	/* DAI mode */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
diff --git a/sound/soc/kirkwood/kirkwood-dma.c b/sound/soc/kirkwood/kirkwood-dma.c
index d2d5c25bf550..0215d187bdff 100644
--- a/sound/soc/kirkwood/kirkwood-dma.c
+++ b/sound/soc/kirkwood/kirkwood-dma.c
@@ -86,7 +86,7 @@ kirkwood_dma_conf_mbus_windows(void __iomem *base, int win,
 
 	/* try to find matching cs for current dma address */
 	for (i = 0; i < dram->num_cs; i++) {
-		const struct mbus_dram_window *cs = dram->cs + i;
+		const struct mbus_dram_window *cs = &dram->cs[i];
 		if ((cs->base & 0xffff0000) < (dma & 0xffff0000)) {
 			writel(cs->base & 0xffff0000,
 				base + KIRKWOOD_AUDIO_WIN_BASE_REG(win));
diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
index da6e40aef7b6..1e37bb7436ec 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -927,7 +927,7 @@ int snd_soc_new_compress(struct snd_soc_pcm_runtime *rtd, int num)
 		rtd->fe_compr = 1;
 		if (rtd->dai_link->dpcm_playback)
 			be_pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream->private_data = rtd;
-		else if (rtd->dai_link->dpcm_capture)
+		if (rtd->dai_link->dpcm_capture)
 			be_pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream->private_data = rtd;
 		memcpy(compr->ops, &soc_compr_dyn_ops, sizeof(soc_compr_dyn_ops));
 	} else {
diff --git a/tools/iio/iio_utils.c b/tools/iio/iio_utils.c
index d66b18c54606..48360994c2a1 100644
--- a/tools/iio/iio_utils.c
+++ b/tools/iio/iio_utils.c
@@ -262,6 +262,7 @@ int iioutils_get_param_float(float *output, const char *param_name,
 			if (fscanf(sysfsfp, "%f", output) != 1)
 				ret = errno ? -errno : -ENODATA;
 
+			fclose(sysfsfp);
 			break;
 		}
 error_free_filename:
@@ -342,9 +343,9 @@ int build_channel_array(const char *device_dir,
 			}
 
 			sysfsfp = fopen(filename, "r");
+			free(filename);
 			if (!sysfsfp) {
 				ret = -errno;
-				free(filename);
 				goto error_close_dir;
 			}
 
@@ -354,7 +355,6 @@ int build_channel_array(const char *device_dir,
 				if (fclose(sysfsfp))
 					perror("build_channel_array(): Failed to close file");
 
-				free(filename);
 				goto error_close_dir;
 			}
 			if (ret == 1)
@@ -362,11 +362,9 @@ int build_channel_array(const char *device_dir,
 
 			if (fclose(sysfsfp)) {
 				ret = -errno;
-				free(filename);
 				goto error_close_dir;
 			}
 
-			free(filename);
 		}
 
 	*ci_array = malloc(sizeof(**ci_array) * (*counter));
@@ -392,9 +390,9 @@ int build_channel_array(const char *device_dir,
 			}
 
 			sysfsfp = fopen(filename, "r");
+			free(filename);
 			if (!sysfsfp) {
 				ret = -errno;
-				free(filename);
 				count--;
 				goto error_cleanup_array;
 			}
@@ -402,20 +400,17 @@ int build_channel_array(const char *device_dir,
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
@@ -426,7 +421,6 @@ int build_channel_array(const char *device_dir,
 						strlen(ent->d_name) -
 						strlen("_en"));
 			if (!current->name) {
-				free(filename);
 				ret = -ENOMEM;
 				count--;
 				goto error_cleanup_array;
@@ -436,7 +430,6 @@ int build_channel_array(const char *device_dir,
 			ret = iioutils_break_up_name(current->name,
 						     &current->generic_name);
 			if (ret) {
-				free(filename);
 				free(current->name);
 				count--;
 				goto error_cleanup_array;
@@ -447,17 +440,16 @@ int build_channel_array(const char *device_dir,
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
 
@@ -467,17 +459,14 @@ int build_channel_array(const char *device_dir,
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
diff --git a/tools/lib/bpf/nlattr.c b/tools/lib/bpf/nlattr.c
index 1e69c0c8d413..e610becd03e8 100644
--- a/tools/lib/bpf/nlattr.c
+++ b/tools/lib/bpf/nlattr.c
@@ -177,7 +177,7 @@ int libbpf_nla_dump_errormsg(struct nlmsghdr *nlh)
 		hlen += nlmsg_len(&err->msg);
 
 	attr = (struct nlattr *) ((void *) err + hlen);
-	alen = nlh->nlmsg_len - hlen;
+	alen = (void *)nlh + nlh->nlmsg_len - (void *)attr;
 
 	if (libbpf_nla_parse(tb, NLMSGERR_ATTR_MAX, attr, alen,
 			     extack_policy) != 0) {
diff --git a/tools/perf/perf-completion.sh b/tools/perf/perf-completion.sh
index fdf75d45efff..978249d7868c 100644
--- a/tools/perf/perf-completion.sh
+++ b/tools/perf/perf-completion.sh
@@ -165,7 +165,12 @@ __perf_main ()
 
 		local cur1=${COMP_WORDS[COMP_CWORD]}
 		local raw_evts=$($cmd list --raw-dump)
-		local arr s tmp result
+		local arr s tmp result cpu_evts
+
+		# aarch64 doesn't have /sys/bus/event_source/devices/cpu/events
+		if [[ `uname -m` != aarch64 ]]; then
+			cpu_evts=$(ls /sys/bus/event_source/devices/cpu/events)
+		fi
 
 		if [[ "$cur1" == */* && ${cur1#*/} =~ ^[A-Z] ]]; then
 			OLD_IFS="$IFS"
@@ -183,9 +188,9 @@ __perf_main ()
 				fi
 			done
 
-			evts=${result}" "$(ls /sys/bus/event_source/devices/cpu/events)
+			evts=${result}" "${cpu_evts}
 		else
-			evts=${raw_evts}" "$(ls /sys/bus/event_source/devices/cpu/events)
+			evts=${raw_evts}" "${cpu_evts}
 		fi
 
 		if [[ "$cur1" == , ]]; then
diff --git a/tools/perf/util/llvm-utils.c b/tools/perf/util/llvm-utils.c
index e7c7e3232fc5..b275a1b297c3 100644
--- a/tools/perf/util/llvm-utils.c
+++ b/tools/perf/util/llvm-utils.c
@@ -523,14 +523,37 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
 
 	pr_debug("llvm compiling command template: %s\n", template);
 
+	/*
+	 * Below, substitute control characters for values that can cause the
+	 * echo to misbehave, then substitute the values back.
+	 */
 	err = -ENOMEM;
-	if (asprintf(&command_echo, "echo -n \"%s\"", template) < 0)
+	if (asprintf(&command_echo, "echo -n \a%s\a", template) < 0)
 		goto errout;
 
+#define SWAP_CHAR(a, b) do { if (*p == a) *p = b; } while (0)
+	for (char *p = command_echo; *p; p++) {
+		SWAP_CHAR('<', '\001');
+		SWAP_CHAR('>', '\002');
+		SWAP_CHAR('"', '\003');
+		SWAP_CHAR('\'', '\004');
+		SWAP_CHAR('|', '\005');
+		SWAP_CHAR('&', '\006');
+		SWAP_CHAR('\a', '"');
+	}
 	err = read_from_pipe(command_echo, (void **) &command_out, NULL);
 	if (err)
 		goto errout;
 
+	for (char *p = command_out; *p; p++) {
+		SWAP_CHAR('\001', '<');
+		SWAP_CHAR('\002', '>');
+		SWAP_CHAR('\003', '"');
+		SWAP_CHAR('\004', '\'');
+		SWAP_CHAR('\005', '|');
+		SWAP_CHAR('\006', '&');
+	}
+#undef SWAP_CHAR
 	pr_debug("llvm compiling command : %s\n", command_out);
 
 	err = read_from_pipe(template, &obj_buf, &obj_buf_sz);
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 49dd029ec80b..698b99e25f98 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -174,6 +174,7 @@ my $store_failures;
 my $store_successes;
 my $test_name;
 my $timeout;
+my $run_timeout;
 my $connect_timeout;
 my $config_bisect_exec;
 my $booted_timeout;
@@ -333,6 +334,7 @@ my %option_map = (
     "STORE_SUCCESSES"		=> \$store_successes,
     "TEST_NAME"			=> \$test_name,
     "TIMEOUT"			=> \$timeout,
+    "RUN_TIMEOUT"		=> \$run_timeout,
     "CONNECT_TIMEOUT"		=> \$connect_timeout,
     "CONFIG_BISECT_EXEC"	=> \$config_bisect_exec,
     "BOOTED_TIMEOUT"		=> \$booted_timeout,
@@ -1422,7 +1424,8 @@ sub reboot {
 
 	# Still need to wait for the reboot to finish
 	wait_for_monitor($time, $reboot_success_line);
-
+    }
+    if ($powercycle || $time) {
 	end_monitor;
     }
 }
@@ -1765,6 +1768,14 @@ sub run_command {
     $command =~ s/\$SSH_USER/$ssh_user/g;
     $command =~ s/\$MACHINE/$machine/g;
 
+    if (!defined($timeout)) {
+	$timeout = $run_timeout;
+    }
+
+    if (!defined($timeout)) {
+	$timeout = -1; # tell wait_for_input to wait indefinitely
+    }
+
     doprint("$command ... ");
     $start_time = time;
 
@@ -1793,13 +1804,10 @@ sub run_command {
 
     while (1) {
 	my $fp = \*CMD;
-	if (defined($timeout)) {
-	    doprint "timeout = $timeout\n";
-	}
 	my $line = wait_for_input($fp, $timeout);
 	if (!defined($line)) {
 	    my $now = time;
-	    if (defined($timeout) && (($now - $start_time) >= $timeout)) {
+	    if ($timeout >= 0 && (($now - $start_time) >= $timeout)) {
 		doprint "Hit timeout of $timeout, killing process\n";
 		$hit_timeout = 1;
 		kill 9, $pid;
@@ -1973,6 +1981,11 @@ sub wait_for_input
 	$time = $timeout;
     }
 
+    if ($time < 0) {
+	# Negative number means wait indefinitely
+	undef $time;
+    }
+
     $rin = '';
     vec($rin, fileno($fp), 1) = 1;
     vec($rin, fileno(\*STDIN), 1) = 1;
@@ -4228,6 +4241,9 @@ sub send_email {
 }
 
 sub cancel_test {
+    if ($monitor_cnt) {
+	end_monitor;
+    }
     if ($email_when_canceled) {
 	my $name = get_test_name;
         send_email("KTEST: Your [$name] test was cancelled",
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index c3bc933d437b..a7b24fda22c1 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -791,6 +791,11 @@
 # is issued instead of a reboot.
 # CONNECT_TIMEOUT = 25
 
+# The timeout in seconds for how long to wait for any running command
+# to timeout. If not defined, it will let it go indefinitely.
+# (default undefined)
+#RUN_TIMEOUT = 600
+
 # In between tests, a reboot of the box may occur, and this
 # is the time to wait for the console after it stops producing
 # output. Some machines may not produce a large lag on reboot
diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc
index f261eeccfaf6..020fbdaa3fba 100644
--- a/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc
@@ -46,7 +46,7 @@ test_event_enabled() {
 
     while [ $check_times -ne 0 ]; do
 	e=`cat $EVENT_ENABLE`
-	if [ "$e" == $val ]; then
+	if [ "$e" = $val ]; then
 	    return 0
 	fi
 	sleep $SLEEP_TIME
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 6986086035d6..24d67fa66d03 100644
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1662,6 +1662,8 @@ EOF
 ################################################################################
 # main
 
+trap cleanup EXIT
+
 while getopts :t:pPhv o
 do
 	case $o in
diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
index 4058c7451e70..f35a924d4a30 100644
--- a/tools/testing/selftests/net/udpgso_bench_rx.c
+++ b/tools/testing/selftests/net/udpgso_bench_rx.c
@@ -214,11 +214,10 @@ static void do_verify_udp(const char *data, int len)
 
 static int recv_msg(int fd, char *buf, int len, int *gso_size)
 {
-	char control[CMSG_SPACE(sizeof(uint16_t))] = {0};
+	char control[CMSG_SPACE(sizeof(int))] = {0};
 	struct msghdr msg = {0};
 	struct iovec iov = {0};
 	struct cmsghdr *cmsg;
-	uint16_t *gsosizeptr;
 	int ret;
 
 	iov.iov_base = buf;
@@ -237,8 +236,7 @@ static int recv_msg(int fd, char *buf, int len, int *gso_size)
 		     cmsg = CMSG_NXTHDR(&msg, cmsg)) {
 			if (cmsg->cmsg_level == SOL_UDP
 			    && cmsg->cmsg_type == UDP_GRO) {
-				gsosizeptr = (uint16_t *) CMSG_DATA(cmsg);
-				*gso_size = *gsosizeptr;
+				*gso_size = *(int *)CMSG_DATA(cmsg);
 				break;
 			}
 		}
diff --git a/virt/kvm/coalesced_mmio.c b/virt/kvm/coalesced_mmio.c
index 8d606997c299..c94e97b351ee 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -191,15 +191,17 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
 			r = kvm_io_bus_unregister_dev(kvm,
 				zone->pio ? KVM_PIO_BUS : KVM_MMIO_BUS, &dev->dev);
 
+			kvm_iodevice_destructor(&dev->dev);
+
 			/*
 			 * On failure, unregister destroys all devices on the
 			 * bus _except_ the target device, i.e. coalesced_zones
-			 * has been modified.  No need to restart the walk as
-			 * there aren't any zones left.
+			 * has been modified.  Bail after destroying the target
+			 * device, there's no need to restart the walk as there
+			 * aren't any zones left.
 			 */
 			if (r)
 				break;
-			kvm_iodevice_destructor(&dev->dev);
 		}
 	}
 
