Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF5F3AABAD
	for <lists+stable@lfdr.de>; Thu, 17 Jun 2021 08:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhFQGKb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Jun 2021 02:10:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbhFQGKa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Jun 2021 02:10:30 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF8F5C061574;
        Wed, 16 Jun 2021 23:08:22 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4G5BSJ40jBz9sSn;
        Thu, 17 Jun 2021 16:08:16 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1623910098;
        bh=hVSqDU1BBeAnmrNw6zEidn4Sen3Yd1tIwA02D0sarGQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=oZZoiBeVQr61j2bwMuugaKP9gv5ITKpktufP160mgBAmaarcFH8bPXbdJ5s5ZAoT7
         68SUZpMPCycXQb4uZ+AqRADj/OQdoSYJqDG4hYoefgWjS0qZPtMny18lrv1bnWbnGs
         KBOE5Mko05q8bQdSFjqPAZizL+y7tz+XE6RsTtBK58oVtL0mWznrq5K0szKgbLprNl
         Z2mnxDi277OL/yq/XSkTEPwus9+Y6U5LpWAEUvgYl5ngSjQplmDenWM0kYCDcyyNHl
         F+wAZD7749u+k4C1USPD+m0b5eb8oHPeBRu1X7PoJNLikR6YONWawdwD8yIVLS7tIK
         85QrKv0/sir6g==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Kees Cook <keescook@chromium.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org,
        Breno =?utf-8?Q?Leit=C3=A3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH] crypto: nx: Fix memcpy() over-reading in nonce
In-Reply-To: <20210616203459.1248036-1-keescook@chromium.org>
References: <20210616203459.1248036-1-keescook@chromium.org>
Date:   Thu, 17 Jun 2021 16:08:15 +1000
Message-ID: <87zgvpqb00.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> Fix typo in memcpy() where size should be CTR_RFC3686_NONCE_SIZE.
>
> Fixes: 030f4e968741 ("crypto: nx - Fix reentrancy bugs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kees Cook <keescook@chromium.org>

Thanks.

> ---
>  drivers/crypto/nx/nx-aes-ctr.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/nx/nx-aes-ctr.c b/drivers/crypto/nx/nx-aes-ctr.c
> index 13f518802343..6120e350ff71 100644
> --- a/drivers/crypto/nx/nx-aes-ctr.c
> +++ b/drivers/crypto/nx/nx-aes-ctr.c
> @@ -118,7 +118,7 @@ static int ctr3686_aes_nx_crypt(struct skcipher_request *req)
>  	struct nx_crypto_ctx *nx_ctx = crypto_skcipher_ctx(tfm);
>  	u8 iv[16];
>  
> -	memcpy(iv, nx_ctx->priv.ctr.nonce, CTR_RFC3686_IV_SIZE);
> +	memcpy(iv, nx_ctx->priv.ctr.nonce, CTR_RFC3686_NONCE_SIZE);
>  	memcpy(iv + CTR_RFC3686_NONCE_SIZE, req->iv, CTR_RFC3686_IV_SIZE);
>  	iv[12] = iv[13] = iv[14] = 0;
>  	iv[15] = 1;

Where IV_SIZE is 8 and NONCE_SIZE is 4.

And iv is 16 bytes, so it's not a buffer overflow.

But priv.ctr.nonce is 4 bytes, and at the end of the struct, so it reads
4 bytes past the end of the nx_crypto_ctx, which is not good.

But then immediately overwrites whatever it read with req->iv.

So seems pretty harmless in practice?

cheers
