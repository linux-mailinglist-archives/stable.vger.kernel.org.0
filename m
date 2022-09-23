Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D964A5E7B0D
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 14:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231652AbiIWMrc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 08:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiIWMr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 08:47:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EC8D13570D;
        Fri, 23 Sep 2022 05:47:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D41060F95;
        Fri, 23 Sep 2022 12:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB88C433C1;
        Fri, 23 Sep 2022 12:47:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663937244;
        bh=vVnW7n93ikss4MT/tY33T53Kr3JsKFx2t9Ag9B7NLn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WrI5TX00mKB/giTluwdzEf8/iDsXLATdFI6Mzyu8OyZh+s7eT42B/TGzh1RxECXz0
         bdM9NNPi3sIzrMtA9Hxv5yANxA/Dr4OG04VZsYZ9dAbcv/KGpTLzM7JtC/MZfs3w1R
         WkcXWtJo2IQjOrEjeH9s5fVQyhs2T7Fz5gSj0nlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.15.70
Date:   Fri, 23 Sep 2022 14:47:12 +0200
Message-Id: <166393723120267@kroah.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <1663937231121107@kroah.com>
References: <1663937231121107@kroah.com>
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
index 2134d5711dcc..e815677ec011 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 15
-SUBLEVEL = 69
+SUBLEVEL = 70
 EXTRAVERSION =
 NAME = Trick or Treat
 
