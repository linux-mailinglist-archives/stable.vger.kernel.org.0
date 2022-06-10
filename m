Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5664A5461B5
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 11:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348803AbiFJJTH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 05:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349030AbiFJJSh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 05:18:37 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904FE2D9AF4;
        Fri, 10 Jun 2022 02:16:41 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1nzakk-005Md7-52; Fri, 10 Jun 2022 19:16:27 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Jun 2022 17:16:26 +0800
Date:   Fri, 10 Jun 2022 17:16:26 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheng Bin <zhengbin13@huawei.com>,
        Eric Biggers <ebiggers@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH crypto] crypto: memneq - move into lib/
Message-ID: <YqML6nrdohsG7gsR@gondor.apana.org.au>
References: <CAHmME9rWfUnUmHR5xo_+WdS0Wgv8yXQb+LqAo24XdoQQR4Wn8w@mail.gmail.com>
 <20220528102429.189731-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220528102429.189731-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, May 28, 2022 at 12:24:29PM +0200, Jason A. Donenfeld wrote:
> This is used by code that doesn't need CONFIG_CRYPTO, so move this into
> lib/ with a Kconfig option so that it can be selected by whatever needs
> it.
> 
> This fixes a linker error Zheng pointed out when
> CRYPTO_MANAGER_DISABLE_TESTS!=y and CRYPTO=m:
> 
>   lib/crypto/curve25519-selftest.o: In function `curve25519_selftest':
>   curve25519-selftest.c:(.init.text+0x60): undefined reference to `__crypto_memneq'
>   curve25519-selftest.c:(.init.text+0xec): undefined reference to `__crypto_memneq'
>   curve25519-selftest.c:(.init.text+0x114): undefined reference to `__crypto_memneq'
>   curve25519-selftest.c:(.init.text+0x154): undefined reference to `__crypto_memneq'
> 
> Reported-by: Zheng Bin <zhengbin13@huawei.com>
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: stable@vger.kernel.org
> Fixes: aa127963f1ca ("crypto: lib/curve25519 - re-add selftests")
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> I'm traveling over the next week, and there are a few ways to skin this
> cat, so if somebody here sees issue, feel free to pick this v1 up and
> fashion a v2 out of it.
> 
>  crypto/Kconfig           | 1 +
>  crypto/Makefile          | 2 +-
>  lib/Kconfig              | 3 +++
>  lib/Makefile             | 1 +
>  lib/crypto/Kconfig       | 1 +
>  {crypto => lib}/memneq.c | 0
>  6 files changed, 7 insertions(+), 1 deletion(-)
>  rename {crypto => lib}/memneq.c (100%)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
