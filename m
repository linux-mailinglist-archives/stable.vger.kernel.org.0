Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4ADF64440A
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 14:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiLFNGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 08:06:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233690AbiLFNFr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 08:05:47 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5D32A416;
        Tue,  6 Dec 2022 05:04:18 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id s7so13828606plk.5;
        Tue, 06 Dec 2022 05:04:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IqQsTGzm4+sVIX3gKs336wfTyo94bCtj3KwX+tW9hU8=;
        b=KG2GyJsx1A2g4lq+tzVwxvWwHN1+9907EZG20F4Bw7WpwgJNg6kONF1bGt7BmoMsWb
         6xUsRZmdxud4sT2C6FRta4sZbSR/6W9XwE6EUMRVg/zOC5RRzzlVJ42cpN07j53sYnX2
         E8L7W87gazsjvZA1n56ynQ1Lfg6agUHtBOUC7uWF2U5KsXrBMbHqu3Z+nABvlfh118Xq
         d27Nqj920giORYDz9JhalCXEHIxdi+RHi4It7qJbxb8YljVJxDj/DLAlhyU2ZS+XTxsy
         xM2IcwrQ10GRPO96Azsyf9aiYUc8biUZ+yE6aEII/u4vnuI4WQc/Am2QAgEUpZ7dT+A5
         HQhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IqQsTGzm4+sVIX3gKs336wfTyo94bCtj3KwX+tW9hU8=;
        b=uukhwkL38ooSBmciA3fpIVlQ7YIbGsg12JNZH1i4s3p3HubC+zCz8TfFxQxwyXfLwA
         zqeeMIdpCAbwpGgK1GMxZ+0B6905++66cGL7tM2/g8cYM4kiUxJgeMYl9sl8a86c4eS0
         PYES/HrSXkcGx8S4jNJ64A1jb91khC8WyaSHgTogzoAghziCUnR/FTXvPdhf2HhDvbQa
         alUeYNTWiexFi+G0VLUt+bHC/8UVCsDnkLWGxOKzrxpMSfloNcJUIVTDYAVpzyNj0N34
         ZrGF4QZcdqszZOUbLoAQBG20GpeKioTQWgZGy78QOTGy4NN5V1VQWz9QNiZcAQFvuOm7
         15Fw==
X-Gm-Message-State: ANoB5pkpTP2v03OW6+Vbib0Fuk7ghUTepwQlMhM9UeWbSHJasWoxkVXK
        wIeb77jx17LL50cMNGKCbOI=
X-Google-Smtp-Source: AA0mqf7twGgkrwoLULCxEra25T6OTlJrCqXS1FI42xJ6RV4j+yuD33IBNYDJKhyrBKLu/VL480J84Q==
X-Received: by 2002:a17:90a:2d81:b0:219:9676:fef4 with SMTP id p1-20020a17090a2d8100b002199676fef4mr19360394pjd.89.1670331823975;
        Tue, 06 Dec 2022 05:03:43 -0800 (PST)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:401:1d20:36ff:cebd:223c:4588])
        by smtp.gmail.com with ESMTPSA id c15-20020a170903234f00b00186c3afb49esm4360691plh.209.2022.12.06.05.03.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 05:03:43 -0800 (PST)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        Max Filippov <jcmvbkbc@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] xtensa: add __umulsidi3 helper
Date:   Tue,  6 Dec 2022 05:03:32 -0800
Message-Id: <20221206130332.3398120-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FROM_LOCAL_NOVOWEL,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

