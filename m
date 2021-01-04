Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CFD62E9AA2
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbhADQAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:00:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:36552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727434AbhADQAB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 073D0224DE;
        Mon,  4 Jan 2021 15:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775970;
        bh=ayMLEWLTO3ln5gCVi+N7vwffY2GRGQLWDRhp7COPZvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CaplG1qk1so6dHIrpuyqPz6MKaPJZdq4x+pN76cyWbhK5MbB0GNY1qOmgbZa8Eo7u
         fMW4cZYlM5cM7DjQUJqRzoWJ1SRBeVktlej7A5FS+/borNEhTareNUrEzITu7/mr3x
         tbH0TVIIihLCMFm5ky0Fn8q0cwiQH61Z581tvl3A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jim Mattson <jmattson@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 12/47] KVM: x86: avoid incorrect writes to host MSR_IA32_SPEC_CTRL
Date:   Mon,  4 Jan 2021 16:57:11 +0100
Message-Id: <20210104155706.339275609@linuxfoundation.org>
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

[ Upstream commit 6441fa6178f5456d1d4b512c08798888f99db185 ]

If the guest is configured to have SPEC_CTRL but the host does not
(which is a nonsensical configuration but these are not explicitly
forbidden) then a host-initiated MSR write can write vmx->spec_ctrl
(respectively svm->spec_ctrl) and trigger a #GP when KVM tries to
restore the host value of the MSR.  Add a more comprehensive check
for valid bits of SPEC_CTRL, covering host CPUID flags and,
since we are at it and it is more correct that way, guest CPUID
flags too.

For AMD, remove the unnecessary is_guest_mode check around setting
the MSR interception bitmap, so that the code looks the same as
for Intel.

Cc: Jim Mattson <jmattson@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm.c     |  9 +++------
 arch/x86/kvm/vmx/vmx.c |  7 +++----
 arch/x86/kvm/x86.c     | 22 ++++++++++++++++++++++
 arch/x86/kvm/x86.h     |  1 +
 4 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index c79c1a07f44b9..72bf1d8175ac2 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4322,12 +4322,10 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
 			return 1;
 
-		/* The STIBP bit doesn't fault even if it's not advertised */
-		if (data & ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD))
+		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
 			return 1;
 
 		svm->spec_ctrl = data;
-
 		if (!data)
 			break;
 
@@ -4351,13 +4349,12 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		if (data & ~PRED_CMD_IBPB)
 			return 1;
-
+		if (!boot_cpu_has(X86_FEATURE_AMD_IBPB))
+			return 1;
 		if (!data)
 			break;
 
 		wrmsrl(MSR_IA32_PRED_CMD, PRED_CMD_IBPB);
-		if (is_guest_mode(vcpu))
-			break;
 		set_msr_interception(svm->msrpm, MSR_IA32_PRED_CMD, 0, 1);
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 2a1ed3aae100e..8450fce70bd96 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1974,12 +1974,10 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
 			return 1;
 
-		/* The STIBP bit doesn't fault even if it's not advertised */
-		if (data & ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD))
+		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
 			return 1;
 
 		vmx->spec_ctrl = data;
-
 		if (!data)
 			break;
 
@@ -2006,7 +2004,8 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		if (data & ~PRED_CMD_IBPB)
 			return 1;
-
+		if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL))
+			return 1;
 		if (!data)
 			break;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index b7f86acb8c911..72990c3c6faf7 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10369,6 +10369,28 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
 }
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
+u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
+{
+	uint64_t bits = SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD;
+
+	/* The STIBP bit doesn't fault even if it's not advertised */
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS))
+		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
+	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL) &&
+	    !boot_cpu_has(X86_FEATURE_AMD_IBRS))
+		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
+
+	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL_SSBD) &&
+	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
+		bits &= ~SPEC_CTRL_SSBD;
+	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) &&
+	    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
+		bits &= ~SPEC_CTRL_SSBD;
+
+	return bits;
+}
+EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index de6b55484876a..301286d924320 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -368,5 +368,6 @@ static inline bool kvm_pat_valid(u64 data)
 
 void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
 void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
+u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
 
 #endif
-- 
2.27.0



