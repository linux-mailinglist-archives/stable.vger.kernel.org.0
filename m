Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E4122FB60
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 23:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726575AbgG0V3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 17:29:36 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:51224 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726237AbgG0V3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jul 2020 17:29:36 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F3A221C0BE9; Mon, 27 Jul 2020 23:29:33 +0200 (CEST)
Date:   Mon, 27 Jul 2020 23:29:33 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Derek Basehore <dbasehore@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 54/86] Input: elan_i2c - only increment wakeup count
 on touch
Message-ID: <20200727212933.pkt6kgescdz7akht@duo.ucw.cz>
References: <20200727134914.312934924@linuxfoundation.org>
 <20200727134917.124943291@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="sjrw5opmsnu3k25n"
Content-Disposition: inline
In-Reply-To: <20200727134917.124943291@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--sjrw5opmsnu3k25n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Derek Basehore <dbasehore@chromium.org>
>=20
> [ Upstream commit 966334dfc472bdfa67bed864842943b19755d192 ]
>=20
> This moves the wakeup increment for elan devices to the touch report.
> This prevents the drivers from incorrectly reporting a wakeup when the
> resume callback resets then device, which causes an interrupt to
> occur.

Contrary to the changelog, this does not move anything... unlike
mainline, it simply adds two pm_wakeup_events.

It may still be correct, but maybe someone wants to double-check?

Best regards,
								Pavel

> diff --git a/drivers/input/mouse/elan_i2c_core.c b/drivers/input/mouse/el=
an_i2c_core.c
> index ae012639ae1d5..82afaca2e1a67 100644
> --- a/drivers/input/mouse/elan_i2c_core.c
> +++ b/drivers/input/mouse/elan_i2c_core.c
> @@ -917,6 +917,8 @@ static void elan_report_absolute(struct elan_tp_data =
*data, u8 *packet)
>  	u8 hover_info =3D packet[ETP_HOVER_INFO_OFFSET];
>  	bool contact_valid, hover_event;
> =20
> +	pm_wakeup_event(&data->client->dev, 0);
> +
>  	hover_event =3D hover_info & 0x40;
>  	for (i =3D 0; i < ETP_MAX_FINGERS; i++) {
>  		contact_valid =3D tp_info & (1U << (3 + i));
> @@ -939,6 +941,8 @@ static void elan_report_trackpoint(struct elan_tp_dat=
a *data, u8 *report)
>  	u8 *packet =3D &report[ETP_REPORT_ID_OFFSET + 1];
>  	int x, y;
> =20
> +	pm_wakeup_event(&data->client->dev, 0);
> +
>  	if (!data->tp_input) {
>  		dev_warn_once(&data->client->dev,
>  			      "received a trackpoint report while no trackpoint device has be=
en created. Please report upstream.\n");
> @@ -963,7 +967,6 @@ static void elan_report_trackpoint(struct elan_tp_dat=
a *data, u8 *report)
>  static irqreturn_t elan_isr(int irq, void *dev_id)
>  {
>  	struct elan_tp_data *data =3D dev_id;
> -	struct device *dev =3D &data->client->dev;
>  	int error;
>  	u8 report[ETP_MAX_REPORT_LEN];
> =20
> @@ -989,7 +992,7 @@ static irqreturn_t elan_isr(int irq, void *dev_id)
>  		elan_report_trackpoint(data, report);
>  		break;
>  	default:
> -		dev_err(dev, "invalid report id data (%x)\n",
> +		dev_err(&data->client->dev, "invalid report id data (%x)\n",
>  			report[ETP_REPORT_ID_OFFSET]);
>  	}
> =20
> --=20
> 2.25.1
>=20
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--sjrw5opmsnu3k25n
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXx9HPQAKCRAw5/Bqldv6
8iuzAJ0XldBBMXFv0WWs2RcAMn9zTd6MGACeMBDRVpMq/vYK0oviAcNO18vzlxM=
=sxsT
-----END PGP SIGNATURE-----

--sjrw5opmsnu3k25n--
