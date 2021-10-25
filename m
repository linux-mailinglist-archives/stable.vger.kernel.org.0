Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB5C43A14D
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:37:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236280AbhJYTiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:38:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232813AbhJYTfQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:35:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A005660EFE;
        Mon, 25 Oct 2021 19:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190357;
        bh=maRFXtQ1lx3G6s9oivxxtVSwlcxrbiWrzBNhxA4uE38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jIT0XMERI55hHiITUYZTu/94H8qe4gQlOpoiV9jvXwXVlFRYXDhGg/GrgNTHx4sx9
         a2CFyOL+bmL3RUqp1um8G7qDVDz6iJ4nFXMCzXcPvirKqd9hW2ZL4ZKbCRlhKrJY1s
         ptRdq2AwWMZHOV79TxU36V8lRXi0tmv47zwedi2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Christopher M. Riedl" <cmr@codefail.de>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.10 55/95] powerpc64/idle: Fix SP offsets when saving GPRs
Date:   Mon, 25 Oct 2021 21:14:52 +0200
Message-Id: <20211025191004.943027833@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christopher M. Riedl <cmr@codefail.de>

commit 73287caa9210ded6066833195f4335f7f688a46b upstream.

The idle entry/exit code saves/restores GPRs in the stack "red zone"
(Protected Zone according to PowerPC64 ELF ABI v2). However, the offset
used for the first GPR is incorrect and overwrites the back chain - the
Protected Zone actually starts below the current SP. In practice this is
probably not an issue, but it's still incorrect so fix it.

Also expand the comments to explain why using the stack "red zone"
instead of creating a new stackframe is appropriate here.

Signed-off-by: Christopher M. Riedl <cmr@codefail.de>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210206072342.5067-1-cmr@codefail.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/idle_book3s.S |  138 ++++++++++++++++++++------------------
 1 file changed, 73 insertions(+), 65 deletions(-)

--- a/arch/powerpc/kernel/idle_book3s.S
+++ b/arch/powerpc/kernel/idle_book3s.S
@@ -52,28 +52,32 @@ _GLOBAL(isa300_idle_stop_mayloss)
 	std	r1,PACAR1(r13)
 	mflr	r4
 	mfcr	r5
-	/* use stack red zone rather than a new frame for saving regs */
-	std	r2,-8*0(r1)
-	std	r14,-8*1(r1)
-	std	r15,-8*2(r1)
-	std	r16,-8*3(r1)
-	std	r17,-8*4(r1)
-	std	r18,-8*5(r1)
-	std	r19,-8*6(r1)
-	std	r20,-8*7(r1)
-	std	r21,-8*8(r1)
-	std	r22,-8*9(r1)
-	std	r23,-8*10(r1)
-	std	r24,-8*11(r1)
-	std	r25,-8*12(r1)
-	std	r26,-8*13(r1)
-	std	r27,-8*14(r1)
-	std	r28,-8*15(r1)
-	std	r29,-8*16(r1)
-	std	r30,-8*17(r1)
-	std	r31,-8*18(r1)
-	std	r4,-8*19(r1)
-	std	r5,-8*20(r1)
+	/*
+	 * Use the stack red zone rather than a new frame for saving regs since
+	 * in the case of no GPR loss the wakeup code branches directly back to
+	 * the caller without deallocating the stack frame first.
+	 */
+	std	r2,-8*1(r1)
+	std	r14,-8*2(r1)
+	std	r15,-8*3(r1)
+	std	r16,-8*4(r1)
+	std	r17,-8*5(r1)
+	std	r18,-8*6(r1)
+	std	r19,-8*7(r1)
+	std	r20,-8*8(r1)
+	std	r21,-8*9(r1)
+	std	r22,-8*10(r1)
+	std	r23,-8*11(r1)
+	std	r24,-8*12(r1)
+	std	r25,-8*13(r1)
+	std	r26,-8*14(r1)
+	std	r27,-8*15(r1)
+	std	r28,-8*16(r1)
+	std	r29,-8*17(r1)
+	std	r30,-8*18(r1)
+	std	r31,-8*19(r1)
+	std	r4,-8*20(r1)
+	std	r5,-8*21(r1)
 	/* 168 bytes */
 	PPC_STOP
 	b	.	/* catch bugs */
@@ -89,8 +93,8 @@ _GLOBAL(isa300_idle_stop_mayloss)
  */
 _GLOBAL(idle_return_gpr_loss)
 	ld	r1,PACAR1(r13)
