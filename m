Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A311157AA0
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:24:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731167AbgBJNYF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:24:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:58096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728639AbgBJMhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:37:08 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 26B7124684;
        Mon, 10 Feb 2020 12:37:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338227;
        bh=7fH1eTraVzIwMXcsP3fm7XwV1Wn9S0RbHBBoo5q3XV8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0tgMSwfi3VfVd/f65nf8VNDcZt/1hccvAFCb+L/lsY4qpVCpv1izlR9VwADKmJN2m
         aw9FntncNu6MX60/dEm2n4nnl4EgheQci3Qbbh9ZetY6DrS99HGS9psYCplEL2uWqU
         eKmrn406E7jUtv2ofhGXsn+ctPBmCOch+8xOrycQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 5.4 067/309] KVM: arm/arm64: Correct CPSR on exception entry
Date:   Mon, 10 Feb 2020 04:30:23 -0800
Message-Id: <20200210122412.363438138@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122406.106356946@linuxfoundation.org>
References: <20200210122406.106356946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

commit 3c2483f15499b877ccb53250d88addb8c91da147 upstream.

When KVM injects an exception into a guest, it generates the CPSR value
from scratch, configuring CPSR.{M,A,I,T,E}, and setting all other
bits to zero.

This isn't correct, as the architecture specifies that some CPSR bits
are (conditionally) cleared or set upon an exception, and others are
unchanged from the original context.

This patch adds logic to match the architectural behaviour. To make this
simple to follow/audit/extend, documentation references are provided,
and bits are configured in order of their layout in SPSR_EL2. This
layout can be seen in the diagram on ARM DDI 0487E.a page C5-426.

Note that this code is used by both arm and arm64, and is intended to
fuction with the SPSR_EL2 and SPSR_HYP layouts.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200108134324.46500-3-mark.rutland@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/include/asm/kvm_emulate.h |   12 ++++
 arch/arm64/include/asm/ptrace.h    |    1 
 virt/kvm/arm/aarch32.c             |  111 +++++++++++++++++++++++++++++++++----
 3 files changed, 114 insertions(+), 10 deletions(-)

--- a/arch/arm/include/asm/kvm_emulate.h
+++ b/arch/arm/include/asm/kvm_emulate.h
@@ -14,13 +14,25 @@
 #include <asm/cputype.h>
 
 /* arm64 compatibility macros */
+#define PSR_AA32_MODE_FIQ	FIQ_MODE
+#define PSR_AA32_MODE_SVC	SVC_MODE
 #define PSR_AA32_MODE_ABT	ABT_MODE
 #define PSR_AA32_MODE_UND	UND_MODE
 #define PSR_AA32_T_BIT		PSR_T_BIT
+#define PSR_AA32_F_BIT		PSR_F_BIT
 #define PSR_AA32_I_BIT		PSR_I_BIT
 #define PSR_AA32_A_BIT		PSR_A_BIT
 #define PSR_AA32_E_BIT		PSR_E_BIT
 #define PSR_AA32_IT_MASK	PSR_IT_MASK
+#define PSR_AA32_GE_MASK	0x000f0000
+#define PSR_AA32_DIT_BIT	0x00200000
+#define PSR_AA32_PAN_BIT	0x00400000
+#define PSR_AA32_SSBS_BIT	0x00800000
+#define PSR_AA32_Q_BIT		PSR_Q_BIT
+#define PSR_AA32_V_BIT		PSR_V_BIT
+#define PSR_AA32_C_BIT		PSR_C_BIT
+#define PSR_AA32_Z_BIT		PSR_Z_BIT
+#define PSR_AA32_N_BIT		PSR_N_BIT
 
 unsigned long *vcpu_reg(struct kvm_vcpu *vcpu, u8 reg_num);
 
--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -62,6 +62,7 @@
 #define PSR_AA32_I_BIT		0x00000080
 #define PSR_AA32_A_BIT		0x00000100
 #define PSR_AA32_E_BIT		0x00000200
+#define PSR_AA32_PAN_BIT	0x00400000
 #define PSR_AA32_SSBS_BIT	0x00800000
 #define PSR_AA32_DIT_BIT	0x01000000
 #define PSR_AA32_Q_BIT		0x08000000
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -10,6 +10,7 @@
  * Author: Christoffer Dall <c.dall@virtualopensystems.com>
  */
 
+#include <linux/bits.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
@@ -28,22 +29,112 @@ static const u8 return_offsets[8][2] = {
 	[7] = { 4, 4 },		/* FIQ, unused */
 };
 
