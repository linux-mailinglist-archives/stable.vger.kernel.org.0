Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6046406240
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhIJApH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231589AbhIJAVC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:21:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C457E610E9;
        Fri, 10 Sep 2021 00:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233192;
        bh=3R/3ZwYH/RAsbuhHdFG5YdBEV1Nz+dZI5kGVVSdYAq8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EYkleiWdzC+3a7A4QhgGpMJ6BRQLHvq8ueQNyTEnNjfpusPyVOqhUzgpr6BQ6yDfS
         PX1wNTD65Z3fqiKdwrz9xkb45WIcaYFYu3U0wgeOuZELMX1cWZbbf994AP96CB+8Zi
         EYJtte6ZUfVj1hYIjIdsNyoZkGX6sMXXC2Z8ObCEbgz4sbE7IAAZmg7QggPLJAQyrC
         4fKix+QfgjORFgjyThCQwxMhnnNWvD3iCadocK5cVftID18yP25k1PmGRlBJhGRDkB
         RWpR23CkladVkODnKXGhmqAynYDS/TqNSTC6YfvTlPFGkcl8tCl35EXkbO3OTwWn0x
         pSFyGQ14guHcQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org,
        kvm-ppc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 65/88] KVM: PPC: Book3S HV Nested: Fix TM softpatch HFAC interrupt emulation
Date:   Thu,  9 Sep 2021 20:17:57 -0400
Message-Id: <20210910001820.174272-65-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910001820.174272-1-sashal@kernel.org>
References: <20210910001820.174272-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit d82b392d9b3556b63e3f9916cf057ea847e173a9 ]

Have the TM softpatch emulation code set up the HFAC interrupt and
return -1 in case an instruction was executed with HFSCR bits clear,
and have the interrupt exit handler fall through to the HFAC handler.
When the L0 is running a nested guest, this ensures the HFAC interrupt
is correctly passed up to the L1.

The "direct guest" exit handler will turn these into PROGILL program
interrupts so functionality in practice will be unchanged. But it's
possible an L1 would want to handle these in a different way.

Also rearrange the FAC interrupt emulation code to match the HFAC format
while here (mainly, adding the FSCR_INTR_CAUSE mask).

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210811160134.904987-5-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/reg.h  |  3 ++-
 arch/powerpc/kvm/book3s_hv.c    | 35 ++++++++++++++++----------
 arch/powerpc/kvm/book3s_hv_tm.c | 44 ++++++++++++++++++---------------
 3 files changed, 48 insertions(+), 34 deletions(-)

diff --git a/arch/powerpc/include/asm/reg.h b/arch/powerpc/include/asm/reg.h
index 7c81d3e563b2..1047dfe55231 100644
--- a/arch/powerpc/include/asm/reg.h
+++ b/arch/powerpc/include/asm/reg.h
@@ -414,6 +414,7 @@
 #define   FSCR_TAR	__MASK(FSCR_TAR_LG)
 #define   FSCR_EBB	__MASK(FSCR_EBB_LG)
 #define   FSCR_DSCR	__MASK(FSCR_DSCR_LG)
+#define   FSCR_INTR_CAUSE (ASM_CONST(0xFF) << 56)	/* interrupt cause */
 #define SPRN_HFSCR	0xbe	/* HV=1 Facility Status & Control Register */
 #define   HFSCR_PREFIX	__MASK(FSCR_PREFIX_LG)
 #define   HFSCR_MSGP	__MASK(FSCR_MSGP_LG)
@@ -425,7 +426,7 @@
 #define   HFSCR_DSCR	__MASK(FSCR_DSCR_LG)
 #define   HFSCR_VECVSX	__MASK(FSCR_VECVSX_LG)
 #define   HFSCR_FP	__MASK(FSCR_FP_LG)
-#define   HFSCR_INTR_CAUSE (ASM_CONST(0xFF) << 56)	/* interrupt cause */
+#define   HFSCR_INTR_CAUSE FSCR_INTR_CAUSE
 #define SPRN_TAR	0x32f	/* Target Address Register */
 #define SPRN_LPCR	0x13E	/* LPAR Control Register */
 #define   LPCR_VPM0		ASM_CONST(0x8000000000000000)
