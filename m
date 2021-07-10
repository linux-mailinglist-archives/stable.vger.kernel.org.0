Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E74583C38E3
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 01:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhGJX4k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Jul 2021 19:56:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233767AbhGJXzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 10 Jul 2021 19:55:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8181F613F5;
        Sat, 10 Jul 2021 23:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625961117;
        bh=Qov3NdALQaJngH7UvnuSSQKyNioJNZNNRlHpZDfJudE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m8VXFjcfr1W05zFZ3dPvSkHUyc/i9EiN90WKL7q5gD2Jqta9m5bAVFH3WfA8tp1E7
         iixKE9ScwEi3Qqqy6QH97/LG2Ckd6pllvdmIeECloVFib0g9NMwV3IukE74E0p46L4
         I+w9oFEsXgg6Jc7MsZesLcC3DDYBlKweMVIQFTNqQgZ/+6dtgWfIX6J9k0OxANhqyd
         QU9tKLGc6m/IqIErFwxpisLDbm9Nd2X0iDBNCMSWqGpyKDX5UmjbBG6VLYUFXHgXiD
         0PpB4QdIKAMSmY6rTcld3jaF6ZRByYZnXTTmX1vnsKaV6xTD5sH6H6ItIlzUR4BArd
         6WTFszPFmGjMQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 10/22] x86/fpu: Return proper error codes from user access functions
Date:   Sat, 10 Jul 2021 19:51:31 -0400
Message-Id: <20210710235143.3222129-10-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710235143.3222129-1-sashal@kernel.org>
References: <20210710235143.3222129-1-sashal@kernel.org>
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
index fa2c93cb42a2..b8c935033d21 100644
--- a/arch/x86/include/asm/fpu/internal.h
+++ b/arch/x86/include/asm/fpu/internal.h
@@ -103,6 +103,7 @@ static inline void fpstate_init_fxstate(struct fxregs_state *fx)
 }
 extern void fpstate_sanitize_xstate(struct fpu *fpu);
 
+/* Returns 0 or the negated trap number, which results in -EFAULT for #PF */
 #define user_insn(insn, output, input...)				\
 ({									\
 	int err;							\
@@ -110,14 +111,14 @@ extern void fpstate_sanitize_xstate(struct fpu *fpu);
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
@@ -221,16 +222,20 @@ static inline void copy_fxregs_to_kernel(struct fpu *fpu)
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

