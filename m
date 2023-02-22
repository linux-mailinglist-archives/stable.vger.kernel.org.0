Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C540F69F42E
	for <lists+stable@lfdr.de>; Wed, 22 Feb 2023 13:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbjBVMQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Feb 2023 07:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbjBVMPw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Feb 2023 07:15:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D32F3866D;
        Wed, 22 Feb 2023 04:15:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 860F56142C;
        Wed, 22 Feb 2023 12:15:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21A2FC4339B;
        Wed, 22 Feb 2023 12:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677068126;
        bh=qIiv2DLaTdsfXSCbXpOC3wHjBTkvqKD6Bka8bv8toWo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DhlTUX3qz2YapGtEl9juChTOcnkDKmbEuyyLplWlVyQKxq3EJwTXo99cJMDRI1+uM
         hBwzne1ygU5biHnVwNMQiMkUaXHe7LPz59G9dxx4mWOcws8pwvrKdbCXfjORrv26Ft
         sOovTTogTqIzCqVnZ+W6HKI7qucJyNFnmdIRC1nE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 6.1.13
Date:   Wed, 22 Feb 2023 13:15:16 +0100
Message-Id: <1677068116141104@kroah.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <1677068116114212@kroah.com>
References: <1677068116114212@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_FILL_THIS_FORM_SHORT,T_PDS_OTHER_BAD_TLD
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 23390805e521..e51356b982f9 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 6
 PATCHLEVEL = 1
-SUBLEVEL = 12
+SUBLEVEL = 13
 EXTRAVERSION =
 NAME = Hurr durr I'ma ninja sloth
 
diff --git a/arch/powerpc/include/asm/hw_irq.h b/arch/powerpc/include/asm/hw_irq.h
index 0b7d01d408ac..eb6d094083fd 100644
--- a/arch/powerpc/include/asm/hw_irq.h
+++ b/arch/powerpc/include/asm/hw_irq.h
@@ -173,6 +173,15 @@ static inline notrace unsigned long irq_soft_mask_or_return(unsigned long mask)
 	return flags;
 }
 
+static inline notrace unsigned long irq_soft_mask_andc_return(unsigned long mask)
+{
+	unsigned long flags = irq_soft_mask_return();
+
+	irq_soft_mask_set(flags & ~mask);
+
+	return flags;
+}
+
 static inline unsigned long arch_local_save_flags(void)
 {
 	return irq_soft_mask_return();
@@ -331,10 +340,11 @@ bool power_pmu_wants_prompt_pmi(void);
  * is a different soft-masked interrupt pending that requires hard
  * masking.
  */
-static inline bool should_hard_irq_enable(void)
+static inline bool should_hard_irq_enable(struct pt_regs *regs)
 {
 	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG)) {
-		WARN_ON(irq_soft_mask_return() == IRQS_ENABLED);
+		WARN_ON(irq_soft_mask_return() != IRQS_ALL_DISABLED);
+		WARN_ON(!(get_paca()->irq_happened & PACA_IRQ_HARD_DIS));
 		WARN_ON(mfmsr() & MSR_EE);
 	}
 
@@ -347,8 +357,17 @@ static inline bool should_hard_irq_enable(void)
 	 *
 	 * TODO: Add test for 64e
 	 */
-	if (IS_ENABLED(CONFIG_PPC_BOOK3S_64) && !power_pmu_wants_prompt_pmi())
-		return false;
+	if (IS_ENABLED(CONFIG_PPC_BOOK3S_64)) {
+		if (!power_pmu_wants_prompt_pmi())
+			return false;
+		/*
+		 * If PMIs are disabled then IRQs should be disabled as well,
+		 * so we shouldn't see this condition, check for it just in
+		 * case because we are about to enable PMIs.
+		 */
+		if (WARN_ON_ONCE(regs->softe & IRQS_PMI_DISABLED))
+			return false;
+	}
 
 	if (get_paca()->irq_happened & PACA_IRQ_MUST_HARD_MASK)
 		return false;
@@ -358,18 +377,16 @@ static inline bool should_hard_irq_enable(void)
 
 /*
  * Do the hard enabling, only call this if should_hard_irq_enable is true.
+ * This allows PMI interrupts to profile irq handlers.
  */
 static inline void do_hard_irq_enable(void)
 {
-	if (IS_ENABLED(CONFIG_PPC_IRQ_SOFT_MASK_DEBUG)) {
-		WARN_ON(irq_soft_mask_return() == IRQS_ENABLED);
-		WARN_ON(get_paca()->irq_happened & PACA_IRQ_MUST_HARD_MASK);
-		WARN_ON(mfmsr() & MSR_EE);
-	}
 	/*
-	 * This allows PMI interrupts (and watchdog soft-NMIs) through.
-	 * There is no other reason to enable this way.
+	 * Asynch interrupts come in with IRQS_ALL_DISABLED,
+	 * PACA_IRQ_HARD_DIS, and MSR[EE]=0.
 	 */
+	if (IS_ENABLED(CONFIG_PPC_BOOK3S_64))
+		irq_soft_mask_andc_return(IRQS_PMI_DISABLED);
 	get_paca()->irq_happened &= ~PACA_IRQ_HARD_DIS;
 	__hard_irq_enable();
 }
@@ -452,7 +469,7 @@ static inline bool arch_irq_disabled_regs(struct pt_regs *regs)
 	return !(regs->msr & MSR_EE);
 }
 
-static __always_inline bool should_hard_irq_enable(void)
+static __always_inline bool should_hard_irq_enable(struct pt_regs *regs)
 {
 	return false;
 }
diff --git a/arch/powerpc/kernel/dbell.c b/arch/powerpc/kernel/dbell.c
index f55c6fb34a3a..5712dd846263 100644
--- a/arch/powerpc/kernel/dbell.c
+++ b/arch/powerpc/kernel/dbell.c
@@ -27,7 +27,7 @@ DEFINE_INTERRUPT_HANDLER_ASYNC(doorbell_exception)
 
 	ppc_msgsync();
 
-	if (should_hard_irq_enable())
+	if (should_hard_irq_enable(regs))
 		do_hard_irq_enable();
 
 	kvmppc_clear_host_ipi(smp_processor_id());
diff --git a/arch/powerpc/kernel/irq.c b/arch/powerpc/kernel/irq.c
index 9ede61a5a469..55142ff649f3 100644
--- a/arch/powerpc/kernel/irq.c
+++ b/arch/powerpc/kernel/irq.c
@@ -238,7 +238,7 @@ static void __do_irq(struct pt_regs *regs, unsigned long oldsp)
 	irq = static_call(ppc_get_irq)();
 
 	/* We can hard enable interrupts now to allow perf interrupts */
-	if (should_hard_irq_enable())
+	if (should_hard_irq_enable(regs))
 		do_hard_irq_enable();
 
 	/* And finally process it */
diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
index a2ab397065c6..f157552d79b3 100644
--- a/arch/powerpc/kernel/time.c
+++ b/arch/powerpc/kernel/time.c
@@ -533,7 +533,7 @@ DEFINE_INTERRUPT_HANDLER_ASYNC(timer_interrupt)
 	}
 
 	/* Conditionally hard-enable interrupts. */
