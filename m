Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A65BB97980
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 14:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728334AbfHUMdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 08:33:14 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:37963 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728333AbfHUMdN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 08:33:13 -0400
X-Originating-IP: 87.18.63.98
Received: from uno.localdomain (unknown [87.18.63.98])
        (Authenticated sender: jacopo@jmondi.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 4E20C1C0008;
        Wed, 21 Aug 2019 12:33:08 +0000 (UTC)
Date:   Wed, 21 Aug 2019 14:34:37 +0200
From:   Jacopo Mondi <jacopo@jmondi.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Jonathan Cameron <jic23@kernel.org>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Stefan Agner <stefan@agner.ch>, linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] iio: adc: max9611: Fix temperature reading in probe
Message-ID: <20190821123437.rhbukfarka7jo6gu@uno.localdomain>
References: <20190805155515.22621-1-jacopo+renesas@jmondi.org>
 <20190805181244.663585ac@archlinux>
 <CAMuHMdVT--S48M+BHTOH5SDi7AG=asOdNWH_UyM5nygZjWLmdg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qun6oiumlid26o25"
Content-Disposition: inline
In-Reply-To: <CAMuHMdVT--S48M+BHTOH5SDi7AG=asOdNWH_UyM5nygZjWLmdg@mail.gmail.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qun6oiumlid26o25
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hi Geert

On Wed, Aug 21, 2019 at 01:28:16PM +0200, Geert Uytterhoeven wrote:
> Hi Jonathan, Jacopo,
>
> On Mon, Aug 5, 2019 at 7:15 PM Jonathan Cameron <jic23@kernel.org> wrote:
> > On Mon,  5 Aug 2019 17:55:15 +0200
> > Jacopo Mondi <jacopo+renesas@jmondi.org> wrote:
> >
> > > The max9611 driver reads the die temperature at probe time to validate
> > > the communication channel. Use the actual read value to perform the test
> > > instead of the read function return value, which was mistakenly used so
> > > far.
> > >
> > > The temperature reading test was only successful because the 0 return
> > > value is in the range of supported temperatures.
> > >
> > > Fixes: 69780a3bbc0b ("iio: adc: Add Maxim max9611 ADC driver")
> > > Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
> >
> > Applied to the fixes-togreg branch of iio.git and marked for
> > stable.  That'll be a bit fiddly given other changes around this
> > so we may need to do backports.
>
> This is now commit b9ddd5091160793e ("iio: adc: max9611: Fix temperature
> reading in probe") in v5.3-rc5, and has been backported to 4.14, 4.19,
> and 5.2.
>
> > > --- a/drivers/iio/adc/max9611.c
> > > +++ b/drivers/iio/adc/max9611.c
> > > @@ -480,7 +480,7 @@ static int max9611_init(struct max9611_dev *max9611)
> > >       if (ret)
> > >               return ret;
> > >
> > > -     regval = ret & MAX9611_TEMP_MASK;
> > > +     regval &= MAX9611_TEMP_MASK;
> > >
> > >       if ((regval > MAX9611_TEMP_MAX_POS &&
> > >            regval < MAX9611_TEMP_MIN_NEG) ||
>
> While this did fix a bug, it also introduced a regression: on Salvator-XS,
> which has two max9611 instances, I now see intermittent failures
>
>     max9611 4-007c: Invalid value received from ADC 0x8000: aborting
>     max9611: probe of 4-007c failed with error -5
>
> and/or
>
>     max9611 4-007f: Invalid value received from ADC 0x8000: aborting
>     max9611: probe of 4-007f failed with error -5
>
> during boot.

AH! I didn't notice! I booted the board a few times only, maybe it
didn't trigger (it was a Salvator-X H3, not an XS, but it shouldn't
make any difference).

>
> Retrying on failure fixes the issue, e.g.:
>
>     max9611_init:483: regval = 0x8000
>     max9611 4-007f: Invalid value received from ADC 0x8000: aborting
>     max9611_init:483: regval = 0x2780
>
> According to the datasheet, 0x8000 is the Power-On Reset value.
> Looks like it should be ignored, and retried?

Indeed... I haven't found a characterization of the delay required to
release registers from their POR values after power up, so I guess we
could read the register value again with a little timeout between
reads (whose value would be arbitrary, anyway..)

I'm a bit suprised though.. The max9611 chips are powered from the
+3.3V rail, and should have exited POR long before the driver gets
to probe, isn't it?

Thanks for reporting and sorry for having missed it in first place


>
> Gr{oetje,eeting}s,
>
>                         Geert
>
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds

--qun6oiumlid26o25
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEtcQ9SICaIIqPWDjAcjQGjxahVjwFAl1dOl0ACgkQcjQGjxah
VjyrKhAAtDuO4WzIq31UoBWpx9c9XTZKqfUlSPk/p6xNPC/ByTk5qugXirqHRNOl
Lud+5C9JA8M2lzXSGk05qwyCETJuCfYLDueF1Tj2I/XD/1sD7cnttmZxmJA0COr+
hjFk8PCJqqcSOXMIdd77Has/+568t1SVXmJGZv27zK5KBjc98zvVSiWEkXvnhMPV
dVBgq6MboeZEGu1na7fyDMQXPYKO2XBZ7tfldmxhHER0UYdbCK3cQBJxFoE9WGNX
JjeDmaY8qKKDWkI2ZR4+rvg4xtmH7B3xysWtr4TjNuX4q49LER06sinwLT/jk9M5
7Xiei5/BPuNh5dZOVI5vKawR8ZrCZUMvwWU3qiPSJcX3hG4tr6veDyp/5zKmXPlz
JeVMq7j217QOY7xgMvMKe4uKI8h3lD8UC5dsjSLqttSgpI0MdGAjYXfSRHcFF0lY
IyEjvyT40KTljK0tM9K7pzTjMyPbDyAg24lE89xFqZb6Mw4ZOechnR9zYGXMOKZH
tPHyUsOnLPPygb4BTiMv75hQzWZqi69C/qU2AdsAgsDvmyMyS3uNrVUDJcXQfJZj
kQ+caeyLq4WsoQQ/Gh1YgBXH2Pk3sgQMp7phK6vm6GKqi25o5awCMpU1alA3rOqd
q+cCysbULdTv0HNSHmc8gGiNa9WgsoTHvvH0ISOPQwLNv6a+6fU=
=McQD
-----END PGP SIGNATURE-----

--qun6oiumlid26o25--
