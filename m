Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AA41B769B5
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 15:54:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388064AbfGZNm7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 09:42:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387569AbfGZNm7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 09:42:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8053022CC0;
        Fri, 26 Jul 2019 13:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564148578;
        bh=Qkv40fafqQomKUgAfGkXE1/nJT1uUnyN1vwBUnVHzKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8dwKgMYSGHKzpSmz+a5qKCd8Tcldmgu8z0ihvXyq8TdCijyEt4hQ0yGhl2YuWME5
         FqyegTZtssEV6lZsgn16bfIGP0tV5uVKn0GmM2Ogg0XQwgfZ41eC37L+DcYWUc8/Mj
         dMNpULchKurQtS6+gBLTANI6uy42ZB8rffjBfCSw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 29/47] x86: math-emu: Hide clang warnings for 16-bit overflow
Date:   Fri, 26 Jul 2019 09:41:52 -0400
Message-Id: <20190726134210.12156-29-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190726134210.12156-1-sashal@kernel.org>
References: <20190726134210.12156-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 29e7e9664aec17b94a9c8c5a75f8d216a206aa3a ]

clang warns about a few parts of the math-emu implementation
where a 16-bit integer becomes negative during assignment:

arch/x86/math-emu/poly_tan.c:88:35: error: implicit conversion from 'int' to 'short' changes value from 49216 to -16320 [-Werror,-Wconstant-conversion]
                                      (0x41 + EXTENDED_Ebias) | SIGN_Negative);
                                      ~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~
arch/x86/math-emu/fpu_emu.h:180:58: note: expanded from macro 'setexponent16'
 #define setexponent16(x,y)  { (*(short *)&((x)->exp)) = (y); }
                                                      ~  ^
arch/x86/math-emu/reg_constant.c:37:32: error: implicit conversion from 'int' to 'short' changes value from 49085 to -16451 [-Werror,-Wconstant-conversion]
FPU_REG const CONST_PI2extra = MAKE_REG(NEG, -66,
                               ^~~~~~~~~~~~~~~~~~
arch/x86/math-emu/reg_constant.c:21:25: note: expanded from macro 'MAKE_REG'
                ((EXTENDED_Ebias+(e)) | ((SIGN_##s != 0)*0x8000)) }
                 ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~
arch/x86/math-emu/reg_constant.c:48:28: error: implicit conversion from 'int' to 'short' changes value from 65535 to -1 [-Werror,-Wconstant-conversion]
FPU_REG const CONST_QNaN = MAKE_REG(NEG, EXP_OVER, 0x00000000, 0xC0000000);
                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
arch/x86/math-emu/reg_constant.c:21:25: note: expanded from macro 'MAKE_REG'
                ((EXTENDED_Ebias+(e)) | ((SIGN_##s != 0)*0x8000)) }
                 ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~

The code is correct as is, so add a typecast to shut up the warnings.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190712090816.350668-1-arnd@arndb.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/math-emu/fpu_emu.h      | 2 +-
 arch/x86/math-emu/reg_constant.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/math-emu/fpu_emu.h b/arch/x86/math-emu/fpu_emu.h
index a5a41ec58072..0c122226ca56 100644
--- a/arch/x86/math-emu/fpu_emu.h
+++ b/arch/x86/math-emu/fpu_emu.h
@@ -177,7 +177,7 @@ static inline void reg_copy(FPU_REG const *x, FPU_REG *y)
 #define setexponentpos(x,y) { (*(short *)&((x)->exp)) = \
   ((y) + EXTENDED_Ebias) & 0x7fff; }
 #define exponent16(x)         (*(short *)&((x)->exp))
-#define setexponent16(x,y)  { (*(short *)&((x)->exp)) = (y); }
+#define setexponent16(x,y)  { (*(short *)&((x)->exp)) = (u16)(y); }
 #define addexponent(x,y)    { (*(short *)&((x)->exp)) += (y); }
 #define stdexp(x)           { (*(short *)&((x)->exp)) += EXTENDED_Ebias; }
 
diff --git a/arch/x86/math-emu/reg_constant.c b/arch/x86/math-emu/reg_constant.c
index 8dc9095bab22..742619e94bdf 100644
--- a/arch/x86/math-emu/reg_constant.c
+++ b/arch/x86/math-emu/reg_constant.c
@@ -18,7 +18,7 @@
 #include "control_w.h"
 
 #define MAKE_REG(s, e, l, h) { l, h, \
-		((EXTENDED_Ebias+(e)) | ((SIGN_##s != 0)*0x8000)) }
+		(u16)((EXTENDED_Ebias+(e)) | ((SIGN_##s != 0)*0x8000)) }
 
 FPU_REG const CONST_1 = MAKE_REG(POS, 0, 0x00000000, 0x80000000);
 #if 0
-- 
2.20.1