xtensa gcc-13 has changed multiplication handling and may now use
__umulsidi3 helper where it used to use __muldi3. As a result building
the kernel with the new gcc may fail with the following error:

    linux/init/main.c:1287: undefined reference to `__umulsidi3'

Fix the build by providing __umulsidi3 implementation for xtensa.

Cc: stable@vger.kernel.org # 5.18+
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
---
 arch/xtensa/kernel/xtensa_ksyms.c |   2 +
 arch/xtensa/lib/Makefile          |   2 +-
 arch/xtensa/lib/umulsidi3.S       | 230 ++++++++++++++++++++++++++++++
 3 files changed, 233 insertions(+), 1 deletion(-)
 create mode 100644 arch/xtensa/lib/umulsidi3.S

diff --git a/arch/xtensa/kernel/xtensa_ksyms.c b/arch/xtensa/kernel/xtensa_ksyms.c
index b0bc8897c924..2a31b1ab0c9f 100644
--- a/arch/xtensa/kernel/xtensa_ksyms.c
+++ b/arch/xtensa/kernel/xtensa_ksyms.c
@@ -62,6 +62,7 @@ extern int __modsi3(int, int);
 extern int __mulsi3(int, int);
 extern unsigned int __udivsi3(unsigned int, unsigned int);
 extern unsigned int __umodsi3(unsigned int, unsigned int);
+extern unsigned long long __umulsidi3(unsigned int, unsigned int);
 
 EXPORT_SYMBOL(__ashldi3);
 EXPORT_SYMBOL(__ashrdi3);
@@ -71,6 +72,7 @@ EXPORT_SYMBOL(__modsi3);
 EXPORT_SYMBOL(__mulsi3);
 EXPORT_SYMBOL(__udivsi3);
 EXPORT_SYMBOL(__umodsi3);
+EXPORT_SYMBOL(__umulsidi3);
 
 unsigned int __sync_fetch_and_and_4(volatile void *p, unsigned int v)
 {
diff --git a/arch/xtensa/lib/Makefile b/arch/xtensa/lib/Makefile
index d4e9c397e3fd..7ecef0519a27 100644
--- a/arch/xtensa/lib/Makefile
+++ b/arch/xtensa/lib/Makefile
@@ -5,7 +5,7 @@
 
 lib-y	+= memcopy.o memset.o checksum.o \
 	   ashldi3.o ashrdi3.o lshrdi3.o \
-	   divsi3.o udivsi3.o modsi3.o umodsi3.o mulsi3.o \
+	   divsi3.o udivsi3.o modsi3.o umodsi3.o mulsi3.o umulsidi3.o \
 	   usercopy.o strncpy_user.o strnlen_user.o
 lib-$(CONFIG_PCI) += pci-auto.o
 lib-$(CONFIG_KCSAN) += kcsan-stubs.o
diff --git a/arch/xtensa/lib/umulsidi3.S b/arch/xtensa/lib/umulsidi3.S
new file mode 100644
index 000000000000..136081647942
--- /dev/null
+++ b/arch/xtensa/lib/umulsidi3.S
@@ -0,0 +1,230 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later WITH GCC-exception-2.0 */
+#include <linux/linkage.h>
+#include <asm/asmmacro.h>
+#include <asm/core.h>
+
+#if !XCHAL_HAVE_MUL16 && !XCHAL_HAVE_MUL32 && !XCHAL_HAVE_MAC16
+#define XCHAL_NO_MUL 1
+#endif
+
+ENTRY(__umulsidi3)
+
+#ifdef __XTENSA_CALL0_ABI__
+	abi_entry(32)
+	s32i	a12, sp, 16
+	s32i	a13, sp, 20
+	s32i	a14, sp, 24
+	s32i	a15, sp, 28
+#elif XCHAL_NO_MUL
+	/* This is not really a leaf function; allocate enough stack space
+	   to allow CALL12s to a helper function.  */
+	abi_entry(32)
+#else
+	abi_entry_default
+#endif
+
+#ifdef __XTENSA_EB__
+#define wh a2
+#define wl a3
+#else
+#define wh a3
+#define wl a2
+#endif /* __XTENSA_EB__ */
+
+	/* This code is taken from the mulsf3 routine in ieee754-sf.S.
+	   See more comments there.  */
+
+#if XCHAL_HAVE_MUL32_HIGH
+	mull	a6, a2, a3
+	muluh	wh, a2, a3
+	mov	wl, a6
+
+#else /* ! MUL32_HIGH */
+
+#if defined(__XTENSA_CALL0_ABI__) && XCHAL_NO_MUL
+	/* a0 and a8 will be clobbered by calling the multiply function
+	   but a8 is not used here and need not be saved.  */
+	s32i	a0, sp, 0
+#endif
+
+#if XCHAL_HAVE_MUL16 || XCHAL_HAVE_MUL32
+
+#define a2h a4
+#define a3h a5
+
+	/* Get the high halves of the inputs into registers.  */
+	srli	a2h, a2, 16
+	srli	a3h, a3, 16
+
+#define a2l a2
+#define a3l a3
+
+#if XCHAL_HAVE_MUL32 && !XCHAL_HAVE_MUL16
+	/* Clear the high halves of the inputs.  This does not matter
+	   for MUL16 because the high bits are ignored.  */
+	extui	a2, a2, 0, 16
+	extui	a3, a3, 0, 16
+#endif
+#endif /* MUL16 || MUL32 */
+
+
+#if XCHAL_HAVE_MUL16
+
+#define do_mul(dst, xreg, xhalf, yreg, yhalf) \
+	mul16u	dst, xreg ## xhalf, yreg ## yhalf
+
+#elif XCHAL_HAVE_MUL32
+
+#define do_mul(dst, xreg, xhalf, yreg, yhalf) \
+	mull	dst, xreg ## xhalf, yreg ## yhalf
+
+#elif XCHAL_HAVE_MAC16
+
+/* The preprocessor insists on inserting a space when concatenating after
+   a period in the definition of do_mul below.  These macros are a workaround
+   using underscores instead of periods when doing the concatenation.  */
+#define umul_aa_ll umul.aa.ll
+#define umul_aa_lh umul.aa.lh
+#define umul_aa_hl umul.aa.hl
+#define umul_aa_hh umul.aa.hh
+
+#define do_mul(dst, xreg, xhalf, yreg, yhalf) \
+	umul_aa_ ## xhalf ## yhalf	xreg, yreg; \
+	rsr	dst, ACCLO
+
+#else /* no multiply hardware */
+
+#define set_arg_l(dst, src) \
+	extui	dst, src, 0, 16
+#define set_arg_h(dst, src) \
+	srli	dst, src, 16
+
+#ifdef __XTENSA_CALL0_ABI__
+#define do_mul(dst, xreg, xhalf, yreg, yhalf) \
+	set_arg_ ## xhalf (a13, xreg); \
+	set_arg_ ## yhalf (a14, yreg); \
+	call0	.Lmul_mulsi3; \
+	mov	dst, a12
+#else
+#define do_mul(dst, xreg, xhalf, yreg, yhalf) \
+	set_arg_ ## xhalf (a14, xreg); \
+	set_arg_ ## yhalf (a15, yreg); \
+	call12	.Lmul_mulsi3; \
+	mov	dst, a14
+#endif /* __XTENSA_CALL0_ABI__ */
+
+#endif /* no multiply hardware */
+
+	/* Add pp1 and pp2 into a6 with carry-out in a9.  */
+	do_mul(a6, a2, l, a3, h)	/* pp 1 */
+	do_mul(a11, a2, h, a3, l)	/* pp 2 */
+	movi	a9, 0
+	add	a6, a6, a11
+	bgeu	a6, a11, 1f
+	addi	a9, a9, 1
+1:
+	/* Shift the high half of a9/a6 into position in a9.  Note that
+	   this value can be safely incremented without any carry-outs.  */
+	ssai	16
+	src	a9, a9, a6
+
+	/* Compute the low word into a6.  */
+	do_mul(a11, a2, l, a3, l)	/* pp 0 */
+	sll	a6, a6
+	add	a6, a6, a11
+	bgeu	a6, a11, 1f
+	addi	a9, a9, 1
+1:
+	/* Compute the high word into wh.  */
+	do_mul(wh, a2, h, a3, h)	/* pp 3 */
+	add	wh, wh, a9
+	mov	wl, a6
+
+#endif /* !MUL32_HIGH */
+
+#if defined(__XTENSA_CALL0_ABI__) && XCHAL_NO_MUL
+	/* Restore the original return address.  */
+	l32i	a0, sp, 0
+#endif
+#ifdef __XTENSA_CALL0_ABI__
+	l32i	a12, sp, 16
+	l32i	a13, sp, 20
+	l32i	a14, sp, 24
+	l32i	a15, sp, 28
+	abi_ret(32)
+#else
+	abi_ret_default
+#endif
+
+#if XCHAL_NO_MUL
+
+	.macro	do_addx2 dst, as, at, tmp
+#if XCHAL_HAVE_ADDX
+	addx2	\dst, \as, \at
+#else
+	slli	\tmp, \as, 1
+	add	\dst, \tmp, \at
+#endif
+	.endm
+
+	.macro	do_addx4 dst, as, at, tmp
+#if XCHAL_HAVE_ADDX
+	addx4	\dst, \as, \at
+#else
+	slli	\tmp, \as, 2
+	add	\dst, \tmp, \at
+#endif
+	.endm
+
+	.macro	do_addx8 dst, as, at, tmp
+#if XCHAL_HAVE_ADDX
+	addx8	\dst, \as, \at
+#else
+	slli	\tmp, \as, 3
+	add	\dst, \tmp, \at
+#endif
+	.endm
+
+	/* For Xtensa processors with no multiply hardware, this simplified
+	   version of _mulsi3 is used for multiplying 16-bit chunks of
+	   the floating-point mantissas.  When using CALL0, this function
+	   uses a custom ABI: the inputs are passed in a13 and a14, the
+	   result is returned in a12, and a8 and a15 are clobbered.  */
+	.align	4
+.Lmul_mulsi3:
+	abi_entry_default
+
+	.macro mul_mulsi3_body dst, src1, src2, tmp1, tmp2
+	movi	\dst, 0
+1:	add	\tmp1, \src2, \dst
+	extui	\tmp2, \src1, 0, 1
+	movnez	\dst, \tmp1, \tmp2
+
+	do_addx2 \tmp1, \src2, \dst, \tmp1
+	extui	\tmp2, \src1, 1, 1
+	movnez	\dst, \tmp1, \tmp2
+
+	do_addx4 \tmp1, \src2, \dst, \tmp1
+	extui	\tmp2, \src1, 2, 1
+	movnez	\dst, \tmp1, \tmp2
+
+	do_addx8 \tmp1, \src2, \dst, \tmp1
+	extui	\tmp2, \src1, 3, 1
+	movnez	\dst, \tmp1, \tmp2
+
+	srli	\src1, \src1, 4
+	slli	\src2, \src2, 4
+	bnez	\src1, 1b
+	.endm
+
+#ifdef __XTENSA_CALL0_ABI__
+	mul_mulsi3_body a12, a13, a14, a15, a8
+#else
+	/* The result will be written into a2, so save that argument in a4.  */
+	mov	a4, a2
+	mul_mulsi3_body a2, a4, a3, a5, a6
+#endif
+	abi_ret_default
+#endif /* XCHAL_NO_MUL */
+
+ENDPROC(__umulsidi3)
-- 
2.30.2

