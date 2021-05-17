Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E449383316
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241824AbhEQOyB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:54:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:48080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241566AbhEQOwA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:52:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3EBD961988;
        Mon, 17 May 2021 14:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261425;
        bh=gHSj6tyoz1bH7DPcjnPJnj511RmRmxNiZ5alo7SwcLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DASroyqKHgCMFym1qO9y+HADBinZpJ9uji33Mcx9dFbpgIZIlL2+be7rHP2dhH4b8
         z5WXIqm4Bo20nBgzwx35HtodixC/tnAmD3mpgn6I7li5aff1+ooHRCyY5D/DTQ4yLY
         pzGE/3tXpP5DE3e84/ZKt19UDtNYKI0lFjKQ3pPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Reiji Watanabe <reijiw@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.12 331/363] KVM: x86: Add support for RDPID without RDTSCP
Date:   Mon, 17 May 2021 16:03:17 +0200
Message-Id: <20210517140313.798043158@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 36fa06f9ff39f23e03cd8206dc6bbb7711c23be6 upstream.

Allow userspace to enable RDPID for a guest without also enabling RDTSCP.
Aside from checking for RDPID support in the obvious flows, VMX also needs
to set ENABLE_RDTSCP=1 when RDPID is exposed.

For the record, there is no known scenario where enabling RDPID without
RDTSCP is desirable.  But, both AMD and Intel architectures allow for the
condition, i.e. this is purely to make KVM more architecturally accurate.

Fixes: 41cd02c6f7f6 ("kvm: x86: Expose RDPID in KVM_GET_SUPPORTED_CPUID")
Cc: stable@vger.kernel.org
Reported-by: Reiji Watanabe <reijiw@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210504171734.1434054-8-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/svm/svm.c |    6 ++++--
 arch/x86/kvm/vmx/vmx.c |   27 +++++++++++++++++++++++----
 arch/x86/kvm/x86.c     |    3 ++-
 3 files changed, 29 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2741,7 +2741,8 @@ static int svm_get_msr(struct kvm_vcpu *
 		if (!boot_cpu_has(X86_FEATURE_RDTSCP))
 			return 1;
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		msr_info->data = svm->tsc_aux;
 		break;
@@ -2952,7 +2953,8 @@ static int svm_set_msr(struct kvm_vcpu *
 			return 1;
 
 		if (!msr->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 
 		/*
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1734,7 +1734,8 @@ static void setup_msrs(struct vcpu_vmx *
 	if (update_transition_efer(vmx))
 		vmx_setup_uret_msr(vmx, MSR_EFER);
 
-	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP))
+	if (guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP)  ||
+	    guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID))
 		vmx_setup_uret_msr(vmx, MSR_TSC_AUX);
 
 	vmx_setup_uret_msr(vmx, MSR_IA32_TSX_CTRL);
@@ -1933,7 +1934,8 @@ static int vmx_get_msr(struct kvm_vcpu *
 		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		goto find_uret_msr;
 	case MSR_IA32_DEBUGCTLMSR:
@@ -2230,7 +2232,8 @@ static int vmx_set_msr(struct kvm_vcpu *
 		break;
 	case MSR_TSC_AUX:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		/* Check reserved bit, higher 32 bits should be zero */
 		if ((data >> 32) != 0)
@@ -4302,7 +4305,23 @@ static void vmx_compute_secondary_exec_c
 						  xsaves_enabled, false);
 	}
 
-	vmx_adjust_sec_exec_feature(vmx, &exec_control, rdtscp, RDTSCP);
+	/*
+	 * RDPID is also gated by ENABLE_RDTSCP, turn on the control if either
+	 * feature is exposed to the guest.  This creates a virtualization hole
+	 * if both are supported in hardware but only one is exposed to the
+	 * guest, but letting the guest execute RDTSCP or RDPID when either one
+	 * is advertised is preferable to emulating the advertised instruction
+	 * in KVM on #UD, and obviously better than incorrectly injecting #UD.
+	 */
+	if (cpu_has_vmx_rdtscp()) {
+		bool rdpid_or_rdtscp_enabled =
+			guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
+			guest_cpuid_has(vcpu, X86_FEATURE_RDPID);
+
+		vmx_adjust_secondary_exec_control(vmx, &exec_control,
+						  SECONDARY_EXEC_ENABLE_RDTSCP,
+						  rdpid_or_rdtscp_enabled, false);
+	}
 	vmx_adjust_sec_exec_feature(vmx, &exec_control, invpcid, INVPCID);
 
 	vmx_adjust_sec_exec_exiting(vmx, &exec_control, rdrand, RDRAND);
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5864,7 +5864,8 @@ static void kvm_init_msr_list(void)
 				continue;
 			break;
 		case MSR_TSC_AUX:
-			if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP))
+			if (!kvm_cpu_cap_has(X86_FEATURE_RDTSCP) &&
+			    !kvm_cpu_cap_has(X86_FEATURE_RDPID))
 				continue;
 			break;
 		case MSR_IA32_UMWAIT_CONTROL:


