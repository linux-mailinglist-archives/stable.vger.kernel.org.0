Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113F76B5D81
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 16:51:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjCKPvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 10:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbjCKPvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 10:51:09 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB06ED69E;
        Sat, 11 Mar 2023 07:50:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AC816CE226E;
        Sat, 11 Mar 2023 15:50:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC91C433A4;
        Sat, 11 Mar 2023 15:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678549805;
        bh=+swjmcyC3H5U0Rr1MIP/4GrEg66DdiKqhC7CB8mZomA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cAl7GD0S+6i/SAEYAtAIoYrwGoX2wy8Y3mLuKRMQhZih8Fxwli8tIBCkWM5XH0wlj
         U1x52nvANHh5zqNrPidavJJF49Ci3tZQ+NsPKpmK+6XqmDgJnOr6zw0ttQsCqqGuBt
         WwRJ0ekhK5Xej8XCCKxuYrCe+RrHWz+QajDLLgWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.173
Date:   Sat, 11 Mar 2023 16:49:49 +0100
Message-Id: <167854978912613@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <1678549789147210@kroah.com>
References: <1678549789147210@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Documentation/ABI/testing/configfs-usb-gadget-uvc b/Documentation/ABI/testing/configfs-usb-gadget-uvc
index ac5e11af79a8..4b1813994bd0 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-uvc
+++ b/Documentation/ABI/testing/configfs-usb-gadget-uvc
@@ -51,7 +51,7 @@ Date:		Dec 2014
 KernelVersion:	4.0
 Description:	Default output terminal descriptors
 
-		All attributes read only:
+		All attributes read only except bSourceID:
 
 		==============	=============================================
 		iTerminal	index of string descriptor
diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation/admin-guide/cgroup-v1/memory.rst
index 12757e63b26c..7882037aca67 100644
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
@@ -740,8 +742,15 @@ NOTE2:
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
index 4756f6b3a04e..10cdd990b63d 100644
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
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 2b4b64797191..08295f488d05 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -4031,6 +4031,18 @@ not holding a previously reported uncorrected error).
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
 
@@ -4111,12 +4123,6 @@ mask is unused.
 
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
index 447ed158d6bc..1a6ea7994079 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 172
+SUBLEVEL = 173
 EXTRAVERSION =
 NAME = Dare mighty things
 
@@ -93,9 +93,16 @@ endif
 
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
index 8b0f81a58b94..751d3197ca76 100644
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
index f9e3b13d3aac..bbf01f76ce3b 100644
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
index a1e54449f33f..41f0e64b1365 100644
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
index fddc661ded28..448e1b153a01 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -382,7 +382,6 @@ &cpu_alert2 {
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
 };
 
 &gic {
diff --git a/arch/arm/boot/dts/exynos5250.dtsi b/arch/arm/boot/dts/exynos5250.dtsi
index bd2d8835dd36..62051e600b32 100644
--- a/arch/arm/boot/dts/exynos5250.dtsi
+++ b/arch/arm/boot/dts/exynos5250.dtsi
@@ -1109,7 +1109,7 @@ timer {
 &cpu_thermal {
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
-	thermal-sensors = <&tmu 0>;
+	thermal-sensors = <&tmu>;
 
 	cooling-maps {
 		map0 {
diff --git a/arch/arm/boot/dts/exynos5410-odroidxu.dts b/arch/arm/boot/dts/exynos5410-odroidxu.dts
index bd1d8499a108..147c077e8855 100644
--- a/arch/arm/boot/dts/exynos5410-odroidxu.dts
+++ b/arch/arm/boot/dts/exynos5410-odroidxu.dts
@@ -116,7 +116,6 @@ &clock_audss {
 };
 
 &cpu0_thermal {
-	thermal-sensors = <&tmu_cpu0 0>;
 	polling-delay-passive = <0>;
 	polling-delay = <0>;
 
diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
index 83580f076a58..34886535f847 100644
--- a/arch/arm/boot/dts/exynos5420.dtsi
+++ b/arch/arm/boot/dts/exynos5420.dtsi
@@ -605,7 +605,7 @@ dp_phy: dp-video-phy {
 		};
 
 		mipi_phy: mipi-video-phy {
-			compatible = "samsung,s5pv210-mipi-video-phy";
+			compatible = "samsung,exynos5420-mipi-video-phy";
 			syscon = <&pmu_system_controller>;
 			#phy-cells = <1>;
 		};
diff --git a/arch/arm/boot/dts/exynos5422-odroidhc1.dts b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
index 88f5c150a30a..a1871d4a0f2a 100644
--- a/arch/arm/boot/dts/exynos5422-odroidhc1.dts
+++ b/arch/arm/boot/dts/exynos5422-odroidhc1.dts
@@ -29,7 +29,7 @@ blueled {
 
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
index 5da2d81e3be2..099ed4384be8 100644
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
index 9e1b0af0aa43..43b39ad9ddce 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
@@ -494,7 +494,7 @@ gpr: iomuxc-gpr@30340000 {
 
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
@@ -242,7 +242,7 @@ stmpe811@41 {
 					irq-trigger = <0x1>;
 
 					stmpegpio: stmpe-gpio {
-						compatible = "stmpe,gpio";
+						compatible = "st,stmpe-gpio";
 						reg = <0>;
 						gpio-controller;
 						#gpio-cells = <2>;
diff --git a/arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts b/arch/arm/boot/dts/sun8i-h3-nanopi-duo2.dts
index 6b149271ef13..8722fdf77ebc 100644
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
index 97fc2096b970..05f016d5e9f6 100644
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
index 5c75fbf0d470..c892b252e5b0 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -151,7 +151,7 @@ scpi {
 		scpi_clocks: clocks {
 			compatible = "arm,scpi-clocks";
 
-			scpi_dvfs: clock-controller {
+			scpi_dvfs: clocks-0 {
 				compatible = "arm,scpi-dvfs-clocks";
 				#clock-cells = <1>;
 				clock-indices = <0>;
@@ -160,7 +160,7 @@ scpi_dvfs: clock-controller {
 		};
 
 		scpi_sensors: sensors {
-			compatible = "amlogic,meson-gxbb-scpi-sensors";
+			compatible = "amlogic,meson-gxbb-scpi-sensors", "arm,scpi-sensors";
 			#thermal-sensor-cells = <1>;
 		};
 	};
diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 2091db7c9b8a..c0defb36592d 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -1727,7 +1727,7 @@ int_mdio: mdio@1 {
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
index c2480bab8d33..27e964bfa947 100644
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
index 88a7db5c55a0..4c7131526c4d 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-gx.dtsi
@@ -226,7 +226,7 @@ sn: sn@14 {
 			reg = <0x14 0x10>;
 		};
 
-		eth_mac: eth_mac@34 {
+		eth_mac: eth-mac@34 {
 			reg = <0x34 0x10>;
 		};
 
@@ -243,7 +243,7 @@ scpi {
 		scpi_clocks: clocks {
 			compatible = "arm,scpi-clocks";
 
-			scpi_dvfs: scpi_clocks@0 {
+			scpi_dvfs: clocks-0 {
 				compatible = "arm,scpi-dvfs-clocks";
 				#clock-cells = <1>;
 				clock-indices = <0>;
@@ -524,7 +524,7 @@ periphs: bus@c8834000 {
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
index 0b95e9ecbef0..ca3fd6b67b94 100644
--- a/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-gxl-s905d-sml5442tw.dts
@@ -75,6 +75,5 @@ bluetooth {
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
diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index 7c6d871538a6..884930a5849a 100644
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
index 08a914d3a643..31bc8bae8cff 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -205,6 +205,15 @@ psci {
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
@@ -355,8 +364,7 @@ systimer: timer@10017000 {
 				     "mediatek,mt6765-timer";
 			reg = <0 0x10017000 0 0x1000>;
 			interrupts = <GIC_SPI 200 IRQ_TYPE_LEVEL_HIGH>;
-			clocks = <&topckgen CLK_TOP_CLK13M>;
-			clock-names = "clk13m";
+			clocks = <&clk13m>;
 		};
 
 		gce: mailbox@10238000 {
diff --git a/arch/arm64/boot/dts/qcom/ipq8074.dtsi b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
index 99e2488b92dc..e191a7bc532b 100644
--- a/arch/arm64/boot/dts/qcom/ipq8074.dtsi
+++ b/arch/arm64/boot/dts/qcom/ipq8074.dtsi
@@ -108,7 +108,7 @@ usb1_ssphy: lane@58200 {
 				#phy-cells = <0>;
 				clocks = <&gcc GCC_USB1_PIPE_CLK>;
 				clock-names = "pipe0";
-				clock-output-names = "gcc_usb1_pipe_clk_src";
+				clock-output-names = "usb3phy_1_cc_pipe_clk";
 			};
 		};
 
@@ -151,7 +151,7 @@ usb0_ssphy: lane@78200 {
 				#phy-cells = <0>;
 				clocks = <&gcc GCC_USB0_PIPE_CLK>;
 				clock-names = "pipe0";
-				clock-output-names = "gcc_usb0_pipe_clk_src";
+				clock-output-names = "usb3phy_0_cc_pipe_clk";
 			};
 		};
 
@@ -167,34 +167,61 @@ qusb_phy_0: phy@79000 {
 			resets = <&gcc GCC_QUSB2_0_PHY_BCR>;
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
 
 		tlmm: pinctrl@1000000 {
@@ -583,9 +610,9 @@ pcie1: pci@10000000 {
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
@@ -628,16 +655,18 @@ IRQ_TYPE_LEVEL_HIGH>, /* int_c */
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
 
@@ -645,9 +674,9 @@ pcie0: pci@20000000 {
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
@@ -665,28 +694,30 @@ IRQ_TYPE_LEVEL_HIGH>, /* int_c */
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
diff --git a/arch/arm64/boot/dts/qcom/qcs404.dtsi b/arch/arm64/boot/dts/qcom/qcs404.dtsi
index 7bddc5ebc6aa..d41f068dde16 100644
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
index c71f3afc1cc9..eb07a882d43b 100644
--- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
@@ -3066,8 +3066,8 @@ spmi_bus: spmi@c440000 {
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
diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index c6691bdc8100..1e889ca932e4 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -896,7 +896,7 @@ sdc2_card_det_n: sd-card-det-n {
 	};
 
 	wcd_intr_default: wcd_intr_default {
-		pins = <54>;
+		pins = "gpio54";
 		function = "gpio";
 
 		input-enable;
diff --git a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
index 53e1d43cbecf..663adf79471b 100644
--- a/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
+++ b/arch/arm64/boot/dts/renesas/beacon-renesom-baseboard.dtsi
@@ -399,20 +399,6 @@ wm8962_endpoint: endpoint {
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
@@ -445,6 +431,16 @@ hd3ss3220_ep: endpoint {
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
index e8a4143e1c24..909ab6661aef 100644
--- a/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
+++ b/arch/arm64/boot/dts/ti/k3-j7200-common-proc-board.dts
@@ -16,7 +16,7 @@ chosen {
 	};
 };
 
-&wkup_pmx0 {
+&wkup_pmx2 {
 	mcu_cpsw_pins_default: mcu-cpsw-pins-default {
 		pinctrl-single,pins = <
 			J721E_WKUP_IOPAD(0x0068, PIN_OUTPUT, 0) /* MCU_RGMII1_TX_CTL */
diff --git a/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi b/arch/arm64/boot/dts/ti/k3-j7200-mcu-wakeup.dtsi
index eb2a78a53512..7f252cc6eb37 100644
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
index d43a02795a4a..f1d41a9328a2 100644
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
index 9dd76fbb7c6b..546bab6bfc27 100644
--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -167,9 +167,12 @@ do_trace_entry:
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
index 612254141296..a3f66ade09b3 100644
--- a/arch/powerpc/Makefile
+++ b/arch/powerpc/Makefile
@@ -92,7 +92,7 @@ aflags-$(CONFIG_CPU_LITTLE_ENDIAN)	+= -mlittle-endian
 
 ifeq ($(HAS_BIARCH),y)
 KBUILD_CFLAGS	+= -m$(BITS)
-KBUILD_AFLAGS	+= -m$(BITS) -Wl,-a$(BITS)
+KBUILD_AFLAGS	+= -m$(BITS)
 KBUILD_LDFLAGS	+= -m elf$(BITS)$(LDEMULATION)
 endif
 
diff --git a/arch/powerpc/kernel/eeh_driver.c b/arch/powerpc/kernel/eeh_driver.c
index 3eff6a4888e7..665d847ef9b5 100644
--- a/arch/powerpc/kernel/eeh_driver.c
+++ b/arch/powerpc/kernel/eeh_driver.c
@@ -1054,45 +1054,46 @@ void eeh_handle_normal_event(struct eeh_pe *pe)
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
@@ -1188,10 +1189,10 @@ void eeh_handle_special_event(void)
 
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
index 014229c40435..c2e407a112a2 100644
--- a/arch/powerpc/kernel/rtas.c
+++ b/arch/powerpc/kernel/rtas.c
@@ -52,10 +52,10 @@ struct rtas_t rtas = {
 EXPORT_SYMBOL(rtas);
 
 DEFINE_SPINLOCK(rtas_data_buf_lock);
-EXPORT_SYMBOL(rtas_data_buf_lock);
+EXPORT_SYMBOL_GPL(rtas_data_buf_lock);
 
-char rtas_data_buf[RTAS_DATA_BUF_SIZE] __cacheline_aligned;
-EXPORT_SYMBOL(rtas_data_buf);
+char rtas_data_buf[RTAS_DATA_BUF_SIZE] __aligned(SZ_4K);
+EXPORT_SYMBOL_GPL(rtas_data_buf);
 
 unsigned long rtas_rmo_buf;
 
@@ -64,7 +64,7 @@ unsigned long rtas_rmo_buf;
  * This is done like this so rtas_flash can be a module.
  */
 void (*rtas_flash_term_hook)(int);
-EXPORT_SYMBOL(rtas_flash_term_hook);
+EXPORT_SYMBOL_GPL(rtas_flash_term_hook);
 
 /* RTAS use home made raw locking instead of spin_lock_irqsave
  * because those can be called from within really nasty contexts
@@ -312,7 +312,7 @@ void rtas_progress(char *s, unsigned short hex)
  
 	spin_unlock(&progress_lock);
 }
-EXPORT_SYMBOL(rtas_progress);		/* needed by rtas_flash module */
+EXPORT_SYMBOL_GPL(rtas_progress);		/* needed by rtas_flash module */
 
 int rtas_token(const char *service)
 {
@@ -322,7 +322,7 @@ int rtas_token(const char *service)
 	tokp = of_get_property(rtas.dev, service, NULL);
 	return tokp ? be32_to_cpu(*tokp) : RTAS_UNKNOWN_SERVICE;
 }
-EXPORT_SYMBOL(rtas_token);
+EXPORT_SYMBOL_GPL(rtas_token);
 
 int rtas_service_present(const char *service)
 {
@@ -482,7 +482,7 @@ int rtas_call(int token, int nargs, int nret, int *outputs, ...)
 	}
 	return ret;
 }
-EXPORT_SYMBOL(rtas_call);
+EXPORT_SYMBOL_GPL(rtas_call);
 
 /* For RTAS_BUSY (-2), delay for 1 millisecond.  For an extended busy status
  * code of 990n, perform the hinted delay of 10^n (last digit) milliseconds.
@@ -517,7 +517,7 @@ unsigned int rtas_busy_delay(int status)
 
 	return ms;
 }
-EXPORT_SYMBOL(rtas_busy_delay);
+EXPORT_SYMBOL_GPL(rtas_busy_delay);
 
 static int rtas_error_rc(int rtas_rc)
 {
@@ -563,7 +563,7 @@ int rtas_get_power_level(int powerdomain, int *level)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_get_power_level);
+EXPORT_SYMBOL_GPL(rtas_get_power_level);
 
 int rtas_set_power_level(int powerdomain, int level, int *setlevel)
 {
@@ -581,7 +581,7 @@ int rtas_set_power_level(int powerdomain, int level, int *setlevel)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_set_power_level);
+EXPORT_SYMBOL_GPL(rtas_set_power_level);
 
 int rtas_get_sensor(int sensor, int index, int *state)
 {
@@ -599,7 +599,7 @@ int rtas_get_sensor(int sensor, int index, int *state)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_get_sensor);
+EXPORT_SYMBOL_GPL(rtas_get_sensor);
 
 int rtas_get_sensor_fast(int sensor, int index, int *state)
 {
@@ -660,7 +660,7 @@ int rtas_set_indicator(int indicator, int index, int new_value)
 		return rtas_error_rc(rc);
 	return rc;
 }
-EXPORT_SYMBOL(rtas_set_indicator);
+EXPORT_SYMBOL_GPL(rtas_set_indicator);
 
 /*
  * Ignoring RTAS extended delay
diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
index 4c2f75916a7e..abbfd5cc40c9 100644
--- a/arch/powerpc/mm/book3s64/radix_tlb.c
+++ b/arch/powerpc/mm/book3s64/radix_tlb.c
@@ -941,15 +941,12 @@ static inline void __radix__flush_tlb_range(struct mm_struct *mm,
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
 
 		if (local) {
 			asm volatile("ptesync": : :"memory");
diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 6e7e820508df..1cd2351d241e 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -79,9 +79,8 @@ static u32 phys_coresperchip; /* Physical cores per chip */
  */
 void read_24x7_sys_info(void)
 {
-	int call_status, len, ntypes;
-
-	spin_lock(&rtas_data_buf_lock);
+	const s32 token = rtas_token("ibm,get-system-parameter");
+	int call_status;
 
 	/*
 	 * Making system parameter: chips and sockets and cores per chip
@@ -91,32 +90,27 @@ void read_24x7_sys_info(void)
 	phys_chipspersocket = 1;
 	phys_coresperchip = 1;
 
-	call_status = rtas_call(rtas_token("ibm,get-system-parameter"), 3, 1,
-				NULL,
-				PROCESSOR_MODULE_INFO,
-				__pa(rtas_data_buf),
-				RTAS_DATA_BUF_SIZE);
+	do {
+		spin_lock(&rtas_data_buf_lock);
+		call_status = rtas_call(token, 3, 1, NULL, PROCESSOR_MODULE_INFO,
+					__pa(rtas_data_buf), RTAS_DATA_BUF_SIZE);
+		if (call_status == 0) {
+			int ntypes = be16_to_cpup((__be16 *)&rtas_data_buf[2]);
+			int len = be16_to_cpup((__be16 *)&rtas_data_buf[0]);
+
+			if (len >= 8 && ntypes != 0) {
+				phys_sockets = be16_to_cpup((__be16 *)&rtas_data_buf[4]);
+				phys_chipspersocket = be16_to_cpup((__be16 *)&rtas_data_buf[6]);
+				phys_coresperchip = be16_to_cpup((__be16 *)&rtas_data_buf[8]);
+			}
+		}
+		spin_unlock(&rtas_data_buf_lock);
+	} while (rtas_busy_delay(call_status));
 
 	if (call_status != 0) {
 		pr_err("Error calling get-system-parameter %d\n",
 		       call_status);
-	} else {
-		len = be16_to_cpup((__be16 *)&rtas_data_buf[0]);
-		if (len < 8)
-			goto out;
-
-		ntypes = be16_to_cpup((__be16 *)&rtas_data_buf[2]);
-
-		if (!ntypes)
-			goto out;
-
-		phys_sockets = be16_to_cpup((__be16 *)&rtas_data_buf[4]);
-		phys_chipspersocket = be16_to_cpup((__be16 *)&rtas_data_buf[6]);
-		phys_coresperchip = be16_to_cpup((__be16 *)&rtas_data_buf[8]);
 	}
-
-out:
-	spin_unlock(&rtas_data_buf_lock);
 }
 
 /* Domains for which more than one result element are returned for each event. */
diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 2b4ceb5e6ce4..a1e6dd47743f 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -2260,7 +2260,8 @@ static void pnv_ioda_setup_pe_res(struct pnv_ioda_pe *pe,
 	int index;
 	int64_t rc;
 
-	if (!res || !res->flags || res->start > res->end)
+	if (!res || !res->flags || res->start > res->end ||
+	    res->flags & IORESOURCE_UNSET)
 		return;
 
 	if (res->flags & IORESOURCE_IO) {
diff --git a/arch/powerpc/platforms/pseries/lpar.c b/arch/powerpc/platforms/pseries/lpar.c
index 1c3ac0f66336..115d196560b8 100644
--- a/arch/powerpc/platforms/pseries/lpar.c
+++ b/arch/powerpc/platforms/pseries/lpar.c
@@ -1433,22 +1433,22 @@ static inline void __init check_lp_set_hblkrm(unsigned int lp,
 
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
index e278390ab28d..d3517e498512 100644
--- a/arch/powerpc/platforms/pseries/lparcfg.c
+++ b/arch/powerpc/platforms/pseries/lparcfg.c
@@ -322,6 +322,7 @@ static void parse_mpp_x_data(struct seq_file *m)
  */
 static void parse_system_parameter_string(struct seq_file *m)
 {
+	const s32 token = rtas_token("ibm,get-system-parameter");
 	int call_status;
 
 	unsigned char *local_buffer = kmalloc(SPLPAR_MAXLENGTH, GFP_KERNEL);
@@ -331,16 +332,15 @@ static void parse_system_parameter_string(struct seq_file *m)
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
diff --git a/arch/riscv/include/asm/parse_asm.h b/arch/riscv/include/asm/parse_asm.h
index f36368de839f..7fee806805c1 100644
--- a/arch/riscv/include/asm/parse_asm.h
+++ b/arch/riscv/include/asm/parse_asm.h
@@ -125,7 +125,7 @@
 #define FUNCT3_C_J		0xa000
 #define FUNCT3_C_JAL		0x2000
 #define FUNCT4_C_JR		0x8000
-#define FUNCT4_C_JALR		0xf000
+#define FUNCT4_C_JALR		0x9000
 
 #define FUNCT12_SRET		0x10200000
 
diff --git a/arch/riscv/kernel/time.c b/arch/riscv/kernel/time.c
index 8a5cf99c0776..303ae47dfb4d 100644
--- a/arch/riscv/kernel/time.c
+++ b/arch/riscv/kernel/time.c
@@ -5,6 +5,7 @@
  */
 
 #include <linux/of_clk.h>
+#include <linux/clockchips.h>
 #include <linux/clocksource.h>
 #include <linux/delay.h>
 #include <asm/sbi.h>
@@ -28,6 +29,8 @@ void __init time_init(void)
 
 	of_clk_init(NULL);
 	timer_probe();
+
+	tick_setup_hrtimer_broadcast();
 }
 
 void clocksource_arch_init(struct clocksource *cs)
diff --git a/arch/s390/kernel/kprobes.c b/arch/s390/kernel/kprobes.c
index aae24dc75df6..0f7e7a68d57b 100644
--- a/arch/s390/kernel/kprobes.c
+++ b/arch/s390/kernel/kprobes.c
@@ -241,6 +241,7 @@ static void pop_kprobe(struct kprobe_ctlblk *kcb)
 {
 	__this_cpu_write(current_kprobe, kcb->prev_kprobe.kp);
 	kcb->kprobe_status = kcb->prev_kprobe.status;
+	kcb->prev_kprobe.kp = NULL;
 }
 NOKPROBE_SYMBOL(pop_kprobe);
 
@@ -402,12 +403,11 @@ static int post_kprobe_handler(struct pt_regs *regs)
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
index 9505bdb0aa54..d7291eb0d0c0 100644
--- a/arch/s390/kernel/vmlinux.lds.S
+++ b/arch/s390/kernel/vmlinux.lds.S
@@ -188,5 +188,6 @@ SECTIONS
 	DISCARDS
 	/DISCARD/ : {
 		*(.eh_frame)
+		*(.interp)
 	}
 }
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 59db85fb63e1..7ffc73ba220f 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -5012,6 +5012,23 @@ int kvm_arch_prepare_memory_region(struct kvm *kvm,
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
index b239f2ba93b0..cbfff2460e58 100644
--- a/arch/s390/mm/vmem.c
+++ b/arch/s390/mm/vmem.c
@@ -296,7 +296,7 @@ static void try_free_pmd_table(pud_t *pud, unsigned long start)
 	if (end > VMALLOC_START)
 		return;
 #ifdef CONFIG_KASAN
-	if (start < KASAN_SHADOW_END && KASAN_SHADOW_START > end)
+	if (start < KASAN_SHADOW_END && end > KASAN_SHADOW_START)
 		return;
 #endif
 	pmd = pmd_offset(pud, start);
@@ -371,7 +371,7 @@ static void try_free_pud_table(p4d_t *p4d, unsigned long start)
 	if (end > VMALLOC_START)
 		return;
 #ifdef CONFIG_KASAN
-	if (start < KASAN_SHADOW_END && KASAN_SHADOW_START > end)
+	if (start < KASAN_SHADOW_END && end > KASAN_SHADOW_START)
 		return;
 #endif
 
@@ -425,7 +425,7 @@ static void try_free_p4d_table(pgd_t *pgd, unsigned long start)
 	if (end > VMALLOC_START)
 		return;
 #ifdef CONFIG_KASAN
-	if (start < KASAN_SHADOW_END && KASAN_SHADOW_START > end)
+	if (start < KASAN_SHADOW_END && end > KASAN_SHADOW_START)
 		return;
 #endif
 
diff --git a/arch/sparc/Kconfig b/arch/sparc/Kconfig
index 530b7ec5d3ca..b5ed89342059 100644
--- a/arch/sparc/Kconfig
+++ b/arch/sparc/Kconfig
@@ -293,7 +293,7 @@ config FORCE_MAX_ZONEORDER
 	  This config option is actually maximum order plus one. For example,
 	  a value of 13 means that the largest free memory block is 2^12 pages.
 
-if SPARC64
+if SPARC64 || COMPILE_TEST
 source "kernel/power/Kconfig"
 endif
 
diff --git a/arch/um/drivers/vector_kern.c b/arch/um/drivers/vector_kern.c
index 555203e3e7b4..fc662f7cc2af 100644
--- a/arch/um/drivers/vector_kern.c
+++ b/arch/um/drivers/vector_kern.c
@@ -771,6 +771,7 @@ static int vector_config(char *str, char **error_out)
 
 	if (parsed == NULL) {
 		*error_out = "vector_config failed to parse parameters";
+		kfree(params);
 		return -EINVAL;
 	}
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d64e69013995..2284666e8c90 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1329,17 +1329,16 @@ config MICROCODE_AMD
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
index e68827e604ad..e92734696030 100644
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
index 5a8ee3b83af2..f71a177b6b18 100644
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
index d428d611a43a..60514502ead6 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -682,6 +682,7 @@ extern void load_direct_gdt(int);
 extern void load_fixmap_gdt(int);
 extern void load_percpu_segment(int);
 extern void cpu_init(void);
+extern void cpu_init_secondary(void);
 extern void cpu_init_exception_handling(void);
 extern void cr4_init(void);
 
@@ -838,8 +839,9 @@ bool xen_set_default_idle(void);
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
diff --git a/arch/x86/include/asm/resctrl.h b/arch/x86/include/asm/resctrl.h
index 07603064df8f..b9ccdf5ea98b 100644
--- a/arch/x86/include/asm/resctrl.h
+++ b/arch/x86/include/asm/resctrl.h
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
@@ -78,17 +81,17 @@ static void __resctrl_sched_in(void)
 	}
 }
 
-static inline void resctrl_sched_in(void)
+static inline void resctrl_sched_in(struct task_struct *tsk)
 {
 	if (static_branch_likely(&rdt_enable_key))
-		__resctrl_sched_in();
+		__resctrl_sched_in(tsk);
 }
 
 void resctrl_cpu_detect(struct cpuinfo_x86 *c);
 
 #else
 
-static inline void resctrl_sched_in(void) {}
+static inline void resctrl_sched_in(struct task_struct *tsk) {}
 static inline void resctrl_cpu_detect(struct cpuinfo_x86 *c) {}
 
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
index a2a087a797ae..c81b8b029b68 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -136,9 +136,17 @@ void __init check_bugs(void)
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
@@ -1058,14 +1066,18 @@ spectre_v2_parse_user_cmdline(void)
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
@@ -1128,12 +1140,19 @@ spectre_v2_user_select_mitigation(void)
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
@@ -2227,7 +2246,7 @@ static ssize_t mmio_stale_data_show_state(char *buf)
 
 static char *stibp_state(void)
 {
-	if (spectre_v2_in_ibrs_mode(spectre_v2_enabled))
+	if (spectre_v2_in_eibrs_mode(spectre_v2_enabled))
 		return "";
 
 	switch (spectre_v2_user_stibp) {
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 56573241d029..e2dee6010846 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2048,13 +2048,12 @@ void cpu_init_exception_handling(void)
 
 /*
  * cpu_init() initializes state that is per-CPU. Some data is already
- * initialized (naturally) in the bootstrap process, such as the GDT
- * and IDT. We reload them nevertheless, this function acts as a
- * 'CPU state barrier', nothing should get across.
+ * initialized (naturally) in the bootstrap process, such as the GDT.  We
+ * reload it nevertheless, this function acts as a 'CPU state barrier',
+ * nothing should get across.
  */
 void cpu_init(void)
 {
-	struct tss_struct *tss = this_cpu_ptr(&cpu_tss_rw);
 	struct task_struct *cur = current;
 	int cpu = raw_smp_processor_id();
 
@@ -2067,8 +2066,6 @@ void cpu_init(void)
 	    early_cpu_to_node(cpu) != NUMA_NO_NODE)
 		set_numa_node(early_cpu_to_node(cpu));
 #endif
-	setup_getcpu(cpu);
-
 	pr_debug("Initializing CPU#%d\n", cpu);
 
 	if (IS_ENABLED(CONFIG_X86_64) || cpu_feature_enabled(X86_FEATURE_VME) ||
@@ -2080,7 +2077,6 @@ void cpu_init(void)
 	 * and set up the GDT descriptor:
 	 */
 	switch_to_new_gdt(cpu);
-	load_current_idt();
 
 	if (IS_ENABLED(CONFIG_X86_64)) {
 		loadsegment(fs, 0);
@@ -2100,12 +2096,6 @@ void cpu_init(void)
 	initialize_tlbstate_and_flush();
 	enter_lazy_tlb(&init_mm, cur);
 
-	/* Initialize the TSS. */
-	tss_setup_ist(tss);
-	tss_setup_io_bitmap(tss);
-	set_tss_desc(cpu, &get_cpu_entry_area(cpu)->tss.x86_tss);
-
-	load_TR_desc();
 	/*
 	 * sp0 points to the entry trampoline stack regardless of what task
 	 * is running.
@@ -2127,35 +2117,64 @@ void cpu_init(void)
 	load_fixmap_gdt(cpu);
 }
 
-/*
+#ifdef CONFIG_SMP
+void cpu_init_secondary(void)
+{
+	/*
+	 * Relies on the BP having set-up the IDT tables, which are loaded
+	 * on this CPU in cpu_init_exception_handling().
+	 */
+	cpu_init_exception_handling();
+	cpu_init();
+}
+#endif
+
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
index 234a96f25248..d3bce6d380ed 100644
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
 	u32 rev, dummy __always_unused;
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
index 0b1732b98e71..24254d141178 100644
--- a/arch/x86/kernel/cpu/microcode/core.c
+++ b/arch/x86/kernel/cpu/microcode/core.c
@@ -55,7 +55,7 @@ LIST_HEAD(microcode_cache);
  * All non cpu-hotplug-callback call sites use:
  *
  * - microcode_mutex to synchronize with each other;
- * - get/put_online_cpus() to synchronize with
+ * - cpus_read_lock/unlock() to synchronize with
  *   the cpu-hotplug-callback call sites.
  *
  * We guarantee that only a single cpu is being
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
-	get_online_cpus();
-	mutex_lock(&microcode_mutex);
-
-	if (do_microcode_update(buf, len) == 0)
-		ret = (ssize_t)len;
-
-	if (ret > 0)
-		perf_check_microcode();
-
-	mutex_unlock(&microcode_mutex);
-	put_online_cpus();
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
@@ -629,7 +549,7 @@ static ssize_t reload_store(struct device *dev,
 	if (val != 1)
 		return size;
 
-	get_online_cpus();
+	cpus_read_lock();
 
 	ret = check_online_cpus();
 	if (ret)
@@ -644,7 +564,7 @@ static ssize_t reload_store(struct device *dev,
 	mutex_unlock(&microcode_mutex);
 
 put:
-	put_online_cpus();
+	cpus_read_unlock();
 
 	if (ret == 0)
 		ret = size;
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
 
@@ -853,14 +777,14 @@ int __init microcode_init(void)
 	if (IS_ERR(microcode_pdev))
 		return PTR_ERR(microcode_pdev);
 
-	get_online_cpus();
+	cpus_read_lock();
 	mutex_lock(&microcode_mutex);
 
 	error = subsys_interface_register(&mc_cpu_interface);
 	if (!error)
 		perf_check_microcode();
 	mutex_unlock(&microcode_mutex);
-	put_online_cpus();
+	cpus_read_unlock();
 
 	if (error)
 		goto out_pdev;
@@ -873,10 +797,6 @@ int __init microcode_init(void)
 		goto out_driver;
 	}
 
-	error = microcode_dev_init();
-	if (error)
-		goto out_ucode_group;
-
 	register_syscore_ops(&mc_syscore_ops);
 	cpuhp_setup_state_nocalls(CPUHP_AP_MICROCODE_LOADER, "x86/microcode:starting",
 				  mc_cpu_starting, NULL);
@@ -887,18 +807,14 @@ int __init microcode_init(void)
 
 	return 0;
 
- out_ucode_group:
-	sysfs_remove_group(&cpu_subsys.dev_root->kobj,
-			   &cpu_root_microcode_group);
-
  out_driver:
-	get_online_cpus();
+	cpus_read_lock();
 	mutex_lock(&microcode_mutex);
 
 	subsys_interface_unregister(&mc_cpu_interface);
 
 	mutex_unlock(&microcode_mutex);
-	put_online_cpus();
+	cpus_read_unlock();
 
  out_pdev:
 	platform_device_unregister(microcode_pdev);
diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index ff26de11b3f1..1a943743cfe4 100644
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
@@ -2312,8 +2312,8 @@ static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
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
index b1deacbeb266..a932a07d0025 100644
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
index 3d6201492006..e37e5e82481a 100644
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
index 5e17c3939dd1..1cba09a9f1c1 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -720,7 +720,7 @@ bool xen_set_default_idle(void)
 }
 #endif
 
-void stop_this_cpu(void *dummy)
+void __noreturn stop_this_cpu(void *dummy)
 {
 	local_irq_disable();
 	/*
diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
index 98bf8fd18902..3b4c394a1a76 100644
--- a/arch/x86/kernel/process_32.c
+++ b/arch/x86/kernel/process_32.c
@@ -214,7 +214,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	switch_fpu_finish(next_p);
 
 	/* Load the Intel cache allocation PQR MSR. */
-	resctrl_sched_in();
+	resctrl_sched_in(next_p);
 
 	return prev_p;
 }
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index ad3f82a18de9..1d8bc4736fb7 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -629,7 +629,7 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
 	}
 
 	/* Load the Intel cache allocation PQR MSR. */
-	resctrl_sched_in();
+	resctrl_sched_in(next_p);
 
 	return prev_p;
 }
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index df3514835b35..4d8c0e258150 100644
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
index eff4ce3b10da..95758ae120ba 100644
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
 
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index e8e5515fb7e9..bda89ecc7799 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -227,8 +227,7 @@ static void notrace start_secondary(void *unused)
 	load_cr3(swapper_pg_dir);
 	__flush_tlb_all();
 #endif
-	cpu_init_exception_handling();
-	cpu_init();
+	cpu_init_secondary();
 	rcu_cpu_starting(raw_smp_processor_id());
 	x86_cpuinit.early_percpu_clock_init();
 	smp_callin();
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
 
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index 2a39a2df6f43..3780c728345c 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1185,9 +1185,7 @@ void __init trap_init(void)
 
 	idt_setup_traps();
 
-	/*
-	 * Should be a barrier for any external CPU state:
-	 */
+	cpu_init_exception_handling();
 	cpu_init();
 
 	idt_setup_ist_traps();
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 260727eaa6b9..21189804524a 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2115,10 +2115,14 @@ int kvm_lapic_reg_write(struct kvm_lapic *apic, u32 reg, u32 val)
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
diff --git a/arch/x86/um/vdso/um_vdso.c b/arch/x86/um/vdso/um_vdso.c
index 2112b8d14668..ff0f3b4b6c45 100644
--- a/arch/x86/um/vdso/um_vdso.c
+++ b/arch/x86/um/vdso/um_vdso.c
@@ -17,8 +17,10 @@ int __vdso_clock_gettime(clockid_t clock, struct __kernel_old_timespec *ts)
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
@@ -29,8 +31,10 @@ int __vdso_gettimeofday(struct __kernel_old_timeval *tv, struct timezone *tz)
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
index 4f6f140a44e0..a4cfc97275df 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -428,6 +428,7 @@ int bio_integrity_clone(struct bio *bio, struct bio *bio_src,
 
 	bip->bip_vcnt = bip_src->bip_vcnt;
 	bip->bip_iter = bip_src->bip_iter;
+	bip->bip_flags = bip_src->bip_flags & ~BIP_BLOCK_INTEGRITY;
 
 	return 0;
 }
diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index fb8f959a7f32..9255b642d6ad 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -872,9 +872,14 @@ static void calc_lcoefs(u64 bps, u64 seqiops, u64 randiops,
 
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
index 72e64ba661fc..7858c5a3535e 100644
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
@@ -224,7 +223,7 @@ static struct blk_mq_ctx *blk_mq_next_ctx(struct blk_mq_hw_ctx *hctx,
 /*
  * Only SCSI implements .get_budget and .put_budget, and SCSI restarts
  * its queue by itself in its completion handler, so we don't need to
- * restart queue if .get_budget() returns BLK_STS_NO_RESOURCE.
+ * restart queue if .get_budget() fails to get the budget.
  *
  * Returns -EAGAIN if hctx->dispatch was found non-empty and run_work has to
  * be run again.  This is necessary to avoid starving flushes.
diff --git a/block/blk-mq.c b/block/blk-mq.c
index e37ba792902a..cf66de0f00fd 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -448,7 +448,8 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 	 * allocator for this for the rare use case of a command tied to
 	 * a specific queue.
 	 */
-	if (WARN_ON_ONCE(!(flags & (BLK_MQ_REQ_NOWAIT | BLK_MQ_REQ_RESERVED))))
+	if (WARN_ON_ONCE(!(flags & BLK_MQ_REQ_NOWAIT)) ||
+	    WARN_ON_ONCE(!(flags & BLK_MQ_REQ_RESERVED)))
 		return ERR_PTR(-EINVAL);
 
 	if (hctx_idx >= q->nr_hw_queues)
diff --git a/crypto/essiv.c b/crypto/essiv.c
index d012be23d496..85bb624e32b9 100644
--- a/crypto/essiv.c
+++ b/crypto/essiv.c
@@ -170,7 +170,12 @@ static void essiv_aead_done(struct crypto_async_request *areq, int err)
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
 
@@ -246,7 +251,7 @@ static int essiv_aead_crypt(struct aead_request *req, bool enc)
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
index ad45b009774b..c6a105dba38b 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -202,12 +202,12 @@ static void xts_encrypt_done(struct crypto_async_request *areq, int err)
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
@@ -222,12 +222,12 @@ static void xts_decrypt_done(struct crypto_async_request *areq, int err)
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
index b2ca7dfd3fc9..0cc4de3f71d5 100644
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
index 90db2d85e7f5..f28d811a3724 100644
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
index be743d177bcb..8b43efe97da5 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -454,7 +454,7 @@ static int extract_package(struct acpi_battery *battery,
 			u8 *ptr = (u8 *)battery + offsets[i].offset;
 			if (element->type == ACPI_TYPE_STRING ||
 			    element->type == ACPI_TYPE_BUFFER)
-				strncpy(ptr, element->string.pointer, 32);
+				strscpy(ptr, element->string.pointer, 32);
 			else if (element->type == ACPI_TYPE_INTEGER) {
 				strncpy(ptr, (u8 *)&element->integer.value,
 					sizeof(u64));
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
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index cc49a921339f..11078e166368 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -80,11 +80,9 @@ static struct page *brd_lookup_page(struct brd_device *brd, sector_t sector)
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
@@ -92,7 +90,7 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
 
 	page = brd_lookup_page(brd, sector);
 	if (page)
-		return page;
+		return 0;
 
 	/*
 	 * Must use NOIO because we don't want to recurse back into the
@@ -101,11 +99,11 @@ static struct page *brd_insert_page(struct brd_device *brd, sector_t sector)
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
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index b10410585a74..d86fbea54652 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1029,13 +1029,13 @@ loop_set_status_from_info(struct loop_device *lo,
 	if (err)
 		return err;
 
+	/* Avoid assigning overflow values */
+	if (info->lo_offset > LLONG_MAX || info->lo_sizelimit > LLONG_MAX)
+		return -EOVERFLOW;
+
 	lo->lo_offset = info->lo_offset;
 	lo->lo_sizelimit = info->lo_sizelimit;
 
-	/* loff_t vars have been assigned __u64 */
-	if (lo->lo_offset < 0 || lo->lo_sizelimit < 0)
-		return -EOVERFLOW;
-
 	memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
 	memcpy(lo->lo_crypt_name, info->lo_crypt_name, LO_NAME_SIZE);
 	lo->lo_file_name[LO_NAME_SIZE-1] = 0;
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 340b1df365f7..932d4bb8e403 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5369,8 +5369,7 @@ static void rbd_dev_release(struct device *dev)
 		module_put(THIS_MODULE);
 }
 
-static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
-					   struct rbd_spec *spec)
+static struct rbd_device *__rbd_dev_create(struct rbd_spec *spec)
 {
 	struct rbd_device *rbd_dev;
 
@@ -5415,9 +5414,6 @@ static struct rbd_device *__rbd_dev_create(struct rbd_client *rbdc,
 	rbd_dev->dev.parent = &rbd_root_dev;
 	device_initialize(&rbd_dev->dev);
 
-	rbd_dev->rbd_client = rbdc;
-	rbd_dev->spec = spec;
-
 	return rbd_dev;
 }
 
@@ -5430,12 +5426,10 @@ static struct rbd_device *rbd_dev_create(struct rbd_client *rbdc,
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
@@ -5452,6 +5446,10 @@ static struct rbd_device *rbd_dev_create(struct rbd_client *rbdc,
 	/* we have a ref from do_rbd_add() */
 	__module_get(THIS_MODULE);
 
+	rbd_dev->rbd_client = rbdc;
+	rbd_dev->spec = spec;
+	rbd_dev->opts = opts;
+
 	dout("%s rbd_dev %p dev_id %d\n", __func__, rbd_dev, rbd_dev->dev_id);
 	return rbd_dev;
 
@@ -6812,7 +6810,7 @@ static int rbd_dev_probe_parent(struct rbd_device *rbd_dev, int depth)
 		goto out_err;
 	}
 
-	parent = __rbd_dev_create(rbd_dev->rbd_client, rbd_dev->parent_spec);
+	parent = __rbd_dev_create(rbd_dev->parent_spec);
 	if (!parent) {
 		ret = -ENOMEM;
 		goto out_err;
@@ -6822,8 +6820,8 @@ static int rbd_dev_probe_parent(struct rbd_device *rbd_dev, int depth)
 	 * Images related by parent/child relationships always share
 	 * rbd_client and spec/parent_spec, so bump their refcounts.
 	 */
-	__rbd_get_client(rbd_dev->rbd_client);
-	rbd_spec_get(rbd_dev->parent_spec);
+	parent->rbd_client = __rbd_get_client(rbd_dev->rbd_client);
+	parent->spec = rbd_spec_get(rbd_dev->parent_spec);
 
 	__set_bit(RBD_DEV_FLAG_READONLY, &parent->flags);
 
diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
index 3d905fda9b29..2695ece47eb0 100644
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -393,6 +393,10 @@ static const struct usb_device_id blacklist_table[] = {
 	{ USB_VENDOR_AND_INTERFACE_INFO(0x8087, 0xe0, 0x01, 0x01),
 	  .driver_info = BTUSB_IGNORE },
 
+	/* Realtek 8821CE Bluetooth devices */
+	{ USB_DEVICE(0x13d3, 0x3529), .driver_info = BTUSB_REALTEK |
+						     BTUSB_WIDEBAND_SPEECH },
+
 	/* Realtek 8822CE Bluetooth devices */
 	{ USB_DEVICE(0x0bda, 0xb00c), .driver_info = BTUSB_REALTEK |
 						     BTUSB_WIDEBAND_SPEECH },
diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
index 477139749513..0f2bac24e564 100644
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
@@ -579,7 +579,7 @@ static void watch_timeout(struct timer_list *t)
 	if (ssif_info->watch_timeout) {
 		mod_timer(&ssif_info->watch_timer,
 			  jiffies + ssif_info->watch_timeout);
-		if (SSIF_IDLE(ssif_info)) {
+		if (IS_SSIF_IDLE(ssif_info)) {
 			start_flag_fetch(ssif_info, flags); /* Releases lock */
 			return;
 		}
@@ -782,7 +782,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 	}
 
 	switch (ssif_info->ssif_state) {
-	case SSIF_NORMAL:
+	case SSIF_IDLE:
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		if (!msg)
 			break;
@@ -800,7 +800,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 			 * Error fetching flags, or invalid length,
 			 * just give up for now.
 			 */
-			ssif_info->ssif_state = SSIF_NORMAL;
+			ssif_info->ssif_state = SSIF_IDLE;
 			ipmi_ssif_unlock_cond(ssif_info, flags);
 			dev_warn(&ssif_info->client->dev,
 				 "Error getting flags: %d %d, %x\n",
@@ -835,7 +835,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 				 "Invalid response clearing flags: %x %x\n",
 				 data[0], data[1]);
 		}
-		ssif_info->ssif_state = SSIF_NORMAL;
+		ssif_info->ssif_state = SSIF_IDLE;
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		break;
 
@@ -913,7 +913,7 @@ static void msg_done_handler(struct ssif_info *ssif_info, int result,
 	}
 
 	flags = ipmi_ssif_lock_cond(ssif_info, &oflags);
-	if (SSIF_IDLE(ssif_info) && !ssif_info->stopping) {
+	if (IS_SSIF_IDLE(ssif_info) && !ssif_info->stopping) {
 		if (ssif_info->req_events)
 			start_event_fetch(ssif_info, flags);
 		else if (ssif_info->req_flags)
@@ -1087,7 +1087,7 @@ static void start_next_msg(struct ssif_info *ssif_info, unsigned long *flags)
 	unsigned long oflags;
 
  restart:
-	if (!SSIF_IDLE(ssif_info)) {
+	if (!IS_SSIF_IDLE(ssif_info)) {
 		ipmi_ssif_unlock_cond(ssif_info, flags);
 		return;
 	}
@@ -1310,7 +1310,7 @@ static void shutdown_ssif(void *send_info)
 	dev_set_drvdata(&ssif_info->client->dev, NULL);
 
 	/* make sure the driver is not looking for flags any more. */
-	while (ssif_info->ssif_state != SSIF_NORMAL)
+	while (ssif_info->ssif_state != SSIF_IDLE)
 		schedule_timeout(1);
 
 	ssif_info->stopping = true;
@@ -1882,7 +1882,7 @@ static int ssif_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	}
 
 	spin_lock_init(&ssif_info->lock);
-	ssif_info->ssif_state = SSIF_NORMAL;
+	ssif_info->ssif_state = SSIF_IDLE;
 	timer_setup(&ssif_info->retry_timer, retry_timeout, 0);
 	timer_setup(&ssif_info->watch_timer, watch_timeout, 0);
 
diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
index b355d3d40f63..3575afe16a57 100644
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
diff --git a/drivers/clk/imx/clk.c b/drivers/clk/imx/clk.c
index 7cc669934253..d4cf0c7045ab 100644
--- a/drivers/clk/imx/clk.c
+++ b/drivers/clk/imx/clk.c
@@ -201,9 +201,10 @@ static int __init imx_clk_disable_uart(void)
 			clk_disable_unprepare(imx_uart_clocks[i]);
 			clk_put(imx_uart_clocks[i]);
 		}
-		kfree(imx_uart_clocks);
 	}
 
+	kfree(imx_uart_clocks);
+
 	return 0;
 }
 late_initcall_sync(imx_clk_disable_uart);
diff --git a/drivers/clk/qcom/gcc-qcs404.c b/drivers/clk/qcom/gcc-qcs404.c
index 46d314d69250..a7a9884799cd 100644
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
 
diff --git a/drivers/clk/qcom/gpucc-sc7180.c b/drivers/clk/qcom/gpucc-sc7180.c
index 88a739b6fec3..c51114e7e1e6 100644
--- a/drivers/clk/qcom/gpucc-sc7180.c
+++ b/drivers/clk/qcom/gpucc-sc7180.c
@@ -21,8 +21,6 @@
 #define CX_GMU_CBCR_SLEEP_SHIFT		4
 #define CX_GMU_CBCR_WAKE_MASK		0xF
 #define CX_GMU_CBCR_WAKE_SHIFT		8
-#define CLK_DIS_WAIT_SHIFT		12
-#define CLK_DIS_WAIT_MASK		(0xf << CLK_DIS_WAIT_SHIFT)
 
 enum {
 	P_BI_TCXO,
@@ -163,6 +161,7 @@ static struct clk_branch gpu_cc_cxo_clk = {
 static struct gdsc cx_gdsc = {
 	.gdscr = 0x106c,
 	.gds_hw_ctrl = 0x1540,
+	.clk_dis_wait_val = 8,
 	.pd = {
 		.name = "cx_gdsc",
 	},
@@ -245,10 +244,6 @@ static int gpu_cc_sc7180_probe(struct platform_device *pdev)
 	value = 0xF << CX_GMU_CBCR_WAKE_SHIFT | 0xF << CX_GMU_CBCR_SLEEP_SHIFT;
 	regmap_update_bits(regmap, 0x1098, mask, value);
 
-	/* Configure clk_dis_wait for gpu_cx_gdsc */
-	regmap_update_bits(regmap, 0x106c, CLK_DIS_WAIT_MASK,
-						8 << CLK_DIS_WAIT_SHIFT);
-
 	return qcom_cc_really_probe(pdev, &gpu_cc_sc7180_desc, regmap);
 }
 
diff --git a/drivers/clk/qcom/gpucc-sdm845.c b/drivers/clk/qcom/gpucc-sdm845.c
index 5663698b306b..658c6ac700e1 100644
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
@@ -196,10 +195,6 @@ static int gpu_cc_sdm845_probe(struct platform_device *pdev)
 	value = 0xf << CX_GMU_CBCR_WAKE_SHIFT | 0xf << CX_GMU_CBCR_SLEEP_SHIFT;
 	regmap_update_bits(regmap, 0x1098, mask, value);
 
-	/* Configure clk_dis_wait for gpu_cx_gdsc */
-	regmap_update_bits(regmap, 0x106c, CLK_DIS_WAIT_MASK,
-						8 << CLK_DIS_WAIT_SHIFT);
-
 	return qcom_cc_really_probe(pdev, &gpu_cc_sdm845_desc, regmap);
 }
 
diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 94db88370337..a5a68e1e7549 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -914,9 +914,8 @@ static int cpg_mssr_resume_noirq(struct device *dev)
 		}
 
 		if (!i)
-			dev_warn(dev, "Failed to enable %s%u[0x%x]\n",
-				 priv->reg_layout == CLK_REG_LAYOUT_RZ_A ?
-				 "STB" : "SMSTP", reg, oldval & mask);
+			dev_warn(dev, "Failed to enable SMSTP%u[0x%x]\n", reg,
+				 oldval & mask);
 	}
 
 	return 0;
@@ -960,7 +959,6 @@ static int __init cpg_mssr_common_init(struct device *dev,
 		goto out_err;
 	}
 
-	cpg_mssr_priv = priv;
 	priv->num_core_clks = info->num_total_core_clks;
 	priv->num_mod_clks = info->num_hw_mod_clks;
 	priv->last_dt_core_clk = info->last_dt_core_clk;
@@ -990,6 +988,8 @@ static int __init cpg_mssr_common_init(struct device *dev,
 	if (error)
 		goto out_err;
 
+	cpg_mssr_priv = priv;
+
 	return 0;
 
 out_err:
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 2e3690f65786..6d05ac0c0513 100644
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
diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index ed39a22e1b2b..856d867f46eb 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -23,6 +23,7 @@
 #include <linux/gfp.h>
 
 #include <asm/smp.h>
+#include <asm/cacheflush.h>
 
 #include "psp-dev.h"
 #include "sev-dev.h"
@@ -138,6 +139,17 @@ static int sev_cmd_buffer_len(int cmd)
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
@@ -304,15 +316,14 @@ static int sev_platform_shutdown(int *error)
 
 static int sev_get_platform_state(int *state, int *error)
 {
-	struct sev_device *sev = psp_master->sev_data;
+	struct sev_user_data_status data;
 	int rc;
 
-	rc = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS,
-				 &sev->status_cmd_buf, error);
+	rc = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, error);
 	if (rc)
 		return rc;
 
-	*state = sev->status_cmd_buf.state;
+	*state = data.state;
 	return rc;
 }
 
@@ -350,15 +361,16 @@ static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
 
 static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 {
-	struct sev_device *sev = psp_master->sev_data;
-	struct sev_user_data_status *data = &sev->status_cmd_buf;
+	struct sev_user_data_status data;
 	int ret;
 
-	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, data, &argp->error);
+	memset(&data, 0, sizeof(data));
+
+	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, &argp->error);
 	if (ret)
 		return ret;
 
-	if (copy_to_user((void __user *)argp->data, data, sizeof(*data)))
+	if (copy_to_user((void __user *)argp->data, &data, sizeof(data)))
 		ret = -EFAULT;
 
 	return ret;
@@ -385,7 +397,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_csr input;
-	struct sev_data_pek_csr *data;
+	struct sev_data_pek_csr data;
 	void __user *input_address;
 	void *blob = NULL;
 	int ret;
@@ -396,9 +408,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	memset(&data, 0, sizeof(data));
 
 	/* userspace wants to query CSR length */
 	if (!input.address || !input.length)
@@ -406,19 +416,15 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 
 	/* allocate a physically contiguous buffer to store the CSR blob */
 	input_address = (void __user *)input.address;
-	if (input.length > SEV_FW_BLOB_MAX_SIZE) {
-		ret = -EFAULT;
-		goto e_free;
-	}
+	if (input.length > SEV_FW_BLOB_MAX_SIZE)
+		return -EFAULT;
 
-	blob = kmalloc(input.length, GFP_KERNEL);
-	if (!blob) {
-		ret = -ENOMEM;
-		goto e_free;
-	}
+	blob = kzalloc(input.length, GFP_KERNEL);
+	if (!blob)
+		return -ENOMEM;
 
-	data->address = __psp_pa(blob);
-	data->len = input.length;
+	data.address = __psp_pa(blob);
+	data.len = input.length;
 
 cmd:
 	if (sev->state == SEV_STATE_UNINIT) {
@@ -427,10 +433,10 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 			goto e_free_blob;
 	}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, data, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CSR, &data, &argp->error);
 
 	 /* If we query the CSR length, FW responded with expected data. */
-	input.length = data->len;
+	input.length = data.len;
 
 	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
 		ret = -EFAULT;
@@ -444,8 +450,6 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
 
 e_free_blob:
 	kfree(blob);
-e_free:
-	kfree(data);
 	return ret;
 }
 
@@ -465,21 +469,20 @@ EXPORT_SYMBOL_GPL(psp_copy_user_blob);
 static int sev_get_api_version(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	struct sev_user_data_status *status;
+	struct sev_user_data_status status;
 	int error = 0, ret;
 
-	status = &sev->status_cmd_buf;
-	ret = sev_platform_status(status, &error);
+	ret = sev_platform_status(&status, &error);
 	if (ret) {
 		dev_err(sev->dev,
 			"SEV: failed to get status. Error: %#x\n", error);
 		return 1;
 	}
 
-	sev->api_major = status->api_major;
-	sev->api_minor = status->api_minor;
-	sev->build = status->build;
-	sev->state = status->state;
+	sev->api_major = status.api_major;
+	sev->api_minor = status.api_minor;
+	sev->build = status.build;
+	sev->state = status.state;
 
 	return 0;
 }
@@ -577,7 +580,7 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 {
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pek_cert_import input;
-	struct sev_data_pek_cert_import *data;
+	struct sev_data_pek_cert_import data;
 	void *pek_blob, *oca_blob;
 	int ret;
 
@@ -587,19 +590,14 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
 	/* copy PEK certificate blobs from userspace */
 	pek_blob = psp_copy_user_blob(input.pek_cert_address, input.pek_cert_len);
-	if (IS_ERR(pek_blob)) {
-		ret = PTR_ERR(pek_blob);
-		goto e_free;
-	}
+	if (IS_ERR(pek_blob))
+		return PTR_ERR(pek_blob);
 
-	data->pek_cert_address = __psp_pa(pek_blob);
-	data->pek_cert_len = input.pek_cert_len;
+	data.reserved = 0;
+	data.pek_cert_address = __psp_pa(pek_blob);
+	data.pek_cert_len = input.pek_cert_len;
 
 	/* copy PEK certificate blobs from userspace */
 	oca_blob = psp_copy_user_blob(input.oca_cert_address, input.oca_cert_len);
@@ -608,8 +606,8 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 		goto e_free_pek;
 	}
 
-	data->oca_cert_address = __psp_pa(oca_blob);
-	data->oca_cert_len = input.oca_cert_len;
+	data.oca_cert_address = __psp_pa(oca_blob);
+	data.oca_cert_len = input.oca_cert_len;
 
 	/* If platform is not in INIT state then transition it to INIT */
 	if (sev->state != SEV_STATE_INIT) {
@@ -618,21 +616,19 @@ static int sev_ioctl_do_pek_import(struct sev_issue_cmd *argp, bool writable)
 			goto e_free_oca;
 	}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, data, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_PEK_CERT_IMPORT, &data, &argp->error);
 
 e_free_oca:
 	kfree(oca_blob);
 e_free_pek:
 	kfree(pek_blob);
-e_free:
-	kfree(data);
 	return ret;
 }
 
 static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 {
 	struct sev_user_data_get_id2 input;
-	struct sev_data_get_id *data;
+	struct sev_data_get_id data;
 	void __user *input_address;
 	void *id_blob = NULL;
 	int ret;
@@ -646,28 +642,32 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 
 	input_address = (void __user *)input.address;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
 	if (input.address && input.length) {
-		id_blob = kmalloc(input.length, GFP_KERNEL);
-		if (!id_blob) {
-			kfree(data);
+		/*
+		 * The length of the ID shouldn't be assumed by software since
+		 * it may change in the future.  The allocation size is limited
+		 * to 1 << (PAGE_SHIFT + MAX_ORDER - 1) by the page allocator.
+		 * If the allocation fails, simply return ENOMEM rather than
+		 * warning in the kernel log.
+		 */
+		id_blob = kzalloc(input.length, GFP_KERNEL | __GFP_NOWARN);
+		if (!id_blob)
 			return -ENOMEM;
-		}
 
-		data->address = __psp_pa(id_blob);
-		data->len = input.length;
+		data.address = __psp_pa(id_blob);
+		data.len = input.length;
+	} else {
+		data.address = 0;
+		data.len = 0;
 	}
 
-	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, data, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_GET_ID, &data, &argp->error);
 
 	/*
 	 * Firmware will return the length of the ID value (either the minimum
 	 * required length or the actual length written), return it to the user.
 	 */
-	input.length = data->len;
+	input.length = data.len;
 
 	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
 		ret = -EFAULT;
@@ -675,7 +675,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 	}
 
 	if (id_blob) {
-		if (copy_to_user(input_address, id_blob, data->len)) {
+		if (copy_to_user(input_address, id_blob, data.len)) {
 			ret = -EFAULT;
 			goto e_free;
 		}
@@ -683,7 +683,6 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
 
 e_free:
 	kfree(id_blob);
-	kfree(data);
 
 	return ret;
 }
@@ -733,7 +732,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	struct sev_device *sev = psp_master->sev_data;
 	struct sev_user_data_pdh_cert_export input;
 	void *pdh_blob = NULL, *cert_blob = NULL;
-	struct sev_data_pdh_cert_export *data;
+	struct sev_data_pdh_cert_export data;
 	void __user *input_cert_chain_address;
 	void __user *input_pdh_cert_address;
 	int ret;
@@ -751,9 +750,7 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
 		return -EFAULT;
 
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	memset(&data, 0, sizeof(data));
 
 	/* Userspace wants to query the certificate length. */
 	if (!input.pdh_cert_address ||
@@ -765,41 +762,35 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	input_cert_chain_address = (void __user *)input.cert_chain_address;
 
 	/* Allocate a physically contiguous buffer to store the PDH blob. */
-	if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE) {
-		ret = -EFAULT;
-		goto e_free;
-	}
+	if (input.pdh_cert_len > SEV_FW_BLOB_MAX_SIZE)
+		return -EFAULT;
 
 	/* Allocate a physically contiguous buffer to store the cert chain blob. */
-	if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE) {
-		ret = -EFAULT;
-		goto e_free;
-	}
+	if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)
+		return -EFAULT;
 
-	pdh_blob = kmalloc(input.pdh_cert_len, GFP_KERNEL);
-	if (!pdh_blob) {
-		ret = -ENOMEM;
-		goto e_free;
-	}
+	pdh_blob = kzalloc(input.pdh_cert_len, GFP_KERNEL);
+	if (!pdh_blob)
+		return -ENOMEM;
 
-	data->pdh_cert_address = __psp_pa(pdh_blob);
-	data->pdh_cert_len = input.pdh_cert_len;
+	data.pdh_cert_address = __psp_pa(pdh_blob);
+	data.pdh_cert_len = input.pdh_cert_len;
 
-	cert_blob = kmalloc(input.cert_chain_len, GFP_KERNEL);
+	cert_blob = kzalloc(input.cert_chain_len, GFP_KERNEL);
 	if (!cert_blob) {
 		ret = -ENOMEM;
 		goto e_free_pdh;
 	}
 
-	data->cert_chain_address = __psp_pa(cert_blob);
-	data->cert_chain_len = input.cert_chain_len;
+	data.cert_chain_address = __psp_pa(cert_blob);
+	data.cert_chain_len = input.cert_chain_len;
 
 cmd:
-	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, data, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_PDH_CERT_EXPORT, &data, &argp->error);
 
 	/* If we query the length, FW responded with expected data. */
-	input.cert_chain_len = data->cert_chain_len;
-	input.pdh_cert_len = data->pdh_cert_len;
+	input.cert_chain_len = data.cert_chain_len;
+	input.pdh_cert_len = data.pdh_cert_len;
 
 	if (copy_to_user((void __user *)argp->data, &input, sizeof(input))) {
 		ret = -EFAULT;
@@ -824,8 +815,6 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
 	kfree(cert_blob);
 e_free_pdh:
 	kfree(pdh_blob);
-e_free:
-	kfree(data);
 	return ret;
 }
 
@@ -1063,7 +1052,6 @@ EXPORT_SYMBOL_GPL(sev_issue_cmd_external_user);
 void sev_pci_init(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	struct page *tmr_page;
 	int error, rc;
 
 	if (!sev)
@@ -1079,14 +1067,13 @@ void sev_pci_init(void)
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
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index dd5c4fe82914..3b0cd0f854df 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -46,7 +46,6 @@ struct sev_device {
 	unsigned int int_rcvd;
 	wait_queue_head_t int_queue;
 	struct sev_misc_dev *misc;
-	struct sev_user_data_status status_cmd_buf;
 	struct sev_data_init init_cmd_buf;
 
 	u8 api_major;
diff --git a/drivers/crypto/hisilicon/sgl.c b/drivers/crypto/hisilicon/sgl.c
index 725a739800b0..ce77826c7fb0 100644
--- a/drivers/crypto/hisilicon/sgl.c
+++ b/drivers/crypto/hisilicon/sgl.c
@@ -113,9 +113,8 @@ struct hisi_acc_sgl_pool *hisi_acc_create_sgl_pool(struct device *dev,
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
diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index c1d379bd7af3..a02777c93c07 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -398,8 +398,8 @@ static void unregister_dev_dax(void *dev)
 	dev_dbg(dev, "%s\n", __func__);
 
 	kill_dev_dax(dev_dax);
-	free_dev_dax_ranges(dev_dax);
 	device_del(dev);
+	free_dev_dax_ranges(dev_dax);
 	put_device(dev);
 }
 
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index b4368c5b6a0c..27d669f8b5f3 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -114,7 +114,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
 					i, range.start, range.end);
-			release_resource(res);
+			remove_resource(res);
 			kfree(res);
 			data->res[i] = NULL;
 			if (mapped)
@@ -159,7 +159,7 @@ static int dev_dax_kmem_remove(struct dev_dax *dev_dax)
 		rc = remove_memory(dev_dax->target_node, range.start,
 				range_len(&range));
 		if (rc == 0) {
-			release_resource(data->res[i]);
+			remove_resource(data->res[i]);
 			kfree(data->res[i]);
 			data->res[i] = NULL;
 			success++;
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
index fbe15f4b75fd..dbdf0e210522 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2051,12 +2051,14 @@ static int dm_resume(void *handle)
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
index 99887bcfada0..7e0a55aa2b18 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -616,6 +616,7 @@ static bool dc_construct_ctx(struct dc *dc,
 
 	dc_ctx->perf_trace = dc_perf_trace_create();
 	if (!dc_ctx->perf_trace) {
+		kfree(dc_ctx);
 		ASSERT_CRITICAL(false);
 		return false;
 	}
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20.c
index b3f0476899d3..14e7a59a9cd1 100644
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
index 1bcda7eba4a6..ee1c80366bd6 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/display_mode_vba_20v2.c
@@ -3974,17 +3974,17 @@ void dml20v2_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode
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
@@ -4037,7 +4037,7 @@ void dml20v2_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode
 				locals->RequiredDISPCLK[i][j] = 0.0;
 				locals->DISPCLK_DPPCLK_Support[i][j] = true;
 				for (k = 0; k <= mode_lib->vba.NumberOfActivePlanes - 1; k++) {
-					locals->ODMCombineEnablePerState[i][k] = false;
+					locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_disabled;
 					if (locals->SwathWidthYSingleDPP[k] <= locals->MaximumSwathWidth[k]) {
 						locals->NoOfDPP[i][j][k] = 1;
 						locals->RequiredDPPCLK[i][j][k] = locals->MinDPPCLKUsingSingleDPP[k]
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
index c09bca335068..25693e62db80 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn21/display_mode_vba_21.c
@@ -3975,17 +3975,17 @@ void dml21_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
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
@@ -4038,7 +4038,7 @@ void dml21_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 				locals->RequiredDISPCLK[i][j] = 0.0;
 				locals->DISPCLK_DPPCLK_Support[i][j] = true;
 				for (k = 0; k <= mode_lib->vba.NumberOfActivePlanes - 1; k++) {
-					locals->ODMCombineEnablePerState[i][k] = false;
+					locals->ODMCombineEnablePerState[i][k] = dm_odm_combine_mode_disabled;
 					if (locals->SwathWidthYSingleDPP[k] <= locals->MaximumSwathWidth[k]) {
 						locals->NoOfDPP[i][j][k] = 1;
 						locals->RequiredDPPCLK[i][j][k] = locals->MinDPPCLKUsingSingleDPP[k]
@@ -5213,7 +5213,7 @@ void dml21_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_l
 			mode_lib->vba.ODMCombineEnabled[k] =
 					locals->ODMCombineEnablePerState[mode_lib->vba.VoltageLevel][k];
 		} else {
-			mode_lib->vba.ODMCombineEnabled[k] = false;
+			mode_lib->vba.ODMCombineEnabled[k] = dm_odm_combine_mode_disabled;
 		}
 		mode_lib->vba.DSCEnabled[k] =
 				locals->RequiresDSC[mode_lib->vba.VoltageLevel][k];
diff --git a/drivers/gpu/drm/arm/malidp_planes.c b/drivers/gpu/drm/arm/malidp_planes.c
index f1e8bc39b16d..24604b410372 100644
--- a/drivers/gpu/drm/arm/malidp_planes.c
+++ b/drivers/gpu/drm/arm/malidp_planes.c
@@ -348,7 +348,7 @@ static bool malidp_check_pages_threshold(struct malidp_plane_state *ms,
 		else
 			sgt = obj->funcs->get_sg_table(obj);
 
-		if (!sgt)
+		if (IS_ERR(sgt))
 			return false;
 
 		sgl = sgt->sgl;
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
 
diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 0feeac52e4eb..b5e15933cb5f 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3769,6 +3769,9 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 		set_bit(0, &mgr->payload_mask);
 		mgr->vcpi_mask = 0;
 		mgr->payload_id_table_cleared = false;
+
+		memset(&mgr->down_rep_recv, 0, sizeof(mgr->down_rep_recv));
+		memset(&mgr->up_req_recv, 0, sizeof(mgr->up_req_recv));
 	}
 
 out_unlock:
@@ -3985,7 +3988,7 @@ static int drm_dp_mst_handle_down_rep(struct drm_dp_mst_topology_mgr *mgr)
 	struct drm_dp_sideband_msg_rx *msg = &mgr->down_rep_recv;
 
 	if (!drm_dp_get_one_sb_msg(mgr, false, &mstb))
-		goto out;
+		goto out_clear_reply;
 
 	/* Multi-packet message transmission, don't clear the reply */
 	if (!msg->have_eomt)
diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 4334e466b4e0..39eb39e78d7a 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -5560,8 +5560,6 @@ static u8 drm_mode_hdmi_vic(const struct drm_connector *connector,
 static u8 drm_mode_cea_vic(const struct drm_connector *connector,
 			   const struct drm_display_mode *mode)
 {
-	u8 vic;
-
 	/*
 	 * HDMI spec says if a mode is found in HDMI 1.4b 4K modes
 	 * we should send its VIC in vendor infoframes, else send the
@@ -5571,13 +5569,18 @@ static u8 drm_mode_cea_vic(const struct drm_connector *connector,
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
 
@@ -5653,7 +5656,7 @@ drm_hdmi_avi_infoframe_from_display_mode(struct hdmi_avi_infoframe *frame,
 		picture_aspect = HDMI_PICTURE_ASPECT_NONE;
 	}
 
-	frame->video_code = vic;
+	frame->video_code = vic_for_avi_infoframe(connector, vic);
 	frame->picture_aspect = picture_aspect;
 	frame->active_aspect = HDMI_ACTIVE_ASPECT_PICTURE;
 	frame->scan_mode = HDMI_SCAN_MODE_UNDERSCAN;
diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index 92152c06b75b..8d1064061e83 100644
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
index f1affc1bb679..fad2c1181127 100644
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
diff --git a/drivers/gpu/drm/i915/display/intel_quirks.c b/drivers/gpu/drm/i915/display/intel_quirks.c
index 8eb1842f14ce..b4e74c86fae7 100644
--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -159,6 +159,8 @@ static struct intel_quirk intel_quirks[] = {
 	/* ECS Liva Q2 */
 	{ 0x3185, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
 	{ 0x3184, 0x1019, 0xa94d, quirk_increase_ddi_disabled_time },
+	/* HP Notebook - 14-r206nv */
+	{ 0x0f31, 0x103c, 0x220f, quirk_invert_brightness },
 };
 
 void intel_init_quirks(struct drm_i915_private *i915)
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
index dfd5ed15a7f4..e83b1c406b96 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_crtc.c
@@ -803,6 +803,8 @@ int mtk_drm_crtc_create(struct drm_device *drm_dev,
 
 	mtk_crtc->planes = devm_kcalloc(dev, num_comp_planes,
 					sizeof(struct drm_plane), GFP_KERNEL);
+	if (!mtk_crtc->planes)
+		return -ENOMEM;
 
 	for (i = 0; i < mtk_crtc->ddp_comp_nr; i++) {
 		ret = mtk_drm_crtc_init_comp_planes(drm_dev, mtk_crtc, i,
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_drv.c b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
index 59c85c63b7cc..719c46d245dd 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_drv.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_drv.c
@@ -378,6 +378,7 @@ static int mtk_drm_bind(struct device *dev)
 err_deinit:
 	mtk_drm_kms_deinit(drm);
 err_free:
+	private->drm = NULL;
 	drm_dev_put(drm);
 	return ret;
 }
diff --git a/drivers/gpu/drm/mediatek/mtk_drm_gem.c b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
index 0583e557ad37..29702dd8631d 100644
--- a/drivers/gpu/drm/mediatek/mtk_drm_gem.c
+++ b/drivers/gpu/drm/mediatek/mtk_drm_gem.c
@@ -142,8 +142,6 @@ static int mtk_drm_gem_object_mmap(struct drm_gem_object *obj,
 
 	ret = dma_mmap_attrs(priv->dma_dev, vma, mtk_gem->cookie,
 			     mtk_gem->dma_addr, obj->size, mtk_gem->dma_attrs);
-	if (ret)
-		drm_gem_vm_close(vma);
 
 	return ret;
 }
@@ -266,6 +264,6 @@ void mtk_drm_gem_prime_vunmap(struct drm_gem_object *obj, void *vaddr)
 		return;
 
 	vunmap(vaddr);
-	mtk_gem->kvaddr = 0;
+	mtk_gem->kvaddr = NULL;
 	kfree(mtk_gem->pages);
 }
diff --git a/drivers/gpu/drm/mediatek/mtk_dsi.c b/drivers/gpu/drm/mediatek/mtk_dsi.c
index 146c4d04f572..a6e71b7b69b8 100644
--- a/drivers/gpu/drm/mediatek/mtk_dsi.c
+++ b/drivers/gpu/drm/mediatek/mtk_dsi.c
@@ -704,7 +704,7 @@ static void mtk_dsi_lane_ready(struct mtk_dsi *dsi)
 		mtk_dsi_clk_ulp_mode_leave(dsi);
 		mtk_dsi_lane0_ulp_mode_leave(dsi);
 		mtk_dsi_clk_hs_mode(dsi, 0);
-		msleep(20);
+		usleep_range(1000, 3000);
 		/* The reaction time after pulling up the mipi signal for dsi_rx */
 	}
 }
diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index de8cc25506d6..78181e2d78a9 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -954,13 +954,13 @@ int adreno_gpu_init(struct drm_device *drm, struct platform_device *pdev,
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
index f56414a06ec4..5afb3c544653 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -682,7 +682,10 @@ static void dpu_crtc_reset(struct drm_crtc *crtc)
 	if (crtc->state)
 		dpu_crtc_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &cstate->base);
+	if (cstate)
+		__drm_atomic_helper_crtc_reset(crtc, &cstate->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 }
 
 /**
@@ -831,6 +834,8 @@ static int dpu_crtc_atomic_check(struct drm_crtc *crtc,
 	struct drm_rect crtc_rect = { 0 };
 
 	pstates = kzalloc(sizeof(*pstates) * DPU_STAGE_MAX * 4, GFP_KERNEL);
+	if (!pstates)
+		return -ENOMEM;
 
 	if (!state->enable || !state->active) {
 		DPU_DEBUG("crtc%d -> enable %d, active %d, skip atomic_check\n",
diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
index 74a13ccad34c..948300529743 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_rm.c
@@ -633,6 +633,11 @@ int dpu_rm_get_assigned_resources(struct dpu_rm *rm,
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
index ff4f207cbdea..60e7371cd0e0 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c
@@ -1124,7 +1124,10 @@ static void mdp5_crtc_reset(struct drm_crtc *crtc)
 	if (crtc->state)
 		mdp5_crtc_destroy_state(crtc, crtc->state);
 
-	__drm_atomic_helper_crtc_reset(crtc, &mdp5_cstate->base);
+	if (mdp5_cstate)
+		__drm_atomic_helper_crtc_reset(crtc, &mdp5_cstate->base);
+	else
+		__drm_atomic_helper_crtc_reset(crtc, NULL);
 }
 
 static const struct drm_crtc_funcs mdp5_crtc_no_lm_cursor_funcs = {
diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 51e8318cc8ff..5a76aa138917 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1913,6 +1913,9 @@ int msm_dsi_host_init(struct msm_dsi *msm_dsi)
 
 	/* setup workqueue */
 	msm_host->workqueue = alloc_ordered_workqueue("dsi_drm_work", 0);
+	if (!msm_host->workqueue)
+		return -ENOMEM;
+
 	INIT_WORK(&msm_host->err_work, dsi_err_worker);
 	INIT_WORK(&msm_host->hpd_work, dsi_hpd_worker);
 
diff --git a/drivers/gpu/drm/msm/hdmi/hdmi.c b/drivers/gpu/drm/msm/hdmi/hdmi.c
index efb14043a6ec..bee208773bee 100644
--- a/drivers/gpu/drm/msm/hdmi/hdmi.c
+++ b/drivers/gpu/drm/msm/hdmi/hdmi.c
@@ -264,6 +264,10 @@ static struct hdmi *msm_hdmi_init(struct platform_device *pdev)
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
index eeccf40bae41..1b1ddc5fe6dc 100644
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
diff --git a/drivers/gpu/drm/radeon/atombios_encoders.c b/drivers/gpu/drm/radeon/atombios_encoders.c
index 12aa7877a625..8cca58f25c0f 100644
--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -2191,11 +2191,12 @@ int radeon_atom_pick_dig_encoder(struct drm_encoder *encoder, int fe_idx)
 
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
index 8287410f471f..131f425c363a 100644
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
diff --git a/drivers/gpu/drm/tidss/tidss_dispc.c b/drivers/gpu/drm/tidss/tidss_dispc.c
index b669168ae7cb..33716213a821 100644
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
index 403af68fa440..7ea26e5fbcb2 100644
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
index 539ebf85fd7c..7e8620838de9 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -567,11 +567,12 @@ static void vc5_hdmi_set_timings(struct vc4_hdmi *vc4_hdmi,
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
 
 	HDMI_WRITE(HDMI_VEC_INTERFACE_XBAR, 0x354021);
diff --git a/drivers/gpu/drm/vc4/vc4_hvs.c b/drivers/gpu/drm/vc4/vc4_hvs.c
index 95fa6fc052a7..f8f2fc3d15f7 100644
--- a/drivers/gpu/drm/vc4/vc4_hvs.c
+++ b/drivers/gpu/drm/vc4/vc4_hvs.c
@@ -677,6 +677,17 @@ static int vc4_hvs_bind(struct device *dev, struct device *master, void *data)
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
index 4df222a83049..2e03c16c60bb 100644
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
index be2c32a519b3..a324ef88ceaf 100644
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
 
diff --git a/drivers/gpu/drm/virtio/virtgpu_object.c b/drivers/gpu/drm/virtio/virtgpu_object.c
index 168148686001..49fa59e09187 100644
--- a/drivers/gpu/drm/virtio/virtgpu_object.c
+++ b/drivers/gpu/drm/virtio/virtgpu_object.c
@@ -159,8 +159,9 @@ static int virtio_gpu_object_shmem_init(struct virtio_gpu_device *vgdev,
 	shmem->pages = drm_gem_shmem_get_sg_table(&bo->base.base);
 	if (IS_ERR(shmem->pages)) {
 		drm_gem_shmem_unpin(&bo->base.base);
+		ret = PTR_ERR(shmem->pages);
 		shmem->pages = NULL;
-		return PTR_ERR(shmem->pages);
+		return ret;
 	}
 
 	if (use_dma_api) {
diff --git a/drivers/gpu/drm/vkms/vkms_drv.c b/drivers/gpu/drm/vkms/vkms_drv.c
index cb0b6230c22c..838428988f79 100644
--- a/drivers/gpu/drm/vkms/vkms_drv.c
+++ b/drivers/gpu/drm/vkms/vkms_drv.c
@@ -61,7 +61,8 @@ static void vkms_release(struct drm_device *dev)
 {
 	struct vkms_device *vkms = container_of(dev, struct vkms_device, drm);
 
-	destroy_workqueue(vkms->output.composer_workq);
+	if (vkms->output.composer_workq)
+		destroy_workqueue(vkms->output.composer_workq);
 }
 
 static void vkms_atomic_commit_tail(struct drm_atomic_state *old_state)
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
index d166ee262ce4..22dae3f51051 100644
--- a/drivers/gpu/ipu-v3/ipu-common.c
+++ b/drivers/gpu/ipu-v3/ipu-common.c
@@ -1168,6 +1168,7 @@ static int ipu_add_client_devices(struct ipu_soc *ipu, unsigned long ipu_base)
 		pdev = platform_device_alloc(reg->name, id++);
 		if (!pdev) {
 			ret = -ENOMEM;
+			of_node_put(of_node);
 			goto err_register;
 		}
 
diff --git a/drivers/hid/hid-asus.c b/drivers/hid/hid-asus.c
index f85c6e3309a0..6865cab33cf8 100644
--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -95,6 +95,7 @@ struct asus_kbd_leds {
 	struct hid_device *hdev;
 	struct work_struct work;
 	unsigned int brightness;
+	spinlock_t lock;
 	bool removed;
 };
 
@@ -397,24 +398,42 @@ static int asus_kbd_get_functions(struct hid_device *hdev,
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
@@ -422,11 +441,11 @@ static void asus_kbd_backlight_work(struct work_struct *work)
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
@@ -488,6 +507,7 @@ static int asus_kbd_register_leds(struct hid_device *hdev)
 	drvdata->kbd_backlight->cdev.brightness_set = asus_kbd_backlight_set;
 	drvdata->kbd_backlight->cdev.brightness_get = asus_kbd_backlight_get;
 	INIT_WORK(&drvdata->kbd_backlight->work, asus_kbd_backlight_work);
+	spin_lock_init(&drvdata->kbd_backlight->lock);
 
 	ret = devm_led_classdev_register(&hdev->dev, &drvdata->kbd_backlight->cdev);
 	if (ret < 0) {
@@ -1016,9 +1036,13 @@ static int asus_probe(struct hid_device *hdev, const struct hid_device_id *id)
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
index f4e2e6937758..1f60a381ae63 100644
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
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 75a4d8d6bb0f..3399953256d8 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -675,6 +675,14 @@ static void hidinput_configure_usage(struct hid_input *hidinput, struct hid_fiel
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
index 66b105162039..f5ea8e1d8445 100644
--- a/drivers/hid/hid-logitech-hidpp.c
+++ b/drivers/hid/hid-logitech-hidpp.c
@@ -3763,6 +3763,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	bool connected;
 	unsigned int connect_mask = HID_CONNECT_DEFAULT;
 	struct hidpp_ff_private_data data;
+	bool will_restart = false;
 
 	/* report_fixup needs drvdata to be set before we call hid_parse */
 	hidpp = devm_kzalloc(&hdev->dev, sizeof(*hidpp), GFP_KERNEL);
@@ -3818,6 +3819,10 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			return ret;
 	}
 
+	if (hidpp->quirks & HIDPP_QUIRK_DELAYED_INIT ||
+	    hidpp->quirks & HIDPP_QUIRK_UNIFYING)
+		will_restart = true;
+
 	INIT_WORK(&hidpp->work, delayed_work_cb);
 	mutex_init(&hidpp->send_mutex);
 	init_waitqueue_head(&hidpp->wait);
@@ -3832,7 +3837,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	 * Plain USB connections need to actually call start and open
 	 * on the transport driver to allow incoming data.
 	 */
-	ret = hid_hw_start(hdev, 0);
+	ret = hid_hw_start(hdev, will_restart ? 0 : connect_mask);
 	if (ret) {
 		hid_err(hdev, "hw start failed\n");
 		goto hid_hw_start_fail;
@@ -3869,6 +3874,7 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 			hidpp->wireless_feature_index = 0;
 		else if (ret)
 			goto hid_hw_init_fail;
+		ret = 0;
 	}
 
 	if (connected && (hidpp->quirks & HIDPP_QUIRK_CLASS_WTP)) {
@@ -3883,19 +3889,21 @@ static int hidpp_probe(struct hid_device *hdev, const struct hid_device_id *id)
 
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
diff --git a/drivers/hwmon/ltc2945.c b/drivers/hwmon/ltc2945.c
index ba9c868a8641..65d792f18425 100644
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
 
diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 88476a1a601a..4b41f35668b2 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -1097,7 +1097,7 @@ static void read_link_down_reason(struct hfi1_devdata *dd, u8 *ldr);
 static void handle_temp_err(struct hfi1_devdata *dd);
 static void dc_shutdown(struct hfi1_devdata *dd);
 static void dc_start(struct hfi1_devdata *dd);
-static int qos_rmt_entries(struct hfi1_devdata *dd, unsigned int *mp,
+static int qos_rmt_entries(unsigned int n_krcv_queues, unsigned int *mp,
 			   unsigned int *np);
 static void clear_full_mgmt_pkey(struct hfi1_pportdata *ppd);
 static int wait_link_transfer_active(struct hfi1_devdata *dd, int wait_ms);
@@ -13403,7 +13403,6 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 	int ret;
 	unsigned ngroups;
 	int rmt_count;
-	int user_rmt_reduced;
 	u32 n_usr_ctxts;
 	u32 send_contexts = chip_send_contexts(dd);
 	u32 rcv_contexts = chip_rcv_contexts(dd);
@@ -13462,28 +13461,34 @@ static int set_up_context_variables(struct hfi1_devdata *dd)
 					 (num_kernel_contexts + n_usr_ctxts),
 					 &node_affinity.real_cpu_mask);
 	/*
-	 * The RMT entries are currently allocated as shown below:
-	 * 1. QOS (0 to 128 entries);
-	 * 2. FECN (num_kernel_context - 1 + num_user_contexts +
-	 *    num_netdev_contexts);
-	 * 3. netdev (num_netdev_contexts).
-	 * It should be noted that FECN oversubscribe num_netdev_contexts
-	 * entries of RMT because both netdev and PSM could allocate any receive
-	 * context between dd->first_dyn_alloc_text and dd->num_rcv_contexts,
-	 * and PSM FECN must reserve an RMT entry for each possible PSM receive
-	 * context.
+	 * RMT entries are allocated as follows:
+	 * 1. QOS (0 to 128 entries)
+	 * 2. FECN (num_kernel_context - 1 [a] + num_user_contexts +
+	 *          num_netdev_contexts [b])
+	 * 3. netdev (NUM_NETDEV_MAP_ENTRIES)
+	 *
+	 * Notes:
+	 * [a] Kernel contexts (except control) are included in FECN if kernel
+	 *     TID_RDMA is active.
+	 * [b] Netdev and user contexts are randomly allocated from the same
+	 *     context pool, so FECN must cover all contexts in the pool.
 	 */
-	rmt_count = qos_rmt_entries(dd, NULL, NULL) + (num_netdev_contexts * 2);
-	if (HFI1_CAP_IS_KSET(TID_RDMA))
-		rmt_count += num_kernel_contexts - 1;
-	if (rmt_count + n_usr_ctxts > NUM_MAP_ENTRIES) {
-		user_rmt_reduced = NUM_MAP_ENTRIES - rmt_count;
-		dd_dev_err(dd,
-			   "RMT size is reducing the number of user receive contexts from %u to %d\n",
-			   n_usr_ctxts,
-			   user_rmt_reduced);
-		/* recalculate */
-		n_usr_ctxts = user_rmt_reduced;
+	rmt_count = qos_rmt_entries(num_kernel_contexts - 1, NULL, NULL)
+		    + (HFI1_CAP_IS_KSET(TID_RDMA) ? num_kernel_contexts - 1
+						  : 0)
+		    + n_usr_ctxts
+		    + num_netdev_contexts
+		    + NUM_NETDEV_MAP_ENTRIES;
+	if (rmt_count > NUM_MAP_ENTRIES) {
+		int over = rmt_count - NUM_MAP_ENTRIES;
+		/* try to squish user contexts, minimum of 1 */
+		if (over >= n_usr_ctxts) {
+			dd_dev_err(dd, "RMT overflow: reduce the requested number of contexts\n");
+			return -EINVAL;
+		}
+		dd_dev_err(dd, "RMT overflow: reducing # user contexts from %u to %u\n",
+			   n_usr_ctxts, n_usr_ctxts - over);
+		n_usr_ctxts -= over;
 	}
 
 	/* the first N are kernel contexts, the rest are user/netdev contexts */
@@ -14340,15 +14345,15 @@ static void clear_rsm_rule(struct hfi1_devdata *dd, u8 rule_index)
 }
 
 /* return the number of RSM map table entries that will be used for QOS */
-static int qos_rmt_entries(struct hfi1_devdata *dd, unsigned int *mp,
+static int qos_rmt_entries(unsigned int n_krcv_queues, unsigned int *mp,
 			   unsigned int *np)
 {
 	int i;
 	unsigned int m, n;
-	u8 max_by_vl = 0;
+	uint max_by_vl = 0;
 
 	/* is QOS active at all? */
-	if (dd->n_krcv_queues <= MIN_KERNEL_KCTXTS ||
+	if (n_krcv_queues < MIN_KERNEL_KCTXTS ||
 	    num_vls == 1 ||
 	    krcvqsset <= 1)
 		goto no_qos;
@@ -14406,7 +14411,7 @@ static void init_qos(struct hfi1_devdata *dd, struct rsm_map_table *rmt)
 
 	if (!rmt)
 		goto bail;
-	rmt_entries = qos_rmt_entries(dd, &m, &n);
+	rmt_entries = qos_rmt_entries(dd->n_krcv_queues - 1, &m, &n);
 	if (rmt_entries == 0)
 		goto bail;
 	qpns_per_vl = 1 << m;
diff --git a/drivers/input/misc/iqs269a.c b/drivers/input/misc/iqs269a.c
index a348247d3d38..8b30c911f789 100644
--- a/drivers/input/misc/iqs269a.c
+++ b/drivers/input/misc/iqs269a.c
@@ -9,6 +9,7 @@
  * axial sliders presented by the device.
  */
 
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
@@ -96,8 +97,6 @@
 #define IQS269_MISC_B_TRACKING_UI_ENABLE	BIT(4)
 #define IQS269_MISC_B_FILT_STR_SLIDER		GENMASK(1, 0)
 
-#define IQS269_CHx_SETTINGS			0x8C
-
 #define IQS269_CHx_ENG_A_MEAS_CAP_SIZE		BIT(15)
 #define IQS269_CHx_ENG_A_RX_GND_INACTIVE	BIT(13)
 #define IQS269_CHx_ENG_A_LOCAL_CAP_SIZE		BIT(12)
@@ -146,14 +145,7 @@
 #define IQS269_NUM_CH				8
 #define IQS269_NUM_SL				2
 
-#define IQS269_ATI_POLL_SLEEP_US		(iqs269->delay_mult * 10000)
-#define IQS269_ATI_POLL_TIMEOUT_US		(iqs269->delay_mult * 500000)
-#define IQS269_ATI_STABLE_DELAY_MS		(iqs269->delay_mult * 150)
-
-#define IQS269_PWR_MODE_POLL_SLEEP_US		IQS269_ATI_POLL_SLEEP_US
-#define IQS269_PWR_MODE_POLL_TIMEOUT_US		IQS269_ATI_POLL_TIMEOUT_US
-
-#define iqs269_irq_wait()			usleep_range(100, 150)
+#define iqs269_irq_wait()			usleep_range(200, 250)
 
 enum iqs269_local_cap_size {
 	IQS269_LOCAL_CAP_SIZE_0,
@@ -245,6 +237,18 @@ struct iqs269_ver_info {
 	u8 padding;
 } __packed;
 
+struct iqs269_ch_reg {
+	u8 rx_enable;
+	u8 tx_enable;
+	__be16 engine_a;
+	__be16 engine_b;
+	__be16 ati_comp;
+	u8 thresh[3];
+	u8 hyst;
+	u8 assoc_select;
+	u8 assoc_weight;
+} __packed;
+
 struct iqs269_sys_reg {
 	__be16 general;
 	u8 active;
@@ -266,18 +270,7 @@ struct iqs269_sys_reg {
 	u8 timeout_swipe;
 	u8 thresh_swipe;
 	u8 redo_ati;
-} __packed;
-
-struct iqs269_ch_reg {
-	u8 rx_enable;
-	u8 tx_enable;
-	__be16 engine_a;
-	__be16 engine_b;
-	__be16 ati_comp;
-	u8 thresh[3];
-	u8 hyst;
-	u8 assoc_select;
-	u8 assoc_weight;
+	struct iqs269_ch_reg ch_reg[IQS269_NUM_CH];
 } __packed;
 
 struct iqs269_flags {
@@ -292,13 +285,11 @@ struct iqs269_private {
 	struct regmap *regmap;
 	struct mutex lock;
 	struct iqs269_switch_desc switches[ARRAY_SIZE(iqs269_events)];
-	struct iqs269_ch_reg ch_reg[IQS269_NUM_CH];
 	struct iqs269_sys_reg sys_reg;
+	struct completion ati_done;
 	struct input_dev *keypad;
 	struct input_dev *slider[IQS269_NUM_SL];
 	unsigned int keycode[ARRAY_SIZE(iqs269_events) * IQS269_NUM_CH];
-	unsigned int suspend_mode;
-	unsigned int delay_mult;
 	unsigned int ch_num;
 	bool hall_enable;
 	bool ati_current;
@@ -307,6 +298,7 @@ struct iqs269_private {
 static int iqs269_ati_mode_set(struct iqs269_private *iqs269,
 			       unsigned int ch_num, unsigned int mode)
 {
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	u16 engine_a;
 
 	if (ch_num >= IQS269_NUM_CH)
@@ -317,12 +309,12 @@ static int iqs269_ati_mode_set(struct iqs269_private *iqs269,
 
 	mutex_lock(&iqs269->lock);
 
-	engine_a = be16_to_cpu(iqs269->ch_reg[ch_num].engine_a);
+	engine_a = be16_to_cpu(ch_reg[ch_num].engine_a);
 
 	engine_a &= ~IQS269_CHx_ENG_A_ATI_MODE_MASK;
 	engine_a |= (mode << IQS269_CHx_ENG_A_ATI_MODE_SHIFT);
 
-	iqs269->ch_reg[ch_num].engine_a = cpu_to_be16(engine_a);
+	ch_reg[ch_num].engine_a = cpu_to_be16(engine_a);
 	iqs269->ati_current = false;
 
 	mutex_unlock(&iqs269->lock);
@@ -333,13 +325,14 @@ static int iqs269_ati_mode_set(struct iqs269_private *iqs269,
 static int iqs269_ati_mode_get(struct iqs269_private *iqs269,
 			       unsigned int ch_num, unsigned int *mode)
 {
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	u16 engine_a;
 
 	if (ch_num >= IQS269_NUM_CH)
 		return -EINVAL;
 
 	mutex_lock(&iqs269->lock);
-	engine_a = be16_to_cpu(iqs269->ch_reg[ch_num].engine_a);
+	engine_a = be16_to_cpu(ch_reg[ch_num].engine_a);
 	mutex_unlock(&iqs269->lock);
 
 	engine_a &= IQS269_CHx_ENG_A_ATI_MODE_MASK;
@@ -351,6 +344,7 @@ static int iqs269_ati_mode_get(struct iqs269_private *iqs269,
 static int iqs269_ati_base_set(struct iqs269_private *iqs269,
 			       unsigned int ch_num, unsigned int base)
 {
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	u16 engine_b;
 
 	if (ch_num >= IQS269_NUM_CH)
@@ -379,12 +373,12 @@ static int iqs269_ati_base_set(struct iqs269_private *iqs269,
 
 	mutex_lock(&iqs269->lock);
 
-	engine_b = be16_to_cpu(iqs269->ch_reg[ch_num].engine_b);
+	engine_b = be16_to_cpu(ch_reg[ch_num].engine_b);
 
 	engine_b &= ~IQS269_CHx_ENG_B_ATI_BASE_MASK;
 	engine_b |= base;
 
-	iqs269->ch_reg[ch_num].engine_b = cpu_to_be16(engine_b);
+	ch_reg[ch_num].engine_b = cpu_to_be16(engine_b);
 	iqs269->ati_current = false;
 
 	mutex_unlock(&iqs269->lock);
@@ -395,13 +389,14 @@ static int iqs269_ati_base_set(struct iqs269_private *iqs269,
 static int iqs269_ati_base_get(struct iqs269_private *iqs269,
 			       unsigned int ch_num, unsigned int *base)
 {
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	u16 engine_b;
 
 	if (ch_num >= IQS269_NUM_CH)
 		return -EINVAL;
 
 	mutex_lock(&iqs269->lock);
-	engine_b = be16_to_cpu(iqs269->ch_reg[ch_num].engine_b);
+	engine_b = be16_to_cpu(ch_reg[ch_num].engine_b);
 	mutex_unlock(&iqs269->lock);
 
 	switch (engine_b & IQS269_CHx_ENG_B_ATI_BASE_MASK) {
@@ -429,6 +424,7 @@ static int iqs269_ati_base_get(struct iqs269_private *iqs269,
 static int iqs269_ati_target_set(struct iqs269_private *iqs269,
 				 unsigned int ch_num, unsigned int target)
 {
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	u16 engine_b;
 
 	if (ch_num >= IQS269_NUM_CH)
@@ -439,12 +435,12 @@ static int iqs269_ati_target_set(struct iqs269_private *iqs269,
 
 	mutex_lock(&iqs269->lock);
 
-	engine_b = be16_to_cpu(iqs269->ch_reg[ch_num].engine_b);
+	engine_b = be16_to_cpu(ch_reg[ch_num].engine_b);
 
 	engine_b &= ~IQS269_CHx_ENG_B_ATI_TARGET_MASK;
 	engine_b |= target / 32;
 
-	iqs269->ch_reg[ch_num].engine_b = cpu_to_be16(engine_b);
+	ch_reg[ch_num].engine_b = cpu_to_be16(engine_b);
 	iqs269->ati_current = false;
 
 	mutex_unlock(&iqs269->lock);
@@ -455,13 +451,14 @@ static int iqs269_ati_target_set(struct iqs269_private *iqs269,
 static int iqs269_ati_target_get(struct iqs269_private *iqs269,
 				 unsigned int ch_num, unsigned int *target)
 {
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	u16 engine_b;
 
 	if (ch_num >= IQS269_NUM_CH)
 		return -EINVAL;
 
 	mutex_lock(&iqs269->lock);
-	engine_b = be16_to_cpu(iqs269->ch_reg[ch_num].engine_b);
+	engine_b = be16_to_cpu(ch_reg[ch_num].engine_b);
 	mutex_unlock(&iqs269->lock);
 
 	*target = (engine_b & IQS269_CHx_ENG_B_ATI_TARGET_MASK) * 32;
@@ -531,13 +528,7 @@ static int iqs269_parse_chan(struct iqs269_private *iqs269,
 	if (fwnode_property_present(ch_node, "azoteq,slider1-select"))
 		iqs269->sys_reg.slider_select[1] |= BIT(reg);
 
-	ch_reg = &iqs269->ch_reg[reg];
-
-	error = regmap_raw_read(iqs269->regmap,
-				IQS269_CHx_SETTINGS + reg * sizeof(*ch_reg) / 2,
-				ch_reg, sizeof(*ch_reg));
-	if (error)
-		return error;
+	ch_reg = &iqs269->sys_reg.ch_reg[reg];
 
 	error = iqs269_parse_mask(ch_node, "azoteq,rx-enable",
 				  &ch_reg->rx_enable);
@@ -694,6 +685,7 @@ static int iqs269_parse_chan(struct iqs269_private *iqs269,
 				dev_err(&client->dev,
 					"Invalid channel %u threshold: %u\n",
 					reg, val);
+				fwnode_handle_put(ev_node);
 				return -EINVAL;
 			}
 
@@ -707,6 +699,7 @@ static int iqs269_parse_chan(struct iqs269_private *iqs269,
 				dev_err(&client->dev,
 					"Invalid channel %u hysteresis: %u\n",
 					reg, val);
+				fwnode_handle_put(ev_node);
 				return -EINVAL;
 			}
 
@@ -721,8 +714,16 @@ static int iqs269_parse_chan(struct iqs269_private *iqs269,
 			}
 		}
 
-		if (fwnode_property_read_u32(ev_node, "linux,code", &val))
+		error = fwnode_property_read_u32(ev_node, "linux,code", &val);
+		fwnode_handle_put(ev_node);
+		if (error == -EINVAL) {
 			continue;
+		} else if (error) {
+			dev_err(&client->dev,
+				"Failed to read channel %u code: %d\n", reg,
+				error);
+			return error;
+		}
 
 		switch (reg) {
 		case IQS269_CHx_HALL_ACTIVE:
@@ -759,17 +760,6 @@ static int iqs269_parse_prop(struct iqs269_private *iqs269)
 	iqs269->hall_enable = device_property_present(&client->dev,
 						      "azoteq,hall-enable");
 
-	if (!device_property_read_u32(&client->dev, "azoteq,suspend-mode",
-				      &val)) {
-		if (val > IQS269_SYS_SETTINGS_PWR_MODE_MAX) {
-			dev_err(&client->dev, "Invalid suspend mode: %u\n",
-				val);
-			return -EINVAL;
-		}
-
-		iqs269->suspend_mode = val;
-	}
-
 	error = regmap_raw_read(iqs269->regmap, IQS269_SYS_SETTINGS, sys_reg,
 				sizeof(*sys_reg));
 	if (error)
@@ -980,13 +970,8 @@ static int iqs269_parse_prop(struct iqs269_private *iqs269)
 
 	general = be16_to_cpu(sys_reg->general);
 
-	if (device_property_present(&client->dev, "azoteq,clk-div")) {
+	if (device_property_present(&client->dev, "azoteq,clk-div"))
 		general |= IQS269_SYS_SETTINGS_CLK_DIV;
-		iqs269->delay_mult = 4;
-	} else {
-		general &= ~IQS269_SYS_SETTINGS_CLK_DIV;
-		iqs269->delay_mult = 1;
-	}
 
 	/*
 	 * Configure the device to automatically switch between normal and low-
@@ -997,6 +982,17 @@ static int iqs269_parse_prop(struct iqs269_private *iqs269)
 	general &= ~IQS269_SYS_SETTINGS_DIS_AUTO;
 	general &= ~IQS269_SYS_SETTINGS_PWR_MODE_MASK;
 
+	if (!device_property_read_u32(&client->dev, "azoteq,suspend-mode",
+				      &val)) {
+		if (val > IQS269_SYS_SETTINGS_PWR_MODE_MAX) {
+			dev_err(&client->dev, "Invalid suspend mode: %u\n",
+				val);
+			return -EINVAL;
+		}
+
+		general |= (val << IQS269_SYS_SETTINGS_PWR_MODE_SHIFT);
+	}
+
 	if (!device_property_read_u32(&client->dev, "azoteq,ulp-update",
 				      &val)) {
 		if (val > IQS269_SYS_SETTINGS_ULP_UPDATE_MAX) {
@@ -1032,10 +1028,7 @@ static int iqs269_parse_prop(struct iqs269_private *iqs269)
 
 static int iqs269_dev_init(struct iqs269_private *iqs269)
 {
-	struct iqs269_sys_reg *sys_reg = &iqs269->sys_reg;
-	struct iqs269_ch_reg *ch_reg;
-	unsigned int val;
-	int error, i;
+	int error;
 
 	mutex_lock(&iqs269->lock);
 
@@ -1045,38 +1038,17 @@ static int iqs269_dev_init(struct iqs269_private *iqs269)
 	if (error)
 		goto err_mutex;
 
-	for (i = 0; i < IQS269_NUM_CH; i++) {
-		if (!(sys_reg->active & BIT(i)))
-			continue;
-
-		ch_reg = &iqs269->ch_reg[i];
-
-		error = regmap_raw_write(iqs269->regmap,
-					 IQS269_CHx_SETTINGS + i *
-					 sizeof(*ch_reg) / 2, ch_reg,
-					 sizeof(*ch_reg));
-		if (error)
-			goto err_mutex;
-	}
-
-	/*
-	 * The REDO-ATI and ATI channel selection fields must be written in the
-	 * same block write, so every field between registers 0x80 through 0x8B
-	 * (inclusive) must be written as well.
-	 */
-	error = regmap_raw_write(iqs269->regmap, IQS269_SYS_SETTINGS, sys_reg,
-				 sizeof(*sys_reg));
+	error = regmap_raw_write(iqs269->regmap, IQS269_SYS_SETTINGS,
+				 &iqs269->sys_reg, sizeof(iqs269->sys_reg));
 	if (error)
 		goto err_mutex;
 
-	error = regmap_read_poll_timeout(iqs269->regmap, IQS269_SYS_FLAGS, val,
-					!(val & IQS269_SYS_FLAGS_IN_ATI),
-					 IQS269_ATI_POLL_SLEEP_US,
-					 IQS269_ATI_POLL_TIMEOUT_US);
-	if (error)
-		goto err_mutex;
+	/*
+	 * The following delay gives the device time to deassert its RDY output
+	 * so as to prevent an interrupt from being serviced prematurely.
+	 */
+	usleep_range(2000, 2100);
 
-	msleep(IQS269_ATI_STABLE_DELAY_MS);
 	iqs269->ati_current = true;
 
 err_mutex:
@@ -1088,10 +1060,8 @@ static int iqs269_dev_init(struct iqs269_private *iqs269)
 static int iqs269_input_init(struct iqs269_private *iqs269)
 {
 	struct i2c_client *client = iqs269->client;
-	struct iqs269_flags flags;
 	unsigned int sw_code, keycode;
 	int error, i, j;
-	u8 dir_mask, state;
 
 	iqs269->keypad = devm_input_allocate_device(&client->dev);
 	if (!iqs269->keypad)
@@ -1104,23 +1074,7 @@ static int iqs269_input_init(struct iqs269_private *iqs269)
 	iqs269->keypad->name = "iqs269a_keypad";
 	iqs269->keypad->id.bustype = BUS_I2C;
 
-	if (iqs269->hall_enable) {
-		error = regmap_raw_read(iqs269->regmap, IQS269_SYS_FLAGS,
-					&flags, sizeof(flags));
-		if (error) {
-			dev_err(&client->dev,
-				"Failed to read initial status: %d\n", error);
-			return error;
-		}
-	}
-
 	for (i = 0; i < ARRAY_SIZE(iqs269_events); i++) {
-		dir_mask = flags.states[IQS269_ST_OFFS_DIR];
-		if (!iqs269_events[i].dir_up)
-			dir_mask = ~dir_mask;
-
-		state = flags.states[iqs269_events[i].st_offs] & dir_mask;
-
 		sw_code = iqs269->switches[i].code;
 
 		for (j = 0; j < IQS269_NUM_CH; j++) {
@@ -1133,13 +1087,9 @@ static int iqs269_input_init(struct iqs269_private *iqs269)
 			switch (j) {
 			case IQS269_CHx_HALL_ACTIVE:
 				if (iqs269->hall_enable &&
-				    iqs269->switches[i].enabled) {
+				    iqs269->switches[i].enabled)
 					input_set_capability(iqs269->keypad,
 							     EV_SW, sw_code);
-					input_report_switch(iqs269->keypad,
-							    sw_code,
-							    state & BIT(j));
-				}
 				fallthrough;
 
 			case IQS269_CHx_HALL_INACTIVE:
@@ -1155,14 +1105,6 @@ static int iqs269_input_init(struct iqs269_private *iqs269)
 		}
 	}
 
-	input_sync(iqs269->keypad);
-
-	error = input_register_device(iqs269->keypad);
-	if (error) {
-		dev_err(&client->dev, "Failed to register keypad: %d\n", error);
-		return error;
-	}
-
 	for (i = 0; i < IQS269_NUM_SL; i++) {
 		if (!iqs269->sys_reg.slider_select[i])
 			continue;
@@ -1222,6 +1164,9 @@ static int iqs269_report(struct iqs269_private *iqs269)
 		return error;
 	}
 
+	if (be16_to_cpu(flags.system) & IQS269_SYS_FLAGS_IN_ATI)
+		return 0;
+
 	error = regmap_raw_read(iqs269->regmap, IQS269_SLIDER_X, slider_x,
 				sizeof(slider_x));
 	if (error) {
@@ -1284,6 +1229,12 @@ static int iqs269_report(struct iqs269_private *iqs269)
 
 	input_sync(iqs269->keypad);
 
+	/*
+	 * The following completion signals that ATI has finished, any initial
+	 * switch states have been reported and the keypad can be registered.
+	 */
+	complete_all(&iqs269->ati_done);
+
 	return 0;
 }
 
@@ -1315,6 +1266,9 @@ static ssize_t counts_show(struct device *dev,
 	if (!iqs269->ati_current || iqs269->hall_enable)
 		return -EPERM;
 
+	if (!completion_done(&iqs269->ati_done))
+		return -EBUSY;
+
 	/*
 	 * Unsolicited I2C communication prompts the device to assert its RDY
 	 * pin, so disable the interrupt line until the operation is finished
@@ -1339,6 +1293,7 @@ static ssize_t hall_bin_show(struct device *dev,
 			     struct device_attribute *attr, char *buf)
 {
 	struct iqs269_private *iqs269 = dev_get_drvdata(dev);
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	struct i2c_client *client = iqs269->client;
 	unsigned int val;
 	int error;
@@ -1353,8 +1308,8 @@ static ssize_t hall_bin_show(struct device *dev,
 	if (error)
 		return error;
 
-	switch (iqs269->ch_reg[IQS269_CHx_HALL_ACTIVE].rx_enable &
-		iqs269->ch_reg[IQS269_CHx_HALL_INACTIVE].rx_enable) {
+	switch (ch_reg[IQS269_CHx_HALL_ACTIVE].rx_enable &
+		ch_reg[IQS269_CHx_HALL_INACTIVE].rx_enable) {
 	case IQS269_HALL_PAD_R:
 		val &= IQS269_CAL_DATA_A_HALL_BIN_R_MASK;
 		val >>= IQS269_CAL_DATA_A_HALL_BIN_R_SHIFT;
@@ -1434,9 +1389,10 @@ static ssize_t rx_enable_show(struct device *dev,
 			      struct device_attribute *attr, char *buf)
 {
 	struct iqs269_private *iqs269 = dev_get_drvdata(dev);
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 
 	return scnprintf(buf, PAGE_SIZE, "%u\n",
-			 iqs269->ch_reg[iqs269->ch_num].rx_enable);
+			 ch_reg[iqs269->ch_num].rx_enable);
 }
 
 static ssize_t rx_enable_store(struct device *dev,
@@ -1444,6 +1400,7 @@ static ssize_t rx_enable_store(struct device *dev,
 			       size_t count)
 {
 	struct iqs269_private *iqs269 = dev_get_drvdata(dev);
+	struct iqs269_ch_reg *ch_reg = iqs269->sys_reg.ch_reg;
 	unsigned int val;
 	int error;
 
@@ -1456,7 +1413,7 @@ static ssize_t rx_enable_store(struct device *dev,
 
 	mutex_lock(&iqs269->lock);
 
-	iqs269->ch_reg[iqs269->ch_num].rx_enable = val;
+	ch_reg[iqs269->ch_num].rx_enable = val;
 	iqs269->ati_current = false;
 
 	mutex_unlock(&iqs269->lock);
@@ -1568,7 +1525,9 @@ static ssize_t ati_trigger_show(struct device *dev,
 {
 	struct iqs269_private *iqs269 = dev_get_drvdata(dev);
 
-	return scnprintf(buf, PAGE_SIZE, "%u\n", iqs269->ati_current);
+	return scnprintf(buf, PAGE_SIZE, "%u\n",
+			 iqs269->ati_current &&
+			 completion_done(&iqs269->ati_done));
 }
 
 static ssize_t ati_trigger_store(struct device *dev,
@@ -1588,6 +1547,7 @@ static ssize_t ati_trigger_store(struct device *dev,
 		return count;
 
 	disable_irq(client->irq);
+	reinit_completion(&iqs269->ati_done);
 
 	error = iqs269_dev_init(iqs269);
 
@@ -1597,6 +1557,10 @@ static ssize_t ati_trigger_store(struct device *dev,
 	if (error)
 		return error;
 
+	if (!wait_for_completion_timeout(&iqs269->ati_done,
+					 msecs_to_jiffies(2000)))
+		return -ETIMEDOUT;
+
 	return count;
 }
 
@@ -1655,6 +1619,7 @@ static int iqs269_probe(struct i2c_client *client)
 	}
 
 	mutex_init(&iqs269->lock);
+	init_completion(&iqs269->ati_done);
 
 	error = regmap_raw_read(iqs269->regmap, IQS269_VER_INFO, &ver_info,
 				sizeof(ver_info));
@@ -1690,6 +1655,22 @@ static int iqs269_probe(struct i2c_client *client)
 		return error;
 	}
 
+	if (!wait_for_completion_timeout(&iqs269->ati_done,
+					 msecs_to_jiffies(2000))) {
+		dev_err(&client->dev, "Failed to complete ATI\n");
+		return -ETIMEDOUT;
+	}
+
+	/*
+	 * The keypad may include one or more switches and is not registered
+	 * until ATI is complete and the initial switch states are read.
+	 */
+	error = input_register_device(iqs269->keypad);
+	if (error) {
+		dev_err(&client->dev, "Failed to register keypad: %d\n", error);
+		return error;
+	}
+
 	error = devm_device_add_group(&client->dev, &iqs269_attr_group);
 	if (error)
 		dev_err(&client->dev, "Failed to add attributes: %d\n", error);
@@ -1697,59 +1678,30 @@ static int iqs269_probe(struct i2c_client *client)
 	return error;
 }
 
+static u16 iqs269_general_get(struct iqs269_private *iqs269)
+{
+	u16 general = be16_to_cpu(iqs269->sys_reg.general);
+
+	general &= ~IQS269_SYS_SETTINGS_REDO_ATI;
+	general &= ~IQS269_SYS_SETTINGS_ACK_RESET;
+
+	return general | IQS269_SYS_SETTINGS_DIS_AUTO;
+}
+
 static int __maybe_unused iqs269_suspend(struct device *dev)
 {
 	struct iqs269_private *iqs269 = dev_get_drvdata(dev);
 	struct i2c_client *client = iqs269->client;
-	unsigned int val;
 	int error;
+	u16 general = iqs269_general_get(iqs269);
 
-	if (!iqs269->suspend_mode)
+	if (!(general & IQS269_SYS_SETTINGS_PWR_MODE_MASK))
 		return 0;
 
 	disable_irq(client->irq);
 
-	/*
-	 * Automatic power mode switching must be disabled before the device is
-	 * forced into any particular power mode. In this case, the device will
-	 * transition into normal-power mode.
-	 */
-	error = regmap_update_bits(iqs269->regmap, IQS269_SYS_SETTINGS,
-				   IQS269_SYS_SETTINGS_DIS_AUTO, ~0);
-	if (error)
-		goto err_irq;
-
-	/*
-	 * The following check ensures the device has completed its transition
-	 * into normal-power mode before a manual mode switch is performed.
-	 */
-	error = regmap_read_poll_timeout(iqs269->regmap, IQS269_SYS_FLAGS, val,
-					!(val & IQS269_SYS_FLAGS_PWR_MODE_MASK),
-					 IQS269_PWR_MODE_POLL_SLEEP_US,
-					 IQS269_PWR_MODE_POLL_TIMEOUT_US);
-	if (error)
-		goto err_irq;
-
-	error = regmap_update_bits(iqs269->regmap, IQS269_SYS_SETTINGS,
-				   IQS269_SYS_SETTINGS_PWR_MODE_MASK,
-				   iqs269->suspend_mode <<
-				   IQS269_SYS_SETTINGS_PWR_MODE_SHIFT);
-	if (error)
-		goto err_irq;
+	error = regmap_write(iqs269->regmap, IQS269_SYS_SETTINGS, general);
 
-	/*
-	 * This last check ensures the device has completed its transition into
-	 * the desired power mode to prevent any spurious interrupts from being
-	 * triggered after iqs269_suspend has already returned.
-	 */
-	error = regmap_read_poll_timeout(iqs269->regmap, IQS269_SYS_FLAGS, val,
-					 (val & IQS269_SYS_FLAGS_PWR_MODE_MASK)
-					 == (iqs269->suspend_mode <<
-					     IQS269_SYS_FLAGS_PWR_MODE_SHIFT),
-					 IQS269_PWR_MODE_POLL_SLEEP_US,
-					 IQS269_PWR_MODE_POLL_TIMEOUT_US);
-
-err_irq:
 	iqs269_irq_wait();
 	enable_irq(client->irq);
 
@@ -1760,43 +1712,20 @@ static int __maybe_unused iqs269_resume(struct device *dev)
 {
 	struct iqs269_private *iqs269 = dev_get_drvdata(dev);
 	struct i2c_client *client = iqs269->client;
-	unsigned int val;
 	int error;
+	u16 general = iqs269_general_get(iqs269);
 
-	if (!iqs269->suspend_mode)
+	if (!(general & IQS269_SYS_SETTINGS_PWR_MODE_MASK))
 		return 0;
 
 	disable_irq(client->irq);
 
-	error = regmap_update_bits(iqs269->regmap, IQS269_SYS_SETTINGS,
-				   IQS269_SYS_SETTINGS_PWR_MODE_MASK, 0);
-	if (error)
-		goto err_irq;
-
-	/*
-	 * This check ensures the device has returned to normal-power mode
-	 * before automatic power mode switching is re-enabled.
-	 */
-	error = regmap_read_poll_timeout(iqs269->regmap, IQS269_SYS_FLAGS, val,
-					!(val & IQS269_SYS_FLAGS_PWR_MODE_MASK),
-					 IQS269_PWR_MODE_POLL_SLEEP_US,
-					 IQS269_PWR_MODE_POLL_TIMEOUT_US);
-	if (error)
-		goto err_irq;
-
-	error = regmap_update_bits(iqs269->regmap, IQS269_SYS_SETTINGS,
-				   IQS269_SYS_SETTINGS_DIS_AUTO, 0);
-	if (error)
-		goto err_irq;
-
-	/*
-	 * This step reports any events that may have been "swallowed" as a
-	 * result of polling PWR_MODE (which automatically acknowledges any
-	 * pending interrupts).
-	 */
-	error = iqs269_report(iqs269);
+	error = regmap_write(iqs269->regmap, IQS269_SYS_SETTINGS,
+			     general & ~IQS269_SYS_SETTINGS_PWR_MODE_MASK);
+	if (!error)
+		error = regmap_write(iqs269->regmap, IQS269_SYS_SETTINGS,
+				     general & ~IQS269_SYS_SETTINGS_DIS_AUTO);
 
-err_irq:
 	iqs269_irq_wait();
 	enable_irq(client->irq);
 
diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index ff97897feaf2..1753288cedde 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -63,19 +63,15 @@
 /* this driver doesn't aim at the peak continuous sample rate */
 #define	SAMPLE_BITS	(8 /*cmd*/ + 16 /*sample*/ + 2 /* before, after */)
 
-struct ts_event {
-	/*
-	 * For portability, we can't read 12 bit values using SPI (which
-	 * would make the controller deliver them as native byte order u16
-	 * with msbs zeroed).  Instead, we read them as two 8-bit values,
-	 * *** WHICH NEED BYTESWAPPING *** and range adjustment.
-	 */
-	u16	x;
-	u16	y;
-	u16	z1, z2;
-	bool	ignore;
-	u8	x_buf[3];
-	u8	y_buf[3];
+struct ads7846_buf {
+	u8 cmd;
+	__be16 data;
+} __packed;
+
+struct ads7846_buf_layout {
+	unsigned int offset;
+	unsigned int count;
+	unsigned int skip;
 };
 
 /*
@@ -84,11 +80,18 @@ struct ts_event {
  * systems where main memory is not DMA-coherent (most non-x86 boards).
  */
 struct ads7846_packet {
-	u8			read_x, read_y, read_z1, read_z2, pwrdown;
-	u16			dummy;		/* for the pwrdown read */
-	struct ts_event		tc;
-	/* for ads7845 with mpc5121 psc spi we use 3-byte buffers */
-	u8			read_x_cmd[3], read_y_cmd[3], pwrdown_cmd[3];
+	unsigned int count;
+	unsigned int count_skip;
+	unsigned int cmds;
+	unsigned int last_cmd_idx;
+	struct ads7846_buf_layout l[5];
+	struct ads7846_buf *rx;
+	struct ads7846_buf *tx;
+
+	struct ads7846_buf pwrdown_cmd;
+
+	bool ignore;
+	u16 x, y, z1, z2;
 };
 
 struct ads7846 {
@@ -187,7 +190,6 @@ struct ads7846 {
 #define	READ_Y(vref)	(READ_12BIT_DFR(y,  1, vref))
 #define	READ_Z1(vref)	(READ_12BIT_DFR(z1, 1, vref))
 #define	READ_Z2(vref)	(READ_12BIT_DFR(z2, 1, vref))
-
 #define	READ_X(vref)	(READ_12BIT_DFR(x,  1, vref))
 #define	PWRDOWN		(READ_12BIT_DFR(y,  0, 0))	/* LAST */
 
@@ -200,6 +202,21 @@ struct ads7846 {
 #define	REF_ON	(READ_12BIT_DFR(x, 1, 1))
 #define	REF_OFF	(READ_12BIT_DFR(y, 0, 0))
 
+/* Order commands in the most optimal way to reduce Vref switching and
+ * settling time:
+ * Measure:  X; Vref: X+, X-; IN: Y+
+ * Measure:  Y; Vref: Y+, Y-; IN: X+
+ * Measure: Z1; Vref: Y+, X-; IN: X+
+ * Measure: Z2; Vref: Y+, X-; IN: Y-
+ */
+enum ads7846_cmds {
+	ADS7846_X,
+	ADS7846_Y,
+	ADS7846_Z1,
+	ADS7846_Z2,
+	ADS7846_PWDOWN,
+};
+
 static int get_pendown_state(struct ads7846 *ts)
 {
 	if (ts->get_pendown_state)
@@ -682,32 +699,109 @@ static int ads7846_no_filter(void *ads, int data_idx, int *val)
 	return ADS7846_FILTER_OK;
 }
 
-static int ads7846_get_value(struct ads7846 *ts, struct spi_message *m)
+static int ads7846_get_value(struct ads7846_buf *buf)
 {
 	int value;
-	struct spi_transfer *t =
-		list_entry(m->transfers.prev, struct spi_transfer, transfer_list);
 
-	if (ts->model == 7845) {
-		value = be16_to_cpup((__be16 *)&(((char *)t->rx_buf)[1]));
-	} else {
-		/*
-		 * adjust:  on-wire is a must-ignore bit, a BE12 value, then
-		 * padding; built from two 8 bit values written msb-first.
-		 */
-		value = be16_to_cpup((__be16 *)t->rx_buf);
-	}
+	value = be16_to_cpup(&buf->data);
 
 	/* enforce ADC output is 12 bits width */
 	return (value >> 3) & 0xfff;
 }
 
-static void ads7846_update_value(struct spi_message *m, int val)
+static void ads7846_set_cmd_val(struct ads7846 *ts, enum ads7846_cmds cmd_idx,
+				u16 val)
 {
-	struct spi_transfer *t =
-		list_entry(m->transfers.prev, struct spi_transfer, transfer_list);
+	struct ads7846_packet *packet = ts->packet;
+
+	switch (cmd_idx) {
+	case ADS7846_Y:
+		packet->y = val;
+		break;
+	case ADS7846_X:
+		packet->x = val;
+		break;
+	case ADS7846_Z1:
+		packet->z1 = val;
+		break;
+	case ADS7846_Z2:
+		packet->z2 = val;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+}
+
+static u8 ads7846_get_cmd(enum ads7846_cmds cmd_idx, int vref)
+{
+	switch (cmd_idx) {
+	case ADS7846_Y:
+		return READ_Y(vref);
+	case ADS7846_X:
+		return READ_X(vref);
+
+	/* 7846 specific commands  */
+	case ADS7846_Z1:
+		return READ_Z1(vref);
+	case ADS7846_Z2:
+		return READ_Z2(vref);
+	case ADS7846_PWDOWN:
+		return PWRDOWN;
+	default:
+		WARN_ON_ONCE(1);
+	}
 
-	*(u16 *)t->rx_buf = val;
+	return 0;
+}
+
+static bool ads7846_cmd_need_settle(enum ads7846_cmds cmd_idx)
+{
+	switch (cmd_idx) {
+	case ADS7846_X:
+	case ADS7846_Y:
+	case ADS7846_Z1:
+	case ADS7846_Z2:
+		return true;
+	case ADS7846_PWDOWN:
+		return false;
+	default:
+		WARN_ON_ONCE(1);
+	}
+
+	return false;
+}
+
+static int ads7846_filter(struct ads7846 *ts)
+{
+	struct ads7846_packet *packet = ts->packet;
+	int action;
+	int val;
+	unsigned int cmd_idx, b;
+
+	packet->ignore = false;
+	for (cmd_idx = packet->last_cmd_idx; cmd_idx < packet->cmds - 1; cmd_idx++) {
+		struct ads7846_buf_layout *l = &packet->l[cmd_idx];
+
+		packet->last_cmd_idx = cmd_idx;
+
+		for (b = l->skip; b < l->count; b++) {
+			val = ads7846_get_value(&packet->rx[l->offset + b]);
+
+			action = ts->filter(ts->filter_data, cmd_idx, &val);
+			if (action == ADS7846_FILTER_REPEAT) {
+				if (b == l->count - 1)
+					return -EAGAIN;
+			} else if (action == ADS7846_FILTER_OK) {
+				ads7846_set_cmd_val(ts, cmd_idx, val);
+				break;
+			} else {
+				packet->ignore = true;
+				return 0;
+			}
+		}
+	}
+
+	return 0;
 }
 
 static void ads7846_read_state(struct ads7846 *ts)
@@ -715,52 +809,26 @@ static void ads7846_read_state(struct ads7846 *ts)
 	struct ads7846_packet *packet = ts->packet;
 	struct spi_message *m;
 	int msg_idx = 0;
-	int val;
-	int action;
 	int error;
 
-	while (msg_idx < ts->msg_count) {
+	packet->last_cmd_idx = 0;
 
+	while (true) {
 		ts->wait_for_sync();
 
 		m = &ts->msg[msg_idx];
 		error = spi_sync(ts->spi, m);
 		if (error) {
 			dev_err(&ts->spi->dev, "spi_sync --> %d\n", error);
-			packet->tc.ignore = true;
+			packet->ignore = true;
 			return;
 		}
 
-		/*
-		 * Last message is power down request, no need to convert
-		 * or filter the value.
-		 */
-		if (msg_idx < ts->msg_count - 1) {
-
-			val = ads7846_get_value(ts, m);
+		error = ads7846_filter(ts);
+		if (error)
+			continue;
 
-			action = ts->filter(ts->filter_data, msg_idx, &val);
-			switch (action) {
-			case ADS7846_FILTER_REPEAT:
-				continue;
-
-			case ADS7846_FILTER_IGNORE:
-				packet->tc.ignore = true;
-				msg_idx = ts->msg_count - 1;
-				continue;
-
-			case ADS7846_FILTER_OK:
-				ads7846_update_value(m, val);
-				packet->tc.ignore = false;
-				msg_idx++;
-				break;
-
-			default:
-				BUG();
-			}
-		} else {
-			msg_idx++;
-		}
+		return;
 	}
 }
 
@@ -770,35 +838,22 @@ static void ads7846_report_state(struct ads7846 *ts)
 	unsigned int Rt;
 	u16 x, y, z1, z2;
 
-	/*
-	 * ads7846_get_value() does in-place conversion (including byte swap)
-	 * from on-the-wire format as part of debouncing to get stable
-	 * readings.
-	 */
+	x = packet->x;
+	y = packet->y;
 	if (ts->model == 7845) {
-		x = *(u16 *)packet->tc.x_buf;
-		y = *(u16 *)packet->tc.y_buf;
 		z1 = 0;
 		z2 = 0;
 	} else {
-		x = packet->tc.x;
-		y = packet->tc.y;
-		z1 = packet->tc.z1;
-		z2 = packet->tc.z2;
+		z1 = packet->z1;
+		z2 = packet->z2;
 	}
 
 	/* range filtering */
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
@@ -817,9 +872,9 @@ static void ads7846_report_state(struct ads7846 *ts)
 	 * the maximum. Don't report it to user space, repeat at least
 	 * once more the measurement
 	 */
-	if (packet->tc.ignore || Rt > ts->pressure_max) {
+	if (packet->ignore || Rt > ts->pressure_max) {
 		dev_vdbg(&ts->spi->dev, "ignored %d pressure %d\n",
-			 packet->tc.ignore, Rt);
+			 packet->ignore, Rt);
 		return;
 	}
 
@@ -980,13 +1035,62 @@ static int ads7846_setup_pendown(struct spi_device *spi,
  * Set up the transfers to read touchscreen state; this assumes we
  * use formula #2 for pressure, not #3.
  */
-static void ads7846_setup_spi_msg(struct ads7846 *ts,
+static int ads7846_setup_spi_msg(struct ads7846 *ts,
 				  const struct ads7846_platform_data *pdata)
 {
 	struct spi_message *m = &ts->msg[0];
 	struct spi_transfer *x = ts->xfer;
 	struct ads7846_packet *packet = ts->packet;
 	int vref = pdata->keep_vref_on;
+	unsigned int count, offset = 0;
+	unsigned int cmd_idx, b;
+	unsigned long time;
+	size_t size = 0;
+
+	/* time per bit */
+	time = NSEC_PER_SEC / ts->spi->max_speed_hz;
+
+	count = pdata->settle_delay_usecs * NSEC_PER_USEC / time;
+	packet->count_skip = DIV_ROUND_UP(count, 24);
+
+	if (ts->debounce_max && ts->debounce_rep)
+		/* ads7846_debounce_filter() is making ts->debounce_rep + 2
+		 * reads. So we need to get all samples for normal case. */
+		packet->count = ts->debounce_rep + 2;
+	else
+		packet->count = 1;
+
+	if (ts->model == 7846)
+		packet->cmds = 5; /* x, y, z1, z2, pwdown */
+	else
+		packet->cmds = 3; /* x, y, pwdown */
+
+	for (cmd_idx = 0; cmd_idx < packet->cmds; cmd_idx++) {
+		struct ads7846_buf_layout *l = &packet->l[cmd_idx];
+		unsigned int max_count;
+
+		if (cmd_idx == packet->cmds - 1)
+			cmd_idx = ADS7846_PWDOWN;
+
+		if (ads7846_cmd_need_settle(cmd_idx))
+			max_count = packet->count + packet->count_skip;
+		else
+			max_count = packet->count;
+
+		l->offset = offset;
+		offset += max_count;
+		l->count = max_count;
+		l->skip = packet->count_skip;
+		size += sizeof(*packet->tx) * max_count;
+	}
+
+	packet->tx = devm_kzalloc(&ts->spi->dev, size, GFP_KERNEL);
+	if (!packet->tx)
+		return -ENOMEM;
+
+	packet->rx = devm_kzalloc(&ts->spi->dev, size, GFP_KERNEL);
+	if (!packet->rx)
+		return -ENOMEM;
 
 	if (ts->model == 7873) {
 		/*
@@ -1002,185 +1106,25 @@ static void ads7846_setup_spi_msg(struct ads7846 *ts,
 	spi_message_init(m);
 	m->context = ts;
 
-	if (ts->model == 7845) {
-		packet->read_y_cmd[0] = READ_Y(vref);
-		packet->read_y_cmd[1] = 0;
-		packet->read_y_cmd[2] = 0;
-		x->tx_buf = &packet->read_y_cmd[0];
-		x->rx_buf = &packet->tc.y_buf[0];
-		x->len = 3;
-		spi_message_add_tail(x, m);
-	} else {
-		/* y- still on; turn on only y+ (and ADC) */
-		packet->read_y = READ_Y(vref);
-		x->tx_buf = &packet->read_y;
-		x->len = 1;
-		spi_message_add_tail(x, m);
-
-		x++;
-		x->rx_buf = &packet->tc.y;
-		x->len = 2;
-		spi_message_add_tail(x, m);
-	}
-
-	/*
-	 * The first sample after switching drivers can be low quality;
-	 * optionally discard it, using a second one after the signals
-	 * have had enough time to stabilize.
-	 */
-	if (pdata->settle_delay_usecs) {
-		x->delay.value = pdata->settle_delay_usecs;
-		x->delay.unit = SPI_DELAY_UNIT_USECS;
-
-		x++;
-		x->tx_buf = &packet->read_y;
-		x->len = 1;
-		spi_message_add_tail(x, m);
-
-		x++;
-		x->rx_buf = &packet->tc.y;
-		x->len = 2;
-		spi_message_add_tail(x, m);
-	}
-
-	ts->msg_count++;
-	m++;
-	spi_message_init(m);
-	m->context = ts;
-
-	if (ts->model == 7845) {
-		x++;
-		packet->read_x_cmd[0] = READ_X(vref);
-		packet->read_x_cmd[1] = 0;
-		packet->read_x_cmd[2] = 0;
-		x->tx_buf = &packet->read_x_cmd[0];
-		x->rx_buf = &packet->tc.x_buf[0];
-		x->len = 3;
-		spi_message_add_tail(x, m);
-	} else {
-		/* turn y- off, x+ on, then leave in lowpower */
-		x++;
-		packet->read_x = READ_X(vref);
-		x->tx_buf = &packet->read_x;
-		x->len = 1;
-		spi_message_add_tail(x, m);
-
-		x++;
-		x->rx_buf = &packet->tc.x;
-		x->len = 2;
-		spi_message_add_tail(x, m);
-	}
+	for (cmd_idx = 0; cmd_idx < packet->cmds; cmd_idx++) {
+		struct ads7846_buf_layout *l = &packet->l[cmd_idx];
+		u8 cmd;
 
-	/* ... maybe discard first sample ... */
-	if (pdata->settle_delay_usecs) {
-		x->delay.value = pdata->settle_delay_usecs;
-		x->delay.unit = SPI_DELAY_UNIT_USECS;
+		if (cmd_idx == packet->cmds - 1)
+			cmd_idx = ADS7846_PWDOWN;
 
-		x++;
-		x->tx_buf = &packet->read_x;
-		x->len = 1;
-		spi_message_add_tail(x, m);
+		cmd = ads7846_get_cmd(cmd_idx, vref);
 
-		x++;
-		x->rx_buf = &packet->tc.x;
-		x->len = 2;
-		spi_message_add_tail(x, m);
+		for (b = 0; b < l->count; b++)
+			packet->tx[l->offset + b].cmd = cmd;
 	}
 
-	/* turn y+ off, x- on; we'll use formula #2 */
-	if (ts->model == 7846) {
-		ts->msg_count++;
-		m++;
-		spi_message_init(m);
-		m->context = ts;
-
-		x++;
-		packet->read_z1 = READ_Z1(vref);
-		x->tx_buf = &packet->read_z1;
-		x->len = 1;
-		spi_message_add_tail(x, m);
-
-		x++;
-		x->rx_buf = &packet->tc.z1;
-		x->len = 2;
-		spi_message_add_tail(x, m);
-
-		/* ... maybe discard first sample ... */
-		if (pdata->settle_delay_usecs) {
-			x->delay.value = pdata->settle_delay_usecs;
-			x->delay.unit = SPI_DELAY_UNIT_USECS;
-
-			x++;
-			x->tx_buf = &packet->read_z1;
-			x->len = 1;
-			spi_message_add_tail(x, m);
-
-			x++;
-			x->rx_buf = &packet->tc.z1;
-			x->len = 2;
-			spi_message_add_tail(x, m);
-		}
-
-		ts->msg_count++;
-		m++;
-		spi_message_init(m);
-		m->context = ts;
-
-		x++;
-		packet->read_z2 = READ_Z2(vref);
-		x->tx_buf = &packet->read_z2;
-		x->len = 1;
-		spi_message_add_tail(x, m);
-
-		x++;
-		x->rx_buf = &packet->tc.z2;
-		x->len = 2;
-		spi_message_add_tail(x, m);
-
-		/* ... maybe discard first sample ... */
-		if (pdata->settle_delay_usecs) {
-			x->delay.value = pdata->settle_delay_usecs;
-			x->delay.unit = SPI_DELAY_UNIT_USECS;
-
-			x++;
-			x->tx_buf = &packet->read_z2;
-			x->len = 1;
-			spi_message_add_tail(x, m);
-
-			x++;
-			x->rx_buf = &packet->tc.z2;
-			x->len = 2;
-			spi_message_add_tail(x, m);
-		}
-	}
-
-	/* power down */
-	ts->msg_count++;
-	m++;
-	spi_message_init(m);
-	m->context = ts;
-
-	if (ts->model == 7845) {
-		x++;
-		packet->pwrdown_cmd[0] = PWRDOWN;
-		packet->pwrdown_cmd[1] = 0;
-		packet->pwrdown_cmd[2] = 0;
-		x->tx_buf = &packet->pwrdown_cmd[0];
-		x->len = 3;
-	} else {
-		x++;
-		packet->pwrdown = PWRDOWN;
-		x->tx_buf = &packet->pwrdown;
-		x->len = 1;
-		spi_message_add_tail(x, m);
-
-		x++;
-		x->rx_buf = &packet->dummy;
-		x->len = 2;
-	}
-
-	CS_CHANGE(*x);
+	x->tx_buf = packet->tx;
+	x->rx_buf = packet->rx;
+	x->len = size;
 	spi_message_add_tail(x, m);
+
+	return 0;
 }
 
 #ifdef CONFIG_OF
@@ -1381,8 +1325,9 @@ static int ads7846_probe(struct spi_device *spi)
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
index c7c9e976acbb..7d776c905b7d 100644
--- a/drivers/irqchip/irq-bcm7120-l2.c
+++ b/drivers/irqchip/irq-bcm7120-l2.c
@@ -273,7 +273,8 @@ static int __init bcm7120_l2_intc_probe(struct device_node *dn,
 		flags |= IRQ_GC_BE_IO;
 
 	ret = irq_alloc_domain_generic_chips(data->domain, IRQS_PER_WORD, 1,
-				dn->full_name, handle_level_irq, clr, 0, flags);
+				dn->full_name, handle_level_irq, clr,
+				IRQ_LEVEL, flags);
 	if (ret) {
 		pr_err("failed to allocate generic irq chip\n");
 		goto out_free_domain;
diff --git a/drivers/irqchip/irq-brcmstb-l2.c b/drivers/irqchip/irq-brcmstb-l2.c
index cdd6a42d4efa..a4aee16db531 100644
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
index 4365c1cc4505..fcb9eee3b609 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -236,14 +236,17 @@ struct led_classdev *of_led_get(struct device_node *np, int index)
 
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
@@ -256,6 +259,7 @@ EXPORT_SYMBOL_GPL(of_led_get);
 void led_put(struct led_classdev *led_cdev)
 {
 	module_put(led_cdev->dev->parent->driver->owner);
+	put_device(led_cdev->dev);
 }
 EXPORT_SYMBOL_GPL(led_put);
 
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 9b2aec309801..f98ad4366301 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -1883,6 +1883,7 @@ static void process_deferred_bios(struct work_struct *ws)
 
 		else
 			commit_needed = process_bio(cache, bio) || commit_needed;
+		cond_resched();
 	}
 
 	if (commit_needed)
@@ -1905,6 +1906,7 @@ static void requeue_deferred_bios(struct cache *cache)
 	while ((bio = bio_list_pop(&bios))) {
 		bio->bi_status = BLK_STS_DM_REQUEUE;
 		bio_endio(bio);
+		cond_resched();
 	}
 }
 
@@ -1945,6 +1947,8 @@ static void check_migrations(struct work_struct *ws)
 		r = mg_start(cache, op, NULL);
 		if (r)
 			break;
+
+		cond_resched();
 	}
 }
 
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index a2cc9e45cbba..36a4ef51ecaa 100644
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
@@ -359,9 +362,11 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
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
 
@@ -387,13 +392,14 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
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
index f3c519e18a12..c890bb3e5185 100644
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
index 1005abf76860..c60febd14be1 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -265,7 +265,6 @@ static int __init local_init(void)
 
 static void local_exit(void)
 {
-	flush_scheduled_work();
 	destroy_workqueue(deferred_remove_workqueue);
 
 	unregister_blkdev(_major, _name);
@@ -2394,6 +2393,7 @@ static void dm_wq_work(struct work_struct *work)
 			break;
 
 		submit_bio_noacct(bio);
+		cond_resched();
 	}
 }
 
diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 4771d0ef2c46..b975636d9440 100644
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
@@ -233,51 +240,13 @@ static const struct imx219_reg mode_1920_1080_regs[] = {
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
-	{0x0162, 0x0d},
-	{0x0163, 0x78},
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
@@ -290,53 +259,13 @@ static const struct imx219_reg mode_1640_1232_regs[] = {
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
@@ -349,35 +278,10 @@ static const struct imx219_reg mode_640_480_regs[] = {
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
@@ -483,6 +387,7 @@ static const struct imx219_mode supported_modes[] = {
 			.num_of_regs = ARRAY_SIZE(mode_3280x2464_regs),
 			.regs = mode_3280x2464_regs,
 		},
+		.binning = false,
 	},
 	{
 		/* 1080P 30fps cropped */
@@ -499,6 +404,7 @@ static const struct imx219_mode supported_modes[] = {
 			.num_of_regs = ARRAY_SIZE(mode_1920_1080_regs),
 			.regs = mode_1920_1080_regs,
 		},
+		.binning = false,
 	},
 	{
 		/* 2x2 binned 30fps mode */
@@ -515,6 +421,7 @@ static const struct imx219_mode supported_modes[] = {
 			.num_of_regs = ARRAY_SIZE(mode_1640_1232_regs),
 			.regs = mode_1640_1232_regs,
 		},
+		.binning = true,
 	},
 	{
 		/* 640x480 30fps mode */
@@ -531,6 +438,7 @@ static const struct imx219_mode supported_modes[] = {
 			.num_of_regs = ARRAY_SIZE(mode_640_480_regs),
 			.regs = mode_640_480_regs,
 		},
+		.binning = true,
 	},
 };
 
@@ -969,6 +877,35 @@ static int imx219_set_framefmt(struct imx219 *imx219)
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
 __imx219_get_pad_crop(struct imx219 *imx219, struct v4l2_subdev_pad_config *cfg,
 		      unsigned int pad, enum v4l2_subdev_format_whence which)
@@ -1032,6 +969,13 @@ static int imx219_start_streaming(struct imx219 *imx219)
 		return ret;
 	}
 
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
@@ -1047,6 +991,13 @@ static int imx219_start_streaming(struct imx219 *imx219)
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
index b1e2476d3c9e..79a11c0184c6 100644
--- a/drivers/media/i2c/max9286.c
+++ b/drivers/media/i2c/max9286.c
@@ -890,6 +890,7 @@ static int max9286_v4l2_register(struct max9286_priv *priv)
 err_put_node:
 	fwnode_handle_put(ep);
 err_async:
+	v4l2_ctrl_handler_free(&priv->ctrls);
 	max9286_v4l2_notifier_unregister(priv);
 
 	return ret;
diff --git a/drivers/media/i2c/ov2740.c b/drivers/media/i2c/ov2740.c
index bd0d45b0d43f..34d74e575a43 100644
--- a/drivers/media/i2c/ov2740.c
+++ b/drivers/media/i2c/ov2740.c
@@ -577,8 +577,10 @@ static int ov2740_init_controls(struct ov2740 *ov2740)
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
index 9540ce8918f0..aa35a9546177 100644
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
index 2fe4a0bd0284..d6838c8ebd7e 100644
--- a/drivers/media/pci/intel/ipu3/ipu3-cio2.c
+++ b/drivers/media/pci/intel/ipu3/ipu3-cio2.c
@@ -1831,6 +1831,9 @@ static void cio2_pci_remove(struct pci_dev *pci_dev)
 	v4l2_device_unregister(&cio2->v4l2_dev);
 	media_device_cleanup(&cio2->media_dev);
 	mutex_destroy(&cio2->lock);
+
+	pm_runtime_forbid(&pci_dev->dev);
+	pm_runtime_get_noresume(&pci_dev->dev);
 }
 
 static int __maybe_unused cio2_runtime_suspend(struct device *dev)
diff --git a/drivers/media/pci/saa7134/saa7134-core.c b/drivers/media/pci/saa7134/saa7134-core.c
index efb757d5168a..e97c30070fc6 100644
--- a/drivers/media/pci/saa7134/saa7134-core.c
+++ b/drivers/media/pci/saa7134/saa7134-core.c
@@ -977,7 +977,7 @@ static void saa7134_unregister_video(struct saa7134_dev *dev)
 	}
 	if (dev->radio_dev) {
 		if (video_is_registered(dev->radio_dev))
-			vb2_video_unregister_device(dev->radio_dev);
+			video_unregister_device(dev->radio_dev);
 		else
 			video_device_release(dev->radio_dev);
 		dev->radio_dev = NULL;
diff --git a/drivers/media/platform/omap3isp/isp.c b/drivers/media/platform/omap3isp/isp.c
index 1311b4996ece..21c16698cc2d 100644
--- a/drivers/media/platform/omap3isp/isp.c
+++ b/drivers/media/platform/omap3isp/isp.c
@@ -2297,7 +2297,16 @@ static int isp_probe(struct platform_device *pdev)
 
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
index 2eef245c31a1..93121c90d76a 100644
--- a/drivers/media/platform/ti-vpe/cal.c
+++ b/drivers/media/platform/ti-vpe/cal.c
@@ -624,8 +624,10 @@ static struct cal_ctx *cal_ctx_create(struct cal_dev *cal, int inst)
 	ctx->cport = inst;
 
 	ret = cal_ctx_v4l2_init(ctx);
-	if (ret)
+	if (ret) {
+		kfree(ctx);
 		return NULL;
+	}
 
 	return ctx;
 }
diff --git a/drivers/media/rc/ene_ir.c b/drivers/media/rc/ene_ir.c
index 6049e5c95394..5aa3953cab82 100644
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
index f479d8971dfb..5e0acabed37a 100644
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
index 282f3d2388cc..6334f99f1854 100644
--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -1121,10 +1121,8 @@ static int uvc_parse_vendor_control(struct uvc_device *dev,
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
@@ -1249,15 +1247,15 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
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
@@ -1289,10 +1287,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		memcpy(term->baSourceID, &buffer[7], 1);
 
-		if (buffer[8] != 0)
-			usb_string(udev, buffer[8], term->name,
-				   sizeof(term->name));
-		else
+		if (buffer[8] == 0 ||
+		    usb_string(udev, buffer[8], term->name, sizeof(term->name)) < 0)
 			sprintf(term->name, "Output %u", buffer[3]);
 
 		list_add_tail(&term->list, &dev->entities);
@@ -1314,10 +1310,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
 
 		memcpy(unit->baSourceID, &buffer[5], p);
 
-		if (buffer[5+p] != 0)
-			usb_string(udev, buffer[5+p], unit->name,
-				   sizeof(unit->name));
-		else
+		if (buffer[5+p] == 0 ||
+		    usb_string(udev, buffer[5+p], unit->name, sizeof(unit->name)) < 0)
 			sprintf(unit->name, "Selector %u", buffer[3]);
 
 		list_add_tail(&unit->list, &dev->entities);
@@ -1347,10 +1341,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
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
@@ -1378,10 +1370,8 @@ static int uvc_parse_standard_control(struct uvc_device *dev,
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
@@ -2565,6 +2555,24 @@ static const struct usb_device_id uvc_ids[] = {
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
index f6373d678d25..03dfe96bceba 100644
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
index c884020b2878..c75990c0957e 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -203,6 +203,7 @@
 #define UVC_QUIRK_RESTORE_CTRLS_ON_INIT	0x00000400
 #define UVC_QUIRK_FORCE_Y8		0x00000800
 #define UVC_QUIRK_FORCE_BPP		0x00001000
+#define UVC_QUIRK_WAKE_AUTOSUSPEND	0x00002000
 
 /* Format flags */
 #define UVC_FMT_FLAG_COMPRESSED		0x00000001
@@ -669,6 +670,7 @@ struct uvc_device {
 	/* Status Interrupt Endpoint */
 	struct usb_host_endpoint *int_ep;
 	struct urb *int_urb;
+	bool flush_status;
 	u8 *status;
 	struct input_dev *input;
 	char input_phys[64];
@@ -838,7 +840,9 @@ int uvc_ctrl_add_mapping(struct uvc_video_chain *chain,
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
index 000cb82023e3..afdc49083625 100644
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
index 4e30fa98fe7d..c4c1275581ec 100644
--- a/drivers/misc/mei/bus-fixup.c
+++ b/drivers/misc/mei/bus-fixup.c
@@ -172,7 +172,7 @@ static int mei_fwver(struct mei_cl_device *cldev)
 	ret = __mei_cl_send(cldev->cl, (u8 *)&req, sizeof(req),
 			    MEI_CL_IO_TX_BLOCKING);
 	if (ret < 0) {
-		dev_err(&cldev->dev, "Could not send ReqFWVersion cmd\n");
+		dev_err(&cldev->dev, "Could not send ReqFWVersion cmd ret = %d\n", ret);
 		return ret;
 	}
 
@@ -184,7 +184,7 @@ static int mei_fwver(struct mei_cl_device *cldev)
 		 * Should be at least one version block,
 		 * error out if nothing found
 		 */
-		dev_err(&cldev->dev, "Could not read FW version\n");
+		dev_err(&cldev->dev, "Could not read FW version ret = %d\n", bytes_recv);
 		return -EIO;
 	}
 
@@ -332,7 +332,7 @@ static int mei_nfc_if_version(struct mei_cl *cl,
 
 	ret = __mei_cl_send(cl, (u8 *)&cmd, sizeof(cmd), MEI_CL_IO_TX_BLOCKING);
 	if (ret < 0) {
-		dev_err(bus->dev, "Could not send IF version cmd\n");
+		dev_err(bus->dev, "Could not send IF version cmd ret = %d\n", ret);
 		return ret;
 	}
 
@@ -346,7 +346,7 @@ static int mei_nfc_if_version(struct mei_cl *cl,
 	ret = 0;
 	bytes_recv = __mei_cl_recv(cl, (u8 *)reply, if_version_length, 0, 0);
 	if (bytes_recv < 0 || (size_t)bytes_recv < if_version_length) {
-		dev_err(bus->dev, "Could not read IF version\n");
+		dev_err(bus->dev, "Could not read IF version ret = %d\n", bytes_recv);
 		ret = -EIO;
 		goto err;
 	}
diff --git a/drivers/mtd/nand/raw/sunxi_nand.c b/drivers/mtd/nand/raw/sunxi_nand.c
index 2a7ca3072f35..52eb28f3277c 100644
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
diff --git a/drivers/mtd/spi-nor/core.c b/drivers/mtd/spi-nor/core.c
index 2c256d455c9f..342215231932 100644
--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2424,6 +2424,15 @@ void spi_nor_set_erase_type(struct spi_nor_erase_type *erase, u32 size,
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
index 6f62ee861231..788775bb6795 100644
--- a/drivers/mtd/spi-nor/core.h
+++ b/drivers/mtd/spi-nor/core.h
@@ -424,6 +424,7 @@ void spi_nor_set_pp_settings(struct spi_nor_pp_command *pp, u8 opcode,
 
 void spi_nor_set_erase_type(struct spi_nor_erase_type *erase, u32 size,
 			    u8 opcode);
+void spi_nor_mask_erase_type(struct spi_nor_erase_type *erase);
 struct spi_nor_erase_region *
 spi_nor_region_next(struct spi_nor_erase_region *region);
 void spi_nor_init_uniform_erase_map(struct spi_nor_erase_map *map,
diff --git a/drivers/mtd/spi-nor/sfdp.c b/drivers/mtd/spi-nor/sfdp.c
index 08de2a2b4452..9dc0528ea884 100644
--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -852,7 +852,7 @@ spi_nor_init_non_uniform_erase_map(struct spi_nor *nor,
 	 */
 	for (i = 0; i < SNOR_ERASE_TYPE_MAX; i++)
 		if (!(regions_erase_type & BIT(erase[i].idx)))
-			spi_nor_set_erase_type(&erase[i], 0, 0xFF);
+			spi_nor_mask_erase_type(&erase[i]);
 
 	return 0;
 }
@@ -1063,7 +1063,7 @@ static int spi_nor_parse_4bait(struct spi_nor *nor,
 			erase_type[i].opcode = (dwords[1] >>
 						erase_type[i].idx * 8) & 0xFF;
 		else
-			spi_nor_set_erase_type(&erase_type[i], 0u, 0xFF);
+			spi_nor_mask_erase_type(&erase_type[i]);
 	}
 
 	/*
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 4153e0d15c5f..e45fdc1bf66a 100644
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
@@ -664,6 +665,12 @@ static int io_init(struct ubi_device *ubi, int max_beb_per1024)
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
diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index 053ab52668e8..69592be33adf 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -146,13 +146,15 @@ void ubi_refill_pools(struct ubi_device *ubi)
 	if (ubi->fm_anchor) {
 		wl_tree_add(ubi->fm_anchor, &ubi->free);
 		ubi->free_count++;
+		ubi->fm_anchor = NULL;
 	}
 
-	/*
-	 * All available PEBs are in ubi->free, now is the time to get
-	 * the best anchor PEBs.
-	 */
-	ubi->fm_anchor = ubi_wl_get_fm_peb(ubi, 1);
+	if (!ubi->fm_disabled)
+		/*
+		 * All available PEBs are in ubi->free, now is the time to get
+		 * the best anchor PEBs.
+		 */
+		ubi->fm_anchor = ubi_wl_get_fm_peb(ubi, 1);
 
 	for (;;) {
 		enough = 0;
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
index 820b5c1c8e8e..6da09263e0b9 100644
--- a/drivers/mtd/ubi/wl.c
+++ b/drivers/mtd/ubi/wl.c
@@ -885,8 +885,11 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
 
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
 
@@ -968,11 +971,11 @@ static int wear_leveling_worker(struct ubi_device *ubi, struct ubi_work *wrk,
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
@@ -1121,14 +1124,18 @@ static int __erase_worker(struct ubi_device *ubi, struct ubi_work *wl_wrk)
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
@@ -1244,6 +1251,18 @@ int ubi_wl_put_peb(struct ubi_device *ubi, int vol_id, int lnum,
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
index e0a6a2e62d23..7667cbb5adfd 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2263,6 +2263,14 @@ static unsigned int bcmgenet_desc_rx(struct bcmgenet_rx_ring *ring,
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
index f9e91304d232..4b875838a646 100644
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
index c1465096239b..4f0d63fa5709 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -5200,15 +5200,12 @@ int ice_vsi_cfg(struct ice_vsi *vsi)
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
 
@@ -5267,7 +5264,7 @@ static int ice_up_complete(struct ice_vsi *vsi)
 
 	if (vsi->port_info &&
 	    (vsi->port_info->phy.link_info.link_info & ICE_AQ_LINK_UP) &&
-	    vsi->netdev) {
+	    vsi->netdev && vsi->type == ICE_VSI_PF) {
 		ice_print_link_msg(vsi, true);
 		netif_tx_start_all_queues(vsi->netdev);
 		netif_carrier_on(vsi->netdev);
@@ -5277,7 +5274,9 @@ static int ice_up_complete(struct ice_vsi *vsi)
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
index 40d7bfca3749..0a011a41c039 100644
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
index a44a2bad5bbb..1ea71f06fdb1 100644
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
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 059d68d48f1e..4074310abcff 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -426,9 +426,7 @@ static int am65_cpsw_nuss_common_open(struct am65_cpsw_common *common,
 	writel(common->rx_flow_id_base,
 	       host_p->port_base + AM65_CPSW_PORT0_REG_FLOW_ID_OFFSET);
 	/* en tx crc offload */
-	if (features & NETIF_F_HW_CSUM)
-		writel(AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN,
-		       host_p->port_base + AM65_CPSW_P0_REG_CTL);
+	writel(AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN, host_p->port_base + AM65_CPSW_P0_REG_CTL);
 
 	am65_cpsw_nuss_set_p0_ptype(common);
 
@@ -1369,31 +1367,6 @@ static void am65_cpsw_nuss_ndo_get_stats(struct net_device *dev,
 	stats->tx_dropped	= dev->stats.tx_dropped;
 }
 
-static int am65_cpsw_nuss_ndo_slave_set_features(struct net_device *ndev,
-						 netdev_features_t features)
-{
-	struct am65_cpsw_common *common = am65_ndev_to_common(ndev);
-	netdev_features_t changes = features ^ ndev->features;
-	struct am65_cpsw_host *host_p;
-
-	host_p = am65_common_get_host(common);
-
-	if (changes & NETIF_F_HW_CSUM) {
-		bool enable = !!(features & NETIF_F_HW_CSUM);
-
-		dev_info(common->dev, "Turn %s tx-checksum-ip-generic\n",
-			 enable ? "ON" : "OFF");
-		if (enable)
-			writel(AM65_CPSW_P0_REG_CTL_RX_CHECKSUM_EN,
-			       host_p->port_base + AM65_CPSW_P0_REG_CTL);
-		else
-			writel(0,
-			       host_p->port_base + AM65_CPSW_P0_REG_CTL);
-	}
-
-	return 0;
-}
-
 static const struct net_device_ops am65_cpsw_nuss_netdev_ops_2g = {
 	.ndo_open		= am65_cpsw_nuss_ndo_slave_open,
 	.ndo_stop		= am65_cpsw_nuss_ndo_slave_stop,
@@ -1406,7 +1379,6 @@ static const struct net_device_ops am65_cpsw_nuss_netdev_ops_2g = {
 	.ndo_vlan_rx_add_vid	= am65_cpsw_nuss_ndo_slave_add_vid,
 	.ndo_vlan_rx_kill_vid	= am65_cpsw_nuss_ndo_slave_kill_vid,
 	.ndo_do_ioctl		= am65_cpsw_nuss_ndo_slave_ioctl,
-	.ndo_set_features	= am65_cpsw_nuss_ndo_slave_set_features,
 	.ndo_setup_tc           = am65_cpsw_qos_ndo_setup_tc,
 };
 
@@ -1515,9 +1487,8 @@ static int am65_cpsw_nuss_init_tx_chns(struct am65_cpsw_common *common)
 						    tx_chn->tx_chn_name,
 						    &tx_cfg);
 		if (IS_ERR(tx_chn->tx_chn)) {
-			ret = PTR_ERR(tx_chn->tx_chn);
-			dev_err(dev, "Failed to request tx dma channel %d\n",
-				ret);
+			ret = dev_err_probe(dev, PTR_ERR(tx_chn->tx_chn),
+					    "Failed to request tx dma channel\n");
 			goto err;
 		}
 
@@ -1588,8 +1559,8 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 
 	rx_chn->rx_chn = k3_udma_glue_request_rx_chn(dev, "rx", &rx_cfg);
 	if (IS_ERR(rx_chn->rx_chn)) {
-		ret = PTR_ERR(rx_chn->rx_chn);
-		dev_err(dev, "Failed to request rx dma channel %d\n", ret);
+		ret = dev_err_probe(dev, PTR_ERR(rx_chn->rx_chn),
+				    "Failed to request rx dma channel\n");
 		goto err;
 	}
 
@@ -1753,13 +1724,14 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		if (ret < 0) {
 			dev_err(dev, "%pOF error reading port_id %d\n",
 				port_np, ret);
-			return ret;
+			goto of_node_put;
 		}
 
 		if (!port_id || port_id > common->port_num) {
 			dev_err(dev, "%pOF has invalid port_id %u %s\n",
 				port_np, port_id, port_np->name);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto of_node_put;
 		}
 
 		port = am65_common_get_port(common, port_id);
@@ -1775,8 +1747,10 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 				(AM65_CPSW_NU_FRAM_PORT_OFFSET * (port_id - 1));
 
 		port->slave.mac_sl = cpsw_sl_get("am65", dev, port->port_base);
-		if (IS_ERR(port->slave.mac_sl))
-			return PTR_ERR(port->slave.mac_sl);
+		if (IS_ERR(port->slave.mac_sl)) {
+			ret = PTR_ERR(port->slave.mac_sl);
+			goto of_node_put;
+		}
 
 		port->disabled = !of_device_is_available(port_np);
 		if (port->disabled)
@@ -1787,7 +1761,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 			ret = PTR_ERR(port->slave.ifphy);
 			dev_err(dev, "%pOF error retrieving port phy: %d\n",
 				port_np, ret);
-			return ret;
+			goto of_node_put;
 		}
 
 		port->slave.mac_only =
@@ -1797,10 +1771,10 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		if (of_phy_is_fixed_link(port_np)) {
 			ret = of_phy_register_fixed_link(port_np);
 			if (ret) {
-				if (ret != -EPROBE_DEFER)
-					dev_err(dev, "%pOF failed to register fixed-link phy: %d\n",
-						port_np, ret);
-				return ret;
+				ret = dev_err_probe(dev, ret,
+						     "failed to register fixed-link phy %pOF\n",
+						     port_np);
+				goto of_node_put;
 			}
 			port->slave.phy_node = of_node_get(port_np);
 		} else {
@@ -1811,14 +1785,15 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 		if (!port->slave.phy_node) {
 			dev_err(dev,
 				"slave[%d] no phy found\n", port_id);
-			return -ENODEV;
+			ret = -ENODEV;
+			goto of_node_put;
 		}
 
 		ret = of_get_phy_mode(port_np, &port->slave.phy_if);
 		if (ret) {
 			dev_err(dev, "%pOF read phy-mode err %d\n",
 				port_np, ret);
-			return ret;
+			goto of_node_put;
 		}
 
 		mac_addr = of_get_mac_address(port_np);
@@ -1835,6 +1810,11 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 	of_node_put(node);
 
 	return 0;
+
+of_node_put:
+	of_node_put(port_np);
+	of_node_put(node);
+	return ret;
 }
 
 static void am65_cpsw_pcpu_stats_free(void *data)
@@ -2090,13 +2070,8 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	clk = devm_clk_get(dev, "fck");
-	if (IS_ERR(clk)) {
-		ret = PTR_ERR(clk);
-
-		if (ret != -EPROBE_DEFER)
-			dev_err(dev, "error getting fck clock %d\n", ret);
-		return ret;
-	}
+	if (IS_ERR(clk))
+		return dev_err_probe(dev, PTR_ERR(clk), "getting fck clock\n");
 	common->bus_freq = clk_get_rate(clk);
 
 	pm_runtime_enable(dev);
diff --git a/drivers/net/tap.c b/drivers/net/tap.c
index 8f7bb15206e9..d9018d9fe310 100644
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
index 67ce7b779af6..f1d46aea8a2b 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -3457,7 +3457,7 @@ static int tun_chr_open(struct inode *inode, struct file * file)
 	tfile->socket.file = file;
 	tfile->socket.ops = &tun_socket_ops;
 
-	sock_init_data(&tfile->socket, &tfile->sk);
+	sock_init_data_uid(&tfile->socket, &tfile->sk, inode->i_uid);
 
 	tfile->sk.sk_write_space = tun_sock_write_space;
 	tfile->sk.sk_sndbuf = INT_MAX;
diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index d2f2898d17b4..a66e275af1eb 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -712,7 +712,6 @@ struct ath11k_base {
 	enum ath11k_dfs_region dfs_region;
 #ifdef CONFIG_ATH11K_DEBUGFS
 	struct dentry *debugfs_soc;
-	struct dentry *debugfs_ath11k;
 #endif
 	struct ath11k_soc_dp_stats soc_stats;
 
diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 1b914e67d314..196314ab4ff0 100644
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
 
 void ath11k_debugfs_fw_stats_init(struct ath11k *ar)
diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 2e77dca6b1ad..578fdc446bc0 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3022,6 +3022,7 @@ int ath11k_peer_rx_frag_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id
 	if (!peer) {
 		ath11k_warn(ab, "failed to find the peer to set up fragment info\n");
 		spin_unlock_bh(&ab->base_lock);
+		crypto_free_shash(tfm);
 		return -ENOENT;
 	}
 
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
index 43a743ec9d9e..622fc7f17040 100644
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
index c8e1d505f7b5..3d544eedc1a3 100644
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
index 4ca8212d4fa4..ef0ac42a55a2 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-mac.c
@@ -3380,10 +3380,12 @@ static DEVICE_ATTR(dump_errors, 0200, NULL, il3945_dump_error_log);
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
 
@@ -3400,6 +3402,8 @@ il3945_setup_deferred_work(struct il_priv *il)
 	timer_setup(&il->watchdog, il_bg_watchdog, 0);
 
 	tasklet_setup(&il->irq_tasklet, il3945_irq_tasklet);
+
+	return 0;
 }
 
 static void
@@ -3721,7 +3725,10 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	}
 
 	il_set_rxon_channel(il, &il->bands[NL80211_BAND_2GHZ].channels[5]);
-	il3945_setup_deferred_work(il);
+	err = il3945_setup_deferred_work(il);
+	if (err)
+		goto out_remove_sysfs;
+
 	il3945_setup_handlers(il);
 	il_power_initialize(il);
 
@@ -3733,7 +3740,7 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	err = il3945_setup_mac(il);
 	if (err)
-		goto out_remove_sysfs;
+		goto out_destroy_workqueue;
 
 	il_dbgfs_register(il, DRV_NAME);
 
@@ -3742,9 +3749,10 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
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
index 28675a4ad861..12cf22d0e994 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -6212,10 +6212,12 @@ il4965_bg_txpower_work(struct work_struct *work)
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
 
@@ -6234,6 +6236,8 @@ il4965_setup_deferred_work(struct il_priv *il)
 	timer_setup(&il->watchdog, il_bg_watchdog, 0);
 
 	tasklet_setup(&il->irq_tasklet, il4965_irq_tasklet);
+
+	return 0;
 }
 
 static void
@@ -6623,7 +6627,10 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_disable_msi;
 	}
 
-	il4965_setup_deferred_work(il);
+	err = il4965_setup_deferred_work(il);
+	if (err)
+		goto out_free_irq;
+
 	il4965_setup_handlers(il);
 
 	/*********************************************
@@ -6661,6 +6668,7 @@ il4965_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 out_destroy_workqueue:
 	destroy_workqueue(il->workqueue);
 	il->workqueue = NULL;
+out_free_irq:
 	free_irq(il->pci_dev->irq, il);
 out_disable_msi:
 	pci_disable_msi(il->pci_dev);
diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 0651a6a416d1..4b55779de00a 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -5176,7 +5176,7 @@ il_mac_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	memset(&il->current_ht_config, 0, sizeof(struct il_ht_config));
 
 	/* new association get rid of ibss beacon skb */
-	dev_kfree_skb(il->beacon_skb);
+	dev_consume_skb_irq(il->beacon_skb);
 	il->beacon_skb = NULL;
 	il->timestamp = 0;
 
@@ -5295,7 +5295,7 @@ il_beacon_update(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	}
 
 	spin_lock_irqsave(&il->lock, flags);
-	dev_kfree_skb(il->beacon_skb);
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
index ee4cf3437e28..1c56cc2742b0 100644
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
index ecce8b56f8a2..2c45ef6e0407 100644
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
index f01b455783b2..7991705e9d13 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -476,6 +476,7 @@ mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
 	bool more;
 
 	spin_lock_bh(&q->lock);
+
 	do {
 		buf = mt76_dma_dequeue(dev, q, true, NULL, NULL, &more);
 		if (!buf)
@@ -483,6 +484,12 @@ mt76_dma_rx_cleanup(struct mt76_dev *dev, struct mt76_queue *q)
 
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
@@ -505,12 +512,6 @@ mt76_dma_rx_reset(struct mt76_dev *dev, enum mt76_rxq_id qid)
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
diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
index 11071519fce8..8ba291abecff 100644
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
diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.c b/drivers/net/wireless/microchip/wilc1000/netdev.c
index 20615c7ec168..c508f429984a 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.c
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.c
@@ -684,6 +684,7 @@ netdev_tx_t wilc_mac_xmit(struct sk_buff *skb, struct net_device *ndev)
 
 	if (skb->dev != ndev) {
 		netdev_err(ndev, "Packet not destined to this device\n");
+		dev_kfree_skb(skb);
 		return NETDEV_TX_OK;
 	}
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index 199e7e031d7d..3b3cb3a6e2e8 100644
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
index 2cb86c28d11f..deef1c09de31 100644
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
 
@@ -5491,9 +5491,6 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
 	btcoex = &priv->bt_coex;
 	rarpt = &priv->ra_report;
 
-	if (priv->rf_paths > 1)
-		goto out;
-
 	while (!skb_queue_empty(&priv->c2hcmd_queue)) {
 		spin_lock_irqsave(&priv->c2hcmd_lock, flags);
 		skb = __skb_dequeue(&priv->c2hcmd_queue);
@@ -5547,10 +5544,9 @@ static void rtl8xxxu_c2hcmd_callback(struct work_struct *work)
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
@@ -5912,7 +5908,6 @@ static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
 	struct device *dev = &priv->udev->dev;
-	u16 val16;
 	int ret = 0, channel;
 	bool ht40;
 
@@ -5922,14 +5917,6 @@ static int rtl8xxxu_config(struct ieee80211_hw *hw, u32 changed)
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
index 63f9ea21962f..335a3c9cdbab 100644
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
index f41a7643b9c4..c0c06ab6d3e7 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/phy.c
@@ -1581,7 +1581,7 @@ static void _rtl8821ae_phy_txpower_by_rate_configuration(struct ieee80211_hw *hw
 }
 
 /* string is in decimal */
-static bool _rtl8812ae_get_integer_from_string(char *str, u8 *pint)
+static bool _rtl8812ae_get_integer_from_string(const char *str, u8 *pint)
 {
 	u16 i = 0;
 	*pint = 0;
@@ -1599,18 +1599,6 @@ static bool _rtl8812ae_get_integer_from_string(char *str, u8 *pint)
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
@@ -1637,10 +1625,11 @@ static s8 _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(struct ieee80211_hw *hw,
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
@@ -1648,8 +1637,8 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw, u8 *pregul
 	u8 channel_index;
 	s8 power_limit = 0, prev_power_limit, ret;
 
-	if (!_rtl8812ae_get_integer_from_string((char *)pchannel, &channel) ||
-	    !_rtl8812ae_get_integer_from_string((char *)ppower_limit,
+	if (!_rtl8812ae_get_integer_from_string(pchannel, &channel) ||
+	    !_rtl8812ae_get_integer_from_string(ppower_limit,
 						&power_limit)) {
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE,
 			"Illegal index of pwr_lmt table [chnl %d][val %d]\n",
@@ -1659,42 +1648,42 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw, u8 *pregul
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
@@ -1718,7 +1707,7 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw, u8 *pregul
 			regulation, bandwidth, rate_section, channel_index,
 			rtlphy->txpwr_limit_2_4g[regulation][bandwidth]
 				[rate_section][channel_index][RF90_PATH_A]);
-	} else if (_rtl8812ae_eq_n_byte(pband, (u8 *)("5G"), 2)) {
+	} else if (strcmp(pband, "5G") == 0) {
 		ret = _rtl8812ae_phy_get_chnl_idx_of_txpwr_lmt(hw,
 							       BAND_ON_5G,
 							       channel);
@@ -1749,10 +1738,10 @@ static void _rtl8812ae_phy_set_txpower_limit(struct ieee80211_hw *hw, u8 *pregul
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
@@ -1765,7 +1754,7 @@ static void _rtl8821ae_phy_read_and_config_txpwr_lmt(struct ieee80211_hw *hw)
 	struct rtl_hal *rtlhal = rtl_hal(rtlpriv);
 	u32 i = 0;
 	u32 array_len;
-	u8 **array;
+	const char **array;
 
 	if (rtlhal->hw_type == HARDWARE_TYPE_RTL8812AE) {
 		array_len = RTL8812AE_TXPWR_LMT_ARRAY_LEN;
@@ -1778,13 +1767,13 @@ static void _rtl8821ae_phy_read_and_config_txpwr_lmt(struct ieee80211_hw *hw)
 	rtl_dbg(rtlpriv, COMP_INIT, DBG_TRACE, "\n");
 
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
index ff1701adbb17..ccf6344ed6fd 100644
--- a/drivers/net/wireless/wl3501_cs.c
+++ b/drivers/net/wireless/wl3501_cs.c
@@ -1330,7 +1330,7 @@ static netdev_tx_t wl3501_hard_start_xmit(struct sk_buff *skb,
 	} else {
 		++dev->stats.tx_packets;
 		dev->stats.tx_bytes += skb->len;
-		kfree_skb(skb);
+		dev_kfree_skb_irq(skb);
 
 		if (this->tx_buffer_cnt < 2)
 			netif_stop_queue(dev);
diff --git a/drivers/nfc/st-nci/se.c b/drivers/nfc/st-nci/se.c
index 37d397aae9b9..a14afceaf5e9 100644
--- a/drivers/nfc/st-nci/se.c
+++ b/drivers/nfc/st-nci/se.c
@@ -664,6 +664,12 @@ int st_nci_se_io(struct nci_dev *ndev, u32 se_idx,
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
index 596c185b5dda..60f4ff8e044d 100644
--- a/drivers/opp/debugfs.c
+++ b/drivers/opp/debugfs.c
@@ -204,7 +204,7 @@ static void opp_migrate_dentry(struct opp_device *opp_dev,
 
 	dentry = debugfs_rename(rootdir, opp_dev->dentry, rootdir,
 				opp_table->dentry_name);
-	if (!dentry) {
+	if (IS_ERR(dentry)) {
 		dev_err(dev, "%s: Failed to rename link from: %s to %s\n",
 			__func__, dev_name(opp_dev->dev), dev_name(dev));
 		return;
diff --git a/drivers/pci/controller/pci-loongson.c b/drivers/pci/controller/pci-loongson.c
index 48169b1e3817..e73e18a73833 100644
--- a/drivers/pci/controller/pci-loongson.c
+++ b/drivers/pci/controller/pci-loongson.c
@@ -13,9 +13,14 @@
 #include "../pci.h"
 
 /* Device IDs */
-#define DEV_PCIE_PORT_0	0x7a09
-#define DEV_PCIE_PORT_1	0x7a19
-#define DEV_PCIE_PORT_2	0x7a29
+#define DEV_LS2K_PCIE_PORT0	0x1a05
+#define DEV_LS7A_PCIE_PORT0	0x7a09
+#define DEV_LS7A_PCIE_PORT1	0x7a19
+#define DEV_LS7A_PCIE_PORT2	0x7a29
+#define DEV_LS7A_PCIE_PORT3	0x7a39
+#define DEV_LS7A_PCIE_PORT4	0x7a49
+#define DEV_LS7A_PCIE_PORT5	0x7a59
+#define DEV_LS7A_PCIE_PORT6	0x7a69
 
 #define DEV_LS2K_APB	0x7a02
 #define DEV_LS7A_CONF	0x7a10
@@ -38,11 +43,11 @@ static void bridge_class_quirk(struct pci_dev *dev)
 	dev->class = PCI_CLASS_BRIDGE_PCI << 8;
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
-			DEV_PCIE_PORT_0, bridge_class_quirk);
+			DEV_LS7A_PCIE_PORT0, bridge_class_quirk);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
-			DEV_PCIE_PORT_1, bridge_class_quirk);
+			DEV_LS7A_PCIE_PORT1, bridge_class_quirk);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
-			DEV_PCIE_PORT_2, bridge_class_quirk);
+			DEV_LS7A_PCIE_PORT2, bridge_class_quirk);
 
 static void system_bus_quirk(struct pci_dev *pdev)
 {
@@ -60,37 +65,33 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
 			DEV_LS7A_LPC, system_bus_quirk);
 
-static void loongson_mrrs_quirk(struct pci_dev *dev)
+static void loongson_mrrs_quirk(struct pci_dev *pdev)
 {
-	struct pci_bus *bus = dev->bus;
-	struct pci_dev *bridge;
-	static const struct pci_device_id bridge_devids[] = {
-		{ PCI_VDEVICE(LOONGSON, DEV_PCIE_PORT_0) },
-		{ PCI_VDEVICE(LOONGSON, DEV_PCIE_PORT_1) },
-		{ PCI_VDEVICE(LOONGSON, DEV_PCIE_PORT_2) },
-		{ 0, },
-	};
-
-	/* look for the matching bridge */
-	while (!pci_is_root_bus(bus)) {
-		bridge = bus->self;
-		bus = bus->parent;
-		/*
-		 * Some Loongson PCIe ports have a h/w limitation of
-		 * 256 bytes maximum read request size. They can't handle
-		 * anything larger than this. So force this limit on
-		 * any devices attached under these ports.
-		 */
-		if (pci_match_id(bridge_devids, bridge)) {
-			if (pcie_get_readrq(dev) > 256) {
-				pci_info(dev, "limiting MRRS to 256\n");
-				pcie_set_readrq(dev, 256);
-			}
-			break;
-		}
-	}
+	/*
+	 * Some Loongson PCIe ports have h/w limitations of maximum read
+	 * request size. They can't handle anything larger than this. So
+	 * force this limit on any devices attached under these ports.
+	 */
+	struct pci_host_bridge *bridge = pci_find_host_bridge(pdev->bus);
+
+	bridge->no_inc_mrrs = 1;
 }
-DECLARE_PCI_FIXUP_ENABLE(PCI_ANY_ID, PCI_ANY_ID, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS2K_PCIE_PORT0, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT0, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT1, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT2, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT3, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT4, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT5, loongson_mrrs_quirk);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_LOONGSON,
+			DEV_LS7A_PCIE_PORT6, loongson_mrrs_quirk);
 
 static void __iomem *cfg1_map(struct loongson_pci *priv, int bus,
 				unsigned int devfn, int where)
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 262577c81d30..744a2e05635b 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -4808,7 +4808,7 @@ void pci_bridge_wait_for_secondary_bus(struct pci_dev *dev)
 	if (pci_dev_is_disconnected(dev))
 		return;
 
-	if (!pci_is_bridge(dev) || !dev->bridge_d3)
+	if (!pci_is_bridge(dev))
 		return;
 
 	down_read(&pci_bus_sem);
@@ -5739,6 +5739,7 @@ int pcie_set_readrq(struct pci_dev *dev, int rq)
 {
 	u16 v;
 	int ret;
+	struct pci_host_bridge *bridge = pci_find_host_bridge(dev->bus);
 
 	if (rq < 128 || rq > 4096 || !is_power_of_2(rq))
 		return -EINVAL;
@@ -5757,6 +5758,15 @@ int pcie_set_readrq(struct pci_dev *dev, int rq)
 
 	v = (ffs(rq) - 8) << 12;
 
+	if (bridge->no_inc_mrrs) {
+		int max_mrrs = pcie_get_readrq(dev);
+
+		if (rq > max_mrrs) {
+			pci_info(dev, "can't set Max_Read_Request_Size to %d; max is %d\n", rq, max_mrrs);
+			return -EINVAL;
+		}
+	}
+
 	ret = pcie_capability_clear_and_set_word(dev, PCI_EXP_DEVCTL,
 						  PCI_EXP_DEVCTL_READRQ, v);
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index 0039460c6ab0..9197d7362731 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -351,53 +351,36 @@ struct pci_sriov {
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
index fb2e52fd01b3..c1ebd5e12b06 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4797,6 +4797,26 @@ static int pci_quirk_brcm_acs(struct pci_dev *dev, u16 acs_flags)
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
@@ -4942,6 +4962,8 @@ static const struct pci_dev_acs_enabled {
 	{ PCI_VENDOR_ID_NXP, 0x8d9b, pci_quirk_nxp_rp_acs },
 	/* Zhaoxin Root/Downstream Ports */
 	{ PCI_VENDOR_ID_ZHAOXIN, PCI_ANY_ID, pci_quirk_zhaoxin_pcie_ports_acs },
+	/* Wangxun nics */
+	{ PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID, pci_quirk_wangxun_nic_acs },
 	{ 0 }
 };
 
@@ -5302,6 +5324,7 @@ static void quirk_no_flr(struct pci_dev *dev)
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x1487, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x148c, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x149c, quirk_no_flr);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_AMD, 0x7901, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1502, quirk_no_flr);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x1503, quirk_no_flr);
 
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 2ce636937c6e..16d291e10627 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -1878,12 +1878,67 @@ static void adjust_bridge_window(struct pci_dev *bridge, struct resource *res,
 		add_size = size - new_size;
 		pci_dbg(bridge, "bridge window %pR shrunken by %pa\n", res,
 			&add_size);
+	} else {
+		return;
 	}
 
 	res->end = res->start + new_size - 1;
 	remove_from_list(add_list, res);
 }
 
+static void remove_dev_resource(struct resource *avail, struct pci_dev *dev,
+				struct resource *res)
+{
+	resource_size_t size, align, tmp;
+
+	size = resource_size(res);
+	if (!size)
+		return;
+
+	align = pci_resource_alignment(dev, res);
+	align = align ? ALIGN(avail->start, align) - avail->start : 0;
+	tmp = align + size;
+	avail->start = min(avail->start + tmp, avail->end + 1);
+}
+
+static void remove_dev_resources(struct pci_dev *dev, struct resource *io,
+				 struct resource *mmio,
+				 struct resource *mmio_pref)
+{
+	int i;
+
+	for (i = 0; i < PCI_NUM_RESOURCES; i++) {
+		struct resource *res = &dev->resource[i];
+
+		if (resource_type(res) == IORESOURCE_IO) {
+			remove_dev_resource(io, dev, res);
+		} else if (resource_type(res) == IORESOURCE_MEM) {
+
+			/*
+			 * Make sure prefetchable memory is reduced from
+			 * the correct resource. Specifically we put 32-bit
+			 * prefetchable memory in non-prefetchable window
+			 * if there is an 64-bit pretchable window.
+			 *
+			 * See comments in __pci_bus_size_bridges() for
+			 * more information.
+			 */
+			if ((res->flags & IORESOURCE_PREFETCH) &&
+			    ((res->flags & IORESOURCE_MEM_64) ==
+			     (mmio_pref->flags & IORESOURCE_MEM_64)))
+				remove_dev_resource(mmio_pref, dev, res);
+			else
+				remove_dev_resource(mmio, dev, res);
+		}
+	}
+}
+
+/*
+ * io, mmio and mmio_pref contain the total amount of bridge window space
+ * available. This includes the minimal space needed to cover all the
+ * existing devices on the bus and the possible extra space that can be
+ * shared with the bridges.
+ */
 static void pci_bus_distribute_available_resources(struct pci_bus *bus,
 					    struct list_head *add_list,
 					    struct resource io,
@@ -1893,7 +1948,7 @@ static void pci_bus_distribute_available_resources(struct pci_bus *bus,
 	unsigned int normal_bridges = 0, hotplug_bridges = 0;
 	struct resource *io_res, *mmio_res, *mmio_pref_res;
 	struct pci_dev *dev, *bridge = bus->self;
-	resource_size_t io_per_hp, mmio_per_hp, mmio_pref_per_hp, align;
+	resource_size_t io_per_b, mmio_per_b, mmio_pref_per_b, align;
 
 	io_res = &bridge->resource[PCI_BRIDGE_IO_WINDOW];
 	mmio_res = &bridge->resource[PCI_BRIDGE_MEM_WINDOW];
@@ -1937,94 +1992,88 @@ static void pci_bus_distribute_available_resources(struct pci_bus *bus,
 			normal_bridges++;
 	}
 
+	if (!(hotplug_bridges + normal_bridges))
+		return;
+
 	/*
-	 * There is only one bridge on the bus so it gets all available
-	 * resources which it can then distribute to the possible hotplug
-	 * bridges below.
+	 * Calculate the amount of space we can forward from "bus" to any
+	 * downstream buses, i.e., the space left over after assigning the
+	 * BARs and windows on "bus".
 	 */
-	if (hotplug_bridges + normal_bridges == 1) {
-		dev = list_first_entry(&bus->devices, struct pci_dev, bus_list);
-		if (dev->subordinate)
-			pci_bus_distribute_available_resources(dev->subordinate,
-				add_list, io, mmio, mmio_pref);
-		return;
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!dev->is_virtfn)
+			remove_dev_resources(dev, &io, &mmio, &mmio_pref);
 	}
 
-	if (hotplug_bridges == 0)
-		return;
-
 	/*
-	 * Calculate the total amount of extra resource space we can
-	 * pass to bridges below this one.  This is basically the
-	 * extra space reduced by the minimal required space for the
-	 * non-hotplug bridges.
+	 * If there is at least one hotplug bridge on this bus it gets all
+	 * the extra resource space that was left after the reductions
+	 * above.
+	 *
+	 * If there are no hotplug bridges the extra resource space is
+	 * split between non-hotplug bridges. This is to allow possible
+	 * hotplug bridges below them to get the extra space as well.
 	 */
+	if (hotplug_bridges) {
+		io_per_b = div64_ul(resource_size(&io), hotplug_bridges);
+		mmio_per_b = div64_ul(resource_size(&mmio), hotplug_bridges);
+		mmio_pref_per_b = div64_ul(resource_size(&mmio_pref),
+					   hotplug_bridges);
+	} else {
+		io_per_b = div64_ul(resource_size(&io), normal_bridges);
+		mmio_per_b = div64_ul(resource_size(&mmio), normal_bridges);
+		mmio_pref_per_b = div64_ul(resource_size(&mmio_pref),
+					   normal_bridges);
+	}
+
 	for_each_pci_bridge(dev, bus) {
-		resource_size_t used_size;
 		struct resource *res;
+		struct pci_bus *b;
 
-		if (dev->is_hotplug_bridge)
+		b = dev->subordinate;
+		if (!b)
+			continue;
+		if (hotplug_bridges && !dev->is_hotplug_bridge)
 			continue;
 
+		res = &dev->resource[PCI_BRIDGE_IO_WINDOW];
+
 		/*
-		 * Reduce the available resource space by what the
-		 * bridge and devices below it occupy.
+		 * Make sure the split resource space is properly aligned
+		 * for bridge windows (align it down to avoid going above
+		 * what is available).
 		 */
-		res = &dev->resource[PCI_BRIDGE_IO_WINDOW];
 		align = pci_resource_alignment(dev, res);
-		align = align ? ALIGN(io.start, align) - io.start : 0;
-		used_size = align + resource_size(res);
-		if (!res->parent)
-			io.start = min(io.start + used_size, io.end + 1);
+		io.end = align ? io.start + ALIGN_DOWN(io_per_b, align) - 1
+			       : io.start + io_per_b - 1;
+
+		/*
+		 * The x_per_b holds the extra resource space that can be
+		 * added for each bridge but there is the minimal already
+		 * reserved as well so adjust x.start down accordingly to
+		 * cover the whole space.
+		 */
+		io.start -= resource_size(res);
 
 		res = &dev->resource[PCI_BRIDGE_MEM_WINDOW];
 		align = pci_resource_alignment(dev, res);
-		align = align ? ALIGN(mmio.start, align) - mmio.start : 0;
-		used_size = align + resource_size(res);
-		if (!res->parent)
-			mmio.start = min(mmio.start + used_size, mmio.end + 1);
+		mmio.end = align ? mmio.start + ALIGN_DOWN(mmio_per_b, align) - 1
+				 : mmio.start + mmio_per_b - 1;
+		mmio.start -= resource_size(res);
 
 		res = &dev->resource[PCI_BRIDGE_PREF_MEM_WINDOW];
 		align = pci_resource_alignment(dev, res);
-		align = align ? ALIGN(mmio_pref.start, align) -
-			mmio_pref.start : 0;
-		used_size = align + resource_size(res);
-		if (!res->parent)
-			mmio_pref.start = min(mmio_pref.start + used_size,
-				mmio_pref.end + 1);
-	}
-
-	io_per_hp = div64_ul(resource_size(&io), hotplug_bridges);
-	mmio_per_hp = div64_ul(resource_size(&mmio), hotplug_bridges);
-	mmio_pref_per_hp = div64_ul(resource_size(&mmio_pref),
-		hotplug_bridges);
-
-	/*
-	 * Go over devices on this bus and distribute the remaining
-	 * resource space between hotplug bridges.
-	 */
-	for_each_pci_bridge(dev, bus) {
-		struct pci_bus *b;
-
-		b = dev->subordinate;
-		if (!b || !dev->is_hotplug_bridge)
-			continue;
-
-		/*
-		 * Distribute available extra resources equally between
-		 * hotplug-capable downstream ports taking alignment into
-		 * account.
-		 */
-		io.end = io.start + io_per_hp - 1;
-		mmio.end = mmio.start + mmio_per_hp - 1;
-		mmio_pref.end = mmio_pref.start + mmio_pref_per_hp - 1;
+		mmio_pref.end = align ? mmio_pref.start +
+					ALIGN_DOWN(mmio_pref_per_b, align) - 1
+				      : mmio_pref.start + mmio_pref_per_b - 1;
+		mmio_pref.start -= resource_size(res);
 
 		pci_bus_distribute_available_resources(b, add_list, io, mmio,
 						       mmio_pref);
 
-		io.start += io_per_hp;
-		mmio.start += mmio_per_hp;
-		mmio_pref.start += mmio_pref_per_hp;
+		io.start += io.end + 1;
+		mmio.start += mmio.end + 1;
+		mmio_pref.start += mmio_pref.end + 1;
 	}
 }
 
diff --git a/drivers/phy/rockchip/phy-rockchip-typec.c b/drivers/phy/rockchip/phy-rockchip-typec.c
index 70a31251b202..20f787d5ec58 100644
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
diff --git a/drivers/pinctrl/bcm/pinctrl-bcm2835.c b/drivers/pinctrl/bcm/pinctrl-bcm2835.c
index 39d2024dc2ee..c7ae9f900b53 100644
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
index d0a4ebbe1e7e..e486d66e220b 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -574,7 +574,7 @@ static int mtk_hw_get_value_wrap(struct mtk_pinctrl *hw, unsigned int gpio, int
 ssize_t mtk_pctrl_show_one_pin(struct mtk_pinctrl *hw,
 	unsigned int gpio, char *buf, unsigned int bufLen)
 {
-	int pinmux, pullup, pullen, len = 0, r1 = -1, r0 = -1;
+	int pinmux, pullup = 0, pullen = 0, len = 0, r1 = -1, r0 = -1;
 	const struct mtk_pin_desc *desc;
 
 	if (gpio >= hw->soc->npins)
@@ -637,7 +637,7 @@ static void mtk_pctrl_dbg_show(struct pinctrl_dev *pctldev, struct seq_file *s,
 			  unsigned int gpio)
 {
 	struct mtk_pinctrl *hw = pinctrl_dev_get_drvdata(pctldev);
-	char buf[PIN_DBG_BUF_SZ];
+	char buf[PIN_DBG_BUF_SZ] = { 0 };
 
 	(void)mtk_pctrl_show_one_pin(hw, gpio, buf, PIN_DBG_BUF_SZ);
 
diff --git a/drivers/pinctrl/pinctrl-at91-pio4.c b/drivers/pinctrl/pinctrl-at91-pio4.c
index 578b387100d9..d2e2b101978f 100644
--- a/drivers/pinctrl/pinctrl-at91-pio4.c
+++ b/drivers/pinctrl/pinctrl-at91-pio4.c
@@ -1081,8 +1081,8 @@ static int atmel_pinctrl_probe(struct platform_device *pdev)
 
 		pin_desc[i].number = i;
 		/* Pin naming convention: P(bank_name)(bank_pin_number). */
-		pin_desc[i].name = kasprintf(GFP_KERNEL, "P%c%d",
-					     bank + 'A', line);
+		pin_desc[i].name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "P%c%d",
+						  bank + 'A', line);
 
 		group->name = group_names[i] = pin_desc[i].name;
 		group->pin = pin_desc[i].number;
diff --git a/drivers/pinctrl/pinctrl-at91.c b/drivers/pinctrl/pinctrl-at91.c
index 9015486e38c1..52ecd47c18e2 100644
--- a/drivers/pinctrl/pinctrl-at91.c
+++ b/drivers/pinctrl/pinctrl-at91.c
@@ -1891,7 +1891,7 @@ static int at91_gpio_probe(struct platform_device *pdev)
 	}
 
 	for (i = 0; i < chip->ngpio; i++)
-		names[i] = kasprintf(GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
+		names[i] = devm_kasprintf(&pdev->dev, GFP_KERNEL, "pio%c%d", alias_idx + 'A', i);
 
 	chip->names = (const char *const *)names;
 
diff --git a/drivers/pinctrl/pinctrl-ingenic.c b/drivers/pinctrl/pinctrl-ingenic.c
index e0df5ad6741d..4d07c531371c 100644
--- a/drivers/pinctrl/pinctrl-ingenic.c
+++ b/drivers/pinctrl/pinctrl-ingenic.c
@@ -11,6 +11,7 @@
 #include <linux/gpio/driver.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/kernel.h>
 #include <linux/of_device.h>
 #include <linux/of_irq.h>
 #include <linux/of_platform.h>
@@ -2826,6 +2827,8 @@ static int __init ingenic_pinctrl_probe(struct platform_device *pdev)
 	return 0;
 }
 
+#define IF_ENABLED(cfg, ptr)	PTR_IF(IS_ENABLED(cfg), (ptr))
+
 static const struct of_device_id ingenic_pinctrl_of_match[] = {
 	{ .compatible = "ingenic,jz4740-pinctrl", .data = &jz4740_chip_info },
 	{ .compatible = "ingenic,jz4725b-pinctrl", .data = &jz4725b_chip_info },
diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 07b1204174bf..2a454098eaaa 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -61,8 +61,17 @@ enum rockchip_pinctrl_type {
 	RK3308,
 	RK3368,
 	RK3399,
+	RK3568,
 };
 
+
+/**
+ * Generate a bitmask for setting a value (v) with a write mask bit in hiword
+ * register 31:16 area.
+ */
+#define WRITE_MASK_VAL(h, l, v) \
+	(GENMASK(((h) + 16), ((l) + 16)) | (((v) << (l)) & GENMASK((h), (l))))
+
 /*
  * Encode variants of iomux registers into a type variable
  */
@@ -290,6 +299,25 @@ struct rockchip_pin_bank {
 		.pull_type[3] = pull3,					\
 	}
 
+#define PIN_BANK_MUX_ROUTE_FLAGS(ID, PIN, FUNC, REG, VAL, FLAG)		\
+	{								\
+		.bank_num	= ID,					\
+		.pin		= PIN,					\
+		.func		= FUNC,					\
+		.route_offset	= REG,					\
+		.route_val	= VAL,					\
+		.route_location	= FLAG,					\
+	}
+
+#define RK_MUXROUTE_SAME(ID, PIN, FUNC, REG, VAL)	\
+	PIN_BANK_MUX_ROUTE_FLAGS(ID, PIN, FUNC, REG, VAL, ROCKCHIP_ROUTE_SAME)
+
+#define RK_MUXROUTE_GRF(ID, PIN, FUNC, REG, VAL)	\
+	PIN_BANK_MUX_ROUTE_FLAGS(ID, PIN, FUNC, REG, VAL, ROCKCHIP_ROUTE_GRF)
+
+#define RK_MUXROUTE_PMU(ID, PIN, FUNC, REG, VAL)	\
+	PIN_BANK_MUX_ROUTE_FLAGS(ID, PIN, FUNC, REG, VAL, ROCKCHIP_ROUTE_PMU)
+
 /**
  * struct rockchip_mux_recalced_data: represent a pin iomux data.
  * @num: bank number.
@@ -816,597 +844,203 @@ static void rockchip_get_recalced_mux(struct rockchip_pin_bank *bank, int pin,
 }
 
 static struct rockchip_mux_route_data px30_mux_route_data[] = {
-	{
-		/* cif-d2m0 */
-		.bank_num = 2,
-		.pin = 0,
-		.func = 1,
-		.route_offset = 0x184,
-		.route_val = BIT(16 + 7),
-	}, {
-		/* cif-d2m1 */
-		.bank_num = 3,
-		.pin = 3,
-		.func = 3,
-		.route_offset = 0x184,
-		.route_val = BIT(16 + 7) | BIT(7),
-	}, {
-		/* pdm-m0 */
-		.bank_num = 3,
-		.pin = 22,
-		.func = 2,
-		.route_offset = 0x184,
-		.route_val = BIT(16 + 8),
-	}, {
-		/* pdm-m1 */
-		.bank_num = 2,
-		.pin = 22,
-		.func = 1,
-		.route_offset = 0x184,
-		.route_val = BIT(16 + 8) | BIT(8),
-	}, {
-		/* uart2-rxm0 */
-		.bank_num = 1,
-		.pin = 27,
-		.func = 2,
-		.route_offset = 0x184,
-		.route_val = BIT(16 + 10),
-	}, {
-		/* uart2-rxm1 */
-		.bank_num = 2,
-		.pin = 14,
-		.func = 2,
-		.route_offset = 0x184,
-		.route_val = BIT(16 + 10) | BIT(10),
-	}, {
-		/* uart3-rxm0 */
-		.bank_num = 0,
-		.pin = 17,
-		.func = 2,
-		.route_offset = 0x184,
-		.route_val = BIT(16 + 9),
-	}, {
-		/* uart3-rxm1 */
-		.bank_num = 1,
-		.pin = 15,
-		.func = 2,
-		.route_offset = 0x184,
-		.route_val = BIT(16 + 9) | BIT(9),
-	},
+	RK_MUXROUTE_SAME(2, RK_PA0, 1, 0x184, BIT(16 + 7)), /* cif-d2m0 */
+	RK_MUXROUTE_SAME(3, RK_PA3, 3, 0x184, BIT(16 + 7) | BIT(7)), /* cif-d2m1 */
+	RK_MUXROUTE_SAME(3, RK_PC6, 2, 0x184, BIT(16 + 8)), /* pdm-m0 */
+	RK_MUXROUTE_SAME(2, RK_PC6, 1, 0x184, BIT(16 + 8) | BIT(8)), /* pdm-m1 */
+	RK_MUXROUTE_SAME(1, RK_PD3, 2, 0x184, BIT(16 + 10)), /* uart2-rxm0 */
+	RK_MUXROUTE_SAME(2, RK_PB6, 2, 0x184, BIT(16 + 10) | BIT(10)), /* uart2-rxm1 */
+	RK_MUXROUTE_SAME(0, RK_PC1, 2, 0x184, BIT(16 + 9)), /* uart3-rxm0 */
+	RK_MUXROUTE_SAME(1, RK_PB7, 2, 0x184, BIT(16 + 9) | BIT(9)), /* uart3-rxm1 */
 };
 
 static struct rockchip_mux_route_data rk3128_mux_route_data[] = {
-	{
-		/* spi-0 */
-		.bank_num = 1,
-		.pin = 10,
-		.func = 1,
-		.route_offset = 0x144,
-		.route_val = BIT(16 + 3) | BIT(16 + 4),
-	}, {
-		/* spi-1 */
-		.bank_num = 1,
-		.pin = 27,
-		.func = 3,
-		.route_offset = 0x144,
-		.route_val = BIT(16 + 3) | BIT(16 + 4) | BIT(3),
-	}, {
-		/* spi-2 */
-		.bank_num = 0,
-		.pin = 13,
-		.func = 2,
-		.route_offset = 0x144,
-		.route_val = BIT(16 + 3) | BIT(16 + 4) | BIT(4),
-	}, {
-		/* i2s-0 */
-		.bank_num = 1,
-		.pin = 5,
-		.func = 1,
-		.route_offset = 0x144,
-		.route_val = BIT(16 + 5),
-	}, {
-		/* i2s-1 */
-		.bank_num = 0,
-		.pin = 14,
-		.func = 1,
-		.route_offset = 0x144,
-		.route_val = BIT(16 + 5) | BIT(5),
-	}, {
-		/* emmc-0 */
-		.bank_num = 1,
-		.pin = 22,
-		.func = 2,
-		.route_offset = 0x144,
-		.route_val = BIT(16 + 6),
-	}, {
-		/* emmc-1 */
-		.bank_num = 2,
-		.pin = 4,
-		.func = 2,
-		.route_offset = 0x144,
-		.route_val = BIT(16 + 6) | BIT(6),
-	},
+	RK_MUXROUTE_SAME(1, RK_PB2, 1, 0x144, BIT(16 + 3) | BIT(16 + 4)), /* spi-0 */
+	RK_MUXROUTE_SAME(1, RK_PD3, 3, 0x144, BIT(16 + 3) | BIT(16 + 4) | BIT(3)), /* spi-1 */
+	RK_MUXROUTE_SAME(0, RK_PB5, 2, 0x144, BIT(16 + 3) | BIT(16 + 4) | BIT(4)), /* spi-2 */
+	RK_MUXROUTE_SAME(1, RK_PA5, 1, 0x144, BIT(16 + 5)), /* i2s-0 */
+	RK_MUXROUTE_SAME(0, RK_PB6, 1, 0x144, BIT(16 + 5) | BIT(5)), /* i2s-1 */
+	RK_MUXROUTE_SAME(1, RK_PC6, 2, 0x144, BIT(16 + 6)), /* emmc-0 */
+	RK_MUXROUTE_SAME(2, RK_PA4, 2, 0x144, BIT(16 + 6) | BIT(6)), /* emmc-1 */
 };
 
 static struct rockchip_mux_route_data rk3188_mux_route_data[] = {
-	{
-		/* non-iomuxed emmc/flash pins on flash-dqs */
-		.bank_num = 0,
-		.pin = 24,
-		.func = 1,
-		.route_location = ROCKCHIP_ROUTE_GRF,
-		.route_offset = 0xa0,
-		.route_val = BIT(16 + 11),
-	}, {
-		/* non-iomuxed emmc/flash pins on emmc-clk */
-		.bank_num = 0,
-		.pin = 24,
-		.func = 2,
-		.route_location = ROCKCHIP_ROUTE_GRF,
-		.route_offset = 0xa0,
-		.route_val = BIT(16 + 11) | BIT(11),
-	},
+	RK_MUXROUTE_SAME(0, RK_PD0, 1, 0xa0, BIT(16 + 11)), /* non-iomuxed emmc/flash pins on flash-dqs */
+	RK_MUXROUTE_SAME(0, RK_PD0, 2, 0xa0, BIT(16 + 11) | BIT(11)), /* non-iomuxed emmc/flash pins on emmc-clk */
 };
 
 static struct rockchip_mux_route_data rk3228_mux_route_data[] = {
-	{
-		/* pwm0-0 */
-		.bank_num = 0,
-		.pin = 26,
-		.func = 1,
-		.route_offset = 0x50,
-		.route_val = BIT(16),
-	}, {
-		/* pwm0-1 */
-		.bank_num = 3,
-		.pin = 21,
-		.func = 1,
-		.route_offset = 0x50,
-		.route_val = BIT(16) | BIT(0),
-	}, {
-		/* pwm1-0 */
-		.bank_num = 0,
-		.pin = 27,
-		.func = 1,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 1),
-	}, {
-		/* pwm1-1 */
-		.bank_num = 0,
-		.pin = 30,
-		.func = 2,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 1) | BIT(1),
-	}, {
-		/* pwm2-0 */
-		.bank_num = 0,
-		.pin = 28,
-		.func = 1,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 2),
-	}, {
-		/* pwm2-1 */
-		.bank_num = 1,
-		.pin = 12,
-		.func = 2,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 2) | BIT(2),
-	}, {
-		/* pwm3-0 */
-		.bank_num = 3,
-		.pin = 26,
-		.func = 1,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 3),
-	}, {
-		/* pwm3-1 */
-		.bank_num = 1,
-		.pin = 11,
-		.func = 2,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 3) | BIT(3),
-	}, {
-		/* sdio-0_d0 */
-		.bank_num = 1,
-		.pin = 1,
-		.func = 1,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 4),
-	}, {
-		/* sdio-1_d0 */
-		.bank_num = 3,
-		.pin = 2,
-		.func = 1,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 4) | BIT(4),
-	}, {
-		/* spi-0_rx */
-		.bank_num = 0,
-		.pin = 13,
-		.func = 2,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 5),
-	}, {
-		/* spi-1_rx */
-		.bank_num = 2,
-		.pin = 0,
-		.func = 2,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 5) | BIT(5),
-	}, {
-		/* emmc-0_cmd */
-		.bank_num = 1,
-		.pin = 22,
-		.func = 2,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 7),
-	}, {
-		/* emmc-1_cmd */
-		.bank_num = 2,
-		.pin = 4,
-		.func = 2,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 7) | BIT(7),
-	}, {
-		/* uart2-0_rx */
-		.bank_num = 1,
-		.pin = 19,
-		.func = 2,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 8),
-	}, {
-		/* uart2-1_rx */
-		.bank_num = 1,
-		.pin = 10,
-		.func = 2,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 8) | BIT(8),
-	}, {
-		/* uart1-0_rx */
-		.bank_num = 1,
-		.pin = 10,
-		.func = 1,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 11),
-	}, {
-		/* uart1-1_rx */
-		.bank_num = 3,
-		.pin = 13,
-		.func = 1,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 11) | BIT(11),
-	},
+	RK_MUXROUTE_SAME(0, RK_PD2, 1, 0x50, BIT(16)), /* pwm0-0 */
+	RK_MUXROUTE_SAME(3, RK_PC5, 1, 0x50, BIT(16) | BIT(0)), /* pwm0-1 */
+	RK_MUXROUTE_SAME(0, RK_PD3, 1, 0x50, BIT(16 + 1)), /* pwm1-0 */
+	RK_MUXROUTE_SAME(0, RK_PD6, 2, 0x50, BIT(16 + 1) | BIT(1)), /* pwm1-1 */
+	RK_MUXROUTE_SAME(0, RK_PD4, 1, 0x50, BIT(16 + 2)), /* pwm2-0 */
+	RK_MUXROUTE_SAME(1, RK_PB4, 2, 0x50, BIT(16 + 2) | BIT(2)), /* pwm2-1 */
+	RK_MUXROUTE_SAME(3, RK_PD2, 1, 0x50, BIT(16 + 3)), /* pwm3-0 */
+	RK_MUXROUTE_SAME(1, RK_PB3, 2, 0x50, BIT(16 + 3) | BIT(3)), /* pwm3-1 */
+	RK_MUXROUTE_SAME(1, RK_PA1, 1, 0x50, BIT(16 + 4)), /* sdio-0_d0 */
+	RK_MUXROUTE_SAME(3, RK_PA2, 1, 0x50, BIT(16 + 4) | BIT(4)), /* sdio-1_d0 */
+	RK_MUXROUTE_SAME(0, RK_PB5, 2, 0x50, BIT(16 + 5)), /* spi-0_rx */
+	RK_MUXROUTE_SAME(2, RK_PA0, 2, 0x50, BIT(16 + 5) | BIT(5)), /* spi-1_rx */
+	RK_MUXROUTE_SAME(1, RK_PC6, 2, 0x50, BIT(16 + 7)), /* emmc-0_cmd */
+	RK_MUXROUTE_SAME(2, RK_PA4, 2, 0x50, BIT(16 + 7) | BIT(7)), /* emmc-1_cmd */
+	RK_MUXROUTE_SAME(1, RK_PC3, 2, 0x50, BIT(16 + 8)), /* uart2-0_rx */
+	RK_MUXROUTE_SAME(1, RK_PB2, 2, 0x50, BIT(16 + 8) | BIT(8)), /* uart2-1_rx */
+	RK_MUXROUTE_SAME(1, RK_PB2, 1, 0x50, BIT(16 + 11)), /* uart1-0_rx */
+	RK_MUXROUTE_SAME(3, RK_PB5, 1, 0x50, BIT(16 + 11) | BIT(11)), /* uart1-1_rx */
 };
 
 static struct rockchip_mux_route_data rk3288_mux_route_data[] = {
-	{
-		/* edphdmi_cecinoutt1 */
-		.bank_num = 7,
-		.pin = 16,
-		.func = 2,
-		.route_offset = 0x264,
-		.route_val = BIT(16 + 12) | BIT(12),
-	}, {
-		/* edphdmi_cecinout */
-		.bank_num = 7,
-		.pin = 23,
-		.func = 4,
-		.route_offset = 0x264,
-		.route_val = BIT(16 + 12),
-	},
+	RK_MUXROUTE_SAME(7, RK_PC0, 2, 0x264, BIT(16 + 12) | BIT(12)), /* edphdmi_cecinoutt1 */
+	RK_MUXROUTE_SAME(7, RK_PC7, 4, 0x264, BIT(16 + 12)), /* edphdmi_cecinout */
 };
 
 static struct rockchip_mux_route_data rk3308_mux_route_data[] = {
-	{
-		/* rtc_clk */
-		.bank_num = 0,
-		.pin = 19,
-		.func = 1,
-		.route_offset = 0x314,
-		.route_val = BIT(16 + 0) | BIT(0),
-	}, {
-		/* uart2_rxm0 */
-		.bank_num = 1,
-		.pin = 22,
-		.func = 2,
-		.route_offset = 0x314,
-		.route_val = BIT(16 + 2) | BIT(16 + 3),
-	}, {
-		/* uart2_rxm1 */
-		.bank_num = 4,
-		.pin = 26,
-		.func = 2,
-		.route_offset = 0x314,
-		.route_val = BIT(16 + 2) | BIT(16 + 3) | BIT(2),
-	}, {
-		/* i2c3_sdam0 */
-		.bank_num = 0,
-		.pin = 15,
-		.func = 2,
-		.route_offset = 0x608,
-		.route_val = BIT(16 + 8) | BIT(16 + 9),
-	}, {
-		/* i2c3_sdam1 */
-		.bank_num = 3,
-		.pin = 12,
-		.func = 2,
-		.route_offset = 0x608,
-		.route_val = BIT(16 + 8) | BIT(16 + 9) | BIT(8),
-	}, {
-		/* i2c3_sdam2 */
-		.bank_num = 2,
-		.pin = 0,
-		.func = 3,
-		.route_offset = 0x608,
-		.route_val = BIT(16 + 8) | BIT(16 + 9) | BIT(9),
-	}, {
-		/* i2s-8ch-1-sclktxm0 */
-		.bank_num = 1,
-		.pin = 3,
-		.func = 2,
-		.route_offset = 0x308,
-		.route_val = BIT(16 + 3),
-	}, {
-		/* i2s-8ch-1-sclkrxm0 */
-		.bank_num = 1,
-		.pin = 4,
-		.func = 2,
-		.route_offset = 0x308,
-		.route_val = BIT(16 + 3),
-	}, {
-		/* i2s-8ch-1-sclktxm1 */
-		.bank_num = 1,
-		.pin = 13,
-		.func = 2,
-		.route_offset = 0x308,
-		.route_val = BIT(16 + 3) | BIT(3),
-	}, {
-		/* i2s-8ch-1-sclkrxm1 */
-		.bank_num = 1,
-		.pin = 14,
-		.func = 2,
-		.route_offset = 0x308,
-		.route_val = BIT(16 + 3) | BIT(3),
-	}, {
-		/* pdm-clkm0 */
-		.bank_num = 1,
-		.pin = 4,
-		.func = 3,
-		.route_offset = 0x308,
-		.route_val =  BIT(16 + 12) | BIT(16 + 13),
-	}, {
-		/* pdm-clkm1 */
-		.bank_num = 1,
-		.pin = 14,
-		.func = 4,
-		.route_offset = 0x308,
-		.route_val = BIT(16 + 12) | BIT(16 + 13) | BIT(12),
-	}, {
-		/* pdm-clkm2 */
-		.bank_num = 2,
-		.pin = 6,
-		.func = 2,
-		.route_offset = 0x308,
-		.route_val = BIT(16 + 12) | BIT(16 + 13) | BIT(13),
-	}, {
-		/* pdm-clkm-m2 */
-		.bank_num = 2,
-		.pin = 4,
-		.func = 3,
-		.route_offset = 0x600,
-		.route_val = BIT(16 + 2) | BIT(2),
-	}, {
-		/* spi1_miso */
-		.bank_num = 3,
-		.pin = 10,
-		.func = 3,
-		.route_offset = 0x314,
-		.route_val = BIT(16 + 9),
-	}, {
-		/* spi1_miso_m1 */
-		.bank_num = 2,
-		.pin = 4,
-		.func = 2,
-		.route_offset = 0x314,
-		.route_val = BIT(16 + 9) | BIT(9),
-	}, {
-		/* owire_m0 */
-		.bank_num = 0,
-		.pin = 11,
-		.func = 3,
-		.route_offset = 0x314,
-		.route_val = BIT(16 + 10) | BIT(16 + 11),
-	}, {
-		/* owire_m1 */
-		.bank_num = 1,
-		.pin = 22,
-		.func = 7,
-		.route_offset = 0x314,
-		.route_val = BIT(16 + 10) | BIT(16 + 11) | BIT(10),
-	}, {
-		/* owire_m2 */
-		.bank_num = 2,
-		.pin = 2,
-		.func = 5,
-		.route_offset = 0x314,
-		.route_val = BIT(16 + 10) | BIT(16 + 11) | BIT(11),
-	}, {
-		/* can_rxd_m0 */
-		.bank_num = 0,
-		.pin = 11,
-		.func = 2,
-		.route_offset = 0x314,
-		.route_val = BIT(16 + 12) | BIT(16 + 13),
-	}, {
-		/* can_rxd_m1 */
-		.bank_num = 1,
-		.pin = 22,
-		.func = 5,
-		.route_offset = 0x314,
-		.route_val = BIT(16 + 12) | BIT(16 + 13) | BIT(12),
-	}, {
-		/* can_rxd_m2 */
-		.bank_num = 2,
-		.pin = 2,
-		.func = 4,
-		.route_offset = 0x314,
-		.route_val = BIT(16 + 12) | BIT(16 + 13) | BIT(13),
-	}, {
-		/* mac_rxd0_m0 */
-		.bank_num = 1,
-		.pin = 20,
-		.func = 3,
-		.route_offset = 0x314,
-		.route_val = BIT(16 + 14),
-	}, {
-		/* mac_rxd0_m1 */
-		.bank_num = 4,
-		.pin = 2,
-		.func = 2,
-		.route_offset = 0x314,
-		.route_val = BIT(16 + 14) | BIT(14),
-	}, {
-		/* uart3_rx */
-		.bank_num = 3,
-		.pin = 12,
-		.func = 4,
-		.route_offset = 0x314,
-		.route_val = BIT(16 + 15),
-	}, {
-		/* uart3_rx_m1 */
-		.bank_num = 0,
-		.pin = 17,
-		.func = 3,
-		.route_offset = 0x314,
-		.route_val = BIT(16 + 15) | BIT(15),
-	},
+	RK_MUXROUTE_SAME(0, RK_PC3, 1, 0x314, BIT(16 + 0) | BIT(0)), /* rtc_clk */
+	RK_MUXROUTE_SAME(1, RK_PC6, 2, 0x314, BIT(16 + 2) | BIT(16 + 3)), /* uart2_rxm0 */
+	RK_MUXROUTE_SAME(4, RK_PD2, 2, 0x314, BIT(16 + 2) | BIT(16 + 3) | BIT(2)), /* uart2_rxm1 */
+	RK_MUXROUTE_SAME(0, RK_PB7, 2, 0x608, BIT(16 + 8) | BIT(16 + 9)), /* i2c3_sdam0 */
+	RK_MUXROUTE_SAME(3, RK_PB4, 2, 0x608, BIT(16 + 8) | BIT(16 + 9) | BIT(8)), /* i2c3_sdam1 */
+	RK_MUXROUTE_SAME(2, RK_PA0, 3, 0x608, BIT(16 + 8) | BIT(16 + 9) | BIT(9)), /* i2c3_sdam2 */
+	RK_MUXROUTE_SAME(1, RK_PA3, 2, 0x308, BIT(16 + 3)), /* i2s-8ch-1-sclktxm0 */
+	RK_MUXROUTE_SAME(1, RK_PA4, 2, 0x308, BIT(16 + 3)), /* i2s-8ch-1-sclkrxm0 */
+	RK_MUXROUTE_SAME(1, RK_PB5, 2, 0x308, BIT(16 + 3) | BIT(3)), /* i2s-8ch-1-sclktxm1 */
+	RK_MUXROUTE_SAME(1, RK_PB6, 2, 0x308, BIT(16 + 3) | BIT(3)), /* i2s-8ch-1-sclkrxm1 */
+	RK_MUXROUTE_SAME(1, RK_PA4, 3, 0x308, BIT(16 + 12) | BIT(16 + 13)), /* pdm-clkm0 */
+	RK_MUXROUTE_SAME(1, RK_PB6, 4, 0x308, BIT(16 + 12) | BIT(16 + 13) | BIT(12)), /* pdm-clkm1 */
+	RK_MUXROUTE_SAME(2, RK_PA6, 2, 0x308, BIT(16 + 12) | BIT(16 + 13) | BIT(13)), /* pdm-clkm2 */
+	RK_MUXROUTE_SAME(2, RK_PA4, 3, 0x600, BIT(16 + 2) | BIT(2)), /* pdm-clkm-m2 */
+	RK_MUXROUTE_SAME(3, RK_PB2, 3, 0x314, BIT(16 + 9)), /* spi1_miso */
+	RK_MUXROUTE_SAME(2, RK_PA4, 2, 0x314, BIT(16 + 9) | BIT(9)), /* spi1_miso_m1 */
+	RK_MUXROUTE_SAME(0, RK_PB3, 3, 0x314, BIT(16 + 10) | BIT(16 + 11)), /* owire_m0 */
+	RK_MUXROUTE_SAME(1, RK_PC6, 7, 0x314, BIT(16 + 10) | BIT(16 + 11) | BIT(10)), /* owire_m1 */
+	RK_MUXROUTE_SAME(2, RK_PA2, 5, 0x314, BIT(16 + 10) | BIT(16 + 11) | BIT(11)), /* owire_m2 */
+	RK_MUXROUTE_SAME(0, RK_PB3, 2, 0x314, BIT(16 + 12) | BIT(16 + 13)), /* can_rxd_m0 */
+	RK_MUXROUTE_SAME(1, RK_PC6, 5, 0x314, BIT(16 + 12) | BIT(16 + 13) | BIT(12)), /* can_rxd_m1 */
+	RK_MUXROUTE_SAME(2, RK_PA2, 4, 0x314, BIT(16 + 12) | BIT(16 + 13) | BIT(13)), /* can_rxd_m2 */
+	RK_MUXROUTE_SAME(1, RK_PC4, 3, 0x314, BIT(16 + 14)), /* mac_rxd0_m0 */
+	RK_MUXROUTE_SAME(4, RK_PA2, 2, 0x314, BIT(16 + 14) | BIT(14)), /* mac_rxd0_m1 */
+	RK_MUXROUTE_SAME(3, RK_PB4, 4, 0x314, BIT(16 + 15)), /* uart3_rx */
+	RK_MUXROUTE_SAME(0, RK_PC1, 3, 0x314, BIT(16 + 15) | BIT(15)), /* uart3_rx_m1 */
 };
 
 static struct rockchip_mux_route_data rk3328_mux_route_data[] = {
-	{
-		/* uart2dbg_rxm0 */
-		.bank_num = 1,
-		.pin = 1,
-		.func = 2,
-		.route_offset = 0x50,
-		.route_val = BIT(16) | BIT(16 + 1),
-	}, {
-		/* uart2dbg_rxm1 */
-		.bank_num = 2,
-		.pin = 1,
-		.func = 1,
-		.route_offset = 0x50,
-		.route_val = BIT(16) | BIT(16 + 1) | BIT(0),
-	}, {
-		/* gmac-m1_rxd0 */
-		.bank_num = 1,
-		.pin = 11,
-		.func = 2,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 2) | BIT(2),
-	}, {
-		/* gmac-m1-optimized_rxd3 */
-		.bank_num = 1,
-		.pin = 14,
-		.func = 2,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 10) | BIT(10),
-	}, {
-		/* pdm_sdi0m0 */
-		.bank_num = 2,
-		.pin = 19,
-		.func = 2,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 3),
-	}, {
-		/* pdm_sdi0m1 */
-		.bank_num = 1,
-		.pin = 23,
-		.func = 3,
-		.route_offset = 0x50,
-		.route_val =  BIT(16 + 3) | BIT(3),
-	}, {
-		/* spi_rxdm2 */
-		.bank_num = 3,
-		.pin = 2,
-		.func = 4,
-		.route_offset = 0x50,
-		.route_val =  BIT(16 + 4) | BIT(16 + 5) | BIT(5),
-	}, {
-		/* i2s2_sdim0 */
-		.bank_num = 1,
-		.pin = 24,
-		.func = 1,
-		.route_offset = 0x50,
-		.route_val = BIT(16 + 6),
-	}, {
-		/* i2s2_sdim1 */
-		.bank_num = 3,
-		.pin = 2,
-		.func = 6,
-		.route_offset = 0x50,
-		.route_val =  BIT(16 + 6) | BIT(6),
-	}, {
-		/* card_iom1 */
-		.bank_num = 2,
-		.pin = 22,
-		.func = 3,
-		.route_offset = 0x50,
-		.route_val =  BIT(16 + 7) | BIT(7),
-	}, {
-		/* tsp_d5m1 */
-		.bank_num = 2,
-		.pin = 16,
-		.func = 3,
-		.route_offset = 0x50,
-		.route_val =  BIT(16 + 8) | BIT(8),
-	}, {
-		/* cif_data5m1 */
-		.bank_num = 2,
-		.pin = 16,
-		.func = 4,
-		.route_offset = 0x50,
-		.route_val =  BIT(16 + 9) | BIT(9),
-	},
+	RK_MUXROUTE_SAME(1, RK_PA1, 2, 0x50, BIT(16) | BIT(16 + 1)), /* uart2dbg_rxm0 */
+	RK_MUXROUTE_SAME(2, RK_PA1, 1, 0x50, BIT(16) | BIT(16 + 1) | BIT(0)), /* uart2dbg_rxm1 */
+	RK_MUXROUTE_SAME(1, RK_PB3, 2, 0x50, BIT(16 + 2) | BIT(2)), /* gmac-m1_rxd0 */
+	RK_MUXROUTE_SAME(1, RK_PB6, 2, 0x50, BIT(16 + 10) | BIT(10)), /* gmac-m1-optimized_rxd3 */
+	RK_MUXROUTE_SAME(2, RK_PC3, 2, 0x50, BIT(16 + 3)), /* pdm_sdi0m0 */
+	RK_MUXROUTE_SAME(1, RK_PC7, 3, 0x50, BIT(16 + 3) | BIT(3)), /* pdm_sdi0m1 */
+	RK_MUXROUTE_SAME(3, RK_PA2, 4, 0x50, BIT(16 + 4) | BIT(16 + 5) | BIT(5)), /* spi_rxdm2 */
+	RK_MUXROUTE_SAME(1, RK_PD0, 1, 0x50, BIT(16 + 6)), /* i2s2_sdim0 */
+	RK_MUXROUTE_SAME(3, RK_PA2, 6, 0x50, BIT(16 + 6) | BIT(6)), /* i2s2_sdim1 */
+	RK_MUXROUTE_SAME(2, RK_PC6, 3, 0x50, BIT(16 + 7) | BIT(7)), /* card_iom1 */
+	RK_MUXROUTE_SAME(2, RK_PC0, 3, 0x50, BIT(16 + 8) | BIT(8)), /* tsp_d5m1 */
+	RK_MUXROUTE_SAME(2, RK_PC0, 4, 0x50, BIT(16 + 9) | BIT(9)), /* cif_data5m1 */
 };
 
 static struct rockchip_mux_route_data rk3399_mux_route_data[] = {
-	{
-		/* uart2dbga_rx */
-		.bank_num = 4,
-		.pin = 8,
-		.func = 2,
-		.route_offset = 0xe21c,
-		.route_val = BIT(16 + 10) | BIT(16 + 11),
-	}, {
-		/* uart2dbgb_rx */
-		.bank_num = 4,
-		.pin = 16,
-		.func = 2,
-		.route_offset = 0xe21c,
-		.route_val = BIT(16 + 10) | BIT(16 + 11) | BIT(10),
-	}, {
-		/* uart2dbgc_rx */
-		.bank_num = 4,
-		.pin = 19,
-		.func = 1,
-		.route_offset = 0xe21c,
-		.route_val = BIT(16 + 10) | BIT(16 + 11) | BIT(11),
-	}, {
-		/* pcie_clkreqn */
-		.bank_num = 2,
-		.pin = 26,
-		.func = 2,
-		.route_offset = 0xe21c,
-		.route_val = BIT(16 + 14),
-	}, {
-		/* pcie_clkreqnb */
-		.bank_num = 4,
-		.pin = 24,
-		.func = 1,
-		.route_offset = 0xe21c,
-		.route_val = BIT(16 + 14) | BIT(14),
-	},
+	RK_MUXROUTE_SAME(4, RK_PB0, 2, 0xe21c, BIT(16 + 10) | BIT(16 + 11)), /* uart2dbga_rx */
+	RK_MUXROUTE_SAME(4, RK_PC0, 2, 0xe21c, BIT(16 + 10) | BIT(16 + 11) | BIT(10)), /* uart2dbgb_rx */
+	RK_MUXROUTE_SAME(4, RK_PC3, 1, 0xe21c, BIT(16 + 10) | BIT(16 + 11) | BIT(11)), /* uart2dbgc_rx */
+	RK_MUXROUTE_SAME(2, RK_PD2, 2, 0xe21c, BIT(16 + 14)), /* pcie_clkreqn */
+	RK_MUXROUTE_SAME(4, RK_PD0, 1, 0xe21c, BIT(16 + 14) | BIT(14)), /* pcie_clkreqnb */
+};
+
+static struct rockchip_mux_route_data rk3568_mux_route_data[] = {
+	RK_MUXROUTE_PMU(0, RK_PB7, 1, 0x0110, WRITE_MASK_VAL(1, 0, 0)), /* PWM0 IO mux M0 */
+	RK_MUXROUTE_PMU(0, RK_PC7, 2, 0x0110, WRITE_MASK_VAL(1, 0, 1)), /* PWM0 IO mux M1 */
+	RK_MUXROUTE_PMU(0, RK_PC0, 1, 0x0110, WRITE_MASK_VAL(3, 2, 0)), /* PWM1 IO mux M0 */
+	RK_MUXROUTE_PMU(0, RK_PB5, 4, 0x0110, WRITE_MASK_VAL(3, 2, 1)), /* PWM1 IO mux M1 */
+	RK_MUXROUTE_PMU(0, RK_PC1, 1, 0x0110, WRITE_MASK_VAL(5, 4, 0)), /* PWM2 IO mux M0 */
+	RK_MUXROUTE_PMU(0, RK_PB6, 4, 0x0110, WRITE_MASK_VAL(5, 4, 1)), /* PWM2 IO mux M1 */
+	RK_MUXROUTE_GRF(0, RK_PB3, 2, 0x0300, WRITE_MASK_VAL(0, 0, 0)), /* CAN0 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PA1, 4, 0x0300, WRITE_MASK_VAL(0, 0, 1)), /* CAN0 IO mux M1 */
+	RK_MUXROUTE_GRF(1, RK_PA1, 3, 0x0300, WRITE_MASK_VAL(2, 2, 0)), /* CAN1 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC3, 3, 0x0300, WRITE_MASK_VAL(2, 2, 1)), /* CAN1 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PB5, 3, 0x0300, WRITE_MASK_VAL(4, 4, 0)), /* CAN2 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PB2, 4, 0x0300, WRITE_MASK_VAL(4, 4, 1)), /* CAN2 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PC4, 1, 0x0300, WRITE_MASK_VAL(6, 6, 0)), /* HPDIN IO mux M0 */
+	RK_MUXROUTE_GRF(0, RK_PC2, 2, 0x0300, WRITE_MASK_VAL(6, 6, 1)), /* HPDIN IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PB1, 3, 0x0300, WRITE_MASK_VAL(8, 8, 0)), /* GMAC1 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PA7, 3, 0x0300, WRITE_MASK_VAL(8, 8, 1)), /* GMAC1 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PD1, 1, 0x0300, WRITE_MASK_VAL(10, 10, 0)), /* HDMITX IO mux M0 */
+	RK_MUXROUTE_GRF(0, RK_PC7, 1, 0x0300, WRITE_MASK_VAL(10, 10, 1)), /* HDMITX IO mux M1 */
+	RK_MUXROUTE_GRF(0, RK_PB6, 1, 0x0300, WRITE_MASK_VAL(14, 14, 0)), /* I2C2 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PB4, 1, 0x0300, WRITE_MASK_VAL(14, 14, 1)), /* I2C2 IO mux M1 */
+	RK_MUXROUTE_GRF(1, RK_PA0, 1, 0x0304, WRITE_MASK_VAL(0, 0, 0)), /* I2C3 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PB6, 4, 0x0304, WRITE_MASK_VAL(0, 0, 1)), /* I2C3 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PB2, 1, 0x0304, WRITE_MASK_VAL(2, 2, 0)), /* I2C4 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PB1, 2, 0x0304, WRITE_MASK_VAL(2, 2, 1)), /* I2C4 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PB4, 4, 0x0304, WRITE_MASK_VAL(4, 4, 0)), /* I2C5 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PD0, 2, 0x0304, WRITE_MASK_VAL(4, 4, 1)), /* I2C5 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PB1, 5, 0x0304, WRITE_MASK_VAL(14, 14, 0)), /* PWM8 IO mux M0 */
+	RK_MUXROUTE_GRF(1, RK_PD5, 4, 0x0304, WRITE_MASK_VAL(14, 14, 1)), /* PWM8 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PB2, 5, 0x0308, WRITE_MASK_VAL(0, 0, 0)), /* PWM9 IO mux M0 */
+	RK_MUXROUTE_GRF(1, RK_PD6, 4, 0x0308, WRITE_MASK_VAL(0, 0, 1)), /* PWM9 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PB5, 5, 0x0308, WRITE_MASK_VAL(2, 2, 0)), /* PWM10 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PA1, 2, 0x0308, WRITE_MASK_VAL(2, 2, 1)), /* PWM10 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PB6, 5, 0x0308, WRITE_MASK_VAL(4, 4, 0)), /* PWM11 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC0, 3, 0x0308, WRITE_MASK_VAL(4, 4, 1)), /* PWM11 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PB7, 2, 0x0308, WRITE_MASK_VAL(6, 6, 0)), /* PWM12 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC5, 1, 0x0308, WRITE_MASK_VAL(6, 6, 1)), /* PWM12 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PC0, 2, 0x0308, WRITE_MASK_VAL(8, 8, 0)), /* PWM13 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC6, 1, 0x0308, WRITE_MASK_VAL(8, 8, 1)), /* PWM13 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PC4, 1, 0x0308, WRITE_MASK_VAL(10, 10, 0)), /* PWM14 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC2, 1, 0x0308, WRITE_MASK_VAL(10, 10, 1)), /* PWM14 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PC5, 1, 0x0308, WRITE_MASK_VAL(12, 12, 0)), /* PWM15 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC3, 1, 0x0308, WRITE_MASK_VAL(12, 12, 1)), /* PWM15 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PD2, 3, 0x0308, WRITE_MASK_VAL(14, 14, 0)), /* SDMMC2 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PA5, 5, 0x0308, WRITE_MASK_VAL(14, 14, 1)), /* SDMMC2 IO mux M1 */
+	RK_MUXROUTE_GRF(0, RK_PB5, 2, 0x030c, WRITE_MASK_VAL(0, 0, 0)), /* SPI0 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PD3, 3, 0x030c, WRITE_MASK_VAL(0, 0, 1)), /* SPI0 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PB5, 3, 0x030c, WRITE_MASK_VAL(2, 2, 0)), /* SPI1 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PC3, 3, 0x030c, WRITE_MASK_VAL(2, 2, 1)), /* SPI1 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PC1, 4, 0x030c, WRITE_MASK_VAL(4, 4, 0)), /* SPI2 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PA0, 3, 0x030c, WRITE_MASK_VAL(4, 4, 1)), /* SPI2 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PB3, 4, 0x030c, WRITE_MASK_VAL(6, 6, 0)), /* SPI3 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC2, 2, 0x030c, WRITE_MASK_VAL(6, 6, 1)), /* SPI3 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PB4, 2, 0x030c, WRITE_MASK_VAL(8, 8, 0)), /* UART1 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PD6, 4, 0x030c, WRITE_MASK_VAL(8, 8, 1)), /* UART1 IO mux M1 */
+	RK_MUXROUTE_GRF(0, RK_PD1, 1, 0x030c, WRITE_MASK_VAL(10, 10, 0)), /* UART2 IO mux M0 */
+	RK_MUXROUTE_GRF(1, RK_PD5, 2, 0x030c, WRITE_MASK_VAL(10, 10, 1)), /* UART2 IO mux M1 */
+	RK_MUXROUTE_GRF(1, RK_PA1, 2, 0x030c, WRITE_MASK_VAL(12, 12, 0)), /* UART3 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PB7, 4, 0x030c, WRITE_MASK_VAL(12, 12, 1)), /* UART3 IO mux M1 */
+	RK_MUXROUTE_GRF(1, RK_PA6, 2, 0x030c, WRITE_MASK_VAL(14, 14, 0)), /* UART4 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PB2, 4, 0x030c, WRITE_MASK_VAL(14, 14, 1)), /* UART4 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PA2, 3, 0x0310, WRITE_MASK_VAL(0, 0, 0)), /* UART5 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PC2, 4, 0x0310, WRITE_MASK_VAL(0, 0, 1)), /* UART5 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PA4, 3, 0x0310, WRITE_MASK_VAL(2, 2, 0)), /* UART6 IO mux M0 */
+	RK_MUXROUTE_GRF(1, RK_PD5, 3, 0x0310, WRITE_MASK_VAL(2, 2, 1)), /* UART6 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PA6, 3, 0x0310, WRITE_MASK_VAL(5, 4, 0)), /* UART7 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PC4, 4, 0x0310, WRITE_MASK_VAL(5, 4, 1)), /* UART7 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PA2, 4, 0x0310, WRITE_MASK_VAL(5, 4, 2)), /* UART7 IO mux M2 */
+	RK_MUXROUTE_GRF(2, RK_PC5, 3, 0x0310, WRITE_MASK_VAL(6, 6, 0)), /* UART8 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PD7, 4, 0x0310, WRITE_MASK_VAL(6, 6, 1)), /* UART8 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PB0, 3, 0x0310, WRITE_MASK_VAL(9, 8, 0)), /* UART9 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC5, 4, 0x0310, WRITE_MASK_VAL(9, 8, 1)), /* UART9 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PA4, 4, 0x0310, WRITE_MASK_VAL(9, 8, 2)), /* UART9 IO mux M2 */
+	RK_MUXROUTE_GRF(1, RK_PA2, 1, 0x0310, WRITE_MASK_VAL(11, 10, 0)), /* I2S1 IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PC6, 4, 0x0310, WRITE_MASK_VAL(11, 10, 1)), /* I2S1 IO mux M1 */
+	RK_MUXROUTE_GRF(2, RK_PD0, 5, 0x0310, WRITE_MASK_VAL(11, 10, 2)), /* I2S1 IO mux M2 */
+	RK_MUXROUTE_GRF(2, RK_PC1, 1, 0x0310, WRITE_MASK_VAL(12, 12, 0)), /* I2S2 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PB6, 5, 0x0310, WRITE_MASK_VAL(12, 12, 1)), /* I2S2 IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PA2, 4, 0x0310, WRITE_MASK_VAL(14, 14, 0)), /* I2S3 IO mux M0 */
+	RK_MUXROUTE_GRF(4, RK_PC2, 5, 0x0310, WRITE_MASK_VAL(14, 14, 1)), /* I2S3 IO mux M1 */
+	RK_MUXROUTE_GRF(1, RK_PA4, 3, 0x0314, WRITE_MASK_VAL(1, 0, 0)), /* PDM IO mux M0 */
+	RK_MUXROUTE_GRF(1, RK_PA6, 3, 0x0314, WRITE_MASK_VAL(1, 0, 0)), /* PDM IO mux M0 */
+	RK_MUXROUTE_GRF(3, RK_PD6, 5, 0x0314, WRITE_MASK_VAL(1, 0, 1)), /* PDM IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PA0, 4, 0x0314, WRITE_MASK_VAL(1, 0, 1)), /* PDM IO mux M1 */
+	RK_MUXROUTE_GRF(3, RK_PC4, 5, 0x0314, WRITE_MASK_VAL(1, 0, 2)), /* PDM IO mux M2 */
+	RK_MUXROUTE_GRF(0, RK_PA5, 3, 0x0314, WRITE_MASK_VAL(3, 2, 0)), /* PCIE20 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PD0, 4, 0x0314, WRITE_MASK_VAL(3, 2, 1)), /* PCIE20 IO mux M1 */
+	RK_MUXROUTE_GRF(1, RK_PB0, 4, 0x0314, WRITE_MASK_VAL(3, 2, 2)), /* PCIE20 IO mux M2 */
+	RK_MUXROUTE_GRF(0, RK_PA4, 3, 0x0314, WRITE_MASK_VAL(5, 4, 0)), /* PCIE30X1 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PD2, 4, 0x0314, WRITE_MASK_VAL(5, 4, 1)), /* PCIE30X1 IO mux M1 */
+	RK_MUXROUTE_GRF(1, RK_PA5, 4, 0x0314, WRITE_MASK_VAL(5, 4, 2)), /* PCIE30X1 IO mux M2 */
+	RK_MUXROUTE_GRF(0, RK_PA6, 2, 0x0314, WRITE_MASK_VAL(7, 6, 0)), /* PCIE30X2 IO mux M0 */
+	RK_MUXROUTE_GRF(2, RK_PD4, 4, 0x0314, WRITE_MASK_VAL(7, 6, 1)), /* PCIE30X2 IO mux M1 */
+	RK_MUXROUTE_GRF(4, RK_PC2, 4, 0x0314, WRITE_MASK_VAL(7, 6, 2)), /* PCIE30X2 IO mux M2 */
 };
 
 static bool rockchip_get_mux_route(struct rockchip_pin_bank *bank, int pin,
@@ -2117,6 +1751,68 @@ static void rk3399_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
 		*bit = (pin_num % 8) * 2;
 }
 
+#define RK3568_PULL_PMU_OFFSET		0x20
+#define RK3568_PULL_GRF_OFFSET		0x80
+#define RK3568_PULL_BITS_PER_PIN	2
+#define RK3568_PULL_PINS_PER_REG	8
+#define RK3568_PULL_BANK_STRIDE		0x10
+
+static void rk3568_calc_pull_reg_and_bit(struct rockchip_pin_bank *bank,
+					 int pin_num, struct regmap **regmap,
+					 int *reg, u8 *bit)
+{
+	struct rockchip_pinctrl *info = bank->drvdata;
+
+	if (bank->bank_num == 0) {
+		*regmap = info->regmap_pmu;
+		*reg = RK3568_PULL_PMU_OFFSET;
+		*reg += bank->bank_num * RK3568_PULL_BANK_STRIDE;
+		*reg += ((pin_num / RK3568_PULL_PINS_PER_REG) * 4);
+
+		*bit = pin_num % RK3568_PULL_PINS_PER_REG;
+		*bit *= RK3568_PULL_BITS_PER_PIN;
+	} else {
+		*regmap = info->regmap_base;
+		*reg = RK3568_PULL_GRF_OFFSET;
+		*reg += (bank->bank_num - 1) * RK3568_PULL_BANK_STRIDE;
+		*reg += ((pin_num / RK3568_PULL_PINS_PER_REG) * 4);
+
+		*bit = (pin_num % RK3568_PULL_PINS_PER_REG);
+		*bit *= RK3568_PULL_BITS_PER_PIN;
+	}
+}
+
+#define RK3568_DRV_PMU_OFFSET		0x70
+#define RK3568_DRV_GRF_OFFSET		0x200
+#define RK3568_DRV_BITS_PER_PIN		8
+#define RK3568_DRV_PINS_PER_REG		2
+#define RK3568_DRV_BANK_STRIDE		0x40
+
+static void rk3568_calc_drv_reg_and_bit(struct rockchip_pin_bank *bank,
+					int pin_num, struct regmap **regmap,
+					int *reg, u8 *bit)
+{
+	struct rockchip_pinctrl *info = bank->drvdata;
+
+	/* The first 32 pins of the first bank are located in PMU */
+	if (bank->bank_num == 0) {
+		*regmap = info->regmap_pmu;
+		*reg = RK3568_DRV_PMU_OFFSET;
+		*reg += ((pin_num / RK3568_DRV_PINS_PER_REG) * 4);
+
+		*bit = pin_num % RK3568_DRV_PINS_PER_REG;
+		*bit *= RK3568_DRV_BITS_PER_PIN;
+	} else {
+		*regmap = info->regmap_base;
+		*reg = RK3568_DRV_GRF_OFFSET;
+		*reg += (bank->bank_num - 1) * RK3568_DRV_BANK_STRIDE;
+		*reg += ((pin_num / RK3568_DRV_PINS_PER_REG) * 4);
+
+		*bit = (pin_num % RK3568_DRV_PINS_PER_REG);
+		*bit *= RK3568_DRV_BITS_PER_PIN;
+	}
+}
+
 static int rockchip_perpin_drv_list[DRV_TYPE_MAX][8] = {
 	{ 2, 4, 8, 12, -1, -1, -1, -1 },
 	{ 3, 6, 9, 12, -1, -1, -1, -1 },
@@ -2217,6 +1913,11 @@ static int rockchip_set_drive_perpin(struct rockchip_pin_bank *bank,
 		bank->bank_num, pin_num, strength);
 
 	ctrl->drv_calc_reg(bank, pin_num, &regmap, &reg, &bit);
+	if (ctrl->type == RK3568) {
+		rmask_bits = RK3568_DRV_BITS_PER_PIN;
+		ret = (1 << (strength + 1)) - 1;
+		goto config;
+	}
 
 	ret = -EINVAL;
 	for (i = 0; i < ARRAY_SIZE(rockchip_perpin_drv_list[drv_type]); i++) {
@@ -2286,6 +1987,7 @@ static int rockchip_set_drive_perpin(struct rockchip_pin_bank *bank,
 		return -EINVAL;
 	}
 
+config:
 	/* enable the write to the equivalent lower bits */
 	data = ((1 << rmask_bits) - 1) << (bit + 16);
 	rmask = data | (data >> 16);
@@ -2343,9 +2045,18 @@ static int rockchip_get_pull(struct rockchip_pin_bank *bank, int pin_num)
 	case RK3308:
 	case RK3368:
 	case RK3399:
+	case RK3568:
 		pull_type = bank->pull_type[pin_num / 8];
 		data >>= bit;
 		data &= (1 << RK3188_PULL_BITS_PER_PIN) - 1;
+		/*
+		 * In the TRM, pull-up being 1 for everything except the GPIO0_D3-D6,
+		 * where that pull up value becomes 3.
+		 */
+		if (ctrl->type == RK3568 && bank->bank_num == 0 && pin_num >= 27 && pin_num <= 30) {
+			if (data == 3)
+				data = 1;
+		}
 
 		return rockchip_pull_list[pull_type][data];
 	default:
@@ -2388,6 +2099,7 @@ static int rockchip_set_pull(struct rockchip_pin_bank *bank,
 	case RK3308:
 	case RK3368:
 	case RK3399:
+	case RK3568:
 		pull_type = bank->pull_type[pin_num / 8];
 		ret = -EINVAL;
 		for (i = 0; i < ARRAY_SIZE(rockchip_pull_list[pull_type]);
@@ -2397,6 +2109,14 @@ static int rockchip_set_pull(struct rockchip_pin_bank *bank,
 				break;
 			}
 		}
+		/*
+		 * In the TRM, pull-up being 1 for everything except the GPIO0_D3-D6,
+		 * where that pull up value becomes 3.
+		 */
+		if (ctrl->type == RK3568 && bank->bank_num == 0 && pin_num >= 27 && pin_num <= 30) {
+			if (ret == 1)
+				ret = 3;
+		}
 
 		if (ret < 0) {
 			dev_err(info->dev, "unsupported pull setting %d\n",
@@ -2441,6 +2161,35 @@ static int rk3328_calc_schmitt_reg_and_bit(struct rockchip_pin_bank *bank,
 	return 0;
 }
 
+#define RK3568_SCHMITT_BITS_PER_PIN		2
+#define RK3568_SCHMITT_PINS_PER_REG		8
+#define RK3568_SCHMITT_BANK_STRIDE		0x10
+#define RK3568_SCHMITT_GRF_OFFSET		0xc0
+#define RK3568_SCHMITT_PMUGRF_OFFSET		0x30
+
+static int rk3568_calc_schmitt_reg_and_bit(struct rockchip_pin_bank *bank,
+					   int pin_num,
+					   struct regmap **regmap,
+					   int *reg, u8 *bit)
+{
+	struct rockchip_pinctrl *info = bank->drvdata;
+
+	if (bank->bank_num == 0) {
+		*regmap = info->regmap_pmu;
+		*reg = RK3568_SCHMITT_PMUGRF_OFFSET;
+	} else {
+		*regmap = info->regmap_base;
+		*reg = RK3568_SCHMITT_GRF_OFFSET;
+		*reg += (bank->bank_num - 1) * RK3568_SCHMITT_BANK_STRIDE;
+	}
+
+	*reg += ((pin_num / RK3568_SCHMITT_PINS_PER_REG) * 4);
+	*bit = pin_num % RK3568_SCHMITT_PINS_PER_REG;
+	*bit *= RK3568_SCHMITT_BITS_PER_PIN;
+
+	return 0;
+}
+
 static int rockchip_get_schmitt(struct rockchip_pin_bank *bank, int pin_num)
 {
 	struct rockchip_pinctrl *info = bank->drvdata;
@@ -2459,6 +2208,13 @@ static int rockchip_get_schmitt(struct rockchip_pin_bank *bank, int pin_num)
 		return ret;
 
 	data >>= bit;
+	switch (ctrl->type) {
+	case RK3568:
+		return data & ((1 << RK3568_SCHMITT_BITS_PER_PIN) - 1);
+	default:
+		break;
+	}
+
 	return data & 0x1;
 }
 
@@ -2480,8 +2236,17 @@ static int rockchip_set_schmitt(struct rockchip_pin_bank *bank,
 		return ret;
 
 	/* enable the write to the equivalent lower bits */
-	data = BIT(bit + 16) | (enable << bit);
-	rmask = BIT(bit + 16) | BIT(bit);
+	switch (ctrl->type) {
+	case RK3568:
+		data = ((1 << RK3568_SCHMITT_BITS_PER_PIN) - 1) << (bit + 16);
+		rmask = data | (data >> 16);
+		data |= ((enable ? 0x2 : 0x1) << bit);
+		break;
+	default:
+		data = BIT(bit + 16) | (enable << bit);
+		rmask = BIT(bit + 16) | BIT(bit);
+		break;
+	}
 
 	return regmap_update_bits(regmap, reg, rmask, data);
 }
@@ -2655,6 +2420,7 @@ static bool rockchip_pinconf_pull_valid(struct rockchip_pin_ctrl *ctrl,
 	case RK3308:
 	case RK3368:
 	case RK3399:
+	case RK3568:
 		return (pull != PIN_CONFIG_BIAS_PULL_PIN_DEFAULT);
 	}
 
@@ -2893,6 +2659,7 @@ static int rockchip_pinctrl_parse_groups(struct device_node *np,
 		np_config = of_find_node_by_phandle(be32_to_cpup(phandle));
 		ret = pinconf_generic_parse_dt_config(np_config, NULL,
 				&grp->data[j].configs, &grp->data[j].nconfigs);
+		of_node_put(np_config);
 		if (ret)
 			return ret;
 	}
@@ -4230,6 +3997,45 @@ static struct rockchip_pin_ctrl rk3399_pin_ctrl = {
 		.drv_calc_reg		= rk3399_calc_drv_reg_and_bit,
 };
 
+static struct rockchip_pin_bank rk3568_pin_banks[] = {
+	PIN_BANK_IOMUX_FLAGS(0, 32, "gpio0", IOMUX_SOURCE_PMU | IOMUX_WIDTH_4BIT,
+					     IOMUX_SOURCE_PMU | IOMUX_WIDTH_4BIT,
+					     IOMUX_SOURCE_PMU | IOMUX_WIDTH_4BIT,
+					     IOMUX_SOURCE_PMU | IOMUX_WIDTH_4BIT),
+	PIN_BANK_IOMUX_FLAGS(1, 32, "gpio1", IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT),
+	PIN_BANK_IOMUX_FLAGS(2, 32, "gpio2", IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT),
+	PIN_BANK_IOMUX_FLAGS(3, 32, "gpio3", IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT),
+	PIN_BANK_IOMUX_FLAGS(4, 32, "gpio4", IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT,
+					     IOMUX_WIDTH_4BIT),
+};
+
+static struct rockchip_pin_ctrl rk3568_pin_ctrl = {
+	.pin_banks		= rk3568_pin_banks,
+	.nr_banks		= ARRAY_SIZE(rk3568_pin_banks),
+	.label			= "RK3568-GPIO",
+	.type			= RK3568,
+	.grf_mux_offset		= 0x0,
+	.pmu_mux_offset		= 0x0,
+	.grf_drv_offset		= 0x0200,
+	.pmu_drv_offset		= 0x0070,
+	.iomux_routes		= rk3568_mux_route_data,
+	.niomux_routes		= ARRAY_SIZE(rk3568_mux_route_data),
+	.pull_calc_reg		= rk3568_calc_pull_reg_and_bit,
+	.drv_calc_reg		= rk3568_calc_drv_reg_and_bit,
+	.schmitt_calc_reg	= rk3568_calc_schmitt_reg_and_bit,
+};
+
 static const struct of_device_id rockchip_pinctrl_dt_match[] = {
 	{ .compatible = "rockchip,px30-pinctrl",
 		.data = &px30_pin_ctrl },
@@ -4259,6 +4065,8 @@ static const struct of_device_id rockchip_pinctrl_dt_match[] = {
 		.data = &rk3368_pin_ctrl },
 	{ .compatible = "rockchip,rk3399-pinctrl",
 		.data = &rk3399_pin_ctrl },
+	{ .compatible = "rockchip,rk3568-pinctrl",
+		.data = &rk3568_pin_ctrl },
 	{},
 };
 
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
index 60406f1f8337..2d852f15cc50 100644
--- a/drivers/pinctrl/stm32/pinctrl-stm32.c
+++ b/drivers/pinctrl/stm32/pinctrl-stm32.c
@@ -1338,6 +1338,7 @@ static struct irq_domain *stm32_pctrl_get_irq_domain(struct device_node *np)
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
index 12e9e23272ab..52a55bae033d 100644
--- a/drivers/pwm/pwm-sifive.c
+++ b/drivers/pwm/pwm-sifive.c
@@ -41,7 +41,7 @@
 
 struct pwm_sifive_ddata {
 	struct pwm_chip	chip;
-	struct mutex lock; /* lock to protect user_count */
+	struct mutex lock; /* lock to protect user_count and approx_period */
 	struct notifier_block notifier;
 	struct clk *clk;
 	void __iomem *regs;
@@ -76,6 +76,7 @@ static void pwm_sifive_free(struct pwm_chip *chip, struct pwm_device *pwm)
 	mutex_unlock(&ddata->lock);
 }
 
+/* Called holding ddata->lock */
 static void pwm_sifive_update_clock(struct pwm_sifive_ddata *ddata,
 				    unsigned long rate)
 {
@@ -163,7 +164,6 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 		return ret;
 	}
 
-	mutex_lock(&ddata->lock);
 	cur_state = pwm->state;
 	enabled = cur_state.enabled;
 
@@ -182,14 +182,23 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
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
 
 	writel(frac, ddata->regs + PWM_SIFIVE_PWMCMP(pwm->hwpwm));
 
@@ -198,7 +207,6 @@ static int pwm_sifive_apply(struct pwm_chip *chip, struct pwm_device *pwm,
 
 exit:
 	clk_disable(ddata->clk);
-	mutex_unlock(&ddata->lock);
 	return ret;
 }
 
diff --git a/drivers/pwm/pwm-stm32-lp.c b/drivers/pwm/pwm-stm32-lp.c
index 945a8b2b8564..c8a847fcb775 100644
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
index 1b3aa84e36e7..3d975ecd9336 100644
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
@@ -190,6 +191,9 @@ struct q6v5 {
 	size_t mba_size;
 	size_t dp_size;
 
+	phys_addr_t mdata_phys;
+	size_t mdata_size;
+
 	phys_addr_t mpss_phys;
 	phys_addr_t mpss_reloc;
 	size_t mpss_size;
@@ -816,15 +820,35 @@ static int q6v5_mpss_init_image(struct q6v5 *qproc, const struct firmware *fw)
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
@@ -853,7 +877,9 @@ static int q6v5_mpss_init_image(struct q6v5 *qproc, const struct firmware *fw)
 			 "mdt buffer not reclaimed system may become unstable\n");
 
 free_dma_attrs:
-	dma_free_attrs(qproc->dev, size, ptr, phys, dma_attrs);
+	if (!qproc->mdata_phys)
+		dma_free_attrs(qproc->dev, size, ptr, phys, dma_attrs);
+free_metadata:
 	kfree(metadata);
 
 	return ret < 0 ? ret : 0;
@@ -1585,6 +1611,7 @@ static int q6v5_init_reset(struct q6v5 *qproc)
 static int q6v5_alloc_memory_region(struct q6v5 *qproc)
 {
 	struct device_node *child;
+	struct reserved_mem *rmem;
 	struct device_node *node;
 	struct resource r;
 	int ret;
@@ -1637,6 +1664,26 @@ static int q6v5_alloc_memory_region(struct q6v5 *qproc)
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
index 7cbed0310c09..98b6d4c09c82 100644
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
index b45ee2cb2c04..3417eef0aca3 100644
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
index 52b36b7c6129..a72856fb5252 100644
--- a/drivers/rtc/rtc-sun6i.c
+++ b/drivers/rtc/rtc-sun6i.c
@@ -128,7 +128,6 @@ struct sun6i_rtc_clk_data {
 	unsigned int fixed_prescaler : 16;
 	unsigned int has_prescaler : 1;
 	unsigned int has_out_clk : 1;
-	unsigned int export_iosc : 1;
 	unsigned int has_losc_en : 1;
 	unsigned int has_auto_swt : 1;
 };
@@ -260,10 +259,8 @@ static void __init sun6i_rtc_clk_init(struct device_node *node,
 	/* Yes, I know, this is ugly. */
 	sun6i_rtc = rtc;
 
-	/* Only read IOSC name from device tree if it is exported */
-	if (rtc->data->export_iosc)
-		of_property_read_string_index(node, "clock-output-names", 2,
-					      &iosc_name);
+	of_property_read_string_index(node, "clock-output-names", 2,
+				      &iosc_name);
 
 	rtc->int_osc = clk_hw_register_fixed_rate_with_accuracy(NULL,
 								iosc_name,
@@ -304,13 +301,10 @@ static void __init sun6i_rtc_clk_init(struct device_node *node,
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
 
@@ -350,7 +344,6 @@ static const struct sun6i_rtc_clk_data sun8i_h3_rtc_data = {
 	.fixed_prescaler = 32,
 	.has_prescaler = 1,
 	.has_out_clk = 1,
-	.export_iosc = 1,
 };
 
 static void __init sun8i_h3_rtc_clk_init(struct device_node *node)
@@ -368,7 +361,6 @@ static const struct sun6i_rtc_clk_data sun50i_h6_rtc_data = {
 	.fixed_prescaler = 32,
 	.has_prescaler = 1,
 	.has_out_clk = 1,
-	.export_iosc = 1,
 	.has_losc_en = 1,
 	.has_auto_swt = 1,
 };
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index f4edfe383e9d..9f26f55e4988 100644
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
index a5e6fbd86ad4..8c376736a8f5 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -1516,23 +1516,22 @@ static void ipr_process_ccn(struct ipr_cmnd *ipr_cmd)
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
@@ -1547,19 +1546,21 @@ static int strip_and_pad_whitespace(int i, char *buf)
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
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index c1b76cda60db..26b15a24300e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2822,19 +2822,25 @@ static int
 _base_config_dma_addressing(struct MPT3SAS_ADAPTER *ioc, struct pci_dev *pdev)
 {
 	struct sysinfo s;
+	u64 coherent_dma_mask, dma_mask;
 
-	if (ioc->is_mcpu_endpoint ||
-	    sizeof(dma_addr_t) == 4 || ioc->use_32bit_dma ||
-	    dma_get_required_mask(&pdev->dev) <= DMA_BIT_MASK(32))
+	if (ioc->is_mcpu_endpoint || sizeof(dma_addr_t) == 4) {
 		ioc->dma_mask = 32;
+		coherent_dma_mask = dma_mask = DMA_BIT_MASK(32);
 	/* Set 63 bit DMA mask for all SAS3 and SAS35 controllers */
-	else if (ioc->hba_mpi_version_belonged > MPI2_VERSION)
+	} else if (ioc->hba_mpi_version_belonged > MPI2_VERSION) {
 		ioc->dma_mask = 63;
-	else
+		coherent_dma_mask = dma_mask = DMA_BIT_MASK(63);
+	} else {
 		ioc->dma_mask = 64;
+		coherent_dma_mask = dma_mask = DMA_BIT_MASK(64);
+	}
 
-	if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(ioc->dma_mask)) ||
-	    dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(ioc->dma_mask)))
+	if (ioc->use_32bit_dma)
+		coherent_dma_mask = DMA_BIT_MASK(32);
+
+	if (dma_set_mask(&pdev->dev, dma_mask) ||
+	    dma_set_coherent_mask(&pdev->dev, coherent_dma_mask))
 		return -ENODEV;
 
 	if (ioc->dma_mask > 32) {
@@ -4905,6 +4911,9 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		}
 		dma_pool_destroy(ioc->pcie_sgl_dma_pool);
 	}
+	kfree(ioc->pcie_sg_lookup);
+	ioc->pcie_sg_lookup = NULL;
+
 	if (ioc->config_page) {
 		dexitprintk(ioc,
 			    ioc_info(ioc, "config_page(0x%p): free\n",
diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index d63ccdf6e988..695dd89be330 100644
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
@@ -336,13 +323,10 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
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
@@ -350,7 +334,6 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
 		wake_up(&sp->nvme_ls_waitq);
 		sp->priv = NULL;
 		priv->sp = NULL;
-		qla_nvme_ls_unmap(sp, fd);
 		qla2x00_rel_sp(sp);
 		return rval;
 	}
diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
index 419156121cb5..e1132970f189 100644
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -6899,9 +6899,12 @@ qla2x00_do_dpc(void *data)
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
 
@@ -7145,7 +7148,7 @@ qla2x00_timer(struct timer_list *t)
 
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
diff --git a/drivers/soundwire/cadence_master.c b/drivers/soundwire/cadence_master.c
index a3247692ddc0..18e7d158fcca 100644
--- a/drivers/soundwire/cadence_master.c
+++ b/drivers/soundwire/cadence_master.c
@@ -511,6 +511,29 @@ cdns_fill_msg_resp(struct sdw_cdns *cdns,
 	return SDW_CMD_OK;
 }
 
+static void cdns_read_response(struct sdw_cdns *cdns)
+{
+	u32 num_resp, cmd_base;
+	int i;
+
+	/* RX_FIFO_AVAIL can be 2 entries more than the FIFO size */
+	BUILD_BUG_ON(ARRAY_SIZE(cdns->response_buf) < CDNS_MCP_CMD_LEN + 2);
+
+	num_resp = cdns_readl(cdns, CDNS_MCP_FIFOSTAT);
+	num_resp &= CDNS_MCP_RX_FIFO_AVAIL;
+	if (num_resp > ARRAY_SIZE(cdns->response_buf)) {
+		dev_warn(cdns->dev, "RX AVAIL %d too long\n", num_resp);
+		num_resp = ARRAY_SIZE(cdns->response_buf);
+	}
+
+	cmd_base = CDNS_MCP_CMD_BASE;
+
+	for (i = 0; i < num_resp; i++) {
+		cdns->response_buf[i] = cdns_readl(cdns, cmd_base);
+		cmd_base += CDNS_MCP_CMD_WORD_LEN;
+	}
+}
+
 static enum sdw_command_response
 _cdns_xfer_msg(struct sdw_cdns *cdns, struct sdw_msg *msg, int cmd,
 	       int offset, int count, bool defer)
@@ -552,6 +575,10 @@ _cdns_xfer_msg(struct sdw_cdns *cdns, struct sdw_msg *msg, int cmd,
 		dev_err(cdns->dev, "IO transfer timed out, cmd %d device %d addr %x len %d\n",
 			cmd, msg->dev_num, msg->addr, msg->len);
 		msg->len = 0;
+
+		/* Drain anything in the RX_FIFO */
+		cdns_read_response(cdns);
+
 		return SDW_CMD_TIMEOUT;
 	}
 
@@ -720,22 +747,6 @@ EXPORT_SYMBOL(cdns_reset_page_addr);
  * IRQ handling
  */
 
-static void cdns_read_response(struct sdw_cdns *cdns)
-{
-	u32 num_resp, cmd_base;
-	int i;
-
-	num_resp = cdns_readl(cdns, CDNS_MCP_FIFOSTAT);
-	num_resp &= CDNS_MCP_RX_FIFO_AVAIL;
-
-	cmd_base = CDNS_MCP_CMD_BASE;
-
-	for (i = 0; i < num_resp; i++) {
-		cdns->response_buf[i] = cdns_readl(cdns, cmd_base);
-		cmd_base += CDNS_MCP_CMD_WORD_LEN;
-	}
-}
-
 static int cdns_update_slave_status(struct sdw_cdns *cdns,
 				    u32 slave0, u32 slave1)
 {
diff --git a/drivers/soundwire/cadence_master.h b/drivers/soundwire/cadence_master.h
index 4d1aab5b5ec2..e7f0108d417c 100644
--- a/drivers/soundwire/cadence_master.h
+++ b/drivers/soundwire/cadence_master.h
@@ -8,6 +8,12 @@
 #define SDW_CADENCE_GSYNC_KHZ		4 /* 4 kHz */
 #define SDW_CADENCE_GSYNC_HZ		(SDW_CADENCE_GSYNC_KHZ * 1000)
 
+/*
+ * The Cadence IP supports up to 32 entries in the FIFO, though implementations
+ * can configure the IP to have a smaller FIFO.
+ */
+#define CDNS_MCP_IP_MAX_CMD_LEN		32
+
 /**
  * struct sdw_cdns_pdi: PDI (Physical Data Interface) instance
  *
@@ -119,7 +125,12 @@ struct sdw_cdns {
 	struct sdw_bus bus;
 	unsigned int instance;
 
-	u32 response_buf[0x80];
+	/*
+	 * The datasheet says the RX FIFO AVAIL can be 2 entries more
+	 * than the FIFO capacity, so allow for this.
+	 */
+	u32 response_buf[CDNS_MCP_IP_MAX_CMD_LEN + 2];
+
 	struct completion tx_complete;
 	struct sdw_defer *defer;
 
diff --git a/drivers/spi/Kconfig b/drivers/spi/Kconfig
index aadaea052f51..4d98ce7571df 100644
--- a/drivers/spi/Kconfig
+++ b/drivers/spi/Kconfig
@@ -256,7 +256,6 @@ config SPI_DW_BT1
 	tristate "Baikal-T1 SPI driver for DW SPI core"
 	depends on MIPS_BAIKAL_T1 || COMPILE_TEST
 	select MULTIPLEXER
-	select MUX_MMIO
 	help
 	  Baikal-T1 SoC is equipped with three DW APB SSI-based MMIO SPI
 	  controllers. Two of them are pretty much normal: with IRQ, DMA,
diff --git a/drivers/spi/spi-bcm63xx-hsspi.c b/drivers/spi/spi-bcm63xx-hsspi.c
index 1f08d7553f07..02f56fc001b4 100644
--- a/drivers/spi/spi-bcm63xx-hsspi.c
+++ b/drivers/spi/spi-bcm63xx-hsspi.c
@@ -21,6 +21,7 @@
 #include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/reset.h>
+#include <linux/pm_runtime.h>
 
 #define HSSPI_GLOBAL_CTRL_REG			0x0
 #define GLOBAL_CTRL_CS_POLARITY_SHIFT		0
@@ -162,6 +163,7 @@ static int bcm63xx_hsspi_do_txrx(struct spi_device *spi, struct spi_transfer *t)
 	int step_size = HSSPI_BUFFER_LEN;
 	const u8 *tx = t->tx_buf;
 	u8 *rx = t->rx_buf;
+	u32 val = 0;
 
 	bcm63xx_hsspi_set_clk(bs, spi, t->speed_hz);
 	bcm63xx_hsspi_set_cs(bs, spi->chip_select, true);
@@ -177,11 +179,16 @@ static int bcm63xx_hsspi_do_txrx(struct spi_device *spi, struct spi_transfer *t)
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
@@ -439,13 +446,17 @@ static int bcm63xx_hsspi_probe(struct platform_device *pdev)
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
diff --git a/drivers/staging/emxx_udc/emxx_udc.c b/drivers/staging/emxx_udc/emxx_udc.c
index 3897f8e8f5e0..6870a33d4ccf 100644
--- a/drivers/staging/emxx_udc/emxx_udc.c
+++ b/drivers/staging/emxx_udc/emxx_udc.c
@@ -2591,10 +2591,15 @@ static int nbu2ss_ep_queue(struct usb_ep *_ep,
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
diff --git a/drivers/thermal/hisi_thermal.c b/drivers/thermal/hisi_thermal.c
index ee05950afd2f..7b1e81912ccf 100644
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
index fb04470d7d4b..6e7c230d308f 100644
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
diff --git a/drivers/thermal/intel/intel_quark_dts_thermal.c b/drivers/thermal/intel/intel_quark_dts_thermal.c
index 3eafc6b0e6c3..b43fbd5eaa6b 100644
--- a/drivers/thermal/intel/intel_quark_dts_thermal.c
+++ b/drivers/thermal/intel/intel_quark_dts_thermal.c
@@ -415,22 +415,14 @@ MODULE_DEVICE_TABLE(x86cpu, qrk_thermal_ids);
 
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
index 4f1a2f7c016c..8d6707e48d02 100644
--- a/drivers/thermal/intel/intel_soc_dts_iosf.c
+++ b/drivers/thermal/intel/intel_soc_dts_iosf.c
@@ -404,7 +404,7 @@ struct intel_soc_dts_sensors *intel_soc_dts_iosf_init(
 {
 	struct intel_soc_dts_sensors *sensors;
 	bool notification;
-	u32 tj_max;
+	int tj_max;
 	int ret;
 	int i;
 
diff --git a/drivers/thermal/qcom/tsens-v1.c b/drivers/thermal/qcom/tsens-v1.c
index 3c19a3800c6d..faa4576fa028 100644
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
@@ -374,17 +361,29 @@ struct tsens_plat_data data_tsens_v1 = {
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
 
-/* Valid for both MSM8956 and MSM8976. Sensor ID 3 is unused. */
 struct tsens_plat_data data_8976 = {
 	.num_sensors	= 11,
 	.ops		= &ops_8976,
-	.hw_ids		= (unsigned int[]){0, 1, 2, 4, 5, 6, 7, 8, 9, 10},
+	.hw_ids		= (unsigned int[]){0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10},
 	.feat		= &tsens_v1_feat,
 	.fields		= tsens_v1_regfields,
 };
diff --git a/drivers/thermal/qcom/tsens.c b/drivers/thermal/qcom/tsens.c
index cb4f4b522446..c73792ca727a 100644
--- a/drivers/thermal/qcom/tsens.c
+++ b/drivers/thermal/qcom/tsens.c
@@ -902,6 +902,12 @@ static const struct of_device_id tsens_table[] = {
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
index f40b625f897e..bbb1e8332821 100644
--- a/drivers/thermal/qcom/tsens.h
+++ b/drivers/thermal/qcom/tsens.h
@@ -588,7 +588,7 @@ extern struct tsens_plat_data data_8960;
 extern struct tsens_plat_data data_8916, data_8939, data_8974;
 
 /* TSENS v1 targets */
-extern struct tsens_plat_data data_tsens_v1, data_8976;
+extern struct tsens_plat_data data_tsens_v1, data_8976, data_8956;
 
 /* TSENS v2 targets */
 extern struct tsens_plat_data data_8996, data_tsens_v2;
diff --git a/drivers/tty/serial/fsl_lpuart.c b/drivers/tty/serial/fsl_lpuart.c
index 223695947b65..9cb0e8673f82 100644
--- a/drivers/tty/serial/fsl_lpuart.c
+++ b/drivers/tty/serial/fsl_lpuart.c
@@ -1448,12 +1448,32 @@ static void lpuart_break_ctl(struct uart_port *port, int break_state)
 
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
diff --git a/drivers/tty/serial/sc16is7xx.c b/drivers/tty/serial/sc16is7xx.c
index 04b4ed5d0634..7ece8d1a23cb 100644
--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -1243,25 +1243,6 @@ static int sc16is7xx_probe(struct device *dev,
 	}
 	sched_set_fifo(s->kworker_task);
 
-#ifdef CONFIG_GPIOLIB
-	if (devtype->nr_gpio) {
-		/* Setup GPIO cotroller */
-		s->gpio.owner		 = THIS_MODULE;
-		s->gpio.parent		 = dev;
-		s->gpio.label		 = dev_name(dev);
-		s->gpio.direction_input	 = sc16is7xx_gpio_direction_input;
-		s->gpio.get		 = sc16is7xx_gpio_get;
-		s->gpio.direction_output = sc16is7xx_gpio_direction_output;
-		s->gpio.set		 = sc16is7xx_gpio_set;
-		s->gpio.base		 = -1;
-		s->gpio.ngpio		 = devtype->nr_gpio;
-		s->gpio.can_sleep	 = 1;
-		ret = gpiochip_add_data(&s->gpio, s);
-		if (ret)
-			goto out_thread;
-	}
-#endif
-
 	/* reset device, purging any pending irq / data */
 	regmap_write(s->regmap, SC16IS7XX_IOCONTROL_REG << SC16IS7XX_REG_SHIFT,
 			SC16IS7XX_IOCONTROL_SRESET_BIT);
@@ -1327,6 +1308,25 @@ static int sc16is7xx_probe(struct device *dev,
 				s->p[u].irda_mode = true;
 	}
 
+#ifdef CONFIG_GPIOLIB
+	if (devtype->nr_gpio) {
+		/* Setup GPIO cotroller */
+		s->gpio.owner		 = THIS_MODULE;
+		s->gpio.parent		 = dev;
+		s->gpio.label		 = dev_name(dev);
+		s->gpio.direction_input	 = sc16is7xx_gpio_direction_input;
+		s->gpio.get		 = sc16is7xx_gpio_get;
+		s->gpio.direction_output = sc16is7xx_gpio_direction_output;
+		s->gpio.set		 = sc16is7xx_gpio_set;
+		s->gpio.base		 = -1;
+		s->gpio.ngpio		 = devtype->nr_gpio;
+		s->gpio.can_sleep	 = 1;
+		ret = gpiochip_add_data(&s->gpio, s);
+		if (ret)
+			goto out_thread;
+	}
+#endif
+
 	/*
 	 * Setup interrupt. We first try to acquire the IRQ line as level IRQ.
 	 * If that succeeds, we can allow sharing the interrupt as well.
@@ -1346,18 +1346,19 @@ static int sc16is7xx_probe(struct device *dev,
 	if (!ret)
 		return 0;
 
-out_ports:
-	for (i--; i >= 0; i--) {
-		uart_remove_one_port(&sc16is7xx_uart, &s->p[i].port);
-		clear_bit(s->p[i].port.line, &sc16is7xx_lines);
-	}
-
 #ifdef CONFIG_GPIOLIB
 	if (devtype->nr_gpio)
 		gpiochip_remove(&s->gpio);
 
 out_thread:
 #endif
+
+out_ports:
+	for (i--; i >= 0; i--) {
+		uart_remove_one_port(&sc16is7xx_uart, &s->p[i].port);
+		clear_bit(s->p[i].port.line, &sc16is7xx_lines);
+	}
+
 	kthread_stop(s->kworker_task);
 
 out_clk:
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 669aef77a0bd..c37d2657308c 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1237,14 +1237,16 @@ static struct tty_struct *tty_driver_lookup_tty(struct tty_driver *driver,
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
diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 71e091f879f0..1dc07f9214d5 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -415,10 +415,8 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 		 */
 		size = vcs_size(vc, attr, uni_mode);
 		if (size < 0) {
-			if (read)
-				break;
 			ret = size;
-			goto unlock_out;
+			break;
 		}
 		if (pos >= size)
 			break;
diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
index 00fb58e50a15..2db01170d096 100644
--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -505,11 +505,68 @@ UVC_ATTR_RO(uvcg_default_output_, cname, aname)
 UVCG_DEFAULT_OUTPUT_ATTR(b_terminal_id, bTerminalID, 8);
 UVCG_DEFAULT_OUTPUT_ATTR(w_terminal_type, wTerminalType, 16);
 UVCG_DEFAULT_OUTPUT_ATTR(b_assoc_terminal, bAssocTerminal, 8);
-UVCG_DEFAULT_OUTPUT_ATTR(b_source_id, bSourceID, 8);
 UVCG_DEFAULT_OUTPUT_ATTR(i_terminal, iTerminal, 8);
 
 #undef UVCG_DEFAULT_OUTPUT_ATTR
 
+static ssize_t uvcg_default_output_b_source_id_show(struct config_item *item,
+						    char *page)
+{
+	struct config_group *group = to_config_group(item);
+	struct f_uvc_opts *opts;
+	struct config_item *opts_item;
+	struct mutex *su_mutex = &group->cg_subsys->su_mutex;
+	struct uvc_output_terminal_descriptor *cd;
+	int result;
+
+	mutex_lock(su_mutex); /* for navigating configfs hierarchy */
+
+	opts_item = group->cg_item.ci_parent->ci_parent->
+			ci_parent->ci_parent;
+	opts = to_f_uvc_opts(opts_item);
+	cd = &opts->uvc_output_terminal;
+
+	mutex_lock(&opts->lock);
+	result = sprintf(page, "%u\n", le8_to_cpu(cd->bSourceID));
+	mutex_unlock(&opts->lock);
+
+	mutex_unlock(su_mutex);
+
+	return result;
+}
+
+static ssize_t uvcg_default_output_b_source_id_store(struct config_item *item,
+						     const char *page, size_t len)
+{
+	struct config_group *group = to_config_group(item);
+	struct f_uvc_opts *opts;
+	struct config_item *opts_item;
+	struct mutex *su_mutex = &group->cg_subsys->su_mutex;
+	struct uvc_output_terminal_descriptor *cd;
+	int result;
+	u8 num;
+
+	result = kstrtou8(page, 0, &num);
+	if (result)
+		return result;
+
+	mutex_lock(su_mutex); /* for navigating configfs hierarchy */
+
+	opts_item = group->cg_item.ci_parent->ci_parent->
+			ci_parent->ci_parent;
+	opts = to_f_uvc_opts(opts_item);
+	cd = &opts->uvc_output_terminal;
+
+	mutex_lock(&opts->lock);
+	cd->bSourceID = num;
+	mutex_unlock(&opts->lock);
+
+	mutex_unlock(su_mutex);
+
+	return len;
+}
+UVC_ATTR(uvcg_default_output_, b_source_id, bSourceID);
+
 static struct configfs_attribute *uvcg_default_output_attrs[] = {
 	&uvcg_default_output_attr_b_terminal_id,
 	&uvcg_default_output_attr_w_terminal_type,
diff --git a/drivers/usb/host/xhci-mvebu.c b/drivers/usb/host/xhci-mvebu.c
index 8ca1a235d164..eabccf25796b 100644
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
index c9ce1c25c80c..737398f1b896 100644
--- a/drivers/usb/storage/ene_ub6250.c
+++ b/drivers/usb/storage/ene_ub6250.c
@@ -938,7 +938,7 @@ static int ms_lib_process_bootblock(struct us_data *us, u16 PhyBlock, u8 *PageDa
 	struct ms_lib_type_extdat ExtraData;
 	struct ene_ub6250_info *info = (struct ene_ub6250_info *) us->extra;
 
-	PageBuffer = kmalloc(MS_BYTES_PER_PAGE, GFP_KERNEL);
+	PageBuffer = kzalloc(MS_BYTES_PER_PAGE * 2, GFP_KERNEL);
 	if (PageBuffer == NULL)
 		return (u32)-1;
 
diff --git a/drivers/vdpa/mlx5/core/mr.c b/drivers/vdpa/mlx5/core/mr.c
index 32c9925de473..1f94ea46c01a 100644
--- a/drivers/vdpa/mlx5/core/mr.c
+++ b/drivers/vdpa/mlx5/core/mr.c
@@ -448,7 +448,6 @@ void mlx5_vdpa_destroy_mr(struct mlx5_vdpa_dev *mvdev)
 		unmap_direct_mr(mvdev, dmr);
 		kfree(dmr);
 	}
-	memset(mr, 0, sizeof(*mr));
 	mr->initialized = false;
 out:
 	mutex_unlock(&mr->mkey_mtx);
diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index ce50ca9a320c..ec1428dbdf9d 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -96,6 +96,7 @@ struct vfio_dma {
 	struct task_struct	*task;
 	struct rb_root		pfn_list;	/* Ex-user pinned pfn list */
 	unsigned long		*bitmap;
+	struct mm_struct	*mm;
 };
 
 struct vfio_batch {
@@ -391,8 +392,8 @@ static int vfio_lock_acct(struct vfio_dma *dma, long npage, bool async)
 	if (!npage)
 		return 0;
 
-	mm = async ? get_task_mm(dma->task) : dma->task->mm;
-	if (!mm)
+	mm = dma->mm;
+	if (async && !mmget_not_zero(mm))
 		return -ESRCH; /* process exited */
 
 	ret = mmap_write_lock_killable(mm);
@@ -666,8 +667,8 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	struct mm_struct *mm;
 	int ret;
 
-	mm = get_task_mm(dma->task);
-	if (!mm)
+	mm = dma->mm;
+	if (!mmget_not_zero(mm))
 		return -ENODEV;
 
 	ret = vaddr_get_pfns(mm, vaddr, 1, dma->prot, pfn_base, pages);
@@ -677,7 +678,7 @@ static int vfio_pin_page_external(struct vfio_dma *dma, unsigned long vaddr,
 	ret = 0;
 
 	if (do_accounting && !is_invalid_reserved_pfn(*pfn_base)) {
-		ret = vfio_lock_acct(dma, 1, true);
+		ret = vfio_lock_acct(dma, 1, false);
 		if (ret) {
 			put_pfn(*pfn_base, dma->prot);
 			if (ret == -ENOMEM)
@@ -1031,6 +1032,7 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	vfio_unmap_unpin(iommu, dma, true);
 	vfio_unlink_dma(iommu, dma);
 	put_task_struct(dma->task);
+	mmdrop(dma->mm);
 	vfio_dma_bitmap_free(dma);
 	kfree(dma);
 	iommu->dma_avail++;
@@ -1452,29 +1454,15 @@ static int vfio_dma_do_map(struct vfio_iommu *iommu,
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
 
@@ -2998,9 +2986,8 @@ static int vfio_iommu_type1_dma_rw_chunk(struct vfio_iommu *iommu,
 			!(dma->prot & IOMMU_READ))
 		return -EPERM;
 
-	mm = get_task_mm(dma->task);
-
-	if (!mm)
+	mm = dma->mm;
+	if (!mmget_not_zero(mm))
 		return -EPERM;
 
 	if (kthread)
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
index 1bdaf17c1d38..8202f0a6b093 100644
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
index 2ee017442dfc..f37255cd75fd 100644
--- a/drivers/watchdog/watchdog_dev.c
+++ b/drivers/watchdog/watchdog_dev.c
@@ -1037,8 +1037,8 @@ static int watchdog_cdev_register(struct watchdog_device *wdd)
 		if (wdd->id == 0) {
 			misc_deregister(&watchdog_miscdev);
 			old_wd_data = NULL;
-			put_device(&wd_data->dev);
 		}
+		put_device(&wd_data->dev);
 		return err;
 	}
 
diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
index 844db4652dd1..8fdd34ff20ef 100644
--- a/fs/cifs/smb2ops.c
+++ b/fs/cifs/smb2ops.c
@@ -859,12 +859,13 @@ smb3_qfs_tcon(const unsigned int xid, struct cifs_tcon *tcon,
 	bool no_cached_open = tcon->nohandlecache;
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
 
 	if (no_cached_open) {
 		rc = SMB2_open(xid, &oparms, &srch_path, &oplock, NULL, NULL,
diff --git a/fs/cifs/smbdirect.c b/fs/cifs/smbdirect.c
index f73f9b062525..bcc611069308 100644
--- a/fs/cifs/smbdirect.c
+++ b/fs/cifs/smbdirect.c
@@ -1691,6 +1691,7 @@ static struct smbd_connection *_smbd_get_connection(
 
 allocate_mr_failed:
 	/* At this point, need to a full transport shutdown */
+	server->smbd_conn = info;
 	smbd_destroy(server);
 	return NULL;
 
@@ -2239,6 +2240,7 @@ static int allocate_mr_list(struct smbd_connection *info)
 	atomic_set(&info->mr_ready_count, 0);
 	atomic_set(&info->mr_used_count, 0);
 	init_waitqueue_head(&info->wait_for_mr_cleanup);
+	INIT_WORK(&info->mr_recovery_work, smbd_mr_recovery_work);
 	/* Allocate more MRs (2x) than hardware responder_resources */
 	for (i = 0; i < info->responder_resources * 2; i++) {
 		smbdirect_mr = kzalloc(sizeof(*smbdirect_mr), GFP_KERNEL);
@@ -2266,13 +2268,13 @@ static int allocate_mr_list(struct smbd_connection *info)
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
diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index dedbc55cd48f..6caded58cda5 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -102,7 +102,7 @@ static int exfat_readdir(struct inode *inode, loff_t *cpos, struct exfat_dir_ent
 			clu.dir = ei->hint_bmap.clu;
 		}
 
-		while (clu_offset > 0) {
+		while (clu_offset > 0 && clu.dir != EXFAT_EOF_CLUSTER) {
 			if (exfat_get_next_cluster(sb, &(clu.dir)))
 				return -EIO;
 
@@ -236,10 +236,7 @@ static int exfat_iterate(struct file *filp, struct dir_context *ctx)
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
index 0d139c7d150d..07b09af57436 100644
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
index c819e8427ea5..819f47278305 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -250,8 +250,7 @@ void exfat_truncate(struct inode *inode, loff_t size)
 	else
 		mark_inode_dirty(inode);
 
-	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
-				inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >> 9;
 write_size:
 	aligned_size = i_size_read(inode);
 	if (aligned_size & (blocksize - 1)) {
diff --git a/fs/exfat/inode.c b/fs/exfat/inode.c
index 2a9f6a80584e..4bd73820a4ac 100644
--- a/fs/exfat/inode.c
+++ b/fs/exfat/inode.c
@@ -242,8 +242,7 @@ static int exfat_map_cluster(struct inode *inode, unsigned int clu_offset,
 				return err;
 		} /* end of if != DIR_DELETED */
 
-		inode->i_blocks +=
-			num_to_be_allocated << sbi->sect_per_clus_bits;
+		inode->i_blocks += EXFAT_CLU_TO_B(num_to_be_allocated, sbi) >> 9;
 
 		/*
 		 * Move *clu pointer along FAT chains (hole care) because the
@@ -600,8 +599,7 @@ static int exfat_fill_inode(struct inode *inode, struct exfat_dir_entry *info)
 
 	exfat_save_attr(inode, info->attr);
 
-	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >>
-				inode->i_blkbits;
+	inode->i_blocks = round_up(i_size_read(inode), sbi->cluster_size) >> 9;
 	inode->i_mtime = info->mtime;
 	inode->i_ctime = info->mtime;
 	ei->i_crtime = info->crtime;
diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index 935f60050900..1382d816912c 100644
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
index ba70ed1c9804..62d79af257a9 100644
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
index 6bf1c62eff04..b80ad5a7b05c 100644
--- a/fs/ext4/xattr.c
+++ b/fs/ext4/xattr.c
@@ -1415,6 +1415,13 @@ static struct inode *ext4_xattr_inode_create(handle_t *handle,
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
@@ -2564,9 +2571,8 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 
 	is = kzalloc(sizeof(struct ext4_xattr_ibody_find), GFP_NOFS);
 	bs = kzalloc(sizeof(struct ext4_xattr_block_find), GFP_NOFS);
-	buffer = kvmalloc(value_size, GFP_NOFS);
 	b_entry_name = kmalloc(entry->e_name_len + 1, GFP_NOFS);
-	if (!is || !bs || !buffer || !b_entry_name) {
+	if (!is || !bs || !b_entry_name) {
 		error = -ENOMEM;
 		goto out;
 	}
@@ -2578,12 +2584,18 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
 
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
@@ -2598,25 +2610,26 @@ static int ext4_xattr_move_to_block(handle_t *handle, struct inode *inode,
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
index 9270330ec5ce..db26e87b8f0d 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -721,7 +721,7 @@ int f2fs_submit_page_bio(struct f2fs_io_info *fio)
 	}
 
 	if (fio->io_wbc && !is_read_io(fio->op))
-		wbc_account_cgroup_owner(fio->io_wbc, page, PAGE_SIZE);
+		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	__attach_io_flag(fio);
 	bio_set_op_attrs(bio, fio->op, fio->op_flags);
@@ -929,7 +929,7 @@ int f2fs_merge_page_bio(struct f2fs_io_info *fio)
 	}
 
 	if (fio->io_wbc)
-		wbc_account_cgroup_owner(fio->io_wbc, page, PAGE_SIZE);
+		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	inc_page_count(fio->sbi, WB_DATA_TYPE(page));
 
@@ -1003,7 +1003,7 @@ void f2fs_submit_page_write(struct f2fs_io_info *fio)
 	}
 
 	if (fio->io_wbc)
-		wbc_account_cgroup_owner(fio->io_wbc, bio_page, PAGE_SIZE);
+		wbc_account_cgroup_owner(fio->io_wbc, fio->page, PAGE_SIZE);
 
 	io->last_block_in_bio = fio->new_blkaddr;
 	f2fs_trace_ios(fio, 0);
diff --git a/fs/f2fs/inline.c b/fs/f2fs/inline.c
index f97c23ec93ce..df1a0cbfa1be 100644
--- a/fs/f2fs/inline.c
+++ b/fs/f2fs/inline.c
@@ -64,7 +64,6 @@ bool f2fs_may_inline_dentry(struct inode *inode)
 void f2fs_do_read_inline_data(struct page *page, struct page *ipage)
 {
 	struct inode *inode = page->mapping->host;
-	void *src_addr, *dst_addr;
 
 	if (PageUptodate(page))
 		return;
@@ -74,11 +73,8 @@ void f2fs_do_read_inline_data(struct page *page, struct page *ipage)
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
@@ -245,7 +241,6 @@ int f2fs_convert_inline_inode(struct inode *inode)
 
 int f2fs_write_inline_data(struct inode *inode, struct page *page)
 {
-	void *src_addr, *dst_addr;
 	struct dnode_of_data dn;
 	int err;
 
@@ -262,10 +257,8 @@ int f2fs_write_inline_data(struct inode *inode, struct page *page)
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
@@ -420,18 +413,17 @@ static int f2fs_move_inline_dirents(struct inode *dir, struct page *ipage,
 
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
index fba413ced982..0bba5c72fc77 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2034,7 +2034,6 @@ static ssize_t f2fs_quota_read(struct super_block *sb, int type, char *data,
 	size_t toread;
 	loff_t i_size = i_size_read(inode);
 	struct page *page;
-	char *kaddr;
 
 	if (off > i_size)
 		return 0;
@@ -2068,9 +2067,7 @@ static ssize_t f2fs_quota_read(struct super_block *sb, int type, char *data,
 			return -EIO;
 		}
 
-		kaddr = kmap_atomic(page);
-		memcpy(data, kaddr + offset, tocopy);
-		kunmap_atomic(kaddr);
+		memcpy_from_page(data, page, offset, tocopy);
 		f2fs_put_page(page, 1);
 
 		offset = 0;
@@ -2092,7 +2089,6 @@ static ssize_t f2fs_quota_write(struct super_block *sb, int type,
 	size_t towrite = len;
 	struct page *page;
 	void *fsdata = NULL;
-	char *kaddr;
 	int err = 0;
 	int tocopy;
 
@@ -2112,10 +2108,7 @@ static ssize_t f2fs_quota_write(struct super_block *sb, int type,
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
index cff94d095d0f..cef40d92268f 100644
--- a/fs/f2fs/verity.c
+++ b/fs/f2fs/verity.c
@@ -47,16 +47,13 @@ static int pagecache_read(struct inode *inode, void *buf, size_t count,
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
 
@@ -81,8 +78,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		size_t n = min_t(size_t, count,
 				 PAGE_SIZE - offset_in_page(pos));
 		struct page *page;
-		void *fsdata;
-		void *addr;
+		void *fsdata = NULL;
 		int res;
 
 		res = pagecache_write_begin(NULL, inode->i_mapping, pos, n, 0,
@@ -90,9 +86,7 @@ static int pagecache_write(struct inode *inode, const void *buf, size_t count,
 		if (res)
 			return res;
 
-		addr = kmap_atomic(page);
-		memcpy(addr + offset_in_page(pos), buf, n);
-		kunmap_atomic(addr);
+		memcpy_to_page(page, offset_in_page(pos), buf, n);
 
 		res = pagecache_write_end(NULL, inode->i_mapping, pos, n, n,
 					  page, fsdata);
diff --git a/fs/gfs2/aops.c b/fs/gfs2/aops.c
index cc4f987687f3..530659554870 100644
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
index d14b98aa1c3e..5cb7e771b57a 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -145,8 +145,10 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
 		return -EIO;
 
 	error = gfs2_find_jhead(sdp->sd_jdesc, &head, false);
-	if (error || gfs2_withdrawn(sdp))
+	if (error) {
+		gfs2_consist(sdp);
 		return error;
+	}
 
 	if (!(head.lh_flags & GFS2_LOG_HEAD_UNMOUNT)) {
 		gfs2_consist(sdp);
@@ -158,7 +160,9 @@ int gfs2_make_fs_rw(struct gfs2_sbd *sdp)
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
index 807119ae5adf..7648f64a17a8 100644
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
index 86472212cce1..1923528154b5 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -984,36 +984,28 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
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
@@ -1023,8 +1015,10 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
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
@@ -1048,10 +1042,24 @@ do_get_write_access(handle_t *handle, struct journal_head *jh,
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
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 2c9493011aec..501263355ef4 100644
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
diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index ad856b7b9a46..7be1a7f7fcb2 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -487,8 +487,9 @@ static int nfs_swap_activate(struct swap_info_struct *sis, struct file *file,
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
@@ -501,14 +502,22 @@ static int nfs_swap_activate(struct swap_info_struct *sis, struct file *file,
 
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
diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
index 1adece1cff3e..36f415278c04 100644
--- a/fs/nfs/inode.c
+++ b/fs/nfs/inode.c
@@ -1906,7 +1906,11 @@ static int nfs_update_inode(struct inode *inode, struct nfs_fattr *fattr)
 	nfs_wcc_update_inode(inode, fattr);
 
 	if (pnfs_layoutcommit_outstanding(inode)) {
-		nfsi->cache_validity |= save_cache_validity & NFS_INO_INVALID_ATTR;
+		nfsi->cache_validity |=
+			save_cache_validity &
+			(NFS_INO_INVALID_CHANGE | NFS_INO_INVALID_CTIME |
+			 NFS_INO_INVALID_MTIME | NFS_INO_INVALID_SIZE |
+			 NFS_INO_REVAL_FORCED);
 		cache_revalidated = false;
 	}
 
diff --git a/fs/nfs/nfs4_fs.h b/fs/nfs/nfs4_fs.h
index 6d916563356e..8b41c0b8624e 100644
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
index ee46ab09e330..8653335c17b6 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -10385,6 +10385,26 @@ static ssize_t nfs4_listxattr(struct dentry *dentry, char *list, size_t size)
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
@@ -10461,6 +10481,8 @@ const struct nfs_rpc_ops nfs_v4_clientops = {
 	.free_client	= nfs4_free_client,
 	.create_server	= nfs4_create_server,
 	.clone_server	= nfs_clone_server,
+	.enable_swap	= nfs4_enable_swap,
+	.disable_swap	= nfs4_disable_swap,
 };
 
 static const struct xattr_handler nfs4_xattr_nfs4_acl_handler = {
diff --git a/fs/nfs/nfs4state.c b/fs/nfs/nfs4state.c
index 175b2e064003..628e030f8e3b 100644
--- a/fs/nfs/nfs4state.c
+++ b/fs/nfs/nfs4state.c
@@ -1208,10 +1208,17 @@ void nfs4_schedule_state_manager(struct nfs_client *clp)
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
 
@@ -1229,6 +1236,7 @@ void nfs4_schedule_state_manager(struct nfs_client *clp)
 		if (!nfs_client_init_is_complete(clp))
 			nfs_mark_client_ready(clp, PTR_ERR(task));
 		nfs4_clear_state_manager_bit(clp);
+		clear_bit(NFS4CLNT_MANAGER_AVAILABLE, &clp->cl_state);
 		nfs_put_client(clp);
 		module_put(THIS_MODULE);
 	}
@@ -2680,12 +2688,8 @@ static void nfs4_state_manager(struct nfs_client *clp)
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
 
@@ -2706,9 +2710,31 @@ static void nfs4_state_manager(struct nfs_client *clp)
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
index 484c1da96dea..d862df9761e7 100644
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
index 735ee8a79870..f82cfe843b99 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -1075,8 +1075,10 @@ nfsd4_verify_copy(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
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
index 9257ee893bdb..6039943877e1 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1117,7 +1117,6 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
 	int err, sz_change, len = strlen(symname);
 	struct fscrypt_str disk_link;
 	struct ubifs_budget_req req = { .new_ino = 1, .new_dent = 1,
-					.new_ino_d = ALIGN(len, 8),
 					.dirtied_ino = 1 };
 	struct fscrypt_name nm;
 
@@ -1133,6 +1132,7 @@ static int ubifs_symlink(struct inode *dir, struct dentry *dentry,
 	 * Budget request settings: new inode, new direntry and changing parent
 	 * directory inode.
 	 */
+	req.new_ino_d = ALIGN(disk_link.len - 1, 8);
 	err = ubifs_budget_space(c, &req);
 	if (err)
 		return err;
@@ -1288,6 +1288,8 @@ static int do_rename(struct inode *old_dir, struct dentry *old_dentry,
 	if (unlink) {
 		ubifs_assert(c, inode_is_locked(new_inode));
 
+		/* Budget for old inode's data when its nlink > 1. */
+		req.dirtied_ino_d = ALIGN(ubifs_inode(new_inode)->data_len, 8);
 		err = ubifs_purge_xattrs(new_inode);
 		if (err)
 			return err;
@@ -1530,6 +1532,10 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 		return err;
 	}
 
+	err = ubifs_budget_space(c, &req);
+	if (err)
+		goto out;
+
 	lock_4_inodes(old_dir, new_dir, NULL, NULL);
 
 	time = current_time(old_dir);
@@ -1555,6 +1561,7 @@ static int ubifs_xrename(struct inode *old_dir, struct dentry *old_dentry,
 	unlock_4_inodes(old_dir, new_dir, NULL, NULL);
 	ubifs_release_budget(c, &req);
 
+out:
 	fscrypt_free_filename(&fst_nm);
 	fscrypt_free_filename(&snd_nm);
 	return err;
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index 354457e846cd..19fdcda04589 100644
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
index 6a8f9efc2e2f..1df193c87e92 100644
--- a/fs/ubifs/super.c
+++ b/fs/ubifs/super.c
@@ -833,7 +833,7 @@ static int alloc_wbufs(struct ubifs_info *c)
 		INIT_LIST_HEAD(&c->jheads[i].buds_list);
 		err = ubifs_wbuf_init(c, &c->jheads[i].wbuf);
 		if (err)
-			return err;
+			goto out_wbuf;
 
 		c->jheads[i].wbuf.sync_callback = &bud_wbuf_callback;
 		c->jheads[i].wbuf.jhead = i;
@@ -841,7 +841,7 @@ static int alloc_wbufs(struct ubifs_info *c)
 		c->jheads[i].log_hash = ubifs_hash_get_desc(c);
 		if (IS_ERR(c->jheads[i].log_hash)) {
 			err = PTR_ERR(c->jheads[i].log_hash);
-			goto out;
+			goto out_log_hash;
 		}
 	}
 
@@ -854,9 +854,18 @@ static int alloc_wbufs(struct ubifs_info *c)
 
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
index 894f1ab14616..07470449b960 100644
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
@@ -3053,6 +3060,21 @@ static void tnc_destroy_cnext(struct ubifs_info *c)
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
index e7e48f3b179a..b66ebab5c5de 100644
--- a/fs/ubifs/ubifs.h
+++ b/fs/ubifs/ubifs.h
@@ -1594,8 +1594,13 @@ static inline int ubifs_check_hmac(const struct ubifs_info *c,
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
index ad8eefad27d7..e283a62701b8 100644
--- a/fs/udf/file.c
+++ b/fs/udf/file.c
@@ -147,26 +147,24 @@ static ssize_t udf_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
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
index 2132bfab67f3..81876284a83c 100644
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
index 3448098e5476..4af9ce34ee80 100644
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
index 360e6377e84b..31ba85a4110a 100644
--- a/include/drm/drm_mipi_dsi.h
+++ b/include/drm/drm_mipi_dsi.h
@@ -283,6 +283,10 @@ int mipi_dsi_dcs_set_display_brightness(struct mipi_dsi_device *dsi,
 					u16 brightness);
 int mipi_dsi_dcs_get_display_brightness(struct mipi_dsi_device *dsi,
 					u16 *brightness);
+int mipi_dsi_dcs_set_display_brightness_large(struct mipi_dsi_device *dsi,
+					     u16 brightness);
+int mipi_dsi_dcs_get_display_brightness_large(struct mipi_dsi_device *dsi,
+					     u16 *brightness);
 
 /**
  * struct mipi_dsi_driver - DSI driver
diff --git a/include/linux/bootconfig.h b/include/linux/bootconfig.h
index 2696eb0fc149..df9cbf02d030 100644
--- a/include/linux/bootconfig.h
+++ b/include/linux/bootconfig.h
@@ -29,7 +29,7 @@ struct xbc_node {
 /* Maximum size of boot config is 32KB - 1 */
 #define XBC_DATA_MAX	(XBC_VALUE - 1)
 
-#define XBC_NODE_MAX	1024
+#define XBC_NODE_MAX	8192
 #define XBC_KEYLEN_MAX	256
 #define XBC_DEPTH_MAX	16
 
diff --git a/include/linux/ima.h b/include/linux/ima.h
index 8fa7bcfb2da2..cd8483fa703e 100644
--- a/include/linux/ima.h
+++ b/include/linux/ima.h
@@ -18,7 +18,8 @@ extern int ima_bprm_check(struct linux_binprm *bprm);
 extern int ima_file_check(struct file *file, int mask);
 extern void ima_post_create_tmpfile(struct inode *inode);
 extern void ima_file_free(struct file *file);
-extern int ima_file_mmap(struct file *file, unsigned long prot);
+extern int ima_file_mmap(struct file *file, unsigned long reqprot,
+			 unsigned long prot, unsigned long flags);
 extern int ima_file_mprotect(struct vm_area_struct *vma, unsigned long prot);
 extern int ima_load_data(enum kernel_load_data_id id, bool contents);
 extern int ima_post_load_data(char *buf, loff_t size,
@@ -70,7 +71,8 @@ static inline void ima_file_free(struct file *file)
 	return;
 }
 
-static inline int ima_file_mmap(struct file *file, unsigned long prot)
+static inline int ima_file_mmap(struct file *file, unsigned long reqprot,
+				unsigned long prot, unsigned long flags)
 {
 	return 0;
 }
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 394f10fc29aa..66948e1bf4fa 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -47,6 +47,8 @@
  */
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
+#define PTR_IF(cond, ptr)	((cond) ? (ptr) : NULL)
+
 #define u64_to_user_ptr(x) (		\
 {					\
 	typecheck(u64, (x));		\
diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 8fff3500d50e..1160e20995a0 100644
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
index 4dbebd319b6f..18b7c40ffb37 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -342,6 +342,8 @@ extern int proc_kprobes_optimization_handler(struct ctl_table *table,
 					     size_t *length, loff_t *ppos);
 #endif
 extern void wait_for_kprobe_optimizer(void);
+bool optprobe_queued_unopt(struct optimized_kprobe *op);
+bool kprobe_disarmed(struct kprobe *p);
 #else
 static inline void wait_for_kprobe_optimizer(void) { }
 #endif /* CONFIG_OPTPROBES */
diff --git a/include/linux/nfs_xdr.h b/include/linux/nfs_xdr.h
index 5491ad5f48a9..33442fd018a0 100644
--- a/include/linux/nfs_xdr.h
+++ b/include/linux/nfs_xdr.h
@@ -1789,6 +1789,8 @@ struct nfs_rpc_ops {
 	struct nfs_server *(*create_server)(struct fs_context *);
 	struct nfs_server *(*clone_server)(struct nfs_server *, struct nfs_fh *,
 					   struct nfs_fattr *, rpc_authflavor_t);
+	void	(*enable_swap)(struct inode *inode);
+	void	(*disable_swap)(struct inode *inode);
 };
 
 /*
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 692ce678c5f1..4cc42ad2f6c5 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -539,6 +539,7 @@ struct pci_host_bridge {
 	struct msi_controller *msi;
 	unsigned int	ignore_reset_delay:1;	/* For entire hierarchy */
 	unsigned int	no_ext_tags:1;		/* No Extended Tags */
+	unsigned int	no_inc_mrrs:1;		/* No Increase MRRS */
 	unsigned int	native_aer:1;		/* OS may use PCIe AER */
 	unsigned int	native_pcie_hotplug:1;	/* OS may use PCIe hotplug */
 	unsigned int	native_shpc_hotplug:1;	/* OS may use SHPC hotplug */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 69e310173fbc..2e1935917c24 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -3033,6 +3033,8 @@
 #define PCI_DEVICE_ID_INTEL_VMD_9A0B	0x9a0b
 #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
 
+#define PCI_VENDOR_ID_WANGXUN		0x8088
+
 #define PCI_VENDOR_ID_SCALEMP		0x8686
 #define PCI_DEVICE_ID_SCALEMP_VSMP_CTL	0x1010
 
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 095b3b39bd03..ef8d56b18da6 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -189,6 +189,7 @@ void synchronize_rcu_tasks_rude(void);
 
 #define rcu_note_voluntary_context_switch(t) rcu_tasks_qs(t, false)
 void exit_tasks_rcu_start(void);
+void exit_tasks_rcu_stop(void);
 void exit_tasks_rcu_finish(void);
 #else /* #ifdef CONFIG_TASKS_RCU_GENERIC */
 #define rcu_tasks_qs(t, preempt) do { } while (0)
@@ -196,6 +197,7 @@ void exit_tasks_rcu_finish(void);
 #define call_rcu_tasks call_rcu
 #define synchronize_rcu_tasks synchronize_rcu
 static inline void exit_tasks_rcu_start(void) { }
+static inline void exit_tasks_rcu_stop(void) { }
 static inline void exit_tasks_rcu_finish(void) { }
 #endif /* #else #ifdef CONFIG_TASKS_RCU_GENERIC */
 
@@ -306,11 +308,18 @@ static inline int rcu_read_lock_any_held(void)
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
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index c7c6e8b8344d..20668760daa0 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -348,6 +348,10 @@ copy_struct_from_user(void *dst, size_t ksize, const void __user *src,
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
index be9ff0422c16..be59e8df0bff 100644
--- a/include/net/sctp/structs.h
+++ b/include/net/sctp/structs.h
@@ -1394,6 +1394,7 @@ struct sctp_stream_priorities {
 	/* The next stream in line */
 	struct sctp_stream_out_ext *next;
 	__u16 prio;
+	__u16 users;
 };
 
 struct sctp_stream_out_ext {
diff --git a/include/net/sock.h b/include/net/sock.h
index 0f48d50a6dde..1d8529311d6f 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1775,7 +1775,12 @@ void sk_common_release(struct sock *sk);
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
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf6f8aeb450d..445afda927f4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -486,6 +486,7 @@ struct io_poll_iocb {
 	struct file			*file;
 	struct wait_queue_head		*head;
 	__poll_t			events;
+	int				retries;
 	struct wait_queue_entry		wait;
 };
 
@@ -2460,6 +2461,15 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 
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
@@ -4986,7 +4996,7 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 	sr->bgid = READ_ONCE(sqe->buf_group);
-	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
@@ -5740,6 +5750,14 @@ enum {
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
@@ -5751,8 +5769,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 
 	if (!req->file || !file_can_poll(req->file))
 		return IO_APOLL_ABORTED;
-	if ((req->flags & (REQ_F_POLLED|REQ_F_PARTIAL_IO)) == REQ_F_POLLED)
-		return IO_APOLL_ABORTED;
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
 
@@ -5770,8 +5786,13 @@ static int io_arm_poll_handler(struct io_kiocb *req)
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
@@ -9048,14 +9069,17 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
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
@@ -9681,6 +9705,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 			while (!list_empty_careful(&ctx->iopoll_list)) {
 				io_iopoll_try_reap_events(ctx);
 				ret = true;
+				cond_resched();
 			}
 		}
 
diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 52e704860739..11b612e94e4e 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -4273,6 +4273,7 @@ btf_get_prog_ctx_type(struct bpf_verifier_log *log, struct btf *btf,
 	if (!ctx_struct)
 		/* should not happen */
 		return NULL;
+again:
 	ctx_tname = btf_name_by_offset(btf_vmlinux, ctx_struct->name_off);
 	if (!ctx_tname) {
 		/* should not happen */
@@ -4286,8 +4287,16 @@ btf_get_prog_ctx_type(struct bpf_verifier_log *log, struct btf *btf,
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
index c6b419db68ef..1720998933f8 100644
--- a/kernel/irq/irqdomain.c
+++ b/kernel/irq/irqdomain.c
@@ -495,6 +495,9 @@ void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 		return;
 
 	hwirq = irq_data->hwirq;
+
+	mutex_lock(&irq_domain_mutex);
+
 	irq_set_status_flags(irq, IRQ_NOREQUEST);
 
 	/* remove chip and handler */
@@ -514,10 +517,12 @@ void irq_domain_disassociate(struct irq_domain *domain, unsigned int irq)
 
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
@@ -530,7 +535,6 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 	if (WARN(irq_data->domain, "error: virq%i is already associated", virq))
 		return -EINVAL;
 
-	mutex_lock(&irq_domain_mutex);
 	irq_data->hwirq = hwirq;
 	irq_data->domain = domain;
 	if (domain->ops->map) {
@@ -547,7 +551,6 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 			}
 			irq_data->domain = NULL;
 			irq_data->hwirq = 0;
-			mutex_unlock(&irq_domain_mutex);
 			return ret;
 		}
 
@@ -558,12 +561,23 @@ int irq_domain_associate(struct irq_domain *domain, unsigned int virq,
 
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
@@ -823,13 +837,8 @@ unsigned int irq_create_fwspec_mapping(struct irq_fwspec *fwspec)
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
index 75150e755518..86d71c49b495 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -447,8 +447,8 @@ static inline int kprobe_optready(struct kprobe *p)
 	return 0;
 }
 
-/* Return true(!0) if the kprobe is disarmed. Note: p must be on hash list */
-static inline int kprobe_disarmed(struct kprobe *p)
+/* Return true if the kprobe is disarmed. Note: p must be on hash list */
+bool kprobe_disarmed(struct kprobe *p)
 {
 	struct optimized_kprobe *op;
 
@@ -652,7 +652,7 @@ void wait_for_kprobe_optimizer(void)
 	mutex_unlock(&kprobe_mutex);
 }
 
-static bool optprobe_queued_unopt(struct optimized_kprobe *op)
+bool optprobe_queued_unopt(struct optimized_kprobe *op)
 {
 	struct optimized_kprobe *_op;
 
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index ef8733e2a476..20243682e605 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -251,7 +251,24 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
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
index 119b929dcff0..334173fe6940 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -72,10 +72,7 @@ static void em_debug_create_pd(struct device *dev)
 
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
index 8b51e6a5b386..c66d47685b28 100644
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
@@ -416,11 +417,21 @@ static void rcu_tasks_pertask(struct task_struct *t, struct list_head *hop)
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
@@ -487,7 +498,10 @@ static void rcu_tasks_postgp(struct rcu_tasks *rtp)
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
@@ -576,28 +590,43 @@ static void show_rcu_tasks_classic_gp_kthread(void)
 }
 #endif /* #ifndef CONFIG_TINY_RCU */
 
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
 static inline void show_rcu_tasks_classic_gp_kthread(void) { }
 void exit_tasks_rcu_start(void) { }
+void exit_tasks_rcu_stop(void) { }
 void exit_tasks_rcu_finish(void) { exit_tasks_rcu_finish_trace(current); }
 #endif /* #else #ifdef CONFIG_TASKS_RCU */
 
@@ -620,9 +649,6 @@ static void rcu_tasks_be_rude(struct work_struct *work)
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
index 0dc16345e668..ef6570137dcd 100644
--- a/kernel/rcu/tree_exp.h
+++ b/kernel/rcu/tree_exp.h
@@ -564,7 +564,9 @@ static void synchronize_rcu_expedited_wait(void)
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
index 817545ff80b9..100253d4909c 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -1293,20 +1293,6 @@ void release_mem_region_adjustable(resource_size_t start, resource_size_t size)
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
index aaf98771f935..f59cb3e8a613 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1847,8 +1847,7 @@ static void set_next_task_dl(struct rq *rq, struct task_struct *p, bool first)
 	deadline_queue_push_tasks(rq);
 }
 
-static struct sched_dl_entity *pick_next_dl_entity(struct rq *rq,
-						   struct dl_rq *dl_rq)
+static struct sched_dl_entity *pick_next_dl_entity(struct dl_rq *dl_rq)
 {
 	struct rb_node *left = rb_first_cached(&dl_rq->root);
 
@@ -1867,7 +1866,7 @@ static struct task_struct *pick_next_task_dl(struct rq *rq)
 	if (!sched_dl_runnable(rq))
 		return NULL;
 
-	dl_se = pick_next_dl_entity(rq, dl_rq);
+	dl_se = pick_next_dl_entity(dl_rq);
 	BUG_ON(!dl_se);
 	p = dl_task_of(dl_se);
 	set_next_task_dl(rq, p, true);
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index e6f22836c600..f690f901b6cc 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -1605,8 +1605,7 @@ static inline void set_next_task_rt(struct rq *rq, struct task_struct *p, bool f
 	rt_queue_push_tasks(rq);
 }
 
-static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
-						   struct rt_rq *rt_rq)
+static struct sched_rt_entity *pick_next_rt_entity(struct rt_rq *rt_rq)
 {
 	struct rt_prio_array *array = &rt_rq->active;
 	struct sched_rt_entity *next = NULL;
@@ -1617,6 +1616,8 @@ static struct sched_rt_entity *pick_next_rt_entity(struct rq *rq,
 	BUG_ON(idx >= MAX_RT_PRIO);
 
 	queue = array->queue + idx;
+	if (SCHED_WARN_ON(list_empty(queue)))
+		return NULL;
 	next = list_entry(queue->next, struct sched_rt_entity, run_list);
 
 	return next;
@@ -1628,8 +1629,9 @@ static struct task_struct *_pick_next_task_rt(struct rq *rq)
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
index e34ceb91f4c5..86e0fbe583f2 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -312,6 +312,15 @@ static void clocksource_verify_percpu(struct clocksource *cs)
 			testcpu, cs_nsec_min, cs_nsec_max, cs->name);
 }
 
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
@@ -319,6 +328,7 @@ static void clocksource_watchdog(struct timer_list *unused)
 	int64_t wd_nsec, cs_nsec;
 	struct clocksource *cs;
 	enum wd_read_status read_ret;
+	unsigned long extra_wait = 0;
 	u32 md;
 
 	spin_lock(&watchdog_lock);
@@ -338,13 +348,30 @@ static void clocksource_watchdog(struct timer_list *unused)
 
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
@@ -434,7 +461,7 @@ static void clocksource_watchdog(struct timer_list *unused)
 	 * pair clocksource_stop_watchdog() clocksource_start_watchdog().
 	 */
 	if (!timer_pending(&watchdog_timer)) {
-		watchdog_timer.expires += WATCHDOG_INTERVAL;
+		watchdog_timer.expires += WATCHDOG_INTERVAL + extra_wait;
 		add_timer_on(&watchdog_timer, next_cpu);
 	}
 out:
@@ -459,14 +486,6 @@ static inline void clocksource_stop_watchdog(void)
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
index 544ce87ba38a..70deb2f01e97 100644
--- a/kernel/time/hrtimer.c
+++ b/kernel/time/hrtimer.c
@@ -2024,6 +2024,7 @@ SYSCALL_DEFINE2(nanosleep, struct __kernel_timespec __user *, rqtp,
 	if (!timespec64_valid(&tu))
 		return -EINVAL;
 
+	current->restart_block.fn = do_no_restart_syscall;
 	current->restart_block.nanosleep.type = rmtp ? TT_NATIVE : TT_NONE;
 	current->restart_block.nanosleep.rmtp = rmtp;
 	return hrtimer_nanosleep(timespec64_to_ktime(tu), HRTIMER_MODE_REL,
@@ -2045,6 +2046,7 @@ SYSCALL_DEFINE2(nanosleep_time32, struct old_timespec32 __user *, rqtp,
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
index b624788023d8..724ca7eb1a6e 100644
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
 
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 49ebb8c66268..70da6f3212bc 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1449,19 +1449,6 @@ static int rb_check_bpage(struct ring_buffer_per_cpu *cpu_buffer,
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
@@ -1471,36 +1458,27 @@ static int rb_check_list(struct ring_buffer_per_cpu *cpu_buffer,
  */
 static int rb_check_pages(struct ring_buffer_per_cpu *cpu_buffer)
 {
-	struct list_head *head = cpu_buffer->pages;
-	struct buffer_page *bpage, *tmp;
-
-	/* Reset the head page if it exists */
-	if (cpu_buffer->head_page)
-		rb_set_head_page(cpu_buffer);
-
-	rb_head_page_deactivate(cpu_buffer);
+	struct list_head *head = rb_list_head(cpu_buffer->pages);
+	struct list_head *tmp;
 
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
 
@@ -5324,11 +5302,16 @@ EXPORT_SYMBOL_GPL(ring_buffer_alloc_read_page);
  */
 void ring_buffer_free_read_page(struct trace_buffer *buffer, int cpu, void *data)
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
diff --git a/lib/errname.c b/lib/errname.c
index 0c4d3e66170e..a5799a8c9cab 100644
--- a/lib/errname.c
+++ b/lib/errname.c
@@ -20,6 +20,7 @@ static const char *names_0[] = {
 	E(EADDRNOTAVAIL),
 	E(EADV),
 	E(EAFNOSUPPORT),
+	E(EAGAIN), /* EWOULDBLOCK */
 	E(EALREADY),
 	E(EBADE),
 	E(EBADF),
@@ -30,15 +31,17 @@ static const char *names_0[] = {
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
@@ -165,14 +168,17 @@ static const char *names_0[] = {
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
diff --git a/lib/mpi/mpicoder.c b/lib/mpi/mpicoder.c
index 7ea225b2204f..7054311d7879 100644
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
index cb7b0aead709..9b15760e0541 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2803,6 +2803,9 @@ void deferred_split_huge_page(struct page *page)
 	if (PageSwapCache(page))
 		return;
 
+	if (!list_empty(page_deferred_list(page)))
+		return;
+
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
 	if (list_empty(page_deferred_list(page))) {
 		count_vm_event(THP_DEFERRED_SPLIT_PAGE);
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c62d997c8ca1..751e3670d7b0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3930,6 +3930,10 @@ static int mem_cgroup_move_charge_write(struct cgroup_subsys_state *css,
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
+	pr_warn_once("Cgroup memory moving (move_charge_at_immigrate) is deprecated. "
+		     "Please report your usecase to linux-mm@kvack.org if you "
+		     "depend on this functionality.\n");
+
 	if (val & ~MOVE_MASK)
 		return -EINVAL;
 
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 2885ff9c76f0..7217bd9886e3 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -386,6 +386,7 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
 	struct p9_trans_rdma *rdma = client->trans;
 	struct ib_recv_wr wr;
 	struct ib_sge sge;
+	int ret;
 
 	c->busa = ib_dma_map_single(rdma->cm_id->device,
 				    c->rc.sdata, client->msize,
@@ -403,7 +404,12 @@ post_recv(struct p9_client *client, struct p9_rdma_context *c)
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
@@ -500,7 +506,7 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
 
 	if (down_interruptible(&rdma->sq_sem)) {
 		err = -EINTR;
-		goto send_error;
+		goto dma_unmap;
 	}
 
 	/* Mark request as `sent' *before* we actually send it,
@@ -510,11 +516,14 @@ static int rdma_request(struct p9_client *client, struct p9_req_t *req)
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
index 6c8a33f98f09..220e8f4ac0cf 100644
--- a/net/9p/trans_xen.c
+++ b/net/9p/trans_xen.c
@@ -393,19 +393,24 @@ static int xen_9pfs_front_alloc_dataring(struct xenbus_device *dev,
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
@@ -420,11 +425,6 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
 	if (p9_xen_trans.maxsize > XEN_FLEX_RING_SIZE(max_ring_order))
 		p9_xen_trans.maxsize = XEN_FLEX_RING_SIZE(max_ring_order) / 2;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
-
-	priv->dev = dev;
 	priv->num_rings = XEN_9PFS_NUM_RINGS;
 	priv->rings = kcalloc(priv->num_rings, sizeof(*priv->rings),
 			      GFP_KERNEL);
@@ -483,23 +483,35 @@ static int xen_9pfs_front_probe(struct xenbus_device *dev,
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
@@ -518,6 +530,8 @@ static void xen_9pfs_front_changed(struct xenbus_device *dev,
 		break;
 
 	case XenbusStateInitWait:
+		if (!xen_9pfs_front_init(dev))
+			xenbus_switch_state(dev, XenbusStateInitialised);
 		break;
 
 	case XenbusStateConnected:
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 71d18d3295f5..73779af2fed6 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -888,10 +888,6 @@ static int hci_sock_release(struct socket *sock)
 	}
 
 	sock_orphan(sk);
-
-	skb_queue_purge(&sk->sk_receive_queue);
-	skb_queue_purge(&sk->sk_write_queue);
-
 	release_sock(sk);
 	sock_put(sk);
 	return 0;
@@ -2012,6 +2008,12 @@ static int hci_sock_getsockopt(struct socket *sock, int level, int optname,
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
@@ -2065,6 +2067,7 @@ static int hci_sock_create(struct net *net, struct socket *sock, int protocol,
 
 	sock->state = SS_UNCONNECTED;
 	sk->sk_state = BT_OPEN;
+	sk->sk_destruct = hci_sock_destruct;
 
 	bt_sock_link(&hci_sk_list, sk);
 	return 0;
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index cf56582d298a..bde90df6b497 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -2679,14 +2679,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
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
@@ -2731,14 +2723,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
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
@@ -2759,14 +2743,6 @@ int l2cap_chan_send(struct l2cap_chan *chan, struct msghdr *msg, size_t len)
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
diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 06b80b584381..8335b7e4bcf6 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1049,7 +1049,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 
 	audit_log_nfcfg(repl->name, AF_BRIDGE, repl->nentries,
 			AUDIT_XT_OP_REPLACE, GFP_KERNEL);
-	return ret;
+	return 0;
 
 free_unlock:
 	mutex_unlock(&ebt_mutex);
diff --git a/net/core/dev.c b/net/core/dev.c
index b7646d4e079b..8cbcb6a104f2 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3119,8 +3119,10 @@ void __dev_kfree_skb_any(struct sk_buff *skb, enum skb_free_reason reason)
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
index 1bb6a003323b..c5ae520d4a69 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2968,7 +2968,7 @@ void sk_stop_timer_sync(struct sock *sk, struct timer_list *timer)
 }
 EXPORT_SYMBOL(sk_stop_timer_sync);
 
-void sock_init_data(struct socket *sock, struct sock *sk)
+void sock_init_data_uid(struct socket *sock, struct sock *sk, kuid_t uid)
 {
 	sk_init_common(sk);
 	sk->sk_send_head	=	NULL;
@@ -2987,11 +2987,10 @@ void sock_init_data(struct socket *sock, struct sock *sk)
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
@@ -3049,6 +3048,16 @@ void sock_init_data(struct socket *sock, struct sock *sk)
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
index 9ed59147ef66..e05dd87848f7 100644
--- a/net/ipv4/inet_connection_sock.c
+++ b/net/ipv4/inet_connection_sock.c
@@ -946,6 +946,7 @@ int inet_csk_listen_start(struct sock *sk, int backlog)
 	 * It is OK, because this socket enters to hash table only
 	 * after validation is complete.
 	 */
+	err = -EADDRINUSE;
 	inet_sk_state_store(sk, TCP_LISTEN);
 	if (!sk->sk_prot->get_port(sk, inet->inet_num)) {
 		inet->inet_sport = htons(inet->inet_num);
diff --git a/net/ipv4/inet_hashtables.c b/net/ipv4/inet_hashtables.c
index 2615b72118d1..79bf550c9dfc 100644
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
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index f77ea0dbe656..ec981618b7b2 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1044,7 +1044,6 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	struct xt_counters *counters;
 	struct ipt_entry *iter;
 
-	ret = 0;
 	counters = xt_counters_alloc(num_counters);
 	if (!counters) {
 		ret = -ENOMEM;
@@ -1090,7 +1089,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		net_warn_ratelimited("iptables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
-	return ret;
+	return 0;
 
  put_module:
 	module_put(t->me);
diff --git a/net/ipv4/tcp_minisocks.c b/net/ipv4/tcp_minisocks.c
index e42312321191..8d854feebdb0 100644
--- a/net/ipv4/tcp_minisocks.c
+++ b/net/ipv4/tcp_minisocks.c
@@ -565,6 +565,9 @@ EXPORT_SYMBOL(tcp_create_openreq_child);
  * validation and inside tcp_v4_reqsk_send_ack(). Can we do better?
  *
  * We don't need to initialize tmp_opt.sack_ok as we don't use the results
+ *
+ * Note: If @fastopen is true, this can be called from process context.
+ *       Otherwise, this is from BH context.
  */
 
 struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
@@ -717,7 +720,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 					  &tcp_rsk(req)->last_oow_ack_time))
 			req->rsk_ops->send_ack(sk, skb, req);
 		if (paws_reject)
-			__NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABREJECTED);
+			NET_INC_STATS(sock_net(sk), LINUX_MIB_PAWSESTABREJECTED);
 		return NULL;
 	}
 
@@ -736,7 +739,7 @@ struct sock *tcp_check_req(struct sock *sk, struct sk_buff *skb,
 	 *	   "fourth, check the SYN bit"
 	 */
 	if (flg & (TCP_FLAG_RST|TCP_FLAG_SYN)) {
-		__TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
+		TCP_INC_STATS(sock_net(sk), TCP_MIB_ATTEMPTFAILS);
 		goto embryonic_reset;
 	}
 
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index d36168baf677..99bb11d16712 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1062,7 +1062,6 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 	struct xt_counters *counters;
 	struct ip6t_entry *iter;
 
-	ret = 0;
 	counters = xt_counters_alloc(num_counters);
 	if (!counters) {
 		ret = -ENOMEM;
@@ -1108,7 +1107,7 @@ __do_replace(struct net *net, const char *name, unsigned int valid_hooks,
 		net_warn_ratelimited("ip6tables: counters copy to user failed while replacing table\n");
 	}
 	vfree(counters);
-	return ret;
+	return 0;
 
  put_module:
 	module_put(t->me);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 803d1aa83140..a6d5c99f65a3 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5444,16 +5444,17 @@ static size_t rt6_nlmsg_size(struct fib6_info *f6i)
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
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index aea85f91f059..5ecc0f200944 100644
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
index cee39ae52245..d572478c4d68 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -2159,7 +2159,7 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u32 rate,
 
 static int sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 {
-	u16 rate = READ_ONCE(sta_get_last_rx_stats(sta)->last_rate);
+	u32 rate = READ_ONCE(sta_get_last_rx_stats(sta)->last_rate);
 
 	if (rate == STA_STATS_RATE_INVALID)
 		return -EINVAL;
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 2efdc50f978b..f8ba3bc25cf3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2359,12 +2359,15 @@ ctnetlink_create_conntrack(struct net *net,
 
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
index 610caea4feec..3f4785be066a 100644
--- a/net/nfc/netlink.c
+++ b/net/nfc/netlink.c
@@ -1442,7 +1442,11 @@ static int nfc_se_io(struct nfc_dev *dev, u32 se_idx,
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
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index bc4e5da76fa6..697522371914 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -503,17 +503,6 @@ config NET_CLS_BASIC
 	  To compile this code as a module, choose M here: the
 	  module will be called cls_basic.
 
-config NET_CLS_TCINDEX
-	tristate "Traffic-Control Index (TCINDEX)"
-	select NET_CLS
-	help
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
index 66bbf9a98f9e..4311fdb21119 100644
--- a/net/sched/Makefile
+++ b/net/sched/Makefile
@@ -69,7 +69,6 @@ obj-$(CONFIG_NET_CLS_U32)	+= cls_u32.o
 obj-$(CONFIG_NET_CLS_ROUTE4)	+= cls_route.o
 obj-$(CONFIG_NET_CLS_FW)	+= cls_fw.o
 obj-$(CONFIG_NET_CLS_RSVP)	+= cls_rsvp.o
-obj-$(CONFIG_NET_CLS_TCINDEX)	+= cls_tcindex.o
 obj-$(CONFIG_NET_CLS_RSVP6)	+= cls_rsvp6.o
 obj-$(CONFIG_NET_CLS_BASIC)	+= cls_basic.o
 obj-$(CONFIG_NET_CLS_FLOW)	+= cls_flow.o
diff --git a/net/sched/act_sample.c b/net/sched/act_sample.c
index 2f0e98bcf494..6988a9cf4080 100644
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
index 2c0c95204cb5..000000000000
--- a/net/sched/cls_tcindex.c
+++ /dev/null
@@ -1,756 +0,0 @@
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
-#include <linux/rcupdate.h>
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
-	bool update_h = false;
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
-	if (cp->perfect) {
-		r = cp->perfect + handle;
-	} else {
-		/* imperfect area is updated in-place using rcu */
-		update_h = !!tcindex_lookup(cp, handle);
-		r = &new_filter_result;
-	}
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
-	if (update_h) {
-		struct tcindex_filter __rcu **fp;
-		struct tcindex_filter *cf;
-
-		f->result.res = r->res;
-		tcf_exts_change(&f->result.exts, &r->exts);
-
-		/* imperfect area bucket */
-		fp = cp->h + (handle % cp->hash);
-
-		/* lookup the filter, guaranteed to exist */
-		for (cf = rcu_dereference_bh_rtnl(*fp); cf;
-		     fp = &cf->next, cf = rcu_dereference_bh_rtnl(*fp))
-			if (cf->key == (u16)handle)
-				break;
-
-		f->next = cf->next;
-
-		cf = rcu_replace_pointer(*fp, f, 1);
-		tcf_exts_get_net(&cf->result.exts);
-		tcf_queue_work(&cf->rwork, tcindex_destroy_fexts_work);
-	} else if (r == &new_filter_result) {
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
-	    tp, handle, tca, arg, opt, p, r, *arg);
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
diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index c478108ca6a6..c6e8bd78e35d 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -3026,6 +3026,8 @@ rpc_clnt_swap_activate_callback(struct rpc_clnt *clnt,
 int
 rpc_clnt_swap_activate(struct rpc_clnt *clnt)
 {
+	while (clnt != clnt->cl_parent)
+		clnt = clnt->cl_parent;
 	if (atomic_inc_return(&clnt->cl_swapper) == 1)
 		return rpc_clnt_iterate_for_each_xprt(clnt,
 				rpc_clnt_swap_activate_callback, NULL);
@@ -3045,6 +3047,8 @@ rpc_clnt_swap_deactivate_callback(struct rpc_clnt *clnt,
 void
 rpc_clnt_swap_deactivate(struct rpc_clnt *clnt)
 {
+	while (clnt != clnt->cl_parent)
+		clnt = clnt->cl_parent;
 	if (atomic_dec_if_positive(&clnt->cl_swapper) == 0)
 		rpc_clnt_iterate_for_each_xprt(clnt,
 				rpc_clnt_swap_deactivate_callback, NULL);
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 21f20c3cda97..ac7feadb4390 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -949,7 +949,9 @@ int tls_sw_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 			       MSG_CMSG_COMPAT))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 
 	if (unlikely(msg->msg_controllen)) {
@@ -1283,7 +1285,9 @@ int tls_sw_sendpage(struct sock *sk, struct page *page,
 		      MSG_SENDPAGE_NOTLAST | MSG_SENDPAGE_NOPOLICY))
 		return -EOPNOTSUPP;
 
-	mutex_lock(&tls_ctx->tx_lock);
+	ret = mutex_lock_interruptible(&tls_ctx->tx_lock);
+	if (ret)
+		return ret;
 	lock_sock(sk);
 	ret = tls_sw_do_sendpage(sk, page, offset, size, flags);
 	release_sock(sk);
@@ -2266,11 +2270,19 @@ static void tx_work_handler(struct work_struct *work)
 
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
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8a7f0c8fba5e..ea36d8c47b31 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -12675,7 +12675,7 @@ static int nl80211_set_rekey_data(struct sk_buff *skb, struct genl_info *info)
 		return -ERANGE;
 	if (nla_len(tb[NL80211_REKEY_DATA_KCK]) != NL80211_KCK_LEN &&
 	    !(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK &&
-	      nla_len(tb[NL80211_REKEY_DATA_KEK]) == NL80211_KCK_EXT_LEN))
+	      nla_len(tb[NL80211_REKEY_DATA_KCK]) == NL80211_KCK_EXT_LEN))
 		return -ERANGE;
 
 	rekey_data.kek = nla_data(tb[NL80211_REKEY_DATA_KEK]);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 060e365c8259..f4d98ed8fa31 100644
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
@@ -1245,6 +1257,15 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
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
index 600b97677085..dd4b28b11ebe 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -378,7 +378,9 @@ static int process_measurement(struct file *file, const struct cred *cred,
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
@@ -386,7 +388,8 @@ static int process_measurement(struct file *file, const struct cred *cred,
  * On success return 0.  On integrity appraisal error, assuming the file
  * is in policy and IMA-appraisal is in enforcing mode, return -EACCES.
  */
-int ima_file_mmap(struct file *file, unsigned long prot)
+int ima_file_mmap(struct file *file, unsigned long reqprot,
+		  unsigned long prot, unsigned long flags)
 {
 	u32 secid;
 
diff --git a/security/security.c b/security/security.c
index 8ea826ea6167..f9157d5023c6 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1534,12 +1534,13 @@ static inline unsigned long mmap_prot(struct file *file, unsigned long prot)
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
index 82f14c3f642b..24c2638cde37 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -2331,7 +2331,7 @@ static int dspio_set_uint_param_no_source(struct hda_codec *codec, int mod_id,
 static int dspio_alloc_dma_chan(struct hda_codec *codec, unsigned int *dma_chan)
 {
 	int status = 0;
-	unsigned int size = sizeof(dma_chan);
+	unsigned int size = sizeof(*dma_chan);
 
 	codec_dbg(codec, "     dspio_alloc_dma_chan() -- begin\n");
 	status = dspio_scp(codec, MASTERCONTROL, 0x20,
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index fffa681313b6..f2ef75c8de42 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11153,6 +11153,7 @@ static const struct snd_pci_quirk alc662_fixup_tbl[] = {
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
index 46f3407ed0e8..39a3c2a33bdb 100644
--- a/sound/soc/atmel/mchp-spdifrx.c
+++ b/sound/soc/atmel/mchp-spdifrx.c
@@ -56,7 +56,7 @@
 /* Validity Bit Mode */
 #define SPDIFRX_MR_VBMODE_MASK		GENAMSK(1, 1)
 #define SPDIFRX_MR_VBMODE_ALWAYS_LOAD \
-	(0 << 1)	/* Load sample regardles of validity bit value */
+	(0 << 1)	/* Load sample regardless of validity bit value */
 #define SPDIFRX_MR_VBMODE_DISCARD_IF_VB1 \
 	(1 << 1)	/* Load sample only if validity bit is 0 */
 
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
-	/* IP might not be started or valid stream might not be prezent */
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
-	/* IP might not be started or valid stream might not be prezent */
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
diff --git a/sound/soc/atmel/mchp-spdiftx.c b/sound/soc/atmel/mchp-spdiftx.c
index 0d2e3fa21519..bcca1cf3cd7b 100644
--- a/sound/soc/atmel/mchp-spdiftx.c
+++ b/sound/soc/atmel/mchp-spdiftx.c
@@ -80,7 +80,7 @@
 #define SPDIFTX_MR_VALID1			BIT(24)
 #define SPDIFTX_MR_VALID2			BIT(25)
 
-/* Disable Null Frame on underrrun */
+/* Disable Null Frame on underrun */
 #define SPDIFTX_MR_DNFR_MASK		GENMASK(27, 27)
 #define SPDIFTX_MR_DNFR_INVALID		(0 << 27)
 #define SPDIFTX_MR_DNFR_VALID		(1 << 27)
diff --git a/sound/soc/atmel/tse850-pcm5142.c b/sound/soc/atmel/tse850-pcm5142.c
index 59e2edb22b3a..50c3dc6936f9 100644
--- a/sound/soc/atmel/tse850-pcm5142.c
+++ b/sound/soc/atmel/tse850-pcm5142.c
@@ -23,7 +23,7 @@
 //   IN2 +---o--+------------+--o---+ OUT2
 //               loop2 relays
 //
-// The 'loop1' gpio pin controlls two relays, which are either in loop
+// The 'loop1' gpio pin controls two relays, which are either in loop
 // position, meaning that input and output are directly connected, or
 // they are in mixer position, meaning that the signal is passed through
 // the 'Sum' mixer. Similarly for 'loop2'.
diff --git a/sound/soc/codecs/Kconfig b/sound/soc/codecs/Kconfig
index 25f331551f68..f1c9e563994b 100644
--- a/sound/soc/codecs/Kconfig
+++ b/sound/soc/codecs/Kconfig
@@ -1701,7 +1701,7 @@ config SND_SOC_WSA881X
 config SND_SOC_ZL38060
 	tristate "Microsemi ZL38060 Connected Home Audio Processor"
 	depends on SPI_MASTER
-	select GPIOLIB
+	depends on GPIOLIB
 	select REGMAP
 	help
 	  Support for ZL38060 Connected Home Audio Processor from Microsemi,
diff --git a/sound/soc/codecs/adau7118.c b/sound/soc/codecs/adau7118.c
index 841229dcbca1..305f294b7710 100644
--- a/sound/soc/codecs/adau7118.c
+++ b/sound/soc/codecs/adau7118.c
@@ -445,22 +445,6 @@ static const struct snd_soc_component_driver adau7118_component_driver = {
 	.non_legacy_dai_naming	= 1,
 };
 
-static void adau7118_regulator_disable(void *data)
-{
-	struct adau7118_data *st = data;
-	int ret;
-	/*
-	 * If we fail to disable DVDD, don't bother in trying IOVDD. We
-	 * actually don't want to be left in the situation where DVDD
-	 * is enabled and IOVDD is disabled.
-	 */
-	ret = regulator_disable(st->dvdd);
-	if (ret)
-		return;
-
-	regulator_disable(st->iovdd);
-}
-
 static int adau7118_regulator_setup(struct adau7118_data *st)
 {
 	st->iovdd = devm_regulator_get(st->dev, "iovdd");
@@ -482,8 +466,7 @@ static int adau7118_regulator_setup(struct adau7118_data *st)
 		regcache_cache_only(st->map, true);
 	}
 
-	return devm_add_action_or_reset(st->dev, adau7118_regulator_disable,
-					st);
+	return 0;
 }
 
 static int adau7118_parset_dt(const struct adau7118_data *st)
diff --git a/sound/soc/codecs/tlv320adcx140.c b/sound/soc/codecs/tlv320adcx140.c
index 53a80246aee1..a6241a045369 100644
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
index 3e5c1eaccd5e..6a5d2b08e271 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -230,6 +230,7 @@ static int fsl_sai_set_dai_fmt_tr(struct snd_soc_dai *cpu_dai,
 	if (!sai->is_lsb_first)
 		val_cr4 |= FSL_SAI_CR4_MF;
 
+	sai->is_dsp_mode = false;
 	/* DAI mode */
 	switch (fmt & SND_SOC_DAIFMT_FORMAT_MASK) {
 	case SND_SOC_DAIFMT_I2S:
diff --git a/sound/soc/kirkwood/kirkwood-dma.c b/sound/soc/kirkwood/kirkwood-dma.c
index e037826b2451..2d41e6ab2ce4 100644
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
index d0f3ff8edd90..8f4ebb189e01 100644
--- a/sound/soc/soc-compress.c
+++ b/sound/soc/soc-compress.c
@@ -822,7 +822,7 @@ int snd_soc_new_compress(struct snd_soc_pcm_runtime *rtd, int num)
 		rtd->fe_compr = 1;
 		if (rtd->dai_link->dpcm_playback)
 			be_pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream->private_data = rtd;
-		else if (rtd->dai_link->dpcm_capture)
+		if (rtd->dai_link->dpcm_capture)
 			be_pcm->streams[SNDRV_PCM_STREAM_CAPTURE].substream->private_data = rtd;
 		memcpy(compr->ops, &soc_compr_dyn_ops, sizeof(soc_compr_dyn_ops));
 	} else {
diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index 592536904dde..d2bcce627b32 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -1912,10 +1912,38 @@ static void profile_close_perf_events(struct profiler_bpf *obj)
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
@@ -1934,17 +1962,11 @@ static int profile_open_perf_events(struct profiler_bpf *obj)
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
diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
index e6f644cdc9f1..f7c48b1fb3a0 100644
--- a/tools/lib/bpf/btf.c
+++ b/tools/lib/bpf/btf.c
@@ -614,8 +614,21 @@ int btf__align_of(const struct btf *btf, __u32 id)
 			if (align <= 0)
 				return align;
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
index b607fa9852b1..1a04299a2a60 100644
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
index 985bcc5cea8a..9a0a54194636 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -180,6 +180,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		"kunit_try_catch_throw",
 		"xen_start_kernel",
 		"cpu_bringup_and_idle",
+		"stop_this_cpu",
 	};
 
 	if (!func)
@@ -571,6 +572,7 @@ static int create_static_call_sections(struct objtool_file *file)
 		if (strncmp(key_name, STATIC_CALL_TRAMP_PREFIX_STR,
 			    STATIC_CALL_TRAMP_PREFIX_LEN)) {
 			WARN("static_call: trampoline name malformed: %s", key_name);
+			free(key_name);
 			return -1;
 		}
 		tmp = key_name + STATIC_CALL_TRAMP_PREFIX_LEN - STATIC_CALL_KEY_PREFIX_LEN;
@@ -580,6 +582,7 @@ static int create_static_call_sections(struct objtool_file *file)
 		if (!key_sym) {
 			if (!module) {
 				WARN("static_call: can't find static_call_key symbol: %s", tmp);
+				free(key_name);
 				return -1;
 			}
 
@@ -863,6 +866,8 @@ static const char *uaccess_safe_builtin[] = {
 	"__tsan_atomic64_compare_exchange_val",
 	"__tsan_atomic_thread_fence",
 	"__tsan_atomic_signal_fence",
+	"__tsan_unaligned_read16",
+	"__tsan_unaligned_write16",
 	/* KCOV */
 	"write_comp_data",
 	"check_kcov_mode",
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
index 0bf6b4d4c90a..570cde4640d0 100644
--- a/tools/perf/util/llvm-utils.c
+++ b/tools/perf/util/llvm-utils.c
@@ -525,14 +525,37 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
 
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
index 8b1e3ae8fe50..ea26f2b0c1bc 100755
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
@@ -1433,7 +1435,8 @@ sub reboot {
 
 	# Still need to wait for the reboot to finish
 	wait_for_monitor($time, $reboot_success_line);
-
+    }
+    if ($powercycle || $time) {
 	end_monitor;
     }
 }
@@ -1799,6 +1802,14 @@ sub run_command {
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
 
@@ -1825,13 +1836,10 @@ sub run_command {
 
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
@@ -2004,6 +2012,11 @@ sub wait_for_input
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
@@ -4283,6 +4296,9 @@ sub send_email {
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
index 1d9155533360..a845724e0906 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -119,8 +119,6 @@ RESOLVE_BTFIDS := $(BUILD_DIR)/resolve_btfids/resolve_btfids
 # NOTE: Semicolon at the end is critical to override lib.mk's default static
 # rule for binaries.
 $(notdir $(TEST_GEN_PROGS)						\
-	 $(TEST_PROGS)							\
-	 $(TEST_PROGS_EXTENDED)						\
 	 $(TEST_GEN_PROGS_EXTENDED)					\
 	 $(TEST_CUSTOM_PROGS)): %: $(OUTPUT)/% ;
 
diff --git a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
index 16d2de18591d..2c81e01c30b3 100755
--- a/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
+++ b/tools/testing/selftests/drivers/net/netdevsim/devlink.sh
@@ -16,6 +16,18 @@ SYSFS_NET_DIR=/sys/bus/netdevsim/devices/$DEV_NAME/net/
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
@@ -255,6 +267,9 @@ netns_reload_test()
 	ip netns del testns2
 	ip netns del testns1
 
+	# Wait until netns async cleanup is done.
+	devlink_wait 2000
+
 	log_test "netns reload test"
 }
 
@@ -347,6 +362,9 @@ resource_test()
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
diff --git a/tools/testing/selftests/net/fib_tests.sh b/tools/testing/selftests/net/fib_tests.sh
index 0f3bf90e04d3..8f42e17db5d0 100755
--- a/tools/testing/selftests/net/fib_tests.sh
+++ b/tools/testing/selftests/net/fib_tests.sh
@@ -1773,6 +1773,8 @@ EOF
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
index d5bebb37238c..ce6f3b916ef9 100644
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
 
