Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CEB21B506A
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 00:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726006AbgDVWj1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 18:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725968AbgDVWj1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 18:39:27 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BE0B2074B;
        Wed, 22 Apr 2020 22:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587595166;
        bh=B1OMz7UfF+OAm1f+P6P94nyMDSYUzhidt60KZJsSkwY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2ej6Ofj79uPkck7o02D/ClisI64VURrJUQ7lx87XI4EuhjurRaq88cM8IwT+JQ6Mf
         t0YGDNMsLjXX1JjKnIpjkz5gFz0fELWKOOLN9JNrtsTWzKT3Xl6zYwXcYUfAeVaN2n
         sriGlQW9SGPIrH1Lmwc+4Nkfqbovrf7e/hy8hzuw=
Date:   Wed, 22 Apr 2020 15:39:25 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        stable@vger.kernel.org
Subject: Re: [PATCH crypto-stable v2] crypto: arch - limit simd usage to 4k
 chunks
Message-ID: <20200422223925.GA96474@gmail.com>
References: <20200420075711.2385190-1-Jason@zx2c4.com>
 <20200422200344.239462-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422200344.239462-1-Jason@zx2c4.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 22, 2020 at 02:03:44PM -0600, Jason A. Donenfeld wrote:
> The initial Zinc patchset, after some mailing list discussion, contained
> code to ensure that kernel_fpu_enable would not be kept on for more than
> a 4k chunk, since it disables preemption. The choice of 4k isn't totally
> scientific, but it's not a bad guess either, and it's what's used in
> both the x86 poly1305, blake2s, and nhpoly1305 code already (in the form
> of PAGE_SIZE, which this commit corrects to be explicitly 4k).
> 
> Ard did some back of the envelope calculations and found that
> at 5 cycles/byte (overestimate) on a 1ghz processor (pretty slow), 4k
> means we have a maximum preemption disabling of 20us, which Sebastian
> confirmed was probably a good limit.
> 
> Unfortunately the chunking appears to have been left out of the final
> patchset that added the glue code. So, this commit adds it back in.
> 
> Fixes: 84e03fa39fbe ("crypto: x86/chacha - expose SIMD ChaCha routine as library function")
> Fixes: b3aad5bad26a ("crypto: arm64/chacha - expose arm64 ChaCha routine as library function")
> Fixes: a44a3430d71b ("crypto: arm/chacha - expose ARM ChaCha routine as library function")
> Fixes: d7d7b8535662 ("crypto: x86/poly1305 - wire up faster implementations for kernel")
> Fixes: f569ca164751 ("crypto: arm64/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> Fixes: a6b803b3ddc7 ("crypto: arm/poly1305 - incorporate OpenSSL/CRYPTOGAMS NEON implementation")
> Fixes: 0f961f9f670e ("crypto: x86/nhpoly1305 - add AVX2 accelerated NHPoly1305")
> Fixes: 012c82388c03 ("crypto: x86/nhpoly1305 - add SSE2 accelerated NHPoly1305")
> Fixes: a00fa0c88774 ("crypto: arm64/nhpoly1305 - add NEON-accelerated NHPoly1305")
> Fixes: 16aae3595a9d ("crypto: arm/nhpoly1305 - add NEON-accelerated NHPoly1305")
> Fixes: ed0356eda153 ("crypto: blake2s - x86_64 SIMD implementation")
> Cc: Eric Biggers <ebiggers@google.com>
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Cc: stable@vger.kernel.org
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> Changes v1->v2:
>  - [Ard] Use explicit 4k chunks instead of PAGE_SIZE.
>  - [Eric] Prefer do-while over for (;;).
> 
>  arch/arm/crypto/chacha-glue.c            | 14 +++++++++++---
>  arch/arm/crypto/nhpoly1305-neon-glue.c   |  2 +-
>  arch/arm/crypto/poly1305-glue.c          | 15 +++++++++++----
>  arch/arm64/crypto/chacha-neon-glue.c     | 14 +++++++++++---
>  arch/arm64/crypto/nhpoly1305-neon-glue.c |  2 +-
>  arch/arm64/crypto/poly1305-glue.c        | 15 +++++++++++----
>  arch/x86/crypto/blake2s-glue.c           | 10 ++++------
>  arch/x86/crypto/chacha_glue.c            | 14 +++++++++++---
>  arch/x86/crypto/nhpoly1305-avx2-glue.c   |  2 +-
>  arch/x86/crypto/nhpoly1305-sse2-glue.c   |  2 +-
>  arch/x86/crypto/poly1305_glue.c          | 13 ++++++-------
>  11 files changed, 69 insertions(+), 34 deletions(-)

Can you split the nhpoly1305 changes into a separate patch?  They're a bit
different from the rest of this patch, which is fixing up the crypto library
interface that's new in v5.5.  The nhpoly1305 changes apply to v5.0 and don't
have anything to do with the crypto library interface, and they're also a bit
different since they replace PAGE_SIZE with 4K rather than unlimited with 4K.

- Eric
