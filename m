Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2A7D18BFD3
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 20:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726892AbgCSTDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 15:03:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41676 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgCSTDH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 15:03:07 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AC792070A;
        Thu, 19 Mar 2020 19:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584644586;
        bh=ernhXbfEVGnkUDBt61dYmqqeZnm1bLgSbo+SerOadKs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yA10IBmoPAJAsc6u7AspQTyanMnQc1CGge6rLRTuz9mAtBo9/EXungbsKFC7m+XVT
         oG/syAvZrUwB03MKafBhBc1N7mTiPoHzGTxcOg7rGqUGSqu/mK3jm7zLdW94MiiEV6
         jPDXkmT0CEz/iLf5vLFgMN6M7GEoIrt6vBgQKWsM=
Date:   Thu, 19 Mar 2020 12:03:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        gregkh@linuxfoundation.org, herbert@gondor.apana.org.au,
        Emil Renner Berthing <kernel@esmil.dk>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH URGENT crypto v2] crypto: arm64/chacha - correctly walk
 through blocks
Message-ID: <20200319190304.GB86395@gmail.com>
References: <CAHmME9otcAe7H4Anan8Tv1KreTZtwt4XXEPMG--x2Ljr0M+o1Q@mail.gmail.com>
 <20200319022732.166085-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319022732.166085-1-Jason@zx2c4.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
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
> 
> diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
> index c1f9660d104c..37ca3e889848 100644
> --- a/arch/arm64/crypto/chacha-neon-glue.c
> +++ b/arch/arm64/crypto/chacha-neon-glue.c
> @@ -55,10 +55,10 @@ static void chacha_doneon(u32 *state, u8 *dst, const u8 *src,
>  			break;
>  		}
>  		chacha_4block_xor_neon(state, dst, src, nrounds, l);
> -		bytes -= CHACHA_BLOCK_SIZE * 5;
> -		src += CHACHA_BLOCK_SIZE * 5;
> -		dst += CHACHA_BLOCK_SIZE * 5;
> -		state[12] += 5;
> +		bytes -= l;
> +		src += l;
> +		dst += l;
> +		state[12] += DIV_ROUND_UP(l, CHACHA_BLOCK_SIZE);
>  	}
>  }
>  
> diff --git a/lib/crypto/chacha20poly1305-selftest.c b/lib/crypto/chacha20poly1305-selftest.c
> index c391a91364e9..fa43deda2660 100644
> --- a/lib/crypto/chacha20poly1305-selftest.c
> +++ b/lib/crypto/chacha20poly1305-selftest.c
> @@ -9028,10 +9028,15 @@ bool __init chacha20poly1305_selftest(void)
>  	     && total_len <= 1 << 10; ++total_len) {
>  		for (i = 0; i <= total_len; ++i) {
>  			for (j = i; j <= total_len; ++j) {
> +				k = 0;
>  				sg_init_table(sg_src, 3);
> -				sg_set_buf(&sg_src[0], input, i);
> -				sg_set_buf(&sg_src[1], input + i, j - i);
> -				sg_set_buf(&sg_src[2], input + j, total_len - j);
> +				if (i)
> +					sg_set_buf(&sg_src[k++], input, i);
> +				if (j - i)
> +					sg_set_buf(&sg_src[k++], input + i, j - i);
> +				if (total_len - j)
> +					sg_set_buf(&sg_src[k++], input + j, total_len - j);
> +				sg_init_marker(sg_src, k);
>  				memset(computed_output, 0, total_len);
>  				memset(input, 0, total_len);
>  

Reviewed-by: Eric Biggers <ebiggers@google.com>

Herbert, can you send this to Linus for 5.6?

- Eric
