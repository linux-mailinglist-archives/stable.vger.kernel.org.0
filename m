Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7240142146D
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 18:52:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237482AbhJDQx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 12:53:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:56920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235435AbhJDQx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 12:53:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A07C61002;
        Mon,  4 Oct 2021 16:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633366328;
        bh=TlKibtnTQDiln93Sx9JAoPg4ztXW/wHOmGDFazZ0vrs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tyFnPDR6qmo5bPllhBMYl4i0McPmK+DZJNKY28OapPbJxBouXvi+h3xOEywwb8/8D
         oiTwVDh0qwkqhjuOxOquaVJFgDDS/6v3eMgxYX1twSk54niX9aA5v/DYvNBFalnoiS
         YTnsyk2l9M9fzRSBpWGDIDLz9D7xEWkxI+pNLAgbsVEr5DeKZ8Zgn6SB9hKK+/dEb6
         AepgJ7Q190BC/fuTFQFJfKbPurxniqnedXABEJ9BCu+VmLCrmjNMPBV32jnoctDmR3
         jw89u8vH27hyvH8azFlMFJopa0JOg7OiBfmx46C7jQY2JoNnbBESsGM51EqF1MSzOc
         OBE8nrf8bvnBg==
Date:   Mon, 4 Oct 2021 17:52:06 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>, rjui@broadcom.com,
        sbranden@broadcom.com, bcm-kernel-feedback-list@broadcom.com,
        nsaenz@kernel.org, linux-spi@vger.kernel.org,
        linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        p.rosenberger@kunbus.com, linux-integrity@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] spi: bcm2835: do not unregister controller in shutdown
 handler
Message-ID: <YVsxNiyZ3CuZTXqE@sirena.org.uk>
References: <20210928195657.5573-1-LinoSanfilippo@gmx.de>
 <20211001175422.GA53652@sirena.org.uk>
 <2c4d7115-7a02-f79e-c91b-3c2dd54051b2@gmx.de>
 <YVr4USeiIoQJ0Pqh@sirena.org.uk>
 <20211004131756.GW3544071@ziepe.ca>
 <YVsLxHMCdXf4vS+i@sirena.org.uk>
 <20211004154436.GY3544071@ziepe.ca>
 <YVssWYaxuQDi8jI5@sirena.org.uk>
 <e68b04ab-831b-0ed5-074a-0879194569f9@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NkhA+eQhCG0AGXrT"
Content-Disposition: inline
In-Reply-To: <e68b04ab-831b-0ed5-074a-0879194569f9@gmail.com>
X-Cookie: If it heals good, say it.
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--NkhA+eQhCG0AGXrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 04, 2021 at 09:36:37AM -0700, Florian Fainelli wrote:
> On 10/4/21 9:31 AM, Mark Brown wrote:

> > an issue, someone could press a button or whatever.  Frankly for SPI the
> > quiescing part doesn't seem like logic that should be implemented in
> > drivers, it's a subsystem level thing since there's nothing driver
> > specific about it.

> Surely the SPI subsystem can help avoid queuing new transfers towards
> the SPI controller while the controller can shut down the resources that
> only it knows about.

Yes, that's what I was saying.

> > In the case of this specific driver I'm still not clear that the best
> > thing isn't just to delete the shutdown callback and let any ongoing
> > transfers complete, though I guess there'd be issues in kexec cases with
> > long enough tansfers.

> No please don't, I should have arguably justified the reasons why
> better, but the main reason is that one of the platforms on which this
> driver is used has received extensive power management analysis and
> changes, and shutting down every bit of hardware, including something as
> small as a SPI controller, and its clock (and its PLL) helped meet
> stringent power targets.

OK, so it's similar to a lot of the other embedded cases where it's for
a power down that doesn't cut as much power as would be desirable -
that's reasonable.  Like you say you didn't mention it at all in the
changelog.  Ideally the hardware would just cut all power to the SoC in
shutdown but then IIRC those boards don't have a PMIC so... =20

> TBH, I still wonder why we have .shutdown() and we simply don't use
> .remove() which would reduce the amount of work that people have to do
> validate that the hardware is put in a low power state and would also
> reduce the amount of burden on the various subsystems.

Yeah, it does seem a bit odd - I'd figured it was for speed reasons.

--NkhA+eQhCG0AGXrT
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFbMTUACgkQJNaLcl1U
h9AA1Af/Q6z/QCECDa+K+0K6vtHCOf97xY7129bjpQG+wVUoD4F+pK2pQBDd77Pb
e/Dh4T78b9DwWIlQG4MAhBOeuAfnBXDwXTHN5OMpUrAF6vJY5CzCMO2GSt06kqBr
pGx3shDth2dlymg3VuEkNqAylrEQJbIeWcBt0w9yLTUy5Dd9UXHVLSaINjam2IVz
jcx5E4YhfNVTU1GiC0D5+dc0t3hU1ECe7b6M6LHGIqRaa1HaWzQuuDCjUBtJXtct
bGvHz2rDuEVS1mcWvoZX8w8c70YWCGRiXm7W5rF7yIJ5CyATCd1gLP4G2Rjexstw
faaGCJdUGSgle5NMA1wJwy2UDr4aVQ==
=uNSe
-----END PGP SIGNATURE-----

--NkhA+eQhCG0AGXrT--
