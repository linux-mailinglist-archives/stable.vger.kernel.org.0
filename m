Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94C62100D1F
	for <lists+stable@lfdr.de>; Mon, 18 Nov 2019 21:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726536AbfKRU3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Nov 2019 15:29:53 -0500
Received: from foss.arm.com ([217.140.110.172]:39754 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726475AbfKRU3x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Nov 2019 15:29:53 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D0B9328;
        Mon, 18 Nov 2019 12:29:52 -0800 (PST)
Received: from localhost (unknown [10.37.6.21])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77B933F6C4;
        Mon, 18 Nov 2019 12:29:51 -0800 (PST)
Date:   Mon, 18 Nov 2019 20:29:49 +0000
From:   Mark Brown <broonie@kernel.org>
To:     Torsten Duwe <duwe@lst.de>
Cc:     Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] regulator: Defer init completion for a while after
 late_initcall
Message-ID: <20191118202949.GD43585@sirena.org.uk>
References: <20190904124250.25844-1-broonie@kernel.org>
 <20191116125233.GA5570@lst.de>
 <20191118124654.GD9761@sirena.org.uk>
 <20191118164101.GA7894@lst.de>
 <20191118165651.GK9761@sirena.org.uk>
 <20191118194012.GB7894@lst.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hoZxPH4CaxYzWscb"
Content-Disposition: inline
In-Reply-To: <20191118194012.GB7894@lst.de>
X-Cookie: Are we live or on tape?
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--hoZxPH4CaxYzWscb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 18, 2019 at 08:40:12PM +0100, Torsten Duwe wrote:
> On Mon, Nov 18, 2019 at 04:56:51PM +0000, Mark Brown wrote:

> > I don't follow at all, if a driver is calling regulator_get() and
> > regulator_put() repeatedly at runtime around voltage changes then it
> > sounds like the driver is extremely broken.  Further, if a supply has a
> > regulator provided in device tree then a dummy regulator will never be
> > provided for it. =20

> I'm afraid I must object here:
>=20
> kernel: anx6345 0-0038: 0-0038 supply dvdd12-supply not found, using dumm=
y regulator
> kernel: anx6345 0-0038: 0-0038 supply dvdd25-supply not found, using dumm=
y regulator

> DT has:
>   dvdd25-supply =3D <&reg_dldo2>;
>   dvdd12-supply =3D <&reg_dldo3>;

> It's only that the regulator driver module has not fully loaded at that p=
oint.

We substitute in the dummy regulator in regulator_get() if
regulator_dev_lookup() returns -ENODEV and a few other conditions are
satisfied.  When lookup up via DT regulator_dev_lookup() will use
of_find_regulator_by_node() to look up the regulator, if that lookup
fails it returns -EPROBE_DEFER.  Until we get to of_find_regulator_by_node()
we're just looking to see if nodes exist, not to see if anything is
registered.  What mechanism do you see causing issues?  If there's
something going wrong here it's in that area.

> > > AFAICS the caller is then stuck with a reference to the dummy, correc=
t?

> > If a dummy regulator has been provided then there is no possibility that
> > a real supply could be provided, there's not a firmware description of
> > one.  We use a dummy regulator to keep software working on the basis
> > that it's unlikely that the device can operate without power but lacking
> > any information on the regulator we can't actually control it.

> That's what I figured. I was fancying some hash table for yet unkown
> regulators with callbacks to those who had asked. Or the EPROBE_DEFER
> to have them come back later. Maybe initrd barriers would help.

Like I've been saying attempts to get a regulator will defer unless the
core can confirm that the regulator can't be resolved.

I don't know what an initrd barrier is but anything that relies on
initrds not going to help with trying to figure out when userspace is
ready since there's no requirement for userspace to use an initrd at all
let alone put all modules in there.

> So is my understanding correct that with the above messages, the anx6345
> driver will never be able to control those voltages for real?
> And additionally, the real regulator's use count will remain 0 unless the=
re
> are other users (which there aren't)?

If the consumer driver is gets a reference to the dummy regulator it's
going to continue to have a reference to the dummy regulator.

> Again: this all didn't matter before this init completion code was moved
> to the right location. Power management wouldn't work, but at least the
> established voltages stayed on.

As far as I can tell whatever is going on with your system it's only
ever been working through luck.  Without any specific references to
what's going on in the system it's hard to tell what might be happening,
it looks like you're working with out of tree code here so it's possible
there's something going on in there and your use of non-standard
terminology makes it a bit hard to follow.

--hoZxPH4CaxYzWscb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl3S/zwACgkQJNaLcl1U
h9Ah/Af/c/71LCy3SIA/+OV+eAV62vp7PW/U11VkTMnP/8JTusv0t6NdClinnwrI
tLx3jVFkPXzauk90sWBYmEo3OaRToPkTl5e3qGAACJLcdZoAOdx+yK4jRh7D1ygC
PReCZCgbHLobTew3lX3f7tzvjvT3Cp/Pc+tAVF6Q3osH4JUS0rx0PW3C+j9xNsN3
Th/Hvb/EWuS3Dr9z5JxqThouiG75W5zuyohL7OsjIb60yk2mS4ak6V0DE6+ZlnqX
A9hW1cm1dPnjc70DwuBbOcxTd7QKYN7wHhb7RIjEKMKY5Z4CPRgUGdofO9gh0Ro1
Y5NXfyII6s+LTsHl9tX5Bh1NKARP4Q==
=zh1w
-----END PGP SIGNATURE-----

--hoZxPH4CaxYzWscb--
