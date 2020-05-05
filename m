Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B0C41C5CB7
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 17:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730408AbgEEP5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 11:57:37 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:38058 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729892AbgEEP5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 11:57:37 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0CBCB1C023E; Tue,  5 May 2020 17:57:35 +0200 (CEST)
Date:   Tue, 5 May 2020 17:57:34 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 4.19 28/37] dmaengine: dmatest: Fix iteration non-stop
 logic
Message-ID: <20200505155734.GA10069@duo.ucw.cz>
References: <20200504165448.264746645@linuxfoundation.org>
 <20200504165451.307643203@linuxfoundation.org>
 <20200505123159.GC28722@amd>
 <CAHp75VeM+qwh5rHL7RDdacru0jPSB9me2aTs__jdy749dTKRng@mail.gmail.com>
 <20200505125818.GA31126@amd>
 <CAHp75VcKreeQpjROdL23XGqgVu+F_0eL5DsJ=5APEQUO9V69EQ@mail.gmail.com>
 <20200505133700.GA31753@amd>
 <CAHp75Ve+pzhamZXiKxHF+VD8yfsjRF2coattHyiD+0aa7Fy2DA@mail.gmail.com>
 <20200505153227.GI13035@sasha-vm>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <20200505153227.GI13035@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2020-05-05 11:32:27, Sasha Levin wrote:
> On Tue, May 05, 2020 at 05:05:37PM +0300, Andy Shevchenko wrote:
> > On Tue, May 5, 2020 at 4:37 PM Pavel Machek <pavel@denx.de> wrote:
> > > On Tue 2020-05-05 16:19:11, Andy Shevchenko wrote:
> > > > On Tue, May 5, 2020 at 3:58 PM Pavel Machek <pavel@denx.de> wrote:
> > > > > On Tue 2020-05-05 15:51:16, Andy Shevchenko wrote:
> > > > > > On Tue, May 5, 2020 at 3:37 PM Pavel Machek <pavel@denx.de> wro=
te:
> > > > > Yeah, I pointed that out above. Both && and || permit short
> > > > > execution. But that does not matter, as neither "params->iteratio=
ns"
> > > > > nor "total_tests >=3D params->iterations" have side effects.
> > > > >
> > > > > Where is the runtime difference?
> > > >
> > > > We have to check *both* conditions. If we don't check iterations, we
> > > > just wait indefinitely until somebody tells us to stop.
> > > > Everything in the commit message and mentioned there commit IDs whi=
ch
> > > > you may check.
> > >=20
> > > No.
> >=20
> > Yes. Please, read carefully the commit message (for your convenience I
> > emphasized above). I don't want to spend time on this basics stuff
> > anymore.
>=20
> I'm a bit confused about this too. Maybe it's too early in the morning,
> so I wrote this little test program:
>=20
> #include <stdio.h>
> #include <stdlib.h>
>=20
> int main(int argc, char *argv[])
> {
>        int a =3D atoi(argv[1]);
>        int b =3D atoi(argv[2]);
>=20
>        if (!a && !b)
>                printf("A");
>        else
>                printf("B");
>=20
>        if (!(a || b))
>                printf("A");
>        else
>                printf("B");
>=20
>        printf("\n");
>=20
>        return 0;
> }
>=20
> Andy, could you give an example of two values which will print something
> other than "AA" or "BB"?

The issue here is "sideffects". Does b have to be evaluated at all?
There is no difference between

      int a, b;
      if (a && b)

and

	if ((!!a) & (!!b))
=2E

But there would be difference between

      int a, b;
        if (a && b++)

and
	if ((!!a) & (!!(b++)))

But:

1) && and || behave same way w.r.t. side effects

2) in the patch we are talking about b has no important side effects

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXrGM7gAKCRAw5/Bqldv6
8ieJAJ4v4FEtbiT64CSr1N7iWJDlt5yAyQCgt4ofhBcePU1F0Lwfl6ckQtbf7gc=
=NMSn
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
