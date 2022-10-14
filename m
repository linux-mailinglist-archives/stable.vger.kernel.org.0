Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2B5B5FEF45
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 15:55:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbiJNNzc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 09:55:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbiJNNyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 09:54:44 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 291921D29A3;
        Fri, 14 Oct 2022 06:53:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B4000CE2664;
        Fri, 14 Oct 2022 13:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E399C433C1;
        Fri, 14 Oct 2022 13:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665755624;
        bh=PjTGjIw9g/rYXpbwtH5HKmN4zxiGGlcpMqI4typSS6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B8fECZ/4PKn44UHjv9UMnZ5WbmFK/1Rm3XHD3cK96SbOzan6xRyX8ai1RCfw+XjxL
         yl9d+IdtHvnnHRzHEp6zX3xJ+BVVxTEzLiql2EbaNqOavk3E4zPDP5KYbxJxUoQO0n
         IA1aQFk64QpAuexJv7ltTnwfL5bU7gu8pZxlfCOX/t/kYTFwwe9TB6AtlHOxA3/vYI
         2SlIecSwJRKIeMLzGTrFXdh4e6psazo1+rPNZPEqI69sEEiYhvX6MKJ32cuhgRtct8
         g7JrHv4sUZc9O6zdlLkeZ1G83EBuZMhqEKfSPcrLxpsP/uE8IRI7BZjrXOtydNsQr4
         2o8oOzo91kIBA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nathan Chancellor <nathan@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.10 2/7] powerpc/math-emu: Remove -w build flag and fix warnings
Date:   Fri, 14 Oct 2022 09:53:28 -0400
Message-Id: <20221014135334.2109814-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221014135334.2109814-1-sashal@kernel.org>
References: <20221014135334.2109814-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 7245fc5bb7a966852d5bd7779d1f5855530b461a ]

As reported by Nathan, the module_init() macro was not taken into
account because the header was missing. That means spe_mathemu_init()
was never called.

This should have been detected by gcc at build time, but due to
'-w' flag it went undetected.

Removing that flag leads to many warnings hence errors.

Fix those warnings then remove the -w flag.

Reported-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/2663961738a46073713786d4efeb53100ca156e7.1662134272.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/math-emu/Makefile   |  2 --
 arch/powerpc/math-emu/math.c     | 18 +++++-----
 arch/powerpc/math-emu/math_efp.c | 57 +++++++++++++++++---------------
 include/math-emu/op-common.h     |  3 ++
 4 files changed, 42 insertions(+), 38 deletions(-)

diff --git a/arch/powerpc/math-emu/Makefile b/arch/powerpc/math-emu/Makefile
index a8794032f15f..26fef2e5672e 100644
--- a/arch/powerpc/math-emu/Makefile
+++ b/arch/powerpc/math-emu/Makefile
@@ -16,5 +16,3 @@ obj-$(CONFIG_SPE)		+= math_efp.o
 
 CFLAGS_fabs.o = -fno-builtin-fabs
 CFLAGS_math.o = -fno-builtin-fabs
-
-ccflags-y = -w
diff --git a/arch/powerpc/math-emu/math.c b/arch/powerpc/math-emu/math.c
index 30b4b69c6941..d9ce80585ecd 100644
--- a/arch/powerpc/math-emu/math.c
+++ b/arch/powerpc/math-emu/math.c
@@ -24,9 +24,9 @@ FLOATFUNC(mtfsf);
 FLOATFUNC(mtfsfi);
 
 #ifdef CONFIG_MATH_EMULATION_HW_UNIMPLEMENTED
-#undef FLOATFUNC(x)
+#undef FLOATFUNC
 #define FLOATFUNC(x)	static inline int x(void *op1, void *op2, void *op3, \
-						 void *op4) { }
+						 void *op4) { return 0; }
 #endif
 
 FLOATFUNC(fadd);
@@ -396,28 +396,28 @@ do_mathemu(struct pt_regs *regs)
 
 	case XCR:
 		op0 = (void *)&regs->ccr;
-		op1 = (void *)((insn >> 23) & 0x7);
+		op1 = (void *)(long)((insn >> 23) & 0x7);
 		op2 = (void *)&current->thread.TS_FPR((insn >> 16) & 0x1f);
 		op3 = (void *)&current->thread.TS_FPR((insn >> 11) & 0x1f);
 		break;
 
 	case XCRL:
 		op0 = (void *)&regs->ccr;
