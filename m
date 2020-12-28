Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E008C2E3F90
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502450AbgL1OmD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:42:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:35108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502498AbgL1O1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:27:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 829ED229C5;
        Mon, 28 Dec 2020 14:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165656;
        bh=AxDOpenW7RBqVlAmoGADVtEeo+8Eh7t5TpWJkifhq6A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DEL6uPABaf0EV6t9dZphDS6925Hwhnbpg83KiB1Xzfd6aeBVI2KmwDCuQeiZ7b5//
         64h41ChmMe8NdaO2tlt/KVsxjweEgG9a5Nsxq13mERQjzLHHy7wBT4T5pubSBg3nEE
         pBQ9tBpqvhNtP0EElbUFzm+Hd2nczfuwkrUypyWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 607/717] powerpc/32: Fix vmap stack - Properly set r1 before activating MMU on syscall too
Date:   Mon, 28 Dec 2020 13:50:05 +0100
Message-Id: <20201228125049.995251298@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit d5c243989fb0cb03c74d7340daca3b819f706ee7 upstream.

We need r1 to be properly set before activating MMU, otherwise any new
exception taken while saving registers into the stack in syscall
prologs will use the user stack, which is wrong and will even lockup
or crash when KUAP is selected.

Do that by switching the meaning of r11 and r1 until we have saved r1
to the stack: copy r1 into r11 and setup the new stack pointer in r1.
To avoid complicating and impacting all generic and specific prolog
code (and more), copy back r1 into r11 once r11 is save onto
the stack.

We could get rid of copying r1 back and forth at the cost of rewriting
everything to use r1 instead of r11 all the way when CONFIG_VMAP_STACK
is set, but the effort is probably not worth it for now.

Fixes: da7bb43ab9da ("powerpc/32: Fix vmap stack - Properly set r1 before activating MMU")
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/a3d819d5c348cee9783a311d5d3f3ba9b48fd219.1608531452.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/head_32.h |   25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

--- a/arch/powerpc/kernel/head_32.h
+++ b/arch/powerpc/kernel/head_32.h
@@ -131,18 +131,28 @@
 #ifdef CONFIG_VMAP_STACK
 	mfspr	r11, SPRN_SRR0
 	mtctr	r11
-#endif
 	andi.	r11, r9, MSR_PR
-	lwz	r11,TASK_STACK-THREAD(r12)
+	mr	r11, r1
+	lwz	r1,TASK_STACK-THREAD(r12)
 	beq-	99f
-	addi	r11, r11, THREAD_SIZE - INT_FRAME_SIZE
-#ifdef CONFIG_VMAP_STACK
+	addi	r1, r1, THREAD_SIZE - INT_FRAME_SIZE
 	li	r10, MSR_KERNEL & ~(MSR_IR | MSR_RI) /* can take DTLB miss */
 	mtmsr	r10
 	isync
+	tovirt(r12, r12)
+	stw	r11,GPR1(r1)
+	stw	r11,0(r1)
+	mr	r11, r1
+#else
+	andi.	r11, r9, MSR_PR
+	lwz	r11,TASK_STACK-THREAD(r12)
+	beq-	99f
+	addi	r11, r11, THREAD_SIZE - INT_FRAME_SIZE
+	tophys(r11, r11)
+	stw	r1,GPR1(r11)
+	stw	r1,0(r11)
+	tovirt(r1, r11)		/* set new kernel sp */
 #endif
-	tovirt_vmstack r12, r12
-	tophys_novmstack r11, r11
 	mflr	r10
 	stw	r10, _LINK(r11)
 #ifdef CONFIG_VMAP_STACK
@@ -150,9 +160,6 @@
 #else
 	mfspr	r10,SPRN_SRR0
 #endif
-	stw	r1,GPR1(r11)
-	stw	r1,0(r11)
-	tovirt_novmstack r1, r11	/* set new kernel sp */
 	stw	r10,_NIP(r11)
 	mfcr	r10
 	rlwinm	r10,r10,0,4,2	/* Clear SO bit in CR */


