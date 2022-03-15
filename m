Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 247C24DA24E
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 19:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351021AbiCOSZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 14:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351031AbiCOSZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 14:25:55 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DC7A528E3E
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 11:24:40 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A856E1476;
        Tue, 15 Mar 2022 11:24:40 -0700 (PDT)
Received: from eglon.cambridge.arm.com (eglon.cambridge.arm.com [10.1.196.218])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08A903F73D;
        Tue, 15 Mar 2022 11:24:39 -0700 (PDT)
From:   James Morse <james.morse@arm.com>
To:     stable@vger.kernel.org
Cc:     catalin.marinas@arm.com, linux-arm-kernel@lists.infradead.org,
        james.morse@arm.com
Subject: [stable:PATCH v5.4.184 09/22] arm64: entry: Allow tramp_alias to access symbols after the 4K boundary
Date:   Tue, 15 Mar 2022 18:24:02 +0000
Message-Id: <20220315182415.3900464-10-james.morse@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220315182415.3900464-1-james.morse@arm.com>
References: <20220315182415.3900464-1-james.morse@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 6c5bf79b69f911560fbf82214c0971af6e58e682 upstream.

Systems using kpti enter and exit the kernel through a trampoline mapping
that is always mapped, even when the kernel is not. tramp_valias is a macro
to find the address of a symbol in the trampoline mapping.

Adding extra sets of vectors will expand the size of the entry.tramp.text
section to beyond 4K. tramp_valias will be unable to generate addresses
for symbols beyond 4K as it uses the 12 bit immediate of the add
instruction.

As there are now two registers available when tramp_alias is called,
use the extra register to avoid the 4K limit of the 12 bit immediate.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: James Morse <james.morse@arm.com>
---
 arch/arm64/kernel/entry.S | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index 7822ecc0e165..3489edd57c51 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -124,9 +124,12 @@
 .org .Lventry_start\@ + 128	// Did we overflow the ventry slot?
 	.endm
 
-	.macro tramp_alias, dst, sym
+	.macro tramp_alias, dst, sym, tmp
 	mov_q	\dst, TRAMP_VALIAS
-	add	\dst, \dst, #(\sym - .entry.tramp.text)
+	adr_l	\tmp, \sym
+	add	\dst, \dst, \tmp
+	adr_l	\tmp, .entry.tramp.text
+	sub	\dst, \dst, \tmp
 	.endm
 
 	// This macro corrupts x0-x3. It is the caller's duty
@@ -377,10 +380,10 @@ alternative_else_nop_endif
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 	bne	5f
 	msr	far_el1, x29
-	tramp_alias	x30, tramp_exit_native
+	tramp_alias	x30, tramp_exit_native, x29
 	br	x30
 5:
-	tramp_alias	x30, tramp_exit_compat
+	tramp_alias	x30, tramp_exit_compat, x29
 	br	x30
 #endif
 	.else
@@ -1362,7 +1365,7 @@ alternative_if_not ARM64_UNMAP_KERNEL_AT_EL0
 alternative_else_nop_endif
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
-	tramp_alias	dst=x5, sym=__sdei_asm_exit_trampoline
+	tramp_alias	dst=x5, sym=__sdei_asm_exit_trampoline, tmp=x3
 	br	x5
 #endif
 ENDPROC(__sdei_asm_handler)
-- 
2.30.2

