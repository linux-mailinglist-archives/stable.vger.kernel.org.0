Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD64512585D
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 01:18:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726696AbfLSASA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 19:18:00 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:38946 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLSASA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Dec 2019 19:18:00 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: sre)
        with ESMTPSA id D427A291E6E
Received: by earth.universe (Postfix, from userid 1000)
        id 61A363C0C7B; Thu, 19 Dec 2019 01:17:56 +0100 (CET)
Date:   Thu, 19 Dec 2019 01:17:56 +0100
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Artur Rojek <contact@artur-rojek.eu>
Cc:     Paul Cercueil <paul@crapouillou.net>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, od@zcrc.me, stable@vger.kernel.org
Subject: Re: [PATCH v3] power/supply: ingenic-battery: Don't change scale if
 there's only one
Message-ID: <20191219001756.vuvmrepmbrd7zjix@earth.universe>
References: <20191116135619.9545-1-paul@crapouillou.net>
 <d5d13a62c1652ce109136dcb3b2e1e51@artur-rojek.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qvszxbgcfqgngyks"
Content-Disposition: inline
In-Reply-To: <d5d13a62c1652ce109136dcb3b2e1e51@artur-rojek.eu>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qvszxbgcfqgngyks
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Nov 16, 2019 at 03:08:46PM +0100, Artur Rojek wrote:
> On 2019-11-16 14:56, Paul Cercueil wrote:
> > The ADC in the JZ4740 can work either in high-precision mode with a 2.5V
> > range, or in low-precision mode with a 7.5V range. The code in place in
> > this driver will select the proper scale according to the maximum
> > voltage of the battery.
> >=20
> > The JZ4770 however only has one mode, with a 6.6V range. If only one
> > scale is available, there's no need to change it (and nothing to change
> > it to), and trying to do so will fail with -EINVAL.
> >=20
> > Fixes: fb24ccfbe1e0 ("power: supply: add Ingenic JZ47xx battery
> > driver.")
> >=20
> > Signed-off-by: Paul Cercueil <paul@crapouillou.net>
> > Cc: stable@vger.kernel.org
>=20
> Looks good to me!
>=20
> Acked-by: Artur Rojek <contact@artur-rojek.eu>

Thanks, queued to power-supply's for-next branch.

-- Sebastian

> > ---
> >=20
> > Notes:
> >     v2: Rebased on v5.4-rc7
> >     v3: Move code after check for max scale voltage
> >=20
> >  drivers/power/supply/ingenic-battery.c | 15 +++++++++++----
> >  1 file changed, 11 insertions(+), 4 deletions(-)
> >=20
> > diff --git a/drivers/power/supply/ingenic-battery.c
> > b/drivers/power/supply/ingenic-battery.c
> > index 35816d4b3012..2748715c4c75 100644
> > --- a/drivers/power/supply/ingenic-battery.c
> > +++ b/drivers/power/supply/ingenic-battery.c
> > @@ -100,10 +100,17 @@ static int ingenic_battery_set_scale(struct
> > ingenic_battery *bat)
> >  		return -EINVAL;
> >  	}
> >=20
> > -	return iio_write_channel_attribute(bat->channel,
> > -					   scale_raw[best_idx],
> > -					   scale_raw[best_idx + 1],
> > -					   IIO_CHAN_INFO_SCALE);
> > +	/* Only set scale if there is more than one (fractional) entry */
> > +	if (scale_len > 2) {
> > +		ret =3D iio_write_channel_attribute(bat->channel,
> > +						  scale_raw[best_idx],
> > +						  scale_raw[best_idx + 1],
> > +						  IIO_CHAN_INFO_SCALE);
> > +		if (ret)
> > +			return ret;
> > +	}
> > +
> > +	return 0;
> >  }
> >=20
> >  static enum power_supply_property ingenic_battery_properties[] =3D {

--qvszxbgcfqgngyks
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl36wbQACgkQ2O7X88g7
+prTHg/8DFNUybhomQ90wJsZPhq1g25jJsiwcHMP/q3IcK6OXrEGVGbE6+1x4qRB
+xH5cbOBgDuDdDdZAYj/Iu0L6QSZu/UZ0KTrMforsKCPmktsL32+5R0/ib4nPIAd
gucIo8VEt83wE/meSqFBsRaJ1YZk8UuIjgnl4iylK5E8jQdkbbVaM26SxaZim5qw
8WgJ6evF2OMeG9az6cVVxDhTDFOh9+HNTzrELeXrGtKbOJAUYFOIFTIDvLJFw+gk
91FnchNd6m//5bXcnz5m84G/vtfRiLMTlVKorsxoExG50shH6DuR4i2p8cI9orbx
OG8zZKePdc26ePN/vGdUpfrUbWoFC69T1hCGzsAvDg3QlOG3lUD2ngP9cOwJr1ln
drFprmhpylvb84+Fjb60aAsig0rIBLC4uUJwgJSpIaG+9NM5i2TzPWppwVMGmyRj
H3WcciftA1osgQnkMjVuHQZEIztgAAnzi/KdiBPe3iWoRPS5NFzztGv+nimzHh+6
ks+qHtQCIG6Elo9UVD71IwvowrAu4aHJs9nDmHwVRQtAth18E3kCE8Xxj7550NQn
uywIoFLkdftq9WIE/liiIbWyvg1B5Wqad7ukjS2LTW0Yy/ySSRuclQ4HGle9pByK
1W5BTTTxCk029b8MGBJuTJA/IcjIUTi3iqMaFVXLMneQjZPDFHI=
=WUfr
-----END PGP SIGNATURE-----

--qvszxbgcfqgngyks--
