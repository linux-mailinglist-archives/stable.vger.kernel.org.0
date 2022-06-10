Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F065461AF
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 11:21:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348640AbiFJJTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 05:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349062AbiFJJSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 05:18:42 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07DB52DABF4;
        Fri, 10 Jun 2022 02:16:52 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nzakz-005Mf6-QQ; Fri, 10 Jun 2022 19:16:43 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Jun 2022 17:16:42 +0800
Date:   Fri, 10 Jun 2022 17:16:42 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        gaochao <gaochao49@huawei.com>, Ard Biesheuvel <ardb@kernel.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH crypto v4] crypto: blake2s - remove shash module
Message-ID: <YqML+uyz1b7Gw1Bh@gondor.apana.org.au>
References: <CAHmME9ozranfubv1qGbVvOWhmFpTn8OuALB0KY2yvJZJLcw3eg@mail.gmail.com>
 <20220528194407.302903-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220528194407.302903-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 28, 2022 at 09:44:07PM +0200, Jason A. Donenfeld wrote:
> BLAKE2s has no currently known use as an shash. Just remove all of this
> unnecessary plumbing. Removing this shash was something we talked about
> back when we were making BLAKE2s a built-in, but I simply never got
> around to doing it. So this completes that project.
> 
> Importantly, this fixs a bug in which the lib code depends on
> crypto_simd_disabled_for_test, causing linker errors.
> 
> Also add more alignment tests to the selftests and compare SIMD and
> non-SIMD compression functions, to make up for what we lose from
> testmgr.c.
> 
> Reported-by: gaochao <gaochao49@huawei.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: stable@vger.kernel.org
> Fixes: 6048fdcc5f26 ("lib/crypto: blake2s: include as built-in")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  arch/arm/crypto/Kconfig           |   2 +-
>  arch/arm/crypto/Makefile          |   4 +-
>  arch/arm/crypto/blake2s-shash.c   |  75 -----------
>  arch/x86/crypto/Makefile          |   4 +-
>  arch/x86/crypto/blake2s-glue.c    |   3 +-
>  arch/x86/crypto/blake2s-shash.c   |  77 -----------
>  crypto/Kconfig                    |  20 +--
>  crypto/Makefile                   |   1 -
>  crypto/blake2s_generic.c          |  75 -----------
>  crypto/tcrypt.c                   |  12 --
>  crypto/testmgr.c                  |  24 ----
>  crypto/testmgr.h                  | 217 ------------------------------
>  include/crypto/internal/blake2s.h | 108 ---------------
>  lib/crypto/blake2s-selftest.c     |  41 ++++++
>  lib/crypto/blake2s.c              |  37 ++++-
>  15 files changed, 76 insertions(+), 624 deletions(-)
>  delete mode 100644 arch/arm/crypto/blake2s-shash.c
>  delete mode 100644 arch/x86/crypto/blake2s-shash.c
>  delete mode 100644 crypto/blake2s_generic.c

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
