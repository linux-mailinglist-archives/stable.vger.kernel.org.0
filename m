Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B075579987
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:04:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238044AbiGSMED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237884AbiGSMDU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:03:20 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB7647B96;
        Tue, 19 Jul 2022 04:59:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8313FCE1BE2;
        Tue, 19 Jul 2022 11:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99E31C341CB;
        Tue, 19 Jul 2022 11:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231970;
        bh=p1p6gOChjy5Orh7Wm6A8qEeo5ehxKGLyGDSGixMUTL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DXVECN29S6tWj+0ov+GF0c/bJI8UeOWDmIVj9/K9oGpLrDJCBckqCPC/3RIEfzXCN
         XTgmAXuNaUEoM94m4yqfemUAqs2snx4h0eUOYlLPfsXBBrvrUyJnFcKoBL98AdiEzM
         zjCaN/DpzaJ5UmbpYoukRuH4bWFgqghGyeOdAFTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.19 08/48] ARM: 9214/1: alignment: advance IT state after emulating Thumb instruction
Date:   Tue, 19 Jul 2022 13:53:45 +0200
Message-Id: <20220719114520.681348458@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114518.915546280@linuxfoundation.org>
References: <20220719114518.915546280@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

commit e5c46fde75e43c15a29b40e5fc5641727f97ae47 upstream.

After emulating a misaligned load or store issued in Thumb mode, we have
to advance the IT state by hand, or it will get out of sync with the
actual instruction stream, which means we'll end up applying the wrong
condition code to subsequent instructions. This might corrupt the
program state rather catastrophically.

So borrow the it_advance() helper from the probing code, and use it on
CPSR if the emulated instruction is Thumb.

Cc: <stable@vger.kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/include/asm/ptrace.h |   26 ++++++++++++++++++++++++++
 arch/arm/mm/alignment.c       |    3 +++
 arch/arm/probes/decode.h      |   26 +-------------------------
 3 files changed, 30 insertions(+), 25 deletions(-)

--- a/arch/arm/include/asm/ptrace.h
+++ b/arch/arm/include/asm/ptrace.h
@@ -167,5 +167,31 @@ static inline unsigned long user_stack_p
 		((current_stack_pointer | (THREAD_SIZE - 1)) - 7) - 1;	\
 })
 
+
+/*
+ * Update ITSTATE after normal execution of an IT block instruction.
+ *
+ * The 8 IT state bits are split into two parts in CPSR:
+ *	ITSTATE<1:0> are in CPSR<26:25>
+ *	ITSTATE<7:2> are in CPSR<15:10>
+ */
+static inline unsigned long it_advance(unsigned long cpsr)
+{
+	if ((cpsr & 0x06000400) == 0) {
+		/* ITSTATE<2:0> == 0 means end of IT block, so clear IT state */
+		cpsr &= ~PSR_IT_MASK;
+	} else {
+		/* We need to shift left ITSTATE<4:0> */
+		const unsigned long mask = 0x06001c00;  /* Mask ITSTATE<4:0> */
+		unsigned long it = cpsr & mask;
+		it <<= 1;
+		it |= it >> (27 - 10);  /* Carry ITSTATE<2> to correct place */
+		it &= mask;
+		cpsr &= ~mask;
+		cpsr |= it;
+	}
+	return cpsr;
+}
+
 #endif /* __ASSEMBLY__ */
 #endif
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -936,6 +936,9 @@ do_alignment(unsigned long addr, unsigne
 	if (type == TYPE_LDST)
 		do_alignment_finish_ldst(addr, instr, regs, offset);
 
+	if (thumb_mode(regs))
+		regs->ARM_cpsr = it_advance(regs->ARM_cpsr);
+
 	return 0;
 
  bad_or_fault:
--- a/arch/arm/probes/decode.h
+++ b/arch/arm/probes/decode.h
@@ -22,6 +22,7 @@
 #include <linux/types.h>
 #include <linux/stddef.h>
 #include <asm/probes.h>
+#include <asm/ptrace.h>
 #include <asm/kprobes.h>
 
 void __init arm_probes_decode_init(void);
@@ -43,31 +44,6 @@ void __init find_str_pc_offset(void);
 #endif
 
 
-/*
- * Update ITSTATE after normal execution of an IT block instruction.
- *
- * The 8 IT state bits are split into two parts in CPSR:
- *	ITSTATE<1:0> are in CPSR<26:25>
- *	ITSTATE<7:2> are in CPSR<15:10>
- */
-static inline unsigned long it_advance(unsigned long cpsr)
-	{
-	if ((cpsr & 0x06000400) == 0) {
-		/* ITSTATE<2:0> == 0 means end of IT block, so clear IT state */
-		cpsr &= ~PSR_IT_MASK;
-	} else {
-		/* We need to shift left ITSTATE<4:0> */
-		const unsigned long mask = 0x06001c00;  /* Mask ITSTATE<4:0> */
-		unsigned long it = cpsr & mask;
-		it <<= 1;
-		it |= it >> (27 - 10);  /* Carry ITSTATE<2> to correct place */
-		it &= mask;
-		cpsr &= ~mask;
-		cpsr |= it;
-	}
-	return cpsr;
-}
-
 static inline void __kprobes bx_write_pc(long pcv, struct pt_regs *regs)
 {
 	long cpsr = regs->ARM_cpsr;


