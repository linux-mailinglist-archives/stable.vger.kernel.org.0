Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC6E2A870F
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 20:25:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731965AbgKETZ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 14:25:56 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:54926 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKETZ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 14:25:56 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0A6AC1C0B82; Thu,  5 Nov 2020 20:25:54 +0100 (CET)
Date:   Thu, 5 Nov 2020 20:25:53 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: Re: [PATCH 4.19 178/191] rtc: rx8010: dont modify the global rtc ops
Message-ID: <20201105192553.GB18462@duo.ucw.cz>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203249.312789260@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="EuxKj2iCbKjpUGkD"
Content-Disposition: inline
In-Reply-To: <20201103203249.312789260@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--EuxKj2iCbKjpUGkD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit d3b14296da69adb7825022f3224ac6137eb30abf upstream.
>=20
> The way the driver is implemented is buggy for the (admittedly unlikely)
> use case where there are two RTCs with one having an interrupt configured
> and the second not. This is caused by the fact that we use a global
> rtc_class_ops struct which we modify depending on whether the irq number
> is present or not.

While this fixes very unlikely configuration with two RTCs...

> Fix it by using two const ops structs with and without alarm operations.
> While at it: not being able to request a configured interrupt is an error
> so don't ignore it and bail out of probe().

=2E..it contains unrelated changes and in particular will break
operation when IRQ can not be requested.

I don't believe we need it in -stable.

Best regards,
								Pavel

> @@ -468,16 +478,16 @@ static int rx8010_probe(struct i2c_clien
> =20
>  		if (err) {
>  			dev_err(&client->dev, "unable to request IRQ\n");
> -			client->irq =3D 0;
> -		} else {
> -			rx8010_rtc_ops.read_alarm =3D rx8010_read_alarm;
> -			rx8010_rtc_ops.set_alarm =3D rx8010_set_alarm;
> -			rx8010_rtc_ops.alarm_irq_enable =3D rx8010_alarm_irq_enable;
> +			return err;
>  		}

--=20
http://www.livejournal.com/~pavelmachek

--EuxKj2iCbKjpUGkD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX6RRwQAKCRAw5/Bqldv6
8kK2AJsEW9B2Z6krorpL4FmqyDKN92TYhwCdFMkHcRX9J6Lo8fWTD3/nhUaPWsU=
=qjbV
-----END PGP SIGNATURE-----

--EuxKj2iCbKjpUGkD--
