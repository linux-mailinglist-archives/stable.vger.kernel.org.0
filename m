Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A31F02C745
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 15:03:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727448AbfE1ND6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 09:03:58 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:35866 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfE1ND6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 09:03:58 -0400
Received: by mail-io1-f66.google.com with SMTP id h6so7098675ioh.3
        for <stable@vger.kernel.org>; Tue, 28 May 2019 06:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Bh/N/QZBC3xi2c5BZMAnemmNFxYJ1TErCB/6n5Xk+X8=;
        b=ibi1V5DBVgTanDaBzc4vcpKjo+uo+gzCpXxoaw5Whec0p10xNV17ytUzJg/eNgvVD+
         yk1exn2HIfQiZpiTpBj6Sbw+Z3H8Acrybi01M4v2THSkE+mhkqB3Sn2iPaXRqqUDMRQ4
         GMjDH3iCH3Md1pQU7zHViowF+TQrXnOVgsSwmLCBypcxquDdXIVfDKVawDdiiu7MGjLR
         101gfrwONUcqOjIQS8n4lZXZTzL7vrWu5g15Ak5siJtxip71JvvJowxhJ2HNEXBXmNMy
         HBXcxiXAH7OKZqgx9F0fLEg/d7QTc2vl8+upTAqv9XtUb6wgkZE3/uGyEE51RYe1eRPj
         8Y8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Bh/N/QZBC3xi2c5BZMAnemmNFxYJ1TErCB/6n5Xk+X8=;
        b=CXs1TzjL1idCweyk/SEoLLRo38ZHRfFiR4pcrbLYGeaBf1Yu8X69tjBH4N99SpAu7/
         Upjr77Tf5bPsoaGCapT4DwCdDT/g7daFNy8KJGqdeXN6XlXIxzpYaX+R6layKHqwQ9Bu
         VlDyCS3y8q5PlJ3NweqO4gJ6s1MIu5hINhqlKkkao5Sb1d9q9kHZNxYuZQu9U89ae41+
         8+jkxOl9zJI6BpVQYjNDWgrsRt9frZPX7KdItV4lD2T2oc9wj1icmToh4xINgPgxfBEH
         wiI6/Uj0tPMrd/+UoIUJT6dV9e8R1fPow1Ee/uF/wvWi+dflDh0tElIi5pHSpfRwFen3
         2lwQ==
X-Gm-Message-State: APjAAAUBMuLyx+aqaS8UVnzWZLxtmSV+sFTh4uPF/aDo0m3+E7tGl132
        IqNnjVV8muq/+O7XFI85IRhXHDYawOL/VZqaKK+mXnYIWiM=
X-Google-Smtp-Source: APXvYqzf4TrvLUejClAo8NVy1VBfMi99WrxFDIKSZqyoOc05Ou/81VFSFQDwd6zFRZwhRu1SUnmsIi8HcbEYv9hknos=
X-Received: by 2002:a05:6602:2109:: with SMTP id x9mr393129iox.128.1559048637409;
 Tue, 28 May 2019 06:03:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190528124152.191773-1-lenaptr@google.com>
In-Reply-To: <20190528124152.191773-1-lenaptr@google.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 28 May 2019 15:03:44 +0200
Message-ID: <CAKv+Gu-Bzb6bucFXgW+EgU2bh9Kp-rAJWq5TSNrk7n_rMGkx9g@mail.gmail.com>
Subject: Re: [PATCH] arm64 sha1-ce finup: correct digest for empty data
To:     Elena Petrova <lenaptr@google.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 May 2019 at 14:42, Elena Petrova <lenaptr@google.com> wrote:
>
> The sha1-ce finup implementation for ARM64 produces wrong digest
> for empty input (len=0). Expected: da39a3ee..., result: 67452301...
> (initial value of SHA internal state). The error is in sha1_ce_finup:
> for empty data `finalize` will be 1, so the code is relying on
> sha1_ce_transform to make the final round. However, in
> sha1_base_do_update, the block function will not be called when
> len == 0.
>
> Fix it by setting finalize to 0 if data is empty.
>
> Fixes: 07eb54d306f4 ("crypto: arm64/sha1-ce - move SHA-1 ARMv8 implementation to base layer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Elena Petrova <lenaptr@google.com>

Thanks for the fix

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

It looks like the sha224/256 suffers from the same issue. Would you
mind sending out a fix for that as well? Thanks.

> ---
>  arch/arm64/crypto/sha1-ce-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/crypto/sha1-ce-glue.c b/arch/arm64/crypto/sha1-ce-glue.c
> index eaa7a8258f1c..0652f5f07ed1 100644
> --- a/arch/arm64/crypto/sha1-ce-glue.c
> +++ b/arch/arm64/crypto/sha1-ce-glue.c
> @@ -55,7 +55,7 @@ static int sha1_ce_finup(struct shash_desc *desc, const u8 *data,
>                          unsigned int len, u8 *out)
>  {
>         struct sha1_ce_state *sctx = shash_desc_ctx(desc);
> -       bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE);
> +       bool finalize = !sctx->sst.count && !(len % SHA1_BLOCK_SIZE) && len;
>
>         if (!crypto_simd_usable())
>                 return crypto_sha1_finup(desc, data, len, out);
> --
> 2.22.0.rc1.257.g3120a18244-goog
>
