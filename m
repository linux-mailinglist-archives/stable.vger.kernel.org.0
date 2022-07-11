Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C2D56FD07
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbiGKJuG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbiGKJtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:49:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D373C248FA;
        Mon, 11 Jul 2022 02:24:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BB28B80E7E;
        Mon, 11 Jul 2022 09:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84599C34115;
        Mon, 11 Jul 2022 09:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531443;
        bh=o7GX/JBWNVpVdHKDfQXCW02YKTtRL9r0qkWI7tB9csQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVtZ85MkkosGEhVXWXxY6oj3Obj0pYMzZsymIyP73lgQs4Y3WZeMA69U/bM/zkrf7
         +lXaxcwU5+KOBL/rLJ7NkvyxuVuJj9loX/8FecqKyV3ksUOAGda5N20udSBaKBINXk
         C+KTP9m4++loqvLAMzyADlAEqw8J4ep7694E69YM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
        Segher Boessenkool <segher@kernel.crashing.org>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 107/230] powerpc: flexible GPR range save/restore macros
Date:   Mon, 11 Jul 2022 11:06:03 +0200
Message-Id: <20220711090607.103010388@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

[ Upstream commit aebd1fb45c622e9a2b06fb70665d084d3a8d6c78 ]

Introduce macros that operate on a (start, end) range of GPRs, which
reduces lines of code and need to do mental arithmetic while reading the
code.

Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Reviewed-by: Segher Boessenkool <segher@kernel.crashing.org>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211022061322.2671178-1-npiggin@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/crt0.S                      | 31 +++++++------
 arch/powerpc/crypto/md5-asm.S                 | 10 ++---
 arch/powerpc/crypto/sha1-powerpc-asm.S        |  6 +--
 arch/powerpc/include/asm/ppc_asm.h            | 43 ++++++++++++-------
 arch/powerpc/kernel/entry_32.S                | 23 ++++------
 arch/powerpc/kernel/exceptions-64e.S          | 14 ++----
 arch/powerpc/kernel/exceptions-64s.S          |  6 +--
 arch/powerpc/kernel/head_32.h                 |  3 +-
 arch/powerpc/kernel/head_booke.h              |  3 +-
 arch/powerpc/kernel/interrupt_64.S            | 34 ++++++---------
 arch/powerpc/kernel/optprobes_head.S          |  4 +-
 arch/powerpc/kernel/tm.S                      | 15 ++-----
 .../powerpc/kernel/trace/ftrace_64_mprofile.S | 15 +++----
 arch/powerpc/kvm/book3s_hv_rmhandlers.S       |  5 +--
 .../lib/test_emulate_step_exec_instr.S        |  8 ++--
 15 files changed, 94 insertions(+), 126 deletions(-)

diff --git a/arch/powerpc/boot/crt0.S b/arch/powerpc/boot/crt0.S
index 1d83966f5ef6..e8f10a599659 100644
--- a/arch/powerpc/boot/crt0.S
+++ b/arch/powerpc/boot/crt0.S
@@ -226,16 +226,19 @@ p_base:	mflr	r10		/* r10 now points to runtime addr of p_base */
 #ifdef __powerpc64__
 
 #define PROM_FRAME_SIZE 512
-#define SAVE_GPR(n, base)       std     n,8*(n)(base)
-#define REST_GPR(n, base)       ld      n,8*(n)(base)
-#define SAVE_2GPRS(n, base)     SAVE_GPR(n, base); SAVE_GPR(n+1, base)
-#define SAVE_4GPRS(n, base)     SAVE_2GPRS(n, base); SAVE_2GPRS(n+2, base)
-#define SAVE_8GPRS(n, base)     SAVE_4GPRS(n, base); SAVE_4GPRS(n+4, base)
-#define SAVE_10GPRS(n, base)    SAVE_8GPRS(n, base); SAVE_2GPRS(n+8, base)
-#define REST_2GPRS(n, base)     REST_GPR(n, base); REST_GPR(n+1, base)
-#define REST_4GPRS(n, base)     REST_2GPRS(n, base); REST_2GPRS(n+2, base)
-#define REST_8GPRS(n, base)     REST_4GPRS(n, base); REST_4GPRS(n+4, base)
-#define REST_10GPRS(n, base)    REST_8GPRS(n, base); REST_2GPRS(n+8, base)
+
+.macro OP_REGS op, width, start, end, base, offset
+	.Lreg=\start
+	.rept (\end - \start + 1)
+	\op	.Lreg,\offset+\width*.Lreg(\base)
+	.Lreg=.Lreg+1
+	.endr
+.endm
+
+#define SAVE_GPRS(start, end, base)	OP_REGS std, 8, start, end, base, 0
+#define REST_GPRS(start, end, base)	OP_REGS ld, 8, start, end, base, 0
+#define SAVE_GPR(n, base)		SAVE_GPRS(n, n, base)
+#define REST_GPR(n, base)		REST_GPRS(n, n, base)
 
 /* prom handles the jump into and return from firmware.  The prom args pointer
    is loaded in r3. */
