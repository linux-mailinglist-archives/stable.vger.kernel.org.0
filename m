Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685D527F2F9
	for <lists+stable@lfdr.de>; Wed, 30 Sep 2020 22:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729551AbgI3UHP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Sep 2020 16:07:15 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:53346 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3UHP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Sep 2020 16:07:15 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B16491C0B76; Wed, 30 Sep 2020 22:07:12 +0200 (CEST)
Date:   Wed, 30 Sep 2020 22:07:12 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Raviteja Narayanam <raviteja.narayanam@xilinx.com>,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 144/245] serial: uartps: Wait for tx_empty in
 console setup
Message-ID: <20200930200711.GA22586@amd>
References: <20200929105946.978650816@linuxfoundation.org>
 <20200929105953.992070373@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20200929105953.992070373@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Raviteja Narayanam <raviteja.narayanam@xilinx.com>
>=20
> [ Upstream commit 42e11948ddf68b9f799cad8c0ddeab0a39da33e8 ]
>=20
> On some platforms, the log is corrupted while console is being
> registered. It is observed that when set_termios is called, there
> are still some bytes in the FIFO to be transmitted.
>=20
> So, wait for tx_empty inside cdns_uart_console_setup before calling
> set_termios.

> @@ -1246,6 +1247,13 @@ static int cdns_uart_console_setup(struct console =
*co, char *options)
>  	if (options)
>  		uart_parse_options(options, &baud, &parity, &bits, &flow);
> =20
> +	/* Wait for tx_empty before setting up the console */
> +	time_out =3D jiffies + usecs_to_jiffies(TX_TIMEOUT);
> +
> +	while (time_before(jiffies, time_out) &&
> +	       cdns_uart_tx_empty(port) !=3D TIOCSER_TEMT)
> +		cpu_relax();
> +

So this is spinning for half a second. Could we use msleep(1) instead
of cpu_relax or something like that?

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl905W8ACgkQMOfwapXb+vJMjACfaQ9IHsQLdFpvHN5i3t0ouijb
BvkAn31MljYKsxKX4BzMdJ5KJgS7L7/s
=YCZ9
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
