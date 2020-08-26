Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A362C2530BB
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:56:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730401AbgHZN4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:56:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730377AbgHZN4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:56:34 -0400
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A65322BEA;
        Wed, 26 Aug 2020 13:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598450192;
        bh=0/lFWSsH4RVCGAcyHva9O7Jg31/lNNrAVoSxoUqNhJI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IxnANnHn1Bm4AvbZmLstcZM1sTr6itieawWuD+oSkrox1qWiOEDM4IMk0ZMoNisFE
         PXBULxchRPraIAeI/3MK4TDmVOxdesb7ymYFU9Ly1TxheWGHg9GshBJs1/bJoqU4p+
         ZoLRDzDvGQSLCuiE0LBWEtAXOgUBR3UUkD0WnLHU=
Received: by mail-oi1-f171.google.com with SMTP id k4so1587404oik.2;
        Wed, 26 Aug 2020 06:56:32 -0700 (PDT)
X-Gm-Message-State: AOAM5330Ek1NV7x8fLbzSOY1MyBSguLBPO1Y3mbQAqRGsGKFKgSqhVNI
        bo7dgkRCEGtU9CNvl19cXYMWO+1j/2Xi9A2wavI=
X-Google-Smtp-Source: ABdhPJwle7rCF3+SyAzbuFqT8TVilYDkMLKrsLA21+8YtQanwKKPDFdcN6NyYe5gh2Q6RIdugSG7PScOco7snDnVOGw=
X-Received: by 2002:a05:6808:b37:: with SMTP id t23mr4174250oij.174.1598450191762;
 Wed, 26 Aug 2020 06:56:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200826055150.2753.90553@ml01.vlan13.01.org> <b34f7644-a495-4845-0a00-0aebf4b9db52@molgen.mpg.de>
 <CAMj1kXEUQdmQDCDXPBNb3hRrbui=HVyDjCDoiFwDr+mDSjP43A@mail.gmail.com>
 <20200826114952.GA2375@gondor.apana.org.au> <CAMj1kXGjytfJEbLMbz50it3okQfiLScHB5YK2FMqR5CsmFEBbg@mail.gmail.com>
 <20200826120832.GA2996@gondor.apana.org.au> <CAOq732JaP=4X9Yh_KjER5_ctQWoauxzXTZqyFP9KsLSxvVH8=w@mail.gmail.com>
 <20200826132952.GA4752@gondor.apana.org.au>
In-Reply-To: <20200826132952.GA4752@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 26 Aug 2020 15:56:20 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHCazXbeTDfcjD=rUyLVcOqrHcHqfgOnsDWt51dALfSpg@mail.gmail.com>
Message-ID: <CAMj1kXHCazXbeTDfcjD=rUyLVcOqrHcHqfgOnsDWt51dALfSpg@mail.gmail.com>
Subject: Re: [PATCH] crypto: af_alg - Work around empty control messages
 without MSG_MORE
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Andrew Zaborowski <andrew.zaborowski@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Caleb Jorden <caljorden@hotmail.com>,
        Sasha Levin <sashal@kernel.org>, iwd@lists.01.org,
        "# 3.4.x" <stable@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 Aug 2020 at 15:30, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> The iwd daemon uses libell which sets up the skcipher operation with
> two separate control messages.  This is fine by itself but the first
> control message is sent without MSG_MORE.  This means that the first
> control message is interpreted as an empty request.
>
> While libell should be fixed to use MSG_MORE where appropriate, this
> patch works around the bug in the kernel so that existing binaries
> continue to work.
>
> We will print a warning however.
>
> Reported-by: Caleb Jorden <caljorden@hotmail.com>
> Fixes: f3c802a1f300 ("crypto: algif_aead - Only wake up when...")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>

Applied this onto v5.4.60, and it makes the iwd selftests pass again

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Tested-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index a6f581ab200c..3da21cadc326 100644
> --- a/crypto/af_alg.c
> +++ b/crypto/af_alg.c
> @@ -16,6 +16,7 @@
>  #include <linux/module.h>
>  #include <linux/net.h>
>  #include <linux/rwsem.h>
> +#include <linux/sched.h>
>  #include <linux/sched/signal.h>
>  #include <linux/security.h>
>
> @@ -846,8 +847,14 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
>
>         lock_sock(sk);
>         if (ctx->init && (init || !ctx->more)) {
> -               err = -EINVAL;
> -               goto unlock;
> +               if (ctx->used) {
> +                       err = -EINVAL;
> +                       goto unlock;
> +               }
> +
> +               pr_info_once(
> +                       "%s sent an empty control message without MSG_MORE.\n",
> +                       current->comm);
>         }
>         ctx->init = true;
>
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
