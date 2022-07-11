Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AD8256FDA7
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231812AbiGKJ6q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbiGKJ6U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:58:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8B13C148;
        Mon, 11 Jul 2022 02:27:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0191BB80D2C;
        Mon, 11 Jul 2022 09:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FC5C34115;
        Mon, 11 Jul 2022 09:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531620;
        bh=W3FkDVsaLvy6NEH/0/OxivKco67wNMOeiRL3HtMFaUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sBB6Xs4idaGIfu3TQK/PAwZH/8r+Geh6uG9IG8z31IqeXLjp7ycy4MCT7hhg7u30F
         4VL1iSgpYO8caBf8mzGFMbBCr6VIFcC/NC5FqsyD0UYKzzA+ZDhG+IjgL2BfabMu09
         R+weYhwGChflVWwMjAYKq0Pg3pKCAZCzKJ/CIJ0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 134/230] powerpc/vdso: Move cvdso_call macro into gettimeofday.S
Date:   Mon, 11 Jul 2022 11:06:30 +0200
Message-Id: <20220711090607.865563405@linuxfoundation.org>
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

[ Upstream commit 692b21d78046851e75dc25bba773189c670b49c2 ]

Now that gettimeofday.S is unique, move cvdso_call macro
into that file which is the only user.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/72720359d4c58e3a3b96dd74952741225faac3de.1642782130.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/vdso/gettimeofday.h | 52 +-------------------
 arch/powerpc/kernel/vdso32/gettimeofday.S    | 44 ++++++++++++++++-
 2 files changed, 45 insertions(+), 51 deletions(-)

diff --git a/arch/powerpc/include/asm/vdso/gettimeofday.h b/arch/powerpc/include/asm/vdso/gettimeofday.h
index df00e91c9a90..f0a4cf01e85c 100644
--- a/arch/powerpc/include/asm/vdso/gettimeofday.h
+++ b/arch/powerpc/include/asm/vdso/gettimeofday.h
@@ -2,57 +2,9 @@
 #ifndef _ASM_POWERPC_VDSO_GETTIMEOFDAY_H
 #define _ASM_POWERPC_VDSO_GETTIMEOFDAY_H
 
-#include <asm/page.h>
-
-#ifdef __ASSEMBLY__
-
-#include <asm/ppc_asm.h>
-
-/*
- * The macro sets two stack frames, one for the caller and one for the callee
- * because there are no requirement for the caller to set a stack frame when
- * calling VDSO so it may have omitted to set one, especially on PPC64
- */
-
-.macro cvdso_call funct call_time=0
-  .cfi_startproc
-	PPC_STLU	r1, -PPC_MIN_STKFRM(r1)
-	mflr		r0
-  .cfi_register lr, r0
-	PPC_STLU	r1, -PPC_MIN_STKFRM(r1)
-	PPC_STL		r0, PPC_MIN_STKFRM + PPC_LR_STKOFF(r1)
-#ifdef __powerpc64__
-	PPC_STL		r2, PPC_MIN_STKFRM + STK_GOT(r1)
-#endif
-	get_datapage	r5
-	.ifeq	\call_time
-	addi		r5, r5, VDSO_DATA_OFFSET
-	.else
-	addi		r4, r5, VDSO_DATA_OFFSET
-	.endif
-	bl		DOTSYM(\funct)
-	PPC_LL		r0, PPC_MIN_STKFRM + PPC_LR_STKOFF(r1)
-#ifdef __powerpc64__
-	PPC_LL		r2, PPC_MIN_STKFRM + STK_GOT(r1)
-#endif
-	.ifeq	\call_time
-	cmpwi		r3, 0
-	.endif
-	mtlr		r0
-  .cfi_restore lr
-	addi		r1, r1, 2 * PPC_MIN_STKFRM
-	crclr		so
-	.ifeq	\call_time
-	beqlr+
-	crset		so
-	neg		r3, r3
-	.endif
-	blr
-  .cfi_endproc
-.endm
-
-#else
+#ifndef __ASSEMBLY__
 
+#include <asm/page.h>
 #include <asm/vdso/timebase.h>
 #include <asm/barrier.h>
 #include <asm/unistd.h>
diff --git a/arch/powerpc/kernel/vdso32/gettimeofday.S b/arch/powerpc/kernel/vdso32/gettimeofday.S
index 9b3ac09423c8..dd2099128b8f 100644
--- a/arch/powerpc/kernel/vdso32/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso32/gettimeofday.S
@@ -12,7 +12,49 @@
 #include <asm/vdso_datapage.h>
 #include <asm/asm-offsets.h>
 #include <asm/unistd.h>
-#include <asm/vdso/gettimeofday.h>
+
+/*
+ * The macro sets two stack frames, one for the caller and one for the callee
+ * because there are no requirement for the caller to set a stack frame when
+ * calling VDSO so it may have omitted to set one, especially on PPC64
+ */
+
+.macro cvdso_call funct call_time=0
+  .cfi_startproc
+	PPC_STLU	r1, -PPC_MIN_STKFRM(r1)
+	mflr		r0
+  .cfi_register lr, r0
+	PPC_STLU	r1, -PPC_MIN_STKFRM(r1)
+	PPC_STL		r0, PPC_MIN_STKFRM + PPC_LR_STKOFF(r1)
+#ifdef __powerpc64__
+	PPC_STL		r2, PPC_MIN_STKFRM + STK_GOT(r1)
+#endif
+	get_datapage	r5
+	.ifeq	\call_time
+	addi		r5, r5, VDSO_DATA_OFFSET
+	.else
+	addi		r4, r5, VDSO_DATA_OFFSET
+	.endif
+	bl		DOTSYM(\funct)
+	PPC_LL		r0, PPC_MIN_STKFRM + PPC_LR_STKOFF(r1)
+#ifdef __powerpc64__
+	PPC_LL		r2, PPC_MIN_STKFRM + STK_GOT(r1)
+#endif
+	.ifeq	\call_time
+	cmpwi		r3, 0
+	.endif
+	mtlr		r0
+  .cfi_restore lr
+	addi		r1, r1, 2 * PPC_MIN_STKFRM
+	crclr		so
+	.ifeq	\call_time
+	beqlr+
+	crset		so
+	neg		r3, r3
+	.endif
+	blr
+  .cfi_endproc
+.endm
 
 	.text
 /*
-- 
2.35.1