-	if (should_hard_irq_enable()) {
+	if (should_hard_irq_enable(regs)) {
 		/*
 		 * Ensure a positive value is written to the decrementer, or
 		 * else some CPUs will continue to take decrementer exceptions.
diff --git a/arch/s390/boot/decompressor.c b/arch/s390/boot/decompressor.c
index e27c2140d620..623f6775d01d 100644
--- a/arch/s390/boot/decompressor.c
+++ b/arch/s390/boot/decompressor.c
@@ -80,6 +80,6 @@ void *decompress_kernel(void)
 	void *output = (void *)decompress_offset;
 
 	__decompress(_compressed_start, _compressed_end - _compressed_start,
-		     NULL, NULL, output, 0, NULL, error);
+		     NULL, NULL, output, vmlinux.image_size, NULL, error);
 	return output;
 }
diff --git a/arch/x86/events/core.c b/arch/x86/events/core.c
index b30b8bbcd1e2..30fb4931d387 100644
--- a/arch/x86/events/core.c
+++ b/arch/x86/events/core.c
@@ -2994,17 +2994,19 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
 
 void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
 {
-	if (!x86_pmu_initialized()) {
+	/* This API doesn't currently support enumerating hybrid PMUs. */
+	if (WARN_ON_ONCE(cpu_feature_enabled(X86_FEATURE_HYBRID_CPU)) ||
+	    !x86_pmu_initialized()) {
 		memset(cap, 0, sizeof(*cap));
 		return;
 	}
 
-	cap->version		= x86_pmu.version;
 	/*
-	 * KVM doesn't support the hybrid PMU yet.
-	 * Return the common value in global x86_pmu,
-	 * which available for all cores.
+	 * Note, hybrid CPU models get tracked as having hybrid PMUs even when
+	 * all E-cores are disabled via BIOS.  When E-cores are disabled, the
+	 * base PMU holds the correct number of counters for P-cores.
 	 */
+	cap->version		= x86_pmu.version;
 	cap->num_counters_gp	= x86_pmu.num_counters;
 	cap->num_counters_fixed	= x86_pmu.num_counters_fixed;
 	cap->bit_width_gp	= x86_pmu.cntval_bits;
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 5cc5721f260b..c976490b7556 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -164,15 +164,27 @@ static inline void kvm_init_pmu_capability(void)
 {
 	bool is_intel = boot_cpu_data.x86_vendor == X86_VENDOR_INTEL;
 
-	perf_get_x86_pmu_capability(&kvm_pmu_cap);
-
-	 /*
-	  * For Intel, only support guest architectural pmu
-	  * on a host with architectural pmu.
-	  */
-	if ((is_intel && !kvm_pmu_cap.version) || !kvm_pmu_cap.num_counters_gp)
+	/*
+	 * Hybrid PMUs don't play nice with virtualization without careful
+	 * configuration by userspace, and KVM's APIs for reporting supported
+	 * vPMU features do not account for hybrid PMUs.  Disable vPMU support
+	 * for hybrid PMUs until KVM gains a way to let userspace opt-in.
+	 */
+	if (cpu_feature_enabled(X86_FEATURE_HYBRID_CPU))
 		enable_pmu = false;
 
+	if (enable_pmu) {
+		perf_get_x86_pmu_capability(&kvm_pmu_cap);
+
+		/*
+		 * For Intel, only support guest architectural pmu
+		 * on a host with architectural pmu.
+		 */
+		if ((is_intel && !kvm_pmu_cap.version) ||
+		    !kvm_pmu_cap.num_counters_gp)
+			enable_pmu = false;
+	}
+
 	if (!enable_pmu) {
 		memset(&kvm_pmu_cap, 0, sizeof(kvm_pmu_cap));
 		return;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a0c35b948c30..05ca303d7fd9 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5250,12 +5250,11 @@ static void kvm_vcpu_ioctl_x86_get_debugregs(struct kvm_vcpu *vcpu,
 {
 	unsigned long val;
 
+	memset(dbgregs, 0, sizeof(*dbgregs));
 	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
 	kvm_get_dr(vcpu, 6, &val);
 	dbgregs->dr6 = val;
 	dbgregs->dr7 = vcpu->arch.dr7;
-	dbgregs->flags = 0;
-	memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
 }
 
 static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 53ab2306da00..17bb0d8158ca 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -422,6 +422,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(INTEL, 0x34d3), board_ahci_low_power }, /* Ice Lake LP AHCI */
 	{ PCI_VDEVICE(INTEL, 0x02d3), board_ahci_low_power }, /* Comet Lake PCH-U AHCI */
 	{ PCI_VDEVICE(INTEL, 0x02d7), board_ahci_low_power }, /* Comet Lake PCH RAID */
+	{ PCI_VDEVICE(INTEL, 0xa0d3), board_ahci_low_power }, /* Tiger Lake UP{3,4} AHCI */
 
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 26a75f5cce95..a5ea144722fa 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4044,6 +4044,9 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
 	{ "Samsung SSD 870*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM |
 						ATA_HORKAGE_NO_NCQ_ON_ATI },
+	{ "SAMSUNG*MZ7LH*",		NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
+						ATA_HORKAGE_ZERO_AFTER_TRIM |
+						ATA_HORKAGE_NO_NCQ_ON_ATI, },
 	{ "FCCT*M500*",			NULL,	ATA_HORKAGE_NO_NCQ_TRIM |
 						ATA_HORKAGE_ZERO_AFTER_TRIM },
 
diff --git a/drivers/gpio/gpio-sim.c b/drivers/gpio/gpio-sim.c
index 1020c2feb249..cff68f31a09f 100644
--- a/drivers/gpio/gpio-sim.c
+++ b/drivers/gpio/gpio-sim.c
@@ -732,7 +732,7 @@ static void gpio_sim_remove_hogs(struct gpio_sim_device *dev)
 
 	gpiod_remove_hogs(dev->hogs);
 
-	for (hog = dev->hogs; !hog->chip_label; hog++) {
+	for (hog = dev->hogs; hog->chip_label; hog++) {
 		kfree(hog->chip_label);
 		kfree(hog->line_name);
 	}
diff --git a/drivers/gpu/drm/Kconfig b/drivers/gpu/drm/Kconfig
index 34f5a092c99e..f30f99166531 100644
--- a/drivers/gpu/drm/Kconfig
+++ b/drivers/gpu/drm/Kconfig
@@ -53,7 +53,8 @@ config DRM_DEBUG_MM
 
 config DRM_USE_DYNAMIC_DEBUG
 	bool "use dynamic debug to implement drm.debug"
-	default y
+	default n
+	depends on BROKEN
 	depends on DRM
 	depends on DYNAMIC_DEBUG || DYNAMIC_DEBUG_CORE
 	depends on JUMP_LABEL
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 8f83d5b6ceaa..a21b3f66fd70 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -4248,6 +4248,9 @@ int amdgpu_device_resume(struct drm_device *dev, bool fbcon)
 #endif
 	adev->in_suspend = false;
 
+	if (adev->enable_mes)
+		amdgpu_mes_self_test(adev);
+
 	if (amdgpu_acpi_smart_shift_update(dev, AMDGPU_SS_DEV_D0))
 		DRM_WARN("smart shift update failed\n");
 
diff --git a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
index 32b0ea8757fa..6f0e389be5f6 100644
--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -1339,7 +1339,7 @@ static int mes_v11_0_late_init(void *handle)
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
 	/* it's only intended for use in mes_self_test case, not for s0ix and reset */
-	if (!amdgpu_in_reset(adev) && !adev->in_s0ix &&
+	if (!amdgpu_in_reset(adev) && !adev->in_s0ix && !adev->in_suspend &&
 	    (adev->ip_versions[GC_HWIP][0] != IP_VERSION(11, 0, 3)))
 		amdgpu_mes_self_test(adev);
 
diff --git a/drivers/gpu/drm/amd/amdgpu/soc21.c b/drivers/gpu/drm/amd/amdgpu/soc21.c
index 9bc9852b9cda..230e15fed755 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc21.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc21.c
@@ -643,7 +643,8 @@ static int soc21_common_early_init(void *handle)
 			AMD_CG_SUPPORT_GFX_CGCG |
 			AMD_CG_SUPPORT_GFX_CGLS |
 			AMD_CG_SUPPORT_REPEATER_FGCG |
-			AMD_CG_SUPPORT_GFX_MGCG;
+			AMD_CG_SUPPORT_GFX_MGCG |
+			AMD_CG_SUPPORT_HDP_SD;
 		adev->pg_flags = AMD_PG_SUPPORT_VCN |
 			AMD_PG_SUPPORT_VCN_DPG |
 			AMD_PG_SUPPORT_JPEG;
diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index 988b1c947aef..e9c4f22696c5 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4526,6 +4526,17 @@ DEVICE_ATTR_WO(s3_debug);
 static int dm_early_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
+	struct amdgpu_mode_info *mode_info = &adev->mode_info;
+	struct atom_context *ctx = mode_info->atom_context;
+	int index = GetIndexIntoMasterTable(DATA, Object_Header);
+	u16 data_offset;
+
+	/* if there is no object header, skip DM */
+	if (!amdgpu_atom_parse_data_header(ctx, index, NULL, NULL, NULL, &data_offset)) {
+		adev->harvest_ip_mask |= AMD_HARVEST_IP_DMU_MASK;
+		dev_info(adev->dev, "No object header, skipping DM\n");
+		return -ENOENT;
+	}
 
 	switch (adev->asic_type) {
 #if defined(CONFIG_DRM_AMD_DC_SI)
@@ -9545,7 +9556,11 @@ static int amdgpu_dm_atomic_check(struct drm_device *dev,
 	 * `dcn10_can_pipe_disable_cursor`). By now, all modified planes are in
 	 * atomic state, so call drm helper to normalize zpos.
 	 */
-	drm_atomic_normalize_zpos(dev, state);
+	ret = drm_atomic_normalize_zpos(dev, state);
+	if (ret) {
+		drm_dbg(dev, "drm_atomic_normalize_zpos() failed\n");
+		goto fail;
+	}
 
 	/* Remove exiting planes if they are modified */
 	for_each_oldnew_plane_in_state_reverse(state, plane, old_plane_state, new_plane_state, i) {
diff --git a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
index 9066c511a052..c80c8c8f51e9 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_resource.c
@@ -871,8 +871,9 @@ static const struct dc_plane_cap plane_cap = {
 	},
 
 	// 6:1 downscaling ratio: 1000/6 = 166.666
+	// 4:1 downscaling ratio for ARGB888 to prevent underflow during P010 playback: 1000/4 = 250
 	.max_downscale_factor = {
-			.argb8888 = 167,
+			.argb8888 = 250,
 			.nv12 = 167,
 			.fp16 = 167
 	},
@@ -1755,7 +1756,7 @@ static bool dcn314_resource_construct(
 	pool->base.underlay_pipe_index = NO_UNDERLAY_PIPE;
 	pool->base.pipe_count = pool->base.res_cap->num_timing_generator;
 	pool->base.mpcc_count = pool->base.res_cap->num_timing_generator;
-	dc->caps.max_downscale_ratio = 600;
+	dc->caps.max_downscale_ratio = 400;
 	dc->caps.i2c_speed_in_khz = 100;
 	dc->caps.i2c_speed_in_khz_hdcp = 100;
 	dc->caps.max_cursor_size = 256;
diff --git a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_init.c b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_init.c
index 45a949ba6f3f..7b7f0e6b2a2f 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_init.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_init.c
@@ -94,7 +94,7 @@ static const struct hw_sequencer_funcs dcn32_funcs = {
 	.get_vupdate_offset_from_vsync = dcn10_get_vupdate_offset_from_vsync,
 	.calc_vupdate_position = dcn10_calc_vupdate_position,
 	.apply_idle_power_optimizations = dcn32_apply_idle_power_optimizations,
-	.does_plane_fit_in_mall = dcn30_does_plane_fit_in_mall,
+	.does_plane_fit_in_mall = NULL,
 	.set_backlight_level = dcn21_set_backlight_level,
 	.set_abm_immediate_disable = dcn21_set_abm_immediate_disable,
 	.hardware_release = dcn30_hardware_release,
diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c b/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
index 0d12fd079cd6..3afd3c80e6da 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn314/display_mode_vba_314.c
@@ -3184,7 +3184,7 @@ static void DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerforman
 		} else {
 			v->MIN_DST_Y_NEXT_START[k] = v->VTotal[k] - v->VFrontPorch[k] + v->VTotal[k] - v->VActive[k] - v->VStartup[k];
 		}
-		v->MIN_DST_Y_NEXT_START[k] += dml_floor(4.0 * v->TSetup[k] / (double)v->HTotal[k] / v->PixelClock[k], 1.0) / 4.0;
+		v->MIN_DST_Y_NEXT_START[k] += dml_floor(4.0 * v->TSetup[k] / ((double)v->HTotal[k] / v->PixelClock[k]), 1.0) / 4.0;
 		if (((v->VUpdateOffsetPix[k] + v->VUpdateWidthPix[k] + v->VReadyOffsetPix[k]) / v->HTotal[k])
 				<= (isInterlaceTiming ?
 						dml_floor((v->VTotal[k] - v->VActive[k] - v->VFrontPorch[k] - v->VStartup[k]) / 2.0, 1.0) :
diff --git a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
index 4a122925c3ae..92c18bfb98b3 100644
--- a/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dmub/src/dmub_srv.c
@@ -532,6 +532,9 @@ enum dmub_status dmub_srv_hw_init(struct dmub_srv *dmub,
 	if (dmub->hw_funcs.reset)
 		dmub->hw_funcs.reset(dmub);
 
+	/* reset the cache of the last wptr as well now that hw is reset */
+	dmub->inbox1_last_wptr = 0;
+
 	cw0.offset.quad_part = inst_fb->gpu_addr;
 	cw0.region.base = DMUB_CW0_BASE;
 	cw0.region.top = cw0.region.base + inst_fb->size - 1;
@@ -649,6 +652,15 @@ enum dmub_status dmub_srv_hw_reset(struct dmub_srv *dmub)
 	if (dmub->hw_funcs.reset)
 		dmub->hw_funcs.reset(dmub);
 
+	/* mailboxes have been reset in hw, so reset the sw state as well */
+	dmub->inbox1_last_wptr = 0;
+	dmub->inbox1_rb.wrpt = 0;
+	dmub->inbox1_rb.rptr = 0;
+	dmub->outbox0_rb.wrpt = 0;
+	dmub->outbox0_rb.rptr = 0;
+	dmub->outbox1_rb.wrpt = 0;
+	dmub->outbox1_rb.rptr = 0;
+
 	dmub->hw_init = false;
 
 	return DMUB_STATUS_OK;
diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index 41635694e521..2f3e239e623d 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -2009,14 +2009,16 @@ static int default_attr_update(struct amdgpu_device *adev, struct amdgpu_device_
 		      gc_ver == IP_VERSION(10, 3, 0) ||
 		      gc_ver == IP_VERSION(10, 1, 2) ||
 		      gc_ver == IP_VERSION(11, 0, 0) ||
-		      gc_ver == IP_VERSION(11, 0, 2)))
+		      gc_ver == IP_VERSION(11, 0, 2) ||
+		      gc_ver == IP_VERSION(11, 0, 3)))
 			*states = ATTR_STATE_UNSUPPORTED;
 	} else if (DEVICE_ATTR_IS(pp_dpm_dclk)) {
 		if (!(gc_ver == IP_VERSION(10, 3, 1) ||
 		      gc_ver == IP_VERSION(10, 3, 0) ||
 		      gc_ver == IP_VERSION(10, 1, 2) ||
 		      gc_ver == IP_VERSION(11, 0, 0) ||
-		      gc_ver == IP_VERSION(11, 0, 2)))
+		      gc_ver == IP_VERSION(11, 0, 2) ||
+		      gc_ver == IP_VERSION(11, 0, 3)))
 			*states = ATTR_STATE_UNSUPPORTED;
 	} else if (DEVICE_ATTR_IS(pp_power_profile_mode)) {
 		if (amdgpu_dpm_get_power_profile_mode(adev, NULL) == -EOPNOTSUPP)
diff --git a/drivers/gpu/drm/i915/gt/intel_workarounds.c b/drivers/gpu/drm/i915/gt/intel_workarounds.c
index a821e3d405db..86621dff868d 100644
--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1249,6 +1249,13 @@ icl_gt_workarounds_init(struct intel_gt *gt, struct i915_wa_list *wal)
 		    GAMT_CHKN_BIT_REG,
 		    GAMT_CHKN_DISABLE_L3_COH_PIPE);
 
+	/*
+	 * Wa_1408615072:icl,ehl  (vsunit)
+	 * Wa_1407596294:icl,ehl  (hsunit)
+	 */
+	wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE,
+		    VSUNIT_CLKGATE_DIS | HSUNIT_CLKGATE_DIS);
+
 	/* Wa_1407352427:icl,ehl */
 	wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE2,
 		    PSDUNIT_CLKGATE_DIS);
@@ -2368,13 +2375,6 @@ rcs_engine_wa_init(struct intel_engine_cs *engine, struct i915_wa_list *wal)
 		wa_masked_en(wal, GEN9_CSFE_CHICKEN1_RCS,
 			     GEN11_ENABLE_32_PLANE_MODE);
 
-		/*
-		 * Wa_1408615072:icl,ehl  (vsunit)
-		 * Wa_1407596294:icl,ehl  (hsunit)
-		 */
-		wa_write_or(wal, UNSLICE_UNIT_LEVEL_CLKGATE,
-			    VSUNIT_CLKGATE_DIS | HSUNIT_CLKGATE_DIS);
-
 		/*
 		 * Wa_1408767742:icl[a2..forever],ehl[all]
 		 * Wa_1605460711:icl[a0..c0]
diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/tu102.c b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/tu102.c
index 634f64f88fc8..81a1ad2c88a7 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/tu102.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/tu102.c
@@ -65,10 +65,33 @@ tu102_devinit_pll_set(struct nvkm_devinit *init, u32 type, u32 freq)
 	return ret;
 }
 
+static int
+tu102_devinit_wait(struct nvkm_device *device)
+{
+	unsigned timeout = 50 + 2000;
+
+	do {
+		if (nvkm_rd32(device, 0x118128) & 0x00000001) {
+			if ((nvkm_rd32(device, 0x118234) & 0x000000ff) == 0xff)
+				return 0;
+		}
+
+		usleep_range(1000, 2000);
+	} while (timeout--);
+
+	return -ETIMEDOUT;
+}
+
 int
 tu102_devinit_post(struct nvkm_devinit *base, bool post)
 {
 	struct nv50_devinit *init = nv50_devinit(base);
+	int ret;
+
+	ret = tu102_devinit_wait(init->base.subdev.device);
+	if (ret)
+		return ret;
+
 	gm200_devinit_preos(init, post);
 	return 0;
 }
diff --git a/drivers/gpu/drm/vc4/vc4_crtc.c b/drivers/gpu/drm/vc4/vc4_crtc.c
index 0108613e79d5..7258975331ca 100644
--- a/drivers/gpu/drm/vc4/vc4_crtc.c
+++ b/drivers/gpu/drm/vc4/vc4_crtc.c
@@ -711,7 +711,7 @@ static int vc4_crtc_atomic_check(struct drm_crtc *crtc,
 		struct vc4_encoder *vc4_encoder = to_vc4_encoder(encoder);
 
 		if (vc4_encoder->type == VC4_ENCODER_TYPE_HDMI0) {
-			vc4_state->hvs_load = max(mode->clock * mode->hdisplay / mode->htotal + 1000,
+			vc4_state->hvs_load = max(mode->clock * mode->hdisplay / mode->htotal + 8000,
 						  mode->clock * 9 / 10) * 1000;
 		} else {
 			vc4_state->hvs_load = mode->clock * 1000;
diff --git a/drivers/gpu/drm/vc4/vc4_plane.c b/drivers/gpu/drm/vc4/vc4_plane.c
index 8b92a45a3c89..bd5acc4a8687 100644
--- a/drivers/gpu/drm/vc4/vc4_plane.c
+++ b/drivers/gpu/drm/vc4/vc4_plane.c
@@ -340,7 +340,7 @@ static int vc4_plane_setup_clipping_and_scaling(struct drm_plane_state *state)
 {
 	struct vc4_plane_state *vc4_state = to_vc4_plane_state(state);
 	struct drm_framebuffer *fb = state->fb;
-	struct drm_gem_dma_object *bo = drm_fb_dma_get_gem_obj(fb, 0);
+	struct drm_gem_dma_object *bo;
 	int num_planes = fb->format->num_planes;
 	struct drm_crtc_state *crtc_state;
 	u32 h_subsample = fb->format->hsub;
@@ -359,8 +359,10 @@ static int vc4_plane_setup_clipping_and_scaling(struct drm_plane_state *state)
 	if (ret)
 		return ret;
 
-	for (i = 0; i < num_planes; i++)
+	for (i = 0; i < num_planes; i++) {
+		bo = drm_fb_dma_get_gem_obj(fb, i);
 		vc4_state->offsets[i] = bo->dma_addr + fb->offsets[i];
+	}
 
 	/*
 	 * We don't support subpixel source positioning for scaling,
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
index 973a0a52462e..ae01d22b8f84 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_bo.c
@@ -462,6 +462,9 @@ int vmw_bo_create(struct vmw_private *vmw,
 		return -ENOMEM;
 	}
 
+	/*
+	 * vmw_bo_init will delete the *p_bo object if it fails
+	 */
 	ret = vmw_bo_init(vmw, *p_bo, size,
 			  placement, interruptible, pin,
 			  bo_free);
@@ -470,7 +473,6 @@ int vmw_bo_create(struct vmw_private *vmw,
 
 	return ret;
 out_error:
-	kfree(*p_bo);
 	*p_bo = NULL;
 	return ret;
 }
@@ -596,6 +598,7 @@ static int vmw_user_bo_synccpu_release(struct drm_file *filp,
 		ttm_bo_put(&vmw_bo->base);
 	}
 
+	drm_gem_object_put(&vmw_bo->base.base);
 	return ret;
 }
 
@@ -636,6 +639,7 @@ int vmw_user_bo_synccpu_ioctl(struct drm_device *dev, void *data,
 
 		ret = vmw_user_bo_synccpu_grab(vbo, arg->flags);
 		vmw_bo_unreference(&vbo);
+		drm_gem_object_put(&vbo->base.base);
 		if (unlikely(ret != 0)) {
 			if (ret == -ERESTARTSYS || ret == -EBUSY)
 				return -EBUSY;
@@ -693,7 +697,7 @@ int vmw_bo_unref_ioctl(struct drm_device *dev, void *data,
  * struct vmw_buffer_object should be placed.
  * Return: Zero on success, Negative error code on error.
  *
- * The vmw buffer object pointer will be refcounted.
+ * The vmw buffer object pointer will be refcounted (both ttm and gem)
  */
 int vmw_user_bo_lookup(struct drm_file *filp,
 		       uint32_t handle,
@@ -710,7 +714,6 @@ int vmw_user_bo_lookup(struct drm_file *filp,
 
 	*out = gem_to_vmw_bo(gobj);
 	ttm_bo_get(&(*out)->base);
-	drm_gem_object_put(gobj);
 
 	return 0;
 }
@@ -777,7 +780,8 @@ int vmw_dumb_create(struct drm_file *file_priv,
 	ret = vmw_gem_object_create_with_handle(dev_priv, file_priv,
 						args->size, &args->handle,
 						&vbo);
-
+	/* drop reference from allocate - handle holds it now */
+	drm_gem_object_put(&vbo->base.base);
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 70cfed4fdba0..1c88b74d68cf 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1160,6 +1160,7 @@ static int vmw_translate_mob_ptr(struct vmw_private *dev_priv,
 	}
 	ret = vmw_validation_add_bo(sw_context->ctx, vmw_bo, true, false);
 	ttm_bo_put(&vmw_bo->base);
+	drm_gem_object_put(&vmw_bo->base.base);
 	if (unlikely(ret != 0))
 		return ret;
 
@@ -1214,6 +1215,7 @@ static int vmw_translate_guest_ptr(struct vmw_private *dev_priv,
 	}
 	ret = vmw_validation_add_bo(sw_context->ctx, vmw_bo, false, false);
 	ttm_bo_put(&vmw_bo->base);
+	drm_gem_object_put(&vmw_bo->base.base);
 	if (unlikely(ret != 0))
 		return ret;
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
index ce609e7d758f..4d2c28e39f4e 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_gem.c
@@ -146,14 +146,12 @@ int vmw_gem_object_create_with_handle(struct vmw_private *dev_priv,
 				    &vmw_sys_placement :
 				    &vmw_vram_sys_placement,
 			    true, false, &vmw_gem_destroy, p_vbo);
-
-	(*p_vbo)->base.base.funcs = &vmw_gem_object_funcs;
 	if (ret != 0)
 		goto out_no_bo;
 
+	(*p_vbo)->base.base.funcs = &vmw_gem_object_funcs;
+
 	ret = drm_gem_handle_create(filp, &(*p_vbo)->base.base, handle);
-	/* drop reference from allocate - handle holds it now */
-	drm_gem_object_put(&(*p_vbo)->base.base);
 out_no_bo:
 	return ret;
 }
@@ -180,6 +178,8 @@ int vmw_gem_object_create_ioctl(struct drm_device *dev, void *data,
 	rep->map_handle = drm_vma_node_offset_addr(&vbo->base.base.vma_node);
 	rep->cur_gmr_id = handle;
 	rep->cur_gmr_offset = 0;
+	/* drop reference from allocate - handle holds it now */
+	drm_gem_object_put(&vbo->base.base);
 out_no_bo:
 	return ret;
 }
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
index 7a2f262414ad..13721bcf047c 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
@@ -1669,8 +1669,10 @@ static struct drm_framebuffer *vmw_kms_fb_create(struct drm_device *dev,
 
 err_out:
 	/* vmw_user_lookup_handle takes one ref so does new_fb */
-	if (bo)
+	if (bo) {
 		vmw_bo_unreference(&bo);
+		drm_gem_object_put(&bo->base.base);
+	}
 	if (surface)
 		vmw_surface_unreference(&surface);
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
index e9f5c89b4ca6..b5b311f2a91a 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_overlay.c
@@ -458,6 +458,7 @@ int vmw_overlay_ioctl(struct drm_device *dev, void *data,
 	ret = vmw_overlay_update_stream(dev_priv, buf, arg, true);
 
 	vmw_bo_unreference(&buf);
+	drm_gem_object_put(&buf->base.base);
 
 out_unlock:
 	mutex_unlock(&overlay->mutex);
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
index 108a496b5d18..51e83dfa1cac 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_shader.c
@@ -807,6 +807,7 @@ static int vmw_shader_define(struct drm_device *dev, struct drm_file *file_priv,
 				    num_output_sig, tfile, shader_handle);
 out_bad_arg:
 	vmw_bo_unreference(&buffer);
+	drm_gem_object_put(&buffer->base.base);
 	return ret;
 }
 
diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
index ace7ca150b03..591c301e6cf2 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_surface.c
@@ -683,7 +683,7 @@ static void vmw_user_surface_base_release(struct ttm_base_object **p_base)
 	    container_of(base, struct vmw_user_surface, prime.base);
 	struct vmw_resource *res = &user_srf->srf.res;
 
-	if (base->shareable && res && res->backup)
+	if (res && res->backup)
 		drm_gem_object_put(&res->backup->base.base);
 
 	*p_base = NULL;
@@ -860,7 +860,11 @@ int vmw_surface_define_ioctl(struct drm_device *dev, void *data,
 			goto out_unlock;
 		}
 		vmw_bo_reference(res->backup);
-		drm_gem_object_get(&res->backup->base.base);
+		/*
+		 * We don't expose the handle to the userspace and surface
+		 * already holds a gem reference
+		 */
+		drm_gem_handle_delete(file_priv, backup_handle);
 	}
 
 	tmp = vmw_resource_reference(&srf->res);
@@ -1564,8 +1568,6 @@ vmw_gb_surface_define_internal(struct drm_device *dev,
 			drm_vma_node_offset_addr(&res->backup->base.base.vma_node);
 		rep->buffer_size = res->backup->base.base.size;
 		rep->buffer_handle = backup_handle;
-		if (user_srf->prime.base.shareable)
-			drm_gem_object_get(&res->backup->base.base);
 	} else {
 		rep->buffer_map_handle = 0;
 		rep->buffer_size = 0;
diff --git a/drivers/mmc/core/sdio_bus.c b/drivers/mmc/core/sdio_bus.c
index babf21a0adeb..f191a2a76f3b 100644
--- a/drivers/mmc/core/sdio_bus.c
+++ b/drivers/mmc/core/sdio_bus.c
@@ -294,6 +294,12 @@ static void sdio_release_func(struct device *dev)
 	if (!(func->card->quirks & MMC_QUIRK_NONSTD_SDIO))
 		sdio_free_func_cis(func);
 
+	/*
+	 * We have now removed the link to the tuples in the
+	 * card structure, so remove the reference.
+	 */
+	put_device(&func->card->dev);
+
 	kfree(func->info);
 	kfree(func->tmpbuf);
 	kfree(func);
@@ -324,6 +330,12 @@ struct sdio_func *sdio_alloc_func(struct mmc_card *card)
 
 	device_initialize(&func->dev);
 
+	/*
+	 * We may link to tuples in the card structure,
+	 * we need make sure we have a reference to it.
+	 */
+	get_device(&func->card->dev);
+
 	func->dev.parent = &card->dev;
 	func->dev.bus = &sdio_bus_type;
 	func->dev.release = sdio_release_func;
@@ -377,10 +389,9 @@ int sdio_add_func(struct sdio_func *func)
  */
 void sdio_remove_func(struct sdio_func *func)
 {
-	if (!sdio_func_present(func))
-		return;
+	if (sdio_func_present(func))
+		device_del(&func->dev);
 
-	device_del(&func->dev);
 	of_node_put(func->dev.of_node);
 	put_device(&func->dev);
 }
diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index a705ba6eff5b..afaa6cab1adc 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -403,12 +403,6 @@ int sdio_read_func_cis(struct sdio_func *func)
 	if (ret)
 		return ret;
 
-	/*
-	 * Since we've linked to tuples in the card structure,
-	 * we must make sure we have a reference to it.
-	 */
-	get_device(&func->card->dev);
-
 	/*
 	 * Vendor/device id is optional for function CIS, so
 	 * copy it from the card structure as needed.
@@ -434,11 +428,5 @@ void sdio_free_func_cis(struct sdio_func *func)
 	}
 
 	func->tuples = NULL;
-
-	/*
-	 * We have now removed the link to the tuples in the
-	 * card structure, so remove the reference.
-	 */
-	put_device(&func->card->dev);
 }
 
diff --git a/drivers/mmc/host/jz4740_mmc.c b/drivers/mmc/host/jz4740_mmc.c
index dc2db9c185ea..eda1e2ddcaca 100644
--- a/drivers/mmc/host/jz4740_mmc.c
+++ b/drivers/mmc/host/jz4740_mmc.c
@@ -1053,6 +1053,16 @@ static int jz4740_mmc_probe(struct platform_device* pdev)
 	mmc->ops = &jz4740_mmc_ops;
 	if (!mmc->f_max)
 		mmc->f_max = JZ_MMC_CLK_RATE;
+
+	/*
+	 * There seems to be a problem with this driver on the JZ4760 and
+	 * JZ4760B SoCs. There, when using the maximum rate supported (50 MHz),
+	 * the communication fails with many SD cards.
+	 * Until this bug is sorted out, limit the maximum rate to 24 MHz.
+	 */
+	if (host->version == JZ_MMC_JZ4760 && mmc->f_max > JZ_MMC_CLK_RATE)
+		mmc->f_max = JZ_MMC_CLK_RATE;
+
 	mmc->f_min = mmc->f_max / 128;
 	mmc->ocr_avail = MMC_VDD_32_33 | MMC_VDD_33_34;
 
diff --git a/drivers/mmc/host/meson-gx-mmc.c b/drivers/mmc/host/meson-gx-mmc.c
index 6e5ea0213b47..5c94ad4661ce 100644
--- a/drivers/mmc/host/meson-gx-mmc.c
+++ b/drivers/mmc/host/meson-gx-mmc.c
@@ -435,7 +435,8 @@ static int meson_mmc_clk_init(struct meson_host *host)
 	clk_reg |= FIELD_PREP(CLK_CORE_PHASE_MASK, CLK_PHASE_180);
 	clk_reg |= FIELD_PREP(CLK_TX_PHASE_MASK, CLK_PHASE_0);
 	clk_reg |= FIELD_PREP(CLK_RX_PHASE_MASK, CLK_PHASE_0);
-	clk_reg |= CLK_IRQ_SDIO_SLEEP(host);
+	if (host->mmc->caps & MMC_CAP_SDIO_IRQ)
+		clk_reg |= CLK_IRQ_SDIO_SLEEP(host);
 	writel(clk_reg, host->regs + SD_EMMC_CLOCK);
 
 	/* get the mux parents */
@@ -948,16 +949,18 @@ static irqreturn_t meson_mmc_irq(int irq, void *dev_id)
 {
 	struct meson_host *host = dev_id;
 	struct mmc_command *cmd;
-	u32 status, raw_status;
+	u32 status, raw_status, irq_mask = IRQ_EN_MASK;
 	irqreturn_t ret = IRQ_NONE;
 
+	if (host->mmc->caps & MMC_CAP_SDIO_IRQ)
+		irq_mask |= IRQ_SDIO;
 	raw_status = readl(host->regs + SD_EMMC_STATUS);
-	status = raw_status & (IRQ_EN_MASK | IRQ_SDIO);
+	status = raw_status & irq_mask;
 
 	if (!status) {
 		dev_dbg(host->dev,
-			"Unexpected IRQ! irq_en 0x%08lx - status 0x%08x\n",
-			 IRQ_EN_MASK | IRQ_SDIO, raw_status);
+			"Unexpected IRQ! irq_en 0x%08x - status 0x%08x\n",
+			 irq_mask, raw_status);
 		return IRQ_NONE;
 	}
 
@@ -1204,6 +1207,11 @@ static int meson_mmc_probe(struct platform_device *pdev)
 		goto free_host;
 	}
 
+	mmc->caps |= MMC_CAP_CMD23;
+
+	if (mmc->caps & MMC_CAP_SDIO_IRQ)
+		mmc->caps2 |= MMC_CAP2_SDIO_IRQ_NOTHREAD;
+
 	host->data = (struct meson_mmc_data *)
 		of_device_get_match_data(&pdev->dev);
 	if (!host->data) {
@@ -1277,11 +1285,6 @@ static int meson_mmc_probe(struct platform_device *pdev)
 
 	spin_lock_init(&host->lock);
 
-	mmc->caps |= MMC_CAP_CMD23;
-
-	if (mmc->caps & MMC_CAP_SDIO_IRQ)
-		mmc->caps2 |= MMC_CAP2_SDIO_IRQ_NOTHREAD;
-
 	if (host->dram_access_quirk) {
 		/* Limit segments to 1 due to low available sram memory */
 		mmc->max_segs = 1;
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 106dd204b1a7..cc333ad67cac 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -1437,7 +1437,7 @@ static int mmc_spi_probe(struct spi_device *spi)
 
 	status = mmc_add_host(mmc);
 	if (status != 0)
-		goto fail_add_host;
+		goto fail_glue_init;
 
 	/*
 	 * Index 0 is card detect
@@ -1445,7 +1445,7 @@ static int mmc_spi_probe(struct spi_device *spi)
 	 */
 	status = mmc_gpiod_request_cd(mmc, NULL, 0, false, 1000);
 	if (status == -EPROBE_DEFER)
-		goto fail_add_host;
+		goto fail_gpiod_request;
 	if (!status) {
 		/*
 		 * The platform has a CD GPIO signal that may support
@@ -1460,7 +1460,7 @@ static int mmc_spi_probe(struct spi_device *spi)
 	/* Index 1 is write protect/read only */
 	status = mmc_gpiod_request_ro(mmc, NULL, 1, 0);
 	if (status == -EPROBE_DEFER)
-		goto fail_add_host;
+		goto fail_gpiod_request;
 	if (!status)
 		has_ro = true;
 
@@ -1474,7 +1474,7 @@ static int mmc_spi_probe(struct spi_device *spi)
 				? ", cd polling" : "");
 	return 0;
 
-fail_add_host:
+fail_gpiod_request:
 	mmc_remove_host(mmc);
 fail_glue_init:
 	mmc_spi_dma_free(host);
diff --git a/drivers/net/ethernet/broadcom/bgmac-bcma.c b/drivers/net/ethernet/broadcom/bgmac-bcma.c
index 02bd3cf9a260..6e4f36aaf5db 100644
--- a/drivers/net/ethernet/broadcom/bgmac-bcma.c
+++ b/drivers/net/ethernet/broadcom/bgmac-bcma.c
@@ -240,12 +240,12 @@ static int bgmac_probe(struct bcma_device *core)
 		bgmac->feature_flags |= BGMAC_FEAT_CLKCTLST;
 		bgmac->feature_flags |= BGMAC_FEAT_FLW_CTRL1;
 		bgmac->feature_flags |= BGMAC_FEAT_SW_TYPE_PHY;
-		if (ci->pkg == BCMA_PKG_ID_BCM47188 ||
-		    ci->pkg == BCMA_PKG_ID_BCM47186) {
+		if ((ci->id == BCMA_CHIP_ID_BCM5357 && ci->pkg == BCMA_PKG_ID_BCM47186) ||
+		    (ci->id == BCMA_CHIP_ID_BCM53572 && ci->pkg == BCMA_PKG_ID_BCM47188)) {
 			bgmac->feature_flags |= BGMAC_FEAT_SW_TYPE_RGMII;
 			bgmac->feature_flags |= BGMAC_FEAT_IOST_ATTACHED;
 		}
-		if (ci->pkg == BCMA_PKG_ID_BCM5358)
+		if (ci->id == BCMA_CHIP_ID_BCM5357 && ci->pkg == BCMA_PKG_ID_BCM5358)
 			bgmac->feature_flags |= BGMAC_FEAT_SW_TYPE_EPHYRMII;
 		break;
 	case BCMA_CHIP_ID_BCM53573:
diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index edca16b5f9e3..cecda545372f 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -9239,10 +9239,14 @@ int bnxt_reserve_rings(struct bnxt *bp, bool irq_re_init)
 		netdev_err(bp->dev, "ring reservation/IRQ init failure rc: %d\n", rc);
 		return rc;
 	}
-	if (tcs && (bp->tx_nr_rings_per_tc * tcs != bp->tx_nr_rings)) {
+	if (tcs && (bp->tx_nr_rings_per_tc * tcs !=
+		    bp->tx_nr_rings - bp->tx_nr_rings_xdp)) {
 		netdev_err(bp->dev, "tx ring reservation failure\n");
 		netdev_reset_tc(bp->dev);
-		bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
+		if (bp->tx_nr_rings_xdp)
+			bp->tx_nr_rings_per_tc = bp->tx_nr_rings_xdp;
+		else
+			bp->tx_nr_rings_per_tc = bp->tx_nr_rings;
 		return -ENOMEM;
 	}
 	return 0;
diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index e6e349f0c945..d30bc38725e9 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -2921,7 +2921,7 @@ static int i40e_change_mtu(struct net_device *netdev, int new_mtu)
 	struct i40e_pf *pf = vsi->back;
 
 	if (i40e_enabled_xdp_vsi(vsi)) {
-		int frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN + VLAN_HLEN;
+		int frame_size = new_mtu + I40E_PACKET_HDR_PAD;
 
 		if (frame_size > i40e_max_xdp_frame_size(vsi))
 			return -EINVAL;
@@ -13140,6 +13140,8 @@ static int i40e_ndo_bridge_setlink(struct net_device *dev,
 	}
 
 	br_spec = nlmsg_find_attr(nlh, sizeof(struct ifinfomsg), IFLA_AF_SPEC);
+	if (!br_spec)
+		return -EINVAL;
 
 	nla_for_each_nested(attr, br_spec, rem) {
 		__u16 mode;
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 333582dabba1..72f97bb50b09 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -270,6 +270,8 @@ static int ice_set_promisc(struct ice_vsi *vsi, u8 promisc_m)
 	if (status && status != -EEXIST)
 		return status;
 
+	netdev_dbg(vsi->netdev, "set promisc filter bits for VSI %i: 0x%x\n",
+		   vsi->vsi_num, promisc_m);
 	return 0;
 }
 
@@ -295,6 +297,8 @@ static int ice_clear_promisc(struct ice_vsi *vsi, u8 promisc_m)
 						    promisc_m, 0);
 	}
 
+	netdev_dbg(vsi->netdev, "clear promisc filter bits for VSI %i: 0x%x\n",
+		   vsi->vsi_num, promisc_m);
 	return status;
 }
 
@@ -423,6 +427,16 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 				}
 				err = 0;
 				vlan_ops->dis_rx_filtering(vsi);
+
+				/* promiscuous mode implies allmulticast so
+				 * that VSIs that are in promiscuous mode are
+				 * subscribed to multicast packets coming to
+				 * the port
+				 */
+				err = ice_set_promisc(vsi,
+						      ICE_MCAST_PROMISC_BITS);
+				if (err)
+					goto out_promisc;
 			}
 		} else {
 			/* Clear Rx filter to remove traffic from wire */
@@ -439,6 +453,18 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
 				    NETIF_F_HW_VLAN_CTAG_FILTER)
 					vlan_ops->ena_rx_filtering(vsi);
 			}
+
+			/* disable allmulti here, but only if allmulti is not
+			 * still enabled for the netdev
+			 */
+			if (!(vsi->current_netdev_flags & IFF_ALLMULTI)) {
+				err = ice_clear_promisc(vsi,
+							ICE_MCAST_PROMISC_BITS);
+				if (err) {
+					netdev_err(netdev, "Error %d clearing multicast promiscuous on VSI %i\n",
+						   err, vsi->vsi_num);
+				}
+			}
 		}
 	}
 	goto exit;
diff --git a/drivers/net/ethernet/intel/ice/ice_xsk.c b/drivers/net/ethernet/intel/ice/ice_xsk.c
index 79fa65d1cf20..65468cdc2587 100644
--- a/drivers/net/ethernet/intel/ice/ice_xsk.c
+++ b/drivers/net/ethernet/intel/ice/ice_xsk.c
@@ -789,6 +789,7 @@ static void ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring)
 	struct ice_tx_desc *tx_desc;
 	u16 cnt = xdp_ring->count;
 	struct ice_tx_buf *tx_buf;
