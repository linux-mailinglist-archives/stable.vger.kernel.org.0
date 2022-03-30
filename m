Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7C94EC066
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 13:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343886AbiC3LuY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 07:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343967AbiC3Ltr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 07:49:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 151D226B38E;
        Wed, 30 Mar 2022 04:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C141DB81C35;
        Wed, 30 Mar 2022 11:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC55BC34111;
        Wed, 30 Mar 2022 11:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648640843;
        bh=Ka5jbGX8/lg8MhfDu2So8lLl4xM7sYE+I8cl5BMDAWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rbd6BMta/ceTnKSgPxaKSQbC0mzdIOWHQ2DgS2lU9Wdpwu7t5ybKfbX4GhIUO8UI1
         qE1pBPkfnPankr4d7rVhVGiybyM5rMRO+epTYVQByhPgabtP6njl7idIrncVComMri
         IeFEiTAkRiSXClbmJahJVmFqO/Fv9ntqJhO2yuvOTSsnTAmbWHxIzC3tAztaGWCnUL
         6bgv9+a9JocTxIDhRHzwIzQfREr96Zt7vaNVvkZK9IKUW0WjFA+3hZmTUsSmeV8Ld2
         tfY2BXxcT8t9UC6U5KeJ27uyCwi54YqvSgmvq2uq6FNHvdTSIaSkeK1zXL7XSm+nl6
         0ZB0ZNeoqoaww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.17 23/66] ARM: ftrace: avoid redundant loads or clobbering IP
Date:   Wed, 30 Mar 2022 07:46:02 -0400
Message-Id: <20220330114646.1669334-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220330114646.1669334-1-sashal@kernel.org>
References: <20220330114646.1669334-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

[ Upstream commit d11967870815b5ab89843980e35aab616c97c463 ]

Tweak the ftrace return paths to avoid redundant loads of SP, as well as
unnecessary clobbering of IP.

This also fixes the inconsistency of using MOV to perform a function
return, which is sub-optimal on recent micro-architectures but more
importantly, does not perform an interworking return, unlike compiler
generated function returns in Thumb2 builds.

Let's fix this by popping PC from the stack like most ordinary code
does.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/entry-ftrace.S | 51 +++++++++++++++-------------------
 1 file changed, 22 insertions(+), 29 deletions(-)

diff --git a/arch/arm/kernel/entry-ftrace.S b/arch/arm/kernel/entry-ftrace.S
index a74289ebc803..5f1b1ce10473 100644
--- a/arch/arm/kernel/entry-ftrace.S
+++ b/arch/arm/kernel/entry-ftrace.S
@@ -22,10 +22,7 @@
  * mcount can be thought of as a function called in the middle of a subroutine
  * call.  As such, it needs to be transparent for both the caller and the
  * callee: the original lr needs to be restored when leaving mcount, and no
- * registers should be clobbered.  (In the __gnu_mcount_nc implementation, we
- * clobber the ip register.  This is OK because the ARM calling convention
- * allows it to be clobbered in subroutines and doesn't use it to hold
- * parameters.)
+ * registers should be clobbered.
  *
  * When using dynamic ftrace, we patch out the mcount call by a "pop {lr}"
  * instead of the __gnu_mcount_nc call (see arch/arm/kernel/ftrace.c).
@@ -70,26 +67,25 @@
 
 .macro __ftrace_regs_caller
 
-	sub	sp, sp, #8	@ space for PC and CPSR OLD_R0,
+	str	lr, [sp, #-8]!	@ store LR as PC and make space for CPSR/OLD_R0,
 				@ OLD_R0 will overwrite previous LR
 
-	add 	ip, sp, #12	@ move in IP the value of SP as it was
-				@ before the push {lr} of the mcount mechanism
+	ldr	lr, [sp, #8]    @ get previous LR
 
-	str     lr, [sp, #0]    @ store LR instead of PC
+	str	r0, [sp, #8]	@ write r0 as OLD_R0 over previous LR
 
-	ldr     lr, [sp, #8]    @ get previous LR
+	str	lr, [sp, #-4]!	@ store previous LR as LR
 
-	str	r0, [sp, #8]	@ write r0 as OLD_R0 over previous LR
+	add 	lr, sp, #16	@ move in LR the value of SP as it was
+				@ before the push {lr} of the mcount mechanism
 
-	stmdb   sp!, {ip, lr}
-	stmdb   sp!, {r0-r11, lr}
+	push	{r0-r11, ip, lr}
 
 	@ stack content at this point:
 	@ 0  4          48   52       56            60   64    68       72
-	@ R0 | R1 | ... | LR | SP + 4 | previous LR | LR | PSR | OLD_R0 |
+	@ R0 | R1 | ... | IP | SP + 4 | previous LR | LR | PSR | OLD_R0 |
 
-	mov r3, sp				@ struct pt_regs*
+	mov	r3, sp				@ struct pt_regs*
 
 	ldr r2, =function_trace_op
 	ldr r2, [r2]				@ pointer to the current
@@ -112,11 +108,9 @@ ftrace_graph_regs_call:
 #endif
 
 	@ pop saved regs
-	ldmia   sp!, {r0-r12}			@ restore r0 through r12
-	ldr	ip, [sp, #8]			@ restore PC
-	ldr	lr, [sp, #4]			@ restore LR
-	ldr	sp, [sp, #0]			@ restore SP
-	mov	pc, ip				@ return
+	pop	{r0-r11, ip, lr}		@ restore r0 through r12
+	ldr	lr, [sp], #4			@ restore LR
+	ldr	pc, [sp], #12
 .endm
 
 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
@@ -132,11 +126,9 @@ ftrace_graph_regs_call:
 	bl	prepare_ftrace_return
 
 	@ pop registers saved in ftrace_regs_caller
-	ldmia   sp!, {r0-r12}			@ restore r0 through r12
-	ldr	ip, [sp, #8]			@ restore PC
-	ldr	lr, [sp, #4]			@ restore LR
-	ldr	sp, [sp, #0]			@ restore SP
-	mov	pc, ip				@ return
+	pop	{r0-r11, ip, lr}		@ restore r0 through r12
+	ldr	lr, [sp], #4			@ restore LR
+	ldr	pc, [sp], #12
 
 .endm
 #endif
@@ -202,16 +194,17 @@ ftrace_graph_call\suffix:
 .endm
 
 .macro mcount_exit
-	ldmia	sp!, {r0-r3, ip, lr}
-	ret	ip
+	ldmia	sp!, {r0-r3}
+	ldr	lr, [sp, #4]
+	ldr	pc, [sp], #8
 .endm
 
 ENTRY(__gnu_mcount_nc)
 UNWIND(.fnstart)
 #ifdef CONFIG_DYNAMIC_FTRACE
-	mov	ip, lr
-	ldmia	sp!, {lr}
-	ret	ip
+	push	{lr}
+	ldr	lr, [sp, #4]
+	ldr	pc, [sp], #8
 #else
 	__mcount
 #endif
-- 
2.34.1

