Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3D118A9BE
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 01:24:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgCSAYB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 20:24:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:42546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCSAYB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 20:24:01 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C750F20752;
        Thu, 19 Mar 2020 00:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584577441;
        bh=0vdNI3zdOZYO15DNPzJWaw/gXCPtXsJdCvTlVIpkfzQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mxcox9aXkzstejxFuEVygjr0iaFm4anRJcctriq+2/v5tV0Uh5CgjcXOADCqCL7go
         8bIyenuI+0yr8tSS0D5xQiEaz0LqqJVt4Urn7qh2Or85EK8dfzvo/WM63O3MEgMqHX
         N4ZuOZhoswsNVR9eu8nXXvdy4eaSHchMvGOeMZ8Q=
Date:   Wed, 18 Mar 2020 17:23:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        gregkh@linuxfoundation.org, herbert@gondor.apana.org.au,
        Emil Renner Berthing <kernel@esmil.dk>,
        Ard Biesheuvel <ardb@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH URGENT crypto] crypto: arm64/chacha - correctly walk
 through blocks
Message-ID: <20200319002359.GF2334@sol.localdomain>
References: <20200318234518.83906-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318234518.83906-1-Jason@zx2c4.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Jason,

On Wed, Mar 18, 2020 at 05:45:18PM -0600, Jason A. Donenfeld wrote:
> Prior, passing in chunks of 2, 3, or 4, followed by any additional
> chunks would result in the chacha state counter getting out of sync,
> resulting in incorrect encryption/decryption, which is a pretty nasty
> crypto vuln, dating back to 2018. WireGuard users never experienced this
> prior, because we have always, out of tree, used a different crypto
> library, until the recent Frankenzinc addition. This commit fixes the
> issue by advancing the pointers and state counter by the actual size
> processed.
> 
> Fixes: f2ca1cbd0fb5 ("crypto: arm64/chacha - optimize for arbitrary length inputs")
> Reported-and-tested-by: Emil Renner Berthing <kernel@esmil.dk>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: stable@vger.kernel.org

Thanks for fixing this!  We definitely should get this fix to Linus for 5.6.
But I don't think your description of this bug dating back to 2018 is accurate,
because this bug only affects the new library interface to ChaCha20 which was
added in v5.5.  In the "regular" crypto API case, the "walksize" is set to
'5 * CHACHA_BLOCK_SIZE', and chacha_doneon() is guaranteed to be called with a
multiple of '5 * CHACHA_BLOCK_SIZE' except at the end.  Thus the code worked
fine with the regular crypto API.

In fact we have fuzz tests for the regular crypto API which find bugs exactly
like these.  For example, they try dividing the data up randomly into chunks.
It would be great if the new library interface had fuzz tests too.

> diff --git a/arch/arm64/crypto/chacha-neon-glue.c b/arch/arm64/crypto/chacha-neon-glue.c
> index c1f9660d104c..debb1de0d3dd 100644
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
> +		state[12] += round_up(l, CHACHA_BLOCK_SIZE) / CHACHA_BLOCK_SIZE;

Use DIV_ROUND_UP(l, CHACHA_BLOCK_SIZE)?

- Eric
