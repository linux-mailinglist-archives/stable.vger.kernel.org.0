Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2456E6943
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:35:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfJ0VIu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:08:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729407AbfJ0VIt (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:08:49 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F52E2064A;
        Sun, 27 Oct 2019 21:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572210528;
        bh=TQ4WaaqVuUrSXMFiVXb79qPOMJ6+uqWsUONya4X9g3Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0vpqEYDxjT4gxT+Zzik2Ktwowh1xwSVXlRvU1qFuOBM94gYiSdJiWI9p2C3Iw0ePC
         TdRlRih6lxfBdD4Ev+KLWLb0Kej5Q+U0KCnQsSZKz6pldYW973HCw1UwoaATq9gP4T
         zDgeiSMobvJCnmS0jdTsyzeW99kwzyUZbKWiqIm8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Suzuki Poulose <suzuki.poulose@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 4.14 044/119] arm64: add PSR_AA32_* definitions
Date:   Sun, 27 Oct 2019 22:00:21 +0100
Message-Id: <20191027203317.526602639@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203259.948006506@linuxfoundation.org>
References: <20191027203259.948006506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit 25086263425641c74123f9387426c23072b299ea ]

The AArch32 CPSR/SPSR format is *almost* identical to the AArch64
SPSR_ELx format for exceptions taken from AArch32, but the two have
diverged with the addition of DIT, and we need to treat the two as
logically distinct.

This patch adds new definitions for the SPSR_ELx format for exceptions
taken from AArch32, with a consistent PSR_AA32_ prefix. The existing
COMPAT_PSR_ definitions will be used for the PSR format as seen from
AArch32.

Definitions of DIT are provided for both, and inline functions are
provided to map between the two formats. Note that for SPSR_ELx, the
(RES0) J bit has been re-allocated as the DIT bit.

Once users of the COMPAT_PSR definitions have been migrated over to the
PSR_AA32 definitions, the (majority of) the former will be removed, so
no efforts is made to avoid duplication until then.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/ptrace.h |   57 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/ptrace.h
+++ b/arch/arm64/include/asm/ptrace.h
@@ -35,7 +35,37 @@
 #define COMPAT_PTRACE_GETHBPREGS	29
 #define COMPAT_PTRACE_SETHBPREGS	30
 
-/* AArch32 CPSR bits */
+/* SPSR_ELx bits for exceptions taken from AArch32 */
+#define PSR_AA32_MODE_MASK	0x0000001f
+#define PSR_AA32_MODE_USR	0x00000010
+#define PSR_AA32_MODE_FIQ	0x00000011
+#define PSR_AA32_MODE_IRQ	0x00000012
+#define PSR_AA32_MODE_SVC	0x00000013
+#define PSR_AA32_MODE_ABT	0x00000017
+#define PSR_AA32_MODE_HYP	0x0000001a
+#define PSR_AA32_MODE_UND	0x0000001b
+#define PSR_AA32_MODE_SYS	0x0000001f
+#define PSR_AA32_T_BIT		0x00000020
+#define PSR_AA32_F_BIT		0x00000040
+#define PSR_AA32_I_BIT		0x00000080
+#define PSR_AA32_A_BIT		0x00000100
+#define PSR_AA32_E_BIT		0x00000200
+#define PSR_AA32_DIT_BIT	0x01000000
+#define PSR_AA32_Q_BIT		0x08000000
+#define PSR_AA32_V_BIT		0x10000000
+#define PSR_AA32_C_BIT		0x20000000
+#define PSR_AA32_Z_BIT		0x40000000
+#define PSR_AA32_N_BIT		0x80000000
+#define PSR_AA32_IT_MASK	0x0600fc00	/* If-Then execution state mask */
+#define PSR_AA32_GE_MASK	0x000f0000
+
+#ifdef CONFIG_CPU_BIG_ENDIAN
+#define PSR_AA32_ENDSTATE	PSR_AA32_E_BIT
+#else
+#define PSR_AA32_ENDSTATE	0
+#endif
+
+/* AArch32 CPSR bits, as seen in AArch32 */
 #define COMPAT_PSR_MODE_MASK	0x0000001f
 #define COMPAT_PSR_MODE_USR	0x00000010
 #define COMPAT_PSR_MODE_FIQ	0x00000011
@@ -50,6 +80,7 @@
 #define COMPAT_PSR_I_BIT	0x00000080
 #define COMPAT_PSR_A_BIT	0x00000100
 #define COMPAT_PSR_E_BIT	0x00000200
+#define COMPAT_PSR_DIT_BIT	0x00200000
 #define COMPAT_PSR_J_BIT	0x01000000
 #define COMPAT_PSR_Q_BIT	0x08000000
 #define COMPAT_PSR_V_BIT	0x10000000
@@ -111,6 +142,30 @@
 #define compat_sp_fiq	regs[29]
 #define compat_lr_fiq	regs[30]
 
+static inline unsigned long compat_psr_to_pstate(const unsigned long psr)
+{
+	unsigned long pstate;
+
+	pstate = psr & ~COMPAT_PSR_DIT_BIT;
+
+	if (psr & COMPAT_PSR_DIT_BIT)
+		pstate |= PSR_AA32_DIT_BIT;
+
+	return pstate;
+}
+
+static inline unsigned long pstate_to_compat_psr(const unsigned long pstate)
+{
+	unsigned long psr;
+
+	psr = pstate & ~PSR_AA32_DIT_BIT;
+
+	if (pstate & PSR_AA32_DIT_BIT)
+		psr |= COMPAT_PSR_DIT_BIT;
+
+	return psr;
+}
+
 /*
  * This struct defines the way the registers are stored on the stack during an
  * exception. Note that sizeof(struct pt_regs) has to be a multiple of 16 (for


