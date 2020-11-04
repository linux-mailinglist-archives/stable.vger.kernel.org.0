Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D94A42A6D84
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 20:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730383AbgKDTGb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 14:06:31 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:48130 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgKDTGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 14:06:31 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 817261C0B7C; Wed,  4 Nov 2020 20:06:27 +0100 (CET)
Date:   Wed, 4 Nov 2020 20:06:27 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     "Gerecke, Jason" <Jason.Gerecke@wacom.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Gerecke <killertofu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Cheng, Ping" <Ping.Cheng@wacom.com>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 4.19 146/191] HID: wacom: Avoid entering
 wacom_wac_pen_report for pad / battery
Message-ID: <20201104190627.GA1850@duo.ucw.cz>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203246.442871831@linuxfoundation.org>
 <20201104075221.GA4338@amd>
 <VI1PR07MB5821A87A8B0133C606C9911CEDEF0@VI1PR07MB5821.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <VI1PR07MB5821A87A8B0133C606C9911CEDEF0@VI1PR07MB5821.eurprd07.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > To correct this, we restore a version of the `WACOM_PAD_FIELD` check
> > > in `wacom_wac_collection()` and return early. This effectively preven=
ts
> > > pad / battery collections from being reported until the very end of t=
he
> > > report as originally intended.
> >=20
> > Okay... but code is either wrong or very confusing:
> >=20
> > > +++ b/drivers/hid/wacom_wac.c
> > > @@ -2729,7 +2729,9 @@ static int wacom_wac_collection(struct h
> > >        if (report->type !=3D HID_INPUT_REPORT)
> > >                return -1;
> > > =20
> > > -     if (WACOM_PEN_FIELD(field) && wacom->wacom_wac.pen_input)
> > > +     if (WACOM_PAD_FIELD(field))
> > > +             return 0;
> > > +     else if (WACOM_PEN_FIELD(field) && wacom->wacom_wac.pen_input)
> > >                wacom_wac_pen_report(hdev, report);
> >=20
> > wacom_wac_pen_report() can never be called, because WACOM_PEN_FIELD()
> > can not be true here; if it was we'd return in the line above.
>=20
> For reference, here's the definition for WACOM_PAD_FIELD() and WACOM_PEN_=
FIELD():
>=20
> > #define WACOM_PAD_FIELD(f)	(((f)->physical =3D=3D HID_DG_TABLETFUNCTION=
KEY) || \
> > 				 ((f)->physical =3D=3D WACOM_HID_WD_DIGITIZERFNKEYS) || \
> > 				 ((f)->physical =3D=3D WACOM_HID_WD_DIGITIZERINFO))
> >=20
> > #define WACOM_PEN_FIELD(f)	(((f)->logical =3D=3D HID_DG_STYLUS) || \
> > 				 ((f)->physical =3D=3D HID_DG_STYLUS) || \
> > 				 ((f)->physical =3D=3D HID_DG_PEN) || \
> > 				 ((f)->application =3D=3D HID_DG_PEN) || \
> > 				 ((f)->application =3D=3D HID_DG_DIGITIZER) || \
> > 				 ((f)->application =3D=3D WACOM_HID_WD_PEN) || \
> > 				 ((f)->application =3D=3D WACOM_HID_WD_DIGITIZER) || \
> > 				 ((f)->application =3D=3D WACOM_HID_G9_PEN) || \
> > 				 ((f)->application =3D=3D WACOM_HID_G11_PEN))
>=20
> WACOM_PAD_FIELD() evaluates to `true` for pad data *not* pen data because=
 pen data is not inside any of the 3 physical collections its looks for.
>=20
> WACOM_PEN_FIELD() evaluates to `true` for pad data *and* pen data because=
 both types of data are inside of the Digitizer application collection.
>

> Without the WACOM_PAD_FIELD() check in place at the very beginning, both =
pad and pen data would trigger a call to wacom_wac_pen_report(). This is un=
desired: only pen data should result in that function being called. Adding =
the check causes the function to return early for pad data while pen data f=
alls into the "else if" and is processed as before. Pad data is only report=
ed once the entire report has been valuated by making a call to wacom_wac_p=
ad_report() at the very end of wacom_wac_report().
>

Yep, you are right. I failed to notice the difference between _PAD_
and _PEN_ macros, and so the code did not make sense.

Sorry for the noise.

Best regards,
								Pavel
							=09
--=20
http://www.livejournal.com/~pavelmachek

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX6L7swAKCRAw5/Bqldv6
8nc0AKCjCKJtNXaXeOhS+GtePsSmvUZ8agCfS9Jlqtj60H2oEsUkg+Ve9EOlJJA=
=v1xk
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