diff --git a/arch/arm64/boot/dts/arm/juno-base.dtsi b/arch/arm64/boot/dts/arm/juno-base.dtsi
index a2635b14da30..34e5549ea748 100644
--- a/arch/arm64/boot/dts/arm/juno-base.dtsi
+++ b/arch/arm64/boot/dts/arm/juno-base.dtsi
@@ -26,7 +26,8 @@ mailbox: mhu@2b1f0000 {
 		compatible = "arm,mhu", "arm,primecell";
 		reg = <0x0 0x2b1f0000 0x0 0x1000>;
 		interrupts = <GIC_SPI 36 IRQ_TYPE_LEVEL_HIGH>,
-			     <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>;
+			     <GIC_SPI 35 IRQ_TYPE_LEVEL_HIGH>,
+			     <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
 		#mbox-cells = <1>;
 		clocks = <&soc_refclk100mhz>;
 		clock-names = "apb_pclk";
diff --git a/arch/mips/cavium-octeon/octeon-irq.c b/arch/mips/cavium-octeon/octeon-irq.c
index be5d4afcd30f..353dfeee0a6d 100644
--- a/arch/mips/cavium-octeon/octeon-irq.c
+++ b/arch/mips/cavium-octeon/octeon-irq.c
@@ -127,6 +127,16 @@ static void octeon_irq_free_cd(struct irq_domain *d, unsigned int irq)
 static int octeon_irq_force_ciu_mapping(struct irq_domain *domain,
 					int irq, int line, int bit)
 {
+	struct device_node *of_node;
+	int ret;
+
+	of_node = irq_domain_get_of_node(domain);
+	if (!of_node)
+		return -EINVAL;
+	ret = irq_alloc_desc_at(irq, of_node_to_nid(of_node));
+	if (ret < 0)
+		return ret;
+
 	return irq_domain_associate(domain, irq, line << 6 | bit);
 }
 
diff --git a/arch/parisc/Kconfig b/arch/parisc/Kconfig
index e6542e44cade..117b0f882750 100644
--- a/arch/parisc/Kconfig
+++ b/arch/parisc/Kconfig
@@ -220,8 +220,18 @@ config MLONGCALLS
 	  Enabling this option will probably slow down your kernel.
 
 config 64BIT
-	def_bool "$(ARCH)" = "parisc64"
+	def_bool y if "$(ARCH)" = "parisc64"
+	bool "64-bit kernel" if "$(ARCH)" = "parisc"
 	depends on PA8X00
+	help
+	  Enable this if you want to support 64bit kernel on PA-RISC platform.
+
+	  At the moment, only people willing to use more than 2GB of RAM,
+	  or having a 64bit-only capable PA-RISC machine should say Y here.
+
+	  Since there is no 64bit userland on PA-RISC, there is no point to
+	  enable this option otherwise. The 64bit kernel is significantly bigger
+	  and slower than the 32bit one.
 
 choice
 	prompt "Kernel page size"
diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 9e50da3ed01a..23ea8a25cbbe 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -115,6 +115,7 @@ KVM_X86_OP(enable_smi_window)
 KVM_X86_OP_NULL(mem_enc_op)
 KVM_X86_OP_NULL(mem_enc_reg_region)
 KVM_X86_OP_NULL(mem_enc_unreg_region)
+KVM_X86_OP_NULL(guest_memory_reclaimed)
 KVM_X86_OP(get_msr_feature)
 KVM_X86_OP(can_emulate_instruction)
 KVM_X86_OP(apic_init_signal_blocked)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 74b5819120da..9e800d4d323c 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1476,6 +1476,7 @@ struct kvm_x86_ops {
 	int (*mem_enc_reg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*mem_enc_unreg_region)(struct kvm *kvm, struct kvm_enc_region *argp);
 	int (*vm_copy_enc_context_from)(struct kvm *kvm, unsigned int source_fd);
+	void (*guest_memory_reclaimed)(struct kvm *kvm);
 
 	int (*get_msr_feature)(struct kvm_msr_entry *entry);
 
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 86f3096f042f..eeedcb3d40e8 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2037,6 +2037,14 @@ static void sev_flush_guest_memory(struct vcpu_svm *svm, void *va,
 	wbinvd_on_all_cpus();
 }
 
+void sev_guest_memory_reclaimed(struct kvm *kvm)
+{
+	if (!sev_guest(kvm))
+		return;
+
+	wbinvd_on_all_cpus();
+}
+
 void sev_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 2947e3c965e3..49bb3db2761a 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4678,6 +4678,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.mem_enc_op = svm_mem_enc_op,
 	.mem_enc_reg_region = svm_register_enc_region,
 	.mem_enc_unreg_region = svm_unregister_enc_region,
+	.guest_memory_reclaimed = sev_guest_memory_reclaimed,
 
 	.vm_copy_enc_context_from = svm_vm_copy_asid_from,
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index cf2d8365aeb4..7004f356edf9 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -555,6 +555,8 @@ int svm_register_enc_region(struct kvm *kvm,
 int svm_unregister_enc_region(struct kvm *kvm,
 			      struct kvm_enc_region *range);
 int svm_vm_copy_asid_from(struct kvm *kvm, unsigned int source_fd);
+void sev_guest_memory_reclaimed(struct kvm *kvm);
+
 void pre_sev_run(struct vcpu_svm *svm, int cpu);
 void __init sev_set_cpu_caps(void);
 void __init sev_hardware_setup(void);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 9109e5589b42..11e73d02fb3a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9557,6 +9557,11 @@ void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 		kvm_make_all_cpus_request(kvm, KVM_REQ_APIC_PAGE_RELOAD);
 }
 
+void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
+{
+	static_call_cond(kvm_x86_guest_memory_reclaimed)(kvm);
+}
+
 void kvm_vcpu_reload_apic_access_page(struct kvm_vcpu *vcpu)
 {
 	if (!lapic_in_kernel(vcpu))
diff --git a/block/blk-core.c b/block/blk-core.c
index 5009b9f1c3c9..13e1fca1e923 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -447,7 +447,7 @@ int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
 
 	while (!blk_try_enter_queue(q, pm)) {
 		if (flags & BLK_MQ_REQ_NOWAIT)
-			return -EBUSY;
+			return -EAGAIN;
 
 		/*
 		 * read pair of barrier in blk_freeze_queue_start(), we need to
@@ -478,7 +478,7 @@ static inline int bio_queue_enter(struct bio *bio)
 			if (test_bit(GD_DEAD, &disk->state))
 				goto dead;
 			bio_wouldblock_error(bio);
-			return -EBUSY;
+			return -EAGAIN;
 		}
 
 		/*
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.c
index 849f8dff0be1..8ed450125c92 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -315,16 +315,9 @@ static inline void binder_alloc_set_vma(struct binder_alloc *alloc,
 {
 	unsigned long vm_start = 0;
 
-	/*
-	 * Allow clearing the vma with holding just the read lock to allow
-	 * munmapping downgrade of the write lock before freeing and closing the
-	 * file using binder_alloc_vma_close().
-	 */
 	if (vma) {
 		vm_start = vma->vm_start;
 		mmap_assert_write_locked(alloc->vma_vm_mm);
-	} else {
-		mmap_assert_locked(alloc->vma_vm_mm);
 	}
 
 	alloc->vma_addr = vm_start;
diff --git a/drivers/gpio/gpio-mpc8xxx.c b/drivers/gpio/gpio-mpc8xxx.c
index a964e25ea620..763256efddc2 100644
--- a/drivers/gpio/gpio-mpc8xxx.c
+++ b/drivers/gpio/gpio-mpc8xxx.c
@@ -172,6 +172,7 @@ static int mpc8xxx_irq_set_type(struct irq_data *d, unsigned int flow_type)
 
 	switch (flow_type) {
 	case IRQ_TYPE_EDGE_FALLING:
+	case IRQ_TYPE_LEVEL_LOW:
 		raw_spin_lock_irqsave(&mpc8xxx_gc->lock, flags);
 		gc->write_reg(mpc8xxx_gc->regs + GPIO_ICR,
 			gc->read_reg(mpc8xxx_gc->regs + GPIO_ICR)
diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index 22b8f0aa80f1..f31b0947eaaa 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -418,11 +418,11 @@ static int rockchip_irq_set_type(struct irq_data *d, unsigned int type)
 			goto out;
 		} else {
 			bank->toggle_edge_mode |= mask;
-			level |= mask;
+			level &= ~mask;
 
 			/*
 			 * Determine gpio state. If 1 next interrupt should be
-			 * falling otherwise rising.
+			 * low otherwise high.
 			 */
 			data = readl(bank->reg_base + bank->gpio_regs->ext_port);
 			if (data & mask)
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
index b184b656b9b6..6f21154d4891 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v2_3.c
@@ -366,6 +366,7 @@ static void nbio_v2_3_enable_aspm(struct amdgpu_device *adev,
 		WREG32_PCIE(smnPCIE_LC_CNTL, data);
 }
 
+#ifdef CONFIG_PCIEASPM
 static void nbio_v2_3_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
@@ -387,9 +388,11 @@ static void nbio_v2_3_program_ltr(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
 }
+#endif
 
 static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
 {
+#ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
 
 	def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
@@ -445,7 +448,10 @@ static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
 
-	nbio_v2_3_program_ltr(adev);
+	/* Don't bother about LTR if LTR is not enabled
+	 * in the path */
+	if (adev->pdev->ltr_path)
+		nbio_v2_3_program_ltr(adev);
 
 	def = data = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
@@ -469,6 +475,7 @@ static void nbio_v2_3_program_aspm(struct amdgpu_device *adev)
 	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
+#endif
 }
 
 static void nbio_v2_3_apply_lc_spc_mode_wa(struct amdgpu_device *adev)
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
index 0d2d629e2d6a..be3f6c52c3ff 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v6_1.c
@@ -278,6 +278,7 @@ static void nbio_v6_1_init_registers(struct amdgpu_device *adev)
 		WREG32_PCIE(smnPCIE_CI_CNTL, data);
 }
 
+#ifdef CONFIG_PCIEASPM
 static void nbio_v6_1_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
@@ -299,9 +300,11 @@ static void nbio_v6_1_program_ltr(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
 }
+#endif
 
 static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
 {
+#ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
 
 	def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
@@ -357,7 +360,10 @@ static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
 
-	nbio_v6_1_program_ltr(adev);
+	/* Don't bother about LTR if LTR is not enabled
+	 * in the path */
+	if (adev->pdev->ltr_path)
+		nbio_v6_1_program_ltr(adev);
 
 	def = data = RREG32_PCIE(smnRCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
@@ -381,6 +387,7 @@ static void nbio_v6_1_program_aspm(struct amdgpu_device *adev)
 	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
+#endif
 }
 
 const struct amdgpu_nbio_funcs nbio_v6_1_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
index f50045cebd44..74cd7543729b 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
@@ -630,6 +630,7 @@ const struct amdgpu_nbio_ras_funcs nbio_v7_4_ras_funcs = {
 	.ras_fini = amdgpu_nbio_ras_fini,
 };
 
+#ifdef CONFIG_PCIEASPM
 static void nbio_v7_4_program_ltr(struct amdgpu_device *adev)
 {
 	uint32_t def, data;
@@ -651,9 +652,11 @@ static void nbio_v7_4_program_ltr(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnBIF_CFG_DEV0_EPF0_DEVICE_CNTL2, data);
 }
+#endif
 
 static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
 {
+#ifdef CONFIG_PCIEASPM
 	uint32_t def, data;
 
 	def = data = RREG32_PCIE(smnPCIE_LC_CNTL);
@@ -709,7 +712,10 @@ static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL6, data);
 
-	nbio_v7_4_program_ltr(adev);
+	/* Don't bother about LTR if LTR is not enabled
+	 * in the path */
+	if (adev->pdev->ltr_path)
+		nbio_v7_4_program_ltr(adev);
 
 	def = data = RREG32_PCIE(smnRCC_BIF_STRAP3);
 	data |= 0x5DE0 << RCC_BIF_STRAP3__STRAP_VLINK_ASPM_IDLE_TIMER__SHIFT;
@@ -733,6 +739,7 @@ static void nbio_v7_4_program_aspm(struct amdgpu_device *adev)
 	data &= ~PCIE_LC_CNTL3__LC_DSC_DONT_ENTER_L23_AFTER_PME_ACK_MASK;
 	if (def != data)
 		WREG32_PCIE(smnPCIE_LC_CNTL3, data);
+#endif
 }
 
 const struct amdgpu_nbio_funcs nbio_v7_4_funcs = {
diff --git a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
index 9014f71d52dd..8b20326c4c05 100644
--- a/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/sdma_v4_0.c
@@ -1507,6 +1507,11 @@ static int sdma_v4_0_start(struct amdgpu_device *adev)
 		WREG32_SDMA(i, mmSDMA0_CNTL, temp);
 
 		if (!amdgpu_sriov_vf(adev)) {
+			ring = &adev->sdma.instance[i].ring;
+			adev->nbio.funcs->sdma_doorbell_range(adev, i,
+				ring->use_doorbell, ring->doorbell_index,
+				adev->doorbell_index.sdma_doorbell_range);
+
 			/* unhalt engine */
 			temp = RREG32_SDMA(i, mmSDMA0_F32_CNTL);
 			temp = REG_SET_FIELD(temp, SDMA0_F32_CNTL, HALT, 0);
diff --git a/drivers/gpu/drm/amd/amdgpu/soc15.c b/drivers/gpu/drm/amd/amdgpu/soc15.c
index bdb47ae96ce6..7d5ff50435e5 100644
--- a/drivers/gpu/drm/amd/amdgpu/soc15.c
+++ b/drivers/gpu/drm/amd/amdgpu/soc15.c
@@ -1416,25 +1416,6 @@ static int soc15_common_sw_fini(void *handle)
 	return 0;
 }
 
-static void soc15_doorbell_range_init(struct amdgpu_device *adev)
-{
-	int i;
-	struct amdgpu_ring *ring;
-
-	/* sdma/ih doorbell range are programed by hypervisor */
-	if (!amdgpu_sriov_vf(adev)) {
-		for (i = 0; i < adev->sdma.num_instances; i++) {
-			ring = &adev->sdma.instance[i].ring;
-			adev->nbio.funcs->sdma_doorbell_range(adev, i,
-				ring->use_doorbell, ring->doorbell_index,
-				adev->doorbell_index.sdma_doorbell_range);
-		}
-
-		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
-						adev->irq.ih.doorbell_index);
-	}
-}
-
 static int soc15_common_hw_init(void *handle)
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
@@ -1454,12 +1435,6 @@ static int soc15_common_hw_init(void *handle)
 
 	/* enable the doorbell aperture */
 	soc15_enable_doorbell_aperture(adev, true);
-	/* HW doorbell routing policy: doorbell writing not
-	 * in SDMA/IH/MM/ACV range will be routed to CP. So
-	 * we need to init SDMA/IH/MM/ACV doorbell range prior
-	 * to CP ip block init and ring test.
-	 */
-	soc15_doorbell_range_init(adev);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/amd/amdgpu/vega10_ih.c b/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
index a9ca6988009e..73728fa85997 100644
--- a/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/vega10_ih.c
@@ -289,6 +289,10 @@ static int vega10_ih_irq_init(struct amdgpu_device *adev)
 		}
 	}
 
+	if (!amdgpu_sriov_vf(adev))
+		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
+						    adev->irq.ih.doorbell_index);
+
 	pci_set_master(adev->pdev);
 
 	/* enable interrupts */
diff --git a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
index f51dfc38ac65..ac34af4cb178 100644
--- a/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
+++ b/drivers/gpu/drm/amd/amdgpu/vega20_ih.c
@@ -340,6 +340,10 @@ static int vega20_ih_irq_init(struct amdgpu_device *adev)
 		}
 	}
 
