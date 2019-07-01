Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71444493C0
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:33:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730181AbfFQV0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:26:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:52718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730177AbfFQV0O (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:26:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8068720673;
        Mon, 17 Jun 2019 21:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806773;
        bh=sCMRiUCgnTP7u/6lQ1+Xl1Q+N82GrJPzjUXp6v3AED4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b5gbLX+qBav1qjHEP4ZRPuJhbOE6ocqxlTlfGiYSoy09i9pHiURtNmR3pw6JCJcnm
         8ZkqOAb9CvbK0MBXDlZ5V6cZwTI+VHZQQnDePABnTwfEMYxTlXxcQKH/cXJgteWtps
         DT8uj2/9FJHbu7bNEk+ILhrmLeVkGk5sRyc/Arhw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Morse <james.morse@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 52/75] KVM: arm/arm64: Move cc/it checks under hyps Makefile to avoid instrumentation
Date:   Mon, 17 Jun 2019 23:10:03 +0200
Message-Id: <20190617210754.768779305@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 623e1528d4090bd1abaf93ec46f047dee9a6fb32 ]

KVM has helpers to handle the condition codes of trapped aarch32
instructions. These are marked __hyp_text and used from HYP, but they
aren't built by the 'hyp' Makefile, which has all the runes to avoid ASAN
and KCOV instrumentation.

Move this code to a new hyp/aarch32.c to avoid a hyp-panic when starting
an aarch32 guest on a host built with the ASAN/KCOV debug options.

Fixes: 021234ef3752f ("KVM: arm64: Make kvm_condition_valid32() accessible from EL2")
Fixes: 8cebe750c4d9a ("arm64: KVM: Make kvm_skip_instr32 available to HYP")
Signed-off-by: James Morse <james.morse@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kvm/hyp/Makefile   |   1 +
 arch/arm64/kvm/hyp/Makefile |   1 +
 virt/kvm/arm/aarch32.c      | 121 --------------------------------
 virt/kvm/arm/hyp/aarch32.c  | 136 ++++++++++++++++++++++++++++++++++++
 4 files changed, 138 insertions(+), 121 deletions(-)
 create mode 100644 virt/kvm/arm/hyp/aarch32.c

diff --git a/arch/arm/kvm/hyp/Makefile b/arch/arm/kvm/hyp/Makefile
index d2b5ec9c4b92..ba88b1eca93c 100644
--- a/arch/arm/kvm/hyp/Makefile
+++ b/arch/arm/kvm/hyp/Makefile
@@ -11,6 +11,7 @@ CFLAGS_ARMV7VE		   :=$(call cc-option, -march=armv7ve)
 
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v3-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
+obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/aarch32.o
 
 obj-$(CONFIG_KVM_ARM_HOST) += tlb.o
 obj-$(CONFIG_KVM_ARM_HOST) += cp15-sr.o
diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index 2fabc2dc1966..feef06fc7c5a 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -10,6 +10,7 @@ KVM=../../../../virt/kvm
 
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/vgic-v3-sr.o
 obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/timer-sr.o
+obj-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/hyp/aarch32.o
 
 obj-$(CONFIG_KVM_ARM_HOST) += vgic-v2-cpuif-proxy.o
 obj-$(CONFIG_KVM_ARM_HOST) += sysreg-sr.o
diff --git a/virt/kvm/arm/aarch32.c b/virt/kvm/arm/aarch32.c
index 5abbe9b3c652..6880236974b8 100644
--- a/virt/kvm/arm/aarch32.c
+++ b/virt/kvm/arm/aarch32.c
@@ -25,127 +25,6 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_hyp.h>
 
