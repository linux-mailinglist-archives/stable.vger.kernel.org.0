Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44B83973C3
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 15:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233758AbhFANGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 09:06:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233584AbhFANGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 09:06:32 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2C3DC061574;
        Tue,  1 Jun 2021 06:04:49 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id f30so21738246lfj.1;
        Tue, 01 Jun 2021 06:04:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Rw1TyoUa9aiS8Shi7TrzrzdMWGto2RvksIaQCYZQl6I=;
        b=NXHuJ3kayobjefeyL1gcrhxn0neUoipH6MHholr7LjQiFr2gmjWwp7ZWCvAO26K9sa
         BEbwTHF1YAtMFQ+Hd0U0cRrmF/f9/4Q1s5yr8Ybmrkoroaav2rR5K54bUfG5VrWAJk3J
         Db8DIH0ynKc9cEMbkrvLVSUxhr9qWY+DHM/6agm/NqN9rfox4ca4h579bvxfvZue1sym
         ewBGcga6XdL14Qb3P+6uam3A6db8VYwXoNvpotaol6sLEgQKgrOZxT+d6TCCSBt83vYq
         0591BivZEwWSmc0Z9nMR0Jsju40sRSwkAIVgmHLssXbgeh2VM5wBTsaSDoAhVZFNCZp1
         B41w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Rw1TyoUa9aiS8Shi7TrzrzdMWGto2RvksIaQCYZQl6I=;
        b=JUiPVbSdid5w5rGHYIooU+t56UvsKMsgmdcT0h0AUHOeBUHWWnxM01UocoKBVxLal2
         guM5PHiQnQxoEQD/Q1ly6Yb8ZObbF8EZOHbXzB7vRzsOfTPoZDEdR12rQfaM8X0T6OmX
         XycFOhqarJOrLUs4/YA+MtiWRcjttBnqLAHi9Gvn7iHchAhEYGWVlp9P9h81exAjjPTF
         bGlMiIj8OH2cmecAIYyyo1X9CjFfha3LlKrs9YCapL5lJfiasGVeOh0tgeFKzsANdnCP
         NOK5nF+6/skAzFRTtazgiEkzY6WZw7lhC/eRr7KZjErgQ8PZYWK6M6uPEyPHsslmC2x8
         cWXA==
X-Gm-Message-State: AOAM5337s9pP1sVGvL0YcEVUs9nTzt9u8hfPQ8onOlk+Gr53IkWZR3zz
        wU6BowhE/JpQbSM3J4YhwuvvSj6tV1WCEn9Huvg=
X-Google-Smtp-Source: ABdhPJzpLx6PUKa9dC0heVhe0p+I2YyziTvvru6/hu8N41tp08cfrvJImTuMZUJvvwgU4bAgBYUphuxvX8RwXbAwHg8=
X-Received: by 2002:a05:6512:21ae:: with SMTP id c14mr18583454lft.483.1622552688197;
 Tue, 01 Jun 2021 06:04:48 -0700 (PDT)
MIME-Version: 1.0
References: <1622467801-30957-1-git-send-email-herbert.tencent@gmail.com> <91999e12-a7de-ad4b-72c4-2376ac682c92@linux.alibaba.com>
In-Reply-To: <91999e12-a7de-ad4b-72c4-2376ac682c92@linux.alibaba.com>
From:   hongbo li <herbert.tencent@gmail.com>
Date:   Tue, 1 Jun 2021 21:04:35 +0800
Message-ID: <CABpmuw+NHufb5rV3POpuwBOyfe7few=oDG2CpOPCk0=zhXya6Q@mail.gmail.com>
Subject: Re: [PATCH] crypto: sm2 - fix a memory leak in sm2
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@kernel.org>,
        David Howells <dhowells@redhat.com>, jarkko@kernel.org,
        =?UTF-8?B?aGVyYmVydGhibGko5p2O5byY5Y2aKQ==?= 
        <herberthbli@tencent.com>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Tianjia,

Tianjia Zhang <tianjia.zhang@linux.alibaba.com> =E4=BA=8E2021=E5=B9=B46=E6=
=9C=881=E6=97=A5=E5=91=A8=E4=BA=8C =E4=B8=8A=E5=8D=8810:54=E5=86=99=E9=81=
=93=EF=BC=9A
>
> Hi Hongbo,
>
> On 5/31/21 9:30 PM, Hongbo Li wrote:
> > From: Hongbo Li <herberthbli@tencent.com>
> >
> > SM2 module alloc ec->Q in sm2_set_pub_key(), when doing alg test in
> > test_akcipher_one(), it will set public key for every test vector,
> > and don't free ec->Q. This will cause a memory leak.
> >
> > This patch alloc ec->Q in sm2_ec_ctx_init().
> >
> > Fixes: ea7ecb66440b ("crypto: sm2 - introduce OSCCA SM2 asymmetric ciph=
er algorithm")
> > Signed-off-by: Hongbo Li <herberthbli@tencent.com>
> > Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> > ---
> >   crypto/sm2.c | 24 ++++++++++--------------
> >   1 file changed, 10 insertions(+), 14 deletions(-)
> >
>
> Just add Cc: to SOB, like this:
>
>    Fixes: ea7ecb66440b (...)
>    Signed-off-by: Hongbo Li <herberthbli@tencent.com>
>    Cc: stable@vger.kernel.org # v5.10+
>    Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>
> Thanks,
> Tianjia

Thank you, I will resend the patch.
Hongbo