@@ -246,9 +249,7 @@ prom:
 	stdu	r1,-PROM_FRAME_SIZE(r1) /* Save SP and create stack space */
 
 	SAVE_GPR(2, r1)
-	SAVE_GPR(13, r1)
-	SAVE_8GPRS(14, r1)
-	SAVE_10GPRS(22, r1)
+	SAVE_GPRS(13, 31, r1)
 	mfcr    r10
 	std     r10,8*32(r1)
 	mfmsr   r10
@@ -283,9 +284,7 @@ prom:
 
 	/* Restore other registers */
 	REST_GPR(2, r1)
-	REST_GPR(13, r1)
-	REST_8GPRS(14, r1)
-	REST_10GPRS(22, r1)
+	REST_GPRS(13, 31, r1)
 	ld      r10,8*32(r1)
 	mtcr	r10
 
diff --git a/arch/powerpc/crypto/md5-asm.S b/arch/powerpc/crypto/md5-asm.S
index 948d100a2934..fa6bc440cf4a 100644
--- a/arch/powerpc/crypto/md5-asm.S
+++ b/arch/powerpc/crypto/md5-asm.S
@@ -38,15 +38,11 @@
 
 #define INITIALIZE \
 	PPC_STLU r1,-INT_FRAME_SIZE(r1); \
-	SAVE_8GPRS(14, r1);		/* push registers onto stack	*/ \
-	SAVE_4GPRS(22, r1);						   \
-	SAVE_GPR(26, r1)
+	SAVE_GPRS(14, 26, r1)		/* push registers onto stack	*/
 
 #define FINALIZE \
-	REST_8GPRS(14, r1);		/* pop registers from stack	*/ \
-	REST_4GPRS(22, r1);						   \
-	REST_GPR(26, r1);						   \
-	addi	r1,r1,INT_FRAME_SIZE;
+	REST_GPRS(14, 26, r1);		/* pop registers from stack	*/ \
+	addi	r1,r1,INT_FRAME_SIZE
 
 #ifdef __BIG_ENDIAN__
 #define LOAD_DATA(reg, off) \
diff --git a/arch/powerpc/crypto/sha1-powerpc-asm.S b/arch/powerpc/crypto/sha1-powerpc-asm.S
index 23e248beff71..f0d5ed557ab1 100644
--- a/arch/powerpc/crypto/sha1-powerpc-asm.S
+++ b/arch/powerpc/crypto/sha1-powerpc-asm.S
@@ -125,8 +125,7 @@
 
 _GLOBAL(powerpc_sha_transform)
 	PPC_STLU r1,-INT_FRAME_SIZE(r1)
-	SAVE_8GPRS(14, r1)
-	SAVE_10GPRS(22, r1)
+	SAVE_GPRS(14, 31, r1)
 
 	/* Load up A - E */
 	lwz	RA(0),0(r3)	/* A */
@@ -184,7 +183,6 @@ _GLOBAL(powerpc_sha_transform)
 	stw	RD(0),12(r3)
 	stw	RE(0),16(r3)
 
-	REST_8GPRS(14, r1)
-	REST_10GPRS(22, r1)
+	REST_GPRS(14, 31, r1)
 	addi	r1,r1,INT_FRAME_SIZE
 	blr
