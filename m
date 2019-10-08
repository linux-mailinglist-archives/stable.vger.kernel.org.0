Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCB29CF63E
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 11:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729928AbfJHJlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 05:41:25 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35673 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729790AbfJHJlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 05:41:24 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 2EE0C803E2; Tue,  8 Oct 2019 11:41:07 +0200 (CEST)
Date:   Tue, 8 Oct 2019 11:41:21 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        Douglas Anderson <dianders@chromium.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 002/106] tpm: Fix TPM 1.2 Shutdown sequence to
 prevent future TPM operations
Message-ID: <20191008094121.GA608@amd>
References: <20191006171124.641144086@linuxfoundation.org>
 <20191006171126.123065744@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20191006171126.123065744@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Vadim Sukhomlinov <sukhomlinov@google.com>
>=20
> commit db4d8cb9c9f2af71c4d087817160d866ed572cc9 upstream
>=20
> TPM 2.0 Shutdown involve sending TPM2_Shutdown to TPM chip and disabling
> future TPM operations. TPM 1.2 behavior was different, future TPM
> operations weren't disabled, causing rare issues. This patch ensures
> that future TPM operations are disabled.
=2E..

> --- a/drivers/char/tpm/tpm-chip.c
> +++ b/drivers/char/tpm/tpm-chip.c
> @@ -187,12 +187,13 @@ static int tpm_class_shutdown(struct device *dev)
>  {
>  	struct tpm_chip *chip =3D container_of(dev, struct tpm_chip, dev);
> =20
> +	down_write(&chip->ops_sem);
>  	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
> -		down_write(&chip->ops_sem);
>  		tpm2_shutdown(chip, TPM2_SU_CLEAR);
>  		chip->ops =3D NULL;
> -		up_write(&chip->ops_sem);
>  	}
> +	chip->ops =3D NULL;
> +	up_write(&chip->ops_sem);
> =20
>  	return 0;
>  }

Still can be improved -- chip->ops =3D NULL; is done twice, copy inside
the if {} is redundant...

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2cWcEACgkQMOfwapXb+vLbYgCffR+Ik90cUuBHAYxxqbhhX8S4
ir0An1MyxGfX0btyAtBfH9oInfWUUBFA
=XvM4
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
