Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34C663F6EB1
	for <lists+stable@lfdr.de>; Wed, 25 Aug 2021 07:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230513AbhHYFGW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Aug 2021 01:06:22 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:36344 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbhHYFGV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Aug 2021 01:06:21 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7DCF01C0B77; Wed, 25 Aug 2021 07:05:35 +0200 (CEST)
Date:   Wed, 25 Aug 2021 07:05:35 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Pavel Machek <pavel@denx.de>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, Marc Zyngier <maz@kernel.org>,
        Kevin Hilman <khilman@baylibre.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 5.10 64/98] net: mdio-mux: Handle -EPROBE_DEFER correctly
Message-ID: <20210825050535.GA24601@duo.ucw.cz>
References: <20210824165908.709932-1-sashal@kernel.org>
 <20210824165908.709932-65-sashal@kernel.org>
 <20210824190009.GA16752@duo.ucw.cz>
 <CAGETcx93J_gpTLhANbjfiBrZ=PCN4bUabfHGG-jv0KdfOUMyjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <CAGETcx93J_gpTLhANbjfiBrZ=PCN4bUabfHGG-jv0KdfOUMyjg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > When registering mdiobus children, if we get an -EPROBE_DEFER, we sho=
uldn't
> > > ignore it and continue registering the rest of the mdiobus children. =
This
> > > would permanently prevent the deferring child mdiobus from working in=
stead
> > > of reattempting it in the future. So, if a child mdiobus needs to be
> > > reattempted in the future, defer the entire mdio-mux initialization.
> > >
> > > This fixes the issue where PHYs sitting under the mdio-mux aren't
> > > initialized correctly if the PHY's interrupt controller is not yet re=
ady
> > > when the mdio-mux is being probed. Additional context in the link
> > > below.
> >
> > I don't believe this is quite right. AFAICT it leaks memory in the
> > EPROBE_DEFER case. Could someone double-check? Suggested fix is below.
>=20
> devm_ APIs would take care of releasing the resource (memory)
> automatically because the probe didn't succeed. So I'm not sure
> there's a leak. Does that make sense?

Yes, it does, I believe you are right.

This part of code confused me: We are going to return error there, yet
we do explicit tree, which should not be neccessary according to this
logic.


        dev_err(dev, "Error: No acceptable child buses found\n");
	devm_kfree(dev, pb);

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bp/iNruPH9dso1Pn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYSXPnwAKCRAw5/Bqldv6
8s8gAJ96e9g8EYddYS9zyNJcBRetQ5lJ7gCghzCQkr+EHZDoCkAdDdVCj0rH4mw=
=Xidz
-----END PGP SIGNATURE-----

--bp/iNruPH9dso1Pn--