+	u16 completed_frames = 0;
 	u16 xsk_frames = 0;
 	u16 last_rs;
 	int i;
@@ -798,19 +799,21 @@ static void ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring)
 	if ((tx_desc->cmd_type_offset_bsz &
 	    cpu_to_le64(ICE_TX_DESC_DTYPE_DESC_DONE))) {
 		if (last_rs >= ntc)
-			xsk_frames = last_rs - ntc + 1;
+			completed_frames = last_rs - ntc + 1;
 		else
-			xsk_frames = last_rs + cnt - ntc + 1;
+			completed_frames = last_rs + cnt - ntc + 1;
 	}
 
-	if (!xsk_frames)
+	if (!completed_frames)
 		return;
 
-	if (likely(!xdp_ring->xdp_tx_active))
+	if (likely(!xdp_ring->xdp_tx_active)) {
+		xsk_frames = completed_frames;
 		goto skip;
+	}
 
 	ntc = xdp_ring->next_to_clean;
-	for (i = 0; i < xsk_frames; i++) {
+	for (i = 0; i < completed_frames; i++) {
 		tx_buf = &xdp_ring->tx_buf[ntc];
 
 		if (tx_buf->raw_buf) {
@@ -826,7 +829,7 @@ static void ice_clean_xdp_irq_zc(struct ice_tx_ring *xdp_ring)
 	}
 skip:
 	tx_desc->cmd_type_offset_bsz = 0;
-	xdp_ring->next_to_clean += xsk_frames;
+	xdp_ring->next_to_clean += completed_frames;
 	if (xdp_ring->next_to_clean >= cnt)
 		xdp_ring->next_to_clean -= cnt;
 	if (xsk_frames)
diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 24a6ae19ad8e..bf4317e47f94 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -2256,6 +2256,30 @@ static void igb_enable_mas(struct igb_adapter *adapter)
 	}
 }
 
+#ifdef CONFIG_IGB_HWMON
+/**
+ *  igb_set_i2c_bb - Init I2C interface
+ *  @hw: pointer to hardware structure
+ **/
+static void igb_set_i2c_bb(struct e1000_hw *hw)
+{
+	u32 ctrl_ext;
+	s32 i2cctl;
+
+	ctrl_ext = rd32(E1000_CTRL_EXT);
+	ctrl_ext |= E1000_CTRL_I2C_ENA;
+	wr32(E1000_CTRL_EXT, ctrl_ext);
+	wrfl();
+
+	i2cctl = rd32(E1000_I2CPARAMS);
+	i2cctl |= E1000_I2CBB_EN
+		| E1000_I2C_CLK_OE_N
+		| E1000_I2C_DATA_OE_N;
+	wr32(E1000_I2CPARAMS, i2cctl);
+	wrfl();
+}
+#endif
+
 void igb_reset(struct igb_adapter *adapter)
 {
 	struct pci_dev *pdev = adapter->pdev;
@@ -2400,7 +2424,8 @@ void igb_reset(struct igb_adapter *adapter)
 			 * interface.
 			 */
 			if (adapter->ets)
-				mac->ops.init_thermal_sensor_thresh(hw);
+				igb_set_i2c_bb(hw);
+			mac->ops.init_thermal_sensor_thresh(hw);
 		}
 	}
 #endif
@@ -3117,21 +3142,12 @@ static void igb_init_mas(struct igb_adapter *adapter)
  **/
 static s32 igb_init_i2c(struct igb_adapter *adapter)
 {
-	struct e1000_hw *hw = &adapter->hw;
 	s32 status = 0;
-	s32 i2cctl;
 
 	/* I2C interface supported on i350 devices */
 	if (adapter->hw.mac.type != e1000_i350)
 		return 0;
 
-	i2cctl = rd32(E1000_I2CPARAMS);
-	i2cctl |= E1000_I2CBB_EN
-		| E1000_I2C_CLK_OUT | E1000_I2C_CLK_OE_N
-		| E1000_I2C_DATA_OUT | E1000_I2C_DATA_OE_N;
-	wr32(E1000_I2CPARAMS, i2cctl);
-	wrfl();
-
 	/* Initialize the i2c bus which is controlled by the registers.
 	 * This bus will use the i2c_algo_bit structure that implements
 	 * the protocol through toggling of the 4 bits in the register.
@@ -3521,6 +3537,12 @@ static int igb_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			adapter->ets = true;
 		else
 			adapter->ets = false;
+		/* Only enable I2C bit banging if an external thermal
+		 * sensor is supported.
+		 */
+		if (adapter->ets)
+			igb_set_i2c_bb(hw);
+		hw->mac.ops.init_thermal_sensor_thresh(hw);
 		if (igb_sysfs_init(adapter))
 			dev_err(&pdev->dev,
 				"failed to allocate sysfs resources\n");
@@ -6794,7 +6816,7 @@ static void igb_perout(struct igb_adapter *adapter, int tsintr_tt)
 	struct timespec64 ts;
 	u32 tsauxc;
 
-	if (pin < 0 || pin >= IGB_N_PEROUT)
+	if (pin < 0 || pin >= IGB_N_SDP)
 		return;
 
 	spin_lock(&adapter->tmreg_lock);
@@ -6802,7 +6824,7 @@ static void igb_perout(struct igb_adapter *adapter, int tsintr_tt)
 	if (hw->mac.type == e1000_82580 ||
 	    hw->mac.type == e1000_i354 ||
 	    hw->mac.type == e1000_i350) {
-		s64 ns = timespec64_to_ns(&adapter->perout[pin].period);
+		s64 ns = timespec64_to_ns(&adapter->perout[tsintr_tt].period);
 		u32 systiml, systimh, level_mask, level, rem;
 		u64 systim, now;
 
@@ -6850,8 +6872,8 @@ static void igb_perout(struct igb_adapter *adapter, int tsintr_tt)
 		ts.tv_nsec = (u32)systim;
 		ts.tv_sec  = ((u32)(systim >> 32)) & 0xFF;
 	} else {
-		ts = timespec64_add(adapter->perout[pin].start,
-				    adapter->perout[pin].period);
+		ts = timespec64_add(adapter->perout[tsintr_tt].start,
+				    adapter->perout[tsintr_tt].period);
 	}
 
 	/* u32 conversion of tv_sec is safe until y2106 */
@@ -6860,7 +6882,7 @@ static void igb_perout(struct igb_adapter *adapter, int tsintr_tt)
 	tsauxc = rd32(E1000_TSAUXC);
 	tsauxc |= TSAUXC_EN_TT0;
 	wr32(E1000_TSAUXC, tsauxc);
-	adapter->perout[pin].start = ts;
+	adapter->perout[tsintr_tt].start = ts;
 
 	spin_unlock(&adapter->tmreg_lock);
 }
@@ -6874,7 +6896,7 @@ static void igb_extts(struct igb_adapter *adapter, int tsintr_tt)
 	struct ptp_clock_event event;
 	struct timespec64 ts;
 
-	if (pin < 0 || pin >= IGB_N_EXTTS)
+	if (pin < 0 || pin >= IGB_N_SDP)
 		return;
 
 	if (hw->mac.type == e1000_82580 ||
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe.h b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
index 5369a97ff5ec..2bf387e52e20 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe.h
@@ -67,6 +67,8 @@
 #define IXGBE_RXBUFFER_4K    4096
 #define IXGBE_MAX_RXBUFFER  16384  /* largest size for a single descriptor */
 
+#define IXGBE_PKT_HDR_PAD   (ETH_HLEN + ETH_FCS_LEN + (VLAN_HLEN * 2))
+
 /* Attempt to maximize the headroom available for incoming frames.  We
  * use a 2K buffer for receives and need 1536/1534 to store the data for
  * the frame.  This leaves us with 512 bytes of room.  From that we need
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 298cfbfcb7b6..faf3a094ac54 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -6777,6 +6777,18 @@ static void ixgbe_free_all_rx_resources(struct ixgbe_adapter *adapter)
 			ixgbe_free_rx_resources(adapter->rx_ring[i]);
 }
 
+/**
+ * ixgbe_max_xdp_frame_size - returns the maximum allowed frame size for XDP
+ * @adapter: device handle, pointer to adapter
+ */
+static int ixgbe_max_xdp_frame_size(struct ixgbe_adapter *adapter)
+{
+	if (PAGE_SIZE >= 8192 || adapter->flags2 & IXGBE_FLAG2_RX_LEGACY)
+		return IXGBE_RXBUFFER_2K;
+	else
+		return IXGBE_RXBUFFER_3K;
+}
+
 /**
  * ixgbe_change_mtu - Change the Maximum Transfer Unit
  * @netdev: network interface device structure
@@ -6788,18 +6800,12 @@ static int ixgbe_change_mtu(struct net_device *netdev, int new_mtu)
 {
 	struct ixgbe_adapter *adapter = netdev_priv(netdev);
 
-	if (adapter->xdp_prog) {
-		int new_frame_size = new_mtu + ETH_HLEN + ETH_FCS_LEN +
-				     VLAN_HLEN;
-		int i;
-
-		for (i = 0; i < adapter->num_rx_queues; i++) {
-			struct ixgbe_ring *ring = adapter->rx_ring[i];
+	if (ixgbe_enabled_xdp_adapter(adapter)) {
+		int new_frame_size = new_mtu + IXGBE_PKT_HDR_PAD;
 
-			if (new_frame_size > ixgbe_rx_bufsz(ring)) {
-				e_warn(probe, "Requested MTU size is not supported with XDP\n");
-				return -EINVAL;
-			}
+		if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
+			e_warn(probe, "Requested MTU size is not supported with XDP\n");
+			return -EINVAL;
 		}
 	}
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index 784ecb2dc9fb..34ea8af48c3d 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -595,8 +595,7 @@ mtk_foe_entry_commit_subflow(struct mtk_ppe *ppe, struct mtk_flow_entry *entry,
 	u32 ib1_mask = mtk_get_ib1_pkt_type_mask(ppe->eth) | MTK_FOE_IB1_UDP;
 	int type;
 
-	flow_info = kzalloc(offsetof(struct mtk_flow_entry, l2_data.end),
-			    GFP_ATOMIC);
+	flow_info = kzalloc(sizeof(*flow_info), GFP_ATOMIC);
 	if (!flow_info)
 		return;
 
diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.h b/drivers/net/ethernet/mediatek/mtk_ppe.h
index a09c32539bcc..e66283b1bc79 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.h
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.h
@@ -277,7 +277,6 @@ struct mtk_flow_entry {
 		struct {
 			struct mtk_flow_entry *base_flow;
 			struct hlist_node list;
-			struct {} end;
 		} l2_data;
 	};
 	struct rhash_head node;
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
index 835caa15d55f..732774645c1a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-qcom-ethqos.c
@@ -560,6 +560,8 @@ static int qcom_ethqos_probe(struct platform_device *pdev)
 	plat_dat->has_gmac4 = 1;
 	plat_dat->pmt = 1;
 	plat_dat->tso_en = of_property_read_bool(np, "snps,tso");
+	if (of_device_is_compatible(np, "qcom,qcs404-ethqos"))
+		plat_dat->rx_clk_runs_in_lpi = 1;
 
 	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
 	if (ret)
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
index 413f66017219..e95d35f1e5a0 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.c
@@ -541,9 +541,9 @@ int dwmac5_flex_pps_config(void __iomem *ioaddr, int index,
 		return 0;
 	}
 
-	val |= PPSCMDx(index, 0x2);
 	val |= TRGTMODSELx(index, 0x2);
 	val |= PPSEN0;
+	writel(val, ioaddr + MAC_PPS_CONTROL);
 
 	writel(cfg->start.tv_sec, ioaddr + MAC_PPSx_TARGET_TIME_SEC(index));
 
@@ -568,6 +568,7 @@ int dwmac5_flex_pps_config(void __iomem *ioaddr, int index,
 	writel(period - 1, ioaddr + MAC_PPSx_WIDTH(index));
 
 	/* Finally, activate it */
+	val |= PPSCMDx(index, 0x2);
 	writel(val, ioaddr + MAC_PPS_CONTROL);
 	return 0;
 }
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 4bba0444c764..84e1740b12f1 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1077,7 +1077,8 @@ static void stmmac_mac_link_up(struct phylink_config *config,
 
 	stmmac_mac_set(priv, priv->ioaddr, true);
 	if (phy && priv->dma_cap.eee) {
-		priv->eee_active = phy_init_eee(phy, 1) >= 0;
+		priv->eee_active =
+			phy_init_eee(phy, !priv->plat->rx_clk_runs_in_lpi) >= 0;
 		priv->eee_enabled = stmmac_eee_init(priv);
 		priv->tx_lpi_enabled = priv->eee_enabled;
 		stmmac_set_eee_pls(priv, priv->hw, true);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index eb6d9cd8e93f..0046a4ee6e64 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -559,7 +559,7 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
 	dma_cfg->mixed_burst = of_property_read_bool(np, "snps,mixed-burst");
 
 	plat->force_thresh_dma_mode = of_property_read_bool(np, "snps,force_thresh_dma_mode");
-	if (plat->force_thresh_dma_mode) {
+	if (plat->force_thresh_dma_mode && plat->force_sf_dma_mode) {
 		plat->force_sf_dma_mode = 0;
 		dev_warn(&pdev->dev,
 			 "force_sf_dma_mode is ignored if force_thresh_dma_mode is set.\n");
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 4ff1cfdb9730..00911e936052 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -500,7 +500,15 @@ static int am65_cpsw_nuss_common_stop(struct am65_cpsw_common *common)
 		k3_udma_glue_disable_tx_chn(common->tx_chns[i].tx_chn);
 	}
 
+	reinit_completion(&common->tdown_complete);
 	k3_udma_glue_tdown_rx_chn(common->rx_chns.rx_chn, true);
+
+	if (common->pdata.quirks & AM64_CPSW_QUIRK_DMA_RX_TDOWN_IRQ) {
+		i = wait_for_completion_timeout(&common->tdown_complete, msecs_to_jiffies(1000));
+		if (!i)
+			dev_err(common->dev, "rx teardown timeout\n");
+	}
+
 	napi_disable(&common->napi_rx);
 
 	for (i = 0; i < AM65_CPSW_MAX_RX_FLOWS; i++)
@@ -704,6 +712,8 @@ static int am65_cpsw_nuss_rx_packets(struct am65_cpsw_common *common,
 
 	if (cppi5_desc_is_tdcm(desc_dma)) {
 		dev_dbg(dev, "%s RX tdown flow: %u\n", __func__, flow_idx);
+		if (common->pdata.quirks & AM64_CPSW_QUIRK_DMA_RX_TDOWN_IRQ)
+			complete(&common->tdown_complete);
 		return 0;
 	}
 
@@ -2634,7 +2644,7 @@ static const struct am65_cpsw_pdata j721e_pdata = {
 };
 
 static const struct am65_cpsw_pdata am64x_cpswxg_pdata = {
-	.quirks = 0,
+	.quirks = AM64_CPSW_QUIRK_DMA_RX_TDOWN_IRQ,
 	.ale_dev_id = "am64-cpswxg",
 	.fdqring_mode = K3_RINGACC_RING_MODE_RING,
 };
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 2c9850fdfcb6..a9610e130cd8 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -86,6 +86,7 @@ struct am65_cpsw_rx_chn {
 };
 
 #define AM65_CPSW_QUIRK_I2027_NO_TX_CSUM BIT(0)
+#define AM64_CPSW_QUIRK_DMA_RX_TDOWN_IRQ BIT(1)
 
 struct am65_cpsw_pdata {
 	u32	quirks;
diff --git a/drivers/net/usb/kalmia.c b/drivers/net/usb/kalmia.c
index 9f2b70ef39aa..613fc6910f14 100644
--- a/drivers/net/usb/kalmia.c
+++ b/drivers/net/usb/kalmia.c
@@ -65,8 +65,8 @@ kalmia_send_init_packet(struct usbnet *dev, u8 *init_msg, u8 init_msg_len,
 		init_msg, init_msg_len, &act_len, KALMIA_USB_TIMEOUT);
 	if (status != 0) {
 		netdev_err(dev->net,
-			"Error sending init packet. Status %i, length %i\n",
-			status, act_len);
+			"Error sending init packet. Status %i\n",
+			status);
 		return status;
 	}
 	else if (act_len != init_msg_len) {
@@ -83,8 +83,8 @@ kalmia_send_init_packet(struct usbnet *dev, u8 *init_msg, u8 init_msg_len,
 
 	if (status != 0)
 		netdev_err(dev->net,
-			"Error receiving init result. Status %i, length %i\n",
-			status, act_len);
+			"Error receiving init result. Status %i\n",
+			status);
 	else if (act_len != expected_len)
 		netdev_err(dev->net, "Unexpected init result length: %i\n",
 			act_len);
diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index 56267c327f0b..682987040ea8 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1546,31 +1546,6 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 				rxd->len = rbi->len;
 			}
 
-#ifdef VMXNET3_RSS
-			if (rcd->rssType != VMXNET3_RCD_RSS_TYPE_NONE &&
-			    (adapter->netdev->features & NETIF_F_RXHASH)) {
-				enum pkt_hash_types hash_type;
-
-				switch (rcd->rssType) {
-				case VMXNET3_RCD_RSS_TYPE_IPV4:
-				case VMXNET3_RCD_RSS_TYPE_IPV6:
-					hash_type = PKT_HASH_TYPE_L3;
-					break;
-				case VMXNET3_RCD_RSS_TYPE_TCPIPV4:
-				case VMXNET3_RCD_RSS_TYPE_TCPIPV6:
-				case VMXNET3_RCD_RSS_TYPE_UDPIPV4:
-				case VMXNET3_RCD_RSS_TYPE_UDPIPV6:
-					hash_type = PKT_HASH_TYPE_L4;
-					break;
-				default:
-					hash_type = PKT_HASH_TYPE_L3;
-					break;
-				}
-				skb_set_hash(ctx->skb,
-					     le32_to_cpu(rcd->rssHash),
-					     hash_type);
-			}
-#endif
 			skb_record_rx_queue(ctx->skb, rq->qid);
 			skb_put(ctx->skb, rcd->len);
 
@@ -1653,6 +1628,31 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx_queue *rq,
 			u32 mtu = adapter->netdev->mtu;
 			skb->len += skb->data_len;
 
+#ifdef VMXNET3_RSS
+			if (rcd->rssType != VMXNET3_RCD_RSS_TYPE_NONE &&
+			    (adapter->netdev->features & NETIF_F_RXHASH)) {
+				enum pkt_hash_types hash_type;
+
+				switch (rcd->rssType) {
+				case VMXNET3_RCD_RSS_TYPE_IPV4:
+				case VMXNET3_RCD_RSS_TYPE_IPV6:
+					hash_type = PKT_HASH_TYPE_L3;
+					break;
+				case VMXNET3_RCD_RSS_TYPE_TCPIPV4:
+				case VMXNET3_RCD_RSS_TYPE_TCPIPV6:
+				case VMXNET3_RCD_RSS_TYPE_UDPIPV4:
+				case VMXNET3_RCD_RSS_TYPE_UDPIPV6:
+					hash_type = PKT_HASH_TYPE_L4;
+					break;
+				default:
+					hash_type = PKT_HASH_TYPE_L3;
+					break;
+				}
+				skb_set_hash(skb,
+					     le32_to_cpu(rcd->rssHash),
+					     hash_type);
+			}
+#endif
 			vmxnet3_rx_csum(adapter, skb,
 					(union Vmxnet3_GenericDesc *)rcd);
 			skb->protocol = eth_type_trans(skb, adapter->netdev);
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 25ade4ce8e0a..5acc9ae225df 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -4881,7 +4881,9 @@ int nvme_alloc_admin_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 out_cleanup_admin_q:
 	blk_mq_destroy_queue(ctrl->admin_q);
 out_free_tagset:
-	blk_mq_free_tag_set(ctrl->admin_tagset);
+	blk_mq_free_tag_set(set);
+	ctrl->admin_q = NULL;
+	ctrl->fabrics_q = NULL;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nvme_alloc_admin_tag_set);
@@ -4931,6 +4933,7 @@ int nvme_alloc_io_tag_set(struct nvme_ctrl *ctrl, struct blk_mq_tag_set *set,
 
 out_free_tag_set:
 	blk_mq_free_tag_set(set);
+	ctrl->connect_q = NULL;
 	return ret;
 }
 EXPORT_SYMBOL_GPL(nvme_alloc_io_tag_set);
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d839689af17c..778f94e9a445 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -109,6 +109,7 @@ struct nvme_queue;
 
 static void nvme_dev_disable(struct nvme_dev *dev, bool shutdown);
 static bool __nvme_disable_io_queues(struct nvme_dev *dev, u8 opcode);
+static void nvme_update_attrs(struct nvme_dev *dev);
 
 /*
  * Represents an NVM Express device.  Each nvme_dev is a PCI function.
@@ -1967,6 +1968,8 @@ static void nvme_map_cmb(struct nvme_dev *dev)
 	if ((dev->cmbsz & (NVME_CMBSZ_WDS | NVME_CMBSZ_RDS)) ==
 			(NVME_CMBSZ_WDS | NVME_CMBSZ_RDS))
 		pci_p2pmem_publish(pdev, true);
+
+	nvme_update_attrs(dev);
 }
 
 static int nvme_set_host_mem(struct nvme_dev *dev, u32 bits)
@@ -2250,6 +2253,11 @@ static const struct attribute_group *nvme_pci_dev_attr_groups[] = {
 	NULL,
 };
 
+static void nvme_update_attrs(struct nvme_dev *dev)
+{
+	sysfs_update_group(&dev->ctrl.device->kobj, &nvme_pci_dev_attrs_group);
+}
+
 /*
  * nirqs is the number of interrupts available for write and read
  * queues. The core already reserved an interrupt for the admin queue.
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 6f918e61b6ae..80383213b882 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1154,13 +1154,13 @@ static void nvme_rdma_error_recovery_work(struct work_struct *work)
 	struct nvme_rdma_ctrl *ctrl = container_of(work,
 			struct nvme_rdma_ctrl, err_work);
 
-	nvme_auth_stop(&ctrl->ctrl);
 	nvme_stop_keep_alive(&ctrl->ctrl);
 	flush_work(&ctrl->ctrl.async_event_work);
 	nvme_rdma_teardown_io_queues(ctrl, false);
 	nvme_start_queues(&ctrl->ctrl);
 	nvme_rdma_teardown_admin_queue(ctrl, false);
 	nvme_start_admin_queue(&ctrl->ctrl);
+	nvme_auth_stop(&ctrl->ctrl);
 
 	if (!nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_CONNECTING)) {
 		/* state change failure is ok if we started ctrl delete */
diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 4c052c261517..1dc7c733c7e3 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2128,7 +2128,6 @@ static void nvme_tcp_error_recovery_work(struct work_struct *work)
 				struct nvme_tcp_ctrl, err_work);
 	struct nvme_ctrl *ctrl = &tcp_ctrl->ctrl;
 
-	nvme_auth_stop(ctrl);
 	nvme_stop_keep_alive(ctrl);
 	flush_work(&ctrl->async_event_work);
 	nvme_tcp_teardown_io_queues(ctrl, false);
@@ -2136,6 +2135,7 @@ static void nvme_tcp_error_recovery_work(struct work_struct *work)
 	nvme_start_queues(ctrl);
 	nvme_tcp_teardown_admin_queue(ctrl, false);
 	nvme_start_admin_queue(ctrl);
+	nvme_auth_stop(ctrl);
 
 	if (!nvme_change_ctrl_state(ctrl, NVME_CTRL_CONNECTING)) {
 		/* state change failure is ok if we started ctrl delete */
diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index ab2627e17bb9..1ab6601fdd5c 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -1685,8 +1685,10 @@ nvmet_fc_ls_create_association(struct nvmet_fc_tgtport *tgtport,
 		else {
 			queue = nvmet_fc_alloc_target_queue(iod->assoc, 0,
 					be16_to_cpu(rqst->assoc_cmd.sqsize));
-			if (!queue)
+			if (!queue) {
 				ret = VERR_QUEUE_ALLOC_FAIL;
+				nvmet_fc_tgt_a_put(iod->assoc);
+			}
 		}
 	}
 
diff --git a/drivers/of/of_reserved_mem.c b/drivers/of/of_reserved_mem.c
index 65f3b02a0e4e..f90975e00446 100644
--- a/drivers/of/of_reserved_mem.c
+++ b/drivers/of/of_reserved_mem.c
@@ -48,9 +48,10 @@ static int __init early_init_dt_alloc_reserved_memory_arch(phys_addr_t size,
 		err = memblock_mark_nomap(base, size);
 		if (err)
 			memblock_phys_free(base, size);
-		kmemleak_ignore_phys(base);
 	}
 
+	kmemleak_ignore_phys(base);
+
 	return err;
 }
 
diff --git a/drivers/platform/x86/touchscreen_dmi.c b/drivers/platform/x86/touchscreen_dmi.c
index f00995390fdf..13802a3c3591 100644
--- a/drivers/platform/x86/touchscreen_dmi.c
+++ b/drivers/platform/x86/touchscreen_dmi.c
@@ -1097,6 +1097,15 @@ const struct dmi_system_id touchscreen_dmi_table[] = {
 			DMI_MATCH(DMI_BIOS_DATE, "05/07/2016"),
 		},
 	},
+	{
+		/* Chuwi Vi8 (CWI501) */
+		.driver_data = (void *)&chuwi_vi8_data,
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Insyde"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "i86"),
+			DMI_MATCH(DMI_BIOS_VERSION, "CHUWI.W86JLBNR01"),
+		},
+	},
 	{
 		/* Chuwi Vi8 (CWI506) */
 		.driver_data = (void *)&chuwi_vi8_data,
diff --git a/drivers/vdpa/ifcvf/ifcvf_main.c b/drivers/vdpa/ifcvf/ifcvf_main.c
index f9c0044c6442..44b29289aa19 100644
--- a/drivers/vdpa/ifcvf/ifcvf_main.c
+++ b/drivers/vdpa/ifcvf/ifcvf_main.c
@@ -849,7 +849,7 @@ static int ifcvf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ret = ifcvf_init_hw(vf, pdev);
 	if (ret) {
 		IFCVF_ERR(pdev, "Failed to init IFCVF hw\n");
-		return ret;
+		goto err;
 	}
 
 	for (i = 0; i < vf->nr_vring; i++)
diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index c730253ab85c..583cbcf09446 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -313,7 +313,7 @@ void fb_deferred_io_open(struct fb_info *info,
 }
 EXPORT_SYMBOL_GPL(fb_deferred_io_open);
 
-void fb_deferred_io_cleanup(struct fb_info *info)
+void fb_deferred_io_release(struct fb_info *info)
 {
 	struct fb_deferred_io *fbdefio = info->fbdefio;
 	struct page *page;
@@ -327,6 +327,14 @@ void fb_deferred_io_cleanup(struct fb_info *info)
 		page = fb_deferred_io_page(info, i);
 		page->mapping = NULL;
 	}
+}
+EXPORT_SYMBOL_GPL(fb_deferred_io_release);
+
+void fb_deferred_io_cleanup(struct fb_info *info)
+{
+	struct fb_deferred_io *fbdefio = info->fbdefio;
+
+	fb_deferred_io_release(info);
 
 	kvfree(info->pagerefs);
 	mutex_destroy(&fbdefio->lock);
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 1e70d8c67653..14ef3aab7663 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -1453,6 +1453,10 @@ __releases(&info->lock)
 	struct fb_info * const info = file->private_data;
 
 	lock_fb_info(info);
+#if IS_ENABLED(CONFIG_FB_DEFERRED_IO)
+	if (info->fbdefio)
+		fb_deferred_io_release(info);
+#endif
 	if (info->fbops->fb_release)
 		info->fbops->fb_release(info,1);
 	module_put(info->fbops->owner);
diff --git a/fs/aio.c b/fs/aio.c
index 562916d85cba..e85ba0b77f59 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -361,6 +361,9 @@ static int aio_ring_mremap(struct vm_area_struct *vma)
 	spin_lock(&mm->ioctx_lock);
 	rcu_read_lock();
 	table = rcu_dereference(mm->ioctx_table);
+	if (!table)
+		goto out_unlock;
+
 	for (i = 0; i < table->nr; i++) {
 		struct kioctx *ctx;
 
@@ -374,6 +377,7 @@ static int aio_ring_mremap(struct vm_area_struct *vma)
 		}
 	}
 