diff --git a/arch/powerpc/include/asm/ppc_asm.h b/arch/powerpc/include/asm/ppc_asm.h
index 7be24048b8d1..f21e6bde17a1 100644
--- a/arch/powerpc/include/asm/ppc_asm.h
+++ b/arch/powerpc/include/asm/ppc_asm.h
@@ -16,30 +16,41 @@
 
 #define SZL			(BITS_PER_LONG/8)
 
+/*
+ * This expands to a sequence of operations with reg incrementing from
+ * start to end inclusive, of this form:
+ *
+ *   op  reg, (offset + (width * reg))(base)
+ *
+ * Note that offset is not the offset of the first operation unless start
+ * is zero (or width is zero).
+ */
+.macro OP_REGS op, width, start, end, base, offset
+	.Lreg=\start
+	.rept (\end - \start + 1)
+	\op	.Lreg, \offset + \width * .Lreg(\base)
+	.Lreg=.Lreg+1
+	.endr
+.endm
+
 /*
  * Macros for storing registers into and loading registers from
  * exception frames.
  */
 #ifdef __powerpc64__
-#define SAVE_GPR(n, base)	std	n,GPR0+8*(n)(base)
-#define REST_GPR(n, base)	ld	n,GPR0+8*(n)(base)
-#define SAVE_NVGPRS(base)	SAVE_8GPRS(14, base); SAVE_10GPRS(22, base)
-#define REST_NVGPRS(base)	REST_8GPRS(14, base); REST_10GPRS(22, base)
+#define SAVE_GPRS(start, end, base)	OP_REGS std, 8, start, end, base, GPR0
+#define REST_GPRS(start, end, base)	OP_REGS ld, 8, start, end, base, GPR0
+#define SAVE_NVGPRS(base)		SAVE_GPRS(14, 31, base)
+#define REST_NVGPRS(base)		REST_GPRS(14, 31, base)
 #else
-#define SAVE_GPR(n, base)	stw	n,GPR0+4*(n)(base)
-#define REST_GPR(n, base)	lwz	n,GPR0+4*(n)(base)
-#define SAVE_NVGPRS(base)	SAVE_GPR(13, base); SAVE_8GPRS(14, base); SAVE_10GPRS(22, base)
-#define REST_NVGPRS(base)	REST_GPR(13, base); REST_8GPRS(14, base); REST_10GPRS(22, base)
+#define SAVE_GPRS(start, end, base)	OP_REGS stw, 4, start, end, base, GPR0
+#define REST_GPRS(start, end, base)	OP_REGS lwz, 4, start, end, base, GPR0
+#define SAVE_NVGPRS(base)		SAVE_GPRS(13, 31, base)
+#define REST_NVGPRS(base)		REST_GPRS(13, 31, base)
 #endif
 
-#define SAVE_2GPRS(n, base)	SAVE_GPR(n, base); SAVE_GPR(n+1, base)
-#define SAVE_4GPRS(n, base)	SAVE_2GPRS(n, base); SAVE_2GPRS(n+2, base)
-#define SAVE_8GPRS(n, base)	SAVE_4GPRS(n, base); SAVE_4GPRS(n+4, base)
-#define SAVE_10GPRS(n, base)	SAVE_8GPRS(n, base); SAVE_2GPRS(n+8, base)
-#define REST_2GPRS(n, base)	REST_GPR(n, base); REST_GPR(n+1, base)
-#define REST_4GPRS(n, base)	REST_2GPRS(n, base); REST_2GPRS(n+2, base)
-#define REST_8GPRS(n, base)	REST_4GPRS(n, base); REST_4GPRS(n+4, base)
-#define REST_10GPRS(n, base)	REST_8GPRS(n, base); REST_2GPRS(n+8, base)
+#define SAVE_GPR(n, base)		SAVE_GPRS(n, n, base)
+#define REST_GPR(n, base)		REST_GPRS(n, n, base)
 
 #define SAVE_FPR(n, base)	stfd	n,8*TS_FPRWIDTH*(n)(base)
 #define SAVE_2FPRS(n, base)	SAVE_FPR(n, base); SAVE_FPR(n+1, base)
