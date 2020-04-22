Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C91E1B35E3
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 06:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725787AbgDVEES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 00:04:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:36458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbgDVEES (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 00:04:18 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 626AF206EC;
        Wed, 22 Apr 2020 04:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587528257;
        bh=R50vllRGiQsBJ4Aew3sRKSSCruehTtz3DQqv/n93hNM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oLnolN4n3W0qfa33jBbew2yBYuAnakUYs7omwV98FryoaPMJV7me5S/It2jiD/eod
         VneXTzDyJl1rkZ4eRKvebq4EwhkN0QceSOCed0MRqQ2FcUpDXFvcc6C8Qz92n+Gwox
         nFX6Tk0k8zatHLfutLngG+aNV9NaJclM54FwYUbo=
Date:   Tue, 21 Apr 2020 21:04:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, ardb@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH crypto-stable] crypto: arch/lib - limit simd usage to
 PAGE_SIZE chunks
Message-ID: <20200422040415.GA2881@sol.localdomain>
References: <20200420075711.2385190-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420075711.2385190-1-Jason@zx2c4.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 20, 2020 at 01:57:11AM -0600, Jason A. Donenfeld wrote:
> The initial Zinc patchset, after some mailing list discussion, contained
> code to ensure that kernel_fpu_enable would not be kept on for more than
> a PAGE_SIZE chunk, since it disables preemption. The choice of PAGE_SIZE
> isn't totally scientific, but it's not a bad guess either, and it's
> what's used in both the x86 poly1305 and blake2s library code already.
> Unfortunately it appears to have been left out of the final patchset
> that actually added the glue code. So, this commit adds back the
> PAGE_SIZE chunking.
> 
> Fixes: 84e03fa39fbe ("crypto: x86/chacha - expose SIMD ChaCha routine as library function")
> Fixes: b3aad5bad26a ("crypto: arm64/chacha - expose arm64 ChaCha routine as library function")
> Fixes: a44a3430d71b ("crypto: arm/chacha - expose ARM ChaCha routine as library function")
> Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> Fixes: a6b803b3ddc7 ("crypto: arm/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Eric, Ard - I'm wondering if this was in fact just an oversight in Ard's
> patches, or if there was actually some later discussion in which we
> concluded that the PAGE_SIZE chunking wasn't required, perhaps because
> of FPU changes. If that's the case, please do let me know, in which case
> I'll submit a _different_ patch that removes the chunking from x86 poly
> and blake. I can't find any emails that would indicate that, but I might
> be mistaken.
> 
>  arch/arm/crypto/chacha-glue.c        | 16 +++++++++++++---
>  arch/arm/crypto/poly1305-glue.c      | 17 +++++++++++++----
>  arch/arm64/crypto/chacha-neon-glue.c | 16 +++++++++++++---
>  arch/arm64/crypto/poly1305-glue.c    | 17 +++++++++++++----
>  arch/x86/crypto/chacha_glue.c        | 16 +++++++++++++---
>  5 files changed, 65 insertions(+), 17 deletions(-)

I don't think you're missing anything.  On x86, kernel_fpu_begin() and
kernel_fpu_end() did get optimized in v5.2.  But they still disable preemption,
which is the concern here.

> 
> diff --git a/arch/arm/crypto/chacha-glue.c b/arch/arm/crypto/chacha-glue.c
> index 6fdb0ac62b3d..0e29ebac95fd 100644
> --- a/arch/arm/crypto/chacha-glue.c
> +++ b/arch/arm/crypto/chacha-glue.c
> @@ -91,9 +91,19 @@ void chacha_crypt_arch(u32 *state, u8 *dst, const u8 *src, unsigned int bytes,
>  		return;
>  	}
>  
> -	kernel_neon_begin();
> -	chacha_doneon(state, dst, src, bytes, nrounds);
> -	kernel_neon_end();
> +	for (;;) {
> +		unsigned int todo = min_t(unsigned int, PAGE_SIZE, bytes);
> +
> +		kernel_neon_begin();
> +		chacha_doneon(state, dst, src, todo, nrounds);
> +		kernel_neon_end();
> +
> +		bytes -= todo;
> +		if (!bytes)
> +			break;
> +		src += todo;
> +		dst += todo;
> +	}
>  }
>  EXPORT_SYMBOL(chacha_crypt_arch);

Seems this should just be a 'while' loop?

	while (bytes) {
		unsigned int todo = min_t(unsigned int, PAGE_SIZE, bytes);

		kernel_neon_begin();
		chacha_doneon(state, dst, src, todo, nrounds);
		kernel_neon_end();

		bytes -= todo;
		src += todo;
		dst += todo;
	}

Likewise elsewhere in this patch.  (For Poly1305, len >= POLY1305_BLOCK_SIZE at
the beginning, so that could use a 'do' loop.)

- Eric
