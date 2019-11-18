Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341C41009D4
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 17:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726706AbfKRQ4y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 11:56:54 -0500
Received: from foss.arm.com ([217.140.110.172]:37162 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726536AbfKRQ4y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 11:56:54 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 86BF81FB;
        Mon, 18 Nov 2019 08:56:53 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E71353F703;
        Mon, 18 Nov 2019 08:56:52 -0800 (PST)
Date:   Mon, 18 Nov 2019 16:56:51 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Torsten Duwe <duwe@lst.de>
Cc:     Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] regulator: Defer init completion for a while after
 late_initcall
Message-ID: <20191118165651.GK9761@sirena.org.uk>
References: <20190904124250.25844-1-broonie@kernel.org>
 <20191116125233.GA5570@lst.de>
 <20191118124654.GD9761@sirena.org.uk>
 <20191118164101.GA7894@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="LHvWgpbS7VDUdu2f"
Content-Disposition: inline
In-Reply-To: <20191118164101.GA7894@lst.de>
X-Cookie: no maintenance:
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LHvWgpbS7VDUdu2f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 18, 2019 at 05:41:01PM +0100, Torsten Duwe wrote:
> On Mon, Nov 18, 2019 at 12:46:54PM +0000, Mark Brown wrote:

> > This is not new behaviour, all this change did was delay this.  We've
> > been powering off unused regulators for a bit over a decade.

> For me, this appeared first after upgrading from from 5.3.0-rc1 to 5.4.0-=
rc6.
> I guess the late initcall was executed before the regulator driver module=
 got
> loaded? And now, with the 30s delay, the regulator driver is finally ther=
e?
> Would that explain it?

If the regulator driver wasn't loaded you'd not see the power off on
late init, yes.

> > We power off regulators which aren't enabled by any driver and where we
> > have permission from the constraints to change the state.  If the
> > regulator can't be powered off then it should be flagged as always-on in
> > constraints, if a driver needs it the driver should be enabling the
> > regulator.

> How exactly? I have been looking for deficiencies in the driver, but found
> devm_regulator_get() should actually do the right thing (use_count++). Is
> that correct, or am I missing something?

Regulators are enabled using the regulator_enable() call, if a driver
hasn't called that and isn't for something like cpufreq where the
regulator is expected to be always on then it should expect that power
may be removed at any time, even if the core didn't do this another
consumer sharing the supply could do the same.  It's perfectly possible
and normal for a driver to enable and disable a regulator at runtime,
for example for power saving.

> > I don't folow what you're saying about probe deferral here at all,
> > sorry.

> I was worried about the regulator core handing out refs to the dummy
> regulator when the requesting driver wants to change the voltages next.

I don't follow at all, if a driver is calling regulator_get() and
regulator_put() repeatedly at runtime around voltage changes then it
sounds like the driver is extremely broken.  Further, if a supply has a
regulator provided in device tree then a dummy regulator will never be
provided for it. =20

> I concluded the requesting device driver would have to wait until the real
> regulator driver was registered. But either this somehow works or my eDP
> bridge is still powered on correctly from U-Boot. What does the warning
> "...  using dummy regulator" mean for the caller of regulator_get()?
> AFAICS the caller is then stuck with a reference to the dummy, correct?

If a dummy regulator has been provided then there is no possibility that
a real supply could be provided, there's not a firmware description of
one.  We use a dummy regulator to keep software working on the basis
that it's unlikely that the device can operate without power but lacking
any information on the regulator we can't actually control it.

--LHvWgpbS7VDUdu2f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl3SzVIACgkQJNaLcl1U
h9DUDwf/Z4j77tXJYQIn/HjxdCb5+MuI1ASptn0Iv8lJk7Umk9qO5Iqa4QxcJ67u
rD59BMJt2+rXlC6bfZEcvpP4P2/ENjqU66G0r06WIT/1rNOzrj+V7eLxifzYaaZQ
1T4QUbOXhTlJAfdAoVP5Eszkp06Lft9JwK0m6bV2iTFqrkbIe2liXJCujJB2eL+4
G3T7t4cGTCiHh+/pGWGLBx3mdmA/Lk33Cl5dh8vGNivbO/AljSUkgpYxMtEl/ne1
quKHcBJGPRUCUoBO3fgAPAKKXhA3Z3OjUALaU6HikSYS84Pj7EIVyo1tLyfLXwRg
3GP53TIKocK/4zJsUuKSPNyoL14L/w==
=mR8K
-----END PGP SIGNATURE-----

--LHvWgpbS7VDUdu2f--