diff --git a/arch/powerpc/kernel/entry_32.S b/arch/powerpc/kernel/entry_32.S
index 61fdd53cdd9a..c62dd9815965 100644
--- a/arch/powerpc/kernel/entry_32.S
+++ b/arch/powerpc/kernel/entry_32.S
@@ -90,8 +90,7 @@ transfer_to_syscall:
 	stw	r12,8(r1)
 	stw	r2,_TRAP(r1)
 	SAVE_GPR(0, r1)
-	SAVE_4GPRS(3, r1)
-	SAVE_2GPRS(7, r1)
+	SAVE_GPRS(3, 8, r1)
 	addi	r2,r10,-THREAD
 	SAVE_NVGPRS(r1)
 
@@ -139,7 +138,7 @@ syscall_exit_finish:
 	mtxer	r5
 	lwz	r0,GPR0(r1)
 	lwz	r3,GPR3(r1)
-	REST_8GPRS(4,r1)
+	REST_GPRS(4, 11, r1)
 	lwz	r12,GPR12(r1)
 	b	1b
 
@@ -232,9 +231,9 @@ fast_exception_return:
 	beq	3f			/* if not, we've got problems */
 #endif
 
-2:	REST_4GPRS(3, r11)
+2:	REST_GPRS(3, 6, r11)
 	lwz	r10,_CCR(r11)
-	REST_2GPRS(1, r11)
+	REST_GPRS(1, 2, r11)
 	mtcr	r10
 	lwz	r10,_LINK(r11)
 	mtlr	r10
@@ -298,16 +297,14 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_STCX_CHECKS_ADDRESS)
 	 * the reliable stack unwinder later on. Clear it.
 	 */
 	stw	r0,8(r1)
-	REST_4GPRS(7, r1)
-	REST_2GPRS(11, r1)
+	REST_GPRS(7, 12, r1)
 
 	mtcr	r3
 	mtlr	r4
 	mtctr	r5
 	mtspr	SPRN_XER,r6
 
-	REST_4GPRS(2, r1)
-	REST_GPR(6, r1)
+	REST_GPRS(2, 6, r1)
 	REST_GPR(0, r1)
 	REST_GPR(1, r1)
 	rfi
@@ -341,8 +338,7 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_STCX_CHECKS_ADDRESS)
 	lwz	r6,_CCR(r1)
 	li	r0,0
 
-	REST_4GPRS(7, r1)
-	REST_2GPRS(11, r1)
+	REST_GPRS(7, 12, r1)
 
 	mtlr	r3
 	mtctr	r4
@@ -354,7 +350,7 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_STCX_CHECKS_ADDRESS)
 	 */
 	stw	r0,8(r1)
 
-	REST_4GPRS(2, r1)
+	REST_GPRS(2, 5, r1)
 
 	bne-	cr1,1f /* emulate stack store */
 	mtcr	r6
@@ -430,8 +426,7 @@ _ASM_NOKPROBE_SYMBOL(interrupt_return)
 	bne	interrupt_return;					\
 	lwz	r0,GPR0(r1);						\
 	lwz	r2,GPR2(r1);						\
-	REST_4GPRS(3, r1);						\
-	REST_2GPRS(7, r1);						\
+	REST_GPRS(3, 8, r1);						\
 	lwz	r10,_XER(r1);						\
 	lwz	r11,_CTR(r1);						\
 	mtspr	SPRN_XER,r10;						\
diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
index 711c66b76df1..67dc4e3179a0 100644
--- a/arch/powerpc/kernel/exceptions-64e.S
+++ b/arch/powerpc/kernel/exceptions-64e.S
@@ -198,8 +198,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_EMB_HV)
 
 	stdcx.	r0,0,r1		/* to clear the reservation */
 
-	REST_4GPRS(2, r1)
-	REST_4GPRS(6, r1)
+	REST_GPRS(2, 9, r1)
 
 	ld	r10,_CTR(r1)
 	ld	r11,_XER(r1)
@@ -375,9 +374,7 @@ ret_from_mc_except:
 exc_##n##_common:							    \
 	std	r0,GPR0(r1);		/* save r0 in stackframe */	    \
 	std	r2,GPR2(r1);		/* save r2 in stackframe */	    \
