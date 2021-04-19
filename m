Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98476363F95
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 12:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238174AbhDSK3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 06:29:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:51004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238651AbhDSK3a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 06:29:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E64A611CE;
        Mon, 19 Apr 2021 10:29:00 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH stable 5.10.x] arm64: mte: Ensure TIF_MTE_ASYNC_FAULT is set atomically
Date:   Mon, 19 Apr 2021 11:28:49 +0100
Message-Id: <20210419102849.2526-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 2decad92f4731fac9755a083fcfefa66edb7d67d upstream.

The entry from EL0 code checks the TFSRE0_EL1 register for any
asynchronous tag check faults in user space and sets the
TIF_MTE_ASYNC_FAULT flag. This is not done atomically, potentially
racing with another CPU calling set_tsk_thread_flag().

Replace the non-atomic ORR+STR with an STSET instruction. While STSET
requires ARMv8.1 and an assembler that understands LSE atomics, the MTE
feature is part of ARMv8.5 and already requires an updated assembler.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Fixes: 637ec831ea4f ("arm64: mte: Handle synchronous and asynchronous tag check faults")
Cc: <stable@vger.kernel.org> # 5.10.x
Reported-by: Will Deacon <will@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20210409173710.18582-1-catalin.marinas@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/Kconfig        |  6 +++++-
 arch/arm64/kernel/entry.S | 10 ++++++----
 2 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c1be64228327..5e5cf3af6351 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1390,10 +1390,13 @@ config ARM64_PAN
 	 The feature is detected at runtime, and will remain as a 'nop'
 	 instruction if the cpu does not implement the feature.
 
+config AS_HAS_LSE_ATOMICS
+	def_bool $(as-instr,.arch_extension lse)
+
 config ARM64_LSE_ATOMICS
 	bool
 	default ARM64_USE_LSE_ATOMICS
-	depends on $(as-instr,.arch_extension lse)
+	depends on AS_HAS_LSE_ATOMICS
 
 config ARM64_USE_LSE_ATOMICS
 	bool "Atomic instructions"
@@ -1667,6 +1670,7 @@ config ARM64_MTE
 	bool "Memory Tagging Extension support"
 	default y
 	depends on ARM64_AS_HAS_MTE && ARM64_TAGGED_ADDR_ABI
+	depends on AS_HAS_LSE_ATOMICS
 	select ARCH_USES_HIGH_VMA_FLAGS
 	help
 	  Memory Tagging (part of the ARMv8.5 Extensions) provides
diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index d72c818b019c..2da82c139e1c 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -148,16 +148,18 @@ alternative_cb_end
 	.endm
 
 	/* Check for MTE asynchronous tag check faults */
-	.macro check_mte_async_tcf, flgs, tmp
+	.macro check_mte_async_tcf, tmp, ti_flags
 #ifdef CONFIG_ARM64_MTE
+	.arch_extension lse
 alternative_if_not ARM64_MTE
 	b	1f
 alternative_else_nop_endif
 	mrs_s	\tmp, SYS_TFSRE0_EL1
 	tbz	\tmp, #SYS_TFSR_EL1_TF0_SHIFT, 1f
 	/* Asynchronous TCF occurred for TTBR0 access, set the TI flag */
-	orr	\flgs, \flgs, #_TIF_MTE_ASYNC_FAULT
-	str	\flgs, [tsk, #TSK_TI_FLAGS]
+	mov	\tmp, #_TIF_MTE_ASYNC_FAULT
+	add	\ti_flags, tsk, #TSK_TI_FLAGS
+	stset	\tmp, [\ti_flags]
 	msr_s	SYS_TFSRE0_EL1, xzr
 1:
 #endif
@@ -207,7 +209,7 @@ alternative_else_nop_endif
 	disable_step_tsk x19, x20
 
 	/* Check for asynchronous tag check faults in user space */
-	check_mte_async_tcf x19, x22
+	check_mte_async_tcf x22, x23
 	apply_ssbd 1, x22, x23
 
 	ptrauth_keys_install_kernel tsk, x20, x22, x23
