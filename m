Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE91CB1F5B
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389154AbfIMNSo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:18:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:46344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390253AbfIMNSn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:18:43 -0400
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5216206A5;
        Fri, 13 Sep 2019 13:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568380721;
        bh=wjPVZDNpf1ne6VkWo3z28b+bpBsCrl5aBCsA1BVOQDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VrknEn2dchblnvYKSls+LlS+nIinJLFIJP+oUaFFJb9jsdVQm+CEnabHy/Yv9hdGF
         UT/96dx9tRpEctaZfgZrYB5fs7DoBN12r6st3awl5wjgVT7Qw4uMoY6wkE15c9W/Pe
         x7IkN7EsLIrRih1ELCH0lQ/ALb5aJvbq9Jh8OVkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>,
        Paul Mackerras <paulus@ozlabs.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 156/190] KVM: PPC: Use ccr field in pt_regs struct embedded in vcpu struct
Date:   Fri, 13 Sep 2019 14:06:51 +0100
Message-Id: <20190913130612.388597658@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190913130559.669563815@linuxfoundation.org>
References: <20190913130559.669563815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit fd0944baad806dfb4c777124ec712c55b714ff51 ]

When the 'regs' field was added to struct kvm_vcpu_arch, the code
was changed to use several of the fields inside regs (e.g., gpr, lr,
etc.) but not the ccr field, because the ccr field in struct pt_regs
is 64 bits on 64-bit platforms, but the cr field in kvm_vcpu_arch is
only 32 bits.  This changes the code to use the regs.ccr field
instead of cr, and changes the assembly code on 64-bit platforms to
use 64-bit loads and stores instead of 32-bit ones.

Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: Paul Mackerras <paulus@ozlabs.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/kvm_book3s.h    |  4 ++--
 arch/powerpc/include/asm/kvm_book3s_64.h |  4 ++--
 arch/powerpc/include/asm/kvm_booke.h     |  4 ++--
 arch/powerpc/include/asm/kvm_host.h      |  2 --
 arch/powerpc/kernel/asm-offsets.c        |  4 ++--
 arch/powerpc/kvm/book3s_emulate.c        | 12 ++++++------
 arch/powerpc/kvm/book3s_hv.c             |  4 ++--
 arch/powerpc/kvm/book3s_hv_rmhandlers.S  |  4 ++--
 arch/powerpc/kvm/book3s_hv_tm.c          |  6 +++---
 arch/powerpc/kvm/book3s_hv_tm_builtin.c  |  5 +++--
 arch/powerpc/kvm/book3s_pr.c             |  4 ++--
 arch/powerpc/kvm/bookehv_interrupts.S    |  8 ++++----
 arch/powerpc/kvm/emulate_loadstore.c     |  1 -
 13 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/arch/powerpc/include/asm/kvm_book3s.h b/arch/powerpc/include/asm/kvm_book3s.h
index 83a9aa3cf6891..dd18d8174504f 100644
--- a/arch/powerpc/include/asm/kvm_book3s.h
+++ b/arch/powerpc/include/asm/kvm_book3s.h
@@ -301,12 +301,12 @@ static inline ulong kvmppc_get_gpr(struct kvm_vcpu *vcpu, int num)
 
 static inline void kvmppc_set_cr(struct kvm_vcpu *vcpu, u32 val)
 {
-	vcpu->arch.cr = val;
+	vcpu->arch.regs.ccr = val;
 }
 
 static inline u32 kvmppc_get_cr(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.cr;
+	return vcpu->arch.regs.ccr;
 }
 
 static inline void kvmppc_set_xer(struct kvm_vcpu *vcpu, ulong val)