-		op1 = (void *)((insn >> 23) & 0x7);
-		op2 = (void *)((insn >> 18) & 0x7);
+		op1 = (void *)(long)((insn >> 23) & 0x7);
+		op2 = (void *)(long)((insn >> 18) & 0x7);
 		break;
 
 	case XCRB:
-		op0 = (void *)((insn >> 21) & 0x1f);
+		op0 = (void *)(long)((insn >> 21) & 0x1f);
 		break;
 
 	case XCRI:
-		op0 = (void *)((insn >> 23) & 0x7);
-		op1 = (void *)((insn >> 12) & 0xf);
+		op0 = (void *)(long)((insn >> 23) & 0x7);
+		op1 = (void *)(long)((insn >> 12) & 0xf);
 		break;
 
 	case XFLB:
-		op0 = (void *)((insn >> 17) & 0xff);
+		op0 = (void *)(long)((insn >> 17) & 0xff);
 		op1 = (void *)&current->thread.TS_FPR((insn >> 11) & 0x1f);
 		break;
 
diff --git a/arch/powerpc/math-emu/math_efp.c b/arch/powerpc/math-emu/math_efp.c
index 0a05e51964c1..3b35340ffc90 100644
--- a/arch/powerpc/math-emu/math_efp.c
+++ b/arch/powerpc/math-emu/math_efp.c
@@ -218,6 +218,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 		case AB:
 		case XCR:
 			FP_UNPACK_SP(SA, va.wp + 1);
+			fallthrough;
 		case XB:
 			FP_UNPACK_SP(SB, vb.wp + 1);
 			break;
@@ -226,8 +227,8 @@ int do_spe_mathemu(struct pt_regs *regs)
 			break;
 		}
 
-		pr_debug("SA: %ld %08lx %ld (%ld)\n", SA_s, SA_f, SA_e, SA_c);
-		pr_debug("SB: %ld %08lx %ld (%ld)\n", SB_s, SB_f, SB_e, SB_c);
+		pr_debug("SA: %d %08x %d (%d)\n", SA_s, SA_f, SA_e, SA_c);
+		pr_debug("SB: %d %08x %d (%d)\n", SB_s, SB_f, SB_e, SB_c);
 
 		switch (func) {
 		case EFSABS:
@@ -278,7 +279,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 			} else {
 				SB_e += (func == EFSCTSF ? 31 : 32);
 				FP_TO_INT_ROUND_S(vc.wp[1], SB, 32,
-						(func == EFSCTSF));
+						(func == EFSCTSF) ? 1 : 0);
 			}
 			goto update_regs;
 
@@ -287,7 +288,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 			FP_CLEAR_EXCEPTIONS;
 			FP_UNPACK_DP(DB, vb.dp);
 
-			pr_debug("DB: %ld %08lx %08lx %ld (%ld)\n",
+			pr_debug("DB: %d %08x %08x %d (%d)\n",
 					DB_s, DB_f1, DB_f0, DB_e, DB_c);
 
 			FP_CONV(S, D, 1, 2, SR, DB);
@@ -301,7 +302,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 				FP_SET_EXCEPTION(FP_EX_INVALID);
 			} else {
 				FP_TO_INT_ROUND_S(vc.wp[1], SB, 32,
-						((func & 0x3) != 0));
+						((func & 0x3) != 0) ? 1 : 0);
 			}
 			goto update_regs;
 
@@ -312,7 +313,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 				FP_SET_EXCEPTION(FP_EX_INVALID);
 			} else {
 				FP_TO_INT_S(vc.wp[1], SB, 32,
-						((func & 0x3) != 0));
+						((func & 0x3) != 0) ? 1 : 0);
 			}
 			goto update_regs;
 
@@ -322,7 +323,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 		break;
 
 pack_s:
-		pr_debug("SR: %ld %08lx %ld (%ld)\n", SR_s, SR_f, SR_e, SR_c);
+		pr_debug("SR: %d %08x %d (%d)\n", SR_s, SR_f, SR_e, SR_c);
 
 		FP_PACK_SP(vc.wp + 1, SR);
 		goto update_regs;
