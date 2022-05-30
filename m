Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82AA05380D2
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 16:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237368AbiE3Nvz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238774AbiE3Nuv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:50:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 207A0AF305;
        Mon, 30 May 2022 06:35:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48707B80DBB;
        Mon, 30 May 2022 13:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0533C385B8;
        Mon, 30 May 2022 13:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917681;
        bh=crdPjxXsbeSThDJ71pyFQjdLwv3x7InzqF9AGJuyQbo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cFCKmaFb+h7VpmWWDh7kfHuq5qT9zTOHeTrMr/+TRYr2LatVKtYpQM1wE8MhlJZT1
         iULn4omZTrdjNCeBD6HSbNTlM4m5dDp7V2ogBvRtdQMu2kcftzLFJs+8YCSOAg/ubU
         Ex3oTq/wGmdW318FxKOm4XOjwNP2wSPzlDcScUEZomoAGeCoh0v9kEEo5ud89CMV8t
         leF0zyz+zSiVyGVNroF2VUFG8E6/M0/BgT6R1h5I2CNThbvpUhAJvylsumBnX7RCz4
         VwY9avuBrD2U37VX7nxpLCyDrQWu7EaEs77KGhYe5vrLJkMIU3MNQ0og+fEjxKvGPK
         aeG3UO5ZdMX1Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Max Filippov <jcmvbkbc@gmail.com>, Sasha Levin <sashal@kernel.org>,
        chris@zankel.net, keescook@chromium.org, ebiederm@xmission.com,
        yang.lee@linux.alibaba.com, linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 5.17 060/135] xtensa: move trace_hardirqs_off call back to entry.S
Date:   Mon, 30 May 2022 09:30:18 -0400
Message-Id: <20220530133133.1931716-60-sashal@kernel.org>
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
index a1029a5b6a1d..ee08238099f4 100644
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

