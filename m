Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418DC1C27E2
	for <lists+stable@lfdr.de>; Sat,  2 May 2020 20:55:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgEBSzD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 May 2020 14:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728343AbgEBSzD (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 2 May 2020 14:55:03 -0400
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42C61206CD;
        Sat,  2 May 2020 18:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588445702;
        bh=qlx6o6YnRpjQRhLXhponshi87759SwhpBDJZ2YbFKmM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Tz3htpDVODHTmaRNANvzbsrKZRho7Z9BycIG4UWvU4LGj8YRWUtsBWGSzciECjcWx
         J0tt6bT9d6CxKMILAjzljZzYESSM4uf3PfRry2WWrsBpXRxdUuFO622JSciVzTvajs
         +03kqTuoI8iE42gts4CMjlQjW1lqhbc0y7X7x0OU=
Received: by mail-il1-f181.google.com with SMTP id b18so7449357ilf.2;
        Sat, 02 May 2020 11:55:02 -0700 (PDT)
X-Gm-Message-State: AGi0PuYSRBlQkG9IFalmIYmIjkZOVJkyPYdvk3dgWsQC0wS5/XiUPSVD
        GqfhKffGM7QP+UfAIV5bMNsTG1/XhGlLGY4aewY=
X-Google-Smtp-Source: APiQypKPVuN03rxQcpgWyQxj+pjAWwt3RGE0SfQMzOCdMom7E+PS6ZAi/6lONypKnF4iiYJZ88Gg8yZKF+60c/Tq0cw=
X-Received: by 2002:a92:607:: with SMTP id x7mr8522212ilg.218.1588445701655;
 Sat, 02 May 2020 11:55:01 -0700 (PDT)
MIME-Version: 1.0
References: <20200502184449.139964-1-ebiggers@kernel.org>
In-Reply-To: <20200502184449.139964-1-ebiggers@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 2 May 2020 20:54:50 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEZbUbyhHTF9i=q7eRXXf6iLoDuU0NHwbj5giDXex6WoQ@mail.gmail.com>
Message-ID: <CAMj1kXEZbUbyhHTF9i=q7eRXXf6iLoDuU0NHwbj5giDXex6WoQ@mail.gmail.com>
Subject: Re: [PATCH] crypto: lib/aes - move IRQ disabling into AES library
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 2 May 2020 at 20:44, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> The AES library code (which originally came from crypto/aes_ti.c) is
> supposed to be constant-time, to the extent possible for a C
> implementation.  But the hardening measure of disabling interrupts while
> the S-box is loaded into cache was not included in the library version;
> it was left only in the crypto API wrapper in crypto/aes_ti.c.
>
> Move this logic into the library version so that everyone gets it.
>

I don't think we should fiddle with interrupts in a general purpose
crypto library.

We /could/ add a variant aes_encrypt_irq_off() if you really want, but
this is not something you should get without asking explicitly imo.



> Fixes: e59c1c987456 ("crypto: aes - create AES library based on the fixed time AES code")
> Cc: <stable@vger.kernel.org> # v5.4+
> Cc: Ard Biesheuvel <ardb@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  crypto/aes_ti.c  | 18 ------------------
>  lib/crypto/aes.c | 18 ++++++++++++++++++
>  2 files changed, 18 insertions(+), 18 deletions(-)
>
> diff --git a/crypto/aes_ti.c b/crypto/aes_ti.c
> index 205c2c257d4926..121f36621d6dcf 100644
> --- a/crypto/aes_ti.c
> +++ b/crypto/aes_ti.c
> @@ -20,33 +20,15 @@ static int aesti_set_key(struct crypto_tfm *tfm, const u8 *in_key,
>  static void aesti_encrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>         const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
> -       unsigned long flags;
> -
> -       /*
> -        * Temporarily disable interrupts to avoid races where cachelines are
> -        * evicted when the CPU is interrupted to do something else.
> -        */
> -       local_irq_save(flags);
>
>         aes_encrypt(ctx, out, in);
> -
> -       local_irq_restore(flags);
>  }
>
>  static void aesti_decrypt(struct crypto_tfm *tfm, u8 *out, const u8 *in)
>  {
>         const struct crypto_aes_ctx *ctx = crypto_tfm_ctx(tfm);
> -       unsigned long flags;
> -
> -       /*
> -        * Temporarily disable interrupts to avoid races where cachelines are
> -        * evicted when the CPU is interrupted to do something else.
> -        */
> -       local_irq_save(flags);
>
>         aes_decrypt(ctx, out, in);
> -
> -       local_irq_restore(flags);
>  }
>
>  static struct crypto_alg aes_alg = {
> diff --git a/lib/crypto/aes.c b/lib/crypto/aes.c
> index 827fe89922fff0..029d8d0eac1f6e 100644
> --- a/lib/crypto/aes.c
> +++ b/lib/crypto/aes.c
> @@ -260,6 +260,7 @@ void aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
>         const u32 *rkp = ctx->key_enc + 4;
>         int rounds = 6 + ctx->key_length / 4;
>         u32 st0[4], st1[4];
> +       unsigned long flags;
>         int round;
>
>         st0[0] = ctx->key_enc[0] ^ get_unaligned_le32(in);
> @@ -267,6 +268,12 @@ void aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
>         st0[2] = ctx->key_enc[2] ^ get_unaligned_le32(in + 8);
>         st0[3] = ctx->key_enc[3] ^ get_unaligned_le32(in + 12);
>
> +       /*
> +        * Temporarily disable interrupts to avoid races where cachelines are
> +        * evicted when the CPU is interrupted to do something else.
> +        */
> +       local_irq_save(flags);
> +
>         /*
>          * Force the compiler to emit data independent Sbox references,
>          * by xoring the input with Sbox values that are known to add up
> @@ -297,6 +304,8 @@ void aes_encrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
>         put_unaligned_le32(subshift(st1, 1) ^ rkp[5], out + 4);
>         put_unaligned_le32(subshift(st1, 2) ^ rkp[6], out + 8);
>         put_unaligned_le32(subshift(st1, 3) ^ rkp[7], out + 12);
> +
> +       local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL(aes_encrypt);
>
> @@ -311,6 +320,7 @@ void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
>         const u32 *rkp = ctx->key_dec + 4;
>         int rounds = 6 + ctx->key_length / 4;
>         u32 st0[4], st1[4];
> +       unsigned long flags;
>         int round;
>
>         st0[0] = ctx->key_dec[0] ^ get_unaligned_le32(in);
> @@ -318,6 +328,12 @@ void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
>         st0[2] = ctx->key_dec[2] ^ get_unaligned_le32(in + 8);
>         st0[3] = ctx->key_dec[3] ^ get_unaligned_le32(in + 12);
>
> +       /*
> +        * Temporarily disable interrupts to avoid races where cachelines are
> +        * evicted when the CPU is interrupted to do something else.
> +        */
> +       local_irq_save(flags);
> +
>         /*
>          * Force the compiler to emit data independent Sbox references,
>          * by xoring the input with Sbox values that are known to add up
> @@ -348,6 +364,8 @@ void aes_decrypt(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in)
>         put_unaligned_le32(inv_subshift(st1, 1) ^ rkp[5], out + 4);
>         put_unaligned_le32(inv_subshift(st1, 2) ^ rkp[6], out + 8);
>         put_unaligned_le32(inv_subshift(st1, 3) ^ rkp[7], out + 12);
> +
> +       local_irq_restore(flags);
>  }
>  EXPORT_SYMBOL(aes_decrypt);
>
> --
> 2.26.2
>
