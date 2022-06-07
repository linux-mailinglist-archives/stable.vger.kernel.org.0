Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF6A541854
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378742AbiFGVJq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:09:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379215AbiFGVJX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:09:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 893BD213E40;
        Tue,  7 Jun 2022 11:51:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A52DB82182;
        Tue,  7 Jun 2022 18:51:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630C3C385A2;
        Tue,  7 Jun 2022 18:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627865;
        bh=agAvA2UlDjU1S+805plgMgA31btECECZRC2FbGPFZ+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=db8ufcIahlPoFEjJGEHd0OOxv7DiNtXbb9nNyB7VUW64t9IIOaTwe0h9Fot9+VuXb
         6YRoBX4N8Lu+Dk7G/ZxIuJTtYEW6wQiH5eqUsXvziavtUpv5/U7/1AafQ9cHIykQ2L
         qy1Z53vR/qP17nPwgN0R2BDi4H1VBrzJtLMYnoDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 122/879] xtensa: move trace_hardirqs_off call back to entry.S
Date:   Tue,  7 Jun 2022 18:54:00 +0200
Message-Id: <20220607165006.242073367@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Max Filippov <jcmvbkbc@gmail.com>

[ Upstream commit de4415d0bac91192ee9c74e849bc61429efa9b42 ]

Context tracking call must be done after hardirq tracking call,
otherwise lockdep_assert_irqs_disabled called from rcu_eqs_exit gives
a warning. To avoid context tracking logic duplication for IRQ/exception
entry paths move trace_hardirqs_off call back to common entry code.

Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/kernel/entry.S | 19 +++++++++++++------
 arch/xtensa/kernel/traps.c | 11 ++---------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/xtensa/kernel/entry.S b/arch/xtensa/kernel/entry.S
index 6b6eff658795..07d683d94e17 100644
--- a/arch/xtensa/kernel/entry.S
+++ b/arch/xtensa/kernel/entry.S
@@ -442,7 +442,6 @@ KABI_W	or	a3, a3, a0
 	moveqz	a3, a0, a2		# a3 = LOCKLEVEL iff interrupt
 KABI_W	movi	a2, PS_WOE_MASK
 KABI_W	or	a3, a3, a2
-	rsr	a2, exccause
 #endif
 
 	/* restore return address (or 0 if return to userspace) */
@@ -469,19 +468,27 @@ KABI_W	or	a3, a3, a2
 
 	save_xtregs_opt a1 a3 a4 a5 a6 a7 PT_XTREGS_OPT
 	
+#ifdef CONFIG_TRACE_IRQFLAGS
+	rsr		abi_tmp0, ps
+	extui		abi_tmp0, abi_tmp0, PS_INTLEVEL_SHIFT, PS_INTLEVEL_WIDTH
+	beqz		abi_tmp0, 1f
+	abi_call	trace_hardirqs_off
+1:
+#endif
+
 	/* Go to second-level dispatcher. Set up parameters to pass to the
 	 * exception handler and call the exception handler.
 	 */
 
-	rsr	a4, excsave1
-	addx4	a4, a2, a4
-	l32i	a4, a4, EXC_TABLE_DEFAULT		# load handler
-	mov	abi_arg1, a2			# pass EXCCAUSE
+	l32i	abi_arg1, a1, PT_EXCCAUSE	# pass EXCCAUSE
+	rsr	abi_tmp0, excsave1
+	addx4	abi_tmp0, abi_arg1, abi_tmp0
+	l32i	abi_tmp0, abi_tmp0, EXC_TABLE_DEFAULT	# load handler
 	mov	abi_arg0, a1			# pass stack frame
 
 	/* Call the second-level handler */
 
-	abi_callx	a4
+	abi_callx	abi_tmp0
 
 	/* Jump here for exception exit */
 	.global common_exception_return
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index 9345007d474d..5f86208c67c8 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -242,12 +242,8 @@ DEFINE_PER_CPU(unsigned long, nmi_count);
 
 void do_nmi(struct pt_regs *regs)
 {
-	struct pt_regs *old_regs;
+	struct pt_regs *old_regs = set_irq_regs(regs);
 
-	if ((regs->ps & PS_INTLEVEL_MASK) < LOCKLEVEL)
-		trace_hardirqs_off();
-
-	old_regs = set_irq_regs(regs);
 	nmi_enter();
 	++*this_cpu_ptr(&nmi_count);
 	check_valid_nmi();
@@ -269,12 +265,9 @@ void do_interrupt(struct pt_regs *regs)
 		XCHAL_INTLEVEL6_MASK,
 		XCHAL_INTLEVEL7_MASK,
 	};
-	struct pt_regs *old_regs;
+	struct pt_regs *old_regs = set_irq_regs(regs);
 	unsigned unhandled = ~0u;
 
-	trace_hardirqs_off();
-
-	old_regs = set_irq_regs(regs);
 	irq_enter();
 
 	for (;;) {
-- 
2.35.1



