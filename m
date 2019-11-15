Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1A3FD607
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbfKOGVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:21:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:50730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727431AbfKOGVr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:21:47 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8944920728;
        Fri, 15 Nov 2019 06:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798906;
        bh=esbgX/tXTYhpuERAzD/3OA2d7lleqUxZQkZ/Ly8h7EI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7pKQBj/bKvxqYREIVXfjqaCxhc60vus9Qw8lRAA5V8NeEFRGxh0GNCzJXj+L0G4N
         3EIVLxA+xNaZEAaRq/vTUuQZe1shaLZq15rIj/yD0f9JwqoTFe6m/3oetzK09SLM4i
         HuLIQLtueDEbXD0hqVHAS1MeKNhqoB9/IKKaF5pQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaoyao Li <xiaoyao.li@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 07/20] KVM: x86: Emulate MSR_IA32_ARCH_CAPABILITIES on AMD hosts
Date:   Fri, 15 Nov 2019 14:20:36 +0800
Message-Id: <20191115062010.681961506@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062006.854443935@linuxfoundation.org>
References: <20191115062006.854443935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
Reported-by: Xiaoyao Li <xiaoyao.li@linux.intel.com>
Cc: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/kvm_host.h |    1 +
 arch/x86/kvm/vmx.c              |   14 --------------
 arch/x86/kvm/x86.c              |   12 ++++++++++++
 3 files changed, 13 insertions(+), 14 deletions(-)

--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -408,6 +408,7 @@ struct kvm_vcpu_arch {
 	u64 smbase;
 	bool tpr_access_reporting;
 	u64 ia32_xss;
+	u64 arch_capabilities;
 
 	/*
 	 * Paging state of the vcpu
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -546,7 +546,6 @@ struct vcpu_vmx {
 	u64 		      msr_guest_kernel_gs_base;
 #endif
 
-	u64 		      arch_capabilities;
 	u64 		      spec_ctrl;
 
 	u32 vm_entry_controls_shadow;
@@ -2866,12 +2865,6 @@ static int vmx_get_msr(struct kvm_vcpu *
 
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
@@ -3028,11 +3021,6 @@ static int vmx_set_msr(struct kvm_vcpu *
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
@@ -5079,8 +5067,6 @@ static int vmx_vcpu_setup(struct vcpu_vm
 		++vmx->nmsrs;
 	}
 
-	vmx->arch_capabilities = kvm_get_arch_capabilities();
-
 	vm_exit_controls_init(vmx, vmcs_config.vmexit_ctrl);
 
 	/* 22.2.1, 20.8.1 */
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -2080,6 +2080,11 @@ int kvm_set_msr_common(struct kvm_vcpu *
 	case MSR_AMD64_BU_CFG2:
 		break;
 
+	case MSR_IA32_ARCH_CAPABILITIES:
+		if (!msr_info->host_initiated)
+			return 1;
+		vcpu->arch.arch_capabilities = data;
+		break;
 	case MSR_EFER:
 		return set_efer(vcpu, msr_info);
 	case MSR_K7_HWCR:
@@ -2354,6 +2359,12 @@ int kvm_get_msr_common(struct kvm_vcpu *
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
 	case 0x200 ... 0x2ff:
 		return kvm_mtrr_get_msr(vcpu, msr_info->index, &msr_info->data);
@@ -7402,6 +7413,7 @@ int kvm_arch_vcpu_setup(struct kvm_vcpu
 {
 	int r;
 
+	vcpu->arch.arch_capabilities = kvm_get_arch_capabilities();
 	kvm_vcpu_mtrr_init(vcpu);
 	r = vcpu_load(vcpu);
 	if (r)


