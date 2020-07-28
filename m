Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8596622FE62
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 02:14:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgG1AOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 20:14:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:48866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgG1AOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 20:14:37 -0400
Received: from earth.universe (unknown [185.213.155.232])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C20720786;
        Tue, 28 Jul 2020 00:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595895276;
        bh=ZjobJSwZTEqZyVrwiktFvrw1vDV/J3FUevuLNucXXFc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e8KCm+Y3BCUyd4X4m0k/p+tKC3n2uKI2tdY20iYqirpt96wqVDUEQW0cCTjYGucmW
         Y1x80Hd6FfPETETaD++tHBrDREMnmz47v3lJN8f7FZL7A+MiSQlUpawlspAX0zJ1xj
         rQ3VMuYwEW5p4nGJESg2Dd9CRDHeswYqIgSRtBKM=
Received: by earth.universe (Postfix, from userid 1000)
        id 946063C0B87; Tue, 28 Jul 2020 02:14:34 +0200 (CEST)
Date:   Tue, 28 Jul 2020 02:14:34 +0200
From:   Sebastian Reichel <sre@kernel.org>
To:     trix@redhat.com
Cc:     anton.vorontsov@linaro.org, jtzhou@marvell.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] power: supply: check if calc_soc succeeded in
 pm860x_init_battery
Message-ID: <20200728001434.3thznd6a35ycb3f2@earth.universe>
References: <20200712192351.15428-1-trix@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pfzhq2sgckiqqd5s"
Content-Disposition: inline
In-Reply-To: <20200712192351.15428-1-trix@redhat.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pfzhq2sgckiqqd5s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jul 12, 2020 at 12:23:51PM -0700, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
>=20
> clang static analysis flags this error
>=20
> 88pm860x_battery.c:522:19: warning: Assigned value is
>   garbage or undefined [core.uninitialized.Assign]
>                 info->start_soc =3D soc;
>                                 ^ ~~~
> soc is set by calling calc_soc.
> But calc_soc can return without setting soc.
>=20
> So check the return status and bail similarly to other
> checks in pm860x_init_battery and initialize soc to
> silence the warning.
>=20
> Fixes: a830d28b48bf ("power_supply: Enable battery-charger for 88pm860x")
>=20
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---

Thanks, queued.

-- Sebastian

>  drivers/power/supply/88pm860x_battery.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/power/supply/88pm860x_battery.c b/drivers/power/supp=
ly/88pm860x_battery.c
> index 1308f3a185f3..590da88a17a2 100644
> --- a/drivers/power/supply/88pm860x_battery.c
> +++ b/drivers/power/supply/88pm860x_battery.c
> @@ -433,7 +433,7 @@ static void pm860x_init_battery(struct pm860x_battery=
_info *info)
>  	int ret;
>  	int data;
>  	int bat_remove;
> -	int soc;
> +	int soc =3D 0;
> =20
>  	/* measure enable on GPADC1 */
>  	data =3D MEAS1_GP1;
> @@ -496,7 +496,9 @@ static void pm860x_init_battery(struct pm860x_battery=
_info *info)
>  	}
>  	mutex_unlock(&info->lock);
> =20
> -	calc_soc(info, OCV_MODE_ACTIVE, &soc);
> +	ret =3D calc_soc(info, OCV_MODE_ACTIVE, &soc);
> +	if (ret < 0)
> +		goto out;
> =20
>  	data =3D pm860x_reg_read(info->i2c, PM8607_POWER_UP_LOG);
>  	bat_remove =3D data & BAT_WU_LOG;
> --=20
> 2.18.1
>=20

--pfzhq2sgckiqqd5s
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAl8fbeoACgkQ2O7X88g7
+pqbiBAAi9zcDp6J8QZGB6XRbzvLzMzWfszhICGReM5sXZStY/KBHXOGZ1letSUH
zfDOA3Wi1nZrM7LgLYLCAoksCWKM3ai0oEAvTfcKUq9Jj25/5DIEFNvXhCjYRiXK
RNpW8pXVJD7HKcAGv4+pwv3Fx2WKVm6pck3mvYhM+o0HFMWaaOyEegvYMV5NmmSJ
7VScVl3foQIiX8ctIfeLiToYIhEug/40Ynw4Eu3tj7cxF1iqhp6vlB+A/V6FHWD3
VpovUY2FAs9gpbDVTRTp8oMWYYvSsx5dMSn2/fZIP/TfpCATvATt4UdIfSClgZtg
pVRWxbml629NXxFivox83t+7gDZVUJ7nPjlnN6OjlJIpuyZ3jcTOhQvVVYa8PevS
72Zu0n+U2bqnHLHNxg/hBigayVvDH4rrZn2MqNFXjenheCC2yz53Jl9Oa7ZqT5yP
S5fp17BWD4IsTCvzVQNV6nAfTwg4d8O4y1RAzYxwgLs9655DeNIqbmHRXq7iSLe7
Xnz0PFdeISNjZ5rebCKDFDQBr5uUr0Dl8j99NHna/LQywpOIelLW+VgAj1C3XSMd
AnW5YsUZFF7aljBxKHmWvm0tniUjLneGXbkfMXT1BlQNQZ/JBrMdEWipD6mdGkav
preS4jDKBhMK8uGu7lauMtPNq1xhJ0X1iuRAJaJQ3LERJx/VA5E=
=Lr1T
-----END PGP SIGNATURE-----

--pfzhq2sgckiqqd5s--