-/*
- * stolen from arch/arm/kernel/opcodes.c
- *
- * condition code lookup table
- * index into the table is test code: EQ, NE, ... LT, GT, AL, NV
- *
- * bit position in short is condition code: NZCV
- */
-static const unsigned short cc_map[16] = {
-	0xF0F0,			/* EQ == Z set            */
-	0x0F0F,			/* NE                     */
-	0xCCCC,			/* CS == C set            */
-	0x3333,			/* CC                     */
-	0xFF00,			/* MI == N set            */
-	0x00FF,			/* PL                     */
-	0xAAAA,			/* VS == V set            */
-	0x5555,			/* VC                     */
-	0x0C0C,			/* HI == C set && Z clear */
-	0xF3F3,			/* LS == C clear || Z set */
-	0xAA55,			/* GE == (N==V)           */
-	0x55AA,			/* LT == (N!=V)           */
-	0x0A05,			/* GT == (!Z && (N==V))   */
-	0xF5FA,			/* LE == (Z || (N!=V))    */
-	0xFFFF,			/* AL always              */
-	0			/* NV                     */
-};
-
-/*
- * Check if a trapped instruction should have been executed or not.
- */
-bool __hyp_text kvm_condition_valid32(const struct kvm_vcpu *vcpu)
-{
-	unsigned long cpsr;
-	u32 cpsr_cond;
-	int cond;
-
-	/* Top two bits non-zero?  Unconditional. */
-	if (kvm_vcpu_get_hsr(vcpu) >> 30)
-		return true;
-
-	/* Is condition field valid? */
-	cond = kvm_vcpu_get_condition(vcpu);
-	if (cond == 0xE)
-		return true;
-
-	cpsr = *vcpu_cpsr(vcpu);
-
-	if (cond < 0) {
-		/* This can happen in Thumb mode: examine IT state. */
-		unsigned long it;
-
-		it = ((cpsr >> 8) & 0xFC) | ((cpsr >> 25) & 0x3);
-
-		/* it == 0 => unconditional. */
-		if (it == 0)
-			return true;
-
-		/* The cond for this insn works out as the top 4 bits. */
-		cond = (it >> 4);
-	}
-
-	cpsr_cond = cpsr >> 28;
-
-	if (!((cc_map[cond] >> cpsr_cond) & 1))
-		return false;
-
-	return true;
-}
-
-/**
- * adjust_itstate - adjust ITSTATE when emulating instructions in IT-block
- * @vcpu:	The VCPU pointer
- *
- * When exceptions occur while instructions are executed in Thumb IF-THEN
- * blocks, the ITSTATE field of the CPSR is not advanced (updated), so we have
- * to do this little bit of work manually. The fields map like this:
- *
- * IT[7:0] -> CPSR[26:25],CPSR[15:10]
- */
-static void __hyp_text kvm_adjust_itstate(struct kvm_vcpu *vcpu)
-{
-	unsigned long itbits, cond;
-	unsigned long cpsr = *vcpu_cpsr(vcpu);
-	bool is_arm = !(cpsr & PSR_AA32_T_BIT);
-
-	if (is_arm || !(cpsr & PSR_AA32_IT_MASK))
-		return;
-
-	cond = (cpsr & 0xe000) >> 13;
-	itbits = (cpsr & 0x1c00) >> (10 - 2);
-	itbits |= (cpsr & (0x3 << 25)) >> 25;
-
-	/* Perform ITAdvance (see page A2-52 in ARM DDI 0406C) */
-	if ((itbits & 0x7) == 0)
-		itbits = cond = 0;
-	else
-		itbits = (itbits << 1) & 0x1f;
-
-	cpsr &= ~PSR_AA32_IT_MASK;
-	cpsr |= cond << 13;
-	cpsr |= (itbits & 0x1c) << (10 - 2);
-	cpsr |= (itbits & 0x3) << 25;
-	*vcpu_cpsr(vcpu) = cpsr;
-}
-
-/**
- * kvm_skip_instr - skip a trapped instruction and proceed to the next
- * @vcpu: The vcpu pointer
- */
-void __hyp_text kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr)
-{
-	bool is_thumb;
-
-	is_thumb = !!(*vcpu_cpsr(vcpu) & PSR_AA32_T_BIT);
-	if (is_thumb && !is_wide_instr)
-		*vcpu_pc(vcpu) += 2;
-	else
-		*vcpu_pc(vcpu) += 4;
-	kvm_adjust_itstate(vcpu);
-}
-
 /*
  * Table taken from ARMv8 ARM DDI0487B-B, table G1-10.
  */
