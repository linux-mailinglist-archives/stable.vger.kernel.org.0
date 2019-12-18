Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C23511247BB
	for <lists+stable@lfdr.de>; Wed, 18 Dec 2019 14:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726710AbfLRNLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Dec 2019 08:11:17 -0500
Received: from foss.arm.com ([217.140.110.172]:45812 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726545AbfLRNLR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Dec 2019 08:11:17 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AF3C930E;
        Wed, 18 Dec 2019 05:11:16 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C9673F718;
        Wed, 18 Dec 2019 05:11:16 -0800 (PST)
Date:   Wed, 18 Dec 2019 13:11:14 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Siddharth Kapoor <ksiddharth@google.com>, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: Kernel panic on Google Pixel devices due to regulator patch
Message-ID: <20191218131114.GD3219@sirena.org.uk>
References: <CAJRo92+eD9F6Q60yVY2PfwaPWO_8Dts8QwH7mhpJaem7SpLihg@mail.gmail.com>
 <20191218113458.GA3219@sirena.org.uk>
 <20191218122157.GA17086@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="GyRA7555PLgSTuth"
Content-Disposition: inline
In-Reply-To: <20191218122157.GA17086@kroah.com>
X-Cookie: Power is poison.
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--GyRA7555PLgSTuth
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 18, 2019 at 01:21:57PM +0100, Greg KH wrote:
> On Wed, Dec 18, 2019 at 11:34:58AM +0000, Mark Brown wrote:
> > On Tue, Dec 17, 2019 at 11:51:55PM +0800, Siddharth Kapoor wrote:

> > > I would like to share a concern with the regulator patch which is part of
> > > 4.9.196 LTS kernel.

> > That's an *extremely* old kernel.

> It is, but it's the latest stable kernel (well close to), and your patch
> was tagged by you to be backported to here, so if there's a problem with
> a stable branch, I want to know about it as I don't want to see
> regressions happen in it.

I don't track what's in older stable kernels, it wanted to go back at
least one kernel revision but the issue has been around since forever.

> > I've got nothing to do with the stable kernels so there's nothing I can
> > do here, sorry.

> Should I revert it everywhere?  This patch reads as it should be fixing
> problems, not causing them :)

The main targets were whatever Debian and Ubuntu are shipping (and to a
lesser extent SuSE or RHEL but they don't use stable directly), it's
less relevant to anything that only gets used on embedded stuff.  It's
right on the knife edge of what I'd backport but since that's way less
enthusiastic than stable is in general these days.

> > Possibly your GPU supplies need to be flagged as always on, possibly
> > your GPU driver is forgetting to enable some supplies it needs, or
> > possibly there's a missing always-on constraint on one of the regulators
> > depending on how the driver expects this to work (if it's a proprietary
> > driver it shouldn't be using the regulator API itself).  I'm quite
> > surprised you've not seen any issue before given that the supplies would
> > still be being disabled earlier.

> Timing "luck" is probably something we shouldn't be messing with in
> stable kernels.  How about I revert this for the 4.14 and older releases
> and let new devices deal with the timing issues when they are brought up
> on new hardware?

To be clear this is more a straight up bug in their stuff than the sort
of thing you'd normally think of as a race condition, we're talking
about moving the timing by 30 seconds here.  The case that we saw
already was just a clear and obvious bug that was made more visible (the
driver was using the wrong name for a supply so lookups were always
failing but some sequence of events meant it didn't produce big runtime
failures).

If you don't want to be messing with timing luck then you probably want
to be having a look at what Sasha's bot is doing, it's picking up a lot
of things that are *well* into this sort of territory (and the bad
interactions with out of tree code territory).  I personally would not
be using stable these days if I wasn't prepared to be digging into
something like this.

--GyRA7555PLgSTuth
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl36JXEACgkQJNaLcl1U
h9CT7Qf/TVaKu0vixHRm1UczK13aXCUS+DKM5tAHD67zj5F/xnkStUva72YMYqga
/W+110vzthWMX/aGDLxJbUXHrn+tNsRFxJ0TWRUOdErmN0g57XkCES6EDlFHHEDv
msLG2dbwXF4dtluv5sGkMlt30eoE6AX04L3FqTgpK0snX6X/4zo8CDRRyKbmKglR
2KNt52rPwXnN5q6Prik/XSfql09LVBjdjRBCnIhAT16Blx2Rf+xLjriiwASswx5I
VeRGU4//lFfDxJkuim8uVrPCgJzwwtc9lqaHc9qVXGBsHV5y6S3B4HCCDkNSbu/d
5m9kJle/UAQda5a5XxAlAVHtiydtuA==
=ZrHN
-----END PGP SIGNATURE-----

--GyRA7555PLgSTuth--
