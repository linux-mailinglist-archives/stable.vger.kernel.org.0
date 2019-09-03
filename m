Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A469FA6FB7
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730973AbfICQej (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:34:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:49700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731012AbfICQ2C (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:02 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CF9F238C7;
        Tue,  3 Sep 2019 16:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528081;
        bh=gzq+NjRgMmksXn34dkQZ3dKzR8VqerRUJi/9FJJrSjg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LllWghzMchxxaIVlx9oXSA79k5f4wFgQdZ9mYJowlWe01I9YmHl975S5f6OtKZb5V
         h1FRDNJ5GunmMO1SIelePd4r9W6V6bcBTi9kZ2VmJXyrpnZ3zILnJsdGHFCrlBFYey
         X2c5ZYbHUg472jEQJ/Dge9cAVvpHA5t+aksu3MNQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     WANG Chao <chao.wang@ucloud.cn>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 093/167] x86/kvm: move kvm_load/put_guest_xcr0 into atomic context
Date:   Tue,  3 Sep 2019 12:24:05 -0400
Message-Id: <20190903162519.7136-93-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: WANG Chao <chao.wang@ucloud.cn>

[ Upstream commit 1811d979c71621aafc7b879477202d286f7e863b ]

guest xcr0 could leak into host when MCE happens in guest mode. Because
do_machine_check() could schedule out at a few places.

For example:

kvm_load_guest_xcr0
...
kvm_x86_ops->run(vcpu) {
  vmx_vcpu_run
    vmx_complete_atomic_exit
      kvm_machine_check
        do_machine_check
          do_memory_failure
            memory_failure
              lock_page

In this case, host_xcr0 is 0x2ff, guest vcpu xcr0 is 0xff. After schedule
out, host cpu has guest xcr0 loaded (0xff).

In __switch_to {
     switch_fpu_finish
       copy_kernel_to_fpregs
         XRSTORS

If any bit i in XSTATE_BV[i] == 1 and xcr0[i] == 0, XRSTORS will
generate #GP (In this case, bit 9). Then ex_handler_fprestore kicks in
and tries to reinitialize fpu by restoring init fpu state. Same story as
last #GP, except we get DOUBLE FAULT this time.

Cc: stable@vger.kernel.org
Signed-off-by: WANG Chao <chao.wang@ucloud.cn>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm.c |  2 ++
 arch/x86/kvm/vmx.c |  4 ++++
 arch/x86/kvm/x86.c | 10 ++++------
 arch/x86/kvm/x86.h |  2 ++
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index 0f33f00aa4dfe..ac2cc2ed7a85f 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -5622,6 +5622,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	svm->vmcb->save.cr2 = vcpu->arch.cr2;
 
 	clgi();
+	kvm_load_guest_xcr0(vcpu);
 
 	/*
 	 * If this vCPU has touched SPEC_CTRL, restore the guest's value if
@@ -5769,6 +5770,7 @@ static void svm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(&svm->vcpu);
 
+	kvm_put_guest_xcr0(vcpu);
 	stgi();
 
 	/* Any pending NMI will happen here */
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 562f5dc4645b6..ee9ff20da3902 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -10756,6 +10756,8 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	if (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)
 		vmx_set_interrupt_shadow(vcpu, 0);
 
+	kvm_load_guest_xcr0(vcpu);
+
 	if (static_cpu_has(X86_FEATURE_PKU) &&
 	    kvm_read_cr4_bits(vcpu, X86_CR4_PKE) &&
 	    vcpu->arch.pkru != vmx->host_pkru)
@@ -10971,6 +10973,8 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 			__write_pkru(vmx->host_pkru);
 	}
 
+	kvm_put_guest_xcr0(vcpu);
+
 	vmx->nested.nested_run_pending = 0;
 	vmx->idt_vectoring_info = 0;
 
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4f564dc17c333..253326aaea9ac 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -713,7 +713,7 @@ void kvm_lmsw(struct kvm_vcpu *vcpu, unsigned long msw)
 }
 EXPORT_SYMBOL_GPL(kvm_lmsw);
 
-static void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu)
+void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu)
 {
 	if (kvm_read_cr4_bits(vcpu, X86_CR4_OSXSAVE) &&
 			!vcpu->guest_xcr0_loaded) {
@@ -723,8 +723,9 @@ static void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu)
 		vcpu->guest_xcr0_loaded = 1;
 	}
 }
+EXPORT_SYMBOL_GPL(kvm_load_guest_xcr0);
 
-static void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu)
+void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu)
 {
 	if (vcpu->guest_xcr0_loaded) {
 		if (vcpu->arch.xcr0 != host_xcr0)
@@ -732,6 +733,7 @@ static void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu)
 		vcpu->guest_xcr0_loaded = 0;
 	}
 }
+EXPORT_SYMBOL_GPL(kvm_put_guest_xcr0);
 
 static int __kvm_set_xcr(struct kvm_vcpu *vcpu, u32 index, u64 xcr)
 {
@@ -7648,8 +7650,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		goto cancel_injection;
 	}
 
-	kvm_load_guest_xcr0(vcpu);
-
 	if (req_immediate_exit) {
 		kvm_make_request(KVM_REQ_EVENT, vcpu);
 		kvm_x86_ops->request_immediate_exit(vcpu);
@@ -7702,8 +7702,6 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 	vcpu->mode = OUTSIDE_GUEST_MODE;
 	smp_wmb();
 
-	kvm_put_guest_xcr0(vcpu);
-
 	kvm_before_interrupt(vcpu);
 	kvm_x86_ops->handle_external_intr(vcpu);
 	kvm_after_interrupt(vcpu);
diff --git a/arch/x86/kvm/x86.h b/arch/x86/kvm/x86.h
index 1826ed9dd1c8f..8889e0c029a70 100644
--- a/arch/x86/kvm/x86.h
+++ b/arch/x86/kvm/x86.h
@@ -345,4 +345,6 @@ static inline void kvm_after_interrupt(struct kvm_vcpu *vcpu)
 	__this_cpu_write(current_vcpu, NULL);
 }
 
+void kvm_load_guest_xcr0(struct kvm_vcpu *vcpu);
+void kvm_put_guest_xcr0(struct kvm_vcpu *vcpu);
 #endif
-- 
2.20.1

