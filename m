Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADA1918C611
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 04:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgCTDsz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 23:48:55 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33854 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbgCTDsz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 23:48:55 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jF8eA-0001To-MJ; Fri, 20 Mar 2020 14:48:35 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Mar 2020 14:48:34 +1100
Date:   Fri, 20 Mar 2020 14:48:34 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        gregkh@linuxfoundation.org, Emil Renner Berthing <kernel@esmil.dk>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH URGENT crypto v2] crypto: arm64/chacha - correctly walk
 through blocks
Message-ID: <20200320034834.GA27372@gondor.apana.org.au>
References: <CAHmME9otcAe7H4Anan8Tv1KreTZtwt4XXEPMG--x2Ljr0M+o1Q@mail.gmail.com>
 <20200319022732.166085-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319022732.166085-1-Jason@zx2c4.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 18, 2020 at 08:27:32PM -0600, Jason A. Donenfeld wrote:
> Prior, passing in chunks of 2, 3, or 4, followed by any additional
> chunks would result in the chacha state counter getting out of sync,
> resulting in incorrect encryption/decryption, which is a pretty nasty
> crypto vuln: "why do images look weird on webpages?" WireGuard users
> never experienced this prior, because we have always, out of tree, used
> a different crypto library, until the recent Frankenzinc addition. This
> commit fixes the issue by advancing the pointers and state counter by
> the actual size processed. It also fixes up a bug in the (optional,
> costly) stride test that prevented it from running on arm64.
> 
> Fixes: b3aad5bad26a ("crypto: arm64/chacha - expose arm64 ChaCha routine as library function")
> Reported-and-tested-by: Emil Renner Berthing <kernel@esmil.dk>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: stable@vger.kernel.org # v5.5+
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
>  arch/arm64/crypto/chacha-neon-glue.c   |  8 ++++----
>  lib/crypto/chacha20poly1305-selftest.c | 11 ++++++++---
>  2 files changed, 12 insertions(+), 7 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
