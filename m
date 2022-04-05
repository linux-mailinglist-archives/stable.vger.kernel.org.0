Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C49CE4F2DB1
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbiDEIkH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:40:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235437AbiDEI0p (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:26:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780F313DF6;
        Tue,  5 Apr 2022 01:20:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18827B81BB0;
        Tue,  5 Apr 2022 08:20:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599A1C385A0;
        Tue,  5 Apr 2022 08:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146852;
        bh=IrqnNTvRac6zDFBz8lPZ519erod6BwbMDCIQfnHanu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QIGdtioAUFito48c1L/nGNgSO18fk5MAQpUx/jPNw+URyx1HWnP0g3dE1LCgpkR9V
         P4pFG0cEbNUvBiYTpUdffi6yTMsiFA2gE+n3j7lQBOonTiFKeKZK7RCQdsqD2UkAyy
         pu6AB0kk6DOokz4gw3gG3FoO3CBBEkQukFzctky0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0911/1126] ARM: ftrace: avoid redundant loads or clobbering IP
Date:   Tue,  5 Apr 2022 09:27:38 +0200
Message-Id: <20220405070434.265203776@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
index f4886fb6e9ba..f33c171e3090 100644
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



