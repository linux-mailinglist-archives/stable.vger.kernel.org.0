Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD731C571A
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 15:37:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729001AbgEENhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 09:37:03 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:60880 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728993AbgEENhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 09:37:03 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1139D1C0225; Tue,  5 May 2020 15:37:01 +0200 (CEST)
Date:   Tue, 5 May 2020 15:37:00 +0200
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
Message-ID: <20200505133700.GA31753@amd>
References: <20200504165448.264746645@linuxfoundation.org>
 <20200504165451.307643203@linuxfoundation.org>
 <20200505123159.GC28722@amd>
 <CAHp75VeM+qwh5rHL7RDdacru0jPSB9me2aTs__jdy749dTKRng@mail.gmail.com>
 <20200505125818.GA31126@amd>
 <CAHp75VcKreeQpjROdL23XGqgVu+F_0eL5DsJ=5APEQUO9V69EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YiEDa0DAkWCtVeE4"
Content-Disposition: inline
In-Reply-To: <CAHp75VcKreeQpjROdL23XGqgVu+F_0eL5DsJ=5APEQUO9V69EQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--YiEDa0DAkWCtVeE4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2020-05-05 16:19:11, Andy Shevchenko wrote:
> On Tue, May 5, 2020 at 3:58 PM Pavel Machek <pavel@denx.de> wrote:
> > On Tue 2020-05-05 15:51:16, Andy Shevchenko wrote:
> > > On Tue, May 5, 2020 at 3:37 PM Pavel Machek <pavel@denx.de> wrote:
> > > > > So, to the point, the conditional of checking the thread to be st=
opped being
> > > > > first part of conjunction logic prevents to check iterations. Thu=
s, we have to
> > > > > always check both conditions to be able to stop after given
> > > > > iterations.
> > > >
> > > > I ... don't understand. AFAICT the code is equivalent. Both && and =
||
> > > > operators permit "short" execution... but second part of expression
> > > > has no sideeffects, so...
> > >
> > > ..
> > >
> > > > You are changing !a & !b into !(a | b). But that's equivalent
> > > > expression. I hate to admit, but I had to draw truth table to prove
> > > > that.
> > ...
> > > > What am I missing?
> > >
> > > Basic stuff. Compiler doesn't consider second part of conjunction when
> > > first one (see operator precedence) is already false, so, it means:
> > >
> > > a & b
> > > 0   x -> false
> > > 1   0 -> false
> > > 1   1 -> true
> > >
> > > x is not being considered at all. So, logically it's equivalent,
> > > run-time it's not.
> >
> > Yeah, I pointed that out above. Both && and || permit short
> > execution. But that does not matter, as neither "params->iterations"
> > nor "total_tests >=3D params->iterations" have side effects.
> >
> > Where is the runtime difference?
>=20
> We have to check *both* conditions. If we don't check iterations, we
> just wait indefinitely until somebody tells us to stop.
> Everything in the commit message and mentioned there commit IDs which
> you may check.

No.

If kthread_should_stop() is true, we break the loop. Both old code and
new code does that. Neither old nor new code checks the
"params->iterations && total_tests >=3Ddparams->iterations" condition,
as both && and || do short execution).

If you wanted both conditions to always evaluate, you'd have to do

#       while (!kthread_should_stop()
#              & !(params->iterations && total_tests >=3D
#              params->iterations)) {

(note && -> &). But, again, there's no reason to do that, as second
part of expression does not have side effects.

> > -       while (!kthread_should_stop()
> > -              && !(params->iterations && total_tests >=3D
> > -              params->iterations)) {
> > +       while (!(kthread_should_stop() ||
> > +              (params->iterations && total_tests >=3D params->iteratio=
ns))) {

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--YiEDa0DAkWCtVeE4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl6xa/wACgkQMOfwapXb+vL7nwCcDSnqwILJ94NPR9EKdIULpNMm
I5UAoJGYrSXReuB+pHvknUfXRyC0gmhO
=sGJB
-----END PGP SIGNATURE-----

--YiEDa0DAkWCtVeE4--
