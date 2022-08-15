Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E7E593B93
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244194AbiHOTxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345407AbiHOTwt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:52:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFA674DC9;
        Mon, 15 Aug 2022 11:50:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B4607611F9;
        Mon, 15 Aug 2022 18:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB479C433D6;
        Mon, 15 Aug 2022 18:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589452;
        bh=Usk5Rcc72gd/aV45Alw/CxdbW2k19I0U8Vws3hmYVRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GHg+S9856e0n590uaYgk3nd3c7pGqfaNH7b+jNCUDu4jSjOfbToaDXlMKOL09uto0
         w8Pl0XHS8HzsK6d2JPZbDd6Y+GaTNHXw/WbSdUH9Qc6Ce4kwoJbDtARWVoE97d3AGG
         7j3RQ6PUDA3GZD7a0ST3tJ9T3UmuDCcnxdpT1QPU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Keith Packard <keithpac@amazon.com>,
        Marc Zyngier <maz@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH 5.15 722/779] ARM: remove some dead code
Date:   Mon, 15 Aug 2022 20:06:06 +0200
Message-Id: <20220815180408.330932233@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ard Biesheuvel <ardb@kernel.org>

[ Upstream commit 08572cd41955166e387d9b4984294d37f8f7526c ]

This code appears to be no longer used so let's get rid of it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Tested-by: Keith Packard <keithpac@amazon.com>
Tested-by: Marc Zyngier <maz@kernel.org>
Tested-by: Vladimir Murzin <vladimir.murzin@arm.com> # ARMv7M
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/include/asm/entry-macro-multi.S | 24 ------------------------
 arch/arm/include/asm/smp.h               |  5 -----
 arch/arm/kernel/smp.c                    |  5 -----
 3 files changed, 34 deletions(-)

diff --git a/arch/arm/include/asm/entry-macro-multi.S b/arch/arm/include/asm/entry-macro-multi.S
index dfc6bfa43012..24486dad9e19 100644
--- a/arch/arm/include/asm/entry-macro-multi.S
+++ b/arch/arm/include/asm/entry-macro-multi.S
@@ -13,28 +13,4 @@
 	@
 	badrne	lr, 1b
 	bne	asm_do_IRQ
-
-#ifdef CONFIG_SMP
-	/*
-	 * XXX
-	 *
-	 * this macro assumes that irqstat (r2) and base (r6) are
-	 * preserved from get_irqnr_and_base above
-	 */
-	ALT_SMP(test_for_ipi r0, r2, r6, lr)
-	ALT_UP_B(9997f)
-	movne	r1, sp
-	badrne	lr, 1b
-	bne	do_IPI
-#endif
-9997:
-	.endm
-
-	.macro	arch_irq_handler, symbol_name
-	.align	5
-	.global \symbol_name
-\symbol_name:
-	mov	r8, lr
-	arch_irq_handler_default
-	ret	r8
 	.endm
diff --git a/arch/arm/include/asm/smp.h b/arch/arm/include/asm/smp.h
index 5d508f5d56c4..fc11ddf13b8f 100644
--- a/arch/arm/include/asm/smp.h
+++ b/arch/arm/include/asm/smp.h
@@ -24,11 +24,6 @@ struct seq_file;
  */
 extern void show_ipi_list(struct seq_file *, int);
 
-/*
- * Called from assembly code, this handles an IPI.
- */
-asmlinkage void do_IPI(int ipinr, struct pt_regs *regs);
-
 /*
  * Called from C code, this handles an IPI.
  */
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 842427ff2b3c..23d369ab7e03 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -622,11 +622,6 @@ static void ipi_complete(unsigned int cpu)
 /*
  * Main handler for inter-processor interrupts
  */
-asmlinkage void __exception_irq_entry do_IPI(int ipinr, struct pt_regs *regs)
-{
-	handle_IPI(ipinr, regs);
-}
-
 static void do_handle_IPI(int ipinr)
 {
 	unsigned int cpu = smp_processor_id();
-- 
2.35.1