diff --git a/arch/powerpc/kvm/book3s_hv.c b/arch/powerpc/kvm/book3s_hv.c
index 14c6b8392021..0e98dae8d965 100644
--- a/arch/powerpc/kvm/book3s_hv.c
+++ b/arch/powerpc/kvm/book3s_hv.c
@@ -1452,6 +1452,21 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 			r = RESUME_GUEST;
 		}
 		break;
+
+#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
+	case BOOK3S_INTERRUPT_HV_SOFTPATCH:
+		/*
+		 * This occurs for various TM-related instructions that
+		 * we need to emulate on POWER9 DD2.2.  We have already
+		 * handled the cases where the guest was in real-suspend
+		 * mode and was transitioning to transactional state.
+		 */
+		r = kvmhv_p9_tm_emulation(vcpu);
+		if (r != -1)
+			break;
+		fallthrough; /* go to facility unavailable handler */
+#endif
+
 	/*
 	 * This occurs if the guest (kernel or userspace), does something that
 	 * is prohibited by HFSCR.
@@ -1470,18 +1485,6 @@ static int kvmppc_handle_exit_hv(struct kvm_vcpu *vcpu,
 		}
 		break;
 
-#ifdef CONFIG_PPC_TRANSACTIONAL_MEM
-	case BOOK3S_INTERRUPT_HV_SOFTPATCH:
-		/*
-		 * This occurs for various TM-related instructions that
-		 * we need to emulate on POWER9 DD2.2.  We have already
-		 * handled the cases where the guest was in real-suspend
-		 * mode and was transitioning to transactional state.
-		 */
-		r = kvmhv_p9_tm_emulation(vcpu);
-		break;
-#endif
-
 	case BOOK3S_INTERRUPT_HV_RM_HARD:
 		r = RESUME_PASSTHROUGH;
 		break;
@@ -1584,9 +1587,15 @@ static int kvmppc_handle_nested_exit(struct kvm_vcpu *vcpu)
 		 * mode and was transitioning to transactional state.
 		 */
 		r = kvmhv_p9_tm_emulation(vcpu);
-		break;
+		if (r != -1)
+			break;
+		fallthrough; /* go to facility unavailable handler */
 #endif
 
+	case BOOK3S_INTERRUPT_H_FAC_UNAVAIL:
+		r = RESUME_HOST;
+		break;
+
 	case BOOK3S_INTERRUPT_HV_RM_HARD:
 		vcpu->arch.trap = 0;
 		r = RESUME_GUEST;
diff --git a/arch/powerpc/kvm/book3s_hv_tm.c b/arch/powerpc/kvm/book3s_hv_tm.c
index e7c36f8bf205..866cadd70094 100644
--- a/arch/powerpc/kvm/book3s_hv_tm.c
+++ b/arch/powerpc/kvm/book3s_hv_tm.c
@@ -88,14 +88,15 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		}
 		/* check EBB facility is available */
 		if (!(vcpu->arch.hfscr & HFSCR_EBB)) {
-			/* generate an illegal instruction interrupt */
-			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
-			return RESUME_GUEST;
+			vcpu->arch.hfscr &= ~HFSCR_INTR_CAUSE;
+			vcpu->arch.hfscr |= (u64)FSCR_EBB_LG << 56;
+			vcpu->arch.trap = BOOK3S_INTERRUPT_H_FAC_UNAVAIL;
+			return -1; /* rerun host interrupt handler */
 		}
 		if ((msr & MSR_PR) && !(vcpu->arch.fscr & FSCR_EBB)) {
 			/* generate a facility unavailable interrupt */
-			vcpu->arch.fscr = (vcpu->arch.fscr & ~(0xffull << 56)) |
-				((u64)FSCR_EBB_LG << 56);
+			vcpu->arch.fscr &= ~FSCR_INTR_CAUSE;
+			vcpu->arch.fscr |= (u64)FSCR_EBB_LG << 56;
 			kvmppc_book3s_queue_irqprio(vcpu, BOOK3S_INTERRUPT_FAC_UNAVAIL);
 			return RESUME_GUEST;
 		}
