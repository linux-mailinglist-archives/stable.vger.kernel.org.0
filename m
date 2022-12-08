Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35635646D17
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 11:35:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230194AbiLHKfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 05:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbiLHKfc (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 05:35:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0535A7F89F;
        Thu,  8 Dec 2022 02:33:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4D7BC61EAD;
        Thu,  8 Dec 2022 10:33:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0657FC433D7;
        Thu,  8 Dec 2022 10:33:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670495600;
        bh=u/CT5AtRMch3fswWdUyJjQJiF77iskB2+v6ah4Dudfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iVqKy9jTsxmeaBaGFSSzp+bqzE9qCgdR7dqCF4EeZAAbAEatb1ww+91IcPHsaEPRI
         OqBAUW0ZoQfmDInhUQlDK8+rVG+UWjC8vmkpe9I+0/DJa67I1bQUiqAr4rNhBT+KIj
         9yYZ5YzQZ+hpwR7u6gMvpQ66Z4LrFyzm59+Apuvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.158
Date:   Thu,  8 Dec 2022 11:33:12 +0100
Message-Id: <1670495591534@kroah.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <1670495591191180@kroah.com>
References: <1670495591191180@kroah.com>
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

diff --git a/Makefile b/Makefile
index bf22df29c4d8..f3d1f07b6a6f 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 157
+SUBLEVEL = 158
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/arm/boot/dts/at91rm9200.dtsi b/arch/arm/boot/dts/at91rm9200.dtsi
index d1181ead18e5..21344fbc89e5 100644
--- a/arch/arm/boot/dts/at91rm9200.dtsi
+++ b/arch/arm/boot/dts/at91rm9200.dtsi
@@ -660,7 +660,7 @@ usb1: gadget@fffb0000 {
 				compatible = "atmel,at91rm9200-udc";
 				reg = <0xfffb0000 0x4000>;
 				interrupts = <11 IRQ_TYPE_LEVEL_HIGH 2>;
-				clocks = <&pmc PMC_TYPE_PERIPHERAL 11>, <&pmc PMC_TYPE_SYSTEM 2>;
+				clocks = <&pmc PMC_TYPE_PERIPHERAL 11>, <&pmc PMC_TYPE_SYSTEM 1>;
 				clock-names = "pclk", "hclk";
 				status = "disabled";
 			};
diff --git a/arch/riscv/kernel/vdso/Makefile b/arch/riscv/kernel/vdso/Makefile
index c92b55a0ec1c..f4ac7ff56bce 100644
--- a/arch/riscv/kernel/vdso/Makefile
+++ b/arch/riscv/kernel/vdso/Makefile
@@ -17,6 +17,7 @@ vdso-syms += flush_icache
 obj-vdso = $(patsubst %, %.o, $(vdso-syms)) note.o
 
 ccflags-y := -fno-stack-protector
+ccflags-y += -DDISABLE_BRANCH_PROFILING
 
 ifneq ($(c-gettimeofday-y),)
   CFLAGS_vgettimeofday.o += -fPIC -include $(c-gettimeofday-y)
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index f507ad7c7fd7..1fcda8263554 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -300,6 +300,7 @@
 #define X86_FEATURE_UNRET		(11*32+15) /* "" AMD BTB untrain return */
 #define X86_FEATURE_USE_IBPB_FW		(11*32+16) /* "" Use IBPB during runtime firmware calls */
 #define X86_FEATURE_RSB_VMEXIT_LITE	(11*32+17) /* "" Fill RSB on VM exit when EIBRS is enabled */
+#define X86_FEATURE_MSR_TSX_CTRL	(11*32+18) /* "" MSR IA32_TSX_CTRL (Intel) implemented */
 
 /* Intel-defined CPU features, CPUID level 0x00000007:1 (EAX), word 12 */
 #define X86_FEATURE_AVX512_BF16		(12*32+ 5) /* AVX512 BFLOAT16 instructions */
diff --git a/arch/x86/include/asm/nospec-branch.h b/arch/x86/include/asm/nospec-branch.h
index 07f5030073bb..f14cdf951249 100644
--- a/arch/x86/include/asm/nospec-branch.h
+++ b/arch/x86/include/asm/nospec-branch.h
@@ -310,7 +310,7 @@ static inline void indirect_branch_prediction_barrier(void)
 /* The Intel SPEC CTRL MSR base value cache */
 extern u64 x86_spec_ctrl_base;
 DECLARE_PER_CPU(u64, x86_spec_ctrl_current);
-extern void write_spec_ctrl_current(u64 val, bool force);
+extern void update_spec_ctrl_cond(u64 val);
 extern u64 spec_ctrl_current(void);
 
 /*
diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index a300a19255b6..e2e22a5740a4 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -59,11 +59,18 @@ EXPORT_SYMBOL_GPL(x86_spec_ctrl_current);
 
 static DEFINE_MUTEX(spec_ctrl_mutex);
 
+/* Update SPEC_CTRL MSR and its cached copy unconditionally */
+static void update_spec_ctrl(u64 val)
+{
+	this_cpu_write(x86_spec_ctrl_current, val);
+	wrmsrl(MSR_IA32_SPEC_CTRL, val);
+}
+
 /*
  * Keep track of the SPEC_CTRL MSR value for the current task, which may differ
  * from x86_spec_ctrl_base due to STIBP/SSB in __speculation_ctrl_update().
  */
-void write_spec_ctrl_current(u64 val, bool force)
+void update_spec_ctrl_cond(u64 val)
 {
 	if (this_cpu_read(x86_spec_ctrl_current) == val)
 		return;
@@ -74,7 +81,7 @@ void write_spec_ctrl_current(u64 val, bool force)
 	 * When KERNEL_IBRS this MSR is written on return-to-user, unless
 	 * forced the update can be delayed until that time.
 	 */
-	if (force || !cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS))
+	if (!cpu_feature_enabled(X86_FEATURE_KERNEL_IBRS))
 		wrmsrl(MSR_IA32_SPEC_CTRL, val);
 }
 
@@ -1291,7 +1298,7 @@ static void __init spec_ctrl_disable_kernel_rrsba(void)
 
 	if (ia32_cap & ARCH_CAP_RRSBA) {
 		x86_spec_ctrl_base |= SPEC_CTRL_RRSBA_DIS_S;
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		update_spec_ctrl(x86_spec_ctrl_base);
 	}
 }
 
@@ -1413,7 +1420,7 @@ static void __init spectre_v2_select_mitigation(void)
 
 	if (spectre_v2_in_ibrs_mode(mode)) {
 		x86_spec_ctrl_base |= SPEC_CTRL_IBRS;
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		update_spec_ctrl(x86_spec_ctrl_base);
 	}
 
 	switch (mode) {
@@ -1527,7 +1534,7 @@ static void __init spectre_v2_select_mitigation(void)
 static void update_stibp_msr(void * __unused)
 {
 	u64 val = spec_ctrl_current() | (x86_spec_ctrl_base & SPEC_CTRL_STIBP);
-	write_spec_ctrl_current(val, true);
+	update_spec_ctrl(val);
 }
 
 /* Update x86_spec_ctrl_base in case SMT state changed. */
@@ -1760,7 +1767,7 @@ static enum ssb_mitigation __init __ssb_select_mitigation(void)
 			x86_amd_ssb_disable();
 		} else {
 			x86_spec_ctrl_base |= SPEC_CTRL_SSBD;
-			write_spec_ctrl_current(x86_spec_ctrl_base, true);
+			update_spec_ctrl(x86_spec_ctrl_base);
 		}
 	}
 
@@ -1978,7 +1985,7 @@ int arch_prctl_spec_ctrl_get(struct task_struct *task, unsigned long which)
 void x86_spec_ctrl_setup_ap(void)
 {
 	if (boot_cpu_has(X86_FEATURE_MSR_SPEC_CTRL))
-		write_spec_ctrl_current(x86_spec_ctrl_base, true);
+		update_spec_ctrl(x86_spec_ctrl_base);
 
 	if (ssb_mode == SPEC_STORE_BYPASS_DISABLE)
 		x86_amd_ssb_disable();
diff --git a/arch/x86/kernel/cpu/tsx.c b/arch/x86/kernel/cpu/tsx.c
index e2ad30e474f8..da06bbb5d68e 100644
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -58,24 +58,6 @@ void tsx_enable(void)
 	wrmsrl(MSR_IA32_TSX_CTRL, tsx);
 }
 
