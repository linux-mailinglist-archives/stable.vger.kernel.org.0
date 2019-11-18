Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B12701005D7
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 13:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfKRMq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 07:46:57 -0500
Received: from foss.arm.com ([217.140.110.172]:34078 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726668AbfKRMq5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 07:46:57 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C06CE1FB;
        Mon, 18 Nov 2019 04:46:56 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 301253F6C4;
        Mon, 18 Nov 2019 04:46:56 -0800 (PST)
Date:   Mon, 18 Nov 2019 12:46:54 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Torsten Duwe <duwe@lst.de>
Cc:     Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] regulator: Defer init completion for a while after
 late_initcall
Message-ID: <20191118124654.GD9761@sirena.org.uk>
References: <20190904124250.25844-1-broonie@kernel.org>
 <20191116125233.GA5570@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="C1iGAkRnbeBonpVg"
Content-Disposition: inline
In-Reply-To: <20191116125233.GA5570@lst.de>
X-Cookie: no maintenance:
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--C1iGAkRnbeBonpVg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Nov 16, 2019 at 01:52:33PM +0100, Torsten Duwe wrote:
> On Wed, 4 Sep 2019 13:42:50 +0100 Mark Brown <broonie@kernel.org> wrote:

> > In the absence of any better idea just defer the powering off for 30s
> > after late_initcall(), this is obviously a hack but it should mask the
> > issue for now and it's no more arbitrary than late_initcall() itself.
> > Ideally we'd have some heuristics to detect if we're on an affected
> > system and tune or skip the delay appropriately, and there may be some
> > need for a command line option to be added.

> Am I the only one having problems with this change? I get

I've had no reports of any problems.

> [   11.917136] anx6345 0-0038: 0-0038 supply dvdd12-supply not found, using dummy regulator
> [   11.917174] axp20x-rsb sunxi-rsb-3a3: AXP20x variant AXP803 found

> Despite being loaded as a very early module, PMIC init ^^^ only starts now.

I'm very surprised that anything to do with resolving incomplete
constraints would be affected by this change.  The only thing we do in
the defered bit of init is power off unused regulators which has no
bearing on registration at all.  The only thing that might have a
bearing on this is marking the sytem as having full constraints but
that's still directly in the initcall, not deferred.

> But much later on

> [   38.248573] dcdc4: disabling
> [   38.268493] vcc-pd: disabling
> [   38.288446] vdd-edp: disabling

> screen goes dark and stays dark. Use count of the regulators is 0. I guess
> this is because the driver code had been returned the dummy instead?

This is not new behaviour, all this change did was delay this.  We've
been powering off unused regulators for a bit over a decade.

> It's a mobile device so in principle there is nothing wrong with powering
> down unused circuitry, and always-on is not an option.
> Am I correct to perceive this solution as not 100% mature yet? The anx6345

Like I say this is not in any way new and pretty stable.

> driver in particular needs to do a little "voltage dance" with specific
> timing on the real regulators should the device come up really unpowered,
> so IMHO it's probably neccessary to return EPROBE_DEFER at least in this
> particular case and prepare the driver for it? Or what would be the real
> solution in this case?

We power off regulators which aren't enabled by any driver and where we
have permission from the constraints to change the state.  If the
regulator can't be powered off then it should be flagged as always-on in
constraints, if a driver needs it the driver should be enabling the
regulator.

I don't folow what you're saying about probe deferral here at all,
sorry.

--C1iGAkRnbeBonpVg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl3Skr0ACgkQJNaLcl1U
h9B1WAf+MdiCuvhr04BgKnPlEzT0g1FHj55+aRqSyitefmztt2TmO0nRuv8s3eOU
B9fc8erSk4KolvPT8lQ6fHsqtyg4yytFD7odddDvSRYY8T/V83MLwiReUWgpBS8o
RADNnmTzn65wqvAG0ukK5AYvXQDspU4etRxICdKOAYamtn/HDIVhaGDMbfUFQ7+W
xxzHdB1TwPQeISPqez9/g+OkXvy4EyKNT4Ffg9/KU2wlnyKddGX1HY56jCmXAMDf
d7+0JDCrtM3/69UDBNN0akoQWUkKr6Y/4+RNXzlKW/a8fAoGGAnuLvQcRPosziXw
W7B+E2j3mik3wUS/+k29r0rtgjEL0w==
=kN3L
-----END PGP SIGNATURE-----

--C1iGAkRnbeBonpVg--
