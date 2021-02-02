Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC3230CC88
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 21:01:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240267AbhBBT66 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:58:58 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:47698 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240263AbhBBT6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Feb 2021 14:58:55 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D62F81C0B7A; Tue,  2 Feb 2021 20:58:09 +0100 (CET)
Date:   Tue, 2 Feb 2021 20:58:09 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.4 24/28] can: dev: prevent potential information leak
 in can_fill_info()
Message-ID: <20210202195809.GA12425@duo.ucw.cz>
References: <20210202132941.180062901@linuxfoundation.org>
 <20210202132942.158736432@linuxfoundation.org>
 <20210202185317.GB6964@duo.ucw.cz>
 <20210202190539.GE20820@kadam>
 <20210202195101.GF20820@kadam>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20210202195101.GF20820@kadam>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2021-02-02 22:51:01, Dan Carpenter wrote:
> On Tue, Feb 02, 2021 at 10:05:39PM +0300, Dan Carpenter wrote:
> > On Tue, Feb 02, 2021 at 07:53:17PM +0100, Pavel Machek wrote:
> > > Hi!
> > >=20
> > > > From: Dan Carpenter <dan.carpenter@oracle.com>
> > > >=20
> > > > [ Upstream commit b552766c872f5b0d90323b24e4c9e8fa67486dd5 ]
> > > >=20
> > > > The "bec" struct isn't necessarily always initialized. For example,=
 the
> > > > mcp251xfd_get_berr_counter() function doesn't initialize anything i=
f the
> > > > interface is down.
> > >=20
> > > Well, yes... and =3D {} does not neccessarily initialize all of the
> > > structure... for example padding.
> > >=20
> > > It is really simple
> > >=20
> > > struct can_berr_counter {
> > > 	__u16 txerr;
> > > 	__u16 rxerr;
> > > };
> > >=20
> > > but maybe something like alpha uses padding in such case, and memset
> > > would be better?
> >=20
> > I'm pretty sure nothing uses padding in this situation.  If it does then
> > we need to re-work a bunch of code.
>=20
> Not necessarily related but in theory a "=3D {};" assignment is a GCC
> extension and it is supposed to zero out struct holes.  If the code
> does "=3D {0};" then that's standard C, and will not necessarily fill
> struct holes but I think GCC tries to.  The other complication is that
> some GCC versions have bugs related to this?  We had a long thread about
> this last August.
>=20
> https://lore.kernel.org/lkml/20200801144030.GM24045@ziepe.ca/
>=20
> Anyway, this code has no holes so it's not affected.

Thanks for pointers. I remembered "just do memset", but there are
clearly more nuances to this.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYBmu0QAKCRAw5/Bqldv6
8tjbAJsFqcPhX1ud4HN18qxbXB1znHVQjwCfYozVCtxPDN5YuADfU9fTHcapQcs=
=hRdw
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