-	SAVE_4GPRS(3, r1);		/* save r3 - r6 in stackframe */    \
-	SAVE_2GPRS(7, r1);		/* save r7, r8 in stackframe */	    \
-	std	r9,GPR9(r1);		/* save r9 in stackframe */	    \
+	SAVE_GPRS(3, 9, r1);		/* save r3 - r9 in stackframe */    \
 	std	r10,_NIP(r1);		/* save SRR0 to stackframe */	    \
 	std	r11,_MSR(r1);		/* save SRR1 to stackframe */	    \
 	beq	2f;			/* if from kernel mode */	    \
@@ -1061,9 +1058,7 @@ bad_stack_book3e:
 	std	r11,_ESR(r1)
 	std	r0,GPR0(r1);		/* save r0 in stackframe */	    \
 	std	r2,GPR2(r1);		/* save r2 in stackframe */	    \
-	SAVE_4GPRS(3, r1);		/* save r3 - r6 in stackframe */    \
-	SAVE_2GPRS(7, r1);		/* save r7, r8 in stackframe */	    \
-	std	r9,GPR9(r1);		/* save r9 in stackframe */	    \
+	SAVE_GPRS(3, 9, r1);		/* save r3 - r9 in stackframe */    \
 	ld	r3,PACA_EXGEN+EX_R10(r13);/* get back r10 */		    \
 	ld	r4,PACA_EXGEN+EX_R11(r13);/* get back r11 */		    \
 	mfspr	r5,SPRN_SPRG_GEN_SCRATCH;/* get back r13 XXX can be wrong */ \
@@ -1077,8 +1072,7 @@ bad_stack_book3e:
 	std	r10,_LINK(r1)
 	std	r11,_CTR(r1)
 	std	r12,_XER(r1)
-	SAVE_10GPRS(14,r1)
-	SAVE_8GPRS(24,r1)
+	SAVE_GPRS(14, 31, r1)
 	lhz	r12,PACA_TRAP_SAVE(r13)
 	std	r12,_TRAP(r1)
 	addi	r11,r1,INT_FRAME_SIZE
diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index eaf1f72131a1..277eccf0f086 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -574,8 +574,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
 	ld	r10,IAREA+EX_CTR(r13)
 	std	r10,_CTR(r1)
 	std	r2,GPR2(r1)		/* save r2 in stackframe	*/
-	SAVE_4GPRS(3, r1)		/* save r3 - r6 in stackframe   */
-	SAVE_2GPRS(7, r1)		/* save r7, r8 in stackframe	*/
+	SAVE_GPRS(3, 8, r1)		/* save r3 - r8 in stackframe   */
 	mflr	r9			/* Get LR, later save to stack	*/
 	ld	r2,PACATOC(r13)		/* get kernel TOC into r2	*/
 	std	r9,_LINK(r1)
@@ -693,8 +692,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_CFAR)
 	mtlr	r9
 	ld	r9,_CCR(r1)
 	mtcr	r9
-	REST_8GPRS(2, r1)
-	REST_4GPRS(10, r1)
+	REST_GPRS(2, 13, r1)
 	REST_GPR(0, r1)
 	/* restore original r1. */
 	ld	r1,GPR1(r1)
diff --git a/arch/powerpc/kernel/head_32.h b/arch/powerpc/kernel/head_32.h
index 349c4a820231..261c79bdbe53 100644
--- a/arch/powerpc/kernel/head_32.h
+++ b/arch/powerpc/kernel/head_32.h
@@ -115,8 +115,7 @@ _ASM_NOKPROBE_SYMBOL(\name\()_virt)
 	stw	r10,8(r1)
 	li	r10, \trapno
 	stw	r10,_TRAP(r1)
-	SAVE_4GPRS(3, r1)
-	SAVE_2GPRS(7, r1)
+	SAVE_GPRS(3, 8, r1)
 	SAVE_NVGPRS(r1)
 	stw	r2,GPR2(r1)
 	stw	r12,_NIP(r1)
