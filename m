Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9BBA6B3944
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 09:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjCJIvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 03:51:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbjCJItp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 03:49:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23090113DA;
        Fri, 10 Mar 2023 00:49:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 596EACE27D3;
        Fri, 10 Mar 2023 08:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B0FC433EF;
        Fri, 10 Mar 2023 08:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678438162;
        bh=t/uM6nnlIlMlB23NNwzPrz90vPcVHJ+dqNgIla01pXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bYpWI91lVuro4njduZQCXDQmKBvGUwT0HZC+Od5MZ/MMEckd26y2231KtPJm3ZO/6
         LYWNFfDEf6EQwOotkJTESbLwSloUHdEVDoawgKuXT2s64DTFkgVDxWcU8O1fSg7cwh
         YHMUB00UJVW0vRxe85uGw4DOkeeAKTj6qbbzCWhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.99
Date:   Fri, 10 Mar 2023 09:48:53 +0100
Message-Id: <1678438132745@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <167843813216030@kroah.com>
References: <167843813216030@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 41191b5fb69d..dd913eefbf31 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -84,6 +84,8 @@ Brief summary of control files.
  memory.swappiness		     set/show swappiness parameter of vmscan
 				     (See sysctl's vm.swappiness)
  memory.move_charge_at_immigrate     set/show controls of moving charges
+                                     This knob is deprecated and shouldn't be
+                                     used.
  memory.oom_control		     set/show oom controls.
  memory.numa_stat		     show the number of memory usage per numa
 				     node
@@ -723,8 +725,15 @@ NOTE2:
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
diff --git a/Documentation/admin-guide/kdump/gdbmacros.txt b/Documentation/admin-guide/kdump/gdbmacros.txt
index 82aecdcae8a6..030de95e3e6b 100644
--- a/Documentation/admin-guide/kdump/gdbmacros.txt
+++ b/Documentation/admin-guide/kdump/gdbmacros.txt
@@ -312,10 +312,10 @@ define dmesg
 			set var $prev_flags = $info->flags
 		end
 
-		set var $id = ($id + 1) & $id_mask
 		if ($id == $end_id)
 			loop_break
 		end
+		set var $id = ($id + 1) & $id_mask
 	end
 end
 document dmesg
diff --git a/Documentation/dev-tools/gdb-kernel-debugging.rst b/Documentation/dev-tools/gdb-kernel-debugging.rst
index 8e0f1fe8d17a..895285c037c7 100644
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
diff --git a/Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml b/Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml
index 2e35aeaa8781..89e3819c6127 100644
--- a/Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml
+++ b/Documentation/devicetree/bindings/sound/amlogic,gx-sound-card.yaml
@@ -61,7 +61,7 @@ patternProperties:
         description: phandle of the CPU DAI
 
     patternProperties:
-      "^codec-[0-9]+$":
+      "^codec(-[0-9]+)?$":
         type: object
         description: |-
           Codecs:
diff --git a/Documentation/hwmon/ftsteutates.rst b/Documentation/hwmon/ftsteutates.rst
index 58a2483d8d0d..198fa8e2819d 100644
--- a/Documentation/hwmon/ftsteutates.rst
+++ b/Documentation/hwmon/ftsteutates.rst
@@ -22,6 +22,10 @@ enhancements. It can monitor up to 4 voltages, 16 temperatures and
 8 fans. It also contains an integrated watchdog which is currently
 implemented in this driver.
 
+The 4 voltages require a board-specific multiplier, since the BMC can
+only measure voltages up to 3.3V and thus relies on voltage dividers.
+Consult your motherboard manual for details.
+
 To clear a temperature or fan alarm, execute the following command with the
 correct path to the alarm file::
 
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index b550f43214c7..ec38299f9428 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4117,6 +4117,18 @@ not holding a previously reported uncorrected error).
 :Parameters: struct kvm_s390_cmma_log (in, out)
 :Returns: 0 on success, a negative value on error
 
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
 
@@ -4197,12 +4209,6 @@ mask is unused.
 
 values points to the userspace buffer where the result will be stored.
 
-This ioctl can fail with -ENOMEM if not enough memory can be allocated to
-complete the task, with -ENXIO if CMMA is not enabled, with -EINVAL if
-KVM_S390_CMMA_PEEK is not set but migration mode was not enabled, with
--EFAULT if the userspace address is invalid or if no page table is
-present for the addresses (e.g. when using hugepages).
-
 4.108 KVM_S390_SET_CMMA_BITS
 ----------------------------
 
diff --git a/Documentation/virt/kvm/devices/vm.rst b/Documentation/virt/kvm/devices/vm.rst
index 60acc39e0e93..147efec626e5 100644
--- a/Documentation/virt/kvm/devices/vm.rst
+++ b/Documentation/virt/kvm/devices/vm.rst
@@ -302,6 +302,10 @@ Allows userspace to start migration mode, needed for PGSTE migration.
 Setting this attribute when migration mode is already active will have
 no effects.
 
+Dirty tracking must be enabled on all memslots, else -EINVAL is returned. When
+dirty tracking is disabled on any memslot, migration mode is automatically
+stopped.
+
 :Parameters: none
 :Returns:   -ENOMEM if there is not enough free memory to start migration mode;
 	    -EINVAL if the state of the VM is invalid (e.g. no memory defined);
diff --git a/Makefile b/Makefile
index b17ce4c2e8f2..08e73aba22ea 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 98
+SUBLEVEL = 99
 EXTRAVERSION =
 NAME = Trick or Treat
 
@@ -93,10 +93,17 @@ endif
 
 # If the user is running make -s (silent mode), suppress echoing of
 # commands
+# make-4.0 (and later) keep single letter options in the 1st word of MAKEFLAGS.
 
-ifneq ($(findstring s,$(filter-out --%,$(MAKEFLAGS))),)
-  quiet=silent_
-  KBUILD_VERBOSE = 0
+ifeq ($(filter 3.%,$(MAKE_VERSION)),)
+silence:=$(findstring s,$(firstword -$(MAKEFLAGS)))
+else
+silence:=$(findstring s,$(filter-out --%,$(MAKEFLAGS)))
+endif
+
+ifeq ($(silence),s)
+quiet=silent_
+KBUILD_VERBOSE = 0
 endif
 
 export quiet Q KBUILD_VERBOSE
diff --git a/arch/alpha/boot/tools/objstrip.c b/arch/alpha/boot/tools/objstrip.c
index 08b430d25a31..7cf92d172dce 100644
--- a/arch/alpha/boot/tools/objstrip.c
+++ b/arch/alpha/boot/tools/objstrip.c
@@ -148,7 +148,7 @@ main (int argc, char *argv[])
 #ifdef __ELF__
     elf = (struct elfhdr *) buf;
 
-    if (elf->e_ident[0] == 0x7f && str_has_prefix((char *)elf->e_ident + 1, "ELF")) {
+    if (memcmp(&elf->e_ident[EI_MAG0], ELFMAG, SELFMAG) == 0) {
 	if (elf->e_type != ET_EXEC) {
 	    fprintf(stderr, "%s: %s is not an ELF executable\n",
 		    prog_name, inname);
diff --git a/arch/alpha/kernel/traps.c b/arch/alpha/kernel/traps.c
index f5ba12adde67..afaf4f6ad0f4 100644
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
index f6ba5e426040..7562497c45dd 100644
--- a/arch/arm/boot/dts/exynos3250-rinato.dts
+++ b/arch/arm/boot/dts/exynos3250-rinato.dts
@@ -249,7 +249,7 @@ &fimd {
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
index eab77a66ae8f..201e2fe7ed0c 100644
--- a/arch/arm/boot/dts/exynos4.dtsi
+++ b/arch/arm/boot/dts/exynos4.dtsi
@@ -605,7 +605,7 @@ i2c_8: i2c@138e0000 {
 			status = "disabled";
 
 			hdmi_i2c_phy: hdmiphy@38 {
-				compatible = "exynos4210-hdmiphy";
+				compatible = "samsung,exynos4210-hdmiphy";
 				reg = <0x38>;
 			};
 		};
diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index 7e7d65ce6585..ac62d8dc70b1 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -393,7 +393,6 @@ &cpu_alert2 {
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
 };
 
 &gic {
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index 4ffa9253b566..de0275df807f 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -1119,7 +1119,7 @@ timer {
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
+	thermal-sensors = <&tmu>;
 
 	cooling-maps {
 		map0 {
diff --git a/arch/arm/boot/dts/exynos5410-odroidxu.dts b/arch/arm/boot/dts/exynos5410-odroidxu.dts
index 884fef55836c..3765f5ba03f2 100644
--- a/arch/arm/boot/dts/exynos5410-odroidxu.dts
+++ b/arch/arm/boot/dts/exynos5410-odroidxu.dts
@@ -120,7 +120,6 @@ &clock_audss {
 };
 
 &cpu0_thermal {
-	thermal-sensors = <&tmu_cpu0 0>;
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
 
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index e23e8ffb093f..4fb4804830af 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -602,7 +602,7 @@ dp_phy: dp-video-phy {
 		};
 
 		mipi_phy: mipi-video-phy {
-			compatible = "samsung,s5pv210-mipi-video-phy";
+			compatible = "samsung,exynos5420-mipi-video-phy";
 			syscon = <&pmu_system_controller>;
 			#phy-cells = <1>;
 		};
diff --git a/arch/arm/boot/dts/exynos5422-odroidhc1.dts b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
index d91f7fa2cf80..e57d3e464434 100644
--- a/arch/arm/boot/dts/exynos5422-odroidhc1.dts
+++ b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
@@ -29,7 +29,7 @@ led-1 {
 
 	thermal-zones {
 		cpu0_thermal: cpu0-thermal {
-			thermal-sensors = <&tmu_cpu0 0>;
+			thermal-sensors = <&tmu_cpu0>;
 			trips {
 				cpu0_alert0: cpu-alert-0 {
 					temperature = <70000>; /* millicelsius */
@@ -84,7 +84,7 @@ map1 {
 			};
 		};
 		cpu1_thermal: cpu1-thermal {
-			thermal-sensors = <&tmu_cpu1 0>;
+			thermal-sensors = <&tmu_cpu1>;
 			trips {
 				cpu1_alert0: cpu-alert-0 {
 					temperature = <70000>;
@@ -128,7 +128,7 @@ map1 {
 			};
 		};
 		cpu2_thermal: cpu2-thermal {
-			thermal-sensors = <&tmu_cpu2 0>;
+			thermal-sensors = <&tmu_cpu2>;
 			trips {
 				cpu2_alert0: cpu-alert-0 {
 					temperature = <70000>;
@@ -172,7 +172,7 @@ map1 {
 			};
 		};
 		cpu3_thermal: cpu3-thermal {
-			thermal-sensors = <&tmu_cpu3 0>;
+			thermal-sensors = <&tmu_cpu3>;
 			trips {
 				cpu3_alert0: cpu-alert-0 {
 					temperature = <70000>;
@@ -216,7 +216,7 @@ map1 {
 			};
 		};
 		gpu_thermal: gpu-thermal {
-			thermal-sensors = <&tmu_gpu 0>;
+			thermal-sensors = <&tmu_gpu>;
 			trips {
 				gpu_alert0: gpu-alert-0 {
 					temperature = <70000>;
diff --git a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
index e35af40a55cb..0b27e968c6fd 100644
--- a/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
+++ b/arch/arm/boot/dts/exynos5422-odroidxu3-common.dtsi
@@ -50,7 +50,7 @@ fan0: pwm-fan {
 
 	thermal-zones {
 		cpu0_thermal: cpu0-thermal {
-			thermal-sensors = <&tmu_cpu0 0>;
+			thermal-sensors = <&tmu_cpu0>;
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
 			trips {
@@ -139,7 +139,7 @@ cpu0_cooling_map4: map4 {
 			};
 		};
 		cpu1_thermal: cpu1-thermal {
-			thermal-sensors = <&tmu_cpu1 0>;
+			thermal-sensors = <&tmu_cpu1>;
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
 			trips {
@@ -212,7 +212,7 @@ cpu1_cooling_map4: map4 {
 			};
 		};
 		cpu2_thermal: cpu2-thermal {
-			thermal-sensors = <&tmu_cpu2 0>;
+			thermal-sensors = <&tmu_cpu2>;
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
 			trips {
@@ -285,7 +285,7 @@ cpu2_cooling_map4: map4 {
 			};
 		};
 		cpu3_thermal: cpu3-thermal {
-			thermal-sensors = <&tmu_cpu3 0>;
+			thermal-sensors = <&tmu_cpu3>;
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
 			trips {
@@ -358,7 +358,7 @@ cpu3_cooling_map4: map4 {
 			};
 		};
 		gpu_thermal: gpu-thermal {
-			thermal-sensors = <&tmu_gpu 0>;
+			thermal-sensors = <&tmu_gpu>;
 			polling-delay-passive = <250>;
 			polling-delay = <0>;
 			trips {
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 95f22513a7c0..f4d2009d998b 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -497,7 +497,7 @@ gpr: iomuxc-gpr@30340000 {
 
 				mux: mux-controller {
 					compatible = "mmio-mux";
-					#mux-control-cells = <0>;
+					#mux-control-cells = <1>;
 					mux-reg-masks = <0x14 0x00000010>;
 				};
 
diff --git a/arch/arm/boot/dts/qcom-sdx55.dtsi b/arch/arm/boot/dts/qcom-sdx55.dtsi
index 0e76d03087fe..9d62487f6c8f 100644
--- a/arch/arm/boot/dts/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom-sdx55.dtsi
@@ -502,7 +502,7 @@ pil-reloc@94c {
 		};
 
 		apps_smmu: iommu@15000000 {
-			compatible = "qcom,sdx55-smmu-500", "arm,mmu-500";
+			compatible = "qcom,sdx55-smmu-500", "qcom,smmu-500", "arm,mmu-500";
 			reg = <0x15000000 0x20000>;
 			#iommu-cells = <2>;
 			#global-interrupts = <1>;
diff --git a/arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts b/arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts
index 8e7dfcffe1fb..355f7844fd55 100644
--- a/arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts
+++ b/arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts
@@ -57,7 +57,7 @@ reg_vdd_cpux: vdd-cpux-regulator {
 		regulator-ramp-delay = <50>; /* 4ms */
 
 		enable-active-high;
-		enable-gpio = <&r_pio 0 8 GPIO_ACTIVE_HIGH>; /* PL8 */
+		enable-gpios = <&r_pio 0 8 GPIO_ACTIVE_HIGH>; /* PL8 */
 		gpios = <&r_pio 0 6 GPIO_ACTIVE_HIGH>; /* PL6 */
 		gpios-states = <0x1>;
 		states = <1100000 0>, <1300000 1>;
diff --git a/arch/arm/configs/bcm2835_defconfig b/arch/arm/configs/bcm2835_defconfig
index 383c632eba7b..1e244a928790 100644
--- a/arch/arm/configs/bcm2835_defconfig
+++ b/arch/arm/configs/bcm2835_defconfig
@@ -108,6 +108,7 @@ CONFIG_MEDIA_SUPPORT=y
 CONFIG_MEDIA_CAMERA_SUPPORT=y
 CONFIG_DRM=y
 CONFIG_DRM_VC4=y
+CONFIG_FB=y
 CONFIG_FB_SIMPLE=y
 CONFIG_FRAMEBUFFER_CONSOLE=y
 CONFIG_SOUND=y
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
index 0411d5508d63..7046d7fa7a0a 100644
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
index 620ba69c8f11..5677c4a08f37 100644
--- a/arch/arm/mach-omap2/timer.c
+++ b/arch/arm/mach-omap2/timer.c
@@ -76,6 +76,7 @@ static void __init realtime_counter_init(void)
 	}
 
 	rate = clk_get_rate(sys_clk);
+	clk_put(sys_clk);
 
 	if (soc_is_dra7xx()) {
 		/*
diff --git a/arch/arm/mach-s3c/s3c64xx.c b/arch/arm/mach-s3c/s3c64xx.c
index 4dfb648142f2..17f006503149 100644
--- a/arch/arm/mach-s3c/s3c64xx.c
+++ b/arch/arm/mach-s3c/s3c64xx.c
@@ -173,7 +173,8 @@ static struct samsung_pwm_variant s3c64xx_pwm_variant = {
 	.tclk_mask	= (1 << 7) | (1 << 6) | (1 << 5),
 };
 
-void __init s3c64xx_set_timer_source(unsigned int event, unsigned int source)
+void __init s3c64xx_set_timer_source(enum s3c64xx_timer_mode event,
+				     enum s3c64xx_timer_mode source)
 {
 	s3c64xx_pwm_variant.output_mask = BIT(SAMSUNG_PWM_NUM) - 1;
 	s3c64xx_pwm_variant.output_mask &= ~(BIT(event) | BIT(source));
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
index e2ab338adb3c..db5a1f465313 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -152,7 +152,7 @@ scpi {
 		scpi_clocks: clocks {
 			compatible = "arm,scpi-clocks";
 
-			scpi_dvfs: clock-controller {
+			scpi_dvfs: clocks-0 {
 				compatible = "arm,scpi-dvfs-clocks";
 				#clock-cells = <1>;
 				clock-indices = <0>;
@@ -161,7 +161,7 @@ scpi_dvfs: clock-controller {
 		};
 
 		scpi_sensors: sensors {
-			compatible = "amlogic,meson-gxbb-scpi-sensors";
+			compatible = "amlogic,meson-gxbb-scpi-sensors", "arm,scpi-sensors";
 			#thermal-sensor-cells = <1>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 2526d6e3a3dc..899cfe416aef 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1733,7 +1733,7 @@ int_mdio: mdio@1 {
 					#address-cells = <1>;
 					#size-cells = <0>;
 
-					internal_ephy: ethernet_phy@8 {
+					internal_ephy: ethernet-phy@8 {
 						compatible = "ethernet-phy-id0180.3301",
 							     "ethernet-phy-ieee802.3-c22";
 						interrupts = <GIC_SPI 9 IRQ_TYPE_LEVEL_HIGH>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12a.dtsi
index fb0ab27d1f64..6eaceb717d61 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a.dtsi
@@ -57,26 +57,6 @@ cpu_opp_table: opp-table {
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
diff --git a/arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi
index 2d7032f41e4b..772c220c8f49 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx-libretech-pc.dtsi
@@ -17,7 +17,7 @@ adc-keys {
 		io-channel-names = "buttons";
 		keyup-threshold-microvolt = <1800000>;
 
-		update-button {
+		button-update {
 			label = "update";
 			linux,code = <KEY_VENDOR>;
 			press-threshold-microvolt = <1300000>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
index ee623ead972e..32cc9fab4490 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -232,7 +232,7 @@ sn: sn@14 {
 			reg = <0x14 0x10>;
 		};
 
-		eth_mac: eth_mac@34 {
+		eth_mac: eth-mac@34 {
 			reg = <0x34 0x10>;
 		};
 
@@ -249,7 +249,7 @@ scpi {
 		scpi_clocks: clocks {
 			compatible = "arm,scpi-clocks";
 
-			scpi_dvfs: scpi_clocks@0 {
+			scpi_dvfs: clocks-0 {
 				compatible = "arm,scpi-dvfs-clocks";
 				#clock-cells = <1>;
 				clock-indices = <0>;
@@ -531,7 +531,7 @@ periphs: bus@c8834000 {
 			#size-cells = <2>;
 			ranges = <0x0 0x0 0x0 0xc8834000 0x0 0x2000>;
 
-			hwrng: rng {
+			hwrng: rng@0 {
 				compatible = "amlogic,meson-rng";
 				reg = <0x0 0x0 0x0 0x4>;
 			};
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts b/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
index e8394a8269ee..802faf7e4e3c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxbb-kii-pro.dts
@@ -16,7 +16,7 @@ / {
 
 	leds {
 		compatible = "gpio-leds";
-		status {
+		led {
 			gpios = <&gpio_ao GPIOAO_13 GPIO_ACTIVE_LOW>;
 			default-state = "off";
 			color = <LED_COLOR_ID_RED>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts
index 9ef210f17b4a..393d3cb33b9e 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-phicomm-n1.dts
@@ -18,7 +18,7 @@ cvbs-connector {
 	leds {
 		compatible = "gpio-leds";
 
-		status {
+		led {
 			label = "n1:white:status";
 			gpios = <&gpio_ao GPIOAO_9 GPIO_ACTIVE_HIGH>;
 			default-state = "on";
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts
index b331a013572f..c490dbbf063b 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts
@@ -79,6 +79,5 @@ bluetooth {
 		enable-gpios = <&gpio GPIOX_17 GPIO_ACTIVE_HIGH>;
 		max-speed = <2000000>;
 		clocks = <&wifi32k>;
-		clock-names = "lpo";
 	};
 };
diff --git a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
index c3ac531c4f84..350022935052 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl.dtsi
@@ -759,7 +759,7 @@ mux {
 		};
 	};
 
-	eth-phy-mux {
+	eth-phy-mux@55c {
 		compatible = "mdio-mux-mmioreg", "mdio-mux";
 		#address-cells = <1>;
 		#size-cells = <0>;
diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
index cadba194b149..38ebe98ba9c6 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-bananapi-m5.dts
@@ -17,13 +17,13 @@ / {
 	compatible = "bananapi,bpi-m5", "amlogic,sm1";
 	model = "Banana Pi BPI-M5";
 
-	adc_keys {
+	adc-keys {
 		compatible = "adc-keys";
 		io-channels = <&saradc 2>;
 		io-channel-names = "buttons";
 		keyup-threshold-microvolt = <1800000>;
 
-		key {
+		button-sw3 {
 			label = "SW3";
 			linux,code = <BTN_3>;
 			press-threshold-microvolt = <1700000>;
@@ -123,7 +123,7 @@ vddio_c: regulator-vddio_c {
 		regulator-min-microvolt = <1800000>;
 		regulator-max-microvolt = <3300000>;
 
-		enable-gpio = <&gpio_ao GPIOE_2 GPIO_ACTIVE_HIGH>;
+		enable-gpio = <&gpio_ao GPIOE_2 GPIO_OPEN_DRAIN>;
 		enable-active-high;
 		regulator-always-on;
 
diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
index f3f953225bf5..15fece2e6320 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
@@ -76,9 +76,17 @@ sound {
 };
 
 &cpu_thermal {
+	trips {
+		cpu_active: cpu-active {
+			temperature = <60000>; /* millicelsius */
+			hysteresis = <2000>; /* millicelsius */
+			type = "active";
+		};
+	};
+
 	cooling-maps {
 		map {
-			trip = <&cpu_passive>;
+			trip = <&cpu_active>;
 			cooling-device = <&fan0 THERMAL_NO_LIMIT THERMAL_NO_LIMIT>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/freescale/imx8mm.dtsi b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
index 67e91fdfaf52..2a67122c5624 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm.dtsi
@@ -530,7 +530,7 @@ ocotp: efuse@30350000 {
 				#address-cells = <1>;
 				#size-cells = <1>;
 
-				imx8mm_uid: unique-id@410 {
+				imx8mm_uid: unique-id@4 {
 					reg = <0x4 0x8>;
 				};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mn.dtsi b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
index 6dcead5bae62..0c47ff242641 100644
--- a/arch/arm64/boot/dts/freescale/imx8mn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mn.dtsi
@@ -533,7 +533,7 @@ ocotp: efuse@30350000 {
 				#address-cells = <1>;
 				#size-cells = <1>;
 
-				imx8mn_uid: unique-id@410 {
+				imx8mn_uid: unique-id@4 {
 					reg = <0x4 0x8>;
 				};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mp.dtsi b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
index 664177ed38d3..ab670b5d641b 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp.dtsi
@@ -358,7 +358,7 @@ ocotp: efuse@30350000 {
 				#address-cells = <1>;
 				#size-cells = <1>;
 
-				imx8mp_uid: unique-id@420 {
+				imx8mp_uid: unique-id@8 {
 					reg = <0x8 0x8>;
 				};
 
diff --git a/arch/arm64/boot/dts/freescale/imx8mq.dtsi b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
index fd38092bb247..2a698c5b87bc 100644
--- a/arch/arm64/boot/dts/freescale/imx8mq.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mq.dtsi
@@ -557,7 +557,7 @@ ocotp: efuse@30350000 {
 				#address-cells = <1>;
 				#size-cells = <1>;
 
-				imx8mq_uid: soc-uid@410 {
+				imx8mq_uid: soc-uid@4 {
 					reg = <0x4 0x8>;
 				};
 
diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index 890a942ec608..a4c48b2abd20 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -428,6 +428,7 @@ uart3: serial@11005000 {
 	pwm: pwm@11006000 {
 		compatible = "mediatek,mt7622-pwm";
 		reg = <0 0x11006000 0 0x1000>;
+		#pwm-cells = <2>;
 		interrupts = <GIC_SPI 77 IRQ_TYPE_LEVEL_LOW>;
 		clocks = <&topckgen CLK_TOP_PWM_SEL>,
 			 <&pericfg CLK_PERI_PWM_PD>,
diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index f4e0bea8ddcb..81fde34ffd52 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -299,6 +299,15 @@ psci {
 		method          = "smc";
 	};
 
+	clk13m: fixed-factor-clock-13m {
+		compatible = "fixed-factor-clock";
+		#clock-cells = <0>;
+		clocks = <&clk26m>;
+		clock-div = <2>;
+		clock-mult = <1>;
+		clock-output-names = "clk13m";
+	};
+
 	clk26m: oscillator {
 		compatible = "fixed-clock";
 		#clock-cells = <0>;
@@ -610,8 +619,7 @@ systimer: timer@10017000 {
 				     "mediatek,mt6765-timer";
 			reg = <0 0x10017000 0 0x1000>;
 			interrupts = <GIC_SPI 200 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&topckgen CLK_TOP_CLK13M>;
-			clock-names = "clk13m";
+			clocks = <&clk13m>;
 		};
 
 		iommu: iommu@10205000 {
diff --git a/arch/arm64/boot/dts/mediatek/mt8192.dtsi b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
index d1e63527b387..9ed1a7229574 100644
--- a/arch/arm64/boot/dts/mediatek/mt8192.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8192.dtsi
@@ -135,19 +135,16 @@ core2 {
 				core3 {
 					cpu = <&cpu3>;
 				};
-			};
-
-			cluster1 {
-				core0 {
+				core4 {
 					cpu = <&cpu4>;
 				};
-				core1 {
+				core5 {
 					cpu = <&cpu5>;
 				};
-				core2 {
+				core6 {
 					cpu = <&cpu6>;
 				};
-				core3 {
+				core7 {
 					cpu = <&cpu7>;
 				};
 			};
diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index 9d4019e0949a..68e82c755986 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -114,7 +114,7 @@ usb1_ssphy: phy@58200 {
 				#phy-cells = <0>;
 				clocks = <&gcc GCC_USB1_PIPE_CLK>;
 				clock-names = "pipe0";
-				clock-output-names = "gcc_usb1_pipe_clk_src";
+				clock-output-names = "usb3phy_1_cc_pipe_clk";
 			};
 		};
 
@@ -157,7 +157,7 @@ usb0_ssphy: phy@78200 {
 				#phy-cells = <0>;
 				clocks = <&gcc GCC_USB0_PIPE_CLK>;
 				clock-names = "pipe0";
-				clock-output-names = "gcc_usb0_pipe_clk_src";
+				clock-output-names = "usb3phy_0_cc_pipe_clk";
 			};
 		};
 
@@ -174,34 +174,61 @@ qusb_phy_0: phy@79000 {
 			status = "disabled";
 		};
 
-		pcie_phy0: phy@86000 {
-			compatible = "qcom,ipq8074-qmp-pcie-phy";
-			reg = <0x00086000 0x1000>;
-			#phy-cells = <0>;
-			clocks = <&gcc GCC_PCIE0_PIPE_CLK>;
-			clock-names = "pipe_clk";
-			clock-output-names = "pcie20_phy0_pipe_clk";
+		pcie_qmp0: phy@84000 {
+			compatible = "qcom,ipq8074-qmp-gen3-pcie-phy";
+			reg = <0x00084000 0x1bc>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
 
+			clocks = <&gcc GCC_PCIE0_AUX_CLK>,
+				<&gcc GCC_PCIE0_AHB_CLK>;
+			clock-names = "aux", "cfg_ahb";
 			resets = <&gcc GCC_PCIE0_PHY_BCR>,
 				<&gcc GCC_PCIE0PHY_PHY_BCR>;
 			reset-names = "phy",
 				      "common";
 			status = "disabled";
+
+			pcie_phy0: phy@84200 {
+				reg = <0x84200 0x16c>,
+				      <0x84400 0x200>,
+				      <0x84800 0x1f0>,
+				      <0x84c00 0xf4>;
+				#phy-cells = <0>;
+				#clock-cells = <0>;
+				clocks = <&gcc GCC_PCIE0_PIPE_CLK>;
+				clock-names = "pipe0";
+				clock-output-names = "pcie20_phy0_pipe_clk";
+			};
 		};
 
-		pcie_phy1: phy@8e000 {
+		pcie_qmp1: phy@8e000 {
 			compatible = "qcom,ipq8074-qmp-pcie-phy";
-			reg = <0x0008e000 0x1000>;
-			#phy-cells = <0>;
-			clocks = <&gcc GCC_PCIE1_PIPE_CLK>;
-			clock-names = "pipe_clk";
-			clock-output-names = "pcie20_phy1_pipe_clk";
+			reg = <0x0008e000 0x1c4>;
+			#address-cells = <1>;
+			#size-cells = <1>;
+			ranges;
 
+			clocks = <&gcc GCC_PCIE1_AUX_CLK>,
+				<&gcc GCC_PCIE1_AHB_CLK>;
+			clock-names = "aux", "cfg_ahb";
 			resets = <&gcc GCC_PCIE1_PHY_BCR>,
 				<&gcc GCC_PCIE1PHY_PHY_BCR>;
 			reset-names = "phy",
 				      "common";
 			status = "disabled";
+
+			pcie_phy1: phy@8e200 {
+				reg = <0x8e200 0x130>,
+				      <0x8e400 0x200>,
+				      <0x8e800 0x1f8>;
+				#phy-cells = <0>;
+				#clock-cells = <0>;
+				clocks = <&gcc GCC_PCIE1_PIPE_CLK>;
+				clock-names = "pipe0";
+				clock-output-names = "pcie20_phy1_pipe_clk";
+			};
 		};
 
 		prng: rng@e3000 {
@@ -635,9 +662,9 @@ pcie1: pci@10000000 {
 			phy-names = "pciephy";
 
 			ranges = <0x81000000 0 0x10200000 0x10200000
-				  0 0x100000   /* downstream I/O */
-				  0x82000000 0 0x10300000 0x10300000
-				  0 0xd00000>; /* non-prefetchable memory */
+				  0 0x10000>,   /* downstream I/O */
+				 <0x82000000 0 0x10220000 0x10220000
+				  0 0xfde0000>; /* non-prefetchable memory */
 
 			interrupts = <GIC_SPI 85 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "msi";
@@ -680,16 +707,18 @@ IRQ_TYPE_LEVEL_HIGH>, /* int_c */
 		};
 
 		pcie0: pci@20000000 {
-			compatible = "qcom,pcie-ipq8074";
+			compatible = "qcom,pcie-ipq8074-gen3";
 			reg = <0x20000000 0xf1d>,
 			      <0x20000f20 0xa8>,
-			      <0x00080000 0x2000>,
+			      <0x20001000 0x1000>,
+			      <0x00080000 0x4000>,
 			      <0x20100000 0x1000>;
-			reg-names = "dbi", "elbi", "parf", "config";
+			reg-names = "dbi", "elbi", "atu", "parf", "config";
 			device_type = "pci";
 			linux,pci-domain = <0>;
 			bus-range = <0x00 0xff>;
 			num-lanes = <1>;
+			max-link-speed = <3>;
 			#address-cells = <3>;
 			#size-cells = <2>;
 
@@ -697,9 +726,9 @@ pcie0: pci@20000000 {
 			phy-names = "pciephy";
 
 			ranges = <0x81000000 0 0x20200000 0x20200000
-				  0 0x100000   /* downstream I/O */
-				  0x82000000 0 0x20300000 0x20300000
-				  0 0xd00000>; /* non-prefetchable memory */
+				  0 0x10000>, /* downstream I/O */
+				 <0x82000000 0 0x20220000 0x20220000
+				  0 0xfde0000>; /* non-prefetchable memory */
 
 			interrupts = <GIC_SPI 52 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "msi";
@@ -717,28 +746,30 @@ IRQ_TYPE_LEVEL_HIGH>, /* int_c */
 			clocks = <&gcc GCC_SYS_NOC_PCIE0_AXI_CLK>,
 				 <&gcc GCC_PCIE0_AXI_M_CLK>,
 				 <&gcc GCC_PCIE0_AXI_S_CLK>,
-				 <&gcc GCC_PCIE0_AHB_CLK>,
-				 <&gcc GCC_PCIE0_AUX_CLK>;
-
+				 <&gcc GCC_PCIE0_AXI_S_BRIDGE_CLK>,
+				 <&gcc GCC_PCIE0_RCHNG_CLK>;
 			clock-names = "iface",
 				      "axi_m",
 				      "axi_s",
-				      "ahb",
-				      "aux";
+				      "axi_bridge",
+				      "rchng";
+
 			resets = <&gcc GCC_PCIE0_PIPE_ARES>,
 				 <&gcc GCC_PCIE0_SLEEP_ARES>,
 				 <&gcc GCC_PCIE0_CORE_STICKY_ARES>,
 				 <&gcc GCC_PCIE0_AXI_MASTER_ARES>,
 				 <&gcc GCC_PCIE0_AXI_SLAVE_ARES>,
 				 <&gcc GCC_PCIE0_AHB_ARES>,
-				 <&gcc GCC_PCIE0_AXI_MASTER_STICKY_ARES>;
+				 <&gcc GCC_PCIE0_AXI_MASTER_STICKY_ARES>,
+				 <&gcc GCC_PCIE0_AXI_SLAVE_STICKY_ARES>;
 			reset-names = "pipe",
 				      "sleep",
 				      "sticky",
 				      "axi_m",
 				      "axi_s",
 				      "ahb",
-				      "axi_m_sticky";
+				      "axi_m_sticky",
+				      "axi_s_sticky";
 			status = "disabled";
 		};
 	};
diff --git a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
index c7d191dc6d4b..60fcb024c887 100644
--- a/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
+++ b/arch/arm64/boot/dts/qcom/msm8992-bullhead-rev-101.dts
@@ -1,7 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright (c) 2015, LGE Inc. All rights reserved.
  * Copyright (c) 2016, The Linux Foundation. All rights reserved.
- * Copyright (c) 2021, Petr Vorel <petr.vorel@gmail.com>
+ * Copyright (c) 2021-2022, Petr Vorel <petr.vorel@gmail.com>
+ * Copyright (c) 2022, Dominik Kobinski <dominikkobinski314@gmail.com>
  */
 
 /dts-v1/;
@@ -13,6 +14,9 @@
 /* cont_splash_mem has different memory mapping */
 /delete-node/ &cont_splash_mem;
 
+/* disabled on downstream, conflicts with cont_splash_mem */
+/delete-node/ &dfps_data_mem;
+
 / {
 	model = "LG Nexus 5X";
 	compatible = "lg,bullhead", "qcom,msm8992";
@@ -47,7 +51,17 @@ ramoops@1ff00000 {
 		};
 
 		cont_splash_mem: memory@3400000 {
-			reg = <0 0x03400000 0 0x1200000>;
+			reg = <0 0x03400000 0 0xc00000>;
+			no-map;
+		};
+
+		reserved@5000000 {
+			reg = <0x0 0x05000000 0x0 0x1a00000>;
+			no-map;
+		};
+
+		reserved@6c00000 {
+			reg = <0x0 0x06c00000 0x0 0x400000>;
 			no-map;
 		};
 	};
diff --git a/arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi b/arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi
index 507396c4d23b..7802abac39fa 100644
--- a/arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996-sony-xperia-tone.dtsi
@@ -938,10 +938,6 @@ touch_int_sleep: touch-int-sleep {
 	};
 };
 
-/*
- * For reasons that are currently unknown (but probably related to fusb301), USB takes about
- * 6 minutes to wake up (nothing interesting in kernel logs), but then it works as it should.
- */
 &usb3 {
 	status = "okay";
 	qcom,select-utmi-as-pipe-clk;
@@ -950,6 +946,7 @@ &usb3 {
 &usb3_dwc3 {
 	extcon = <&usb3_id>;
 	dr_mode = "peripheral";
+	maximum-speed = "high-speed";
 	phys = <&hsusb_phy1>;
 	phy-names = "usb2-phy";
 	snps,hird-threshold = /bits/ 8 <0>;
diff --git a/arch/arm64/boot/dts/qcom/pmk8350.dtsi b/arch/arm64/boot/dts/qcom/pmk8350.dtsi
index 04fc2632a0b2..fc38f77d12a3 100644
--- a/arch/arm64/boot/dts/qcom/pmk8350.dtsi
+++ b/arch/arm64/boot/dts/qcom/pmk8350.dtsi
@@ -16,8 +16,9 @@ pmk8350: pmic@0 {
 		#size-cells = <0>;
 
 		pmk8350_pon: pon@1300 {
-			compatible = "qcom,pm8998-pon";
-			reg = <0x1300>;
+			compatible = "qcom,pmk8350-pon";
+			reg = <0x1300>, <0x800>;
+			reg-names = "hlos", "pbs";
 
 			pwrkey {
 				compatible = "qcom,pmk8350-pwrkey";
diff --git a/arch/arm64/boot/dts/qcom/qcs404.dtsi b/arch/arm64/boot/dts/qcom/qcs404.dtsi
index 18cc8e3bc93a..fd0d634a373f 100644
--- a/arch/arm64/boot/dts/qcom/qcs404.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcs404.dtsi
@@ -775,7 +775,7 @@ pcie_phy: phy@7786000 {
 
 			clocks = <&gcc GCC_PCIE_0_PIPE_CLK>;
 			resets = <&gcc GCC_PCIEPHY_0_PHY_BCR>,
-				 <&gcc 21>;
+				 <&gcc GCC_PCIE_0_PIPE_ARES>;
 			reset-names = "phy", "pipe";
 
 			clock-output-names = "pcie_0_pipe_clk";
@@ -1305,12 +1305,12 @@ pcie: pci@10000000 {
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
diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
index de86ae3a7fd2..12816d60e249 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -3241,8 +3241,8 @@ spmi_bus: spmi@c440000 {
 			interrupts-extended = <&pdc 1 IRQ_TYPE_LEVEL_HIGH>;
 			qcom,ee = <0>;
 			qcom,channel = <0>;
-			#address-cells = <1>;
-			#size-cells = <1>;
+			#address-cells = <2>;
+			#size-cells = <0>;
 			interrupt-controller;
 			#interrupt-cells = <4>;
 			cell-index = <0>;
diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index b795a9993cc1..fb6473a0aa4b 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -1494,8 +1494,8 @@ spmi_bus: spmi@c440000 {
 			interrupts-extended = <&pdc 1 IRQ_TYPE_LEVEL_HIGH>;
 			qcom,ee = <0>;
 			qcom,channel = <0>;
-			#address-cells = <1>;
-			#size-cells = <1>;
+			#address-cells = <2>;
+			#size-cells = <0>;
 			interrupt-controller;
 			#interrupt-cells = <4>;
 		};
diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index 146d3cd3f1b3..5ce270f0b2ec 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -896,7 +896,7 @@ sdc2_card_det_n: sd-card-det-n {
 	};
 
 	wcd_intr_default: wcd_intr_default {
-		pins = <54>;
+		pins = "gpio54";
 		function = "gpio";
 
 		input-enable;
diff --git a/arch/arm64/boot/dts/qcom/sm6125.dtsi b/arch/arm64/boot/dts/qcom/sm6125.dtsi
index dc3bddc54eb6..2e4fe2bc1e0a 100644
--- a/arch/arm64/boot/dts/qcom/sm6125.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6125.dtsi
@@ -392,9 +392,9 @@ hsusb_phy1: phy@1613000 {
 			reg = <0x01613000 0x180>;
 			#phy-cells = <0>;
 
-			clocks = <&rpmcc RPM_SMD_XO_CLK_SRC>,
-				 <&gcc GCC_AHB2PHY_USB_CLK>;
-			clock-names = "ref", "cfg_ahb";
+			clocks = <&gcc GCC_AHB2PHY_USB_CLK>,
+				 <&rpmcc RPM_SMD_XO_CLK_SRC>;
+			clock-names = "cfg_ahb", "ref";
 
 			resets = <&gcc GCC_QUSB2PHY_PRIM_BCR>;
 			status = "disabled";
diff --git a/arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi b/arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi
index fb6e5a140c9f..04c71f74ab72 100644
--- a/arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi
@@ -33,9 +33,10 @@ chosen {
 		framebuffer: framebuffer@9c000000 {
 			compatible = "simple-framebuffer";
 			reg = <0 0x9c000000 0 0x2300000>;
-			width = <1644>;
-			height = <3840>;
-			stride = <(1644 * 4)>;
+			/* Griffin BL initializes in 2.5k mode, not 4k */
+			width = <1096>;
+			height = <2560>;
+			stride = <(1096 * 4)>;
 			format = "a8r8g8b8";
 			/*
 			 * That's (going to be) a lot of clocks, but it's necessary due
diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
index 48e0c0494f6a..f1ab4943c295 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
@@ -432,20 +432,6 @@ wm8962_endpoint: endpoint {
 		};
 	};
 
-	/* 0 - lcd_reset */
-	/* 1 - lcd_pwr */
-	/* 2 - lcd_select */
-	/* 3 - backlight-enable */
-	/* 4 - Touch_shdwn */
-	/* 5 - LCD_H_pol */
-	/* 6 - lcd_V_pol */
-	gpio_exp1: gpio@20 {
-		compatible = "onnn,pca9654";
-		reg = <0x20>;
-		gpio-controller;
-		#gpio-cells = <2>;
-	};
-
 	touchscreen@26 {
 		compatible = "ilitek,ili2117";
 		reg = <0x26>;
@@ -477,6 +463,16 @@ hd3ss3220_out_ep: endpoint {
 			};
 		};
 	};
+
+	gpio_exp1: gpio@70 {
+		compatible = "nxp,pca9538";
+		reg = <0x70>;
+		gpio-controller;
+		#gpio-cells = <2>;
+		gpio-line-names = "lcd_reset", "lcd_pwr", "lcd_select",
+				  "backlight-enable", "Touch_shdwn",
+				  "LCD_H_pol", "lcd_V_pol";
+	};
 };
 
 &lvds0 {
diff --git a/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts b/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
index c3406e7f10a9..4417fe81afd7 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
@@ -77,7 +77,7 @@ vdd_sd_dv: gpio-regulator-TLV71033 {
 	};
 };
 
-&wkup_pmx0 {
+&wkup_pmx2 {
 	mcu_cpsw_pins_default: mcu-cpsw-pins-default {
 		pinctrl-single,pins = <
 			J721E_WKUP_IOPAD(0x0068, PIN_OUTPUT, 0) /* MCU_RGMII1_TX_CTL */
diff --git a/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
index 1044ec6c4b0d..8185c1627c6f 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
@@ -56,7 +56,34 @@ chipid@43000014 {
 	wkup_pmx0: pinctrl@4301c000 {
 		compatible = "pinctrl-single";
 		/* Proxy 0 addressing */
-		reg = <0x00 0x4301c000 0x00 0x178>;
+		reg = <0x00 0x4301c000 0x00 0x34>;
+		#pinctrl-cells = <1>;
+		pinctrl-single,register-width = <32>;
+		pinctrl-single,function-mask = <0xffffffff>;
+	};
+
+	wkup_pmx1: pinctrl@0x4301c038 {
+		compatible = "pinctrl-single";
+		/* Proxy 0 addressing */
+		reg = <0x00 0x4301c038 0x00 0x8>;
+		#pinctrl-cells = <1>;
+		pinctrl-single,register-width = <32>;
+		pinctrl-single,function-mask = <0xffffffff>;
+	};
+
+	wkup_pmx2: pinctrl@0x4301c068 {
+		compatible = "pinctrl-single";
+		/* Proxy 0 addressing */
+		reg = <0x00 0x4301c068 0x00 0xec>;
+		#pinctrl-cells = <1>;
+		pinctrl-single,register-width = <32>;
+		pinctrl-single,function-mask = <0xffffffff>;
+	};
+
+	wkup_pmx3: pinctrl@0x4301c174 {
+		compatible = "pinctrl-single";
+		/* Proxy 0 addressing */
+		reg = <0x00 0x4301c174 0x00 0x20>;
 		#pinctrl-cells = <1>;
 		pinctrl-single,register-width = <32>;
 		pinctrl-single,function-mask = <0xffffffff>;
diff --git a/arch/m68k/68000/entry.S b/arch/m68k/68000/entry.S
index 997b54933015..7d63e2f1555a 100644
--- a/arch/m68k/68000/entry.S
+++ b/arch/m68k/68000/entry.S
@@ -45,6 +45,8 @@ do_trace:
 	jbsr	syscall_trace_enter
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
+	addql	#1,%d0
+	jeq	ret_from_exception
 	movel	%sp@(PT_OFF_ORIG_D0),%d1
 	movel	#-ENOSYS,%d0
 	cmpl	#NR_syscalls,%d1
diff --git a/arch/m68k/Kconfig.devices b/arch/m68k/Kconfig.devices
index 6a87b4a5fcac..e6e3efac1840 100644
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
index 9f337c70243a..35104c5417ff 100644
--- a/arch/m68k/coldfire/entry.S
+++ b/arch/m68k/coldfire/entry.S
@@ -90,6 +90,8 @@ ENTRY(system_call)
 	jbsr	syscall_trace_enter
 	RESTORE_SWITCH_STACK
 	addql	#4,%sp
+	addql	#1,%d0
+	jeq	ret_from_exception
 	movel	%d3,%a0
 	jbsr	%a0@
 	movel	%d0,%sp@(PT_OFF_D0)		/* save the return value */
diff --git a/arch/m68k/kernel/entry.S b/arch/m68k/kernel/entry.S
index 9434fca68de5..9f3663facaa0 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -184,9 +184,12 @@ do_trace_entry:
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
diff --git a/arch/mips/boot/dts/ingenic/ci20.dts b/arch/mips/boot/dts/ingenic/ci20.dts
index a688809beebc..74d49dc13438 100644
--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -99,7 +99,7 @@ otg_power: fixedregulator@2 {
 		regulator-min-microvolt = <5000000>;
 		regulator-max-microvolt = <5000000>;
 
-		gpio = <&gpf 14 GPIO_ACTIVE_LOW>;
+		gpio = <&gpf 15 GPIO_ACTIVE_LOW>;
 		enable-active-high;
 	};
 };
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
diff --git a/arch/powerpc/Makefile b/arch/powerpc/Makefile
index 7859ae56fcdc..a8e52e64c1a5 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -92,7 +92,7 @@ aflags-$(CONFIG_CPU_LITTLE_ENDIAN)	+= -mlittle-endian
 
 ifeq ($(HAS_BIARCH),y)
 KBUILD_CFLAGS	+= -m$(BITS)
-KBUILD_AFLAGS	+= -m$(BITS) -Wl,-a$(BITS)
+KBUILD_AFLAGS	+= -m$(BITS)
 KBUILD_LDFLAGS	+= -m elf$(BITS)$(LDEMULATION)
 endif
 
diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
index 7724af19ed7e..5172d5cec2c0 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -1171,15 +1171,12 @@ static inline void __radix__flush_tlb_range(struct mm_struct *mm,
 			}
 		}
 	} else {
-		bool hflush = false;
+		bool hflush;
 		unsigned long hstart, hend;
 
-		if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
-			hstart = (start + PMD_SIZE - 1) & PMD_MASK;
-			hend = end & PMD_MASK;
-			if (hstart < hend)
-				hflush = true;
-		}
+		hstart = (start + PMD_SIZE - 1) & PMD_MASK;
+		hend = end & PMD_MASK;
+		hflush = IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && hstart < hend;
 
 		if (type == FLUSH_TYPE_LOCAL) {
 			asm volatile("ptesync": : :"memory");
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index 337a686f941b..b3592be7fa60 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -13,7 +13,11 @@ LDFLAGS_vmlinux :=
 ifeq ($(CONFIG_DYNAMIC_FTRACE),y)
 	LDFLAGS_vmlinux := --no-relax
 	KBUILD_CPPFLAGS += -DCC_USING_PATCHABLE_FUNCTION_ENTRY
-	CC_FLAGS_FTRACE := -fpatchable-function-entry=8
+ifeq ($(CONFIG_RISCV_ISA_C),y)
+	CC_FLAGS_FTRACE := -fpatchable-function-entry=4
+else
+	CC_FLAGS_FTRACE := -fpatchable-function-entry=2
+endif
 endif
 
 ifeq ($(CONFIG_CMODEL_MEDLOW),y)
diff --git a/arch/riscv/include/asm/ftrace.h b/arch/riscv/include/asm/ftrace.h
index 04dad3380041..9e73922e1e2e 100644
--- a/arch/riscv/include/asm/ftrace.h
+++ b/arch/riscv/include/asm/ftrace.h
@@ -42,6 +42,14 @@ struct dyn_arch_ftrace {
  * 2) jalr: setting low-12 offset to ra, jump to ra, and set ra to
  *          return address (original pc + 4)
  *
+ *<ftrace enable>:
+ * 0: auipc  t0/ra, 0x?
+ * 4: jalr   t0/ra, ?(t0/ra)
+ *
+ *<ftrace disable>:
+ * 0: nop
+ * 4: nop
+ *
  * Dynamic ftrace generates probes to call sites, so we must deal with
  * both auipc and jalr at the same time.
  */
@@ -52,25 +60,43 @@ struct dyn_arch_ftrace {
 #define AUIPC_OFFSET_MASK	(0xfffff000)
 #define AUIPC_PAD		(0x00001000)
 #define JALR_SHIFT		20
-#define JALR_BASIC		(0x000080e7)
-#define AUIPC_BASIC		(0x00000097)
+#define JALR_RA			(0x000080e7)
+#define AUIPC_RA		(0x00000097)
+#define JALR_T0			(0x000282e7)
+#define AUIPC_T0		(0x00000297)
 #define NOP4			(0x00000013)
 
-#define make_call(caller, callee, call)					\
+#define to_jalr_t0(offset)						\
+	(((offset & JALR_OFFSET_MASK) << JALR_SHIFT) | JALR_T0)
+
+#define to_auipc_t0(offset)						\
+	((offset & JALR_SIGN_MASK) ?					\
+	(((offset & AUIPC_OFFSET_MASK) + AUIPC_PAD) | AUIPC_T0) :	\
+	((offset & AUIPC_OFFSET_MASK) | AUIPC_T0))
+
+#define make_call_t0(caller, callee, call)				\
 do {									\
-	call[0] = to_auipc_insn((unsigned int)((unsigned long)callee -	\
-				(unsigned long)caller));		\
-	call[1] = to_jalr_insn((unsigned int)((unsigned long)callee -	\
-			       (unsigned long)caller));			\
+	unsigned int offset =						\
+		(unsigned long) callee - (unsigned long) caller;	\
+	call[0] = to_auipc_t0(offset);					\
+	call[1] = to_jalr_t0(offset);					\
 } while (0)
 
-#define to_jalr_insn(offset)						\
-	(((offset & JALR_OFFSET_MASK) << JALR_SHIFT) | JALR_BASIC)
+#define to_jalr_ra(offset)						\
+	(((offset & JALR_OFFSET_MASK) << JALR_SHIFT) | JALR_RA)
 
-#define to_auipc_insn(offset)						\
+#define to_auipc_ra(offset)						\
 	((offset & JALR_SIGN_MASK) ?					\
-	(((offset & AUIPC_OFFSET_MASK) + AUIPC_PAD) | AUIPC_BASIC) :	\
-	((offset & AUIPC_OFFSET_MASK) | AUIPC_BASIC))
+	(((offset & AUIPC_OFFSET_MASK) + AUIPC_PAD) | AUIPC_RA) :	\
+	((offset & AUIPC_OFFSET_MASK) | AUIPC_RA))
+
+#define make_call_ra(caller, callee, call)				\
+do {									\
+	unsigned int offset =						\
+		(unsigned long) callee - (unsigned long) caller;	\
+	call[0] = to_auipc_ra(offset);					\
+	call[1] = to_jalr_ra(offset);					\
+} while (0)
 
 /*
  * Let auipc+jalr be the basic *mcount unit*, so we make it 8 bytes here.
diff --git a/arch/riscv/include/asm/jump_label.h b/arch/riscv/include/asm/jump_label.h
index 38af2ec7b9bf..729991e8f782 100644
--- a/arch/riscv/include/asm/jump_label.h
+++ b/arch/riscv/include/asm/jump_label.h
@@ -18,6 +18,7 @@ static __always_inline bool arch_static_branch(struct static_key *key,
 					       bool branch)
 {
 	asm_volatile_goto(
+		"	.align		2			\n\t"
 		"	.option push				\n\t"
 		"	.option norelax				\n\t"
 		"	.option norvc				\n\t"
@@ -39,6 +40,7 @@ static __always_inline bool arch_static_branch_jump(struct static_key *key,
 						    bool branch)
 {
 	asm_volatile_goto(
+		"	.align		2			\n\t"
 		"	.option push				\n\t"
 		"	.option norelax				\n\t"
 		"	.option norvc				\n\t"
diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 799c16e06525..39b550310ec6 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -386,7 +386,7 @@ static inline void update_mmu_cache(struct vm_area_struct *vma,
 	 * Relying on flush_tlb_fix_spurious_fault would suffice, but
 	 * the extra traps reduce performance.  So, eagerly SFENCE.VMA.
 	 */
-	flush_tlb_page(vma, address);
+	local_flush_tlb_page(address);
 }
 
 static inline void update_mmu_cache_pmd(struct vm_area_struct *vma,
diff --git a/arch/riscv/include/asm/thread_info.h b/arch/riscv/include/asm/thread_info.h
index e3866ffa06c5..42d97043e537 100644
--- a/arch/riscv/include/asm/thread_info.h
+++ b/arch/riscv/include/asm/thread_info.h
@@ -43,6 +43,7 @@
 #ifndef __ASSEMBLY__
 
 extern long shadow_stack[SHADOW_OVERFLOW_STACK_SIZE / sizeof(long)];
+extern unsigned long spin_shadow_stack;
 
 #include <asm/processor.h>
 #include <asm/csr.h>
diff --git a/arch/riscv/kernel/ftrace.c b/arch/riscv/kernel/ftrace.c
index 7f1e5203de88..47b43d8ee9a6 100644
--- a/arch/riscv/kernel/ftrace.c
+++ b/arch/riscv/kernel/ftrace.c
@@ -57,12 +57,15 @@ static int ftrace_check_current_call(unsigned long hook_pos,
 }
 
 static int __ftrace_modify_call(unsigned long hook_pos, unsigned long target,
-				bool enable)
+				bool enable, bool ra)
 {
 	unsigned int call[2];
 	unsigned int nops[2] = {NOP4, NOP4};
 
-	make_call(hook_pos, target, call);
+	if (ra)
+		make_call_ra(hook_pos, target, call);
+	else
+		make_call_t0(hook_pos, target, call);
 
 	/* Replace the auipc-jalr pair at once. Return -EPERM on write error. */
 	if (patch_text_nosync
@@ -72,42 +75,13 @@ static int __ftrace_modify_call(unsigned long hook_pos, unsigned long target,
 	return 0;
 }
 
-/*
- * Put 5 instructions with 16 bytes at the front of function within
- * patchable function entry nops' area.
- *
- * 0: REG_S  ra, -SZREG(sp)
- * 1: auipc  ra, 0x?
- * 2: jalr   -?(ra)
- * 3: REG_L  ra, -SZREG(sp)
- *
- * So the opcodes is:
- * 0: 0xfe113c23 (sd)/0xfe112e23 (sw)
- * 1: 0x???????? -> auipc
- * 2: 0x???????? -> jalr
- * 3: 0xff813083 (ld)/0xffc12083 (lw)
- */
-#if __riscv_xlen == 64
-#define INSN0	0xfe113c23
-#define INSN3	0xff813083
-#elif __riscv_xlen == 32
-#define INSN0	0xfe112e23
-#define INSN3	0xffc12083
-#endif
-
-#define FUNC_ENTRY_SIZE	16
-#define FUNC_ENTRY_JMP	4
-
 int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 {
-	unsigned int call[4] = {INSN0, 0, 0, INSN3};
-	unsigned long target = addr;
-	unsigned long caller = rec->ip + FUNC_ENTRY_JMP;
+	unsigned int call[2];
 
-	call[1] = to_auipc_insn((unsigned int)(target - caller));
-	call[2] = to_jalr_insn((unsigned int)(target - caller));
+	make_call_t0(rec->ip, addr, call);
 
-	if (patch_text_nosync((void *)rec->ip, call, FUNC_ENTRY_SIZE))
+	if (patch_text_nosync((void *)rec->ip, call, MCOUNT_INSN_SIZE))
 		return -EPERM;
 
 	return 0;
@@ -116,15 +90,14 @@ int ftrace_make_call(struct dyn_ftrace *rec, unsigned long addr)
 int ftrace_make_nop(struct module *mod, struct dyn_ftrace *rec,
 		    unsigned long addr)
 {
-	unsigned int nops[4] = {NOP4, NOP4, NOP4, NOP4};
+	unsigned int nops[2] = {NOP4, NOP4};
 
-	if (patch_text_nosync((void *)rec->ip, nops, FUNC_ENTRY_SIZE))
+	if (patch_text_nosync((void *)rec->ip, nops, MCOUNT_INSN_SIZE))
 		return -EPERM;
 
 	return 0;
 }
 
-
 /*
  * This is called early on, and isn't wrapped by
  * ftrace_arch_code_modify_{prepare,post_process}() and therefor doesn't hold
@@ -146,10 +119,10 @@ int ftrace_init_nop(struct module *mod, struct dyn_ftrace *rec)
 int ftrace_update_ftrace_func(ftrace_func_t func)
 {
 	int ret = __ftrace_modify_call((unsigned long)&ftrace_call,
-				       (unsigned long)func, true);
+				       (unsigned long)func, true, true);
 	if (!ret) {
 		ret = __ftrace_modify_call((unsigned long)&ftrace_regs_call,
-					   (unsigned long)func, true);
+					   (unsigned long)func, true, true);
 	}
 
 	return ret;
@@ -166,16 +139,16 @@ int ftrace_modify_call(struct dyn_ftrace *rec, unsigned long old_addr,
 		       unsigned long addr)
 {
 	unsigned int call[2];
-	unsigned long caller = rec->ip + FUNC_ENTRY_JMP;
+	unsigned long caller = rec->ip;
 	int ret;
 
-	make_call(caller, old_addr, call);
+	make_call_t0(caller, old_addr, call);
 	ret = ftrace_check_current_call(caller, call);
 
 	if (ret)
 		return ret;
 
-	return __ftrace_modify_call(caller, addr, true);
+	return __ftrace_modify_call(caller, addr, true, false);
 }
 #endif
 
@@ -210,12 +183,12 @@ int ftrace_enable_ftrace_graph_caller(void)
 	int ret;
 
 	ret = __ftrace_modify_call((unsigned long)&ftrace_graph_call,
-				    (unsigned long)&prepare_ftrace_return, true);
+				    (unsigned long)&prepare_ftrace_return, true, true);
 	if (ret)
 		return ret;
 
 	return __ftrace_modify_call((unsigned long)&ftrace_graph_regs_call,
-				    (unsigned long)&prepare_ftrace_return, true);
+				    (unsigned long)&prepare_ftrace_return, true, true);
 }
 
 int ftrace_disable_ftrace_graph_caller(void)
@@ -223,12 +196,12 @@ int ftrace_disable_ftrace_graph_caller(void)
 	int ret;
 
 	ret = __ftrace_modify_call((unsigned long)&ftrace_graph_call,
-				    (unsigned long)&prepare_ftrace_return, false);
+				    (unsigned long)&prepare_ftrace_return, false, true);
 	if (ret)
 		return ret;
 
 	return __ftrace_modify_call((unsigned long)&ftrace_graph_regs_call,
-				    (unsigned long)&prepare_ftrace_return, false);
+				    (unsigned long)&prepare_ftrace_return, false, true);
 }
 #endif /* CONFIG_DYNAMIC_FTRACE */
 #endif /* CONFIG_FUNCTION_GRAPH_TRACER */
diff --git a/arch/riscv/kernel/mcount-dyn.S b/arch/riscv/kernel/mcount-dyn.S
index d171eca623b6..125de818d1ba 100644
--- a/arch/riscv/kernel/mcount-dyn.S
+++ b/arch/riscv/kernel/mcount-dyn.S
@@ -13,8 +13,8 @@
 
 	.text
 
-#define FENTRY_RA_OFFSET	12
-#define ABI_SIZE_ON_STACK	72
+#define FENTRY_RA_OFFSET	8
+#define ABI_SIZE_ON_STACK	80
 #define ABI_A0			0
 #define ABI_A1			8
 #define ABI_A2			16
@@ -23,10 +23,10 @@
 #define ABI_A5			40
 #define ABI_A6			48
 #define ABI_A7			56
-#define ABI_RA			64
+#define ABI_T0			64
+#define ABI_RA			72
 
 	.macro SAVE_ABI
-	addi	sp, sp, -SZREG
 	addi	sp, sp, -ABI_SIZE_ON_STACK
 
 	REG_S	a0, ABI_A0(sp)
@@ -37,6 +37,7 @@
 	REG_S	a5, ABI_A5(sp)
 	REG_S	a6, ABI_A6(sp)
 	REG_S	a7, ABI_A7(sp)
+	REG_S	t0, ABI_T0(sp)
 	REG_S	ra, ABI_RA(sp)
 	.endm
 
@@ -49,24 +50,18 @@
 	REG_L	a5, ABI_A5(sp)
 	REG_L	a6, ABI_A6(sp)
 	REG_L	a7, ABI_A7(sp)
+	REG_L	t0, ABI_T0(sp)
 	REG_L	ra, ABI_RA(sp)
 
 	addi	sp, sp, ABI_SIZE_ON_STACK
-	addi	sp, sp, SZREG
 	.endm
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 	.macro SAVE_ALL
-	addi	sp, sp, -SZREG
 	addi	sp, sp, -PT_SIZE_ON_STACK
 
-	REG_S x1,  PT_EPC(sp)
-	addi	sp, sp, PT_SIZE_ON_STACK
-	REG_L x1,  (sp)
-	addi	sp, sp, -PT_SIZE_ON_STACK
+	REG_S t0,  PT_EPC(sp)
 	REG_S x1,  PT_RA(sp)
-	REG_L x1,  PT_EPC(sp)
-
 	REG_S x2,  PT_SP(sp)
 	REG_S x3,  PT_GP(sp)
 	REG_S x4,  PT_TP(sp)
@@ -100,15 +95,11 @@
 	.endm
 
 	.macro RESTORE_ALL
+	REG_L t0,  PT_EPC(sp)
 	REG_L x1,  PT_RA(sp)
-	addi	sp, sp, PT_SIZE_ON_STACK
-	REG_S x1,  (sp)
-	addi	sp, sp, -PT_SIZE_ON_STACK
-	REG_L x1,  PT_EPC(sp)
 	REG_L x2,  PT_SP(sp)
 	REG_L x3,  PT_GP(sp)
 	REG_L x4,  PT_TP(sp)
-	REG_L x5,  PT_T0(sp)
 	REG_L x6,  PT_T1(sp)
 	REG_L x7,  PT_T2(sp)
 	REG_L x8,  PT_S0(sp)
@@ -137,17 +128,16 @@
 	REG_L x31, PT_T6(sp)
 
 	addi	sp, sp, PT_SIZE_ON_STACK
-	addi	sp, sp, SZREG
 	.endm
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_REGS */
 
 ENTRY(ftrace_caller)
 	SAVE_ABI
 
-	addi	a0, ra, -FENTRY_RA_OFFSET
+	addi	a0, t0, -FENTRY_RA_OFFSET
 	la	a1, function_trace_op
 	REG_L	a2, 0(a1)
-	REG_L	a1, ABI_SIZE_ON_STACK(sp)
+	mv	a1, ra
 	mv	a3, sp
 
 ftrace_call:
@@ -155,8 +145,8 @@ ftrace_call:
 	call	ftrace_stub
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	addi	a0, sp, ABI_SIZE_ON_STACK
-	REG_L	a1, ABI_RA(sp)
+	addi	a0, sp, ABI_RA
+	REG_L	a1, ABI_T0(sp)
 	addi	a1, a1, -FENTRY_RA_OFFSET
 #ifdef HAVE_FUNCTION_GRAPH_FP_TEST
 	mv	a2, s0
@@ -166,17 +156,17 @@ ftrace_graph_call:
 	call	ftrace_stub
 #endif
 	RESTORE_ABI
-	ret
+	jr t0
 ENDPROC(ftrace_caller)
 
 #ifdef CONFIG_DYNAMIC_FTRACE_WITH_REGS
 ENTRY(ftrace_regs_caller)
 	SAVE_ALL
 
-	addi	a0, ra, -FENTRY_RA_OFFSET
+	addi	a0, t0, -FENTRY_RA_OFFSET
 	la	a1, function_trace_op
 	REG_L	a2, 0(a1)
-	REG_L	a1, PT_SIZE_ON_STACK(sp)
+	mv	a1, ra
 	mv	a3, sp
 
 ftrace_regs_call:
@@ -196,6 +186,6 @@ ftrace_graph_regs_call:
 #endif
 
 	RESTORE_ALL
-	ret
+	jr t0
 ENDPROC(ftrace_regs_caller)
 #endif /* CONFIG_DYNAMIC_FTRACE_WITH_REGS */
diff --git a/arch/riscv/kernel/time.c b/arch/riscv/kernel/time.c
index 8217b0f67c6c..1cf21db4fcc7 100644
--- a/arch/riscv/kernel/time.c
+++ b/arch/riscv/kernel/time.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/of_clk.h>
+#include <linux/clockchips.h>
 #include <linux/clocksource.h>
 #include <linux/delay.h>
 #include <asm/sbi.h>
@@ -29,6 +30,8 @@ void __init time_init(void)
 
 	of_clk_init(NULL);
 	timer_probe();
+
+	tick_setup_hrtimer_broadcast();
 }
 
 void clocksource_arch_init(struct clocksource *cs)
diff --git a/arch/riscv/mm/fault.c b/arch/riscv/mm/fault.c
index 676a3f28811f..884a3c76573c 100644
--- a/arch/riscv/mm/fault.c
+++ b/arch/riscv/mm/fault.c
@@ -271,10 +271,12 @@ asmlinkage void do_page_fault(struct pt_regs *regs)
 	if (user_mode(regs))
 		flags |= FAULT_FLAG_USER;
 
-	if (!user_mode(regs) && addr < TASK_SIZE &&
-			unlikely(!(regs->status & SR_SUM)))
-		die_kernel_fault("access to user memory without uaccess routines",
-				addr, regs);
+	if (!user_mode(regs) && addr < TASK_SIZE && unlikely(!(regs->status & SR_SUM))) {
+		if (fixup_exception(regs))
+			return;
+
+		die_kernel_fault("access to user memory without uaccess routines", addr, regs);
+	}
 
 	perf_sw_event(PERF_COUNT_SW_PAGE_FAULTS, 1, regs, addr);
 
diff --git a/arch/s390/boot/mem_detect.c b/arch/s390/boot/mem_detect.c
index 2f949cd9076b..17a32707d17e 100644
--- a/arch/s390/boot/mem_detect.c
+++ b/arch/s390/boot/mem_detect.c
@@ -165,7 +165,7 @@ static void search_mem_end(void)
 
 unsigned long detect_memory(void)
 {
-	unsigned long max_physmem_end;
+	unsigned long max_physmem_end = 0;
 
 	sclp_early_get_memsize(&max_physmem_end);
 
diff --git a/arch/s390/include/asm/ap.h b/arch/s390/include/asm/ap.h
index 3afbee21dc1f..859e6d87b108 100644
--- a/arch/s390/include/asm/ap.h
+++ b/arch/s390/include/asm/ap.h
@@ -236,7 +236,10 @@ static inline struct ap_queue_status ap_aqic(ap_qid_t qid,
 	union {
 		unsigned long value;
 		struct ap_qirq_ctrl qirqctrl;
-		struct ap_queue_status status;
+		struct {
+			u32 _pad;
+			struct ap_queue_status status;
+		};
 	} reg1;
 	void *reg2 = ind;
 
@@ -250,7 +253,7 @@ static inline struct ap_queue_status ap_aqic(ap_qid_t qid,
 		"	lgr	%[reg1],1\n"   /* gr1 (status) into reg1 */
 		: [reg1] "+&d" (reg1)
 		: [reg0] "d" (reg0), [reg2] "d" (reg2)
-		: "cc", "0", "1", "2");
+		: "cc", "memory", "0", "1", "2");
 
 	return reg1.status;
 }
@@ -287,7 +290,10 @@ static inline struct ap_queue_status ap_qact(ap_qid_t qid, int ifbit,
 	unsigned long reg0 = qid | (5UL << 24) | ((ifbit & 0x01) << 22);
 	union {
 		unsigned long value;
-		struct ap_queue_status status;
+		struct {
+			u32 _pad;
+			struct ap_queue_status status;
+		};
 	} reg1;
 	unsigned long reg2;
 
diff --git a/arch/s390/kernel/idle.c b/arch/s390/kernel/idle.c
index 4bf1ee293f2b..a0da049e7360 100644
--- a/arch/s390/kernel/idle.c
+++ b/arch/s390/kernel/idle.c
@@ -44,7 +44,7 @@ void account_idle_time_irq(void)
 	S390_lowcore.last_update_timer = idle->timer_idle_exit;
 }
 
-void arch_cpu_idle(void)
+void noinstr arch_cpu_idle(void)
 {
 	struct s390_idle_data *idle = this_cpu_ptr(&s390_idle);
 	unsigned long idle_time;
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index 952d44b0610b..fbc0bf417ec6 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -233,6 +233,7 @@ static void pop_kprobe(struct kprobe_ctlblk *kcb)
 {
 	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
+	kcb->prev_kprobe.kp = NULL;
 }
 NOKPROBE_SYMBOL(pop_kprobe);
 
@@ -394,12 +395,11 @@ static int post_kprobe_handler(struct pt_regs *regs)
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
 
diff --git a/arch/s390/kernel/vdso32/Makefile b/arch/s390/kernel/vdso32/Makefile
index e3e6ac5686df..245bddfe9bc0 100644
--- a/arch/s390/kernel/vdso32/Makefile
+++ b/arch/s390/kernel/vdso32/Makefile
@@ -22,7 +22,7 @@ KBUILD_AFLAGS_32 += -m31 -s
 KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
 KBUILD_CFLAGS_32 += -m31 -fPIC -shared -fno-common -fno-builtin
 
-LDFLAGS_vdso32.so.dbg += -fPIC -shared -nostdlib -soname=linux-vdso32.so.1 \
+LDFLAGS_vdso32.so.dbg += -fPIC -shared -soname=linux-vdso32.so.1 \
 	--hash-style=both --build-id=sha1 -melf_s390 -T
 
 $(targets:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_32)
diff --git a/arch/s390/kernel/vdso64/Makefile b/arch/s390/kernel/vdso64/Makefile
index 0dea82b87e54..1605ba45ac4c 100644
--- a/arch/s390/kernel/vdso64/Makefile
+++ b/arch/s390/kernel/vdso64/Makefile
@@ -25,8 +25,8 @@ KBUILD_AFLAGS_64 := $(filter-out -m64,$(KBUILD_AFLAGS))
 KBUILD_AFLAGS_64 += -m64 -s
 
 KBUILD_CFLAGS_64 := $(filter-out -m64,$(KBUILD_CFLAGS))
-KBUILD_CFLAGS_64 += -m64 -fPIC -shared -fno-common -fno-builtin
-ldflags-y := -fPIC -shared -nostdlib -soname=linux-vdso64.so.1 \
+KBUILD_CFLAGS_64 += -m64 -fPIC -fno-common -fno-builtin
+ldflags-y := -fPIC -shared -soname=linux-vdso64.so.1 \
 	     --hash-style=both --build-id=sha1 -T
 
 $(targets:%=$(obj)/%.dbg): KBUILD_CFLAGS = $(KBUILD_CFLAGS_64)
diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
index 8ce1615c1046..29059a1aed53 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -227,5 +227,6 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(.eh_frame)
+		*(.interp)
 	}
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index c61533e1448a..d7aa442ceaf1 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5066,6 +5066,23 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
 	/* When we are protected, we should not change the memory slots */
 	if (kvm_s390_pv_get_handle(kvm))
 		return -EINVAL;
+
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
 
diff --git a/arch/s390/mm/extmem.c b/arch/s390/mm/extmem.c
index 5060956b8e7d..1bc42ce26599 100644
--- a/arch/s390/mm/extmem.c
+++ b/arch/s390/mm/extmem.c
@@ -289,15 +289,17 @@ segment_overlaps_others (struct dcss_segment *seg)
 
 /*
  * real segment loading function, called from segment_load
+ * Must return either an error code < 0, or the segment type code >= 0
  */
 static int
 __segment_load (char *name, int do_nonshared, unsigned long *addr, unsigned long *end)
 {
 	unsigned long start_addr, end_addr, dummy;
 	struct dcss_segment *seg;
-	int rc, diag_cc;
+	int rc, diag_cc, segtype;
 
 	start_addr = end_addr = 0;
+	segtype = -1;
 	seg = kmalloc(sizeof(*seg), GFP_KERNEL | GFP_DMA);
 	if (seg == NULL) {
 		rc = -ENOMEM;
@@ -326,9 +328,9 @@ __segment_load (char *name, int do_nonshared, unsigned long *addr, unsigned long
 	seg->res_name[8] = '\0';
 	strlcat(seg->res_name, " (DCSS)", sizeof(seg->res_name));
 	seg->res->name = seg->res_name;
-	rc = seg->vm_segtype;
-	if (rc == SEG_TYPE_SC ||
-	    ((rc == SEG_TYPE_SR || rc == SEG_TYPE_ER) && !do_nonshared))
+	segtype = seg->vm_segtype;
+	if (segtype == SEG_TYPE_SC ||
+	    ((segtype == SEG_TYPE_SR || segtype == SEG_TYPE_ER) && !do_nonshared))
 		seg->res->flags |= IORESOURCE_READONLY;
 
 	/* Check for overlapping resources before adding the mapping. */
@@ -386,7 +388,7 @@ __segment_load (char *name, int do_nonshared, unsigned long *addr, unsigned long
  out_free:
 	kfree(seg);
  out:
-	return rc;
+	return rc < 0 ? rc : segtype;
 }
 
 /*
diff --git a/arch/s390/mm/vmem.c b/arch/s390/mm/vmem.c
index 2b1c6d916cf9..39912629b061 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -297,7 +297,7 @@ static void try_free_pmd_table(pud_t *pud, unsigned long start)
 	if (end > VMALLOC_START)
 		return;
 #ifdef CONFIG_KASAN
-	if (start < KASAN_SHADOW_END && KASAN_SHADOW_START > end)
+	if (start < KASAN_SHADOW_END && end > KASAN_SHADOW_START)
 		return;
 #endif
 	pmd = pmd_offset(pud, start);
@@ -372,7 +372,7 @@ static void try_free_pud_table(p4d_t *p4d, unsigned long start)
 	if (end > VMALLOC_START)
 		return;
 #ifdef CONFIG_KASAN
-	if (start < KASAN_SHADOW_END && KASAN_SHADOW_START > end)
+	if (start < KASAN_SHADOW_END && end > KASAN_SHADOW_START)
 		return;
 #endif
 
@@ -426,7 +426,7 @@ static void try_free_p4d_table(pgd_t *pgd, unsigned long start)
 	if (end > VMALLOC_START)
 		return;
 #ifdef CONFIG_KASAN
-	if (start < KASAN_SHADOW_END && KASAN_SHADOW_START > end)
+	if (start < KASAN_SHADOW_END && end > KASAN_SHADOW_START)
 		return;
 #endif
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index b120ed947f50..eff9116bf7be 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -286,7 +286,7 @@ config FORCE_MAX_ZONEORDER
 	  This config option is actually maximum order plus one. For example,
 	  a value of 13 means that the largest free memory block is 2^12 pages.
 
-if SPARC64
+if SPARC64 || COMPILE_TEST
 source "kernel/power/Kconfig"
 endif
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0f2234cd8453..a08ce6360382 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1320,17 +1320,16 @@ config MICROCODE_AMD
 	  If you select this option, microcode patch loading support for AMD
 	  processors will be enabled.
 
-config MICROCODE_OLD_INTERFACE
-	bool "Ancient loading interface (DEPRECATED)"
+config MICROCODE_LATE_LOADING
+	bool "Late microcode loading (DANGEROUS)"
 	default n
 	depends on MICROCODE
 	help
-	  DO NOT USE THIS! This is the ancient /dev/cpu/microcode interface
-	  which was used by userspace tools like iucode_tool and microcode.ctl.
-	  It is inadequate because it runs too late to be able to properly
-	  load microcode on a machine and it needs special tools. Instead, you
-	  should've switched to the early loading method with the initrd or
-	  builtin microcode by now: Documentation/x86/microcode.rst
+	  Loading microcode late, when the system is up and executing instructions
+	  is a tricky business and should be avoided if possible. Just the sequence
+	  of synchronizing all cores and SMT threads is one fragile dance which does
+	  not guarantee that cores might not softlock after the loading. Therefore,
+	  use this at your own risk. Late loading taints the kernel too.
 
 config X86_MSR
 	tristate "/dev/cpu/*/msr - Model-specific register support"
diff --git a/arch/x86/crypto/ghash-clmulni-intel_glue.c b/arch/x86/crypto/ghash-clmulni-intel_glue.c
index 1f1a95f3dd0c..c0ab0ff4af65 100644
--- a/arch/x86/crypto/ghash-clmulni-intel_glue.c
+++ b/arch/x86/crypto/ghash-clmulni-intel_glue.c
@@ -19,6 +19,7 @@
 #include <crypto/internal/simd.h>
 #include <asm/cpu_device_id.h>
 #include <asm/simd.h>
+#include <asm/unaligned.h>
 
 #define GHASH_BLOCK_SIZE	16
 #define GHASH_DIGEST_SIZE	16
@@ -54,15 +55,14 @@ static int ghash_setkey(struct crypto_shash *tfm,
 			const u8 *key, unsigned int keylen)
 {
 	struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
-	be128 *x = (be128 *)key;
 	u64 a, b;
 
 	if (keylen != GHASH_BLOCK_SIZE)
 		return -EINVAL;
 
 	/* perform multiplication by 'x' in GF(2^128) */
-	a = be64_to_cpu(x->a);
-	b = be64_to_cpu(x->b);
+	a = get_unaligned_be64(key);
+	b = get_unaligned_be64(key + 8);
 
 	ctx->shash.a = (b << 1) | (a >> 63);
 	ctx->shash.b = (a << 1) | (b >> 63);
diff --git a/arch/x86/events/zhaoxin/core.c b/arch/x86/events/zhaoxin/core.c
index 949d845c922b..3e9acdaeed1e 100644
--- a/arch/x86/events/zhaoxin/core.c
+++ b/arch/x86/events/zhaoxin/core.c
@@ -541,7 +541,13 @@ __init int zhaoxin_pmu_init(void)
 
 	switch (boot_cpu_data.x86) {
 	case 0x06:
-		if (boot_cpu_data.x86_model == 0x0f || boot_cpu_data.x86_model == 0x19) {
+		/*
+		 * Support Zhaoxin CPU from ZXC series, exclude Nano series through FMS.
+		 * Nano FMS: Family=6, Model=F, Stepping=[0-A][C-D]
+		 * ZXC FMS: Family=6, Model=F, Stepping=E-F OR Family=6, Model=0x19, Stepping=0-3
+		 */
+		if ((boot_cpu_data.x86_model == 0x0f && boot_cpu_data.x86_stepping >= 0x0e) ||
+			boot_cpu_data.x86_model == 0x19) {
 
 			x86_pmu.max_period = x86_pmu.cntval_mask >> 1;
 
diff --git a/arch/x86/include/asm/microcode.h b/arch/x86/include/asm/microcode.h
index d130d21f4862..1bf064a14b95 100644
--- a/arch/x86/include/asm/microcode.h
+++ b/arch/x86/include/asm/microcode.h
@@ -130,14 +130,14 @@ static inline unsigned int x86_cpuid_family(void)
 #ifdef CONFIG_MICROCODE
 extern void __init load_ucode_bsp(void);
 extern void load_ucode_ap(void);
-void reload_early_microcode(void);
+void reload_early_microcode(unsigned int cpu);
 extern bool get_builtin_firmware(struct cpio_data *cd, const char *name);
 extern bool initrd_gone;
 void microcode_bsp_resume(void);
 #else
 static inline void __init load_ucode_bsp(void)			{ }
 static inline void load_ucode_ap(void)				{ }
-static inline void reload_early_microcode(void)			{ }
+static inline void reload_early_microcode(unsigned int cpu)	{ }
 static inline void microcode_bsp_resume(void)			{ }
 static inline bool
 get_builtin_firmware(struct cpio_data *cd, const char *name)	{ return false; }
diff --git a/arch/x86/include/asm/microcode_amd.h b/arch/x86/include/asm/microcode_amd.h
index 7063b5a43220..a645b25ee442 100644
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
-static inline void reload_ucode_amd(void) {}
+static inline void reload_ucode_amd(unsigned int cpu) {}
 #endif
 #endif /* _ASM_X86_MICROCODE_AMD_H */
diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
index f069ab09c5fc..3588b799c63f 100644
--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -54,6 +54,10 @@
 #define SPEC_CTRL_RRSBA_DIS_S_SHIFT	6	   /* Disable RRSBA behavior */
 #define SPEC_CTRL_RRSBA_DIS_S		BIT(SPEC_CTRL_RRSBA_DIS_S_SHIFT)
 
+/* A mask for bits which the kernel toggles when controlling mitigations */
+#define SPEC_CTRL_MITIGATIONS_MASK	(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD \
+							| SPEC_CTRL_RRSBA_DIS_S)
+
 #define MSR_IA32_PRED_CMD		0x00000049 /* Prediction Command */
 #define PRED_CMD_IBPB			BIT(0)	   /* Indirect Branch Prediction Barrier */
 
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 577f342dbfb2..3e3bd5b7d5db 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -834,8 +834,9 @@ bool xen_set_default_idle(void);
 #define xen_set_default_idle 0
 #endif
 
-void stop_this_cpu(void *dummy);
-void microcode_check(void);
+void __noreturn stop_this_cpu(void *dummy);
+void microcode_check(struct cpuinfo_x86 *prev_info);
+void store_cpu_caps(struct cpuinfo_x86 *info);
 
 enum l1tf_mitigations {
 	L1TF_MITIGATION_OFF,
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
diff --git a/arch/x86/include/asm/virtext.h b/arch/x86/include/asm/virtext.h
index 8757078d4442..3b12e6b99412 100644
--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -126,7 +126,21 @@ static inline void cpu_svm_disable(void)
 
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
index 544e6c61e17d..2627e97e6e2e 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -144,9 +144,17 @@ void __init check_bugs(void)
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
@@ -1095,14 +1103,18 @@ spectre_v2_parse_user_cmdline(void)
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
@@ -1165,12 +1177,19 @@ spectre_v2_user_select_mitigation(void)
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
@@ -2297,7 +2316,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return "";
 
 	switch (spectre_v2_user_stibp) {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 1698470dbea5..f7b4bbe71cdf 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2149,35 +2149,52 @@ void cpu_init_secondary(void)
 }
 #endif
 
-/*
+#ifdef CONFIG_MICROCODE_LATE_LOADING
+/**
+ * store_cpu_caps() - Store a snapshot of CPU capabilities
+ * @curr_info: Pointer where to store it
+ *
+ * Returns: None
+ */
+void store_cpu_caps(struct cpuinfo_x86 *curr_info)
+{
+	/* Reload CPUID max function as it might've changed. */
+	curr_info->cpuid_level = cpuid_eax(0);
+
+	/* Copy all capability leafs and pick up the synthetic ones. */
+	memcpy(&curr_info->x86_capability, &boot_cpu_data.x86_capability,
+	       sizeof(curr_info->x86_capability));
+
+	/* Get the hardware CPUID leafs */
+	get_cpu_cap(curr_info);
+}
+
+/**
+ * microcode_check() - Check if any CPU capabilities changed after an update.
+ * @prev_info:	CPU capabilities stored before an update.
+ *
  * The microcode loader calls this upon late microcode load to recheck features,
  * only when microcode has been updated. Caller holds microcode_mutex and CPU
  * hotplug lock.
+ *
+ * Return: None
  */
-void microcode_check(void)
+void microcode_check(struct cpuinfo_x86 *prev_info)
 {
-	struct cpuinfo_x86 info;
+	struct cpuinfo_x86 curr_info;
 
 	perf_check_microcode();
 
-	/* Reload CPUID max function as it might've changed. */
-	info.cpuid_level = cpuid_eax(0);
-
-	/*
-	 * Copy all capability leafs to pick up the synthetic ones so that
-	 * memcmp() below doesn't fail on that. The ones coming from CPUID will
-	 * get overwritten in get_cpu_cap().
-	 */
-	memcpy(&info.x86_capability, &boot_cpu_data.x86_capability, sizeof(info.x86_capability));
+	store_cpu_caps(&curr_info);
 
-	get_cpu_cap(&info);
-
-	if (!memcmp(&info.x86_capability, &boot_cpu_data.x86_capability, sizeof(info.x86_capability)))
+	if (!memcmp(&prev_info->x86_capability, &curr_info.x86_capability,
+		    sizeof(prev_info->x86_capability)))
 		return;
 
 	pr_warn("x86/CPU: CPU features have changed after loading microcode, but might not take effect.\n");
 	pr_warn("x86/CPU: Please consider either early loading through initrd/built-in or a potential BIOS update.\n");
 }
+#endif
 
 /*
  * Invoked from core CPU hotplug code after hotplug operations
diff --git a/arch/x86/kernel/cpu/microcode/amd.c b/arch/x86/kernel/cpu/microcode/amd.c
index 7c758f1afbf0..9bffe40e97d3 100644
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
@@ -428,7 +430,7 @@ apply_microcode_early_amd(u32 cpuid_1_eax, void *ucode, size_t size, bool save_p
 	patch	= (u8 (*)[PATCH_MAX_SIZE])__pa_nodebug(&amd_ucode_patch);
 #else
 	new_rev = &ucode_new_rev;
-	patch	= &amd_ucode_patch;
+	patch	= &amd_ucode_patch[0];
 #endif
 
 	desc.cpuid_1_eax = cpuid_1_eax;
@@ -547,8 +549,7 @@ void load_ucode_amd_ap(unsigned int cpuid_1_eax)
 	apply_microcode_early_amd(cpuid_1_eax, cp.data, cp.size, false);
 }
 
-static enum ucode_state
-load_microcode_amd(bool save, u8 family, const u8 *data, size_t size);
+static enum ucode_state load_microcode_amd(u8 family, const u8 *data, size_t size);
 
 int __init save_microcode_in_initrd_amd(unsigned int cpuid_1_eax)
 {
@@ -566,19 +567,19 @@ int __init save_microcode_in_initrd_amd(unsigned int cpuid_1_eax)
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
 	u32 rev, dummy __always_unused;
+	struct microcode_amd *mc;
 
-	mc = (struct microcode_amd *)amd_ucode_patch;
+	mc = (struct microcode_amd *)amd_ucode_patch[cpu_to_node(cpu)];
 
 	rdmsr(MSR_AMD64_PATCH_LEVEL, rev, dummy);
 
@@ -844,9 +845,10 @@ static enum ucode_state __load_microcode_amd(u8 family, const u8 *data,
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
 
@@ -859,22 +861,22 @@ load_microcode_amd(bool save, u8 family, const u8 *data, size_t size)
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
@@ -900,12 +902,11 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
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
@@ -920,7 +921,7 @@ static enum ucode_state request_microcode_amd(int cpu, struct device *device,
 	if (!verify_container(fw->data, fw->size, false))
 		goto fw_release;
 
-	ret = load_microcode_amd(bsp, c->x86, fw->data, fw->size);
+	ret = load_microcode_amd(c->x86, fw->data, fw->size);
 
  fw_release:
 	release_firmware(fw);
diff --git a/arch/x86/kernel/cpu/microcode/core.c b/arch/x86/kernel/cpu/microcode/core.c
index 150ebfb8c12e..d2f00d77e9ad 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -315,7 +315,7 @@ struct cpio_data find_microcode_in_initrd(const char *path, bool use_pa)
 #endif
 }
 
-void reload_early_microcode(void)
+void reload_early_microcode(unsigned int cpu)
 {
 	int vendor, family;
 
@@ -329,7 +329,7 @@ void reload_early_microcode(void)
 		break;
 	case X86_VENDOR_AMD:
 		if (family >= 0x10)
-			reload_ucode_amd();
+			reload_ucode_amd(cpu);
 		break;
 	default:
 		break;
@@ -390,101 +390,10 @@ static int apply_microcode_on_target(int cpu)
 	return ret;
 }
 
-#ifdef CONFIG_MICROCODE_OLD_INTERFACE
-static int do_microcode_update(const void __user *buf, size_t size)
-{
-	int error = 0;
-	int cpu;
-
-	for_each_online_cpu(cpu) {
-		struct ucode_cpu_info *uci = ucode_cpu_info + cpu;
-		enum ucode_state ustate;
-
-		if (!uci->valid)
-			continue;
-
-		ustate = microcode_ops->request_microcode_user(cpu, buf, size);
-		if (ustate == UCODE_ERROR) {
-			error = -1;
-			break;
-		} else if (ustate == UCODE_NEW) {
-			apply_microcode_on_target(cpu);
-		}
-	}
-
-	return error;
-}
-
-static int microcode_open(struct inode *inode, struct file *file)
-{
-	return capable(CAP_SYS_RAWIO) ? stream_open(inode, file) : -EPERM;
-}
-
-static ssize_t microcode_write(struct file *file, const char __user *buf,
-			       size_t len, loff_t *ppos)
-{
-	ssize_t ret = -EINVAL;
-	unsigned long nr_pages = totalram_pages();
-
-	if ((len >> PAGE_SHIFT) > nr_pages) {
-		pr_err("too much data (max %ld pages)\n", nr_pages);
-		return ret;
-	}
-
-	cpus_read_lock();
-	mutex_lock(&microcode_mutex);
-
-	if (do_microcode_update(buf, len) == 0)
-		ret = (ssize_t)len;
-
-	if (ret > 0)
-		perf_check_microcode();
-
-	mutex_unlock(&microcode_mutex);
-	cpus_read_unlock();
-
-	return ret;
-}
-
-static const struct file_operations microcode_fops = {
-	.owner			= THIS_MODULE,
-	.write			= microcode_write,
-	.open			= microcode_open,
-	.llseek		= no_llseek,
-};
-
-static struct miscdevice microcode_dev = {
-	.minor			= MICROCODE_MINOR,
-	.name			= "microcode",
-	.nodename		= "cpu/microcode",
-	.fops			= &microcode_fops,
-};
-
-static int __init microcode_dev_init(void)
-{
-	int error;
-
-	error = misc_register(&microcode_dev);
-	if (error) {
-		pr_err("can't misc_register on minor=%d\n", MICROCODE_MINOR);
-		return error;
-	}
-
-	return 0;
-}
-
-static void __exit microcode_dev_exit(void)
-{
-	misc_deregister(&microcode_dev);
-}
-#else
-#define microcode_dev_init()	0
-#define microcode_dev_exit()	do { } while (0)
-#endif
-
 /* fake device for request_firmware */
 static struct platform_device	*microcode_pdev;
 
+#ifdef CONFIG_MICROCODE_LATE_LOADING
 /*
  * Late loading dance. Why the heavy-handed stomp_machine effort?
  *
@@ -599,16 +508,27 @@ static int __reload_late(void *info)
  */
 static int microcode_reload_late(void)
 {
-	int ret;
+	int old = boot_cpu_data.microcode, ret;
+	struct cpuinfo_x86 prev_info;
 
 	atomic_set(&late_cpus_in,  0);
 	atomic_set(&late_cpus_out, 0);
 
-	ret = stop_machine_cpuslocked(__reload_late, NULL, cpu_online_mask);
-	if (ret == 0)
-		microcode_check();
+	/*
+	 * Take a snapshot before the microcode update in order to compare and
+	 * check whether any bits changed after an update.
+	 */
+	store_cpu_caps(&prev_info);
 
-	pr_info("Reload completed, microcode revision: 0x%x\n", boot_cpu_data.microcode);
+	ret = stop_machine_cpuslocked(__reload_late, NULL, cpu_online_mask);
+	if (!ret) {
+		pr_info("Reload succeeded, microcode revision: 0x%x -> 0x%x\n",
+			old, boot_cpu_data.microcode);
+		microcode_check(&prev_info);
+	} else {
+		pr_info("Reload failed, current microcode revision: 0x%x\n",
+			boot_cpu_data.microcode);
+	}
 
 	return ret;
 }
@@ -652,6 +572,9 @@ static ssize_t reload_store(struct device *dev,
 	return ret;
 }
 
+static DEVICE_ATTR_WO(reload);
+#endif
+
 static ssize_t version_show(struct device *dev,
 			struct device_attribute *attr, char *buf)
 {
@@ -668,7 +591,6 @@ static ssize_t pf_show(struct device *dev,
 	return sprintf(buf, "0x%x\n", uci->cpu_sig.pf);
 }
 
-static DEVICE_ATTR_WO(reload);
 static DEVICE_ATTR(version, 0444, version_show, NULL);
 static DEVICE_ATTR(processor_flags, 0444, pf_show, NULL);
 
@@ -785,7 +707,7 @@ void microcode_bsp_resume(void)
 	if (uci->valid && uci->mc)
 		microcode_ops->apply_microcode(cpu);
 	else if (!uci->mc)
-		reload_early_microcode();
+		reload_early_microcode(cpu);
 }
 
 static struct syscore_ops mc_syscore_ops = {
@@ -821,7 +743,9 @@ static int mc_cpu_down_prep(unsigned int cpu)
 }
 
 static struct attribute *cpu_root_microcode_attrs[] = {
+#ifdef CONFIG_MICROCODE_LATE_LOADING
 	&dev_attr_reload.attr,
+#endif
 	NULL
 };
 
@@ -873,10 +797,6 @@ static int __init microcode_init(void)
 		goto out_driver;
 	}
 
-	error = microcode_dev_init();
-	if (error)
-		goto out_ucode_group;
-
 	register_syscore_ops(&mc_syscore_ops);
 	cpuhp_setup_state_nocalls(CPUHP_AP_MICROCODE_LOADER, "x86/microcode:starting",
 				  mc_cpu_starting, NULL);
@@ -887,10 +807,6 @@ static int __init microcode_init(void)
 
 	return 0;
 
- out_ucode_group:
-	sysfs_remove_group(&cpu_subsys.dev_root->kobj,
-			   &cpu_root_microcode_group);
-
  out_driver:
 	cpus_read_lock();
 	mutex_lock(&microcode_mutex);
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 03a454d427c3..97b9212a6aab 100644
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
@@ -81,15 +80,6 @@ static void kdump_nmi_callback(int cpu, struct pt_regs *regs)
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
@@ -148,12 +138,7 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
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
index a9121073d951..98d0e2012e1f 100644
--- a/arch/x86/kernel/kprobes/opt.c
+++ b/arch/x86/kernel/kprobes/opt.c
@@ -46,8 +46,8 @@ unsigned long __recover_optprobed_insn(kprobe_opcode_t *buf, unsigned long addr)
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
@@ -346,7 +346,7 @@ int arch_check_optimized_kprobe(struct optimized_kprobe *op)
 
 	for (i = 1; i < op->optinsn.size; i++) {
 		p = get_kprobe(op->kp.addr + i);
-		if (p && !kprobe_disabled(p))
+		if (p && !kprobe_disarmed(p))
 			return -EEXIST;
 	}
 
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index bc9b4b93cf9b..e6b28c689e9a 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -731,7 +731,7 @@ bool xen_set_default_idle(void)
 }
 #endif
 
-void stop_this_cpu(void *dummy)
+void __noreturn stop_this_cpu(void *dummy)
 {
 	local_irq_disable();
 	/*
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index fa700b46588e..deedd77c7593 100644
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
 
@@ -590,7 +586,7 @@ static void native_machine_emergency_restart(void)
 	unsigned short mode;
 
 	if (reboot_emergency)
-		emergency_vmx_disable_all();
+		emergency_reboot_disable_virtualization();
 
 	tboot_shutdown(TB_SHUTDOWN_REBOOT);
 
@@ -795,6 +791,17 @@ void machine_crash_shutdown(struct pt_regs *regs)
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
@@ -817,7 +824,14 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
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
@@ -828,18 +842,32 @@ static int crash_nmi_callback(unsigned int val, struct pt_regs *regs)
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
 
@@ -867,7 +895,17 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
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
@@ -897,6 +935,8 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
 	/* No other CPUs to shoot down */
 }
 
+static inline void nmi_shootdown_cpus_on_restart(void) { }
+
 void run_crash_ipi_callback(struct pt_regs *regs)
 {
 }
diff --git a/arch/x86/kernel/smp.c b/arch/x86/kernel/smp.c
index 06db901fabe8..375b33ecafa2 100644
--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -32,7 +32,7 @@
 #include <asm/mce.h>
 #include <asm/trace/irq_vectors.h>
 #include <asm/kexec.h>
-#include <asm/virtext.h>
+#include <asm/reboot.h>
 
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
@@ -122,7 +122,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 	if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
 		return NMI_HANDLED;
 
-	cpu_emergency_vmxoff();
+	cpu_emergency_disable_virtualization();
 	stop_this_cpu(NULL);
 
 	return NMI_HANDLED;
@@ -134,7 +134,7 @@ static int smp_stop_nmi_callback(unsigned int val, struct pt_regs *regs)
 DEFINE_IDTENTRY_SYSVEC(sysvec_reboot)
 {
 	ack_APIC_irq();
-	cpu_emergency_vmxoff();
+	cpu_emergency_disable_virtualization();
 	stop_this_cpu(NULL);
 }
 
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 8ea4658f48ef..25530a908b4c 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2127,10 +2127,14 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
 		break;
 
 	case APIC_SELF_IPI:
-		if (apic_x2apic_mode(apic))
-			kvm_apic_send_ipi(apic, APIC_DEST_SELF | (val & APIC_VECTOR_MASK), 0);
-		else
+		/*
+		 * Self-IPI exists only when x2APIC is enabled.  Bits 7:0 hold
+		 * the vector, everything else is reserved.
+		 */
+		if (!apic_x2apic_mode(apic) || (val & ~APIC_VECTOR_MASK))
 			ret = 1;
+		else
+			kvm_apic_send_ipi(apic, APIC_DEST_SELF | val, 0);
 		break;
 	default:
 		ret = 1;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index eeedcb3d40e8..93d73b55ae3e 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -1277,7 +1277,7 @@ static int sev_send_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Check if we are crossing the page boundary */
 	offset = params.guest_uaddr & (PAGE_SIZE - 1);
-	if ((params.guest_len + offset > PAGE_SIZE))
+	if (params.guest_len > PAGE_SIZE || (params.guest_len + offset) > PAGE_SIZE)
 		return -EINVAL;
 
 	/* Pin guest memory */
@@ -1457,7 +1457,7 @@ static int sev_receive_update_data(struct kvm *kvm, struct kvm_sev_cmd *argp)
 
 	/* Check if we are crossing the page boundary */
 	offset = params.guest_uaddr & (PAGE_SIZE - 1);
-	if ((params.guest_len + offset > PAGE_SIZE))
+	if (params.guest_len > PAGE_SIZE || (params.guest_len + offset) > PAGE_SIZE)
 		return -EINVAL;
 
 	hdr = psp_copy_user_blob(params.hdr_uaddr, params.hdr_len);
diff --git a/arch/x86/kvm/svm/svm_onhyperv.h b/arch/x86/kvm/svm/svm_onhyperv.h
index c53b8bf8d013..3a0c3814a377 100644
--- a/arch/x86/kvm/svm/svm_onhyperv.h
+++ b/arch/x86/kvm/svm/svm_onhyperv.h
@@ -48,7 +48,7 @@ static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 		hve->hv_enlightenments_control.enlightened_npt_tlb = 1;
 }
 
-static inline void svm_hv_hardware_setup(void)
+static inline __init void svm_hv_hardware_setup(void)
 {
 	if (npt_enabled &&
 	    ms_hyperv.nested_features & HV_X64_NESTED_ENLIGHTENED_TLB) {
@@ -112,7 +112,7 @@ static inline void svm_hv_init_vmcb(struct vmcb *vmcb)
 {
 }
 
-static inline void svm_hv_hardware_setup(void)
+static inline __init void svm_hv_hardware_setup(void)
 {
 }
 
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 4a7c33ed9a66..4f34ac27c47d 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -417,6 +417,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	bip->bip_vcnt = bip_src->bip_vcnt;
 	bip->bip_iter = bip_src->bip_iter;
+	bip->bip_flags = bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
 
 	return 0;
 }
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 069193dee95b..bd7e9ffa5d40 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -870,9 +870,14 @@ static void calc_lcoefs(u64 bps, u64 seqiops, u64 randiops,
 
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
index 35770e33c817..ff1021dbb0d2 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -45,8 +45,7 @@ void blk_mq_sched_assign_ioc(struct request *rq)
 }
 
 /*
- * Mark a hardware queue as needing a restart. For shared queues, maintain
- * a count of how many hardware queues are marked for restart.
+ * Mark a hardware queue as needing a restart.
  */
 void blk_mq_sched_mark_restart_hctx(struct blk_mq_hw_ctx *hctx)
 {
@@ -110,7 +109,7 @@ static bool blk_mq_dispatch_hctx_list(struct list_head *rq_list)
 /*
  * Only SCSI implements .get_budget and .put_budget, and SCSI restarts
  * its queue by itself in its completion handler, so we don't need to
- * restart queue if .get_budget() returns BLK_STS_NO_RESOURCE.
+ * restart queue if .get_budget() fails to get the budget.
  *
  * Returns -EAGAIN if hctx->dispatch was found non-empty and run_work has to
  * be run again.  This is necessary to avoid starving flushes.
@@ -238,7 +237,7 @@ static struct blk_mq_ctx *blk_mq_next_ctx(struct blk_mq_hw_ctx *hctx,
 /*
  * Only SCSI implements .get_budget and .put_budget, and SCSI restarts
  * its queue by itself in its completion handler, so we don't need to
- * restart queue if .get_budget() returns BLK_STS_NO_RESOURCE.
+ * restart queue if .get_budget() fails to get the budget.
  *
  * Returns -EAGAIN if hctx->dispatch was found non-empty and run_work has to
  * be run again.  This is necessary to avoid starving flushes.
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9f53b4caf977..01e281801453 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -457,7 +457,8 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 	 * allocator for this for the rare use case of a command tied to
 	 * a specific queue.
 	 */
-	if (WARN_ON_ONCE(!(flags & (BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_RESERVED))))
+	if (WARN_ON_ONCE(!(flags & BLK_MQ_REQ_NOWAIT)) ||
+	    WARN_ON_ONCE(!(flags & BLK_MQ_REQ_RESERVED)))
 		return ERR_PTR(-EINVAL);
 
 	if (hctx_idx >= q->nr_hw_queues)
diff --git a/block/fops.c b/block/fops.c
index 1e970c247e0e..6c265a1bcf1b 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -243,6 +243,24 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 			bio_endio(bio);
 			break;
 		}
+		if (iocb->ki_flags & IOCB_NOWAIT) {
+			/*
+			 * This is nonblocking IO, and we need to allocate
+			 * another bio if we have data left to map. As we
+			 * cannot guarantee that one of the sub bios will not
+			 * fail getting issued FOR NOWAIT and as error results
+			 * are coalesced across all of them, be safe and ask for
+			 * a retry of this from blocking context.
+			 */
+			if (unlikely(iov_iter_count(iter))) {
+				bio_release_pages(bio, false);
+				bio_clear_flag(bio, BIO_REFFED);
+				bio_put(bio);
+				blk_finish_plug(&plug);
+				return -EAGAIN;
+			}
+			bio->bi_opf |= REQ_NOWAIT;
+		}
 
 		if (is_read) {
 			bio->bi_opf = REQ_OP_READ;
@@ -252,9 +270,6 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 			bio->bi_opf = dio_bio_write_op(iocb);
 			task_io_account_write(bio->bi_iter.bi_size);
 		}
-		if (iocb->ki_flags & IOCB_NOWAIT)
-			bio->bi_opf |= REQ_NOWAIT;
-
 		dio->size += bio->bi_iter.bi_size;
 		pos += bio->bi_iter.bi_size;
 
diff --git a/crypto/asymmetric_keys/public_key.c b/crypto/asymmetric_keys/public_key.c
index 2f8352e88860..eca5671ad3f2 100644
--- a/crypto/asymmetric_keys/public_key.c
+++ b/crypto/asymmetric_keys/public_key.c
@@ -186,8 +186,28 @@ static int software_key_query(const struct kernel_pkey_params *params,
 
 	len = crypto_akcipher_maxsize(tfm);
 	info->key_size = len * 8;
-	info->max_data_size = len;
-	info->max_sig_size = len;
+
+	if (strncmp(pkey->pkey_algo, "ecdsa", 5) == 0) {
+		/*
+		 * ECDSA key sizes are much smaller than RSA, and thus could
+		 * operate on (hashed) inputs that are larger than key size.
+		 * For example SHA384-hashed input used with secp256r1
+		 * based keys.  Set max_data_size to be at least as large as
+		 * the largest supported hash size (SHA512)
+		 */
+		info->max_data_size = 64;
+
+		/*
+		 * Verify takes ECDSA-Sig (described in RFC 5480) as input,
+		 * which is actually 2 'key_size'-bit integers encoded in
+		 * ASN.1.  Account for the ASN.1 encoding overhead here.
+		 */
+		info->max_sig_size = 2 * (len + 3) + 2;
+	} else {
+		info->max_data_size = len;
+		info->max_sig_size = len;
+	}
+
 	info->max_enc_size = len;
 	info->max_dec_size = len;
 	info->supported_ops = (KEYCTL_SUPPORTS_ENCRYPT |
diff --git a/crypto/essiv.c b/crypto/essiv.c
index 8bcc5bdcb2a9..3505b071e647 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -171,7 +171,12 @@ static void essiv_aead_done(struct crypto_async_request *areq, int err)
 	struct aead_request *req = areq->data;
 	struct essiv_aead_request_ctx *rctx = aead_request_ctx(req);
 
+	if (err == -EINPROGRESS)
+		goto out;
+
 	kfree(rctx->assoc);
+
+out:
 	aead_request_complete(req, err);
 }
 
@@ -247,7 +252,7 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
 	err = enc ? crypto_aead_encrypt(subreq) :
 		    crypto_aead_decrypt(subreq);
 
-	if (rctx->assoc && err != -EINPROGRESS)
+	if (rctx->assoc && err != -EINPROGRESS && err != -EBUSY)
 		kfree(rctx->assoc);
 	return err;
 }
diff --git a/crypto/rsa-pkcs1pad.c b/crypto/rsa-pkcs1pad.c
index 9d804831c8b3..a4ebbb889274 100644
--- a/crypto/rsa-pkcs1pad.c
+++ b/crypto/rsa-pkcs1pad.c
@@ -214,16 +214,14 @@ static void pkcs1pad_encrypt_sign_complete_cb(
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
@@ -332,15 +330,14 @@ static void pkcs1pad_decrypt_complete_cb(
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
@@ -512,15 +509,14 @@ static void pkcs1pad_verify_complete_cb(
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
index 0899d527c284..b1bcfe537daf 100644
--- a/crypto/seqiv.c
+++ b/crypto/seqiv.c
@@ -23,7 +23,7 @@ static void seqiv_aead_encrypt_complete2(struct aead_request *req, int err)
 	struct aead_request *subreq = aead_request_ctx(req);
 	struct crypto_aead *geniv;
 
-	if (err == -EINPROGRESS)
+	if (err == -EINPROGRESS || err == -EBUSY)
 		return;
 
 	if (err)
diff --git a/crypto/xts.c b/crypto/xts.c
index 63c85b9e64e0..de6cbcf69bbd 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -203,12 +203,12 @@ static void xts_encrypt_done(struct crypto_async_request *areq, int err)
 	if (!err) {
 		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 
-		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+		rctx->subreq.base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
 		err = xts_xor_tweak_post(req, true);
 
 		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
 			err = xts_cts_final(req, crypto_skcipher_encrypt);
-			if (err == -EINPROGRESS)
+			if (err == -EINPROGRESS || err == -EBUSY)
 				return;
 		}
 	}
@@ -223,12 +223,12 @@ static void xts_decrypt_done(struct crypto_async_request *areq, int err)
 	if (!err) {
 		struct xts_request_ctx *rctx = skcipher_request_ctx(req);
 
-		rctx->subreq.base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
+		rctx->subreq.base.flags &= CRYPTO_TFM_REQ_MAY_BACKLOG;
 		err = xts_xor_tweak_post(req, false);
 
 		if (!err && unlikely(req->cryptlen % XTS_BLOCK_SIZE)) {
 			err = xts_cts_final(req, crypto_skcipher_decrypt);
-			if (err == -EINPROGRESS)
+			if (err == -EINPROGRESS || err == -EBUSY)
 				return;
 		}
 	}
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
index e15badf4077a..c6716f90e013 100644
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
index 499067daa22c..1b8677f2ced3 100644
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
index 56db7b4da514..c7569151fd02 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -449,7 +449,7 @@ static int extract_package(struct acpi_battery *battery,
 
 			if (element->type == ACPI_TYPE_STRING ||
 			    element->type == ACPI_TYPE_BUFFER)
-				strncpy(ptr, element->string.pointer, 32);
+				strscpy(ptr, element->string.pointer, 32);
 			else if (element->type == ACPI_TYPE_INTEGER) {
 				strncpy(ptr, (u8 *)&element->integer.value,
 					sizeof(u64));
diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 33921949bd8f..3b9f89487336 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -435,17 +435,34 @@ static const struct dmi_system_id lenovo_laptop[] = {
 	{ }
 };
 
-static const struct dmi_system_id schenker_gm_rg[] = {
+static const struct dmi_system_id tongfang_gm_rg[] = {
 	{
-		.ident = "XMG CORE 15 (M22)",
+		.ident = "TongFang GMxRGxx/XMG CORE 15 (M22)/TUXEDO Stellaris 15 Gen4 AMD",
 		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "SchenkerTechnologiesGmbH"),
 			DMI_MATCH(DMI_BOARD_NAME, "GMxRGxx"),
 		},
 	},
 	{ }
 };
 
+static const struct dmi_system_id maingear_laptop[] = {
+	{
+		.ident = "MAINGEAR Vector Pro 2 15",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Micro Electronics Inc"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MG-VCP2-15A3070T"),
+		}
+	},
+	{
+		.ident = "MAINGEAR Vector Pro 2 17",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Micro Electronics Inc"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "MG-VCP2-17A3070T"),
+		},
+	},
+	{ }
+};
+
 struct irq_override_cmp {
 	const struct dmi_system_id *system;
 	unsigned char irq;
@@ -460,7 +477,8 @@ static const struct irq_override_cmp override_table[] = {
 	{ asus_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
 	{ lenovo_laptop, 6, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
 	{ lenovo_laptop, 10, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
-	{ schenker_gm_rg, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
+	{ tongfang_gm_rg, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
+	{ maingear_laptop, 1, ACPI_EDGE_SENSITIVE, ACPI_ACTIVE_LOW, 1, true },
 };
 
 static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
@@ -770,6 +788,23 @@ int acpi_dev_get_dma_resources(struct acpi_device *adev, struct list_head *list)
 }
 EXPORT_SYMBOL_GPL(acpi_dev_get_dma_resources);
 
+/**
+ * acpi_dev_get_memory_resources - Get current memory resources of a device.
+ * @adev: ACPI device node to get the resources for.
+ * @list: Head of the resultant list of resources (must be empty).
+ *
+ * This is a helper function that locates all memory type resources of @adev
+ * with acpi_dev_get_resources().
+ *
+ * The number of resources in the output list is returned on success, an error
+ * code reflecting the error condition is returned otherwise.
+ */
+int acpi_dev_get_memory_resources(struct acpi_device *adev, struct list_head *list)
+{
+	return acpi_dev_get_resources(adev, list, is_memory, NULL);
+}
+EXPORT_SYMBOL_GPL(acpi_dev_get_memory_resources);
+
 /**
  * acpi_dev_filter_resource_type - Filter ACPI resource according to resource
  *				   types
diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index b13713199ad9..038542b3a80a 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -313,7 +313,7 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 	 .ident = "Lenovo Ideapad Z570",
 	 .matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "102434U"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "Ideapad Z570"),
 		},
 	},
 	{
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 10e027e92692..adf003a7e8d6 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -3328,7 +3328,7 @@ int device_add(struct device *dev)
 	/* we require the name to be set before, and pass NULL */
 	error = kobject_add(&dev->kobj, dev->kobj.parent, NULL);
 	if (error) {
-		glue_dir = get_glue_dir(dev);
+		glue_dir = kobj;
 		goto Error;
 	}
 
@@ -3428,6 +3428,7 @@ int device_add(struct device *dev)
 	device_pm_remove(dev);
 	dpm_sysfs_remove(dev);
  DPMError:
+	dev->driver = NULL;
 	bus_remove_device(dev);
  BusError:
 	device_remove_attrs(dev);
diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
index 94fe30c187ad..24a82e252b7e 100644
--- a/drivers/base/power/domain.c
+++ b/drivers/base/power/domain.c
@@ -217,13 +217,10 @@ static void genpd_debug_add(struct generic_pm_domain *genpd);
 
 static void genpd_debug_remove(struct generic_pm_domain *genpd)
 {
-	struct dentry *d;
-
 	if (!genpd_debugfs_dir)
 		return;
 
-	d = debugfs_lookup(genpd->name, genpd_debugfs_dir);
-	debugfs_remove(d);
+	debugfs_lookup_and_remove(genpd->name, genpd_debugfs_dir);
 }
 
 static void genpd_update_accounting(struct generic_pm_domain *genpd)
diff --git a/drivers/base/transport_class.c b/drivers/base/transport_class.c
index ccc86206e508..09ee2a1e35bb 100644
--- a/drivers/base/transport_class.c
+++ b/drivers/base/transport_class.c
@@ -155,12 +155,27 @@ static int transport_add_class_device(struct attribute_container *cont,
 				      struct device *dev,
 				      struct device *classdev)
 {
+	struct transport_class *tclass = class_to_transport_class(cont->class);
 	int error = attribute_container_add_class_device(classdev);
 	struct transport_container *tcont = 
 		attribute_container_to_transport_container(cont);
 
-	if (!error && tcont->statistics)
+	if (error)
+		goto err_remove;
+
+	if (tcont->statistics) {
 		error = sysfs_create_group(&classdev->kobj, tcont->statistics);
+		if (error)
+			goto err_del;
+	}
+
+	return 0;
+
+err_del:
+	attribute_container_class_device_del(classdev);
+err_remove:
+	if (tclass->remove)
+		tclass->remove(tcont, dev, classdev);
 
 	return error;
 }
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 530b31240203..2427b2261e51 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -78,11 +78,9 @@ static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
 }
 
 /*
- * Look up and return a brd's page for a given sector.
- * If one does not exist, allocate an empty page, and insert that. Then
- * return it.
+ * Insert a new page for a given sector, if one does not already exist.
  */
-static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
+static int brd_insert_page(struct brd_device *brd, sector_t sector)
 {
 	pgoff_t idx;
 	struct page *page;
@@ -90,7 +88,7 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 
 	page = brd_lookup_page(brd, sector);
 	if (page)
-		return page;
+		return 0;
 
 	/*
 	 * Must use NOIO because we don't want to recurse back into the
@@ -99,11 +97,11 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 	gfp_flags = GFP_NOIO | __GFP_ZERO | __GFP_HIGHMEM;
 	page = alloc_page(gfp_flags);
 	if (!page)
-		return NULL;
+		return -ENOMEM;
 
 	if (radix_tree_preload(GFP_NOIO)) {
 		__free_page(page);
-		return NULL;
+		return -ENOMEM;
 	}
 
 	spin_lock(&brd->brd_lock);
@@ -120,8 +118,7 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 	spin_unlock(&brd->brd_lock);
 
 	radix_tree_preload_end();
-
-	return page;
+	return 0;
 }
 
 /*
@@ -174,16 +171,17 @@ static int copy_to_brd_setup(struct brd_device *brd, sector_t sector, size_t n)
 {
 	unsigned int offset = (sector & (PAGE_SECTORS-1)) << SECTOR_SHIFT;
 	size_t copy;
+	int ret;
 
 	copy = min_t(size_t, n, PAGE_SIZE - offset);
-	if (!brd_insert_page(brd, sector))
-		return -ENOSPC;
+	ret = brd_insert_page(brd, sector);
+	if (ret)
+		return ret;
 	if (copy < n) {
 		sector += copy >> SECTOR_SHIFT;
-		if (!brd_insert_page(brd, sector))
-			return -ENOSPC;
+		ret = brd_insert_page(brd, sector);
 	}
-	return 0;
+	return ret;
 }
 
 /*
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index c4a52f33604d..f9d298c5a2ab 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5296,8 +5296,7 @@ static void rbd_dev_release(struct device *dev)
 		module_put(THIS_MODULE);
 }
 
-static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
-					   struct rbd_spec *spec)
+static struct rbd_device *__rbd_dev_create(struct rbd_spec *spec)
 {
 	struct rbd_device *rbd_dev;
 
@@ -5342,9 +5341,6 @@ static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
 	rbd_dev->dev.parent = &rbd_root_dev;
 	device_initialize(&rbd_dev->dev);
 
-	rbd_dev->rbd_client = rbdc;
-	rbd_dev->spec = spec;
-
 	return rbd_dev;
 }
 
@@ -5357,12 +5353,10 @@ static struct rbd_device *rbd_dev_create(struct rbd_client *rbdc,
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
@@ -5379,6 +5373,10 @@ static struct rbd_device *rbd_dev_create(struct rbd_client *rbdc,
 	/* we have a ref from do_rbd_add() */
 	__module_get(THIS_MODULE);
 
+	rbd_dev->rbd_client = rbdc;
+	rbd_dev->spec = spec;
+	rbd_dev->opts = opts;
+
 	dout("%s rbd_dev %p dev_id %d\n", __func__, rbd_dev, rbd_dev->dev_id);
 	return rbd_dev;
 
@@ -6739,7 +6737,7 @@ static int rbd_dev_probe_parent(struct rbd_device *rbd_dev, int depth)
 		goto out_err;
 	}
 
-	parent = __rbd_dev_create(rbd_dev->rbd_client, rbd_dev->parent_spec);
+	parent = __rbd_dev_create(rbd_dev->parent_spec);
 	if (!parent) {
 		ret = -ENOMEM;
 		goto out_err;
@@ -6749,8 +6747,8 @@ static int rbd_dev_probe_parent(struct rbd_device *rbd_dev, int depth)
 	 * Images related by parent/child relationships always share
 	 * rbd_client and spec/parent_spec, so bump their refcounts.
 	 */
-	__rbd_get_client(rbd_dev->rbd_client);
-	rbd_spec_get(rbd_dev->parent_spec);
+	parent->rbd_client = __rbd_get_client(rbd_dev->rbd_client);
+	parent->spec = rbd_spec_get(rbd_dev->parent_spec);
 
 	__set_bit(RBD_DEV_FLAG_READONLY, &parent->flags);
 
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 9c32263f872b..9eb2267bd3a0 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -400,6 +400,10 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x8087, 0xe0, 0x01, 0x01),
 	  .driver_info = BTUSB_IGNORE },
 
+	/* Realtek 8821CE Bluetooth devices */
+	{ USB_DEVICE(0x13d3, 0x3529), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+
 	/* Realtek 8822CE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0xb00c), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
index e45777b3f5da..8041155f3021 100644
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -1582,10 +1582,11 @@ static bool qca_prevent_wake(struct hci_dev *hdev)
 	struct hci_uart *hu = hci_get_drvdata(hdev);
 	bool wakeup;
 
-	/* UART driver handles the interrupt from BT SoC.So we need to use
-	 * device handle of UART driver to get the status of device may wakeup.
+	/* BT SoC attached through the serial bus is handled by the serdev driver.
+	 * So we need to use the device handle of the serdev driver to get the
+	 * status of device may wakeup.
 	 */
-	wakeup = device_may_wakeup(hu->serdev->ctrl->dev.parent);
+	wakeup = device_may_wakeup(&hu->serdev->ctrl->dev);
 	bt_dev_dbg(hu->hdev, "wakeup status : %d", wakeup);
 
 	return !wakeup;
diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index deb85a334c93..260573c28320 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -197,8 +197,10 @@ static int __init applicom_init(void)
 		if (!pci_match_id(applicom_pci_tbl, dev))
 			continue;
 		
-		if (pci_enable_device(dev))
+		if (pci_enable_device(dev)) {
+			pci_dev_put(dev);
 			return -EIO;
+		}
 
 		RamIO = ioremap(pci_resource_start(dev, 0), LEN_RAM_IO);
 
@@ -207,6 +209,7 @@ static int __init applicom_init(void)
 				"space at 0x%llx\n",
 				(unsigned long long)pci_resource_start(dev, 0));
 			pci_disable_device(dev);
+			pci_dev_put(dev);
 			return -EIO;
 		}
 
diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index f366e8e3eee3..427bf618c447 100644
--- a/drivers/char/ipmi/ipmi_ssif.c
+++ b/drivers/char/ipmi/ipmi_ssif.c
@@ -92,7 +92,7 @@
 #define SSIF_WATCH_WATCHDOG_TIMEOUT	msecs_to_jiffies(250)
 
 enum ssif_intf_state {
-	SSIF_NORMAL,
+	SSIF_IDLE,
 	SSIF_GETTING_FLAGS,
 	SSIF_GETTING_EVENTS,
 	SSIF_CLEARING_FLAGS,
@@ -100,8 +100,8 @@ enum ssif_intf_state {
 	/* FIXME - add watchdog stuff. */
 };
 
-#define SSIF_IDLE(ssif)	 ((ssif)->ssif_state == SSIF_NORMAL \
-			  && (ssif)->curr_msg == NULL)
+#define IS_SSIF_IDLE(ssif) ((ssif)->ssif_state == SSIF_IDLE \
+			    && (ssif)->curr_msg == NULL)
 
 /*
  * Indexes into stats[] in ssif_info below.
@@ -348,9 +348,9 @@ static void return_hosed_msg(struct ssif_info *ssif_info,
 
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
@@ -367,7 +367,7 @@ static void start_clear_flags(struct ssif_info *ssif_info, unsigned long *flags)
 
 	if (start_send(ssif_info, msg, 3) != 0) {
 		/* Error, just go to normal state. */
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 	}
 }
 
@@ -382,7 +382,7 @@ static void start_flag_fetch(struct ssif_info *ssif_info, unsigned long *flags)
 	mb[0] = (IPMI_NETFN_APP_REQUEST << 2);
 	mb[1] = IPMI_GET_MSG_FLAGS_CMD;
 	if (start_send(ssif_info, mb, 2) != 0)
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 }
 
 static void check_start_send(struct ssif_info *ssif_info, unsigned long *flags,
@@ -393,7 +393,7 @@ static void check_start_send(struct ssif_info *ssif_info, unsigned long *flags,
 
 		flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
 		ssif_info->curr_msg = NULL;
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		ipmi_free_smi_msg(msg);
 	}
@@ -407,7 +407,7 @@ static void start_event_fetch(struct ssif_info *ssif_info, unsigned long *flags)
 
 	msg = ipmi_alloc_smi_msg();
 	if (!msg) {
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -430,7 +430,7 @@ static void start_recv_msg_fetch(struct ssif_info *ssif_info,
 
 	msg = ipmi_alloc_smi_msg();
 	if (!msg) {
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -448,9 +448,9 @@ static void start_recv_msg_fetch(struct ssif_info *ssif_info,
 
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
@@ -466,7 +466,7 @@ static void handle_flags(struct ssif_info *ssif_info, unsigned long *flags)
 		/* Events available. */
 		start_event_fetch(ssif_info, flags);
 	else {
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 	}
 }
@@ -568,7 +568,7 @@ static void watch_timeout(struct timer_list *t)
 	if (ssif_info->watch_timeout) {
 		mod_timer(&ssif_info->watch_timer,
 			  jiffies + ssif_info->watch_timeout);
-		if (SSIF_IDLE(ssif_info)) {
+		if (IS_SSIF_IDLE(ssif_info)) {
 			start_flag_fetch(ssif_info, flags); /* Releases lock */
 			return;
 		}
@@ -602,7 +602,7 @@ static void ssif_alert(struct i2c_client *client, enum i2c_alert_protocol type,
 		start_get(ssif_info);
 }
 
-static int start_resend(struct ssif_info *ssif_info);
+static void start_resend(struct ssif_info *ssif_info);
 
 static void msg_done_handler(struct ssif_info *ssif_info, int result,
 			     unsigned char *data, unsigned int len)
@@ -756,7 +756,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 	}
 
 	switch (ssif_info->ssif_state) {
-	case SSIF_NORMAL:
+	case SSIF_IDLE:
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		if (!msg)
 			break;
@@ -774,7 +774,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 			 * Error fetching flags, or invalid length,
 			 * just give up for now.
 			 */
-			ssif_info->ssif_state = SSIF_NORMAL;
+			ssif_info->ssif_state = SSIF_IDLE;
 			ipmi_ssif_unlock_cond(ssif_info, flags);
 			dev_warn(&ssif_info->client->dev,
 				 "Error getting flags: %d %d, %x\n",
@@ -809,7 +809,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 				 "Invalid response clearing flags: %x %x\n",
 				 data[0], data[1]);
 		}
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		break;
 
@@ -887,7 +887,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 	}
 
 	flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
-	if (SSIF_IDLE(ssif_info) && !ssif_info->stopping) {
+	if (IS_SSIF_IDLE(ssif_info) && !ssif_info->stopping) {
 		if (ssif_info->req_events)
 			start_event_fetch(ssif_info, flags);
 		else if (ssif_info->req_flags)
@@ -909,31 +909,17 @@ static void msg_written_handler(struct ssif_info *ssif_info, int result,
 	if (result < 0) {
 		ssif_info->retries_left--;
 		if (ssif_info->retries_left > 0) {
-			if (!start_resend(ssif_info)) {
-				ssif_inc_stat(ssif_info, send_retries);
-				return;
-			}
-			/* request failed, just return the error. */
-			ssif_inc_stat(ssif_info, send_errors);
-
-			if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
-				dev_dbg(&ssif_info->client->dev,
-					"%s: Out of retries\n", __func__);
-			msg_done_handler(ssif_info, -EIO, NULL, 0);
+			start_resend(ssif_info);
 			return;
 		}
 
 		ssif_inc_stat(ssif_info, send_errors);
 
-		/*
-		 * Got an error on transmit, let the done routine
-		 * handle it.
-		 */
 		if (ssif_info->ssif_debug & SSIF_DEBUG_MSG)
 			dev_dbg(&ssif_info->client->dev,
-				"%s: Error  %d\n", __func__, result);
+				"%s: Out of retries\n", __func__);
 
-		msg_done_handler(ssif_info, result, NULL, 0);
+		msg_done_handler(ssif_info, -EIO, NULL, 0);
 		return;
 	}
 
@@ -996,7 +982,7 @@ static void msg_written_handler(struct ssif_info *ssif_info, int result,
 	}
 }
 
-static int start_resend(struct ssif_info *ssif_info)
+static void start_resend(struct ssif_info *ssif_info)
 {
 	int command;
 
@@ -1021,7 +1007,6 @@ static int start_resend(struct ssif_info *ssif_info)
 
 	ssif_i2c_send(ssif_info, msg_written_handler, I2C_SMBUS_WRITE,
 		   command, ssif_info->data, I2C_SMBUS_BLOCK_DATA);
-	return 0;
 }
 
 static int start_send(struct ssif_info *ssif_info,
@@ -1036,7 +1021,8 @@ static int start_send(struct ssif_info *ssif_info,
 	ssif_info->retries_left = SSIF_SEND_RETRIES;
 	memcpy(ssif_info->data + 1, data, len);
 	ssif_info->data_len = len;
-	return start_resend(ssif_info);
+	start_resend(ssif_info);
+	return 0;
 }
 
 /* Must be called with the message lock held. */
@@ -1046,7 +1032,7 @@ static void start_next_msg(struct ssif_info *ssif_info, unsigned long *flags)
 	unsigned long oflags;
 
  restart:
-	if (!SSIF_IDLE(ssif_info)) {
+	if (!IS_SSIF_IDLE(ssif_info)) {
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -1269,7 +1255,7 @@ static void shutdown_ssif(void *send_info)
 	dev_set_drvdata(&ssif_info->client->dev, NULL);
 
 	/* make sure the driver is not looking for flags any more. */
-	while (ssif_info->ssif_state != SSIF_NORMAL)
+	while (ssif_info->ssif_state != SSIF_IDLE)
 		schedule_timeout(1);
 
 	ssif_info->stopping = true;
@@ -1841,7 +1827,7 @@ static int ssif_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	spin_lock_init(&ssif_info->lock);
-	ssif_info->ssif_state = SSIF_NORMAL;
+	ssif_info->ssif_state = SSIF_IDLE;
 	timer_setup(&ssif_info->retry_timer, retry_timeout, 0);
 	timer_setup(&ssif_info->watch_timer, watch_timeout, 0);
 
diff --git a/drivers/char/pcmcia/cm4000_cs.c b/drivers/char/pcmcia/cm4000_cs.c
index 8f1bce0b4fe5..7057b7bacc8c 100644
--- a/drivers/char/pcmcia/cm4000_cs.c
+++ b/drivers/char/pcmcia/cm4000_cs.c
@@ -530,7 +530,8 @@ static int set_protocol(struct cm4000_dev *dev, struct ptsreq *ptsreq)
 			DEBUGP(5, dev, "NumRecBytes is valid\n");
 			break;
 		}
-		usleep_range(10000, 11000);
+		/* can not sleep as this is in atomic context */
+		mdelay(10);
 	}
 	if (i == 100) {
 		DEBUGP(5, dev, "Timeout waiting for NumRecBytes getting "
@@ -550,7 +551,8 @@ static int set_protocol(struct cm4000_dev *dev, struct ptsreq *ptsreq)
 			}
 			break;
 		}
-		usleep_range(10000, 11000);
+		/* can not sleep as this is in atomic context */
+		mdelay(10);
 	}
 
 	/* check whether it is a short PTS reply? */
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 8278d98074e9..e1556a3582a3 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -522,7 +522,6 @@ static void crypto4xx_cipher_done(struct crypto4xx_device *dev,
 {
 	struct skcipher_request *req;
 	struct scatterlist *dst;
-	dma_addr_t addr;
 
 	req = skcipher_request_cast(pd_uinfo->async_req);
 
@@ -531,8 +530,8 @@ static void crypto4xx_cipher_done(struct crypto4xx_device *dev,
 					  req->cryptlen, req->dst);
 	} else {
 		dst = pd_uinfo->dest_va;
-		addr = dma_map_page(dev->core_dev->device, sg_page(dst),
-				    dst->offset, dst->length, DMA_FROM_DEVICE);
+		dma_unmap_page(dev->core_dev->device, pd->dest, dst->length,
+			       DMA_FROM_DEVICE);
 	}
 
 	if (pd_uinfo->sa_va->sa_command_0.bf.save_iv == SA_SAVE_IV) {
@@ -557,10 +556,9 @@ static void crypto4xx_ahash_done(struct crypto4xx_device *dev,
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
index 9f753cb4f5f1..b386a7063818 100644
--- a/drivers/crypto/ccp/ccp-dmaengine.c
+++ b/drivers/crypto/ccp/ccp-dmaengine.c
@@ -642,14 +642,26 @@ static void ccp_dma_release(struct ccp_device *ccp)
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
@@ -770,8 +782,9 @@ void ccp_dmaengine_unregister(struct ccp_device *ccp)
 	if (!dmaengine)
 		return;
 
-	ccp_dma_release(ccp);
+	ccp_dma_release_channels(ccp);
 	dma_async_device_unregister(dma_dev);
+	ccp_dma_release(ccp);
 
 	kmem_cache_destroy(ccp->dma_desc_cache);
 	kmem_cache_destroy(ccp->dma_cmd_cache);
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 900727b5edda..70174a9118b1 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -24,6 +24,7 @@
 #include <linux/cpufeature.h>
 
 #include <asm/smp.h>
+#include <asm/cacheflush.h>
 
 #include "psp-dev.h"
 #include "sev-dev.h"
@@ -141,6 +142,17 @@ static int sev_cmd_buffer_len(int cmd)
 	return 0;
 }
 
+static void *sev_fw_alloc(unsigned long len)
+{
+	struct page *page;
+
+	page = alloc_pages(GFP_KERNEL, get_order(len));
+	if (!page)
+		return NULL;
+
+	return page_address(page);
+}
+
 static int __sev_do_cmd_locked(int cmd, void *data, int *psp_ret)
 {
 	struct psp_device *psp = psp_master;
@@ -667,7 +679,14 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 	input_address = (void __user *)input.address;
 
 	if (input.address && input.length) {
-		id_blob = kzalloc(input.length, GFP_KERNEL);
+		/*
+		 * The length of the ID shouldn't be assumed by software since
+		 * it may change in the future.  The allocation size is limited
+		 * to 1 << (PAGE_SHIFT + MAX_ORDER - 1) by the page allocator.
+		 * If the allocation fails, simply return ENOMEM rather than
+		 * warning in the kernel log.
+		 */
+		id_blob = kzalloc(input.length, GFP_KERNEL | __GFP_NOWARN);
 		if (!id_blob)
 			return -ENOMEM;
 
@@ -1080,7 +1099,6 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	struct page *tmr_page;
 	int error, rc;
 
 	if (!sev)
@@ -1096,14 +1114,13 @@ void sev_pci_init(void)
 		sev_get_api_version();
 
 	/* Obtain the TMR memory area for SEV-ES use */
-	tmr_page = alloc_pages(GFP_KERNEL, get_order(SEV_ES_TMR_SIZE));
-	if (tmr_page) {
-		sev_es_tmr = page_address(tmr_page);
-	} else {
-		sev_es_tmr = NULL;
+	sev_es_tmr = sev_fw_alloc(SEV_ES_TMR_SIZE);
+	if (sev_es_tmr)
+		/* Must flush the cache before giving it to the firmware */
+		clflush_cache_range(sev_es_tmr, SEV_ES_TMR_SIZE);
+	else
 		dev_warn(sev->dev,
 			 "SEV: TMR allocation failed, SEV-ES support unavailable\n");
-	}
 
 	/* Initialize the platform */
 	rc = sev_platform_init(&error);
diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 057273769f26..3dbe5405d17b 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -122,9 +122,8 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
 	for (j = 0; j < i; j++) {
 		dma_free_coherent(dev, block_size, block[j].sgl,
 				  block[j].sgl_dma);
-		memset(block + j, 0, sizeof(*block));
 	}
-	kfree(pool);
+	kfree_sensitive(pool);
 	return ERR_PTR(-ENOMEM);
 }
 EXPORT_SYMBOL_GPL(hisi_acc_create_sgl_pool);
diff --git a/drivers/crypto/qat/qat_common/qat_algs.c b/drivers/crypto/qat/qat_common/qat_algs.c
index 9abdaf7cd2cf..906082fbdd67 100644
--- a/drivers/crypto/qat/qat_common/qat_algs.c
+++ b/drivers/crypto/qat/qat_common/qat_algs.c
@@ -434,8 +434,8 @@ static void qat_alg_skcipher_init_com(struct qat_alg_skcipher_ctx *ctx,
 	} else if (aes_v2_capable && mode == ICP_QAT_HW_CIPHER_CTR_MODE) {
 		ICP_QAT_FW_LA_SLICE_TYPE_SET(header->serv_specif_flags,
 					     ICP_QAT_FW_LA_USE_UCS_SLICE_TYPE);
-		keylen = round_up(keylen, 16);
 		memcpy(cd->ucs_aes.key, key, keylen);
+		keylen = round_up(keylen, 16);
 	} else {
 		memcpy(cd->aes.key, key, keylen);
 	}
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 6cc4da4c713d..e75b9edc88a1 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -397,8 +397,8 @@ static void unregister_dev_dax(void *dev)
 	dev_dbg(dev, "%s\n", __func__);
 
 	kill_dev_dax(dev_dax);
-	free_dev_dax_ranges(dev_dax);
 	device_del(dev);
+	free_dev_dax_ranges(dev_dax);
 	put_device(dev);
 }
 
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a37622060fff..04f85f16720c 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -135,7 +135,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
 					i, range.start, range.end);
-			release_resource(res);
+			remove_resource(res);
 			kfree(res);
 			data->res[i] = NULL;
 			if (mapped)
@@ -181,7 +181,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 
 		rc = remove_memory(range.start, range_len(&range));
 		if (rc == 0) {
-			release_resource(data->res[i]);
+			remove_resource(data->res[i]);
 			kfree(data->res[i]);
 			data->res[i] = NULL;
 			success++;
diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
index 80c2c03cb014..95344ae49e53 100644
--- a/drivers/dma/Kconfig
+++ b/drivers/dma/Kconfig
@@ -236,7 +236,7 @@ config FSL_RAID
 
 config HISI_DMA
 	tristate "HiSilicon DMA Engine support"
-	depends on ARM64 || COMPILE_TEST
+	depends on ARCH_HISI || COMPILE_TEST
 	depends on PCI_MSI
 	select DMA_ENGINE
 	select DMA_VIRTUAL_CHANNELS
diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index 41654b2f6c60..cfc47efcb5d9 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -288,8 +288,6 @@ dma_chan_tx_status(struct dma_chan *dchan, dma_cookie_t cookie,
 		len = vd_to_axi_desc(vdesc)->hw_desc[0].len;
 		completed_length = completed_blocks * len;
 		bytes = length - completed_length;
-	} else {
-		bytes = vd_to_axi_desc(vdesc)->length;
 	}
 
 	spin_unlock_irqrestore(&chan->vc.lock, flags);
diff --git a/drivers/dma/dw-edma/dw-edma-core.c b/drivers/dma/dw-edma/dw-edma-core.c
index 36b3fe1b6b0f..97f5e4e93cfc 100644
--- a/drivers/dma/dw-edma/dw-edma-core.c
+++ b/drivers/dma/dw-edma/dw-edma-core.c
@@ -438,6 +438,8 @@ dw_edma_device_transfer(struct dw_edma_transfer *xfer)
 				 * and destination addresses are increased
 				 * by the same portion (data length)
 				 */
+			} else if (xfer->type == EDMA_XFER_INTERLEAVED) {
+				burst->dar = dst_addr;
 			}
 		} else {
 			burst->dar = dst_addr;
@@ -453,6 +455,8 @@ dw_edma_device_transfer(struct dw_edma_transfer *xfer)
 				 * and destination addresses are increased
 				 * by the same portion (data length)
 				 */
+			}  else if (xfer->type == EDMA_XFER_INTERLEAVED) {
+				burst->sar = src_addr;
 			}
 		}
 
diff --git a/drivers/dma/dw-edma/dw-edma-v0-core.c b/drivers/dma/dw-edma/dw-edma-v0-core.c
index b5b8f8181e77..043a4f3115fa 100644
--- a/drivers/dma/dw-edma/dw-edma-v0-core.c
+++ b/drivers/dma/dw-edma/dw-edma-v0-core.c
@@ -192,7 +192,7 @@ static inline void writeq_ch(struct dw_edma *dw, enum dw_edma_dir dir, u16 ch,
 static inline u64 readq_ch(struct dw_edma *dw, enum dw_edma_dir dir, u16 ch,
 			   const void __iomem *addr)
 {
-	u32 value;
+	u64 value;
 
 	if (dw->mf == EDMA_MF_EDMA_LEGACY) {
 		u32 viewport_sel;
diff --git a/drivers/dma/idxd/device.c b/drivers/dma/idxd/device.c
index 37b07c679c0e..535f021911c5 100644
--- a/drivers/dma/idxd/device.c
+++ b/drivers/dma/idxd/device.c
@@ -702,7 +702,7 @@ static void idxd_groups_clear_state(struct idxd_device *idxd)
 		group->use_rdbuf_limit = false;
 		group->rdbufs_allowed = 0;
 		group->rdbufs_reserved = 0;
-		if (idxd->hw.version < DEVICE_VERSION_2 && !tc_override) {
+		if (idxd->hw.version <= DEVICE_VERSION_2 && !tc_override) {
 			group->tc_a = 1;
 			group->tc_b = 1;
 		} else {
diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 6263d9825250..e0e0c7f286b6 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -340,7 +340,7 @@ static int idxd_setup_groups(struct idxd_device *idxd)
 		}
 
 		idxd->groups[i] = group;
-		if (idxd->hw.version < DEVICE_VERSION_2 && !tc_override) {
+		if (idxd->hw.version <= DEVICE_VERSION_2 && !tc_override) {
 			group->tc_a = 1;
 			group->tc_b = 1;
 		} else {
diff --git a/drivers/dma/idxd/sysfs.c b/drivers/dma/idxd/sysfs.c
index 33d94c67fedb..489a9d885076 100644
--- a/drivers/dma/idxd/sysfs.c
+++ b/drivers/dma/idxd/sysfs.c
@@ -327,7 +327,7 @@ static ssize_t group_traffic_class_a_store(struct device *dev,
 	if (idxd->state == IDXD_DEV_ENABLED)
 		return -EPERM;
 
-	if (idxd->hw.version < DEVICE_VERSION_2 && !tc_override)
+	if (idxd->hw.version <= DEVICE_VERSION_2 && !tc_override)
 		return -EPERM;
 
 	if (val < 0 || val > 7)
@@ -369,7 +369,7 @@ static ssize_t group_traffic_class_b_store(struct device *dev,
 	if (idxd->state == IDXD_DEV_ENABLED)
 		return -EPERM;
 
-	if (idxd->hw.version < DEVICE_VERSION_2 && !tc_override)
+	if (idxd->hw.version <= DEVICE_VERSION_2 && !tc_override)
 		return -EPERM;
 
 	if (val < 0 || val > 7)
diff --git a/drivers/dma/sf-pdma/sf-pdma.c b/drivers/dma/sf-pdma/sf-pdma.c
index ab0ad7a2f201..dcf2b7a4183c 100644
--- a/drivers/dma/sf-pdma/sf-pdma.c
+++ b/drivers/dma/sf-pdma/sf-pdma.c
@@ -96,7 +96,6 @@ sf_pdma_prep_dma_memcpy(struct dma_chan *dchan,	dma_addr_t dest, dma_addr_t src,
 	if (!desc)
 		return NULL;
 
-	desc->in_use = true;
 	desc->dirn = DMA_MEM_TO_MEM;
 	desc->async_tx = vchan_tx_prep(&chan->vchan, &desc->vdesc, flags);
 
@@ -290,7 +289,7 @@ static void sf_pdma_free_desc(struct virt_dma_desc *vdesc)
 	struct sf_pdma_desc *desc;
 
 	desc = to_sf_pdma_desc(vdesc);
-	desc->in_use = false;
+	kfree(desc);
 }
 
 static void sf_pdma_donebh_tasklet(struct tasklet_struct *t)
diff --git a/drivers/dma/sf-pdma/sf-pdma.h b/drivers/dma/sf-pdma/sf-pdma.h
index 0c20167b097d..02a229a3ae22 100644
--- a/drivers/dma/sf-pdma/sf-pdma.h
+++ b/drivers/dma/sf-pdma/sf-pdma.h
@@ -82,7 +82,6 @@ struct sf_pdma_desc {
 	u64				src_addr;
 	struct virt_dma_desc		vdesc;
 	struct sf_pdma_chan		*chan;
-	bool				in_use;
 	enum dma_transfer_direction	dirn;
 	struct dma_async_tx_descriptor *async_tx;
 };
diff --git a/drivers/firmware/dmi-sysfs.c b/drivers/firmware/dmi-sysfs.c
index 4a93fb490cb4..3d57b08320df 100644
--- a/drivers/firmware/dmi-sysfs.c
+++ b/drivers/firmware/dmi-sysfs.c
@@ -602,16 +602,16 @@ static void __init dmi_sysfs_register_handle(const struct dmi_header *dh,
 	*ret = kobject_init_and_add(&entry->kobj, &dmi_sysfs_entry_ktype, NULL,
 				    "%d-%d", dh->type, entry->instance);
 
-	if (*ret) {
-		kobject_put(&entry->kobj);
-		return;
-	}
-
 	/* Thread on the global list for cleanup */
 	spin_lock(&entry_list_lock);
 	list_add_tail(&entry->list, &entry_list);
 	spin_unlock(&entry_list_lock);
 
+	if (*ret) {
+		kobject_put(&entry->kobj);
+		return;
+	}
+
 	/* Handle specializations by type */
 	switch (dh->type) {
 	case DMI_ENTRY_SYSTEM_EVENT_LOG:
diff --git a/drivers/firmware/google/framebuffer-coreboot.c b/drivers/firmware/google/framebuffer-coreboot.c
index c6dcc1ef93ac..c323a818805c 100644
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
diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index 7dd0ac1a0cfc..4fdd75f1e86e 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -994,13 +994,17 @@ static int stratix10_svc_drv_probe(struct platform_device *pdev)
 
 	/* allocate service controller and supporting channel */
 	controller = devm_kzalloc(dev, sizeof(*controller), GFP_KERNEL);
-	if (!controller)
-		return -ENOMEM;
+	if (!controller) {
+		ret = -ENOMEM;
+		goto err_destroy_pool;
+	}
 
 	chans = devm_kmalloc_array(dev, SVC_NUM_CHANNEL,
 				   sizeof(*chans), GFP_KERNEL | __GFP_ZERO);
-	if (!chans)
-		return -ENOMEM;
+	if (!chans) {
+		ret = -ENOMEM;
+		goto err_destroy_pool;
+	}
 
 	controller->dev = dev;
 	controller->num_chans = SVC_NUM_CHANNEL;
@@ -1015,7 +1019,7 @@ static int stratix10_svc_drv_probe(struct platform_device *pdev)
 	ret = kfifo_alloc(&controller->svc_fifo, fifo_size, GFP_KERNEL);
 	if (ret) {
 		dev_err(dev, "failed to allocate FIFO\n");
-		return ret;
+		goto err_destroy_pool;
 	}
 	spin_lock_init(&controller->svc_fifo_lock);
 
@@ -1060,6 +1064,8 @@ static int stratix10_svc_drv_probe(struct platform_device *pdev)
 	platform_device_put(svc->stratix10_svc_rsu);
 err_free_kfifo:
 	kfifo_free(&controller->svc_fifo);
+err_destroy_pool:
+	gen_pool_destroy(genpool);
 	return ret;
 }
 
diff --git a/drivers/gpio/gpio-vf610.c b/drivers/gpio/gpio-vf610.c
index 47e191e11c69..edb28af7ba3b 100644
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
index b4293b5a8252..68c98e30fee7 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2687,12 +2687,14 @@ static int dm_resume(void *handle)
 	drm_for_each_connector_iter(connector, &iter) {
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
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index 6c9378208127..eca882438f6e 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -771,6 +771,7 @@ static bool dc_construct_ctx(struct dc *dc,
 
 	dc_ctx->perf_trace = dc_perf_trace_create();
 	if (!dc_ctx->perf_trace) {
+		kfree(dc_ctx);
 		ASSERT_CRITICAL(false);
 		return false;
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 3c4205248efc..b727bd7e039d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -1665,12 +1665,6 @@ struct dc_link *link_create(const struct link_init_data *init_params)
 	if (false == dc_link_construct(link, init_params))
 		goto construct_fail;
 
-	/*
-	 * Must use preferred_link_setting, not reported_link_cap or verified_link_cap,
-	 * since struct preferred_link_setting won't be reset after S3.
-	 */
-	link->preferred_link_setting.dpcd_source_device_specific_field_support = true;
-
 	return link;
 
 construct_fail:
diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index a6ff1b17fd22..6777adb66f9d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -4841,18 +4841,10 @@ void dpcd_set_source_specific_data(struct dc_link *link)
 
 			uint8_t hblank_size = (uint8_t)link->dc->caps.min_horizontal_blanking_period;
 
-			if (link->preferred_link_setting.dpcd_source_device_specific_field_support) {
-				result_write_min_hblank = core_link_write_dpcd(link,
-					DP_SOURCE_MINIMUM_HBLANK_SUPPORTED, (uint8_t *)(&hblank_size),
-					sizeof(hblank_size));
-
-				if (result_write_min_hblank == DC_ERROR_UNEXPECTED)
-					link->preferred_link_setting.dpcd_source_device_specific_field_support = false;
-			} else {
-				DC_LOG_DC("Sink device does not support 00340h DPCD write. Skipping on purpose.\n");
-			}
+			result_write_min_hblank = core_link_write_dpcd(link,
+				DP_SOURCE_MINIMUM_HBLANK_SUPPORTED, (uint8_t *)(&hblank_size),
+				sizeof(hblank_size));
 		}
-
 		DC_TRACE_LEVEL_MESSAGE(DAL_TRACE_LEVEL_INFORMATION,
 							WPP_BIT_FLAG_DC_DETECTION_DP_CAPS,
 							"result=%u link_index=%u enum dce_version=%d DPCD=0x%04X min_hblank=%u branch_dev_id=0x%x branch_dev_name='%c%c%c%c%c%c'",
diff --git a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
index 4f54bde1bb1c..1948cd9427d7 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_dp_types.h
@@ -109,7 +109,6 @@ struct dc_link_settings {
 	enum dc_link_spread link_spread;
 	bool use_link_rate_set;
 	uint8_t link_rate_set;
-	bool dpcd_source_device_specific_field_support;
 };
 
 struct dc_lane_settings {
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c
index d3b5b6fedf04..6266b0788387 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c
@@ -3897,14 +3897,14 @@ void dml20_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 					mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine = mode_lib->vba.PixelClock[k] / 2
 							* (1 + mode_lib->vba.DISPCLKDPPCLKDSCCLKDownSpreading / 100.0);
 
-				locals->ODMCombineEnablePerState[i][k] = false;
+				locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_disabled;
 				mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithoutODMCombine;
 				if (mode_lib->vba.ODMCapability) {
 					if (locals->PlaneRequiredDISPCLKWithoutODMCombine > mode_lib->vba.MaxDispclkRoundedDownToDFSGranularity) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					} else if (locals->HActive[k] > DCN20_MAX_420_IMAGE_WIDTH && locals->OutputFormat[k] == dm_420) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					}
 				}
@@ -3957,7 +3957,7 @@ void dml20_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 				locals->RequiredDISPCLK[i][j] = 0.0;
 				locals->DISPCLK_DPPCLK_Support[i][j] = true;
 				for (k = 0; k <= mode_lib->vba.NumberOfActivePlanes - 1; k++) {
-					locals->ODMCombineEnablePerState[i][k] = false;
+					locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_disabled;
 					if (locals->SwathWidthYSingleDPP[k] <= locals->MaximumSwathWidth[k]) {
 						locals->NoOfDPP[i][j][k] = 1;
 						locals->RequiredDPPCLK[i][j][k] = locals->MinDPPCLKUsingSingleDPP[k]
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
index 63bbdf8b8678..0053a6d5178c 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
@@ -4008,17 +4008,17 @@ void dml20v2_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode
 					mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine = mode_lib->vba.PixelClock[k] / 2
 							* (1 + mode_lib->vba.DISPCLKDPPCLKDSCCLKDownSpreading / 100.0);
 
-				locals->ODMCombineEnablePerState[i][k] = false;
+				locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_disabled;
 				mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithoutODMCombine;
 				if (mode_lib->vba.ODMCapability) {
 					if (locals->PlaneRequiredDISPCLKWithoutODMCombine > MaxMaxDispclkRoundedDown) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					} else if (locals->DSCEnabled[k] && (locals->HActive[k] > DCN20_MAX_DSC_IMAGE_WIDTH)) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					} else if (locals->HActive[k] > DCN20_MAX_420_IMAGE_WIDTH && locals->OutputFormat[k] == dm_420) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					}
 				}
@@ -4071,7 +4071,7 @@ void dml20v2_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode
 				locals->RequiredDISPCLK[i][j] = 0.0;
 				locals->DISPCLK_DPPCLK_Support[i][j] = true;
 				for (k = 0; k <= mode_lib->vba.NumberOfActivePlanes - 1; k++) {
-					locals->ODMCombineEnablePerState[i][k] = false;
+					locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_disabled;
 					if (locals->SwathWidthYSingleDPP[k] <= locals->MaximumSwathWidth[k]) {
 						locals->NoOfDPP[i][j][k] = 1;
 						locals->RequiredDPPCLK[i][j][k] = locals->MinDPPCLKUsingSingleDPP[k]
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
index 4136eb8256cb..26f839ce710f 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
@@ -3979,17 +3979,17 @@ void dml21_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 					mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine = mode_lib->vba.PixelClock[k] / 2
 							* (1 + mode_lib->vba.DISPCLKDPPCLKDSCCLKDownSpreading / 100.0);
 
-				locals->ODMCombineEnablePerState[i][k] = false;
+				locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_disabled;
 				mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithoutODMCombine;
 				if (mode_lib->vba.ODMCapability) {
 					if (locals->PlaneRequiredDISPCLKWithoutODMCombine > MaxMaxDispclkRoundedDown) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					} else if (locals->DSCEnabled[k] && (locals->HActive[k] > DCN21_MAX_DSC_IMAGE_WIDTH)) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					} else if (locals->HActive[k] > DCN21_MAX_420_IMAGE_WIDTH && locals->OutputFormat[k] == dm_420) {
-						locals->ODMCombineEnablePerState[i][k] = true;
+						locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_2to1;
 						mode_lib->vba.PlaneRequiredDISPCLK = mode_lib->vba.PlaneRequiredDISPCLKWithODMCombine;
 					}
 				}
@@ -4042,7 +4042,7 @@ void dml21_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 				locals->RequiredDISPCLK[i][j] = 0.0;
 				locals->DISPCLK_DPPCLK_Support[i][j] = true;
 				for (k = 0; k <= mode_lib->vba.NumberOfActivePlanes - 1; k++) {
-					locals->ODMCombineEnablePerState[i][k] = false;
+					locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_disabled;
 					if (locals->SwathWidthYSingleDPP[k] <= locals->MaximumSwathWidth[k]) {
 						locals->NoOfDPP[i][j][k] = 1;
 						locals->RequiredDPPCLK[i][j][k] = locals->MinDPPCLKUsingSingleDPP[k]
@@ -5218,7 +5218,7 @@ void dml21_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 			mode_lib->vba.ODMCombineEnabled[k] =
 					locals->ODMCombineEnablePerState[mode_lib->vba.VoltageLevel][k];
 		} else {
-			mode_lib->vba.ODMCombineEnabled[k] = false;
+			mode_lib->vba.ODMCombineEnabled[k] = dm_odm_combine_mode_disabled;
 		}
 		mode_lib->vba.DSCEnabled[k] =
 				locals->RequiresDSC[mode_lib->vba.VoltageLevel][k];
diff --git a/drivers/gpu/drm/bridge/lontium-lt9611.c b/drivers/gpu/drm/bridge/lontium-lt9611.c
index 1dcc28a4d853..0c6dea9ccb72 100644
--- a/drivers/gpu/drm/bridge/lontium-lt9611.c
+++ b/drivers/gpu/drm/bridge/lontium-lt9611.c
@@ -185,12 +185,14 @@ static void lt9611_mipi_video_setup(struct lt9611 *lt9611,
 
 	regmap_write(lt9611->regmap, 0x8319, (u8)(hfront_porch % 256));
 
-	regmap_write(lt9611->regmap, 0x831a, (u8)(hsync_porch / 256));
+	regmap_write(lt9611->regmap, 0x831a, (u8)(hsync_porch / 256) |
+						((hfront_porch / 256) << 4));
 	regmap_write(lt9611->regmap, 0x831b, (u8)(hsync_porch % 256));
 }
 
-static void lt9611_pcr_setup(struct lt9611 *lt9611, const struct drm_display_mode *mode)
+static void lt9611_pcr_setup(struct lt9611 *lt9611, const struct drm_display_mode *mode, unsigned int postdiv)
 {
+	unsigned int pcr_m = mode->clock * 5 * postdiv / 27000;
 	const struct reg_sequence reg_cfg[] = {
 		{ 0x830b, 0x01 },
 		{ 0x830c, 0x10 },
@@ -205,7 +207,6 @@ static void lt9611_pcr_setup(struct lt9611 *lt9611, const struct drm_display_mod
 
 		/* stage 2 */
 		{ 0x834a, 0x40 },
-		{ 0x831d, 0x10 },
 
 		/* MK limit */
 		{ 0x832d, 0x38 },
@@ -220,30 +221,28 @@ static void lt9611_pcr_setup(struct lt9611 *lt9611, const struct drm_display_mod
 		{ 0x8325, 0x00 },
 		{ 0x832a, 0x01 },
 		{ 0x834a, 0x10 },
-		{ 0x831d, 0x10 },
-		{ 0x8326, 0x37 },
 	};
+	u8 pol = 0x10;
 
-	regmap_multi_reg_write(lt9611->regmap, reg_cfg, ARRAY_SIZE(reg_cfg));
+	if (mode->flags & DRM_MODE_FLAG_NHSYNC)
+		pol |= 0x2;
+	if (mode->flags & DRM_MODE_FLAG_NVSYNC)
+		pol |= 0x1;
+	regmap_write(lt9611->regmap, 0x831d, pol);
 
-	switch (mode->hdisplay) {
-	case 640:
-		regmap_write(lt9611->regmap, 0x8326, 0x14);
-		break;
-	case 1920:
-		regmap_write(lt9611->regmap, 0x8326, 0x37);
-		break;
-	case 3840:
+	if (mode->hdisplay == 3840)
 		regmap_multi_reg_write(lt9611->regmap, reg_cfg2, ARRAY_SIZE(reg_cfg2));
-		break;
-	}
+	else
+		regmap_multi_reg_write(lt9611->regmap, reg_cfg, ARRAY_SIZE(reg_cfg));
+
+	regmap_write(lt9611->regmap, 0x8326, pcr_m);
 
 	/* pcr rst */
 	regmap_write(lt9611->regmap, 0x8011, 0x5a);
 	regmap_write(lt9611->regmap, 0x8011, 0xfa);
 }
 
-static int lt9611_pll_setup(struct lt9611 *lt9611, const struct drm_display_mode *mode)
+static int lt9611_pll_setup(struct lt9611 *lt9611, const struct drm_display_mode *mode, unsigned int *postdiv)
 {
 	unsigned int pclk = mode->clock;
 	const struct reg_sequence reg_cfg[] = {
@@ -261,12 +260,16 @@ static int lt9611_pll_setup(struct lt9611 *lt9611, const struct drm_display_mode
 
 	regmap_multi_reg_write(lt9611->regmap, reg_cfg, ARRAY_SIZE(reg_cfg));
 
-	if (pclk > 150000)
+	if (pclk > 150000) {
 		regmap_write(lt9611->regmap, 0x812d, 0x88);
-	else if (pclk > 70000)
+		*postdiv = 1;
+	} else if (pclk > 70000) {
 		regmap_write(lt9611->regmap, 0x812d, 0x99);
-	else
+		*postdiv = 2;
+	} else {
 		regmap_write(lt9611->regmap, 0x812d, 0xaa);
+		*postdiv = 4;
+	}
 
 	/*
 	 * first divide pclk by 2 first
@@ -446,12 +449,11 @@ static void lt9611_sleep_setup(struct lt9611 *lt9611)
 		{ 0x8023, 0x01 },
 		{ 0x8157, 0x03 }, /* set addr pin as output */
 		{ 0x8149, 0x0b },
-		{ 0x8151, 0x30 }, /* disable IRQ */
+
 		{ 0x8102, 0x48 }, /* MIPI Rx power down */
 		{ 0x8123, 0x80 },
 		{ 0x8130, 0x00 },
-		{ 0x8100, 0x01 }, /* bandgap power down */
-		{ 0x8101, 0x00 }, /* system clk power down */
+		{ 0x8011, 0x0a },
 	};
 
 	regmap_multi_reg_write(lt9611->regmap,
@@ -757,7 +759,7 @@ static const struct drm_connector_funcs lt9611_bridge_connector_funcs = {
 static struct mipi_dsi_device *lt9611_attach_dsi(struct lt9611 *lt9611,
 						 struct device_node *dsi_node)
 {
-	const struct mipi_dsi_device_info info = { "lt9611", 0, NULL };
+	const struct mipi_dsi_device_info info = { "lt9611", 0, lt9611->dev->of_node};
 	struct mipi_dsi_device *dsi;
 	struct mipi_dsi_host *host;
 	int ret;
@@ -881,12 +883,18 @@ static enum drm_mode_status lt9611_bridge_mode_valid(struct drm_bridge *bridge,
 static void lt9611_bridge_pre_enable(struct drm_bridge *bridge)
 {
 	struct lt9611 *lt9611 = bridge_to_lt9611(bridge);
+	static const struct reg_sequence reg_cfg[] = {
+		{ 0x8102, 0x12 },
+		{ 0x8123, 0x40 },
+		{ 0x8130, 0xea },
+		{ 0x8011, 0xfa },
+	};
 
 	if (!lt9611->sleep)
 		return;
 
-	lt9611_reset(lt9611);
-	regmap_write(lt9611->regmap, 0x80ee, 0x01);
+	regmap_multi_reg_write(lt9611->regmap,
+			       reg_cfg, ARRAY_SIZE(reg_cfg));
 
 	lt9611->sleep = false;
 }
@@ -904,14 +912,15 @@ static void lt9611_bridge_mode_set(struct drm_bridge *bridge,
 {
 	struct lt9611 *lt9611 = bridge_to_lt9611(bridge);
 	struct hdmi_avi_infoframe avi_frame;
+	unsigned int postdiv;
 	int ret;
 
 	lt9611_bridge_pre_enable(bridge);
 
 	lt9611_mipi_input_digital(lt9611, mode);
-	lt9611_pll_setup(lt9611, mode);
+	lt9611_pll_setup(lt9611, mode, &postdiv);
 	lt9611_mipi_video_setup(lt9611, mode);
-	lt9611_pcr_setup(lt9611, mode);
+	lt9611_pcr_setup(lt9611, mode, postdiv);
 
 	ret = drm_hdmi_avi_infoframe_from_display_mode(&avi_frame,
 						       &lt9611->connector,
diff --git a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
index 72248a565579..e41afcc5326b 100644
--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -444,7 +444,11 @@ static int __init stdpxxxx_ge_b850v3_init(void)
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
 
diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi83.c b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
index c901c0e1a3b0..b3cb910b3085 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -381,6 +381,8 @@ static void sn65dsi83_atomic_enable(struct drm_bridge *bridge,
 	u16 val;
 	int ret;
 
+	usleep_range(10000, 11000);
+
 	/* Get the LVDS format from the bridge state. */
 	bridge_state = drm_atomic_get_new_bridge_state(state, bridge);
 
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index d940c76419c5..720956893b56 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5598,8 +5598,6 @@ static u8 drm_mode_hdmi_vic(const struct drm_connector *connector,
 static u8 drm_mode_cea_vic(const struct drm_connector *connector,
 			   const struct drm_display_mode *mode)
 {
-	u8 vic;
-
 	/*
 	 * HDMI spec says if a mode is found in HDMI 1.4b 4K modes
 	 * we should send its VIC in vendor infoframes, else send the
@@ -5609,13 +5607,18 @@ static u8 drm_mode_cea_vic(const struct drm_connector *connector,
 	if (drm_mode_hdmi_vic(connector, mode))
 		return 0;
 
-	vic = drm_match_cea_mode(mode);
+	return drm_match_cea_mode(mode);
+}
 
-	/*
-	 * HDMI 1.4 VIC range: 1 <= VIC <= 64 (CEA-861-D) but
-	 * HDMI 2.0 VIC range: 1 <= VIC <= 107 (CEA-861-F). So we
-	 * have to make sure we dont break HDMI 1.4 sinks.
-	 */
+/*
+ * Avoid sending VICs defined in HDMI 2.0 in AVI infoframes to sinks that
+ * conform to HDMI 1.4.
+ *
+ * HDMI 1.4 (CTA-861-D) VIC range: [1..64]
+ * HDMI 2.0 (CTA-861-F) VIC range: [1..107]
+ */
+static u8 vic_for_avi_infoframe(const struct drm_connector *connector, u8 vic)
+{
 	if (!is_hdmi2_sink(connector) && vic > 64)
 		return 0;
 
@@ -5691,7 +5694,7 @@ drm_hdmi_avi_infoframe_from_display_mode(struct hdmi_avi_infoframe *frame,
 		picture_aspect = HDMI_PICTURE_ASPECT_NONE;
 	}
 
-	frame->video_code = vic;
+	frame->video_code = vic_for_avi_infoframe(connector, vic);
 	frame->picture_aspect = picture_aspect;
 	frame->active_aspect = HDMI_ACTIVE_ASPECT_PICTURE;
 	frame->scan_mode = HDMI_SCAN_MODE_UNDERSCAN;
diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index 32ee023aed26..7940d948ffdc 100644
--- a/drivers/gpu/drm/drm_fourcc.c
+++ b/drivers/gpu/drm/drm_fourcc.c
@@ -153,6 +153,10 @@ const struct drm_format_info *__drm_format_info(u32 format)
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
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index 15c3849e995b..d58e8e12d3ae 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -651,23 +651,7 @@ struct sg_table *drm_gem_shmem_get_sg_table(struct drm_gem_shmem_object *shmem)
 }
 EXPORT_SYMBOL_GPL(drm_gem_shmem_get_sg_table);
 
-/**
- * drm_gem_shmem_get_pages_sgt - Pin pages, dma map them, and return a
- *				 scatter/gather table for a shmem GEM object.
- * @shmem: shmem GEM object
- *
- * This function returns a scatter/gather table suitable for driver usage. If
- * the sg table doesn't exist, the pages are pinned, dma-mapped, and a sg
- * table created.
- *
- * This is the main function for drivers to get at backing storage, and it hides
- * and difference between dma-buf imported and natively allocated objects.
- * drm_gem_shmem_get_sg_table() should not be directly called by drivers.
- *
- * Returns:
- * A pointer to the scatter/gather table of pinned pages or errno on failure.
- */
-struct sg_table *drm_gem_shmem_get_pages_sgt(struct drm_gem_shmem_object *shmem)
+static struct sg_table *drm_gem_shmem_get_pages_sgt_locked(struct drm_gem_shmem_object *shmem)
 {
 	struct drm_gem_object *obj = &shmem->base;
 	int ret;
@@ -678,7 +662,7 @@ struct sg_table *drm_gem_shmem_get_pages_sgt(struct drm_gem_shmem_object *shmem)
 
 	WARN_ON(obj->import_attach);
 
-	ret = drm_gem_shmem_get_pages(shmem);
+	ret = drm_gem_shmem_get_pages_locked(shmem);
 	if (ret)
 		return ERR_PTR(ret);
 
@@ -700,9 +684,39 @@ struct sg_table *drm_gem_shmem_get_pages_sgt(struct drm_gem_shmem_object *shmem)
 	sg_free_table(sgt);
 	kfree(sgt);
 err_put_pages:
-	drm_gem_shmem_put_pages(shmem);
+	drm_gem_shmem_put_pages_locked(shmem);
 	return ERR_PTR(ret);
 }
+
+/**
+ * drm_gem_shmem_get_pages_sgt - Pin pages, dma map them, and return a
+ *				 scatter/gather table for a shmem GEM object.
+ * @shmem: shmem GEM object
+ *
+ * This function returns a scatter/gather table suitable for driver usage. If
+ * the sg table doesn't exist, the pages are pinned, dma-mapped, and a sg
+ * table created.
+ *
+ * This is the main function for drivers to get at backing storage, and it hides
+ * and difference between dma-buf imported and natively allocated objects.
+ * drm_gem_shmem_get_sg_table() should not be directly called by drivers.
+ *
+ * Returns:
+ * A pointer to the scatter/gather table of pinned pages or errno on failure.
+ */
+struct sg_table *drm_gem_shmem_get_pages_sgt(struct drm_gem_shmem_object *shmem)
+{
+	int ret;
+	struct sg_table *sgt;
+
+	ret = mutex_lock_interruptible(&shmem->pages_lock);
+	if (ret)
+		return ERR_PTR(ret);
+	sgt = drm_gem_shmem_get_pages_sgt_locked(shmem);
+	mutex_unlock(&shmem->pages_lock);
+
+	return sgt;
+}
 EXPORT_SYMBOL_GPL(drm_gem_shmem_get_pages_sgt);
 
 /**
diff --git a/drivers/gpu/drm/drm_mipi_dsi.c b/drivers/gpu/drm/drm_mipi_dsi.c
index 2c43d54766f3..19fb1d93a4f0 100644
--- a/drivers/gpu/drm/drm_mipi_dsi.c
+++ b/drivers/gpu/drm/drm_mipi_dsi.c
@@ -1143,6 +1143,58 @@ int mipi_dsi_dcs_get_display_brightness(struct mipi_dsi_device *dsi,
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
diff --git a/drivers/gpu/drm/drm_mode_config.c b/drivers/gpu/drm/drm_mode_config.c
index 37b4b9f0e468..1bd4f0b2cc4d 100644
--- a/drivers/gpu/drm/drm_mode_config.c
+++ b/drivers/gpu/drm/drm_mode_config.c
@@ -398,6 +398,8 @@ static void drm_mode_config_init_release(struct drm_device *dev, void *ptr)
  */
 int drmm_mode_config_init(struct drm_device *dev)
 {
+	int ret;
+
 	mutex_init(&dev->mode_config.mutex);
 	drm_modeset_lock_init(&dev->mode_config.connection_mutex);
 	mutex_init(&dev->mode_config.idr_mutex);
@@ -419,7 +421,11 @@ int drmm_mode_config_init(struct drm_device *dev)
 	init_llist_head(&dev->mode_config.connector_free_list);
 	INIT_WORK(&dev->mode_config.connector_free_work, drm_connector_free_work_fn);
 
-	drm_mode_create_standard_properties(dev);
+	ret = drm_mode_create_standard_properties(dev);
+	if (ret) {
+		drm_mode_config_cleanup(dev);
+		return ret;
+	}
 
 	/* Just to be sure */
 	dev->mode_config.num_fb = 0;
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
diff --git a/drivers/gpu/drm/exynos/exynos_drm_dsi.c b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
index 8d137857818c..e0465b604f21 100644
--- a/drivers/gpu/drm/exynos/exynos_drm_dsi.c
+++ b/drivers/gpu/drm/exynos/exynos_drm_dsi.c
@@ -809,15 +809,15 @@ static int exynos_dsi_init_link(struct exynos_dsi *dsi)
 			reg |= DSIM_AUTO_MODE;
 		if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO_HSE)
 			reg |= DSIM_HSE_MODE;
-		if (!(dsi->mode_flags & MIPI_DSI_MODE_VIDEO_NO_HFP))
+		if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO_NO_HFP)
 			reg |= DSIM_HFP_MODE;
-		if (!(dsi->mode_flags & MIPI_DSI_MODE_VIDEO_NO_HBP))
+		if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO_NO_HBP)
 			reg |= DSIM_HBP_MODE;
-		if (!(dsi->mode_flags & MIPI_DSI_MODE_VIDEO_NO_HSA))
+		if (dsi->mode_flags & MIPI_DSI_MODE_VIDEO_NO_HSA)
 			reg |= DSIM_HSA_MODE;
 	}
 
-	if (!(dsi->mode_flags & MIPI_DSI_MODE_NO_EOT_PACKET))
+	if (dsi->mode_flags & MIPI_DSI_MODE_NO_EOT_PACKET)
 		reg |= DSIM_EOT_DISABLE;
 
 	switch (dsi->format) {
diff --git a/drivers/gpu/drm/i915/display/intel_quirks.c b/drivers/gpu/drm/i915/display/intel_quirks.c
index 407b096f5392..015e5b806b6d 100644
--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -193,6 +193,8 @@ static struct intel_quirk intel_quirks[] = {
 	/* ECS Liva Q2 */
 	{ 0x3185, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
 	{ 0x3184, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
+	/* HP Notebook - 14-r206nv */
+	{ 0x0f31, 0x103c, 0x220f, quirk_invert_brightness },
 };
 
 void intel_init_quirks(struct drm_i915_private *i915)
diff --git a/drivers/gpu/drm/i915/gt/intel_ring.c b/drivers/gpu/drm/i915/gt/intel_ring.c
index 7c4d5158e03b..6499f8ba953a 100644
--- a/drivers/gpu/drm/i915/gt/intel_ring.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring.c
@@ -51,7 +51,7 @@ int intel_ring_pin(struct intel_ring *ring, struct i915_gem_ww_ctx *ww)
 	if (unlikely(ret))
 		goto err_unpin;
 
-	if (i915_vma_is_map_and_fenceable(vma)) {
+	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915)) {
 		addr = (void __force *)i915_vma_pin_iomap(vma);
 	} else {
 		int type = i915_coherent_map_type(vma->vm->i915, vma->obj, false);
@@ -96,7 +96,7 @@ void intel_ring_unpin(struct intel_ring *ring)
 		return;
 
 	i915_vma_unset_ggtt_write(vma);
-	if (i915_vma_is_map_and_fenceable(vma))
+	if (i915_vma_is_map_and_fenceable(vma) && !HAS_LLC(vma->vm->i915))
 		i915_vma_unpin_iomap(vma);
 	else
 		i915_gem_object_unpin_map(vma->obj);
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index 34bb6c713a90..6497c9fcd2af 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -889,6 +889,8 @@ int mtk_drm_crtc_create(struct drm_device *drm_dev,
 
 	mtk_crtc->planes = devm_kcalloc(dev, num_comp_planes,
 					sizeof(struct drm_plane), GFP_KERNEL);
+	if (!mtk_crtc->planes)
+		return -ENOMEM;
 
 	for (i = 0; i < mtk_crtc->ddp_comp_nr; i++) {
 		ret = mtk_drm_crtc_init_comp_planes(drm_dev, mtk_crtc, i,
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index aec39724ebeb..8b3928c2c7d7 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -376,6 +376,7 @@ static int mtk_drm_bind(struct device *dev)
 err_deinit:
 	mtk_drm_kms_deinit(drm);
 err_free:
+	private->drm = NULL;
 	drm_dev_put(drm);
 	return ret;
 }
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_gem.c b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
index d0544962cfc1..726a34c4725c 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
@@ -164,8 +164,6 @@ static int mtk_drm_gem_object_mmap(struct drm_gem_object *obj,
 
 	ret = dma_mmap_attrs(priv->dma_dev, vma, mtk_gem->cookie,
 			     mtk_gem->dma_addr, obj->size, mtk_gem->dma_attrs);
-	if (ret)
-		drm_gem_vm_close(vma);
 
 	return ret;
 }
@@ -261,6 +259,6 @@ void mtk_drm_gem_prime_vunmap(struct drm_gem_object *obj, struct dma_buf_map *ma
 		return;
 
 	vunmap(vaddr);
-	mtk_gem->kvaddr = 0;
+	mtk_gem->kvaddr = NULL;
 	kfree(mtk_gem->pages);
 }
diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index a6d28533f1b1..98b1204c9290 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -709,7 +709,7 @@ static void mtk_dsi_lane_ready(struct mtk_dsi *dsi)
 		mtk_dsi_clk_ulp_mode_leave(dsi);
 		mtk_dsi_lane0_ulp_mode_leave(dsi);
 		mtk_dsi_clk_hs_mode(dsi, 0);
-		msleep(20);
+		usleep_range(1000, 3000);
 		/* The reaction time after pulling up the mipi signal for dsi_rx */
 	}
 }
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index bba68776cb25..3fa01938f4b2 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -952,13 +952,13 @@ int adreno_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 void adreno_gpu_cleanup(struct adreno_gpu *adreno_gpu)
 {
 	struct msm_gpu *gpu = &adreno_gpu->base;
-	struct msm_drm_private *priv = gpu->dev->dev_private;
+	struct msm_drm_private *priv = gpu->dev ? gpu->dev->dev_private : NULL;
 	unsigned int i;
 
 	for (i = 0; i < ARRAY_SIZE(adreno_gpu->info->fw); i++)
 		release_firmware(adreno_gpu->fw[i]);
 
-	if (pm_runtime_enabled(&priv->gpu_pdev->dev))
+	if (priv && pm_runtime_enabled(&priv->gpu_pdev->dev))
 		pm_runtime_disable(&priv->gpu_pdev->dev);
 
 	msm_gpu_cleanup(&adreno_gpu->base);
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index 2186fc947e5b..4194689b6b35 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -770,7 +770,10 @@ static void dpu_crtc_reset(struct drm_crtc *crtc)
 	if (crtc->state)
 		dpu_crtc_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &cstate->base);
+	if (cstate)
+		__drm_atomic_helper_crtc_reset(crtc, &cstate->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 }
 
 /**
@@ -938,6 +941,8 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
 	bool needs_dirtyfb = dpu_crtc_needs_dirtyfb(crtc_state);
 
 	pstates = kzalloc(sizeof(*pstates) * DPU_STAGE_MAX * 4, GFP_KERNEL);
+	if (!pstates)
+		return -ENOMEM;
 
 	if (!crtc_state->enable || !crtc_state->active) {
 		DRM_DEBUG_ATOMIC("crtc%d -> enable %d, active %d, skip atomic_check\n",
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
index e32fe89c203c..59390dc3d1b8 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_plane.c
@@ -1089,7 +1089,7 @@ static void dpu_plane_sspp_atomic_update(struct drm_plane *plane)
 	struct dpu_plane_state *pstate = to_dpu_plane_state(state);
 	struct drm_crtc *crtc = state->crtc;
 	struct drm_framebuffer *fb = state->fb;
-	bool is_rt_pipe, update_qos_remap;
+	bool is_rt_pipe;
 	const struct dpu_format *fmt =
 		to_dpu_format(msm_framebuffer_format(fb));
 
@@ -1100,6 +1100,9 @@ static void dpu_plane_sspp_atomic_update(struct drm_plane *plane)
 	pstate->pending = true;
 
 	is_rt_pipe = (dpu_crtc_get_client_type(crtc) != NRT_CLIENT);
+	pstate->needs_qos_remap |= (is_rt_pipe != pdpu->is_rt_pipe);
+	pdpu->is_rt_pipe = is_rt_pipe;
+
 	_dpu_plane_set_qos_ctrl(plane, false, DPU_PLANE_QOS_PANIC_CTRL);
 
 	DPU_DEBUG_PLANE(pdpu, "FB[%u] " DRM_RECT_FP_FMT "->crtc%u " DRM_RECT_FMT
@@ -1205,14 +1208,8 @@ static void dpu_plane_sspp_atomic_update(struct drm_plane *plane)
 		_dpu_plane_set_ot_limit(plane, crtc);
 	}
 
-	update_qos_remap = (is_rt_pipe != pdpu->is_rt_pipe) ||
-			pstate->needs_qos_remap;
-
-	if (update_qos_remap) {
-		if (is_rt_pipe != pdpu->is_rt_pipe)
-			pdpu->is_rt_pipe = is_rt_pipe;
-		else if (pstate->needs_qos_remap)
-			pstate->needs_qos_remap = false;
+	if (pstate->needs_qos_remap) {
+		pstate->needs_qos_remap = false;
 		_dpu_plane_set_qos_remap(plane);
 	}
 
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
index 24fbaf562d41..932275b2dfe7 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
@@ -663,6 +663,11 @@ int dpu_rm_get_assigned_resources(struct dpu_rm *rm,
 				  blks_size, enc_id);
 			break;
 		}
+		if (!hw_blks[i]) {
+			DPU_ERROR("Allocated resource %d unavailable to assign to enc %d\n",
+				  type, enc_id);
+			break;
+		}
 		blks[num_blks++] = hw_blks[i];
 	}
 
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
index 31447da0af25..2b15f10eeae0 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
@@ -1138,7 +1138,10 @@ static void mdp5_crtc_reset(struct drm_crtc *crtc)
 	if (crtc->state)
 		mdp5_crtc_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &mdp5_cstate->base);
+	if (mdp5_cstate)
+		__drm_atomic_helper_crtc_reset(crtc, &mdp5_cstate->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 }
 
 static const struct drm_crtc_funcs mdp5_crtc_no_lm_cursor_funcs = {
diff --git a/drivers/gpu/drm/msm/dsi/dsi_cfg.c b/drivers/gpu/drm/msm/dsi/dsi_cfg.c
index ce3901439c69..68a3f8fea9fe 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_cfg.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_cfg.c
@@ -209,8 +209,8 @@ static const struct msm_dsi_config sc7280_dsi_cfg = {
 	},
 	.bus_clk_names = dsi_sc7280_bus_clk_names,
 	.num_bus_clks = ARRAY_SIZE(dsi_sc7280_bus_clk_names),
-	.io_start = { 0xae94000 },
-	.num_dsi = 1,
+	.io_start = { 0xae94000, 0xae96000 },
+	.num_dsi = 2,
 };
 
 static const struct msm_dsi_host_cfg_ops msm_dsi_v2_host_ops = {
diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index eb60ce125a1f..d3ec4d67a9a3 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1929,6 +1929,9 @@ int msm_dsi_host_init(struct msm_dsi *msm_dsi)
 
 	/* setup workqueue */
 	msm_host->workqueue = alloc_ordered_workqueue("dsi_drm_work", 0);
+	if (!msm_host->workqueue)
+		return -ENOMEM;
+
 	INIT_WORK(&msm_host->err_work, dsi_err_worker);
 	INIT_WORK(&msm_host->hpd_work, dsi_hpd_worker);
 
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index e1a9b52d0a29..2c944419e175 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -264,6 +264,10 @@ static struct hdmi *msm_hdmi_init(struct platform_device *pdev)
 	devm_pm_runtime_enable(&pdev->dev);
 
 	hdmi->workq = alloc_ordered_workqueue("msm_hdmi", 0);
+	if (!hdmi->workq) {
+		ret = -ENOMEM;
+		goto fail;
+	}
 
 	hdmi->i2c = msm_hdmi_i2c_init(hdmi);
 	if (IS_ERR(hdmi->i2c)) {
diff --git a/drivers/gpu/drm/msm/msm_drv.c b/drivers/gpu/drm/msm/msm_drv.c
index 916361c30d77..6c4d519450b9 100644
--- a/drivers/gpu/drm/msm/msm_drv.c
+++ b/drivers/gpu/drm/msm/msm_drv.c
@@ -609,7 +609,7 @@ static int msm_drm_init(struct device *dev, const struct drm_driver *drv)
 		if (IS_ERR(priv->event_thread[i].worker)) {
 			ret = PTR_ERR(priv->event_thread[i].worker);
 			DRM_DEV_ERROR(dev, "failed to create crtc_event kthread\n");
-			ret = PTR_ERR(priv->event_thread[i].worker);
+			priv->event_thread[i].worker = NULL;
 			goto err_msm_uninit;
 		}
 
diff --git a/drivers/gpu/drm/msm/msm_fence.c b/drivers/gpu/drm/msm/msm_fence.c
index f2cece542c3f..76439678919c 100644
--- a/drivers/gpu/drm/msm/msm_fence.c
+++ b/drivers/gpu/drm/msm/msm_fence.c
@@ -21,7 +21,7 @@ msm_fence_context_alloc(struct drm_device *dev, volatile uint32_t *fenceptr,
 		return ERR_PTR(-ENOMEM);
 
 	fctx->dev = dev;
-	strncpy(fctx->name, name, sizeof(fctx->name));
+	strscpy(fctx->name, name, sizeof(fctx->name));
 	fctx->context = dma_fence_context_alloc(1);
 	fctx->fenceptr = fenceptr;
 	spin_lock_init(&fctx->spinlock);
diff --git a/drivers/gpu/drm/msm/msm_gem_submit.c b/drivers/gpu/drm/msm/msm_gem_submit.c
index 1f74bab9e231..83e6ccad7728 100644
--- a/drivers/gpu/drm/msm/msm_gem_submit.c
+++ b/drivers/gpu/drm/msm/msm_gem_submit.c
@@ -220,6 +220,10 @@ static int submit_lookup_cmds(struct msm_gem_submit *submit,
 			goto out;
 		}
 		submit->cmd[i].relocs = kmalloc(sz, GFP_KERNEL);
+		if (!submit->cmd[i].relocs) {
+			ret = -ENOMEM;
+			goto out;
+		}
 		ret = copy_from_user(submit->cmd[i].relocs, userptr, sz);
 		if (ret) {
 			ret = -EFAULT;
diff --git a/drivers/gpu/drm/mxsfb/Kconfig b/drivers/gpu/drm/mxsfb/Kconfig
index ee22cd25d3e3..e7201e16119a 100644
--- a/drivers/gpu/drm/mxsfb/Kconfig
+++ b/drivers/gpu/drm/mxsfb/Kconfig
@@ -8,6 +8,7 @@ config DRM_MXSFB
 	tristate "i.MX (e)LCDIF LCD controller"
 	depends on DRM && OF
 	depends on COMMON_CLK
+	depends on ARCH_MXS || ARCH_MXC || COMPILE_TEST
 	select DRM_MXS
 	select DRM_KMS_HELPER
 	select DRM_KMS_CMA_HELPER
diff --git a/drivers/gpu/drm/omapdrm/dss/dsi.c b/drivers/gpu/drm/omapdrm/dss/dsi.c
index 5f1722b040f4..41da86cd8b64 100644
--- a/drivers/gpu/drm/omapdrm/dss/dsi.c
+++ b/drivers/gpu/drm/omapdrm/dss/dsi.c
@@ -1039,22 +1039,26 @@ static int dsi_dump_dsi_irqs(struct seq_file *s, void *p)
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
@@ -1078,10 +1082,10 @@ static int dsi_dump_dsi_irqs(struct seq_file *s, void *p)
 
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
@@ -1097,7 +1101,7 @@ static int dsi_dump_dsi_irqs(struct seq_file *s, void *p)
 
 #define PIS(x) \
 	seq_printf(s, "%-20s %10d\n", #x, \
-			stats.cio_irqs[ffs(DSI_CIO_IRQ_##x)-1]);
+			stats->cio_irqs[ffs(DSI_CIO_IRQ_##x)-1]);
 
 	seq_printf(s, "-- CIO interrupts --\n");
 	PIS(ERRSYNCESC1);
@@ -1122,6 +1126,8 @@ static int dsi_dump_dsi_irqs(struct seq_file *s, void *p)
 	PIS(ULPSACTIVENOT_ALL1);
 #undef PIS
 
+	kfree(stats);
+
 	return 0;
 }
 #endif
diff --git a/drivers/gpu/drm/panel/panel-samsung-s6e3ha2.c b/drivers/gpu/drm/panel/panel-samsung-s6e3ha2.c
index 0ab1b7ec84cd..166d7d41cd9b 100644
--- a/drivers/gpu/drm/panel/panel-samsung-s6e3ha2.c
+++ b/drivers/gpu/drm/panel/panel-samsung-s6e3ha2.c
@@ -692,7 +692,9 @@ static int s6e3ha2_probe(struct mipi_dsi_device *dsi)
 
 	dsi->lanes = 4;
 	dsi->format = MIPI_DSI_FMT_RGB888;
-	dsi->mode_flags = MIPI_DSI_CLOCK_NON_CONTINUOUS;
+	dsi->mode_flags = MIPI_DSI_CLOCK_NON_CONTINUOUS |
+		MIPI_DSI_MODE_VIDEO_NO_HFP | MIPI_DSI_MODE_VIDEO_NO_HBP |
+		MIPI_DSI_MODE_VIDEO_NO_HSA | MIPI_DSI_MODE_NO_EOT_PACKET;
 
 	ctx->supplies[0].supply = "vdd3";
 	ctx->supplies[1].supply = "vci";
diff --git a/drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c b/drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c
index ccc8ed6fe3ae..2fc46fdd0e7a 100644
--- a/drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c
+++ b/drivers/gpu/drm/panel/panel-samsung-s6e63j0x03.c
@@ -446,7 +446,8 @@ static int s6e63j0x03_probe(struct mipi_dsi_device *dsi)
 
 	dsi->lanes = 1;
 	dsi->format = MIPI_DSI_FMT_RGB888;
-	dsi->mode_flags = MIPI_DSI_MODE_NO_EOT_PACKET;
+	dsi->mode_flags = MIPI_DSI_MODE_VIDEO_NO_HFP |
+		MIPI_DSI_MODE_VIDEO_NO_HBP | MIPI_DSI_MODE_VIDEO_NO_HSA;
 
 	ctx->supplies[0].supply = "vdd3";
 	ctx->supplies[1].supply = "vci";
diff --git a/drivers/gpu/drm/panel/panel-samsung-s6e8aa0.c b/drivers/gpu/drm/panel/panel-samsung-s6e8aa0.c
index 9b3599d6d2de..737b8ca22b37 100644
--- a/drivers/gpu/drm/panel/panel-samsung-s6e8aa0.c
+++ b/drivers/gpu/drm/panel/panel-samsung-s6e8aa0.c
@@ -990,8 +990,6 @@ static int s6e8aa0_probe(struct mipi_dsi_device *dsi)
 	dsi->lanes = 4;
 	dsi->format = MIPI_DSI_FMT_RGB888;
 	dsi->mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_BURST
-		| MIPI_DSI_MODE_VIDEO_NO_HFP | MIPI_DSI_MODE_VIDEO_NO_HBP
-		| MIPI_DSI_MODE_VIDEO_NO_HSA | MIPI_DSI_MODE_NO_EOT_PACKET
 		| MIPI_DSI_MODE_VSYNC_FLUSH | MIPI_DSI_MODE_VIDEO_AUTO_VERT;
 
 	ret = s6e8aa0_parse_dt(ctx);
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 70bd84b7ef2b..2b4491137217 100644
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
index 92905ebb7b45..1c005e0ddd38 100644
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
diff --git a/drivers/gpu/drm/tegra/firewall.c b/drivers/gpu/drm/tegra/firewall.c
index 1824d2db0e2c..d53f890fa689 100644
--- a/drivers/gpu/drm/tegra/firewall.c
+++ b/drivers/gpu/drm/tegra/firewall.c
@@ -97,6 +97,9 @@ static int fw_check_regs_imm(struct tegra_drm_firewall *fw, u32 offset)
 {
 	bool is_addr;
 
+	if (!fw->client->ops->is_addr_reg)
+		return 0;
+
 	is_addr = fw->client->ops->is_addr_reg(fw->client->base.dev, fw->class,
 					       offset);
 	if (is_addr)
diff --git a/drivers/gpu/drm/tidss/tidss_dispc.c b/drivers/gpu/drm/tidss/tidss_dispc.c
index 60b92df615aa..f54517698710 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -1855,8 +1855,8 @@ static const struct {
 	{ DRM_FORMAT_XBGR4444, 0x21, },
 	{ DRM_FORMAT_RGBX4444, 0x22, },
 
-	{ DRM_FORMAT_ARGB1555, 0x25, },
-	{ DRM_FORMAT_ABGR1555, 0x26, },
+	{ DRM_FORMAT_XRGB1555, 0x25, },
+	{ DRM_FORMAT_XBGR1555, 0x26, },
 
 	{ DRM_FORMAT_XRGB8888, 0x27, },
 	{ DRM_FORMAT_XBGR8888, 0x28, },
diff --git a/drivers/gpu/drm/tiny/ili9486.c b/drivers/gpu/drm/tiny/ili9486.c
index e9a63f4b2993..e159dfb5f7fe 100644
--- a/drivers/gpu/drm/tiny/ili9486.c
+++ b/drivers/gpu/drm/tiny/ili9486.c
@@ -43,6 +43,7 @@ static int waveshare_command(struct mipi_dbi *mipi, u8 *cmd, u8 *par,
 			     size_t num)
 {
 	struct spi_device *spi = mipi->spi;
+	unsigned int bpw = 8;
 	void *data = par;
 	u32 speed_hz;
 	int i, ret;
@@ -56,8 +57,6 @@ static int waveshare_command(struct mipi_dbi *mipi, u8 *cmd, u8 *par,
 	 * The displays are Raspberry Pi HATs and connected to the 8-bit only
 	 * SPI controller, so 16-bit command and parameters need byte swapping
 	 * before being transferred as 8-bit on the big endian SPI bus.
-	 * Pixel data bytes have already been swapped before this function is
-	 * called.
 	 */
 	buf[0] = cpu_to_be16(*cmd);
 	gpiod_set_value_cansleep(mipi->dc, 0);
@@ -71,12 +70,18 @@ static int waveshare_command(struct mipi_dbi *mipi, u8 *cmd, u8 *par,
 		for (i = 0; i < num; i++)
 			buf[i] = cpu_to_be16(par[i]);
 		num *= 2;
-		speed_hz = mipi_dbi_spi_cmd_max_speed(spi, num);
 		data = buf;
 	}
 
+	/*
+	 * Check whether pixel data bytes needs to be swapped or not
+	 */
+	if (*cmd == MIPI_DCS_WRITE_MEMORY_START && !mipi->swap_bytes)
+		bpw = 16;
+
 	gpiod_set_value_cansleep(mipi->dc, 1);
-	ret = mipi_dbi_spi_transfer(spi, speed_hz, 8, data, num);
+	speed_hz = mipi_dbi_spi_cmd_max_speed(spi, num);
+	ret = mipi_dbi_spi_transfer(spi, speed_hz, bpw, data, num);
  free:
 	kfree(buf);
 
diff --git a/drivers/gpu/drm/vc4/vc4_dpi.c b/drivers/gpu/drm/vc4/vc4_dpi.c
index a90f2545baee..9c8a71d7426a 100644
--- a/drivers/gpu/drm/vc4/vc4_dpi.c
+++ b/drivers/gpu/drm/vc4/vc4_dpi.c
@@ -148,35 +148,45 @@ static void vc4_dpi_encoder_enable(struct drm_encoder *encoder)
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
diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 665f772f9ffc..7a8353d7ab36 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -785,11 +785,12 @@ static void vc5_hdmi_set_timings(struct vc4_hdmi *vc4_hdmi,
 		     VC4_SET_FIELD(mode->crtc_vdisplay, VC5_HDMI_VERTA_VAL));
 	u32 vertb = (VC4_SET_FIELD(mode->htotal >> (2 - pixel_rep),
 				   VC5_HDMI_VERTB_VSPO) |
-		     VC4_SET_FIELD(mode->crtc_vtotal - mode->crtc_vsync_end,
+		     VC4_SET_FIELD(mode->crtc_vtotal - mode->crtc_vsync_end +
+				   interlaced,
 				   VC4_HDMI_VERTB_VBP));
 	u32 vertb_even = (VC4_SET_FIELD(0, VC5_HDMI_VERTB_VSPO) |
 			  VC4_SET_FIELD(mode->crtc_vtotal -
-					mode->crtc_vsync_end - interlaced,
+					mode->crtc_vsync_end,
 					VC4_HDMI_VERTB_VBP));
 	unsigned char gcp;
 	bool gcp_en;
diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 9d88bfb50c9b..3856ac289d38 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -718,6 +718,17 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
 		      SCALER_DISPCTRL_DSPEISLUR(2) |
 		      SCALER_DISPCTRL_SCLEIRQ);
 
+	/* Set AXI panic mode.
+	 * VC4 panics when < 2 lines in FIFO.
+	 * VC5 panics when less than 1 line in the FIFO.
+	 */
+	dispctrl &= ~(SCALER_DISPCTRL_PANIC0_MASK |
+		      SCALER_DISPCTRL_PANIC1_MASK |
+		      SCALER_DISPCTRL_PANIC2_MASK);
+	dispctrl |= VC4_SET_FIELD(2, SCALER_DISPCTRL_PANIC0);
+	dispctrl |= VC4_SET_FIELD(2, SCALER_DISPCTRL_PANIC1);
+	dispctrl |= VC4_SET_FIELD(2, SCALER_DISPCTRL_PANIC2);
+
 	HVS_WRITE(SCALER_DISPCTRL, dispctrl);
 
 	ret = devm_request_irq(dev, platform_get_irq(pdev, 0),
diff --git a/drivers/gpu/drm/vc4/vc4_plane.c b/drivers/gpu/drm/vc4/vc4_plane.c
index 8574acefd40e..4404059810d0 100644
--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -72,11 +72,13 @@ static const struct hvs_format {
 		.drm = DRM_FORMAT_ARGB1555,
 		.hvs = HVS_PIXEL_FORMAT_RGBA5551,
 		.pixel_order = HVS_PIXEL_ORDER_ABGR,
+		.pixel_order_hvs5 = HVS_PIXEL_ORDER_ARGB,
 	},
 	{
 		.drm = DRM_FORMAT_XRGB1555,
 		.hvs = HVS_PIXEL_FORMAT_RGBA5551,
 		.pixel_order = HVS_PIXEL_ORDER_ABGR,
+		.pixel_order_hvs5 = HVS_PIXEL_ORDER_ARGB,
 	},
 	{
 		.drm = DRM_FORMAT_RGB888,
diff --git a/drivers/gpu/drm/vc4/vc4_regs.h b/drivers/gpu/drm/vc4/vc4_regs.h
index 8ac2f088106a..fe6d0e21ddd8 100644
--- a/drivers/gpu/drm/vc4/vc4_regs.h
+++ b/drivers/gpu/drm/vc4/vc4_regs.h
@@ -220,6 +220,12 @@
 #define SCALER_DISPCTRL                         0x00000000
 /* Global register for clock gating the HVS */
 # define SCALER_DISPCTRL_ENABLE			BIT(31)
+# define SCALER_DISPCTRL_PANIC0_MASK		VC4_MASK(25, 24)
+# define SCALER_DISPCTRL_PANIC0_SHIFT		24
+# define SCALER_DISPCTRL_PANIC1_MASK		VC4_MASK(27, 26)
+# define SCALER_DISPCTRL_PANIC1_SHIFT		26
+# define SCALER_DISPCTRL_PANIC2_MASK		VC4_MASK(29, 28)
+# define SCALER_DISPCTRL_PANIC2_SHIFT		28
 # define SCALER_DISPCTRL_DSP3_MUX_MASK		VC4_MASK(19, 18)
 # define SCALER_DISPCTRL_DSP3_MUX_SHIFT		18
 
diff --git a/drivers/gpu/drm/vkms/vkms_drv.c b/drivers/gpu/drm/vkms/vkms_drv.c
index 0ffe5f0e33f7..f716c5796f5f 100644
--- a/drivers/gpu/drm/vkms/vkms_drv.c
+++ b/drivers/gpu/drm/vkms/vkms_drv.c
@@ -57,7 +57,8 @@ static void vkms_release(struct drm_device *dev)
 {
 	struct vkms_device *vkms = drm_device_to_vkms_device(dev);
 
-	destroy_workqueue(vkms->output.composer_workq);
+	if (vkms->output.composer_workq)
+		destroy_workqueue(vkms->output.composer_workq);
 }
 
 static void vkms_atomic_commit_tail(struct drm_atomic_state *old_state)
@@ -218,6 +219,7 @@ static int vkms_create(struct vkms_config *config)
 
 static int __init vkms_init(void)
 {
+	int ret;
 	struct vkms_config *config;
 
 	config = kmalloc(sizeof(*config), GFP_KERNEL);
@@ -230,7 +232,11 @@ static int __init vkms_init(void)
 	config->writeback = enable_writeback;
 	config->overlay = enable_overlay;
 
-	return vkms_create(config);
+	ret = vkms_create(config);
+	if (ret)
+		kfree(config);
+
+	return ret;
 }
 
 static void vkms_destroy(struct vkms_config *config)
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
index 118318513e2d..c35eac1116f5 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -1165,6 +1165,7 @@ static int ipu_add_client_devices(struct ipu_soc *ipu, unsigned long ipu_base)
 		pdev = platform_device_alloc(reg->name, id++);
 		if (!pdev) {
 			ret = -ENOMEM;
+			of_node_put(of_node);
 			goto err_register;
 		}
 
diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index b59c3dafa6a4..16832e79f6a8 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -98,6 +98,7 @@ struct asus_kbd_leds {
 	struct hid_device *hdev;
 	struct work_struct work;
 	unsigned int brightness;
+	spinlock_t lock;
 	bool removed;
 };
 
@@ -492,21 +493,42 @@ static int rog_nkey_led_init(struct hid_device *hdev)
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
+	unsigned long flags;
+
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
@@ -514,11 +536,11 @@ static void asus_kbd_backlight_work(struct work_struct *work)
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
@@ -586,6 +608,7 @@ static int asus_kbd_register_leds(struct hid_device *hdev)
 	drvdata->kbd_backlight->cdev.brightness_set = asus_kbd_backlight_set;
 	drvdata->kbd_backlight->cdev.brightness_get = asus_kbd_backlight_get;
 	INIT_WORK(&drvdata->kbd_backlight->work, asus_kbd_backlight_work);
+	spin_lock_init(&drvdata->kbd_backlight->lock);
 
 	ret = devm_led_classdev_register(&hdev->dev, &drvdata->kbd_backlight->cdev);
 	if (ret < 0) {
@@ -1121,9 +1144,13 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
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
index f48d3534e020..03da865e423c 100644
--- a/drivers/hid/hid-debug.c
+++ b/drivers/hid/hid-debug.c
@@ -937,6 +937,7 @@ static const char *keys[KEY_MAX + 1] = {
 	[KEY_KBD_LAYOUT_NEXT] = "KbdLayoutNext",
 	[KEY_EMOJI_PICKER] = "EmojiPicker",
 	[KEY_DICTATE] = "Dictate",
+	[KEY_MICMUTE] = "MicrophoneMute",
 	[KEY_BRIGHTNESS_MIN] = "BrightnessMin",
 	[KEY_BRIGHTNESS_MAX] = "BrightnessMax",
 	[KEY_BRIGHTNESS_AUTO] = "BrightnessAuto",
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index f197aed6444a..0ae959e54462 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -709,6 +709,14 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
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
diff --git a/drivers/hid/hid-logitech-hidpp.c b/drivers/hid/hid-logitech-hidpp.c
index 81de88ab2ecc..601ab673727d 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -4049,6 +4049,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	bool connected;
 	unsigned int connect_mask = HID_CONNECT_DEFAULT;
 	struct hidpp_ff_private_data data;
+	bool will_restart = false;
 
 	/* report_fixup needs drvdata to be set before we call hid_parse */
 	hidpp = devm_kzalloc(&hdev->dev, sizeof(*hidpp), GFP_KERNEL);
@@ -4104,6 +4105,10 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			return ret;
 	}
 
+	if (hidpp->quirks & HIDPP_QUIRK_DELAYED_INIT ||
+	    hidpp->quirks & HIDPP_QUIRK_UNIFYING)
+		will_restart = true;
+
 	INIT_WORK(&hidpp->work, delayed_work_cb);
 	mutex_init(&hidpp->send_mutex);
 	init_waitqueue_head(&hidpp->wait);
@@ -4118,7 +4123,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	 * Plain USB connections need to actually call start and open
 	 * on the transport driver to allow incoming data.
 	 */
-	ret = hid_hw_start(hdev, 0);
+	ret = hid_hw_start(hdev, will_restart ? 0 : connect_mask);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
 		goto hid_hw_start_fail;
@@ -4155,6 +4160,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			hidpp->wireless_feature_index = 0;
 		else if (ret)
 			goto hid_hw_init_fail;
+		ret = 0;
 	}
 
 	if (connected && (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)) {
@@ -4169,19 +4175,21 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
 	hidpp_connect_event(hidpp);
 
-	/* Reset the HID node state */
-	hid_device_io_stop(hdev);
-	hid_hw_close(hdev);
-	hid_hw_stop(hdev);
+	if (will_restart) {
+		/* Reset the HID node state */
+		hid_device_io_stop(hdev);
+		hid_hw_close(hdev);
+		hid_hw_stop(hdev);
 
-	if (hidpp->quirks & HIDPP_QUIRK_NO_HIDINPUT)
-		connect_mask &= ~HID_CONNECT_HIDINPUT;
+		if (hidpp->quirks & HIDPP_QUIRK_NO_HIDINPUT)
+			connect_mask &= ~HID_CONNECT_HIDINPUT;
 
-	/* Now export the actual inputs and hidraw nodes to the world */
-	ret = hid_hw_start(hdev, connect_mask);
-	if (ret) {
-		hid_err(hdev, "%s:hid_hw_start returned error\n", __func__);
-		goto hid_hw_start_fail;
+		/* Now export the actual inputs and hidraw nodes to the world */
+		ret = hid_hw_start(hdev, connect_mask);
+		if (ret) {
+			hid_err(hdev, "%s:hid_hw_start returned error\n", __func__);
+			goto hid_hw_start_fail;
+		}
 	}
 
 	if (hidpp->quirks & HIDPP_QUIRK_CLASS_G920) {
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 6b86d368d5e7..592ffdd546fb 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -71,6 +71,7 @@ MODULE_LICENSE("GPL");
 #define MT_QUIRK_SEPARATE_APP_REPORT	BIT(19)
 #define MT_QUIRK_FORCE_MULTI_INPUT	BIT(20)
 #define MT_QUIRK_DISABLE_WAKEUP		BIT(21)
+#define MT_QUIRK_ORIENTATION_INVERT	BIT(22)
 
 #define MT_INPUTMODE_TOUCHSCREEN	0x02
 #define MT_INPUTMODE_TOUCHPAD		0x03
@@ -1009,6 +1010,7 @@ static int mt_process_slot(struct mt_device *td, struct input_dev *input,
 			    struct mt_usages *slot)
 {
 	struct input_mt *mt = input->mt;
+	struct hid_device *hdev = td->hdev;
 	__s32 quirks = app->quirks;
 	bool valid = true;
 	bool confidence_state = true;
@@ -1086,6 +1088,10 @@ static int mt_process_slot(struct mt_device *td, struct input_dev *input,
 		int orientation = wide;
 		int max_azimuth;
 		int azimuth;
+		int x;
+		int y;
+		int cx;
+		int cy;
 
 		if (slot->a != DEFAULT_ZERO) {
 			/*
@@ -1104,6 +1110,9 @@ static int mt_process_slot(struct mt_device *td, struct input_dev *input,
 			if (azimuth > max_azimuth * 2)
 				azimuth -= max_azimuth * 4;
 			orientation = -azimuth;
+			if (quirks & MT_QUIRK_ORIENTATION_INVERT)
+				orientation = -orientation;
+
 		}
 
 		if (quirks & MT_QUIRK_TOUCH_SIZE_SCALING) {
@@ -1115,10 +1124,23 @@ static int mt_process_slot(struct mt_device *td, struct input_dev *input,
 			minor = minor >> 1;
 		}
 
-		input_event(input, EV_ABS, ABS_MT_POSITION_X, *slot->x);
-		input_event(input, EV_ABS, ABS_MT_POSITION_Y, *slot->y);
-		input_event(input, EV_ABS, ABS_MT_TOOL_X, *slot->cx);
-		input_event(input, EV_ABS, ABS_MT_TOOL_Y, *slot->cy);
+		x = hdev->quirks & HID_QUIRK_X_INVERT ?
+			input_abs_get_max(input, ABS_MT_POSITION_X) - *slot->x :
+			*slot->x;
+		y = hdev->quirks & HID_QUIRK_Y_INVERT ?
+			input_abs_get_max(input, ABS_MT_POSITION_Y) - *slot->y :
+			*slot->y;
+		cx = hdev->quirks & HID_QUIRK_X_INVERT ?
+			input_abs_get_max(input, ABS_MT_POSITION_X) - *slot->cx :
+			*slot->cx;
+		cy = hdev->quirks & HID_QUIRK_Y_INVERT ?
+			input_abs_get_max(input, ABS_MT_POSITION_Y) - *slot->cy :
+			*slot->cy;
+
+		input_event(input, EV_ABS, ABS_MT_POSITION_X, x);
+		input_event(input, EV_ABS, ABS_MT_POSITION_Y, y);
+		input_event(input, EV_ABS, ABS_MT_TOOL_X, cx);
+		input_event(input, EV_ABS, ABS_MT_TOOL_Y, cy);
 		input_event(input, EV_ABS, ABS_MT_DISTANCE, !*slot->tip_state);
 		input_event(input, EV_ABS, ABS_MT_ORIENTATION, orientation);
 		input_event(input, EV_ABS, ABS_MT_PRESSURE, *slot->p);
@@ -1738,6 +1760,15 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (id->vendor == HID_ANY_ID && id->product == HID_ANY_ID)
 		td->serial_maybe = true;
 
+
+	/* Orientation is inverted if the X or Y axes are
+	 * flipped, but normalized if both are inverted.
+	 */
+	if (hdev->quirks & (HID_QUIRK_X_INVERT | HID_QUIRK_Y_INVERT) &&
+	    !((hdev->quirks & HID_QUIRK_X_INVERT)
+	      && (hdev->quirks & HID_QUIRK_Y_INVERT)))
+		td->mtclass.quirks = MT_QUIRK_ORIENTATION_INVERT;
+
 	/* This allows the driver to correctly support devices
 	 * that emit events over several HID messages.
 	 */
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 4a8c32148e58..c7c06aa958c4 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -1217,7 +1217,7 @@ EXPORT_SYMBOL_GPL(hid_quirks_exit);
 static unsigned long hid_gets_squirk(const struct hid_device *hdev)
 {
 	const struct hid_device_id *bl_entry;
-	unsigned long quirks = 0;
+	unsigned long quirks = hdev->initial_quirks;
 
 	if (hid_match_id(hdev, hid_ignore_list))
 		quirks |= HID_QUIRK_IGNORE;
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index 65c1f20ec420..7c61bb9291e4 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -1012,6 +1012,10 @@ int i2c_hid_core_probe(struct i2c_client *client, struct i2chid_ops *ops,
 	hid->vendor = le16_to_cpu(ihid->hdesc.wVendorID);
 	hid->product = le16_to_cpu(ihid->hdesc.wProductID);
 
+	hid->initial_quirks = quirks;
+	hid->initial_quirks |= i2c_hid_get_dmi_quirks(hid->vendor,
+						      hid->product);
+
 	snprintf(hid->name, sizeof(hid->name), "%s %04X:%04X",
 		 client->name, (u16)hid->vendor, (u16)hid->product);
 	strlcpy(hid->phys, dev_name(&client->dev), sizeof(hid->phys));
@@ -1025,8 +1029,6 @@ int i2c_hid_core_probe(struct i2c_client *client, struct i2chid_ops *ops,
 		goto err_mem_free;
 	}
 
-	hid->quirks |= quirks;
-
 	return 0;
 
 err_mem_free:
diff --git a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
index 8e0f67455c09..210f17c3a0be 100644
--- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -10,8 +10,10 @@
 #include <linux/types.h>
 #include <linux/dmi.h>
 #include <linux/mod_devicetable.h>
+#include <linux/hid.h>
 
 #include "i2c-hid.h"
+#include "../hid-ids.h"
 
 
 struct i2c_hid_desc_override {
@@ -416,6 +418,28 @@ static const struct dmi_system_id i2c_hid_dmi_desc_override_table[] = {
 	{ }	/* Terminate list */
 };
 
+static const struct hid_device_id i2c_hid_elan_flipped_quirks = {
+	HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8, USB_VENDOR_ID_ELAN, 0x2dcd),
+		HID_QUIRK_X_INVERT | HID_QUIRK_Y_INVERT
+};
+
+/*
+ * This list contains devices which have specific issues based on the system
+ * they're on and not just the device itself. The driver_data will have a
+ * specific hid device to match against.
+ */
+static const struct dmi_system_id i2c_hid_dmi_quirk_table[] = {
+	{
+		.ident = "DynaBook K50/FR",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Dynabook Inc."),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "dynabook K50/FR"),
+		},
+		.driver_data = (void *)&i2c_hid_elan_flipped_quirks,
+	},
+	{ }	/* Terminate list */
+};
+
 
 struct i2c_hid_desc *i2c_hid_get_dmi_i2c_hid_desc_override(uint8_t *i2c_name)
 {
@@ -450,3 +474,21 @@ char *i2c_hid_get_dmi_hid_report_desc_override(uint8_t *i2c_name,
 	*size = override->hid_report_desc_size;
 	return override->hid_report_desc;
 }
+
+u32 i2c_hid_get_dmi_quirks(const u16 vendor, const u16 product)
+{
+	u32 quirks = 0;
+	const struct dmi_system_id *system_id =
+			dmi_first_match(i2c_hid_dmi_quirk_table);
+
+	if (system_id) {
+		const struct hid_device_id *device_id =
+				(struct hid_device_id *)(system_id->driver_data);
+
+		if (device_id && device_id->vendor == vendor &&
+		    device_id->product == product)
+			quirks = device_id->driver_data;
+	}
+
+	return quirks;
+}
diff --git a/drivers/hid/i2c-hid/i2c-hid.h b/drivers/hid/i2c-hid/i2c-hid.h
index 236cc062d5ef..7b93b6c21f12 100644
--- a/drivers/hid/i2c-hid/i2c-hid.h
+++ b/drivers/hid/i2c-hid/i2c-hid.h
@@ -9,6 +9,7 @@
 struct i2c_hid_desc *i2c_hid_get_dmi_i2c_hid_desc_override(uint8_t *i2c_name);
 char *i2c_hid_get_dmi_hid_report_desc_override(uint8_t *i2c_name,
 					       unsigned int *size);
+u32 i2c_hid_get_dmi_quirks(const u16 vendor, const u16 product);
 #else
 static inline struct i2c_hid_desc
 		   *i2c_hid_get_dmi_i2c_hid_desc_override(uint8_t *i2c_name)
@@ -16,6 +17,8 @@ static inline struct i2c_hid_desc
 static inline char *i2c_hid_get_dmi_hid_report_desc_override(uint8_t *i2c_name,
 							     unsigned int *size)
 { return NULL; }
+static inline u32 i2c_hid_get_dmi_quirks(const u16 vendor, const u16 product)
+{ return 0; }
 #endif
 
 /**
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 42b84ebff057..eaae5de2ab61 100644
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
diff --git a/drivers/hwmon/ftsteutates.c b/drivers/hwmon/ftsteutates.c
index ceffc76a0c51..2998d8cdce00 100644
--- a/drivers/hwmon/ftsteutates.c
+++ b/drivers/hwmon/ftsteutates.c
@@ -12,6 +12,7 @@
 #include <linux/i2c.h>
 #include <linux/init.h>
 #include <linux/jiffies.h>
+#include <linux/math.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
@@ -347,13 +348,15 @@ static ssize_t in_value_show(struct device *dev,
 {
 	struct fts_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(devattr)->index;
-	int err;
+	int value, err;
 
 	err = fts_update_device(data);
 	if (err < 0)
 		return err;
 
-	return sprintf(buf, "%u\n", data->volt[index]);
+	value = DIV_ROUND_CLOSEST(data->volt[index] * 3300, 255);
+
+	return sprintf(buf, "%d\n", value);
 }
 
 static ssize_t temp_value_show(struct device *dev,
@@ -361,13 +364,15 @@ static ssize_t temp_value_show(struct device *dev,
 {
 	struct fts_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(devattr)->index;
-	int err;
+	int value, err;
 
 	err = fts_update_device(data);
 	if (err < 0)
 		return err;
 
-	return sprintf(buf, "%u\n", data->temp_input[index]);
+	value = (data->temp_input[index] - 64) * 1000;
+
+	return sprintf(buf, "%d\n", value);
 }
 
 static ssize_t temp_fault_show(struct device *dev,
@@ -436,13 +441,15 @@ static ssize_t fan_value_show(struct device *dev,
 {
 	struct fts_data *data = dev_get_drvdata(dev);
 	int index = to_sensor_dev_attr(devattr)->index;
-	int err;
+	int value, err;
 
 	err = fts_update_device(data);
 	if (err < 0)
 		return err;
 
-	return sprintf(buf, "%u\n", data->fan_input[index]);
+	value = data->fan_input[index] * 60;
+
+	return sprintf(buf, "%d\n", value);
 }
 
 static ssize_t fan_source_show(struct device *dev,
diff --git a/drivers/hwmon/ltc2945.c b/drivers/hwmon/ltc2945.c
index 9adebb59f604..c06ab7317431 100644
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
index 89fe7b9fe26b..6ecc45c06849 100644
--- a/drivers/hwmon/mlxreg-fan.c
+++ b/drivers/hwmon/mlxreg-fan.c
@@ -151,6 +151,12 @@ mlxreg_fan_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
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
diff --git a/drivers/hwtracing/coresight/coresight-cti-core.c b/drivers/hwtracing/coresight/coresight-cti-core.c
index dcd607a0c41a..932e17f00c0b 100644
--- a/drivers/hwtracing/coresight/coresight-cti-core.c
+++ b/drivers/hwtracing/coresight/coresight-cti-core.c
@@ -151,9 +151,16 @@ static int cti_disable_hw(struct cti_drvdata *drvdata)
 {
 	struct cti_config *config = &drvdata->config;
 	struct coresight_device *csdev = drvdata->csdev;
+	int ret = 0;
 
 	spin_lock(&drvdata->spinlock);
 
+	/* don't allow negative refcounts, return an error */
+	if (!atomic_read(&drvdata->config.enable_req_count)) {
+		ret = -EINVAL;
+		goto cti_not_disabled;
+	}
+
 	/* check refcount - disable on 0 */
 	if (atomic_dec_return(&drvdata->config.enable_req_count) > 0)
 		goto cti_not_disabled;
@@ -171,12 +178,12 @@ static int cti_disable_hw(struct cti_drvdata *drvdata)
 	coresight_disclaim_device_unlocked(csdev);
 	CS_LOCK(drvdata->base);
 	spin_unlock(&drvdata->spinlock);
-	return 0;
+	return ret;
 
 	/* not disabled this call */
 cti_not_disabled:
 	spin_unlock(&drvdata->spinlock);
-	return 0;
+	return ret;
 }
 
 void cti_write_single_reg(struct cti_drvdata *drvdata, int offset, u32 value)
diff --git a/drivers/hwtracing/coresight/coresight-cti-sysfs.c b/drivers/hwtracing/coresight/coresight-cti-sysfs.c
index 7ff7e7780bbf..92fc3000872a 100644
--- a/drivers/hwtracing/coresight/coresight-cti-sysfs.c
+++ b/drivers/hwtracing/coresight/coresight-cti-sysfs.c
@@ -108,10 +108,19 @@ static ssize_t enable_store(struct device *dev,
 	if (ret)
 		return ret;
 
-	if (val)
+	if (val) {
+		ret = pm_runtime_resume_and_get(dev->parent);
+		if (ret)
+			return ret;
 		ret = cti_enable(drvdata->csdev);
-	else
+		if (ret)
+			pm_runtime_put(dev->parent);
+	} else {
 		ret = cti_disable(drvdata->csdev);
+		if (!ret)
+			pm_runtime_put(dev->parent);
+	}
+
 	if (ret)
 		return ret;
 	return size;
diff --git a/drivers/hwtracing/coresight/coresight-etm4x-core.c b/drivers/hwtracing/coresight/coresight-etm4x-core.c
index e24252eaf8e4..aa64efa0e05f 100644
--- a/drivers/hwtracing/coresight/coresight-etm4x-core.c
+++ b/drivers/hwtracing/coresight/coresight-etm4x-core.c
@@ -384,8 +384,10 @@ static int etm4_enable_hw(struct etmv4_drvdata *drvdata)
 		etm4x_relaxed_write32(csa, config->vipcssctlr, TRCVIPCSSCTLR);
 	for (i = 0; i < drvdata->nrseqstate - 1; i++)
 		etm4x_relaxed_write32(csa, config->seq_ctrl[i], TRCSEQEVRn(i));
-	etm4x_relaxed_write32(csa, config->seq_rst, TRCSEQRSTEVR);
-	etm4x_relaxed_write32(csa, config->seq_state, TRCSEQSTR);
+	if (drvdata->nrseqstate) {
+		etm4x_relaxed_write32(csa, config->seq_rst, TRCSEQRSTEVR);
+		etm4x_relaxed_write32(csa, config->seq_state, TRCSEQSTR);
+	}
 	etm4x_relaxed_write32(csa, config->ext_inp, TRCEXTINSELR);
 	for (i = 0; i < drvdata->nr_cntr; i++) {
 		etm4x_relaxed_write32(csa, config->cntrldvr[i], TRCCNTRLDVRn(i));
@@ -1618,8 +1620,10 @@ static int etm4_cpu_save(struct etmv4_drvdata *drvdata)
 	for (i = 0; i < drvdata->nrseqstate - 1; i++)
 		state->trcseqevr[i] = etm4x_read32(csa, TRCSEQEVRn(i));
 
-	state->trcseqrstevr = etm4x_read32(csa, TRCSEQRSTEVR);
-	state->trcseqstr = etm4x_read32(csa, TRCSEQSTR);
+	if (drvdata->nrseqstate) {
+		state->trcseqrstevr = etm4x_read32(csa, TRCSEQRSTEVR);
+		state->trcseqstr = etm4x_read32(csa, TRCSEQSTR);
+	}
 	state->trcextinselr = etm4x_read32(csa, TRCEXTINSELR);
 
 	for (i = 0; i < drvdata->nr_cntr; i++) {
@@ -1731,8 +1735,10 @@ static void etm4_cpu_restore(struct etmv4_drvdata *drvdata)
 	for (i = 0; i < drvdata->nrseqstate - 1; i++)
 		etm4x_relaxed_write32(csa, state->trcseqevr[i], TRCSEQEVRn(i));
 
-	etm4x_relaxed_write32(csa, state->trcseqrstevr, TRCSEQRSTEVR);
-	etm4x_relaxed_write32(csa, state->trcseqstr, TRCSEQSTR);
+	if (drvdata->nrseqstate) {
+		etm4x_relaxed_write32(csa, state->trcseqrstevr, TRCSEQRSTEVR);
+		etm4x_relaxed_write32(csa, state->trcseqstr, TRCSEQSTR);
+	}
 	etm4x_relaxed_write32(csa, state->trcextinselr, TRCEXTINSELR);
 
 	for (i = 0; i < drvdata->nr_cntr; i++) {
diff --git a/drivers/i2c/busses/i2c-designware-common.c b/drivers/i2c/busses/i2c-designware-common.c
index 4af65f101dac..4e752321b95e 100644
--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -465,7 +465,7 @@ void __i2c_dw_disable(struct dw_i2c_dev *dev)
 	dev_warn(dev->dev, "timeout in disabling adapter\n");
 }
 
-unsigned long i2c_dw_clk_rate(struct dw_i2c_dev *dev)
+u32 i2c_dw_clk_rate(struct dw_i2c_dev *dev)
 {
 	/*
 	 * Clock is not necessary if we got LCNT/HCNT values directly from
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index 9be81dbebede..59b36e0644f3 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -310,7 +310,7 @@ int i2c_dw_init_regmap(struct dw_i2c_dev *dev);
 u32 i2c_dw_scl_hcnt(u32 ic_clk, u32 tSYMBOL, u32 tf, int cond, int offset);
 u32 i2c_dw_scl_lcnt(u32 ic_clk, u32 tLOW, u32 tf, int offset);
 int i2c_dw_set_sda_hold(struct dw_i2c_dev *dev);
-unsigned long i2c_dw_clk_rate(struct dw_i2c_dev *dev);
+u32 i2c_dw_clk_rate(struct dw_i2c_dev *dev);
 int i2c_dw_prepare_clk(struct dw_i2c_dev *dev, bool prepare);
 int i2c_dw_acquire_lock(struct dw_i2c_dev *dev);
 void i2c_dw_release_lock(struct dw_i2c_dev *dev);
diff --git a/drivers/iio/light/tsl2563.c b/drivers/iio/light/tsl2563.c
index 5bf2bfbc5379..af616352fe71 100644
--- a/drivers/iio/light/tsl2563.c
+++ b/drivers/iio/light/tsl2563.c
@@ -705,6 +705,7 @@ static int tsl2563_probe(struct i2c_client *client,
 	struct iio_dev *indio_dev;
 	struct tsl2563_chip *chip;
 	struct tsl2563_platform_data *pdata = client->dev.platform_data;
+	unsigned long irq_flags;
 	int err = 0;
 	u8 id = 0;
 
@@ -760,10 +761,15 @@ static int tsl2563_probe(struct i2c_client *client,
 		indio_dev->info = &tsl2563_info_no_irq;
 
 	if (client->irq) {
+		irq_flags = irq_get_trigger_type(client->irq);
+		if (irq_flags == IRQF_TRIGGER_NONE)
+			irq_flags = IRQF_TRIGGER_RISING;
+		irq_flags |= IRQF_ONESHOT;
+
 		err = devm_request_threaded_irq(&client->dev, client->irq,
 					   NULL,
 					   &tsl2563_event_handler,
-					   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+					   irq_flags,
 					   "tsl2563_event",
 					   indio_dev);
 		if (err) {
diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 291471d12197..a3e4913904b7 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2682,6 +2682,9 @@ static int pass_establish(struct c4iw_dev *dev, struct sk_buff *skb)
 	u16 tcp_opt = ntohs(req->tcp_opt);
 
 	ep = get_ep_from_tid(dev, tid);
+	if (!ep)
+		return 0;
+
 	pr_debug("ep %p tid %u\n", ep, ep->hwtid);
 	ep->snd_seq = be32_to_cpu(req->snd_isn);
 	ep->rcv_seq = be32_to_cpu(req->rcv_isn);
@@ -4150,6 +4153,10 @@ static int rx_pkt(struct c4iw_dev *dev, struct sk_buff *skb)
 
 	if (neigh->dev->flags & IFF_LOOPBACK) {
 		pdev = ip_dev_find(&init_net, iph->daddr);
+		if (!pdev) {
+			pr_err("%s - failed to find device!\n", __func__);
+			goto free_dst;
+		}
 		e = cxgb4_l2t_get(dev->rdev.lldi.l2t, neigh,
 				    pdev, 0);
 		pi = (struct port_info *)netdev_priv(pdev);
diff --git a/drivers/infiniband/hw/cxgb4/restrack.c b/drivers/infiniband/hw/cxgb4/restrack.c
index ff645b955a08..fd22c85d35f4 100644
--- a/drivers/infiniband/hw/cxgb4/restrack.c
+++ b/drivers/infiniband/hw/cxgb4/restrack.c
@@ -238,7 +238,7 @@ int c4iw_fill_res_cm_id_entry(struct sk_buff *msg,
 	if (rdma_nl_put_driver_u64_hex(msg, "history", epcp->history))
 		goto err_cancel_table;
 
-	if (epcp->state == LISTEN) {
+	if (listen_ep) {
 		if (rdma_nl_put_driver_u32(msg, "stid", listen_ep->stid))
 			goto err_cancel_table;
 		if (rdma_nl_put_driver_u32(msg, "backlog", listen_ep->backlog))
diff --git a/drivers/infiniband/hw/hfi1/sdma.c b/drivers/infiniband/hw/hfi1/sdma.c
index a95b654f5254..8ed20392e9f0 100644
--- a/drivers/infiniband/hw/hfi1/sdma.c
+++ b/drivers/infiniband/hw/hfi1/sdma.c
@@ -3160,8 +3160,7 @@ int _pad_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 {
 	int rval = 0;
 
-	tx->num_desc++;
-	if ((unlikely(tx->num_desc == tx->desc_limit))) {
+	if ((unlikely(tx->num_desc + 1 == tx->desc_limit))) {
 		rval = _extend_sdma_tx_descs(dd, tx);
 		if (rval) {
 			__sdma_txclean(dd, tx);
@@ -3174,6 +3173,7 @@ int _pad_sdma_tx_descs(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 		SDMA_MAP_NONE,
 		dd->sdma_pad_phys,
 		sizeof(u32) - (tx->packet_len & (sizeof(u32) - 1)));
+	tx->num_desc++;
 	_sdma_close_tx(dd, tx);
 	return rval;
 }
diff --git a/drivers/infiniband/hw/hfi1/sdma.h b/drivers/infiniband/hw/hfi1/sdma.h
index d8170fcbfbdd..b023fc461bd5 100644
--- a/drivers/infiniband/hw/hfi1/sdma.h
+++ b/drivers/infiniband/hw/hfi1/sdma.h
@@ -631,14 +631,13 @@ static inline void sdma_txclean(struct hfi1_devdata *dd, struct sdma_txreq *tx)
 static inline void _sdma_close_tx(struct hfi1_devdata *dd,
 				  struct sdma_txreq *tx)
 {
-	tx->descp[tx->num_desc].qw[0] |=
-		SDMA_DESC0_LAST_DESC_FLAG;
-	tx->descp[tx->num_desc].qw[1] |=
-		dd->default_desc1;
+	u16 last_desc = tx->num_desc - 1;
+
+	tx->descp[last_desc].qw[0] |= SDMA_DESC0_LAST_DESC_FLAG;
+	tx->descp[last_desc].qw[1] |= dd->default_desc1;
 	if (tx->flags & SDMA_TXREQ_F_URGENT)
-		tx->descp[tx->num_desc].qw[1] |=
-			(SDMA_DESC1_HEAD_TO_HOST_FLAG |
-			 SDMA_DESC1_INT_REQ_FLAG);
+		tx->descp[last_desc].qw[1] |= (SDMA_DESC1_HEAD_TO_HOST_FLAG |
+					       SDMA_DESC1_INT_REQ_FLAG);
 }
 
 static inline int _sdma_txadd_daddr(
@@ -655,6 +654,7 @@ static inline int _sdma_txadd_daddr(
 		type,
 		addr, len);
 	WARN_ON(len > tx->tlen);
+	tx->num_desc++;
 	tx->tlen -= len;
 	/* special cases for last */
 	if (!tx->tlen) {
@@ -666,7 +666,6 @@ static inline int _sdma_txadd_daddr(
 			_sdma_close_tx(dd, tx);
 		}
 	}
-	tx->num_desc++;
 	return rval;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/user_pages.c b/drivers/infiniband/hw/hfi1/user_pages.c
index 7bce963e2ae6..36aaedc65145 100644
--- a/drivers/infiniband/hw/hfi1/user_pages.c
+++ b/drivers/infiniband/hw/hfi1/user_pages.c
@@ -29,33 +29,52 @@ MODULE_PARM_DESC(cache_size, "Send and receive side cache size limit (in MB)");
 bool hfi1_can_pin_pages(struct hfi1_devdata *dd, struct mm_struct *mm,
 			u32 nlocked, u32 npages)
 {
-	unsigned long ulimit = rlimit(RLIMIT_MEMLOCK), pinned, cache_limit,
-		size = (cache_size * (1UL << 20)); /* convert to bytes */
-	unsigned int usr_ctxts =
-			dd->num_rcv_contexts - dd->first_dyn_alloc_ctxt;
-	bool can_lock = capable(CAP_IPC_LOCK);
+	unsigned long ulimit_pages;
+	unsigned long cache_limit_pages;
+	unsigned int usr_ctxts;
 
 	/*
-	 * Calculate per-cache size. The calculation below uses only a quarter
-	 * of the available per-context limit. This leaves space for other
-	 * pinning. Should we worry about shared ctxts?
+	 * Perform RLIMIT_MEMLOCK based checks unless CAP_IPC_LOCK is present.
 	 */
-	cache_limit = (ulimit / usr_ctxts) / 4;
-
-	/* If ulimit isn't set to "unlimited" and is smaller than cache_size. */
-	if (ulimit != (-1UL) && size > cache_limit)
-		size = cache_limit;
-
-	/* Convert to number of pages */
-	size = DIV_ROUND_UP(size, PAGE_SIZE);
-
-	pinned = atomic64_read(&mm->pinned_vm);
+	if (!capable(CAP_IPC_LOCK)) {
+		ulimit_pages =
+			DIV_ROUND_DOWN_ULL(rlimit(RLIMIT_MEMLOCK), PAGE_SIZE);
+
+		/*
+		 * Pinning these pages would exceed this process's locked memory
+		 * limit.
+		 */
+		if (atomic64_read(&mm->pinned_vm) + npages > ulimit_pages)
+			return false;
+
+		/*
+		 * Only allow 1/4 of the user's RLIMIT_MEMLOCK to be used for HFI
+		 * caches.  This fraction is then equally distributed among all
+		 * existing user contexts.  Note that if RLIMIT_MEMLOCK is
+		 * 'unlimited' (-1), the value of this limit will be > 2^42 pages
+		 * (2^64 / 2^12 / 2^8 / 2^2).
+		 *
+		 * The effectiveness of this check may be reduced if I/O occurs on
+		 * some user contexts before all user contexts are created.  This
+		 * check assumes that this process is the only one using this
+		 * context (e.g., the corresponding fd was not passed to another
+		 * process for concurrent access) as there is no per-context,
+		 * per-process tracking of pinned pages.  It also assumes that each
+		 * user context has only one cache to limit.
+		 */
+		usr_ctxts = dd->num_rcv_contexts - dd->first_dyn_alloc_ctxt;
+		if (nlocked + npages > (ulimit_pages / usr_ctxts / 4))
+			return false;
+	}
 
-	/* First, check the absolute limit against all pinned pages. */
-	if (pinned + npages >= ulimit && !can_lock)
+	/*
+	 * Pinning these pages would exceed the size limit for this cache.
+	 */
+	cache_limit_pages = cache_size * (1024 * 1024) / PAGE_SIZE;
+	if (nlocked + npages > cache_limit_pages)
 		return false;
 
-	return ((nlocked + npages) <= size) || can_lock;
+	return true;
 }
 
 int hfi1_acquire_user_pages(struct mm_struct *mm, unsigned long vaddr, size_t npages,
diff --git a/drivers/infiniband/hw/irdma/hw.c b/drivers/infiniband/hw/irdma/hw.c
index c14f19cff534..b918f80d2e2c 100644
--- a/drivers/infiniband/hw/irdma/hw.c
+++ b/drivers/infiniband/hw/irdma/hw.c
@@ -483,6 +483,8 @@ static enum irdma_status_code irdma_save_msix_info(struct irdma_pci_f *rf)
 	iw_qvlist->num_vectors = rf->msix_count;
 	if (rf->msix_count <= num_online_cpus())
 		rf->msix_shared = true;
+	else if (rf->msix_count > num_online_cpus() + 1)
+		rf->msix_count = num_online_cpus() + 1;
 
 	pmsix = rf->msix_entries;
 	for (i = 0, ceq_idx = 0; i < rf->msix_count; i++, iw_qvinfo++) {
diff --git a/drivers/infiniband/sw/siw/siw_mem.c b/drivers/infiniband/sw/siw/siw_mem.c
index 61c17db70d65..bf69566e2eb6 100644
--- a/drivers/infiniband/sw/siw/siw_mem.c
+++ b/drivers/infiniband/sw/siw/siw_mem.c
@@ -398,7 +398,7 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
 
 	mlock_limit = rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
 
-	if (num_pages + atomic64_read(&mm_s->pinned_vm) > mlock_limit) {
+	if (atomic64_add_return(num_pages, &mm_s->pinned_vm) > mlock_limit) {
 		rv = -ENOMEM;
 		goto out_sem_up;
 	}
@@ -411,18 +411,16 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
 		goto out_sem_up;
 	}
 	for (i = 0; num_pages; i++) {
-		int got, nents = min_t(int, num_pages, PAGES_PER_CHUNK);
-
-		umem->page_chunk[i].plist =
+		int nents = min_t(int, num_pages, PAGES_PER_CHUNK);
+		struct page **plist =
 			kcalloc(nents, sizeof(struct page *), GFP_KERNEL);
-		if (!umem->page_chunk[i].plist) {
+
+		if (!plist) {
 			rv = -ENOMEM;
 			goto out_sem_up;
 		}
-		got = 0;
+		umem->page_chunk[i].plist = plist;
 		while (nents) {
-			struct page **plist = &umem->page_chunk[i].plist[got];
-
 			rv = pin_user_pages(first_page_va, nents,
 					    foll_flags | FOLL_LONGTERM,
 					    plist, NULL);
@@ -430,12 +428,11 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
 				goto out_sem_up;
 
 			umem->num_pages += rv;
-			atomic64_add(rv, &mm_s->pinned_vm);
 			first_page_va += rv * PAGE_SIZE;
+			plist += rv;
 			nents -= rv;
-			got += rv;
+			num_pages -= rv;
 		}
-		num_pages -= got;
 	}
 out_sem_up:
 	mmap_read_unlock(mm_s);
@@ -443,6 +440,10 @@ struct siw_umem *siw_umem_get(u64 start, u64 len, bool writable)
 	if (rv > 0)
 		return umem;
 
+	/* Adjust accounting for pages not pinned */
+	if (num_pages)
+		atomic64_sub(num_pages, &mm_s->pinned_vm);
+
 	siw_umem_release(umem, false);
 
 	return ERR_PTR(rv);
diff --git a/drivers/iommu/intel/cap_audit.c b/drivers/iommu/intel/cap_audit.c
index b12e421a2f1a..71596fc62822 100644
--- a/drivers/iommu/intel/cap_audit.c
+++ b/drivers/iommu/intel/cap_audit.c
@@ -144,6 +144,7 @@ static int cap_audit_static(struct intel_iommu *iommu, enum cap_audit_type type)
 {
 	struct dmar_drhd_unit *d;
 	struct intel_iommu *i;
+	int rc = 0;
 
 	rcu_read_lock();
 	if (list_empty(&dmar_drhd_units))
@@ -163,9 +164,17 @@ static int cap_audit_static(struct intel_iommu *iommu, enum cap_audit_type type)
 			check_irq_capabilities(iommu, i);
 	}
 
+	/*
+	 * If the system is sane to support scalable mode, either SL or FL
+	 * should be sane.
+	 */
+	if (intel_cap_smts_sanity() &&
+	    !intel_cap_flts_sanity() && !intel_cap_slts_sanity())
+		rc = -EOPNOTSUPP;
+
 out:
 	rcu_read_unlock();
-	return 0;
+	return rc;
 }
 
 int intel_cap_audit(enum cap_audit_type type, struct intel_iommu *iommu)
@@ -203,3 +212,8 @@ bool intel_cap_flts_sanity(void)
 {
 	return ecap_flts(intel_iommu_ecap_sanity);
 }
+
+bool intel_cap_slts_sanity(void)
+{
+	return ecap_slts(intel_iommu_ecap_sanity);
+}
diff --git a/drivers/iommu/intel/cap_audit.h b/drivers/iommu/intel/cap_audit.h
index 74cfccae0e81..d07b75938961 100644
--- a/drivers/iommu/intel/cap_audit.h
+++ b/drivers/iommu/intel/cap_audit.h
@@ -111,6 +111,7 @@ bool intel_cap_smts_sanity(void);
 bool intel_cap_pasid_sanity(void);
 bool intel_cap_nest_sanity(void);
 bool intel_cap_flts_sanity(void);
+bool intel_cap_slts_sanity(void);
 
 static inline bool scalable_mode_support(void)
 {
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 751ff91af0ff..29538471c528 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -514,7 +514,7 @@ static inline void free_devinfo_mem(void *vaddr)
 
 static inline int domain_type_is_si(struct dmar_domain *domain)
 {
-	return domain->flags & DOMAIN_FLAG_STATIC_IDENTITY;
+	return domain->domain.type == IOMMU_DOMAIN_IDENTITY;
 }
 
 static inline bool domain_use_first_level(struct dmar_domain *domain)
@@ -1917,12 +1917,21 @@ static void free_dmar_iommu(struct intel_iommu *iommu)
  * Check and return whether first level is used by default for
  * DMA translation.
  */
-static bool first_level_by_default(void)
+static bool first_level_by_default(unsigned int type)
 {
-	return scalable_mode_support() && intel_cap_flts_sanity();
+	/* Only SL is available in legacy mode */
+	if (!scalable_mode_support())
+		return false;
+
+	/* Only level (either FL or SL) is available, just use it */
+	if (intel_cap_flts_sanity() ^ intel_cap_slts_sanity())
+		return intel_cap_flts_sanity();
+
+	/* Both levels are available, decide it based on domain type */
+	return type != IOMMU_DOMAIN_UNMANAGED;
 }
 
-static struct dmar_domain *alloc_domain(int flags)
+static struct dmar_domain *alloc_domain(unsigned int type)
 {
 	struct dmar_domain *domain;
 
@@ -1932,8 +1941,7 @@ static struct dmar_domain *alloc_domain(int flags)
 
 	memset(domain, 0, sizeof(*domain));
 	domain->nid = NUMA_NO_NODE;
-	domain->flags = flags;
-	if (first_level_by_default())
+	if (first_level_by_default(type))
 		domain->flags |= DOMAIN_FLAG_USE_FIRST_LEVEL;
 	domain->has_iotlb_device = false;
 	INIT_LIST_HEAD(&domain->devices);
@@ -2753,7 +2761,7 @@ static int __init si_domain_init(int hw)
 	struct device *dev;
 	int i, nid, ret;
 
-	si_domain = alloc_domain(DOMAIN_FLAG_STATIC_IDENTITY);
+	si_domain = alloc_domain(IOMMU_DOMAIN_IDENTITY);
 	if (!si_domain)
 		return -EFAULT;
 
@@ -4415,7 +4423,8 @@ int __init intel_iommu_init(void)
 		 * is likely to be much lower than the overhead of synchronizing
 		 * the virtual and physical IOMMU page-tables.
 		 */
-		if (cap_caching_mode(iommu->cap)) {
+		if (cap_caching_mode(iommu->cap) &&
+		    !first_level_by_default(IOMMU_DOMAIN_DMA)) {
 			pr_info_once("IOMMU batching disallowed due to virtualization\n");
 			iommu_set_dma_strict();
 		}
@@ -4555,7 +4564,7 @@ static struct iommu_domain *intel_iommu_domain_alloc(unsigned type)
 	case IOMMU_DOMAIN_DMA:
 	case IOMMU_DOMAIN_DMA_FQ:
 	case IOMMU_DOMAIN_UNMANAGED:
-		dmar_domain = alloc_domain(0);
+		dmar_domain = alloc_domain(type);
 		if (!dmar_domain) {
 			pr_err("Can't allocate dmar_domain\n");
 			return NULL;
@@ -5131,7 +5140,12 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
 	if (dmar_domain->max_addr == iova + size)
 		dmar_domain->max_addr = iova;
 
-	iommu_iotlb_gather_add_page(domain, gather, iova, size);
+	/*
+	 * We do not use page-selective IOTLB invalidation in flush queue,
+	 * so there is no need to track page and sync iotlb.
+	 */
+	if (!iommu_iotlb_gather_queued(gather))
+		iommu_iotlb_gather_add_page(domain, gather, iova, size);
 
 	return size;
 }
@@ -5405,8 +5419,12 @@ static int intel_iommu_enable_sva(struct device *dev)
 		return -EINVAL;
 
 	ret = iopf_queue_add_device(iommu->iopf_queue, dev);
-	if (!ret)
-		ret = iommu_register_device_fault_handler(dev, iommu_queue_iopf, dev);
+	if (ret)
+		return ret;
+
+	ret = iommu_register_device_fault_handler(dev, iommu_queue_iopf, dev);
+	if (ret)
+		iopf_queue_remove_device(iommu->iopf_queue, dev);
 
 	return ret;
 }
@@ -5418,8 +5436,12 @@ static int intel_iommu_disable_sva(struct device *dev)
 	int ret;
 
 	ret = iommu_unregister_device_fault_handler(dev);
-	if (!ret)
-		ret = iopf_queue_remove_device(iommu->iopf_queue, dev);
+	if (ret)
+		return ret;
+
+	ret = iopf_queue_remove_device(iommu->iopf_queue, dev);
+	if (ret)
+		iommu_register_device_fault_handler(dev, iommu_queue_iopf, dev);
 
 	return ret;
 }
diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 0060bd089dc7..9a3dd55aaa1c 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -425,6 +425,16 @@ static inline void pasid_set_page_snoop(struct pasid_entry *pe, bool value)
 	pasid_set_bits(&pe->val[1], 1 << 23, value << 23);
 }
 
+/*
+ * Setup No Execute Enable bit (Bit 133) of a scalable mode PASID
+ * entry. It is required when XD bit of the first level page table
+ * entry is about to be set.
+ */
+static inline void pasid_set_nxe(struct pasid_entry *pe)
+{
+	pasid_set_bits(&pe->val[2], 1 << 5, 1 << 5);
+}
+
 /*
  * Setup the Page Snoop (PGSNP) field (Bit 88) of a scalable mode
  * PASID entry.
@@ -631,6 +641,7 @@ int intel_pasid_setup_first_level(struct intel_iommu *iommu,
 	pasid_set_domain_id(pte, did);
 	pasid_set_address_width(pte, iommu->agaw);
 	pasid_set_page_snoop(pte, !!ecap_smpwc(iommu->ecap));
+	pasid_set_nxe(pte);
 
 	/* Setup Present and PASID Granular Transfer Type: */
 	pasid_set_translation_type(pte, PASID_ENTRY_PGTT_FL_ONLY);
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 7f409e9eea4b..d06dbf035c7c 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -656,12 +656,16 @@ struct iommu_group *iommu_group_alloc(void)
 
 	ret = iommu_group_create_file(group,
 				      &iommu_group_attr_reserved_regions);
-	if (ret)
+	if (ret) {
+		kobject_put(group->devices_kobj);
 		return ERR_PTR(ret);
+	}
 
 	ret = iommu_group_create_file(group, &iommu_group_attr_type);
-	if (ret)
+	if (ret) {
+		kobject_put(group->devices_kobj);
 		return ERR_PTR(ret);
+	}
 
 	pr_debug("Allocated group %d\n", group->id);
 
diff --git a/drivers/irqchip/irq-alpine-msi.c b/drivers/irqchip/irq-alpine-msi.c
index 5ddb8e578ac6..fc1ef7de3797 100644
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
index f23d7651ea84..e91b38a6fc3d 100644
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
diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
index 8e0911561f2d..fddea7227246 100644
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
index fe88a782173d..c43a345061d5 100644
--- a/drivers/irqchip/irq-mvebu-gicp.c
+++ b/drivers/irqchip/irq-mvebu-gicp.c
@@ -221,6 +221,7 @@ static int mvebu_gicp_probe(struct platform_device *pdev)
 	}
 
 	parent_domain = irq_find_host(irq_parent_dn);
+	of_node_put(irq_parent_dn);
 	if (!parent_domain) {
 		dev_err(&pdev->dev, "failed to find parent IRQ domain\n");
 		return -ENODEV;
diff --git a/drivers/irqchip/irq-ti-sci-intr.c b/drivers/irqchip/irq-ti-sci-intr.c
index fe8fad22bcf9..020ddf29efb8 100644
--- a/drivers/irqchip/irq-ti-sci-intr.c
+++ b/drivers/irqchip/irq-ti-sci-intr.c
@@ -236,6 +236,7 @@ static int ti_sci_intr_irq_domain_probe(struct platform_device *pdev)
 	}
 
 	parent_domain = irq_find_host(parent_node);
+	of_node_put(parent_node);
 	if (!parent_domain) {
 		dev_err(dev, "Failed to find IRQ parent domain\n");
 		return -ENODEV;
diff --git a/drivers/irqchip/irqchip.c b/drivers/irqchip/irqchip.c
index 3570f0a588c4..7899607fbee8 100644
--- a/drivers/irqchip/irqchip.c
+++ b/drivers/irqchip/irqchip.c
@@ -38,8 +38,10 @@ int platform_irqchip_probe(struct platform_device *pdev)
 	struct device_node *par_np = of_irq_find_parent(np);
 	of_irq_init_cb_t irq_init_cb = of_device_get_match_data(&pdev->dev);
 
-	if (!irq_init_cb)
+	if (!irq_init_cb) {
+		of_node_put(par_np);
 		return -EINVAL;
+	}
 
 	if (par_np == np)
 		par_np = NULL;
@@ -52,8 +54,10 @@ int platform_irqchip_probe(struct platform_device *pdev)
 	 * interrupt controller. The actual initialization callback of this
 	 * interrupt controller can check for specific domains as necessary.
 	 */
-	if (par_np && !irq_find_matching_host(par_np, DOMAIN_BUS_ANY))
+	if (par_np && !irq_find_matching_host(par_np, DOMAIN_BUS_ANY)) {
+		of_node_put(par_np);
 		return -EPROBE_DEFER;
+	}
 
 	return irq_init_cb(np, par_np);
 }
diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index f4bb02f6e042..1024b1562aaf 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -235,14 +235,17 @@ struct led_classdev *of_led_get(struct device_node *np, int index)
 
 	led_dev = class_find_device_by_of_node(leds_class, led_node);
 	of_node_put(led_node);
+	put_device(led_dev);
 
 	if (!led_dev)
 		return ERR_PTR(-EPROBE_DEFER);
 
 	led_cdev = dev_get_drvdata(led_dev);
 
-	if (!try_module_get(led_cdev->dev->parent->driver->owner))
+	if (!try_module_get(led_cdev->dev->parent->driver->owner)) {
+		put_device(led_cdev->dev);
 		return ERR_PTR(-ENODEV);
+	}
 
 	return led_cdev;
 }
@@ -255,6 +258,7 @@ EXPORT_SYMBOL_GPL(of_led_get);
 void led_put(struct led_classdev *led_cdev)
 {
 	module_put(led_cdev->dev->parent->driver->owner);
+	put_device(led_cdev->dev);
 }
 EXPORT_SYMBOL_GPL(led_put);
 
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index abfe7e37b76f..24cd28ea2c59 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1813,6 +1813,7 @@ static void process_deferred_bios(struct work_struct *ws)
 
 		else
 			commit_needed = process_bio(cache, bio) || commit_needed;
+		cond_resched();
 	}
 
 	if (commit_needed)
@@ -1835,6 +1836,7 @@ static void requeue_deferred_bios(struct cache *cache)
 	while ((bio = bio_list_pop(&bios))) {
 		bio->bi_status = BLK_STS_DM_REQUEUE;
 		bio_endio(bio);
+		cond_resched();
 	}
 }
 
@@ -1875,6 +1877,8 @@ static void check_migrations(struct work_struct *ws)
 		r = mg_start(cache, op, NULL);
 		if (r)
 			break;
+
+		cond_resched();
 	}
 }
 
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 4b94ffe6f2d4..bf7f205354f0 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -301,9 +301,13 @@ static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
 	 */
 	bio_for_each_segment(bvec, bio, iter) {
 		if (bio_iter_len(bio, iter) > corrupt_bio_byte) {
-			char *segment = (page_address(bio_iter_page(bio, iter))
-					 + bio_iter_offset(bio, iter));
+			char *segment;
+			struct page *page = bio_iter_page(bio, iter);
+			if (unlikely(page == ZERO_PAGE(0)))
+				break;
+			segment = bvec_kmap_local(&bvec);
 			segment[corrupt_bio_byte] = fc->corrupt_bio_value;
+			kunmap_local(segment);
 			DMDEBUG("Corrupting data bio=%p by writing %u to byte %u "
 				"(rw=%c bi_opf=%u bi_sector=%llu size=%u)\n",
 				bio, fc->corrupt_bio_value, fc->corrupt_bio_byte,
@@ -359,9 +363,11 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
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
 
@@ -387,13 +393,14 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
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
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index dcaca4aaac91..e277feb5ff93 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -482,7 +482,7 @@ static struct mapped_device *dm_hash_rename(struct dm_ioctl *param,
 		dm_table_event(table);
 	dm_put_live_table(hc->md, srcu_idx);
 
-	if (!dm_kobject_uevent(hc->md, KOBJ_CHANGE, param->event_nr))
+	if (!dm_kobject_uevent(hc->md, KOBJ_CHANGE, param->event_nr, false))
 		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
 	md = hc->md;
@@ -989,7 +989,7 @@ static int dev_remove(struct file *filp, struct dm_ioctl *param, size_t param_si
 
 	dm_ima_measure_on_device_remove(md, false);
 
-	if (!dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr))
+	if (!dm_kobject_uevent(md, KOBJ_REMOVE, param->event_nr, false))
 		param->flags |= DM_UEVENT_GENERATED_FLAG;
 
 	dm_put(md);
@@ -1123,6 +1123,7 @@ static int do_resume(struct dm_ioctl *param)
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	struct dm_table *new_map, *old_map = NULL;
+	bool need_resize_uevent = false;
 
 	down_write(&_hash_lock);
 
@@ -1143,6 +1144,8 @@ static int do_resume(struct dm_ioctl *param)
 
 	/* Do we need to load a new map ? */
 	if (new_map) {
+		sector_t old_size, new_size;
+
 		/* Suspend if it isn't already suspended */
 		if (param->flags & DM_SKIP_LOCKFS_FLAG)
 			suspend_flags &= ~DM_SUSPEND_LOCKFS_FLAG;
@@ -1151,6 +1154,7 @@ static int do_resume(struct dm_ioctl *param)
 		if (!dm_suspended_md(md))
 			dm_suspend(md, suspend_flags);
 
+		old_size = dm_get_size(md);
 		old_map = dm_swap_table(md, new_map);
 		if (IS_ERR(old_map)) {
 			dm_sync_table(md);
@@ -1158,6 +1162,9 @@ static int do_resume(struct dm_ioctl *param)
 			dm_put(md);
 			return PTR_ERR(old_map);
 		}
+		new_size = dm_get_size(md);
+		if (old_size && new_size && old_size != new_size)
+			need_resize_uevent = true;
 
 		if (dm_table_get_mode(new_map) & FMODE_WRITE)
 			set_disk_ro(dm_disk(md), 0);
@@ -1170,7 +1177,7 @@ static int do_resume(struct dm_ioctl *param)
 		if (!r) {
 			dm_ima_measure_on_device_resume(md, new_map ? true : false);
 
-			if (!dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr))
+			if (!dm_kobject_uevent(md, KOBJ_CHANGE, param->event_nr, need_resize_uevent))
 				param->flags |= DM_UEVENT_GENERATED_FLAG;
 		}
 	}
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index cce26f46ded5..f7124f257703 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -2217,6 +2217,7 @@ static void process_thin_deferred_bios(struct thin_c *tc)
 			throttle_work_update(&pool->throttle);
 			dm_pool_issue_prefetches(pool->pmd);
 		}
+		cond_resched();
 	}
 	blk_finish_plug(&plug);
 }
@@ -2299,6 +2300,7 @@ static void process_thin_deferred_cells(struct thin_c *tc)
 			else
 				pool->process_cell(tc, cell);
 		}
+		cond_resched();
 	} while (!list_empty(&cells));
 }
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 9dd2c2da075d..0bd2185d5194 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -226,7 +226,6 @@ static int __init local_init(void)
 
 static void local_exit(void)
 {
-	flush_scheduled_work();
 	destroy_workqueue(deferred_remove_workqueue);
 
 	unregister_blkdev(_major, _name);
@@ -1943,10 +1942,7 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 	if (size != dm_get_size(md))
 		memset(&md->geometry, 0, sizeof(md->geometry));
 
-	if (!get_capacity(md->disk))
-		set_capacity(md->disk, size);
-	else
-		set_capacity_and_notify(md->disk, size);
+	set_capacity(md->disk, size);
 
 	dm_table_event_callback(t, event_callback, md);
 
@@ -2309,6 +2305,7 @@ static void dm_wq_work(struct work_struct *work)
 			break;
 
 		submit_bio_noacct(bio);
+		cond_resched();
 	}
 }
 
@@ -2708,23 +2705,25 @@ EXPORT_SYMBOL_GPL(dm_internal_resume_fast);
  * Event notification.
  *---------------------------------------------------------------*/
 int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
-		       unsigned cookie)
+		      unsigned cookie, bool need_resize_uevent)
 {
 	int r;
 	unsigned noio_flag;
 	char udev_cookie[DM_COOKIE_LENGTH];
-	char *envp[] = { udev_cookie, NULL };
-
-	noio_flag = memalloc_noio_save();
-
-	if (!cookie)
-		r = kobject_uevent(&disk_to_dev(md->disk)->kobj, action);
-	else {
+	char *envp[3] = { NULL, NULL, NULL };
+	char **envpp = envp;
+	if (cookie) {
 		snprintf(udev_cookie, DM_COOKIE_LENGTH, "%s=%u",
 			 DM_COOKIE_ENV_VAR_NAME, cookie);
-		r = kobject_uevent_env(&disk_to_dev(md->disk)->kobj,
-				       action, envp);
+		*envpp++ = udev_cookie;
 	}
+	if (need_resize_uevent) {
+		*envpp++ = "RESIZE=1";
+	}
+
+	noio_flag = memalloc_noio_save();
+
+	r = kobject_uevent_env(&disk_to_dev(md->disk)->kobj, action, envp);
 
 	memalloc_noio_restore(noio_flag);
 
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 742d9c80efe1..10e4a3482db8 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -210,7 +210,7 @@ int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
 void dm_put_table_device(struct mapped_device *md, struct dm_dev *d);
 
 int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
-		      unsigned cookie);
+		      unsigned cookie, bool need_resize_uevent);
 
 void dm_internal_suspend(struct mapped_device *md);
 void dm_internal_resume(struct mapped_device *md);
diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index e10af3f74b38..de1f0aa6fff4 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -89,6 +89,12 @@
 
 #define IMX219_REG_ORIENTATION		0x0172
 
+/* Binning  Mode */
+#define IMX219_REG_BINNING_MODE		0x0174
+#define IMX219_BINNING_NONE		0x0000
+#define IMX219_BINNING_2X2		0x0101
+#define IMX219_BINNING_2X2_ANALOG	0x0303
+
 /* Test Pattern Control */
 #define IMX219_REG_TEST_PATTERN		0x0600
 #define IMX219_TEST_PATTERN_DISABLE	0
@@ -143,25 +149,66 @@ struct imx219_mode {
 
 	/* Default register values */
 	struct imx219_reg_list reg_list;
+
+	/* 2x2 binning is used */
+	bool binning;
 };
 
-/*
- * Register sets lifted off the i2C interface from the Raspberry Pi firmware
- * driver.
- * 3280x2464 = mode 2, 1920x1080 = mode 1, 1640x1232 = mode 4, 640x480 = mode 7.
- */
-static const struct imx219_reg mode_3280x2464_regs[] = {
-	{0x0100, 0x00},
+static const struct imx219_reg imx219_common_regs[] = {
+	{0x0100, 0x00},	/* Mode Select */
+
+	/* To Access Addresses 3000-5fff, send the following commands */
 	{0x30eb, 0x0c},
 	{0x30eb, 0x05},
 	{0x300a, 0xff},
 	{0x300b, 0xff},
 	{0x30eb, 0x05},
 	{0x30eb, 0x09},
-	{0x0114, 0x01},
-	{0x0128, 0x00},
-	{0x012a, 0x18},
+
+	/* PLL Clock Table */
+	{0x0301, 0x05},	/* VTPXCK_DIV */
+	{0x0303, 0x01},	/* VTSYSCK_DIV */
+	{0x0304, 0x03},	/* PREPLLCK_VT_DIV 0x03 = AUTO set */
+	{0x0305, 0x03}, /* PREPLLCK_OP_DIV 0x03 = AUTO set */
+	{0x0306, 0x00},	/* PLL_VT_MPY */
+	{0x0307, 0x39},
+	{0x030b, 0x01},	/* OP_SYS_CLK_DIV */
+	{0x030c, 0x00},	/* PLL_OP_MPY */
+	{0x030d, 0x72},
+
+	/* Undocumented registers */
+	{0x455e, 0x00},
+	{0x471e, 0x4b},
+	{0x4767, 0x0f},
+	{0x4750, 0x14},
+	{0x4540, 0x00},
+	{0x47b4, 0x14},
+	{0x4713, 0x30},
+	{0x478b, 0x10},
+	{0x478f, 0x10},
+	{0x4793, 0x10},
+	{0x4797, 0x0e},
+	{0x479b, 0x0e},
+
+	/* Frame Bank Register Group "A" */
+	{0x0162, 0x0d},	/* Line_Length_A */
+	{0x0163, 0x78},
+	{0x0170, 0x01}, /* X_ODD_INC_A */
+	{0x0171, 0x01}, /* Y_ODD_INC_A */
+
+	/* Output setup registers */
+	{0x0114, 0x01},	/* CSI 2-Lane Mode */
+	{0x0128, 0x00},	/* DPHY Auto Mode */
+	{0x012a, 0x18},	/* EXCK_Freq */
 	{0x012b, 0x00},
+};
+
+/*
+ * Register sets lifted off the i2C interface from the Raspberry Pi firmware
+ * driver.
+ * 3280x2464 = mode 2, 1920x1080 = mode 1, 1640x1232 = mode 4, 640x480 = mode 7.
+ */
+static const struct imx219_reg mode_3280x2464_regs[] = {
 	{0x0164, 0x00},
 	{0x0165, 0x00},
 	{0x0166, 0x0c},
@@ -174,53 +221,13 @@ static const struct imx219_reg mode_3280x2464_regs[] = {
 	{0x016d, 0xd0},
 	{0x016e, 0x09},
 	{0x016f, 0xa0},
-	{0x0170, 0x01},
-	{0x0171, 0x01},
-	{0x0174, 0x00},
-	{0x0175, 0x00},
-	{0x0301, 0x05},
-	{0x0303, 0x01},
-	{0x0304, 0x03},
-	{0x0305, 0x03},
-	{0x0306, 0x00},
-	{0x0307, 0x39},
-	{0x030b, 0x01},
-	{0x030c, 0x00},
-	{0x030d, 0x72},
 	{0x0624, 0x0c},
 	{0x0625, 0xd0},
 	{0x0626, 0x09},
 	{0x0627, 0xa0},
-	{0x455e, 0x00},
-	{0x471e, 0x4b},
-	{0x4767, 0x0f},
-	{0x4750, 0x14},
-	{0x4540, 0x00},
-	{0x47b4, 0x14},
-	{0x4713, 0x30},
-	{0x478b, 0x10},
-	{0x478f, 0x10},
-	{0x4793, 0x10},
-	{0x4797, 0x0e},
-	{0x479b, 0x0e},
-	{0x0162, 0x0d},
-	{0x0163, 0x78},
 };
 
 static const struct imx219_reg mode_1920_1080_regs[] = {
-	{0x0100, 0x00},
-	{0x30eb, 0x05},
-	{0x30eb, 0x0c},
-	{0x300a, 0xff},
-	{0x300b, 0xff},
-	{0x30eb, 0x05},
-	{0x30eb, 0x09},
-	{0x0114, 0x01},
-	{0x0128, 0x00},
-	{0x012a, 0x18},
-	{0x012b, 0x00},
-	{0x0162, 0x0d},
-	{0x0163, 0x78},
 	{0x0164, 0x02},
 	{0x0165, 0xa8},
 	{0x0166, 0x0a},
@@ -233,49 +240,13 @@ static const struct imx219_reg mode_1920_1080_regs[] = {
 	{0x016d, 0x80},
 	{0x016e, 0x04},
 	{0x016f, 0x38},
-	{0x0170, 0x01},
-	{0x0171, 0x01},
-	{0x0174, 0x00},
-	{0x0175, 0x00},
-	{0x0301, 0x05},
-	{0x0303, 0x01},
-	{0x0304, 0x03},
-	{0x0305, 0x03},
-	{0x0306, 0x00},
-	{0x0307, 0x39},
-	{0x030b, 0x01},
-	{0x030c, 0x00},
-	{0x030d, 0x72},
 	{0x0624, 0x07},
 	{0x0625, 0x80},
 	{0x0626, 0x04},
 	{0x0627, 0x38},
-	{0x455e, 0x00},
-	{0x471e, 0x4b},
-	{0x4767, 0x0f},
-	{0x4750, 0x14},
-	{0x4540, 0x00},
-	{0x47b4, 0x14},
-	{0x4713, 0x30},
-	{0x478b, 0x10},
-	{0x478f, 0x10},
-	{0x4793, 0x10},
-	{0x4797, 0x0e},
-	{0x479b, 0x0e},
 };
 
 static const struct imx219_reg mode_1640_1232_regs[] = {
-	{0x0100, 0x00},
-	{0x30eb, 0x0c},
-	{0x30eb, 0x05},
-	{0x300a, 0xff},
-	{0x300b, 0xff},
-	{0x30eb, 0x05},
-	{0x30eb, 0x09},
-	{0x0114, 0x01},
-	{0x0128, 0x00},
-	{0x012a, 0x18},
-	{0x012b, 0x00},
 	{0x0164, 0x00},
 	{0x0165, 0x00},
 	{0x0166, 0x0c},
@@ -288,53 +259,13 @@ static const struct imx219_reg mode_1640_1232_regs[] = {
 	{0x016d, 0x68},
 	{0x016e, 0x04},
 	{0x016f, 0xd0},
-	{0x0170, 0x01},
-	{0x0171, 0x01},
-	{0x0174, 0x01},
-	{0x0175, 0x01},
-	{0x0301, 0x05},
-	{0x0303, 0x01},
-	{0x0304, 0x03},
-	{0x0305, 0x03},
-	{0x0306, 0x00},
-	{0x0307, 0x39},
-	{0x030b, 0x01},
-	{0x030c, 0x00},
-	{0x030d, 0x72},
 	{0x0624, 0x06},
 	{0x0625, 0x68},
 	{0x0626, 0x04},
 	{0x0627, 0xd0},
-	{0x455e, 0x00},
-	{0x471e, 0x4b},
-	{0x4767, 0x0f},
-	{0x4750, 0x14},
-	{0x4540, 0x00},
-	{0x47b4, 0x14},
-	{0x4713, 0x30},
-	{0x478b, 0x10},
-	{0x478f, 0x10},
-	{0x4793, 0x10},
-	{0x4797, 0x0e},
-	{0x479b, 0x0e},
-	{0x0162, 0x0d},
-	{0x0163, 0x78},
 };
 
 static const struct imx219_reg mode_640_480_regs[] = {
-	{0x0100, 0x00},
-	{0x30eb, 0x05},
-	{0x30eb, 0x0c},
-	{0x300a, 0xff},
-	{0x300b, 0xff},
-	{0x30eb, 0x05},
-	{0x30eb, 0x09},
-	{0x0114, 0x01},
-	{0x0128, 0x00},
-	{0x012a, 0x18},
-	{0x012b, 0x00},
-	{0x0162, 0x0d},
-	{0x0163, 0x78},
 	{0x0164, 0x03},
 	{0x0165, 0xe8},
 	{0x0166, 0x08},
@@ -347,35 +278,10 @@ static const struct imx219_reg mode_640_480_regs[] = {
 	{0x016d, 0x80},
 	{0x016e, 0x01},
 	{0x016f, 0xe0},
-	{0x0170, 0x01},
-	{0x0171, 0x01},
-	{0x0174, 0x03},
-	{0x0175, 0x03},
-	{0x0301, 0x05},
-	{0x0303, 0x01},
-	{0x0304, 0x03},
-	{0x0305, 0x03},
-	{0x0306, 0x00},
-	{0x0307, 0x39},
-	{0x030b, 0x01},
-	{0x030c, 0x00},
-	{0x030d, 0x72},
 	{0x0624, 0x06},
 	{0x0625, 0x68},
 	{0x0626, 0x04},
 	{0x0627, 0xd0},
-	{0x455e, 0x00},
-	{0x471e, 0x4b},
-	{0x4767, 0x0f},
-	{0x4750, 0x14},
-	{0x4540, 0x00},
-	{0x47b4, 0x14},
-	{0x4713, 0x30},
-	{0x478b, 0x10},
-	{0x478f, 0x10},
-	{0x4793, 0x10},
-	{0x4797, 0x0e},
-	{0x479b, 0x0e},
 };
 
 static const struct imx219_reg raw8_framefmt_regs[] = {
@@ -485,6 +391,7 @@ static const struct imx219_mode supported_modes[] = {
 			.num_of_regs = ARRAY_SIZE(mode_3280x2464_regs),
 			.regs = mode_3280x2464_regs,
 		},
+		.binning = false,
 	},
 	{
 		/* 1080P 30fps cropped */
@@ -501,6 +408,7 @@ static const struct imx219_mode supported_modes[] = {
 			.num_of_regs = ARRAY_SIZE(mode_1920_1080_regs),
 			.regs = mode_1920_1080_regs,
 		},
+		.binning = false,
 	},
 	{
 		/* 2x2 binned 30fps mode */
@@ -517,6 +425,7 @@ static const struct imx219_mode supported_modes[] = {
 			.num_of_regs = ARRAY_SIZE(mode_1640_1232_regs),
 			.regs = mode_1640_1232_regs,
 		},
+		.binning = true,
 	},
 	{
 		/* 640x480 30fps mode */
@@ -533,6 +442,7 @@ static const struct imx219_mode supported_modes[] = {
 			.num_of_regs = ARRAY_SIZE(mode_640_480_regs),
 			.regs = mode_640_480_regs,
 		},
+		.binning = true,
 	},
 };
 
@@ -979,6 +889,35 @@ static int imx219_set_framefmt(struct imx219 *imx219)
 	return -EINVAL;
 }
 
+static int imx219_set_binning(struct imx219 *imx219)
+{
+	if (!imx219->mode->binning) {
+		return imx219_write_reg(imx219, IMX219_REG_BINNING_MODE,
+					IMX219_REG_VALUE_16BIT,
+					IMX219_BINNING_NONE);
+	}
+
+	switch (imx219->fmt.code) {
+	case MEDIA_BUS_FMT_SRGGB8_1X8:
+	case MEDIA_BUS_FMT_SGRBG8_1X8:
+	case MEDIA_BUS_FMT_SGBRG8_1X8:
+	case MEDIA_BUS_FMT_SBGGR8_1X8:
+		return imx219_write_reg(imx219, IMX219_REG_BINNING_MODE,
+					IMX219_REG_VALUE_16BIT,
+					IMX219_BINNING_2X2_ANALOG);
+
+	case MEDIA_BUS_FMT_SRGGB10_1X10:
+	case MEDIA_BUS_FMT_SGRBG10_1X10:
+	case MEDIA_BUS_FMT_SGBRG10_1X10:
+	case MEDIA_BUS_FMT_SBGGR10_1X10:
+		return imx219_write_reg(imx219, IMX219_REG_BINNING_MODE,
+					IMX219_REG_VALUE_16BIT,
+					IMX219_BINNING_2X2);
+	}
+
+	return -EINVAL;
+}
+
 static const struct v4l2_rect *
 __imx219_get_pad_crop(struct imx219 *imx219,
 		      struct v4l2_subdev_state *sd_state,
@@ -1041,6 +980,13 @@ static int imx219_start_streaming(struct imx219 *imx219)
 	if (ret < 0)
 		return ret;
 
+	/* Send all registers that are common to all modes */
+	ret = imx219_write_regs(imx219, imx219_common_regs, ARRAY_SIZE(imx219_common_regs));
+	if (ret) {
+		dev_err(&client->dev, "%s failed to send mfg header\n", __func__);
+		goto err_rpm_put;
+	}
+
 	/* Apply default values of current mode */
 	reg_list = &imx219->mode->reg_list;
 	ret = imx219_write_regs(imx219, reg_list->regs, reg_list->num_of_regs);
@@ -1056,6 +1002,13 @@ static int imx219_start_streaming(struct imx219 *imx219)
 		goto err_rpm_put;
 	}
 
+	ret = imx219_set_binning(imx219);
+	if (ret) {
+		dev_err(&client->dev, "%s failed to set binning: %d\n",
+			__func__, ret);
+		goto err_rpm_put;
+	}
+
 	/* Apply customized values from user */
 	ret =  __v4l2_ctrl_handler_setup(imx219->sd.ctrl_handler);
 	if (ret)
diff --git a/drivers/media/i2c/max9286.c b/drivers/media/i2c/max9286.c
index ce943702ffe9..b9513e93ac61 100644
--- a/drivers/media/i2c/max9286.c
+++ b/drivers/media/i2c/max9286.c
@@ -928,6 +928,7 @@ static int max9286_v4l2_register(struct max9286_priv *priv)
 err_put_node:
 	fwnode_handle_put(ep);
 err_async:
+	v4l2_ctrl_handler_free(&priv->ctrls);
 	max9286_v4l2_notifier_unregister(priv);
 
 	return ret;
diff --git a/drivers/media/i2c/ov2740.c b/drivers/media/i2c/ov2740.c
index 934c9d65cb09..4b1ab3e07910 100644
--- a/drivers/media/i2c/ov2740.c
+++ b/drivers/media/i2c/ov2740.c
@@ -603,8 +603,10 @@ static int ov2740_init_controls(struct ov2740 *ov2740)
 				     V4L2_CID_TEST_PATTERN,
 				     ARRAY_SIZE(ov2740_test_pattern_menu) - 1,
 				     0, 0, ov2740_test_pattern_menu);
-	if (ctrl_hdlr->error)
+	if (ctrl_hdlr->error) {
+		v4l2_ctrl_handler_free(ctrl_hdlr);
 		return ctrl_hdlr->error;
+	}
 
 	ov2740->sd.ctrl_handler = ctrl_hdlr;
 
diff --git a/drivers/media/i2c/ov5675.c b/drivers/media/i2c/ov5675.c
index da5850b7ad07..2104589dd434 100644
--- a/drivers/media/i2c/ov5675.c
+++ b/drivers/media/i2c/ov5675.c
@@ -791,8 +791,10 @@ static int ov5675_init_controls(struct ov5675 *ov5675)
 	v4l2_ctrl_new_std(ctrl_hdlr, &ov5675_ctrl_ops,
 			  V4L2_CID_VFLIP, 0, 1, 1, 0);
 
-	if (ctrl_hdlr->error)
+	if (ctrl_hdlr->error) {
+		v4l2_ctrl_handler_free(ctrl_hdlr);
 		return ctrl_hdlr->error;
+	}
 
 	ov5675->sd.ctrl_handler = ctrl_hdlr;
 
diff --git a/drivers/media/i2c/ov7670.c b/drivers/media/i2c/ov7670.c
index 1be2c0e5bdc1..23001ede138c 100644
--- a/drivers/media/i2c/ov7670.c
+++ b/drivers/media/i2c/ov7670.c
@@ -1841,7 +1841,7 @@ static int ov7670_parse_dt(struct device *dev,
 
 	if (bus_cfg.bus_type != V4L2_MBUS_PARALLEL) {
 		dev_err(dev, "Unsupported media bus type\n");
-		return ret;
+		return -EINVAL;
 	}
 	info->mbus_config = bus_cfg.bus.parallel.flags;
 
diff --git a/drivers/media/i2c/ov772x.c b/drivers/media/i2c/ov772x.c
index 78602a2f70b0..e05b48c90fae 100644
--- a/drivers/media/i2c/ov772x.c
+++ b/drivers/media/i2c/ov772x.c
@@ -1462,7 +1462,7 @@ static int ov772x_probe(struct i2c_client *client)
 	priv->subdev.ctrl_handler = &priv->hdl;
 	if (priv->hdl.error) {
 		ret = priv->hdl.error;
-		goto error_mutex_destroy;
+		goto error_ctrl_free;
 	}
 
 	priv->clk = clk_get(&client->dev, NULL);
@@ -1515,7 +1515,6 @@ static int ov772x_probe(struct i2c_client *client)
 	clk_put(priv->clk);
 error_ctrl_free:
 	v4l2_ctrl_handler_free(&priv->hdl);
-error_mutex_destroy:
 	mutex_destroy(&priv->lock);
 
 	return ret;
diff --git a/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c b/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c
index 47db0ee0fcbf..3a8af3936e93 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2-main.c
@@ -1851,6 +1851,9 @@ static void cio2_pci_remove(struct pci_dev *pci_dev)
 	v4l2_device_unregister(&cio2->v4l2_dev);
 	media_device_cleanup(&cio2->media_dev);
 	mutex_destroy(&cio2->lock);
+
+	pm_runtime_forbid(&pci_dev->dev);
+	pm_runtime_get_noresume(&pci_dev->dev);
 }
 
 static int __maybe_unused cio2_runtime_suspend(struct device *dev)
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index 96328b0af164..cf2871306987 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -978,7 +978,7 @@ static void saa7134_unregister_video(struct saa7134_dev *dev)
 	}
 	if (dev->radio_dev) {
 		if (video_is_registered(dev->radio_dev))
-			vb2_video_unregister_device(dev->radio_dev);
+			video_unregister_device(dev->radio_dev);
 		else
 			video_device_release(dev->radio_dev);
 		dev->radio_dev = NULL;
diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.c b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
index 984fcdfa0f09..e515325683a4 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.c
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.c
@@ -2105,19 +2105,12 @@ static int mxc_jpeg_probe(struct platform_device *pdev)
 	jpeg->mode = mode;
 
 	/* Get clocks */
-	jpeg->clk_ipg = devm_clk_get(dev, "ipg");
-	if (IS_ERR(jpeg->clk_ipg)) {
-		dev_err(dev, "failed to get clock: ipg\n");
-		ret = PTR_ERR(jpeg->clk_ipg);
-		goto err_clk;
-	}
-
-	jpeg->clk_per = devm_clk_get(dev, "per");
-	if (IS_ERR(jpeg->clk_per)) {
-		dev_err(dev, "failed to get clock: per\n");
-		ret = PTR_ERR(jpeg->clk_per);
+	ret = devm_clk_bulk_get_all(&pdev->dev, &jpeg->clks);
+	if (ret < 0) {
+		dev_err(dev, "failed to get clock\n");
 		goto err_clk;
 	}
+	jpeg->num_clks = ret;
 
 	ret = mxc_jpeg_attach_pm_domains(jpeg);
 	if (ret < 0) {
@@ -2214,32 +2207,20 @@ static int mxc_jpeg_runtime_resume(struct device *dev)
 	struct mxc_jpeg_dev *jpeg = dev_get_drvdata(dev);
 	int ret;
 
-	ret = clk_prepare_enable(jpeg->clk_ipg);
-	if (ret < 0) {
-		dev_err(dev, "failed to enable clock: ipg\n");
-		goto err_ipg;
-	}
-
-	ret = clk_prepare_enable(jpeg->clk_per);
+	ret = clk_bulk_prepare_enable(jpeg->num_clks, jpeg->clks);
 	if (ret < 0) {
-		dev_err(dev, "failed to enable clock: per\n");
-		goto err_per;
+		dev_err(dev, "failed to enable clock\n");
+		return ret;
 	}
 
 	return 0;
-
-err_per:
-	clk_disable_unprepare(jpeg->clk_ipg);
-err_ipg:
-	return ret;
 }
 
 static int mxc_jpeg_runtime_suspend(struct device *dev)
 {
 	struct mxc_jpeg_dev *jpeg = dev_get_drvdata(dev);
 
-	clk_disable_unprepare(jpeg->clk_ipg);
-	clk_disable_unprepare(jpeg->clk_per);
+	clk_bulk_disable_unprepare(jpeg->num_clks, jpeg->clks);
 
 	return 0;
 }
diff --git a/drivers/media/platform/imx-jpeg/mxc-jpeg.h b/drivers/media/platform/imx-jpeg/mxc-jpeg.h
index 542993eb8d5b..495000800d55 100644
--- a/drivers/media/platform/imx-jpeg/mxc-jpeg.h
+++ b/drivers/media/platform/imx-jpeg/mxc-jpeg.h
@@ -112,8 +112,8 @@ struct mxc_jpeg_dev {
 	spinlock_t			hw_lock; /* hardware access lock */
 	unsigned int			mode;
 	struct mutex			lock; /* v4l2 ioctls serialization */
-	struct clk			*clk_ipg;
-	struct clk			*clk_per;
+	struct clk_bulk_data		*clks;
+	int				num_clks;
 	struct platform_device		*pdev;
 	struct device			*dev;
 	void __iomem			*base_reg;
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 20f59c59ff8a..3222c98b8363 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2306,7 +2306,16 @@ static int isp_probe(struct platform_device *pdev)
 
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
diff --git a/drivers/media/platform/ti-vpe/cal.c b/drivers/media/platform/ti-vpe/cal.c
index 8e469d518a74..35d62eb1321f 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -940,8 +940,10 @@ static struct cal_ctx *cal_ctx_create(struct cal_dev *cal, int inst)
 	ctx->datatype = CAL_CSI2_CTX_DT_ANY;
 
 	ret = cal_ctx_v4l2_init(ctx);
-	if (ret)
+	if (ret) {
+		kfree(ctx);
 		return NULL;
+	}
 
 	return ctx;
 }
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index e09270916fbc..11ee21a7db8f 100644
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
index df4c5dcba39c..1babfe6e2c36 100644
--- a/drivers/media/usb/siano/smsusb.c
+++ b/drivers/media/usb/siano/smsusb.c
@@ -179,6 +179,7 @@ static void smsusb_stop_streaming(struct smsusb_device_t *dev)
 
 	for (i = 0; i < MAX_URBS; i++) {
 		usb_kill_urb(&dev->surbs[i].urb);
+		cancel_work_sync(&dev->surbs[i].wq);
 
 		if (dev->surbs[i].cb) {
 			smscore_putbuffer(dev->coredev, dev->surbs[i].cb);
diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index 5bb29fc49538..4b3a44264b2c 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -357,6 +357,11 @@ static const struct uvc_control_info uvc_ctrls[] = {
 	},
 };
 
+static const u32 uvc_control_classes[] = {
+	V4L2_CID_CAMERA_CLASS,
+	V4L2_CID_USER_CLASS,
+};
+
 static const struct uvc_menu_info power_line_frequency_controls[] = {
 	{ 0, "Disabled" },
 	{ 1, "50 Hz" },
@@ -427,7 +432,6 @@ static void uvc_ctrl_set_rel_speed(struct uvc_control_mapping *mapping,
 static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	{
 		.id		= V4L2_CID_BRIGHTNESS,
-		.name		= "Brightness",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_BRIGHTNESS_CONTROL,
 		.size		= 16,
@@ -437,7 +441,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_CONTRAST,
-		.name		= "Contrast",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_CONTRAST_CONTROL,
 		.size		= 16,
@@ -447,7 +450,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_HUE,
-		.name		= "Hue",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_HUE_CONTROL,
 		.size		= 16,
@@ -459,7 +461,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_SATURATION,
-		.name		= "Saturation",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_SATURATION_CONTROL,
 		.size		= 16,
@@ -469,7 +470,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_SHARPNESS,
-		.name		= "Sharpness",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_SHARPNESS_CONTROL,
 		.size		= 16,
@@ -479,7 +479,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_GAMMA,
-		.name		= "Gamma",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_GAMMA_CONTROL,
 		.size		= 16,
@@ -489,7 +488,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_BACKLIGHT_COMPENSATION,
-		.name		= "Backlight Compensation",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_BACKLIGHT_COMPENSATION_CONTROL,
 		.size		= 16,
@@ -499,7 +497,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_GAIN,
-		.name		= "Gain",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_GAIN_CONTROL,
 		.size		= 16,
@@ -509,7 +506,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_POWER_LINE_FREQUENCY,
-		.name		= "Power Line Frequency",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_POWER_LINE_FREQUENCY_CONTROL,
 		.size		= 2,
@@ -521,7 +517,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_HUE_AUTO,
-		.name		= "Hue, Auto",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_HUE_AUTO_CONTROL,
 		.size		= 1,
@@ -532,7 +527,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_EXPOSURE_AUTO,
-		.name		= "Exposure, Auto",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_AE_MODE_CONTROL,
 		.size		= 4,
@@ -545,7 +539,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_EXPOSURE_AUTO_PRIORITY,
-		.name		= "Exposure, Auto Priority",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_AE_PRIORITY_CONTROL,
 		.size		= 1,
@@ -555,7 +548,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_EXPOSURE_ABSOLUTE,
-		.name		= "Exposure (Absolute)",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_EXPOSURE_TIME_ABSOLUTE_CONTROL,
 		.size		= 32,
@@ -567,7 +559,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
-		.name		= "White Balance Temperature, Auto",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_WHITE_BALANCE_TEMPERATURE_AUTO_CONTROL,
 		.size		= 1,
@@ -578,7 +569,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_WHITE_BALANCE_TEMPERATURE,
-		.name		= "White Balance Temperature",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_WHITE_BALANCE_TEMPERATURE_CONTROL,
 		.size		= 16,
@@ -590,7 +580,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_AUTO_WHITE_BALANCE,
-		.name		= "White Balance Component, Auto",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_WHITE_BALANCE_COMPONENT_AUTO_CONTROL,
 		.size		= 1,
@@ -602,7 +591,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_BLUE_BALANCE,
-		.name		= "White Balance Blue Component",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_WHITE_BALANCE_COMPONENT_CONTROL,
 		.size		= 16,
@@ -614,7 +602,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_RED_BALANCE,
-		.name		= "White Balance Red Component",
 		.entity		= UVC_GUID_UVC_PROCESSING,
 		.selector	= UVC_PU_WHITE_BALANCE_COMPONENT_CONTROL,
 		.size		= 16,
@@ -626,7 +613,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_FOCUS_ABSOLUTE,
-		.name		= "Focus (absolute)",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_FOCUS_ABSOLUTE_CONTROL,
 		.size		= 16,
@@ -638,7 +624,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_FOCUS_AUTO,
-		.name		= "Focus, Auto",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_FOCUS_AUTO_CONTROL,
 		.size		= 1,
@@ -649,7 +634,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_IRIS_ABSOLUTE,
-		.name		= "Iris, Absolute",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_IRIS_ABSOLUTE_CONTROL,
 		.size		= 16,
@@ -659,7 +643,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_IRIS_RELATIVE,
-		.name		= "Iris, Relative",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_IRIS_RELATIVE_CONTROL,
 		.size		= 8,
@@ -669,7 +652,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_ZOOM_ABSOLUTE,
-		.name		= "Zoom, Absolute",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_ZOOM_ABSOLUTE_CONTROL,
 		.size		= 16,
@@ -679,7 +661,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_ZOOM_CONTINUOUS,
-		.name		= "Zoom, Continuous",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_ZOOM_RELATIVE_CONTROL,
 		.size		= 0,
@@ -691,7 +672,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_PAN_ABSOLUTE,
-		.name		= "Pan (Absolute)",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_PANTILT_ABSOLUTE_CONTROL,
 		.size		= 32,
@@ -701,7 +681,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_TILT_ABSOLUTE,
-		.name		= "Tilt (Absolute)",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_PANTILT_ABSOLUTE_CONTROL,
 		.size		= 32,
@@ -711,7 +690,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_PAN_SPEED,
-		.name		= "Pan (Speed)",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_PANTILT_RELATIVE_CONTROL,
 		.size		= 16,
@@ -723,7 +701,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_TILT_SPEED,
-		.name		= "Tilt (Speed)",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_PANTILT_RELATIVE_CONTROL,
 		.size		= 16,
@@ -735,7 +712,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_PRIVACY,
-		.name		= "Privacy",
 		.entity		= UVC_GUID_UVC_CAMERA,
 		.selector	= UVC_CT_PRIVACY_CONTROL,
 		.size		= 1,
@@ -745,7 +721,6 @@ static const struct uvc_control_mapping uvc_ctrl_mappings[] = {
 	},
 	{
 		.id		= V4L2_CID_PRIVACY,
-		.name		= "Privacy",
 		.entity		= UVC_GUID_EXT_GPIO_CONTROLLER,
 		.selector	= UVC_CT_PRIVACY_CONTROL,
 		.size		= 1,
@@ -1044,6 +1019,125 @@ static int __uvc_ctrl_get(struct uvc_video_chain *chain,
 	return 0;
 }
 
+static int __uvc_query_v4l2_class(struct uvc_video_chain *chain, u32 req_id,
+				  u32 found_id)
+{
+	bool find_next = req_id & V4L2_CTRL_FLAG_NEXT_CTRL;
+	unsigned int i;
+
+	req_id &= V4L2_CTRL_ID_MASK;
+
+	for (i = 0; i < ARRAY_SIZE(uvc_control_classes); i++) {
+		if (!(chain->ctrl_class_bitmap & BIT(i)))
+			continue;
+		if (!find_next) {
+			if (uvc_control_classes[i] == req_id)
+				return i;
+			continue;
+		}
+		if (uvc_control_classes[i] > req_id &&
+		    uvc_control_classes[i] < found_id)
+			return i;
+	}
+
+	return -ENODEV;
+}
+
+static int uvc_query_v4l2_class(struct uvc_video_chain *chain, u32 req_id,
+				u32 found_id, struct v4l2_queryctrl *v4l2_ctrl)
+{
+	int idx;
+
+	idx = __uvc_query_v4l2_class(chain, req_id, found_id);
+	if (idx < 0)
+		return -ENODEV;
+
+	memset(v4l2_ctrl, 0, sizeof(*v4l2_ctrl));
+	v4l2_ctrl->id = uvc_control_classes[idx];
+	strscpy(v4l2_ctrl->name, v4l2_ctrl_get_name(v4l2_ctrl->id),
+		sizeof(v4l2_ctrl->name));
+	v4l2_ctrl->type = V4L2_CTRL_TYPE_CTRL_CLASS;
+	v4l2_ctrl->flags = V4L2_CTRL_FLAG_WRITE_ONLY
+			 | V4L2_CTRL_FLAG_READ_ONLY;
+	return 0;
+}
+
+/*
+ * Check if control @v4l2_id can be accessed by the given control @ioctl
+ * (VIDIOC_G_EXT_CTRLS, VIDIOC_TRY_EXT_CTRLS or VIDIOC_S_EXT_CTRLS).
+ *
+ * For set operations on slave controls, check if the master's value is set to
+ * manual, either in the others controls set in the same ioctl call, or from
+ * the master's current value. This catches VIDIOC_S_EXT_CTRLS calls that set
+ * both the master and slave control, such as for instance setting
+ * auto_exposure=1, exposure_time_absolute=251.
+ */
+int uvc_ctrl_is_accessible(struct uvc_video_chain *chain, u32 v4l2_id,
+			   const struct v4l2_ext_controls *ctrls,
+			   unsigned long ioctl)
+{
+	struct uvc_control_mapping *master_map = NULL;
+	struct uvc_control *master_ctrl = NULL;
+	struct uvc_control_mapping *mapping;
+	struct uvc_control *ctrl;
+	bool read = ioctl == VIDIOC_G_EXT_CTRLS;
+	s32 val;
+	int ret;
+	int i;
+
+	if (__uvc_query_v4l2_class(chain, v4l2_id, 0) >= 0)
+		return -EACCES;
+
+	ctrl = uvc_find_control(chain, v4l2_id, &mapping);
+	if (!ctrl)
+		return -EINVAL;
+
+	if (!(ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR) && read)
+		return -EACCES;
+
+	if (!(ctrl->info.flags & UVC_CTRL_FLAG_SET_CUR) && !read)
+		return -EACCES;
+
+	if (ioctl != VIDIOC_S_EXT_CTRLS || !mapping->master_id)
+		return 0;
+
+	/*
+	 * Iterate backwards in cases where the master control is accessed
+	 * multiple times in the same ioctl. We want the last value.
+	 */
+	for (i = ctrls->count - 1; i >= 0; i--) {
+		if (ctrls->controls[i].id == mapping->master_id)
+			return ctrls->controls[i].value ==
+					mapping->master_manual ? 0 : -EACCES;
+	}
+
+	__uvc_find_control(ctrl->entity, mapping->master_id, &master_map,
+			   &master_ctrl, 0);
+
+	if (!master_ctrl || !(master_ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR))
+		return 0;
+
+	ret = __uvc_ctrl_get(chain, master_ctrl, master_map, &val);
+	if (ret >= 0 && val != mapping->master_manual)
+		return -EACCES;
+
+	return 0;
+}
+
+static const char *uvc_map_get_name(const struct uvc_control_mapping *map)
+{
+	const char *name;
+
+	if (map->name)
+		return map->name;
+
+	name = v4l2_ctrl_get_name(map->id);
+	if (name)
+		return name;
+
+	return "Unknown Control";
+}
+
 static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	struct uvc_control *ctrl,
 	struct uvc_control_mapping *mapping,
@@ -1057,7 +1151,8 @@ static int __uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	memset(v4l2_ctrl, 0, sizeof(*v4l2_ctrl));
 	v4l2_ctrl->id = mapping->id;
 	v4l2_ctrl->type = mapping->v4l2_type;
-	strscpy(v4l2_ctrl->name, mapping->name, sizeof(v4l2_ctrl->name));
+	strscpy(v4l2_ctrl->name, uvc_map_get_name(mapping),
+		sizeof(v4l2_ctrl->name));
 	v4l2_ctrl->flags = 0;
 
 	if (!(ctrl->info.flags & UVC_CTRL_FLAG_GET_CUR))
@@ -1147,12 +1242,31 @@ int uvc_query_v4l2_ctrl(struct uvc_video_chain *chain,
 	if (ret < 0)
 		return -ERESTARTSYS;
 
+	/* Check if the ctrl is a know class */
+	if (!(v4l2_ctrl->id & V4L2_CTRL_FLAG_NEXT_CTRL)) {
+		ret = uvc_query_v4l2_class(chain, v4l2_ctrl->id, 0, v4l2_ctrl);
+		if (!ret)
+			goto done;
+	}
+
 	ctrl = uvc_find_control(chain, v4l2_ctrl->id, &mapping);
 	if (ctrl == NULL) {
 		ret = -EINVAL;
 		goto done;
 	}
 
+	/*
+	 * If we're enumerating control with V4L2_CTRL_FLAG_NEXT_CTRL, check if
+	 * a class should be inserted between the previous control and the one
+	 * we have just found.
+	 */
+	if (v4l2_ctrl->id & V4L2_CTRL_FLAG_NEXT_CTRL) {
+		ret = uvc_query_v4l2_class(chain, v4l2_ctrl->id, mapping->id,
+					   v4l2_ctrl);
+		if (!ret)
+			goto done;
+	}
+
 	ret = __uvc_query_v4l2_ctrl(chain, ctrl, mapping, v4l2_ctrl);
 done:
 	mutex_unlock(&chain->ctrl_mutex);
@@ -1446,6 +1560,11 @@ static int uvc_ctrl_add_event(struct v4l2_subscribed_event *sev, unsigned elems)
 	if (ret < 0)
 		return -ERESTARTSYS;
 
+	if (__uvc_query_v4l2_class(handle->chain, sev->id, 0) >= 0) {
+		ret = 0;
+		goto done;
+	}
+
 	ctrl = uvc_find_control(handle->chain, sev->id, &mapping);
 	if (ctrl == NULL) {
 		ret = -EINVAL;
@@ -1479,7 +1598,10 @@ static void uvc_ctrl_del_event(struct v4l2_subscribed_event *sev)
 	struct uvc_fh *handle = container_of(sev->fh, struct uvc_fh, vfh);
 
 	mutex_lock(&handle->chain->ctrl_mutex);
+	if (__uvc_query_v4l2_class(handle->chain, sev->id, 0) >= 0)
+		goto done;
 	list_del(&sev->node);
+done:
 	mutex_unlock(&handle->chain->ctrl_mutex);
 }
 
@@ -1597,6 +1719,9 @@ int uvc_ctrl_get(struct uvc_video_chain *chain,
 	struct uvc_control *ctrl;
 	struct uvc_control_mapping *mapping;
 
+	if (__uvc_query_v4l2_class(chain, xctrl->id, 0) >= 0)
+		return -EACCES;
+
 	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
 	if (ctrl == NULL)
 		return -EINVAL;
@@ -1616,6 +1741,9 @@ int uvc_ctrl_set(struct uvc_fh *handle,
 	s32 max;
 	int ret;
 
+	if (__uvc_query_v4l2_class(chain, xctrl->id, 0) >= 0)
+		return -EACCES;
+
 	ctrl = uvc_find_control(chain, xctrl->id, &mapping);
 	if (ctrl == NULL)
 		return -EINVAL;
@@ -2066,11 +2194,12 @@ static int uvc_ctrl_add_info(struct uvc_device *dev, struct uvc_control *ctrl,
 /*
  * Add a control mapping to a given control.
  */
-static int __uvc_ctrl_add_mapping(struct uvc_device *dev,
+static int __uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 	struct uvc_control *ctrl, const struct uvc_control_mapping *mapping)
 {
 	struct uvc_control_mapping *map;
 	unsigned int size;
+	unsigned int i;
 
 	/* Most mappings come from static kernel data and need to be duplicated.
 	 * Mappings that come from userspace will be unnecessarily duplicated,
@@ -2094,9 +2223,18 @@ static int __uvc_ctrl_add_mapping(struct uvc_device *dev,
 	if (map->set == NULL)
 		map->set = uvc_set_le_value;
 
+	for (i = 0; i < ARRAY_SIZE(uvc_control_classes); i++) {
+		if (V4L2_CTRL_ID2WHICH(uvc_control_classes[i]) ==
+						V4L2_CTRL_ID2WHICH(map->id)) {
+			chain->ctrl_class_bitmap |= BIT(i);
+			break;
+		}
+	}
+
 	list_add_tail(&map->list, &ctrl->info.mappings);
-	uvc_dbg(dev, CONTROL, "Adding mapping '%s' to control %pUl/%u\n",
-		map->name, ctrl->info.entity, ctrl->info.selector);
+	uvc_dbg(chain->dev, CONTROL, "Adding mapping '%s' to control %pUl/%u\n",
+		uvc_map_get_name(map), ctrl->info.entity,
+		ctrl->info.selector);
 
 	return 0;
 }
@@ -2114,7 +2252,7 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 	if (mapping->id & ~V4L2_CTRL_ID_MASK) {
 		uvc_dbg(dev, CONTROL,
 			"Can't add mapping '%s', control id 0x%08x is invalid\n",
-			mapping->name, mapping->id);
+			uvc_map_get_name(mapping), mapping->id);
 		return -EINVAL;
 	}
 
@@ -2161,7 +2299,7 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 		if (mapping->id == map->id) {
 			uvc_dbg(dev, CONTROL,
 				"Can't add mapping '%s', control id 0x%08x already exists\n",
-				mapping->name, mapping->id);
+				uvc_map_get_name(mapping), mapping->id);
 			ret = -EEXIST;
 			goto done;
 		}
@@ -2172,12 +2310,12 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
 		atomic_dec(&dev->nmappings);
 		uvc_dbg(dev, CONTROL,
 			"Can't add mapping '%s', maximum mappings count (%u) exceeded\n",
-			mapping->name, UVC_MAX_CONTROL_MAPPINGS);
+			uvc_map_get_name(mapping), UVC_MAX_CONTROL_MAPPINGS);
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	ret = __uvc_ctrl_add_mapping(dev, ctrl, mapping);
+	ret = __uvc_ctrl_add_mapping(chain, ctrl, mapping);
 	if (ret < 0)
 		atomic_dec(&dev->nmappings);
 
@@ -2253,7 +2391,8 @@ static void uvc_ctrl_prune_entity(struct uvc_device *dev,
  * Add control information and hardcoded stock control mappings to the given
  * device.
  */
-static void uvc_ctrl_init_ctrl(struct uvc_device *dev, struct uvc_control *ctrl)
+static void uvc_ctrl_init_ctrl(struct uvc_video_chain *chain,
+			       struct uvc_control *ctrl)
 {
 	const struct uvc_control_info *info = uvc_ctrls;
 	const struct uvc_control_info *iend = info + ARRAY_SIZE(uvc_ctrls);
@@ -2272,14 +2411,14 @@ static void uvc_ctrl_init_ctrl(struct uvc_device *dev, struct uvc_control *ctrl)
 	for (; info < iend; ++info) {
 		if (uvc_entity_match_guid(ctrl->entity, info->entity) &&
 		    ctrl->index == info->index) {
-			uvc_ctrl_add_info(dev, ctrl, info);
+			uvc_ctrl_add_info(chain->dev, ctrl, info);
 			/*
 			 * Retrieve control flags from the device. Ignore errors
 			 * and work with default flag values from the uvc_ctrl
 			 * array when the device doesn't properly implement
 			 * GET_INFO on standard controls.
 			 */
-			uvc_ctrl_get_flags(dev, ctrl, &ctrl->info);
+			uvc_ctrl_get_flags(chain->dev, ctrl, &ctrl->info);
 			break;
 		 }
 	}
@@ -2290,22 +2429,20 @@ static void uvc_ctrl_init_ctrl(struct uvc_device *dev, struct uvc_control *ctrl)
 	for (; mapping < mend; ++mapping) {
 		if (uvc_entity_match_guid(ctrl->entity, mapping->entity) &&
 		    ctrl->info.selector == mapping->selector)
-			__uvc_ctrl_add_mapping(dev, ctrl, mapping);
+			__uvc_ctrl_add_mapping(chain, ctrl, mapping);
 	}
 }
 
 /*
  * Initialize device controls.
  */
-int uvc_ctrl_init_device(struct uvc_device *dev)
+static int uvc_ctrl_init_chain(struct uvc_video_chain *chain)
 {
 	struct uvc_entity *entity;
 	unsigned int i;
 
-	INIT_WORK(&dev->async_ctrl.work, uvc_ctrl_status_event_work);
-
 	/* Walk the entities list and instantiate controls */
-	list_for_each_entry(entity, &dev->entities, list) {
+	list_for_each_entry(entity, &chain->entities, chain) {
 		struct uvc_control *ctrl;
 		unsigned int bControlSize = 0, ncontrols;
 		u8 *bmControls = NULL;
@@ -2325,7 +2462,7 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 		}
 
 		/* Remove bogus/blacklisted controls */
-		uvc_ctrl_prune_entity(dev, entity);
+		uvc_ctrl_prune_entity(chain->dev, entity);
 
 		/* Count supported controls and allocate the controls array */
 		ncontrols = memweight(bmControls, bControlSize);
@@ -2347,7 +2484,7 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 			ctrl->entity = entity;
 			ctrl->index = i;
 
-			uvc_ctrl_init_ctrl(dev, ctrl);
+			uvc_ctrl_init_ctrl(chain, ctrl);
 			ctrl++;
 		}
 	}
@@ -2355,6 +2492,22 @@ int uvc_ctrl_init_device(struct uvc_device *dev)
 	return 0;
 }
 
+int uvc_ctrl_init_device(struct uvc_device *dev)
+{
+	struct uvc_video_chain *chain;
+	int ret;
+
+	INIT_WORK(&dev->async_ctrl.work, uvc_ctrl_status_event_work);
+
+	list_for_each_entry(chain, &dev->chains, list) {
+		ret = uvc_ctrl_init_chain(chain);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 /*
  * Cleanup device controls.
  */
@@ -2366,6 +2519,7 @@ static void uvc_ctrl_cleanup_mappings(struct uvc_device *dev,
 	list_for_each_entry_safe(mapping, nm, &ctrl->info.mappings, list) {
 		list_del(&mapping->list);
 		kfree(mapping->menu_info);
+		kfree(mapping->name);
 		kfree(mapping);
 	}
 }
diff --git a/drivers/media/usb/uvc/uvc_driver.c b/drivers/media/usb/uvc/uvc_driver.c
index 72fff7264b54..ceae2eabc0a1 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2455,14 +2455,14 @@ static int uvc_probe(struct usb_interface *intf,
 	if (v4l2_device_register(&intf->dev, &dev->vdev) < 0)
 		goto error;
 
-	/* Initialize controls. */
-	if (uvc_ctrl_init_device(dev) < 0)
-		goto error;
-
 	/* Scan the device for video chains. */
 	if (uvc_scan_device(dev) < 0)
 		goto error;
 
+	/* Initialize controls. */
+	if (uvc_ctrl_init_device(dev) < 0)
+		goto error;
+
 	/* Register video device nodes. */
 	if (uvc_register_chains(dev) < 0)
 		goto error;
diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 63842eb223a1..023412b2a9b9 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -40,7 +40,15 @@ static int uvc_ioctl_ctrl_map(struct uvc_video_chain *chain,
 		return -ENOMEM;
 
 	map->id = xmap->id;
-	memcpy(map->name, xmap->name, sizeof(map->name));
+	/* Non standard control id. */
+	if (v4l2_ctrl_get_name(map->id) == NULL) {
+		map->name = kmemdup(xmap->name, sizeof(xmap->name),
+				    GFP_KERNEL);
+		if (!map->name) {
+			ret = -ENOMEM;
+			goto free_map;
+		}
+	}
 	memcpy(map->entity, xmap->entity, sizeof(map->entity));
 	map->selector = xmap->selector;
 	map->size = xmap->size;
@@ -1000,58 +1008,23 @@ static int uvc_ioctl_query_ext_ctrl(struct file *file, void *fh,
 	return 0;
 }
 
-static int uvc_ioctl_g_ctrl(struct file *file, void *fh,
-			    struct v4l2_control *ctrl)
+static int uvc_ctrl_check_access(struct uvc_video_chain *chain,
+				 struct v4l2_ext_controls *ctrls,
+				 unsigned long ioctl)
 {
-	struct uvc_fh *handle = fh;
-	struct uvc_video_chain *chain = handle->chain;
-	struct v4l2_ext_control xctrl;
-	int ret;
-
-	memset(&xctrl, 0, sizeof(xctrl));
-	xctrl.id = ctrl->id;
-
-	ret = uvc_ctrl_begin(chain);
-	if (ret < 0)
-		return ret;
-
-	ret = uvc_ctrl_get(chain, &xctrl);
-	uvc_ctrl_rollback(handle);
-	if (ret < 0)
-		return ret;
-
-	ctrl->value = xctrl.value;
-	return 0;
-}
-
-static int uvc_ioctl_s_ctrl(struct file *file, void *fh,
-			    struct v4l2_control *ctrl)
-{
-	struct uvc_fh *handle = fh;
-	struct uvc_video_chain *chain = handle->chain;
-	struct v4l2_ext_control xctrl;
-	int ret;
-
-	memset(&xctrl, 0, sizeof(xctrl));
-	xctrl.id = ctrl->id;
-	xctrl.value = ctrl->value;
-
-	ret = uvc_ctrl_begin(chain);
-	if (ret < 0)
-		return ret;
+	struct v4l2_ext_control *ctrl = ctrls->controls;
+	unsigned int i;
+	int ret = 0;
 
-	ret = uvc_ctrl_set(handle, &xctrl);
-	if (ret < 0) {
-		uvc_ctrl_rollback(handle);
-		return ret;
+	for (i = 0; i < ctrls->count; ++ctrl, ++i) {
+		ret = uvc_ctrl_is_accessible(chain, ctrl->id, ctrls, ioctl);
+		if (ret)
+			break;
 	}
 
-	ret = uvc_ctrl_commit(handle, &xctrl, 1);
-	if (ret < 0)
-		return ret;
+	ctrls->error_idx = ioctl == VIDIOC_TRY_EXT_CTRLS ? i : ctrls->count;
 
-	ctrl->value = xctrl.value;
-	return 0;
+	return ret;
 }
 
 static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
@@ -1063,6 +1036,10 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
 	unsigned int i;
 	int ret;
 
+	ret = uvc_ctrl_check_access(chain, ctrls, VIDIOC_G_EXT_CTRLS);
+	if (ret < 0)
+		return ret;
+
 	if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL) {
 		for (i = 0; i < ctrls->count; ++ctrl, ++i) {
 			struct v4l2_queryctrl qc = { .id = ctrl->id };
@@ -1099,16 +1076,16 @@ static int uvc_ioctl_g_ext_ctrls(struct file *file, void *fh,
 
 static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
 				     struct v4l2_ext_controls *ctrls,
-				     bool commit)
+				     unsigned long ioctl)
 {
 	struct v4l2_ext_control *ctrl = ctrls->controls;
 	struct uvc_video_chain *chain = handle->chain;
 	unsigned int i;
 	int ret;
 
-	/* Default value cannot be changed */
-	if (ctrls->which == V4L2_CTRL_WHICH_DEF_VAL)
-		return -EINVAL;
+	ret = uvc_ctrl_check_access(chain, ctrls, ioctl);
+	if (ret < 0)
+		return ret;
 
 	ret = uvc_ctrl_begin(chain);
 	if (ret < 0)
@@ -1118,14 +1095,15 @@ static int uvc_ioctl_s_try_ext_ctrls(struct uvc_fh *handle,
 		ret = uvc_ctrl_set(handle, ctrl);
 		if (ret < 0) {
 			uvc_ctrl_rollback(handle);
-			ctrls->error_idx = commit ? ctrls->count : i;
+			ctrls->error_idx = ioctl == VIDIOC_S_EXT_CTRLS ?
+						    ctrls->count : i;
 			return ret;
 		}
 	}
 
 	ctrls->error_idx = 0;
 
-	if (commit)
+	if (ioctl == VIDIOC_S_EXT_CTRLS)
 		return uvc_ctrl_commit(handle, ctrls->controls, ctrls->count);
 	else
 		return uvc_ctrl_rollback(handle);
@@ -1136,7 +1114,7 @@ static int uvc_ioctl_s_ext_ctrls(struct file *file, void *fh,
 {
 	struct uvc_fh *handle = fh;
 
-	return uvc_ioctl_s_try_ext_ctrls(handle, ctrls, true);
+	return uvc_ioctl_s_try_ext_ctrls(handle, ctrls, VIDIOC_S_EXT_CTRLS);
 }
 
 static int uvc_ioctl_try_ext_ctrls(struct file *file, void *fh,
@@ -1144,7 +1122,7 @@ static int uvc_ioctl_try_ext_ctrls(struct file *file, void *fh,
 {
 	struct uvc_fh *handle = fh;
 
-	return uvc_ioctl_s_try_ext_ctrls(handle, ctrls, false);
+	return uvc_ioctl_s_try_ext_ctrls(handle, ctrls, VIDIOC_TRY_EXT_CTRLS);
 }
 
 static int uvc_ioctl_querymenu(struct file *file, void *fh,
@@ -1543,8 +1521,6 @@ const struct v4l2_ioctl_ops uvc_ioctl_ops = {
 	.vidioc_s_input = uvc_ioctl_s_input,
 	.vidioc_queryctrl = uvc_ioctl_queryctrl,
 	.vidioc_query_ext_ctrl = uvc_ioctl_query_ext_ctrl,
-	.vidioc_g_ctrl = uvc_ioctl_g_ctrl,
-	.vidioc_s_ctrl = uvc_ioctl_s_ctrl,
 	.vidioc_g_ext_ctrls = uvc_ioctl_g_ext_ctrls,
 	.vidioc_s_ext_ctrls = uvc_ioctl_s_ext_ctrls,
 	.vidioc_try_ext_ctrls = uvc_ioctl_try_ext_ctrls,
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index c3ea6a53869f..d7c4f6f5fca9 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -241,7 +241,7 @@ struct uvc_control_mapping {
 	struct list_head ev_subs;
 
 	u32 id;
-	u8 name[32];
+	char *name;
 	u8 entity[16];
 	u8 selector;
 
@@ -476,6 +476,7 @@ struct uvc_video_chain {
 
 	struct v4l2_prio_state prio;		/* V4L2 priority state */
 	u32 caps;				/* V4L2 chain-wide caps */
+	u8 ctrl_class_bitmap;			/* Bitmap of valid classes */
 };
 
 struct uvc_stats_frame {
@@ -900,6 +901,9 @@ static inline int uvc_ctrl_rollback(struct uvc_fh *handle)
 
 int uvc_ctrl_get(struct uvc_video_chain *chain, struct v4l2_ext_control *xctrl);
 int uvc_ctrl_set(struct uvc_fh *handle, struct v4l2_ext_control *xctrl);
+int uvc_ctrl_is_accessible(struct uvc_video_chain *chain, u32 v4l2_id,
+			   const struct v4l2_ext_controls *ctrls,
+			   unsigned long ioctl);
 
 int uvc_xu_ctrl_query(struct uvc_video_chain *chain,
 		      struct uvc_xu_control_query *xqry);
diff --git a/drivers/media/v4l2-core/v4l2-jpeg.c b/drivers/media/v4l2-core/v4l2-jpeg.c
index c2513b775f6a..94435a7b6816 100644
--- a/drivers/media/v4l2-core/v4l2-jpeg.c
+++ b/drivers/media/v4l2-core/v4l2-jpeg.c
@@ -460,7 +460,7 @@ static int jpeg_parse_app14_data(struct jpeg_stream *stream,
 	/* Check for "Adobe\0" in Ap1..6 */
 	if (stream->curr + 6 > stream->end ||
 	    strncmp(stream->curr, "Adobe\0", 6))
-		return -EINVAL;
+		return jpeg_skip(stream, lp - 2);
 
 	/* get to Ap12 */
 	ret = jpeg_skip(stream, 11);
@@ -474,7 +474,7 @@ static int jpeg_parse_app14_data(struct jpeg_stream *stream,
 	*tf = ret;
 
 	/* skip the rest of the segment, this ensures at least it is complete */
-	skip = lp - 2 - 11;
+	skip = lp - 2 - 11 - 1;
 	return jpeg_skip(stream, skip);
 }
 
diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
index 5dd7ea0ebd46..ef550d33af92 100644
--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -15,6 +15,7 @@ config MFD_CS5535
 	tristate "AMD CS5535 and CS5536 southbridge core functions"
 	select MFD_CORE
 	depends on PCI && (X86_32 || (X86 && COMPILE_TEST))
+	depends on !UML
 	help
 	  This is the core driver for CS5535/CS5536 MFD functions.  This is
 	  necessary for using the board's GPIO and MFGPT functionality.
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
 
diff --git a/drivers/misc/eeprom/idt_89hpesx.c b/drivers/misc/eeprom/idt_89hpesx.c
index 7f430742ce2b..5298be4cc14c 100644
--- a/drivers/misc/eeprom/idt_89hpesx.c
+++ b/drivers/misc/eeprom/idt_89hpesx.c
@@ -1568,12 +1568,20 @@ static struct i2c_driver idt_driver = {
  */
 static int __init idt_init(void)
 {
+	int ret;
+
 	/* Create Debugfs directory first */
 	if (debugfs_initialized())
 		csr_dbgdir = debugfs_create_dir("idt_csr", NULL);
 
 	/* Add new i2c-device driver */
-	return i2c_add_driver(&idt_driver);
+	ret = i2c_add_driver(&idt_driver);
+	if (ret) {
+		debugfs_remove_recursive(csr_dbgdir);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(idt_init);
 
diff --git a/drivers/misc/mei/hdcp/mei_hdcp.c b/drivers/misc/mei/hdcp/mei_hdcp.c
index ec2a4fce8581..5c4295d366ea 100644
--- a/drivers/misc/mei/hdcp/mei_hdcp.c
+++ b/drivers/misc/mei/hdcp/mei_hdcp.c
@@ -859,8 +859,8 @@ static void mei_hdcp_remove(struct mei_cl_device *cldev)
 		dev_warn(&cldev->dev, "mei_cldev_disable() failed\n");
 }
 
-#define MEI_UUID_HDCP GUID_INIT(0xB638AB7E, 0x94E2, 0x4EA2, 0xA5, \
-				0x52, 0xD1, 0xC5, 0x4B, 0x62, 0x7F, 0x04)
+#define MEI_UUID_HDCP UUID_LE(0xB638AB7E, 0x94E2, 0x4EA2, 0xA5, \
+			      0x52, 0xD1, 0xC5, 0x4B, 0x62, 0x7F, 0x04)
 
 static const struct mei_cl_device_id mei_hdcp_tbl[] = {
 	{ .uuid = MEI_UUID_HDCP, .version = MEI_CL_VERSION_ANY },
diff --git a/drivers/misc/vmw_vmci/vmci_host.c b/drivers/misc/vmw_vmci/vmci_host.c
index da1e2a773823..857b9851402a 100644
--- a/drivers/misc/vmw_vmci/vmci_host.c
+++ b/drivers/misc/vmw_vmci/vmci_host.c
@@ -242,6 +242,8 @@ static int vmci_host_setup_notify(struct vmci_ctx *context,
 		context->notify_page = NULL;
 		return VMCI_ERROR_GENERIC;
 	}
+	if (context->notify_page == NULL)
+		return VMCI_ERROR_UNAVAILABLE;
 
 	/*
 	 * Map the locked page and set up notify pointer.
diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index d5dcc74a625e..1e61c2364622 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2246,6 +2246,15 @@ void spi_nor_set_erase_type(struct spi_nor_erase_type *erase, u32 size,
 	erase->size_mask = (1 << erase->size_shift) - 1;
 }
 
+/**
+ * spi_nor_mask_erase_type() - mask out a SPI NOR erase type
+ * @erase:	pointer to a structure that describes a SPI NOR erase type
+ */
+void spi_nor_mask_erase_type(struct spi_nor_erase_type *erase)
+{
+	erase->size = 0;
+}
+
 /**
  * spi_nor_init_uniform_erase_map() - Initialize uniform erase map
  * @map:		the erase map of the SPI NOR
diff --git a/drivers/mtd/spi-nor/core.h b/drivers/mtd/spi-nor/core.h
index 3348e1dd1445..7eb2090b2fdb 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -538,6 +538,7 @@ void spi_nor_set_pp_settings(struct spi_nor_pp_command *pp, u8 opcode,
 
 void spi_nor_set_erase_type(struct spi_nor_erase_type *erase, u32 size,
 			    u8 opcode);
+void spi_nor_mask_erase_type(struct spi_nor_erase_type *erase);
 struct spi_nor_erase_region *
 spi_nor_region_next(struct spi_nor_erase_region *region);
 void spi_nor_init_uniform_erase_map(struct spi_nor_erase_map *map,
diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index c500c2118a5d..c787fdacf0a1 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -874,7 +874,7 @@ static int spi_nor_init_non_uniform_erase_map(struct spi_nor *nor,
 	 */
 	for (i = 0; i < SNOR_ERASE_TYPE_MAX; i++)
 		if (!(regions_erase_type & BIT(erase[i].idx)))
-			spi_nor_set_erase_type(&erase[i], 0, 0xFF);
+			spi_nor_mask_erase_type(&erase[i]);
 
 	return 0;
 }
@@ -1088,7 +1088,7 @@ static int spi_nor_parse_4bait(struct spi_nor *nor,
 			erase_type[i].opcode = (dwords[1] >>
 						erase_type[i].idx * 8) & 0xFF;
 		else
-			spi_nor_set_erase_type(&erase_type[i], 0u, 0xFF);
+			spi_nor_mask_erase_type(&erase_type[i]);
 	}
 
 	/*
@@ -1220,7 +1220,7 @@ static int spi_nor_parse_sccr(struct spi_nor *nor,
 
 	le32_to_cpu_array(dwords, sccr_header->length);
 
-	if (FIELD_GET(SCCR_DWORD22_OCTAL_DTR_EN_VOLATILE, dwords[22]))
+	if (FIELD_GET(SCCR_DWORD22_OCTAL_DTR_EN_VOLATILE, dwords[21]))
 		nor->flags |= SNOR_F_IO_MODE_EN_VOLATILE;
 
 out:
diff --git a/drivers/mtd/spi-nor/spansion.c b/drivers/mtd/spi-nor/spansion.c
index ee82dcd75310..f3684b3f4089 100644
--- a/drivers/mtd/spi-nor/spansion.c
+++ b/drivers/mtd/spi-nor/spansion.c
@@ -15,8 +15,13 @@
 #define SPINOR_REG_CYPRESS_CFR3V		0x00800004
 #define SPINOR_REG_CYPRESS_CFR3V_PGSZ		BIT(4) /* Page size. */
 #define SPINOR_REG_CYPRESS_CFR5V		0x00800006
-#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN	0x3
-#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	0
+#define SPINOR_REG_CYPRESS_CFR5_BIT6		BIT(6)
+#define SPINOR_REG_CYPRESS_CFR5_DDR		BIT(1)
+#define SPINOR_REG_CYPRESS_CFR5_OPI		BIT(0)
+#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_EN				\
+	(SPINOR_REG_CYPRESS_CFR5_BIT6 |	SPINOR_REG_CYPRESS_CFR5_DDR |	\
+	 SPINOR_REG_CYPRESS_CFR5_OPI)
+#define SPINOR_REG_CYPRESS_CFR5V_OCT_DTR_DS	SPINOR_REG_CYPRESS_CFR5_BIT6
 #define SPINOR_OP_CYPRESS_RD_FAST		0xee
 
 /**
diff --git a/drivers/net/can/usb/esd_usb2.c b/drivers/net/can/usb/esd_usb2.c
index 9ed048cb07e6..1abdf88597de 100644
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
index ea1391753752..92cd2916e801 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2267,6 +2267,14 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
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
diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
index dbd2ede53f94..f61f832ea19c 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -165,15 +165,6 @@ void bcmgenet_phy_power_set(struct net_device *dev, bool enable)
 
 static void bcmgenet_moca_phy_setup(struct bcmgenet_priv *priv)
 {
-	u32 reg;
-
-	if (!GENET_IS_V5(priv)) {
-		/* Speed settings are set in bcmgenet_mii_setup() */
-		reg = bcmgenet_sys_readl(priv, SYS_PORT_CTRL);
-		reg |= LED_ACT_SOURCE_MAC;
-		bcmgenet_sys_writel(priv, reg, SYS_PORT_CTRL);
-	}
-
 	if (priv->hw_params->flags & GENET_HAS_MOCA_LINK_DET)
 		fixed_phy_set_link_update(priv->dev->phydev,
 					  bcmgenet_fixed_phy_link_update);
@@ -206,6 +197,8 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
 
 		if (!phy_name) {
 			phy_name = "MoCA";
+			if (!GENET_IS_V5(priv))
+				port_ctrl |= LED_ACT_SOURCE_MAC;
 			bcmgenet_moca_phy_setup(priv);
 		}
 		break;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6f674cd117d3..13afbffc4758 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5477,15 +5477,12 @@ int ice_vsi_cfg(struct ice_vsi *vsi)
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
 
@@ -5651,7 +5648,7 @@ static int ice_up_complete(struct ice_vsi *vsi)
 
 	if (vsi->port_info &&
 	    (vsi->port_info->phy.link_info.link_info & ICE_AQ_LINK_UP) &&
-	    vsi->netdev) {
+	    vsi->netdev && vsi->type == ICE_VSI_PF) {
 		ice_print_link_msg(vsi, true);
 		netif_tx_start_all_queues(vsi->netdev);
 		netif_carrier_on(vsi->netdev);
@@ -5661,7 +5658,9 @@ static int ice_up_complete(struct ice_vsi *vsi)
 	 * set the baseline so counters are ready when interface is up
 	 */
 	ice_update_eth_stats(vsi);
-	ice_service_task_schedule(pf);
+
+	if (vsi->type == ICE_VSI_PF)
+		ice_service_task_schedule(pf);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/intel/ice/ice_ptp.c b/drivers/net/ethernet/intel/ice/ice_ptp.c
index 9b50e9e6042a..4d7aa49b7c14 100644
--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -1090,7 +1090,7 @@ static void ice_ptp_set_caps(struct ice_pf *pf)
 	snprintf(info->name, sizeof(info->name) - 1, "%s-%s-clk",
 		 dev_driver_string(dev), dev_name(dev));
 	info->owner = THIS_MODULE;
-	info->max_adj = 999999999;
+	info->max_adj = 100000000;
 	info->adjtime = ice_ptp_adjtime;
 	info->adjfine = ice_ptp_adjfine;
 	info->gettimex64 = ice_ptp_gettimex64;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index 1c72fc0b7b68..05c7c2140909 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -603,7 +603,7 @@ static int mlx5_tracer_handle_string_trace(struct mlx5_fw_tracer *tracer,
 	} else {
 		cur_string = mlx5_tracer_message_get(tracer, tracer_event);
 		if (!cur_string) {
-			pr_debug("%s Got string event for unknown string tdsm: %d\n",
+			pr_debug("%s Got string event for unknown string tmsn: %d\n",
 				 __func__, tracer_event->string_event.tmsn);
 			return -1;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
index 110c0837f95b..ae6ac51b8ab0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/pagealloc.c
@@ -216,7 +216,8 @@ static int alloc_4k(struct mlx5_core_dev *dev, u64 *addr, u32 function)
 
 	n = find_first_bit(&fp->bitmask, 8 * sizeof(fp->bitmask));
 	if (n >= MLX5_NUM_4K_IN_PAGE) {
-		mlx5_core_warn(dev, "alloc 4k bug\n");
+		mlx5_core_warn(dev, "alloc 4k bug: fw page = 0x%llx, n = %u, bitmask: %lu, max num of 4K pages: %d\n",
+			       fp->addr, n, fp->bitmask,  MLX5_NUM_4K_IN_PAGE);
 		return -ENOENT;
 	}
 	clear_bit(n, &fp->bitmask);
diff --git a/drivers/net/ethernet/qlogic/qede/qede_main.c b/drivers/net/ethernet/qlogic/qede/qede_main.c
index ee4c3bd28a93..2d3f0ae4f889 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_main.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_main.c
@@ -899,7 +899,6 @@ static int qede_alloc_fp_array(struct qede_dev *edev)
 {
 	u8 fp_combined, fp_rx = edev->fp_num_rx;
 	struct qede_fastpath *fp;
-	void *mem;
 	int i;
 
 	edev->fp_array = kcalloc(QEDE_QUEUE_CNT(edev),
@@ -909,14 +908,15 @@ static int qede_alloc_fp_array(struct qede_dev *edev)
 		goto err;
 	}
 
-	mem = krealloc(edev->coal_entry, QEDE_QUEUE_CNT(edev) *
-		       sizeof(*edev->coal_entry), GFP_KERNEL);
-	if (!mem) {
-		DP_ERR(edev, "coalesce entry allocation failed\n");
-		kfree(edev->coal_entry);
-		goto err;
+	if (!edev->coal_entry) {
+		edev->coal_entry = kcalloc(QEDE_MAX_RSS_CNT(edev),
+					   sizeof(*edev->coal_entry),
+					   GFP_KERNEL);
+		if (!edev->coal_entry) {
+			DP_ERR(edev, "coalesce entry allocation failed\n");
+			goto err;
+		}
 	}
-	edev->coal_entry = mem;
 
 	fp_combined = QEDE_QUEUE_CNT(edev) - fp_rx - edev->fp_num_tx;
 
diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index fb2448f9a8b1..4156299e039d 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -814,6 +814,7 @@ static void netvsc_send_completion(struct net_device *ndev,
 	u32 msglen = hv_pkt_datalen(desc);
 	struct nvsp_message *pkt_rqst;
 	u64 cmd_rqst;
+	u32 status;
 
 	/* First check if this is a VMBUS completion without data payload */
 	if (!msglen) {
@@ -885,6 +886,23 @@ static void netvsc_send_completion(struct net_device *ndev,
 		break;
 
 	case NVSP_MSG1_TYPE_SEND_RNDIS_PKT_COMPLETE:
+		if (msglen < sizeof(struct nvsp_message_header) +
+		    sizeof(struct nvsp_1_message_send_rndis_packet_complete)) {
+			if (net_ratelimit())
+				netdev_err(ndev, "nvsp_rndis_pkt_complete length too small: %u\n",
+					   msglen);
+			return;
+		}
+
+		/* If status indicates an error, output a message so we know
+		 * there's a problem. But process the completion anyway so the
+		 * resources are released.
+		 */
+		status = nvsp_packet->msg.v1_msg.send_rndis_pkt_complete.status;
+		if (status != NVSP_STAT_SUCCESS && net_ratelimit())
+			netdev_err(ndev, "nvsp_rndis_pkt_complete error status: %x\n",
+				   status);
+
 		netvsc_send_tx_complete(ndev, net_device, incoming_channel,
 					desc, budget);
 		break;
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index ba2ef5437e16..854ed2f21d32 100644
--- a/drivers/net/tap.c
+++ b/drivers/net/tap.c
@@ -523,7 +523,7 @@ static int tap_open(struct inode *inode, struct file *file)
 	q->sock.state = SS_CONNECTED;
 	q->sock.file = file;
 	q->sock.ops = &tap_socket_ops;
-	sock_init_data(&q->sock, &q->sk);
+	sock_init_data_uid(&q->sock, &q->sk, inode->i_uid);
 	q->sk.sk_write_space = tap_sock_write_space;
 	q->sk.sk_destruct = tap_sock_destruct;
 	q->flags = IFF_VNET_HDR | IFF_NO_PI | IFF_TAP;
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index a1dda57c812d..30eea8270c9b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3411,7 +3411,7 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 	tfile->socket.file = file;
 	tfile->socket.ops = &tun_socket_ops;
 
-	sock_init_data(&tfile->socket, &tfile->sk);
+	sock_init_data_uid(&tfile->socket, &tfile->sk, inode->i_uid);
 
 	tfile->sk.sk_write_space = tun_sock_write_space;
 	tfile->sk.sk_sndbuf = INT_MAX;
diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index caa8f6eba009..fda1c2db05d0 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -731,7 +731,6 @@ struct ath11k_base {
 	enum ath11k_dfs_region dfs_region;
 #ifdef CONFIG_ATH11K_DEBUGFS
 	struct dentry *debugfs_soc;
-	struct dentry *debugfs_ath11k;
 #endif
 	struct ath11k_soc_dp_stats soc_stats;
 
diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 554feaf1ed5c..f827035f0dd2 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -836,10 +836,6 @@ int ath11k_debugfs_pdev_create(struct ath11k_base *ab)
 	if (test_bit(ATH11K_FLAG_REGISTERED, &ab->dev_flags))
 		return 0;
 
-	ab->debugfs_soc = debugfs_create_dir(ab->hw_params.name, ab->debugfs_ath11k);
-	if (IS_ERR(ab->debugfs_soc))
-		return PTR_ERR(ab->debugfs_soc);
-
 	debugfs_create_file("simulate_fw_crash", 0600, ab->debugfs_soc, ab,
 			    &fops_simulate_fw_crash);
 
@@ -857,15 +853,51 @@ void ath11k_debugfs_pdev_destroy(struct ath11k_base *ab)
 
 int ath11k_debugfs_soc_create(struct ath11k_base *ab)
 {
-	ab->debugfs_ath11k = debugfs_create_dir("ath11k", NULL);
+	struct dentry *root;
+	bool dput_needed;
+	char name[64];
+	int ret;
+
+	root = debugfs_lookup("ath11k", NULL);
+	if (!root) {
+		root = debugfs_create_dir("ath11k", NULL);
+		if (IS_ERR_OR_NULL(root))
+			return PTR_ERR(root);
+
+		dput_needed = false;
+	} else {
+		/* a dentry from lookup() needs dput() after we don't use it */
+		dput_needed = true;
+	}
+
+	scnprintf(name, sizeof(name), "%s-%s", ath11k_bus_str(ab->hif.bus),
+		  dev_name(ab->dev));
+
+	ab->debugfs_soc = debugfs_create_dir(name, root);
+	if (IS_ERR_OR_NULL(ab->debugfs_soc)) {
+		ret = PTR_ERR(ab->debugfs_soc);
+		goto out;
+	}
+
+	ret = 0;
 
-	return PTR_ERR_OR_ZERO(ab->debugfs_ath11k);
+out:
+	if (dput_needed)
+		dput(root);
+
+	return ret;
 }
 
 void ath11k_debugfs_soc_destroy(struct ath11k_base *ab)
 {
-	debugfs_remove_recursive(ab->debugfs_ath11k);
-	ab->debugfs_ath11k = NULL;
+	debugfs_remove_recursive(ab->debugfs_soc);
+	ab->debugfs_soc = NULL;
+
+	/* We are not removing ath11k directory on purpose, even if it
+	 * would be empty. This simplifies the directory handling and it's
+	 * a minor cosmetic issue to leave an empty ath11k directory to
+	 * debugfs.
+	 */
 }
 EXPORT_SYMBOL(ath11k_debugfs_soc_destroy);
 
diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 0ae6bebff801..3c64d33d0133 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3056,6 +3056,7 @@ int ath11k_peer_rx_frag_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id
 	if (!peer) {
 		ath11k_warn(ab, "failed to find the peer to set up fragment info\n");
 		spin_unlock_bh(&ab->base_lock);
+		crypto_free_shash(tfm);
 		return -ENOENT;
 	}
 
diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 7d0be9388f89..bfa7f8d96d82 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -1395,7 +1395,7 @@ static __maybe_unused int ath11k_pci_pm_suspend(struct device *dev)
 	if (ret)
 		ath11k_warn(ab, "failed to suspend core: %d\n", ret);
 
-	return ret;
+	return 0;
 }
 
 static __maybe_unused int ath11k_pci_pm_resume(struct device *dev)
diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index f938ac1a4abd..f521dfa2f194 100644
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
@@ -1412,8 +1424,6 @@ static void ath9k_hif_usb_disconnect(struct usb_interface *interface)
 
 	if (hif_dev->flags & HIF_USB_READY) {
 		ath9k_htc_hw_deinit(hif_dev->htc_handle, unplugged);
-		ath9k_hif_usb_dev_deinit(hif_dev);
-		ath9k_destroy_wmi(hif_dev->htc_handle->drv_priv);
 		ath9k_htc_hw_free(hif_dev->htc_handle);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/htc.h b/drivers/net/wireless/ath/ath9k/htc.h
index e3d546ef71dd..237f4ec2cffd 100644
--- a/drivers/net/wireless/ath/ath9k/htc.h
+++ b/drivers/net/wireless/ath/ath9k/htc.h
@@ -327,14 +327,18 @@ static inline struct ath9k_htc_tx_ctl *HTC_SKB_CB(struct sk_buff *skb)
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
@@ -374,13 +378,13 @@ void ath9k_htc_get_et_stats(struct ieee80211_hw *hw,
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
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 07ac88fb1c57..96a3185a96d7 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -988,6 +988,8 @@ void ath9k_htc_disconnect_device(struct htc_target *htc_handle, bool hotunplug)
 
 		ath9k_deinit_device(htc_handle->drv_priv);
 		ath9k_stop_wmi(htc_handle->drv_priv);
+		ath9k_hif_usb_dealloc_urbs((struct hif_device_usb *)htc_handle->hif_dev);
+		ath9k_destroy_wmi(htc_handle->drv_priv);
 		ieee80211_free_hw(htc_handle->drv_priv->hw);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index a23eaca0326d..672789e3c55d 100644
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
@@ -328,7 +328,7 @@ static void ath9k_htc_tx_data(struct ath9k_htc_priv *priv,
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
index f315c54bd3ac..19345b8f7bfd 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -341,6 +341,7 @@ int ath9k_wmi_cmd(struct wmi *wmi, enum wmi_cmd_id cmd_id,
 	if (!time_left) {
 		ath_dbg(common, WMI, "Timeout waiting for WMI command: %s\n",
 			wmi_cmd_to_name(cmd_id));
+		wmi->last_seq_id = 0;
 		mutex_unlock(&wmi->op_mutex);
 		return -ETIMEDOUT;
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/common.c
index e3758bd86acf..f29de630908d 100644
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
index e5bae6224521..f03fc6f1f833 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -338,6 +338,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 			bphy_err(drvr, "%s: failed to expand headroom\n",
 				 brcmf_ifname(ifp));
 			atomic_inc(&drvr->bus_if->stats.pktcow_failed);
+			dev_kfree_skb(skb);
 			goto done;
 		}
 	}
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 7c8e08ee8f0f..bd3b234b7803 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -346,8 +346,11 @@ brcmf_msgbuf_alloc_pktid(struct device *dev,
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
index ada6ce32c1f1..bb728fb24b8a 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2200.c
@@ -3444,7 +3444,7 @@ static void ipw_rx_queue_reset(struct ipw_priv *priv,
 			dma_unmap_single(&priv->pci_dev->dev,
 					 rxq->pool[i].dma_addr,
 					 IPW_RX_BUF_SIZE, DMA_FROM_DEVICE);
-			dev_kfree_skb(rxq->pool[i].skb);
+			dev_kfree_skb_irq(rxq->pool[i].skb);
 			rxq->pool[i].skb = NULL;
 		}
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
@@ -11400,9 +11400,14 @@ static int ipw_wdev_init(struct net_device *dev)
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
 
diff --git a/drivers/net/wireless/intel/iwlegacy/3945-mac.c b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
index 45abb25b65a9..04c149ff745e 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3378,10 +3378,12 @@ static DEVICE_ATTR(dump_errors, 0200, NULL, il3945_dump_error_log);
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
 
@@ -3398,6 +3400,8 @@ il3945_setup_deferred_work(struct il_priv *il)
 	timer_setup(&il->watchdog, il_bg_watchdog, 0);
 
 	tasklet_setup(&il->irq_tasklet, il3945_irq_tasklet);
+
+	return 0;
 }
 
 static void
@@ -3717,7 +3721,10 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	il_set_rxon_channel(il, &il->bands[NL80211_BAND_2GHZ].channels[5]);
-	il3945_setup_deferred_work(il);
+	err = il3945_setup_deferred_work(il);
+	if (err)
+		goto out_remove_sysfs;
+
 	il3945_setup_handlers(il);
 	il_power_initialize(il);
 
@@ -3729,7 +3736,7 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = il3945_setup_mac(il);
 	if (err)
-		goto out_remove_sysfs;
+		goto out_destroy_workqueue;
 
 	il_dbgfs_register(il, DRV_NAME);
 
@@ -3738,9 +3745,10 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	return 0;
 
-out_remove_sysfs:
+out_destroy_workqueue:
 	destroy_workqueue(il->workqueue);
 	il->workqueue = NULL;
+out_remove_sysfs:
 	sysfs_remove_group(&pdev->dev.kobj, &il3945_attribute_group);
 out_release_irq:
 	free_irq(il->pci_dev->irq, il);
diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index 0223532fd56a..ff04282e3db0 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -6211,10 +6211,12 @@ il4965_bg_txpower_work(struct work_struct *work)
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
 
@@ -6233,6 +6235,8 @@ il4965_setup_deferred_work(struct il_priv *il)
 	timer_setup(&il->watchdog, il_bg_watchdog, 0);
 
 	tasklet_setup(&il->irq_tasklet, il4965_irq_tasklet);
+
+	return 0;
 }
 
 static void
@@ -6617,7 +6621,10 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_disable_msi;
 	}
 
-	il4965_setup_deferred_work(il);
+	err = il4965_setup_deferred_work(il);
+	if (err)
+		goto out_free_irq;
+
 	il4965_setup_handlers(il);
 
 	/*********************************************
@@ -6655,6 +6662,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_destroy_workqueue:
 	destroy_workqueue(il->workqueue);
 	il->workqueue = NULL;
+out_free_irq:
 	free_irq(il->pci_dev->irq, il);
 out_disable_msi:
 	pci_disable_msi(il->pci_dev);
diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 683b632981ed..83c1ff0d660f 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -5173,7 +5173,7 @@ il_mac_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	memset(&il->current_ht_config, 0, sizeof(struct il_ht_config));
 
 	/* new association get rid of ibss beacon skb */
-	dev_kfree_skb(il->beacon_skb);
+	dev_consume_skb_irq(il->beacon_skb);
 	il->beacon_skb = NULL;
 	il->timestamp = 0;
 
@@ -5292,7 +5292,7 @@ il_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 	spin_lock_irqsave(&il->lock, flags);
-	dev_kfree_skb(il->beacon_skb);
+	dev_consume_skb_irq(il->beacon_skb);
 	il->beacon_skb = skb;
 
 	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
diff --git a/drivers/net/wireless/intersil/orinoco/hw.c b/drivers/net/wireless/intersil/orinoco/hw.c
index 0aea35c9c11c..4fcca08e50de 100644
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
index cb515c5584c1..74cb7551f427 100644
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
index 64fc5e410864..46877773a36d 100644
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
index 75b5319d033f..1750f5e93de2 100644
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
index cf08a4af84d6..b99381ebb82a 100644
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
index 7aecde35cb9a..1aa0479c5fa4 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -486,6 +486,7 @@ mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
 	bool more;
 
 	spin_lock_bh(&q->lock);
+
 	do {
 		buf = mt76_dma_dequeue(dev, q, true, NULL, NULL, &more);
 		if (!buf)
@@ -493,6 +494,12 @@ mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
 
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
@@ -515,12 +522,6 @@ mt76_dma_rx_reset(struct mt76_dev *dev, enum mt76_rxq_id qid)
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
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index e9d854e3293e..1c900454cf58 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -2689,7 +2689,7 @@ static int mt7915_driver_own(struct mt7915_dev *dev)
 {
 	mt76_wr(dev, MT_TOP_LPCR_HOST_BAND0, MT_TOP_LPCR_HOST_DRV_OWN);
 	if (!mt76_poll_msec(dev, MT_TOP_LPCR_HOST_BAND0,
-			    MT_TOP_LPCR_HOST_FW_OWN, 0, 500)) {
+			    MT_TOP_LPCR_HOST_FW_OWN_STAT, 0, 500)) {
 		dev_err(dev->mt76.dev, "Timeout for driver own\n");
 		return -EIO;
 	}
diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
index a213b5cb82f8..f4101cc9f9eb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/regs.h
@@ -426,6 +426,7 @@
 #define MT_TOP_LPCR_HOST_BAND0		MT_TOP(0x10)
 #define MT_TOP_LPCR_HOST_FW_OWN		BIT(0)
 #define MT_TOP_LPCR_HOST_DRV_OWN	BIT(1)
+#define MT_TOP_LPCR_HOST_FW_OWN_STAT	BIT(2)
 
 #define MT_TOP_MISC			MT_TOP(0xf0)
 #define MT_TOP_MISC_FW_STATE		GENMASK(2, 0)
diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index ed78d2cb35e3..fd3b768ca92b 100644
--- a/drivers/net/wireless/mediatek/mt7601u/dma.c
+++ b/drivers/net/wireless/mediatek/mt7601u/dma.c
@@ -123,7 +123,8 @@ static u16 mt7601u_rx_next_seg_len(u8 *data, u32 data_len)
 	if (data_len < min_seg_len ||
 	    WARN_ON_ONCE(!dma_len) ||
 	    WARN_ON_ONCE(dma_len + MT_DMA_HDRS > data_len) ||
-	    WARN_ON_ONCE(dma_len & 0x3))
+	    WARN_ON_ONCE(dma_len & 0x3) ||
+	    WARN_ON_ONCE(dma_len < min_seg_len))
 		return 0;
 
 	return MT_DMA_HDRS + dma_len;
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 9dfb1a285e6a..5e3ec20e24da 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -724,6 +724,7 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	if (skb->dev != ndev) {
 		netdev_err(ndev, "Packet not destined to this device\n");
+		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index b06508d0cdf8..46767dc6d649 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1669,6 +1669,11 @@ static void rtl8192e_enable_rf(struct rtl8xxxu_priv *priv)
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
index 3d3fa2b616a8..8873070135a0 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -5184,7 +5184,7 @@ static void rtl8xxxu_queue_rx_urb(struct rtl8xxxu_priv *priv,
 		pending = priv->rx_urb_pending_count;
 	} else {
 		skb = (struct sk_buff *)rx_urb->urb.context;
-		dev_kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 		usb_free_urb(&rx_urb->urb);
 	}
 
@@ -5490,9 +5490,6 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 	btcoex = &priv->bt_coex;
 	rarpt = &priv->ra_report;
 
-	if (priv->rf_paths > 1)
-		goto out;
-
 	while (!skb_queue_empty(&priv->c2hcmd_queue)) {
 		skb = skb_dequeue(&priv->c2hcmd_queue);
 
@@ -5544,10 +5541,9 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 		default:
 			break;
 		}
-	}
 
-out:
-	dev_kfree_skb(skb);
+		dev_kfree_skb(skb);
+	}
 }
 
 static void rtl8723bu_handle_c2h(struct rtl8xxxu_priv *priv,
@@ -5913,7 +5909,6 @@ static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct device *dev = &priv->udev->dev;
-	u16 val16;
 	int ret = 0, channel;
 	bool ht40;
 
@@ -5923,14 +5918,6 @@ static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
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
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
index bf686a916acb..13e9717a1ce8 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/hw.c
@@ -68,8 +68,10 @@ static void _rtl88ee_return_beacon_queue_skb(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[BEACON_QUEUE];
+	struct sk_buff_head free_list;
 	unsigned long flags;
 
+	skb_queue_head_init(&free_list);
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 	while (skb_queue_len(&ring->queue)) {
 		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
@@ -79,10 +81,12 @@ static void _rtl88ee_return_beacon_queue_skb(struct ieee80211_hw *hw)
 				 rtlpriv->cfg->ops->get_desc(hw, (u8 *)entry,
 						true, HW_DESC_TXBUFF_ADDR),
 				 skb->len, DMA_TO_DEVICE);
-		kfree_skb(skb);
+		__skb_queue_tail(&free_list, skb);
 		ring->idx = (ring->idx + 1) % ring->entries;
 	}
 	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
+
+	__skb_queue_purge(&free_list);
 }
 
 static void _rtl88ee_disable_bcn_sub_func(struct ieee80211_hw *hw)
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
index 0748aedce2ad..ccbb082d5e92 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723be/hw.c
@@ -30,8 +30,10 @@ static void _rtl8723be_return_beacon_queue_skb(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[BEACON_QUEUE];
+	struct sk_buff_head free_list;
 	unsigned long flags;
 
+	skb_queue_head_init(&free_list);
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 	while (skb_queue_len(&ring->queue)) {
 		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
@@ -41,10 +43,12 @@ static void _rtl8723be_return_beacon_queue_skb(struct ieee80211_hw *hw)
 				 rtlpriv->cfg->ops->get_desc(hw, (u8 *)entry,
 						true, HW_DESC_TXBUFF_ADDR),
 				 skb->len, DMA_TO_DEVICE);
-		kfree_skb(skb);
+		__skb_queue_tail(&free_list, skb);
 		ring->idx = (ring->idx + 1) % ring->entries;
 	}
 	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
+
+	__skb_queue_purge(&free_list);
 }
 
 static void _rtl8723be_set_bcn_ctrl_reg(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 33ffc24d3675..c4ee65cc2d5e 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -26,8 +26,10 @@ static void _rtl8821ae_return_beacon_queue_skb(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 	struct rtl8192_tx_ring *ring = &rtlpci->tx_ring[BEACON_QUEUE];
+	struct sk_buff_head free_list;
 	unsigned long flags;
 
+	skb_queue_head_init(&free_list);
 	spin_lock_irqsave(&rtlpriv->locks.irq_th_lock, flags);
 	while (skb_queue_len(&ring->queue)) {
 		struct rtl_tx_desc *entry = &ring->desc[ring->idx];
@@ -37,10 +39,12 @@ static void _rtl8821ae_return_beacon_queue_skb(struct ieee80211_hw *hw)
 				 rtlpriv->cfg->ops->get_desc(hw, (u8 *)entry,
 						true, HW_DESC_TXBUFF_ADDR),
 				 skb->len, DMA_TO_DEVICE);
-		kfree_skb(skb);
+		__skb_queue_tail(&free_list, skb);
 		ring->idx = (ring->idx + 1) % ring->entries;
 	}
 	spin_unlock_irqrestore(&rtlpriv->locks.irq_th_lock, flags);
+
+	__skb_queue_purge(&free_list);
 }
 
 static void _rtl8821ae_set_bcn_ctrl_reg(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
index a29321e2fa72..5323ead30db0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -1598,18 +1598,6 @@ static bool _rtl8812ae_get_integer_from_string(const char *str, u8 *pint)
 	return true;
 }
 
-static bool _rtl8812ae_eq_n_byte(const char *str1, const char *str2, u32 num)
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
@@ -1659,42 +1647,42 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw,
 	power_limit = power_limit > MAX_POWER_INDEX ?
 		      MAX_POWER_INDEX : power_limit;
 
-	if (_rtl8812ae_eq_n_byte(pregulation, "FCC", 3))
+	if (strcmp(pregulation, "FCC") == 0)
 		regulation = 0;
-	else if (_rtl8812ae_eq_n_byte(pregulation, "MKK", 3))
+	else if (strcmp(pregulation, "MKK") == 0)
 		regulation = 1;
-	else if (_rtl8812ae_eq_n_byte(pregulation, "ETSI", 4))
+	else if (strcmp(pregulation, "ETSI") == 0)
 		regulation = 2;
-	else if (_rtl8812ae_eq_n_byte(pregulation, "WW13", 4))
+	else if (strcmp(pregulation, "WW13") == 0)
 		regulation = 3;
 
-	if (_rtl8812ae_eq_n_byte(prate_section, "CCK", 3))
+	if (strcmp(prate_section, "CCK") == 0)
 		rate_section = 0;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "OFDM", 4))
+	else if (strcmp(prate_section, "OFDM") == 0)
 		rate_section = 1;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "HT", 2) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "1T", 2))
+	else if (strcmp(prate_section, "HT") == 0 &&
+		 strcmp(prf_path, "1T") == 0)
 		rate_section = 2;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "HT", 2) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "2T", 2))
+	else if (strcmp(prate_section, "HT") == 0 &&
+		 strcmp(prf_path, "2T") == 0)
 		rate_section = 3;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "VHT", 3) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "1T", 2))
+	else if (strcmp(prate_section, "VHT") == 0 &&
+		 strcmp(prf_path, "1T") == 0)
 		rate_section = 4;
-	else if (_rtl8812ae_eq_n_byte(prate_section, "VHT", 3) &&
-		 _rtl8812ae_eq_n_byte(prf_path, "2T", 2))
+	else if (strcmp(prate_section, "VHT") == 0 &&
+		 strcmp(prf_path, "2T") == 0)
 		rate_section = 5;
 
-	if (_rtl8812ae_eq_n_byte(pbandwidth, "20M", 3))
+	if (strcmp(pbandwidth, "20M") == 0)
 		bandwidth = 0;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, "40M", 3))
+	else if (strcmp(pbandwidth, "40M") == 0)
 		bandwidth = 1;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, "80M", 3))
+	else if (strcmp(pbandwidth, "80M") == 0)
 		bandwidth = 2;
-	else if (_rtl8812ae_eq_n_byte(pbandwidth, "160M", 4))
+	else if (strcmp(pbandwidth, "160M") == 0)
 		bandwidth = 3;
 
-	if (_rtl8812ae_eq_n_byte(pband, "2.4G", 4)) {
+	if (strcmp(pband, "2.4G") == 0) {
 		ret = _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(hw,
 							       BAND_ON_2_4G,
 							       channel);
@@ -1718,7 +1706,7 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw,
 			regulation, bandwidth, rate_section, channel_index,
 			rtlphy->txpwr_limit_2_4g[regulation][bandwidth]
 				[rate_section][channel_index][RF90_PATH_A]);
-	} else if (_rtl8812ae_eq_n_byte(pband, "5G", 2)) {
+	} else if (strcmp(pband, "5G") == 0) {
 		ret = _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(hw,
 							       BAND_ON_5G,
 							       channel);
diff --git a/drivers/net/wireless/rsi/rsi_91x_coex.c b/drivers/net/wireless/rsi/rsi_91x_coex.c
index a0c5d02ae88c..7395359b43b7 100644
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
diff --git a/drivers/net/wireless/wl3501_cs.c b/drivers/net/wireless/wl3501_cs.c
index 672f5d5f3f2c..cb71b73853f4 100644
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
diff --git a/drivers/opp/debugfs.c b/drivers/opp/debugfs.c
index b5f2f9f39392..9eb71f47487b 100644
--- a/drivers/opp/debugfs.c
+++ b/drivers/opp/debugfs.c
@@ -209,7 +209,7 @@ static void opp_migrate_dentry(struct opp_device *opp_dev,
 
 	dentry = debugfs_rename(rootdir, opp_dev->dentry, rootdir,
 				opp_table->dentry_name);
-	if (!dentry) {
+	if (IS_ERR(dentry)) {
 		dev_err(dev, "%s: Failed to rename link from: %s to %s\n",
 			__func__, dev_name(opp_dev->dev), dev_name(dev));
 		return;
diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index dafdc652fcd0..ef71c1a20400 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -14,7 +14,7 @@
 #include <linux/delay.h>
 #include "pci.h"
 
-#define VIRTFN_ID_LEN	16
+#define VIRTFN_ID_LEN	17	/* "virtfn%u\0" for 2^32 - 1 */
 
 int pci_iov_virtfn_bus(struct pci_dev *dev, int vf_id)
 {
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index a0c6a9eeb7c6..778ae3c861f4 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4902,7 +4902,7 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 	if (pci_dev_is_disconnected(dev))
 		return;
 
-	if (!pci_is_bridge(dev) || !dev->bridge_d3)
+	if (!pci_is_bridge(dev))
 		return;
 
 	down_read(&pci_bus_sem);
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 1cce56c2aea0..739e416b0db2 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -347,53 +347,36 @@ struct pci_sriov {
  * @dev: PCI device to set new error_state
  * @new: the state we want dev to be in
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
index a531064233f9..305ff5bd1a20 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5328,6 +5328,7 @@ static void quirk_no_flr(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1487, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x148c, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x7901, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
 
diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index 0b301f8be9ed..d021ef3fb165 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -552,21 +552,20 @@ static ssize_t switchtec_dev_read(struct file *filp, char __user *data,
 	rc = copy_to_user(data, &stuser->return_code,
 			  sizeof(stuser->return_code));
 	if (rc) {
-		rc = -EFAULT;
-		goto out;
+		mutex_unlock(&stdev->mrpc_mutex);
+		return -EFAULT;
 	}
 
 	data += sizeof(stuser->return_code);
 	rc = copy_to_user(data, &stuser->data,
 			  size - sizeof(stuser->return_code));
 	if (rc) {
-		rc = -EFAULT;
-		goto out;
+		mutex_unlock(&stdev->mrpc_mutex);
+		return -EFAULT;
 	}
 
 	stuser_set_state(stuser, MRPC_IDLE);
 
-out:
 	mutex_unlock(&stdev->mrpc_mutex);
 
 	if (stuser->status == SWITCHTEC_MRPC_STATUS_DONE)
diff --git a/drivers/phy/rockchip/phy-rockchip-typec.c b/drivers/phy/rockchip/phy-rockchip-typec.c
index d2bbdc96a167..5b9a254c4552 100644
--- a/drivers/phy/rockchip/phy-rockchip-typec.c
+++ b/drivers/phy/rockchip/phy-rockchip-typec.c
@@ -821,10 +821,10 @@ static int tcphy_get_mode(struct rockchip_typec_phy *tcphy)
 	mode = MODE_DFP_USB;
 	id = EXTCON_USB_HOST;
 
-	if (ufp) {
+	if (ufp > 0) {
 		mode = MODE_UFP_USB;
 		id = EXTCON_USB;
-	} else if (dp) {
+	} else if (dp > 0) {
 		mode = MODE_DFP_DP;
 		id = EXTCON_DISP_DP;
 
diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index a2938995c7c1..2c10086fd155 100644
--- a/drivers/pinctrl/bcm/pinctrl-bcm2835.c
+++ b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
@@ -356,8 +356,6 @@ static int bcm2835_of_gpio_ranges_fallback(struct gpio_chip *gc,
 {
 	struct pinctrl_dev *pctldev = of_pinctrl_get(np);
 
-	of_node_put(np);
-
 	if (!pctldev)
 		return 0;
 
diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index 02e2a259edd3..0fa1c36148c2 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -572,9 +572,9 @@ static int mtk_hw_get_value_wrap(struct mtk_pinctrl *hw, unsigned int gpio, int
 	mtk_hw_get_value_wrap(hw, gpio, PINCTRL_PIN_REG_DRV)
 
 ssize_t mtk_pctrl_show_one_pin(struct mtk_pinctrl *hw,
-	unsigned int gpio, char *buf, unsigned int bufLen)
+	unsigned int gpio, char *buf, unsigned int buf_len)
 {
-	int pinmux, pullup, pullen, len = 0, r1 = -1, r0 = -1;
+	int pinmux, pullup = 0, pullen = 0, len = 0, r1 = -1, r0 = -1;
 	const struct mtk_pin_desc *desc;
 
 	if (gpio >= hw->soc->npins)
@@ -608,7 +608,7 @@ ssize_t mtk_pctrl_show_one_pin(struct mtk_pinctrl *hw,
 	} else if (pullen != MTK_DISABLE && pullen != MTK_ENABLE) {
 		pullen = 0;
 	}
-	len += scnprintf(buf + len, bufLen - len,
+	len += scnprintf(buf + len, buf_len - len,
 			"%03d: %1d%1d%1d%1d%02d%1d%1d%1d%1d",
 			gpio,
 			pinmux,
@@ -622,10 +622,10 @@ ssize_t mtk_pctrl_show_one_pin(struct mtk_pinctrl *hw,
 			pullup);
 
 	if (r1 != -1) {
-		len += scnprintf(buf + len, bufLen - len, " (%1d %1d)\n",
+		len += scnprintf(buf + len, buf_len - len, " (%1d %1d)\n",
 			r1, r0);
 	} else {
-		len += scnprintf(buf + len, bufLen - len, "\n");
+		len += scnprintf(buf + len, buf_len - len, "\n");
 	}
 
 	return len;
@@ -637,7 +637,7 @@ static void mtk_pctrl_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
 			  unsigned int gpio)
 {
 	struct mtk_pinctrl *hw = pinctrl_dev_get_drvdata(pctldev);
-	char buf[PIN_DBG_BUF_SZ];
+	char buf[PIN_DBG_BUF_SZ] = { 0 };
 
 	(void)mtk_pctrl_show_one_pin(hw, gpio, buf, PIN_DBG_BUF_SZ);
 
diff --git a/drivers/pinctrl/pinctrl-at91-pio4.c b/drivers/pinctrl/pinctrl-at91-pio4.c
index 03c32b2c5d30..c86fcdfaf825 100644
--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -1126,8 +1126,8 @@ static int atmel_pinctrl_probe(struct platform_device *pdev)
 
 		pin_desc[i].number = i;
 		/* Pin naming convention: P(bank_name)(bank_pin_number). */
-		pin_desc[i].name = kasprintf(GFP_KERNEL, "P%c%d",
-					     bank + 'A', line);
+		pin_desc[i].name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "P%c%d",
+						  bank + 'A', line);
 
 		group->name = group_names[i] = pin_desc[i].name;
 		group->pin = pin_desc[i].number;
diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 6022496bb6a9..3b0341c730ee 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1891,7 +1891,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < chip->ngpio; i++)
-		names[i] = kasprintf(GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
+		names[i] = devm_kasprintf(&pdev->dev, GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
 
 	chip->names = (const char *const *)names;
 
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index c33cbf7568db..a6f4aca9c61c 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -2499,6 +2499,7 @@ static int rockchip_pinctrl_parse_groups(struct device_node *np,
 		np_config = of_find_node_by_phandle(be32_to_cpup(phandle));
 		ret = pinconf_generic_parse_dt_config(np_config, NULL,
 				&grp->data[j].configs, &grp->data[j].nconfigs);
+		of_node_put(np_config);
 		if (ret)
 			return ret;
 	}
diff --git a/drivers/pinctrl/qcom/pinctrl-msm8976.c b/drivers/pinctrl/qcom/pinctrl-msm8976.c
index ec43edf9b660..e11d84584719 100644
--- a/drivers/pinctrl/qcom/pinctrl-msm8976.c
+++ b/drivers/pinctrl/qcom/pinctrl-msm8976.c
@@ -733,7 +733,7 @@ static const char * const codec_int2_groups[] = {
 	"gpio74",
 };
 static const char * const wcss_bt_groups[] = {
-	"gpio39", "gpio47", "gpio88",
+	"gpio39", "gpio47", "gpio48",
 };
 static const char * const sdc3_groups[] = {
 	"gpio39", "gpio40", "gpio41",
@@ -958,9 +958,9 @@ static const struct msm_pingroup msm8976_groups[] = {
 	PINGROUP(37, NA, NA, NA, qdss_tracedata_b, NA, NA, NA, NA, NA),
 	PINGROUP(38, NA, NA, NA, NA, NA, NA, NA, qdss_tracedata_b, NA),
 	PINGROUP(39, wcss_bt, sdc3, NA, qdss_tracedata_a, NA, NA, NA, NA, NA),
-	PINGROUP(40, wcss_wlan, sdc3, NA, qdss_tracedata_a, NA, NA, NA, NA, NA),
-	PINGROUP(41, wcss_wlan, sdc3, NA, qdss_tracedata_a, NA, NA, NA, NA, NA),
-	PINGROUP(42, wcss_wlan, sdc3, NA, qdss_tracedata_a, NA, NA, NA, NA, NA),
+	PINGROUP(40, wcss_wlan2, sdc3, NA, qdss_tracedata_a, NA, NA, NA, NA, NA),
+	PINGROUP(41, wcss_wlan1, sdc3, NA, qdss_tracedata_a, NA, NA, NA, NA, NA),
+	PINGROUP(42, wcss_wlan0, sdc3, NA, qdss_tracedata_a, NA, NA, NA, NA, NA),
 	PINGROUP(43, wcss_wlan, sdc3, NA, NA, qdss_tracedata_a, NA, NA, NA, NA),
 	PINGROUP(44, wcss_wlan, sdc3, NA, NA, NA, NA, NA, NA, NA),
 	PINGROUP(45, wcss_fm, NA, qdss_tracectl_a, NA, NA, NA, NA, NA, NA),
diff --git a/drivers/pinctrl/stm32/pinctrl-stm32.c b/drivers/pinctrl/stm32/pinctrl-stm32.c
index d3fa8cf0d72c..abb12a5c3c32 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1334,6 +1334,7 @@ static struct irq_domain *stm32_pctrl_get_irq_domain(struct device_node *np)
 		return ERR_PTR(-ENXIO);
 
 	domain = irq_find_host(parent);
+	of_node_put(parent);
 	if (!domain)
 		/* domain not registered yet */
 		return ERR_PTR(-EPROBE_DEFER);
diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 3f9c60c5b250..8161fad081a9 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -1014,87 +1014,6 @@ static void psy_unregister_thermal(struct power_supply *psy)
 	thermal_zone_device_unregister(psy->tzd);
 }
 
-/* thermal cooling device callbacks */
-static int ps_get_max_charge_cntl_limit(struct thermal_cooling_device *tcd,
-					unsigned long *state)
-{
-	struct power_supply *psy;
-	union power_supply_propval val;
-	int ret;
-
-	psy = tcd->devdata;
-	ret = power_supply_get_property(psy,
-			POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT_MAX, &val);
-	if (ret)
-		return ret;
-
-	*state = val.intval;
-
-	return ret;
-}
-
-static int ps_get_cur_charge_cntl_limit(struct thermal_cooling_device *tcd,
-					unsigned long *state)
-{
-	struct power_supply *psy;
-	union power_supply_propval val;
-	int ret;
-
-	psy = tcd->devdata;
-	ret = power_supply_get_property(psy,
-			POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT, &val);
-	if (ret)
-		return ret;
-
-	*state = val.intval;
-
-	return ret;
-}
-
-static int ps_set_cur_charge_cntl_limit(struct thermal_cooling_device *tcd,
-					unsigned long state)
-{
-	struct power_supply *psy;
-	union power_supply_propval val;
-	int ret;
-
-	psy = tcd->devdata;
-	val.intval = state;
-	ret = psy->desc->set_property(psy,
-		POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT, &val);
-
-	return ret;
-}
-
-static const struct thermal_cooling_device_ops psy_tcd_ops = {
-	.get_max_state = ps_get_max_charge_cntl_limit,
-	.get_cur_state = ps_get_cur_charge_cntl_limit,
-	.set_cur_state = ps_set_cur_charge_cntl_limit,
-};
-
-static int psy_register_cooler(struct power_supply *psy)
-{
-	int i;
-
-	/* Register for cooling device if psy can control charging */
-	for (i = 0; i < psy->desc->num_properties; i++) {
-		if (psy->desc->properties[i] ==
-				POWER_SUPPLY_PROP_CHARGE_CONTROL_LIMIT) {
-			psy->tcd = thermal_cooling_device_register(
-							(char *)psy->desc->name,
-							psy, &psy_tcd_ops);
-			return PTR_ERR_OR_ZERO(psy->tcd);
-		}
-	}
-	return 0;
-}
-
-static void psy_unregister_cooler(struct power_supply *psy)
-{
-	if (IS_ERR_OR_NULL(psy->tcd))
-		return;
-	thermal_cooling_device_unregister(psy->tcd);
-}
 #else
 static int psy_register_thermal(struct power_supply *psy)
 {
@@ -1104,15 +1023,6 @@ static int psy_register_thermal(struct power_supply *psy)
 static void psy_unregister_thermal(struct power_supply *psy)
 {
 }
-
-static int psy_register_cooler(struct power_supply *psy)
-{
-	return 0;
-}
-
-static void psy_unregister_cooler(struct power_supply *psy)
-{
-}
 #endif
 
 static struct power_supply *__must_check
@@ -1188,10 +1098,6 @@ __power_supply_register(struct device *parent,
 	if (rc)
 		goto register_thermal_failed;
 
-	rc = psy_register_cooler(psy);
-	if (rc)
-		goto register_cooler_failed;
-
 	rc = power_supply_create_triggers(psy);
 	if (rc)
 		goto create_triggers_failed;
@@ -1221,8 +1127,6 @@ __power_supply_register(struct device *parent,
 add_hwmon_sysfs_failed:
 	power_supply_remove_triggers(psy);
 create_triggers_failed:
-	psy_unregister_cooler(psy);
-register_cooler_failed:
 	psy_unregister_thermal(psy);
 register_thermal_failed:
 wakeup_init_failed:
@@ -1374,7 +1278,6 @@ void power_supply_unregister(struct power_supply *psy)
 	sysfs_remove_link(&psy->dev.kobj, "powers");
 	power_supply_remove_hwmon_sysfs(psy);
 	power_supply_remove_triggers(psy);
-	psy_unregister_cooler(psy);
 	psy_unregister_thermal(psy);
 	device_init_wakeup(&psy->dev, false);
 	device_unregister(&psy->dev);
diff --git a/drivers/powercap/powercap_sys.c b/drivers/powercap/powercap_sys.c
index f0654a932b37..ff736b006198 100644
--- a/drivers/powercap/powercap_sys.c
+++ b/drivers/powercap/powercap_sys.c
@@ -529,9 +529,6 @@ struct powercap_zone *powercap_register_zone(
 	power_zone->name = kstrdup(name, GFP_KERNEL);
 	if (!power_zone->name)
 		goto err_name_alloc;
-	dev_set_name(&power_zone->dev, "%s:%x",
-					dev_name(power_zone->dev.parent),
-					power_zone->id);
 	power_zone->constraints = kcalloc(nr_constraints,
 					  sizeof(*power_zone->constraints),
 					  GFP_KERNEL);
@@ -554,9 +551,16 @@ struct powercap_zone *powercap_register_zone(
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
diff --git a/drivers/regulator/max77802-regulator.c b/drivers/regulator/max77802-regulator.c
index 21e0eb0f43f9..befe5f319819 100644
--- a/drivers/regulator/max77802-regulator.c
+++ b/drivers/regulator/max77802-regulator.c
@@ -94,9 +94,11 @@ static int max77802_set_suspend_disable(struct regulator_dev *rdev)
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
@@ -110,7 +112,7 @@ static int max77802_set_suspend_disable(struct regulator_dev *rdev)
 static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
 {
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 	unsigned int val;
 	int shift = max77802_get_opmode_shift(id);
 
@@ -127,6 +129,9 @@ static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
 		return -EINVAL;
 	}
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
+
 	max77802->opmode[id] = val;
 	return regmap_update_bits(rdev->regmap, rdev->desc->enable_reg,
 				  rdev->desc->enable_mask, val << shift);
@@ -135,8 +140,10 @@ static int max77802_set_mode(struct regulator_dev *rdev, unsigned int mode)
 static unsigned max77802_get_mode(struct regulator_dev *rdev)
 {
 	struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
-	int id = rdev_get_id(rdev);
+	unsigned int id = rdev_get_id(rdev);
 
+	if (WARN_ON_ONCE(id >= ARRAY_SIZE(max77802->opmode)))
+		return -EINVAL;
 	return max77802_map_mode(max77802->opmode[id]);
 }
 
@@ -160,10 +167,13 @@ static int max77802_set_suspend_mode(struct regulator_dev *rdev,
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
@@ -209,9 +219,11 @@ static int max77802_set_suspend_mode(struct regulator_dev *rdev,
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
 
@@ -495,7 +507,7 @@ static int max77802_pmic_probe(struct platform_device *pdev)
 
 	for (i = 0; i < MAX77802_REG_MAX; i++) {
 		struct regulator_dev *rdev;
-		int id = regulators[i].id;
+		unsigned int id = regulators[i].id;
 		int shift = max77802_get_opmode_shift(id);
 		int ret;
 
@@ -513,10 +525,12 @@ static int max77802_pmic_probe(struct platform_device *pdev)
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
index 35269f998210..754c6fcc6e64 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -923,10 +923,14 @@ static int s5m8767_pmic_probe(struct platform_device *pdev)
 
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
diff --git a/drivers/remoteproc/mtk_scp_ipi.c b/drivers/remoteproc/mtk_scp_ipi.c
index 6dc955ecab80..968128b78e59 100644
--- a/drivers/remoteproc/mtk_scp_ipi.c
+++ b/drivers/remoteproc/mtk_scp_ipi.c
@@ -164,21 +164,21 @@ int scp_ipi_send(struct mtk_scp *scp, u32 id, void *buf, unsigned int len,
 	    WARN_ON(len > sizeof(send_obj->share_buf)) || WARN_ON(!buf))
 		return -EINVAL;
 
-	mutex_lock(&scp->send_lock);
-
 	ret = clk_prepare_enable(scp->clk);
 	if (ret) {
 		dev_err(scp->dev, "failed to enable clock\n");
-		goto unlock_mutex;
+		return ret;
 	}
 
+	mutex_lock(&scp->send_lock);
+
 	 /* Wait until SCP receives the last command */
 	timeout = jiffies + msecs_to_jiffies(2000);
 	do {
 		if (time_after(jiffies, timeout)) {
 			dev_err(scp->dev, "%s: IPI timeout!\n", __func__);
 			ret = -ETIMEDOUT;
-			goto clock_disable;
+			goto unlock_mutex;
 		}
 	} while (readl(scp->reg_base + scp->data->host_to_scp_reg));
 
@@ -205,10 +205,9 @@ int scp_ipi_send(struct mtk_scp *scp, u32 id, void *buf, unsigned int len,
 			ret = 0;
 	}
 
-clock_disable:
-	clk_disable_unprepare(scp->clk);
 unlock_mutex:
 	mutex_unlock(&scp->send_lock);
+	clk_disable_unprepare(scp->clk);
 
 	return ret;
 }
diff --git a/drivers/remoteproc/qcom_q6v5_mss.c b/drivers/remoteproc/qcom_q6v5_mss.c
index ca1c7387776b..93eefefd514c 100644
--- a/drivers/remoteproc/qcom_q6v5_mss.c
+++ b/drivers/remoteproc/qcom_q6v5_mss.c
@@ -17,6 +17,7 @@
 #include <linux/module.h>
 #include <linux/of_address.h>
 #include <linux/of_device.h>
+#include <linux/of_reserved_mem.h>
 #include <linux/platform_device.h>
 #include <linux/pm_domain.h>
 #include <linux/pm_runtime.h>
@@ -192,6 +193,9 @@ struct q6v5 {
 	size_t mba_size;
 	size_t dp_size;
 
+	phys_addr_t mdata_phys;
+	size_t mdata_size;
+
 	phys_addr_t mpss_phys;
 	phys_addr_t mpss_reloc;
 	size_t mpss_size;
@@ -832,15 +836,35 @@ static int q6v5_mpss_init_image(struct q6v5 *qproc, const struct firmware *fw)
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
 	ret = q6v5_xfer_mem_ownership(qproc, &mdata_perm, false, true,
@@ -869,7 +893,9 @@ static int q6v5_mpss_init_image(struct q6v5 *qproc, const struct firmware *fw)
 			 "mdt buffer not reclaimed system may become unstable\n");
 
 free_dma_attrs:
-	dma_free_attrs(qproc->dev, size, ptr, phys, dma_attrs);
+	if (!qproc->mdata_phys)
+		dma_free_attrs(qproc->dev, size, ptr, phys, dma_attrs);
+free_metadata:
 	kfree(metadata);
 
 	return ret < 0 ? ret : 0;
@@ -1615,6 +1641,7 @@ static int q6v5_init_reset(struct q6v5 *qproc)
 static int q6v5_alloc_memory_region(struct q6v5 *qproc)
 {
 	struct device_node *child;
+	struct reserved_mem *rmem;
 	struct device_node *node;
 	struct resource r;
 	int ret;
@@ -1661,6 +1688,26 @@ static int q6v5_alloc_memory_region(struct q6v5 *qproc)
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
index 13c31372337a..fd4c2f0fa4b1 100644
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
index 29a1c65661e9..b1fb870c570d 100644
--- a/drivers/rtc/rtc-pm8xxx.c
+++ b/drivers/rtc/rtc-pm8xxx.c
@@ -220,7 +220,6 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 {
 	int rc, i;
 	u8 value[NUM_8_BIT_RTC_REGS];
-	unsigned int ctrl_reg;
 	unsigned long secs, irq_flags;
 	struct pm8xxx_rtc *rtc_dd = dev_get_drvdata(dev);
 	const struct pm8xxx_rtc_regs *regs = rtc_dd->regs;
@@ -232,6 +231,11 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
 		secs >>= 8;
 	}
 
+	rc = regmap_update_bits(rtc_dd->regmap, regs->alarm_ctrl,
+				regs->alarm_en, 0);
+	if (rc)
+		return rc;
+
 	spin_lock_irqsave(&rtc_dd->ctrl_reg_lock, irq_flags);
 
 	rc = regmap_bulk_write(rtc_dd->regmap, regs->alarm_rw, value,
@@ -241,19 +245,11 @@ static int pm8xxx_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *alarm)
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
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 57dfc92aa756..56ab74aa07f4 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -6729,8 +6729,10 @@ dasd_eckd_init(void)
 		return -ENOMEM;
 	dasd_vol_info_req = kmalloc(sizeof(*dasd_vol_info_req),
 				    GFP_KERNEL | GFP_DMA);
-	if (!dasd_vol_info_req)
+	if (!dasd_vol_info_req) {
+		kfree(dasd_reserve_req);
 		return -ENOMEM;
+	}
 	pe_handler_worker = kmalloc(sizeof(*pe_handler_worker),
 				    GFP_KERNEL | GFP_DMA);
 	if (!pe_handler_worker) {
diff --git a/drivers/scsi/aic94xx/aic94xx_task.c b/drivers/scsi/aic94xx/aic94xx_task.c
index c6b63eae28f5..ce48f34f412f 100644
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
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index df3b190fccd1..7d333167047f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -21066,6 +21066,7 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 	struct lpfc_mbx_wr_object *wr_object;
 	LPFC_MBOXQ_t *mbox;
 	int rc = 0, i = 0;
+	int mbox_status = 0;
 	uint32_t shdr_status, shdr_add_status, shdr_add_status_2;
 	uint32_t shdr_change_status = 0, shdr_csf = 0;
 	uint32_t mbox_tmo;
@@ -21111,11 +21112,15 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 	wr_object->u.request.bde_count = i;
 	bf_set(lpfc_wr_object_write_length, &wr_object->u.request, written);
 	if (!phba->sli4_hba.intr_enable)
-		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
+		mbox_status = lpfc_sli_issue_mbox(phba, mbox, MBX_POLL);
 	else {
 		mbox_tmo = lpfc_mbox_tmo_val(phba, mbox);
-		rc = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
+		mbox_status = lpfc_sli_issue_mbox_wait(phba, mbox, mbox_tmo);
 	}
+
+	/* The mbox status needs to be maintained to detect MBOX_TIMEOUT. */
+	rc = mbox_status;
+
 	/* The IOCTL status is embedded in the mailbox subheader. */
 	shdr_status = bf_get(lpfc_mbox_hdr_status,
 			     &wr_object->header.cfg_shdr.response);
@@ -21130,10 +21135,6 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 				  &wr_object->u.response);
 	}
 
-	if (!phba->sli4_hba.intr_enable)
-		mempool_free(mbox, phba->mbox_mem_pool);
-	else if (rc != MBX_TIMEOUT)
-		mempool_free(mbox, phba->mbox_mem_pool);
 	if (shdr_status || shdr_add_status || shdr_add_status_2 || rc) {
 		lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 				"3025 Write Object mailbox failed with "
@@ -21151,6 +21152,12 @@ lpfc_wr_object(struct lpfc_hba *phba, struct list_head *dmabuf_list,
 		lpfc_log_fw_write_cmpl(phba, shdr_status, shdr_add_status,
 				       shdr_add_status_2, shdr_change_status,
 				       shdr_csf);
+
+	if (!phba->sli4_hba.intr_enable)
+		mempool_free(mbox, phba->mbox_mem_pool);
+	else if (mbox_status != MBX_TIMEOUT)
+		mempool_free(mbox, phba->mbox_mem_pool);
+
 	return rc;
 }
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 766c3a59a900..9e674b748e78 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5682,6 +5682,9 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		}
 		dma_pool_destroy(ioc->pcie_sgl_dma_pool);
 	}
+	kfree(ioc->pcie_sg_lookup);
+	ioc->pcie_sg_lookup = NULL;
+
 	if (ioc->config_page) {
 		dexitprintk(ioc,
 			    ioc_info(ioc, "config_page(0x%p): free\n",
diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
index 3650f16cab6c..c7c5c013a074 100644
--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -278,8 +278,8 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 	const char *type;
 	int req_sg_cnt, rsp_sg_cnt;
 	int rval =  (DID_ERROR << 16);
-	uint16_t nextlid = 0;
 	uint32_t els_cmd = 0;
+	int qla_port_allocated = 0;
 
 	if (bsg_request->msgcode == FC_BSG_RPT_ELS) {
 		rport = fc_bsg_to_rport(bsg_job);
@@ -329,9 +329,9 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 		/* make sure the rport is logged in,
 		 * if not perform fabric login
 		 */
-		if (qla2x00_fabric_login(vha, fcport, &nextlid)) {
+		if (atomic_read(&fcport->state) != FCS_ONLINE) {
 			ql_dbg(ql_dbg_user, vha, 0x7003,
-			    "Failed to login port %06X for ELS passthru.\n",
+			    "Port %06X is not online for ELS passthru.\n",
 			    fcport->d_id.b24);
 			rval = -EIO;
 			goto done;
@@ -348,6 +348,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 			goto done;
 		}
 
+		qla_port_allocated = 1;
 		/* Initialize all required  fields of fcport */
 		fcport->vha = vha;
 		fcport->d_id.b.al_pa =
@@ -432,7 +433,7 @@ qla2x00_process_els(struct bsg_job *bsg_job)
 	goto done_free_fcport;
 
 done_free_fcport:
-	if (bsg_request->msgcode != FC_BSG_RPT_ELS)
+	if (qla_port_allocated)
 		qla2x00_free_fcport(fcport);
 done:
 	return rval;
diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_def.h
index 307ffdfe048b..5b499b0e2c86 100644
--- a/drivers/scsi/qla2xxx/qla_def.h
+++ b/drivers/scsi/qla2xxx/qla_def.h
@@ -655,7 +655,7 @@ enum {
 
 struct iocb_resource {
 	u8 res_type;
-	u8 pad;
+	u8  exch_cnt;
 	u16 iocb_cnt;
 };
 
@@ -3707,6 +3707,10 @@ struct qla_fw_resources {
 	u16 iocbs_limit;
 	u16 iocbs_qp_limit;
 	u16 iocbs_used;
+	u16 exch_total;
+	u16 exch_limit;
+	u16 exch_used;
+	u16 pad;
 };
 
 #define QLA_IOCB_PCT_LIMIT 95
diff --git a/drivers/scsi/qla2xxx/qla_dfs.c b/drivers/scsi/qla2xxx/qla_dfs.c
index 85bd0e468d43..8f6f56c9584c 100644
--- a/drivers/scsi/qla2xxx/qla_dfs.c
+++ b/drivers/scsi/qla2xxx/qla_dfs.c
@@ -235,7 +235,7 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 	uint16_t mb[MAX_IOCB_MB_REG];
 	int rc;
 	struct qla_hw_data *ha = vha->hw;
-	u16 iocbs_used, i;
+	u16 iocbs_used, i, exch_used;
 
 	rc = qla24xx_res_count_wait(vha, mb, SIZEOF_IOCB_MB_REG);
 	if (rc != QLA_SUCCESS) {
@@ -263,13 +263,19 @@ qla_dfs_fw_resource_cnt_show(struct seq_file *s, void *unused)
 	if (ql2xenforce_iocb_limit) {
 		/* lock is not require. It's an estimate. */
 		iocbs_used = ha->base_qpair->fwres.iocbs_used;
+		exch_used = ha->base_qpair->fwres.exch_used;
 		for (i = 0; i < ha->max_qpairs; i++) {
-			if (ha->queue_pair_map[i])
+			if (ha->queue_pair_map[i]) {
 				iocbs_used += ha->queue_pair_map[i]->fwres.iocbs_used;
+				exch_used += ha->queue_pair_map[i]->fwres.exch_used;
+			}
 		}
 
 		seq_printf(s, "Driver: estimate iocb used [%d] high water limit [%d]\n",
 			   iocbs_used, ha->base_qpair->fwres.iocbs_limit);
+
+		seq_printf(s, "estimate exchange used[%d] high water limit [%d] n",
+			   exch_used, ha->base_qpair->fwres.exch_limit);
 	}
 
 	return 0;
diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
index 8e9237434e8b..f81cf85dcdc7 100644
--- a/drivers/scsi/qla2xxx/qla_edif.c
+++ b/drivers/scsi/qla2xxx/qla_edif.c
@@ -2898,6 +2898,13 @@ qla28xx_start_scsi_edif(srb_t *sp)
 
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
+	sp->iores.iocb_cnt = req_cnt;
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
+		goto queuing_error;
+
 	if (req->cnt < (req_cnt + 2)) {
 		cnt = IS_SHADOW_REG_CAPABLE(ha) ? *req->out_ptr :
 		    rd_reg_dword(req->req_q_out);
@@ -3089,6 +3096,7 @@ qla28xx_start_scsi_edif(srb_t *sp)
 		mempool_free(sp->u.scmd.ct6_ctx, ha->ctx_mempool);
 		sp->u.scmd.ct6_ctx = NULL;
 	}
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(lock, flags);
 
 	return QLA_FUNCTION_FAILED;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
index 30798ab84db9..ded027fe2924 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -128,12 +128,14 @@ static void qla24xx_abort_iocb_timeout(void *data)
 		    sp->cmd_sp)) {
 			qpair->req->outstanding_cmds[handle] = NULL;
 			cmdsp_found = 1;
+			qla_put_fw_resources(qpair, &sp->cmd_sp->iores);
 		}
 
 		/* removing the abort */
 		if (qpair->req->outstanding_cmds[handle] == sp) {
 			qpair->req->outstanding_cmds[handle] = NULL;
 			sp_found = 1;
+			qla_put_fw_resources(qpair, &sp->iores);
 			break;
 		}
 	}
@@ -2002,6 +2004,7 @@ qla2x00_tmf_iocb_timeout(void *data)
 		for (h = 1; h < sp->qpair->req->num_outstanding_cmds; h++) {
 			if (sp->qpair->req->outstanding_cmds[h] == sp) {
 				sp->qpair->req->outstanding_cmds[h] = NULL;
+				qla_put_fw_resources(sp->qpair, &sp->iores);
 				break;
 			}
 		}
@@ -2075,7 +2078,6 @@ qla2x00_async_tm_cmd(fc_port_t *fcport, uint32_t flags, uint32_t lun,
 done_free_sp:
 	/* ref: INIT */
 	kref_put(&sp->cmd_kref, qla2x00_sp_release);
-	fcport->flags &= ~FCF_ASYNC_SENT;
 done:
 	return rval;
 }
@@ -3945,6 +3947,12 @@ void qla_init_iocb_limit(scsi_qla_host_t *vha)
 	ha->base_qpair->fwres.iocbs_limit = limit;
 	ha->base_qpair->fwres.iocbs_qp_limit = limit / num_qps;
 	ha->base_qpair->fwres.iocbs_used = 0;
+
+	ha->base_qpair->fwres.exch_total = ha->orig_fw_xcb_count;
+	ha->base_qpair->fwres.exch_limit = (ha->orig_fw_xcb_count *
+					    QLA_IOCB_PCT_LIMIT) / 100;
+	ha->base_qpair->fwres.exch_used  = 0;
+
 	for (i = 0; i < ha->max_qpairs; i++) {
 		if (ha->queue_pair_map[i])  {
 			ha->queue_pair_map[i]->fwres.iocbs_total =
@@ -3953,6 +3961,10 @@ void qla_init_iocb_limit(scsi_qla_host_t *vha)
 			ha->queue_pair_map[i]->fwres.iocbs_qp_limit =
 				limit / num_qps;
 			ha->queue_pair_map[i]->fwres.iocbs_used = 0;
+			ha->queue_pair_map[i]->fwres.exch_total = ha->orig_fw_xcb_count;
+			ha->queue_pair_map[i]->fwres.exch_limit =
+				(ha->orig_fw_xcb_count * QLA_IOCB_PCT_LIMIT) / 100;
+			ha->queue_pair_map[i]->fwres.exch_used = 0;
 		}
 	}
 }
diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
index 5185dc5daf80..b0ee307b5d4b 100644
--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -380,24 +380,26 @@ qla2xxx_get_fc4_priority(struct scsi_qla_host *vha)
 
 enum {
 	RESOURCE_NONE,
-	RESOURCE_INI,
+	RESOURCE_IOCB = BIT_0,
+	RESOURCE_EXCH = BIT_1,  /* exchange */
+	RESOURCE_FORCE = BIT_2,
 };
 
 static inline int
-qla_get_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
+qla_get_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
 {
 	u16 iocbs_used, i;
+	u16 exch_used;
 	struct qla_hw_data *ha = qp->vha->hw;
 
 	if (!ql2xenforce_iocb_limit) {
 		iores->res_type = RESOURCE_NONE;
 		return 0;
 	}
+	if (iores->res_type & RESOURCE_FORCE)
+		goto force;
 
-	if ((iores->iocb_cnt + qp->fwres.iocbs_used) < qp->fwres.iocbs_qp_limit) {
-		qp->fwres.iocbs_used += iores->iocb_cnt;
-		return 0;
-	} else {
+	if ((iores->iocb_cnt + qp->fwres.iocbs_used) >= qp->fwres.iocbs_qp_limit) {
 		/* no need to acquire qpair lock. It's just rough calculation */
 		iocbs_used = ha->base_qpair->fwres.iocbs_used;
 		for (i = 0; i < ha->max_qpairs; i++) {
@@ -405,30 +407,49 @@ qla_get_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
 				iocbs_used += ha->queue_pair_map[i]->fwres.iocbs_used;
 		}
 
-		if ((iores->iocb_cnt + iocbs_used) < qp->fwres.iocbs_limit) {
-			qp->fwres.iocbs_used += iores->iocb_cnt;
-			return 0;
-		} else {
+		if ((iores->iocb_cnt + iocbs_used) >= qp->fwres.iocbs_limit) {
+			iores->res_type = RESOURCE_NONE;
+			return -ENOSPC;
+		}
+	}
+
+	if (iores->res_type & RESOURCE_EXCH) {
+		exch_used = ha->base_qpair->fwres.exch_used;
+		for (i = 0; i < ha->max_qpairs; i++) {
+			if (ha->queue_pair_map[i])
+				exch_used += ha->queue_pair_map[i]->fwres.exch_used;
+		}
+
+		if ((exch_used + iores->exch_cnt) >= qp->fwres.exch_limit) {
 			iores->res_type = RESOURCE_NONE;
 			return -ENOSPC;
 		}
 	}
+force:
+	qp->fwres.iocbs_used += iores->iocb_cnt;
+	qp->fwres.exch_used += iores->exch_cnt;
+	return 0;
 }
 
 static inline void
-qla_put_iocbs(struct qla_qpair *qp, struct iocb_resource *iores)
+qla_put_fw_resources(struct qla_qpair *qp, struct iocb_resource *iores)
 {
-	switch (iores->res_type) {
-	case RESOURCE_NONE:
-		break;
-	default:
+	if (iores->res_type & RESOURCE_IOCB) {
 		if (qp->fwres.iocbs_used >= iores->iocb_cnt) {
 			qp->fwres.iocbs_used -= iores->iocb_cnt;
 		} else {
-			// should not happen
+			/* should not happen */
 			qp->fwres.iocbs_used = 0;
 		}
-		break;
+	}
+
+	if (iores->res_type & RESOURCE_EXCH) {
+		if (qp->fwres.exch_used >= iores->exch_cnt) {
+			qp->fwres.exch_used -= iores->exch_cnt;
+		} else {
+			/* should not happen */
+			qp->fwres.exch_used = 0;
+		}
 	}
 	iores->res_type = RESOURCE_NONE;
 }
diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 42ce4e1fe744..4f48f098ea5a 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1589,9 +1589,10 @@ qla24xx_start_scsi(srb_t *sp)
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 
-	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
 	sp->iores.iocb_cnt = req_cnt;
-	if (qla_get_iocbs(sp->qpair, &sp->iores))
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
@@ -1678,7 +1679,7 @@ qla24xx_start_scsi(srb_t *sp)
 	if (tot_dsds)
 		scsi_dma_unmap(cmd);
 
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
@@ -1793,9 +1794,10 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	tot_prot_dsds = nseg;
 	tot_dsds += nseg;
 
-	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
 	sp->iores.iocb_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
-	if (qla_get_iocbs(sp->qpair, &sp->iores))
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
@@ -1883,7 +1885,7 @@ qla24xx_dif_start_scsi(srb_t *sp)
 	}
 	/* Cleanup will be performed by the caller (queuecommand) */
 
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&ha->hardware_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
@@ -1952,9 +1954,10 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	tot_dsds = nseg;
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
 
-	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
 	sp->iores.iocb_cnt = req_cnt;
-	if (qla_get_iocbs(sp->qpair, &sp->iores))
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
@@ -2041,7 +2044,7 @@ qla2xxx_start_scsi_mq(srb_t *sp)
 	if (tot_dsds)
 		scsi_dma_unmap(cmd);
 
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
@@ -2171,9 +2174,10 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 	tot_prot_dsds = nseg;
 	tot_dsds += nseg;
 
-	sp->iores.res_type = RESOURCE_INI;
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
 	sp->iores.iocb_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
-	if (qla_get_iocbs(sp->qpair, &sp->iores))
+	if (qla_get_fw_resources(sp->qpair, &sp->iores))
 		goto queuing_error;
 
 	if (req->cnt < (req_cnt + 2)) {
@@ -2260,7 +2264,7 @@ qla2xxx_dif_start_scsi_mq(srb_t *sp)
 	}
 	/* Cleanup will be performed by the caller (queuecommand) */
 
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 
 	return QLA_FUNCTION_FAILED;
@@ -3813,6 +3817,65 @@ qla24xx_prlo_iocb(srb_t *sp, struct logio_entry_24xx *logio)
 	logio->vp_index = sp->fcport->vha->vp_idx;
 }
 
+int qla_get_iocbs_resource(struct srb *sp)
+{
+	bool get_exch;
+	bool push_it_through = false;
+
+	if (!ql2xenforce_iocb_limit) {
+		sp->iores.res_type = RESOURCE_NONE;
+		return 0;
+	}
+	sp->iores.res_type = RESOURCE_NONE;
+
+	switch (sp->type) {
+	case SRB_TM_CMD:
+	case SRB_PRLI_CMD:
+	case SRB_ADISC_CMD:
+		push_it_through = true;
+		fallthrough;
+	case SRB_LOGIN_CMD:
+	case SRB_ELS_CMD_RPT:
+	case SRB_ELS_CMD_HST:
+	case SRB_ELS_CMD_HST_NOLOGIN:
+	case SRB_CT_CMD:
+	case SRB_NVME_LS:
+	case SRB_ELS_DCMD:
+		get_exch = true;
+		break;
+
+	case SRB_FXIOCB_DCMD:
+	case SRB_FXIOCB_BCMD:
+		sp->iores.res_type = RESOURCE_NONE;
+		return 0;
+
+	case SRB_SA_UPDATE:
+	case SRB_SA_REPLACE:
+	case SRB_MB_IOCB:
+	case SRB_ABT_CMD:
+	case SRB_NACK_PLOGI:
+	case SRB_NACK_PRLI:
+	case SRB_NACK_LOGO:
+	case SRB_LOGOUT_CMD:
+	case SRB_CTRL_VP:
+		push_it_through = true;
+		fallthrough;
+	default:
+		get_exch = false;
+	}
+
+	sp->iores.res_type |= RESOURCE_IOCB;
+	sp->iores.iocb_cnt = 1;
+	if (get_exch) {
+		sp->iores.res_type |= RESOURCE_EXCH;
+		sp->iores.exch_cnt = 1;
+	}
+	if (push_it_through)
+		sp->iores.res_type |= RESOURCE_FORCE;
+
+	return qla_get_fw_resources(sp->qpair, &sp->iores);
+}
+
 int
 qla2x00_start_sp(srb_t *sp)
 {
@@ -3827,6 +3890,12 @@ qla2x00_start_sp(srb_t *sp)
 		return -EIO;
 
 	spin_lock_irqsave(qp->qp_lock_ptr, flags);
+	rval = qla_get_iocbs_resource(sp);
+	if (rval) {
+		spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
+		return -EAGAIN;
+	}
+
 	pkt = __qla2x00_alloc_iocbs(sp->qpair, sp);
 	if (!pkt) {
 		rval = EAGAIN;
@@ -3927,6 +3996,8 @@ qla2x00_start_sp(srb_t *sp)
 	wmb();
 	qla2x00_start_iocbs(vha, qp->req);
 done:
+	if (rval)
+		qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(qp->qp_lock_ptr, flags);
 	return rval;
 }
diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 59f5918dca95..e855d291db3c 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3099,6 +3099,7 @@ qla25xx_process_bidir_status_iocb(scsi_qla_host_t *vha, void *pkt,
 	}
 	bsg_reply->reply_payload_rcv_len = 0;
 
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 done:
 	/* Return the vendor specific reply to API */
 	bsg_reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
@@ -3184,7 +3185,7 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 		}
 		return;
 	}
-	qla_put_iocbs(sp->qpair, &sp->iores);
+	qla_put_fw_resources(sp->qpair, &sp->iores);
 
 	if (sp->cmd_type != TYPE_SRB) {
 		req->outstanding_cmds[handle] = NULL;
@@ -3349,8 +3350,6 @@ qla2x00_status_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, void *pkt)
 				       "Dropped frame(s) detected (0x%x of 0x%x bytes).\n",
 				       resid, scsi_bufflen(cp));
 
-				vha->interface_err_cnt++;
-
 				res = DID_ERROR << 16 | lscsi_status;
 				goto check_scsi_status;
 			}
@@ -3605,7 +3604,6 @@ qla2x00_error_entry(scsi_qla_host_t *vha, struct rsp_que *rsp, sts_entry_t *pkt)
 	default:
 		sp = qla2x00_get_sp_from_handle(vha, func, req, pkt);
 		if (sp) {
-			qla_put_iocbs(sp->qpair, &sp->iores);
 			sp->done(sp, res);
 			return 0;
 		}
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 3e167dc4eec7..98edab687c13 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -165,18 +165,6 @@ static void qla_nvme_release_fcp_cmd_kref(struct kref *kref)
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
@@ -194,7 +182,6 @@ static void qla_nvme_release_ls_cmd_kref(struct kref *kref)
 
 	fd = priv->fd;
 
-	qla_nvme_ls_unmap(sp, fd);
 	fd->done(fd, priv->comp_status);
 out:
 	qla2x00_rel_sp(sp);
@@ -360,13 +347,10 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
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
@@ -374,7 +358,6 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 		wake_up(&sp->nvme_ls_waitq);
 		sp->priv = NULL;
 		priv->sp = NULL;
-		qla_nvme_ls_unmap(sp, fd);
 		qla2x00_rel_sp(sp);
 		return rval;
 	}
@@ -438,13 +421,24 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 		goto queuing_error;
 	}
 	req_cnt = qla24xx_calc_iocbs(vha, tot_dsds);
+
+	sp->iores.res_type = RESOURCE_IOCB | RESOURCE_EXCH;
+	sp->iores.exch_cnt = 1;
+	sp->iores.iocb_cnt = req_cnt;
+	if (qla_get_fw_resources(sp->qpair, &sp->iores)) {
+		rval = -EBUSY;
+		goto queuing_error;
+	}
+
 	if (req->cnt < (req_cnt + 2)) {
 		if (IS_SHADOW_REG_CAPABLE(ha)) {
 			cnt = *req->out_ptr;
 		} else {
 			cnt = rd_reg_dword_relaxed(req->req_q_out);
-			if (qla2x00_check_reg16_for_disconnect(vha, cnt))
+			if (qla2x00_check_reg16_for_disconnect(vha, cnt)) {
+				rval = -EBUSY;
 				goto queuing_error;
+			}
 		}
 
 		if (req->ring_index < cnt)
@@ -589,6 +583,8 @@ static inline int qla2x00_start_nvme_mq(srb_t *sp)
 	wrt_reg_dword(req->req_q_in, req->ring_index);
 
 queuing_error:
+	if (rval)
+		qla_put_fw_resources(sp->qpair, &sp->iores);
 	spin_unlock_irqrestore(&qpair->qp_lock, flags);
 
 	return rval;
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 05d827227d0b..330f34c8724f 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -7069,9 +7069,12 @@ qla2x00_do_dpc(void *data)
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
 
@@ -7422,7 +7425,7 @@ qla2x00_timer(struct timer_list *t)
 
 		/* if the loop has been down for 4 minutes, reinit adapter */
 		if (atomic_dec_and_test(&vha->loop_down_timer) != 0) {
-			if (!(vha->device_flags & DFLG_NO_CABLE)) {
+			if (!(vha->device_flags & DFLG_NO_CABLE) && !vha->vp_idx) {
 				ql_log(ql_log_warn, vha, 0x6009,
 				    "Loop down - aborting ISP.\n");
 
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
diff --git a/drivers/scsi/snic/snic_debugfs.c b/drivers/scsi/snic/snic_debugfs.c
index 5e0faeba516e..76baa4f9a06e 100644
--- a/drivers/scsi/snic/snic_debugfs.c
+++ b/drivers/scsi/snic/snic_debugfs.c
@@ -451,6 +451,6 @@ void snic_trc_debugfs_init(void)
 void
 snic_trc_debugfs_term(void)
 {
-	debugfs_remove(debugfs_lookup(TRC_FILE, snic_glob->trc_root));
-	debugfs_remove(debugfs_lookup(TRC_ENABLE_FILE, snic_glob->trc_root));
+	debugfs_lookup_and_remove(TRC_FILE, snic_glob->trc_root);
+	debugfs_lookup_and_remove(TRC_ENABLE_FILE, snic_glob->trc_root);
 }
diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index 18d2f9b3e201..0339e6df6eb7 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -127,7 +127,8 @@ MODULE_PARM_DESC(cdns_mcp_int_mask, "Cadence MCP IntMask");
 
 #define CDNS_MCP_CMD_BASE			0x80
 #define CDNS_MCP_RESP_BASE			0x80
-#define CDNS_MCP_CMD_LEN			0x20
+/* FIFO can hold 8 commands */
+#define CDNS_MCP_CMD_LEN			8
 #define CDNS_MCP_CMD_WORD_LEN			0x4
 
 #define CDNS_MCP_CMD_SSP_TAG			BIT(31)
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index 83e352b0c8f9..4fc23236d3bd 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -272,7 +272,6 @@ config SPI_DW_BT1
 	tristate "Baikal-T1 SPI driver for DW SPI core"
 	depends on MIPS_BAIKAL_T1 || COMPILE_TEST
 	select MULTIPLEXER
-	select MUX_MMIO
 	help
 	  Baikal-T1 SoC is equipped with three DW APB SSI-based MMIO SPI
 	  controllers. Two of them are pretty much normal: with IRQ, DMA,
diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index b871fd810d80..02f56fc001b4 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -163,6 +163,7 @@ static int bcm63xx_hsspi_do_txrx(struct spi_device *spi, struct spi_transfer *t)
 	int step_size = HSSPI_BUFFER_LEN;
 	const u8 *tx = t->tx_buf;
 	u8 *rx = t->rx_buf;
+	u32 val = 0;
 
 	bcm63xx_hsspi_set_clk(bs, spi, t->speed_hz);
 	bcm63xx_hsspi_set_cs(bs, spi->chip_select, true);
@@ -178,11 +179,16 @@ static int bcm63xx_hsspi_do_txrx(struct spi_device *spi, struct spi_transfer *t)
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
diff --git a/drivers/spi/spi-synquacer.c b/drivers/spi/spi-synquacer.c
index 47cbe73137c2..dc188f9202c9 100644
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
diff --git a/drivers/thermal/hisi_thermal.c b/drivers/thermal/hisi_thermal.c
index 9a21ac0ceb11..29ff1e66dd6e 100644
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
 
diff --git a/drivers/thermal/intel/intel_pch_thermal.c b/drivers/thermal/intel/intel_pch_thermal.c
index 527c91f5960b..768c66046a59 100644
--- a/drivers/thermal/intel/intel_pch_thermal.c
+++ b/drivers/thermal/intel/intel_pch_thermal.c
@@ -29,6 +29,7 @@
 #define PCH_THERMAL_DID_CNL_LP	0x02F9 /* CNL-LP PCH */
 #define PCH_THERMAL_DID_CML_H	0X06F9 /* CML-H PCH */
 #define PCH_THERMAL_DID_LWB	0xA1B1 /* Lewisburg PCH */
+#define PCH_THERMAL_DID_WBG	0x8D24 /* Wellsburg PCH */
 
 /* Wildcat Point-LP  PCH Thermal registers */
 #define WPT_TEMP	0x0000	/* Temperature */
@@ -345,6 +346,7 @@ enum board_ids {
 	board_cnl,
 	board_cml,
 	board_lwb,
+	board_wbg,
 };
 
 static const struct board_info {
@@ -375,6 +377,10 @@ static const struct board_info {
 		.name = "pch_lewisburg",
 		.ops = &pch_dev_ops_wpt,
 	},
+	[board_wbg] = {
+		.name = "pch_wellsburg",
+		.ops = &pch_dev_ops_wpt,
+	},
 };
 
 static int intel_pch_thermal_probe(struct pci_dev *pdev,
@@ -490,6 +496,8 @@ static const struct pci_device_id intel_pch_thermal_id[] = {
 		.driver_data = board_cml, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCH_THERMAL_DID_LWB),
 		.driver_data = board_lwb, },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCH_THERMAL_DID_WBG),
+		.driver_data = board_wbg, },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, intel_pch_thermal_id);
diff --git a/drivers/thermal/intel/intel_powerclamp.c b/drivers/thermal/intel/intel_powerclamp.c
index 5b19e2d46043..08ea6cdb25b8 100644
--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -57,6 +57,7 @@
 
 static unsigned int target_mwait;
 static struct dentry *debug_dir;
+static bool poll_pkg_cstate_enable;
 
 /* user selected target */
 static unsigned int set_target_ratio;
@@ -262,6 +263,9 @@ static unsigned int get_compensation(int ratio)
 {
 	unsigned int comp = 0;
 
+	if (!poll_pkg_cstate_enable)
+		return 0;
+
 	/* we only use compensation if all adjacent ones are good */
 	if (ratio == 1 &&
 		cal_data[ratio].confidence >= CONFIDENCE_OK &&
@@ -534,7 +538,8 @@ static int start_power_clamp(void)
 	control_cpu = cpumask_first(cpu_online_mask);
 
 	clamping = true;
-	schedule_delayed_work(&poll_pkg_cstate_work, 0);
+	if (poll_pkg_cstate_enable)
+		schedule_delayed_work(&poll_pkg_cstate_work, 0);
 
 	/* start one kthread worker per online cpu */
 	for_each_online_cpu(cpu) {
@@ -603,11 +608,15 @@ static int powerclamp_get_max_state(struct thermal_cooling_device *cdev,
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
@@ -732,6 +741,9 @@ static int __init powerclamp_init(void)
 		goto exit_unregister;
 	}
 
+	if (topology_max_packages() == 1 && topology_max_die_per_package() == 1)
+		poll_pkg_cstate_enable = true;
+
 	cooling_dev = thermal_cooling_device_register("intel_powerclamp", NULL,
 						&powerclamp_cooling_ops);
 	if (IS_ERR(cooling_dev)) {
diff --git a/drivers/thermal/intel/intel_soc_dts_iosf.c b/drivers/thermal/intel/intel_soc_dts_iosf.c
index 342b0bb5a56d..8651ff1abe75 100644
--- a/drivers/thermal/intel/intel_soc_dts_iosf.c
+++ b/drivers/thermal/intel/intel_soc_dts_iosf.c
@@ -405,7 +405,7 @@ struct intel_soc_dts_sensors *intel_soc_dts_iosf_init(
 {
 	struct intel_soc_dts_sensors *sensors;
 	bool notification;
-	u32 tj_max;
+	int tj_max;
 	int ret;
 	int i;
 
diff --git a/drivers/thermal/qcom/tsens-v0_1.c b/drivers/thermal/qcom/tsens-v0_1.c
index 327f37202c69..8d036727b99f 100644
--- a/drivers/thermal/qcom/tsens-v0_1.c
+++ b/drivers/thermal/qcom/tsens-v0_1.c
@@ -285,7 +285,7 @@ static int calibrate_8939(struct tsens_priv *priv)
 	u32 p1[10], p2[10];
 	int mode = 0;
 	u32 *qfprom_cdata;
-	u32 cdata[6];
+	u32 cdata[4];
 
 	qfprom_cdata = (u32 *)qfprom_read(priv->dev, "calib");
 	if (IS_ERR(qfprom_cdata))
@@ -296,8 +296,6 @@ static int calibrate_8939(struct tsens_priv *priv)
 	cdata[1] = qfprom_cdata[13];
 	cdata[2] = qfprom_cdata[0];
 	cdata[3] = qfprom_cdata[1];
-	cdata[4] = qfprom_cdata[22];
-	cdata[5] = qfprom_cdata[21];
 
 	mode = (cdata[0] & MSM8939_CAL_SEL_MASK) >> MSM8939_CAL_SEL_SHIFT;
 	dev_dbg(priv->dev, "calibration mode is %d\n", mode);
@@ -314,8 +312,6 @@ static int calibrate_8939(struct tsens_priv *priv)
 		p2[6] = (cdata[2] & MSM8939_S6_P2_MASK) >> MSM8939_S6_P2_SHIFT;
 		p2[7] = (cdata[3] & MSM8939_S7_P2_MASK) >> MSM8939_S7_P2_SHIFT;
 		p2[8] = (cdata[3] & MSM8939_S8_P2_MASK) >> MSM8939_S8_P2_SHIFT;
-		p2[9] = (cdata[4] & MSM8939_S9_P2_MASK_0_4) >> MSM8939_S9_P2_SHIFT_0_4;
-		p2[9] |= ((cdata[5] & MSM8939_S9_P2_MASK_5) >> MSM8939_S9_P2_SHIFT_5) << 5;
 		for (i = 0; i < priv->num_sensors; i++)
 			p2[i] = (base1 + p2[i]) << 2;
 		fallthrough;
@@ -331,7 +327,6 @@ static int calibrate_8939(struct tsens_priv *priv)
 		p1[6] = (cdata[2] & MSM8939_S6_P1_MASK) >> MSM8939_S6_P1_SHIFT;
 		p1[7] = (cdata[3] & MSM8939_S7_P1_MASK) >> MSM8939_S7_P1_SHIFT;
 		p1[8] = (cdata[3] & MSM8939_S8_P1_MASK) >> MSM8939_S8_P1_SHIFT;
-		p1[9] = (cdata[4] & MSM8939_S9_P1_MASK) >> MSM8939_S9_P1_SHIFT;
 		for (i = 0; i < priv->num_sensors; i++)
 			p1[i] = ((base0) + p1[i]) << 2;
 		break;
@@ -534,6 +529,21 @@ static int calibrate_9607(struct tsens_priv *priv)
 	return 0;
 }
 
+static int __init init_8939(struct tsens_priv *priv) {
+	priv->sensor[0].slope = 2911;
+	priv->sensor[1].slope = 2789;
+	priv->sensor[2].slope = 2906;
+	priv->sensor[3].slope = 2763;
+	priv->sensor[4].slope = 2922;
+	priv->sensor[5].slope = 2867;
+	priv->sensor[6].slope = 2833;
+	priv->sensor[7].slope = 2838;
+	priv->sensor[8].slope = 2840;
+	/* priv->sensor[9].slope = 2852; */
+
+	return init_common(priv);
+}
+
 /* v0.1: 8916, 8939, 8974, 9607 */
 
 static struct tsens_features tsens_v0_1_feat = {
@@ -596,15 +606,15 @@ struct tsens_plat_data data_8916 = {
 };
 
 static const struct tsens_ops ops_8939 = {
-	.init		= init_common,
+	.init		= init_8939,
 	.calibrate	= calibrate_8939,
 	.get_temp	= get_temp_common,
 };
 
 struct tsens_plat_data data_8939 = {
-	.num_sensors	= 10,
+	.num_sensors	= 9,
 	.ops		= &ops_8939,
-	.hw_ids		= (unsigned int []){ 0, 1, 2, 3, 5, 6, 7, 8, 9, 10 },
+	.hw_ids		= (unsigned int []){ 0, 1, 2, 3, 5, 6, 7, 8, 9, /* 10 */ },
 
 	.feat		= &tsens_v0_1_feat,
 	.fields	= tsens_v0_1_regfields,
diff --git a/drivers/thermal/qcom/tsens-v1.c b/drivers/thermal/qcom/tsens-v1.c
index 573e261ccca7..faa4576fa028 100644
--- a/drivers/thermal/qcom/tsens-v1.c
+++ b/drivers/thermal/qcom/tsens-v1.c
@@ -78,11 +78,6 @@
 
 #define MSM8976_CAL_SEL_MASK	0x3
 
-#define MSM8976_CAL_DEGC_PT1	30
-#define MSM8976_CAL_DEGC_PT2	120
-#define MSM8976_SLOPE_FACTOR	1000
-#define MSM8976_SLOPE_DEFAULT	3200
-
 /* eeprom layout data for qcs404/405 (v1) */
 #define BASE0_MASK	0x000007f8
 #define BASE1_MASK	0x0007f800
@@ -142,30 +137,6 @@
 #define CAL_SEL_MASK	7
 #define CAL_SEL_SHIFT	0
 
-static void compute_intercept_slope_8976(struct tsens_priv *priv,
-			      u32 *p1, u32 *p2, u32 mode)
-{
-	int i;
-
-	priv->sensor[0].slope = 3313;
-	priv->sensor[1].slope = 3275;
-	priv->sensor[2].slope = 3320;
-	priv->sensor[3].slope = 3246;
-	priv->sensor[4].slope = 3279;
-	priv->sensor[5].slope = 3257;
-	priv->sensor[6].slope = 3234;
-	priv->sensor[7].slope = 3269;
-	priv->sensor[8].slope = 3255;
-	priv->sensor[9].slope = 3239;
-	priv->sensor[10].slope = 3286;
-
-	for (i = 0; i < priv->num_sensors; i++) {
-		priv->sensor[i].offset = (p1[i] * MSM8976_SLOPE_FACTOR) -
-				(MSM8976_CAL_DEGC_PT1 *
-				priv->sensor[i].slope);
-	}
-}
-
 static int calibrate_v1(struct tsens_priv *priv)
 {
 	u32 base0 = 0, base1 = 0;
@@ -291,7 +262,7 @@ static int calibrate_8976(struct tsens_priv *priv)
 		break;
 	}
 
-	compute_intercept_slope_8976(priv, p1, p2, mode);
+	compute_intercept_slope(priv, p1, p2, mode);
 	kfree(qfprom_cdata);
 
 	return 0;
@@ -362,6 +333,22 @@ static const struct reg_field tsens_v1_regfields[MAX_REGFIELDS] = {
 	[TRDY] = REG_FIELD(TM_TRDY_OFF, 0, 0),
 };
 
+static int __init init_8956(struct tsens_priv *priv) {
+	priv->sensor[0].slope = 3313;
+	priv->sensor[1].slope = 3275;
+	priv->sensor[2].slope = 3320;
+	priv->sensor[3].slope = 3246;
+	priv->sensor[4].slope = 3279;
+	priv->sensor[5].slope = 3257;
+	priv->sensor[6].slope = 3234;
+	priv->sensor[7].slope = 3269;
+	priv->sensor[8].slope = 3255;
+	priv->sensor[9].slope = 3239;
+	priv->sensor[10].slope = 3286;
+
+	return init_common(priv);
+}
+
 static const struct tsens_ops ops_generic_v1 = {
 	.init		= init_common,
 	.calibrate	= calibrate_v1,
@@ -374,13 +361,25 @@ struct tsens_plat_data data_tsens_v1 = {
 	.fields	= tsens_v1_regfields,
 };
 
+static const struct tsens_ops ops_8956 = {
+	.init		= init_8956,
+	.calibrate	= calibrate_8976,
+	.get_temp	= get_temp_tsens_valid,
+};
+
+struct tsens_plat_data data_8956 = {
+	.num_sensors	= 11,
+	.ops		= &ops_8956,
+	.feat		= &tsens_v1_feat,
+	.fields		= tsens_v1_regfields,
+};
+
 static const struct tsens_ops ops_8976 = {
 	.init		= init_common,
 	.calibrate	= calibrate_8976,
 	.get_temp	= get_temp_tsens_valid,
 };
 
-/* Valid for both MSM8956 and MSM8976. */
 struct tsens_plat_data data_8976 = {
 	.num_sensors	= 11,
 	.ops		= &ops_8976,
diff --git a/drivers/thermal/qcom/tsens.c b/drivers/thermal/qcom/tsens.c
index 99a8d9f3e03c..926cd8b41132 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -978,6 +978,12 @@ static const struct of_device_id tsens_table[] = {
 	}, {
 		.compatible = "qcom,msm8939-tsens",
 		.data = &data_8939,
+	}, {
+		.compatible = "qcom,msm8956-tsens",
+		.data = &data_8956,
+	}, {
+		.compatible = "qcom,msm8960-tsens",
+		.data = &data_8960,
 	}, {
 		.compatible = "qcom,msm8974-tsens",
 		.data = &data_8974,
diff --git a/drivers/thermal/qcom/tsens.h b/drivers/thermal/qcom/tsens.h
index 1471a2c00f15..c2e5aee15927 100644
--- a/drivers/thermal/qcom/tsens.h
+++ b/drivers/thermal/qcom/tsens.h
@@ -590,7 +590,7 @@ extern struct tsens_plat_data data_8960;
 extern struct tsens_plat_data data_8916, data_8939, data_8974, data_9607;
 
 /* TSENS v1 targets */
-extern struct tsens_plat_data data_tsens_v1, data_8976;
+extern struct tsens_plat_data data_tsens_v1, data_8976, data_8956;
 
 /* TSENS v2 targets */
 extern struct tsens_plat_data data_8996, data_tsens_v2;
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index fc311df9f1c9..f4d9dc4648da 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1406,9 +1406,9 @@ static int lpuart32_config_rs485(struct uart_port *port,
 		 * Note: UART is assumed to be active high.
 		 */
 		if (rs485->flags & SER_RS485_RTS_ON_SEND)
-			modem &= ~UARTMODEM_TXRTSPOL;
-		else if (rs485->flags & SER_RS485_RTS_AFTER_SEND)
 			modem |= UARTMODEM_TXRTSPOL;
+		else if (rs485->flags & SER_RS485_RTS_AFTER_SEND)
+			modem &= ~UARTMODEM_TXRTSPOL;
 	}
 
 	/* Store the new configuration */
@@ -1700,12 +1700,6 @@ static void lpuart32_configure(struct lpuart_port *sport)
 {
 	unsigned long temp;
 
-	if (sport->lpuart_dma_rx_use) {
-		/* RXWATER must be 0 */
-		temp = lpuart32_read(&sport->port, UARTWATER);
-		temp &= ~(UARTWATER_WATER_MASK << UARTWATER_RXWATER_OFF);
-		lpuart32_write(&sport->port, temp, UARTWATER);
-	}
 	temp = lpuart32_read(&sport->port, UARTCTRL);
 	if (!sport->lpuart_dma_rx_use)
 		temp |= UARTCTRL_RIE;
@@ -1807,6 +1801,15 @@ static void lpuart32_shutdown(struct uart_port *port)
 
 	spin_lock_irqsave(&port->lock, flags);
 
+	/* clear status */
+	temp = lpuart32_read(&sport->port, UARTSTAT);
+	lpuart32_write(&sport->port, temp, UARTSTAT);
+
+	/* disable Rx/Tx DMA */
+	temp = lpuart32_read(port, UARTBAUD);
+	temp &= ~(UARTBAUD_TDMAE | UARTBAUD_RDMAE);
+	lpuart32_write(port, temp, UARTBAUD);
+
 	/* disable Rx/Tx and interrupts */
 	temp = lpuart32_read(port, UARTCTRL);
 	temp &= ~(UARTCTRL_TE | UARTCTRL_RE |
diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
index 711edb835c27..77a4f4af3b8d 100644
--- a/drivers/tty/serial/imx.c
+++ b/drivers/tty/serial/imx.c
@@ -484,7 +484,7 @@ static void imx_uart_stop_tx(struct uart_port *port)
 static void imx_uart_stop_rx(struct uart_port *port)
 {
 	struct imx_port *sport = (struct imx_port *)port;
-	u32 ucr1, ucr2, ucr4;
+	u32 ucr1, ucr2, ucr4, uts;
 
 	ucr1 = imx_uart_readl(sport, UCR1);
 	ucr2 = imx_uart_readl(sport, UCR2);
@@ -500,7 +500,18 @@ static void imx_uart_stop_rx(struct uart_port *port)
 	imx_uart_writel(sport, ucr1, UCR1);
 	imx_uart_writel(sport, ucr4, UCR4);
 
-	ucr2 &= ~UCR2_RXEN;
+	/* See SER_RS485_ENABLED/UTS_LOOP comment in imx_uart_probe() */
+	if (port->rs485.flags & SER_RS485_ENABLED &&
+	    port->rs485.flags & SER_RS485_RTS_ON_SEND &&
+	    sport->have_rtscts && !sport->have_rtsgpio) {
+		uts = imx_uart_readl(sport, imx_uart_uts_reg(sport));
+		uts |= UTS_LOOP;
+		imx_uart_writel(sport, uts, imx_uart_uts_reg(sport));
+		ucr2 |= UCR2_RXEN;
+	} else {
+		ucr2 &= ~UCR2_RXEN;
+	}
+
 	imx_uart_writel(sport, ucr2, UCR2);
 }
 
@@ -1383,7 +1394,7 @@ static int imx_uart_startup(struct uart_port *port)
 	int retval, i;
 	unsigned long flags;
 	int dma_is_inited = 0;
-	u32 ucr1, ucr2, ucr3, ucr4;
+	u32 ucr1, ucr2, ucr3, ucr4, uts;
 
 	retval = clk_prepare_enable(sport->clk_per);
 	if (retval)
@@ -1488,6 +1499,11 @@ static int imx_uart_startup(struct uart_port *port)
 		imx_uart_writel(sport, ucr2, UCR2);
 	}
 
+	/* See SER_RS485_ENABLED/UTS_LOOP comment in imx_uart_probe() */
+	uts = imx_uart_readl(sport, imx_uart_uts_reg(sport));
+	uts &= ~UTS_LOOP;
+	imx_uart_writel(sport, uts, imx_uart_uts_reg(sport));
+
 	spin_unlock_irqrestore(&sport->port.lock, flags);
 
 	return 0;
@@ -1497,7 +1513,7 @@ static void imx_uart_shutdown(struct uart_port *port)
 {
 	struct imx_port *sport = (struct imx_port *)port;
 	unsigned long flags;
-	u32 ucr1, ucr2, ucr4;
+	u32 ucr1, ucr2, ucr4, uts;
 
 	if (sport->dma_is_enabled) {
 		dmaengine_terminate_sync(sport->dma_chan_tx);
@@ -1541,7 +1557,18 @@ static void imx_uart_shutdown(struct uart_port *port)
 	spin_lock_irqsave(&sport->port.lock, flags);
 
 	ucr1 = imx_uart_readl(sport, UCR1);
-	ucr1 &= ~(UCR1_TRDYEN | UCR1_RRDYEN | UCR1_RTSDEN | UCR1_UARTEN | UCR1_RXDMAEN | UCR1_ATDMAEN);
+	ucr1 &= ~(UCR1_TRDYEN | UCR1_RRDYEN | UCR1_RTSDEN | UCR1_RXDMAEN | UCR1_ATDMAEN);
+	/* See SER_RS485_ENABLED/UTS_LOOP comment in imx_uart_probe() */
+	if (port->rs485.flags & SER_RS485_ENABLED &&
+	    port->rs485.flags & SER_RS485_RTS_ON_SEND &&
+	    sport->have_rtscts && !sport->have_rtsgpio) {
+		uts = imx_uart_readl(sport, imx_uart_uts_reg(sport));
+		uts |= UTS_LOOP;
+		imx_uart_writel(sport, uts, imx_uart_uts_reg(sport));
+		ucr1 |= UCR1_UARTEN;
+	} else {
+		ucr1 &= ~UCR1_UARTEN;
+	}
 	imx_uart_writel(sport, ucr1, UCR1);
 
 	ucr4 = imx_uart_readl(sport, UCR4);
@@ -2189,7 +2216,7 @@ static int imx_uart_probe(struct platform_device *pdev)
 	void __iomem *base;
 	u32 dma_buf_conf[2];
 	int ret = 0;
-	u32 ucr1;
+	u32 ucr1, ucr2, uts;
 	struct resource *res;
 	int txirq, rxirq, rtsirq;
 
@@ -2321,6 +2348,36 @@ static int imx_uart_probe(struct platform_device *pdev)
 	ucr1 &= ~(UCR1_ADEN | UCR1_TRDYEN | UCR1_IDEN | UCR1_RRDYEN | UCR1_RTSDEN);
 	imx_uart_writel(sport, ucr1, UCR1);
 
+	/* Disable Ageing Timer interrupt */
+	ucr2 = imx_uart_readl(sport, UCR2);
+	ucr2 &= ~UCR2_ATEN;
+	imx_uart_writel(sport, ucr2, UCR2);
+
+	/*
+	 * In case RS485 is enabled without GPIO RTS control, the UART IP
+	 * is used to control CTS signal. Keep both the UART and Receiver
+	 * enabled, otherwise the UART IP pulls CTS signal always HIGH no
+	 * matter how the UCR2 CTSC and CTS bits are set. To prevent any
+	 * data from being fed into the RX FIFO, enable loopback mode in
+	 * UTS register, which disconnects the RX path from external RXD
+	 * pin and connects it to the Transceiver, which is disabled, so
+	 * no data can be fed to the RX FIFO that way.
+	 */
+	if (sport->port.rs485.flags & SER_RS485_ENABLED &&
+	    sport->have_rtscts && !sport->have_rtsgpio) {
+		uts = imx_uart_readl(sport, imx_uart_uts_reg(sport));
+		uts |= UTS_LOOP;
+		imx_uart_writel(sport, uts, imx_uart_uts_reg(sport));
+
+		ucr1 = imx_uart_readl(sport, UCR1);
+		ucr1 |= UCR1_UARTEN;
+		imx_uart_writel(sport, ucr1, UCR1);
+
+		ucr2 = imx_uart_readl(sport, UCR2);
+		ucr2 |= UCR2_RXEN;
+		imx_uart_writel(sport, ucr2, UCR2);
+	}
+
 	if (!imx_uart_is_imx1(sport) && sport->dte_mode) {
 		/*
 		 * The DCEDTE bit changes the direction of DSR, DCD, DTR and RI
diff --git a/drivers/tty/serial/serial-tegra.c b/drivers/tty/serial/serial-tegra.c
index 79187ff9ac13..25f34f86a085 100644
--- a/drivers/tty/serial/serial-tegra.c
+++ b/drivers/tty/serial/serial-tegra.c
@@ -1047,6 +1047,7 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 	if (tup->cdata->fifo_mode_enable_status) {
 		ret = tegra_uart_wait_fifo_mode_enabled(tup);
 		if (ret < 0) {
+			clk_disable_unprepare(tup->uart_clk);
 			dev_err(tup->uport.dev,
 				"Failed to enable FIFO mode: %d\n", ret);
 			return ret;
@@ -1068,6 +1069,7 @@ static int tegra_uart_hw_init(struct tegra_uart_port *tup)
 	 */
 	ret = tegra_set_baudrate(tup, TEGRA_UART_DEFAULT_BAUD);
 	if (ret < 0) {
+		clk_disable_unprepare(tup->uart_clk);
 		dev_err(tup->uport.dev, "Failed to set baud rate\n");
 		return ret;
 	}
@@ -1227,10 +1229,13 @@ static int tegra_uart_startup(struct uart_port *u)
 				dev_name(u->dev), tup);
 	if (ret < 0) {
 		dev_err(u->dev, "Failed to register ISR for IRQ %d\n", u->irq);
-		goto fail_hw_init;
+		goto fail_request_irq;
 	}
 	return 0;
 
+fail_request_irq:
+	/* tup->uart_clk is already enabled in tegra_uart_hw_init */
+	clk_disable_unprepare(tup->uart_clk);
 fail_hw_init:
 	if (!tup->use_rx_pio)
 		tegra_uart_dma_channel_free(tup, true);
diff --git a/drivers/usb/early/xhci-dbc.c b/drivers/usb/early/xhci-dbc.c
index 6c0434100e38..b0c4071f0b16 100644
--- a/drivers/usb/early/xhci-dbc.c
+++ b/drivers/usb/early/xhci-dbc.c
@@ -871,7 +871,8 @@ static int xdbc_bulk_write(const char *bytes, int size)
 
 static void early_xdbc_write(struct console *con, const char *str, u32 n)
 {
-	static char buf[XDBC_MAX_PACKET];
+	/* static variables are zeroed, so buf is always NULL terminated */
+	static char buf[XDBC_MAX_PACKET + 1];
 	int chunk, ret;
 	int use_cr = 0;
 
diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 5ade844db404..5cbf4084daed 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -416,10 +416,9 @@ static int config_usb_cfg_link(
 	struct usb_composite_dev *cdev = cfg->c.cdev;
 	struct gadget_info *gi = container_of(cdev, struct gadget_info, cdev);
 
-	struct config_group *group = to_config_group(usb_func_ci);
-	struct usb_function_instance *fi = container_of(group,
-			struct usb_function_instance, group);
-	struct usb_function_instance *a_fi;
+	struct usb_function_instance *fi =
+			to_usb_function_instance(usb_func_ci);
+	struct usb_function_instance *a_fi = NULL, *iter;
 	struct usb_function *f;
 	int ret;
 
@@ -429,11 +428,19 @@ static int config_usb_cfg_link(
 	 * from another gadget or a random directory.
 	 * Also a function instance can only be linked once.
 	 */
-	list_for_each_entry(a_fi, &gi->available_func, cfs_list) {
-		if (a_fi == fi)
-			break;
+
+	if (gi->composite.gadget_driver.udc_name) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	list_for_each_entry(iter, &gi->available_func, cfs_list) {
+		if (iter != fi)
+			continue;
+		a_fi = iter;
+		break;
 	}
-	if (a_fi != fi) {
+	if (!a_fi) {
 		ret = -EINVAL;
 		goto out;
 	}
@@ -467,9 +474,8 @@ static void config_usb_cfg_unlink(
 	struct usb_composite_dev *cdev = cfg->c.cdev;
 	struct gadget_info *gi = container_of(cdev, struct gadget_info, cdev);
 
-	struct config_group *group = to_config_group(usb_func_ci);
-	struct usb_function_instance *fi = container_of(group,
-			struct usb_function_instance, group);
+	struct usb_function_instance *fi =
+			to_usb_function_instance(usb_func_ci);
 	struct usb_function *f;
 
 	/*
@@ -890,18 +896,18 @@ static int os_desc_link(struct config_item *os_desc_ci,
 	struct gadget_info *gi = container_of(to_config_group(os_desc_ci),
 					struct gadget_info, os_desc_group);
 	struct usb_composite_dev *cdev = &gi->cdev;
-	struct config_usb_cfg *c_target =
-		container_of(to_config_group(usb_cfg_ci),
-			     struct config_usb_cfg, group);
-	struct usb_configuration *c;
+	struct config_usb_cfg *c_target = to_config_usb_cfg(usb_cfg_ci);
+	struct usb_configuration *c = NULL, *iter;
 	int ret;
 
 	mutex_lock(&gi->lock);
-	list_for_each_entry(c, &cdev->configs, list) {
-		if (c == &c_target->c)
-			break;
+	list_for_each_entry(iter, &cdev->configs, list) {
+		if (iter != &c_target->c)
+			continue;
+		c = iter;
+		break;
 	}
-	if (c != &c_target->c) {
+	if (!c) {
 		ret = -EINVAL;
 		goto out;
 	}
diff --git a/drivers/usb/gadget/udc/fotg210-udc.c b/drivers/usb/gadget/udc/fotg210-udc.c
index d0e051beb3af..6f7ade156437 100644
--- a/drivers/usb/gadget/udc/fotg210-udc.c
+++ b/drivers/usb/gadget/udc/fotg210-udc.c
@@ -706,6 +706,20 @@ static int fotg210_is_epnstall(struct fotg210_ep *ep)
 	return value & INOUTEPMPSR_STL_EP ? 1 : 0;
 }
 
+/* For EP0 requests triggered by this driver (currently GET_STATUS response) */
+static void fotg210_ep0_complete(struct usb_ep *_ep, struct usb_request *req)
+{
+	struct fotg210_ep *ep;
+	struct fotg210_udc *fotg210;
+
+	ep = container_of(_ep, struct fotg210_ep, ep);
+	fotg210 = ep->fotg210;
+
+	if (req->status || req->actual != req->length) {
+		dev_warn(&fotg210->gadget.dev, "EP0 request failed: %d\n", req->status);
+	}
+}
+
 static void fotg210_get_status(struct fotg210_udc *fotg210,
 				struct usb_ctrlrequest *ctrl)
 {
@@ -1172,6 +1186,8 @@ static int fotg210_udc_probe(struct platform_device *pdev)
 	if (fotg210->ep0_req == NULL)
 		goto err_map;
 
+	fotg210->ep0_req->complete = fotg210_ep0_complete;
+
 	fotg210_init(fotg210);
 
 	fotg210_disable_unplug(fotg210);
diff --git a/drivers/usb/gadget/udc/fusb300_udc.c b/drivers/usb/gadget/udc/fusb300_udc.c
index 9af8b415f303..5e9e8e56e2d0 100644
--- a/drivers/usb/gadget/udc/fusb300_udc.c
+++ b/drivers/usb/gadget/udc/fusb300_udc.c
@@ -1347,6 +1347,7 @@ static int fusb300_remove(struct platform_device *pdev)
 	usb_del_gadget_udc(&fusb300->gadget);
 	iounmap(fusb300->reg);
 	free_irq(platform_get_irq(pdev, 0), fusb300);
+	free_irq(platform_get_irq(pdev, 1), fusb300);
 
 	fusb300_free_request(&fusb300->ep[0]->ep, fusb300->ep0_req);
 	for (i = 0; i < FUSB300_MAX_NUM_EP; i++)
@@ -1432,7 +1433,7 @@ static int fusb300_probe(struct platform_device *pdev)
 			IRQF_SHARED, udc_name, fusb300);
 	if (ret < 0) {
 		pr_err("request_irq1 error (%d)\n", ret);
-		goto clean_up;
+		goto err_request_irq1;
 	}
 
 	INIT_LIST_HEAD(&fusb300->gadget.ep_list);
@@ -1471,7 +1472,7 @@ static int fusb300_probe(struct platform_device *pdev)
 				GFP_KERNEL);
 	if (fusb300->ep0_req == NULL) {
 		ret = -ENOMEM;
-		goto clean_up3;
+		goto err_alloc_request;
 	}
 
 	init_controller(fusb300);
@@ -1486,7 +1487,10 @@ static int fusb300_probe(struct platform_device *pdev)
 err_add_udc:
 	fusb300_free_request(&fusb300->ep[0]->ep, fusb300->ep0_req);
 
-clean_up3:
+err_alloc_request:
+	free_irq(ires1->start, fusb300);
+
+err_request_irq1:
 	free_irq(ires->start, fusb300);
 
 clean_up:
diff --git a/drivers/usb/host/max3421-hcd.c b/drivers/usb/host/max3421-hcd.c
index 30de85a707fe..994dc562b2db 100644
--- a/drivers/usb/host/max3421-hcd.c
+++ b/drivers/usb/host/max3421-hcd.c
@@ -1436,7 +1436,7 @@ max3421_spi_thread(void *dev_id)
 			 * use spi_wr_buf().
 			 */
 			for (i = 0; i < ARRAY_SIZE(max3421_hcd->iopins); ++i) {
-				u8 val = spi_rd8(hcd, MAX3421_REG_IOPINS1);
+				u8 val = spi_rd8(hcd, MAX3421_REG_IOPINS1 + i);
 
 				val = ((val & 0xf0) |
 				       (max3421_hcd->iopins[i] & 0x0f));
diff --git a/drivers/usb/musb/mediatek.c b/drivers/usb/musb/mediatek.c
index 6b92d037d8fc..4f52b92c4597 100644
--- a/drivers/usb/musb/mediatek.c
+++ b/drivers/usb/musb/mediatek.c
@@ -346,7 +346,8 @@ static int mtk_musb_init(struct musb *musb)
 err_phy_power_on:
 	phy_exit(glue->phy);
 err_phy_init:
-	mtk_otg_switch_exit(glue);
+	if (musb->port_mode == MUSB_OTG)
+		mtk_otg_switch_exit(glue);
 	return ret;
 }
 
diff --git a/drivers/usb/typec/mux/intel_pmc_mux.c b/drivers/usb/typec/mux/intel_pmc_mux.c
index a2f5cfdcf02a..a7313c2d9f0f 100644
--- a/drivers/usb/typec/mux/intel_pmc_mux.c
+++ b/drivers/usb/typec/mux/intel_pmc_mux.c
@@ -563,15 +563,6 @@ static int pmc_usb_register_port(struct pmc_usb *pmc, int index,
 	return ret;
 }
 
-static int is_memory(struct acpi_resource *res, void *data)
-{
-	struct resource_win win = {};
-	struct resource *r = &win.res;
-
-	return !(acpi_dev_resource_memory(res, r) ||
-		 acpi_dev_resource_address_space(res, &win));
-}
-
 /* IOM ACPI IDs and IOM_PORT_STATUS_OFFSET */
 static const struct acpi_device_id iom_acpi_ids[] = {
 	/* TigerLake */
@@ -605,9 +596,11 @@ static int pmc_usb_probe_iom(struct pmc_usb *pmc)
 		return -ENODEV;
 
 	INIT_LIST_HEAD(&resource_list);
-	ret = acpi_dev_get_resources(adev, &resource_list, is_memory, NULL);
-	if (ret < 0)
+	ret = acpi_dev_get_memory_resources(adev, &resource_list);
+	if (ret < 0) {
+		acpi_dev_put(adev);
 		return ret;
+	}
 
 	rentry = list_first_entry_or_null(&resource_list, struct resource_entry, node);
 	if (rentry)
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index 852e6c5643e5..5623fc28b1ea 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -100,6 +100,8 @@ struct vfio_dma {
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct mm_struct	*mm;
+	size_t			locked_vm;
 };
 
 struct vfio_batch {
@@ -416,6 +418,19 @@ static int vfio_iova_put_vfio_pfn(struct vfio_dma *dma, struct vfio_pfn *vpfn)
 	return ret;
 }
 
+static int mm_lock_acct(struct task_struct *task, struct mm_struct *mm,
+			bool lock_cap, long npage)
+{
+	int ret = mmap_write_lock_killable(mm);
+
+	if (ret)
+		return ret;
+
+	ret = __account_locked_vm(mm, abs(npage), npage > 0, task, lock_cap);
+	mmap_write_unlock(mm);
+	return ret;
+}
+
 static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 {
 	struct mm_struct *mm;
@@ -424,16 +439,13 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 	if (!npage)
 		return 0;
 
-	mm = async ? get_task_mm(dma->task) : dma->task->mm;
-	if (!mm)
+	mm = dma->mm;
+	if (async && !mmget_not_zero(mm))
 		return -ESRCH; /* process exited */
 
-	ret = mmap_write_lock_killable(mm);
-	if (!ret) {
-		ret = __account_locked_vm(mm, abs(npage), npage > 0, dma->task,
-					  dma->lock_cap);
-		mmap_write_unlock(mm);
-	}
+	ret = mm_lock_acct(dma->task, mm, dma->lock_cap, npage);
+	if (!ret)
+		dma->locked_vm += npage;
 
 	if (async)
 		mmput(mm);
@@ -798,8 +810,8 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	struct mm_struct *mm;
 	int ret;
 
-	mm = get_task_mm(dma->task);
-	if (!mm)
+	mm = dma->mm;
+	if (!mmget_not_zero(mm))
 		return -ENODEV;
 
 	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, pages);
@@ -809,7 +821,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	ret = 0;
 
 	if (do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
-		ret = vfio_lock_acct(dma, 1, true);
+		ret = vfio_lock_acct(dma, 1, false);
 		if (ret) {
 			put_pfn(*pfn_base, dma->prot);
 			if (ret == -ENOMEM)
@@ -1179,6 +1191,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
+	mmdrop(dma->mm);
 	vfio_dma_bitmap_free(dma);
 	if (dma->vaddr_invalid) {
 		iommu->vaddr_invalid_count--;
@@ -1563,6 +1576,38 @@ static bool vfio_iommu_iova_dma_valid(struct vfio_iommu *iommu,
 	return list_empty(iova);
 }
 
+static int vfio_change_dma_owner(struct vfio_dma *dma)
+{
+	struct task_struct *task = current->group_leader;
+	struct mm_struct *mm = current->mm;
+	long npage = dma->locked_vm;
+	bool lock_cap;
+	int ret;
+
+	if (mm == dma->mm)
+		return 0;
+
+	lock_cap = capable(CAP_IPC_LOCK);
+	ret = mm_lock_acct(task, mm, lock_cap, npage);
+	if (ret)
+		return ret;
+
+	if (mmget_not_zero(dma->mm)) {
+		mm_lock_acct(dma->task, dma->mm, dma->lock_cap, -npage);
+		mmput(dma->mm);
+	}
+
+	if (dma->task != task) {
+		put_task_struct(dma->task);
+		dma->task = get_task_struct(task);
+	}
+	mmdrop(dma->mm);
+	dma->mm = mm;
+	mmgrab(dma->mm);
+	dma->lock_cap = lock_cap;
+	return 0;
+}
+
 static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   struct vfio_iommu_type1_dma_map *map)
 {
@@ -1612,6 +1657,9 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 			   dma->size != size) {
 			ret = -EINVAL;
 		} else {
+			ret = vfio_change_dma_owner(dma);
+			if (ret)
+				goto out_unlock;
 			dma->vaddr = vaddr;
 			dma->vaddr_invalid = false;
 			iommu->vaddr_invalid_count--;
@@ -1649,29 +1697,15 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
 	 * against the locked memory limit and we need to be able to do both
 	 * outside of this call path as pinning can be asynchronous via the
 	 * external interfaces for mdev devices.  RLIMIT_MEMLOCK requires a
-	 * task_struct and VM locked pages requires an mm_struct, however
-	 * holding an indefinite mm reference is not recommended, therefore we
-	 * only hold a reference to a task.  We could hold a reference to
-	 * current, however QEMU uses this call path through vCPU threads,
-	 * which can be killed resulting in a NULL mm and failure in the unmap
-	 * path when called via a different thread.  Avoid this problem by
-	 * using the group_leader as threads within the same group require
-	 * both CLONE_THREAD and CLONE_VM and will therefore use the same
-	 * mm_struct.
-	 *
-	 * Previously we also used the task for testing CAP_IPC_LOCK at the
-	 * time of pinning and accounting, however has_capability() makes use
-	 * of real_cred, a copy-on-write field, so we can't guarantee that it
-	 * matches group_leader, or in fact that it might not change by the
-	 * time it's evaluated.  If a process were to call MAP_DMA with
-	 * CAP_IPC_LOCK but later drop it, it doesn't make sense that they
-	 * possibly see different results for an iommu_mapped vfio_dma vs
-	 * externally mapped.  Therefore track CAP_IPC_LOCK in vfio_dma at the
-	 * time of calling MAP_DMA.
+	 * task_struct. Save the group_leader so that all DMA tracking uses
+	 * the same task, to make debugging easier.  VM locked pages requires
+	 * an mm_struct, so grab the mm in case the task dies.
 	 */
 	get_task_struct(current->group_leader);
 	dma->task = current->group_leader;
 	dma->lock_cap = capable(CAP_IPC_LOCK);
+	dma->mm = current->mm;
+	mmgrab(dma->mm);
 
 	dma->pfn_list = RB_ROOT;
 
@@ -3168,9 +3202,8 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 			!(dma->prot & IOMMU_READ))
 		return -EPERM;
 
-	mm = get_task_mm(dma->task);
-
-	if (!mm)
+	mm = dma->mm;
+	if (!mmget_not_zero(mm))
 		return -EPERM;
 
 	if (kthread)
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index d90d807c6756..b6712655ec1f 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -989,7 +989,7 @@ static const char *fbcon_startup(void)
 	set_blitting_type(vc, info);
 
 	/* Setup default font */
-	if (!p->fontdata && !vc->vc_font.data) {
+	if (!p->fontdata) {
 		if (!fontname[0] || !(font = find_font(fontname)))
 			font = get_default_font(info->var.xres,
 						info->var.yres,
@@ -999,8 +999,6 @@ static const char *fbcon_startup(void)
 		vc->vc_font.height = font->height;
 		vc->vc_font.data = (void *)(p->fontdata = font->data);
 		vc->vc_font.charcount = font->charcount;
-	} else {
-		p->fontdata = vc->vc_font.data;
 	}
 
 	cols = FBCON_SWAP(ops->rotate, info->var.xres, info->var.yres);
@@ -1167,9 +1165,9 @@ static void fbcon_init(struct vc_data *vc, int init)
 	ops->p = &fb_display[fg_console];
 }
 
-static void fbcon_free_font(struct fbcon_display *p, bool freefont)
+static void fbcon_free_font(struct fbcon_display *p)
 {
-	if (freefont && p->userfont && p->fontdata && (--REFCOUNT(p->fontdata) == 0))
+	if (p->userfont && p->fontdata && (--REFCOUNT(p->fontdata) == 0))
 		kfree(p->fontdata - FONT_EXTRA_WORDS * sizeof(int));
 	p->fontdata = NULL;
 	p->userfont = 0;
@@ -1183,8 +1181,8 @@ static void fbcon_deinit(struct vc_data *vc)
 	struct fb_info *info;
 	struct fbcon_ops *ops;
 	int idx;
-	bool free_font = true;
 
+	fbcon_free_font(p);
 	idx = con2fb_map[vc->vc_num];
 
 	if (idx == -1)
@@ -1195,8 +1193,6 @@ static void fbcon_deinit(struct vc_data *vc)
 	if (!info)
 		goto finished;
 
-	if (info->flags & FBINFO_MISC_FIRMWARE)
-		free_font = false;
 	ops = info->fbcon_par;
 
 	if (!ops)
@@ -1208,9 +1204,8 @@ static void fbcon_deinit(struct vc_data *vc)
 	ops->flags &= ~FBCON_FLAGS_INIT;
 finished:
 
-	fbcon_free_font(p, free_font);
-	if (free_font)
-		vc->vc_font.data = NULL;
+	fbcon_free_font(p);
+	vc->vc_font.data = NULL;
 
 	if (vc->vc_hi_font_mask && vc->vc_screenbuf)
 		set_vc_hi_font(vc, false);
diff --git a/fs/btrfs/discard.c b/fs/btrfs/discard.c
index e1b7bd927d69..bd9dde374e5d 100644
--- a/fs/btrfs/discard.c
+++ b/fs/btrfs/discard.c
@@ -77,6 +77,7 @@ static struct list_head *get_discard_list(struct btrfs_discard_ctl *discard_ctl,
 static void __add_to_discard_list(struct btrfs_discard_ctl *discard_ctl,
 				  struct btrfs_block_group *block_group)
 {
+	lockdep_assert_held(&discard_ctl->lock);
 	if (!btrfs_run_discard_work(discard_ctl))
 		return;
 
@@ -88,6 +89,8 @@ static void __add_to_discard_list(struct btrfs_discard_ctl *discard_ctl,
 						      BTRFS_DISCARD_DELAY);
 		block_group->discard_state = BTRFS_DISCARD_RESET_CURSOR;
 	}
+	if (list_empty(&block_group->discard_list))
+		btrfs_get_block_group(block_group);
 
 	list_move_tail(&block_group->discard_list,
 		       get_discard_list(discard_ctl, block_group));
@@ -107,8 +110,12 @@ static void add_to_discard_list(struct btrfs_discard_ctl *discard_ctl,
 static void add_to_discard_unused_list(struct btrfs_discard_ctl *discard_ctl,
 				       struct btrfs_block_group *block_group)
 {
+	bool queued;
+
 	spin_lock(&discard_ctl->lock);
 
+	queued = !list_empty(&block_group->discard_list);
+
 	if (!btrfs_run_discard_work(discard_ctl)) {
 		spin_unlock(&discard_ctl->lock);
 		return;
@@ -120,6 +127,8 @@ static void add_to_discard_unused_list(struct btrfs_discard_ctl *discard_ctl,
 	block_group->discard_eligible_time = (ktime_get_ns() +
 					      BTRFS_DISCARD_UNUSED_DELAY);
 	block_group->discard_state = BTRFS_DISCARD_RESET_CURSOR;
+	if (!queued)
+		btrfs_get_block_group(block_group);
 	list_add_tail(&block_group->discard_list,
 		      &discard_ctl->discard_list[BTRFS_DISCARD_INDEX_UNUSED]);
 
@@ -130,6 +139,7 @@ static bool remove_from_discard_list(struct btrfs_discard_ctl *discard_ctl,
 				     struct btrfs_block_group *block_group)
 {
 	bool running = false;
+	bool queued = false;
 
 	spin_lock(&discard_ctl->lock);
 
@@ -139,7 +149,16 @@ static bool remove_from_discard_list(struct btrfs_discard_ctl *discard_ctl,
 	}
 
 	block_group->discard_eligible_time = 0;
+	queued = !list_empty(&block_group->discard_list);
 	list_del_init(&block_group->discard_list);
+	/*
+	 * If the block group is currently running in the discard workfn, we
+	 * don't want to deref it, since it's still being used by the workfn.
+	 * The workfn will notice this case and deref the block group when it is
+	 * finished.
+	 */
+	if (queued && !running)
+		btrfs_put_block_group(block_group);
 
 	spin_unlock(&discard_ctl->lock);
 
@@ -212,10 +231,12 @@ static struct btrfs_block_group *peek_discard_list(
 	if (block_group && now >= block_group->discard_eligible_time) {
 		if (block_group->discard_index == BTRFS_DISCARD_INDEX_UNUSED &&
 		    block_group->used != 0) {
-			if (btrfs_is_block_group_data_only(block_group))
+			if (btrfs_is_block_group_data_only(block_group)) {
 				__add_to_discard_list(discard_ctl, block_group);
-			else
+			} else {
 				list_del_init(&block_group->discard_list);
+				btrfs_put_block_group(block_group);
+			}
 			goto again;
 		}
 		if (block_group->discard_state == BTRFS_DISCARD_RESET_CURSOR) {
@@ -502,6 +523,15 @@ static void btrfs_discard_workfn(struct work_struct *work)
 	spin_lock(&discard_ctl->lock);
 	discard_ctl->prev_discard = trimmed;
 	discard_ctl->prev_discard_time = now;
+	/*
+	 * If the block group was removed from the discard list while it was
+	 * running in this workfn, then we didn't deref it, since this function
+	 * still owned that reference. But we set the discard_ctl->block_group
+	 * back to NULL, so we can use that condition to know that now we need
+	 * to deref the block_group.
+	 */
+	if (discard_ctl->block_group == NULL)
+		btrfs_put_block_group(block_group);
 	discard_ctl->block_group = NULL;
 	__btrfs_discard_schedule_work(discard_ctl, now, false);
 	spin_unlock(&discard_ctl->lock);
@@ -638,8 +668,12 @@ void btrfs_discard_punt_unused_bgs_list(struct btrfs_fs_info *fs_info)
 	list_for_each_entry_safe(block_group, next, &fs_info->unused_bgs,
 				 bg_list) {
 		list_del_init(&block_group->bg_list);
-		btrfs_put_block_group(block_group);
 		btrfs_discard_queue_work(&fs_info->discard_ctl, block_group);
+		/*
+		 * This put is for the get done by btrfs_mark_bg_unused.
+		 * Queueing discard incremented it for discard's reference.
+		 */
+		btrfs_put_block_group(block_group);
 	}
 	spin_unlock(&fs_info->unused_bgs_lock);
 }
@@ -669,6 +703,7 @@ static void btrfs_discard_purge_list(struct btrfs_discard_ctl *discard_ctl)
 			if (block_group->used == 0)
 				btrfs_mark_bg_unused(block_group);
 			spin_lock(&discard_ctl->lock);
+			btrfs_put_block_group(block_group);
 		}
 	}
 	spin_unlock(&discard_ctl->lock);
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 53bffda3c76c..cb87714fe886 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2084,6 +2084,9 @@ static long ceph_fallocate(struct file *file, int mode,
 	loff_t endoff = 0;
 	loff_t size;
 
+	dout("%s %p %llx.%llx mode %x, offset %llu length %llu\n", __func__,
+	     inode, ceph_vinop(inode), mode, offset, length);
+
 	if (mode != (FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
 		return -EOPNOTSUPP;
 
@@ -2124,6 +2127,10 @@ static long ceph_fallocate(struct file *file, int mode,
 	if (ret < 0)
 		goto unlock;
 
+	ret = file_modified(file);
+	if (ret)
+		goto put_caps;
+
 	filemap_invalidate_lock(inode->i_mapping);
 	ceph_zero_pagecache_range(inode, offset, length);
 	ret = ceph_zero_objects(inode, offset, length);
@@ -2139,6 +2146,7 @@ static long ceph_fallocate(struct file *file, int mode,
 	}
 	filemap_invalidate_unlock(inode->i_mapping);
 
+put_caps:
 	ceph_put_cap_refs(ci, got);
 unlock:
 	inode_unlock(inode);
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 817d78129bd2..1fef721f60c9 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -966,12 +966,13 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 	struct cifs_fid fid;
 	struct cached_fid *cfid = NULL;
 
-	oparms.tcon = tcon;
-	oparms.desired_access = FILE_READ_ATTRIBUTES;
-	oparms.disposition = FILE_OPEN;
-	oparms.create_options = cifs_create_options(cifs_sb, 0);
-	oparms.fid = &fid;
-	oparms.reconnect = false;
+	oparms = (struct cifs_open_parms) {
+		.tcon = tcon,
+		.desired_access = FILE_READ_ATTRIBUTES,
+		.disposition = FILE_OPEN,
+		.create_options = cifs_create_options(cifs_sb, 0),
+		.fid = &fid,
+	};
 
 	rc = open_cached_dir(xid, tcon, "", cifs_sb, &cfid);
 	if (rc == 0)
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index cb93cccbf0c4..a9a5d27b8d38 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1702,6 +1702,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 allocate_mr_failed:
 	/* At this point, need to a full transport shutdown */
+	server->smbd_conn = info;
 	smbd_destroy(server);
 	return NULL;
 
@@ -2250,6 +2251,7 @@ static int allocate_mr_list(struct smbd_connection *info)
 	atomic_set(&info->mr_ready_count, 0);
 	atomic_set(&info->mr_used_count, 0);
 	init_waitqueue_head(&info->wait_for_mr_cleanup);
+	INIT_WORK(&info->mr_recovery_work, smbd_mr_recovery_work);
 	/* Allocate more MRs (2x) than hardware responder_resources */
 	for (i = 0; i < info->responder_resources * 2; i++) {
 		smbdirect_mr = kzalloc(sizeof(*smbdirect_mr), GFP_KERNEL);
@@ -2277,13 +2279,13 @@ static int allocate_mr_list(struct smbd_connection *info)
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
diff --git a/fs/dlm/midcomms.c b/fs/dlm/midcomms.c
index 7ae39ec8d9b0..702c14de7a4b 100644
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -366,7 +366,7 @@ static int dlm_send_ack(int nodeid, uint32_t seq)
 	struct dlm_msg *msg;
 	char *ppc;
 
-	msg = dlm_lowcomms_new_msg(nodeid, mb_len, GFP_NOFS, &ppc,
+	msg = dlm_lowcomms_new_msg(nodeid, mb_len, GFP_ATOMIC, &ppc,
 				   NULL, NULL);
 	if (!msg)
 		return -ENOMEM;
@@ -394,7 +394,7 @@ static int dlm_send_fin(struct midcomms_node *node,
 	struct dlm_mhandle *mh;
 	char *ppc;
 
-	mh = dlm_midcomms_get_mhandle(node->nodeid, mb_len, GFP_NOFS, &ppc);
+	mh = dlm_midcomms_get_mhandle(node->nodeid, mb_len, GFP_ATOMIC, &ppc);
 	if (!mh)
 		return -ENOMEM;
 
@@ -478,15 +478,14 @@ static void dlm_midcomms_receive_buffer(union dlm_packet *p,
 
 		switch (p->header.h_cmd) {
 		case DLM_FIN:
-			/* send ack before fin */
-			dlm_send_ack(node->nodeid, node->seq_next);
-
 			spin_lock(&node->state_lock);
 			pr_debug("receive fin msg from node %d with state %s\n",
 				 node->nodeid, dlm_state_str(node->state));
 
 			switch (node->state) {
 			case DLM_ESTABLISHED:
+				dlm_send_ack(node->nodeid, node->seq_next);
+
 				node->state = DLM_CLOSE_WAIT;
 				pr_debug("switch node %d to state %s\n",
 					 node->nodeid, dlm_state_str(node->state));
@@ -498,16 +497,19 @@ static void dlm_midcomms_receive_buffer(union dlm_packet *p,
 					node->state = DLM_LAST_ACK;
 					pr_debug("switch node %d to state %s case 1\n",
 						 node->nodeid, dlm_state_str(node->state));
-					spin_unlock(&node->state_lock);
-					goto send_fin;
+					set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
+					dlm_send_fin(node, dlm_pas_fin_ack_rcv);
 				}
 				break;
 			case DLM_FIN_WAIT1:
+				dlm_send_ack(node->nodeid, node->seq_next);
 				node->state = DLM_CLOSING;
+				set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
 				pr_debug("switch node %d to state %s\n",
 					 node->nodeid, dlm_state_str(node->state));
 				break;
 			case DLM_FIN_WAIT2:
+				dlm_send_ack(node->nodeid, node->seq_next);
 				midcomms_node_reset(node);
 				pr_debug("switch node %d to state %s\n",
 					 node->nodeid, dlm_state_str(node->state));
@@ -524,8 +526,6 @@ static void dlm_midcomms_receive_buffer(union dlm_packet *p,
 				return;
 			}
 			spin_unlock(&node->state_lock);
-
-			set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
 			break;
 		default:
 			WARN_ON(test_bit(DLM_NODE_FLAG_STOP_RX, &node->flags));
@@ -543,12 +543,6 @@ static void dlm_midcomms_receive_buffer(union dlm_packet *p,
 		log_print_ratelimited("ignore dlm msg because seq mismatch, seq: %u, expected: %u, nodeid: %d",
 				      seq, node->seq_next, node->nodeid);
 	}
-
-	return;
-
-send_fin:
-	set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
-	dlm_send_fin(node, dlm_pas_fin_ack_rcv);
 }
 
 static struct midcomms_node *
@@ -1269,11 +1263,11 @@ void dlm_midcomms_remove_member(int nodeid)
 		case DLM_CLOSE_WAIT:
 			/* passive shutdown DLM_LAST_ACK case 2 */
 			node->state = DLM_LAST_ACK;
-			spin_unlock(&node->state_lock);
-
 			pr_debug("switch node %d to state %s case 2\n",
 				 node->nodeid, dlm_state_str(node->state));
-			goto send_fin;
+			set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
+			dlm_send_fin(node, dlm_pas_fin_ack_rcv);
+			break;
 		case DLM_LAST_ACK:
 			/* probably receive fin caught it, do nothing */
 			break;
@@ -1289,12 +1283,6 @@ void dlm_midcomms_remove_member(int nodeid)
 	spin_unlock(&node->state_lock);
 
 	srcu_read_unlock(&nodes_srcu, idx);
-	return;
-
-send_fin:
-	set_bit(DLM_NODE_FLAG_STOP_RX, &node->flags);
-	dlm_send_fin(node, dlm_pas_fin_ack_rcv);
-	srcu_read_unlock(&nodes_srcu, idx);
 }
 
 static void midcomms_node_release(struct rcu_head *rcu)
@@ -1325,6 +1313,7 @@ static void midcomms_shutdown(struct midcomms_node *node)
 		node->state = DLM_FIN_WAIT1;
 		pr_debug("switch node %d to state %s case 2\n",
 			 node->nodeid, dlm_state_str(node->state));
+		dlm_send_fin(node, dlm_act_fin_ack_rcv);
 		break;
 	case DLM_CLOSED:
 		/* we have what we want */
@@ -1338,12 +1327,8 @@ static void midcomms_shutdown(struct midcomms_node *node)
 	}
 	spin_unlock(&node->state_lock);
 
-	if (node->state == DLM_FIN_WAIT1) {
-		dlm_send_fin(node, dlm_act_fin_ack_rcv);
-
-		if (DLM_DEBUG_FENCE_TERMINATION)
-			msleep(5000);
-	}
+	if (DLM_DEBUG_FENCE_TERMINATION)
+		msleep(5000);
 
 	/* wait for other side dlm + fin */
 	ret = wait_event_timeout(node->shutdown_wait,
diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index cb1c0d8c1714..3940a56902dd 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -103,7 +103,7 @@ static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_ent
 			clu.dir = ei->hint_bmap.clu;
 		}
 
-		while (clu_offset > 0) {
+		while (clu_offset > 0 && clu.dir != EXFAT_EOF_CLUSTER) {
 			if (exfat_get_next_cluster(sb, &(clu.dir)))
 				return -EIO;
 
@@ -237,10 +237,7 @@ static int exfat_iterate(struct file *filp, struct dir_context *ctx)
 		fake_offset = 1;
 	}
 
-	if (cpos & (DENTRY_SIZE - 1)) {
-		err = -ENOENT;
-		goto unlock;
-	}
+	cpos = round_up(cpos, DENTRY_SIZE);
 
 	/* name buffer should be allocated before use */
 	err = exfat_alloc_namebuf(nb);
diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index 9f82a8a835ee..db538709dafa 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -42,7 +42,7 @@ enum {
 #define ES_2_ENTRIES		2
 #define ES_ALL_ENTRIES		0
 
-#define DIR_DELETED		0xFFFF0321
+#define DIR_DELETED		0xFFFFFFF7
 
 /* type values */
 #define TYPE_UNUSED		0x0000
diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index d890fd34bb2d..c40082ae3bd1 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -251,8 +251,7 @@ void exfat_truncate(struct inode *inode, loff_t size)
 	else
 		mark_inode_dirty(inode);
 
-	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
-				inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >> 9;
 write_size:
 	aligned_size = i_size_read(inode);
 	if (aligned_size & (blocksize - 1)) {
diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 72a0ccfb616c..23d8c364edff 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -243,8 +243,7 @@ static int exfat_map_cluster(struct inode *inode, unsigned int clu_offset,
 				return err;
 		} /* end of if != DIR_DELETED */
 
-		inode->i_blocks +=
-			num_to_be_allocated << sbi->sect_per_clus_bits;
+		inode->i_blocks += EXFAT_CLU_TO_B(num_to_be_allocated, sbi) >> 9;
 
 		/*
 		 * Move *clu pointer along FAT chains (hole care) because the
@@ -602,8 +601,7 @@ static int exfat_fill_inode(struct inode *inode, struct exfat_dir_entry *info)
 
 	exfat_save_attr(inode, info->attr);
 
-	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
-				inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >> 9;
 	inode->i_mtime = info->mtime;
 	inode->i_ctime = info->mtime;
 	ei->i_crtime = info->crtime;
diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 8a7f4c0830f3..b22d6c984f8c 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -398,7 +398,7 @@ static int exfat_find_empty_entry(struct inode *inode,
 		ei->i_size_ondisk += sbi->cluster_size;
 		ei->i_size_aligned += sbi->cluster_size;
 		ei->flags = p_dir->flags;
-		inode->i_blocks += 1 << sbi->sect_per_clus_bits;
+		inode->i_blocks += sbi->cluster_size >> 9;
 	}
 
 	return dentry;
diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 4b5d02b1df58..822976236f44 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -364,8 +364,7 @@ static int exfat_read_root(struct inode *inode)
 	inode->i_op = &exfat_dir_inode_operations;
 	inode->i_fop = &exfat_dir_operations;
 
-	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
-				inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >> 9;
 	ei->i_pos = ((loff_t)sbi->root_dir << 32) | 0xffffffff;
 	ei->i_size_aligned = i_size_read(inode);
 	ei->i_size_ondisk = i_size_read(inode);
diff --git a/fs/ext4/xattr.c b/fs/ext4/xattr.c
index b92da41e9640..d6edf38de31b 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1422,6 +1422,13 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
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
@@ -2549,9 +2556,8 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 
 	is = kzalloc(sizeof(struct ext4_xattr_ibody_find), GFP_NOFS);
 	bs = kzalloc(sizeof(struct ext4_xattr_block_find), GFP_NOFS);
-	buffer = kvmalloc(value_size, GFP_NOFS);
 	b_entry_name = kmalloc(entry->e_name_len + 1, GFP_NOFS);
-	if (!is || !bs || !buffer || !b_entry_name) {
+	if (!is || !bs || !b_entry_name) {
 		error = -ENOMEM;
 		goto out;
 	}
@@ -2563,12 +2569,18 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 
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
@@ -2583,25 +2595,26 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
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
index cfa6e1322e46..ee2909267a33 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -677,7 +677,7 @@ int f2fs_submit_page_bio(struct f2fs_io_info *fio)
 	}
 
 	if (fio->io_wbc && !is_read_io(fio->op))
-		wbc_account_cgroup_owner(fio->io_wbc, page, PAGE_SIZE);
+		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	__attach_io_flag(fio);
 	bio_set_op_attrs(bio, fio->op, fio->op_flags);
@@ -887,7 +887,7 @@ int f2fs_merge_page_bio(struct f2fs_io_info *fio)
 	}
 
 	if (fio->io_wbc)
-		wbc_account_cgroup_owner(fio->io_wbc, page, PAGE_SIZE);
+		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	inc_page_count(fio->sbi, WB_DATA_TYPE(page));
 
@@ -961,7 +961,7 @@ void f2fs_submit_page_write(struct f2fs_io_info *fio)
 	}
 
 	if (fio->io_wbc)
-		wbc_account_cgroup_owner(fio->io_wbc, bio_page, PAGE_SIZE);
+		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	io->last_block_in_bio = fio->new_blkaddr;
 
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index d0e3fc963cf2..480d5f76491d 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -427,18 +427,17 @@ static int f2fs_move_inline_dirents(struct inode *dir, struct page *ipage,
 
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
 
diff --git a/fs/fuse/ioctl.c b/fs/fuse/ioctl.c
index e91d40703839..dbff26f7f9cd 100644
--- a/fs/fuse/ioctl.c
+++ b/fs/fuse/ioctl.c
@@ -419,6 +419,12 @@ static struct fuse_file *fuse_priv_ioctl_prepare(struct inode *inode)
 	struct fuse_mount *fm = get_fuse_mount(inode);
 	bool isdir = S_ISDIR(inode->i_mode);
 
+	if (!fuse_allow_current_process(fm->fc))
+		return ERR_PTR(-EACCES);
+
+	if (fuse_is_bad(inode))
+		return ERR_PTR(-EIO);
+
 	if (!S_ISREG(inode->i_mode) && !isdir)
 		return ERR_PTR(-ENOTTY);
 
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index 4bbfb156e6a4..ee212c9310ad 100644
--- a/fs/gfs2/aops.c
+++ b/fs/gfs2/aops.c
@@ -152,7 +152,6 @@ static int __gfs2_jdata_writepage(struct page *page, struct writeback_control *w
 {
 	struct inode *inode = page->mapping->host;
 	struct gfs2_inode *ip = GFS2_I(inode);
-	struct gfs2_sbd *sdp = GFS2_SB(inode);
 
 	if (PageChecked(page)) {
 		ClearPageChecked(page);
@@ -160,7 +159,7 @@ static int __gfs2_jdata_writepage(struct page *page, struct writeback_control *w
 			create_empty_buffers(page, inode->i_sb->s_blocksize,
 					     BIT(BH_Dirty)|BIT(BH_Uptodate));
 		}
-		gfs2_page_add_databufs(ip, page, 0, sdp->sd_vfs->s_blocksize);
+		gfs2_page_add_databufs(ip, page, 0, PAGE_SIZE);
 	}
 	return gfs2_write_jdata_page(page, wbc);
 }
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index d615974ce418..775ac3fb10c6 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -138,8 +138,10 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 		return -EIO;
 
 	error = gfs2_find_jhead(sdp->sd_jdesc, &head, false);
-	if (error || gfs2_withdrawn(sdp))
+	if (error) {
+		gfs2_consist(sdp);
 		return error;
+	}
 
 	if (!(head.lh_flags & GFS2_LOG_HEAD_UNMOUNT)) {
 		gfs2_consist(sdp);
@@ -151,7 +153,9 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 	gfs2_log_pointers_init(sdp, head.lh_blkno);
 
 	error = gfs2_quota_init(sdp);
-	if (!error && !gfs2_withdrawn(sdp))
+	if (!error && gfs2_withdrawn(sdp))
+		error = -EIO;
+	if (!error)
 		set_bit(SDF_JOURNAL_LIVE, &sdp->sd_flags);
 	return error;
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
index b9e3db3f855f..392edb60edd0 100644
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
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index a57c0c8c63c4..55232064cab2 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1001,36 +1001,28 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
 	 * ie. locked but not dirty) or tune2fs (which may actually have
 	 * the buffer dirtied, ugh.)  */
 
-	if (buffer_dirty(bh)) {
+	if (buffer_dirty(bh) && jh->b_transaction) {
+		warn_dirty_buffer(bh);
 		/*
-		 * First question: is this buffer already part of the current
-		 * transaction or the existing committing transaction?
-		 */
-		if (jh->b_transaction) {
-			J_ASSERT_JH(jh,
-				jh->b_transaction == transaction ||
-				jh->b_transaction ==
-					journal->j_committing_transaction);
-			if (jh->b_next_transaction)
-				J_ASSERT_JH(jh, jh->b_next_transaction ==
-							transaction);
-			warn_dirty_buffer(bh);
-		}
-		/*
-		 * In any case we need to clean the dirty flag and we must
-		 * do it under the buffer lock to be sure we don't race
-		 * with running write-out.
+		 * We need to clean the dirty flag and we must do it under the
+		 * buffer lock to be sure we don't race with running write-out.
 		 */
 		JBUFFER_TRACE(jh, "Journalling dirty buffer");
 		clear_buffer_dirty(bh);
+		/*
+		 * The buffer is going to be added to BJ_Reserved list now and
+		 * nothing guarantees jbd2_journal_dirty_metadata() will be
+		 * ever called for it. So we need to set jbddirty bit here to
+		 * make sure the buffer is dirtied and written out when the
+		 * journaling machinery is done with it.
+		 */
 		set_buffer_jbddirty(bh);
 	}
 
-	unlock_buffer(bh);
-
 	error = -EROFS;
 	if (is_handle_aborted(handle)) {
 		spin_unlock(&jh->b_state_lock);
+		unlock_buffer(bh);
 		goto out;
 	}
 	error = 0;
@@ -1040,8 +1032,10 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
 	 * b_next_transaction points to it
 	 */
 	if (jh->b_transaction == transaction ||
-	    jh->b_next_transaction == transaction)
+	    jh->b_next_transaction == transaction) {
+		unlock_buffer(bh);
 		goto done;
+	}
 
 	/*
 	 * this is the first time this transaction is touching this buffer,
@@ -1065,10 +1059,24 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
 		 */
 		smp_wmb();
 		spin_lock(&journal->j_list_lock);
+		if (test_clear_buffer_dirty(bh)) {
+			/*
+			 * Execute buffer dirty clearing and jh->b_transaction
+			 * assignment under journal->j_list_lock locked to
+			 * prevent bh being removed from checkpoint list if
+			 * the buffer is in an intermediate state (not dirty
+			 * and jh->b_transaction is NULL).
+			 */
+			JBUFFER_TRACE(jh, "Journalling dirty buffer");
+			set_buffer_jbddirty(bh);
+		}
 		__jbd2_journal_file_buffer(jh, transaction, BJ_Reserved);
 		spin_unlock(&journal->j_list_lock);
+		unlock_buffer(bh);
 		goto done;
 	}
+	unlock_buffer(bh);
+
 	/*
 	 * If there is already a copy-out version of this buffer, then we don't
 	 * need to make another one
diff --git a/fs/ksmbd/smb2misc.c b/fs/ksmbd/smb2misc.c
index b47be71be4c8..c579d0e09c13 100644
--- a/fs/ksmbd/smb2misc.c
+++ b/fs/ksmbd/smb2misc.c
@@ -150,15 +150,11 @@ static int smb2_get_data_area_len(unsigned int *off, unsigned int *len,
 		break;
 	case SMB2_LOCK:
 	{
-		int lock_count;
+		unsigned short lock_count;
 
-		/*
-		 * smb2_lock request size is 48 included single
-		 * smb2_lock_element structure size.
-		 */
-		lock_count = le16_to_cpu(((struct smb2_lock_req *)hdr)->LockCount) - 1;
+		lock_count = le16_to_cpu(((struct smb2_lock_req *)hdr)->LockCount);
 		if (lock_count > 0) {
-			*off = __SMB2_HEADER_STRUCTURE_SIZE + 48;
+			*off = offsetof(struct smb2_lock_req, locks);
 			*len = sizeof(struct smb2_lock_element) * lock_count;
 		}
 		break;
@@ -418,20 +414,19 @@ int ksmbd_smb2_check_message(struct ksmbd_work *work)
 			goto validate_credit;
 
 		/*
-		 * windows client also pad up to 8 bytes when compounding.
-		 * If pad is longer than eight bytes, log the server behavior
-		 * (once), since may indicate a problem but allow it and
-		 * continue since the frame is parseable.
+		 * SMB2 NEGOTIATE request will be validated when message
+		 * handling proceeds.
 		 */
-		if (clc_len < len) {
-			ksmbd_debug(SMB,
-				    "cli req padded more than expected. Length %d not %d for cmd:%d mid:%llu\n",
-				    len, clc_len, command,
-				    le64_to_cpu(hdr->MessageId));
+		if (command == SMB2_NEGOTIATE_HE)
+			goto validate_credit;
+
+		/*
+		 * Allow a message that padded to 8byte boundary.
+		 */
+		if (clc_len < len && (len - clc_len) < 8)
 			goto validate_credit;
-		}
 
-		ksmbd_debug(SMB,
+		pr_err_ratelimited(
 			    "cli req too short, len %d not %d. cmd:%d mid:%llu\n",
 			    len, clc_len, command,
 			    le64_to_cpu(hdr->MessageId));
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index ad5114e48009..dd53d0f97c57 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -484,8 +484,9 @@ static int nfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 {
 	unsigned long blocks;
 	long long isize;
-	struct rpc_clnt *clnt = NFS_CLIENT(file->f_mapping->host);
-	struct inode *inode = file->f_mapping->host;
+	struct inode *inode = file_inode(file);
+	struct rpc_clnt *clnt = NFS_CLIENT(inode);
+	struct nfs_client *cl = NFS_SERVER(inode)->nfs_client;
 
 	spin_lock(&inode->i_lock);
 	blocks = inode->i_blocks;
@@ -498,14 +499,22 @@ static int nfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 
 	*span = sis->pages;
 
+
+	if (cl->rpc_ops->enable_swap)
+		cl->rpc_ops->enable_swap(inode);
+
 	return rpc_clnt_swap_activate(clnt);
 }
 
 static void nfs_swap_deactivate(struct file *file)
 {
-	struct rpc_clnt *clnt = NFS_CLIENT(file->f_mapping->host);
+	struct inode *inode = file_inode(file);
+	struct rpc_clnt *clnt = NFS_CLIENT(inode);
+	struct nfs_client *cl = NFS_SERVER(inode)->nfs_client;
 
 	rpc_clnt_swap_deactivate(clnt);
+	if (cl->rpc_ops->disable_swap)
+		cl->rpc_ops->disable_swap(file_inode(file));
 }
 
 const struct address_space_operations nfs_file_aops = {
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index f8672a34fd63..0a1e1c64b131 100644
--- a/fs/nfs/nfs4_fs.h
+++ b/fs/nfs/nfs4_fs.h
@@ -42,6 +42,7 @@ enum nfs4_client_state {
 	NFS4CLNT_LEASE_MOVED,
 	NFS4CLNT_DELEGATION_EXPIRED,
 	NFS4CLNT_RUN_MANAGER,
+	NFS4CLNT_MANAGER_AVAILABLE,
 	NFS4CLNT_RECALL_RUNNING,
 	NFS4CLNT_RECALL_ANY_LAYOUT_READ,
 	NFS4CLNT_RECALL_ANY_LAYOUT_RW,
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index b6b1fad031c7..27cafeada865 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10530,6 +10530,26 @@ static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
 	return error + error2 + error3;
 }
 
+static void nfs4_enable_swap(struct inode *inode)
+{
+	/* The state manager thread must always be running.
+	 * It will notice the client is a swapper, and stay put.
+	 */
+	struct nfs_client *clp = NFS_SERVER(inode)->nfs_client;
+
+	nfs4_schedule_state_manager(clp);
+}
+
+static void nfs4_disable_swap(struct inode *inode)
+{
+	/* The state manager thread will now exit once it is
+	 * woken.
+	 */
+	struct nfs_client *clp = NFS_SERVER(inode)->nfs_client;
+
+	nfs4_schedule_state_manager(clp);
+}
+
 static const struct inode_operations nfs4_dir_inode_operations = {
 	.create		= nfs_create,
 	.lookup		= nfs_lookup,
@@ -10607,6 +10627,8 @@ const struct nfs_rpc_ops nfs_v4_clientops = {
 	.create_server	= nfs4_create_server,
 	.clone_server	= nfs_clone_server,
 	.discover_trunking = nfs4_discover_trunking,
+	.enable_swap	= nfs4_enable_swap,
+	.disable_swap	= nfs4_disable_swap,
 };
 
 static const struct xattr_handler nfs4_xattr_nfs4_acl_handler = {
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 0cd803b4d90c..7223816bc5d5 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1209,10 +1209,17 @@ void nfs4_schedule_state_manager(struct nfs_client *clp)
 {
 	struct task_struct *task;
 	char buf[INET6_ADDRSTRLEN + sizeof("-manager") + 1];
+	struct rpc_clnt *cl = clp->cl_rpcclient;
+
+	while (cl != cl->cl_parent)
+		cl = cl->cl_parent;
 
 	set_bit(NFS4CLNT_RUN_MANAGER, &clp->cl_state);
-	if (test_and_set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state) != 0)
+	if (test_and_set_bit(NFS4CLNT_MANAGER_AVAILABLE, &clp->cl_state) != 0) {
+		wake_up_var(&clp->cl_state);
 		return;
+	}
+	set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state);
 	__module_get(THIS_MODULE);
 	refcount_inc(&clp->cl_count);
 
@@ -1230,6 +1237,7 @@ void nfs4_schedule_state_manager(struct nfs_client *clp)
 		if (!nfs_client_init_is_complete(clp))
 			nfs_mark_client_ready(clp, PTR_ERR(task));
 		nfs4_clear_state_manager_bit(clp);
+		clear_bit(NFS4CLNT_MANAGER_AVAILABLE, &clp->cl_state);
 		nfs_put_client(clp);
 		module_put(THIS_MODULE);
 	}
@@ -2689,12 +2697,8 @@ static void nfs4_state_manager(struct nfs_client *clp)
 			clear_bit(NFS4CLNT_RECALL_RUNNING, &clp->cl_state);
 		}
 
-		/* Did we race with an attempt to give us more work? */
-		if (!test_bit(NFS4CLNT_RUN_MANAGER, &clp->cl_state))
-			return;
-		if (test_and_set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state) != 0)
-			return;
-		memflags = memalloc_nofs_save();
+		return;
+
 	} while (refcount_read(&clp->cl_count) > 1 && !signalled());
 	goto out_drain;
 
@@ -2715,9 +2719,31 @@ static void nfs4_state_manager(struct nfs_client *clp)
 static int nfs4_run_state_manager(void *ptr)
 {
 	struct nfs_client *clp = ptr;
+	struct rpc_clnt *cl = clp->cl_rpcclient;
+
+	while (cl != cl->cl_parent)
+		cl = cl->cl_parent;
 
 	allow_signal(SIGKILL);
+again:
+	set_bit(NFS4CLNT_MANAGER_RUNNING, &clp->cl_state);
 	nfs4_state_manager(clp);
+	if (atomic_read(&cl->cl_swapper)) {
+		wait_var_event_interruptible(&clp->cl_state,
+					     test_bit(NFS4CLNT_RUN_MANAGER,
+						      &clp->cl_state));
+		if (atomic_read(&cl->cl_swapper) &&
+		    test_bit(NFS4CLNT_RUN_MANAGER, &clp->cl_state))
+			goto again;
+		/* Either no longer a swapper, or were signalled */
+	}
+	clear_bit(NFS4CLNT_MANAGER_AVAILABLE, &clp->cl_state);
+
+	if (refcount_read(&clp->cl_count) > 1 && !signalled() &&
+	    test_bit(NFS4CLNT_RUN_MANAGER, &clp->cl_state) &&
+	    !test_and_set_bit(NFS4CLNT_MANAGER_AVAILABLE, &clp->cl_state))
+		goto again;
+
 	nfs_put_client(clp);
 	module_put_and_exit(0);
 	return 0;
diff --git a/fs/nfs/nfs4trace.h b/fs/nfs/nfs4trace.h
index 7a2567aa2b86..bcd18e96b44f 100644
--- a/fs/nfs/nfs4trace.h
+++ b/fs/nfs/nfs4trace.h
@@ -584,32 +584,34 @@ TRACE_DEFINE_ENUM(NFS4CLNT_MOVED);
 TRACE_DEFINE_ENUM(NFS4CLNT_LEASE_MOVED);
 TRACE_DEFINE_ENUM(NFS4CLNT_DELEGATION_EXPIRED);
 TRACE_DEFINE_ENUM(NFS4CLNT_RUN_MANAGER);
+TRACE_DEFINE_ENUM(NFS4CLNT_MANAGER_AVAILABLE);
 TRACE_DEFINE_ENUM(NFS4CLNT_RECALL_RUNNING);
 TRACE_DEFINE_ENUM(NFS4CLNT_RECALL_ANY_LAYOUT_READ);
 TRACE_DEFINE_ENUM(NFS4CLNT_RECALL_ANY_LAYOUT_RW);
+TRACE_DEFINE_ENUM(NFS4CLNT_DELEGRETURN_DELAYED);
 
 #define show_nfs4_clp_state(state) \
 	__print_flags(state, "|", \
-		{ NFS4CLNT_MANAGER_RUNNING,	"MANAGER_RUNNING" }, \
-		{ NFS4CLNT_CHECK_LEASE,		"CHECK_LEASE" }, \
-		{ NFS4CLNT_LEASE_EXPIRED,	"LEASE_EXPIRED" }, \
-		{ NFS4CLNT_RECLAIM_REBOOT,	"RECLAIM_REBOOT" }, \
-		{ NFS4CLNT_RECLAIM_NOGRACE,	"RECLAIM_NOGRACE" }, \
-		{ NFS4CLNT_DELEGRETURN,		"DELEGRETURN" }, \
-		{ NFS4CLNT_SESSION_RESET,	"SESSION_RESET" }, \
-		{ NFS4CLNT_LEASE_CONFIRM,	"LEASE_CONFIRM" }, \
-		{ NFS4CLNT_SERVER_SCOPE_MISMATCH, \
-						"SERVER_SCOPE_MISMATCH" }, \
-		{ NFS4CLNT_PURGE_STATE,		"PURGE_STATE" }, \
-		{ NFS4CLNT_BIND_CONN_TO_SESSION, \
-						"BIND_CONN_TO_SESSION" }, \
-		{ NFS4CLNT_MOVED,		"MOVED" }, \
-		{ NFS4CLNT_LEASE_MOVED,		"LEASE_MOVED" }, \
-		{ NFS4CLNT_DELEGATION_EXPIRED,	"DELEGATION_EXPIRED" }, \
-		{ NFS4CLNT_RUN_MANAGER,		"RUN_MANAGER" }, \
-		{ NFS4CLNT_RECALL_RUNNING,	"RECALL_RUNNING" }, \
-		{ NFS4CLNT_RECALL_ANY_LAYOUT_READ, "RECALL_ANY_LAYOUT_READ" }, \
-		{ NFS4CLNT_RECALL_ANY_LAYOUT_RW, "RECALL_ANY_LAYOUT_RW" })
+	{ BIT(NFS4CLNT_MANAGER_RUNNING),	"MANAGER_RUNNING" }, \
+	{ BIT(NFS4CLNT_CHECK_LEASE),		"CHECK_LEASE" }, \
+	{ BIT(NFS4CLNT_LEASE_EXPIRED),	"LEASE_EXPIRED" }, \
+	{ BIT(NFS4CLNT_RECLAIM_REBOOT),	"RECLAIM_REBOOT" }, \
+	{ BIT(NFS4CLNT_RECLAIM_NOGRACE),	"RECLAIM_NOGRACE" }, \
+	{ BIT(NFS4CLNT_DELEGRETURN),		"DELEGRETURN" }, \
+	{ BIT(NFS4CLNT_SESSION_RESET),	"SESSION_RESET" }, \
+	{ BIT(NFS4CLNT_LEASE_CONFIRM),	"LEASE_CONFIRM" }, \
+	{ BIT(NFS4CLNT_SERVER_SCOPE_MISMATCH),	"SERVER_SCOPE_MISMATCH" }, \
+	{ BIT(NFS4CLNT_PURGE_STATE),		"PURGE_STATE" }, \
+	{ BIT(NFS4CLNT_BIND_CONN_TO_SESSION),	"BIND_CONN_TO_SESSION" }, \
+	{ BIT(NFS4CLNT_MOVED),		"MOVED" }, \
+	{ BIT(NFS4CLNT_LEASE_MOVED),		"LEASE_MOVED" }, \
+	{ BIT(NFS4CLNT_DELEGATION_EXPIRED),	"DELEGATION_EXPIRED" }, \
+	{ BIT(NFS4CLNT_RUN_MANAGER),		"RUN_MANAGER" }, \
+	{ BIT(NFS4CLNT_MANAGER_AVAILABLE), "MANAGER_AVAILABLE" }, \
+	{ BIT(NFS4CLNT_RECALL_RUNNING),	"RECALL_RUNNING" }, \
+	{ BIT(NFS4CLNT_RECALL_ANY_LAYOUT_READ), "RECALL_ANY_LAYOUT_READ" }, \
+	{ BIT(NFS4CLNT_RECALL_ANY_LAYOUT_RW), "RECALL_ANY_LAYOUT_RW" }, \
+	{ BIT(NFS4CLNT_DELEGRETURN_DELAYED), "DELERETURN_DELAYED" })
 
 TRACE_EVENT(nfs4_state_mgr,
 		TP_PROTO(
diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index a97873f2d22b..2673019d30ec 100644
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
index 0a900b9e39ea..57af9c30eb48 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1088,8 +1088,10 @@ nfsd4_verify_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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
index 192cad0662d8..b1e32ec4a9d4 100644
--- a/fs/ocfs2/move_extents.c
+++ b/fs/ocfs2/move_extents.c
@@ -105,14 +105,6 @@ static int __ocfs2_move_extent(handle_t *handle,
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
@@ -121,8 +113,6 @@ static int __ocfs2_move_extent(handle_t *handle,
 		goto out;
 	}
 
-	ocfs2_journal_dirty(handle, context->et.et_root_bh);
-
 	context->new_phys_cpos = new_p_cpos;
 
 	/*
@@ -444,7 +434,7 @@ static int ocfs2_find_victim_alloc_group(struct inode *inode,
 			bg = (struct ocfs2_group_desc *)gd_bh->b_data;
 
 			if (vict_blkno < (le64_to_cpu(bg->bg_blkno) +
-						le16_to_cpu(bg->bg_bits))) {
+						(le16_to_cpu(bg->bg_bits) << bits_per_unit))) {
 
 				*ret_bh = gd_bh;
 				*vict_bit = (vict_blkno - blkno) >>
@@ -559,6 +549,7 @@ static void ocfs2_probe_alloc_group(struct inode *inode, struct buffer_head *bh,
 			last_free_bits++;
 
 		if (last_free_bits == move_len) {
+			i -= move_len;
 			*goal_bit = i;
 			*phys_cpos = base_cpos + i;
 			break;
@@ -1030,18 +1021,19 @@ int ocfs2_ioctl_move_extents(struct file *filp, void __user *argp)
 
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
diff --git a/fs/udf/file.c b/fs/udf/file.c
index 1baff8ddb754..83410fe1d16c 100644
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
index d2488b7e54a5..a151e04856af 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -525,8 +525,10 @@ static int udf_do_extend_file(struct inode *inode,
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
@@ -560,7 +562,7 @@ static int udf_do_extend_file(struct inode *inode,
 		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
-			return err;
+			goto out_err;
 		count++;
 	}
 	if (new_block_bytes) {
@@ -569,7 +571,7 @@ static int udf_do_extend_file(struct inode *inode,
 		err = udf_add_aext(inode, last_pos, &last_ext->extLocation,
 				   last_ext->extLength, 1);
 		if (err)
-			return err;
+			goto out_err;
 		count++;
 	}
 
@@ -583,6 +585,11 @@ static int udf_do_extend_file(struct inode *inode,
 		return -EIO;
 
 	return count;
+out_err:
+	/* Remove extents we've created so far */
+	udf_clear_extent_cache(inode);
+	udf_truncate_extents(inode);
+	return err;
 }
 
 /* Extend the final block of the file to final_block_len bytes */
@@ -797,19 +804,17 @@ static sector_t inode_getblk(struct inode *inode, sector_t block,
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
@@ -1086,23 +1091,8 @@ static void udf_merge_extents(struct inode *inode, struct kernel_long_ad *laarr,
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
@@ -1393,6 +1383,7 @@ static int udf_read_inode(struct inode *inode, bool hidden_inode)
 		ret = -EIO;
 		goto out;
 	}
+	iinfo->i_hidden = hidden_inode;
 	iinfo->i_unique = 0;
 	iinfo->i_lenEAttr = 0;
 	iinfo->i_lenExtents = 0;
@@ -1728,8 +1719,12 @@ static int udf_update_inode(struct inode *inode, int do_sync)
 
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
 
@@ -1900,8 +1895,13 @@ struct inode *__udf_iget(struct super_block *sb, struct kernel_lb_addr *ino,
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
index aa2f6093d3f6..6b85c66722d3 100644
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
index 06ff7006b822..312b7c9ef10e 100644
--- a/fs/udf/udf_i.h
+++ b/fs/udf/udf_i.h
@@ -44,7 +44,8 @@ struct udf_inode_info {
 	unsigned		i_use : 1;	/* unallocSpaceEntry */
 	unsigned		i_strat4096 : 1;
 	unsigned		i_streamdir : 1;
-	unsigned		reserved : 25;
+	unsigned		i_hidden : 1;	/* hidden system inode */
+	unsigned		reserved : 24;
 	__u8			*i_data;
 	struct kernel_lb_addr	i_locStreamdir;
 	__u64			i_lenStreams;
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 4fa620543d30..2205859731dc 100644
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
diff --git a/include/drm/drm_mipi_dsi.h b/include/drm/drm_mipi_dsi.h
index af7ba8071eb0..1d263eb0b2e1 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -288,6 +288,10 @@ int mipi_dsi_dcs_set_display_brightness(struct mipi_dsi_device *dsi,
 					u16 brightness);
 int mipi_dsi_dcs_get_display_brightness(struct mipi_dsi_device *dsi,
 					u16 *brightness);
+int mipi_dsi_dcs_set_display_brightness_large(struct mipi_dsi_device *dsi,
+					     u16 brightness);
+int mipi_dsi_dcs_get_display_brightness_large(struct mipi_dsi_device *dsi,
+					     u16 *brightness);
 
 /**
  * struct mipi_dsi_driver - DSI driver
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 2d7df5cea249..a23a5aea9c81 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -484,6 +484,7 @@ int acpi_dev_get_resources(struct acpi_device *adev, struct list_head *list,
 			   void *preproc_data);
 int acpi_dev_get_dma_resources(struct acpi_device *adev,
 			       struct list_head *list);
+int acpi_dev_get_memory_resources(struct acpi_device *adev, struct list_head *list);
 int acpi_dev_filter_resource_type(struct acpi_resource *ares,
 				  unsigned long types);
 
diff --git a/include/linux/hid.h b/include/linux/hid.h
index 26742ca14609..3cfbffd94a05 100644
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -599,6 +599,7 @@ struct hid_device {							/* device report descriptor */
 	unsigned long status;						/* see STAT flags above */
 	unsigned claimed;						/* Claimed by hidinput, hiddev? */
 	unsigned quirks;						/* Various quirks the device can pull on us */
+	unsigned initial_quirks;					/* Initial set of quirks supplied when creating device */
 	bool io_started;						/* If IO has started */
 
 	struct list_head inputs;					/* The list of inputs */
diff --git a/include/linux/ima.h b/include/linux/ima.h
index b6ab66a546ae..6e1bca75c73b 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -21,7 +21,8 @@ extern int ima_file_check(struct file *file, int mask);
 extern void ima_post_create_tmpfile(struct user_namespace *mnt_userns,
 				    struct inode *inode);
 extern void ima_file_free(struct file *file);
-extern int ima_file_mmap(struct file *file, unsigned long prot);
+extern int ima_file_mmap(struct file *file, unsigned long reqprot,
+			 unsigned long prot, unsigned long flags);
 extern int ima_file_mprotect(struct vm_area_struct *vma, unsigned long prot);
 extern int ima_load_data(enum kernel_load_data_id id, bool contents);
 extern int ima_post_load_data(char *buf, loff_t size,
@@ -91,7 +92,8 @@ static inline void ima_file_free(struct file *file)
 	return;
 }
 
-static inline int ima_file_mmap(struct file *file, unsigned long prot)
+static inline int ima_file_mmap(struct file *file, unsigned long reqprot,
+				unsigned long prot, unsigned long flags)
 {
 	return 0;
 }
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index 81da7107e3bd..0cf00786a164 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -515,9 +515,6 @@ struct context_entry {
 	u64 hi;
 };
 
-/* si_domain contains mulitple devices */
-#define DOMAIN_FLAG_STATIC_IDENTITY		BIT(0)
-
 /*
  * When VT-d works in the scalable mode, it allows DMA translation to
  * happen through either first level or second level page table. This
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 69ae6b278464..f9460fbea0a8 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -72,7 +72,7 @@ extern unsigned int kstat_irqs_usr(unsigned int irq);
 /*
  * Number of interrupts per cpu, since bootup
  */
-static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
+static inline unsigned long kstat_cpu_irqs_sum(unsigned int cpu)
 {
 	return kstat_cpu(cpu).irqs_sum;
 }
diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index ea30529fba08..d38916e598a5 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -116,7 +116,7 @@ extern void kobject_put(struct kobject *kobj);
 extern const void *kobject_namespace(struct kobject *kobj);
 extern void kobject_get_ownership(struct kobject *kobj,
 				  kuid_t *uid, kgid_t *gid);
-extern char *kobject_get_path(struct kobject *kobj, gfp_t flag);
+extern char *kobject_get_path(const struct kobject *kobj, gfp_t flag);
 
 /**
  * kobject_has_children - Returns whether a kobject has children.
diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index ef8c7accbc68..2cbb6a51c291 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -349,6 +349,8 @@ extern int proc_kprobes_optimization_handler(struct ctl_table *table,
 					     size_t *length, loff_t *ppos);
 #endif
 extern void wait_for_kprobe_optimizer(void);
+bool optprobe_queued_unopt(struct optimized_kprobe *op);
+bool kprobe_disarmed(struct kprobe *p);
 #else
 static inline void wait_for_kprobe_optimizer(void) { }
 #endif /* CONFIG_OPTPROBES */
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 783f871b4e12..7fcd56c6ded6 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1806,6 +1806,8 @@ struct nfs_rpc_ops {
 	struct nfs_server *(*clone_server)(struct nfs_server *, struct nfs_fh *,
 					   struct nfs_fattr *, rpc_authflavor_t);
 	int	(*discover_trunking)(struct nfs_server *, struct nfs_fh *);
+	void	(*enable_swap)(struct inode *inode);
+	void	(*disable_swap)(struct inode *inode);
 };
 
 /*
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 434d12fe2d4f..13bddb841ceb 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -193,6 +193,7 @@ void synchronize_rcu_tasks_rude(void);
 
 #define rcu_note_voluntary_context_switch(t) rcu_tasks_qs(t, false)
 void exit_tasks_rcu_start(void);
+void exit_tasks_rcu_stop(void);
 void exit_tasks_rcu_finish(void);
 #else /* #ifdef CONFIG_TASKS_RCU_GENERIC */
 #define rcu_tasks_qs(t, preempt) do { } while (0)
@@ -200,6 +201,7 @@ void exit_tasks_rcu_finish(void);
 #define call_rcu_tasks call_rcu
 #define synchronize_rcu_tasks synchronize_rcu
 static inline void exit_tasks_rcu_start(void) { }
+static inline void exit_tasks_rcu_stop(void) { }
 static inline void exit_tasks_rcu_finish(void) { }
 #endif /* #else #ifdef CONFIG_TASKS_RCU_GENERIC */
 
@@ -311,11 +313,18 @@ static inline int rcu_read_lock_any_held(void)
  * RCU_LOCKDEP_WARN - emit lockdep splat if specified condition is met
  * @c: condition to check
  * @s: informative message
+ *
+ * This checks debug_lockdep_rcu_enabled() before checking (c) to
+ * prevent early boot splats due to lockdep not yet being initialized,
+ * and rechecks it after checking (c) to prevent false-positive splats
+ * due to races with lockdep being disabled.  See commit 3066820034b5dd
+ * ("rcu: Reject RCU_LOCKDEP_WARN() false positives") for more detail.
  */
 #define RCU_LOCKDEP_WARN(c, s)						\
 	do {								\
 		static bool __section(".data.unlikely") __warned;	\
-		if ((c) && debug_lockdep_rcu_enabled() && !__warned) {	\
+		if (debug_lockdep_rcu_enabled() && (c) &&		\
+		    debug_lockdep_rcu_enabled() && !__warned) {		\
 			__warned = true;				\
 			lockdep_rcu_suspicious(__FILE__, __LINE__, s);	\
 		}							\
diff --git a/include/linux/transport_class.h b/include/linux/transport_class.h
index 63076fb835e3..2efc271a96fa 100644
--- a/include/linux/transport_class.h
+++ b/include/linux/transport_class.h
@@ -70,8 +70,14 @@ void transport_destroy_device(struct device *);
 static inline int
 transport_register_device(struct device *dev)
 {
+	int ret;
+
 	transport_setup_device(dev);
-	return transport_add_device(dev);
+	ret = transport_add_device(dev);
+	if (ret)
+		transport_destroy_device(dev);
+
+	return ret;
 }
 
 static inline void
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index ac0394087f7d..e1d59ca6530d 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -338,6 +338,10 @@ copy_struct_from_user(void *dst, size_t ksize, const void __user *src,
 	size_t size = min(ksize, usize);
 	size_t rest = max(ksize, usize) - size;
 
+	/* Double check if ksize is larger than a known object size. */
+	if (WARN_ON_ONCE(ksize > __builtin_object_size(dst, 1)))
+		return -E2BIG;
+
 	/* Deal with trailing bytes. */
 	if (usize < ksize) {
 		memset(dst + size, 0, rest);
diff --git a/include/net/sock.h b/include/net/sock.h
index cd6f2ae28ecf..3a4e81399edc 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1847,7 +1847,12 @@ void sk_common_release(struct sock *sk);
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
diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index c3039e97929a..32e93d55acf7 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -16,6 +16,7 @@
 #include <sound/asoc.h>
 
 struct device;
+struct snd_pcm_substream;
 struct snd_soc_pcm_runtime;
 struct soc_enum;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 51d6fbe17f7f..ed17850b3c51 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -486,6 +486,7 @@ struct io_poll_iocb {
 	struct file			*file;
 	struct wait_queue_head		*head;
 	__poll_t			events;
+	int				retries;
 	struct wait_queue_entry		wait;
 };
 
@@ -2463,6 +2464,15 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 
 static inline bool io_run_task_work(void)
 {
+	/*
+	 * PF_IO_WORKER never returns to userspace, so check here if we have
+	 * notify work that needs processing.
+	 */
+	if (current->flags & PF_IO_WORKER &&
+	    test_thread_flag(TIF_NOTIFY_RESUME)) {
+		__set_current_state(TASK_RUNNING);
+		tracehook_notify_resume(NULL);
+	}
 	if (test_thread_flag(TIF_NOTIFY_SIGNAL) || current->task_works) {
 		__set_current_state(TASK_RUNNING);
 		tracehook_notify_signal();
@@ -5132,7 +5142,7 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 	sr->bgid = READ_ONCE(sqe->buf_group);
-	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
@@ -5885,6 +5895,14 @@ enum {
 	IO_APOLL_READY
 };
 
+/*
+ * We can't reliably detect loops in repeated poll triggers and issue
+ * subsequently failing. But rather than fail these immediately, allow a
+ * certain amount of retries before we give up. Given that this condition
+ * should _rarely_ trigger even once, we should be fine with a larger value.
+ */
+#define APOLL_MAX_RETRY		128
+
 static int io_arm_poll_handler(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
@@ -5896,8 +5914,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 
 	if (!req->file || !file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
-	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
-		return IO_APOLL_ABORTED;
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
 
@@ -5915,8 +5931,13 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	if (req->flags & REQ_F_POLLED) {
 		apoll = req->apoll;
 		kfree(apoll->double_poll);
+		if (unlikely(!--apoll->poll.retries)) {
+			apoll->double_poll = NULL;
+			return IO_APOLL_ABORTED;
+		}
 	} else {
 		apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+		apoll->poll.retries = APOLL_MAX_RETRY;
 	}
 	if (unlikely(!apoll))
 		return IO_APOLL_ABORTED;
@@ -9219,14 +9240,17 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 	pret = pin_user_pages(ubuf, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
 			      pages, vmas);
 	if (pret == nr_pages) {
+		struct file *file = vmas[0]->vm_file;
+
 		/* don't support file backed memory */
 		for (i = 0; i < nr_pages; i++) {
-			struct vm_area_struct *vma = vmas[i];
-
-			if (vma_is_shmem(vma))
+			if (vmas[i]->vm_file != file) {
+				ret = -EINVAL;
+				break;
+			}
+			if (!file)
 				continue;
-			if (vma->vm_file &&
-			    !is_file_hugepages(vma->vm_file)) {
+			if (!vma_is_shmem(vmas[i]) && !is_file_hugepages(file)) {
 				ret = -EOPNOTSUPP;
 				break;
 			}
@@ -9852,6 +9876,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 			while (!list_empty_careful(&ctx->iopoll_list)) {
 				io_iopoll_try_reap_events(ctx);
 				ret = true;
+				cond_resched();
 			}
 		}
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0c2fa93bd8d2..1f9369b677fe 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4468,6 +4468,7 @@ btf_get_prog_ctx_type(struct bpf_verifier_log *log, const struct btf *btf,
 	if (!ctx_struct)
 		/* should not happen */
 		return NULL;
+again:
 	ctx_tname = btf_name_by_offset(btf_vmlinux, ctx_struct->name_off);
 	if (!ctx_tname) {
 		/* should not happen */
@@ -4481,8 +4482,16 @@ btf_get_prog_ctx_type(struct bpf_verifier_log *log, const struct btf *btf,
 	 * int socket_filter_bpf_prog(struct __sk_buff *skb)
 	 * { // no fields of skb are ever used }
 	 */
-	if (strcmp(ctx_tname, tname))
-		return NULL;
+	if (strcmp(ctx_tname, tname)) {
+		/* bpf_user_pt_regs_t is a typedef, so resolve it to
+		 * underlying struct and check name again
+		 */
+		if (!btf_type_is_modifier(ctx_struct))
+			return NULL;
+		while (btf_type_is_modifier(ctx_struct))
+			ctx_struct = btf_type_by_id(btf_vmlinux, ctx_struct->type);
+		goto again;
+	}
 	return ctx_type;
 }
 
diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
index b1e6ca98d0af..298f9c12023c 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -123,23 +123,12 @@ void irq_domain_free_fwnode(struct fwnode_handle *fwnode)
 }
 EXPORT_SYMBOL_GPL(irq_domain_free_fwnode);
 
-/**
- * __irq_domain_add() - Allocate a new irq_domain data structure
- * @fwnode: firmware node for the interrupt controller
- * @size: Size of linear map; 0 for radix mapping only
- * @hwirq_max: Maximum number of interrupts supported by controller
- * @direct_max: Maximum value of direct maps; Use ~0 for no limit; 0 for no
- *              direct mapping
- * @ops: domain callbacks
- * @host_data: Controller private data pointer
- *
- * Allocates and initializes an irq_domain structure.
- * Returns pointer to IRQ domain, or NULL on failure.
- */
-struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int size,
-				    irq_hw_number_t hwirq_max, int direct_max,
-				    const struct irq_domain_ops *ops,
-				    void *host_data)
+static struct irq_domain *__irq_domain_create(struct fwnode_handle *fwnode,
+					      unsigned int size,
+					      irq_hw_number_t hwirq_max,
+					      int direct_max,
+					      const struct irq_domain_ops *ops,
+					      void *host_data)
 {
 	struct irqchip_fwid *fwid;
 	struct irq_domain *domain;
@@ -227,12 +216,44 @@ struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int s
 
 	irq_domain_check_hierarchy(domain);
 
+	return domain;
+}
+
+static void __irq_domain_publish(struct irq_domain *domain)
+{
 	mutex_lock(&irq_domain_mutex);
 	debugfs_add_domain_dir(domain);
 	list_add(&domain->link, &irq_domain_list);
 	mutex_unlock(&irq_domain_mutex);
 
 	pr_debug("Added domain %s\n", domain->name);
+}
+
+/**
+ * __irq_domain_add() - Allocate a new irq_domain data structure
+ * @fwnode: firmware node for the interrupt controller
+ * @size: Size of linear map; 0 for radix mapping only
+ * @hwirq_max: Maximum number of interrupts supported by controller
+ * @direct_max: Maximum value of direct maps; Use ~0 for no limit; 0 for no
+ *              direct mapping
+ * @ops: domain callbacks
+ * @host_data: Controller private data pointer
+ *
+ * Allocates and initializes an irq_domain structure.
+ * Returns pointer to IRQ domain, or NULL on failure.
+ */
+struct irq_domain *__irq_domain_add(struct fwnode_handle *fwnode, unsigned int size,
+				    irq_hw_number_t hwirq_max, int direct_max,
+				    const struct irq_domain_ops *ops,
+				    void *host_data)
+{
+	struct irq_domain *domain;
+
+	domain = __irq_domain_create(fwnode, size, hwirq_max, direct_max,
+				     ops, host_data);
+	if (domain)
+		__irq_domain_publish(domain);
+
 	return domain;
 }
 EXPORT_SYMBOL_GPL(__irq_domain_add);
@@ -538,6 +559,9 @@ static void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 		return;
 
 	hwirq = irq_data->hwirq;
+
+	mutex_lock(&irq_domain_mutex);
+
 	irq_set_status_flags(irq, IRQ_NOREQUEST);
 
 	/* remove chip and handler */
@@ -557,10 +581,12 @@ static void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 
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
@@ -573,7 +599,6 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 	if (WARN(irq_data->domain, "error: virq%i is already associated", virq))
 		return -EINVAL;
 
-	mutex_lock(&irq_domain_mutex);
 	irq_data->hwirq = hwirq;
 	irq_data->domain = domain;
 	if (domain->ops->map) {
@@ -590,7 +615,6 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 			}
 			irq_data->domain = NULL;
 			irq_data->hwirq = 0;
-			mutex_unlock(&irq_domain_mutex);
 			return ret;
 		}
 
@@ -601,12 +625,23 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 
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
@@ -668,6 +703,34 @@ unsigned int irq_create_direct_mapping(struct irq_domain *domain)
 EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
 #endif
 
+static unsigned int __irq_create_mapping_affinity(struct irq_domain *domain,
+						  irq_hw_number_t hwirq,
+						  const struct irq_affinity_desc *affinity)
+{
+	struct device_node *of_node = irq_domain_get_of_node(domain);
+	int virq;
+
+	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
+
+	/* Allocate a virtual interrupt number */
+	virq = irq_domain_alloc_descs(-1, 1, hwirq, of_node_to_nid(of_node),
+				      affinity);
+	if (virq <= 0) {
+		pr_debug("-> virq allocation failed\n");
+		return 0;
+	}
+
+	if (irq_domain_associate(domain, virq, hwirq)) {
+		irq_free_desc(virq);
+		return 0;
+	}
+
+	pr_debug("irq %lu on domain %s mapped to virtual irq %u\n",
+		hwirq, of_node_full_name(of_node), virq);
+
+	return virq;
+}
+
 /**
  * irq_create_mapping_affinity() - Map a hardware interrupt into linux irq space
  * @domain: domain owning this hardware interrupt or NULL for default domain
@@ -680,14 +743,11 @@ EXPORT_SYMBOL_GPL(irq_create_direct_mapping);
  * on the number returned from that call.
  */
 unsigned int irq_create_mapping_affinity(struct irq_domain *domain,
-				       irq_hw_number_t hwirq,
-				       const struct irq_affinity_desc *affinity)
+					 irq_hw_number_t hwirq,
+					 const struct irq_affinity_desc *affinity)
 {
-	struct device_node *of_node;
 	int virq;
 
-	pr_debug("irq_create_mapping(0x%p, 0x%lx)\n", domain, hwirq);
-
 	/* Look for default domain if necessary */
 	if (domain == NULL)
 		domain = irq_default_domain;
@@ -695,34 +755,15 @@ unsigned int irq_create_mapping_affinity(struct irq_domain *domain,
 		WARN(1, "%s(, %lx) called with NULL domain\n", __func__, hwirq);
 		return 0;
 	}
-	pr_debug("-> using domain @%p\n", domain);
-
-	of_node = irq_domain_get_of_node(domain);
 
 	/* Check if mapping already exists */
 	virq = irq_find_mapping(domain, hwirq);
 	if (virq) {
-		pr_debug("-> existing mapping on virq %d\n", virq);
+		pr_debug("existing mapping on virq %d\n", virq);
 		return virq;
 	}
 
-	/* Allocate a virtual interrupt number */
-	virq = irq_domain_alloc_descs(-1, 1, hwirq, of_node_to_nid(of_node),
-				      affinity);
-	if (virq <= 0) {
-		pr_debug("-> virq allocation failed\n");
-		return 0;
-	}
-
-	if (irq_domain_associate(domain, virq, hwirq)) {
-		irq_free_desc(virq);
-		return 0;
-	}
-
-	pr_debug("irq %lu on domain %s mapped to virtual irq %u\n",
-		hwirq, of_node_full_name(of_node), virq);
-
-	return virq;
+	return __irq_create_mapping_affinity(domain, hwirq, affinity);
 }
 EXPORT_SYMBOL_GPL(irq_create_mapping_affinity);
 
@@ -827,19 +868,14 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
 			return 0;
 	} else {
 		/* Create mapping */
-		virq = irq_create_mapping(domain, hwirq);
+		virq = __irq_create_mapping_affinity(domain, hwirq, NULL);
 		if (!virq)
 			return virq;
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
@@ -1102,12 +1138,15 @@ struct irq_domain *irq_domain_create_hierarchy(struct irq_domain *parent,
 	struct irq_domain *domain;
 
 	if (size)
-		domain = irq_domain_create_linear(fwnode, size, ops, host_data);
+		domain = __irq_domain_create(fwnode, size, size, 0, ops, host_data);
 	else
-		domain = irq_domain_create_tree(fwnode, ops, host_data);
+		domain = __irq_domain_create(fwnode, 0, ~0, 0, ops, host_data);
+
 	if (domain) {
 		domain->parent = parent;
 		domain->flags |= flags;
+
+		__irq_domain_publish(domain);
 	}
 
 	return domain;
diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 8818f3a89fef..7e9fa1b7ff67 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -451,8 +451,8 @@ static inline int kprobe_optready(struct kprobe *p)
 	return 0;
 }
 
-/* Return true(!0) if the kprobe is disarmed. Note: p must be on hash list */
-static inline int kprobe_disarmed(struct kprobe *p)
+/* Return true if the kprobe is disarmed. Note: p must be on hash list */
+bool kprobe_disarmed(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -656,7 +656,7 @@ void wait_for_kprobe_optimizer(void)
 	mutex_unlock(&kprobe_mutex);
 }
 
-static bool optprobe_queued_unopt(struct optimized_kprobe *op)
+bool optprobe_queued_unopt(struct optimized_kprobe *op)
 {
 	struct optimized_kprobe *_op;
 
diff --git a/kernel/locking/rwsem.c b/kernel/locking/rwsem.c
index 4cc73e6f8974..de375feada51 100644
--- a/kernel/locking/rwsem.c
+++ b/kernel/locking/rwsem.c
@@ -586,18 +586,16 @@ static inline bool rwsem_try_write_lock(struct rw_semaphore *sem,
 			 */
 			if (first->handoff_set && (waiter != first))
 				return false;
-
-			/*
-			 * First waiter can inherit a previously set handoff
-			 * bit and spin on rwsem if lock acquisition fails.
-			 */
-			if (waiter == first)
-				waiter->handoff_set = true;
 		}
 
 		new = count;
 
 		if (count & RWSEM_LOCK_MASK) {
+			/*
+			 * A waiter (first or not) can set the handoff bit
+			 * if it is an RT task or wait in the wait queue
+			 * for too long.
+			 */
 			if (has_handoff || (!rt_task(waiter->task) &&
 					    !time_after(jiffies, waiter->timeout)))
 				return false;
@@ -613,11 +611,12 @@ static inline bool rwsem_try_write_lock(struct rw_semaphore *sem,
 	} while (!atomic_long_try_cmpxchg_acquire(&sem->count, &count, new));
 
 	/*
-	 * We have either acquired the lock with handoff bit cleared or
-	 * set the handoff bit.
+	 * We have either acquired the lock with handoff bit cleared or set
+	 * the handoff bit. Only the first waiter can have its handoff_set
+	 * set here to enable optimistic spinning in slowpath loop.
 	 */
 	if (new & RWSEM_FLAG_HANDOFF) {
-		waiter->handoff_set = true;
+		first->handoff_set = true;
 		lockevent_inc(rwsem_wlock_handoff);
 		return false;
 	}
@@ -1045,7 +1044,7 @@ rwsem_down_read_slowpath(struct rw_semaphore *sem, long count, unsigned int stat
 			/* Ordered by sem->wait_lock against rwsem_mark_wake(). */
 			break;
 		}
-		schedule();
+		schedule_preempt_disabled();
 		lockevent_inc(rwsem_sleep_reader);
 	}
 
@@ -1224,14 +1223,20 @@ static struct rw_semaphore *rwsem_downgrade_wake(struct rw_semaphore *sem)
  */
 static inline int __down_read_common(struct rw_semaphore *sem, int state)
 {
+	int ret = 0;
 	long count;
 
+	preempt_disable();
 	if (!rwsem_read_trylock(sem, &count)) {
-		if (IS_ERR(rwsem_down_read_slowpath(sem, count, state)))
-			return -EINTR;
+		if (IS_ERR(rwsem_down_read_slowpath(sem, count, state))) {
+			ret = -EINTR;
+			goto out;
+		}
 		DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
 	}
-	return 0;
+out:
+	preempt_enable();
+	return ret;
 }
 
 static inline void __down_read(struct rw_semaphore *sem)
@@ -1251,22 +1256,23 @@ static inline int __down_read_killable(struct rw_semaphore *sem)
 
 static inline int __down_read_trylock(struct rw_semaphore *sem)
 {
+	int ret = 0;
 	long tmp;
 
 	DEBUG_RWSEMS_WARN_ON(sem->magic != sem, sem);
 
-	/*
-	 * Optimize for the case when the rwsem is not locked at all.
-	 */
-	tmp = RWSEM_UNLOCKED_VALUE;
-	do {
+	preempt_disable();
+	tmp = atomic_long_read(&sem->count);
+	while (!(tmp & RWSEM_READ_FAILED_MASK)) {
 		if (atomic_long_try_cmpxchg_acquire(&sem->count, &tmp,
-					tmp + RWSEM_READER_BIAS)) {
+						    tmp + RWSEM_READER_BIAS)) {
 			rwsem_set_reader_owned(sem);
-			return 1;
+			ret = 1;
+			break;
 		}
-	} while (!(tmp & RWSEM_READ_FAILED_MASK));
-	return 0;
+	}
+	preempt_enable();
+	return ret;
 }
 
 /*
@@ -1308,6 +1314,7 @@ static inline void __up_read(struct rw_semaphore *sem)
 	DEBUG_RWSEMS_WARN_ON(sem->magic != sem, sem);
 	DEBUG_RWSEMS_WARN_ON(!is_rwsem_reader_owned(sem), sem);
 
+	preempt_disable();
 	rwsem_clear_reader_owned(sem);
 	tmp = atomic_long_add_return_release(-RWSEM_READER_BIAS, &sem->count);
 	DEBUG_RWSEMS_WARN_ON(tmp < 0, sem);
@@ -1316,6 +1323,7 @@ static inline void __up_read(struct rw_semaphore *sem)
 		clear_nonspinnable(sem);
 		rwsem_wake(sem);
 	}
+	preempt_enable();
 }
 
 /*
@@ -1633,6 +1641,12 @@ void down_read_non_owner(struct rw_semaphore *sem)
 {
 	might_sleep();
 	__down_read(sem);
+	/*
+	 * The owner value for a reader-owned lock is mostly for debugging
+	 * purpose only and is not critical to the correct functioning of
+	 * rwsem. So it is perfectly fine to set it in a preempt-enabled
+	 * context here.
+	 */
 	__rwsem_set_reader_owned(sem, NULL);
 }
 EXPORT_SYMBOL(down_read_non_owner);
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index a46a3723bc66..259fc4ca0d9c 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -244,7 +244,24 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (pid_ns->pid_allocated == init_pids)
 			break;
+		/*
+		 * Release tasks_rcu_exit_srcu to avoid following deadlock:
+		 *
+		 * 1) TASK A unshare(CLONE_NEWPID)
+		 * 2) TASK A fork() twice -> TASK B (child reaper for new ns)
+		 *    and TASK C
+		 * 3) TASK B exits, kills TASK C, waits for TASK A to reap it
+		 * 4) TASK A calls synchronize_rcu_tasks()
+		 *                   -> synchronize_srcu(tasks_rcu_exit_srcu)
+		 * 5) *DEADLOCK*
+		 *
+		 * It is considered safe to release tasks_rcu_exit_srcu here
+		 * because we assume the current task can not be concurrently
+		 * reaped at this point.
+		 */
+		exit_tasks_rcu_stop();
 		schedule();
+		exit_tasks_rcu_start();
 	}
 	__set_current_state(TASK_RUNNING);
 
diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index 97e62469a6b3..1b902f986f91 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -85,10 +85,7 @@ static void em_debug_create_pd(struct device *dev)
 
 static void em_debug_remove_pd(struct device *dev)
 {
-	struct dentry *debug_dir;
-
-	debug_dir = debugfs_lookup(dev_name(dev), rootdir);
-	debugfs_remove_recursive(debug_dir);
+	debugfs_lookup_and_remove(dev_name(dev), rootdir);
 }
 
 static int __init em_debug_init(void)
diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index 4bd07cc3c0ea..94b8ee84bc78 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -171,8 +171,9 @@ static void call_rcu_tasks_generic(struct rcu_head *rhp, rcu_callback_t func,
 static void synchronize_rcu_tasks_generic(struct rcu_tasks *rtp)
 {
 	/* Complain if the scheduler has not started.  */
-	WARN_ONCE(rcu_scheduler_active == RCU_SCHEDULER_INACTIVE,
-			 "synchronize_rcu_tasks called too soon");
+	if (WARN_ONCE(rcu_scheduler_active == RCU_SCHEDULER_INACTIVE,
+			 "synchronize_%s() called too soon", rtp->name))
+		return;
 
 	/* Wait for the grace period. */
 	wait_rcu_gp(rtp->call_func);
@@ -451,11 +452,21 @@ static void rcu_tasks_pertask(struct task_struct *t, struct list_head *hop)
 static void rcu_tasks_postscan(struct list_head *hop)
 {
 	/*
-	 * Wait for tasks that are in the process of exiting.  This
-	 * does only part of the job, ensuring that all tasks that were
-	 * previously exiting reach the point where they have disabled
-	 * preemption, allowing the later synchronize_rcu() to finish
-	 * the job.
+	 * Exiting tasks may escape the tasklist scan. Those are vulnerable
+	 * until their final schedule() with TASK_DEAD state. To cope with
+	 * this, divide the fragile exit path part in two intersecting
+	 * read side critical sections:
+	 *
+	 * 1) An _SRCU_ read side starting before calling exit_notify(),
+	 *    which may remove the task from the tasklist, and ending after
+	 *    the final preempt_disable() call in do_exit().
+	 *
+	 * 2) An _RCU_ read side starting with the final preempt_disable()
+	 *    call in do_exit() and ending with the final call to schedule()
+	 *    with TASK_DEAD state.
+	 *
+	 * This handles the part 1). And postgp will handle part 2) with a
+	 * call to synchronize_rcu().
 	 */
 	synchronize_srcu(&tasks_rcu_exit_srcu);
 }
@@ -522,7 +533,10 @@ static void rcu_tasks_postgp(struct rcu_tasks *rtp)
 	 *
 	 * In addition, this synchronize_rcu() waits for exiting tasks
 	 * to complete their final preempt_disable() region of execution,
-	 * cleaning up after the synchronize_srcu() above.
+	 * cleaning up after synchronize_srcu(&tasks_rcu_exit_srcu),
+	 * enforcing the whole region before tasklist removal until
+	 * the final schedule() with TASK_DEAD state to be an RCU TASKS
+	 * read side critical section.
 	 */
 	synchronize_rcu();
 }
@@ -612,27 +626,42 @@ void show_rcu_tasks_classic_gp_kthread(void)
 EXPORT_SYMBOL_GPL(show_rcu_tasks_classic_gp_kthread);
 #endif // !defined(CONFIG_TINY_RCU)
 
-/* Do the srcu_read_lock() for the above synchronize_srcu().  */
+/*
+ * Contribute to protect against tasklist scan blind spot while the
+ * task is exiting and may be removed from the tasklist. See
+ * corresponding synchronize_srcu() for further details.
+ */
 void exit_tasks_rcu_start(void) __acquires(&tasks_rcu_exit_srcu)
 {
-	preempt_disable();
 	current->rcu_tasks_idx = __srcu_read_lock(&tasks_rcu_exit_srcu);
-	preempt_enable();
 }
 
-/* Do the srcu_read_unlock() for the above synchronize_srcu().  */
-void exit_tasks_rcu_finish(void) __releases(&tasks_rcu_exit_srcu)
+/*
+ * Contribute to protect against tasklist scan blind spot while the
+ * task is exiting and may be removed from the tasklist. See
+ * corresponding synchronize_srcu() for further details.
+ */
+void exit_tasks_rcu_stop(void) __releases(&tasks_rcu_exit_srcu)
 {
 	struct task_struct *t = current;
 
-	preempt_disable();
 	__srcu_read_unlock(&tasks_rcu_exit_srcu, t->rcu_tasks_idx);
-	preempt_enable();
-	exit_tasks_rcu_finish_trace(t);
+}
+
+/*
+ * Contribute to protect against tasklist scan blind spot while the
+ * task is exiting and may be removed from the tasklist. See
+ * corresponding synchronize_srcu() for further details.
+ */
+void exit_tasks_rcu_finish(void)
+{
+	exit_tasks_rcu_stop();
+	exit_tasks_rcu_finish_trace(current);
 }
 
 #else /* #ifdef CONFIG_TASKS_RCU */
 void exit_tasks_rcu_start(void) { }
+void exit_tasks_rcu_stop(void) { }
 void exit_tasks_rcu_finish(void) { exit_tasks_rcu_finish_trace(current); }
 #endif /* #else #ifdef CONFIG_TASKS_RCU */
 
@@ -660,9 +689,6 @@ static void rcu_tasks_be_rude(struct work_struct *work)
 // Wait for one rude RCU-tasks grace period.
 static void rcu_tasks_rude_wait_gp(struct rcu_tasks *rtp)
 {
-	if (num_online_cpus() <= 1)
-		return;	// Fastpath for only one CPU.
-
 	rtp->n_ipis += cpumask_weight(cpu_online_mask);
 	schedule_on_each_cpu(rcu_tasks_be_rude);
 }
diff --git a/kernel/rcu/tree_exp.h b/kernel/rcu/tree_exp.h
index 16f94118ca34..f9fb2793b019 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -565,7 +565,9 @@ static void synchronize_rcu_expedited_wait(void)
 				mask = leaf_node_cpu_bit(rnp, cpu);
 				if (!(READ_ONCE(rnp->expmask) & mask))
 					continue;
+				preempt_disable(); // For smp_processor_id() in dump_cpu_task().
 				dump_cpu_task(cpu);
+				preempt_enable();
 			}
 		}
 		jiffies_stall = 3 * rcu_jiffies_till_stall_check() + 3;
diff --git a/kernel/resource.c b/kernel/resource.c
index 20e10e48f052..cb441e3e7670 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1325,20 +1325,6 @@ void release_mem_region_adjustable(resource_size_t start, resource_size_t size)
 			continue;
 		}
 
-		/*
-		 * All memory regions added from memory-hotplug path have the
-		 * flag IORESOURCE_SYSTEM_RAM. If the resource does not have
-		 * this flag, we know that we are dealing with a resource coming
-		 * from HMM/devm. HMM/devm use another mechanism to add/release
-		 * a resource. This goes via devm_request_mem_region and
-		 * devm_release_mem_region.
-		 * HMM/devm take care to release their resources when they want,
-		 * so if we are dealing with them, let us just back off here.
-		 */
-		if (!(res->flags & IORESOURCE_SYSRAM)) {
-			break;
-		}
-
 		if (!(res->flags & IORESOURCE_MEM))
 			break;
 
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 2a2f32eaffcc..226c814368d1 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1846,8 +1846,7 @@ static void set_next_task_dl(struct rq *rq, struct task_struct *p, bool first)
 	deadline_queue_push_tasks(rq);
 }
 
-static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
-						   struct dl_rq *dl_rq)
+static struct sched_dl_entity *pick_next_dl_entity(struct dl_rq *dl_rq)
 {
 	struct rb_node *left = rb_first_cached(&dl_rq->root);
 
@@ -1866,7 +1865,7 @@ static struct task_struct *pick_task_dl(struct rq *rq)
 	if (!sched_dl_runnable(rq))
 		return NULL;
 
-	dl_se = pick_next_dl_entity(rq, dl_rq);
+	dl_se = pick_next_dl_entity(dl_rq);
 	BUG_ON(!dl_se);
 	p = dl_task_of(dl_se);
 
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index add67f811e00..08af6076c809 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1614,8 +1614,7 @@ static inline void set_next_task_rt(struct rq *rq, struct task_struct *p, bool f
 	rt_queue_push_tasks(rq);
 }
 
-static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
-						   struct rt_rq *rt_rq)
+static struct sched_rt_entity *pick_next_rt_entity(struct rt_rq *rt_rq)
 {
 	struct rt_prio_array *array = &rt_rq->active;
 	struct sched_rt_entity *next = NULL;
@@ -1626,6 +1625,8 @@ static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
 	BUG_ON(idx >= MAX_RT_PRIO);
 
 	queue = array->queue + idx;
+	if (SCHED_WARN_ON(list_empty(queue)))
+		return NULL;
 	next = list_entry(queue->next, struct sched_rt_entity, run_list);
 
 	return next;
@@ -1637,8 +1638,9 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
 	struct rt_rq *rt_rq  = &rq->rt;
 
 	do {
-		rt_se = pick_next_rt_entity(rq, rt_rq);
-		BUG_ON(!rt_se);
+		rt_se = pick_next_rt_entity(rt_rq);
+		if (unlikely(!rt_se))
+			return NULL;
 		rt_rq = group_rt_rq(rt_se);
 	} while (rt_rq);
 
diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index bcad1a1e5dcf..97ec98041f92 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -378,6 +378,15 @@ void clocksource_verify_percpu(struct clocksource *cs)
 }
 EXPORT_SYMBOL_GPL(clocksource_verify_percpu);
 
+static inline void clocksource_reset_watchdog(void)
+{
+	struct clocksource *cs;
+
+	list_for_each_entry(cs, &watchdog_list, wd_list)
+		cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
+}
+
+
 static void clocksource_watchdog(struct timer_list *unused)
 {
 	u64 csnow, wdnow, cslast, wdlast, delta;
@@ -385,6 +394,7 @@ static void clocksource_watchdog(struct timer_list *unused)
 	int64_t wd_nsec, cs_nsec;
 	struct clocksource *cs;
 	enum wd_read_status read_ret;
+	unsigned long extra_wait = 0;
 	u32 md;
 
 	spin_lock(&watchdog_lock);
@@ -404,13 +414,30 @@ static void clocksource_watchdog(struct timer_list *unused)
 
 		read_ret = cs_watchdog_read(cs, &csnow, &wdnow);
 
-		if (read_ret != WD_READ_SUCCESS) {
-			if (read_ret == WD_READ_UNSTABLE)
-				/* Clock readout unreliable, so give it up. */
-				__clocksource_unstable(cs);
+		if (read_ret == WD_READ_UNSTABLE) {
+			/* Clock readout unreliable, so give it up. */
+			__clocksource_unstable(cs);
 			continue;
 		}
 
+		/*
+		 * When WD_READ_SKIP is returned, it means the system is likely
+		 * under very heavy load, where the latency of reading
+		 * watchdog/clocksource is very big, and affect the accuracy of
+		 * watchdog check. So give system some space and suspend the
+		 * watchdog check for 5 minutes.
+		 */
+		if (read_ret == WD_READ_SKIP) {
+			/*
+			 * As the watchdog timer will be suspended, and
+			 * cs->last could keep unchanged for 5 minutes, reset
+			 * the counters.
+			 */
+			clocksource_reset_watchdog();
+			extra_wait = HZ * 300;
+			break;
+		}
+
 		/* Clocksource initialized ? */
 		if (!(cs->flags & CLOCK_SOURCE_WATCHDOG) ||
 		    atomic_read(&watchdog_reset_pending)) {
@@ -506,7 +533,7 @@ static void clocksource_watchdog(struct timer_list *unused)
 	 * pair clocksource_stop_watchdog() clocksource_start_watchdog().
 	 */
 	if (!timer_pending(&watchdog_timer)) {
-		watchdog_timer.expires += WATCHDOG_INTERVAL;
+		watchdog_timer.expires += WATCHDOG_INTERVAL + extra_wait;
 		add_timer_on(&watchdog_timer, next_cpu);
 	}
 out:
@@ -531,14 +558,6 @@ static inline void clocksource_stop_watchdog(void)
 	watchdog_running = 0;
 }
 
-static inline void clocksource_reset_watchdog(void)
-{
-	struct clocksource *cs;
-
-	list_for_each_entry(cs, &watchdog_list, wd_list)
-		cs->flags &= ~CLOCK_SOURCE_WATCHDOG;
-}
-
 static void clocksource_resume_watchdog(void)
 {
 	atomic_inc(&watchdog_reset_pending);
diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
index 23af5eca11b1..97409581e9da 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2126,6 +2126,7 @@ SYSCALL_DEFINE2(nanosleep, struct __kernel_timespec __user *, rqtp,
 	if (!timespec64_valid(&tu))
 		return -EINVAL;
 
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 	return hrtimer_nanosleep(timespec64_to_ktime(tu), HRTIMER_MODE_REL,
@@ -2147,6 +2148,7 @@ SYSCALL_DEFINE2(nanosleep_time32, struct old_timespec32 __user *, rqtp,
 	if (!timespec64_valid(&tu))
 		return -EINVAL;
 
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
 	return hrtimer_nanosleep(timespec64_to_ktime(tu), HRTIMER_MODE_REL,
diff --git a/kernel/time/posix-stubs.c b/kernel/time/posix-stubs.c
index fcb3b21d8bdc..3783d07d60ba 100644
--- a/kernel/time/posix-stubs.c
+++ b/kernel/time/posix-stubs.c
@@ -146,6 +146,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 	texp = timespec64_to_ktime(t);
@@ -239,6 +240,7 @@ SYSCALL_DEFINE4(clock_nanosleep_time32, clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
 	texp = timespec64_to_ktime(t);
diff --git a/kernel/time/posix-timers.c b/kernel/time/posix-timers.c
index 5dead89308b7..0c8a87a11b39 100644
--- a/kernel/time/posix-timers.c
+++ b/kernel/time/posix-timers.c
@@ -1270,6 +1270,7 @@ SYSCALL_DEFINE4(clock_nanosleep, const clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 
@@ -1297,6 +1298,7 @@ SYSCALL_DEFINE4(clock_nanosleep_time32, clockid_t, which_clock, int, flags,
 		return -EINVAL;
 	if (flags & TIMER_ABSTIME)
 		rmtp = NULL;
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_COMPAT : TT_NONE;
 	current->restart_block.nanosleep.compat_rmtp = rmtp;
 
diff --git a/kernel/time/test_udelay.c b/kernel/time/test_udelay.c
index 13b11eb62685..20d5df631570 100644
--- a/kernel/time/test_udelay.c
+++ b/kernel/time/test_udelay.c
@@ -149,7 +149,7 @@ module_init(udelay_test_init);
 static void __exit udelay_test_exit(void)
 {
 	mutex_lock(&udelay_test_lock);
-	debugfs_remove(debugfs_lookup(DEBUGFS_FILENAME, NULL));
+	debugfs_lookup_and_remove(DEBUGFS_FILENAME, NULL);
 	mutex_unlock(&udelay_test_lock);
 }
 
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 16b0d3fa56e0..e6d03cf14859 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -319,8 +319,8 @@ static void blk_trace_free(struct request_queue *q, struct blk_trace *bt)
 	 * under 'q->debugfs_dir', thus lookup and remove them.
 	 */
 	if (!bt->dir) {
-		debugfs_remove(debugfs_lookup("dropped", q->debugfs_dir));
-		debugfs_remove(debugfs_lookup("msg", q->debugfs_dir));
+		debugfs_lookup_and_remove("dropped", q->debugfs_dir);
+		debugfs_lookup_and_remove("msg", q->debugfs_dir);
 	} else {
 		debugfs_remove(bt->dir);
 	}
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index ffc8696e6746..459055696355 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1544,19 +1544,6 @@ static int rb_check_bpage(struct ring_buffer_per_cpu *cpu_buffer,
 	return 0;
 }
 
-/**
- * rb_check_list - make sure a pointer to a list has the last bits zero
- */
-static int rb_check_list(struct ring_buffer_per_cpu *cpu_buffer,
-			 struct list_head *list)
-{
-	if (RB_WARN_ON(cpu_buffer, rb_list_head(list->prev) != list->prev))
-		return 1;
-	if (RB_WARN_ON(cpu_buffer, rb_list_head(list->next) != list->next))
-		return 1;
-	return 0;
-}
-
 /**
  * rb_check_pages - integrity check of buffer pages
  * @cpu_buffer: CPU buffer with pages to test
@@ -1566,36 +1553,27 @@ static int rb_check_list(struct ring_buffer_per_cpu *cpu_buffer,
  */
 static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct list_head *head = cpu_buffer->pages;
-	struct buffer_page *bpage, *tmp;
+	struct list_head *head = rb_list_head(cpu_buffer->pages);
+	struct list_head *tmp;
 
-	/* Reset the head page if it exists */
-	if (cpu_buffer->head_page)
-		rb_set_head_page(cpu_buffer);
-
-	rb_head_page_deactivate(cpu_buffer);
-
-	if (RB_WARN_ON(cpu_buffer, head->next->prev != head))
-		return -1;
-	if (RB_WARN_ON(cpu_buffer, head->prev->next != head))
+	if (RB_WARN_ON(cpu_buffer,
+			rb_list_head(rb_list_head(head->next)->prev) != head))
 		return -1;
 
-	if (rb_check_list(cpu_buffer, head))
+	if (RB_WARN_ON(cpu_buffer,
+			rb_list_head(rb_list_head(head->prev)->next) != head))
 		return -1;
 
-	list_for_each_entry_safe(bpage, tmp, head, list) {
+	for (tmp = rb_list_head(head->next); tmp != head; tmp = rb_list_head(tmp->next)) {
 		if (RB_WARN_ON(cpu_buffer,
-			       bpage->list.next->prev != &bpage->list))
+				rb_list_head(rb_list_head(tmp->next)->prev) != tmp))
 			return -1;
+
 		if (RB_WARN_ON(cpu_buffer,
-			       bpage->list.prev->next != &bpage->list))
-			return -1;
-		if (rb_check_list(cpu_buffer, &bpage->list))
+				rb_list_head(rb_list_head(tmp->prev)->next) != tmp))
 			return -1;
 	}
 
-	rb_head_page_activate(cpu_buffer);
-
 	return 0;
 }
 
diff --git a/lib/errname.c b/lib/errname.c
index 05cbf731545f..67739b174a8c 100644
--- a/lib/errname.c
+++ b/lib/errname.c
@@ -21,6 +21,7 @@ static const char *names_0[] = {
 	E(EADDRNOTAVAIL),
 	E(EADV),
 	E(EAFNOSUPPORT),
+	E(EAGAIN), /* EWOULDBLOCK */
 	E(EALREADY),
 	E(EBADE),
 	E(EBADF),
@@ -31,15 +32,17 @@ static const char *names_0[] = {
 	E(EBADSLT),
 	E(EBFONT),
 	E(EBUSY),
-#ifdef ECANCELLED
-	E(ECANCELLED),
-#endif
+	E(ECANCELED), /* ECANCELLED */
 	E(ECHILD),
 	E(ECHRNG),
 	E(ECOMM),
 	E(ECONNABORTED),
+	E(ECONNREFUSED), /* EREFUSED */
 	E(ECONNRESET),
+	E(EDEADLK), /* EDEADLOCK */
+#if EDEADLK != EDEADLOCK /* mips, sparc, powerpc */
 	E(EDEADLOCK),
+#endif
 	E(EDESTADDRREQ),
 	E(EDOM),
 	E(EDOTDOT),
@@ -166,14 +169,17 @@ static const char *names_0[] = {
 	E(EUSERS),
 	E(EXDEV),
 	E(EXFULL),
-
-	E(ECANCELED), /* ECANCELLED */
-	E(EAGAIN), /* EWOULDBLOCK */
-	E(ECONNREFUSED), /* EREFUSED */
-	E(EDEADLK), /* EDEADLOCK */
 };
 #undef E
 
+#ifdef EREFUSED /* parisc */
+static_assert(EREFUSED == ECONNREFUSED);
+#endif
+#ifdef ECANCELLED /* parisc */
+static_assert(ECANCELLED == ECANCELED);
+#endif
+static_assert(EAGAIN == EWOULDBLOCK); /* everywhere */
+
 #define E(err) [err - 512 + BUILD_BUG_ON_ZERO(err < 512 || err > 550)] = "-" #err
 static const char *names_512[] = {
 	E(ERESTARTSYS),
diff --git a/lib/kobject.c b/lib/kobject.c
index ea53b30cf483..184a3dab2699 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -126,10 +126,10 @@ static int create_dir(struct kobject *kobj)
 	return 0;
 }
 
-static int get_kobj_path_length(struct kobject *kobj)
+static int get_kobj_path_length(const struct kobject *kobj)
 {
 	int length = 1;
-	struct kobject *parent = kobj;
+	const struct kobject *parent = kobj;
 
 	/* walk up the ancestors until we hit the one pointing to the
 	 * root.
@@ -144,21 +144,25 @@ static int get_kobj_path_length(struct kobject *kobj)
 	return length;
 }
 
-static void fill_kobj_path(struct kobject *kobj, char *path, int length)
+static int fill_kobj_path(const struct kobject *kobj, char *path, int length)
 {
-	struct kobject *parent;
+	const struct kobject *parent;
 
 	--length;
 	for (parent = kobj; parent; parent = parent->parent) {
 		int cur = strlen(kobject_name(parent));
 		/* back up enough to print this name with '/' */
 		length -= cur;
+		if (length <= 0)
+			return -EINVAL;
 		memcpy(path + length, kobject_name(parent), cur);
 		*(path + --length) = '/';
 	}
 
 	pr_debug("kobject: '%s' (%p): %s: path = '%s'\n", kobject_name(kobj),
 		 kobj, __func__, path);
+
+	return 0;
 }
 
 /**
@@ -168,18 +172,22 @@ static void fill_kobj_path(struct kobject *kobj, char *path, int length)
  *
  * Return: The newly allocated memory, caller must free with kfree().
  */
-char *kobject_get_path(struct kobject *kobj, gfp_t gfp_mask)
+char *kobject_get_path(const struct kobject *kobj, gfp_t gfp_mask)
 {
 	char *path;
 	int len;
 
+retry:
 	len = get_kobj_path_length(kobj);
 	if (len == 0)
 		return NULL;
 	path = kzalloc(len, gfp_mask);
 	if (!path)
 		return NULL;
-	fill_kobj_path(kobj, path, len);
+	if (fill_kobj_path(kobj, path, len)) {
+		kfree(path);
+		goto retry;
+	}
 
 	return path;
 }
diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 39c4c6731094..3cb6bd148fa9 100644
--- a/lib/mpi/mpicoder.c
+++ b/lib/mpi/mpicoder.c
@@ -504,7 +504,8 @@ MPI mpi_read_raw_from_sgl(struct scatterlist *sgl, unsigned int nbytes)
 
 	while (sg_miter_next(&miter)) {
 		buff = miter.addr;
-		len = miter.length;
+		len = min_t(unsigned, miter.length, nbytes);
+		nbytes -= len;
 
 		for (x = 0; x < len; x++) {
 			a <<= 8;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 07941a1540cb..100f46dd79bf 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2778,6 +2778,9 @@ void deferred_split_huge_page(struct page *page)
 	if (PageSwapCache(page))
 		return;
 
+	if (!list_empty(page_deferred_list(page)))
+		return;
+
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (list_empty(page_deferred_list(page))) {
 		count_vm_event(THP_DEFERRED_SPLIT_PAGE);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3d3364cd4ff1..b68b2fe639fd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3872,6 +3872,10 @@ static int mem_cgroup_move_charge_write(struct cgroup_subsys_state *css,
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
+	pr_warn_once("Cgroup memory moving (move_charge_at_immigrate) is deprecated. "
+		     "Please report your usecase to linux-mm@kvack.org if you "
+		     "depend on this functionality.\n");
+
 	if (val & ~MOVE_MASK)
 		return -EINVAL;
 
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index e15fcf72a342..a21e086d69d0 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2683,14 +2683,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
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
@@ -2735,14 +2727,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
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
@@ -2763,14 +2747,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
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
index d2c678520599..a267c9b6bcef 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1623,6 +1623,14 @@ static struct sk_buff *l2cap_sock_alloc_skb_cb(struct l2cap_chan *chan,
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
diff --git a/net/core/scm.c b/net/core/scm.c
index 5c356f0dee30..acb7d776fa6e 100644
--- a/net/core/scm.c
+++ b/net/core/scm.c
@@ -229,6 +229,8 @@ int put_cmsg(struct msghdr * msg, int level, int type, int len, void *data)
 	if (msg->msg_control_is_user) {
 		struct cmsghdr __user *cm = msg->msg_control_user;
 
+		check_object_size(data, cmlen - sizeof(*cm), true);
+
 		if (!user_write_access_begin(cm, cmlen))
 			goto efault;
 
diff --git a/net/core/sock.c b/net/core/sock.c
index b7ac53e72d1a..ff7e8fc80731 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3118,7 +3118,7 @@ void sk_stop_timer_sync(struct sock *sk, struct timer_list *timer)
 }
 EXPORT_SYMBOL(sk_stop_timer_sync);
 
-void sock_init_data(struct socket *sock, struct sock *sk)
+void sock_init_data_uid(struct socket *sock, struct sock *sk, kuid_t uid)
 {
 	sk_init_common(sk);
 	sk->sk_send_head	=	NULL;
@@ -3137,11 +3137,10 @@ void sock_init_data(struct socket *sock, struct sock *sk)
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
@@ -3199,6 +3198,16 @@ void sock_init_data(struct socket *sock, struct sock *sk)
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
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 410b6b7998ca..39b3db5b6119 100644
--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -760,17 +760,7 @@ int __inet_hash_connect(struct inet_timewait_death_row *death_row,
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
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index bf35710127dd..9cef8e080f64 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -651,54 +651,22 @@ static int pppol2tp_tunnel_mtu(const struct l2tp_tunnel *tunnel)
 	return mtu - PPPOL2TP_HEADER_OVERHEAD;
 }
 
-/* connect() handler. Attach a PPPoX socket to a tunnel UDP socket
- */
-static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
-			    int sockaddr_len, int flags)
+static struct l2tp_tunnel *pppol2tp_tunnel_get(struct net *net,
+					       const struct l2tp_connect_info *info,
+					       bool *new_tunnel)
 {
-	struct sock *sk = sock->sk;
-	struct pppox_sock *po = pppox_sk(sk);
-	struct l2tp_session *session = NULL;
-	struct l2tp_connect_info info;
 	struct l2tp_tunnel *tunnel;
-	struct pppol2tp_session *ps;
-	struct l2tp_session_cfg cfg = { 0, };
-	bool drop_refcnt = false;
-	bool drop_tunnel = false;
-	bool new_session = false;
-	bool new_tunnel = false;
 	int error;
 
-	error = pppol2tp_sockaddr_get_info(uservaddr, sockaddr_len, &info);
-	if (error < 0)
-		return error;
+	*new_tunnel = false;
 
-	lock_sock(sk);
-
-	/* Check for already bound sockets */
-	error = -EBUSY;
-	if (sk->sk_state & PPPOX_CONNECTED)
-		goto end;
-
-	/* We don't supporting rebinding anyway */
-	error = -EALREADY;
-	if (sk->sk_user_data)
-		goto end; /* socket is already attached */
-
-	/* Don't bind if tunnel_id is 0 */
-	error = -EINVAL;
-	if (!info.tunnel_id)
-		goto end;
-
-	tunnel = l2tp_tunnel_get(sock_net(sk), info.tunnel_id);
-	if (tunnel)
-		drop_tunnel = true;
+	tunnel = l2tp_tunnel_get(net, info->tunnel_id);
 
 	/* Special case: create tunnel context if session_id and
 	 * peer_session_id is 0. Otherwise look up tunnel using supplied
 	 * tunnel id.
 	 */
-	if (!info.session_id && !info.peer_session_id) {
+	if (!info->session_id && !info->peer_session_id) {
 		if (!tunnel) {
 			struct l2tp_tunnel_cfg tcfg = {
 				.encap = L2TP_ENCAPTYPE_UDP,
@@ -707,40 +675,82 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 			/* Prevent l2tp_tunnel_register() from trying to set up
 			 * a kernel socket.
 			 */
-			if (info.fd < 0) {
-				error = -EBADF;
-				goto end;
-			}
+			if (info->fd < 0)
+				return ERR_PTR(-EBADF);
 
-			error = l2tp_tunnel_create(info.fd,
-						   info.version,
-						   info.tunnel_id,
-						   info.peer_tunnel_id, &tcfg,
+			error = l2tp_tunnel_create(info->fd,
+						   info->version,
+						   info->tunnel_id,
+						   info->peer_tunnel_id, &tcfg,
 						   &tunnel);
 			if (error < 0)
-				goto end;
+				return ERR_PTR(error);
 
 			l2tp_tunnel_inc_refcount(tunnel);
-			error = l2tp_tunnel_register(tunnel, sock_net(sk),
-						     &tcfg);
+			error = l2tp_tunnel_register(tunnel, net, &tcfg);
 			if (error < 0) {
 				kfree(tunnel);
-				goto end;
+				return ERR_PTR(error);
 			}
-			drop_tunnel = true;
-			new_tunnel = true;
+
+			*new_tunnel = true;
 		}
 	} else {
 		/* Error if we can't find the tunnel */
-		error = -ENOENT;
 		if (!tunnel)
-			goto end;
+			return ERR_PTR(-ENOENT);
 
 		/* Error if socket is not prepped */
-		if (!tunnel->sock)
-			goto end;
+		if (!tunnel->sock) {
+			l2tp_tunnel_dec_refcount(tunnel);
+			return ERR_PTR(-ENOENT);
+		}
 	}
 
+	return tunnel;
+}
+
+/* connect() handler. Attach a PPPoX socket to a tunnel UDP socket
+ */
+static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
+			    int sockaddr_len, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct pppox_sock *po = pppox_sk(sk);
+	struct l2tp_session *session = NULL;
+	struct l2tp_connect_info info;
+	struct l2tp_tunnel *tunnel;
+	struct pppol2tp_session *ps;
+	struct l2tp_session_cfg cfg = { 0, };
+	bool drop_refcnt = false;
+	bool new_session = false;
+	bool new_tunnel = false;
+	int error;
+
+	error = pppol2tp_sockaddr_get_info(uservaddr, sockaddr_len, &info);
+	if (error < 0)
+		return error;
+
+	/* Don't bind if tunnel_id is 0 */
+	if (!info.tunnel_id)
+		return -EINVAL;
+
+	tunnel = pppol2tp_tunnel_get(sock_net(sk), &info, &new_tunnel);
+	if (IS_ERR(tunnel))
+		return PTR_ERR(tunnel);
+
+	lock_sock(sk);
+
+	/* Check for already bound sockets */
+	error = -EBUSY;
+	if (sk->sk_state & PPPOX_CONNECTED)
+		goto end;
+
+	/* We don't supporting rebinding anyway */
+	error = -EALREADY;
+	if (sk->sk_user_data)
+		goto end; /* socket is already attached */
+
 	if (tunnel->peer_tunnel_id == 0)
 		tunnel->peer_tunnel_id = info.peer_tunnel_id;
 
@@ -841,8 +851,7 @@ static int pppol2tp_connect(struct socket *sock, struct sockaddr *uservaddr,
 	}
 	if (drop_refcnt)
 		l2tp_session_dec_refcount(session);
-	if (drop_tunnel)
-		l2tp_tunnel_dec_refcount(tunnel);
+	l2tp_tunnel_dec_refcount(tunnel);
 	release_sock(sk);
 
 	return error;
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f1e263b2c295..14db465289c5 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2190,7 +2190,7 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u32 rate,
 
 static int sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 {
-	u16 rate = READ_ONCE(sta_get_last_rx_stats(sta)->last_rate);
+	u32 rate = READ_ONCE(sta_get_last_rx_stats(sta)->last_rate);
 
 	if (rate == STA_STATS_RATE_INVALID)
 		return -EINVAL;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 81bd13b3d8fd..a02a25b7eae6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6794,6 +6794,9 @@ static int nf_tables_newobj(struct sk_buff *skb, const struct nfnl_info *info,
 			return -EOPNOTSUPP;
 
 		type = __nft_obj_type_get(objtype);
+		if (WARN_ON_ONCE(!type))
+			return -ENOENT;
+
 		nft_ctx_init(&ctx, net, skb, info->nlh, family, table, NULL, nla);
 
 		return nf_tables_updobj(&ctx, type, nla[NFTA_OBJ_DATA], obj);
diff --git a/net/rds/message.c b/net/rds/message.c
index b363ef13c75e..8fa3d19c2e66 100644
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
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index bbeb80e1133d..ad3e9a40b061 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -3117,6 +3117,8 @@ rpc_clnt_swap_activate_callback(struct rpc_clnt *clnt,
 int
 rpc_clnt_swap_activate(struct rpc_clnt *clnt)
 {
+	while (clnt != clnt->cl_parent)
+		clnt = clnt->cl_parent;
 	if (atomic_inc_return(&clnt->cl_swapper) == 1)
 		return rpc_clnt_iterate_for_each_xprt(clnt,
 				rpc_clnt_swap_activate_callback, NULL);
@@ -3136,6 +3138,8 @@ rpc_clnt_swap_deactivate_callback(struct rpc_clnt *clnt,
 void
 rpc_clnt_swap_deactivate(struct rpc_clnt *clnt)
 {
+	while (clnt != clnt->cl_parent)
+		clnt = clnt->cl_parent;
 	if (atomic_dec_if_positive(&clnt->cl_swapper) == 0)
 		rpc_clnt_iterate_for_each_xprt(clnt,
 				rpc_clnt_swap_deactivate_callback, NULL);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index bb46a6a34614..1b91a9c20896 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12922,7 +12922,7 @@ static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 		return -ERANGE;
 	if (nla_len(tb[NL80211_REKEY_DATA_KCK]) != NL80211_KCK_LEN &&
 	    !(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK &&
-	      nla_len(tb[NL80211_REKEY_DATA_KEK]) == NL80211_KCK_EXT_LEN))
+	      nla_len(tb[NL80211_REKEY_DATA_KCK]) == NL80211_KCK_EXT_LEN))
 		return -ERANGE;
 
 	rekey_data.kek = nla_data(tb[NL80211_REKEY_DATA_KEK]);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 08a70b4f090c..6f386aecf617 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -268,6 +268,15 @@ void cfg80211_conn_work(struct work_struct *work)
 	wiphy_unlock(&rdev->wiphy);
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
@@ -285,10 +294,7 @@ static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 	if (!bss)
 		return NULL;
 
-	memcpy(wdev->conn->bssid, bss->bssid, ETH_ALEN);
-	wdev->conn->params.bssid = wdev->conn->bssid;
-	wdev->conn->params.channel = bss->channel;
-	wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
+	cfg80211_step_auth_next(wdev->conn, bss);
 	schedule_work(&rdev->conn_work);
 
 	return bss;
@@ -567,7 +573,12 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
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
@@ -578,6 +589,7 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 	if (bss) {
 		enum nl80211_timeout_reason treason;
 
+		cfg80211_step_auth_next(wdev->conn, bss);
 		err = cfg80211_conn_do_work(wdev, &treason);
 		cfg80211_put_bss(wdev->wiphy, bss);
 	} else {
@@ -1244,6 +1256,15 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
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
diff --git a/scripts/package/mkdebian b/scripts/package/mkdebian
index 60a2a63a5e90..32d528a36786 100755
--- a/scripts/package/mkdebian
+++ b/scripts/package/mkdebian
@@ -236,7 +236,7 @@ binary-arch: build-arch
 	KBUILD_BUILD_VERSION=${revision} -f \$(srctree)/Makefile intdeb-pkg
 
 clean:
-	rm -rf debian/*tmp debian/files
+	rm -rf debian/files debian/linux-*
 	\$(MAKE) clean
 
 binary: binary-arch
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 465865412100..e9a361109dd2 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -395,7 +395,9 @@ static int process_measurement(struct file *file, const struct cred *cred,
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
@@ -403,7 +405,8 @@ static int process_measurement(struct file *file, const struct cred *cred,
  * On success return 0.  On integrity appraisal error, assuming the file
  * is in policy and IMA-appraisal is in enforcing mode, return -EACCES.
  */
-int ima_file_mmap(struct file *file, unsigned long prot)
+int ima_file_mmap(struct file *file, unsigned long reqprot,
+		  unsigned long prot, unsigned long flags)
 {
 	u32 secid;
 
diff --git a/security/security.c b/security/security.c
index 7b9f9d3fffe5..a97079e12c67 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1592,12 +1592,13 @@ static inline unsigned long mmap_prot(struct file *file, unsigned long prot)
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
index 801dd8d44953..c0cb6e49a9b6 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -2455,7 +2455,7 @@ static int dspio_set_uint_param(struct hda_codec *codec, int mod_id,
 static int dspio_alloc_dma_chan(struct hda_codec *codec, unsigned int *dma_chan)
 {
 	int status = 0;
-	unsigned int size = sizeof(dma_chan);
+	unsigned int size = sizeof(*dma_chan);
 
 	codec_dbg(codec, "     dspio_alloc_dma_chan() -- begin\n");
 	status = dspio_scp(codec, MASTERCONTROL, 0x20,
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index dddb6f842ff2..0f7dbfe547f9 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11236,6 +11236,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1028, 0x0698, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1028, 0x069f, "Dell", ALC668_FIXUP_DELL_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x103c, 0x1632, "HP RP5800", ALC662_FIXUP_HP_RP5800),
+	SND_PCI_QUIRK(0x103c, 0x870c, "HP", ALC897_FIXUP_HP_HSMIC_VERB),
 	SND_PCI_QUIRK(0x103c, 0x8719, "HP", ALC897_FIXUP_HP_HSMIC_VERB),
 	SND_PCI_QUIRK(0x103c, 0x873e, "HP", ALC671_FIXUP_HP_HEADSET_MIC2),
 	SND_PCI_QUIRK(0x103c, 0x877e, "HP 288 Pro G6", ALC671_FIXUP_HP_HEADSET_MIC2),
diff --git a/sound/pci/ice1712/aureon.c b/sound/pci/ice1712/aureon.c
index 9a30f6d35d13..40a0e0095030 100644
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
diff --git a/sound/soc/atmel/mchp-spdifrx.c b/sound/soc/atmel/mchp-spdifrx.c
index 2a62d9a2fa0d..39a3c2a33bdb 100644
--- a/sound/soc/atmel/mchp-spdifrx.c
+++ b/sound/soc/atmel/mchp-spdifrx.c
@@ -217,7 +217,6 @@ struct mchp_spdifrx_ch_stat {
 struct mchp_spdifrx_user_data {
 	unsigned char data[SPDIFRX_UD_BITS / 8];
 	struct completion done;
-	spinlock_t lock;	/* protect access to user data */
 };
 
 struct mchp_spdifrx_mixer_control {
@@ -231,13 +230,13 @@ struct mchp_spdifrx_mixer_control {
 struct mchp_spdifrx_dev {
 	struct snd_dmaengine_dai_dma_data	capture;
 	struct mchp_spdifrx_mixer_control	control;
-	spinlock_t				blockend_lock;	/* protect access to blockend_refcount */
-	int					blockend_refcount;
+	struct mutex				mlock;
 	struct device				*dev;
 	struct regmap				*regmap;
 	struct clk				*pclk;
 	struct clk				*gclk;
 	unsigned int				fmt;
+	unsigned int				trigger_enabled;
 	unsigned int				gclk_enabled:1;
 };
 
@@ -275,37 +274,11 @@ static void mchp_spdifrx_channel_user_data_read(struct mchp_spdifrx_dev *dev,
 	}
 }
 
-/* called from non-atomic context only */
-static void mchp_spdifrx_isr_blockend_en(struct mchp_spdifrx_dev *dev)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->blockend_lock, flags);
-	dev->blockend_refcount++;
-	/* don't enable BLOCKEND interrupt if it's already enabled */
-	if (dev->blockend_refcount == 1)
-		regmap_write(dev->regmap, SPDIFRX_IER, SPDIFRX_IR_BLOCKEND);
-	spin_unlock_irqrestore(&dev->blockend_lock, flags);
-}
-
-/* called from atomic/non-atomic context */
-static void mchp_spdifrx_isr_blockend_dis(struct mchp_spdifrx_dev *dev)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&dev->blockend_lock, flags);
-	dev->blockend_refcount--;
-	/* don't enable BLOCKEND interrupt if it's already enabled */
-	if (dev->blockend_refcount == 0)
-		regmap_write(dev->regmap, SPDIFRX_IDR, SPDIFRX_IR_BLOCKEND);
-	spin_unlock_irqrestore(&dev->blockend_lock, flags);
-}
-
 static irqreturn_t mchp_spdif_interrupt(int irq, void *dev_id)
 {
 	struct mchp_spdifrx_dev *dev = dev_id;
 	struct mchp_spdifrx_mixer_control *ctrl = &dev->control;
-	u32 sr, imr, pending, idr = 0;
+	u32 sr, imr, pending;
 	irqreturn_t ret = IRQ_NONE;
 	int ch;
 
@@ -320,13 +293,10 @@ static irqreturn_t mchp_spdif_interrupt(int irq, void *dev_id)
 
 	if (pending & SPDIFRX_IR_BLOCKEND) {
 		for (ch = 0; ch < SPDIFRX_CHANNELS; ch++) {
-			spin_lock(&ctrl->user_data[ch].lock);
 			mchp_spdifrx_channel_user_data_read(dev, ch);
-			spin_unlock(&ctrl->user_data[ch].lock);
-
 			complete(&ctrl->user_data[ch].done);
 		}
-		mchp_spdifrx_isr_blockend_dis(dev);
+		regmap_write(dev->regmap, SPDIFRX_IDR, SPDIFRX_IR_BLOCKEND);
 		ret = IRQ_HANDLED;
 	}
 
@@ -334,7 +304,7 @@ static irqreturn_t mchp_spdif_interrupt(int irq, void *dev_id)
 		if (pending & SPDIFRX_IR_CSC(ch)) {
 			mchp_spdifrx_channel_status_read(dev, ch);
 			complete(&ctrl->ch_stat[ch].done);
-			idr |= SPDIFRX_IR_CSC(ch);
+			regmap_write(dev->regmap, SPDIFRX_IDR, SPDIFRX_IR_CSC(ch));
 			ret = IRQ_HANDLED;
 		}
 	}
@@ -344,8 +314,6 @@ static irqreturn_t mchp_spdif_interrupt(int irq, void *dev_id)
 		ret = IRQ_HANDLED;
 	}
 
-	regmap_write(dev->regmap, SPDIFRX_IDR, idr);
-
 	return ret;
 }
 
@@ -353,47 +321,40 @@ static int mchp_spdifrx_trigger(struct snd_pcm_substream *substream, int cmd,
 				struct snd_soc_dai *dai)
 {
 	struct mchp_spdifrx_dev *dev = snd_soc_dai_get_drvdata(dai);
-	u32 mr;
-	int running;
-	int ret;
-
-	regmap_read(dev->regmap, SPDIFRX_MR, &mr);
-	running = !!(mr & SPDIFRX_MR_RXEN_ENABLE);
+	int ret = 0;
 
 	switch (cmd) {
 	case SNDRV_PCM_TRIGGER_START:
 	case SNDRV_PCM_TRIGGER_RESUME:
 	case SNDRV_PCM_TRIGGER_PAUSE_RELEASE:
-		if (!running) {
-			mr &= ~SPDIFRX_MR_RXEN_MASK;
-			mr |= SPDIFRX_MR_RXEN_ENABLE;
-			/* enable overrun interrupts */
-			regmap_write(dev->regmap, SPDIFRX_IER,
-				     SPDIFRX_IR_OVERRUN);
-		}
+		mutex_lock(&dev->mlock);
+		/* Enable overrun interrupts */
+		regmap_write(dev->regmap, SPDIFRX_IER, SPDIFRX_IR_OVERRUN);
+
+		/* Enable receiver. */
+		regmap_update_bits(dev->regmap, SPDIFRX_MR, SPDIFRX_MR_RXEN_MASK,
+				   SPDIFRX_MR_RXEN_ENABLE);
+		dev->trigger_enabled = true;
+		mutex_unlock(&dev->mlock);
 		break;
 	case SNDRV_PCM_TRIGGER_STOP:
 	case SNDRV_PCM_TRIGGER_SUSPEND:
 	case SNDRV_PCM_TRIGGER_PAUSE_PUSH:
-		if (running) {
-			mr &= ~SPDIFRX_MR_RXEN_MASK;
-			mr |= SPDIFRX_MR_RXEN_DISABLE;
-			/* disable overrun interrupts */
-			regmap_write(dev->regmap, SPDIFRX_IDR,
-				     SPDIFRX_IR_OVERRUN);
-		}
+		mutex_lock(&dev->mlock);
+		/* Disable overrun interrupts */
+		regmap_write(dev->regmap, SPDIFRX_IDR, SPDIFRX_IR_OVERRUN);
+
+		/* Disable receiver. */
+		regmap_update_bits(dev->regmap, SPDIFRX_MR, SPDIFRX_MR_RXEN_MASK,
+				   SPDIFRX_MR_RXEN_DISABLE);
+		dev->trigger_enabled = false;
+		mutex_unlock(&dev->mlock);
 		break;
 	default:
-		return -EINVAL;
-	}
-
-	ret = regmap_write(dev->regmap, SPDIFRX_MR, mr);
-	if (ret) {
-		dev_err(dev->dev, "unable to enable/disable RX: %d\n", ret);
-		return ret;
+		ret = -EINVAL;
 	}
 
-	return 0;
+	return ret;
 }
 
 static int mchp_spdifrx_hw_params(struct snd_pcm_substream *substream,
@@ -401,7 +362,7 @@ static int mchp_spdifrx_hw_params(struct snd_pcm_substream *substream,
 				  struct snd_soc_dai *dai)
 {
 	struct mchp_spdifrx_dev *dev = snd_soc_dai_get_drvdata(dai);
-	u32 mr;
+	u32 mr = 0;
 	int ret;
 
 	dev_dbg(dev->dev, "%s() rate=%u format=%#x width=%u channels=%u\n",
@@ -413,13 +374,6 @@ static int mchp_spdifrx_hw_params(struct snd_pcm_substream *substream,
 		return -EINVAL;
 	}
 
-	regmap_read(dev->regmap, SPDIFRX_MR, &mr);
-
-	if (mr & SPDIFRX_MR_RXEN_ENABLE) {
-		dev_err(dev->dev, "PCM already running\n");
-		return -EBUSY;
-	}
-
 	if (params_channels(params) != SPDIFRX_CHANNELS) {
 		dev_err(dev->dev, "unsupported number of channels: %d\n",
 			params_channels(params));
@@ -445,6 +399,13 @@ static int mchp_spdifrx_hw_params(struct snd_pcm_substream *substream,
 		return -EINVAL;
 	}
 
+	mutex_lock(&dev->mlock);
+	if (dev->trigger_enabled) {
+		dev_err(dev->dev, "PCM already running\n");
+		ret = -EBUSY;
+		goto unlock;
+	}
+
 	if (dev->gclk_enabled) {
 		clk_disable_unprepare(dev->gclk);
 		dev->gclk_enabled = 0;
@@ -455,19 +416,24 @@ static int mchp_spdifrx_hw_params(struct snd_pcm_substream *substream,
 		dev_err(dev->dev,
 			"unable to set gclk min rate: rate %u * ratio %u + 1\n",
 			params_rate(params), SPDIFRX_GCLK_RATIO_MIN);
-		return ret;
+		goto unlock;
 	}
 	ret = clk_prepare_enable(dev->gclk);
 	if (ret) {
 		dev_err(dev->dev, "unable to enable gclk: %d\n", ret);
-		return ret;
+		goto unlock;
 	}
 	dev->gclk_enabled = 1;
 
 	dev_dbg(dev->dev, "GCLK range min set to %d\n",
 		params_rate(params) * SPDIFRX_GCLK_RATIO_MIN + 1);
 
-	return regmap_write(dev->regmap, SPDIFRX_MR, mr);
+	ret = regmap_write(dev->regmap, SPDIFRX_MR, mr);
+
+unlock:
+	mutex_unlock(&dev->mlock);
+
+	return ret;
 }
 
 static int mchp_spdifrx_hw_free(struct snd_pcm_substream *substream,
@@ -475,10 +441,12 @@ static int mchp_spdifrx_hw_free(struct snd_pcm_substream *substream,
 {
 	struct mchp_spdifrx_dev *dev = snd_soc_dai_get_drvdata(dai);
 
+	mutex_lock(&dev->mlock);
 	if (dev->gclk_enabled) {
 		clk_disable_unprepare(dev->gclk);
 		dev->gclk_enabled = 0;
 	}
+	mutex_unlock(&dev->mlock);
 	return 0;
 }
 
@@ -515,22 +483,51 @@ static int mchp_spdifrx_cs_get(struct mchp_spdifrx_dev *dev,
 {
 	struct mchp_spdifrx_mixer_control *ctrl = &dev->control;
 	struct mchp_spdifrx_ch_stat *ch_stat = &ctrl->ch_stat[channel];
-	int ret;
-
-	regmap_write(dev->regmap, SPDIFRX_IER, SPDIFRX_IR_CSC(channel));
-	/* check for new data available */
-	ret = wait_for_completion_interruptible_timeout(&ch_stat->done,
-							msecs_to_jiffies(100));
-	/* IP might not be started or valid stream might not be present */
-	if (ret < 0) {
-		dev_dbg(dev->dev, "channel status for channel %d timeout\n",
-			channel);
+	int ret = 0;
+
+	mutex_lock(&dev->mlock);
+
+	/*
+	 * We may reach this point with both clocks enabled but the receiver
+	 * still disabled. To void waiting for completion and return with
+	 * timeout check the dev->trigger_enabled.
+	 *
+	 * To retrieve data:
+	 * - if the receiver is enabled CSC IRQ will update the data in software
+	 *   caches (ch_stat->data)
+	 * - otherwise we just update it here the software caches with latest
+	 *   available information and return it; in this case we don't need
+	 *   spin locking as the IRQ is disabled and will not be raised from
+	 *   anywhere else.
+	 */
+
+	if (dev->trigger_enabled) {
+		reinit_completion(&ch_stat->done);
+		regmap_write(dev->regmap, SPDIFRX_IER, SPDIFRX_IR_CSC(channel));
+		/* Check for new data available */
+		ret = wait_for_completion_interruptible_timeout(&ch_stat->done,
+								msecs_to_jiffies(100));
+		/* Valid stream might not be present */
+		if (ret <= 0) {
+			dev_dbg(dev->dev, "channel status for channel %d timeout\n",
+				channel);
+			regmap_write(dev->regmap, SPDIFRX_IDR, SPDIFRX_IR_CSC(channel));
+			ret = ret ? : -ETIMEDOUT;
+			goto unlock;
+		} else {
+			ret = 0;
+		}
+	} else {
+		/* Update software cache with latest channel status. */
+		mchp_spdifrx_channel_status_read(dev, channel);
 	}
 
 	memcpy(uvalue->value.iec958.status, ch_stat->data,
 	       sizeof(ch_stat->data));
 
-	return 0;
+unlock:
+	mutex_unlock(&dev->mlock);
+	return ret;
 }
 
 static int mchp_spdifrx_cs1_get(struct snd_kcontrol *kcontrol,
@@ -564,29 +561,49 @@ static int mchp_spdifrx_subcode_ch_get(struct mchp_spdifrx_dev *dev,
 				       int channel,
 				       struct snd_ctl_elem_value *uvalue)
 {
-	unsigned long flags;
 	struct mchp_spdifrx_mixer_control *ctrl = &dev->control;
 	struct mchp_spdifrx_user_data *user_data = &ctrl->user_data[channel];
-	int ret;
-
-	reinit_completion(&user_data->done);
-	mchp_spdifrx_isr_blockend_en(dev);
-	ret = wait_for_completion_interruptible_timeout(&user_data->done,
-							msecs_to_jiffies(100));
-	/* IP might not be started or valid stream might not be present */
-	if (ret <= 0) {
-		dev_dbg(dev->dev, "user data for channel %d timeout\n",
-			channel);
-		mchp_spdifrx_isr_blockend_dis(dev);
-		return ret;
+	int ret = 0;
+
+	mutex_lock(&dev->mlock);
+
+	/*
+	 * We may reach this point with both clocks enabled but the receiver
+	 * still disabled. To void waiting for completion to just timeout we
+	 * check here the dev->trigger_enabled flag.
+	 *
+	 * To retrieve data:
+	 * - if the receiver is enabled we need to wait for blockend IRQ to read
+	 *   data to and update it for us in software caches
+	 * - otherwise reading the SPDIFRX_CHUD() registers is enough.
+	 */
+
+	if (dev->trigger_enabled) {
+		reinit_completion(&user_data->done);
+		regmap_write(dev->regmap, SPDIFRX_IER, SPDIFRX_IR_BLOCKEND);
+		ret = wait_for_completion_interruptible_timeout(&user_data->done,
+								msecs_to_jiffies(100));
+		/* Valid stream might not be present. */
+		if (ret <= 0) {
+			dev_dbg(dev->dev, "user data for channel %d timeout\n",
+				channel);
+			regmap_write(dev->regmap, SPDIFRX_IDR, SPDIFRX_IR_BLOCKEND);
+			ret = ret ? : -ETIMEDOUT;
+			goto unlock;
+		} else {
+			ret = 0;
+		}
+	} else {
+		/* Update software cache with last available data. */
+		mchp_spdifrx_channel_user_data_read(dev, channel);
 	}
 
-	spin_lock_irqsave(&user_data->lock, flags);
 	memcpy(uvalue->value.iec958.subcode, user_data->data,
 	       sizeof(user_data->data));
-	spin_unlock_irqrestore(&user_data->lock, flags);
 
-	return 0;
+unlock:
+	mutex_unlock(&dev->mlock);
+	return ret;
 }
 
 static int mchp_spdifrx_subcode_ch1_get(struct snd_kcontrol *kcontrol,
@@ -627,10 +644,24 @@ static int mchp_spdifrx_ulock_get(struct snd_kcontrol *kcontrol,
 	u32 val;
 	bool ulock_old = ctrl->ulock;
 
-	regmap_read(dev->regmap, SPDIFRX_RSR, &val);
-	ctrl->ulock = !(val & SPDIFRX_RSR_ULOCK);
+	mutex_lock(&dev->mlock);
+
+	/*
+	 * The RSR.ULOCK has wrong value if both pclk and gclk are enabled
+	 * and the receiver is disabled. Thus we take into account the
+	 * dev->trigger_enabled here to return a real status.
+	 */
+	if (dev->trigger_enabled) {
+		regmap_read(dev->regmap, SPDIFRX_RSR, &val);
+		ctrl->ulock = !(val & SPDIFRX_RSR_ULOCK);
+	} else {
+		ctrl->ulock = 0;
+	}
+
 	uvalue->value.integer.value[0] = ctrl->ulock;
 
+	mutex_unlock(&dev->mlock);
+
 	return ulock_old != ctrl->ulock;
 }
 
@@ -643,8 +674,22 @@ static int mchp_spdifrx_badf_get(struct snd_kcontrol *kcontrol,
 	u32 val;
 	bool badf_old = ctrl->badf;
 
-	regmap_read(dev->regmap, SPDIFRX_RSR, &val);
-	ctrl->badf = !!(val & SPDIFRX_RSR_BADF);
+	mutex_lock(&dev->mlock);
+
+	/*
+	 * The RSR.ULOCK has wrong value if both pclk and gclk are enabled
+	 * and the receiver is disabled. Thus we take into account the
+	 * dev->trigger_enabled here to return a real status.
+	 */
+	if (dev->trigger_enabled) {
+		regmap_read(dev->regmap, SPDIFRX_RSR, &val);
+		ctrl->badf = !!(val & SPDIFRX_RSR_BADF);
+	} else {
+		ctrl->badf = 0;
+	}
+
+	mutex_unlock(&dev->mlock);
+
 	uvalue->value.integer.value[0] = ctrl->badf;
 
 	return badf_old != ctrl->badf;
@@ -656,11 +701,48 @@ static int mchp_spdifrx_signal_get(struct snd_kcontrol *kcontrol,
 	struct snd_soc_dai *dai = snd_kcontrol_chip(kcontrol);
 	struct mchp_spdifrx_dev *dev = snd_soc_dai_get_drvdata(dai);
 	struct mchp_spdifrx_mixer_control *ctrl = &dev->control;
-	u32 val;
+	u32 val = ~0U, loops = 10;
+	int ret;
 	bool signal_old = ctrl->signal;
 
-	regmap_read(dev->regmap, SPDIFRX_RSR, &val);
-	ctrl->signal = !(val & SPDIFRX_RSR_NOSIGNAL);
+	mutex_lock(&dev->mlock);
+
+	/*
+	 * To get the signal we need to have receiver enabled. This
+	 * could be enabled also from trigger() function thus we need to
+	 * take care of not disabling the receiver when it runs.
+	 */
+	if (!dev->trigger_enabled) {
+		ret = clk_prepare_enable(dev->gclk);
+		if (ret)
+			goto unlock;
+
+		regmap_update_bits(dev->regmap, SPDIFRX_MR, SPDIFRX_MR_RXEN_MASK,
+				   SPDIFRX_MR_RXEN_ENABLE);
+
+		/* Wait for RSR.ULOCK bit. */
+		while (--loops) {
+			regmap_read(dev->regmap, SPDIFRX_RSR, &val);
+			if (!(val & SPDIFRX_RSR_ULOCK))
+				break;
+			usleep_range(100, 150);
+		}
+
+		regmap_update_bits(dev->regmap, SPDIFRX_MR, SPDIFRX_MR_RXEN_MASK,
+				   SPDIFRX_MR_RXEN_DISABLE);
+
+		clk_disable_unprepare(dev->gclk);
+	} else {
+		regmap_read(dev->regmap, SPDIFRX_RSR, &val);
+	}
+
+unlock:
+	mutex_unlock(&dev->mlock);
+
+	if (!(val & SPDIFRX_RSR_ULOCK))
+		ctrl->signal = !(val & SPDIFRX_RSR_NOSIGNAL);
+	else
+		ctrl->signal = 0;
 	uvalue->value.integer.value[0] = ctrl->signal;
 
 	return signal_old != ctrl->signal;
@@ -685,18 +767,32 @@ static int mchp_spdifrx_rate_get(struct snd_kcontrol *kcontrol,
 	u32 val;
 	int rate;
 
-	regmap_read(dev->regmap, SPDIFRX_RSR, &val);
-
-	/* if the receiver is not locked, ISF data is invalid */
-	if (val & SPDIFRX_RSR_ULOCK || !(val & SPDIFRX_RSR_IFS_MASK)) {
+	mutex_lock(&dev->mlock);
+
+	/*
+	 * The RSR.ULOCK has wrong value if both pclk and gclk are enabled
+	 * and the receiver is disabled. Thus we take into account the
+	 * dev->trigger_enabled here to return a real status.
+	 */
+	if (dev->trigger_enabled) {
+		regmap_read(dev->regmap, SPDIFRX_RSR, &val);
+		/* If the receiver is not locked, ISF data is invalid. */
+		if (val & SPDIFRX_RSR_ULOCK || !(val & SPDIFRX_RSR_IFS_MASK)) {
+			ucontrol->value.integer.value[0] = 0;
+			goto unlock;
+		}
+	} else {
+		/* Reveicer is not locked, IFS data is invalid. */
 		ucontrol->value.integer.value[0] = 0;
-		return 0;
+		goto unlock;
 	}
 
 	rate = clk_get_rate(dev->gclk);
 
 	ucontrol->value.integer.value[0] = rate / (32 * SPDIFRX_RSR_IFS(val));
 
+unlock:
+	mutex_unlock(&dev->mlock);
 	return 0;
 }
 
@@ -808,11 +904,9 @@ static int mchp_spdifrx_dai_probe(struct snd_soc_dai *dai)
 		     SPDIFRX_MR_AUTORST_NOACTION |
 		     SPDIFRX_MR_PACK_DISABLED);
 
-	dev->blockend_refcount = 0;
 	for (ch = 0; ch < SPDIFRX_CHANNELS; ch++) {
 		init_completion(&ctrl->ch_stat[ch].done);
 		init_completion(&ctrl->user_data[ch].done);
-		spin_lock_init(&ctrl->user_data[ch].lock);
 	}
 
 	/* Add controls */
@@ -827,7 +921,7 @@ static int mchp_spdifrx_dai_remove(struct snd_soc_dai *dai)
 	struct mchp_spdifrx_dev *dev = snd_soc_dai_get_drvdata(dai);
 
 	/* Disable interrupts */
-	regmap_write(dev->regmap, SPDIFRX_IDR, 0xFF);
+	regmap_write(dev->regmap, SPDIFRX_IDR, GENMASK(14, 0));
 
 	clk_disable_unprepare(dev->pclk);
 
@@ -912,7 +1006,17 @@ static int mchp_spdifrx_probe(struct platform_device *pdev)
 			"failed to get the PMC generated clock: %d\n", err);
 		return err;
 	}
-	spin_lock_init(&dev->blockend_lock);
+
+	/*
+	 * Signal control need a valid rate on gclk. hw_params() configures
+	 * it propertly but requesting signal before any hw_params() has been
+	 * called lead to invalid value returned for signal. Thus, configure
+	 * gclk at a valid rate, here, in initialization, to simplify the
+	 * control path.
+	 */
+	clk_set_min_rate(dev->gclk, 48000 * SPDIFRX_GCLK_RATIO_MIN + 1);
+
+	mutex_init(&dev->mlock);
 
 	dev->dev = &pdev->dev;
 	dev->regmap = regmap;
diff --git a/sound/soc/codecs/lpass-rx-macro.c b/sound/soc/codecs/lpass-rx-macro.c
index 23452900b9ae..72a0db09c713 100644
--- a/sound/soc/codecs/lpass-rx-macro.c
+++ b/sound/soc/codecs/lpass-rx-macro.c
@@ -363,7 +363,7 @@
 #define CDC_RX_DSD1_CFG2			(0x0F8C)
 #define RX_MAX_OFFSET				(0x0F8C)
 
-#define MCLK_FREQ		9600000
+#define MCLK_FREQ		19200000
 
 #define RX_MACRO_RATES (SNDRV_PCM_RATE_8000 | SNDRV_PCM_RATE_16000 |\
 			SNDRV_PCM_RATE_32000 | SNDRV_PCM_RATE_48000 |\
@@ -608,7 +608,11 @@ struct rx_macro {
 	int softclip_clk_users;
 
 	struct regmap *regmap;
-	struct clk_bulk_data clks[RX_NUM_CLKS_MAX];
+	struct clk *mclk;
+	struct clk *npl;
+	struct clk *macro;
+	struct clk *dcodec;
+	struct clk *fsgen;
 	struct clk_hw hw;
 };
 #define to_rx_macro(_hw) container_of(_hw, struct rx_macro, hw)
@@ -3479,17 +3483,16 @@ static const struct clk_ops swclk_gate_ops = {
 
 };
 
-static struct clk *rx_macro_register_mclk_output(struct rx_macro *rx)
+static int rx_macro_register_mclk_output(struct rx_macro *rx)
 {
 	struct device *dev = rx->dev;
-	struct device_node *np = dev->of_node;
 	const char *parent_clk_name = NULL;
 	const char *clk_name = "lpass-rx-mclk";
 	struct clk_hw *hw;
 	struct clk_init_data init;
 	int ret;
 
-	parent_clk_name = __clk_get_name(rx->clks[2].clk);
+	parent_clk_name = __clk_get_name(rx->mclk);
 
 	init.name = clk_name;
 	init.ops = &swclk_gate_ops;
@@ -3498,13 +3501,11 @@ static struct clk *rx_macro_register_mclk_output(struct rx_macro *rx)
 	init.num_parents = 1;
 	rx->hw.init = &init;
 	hw = &rx->hw;
-	ret = clk_hw_register(rx->dev, hw);
+	ret = devm_clk_hw_register(rx->dev, hw);
 	if (ret)
-		return ERR_PTR(ret);
-
-	of_clk_add_provider(np, of_clk_src_simple_get, hw->clk);
+		return ret;
 
-	return NULL;
+	return devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get, hw);
 }
 
 static const struct snd_soc_component_driver rx_macro_component_drv = {
@@ -3529,17 +3530,25 @@ static int rx_macro_probe(struct platform_device *pdev)
 	if (!rx)
 		return -ENOMEM;
 
-	rx->clks[0].id = "macro";
-	rx->clks[1].id = "dcodec";
-	rx->clks[2].id = "mclk";
-	rx->clks[3].id = "npl";
-	rx->clks[4].id = "fsgen";
+	rx->macro = devm_clk_get_optional(dev, "macro");
+	if (IS_ERR(rx->macro))
+		return PTR_ERR(rx->macro);
 
-	ret = devm_clk_bulk_get(dev, RX_NUM_CLKS_MAX, rx->clks);
-	if (ret) {
-		dev_err(dev, "Error getting RX Clocks (%d)\n", ret);
-		return ret;
-	}
+	rx->dcodec = devm_clk_get_optional(dev, "dcodec");
+	if (IS_ERR(rx->dcodec))
+		return PTR_ERR(rx->dcodec);
+
+	rx->mclk = devm_clk_get(dev, "mclk");
+	if (IS_ERR(rx->mclk))
+		return PTR_ERR(rx->mclk);
+
+	rx->npl = devm_clk_get(dev, "npl");
+	if (IS_ERR(rx->npl))
+		return PTR_ERR(rx->npl);
+
+	rx->fsgen = devm_clk_get(dev, "fsgen");
+	if (IS_ERR(rx->fsgen))
+		return PTR_ERR(rx->fsgen);
 
 	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
@@ -3555,21 +3564,52 @@ static int rx_macro_probe(struct platform_device *pdev)
 	rx->dev = dev;
 
 	/* set MCLK and NPL rates */
-	clk_set_rate(rx->clks[2].clk, MCLK_FREQ);
-	clk_set_rate(rx->clks[3].clk, 2 * MCLK_FREQ);
+	clk_set_rate(rx->mclk, MCLK_FREQ);
+	clk_set_rate(rx->npl, MCLK_FREQ);
 
-	ret = clk_bulk_prepare_enable(RX_NUM_CLKS_MAX, rx->clks);
+	ret = clk_prepare_enable(rx->macro);
 	if (ret)
-		return ret;
+		goto err;
+
+	ret = clk_prepare_enable(rx->dcodec);
+	if (ret)
+		goto err_dcodec;
 
-	rx_macro_register_mclk_output(rx);
+	ret = clk_prepare_enable(rx->mclk);
+	if (ret)
+		goto err_mclk;
+
+	ret = clk_prepare_enable(rx->npl);
+	if (ret)
+		goto err_npl;
+
+	ret = clk_prepare_enable(rx->fsgen);
+	if (ret)
+		goto err_fsgen;
+
+	ret = rx_macro_register_mclk_output(rx);
+	if (ret)
+		goto err_clkout;
 
 	ret = devm_snd_soc_register_component(dev, &rx_macro_component_drv,
 					      rx_macro_dai,
 					      ARRAY_SIZE(rx_macro_dai));
 	if (ret)
-		clk_bulk_disable_unprepare(RX_NUM_CLKS_MAX, rx->clks);
+		goto err_clkout;
+
+	return 0;
 
+err_clkout:
+	clk_disable_unprepare(rx->fsgen);
+err_fsgen:
+	clk_disable_unprepare(rx->npl);
+err_npl:
+	clk_disable_unprepare(rx->mclk);
+err_mclk:
+	clk_disable_unprepare(rx->dcodec);
+err_dcodec:
+	clk_disable_unprepare(rx->macro);
+err:
 	return ret;
 }
 
@@ -3577,8 +3617,12 @@ static int rx_macro_remove(struct platform_device *pdev)
 {
 	struct rx_macro *rx = dev_get_drvdata(&pdev->dev);
 
-	of_clk_del_provider(pdev->dev.of_node);
-	clk_bulk_disable_unprepare(RX_NUM_CLKS_MAX, rx->clks);
+	clk_disable_unprepare(rx->mclk);
+	clk_disable_unprepare(rx->npl);
+	clk_disable_unprepare(rx->fsgen);
+	clk_disable_unprepare(rx->macro);
+	clk_disable_unprepare(rx->dcodec);
+
 	return 0;
 }
 
diff --git a/sound/soc/codecs/lpass-tx-macro.c b/sound/soc/codecs/lpass-tx-macro.c
index feafb8a90ffe..2b7ba78551fa 100644
--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -6,6 +6,7 @@
 #include <linux/clk.h>
 #include <linux/io.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/regmap.h>
 #include <sound/soc.h>
 #include <sound/soc-dapm.h>
@@ -199,7 +200,7 @@
 #define TX_MACRO_AMIC_UNMUTE_DELAY_MS	100
 #define TX_MACRO_DMIC_HPF_DELAY_MS	300
 #define TX_MACRO_AMIC_HPF_DELAY_MS	300
-#define MCLK_FREQ		9600000
+#define MCLK_FREQ		19200000
 
 enum {
 	TX_MACRO_AIF_INVALID = 0,
@@ -258,7 +259,11 @@ struct tx_macro {
 	unsigned long active_ch_cnt[TX_MACRO_MAX_DAIS];
 	unsigned long active_decimator[TX_MACRO_MAX_DAIS];
 	struct regmap *regmap;
-	struct clk_bulk_data clks[TX_NUM_CLKS_MAX];
+	struct clk *mclk;
+	struct clk *npl;
+	struct clk *macro;
+	struct clk *dcodec;
+	struct clk *fsgen;
 	struct clk_hw hw;
 	bool dec_active[NUM_DECIMATORS];
 	bool reset_swr;
@@ -1745,17 +1750,16 @@ static const struct clk_ops swclk_gate_ops = {
 
 };
 
-static struct clk *tx_macro_register_mclk_output(struct tx_macro *tx)
+static int tx_macro_register_mclk_output(struct tx_macro *tx)
 {
 	struct device *dev = tx->dev;
-	struct device_node *np = dev->of_node;
 	const char *parent_clk_name = NULL;
 	const char *clk_name = "lpass-tx-mclk";
 	struct clk_hw *hw;
 	struct clk_init_data init;
 	int ret;
 
-	parent_clk_name = __clk_get_name(tx->clks[2].clk);
+	parent_clk_name = __clk_get_name(tx->mclk);
 
 	init.name = clk_name;
 	init.ops = &swclk_gate_ops;
@@ -1764,13 +1768,11 @@ static struct clk *tx_macro_register_mclk_output(struct tx_macro *tx)
 	init.num_parents = 1;
 	tx->hw.init = &init;
 	hw = &tx->hw;
-	ret = clk_hw_register(tx->dev, hw);
+	ret = devm_clk_hw_register(dev, hw);
 	if (ret)
-		return ERR_PTR(ret);
-
-	of_clk_add_provider(np, of_clk_src_simple_get, hw->clk);
+		return ret;
 
-	return NULL;
+	return devm_of_clk_add_hw_provider(dev, of_clk_hw_simple_get, hw);
 }
 
 static const struct snd_soc_component_driver tx_macro_component_drv = {
@@ -1795,17 +1797,25 @@ static int tx_macro_probe(struct platform_device *pdev)
 	if (!tx)
 		return -ENOMEM;
 
-	tx->clks[0].id = "macro";
-	tx->clks[1].id = "dcodec";
-	tx->clks[2].id = "mclk";
-	tx->clks[3].id = "npl";
-	tx->clks[4].id = "fsgen";
+	tx->macro = devm_clk_get_optional(dev, "macro");
+	if (IS_ERR(tx->macro))
+		return PTR_ERR(tx->macro);
 
-	ret = devm_clk_bulk_get(dev, TX_NUM_CLKS_MAX, tx->clks);
-	if (ret) {
-		dev_err(dev, "Error getting RX Clocks (%d)\n", ret);
-		return ret;
-	}
+	tx->dcodec = devm_clk_get_optional(dev, "dcodec");
+	if (IS_ERR(tx->dcodec))
+		return PTR_ERR(tx->dcodec);
+
+	tx->mclk = devm_clk_get(dev, "mclk");
+	if (IS_ERR(tx->mclk))
+		return PTR_ERR(tx->mclk);
+
+	tx->npl = devm_clk_get(dev, "npl");
+	if (IS_ERR(tx->npl))
+		return PTR_ERR(tx->npl);
+
+	tx->fsgen = devm_clk_get(dev, "fsgen");
+	if (IS_ERR(tx->fsgen))
+		return PTR_ERR(tx->fsgen);
 
 	base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(base))
@@ -1821,24 +1831,52 @@ static int tx_macro_probe(struct platform_device *pdev)
 	tx->dev = dev;
 
 	/* set MCLK and NPL rates */
-	clk_set_rate(tx->clks[2].clk, MCLK_FREQ);
-	clk_set_rate(tx->clks[3].clk, 2 * MCLK_FREQ);
+	clk_set_rate(tx->mclk, MCLK_FREQ);
+	clk_set_rate(tx->npl, MCLK_FREQ);
 
-	ret = clk_bulk_prepare_enable(TX_NUM_CLKS_MAX, tx->clks);
+	ret = clk_prepare_enable(tx->macro);
 	if (ret)
-		return ret;
+		goto err;
+
+	ret = clk_prepare_enable(tx->dcodec);
+	if (ret)
+		goto err_dcodec;
 
-	tx_macro_register_mclk_output(tx);
+	ret = clk_prepare_enable(tx->mclk);
+	if (ret)
+		goto err_mclk;
+
+	ret = clk_prepare_enable(tx->npl);
+	if (ret)
+		goto err_npl;
+
+	ret = clk_prepare_enable(tx->fsgen);
+	if (ret)
+		goto err_fsgen;
+
+	ret = tx_macro_register_mclk_output(tx);
+	if (ret)
+		goto err_clkout;
 
 	ret = devm_snd_soc_register_component(dev, &tx_macro_component_drv,
 					      tx_macro_dai,
 					      ARRAY_SIZE(tx_macro_dai));
 	if (ret)
-		goto err;
-	return ret;
-err:
-	clk_bulk_disable_unprepare(TX_NUM_CLKS_MAX, tx->clks);
+		goto err_clkout;
+
+	return 0;
 
+err_clkout:
+	clk_disable_unprepare(tx->fsgen);
+err_fsgen:
+	clk_disable_unprepare(tx->npl);
+err_npl:
+	clk_disable_unprepare(tx->mclk);
+err_mclk:
+	clk_disable_unprepare(tx->dcodec);
+err_dcodec:
+	clk_disable_unprepare(tx->macro);
+err:
 	return ret;
 }
 
@@ -1846,9 +1884,11 @@ static int tx_macro_remove(struct platform_device *pdev)
 {
 	struct tx_macro *tx = dev_get_drvdata(&pdev->dev);
 
-	of_clk_del_provider(pdev->dev.of_node);
-
-	clk_bulk_disable_unprepare(TX_NUM_CLKS_MAX, tx->clks);
+	clk_disable_unprepare(tx->macro);
+	clk_disable_unprepare(tx->dcodec);
+	clk_disable_unprepare(tx->mclk);
+	clk_disable_unprepare(tx->npl);
+	clk_disable_unprepare(tx->fsgen);
 
 	return 0;
 }
diff --git a/sound/soc/codecs/lpass-va-macro.c b/sound/soc/codecs/lpass-va-macro.c
index 08702a21212c..9b9bae9b92be 100644
--- a/sound/soc/codecs/lpass-va-macro.c
+++ b/sound/soc/codecs/lpass-va-macro.c
@@ -1408,7 +1408,7 @@ static int va_macro_probe(struct platform_device *pdev)
 	va->clks[1].id = "dcodec";
 	va->clks[2].id = "mclk";
 
-	ret = devm_clk_bulk_get(dev, VA_NUM_CLKS_MAX, va->clks);
+	ret = devm_clk_bulk_get_optional(dev, VA_NUM_CLKS_MAX, va->clks);
 	if (ret) {
 		dev_err(dev, "Error getting VA Clocks (%d)\n", ret);
 		return ret;
diff --git a/sound/soc/codecs/tlv320adcx140.c b/sound/soc/codecs/tlv320adcx140.c
index 32b120d624b2..06d2502b1347 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -870,7 +870,7 @@ static int adcx140_configure_gpio(struct adcx140_priv *adcx140)
 
 	gpio_count = device_property_count_u32(adcx140->dev,
 			"ti,gpio-config");
-	if (gpio_count == 0)
+	if (gpio_count <= 0)
 		return 0;
 
 	if (gpio_count != ADCX140_NUM_GPIO_CFGS)
diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 5ba06df2ace5..6a12cbd43084 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -231,6 +231,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 	if (!sai->is_lsb_first)
 		val_cr4 |= FSL_SAI_CR4_MF;
 
+	sai->is_dsp_mode = false;
 	/* DAI mode */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
@@ -297,23 +298,23 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 		return -EINVAL;
 	}
 
-	/* DAI clock master masks */
-	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
-	case SND_SOC_DAIFMT_CBS_CFS:
+	/* DAI clock provider masks */
+	switch (fmt & SND_SOC_DAIFMT_CLOCK_PROVIDER_MASK) {
+	case SND_SOC_DAIFMT_CBC_CFC:
 		val_cr2 |= FSL_SAI_CR2_BCD_MSTR;
 		val_cr4 |= FSL_SAI_CR4_FSD_MSTR;
-		sai->is_slave_mode = false;
+		sai->is_consumer_mode = false;
 		break;
-	case SND_SOC_DAIFMT_CBM_CFM:
-		sai->is_slave_mode = true;
+	case SND_SOC_DAIFMT_CBP_CFP:
+		sai->is_consumer_mode = true;
 		break;
-	case SND_SOC_DAIFMT_CBS_CFM:
+	case SND_SOC_DAIFMT_CBC_CFP:
 		val_cr2 |= FSL_SAI_CR2_BCD_MSTR;
-		sai->is_slave_mode = false;
+		sai->is_consumer_mode = false;
 		break;
-	case SND_SOC_DAIFMT_CBM_CFS:
+	case SND_SOC_DAIFMT_CBP_CFC:
 		val_cr4 |= FSL_SAI_CR4_FSD_MSTR;
-		sai->is_slave_mode = true;
+		sai->is_consumer_mode = true;
 		break;
 	default:
 		return -EINVAL;
@@ -356,8 +357,8 @@ static int fsl_sai_set_bclk(struct snd_soc_dai *dai, bool tx, u32 freq)
 	u32 id;
 	int ret = 0;
 
-	/* Don't apply to slave mode */
-	if (sai->is_slave_mode)
+	/* Don't apply to consumer mode */
+	if (sai->is_consumer_mode)
 		return 0;
 
 	/*
@@ -462,7 +463,7 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 
 	pins = DIV_ROUND_UP(channels, slots);
 
-	if (!sai->is_slave_mode) {
+	if (!sai->is_consumer_mode) {
 		if (sai->bclk_ratio)
 			ret = fsl_sai_set_bclk(cpu_dai, tx,
 					       sai->bclk_ratio *
@@ -502,12 +503,12 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
 		val_cr4 |= FSL_SAI_CR4_CHMOD;
 
 	/*
-	 * For SAI master mode, when Tx(Rx) sync with Rx(Tx) clock, Rx(Tx) will
+	 * For SAI provider mode, when Tx(Rx) sync with Rx(Tx) clock, Rx(Tx) will
 	 * generate bclk and frame clock for Tx(Rx), we should set RCR4(TCR4),
 	 * RCR5(TCR5) for playback(capture), or there will be sync error.
 	 */
 
-	if (!sai->is_slave_mode && fsl_sai_dir_is_synced(sai, adir)) {
+	if (!sai->is_consumer_mode && fsl_sai_dir_is_synced(sai, adir)) {
 		regmap_update_bits(sai->regmap, FSL_SAI_xCR4(!tx, ofs),
 				   FSL_SAI_CR4_SYWD_MASK | FSL_SAI_CR4_FRSZ_MASK |
 				   FSL_SAI_CR4_CHMOD_MASK,
@@ -543,7 +544,7 @@ static int fsl_sai_hw_free(struct snd_pcm_substream *substream,
 	regmap_update_bits(sai->regmap, FSL_SAI_xCR3(tx, ofs),
 			   FSL_SAI_CR3_TRCE_MASK, 0);
 
-	if (!sai->is_slave_mode &&
+	if (!sai->is_consumer_mode &&
 			sai->mclk_streams & BIT(substream->stream)) {
 		clk_disable_unprepare(sai->mclk_clk[sai->mclk_id[tx]]);
 		sai->mclk_streams &= ~BIT(substream->stream);
@@ -577,7 +578,7 @@ static void fsl_sai_config_disable(struct fsl_sai *sai, int dir)
 	 * This is a hardware bug, and will be fix in the
 	 * next sai version.
 	 */
-	if (!sai->is_slave_mode) {
+	if (!sai->is_consumer_mode) {
 		/* Software Reset */
 		regmap_write(sai->regmap, FSL_SAI_xCSR(tx, ofs), FSL_SAI_CSR_SR);
 		/* Clear SR bit to finish the reset */
diff --git a/sound/soc/fsl/fsl_sai.h b/sound/soc/fsl/fsl_sai.h
index f471467dfb3e..93da86009c75 100644
--- a/sound/soc/fsl/fsl_sai.h
+++ b/sound/soc/fsl/fsl_sai.h
@@ -259,7 +259,7 @@ struct fsl_sai {
 	struct clk *bus_clk;
 	struct clk *mclk_clk[FSL_SAI_MCLK_MAX];
 
-	bool is_slave_mode;
+	bool is_consumer_mode;
 	bool is_lsb_first;
 	bool is_dsp_mode;
 	bool synchronous[2];
diff --git a/sound/soc/kirkwood/kirkwood-dma.c b/sound/soc/kirkwood/kirkwood-dma.c
index 700a18561a94..640cebd2983e 100644
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
diff --git a/sound/soc/sh/rcar/rsnd.h b/sound/soc/sh/rcar/rsnd.h
index d9cd190d7e19..f8ef6836ef84 100644
--- a/sound/soc/sh/rcar/rsnd.h
+++ b/sound/soc/sh/rcar/rsnd.h
@@ -901,8 +901,6 @@ void rsnd_mod_make_sure(struct rsnd_mod *mod, enum rsnd_mod_type type);
 	if (!IS_BUILTIN(RSND_DEBUG_NO_DAI_CALL))	\
 		dev_dbg(dev, param)
 
-#endif
-
 #ifdef CONFIG_DEBUG_FS
 int rsnd_debugfs_probe(struct snd_soc_component *component);
 void rsnd_debugfs_reg_show(struct seq_file *m, phys_addr_t _addr,
@@ -913,3 +911,5 @@ void rsnd_debugfs_mod_reg_show(struct seq_file *m, struct rsnd_mod *mod,
 #else
 #define rsnd_debugfs_probe  NULL
 #endif
+
+#endif /* RSND_H */
diff --git a/sound/soc/soc-compress.c b/sound/soc/soc-compress.c
index 2050728063a1..c2703a7598dd 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -116,6 +116,8 @@ static int soc_compr_open_fe(struct snd_compr_stream *cstream)
 	if (ret < 0)
 		goto be_err;
 
+	mutex_lock_nested(&fe->card->pcm_mutex, fe->card->pcm_subclass);
+
 	/* calculate valid and active FE <-> BE dpcms */
 	dpcm_process_paths(fe, stream, &list, 1);
 	fe->dpcm[stream].runtime = fe_substream->runtime;
@@ -151,7 +153,6 @@ static int soc_compr_open_fe(struct snd_compr_stream *cstream)
 	fe->dpcm[stream].state = SND_SOC_DPCM_STATE_OPEN;
 	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_NO;
 
-	mutex_lock_nested(&fe->card->pcm_mutex, fe->card->pcm_subclass);
 	snd_soc_runtime_activate(fe, stream);
 	mutex_unlock(&fe->card->pcm_mutex);
 
@@ -182,7 +183,6 @@ static int soc_compr_free_fe(struct snd_compr_stream *cstream)
 
 	mutex_lock_nested(&fe->card->pcm_mutex, fe->card->pcm_subclass);
 	snd_soc_runtime_deactivate(fe, stream);
-	mutex_unlock(&fe->card->pcm_mutex);
 
 	fe->dpcm[stream].runtime_update = SND_SOC_DPCM_UPDATE_FE;
 
@@ -201,6 +201,8 @@ static int soc_compr_free_fe(struct snd_compr_stream *cstream)
 
 	dpcm_be_disconnect(fe, stream);
 
+	mutex_unlock(&fe->card->pcm_mutex);
+
 	fe->dpcm[stream].runtime = NULL;
 
 	snd_soc_link_compr_shutdown(cstream, 0);
@@ -376,8 +378,9 @@ static int soc_compr_set_params_fe(struct snd_compr_stream *cstream,
 	ret = snd_soc_link_compr_set_params(cstream);
 	if (ret < 0)
 		goto out;
-
+	mutex_lock_nested(&fe->card->pcm_mutex, fe->card->pcm_subclass);
 	dpcm_dapm_stream_event(fe, stream, SND_SOC_DAPM_STREAM_START);
+	mutex_unlock(&fe->card->pcm_mutex);
 	fe->dpcm[stream].state = SND_SOC_DPCM_STATE_PREPARE;
 
 out:
@@ -590,7 +593,7 @@ int snd_soc_new_compress(struct snd_soc_pcm_runtime *rtd, int num)
 		rtd->fe_compr = 1;
 		if (rtd->dai_link->dpcm_playback)
 			be_pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream->private_data = rtd;
-		else if (rtd->dai_link->dpcm_capture)
+		if (rtd->dai_link->dpcm_capture)
 			be_pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream->private_data = rtd;
 		memcpy(compr->ops, &soc_compr_dyn_ops, sizeof(soc_compr_dyn_ops));
 	} else {
diff --git a/tools/bootconfig/scripts/ftrace2bconf.sh b/tools/bootconfig/scripts/ftrace2bconf.sh
index 6183b36c6846..1603801cf126 100755
--- a/tools/bootconfig/scripts/ftrace2bconf.sh
+++ b/tools/bootconfig/scripts/ftrace2bconf.sh
@@ -93,7 +93,7 @@ referred_vars() {
 }
 
 event_is_enabled() { # enable-file
-	test -f $1 & grep -q "1" $1
+	test -f $1 && grep -q "1" $1
 }
 
 per_event_options() { # event-dir
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index f8755beb3d9e..bdd4d3b12f6c 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -2064,10 +2064,38 @@ static void profile_close_perf_events(struct profiler_bpf *obj)
 	profile_perf_event_cnt = 0;
 }
 
+static int profile_open_perf_event(int mid, int cpu, int map_fd)
+{
+	int pmu_fd;
+
+	pmu_fd = syscall(__NR_perf_event_open, &metrics[mid].attr,
+			 -1 /*pid*/, cpu, -1 /*group_fd*/, 0);
+	if (pmu_fd < 0) {
+		if (errno == ENODEV) {
+			p_info("cpu %d may be offline, skip %s profiling.",
+				cpu, metrics[mid].name);
+			profile_perf_event_cnt++;
+			return 0;
+		}
+		return -1;
+	}
+
+	if (bpf_map_update_elem(map_fd,
+				&profile_perf_event_cnt,
+				&pmu_fd, BPF_ANY) ||
+	    ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0)) {
+		close(pmu_fd);
+		return -1;
+	}
+
+	profile_perf_events[profile_perf_event_cnt++] = pmu_fd;
+	return 0;
+}
+
 static int profile_open_perf_events(struct profiler_bpf *obj)
 {
 	unsigned int cpu, m;
-	int map_fd, pmu_fd;
+	int map_fd;
 
 	profile_perf_events = calloc(
 		sizeof(int), obj->rodata->num_cpu * obj->rodata->num_metric);
@@ -2086,17 +2114,11 @@ static int profile_open_perf_events(struct profiler_bpf *obj)
 		if (!metrics[m].selected)
 			continue;
 		for (cpu = 0; cpu < obj->rodata->num_cpu; cpu++) {
-			pmu_fd = syscall(__NR_perf_event_open, &metrics[m].attr,
-					 -1/*pid*/, cpu, -1/*group_fd*/, 0);
-			if (pmu_fd < 0 ||
-			    bpf_map_update_elem(map_fd, &profile_perf_event_cnt,
-						&pmu_fd, BPF_ANY) ||
-			    ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0)) {
+			if (profile_open_perf_event(m, cpu, map_fd)) {
 				p_err("failed to create event %s on cpu %d",
 				      metrics[m].name, cpu);
 				return -1;
 			}
-			profile_perf_events[profile_perf_event_cnt++] = pmu_fd;
 		}
 	}
 	return 0;
diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index 3ed759f53e7c..fd2309512978 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -647,8 +647,21 @@ int btf__align_of(const struct btf *btf, __u32 id)
 			if (align <= 0)
 				return libbpf_err(align);
 			max_align = max(max_align, align);
+
+			/* if field offset isn't aligned according to field
+			 * type's alignment, then struct must be packed
+			 */
+			if (btf_member_bitfield_size(t, i) == 0 &&
+			    (m->offset % (8 * align)) != 0)
+				return 1;
 		}
 
+		/* if struct/union size isn't a multiple of its alignment,
+		 * then struct must be packed
+		 */
+		if ((t->size % max_align) != 0)
+			return 1;
+
 		return max_align;
 	}
 	default:
diff --git a/tools/lib/bpf/nlattr.c b/tools/lib/bpf/nlattr.c
index f57e77a6e40f..2dbe7b99f28f 100644
--- a/tools/lib/bpf/nlattr.c
+++ b/tools/lib/bpf/nlattr.c
@@ -178,7 +178,7 @@ int libbpf_nla_dump_errormsg(struct nlmsghdr *nlh)
 		hlen += nlmsg_len(&err->msg);
 
 	attr = (struct nlattr *) ((void *) err + hlen);
-	alen = nlh->nlmsg_len - hlen;
+	alen = (void *)nlh + nlh->nlmsg_len - (void *)attr;
 
 	if (libbpf_nla_parse(tb, NLMSGERR_ATTR_MAX, attr, alen,
 			     extack_policy) != 0) {
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 758c0ba8de35..2fc0270e3c1f 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -181,6 +181,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"kunit_try_catch_throw",
 		"xen_start_kernel",
 		"cpu_bringup_and_idle",
+		"stop_this_cpu",
 	};
 
 	if (!func)
@@ -907,6 +908,8 @@ static const char *uaccess_safe_builtin[] = {
 	"__tsan_atomic64_compare_exchange_val",
 	"__tsan_atomic_thread_fence",
 	"__tsan_atomic_signal_fence",
+	"__tsan_unaligned_read16",
+	"__tsan_unaligned_write16",
 	/* KCOV */
 	"write_comp_data",
 	"check_kcov_mode",
diff --git a/tools/perf/Documentation/perf-intel-pt.txt b/tools/perf/Documentation/perf-intel-pt.txt
index db465fa7ee91..de63c418e4d1 100644
--- a/tools/perf/Documentation/perf-intel-pt.txt
+++ b/tools/perf/Documentation/perf-intel-pt.txt
@@ -108,9 +108,10 @@ displayed as follows:
 
 	perf script --itrace=ibxwpe -F+flags
 
-The flags are "bcrosyiABExgh" which stand for branch, call, return, conditional,
+The flags are "bcrosyiABExghDt" which stand for branch, call, return, conditional,
 system, asynchronous, interrupt, transaction abort, trace begin, trace end,
-in transaction, VM-entry, and VM-exit respectively.
+in transaction, VM-entry, VM-exit, interrupt disabled, and interrupt disable
+toggle respectively.
 
 perf script also supports higher level ways to dump instruction traces:
 
@@ -456,6 +457,8 @@ ptw		Enable PTWRITE packets which are produced when a ptwrite instruction
 		which contains "1" if the feature is supported and
 		"0" otherwise.
 
+		As an alternative, refer to "Emulated PTWRITE" further below.
+
 fup_on_ptw	Enable a FUP packet to follow the PTWRITE packet.  The FUP packet
 		provides the address of the ptwrite instruction.  In the absence of
 		fup_on_ptw, the decoder will use the address of the previous branch
@@ -472,6 +475,30 @@ pwr_evt		Enable power events.  The power events provide information about
 		which contains "1" if the feature is supported and
 		"0" otherwise.
 
+event		Enable Event Trace.  The events provide information about asynchronous
+		events.
+
+		Support for this feature is indicated by:
+
+			/sys/bus/event_source/devices/intel_pt/caps/event_trace
+
+		which contains "1" if the feature is supported and
+		"0" otherwise.
+
+notnt		Disable TNT packets.  Without TNT packets, it is not possible to walk
+		executable code to reconstruct control flow, however FUP, TIP, TIP.PGE
+		and TIP.PGD packets still indicate asynchronous control flow, and (if
+		return compression is disabled - see noretcomp) return statements.
+		The advantage of eliminating TNT packets is reducing the size of the
+		trace and corresponding tracing overhead.
+
+		Support for this feature is indicated by:
+
+			/sys/bus/event_source/devices/intel_pt/caps/tnt_disable
+
+		which contains "1" if the feature is supported and
+		"0" otherwise.
+
 
 AUX area sampling option
 ~~~~~~~~~~~~~~~~~~~~~~~~
@@ -865,6 +892,8 @@ The letters are:
 	p	synthesize "power" events (incl. PSB events)
 	c	synthesize branches events (calls only)
 	r	synthesize branches events (returns only)
+	o	synthesize PEBS-via-PT events
+	I	synthesize Event Trace events
 	e	synthesize tracing error events
 	d	create a debug log
 	g	synthesize a call chain (use with i or x)
@@ -1338,6 +1367,202 @@ There were none.
           :17006 17006 [001] 11500.262869216:  ffffffff8220116e error_entry+0xe ([guest.kernel.kallsyms])               pushq  %rax
 
 
+Event Trace
+-----------
+
+Event Trace records information about asynchronous events, for example interrupts,
+faults, VM exits and entries.  The information is recorded in CFE and EVD packets,
+and also the Interrupt Flag is recorded on the MODE.Exec packet.  The CFE packet
+contains a type field to identify one of the following:
+
+	 1	INTR		interrupt, fault, exception, NMI
+	 2	IRET		interrupt return
+	 3	SMI		system management interrupt
+	 4	RSM		resume from system management mode
+	 5	SIPI		startup interprocessor interrupt
+	 6	INIT		INIT signal
+	 7	VMENTRY		VM-Entry
+	 8	VMEXIT		VM-Entry
+	 9	VMEXIT_INTR	VM-Exit due to interrupt
+	10	SHUTDOWN	Shutdown
+
+For more details, refer to the Intel 64 and IA-32 Architectures Software
+Developer Manuals (version 076 or later).
+
+The capability to do Event Trace is indicated by the
+/sys/bus/event_source/devices/intel_pt/caps/event_trace file.
+
+Event trace is selected for recording using the "event" config term. e.g.
+
+	perf record -e intel_pt/event/u uname
+
+Event trace events are output using the --itrace I option. e.g.
+
+	perf script --itrace=Ie
+
+perf script displays events containing CFE type, vector and event data,
+in the form:
+
+	  evt:   hw int            (t)  cfe: INTR IP: 1 vector: 3 PFA: 0x8877665544332211
+
+The IP flag indicates if the event binds to an IP, which includes any case where
+flow control packet generation is enabled, as well as when CFE packet IP bit is
+set.
+
+perf script displays events containing changes to the Interrupt Flag in the form:
+
+	iflag:   t                      IFLAG: 1->0 via branch
+
+where "via branch" indicates a branch (interrupt or return from interrupt) and
+"non branch" indicates an instruction such as CFI, STI or POPF).
+
+In addition, the current state of the interrupt flag is indicated by the presence
+or absence of the "D" (interrupt disabled) perf script flag.  If the interrupt
+flag is changed, then the "t" flag is also included i.e.
+
+		no flag, interrupts enabled IF=1
+	t	interrupts become disabled IF=1 -> IF=0
+	D	interrupts are disabled IF=0
+	Dt	interrupts become enabled  IF=0 -> IF=1
+
+The intel-pt-events.py script illustrates how to access Event Trace information
+using a Python script.
+
+
+TNT Disable
+-----------
+
+TNT packets are disabled using the "notnt" config term. e.g.
+
+	perf record -e intel_pt/notnt/u uname
+
+In that case the --itrace q option is forced because walking executable code
+to reconstruct the control flow is not possible.
+
+
+Emulated PTWRITE
+----------------
+
+Later perf tools support a method to emulate the ptwrite instruction, which
+can be useful if hardware does not support the ptwrite instruction.
+
+Instead of using the ptwrite instruction, a function is used which produces
+a trace that encodes the payload data into TNT packets.  Here is an example
+of the function:
+
+ #include <stdint.h>
+
+ void perf_emulate_ptwrite(uint64_t x)
+ __attribute__((externally_visible, noipa, no_instrument_function, naked));
+
+ #define PERF_EMULATE_PTWRITE_8_BITS \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"        \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"        \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"        \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"        \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"        \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"        \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"        \
+                 "1: shl %rax\n"     \
+                 "   jc 1f\n"
+
+ /* Undefined instruction */
+ #define PERF_EMULATE_PTWRITE_UD2        ".byte 0x0f, 0x0b\n"
+
+ #define PERF_EMULATE_PTWRITE_MAGIC        PERF_EMULATE_PTWRITE_UD2 ".ascii \"perf,ptwrite  \"\n"
+
+ void perf_emulate_ptwrite(uint64_t x __attribute__ ((__unused__)))
+ {
+          /* Assumes SysV ABI : x passed in rdi */
+         __asm__ volatile (
+                 "jmp 1f\n"
+                 PERF_EMULATE_PTWRITE_MAGIC
+                 "1: mov %rdi, %rax\n"
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 PERF_EMULATE_PTWRITE_8_BITS
+                 "1: ret\n"
+         );
+ }
+
+For example, a test program with the function above:
+
+ #include <stdio.h>
+ #include <stdint.h>
+ #include <stdlib.h>
+
+ #include "perf_emulate_ptwrite.h"
+
+ int main(int argc, char *argv[])
+ {
+         uint64_t x = 0;
+
+         if (argc > 1)
+                 x = strtoull(argv[1], NULL, 0);
+         perf_emulate_ptwrite(x);
+         return 0;
+ }
+
+Can be compiled and traced:
+
+ $ gcc -Wall -Wextra -O3 -g -o eg_ptw eg_ptw.c
+ $ perf record -e intel_pt//u ./eg_ptw 0x1234567890abcdef
+ [ perf record: Woken up 1 times to write data ]
+ [ perf record: Captured and wrote 0.017 MB perf.data ]
+ $ perf script --itrace=ew
+           eg_ptw 19875 [007]  8061.235912:     ptwrite:  IP: 0 payload: 0x1234567890abcdef      55701249a196 perf_emulate_ptwrite+0x16 (/home/user/eg_ptw)
+ $
+
+
+Pipe mode
+---------
+Pipe mode is a problem for Intel PT and possibly other auxtrace users.
+It's not recommended to use a pipe as data output with Intel PT because
+of the following reason.
+
+Essentially the auxtrace buffers do not behave like the regular perf
+event buffers.  That is because the head and tail are updated by
+software, but in the auxtrace case the data is written by hardware.
+So the head and tail do not get updated as data is written.
+
+In the Intel PT case, the head and tail are updated only when the trace
+is disabled by software, for example:
+    - full-trace, system wide : when buffer passes watermark
+    - full-trace, not system-wide : when buffer passes watermark or
+                                    context switches
+    - snapshot mode : as above but also when a snapshot is made
+    - sample mode : as above but also when a sample is made
+
+That means finished-round ordering doesn't work.  An auxtrace buffer
+can turn up that has data that extends back in time, possibly to the
+very beginning of tracing.
+
+For a perf.data file, that problem is solved by going through the trace
+and queuing up the auxtrace buffers in advance.
+
+For pipe mode, the order of events and timestamps can presumably
+be messed up.
+
+
+EXAMPLE
+-------
+
+Examples can be found on perf wiki page "Perf tools support for Intel® Processor Trace":
+
+https://perf.wiki.kernel.org/index.php/Perf_tools_support_for_Intel%C2%AE_Processor_Trace
+
 
 SEE ALSO
 --------
diff --git a/tools/perf/arch/x86/tests/intel-pt-pkt-decoder-test.c b/tools/perf/arch/x86/tests/intel-pt-pkt-decoder-test.c
index c933e3dcd0a8..9589314d60b7 100644
--- a/tools/perf/arch/x86/tests/intel-pt-pkt-decoder-test.c
+++ b/tools/perf/arch/x86/tests/intel-pt-pkt-decoder-test.c
@@ -166,6 +166,14 @@ struct test_data {
 	{2, {0x02, 0xb3}, INTEL_PT_BLK_4_CTX, {INTEL_PT_BEP_IP, 0, 0}, 0, 0 },
 	{2, {0x02, 0x33}, INTEL_PT_BLK_8_CTX, {INTEL_PT_BEP, 0, 0}, 0, 0 },
 	{2, {0x02, 0xb3}, INTEL_PT_BLK_8_CTX, {INTEL_PT_BEP_IP, 0, 0}, 0, 0 },
+	/* Control Flow Event Packet */
+	{4, {0x02, 0x13, 0x01, 0x03}, 0, {INTEL_PT_CFE, 1, 3}, 0, 0 },
+	{4, {0x02, 0x13, 0x81, 0x03}, 0, {INTEL_PT_CFE_IP, 1, 3}, 0, 0 },
+	{4, {0x02, 0x13, 0x1f, 0x00}, 0, {INTEL_PT_CFE, 0x1f, 0}, 0, 0 },
+	{4, {0x02, 0x13, 0x9f, 0xff}, 0, {INTEL_PT_CFE_IP, 0x1f, 0xff}, 0, 0 },
+	/*  */
+	{11, {0x02, 0x53, 0x09, 1, 2, 3, 4, 5, 6, 7}, 0, {INTEL_PT_EVD, 0x09, 0x7060504030201}, 0, 0 },
+	{11, {0x02, 0x53, 0x3f, 2, 3, 4, 5, 6, 7, 8}, 0, {INTEL_PT_EVD, 0x3f, 0x8070605040302}, 0, 0 },
 	/* Terminator */
 	{0, {0}, 0, {0, 0, 0}, 0, 0 },
 };
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 50c2e6892b3e..f15c146e0054 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -142,14 +142,14 @@ static int perf_event__repipe_event_update(struct perf_tool *tool,
 
 #ifdef HAVE_AUXTRACE_SUPPORT
 
-static int copy_bytes(struct perf_inject *inject, int fd, off_t size)
+static int copy_bytes(struct perf_inject *inject, struct perf_data *data, off_t size)
 {
 	char buf[4096];
 	ssize_t ssz;
 	int ret;
 
 	while (size > 0) {
-		ssz = read(fd, buf, min(size, (off_t)sizeof(buf)));
+		ssz = perf_data__read(data, buf, min(size, (off_t)sizeof(buf)));
 		if (ssz < 0)
 			return -errno;
 		ret = output_bytes(inject, buf, ssz);
@@ -187,7 +187,7 @@ static s64 perf_event__repipe_auxtrace(struct perf_session *session,
 		ret = output_bytes(inject, event, event->header.size);
 		if (ret < 0)
 			return ret;
-		ret = copy_bytes(inject, perf_data__fd(session->data),
+		ret = copy_bytes(inject, session->data,
 				 event->auxtrace.size);
 	} else {
 		ret = output_bytes(inject, event,
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
diff --git a/tools/perf/util/auxtrace.c b/tools/perf/util/auxtrace.c
index 0ef4cbf21e62..344b65a8f768 100644
--- a/tools/perf/util/auxtrace.c
+++ b/tools/perf/util/auxtrace.c
@@ -1107,6 +1107,9 @@ int auxtrace_queue_data(struct perf_session *session, bool samples, bool events)
 	if (auxtrace__dont_decode(session))
 		return 0;
 
+	if (perf_data__is_pipe(session->data))
+		return 0;
+
 	if (!session->auxtrace || !session->auxtrace->queue_data)
 		return -EINVAL;
 
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
index b0034ee4bba5..372ffec96c2d 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.c
@@ -137,6 +137,7 @@ struct intel_pt_decoder {
 	bool in_psb;
 	bool hop;
 	bool leap;
+	bool emulated_ptwrite;
 	bool vm_time_correlation;
 	bool vm_tm_corr_dry_run;
 	bool vm_tm_corr_reliable;
@@ -473,6 +474,8 @@ static int intel_pt_ext_err(int code)
 		return INTEL_PT_ERR_LOST;
 	case -ELOOP:
 		return INTEL_PT_ERR_NELOOP;
+	case -ECONNRESET:
+		return INTEL_PT_ERR_EPTW;
 	default:
 		return INTEL_PT_ERR_UNK;
 	}
@@ -489,6 +492,7 @@ static const char *intel_pt_err_msgs[] = {
 	[INTEL_PT_ERR_LOST]   = "Lost trace data",
 	[INTEL_PT_ERR_UNK]    = "Unknown error!",
 	[INTEL_PT_ERR_NELOOP] = "Never-ending loop (refer perf config intel-pt.max-loops)",
+	[INTEL_PT_ERR_EPTW]   = "Broken emulated ptwrite",
 };
 
 int intel_pt__strerror(int code, char *buf, size_t buflen)
@@ -819,6 +823,9 @@ static int intel_pt_calc_cyc_cb(struct intel_pt_pkt_info *pkt_info)
 	case INTEL_PT_BIP:
 	case INTEL_PT_BEP:
 	case INTEL_PT_BEP_IP:
+	case INTEL_PT_CFE:
+	case INTEL_PT_CFE_IP:
+	case INTEL_PT_EVD:
 		return 0;
 
 	case INTEL_PT_MTC:
@@ -1402,17 +1409,108 @@ static int intel_pt_walk_tip(struct intel_pt_decoder *decoder)
 	return intel_pt_bug(decoder);
 }
 
+struct eptw_data {
+	int bit_countdown;
+	uint64_t payload;
+};
+
+static int intel_pt_eptw_lookahead_cb(struct intel_pt_pkt_info *pkt_info)
+{
+	struct eptw_data *data = pkt_info->data;
+	int nr_bits;
+
+	switch (pkt_info->packet.type) {
+	case INTEL_PT_PAD:
+	case INTEL_PT_MNT:
+	case INTEL_PT_MODE_EXEC:
+	case INTEL_PT_MODE_TSX:
+	case INTEL_PT_MTC:
+	case INTEL_PT_FUP:
+	case INTEL_PT_CYC:
+	case INTEL_PT_CBR:
+	case INTEL_PT_TSC:
+	case INTEL_PT_TMA:
+	case INTEL_PT_PIP:
+	case INTEL_PT_VMCS:
+	case INTEL_PT_PSB:
+	case INTEL_PT_PSBEND:
+	case INTEL_PT_PTWRITE:
+	case INTEL_PT_PTWRITE_IP:
+	case INTEL_PT_EXSTOP:
+	case INTEL_PT_EXSTOP_IP:
+	case INTEL_PT_MWAIT:
+	case INTEL_PT_PWRE:
+	case INTEL_PT_PWRX:
+	case INTEL_PT_BBP:
+	case INTEL_PT_BIP:
+	case INTEL_PT_BEP:
+	case INTEL_PT_BEP_IP:
+	case INTEL_PT_CFE:
+	case INTEL_PT_CFE_IP:
+	case INTEL_PT_EVD:
+		break;
+
+	case INTEL_PT_TNT:
+		nr_bits = data->bit_countdown;
+		if (nr_bits > pkt_info->packet.count)
+			nr_bits = pkt_info->packet.count;
+		data->payload <<= nr_bits;
+		data->payload |= pkt_info->packet.payload >> (64 - nr_bits);
+		data->bit_countdown -= nr_bits;
+		return !data->bit_countdown;
+
+	case INTEL_PT_TIP_PGE:
+	case INTEL_PT_TIP_PGD:
+	case INTEL_PT_TIP:
+	case INTEL_PT_BAD:
+	case INTEL_PT_OVF:
+	case INTEL_PT_TRACESTOP:
+	default:
+		return 1;
+	}
+
+	return 0;
+}
+
+static int intel_pt_emulated_ptwrite(struct intel_pt_decoder *decoder)
+{
+	int n = 64 - decoder->tnt.count;
+	struct eptw_data data = {
+		.bit_countdown = n,
+		.payload = decoder->tnt.payload >> n,
+	};
+
+	decoder->emulated_ptwrite = false;
+	intel_pt_log("Emulated ptwrite detected\n");
+
+	intel_pt_pkt_lookahead(decoder, intel_pt_eptw_lookahead_cb, &data);
+	if (data.bit_countdown)
+		return -ECONNRESET;
+
+	decoder->state.type = INTEL_PT_PTW;
+	decoder->state.from_ip = decoder->ip;
+	decoder->state.to_ip = 0;
+	decoder->state.ptw_payload = data.payload;
+	return 0;
+}
+
 static int intel_pt_walk_tnt(struct intel_pt_decoder *decoder)
 {
 	struct intel_pt_insn intel_pt_insn;
 	int err;
 
 	while (1) {
+		if (decoder->emulated_ptwrite)
+			return intel_pt_emulated_ptwrite(decoder);
 		err = intel_pt_walk_insn(decoder, &intel_pt_insn, 0);
-		if (err == INTEL_PT_RETURN)
+		if (err == INTEL_PT_RETURN) {
+			decoder->emulated_ptwrite = intel_pt_insn.emulated_ptwrite;
 			return 0;
-		if (err)
+		}
+		if (err) {
+			decoder->emulated_ptwrite = false;
 			return err;
+		}
 
 		if (intel_pt_insn.op == INTEL_PT_OP_RET) {
 			if (!decoder->return_compression) {
@@ -1872,6 +1970,9 @@ static int intel_pt_walk_psbend(struct intel_pt_decoder *decoder)
 		case INTEL_PT_BIP:
 		case INTEL_PT_BEP:
 		case INTEL_PT_BEP_IP:
+		case INTEL_PT_CFE:
+		case INTEL_PT_CFE_IP:
+		case INTEL_PT_EVD:
 			decoder->have_tma = false;
 			intel_pt_log("ERROR: Unexpected packet\n");
 			err = -EAGAIN;
@@ -1974,6 +2075,9 @@ static int intel_pt_walk_fup_tip(struct intel_pt_decoder *decoder)
 		case INTEL_PT_BIP:
 		case INTEL_PT_BEP:
 		case INTEL_PT_BEP_IP:
+		case INTEL_PT_CFE:
+		case INTEL_PT_CFE_IP:
+		case INTEL_PT_EVD:
 			intel_pt_log("ERROR: Missing TIP after FUP\n");
 			decoder->pkt_state = INTEL_PT_STATE_ERR3;
 			decoder->pkt_step = 0;
@@ -2133,6 +2237,9 @@ static int intel_pt_vm_psb_lookahead_cb(struct intel_pt_pkt_info *pkt_info)
 	case INTEL_PT_TIP:
 	case INTEL_PT_PSB:
 	case INTEL_PT_TRACESTOP:
+	case INTEL_PT_CFE:
+	case INTEL_PT_CFE_IP:
+	case INTEL_PT_EVD:
 	default:
 		return 1;
 	}
@@ -2652,6 +2759,9 @@ static int intel_pt_vm_time_correlation(struct intel_pt_decoder *decoder)
 			decoder->blk_type = 0;
 			break;
 
+		case INTEL_PT_CFE:
+		case INTEL_PT_CFE_IP:
+		case INTEL_PT_EVD:
 		case INTEL_PT_MODE_EXEC:
 		case INTEL_PT_MODE_TSX:
 		case INTEL_PT_MNT:
@@ -2788,6 +2898,9 @@ static int intel_pt_hop_trace(struct intel_pt_decoder *decoder, bool *no_tip, in
 	case INTEL_PT_BIP:
 	case INTEL_PT_BEP:
 	case INTEL_PT_BEP_IP:
+	case INTEL_PT_CFE:
+	case INTEL_PT_CFE_IP:
+	case INTEL_PT_EVD:
 	default:
 		return HOP_PROCESS;
 	}
@@ -2856,6 +2969,9 @@ static int intel_pt_psb_lookahead_cb(struct intel_pt_pkt_info *pkt_info)
 	case INTEL_PT_BIP:
 	case INTEL_PT_BEP:
 	case INTEL_PT_BEP_IP:
+	case INTEL_PT_CFE:
+	case INTEL_PT_CFE_IP:
+	case INTEL_PT_EVD:
 		if (data->after_psbend) {
 			data->after_psbend -= 1;
 			if (!data->after_psbend)
@@ -3222,6 +3338,11 @@ static int intel_pt_walk_trace(struct intel_pt_decoder *decoder)
 			}
 			goto next;
 
+		case INTEL_PT_CFE:
+		case INTEL_PT_CFE_IP:
+		case INTEL_PT_EVD:
+			break;
+
 		default:
 			return intel_pt_bug(decoder);
 		}
@@ -3264,6 +3385,9 @@ static int intel_pt_walk_psb(struct intel_pt_decoder *decoder)
 		case INTEL_PT_BIP:
 		case INTEL_PT_BEP:
 		case INTEL_PT_BEP_IP:
+		case INTEL_PT_CFE:
+		case INTEL_PT_CFE_IP:
+		case INTEL_PT_EVD:
 			intel_pt_log("ERROR: Unexpected packet\n");
 			err = -ENOENT;
 			goto out;
@@ -3475,6 +3599,9 @@ static int intel_pt_walk_to_ip(struct intel_pt_decoder *decoder)
 		case INTEL_PT_BIP:
 		case INTEL_PT_BEP:
 		case INTEL_PT_BEP_IP:
+		case INTEL_PT_CFE:
+		case INTEL_PT_CFE_IP:
+		case INTEL_PT_EVD:
 		default:
 			break;
 		}
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h
index 4b5e79fcf557..0a641aba3c7c 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-decoder.h
@@ -55,6 +55,7 @@ enum {
 	INTEL_PT_ERR_LOST,
 	INTEL_PT_ERR_UNK,
 	INTEL_PT_ERR_NELOOP,
+	INTEL_PT_ERR_EPTW,
 	INTEL_PT_ERR_MAX,
 };
 
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
index 593f20e9774c..9f29cf721077 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.c
@@ -32,6 +32,7 @@ static void intel_pt_insn_decoder(struct insn *insn,
 	int ext;
 
 	intel_pt_insn->rel = 0;
+	intel_pt_insn->emulated_ptwrite = false;
 
 	if (insn_is_avx(insn)) {
 		intel_pt_insn->op = INTEL_PT_OP_OTHER;
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.h b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.h
index c2861cfdd768..e3338b56a75f 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.h
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-insn-decoder.h
@@ -37,6 +37,7 @@ enum intel_pt_insn_branch {
 struct intel_pt_insn {
 	enum intel_pt_insn_op		op;
 	enum intel_pt_insn_branch	branch;
+	bool				emulated_ptwrite;
 	int				length;
 	int32_t				rel;
 	unsigned char			buf[INTEL_PT_INSN_BUF_SZ];
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.c b/tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.c
index 02a3395d6ce3..6ff97b6107b7 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.c
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.c
@@ -64,6 +64,9 @@ static const char * const packet_name[] = {
 	[INTEL_PT_BIP]		= "BIP",
 	[INTEL_PT_BEP]		= "BEP",
 	[INTEL_PT_BEP_IP]	= "BEP",
+	[INTEL_PT_CFE]		= "CFE",
+	[INTEL_PT_CFE_IP]	= "CFE",
+	[INTEL_PT_EVD]		= "EVD",
 };
 
 const char *intel_pt_pkt_name(enum intel_pt_pkt_type type)
@@ -329,6 +332,29 @@ static int intel_pt_get_bep_ip(size_t len, struct intel_pt_pkt *packet)
 	return 2;
 }
 
+static int intel_pt_get_cfe(const unsigned char *buf, size_t len,
+			    struct intel_pt_pkt *packet)
+{
+	if (len < 4)
+		return INTEL_PT_NEED_MORE_BYTES;
+	packet->type = buf[2] & 0x80 ? INTEL_PT_CFE_IP : INTEL_PT_CFE;
+	packet->count = buf[2] & 0x1f;
+	packet->payload = buf[3];
+	return 4;
+}
+
+static int intel_pt_get_evd(const unsigned char *buf, size_t len,
+			    struct intel_pt_pkt *packet)
+{
+	if (len < 11)
+		return INTEL_PT_NEED_MORE_BYTES;
+	packet->type = INTEL_PT_EVD;
+	packet->count = buf[2] & 0x3f;
+	packet->payload = buf[3];
+	memcpy_le64(&packet->payload, buf + 3, 8);
+	return 11;
+}
+
 static int intel_pt_get_ext(const unsigned char *buf, size_t len,
 			    struct intel_pt_pkt *packet)
 {
@@ -375,6 +401,10 @@ static int intel_pt_get_ext(const unsigned char *buf, size_t len,
 		return intel_pt_get_bep(len, packet);
 	case 0xb3: /* BEP with IP */
 		return intel_pt_get_bep_ip(len, packet);
+	case 0x13: /* CFE */
+		return intel_pt_get_cfe(buf, len, packet);
+	case 0x53: /* EVD */
+		return intel_pt_get_evd(buf, len, packet);
 	default:
 		return INTEL_PT_BAD_PACKET;
 	}
@@ -624,6 +654,9 @@ void intel_pt_upd_pkt_ctx(const struct intel_pt_pkt *packet,
 	case INTEL_PT_MWAIT:
 	case INTEL_PT_BEP:
 	case INTEL_PT_BEP_IP:
+	case INTEL_PT_CFE:
+	case INTEL_PT_CFE_IP:
+	case INTEL_PT_EVD:
 		*ctx = INTEL_PT_NO_CTX;
 		break;
 	case INTEL_PT_BBP:
@@ -751,6 +784,13 @@ int intel_pt_pkt_desc(const struct intel_pt_pkt *packet, char *buf,
 	case INTEL_PT_BIP:
 		return snprintf(buf, buf_len, "%s ID 0x%02x Value 0x%llx",
 				name, packet->count, payload);
+	case INTEL_PT_CFE:
+	case INTEL_PT_CFE_IP:
+		return snprintf(buf, buf_len, "%s IP:%d Type 0x%02x Vector 0x%llx",
+				name, packet->type == INTEL_PT_CFE_IP, packet->count, payload);
+	case INTEL_PT_EVD:
+		return snprintf(buf, buf_len, "%s Type 0x%02x Payload 0x%llx",
+				name, packet->count, payload);
 	default:
 		break;
 	}
diff --git a/tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.h b/tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.h
index 996090cb84f6..496ba4be875c 100644
--- a/tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.h
+++ b/tools/perf/util/intel-pt-decoder/intel-pt-pkt-decoder.h
@@ -56,6 +56,9 @@ enum intel_pt_pkt_type {
 	INTEL_PT_BIP,
 	INTEL_PT_BEP,
 	INTEL_PT_BEP_IP,
+	INTEL_PT_CFE,
+	INTEL_PT_CFE_IP,
+	INTEL_PT_EVD,
 };
 
 struct intel_pt_pkt {
diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 632419546705..7a2ce387079e 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -506,6 +506,7 @@ struct intel_pt_cache_entry {
 	u64				byte_cnt;
 	enum intel_pt_insn_op		op;
 	enum intel_pt_insn_branch	branch;
+	bool				emulated_ptwrite;
 	int				length;
 	int32_t				rel;
 	char				insn[INTEL_PT_INSN_BUF_SZ];
@@ -592,6 +593,7 @@ static int intel_pt_cache_add(struct dso *dso, struct machine *machine,
 	e->byte_cnt = byte_cnt;
 	e->op = intel_pt_insn->op;
 	e->branch = intel_pt_insn->branch;
+	e->emulated_ptwrite = intel_pt_insn->emulated_ptwrite;
 	e->length = intel_pt_insn->length;
 	e->rel = intel_pt_insn->rel;
 	memcpy(e->insn, intel_pt_insn->buf, INTEL_PT_INSN_BUF_SZ);
@@ -678,6 +680,28 @@ static int intel_pt_get_guest(struct intel_pt_queue *ptq)
 	return 0;
 }
 
+static inline bool intel_pt_jmp_16(struct intel_pt_insn *intel_pt_insn)
+{
+	return intel_pt_insn->rel == 16 && intel_pt_insn->branch == INTEL_PT_BR_UNCONDITIONAL;
+}
+
+#define PTWRITE_MAGIC		"\x0f\x0bperf,ptwrite  "
+#define PTWRITE_MAGIC_LEN	16
+
+static bool intel_pt_emulated_ptwrite(struct dso *dso, struct machine *machine, u64 offset)
+{
+	unsigned char buf[PTWRITE_MAGIC_LEN];
+	ssize_t len;
+
+	len = dso__data_read_offset(dso, machine, offset, buf, PTWRITE_MAGIC_LEN);
+	if (len == PTWRITE_MAGIC_LEN && !memcmp(buf, PTWRITE_MAGIC, PTWRITE_MAGIC_LEN)) {
+		intel_pt_log("Emulated ptwrite signature found\n");
+		return true;
+	}
+	intel_pt_log("Emulated ptwrite signature not found\n");
+	return false;
+}
+
 static int intel_pt_walk_next_insn(struct intel_pt_insn *intel_pt_insn,
 				   uint64_t *insn_cnt_ptr, uint64_t *ip,
 				   uint64_t to_ip, uint64_t max_insn_cnt,
@@ -740,6 +764,7 @@ static int intel_pt_walk_next_insn(struct intel_pt_insn *intel_pt_insn,
 				*ip += e->byte_cnt;
 				intel_pt_insn->op = e->op;
 				intel_pt_insn->branch = e->branch;
+				intel_pt_insn->emulated_ptwrite = e->emulated_ptwrite;
 				intel_pt_insn->length = e->length;
 				intel_pt_insn->rel = e->rel;
 				memcpy(intel_pt_insn->buf, e->insn,
@@ -771,8 +796,18 @@ static int intel_pt_walk_next_insn(struct intel_pt_insn *intel_pt_insn,
 
 			insn_cnt += 1;
 
-			if (intel_pt_insn->branch != INTEL_PT_BR_NO_BRANCH)
+			if (intel_pt_insn->branch != INTEL_PT_BR_NO_BRANCH) {
+				bool eptw;
+				u64 offs;
+
+				if (!intel_pt_jmp_16(intel_pt_insn))
+					goto out;
+				/* Check for emulated ptwrite */
+				offs = offset + intel_pt_insn->length;
+				eptw = intel_pt_emulated_ptwrite(al.map->dso, machine, offs);
+				intel_pt_insn->emulated_ptwrite = eptw;
 				goto out;
+			}
 
 			if (max_insn_cnt && insn_cnt >= max_insn_cnt)
 				goto out_no_cache;
@@ -3907,6 +3942,12 @@ int intel_pt_process_auxtrace_info(union perf_event *event,
 
 	intel_pt_setup_pebs_events(pt);
 
+	if (perf_data__is_pipe(session->data)) {
+		pr_warning("WARNING: Intel PT with pipe mode is not recommended.\n"
+			   "         The output cannot relied upon.  In particular,\n"
+			   "         timestamps and the order of events may be incorrect.\n");
+	}
+
 	if (pt->sampling_mode || list_empty(&session->auxtrace_index))
 		err = auxtrace_queue_data(session, true, true);
 	else
diff --git a/tools/perf/util/llvm-utils.c b/tools/perf/util/llvm-utils.c
index 96c8ef60f4f8..8ee3a947b159 100644
--- a/tools/perf/util/llvm-utils.c
+++ b/tools/perf/util/llvm-utils.c
@@ -531,14 +531,37 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
 
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
diff --git a/tools/power/x86/intel-speed-select/isst-config.c b/tools/power/x86/intel-speed-select/isst-config.c
index bf9fd3549a1d..cd08ffe0d62b 100644
--- a/tools/power/x86/intel-speed-select/isst-config.c
+++ b/tools/power/x86/intel-speed-select/isst-config.c
@@ -108,7 +108,7 @@ int is_skx_based_platform(void)
 
 int is_spr_platform(void)
 {
-	if (cpu_model == 0x8F)
+	if (cpu_model == 0x8F || cpu_model == 0xCF)
 		return 1;
 
 	return 0;
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 1737c59e4ff6..e6c381498e63 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -178,6 +178,7 @@ my $store_failures;
 my $store_successes;
 my $test_name;
 my $timeout;
+my $run_timeout;
 my $connect_timeout;
 my $config_bisect_exec;
 my $booted_timeout;
@@ -340,6 +341,7 @@ my %option_map = (
     "STORE_SUCCESSES"		=> \$store_successes,
     "TEST_NAME"			=> \$test_name,
     "TIMEOUT"			=> \$timeout,
+    "RUN_TIMEOUT"		=> \$run_timeout,
     "CONNECT_TIMEOUT"		=> \$connect_timeout,
     "CONFIG_BISECT_EXEC"	=> \$config_bisect_exec,
     "BOOTED_TIMEOUT"		=> \$booted_timeout,
@@ -1488,7 +1490,8 @@ sub reboot {
 
 	# Still need to wait for the reboot to finish
 	wait_for_monitor($time, $reboot_success_line);
-
+    }
+    if ($powercycle || $time) {
 	end_monitor;
     }
 }
@@ -1850,6 +1853,14 @@ sub run_command {
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
 
@@ -1876,13 +1887,10 @@ sub run_command {
 
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
@@ -2054,6 +2062,11 @@ sub wait_for_input {
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
@@ -4193,6 +4206,9 @@ sub send_email {
 }
 
 sub cancel_test {
+    if ($monitor_cnt) {
+	end_monitor;
+    }
     if ($email_when_canceled) {
 	my $name = get_test_name;
 	send_email("KTEST: Your [$name] test was cancelled",
diff --git a/tools/testing/ktest/sample.conf b/tools/testing/ktest/sample.conf
index 5e7d1d729752..65957a9803b5 100644
--- a/tools/testing/ktest/sample.conf
+++ b/tools/testing/ktest/sample.conf
@@ -809,6 +809,11 @@
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
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 638966ae8ad9..0d845a0c8599 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -144,8 +144,6 @@ endif
 # NOTE: Semicolon at the end is critical to override lib.mk's default static
 # rule for binaries.
 $(notdir $(TEST_GEN_PROGS)						\
-	 $(TEST_PROGS)							\
-	 $(TEST_PROGS_EXTENDED)						\
 	 $(TEST_GEN_PROGS_EXTENDED)					\
 	 $(TEST_CUSTOM_PROGS)): %: $(OUTPUT)/% ;
 
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index a08c02abde12..7f7d20f22207 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -17,6 +17,18 @@ SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV_NAME/net/
 DEBUGFS_DIR=/sys/kernel/debug/netdevsim/$DEV_NAME/
 DL_HANDLE=netdevsim/$DEV_NAME
 
+wait_for_devlink()
+{
+	"$@" | grep -q $DL_HANDLE
+}
+
+devlink_wait()
+{
+	local timeout=$1
+
+	busywait "$timeout" wait_for_devlink devlink dev
+}
+
 fw_flash_test()
 {
 	RET=0
@@ -256,6 +268,9 @@ netns_reload_test()
 	ip netns del testns2
 	ip netns del testns1
 
+	# Wait until netns async cleanup is done.
+	devlink_wait 2000
+
 	log_test "netns reload test"
 }
 
@@ -348,6 +363,9 @@ resource_test()
 	ip netns del testns2
 	ip netns del testns1
 
+	# Wait until netns async cleanup is done.
+	devlink_wait 2000
+
 	log_test "resource test"
 }
 
diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc
index 27a68bbe778b..d9b812795077 100644
--- a/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc
@@ -42,7 +42,7 @@ test_event_enabled() {
 
     while [ $check_times -ne 0 ]; do
 	e=`cat $EVENT_ENABLE`
-	if [ "$e" == $val ]; then
+	if [ "$e" = $val ]; then
 	    return 0
 	fi
 	sleep $SLEEP_TIME
diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
index a4fdcda62bde..ea988b3d6b2e 100644
--- a/tools/testing/selftests/landlock/fs_test.c
+++ b/tools/testing/selftests/landlock/fs_test.c
@@ -11,6 +11,7 @@
 #include <fcntl.h>
 #include <linux/landlock.h>
 #include <sched.h>
+#include <stdio.h>
 #include <string.h>
 #include <sys/capability.h>
 #include <sys/mount.h>
@@ -87,6 +88,40 @@ static const char dir_s3d3[] = TMP_DIR "/s3d1/s3d2/s3d3";
  *         └── s3d3
  */
 
+static bool fgrep(FILE *const inf, const char *const str)
+{
+	char line[32];
+	const int slen = strlen(str);
+
+	while (!feof(inf)) {
+		if (!fgets(line, sizeof(line), inf))
+			break;
+		if (strncmp(line, str, slen))
+			continue;
+
+		return true;
+	}
+
+	return false;
+}
+
+static bool supports_overlayfs(void)
+{
+	bool res;
+	FILE *const inf = fopen("/proc/filesystems", "r");
+
+	/*
+	 * Consider that the filesystem is supported if we cannot get the
+	 * supported ones.
+	 */
+	if (!inf)
+		return true;
+
+	res = fgrep(inf, "nodev\toverlay\n");
+	fclose(inf);
+	return res;
+}
+
 static void mkdir_parents(struct __test_metadata *const _metadata,
 			  const char *const path)
 {
@@ -2650,6 +2685,9 @@ FIXTURE(layout2_overlay) {};
 
 FIXTURE_SETUP(layout2_overlay)
 {
+	if (!supports_overlayfs())
+		SKIP(return, "overlayfs is not supported");
+
 	prepare_layout(_metadata);
 
 	create_directory(_metadata, LOWER_BASE);
@@ -2686,6 +2724,9 @@ FIXTURE_SETUP(layout2_overlay)
 
 FIXTURE_TEARDOWN(layout2_overlay)
 {
+	if (!supports_overlayfs())
+		SKIP(return, "overlayfs is not supported");
+
 	EXPECT_EQ(0, remove_path(lower_do1_fl3));
 	EXPECT_EQ(0, remove_path(lower_dl1_fl2));
 	EXPECT_EQ(0, remove_path(lower_fl1));
@@ -2717,6 +2758,9 @@ FIXTURE_TEARDOWN(layout2_overlay)
 
 TEST_F_FORK(layout2_overlay, no_restriction)
 {
+	if (!supports_overlayfs())
+		SKIP(return, "overlayfs is not supported");
+
 	ASSERT_EQ(0, test_open(lower_fl1, O_RDONLY));
 	ASSERT_EQ(0, test_open(lower_dl1, O_RDONLY));
 	ASSERT_EQ(0, test_open(lower_dl1_fl2, O_RDONLY));
@@ -2880,6 +2924,9 @@ TEST_F_FORK(layout2_overlay, same_content_different_file)
 	size_t i;
 	const char *path_entry;
 
+	if (!supports_overlayfs())
+		SKIP(return, "overlayfs is not supported");
+
 	/* Sets rules on base directories (i.e. outside overlay scope). */
 	ruleset_fd = create_ruleset(_metadata, ACCESS_RW, layer1_base);
 	ASSERT_LE(0, ruleset_fd);
diff --git a/tools/testing/selftests/landlock/ptrace_test.c b/tools/testing/selftests/landlock/ptrace_test.c
index c28ef98ff3ac..55e7871631a1 100644
--- a/tools/testing/selftests/landlock/ptrace_test.c
+++ b/tools/testing/selftests/landlock/ptrace_test.c
@@ -19,6 +19,12 @@
 
 #include "common.h"
 
+/* Copied from security/yama/yama_lsm.c */
+#define YAMA_SCOPE_DISABLED 0
+#define YAMA_SCOPE_RELATIONAL 1
+#define YAMA_SCOPE_CAPABILITY 2
+#define YAMA_SCOPE_NO_ATTACH 3
+
 static void create_domain(struct __test_metadata *const _metadata)
 {
 	int ruleset_fd;
@@ -60,6 +66,25 @@ static int test_ptrace_read(const pid_t pid)
 	return 0;
 }
 
+static int get_yama_ptrace_scope(void)
+{
+	int ret;
+	char buf[2] = {};
+	const int fd = open("/proc/sys/kernel/yama/ptrace_scope", O_RDONLY);
+
+	if (fd < 0)
+		return 0;
+
+	if (read(fd, buf, 1) < 0) {
+		close(fd);
+		return -1;
+	}
+
+	ret = atoi(buf);
+	close(fd);
+	return ret;
+}
+
 /* clang-format off */
 FIXTURE(hierarchy) {};
 /* clang-format on */
@@ -232,8 +257,51 @@ TEST_F(hierarchy, trace)
 	pid_t child, parent;
 	int status, err_proc_read;
 	int pipe_child[2], pipe_parent[2];
+	int yama_ptrace_scope;
 	char buf_parent;
 	long ret;
+	bool can_read_child, can_trace_child, can_read_parent, can_trace_parent;
+
+	yama_ptrace_scope = get_yama_ptrace_scope();
+	ASSERT_LE(0, yama_ptrace_scope);
+
+	if (yama_ptrace_scope > YAMA_SCOPE_DISABLED)
+		TH_LOG("Incomplete tests due to Yama restrictions (scope %d)",
+		       yama_ptrace_scope);
+
+	/*
+	 * can_read_child is true if a parent process can read its child
+	 * process, which is only the case when the parent process is not
+	 * isolated from the child with a dedicated Landlock domain.
+	 */
+	can_read_child = !variant->domain_parent;
+
+	/*
+	 * can_trace_child is true if a parent process can trace its child
+	 * process.  This depends on two conditions:
+	 * - The parent process is not isolated from the child with a dedicated
+	 *   Landlock domain.
+	 * - Yama allows tracing children (up to YAMA_SCOPE_RELATIONAL).
+	 */
+	can_trace_child = can_read_child &&
+			  yama_ptrace_scope <= YAMA_SCOPE_RELATIONAL;
+
+	/*
+	 * can_read_parent is true if a child process can read its parent
+	 * process, which is only the case when the child process is not
+	 * isolated from the parent with a dedicated Landlock domain.
+	 */
+	can_read_parent = !variant->domain_child;
+
+	/*
+	 * can_trace_parent is true if a child process can trace its parent
+	 * process.  This depends on two conditions:
+	 * - The child process is not isolated from the parent with a dedicated
+	 *   Landlock domain.
+	 * - Yama is disabled (YAMA_SCOPE_DISABLED).
+	 */
+	can_trace_parent = can_read_parent &&
+			   yama_ptrace_scope <= YAMA_SCOPE_DISABLED;
 
 	/*
 	 * Removes all effective and permitted capabilities to not interfere
@@ -264,16 +332,21 @@ TEST_F(hierarchy, trace)
 		/* Waits for the parent to be in a domain, if any. */
 		ASSERT_EQ(1, read(pipe_parent[0], &buf_child, 1));
 
-		/* Tests PTRACE_ATTACH and PTRACE_MODE_READ on the parent. */
+		/* Tests PTRACE_MODE_READ on the parent. */
 		err_proc_read = test_ptrace_read(parent);
+		if (can_read_parent) {
+			EXPECT_EQ(0, err_proc_read);
+		} else {
+			EXPECT_EQ(EACCES, err_proc_read);
+		}
+
+		/* Tests PTRACE_ATTACH on the parent. */
 		ret = ptrace(PTRACE_ATTACH, parent, NULL, 0);
-		if (variant->domain_child) {
+		if (can_trace_parent) {
+			EXPECT_EQ(0, ret);
+		} else {
 			EXPECT_EQ(-1, ret);
 			EXPECT_EQ(EPERM, errno);
-			EXPECT_EQ(EACCES, err_proc_read);
-		} else {
-			EXPECT_EQ(0, ret);
-			EXPECT_EQ(0, err_proc_read);
 		}
 		if (ret == 0) {
 			ASSERT_EQ(parent, waitpid(parent, &status, 0));
@@ -283,11 +356,11 @@ TEST_F(hierarchy, trace)
 
 		/* Tests child PTRACE_TRACEME. */
 		ret = ptrace(PTRACE_TRACEME);
-		if (variant->domain_parent) {
+		if (can_trace_child) {
+			EXPECT_EQ(0, ret);
+		} else {
 			EXPECT_EQ(-1, ret);
 			EXPECT_EQ(EPERM, errno);
-		} else {
-			EXPECT_EQ(0, ret);
 		}
 
 		/*
@@ -296,7 +369,7 @@ TEST_F(hierarchy, trace)
 		 */
 		ASSERT_EQ(1, write(pipe_child[1], ".", 1));
 
-		if (!variant->domain_parent) {
+		if (can_trace_child) {
 			ASSERT_EQ(0, raise(SIGSTOP));
 		}
 
@@ -321,7 +394,7 @@ TEST_F(hierarchy, trace)
 	ASSERT_EQ(1, read(pipe_child[0], &buf_parent, 1));
 
 	/* Tests child PTRACE_TRACEME. */
-	if (!variant->domain_parent) {
+	if (can_trace_child) {
 		ASSERT_EQ(child, waitpid(child, &status, 0));
 		ASSERT_EQ(1, WIFSTOPPED(status));
 		ASSERT_EQ(0, ptrace(PTRACE_DETACH, child, NULL, 0));
@@ -331,17 +404,23 @@ TEST_F(hierarchy, trace)
 		EXPECT_EQ(ESRCH, errno);
 	}
 
-	/* Tests PTRACE_ATTACH and PTRACE_MODE_READ on the child. */
+	/* Tests PTRACE_MODE_READ on the child. */
 	err_proc_read = test_ptrace_read(child);
+	if (can_read_child) {
+		EXPECT_EQ(0, err_proc_read);
+	} else {
+		EXPECT_EQ(EACCES, err_proc_read);
+	}
+
+	/* Tests PTRACE_ATTACH on the child. */
 	ret = ptrace(PTRACE_ATTACH, child, NULL, 0);
-	if (variant->domain_parent) {
+	if (can_trace_child) {
+		EXPECT_EQ(0, ret);
+	} else {
 		EXPECT_EQ(-1, ret);
 		EXPECT_EQ(EPERM, errno);
-		EXPECT_EQ(EACCES, err_proc_read);
-	} else {
-		EXPECT_EQ(0, ret);
-		EXPECT_EQ(0, err_proc_read);
 	}
+
 	if (ret == 0) {
 		ASSERT_EQ(child, waitpid(child, &status, 0));
 		ASSERT_EQ(1, WIFSTOPPED(status));
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 7df066bf74b8..c64b0b121762 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1921,6 +1921,8 @@ EOF
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
index 0be80c213f7f..5ef88f5a0864 100644
--- a/virt/kvm/coalesced_mmio.c
+++ b/virt/kvm/coalesced_mmio.c
@@ -187,15 +187,17 @@ int kvm_vm_ioctl_unregister_coalesced_mmio(struct kvm *kvm,
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
 
