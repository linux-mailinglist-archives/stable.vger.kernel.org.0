Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8E9599E69
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 17:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349819AbiHSPhh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349817AbiHSPhg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:37:36 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B15ACE831F;
        Fri, 19 Aug 2022 08:37:35 -0700 (PDT)
Received: from nicolas-tpx395.localdomain (zone.collabora.co.uk [167.235.23.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: nicolas)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id CEFC36601DC1;
        Fri, 19 Aug 2022 16:37:30 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1660923453;
        bh=yPtWZ9dIeoSnNCWNTE1Z+qUHDWr0Ag6n3/7+J9VVv8s=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YPyLcdiuSpMv6Qmg1v2M1IdOBzsVHjTCwxcqM/eVA5UQqG0DxkbKaMW4tTqCfl4Xt
         GpmOwmCRrvzvkpqsZ9iFJo9+h/QofDgaI3+Qzd/7lT/EEVf/wBKaiuLstvdh2kPyeT
         tmrybLzL/faEvfdmudArNQhS2hKEFxnKDVZs/BNIiSe+7TG1riqXhff15tUd1wfYxq
         VT7nllVpMuW3ENKXdWS393D/qsgSoyQtHbzQcgSRWE2McS0CuurppiLmDHmC91455Z
         WLl9a2zBjsqubtRWacvH2nAxEQvsFPetiivf5nTO/3Ikm7rNb9P37HKaPaTtQhhi+M
         FQJbeXK/gDvgA==
Message-ID: <47ce07adc73887b5afaf9815a78b793d0e9a6b54.camel@collabora.com>
Subject: Re: [PATCH v1 2/3] media: cedrus: Set the platform driver data
 earlier
From:   Nicolas Dufresne <nicolas.dufresne@collabora.com>
To:     Jernej =?UTF-8?Q?=C5=A0krabec?= <jernej.skrabec@gmail.com>,
        linux-media@vger.kernel.org, Maxime Ripard <mripard@kernel.org>,
        Paul Kocialkowski <paul.kocialkowski@bootlin.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Samuel Holland <samuel@sholland.org>
Cc:     kernel@collabora.com,
        Dmitry Osipenko <dmitry.osipenko@collabora.com>,
        stable@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
        linux-kernel@vger.kernel.org
Date:   Fri, 19 Aug 2022 11:37:20 -0400
In-Reply-To: <4418189.LvFx2qVVIh@jernej-laptop>
References: <20220818203308.439043-1-nicolas.dufresne@collabora.com>
         <20220818203308.439043-3-nicolas.dufresne@collabora.com>
         <4418189.LvFx2qVVIh@jernej-laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le vendredi 19 ao=C3=BBt 2022 =C3=A0 06:17 +0200, Jernej =C5=A0krabec a =C3=
=A9crit=C2=A0:
> Dne =C4=8Detrtek, 18. avgust 2022 ob 22:33:07 CEST je Nicolas Dufresne na=
pisal(a):
> > From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> >=20
> > The cedrus_hw_resume() crashes with NULL deference on driver probe if
> > runtime PM is disabled because it uses platform data that hasn't been
> > set up yet. Fix this by setting the platform data earlier during probe.
>=20
> Does it even work without PM? Maybe it would be better if Cedrus would se=
lect=20
> PM in Kconfig.

I cannot comment myself on this, but it does not seem to invalidate this
Dmitry's fix.

>=20
> Best regards,
> Jernej
>=20
> >=20
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> > Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > ---
> >  drivers/staging/media/sunxi/cedrus/cedrus.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus.c
> > b/drivers/staging/media/sunxi/cedrus/cedrus.c index
> > 960a0130cd620..55c54dfdc585c 100644
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus.c
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus.c
> > @@ -448,6 +448,8 @@ static int cedrus_probe(struct platform_device *pde=
v)
> >  	if (!dev)
> >  		return -ENOMEM;
> >=20
> > +	platform_set_drvdata(pdev, dev);
> > +
> >  	dev->vfd =3D cedrus_video_device;
> >  	dev->dev =3D &pdev->dev;
> >  	dev->pdev =3D pdev;
> > @@ -521,8 +523,6 @@ static int cedrus_probe(struct platform_device *pde=
v)
> >  		goto err_m2m_mc;
> >  	}
> >=20
> > -	platform_set_drvdata(pdev, dev);
> > -
> >  	return 0;
> >=20
> >  err_m2m_mc:
>=20
>=20
>=20
>=20

