Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90881CFA65
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 14:51:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730958AbfJHMvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 08:51:23 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41171 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730541AbfJHMvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 08:51:23 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 01A4680311; Tue,  8 Oct 2019 14:51:05 +0200 (CEST)
Date:   Tue, 8 Oct 2019 14:51:20 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Alexander Steffen <Alexander.Steffen@infineon.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 001/106] tpm: use tpm_try_get_ops() in tpm-sysfs.c.
Message-ID: <20191008125120.GF608@amd>
References: <20191006171124.641144086@linuxfoundation.org>
 <20191006171125.167365005@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0rSojgWGcpz+ezC3"
Content-Disposition: inline
In-Reply-To: <20191006171125.167365005@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0rSojgWGcpz+ezC3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2019-10-06 19:20:07, Greg Kroah-Hartman wrote:
> From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
>=20
> commit 2677ca98ae377517930c183248221f69f771c921 upstream
>=20
> Use tpm_try_get_ops() in tpm-sysfs.c so that we can consider moving
> other decorations (locking, localities, power management for example)
> inside it. This direction can be of course taken only after other call
> sites for tpm_transmit() have been treated in the same way.

This changes locking completely:

> @@ -244,10 +274,12 @@ static ssize_t cancel_store(struct device *dev, str=
uct device_attribute *attr,
>  			    const char *buf, size_t count)
>  {
>  	struct tpm_chip *chip =3D to_tpm_chip(dev);
> -	if (chip =3D=3D NULL)
> +
> +	if (tpm_try_get_ops(chip))
>  		return 0;
> =20
>  	chip->ops->cancel(chip);
> +	tpm_put_ops(chip);
>  	return count;
>  }
>  static DEVICE_ATTR_WO(cancel);

For example this did not have any locking, and is now protected by

        get_device(&chip->dev);

        down_read(&chip->ops_sem);

=2E Is that intended? Is this known to fix any bugs?

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--0rSojgWGcpz+ezC3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2chkgACgkQMOfwapXb+vL3pwCeK3IF82vko0V0QD9OjQKUm4xq
NgAAoLRw/Djduv5WqrwpppO/tYpmYyCQ
=HN91
-----END PGP SIGNATURE-----

--0rSojgWGcpz+ezC3--
