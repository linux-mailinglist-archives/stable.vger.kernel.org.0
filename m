Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCC6627CB54
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729751AbgI2M0x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:26:53 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:56122 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732756AbgI2M0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Sep 2020 08:26:47 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 227E01C0B80; Tue, 29 Sep 2020 14:26:45 +0200 (CEST)
Date:   Tue, 29 Sep 2020 14:26:44 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Pavel Machek <pavel@denx.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Kfir Itzhak <mastertheknife@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 23/37] ipv4: Update exception handling for multipath
 routes via same device
Message-ID: <20200929122644.GC29097@duo.ucw.cz>
References: <20200925124720.972208530@linuxfoundation.org>
 <20200925124724.448531559@linuxfoundation.org>
 <20200925165134.GA7253@duo.ucw.cz>
 <20200926154635.GA3347445@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="mvpLiMfbWzRoNl4x"
Content-Disposition: inline
In-Reply-To: <20200926154635.GA3347445@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--mvpLiMfbWzRoNl4x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2020-09-26 17:46:35, Greg Kroah-Hartman wrote:
> On Fri, Sep 25, 2020 at 06:51:34PM +0200, Pavel Machek wrote:
> > Hi!
> >=20
> > > [ Upstream commit 2fbc6e89b2f1403189e624cabaf73e189c5e50c6 ]
> > >=20
> > > Kfir reported that pmtu exceptions are not created properly for
> > > deployments where multipath routes use the same device.
> >=20
> > This is mismerged (in a way that does not affect functionality):
> >=20
> >=20
> > > @@ -779,6 +779,8 @@ static void __ip_do_redirect(struct rtab
> > >  			if (fib_lookup(net, fl4, &res, 0) =3D=3D 0) {
> > >  				struct fib_nh *nh =3D &FIB_RES_NH(res);
> > > =20
> > > +				fib_select_path(net, &res, fl4, skb);
> > > +				nh =3D &FIB_RES_NH(res);
> > >  				update_or_create_fnhe(nh, fl4->daddr, new_gw,
> > >  						0, false,
> >=20
> > nh is assigned value that is never used. Mainline patch removes the
> > assignment (but variable has different type).
> >=20
> > 4.19 should delete the assignment, too.
>=20
> Ah, good catch, I'll merge this in, thanks.

Thank you!
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--mvpLiMfbWzRoNl4x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX3MoBAAKCRAw5/Bqldv6
8nSRAJ94pqb7YDPWyrGBj0PBFjgElglIFgCggYRLwIUGOBRfRnfMt3p+JrIMnLA=
=655A
-----END PGP SIGNATURE-----

--mvpLiMfbWzRoNl4x--
