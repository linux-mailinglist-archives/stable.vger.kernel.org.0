Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4303ED698
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239655AbhHPNW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:22:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240941AbhHPNUY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:20:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BF0D632FA;
        Mon, 16 Aug 2021 13:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119731;
        bh=RNatMPhs7s2pzyC0PKy3nfDcNEQz54JnC3nFJPeN/Mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qFNi5f6YX9XXsTHVvgsvFpvGywTIfwZZIZgZpmGBTgSc3WHNIWy43XBAS7iSrR2YJ
         MEl7b79CEOIgffBaSmFekYUJgNQjV+igxXu7Z86ZjpSiK6LfsUHA/szUMeSkagt+Nu
         S5qTyLv4bMwA7MlX1Ho0CgCr6n/Cl/NgEUmAnFj0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Radu Rendec <radu.rendec@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.13 141/151] powerpc/32: Fix critical and debug interrupts on BOOKE
Date:   Mon, 16 Aug 2021 15:02:51 +0200
Message-Id: <20210816125448.710936914@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit b5cfc9cd7b0426e94ffd9e9ed79d1b00ace7780a upstream.

32 bits BOOKE have special interrupts for debug and other
critical events.

When handling those interrupts, dedicated registers are saved
in the stack frame in addition to the standard registers, leading
to a shift of the pt_regs struct.

Since commit db297c3b07af ("powerpc/32: Don't save thread.regs on
interrupt entry"), the pt_regs struct is expected to be at the
same place all the time.

Instead of handling a special struct in addition to pt_regs, just
add those special registers to struct pt_regs.

Fixes: db297c3b07af ("powerpc/32: Don't save thread.regs on interrupt entry")
Cc: stable@vger.kernel.org
Reported-by: Radu Rendec <radu.rendec@gmail.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/028d5483b4851b01ea4334d0751e7f260419092b.1625637264.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/ptrace.h |   16 ++++++++++++++++
 arch/powerpc/kernel/asm-offsets.c |   31 ++++++++++++++-----------------
 arch/powerpc/kernel/head_booke.h  |   27 +++------------------------
 3 files changed, 33 insertions(+), 41 deletions(-)

--- a/arch/powerpc/include/asm/ptrace.h
+++ b/arch/powerpc/include/asm/ptrace.h
@@ -68,6 +68,22 @@ struct pt_regs
 		};
 		unsigned long __pad[4];	/* Maintain 16 byte interrupt stack alignment */
 	};
+#if defined(CONFIG_PPC32) && defined(CONFIG_BOOKE)
+	struct { /* Must be a multiple of 16 bytes */
+		unsigned long mas0;
+		unsigned long mas1;
+		unsigned long mas2;
+		unsigned long mas3;
+		unsigned long mas6;
+		unsigned long mas7;
+		unsigned long srr0;
+		unsigned long srr1;
+		unsigned long csrr0;
+		unsigned long csrr1;
+		unsigned long dsrr0;
+		unsigned long dsrr1;
+	};
+#endif
 };
 #endif
 
--- a/arch/powerpc/kernel/asm-offsets.c
+++ b/arch/powerpc/kernel/asm-offsets.c
@@ -348,24 +348,21 @@ int main(void)
 #endif
 
 
-#if defined(CONFIG_PPC32)
-#if defined(CONFIG_BOOKE) || defined(CONFIG_40x)
-	DEFINE(EXC_LVL_SIZE, STACK_EXC_LVL_FRAME_SIZE);
-	DEFINE(MAS0, STACK_INT_FRAME_SIZE+offsetof(struct exception_regs, mas0));
+#if defined(CONFIG_PPC32) && defined(CONFIG_BOOKE)
+	STACK_PT_REGS_OFFSET(MAS0, mas0);
 	/* we overload MMUCR for 44x on MAS0 since they are mutually exclusive */
