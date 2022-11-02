Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FC261580C
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 03:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiKBCoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 22:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230326AbiKBCoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 22:44:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E22FF1FCC1
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:44:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F94A601C6
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 02:44:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 201B4C433D6;
        Wed,  2 Nov 2022 02:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667357063;
        bh=8vhQ9QGUp701gyPl88umBGYkGLyY9qqgtlWYS1YQ3CY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YdECXwXAPRXti2ZLPclLTHsFYYaUFX/G4iOYIERcWIK+MmtJBiPTusQg3OvqZOVbQ
         p3nnwneZxKrofhs4UuKFXxlVBqNWCLuytEzjKoiJU3o4vtRoviv0PP4haIx23o+Pjf
         4XYS/LA1uVH83c9Pa+ScPCu8UYE8lCFjyrmky61Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sachin Sant <sachinp@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.0 107/240] powerpc/64s/interrupt: Fix clear of PACA_IRQS_HARD_DIS when returning to soft-masked context
Date:   Wed,  2 Nov 2022 03:31:22 +0100
Message-Id: <20221102022113.810485845@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit 65722736c3baf29e02e964a09e85c9ef71c48e8d upstream.

Commit a4cb3651a1743 ("powerpc/64s/interrupt: Fix lost interrupts when
returning to soft-masked context") fixed the problem of pending irqs
being cleared when clearing the HARD_DIS bit, but then it didn't clear
the bit at all. This change clears HARD_DIS without affecting other bits
in the mask.

When an interrupt hits in a soft-masked section that has MSR[EE]=1, it
can hard disable and set PACA_IRQS_HARD_DIS, which must be cleared when
returning to the EE=1 caller (unless it was set due to a MUST_HARD_MASK
interrupt becoming pending). Failure to clear this leaves the
returned-to context running with MSR[EE]=1 and PACA_IRQS_HARD_DIS, which
confuses irq assertions and could be dangerous for code that might test
the flag.

This was observed in a hash MMU kernel where a kernel hash fault hits in
a local_irqs_disabled region that has EE=1. The hash fault also runs
with EE=1, then as it returns, a decrementer hits in the restart section
and the irq restart code hard-masks which sets the PACA_IRQ_HARD_DIS
flag, which is not clear when the original context is returned to.

Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Fixes: a4cb3651a1743 ("powerpc/64s/interrupt: Fix lost interrupts when returning to soft-masked context")
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Tested-by: Sachin Sant <sachinp@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221022052207.471328-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/interrupt_64.S |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/interrupt_64.S
+++ b/arch/powerpc/kernel/interrupt_64.S
@@ -565,15 +565,24 @@ _ASM_NOKPROBE_SYMBOL(interrupt_return_\s
 	 * Returning to soft-disabled context.
 	 * Check if a MUST_HARD_MASK interrupt has become pending, in which
 	 * case we need to disable MSR[EE] in the return context.
+	 *
+	 * The MSR[EE] check catches among other things the short incoherency
+	 * in hard_irq_disable() between clearing MSR[EE] and setting
+	 * PACA_IRQ_HARD_DIS.
 	 */
 	ld	r12,_MSR(r1)
 	andi.	r10,r12,MSR_EE
 	beq	.Lfast_kernel_interrupt_return_\srr\() // EE already disabled
 	lbz	r11,PACAIRQHAPPENED(r13)
 	andi.	r10,r11,PACA_IRQ_MUST_HARD_MASK
-	beq	.Lfast_kernel_interrupt_return_\srr\() // No HARD_MASK pending
+	bne	1f // HARD_MASK is pending
+	// No HARD_MASK pending, clear possible HARD_DIS set by interrupt
+	andi.	r11,r11,(~PACA_IRQ_HARD_DIS)@l
+	stb	r11,PACAIRQHAPPENED(r13)
+	b	.Lfast_kernel_interrupt_return_\srr\()
 
-	/* Must clear MSR_EE from _MSR */
+
+1:	/* Must clear MSR_EE from _MSR */
 #ifdef CONFIG_PPC_BOOK3S
 	li	r10,0
 	/* Clear valid before changing _MSR */


