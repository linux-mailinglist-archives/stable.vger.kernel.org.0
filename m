Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0CC031BCF8
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 16:38:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbhBOPhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 10:37:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:49598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231195AbhBOPgz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 10:36:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B789E64E95;
        Mon, 15 Feb 2021 15:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613403152;
        bh=Z6zA4YjEHvL5sTyAuNPMYVZfJqzVp0yb+RJGVduycbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NLUymA6RPphiTrBUZ4No6ov+3Ao1dcUlSclfW8/EU7VV6vaFxrznnqL4/VNRmOzFH
         4EqGtbuZFfZaJ6nYOeTXbn4dz7E6d3fEN3YwRlfFEg7Icjo3XSDYMbC7v9YB+wyrEN
         N6CB26Nzt1movYWJfYZnTYgxVlkaiPiOWLc0G0lA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 048/104] KVM: x86: cleanup CR3 reserved bits checks
Date:   Mon, 15 Feb 2021 16:27:01 +0100
Message-Id: <20210215152721.031370031@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210215152719.459796636@linuxfoundation.org>
References: <20210215152719.459796636@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit c1c35cf78bfab31b8cb455259524395c9e4c7cd6 ]

If not in long mode, the low bits of CR3 are reserved but not enforced to
be zero, so remove those checks.  If in long mode, however, the MBZ bits
extend down to the highest physical address bit of the guest, excluding
the encryption bit.

Make the checks consistent with the above, and match them between
nested_vmcb_checks and KVM_SET_SREGS.

Cc: stable@vger.kernel.org
Fixes: 761e41693465 ("KVM: nSVM: Check that MBZ bits in CR3 and CR4 are not set on vmrun of nested guests")
Fixes: a780a3ea6282 ("KVM: X86: Fix reserved bits check for MOV to CR3")
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/svm/nested.c | 13 +++----------
 arch/x86/kvm/svm/svm.h    |  3 ---
 arch/x86/kvm/x86.c        |  2 ++
 3 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 65e40acde71aa..4fbe190c79159 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -231,6 +231,7 @@ static bool nested_vmcb_check_controls(struct vmcb_control_area *control)
 
 static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
 {
+	struct kvm_vcpu *vcpu = &svm->vcpu;
 	bool vmcb12_lma;
 
 	if ((vmcb12->save.efer & EFER_SVME) == 0)
@@ -244,18 +245,10 @@ static bool nested_vmcb_checks(struct vcpu_svm *svm, struct vmcb *vmcb12)
 
 	vmcb12_lma = (vmcb12->save.efer & EFER_LME) && (vmcb12->save.cr0 & X86_CR0_PG);
 
-	if (!vmcb12_lma) {
-		if (vmcb12->save.cr4 & X86_CR4_PAE) {
-			if (vmcb12->save.cr3 & MSR_CR3_LEGACY_PAE_RESERVED_MASK)
-				return false;
-		} else {
-			if (vmcb12->save.cr3 & MSR_CR3_LEGACY_RESERVED_MASK)
-				return false;
-		}
-	} else {
+	if (vmcb12_lma) {
 		if (!(vmcb12->save.cr4 & X86_CR4_PAE) ||
 		    !(vmcb12->save.cr0 & X86_CR0_PE) ||
-		    (vmcb12->save.cr3 & MSR_CR3_LONG_MBZ_MASK))
+		    (vmcb12->save.cr3 & vcpu->arch.cr3_lm_rsvd_bits))
 			return false;
 	}
 	if (kvm_valid_cr4(&svm->vcpu, vmcb12->save.cr4))
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1d853fe4c778b..be74e22b82ea7 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -346,9 +346,6 @@ static inline bool gif_set(struct vcpu_svm *svm)
 }
 
 /* svm.c */
-#define MSR_CR3_LEGACY_RESERVED_MASK		0xfe7U
-#define MSR_CR3_LEGACY_PAE_RESERVED_MASK	0x7U
-#define MSR_CR3_LONG_MBZ_MASK			0xfff0000000000000U
 #define MSR_INVALID				0xffffffffU
 
 u32 svm_msrpm_offset(u32 msr);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 18a315bbcb79e..3bcde449938e6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9558,6 +9558,8 @@ static int kvm_valid_sregs(struct kvm_vcpu *vcpu, struct kvm_sregs *sregs)
 		if (!(sregs->cr4 & X86_CR4_PAE)
 		    || !(sregs->efer & EFER_LMA))
 			return -EINVAL;
+		if (sregs->cr3 & vcpu->arch.cr3_lm_rsvd_bits)
+			return false;
 	} else {
 		/*
 		 * Not in 64-bit mode: EFER.LMA is clear and the code
-- 
2.27.0



