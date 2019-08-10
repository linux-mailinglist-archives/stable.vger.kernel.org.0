Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 571CF88E1F
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbfHJUv7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:51:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54176 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726597AbfHJUnw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:52 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDN-00053u-8D; Sat, 10 Aug 2019 21:43:49 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDK-0003bw-Bb; Sat, 10 Aug 2019 21:43:46 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Paolo Bonzini" <pbonzini@redhat.com>,
        "Xiaoyao Li" <xiaoyao.li@linux.intel.com>,
        "Jim Mattson" <jmattson@google.com>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.995437361@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 056/157] KVM: x86: Emulate MSR_IA32_ARCH_CAPABILITIES
 on AMD hosts
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <sean.j.christopherson@intel.com>

commit 0cf9135b773bf32fba9dd8e6699c1b331ee4b749 upstream.

The CPUID flag ARCH_CAPABILITIES is unconditioinally exposed to host
userspace for all x86 hosts, i.e. KVM advertises ARCH_CAPABILITIES
regardless of hardware support under the pretense that KVM fully
emulates MSR_IA32_ARCH_CAPABILITIES.  Unfortunately, only VMX hosts
handle accesses to MSR_IA32_ARCH_CAPABILITIES (despite KVM_GET_MSRS
also reporting MSR_IA32_ARCH_CAPABILITIES for all hosts).

Move the MSR_IA32_ARCH_CAPABILITIES handling to common x86 code so
that it's emulated on AMD hosts.

Fixes: 1eaafe91a0df4 ("kvm: x86: IA32_ARCH_CAPABILITIES is always supported")
Reported-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
[bwh: Backported to 3.16:
 - Keep using guest_cpuid_has_arch_capabilities() to check the CPUID
 - Keep using rdmsrl() to get the initial value of IA32_ARCH_CAPABILITIES
 - Adjust filenames, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/vmx.c              | 13 -------------
 arch/x86/kvm/x86.c              | 12 ++++++++++++
 4 files changed, 13 insertions(+), 14 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -363,6 +363,7 @@ struct kvm_vcpu_arch {
 	int mp_state;
 	u64 ia32_misc_enable_msr;
 	bool tpr_access_reporting;
+	u64 arch_capabilities;
 
 	/*
 	 * Paging state of the vcpu
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -433,7 +433,6 @@ struct vcpu_vmx {
 	u64 		      msr_guest_kernel_gs_base;
 #endif
 
-	u64 		      arch_capabilities;
 	u64 		      spec_ctrl;
 
 	u32 vm_entry_controls_shadow;
@@ -2481,12 +2480,6 @@ static int vmx_get_msr(struct kvm_vcpu *
 
 		msr_info->data = to_vmx(vcpu)->spec_ctrl;
 		break;
-	case MSR_IA32_ARCH_CAPABILITIES:
-		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has_arch_capabilities(vcpu))
-			return 1;
-		msr_info->data = to_vmx(vcpu)->arch_capabilities;
-		break;
 	case MSR_IA32_SYSENTER_CS:
 		msr_info->data = vmcs_read32(GUEST_SYSENTER_CS);
 		break;
@@ -2636,11 +2629,6 @@ static int vmx_set_msr(struct kvm_vcpu *
 		vmx_disable_intercept_for_msr(vmx->vmcs01.msr_bitmap, MSR_IA32_PRED_CMD,
 					      MSR_TYPE_W);
 		break;
-	case MSR_IA32_ARCH_CAPABILITIES:
-		if (!msr_info->host_initiated)
-			return 1;
-		vmx->arch_capabilities = data;
-		break;
 	case MSR_IA32_CR_PAT:
 		if (vmcs_config.vmentry_ctrl & VM_ENTRY_LOAD_IA32_PAT) {
 			if (!kvm_mtrr_valid(vcpu, MSR_IA32_CR_PAT, data))
@@ -4583,9 +4571,6 @@ static int vmx_vcpu_setup(struct vcpu_vm
 		++vmx->nmsrs;
 	}
 
-	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
-		rdmsrl(MSR_IA32_ARCH_CAPABILITIES, vmx->arch_capabilities);
-
 	vm_exit_controls_init(vmx, vmcs_config.vmexit_ctrl);
 
 	/* 22.2.1, 20.8.1 */
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2089,6 +2089,11 @@ int kvm_set_msr_common(struct kvm_vcpu *
 	case MSR_F15H_EX_CFG:
 		break;
 
+	case MSR_IA32_ARCH_CAPABILITIES:
+		if (!msr_info->host_initiated)
+			return 1;
+		vcpu->arch.arch_capabilities = data;
+		break;
 	case MSR_EFER:
 		return set_efer(vcpu, data);
 	case MSR_K7_HWCR:
@@ -2479,6 +2484,12 @@ int kvm_get_msr_common(struct kvm_vcpu *
 	case MSR_IA32_UCODE_REV:
 		msr_info->data = 0x100000000ULL;
 		break;
+	case MSR_IA32_ARCH_CAPABILITIES:
+		if (!msr_info->host_initiated &&
+		    !guest_cpuid_has_arch_capabilities(vcpu))
+			return 1;
+		msr_info->data = vcpu->arch.arch_capabilities;
+		break;
 	case MSR_MTRRcap:
 		msr_info->data = 0x500 | KVM_NR_VAR_MTRR;
 		break;
@@ -6957,6 +6968,9 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu
 {
 	int r;
 
+	if (boot_cpu_has(X86_FEATURE_ARCH_CAPABILITIES))
+		rdmsrl(MSR_IA32_ARCH_CAPABILITIES,
+		       vcpu->arch.arch_capabilities);
 	vcpu->arch.mtrr_state.have_fixed = 1;
 	r = vcpu_load(vcpu);
 	if (r)

