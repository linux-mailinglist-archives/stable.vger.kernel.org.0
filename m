Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDBF246AA1
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 17:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730651AbgHQPjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 11:39:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:47950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730647AbgHQPj0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 11:39:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4518F208E4;
        Mon, 17 Aug 2020 15:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597678765;
        bh=H4vSDaCyjxKZTYeROfoR5iI4z/cm28X+ppZfsnqP+G4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BB/vpP5eH8Z/xrGXSMBpfhvaTQ0vElpzdaloKwzIR9uQKFMJoa0b4ZzgwwnoH4//B
         tM3Qm+oFAQJWichB5vrXnBaiB8UX/rW5ZV2/7RoxPtXv7T4TWZC/LbizL3ZgykwHfj
         FkycaL1ukPe9sowvDULXzL4I83UFMuolh0T+z13o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.8 419/464] kvm: x86: replace kvm_spec_ctrl_test_value with runtime test on the host
Date:   Mon, 17 Aug 2020 17:16:12 +0200
Message-Id: <20200817143853.847481498@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143833.737102804@linuxfoundation.org>
References: <20200817143833.737102804@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/svm/svm.c |    2 +-
 arch/x86/kvm/vmx/vmx.c |    2 +-
 arch/x86/kvm/x86.c     |   40 ++++++++++++++++++++++------------------
 arch/x86/kvm/x86.h     |    2 +-
 4 files changed, 25 insertions(+), 21 deletions(-)

--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -2522,7 +2522,7 @@ static int svm_set_msr(struct kvm_vcpu *
 		    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
 			return 1;
 
-		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
+		if (kvm_spec_ctrl_test_value(data))
 			return 1;
 
 		svm->spec_ctrl = data;
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2062,7 +2062,7 @@ static int vmx_set_msr(struct kvm_vcpu *
 		    !guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
 			return 1;
 
-		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
+		if (kvm_spec_ctrl_test_value(data))
 			return 1;
 
 		vmx->spec_ctrl = data;
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10676,28 +10676,32 @@ bool kvm_arch_no_poll(struct kvm_vcpu *v
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
@@ -363,7 +363,7 @@ static inline bool kvm_dr7_valid(u64 dat
 
 void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu);
 void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu);
-u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
+int kvm_spec_ctrl_test_value(u64 value);
 bool kvm_vcpu_exit_request(struct kvm_vcpu *vcpu);
 
 #endif


