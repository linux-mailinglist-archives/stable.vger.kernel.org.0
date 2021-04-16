Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EBD361ED1
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 13:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242771AbhDPLdn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 07:33:43 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:53148 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242542AbhDPLdm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 07:33:42 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lXMiO-0003We-Dy; Fri, 16 Apr 2021 21:32:49 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 16 Apr 2021 21:32:48 +1000
Date:   Fri, 16 Apr 2021 21:32:48 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Jessica Clarke <jrtc27@jrtc27.com>
Subject: Re: [PATCH] crypto: arm/curve25519 - Move '.fpu' after '.arch'
Message-ID: <20210416113248.GM16633@gondor.apana.org.au>
References: <20210409221155.1113205-1-nathan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409221155.1113205-1-nathan@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 03:11:55PM -0700, Nathan Chancellor wrote:
> Debian's clang carries a patch that makes the default FPU mode
> 'vfp3-d16' instead of 'neon' for 'armv7-a' to avoid generating NEON
> instructions on hardware that does not support them:
> 
> https://salsa.debian.org/pkg-llvm-team/llvm-toolchain/-/raw/5a61ca6f21b4ad8c6ac4970e5ea5a7b5b4486d22/debian/patches/clang-arm-default-vfp3-on-armv7a.patch
> https://bugs.debian.org/841474
> https://bugs.debian.org/842142
> https://bugs.debian.org/914268
> 
> This results in the following build error when clang's integrated
> assembler is used because the '.arch' directive overrides the '.fpu'
> directive:
> 
> arch/arm/crypto/curve25519-core.S:25:2: error: instruction requires: NEON
>  vmov.i32 q0, #1
>  ^
> arch/arm/crypto/curve25519-core.S:26:2: error: instruction requires: NEON
>  vshr.u64 q1, q0, #7
>  ^
> arch/arm/crypto/curve25519-core.S:27:2: error: instruction requires: NEON
>  vshr.u64 q0, q0, #8
>  ^
> arch/arm/crypto/curve25519-core.S:28:2: error: instruction requires: NEON
>  vmov.i32 d4, #19
>  ^
> 
> Shuffle the order of the '.arch' and '.fpu' directives so that the code
> builds regardless of the default FPU mode. This has been tested against
> both clang with and without Debian's patch and GCC.
> 
> Cc: stable@vger.kernel.org
> Fixes: d8f1308a025f ("crypto: arm/curve25519 - wire up NEON implementation")
> Link: https://github.com/ClangBuiltLinux/continuous-integration2/issues/118
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Arnd Bergmann <arnd@arndb.de>
> Suggested-by: Jessica Clarke <jrtc27@jrtc27.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/arm/crypto/curve25519-core.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
