Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4E93C3961
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232033AbhGJX7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:59:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234144AbhGJX5u (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:57:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52607613F2;
        Sat, 10 Jul 2021 23:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961171;
        bh=zOkvkDVVrsYdslozqi9IrXBmgGJDkAGaU2YsKa2eYnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ICuQThf5lMNc0cAntoDp0EvzqxiHMiBJqdmasAwUkW8DnudTIUjkGcEbUjYOqJC0B
         yZbMvymvVX8yt3u8vKmrb4lJli2l0MM4A2l7YRi3VnvewqjQWnfE1fJJmFV5IACMDv
         9kXJw91KGEiacz7LouJ1wu/aiKE1OH3PcmCN4EvPZ0DZ30HQMbS9zWzfbEvfv1qg3O
         dgs5fJ1vjsAi8TFblwCyQKHXagK7Tepj7KETvHXFpy+BiDjqGVNK01pG01vUvjemQo
         oSYQu60J03KLvxW5/M6XCbnk/K7MAV587Z3nvxhF0R/vWLCGW3wCrqyOflAP2TG46I
         qyBWjrYCt5Ozg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.9 08/16] x86/fpu: Return proper error codes from user access functions
Date:   Sat, 10 Jul 2021 19:52:32 -0400
Message-Id: <20210710235240.3222618-8-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235240.3222618-1-sashal@kernel.org>
References: <20210710235240.3222618-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit aee8c67a4faa40a8df4e79316dbfc92d123989c1 ]

When *RSTOR from user memory raises an exception, there is no way to
differentiate them. That's bad because it forces the slow path even when
the failure was not a fault. If the operation raised eg. #GP then going
through the slow path is pointless.

Use _ASM_EXTABLE_FAULT() which stores the trap number and let the exception
fixup return the negated trap number as error.

This allows to separate the fast path and let it handle faults directly and
avoid the slow path for all other exceptions.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210623121457.601480369@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/fpu/internal.h | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/fpu/internal.h b/arch/x86/include/asm/fpu/internal.h
index 21d6fa27b4a9..ebda4718eb8f 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -94,6 +94,7 @@ static inline void fpstate_init_fxstate(struct fxregs_state *fx)
 }
 extern void fpstate_sanitize_xstate(struct fpu *fpu);
 
+/* Returns 0 or the negated trap number, which results in -EFAULT for #PF */
 #define user_insn(insn, output, input...)				\
 ({									\
 	int err;							\
@@ -101,14 +102,14 @@ extern void fpstate_sanitize_xstate(struct fpu *fpu);
 	might_fault();							\
 									\
 	asm volatile(ASM_STAC "\n"					\
-		     "1:" #insn "\n\t"					\
+		     "1: " #insn "\n"					\
 		     "2: " ASM_CLAC "\n"				\
 		     ".section .fixup,\"ax\"\n"				\
-		     "3:  movl $-1,%[err]\n"				\
+		     "3:  negl %%eax\n"					\
 		     "    jmp  2b\n"					\
 		     ".previous\n"					\
-		     _ASM_EXTABLE(1b, 3b)				\
-		     : [err] "=r" (err), output				\
+		     _ASM_EXTABLE_FAULT(1b, 3b)				\
+		     : [err] "=a" (err), output				\
 		     : "0"(0), input);					\
 	err;								\
 })
@@ -227,16 +228,20 @@ static inline void copy_fxregs_to_kernel(struct fpu *fpu)
 #define XRSTOR		".byte " REX_PREFIX "0x0f,0xae,0x2f"
 #define XRSTORS		".byte " REX_PREFIX "0x0f,0xc7,0x1f"
 
+/*
+ * After this @err contains 0 on success or the negated trap number when
+ * the operation raises an exception. For faults this results in -EFAULT.
+ */
 #define XSTATE_OP(op, st, lmask, hmask, err)				\
 	asm volatile("1:" op "\n\t"					\
 		     "xor %[err], %[err]\n"				\
 		     "2:\n\t"						\
 		     ".pushsection .fixup,\"ax\"\n\t"			\
-		     "3: movl $-2,%[err]\n\t"				\
+		     "3: negl %%eax\n\t"				\
 		     "jmp 2b\n\t"					\
 		     ".popsection\n\t"					\
-		     _ASM_EXTABLE(1b, 3b)				\
-		     : [err] "=r" (err)					\
+		     _ASM_EXTABLE_FAULT(1b, 3b)				\
+		     : [err] "=a" (err)					\
 		     : "D" (st), "m" (*st), "a" (lmask), "d" (hmask)	\
 		     : "memory")
 
-- 
2.30.2

