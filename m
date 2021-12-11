Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE88A471429
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 15:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229721AbhLKOL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Dec 2021 09:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhLKOL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Dec 2021 09:11:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17D66C061714
        for <stable@vger.kernel.org>; Sat, 11 Dec 2021 06:11:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 32416CE2F8E
        for <stable@vger.kernel.org>; Sat, 11 Dec 2021 14:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1D61C004DD;
        Sat, 11 Dec 2021 14:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639231880;
        bh=gSPAkdMKYsY8ZnRy7J8M1tSjKo65CY+ZbYEgjWRb9VE=;
        h=From:To:Cc:Subject:Date:From;
        b=qJNRbC6iCUaJxI/Nus9IaeADQfAnWKt4SszqNiRR50OfYbHEvbI9KZIel1mKyecPN
         Khq9jn4QXCRJALawgC2gQkmipTr2hYcYXwZ6qzF5LRtghiqDxN62t9kCPrupBU7cpu
         jHZMxmmnfTlWoCzRJt5BlH4KMY5BmPZ01LPpjlhYJr80gtuSATGIM18wU+z5PMPXaI
         fhPf9fi5G9VXAMFWdOexWpzesW9yWfANwYSyH7+G0H1/6afWhfHM7QEBcmQvYxlew5
         283ExHUW7n5hILnwGzZ4iSHcN884UdE6pmGI8tWtLSOGpcIbbja0l4RAMafPTZRwSf
         Ke9N/0E+rvIiw==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-arm-kernel@lists.infradead.org
Cc:     linux@armlinux.org.uk, arnd@arndb.de, linus.walleij@linaro.org,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] ARM: entry: fix Thumb2 bug in iWMMXt exception handling
Date:   Sat, 11 Dec 2021 15:11:07 +0100
Message-Id: <20211211141107.2146050-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1945; h=from:subject; bh=gSPAkdMKYsY8ZnRy7J8M1tSjKo65CY+ZbYEgjWRb9VE=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBhtLF6p5ieeInM0JfWLq9ljBRJ856oYuNfciGA9Ham aiI4ikyJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYbSxegAKCRDDTyI5ktmPJEpfC/ 4xFEHMwoBXkVxYpqSg3O+L/o/au8QfDa4Jd2v6TFv/N5UkTzUuSvLaCg01OektjLw9ug4x4g/jffWw sssGGkbGL0d+Bp0VQ07+YYaget0VIHhqXle3kRGDhWJY+aFudljGQUj9nuBy2FviM1X2HqcPRiiTbM mUY6nzsFUlmTSmtldyPtPDj8ocVv9XflBPCmjZ9lc7GUiUUg+xIoONuz26DR/mQmsXALz9VwpgDad+ AiS6AnZBAOcsfObcsILGvdyllnE9G/KvccD/wnqlvZ3EaN0KFJuZApcRoJ6TZUN8j2/LjkWqelWVXG We74O4emIGvSvdoNc2Oj9TYlXakPeRzQVgZppzrc0cDWZwkFRTEGmSwOCKl8vtczutnxpdIaOYi+kk Rxt08bUNXSf45Pdo+XSEBIlhVzNff4nR6YiqIfHWC/3BILriYMUefS5jIQeJzoXzUwBd4c5mytg8/S Sgnf3bxkMnKbhFUfY1BjQTqDV6cyTCD3bg0f/V5MnbaW8=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The Thumb2 version of the FP exception handling entry code treats the
register holding the CP number (R8) differently, resulting in the iWMMXT
CP number check to be incorrect.

Fix this by unifying the ARM and Thumb2 code paths, by switching the
order of the additions of the TI_USED_CP offset and the shifted CP
index.

Cc: <stable@vger.kernel.org>
Fixes: b86040a59feb ("Thumb-2: Implementation of the unified start-up and exceptions code")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/kernel/entry-armv.S | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

Found through inspection, while I was looking at the entry code for the
IRQ and vmap'ed stacks work. Not sure whether/how this affects the
Thumb2 kernel running on PJ4 based systems.

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index ef7f58596f77..9721e2da7dbc 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -629,24 +629,22 @@ call_fpe:
 #endif
 	tst	r0, #0x08000000			@ only CDP/CPRT/LDC/STC have bit 27
 	tstne	r0, #0x04000000			@ bit 26 set on both ARM and Thumb-2
 	reteq	lr
 	and	r8, r0, #0x00000f00		@ mask out CP number
- THUMB(	lsr	r8, r8, #8		)
 	mov	r7, #1
-	add	r6, r10, #TI_USED_CP
- ARM(	strb	r7, [r6, r8, lsr #8]	)	@ set appropriate used_cp[]
- THUMB(	strb	r7, [r6, r8]		)	@ set appropriate used_cp[]
+	add	r6, r10, r8, lsr #8		@ add used_cp[] array offset first
+	strb	r7, [r6, #TI_USED_CP]		@ set appropriate used_cp[]
 #ifdef CONFIG_IWMMXT
 	@ Test if we need to give access to iWMMXt coprocessors
 	ldr	r5, [r10, #TI_FLAGS]
 	rsbs	r7, r8, #(1 << 8)		@ CP 0 or 1 only
 	movscs	r7, r5, lsr #(TIF_USING_IWMMXT + 1)
 	bcs	iwmmxt_task_enable
 #endif
  ARM(	add	pc, pc, r8, lsr #6	)
- THUMB(	lsl	r8, r8, #2		)
+ THUMB(	lsr	r8, r8, #6		)
  THUMB(	add	pc, r8			)
 	nop
 
 	ret.w	lr				@ CP#0
 	W(b)	do_fpe				@ CP#1 (FPE)
-- 
2.30.2

