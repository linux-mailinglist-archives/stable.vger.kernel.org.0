Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49DF6180136
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 16:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgCJPIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 11:08:38 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48134 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgCJPIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Mar 2020 11:08:38 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 123F91C0317; Tue, 10 Mar 2020 16:08:36 +0100 (CET)
Date:   Tue, 10 Mar 2020 16:08:35 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sergey Organov <sorganov@gmail.com>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 12/86] usb: gadget: serial: fix Tx stall after
 buffer overflow
Message-ID: <20200310150834.GA24886@duo.ucw.cz>
References: <20200310124530.808338541@linuxfoundation.org>
 <20200310124531.459641903@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20200310124531.459641903@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Sergey Organov <sorganov@gmail.com>
>=20
> [ Upstream commit e4bfded56cf39b8d02733c1e6ef546b97961e18a ]
>=20
> Symptom: application opens /dev/ttyGS0 and starts sending (writing) to
> it while either USB cable is not connected, or nobody listens on the
> other side of the cable. If driver circular buffer overflows before
> connection is established, no data will be written to the USB layer
> until/unless /dev/ttyGS0 is closed and re-opened again by the
> application (the latter besides having no means of being notified about
> the event of establishing of the connection.)
>=20
> Fix: on open and/or connect, kick Tx to flush circular buffer data to
> USB layer.

> diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/=
function/u_serial.c
> index d4d317db89df5..38afe96c5cd26 100644
> --- a/drivers/usb/gadget/function/u_serial.c
> +++ b/drivers/usb/gadget/function/u_serial.c
> @@ -567,8 +567,10 @@ static int gs_start_io(struct gs_port *port)
>  	port->n_read =3D 0;
>  	started =3D gs_start_rx(port);
> =20
> -	/* unblock any pending writes into our circular buffer */
>  	if (started) {
> +		gs_start_tx(port);
> +		/* Unblock any pending writes into our circular buffer, in case
> +		 * we didn't in gs_start_tx() */
>  		tty_wakeup(port->port.tty);

I'm confused. gs-start_tx() is done twice in a row. Its return
convention seem to be 0 in success case, and non-zero on failure. But
it is assigned to variable called "started", which does not sound like
"error" to me.

Are you sure this is correct?
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXmetcgAKCRAw5/Bqldv6
8tI1AJ9iqt5Q0UNko3XwYraoft5l5pkFagCfeFkTUDh9fs5XqbEvUHtsyghET88=
=ZK1I
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
