Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95C403C5127
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344696AbhGLHiI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:38:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:55812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243809AbhGLHgi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:36:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB1B86144A;
        Mon, 12 Jul 2021 07:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075148;
        bh=iCupDYR1VQc1hw+soXLyxVpeELTUIczXD5VxJ6o5XXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SM67x9DiZy+apQFXnuLHXPjNWVSLnSoNyW1SnLngggco6STRRvaN27CsQKPdbnKRE
         0A9ROxlXXcd+/Ed1hCrKdhnFHIH/Xw6L5VwEAkWZ9/OtLdq3CzUG/R5uoMx7RfWmGX
         NgvUQyyfRD1thiCDei1aPvxc5z/gdyKMc4hl0Qgg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.13 079/800] KVM: x86: Properly reset MMU context at vCPU RESET/INIT
Date:   Mon, 12 Jul 2021 08:01:42 +0200
Message-Id: <20210712060924.247022280@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

commit 0aa1837533e5f4be8cc21bbc06314c23ba2c5447 upstream.

Reset the MMU context at vCPU INIT (and RESET for good measure) if CR0.PG
was set prior to INIT.  Simply re-initializing the current MMU is not
sufficient as the current root HPA may not be usable in the new context.
E.g. if TDP is disabled and INIT arrives while the vCPU is in long mode,
KVM will fail to switch to the 32-bit pae_root and bomb on the next
VM-Enter due to running with a 64-bit CR3 in 32-bit mode.

This bug was papered over in both VMX and SVM, but still managed to rear
its head in the MMU role on VMX.  Because EFER.LMA=1 requires CR0.PG=1,
kvm_calc_shadow_mmu_root_page_role() checks for EFER.LMA without first
checking CR0.PG.  VMX's RESET/INIT flow writes CR0 before EFER, and so
an INIT with the vCPU in 64-bit mode will cause the hack-a-fix to
generate the wrong MMU role.

In VMX, the INIT issue is specific to running without unrestricted guest
since unrestricted guest is available if and only if EPT is enabled.
Commit 8668a3c468ed ("KVM: VMX: Reset mmu context when entering real
mode") resolved the issue by forcing a reset when entering emulated real
mode.

In SVM, commit ebae871a509d ("kvm: svm: reset mmu on VCPU reset") forced
a MMU reset on every INIT to workaround the flaw in common x86.  Note, at
the time the bug was fixed, the SVM problem was exacerbated by a complete
lack of a CR4 update.

The vendor resets will be reverted in future patches, primarily to aid
bisection in case there are non-INIT flows that rely on the existing VMX
logic.

Because CR0.PG is unconditionally cleared on INIT, and because CR0.WP and
all CR4/EFER paging bits are ignored if CR0.PG=0, simply checking that
CR0.PG was '1' prior to INIT/RESET is sufficient to detect a required MMU
context reset.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210622175739.3610207-4-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kvm/x86.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -10454,6 +10454,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vc
 
 void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 {
+	unsigned long old_cr0 = kvm_read_cr0(vcpu);
+
 	kvm_lapic_reset(vcpu, init_event);
 
 	vcpu->arch.hflags = 0;
@@ -10522,6 +10524,17 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcp
 	vcpu->arch.ia32_xss = 0;
 
 	static_call(kvm_x86_vcpu_reset)(vcpu, init_event);
+
+	/*
+	 * Reset the MMU context if paging was enabled prior to INIT (which is
+	 * implied if CR0.PG=1 as CR0 will be '0' prior to RESET).  Unlike the
+	 * standard CR0/CR4/EFER modification paths, only CR0.PG needs to be
+	 * checked because it is unconditionally cleared on INIT and all other
+	 * paging related bits are ignored if paging is disabled, i.e. CR0.WP,
+	 * CR4, and EFER changes are all irrelevant if CR0.PG was '0'.
+	 */
+	if (old_cr0 & X86_CR0_PG)
+		kvm_mmu_reset_context(vcpu);
 }
 
 void kvm_vcpu_deliver_sipi_vector(struct kvm_vcpu *vcpu, u8 vector)


