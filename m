Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCE7D57995B
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237818AbiGSMBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237817AbiGSMBS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:01:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261434A803;
        Tue, 19 Jul 2022 04:58:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98F3EB81B2C;
        Tue, 19 Jul 2022 11:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E66C341C6;
        Tue, 19 Jul 2022 11:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231907;
        bh=p1p6gOChjy5Orh7Wm6A8qEeo5ehxKGLyGDSGixMUTL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x7B0QDazKip98YSbDKhmLA0m2D3WuNUEBWTL+s1Q6MfKf52KEtHDm4t2qO2bgFf+s
         x+rRvzKr9Z7ShPcEzOlNzZxYVHbu+65by+0U2RAGZrAYVJeAU3bmBIoB1aNPCRdYbM
         rNqotlX+WDjzRhmBwrlu4fguiqh1V0pmFgGrWpmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH 4.14 06/43] ARM: 9214/1: alignment: advance IT state after emulating Thumb instruction
Date:   Tue, 19 Jul 2022 13:53:37 +0200
Message-Id: <20220719114522.649656788@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
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


