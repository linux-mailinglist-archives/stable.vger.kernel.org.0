Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8698B2A5841
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731444AbgKCUtF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:49:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:41418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731693AbgKCUtC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:49:02 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA9F7223FD;
        Tue,  3 Nov 2020 20:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436542;
        bh=JhRCqgYBftJV9RLEr0aFlDHQbjUDv3WD1T3e62GZwS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nb7LI/o+UuP68FBpDKf3MEVqM+nEBJgq8Vzvn3MoC/p9Vv9De/y70uftnDAz1YuHZ
         LajoML3cvtqphx/b8ZADaEaGEYS1FNSe9+BqrKjXnKeU+/9sviunt9j6waftscKohq
         Vr0wNDI9Vhe528xtXJHOUeY/dbC54NFj6zcTYpiA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.9 294/391] powerpc/32: Fix vmap stack - Properly set r1 before activating MMU
Date:   Tue,  3 Nov 2020 21:35:45 +0100
Message-Id: <20201103203406.911311335@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit da7bb43ab9da39bcfed0d146ce94e1f0cbae4ca0 upstream.

We need r1 to be properly set before activating MMU, otherwise any new
exception taken while saving registers into the stack in exception
prologs will use the user stack, which is wrong and will even lockup
or crash when KUAP is selected.

Do that by switching the meaning of r11 and r1 until we have saved r1
to the stack: copy r1 into r11 and setup the new stack pointer in r1.
To avoid complicating and impacting all generic and specific prolog
code (and more), copy back r1 into r11 once r11 is save onto
the stack.

We could get rid of copying r1 back and forth at the cost of
rewriting everything to use r1 instead of r11 all the way when
CONFIG_VMAP_STACK is set, but the effort is probably not worth it.

Fixes: 028474876f47 ("powerpc/32: prepare for CONFIG_VMAP_STACK")
Cc: stable@vger.kernel.org
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/8f85e8752ac5af602db7237ef53d634f4f3d3892.1599486108.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/head_32.h |   43 ++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

--- a/arch/powerpc/kernel/head_32.h
+++ b/arch/powerpc/kernel/head_32.h
@@ -39,15 +39,24 @@
 .endm
 
 .macro EXCEPTION_PROLOG_1 for_rtas=0
+#ifdef CONFIG_VMAP_STACK
+	mr	r11, r1
+	subi	r1, r1, INT_FRAME_SIZE		/* use r1 if kernel */
+	beq	1f
+	mfspr	r1,SPRN_SPRG_THREAD
+	lwz	r1,TASK_STACK-THREAD(r1)
+	addi	r1, r1, THREAD_SIZE - INT_FRAME_SIZE
+#else
 	subi	r11, r1, INT_FRAME_SIZE		/* use r1 if kernel */
 	beq	1f
 	mfspr	r11,SPRN_SPRG_THREAD
 	lwz	r11,TASK_STACK-THREAD(r11)
 	addi	r11, r11, THREAD_SIZE - INT_FRAME_SIZE
+#endif
 1:
 	tophys_novmstack r11, r11
 #ifdef CONFIG_VMAP_STACK
-	mtcrf	0x7f, r11
+	mtcrf	0x7f, r1
 	bt	32 - THREAD_ALIGN_SHIFT, stack_overflow
 #endif
 .endm
@@ -62,6 +71,15 @@
 	stw	r10,_CCR(r11)		/* save registers */
 #endif
 	mfspr	r10, SPRN_SPRG_SCRATCH0
+#ifdef CONFIG_VMAP_STACK
+	stw	r11,GPR1(r1)
+	stw	r11,0(r1)
+	mr	r11, r1
+#else
+	stw	r1,GPR1(r11)
+	stw	r1,0(r11)
+	tovirt(r1, r11)		/* set new kernel sp */
+#endif
 	stw	r12,GPR12(r11)
 	stw	r9,GPR9(r11)
 	stw	r10,GPR10(r11)
@@ -89,9 +107,6 @@
 	mfspr	r12,SPRN_SRR0
 	mfspr	r9,SPRN_SRR1
 #endif
-	stw	r1,GPR1(r11)
-	stw	r1,0(r11)
-	tovirt_novmstack r1, r11	/* set new kernel sp */
 #ifdef CONFIG_40x
 	rlwinm	r9,r9,0,14,12		/* clear MSR_WE (necessary?) */
 #else
@@ -309,19 +324,19 @@ label:
 .macro vmap_stack_overflow_exception
 #ifdef CONFIG_VMAP_STACK
 #ifdef CONFIG_SMP
-	mfspr	r11, SPRN_SPRG_THREAD
-	lwz	r11, TASK_CPU - THREAD(r11)
-	slwi	r11, r11, 3
-	addis	r11, r11, emergency_ctx@ha
+	mfspr	r1, SPRN_SPRG_THREAD
+	lwz	r1, TASK_CPU - THREAD(r1)
+	slwi	r1, r1, 3
+	addis	r1, r1, emergency_ctx@ha
 #else
-	lis	r11, emergency_ctx@ha
+	lis	r1, emergency_ctx@ha
 #endif
-	lwz	r11, emergency_ctx@l(r11)
-	cmpwi	cr1, r11, 0
+	lwz	r1, emergency_ctx@l(r1)
+	cmpwi	cr1, r1, 0
 	bne	cr1, 1f
-	lis	r11, init_thread_union@ha
-	addi	r11, r11, init_thread_union@l
-1:	addi	r11, r11, THREAD_SIZE - INT_FRAME_SIZE
+	lis	r1, init_thread_union@ha
+	addi	r1, r1, init_thread_union@l
+1:	addi	r1, r1, THREAD_SIZE - INT_FRAME_SIZE
 	EXCEPTION_PROLOG_2
 	SAVE_NVGPRS(r11)
 	addi	r3, r1, STACK_FRAME_OVERHEAD


