Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28C782E3F95
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390383AbgL1OmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:42:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502469AbgL1O1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BD8222B37;
        Mon, 28 Dec 2020 14:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165627;
        bh=euW864Oaq4x0ZWfu6c5+vxqD4cYpeuLXF7hZ+z4ly3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OUlmsm9blpmWtivGk3a5l45rLf67SzcJvkoEzYXsRs+9g/LG/QznbyoZ4mRSlel4F
         1r39mm6X+F69w17zV9pxKHnns7fiKBOFxwKsL/FgjbDvTJ0koDPXCrUPeksLyObCA6
         rWxpYrbuekEe2ZAkg9aSto7JsWriDwzjFTcsXhwo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 598/717] KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL cpuid bits
Date:   Mon, 28 Dec 2020 13:49:56 +0100
Message-Id: <20201228125049.557290173@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

commit 39485ed95d6b83b62fa75c06c2c4d33992e0d971 upstream.

Until commit e7c587da1252 ("x86/speculation: Use synthetic bits for
IBRS/IBPB/STIBP"), KVM was testing both Intel and AMD CPUID bits before
allowing the guest to write MSR_IA32_SPEC_CTRL and MSR_IA32_PRED_CMD.
Testing only Intel bits on VMX processors, or only AMD bits on SVM
processors, fails if the guests are created with the "opposite" vendor
as the host.

While at it, also tweak the host CPU check to use the vendor-agnostic
feature bit X86_FEATURE_IBPB, since we only care about the availability
of the MSR on the host here and not about specific CPUID bits.

Fixes: e7c587da1252 ("x86/speculation: Use synthetic bits for IBRS/IBPB/STIBP")
Cc: stable@vger.kernel.org
Reported-by: Denis V. Lunev <den@openvz.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/cpuid.h   |   14 ++++++++++++++
 arch/x86/kvm/svm/svm.c |   14 ++++----------
 arch/x86/kvm/vmx/vmx.c |    8 ++++----
 3 files changed, 22 insertions(+), 14 deletions(-)

--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -264,6 +264,20 @@ static inline int guest_cpuid_stepping(s
 	return x86_stepping(best->eax);
 }
 
+static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
+{
+	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD));
+}
+
+static inline bool guest_has_pred_cmd_msr(struct kvm_vcpu *vcpu)
+{
+	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB));
+}
+
 static inline bool supports_cpuid_fault(struct kvm_vcpu *vcpu)
 {
 	return vcpu->arch.msr_platform_info & MSR_PLATFORM_INFO_CPUID_FAULT;
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2543,10 +2543,7 @@ static int svm_get_msr(struct kvm_vcpu *
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
+		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
 		msr_info->data = svm->spec_ctrl;
@@ -2630,10 +2627,7 @@ static int svm_set_msr(struct kvm_vcpu *
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
+		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
 		if (kvm_spec_ctrl_test_value(data))
@@ -2658,12 +2652,12 @@ static int svm_set_msr(struct kvm_vcpu *
 		break;
 	case MSR_IA32_PRED_CMD:
 		if (!msr->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB))
+		    !guest_has_pred_cmd_msr(vcpu))
 			return 1;
 
 		if (data & ~PRED_CMD_IBPB)
 			return 1;
-		if (!boot_cpu_has(X86_FEATURE_AMD_IBPB))
+		if (!boot_cpu_has(X86_FEATURE_IBPB))
 			return 1;
 		if (!data)
 			break;
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1826,7 +1826,7 @@ static int vmx_get_msr(struct kvm_vcpu *
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
 		msr_info->data = to_vmx(vcpu)->spec_ctrl;
@@ -2028,7 +2028,7 @@ static int vmx_set_msr(struct kvm_vcpu *
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
 		if (kvm_spec_ctrl_test_value(data))
@@ -2063,12 +2063,12 @@ static int vmx_set_msr(struct kvm_vcpu *
 		goto find_uret_msr;
 	case MSR_IA32_PRED_CMD:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		    !guest_has_pred_cmd_msr(vcpu))
 			return 1;
 
 		if (data & ~PRED_CMD_IBPB)
 			return 1;
-		if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL))
+		if (!boot_cpu_has(X86_FEATURE_IBPB))
 			return 1;
 		if (!data)
 			break;


