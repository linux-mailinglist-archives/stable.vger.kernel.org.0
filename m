Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C775F6B3DCA
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 12:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbjCJLb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 06:31:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjCJLb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 06:31:27 -0500
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261E25FD6;
        Fri, 10 Mar 2023 03:31:26 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1paaxt-002Y86-Su; Fri, 10 Mar 2023 19:31:14 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Mar 2023 19:31:13 +0800
Date:   Fri, 10 Mar 2023 19:31:13 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: testmgr - fix RNG performance in fuzz tests
Message-ID: <ZAsVAXRGjM/fREEn@gondor.apana.org.au>
References: <20230227182947.61733-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227182947.61733-1-ebiggers@kernel.org>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 10:29:47AM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> The performance of the crypto fuzz tests has greatly regressed since
> v5.18.  When booting a kernel on an arm64 dev board with all software
> crypto algorithms and CONFIG_CRYPTO_MANAGER_EXTRA_TESTS enabled, the
> fuzz tests now take about 200 seconds to run, or about 325 seconds with
> lockdep enabled, compared to about 5 seconds before.
> 
> The root cause is that the random number generation has become much
> slower due to commit d4150779e60f ("random32: use real rng for
> non-deterministic randomness").  On my same arm64 dev board, at the time
> the fuzz tests are run, get_random_u8() is about 345x slower than
> prandom_u32_state(), or about 469x if lockdep is enabled.
> 
> Lockdep makes a big difference, but much of the rest comes from the
> get_random_*() functions taking a *very* slow path when the CRNG is not
> yet initialized.  Since the crypto self-tests run early during boot,
> even having a hardware RNG driver enabled (CONFIG_CRYPTO_DEV_QCOM_RNG in
> my case) doesn't prevent this.  x86 systems don't have this issue, but
> they still see a significant regression if lockdep is enabled.
> 
> Converting the "Fully random bytes" case in generate_random_bytes() to
> use get_random_bytes() helps significantly, improving the test time to
> about 27 seconds.  But that's still over 5x slower than before.
> 
> This is all a bit silly, though, since the fuzz tests don't actually
> need cryptographically secure random numbers.  So let's just make them
> use a non-cryptographically-secure RNG as they did before.  The original
> prandom_u32() is gone now, so let's use prandom_u32_state() instead,
> with an explicitly managed state, like various other self-tests in the
> kernel source tree (rbtree_test.c, test_scanf.c, etc.) already do.  This
> also has the benefit that no locking is required anymore, so performance
> should be even better than the original version that used prandom_u32().
> 
> Fixes: d4150779e60f ("random32: use real rng for non-deterministic randomness")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> v2: made init_rnd_state() use get_random_u64()
> 
>  crypto/testmgr.c | 266 ++++++++++++++++++++++++++++++-----------------
>  1 file changed, 169 insertions(+), 97 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
