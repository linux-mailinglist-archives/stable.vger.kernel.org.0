Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5342A6FB1
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730801AbfICQe0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:34:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730128AbfICQ2D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:03 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86D63238CE;
        Tue,  3 Sep 2019 16:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528082;
        bh=wmnQxp2HMkOFZp3HHAj1n4a4YWH3XlYXRZ8LgI+w4/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yoyppE6fZRn3KbXsCdTO13dgay3ElMxTUyD4gqHeGpf2RGLjrP4H7R7huAWP1+1Ys
         lxSjEejSEzlS5A9uHvxzRBmD4626wqmJ/COJ/SjkuzvYhqUmTqht39ITRPg60SFjB+
         TmZWSnWJHeT5JMnAunwosBeaVI4jOvW9BzOziPbw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>, kvm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 094/167] KVM: x86: Always use 32-bit SMRAM save state for 32-bit kernels
Date:   Tue,  3 Sep 2019 12:24:06 -0400
Message-Id: <20190903162519.7136-94-sashal@kernel.org>
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

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit b68f3cc7d978943fcf85148165b00594c38db776 ]

Invoking the 64-bit variation on a 32-bit kenrel will crash the guest,
trigger a WARN, and/or lead to a buffer overrun in the host, e.g.
rsm_load_state_64() writes r8-r15 unconditionally, but enum kvm_reg and
thus x86_emulate_ctxt._regs only define r8-r15 for CONFIG_X86_64.

KVM allows userspace to report long mode support via CPUID, even though
the guest is all but guaranteed to crash if it actually tries to enable
long mode.  But, a pure 32-bit guest that is ignorant of long mode will
happily plod along.

SMM complicates things as 64-bit CPUs use a different SMRAM save state
area.  KVM handles this correctly for 64-bit kernels, e.g. uses the
legacy save state map if userspace has hid long mode from the guest,
but doesn't fare well when userspace reports long mode support on a
32-bit host kernel (32-bit KVM doesn't support 64-bit guests).

Since the alternative is to crash the guest, e.g. by not loading state
or explicitly requesting shutdown, unconditionally use the legacy SMRAM
save state map for 32-bit KVM.  If a guest has managed to get far enough
to handle SMIs when running under a weird/buggy userspace hypervisor,
then don't deliberately crash the guest since there are no downsides
(from KVM's perspective) to allow it to continue running.

Fixes: 660a5d517aaab ("KVM: x86: save/load state on SMM switch")
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/emulate.c | 10 ++++++++++
 arch/x86/kvm/x86.c     | 10 ++++++----
 2 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index 4a688ef9e4481..429728b35bca1 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -2331,12 +2331,16 @@ static int em_lseg(struct x86_emulate_ctxt *ctxt)
 
 static int emulator_has_longmode(struct x86_emulate_ctxt *ctxt)
 {
+#ifdef CONFIG_X86_64
 	u32 eax, ebx, ecx, edx;
 
 	eax = 0x80000001;
 	ecx = 0;
 	ctxt->ops->get_cpuid(ctxt, &eax, &ebx, &ecx, &edx, false);
 	return edx & bit(X86_FEATURE_LM);
+#else
+	return false;
+#endif
 }
 
 #define GET_SMSTATE(type, smbase, offset)				  \
@@ -2381,6 +2385,7 @@ static int rsm_load_seg_32(struct x86_emulate_ctxt *ctxt, u64 smbase, int n)
 	return X86EMUL_CONTINUE;
 }
 
+#ifdef CONFIG_X86_64
 static int rsm_load_seg_64(struct x86_emulate_ctxt *ctxt, u64 smbase, int n)
 {
 	struct desc_struct desc;
@@ -2399,6 +2404,7 @@ static int rsm_load_seg_64(struct x86_emulate_ctxt *ctxt, u64 smbase, int n)
 	ctxt->ops->set_segment(ctxt, selector, &desc, base3, n);
 	return X86EMUL_CONTINUE;
 }
+#endif
 
 static int rsm_enter_protected_mode(struct x86_emulate_ctxt *ctxt,
 				    u64 cr0, u64 cr3, u64 cr4)
@@ -2499,6 +2505,7 @@ static int rsm_load_state_32(struct x86_emulate_ctxt *ctxt, u64 smbase)
 	return rsm_enter_protected_mode(ctxt, cr0, cr3, cr4);
 }
 
+#ifdef CONFIG_X86_64
 static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt, u64 smbase)
 {
 	struct desc_struct desc;
@@ -2560,6 +2567,7 @@ static int rsm_load_state_64(struct x86_emulate_ctxt *ctxt, u64 smbase)
 
 	return X86EMUL_CONTINUE;
 }
+#endif
 
 static int em_rsm(struct x86_emulate_ctxt *ctxt)
 {
@@ -2616,9 +2624,11 @@ static int em_rsm(struct x86_emulate_ctxt *ctxt)
 	if (ctxt->ops->pre_leave_smm(ctxt, smbase))
 		return X86EMUL_UNHANDLEABLE;
 
+#ifdef CONFIG_X86_64
 	if (emulator_has_longmode(ctxt))
 		ret = rsm_load_state_64(ctxt, smbase + 0x8000);
 	else
+#endif
 		ret = rsm_load_state_32(ctxt, smbase + 0x8000);
 
 	if (ret != X86EMUL_CONTINUE) {
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 253326aaea9ac..1b80b4bd0fbf2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -7226,9 +7226,9 @@ static void enter_smm_save_state_32(struct kvm_vcpu *vcpu, char *buf)
 	put_smstate(u32, buf, 0x7ef8, vcpu->arch.smbase);
 }
 
+#ifdef CONFIG_X86_64
 static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
 {
-#ifdef CONFIG_X86_64
 	struct desc_ptr dt;
 	struct kvm_segment seg;
 	unsigned long val;
@@ -7278,10 +7278,8 @@ static void enter_smm_save_state_64(struct kvm_vcpu *vcpu, char *buf)
 
 	for (i = 0; i < 6; i++)
 		enter_smm_save_seg_64(vcpu, buf, i);
-#else
-	WARN_ON_ONCE(1);
-#endif
 }
+#endif
 
 static void enter_smm(struct kvm_vcpu *vcpu)
 {
@@ -7292,9 +7290,11 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 
 	trace_kvm_enter_smm(vcpu->vcpu_id, vcpu->arch.smbase, true);
 	memset(buf, 0, 512);
+#ifdef CONFIG_X86_64
 	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
 		enter_smm_save_state_64(vcpu, buf);
 	else
+#endif
 		enter_smm_save_state_32(vcpu, buf);
 
 	/*
@@ -7352,8 +7352,10 @@ static void enter_smm(struct kvm_vcpu *vcpu)
 	kvm_set_segment(vcpu, &ds, VCPU_SREG_GS);
 	kvm_set_segment(vcpu, &ds, VCPU_SREG_SS);
 
+#ifdef CONFIG_X86_64
 	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
 		kvm_x86_ops->set_efer(vcpu, 0);
+#endif
 
 	kvm_update_cpuid(vcpu);
 	kvm_mmu_reset_context(vcpu);
-- 
2.20.1