diff --git a/arch/powerpc/kernel/head_booke.h b/arch/powerpc/kernel/head_booke.h
index ef8d1b1c234e..bb6d5d0fc4ac 100644
--- a/arch/powerpc/kernel/head_booke.h
+++ b/arch/powerpc/kernel/head_booke.h
@@ -87,8 +87,7 @@ END_BTB_FLUSH_SECTION
 	stw	r10, 8(r1)
 	li	r10, \trapno
 	stw	r10,_TRAP(r1)
-	SAVE_4GPRS(3, r1)
-	SAVE_2GPRS(7, r1)
+	SAVE_GPRS(3, 8, r1)
 	SAVE_NVGPRS(r1)
 	stw	r2,GPR2(r1)
 	stw	r12,_NIP(r1)
diff --git a/arch/powerpc/kernel/interrupt_64.S b/arch/powerpc/kernel/interrupt_64.S
index 4c6d1a8dcefe..ff8c8c03f41a 100644
--- a/arch/powerpc/kernel/interrupt_64.S
+++ b/arch/powerpc/kernel/interrupt_64.S
@@ -166,10 +166,9 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	 * The value of AMR only matters while we're in the kernel.
 	 */
 	mtcr	r2
-	ld	r2,GPR2(r1)
-	ld	r3,GPR3(r1)
-	ld	r13,GPR13(r1)
-	ld	r1,GPR1(r1)
+	REST_GPRS(2, 3, r1)
+	REST_GPR(13, r1)
+	REST_GPR(1, r1)
 	RFSCV_TO_USER
 	b	.	/* prevent speculative execution */
 
@@ -187,9 +186,8 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	mtctr	r3
 	mtlr	r4
 	mtspr	SPRN_XER,r5
-	REST_10GPRS(2, r1)
-	REST_2GPRS(12, r1)
-	ld	r1,GPR1(r1)
+	REST_GPRS(2, 13, r1)
+	REST_GPR(1, r1)
 	RFI_TO_USER
 .Lsyscall_vectored_\name\()_rst_end:
 
@@ -378,10 +376,9 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	 * The value of AMR only matters while we're in the kernel.
 	 */
 	mtcr	r2
-	ld	r2,GPR2(r1)
-	ld	r3,GPR3(r1)
-	ld	r13,GPR13(r1)
-	ld	r1,GPR1(r1)
+	REST_GPRS(2, 3, r1)
+	REST_GPR(13, r1)
+	REST_GPR(1, r1)
 	RFI_TO_USER
 	b	.	/* prevent speculative execution */
 
@@ -392,8 +389,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_HAS_PPR)
 	mtctr	r3
 	mtspr	SPRN_XER,r4
 	ld	r0,GPR0(r1)
-	REST_8GPRS(4, r1)
-	ld	r12,GPR12(r1)
+	REST_GPRS(4, 12, r1)
 	b	.Lsyscall_restore_regs_cont
 .Lsyscall_rst_end:
 
@@ -522,17 +518,14 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_STCX_CHECKS_ADDRESS)
 	ld	r6,_XER(r1)
 	li	r0,0
 
-	REST_4GPRS(7, r1)
-	REST_2GPRS(11, r1)
-	REST_GPR(13, r1)
+	REST_GPRS(7, 13, r1)
 
 	mtcr	r3
 	mtlr	r4
 	mtctr	r5
 	mtspr	SPRN_XER,r6
 
-	REST_4GPRS(2, r1)
-	REST_GPR(6, r1)
+	REST_GPRS(2, 6, r1)
 	REST_GPR(0, r1)
 	REST_GPR(1, r1)
 	.ifc \srr,srr
@@ -629,8 +622,7 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_STCX_CHECKS_ADDRESS)
 	ld	r6,_CCR(r1)
 	li	r0,0
 
-	REST_4GPRS(7, r1)
-	REST_2GPRS(11, r1)
+	REST_GPRS(7, 12, r1)
 
 	mtlr	r3
 	mtctr	r4
@@ -642,7 +634,7 @@ ALT_FTR_SECTION_END_IFCLR(CPU_FTR_STCX_CHECKS_ADDRESS)
 	 */
 	std	r0,STACK_FRAME_OVERHEAD-16(r1)
 
-	REST_4GPRS(2, r1)
+	REST_GPRS(2, 5, r1)
 
 	bne-	cr1,1f /* emulate stack store */
 	mtcr	r6
