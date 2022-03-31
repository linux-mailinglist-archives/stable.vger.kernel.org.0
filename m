Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266614EDEFC
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 18:42:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233883AbiCaQoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 12:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232615AbiCaQn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 12:43:59 -0400
Received: from aposti.net (aposti.net [89.234.176.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F03220E947;
        Thu, 31 Mar 2022 09:42:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1648744927; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-transfer-encoding:content-transfer-encoding:
         in-reply-to:references; bh=IAvMrhVHS/428HmJmNcZO9TFoCp/orv0qlTHSEiIHbc=;
        b=tznwXdrdiBiRDvepwYYMPhTVr04PPgDcJ7Ruoue3YkWqZRIPmeiLPikWU8YEMJ5g0dPVxw
        uhZEbSGIUKaYIBnzMtKbwtg6yjuNnEwe4/leZdiigFdXZCK4VDXUDAJ+Hvccc6alH1sGpm
        y9zc+tiTVNSvZ/cPqcbQEEttqV58WlY=
From:   Paul Cercueil <paul@crapouillou.net>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        "Maciej W . Rozycki" <macro@orcam.me.uk>,
        linux-crypto@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Paul Cercueil <paul@crapouillou.net>, stable@vger.kernel.org,
        kernel test robot <lkp@intel.com>
Subject: [PATCH] MIPS: crypto: Fix CRC32 code
Date:   Thu, 31 Mar 2022 17:42:00 +0100
Message-Id: <20220331164200.177015-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 67512a8cf5a7 ("MIPS: Avoid macro redefinitions") changed how the
MIPS register macros were defined, in order to allow the code to compile
under LLVM/Clang.

The MIPS CRC32 code however wasn't updated accordingly, causing a build
bug when using a MIPS32r6 toolchain without CRC support.

Update the CRC32 code to use the macros correctly, to fix the build
failures.

Fixes: 67512a8cf5a7 ("MIPS: Avoid macro redefinitions")
Cc: <stable@vger.kernel.org>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Reported-by: kernel test robot <lkp@intel.com>
---
 arch/mips/crypto/crc32-mips.c | 46 ++++++++++++++++++++---------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/arch/mips/crypto/crc32-mips.c b/arch/mips/crypto/crc32-mips.c
index 0a03529cf317..3e4f5ba104f8 100644
--- a/arch/mips/crypto/crc32-mips.c
+++ b/arch/mips/crypto/crc32-mips.c
@@ -28,7 +28,7 @@ enum crc_type {
 };
 
 #ifndef TOOLCHAIN_SUPPORTS_CRC
-#define _ASM_MACRO_CRC32(OP, SZ, TYPE)					  \
+#define _ASM_SET_CRC(OP, SZ, TYPE)					  \
 _ASM_MACRO_3R(OP, rt, rs, rt2,						  \
 	".ifnc	\\rt, \\rt2\n\t"					  \
 	".error	\"invalid operands \\\"" #OP " \\rt,\\rs,\\rt2\\\"\"\n\t" \
@@ -37,30 +37,36 @@ _ASM_MACRO_3R(OP, rt, rs, rt2,						  \
 			  ((SZ) <<  6) | ((TYPE) << 8))			  \
 	_ASM_INSN32_IF_MM(0x00000030 | (__rs << 16) | (__rt << 21) |	  \
 			  ((SZ) << 14) | ((TYPE) << 3)))
-_ASM_MACRO_CRC32(crc32b,  0, 0);
-_ASM_MACRO_CRC32(crc32h,  1, 0);
-_ASM_MACRO_CRC32(crc32w,  2, 0);
-_ASM_MACRO_CRC32(crc32d,  3, 0);
-_ASM_MACRO_CRC32(crc32cb, 0, 1);
-_ASM_MACRO_CRC32(crc32ch, 1, 1);
-_ASM_MACRO_CRC32(crc32cw, 2, 1);
-_ASM_MACRO_CRC32(crc32cd, 3, 1);
-#define _ASM_SET_CRC ""
+#define _ASM_UNSET_CRC(op, SZ, TYPE) ".purgem " #op "\n\t"
 #else /* !TOOLCHAIN_SUPPORTS_CRC */
-#define _ASM_SET_CRC ".set\tcrc\n\t"
+#define _ASM_SET_CRC(op, SZ, TYPE) ".set\tcrc\n\t"
+#define _ASM_UNSET_CRC(op, SZ, TYPE)
 #endif
 
-#define _CRC32(crc, value, size, type)		\
-do {						\
-	__asm__ __volatile__(			\
-		".set	push\n\t"		\
-		_ASM_SET_CRC			\
-		#type #size "	%0, %1, %0\n\t"	\
-		".set	pop"			\
-		: "+r" (crc)			\
-		: "r" (value));			\
+#define __CRC32(crc, value, op, SZ, TYPE)		\
+do {							\
+	__asm__ __volatile__(				\
+		".set	push\n\t"			\
+		_ASM_SET_CRC(op, SZ, TYPE)		\
+		#op "	%0, %1, %0\n\t"			\
+		_ASM_UNSET_CRC(op, SZ, TYPE)		\
+		".set	pop"				\
+		: "+r" (crc)				\
+		: "r" (value));				\
 } while (0)
 
+#define _CRC32_crc32b(crc, value)	__CRC32(crc, value, crc32b, 0, 0)
+#define _CRC32_crc32h(crc, value)	__CRC32(crc, value, crc32h, 1, 0)
+#define _CRC32_crc32w(crc, value)	__CRC32(crc, value, crc32w, 2, 0)
+#define _CRC32_crc32d(crc, value)	__CRC32(crc, value, crc32d, 3, 0)
+#define _CRC32_crc32cb(crc, value)	__CRC32(crc, value, crc32cb, 0, 1)
+#define _CRC32_crc32ch(crc, value)	__CRC32(crc, value, crc32ch, 1, 1)
+#define _CRC32_crc32cw(crc, value)	__CRC32(crc, value, crc32cw, 2, 1)
+#define _CRC32_crc32cd(crc, value)	__CRC32(crc, value, crc32cd, 3, 1)
+
+#define _CRC32(crc, value, size, op) \
+	_CRC32_##op##size(crc, value)
+
 #define CRC32(crc, value, size) \
 	_CRC32(crc, value, size, crc32)
 
-- 
2.35.1