diff --git a/virt/kvm/arm/hyp/aarch32.c b/virt/kvm/arm/hyp/aarch32.c
new file mode 100644
index 000000000000..d31f267961e7
--- /dev/null
+++ b/virt/kvm/arm/hyp/aarch32.c
@@ -0,0 +1,136 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Hyp portion of the (not much of an) Emulation layer for 32bit guests.
+ *
+ * Copyright (C) 2012,2013 - ARM Ltd
+ * Author: Marc Zyngier <marc.zyngier@arm.com>
+ *
+ * based on arch/arm/kvm/emulate.c
+ * Copyright (C) 2012 - Virtual Open Systems and Columbia University
+ * Author: Christoffer Dall <c.dall@virtualopensystems.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <asm/kvm_emulate.h>
+#include <asm/kvm_hyp.h>
+
+/*
+ * stolen from arch/arm/kernel/opcodes.c
+ *
+ * condition code lookup table
+ * index into the table is test code: EQ, NE, ... LT, GT, AL, NV
+ *
+ * bit position in short is condition code: NZCV
+ */
+static const unsigned short cc_map[16] = {
+	0xF0F0,			/* EQ == Z set            */
+	0x0F0F,			/* NE                     */
+	0xCCCC,			/* CS == C set            */
+	0x3333,			/* CC                     */
+	0xFF00,			/* MI == N set            */
+	0x00FF,			/* PL                     */
+	0xAAAA,			/* VS == V set            */
+	0x5555,			/* VC                     */
+	0x0C0C,			/* HI == C set && Z clear */
+	0xF3F3,			/* LS == C clear || Z set */
+	0xAA55,			/* GE == (N==V)           */
+	0x55AA,			/* LT == (N!=V)           */
+	0x0A05,			/* GT == (!Z && (N==V))   */
+	0xF5FA,			/* LE == (Z || (N!=V))    */
+	0xFFFF,			/* AL always              */
+	0			/* NV                     */
+};
+
+/*
+ * Check if a trapped instruction should have been executed or not.
+ */
+bool __hyp_text kvm_condition_valid32(const struct kvm_vcpu *vcpu)
+{
+	unsigned long cpsr;
+	u32 cpsr_cond;
+	int cond;
+
+	/* Top two bits non-zero?  Unconditional. */
+	if (kvm_vcpu_get_hsr(vcpu) >> 30)
+		return true;
+
+	/* Is condition field valid? */
+	cond = kvm_vcpu_get_condition(vcpu);
+	if (cond == 0xE)
+		return true;
+
+	cpsr = *vcpu_cpsr(vcpu);
+
+	if (cond < 0) {
+		/* This can happen in Thumb mode: examine IT state. */
+		unsigned long it;
+
+		it = ((cpsr >> 8) & 0xFC) | ((cpsr >> 25) & 0x3);
+
+		/* it == 0 => unconditional. */
+		if (it == 0)
+			return true;
+
+		/* The cond for this insn works out as the top 4 bits. */
+		cond = (it >> 4);
+	}
+
+	cpsr_cond = cpsr >> 28;
+
+	if (!((cc_map[cond] >> cpsr_cond) & 1))
+		return false;
+
+	return true;
+}
+
+/**
+ * adjust_itstate - adjust ITSTATE when emulating instructions in IT-block
+ * @vcpu:	The VCPU pointer
+ *
+ * When exceptions occur while instructions are executed in Thumb IF-THEN
+ * blocks, the ITSTATE field of the CPSR is not advanced (updated), so we have
+ * to do this little bit of work manually. The fields map like this:
+ *
+ * IT[7:0] -> CPSR[26:25],CPSR[15:10]
+ */
+static void __hyp_text kvm_adjust_itstate(struct kvm_vcpu *vcpu)
+{
+	unsigned long itbits, cond;
+	unsigned long cpsr = *vcpu_cpsr(vcpu);
+	bool is_arm = !(cpsr & PSR_AA32_T_BIT);
+
+	if (is_arm || !(cpsr & PSR_AA32_IT_MASK))
+		return;
+
+	cond = (cpsr & 0xe000) >> 13;
+	itbits = (cpsr & 0x1c00) >> (10 - 2);
+	itbits |= (cpsr & (0x3 << 25)) >> 25;
+
+	/* Perform ITAdvance (see page A2-52 in ARM DDI 0406C) */
+	if ((itbits & 0x7) == 0)
+		itbits = cond = 0;
+	else
+		itbits = (itbits << 1) & 0x1f;
+
+	cpsr &= ~PSR_AA32_IT_MASK;
+	cpsr |= cond << 13;
+	cpsr |= (itbits & 0x1c) << (10 - 2);
+	cpsr |= (itbits & 0x3) << 25;
+	*vcpu_cpsr(vcpu) = cpsr;
+}
+
+/**
+ * kvm_skip_instr - skip a trapped instruction and proceed to the next
+ * @vcpu: The vcpu pointer
+ */
+void __hyp_text kvm_skip_instr32(struct kvm_vcpu *vcpu, bool is_wide_instr)
+{
+	bool is_thumb;
+
+	is_thumb = !!(*vcpu_cpsr(vcpu) & PSR_AA32_T_BIT);
+	if (is_thumb && !is_wide_instr)
+		*vcpu_pc(vcpu) += 2;
+	else
+		*vcpu_pc(vcpu) += 4;
+	kvm_adjust_itstate(vcpu);
+}
-- 
2.20.1



