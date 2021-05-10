Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B843788EC
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:49:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhEJLY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:24:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234919AbhEJLNM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:13:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1EB2B613C5;
        Mon, 10 May 2021 11:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645012;
        bh=GP313qOubS9rto88V4AxPe+esMFnkQi8JAn6FdOn3f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQufBwhCB0gUbFTf+CeoFYmD9Ayo4y+CruyX9Hul94sPNfBMs3G49ZFHVRvtoidQM
         xKUqfXTOlOQsK4w2f4XFMf50KWqxydD/CP6oxO7FgZMBBkySmI8MaVzezxcd0ivi5U
         IsfO6VFtnYWTyKM6VzkCxzRpSJyPVwBRvYSl/zoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jessica Clarke <jrtc27@jrtc27.com>,
        Nathan Chancellor <nathan@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.12 316/384] crypto: arm/curve25519 - Move .fpu after .arch
Date:   Mon, 10 May 2021 12:21:45 +0200
Message-Id: <20210510102025.208994993@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 44200f2d9b8b52389c70e6c7bbe51e0dc6eaf938 upstream.

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
Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Tested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/crypto/curve25519-core.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