-	ld	r4,-8*19(r1)
-	ld	r5,-8*20(r1)
+	ld	r4,-8*20(r1)
+	ld	r5,-8*21(r1)
 	mtlr	r4
 	mtcr	r5
 	/*
@@ -98,25 +102,25 @@ _GLOBAL(idle_return_gpr_loss)
 	 * from PACATOC. This could be avoided for that less common case
 	 * if KVM saved its r2.
 	 */
-	ld	r2,-8*0(r1)
-	ld	r14,-8*1(r1)
-	ld	r15,-8*2(r1)
-	ld	r16,-8*3(r1)
-	ld	r17,-8*4(r1)
-	ld	r18,-8*5(r1)
-	ld	r19,-8*6(r1)
-	ld	r20,-8*7(r1)
-	ld	r21,-8*8(r1)
-	ld	r22,-8*9(r1)
-	ld	r23,-8*10(r1)
-	ld	r24,-8*11(r1)
-	ld	r25,-8*12(r1)
-	ld	r26,-8*13(r1)
-	ld	r27,-8*14(r1)
-	ld	r28,-8*15(r1)
-	ld	r29,-8*16(r1)
-	ld	r30,-8*17(r1)
-	ld	r31,-8*18(r1)
+	ld	r2,-8*1(r1)
+	ld	r14,-8*2(r1)
+	ld	r15,-8*3(r1)
+	ld	r16,-8*4(r1)
+	ld	r17,-8*5(r1)
+	ld	r18,-8*6(r1)
+	ld	r19,-8*7(r1)
+	ld	r20,-8*8(r1)
+	ld	r21,-8*9(r1)
+	ld	r22,-8*10(r1)
+	ld	r23,-8*11(r1)
+	ld	r24,-8*12(r1)
+	ld	r25,-8*13(r1)
+	ld	r26,-8*14(r1)
+	ld	r27,-8*15(r1)
+	ld	r28,-8*16(r1)
+	ld	r29,-8*17(r1)
+	ld	r30,-8*18(r1)
+	ld	r31,-8*19(r1)
 	blr
 
 /*
@@ -154,28 +158,32 @@ _GLOBAL(isa206_idle_insn_mayloss)
 	std	r1,PACAR1(r13)
 	mflr	r4
 	mfcr	r5
-	/* use stack red zone rather than a new frame for saving regs */
-	std	r2,-8*0(r1)
-	std	r14,-8*1(r1)
-	std	r15,-8*2(r1)
-	std	r16,-8*3(r1)
-	std	r17,-8*4(r1)
-	std	r18,-8*5(r1)
-	std	r19,-8*6(r1)
-	std	r20,-8*7(r1)
-	std	r21,-8*8(r1)
-	std	r22,-8*9(r1)
-	std	r23,-8*10(r1)
-	std	r24,-8*11(r1)
-	std	r25,-8*12(r1)
-	std	r26,-8*13(r1)
-	std	r27,-8*14(r1)
-	std	r28,-8*15(r1)
-	std	r29,-8*16(r1)
-	std	r30,-8*17(r1)
-	std	r31,-8*18(r1)
-	std	r4,-8*19(r1)
-	std	r5,-8*20(r1)
+	/*
+	 * Use the stack red zone rather than a new frame for saving regs since
+	 * in the case of no GPR loss the wakeup code branches directly back to
+	 * the caller without deallocating the stack frame first.
+	 */
+	std	r2,-8*1(r1)
+	std	r14,-8*2(r1)
+	std	r15,-8*3(r1)
+	std	r16,-8*4(r1)
+	std	r17,-8*5(r1)
+	std	r18,-8*6(r1)
+	std	r19,-8*7(r1)
+	std	r20,-8*8(r1)
+	std	r21,-8*9(r1)
+	std	r22,-8*10(r1)
+	std	r23,-8*11(r1)
+	std	r24,-8*12(r1)
+	std	r25,-8*13(r1)
+	std	r26,-8*14(r1)
+	std	r27,-8*15(r1)
+	std	r28,-8*16(r1)
+	std	r29,-8*17(r1)
+	std	r30,-8*18(r1)
+	std	r31,-8*19(r1)
+	std	r4,-8*20(r1)
+	std	r5,-8*21(r1)
 	cmpwi	r3,PNV_THREAD_NAP
 	bne	1f
 	IDLE_STATE_ENTER_SEQ_NORET(PPC_NAP)