diff --git a/arch/powerpc/kernel/optprobes_head.S b/arch/powerpc/kernel/optprobes_head.S
index 19ea3312403c..5c7f0b4b784b 100644
--- a/arch/powerpc/kernel/optprobes_head.S
+++ b/arch/powerpc/kernel/optprobes_head.S
@@ -10,8 +10,8 @@
 #include <asm/asm-offsets.h>
 
 #ifdef CONFIG_PPC64
-#define SAVE_30GPRS(base) SAVE_10GPRS(2,base); SAVE_10GPRS(12,base); SAVE_10GPRS(22,base)
-#define REST_30GPRS(base) REST_10GPRS(2,base); REST_10GPRS(12,base); REST_10GPRS(22,base)
+#define SAVE_30GPRS(base) SAVE_GPRS(2, 31, base)
+#define REST_30GPRS(base) REST_GPRS(2, 31, base)
 #define TEMPLATE_FOR_IMM_LOAD_INSNS	nop; nop; nop; nop; nop
 #else
 #define SAVE_30GPRS(base) stmw	r2, GPR2(base)
diff --git a/arch/powerpc/kernel/tm.S b/arch/powerpc/kernel/tm.S
index 2b91f233b05d..3beecc32940b 100644
--- a/arch/powerpc/kernel/tm.S
+++ b/arch/powerpc/kernel/tm.S
@@ -226,11 +226,8 @@ _GLOBAL(tm_reclaim)
 
 	/* Sync the userland GPRs 2-12, 14-31 to thread->regs: */
 	SAVE_GPR(0, r7)				/* user r0 */
-	SAVE_GPR(2, r7)				/* user r2 */
-	SAVE_4GPRS(3, r7)			/* user r3-r6 */
-	SAVE_GPR(8, r7)				/* user r8 */
-	SAVE_GPR(9, r7)				/* user r9 */
-	SAVE_GPR(10, r7)			/* user r10 */
+	SAVE_GPRS(2, 6, r7)			/* user r2-r6 */
+	SAVE_GPRS(8, 10, r7)			/* user r8-r10 */
 	ld	r3, GPR1(r1)			/* user r1 */
 	ld	r4, GPR7(r1)			/* user r7 */
 	ld	r5, GPR11(r1)			/* user r11 */
@@ -445,12 +442,8 @@ restore_gprs:
 	ld	r6, THREAD_TM_PPR(r3)
 
 	REST_GPR(0, r7)				/* GPR0 */
-	REST_2GPRS(2, r7)			/* GPR2-3 */
-	REST_GPR(4, r7)				/* GPR4 */
-	REST_4GPRS(8, r7)			/* GPR8-11 */
-	REST_2GPRS(12, r7)			/* GPR12-13 */
-
-	REST_NVGPRS(r7)				/* GPR14-31 */
+	REST_GPRS(2, 4, r7)			/* GPR2-4 */
+	REST_GPRS(8, 31, r7)			/* GPR8-31 */
 
 	/* Load up PPR and DSCR here so we don't run with user values for long */
 	mtspr	SPRN_DSCR, r5
diff --git a/arch/powerpc/kernel/trace/ftrace_64_mprofile.S b/arch/powerpc/kernel/trace/ftrace_64_mprofile.S
index f9fd5f743eba..d636fc755f60 100644
--- a/arch/powerpc/kernel/trace/ftrace_64_mprofile.S
+++ b/arch/powerpc/kernel/trace/ftrace_64_mprofile.S
@@ -41,15 +41,14 @@ _GLOBAL(ftrace_regs_caller)
 
 	/* Save all gprs to pt_regs */
 	SAVE_GPR(0, r1)
-	SAVE_10GPRS(2, r1)
+	SAVE_GPRS(2, 11, r1)
 
 	/* Ok to continue? */
 	lbz	r3, PACA_FTRACE_ENABLED(r13)
 	cmpdi	r3, 0
 	beq	ftrace_no_trace
 
-	SAVE_10GPRS(12, r1)
-	SAVE_10GPRS(22, r1)
+	SAVE_GPRS(12, 31, r1)
 
 	/* Save previous stack pointer (r1) */
 	addi	r8, r1, SWITCH_FRAME_SIZE
