Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDBB23877E2
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 13:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348812AbhERLmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 07:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348769AbhERLmA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 07:42:00 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D02FC061573;
        Tue, 18 May 2021 04:40:41 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id a8so945287ioa.12;
        Tue, 18 May 2021 04:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=TREpcWQl6SkXU344K7y82w1x4KaFiK36OPUcoY0ELPg=;
        b=VfHpvStNnG5inCIfLjjrmo+8EZGNTzmkohwTK8+hVZ8t/ctcBWxXy6W1Dw+oRQEwrV
         WNpgNfsJkWFc2MPnhAE1BZztieRJ2EK1RgkiouZnc2ppBHBLeKjY84gfsOao0Bt/h2mj
         FlXoXUwweIzctX2TKayk5l9e69uxX/tim+qu3M+VGaPs6D2cafjdgdREOe0GZBQiB8VR
         KnvCleevnYeJy2we8H9ERbSV2QQdHyMRQjtyabnzwgGE++U27CtqE1LLBKwVJEayLIdW
         7skNVldOBGWXStoN2khHkXrFKe7WnCmSMXLAJM6DUpzih3TZwsukBRujZbFuCK/nEDck
         3B+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=TREpcWQl6SkXU344K7y82w1x4KaFiK36OPUcoY0ELPg=;
        b=pWpNwek43dc9pmEHKC5qjAUqacbq3Zjp1+XGWo/zbKIkoDC5K4weNSs64+/7BZqAb2
         /0vBT8pM8z9++1sp/4pAbIqXOFbtqKCx7VC+liv73EKYM+QhDa/Xy+eH6F/EFKBiEOIQ
         vtC6yaemKM0uRi93lWHyrkzAripu2aFu1CwIhWze3SKE41zOe7yOhC1VX7AP9L9xQ+vJ
         +TDfZNwF4fDDXyULIgMavXCCG6CZ6h0eTSia1Rt0QBeFjqBaikgn6zc0IuNKNWidVmHc
         kN/AiM1YT8ZN039FuEa0SJFGehZSIjEYGYQAd1nY0rKfbWqCWVZw9EuaUKQH1KFS3aVE
         ggNQ==
X-Gm-Message-State: AOAM531ap9DEPLvr13YwtnD+BTvMdZocc2gHy2EOMl5dVB7v4Evt/cYi
        e5m+rtaVtSxpS4eISdp95nMhHuDAtfKYD/BlAD4=
X-Google-Smtp-Source: ABdhPJw1SUMFO66CimuyVB0EtqFRidGuV+Fqnab54rg4xiAZWOAUFblUzRGkyVeQcBs7DG21kMGROebLwkGCdJP82Dc=
X-Received: by 2002:a6b:f311:: with SMTP id m17mr3795220ioh.162.1621338040706;
 Tue, 18 May 2021 04:40:40 -0700 (PDT)
MIME-Version: 1.0
References: <1620828254-25545-1-git-send-email-herbert.tencent@gmail.com>
 <1620828254-25545-2-git-send-email-herbert.tencent@gmail.com> <246ad441-76c9-0934-d132-42d263d63195@linux.alibaba.com>
In-Reply-To: <246ad441-76c9-0934-d132-42d263d63195@linux.alibaba.com>
From:   hongbo li <herbert.tencent@gmail.com>
Date:   Tue, 18 May 2021 19:40:30 +0800
Message-ID: <CABpmuwJ1-cMWikSz4g41B6CDSPvUrbg8X=No-1EFuawMB5K2aQ@mail.gmail.com>
Subject: Re: [PATCH 1/7] crypto: fix a memory leak in sm2
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Howells <dhowells@redhat.com>, jarkko@kernel.org,
        herberthbli@tencent.com, stable@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Tianjia Zhang <tianjia.zhang@linux.alibaba.com> =E4=BA=8E2021=E5=B9=B45=E6=
=9C=8814=E6=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8B=E5=8D=8812:52=E5=86=99=E9=81=
=93=EF=BC=9A
>
> Hi Hongbo,
>
> On 5/12/21 10:04 PM, Hongbo Li wrote:
> > From: Hongbo Li <herberthbli@tencent.com>
> >
> > SM2 module alloc ec->Q in sm2_set_pub_key(), when doing alg test in
> > test_akcipher_one(), it will set public key for every test vector,
> > and don't free ec->Q. This will cause a memory leak.
> >
> > This patch alloc ec->Q in sm2_ec_ctx_init().
> >
> > Signed-off-by: Hongbo Li <herberthbli@tencent.com>
> > ---
> >   crypto/sm2.c | 24 ++++++++++--------------
> >   1 file changed, 10 insertions(+), 14 deletions(-)
> >
> > diff --git a/crypto/sm2.c b/crypto/sm2.c
> > index b21addc..db8a4a2 100644
> > --- a/crypto/sm2.c
> > +++ b/crypto/sm2.c
> > @@ -79,10 +79,17 @@ static int sm2_ec_ctx_init(struct mpi_ec_ctx *ec)
> >               goto free;
> >
> >       rc =3D -ENOMEM;
> > +
> > +     ec->Q =3D mpi_point_new(0);
> > +     if (!ec->Q)
> > +             goto free;
> > +
> >       /* mpi_ec_setup_elliptic_curve */
> >       ec->G =3D mpi_point_new(0);
> > -     if (!ec->G)
> > +     if (!ec->G) {
> > +             mpi_point_release(ec->Q);
> >               goto free;
> > +     }
> >
> >       mpi_set(ec->G->x, x);
> >       mpi_set(ec->G->y, y);
> > @@ -91,6 +98,7 @@ static int sm2_ec_ctx_init(struct mpi_ec_ctx *ec)
> >       rc =3D -EINVAL;
> >       ec->n =3D mpi_scanval(ecp->n);
> >       if (!ec->n) {
> > +             mpi_point_release(ec->Q);
> >               mpi_point_release(ec->G);
> >               goto free;
> >       }
> > @@ -386,27 +394,15 @@ static int sm2_set_pub_key(struct crypto_akcipher=
 *tfm,
> >       MPI a;
> >       int rc;
> >
> > -     ec->Q =3D mpi_point_new(0);
> > -     if (!ec->Q)
> > -             return -ENOMEM;
> > -
> >       /* include the uncompressed flag '0x04' */
> > -     rc =3D -ENOMEM;
> >       a =3D mpi_read_raw_data(key, keylen);
> >       if (!a)
> > -             goto error;
> > +             return -ENOMEM;
> >
> >       mpi_normalize(a);
> >       rc =3D sm2_ecc_os2ec(ec->Q, a);
> >       mpi_free(a);
> > -     if (rc)
> > -             goto error;
> > -
> > -     return 0;
> >
> > -error:
> > -     mpi_point_release(ec->Q);
> > -     ec->Q =3D NULL;
> >       return rc;
> >   }
> >
> >
>
> Thanks a lot for fixing this issue.
>
> Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>
> Also added:
>
> Cc: stable@vger.kernel.org # v5.10+
>
> Best regards,
> Tianjia

Thank you for your review=EF=BC=81
Regards=EF=BC=8C
Hongbo
