Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A320A56FD7E
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234039AbiGKJ4Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbiGKJzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:55:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D39CB23E2;
        Mon, 11 Jul 2022 02:26:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E175461370;
        Mon, 11 Jul 2022 09:26:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA600C34115;
        Mon, 11 Jul 2022 09:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531590;
        bh=3cODyiIArg5qEo2VckCG8XY4zG4teTgxZicxoXR9kYM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HZR0fA5ZEFcSxAdKtdcIDj/712wnutLrupwlaF8+utqVc5AP3+GlkrHrOBM9DmGxc
         0zoCEYUcqeWU2ruYmViVM3p54pXuNJfUAbKcyj4MXfUwO7e6PHha7O3LDtf87wFvit
         XYVxekuobYFy3GpO5ECtSuINVmE+jA58rNLMjSdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 133/230] powerpc/vdso: Remove cvdso_call_time macro
Date:   Mon, 11 Jul 2022 11:06:29 +0200
Message-Id: <20220711090607.837197961@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 9b97bea90072a075363a200dd7b54ad4a24e9491 ]

cvdso_call_time macro is very similar to cvdso_call macro.

Add a call_time argument to cvdso_call which is 0 by default
and set to 1 when using cvdso_call to call __c_kernel_time().

Return returned value as is with CR[SO] cleared when it is used
for time().

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/837a260ad86fc1ce297a562c2117fd69be5f7b5c.1642782130.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/vdso/gettimeofday.h | 37 ++++++--------------
 arch/powerpc/kernel/vdso32/gettimeofday.S    |  2 +-
 2 files changed, 11 insertions(+), 28 deletions(-)

diff --git a/arch/powerpc/include/asm/vdso/gettimeofday.h b/arch/powerpc/include/asm/vdso/gettimeofday.h
index 1faff0be1111..df00e91c9a90 100644
--- a/arch/powerpc/include/asm/vdso/gettimeofday.h
+++ b/arch/powerpc/include/asm/vdso/gettimeofday.h
@@ -9,12 +9,12 @@
 #include <asm/ppc_asm.h>
 
 /*
- * The macros sets two stack frames, one for the caller and one for the callee
+ * The macro sets two stack frames, one for the caller and one for the callee
  * because there are no requirement for the caller to set a stack frame when
  * calling VDSO so it may have omitted to set one, especially on PPC64
  */
 
-.macro cvdso_call funct
+.macro cvdso_call funct call_time=0
   .cfi_startproc
 	PPC_STLU	r1, -PPC_MIN_STKFRM(r1)
 	mflr		r0
@@ -25,45 +25,28 @@
 	PPC_STL		r2, PPC_MIN_STKFRM + STK_GOT(r1)
 #endif
 	get_datapage	r5
+	.ifeq	\call_time
 	addi		r5, r5, VDSO_DATA_OFFSET
+	.else
+	addi		r4, r5, VDSO_DATA_OFFSET
+	.endif
 	bl		DOTSYM(\funct)
 	PPC_LL		r0, PPC_MIN_STKFRM + PPC_LR_STKOFF(r1)
 #ifdef __powerpc64__
 	PPC_LL		r2, PPC_MIN_STKFRM + STK_GOT(r1)
 #endif
+	.ifeq	\call_time
 	cmpwi		r3, 0
+	.endif
 	mtlr		r0
   .cfi_restore lr
 	addi		r1, r1, 2 * PPC_MIN_STKFRM
 	crclr		so
+	.ifeq	\call_time
 	beqlr+
 	crset		so
 	neg		r3, r3
-	blr
-  .cfi_endproc
-.endm
-
-.macro cvdso_call_time funct
-  .cfi_startproc
-	PPC_STLU	r1, -PPC_MIN_STKFRM(r1)
-	mflr		r0
-  .cfi_register lr, r0
-	PPC_STLU	r1, -PPC_MIN_STKFRM(r1)
-	PPC_STL		r0, PPC_MIN_STKFRM + PPC_LR_STKOFF(r1)
-#ifdef __powerpc64__
-	PPC_STL		r2, PPC_MIN_STKFRM + STK_GOT(r1)
-#endif
-	get_datapage	r4
-	addi		r4, r4, VDSO_DATA_OFFSET
-	bl		DOTSYM(\funct)
-	PPC_LL		r0, PPC_MIN_STKFRM + PPC_LR_STKOFF(r1)
-#ifdef __powerpc64__
-	PPC_LL		r2, PPC_MIN_STKFRM + STK_GOT(r1)
-#endif
-	crclr		so
-	mtlr		r0
-  .cfi_restore lr
-	addi		r1, r1, 2 * PPC_MIN_STKFRM
+	.endif
 	blr
   .cfi_endproc
 .endm
diff --git a/arch/powerpc/kernel/vdso32/gettimeofday.S b/arch/powerpc/kernel/vdso32/gettimeofday.S
index d21d08140a5e..9b3ac09423c8 100644
--- a/arch/powerpc/kernel/vdso32/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso32/gettimeofday.S
@@ -63,7 +63,7 @@ V_FUNCTION_END(__kernel_clock_getres)
  *
  */
 V_FUNCTION_BEGIN(__kernel_time)
-	cvdso_call_time __c_kernel_time
+	cvdso_call __c_kernel_time call_time=1
 V_FUNCTION_END(__kernel_time)
 
 /* Routines for restoring integer registers, called by the compiler.  */
-- 
2.35.1