+/*
+ * When an exception is taken, most CPSR fields are left unchanged in the
+ * handler. However, some are explicitly overridden (e.g. M[4:0]).
+ *
+ * The SPSR/SPSR_ELx layouts differ, and the below is intended to work with
+ * either format. Note: SPSR.J bit doesn't exist in SPSR_ELx, but this bit was
+ * obsoleted by the ARMv7 virtualization extensions and is RES0.
+ *
+ * For the SPSR layout seen from AArch32, see:
+ * - ARM DDI 0406C.d, page B1-1148
+ * - ARM DDI 0487E.a, page G8-6264
+ *
+ * For the SPSR_ELx layout for AArch32 seen from AArch64, see:
+ * - ARM DDI 0487E.a, page C5-426
+ *
+ * Here we manipulate the fields in order of the AArch32 SPSR_ELx layout, from
+ * MSB to LSB.
+ */
+static unsigned long get_except32_cpsr(struct kvm_vcpu *vcpu, u32 mode)
+{
+	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
+	unsigned long old, new;
+
+	old = *vcpu_cpsr(vcpu);
+	new = 0;
+
+	new |= (old & PSR_AA32_N_BIT);
+	new |= (old & PSR_AA32_Z_BIT);
+	new |= (old & PSR_AA32_C_BIT);
+	new |= (old & PSR_AA32_V_BIT);
+	new |= (old & PSR_AA32_Q_BIT);
+
+	// CPSR.IT[7:0] are set to zero upon any exception
+	// See ARM DDI 0487E.a, section G1.12.3
+	// See ARM DDI 0406C.d, section B1.8.3
+
+	new |= (old & PSR_AA32_DIT_BIT);
+
+	// CPSR.SSBS is set to SCTLR.DSSBS upon any exception
+	// See ARM DDI 0487E.a, page G8-6244
+	if (sctlr & BIT(31))
+		new |= PSR_AA32_SSBS_BIT;
+
+	// CPSR.PAN is unchanged unless SCTLR.SPAN == 0b0
+	// SCTLR.SPAN is RES1 when ARMv8.1-PAN is not implemented
+	// See ARM DDI 0487E.a, page G8-6246
+	new |= (old & PSR_AA32_PAN_BIT);
+	if (!(sctlr & BIT(23)))
+		new |= PSR_AA32_PAN_BIT;
+
+	// SS does not exist in AArch32, so ignore
+
+	// CPSR.IL is set to zero upon any exception
+	// See ARM DDI 0487E.a, page G1-5527
+
+	new |= (old & PSR_AA32_GE_MASK);
+
+	// CPSR.IT[7:0] are set to zero upon any exception
+	// See prior comment above
+
+	// CPSR.E is set to SCTLR.EE upon any exception
+	// See ARM DDI 0487E.a, page G8-6245
+	// See ARM DDI 0406C.d, page B4-1701
+	if (sctlr & BIT(25))
+		new |= PSR_AA32_E_BIT;
+
+	// CPSR.A is unchanged upon an exception to Undefined, Supervisor
+	// CPSR.A is set upon an exception to other modes
+	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
+	// See ARM DDI 0406C.d, page B1-1182
+	new |= (old & PSR_AA32_A_BIT);
+	if (mode != PSR_AA32_MODE_UND && mode != PSR_AA32_MODE_SVC)
+		new |= PSR_AA32_A_BIT;
+
+	// CPSR.I is set upon any exception
+	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
+	// See ARM DDI 0406C.d, page B1-1182
+	new |= PSR_AA32_I_BIT;
+
+	// CPSR.F is set upon an exception to FIQ
+	// CPSR.F is unchanged upon an exception to other modes
+	// See ARM DDI 0487E.a, pages G1-5515 to G1-5516
+	// See ARM DDI 0406C.d, page B1-1182
+	new |= (old & PSR_AA32_F_BIT);
+	if (mode == PSR_AA32_MODE_FIQ)
+		new |= PSR_AA32_F_BIT;
+
+	// CPSR.T is set to SCTLR.TE upon any exception
+	// See ARM DDI 0487E.a, page G8-5514
+	// See ARM DDI 0406C.d, page B1-1181
+	if (sctlr & BIT(30))
+		new |= PSR_AA32_T_BIT;
+
+	new |= mode;
+
+	return new;
+}
+
 static void prepare_fault32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 {
-	unsigned long cpsr;
 	unsigned long new_spsr_value = *vcpu_cpsr(vcpu);
 	bool is_thumb = (new_spsr_value & PSR_AA32_T_BIT);
 	u32 return_offset = return_offsets[vect_offset >> 2][is_thumb];
 	u32 sctlr = vcpu_cp15(vcpu, c1_SCTLR);
 
-	cpsr = mode | PSR_AA32_I_BIT;
-
-	if (sctlr & (1 << 30))
-		cpsr |= PSR_AA32_T_BIT;
-	if (sctlr & (1 << 25))
-		cpsr |= PSR_AA32_E_BIT;
-
-	*vcpu_cpsr(vcpu) = cpsr;
+	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
 
 	/* Note: These now point to the banked copies */
 	vcpu_write_spsr(vcpu, new_spsr_value);
@@ -84,7 +175,7 @@ static void inject_abt32(struct kvm_vcpu
 		fsr = &vcpu_cp15(vcpu, c5_DFSR);
 	}
 
-	prepare_fault32(vcpu, PSR_AA32_MODE_ABT | PSR_AA32_A_BIT, vect_offset);
+	prepare_fault32(vcpu, PSR_AA32_MODE_ABT, vect_offset);
 
 	*far = addr;
 


