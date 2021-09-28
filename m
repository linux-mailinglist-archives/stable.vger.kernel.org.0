Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEDA41B827
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 22:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbhI1ULM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 16:11:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:40386 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242679AbhI1ULM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 16:11:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFC9A611BD;
        Tue, 28 Sep 2021 20:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632859772;
        bh=1zjiJRB4COENYADtGBiO8bi9VSTzBhcEvxXTXQ4YCJE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dz0C6jtbZVt+WG3dNRtf+Uc9eF5JOWHAvfNIrrYzMIOTtnDRCp+/azIndIeYUhuhS
         GGj9WX0TpZ5ehMF/69Pmyeuh3/ucdVx+qA3a0SrYvsaqxSgZV0shpnjQj0dgnvtlDW
         GK5b7nwNLoS1JV2QEWs0jn4T3pv6UNuQ3GOrIAsdusi/ot+w2ueV1sdE8WVRcdnqZX
         cgiO+4gf5OFvRgfRTooLYYuaVZiaQIlw1bPQgPWn+ImuCn12t1mkZQ50n8ZtXb4XEj
         c908lF8UTPW0K3QMGBiV0IMqbWqaiGDPylrbcjaaPN5jbUKJVQP3alF56n6OkfPFBJ
         vyPqI1c2el5Eg==
Date:   Tue, 28 Sep 2021 21:08:43 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     f.fainelli@gmail.com, rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, nsaenz@kernel.org,
        linux-spi@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        jgg@ziepe.ca, p.rosenberger@kunbus.com,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] spi: bcm2835: do not unregister controller in shutdown
 handler
Message-ID: <20210928200843.GM4199@sirena.org.uk>
References: <20210928195657.5573-1-LinoSanfilippo@gmx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="B9BE8dkJ1pIKavwa"
Content-Disposition: inline
In-Reply-To: <20210928195657.5573-1-LinoSanfilippo@gmx.de>
X-Cookie: 98% lean.
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--B9BE8dkJ1pIKavwa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 28, 2021 at 09:56:57PM +0200, Lino Sanfilippo wrote:
> Do not unregister the SPI controller in the shutdown handler. The reason
> to avoid this is that controller unregistration results in the slave
> devices remove() handler being called which may be unexpected for slave
> drivers at system shutdown.
>=20
> One example is if the BCM2835 driver is used together with the TPM SPI
> driver:
> At system shutdown first the TPM chip devices (pre) shutdown handler
> (tpm_class_shutdown) is called, stopping the chip and setting an operatio=
ns
> pointer to NULL.
> Then since the BCM2835 shutdown handler unregisters the SPI controller the
> TPM SPI remove function (tpm_tis_spi_remove) is also called. In case of
> TPM 2 this function accesses the now nullified operations pointer,
> resulting in the following NULL pointer access:
>=20
> [  174.078277] 8<--- cut here ---
> [  174.078288] Unable to handle kernel NULL pointer dereference at virtua=
l address 00000034
> [  174.078293] pgd =3D 557a5fc9
> [  174.078300] [00000034] *pgd=3D031cf003, *pmd=3D00000000
> [  174.078317] Internal error: Oops: 206 [#1] SMP ARM
> [  174.078323] Modules linked in: tpm_tis_spi tpm_tis_core tpm spidev gpi=
o_pca953x mcp320x rtc_pcf2127 industrialio regmap_i2c regmap_spi 8021q garp=
 stp llc ftdi_sio6

Please think hard before including complete backtraces in upstream
reports, they are very large and contain almost no useful information
relative to their size so often obscure the relevant content in your
message. If part of the backtrace is usefully illustrative (it often is
for search engines if nothing else) then it's usually better to pull out
the relevant sections.

--B9BE8dkJ1pIKavwa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmFTdkoACgkQJNaLcl1U
h9CTzgf9HUmFe5BoskDVSI+tZ1ZSUUmxs3qmjAsP2XzBPZp/I7ktj6J+xN+F2iIy
hgzIj3PGq+/ytsrwbcQC1mNWCjseYHVAaDWyBzKnP8MLMp0g7LrpatFM/BSPmoTK
3n2tvz8Hi+GK0q2I8aqw+JKku5QC+kz7VN4ppt+MfwMfswxpMwBgrY44uJh5aPE6
i+iJjseUk9USwDgTvD9so28Vpk+iOwWvYAoVwgH3vZghRaJ80lJ9Uhv+dwyrmBVt
/GMSxG8AtRWyHbYfegaCMdh/PX0tWYfAE2Pzg9qQgVzLW2t0jju2YZz7d+b48fhN
2hT9RxJ6bnNzZ2U8LQ/e+giE8r5swQ==
=ztne
-----END PGP SIGNATURE-----

--B9BE8dkJ1pIKavwa--
