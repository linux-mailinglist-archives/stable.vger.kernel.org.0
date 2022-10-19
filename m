Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96FE260402F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234182AbiJSJmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234577AbiJSJkr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C705F035F;
        Wed, 19 Oct 2022 02:17:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E53B61800;
        Wed, 19 Oct 2022 09:16:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56855C433C1;
        Wed, 19 Oct 2022 09:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666171000;
        bh=0fvtEFI43QThxu2xB2MBCAmBh4JcfuNcBuF2dhDcgv4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywmKqZuGivTVQepAN3b+e1fTXAyOEo6M4EGLK+BNsbWacYurRSC1hekOEiwKhxMTI
         noForu5Y4v0goiBtsnIQ0xSrzTGKrBkhfv1M6lfrvUWsIt1EGayXOumbtQe8UqSFrQ
         EB1/1bz3TLTJvIKCRJVwyhOLHEq6hO9VSIIMo+5Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sachin Sant <sachinp@linux.ibm.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 6.0 856/862] powerpc/64s/interrupt: Fix lost interrupts when returning to soft-masked context
Date:   Wed, 19 Oct 2022 10:35:43 +0200
Message-Id: <20221019083327.701054960@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Piggin <npiggin@gmail.com>

commit a4cb3651a174366cc85a677da9e3681fbe97fdae upstream.

It's possible for an interrupt returning to an irqs-disabled context to
lose a pending soft-masked irq because it branches to part of the exit
code for irqs-enabled contexts, which is meant to clear only the
PACA_IRQS_HARD_DIS flag from PACAIRQHAPPENED by zeroing the byte. This
just looks like a simple thinko from a recent commit (if there was no
hard mask pending, there would be no reason to clear it anyway).

This also adds comment to the code that actually does need to clear the
flag.

Fixes: e485f6c751e0a ("powerpc/64/interrupt: Fix return to masked context after hard-mask irq becomes pending")
Reported-by: Sachin Sant <sachinp@linux.ibm.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221013064418.1311104-1-npiggin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/interrupt_64.S |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/interrupt_64.S
+++ b/arch/powerpc/kernel/interrupt_64.S
@@ -571,7 +571,7 @@ _ASM_NOKPROBE_SYMBOL(interrupt_return_\s
 	beq	.Lfast_kernel_interrupt_return_\srr\() // EE already disabled
 	lbz	r11,PACAIRQHAPPENED(r13)
 	andi.	r10,r11,PACA_IRQ_MUST_HARD_MASK
-	beq	1f // No HARD_MASK pending
+	beq	.Lfast_kernel_interrupt_return_\srr\() // No HARD_MASK pending
 
 	/* Must clear MSR_EE from _MSR */
 #ifdef CONFIG_PPC_BOOK3S
@@ -588,12 +588,23 @@ _ASM_NOKPROBE_SYMBOL(interrupt_return_\s
 	b	.Lfast_kernel_interrupt_return_\srr\()
 
 .Linterrupt_return_\srr\()_soft_enabled:
+	/*
+	 * In the soft-enabled case, need to double-check that we have no
+	 * pending interrupts that might have come in before we reached the
+	 * restart section of code, and restart the exit so those can be
+	 * handled.
+	 *
+	 * If there are none, it is be possible that the interrupt still
+	 * has PACA_IRQ_HARD_DIS set, which needs to be cleared for the
+	 * interrupted context. This clear will not clobber a new pending
+	 * interrupt coming in, because we're in the restart section, so
+	 * such would return to the restart location.
+	 */
 #ifdef CONFIG_PPC_BOOK3S
 	lbz	r11,PACAIRQHAPPENED(r13)
 	andi.	r11,r11,(~PACA_IRQ_HARD_DIS)@l
 	bne-	interrupt_return_\srr\()_kernel_restart
 #endif
-1:
 	li	r11,0
 	stb	r11,PACAIRQHAPPENED(r13) // clear the possible HARD_DIS
 


