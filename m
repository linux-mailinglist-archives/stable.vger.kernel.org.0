Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 254E515781D
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730801AbgBJNFM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:05:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:39394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729619AbgBJMkG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:40:06 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D1632467A;
        Mon, 10 Feb 2020 12:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338406;
        bh=g8wODqSpfkEv9Y70DI6xQCmerG9xeMQZlte3xZLBM1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wXlzfYXlIT7clzhH43pE3j8oFhXAsd0wBl7PBCNsrl7h3pd51hbv3X36gGCNhbJei
         LJj89Lye/Pftyr9BvFq98StOaBh8WsKHKakU9luOJe5plKqXWcwlmVqiX932Q/AOfv
         JvtQXyb2WrHv+9T4eW1ppUw64uJt55+E6XO54iEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>
Subject: [PATCH 5.5 073/367] KVM: arm64: Correct PSTATE on exception entry
Date:   Mon, 10 Feb 2020 04:29:46 -0800
Message-Id: <20200210122430.926355733@linuxfoundation.org>
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

commit a425372e733177eb0779748956bc16c85167af48 upstream.

When KVM injects an exception into a guest, it generates the PSTATE
value from scratch, configuring PSTATE.{M[4:0],DAIF}, and setting all
other bits to zero.

This isn't correct, as the architecture specifies that some PSTATE bits
are (conditionally) cleared or set upon an exception, and others are
unchanged from the original context.

This patch adds logic to match the architectural behaviour. To make this
simple to follow/audit/extend, documentation references are provided,
and bits are configured in order of their layout in SPSR_EL2. This
layout can be seen in the diagram on ARM DDI 0487E.a page C5-429.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200108134324.46500-2-mark.rutland@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/uapi/asm/ptrace.h |    1 
 arch/arm64/kvm/inject_fault.c        |   70 ++++++++++++++++++++++++++++++++---
 2 files changed, 66 insertions(+), 5 deletions(-)

--- a/arch/arm64/include/uapi/asm/ptrace.h
+++ b/arch/arm64/include/uapi/asm/ptrace.h
@@ -49,6 +49,7 @@
 #define PSR_SSBS_BIT	0x00001000
 #define PSR_PAN_BIT	0x00400000
 #define PSR_UAO_BIT	0x00800000
+#define PSR_DIT_BIT	0x01000000
 #define PSR_V_BIT	0x10000000
 #define PSR_C_BIT	0x20000000
 #define PSR_Z_BIT	0x40000000
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -14,9 +14,6 @@
 #include <asm/kvm_emulate.h>
 #include <asm/esr.h>
 
-#define PSTATE_FAULT_BITS_64 	(PSR_MODE_EL1h | PSR_A_BIT | PSR_F_BIT | \
-				 PSR_I_BIT | PSR_D_BIT)
-
 #define CURRENT_EL_SP_EL0_VECTOR	0x0
 #define CURRENT_EL_SP_ELx_VECTOR	0x200
 #define LOWER_EL_AArch64_VECTOR		0x400
@@ -50,6 +47,69 @@ static u64 get_except_vector(struct kvm_
 	return vcpu_read_sys_reg(vcpu, VBAR_EL1) + exc_offset + type;
 }
 
+/*
+ * When an exception is taken, most PSTATE fields are left unchanged in the
+ * handler. However, some are explicitly overridden (e.g. M[4:0]). Luckily all
+ * of the inherited bits have the same position in the AArch64/AArch32 SPSR_ELx
+ * layouts, so we don't need to shuffle these for exceptions from AArch32 EL0.
+ *
+ * For the SPSR_ELx layout for AArch64, see ARM DDI 0487E.a page C5-429.
+ * For the SPSR_ELx layout for AArch32, see ARM DDI 0487E.a page C5-426.
+ *
+ * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
+ * MSB to LSB.
+ */
+static unsigned long get_except64_pstate(struct kvm_vcpu *vcpu)
+{
+	unsigned long sctlr = vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+	unsigned long old, new;
+
+	old = *vcpu_cpsr(vcpu);
+	new = 0;
+
+	new |= (old & PSR_N_BIT);
+	new |= (old & PSR_Z_BIT);
+	new |= (old & PSR_C_BIT);
+	new |= (old & PSR_V_BIT);
+
+	// TODO: TCO (if/when ARMv8.5-MemTag is exposed to guests)
+
+	new |= (old & PSR_DIT_BIT);
+
+	// PSTATE.UAO is set to zero upon any exception to AArch64
+	// See ARM DDI 0487E.a, page D5-2579.
+
+	// PSTATE.PAN is unchanged unless SCTLR_ELx.SPAN == 0b0
+	// SCTLR_ELx.SPAN is RES1 when ARMv8.1-PAN is not implemented
+	// See ARM DDI 0487E.a, page D5-2578.
+	new |= (old & PSR_PAN_BIT);
+	if (!(sctlr & SCTLR_EL1_SPAN))
+		new |= PSR_PAN_BIT;
+
+	// PSTATE.SS is set to zero upon any exception to AArch64
+	// See ARM DDI 0487E.a, page D2-2452.
+
+	// PSTATE.IL is set to zero upon any exception to AArch64
+	// See ARM DDI 0487E.a, page D1-2306.
+
+	// PSTATE.SSBS is set to SCTLR_ELx.DSSBS upon any exception to AArch64
+	// See ARM DDI 0487E.a, page D13-3258
+	if (sctlr & SCTLR_ELx_DSSBS)
+		new |= PSR_SSBS_BIT;
+
+	// PSTATE.BTYPE is set to zero upon any exception to AArch64
+	// See ARM DDI 0487E.a, pages D1-2293 to D1-2294.
+
+	new |= PSR_D_BIT;
+	new |= PSR_A_BIT;
+	new |= PSR_I_BIT;
+	new |= PSR_F_BIT;
+
+	new |= PSR_MODE_EL1h;
+
+	return new;
+}
+
 static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr)
 {
 	unsigned long cpsr = *vcpu_cpsr(vcpu);
@@ -59,7 +119,7 @@ static void inject_abt64(struct kvm_vcpu
 	vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
 	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
 
-	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
+	*vcpu_cpsr(vcpu) = get_except64_pstate(vcpu);
 	vcpu_write_spsr(vcpu, cpsr);
 
 	vcpu_write_sys_reg(vcpu, addr, FAR_EL1);
@@ -94,7 +154,7 @@ static void inject_undef64(struct kvm_vc
 	vcpu_write_elr_el1(vcpu, *vcpu_pc(vcpu));
 	*vcpu_pc(vcpu) = get_except_vector(vcpu, except_type_sync);
 
-	*vcpu_cpsr(vcpu) = PSTATE_FAULT_BITS_64;
+	*vcpu_cpsr(vcpu) = get_except64_pstate(vcpu);
 	vcpu_write_spsr(vcpu, cpsr);
 
 	/*


