Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111582A87A0
	for <lists+stable@lfdr.de>; Thu,  5 Nov 2020 20:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgKETzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 14:55:10 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57284 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgKETzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 14:55:10 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D8E121C0B82; Thu,  5 Nov 2020 20:55:08 +0100 (CET)
Date:   Thu, 5 Nov 2020 20:55:08 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jonathan Bakker <xc-racer2@live.ca>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 107/191] ARM: dts: s5pv210: move PMU node out of
 clock controller
Message-ID: <20201105195508.GB19957@duo.ucw.cz>
References: <20201103203232.656475008@linuxfoundation.org>
 <20201103203243.594174920@linuxfoundation.org>
 <20201105114648.GB9009@duo.ucw.cz>
 <CAJKOXPeexYuH1_9HZUGn4Q80QBtKmqCKiEd=hNd46VKTM4kGgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="JP+T4n/bALQSJXh8"
Content-Disposition: inline
In-Reply-To: <CAJKOXPeexYuH1_9HZUGn4Q80QBtKmqCKiEd=hNd46VKTM4kGgA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--JP+T4n/bALQSJXh8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > The Power Management Unit (PMU) is a separate device which has little
> > > common with clock controller.  Moving it to one level up (from clock
> > > controller child to SoC) allows to remove fake simple-bus compatible =
and
> > > dtbs_check warnings like:
> > >
> > >   clock-controller@e0100000: $nodename:0:
> > >     'clock-controller@e0100000' does not match '^([a-z][a-z0-9\\-]+-b=
us|bus|soc|axi|ahb|apb)(@[0-9a-f]+)?$'
> >
> > > +++ b/arch/arm/boot/dts/s5pv210.dtsi
> > > @@ -98,19 +98,16 @@
> > >               };
> > >
> > >               clocks: clock-controller@e0100000 {
> > > -                     compatible =3D "samsung,s5pv210-clock", "simple=
-bus";
> > > +                     compatible =3D "samsung,s5pv210-clock";
> > >                       reg =3D <0xe0100000 0x10000>;
> > ...
> > > +             pmu_syscon: syscon@e0108000 {
> > > +                     compatible =3D "samsung-s5pv210-pmu", "syscon";
> > > +                     reg =3D <0xe0108000 0x8000>;
> > >               };
> >
> > Should clock-controller@e0100000's reg be shortened to 0x8000 so that
> > the ranges do not overlap?
> >
> > Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>
>=20
> I don't think this commit should be backported to stable. It is simple
> dtbs_check - checking whether Devicetree source matches device tree
> schema. Neither the schema nor the warning existed in v4.19. I think
> dtbs_check fixes should not be backported, unless a real issue is
> pointed out.

I agree with you about the backporting. Hopefully Greg drops the
commit.

But the other issue is: should mainline be fixed so that ranges do not over=
lap?

Best regards,
									Pavel
--=20
http://www.livejournal.com/~pavelmachek

--JP+T4n/bALQSJXh8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX6RYnAAKCRAw5/Bqldv6
8i9/AJ9ai3hUhssI3I6aTYUeeZR3CWEr9wCfWAFAUwsvnzHtowU4UMMszdH3l30=
=EtPM
-----END PGP SIGNATURE-----

--JP+T4n/bALQSJXh8--
