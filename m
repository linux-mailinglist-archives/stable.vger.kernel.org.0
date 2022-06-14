Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E25354B903
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 20:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357504AbiFNSoz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 14:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357731AbiFNSoU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 14:44:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C9EC4D9DF;
        Tue, 14 Jun 2022 11:43:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7723CB81A3D;
        Tue, 14 Jun 2022 18:43:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FCAC3411B;
        Tue, 14 Jun 2022 18:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655232191;
        bh=e0++alf+J7304pXKotEWAAi2YNfDgxJLM6EdwJGGUSg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDwSKPMRqMDuhPNyu5uX6h6u6NaB5PO/QnB9DJUZBYIawaQStLYIo8aFd9E2Ep+VN
         mdq/NS/0MGZ5nyzZ4/hZDKXTJQAPfqL3Te1PBTiLcJ7IbQOlyINDL+FXblJiWs9Py+
         EPjhmtDA8jG9mVXqBGmXszuapV81mvw48UK9wbNg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Subject: [PATCH 4.19 15/16] KVM: x86/speculation: Disable Fill buffer clear within guests
Date:   Tue, 14 Jun 2022 20:40:16 +0200
Message-Id: <20220614183724.544969485@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220614183720.928818645@linuxfoundation.org>
References: <20220614183720.928818645@linuxfoundation.org>
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
[cascardo: arch/x86/kvm/vmx.c has been split and context adjustment at
 vmx_vcpu_run]
[cascardo: moved functions so they are after struct vcpu_vmx definition]
[cascardo: fb_clear is disabled/enabled around __vmx_vcpu_run]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/msr-index.h |    6 +++
 arch/x86/kvm/vmx.c               |   74 ++++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c               |    4 ++
 3 files changed, 83 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/msr-index.h
+++ b/arch/x86/include/asm/msr-index.h
@@ -115,6 +115,11 @@
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
@@ -132,6 +137,7 @@
 /* SRBDS support */
 #define MSR_IA32_MCU_OPT_CTRL		0x00000123
 #define RNGDS_MITG_DIS			BIT(0)
+#define FB_CLEAR_DIS			BIT(3)	/* CPU Fill buffer clear disable */
 
 #define MSR_IA32_SYSENTER_CS		0x00000174
 #define MSR_IA32_SYSENTER_ESP		0x00000175
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -212,6 +212,9 @@ static const struct {
 #define L1D_CACHE_ORDER 4
 static void *vmx_l1d_flush_pages;
 
+/* Control for disabling CPU Fill buffer clear */
+static bool __read_mostly vmx_fb_clear_ctrl_available;
+
 static int vmx_setup_l1d_flush(enum vmx_l1d_flush_state l1tf)
 {
 	struct page *page;
@@ -1045,6 +1048,8 @@ struct vcpu_vmx {
 	u64 msr_ia32_feature_control;
 	u64 msr_ia32_feature_control_valid_bits;
 	u64 ept_pointer;
+	u64 msr_ia32_mcu_opt_ctrl;
+	bool disable_fb_clear;
 };
 
 enum segment_cache_field {
@@ -2107,6 +2112,60 @@ static inline void __invept(unsigned lon
 	BUG_ON(error);
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
 static struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr)
 {
 	int i;
@@ -4314,9 +4373,13 @@ static int vmx_set_msr(struct kvm_vcpu *
 			}
 			break;
 		}
-		ret = kvm_set_msr_common(vcpu, msr_info);
+			ret = kvm_set_msr_common(vcpu, msr_info);
 	}
 
+	/* FB_CLEAR may have changed, also update the FB_CLEAR_DIS behavior */
+	if (msr_index == MSR_IA32_ARCH_CAPABILITIES)
+		vmx_update_fb_clear_dis(vcpu, vmx);
+
 	return ret;
 }
 
@@ -6761,6 +6824,8 @@ static void vmx_vcpu_reset(struct kvm_vc
 	vpid_sync_context(vmx->vpid);
 	if (init_event)
 		vmx_clear_hlt(vcpu);
+
+	vmx_update_fb_clear_dis(vcpu, vmx);
 }
 
 /*
@@ -10777,6 +10842,8 @@ static void __noclone vmx_vcpu_run(struc
 		 kvm_arch_has_assigned_device(vcpu->kvm))
 		mds_clear_cpu_buffers();
 
+	vmx_disable_fb_clear(vmx);
+
 	asm volatile (
 		/* Store host registers */
 		"push %%" _ASM_DX "; push %%" _ASM_BP ";"
@@ -10921,6 +10988,8 @@ static void __noclone vmx_vcpu_run(struc
 #endif
 	      );
 
+	vmx_enable_fb_clear(vmx);
+
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
 	 * SPEC_CTRL MSR it may have left it on; save the value and
@@ -14626,8 +14695,11 @@ static int __init vmx_init(void)
 		}
 	}
 
+	vmx_setup_fb_clear_ctrl();
+
 	for_each_possible_cpu(cpu) {
 		INIT_LIST_HEAD(&per_cpu(loaded_vmcss_on_cpu, cpu));
+
 		INIT_LIST_HEAD(&per_cpu(blocked_vcpu_on_cpu, cpu));
 		spin_lock_init(&per_cpu(blocked_vcpu_on_cpu_lock, cpu));
 	}
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1220,6 +1220,10 @@ u64 kvm_get_arch_capabilities(void)
 
 	/* KVM does not emulate MSR_IA32_TSX_CTRL.  */
 	data &= ~ARCH_CAP_TSX_CTRL_MSR;
+
+	/* Guests don't need to know "Fill buffer clear control" exists */
+	data &= ~ARCH_CAP_FB_CLEAR_CTRL;
+
 	return data;
 }
 