diff --git a/arch/powerpc/include/asm/kvm_book3s_64.h b/arch/powerpc/include/asm/kvm_book3s_64.h
index dc435a5af7d6c..14fa07c73f44d 100644
--- a/arch/powerpc/include/asm/kvm_book3s_64.h
+++ b/arch/powerpc/include/asm/kvm_book3s_64.h
@@ -482,7 +482,7 @@ static inline u64 sanitize_msr(u64 msr)
 #ifdef CONFIG_PPC_TRANSACTIONAL_MEM
 static inline void copy_from_checkpoint(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.cr  = vcpu->arch.cr_tm;
+	vcpu->arch.regs.ccr  = vcpu->arch.cr_tm;
 	vcpu->arch.regs.xer = vcpu->arch.xer_tm;
 	vcpu->arch.regs.link  = vcpu->arch.lr_tm;
 	vcpu->arch.regs.ctr = vcpu->arch.ctr_tm;
@@ -499,7 +499,7 @@ static inline void copy_from_checkpoint(struct kvm_vcpu *vcpu)
 
 static inline void copy_to_checkpoint(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.cr_tm  = vcpu->arch.cr;
+	vcpu->arch.cr_tm  = vcpu->arch.regs.ccr;
 	vcpu->arch.xer_tm = vcpu->arch.regs.xer;
 	vcpu->arch.lr_tm  = vcpu->arch.regs.link;
 	vcpu->arch.ctr_tm = vcpu->arch.regs.ctr;
diff --git a/arch/powerpc/include/asm/kvm_booke.h b/arch/powerpc/include/asm/kvm_booke.h
index d513e3ed1c659..f0cef625f17ce 100644
--- a/arch/powerpc/include/asm/kvm_booke.h
+++ b/arch/powerpc/include/asm/kvm_booke.h
@@ -46,12 +46,12 @@ static inline ulong kvmppc_get_gpr(struct kvm_vcpu *vcpu, int num)
 
 static inline void kvmppc_set_cr(struct kvm_vcpu *vcpu, u32 val)
 {
-	vcpu->arch.cr = val;
+	vcpu->arch.regs.ccr = val;
 }
 
 static inline u32 kvmppc_get_cr(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.cr;
+	return vcpu->arch.regs.ccr;
 }
 
 static inline void kvmppc_set_xer(struct kvm_vcpu *vcpu, ulong val)
diff --git a/arch/powerpc/include/asm/kvm_host.h b/arch/powerpc/include/asm/kvm_host.h
index 2b6049e839706..2f95e38f05491 100644
--- a/arch/powerpc/include/asm/kvm_host.h
+++ b/arch/powerpc/include/asm/kvm_host.h
@@ -538,8 +538,6 @@ struct kvm_vcpu_arch {
 	ulong tar;
 #endif
 
-	u32 cr;
-
 #ifdef CONFIG_PPC_BOOK3S
 	ulong hflags;
 	ulong guest_owned_ext;
diff --git a/arch/powerpc/kernel/asm-offsets.c b/arch/powerpc/kernel/asm-offsets.c
index 89cf15566c4e8..7c3738d890e8b 100644
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -438,7 +438,7 @@ int main(void)
 #ifdef CONFIG_PPC_BOOK3S
 	OFFSET(VCPU_TAR, kvm_vcpu, arch.tar);
 #endif
-	OFFSET(VCPU_CR, kvm_vcpu, arch.cr);
+	OFFSET(VCPU_CR, kvm_vcpu, arch.regs.ccr);
 	OFFSET(VCPU_PC, kvm_vcpu, arch.regs.nip);
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 	OFFSET(VCPU_MSR, kvm_vcpu, arch.shregs.msr);
@@ -695,7 +695,7 @@ int main(void)
 #endif /* CONFIG_PPC_BOOK3S_64 */
 
 #else /* CONFIG_PPC_BOOK3S */
-	OFFSET(VCPU_CR, kvm_vcpu, arch.cr);
+	OFFSET(VCPU_CR, kvm_vcpu, arch.regs.ccr);
 	OFFSET(VCPU_XER, kvm_vcpu, arch.regs.xer);
 	OFFSET(VCPU_LR, kvm_vcpu, arch.regs.link);
 	OFFSET(VCPU_CTR, kvm_vcpu, arch.regs.ctr);
diff --git a/arch/powerpc/kvm/book3s_emulate.c b/arch/powerpc/kvm/book3s_emulate.c
index 36b11c5a0dbb9..2654df220d054 100644
--- a/arch/powerpc/kvm/book3s_emulate.c
+++ b/arch/powerpc/kvm/book3s_emulate.c
@@ -110,7 +110,7 @@ static inline void kvmppc_copyto_vcpu_tm(struct kvm_vcpu *vcpu)
 	vcpu->arch.ctr_tm = vcpu->arch.regs.ctr;
 	vcpu->arch.tar_tm = vcpu->arch.tar;
 	vcpu->arch.lr_tm = vcpu->arch.regs.link;
-	vcpu->arch.cr_tm = vcpu->arch.cr;
+	vcpu->arch.cr_tm = vcpu->arch.regs.ccr;
 	vcpu->arch.xer_tm = vcpu->arch.regs.xer;
 	vcpu->arch.vrsave_tm = vcpu->arch.vrsave;
 }
@@ -129,7 +129,7 @@ static inline void kvmppc_copyfrom_vcpu_tm(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs.ctr = vcpu->arch.ctr_tm;
 	vcpu->arch.tar = vcpu->arch.tar_tm;
 	vcpu->arch.regs.link = vcpu->arch.lr_tm;
-	vcpu->arch.cr = vcpu->arch.cr_tm;
+	vcpu->arch.regs.ccr = vcpu->arch.cr_tm;
 	vcpu->arch.regs.xer = vcpu->arch.xer_tm;
 	vcpu->arch.vrsave = vcpu->arch.vrsave_tm;
 }
@@ -141,7 +141,7 @@ static void kvmppc_emulate_treclaim(struct kvm_vcpu *vcpu, int ra_val)
 	uint64_t texasr;
 
 	/* CR0 = 0 | MSR[TS] | 0 */
-	vcpu->arch.cr = (vcpu->arch.cr & ~(CR0_MASK << CR0_SHIFT)) |
+	vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & ~(CR0_MASK << CR0_SHIFT)) |
 		(((guest_msr & MSR_TS_MASK) >> (MSR_TS_S_LG - 1))
 		 << CR0_SHIFT);
 
@@ -220,7 +220,7 @@ void kvmppc_emulate_tabort(struct kvm_vcpu *vcpu, int ra_val)
 	tm_abort(ra_val);
 
 	/* CR0 = 0 | MSR[TS] | 0 */
-	vcpu->arch.cr = (vcpu->arch.cr & ~(CR0_MASK << CR0_SHIFT)) |
+	vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & ~(CR0_MASK << CR0_SHIFT)) |
 		(((guest_msr & MSR_TS_MASK) >> (MSR_TS_S_LG - 1))
 		 << CR0_SHIFT);
 