+	if (!amdgpu_sriov_vf(adev))
+		adev->nbio.funcs->ih_doorbell_range(adev, adev->irq.ih.use_doorbell,
+						    adev->irq.ih.doorbell_index);
+
 	pci_set_master(adev->pdev);
 
 	/* enable interrupts */
diff --git a/drivers/gpu/drm/meson/meson_plane.c b/drivers/gpu/drm/meson/meson_plane.c
index 8640a8a8a469..44aa52629443 100644
--- a/drivers/gpu/drm/meson/meson_plane.c
+++ b/drivers/gpu/drm/meson/meson_plane.c
@@ -168,7 +168,7 @@ static void meson_plane_atomic_update(struct drm_plane *plane,
 
 	/* Enable OSD and BLK0, set max global alpha */
 	priv->viu.osd1_ctrl_stat = OSD_ENABLE |
-				   (0xFF << OSD_GLOBAL_ALPHA_SHIFT) |
+				   (0x100 << OSD_GLOBAL_ALPHA_SHIFT) |
 				   OSD_BLK0_ENABLE;
 
 	priv->viu.osd1_ctrl_stat2 = readl(priv->io_base +
diff --git a/drivers/gpu/drm/meson/meson_viu.c b/drivers/gpu/drm/meson/meson_viu.c
index bb7e109534de..d4b907889a21 100644
--- a/drivers/gpu/drm/meson/meson_viu.c
+++ b/drivers/gpu/drm/meson/meson_viu.c
@@ -94,7 +94,7 @@ static void meson_viu_set_g12a_osd1_matrix(struct meson_drm *priv,
 		priv->io_base + _REG(VPP_WRAP_OSD1_MATRIX_COEF11_12));
 	writel(((m[9] & 0x1fff) << 16) | (m[10] & 0x1fff),
 		priv->io_base + _REG(VPP_WRAP_OSD1_MATRIX_COEF20_21));
-	writel((m[11] & 0x1fff) << 16,
+	writel((m[11] & 0x1fff),
 		priv->io_base +	_REG(VPP_WRAP_OSD1_MATRIX_COEF22));
 
 	writel(((m[18] & 0xfff) << 16) | (m[19] & 0xfff),
diff --git a/drivers/gpu/drm/panfrost/panfrost_devfreq.c b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
index 194af7f607a6..be36dd060a2b 100644
--- a/drivers/gpu/drm/panfrost/panfrost_devfreq.c
+++ b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
@@ -132,6 +132,17 @@ int panfrost_devfreq_init(struct panfrost_device *pfdev)
 		return PTR_ERR(opp);
 
 	panfrost_devfreq_profile.initial_freq = cur_freq;
+
+	/*
+	 * Set the recommend OPP this will enable and configure the regulator
+	 * if any and will avoid a switch off by regulator_late_cleanup()
+	 */
+	ret = dev_pm_opp_set_opp(dev, opp);
+	if (ret) {
+		DRM_DEV_ERROR(dev, "Couldn't set recommended OPP\n");
+		return ret;
+	}
+
 	dev_pm_opp_put(opp);
 
 	/*
diff --git a/drivers/gpu/drm/tegra/vic.c b/drivers/gpu/drm/tegra/vic.c
index da4af5371991..d3e2fab91086 100644
--- a/drivers/gpu/drm/tegra/vic.c
+++ b/drivers/gpu/drm/tegra/vic.c
@@ -275,7 +275,7 @@ static int vic_load_firmware(struct vic *vic)
 }
 
 
-static int vic_runtime_resume(struct device *dev)
+static int __maybe_unused vic_runtime_resume(struct device *dev)
 {
 	struct vic *vic = dev_get_drvdata(dev);
 	int err;
@@ -309,7 +309,7 @@ static int vic_runtime_resume(struct device *dev)
 	return err;
 }
 
-static int vic_runtime_suspend(struct device *dev)
+static int __maybe_unused vic_runtime_suspend(struct device *dev)
 {
 	struct vic *vic = dev_get_drvdata(dev);
 	int err;
diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index 3e1aab1e894e..15c90441285c 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1085,6 +1085,7 @@ static const struct usb_device_id products[] = {
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0512)},	/* Quectel EG12/EM12 */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0620)},	/* Quectel EM160R-GL */
 	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0800)},	/* Quectel RM500Q-GL */
