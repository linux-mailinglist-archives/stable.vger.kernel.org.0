Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 485952E9A88
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729420AbhADQLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:11:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728273AbhADQAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9FBD12251E;
        Mon,  4 Jan 2021 15:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775993;
        bh=T8QIi5GrNr2Tt8t7UBFRpZ5z4HsrVjXPVVH/CWQir+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d0l3TxI6a/LMyGGniWhlJwy2wBeEWPju/OnstutOYuKFqWVSLrDTSFU3cRIgBHImf
         ZPgwW0BgtFNQQ+/ZYo0LSiETk8C7KVfFKGxaEAzDN+vUjeENts/gyoRPwEwxU38U+K
         /FX6l3GZqFiLtPzRH/m5fgURYul+BFknWlnus9ZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 14/47] KVM: x86: reinstate vendor-agnostic check on SPEC_CTRL cpuid bits
Date:   Mon,  4 Jan 2021 16:57:13 +0100
Message-Id: <20210104155706.439318618@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 39485ed95d6b83b62fa75c06c2c4d33992e0d971 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/cpuid.h   | 14 ++++++++++++++
 arch/x86/kvm/svm.c     | 14 ++++----------
 arch/x86/kvm/vmx/vmx.c |  8 ++++----
 3 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index d78a61408243f..7dec43b2c4205 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -154,6 +154,20 @@ static inline int guest_cpuid_stepping(struct kvm_vcpu *vcpu)
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
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index ca746006ac040..2b506904be024 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4233,10 +4233,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
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
@@ -4320,10 +4317,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
+		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
 		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
@@ -4348,12 +4342,12 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
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
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 8450fce70bd96..e7fd2f00edc11 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1788,7 +1788,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
 		msr_info->data = to_vmx(vcpu)->spec_ctrl;
@@ -1971,7 +1971,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
 		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
@@ -1999,12 +1999,12 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
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
-- 
2.27.0



