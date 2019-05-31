Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA8E830BD8
	for <lists+stable@lfdr.de>; Fri, 31 May 2019 11:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfEaJm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 May 2019 05:42:26 -0400
Received: from mail-it1-f196.google.com ([209.85.166.196]:36402 "EHLO
        mail-it1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfEaJmZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 May 2019 05:42:25 -0400
Received: by mail-it1-f196.google.com with SMTP id e184so14228478ite.1;
        Fri, 31 May 2019 02:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HhL4osx7ESpBduYF2Unw1uRF9bT1OgVQDPJAu+S7bbM=;
        b=mqRL7pQSlFTZGtxyeO3wy/9cmrkU/33+hQAmkFIq9NbunOA3bsL30A/mMJHoxDDlnl
         A+3S/kWB6G+hh/IEjY/gpipUAduje+pGUpBEsgmW/toXllExNcw6LZSCKwKeMRNOBvr9
         H4U1lPEbHlGp2CsFaAcMNMKFUbaedBleqJZ5pwVtZWuyHhrBJdMRuRsizplltzvbf1Nr
         SsfP7ah1F857CFixN1g+IDRGRtiBl5tjghOtIS+f1E42g7cv13msnsbSOPLhy9i9wetk
         g7ATnlILwIPVbjDjVPYhr8PVXKhWYJgXlVv7B54pA/gvNu0UaQIQEzSPI0lDnP5di+Ma
         /sfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HhL4osx7ESpBduYF2Unw1uRF9bT1OgVQDPJAu+S7bbM=;
        b=YA0oLS9/f/4DQnW8c28JACwswYQefycDdF0Xbb0fevjrSlG+Xzcc2aHd/+k1wfaax5
         VbfQNlBxjJb59qIo1psWIp+dj+GEwC3LI538n3aFvkJXaDzaJ4hGXZGcT8fMMld16o90
         L/+LAYbjF6fAwDq2/M/+ixS4v5MBKCBJ4uKLkrR5jh5S4yEAxYT+99BI/SWMMZr1fG0B
         VpG+8uo/2Zs26fyf267/Au+bJApCTfFTMMTXkMXL5qoT4aM1+N79wDjSdF/oarOznxcd
         gD2JQ12YGzgKuQXw0MX/mkdarB3bMbKBBZirZtym7iyOdHQQtScPEfb3nkG3bqTcHun7
         VQfQ==
X-Gm-Message-State: APjAAAXtsrx3V9BTgZRzmcojfRdIYgpvBuD1iHZev5YnLZntHEmf3nDX
        1d8FHXTXY0RipF+MVvMS8h5Aff8+dNa3jZRB9vHX5O7u
X-Google-Smtp-Source: APXvYqwkiJMj34/oANfH3YW9bzF/NQr+5I6NBsmtVf0A0U7Jfn7/2fd88CsHM5mvSyEBPrLAmzwQFYu8LP3gfpzWYaw=
X-Received: by 2002:a24:b8c2:: with SMTP id m185mr6253209ite.0.1559295744959;
 Fri, 31 May 2019 02:42:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190530175039.195574-1-ebiggers@kernel.org>
In-Reply-To: <20190530175039.195574-1-ebiggers@kernel.org>
From:   Peter Robinson <pbrobinson@gmail.com>
Date:   Fri, 31 May 2019 10:42:13 +0100
Message-ID: <CALeDE9PL0q7wGj6rJO03fzJZ4m5dnkLxvu4xgMhG0dNKWxxW2A@mail.gmail.com>
Subject: Re: [PATCH] crypto: ghash - fix unaligned memory access in ghash_setkey()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 6:51 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
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
>
> Don't fix it by setting an alignmask on the algorithm instead because
> that would unnecessarily force alignment of the data too.
>
> Fixes: 2cdc6899a88e ("crypto: ghash - Add GHASH digest algorithm for GCM")
> Reported-by: Peter Robinson <pbrobinson@gmail.com>
Tested-by: Peter Robinson <pbrobinson@gmail.com>

That fixes the problems I was seeing, thanks for the quick response/fix.

Peter

> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/ghash-generic.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/crypto/ghash-generic.c b/crypto/ghash-generic.c
> index e6307935413c1..c8a347798eae6 100644
> --- a/crypto/ghash-generic.c
> +++ b/crypto/ghash-generic.c
> @@ -34,6 +34,7 @@ static int ghash_setkey(struct crypto_shash *tfm,
>                         const u8 *key, unsigned int keylen)
>  {
>         struct ghash_ctx *ctx = crypto_shash_ctx(tfm);
> +       be128 k;
>
>         if (keylen != GHASH_BLOCK_SIZE) {
>                 crypto_shash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
> @@ -42,7 +43,12 @@ static int ghash_setkey(struct crypto_shash *tfm,
>
>         if (ctx->gf128)
>                 gf128mul_free_4k(ctx->gf128);
> -       ctx->gf128 = gf128mul_init_4k_lle((be128 *)key);
> +
> +       BUILD_BUG_ON(sizeof(k) != GHASH_BLOCK_SIZE);
> +       memcpy(&k, key, GHASH_BLOCK_SIZE); /* avoid violating alignment rules */
> +       ctx->gf128 = gf128mul_init_4k_lle(&k);
> +       memzero_explicit(&k, GHASH_BLOCK_SIZE);
> +
>         if (!ctx->gf128)
>                 return -ENOMEM;
>
> --
> 2.22.0.rc1.257.g3120a18244-goog
>
