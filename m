Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80AFA599E82
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 17:43:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349842AbiHSPjk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349629AbiHSPjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:39:39 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 106971ADBA;
        Fri, 19 Aug 2022 08:39:39 -0700 (PDT)
Received: from nicolas-tpx395.localdomain (zone.collabora.co.uk [167.235.23.81])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: nicolas)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 8309A6601DC1;
        Fri, 19 Aug 2022 16:39:35 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1660923577;
        bh=Sf7z9oeTO/SV+Jx+YtJSmjHObIi/DpjdAj42YvmAPrM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LqXt2BZwCkQQURlf7+9KbYDQ21otTAD7DhkbvXvTi0DXAbR5J7moONn+JfJBM+M67
         2l6pDutujwBQVR1lPvHrbb3xf7qoFV6nnL13b+arC09ZwbopdaUW4NWxVwZt4RN9sM
         oM5TJpu+9IR91xawmul8A0Dzurl5RG3+0np1OG+Xv1QaPnfq3mp+kRZz70iEaWksYD
         lLJwT1zRzGMHj67HqVObU+H0D5ejshNrhEU2VXAr1FH9UcfM/jXmnkVby9tsbzZdvF
         YSh847gyNmBRpmSm4fkMHFQYA7wNj5wTtvcTCUOeoAffxftQiSryS1FYPeNZsvCFR8
         +yMDLfljF/kXw==
Message-ID: <52bb86cf12450ce78d2f196a1b86b4137ec61a07.camel@collabora.com>
Subject: Re: [PATCH v1 3/3] media: cedrus: Fix endless loop in
 cedrus_h265_skip_bits()
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
Date:   Fri, 19 Aug 2022 11:39:25 -0400
In-Reply-To: <5849126.lOV4Wx5bFT@jernej-laptop>
References: <20220818203308.439043-1-nicolas.dufresne@collabora.com>
         <20220818203308.439043-4-nicolas.dufresne@collabora.com>
         <5849126.lOV4Wx5bFT@jernej-laptop>
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

Le vendredi 19 ao=C3=BBt 2022 =C3=A0 06:16 +0200, Jernej =C5=A0krabec a =C3=
=A9crit=C2=A0:
> Dne =C4=8Detrtek, 18. avgust 2022 ob 22:33:08 CEST je Nicolas Dufresne na=
pisal(a):
> > From: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> >=20
> > The busy status bit may never de-assert if number of programmed skip
> > bits is incorrect, resulting in a kernel hang because the bit is polled
> > endlessly in the code. Fix it by adding timeout for the bit-polling.
> > This problem is reproducible by setting the data_bit_offset field of
> > the HEVC slice params to a wrong value by userspace.
> >=20
> > Cc: stable@vger.kernel.org
> > Reported-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
> > Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
> > Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
>=20
> Fixes tag would be nice.
>=20
> > ---
> >  drivers/staging/media/sunxi/cedrus/cedrus_h265.c | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
> > b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c index
> > f703c585d91c5..f0bc118021b0a 100644
> > --- a/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
> > +++ b/drivers/staging/media/sunxi/cedrus/cedrus_h265.c
> > @@ -227,6 +227,7 @@ static void cedrus_h265_pred_weight_write(struct
> > cedrus_dev *dev, static void cedrus_h265_skip_bits(struct cedrus_dev *d=
ev,
> > int num) {
> >  	int count =3D 0;
> > +	u32 reg;
> >=20
> >  	while (count < num) {
> >  		int tmp =3D min(num - count, 32);
> > @@ -234,8 +235,9 @@ static void cedrus_h265_skip_bits(struct cedrus_dev
> > *dev, int num) cedrus_write(dev, VE_DEC_H265_TRIGGER,
> >  			     VE_DEC_H265_TRIGGER_FLUSH_BITS |
> >  			     VE_DEC_H265_TRIGGER_TYPE_N_BITS(tmp));
> > -		while (cedrus_read(dev, VE_DEC_H265_STATUS) &
> > VE_DEC_H265_STATUS_VLD_BUSY) -			udelay(1);
> > +
> > +		if (cedrus_wait_for(dev, VE_DEC_H265_STATUS,
> > VE_DEC_H265_STATUS_VLD_BUSY)) +		=09
> dev_err_ratelimited(dev->dev, "timed out
> > waiting to skip bits\n");
>=20
> Reporting issue is nice, but better would be to propagate error, since th=
ere=20
> is no way to properly decode this slice if above code block fails.

This mimic what was already there, mind if we do that later ? The propagati=
on is
doing to be a lot more intrusive.

>=20
> Best regards,
> Jernej
>=20
> >=20
> >  		count +=3D tmp;
> >  	}
>=20
>=20
>=20
>=20

