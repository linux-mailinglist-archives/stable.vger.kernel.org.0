Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B64D3527C7
	for <lists+stable@lfdr.de>; Fri,  2 Apr 2021 11:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbhDBJDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Apr 2021 05:03:48 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58910 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229553AbhDBJDs (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Apr 2021 05:03:48 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lSFiF-0002Hr-Gw; Fri, 02 Apr 2021 20:03:32 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Apr 2021 20:03:31 +1100
Date:   Fri, 2 Apr 2021 20:03:31 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, dan.carpenter@oracle.com,
        nhorman@tuxdriver.com, clabbe@baylibre.com, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: rng - fix crypto_rng_reset() refcounting when
 !CRYPTO_STATS
Message-ID: <20210402090331.GA24545@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322050748.265604-1-ebiggers@kernel.org>
X-Newsgroups: apana.lists.os.linux.cryptoapi
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> crypto_stats_get() is a no-op when the kernel is compiled without
> CONFIG_CRYPTO_STATS, so pairing it with crypto_alg_put() unconditionally
> (as crypto_rng_reset() does) is wrong.
> 
> Fix this by moving the call to crypto_stats_get() to just before the
> actual algorithm operation which might need it.  This makes it always
> paired with crypto_stats_rng_seed().
> 
> Fixes: eed74b3eba9e ("crypto: rng - Fix a refcounting bug in crypto_rng_reset()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> crypto/rng.c | 10 +++-------
> 1 file changed, 3 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
