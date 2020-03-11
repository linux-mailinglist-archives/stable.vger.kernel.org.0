Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D76CE181531
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 10:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgCKJm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 05:42:27 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48988 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgCKJm0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 05:42:26 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A7E691C031B; Wed, 11 Mar 2020 10:42:24 +0100 (CET)
Date:   Wed, 11 Mar 2020 10:42:24 +0100
From:   Pavel Machek <pavel@denx.de>
To:     =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sergey Organov <sorganov@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 12/86] usb: gadget: serial: fix Tx stall after
 buffer overflow
Message-ID: <20200311094223.GA15976@duo.ucw.cz>
References: <20200310124530.808338541@linuxfoundation.org>
 <20200310124531.459641903@linuxfoundation.org>
 <20200310150834.GA24886@duo.ucw.cz>
 <20200310225118.GA32479@qmqm.qmqm.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <20200310225118.GA32479@qmqm.qmqm.pl>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > From: Sergey Organov <sorganov@gmail.com>
> > >=20
> > > [ Upstream commit e4bfded56cf39b8d02733c1e6ef546b97961e18a ]
> > >=20
> > > Symptom: application opens /dev/ttyGS0 and starts sending (writing) to
> > > it while either USB cable is not connected, or nobody listens on the
> > > other side of the cable. If driver circular buffer overflows before
> > > connection is established, no data will be written to the USB layer
> > > until/unless /dev/ttyGS0 is closed and re-opened again by the
> > > application (the latter besides having no means of being notified abo=
ut
> > > the event of establishing of the connection.)
> > >=20
> > > Fix: on open and/or connect, kick Tx to flush circular buffer data to
> > > USB layer.
> >=20
> > > diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gad=
get/function/u_serial.c
> > > index d4d317db89df5..38afe96c5cd26 100644
> > > --- a/drivers/usb/gadget/function/u_serial.c
> > > +++ b/drivers/usb/gadget/function/u_serial.c
> > > @@ -567,8 +567,10 @@ static int gs_start_io(struct gs_port *port)
> > >  	port->n_read =3D 0;
> > >  	started =3D gs_start_rx(port);
> > > =20
> > > -	/* unblock any pending writes into our circular buffer */
> > >  	if (started) {
> > > +		gs_start_tx(port);
> > > +		/* Unblock any pending writes into our circular buffer, in case
> > > +		 * we didn't in gs_start_tx() */
> > >  		tty_wakeup(port->port.tty);
> >=20
> > I'm confused. gs-start_tx() is done twice in a row. Its return
> > convention seem to be 0 in success case, and non-zero on failure. But
> > it is assigned to variable called "started", which does not sound like
> > "error" to me.
> >=20
> > Are you sure this is correct?
>=20
> The function before 'if (started)' is gs_start_rx() - it's RX not
> TX.

Aha, I missed that, sorry for the noise.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXmiyfwAKCRAw5/Bqldv6
8pr/AJ9aSgvJ5WVI5DzY9pWECe0/+CVTOgCgjReT0Iys54B1ezCHTMyeB2GZffM=
=+MLw
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
