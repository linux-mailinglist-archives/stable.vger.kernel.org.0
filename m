Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 811CE157810
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729647AbgBJMkL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:40:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:39506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729642AbgBJMkK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:10 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B34F20873;
        Mon, 10 Feb 2020 12:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338409;
        bh=dOMzGPVsHWo3tdWG/fI+eQttGTRarNmGKo+q5kLqy2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KPtSwIxeNAktYSbll60WGIPCLIRqo0TCuGqYPj1NZLKeQADL4j02ftOBud1XnLrM
         +2nTnaU/M2lOYEPRiLR+rAy/qUCqTBj7zUeCtgHKB6L4CWOfRibz6V9zsqkjvZo1nR
         DC8XXjpxMUGpihh4XNcbUdv3/e2NELFoNYneIR8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 5.5 075/367] KVM: arm/arm64: Correct AArch32 SPSR on exception entry
Date:   Mon, 10 Feb 2020 04:29:48 -0800
Message-Id: <20200210122431.132694930@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 1cfbb484de158e378e8971ac40f3082e53ecca55 upstream.

Confusingly, there are three SPSR layouts that a kernel may need to deal
with:

(1) An AArch64 SPSR_ELx view of an AArch64 pstate
(2) An AArch64 SPSR_ELx view of an AArch32 pstate
(3) An AArch32 SPSR_* view of an AArch32 pstate

When the KVM AArch32 support code deals with SPSR_{EL2,HYP}, it's either
dealing with #2 or #3 consistently. On arm64 the PSR_AA32_* definitions
match the AArch64 SPSR_ELx view, and on arm the PSR_AA32_* definitions
match the AArch32 SPSR_* view.

However, when we inject an exception into an AArch32 guest, we have to
synthesize the AArch32 SPSR_* that the guest will see. Thus, an AArch64
host needs to synthesize layout #3 from layout #2.

This patch adds a new host_spsr_to_spsr32() helper for this, and makes
use of it in the KVM AArch32 support code. For arm64 we need to shuffle
the DIT bit around, and remove the SS bit, while for arm we can use the
value as-is.

I've open-coded the bit manipulation for now to avoid having to rework
the existing PSR_* definitions into PSR64_AA32_* and PSR32_AA32_*
definitions. I hope to perform a more thorough refactoring in future so
that we can handle pstate view manipulation more consistently across the
kernel tree.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200108134324.46500-4-mark.rutland@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/kvm_emulate.h   |    5 +++++
 arch/arm64/include/asm/kvm_emulate.h |   32 ++++++++++++++++++++++++++++++++
 virt/kvm/arm/aarch32.c               |    6 +++---
 3 files changed, 40 insertions(+), 3 deletions(-)

--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -53,6 +53,11 @@ static inline void vcpu_write_spsr(struc
 	*__vcpu_spsr(vcpu) = v;
 }
 
+static inline unsigned long host_spsr_to_spsr32(unsigned long spsr)
+{
+	return spsr;
+}
+
 static inline unsigned long vcpu_get_reg(struct kvm_vcpu *vcpu,
 					 u8 reg_num)
 {
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -219,6 +219,38 @@ static inline void vcpu_write_spsr(struc
 		vcpu_gp_regs(vcpu)->spsr[KVM_SPSR_EL1] = v;
 }
 
+/*
+ * The layout of SPSR for an AArch32 state is different when observed from an
+ * AArch64 SPSR_ELx or an AArch32 SPSR_*. This function generates the AArch32
+ * view given an AArch64 view.
+ *
+ * In ARM DDI 0487E.a see:
+ *
+ * - The AArch64 view (SPSR_EL2) in section C5.2.18, page C5-426
+ * - The AArch32 view (SPSR_abt) in section G8.2.126, page G8-6256
+ * - The AArch32 view (SPSR_und) in section G8.2.132, page G8-6280
+ *
+ * Which show the following differences:
+ *
+ * | Bit | AA64 | AA32 | Notes                       |
+ * +-----+------+------+-----------------------------|
+ * | 24  | DIT  | J    | J is RES0 in ARMv8          |
+ * | 21  | SS   | DIT  | SS doesn't exist in AArch32 |
+ *
+ * ... and all other bits are (currently) common.
+ */
+static inline unsigned long host_spsr_to_spsr32(unsigned long spsr)
+{
+	const unsigned long overlap = BIT(24) | BIT(21);
+	unsigned long dit = !!(spsr & PSR_AA32_DIT_BIT);
+
+	spsr &= ~overlap;
+
+	spsr |= dit << 21;
+
+	return spsr;
+}
+
 static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
 {
 	u32 mode;
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -129,15 +129,15 @@ static unsigned long get_except32_cpsr(s
 
 static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 {
-	unsigned long new_spsr_value = *vcpu_cpsr(vcpu);
-	bool is_thumb = (new_spsr_value & PSR_AA32_T_BIT);
+	unsigned long spsr = *vcpu_cpsr(vcpu);
+	bool is_thumb = (spsr & PSR_AA32_T_BIT);
 	u32 return_offset = return_offsets[vect_offset >> 2][is_thumb];
 	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
 
 	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
 
 	/* Note: These now point to the banked copies */
-	vcpu_write_spsr(vcpu, new_spsr_value);
+	vcpu_write_spsr(vcpu, host_spsr_to_spsr32(spsr));
 	*vcpu_reg32(vcpu, 14) = *vcpu_pc(vcpu) + return_offset;
 
 	/* Branch to exception vector */


