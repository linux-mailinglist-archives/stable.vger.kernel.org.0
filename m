Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D950B3263F4
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 15:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbhBZOVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Feb 2021 09:21:13 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:46878 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229545AbhBZOVN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Feb 2021 09:21:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614349186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=0QvGx18Asyy+RiyJ26+wi8+cjduIsHJXkwNI7JnyOfE=;
        b=DFNZCsJbs0QC2NILXkZZ3Tood43BaFGHIO6NxboNnfgptOg8hR787T5IIpimrwiqmkUv9/
        ec+UY45IVWM3XNve/qe03W0BHRlMq0dInJnmRVZLJnJ2t19iV1ZcCo4/WrjNy1AI4NNNdK
        tuhNErXY/wGh+/kz9IFduhAho0l70JI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-454-ymeovn3MNSKj2vjbCCc8KQ-1; Fri, 26 Feb 2021 09:19:43 -0500
X-MC-Unique: ymeovn3MNSKj2vjbCCc8KQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E122250741;
        Fri, 26 Feb 2021 14:19:41 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2940A5C233;
        Fri, 26 Feb 2021 14:19:41 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     stable@vger.kernel.org
Cc:     t.lamprecht@proxmox.com, Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Subject: [PATCH] kvm: x86: replace kvm_spec_ctrl_test_value with runtime test on the host
Date:   Fri, 26 Feb 2021 09:19:40 -0500
Message-Id: <20210226141940.181194-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Levitsky <mlevitsk@redhat.com>

[ upstream commit 841c2be09fe4f495fe5224952a419bd8c7e5b455 ]

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
---
 arch/x86/kvm/svm.c     |  2 +-
 arch/x86/kvm/vmx/vmx.c |  2 +-
 arch/x86/kvm/x86.c     | 38 +++++++++++++++++++++-----------------
 arch/x86/kvm/x86.h     |  2 +-
 4 files changed, 24 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 296b0d7570d0..282e380e6345 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -4327,7 +4327,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
-		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
+		if (kvm_spec_ctrl_test_value(data))
 			return 1;
 
 		svm->spec_ctrl = data;
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index e7fd2f00edc1..e177848a3631 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1974,7 +1974,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		    !guest_has_spec_ctrl_msr(vcpu))
 			return 1;
 
-		if (data & ~kvm_spec_ctrl_valid_bits(vcpu))
+		if (kvm_spec_ctrl_test_value(data))
 			return 1;
 
 		vmx->spec_ctrl = data;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 73095d721399..153659e8f403 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10374,28 +10374,32 @@ bool kvm_arch_no_poll(struct kvm_vcpu *vcpu)
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
 
-	/* The STIBP bit doesn't fault even if it's not advertised */
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
-	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS))
-		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
-	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL) &&
-	    !boot_cpu_has(X86_FEATURE_AMD_IBRS))
-		bits &= ~(SPEC_CTRL_IBRS | SPEC_CTRL_STIBP);
+	local_irq_save(flags);
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL_SSBD) &&
-	    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD))
-		bits &= ~SPEC_CTRL_SSBD;
-	if (!boot_cpu_has(X86_FEATURE_SPEC_CTRL_SSBD) &&
-	    !boot_cpu_has(X86_FEATURE_AMD_SSBD))
-		bits &= ~SPEC_CTRL_SSBD;
+	if (rdmsrl_safe(MSR_IA32_SPEC_CTRL, &saved_value))
+		ret = 1;
+	else if (wrmsrl_safe(MSR_IA32_SPEC_CTRL, value))
+		ret = 1;
+	else
+		wrmsrl(MSR_IA32_SPEC_CTRL, saved_value);
 
-	return bits;
+	local_irq_restore(flags);
+
+	return ret;
 }
-EXPORT_SYMBOL_GPL(kvm_spec_ctrl_valid_bits);
+EXPORT_SYMBOL_GPL(kvm_spec_ctrl_test_value);
 
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_exit);
 EXPORT_TRACEPOINT_SYMBOL_GPL(kvm_fast_mmio);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 301286d92432..c520d373790a 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -368,6 +368,6 @@ static inline bool kvm_pat_valid(u64 data)
 
 void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
 void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
-u64 kvm_spec_ctrl_valid_bits(struct kvm_vcpu *vcpu);
+int kvm_spec_ctrl_test_value(u64 value);
 
 #endif
-- 
2.26.2

