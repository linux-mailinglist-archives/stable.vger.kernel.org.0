Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9381932978
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 09:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbfFCH1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 03:27:31 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:27831 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726956AbfFCH1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 03:27:31 -0400
Received: from localhost (mailhub1-int [192.168.12.234])
        by localhost (Postfix) with ESMTP id 45HRTM1MJ0z9txrs;
        Mon,  3 Jun 2019 09:27:19 +0200 (CEST)
Authentication-Results: localhost; dkim=pass
        reason="1024-bit key; insecure key"
        header.d=c-s.fr header.i=@c-s.fr header.b=TNCSahey; dkim-adsp=pass;
        dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
Received: from pegase1.c-s.fr ([192.168.12.234])
        by localhost (pegase1.c-s.fr [192.168.12.234]) (amavisd-new, port 10024)
        with ESMTP id EkNaZE1SsL4v; Mon,  3 Jun 2019 09:27:19 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
        by pegase1.c-s.fr (Postfix) with ESMTP id 45HRTM0GRPz9txrq;
        Mon,  3 Jun 2019 09:27:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
        t=1559546839; bh=y4yWGiBs4AVaPkQMeBun7TOFr1uohDtRZ02pj0yDyCE=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=TNCSahey5JC9LWgbW3e1bcDRql89qbHWBTW25XvUxSxPPFXy2itMd3Hs0H0bUyhq+
         e6mwel6/ODZK7TATmQwh7L4fvIrozErwyj2oL1qEzoz5z86qjvTnJuVV7sHBJrC7Ix
         GFYSemOr6uoEJTYlsXbJsZy0rBIElzTWSPiT0AWw=
Received: from localhost (localhost [127.0.0.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 9BC9B8B7B1;
        Mon,  3 Jun 2019 09:27:23 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
        by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
        with ESMTP id e1C1R_Rcnar6; Mon,  3 Jun 2019 09:27:23 +0200 (CEST)
Received: from PO15451 (po15451.idsi0.si.c-s.fr [172.25.231.1])
        by messagerie.si.c-s.fr (Postfix) with ESMTP id 6B44E8B7A1;
        Mon,  3 Jun 2019 09:27:23 +0200 (CEST)
Subject: Re: [PATCH] crypto: ghash - fix unaligned memory access in
 ghash_setkey()
To:     Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Peter Robinson <pbrobinson@gmail.com>, stable@vger.kernel.org
References: <20190530175039.195574-1-ebiggers@kernel.org>
From:   Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <0f7e6d3d-aa27-30c3-5c82-67d484bf667c@c-s.fr>
Date:   Mon, 3 Jun 2019 09:27:24 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190530175039.195574-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le 30/05/2019 à 19:50, Eric Biggers a écrit :
> From: Eric Biggers <ebiggers@google.com>
> 
> Changing ghash_mod_init() to be subsys_initcall made it start running
> before the alignment fault handler has been installed on ARM.  In kernel
> builds where the keys in the ghash test vectors happened to be
> misaligned in the kernel image, this exposed the longstanding bug that
> ghash_setkey() is incorrectly casting the key buffer (which can have any
> alignment) to be128 for passing to gf128mul_init_4k_lle().
> 
> Fix this by memcpy()ing the key to a temporary buffer.

Shouldn't we make it dependent on CONFIG_HAVE_64BIT_ALIGNED_ACCESS or 
!CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS ?

Christophe

> 
> Don't fix it by setting an alignmask on the algorithm instead because
> that would unnecessarily force alignment of the data too.
> 
> Fixes: 2cdc6899a88e ("crypto: ghash - Add GHASH digest algorithm for GCM")
> Reported-by: Peter Robinson <pbrobinson@gmail.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   crypto/ghash-generic.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
> index e6307935413c1..c8a347798eae6 100644
> --- a/crypto/ghash-generic.c
> +++ b/crypto/ghash-generic.c
> @@ -34,6 +34,7 @@ static int ghash_setkey(struct crypto_shash *tfm,
>   			const u8 *key, unsigned int keylen)
>   {
>   	struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
> +	be128 k;
>   
>   	if (keylen != GHASH_BLOCK_SIZE) {
>   		crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> @@ -42,7 +43,12 @@ static int ghash_setkey(struct crypto_shash *tfm,
>   
>   	if (ctx->gf128)
>   		gf128mul_free_4k(ctx->gf128);
> -	ctx->gf128 = gf128mul_init_4k_lle((be128 *)key);
> +
> +	BUILD_BUG_ON(sizeof(k) != GHASH_BLOCK_SIZE);
> +	memcpy(&k, key, GHASH_BLOCK_SIZE); /* avoid violating alignment rules */
> +	ctx->gf128 = gf128mul_init_4k_lle(&k);
> +	memzero_explicit(&k, GHASH_BLOCK_SIZE);
> +
>   	if (!ctx->gf128)
>   		return -ENOMEM;
>   
> 