+out_unlock:
 	rcu_read_unlock();
 	spin_unlock(&mm->ioctx_lock);
 	return res;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index acb3c5c3b025..58785dc7080a 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -3938,6 +3938,7 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 	lockend = round_up(start + len, root->fs_info->sectorsize);
 	prev_extent_end = lockstart;
 
+	btrfs_inode_lock(&inode->vfs_inode, BTRFS_ILOCK_SHARED);
 	lock_extent(&inode->io_tree, lockstart, lockend, &cached_state);
 
 	ret = fiemap_find_last_extent_offset(inode, path, &last_extent_end);
@@ -4129,6 +4130,7 @@ int extent_fiemap(struct btrfs_inode *inode, struct fiemap_extent_info *fieinfo,
 
 out_unlock:
 	unlock_extent(&inode->io_tree, lockstart, lockend, &cached_state);
+	btrfs_inode_unlock(&inode->vfs_inode, BTRFS_ILOCK_SHARED);
 out:
 	kfree(backref_cache);
 	btrfs_free_path(path);
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 23056d9914d8..1bda59c68360 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -31,329 +31,6 @@
 #include "reflink.h"
 #include "subpage.h"
 
-static struct kmem_cache *btrfs_inode_defrag_cachep;
-/*
- * when auto defrag is enabled we
- * queue up these defrag structs to remember which
- * inodes need defragging passes
- */
-struct inode_defrag {
-	struct rb_node rb_node;
-	/* objectid */
-	u64 ino;
-	/*
-	 * transid where the defrag was added, we search for
-	 * extents newer than this
-	 */
-	u64 transid;
-
-	/* root objectid */
-	u64 root;
-
-	/*
-	 * The extent size threshold for autodefrag.
-	 *
-	 * This value is different for compressed/non-compressed extents,
-	 * thus needs to be passed from higher layer.
-	 * (aka, inode_should_defrag())
-	 */
-	u32 extent_thresh;
-};
-
-static int __compare_inode_defrag(struct inode_defrag *defrag1,
-				  struct inode_defrag *defrag2)
-{
-	if (defrag1->root > defrag2->root)
-		return 1;
-	else if (defrag1->root < defrag2->root)
-		return -1;
-	else if (defrag1->ino > defrag2->ino)
-		return 1;
-	else if (defrag1->ino < defrag2->ino)
-		return -1;
-	else
-		return 0;
-}
-
-/* pop a record for an inode into the defrag tree.  The lock
- * must be held already
- *
- * If you're inserting a record for an older transid than an
- * existing record, the transid already in the tree is lowered
- *
- * If an existing record is found the defrag item you
- * pass in is freed
- */
-static int __btrfs_add_inode_defrag(struct btrfs_inode *inode,
-				    struct inode_defrag *defrag)
-{
-	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	struct inode_defrag *entry;
-	struct rb_node **p;
-	struct rb_node *parent = NULL;
-	int ret;
-
-	p = &fs_info->defrag_inodes.rb_node;
-	while (*p) {
-		parent = *p;
-		entry = rb_entry(parent, struct inode_defrag, rb_node);
-
-		ret = __compare_inode_defrag(defrag, entry);
-		if (ret < 0)
-			p = &parent->rb_left;
-		else if (ret > 0)
-			p = &parent->rb_right;
-		else {
-			/* if we're reinserting an entry for
-			 * an old defrag run, make sure to
-			 * lower the transid of our existing record
-			 */
-			if (defrag->transid < entry->transid)
-				entry->transid = defrag->transid;
-			entry->extent_thresh = min(defrag->extent_thresh,
-						   entry->extent_thresh);
-			return -EEXIST;
-		}
-	}
-	set_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags);
-	rb_link_node(&defrag->rb_node, parent, p);
-	rb_insert_color(&defrag->rb_node, &fs_info->defrag_inodes);
-	return 0;
-}
-
-static inline int __need_auto_defrag(struct btrfs_fs_info *fs_info)
-{
-	if (!btrfs_test_opt(fs_info, AUTO_DEFRAG))
-		return 0;
-
-	if (btrfs_fs_closing(fs_info))
-		return 0;
-
-	return 1;
-}
-
-/*
- * insert a defrag record for this inode if auto defrag is
- * enabled
- */
-int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
-			   struct btrfs_inode *inode, u32 extent_thresh)
-{
-	struct btrfs_root *root = inode->root;
-	struct btrfs_fs_info *fs_info = root->fs_info;
-	struct inode_defrag *defrag;
-	u64 transid;
-	int ret;
-
-	if (!__need_auto_defrag(fs_info))
-		return 0;
-
-	if (test_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags))
-		return 0;
-
-	if (trans)
-		transid = trans->transid;
-	else
-		transid = inode->root->last_trans;
-
-	defrag = kmem_cache_zalloc(btrfs_inode_defrag_cachep, GFP_NOFS);
-	if (!defrag)
-		return -ENOMEM;
-
-	defrag->ino = btrfs_ino(inode);
-	defrag->transid = transid;
-	defrag->root = root->root_key.objectid;
-	defrag->extent_thresh = extent_thresh;
-
-	spin_lock(&fs_info->defrag_inodes_lock);
-	if (!test_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags)) {
-		/*
-		 * If we set IN_DEFRAG flag and evict the inode from memory,
-		 * and then re-read this inode, this new inode doesn't have
-		 * IN_DEFRAG flag. At the case, we may find the existed defrag.
-		 */
-		ret = __btrfs_add_inode_defrag(inode, defrag);
-		if (ret)
-			kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
-	} else {
-		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
-	}
-	spin_unlock(&fs_info->defrag_inodes_lock);
-	return 0;
-}
-
-/*
- * pick the defragable inode that we want, if it doesn't exist, we will get
- * the next one.
- */
-static struct inode_defrag *
-btrfs_pick_defrag_inode(struct btrfs_fs_info *fs_info, u64 root, u64 ino)
-{
-	struct inode_defrag *entry = NULL;
-	struct inode_defrag tmp;
-	struct rb_node *p;
-	struct rb_node *parent = NULL;
-	int ret;
-
-	tmp.ino = ino;
-	tmp.root = root;
-
-	spin_lock(&fs_info->defrag_inodes_lock);
-	p = fs_info->defrag_inodes.rb_node;
-	while (p) {
-		parent = p;
-		entry = rb_entry(parent, struct inode_defrag, rb_node);
-
-		ret = __compare_inode_defrag(&tmp, entry);
-		if (ret < 0)
-			p = parent->rb_left;
-		else if (ret > 0)
-			p = parent->rb_right;
-		else
-			goto out;
-	}
-
-	if (parent && __compare_inode_defrag(&tmp, entry) > 0) {
-		parent = rb_next(parent);
-		if (parent)
-			entry = rb_entry(parent, struct inode_defrag, rb_node);
-		else
-			entry = NULL;
-	}
-out:
-	if (entry)
-		rb_erase(parent, &fs_info->defrag_inodes);
-	spin_unlock(&fs_info->defrag_inodes_lock);
-	return entry;
-}
-
-void btrfs_cleanup_defrag_inodes(struct btrfs_fs_info *fs_info)
-{
-	struct inode_defrag *defrag;
-	struct rb_node *node;
-
-	spin_lock(&fs_info->defrag_inodes_lock);
-	node = rb_first(&fs_info->defrag_inodes);
-	while (node) {
-		rb_erase(node, &fs_info->defrag_inodes);
-		defrag = rb_entry(node, struct inode_defrag, rb_node);
-		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
-
-		cond_resched_lock(&fs_info->defrag_inodes_lock);
-
-		node = rb_first(&fs_info->defrag_inodes);
-	}
-	spin_unlock(&fs_info->defrag_inodes_lock);
-}
-
-#define BTRFS_DEFRAG_BATCH	1024
-
-static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
-				    struct inode_defrag *defrag)
-{
-	struct btrfs_root *inode_root;
-	struct inode *inode;
-	struct btrfs_ioctl_defrag_range_args range;
-	int ret = 0;
-	u64 cur = 0;
-
-again:
-	if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state))
-		goto cleanup;
-	if (!__need_auto_defrag(fs_info))
-		goto cleanup;
-
-	/* get the inode */
-	inode_root = btrfs_get_fs_root(fs_info, defrag->root, true);
-	if (IS_ERR(inode_root)) {
-		ret = PTR_ERR(inode_root);
-		goto cleanup;
-	}
-
-	inode = btrfs_iget(fs_info->sb, defrag->ino, inode_root);
-	btrfs_put_root(inode_root);
-	if (IS_ERR(inode)) {
-		ret = PTR_ERR(inode);
-		goto cleanup;
-	}
-
-	if (cur >= i_size_read(inode)) {
-		iput(inode);
-		goto cleanup;
-	}
-
-	/* do a chunk of defrag */
-	clear_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags);
-	memset(&range, 0, sizeof(range));
-	range.len = (u64)-1;
-	range.start = cur;
-	range.extent_thresh = defrag->extent_thresh;
-
-	sb_start_write(fs_info->sb);
-	ret = btrfs_defrag_file(inode, NULL, &range, defrag->transid,
-				       BTRFS_DEFRAG_BATCH);
-	sb_end_write(fs_info->sb);
-	iput(inode);
-
-	if (ret < 0)
-		goto cleanup;
-
-	cur = max(cur + fs_info->sectorsize, range.start);
-	goto again;
-
-cleanup:
-	kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
-	return ret;
-}
-
-/*
- * run through the list of inodes in the FS that need
- * defragging
- */
-int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
-{
-	struct inode_defrag *defrag;
-	u64 first_ino = 0;
-	u64 root_objectid = 0;
-
-	atomic_inc(&fs_info->defrag_running);
-	while (1) {
-		/* Pause the auto defragger. */
-		if (test_bit(BTRFS_FS_STATE_REMOUNTING,
-			     &fs_info->fs_state))
-			break;
-
-		if (!__need_auto_defrag(fs_info))
-			break;
-
-		/* find an inode to defrag */
-		defrag = btrfs_pick_defrag_inode(fs_info, root_objectid,
-						 first_ino);
-		if (!defrag) {
-			if (root_objectid || first_ino) {
-				root_objectid = 0;
-				first_ino = 0;
-				continue;
-			} else {
-				break;
-			}
-		}
-
-		first_ino = defrag->ino + 1;
-		root_objectid = defrag->root;
-
-		__btrfs_run_defrag_inode(fs_info, defrag);
-	}
-	atomic_dec(&fs_info->defrag_running);
-
-	/*
-	 * during unmount, we use the transaction_wait queue to
-	 * wait for the defragger to stop
-	 */
-	wake_up(&fs_info->transaction_wait);
-	return 0;
-}
-
 /* simple helper to fault in pages and copy.  This should go away
  * and be replaced with calls into generic code.
  */
@@ -4130,23 +3807,6 @@ const struct file_operations btrfs_file_operations = {
 	.remap_file_range = btrfs_remap_file_range,
 };
 
