Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99A202C8E3
	for <lists+stable@lfdr.de>; Tue, 28 May 2019 16:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbfE1Ogi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 May 2019 10:36:38 -0400
Received: from mail-it1-f195.google.com ([209.85.166.195]:52417 "EHLO
        mail-it1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726425AbfE1Ogi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 May 2019 10:36:38 -0400
Received: by mail-it1-f195.google.com with SMTP id t184so4732184itf.2
        for <stable@vger.kernel.org>; Tue, 28 May 2019 07:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BBDKO8EMJjZWQxMXL1xSwnjCZ+AQSkiGLjl7m48b9A0=;
        b=rF95Z0N5QLTFBHs3BTxtcbdrh8/unoYwP93vjrLBUrBizEAkTMTsd/byG2IAdwa0ig
         czH2P3ZpcIoef72BQ7Fd7b13d+s3a4iosZj/hnOHpmn5sGD3PCtpZVltKDbymGXGgQgj
         vnkyXGqsYeB+XllrC5BheaJ77PMTmgwcso9rrRmq1sPt7e2+RN3I4ERmwZzeFyzIRN4j
         SwpR3D9y2plr5JL3E/+l3n/Slpy4BPVMfgSpZpZatoJuSrBS8Es8vLro8YrjCVw3sGHx
         vT0ipIPcRZB3qXK7Eadp+SMr6A4dDvsbA2A3EioYSjth9hl9SHdaKFE9HrQuWo3ktymj
         OnFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BBDKO8EMJjZWQxMXL1xSwnjCZ+AQSkiGLjl7m48b9A0=;
        b=qx6g76Kls/h0nOxBYUUEyqHVVgBB95MSh9bcXH96dqa1lpOQ7RjiRQ7p9uH+pBuQwd
         Biwcr+0PRrI9zTAiXuvcIJ+rdFTO572CfQ4XU9H9FCuWYg1OAEvH8UAR76kfshTnzZFD
         tLeXF493tpEx8HsZptcmb1qa77Rfrhk4oMJIv+OUgMyYrfIh6sAb5BL4wLao4bTWwlYy
         U5wos3YqLGTqfTn6dooNrhRgZ/JFxqDrrqdgo/XTjCvljgKxPeC+yMt1AAmU/wTPq0o4
         VAwnMgaOs2p0RUz8R8dynaQqR+qUNaM35CFAopf1+nWaWQ4Kc7y94FY9Jvy8oac/F67l
         wP8Q==
X-Gm-Message-State: APjAAAV+i0Ztb8nIaBs63eS+itWP/mBiywmCTCYdN3CgQkN4RNXnbI5J
        l3uaLfXPQib4y1KHXT5rLaH7o7SqZdh8V4l4tNFOTg==
X-Google-Smtp-Source: APXvYqzt8rxhLzvnhfn/gd7KNM3Ie6fghJlq+EY+LGmtpGCtOuJ78lbZ/iL1v023Ym80gKxfsMuN/dDr8sX3fcygp8c=
X-Received: by 2002:a24:ca84:: with SMTP id k126mr3191038itg.104.1559054197632;
 Tue, 28 May 2019 07:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190528143506.212198-1-lenaptr@google.com>
In-Reply-To: <20190528143506.212198-1-lenaptr@google.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 28 May 2019 16:36:25 +0200
Message-ID: <CAKv+Gu9+79HV3EvTGpqJS8nCbfZ22xtvUbJ5XyMuuF9bR+Nysw@mail.gmail.com>
Subject: Re: [PATCH] arm64 sha2-ce finup: correct digest for empty data
To:     Elena Petrova <lenaptr@google.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 28 May 2019 at 16:35, Elena Petrova <lenaptr@google.com> wrote:
>
> The sha256-ce finup implementation for ARM64 produces wrong digest
> for empty input (len=0). Expected: the actual digest, result: initial
> value of SHA internal state. The error is in sha256_ce_finup:
> for empty data `finalize` will be 1, so the code is relying on
> sha2_ce_transform to make the final round. However, in
> sha256_base_do_update, the block function will not be called when
> len == 0.
>
> Fix it by setting finalize to 0 if data is empty.
>
> Fixes: 03802f6a80b3a ("crypto: arm64/sha2-ce - move SHA-224/256 ARMv8 implementation to base layer")
> Cc: stable@vger.kernel.org
> Signed-off-by: Elena Petrova <lenaptr@google.com>

Thanks again

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

> ---
>  arch/arm64/crypto/sha2-ce-glue.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm64/crypto/sha2-ce-glue.c b/arch/arm64/crypto/sha2-ce-glue.c
> index a725997e55f2..6a5ade974a35 100644
> --- a/arch/arm64/crypto/sha2-ce-glue.c
> +++ b/arch/arm64/crypto/sha2-ce-glue.c
> @@ -60,7 +60,7 @@ static int sha256_ce_finup(struct shash_desc *desc, const u8 *data,
>                            unsigned int len, u8 *out)
>  {
>         struct sha256_ce_state *sctx = shash_desc_ctx(desc);
> -       bool finalize = !sctx->sst.count && !(len % SHA256_BLOCK_SIZE);
> +       bool finalize = !sctx->sst.count && !(len % SHA256_BLOCK_SIZE) && len;
>
>         if (!crypto_simd_usable()) {
>                 if (len)
> --
> 2.22.0.rc1.257.g3120a18244-goog
>
