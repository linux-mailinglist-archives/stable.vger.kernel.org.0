Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC4E62A5EF8
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 08:52:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgKDHw0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 02:52:26 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:37250 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726152AbgKDHw0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 02:52:26 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DBC2B1C0B77; Wed,  4 Nov 2020 08:52:22 +0100 (CET)
Date:   Wed, 4 Nov 2020 08:52:21 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH 4.19 146/191] HID: wacom: Avoid entering
 wacom_wac_pen_report for pad / battery
Message-ID: <20201104075221.GA4338@amd>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203246.442871831@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <20201103203246.442871831@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> To correct this, we restore a version of the `WACOM_PAD_FIELD` check
> in `wacom_wac_collection()` and return early. This effectively prevents
> pad / battery collections from being reported until the very end of the
> report as originally intended.

Okay... but code is either wrong or very confusing:

> +++ b/drivers/hid/wacom_wac.c
> @@ -2729,7 +2729,9 @@ static int wacom_wac_collection(struct h
>  	if (report->type !=3D HID_INPUT_REPORT)
>  		return -1;
> =20
> -	if (WACOM_PEN_FIELD(field) && wacom->wacom_wac.pen_input)
> +	if (WACOM_PAD_FIELD(field))
> +		return 0;
> +	else if (WACOM_PEN_FIELD(field) && wacom->wacom_wac.pen_input)
>  		wacom_wac_pen_report(hdev, report);

wacom_wac_pen_report() can never be called, because WACOM_PEN_FIELD()
can not be true here; if it was we'd return in the line above.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+iXbUACgkQMOfwapXb+vIcLACgp27+/zNvZ6w44XtqM+Zce0js
qagAoJGAXinJ0u4gIlnnWCEL9qUGfYFb
=Ma4D
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