-	DEFINE(MMUCR, STACK_INT_FRAME_SIZE+offsetof(struct exception_regs, mas0));
-	DEFINE(MAS1, STACK_INT_FRAME_SIZE+offsetof(struct exception_regs, mas1));
-	DEFINE(MAS2, STACK_INT_FRAME_SIZE+offsetof(struct exception_regs, mas2));
-	DEFINE(MAS3, STACK_INT_FRAME_SIZE+offsetof(struct exception_regs, mas3));
-	DEFINE(MAS6, STACK_INT_FRAME_SIZE+offsetof(struct exception_regs, mas6));
-	DEFINE(MAS7, STACK_INT_FRAME_SIZE+offsetof(struct exception_regs, mas7));
-	DEFINE(_SRR0, STACK_INT_FRAME_SIZE+offsetof(struct exception_regs, srr0));
-	DEFINE(_SRR1, STACK_INT_FRAME_SIZE+offsetof(struct exception_regs, srr1));
-	DEFINE(_CSRR0, STACK_INT_FRAME_SIZE+offsetof(struct exception_regs, csrr0));
-	DEFINE(_CSRR1, STACK_INT_FRAME_SIZE+offsetof(struct exception_regs, csrr1));
-	DEFINE(_DSRR0, STACK_INT_FRAME_SIZE+offsetof(struct exception_regs, dsrr0));
-	DEFINE(_DSRR1, STACK_INT_FRAME_SIZE+offsetof(struct exception_regs, dsrr1));
-#endif
+	STACK_PT_REGS_OFFSET(MMUCR, mas0);
+	STACK_PT_REGS_OFFSET(MAS1, mas1);
+	STACK_PT_REGS_OFFSET(MAS2, mas2);
+	STACK_PT_REGS_OFFSET(MAS3, mas3);
+	STACK_PT_REGS_OFFSET(MAS6, mas6);
+	STACK_PT_REGS_OFFSET(MAS7, mas7);
+	STACK_PT_REGS_OFFSET(_SRR0, srr0);
+	STACK_PT_REGS_OFFSET(_SRR1, srr1);
+	STACK_PT_REGS_OFFSET(_CSRR0, csrr0);
+	STACK_PT_REGS_OFFSET(_CSRR1, csrr1);
+	STACK_PT_REGS_OFFSET(_DSRR0, dsrr0);
+	STACK_PT_REGS_OFFSET(_DSRR1, dsrr1);
 #endif
 
 #ifndef CONFIG_PPC64
--- a/arch/powerpc/kernel/head_booke.h
+++ b/arch/powerpc/kernel/head_booke.h
@@ -185,20 +185,18 @@ ALT_FTR_SECTION_END_IFSET(CPU_FTR_EMB_HV
 /* only on e500mc */
 #define DBG_STACK_BASE		dbgirq_ctx
 
-#define EXC_LVL_FRAME_OVERHEAD	(THREAD_SIZE - INT_FRAME_SIZE - EXC_LVL_SIZE)
-
 #ifdef CONFIG_SMP
 #define BOOKE_LOAD_EXC_LEVEL_STACK(level)		\
 	mfspr	r8,SPRN_PIR;				\
 	slwi	r8,r8,2;				\
 	addis	r8,r8,level##_STACK_BASE@ha;		\
 	lwz	r8,level##_STACK_BASE@l(r8);		\
-	addi	r8,r8,EXC_LVL_FRAME_OVERHEAD;
+	addi	r8,r8,THREAD_SIZE - INT_FRAME_SIZE;
 #else
 #define BOOKE_LOAD_EXC_LEVEL_STACK(level)		\
 	lis	r8,level##_STACK_BASE@ha;		\
 	lwz	r8,level##_STACK_BASE@l(r8);		\
-	addi	r8,r8,EXC_LVL_FRAME_OVERHEAD;
+	addi	r8,r8,THREAD_SIZE - INT_FRAME_SIZE;
 #endif
 
 /*
@@ -225,7 +223,7 @@ ALT_FTR_SECTION_END_IFSET(CPU_FTR_EMB_HV
 	mtmsr	r11;							\
 	mfspr	r11,SPRN_SPRG_THREAD;	/* if from user, start at top of   */\
 	lwz	r11, TASK_STACK - THREAD(r11); /* this thread's kernel stack */\
-	addi	r11,r11,EXC_LVL_FRAME_OVERHEAD;	/* allocate stack frame    */\
+	addi	r11,r11,THREAD_SIZE - INT_FRAME_SIZE;	/* allocate stack frame    */\
 	beq	1f;							     \
 	/* COMING FROM USER MODE */					     \
 	stw	r9,_CCR(r11);		/* save CR			   */\
@@ -533,24 +531,5 @@ label:
 	bl	kernel_fp_unavailable_exception;			      \
 	b	interrupt_return
 
-#else /* __ASSEMBLY__ */
-struct exception_regs {
-	unsigned long mas0;
-	unsigned long mas1;
-	unsigned long mas2;
-	unsigned long mas3;
-	unsigned long mas6;
-	unsigned long mas7;
-	unsigned long srr0;
-	unsigned long srr1;
-	unsigned long csrr0;
-	unsigned long csrr1;
-	unsigned long dsrr0;
-	unsigned long dsrr1;
-};
-
-/* ensure this structure is always sized to a multiple of the stack alignment */
-#define STACK_EXC_LVL_FRAME_SIZE	ALIGN(sizeof (struct exception_regs), 16)
-
 #endif /* __ASSEMBLY__ */
 #endif /* __HEAD_BOOKE_H__ */


