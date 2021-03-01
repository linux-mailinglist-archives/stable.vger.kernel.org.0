Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E50328793
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238383AbhCARZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:25:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:37368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237993AbhCARVU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:21:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2F7165062;
        Mon,  1 Mar 2021 16:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617284;
        bh=mqxnt136SEdOf533FCXJNP5DiIBV6M44czdVE7SJp4I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D3W4o1WNd5t7uMW7NN1JZdTe/G+aNSJO52nUYsrgj3Mv+YBzW3S4wcbRoFFPIQDFN
         mvDR3KDvYYfArp9Sp7lHmHDTrb7NFZcq4he2C9qGyjMCM1nn3kBUGjOYW8NNpfyymv
         EQR0sw79ibZXRaQp3dtLrO/Hm7LfOYWSKxWHheoY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Lamprecht <t.lamprecht@proxmox.com>
Subject: [PATCH 5.4 002/340] kvm: x86: replace kvm_spec_ctrl_test_value with runtime test on the host
Date:   Mon,  1 Mar 2021 17:09:06 +0100
Message-Id: <20210301161048.424208403@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

commit 841c2be09fe4f495fe5224952a419bd8c7e5b455 upstream.

To avoid complex and in some cases incorrect logic in
kvm_spec_ctrl_test_value, just try the guest's given value on the host
processor instead, and if it doesn't #GP, allow the guest to set it.

One such case is when host CPU supports STIBP mitigation
but doesn't support IBRS (as is the case with some Zen2 AMD cpus),
and in this case we were giving guest #GP when it tried to use STIBP

The reason why can can do the host test is that IA32_SPEC_CTRL msr is
passed to the guest, after the guest sets it to a non zero value
for the first time (due to performance reasons),
and as as result of this, it is pointless to emulate #GP condition on
this first access, in a different way than what the host CPU does.

This is based on a patch from Sean Christopherson, who suggested this idea.

Fixes: 6441fa6178f5 ("KVM: x86: avoid incorrect writes to host MSR_IA32_SPEC_CTRL")
Cc: stable@vger.kernel.org
Suggested-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20200708115731.180097-1-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Thomas Lamprecht <t.lamprecht@proxmox.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/svm.c     |    2 +-
 arch/x86/kvm/vmx/vmx.c |    2 +-
 arch/x86/kvm/x86.c     |   40 ++++++++++++++++++++++------------------
 arch/x86/kvm/x86.h     |    2 +-
 4 files changed, 25 insertions(+), 21 deletions(-)

--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4327,7 +4327,7 @@ static int svm_set_msr(struct kvm_vcpu *
 		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
-		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
+		if (kvm_spec_ctrl_test_value(data))
 			return 1;
 
 		svm->spec_ctrl = data;
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1974,7 +1974,7 @@ static int vmx_set_msr(struct kvm_vcpu *
 		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
-		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
+		if (kvm_spec_ctrl_test_value(data))
 			return 1;
 
 		vmx->spec_ctrl = data;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10374,28 +10374,32 @@ bool kvm_arch_no_poll(struct kvm_vcpu *v
 }
 EXPORT_SYMBOL_GPL(kvm_arch_no_poll);
 
-u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu)
+
+int kvm_spec_ctrl_test_value(u64 value)
 {
-	uint64_t bits = SPEC_CTRL_IBRS | SPEC_CTRL_STIBP | SPEC_CTRL_SSBD;
+	/*
+	 * test that setting IA32_SPEC_CTRL to given value
+	 * is allowed by the host processor
+	 */
+
+	u64 saved_value;
+	unsigned long flags;
+	int ret = 0;
+
+	local_irq_save(flags);
+
+	if (rdmsrl_safe(MSR_IA32_SPEC_CTRL, &saved_value))
+		ret = 1;
+	else if (wrmsrl_safe(MSR_IA32_SPEC_CTRL, value))
+		ret = 1;
+	else
+		wrmsrl(MSR_IA32_SPEC_CTRL, saved_value);
 
-	/* The STIBP bit doesn't fault even if it's not advertised */
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
-	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS))
-		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
-	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL) &&
-	    !boot_cpu_has(X86_FEATURE_AMD_IBRS))
-		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
-
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL_SSBD) &&
-	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
-		bits &= ~SPEC_CTRL_SSBD;
-	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) &&
-	    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
-		bits &= ~SPEC_CTRL_SSBD;
+	local_irq_restore(flags);
 
-	return bits;
+	return ret;
 }
-EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
+EXPORT_SYMBOL_GPL(kvm_spec_ctrl_test_value);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -368,6 +368,6 @@ static inline bool kvm_pat_valid(u64 dat
 
 void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
 void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
-u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
+int kvm_spec_ctrl_test_value(u64 value);
 
 #endif


