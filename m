Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52A574F3310
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:08:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245373AbiDEIzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240683AbiDEIcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63CE13CC3;
        Tue,  5 Apr 2022 01:24:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CECDF60FF5;
        Tue,  5 Apr 2022 08:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFBC3C385A0;
        Tue,  5 Apr 2022 08:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147085;
        bh=dXdjpfekDNrTTf5v3ALYDHyT1ftBFvjw95HyxuH5594=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f1vkLz+1W4v/Cm3k681DJOdA/qw/jm/jWKl4z20SrtJjRxWsh+bVlkurDITHksFUy
         G6TMyFfNDoB1lKP1zf7miXH9yKFyM7MJ/n5Dksd/AjPrEoLqhsEOLSesbXp6BibI4n
         TZbfAJkO3za15D94usIWKTAklIjbHPDfLvfyPwtE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        kernel test robot <lkp@intel.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.17 0995/1126] MIPS: crypto: Fix CRC32 code
Date:   Tue,  5 Apr 2022 09:29:02 +0200
Message-Id: <20220405070436.699741744@linuxfoundation.org>
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

From: Paul Cercueil <paul@crapouillou.net>

commit 41022eff9c2d21e658c7a6fcd31005bf514d28b7 upstream.

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
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/crypto/crc32-mips.c |   46 +++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

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
 