@@ -494,8 +494,8 @@ int kvmppc_core_emulate_op_pr(struct kvm_run *run, struct kvm_vcpu *vcpu,
 
 			if (!(kvmppc_get_msr(vcpu) & MSR_PR)) {
 				preempt_disable();
-				vcpu->arch.cr = (CR0_TBEGIN_FAILURE |
-				  (vcpu->arch.cr & ~(CR0_MASK << CR0_SHIFT)));
+				vcpu->arch.regs.ccr = (CR0_TBEGIN_FAILURE |
+				  (vcpu->arch.regs.ccr & ~(CR0_MASK << CR0_SHIFT)));
 
 				vcpu->arch.texasr = (TEXASR_FS | TEXASR_EXACT |
 					(((u64)(TM_CAUSE_EMULATE | TM_CAUSE_PERSISTENT))
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 9595db30e6b87..05b32cc12e417 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -410,8 +410,8 @@ static void kvmppc_dump_regs(struct kvm_vcpu *vcpu)
 	       vcpu->arch.shregs.sprg0, vcpu->arch.shregs.sprg1);
 	pr_err("sprg2 = %.16llx sprg3 = %.16llx\n",
 	       vcpu->arch.shregs.sprg2, vcpu->arch.shregs.sprg3);
-	pr_err("cr = %.8x  xer = %.16lx  dsisr = %.8x\n",
-	       vcpu->arch.cr, vcpu->arch.regs.xer, vcpu->arch.shregs.dsisr);
+	pr_err("cr = %.8lx  xer = %.16lx  dsisr = %.8x\n",
+	       vcpu->arch.regs.ccr, vcpu->arch.regs.xer, vcpu->arch.shregs.dsisr);
 	pr_err("dar = %.16llx\n", vcpu->arch.shregs.dar);
 	pr_err("fault dar = %.16lx dsisr = %.8x\n",
 	       vcpu->arch.fault_dar, vcpu->arch.fault_dsisr);
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 5902a60f92268..68c7591f2b5f7 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -1209,7 +1209,7 @@ BEGIN_FTR_SECTION
 END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 
 	ld	r5, VCPU_LR(r4)
-	lwz	r6, VCPU_CR(r4)
+	ld	r6, VCPU_CR(r4)
 	mtlr	r5
 	mtcr	r6
 
@@ -1320,7 +1320,7 @@ kvmppc_interrupt_hv:
 	std	r3, VCPU_GPR(R12)(r9)
 	/* CR is in the high half of r12 */
 	srdi	r4, r12, 32
-	stw	r4, VCPU_CR(r9)
+	std	r4, VCPU_CR(r9)
 BEGIN_FTR_SECTION
 	ld	r3, HSTATE_CFAR(r13)
 	std	r3, VCPU_CFAR(r9)
diff --git a/arch/powerpc/kvm/book3s_hv_tm.c b/arch/powerpc/kvm/book3s_hv_tm.c
index 008285058f9b5..888e2609e3f15 100644
--- a/arch/powerpc/kvm/book3s_hv_tm.c
+++ b/arch/powerpc/kvm/book3s_hv_tm.c
@@ -130,7 +130,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 			return RESUME_GUEST;
 		}
 		/* Set CR0 to indicate previous transactional state */
-		vcpu->arch.cr = (vcpu->arch.cr & 0x0fffffff) |
+		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
 			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 28);
 		/* L=1 => tresume, L=0 => tsuspend */
 		if (instr & (1 << 21)) {
@@ -174,7 +174,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		copy_from_checkpoint(vcpu);
 
 		/* Set CR0 to indicate previous transactional state */
-		vcpu->arch.cr = (vcpu->arch.cr & 0x0fffffff) |
+		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
 			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 28);
 		vcpu->arch.shregs.msr &= ~MSR_TS_MASK;
 		return RESUME_GUEST;
@@ -204,7 +204,7 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		copy_to_checkpoint(vcpu);
 
 		/* Set CR0 to indicate previous transactional state */
-		vcpu->arch.cr = (vcpu->arch.cr & 0x0fffffff) |
+		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
 			(((msr & MSR_TS_MASK) >> MSR_TS_S_LG) << 28);
 		vcpu->arch.shregs.msr = msr | MSR_TS_S;
 		return RESUME_GUEST;
diff --git a/arch/powerpc/kvm/book3s_hv_tm_builtin.c b/arch/powerpc/kvm/book3s_hv_tm_builtin.c
index b2c7c6fca4f96..3cf5863bc06e8 100644
--- a/arch/powerpc/kvm/book3s_hv_tm_builtin.c
+++ b/arch/powerpc/kvm/book3s_hv_tm_builtin.c
@@ -89,7 +89,8 @@ int kvmhv_p9_tm_emulation_early(struct kvm_vcpu *vcpu)
 		if (instr & (1 << 21))
 			vcpu->arch.shregs.msr = (msr & ~MSR_TS_MASK) | MSR_TS_T;
 		/* Set CR0 to 0b0010 */
-		vcpu->arch.cr = (vcpu->arch.cr & 0x0fffffff) | 0x20000000;
+		vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) |
+			0x20000000;
 		return 1;
 	}
 
