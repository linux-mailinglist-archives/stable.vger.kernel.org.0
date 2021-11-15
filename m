Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73684451EA0
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348127AbhKPAgu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:36:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45404 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345045AbhKOT0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:26:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1CAD60F51;
        Mon, 15 Nov 2021 19:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637003365;
        bh=mgDNW/47jdGYvV6npQU2dMyP1XGWNtNNHdrFuNuvKYs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AD5PWtKefCrPTb4NYQduGrDcQaYMGZ6bl1c9zzSyjknKQ/9dVgOpJh6NnoO96u1qP
         I/CAGATpPI5smwMpLDjLe5MtIvxFPSmuGG3A1L5ry/FJnDkshGiRZiWm5oANSavvsy
         rRS1EFHv1/q2AtGjjag1mKfAS4/5BBVp51CPOwvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jacques de Laval <jacques.delaval@protonmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 907/917] powerpc/32e: Ignore ESR in instruction storage interrupt handler
Date:   Mon, 15 Nov 2021 18:06:42 +0100
Message-Id: <20211115165459.790919502@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit 81291383ffde08b23bce75e7d6b2575ce9d3475c upstream.

A e5500 machine running a 32-bit kernel sometimes hangs at boot,
seemingly going into an infinite loop of instruction storage interrupts.

The ESR (Exception Syndrome Register) has a value of 0x800000 (store)
when this happens, which is likely set by a previous store. An
instruction TLB miss interrupt would then leave ESR unchanged, and if no
PTE exists it calls directly to the instruction storage interrupt
handler without changing ESR.

access_error() does not cause a segfault due to a store to a read-only
vma because is_exec is true. Most subsequent fault handling does not
check for a write fault on a read-only vma, and might do strange things
like create a writeable PTE or call page_mkwrite on a read only vma or
file. It's not clear what happens here to cause the infinite faulting in
this case, a fault handler failure or low level PTE or TLB handling.

In any case this can be fixed by having the instruction storage
interrupt zero regs->dsisr rather than storing the ESR value to it.

Fixes: a01a3f2ddbcd ("powerpc: remove arguments from fault handler functions")
Cc: stable@vger.kernel.org # v5.12+
Reported-by: Jacques de Laval <jacques.delaval@protonmail.com>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Tested-by: Jacques de Laval <jacques.delaval@protonmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211028133043.4159501-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/head_booke.h |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/arch/powerpc/kernel/head_booke.h
+++ b/arch/powerpc/kernel/head_booke.h
@@ -465,12 +465,21 @@ label:
 	bl	do_page_fault;						      \
 	b	interrupt_return
 
+/*
+ * Instruction TLB Error interrupt handlers may call InstructionStorage
+ * directly without clearing ESR, so the ESR at this point may be left over
+ * from a prior interrupt.
+ *
+ * In any case, do_page_fault for BOOK3E does not use ESR and always expects
+ * dsisr to be 0. ESR_DST from a prior store in particular would confuse fault
+ * handling.
+ */
 #define INSTRUCTION_STORAGE_EXCEPTION					      \
 	START_EXCEPTION(InstructionStorage)				      \
-	NORMAL_EXCEPTION_PROLOG(0x400, INST_STORAGE);		      \
-	mfspr	r5,SPRN_ESR;		/* Grab the ESR and save it */	      \
+	NORMAL_EXCEPTION_PROLOG(0x400, INST_STORAGE);			      \
+	li	r5,0;			/* Store 0 in regs->esr (dsisr) */    \
 	stw	r5,_ESR(r11);						      \
-	stw	r12, _DEAR(r11);	/* Pass SRR0 as arg2 */		      \
+	stw	r12, _DEAR(r11);	/* Set regs->dear (dar) to SRR0 */    \
 	prepare_transfer_to_handler;					      \
 	bl	do_page_fault;						      \
 	b	interrupt_return


