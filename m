Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C096141FCE1
	for <lists+stable@lfdr.de>; Sat,  2 Oct 2021 17:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233535AbhJBPz3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 2 Oct 2021 11:55:29 -0400
Received: from bhuna.collabora.co.uk ([46.235.227.227]:56986 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233438AbhJBPz2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 2 Oct 2021 11:55:28 -0400
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: sre)
        with ESMTPSA id D13321F411C6
Received: by earth.universe (Postfix, from userid 1000)
        id D4F533C0CA8; Sat,  2 Oct 2021 17:53:39 +0200 (CEST)
Date:   Sat, 2 Oct 2021 17:53:39 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Henrik Grimler <henrik@grimler.se>, m.szyprowski@samsung.com,
        krzysztof.kozlowski@canonical.com, sebastian.krzyszkowiak@puri.sm,
        linux-pm@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, stable@vger.kernel.org,
        Wolfgang Wiedmeyer <wolfgit@wiedmeyer.de>
Subject: Re: [PATCH v2 1/2] power: supply: max17042_battery: use VFSOC for
 capacity when no rsns
Message-ID: <20211002155339.u33vym7gp5kchwrz@earth.universe>
References: <20210929181418.4221-1-henrik@grimler.se>
 <be608922-ef03-da35-c65c-575f301b596b@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="7egjpavqn5hc2qqd"
Content-Disposition: inline
In-Reply-To: <be608922-ef03-da35-c65c-575f301b596b@redhat.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7egjpavqn5hc2qqd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Sep 29, 2021 at 09:43:25PM +0200, Hans de Goede wrote:
> On 9/29/21 8:14 PM, Henrik Grimler wrote:
> > On Galaxy S3 (i9300/i9305), which has the max17047 fuel gauge and no
> > current sense resistor (rsns), the RepSOC register does not provide an
> > accurate state of charge value. The reported value is wrong, and does
> > not change over time. VFSOC however, which uses the voltage fuel gauge
> > to determine the state of charge, always shows an accurate value.
> >=20
> > For devices without current sense, VFSOC is already used for the
> > soc-alert (0x0003 is written to MiscCFG register), so with this change
> > the source of the alert and the PROP_CAPACITY value match.
> >=20
> > Fixes: 359ab9f5b154 ("power_supply: Add MAX17042 Fuel Gauge Driver")
> > Cc: <stable@vger.kernel.org>
> > Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> > Suggested-by: Wolfgang Wiedmeyer <wolfgit@wiedmeyer.de>
> > Signed-off-by: Henrik Grimler <henrik@grimler.se>
> > ---
> > Changes in v2:
> > Re-write commit message to highlight that VFSOC is already used for
> > alert, after Krzysztof's comments
>=20
> Thanks, both patches looks good to me:
>=20
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
>=20
> for the series.

Thanks, both queued.

-- Sebastian

>=20
>=20
> Regards,
>=20
> Hans
>=20
>=20
> > ---
> >  drivers/power/supply/max17042_battery.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/drivers/power/supply/max17042_battery.c b/drivers/power/su=
pply/max17042_battery.c
> > index 8dffae76b6a3..5809ba997093 100644
> > --- a/drivers/power/supply/max17042_battery.c
> > +++ b/drivers/power/supply/max17042_battery.c
> > @@ -313,7 +313,10 @@ static int max17042_get_property(struct power_supp=
ly *psy,
> >  		val->intval =3D data * 625 / 8;
> >  		break;
> >  	case POWER_SUPPLY_PROP_CAPACITY:
> > -		ret =3D regmap_read(map, MAX17042_RepSOC, &data);
> > +		if (chip->pdata->enable_current_sense)
> > +			ret =3D regmap_read(map, MAX17042_RepSOC, &data);
> > +		else
> > +			ret =3D regmap_read(map, MAX17042_VFSOC, &data);
> >  		if (ret < 0)
> >  			return ret;
> > =20
> >=20
> > base-commit: 5816b3e6577eaa676ceb00a848f0fd65fe2adc29
> >=20
>=20

--7egjpavqn5hc2qqd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmFYgIMACgkQ2O7X88g7
+poQLg/8CXVaO8gho0G+JicSoNEXEmdF+noJAB/DYjGgXihZVXKvvJQpP/fjLt7z
28rm2NaWrV02OlWK0Rpx1ZIkCU1CPJjnnLUwxMEyKICyjJPH8p61nEYRKYSVDtN6
Y9c9isOFNVcHUU8Sg14E+1xr9PImplWmvSTLEODb9DqJ8fBwtrO5JRJ54F3lOUkB
Hqzv7hKYjbslAOnT/rVn3CcMhliT7xCp+GUU22sEwsUlX9P0aBHuHZPkBouTpflD
r4y9Z6HvW3WGGSdulTvYBkPQWWYeXSrFv37pi/I65cn0GJH3hw5uUUSkQM6Mxg1u
tRj3N5DtAR6FDGfqOSSjWhciY6N5NOs1dwAwpNnFWoX6ZQHpF3KNRt9HX1BBS37a
TGPBHU/a66b12XiMQoALHceVRupYNJ1wqvMhkNiSfiL/mczCTS0mAZeWqyfvL9EP
aqCHHe50hSoO/dJU5KyZW3EtCkcHUMmP4+LLR8QkZHFZdz7Zg4pcXbsmZoPZZ6eN
9VuQDDf16VLk3fGird4gxuEoL4OhZHbMKkDdhXnfHTYG2wHmI83eanIHtOjQKazA
zAXlFMiUy42llxw/beB/NR97/phZ9XAf2i2URrxOG1DqbpxRBbdb6XpO5qenaoox
Cb3RUHYF4x6ZDSj/ySZnMJABlS6RzN6UAf4avYycKku0cZG4bTg=
=HT6D
-----END PGP SIGNATURE-----

--7egjpavqn5hc2qqd--