@@ -105,5 +106,5 @@ void kvmhv_emulate_tm_rollback(struct kvm_vcpu *vcpu)
 	vcpu->arch.shregs.msr &= ~MSR_TS_MASK;	/* go to N state */
 	vcpu->arch.regs.nip = vcpu->arch.tfhar;
 	copy_from_checkpoint(vcpu);
-	vcpu->arch.cr = (vcpu->arch.cr & 0x0fffffff) | 0xa0000000;
+	vcpu->arch.regs.ccr = (vcpu->arch.regs.ccr & 0x0fffffff) | 0xa0000000;
 }
diff --git a/arch/powerpc/kvm/book3s_pr.c b/arch/powerpc/kvm/book3s_pr.c
index 614ebb4261f76..de9702219dee9 100644
--- a/arch/powerpc/kvm/book3s_pr.c
+++ b/arch/powerpc/kvm/book3s_pr.c
@@ -167,7 +167,7 @@ void kvmppc_copy_to_svcpu(struct kvm_vcpu *vcpu)
 	svcpu->gpr[11] = vcpu->arch.regs.gpr[11];
 	svcpu->gpr[12] = vcpu->arch.regs.gpr[12];
 	svcpu->gpr[13] = vcpu->arch.regs.gpr[13];
-	svcpu->cr  = vcpu->arch.cr;
+	svcpu->cr  = vcpu->arch.regs.ccr;
 	svcpu->xer = vcpu->arch.regs.xer;
 	svcpu->ctr = vcpu->arch.regs.ctr;
 	svcpu->lr  = vcpu->arch.regs.link;