-void __cold btrfs_auto_defrag_exit(void)
-{
-	kmem_cache_destroy(btrfs_inode_defrag_cachep);
-}
-
-int __init btrfs_auto_defrag_init(void)
-{
-	btrfs_inode_defrag_cachep = kmem_cache_create("btrfs_inode_defrag",
-					sizeof(struct inode_defrag), 0,
-					SLAB_MEM_SPREAD,
-					NULL);
-	if (!btrfs_inode_defrag_cachep)
-		return -ENOMEM;
-
-	return 0;
-}
-
 int btrfs_fdatawrite_range(struct inode *inode, loff_t start, loff_t end)
 {
 	int ret;
diff --git a/fs/btrfs/tree-defrag.c b/fs/btrfs/tree-defrag.c
index 072ab9a1374b..0520d6d32a2d 100644
--- a/fs/btrfs/tree-defrag.c
+++ b/fs/btrfs/tree-defrag.c
@@ -10,6 +10,326 @@
 #include "transaction.h"
 #include "locking.h"
 
+static struct kmem_cache *btrfs_inode_defrag_cachep;
+
+/*
+ * When auto defrag is enabled we queue up these defrag structs to remember
+ * which inodes need defragging passes.
+ */
+struct inode_defrag {
+	struct rb_node rb_node;
+	/* Inode number */
+	u64 ino;
+	/*
+	 * Transid where the defrag was added, we search for extents newer than
+	 * this.
+	 */
+	u64 transid;
+
+	/* Root objectid */
+	u64 root;
+
+	/*
+	 * The extent size threshold for autodefrag.
+	 *
+	 * This value is different for compressed/non-compressed extents, thus
+	 * needs to be passed from higher layer.
+	 * (aka, inode_should_defrag())
+	 */
+	u32 extent_thresh;
+};
+
+static int __compare_inode_defrag(struct inode_defrag *defrag1,
+				  struct inode_defrag *defrag2)
+{
+	if (defrag1->root > defrag2->root)
+		return 1;
+	else if (defrag1->root < defrag2->root)
+		return -1;
+	else if (defrag1->ino > defrag2->ino)
+		return 1;
+	else if (defrag1->ino < defrag2->ino)
+		return -1;
+	else
+		return 0;
+}
+
+/*
+ * Pop a record for an inode into the defrag tree.  The lock must be held
+ * already.
+ *
+ * If you're inserting a record for an older transid than an existing record,
+ * the transid already in the tree is lowered.
+ *
+ * If an existing record is found the defrag item you pass in is freed.
+ */
+static int __btrfs_add_inode_defrag(struct btrfs_inode *inode,
+				    struct inode_defrag *defrag)
+{
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct inode_defrag *entry;
+	struct rb_node **p;
+	struct rb_node *parent = NULL;
+	int ret;
+
+	p = &fs_info->defrag_inodes.rb_node;
+	while (*p) {
+		parent = *p;
+		entry = rb_entry(parent, struct inode_defrag, rb_node);
+
+		ret = __compare_inode_defrag(defrag, entry);
+		if (ret < 0)
+			p = &parent->rb_left;
+		else if (ret > 0)
+			p = &parent->rb_right;
+		else {
+			/*
+			 * If we're reinserting an entry for an old defrag run,
+			 * make sure to lower the transid of our existing
+			 * record.
+			 */
+			if (defrag->transid < entry->transid)
+				entry->transid = defrag->transid;
+			entry->extent_thresh = min(defrag->extent_thresh,
+						   entry->extent_thresh);
+			return -EEXIST;
+		}
+	}
+	set_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags);
+	rb_link_node(&defrag->rb_node, parent, p);
+	rb_insert_color(&defrag->rb_node, &fs_info->defrag_inodes);
+	return 0;
+}
+
+static inline int __need_auto_defrag(struct btrfs_fs_info *fs_info)
+{
+	if (!btrfs_test_opt(fs_info, AUTO_DEFRAG))
+		return 0;
+
+	if (btrfs_fs_closing(fs_info))
+		return 0;
+
+	return 1;
+}
+
+/*
+ * Insert a defrag record for this inode if auto defrag is enabled.
+ */
+int btrfs_add_inode_defrag(struct btrfs_trans_handle *trans,
+			   struct btrfs_inode *inode, u32 extent_thresh)
+{
+	struct btrfs_root *root = inode->root;
+	struct btrfs_fs_info *fs_info = root->fs_info;
+	struct inode_defrag *defrag;
+	u64 transid;
+	int ret;
+
+	if (!__need_auto_defrag(fs_info))
+		return 0;
+
+	if (test_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags))
+		return 0;
+
+	if (trans)
+		transid = trans->transid;
+	else
+		transid = inode->root->last_trans;
+
+	defrag = kmem_cache_zalloc(btrfs_inode_defrag_cachep, GFP_NOFS);
+	if (!defrag)
+		return -ENOMEM;
+
+	defrag->ino = btrfs_ino(inode);
+	defrag->transid = transid;
+	defrag->root = root->root_key.objectid;
+	defrag->extent_thresh = extent_thresh;
+
+	spin_lock(&fs_info->defrag_inodes_lock);
+	if (!test_bit(BTRFS_INODE_IN_DEFRAG, &inode->runtime_flags)) {
+		/*
+		 * If we set IN_DEFRAG flag and evict the inode from memory,
+		 * and then re-read this inode, this new inode doesn't have
+		 * IN_DEFRAG flag. At the case, we may find the existed defrag.
+		 */
+		ret = __btrfs_add_inode_defrag(inode, defrag);
+		if (ret)
+			kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+	} else {
+		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+	}
+	spin_unlock(&fs_info->defrag_inodes_lock);
+	return 0;
+}
+
+/*
+ * Pick the defragable inode that we want, if it doesn't exist, we will get the
+ * next one.
+ */
+static struct inode_defrag *btrfs_pick_defrag_inode(
+			struct btrfs_fs_info *fs_info, u64 root, u64 ino)
+{
+	struct inode_defrag *entry = NULL;
+	struct inode_defrag tmp;
+	struct rb_node *p;
+	struct rb_node *parent = NULL;
+	int ret;
+
+	tmp.ino = ino;
+	tmp.root = root;
+
+	spin_lock(&fs_info->defrag_inodes_lock);
+	p = fs_info->defrag_inodes.rb_node;
+	while (p) {
+		parent = p;
+		entry = rb_entry(parent, struct inode_defrag, rb_node);
+
+		ret = __compare_inode_defrag(&tmp, entry);
+		if (ret < 0)
+			p = parent->rb_left;
+		else if (ret > 0)
+			p = parent->rb_right;
+		else
+			goto out;
+	}
+
+	if (parent && __compare_inode_defrag(&tmp, entry) > 0) {
+		parent = rb_next(parent);
+		if (parent)
+			entry = rb_entry(parent, struct inode_defrag, rb_node);
+		else
+			entry = NULL;
+	}
+out:
+	if (entry)
+		rb_erase(parent, &fs_info->defrag_inodes);
+	spin_unlock(&fs_info->defrag_inodes_lock);
+	return entry;
+}
+
+void btrfs_cleanup_defrag_inodes(struct btrfs_fs_info *fs_info)
+{
+	struct inode_defrag *defrag;
+	struct rb_node *node;
+
+	spin_lock(&fs_info->defrag_inodes_lock);
+	node = rb_first(&fs_info->defrag_inodes);
+	while (node) {
+		rb_erase(node, &fs_info->defrag_inodes);
+		defrag = rb_entry(node, struct inode_defrag, rb_node);
+		kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+
+		cond_resched_lock(&fs_info->defrag_inodes_lock);
+
+		node = rb_first(&fs_info->defrag_inodes);
+	}
+	spin_unlock(&fs_info->defrag_inodes_lock);
+}
+
+#define BTRFS_DEFRAG_BATCH	1024
+
+static int __btrfs_run_defrag_inode(struct btrfs_fs_info *fs_info,
+				    struct inode_defrag *defrag)
+{
+	struct btrfs_root *inode_root;
+	struct inode *inode;
+	struct btrfs_ioctl_defrag_range_args range;
+	int ret = 0;
+	u64 cur = 0;
+
+again:
+	if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state))
+		goto cleanup;
+	if (!__need_auto_defrag(fs_info))
+		goto cleanup;
+
+	/* Get the inode */
+	inode_root = btrfs_get_fs_root(fs_info, defrag->root, true);
+	if (IS_ERR(inode_root)) {
+		ret = PTR_ERR(inode_root);
+		goto cleanup;
+	}
+
+	inode = btrfs_iget(fs_info->sb, defrag->ino, inode_root);
+	btrfs_put_root(inode_root);
+	if (IS_ERR(inode)) {
+		ret = PTR_ERR(inode);
+		goto cleanup;
+	}
+
+	if (cur >= i_size_read(inode)) {
+		iput(inode);
+		goto cleanup;
+	}
+
+	/* Do a chunk of defrag */
+	clear_bit(BTRFS_INODE_IN_DEFRAG, &BTRFS_I(inode)->runtime_flags);
+	memset(&range, 0, sizeof(range));
+	range.len = (u64)-1;
+	range.start = cur;
+	range.extent_thresh = defrag->extent_thresh;
+
+	sb_start_write(fs_info->sb);
+	ret = btrfs_defrag_file(inode, NULL, &range, defrag->transid,
+				       BTRFS_DEFRAG_BATCH);
+	sb_end_write(fs_info->sb);
+	iput(inode);
+
+	if (ret < 0)
+		goto cleanup;
+
+	cur = max(cur + fs_info->sectorsize, range.start);
+	goto again;
+
+cleanup:
+	kmem_cache_free(btrfs_inode_defrag_cachep, defrag);
+	return ret;
+}
+
+/*
+ * Run through the list of inodes in the FS that need defragging.
+ */
+int btrfs_run_defrag_inodes(struct btrfs_fs_info *fs_info)
+{
+	struct inode_defrag *defrag;
+	u64 first_ino = 0;
+	u64 root_objectid = 0;
+
+	atomic_inc(&fs_info->defrag_running);
+	while (1) {
+		/* Pause the auto defragger. */
+		if (test_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state))
+			break;
+
+		if (!__need_auto_defrag(fs_info))
+			break;
+
+		/* find an inode to defrag */
+		defrag = btrfs_pick_defrag_inode(fs_info, root_objectid, first_ino);
+		if (!defrag) {
+			if (root_objectid || first_ino) {
+				root_objectid = 0;
+				first_ino = 0;
+				continue;
+			} else {
+				break;
+			}
+		}
+
+		first_ino = defrag->ino + 1;
+		root_objectid = defrag->root;
+
+		__btrfs_run_defrag_inode(fs_info, defrag);
+	}
+	atomic_dec(&fs_info->defrag_running);
+
+	/*
+	 * During unmount, we use the transaction_wait queue to wait for the
+	 * defragger to stop.
+	 */
+	wake_up(&fs_info->transaction_wait);
+	return 0;
+}
+
 /*
  * Defrag all the leaves in a given btree.
  * Read all the leaves and try to get key order to
@@ -132,3 +452,20 @@ int btrfs_defrag_leaves(struct btrfs_trans_handle *trans,
 
 	return ret;
 }
+
+void __cold btrfs_auto_defrag_exit(void)
+{
+	kmem_cache_destroy(btrfs_inode_defrag_cachep);
+}
+
+int __init btrfs_auto_defrag_init(void)
+{
+	btrfs_inode_defrag_cachep = kmem_cache_create("btrfs_inode_defrag",
+					sizeof(struct inode_defrag), 0,
+					SLAB_MEM_SPREAD,
+					NULL);
+	if (!btrfs_inode_defrag_cachep)
+		return -ENOMEM;
+
+	return 0;
+}
diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 61f47debec5a..478c03bfba66 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -305,7 +305,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	struct inode *inode = rreq->inode;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
-	struct ceph_osd_request *req;
+	struct ceph_osd_request *req = NULL;
 	struct ceph_vino vino = ceph_vino(inode);
 	struct iov_iter iter;
 	struct page **pages;
@@ -313,6 +313,11 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	int err = 0;
 	u64 len = subreq->len;
 
+	if (ceph_inode_is_shutdown(inode)) {
+		err = -EIO;
+		goto out;
+	}
+
 	if (ceph_has_inline_data(ci) && ceph_netfs_issue_op_inline(subreq))
 		return;
 
@@ -563,6 +568,9 @@ static int writepage_nounlock(struct page *page, struct writeback_control *wbc)
 
 	dout("writepage %p idx %lu\n", page, page->index);
 
+	if (ceph_inode_is_shutdown(inode))
+		return -EIO;
+
 	/* verify this is a writeable snap context */
 	snapc = page_snap_context(page);
 	if (!snapc) {
@@ -1643,7 +1651,7 @@ int ceph_uninline_data(struct file *file)
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
 	struct ceph_osd_request *req = NULL;
-	struct ceph_cap_flush *prealloc_cf;
+	struct ceph_cap_flush *prealloc_cf = NULL;
 	struct folio *folio = NULL;
 	u64 inline_version = CEPH_INLINE_NONE;
 	struct page *pages[1];
@@ -1657,6 +1665,11 @@ int ceph_uninline_data(struct file *file)
 	dout("uninline_data %p %llx.%llx inline_version %llu\n",
 	     inode, ceph_vinop(inode), inline_version);
 
+	if (ceph_inode_is_shutdown(inode)) {
+		err = -EIO;
+		goto out;
+	}
+
 	if (inline_version == CEPH_INLINE_NONE)
 		return 0;
 
diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index cd69bf267d1b..795fd6d84bde 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4081,6 +4081,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	void *p, *end;
 	struct cap_extra_info extra_info = {};
 	bool queue_trunc;
+	bool close_sessions = false;
 
 	dout("handle_caps from mds%d\n", session->s_mds);
 
@@ -4218,9 +4219,13 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 		realm = NULL;
 		if (snaptrace_len) {
 			down_write(&mdsc->snap_rwsem);
-			ceph_update_snap_trace(mdsc, snaptrace,
-					       snaptrace + snaptrace_len,
-					       false, &realm);
+			if (ceph_update_snap_trace(mdsc, snaptrace,
+						   snaptrace + snaptrace_len,
+						   false, &realm)) {
+				up_write(&mdsc->snap_rwsem);
+				close_sessions = true;
+				goto done;
+			}
 			downgrade_write(&mdsc->snap_rwsem);
 		} else {
 			down_read(&mdsc->snap_rwsem);
@@ -4280,6 +4285,11 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	iput(inode);
 out:
 	ceph_put_string(extra_info.pool_ns);
+
+	/* Defer closing the sessions after s_mutex lock being released */
+	if (close_sessions)
+		ceph_mdsc_close_sessions(mdsc);
+
 	return;
 
 flush_cap_releases:
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 6f9580defb2b..5895797f3104 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2004,6 +2004,9 @@ static int ceph_zero_partial_object(struct inode *inode,
 	loff_t zero = 0;
 	int op;
 
+	if (ceph_inode_is_shutdown(inode))
+		return -EIO;
+
 	if (!length) {
 		op = offset ? CEPH_OSD_OP_DELETE : CEPH_OSD_OP_TRUNCATE;
 		length = &zero;
diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 756560df3bdb..27a245d959c0 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -806,6 +806,9 @@ static struct ceph_mds_session *register_session(struct ceph_mds_client *mdsc,
 {
 	struct ceph_mds_session *s;
 
+	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
+		return ERR_PTR(-EIO);
+
 	if (mds >= mdsc->mdsmap->possible_max_rank)
 		return ERR_PTR(-EINVAL);
 
@@ -1478,6 +1481,9 @@ static int __open_session(struct ceph_mds_client *mdsc,
 	int mstate;
 	int mds = session->s_mds;
 
+	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO)
+		return -EIO;
+
 	/* wait for mds to go active? */
 	mstate = ceph_mdsmap_get_state(mdsc->mdsmap, mds);
 	dout("open_session to mds%d (%s)\n", mds,
@@ -2860,6 +2866,11 @@ static void __do_request(struct ceph_mds_client *mdsc,
 		return;
 	}
 
+	if (READ_ONCE(mdsc->fsc->mount_state) == CEPH_MOUNT_FENCE_IO) {
+		dout("do_request metadata corrupted\n");
+		err = -EIO;
+		goto finish;
+	}
 	if (req->r_timeout &&
 	    time_after_eq(jiffies, req->r_started + req->r_timeout)) {
 		dout("do_request timed out\n");
@@ -3245,6 +3256,7 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	u64 tid;
 	int err, result;
 	int mds = session->s_mds;
+	bool close_sessions = false;
 
 	if (msg->front.iov_len < sizeof(*head)) {
 		pr_err("mdsc_handle_reply got corrupt (short) reply\n");
@@ -3351,10 +3363,17 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 	realm = NULL;
 	if (rinfo->snapblob_len) {
 		down_write(&mdsc->snap_rwsem);
-		ceph_update_snap_trace(mdsc, rinfo->snapblob,
+		err = ceph_update_snap_trace(mdsc, rinfo->snapblob,
 				rinfo->snapblob + rinfo->snapblob_len,
 				le32_to_cpu(head->op) == CEPH_MDS_OP_RMSNAP,
 				&realm);
+		if (err) {
+			up_write(&mdsc->snap_rwsem);
+			close_sessions = true;
+			if (err == -EIO)
+				ceph_msg_dump(msg);
+			goto out_err;
+		}
 		downgrade_write(&mdsc->snap_rwsem);
 	} else {
 		down_read(&mdsc->snap_rwsem);
@@ -3412,6 +3431,10 @@ static void handle_reply(struct ceph_mds_session *session, struct ceph_msg *msg)
 				     req->r_end_latency, err);
 out:
 	ceph_mdsc_put_request(req);
+
+	/* Defer closing the sessions after s_mutex lock being released */
+	if (close_sessions)
+		ceph_mdsc_close_sessions(mdsc);
 	return;
 }
 
@@ -5017,7 +5040,7 @@ static bool done_closing_sessions(struct ceph_mds_client *mdsc, int skipped)
 }
 
 /*
- * called after sb is ro.
+ * called after sb is ro or when metadata corrupted.
  */
 void ceph_mdsc_close_sessions(struct ceph_mds_client *mdsc)
 {
@@ -5307,7 +5330,8 @@ static void mds_peer_reset(struct ceph_connection *con)
 	struct ceph_mds_client *mdsc = s->s_mdsc;
 
 	pr_warn("mds%d closed our session\n", s->s_mds);
-	send_mds_reconnect(mdsc, s);
+	if (READ_ONCE(mdsc->fsc->mount_state) != CEPH_MOUNT_FENCE_IO)
+		send_mds_reconnect(mdsc, s);
 }
 
 static void mds_dispatch(struct ceph_connection *con, struct ceph_msg *msg)
diff --git a/fs/ceph/snap.c b/fs/ceph/snap.c
index e4151852184e..87007203f130 100644
--- a/fs/ceph/snap.c
+++ b/fs/ceph/snap.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/ceph/ceph_debug.h>
 
+#include <linux/fs.h>
 #include <linux/sort.h>
 #include <linux/slab.h>
 #include <linux/iversion.h>
@@ -766,8 +767,10 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	struct ceph_snap_realm *realm;
 	struct ceph_snap_realm *first_realm = NULL;
 	struct ceph_snap_realm *realm_to_rebuild = NULL;
+	struct ceph_client *client = mdsc->fsc->client;
 	int rebuild_snapcs;
 	int err = -ENOMEM;
+	int ret;
 	LIST_HEAD(dirty_realms);
 
 	lockdep_assert_held_write(&mdsc->snap_rwsem);
@@ -884,6 +887,27 @@ int ceph_update_snap_trace(struct ceph_mds_client *mdsc,
 	if (first_realm)
 		ceph_put_snap_realm(mdsc, first_realm);
 	pr_err("%s error %d\n", __func__, err);
+
+	/*
+	 * When receiving a corrupted snap trace we don't know what
+	 * exactly has happened in MDS side. And we shouldn't continue
+	 * writing to OSD, which may corrupt the snapshot contents.
+	 *
+	 * Just try to blocklist this kclient and then this kclient
+	 * must be remounted to continue after the corrupted metadata
+	 * fixed in the MDS side.
+	 */
+	WRITE_ONCE(mdsc->fsc->mount_state, CEPH_MOUNT_FENCE_IO);
+	ret = ceph_monc_blocklist_add(&client->monc, &client->msgr.inst.addr);
+	if (ret)
+		pr_err("%s failed to blocklist %s: %d\n", __func__,
+		       ceph_pr_addr(&client->msgr.inst.addr), ret);
+
+	WARN(1, "%s: %s%sdo remount to continue%s",
+	     __func__, ret ? "" : ceph_pr_addr(&client->msgr.inst.addr),
+	     ret ? "" : " was blocklisted, ",
+	     err == -EIO ? " after corrupted snaptrace is fixed" : "");
+
 	return err;
 }
 
@@ -984,6 +1008,7 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	__le64 *split_inos = NULL, *split_realms = NULL;
 	int i;
 	int locked_rwsem = 0;
+	bool close_sessions = false;
 
 	/* decode */
 	if (msg->front.iov_len < sizeof(*h))
@@ -1092,8 +1117,12 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 	 * update using the provided snap trace. if we are deleting a
 	 * snap, we can avoid queueing cap_snaps.
 	 */
-	ceph_update_snap_trace(mdsc, p, e,
-			       op == CEPH_SNAP_OP_DESTROY, NULL);
+	if (ceph_update_snap_trace(mdsc, p, e,
+				   op == CEPH_SNAP_OP_DESTROY,
+				   NULL)) {
+		close_sessions = true;
+		goto bad;
+	}
 
 	if (op == CEPH_SNAP_OP_SPLIT)
 		/* we took a reference when we created the realm, above */
@@ -1112,6 +1141,9 @@ void ceph_handle_snap(struct ceph_mds_client *mdsc,
 out:
 	if (locked_rwsem)
 		up_write(&mdsc->snap_rwsem);
+
+	if (close_sessions)
+		ceph_mdsc_close_sessions(mdsc);
 	return;
 }
 
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index ae4126f63410..3599fefa91f9 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -100,6 +100,17 @@ struct ceph_mount_options {
 	char *mon_addr;
 };
 
+/* mount state */
+enum {
+	CEPH_MOUNT_MOUNTING,
+	CEPH_MOUNT_MOUNTED,
+	CEPH_MOUNT_UNMOUNTING,
+	CEPH_MOUNT_UNMOUNTED,
+	CEPH_MOUNT_SHUTDOWN,
+	CEPH_MOUNT_RECOVER,
+	CEPH_MOUNT_FENCE_IO,
+};
+
 #define CEPH_ASYNC_CREATE_CONFLICT_BITS 8
 
 struct ceph_fs_client {
diff --git a/fs/coredump.c b/fs/coredump.c
index 095ed821c8ac..4d332f147137 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -831,6 +831,30 @@ static int __dump_skip(struct coredump_params *cprm, size_t nr)
 	}
 }
 
+int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
+{
+	if (cprm->to_skip) {
+		if (!__dump_skip(cprm, cprm->to_skip))
+			return 0;
+		cprm->to_skip = 0;
+	}
+	return __dump_emit(cprm, addr, nr);
+}
+EXPORT_SYMBOL(dump_emit);
+
+void dump_skip_to(struct coredump_params *cprm, unsigned long pos)
+{
+	cprm->to_skip = pos - cprm->pos;
+}
+EXPORT_SYMBOL(dump_skip_to);
+
+void dump_skip(struct coredump_params *cprm, size_t nr)
+{
+	cprm->to_skip += nr;
+}
+EXPORT_SYMBOL(dump_skip);
+
+#ifdef CONFIG_ELF_CORE
 static int dump_emit_page(struct coredump_params *cprm, struct page *page)
 {
 	struct bio_vec bvec = {
@@ -864,30 +888,6 @@ static int dump_emit_page(struct coredump_params *cprm, struct page *page)
 	return 1;
 }
 
-int dump_emit(struct coredump_params *cprm, const void *addr, int nr)
-{
-	if (cprm->to_skip) {
-		if (!__dump_skip(cprm, cprm->to_skip))
-			return 0;
-		cprm->to_skip = 0;
-	}
-	return __dump_emit(cprm, addr, nr);
-}
-EXPORT_SYMBOL(dump_emit);
-
-void dump_skip_to(struct coredump_params *cprm, unsigned long pos)
-{
-	cprm->to_skip = pos - cprm->pos;
-}
-EXPORT_SYMBOL(dump_skip_to);
-
-void dump_skip(struct coredump_params *cprm, size_t nr)
-{
-	cprm->to_skip += nr;
-}
-EXPORT_SYMBOL(dump_skip);
-
-#ifdef CONFIG_ELF_CORE
 int dump_user_range(struct coredump_params *cprm, unsigned long start,
 		    unsigned long len)
 {
diff --git a/fs/fscache/volume.c b/fs/fscache/volume.c
index 903af9d85f8b..cdf991bdd9de 100644
--- a/fs/fscache/volume.c
+++ b/fs/fscache/volume.c
@@ -280,8 +280,7 @@ static void fscache_create_volume_work(struct work_struct *work)
 	fscache_end_cache_access(volume->cache,
 				 fscache_access_acquire_volume_end);
 
-	clear_bit_unlock(FSCACHE_VOLUME_CREATING, &volume->flags);
-	wake_up_bit(&volume->flags, FSCACHE_VOLUME_CREATING);
+	clear_and_wake_up_bit(FSCACHE_VOLUME_CREATING, &volume->flags);
 	fscache_put_volume(volume, fscache_volume_put_create_work);
 }
 
diff --git a/fs/nilfs2/ioctl.c b/fs/nilfs2/ioctl.c
index 87e1004b606d..b4041d0566a9 100644
--- a/fs/nilfs2/ioctl.c
+++ b/fs/nilfs2/ioctl.c
@@ -1114,7 +1114,14 @@ static int nilfs_ioctl_set_alloc_range(struct inode *inode, void __user *argp)
 
 	minseg = range[0] + segbytes - 1;
 	do_div(minseg, segbytes);
+
+	if (range[1] < 4096)
+		goto out;
+
 	maxseg = NILFS_SB2_OFFSET_BYTES(range[1]);
+	if (maxseg < segbytes)
+		goto out;
+
 	do_div(maxseg, segbytes);
 	maxseg--;
 
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index 6edb6e0dd61f..1422b8ba24ed 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -408,6 +408,15 @@ int nilfs_resize_fs(struct super_block *sb, __u64 newsize)
 	if (newsize > devsize)
 		goto out;
 
+	/*
+	 * Prevent underflow in second superblock position calculation.
+	 * The exact minimum size check is done in nilfs_sufile_resize().
+	 */
+	if (newsize < 4096) {
+		ret = -ENOSPC;
+		goto out;
+	}
+
 	/*
 	 * Write lock is required to protect some functions depending
 	 * on the number of segments, the number of reserved segments,
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 2064e6473d30..3a4c9c150cbf 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -544,9 +544,15 @@ static int nilfs_load_super_block(struct the_nilfs *nilfs,
 {
 	struct nilfs_super_block **sbp = nilfs->ns_sbp;
 	struct buffer_head **sbh = nilfs->ns_sbh;
-	u64 sb2off = NILFS_SB2_OFFSET_BYTES(bdev_nr_bytes(nilfs->ns_bdev));
+	u64 sb2off, devsize = bdev_nr_bytes(nilfs->ns_bdev);
 	int valid[2], swp = 0;
 
+	if (devsize < NILFS_SEG_MIN_BLOCKS * NILFS_MIN_BLOCK_SIZE + 4096) {
+		nilfs_err(sb, "device size too small");
+		return -EINVAL;
+	}
+	sb2off = NILFS_SB2_OFFSET_BYTES(devsize);
+
 	sbp[0] = nilfs_read_super_block(sb, NILFS_SB_OFFSET_BYTES, blocksize,
 					&sbh[0]);
 	sbp[1] = nilfs_read_super_block(sb, sb2off, blocksize, &sbh[1]);
diff --git a/fs/squashfs/xattr_id.c b/fs/squashfs/xattr_id.c
index b88d19e9581e..c8469c656e0d 100644
--- a/fs/squashfs/xattr_id.c
+++ b/fs/squashfs/xattr_id.c
@@ -76,7 +76,7 @@ __le64 *squashfs_read_xattr_id_table(struct super_block *sb, u64 table_start,
 	/* Sanity check values */
 
 	/* there is always at least one xattr id */
-	if (*xattr_ids <= 0)
+	if (*xattr_ids == 0)
 		return ERR_PTR(-EINVAL);
 
 	len = SQUASHFS_XATTR_BLOCK_BYTES(*xattr_ids);
diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
index 00af2c98da75..4497d0a6772c 100644
--- a/include/linux/ceph/libceph.h
+++ b/include/linux/ceph/libceph.h
@@ -99,16 +99,6 @@ struct ceph_options {
 
 #define CEPH_AUTH_NAME_DEFAULT   "guest"
 
-/* mount state */
-enum {
-	CEPH_MOUNT_MOUNTING,
-	CEPH_MOUNT_MOUNTED,
-	CEPH_MOUNT_UNMOUNTING,
-	CEPH_MOUNT_UNMOUNTED,
-	CEPH_MOUNT_SHUTDOWN,
-	CEPH_MOUNT_RECOVER,
-};
-
 static inline unsigned long ceph_timeout_jiffies(unsigned long timeout)
 {
 	return timeout ?: MAX_SCHEDULE_TIMEOUT;
diff --git a/include/linux/fb.h b/include/linux/fb.h
index bcb8658f5b64..486c4e3b6d6a 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -662,6 +662,7 @@ extern int  fb_deferred_io_init(struct fb_info *info);
 extern void fb_deferred_io_open(struct fb_info *info,
 				struct inode *inode,
 				struct file *file);
+extern void fb_deferred_io_release(struct fb_info *info);
 extern void fb_deferred_io_cleanup(struct fb_info *info);
 extern int fb_deferred_io_fsync(struct file *file, loff_t start,
 				loff_t end, int datasync);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 770650d1ff84..58b53d08f2c8 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -753,7 +753,10 @@ static inline struct hstate *hstate_sizelog(int page_size_log)
 	if (!page_size_log)
 		return &default_hstate;
 
-	return size_to_hstate(1UL << page_size_log);
+	if (page_size_log < BITS_PER_LONG)
+		return size_to_hstate(1UL << page_size_log);
+
+	return NULL;
 }
 
 static inline struct hstate *hstate_vma(struct vm_area_struct *vma)
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 974ccca609d2..e5e8acf8eb89 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -136,7 +136,7 @@ extern int mmap_rnd_compat_bits __read_mostly;
  * define their own version of this macro in <asm/pgtable.h>
  */
 #if BITS_PER_LONG == 64
-/* This function must be updated when the size of struct page grows above 80
+/* This function must be updated when the size of struct page grows above 96
  * or reduces below 56. The idea that compiler optimizes out switch()
  * statement, and only leaves move/store instructions. Also the compiler can
  * combine write statements if they are both assignments and can be reordered,
@@ -147,12 +147,18 @@ static inline void __mm_zero_struct_page(struct page *page)
 {
 	unsigned long *_pp = (void *)page;
 
-	 /* Check that struct page is either 56, 64, 72, or 80 bytes */
+	 /* Check that struct page is either 56, 64, 72, 80, 88 or 96 bytes */
 	BUILD_BUG_ON(sizeof(struct page) & 7);
 	BUILD_BUG_ON(sizeof(struct page) < 56);
-	BUILD_BUG_ON(sizeof(struct page) > 80);
+	BUILD_BUG_ON(sizeof(struct page) > 96);
 
 	switch (sizeof(struct page)) {
+	case 96:
+		_pp[11] = 0;
+		fallthrough;
+	case 88:
+		_pp[10] = 0;
+		fallthrough;
 	case 80:
 		_pp[9] = 0;
 		fallthrough;
diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
index 08e6054e061f..258b615124b6 100644
--- a/include/linux/shrinker.h
+++ b/include/linux/shrinker.h
@@ -104,7 +104,7 @@ extern void synchronize_shrinkers(void);
 
 #ifdef CONFIG_SHRINKER_DEBUG
 extern int shrinker_debugfs_add(struct shrinker *shrinker);
-extern void shrinker_debugfs_remove(struct shrinker *shrinker);
+extern struct dentry *shrinker_debugfs_remove(struct shrinker *shrinker);
 extern int __printf(2, 3) shrinker_debugfs_rename(struct shrinker *shrinker,
 						  const char *fmt, ...);
 #else /* CONFIG_SHRINKER_DEBUG */
@@ -112,8 +112,9 @@ static inline int shrinker_debugfs_add(struct shrinker *shrinker)
 {
 	return 0;
 }
-static inline void shrinker_debugfs_remove(struct shrinker *shrinker)
+static inline struct dentry *shrinker_debugfs_remove(struct shrinker *shrinker)
 {
+	return NULL;
 }
 static inline __printf(2, 3)
 int shrinker_debugfs_rename(struct shrinker *shrinker, const char *fmt, ...)
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index fb2e88614f5d..313edd19bf54 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -252,6 +252,7 @@ struct plat_stmmacenet_data {
 	int rss_en;
 	int mac_port_sel_speed;
 	bool en_tx_lpi_clockgating;
+	bool rx_clk_runs_in_lpi;
 	int has_xgmac;
 	bool vlan_fail_q_en;
 	u8 vlan_fail_q;
diff --git a/include/net/sock.h b/include/net/sock.h
index e0517ecc6531..1f868764575c 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2430,6 +2430,19 @@ static inline __must_check bool skb_set_owner_sk_safe(struct sk_buff *skb, struc
 	return false;
 }
 
+static inline struct sk_buff *skb_clone_and_charge_r(struct sk_buff *skb, struct sock *sk)
+{
+	skb = skb_clone(skb, sk_gfp_mask(sk, GFP_ATOMIC));
+	if (skb) {
+		if (sk_rmem_schedule(sk, skb, skb->truesize)) {
+			skb_set_owner_r(skb, sk);
+			return skb;
+		}
+		__kfree_skb(skb);
+	}
+	return NULL;
+}
+
 static inline void skb_prepare_for_gro(struct sk_buff *skb)
 {
 	if (skb->destructor != sock_wfree) {
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 7f40d87e8f50..48fedeee15c5 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -1278,10 +1278,11 @@ void psi_trigger_destroy(struct psi_trigger *t)
 
 	group = t->group;
 	/*
-	 * Wakeup waiters to stop polling. Can happen if cgroup is deleted
-	 * from under a polling process.
+	 * Wakeup waiters to stop polling and clear the queue to prevent it from
+	 * being accessed later. Can happen if cgroup is deleted from under a
+	 * polling process.
 	 */
-	wake_up_interruptible(&t->event_wait);
+	wake_up_pollfree(&t->event_wait);
 
 	mutex_lock(&group->trigger_lock);
 
diff --git a/kernel/time/alarmtimer.c b/kernel/time/alarmtimer.c
index 5897828b9d7e..7e5dff602585 100644
--- a/kernel/time/alarmtimer.c
+++ b/kernel/time/alarmtimer.c
@@ -470,11 +470,35 @@ u64 alarm_forward(struct alarm *alarm, ktime_t now, ktime_t interval)
 }
 EXPORT_SYMBOL_GPL(alarm_forward);
 
-u64 alarm_forward_now(struct alarm *alarm, ktime_t interval)
+static u64 __alarm_forward_now(struct alarm *alarm, ktime_t interval, bool throttle)
 {
 	struct alarm_base *base = &alarm_bases[alarm->type];
+	ktime_t now = base->get_ktime();
+
+	if (IS_ENABLED(CONFIG_HIGH_RES_TIMERS) && throttle) {
+		/*
+		 * Same issue as with posix_timer_fn(). Timers which are
+		 * periodic but the signal is ignored can starve the system
+		 * with a very small interval. The real fix which was
+		 * promised in the context of posix_timer_fn() never
+		 * materialized, but someone should really work on it.
+		 *
+		 * To prevent DOS fake @now to be 1 jiffie out which keeps
+		 * the overrun accounting correct but creates an
+		 * inconsistency vs. timer_gettime(2).
+		 */
+		ktime_t kj = NSEC_PER_SEC / HZ;
+
+		if (interval < kj)
+			now = ktime_add(now, kj);
+	}
+
+	return alarm_forward(alarm, now, interval);
+}
 
-	return alarm_forward(alarm, base->get_ktime(), interval);
+u64 alarm_forward_now(struct alarm *alarm, ktime_t interval)
+{
+	return __alarm_forward_now(alarm, interval, false);
 }
 EXPORT_SYMBOL_GPL(alarm_forward_now);
 
@@ -551,9 +575,10 @@ static enum alarmtimer_restart alarm_handle_timer(struct alarm *alarm,
 	if (posix_timer_event(ptr, si_private) && ptr->it_interval) {
 		/*
 		 * Handle ignored signals and rearm the timer. This will go
-		 * away once we handle ignored signals proper.
+		 * away once we handle ignored signals proper. Ensure that
+		 * small intervals cannot starve the system.
 		 */
-		ptr->it_overrun += alarm_forward_now(alarm, ptr->it_interval);
+		ptr->it_overrun += __alarm_forward_now(alarm, ptr->it_interval, true);
 		++ptr->it_requeue_pending;
 		ptr->it_active = 1;
 		result = ALARMTIMER_RESTART;
diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 2a2ea9b6f762..e67923986496 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -155,7 +155,7 @@ int trace_define_field(struct trace_event_call *call, const char *type,
 }
 EXPORT_SYMBOL_GPL(trace_define_field);
 
-int trace_define_field_ext(struct trace_event_call *call, const char *type,
+static int trace_define_field_ext(struct trace_event_call *call, const char *type,
 		       const char *name, int offset, int size, int is_signed,
 		       int filter_type, int len)
 {
diff --git a/kernel/umh.c b/kernel/umh.c
index 850631518665..fbf872c624cb 100644
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -438,21 +438,27 @@ int call_usermodehelper_exec(struct subprocess_info *sub_info, int wait)
 	if (wait == UMH_NO_WAIT)	/* task has freed sub_info */
 		goto unlock;
 
-	if (wait & UMH_KILLABLE)
-		state |= TASK_KILLABLE;
-
 	if (wait & UMH_FREEZABLE)
 		state |= TASK_FREEZABLE;
 
-	retval = wait_for_completion_state(&done, state);
-	if (!retval)
-		goto wait_done;
-
 	if (wait & UMH_KILLABLE) {
+		retval = wait_for_completion_state(&done, state | TASK_KILLABLE);
+		if (!retval)
+			goto wait_done;
+
 		/* umh_complete() will see NULL and free sub_info */
 		if (xchg(&sub_info->complete, NULL))
 			goto unlock;
+
+		/*
+		 * fallthrough; in case of -ERESTARTSYS now do uninterruptible
+		 * wait_for_completion_state(). Since umh_complete() shall call
+		 * complete() in a moment if xchg() above returned NULL, this
+		 * uninterruptible wait_for_completion_state() will not block
+		 * SIGKILL'ed processes for long.
+		 */
 	}
+	wait_for_completion_state(&done, state);
 
 wait_done:
 	retval = sub_info->retval;
diff --git a/mm/filemap.c b/mm/filemap.c
index 08341616ae7a..322aea78058a 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2569,18 +2569,19 @@ static int filemap_get_pages(struct kiocb *iocb, struct iov_iter *iter,
 	struct folio *folio;
 	int err = 0;
 
+	/* "last_index" is the index of the page beyond the end of the read */
 	last_index = DIV_ROUND_UP(iocb->ki_pos + iter->count, PAGE_SIZE);
 retry:
 	if (fatal_signal_pending(current))
 		return -EINTR;
 
-	filemap_get_read_batch(mapping, index, last_index, fbatch);
+	filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
 	if (!folio_batch_count(fbatch)) {
 		if (iocb->ki_flags & IOCB_NOIO)
 			return -EAGAIN;
 		page_cache_sync_readahead(mapping, ra, filp, index,
 				last_index - index);
-		filemap_get_read_batch(mapping, index, last_index, fbatch);
+		filemap_get_read_batch(mapping, index, last_index - 1, fbatch);
 	}
 	if (!folio_batch_count(fbatch)) {
 		if (iocb->ki_flags & (IOCB_NOWAIT | IOCB_WAITQ))
diff --git a/mm/gup.c b/mm/gup.c
index eb8d7baf9e4d..028f3b4e8c3f 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1978,7 +1978,7 @@ static unsigned long collect_longterm_unpinnable_pages(
 			drain_allow = false;
 		}
 
-		if (!folio_isolate_lru(folio))
+		if (folio_isolate_lru(folio))
 			continue;
 
 		list_add_tail(&folio->lru, movable_page_list);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 811d19b5c4f6..e7cf013a0efd 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3253,8 +3253,6 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 	pmde = mk_huge_pmd(new, READ_ONCE(vma->vm_page_prot));
 	if (pmd_swp_soft_dirty(*pvmw->pmd))
 		pmde = pmd_mksoft_dirty(pmde);
-	if (is_writable_migration_entry(entry))
-		pmde = maybe_pmd_mkwrite(pmde, vma);
 	if (pmd_swp_uffd_wp(*pvmw->pmd))
 		pmde = pmd_wrprotect(pmd_mkuffd_wp(pmde));
 	if (!is_migration_entry_young(entry))
@@ -3262,6 +3260,10 @@ void remove_migration_pmd(struct page_vma_mapped_walk *pvmw, struct page *new)
 	/* NOTE: this may contain setting soft-dirty on some archs */
 	if (PageDirty(new) && is_migration_entry_dirty(entry))
 		pmde = pmd_mkdirty(pmde);
+	if (is_writable_migration_entry(entry))
+		pmde = maybe_pmd_mkwrite(pmde, vma);
+	else
+		pmde = pmd_wrprotect(pmde);
 
 	if (PageAnon(new)) {
 		rmap_t rmap_flags = RMAP_COMPOUND;
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 833bf2cfd2a3..21e66d7f261d 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -246,6 +246,9 @@ bool __kasan_slab_free(struct kmem_cache *cache, void *object,
 
 static inline bool ____kasan_kfree_large(void *ptr, unsigned long ip)
 {
+	if (!kasan_arch_is_ready())
+		return false;
+
 	if (ptr != page_address(virt_to_head_page(ptr))) {
 		kasan_report_invalid_free(ptr, ip, KASAN_REPORT_INVALID_FREE);
 		return true;
diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
index d8b5590f9484..4967988fb3c6 100644
--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -191,7 +191,12 @@ bool kasan_check_range(unsigned long addr, size_t size, bool write,
 
 bool kasan_byte_accessible(const void *addr)
 {
-	s8 shadow_byte = READ_ONCE(*(s8 *)kasan_mem_to_shadow(addr));
+	s8 shadow_byte;
+
+	if (!kasan_arch_is_ready())
+		return true;
+
+	shadow_byte = READ_ONCE(*(s8 *)kasan_mem_to_shadow(addr));
 
 	return shadow_byte >= 0 && shadow_byte < KASAN_GRANULE_SIZE;
 }
diff --git a/mm/kasan/shadow.c b/mm/kasan/shadow.c
index 0e3648b603a6..ecb7acb3897c 100644
--- a/mm/kasan/shadow.c
+++ b/mm/kasan/shadow.c
@@ -291,6 +291,9 @@ int kasan_populate_vmalloc(unsigned long addr, unsigned long size)
 	unsigned long shadow_start, shadow_end;
 	int ret;
 
+	if (!kasan_arch_is_ready())
+		return 0;
+
 	if (!is_vmalloc_or_module_addr((void *)addr))
 		return 0;
 
@@ -459,6 +462,9 @@ void kasan_release_vmalloc(unsigned long start, unsigned long end,
 	unsigned long region_start, region_end;
 	unsigned long size;
 
+	if (!kasan_arch_is_ready())
+		return;
+
 	region_start = ALIGN(start, KASAN_MEMORY_PER_SHADOW_PAGE);
 	region_end = ALIGN_DOWN(end, KASAN_MEMORY_PER_SHADOW_PAGE);
 
@@ -502,6 +508,9 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
 	 * with setting memory tags, so the KASAN_VMALLOC_INIT flag is ignored.
 	 */
 
+	if (!kasan_arch_is_ready())
+		return (void *)start;
+
 	if (!is_vmalloc_or_module_addr(start))
 		return (void *)start;
 
@@ -524,6 +533,9 @@ void *__kasan_unpoison_vmalloc(const void *start, unsigned long size,
  */
 void __kasan_poison_vmalloc(const void *start, unsigned long size)
 {
+	if (!kasan_arch_is_ready())
+		return;
+
 	if (!is_vmalloc_or_module_addr(start))
 		return;
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e0c7bbd69b33..77a76bcf15f5 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2608,6 +2608,7 @@ static int madvise_collapse_errno(enum scan_result r)
 	case SCAN_CGROUP_CHARGE_FAIL:
 		return -EBUSY;
 	/* Resource temporary unavailable - trying again might succeed */
+	case SCAN_PAGE_COUNT:
 	case SCAN_PAGE_LOCK:
 	case SCAN_PAGE_LRU:
 	case SCAN_DEL_PAGE_LRU:
diff --git a/mm/memblock.c b/mm/memblock.c
index fc3d8fbd2060..511d4783dcf1 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1640,13 +1640,7 @@ void __init memblock_free_late(phys_addr_t base, phys_addr_t size)
 	end = PFN_DOWN(base + size);
 
 	for (; cursor < end; cursor++) {
-		/*
-		 * Reserved pages are always initialized by the end of
-		 * memblock_free_all() (by memmap_init() and, if deferred
-		 * initialization is enabled, memmap_init_reserved_pages()), so
-		 * these pages can be released directly to the buddy allocator.
-		 */
-		__free_pages_core(pfn_to_page(cursor), 0);
+		memblock_free_pages(pfn_to_page(cursor), cursor, 0);
 		totalram_pages_inc();
 	}
 }
diff --git a/mm/migrate.c b/mm/migrate.c
index dff333593a8a..8d5c0dc618a5 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -215,6 +215,8 @@ static bool remove_migration_pte(struct folio *folio,
 			pte = maybe_mkwrite(pte, vma);
 		else if (pte_swp_uffd_wp(*pvmw.pte))
 			pte = pte_mkuffd_wp(pte);
+		else
+			pte = pte_wrprotect(pte);
 
 		if (folio_test_anon(folio) && !is_readable_migration_entry(entry))
 			rmap_flags |= RMAP_EXCLUSIVE;
diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
index b05295bab322..39c3491e28a3 100644
--- a/mm/shrinker_debug.c
+++ b/mm/shrinker_debug.c
@@ -246,18 +246,21 @@ int shrinker_debugfs_rename(struct shrinker *shrinker, const char *fmt, ...)
 }
 EXPORT_SYMBOL(shrinker_debugfs_rename);
 
-void shrinker_debugfs_remove(struct shrinker *shrinker)
+struct dentry *shrinker_debugfs_remove(struct shrinker *shrinker)
 {
+	struct dentry *entry = shrinker->debugfs_entry;
+
 	lockdep_assert_held(&shrinker_rwsem);
 
 	kfree_const(shrinker->name);
 	shrinker->name = NULL;
 
-	if (!shrinker->debugfs_entry)
-		return;
+	if (entry) {
+		ida_free(&shrinker_debugfs_ida, shrinker->debugfs_id);
+		shrinker->debugfs_entry = NULL;
+	}
 
-	debugfs_remove_recursive(shrinker->debugfs_entry);
-	ida_free(&shrinker_debugfs_ida, shrinker->debugfs_id);
+	return entry;
 }
 
 static int __init shrinker_debugfs_init(void)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 96eb9da372cd..dc66f6715bfc 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -740,6 +740,8 @@ EXPORT_SYMBOL(register_shrinker);
  */
 void unregister_shrinker(struct shrinker *shrinker)
 {
+	struct dentry *debugfs_entry;
+
 	if (!(shrinker->flags & SHRINKER_REGISTERED))
 		return;
 
@@ -748,9 +750,11 @@ void unregister_shrinker(struct shrinker *shrinker)
 	shrinker->flags &= ~SHRINKER_REGISTERED;
 	if (shrinker->flags & SHRINKER_MEMCG_AWARE)
 		unregister_memcg_shrinker(shrinker);
-	shrinker_debugfs_remove(shrinker);
+	debugfs_entry = shrinker_debugfs_remove(shrinker);
 	up_write(&shrinker_rwsem);
 
+	debugfs_remove_recursive(debugfs_entry);
+
 	kfree(shrinker->nr_deferred);
 	shrinker->nr_deferred = NULL;
 }
diff --git a/net/core/dev.c b/net/core/dev.c
index 70e06853ba25..7a2a4650a898 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10385,7 +10385,7 @@ void netdev_stats_to_stats64(struct rtnl_link_stats64 *stats64,
 
 	BUILD_BUG_ON(n > sizeof(*stats64) / sizeof(u64));
 	for (i = 0; i < n; i++)
-		dst[i] = atomic_long_read(&src[i]);
+		dst[i] = (unsigned long)atomic_long_read(&src[i]);
 	/* zero out counters that only exist in rtnl_link_stats64 */
 	memset((char *)stats64 + n * sizeof(u64), 0,
 	       sizeof(*stats64) - n * sizeof(u64));
diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 22fa2c5bc6ec..a68a7290a3b2 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -1569,15 +1569,16 @@ void sock_map_unhash(struct sock *sk)
 	psock = sk_psock(sk);
 	if (unlikely(!psock)) {
 		rcu_read_unlock();
-		if (sk->sk_prot->unhash)
-			sk->sk_prot->unhash(sk);
-		return;
+		saved_unhash = READ_ONCE(sk->sk_prot)->unhash;
+	} else {
+		saved_unhash = psock->saved_unhash;
+		sock_map_remove_links(sk, psock);
+		rcu_read_unlock();
 	}
-
-	saved_unhash = psock->saved_unhash;
-	sock_map_remove_links(sk, psock);
-	rcu_read_unlock();
-	saved_unhash(sk);
+	if (WARN_ON_ONCE(saved_unhash == sock_map_unhash))
+		return;
+	if (saved_unhash)
+		saved_unhash(sk);
 }
 EXPORT_SYMBOL_GPL(sock_map_unhash);
 
@@ -1590,17 +1591,18 @@ void sock_map_destroy(struct sock *sk)
 	psock = sk_psock_get(sk);
 	if (unlikely(!psock)) {
 		rcu_read_unlock();
-		if (sk->sk_prot->destroy)
-			sk->sk_prot->destroy(sk);
-		return;
+		saved_destroy = READ_ONCE(sk->sk_prot)->destroy;
+	} else {
+		saved_destroy = psock->saved_destroy;
+		sock_map_remove_links(sk, psock);
+		rcu_read_unlock();
+		sk_psock_stop(psock);
+		sk_psock_put(sk, psock);
 	}
-
-	saved_destroy = psock->saved_destroy;
-	sock_map_remove_links(sk, psock);
-	rcu_read_unlock();
-	sk_psock_stop(psock);
-	sk_psock_put(sk, psock);
-	saved_destroy(sk);
+	if (WARN_ON_ONCE(saved_destroy == sock_map_destroy))
+		return;
+	if (saved_destroy)
+		saved_destroy(sk);
 }
 EXPORT_SYMBOL_GPL(sock_map_destroy);
 
@@ -1615,16 +1617,21 @@ void sock_map_close(struct sock *sk, long timeout)
 	if (unlikely(!psock)) {
 		rcu_read_unlock();
 		release_sock(sk);
-		return sk->sk_prot->close(sk, timeout);
+		saved_close = READ_ONCE(sk->sk_prot)->close;
+	} else {
+		saved_close = psock->saved_close;
+		sock_map_remove_links(sk, psock);
+		rcu_read_unlock();
+		sk_psock_stop(psock);
+		release_sock(sk);
+		cancel_work_sync(&psock->work);
+		sk_psock_put(sk, psock);
 	}
-
-	saved_close = psock->saved_close;
-	sock_map_remove_links(sk, psock);
-	rcu_read_unlock();
-	sk_psock_stop(psock);
-	release_sock(sk);
-	cancel_work_sync(&psock->work);
-	sk_psock_put(sk, psock);
+	/* Make sure we do not recurse. This is a bug.
+	 * Leak the socket instead of crashing on a stack overflow.
+	 */
+	if (WARN_ON_ONCE(saved_close == sock_map_close))
+		return;
 	saved_close(sk, timeout);
 }
 EXPORT_SYMBOL_GPL(sock_map_close);
diff --git a/net/dccp/ipv6.c b/net/dccp/ipv6.c
index 602f3432d80b..7a736c352dc4 100644
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -551,11 +551,9 @@ static struct sock *dccp_v6_request_recv_sock(const struct sock *sk,
 	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash), NULL);
 	/* Clone pktoptions received with SYN, if we own the req */
 	if (*own_req && ireq->pktopts) {
-		newnp->pktoptions = skb_clone(ireq->pktopts, GFP_ATOMIC);
+		newnp->pktoptions = skb_clone_and_charge_r(ireq->pktopts, newsk);
 		consume_skb(ireq->pktopts);
 		ireq->pktopts = NULL;
-		if (newnp->pktoptions)
-			skb_set_owner_r(newnp->pktoptions, newsk);
 	}
 
 	return newsk;
@@ -615,7 +613,7 @@ static int dccp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 					       --ANK (980728)
 	 */
 	if (np->rxopt.all)
-		opt_skb = skb_clone(skb, GFP_ATOMIC);
+		opt_skb = skb_clone_and_charge_r(skb, sk);
 
 	if (sk->sk_state == DCCP_OPEN) { /* Fast path */
 		if (dccp_rcv_established(sk, skb, dccp_hdr(skb), skb->len))
@@ -679,7 +677,6 @@ static int dccp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 			np->flow_label = ip6_flowlabel(ipv6_hdr(opt_skb));
 		if (ipv6_opt_accepted(sk, opt_skb,
 				      &DCCP_SKB_CB(opt_skb)->header.h6)) {
-			skb_set_owner_r(opt_skb, sk);
 			memmove(IP6CB(opt_skb),
 				&DCCP_SKB_CB(opt_skb)->header.h6,
 				sizeof(struct inet6_skb_parm));
diff --git a/net/ipv6/datagram.c b/net/ipv6/datagram.c
index ba28aeb7cade..e70ace403bbd 100644
--- a/net/ipv6/datagram.c
+++ b/net/ipv6/datagram.c
@@ -51,7 +51,7 @@ static void ip6_datagram_flow_key_init(struct flowi6 *fl6, struct sock *sk)
 	fl6->flowi6_mark = sk->sk_mark;
 	fl6->fl6_dport = inet->inet_dport;
 	fl6->fl6_sport = inet->inet_sport;
-	fl6->flowlabel = np->flow_label;
+	fl6->flowlabel = ip6_make_flowinfo(np->tclass, np->flow_label);
 	fl6->flowi6_uid = sk->sk_uid;
 
 	if (!oif)
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index f0548dbcabd2..ea1ecf5fe947 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -272,6 +272,7 @@ static int tcp_v6_connect(struct sock *sk, struct sockaddr *uaddr,
 	fl6.flowi6_proto = IPPROTO_TCP;
 	fl6.daddr = sk->sk_v6_daddr;
 	fl6.saddr = saddr ? *saddr : np->saddr;
+	fl6.flowlabel = ip6_make_flowinfo(np->tclass, np->flow_label);
 	fl6.flowi6_oif = sk->sk_bound_dev_if;
 	fl6.flowi6_mark = sk->sk_mark;
 	fl6.fl6_dport = usin->sin6_port;
@@ -1388,14 +1389,11 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 
 		/* Clone pktoptions received with SYN, if we own the req */
 		if (ireq->pktopts) {
-			newnp->pktoptions = skb_clone(ireq->pktopts,
-						      sk_gfp_mask(sk, GFP_ATOMIC));
+			newnp->pktoptions = skb_clone_and_charge_r(ireq->pktopts, newsk);
 			consume_skb(ireq->pktopts);
 			ireq->pktopts = NULL;
-			if (newnp->pktoptions) {
+			if (newnp->pktoptions)
 				tcp_v6_restore_cb(newnp->pktoptions);
-				skb_set_owner_r(newnp->pktoptions, newsk);
-			}
 		}
 	} else {
 		if (!req_unhash && found_dup_sk) {
@@ -1467,7 +1465,7 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 					       --ANK (980728)
 	 */
 	if (np->rxopt.all)
-		opt_skb = skb_clone(skb, sk_gfp_mask(sk, GFP_ATOMIC));
+		opt_skb = skb_clone_and_charge_r(skb, sk);
 
 	reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	if (sk->sk_state == TCP_ESTABLISHED) { /* Fast path */
@@ -1553,7 +1551,6 @@ int tcp_v6_do_rcv(struct sock *sk, struct sk_buff *skb)
 		if (np->repflow)
 			np->flow_label = ip6_flowlabel(ipv6_hdr(opt_skb));
 		if (ipv6_opt_accepted(sk, opt_skb, &TCP_SKB_CB(opt_skb)->header.h6)) {
-			skb_set_owner_r(opt_skb, sk);
 			tcp_v6_restore_cb(opt_skb);
 			opt_skb = xchg(&np->pktoptions, opt_skb);
 		} else {
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index b52afe316dc4..f1f43894efb8 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1428,6 +1428,7 @@ static int mpls_dev_sysctl_register(struct net_device *dev,
 free:
 	kfree(table);
 out:
+	mdev->sysctl = NULL;
 	return -ENOBUFS;
 }
 
@@ -1437,6 +1438,9 @@ static void mpls_dev_sysctl_unregister(struct net_device *dev,
 	struct net *net = dev_net(dev);
 	struct ctl_table *table;
 
+	if (!mdev->sysctl)
+		return;
+
 	table = mdev->sysctl->ctl_table_arg;
 	unregister_net_sysctl_table(mdev->sysctl);
 	kfree(table);
diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index 9813ed0fde9b..5e38a0abbaba 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -992,8 +992,8 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 {
 	int addrlen = sizeof(struct sockaddr_in);
 	struct sockaddr_storage addr;
-	struct mptcp_sock *msk;
 	struct socket *ssock;
+	struct sock *newsk;
 	int backlog = 1024;
 	int err;
 
@@ -1002,17 +1002,15 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	if (err)
 		return err;
 
-	msk = mptcp_sk(entry->lsk->sk);
-	if (!msk) {
-		err = -EINVAL;
-		goto out;
-	}
+	newsk = entry->lsk->sk;
+	if (!newsk)
+		return -EINVAL;
 
-	ssock = __mptcp_nmpc_socket(msk);
-	if (!ssock) {
-		err = -EINVAL;
-		goto out;
-	}
+	lock_sock(newsk);
+	ssock = __mptcp_nmpc_socket(mptcp_sk(newsk));
+	release_sock(newsk);
+	if (!ssock)
+		return -EINVAL;
 
 	mptcp_info2sockaddr(&entry->addr, &addr, entry->addr.family);
 #if IS_ENABLED(CONFIG_MPTCP_IPV6)
@@ -1022,20 +1020,16 @@ static int mptcp_pm_nl_create_listen_socket(struct sock *sk,
 	err = kernel_bind(ssock, (struct sockaddr *)&addr, addrlen);
 	if (err) {
 		pr_warn("kernel_bind error, err=%d", err);
-		goto out;
+		return err;
 	}
 
 	err = kernel_listen(ssock, backlog);
 	if (err) {
 		pr_warn("kernel_listen error, err=%d", err);
-		goto out;
+		return err;
 	}
 
 	return 0;
-
-out:
-	sock_release(entry->lsk);
-	return err;
 }
 
 int mptcp_pm_nl_get_local_id(struct mptcp_sock *msk, struct sock_common *skc)
@@ -1327,7 +1321,7 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 		return -EINVAL;
 	}
 
-	entry = kmalloc(sizeof(*entry), GFP_KERNEL_ACCOUNT);
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL_ACCOUNT);
 	if (!entry) {
 		GENL_SET_ERR_MSG(info, "can't allocate addr");
 		return -ENOMEM;
@@ -1338,22 +1332,21 @@ static int mptcp_nl_cmd_add_addr(struct sk_buff *skb, struct genl_info *info)
 		ret = mptcp_pm_nl_create_listen_socket(skb->sk, entry);
 		if (ret) {
 			GENL_SET_ERR_MSG(info, "create listen socket error");
-			kfree(entry);
-			return ret;
+			goto out_free;
 		}
 	}
 	ret = mptcp_pm_nl_append_new_local_addr(pernet, entry);
 	if (ret < 0) {
 		GENL_SET_ERR_MSG(info, "too many addresses or duplicate one");
-		if (entry->lsk)
-			sock_release(entry->lsk);
-		kfree(entry);
-		return ret;
+		goto out_free;
 	}
 
 	mptcp_nl_add_subflow_or_signal_addr(sock_net(skb->sk));
-
 	return 0;
+
+out_free:
+	__mptcp_pm_release_addr_entry(entry);
+	return ret;
 }
 
 int mptcp_pm_get_flags_and_ifindex_by_id(struct mptcp_sock *msk, unsigned int id,
diff --git a/net/mptcp/sockopt.c b/net/mptcp/sockopt.c
index c7cb68c725b2..696ba398d699 100644
--- a/net/mptcp/sockopt.c
+++ b/net/mptcp/sockopt.c
@@ -769,17 +769,24 @@ static int mptcp_setsockopt_sol_tcp_defer(struct mptcp_sock *msk, sockptr_t optv
 	return tcp_setsockopt(listener->sk, SOL_TCP, TCP_DEFER_ACCEPT, optval, optlen);
 }
 
-static int mptcp_setsockopt_sol_tcp_fastopen_connect(struct mptcp_sock *msk, sockptr_t optval,
-						     unsigned int optlen)
+static int mptcp_setsockopt_first_sf_only(struct mptcp_sock *msk, int level, int optname,
+					  sockptr_t optval, unsigned int optlen)
 {
+	struct sock *sk = (struct sock *)msk;
 	struct socket *sock;
+	int ret = -EINVAL;
 
-	/* Limit to first subflow */
+	/* Limit to first subflow, before the connection establishment */
+	lock_sock(sk);
 	sock = __mptcp_nmpc_socket(msk);
 	if (!sock)
-		return -EINVAL;
+		goto unlock;
 
-	return tcp_setsockopt(sock->sk, SOL_TCP, TCP_FASTOPEN_CONNECT, optval, optlen);
+	ret = tcp_setsockopt(sock->sk, level, optname, optval, optlen);
+
+unlock:
+	release_sock(sk);
+	return ret;
 }
 
 static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
@@ -811,7 +818,8 @@ static int mptcp_setsockopt_sol_tcp(struct mptcp_sock *msk, int optname,
 	case TCP_DEFER_ACCEPT:
 		return mptcp_setsockopt_sol_tcp_defer(msk, optval, optlen);
 	case TCP_FASTOPEN_CONNECT:
-		return mptcp_setsockopt_sol_tcp_fastopen_connect(msk, optval, optlen);
+		return mptcp_setsockopt_first_sf_only(msk, SOL_TCP, optname,
+						      optval, optlen);
 	}
 
 	return -EOPNOTSUPP;
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 929b0ee8b3d5..c4971bc42f60 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1631,7 +1631,7 @@ int mptcp_subflow_create_socket(struct sock *sk, unsigned short family,
 	if (err)
 		return err;
 
-	lock_sock(sf->sk);
+	lock_sock_nested(sf->sk, SINGLE_DEPTH_NESTING);
 
 	/* the newly created socket has to be in the same cgroup as its parent */
 	mptcp_attach_cgroup(sk, sf->sk);
diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
index 6e38f68f88c2..f2698d2316df 100644
--- a/net/openvswitch/meter.c
+++ b/net/openvswitch/meter.c
@@ -449,7 +449,7 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
 
 	err = attach_meter(meter_tbl, meter);
 	if (err)
-		goto exit_unlock;
+		goto exit_free_old_meter;
 
 	ovs_unlock();
 
@@ -472,6 +472,8 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
 	genlmsg_end(reply, ovs_reply_header);
 	return genlmsg_reply(reply, info);
 
+exit_free_old_meter:
+	ovs_meter_free(old_meter);
 exit_unlock:
 	ovs_unlock();
 	nlmsg_free(reply);
diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 36fefc3957d7..ca2b17f32670 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -488,6 +488,12 @@ static int rose_listen(struct socket *sock, int backlog)
 {
 	struct sock *sk = sock->sk;
 
+	lock_sock(sk);
+	if (sock->state != SS_UNCONNECTED) {
+		release_sock(sk);
+		return -EINVAL;
+	}
+
 	if (sk->sk_state != TCP_LISTEN) {
 		struct rose_sock *rose = rose_sk(sk);
 
@@ -497,8 +503,10 @@ static int rose_listen(struct socket *sock, int backlog)
 		memset(rose->dest_digis, 0, AX25_ADDR_LEN * ROSE_MAX_DIGIS);
 		sk->sk_max_ack_backlog = backlog;
 		sk->sk_state           = TCP_LISTEN;
+		release_sock(sk);
 		return 0;
 	}
+	release_sock(sk);
 
 	return -EOPNOTSUPP;
 }
diff --git a/net/sched/act_ctinfo.c b/net/sched/act_ctinfo.c
index eaa02f098d1c..7275ad869f8e 100644
--- a/net/sched/act_ctinfo.c
+++ b/net/sched/act_ctinfo.c
@@ -91,7 +91,7 @@ static int tcf_ctinfo_act(struct sk_buff *skb, const struct tc_action *a,
 	cp = rcu_dereference_bh(ca->params);
 
 	tcf_lastuse_update(&ca->tcf_tm);
-	bstats_update(&ca->tcf_bstats, skb);
+	tcf_action_update_bstats(&ca->common, skb);
 	action = READ_ONCE(ca->tcf_action);
 
 	wlen = skb_network_offset(skb);
@@ -210,8 +210,8 @@ static int tcf_ctinfo_init(struct net *net, struct nlattr *nla,
 	index = actparm->index;
 	err = tcf_idr_check_alloc(tn, &index, a, bind);
 	if (!err) {
-		ret = tcf_idr_create(tn, index, est, a,
-				     &act_ctinfo_ops, bind, false, flags);
+		ret = tcf_idr_create_from_flags(tn, index, est, a,
+						&act_ctinfo_ops, bind, flags);
 		if (ret) {
 			tcf_idr_cleanup(tn, index);
 			return ret;
diff --git a/net/sched/cls_tcindex.c b/net/sched/cls_tcindex.c
index 4bdcbee4bec5..eea8e185fcdb 100644
--- a/net/sched/cls_tcindex.c
+++ b/net/sched/cls_tcindex.c
@@ -12,6 +12,7 @@
 #include <linux/errno.h>
 #include <linux/slab.h>
 #include <linux/refcount.h>
+#include <linux/rcupdate.h>
 #include <net/act_api.h>
 #include <net/netlink.h>
 #include <net/pkt_cls.h>
@@ -338,6 +339,7 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 	struct tcf_result cr = {};
 	int err, balloc = 0;
 	struct tcf_exts e;
+	bool update_h = false;
 
 	err = tcf_exts_init(&e, net, TCA_TCINDEX_ACT, TCA_TCINDEX_POLICE);
 	if (err < 0)
@@ -455,10 +457,13 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 		}
 	}
 
-	if (cp->perfect)
+	if (cp->perfect) {
 		r = cp->perfect + handle;
-	else
-		r = tcindex_lookup(cp, handle) ? : &new_filter_result;
+	} else {
+		/* imperfect area is updated in-place using rcu */
+		update_h = !!tcindex_lookup(cp, handle);
+		r = &new_filter_result;
+	}
 
 	if (r == &new_filter_result) {
 		f = kzalloc(sizeof(*f), GFP_KERNEL);
@@ -484,7 +489,28 @@ tcindex_set_parms(struct net *net, struct tcf_proto *tp, unsigned long base,
 
 	rcu_assign_pointer(tp->root, cp);
 
-	if (r == &new_filter_result) {
+	if (update_h) {
+		struct tcindex_filter __rcu **fp;
+		struct tcindex_filter *cf;
+
+		f->result.res = r->res;
+		tcf_exts_change(&f->result.exts, &r->exts);
+
+		/* imperfect area bucket */
+		fp = cp->h + (handle % cp->hash);
+
+		/* lookup the filter, guaranteed to exist */
+		for (cf = rcu_dereference_bh_rtnl(*fp); cf;
+		     fp = &cf->next, cf = rcu_dereference_bh_rtnl(*fp))
+			if (cf->key == (u16)handle)
+				break;
+
+		f->next = cf->next;
+
+		cf = rcu_replace_pointer(*fp, f, 1);
+		tcf_exts_get_net(&cf->result.exts);
+		tcf_queue_work(&cf->rwork, tcindex_destroy_fexts_work);
+	} else if (r == &new_filter_result) {
 		struct tcindex_filter *nfp;
 		struct tcindex_filter __rcu **fp;
 
diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 3afac9c21a76..67b1879ea8e1 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -427,7 +427,10 @@ static void htb_activate_prios(struct htb_sched *q, struct htb_class *cl)
 	while (cl->cmode == HTB_MAY_BORROW && p && mask) {
 		m = mask;
 		while (m) {
-			int prio = ffz(~m);
+			unsigned int prio = ffz(~m);
+
+			if (WARN_ON_ONCE(prio >= ARRAY_SIZE(p->inner.clprio)))
+				break;
 			m &= ~(1 << prio);
 
 			if (p->inner.clprio[prio].feed.rb_node)
diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index d9c6d8f30f09..b0ce1080842d 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -343,11 +343,9 @@ static int sctp_sock_filter(struct sctp_endpoint *ep, struct sctp_transport *tsp
 	struct sctp_comm_param *commp = p;
 	struct sock *sk = ep->base.sk;
 	const struct inet_diag_req_v2 *r = commp->r;
-	struct sctp_association *assoc =
-		list_entry(ep->asocs.next, struct sctp_association, asocs);
 
 	/* find the ep only once through the transports by this condition */
-	if (tsp->asoc != assoc)
+	if (!list_is_first(&tsp->asoc->asocs, &ep->asocs))
 		return 0;
 
 	if (r->sdiag_family != AF_UNSPEC && sk->sk_family != r->sdiag_family)
diff --git a/net/socket.c b/net/socket.c
index 73463c7c3702..29a4bad1b1d8 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -971,9 +971,12 @@ static inline void sock_recv_drops(struct msghdr *msg, struct sock *sk,
 static void sock_recv_mark(struct msghdr *msg, struct sock *sk,
 			   struct sk_buff *skb)
 {
-	if (sock_flag(sk, SOCK_RCVMARK) && skb)
-		put_cmsg(msg, SOL_SOCKET, SO_MARK, sizeof(__u32),
-			 &skb->mark);
+	if (sock_flag(sk, SOCK_RCVMARK) && skb) {
+		/* We must use a bounce buffer for CONFIG_HARDENED_USERCOPY=y */
+		__u32 mark = skb->mark;
+
+		put_cmsg(msg, SOL_SOCKET, SO_MARK, sizeof(__u32), &mark);
+	}
 }
 
 void __sock_recv_cmsgs(struct msghdr *msg, struct sock *sk,
diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index e902b01ea3cb..ff5bb9e4731c 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2614,6 +2614,7 @@ static int tipc_connect(struct socket *sock, struct sockaddr *dest,
 		/* Send a 'SYN-' to destination */
 		m.msg_name = dest;
 		m.msg_namelen = destlen;
+		iov_iter_kvec(&m.msg_iter, ITER_SOURCE, NULL, 0, 0);
 
 		/* If connect is in non-blocking case, set MSG_DONTWAIT to
 		 * indicate send_msg() is never blocked.
@@ -2776,6 +2777,7 @@ static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
 		__skb_queue_head(&new_sk->sk_receive_queue, buf);
 		skb_set_owner_r(buf, new_sk);
 	}
+	iov_iter_kvec(&m.msg_iter, ITER_SOURCE, NULL, 0, 0);
 	__tipc_sendstream(new_sock, &m, 0);
 	release_sock(new_sk);
 exit:
diff --git a/sound/pci/hda/hda_bind.c b/sound/pci/hda/hda_bind.c
index 1a868dd9dc4b..890c2f7c33fc 100644
--- a/sound/pci/hda/hda_bind.c
+++ b/sound/pci/hda/hda_bind.c
@@ -144,6 +144,7 @@ static int hda_codec_driver_probe(struct device *dev)
 
  error:
 	snd_hda_codec_cleanup_for_unbind(codec);
+	codec->preset = NULL;
 	return err;
 }
 
@@ -166,6 +167,7 @@ static int hda_codec_driver_remove(struct device *dev)
 	if (codec->patch_ops.free)
 		codec->patch_ops.free(codec);
 	snd_hda_codec_cleanup_for_unbind(codec);
+	codec->preset = NULL;
 	module_put(dev->driver->owner);
 	return 0;
 }
diff --git a/sound/pci/hda/hda_codec.c b/sound/pci/hda/hda_codec.c
index edd653ece70d..2e728aad6771 100644
--- a/sound/pci/hda/hda_codec.c
+++ b/sound/pci/hda/hda_codec.c
@@ -795,7 +795,6 @@ void snd_hda_codec_cleanup_for_unbind(struct hda_codec *codec)
 	snd_array_free(&codec->cvt_setups);
 	snd_array_free(&codec->spdif_out);
 	snd_array_free(&codec->verbs);
-	codec->preset = NULL;
 	codec->follower_dig_outs = NULL;
 	codec->spdif_status_reset = 0;
 	snd_array_free(&codec->mixers);
@@ -928,7 +927,6 @@ snd_hda_codec_device_init(struct hda_bus *bus, unsigned int codec_addr,
 	codec->depop_delay = -1;
 	codec->fixup_id = HDA_FIXUP_ID_NOT_SET;
 	codec->core.dev.release = snd_hda_codec_dev_release;
-	codec->core.exec_verb = codec_exec_verb;
 	codec->core.type = HDA_DEV_LEGACY;
 
 	mutex_init(&codec->spdif_mutex);
@@ -999,6 +997,7 @@ int snd_hda_codec_device_new(struct hda_bus *bus, struct snd_card *card,
 	if (snd_BUG_ON(codec_addr > HDA_MAX_CODEC_ADDRESS))
 		return -EINVAL;
 
+	codec->core.exec_verb = codec_exec_verb;
 	codec->card = card;
 	codec->addr = codec_addr;
 
diff --git a/sound/pci/hda/patch_conexant.c b/sound/pci/hda/patch_conexant.c
index 7b1a30a551f6..75e1d00074b9 100644
--- a/sound/pci/hda/patch_conexant.c
+++ b/sound/pci/hda/patch_conexant.c
@@ -1125,6 +1125,7 @@ static const struct hda_device_id snd_hda_id_conexant[] = {
 	HDA_CODEC_ENTRY(0x14f11f87, "SN6140", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f12008, "CX8200", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f120d0, "CX11970", patch_conexant_auto),
+	HDA_CODEC_ENTRY(0x14f120d1, "SN6180", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15045, "CX20549 (Venice)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15047, "CX20551 (Waikiki)", patch_conexant_auto),
 	HDA_CODEC_ENTRY(0x14f15051, "CX20561 (Hermosa)", patch_conexant_auto),
diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 1134a493d225..e103bb3693c0 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -832,7 +832,7 @@ static int alc_subsystem_id(struct hda_codec *codec, const hda_nid_t *ports)
 			alc_setup_gpio(codec, 0x02);
 			break;
 		case 7:
-			alc_setup_gpio(codec, 0x03);
+			alc_setup_gpio(codec, 0x04);
 			break;
 		case 5:
 		default:
@@ -9432,10 +9432,17 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	 SND_PCI_QUIRK(0x103c, 0x8abb, "HP ZBook Firefly 14 G9", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad1, "HP EliteBook 840 14 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8ad2, "HP EliteBook 860 16 inch G9 Notebook PC", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b42, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b43, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b44, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b45, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b46, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b47, "HP", ALC245_FIXUP_CS35L41_SPI_2_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b5d, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b5e, "HP", ALC236_FIXUP_HP_MUTE_LED_MICMUTE_VREF),
 	SND_PCI_QUIRK(0x103c, 0x8b7a, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b7d, "HP", ALC236_FIXUP_HP_GPIO_LED),
+	SND_PCI_QUIRK(0x103c, 0x8b87, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b8a, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b8b, "HP", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x8b8d, "HP", ALC236_FIXUP_HP_GPIO_LED),
diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 0d283e41f66d..36314753923b 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -227,6 +227,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Redmi Book Pro 14 2022"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "TIMI"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Redmi Book Pro 15 2022"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
@@ -234,6 +241,20 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Blade 14 (2022) - RZ09-0427"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "RB"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Swift SFA16-41"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "IRBIS"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "15NBC1011"),
+		}
+	},
 	{}
 };
 
diff --git a/sound/soc/codecs/cs42l56.c b/sound/soc/codecs/cs42l56.c
index 26066682c983..3b0e715549c9 100644
--- a/sound/soc/codecs/cs42l56.c
+++ b/sound/soc/codecs/cs42l56.c
@@ -1191,18 +1191,12 @@ static int cs42l56_i2c_probe(struct i2c_client *i2c_client)
 	if (pdata) {
 		cs42l56->pdata = *pdata;
 	} else {
-		pdata = devm_kzalloc(&i2c_client->dev, sizeof(*pdata),
-				     GFP_KERNEL);
-		if (!pdata)
-			return -ENOMEM;
-
 		if (i2c_client->dev.of_node) {
 			ret = cs42l56_handle_of_data(i2c_client,
 						     &cs42l56->pdata);
 			if (ret != 0)
 				return ret;
 		}
-		cs42l56->pdata = *pdata;
 	}
 
 	if (cs42l56->pdata.gpio_nreset) {
diff --git a/sound/soc/intel/boards/sof_cs42l42.c b/sound/soc/intel/boards/sof_cs42l42.c
index e38bd2831e6a..e9d190cb13b0 100644
--- a/sound/soc/intel/boards/sof_cs42l42.c
+++ b/sound/soc/intel/boards/sof_cs42l42.c
@@ -336,6 +336,9 @@ static int create_spk_amp_dai_links(struct device *dev,
 	links[*id].platforms = platform_component;
 	links[*id].num_platforms = ARRAY_SIZE(platform_component);
 	links[*id].dpcm_playback = 1;
+	/* firmware-generated echo reference */
+	links[*id].dpcm_capture = 1;
+
 	links[*id].no_pcm = 1;
 	links[*id].cpus = &cpus[*id];
 	links[*id].num_cpus = 1;
diff --git a/sound/soc/intel/boards/sof_nau8825.c b/sound/soc/intel/boards/sof_nau8825.c
index 009a41fbefa1..0c723d4d2d63 100644
--- a/sound/soc/intel/boards/sof_nau8825.c
+++ b/sound/soc/intel/boards/sof_nau8825.c
@@ -479,8 +479,6 @@ static struct snd_soc_dai_link *sof_card_dai_links_create(struct device *dev,
 			links[id].num_codecs = ARRAY_SIZE(max_98373_components);
 			links[id].init = max_98373_spk_codec_init;
 			links[id].ops = &max_98373_ops;
-			/* feedback stream */
-			links[id].dpcm_capture = 1;
 		} else if (sof_nau8825_quirk &
 				SOF_MAX98360A_SPEAKER_AMP_PRESENT) {
 			max_98360a_dai_link(&links[id]);
@@ -493,6 +491,9 @@ static struct snd_soc_dai_link *sof_card_dai_links_create(struct device *dev,
 		links[id].platforms = platform_component;
 		links[id].num_platforms = ARRAY_SIZE(platform_component);
 		links[id].dpcm_playback = 1;
+		/* feedback stream or firmware-generated echo reference */
+		links[id].dpcm_capture = 1;
+
 		links[id].no_pcm = 1;
 		links[id].cpus = &cpus[id];
 		links[id].num_cpus = 1;
diff --git a/sound/soc/intel/boards/sof_rt5682.c b/sound/soc/intel/boards/sof_rt5682.c
index 2358be208c1f..59c58ef932e4 100644
--- a/sound/soc/intel/boards/sof_rt5682.c
+++ b/sound/soc/intel/boards/sof_rt5682.c
@@ -761,8 +761,6 @@ static struct snd_soc_dai_link *sof_card_dai_links_create(struct device *dev,
 			links[id].num_codecs = ARRAY_SIZE(max_98373_components);
 			links[id].init = max_98373_spk_codec_init;
 			links[id].ops = &max_98373_ops;
-			/* feedback stream */
-			links[id].dpcm_capture = 1;
 		} else if (sof_rt5682_quirk &
 				SOF_MAX98360A_SPEAKER_AMP_PRESENT) {
 			max_98360a_dai_link(&links[id]);
@@ -789,6 +787,9 @@ static struct snd_soc_dai_link *sof_card_dai_links_create(struct device *dev,
 		links[id].platforms = platform_component;
 		links[id].num_platforms = ARRAY_SIZE(platform_component);
 		links[id].dpcm_playback = 1;
+		/* feedback stream or firmware-generated echo reference */
+		links[id].dpcm_capture = 1;
+
 		links[id].no_pcm = 1;
 		links[id].cpus = &cpus[id];
 		links[id].num_cpus = 1;
diff --git a/sound/soc/intel/boards/sof_ssp_amp.c b/sound/soc/intel/boards/sof_ssp_amp.c
index 94d25aeb6e7c..7b74f122e340 100644
--- a/sound/soc/intel/boards/sof_ssp_amp.c
+++ b/sound/soc/intel/boards/sof_ssp_amp.c
@@ -258,13 +258,12 @@ static struct snd_soc_dai_link *sof_card_dai_links_create(struct device *dev,
 		sof_rt1308_dai_link(&links[id]);
 	} else if (sof_ssp_amp_quirk & SOF_CS35L41_SPEAKER_AMP_PRESENT) {
 		cs35l41_set_dai_link(&links[id]);
-
-		/* feedback from amplifier */
-		links[id].dpcm_capture = 1;
 	}
 	links[id].platforms = platform_component;
 	links[id].num_platforms = ARRAY_SIZE(platform_component);
 	links[id].dpcm_playback = 1;
+	/* feedback from amplifier or firmware-generated echo reference */
+	links[id].dpcm_capture = 1;
 	links[id].no_pcm = 1;
 	links[id].cpus = &cpus[id];
 	links[id].num_cpus = 1;
diff --git a/sound/soc/sof/intel/hda-dai.c b/sound/soc/sof/intel/hda-dai.c
index 556e883a32ed..5f03ee390d54 100644
--- a/sound/soc/sof/intel/hda-dai.c
+++ b/sound/soc/sof/intel/hda-dai.c
@@ -216,6 +216,10 @@ static int hda_link_dma_hw_params(struct snd_pcm_substream *substream,
 	struct hdac_bus *bus = hstream->bus;
 	struct hdac_ext_link *link;
 
+	link = snd_hdac_ext_bus_get_link(bus, codec_dai->component->name);
+	if (!link)
+		return -EINVAL;
+
 	hext_stream = snd_soc_dai_get_dma_data(cpu_dai, substream);
 	if (!hext_stream) {
 		hext_stream = hda_link_stream_assign(bus, substream);
@@ -225,10 +229,6 @@ static int hda_link_dma_hw_params(struct snd_pcm_substream *substream,
 		snd_soc_dai_set_dma_data(cpu_dai, substream, (void *)hext_stream);
 	}
 
-	link = snd_hdac_ext_bus_get_link(bus, codec_dai->component->name);
-	if (!link)
-		return -EINVAL;
-
 	/* set the hdac_stream in the codec dai */
 	snd_soc_dai_set_stream(codec_dai, hdac_stream(hext_stream), substream->stream);
 
diff --git a/sound/soc/sof/sof-audio.c b/sound/soc/sof/sof-audio.c
index 2df433c6ef55..cf2c0db57d89 100644
--- a/sound/soc/sof/sof-audio.c
+++ b/sound/soc/sof/sof-audio.c
@@ -431,11 +431,11 @@ sof_walk_widgets_in_order(struct snd_sof_dev *sdev, struct snd_soc_dapm_widget_l
 
 	for_each_dapm_widgets(list, i, widget) {
 		/* starting widget for playback is AIF type */
-		if (dir == SNDRV_PCM_STREAM_PLAYBACK && !WIDGET_IS_AIF(widget->id))
+		if (dir == SNDRV_PCM_STREAM_PLAYBACK && widget->id != snd_soc_dapm_aif_in)
 			continue;
 
 		/* starting widget for capture is DAI type */
-		if (dir == SNDRV_PCM_STREAM_CAPTURE && !WIDGET_IS_DAI(widget->id))
+		if (dir == SNDRV_PCM_STREAM_CAPTURE && widget->id != snd_soc_dapm_dai_out)
 			continue;
 
 		switch (op) {
diff --git a/sound/usb/quirks.c b/sound/usb/quirks.c
index 3d13fdf7590c..3ecd1ba7fd4b 100644
--- a/sound/usb/quirks.c
+++ b/sound/usb/quirks.c
@@ -2152,6 +2152,8 @@ static const struct usb_audio_quirk_flags_table quirk_flags_table[] = {
 		   QUIRK_FLAG_GENERIC_IMPLICIT_FB),
 	DEVICE_FLG(0x0525, 0xa4ad, /* Hamedal C20 usb camero */
 		   QUIRK_FLAG_IFACE_SKIP_CLOSE),
+	DEVICE_FLG(0x0ecb, 0x205c, /* JBL Quantum610 Wireless */
+		   QUIRK_FLAG_FIXED_RATE),
 	DEVICE_FLG(0x0ecb, 0x2069, /* JBL Quantum810 Wireless */
 		   QUIRK_FLAG_FIXED_RATE),
 
diff --git a/tools/testing/memblock/internal.h b/tools/testing/memblock/internal.h
index 85973e55489e..fdb7f5db7308 100644
--- a/tools/testing/memblock/internal.h
+++ b/tools/testing/memblock/internal.h
@@ -15,10 +15,6 @@ bool mirrored_kernelcore = false;
 
 struct page {};
 
-void __free_pages_core(struct page *page, unsigned int order)
-{
-}
-
 void memblock_free_pages(struct page *page, unsigned long pfn,
 			 unsigned int order)
 {
diff --git a/tools/testing/selftests/bpf/verifier/search_pruning.c b/tools/testing/selftests/bpf/verifier/search_pruning.c
index 68b14fdfebdb..d63fd8991b03 100644
--- a/tools/testing/selftests/bpf/verifier/search_pruning.c
+++ b/tools/testing/selftests/bpf/verifier/search_pruning.c
@@ -225,3 +225,39 @@
 	.result_unpriv = ACCEPT,
 	.insn_processed = 15,
 },
+/* The test performs a conditional 64-bit write to a stack location
+ * fp[-8], this is followed by an unconditional 8-bit write to fp[-8],
+ * then data is read from fp[-8]. This sequence is unsafe.
+ *
+ * The test would be mistakenly marked as safe w/o dst register parent
+ * preservation in verifier.c:copy_register_state() function.
+ *
+ * Note the usage of BPF_F_TEST_STATE_FREQ to force creation of the
+ * checkpoint state after conditional 64-bit assignment.
+ */
+{
+	"write tracking and register parent chain bug",
+	.insns = {
+	/* r6 = ktime_get_ns() */
+	BPF_EMIT_CALL(BPF_FUNC_ktime_get_ns),
+	BPF_MOV64_REG(BPF_REG_6, BPF_REG_0),
+	/* r0 = ktime_get_ns() */
+	BPF_EMIT_CALL(BPF_FUNC_ktime_get_ns),
+	/* if r0 > r6 goto +1 */
+	BPF_JMP_REG(BPF_JGT, BPF_REG_0, BPF_REG_6, 1),
+	/* *(u64 *)(r10 - 8) = 0xdeadbeef */
+	BPF_ST_MEM(BPF_DW, BPF_REG_FP, -8, 0xdeadbeef),
+	/* r1 = 42 */
+	BPF_MOV64_IMM(BPF_REG_1, 42),
+	/* *(u8 *)(r10 - 8) = r1 */
+	BPF_STX_MEM(BPF_B, BPF_REG_FP, BPF_REG_1, -8),
+	/* r2 = *(u64 *)(r10 - 8) */
+	BPF_LDX_MEM(BPF_DW, BPF_REG_2, BPF_REG_FP, -8),
+	/* exit(0) */
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.flags = BPF_F_TEST_STATE_FREQ,
+	.errstr = "invalid read from stack off -8+1 size 8",
+	.result = REJECT,
+},
diff --git a/tools/testing/selftests/net/cmsg_ipv6.sh b/tools/testing/selftests/net/cmsg_ipv6.sh
index 2d89cb0ad288..330d0b1ceced 100755
--- a/tools/testing/selftests/net/cmsg_ipv6.sh
+++ b/tools/testing/selftests/net/cmsg_ipv6.sh
@@ -6,7 +6,7 @@ ksft_skip=4
 NS=ns
 IP6=2001:db8:1::1/64
 TGT6=2001:db8:1::2
-TMPF=`mktemp`
+TMPF=$(mktemp --suffix ".pcap")
 
 cleanup()
 {
diff --git a/tools/testing/selftests/net/mptcp/userspace_pm.sh b/tools/testing/selftests/net/mptcp/userspace_pm.sh
index 0040e3bc7b16..ad6547c79b83 100755
--- a/tools/testing/selftests/net/mptcp/userspace_pm.sh
+++ b/tools/testing/selftests/net/mptcp/userspace_pm.sh
@@ -778,6 +778,14 @@ test_subflows()
 
 test_subflows_v4_v6_mix()
 {
+	local client_evts
+	client_evts=$(mktemp)
+	# Capture events on the network namespace running the client
+	:>"$client_evts"
+	ip netns exec "$ns2" ./pm_nl_ctl events >> "$client_evts" 2>&1 &
+	evts_pid=$!
+	sleep 0.5
+
 	# Attempt to add a listener at 10.0.2.1:<subflow-port>
 	ip netns exec "$ns1" ./pm_nl_ctl listen 10.0.2.1\
 	   $app6_port > /dev/null 2>&1 &
@@ -820,6 +828,9 @@ test_subflows_v4_v6_mix()
 	ip netns exec "$ns1" ./pm_nl_ctl rem id $server_addr_id token\
 	   "$server6_token" > /dev/null 2>&1
 	sleep 0.5
+
+	kill_wait $evts_pid
+	rm -f "$client_evts"
 }
 
 test_prio()
diff --git a/tools/virtio/linux/bug.h b/tools/virtio/linux/bug.h
index 813baf13f62a..51a919083d9b 100644
--- a/tools/virtio/linux/bug.h
+++ b/tools/virtio/linux/bug.h
@@ -1,13 +1,11 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#ifndef BUG_H
-#define BUG_H
+#ifndef _LINUX_BUG_H
+#define _LINUX_BUG_H
 
 #include <asm/bug.h>
 
 #define BUG_ON(__BUG_ON_cond) assert(!(__BUG_ON_cond))
 
-#define BUILD_BUG_ON(x)
-
 #define BUG() abort()
 
-#endif /* BUG_H */
+#endif /* _LINUX_BUG_H */
diff --git a/tools/virtio/linux/build_bug.h b/tools/virtio/linux/build_bug.h
new file mode 100644
index 000000000000..cdbb75e28a60
--- /dev/null
+++ b/tools/virtio/linux/build_bug.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_BUILD_BUG_H
+#define _LINUX_BUILD_BUG_H
+
+#define BUILD_BUG_ON(x)
+
+#endif	/* _LINUX_BUILD_BUG_H */
diff --git a/tools/virtio/linux/cpumask.h b/tools/virtio/linux/cpumask.h
new file mode 100644
index 000000000000..307da69d6b26
--- /dev/null
+++ b/tools/virtio/linux/cpumask.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_CPUMASK_H
+#define _LINUX_CPUMASK_H
+
+#include <linux/kernel.h>
+
+#endif /* _LINUX_CPUMASK_H */
diff --git a/tools/virtio/linux/gfp.h b/tools/virtio/linux/gfp.h
new file mode 100644
index 000000000000..43d146f236f1
--- /dev/null
+++ b/tools/virtio/linux/gfp.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __LINUX_GFP_H
+#define __LINUX_GFP_H
+
+#include <linux/topology.h>
+
+#endif
diff --git a/tools/virtio/linux/kernel.h b/tools/virtio/linux/kernel.h
index 21593bf97755..8b877167933d 100644
--- a/tools/virtio/linux/kernel.h
+++ b/tools/virtio/linux/kernel.h
@@ -10,6 +10,7 @@
 #include <stdarg.h>
 
 #include <linux/compiler.h>
+#include <linux/log2.h>
 #include <linux/types.h>
 #include <linux/overflow.h>
 #include <linux/list.h>
diff --git a/tools/virtio/linux/kmsan.h b/tools/virtio/linux/kmsan.h
new file mode 100644
index 000000000000..272b5aa285d5
--- /dev/null
+++ b/tools/virtio/linux/kmsan.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_KMSAN_H
+#define _LINUX_KMSAN_H
+
+#include <linux/gfp.h>
+
+inline void kmsan_handle_dma(struct page *page, size_t offset, size_t size,
+			     enum dma_data_direction dir)
+{
+}
+
+#endif /* _LINUX_KMSAN_H */
diff --git a/tools/virtio/linux/scatterlist.h b/tools/virtio/linux/scatterlist.h
index 369ee308b668..74d9e1825748 100644
--- a/tools/virtio/linux/scatterlist.h
+++ b/tools/virtio/linux/scatterlist.h
@@ -2,6 +2,7 @@
 #ifndef SCATTERLIST_H
 #define SCATTERLIST_H
 #include <linux/kernel.h>
+#include <linux/bug.h>
 
 struct scatterlist {
 	unsigned long	page_link;
diff --git a/tools/virtio/linux/topology.h b/tools/virtio/linux/topology.h
new file mode 100644
index 000000000000..910794afb993
--- /dev/null
+++ b/tools/virtio/linux/topology.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _LINUX_TOPOLOGY_H
+#define _LINUX_TOPOLOGY_H
+
+#include <linux/cpumask.h>
+
+#endif /* _LINUX_TOPOLOGY_H */
