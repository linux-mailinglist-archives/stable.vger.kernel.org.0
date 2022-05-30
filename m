Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A86753808F
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231893AbiE3N5U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238454AbiE3NyA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:54:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB16E95484;
        Mon, 30 May 2022 06:37:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 02FFFB80D84;
        Mon, 30 May 2022 13:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D7FC385B8;
        Mon, 30 May 2022 13:37:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917874;
        bh=79A2qcAkQUl80c96RtleITyTMTBFf0WxxTgXW1Nkq6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3xA0Z/inz8z5CbyC8mRzZr15LwMJQPuKoKlyLxbfCxEagzn2VfYGSbLFjTxOpk+I
         vFcJL4P9aPNSRxiPyeMTSNBGsBa3UzE7DoZ8FI7Cqr8W/1xuIS0TjYLbZ5xeYHts2b
         ydHQWUb9sz1g4MGzpbD4kAJADiovnYExOC4FpZv4Nf9K6ksSY8DQhBm0qQ/+/M0djR
         0t0FGg2NfqvAh4NGPE0EMOtNjPXbBKfVdWl4ZqQzbGRv+Efe/JflQ95BCiuUnbqwEH
         Jw99ezz+CONd8MEhsYSaFAsGgFgGbE9UYFf3XlumeUxguSUJy4WvDD6LnrVGj6JeEk
         mkCvFlOUlmq0A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linus.walleij@linaro.org, nico@fluxnic.net, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 125/135] ARM: 9201/1: spectre-bhb: rely on linker to emit cross-section literal loads
Date:   Mon, 30 May 2022 09:31:23 -0400
Message-Id: <20220530133133.1931716-125-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530133133.1931716-1-sashal@kernel.org>
References: <20220530133133.1931716-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit ad12c2f1587c6ec9b52ff226f438955bfae6ad89 ]

The assembler does not permit 'LDR PC, <sym>' when the symbol lives in a
different section, which is why we have been relying on rather fragile
open-coded arithmetic to load the address of the vector_swi routine into
the program counter using a single LDR instruction in the SWI slot in
the vector table. The literal was moved to a different section to in
commit 19accfd373847 ("ARM: move vector stubs") to ensure that the
vector stubs page does not need to be mapped readable for user space,
which is the case for the vector page itself, as it carries the kuser
helpers as well.

So the cross-section literal load is open-coded, and this relies on the
address of vector_swi to be at the very start of the vector stubs page,
and we won't notice if we got it wrong until booting the kernel and see
it break. Fortunately, it was guaranteed to break, so this was fragile
but not problematic.

Now that we have added two other variants of the vector table, we have 3
occurrences of the same trick, and so the size of our ISA/compiler/CPU
validation space has tripled, in a way that may cause regressions to only
be observed once booting the image in question on a CPU that exercises a
particular vector table.

So let's switch to true cross section references, and let the linker fix
them up like it fixes up all the other cross section references in the
vector page.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/entry-armv.S | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 4bbd92d41031..bc536c6fcf2d 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -1071,10 +1071,15 @@ ENDPROC(vector_bhb_bpiall_\name)
 	.endm
 
 	.section .stubs, "ax", %progbits
-	@ This must be the first word
+	@ These need to remain at the start of the section so that
+	@ they are in range of the 'SWI' entries in the vector tables
+	@ located 4k down.
+.L__vector_swi:
 	.word	vector_swi
 #ifdef CONFIG_HARDEN_BRANCH_HISTORY
+.L__vector_bhb_loop8_swi:
 	.word	vector_bhb_loop8_swi
+.L__vector_bhb_bpiall_swi:
 	.word	vector_bhb_bpiall_swi
 #endif
 
@@ -1217,10 +1222,11 @@ vector_addrexcptn:
 	.globl	vector_fiq
 
 	.section .vectors, "ax", %progbits
-.L__vectors_start:
 	W(b)	vector_rst
 	W(b)	vector_und
-	W(ldr)	pc, .L__vectors_start + 0x1000
+ARM(	.reloc	., R_ARM_LDR_PC_G0, .L__vector_swi		)
+THUMB(	.reloc	., R_ARM_THM_PC12, .L__vector_swi		)
+	W(ldr)	pc, .
 	W(b)	vector_pabt
 	W(b)	vector_dabt
 	W(b)	vector_addrexcptn
@@ -1229,10 +1235,11 @@ vector_addrexcptn:
 
 #ifdef CONFIG_HARDEN_BRANCH_HISTORY
 	.section .vectors.bhb.loop8, "ax", %progbits
-.L__vectors_bhb_loop8_start:
 	W(b)	vector_rst
 	W(b)	vector_bhb_loop8_und
-	W(ldr)	pc, .L__vectors_bhb_loop8_start + 0x1004
+ARM(	.reloc	., R_ARM_LDR_PC_G0, .L__vector_bhb_loop8_swi	)
+THUMB(	.reloc	., R_ARM_THM_PC12, .L__vector_bhb_loop8_swi	)
+	W(ldr)	pc, .
 	W(b)	vector_bhb_loop8_pabt
 	W(b)	vector_bhb_loop8_dabt
 	W(b)	vector_addrexcptn
@@ -1240,10 +1247,11 @@ vector_addrexcptn:
 	W(b)	vector_bhb_loop8_fiq
 
 	.section .vectors.bhb.bpiall, "ax", %progbits
-.L__vectors_bhb_bpiall_start:
 	W(b)	vector_rst
 	W(b)	vector_bhb_bpiall_und
-	W(ldr)	pc, .L__vectors_bhb_bpiall_start + 0x1008
+ARM(	.reloc	., R_ARM_LDR_PC_G0, .L__vector_bhb_bpiall_swi	)
+THUMB(	.reloc	., R_ARM_THM_PC12, .L__vector_bhb_bpiall_swi	)
+	W(ldr)	pc, .
 	W(b)	vector_bhb_bpiall_pabt
 	W(b)	vector_bhb_bpiall_dabt
 	W(b)	vector_addrexcptn
-- 
2.35.1