@@ -108,10 +107,8 @@ ftrace_regs_call:
 #endif
 
 	/* Restore gprs */
-	REST_GPR(0,r1)
-	REST_10GPRS(2,r1)
-	REST_10GPRS(12,r1)
-	REST_10GPRS(22,r1)
+	REST_GPR(0, r1)
+	REST_GPRS(2, 31, r1)
 
 	/* Restore possibly modified LR */
 	ld	r0, _LINK(r1)
@@ -157,7 +154,7 @@ _GLOBAL(ftrace_caller)
 	stdu	r1, -SWITCH_FRAME_SIZE(r1)
 
 	/* Save all gprs to pt_regs */
-	SAVE_8GPRS(3, r1)
+	SAVE_GPRS(3, 10, r1)
 
 	lbz	r3, PACA_FTRACE_ENABLED(r13)
 	cmpdi	r3, 0
@@ -194,7 +191,7 @@ ftrace_call:
 	mtctr	r3
 
 	/* Restore gprs */
-	REST_8GPRS(3,r1)
+	REST_GPRS(3, 10, r1)
 
 	/* Restore callee's TOC */
 	ld	r2, 24(r1)
diff --git a/arch/powerpc/kvm/book3s_hv_rmhandlers.S b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
index 32a4b4d412b9..81fc1e0ebe9a 100644
--- a/arch/powerpc/kvm/book3s_hv_rmhandlers.S
+++ b/arch/powerpc/kvm/book3s_hv_rmhandlers.S
@@ -2711,8 +2711,7 @@ kvmppc_bad_host_intr:
 	std	r0, GPR0(r1)
 	std	r9, GPR1(r1)
 	std	r2, GPR2(r1)
-	SAVE_4GPRS(3, r1)
-	SAVE_2GPRS(7, r1)
+	SAVE_GPRS(3, 8, r1)
 	srdi	r0, r12, 32
 	clrldi	r12, r12, 32
 	std	r0, _CCR(r1)
@@ -2735,7 +2734,7 @@ kvmppc_bad_host_intr:
 	ld	r9, HSTATE_SCRATCH2(r13)
 	ld	r12, HSTATE_SCRATCH0(r13)
 	GET_SCRATCH0(r0)
-	SAVE_4GPRS(9, r1)
+	SAVE_GPRS(9, 12, r1)
 	std	r0, GPR13(r1)
 	SAVE_NVGPRS(r1)
 	ld	r5, HSTATE_CFAR(r13)
diff --git a/arch/powerpc/lib/test_emulate_step_exec_instr.S b/arch/powerpc/lib/test_emulate_step_exec_instr.S
index 9ef941d958d8..5473f9d03df3 100644
--- a/arch/powerpc/lib/test_emulate_step_exec_instr.S
+++ b/arch/powerpc/lib/test_emulate_step_exec_instr.S
@@ -37,7 +37,7 @@ _GLOBAL(exec_instr)
 	 * The stack pointer (GPR1) and the thread pointer (GPR13) are not
 	 * saved as these should not be modified anyway.
 	 */
-	SAVE_2GPRS(2, r1)
+	SAVE_GPRS(2, 3, r1)
 	SAVE_NVGPRS(r1)
 
 	/*
@@ -75,8 +75,7 @@ _GLOBAL(exec_instr)
 
 	/* Load GPRs from pt_regs */
 	REST_GPR(0, r31)
-	REST_10GPRS(2, r31)
-	REST_GPR(12, r31)
+	REST_GPRS(2, 12, r31)
 	REST_NVGPRS(r31)
 
 	/* Placeholder for the test instruction */
@@ -99,8 +98,7 @@ _GLOBAL(exec_instr)
 	subi	r3, r3, GPR0
 	SAVE_GPR(0, r3)
 	SAVE_GPR(2, r3)
-	SAVE_8GPRS(4, r3)
-	SAVE_GPR(12, r3)
+	SAVE_GPRS(4, 12, r3)
 	SAVE_NVGPRS(r3)
 
 	/* Save resulting LR to pt_regs */
-- 
2.35.1



