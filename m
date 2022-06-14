Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E3654B992
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 21:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357903AbiFNStM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358185AbiFNSsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:48:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1F5B4DF6D;
        Tue, 14 Jun 2022 11:45:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 43F68617C6;
        Tue, 14 Jun 2022 18:45:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53545C3411D;
        Tue, 14 Jun 2022 18:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232301;
        bh=iMLs2jzYpe0RsHxOw6Xr/DxDIcgvBclz3BmI1WmRBvQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZCRq0C6ySpKVduCSnED06pa3+dkFwLhWB1FXRqldl4CyNzZa+aKLoFstZnocAIQ+7
         5/k/IK6s4v0VhVffH1zhjd7+kNcZrO8a0rjDk5wmOgKV9SmaidkfatKDpo9aWW7IIS
         P9+9a7XV+aZaKqDPjKPoEYASiyZ14THl2q02eRew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5.15 10/11] KVM: x86/speculation: Disable Fill buffer clear within guests
Date:   Tue, 14 Jun 2022 20:40:39 +0200
Message-Id: <20220614183723.005030282@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183720.512073672@linuxfoundation.org>
References: <20220614183720.512073672@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 027bbb884be006b05d9c577d6401686053aa789e upstream

The enumeration of MD_CLEAR in CPUID(EAX=7,ECX=0).EDX{bit 10} is not an
accurate indicator on all CPUs of whether the VERW instruction will
overwrite fill buffers. FB_CLEAR enumeration in
IA32_ARCH_CAPABILITIES{bit 17} covers the case of CPUs that are not
vulnerable to MDS/TAA, indicating that microcode does overwrite fill
buffers.

Guests running in VMM environments may not be aware of all the
capabilities/vulnerabilities of the host CPU. Specifically, a guest may
apply MDS/TAA mitigations when a virtual CPU is enumerated as vulnerable
to MDS/TAA even when the physical CPU is not. On CPUs that enumerate
FB_CLEAR_CTRL the VMM may set FB_CLEAR_DIS to skip overwriting of fill
buffers by the VERW instruction. This is done by setting FB_CLEAR_DIS
during VMENTER and resetting on VMEXIT. For guests that enumerate
FB_CLEAR (explicitly asking for fill buffer clear capability) the VMM
will not use FB_CLEAR_DIS.

Irrespective of guest state, host overwrites CPU buffers before VMENTER
to protect itself from an MMIO capable guest, as part of mitigation for
MMIO Stale Data vulnerabilities.

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/msr-index.h       |    6 ++
 arch/x86/kvm/vmx/vmx.c                 |   69 +++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/vmx.h                 |    2 
 arch/x86/kvm/x86.c                     |    3 +
 tools/arch/x86/include/asm/msr-index.h |    6 ++
 5 files changed, 86 insertions(+)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -133,6 +133,11 @@
 						 * VERW clears CPU fill buffer
 						 * even on MDS_NO CPUs.
 						 */
+#define ARCH_CAP_FB_CLEAR_CTRL		BIT(18)	/*
+						 * MSR_IA32_MCU_OPT_CTRL[FB_CLEAR_DIS]
+						 * bit available to control VERW
+						 * behavior.
+						 */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
@@ -150,6 +155,7 @@
 #define MSR_IA32_MCU_OPT_CTRL		0x00000123
 #define RNGDS_MITG_DIS			BIT(0)	/* SRBDS support */
 #define RTM_ALLOW			BIT(1)	/* TSX development mode */