-static bool __init tsx_ctrl_is_supported(void)
-{
-	u64 ia32_cap = x86_read_arch_cap_msr();
-
-	/*
-	 * TSX is controlled via MSR_IA32_TSX_CTRL.  However, support for this
-	 * MSR is enumerated by ARCH_CAP_TSX_MSR bit in MSR_IA32_ARCH_CAPABILITIES.
-	 *
-	 * TSX control (aka MSR_IA32_TSX_CTRL) is only available after a
-	 * microcode update on CPUs that have their MSR_IA32_ARCH_CAPABILITIES
-	 * bit MDS_NO=1. CPUs with MDS_NO=0 are not planned to get
-	 * MSR_IA32_TSX_CTRL support even after a microcode update. Thus,
-	 * tsx= cmdline requests will do nothing on CPUs without
-	 * MSR_IA32_TSX_CTRL support.
-	 */
-	return !!(ia32_cap & ARCH_CAP_TSX_CTRL_MSR);
-}
-
 static enum tsx_ctrl_states x86_get_tsx_auto_mode(void)
 {
 	if (boot_cpu_has_bug(X86_BUG_TAA))
@@ -89,9 +71,22 @@ void __init tsx_init(void)
 	char arg[5] = {};
 	int ret;
 
-	if (!tsx_ctrl_is_supported())
+	/*
+	 * TSX is controlled via MSR_IA32_TSX_CTRL.  However, support for this
+	 * MSR is enumerated by ARCH_CAP_TSX_MSR bit in MSR_IA32_ARCH_CAPABILITIES.
+	 *
+	 * TSX control (aka MSR_IA32_TSX_CTRL) is only available after a
+	 * microcode update on CPUs that have their MSR_IA32_ARCH_CAPABILITIES
+	 * bit MDS_NO=1. CPUs with MDS_NO=0 are not planned to get
+	 * MSR_IA32_TSX_CTRL support even after a microcode update. Thus,
+	 * tsx= cmdline requests will do nothing on CPUs without
+	 * MSR_IA32_TSX_CTRL support.
+	 */
+	if (!(x86_read_arch_cap_msr() & ARCH_CAP_TSX_CTRL_MSR))
 		return;
 
+	setup_force_cpu_cap(X86_FEATURE_MSR_TSX_CTRL);
+
 	ret = cmdline_find_option(boot_command_line, "tsx", arg, sizeof(arg));
 	if (ret >= 0) {
 		if (!strcmp(arg, "on")) {
diff --git a/arch/x86/kernel/process.c b/arch/x86/kernel/process.c
index 4505d845daba..383afcc1098b 100644
--- a/arch/x86/kernel/process.c
+++ b/arch/x86/kernel/process.c
@@ -556,7 +556,7 @@ static __always_inline void __speculation_ctrl_update(unsigned long tifp,
 	}
 
 	if (updmsr)
-		write_spec_ctrl_current(msr, false);
+		update_spec_ctrl_cond(msr);
 }
 
 static unsigned long speculation_ctrl_update_tif(struct task_struct *tsk)
diff --git a/arch/x86/power/cpu.c b/arch/x86/power/cpu.c
index 61581c45788e..4e4e76ecd3ec 100644
--- a/arch/x86/power/cpu.c
+++ b/arch/x86/power/cpu.c
@@ -516,16 +516,23 @@ static int pm_cpu_check(const struct x86_cpu_id *c)
 
 static void pm_save_spec_msr(void)
 {
-	u32 spec_msr_id[] = {
-		MSR_IA32_SPEC_CTRL,
-		MSR_IA32_TSX_CTRL,
-		MSR_TSX_FORCE_ABORT,
-		MSR_IA32_MCU_OPT_CTRL,
-		MSR_AMD64_LS_CFG,
-		MSR_AMD64_DE_CFG,
+	struct msr_enumeration {
+		u32 msr_no;
+		u32 feature;
+	} msr_enum[] = {
+		{ MSR_IA32_SPEC_CTRL,	 X86_FEATURE_MSR_SPEC_CTRL },
+		{ MSR_IA32_TSX_CTRL,	 X86_FEATURE_MSR_TSX_CTRL },
+		{ MSR_TSX_FORCE_ABORT,	 X86_FEATURE_TSX_FORCE_ABORT },
+		{ MSR_IA32_MCU_OPT_CTRL, X86_FEATURE_SRBDS_CTRL },
+		{ MSR_AMD64_LS_CFG,	 X86_FEATURE_LS_CFG_SSBD },
+		{ MSR_AMD64_DE_CFG,	 X86_FEATURE_LFENCE_RDTSC },
 	};
+	int i;
 
-	msr_build_context(spec_msr_id, ARRAY_SIZE(spec_msr_id));
+	for (i = 0; i < ARRAY_SIZE(msr_enum); i++) {
+		if (boot_cpu_has(msr_enum[i].feature))
+			msr_build_context(&msr_enum[i].msr_no, 1);
+	}
 }
 
 static int pm_check_save_msr(void)
diff --git a/block/partitions/core.c b/block/partitions/core.c
index a02e22411594..e3d61ec4a5a6 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -329,6 +329,7 @@ void delete_partition(struct hd_struct *part)
 	struct gendisk *disk = part_to_disk(part);
 	struct disk_part_tbl *ptbl =
 		rcu_dereference_protected(disk->part_tbl, 1);
+	struct block_device *bdev;
 
 	/*
 	 * ->part_tbl is referenced in this part's release handler, so
@@ -346,6 +347,12 @@ void delete_partition(struct hd_struct *part)
 	 * "in-use" until we really free the gendisk.
 	 */
 	blk_invalidate_devt(part_devt(part));
+
+	bdev = bdget_part(part);
+	if (bdev) {
+		remove_inode_hash(bdev->bd_inode);
+		bdput(bdev);
+	}
 	percpu_ref_kill(&part->ref);
 }
 
diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
index 137a5dd880c2..26453a945da4 100644
--- a/drivers/acpi/numa/hmat.c
+++ b/drivers/acpi/numa/hmat.c
@@ -563,17 +563,26 @@ static int initiator_cmp(void *priv, const struct list_head *a,
 {
 	struct memory_initiator *ia;
 	struct memory_initiator *ib;
-	unsigned long *p_nodes = priv;
 
 	ia = list_entry(a, struct memory_initiator, node);
 	ib = list_entry(b, struct memory_initiator, node);
 
-	set_bit(ia->processor_pxm, p_nodes);
-	set_bit(ib->processor_pxm, p_nodes);
-
 	return ia->processor_pxm - ib->processor_pxm;
 }
 
+static int initiators_to_nodemask(unsigned long *p_nodes)
+{
+	struct memory_initiator *initiator;
+
+	if (list_empty(&initiators))
+		return -ENXIO;
+
+	list_for_each_entry(initiator, &initiators, node)
+		set_bit(initiator->processor_pxm, p_nodes);
+
+	return 0;
+}
+
 static void hmat_register_target_initiators(struct memory_target *target)
 {
 	static DECLARE_BITMAP(p_nodes, MAX_NUMNODES);
@@ -610,7 +619,10 @@ static void hmat_register_target_initiators(struct memory_target *target)
 	 * initiators.
 	 */
 	bitmap_zero(p_nodes, MAX_NUMNODES);
-	list_sort(p_nodes, &initiators, initiator_cmp);
+	list_sort(NULL, &initiators, initiator_cmp);
+	if (initiators_to_nodemask(p_nodes) < 0)
+		return;
+
 	if (!access0done) {
 		for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
 			loc = localities_types[i];
@@ -644,8 +656,9 @@ static void hmat_register_target_initiators(struct memory_target *target)
 
 	/* Access 1 ignores Generic Initiators */
 	bitmap_zero(p_nodes, MAX_NUMNODES);
-	list_sort(p_nodes, &initiators, initiator_cmp);
-	best = 0;
+	if (initiators_to_nodemask(p_nodes) < 0)
+		return;
+
 	for (i = WRITE_LATENCY; i <= READ_BANDWIDTH; i++) {
 		loc = localities_types[i];
 		if (!loc)
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index 1621ce818705..d69905233aff 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -401,13 +401,14 @@ int tpm_pm_suspend(struct device *dev)
 	    !pm_suspend_via_firmware())
 		goto suspended;
 
-	if (!tpm_chip_start(chip)) {
+	rc = tpm_try_get_ops(chip);
+	if (!rc) {
 		if (chip->flags & TPM_CHIP_FLAG_TPM2)
 			tpm2_shutdown(chip, TPM2_SU_STATE);
 		else
 			rc = tpm1_pm_suspend(chip, tpm_suspend_pcr);
 
-		tpm_chip_stop(chip);
+		tpm_put_ops(chip);
 	}
 
 suspended:
diff --git a/drivers/clk/at91/at91rm9200.c b/drivers/clk/at91/at91rm9200.c
index 2c3d8e6ca63c..7cc20c0f8865 100644
--- a/drivers/clk/at91/at91rm9200.c
+++ b/drivers/clk/at91/at91rm9200.c
@@ -38,7 +38,7 @@ static const struct clk_pll_characteristics rm9200_pll_characteristics = {
 };
 
 static const struct sck at91rm9200_systemck[] = {
-	{ .n = "udpck", .p = "usbck",    .id = 2 },
+	{ .n = "udpck", .p = "usbck",    .id = 1 },
 	{ .n = "uhpck", .p = "usbck",    .id = 4 },
 	{ .n = "pck0",  .p = "prog0",    .id = 8 },
 	{ .n = "pck1",  .p = "prog1",    .id = 9 },
diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index 0e7748df4be3..c51c5ed15aa7 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -32,7 +32,7 @@ static int riscv_clock_next_event(unsigned long delta,
 static unsigned int riscv_clock_event_irq;
 static DEFINE_PER_CPU(struct clock_event_device, riscv_clock_event) = {
 	.name			= "riscv_timer_clockevent",
-	.features		= CLOCK_EVT_FEAT_ONESHOT | CLOCK_EVT_FEAT_C3STOP,
+	.features		= CLOCK_EVT_FEAT_ONESHOT,
 	.rating			= 100,
 	.set_next_event		= riscv_clock_next_event,
 };
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
index 98d3661336a4..aabfe5705bb8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_connectors.c
@@ -315,8 +315,10 @@ static void amdgpu_connector_get_edid(struct drm_connector *connector)
 	if (!amdgpu_connector->edid) {
 		/* some laptops provide a hardcoded edid in rom for LCDs */
 		if (((connector->connector_type == DRM_MODE_CONNECTOR_LVDS) ||
-		     (connector->connector_type == DRM_MODE_CONNECTOR_eDP)))
+		     (connector->connector_type == DRM_MODE_CONNECTOR_eDP))) {
 			amdgpu_connector->edid = amdgpu_connector_get_hardcoded_edid(adev);
+			drm_connector_update_edid_property(connector, amdgpu_connector->edid);
+		}
 	}
 }
 
diff --git a/drivers/gpu/drm/amd/display/Kconfig b/drivers/gpu/drm/amd/display/Kconfig
index f3274eb6b341..6c4cba09d23b 100644
--- a/drivers/gpu/drm/amd/display/Kconfig
+++ b/drivers/gpu/drm/amd/display/Kconfig
@@ -5,6 +5,7 @@ menu "Display Engine Configuration"
 config DRM_AMD_DC
 	bool "AMD DC - Enable new display engine"
 	default y
+	depends on BROKEN || !CC_IS_CLANG || X86_64 || SPARC64 || ARM64
 	select SND_HDA_COMPONENT if SND_HDA_CORE
 	select DRM_AMD_DC_DCN if (X86 || PPC64) && !(KCOV_INSTRUMENT_ALL && KCOV_ENABLE_COMPARISONS)
 	help
@@ -12,6 +13,12 @@ config DRM_AMD_DC
 	  support for AMDGPU. This adds required support for Vega and
 	  Raven ASICs.
 
+	  calculate_bandwidth() is presently broken on all !(X86_64 || SPARC64 || ARM64)
+	  architectures built with Clang (all released versions), whereby the stack
+	  frame gets blown up to well over 5k.  This would cause an immediate kernel
+	  panic on most architectures.  We'll revert this when the following bug report
+	  has been resolved: https://github.com/llvm/llvm-project/issues/41896.
+
 config DRM_AMD_DC_DCN
 	def_bool n
 	help
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 55ecc67592eb..167a1ee518a8 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2348,13 +2348,12 @@ void amdgpu_dm_update_connector_after_detect(
 			aconnector->edid =
 				(struct edid *)sink->dc_edid.raw_edid;
 
-			drm_connector_update_edid_property(connector,
-							   aconnector->edid);
 			if (aconnector->dc_link->aux_mode)
 				drm_dp_cec_set_edid(&aconnector->dm_dp_aux.aux,
 						    aconnector->edid);
 		}
 
+		drm_connector_update_edid_property(connector, aconnector->edid);
 		amdgpu_dm_update_freesync_caps(connector, aconnector->edid);
 		update_connector_ext_caps(aconnector);
 	} else {
diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 4272cd3622f8..0feeac52e4eb 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -5238,7 +5238,7 @@ int drm_dp_mst_add_affected_dsc_crtcs(struct drm_atomic_state *state, struct drm
 	mst_state = drm_atomic_get_mst_topology_state(state, mgr);
 
 	if (IS_ERR(mst_state))
-		return -EINVAL;
+		return PTR_ERR(mst_state);
 
 	list_for_each_entry(pos, &mst_state->vcpis, next) {
 
diff --git a/drivers/gpu/drm/i915/gt/intel_gt_requests.c b/drivers/gpu/drm/i915/gt/intel_gt_requests.c
index 66fcbf9d0fdd..cca285185dc4 100644
--- a/drivers/gpu/drm/i915/gt/intel_gt_requests.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt_requests.c
@@ -200,7 +200,7 @@ out_active:	spin_lock(&timelines->lock);
 	if (flush_submission(gt, timeout)) /* Wait, there's more! */
 		active_count++;
 
-	return active_count ? timeout : 0;
+	return active_count ? timeout ?: -ETIME : 0;
 }
 
 int intel_gt_wait_for_idle(struct intel_gt *gt, long timeout)
diff --git a/drivers/hwmon/coretemp.c b/drivers/hwmon/coretemp.c
index 032129292957..42b84ebff057 100644
--- a/drivers/hwmon/coretemp.c
+++ b/drivers/hwmon/coretemp.c
@@ -242,10 +242,13 @@ static int adjust_tjmax(struct cpuinfo_x86 *c, u32 id, struct device *dev)
 	 */
 	if (host_bridge && host_bridge->vendor == PCI_VENDOR_ID_INTEL) {
 		for (i = 0; i < ARRAY_SIZE(tjmax_pci_table); i++) {
-			if (host_bridge->device == tjmax_pci_table[i].device)
+			if (host_bridge->device == tjmax_pci_table[i].device) {
+				pci_dev_put(host_bridge);
 				return tjmax_pci_table[i].tjmax;
+			}
 		}
 	}
+	pci_dev_put(host_bridge);
 
 	for (i = 0; i < ARRAY_SIZE(tjmax_table); i++) {
 		if (strstr(c->x86_model_id, tjmax_table[i].id))
@@ -533,6 +536,10 @@ static void coretemp_remove_core(struct platform_data *pdata, int indx)
 {
 	struct temp_data *tdata = pdata->core_data[indx];
 
+	/* if we errored on add then this is already gone */
+	if (!tdata)
+		return;
+
 	/* Remove the sysfs attributes */
 	sysfs_remove_group(&pdata->hwmon_dev->kobj, &tdata->attr_group);
 
diff --git a/drivers/hwmon/i5500_temp.c b/drivers/hwmon/i5500_temp.c
index 360f5aee1394..d4be03f43fb4 100644
--- a/drivers/hwmon/i5500_temp.c
+++ b/drivers/hwmon/i5500_temp.c
@@ -108,7 +108,7 @@ static int i5500_temp_probe(struct pci_dev *pdev,
 	u32 tstimer;
 	s8 tsfsc;
 
-	err = pci_enable_device(pdev);
+	err = pcim_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "Failed to enable device\n");
 		return err;
diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index b2ab83c9fd9a..fe90f0536d76 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -502,6 +502,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
 	return;
 
 out_register:
+	list_del(&data->list);
 	hwmon_device_unregister(data->hwmon_dev);
 out_user:
 	ipmi_destroy_user(data->user);
diff --git a/drivers/hwmon/ina3221.c b/drivers/hwmon/ina3221.c
index ad11cbddc3a7..d3c98115042b 100644
--- a/drivers/hwmon/ina3221.c
+++ b/drivers/hwmon/ina3221.c
@@ -230,7 +230,7 @@ static int ina3221_read_value(struct ina3221_data *ina, unsigned int reg,
 	 * Shunt Voltage Sum register has 14-bit value with 1-bit shift
 	 * Other Shunt Voltage registers have 12 bits with 3-bit shift
 	 */
-	if (reg == INA3221_SHUNT_SUM)
+	if (reg == INA3221_SHUNT_SUM || reg == INA3221_CRIT_SUM)
 		*val = sign_extend32(regval >> 1, 14);
 	else
 		*val = sign_extend32(regval >> 3, 12);
@@ -465,7 +465,7 @@ static int ina3221_write_curr(struct device *dev, u32 attr,
 	 *     SHUNT_SUM: (1 / 40uV) << 1 = 1 / 20uV
 	 *     SHUNT[1-3]: (1 / 40uV) << 3 = 1 / 5uV
 	 */
-	if (reg == INA3221_SHUNT_SUM)
+	if (reg == INA3221_SHUNT_SUM || reg == INA3221_CRIT_SUM)
 		regval = DIV_ROUND_CLOSEST(voltage_uv, 20) & 0xfffe;
 	else
 		regval = DIV_ROUND_CLOSEST(voltage_uv, 5) & 0xfff8;
diff --git a/drivers/hwmon/ltc2947-core.c b/drivers/hwmon/ltc2947-core.c
index 5423466de697..e918490f3ff7 100644
--- a/drivers/hwmon/ltc2947-core.c
+++ b/drivers/hwmon/ltc2947-core.c
@@ -396,7 +396,7 @@ static int ltc2947_read_temp(struct device *dev, const u32 attr, long *val,
 		return ret;
 
 	/* in milidegrees celcius, temp is given by: */
-	*val = (__val * 204) + 550;
+	*val = (__val * 204) + 5500;
 
 	return 0;
 }
diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index be4ad516293b..b4fb4336b4e8 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -843,7 +843,8 @@ static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs,
 	int i, result;
 	unsigned int temp;
 	int block_data = msgs->flags & I2C_M_RECV_LEN;
-	int use_dma = i2c_imx->dma && msgs->len >= DMA_THRESHOLD && !block_data;
+	int use_dma = i2c_imx->dma && msgs->flags & I2C_M_DMA_SAFE &&
+		msgs->len >= DMA_THRESHOLD && !block_data;
 
 	dev_dbg(&i2c_imx->adapter.dev,
 		"<%s> write slave address: addr=0x%x\n",
@@ -1011,7 +1012,8 @@ static int i2c_imx_xfer_common(struct i2c_adapter *adapter,
 			result = i2c_imx_read(i2c_imx, &msgs[i], is_lastmsg, atomic);
 		} else {
 			if (!atomic &&
-			    i2c_imx->dma && msgs[i].len >= DMA_THRESHOLD)
+			    i2c_imx->dma && msgs[i].len >= DMA_THRESHOLD &&
+				msgs[i].flags & I2C_M_DMA_SAFE)
 				result = i2c_imx_dma_write(i2c_imx, &msgs[i]);
 			else
 				result = i2c_imx_write(i2c_imx, &msgs[i], atomic);
diff --git a/drivers/i2c/busses/i2c-npcm7xx.c b/drivers/i2c/busses/i2c-npcm7xx.c
index 31e3d2c9d6bc..c1b679737240 100644
--- a/drivers/i2c/busses/i2c-npcm7xx.c
+++ b/drivers/i2c/busses/i2c-npcm7xx.c
@@ -2362,8 +2362,17 @@ static struct platform_driver npcm_i2c_bus_driver = {
 
 static int __init npcm_i2c_init(void)
 {
+	int ret;
+
 	npcm_i2c_debugfs_dir = debugfs_create_dir("npcm_i2c", NULL);
-	return platform_driver_register(&npcm_i2c_bus_driver);
+
+	ret = platform_driver_register(&npcm_i2c_bus_driver);
+	if (ret) {
+		debugfs_remove_recursive(npcm_i2c_debugfs_dir);
+		return ret;
+	}
+
+	return 0;
 }
 module_init(npcm_i2c_init);
 
diff --git a/drivers/iio/health/afe4403.c b/drivers/iio/health/afe4403.c
index 38734e4ce360..82d01ac36128 100644
--- a/drivers/iio/health/afe4403.c
+++ b/drivers/iio/health/afe4403.c
@@ -245,14 +245,14 @@ static int afe4403_read_raw(struct iio_dev *indio_dev,
 			    int *val, int *val2, long mask)
 {
 	struct afe4403_data *afe = iio_priv(indio_dev);
-	unsigned int reg = afe4403_channel_values[chan->address];
-	unsigned int field = afe4403_channel_leds[chan->address];
+	unsigned int reg, field;
 	int ret;
 
 	switch (chan->type) {
 	case IIO_INTENSITY:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			reg = afe4403_channel_values[chan->address];
 			ret = afe4403_read(afe, reg, val);
 			if (ret)
 				return ret;
@@ -262,6 +262,7 @@ static int afe4403_read_raw(struct iio_dev *indio_dev,
 	case IIO_CURRENT:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			field = afe4403_channel_leds[chan->address];
 			ret = regmap_field_read(afe->fields[field], val);
 			if (ret)
 				return ret;
diff --git a/drivers/iio/health/afe4404.c b/drivers/iio/health/afe4404.c
index 61fe4932d81d..0eaa34da59a8 100644
--- a/drivers/iio/health/afe4404.c
+++ b/drivers/iio/health/afe4404.c
@@ -250,20 +250,20 @@ static int afe4404_read_raw(struct iio_dev *indio_dev,
 			    int *val, int *val2, long mask)
 {
 	struct afe4404_data *afe = iio_priv(indio_dev);
-	unsigned int value_reg = afe4404_channel_values[chan->address];
-	unsigned int led_field = afe4404_channel_leds[chan->address];
-	unsigned int offdac_field = afe4404_channel_offdacs[chan->address];
+	unsigned int value_reg, led_field, offdac_field;
 	int ret;
 
 	switch (chan->type) {
 	case IIO_INTENSITY:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			value_reg = afe4404_channel_values[chan->address];
 			ret = regmap_read(afe->regmap, value_reg, val);
 			if (ret)
 				return ret;
 			return IIO_VAL_INT;
 		case IIO_CHAN_INFO_OFFSET:
+			offdac_field = afe4404_channel_offdacs[chan->address];
 			ret = regmap_field_read(afe->fields[offdac_field], val);
 			if (ret)
 				return ret;
@@ -273,6 +273,7 @@ static int afe4404_read_raw(struct iio_dev *indio_dev,
 	case IIO_CURRENT:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			led_field = afe4404_channel_leds[chan->address];
 			ret = regmap_field_read(afe->fields[led_field], val);
 			if (ret)
 				return ret;
@@ -295,19 +296,20 @@ static int afe4404_write_raw(struct iio_dev *indio_dev,
 			     int val, int val2, long mask)
 {
 	struct afe4404_data *afe = iio_priv(indio_dev);
-	unsigned int led_field = afe4404_channel_leds[chan->address];
-	unsigned int offdac_field = afe4404_channel_offdacs[chan->address];
+	unsigned int led_field, offdac_field;
 
 	switch (chan->type) {
 	case IIO_INTENSITY:
 		switch (mask) {
 		case IIO_CHAN_INFO_OFFSET:
+			offdac_field = afe4404_channel_offdacs[chan->address];
 			return regmap_field_write(afe->fields[offdac_field], val);
 		}
 		break;
 	case IIO_CURRENT:
 		switch (mask) {
 		case IIO_CHAN_INFO_RAW:
+			led_field = afe4404_channel_leds[chan->address];
 			return regmap_field_write(afe->fields[led_field], val);
 		}
 		break;
diff --git a/drivers/iio/light/Kconfig b/drivers/iio/light/Kconfig
index 917f9becf9c7..dd52eff9ba2a 100644
--- a/drivers/iio/light/Kconfig
+++ b/drivers/iio/light/Kconfig
@@ -294,6 +294,8 @@ config RPR0521
 	tristate "ROHM RPR0521 ALS and proximity sensor driver"
 	depends on I2C
 	select REGMAP_I2C
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say Y here if you want to build support for ROHM's RPR0521
 	  ambient light and proximity sensor device.
diff --git a/drivers/input/touchscreen/raydium_i2c_ts.c b/drivers/input/touchscreen/raydium_i2c_ts.c
index 4d2d22a86977..bdb3e2c3ab79 100644
--- a/drivers/input/touchscreen/raydium_i2c_ts.c
+++ b/drivers/input/touchscreen/raydium_i2c_ts.c
@@ -210,12 +210,14 @@ static int raydium_i2c_send(struct i2c_client *client,
 
 		error = raydium_i2c_xfer(client, addr, xfer, ARRAY_SIZE(xfer));
 		if (likely(!error))
-			return 0;
+			goto out;
 
 		msleep(RM_RETRY_DELAY_MS);
 	} while (++tries < RM_MAX_RETRIES);
 
 	dev_err(&client->dev, "%s failed: %d\n", __func__, error);
+out:
+	kfree(tx_buf);
 	return error;
 }
 
diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index 0bc497f4cb9f..a27765a7f6b7 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -816,6 +816,7 @@ int __init dmar_dev_scope_init(void)
 			info = dmar_alloc_pci_notify_info(dev,
 					BUS_NOTIFY_ADD_DEVICE);
 			if (!info) {
+				pci_dev_put(dev);
 				return dmar_dev_scope_status;
 			} else {
 				dmar_pci_bus_add_dev(info);
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index f23329b7f97c..47666c9b4ba1 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4893,8 +4893,10 @@ static inline bool has_external_pci(void)
 	struct pci_dev *pdev = NULL;
 
 	for_each_pci_dev(pdev)
-		if (pdev->external_facing)
+		if (pdev->external_facing) {
+			pci_dev_put(pdev);
 			return true;
+		}
 
 	return false;
 }
diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 7d9ec91e081b..8f2465394253 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -1539,6 +1539,11 @@ void mmc_init_erase(struct mmc_card *card)
 		card->pref_erase = 0;
 }
 
+static bool is_trim_arg(unsigned int arg)
+{
+	return (arg & MMC_TRIM_OR_DISCARD_ARGS) && arg != MMC_DISCARD_ARG;
+}
+
 static unsigned int mmc_mmc_erase_timeout(struct mmc_card *card,
 				          unsigned int arg, unsigned int qty)
 {
@@ -1837,7 +1842,7 @@ int mmc_erase(struct mmc_card *card, unsigned int from, unsigned int nr,
 	    !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_ER_EN))
 		return -EOPNOTSUPP;
 
-	if (mmc_card_mmc(card) && (arg & MMC_TRIM_ARGS) &&
+	if (mmc_card_mmc(card) && is_trim_arg(arg) &&
 	    !(card->ext_csd.sec_feature_support & EXT_CSD_SEC_GB_CL_EN))
 		return -EOPNOTSUPP;
 
@@ -1867,7 +1872,7 @@ int mmc_erase(struct mmc_card *card, unsigned int from, unsigned int nr,
 	 * identified by the card->eg_boundary flag.
 	 */
 	rem = card->erase_size - (from % card->erase_size);
-	if ((arg & MMC_TRIM_ARGS) && (card->eg_boundary) && (nr > rem)) {
+	if ((arg & MMC_TRIM_OR_DISCARD_ARGS) && card->eg_boundary && nr > rem) {
 		err = mmc_do_erase(card, from, from + rem - 1, arg);
 		from += rem;
 		if ((err) || (to <= from))
diff --git a/drivers/mmc/core/mmc_test.c b/drivers/mmc/core/mmc_test.c
index 152e7525ed33..b9b6f000154b 100644
--- a/drivers/mmc/core/mmc_test.c
+++ b/drivers/mmc/core/mmc_test.c
@@ -3195,7 +3195,8 @@ static int __mmc_test_register_dbgfs_file(struct mmc_card *card,
 	struct mmc_test_dbgfs_file *df;
 
 	if (card->debugfs_root)
-		debugfs_create_file(name, mode, card->debugfs_root, card, fops);
+		file = debugfs_create_file(name, mode, card->debugfs_root,
+					   card, fops);
 
 	df = kmalloc(sizeof(*df), GFP_KERNEL);
 	if (!df) {
diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
index 1f1bdd34dd55..9e827bfe19ff 100644
--- a/drivers/mmc/host/sdhci-esdhc-imx.c
+++ b/drivers/mmc/host/sdhci-esdhc-imx.c
@@ -1449,7 +1449,7 @@ static void esdhc_cqe_enable(struct mmc_host *mmc)
 	 * system resume back.
 	 */
 	cqhci_writel(cq_host, 0, CQHCI_CTL);
-	if (cqhci_readl(cq_host, CQHCI_CTL) && CQHCI_HALT)
+	if (cqhci_readl(cq_host, CQHCI_CTL) & CQHCI_HALT)
 		dev_err(mmc_dev(host->mmc),
 			"failed to exit halt state when enable CQE\n");
 
diff --git a/drivers/mmc/host/sdhci-sprd.c b/drivers/mmc/host/sdhci-sprd.c
index 8575f4537e57..110ee0c804c8 100644
--- a/drivers/mmc/host/sdhci-sprd.c
+++ b/drivers/mmc/host/sdhci-sprd.c
@@ -457,7 +457,7 @@ static int sdhci_sprd_voltage_switch(struct mmc_host *mmc, struct mmc_ios *ios)
 	}
 
 	if (IS_ERR(sprd_host->pinctrl))
-		return 0;
+		goto reset;
 
 	switch (ios->signal_voltage) {
 	case MMC_SIGNAL_VOLTAGE_180:
@@ -485,6 +485,8 @@ static int sdhci_sprd_voltage_switch(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	/* Wait for 300 ~ 500 us for pin state stable */
 	usleep_range(300, 500);
+
+reset:
 	sdhci_reset(host, SDHCI_RESET_CMD | SDHCI_RESET_DATA);
 
 	return 0;
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index d42e86cdff12..133f0d376480 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -339,6 +339,7 @@ static void sdhci_init(struct sdhci_host *host, int soft)
 	if (soft) {
 		/* force clock reconfiguration */
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->set_ios(mmc, &mmc->ios);
 	}
 }
@@ -2258,11 +2259,46 @@ void sdhci_set_uhs_signaling(struct sdhci_host *host, unsigned timing)
 }
 EXPORT_SYMBOL_GPL(sdhci_set_uhs_signaling);
 
+static bool sdhci_timing_has_preset(unsigned char timing)
+{
+	switch (timing) {
+	case MMC_TIMING_UHS_SDR12:
+	case MMC_TIMING_UHS_SDR25:
+	case MMC_TIMING_UHS_SDR50:
+	case MMC_TIMING_UHS_SDR104:
+	case MMC_TIMING_UHS_DDR50:
+	case MMC_TIMING_MMC_DDR52:
+		return true;
+	};
+	return false;
+}
+
+static bool sdhci_preset_needed(struct sdhci_host *host, unsigned char timing)
+{
+	return !(host->quirks2 & SDHCI_QUIRK2_PRESET_VALUE_BROKEN) &&
+	       sdhci_timing_has_preset(timing);
+}
+
+static bool sdhci_presetable_values_change(struct sdhci_host *host, struct mmc_ios *ios)
+{
+	/*
+	 * Preset Values are: Driver Strength, Clock Generator and SDCLK/RCLK
+	 * Frequency. Check if preset values need to be enabled, or the Driver
+	 * Strength needs updating. Note, clock changes are handled separately.
+	 */
+	return !host->preset_enabled &&
+	       (sdhci_preset_needed(host, ios->timing) || host->drv_type != ios->drv_type);
+}
+
 void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 {
 	struct sdhci_host *host = mmc_priv(mmc);
+	bool reinit_uhs = host->reinit_uhs;
+	bool turning_on_clk = false;
 	u8 ctrl;
 
+	host->reinit_uhs = false;
+
 	if (ios->power_mode == MMC_POWER_UNDEFINED)
 		return;
 
@@ -2288,6 +2324,8 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		sdhci_enable_preset_value(host, false);
 
 	if (!ios->clock || ios->clock != host->clock) {
+		turning_on_clk = ios->clock && !host->clock;
+
 		host->ops->set_clock(host, ios->clock);
 		host->clock = ios->clock;
 
@@ -2314,6 +2352,17 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 
 	host->ops->set_bus_width(host, ios->bus_width);
 
+	/*
+	 * Special case to avoid multiple clock changes during voltage
+	 * switching.
+	 */
+	if (!reinit_uhs &&
+	    turning_on_clk &&
+	    host->timing == ios->timing &&
+	    host->version >= SDHCI_SPEC_300 &&
+	    !sdhci_presetable_values_change(host, ios))
+		return;
+
 	ctrl = sdhci_readb(host, SDHCI_HOST_CONTROL);
 
 	if (!(host->quirks & SDHCI_QUIRK_NO_HISPD_BIT)) {
@@ -2357,6 +2406,7 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 			}
 
 			sdhci_writew(host, ctrl_2, SDHCI_HOST_CONTROL2);
+			host->drv_type = ios->drv_type;
 		} else {
 			/*
 			 * According to SDHC Spec v3.00, if the Preset Value
@@ -2384,19 +2434,14 @@ void sdhci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
 		host->ops->set_uhs_signaling(host, ios->timing);
 		host->timing = ios->timing;
 
-		if (!(host->quirks2 & SDHCI_QUIRK2_PRESET_VALUE_BROKEN) &&
-				((ios->timing == MMC_TIMING_UHS_SDR12) ||
-				 (ios->timing == MMC_TIMING_UHS_SDR25) ||
-				 (ios->timing == MMC_TIMING_UHS_SDR50) ||
-				 (ios->timing == MMC_TIMING_UHS_SDR104) ||
-				 (ios->timing == MMC_TIMING_UHS_DDR50) ||
-				 (ios->timing == MMC_TIMING_MMC_DDR52))) {
+		if (sdhci_preset_needed(host, ios->timing)) {
 			u16 preset;
 
 			sdhci_enable_preset_value(host, true);
 			preset = sdhci_get_preset_value(host);
 			ios->drv_type = FIELD_GET(SDHCI_PRESET_DRV_MASK,
 						  preset);
+			host->drv_type = ios->drv_type;
 		}
 
 		/* Re-enable SD Clock */
@@ -3707,6 +3752,7 @@ int sdhci_resume_host(struct sdhci_host *host)
 		sdhci_init(host, 0);
 		host->pwr = 0;
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->set_ios(mmc, &mmc->ios);
 	} else {
 		sdhci_init(host, (host->mmc->pm_flags & MMC_PM_KEEP_POWER));
@@ -3769,6 +3815,7 @@ int sdhci_runtime_resume_host(struct sdhci_host *host, int soft_reset)
 		/* Force clock and power re-program */
 		host->pwr = 0;
 		host->clock = 0;
+		host->reinit_uhs = true;
 		mmc->ops->start_signal_voltage_switch(mmc, &mmc->ios);
 		mmc->ops->set_ios(mmc, &mmc->ios);
 
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 8b1650f37fbb..4db57c3a8cd4 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -520,6 +520,8 @@ struct sdhci_host {
 
 	unsigned int clock;	/* Current clock (MHz) */
 	u8 pwr;			/* Current voltage */
+	u8 drv_type;		/* Current UHS-I driver type */
+	bool reinit_uhs;	/* Force UHS-related re-initialization */
 
 	bool runtime_suspended;	/* Host is runtime suspended */
 	bool bus_on;		/* Bus power prevents runtime suspend */
diff --git a/drivers/net/can/cc770/cc770_isa.c b/drivers/net/can/cc770/cc770_isa.c
index 194c86e0f340..8f6dccd5a587 100644
--- a/drivers/net/can/cc770/cc770_isa.c
+++ b/drivers/net/can/cc770/cc770_isa.c
@@ -264,22 +264,24 @@ static int cc770_isa_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev,
 			"couldn't register device (err=%d)\n", err);
-		goto exit_unmap;
+		goto exit_free;
 	}
 
 	dev_info(&pdev->dev, "device registered (reg_base=0x%p, irq=%d)\n",
 		 priv->reg_base, dev->irq);
 	return 0;
 
- exit_unmap:
+exit_free:
+	free_cc770dev(dev);
+exit_unmap:
 	if (mem[idx])
 		iounmap(base);
- exit_release:
+exit_release:
 	if (mem[idx])
 		release_mem_region(mem[idx], iosize);
 	else
 		release_region(port[idx], iosize);
- exit:
+exit:
 	return err;
 }
 
diff --git a/drivers/net/can/sja1000/sja1000_isa.c b/drivers/net/can/sja1000/sja1000_isa.c
index d513fac50718..db3e767d5320 100644
--- a/drivers/net/can/sja1000/sja1000_isa.c
+++ b/drivers/net/can/sja1000/sja1000_isa.c
@@ -202,22 +202,24 @@ static int sja1000_isa_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev, "registering %s failed (err=%d)\n",
 			DRV_NAME, err);
-		goto exit_unmap;
+		goto exit_free;
 	}
 
 	dev_info(&pdev->dev, "%s device registered (reg_base=0x%p, irq=%d)\n",
 		 DRV_NAME, priv->reg_base, dev->irq);
 	return 0;
 
- exit_unmap:
+exit_free:
+	free_sja1000dev(dev);
+exit_unmap:
 	if (mem[idx])
 		iounmap(base);
- exit_release:
+exit_release:
 	if (mem[idx])
 		release_mem_region(mem[idx], iosize);
 	else
 		release_region(port[idx], iosize);
- exit:
+exit:
 	return err;
 }
 
diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-core.c
index 2044d440d7de..c79bb8cf962c 100644
--- a/drivers/net/dsa/lan9303-core.c
+++ b/drivers/net/dsa/lan9303-core.c
@@ -958,7 +958,7 @@ static const struct lan9303_mib_desc lan9303_mib[] = {
 	{ .offset = LAN9303_MAC_TX_BRDCST_CNT_0, .name = "TxBroad", },
 	{ .offset = LAN9303_MAC_TX_PAUSE_CNT_0, .name = "TxPause", },
 	{ .offset = LAN9303_MAC_TX_MULCST_CNT_0, .name = "TxMulti", },
-	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "TxUnderRun", },
+	{ .offset = LAN9303_MAC_RX_UNDSZE_CNT_0, .name = "RxShort", },
 	{ .offset = LAN9303_MAC_TX_64_CNT_0, .name = "Tx64Byte", },
 	{ .offset = LAN9303_MAC_TX_127_CNT_0, .name = "Tx128Byte", },
 	{ .offset = LAN9303_MAC_TX_255_CNT_0, .name = "Tx256Byte", },
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
index de2a9348bc3f..1d512e6a89f5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ethtool.c
@@ -13,6 +13,7 @@
 #include "aq_ptp.h"
 #include "aq_filters.h"
 #include "aq_macsec.h"
+#include "aq_main.h"
 
 #include <linux/ptp_clock_kernel.h>
 
@@ -841,7 +842,7 @@ static int aq_set_ringparam(struct net_device *ndev,
 
 	if (netif_running(ndev)) {
 		ndev_running = true;
-		dev_close(ndev);
+		aq_ndev_close(ndev);
 	}
 
 	cfg->rxds = max(ring->rx_pending, hw_caps->rxds_min);
@@ -857,7 +858,7 @@ static int aq_set_ringparam(struct net_device *ndev,
 		goto err_exit;
 
 	if (ndev_running)
-		err = dev_open(ndev, NULL);
+		err = aq_ndev_open(ndev);
 
 err_exit:
 	return err;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index ff245f75fa3d..1401fc4632b5 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -53,7 +53,7 @@ struct net_device *aq_ndev_alloc(void)
 	return ndev;
 }
 
-static int aq_ndev_open(struct net_device *ndev)
+int aq_ndev_open(struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	int err = 0;
@@ -83,7 +83,7 @@ static int aq_ndev_open(struct net_device *ndev)
 	return err;
 }
 
-static int aq_ndev_close(struct net_device *ndev)
+int aq_ndev_close(struct net_device *ndev)
 {
 	struct aq_nic_s *aq_nic = netdev_priv(ndev);
 	int err = 0;
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.h b/drivers/net/ethernet/aquantia/atlantic/aq_main.h
index a5a624b9ce73..2a562ab7a5af 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.h
@@ -14,5 +14,7 @@
 
 void aq_ndev_schedule_work(struct work_struct *work);
 struct net_device *aq_ndev_alloc(void);
+int aq_ndev_open(struct net_device *ndev);
+int aq_ndev_close(struct net_device *ndev);
 
 #endif /* AQ_MAIN_H */
diff --git a/drivers/net/ethernet/intel/e100.c b/drivers/net/ethernet/intel/e100.c
index 9295a9a1efc7..001850d578e8 100644
--- a/drivers/net/ethernet/intel/e100.c
+++ b/drivers/net/ethernet/intel/e100.c
@@ -1739,14 +1739,11 @@ static int e100_xmit_prepare(struct nic *nic, struct cb *cb,
 	dma_addr_t dma_addr;
 	cb->command = nic->tx_command;
 
-	dma_addr = pci_map_single(nic->pdev,
-				  skb->data, skb->len, PCI_DMA_TODEVICE);
+	dma_addr = dma_map_single(&nic->pdev->dev, skb->data, skb->len,
+				  DMA_TO_DEVICE);
 	/* If we can't map the skb, have the upper layer try later */
-	if (pci_dma_mapping_error(nic->pdev, dma_addr)) {
-		dev_kfree_skb_any(skb);
-		skb = NULL;
+	if (dma_mapping_error(&nic->pdev->dev, dma_addr))
 		return -ENOMEM;
-	}
 
 	/*
 	 * Use the last 4 bytes of the SKB payload packet as the CRC, used for
@@ -1828,10 +1825,10 @@ static int e100_tx_clean(struct nic *nic)
 			dev->stats.tx_packets++;
 			dev->stats.tx_bytes += cb->skb->len;
 
-			pci_unmap_single(nic->pdev,
-				le32_to_cpu(cb->u.tcb.tbd.buf_addr),
-				le16_to_cpu(cb->u.tcb.tbd.size),
-				PCI_DMA_TODEVICE);
+			dma_unmap_single(&nic->pdev->dev,
+					 le32_to_cpu(cb->u.tcb.tbd.buf_addr),
+					 le16_to_cpu(cb->u.tcb.tbd.size),
+					 DMA_TO_DEVICE);
 			dev_kfree_skb_any(cb->skb);
 			cb->skb = NULL;
 			tx_cleaned = 1;
@@ -1855,10 +1852,10 @@ static void e100_clean_cbs(struct nic *nic)
 		while (nic->cbs_avail != nic->params.cbs.count) {
 			struct cb *cb = nic->cb_to_clean;
 			if (cb->skb) {
-				pci_unmap_single(nic->pdev,
-					le32_to_cpu(cb->u.tcb.tbd.buf_addr),
-					le16_to_cpu(cb->u.tcb.tbd.size),
-					PCI_DMA_TODEVICE);
+				dma_unmap_single(&nic->pdev->dev,
+						 le32_to_cpu(cb->u.tcb.tbd.buf_addr),
+						 le16_to_cpu(cb->u.tcb.tbd.size),
+						 DMA_TO_DEVICE);
 				dev_kfree_skb(cb->skb);
 			}
 			nic->cb_to_clean = nic->cb_to_clean->next;
@@ -1925,10 +1922,10 @@ static int e100_rx_alloc_skb(struct nic *nic, struct rx *rx)
 
 	/* Init, and map the RFD. */
 	skb_copy_to_linear_data(rx->skb, &nic->blank_rfd, sizeof(struct rfd));
-	rx->dma_addr = pci_map_single(nic->pdev, rx->skb->data,
-		RFD_BUF_LEN, PCI_DMA_BIDIRECTIONAL);
+	rx->dma_addr = dma_map_single(&nic->pdev->dev, rx->skb->data,
+				      RFD_BUF_LEN, DMA_BIDIRECTIONAL);
 
-	if (pci_dma_mapping_error(nic->pdev, rx->dma_addr)) {
+	if (dma_mapping_error(&nic->pdev->dev, rx->dma_addr)) {
 		dev_kfree_skb_any(rx->skb);
 		rx->skb = NULL;
 		rx->dma_addr = 0;
@@ -1941,8 +1938,10 @@ static int e100_rx_alloc_skb(struct nic *nic, struct rx *rx)
 	if (rx->prev->skb) {
 		struct rfd *prev_rfd = (struct rfd *)rx->prev->skb->data;
 		put_unaligned_le32(rx->dma_addr, &prev_rfd->link);
-		pci_dma_sync_single_for_device(nic->pdev, rx->prev->dma_addr,
-			sizeof(struct rfd), PCI_DMA_BIDIRECTIONAL);
+		dma_sync_single_for_device(&nic->pdev->dev,
+					   rx->prev->dma_addr,
+					   sizeof(struct rfd),
+					   DMA_BIDIRECTIONAL);
 	}
 
 	return 0;
@@ -1961,8 +1960,8 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 		return -EAGAIN;
 
 	/* Need to sync before taking a peek at cb_complete bit */
-	pci_dma_sync_single_for_cpu(nic->pdev, rx->dma_addr,
-		sizeof(struct rfd), PCI_DMA_BIDIRECTIONAL);
+	dma_sync_single_for_cpu(&nic->pdev->dev, rx->dma_addr,
+				sizeof(struct rfd), DMA_BIDIRECTIONAL);
 	rfd_status = le16_to_cpu(rfd->status);
 
 	netif_printk(nic, rx_status, KERN_DEBUG, nic->netdev,
@@ -1981,9 +1980,9 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 
 			if (ioread8(&nic->csr->scb.status) & rus_no_res)
 				nic->ru_running = RU_SUSPENDED;
-		pci_dma_sync_single_for_device(nic->pdev, rx->dma_addr,
-					       sizeof(struct rfd),
-					       PCI_DMA_FROMDEVICE);
+		dma_sync_single_for_device(&nic->pdev->dev, rx->dma_addr,
+					   sizeof(struct rfd),
+					   DMA_FROM_DEVICE);
 		return -ENODATA;
 	}
 
@@ -1995,8 +1994,8 @@ static int e100_rx_indicate(struct nic *nic, struct rx *rx,
 		actual_size = RFD_BUF_LEN - sizeof(struct rfd);
 
 	/* Get data */
-	pci_unmap_single(nic->pdev, rx->dma_addr,
-		RFD_BUF_LEN, PCI_DMA_BIDIRECTIONAL);
+	dma_unmap_single(&nic->pdev->dev, rx->dma_addr, RFD_BUF_LEN,
+			 DMA_BIDIRECTIONAL);
 
 	/* If this buffer has the el bit, but we think the receiver
 	 * is still running, check to see if it really stopped while
@@ -2097,22 +2096,25 @@ static void e100_rx_clean(struct nic *nic, unsigned int *work_done,
 			(struct rfd *)new_before_last_rx->skb->data;
 		new_before_last_rfd->size = 0;
 		new_before_last_rfd->command |= cpu_to_le16(cb_el);
-		pci_dma_sync_single_for_device(nic->pdev,
-			new_before_last_rx->dma_addr, sizeof(struct rfd),
-			PCI_DMA_BIDIRECTIONAL);
+		dma_sync_single_for_device(&nic->pdev->dev,
+					   new_before_last_rx->dma_addr,
+					   sizeof(struct rfd),
+					   DMA_BIDIRECTIONAL);
 
 		/* Now that we have a new stopping point, we can clear the old
 		 * stopping point.  We must sync twice to get the proper
 		 * ordering on the hardware side of things. */
 		old_before_last_rfd->command &= ~cpu_to_le16(cb_el);
-		pci_dma_sync_single_for_device(nic->pdev,
-			old_before_last_rx->dma_addr, sizeof(struct rfd),
-			PCI_DMA_BIDIRECTIONAL);
+		dma_sync_single_for_device(&nic->pdev->dev,
+					   old_before_last_rx->dma_addr,
+					   sizeof(struct rfd),
+					   DMA_BIDIRECTIONAL);
 		old_before_last_rfd->size = cpu_to_le16(VLAN_ETH_FRAME_LEN
 							+ ETH_FCS_LEN);
-		pci_dma_sync_single_for_device(nic->pdev,
-			old_before_last_rx->dma_addr, sizeof(struct rfd),
-			PCI_DMA_BIDIRECTIONAL);
+		dma_sync_single_for_device(&nic->pdev->dev,
+					   old_before_last_rx->dma_addr,
+					   sizeof(struct rfd),
+					   DMA_BIDIRECTIONAL);
 	}
 
 	if (restart_required) {
@@ -2134,8 +2136,9 @@ static void e100_rx_clean_list(struct nic *nic)
 	if (nic->rxs) {
 		for (rx = nic->rxs, i = 0; i < count; rx++, i++) {
 			if (rx->skb) {
-				pci_unmap_single(nic->pdev, rx->dma_addr,
-					RFD_BUF_LEN, PCI_DMA_BIDIRECTIONAL);
+				dma_unmap_single(&nic->pdev->dev,
+						 rx->dma_addr, RFD_BUF_LEN,
+						 DMA_BIDIRECTIONAL);
 				dev_kfree_skb(rx->skb);
 			}
 		}
@@ -2177,8 +2180,8 @@ static int e100_rx_alloc_list(struct nic *nic)
 	before_last = (struct rfd *)rx->skb->data;
 	before_last->command |= cpu_to_le16(cb_el);
 	before_last->size = 0;
-	pci_dma_sync_single_for_device(nic->pdev, rx->dma_addr,
-		sizeof(struct rfd), PCI_DMA_BIDIRECTIONAL);
+	dma_sync_single_for_device(&nic->pdev->dev, rx->dma_addr,
+				   sizeof(struct rfd), DMA_BIDIRECTIONAL);
 
 	nic->rx_to_use = nic->rx_to_clean = nic->rxs;
 	nic->ru_running = RU_SUSPENDED;
@@ -2377,8 +2380,8 @@ static int e100_loopback_test(struct nic *nic, enum loopback loopback_mode)
 
 	msleep(10);
 
-	pci_dma_sync_single_for_cpu(nic->pdev, nic->rx_to_clean->dma_addr,
-			RFD_BUF_LEN, PCI_DMA_BIDIRECTIONAL);
+	dma_sync_single_for_cpu(&nic->pdev->dev, nic->rx_to_clean->dma_addr,
+				RFD_BUF_LEN, DMA_BIDIRECTIONAL);
 
 	if (memcmp(nic->rx_to_clean->skb->data + sizeof(struct rfd),
 	   skb->data, ETH_DATA_LEN))
@@ -2759,16 +2762,16 @@ static int e100_do_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
 
 static int e100_alloc(struct nic *nic)
 {
-	nic->mem = pci_alloc_consistent(nic->pdev, sizeof(struct mem),
-		&nic->dma_addr);
+	nic->mem = dma_alloc_coherent(&nic->pdev->dev, sizeof(struct mem),
+				      &nic->dma_addr, GFP_KERNEL);
 	return nic->mem ? 0 : -ENOMEM;
 }
 
 static void e100_free(struct nic *nic)
 {
 	if (nic->mem) {
-		pci_free_consistent(nic->pdev, sizeof(struct mem),
-			nic->mem, nic->dma_addr);
+		dma_free_coherent(&nic->pdev->dev, sizeof(struct mem),
+				  nic->mem, nic->dma_addr);
 		nic->mem = NULL;
 	}
 }
@@ -2861,7 +2864,7 @@ static int e100_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out_disable_pdev;
 	}
 
-	if ((err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32)))) {
+	if ((err = dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)))) {
 		netif_err(nic, probe, nic->netdev, "No usable DMA configuration, aborting\n");
 		goto err_out_free_res;
 	}
diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index 99b8252eb969..a388a0fcbeed 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -32,6 +32,8 @@ struct workqueue_struct *fm10k_workqueue;
  **/
 static int __init fm10k_init_module(void)
 {
+	int ret;
+
 	pr_info("%s\n", fm10k_driver_string);
 	pr_info("%s\n", fm10k_copyright);
 
@@ -43,7 +45,13 @@ static int __init fm10k_init_module(void)
 
 	fm10k_dbg_init();
 
-	return fm10k_register_pci_driver();
+	ret = fm10k_register_pci_driver();
+	if (ret) {
+		fm10k_dbg_exit();
+		destroy_workqueue(fm10k_workqueue);
+	}
+
+	return ret;
 }
 module_init(fm10k_init_module);
 
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index ea6a984c6d12..d7ddf9239e51 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -15972,6 +15972,8 @@ static struct pci_driver i40e_driver = {
  **/
 static int __init i40e_init_module(void)
 {
+	int err;
+
 	pr_info("%s: %s\n", i40e_driver_name, i40e_driver_string);
 	pr_info("%s: %s\n", i40e_driver_name, i40e_copyright);
 
@@ -15989,7 +15991,14 @@ static int __init i40e_init_module(void)
 	}
 
 	i40e_dbg_init();
-	return pci_register_driver(&i40e_driver);
+	err = pci_register_driver(&i40e_driver);
+	if (err) {
+		destroy_workqueue(i40e_wq);
+		i40e_dbg_exit();
+		return err;
+	}
+
+	return 0;
 }
 module_init(i40e_init_module);
 
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index a9cea7ccdd86..ae96b552a3bb 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1318,7 +1318,6 @@ static void iavf_fill_rss_lut(struct iavf_adapter *adapter)
 static int iavf_init_rss(struct iavf_adapter *adapter)
 {
 	struct iavf_hw *hw = &adapter->hw;
-	int ret;
 
 	if (!RSS_PF(adapter)) {
 		/* Enable PCTYPES for RSS, TCP/UDP with IPv4/IPv6 */
@@ -1334,9 +1333,8 @@ static int iavf_init_rss(struct iavf_adapter *adapter)
 
 	iavf_fill_rss_lut(adapter);
 	netdev_rss_key_fill((void *)adapter->rss_key, adapter->rss_key_size);
-	ret = iavf_config_rss(adapter);
 
-	return ret;
+	return iavf_config_rss(adapter);
 }
 
 /**
@@ -4040,7 +4038,11 @@ static int __init iavf_init_module(void)
 		pr_err("%s: Failed to create workqueue\n", iavf_driver_name);
 		return -ENOMEM;
 	}
+
 	ret = pci_register_driver(&iavf_driver);
+	if (ret)
+		destroy_workqueue(iavf_wq);
+
 	return ret;
 }
 
diff --git a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
index 2d6ac61d7a3e..4510a84514fa 100644
--- a/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
+++ b/drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c
@@ -4878,6 +4878,8 @@ static struct pci_driver ixgbevf_driver = {
  **/
 static int __init ixgbevf_init_module(void)
 {
+	int err;
+
 	pr_info("%s\n", ixgbevf_driver_string);
 	pr_info("%s\n", ixgbevf_copyright);
 	ixgbevf_wq = create_singlethread_workqueue(ixgbevf_driver_name);
@@ -4886,7 +4888,13 @@ static int __init ixgbevf_init_module(void)
 		return -ENOMEM;
 	}
 
-	return pci_register_driver(&ixgbevf_driver);
+	err = pci_register_driver(&ixgbevf_driver);
+	if (err) {
+		destroy_workqueue(ixgbevf_wq);
+		return err;
+	}
+
+	return 0;
 }
 
 module_init(ixgbevf_init_module);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index c838d8698eab..39c17e903915 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1422,8 +1422,8 @@ static ssize_t outlen_write(struct file *filp, const char __user *buf,
 		return -EFAULT;
 
 	err = sscanf(outlen_str, "%d", &outlen);
-	if (err < 0)
-		return err;
+	if (err != 1)
+		return -EINVAL;
 
 	ptr = kzalloc(outlen, GFP_KERNEL);
 	if (!ptr)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 6c865cb7f445..132ea9997676 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -308,6 +308,8 @@ mlx5_eswitch_add_termtbl_rule(struct mlx5_eswitch *esw,
 	for (curr_dest = 0; curr_dest < num_vport_dests; curr_dest++) {
 		struct mlx5_termtbl_handle *tt = attr->dests[curr_dest].termtbl;
 
+		attr->dests[curr_dest].termtbl = NULL;
+
 		/* search for the destination associated with the
 		 * current term table
 		 */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
index b599b6beb5b9..6a4b997c258a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_table.c
@@ -9,7 +9,7 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 	struct mlx5dr_matcher *last_matcher = NULL;
 	struct mlx5dr_htbl_connect_info info;
 	struct mlx5dr_ste_htbl *last_htbl;
-	int ret;
+	int ret = -EOPNOTSUPP;
 
 	if (action && action->action_type != DR_ACTION_TYP_FT)
 		return -EOPNOTSUPP;
@@ -68,6 +68,9 @@ int mlx5dr_table_set_miss_action(struct mlx5dr_table *tbl,
 		}
 	}
 
+	if (ret)
+		goto out;
+
 	/* Release old action */
 	if (tbl->miss_action)
 		refcount_dec(&tbl->miss_action->refcount);
diff --git a/drivers/net/ethernet/ni/nixge.c b/drivers/net/ethernet/ni/nixge.c
index 9c48fd85c418..07fbd329fe93 100644
--- a/drivers/net/ethernet/ni/nixge.c
+++ b/drivers/net/ethernet/ni/nixge.c
@@ -249,25 +249,26 @@ static void nixge_hw_dma_bd_release(struct net_device *ndev)
 	struct sk_buff *skb;
 	int i;
 
-	for (i = 0; i < RX_BD_NUM; i++) {
-		phys_addr = nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
-						     phys);
-
-		dma_unmap_single(ndev->dev.parent, phys_addr,
-				 NIXGE_MAX_JUMBO_FRAME_SIZE,
-				 DMA_FROM_DEVICE);
-
-		skb = (struct sk_buff *)(uintptr_t)
-			nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
-						 sw_id_offset);
-		dev_kfree_skb(skb);
-	}
+	if (priv->rx_bd_v) {
+		for (i = 0; i < RX_BD_NUM; i++) {
+			phys_addr = nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
+							     phys);
+
+			dma_unmap_single(ndev->dev.parent, phys_addr,
+					 NIXGE_MAX_JUMBO_FRAME_SIZE,
+					 DMA_FROM_DEVICE);
+
+			skb = (struct sk_buff *)(uintptr_t)
+				nixge_hw_dma_bd_get_addr(&priv->rx_bd_v[i],
+							 sw_id_offset);
+			dev_kfree_skb(skb);
+		}
 
-	if (priv->rx_bd_v)
 		dma_free_coherent(ndev->dev.parent,
 				  sizeof(*priv->rx_bd_v) * RX_BD_NUM,
 				  priv->rx_bd_v,
 				  priv->rx_bd_p);
+	}
 
 	if (priv->tx_skb)
 		devm_kfree(ndev->dev.parent, priv->tx_skb);
diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
index bd0607680329..2fd5c6fdb500 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
@@ -2991,7 +2991,7 @@ static void qlcnic_83xx_recover_driver_lock(struct qlcnic_adapter *adapter)
 		QLCWRX(adapter->ahw, QLC_83XX_RECOVER_DRV_LOCK, val);
 		dev_info(&adapter->pdev->dev,
 			 "%s: lock recovery initiated\n", __func__);
-		msleep(QLC_83XX_DRV_LOCK_RECOVERY_DELAY);
+		mdelay(QLC_83XX_DRV_LOCK_RECOVERY_DELAY);
 		val = QLCRDX(adapter->ahw, QLC_83XX_RECOVER_DRV_LOCK);
 		id = ((val >> 2) & 0xF);
 		if (id == adapter->portnum) {
@@ -3027,7 +3027,7 @@ int qlcnic_83xx_lock_driver(struct qlcnic_adapter *adapter)
 		if (status)
 			break;
 
-		msleep(QLC_83XX_DRV_LOCK_WAIT_DELAY);
+		mdelay(QLC_83XX_DRV_LOCK_WAIT_DELAY);
 		i++;
 
 		if (i == 1)
diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index f96eed67e1a2..9e7b85e178fd 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2364,6 +2364,7 @@ static int __maybe_unused ravb_resume(struct device *dev)
 		ret = ravb_open(ndev);
 		if (ret < 0)
 			return ret;
+		ravb_set_rx_mode(ndev);
 		netif_device_attach(ndev);
 	}
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
index 2e71e510e127..5b052fdd2696 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c
@@ -720,6 +720,8 @@ static void dwmac4_flow_ctrl(struct mac_device_info *hw, unsigned int duplex,
 	if (fc & FLOW_RX) {
 		pr_debug("\tReceive Flow-Control ON\n");
 		flow |= GMAC_RX_FLOW_CTRL_RFE;
+	} else {
+		pr_debug("\tReceive Flow-Control OFF\n");
 	}
 	writel(flow, ioaddr + GMAC_RX_FLOW_CTRL);
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 41e71a26b1ad..14ea0168b548 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1043,8 +1043,16 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 		ctrl |= priv->hw->link.duplex;
 
 	/* Flow Control operation */
-	if (tx_pause && rx_pause)
-		stmmac_mac_flow_ctrl(priv, duplex);
+	if (rx_pause && tx_pause)
+		priv->flow_ctrl = FLOW_AUTO;
+	else if (rx_pause && !tx_pause)
+		priv->flow_ctrl = FLOW_RX;
+	else if (!rx_pause && tx_pause)
+		priv->flow_ctrl = FLOW_TX;
+	else
+		priv->flow_ctrl = FLOW_OFF;
+
+	stmmac_mac_flow_ctrl(priv, duplex);
 
 	writel(ctrl, priv->ioaddr + MAC_CTRL_REG);
 
diff --git a/drivers/net/ntb_netdev.c b/drivers/net/ntb_netdev.c
index a5bab614ff84..1b7d588ff3c5 100644
--- a/drivers/net/ntb_netdev.c
+++ b/drivers/net/ntb_netdev.c
@@ -484,7 +484,14 @@ static int __init ntb_netdev_init_module(void)
 	rc = ntb_transport_register_client_dev(KBUILD_MODNAME);
 	if (rc)
 		return rc;
-	return ntb_transport_register_client(&ntb_netdev_client);
+
+	rc = ntb_transport_register_client(&ntb_netdev_client);
+	if (rc) {
+		ntb_transport_unregister_client_dev(KBUILD_MODNAME);
+		return rc;
+	}
+
+	return 0;
 }
 module_init(ntb_netdev_init_module);
 
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index d2f6d8107595..3ef5aa6b72a7 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1423,6 +1423,7 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 
 error_module_put:
 	module_put(d->driver->owner);
+	d->driver = NULL;
 error_put_device:
 	put_device(d);
 	if (ndev_owner != bus->owner)
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index cb42fdbfeb32..67ce7b779af6 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -698,7 +698,6 @@ static void __tun_detach(struct tun_file *tfile, bool clean)
 		if (tun)
 			xdp_rxq_info_unreg(&tfile->xdp_rxq);
 		ptr_ring_cleanup(&tfile->tx_ring, tun_ptr_free);
-		sock_put(&tfile->sk);
 	}
 }
 
@@ -714,6 +713,9 @@ static void tun_detach(struct tun_file *tfile, bool clean)
 	if (dev)
 		netdev_state_change(dev);
 	rtnl_unlock();
+
+	if (clean)
+		sock_put(&tfile->sk);
 }
 
 static void tun_detach_all(struct net_device *dev)
diff --git a/drivers/of/property.c b/drivers/of/property.c
index 1d7d24e7094b..8f998351bf4f 100644
--- a/drivers/of/property.c
+++ b/drivers/of/property.c
@@ -956,8 +956,10 @@ of_fwnode_get_reference_args(const struct fwnode_handle *fwnode,
 						       nargs, index, &of_args);
 	if (ret < 0)
 		return ret;
-	if (!args)
+	if (!args) {
+		of_node_put(of_args.np);
 		return 0;
+	}
 
 	args->nargs = of_args.args_count;
 	args->fwnode = of_fwnode_handle(of_args.np);
diff --git a/drivers/pinctrl/intel/pinctrl-intel.c b/drivers/pinctrl/intel/pinctrl-intel.c
index 4de832ac47d3..db9087c129c0 100644
--- a/drivers/pinctrl/intel/pinctrl-intel.c
+++ b/drivers/pinctrl/intel/pinctrl-intel.c
@@ -426,9 +426,14 @@ static void __intel_gpio_set_direction(void __iomem *padcfg0, bool input)
 	writel(value, padcfg0);
 }
 
+static int __intel_gpio_get_gpio_mode(u32 value)
+{
+	return (value & PADCFG0_PMODE_MASK) >> PADCFG0_PMODE_SHIFT;
+}
+
 static int intel_gpio_get_gpio_mode(void __iomem *padcfg0)
 {
-	return (readl(padcfg0) & PADCFG0_PMODE_MASK) >> PADCFG0_PMODE_SHIFT;
+	return __intel_gpio_get_gpio_mode(readl(padcfg0));
 }
 
 static void intel_gpio_set_gpio_mode(void __iomem *padcfg0)
@@ -1604,6 +1609,7 @@ EXPORT_SYMBOL_GPL(intel_pinctrl_get_soc_data);
 static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int pin)
 {
 	const struct pin_desc *pd = pin_desc_get(pctrl->pctldev, pin);
+	u32 value;
 
 	if (!pd || !intel_pad_usable(pctrl, pin))
 		return false;
@@ -1618,6 +1624,25 @@ static bool intel_pinctrl_should_save(struct intel_pinctrl *pctrl, unsigned int
 	    gpiochip_line_is_irq(&pctrl->chip, intel_pin_to_gpio(pctrl, pin)))
 		return true;
 
+	/*
+	 * The firmware on some systems may configure GPIO pins to be
+	 * an interrupt source in so called "direct IRQ" mode. In such
+	 * cases the GPIO controller driver has no idea if those pins
+	 * are being used or not. At the same time, there is a known bug
+	 * in the firmwares that don't restore the pin settings correctly
+	 * after suspend, i.e. by an unknown reason the Rx value becomes
+	 * inverted.
+	 *
+	 * Hence, let's save and restore the pins that are configured
+	 * as GPIOs in the input mode with GPIROUTIOXAPIC bit set.
+	 *
+	 * See https://bugzilla.kernel.org/show_bug.cgi?id=214749.
+	 */
+	value = readl(intel_get_padcfg(pctrl, pin, PADCFG0));
+	if ((value & PADCFG0_GPIROUTIOXAPIC) && (value & PADCFG0_GPIOTXDIS) &&
+	    (__intel_gpio_get_gpio_mode(value) == PADCFG0_PMODE_GPIO))
+		return true;
+
 	return false;
 }
 
diff --git a/drivers/pinctrl/pinctrl-single.c b/drivers/pinctrl/pinctrl-single.c
index 17aa0d542d92..d139cd9e6d13 100644
--- a/drivers/pinctrl/pinctrl-single.c
+++ b/drivers/pinctrl/pinctrl-single.c
@@ -726,7 +726,7 @@ static int pcs_allocate_pin_table(struct pcs_device *pcs)
 
 	mux_bytes = pcs->width / BITS_PER_BYTE;
 
-	if (pcs->bits_per_mux) {
+	if (pcs->bits_per_mux && pcs->fmask) {
 		pcs->bits_per_pin = fls(pcs->fmask);
 		nr_pins = (pcs->size * BITS_PER_BYTE) / pcs->bits_per_pin;
 		num_pins_in_register = pcs->width / pcs->bits_per_pin;
diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 0e3bc0b0a526..74b3b6ca15ef 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -434,8 +434,7 @@ static unsigned int mx51_ecspi_clkdiv(struct spi_imx_data *spi_imx,
 	unsigned int pre, post;
 	unsigned int fin = spi_imx->spi_clk;
 
-	if (unlikely(fspi > fin))
-		return 0;
+	fspi = min(fspi, fin);
 
 	post = fls(fin) - fls(fspi);
 	if (fin > fspi << post)
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index e85282825973..f5063499f9cf 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -235,7 +235,7 @@ struct gsm_mux {
 	int old_c_iflag;		/* termios c_iflag value before attach */
 	bool constipated;		/* Asked by remote to shut up */
 
-	struct mutex tx_mutex;
+	spinlock_t tx_lock;
 	unsigned int tx_bytes;		/* TX data outstanding */
 #define TX_THRESH_HI		8192
 #define TX_THRESH_LO		2048
@@ -820,14 +820,15 @@ static void __gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
  *
  *	Add data to the transmit queue and try and get stuff moving
  *	out of the mux tty if not already doing so. Take the
- *	the gsm tx mutex and dlci lock.
+ *	the gsm tx lock and dlci lock.
  */
 
 static void gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
 {
-	mutex_lock(&dlci->gsm->tx_mutex);
+	unsigned long flags;
+	spin_lock_irqsave(&dlci->gsm->tx_lock, flags);
 	__gsm_data_queue(dlci, msg);
-	mutex_unlock(&dlci->gsm->tx_mutex);
+	spin_unlock_irqrestore(&dlci->gsm->tx_lock, flags);
 }
 
 /**
@@ -839,7 +840,7 @@ static void gsm_data_queue(struct gsm_dlci *dlci, struct gsm_msg *msg)
  *	is data. Keep to the MRU of the mux. This path handles the usual tty
  *	interface which is a byte stream with optional modem data.
  *
- *	Caller must hold the tx_mutex of the mux.
+ *	Caller must hold the tx_lock of the mux.
  */
 
 static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
@@ -902,7 +903,7 @@ static int gsm_dlci_data_output(struct gsm_mux *gsm, struct gsm_dlci *dlci)
  *	is data. Keep to the MRU of the mux. This path handles framed data
  *	queued as skbuffs to the DLCI.
  *
- *	Caller must hold the tx_mutex of the mux.
+ *	Caller must hold the tx_lock of the mux.
  */
 
 static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
@@ -918,7 +919,7 @@ static int gsm_dlci_data_output_framed(struct gsm_mux *gsm,
 	if (dlci->adaption == 4)
 		overhead = 1;
 
-	/* dlci->skb is locked by tx_mutex */
+	/* dlci->skb is locked by tx_lock */
 	if (dlci->skb == NULL) {
 		dlci->skb = skb_dequeue_tail(&dlci->skb_list);
 		if (dlci->skb == NULL)
@@ -1018,12 +1019,13 @@ static void gsm_dlci_data_sweep(struct gsm_mux *gsm)
 
 static void gsm_dlci_data_kick(struct gsm_dlci *dlci)
 {
+	unsigned long flags;
 	int sweep;
 
 	if (dlci->constipated)
 		return;
 
-	mutex_lock(&dlci->gsm->tx_mutex);
+	spin_lock_irqsave(&dlci->gsm->tx_lock, flags);
 	/* If we have nothing running then we need to fire up */
 	sweep = (dlci->gsm->tx_bytes < TX_THRESH_LO);
 	if (dlci->gsm->tx_bytes == 0) {
@@ -1034,7 +1036,7 @@ static void gsm_dlci_data_kick(struct gsm_dlci *dlci)
 	}
 	if (sweep)
 		gsm_dlci_data_sweep(dlci->gsm);
-	mutex_unlock(&dlci->gsm->tx_mutex);
+	spin_unlock_irqrestore(&dlci->gsm->tx_lock, flags);
 }
 
 /*
@@ -1256,6 +1258,7 @@ static void gsm_control_message(struct gsm_mux *gsm, unsigned int command,
 						const u8 *data, int clen)
 {
 	u8 buf[1];
+	unsigned long flags;
 
 	switch (command) {
 	case CMD_CLD: {
@@ -1277,9 +1280,9 @@ static void gsm_control_message(struct gsm_mux *gsm, unsigned int command,
 		gsm->constipated = false;
 		gsm_control_reply(gsm, CMD_FCON, NULL, 0);
 		/* Kick the link in case it is idling */
-		mutex_lock(&gsm->tx_mutex);
+		spin_lock_irqsave(&gsm->tx_lock, flags);
 		gsm_data_kick(gsm, NULL);
-		mutex_unlock(&gsm->tx_mutex);
+		spin_unlock_irqrestore(&gsm->tx_lock, flags);
 		break;
 	case CMD_FCOFF:
 		/* Modem wants us to STFU */
@@ -2225,7 +2228,6 @@ static void gsm_free_mux(struct gsm_mux *gsm)
 			break;
 		}
 	}
-	mutex_destroy(&gsm->tx_mutex);
 	mutex_destroy(&gsm->mutex);
 	kfree(gsm->txframe);
 	kfree(gsm->buf);
@@ -2297,12 +2299,12 @@ static struct gsm_mux *gsm_alloc_mux(void)
 	}
 	spin_lock_init(&gsm->lock);
 	mutex_init(&gsm->mutex);
-	mutex_init(&gsm->tx_mutex);
 	kref_init(&gsm->ref);
 	INIT_LIST_HEAD(&gsm->tx_list);
 	timer_setup(&gsm->t2_timer, gsm_control_retransmit, 0);
 	init_waitqueue_head(&gsm->event);
 	spin_lock_init(&gsm->control_lock);
+	spin_lock_init(&gsm->tx_lock);
 
 	gsm->t1 = T1;
 	gsm->t2 = T2;
@@ -2327,7 +2329,6 @@ static struct gsm_mux *gsm_alloc_mux(void)
 	}
 	spin_unlock(&gsm_mux_lock);
 	if (i == MAX_MUX) {
-		mutex_destroy(&gsm->tx_mutex);
 		mutex_destroy(&gsm->mutex);
 		kfree(gsm->txframe);
 		kfree(gsm->buf);
@@ -2652,15 +2653,16 @@ static int gsmld_open(struct tty_struct *tty)
 static void gsmld_write_wakeup(struct tty_struct *tty)
 {
 	struct gsm_mux *gsm = tty->disc_data;
+	unsigned long flags;
 
 	/* Queue poll */
 	clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-	mutex_lock(&gsm->tx_mutex);
+	spin_lock_irqsave(&gsm->tx_lock, flags);
 	gsm_data_kick(gsm, NULL);
 	if (gsm->tx_bytes < TX_THRESH_LO) {
 		gsm_dlci_data_sweep(gsm);
 	}
-	mutex_unlock(&gsm->tx_mutex);
+	spin_unlock_irqrestore(&gsm->tx_lock, flags);
 }
 
 /**
@@ -2703,6 +2705,7 @@ static ssize_t gsmld_write(struct tty_struct *tty, struct file *file,
 			   const unsigned char *buf, size_t nr)
 {
 	struct gsm_mux *gsm = tty->disc_data;
+	unsigned long flags;
 	int space;
 	int ret;
 
@@ -2710,13 +2713,13 @@ static ssize_t gsmld_write(struct tty_struct *tty, struct file *file,
 		return -ENODEV;
 
 	ret = -ENOBUFS;
-	mutex_lock(&gsm->tx_mutex);
+	spin_lock_irqsave(&gsm->tx_lock, flags);
 	space = tty_write_room(tty);
 	if (space >= nr)
 		ret = tty->ops->write(tty, buf, nr);
 	else
 		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
-	mutex_unlock(&gsm->tx_mutex);
+	spin_unlock_irqrestore(&gsm->tx_lock, flags);
 
 	return ret;
 }
diff --git a/fs/afs/fs_probe.c b/fs/afs/fs_probe.c
index e7e98ad63a91..04d42e49fc59 100644
--- a/fs/afs/fs_probe.c
+++ b/fs/afs/fs_probe.c
@@ -161,8 +161,8 @@ void afs_fileserver_probe_result(struct afs_call *call)
 		}
 	}
 
-	if (rxrpc_kernel_get_srtt(call->net->socket, call->rxcall, &rtt_us) &&
-	    rtt_us < server->probe.rtt) {
+	rxrpc_kernel_get_srtt(call->net->socket, call->rxcall, &rtt_us);
+	if (rtt_us < server->probe.rtt) {
 		server->probe.rtt = rtt_us;
 		server->rtt = rtt_us;
 		alist->preferred = index;
diff --git a/fs/btrfs/backref.c b/fs/btrfs/backref.c
index 6942707f8b03..7208ba22e734 100644
--- a/fs/btrfs/backref.c
+++ b/fs/btrfs/backref.c
@@ -2060,10 +2060,29 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
+static int build_ino_list(u64 inum, u64 offset, u64 root, void *ctx)
+{
+	struct btrfs_data_container *inodes = ctx;
+	const size_t c = 3 * sizeof(u64);
+
+	if (inodes->bytes_left >= c) {
+		inodes->bytes_left -= c;
+		inodes->val[inodes->elem_cnt] = inum;
+		inodes->val[inodes->elem_cnt + 1] = offset;
+		inodes->val[inodes->elem_cnt + 2] = root;
+		inodes->elem_cnt += 3;
+	} else {
+		inodes->bytes_missing += c - inodes->bytes_left;
+		inodes->bytes_left = 0;
+		inodes->elem_missed += 3;
+	}
+
+	return 0;
+}
+
 int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 				struct btrfs_path *path,
-				iterate_extent_inodes_t *iterate, void *ctx,
-				bool ignore_offset)
+				void *ctx, bool ignore_offset)
 {
 	int ret;
 	u64 extent_item_pos;
@@ -2081,7 +2100,7 @@ int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
 	extent_item_pos = logical - found_key.objectid;
 	ret = iterate_extent_inodes(fs_info, found_key.objectid,
 					extent_item_pos, search_commit_root,
-					iterate, ctx, ignore_offset);
+					build_ino_list, ctx, ignore_offset);
 
 	return ret;
 }
diff --git a/fs/btrfs/backref.h b/fs/btrfs/backref.h
index 17abde7f794c..6ed18b807b64 100644
--- a/fs/btrfs/backref.h
+++ b/fs/btrfs/backref.h
@@ -35,8 +35,7 @@ int iterate_extent_inodes(struct btrfs_fs_info *fs_info,
 				bool ignore_offset);
 
 int iterate_inodes_from_logical(u64 logical, struct btrfs_fs_info *fs_info,
-				struct btrfs_path *path,
-				iterate_extent_inodes_t *iterate, void *ctx,
+				struct btrfs_path *path, void *ctx,
 				bool ignore_offset);
 
 int paths_from_inode(u64 inum, struct inode_fs_paths *ipath);
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index d0c31651ec80..a17076a05c4d 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -3898,26 +3898,6 @@ static long btrfs_ioctl_ino_to_path(struct btrfs_root *root, void __user *arg)
 	return ret;
 }
 
-static int build_ino_list(u64 inum, u64 offset, u64 root, void *ctx)
-{
-	struct btrfs_data_container *inodes = ctx;
-	const size_t c = 3 * sizeof(u64);
-
-	if (inodes->bytes_left >= c) {
-		inodes->bytes_left -= c;
-		inodes->val[inodes->elem_cnt] = inum;
-		inodes->val[inodes->elem_cnt + 1] = offset;
-		inodes->val[inodes->elem_cnt + 2] = root;
-		inodes->elem_cnt += 3;
-	} else {
-		inodes->bytes_missing += c - inodes->bytes_left;
-		inodes->bytes_left = 0;
-		inodes->elem_missed += 3;
-	}
-
-	return 0;
-}
-
 static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 					void __user *arg, int version)
 {
@@ -3953,21 +3933,20 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 		size = min_t(u32, loi->size, SZ_16M);
 	}
 
-	path = btrfs_alloc_path();
-	if (!path) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
 	inodes = init_data_container(size);
 	if (IS_ERR(inodes)) {
 		ret = PTR_ERR(inodes);
-		inodes = NULL;
-		goto out;
+		goto out_loi;
 	}
 
+	path = btrfs_alloc_path();
+	if (!path) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	ret = iterate_inodes_from_logical(loi->logical, fs_info, path,
-					  build_ino_list, inodes, ignore_offset);
+					  inodes, ignore_offset);
+	btrfs_free_path(path);
 	if (ret == -EINVAL)
 		ret = -ENOENT;
 	if (ret < 0)
@@ -3979,7 +3958,6 @@ static long btrfs_ioctl_logical_to_ino(struct btrfs_fs_info *fs_info,
 		ret = -EFAULT;
 
 out:
-	btrfs_free_path(path);
 	kvfree(inodes);
 out_loi:
 	kfree(loi);
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 36da77534076..74cbbb5d8897 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -2913,14 +2913,7 @@ int btrfs_qgroup_inherit(struct btrfs_trans_handle *trans, u64 srcid,
 		dstgroup->rsv_rfer = inherit->lim.rsv_rfer;
 		dstgroup->rsv_excl = inherit->lim.rsv_excl;
 
-		ret = update_qgroup_limit_item(trans, dstgroup);
-		if (ret) {
-			fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-			btrfs_info(fs_info,
-				   "unable to update quota limit for %llu",
-				   dstgroup->qgroupid);
-			goto unlock;
-		}
+		qgroup_dirty(fs_info, dstgroup);
 	}
 
 	if (srcid) {
@@ -3290,7 +3283,8 @@ static int qgroup_rescan_leaf(struct btrfs_trans_handle *trans,
 static bool rescan_should_stop(struct btrfs_fs_info *fs_info)
 {
 	return btrfs_fs_closing(fs_info) ||
-		test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state);
+		test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state) ||
+		!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags);
 }
 
 static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
@@ -3320,11 +3314,9 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 			err = PTR_ERR(trans);
 			break;
 		}
-		if (!test_bit(BTRFS_FS_QUOTA_ENABLED, &fs_info->flags)) {
-			err = -EINTR;
-		} else {
-			err = qgroup_rescan_leaf(trans, path);
-		}
+
+		err = qgroup_rescan_leaf(trans, path);
+
 		if (err > 0)
 			btrfs_commit_transaction(trans);
 		else
@@ -3338,7 +3330,7 @@ static void btrfs_qgroup_rescan_worker(struct btrfs_work *work)
 	if (err > 0 &&
 	    fs_info->qgroup_flags & BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT) {
 		fs_info->qgroup_flags &= ~BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
-	} else if (err < 0) {
+	} else if (err < 0 || stopped) {
 		fs_info->qgroup_flags |= BTRFS_QGROUP_STATUS_FLAG_INCONSISTENT;
 	}
 	mutex_unlock(&fs_info->qgroup_rescan_lock);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index d1cb1addea96..c5c22b067cd8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -217,6 +217,7 @@ struct fixed_file_data {
 	struct completion		done;
 	struct list_head		ref_list;
 	spinlock_t			lock;
+	bool				quiesce;
 };
 
 struct io_buffer {
@@ -7105,41 +7106,79 @@ static void io_sqe_files_set_node(struct fixed_file_data *file_data,
 	percpu_ref_get(&file_data->refs);
 }
 
-static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
-{
-	struct fixed_file_data *data = ctx->file_data;
-	struct fixed_file_ref_node *backup_node, *ref_node = NULL;
-	unsigned nr_tables, i;
-	int ret;
 
-	if (!data)
-		return -ENXIO;
-	backup_node = alloc_fixed_file_ref_node(ctx);
-	if (!backup_node)
-		return -ENOMEM;
+static void io_sqe_files_kill_node(struct fixed_file_data *data)
+{
+	struct fixed_file_ref_node *ref_node = NULL;
 
 	spin_lock_bh(&data->lock);
 	ref_node = data->node;
 	spin_unlock_bh(&data->lock);
 	if (ref_node)
 		percpu_ref_kill(&ref_node->refs);
+}
+
+static int io_file_ref_quiesce(struct fixed_file_data *data,
+			       struct io_ring_ctx *ctx)
+{
+	int ret;
+	struct fixed_file_ref_node *backup_node;
 
-	percpu_ref_kill(&data->refs);
+	if (data->quiesce)
+		return -ENXIO;
 
-	/* wait for all refs nodes to complete */
-	flush_delayed_work(&ctx->file_put_work);
+	data->quiesce = true;
 	do {
+		backup_node = alloc_fixed_file_ref_node(ctx);
+		if (!backup_node)
+			break;
+
+		io_sqe_files_kill_node(data);
+		percpu_ref_kill(&data->refs);
+		flush_delayed_work(&ctx->file_put_work);
+
 		ret = wait_for_completion_interruptible(&data->done);
 		if (!ret)
 			break;
+
+		percpu_ref_resurrect(&data->refs);
+		io_sqe_files_set_node(data, backup_node);
+		backup_node = NULL;
+		reinit_completion(&data->done);
+		mutex_unlock(&ctx->uring_lock);
 		ret = io_run_task_work_sig();
-		if (ret < 0) {
-			percpu_ref_resurrect(&data->refs);
-			reinit_completion(&data->done);
-			io_sqe_files_set_node(data, backup_node);
-			return ret;
-		}
+		mutex_lock(&ctx->uring_lock);
+
+		if (ret < 0)
+			break;
+		backup_node = alloc_fixed_file_ref_node(ctx);
+		ret = -ENOMEM;
+		if (!backup_node)
+			break;
 	} while (1);
+	data->quiesce = false;
+
+	if (backup_node)
+		destroy_fixed_file_ref_node(backup_node);
+	return ret;
+}
+
+static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
+{
+	struct fixed_file_data *data = ctx->file_data;
+	unsigned nr_tables, i;
+	int ret;
+
+	/*
+	 * percpu_ref_is_dying() is to stop parallel files unregister
+	 * Since we possibly drop uring lock later in this function to
+	 * run task work.
+	 */
+	if (!data || percpu_ref_is_dying(&data->refs))
+		return -ENXIO;
+	ret = io_file_ref_quiesce(data, ctx);
+	if (ret)
+		return ret;
 
 	__io_sqe_files_unregister(ctx);
 	nr_tables = DIV_ROUND_UP(ctx->nr_user_files, IORING_MAX_FILES_TABLE);
@@ -7150,7 +7189,6 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	kfree(data);
 	ctx->file_data = NULL;
 	ctx->nr_user_files = 0;
-	destroy_fixed_file_ref_node(backup_node);
 	return 0;
 }
 
@@ -8444,7 +8482,9 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		css_put(ctx->sqo_blkcg_css);
 #endif
 
+	mutex_lock(&ctx->uring_lock);
 	io_sqe_files_unregister(ctx);
+	mutex_unlock(&ctx->uring_lock);
 	io_eventfd_unregister(ctx);
 	io_destroy_buffers(ctx);
 
diff --git a/fs/nilfs2/dat.c b/fs/nilfs2/dat.c
index 1a3d183027b9..8fedc7104320 100644
--- a/fs/nilfs2/dat.c
+++ b/fs/nilfs2/dat.c
@@ -111,6 +111,13 @@ static void nilfs_dat_commit_free(struct inode *dat,
 	kunmap_atomic(kaddr);
 
 	nilfs_dat_commit_entry(dat, req);
+
+	if (unlikely(req->pr_desc_bh == NULL || req->pr_bitmap_bh == NULL)) {
+		nilfs_error(dat->i_sb,
+			    "state inconsistency probably due to duplicate use of vblocknr = %llu",
+			    (unsigned long long)req->pr_entry_nr);
+		return;
+	}
 	nilfs_palloc_commit_free_entry(dat, req);
 }
 
diff --git a/include/linux/mmc/mmc.h b/include/linux/mmc/mmc.h
index d9a65c6a8816..545578fb814b 100644
--- a/include/linux/mmc/mmc.h
+++ b/include/linux/mmc/mmc.h
@@ -445,7 +445,7 @@ static inline bool mmc_ready_for_data(u32 status)
 #define MMC_SECURE_TRIM1_ARG		0x80000001
 #define MMC_SECURE_TRIM2_ARG		0x80008000
 #define MMC_SECURE_ARGS			0x80000000
-#define MMC_TRIM_ARGS			0x00008001
+#define MMC_TRIM_OR_DISCARD_ARGS	0x00008003
 
 #define mmc_driver_type_mask(n)		(1 << (n))
 
diff --git a/include/net/sctp/stream_sched.h b/include/net/sctp/stream_sched.h
index 01a70b27e026..65058faea4db 100644
--- a/include/net/sctp/stream_sched.h
+++ b/include/net/sctp/stream_sched.h
@@ -26,6 +26,8 @@ struct sctp_sched_ops {
 	int (*init)(struct sctp_stream *stream);
 	/* Init a stream */
 	int (*init_sid)(struct sctp_stream *stream, __u16 sid, gfp_t gfp);
+	/* free a stream */
+	void (*free_sid)(struct sctp_stream *stream, __u16 sid);
 	/* Frees the entire thing */
 	void (*free)(struct sctp_stream *stream);
 
diff --git a/ipc/sem.c b/ipc/sem.c
index 2cb6515ef1dd..916f7a90be31 100644
--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -2190,14 +2190,15 @@ static long do_semtimedop(int semid, struct sembuf __user *tsops,
 		 * scenarios where we were awakened externally, during the
 		 * window between wake_q_add() and wake_up_q().
 		 */
+		rcu_read_lock();
 		error = READ_ONCE(queue.status);
 		if (error != -EINTR) {
 			/* see SEM_BARRIER_2 for purpose/pairing */
 			smp_acquire__after_ctrl_dep();
+			rcu_read_unlock();
 			goto out_free;
 		}
 
-		rcu_read_lock();
 		locknum = sem_lock(sma, sops, nsops);
 
 		if (!ipc_valid_object(&sma->sem_perm))
diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storage.c
index 5d3a7af9ba9b..8aaaaef99f09 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -70,7 +70,7 @@ bpf_selem_alloc(struct bpf_local_storage_map *smap, void *owner,
 	selem = kzalloc(smap->elem_size, GFP_ATOMIC | __GFP_NOWARN);
 	if (selem) {
 		if (value)
-			memcpy(SDATA(selem)->data, value, smap->map.value_size);
+			copy_map_value(&smap->map, SDATA(selem)->data, value);
 		return selem;
 	}
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0e01216f4e5a..e9b354d521a3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8740,7 +8740,7 @@ static void perf_event_bpf_emit_ksymbols(struct bpf_prog *prog,
 				PERF_RECORD_KSYMBOL_TYPE_BPF,
 				(u64)(unsigned long)subprog->bpf_func,
 				subprog->jited_len, unregister,
-				prog->aux->ksym.name);
+				subprog->aux->ksym.name);
 		}
 	}
 }
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f0dd1a3b66eb..3eb527f8a269 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -391,13 +391,14 @@ int proc_dostring(struct ctl_table *table, int write,
 			ppos);
 }
 
-static size_t proc_skip_spaces(char **buf)
+static void proc_skip_spaces(char **buf, size_t *size)
 {
-	size_t ret;
-	char *tmp = skip_spaces(*buf);
-	ret = tmp - *buf;
-	*buf = tmp;
-	return ret;
+	while (*size) {
+		if (!isspace(**buf))
+			break;
+		(*size)--;
+		(*buf)++;
+	}
 }
 
 static void proc_skip_char(char **buf, size_t *size, const char v)
@@ -466,13 +467,12 @@ static int proc_get_long(char **buf, size_t *size,
 			  unsigned long *val, bool *neg,
 			  const char *perm_tr, unsigned perm_tr_len, char *tr)
 {
-	int len;
 	char *p, tmp[TMPBUFLEN];
+	ssize_t len = *size;
 
-	if (!*size)
+	if (len <= 0)
 		return -EINVAL;
 
-	len = *size;
 	if (len > TMPBUFLEN - 1)
 		len = TMPBUFLEN - 1;
 
@@ -630,7 +630,7 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 		bool neg;
 
 		if (write) {
-			left -= proc_skip_spaces(&p);
+			proc_skip_spaces(&p, &left);
 
 			if (!left)
 				break;
@@ -657,7 +657,7 @@ static int __do_proc_dointvec(void *tbl_data, struct ctl_table *table,
 	if (!write && !first && left && !err)
 		proc_put_char(&buffer, &left, '\n');
 	if (write && !err && left)
-		left -= proc_skip_spaces(&p);
+		proc_skip_spaces(&p, &left);
 	if (write && first)
 		return err ? : -EINVAL;
 	*lenp -= left;
@@ -699,7 +699,7 @@ static int do_proc_douintvec_w(unsigned int *tbl_data,
 	if (left > PAGE_SIZE - 1)
 		left = PAGE_SIZE - 1;
 
-	left -= proc_skip_spaces(&p);
+	proc_skip_spaces(&p, &left);
 	if (!left) {
 		err = -EINVAL;
 		goto out_free;
@@ -719,7 +719,7 @@ static int do_proc_douintvec_w(unsigned int *tbl_data,
 	}
 
 	if (!err && left)
-		left -= proc_skip_spaces(&p);
+		proc_skip_spaces(&p, &left);
 
 out_free:
 	if (err)
@@ -1177,7 +1177,7 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table,
 		if (write) {
 			bool neg;
 
-			left -= proc_skip_spaces(&p);
+			proc_skip_spaces(&p, &left);
 			if (!left)
 				break;
 
@@ -1205,7 +1205,7 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table,
 	if (!write && !first && left && !err)
 		proc_put_char(&buffer, &left, '\n');
 	if (write && !err)
-		left -= proc_skip_spaces(&p);
+		proc_skip_spaces(&p, &left);
 	if (write && first)
 		return err ? : -EINVAL;
 	*lenp -= left;
diff --git a/kernel/trace/trace_dynevent.c b/kernel/trace/trace_dynevent.c
index 5fa49cfd2bb6..d312a52a10a5 100644
--- a/kernel/trace/trace_dynevent.c
+++ b/kernel/trace/trace_dynevent.c
@@ -70,6 +70,7 @@ int dyn_event_release(int argc, char **argv, struct dyn_event_operations *type)
 		if (ret)
 			break;
 	}
+	tracing_reset_all_online_cpus();
 	mutex_unlock(&event_mutex);
 
 	return ret;
@@ -165,6 +166,7 @@ int dyn_events_release_all(struct dyn_event_operations *type)
 			break;
 	}
 out:
+	tracing_reset_all_online_cpus();
 	mutex_unlock(&event_mutex);
 
 	return ret;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 826ecf01e380..bac13f24a96e 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2572,7 +2572,10 @@ static int probe_remove_event_call(struct trace_event_call *call)
 		 * TRACE_REG_UNREGISTER.
 		 */
 		if (file->flags & EVENT_FILE_FL_ENABLED)
-			return -EBUSY;
+			goto busy;
+
+		if (file->flags & EVENT_FILE_FL_WAS_ENABLED)
+			tr->clear_trace = true;
 		/*
 		 * The do_for_each_event_file_safe() is
 		 * a double loop. After finding the call for this
@@ -2585,6 +2588,12 @@ static int probe_remove_event_call(struct trace_event_call *call)
 	__trace_remove_event_call(call);
 
 	return 0;
+ busy:
+	/* No need to clear the trace now */
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
+		tr->clear_trace = false;
+	}
+	return -EBUSY;
 }
 
 /* Remove an event_call */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ce796ca869c2..4aed8abb2022 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -298,8 +298,10 @@ config FRAME_WARN
 	int "Warn for stack frames larger than"
 	range 0 8192
 	default 2048 if GCC_PLUGIN_LATENT_ENTROPY
-	default 1280 if (!64BIT && PARISC)
-	default 1024 if (!64BIT && !PARISC)
+	default 2048 if PARISC
+	default 1536 if (!64BIT && XTENSA)
+	default 1280 if KASAN && !64BIT
+	default 1024 if !64BIT
 	default 2048 if 64BIT
 	help
 	  Tell gcc to warn at build time for stack frames larger than this.
@@ -1801,8 +1803,14 @@ config NETDEV_NOTIFIER_ERROR_INJECT
 	  If unsure, say N.
 
 config FUNCTION_ERROR_INJECTION
-	def_bool y
+	bool "Fault-injections of functions"
 	depends on HAVE_FUNCTION_ERROR_INJECTION && KPROBES
+	help
+	  Add fault injections into various functions that are annotated with
+	  ALLOW_ERROR_INJECTION() in the kernel. BPF may also modify the return
+	  value of theses functions. This is useful to test error paths of code.
+
+	  If unsure, say N
 
 config FAULT_INJECTION
 	bool "Fault-injection framework"
diff --git a/mm/frame_vector.c b/mm/frame_vector.c
index 10f82d5643b6..0e589a9a8801 100644
--- a/mm/frame_vector.c
+++ b/mm/frame_vector.c
@@ -37,7 +37,6 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	int ret = 0;
-	int err;
 	int locked;
 
 	if (nr_frames == 0)
@@ -74,32 +73,14 @@ int get_vaddr_frames(unsigned long start, unsigned int nr_frames,
 		vec->is_pfns = false;
 		ret = pin_user_pages_locked(start, nr_frames,
 			gup_flags, (struct page **)(vec->ptrs), &locked);
-		goto out;
+		if (likely(ret > 0))
+			goto out;
 	}
 
-	vec->got_ref = false;
-	vec->is_pfns = true;
-	do {
-		unsigned long *nums = frame_vector_pfns(vec);
-
-		while (ret < nr_frames && start + PAGE_SIZE <= vma->vm_end) {
-			err = follow_pfn(vma, start, &nums[ret]);
-			if (err) {
-				if (ret == 0)
-					ret = err;
-				goto out;
-			}
-			start += PAGE_SIZE;
-			ret++;
-		}
-		/*
-		 * We stop if we have enough pages or if VMA doesn't completely
-		 * cover the tail page.
-		 */
-		if (ret >= nr_frames || start < vma->vm_end)
-			break;
-		vma = find_vma_intersection(mm, start, start + 1);
-	} while (vma && vma->vm_flags & (VM_IO | VM_PFNMAP));
+	/* This used to (racily) return non-refcounted pfns. Let people know */
+	WARN_ONCE(1, "get_vaddr_frames() cannot follow VM_IO mapping");
+	vec->nr_frames = 0;
+
 out:
 	if (locked)
 		mmap_read_unlock(mm);
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 400219801e63..deb66635f0f3 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -852,8 +852,10 @@ static int p9_socket_open(struct p9_client *client, struct socket *csocket)
 	struct file *file;
 
 	p = kzalloc(sizeof(struct p9_trans_fd), GFP_KERNEL);
-	if (!p)
+	if (!p) {
+		sock_release(csocket);
 		return -ENOMEM;
+	}
 
 	csocket->sk->sk_allocation = GFP_NOIO;
 	file = sock_alloc_file(csocket, 0, NULL);
diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 908324b46328..cb9b54a7abd2 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -303,17 +303,18 @@ static void hsr_deliver_master(struct sk_buff *skb, struct net_device *dev,
 			       struct hsr_node *node_src)
 {
 	bool was_multicast_frame;
-	int res;
+	int res, recv_len;
 
 	was_multicast_frame = (skb->pkt_type == PACKET_MULTICAST);
 	hsr_addr_subst_source(node_src, skb);
 	skb_pull(skb, ETH_HLEN);
+	recv_len = skb->len;
 	res = netif_rx(skb);
 	if (res == NET_RX_DROP) {
 		dev->stats.rx_dropped++;
 	} else {
 		dev->stats.rx_packets++;
-		dev->stats.rx_bytes += skb->len;
+		dev->stats.rx_bytes += recv_len;
 		if (was_multicast_frame)
 			dev->stats.multicast++;
 	}
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index 3824b7abecf7..52ec0c43e6b8 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -887,13 +887,15 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 		return 1;
 	}
 
+	if (fi->nh) {
+		if (cfg->fc_oif || cfg->fc_gw_family || cfg->fc_mp)
+			return 1;
+		return 0;
+	}
+
 	if (cfg->fc_oif || cfg->fc_gw_family) {
 		struct fib_nh *nh;
 
-		/* cannot match on nexthop object attributes */
-		if (fi->nh)
-			return 1;
-
 		nh = fib_info_nh(fi, 0);
 		if (cfg->fc_encap) {
 			if (fib_encap_match(net, cfg->fc_encap_type,
diff --git a/net/mac80211/airtime.c b/net/mac80211/airtime.c
index 26d2f8ba7029..758ef63669e7 100644
--- a/net/mac80211/airtime.c
+++ b/net/mac80211/airtime.c
@@ -457,6 +457,9 @@ static u32 ieee80211_get_rate_duration(struct ieee80211_hw *hw,
 			 (status->encoding == RX_ENC_HE && streams > 8)))
 		return 0;
 
+	if (idx >= MCS_GROUP_RATES)
+		return 0;
+
 	duration = airtime_mcs_groups[group].duration[idx];
 	duration <<= airtime_mcs_groups[group].shift;
 	*overhead = 36 + (streams << 2);
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index b70b06e312bd..eaa030e2ad55 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -2243,8 +2243,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (skb->ip_summed == CHECKSUM_PARTIAL)
 		status |= TP_STATUS_CSUMNOTREADY;
 	else if (skb->pkt_type != PACKET_OUTGOING &&
-		 (skb->ip_summed == CHECKSUM_COMPLETE ||
-		  skb_csum_unnecessary(skb)))
+		 skb_csum_unnecessary(skb))
 		status |= TP_STATUS_CSUM_VALID;
 
 	if (snaplen > res)
@@ -3480,8 +3479,7 @@ static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
 		if (skb->ip_summed == CHECKSUM_PARTIAL)
 			aux.tp_status |= TP_STATUS_CSUMNOTREADY;
 		else if (skb->pkt_type != PACKET_OUTGOING &&
-			 (skb->ip_summed == CHECKSUM_COMPLETE ||
-			  skb_csum_unnecessary(skb)))
+			 skb_csum_unnecessary(skb))
 			aux.tp_status |= TP_STATUS_CSUM_VALID;
 
 		aux.tp_len = origlen;
diff --git a/net/sctp/stream.c b/net/sctp/stream.c
index ef9fceadef8d..ee6514af830f 100644
--- a/net/sctp/stream.c
+++ b/net/sctp/stream.c
@@ -52,6 +52,19 @@ static void sctp_stream_shrink_out(struct sctp_stream *stream, __u16 outcnt)
 	}
 }
 
+static void sctp_stream_free_ext(struct sctp_stream *stream, __u16 sid)
+{
+	struct sctp_sched_ops *sched;
+
+	if (!SCTP_SO(stream, sid)->ext)
+		return;
+
+	sched = sctp_sched_ops_from_stream(stream);
+	sched->free_sid(stream, sid);
+	kfree(SCTP_SO(stream, sid)->ext);
+	SCTP_SO(stream, sid)->ext = NULL;
+}
+
 /* Migrates chunks from stream queues to new stream queues if needed,
  * but not across associations. Also, removes those chunks to streams
  * higher than the new max.
@@ -70,16 +83,14 @@ static void sctp_stream_outq_migrate(struct sctp_stream *stream,
 		 * sctp_stream_update will swap ->out pointers.
 		 */
 		for (i = 0; i < outcnt; i++) {
-			kfree(SCTP_SO(new, i)->ext);
+			sctp_stream_free_ext(new, i);
 			SCTP_SO(new, i)->ext = SCTP_SO(stream, i)->ext;
 			SCTP_SO(stream, i)->ext = NULL;
 		}
 	}
 
-	for (i = outcnt; i < stream->outcnt; i++) {
-		kfree(SCTP_SO(stream, i)->ext);
-		SCTP_SO(stream, i)->ext = NULL;
-	}
+	for (i = outcnt; i < stream->outcnt; i++)
+		sctp_stream_free_ext(stream, i);
 }
 
 static int sctp_stream_alloc_out(struct sctp_stream *stream, __u16 outcnt,
@@ -174,9 +185,9 @@ void sctp_stream_free(struct sctp_stream *stream)
 	struct sctp_sched_ops *sched = sctp_sched_ops_from_stream(stream);
 	int i;
 
-	sched->free(stream);
+	sched->unsched_all(stream);
 	for (i = 0; i < stream->outcnt; i++)
-		kfree(SCTP_SO(stream, i)->ext);
+		sctp_stream_free_ext(stream, i);
 	genradix_free(&stream->out);
 	genradix_free(&stream->in);
 }
diff --git a/net/sctp/stream_sched.c b/net/sctp/stream_sched.c
index a2e1d34f52c5..33c2630c2496 100644
--- a/net/sctp/stream_sched.c
+++ b/net/sctp/stream_sched.c
@@ -46,6 +46,10 @@ static int sctp_sched_fcfs_init_sid(struct sctp_stream *stream, __u16 sid,
 	return 0;
 }
 
+static void sctp_sched_fcfs_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+}
+
 static void sctp_sched_fcfs_free(struct sctp_stream *stream)
 {
 }
@@ -96,6 +100,7 @@ static struct sctp_sched_ops sctp_sched_fcfs = {
 	.get = sctp_sched_fcfs_get,
 	.init = sctp_sched_fcfs_init,
 	.init_sid = sctp_sched_fcfs_init_sid,
+	.free_sid = sctp_sched_fcfs_free_sid,
 	.free = sctp_sched_fcfs_free,
 	.enqueue = sctp_sched_fcfs_enqueue,
 	.dequeue = sctp_sched_fcfs_dequeue,
diff --git a/net/sctp/stream_sched_prio.c b/net/sctp/stream_sched_prio.c
index 80b5a2c4cbc7..4fc9f2923ed1 100644
--- a/net/sctp/stream_sched_prio.c
+++ b/net/sctp/stream_sched_prio.c
@@ -204,6 +204,24 @@ static int sctp_sched_prio_init_sid(struct sctp_stream *stream, __u16 sid,
 	return sctp_sched_prio_set(stream, sid, 0, gfp);
 }
 
+static void sctp_sched_prio_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+	struct sctp_stream_priorities *prio = SCTP_SO(stream, sid)->ext->prio_head;
+	int i;
+
+	if (!prio)
+		return;
+
+	SCTP_SO(stream, sid)->ext->prio_head = NULL;
+	for (i = 0; i < stream->outcnt; i++) {
+		if (SCTP_SO(stream, i)->ext &&
+		    SCTP_SO(stream, i)->ext->prio_head == prio)
+			return;
+	}
+
+	kfree(prio);
+}
+
 static void sctp_sched_prio_free(struct sctp_stream *stream)
 {
 	struct sctp_stream_priorities *prio, *n;
@@ -323,6 +341,7 @@ static struct sctp_sched_ops sctp_sched_prio = {
 	.get = sctp_sched_prio_get,
 	.init = sctp_sched_prio_init,
 	.init_sid = sctp_sched_prio_init_sid,
+	.free_sid = sctp_sched_prio_free_sid,
 	.free = sctp_sched_prio_free,
 	.enqueue = sctp_sched_prio_enqueue,
 	.dequeue = sctp_sched_prio_dequeue,
diff --git a/net/sctp/stream_sched_rr.c b/net/sctp/stream_sched_rr.c
index ff425aed62c7..cc444fe0d67c 100644
--- a/net/sctp/stream_sched_rr.c
+++ b/net/sctp/stream_sched_rr.c
@@ -90,6 +90,10 @@ static int sctp_sched_rr_init_sid(struct sctp_stream *stream, __u16 sid,
 	return 0;
 }
 
+static void sctp_sched_rr_free_sid(struct sctp_stream *stream, __u16 sid)
+{
+}
+
 static void sctp_sched_rr_free(struct sctp_stream *stream)
 {
 	sctp_sched_rr_unsched_all(stream);
@@ -177,6 +181,7 @@ static struct sctp_sched_ops sctp_sched_rr = {
 	.get = sctp_sched_rr_get,
 	.init = sctp_sched_rr_init,
 	.init_sid = sctp_sched_rr_init_sid,
+	.free_sid = sctp_sched_rr_free_sid,
 	.free = sctp_sched_rr_free,
 	.enqueue = sctp_sched_rr_enqueue,
 	.dequeue = sctp_sched_rr_dequeue,
diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 6f91b9a306dc..de63d6d41645 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -1975,6 +1975,9 @@ static void tipc_crypto_rcv_complete(struct net *net, struct tipc_aead *aead,
 	/* Ok, everything's fine, try to synch own keys according to peers' */
 	tipc_crypto_key_synch(rx, *skb);
 
+	/* Re-fetch skb cb as skb might be changed in tipc_msg_validate */
+	skb_cb = TIPC_SKB_CB(*skb);
+
 	/* Mark skb decrypted */
 	skb_cb->decrypted = 1;
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 15119c49c093..d09dabae5627 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -330,7 +330,8 @@ static size_t cfg80211_gen_new_ie(const u8 *ie, size_t ielen,
 			 * determine if they are the same ie.
 			 */
 			if (tmp_old[0] == WLAN_EID_VENDOR_SPECIFIC) {
-				if (!memcmp(tmp_old + 2, tmp + 2, 5)) {
+				if (tmp_old[1] >= 5 && tmp[1] >= 5 &&
+				    !memcmp(tmp_old + 2, tmp + 2, 5)) {
 					/* same vendor ie, copy from
 					 * subelement
 					 */
@@ -2466,10 +2467,15 @@ cfg80211_inform_bss_frame_data(struct wiphy *wiphy,
 	const struct cfg80211_bss_ies *ies1, *ies2;
 	size_t ielen = len - offsetof(struct ieee80211_mgmt,
 				      u.probe_resp.variable);
-	struct cfg80211_non_tx_bss non_tx_data;
+	struct cfg80211_non_tx_bss non_tx_data = {};
 
 	res = cfg80211_inform_single_bss_frame_data(wiphy, data, mgmt,
 						    len, gfp);
+
+	/* don't do any further MBSSID handling for S1G */
+	if (ieee80211_is_s1g_beacon(mgmt->frame_control))
+		return res;
+
 	if (!res || !wiphy->support_mbssid ||
 	    !cfg80211_find_ie(WLAN_EID_MULTIPLE_BSSID, ie, ielen))
 		return res;
diff --git a/scripts/faddr2line b/scripts/faddr2line
index 57099687e5e1..9e730b805e87 100755
--- a/scripts/faddr2line
+++ b/scripts/faddr2line
@@ -73,7 +73,8 @@ command -v ${ADDR2LINE} >/dev/null 2>&1 || die "${ADDR2LINE} isn't installed"
 find_dir_prefix() {
 	local objfile=$1
 
-	local start_kernel_addr=$(${READELF} --symbols --wide $objfile | ${AWK} '$8 == "start_kernel" {printf "0x%s", $2}')
+	local start_kernel_addr=$(${READELF} --symbols --wide $objfile | sed 's/\[.*\]//' |
+		${AWK} '$8 == "start_kernel" {printf "0x%s", $2}')
 	[[ -z $start_kernel_addr ]] && return
 
 	local file_line=$(${ADDR2LINE} -e $objfile $start_kernel_addr)
@@ -177,7 +178,7 @@ __faddr2line() {
 				found=2
 				break
 			fi
-		done < <(${READELF} --symbols --wide $objfile | ${AWK} -v sec=$sym_sec '$7 == sec' | sort --key=2)
+		done < <(${READELF} --symbols --wide $objfile | sed 's/\[.*\]//' | ${AWK} -v sec=$sym_sec '$7 == sec' | sort --key=2)
 
 		if [[ $found = 0 ]]; then
 			warn "can't find symbol: sym_name: $sym_name sym_sec: $sym_sec sym_addr: $sym_addr sym_elf_size: $sym_elf_size"
@@ -258,7 +259,7 @@ __faddr2line() {
 
 		DONE=1
 
-	done < <(${READELF} --symbols --wide $objfile | ${AWK} -v fn=$sym_name '$4 == "FUNC" && $8 == fn')
+	done < <(${READELF} --symbols --wide $objfile | sed 's/\[.*\]//' | ${AWK} -v fn=$sym_name '$4 == "FUNC" && $8 == fn')
 }
 
 [[ $# -lt 2 ]] && usage
diff --git a/sound/soc/soc-ops.c b/sound/soc/soc-ops.c
index 0f26d6c31ce5..5fdd96e77ef3 100644
--- a/sound/soc/soc-ops.c
+++ b/sound/soc/soc-ops.c
@@ -432,7 +432,7 @@ int snd_soc_put_volsw_sx(struct snd_kcontrol *kcontrol,
 	val = ucontrol->value.integer.value[0];
 	if (mc->platform_max && val > mc->platform_max)
 		return -EINVAL;
-	if (val > max - min)
+	if (val > max)
 		return -EINVAL;
 	if (val < 0)
 		return -EINVAL;
diff --git a/tools/lib/bpf/ringbuf.c b/tools/lib/bpf/ringbuf.c
index 86c31c787fb9..5e242be45206 100644
--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -59,6 +59,7 @@ int ring_buffer__add(struct ring_buffer *rb, int map_fd,
 	__u32 len = sizeof(info);
 	struct epoll_event *e;
 	struct ring *r;
+	__u64 mmap_sz;
 	void *tmp;
 	int err;
 
@@ -97,8 +98,7 @@ int ring_buffer__add(struct ring_buffer *rb, int map_fd,
 	r->mask = info.max_entries - 1;
 
 	/* Map writable consumer page */
-	tmp = mmap(NULL, rb->page_size, PROT_READ | PROT_WRITE, MAP_SHARED,
-		   map_fd, 0);
+	tmp = mmap(NULL, rb->page_size, PROT_READ | PROT_WRITE, MAP_SHARED, map_fd, 0);
 	if (tmp == MAP_FAILED) {
 		err = -errno;
 		pr_warn("ringbuf: failed to mmap consumer page for map fd=%d: %d\n",
@@ -111,8 +111,12 @@ int ring_buffer__add(struct ring_buffer *rb, int map_fd,
 	 * data size to allow simple reading of samples that wrap around the
 	 * end of a ring buffer. See kernel implementation for details.
 	 * */
-	tmp = mmap(NULL, rb->page_size + 2 * info.max_entries, PROT_READ,
-		   MAP_SHARED, map_fd, rb->page_size);
+	mmap_sz = rb->page_size + 2 * (__u64)info.max_entries;
+	if (mmap_sz != (__u64)(size_t)mmap_sz) {
+		pr_warn("ringbuf: ring buffer size (%u) is too big\n", info.max_entries);
+		return -E2BIG;
+	}
+	tmp = mmap(NULL, (size_t)mmap_sz, PROT_READ, MAP_SHARED, map_fd, rb->page_size);
 	if (tmp == MAP_FAILED) {
 		err = -errno;
 		ringbuf_unmap_ring(rb, r);
diff --git a/tools/testing/selftests/net/fib_nexthops.sh b/tools/testing/selftests/net/fib_nexthops.sh
index 4c7d33618437..7ece4131dc6f 100755
--- a/tools/testing/selftests/net/fib_nexthops.sh
+++ b/tools/testing/selftests/net/fib_nexthops.sh
@@ -931,6 +931,36 @@ ipv4_fcnal()
 	set +e
 	check_nexthop "dev veth1" ""
 	log_test $? 0 "Nexthops removed on admin down"
+
+	# nexthop route delete warning: route add with nhid and delete
+	# using device
+	run_cmd "$IP li set dev veth1 up"
+	run_cmd "$IP nexthop add id 12 via 172.16.1.3 dev veth1"
+	out1=`dmesg | grep "WARNING:.*fib_nh_match.*" | wc -l`
+	run_cmd "$IP route add 172.16.101.1/32 nhid 12"
+	run_cmd "$IP route delete 172.16.101.1/32 dev veth1"
+	out2=`dmesg | grep "WARNING:.*fib_nh_match.*" | wc -l`
+	[ $out1 -eq $out2 ]
+	rc=$?
+	log_test $rc 0 "Delete nexthop route warning"
+	run_cmd "$IP route delete 172.16.101.1/32 nhid 12"
+	run_cmd "$IP nexthop del id 12"
+
+	run_cmd "$IP nexthop add id 21 via 172.16.1.6 dev veth1"
+	run_cmd "$IP ro add 172.16.101.0/24 nhid 21"
+	run_cmd "$IP ro del 172.16.101.0/24 nexthop via 172.16.1.7 dev veth1 nexthop via 172.16.1.8 dev veth1"
+	log_test $? 2 "Delete multipath route with only nh id based entry"
+
+	run_cmd "$IP nexthop add id 22 via 172.16.1.6 dev veth1"
+	run_cmd "$IP ro add 172.16.102.0/24 nhid 22"
+	run_cmd "$IP ro del 172.16.102.0/24 dev veth1"
+	log_test $? 2 "Delete route when specifying only nexthop device"
+
+	run_cmd "$IP ro del 172.16.102.0/24 via 172.16.1.6"
+	log_test $? 2 "Delete route when specifying only gateway"
+
+	run_cmd "$IP ro del 172.16.102.0/24"
+	log_test $? 0 "Delete route when not specifying nexthop attributes"
 }
 
 ipv4_grp_fcnal()
diff --git a/tools/vm/slabinfo-gnuplot.sh b/tools/vm/slabinfo-gnuplot.sh
index 26e193ffd2a2..873a892147e5 100644
--- a/tools/vm/slabinfo-gnuplot.sh
+++ b/tools/vm/slabinfo-gnuplot.sh
@@ -150,7 +150,7 @@ do_preprocess()
 	let lines=3
 	out=`basename "$in"`"-slabs-by-loss"
 	`cat "$in" | grep -A "$lines" 'Slabs sorted by loss' |\
-		egrep -iv '\-\-|Name|Slabs'\
+		grep -E -iv '\-\-|Name|Slabs'\
 		| awk '{print $1" "$4+$2*$3" "$4}' > "$out"`
 	if [ $? -eq 0 ]; then
 		do_slabs_plotting "$out"
@@ -159,7 +159,7 @@ do_preprocess()
 	let lines=3
 	out=`basename "$in"`"-slabs-by-size"
 	`cat "$in" | grep -A "$lines" 'Slabs sorted by size' |\
-		egrep -iv '\-\-|Name|Slabs'\
+		grep -E -iv '\-\-|Name|Slabs'\
 		| awk '{print $1" "$4" "$4-$2*$3}' > "$out"`
 	if [ $? -eq 0 ]; then
 		do_slabs_plotting "$out"
