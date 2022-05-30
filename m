Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 824AC5386D2
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 19:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236134AbiE3Rgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 13:36:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiE3Rgb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 13:36:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F07B6898D;
        Mon, 30 May 2022 10:36:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 902A3B80DC0;
        Mon, 30 May 2022 17:36:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF5DC385B8;
        Mon, 30 May 2022 17:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653932188;
        bh=FoOGGS5HbF/zub9jWYSV2y47AxBkhodh4GDcvNJTV/E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k9XidlBjS90S1D3ozRaqkXwNoMLtXaaUSzgtU8f/9GuNDlh7sC/92xLJXDU4IZN6C
         Hh6rFuhGvl1O8YDK+6xu7FAL4BXeW7+CqWwh8vyrLY0hVM4nNEdd5/Qv90zTJ4gjhs
         2hwy8RLr1rKQghxP6wKv1cSRK1mrQKJZ+PtTsIQ9t6IHG/mSKietwUakM8Btp0U1us
         teAMQzQ3QHhDj+D9C/6xe6ZX/8XxXUtN0zlx7hM3ApDk2WtCuw6VwFQliMwbeEDTVn
         ICejKzj4wdYHo5lhN2BYhDTqq49SsHp/xDYTSB7+DmswshdDFlT1d8S39UDUuFy7x8
         I1Gq9SLH0VtLA==
Date:   Mon, 30 May 2022 10:36:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zheng Bin <zhengbin13@huawei.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH crypto] crypto: memneq - move into lib/
Message-ID: <YpUAmiBSb6oEr1oc@sol.localdomain>
References: <CAHmME9rWfUnUmHR5xo_+WdS0Wgv8yXQb+LqAo24XdoQQR4Wn8w@mail.gmail.com>
 <20220528102429.189731-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220528102429.189731-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