+#define FB_CLEAR_DIS			BIT(3)	/* CPU Fill buffer clear disable */
 
 #define MSR_IA32_SYSENTER_CS		0x00000174
 #define MSR_IA32_SYSENTER_ESP		0x00000175
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -226,6 +226,9 @@ static const struct {
 #define L1D_CACHE_ORDER 4
 static void *vmx_l1d_flush_pages;
 
+/* Control for disabling CPU Fill buffer clear */
+static bool __read_mostly vmx_fb_clear_ctrl_available;
+
 static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 {
 	struct page *page;
@@ -357,6 +360,60 @@ static int vmentry_l1d_flush_get(char *s
 	return sprintf(s, "%s\n", vmentry_l1d_param[l1tf_vmx_mitigation].option);
 }
 
+static void vmx_setup_fb_clear_ctrl(void)
+{
+	u64 msr;
+
+	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES) &&
+	    !boot_cpu_has_bug(X86_BUG_MDS) &&
+	    !boot_cpu_has_bug(X86_BUG_TAA)) {
+		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, msr);
+		if (msr & ARCH_CAP_FB_CLEAR_CTRL)
+			vmx_fb_clear_ctrl_available = true;
+	}
+}
+
+static __always_inline void vmx_disable_fb_clear(struct vcpu_vmx *vmx)
+{
+	u64 msr;
+
+	if (!vmx->disable_fb_clear)
+		return;
+
+	rdmsrl(MSR_IA32_MCU_OPT_CTRL, msr);
+	msr |= FB_CLEAR_DIS;
+	wrmsrl(MSR_IA32_MCU_OPT_CTRL, msr);
+	/* Cache the MSR value to avoid reading it later */
+	vmx->msr_ia32_mcu_opt_ctrl = msr;
+}
+
+static __always_inline void vmx_enable_fb_clear(struct vcpu_vmx *vmx)
+{
+	if (!vmx->disable_fb_clear)
+		return;
+
+	vmx->msr_ia32_mcu_opt_ctrl &= ~FB_CLEAR_DIS;
+	wrmsrl(MSR_IA32_MCU_OPT_CTRL, vmx->msr_ia32_mcu_opt_ctrl);
+}
+
+static void vmx_update_fb_clear_dis(struct kvm_vcpu *vcpu, struct vcpu_vmx *vmx)
+{
+	vmx->disable_fb_clear = vmx_fb_clear_ctrl_available;
+
+	/*
+	 * If guest will not execute VERW, there is no need to set FB_CLEAR_DIS
+	 * at VMEntry. Skip the MSR read/write when a guest has no use case to
+	 * execute VERW.
+	 */
+	if ((vcpu->arch.arch_capabilities & ARCH_CAP_FB_CLEAR) ||
+	   ((vcpu->arch.arch_capabilities & ARCH_CAP_MDS_NO) &&
+	    (vcpu->arch.arch_capabilities & ARCH_CAP_TAA_NO) &&
+	    (vcpu->arch.arch_capabilities & ARCH_CAP_PSDP_NO) &&
+	    (vcpu->arch.arch_capabilities & ARCH_CAP_FBSDP_NO) &&
+	    (vcpu->arch.arch_capabilities & ARCH_CAP_SBDR_SSDP_NO)))
+		vmx->disable_fb_clear = false;
+}
+
 static const struct kernel_param_ops vmentry_l1d_flush_ops = {
 	.set = vmentry_l1d_flush_set,
 	.get = vmentry_l1d_flush_get,
@@ -2228,6 +2285,10 @@ static int vmx_set_msr(struct kvm_vcpu *
 			ret = kvm_set_msr_common(vcpu, msr_info);
 	}
 
+	/* FB_CLEAR may have changed, also update the FB_CLEAR_DIS behavior */
+	if (msr_index == MSR_IA32_ARCH_CAPABILITIES)
+		vmx_update_fb_clear_dis(vcpu, vmx);
+
 	return ret;
 }
 
@@ -4450,6 +4511,8 @@ static void vmx_vcpu_reset(struct kvm_vc
 	kvm_make_request(KVM_REQ_APIC_PAGE_RELOAD, vcpu);
 
 	vpid_sync_context(vmx->vpid);
+
+	vmx_update_fb_clear_dis(vcpu, vmx);
 }
 
 static void vmx_enable_irq_window(struct kvm_vcpu *vcpu)
@@ -6617,6 +6680,8 @@ static noinstr void vmx_vcpu_enter_exit(
 		 kvm_arch_has_assigned_device(vcpu->kvm))
 		mds_clear_cpu_buffers();
 
+	vmx_disable_fb_clear(vmx);
+
 	if (vcpu->arch.cr2 != native_read_cr2())
 		native_write_cr2(vcpu->arch.cr2);
 
@@ -6625,6 +6690,8 @@ static noinstr void vmx_vcpu_enter_exit(
 
 	vcpu->arch.cr2 = native_read_cr2();
 
+	vmx_enable_fb_clear(vmx);
+
 	kvm_guest_exit_irqoff();
 }
 
@@ -8042,6 +8109,8 @@ static int __init vmx_init(void)
 		return r;
 	}
 
+	vmx_setup_fb_clear_ctrl();
+
 	for_each_possible_cpu(cpu) {
 		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
 
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -326,6 +326,8 @@ struct vcpu_vmx {
 	u64 msr_ia32_feature_control_valid_bits;
 	/* SGX Launch Control public key hash */
 	u64 msr_ia32_sgxlepubkeyhash[4];
+	u64 msr_ia32_mcu_opt_ctrl;
+	bool disable_fb_clear;
 
 	struct pt_desc pt_desc;
 	struct lbr_desc lbr_desc;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1510,6 +1510,9 @@ static u64 kvm_get_arch_capabilities(voi
 		 */
 	}
 
+	/* Guests don't need to know "Fill buffer clear control" exists */
+	data &= ~ARCH_CAP_FB_CLEAR_CTRL;
+
 	return data;
 }
 
--- a/tools/arch/x86/include/asm/msr-index.h
+++ b/tools/arch/x86/include/asm/msr-index.h
@@ -133,6 +133,11 @@
 						 * VERW clears CPU fill buffer
 						 * even on MDS_NO CPUs.
 						 */
+#define ARCH_CAP_FB_CLEAR_CTRL		BIT(18)	/*
+						 * MSR_IA32_MCU_OPT_CTRL[FB_CLEAR_DIS]
+						 * bit available to control VERW
+						 * behavior.
+						 */
 
 #define MSR_IA32_FLUSH_CMD		0x0000010b
 #define L1D_FLUSH			BIT(0)	/*
@@ -150,6 +155,7 @@
 #define MSR_IA32_MCU_OPT_CTRL		0x00000123
 #define RNGDS_MITG_DIS			BIT(0)	/* SRBDS support */
 #define RTM_ALLOW			BIT(1)	/* TSX development mode */
+#define FB_CLEAR_DIS			BIT(3)	/* CPU Fill buffer clear disable */
 
 #define MSR_IA32_SYSENTER_CS		0x00000174
 #define MSR_IA32_SYSENTER_ESP		0x00000175