+	{QMI_MATCH_FF_FF_FF(0x2c7c, 0x0801)},	/* Quectel RM520N */
 
 	/* 3. Combined interface devices matching on interface number */
 	{QMI_FIXED_INTF(0x0408, 0xea42, 4)},	/* Yota / Megafon M100-1 */
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index feddf4045a8c..52a2574b7d13 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -4278,6 +4278,10 @@ static int hwsim_virtio_handle_cmd(struct sk_buff *skb)
 
 	nlh = nlmsg_hdr(skb);
 	gnlh = nlmsg_data(nlh);
+
+	if (skb->len < nlh->nlmsg_len)
+		return -EINVAL;
+
 	err = genlmsg_parse(nlh, &hwsim_genl_family, tb, HWSIM_ATTR_MAX,
 			    hwsim_genl_policy, NULL);
 	if (err) {
@@ -4320,7 +4324,8 @@ static void hwsim_virtio_rx_work(struct work_struct *work)
 	spin_unlock_irqrestore(&hwsim_virtio_lock, flags);
 
 	skb->data = skb->head;
-	skb_set_tail_pointer(skb, len);
+	skb_reset_tail_pointer(skb);
+	skb_put(skb, len);
 	hwsim_virtio_handle_cmd(skb);
 
 	spin_lock_irqsave(&hwsim_virtio_lock, flags);
diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index d245628b15dd..338171c978cc 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -313,7 +313,7 @@ static int unflatten_dt_nodes(const void *blob,
 	for (offset = 0;
 	     offset >= 0 && depth >= initial_depth;
 	     offset = fdt_next_node(blob, offset, &depth)) {
-		if (WARN_ON_ONCE(depth >= FDT_MAX_DEPTH))
+		if (WARN_ON_ONCE(depth >= FDT_MAX_DEPTH - 1))
 			continue;
 
 		if (!IS_ENABLED(CONFIG_OF_KOBJ) &&
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index f69ab90b5e22..6052f264bbb0 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -1546,6 +1546,7 @@ static int __init ccio_probe(struct parisc_device *dev)
 	}
 	ccio_ioc_init(ioc);
 	if (ccio_init_resources(ioc)) {
+		iounmap(ioc->ioc_regs);
 		kfree(ioc);
 		return -ENOMEM;
 	}
diff --git a/drivers/pinctrl/qcom/pinctrl-sc8180x.c b/drivers/pinctrl/qcom/pinctrl-sc8180x.c
index 0d9654b4ab60..a4725ff12da0 100644
--- a/drivers/pinctrl/qcom/pinctrl-sc8180x.c
+++ b/drivers/pinctrl/qcom/pinctrl-sc8180x.c
@@ -530,10 +530,10 @@ DECLARE_MSM_GPIO_PINS(187);
 DECLARE_MSM_GPIO_PINS(188);
 DECLARE_MSM_GPIO_PINS(189);
 
-static const unsigned int sdc2_clk_pins[] = { 190 };
-static const unsigned int sdc2_cmd_pins[] = { 191 };
-static const unsigned int sdc2_data_pins[] = { 192 };
-static const unsigned int ufs_reset_pins[] = { 193 };
+static const unsigned int ufs_reset_pins[] = { 190 };
+static const unsigned int sdc2_clk_pins[] = { 191 };
+static const unsigned int sdc2_cmd_pins[] = { 192 };
+static const unsigned int sdc2_data_pins[] = { 193 };
 
 enum sc8180x_functions {
 	msm_mux_adsp_ext,
@@ -1582,7 +1582,7 @@ static const int sc8180x_acpi_reserved_gpios[] = {
 static const struct msm_gpio_wakeirq_map sc8180x_pdc_map[] = {
 	{ 3, 31 }, { 5, 32 }, { 8, 33 }, { 9, 34 }, { 10, 100 }, { 12, 104 },
 	{ 24, 37 }, { 26, 38 }, { 27, 41 }, { 28, 42 }, { 30, 39 }, { 36, 43 },
-	{ 37, 43 }, { 38, 45 }, { 39, 118 }, { 39, 125 }, { 41, 47 },
+	{ 37, 44 }, { 38, 45 }, { 39, 118 }, { 39, 125 }, { 41, 47 },
 	{ 42, 48 }, { 46, 50 }, { 47, 49 }, { 48, 51 }, { 49, 53 }, { 50, 52 },
 	{ 51, 116 }, { 51, 123 }, { 53, 54 }, { 54, 55 }, { 55, 56 },
 	{ 56, 57 }, { 58, 58 }, { 60, 60 }, { 68, 62 }, { 70, 63 }, { 76, 86 },
diff --git a/drivers/pinctrl/sunxi/pinctrl-sun50i-a100-r.c b/drivers/pinctrl/sunxi/pinctrl-sun50i-a100-r.c
index 21054fcacd34..18088f6f44b2 100644
--- a/drivers/pinctrl/sunxi/pinctrl-sun50i-a100-r.c
+++ b/drivers/pinctrl/sunxi/pinctrl-sun50i-a100-r.c
@@ -98,7 +98,7 @@ MODULE_DEVICE_TABLE(of, a100_r_pinctrl_match);
 static struct platform_driver a100_r_pinctrl_driver = {
 	.probe	= a100_r_pinctrl_probe,
 	.driver	= {
-		.name		= "sun50iw10p1-r-pinctrl",
+		.name		= "sun50i-a100-r-pinctrl",
 		.of_match_table	= a100_r_pinctrl_match,
 	},
 };
diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index aa55cfca9e40..a9a0bd918d1e 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -763,7 +763,7 @@ static int pfuze100_regulator_probe(struct i2c_client *client,
 		((pfuze_chip->chip_id == PFUZE3000) ? "3000" : "3001"))));
 
 	memcpy(pfuze_chip->regulator_descs, pfuze_chip->pfuze_regulators,
-		sizeof(pfuze_chip->regulator_descs));
+		regulator_num * sizeof(struct pfuze_regulator));
 
 	ret = pfuze_parse_regulators_dt(pfuze_chip);
 	if (ret)
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 7da8e4c845df..41313fcaf84a 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4278,7 +4278,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 		    lpfc_cmd->result == IOERR_NO_RESOURCES ||
 		    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
 		    lpfc_cmd->result == IOERR_SLER_CMD_RCV_FAILURE) {
-			cmd->result = DID_REQUEUE << 16;
+			cmd->result = DID_TRANSPORT_DISRUPTED << 16;
 			break;
 		}
 		if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
@@ -4567,7 +4567,7 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pIocbIn,
 			    lpfc_cmd->result == IOERR_NO_RESOURCES ||
 			    lpfc_cmd->result == IOERR_ABORT_REQUESTED ||
 			    lpfc_cmd->result == IOERR_SLER_CMD_RCV_FAILURE) {
-				cmd->result = DID_REQUEUE << 16;
+				cmd->result = DID_TRANSPORT_DISRUPTED << 16;
 				break;
 			}
 			if ((lpfc_cmd->result == IOERR_RX_DMA_FAILED ||
diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index dd350c590880..c0a86558ceaa 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -295,20 +295,16 @@ static int atmel_config_rs485(struct uart_port *port,
 
 	mode = atmel_uart_readl(port, ATMEL_US_MR);
 
-	/* Resetting serial mode to RS232 (0x0) */
-	mode &= ~ATMEL_US_USMODE;
-
-	port->rs485 = *rs485conf;
-
 	if (rs485conf->flags & SER_RS485_ENABLED) {
 		dev_dbg(port->dev, "Setting UART to RS485\n");
-		if (port->rs485.flags & SER_RS485_RX_DURING_TX)
+		if (rs485conf->flags & SER_RS485_RX_DURING_TX)
 			atmel_port->tx_done_mask = ATMEL_US_TXRDY;
 		else
 			atmel_port->tx_done_mask = ATMEL_US_TXEMPTY;
 
 		atmel_uart_writel(port, ATMEL_US_TTGR,
 				  rs485conf->delay_rts_after_send);
+		mode &= ~ATMEL_US_USMODE;
 		mode |= ATMEL_US_USMODE_RS485;
 	} else {
 		dev_dbg(port->dev, "Setting UART to RS232\n");
diff --git a/drivers/video/fbdev/i740fb.c b/drivers/video/fbdev/i740fb.c
index ad5ced4ef972..8fb4e01e1943 100644
--- a/drivers/video/fbdev/i740fb.c
+++ b/drivers/video/fbdev/i740fb.c
@@ -662,6 +662,9 @@ static int i740fb_decode_var(const struct fb_var_screeninfo *var,
 
 static int i740fb_check_var(struct fb_var_screeninfo *var, struct fb_info *info)
 {
+	if (!var->pixclock)
+		return -EINVAL;
+
 	switch (var->bits_per_pixel) {
 	case 8:
 		var->red.offset	= var->green.offset = var->blue.offset = 0;
diff --git a/drivers/video/fbdev/pxa3xx-gcu.c b/drivers/video/fbdev/pxa3xx-gcu.c
index 9421d14d0eb0..9e9888e40c57 100644
--- a/drivers/video/fbdev/pxa3xx-gcu.c
+++ b/drivers/video/fbdev/pxa3xx-gcu.c
@@ -381,7 +381,7 @@ pxa3xx_gcu_write(struct file *file, const char *buff,
 	struct pxa3xx_gcu_batch	*buffer;
 	struct pxa3xx_gcu_priv *priv = to_pxa3xx_gcu_priv(file);
 
-	int words = count / 4;
+	size_t words = count / 4;
 
 	/* Does not need to be atomic. There's a lock in user space,
 	 * but anyhow, this is just for statistics. */
diff --git a/fs/afs/misc.c b/fs/afs/misc.c
index 933e67fcdab1..805328ca5428 100644
--- a/fs/afs/misc.c
+++ b/fs/afs/misc.c
@@ -69,6 +69,7 @@ int afs_abort_to_error(u32 abort_code)
 		/* Unified AFS error table */
 	case UAEPERM:			return -EPERM;
 	case UAENOENT:			return -ENOENT;
+	case UAEAGAIN:			return -EAGAIN;
 	case UAEACCES:			return -EACCES;
 	case UAEBUSY:			return -EBUSY;
 	case UAEEXIST:			return -EEXIST;
diff --git a/fs/cifs/connect.c b/fs/cifs/connect.c
index 70da1d27be3d..278634a63895 100644
--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -519,9 +519,6 @@ cifs_readv_from_socket(struct TCP_Server_Info *server, struct msghdr *smb_msg)
 	int length = 0;
 	int total_read;
 
-	smb_msg->msg_control = NULL;
-	smb_msg->msg_controllen = 0;
-
 	for (total_read = 0; msg_data_left(smb_msg); total_read += length) {
 		try_to_freeze();
 
@@ -572,7 +569,7 @@ int
 cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 		      unsigned int to_read)
 {
-	struct msghdr smb_msg;
+	struct msghdr smb_msg = {};
 	struct kvec iov = {.iov_base = buf, .iov_len = to_read};
 	iov_iter_kvec(&smb_msg.msg_iter, READ, &iov, 1, to_read);
 
@@ -582,15 +579,13 @@ cifs_read_from_socket(struct TCP_Server_Info *server, char *buf,
 ssize_t
 cifs_discard_from_socket(struct TCP_Server_Info *server, size_t to_read)
 {
-	struct msghdr smb_msg;
+	struct msghdr smb_msg = {};
 
 	/*
 	 *  iov_iter_discard already sets smb_msg.type and count and iov_offset
 	 *  and cifs_readv_from_socket sets msg_control and msg_controllen
 	 *  so little to initialize in struct msghdr
 	 */
-	smb_msg.msg_name = NULL;
-	smb_msg.msg_namelen = 0;
 	iov_iter_discard(&smb_msg.msg_iter, READ, to_read);
 
 	return cifs_readv_from_socket(server, &smb_msg);
@@ -600,7 +595,7 @@ int
 cifs_read_page_from_socket(struct TCP_Server_Info *server, struct page *page,
 	unsigned int page_offset, unsigned int to_read)
 {
-	struct msghdr smb_msg;
+	struct msghdr smb_msg = {};
 	struct bio_vec bv = {
 		.bv_page = page, .bv_len = to_read, .bv_offset = page_offset};
 	iov_iter_bvec(&smb_msg.msg_iter, READ, &bv, 1, to_read);
diff --git a/fs/cifs/file.c b/fs/cifs/file.c
index 3015a8b20bd9..2ef57bc054d2 100644
--- a/fs/cifs/file.c
+++ b/fs/cifs/file.c
@@ -3318,6 +3318,9 @@ static ssize_t __cifs_writev(
 
 ssize_t cifs_direct_writev(struct kiocb *iocb, struct iov_iter *from)
 {
+	struct file *file = iocb->ki_filp;
+
+	cifs_revalidate_mapping(file->f_inode);
 	return __cifs_writev(iocb, from, true);
 }
 
diff --git a/fs/cifs/transport.c b/fs/cifs/transport.c
index 61ea3d3f95b4..514056605fa7 100644
--- a/fs/cifs/transport.c
+++ b/fs/cifs/transport.c
@@ -196,10 +196,6 @@ smb_send_kvec(struct TCP_Server_Info *server, struct msghdr *smb_msg,
 
 	*sent = 0;
 
-	smb_msg->msg_name = (struct sockaddr *) &server->dstaddr;
-	smb_msg->msg_namelen = sizeof(struct sockaddr);
-	smb_msg->msg_control = NULL;
-	smb_msg->msg_controllen = 0;
 	if (server->noblocksnd)
 		smb_msg->msg_flags = MSG_DONTWAIT + MSG_NOSIGNAL;
 	else
@@ -311,7 +307,7 @@ __smb_send_rqst(struct TCP_Server_Info *server, int num_rqst,
 	sigset_t mask, oldmask;
 	size_t total_len = 0, sent, size;
 	struct socket *ssocket = server->ssocket;
-	struct msghdr smb_msg;
+	struct msghdr smb_msg = {};
 	__be32 rfc1002_marker;
 
 	if (cifs_rdma_enabled(server)) {
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index e65c83494c05..a847011f36c9 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -1046,22 +1046,31 @@ static void nfs_fill_super(struct super_block *sb, struct nfs_fs_context *ctx)
 	if (ctx->bsize)
 		sb->s_blocksize = nfs_block_size(ctx->bsize, &sb->s_blocksize_bits);
 
-	if (server->nfs_client->rpc_ops->version != 2) {
-		/* The VFS shouldn't apply the umask to mode bits. We will do
-		 * so ourselves when necessary.
+	switch (server->nfs_client->rpc_ops->version) {
+	case 2:
+		sb->s_time_gran = 1000;
+		sb->s_time_min = 0;
+		sb->s_time_max = U32_MAX;
+		break;
+	case 3:
+		/*
+		 * The VFS shouldn't apply the umask to mode bits.
+		 * We will do so ourselves when necessary.
 		 */
 		sb->s_flags |= SB_POSIXACL;
 		sb->s_time_gran = 1;
-		sb->s_export_op = &nfs_export_ops;
-	} else
-		sb->s_time_gran = 1000;
-
-	if (server->nfs_client->rpc_ops->version != 4) {
 		sb->s_time_min = 0;
 		sb->s_time_max = U32_MAX;
-	} else {
+		sb->s_export_op = &nfs_export_ops;
+		break;
+	case 4:
+		sb->s_flags |= SB_POSIXACL;
+		sb->s_time_gran = 1;
 		sb->s_time_min = S64_MIN;
 		sb->s_time_max = S64_MAX;
+		if (server->caps & NFS_CAP_ATOMIC_OPEN_V1)
+			sb->s_export_op = &nfs_export_ops;
+		break;
 	}
 
 	sb->s_magic = NFS_SUPER_MAGIC;
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 38b7e9ab48b8..725f8f13adb5 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1912,6 +1912,8 @@ static inline long kvm_arch_vcpu_async_ioctl(struct file *filp,
 void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 					    unsigned long start, unsigned long end);
 
+void kvm_arch_guest_memory_reclaimed(struct kvm *kvm);
+
 #ifdef CONFIG_HAVE_KVM_VCPU_RUN_PID_CHANGE
 int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu);
 #else
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index 1d7992a02e36..1a803e4335d3 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -101,8 +101,9 @@ static inline struct device_node *of_cpu_device_node_get(int cpu)
 }
 
 static inline int of_dma_configure_id(struct device *dev,
-				   struct device_node *np,
-				   bool force_dma)
+				      struct device_node *np,
+				      bool force_dma,
+				      const u32 *id)
 {
 	return 0;
 }
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 65242172e41c..73030094c6e6 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -1190,6 +1190,8 @@ int __xfrm_sk_clone_policy(struct sock *sk, const struct sock *osk);
 
 static inline int xfrm_sk_clone_policy(struct sock *sk, const struct sock *osk)
 {
+	if (!sk_fullsock(osk))
+		return 0;
 	sk->sk_policy[0] = NULL;
 	sk->sk_policy[1] = NULL;
 	if (unlikely(osk->sk_policy[0] || osk->sk_policy[1]))
diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 58900dc92ac9..ee8b3d80f19e 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -59,6 +59,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 	int retval = 0;
 
 	mutex_lock(&cgroup_mutex);
+	cpus_read_lock();
 	percpu_down_write(&cgroup_threadgroup_rwsem);
 	for_each_root(root) {
 		struct cgroup *from_cgrp;
@@ -75,6 +76,7 @@ int cgroup_attach_task_all(struct task_struct *from, struct task_struct *tsk)
 			break;
 	}
 	percpu_up_write(&cgroup_threadgroup_rwsem);
+	cpus_read_unlock();
 	mutex_unlock(&cgroup_mutex);
 
 	return retval;
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 7aff0179b3c2..ef786c6232df 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -1704,7 +1704,7 @@ void ip_send_unicast_reply(struct sock *sk, struct sk_buff *skb,
 			   tcp_hdr(skb)->source, tcp_hdr(skb)->dest,
 			   arg->uid);
 	security_skb_classify_flow(skb, flowi4_to_flowi_common(&fl4));
-	rt = ip_route_output_key(net, &fl4);
+	rt = ip_route_output_flow(net, &fl4, sk);
 	if (IS_ERR(rt))
 		return;
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index dae0776c4948..88a45d5650da 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -817,6 +817,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 		ctl_sk->sk_priority = (sk->sk_state == TCP_TIME_WAIT) ?
 				   inet_twsk(sk)->tw_priority : sk->sk_priority;
 		transmit_time = tcp_transmit_time(sk);
+		xfrm_sk_clone_policy(ctl_sk, sk);
 	}
 	ip_send_unicast_reply(ctl_sk,
 			      skb, &TCP_SKB_CB(skb)->header.h4.opt,
@@ -825,6 +826,7 @@ static void tcp_v4_send_reset(const struct sock *sk, struct sk_buff *skb)
 			      transmit_time);
 
 	ctl_sk->sk_mark = 0;
+	xfrm_sk_free_policy(ctl_sk);
 	sock_net_set(ctl_sk, &init_net);
 	__TCP_INC_STATS(net, TCP_MIB_OUTSEGS);
 	__TCP_INC_STATS(net, TCP_MIB_OUTRSTS);
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 8ab39cf57d43..66d00368db82 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1001,7 +1001,10 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	 * Underlying function will use this to retrieve the network
 	 * namespace
 	 */
-	dst = ip6_dst_lookup_flow(sock_net(ctl_sk), ctl_sk, &fl6, NULL);
+	if (sk && sk->sk_state != TCP_TIME_WAIT)
+		dst = ip6_dst_lookup_flow(net, sk, &fl6, NULL); /*sk's xfrm_policy can be referred*/
+	else
+		dst = ip6_dst_lookup_flow(net, ctl_sk, &fl6, NULL);
 	if (!IS_ERR(dst)) {
 		skb_dst_set(buff, dst);
 		ip6_xmit(ctl_sk, buff, &fl6, fl6.flowi6_mark, NULL,
diff --git a/net/rxrpc/call_event.c b/net/rxrpc/call_event.c
index f8ecad2b730e..2a93e7b5fbd0 100644
--- a/net/rxrpc/call_event.c
+++ b/net/rxrpc/call_event.c
@@ -166,7 +166,7 @@ static void rxrpc_resend(struct rxrpc_call *call, unsigned long now_j)
 	_enter("{%d,%d}", call->tx_hard_ack, call->tx_top);
 
 	now = ktime_get_real();
-	max_age = ktime_sub(now, jiffies_to_usecs(call->peer->rto_j));
+	max_age = ktime_sub_us(now, jiffies_to_usecs(call->peer->rto_j));
 
 	spin_lock_bh(&call->lock);
 
diff --git a/net/rxrpc/local_object.c b/net/rxrpc/local_object.c
index ef43fe8bdd2f..1d15940f61d7 100644
--- a/net/rxrpc/local_object.c
+++ b/net/rxrpc/local_object.c
@@ -406,6 +406,9 @@ static void rxrpc_local_processor(struct work_struct *work)
 		container_of(work, struct rxrpc_local, processor);
 	bool again;
 
+	if (local->dead)
+		return;
+
 	trace_rxrpc_local(local->debug_id, rxrpc_local_processing,
 			  atomic_read(&local->usage), NULL);
 
diff --git a/scripts/mksysmap b/scripts/mksysmap
index 9aa23d15862a..ad8bbc52267d 100755
--- a/scripts/mksysmap
+++ b/scripts/mksysmap
@@ -41,4 +41,4 @@
 # so we just ignore them to let readprofile continue to work.
 # (At least sparc64 has __crc_ in the middle).
 
-$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)\|\( \.L\)' > $2
+$NM -n $1 | grep -v '\( [aNUw] \)\|\(__crc_\)\|\( \$[adt]\)\|\( \.L\)\|\( L0\)' > $2
diff --git a/sound/pci/hda/hda_tegra.c b/sound/pci/hda/hda_tegra.c
index 773f4903550a..f0e556f2ccf6 100644
--- a/sound/pci/hda/hda_tegra.c
+++ b/sound/pci/hda/hda_tegra.c
@@ -451,7 +451,8 @@ MODULE_DEVICE_TABLE(of, hda_tegra_match);
 static int hda_tegra_probe(struct platform_device *pdev)
 {
 	const unsigned int driver_flags = AZX_DCAPS_CORBRP_SELF_CLEAR |
-					  AZX_DCAPS_PM_RUNTIME;
+					  AZX_DCAPS_PM_RUNTIME |
+					  AZX_DCAPS_4K_BDLE_BOUNDARY;
 	struct snd_card *card;
 	struct azx *chip;
 	struct hda_tegra *hda;
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 61df4d33c48f..7f340f18599c 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -209,6 +209,7 @@ struct sigmatel_spec {
 
 	/* beep widgets */
 	hda_nid_t anabeep_nid;
+	bool beep_power_on;
 
 	/* SPDIF-out mux */
 	const char * const *spdif_labels;
@@ -4443,6 +4444,28 @@ static int stac_suspend(struct hda_codec *codec)
 
 	return 0;
 }
+
+static int stac_check_power_status(struct hda_codec *codec, hda_nid_t nid)
+{
+#ifdef CONFIG_SND_HDA_INPUT_BEEP
+	struct sigmatel_spec *spec = codec->spec;
+#endif
+	int ret = snd_hda_gen_check_power_status(codec, nid);
+
+#ifdef CONFIG_SND_HDA_INPUT_BEEP
+	if (nid == spec->gen.beep_nid && codec->beep) {
+		if (codec->beep->enabled != spec->beep_power_on) {
+			spec->beep_power_on = codec->beep->enabled;
+			if (spec->beep_power_on)
+				snd_hda_power_up_pm(codec);
+			else
+				snd_hda_power_down_pm(codec);
+		}
+		ret |= spec->beep_power_on;
+	}
+#endif
+	return ret;
+}
 #else
 #define stac_suspend		NULL
 #endif /* CONFIG_PM */
@@ -4455,6 +4478,7 @@ static const struct hda_codec_ops stac_patch_ops = {
 	.unsol_event = snd_hda_jack_unsol_event,
 #ifdef CONFIG_PM
 	.suspend = stac_suspend,
+	.check_power_status = stac_check_power_status,
 #endif
 };
 
diff --git a/sound/soc/codecs/nau8824.c b/sound/soc/codecs/nau8824.c
index f7018f2dd21f..27589900f4fb 100644
--- a/sound/soc/codecs/nau8824.c
+++ b/sound/soc/codecs/nau8824.c
@@ -1042,6 +1042,7 @@ static int nau8824_hw_params(struct snd_pcm_substream *substream,
 	struct snd_soc_component *component = dai->component;
 	struct nau8824 *nau8824 = snd_soc_component_get_drvdata(component);
 	unsigned int val_len = 0, osr, ctrl_val, bclk_fs, bclk_div;
+	int err = -EINVAL;
 
 	nau8824_sema_acquire(nau8824, HZ);
 
@@ -1058,7 +1059,7 @@ static int nau8824_hw_params(struct snd_pcm_substream *substream,
 		osr &= NAU8824_DAC_OVERSAMPLE_MASK;
 		if (nau8824_clock_check(nau8824, substream->stream,
 			nau8824->fs, osr))
-			return -EINVAL;
+			goto error;
 		regmap_update_bits(nau8824->regmap, NAU8824_REG_CLK_DIVIDER,
 			NAU8824_CLK_DAC_SRC_MASK,
 			osr_dac_sel[osr].clk_src << NAU8824_CLK_DAC_SRC_SFT);
@@ -1068,7 +1069,7 @@ static int nau8824_hw_params(struct snd_pcm_substream *substream,
 		osr &= NAU8824_ADC_SYNC_DOWN_MASK;
 		if (nau8824_clock_check(nau8824, substream->stream,
 			nau8824->fs, osr))
-			return -EINVAL;
+			goto error;
 		regmap_update_bits(nau8824->regmap, NAU8824_REG_CLK_DIVIDER,
 			NAU8824_CLK_ADC_SRC_MASK,
 			osr_adc_sel[osr].clk_src << NAU8824_CLK_ADC_SRC_SFT);
@@ -1089,7 +1090,7 @@ static int nau8824_hw_params(struct snd_pcm_substream *substream,
 		else if (bclk_fs <= 256)
 			bclk_div = 0;
 		else
-			return -EINVAL;
+			goto error;
 		regmap_update_bits(nau8824->regmap,
 			NAU8824_REG_PORT0_I2S_PCM_CTRL_2,
 			NAU8824_I2S_LRC_DIV_MASK | NAU8824_I2S_BLK_DIV_MASK,
@@ -1110,15 +1111,17 @@ static int nau8824_hw_params(struct snd_pcm_substream *substream,
 		val_len |= NAU8824_I2S_DL_32;
 		break;
 	default:
-		return -EINVAL;
+		goto error;
 	}
 
 	regmap_update_bits(nau8824->regmap, NAU8824_REG_PORT0_I2S_PCM_CTRL_1,
 		NAU8824_I2S_DL_MASK, val_len);
+	err = 0;
 
+ error:
 	nau8824_sema_release(nau8824);
 
-	return 0;
+	return err;
 }
 
 static int nau8824_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
@@ -1127,8 +1130,6 @@ static int nau8824_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 	struct nau8824 *nau8824 = snd_soc_component_get_drvdata(component);
 	unsigned int ctrl1_val = 0, ctrl2_val = 0;
 
-	nau8824_sema_acquire(nau8824, HZ);
-
 	switch (fmt & SND_SOC_DAIFMT_MASTER_MASK) {
 	case SND_SOC_DAIFMT_CBM_CFM:
 		ctrl2_val |= NAU8824_I2S_MS_MASTER;
@@ -1170,6 +1171,8 @@ static int nau8824_set_fmt(struct snd_soc_dai *dai, unsigned int fmt)
 		return -EINVAL;
 	}
 
+	nau8824_sema_acquire(nau8824, HZ);
+
 	regmap_update_bits(nau8824->regmap, NAU8824_REG_PORT0_I2S_PCM_CTRL_1,
 		NAU8824_I2S_DF_MASK | NAU8824_I2S_BP_MASK |
 		NAU8824_I2S_PCMB_EN, ctrl1_val);
diff --git a/tools/include/uapi/asm/errno.h b/tools/include/uapi/asm/errno.h
index d30439b4b8ab..869379f91fe4 100644
--- a/tools/include/uapi/asm/errno.h
+++ b/tools/include/uapi/asm/errno.h
@@ -9,8 +9,8 @@
 #include "../../../arch/alpha/include/uapi/asm/errno.h"
 #elif defined(__mips__)
 #include "../../../arch/mips/include/uapi/asm/errno.h"
-#elif defined(__xtensa__)
-#include "../../../arch/xtensa/include/uapi/asm/errno.h"
+#elif defined(__hppa__)
+#include "../../../arch/parisc/include/uapi/asm/errno.h"
 #else
 #include <asm-generic/errno.h>
 #endif
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 86fc429a0e43..3ae5f6a3eae4 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -162,6 +162,10 @@ __weak void kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 {
 }
 
+__weak void kvm_arch_guest_memory_reclaimed(struct kvm *kvm)
+{
+}
+
 bool kvm_is_zone_device_pfn(kvm_pfn_t pfn)
 {
 	/*
@@ -353,6 +357,12 @@ void kvm_reload_remote_mmus(struct kvm *kvm)
 	kvm_make_all_cpus_request(kvm, KVM_REQ_MMU_RELOAD);
 }
 
+static void kvm_flush_shadow_all(struct kvm *kvm)
+{
+	kvm_arch_flush_shadow_all(kvm);
+	kvm_arch_guest_memory_reclaimed(kvm);
+}
+
 #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
 static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
 					       gfp_t gfp_flags)
@@ -469,12 +479,15 @@ typedef bool (*hva_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 typedef void (*on_lock_fn_t)(struct kvm *kvm, unsigned long start,
 			     unsigned long end);
 
+typedef void (*on_unlock_fn_t)(struct kvm *kvm);
+
 struct kvm_hva_range {
 	unsigned long start;
 	unsigned long end;
 	pte_t pte;
 	hva_handler_t handler;
 	on_lock_fn_t on_lock;
+	on_unlock_fn_t on_unlock;
 	bool flush_on_ret;
 	bool may_block;
 };
@@ -551,8 +564,11 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
 	if (range->flush_on_ret && ret)
 		kvm_flush_remote_tlbs(kvm);
 
-	if (locked)
+	if (locked) {
 		KVM_MMU_UNLOCK(kvm);
+		if (!IS_KVM_NULL_FN(range->on_unlock))
+			range->on_unlock(kvm);
+	}
 
 	srcu_read_unlock(&kvm->srcu, idx);
 
@@ -573,6 +589,7 @@ static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
 		.pte		= pte,
 		.handler	= handler,
 		.on_lock	= (void *)kvm_null_fn,
+		.on_unlock	= (void *)kvm_null_fn,
 		.flush_on_ret	= true,
 		.may_block	= false,
 	};
@@ -592,6 +609,7 @@ static __always_inline int kvm_handle_hva_range_no_flush(struct mmu_notifier *mn
 		.pte		= __pte(0),
 		.handler	= handler,
 		.on_lock	= (void *)kvm_null_fn,
+		.on_unlock	= (void *)kvm_null_fn,
 		.flush_on_ret	= false,
 		.may_block	= false,
 	};
@@ -660,6 +678,7 @@ static int kvm_mmu_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		.pte		= __pte(0),
 		.handler	= kvm_unmap_gfn_range,
 		.on_lock	= kvm_inc_notifier_count,
+		.on_unlock	= kvm_arch_guest_memory_reclaimed,
 		.flush_on_ret	= true,
 		.may_block	= mmu_notifier_range_blockable(range),
 	};
@@ -711,6 +730,7 @@ static void kvm_mmu_notifier_invalidate_range_end(struct mmu_notifier *mn,
 		.pte		= __pte(0),
 		.handler	= (void *)kvm_null_fn,
 		.on_lock	= kvm_dec_notifier_count,
+		.on_unlock	= (void *)kvm_null_fn,
 		.flush_on_ret	= false,
 		.may_block	= mmu_notifier_range_blockable(range),
 	};
@@ -783,7 +803,7 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 	int idx;
 
 	idx = srcu_read_lock(&kvm->srcu);
-	kvm_arch_flush_shadow_all(kvm);
+	kvm_flush_shadow_all(kvm);
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
@@ -1188,7 +1208,7 @@ static void kvm_destroy_vm(struct kvm *kvm)
 	WARN_ON(rcuwait_active(&kvm->mn_memslots_update_rcuwait));
 	kvm->mn_active_invalidate_count = 0;
 #else
-	kvm_arch_flush_shadow_all(kvm);
+	kvm_flush_shadow_all(kvm);
 #endif
 	kvm_arch_destroy_vm(kvm);
 	kvm_destroy_devices(kvm);
@@ -1588,6 +1608,7 @@ static int kvm_set_memslot(struct kvm *kvm,
 		 *	- kvm_is_visible_gfn (mmu_check_root)
 		 */
 		kvm_arch_flush_shadow_memslot(kvm, slot);
+		kvm_arch_guest_memory_reclaimed(kvm);
 
 		/* Released in install_new_memslots. */
 		mutex_lock(&kvm->slots_arch_lock);
