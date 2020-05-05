Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE82B1C5A17
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 16:53:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729065AbgEEOxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 10:53:20 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:52394 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729201AbgEEOxU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 10:53:20 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id AAC611C0224; Tue,  5 May 2020 16:53:18 +0200 (CEST)
Date:   Tue, 5 May 2020 16:53:18 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 4.19 28/37] dmaengine: dmatest: Fix iteration non-stop
 logic
Message-ID: <20200505145317.GA2834@amd>
References: <20200504165448.264746645@linuxfoundation.org>
 <20200504165451.307643203@linuxfoundation.org>
 <20200505123159.GC28722@amd>
 <CAHp75VeM+qwh5rHL7RDdacru0jPSB9me2aTs__jdy749dTKRng@mail.gmail.com>
 <20200505125818.GA31126@amd>
 <CAHp75VcKreeQpjROdL23XGqgVu+F_0eL5DsJ=5APEQUO9V69EQ@mail.gmail.com>
 <20200505133700.GA31753@amd>
 <CAHp75Ve+pzhamZXiKxHF+VD8yfsjRF2coattHyiD+0aa7Fy2DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <CAHp75Ve+pzhamZXiKxHF+VD8yfsjRF2coattHyiD+0aa7Fy2DA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2020-05-05 17:05:37, Andy Shevchenko wrote:
> On Tue, May 5, 2020 at 4:37 PM Pavel Machek <pavel@denx.de> wrote:
> > On Tue 2020-05-05 16:19:11, Andy Shevchenko wrote:
> > > On Tue, May 5, 2020 at 3:58 PM Pavel Machek <pavel@denx.de> wrote:
> > > > On Tue 2020-05-05 15:51:16, Andy Shevchenko wrote:
> > > > > On Tue, May 5, 2020 at 3:37 PM Pavel Machek <pavel@denx.de> wrote:
> > > > > > > So, to the point, the conditional of checking the thread to b=
e stopped being
> > > > > > > first part of conjunction logic prevents to check iterations.=
 Thus, we have to
> > > > > > > always check both conditions
>=20
> vvv
> >>>>>> to be able to stop after given iterations.
> ^^^

_If_ you are already stopping due to kthread_should_stop(), you don't
need to check iterations.

If you are not stopping, iterations are always checked.

No, the new code does not "always check both conditions" as you claim.

> Yes. Please, read carefully the commit message (for your convenience I
> emphasized above). I don't want to spend time on this basics stuff
> anymore.

You may want to go through the basics once more. The change clearly
does not do what you said it does; in fact, it does not do anything.

> > If you wanted both conditions to always evaluate, you'd have to do
> >
> > #       while (!kthread_should_stop()
> > #              & !(params->iterations && total_tests >=3D
> > #              params->iterations)) {
> >
> > (note && -> &). But, again, there's no reason to do that, as second
> > part of expression does not have side effects.
>=20
> It fixes a bug in the code, try with and without this change. (I can
> reproduce it here)

I'm not sure if you made mistake during testing, or if you have buggy
compiler or what...
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl6xfd0ACgkQMOfwapXb+vIEDgCgqysFldRlePOGBpziHUZEVK/5
KvsAoKAGNxqP2ZKLJqJLvA/wW6+FbHe9
=BnUQ
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