@@ -346,6 +347,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 		case AB:
 		case XCR:
 			FP_UNPACK_DP(DA, va.dp);
+			fallthrough;
 		case XB:
 			FP_UNPACK_DP(DB, vb.dp);
 			break;
@@ -354,9 +356,9 @@ int do_spe_mathemu(struct pt_regs *regs)
 			break;
 		}
 
-		pr_debug("DA: %ld %08lx %08lx %ld (%ld)\n",
+		pr_debug("DA: %d %08x %08x %d (%d)\n",
 				DA_s, DA_f1, DA_f0, DA_e, DA_c);
-		pr_debug("DB: %ld %08lx %08lx %ld (%ld)\n",
+		pr_debug("DB: %d %08x %08x %d (%d)\n",
 				DB_s, DB_f1, DB_f0, DB_e, DB_c);
 
 		switch (func) {
@@ -408,7 +410,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 			} else {
 				DB_e += (func == EFDCTSF ? 31 : 32);
 				FP_TO_INT_ROUND_D(vc.wp[1], DB, 32,
-						(func == EFDCTSF));
+						(func == EFDCTSF) ? 1 : 0);
 			}
 			goto update_regs;
 
@@ -417,7 +419,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 			FP_CLEAR_EXCEPTIONS;
 			FP_UNPACK_SP(SB, vb.wp + 1);
 
-			pr_debug("SB: %ld %08lx %ld (%ld)\n",
+			pr_debug("SB: %d %08x %d (%d)\n",
 					SB_s, SB_f, SB_e, SB_c);
 
 			FP_CONV(D, S, 2, 1, DR, SB);
@@ -431,7 +433,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 				FP_SET_EXCEPTION(FP_EX_INVALID);
 			} else {
 				FP_TO_INT_D(vc.dp[0], DB, 64,
-						((func & 0x1) == 0));
+						((func & 0x1) == 0) ? 1 : 0);
 			}
 			goto update_regs;
 
@@ -442,7 +444,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 				FP_SET_EXCEPTION(FP_EX_INVALID);
 			} else {
 				FP_TO_INT_ROUND_D(vc.wp[1], DB, 32,
-						((func & 0x3) != 0));
+						((func & 0x3) != 0) ? 1 : 0);
 			}
 			goto update_regs;
 
@@ -453,7 +455,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 				FP_SET_EXCEPTION(FP_EX_INVALID);
 			} else {
 				FP_TO_INT_D(vc.wp[1], DB, 32,
-						((func & 0x3) != 0));
+						((func & 0x3) != 0) ? 1 : 0);
 			}
 			goto update_regs;
 
@@ -463,7 +465,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 		break;
 
 pack_d:
-		pr_debug("DR: %ld %08lx %08lx %ld (%ld)\n",
+		pr_debug("DR: %d %08x %08x %d (%d)\n",
 				DR_s, DR_f1, DR_f0, DR_e, DR_c);
 
 		FP_PACK_DP(vc.dp, DR);
@@ -492,6 +494,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 		case XCR:
 			FP_UNPACK_SP(SA0, va.wp);
 			FP_UNPACK_SP(SA1, va.wp + 1);
+			fallthrough;
 		case XB:
 			FP_UNPACK_SP(SB0, vb.wp);
 			FP_UNPACK_SP(SB1, vb.wp + 1);
@@ -502,13 +505,13 @@ int do_spe_mathemu(struct pt_regs *regs)
 			break;
 		}
 
