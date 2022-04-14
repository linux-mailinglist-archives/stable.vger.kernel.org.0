Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7E075011DB
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345805AbiDNNyS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343732AbiDNNn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:43:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EF924951;
        Thu, 14 Apr 2022 06:39:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB5BCB829A3;
        Thu, 14 Apr 2022 13:39:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B8BC385A1;
        Thu, 14 Apr 2022 13:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943579;
        bh=zFT/33gx2QpYPbSY/7LiF+3Gf+gZx34HbhjPo3288vU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0fycYHmxKEGO7vSXZXojet09xcnCwlemQ4LOrF0X8ENpR9QJT2G8WrU4QpshPLXjP
         ZAKyr6tCAN2hOxce0Dr4f4weIsXIhQmvy5nA7mUhXtYvbYLJ7X/rCmF/OGzB1UNQTD
         VCaavw3ItC9ibwLGkcZEJSZsF4ANeX000Zj3bQEQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Paul Burton <paulburton@kernel.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        linux-mips@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 205/475] mips: DEC: honor CONFIG_MIPS_FP_SUPPORT=n
Date:   Thu, 14 Apr 2022 15:09:50 +0200
Message-Id: <20220414110900.865986588@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 97bf0395c226907e1a9b908511a35192bf1e09bb ]

Include the DECstation interrupt handler in opting out of
FPU support.

Fixes a linker error:

mips-linux-ld: arch/mips/dec/int-handler.o: in function `fpu':
(.text+0x148): undefined reference to `handle_fpe_int'

Fixes: 183b40f992c8 ("MIPS: Allow FP support to be disabled")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Maciej W. Rozycki <macro@orcam.me.uk>
Cc: linux-mips@vger.kernel.org
Acked-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/dec/int-handler.S | 6 +++---
 arch/mips/dec/setup.c       | 3 ++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/mips/dec/int-handler.S b/arch/mips/dec/int-handler.S
index a25ef822e725..5ed38e618019 100644
--- a/arch/mips/dec/int-handler.S
+++ b/arch/mips/dec/int-handler.S
@@ -131,7 +131,7 @@
 		 */
 		mfc0	t0,CP0_CAUSE		# get pending interrupts
 		mfc0	t1,CP0_STATUS
-#ifdef CONFIG_32BIT
+#if defined(CONFIG_32BIT) && defined(CONFIG_MIPS_FP_SUPPORT)
 		lw	t2,cpu_fpu_mask
 #endif
 		andi	t0,ST0_IM		# CAUSE.CE may be non-zero!
@@ -139,7 +139,7 @@
 
 		beqz	t0,spurious
 
-#ifdef CONFIG_32BIT
+#if defined(CONFIG_32BIT) && defined(CONFIG_MIPS_FP_SUPPORT)
 		 and	t2,t0
 		bnez	t2,fpu			# handle FPU immediately
 #endif
@@ -280,7 +280,7 @@ handle_it:
 		j	dec_irq_dispatch
 		 nop
 
-#ifdef CONFIG_32BIT
+#if defined(CONFIG_32BIT) && defined(CONFIG_MIPS_FP_SUPPORT)
 fpu:
 		lw	t0,fpu_kstat_irq
 		nop
diff --git a/arch/mips/dec/setup.c b/arch/mips/dec/setup.c
index 1fc8dffa8d1d..649b50ae5b1e 100644
--- a/arch/mips/dec/setup.c
+++ b/arch/mips/dec/setup.c
@@ -766,7 +766,8 @@ void __init arch_init_irq(void)
 		dec_interrupt[DEC_IRQ_HALT] = -1;
 
 	/* Register board interrupts: FPU and cascade. */
-	if (dec_interrupt[DEC_IRQ_FPU] >= 0 && cpu_has_fpu) {
+	if (IS_ENABLED(CONFIG_MIPS_FP_SUPPORT) &&
+	    dec_interrupt[DEC_IRQ_FPU] >= 0 && cpu_has_fpu) {
 		struct irq_desc *desc_fpu;
 		int irq_fpu;
 
-- 
2.34.1