@@ -249,7 +249,7 @@ void kvmppc_copy_from_svcpu(struct kvm_vcpu *vcpu)
 	vcpu->arch.regs.gpr[11] = svcpu->gpr[11];
 	vcpu->arch.regs.gpr[12] = svcpu->gpr[12];
 	vcpu->arch.regs.gpr[13] = svcpu->gpr[13];
-	vcpu->arch.cr  = svcpu->cr;
+	vcpu->arch.regs.ccr  = svcpu->cr;
 	vcpu->arch.regs.xer = svcpu->xer;
 	vcpu->arch.regs.ctr = svcpu->ctr;
 	vcpu->arch.regs.link  = svcpu->lr;
diff --git a/arch/powerpc/kvm/bookehv_interrupts.S b/arch/powerpc/kvm/bookehv_interrupts.S
index 612b7f6a887f8..4e5081e584098 100644
--- a/arch/powerpc/kvm/bookehv_interrupts.S
+++ b/arch/powerpc/kvm/bookehv_interrupts.S
@@ -186,7 +186,7 @@ END_BTB_FLUSH_SECTION
 	 */
 	PPC_LL	r4, PACACURRENT(r13)
 	PPC_LL	r4, (THREAD + THREAD_KVM_VCPU)(r4)
-	stw	r10, VCPU_CR(r4)
+	PPC_STL	r10, VCPU_CR(r4)
 	PPC_STL r11, VCPU_GPR(R4)(r4)
 	PPC_STL	r5, VCPU_GPR(R5)(r4)
 	PPC_STL	r6, VCPU_GPR(R6)(r4)
@@ -296,7 +296,7 @@ _GLOBAL(kvmppc_handler_\intno\()_\srr1)
 	PPC_STL	r4, VCPU_GPR(R4)(r11)
 	PPC_LL	r4, THREAD_NORMSAVE(0)(r10)
 	PPC_STL	r5, VCPU_GPR(R5)(r11)
-	stw	r13, VCPU_CR(r11)
+	PPC_STL	r13, VCPU_CR(r11)
 	mfspr	r5, \srr0
 	PPC_STL	r3, VCPU_GPR(R10)(r11)
 	PPC_LL	r3, THREAD_NORMSAVE(2)(r10)
@@ -323,7 +323,7 @@ _GLOBAL(kvmppc_handler_\intno\()_\srr1)
 	PPC_STL	r4, VCPU_GPR(R4)(r11)
 	PPC_LL	r4, GPR9(r8)
 	PPC_STL	r5, VCPU_GPR(R5)(r11)
-	stw	r9, VCPU_CR(r11)
+	PPC_STL	r9, VCPU_CR(r11)
 	mfspr	r5, \srr0
 	PPC_STL	r3, VCPU_GPR(R8)(r11)
 	PPC_LL	r3, GPR10(r8)
@@ -647,7 +647,7 @@ lightweight_exit:
 	PPC_LL	r3, VCPU_LR(r4)
 	PPC_LL	r5, VCPU_XER(r4)
 	PPC_LL	r6, VCPU_CTR(r4)
-	lwz	r7, VCPU_CR(r4)
+	PPC_LL	r7, VCPU_CR(r4)
 	PPC_LL	r8, VCPU_PC(r4)
 	PPC_LD(r9, VCPU_SHARED_MSR, r11)
 	PPC_LL	r0, VCPU_GPR(R0)(r4)
diff --git a/arch/powerpc/kvm/emulate_loadstore.c b/arch/powerpc/kvm/emulate_loadstore.c
index 75dce1ef3bc83..f91b1309a0a86 100644
--- a/arch/powerpc/kvm/emulate_loadstore.c
+++ b/arch/powerpc/kvm/emulate_loadstore.c
@@ -117,7 +117,6 @@ int kvmppc_emulate_loadstore(struct kvm_vcpu *vcpu)
 
 	emulated = EMULATE_FAIL;
 	vcpu->arch.regs.msr = vcpu->arch.shared->msr;
-	vcpu->arch.regs.ccr = vcpu->arch.cr;
 	if (analyse_instr(&op, &vcpu->arch.regs, inst) == 0) {
 		int type = op.type & INSTR_TYPE_MASK;
 		int size = GETSIZE(op.type);
-- 
2.20.1