@@ -138,14 +139,15 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		}
 		/* check for TM disabled in the HFSCR or MSR */
 		if (!(vcpu->arch.hfscr & HFSCR_TM)) {
-			/* generate an illegal instruction interrupt */
-			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
-			return RESUME_GUEST;
+			vcpu->arch.hfscr &= ~HFSCR_INTR_CAUSE;
+			vcpu->arch.hfscr |= (u64)FSCR_TM_LG << 56;
+			vcpu->arch.trap = BOOK3S_INTERRUPT_H_FAC_UNAVAIL;
+			return -1; /* rerun host interrupt handler */
 		}
 		if (!(msr & MSR_TM)) {
 			/* generate a facility unavailable interrupt */
-			vcpu->arch.fscr = (vcpu->arch.fscr & ~(0xffull << 56)) |
-				((u64)FSCR_TM_LG << 56);
+			vcpu->arch.fscr &= ~FSCR_INTR_CAUSE;
+			vcpu->arch.fscr |= (u64)FSCR_TM_LG << 56;
 			kvmppc_book3s_queue_irqprio(vcpu,
 						BOOK3S_INTERRUPT_FAC_UNAVAIL);
 			return RESUME_GUEST;
@@ -169,14 +171,15 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 	case (PPC_INST_TRECLAIM & PO_XOP_OPCODE_MASK):
 		/* check for TM disabled in the HFSCR or MSR */
 		if (!(vcpu->arch.hfscr & HFSCR_TM)) {
-			/* generate an illegal instruction interrupt */
-			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
-			return RESUME_GUEST;
+			vcpu->arch.hfscr &= ~HFSCR_INTR_CAUSE;
+			vcpu->arch.hfscr |= (u64)FSCR_TM_LG << 56;
+			vcpu->arch.trap = BOOK3S_INTERRUPT_H_FAC_UNAVAIL;
+			return -1; /* rerun host interrupt handler */
 		}
 		if (!(msr & MSR_TM)) {
 			/* generate a facility unavailable interrupt */
-			vcpu->arch.fscr = (vcpu->arch.fscr & ~(0xffull << 56)) |
-				((u64)FSCR_TM_LG << 56);
+			vcpu->arch.fscr &= ~FSCR_INTR_CAUSE;
+			vcpu->arch.fscr |= (u64)FSCR_TM_LG << 56;
 			kvmppc_book3s_queue_irqprio(vcpu,
 						BOOK3S_INTERRUPT_FAC_UNAVAIL);
 			return RESUME_GUEST;
@@ -208,14 +211,15 @@ int kvmhv_p9_tm_emulation(struct kvm_vcpu *vcpu)
 		/* XXX do we need to check for PR=0 here? */
 		/* check for TM disabled in the HFSCR or MSR */
 		if (!(vcpu->arch.hfscr & HFSCR_TM)) {
-			/* generate an illegal instruction interrupt */
-			kvmppc_core_queue_program(vcpu, SRR1_PROGILL);
-			return RESUME_GUEST;
+			vcpu->arch.hfscr &= ~HFSCR_INTR_CAUSE;
+			vcpu->arch.hfscr |= (u64)FSCR_TM_LG << 56;
+			vcpu->arch.trap = BOOK3S_INTERRUPT_H_FAC_UNAVAIL;
+			return -1; /* rerun host interrupt handler */
 		}
 		if (!(msr & MSR_TM)) {
 			/* generate a facility unavailable interrupt */
-			vcpu->arch.fscr = (vcpu->arch.fscr & ~(0xffull << 56)) |
-				((u64)FSCR_TM_LG << 56);
+			vcpu->arch.fscr &= ~FSCR_INTR_CAUSE;
+			vcpu->arch.fscr |= (u64)FSCR_TM_LG << 56;
 			kvmppc_book3s_queue_irqprio(vcpu,
 						BOOK3S_INTERRUPT_FAC_UNAVAIL);
 			return RESUME_GUEST;
-- 
2.30.2

