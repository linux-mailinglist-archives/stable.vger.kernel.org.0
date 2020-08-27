Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD9B253F61
	for <lists+stable@lfdr.de>; Thu, 27 Aug 2020 09:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgH0HkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Aug 2020 03:40:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:55032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727048AbgH0HkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Aug 2020 03:40:13 -0400
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F31BB207DF;
        Thu, 27 Aug 2020 07:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598514013;
        bh=/LiQYxCbDRGQBK25FV+ZZG7qakAtgDGsZ/+d3lypKE0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=syBaQFvdoCiwgk7cVCOoYQ+yK4EBv+0aZ2hy5ghEl8r/qQ5Z4FU6h824YwanRok7K
         KaUG2O0Vm2LibzQ+/5O89Bmyk58mblOaiwFF1wC23osJy25NNGHGql7ows/EHD9dok
         SNKgvkLIoQZRoWrFwzjjGKMFvjeSRzU/IM5v7eJc=
Received: by mail-ot1-f48.google.com with SMTP id 5so3635930otp.12;
        Thu, 27 Aug 2020 00:40:12 -0700 (PDT)
X-Gm-Message-State: AOAM530Cd89Tua0V1P4re960xrULsCQ57qfRzSEeIhU9908l1tLhvLe9
        sPypxUpV7hWSqdQZEyUYEc0OKuMq3K73gKBcKmE=
X-Google-Smtp-Source: ABdhPJx9MYGrgNv1LMEanHPE4j55h5as3tyjvP5RGGgX2ze5HBi/cvqEI0eE3Io6ZwbEUHdecsRxhxrSDhBEJFj2AQs=
X-Received: by 2002:a9d:5189:: with SMTP id y9mr7188086otg.77.1598514012179;
 Thu, 27 Aug 2020 00:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAMj1kXGjytfJEbLMbz50it3okQfiLScHB5YK2FMqR5CsmFEBbg@mail.gmail.com>
 <20200826120832.GA2996@gondor.apana.org.au> <CAOq732JaP=4X9Yh_KjER5_ctQWoauxzXTZqyFP9KsLSxvVH8=w@mail.gmail.com>
 <20200826130010.GA3232@gondor.apana.org.au> <c27e5303-48d9-04a4-4e73-cfea5470f357@gmail.com>
 <20200826141907.GA5111@gondor.apana.org.au> <4bb6d926-a249-8183-b3d9-05b8e1b7808a@gmail.com>
 <CAMj1kXEn507bEt+eT6q7MpCwNH=oAZsTkFRz0t=kPEV0QxFsOQ@mail.gmail.com>
 <20200826221913.GA16175@gondor.apana.org.au> <CAMj1kXH-qZZhw5D5sBEVFP9=Z04pU+xCnQ78sDDw6WuSM-pRGQ@mail.gmail.com>
 <20200827071436.GA30281@gondor.apana.org.au>
In-Reply-To: <20200827071436.GA30281@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 27 Aug 2020 09:40:01 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGJWRXu1Mx=ObTkztTdBQusv0N8o-cH1f+KM7d7geD20w@mail.gmail.com>
Message-ID: <CAMj1kXGJWRXu1Mx=ObTkztTdBQusv0N8o-cH1f+KM7d7geD20w@mail.gmail.com>
Subject: Re: [v2 PATCH] crypto: af_alg - Work around empty control messages
 without MSG_MORE
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Denis Kenzior <denkenz@gmail.com>,
        Andrew Zaborowski <andrew.zaborowski@intel.com>,
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

On Thu, 27 Aug 2020 at 09:15, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 27, 2020 at 08:40:01AM +0200, Ard Biesheuvel wrote:
> >
> > It is part of iwd - just build that and run 'make check'
> >
> > With your patch applied, the occurrence of sendmsg() in
> > operate_cipher() triggers the warn_once(), but if I add MSG_MORE
> > there, the test hangs.
>
> I see.  This is a different issue.  The original kernel change
> was a bit too strict here and it is barfing at the fact that two
> successive sendmsg's of the same request both contain a control
> message.
>
> Here's an updated patch to allow this.
>
> ---8<---
> The iwd daemon uses libell which sets up the skcipher operation with
> two separate control messages.  As the first control message is sent
> without MSG_MORE, it is interpreted as an empty request.
>
> While libell should be fixed to use MSG_MORE where appropriate, this
> patch works around the bug in the kernel so that existing binaries
> continue to work.
>
> We will print a warning however.
>
> A separate issue is that the new kernel code no longer allows the
> control message to be sent twice within the same request.  This
> restriction is obviously incompatible with what iwd was doing (first
> setting an IV and then sending the real control message).  This
> patch changes the kernel so that this is explicitly allowed.
>
> Reported-by: Caleb Jorden <caljorden@hotmail.com>
> Fixes: f3c802a1f300 ("crypto: algif_aead - Only wake up when...")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> diff --git a/crypto/af_alg.c b/crypto/af_alg.c
> index a6f581ab200c..8be8bec07cdd 100644
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
> @@ -845,9 +846,15 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
>         }
>
>         lock_sock(sk);
> -       if (ctx->init && (init || !ctx->more)) {
> -               err = -EINVAL;
> -               goto unlock;
> +       if (ctx->init && !ctx->more) {
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

Yep, that works.