-		pr_debug("SA0: %ld %08lx %ld (%ld)\n",
+		pr_debug("SA0: %d %08x %d (%d)\n",
 				SA0_s, SA0_f, SA0_e, SA0_c);
-		pr_debug("SA1: %ld %08lx %ld (%ld)\n",
+		pr_debug("SA1: %d %08x %d (%d)\n",
 				SA1_s, SA1_f, SA1_e, SA1_c);
-		pr_debug("SB0: %ld %08lx %ld (%ld)\n",
+		pr_debug("SB0: %d %08x %d (%d)\n",
 				SB0_s, SB0_f, SB0_e, SB0_c);
-		pr_debug("SB1: %ld %08lx %ld (%ld)\n",
+		pr_debug("SB1: %d %08x %d (%d)\n",
 				SB1_s, SB1_f, SB1_e, SB1_c);
 
 		switch (func) {
@@ -567,7 +570,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 			} else {
 				SB0_e += (func == EVFSCTSF ? 31 : 32);
 				FP_TO_INT_ROUND_S(vc.wp[0], SB0, 32,
-						(func == EVFSCTSF));
+						(func == EVFSCTSF) ? 1 : 0);
 			}
 			if (SB1_c == FP_CLS_NAN) {
 				vc.wp[1] = 0;
@@ -575,7 +578,7 @@ int do_spe_mathemu(struct pt_regs *regs)
 			} else {
 				SB1_e += (func == EVFSCTSF ? 31 : 32);
 				FP_TO_INT_ROUND_S(vc.wp[1], SB1, 32,
-						(func == EVFSCTSF));
+						(func == EVFSCTSF) ? 1 : 0);
 			}
 			goto update_regs;
 
@@ -586,14 +589,14 @@ int do_spe_mathemu(struct pt_regs *regs)
 				FP_SET_EXCEPTION(FP_EX_INVALID);
 			} else {
 				FP_TO_INT_ROUND_S(vc.wp[0], SB0, 32,
-						((func & 0x3) != 0));
+						((func & 0x3) != 0) ? 1 : 0);
 			}
 			if (SB1_c == FP_CLS_NAN) {
 				vc.wp[1] = 0;
 				FP_SET_EXCEPTION(FP_EX_INVALID);
 			} else {
 				FP_TO_INT_ROUND_S(vc.wp[1], SB1, 32,
-						((func & 0x3) != 0));
+						((func & 0x3) != 0) ? 1 : 0);
 			}
 			goto update_regs;
 
@@ -604,14 +607,14 @@ int do_spe_mathemu(struct pt_regs *regs)
 				FP_SET_EXCEPTION(FP_EX_INVALID);
 			} else {
 				FP_TO_INT_S(vc.wp[0], SB0, 32,
-						((func & 0x3) != 0));
+						((func & 0x3) != 0) ? 1 : 0);
 			}
 			if (SB1_c == FP_CLS_NAN) {
 				vc.wp[1] = 0;
 				FP_SET_EXCEPTION(FP_EX_INVALID);
 			} else {
 				FP_TO_INT_S(vc.wp[1], SB1, 32,
-						((func & 0x3) != 0));
+						((func & 0x3) != 0) ? 1 : 0);
 			}
 			goto update_regs;
 
@@ -621,9 +624,9 @@ int do_spe_mathemu(struct pt_regs *regs)
 		break;
 
 pack_vs:
-		pr_debug("SR0: %ld %08lx %ld (%ld)\n",
+		pr_debug("SR0: %d %08x %d (%d)\n",
 				SR0_s, SR0_f, SR0_e, SR0_c);
-		pr_debug("SR1: %ld %08lx %ld (%ld)\n",
+		pr_debug("SR1: %d %08x %d (%d)\n",
 				SR1_s, SR1_f, SR1_e, SR1_c);
 
 		FP_PACK_SP(vc.wp, SR0);
diff --git a/include/math-emu/op-common.h b/include/math-emu/op-common.h
index 143568d64b20..94bb27a5cd18 100644
--- a/include/math-emu/op-common.h
+++ b/include/math-emu/op-common.h
@@ -662,12 +662,14 @@ do {									\
 	if (X##_e < 0)								\
 	  {									\
 	    FP_SET_EXCEPTION(FP_EX_INEXACT);					\
+	    fallthrough;							\
 	  case FP_CLS_ZERO:							\
 	    r = 0;								\
 	  }									\
 	else if (X##_e >= rsize - (rsigned > 0 || X##_s)			\
 		 || (!rsigned && X##_s))					\
 	  {	/* overflow */							\
+	    fallthrough;							\
 	  case FP_CLS_NAN:                                                      \
 	  case FP_CLS_INF:							\
 	    if (rsigned == 2)							\
@@ -767,6 +769,7 @@ do {									\
 	if (X##_e >= rsize - (rsigned > 0 || X##_s)				\
 	    || (!rsigned && X##_s))						\
 	  {	/* overflow */							\
+	    fallthrough;							\
 	  case FP_CLS_NAN:                                                      \
 	  case FP_CLS_INF:							\
 	    if (!rsigned)							\
-- 
2.35.1

