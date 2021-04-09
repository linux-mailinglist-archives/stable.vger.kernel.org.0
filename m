Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E94635A8A0
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 00:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234883AbhDIWMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 18:12:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:53520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234602AbhDIWMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 18:12:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E0ABB610A8;
        Fri,  9 Apr 2021 22:12:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618006337;
        bh=M7s3pMhdWn3yHEsyevVbXdjmmUWWkdETqRhmlxr/BlU=;
        h=From:To:Cc:Subject:Date:From;
        b=u8y2wdd5u/QpjQy7m0Mnv9ezCsy+6q+xfW8jgXnagVFBq5MniZ9a9DTrDCRolQoo5
         oI8lvsMs7amktN21+2FJzdF5kbvYLuyYfKXdXKpkfZJVvc0XLX8gaaZK8xAmVYkJy3
         hwhOCQiTO6ZUpg6y+Ez9Fo9qD99ihYlmbCxBQYZxdyPhFAkD/2+tIVtfk1KauI7h2w
         0rboiSLYcZLBBIycx9UZ/c0QVsBjiUZaTO5xRE4Yw8B/FN15qzo1ANrs8sjPHNhP+g
         NByXHDb9V0M3wOtvCHGVDXveeFDKPd9SQtCY55QGJCzx34J2b9hkYiGoVFz99dS7wL
         TY8gT0uhpgaqQ==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Russell King <linux@armlinux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <nathan@kernel.org>, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Jessica Clarke <jrtc27@jrtc27.com>
Subject: [PATCH] crypto: arm/curve25519 - Move '.fpu' after '.arch'
Date:   Fri,  9 Apr 2021 15:11:55 -0700
Message-Id: <20210409221155.1113205-1-nathan@kernel.org>
X-Mailer: git-send-email 2.31.1.189.g2e36527f23
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Debian's clang carries a patch that makes the default FPU mode
'vfp3-d16' instead of 'neon' for 'armv7-a' to avoid generating NEON
instructions on hardware that does not support them:

https://salsa.debian.org/pkg-llvm-team/llvm-toolchain/-/raw/5a61ca6f21b4ad8c6ac4970e5ea5a7b5b4486d22/debian/patches/clang-arm-default-vfp3-on-armv7a.patch
https://bugs.debian.org/841474
https://bugs.debian.org/842142
https://bugs.debian.org/914268

This results in the following build error when clang's integrated
assembler is used because the '.arch' directive overrides the '.fpu'
directive:

arch/arm/crypto/curve25519-core.S:25:2: error: instruction requires: NEON
 vmov.i32 q0, #1
 ^
arch/arm/crypto/curve25519-core.S:26:2: error: instruction requires: NEON
 vshr.u64 q1, q0, #7
 ^
arch/arm/crypto/curve25519-core.S:27:2: error: instruction requires: NEON
 vshr.u64 q0, q0, #8
 ^
arch/arm/crypto/curve25519-core.S:28:2: error: instruction requires: NEON
 vmov.i32 d4, #19
 ^

Shuffle the order of the '.arch' and '.fpu' directives so that the code
builds regardless of the default FPU mode. This has been tested against
both clang with and without Debian's patch and GCC.

Cc: stable@vger.kernel.org
Fixes: d8f1308a025f ("crypto: arm/curve25519 - wire up NEON implementation")
Link: https://github.com/ClangBuiltLinux/continuous-integration2/issues/118
Reported-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Suggested-by: Jessica Clarke <jrtc27@jrtc27.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/arm/crypto/curve25519-core.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/crypto/curve25519-core.S b/arch/arm/crypto/curve25519-core.S
index be18af52e7dc..b697fa5d059a 100644
--- a/arch/arm/crypto/curve25519-core.S
+++ b/arch/arm/crypto/curve25519-core.S
@@ -10,8 +10,8 @@
 #include <linux/linkage.h>
 
 .text
-.fpu neon
 .arch armv7-a
+.fpu neon
 .align 4
 
 ENTRY(curve25519_neon)

base-commit: e49d033bddf5b565044e2abe4241353959bc9120
-- 
2.31.1.189.g2e36527f23

