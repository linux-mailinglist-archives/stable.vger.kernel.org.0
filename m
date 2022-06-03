Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D5D53C817
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 12:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236738AbiFCKGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 06:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240691AbiFCKGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 06:06:19 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61FE3AA55;
        Fri,  3 Jun 2022 03:06:16 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0AC111C0B9B; Fri,  3 Jun 2022 12:06:14 +0200 (CEST)
Date:   Fri, 3 Jun 2022 12:06:13 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        theflamefire89@gmail.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 4.9 34/48] ASoC: ops: Reject out of bounds values in
 snd_soc_put_volsw_sx()
Message-ID: <20220603100613.GA26825@duo.ucw.cz>
References: <20220207103752.341184175@linuxfoundation.org>
 <20220207103753.450763414@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <20220207103753.450763414@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 4f1e50d6a9cf9c1b8c859d449b5031cacfa8404e upstream.
>=20
> We don't currently validate that the values being set are within the range
> we advertised to userspace as being valid, do so and reject any values
> that are out of range.

We are getting reports that this commit breaks audio on some
phones... and indeed it looks like "+ min" is missing in first condition:

https://github.com/baunilla/android_kernel_xiaomi_rosy/commit/969b9d366c1e9=
564e173aea325ec544dcd7804ff

	val =3D ucontrol->value.integer.value[0];
-=EF=BF=BC	if (mc->platform_max && val > mc->platform_max)
+=EF=BF=BC	if (mc->platform_max && ((int)val + min) > mc->platform_max)
=EF=BF=BC		return -EINVAL;

What needs to be done to get this fixed?

Best regards,
								Pavel

Reported-by: <theflamefire89@gmail.com>

> Signed-off-by: Mark Brown <broonie@kernel.org>
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/r/20220124153253.3548853-3-broonie@kernel.o=
rg
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  sound/soc/soc-ops.c |    9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>=20
> --- a/sound/soc/soc-ops.c
> +++ b/sound/soc/soc-ops.c
> @@ -441,8 +441,15 @@ int snd_soc_put_volsw_sx(struct snd_kcon
>  	int err =3D 0;
>  	unsigned int val, val_mask, val2 =3D 0;
> =20
> +	val =3D ucontrol->value.integer.value[0];
> +	if (mc->platform_max && val > mc->platform_max)
> +		return -EINVAL;
> +	if (val > max - min)
> +		return -EINVAL;
> +	if (val < 0)
> +		return -EINVAL;
>  	val_mask =3D mask << shift;
> -	val =3D (ucontrol->value.integer.value[0] + min) & mask;
> +	val =3D (val + min) & mask;
>  	val =3D val << shift;
> =20
>  	err =3D snd_soc_component_update_bits(component, reg, val_mask, val);
>=20

--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYpndFQAKCRAw5/Bqldv6
8k3FAKCjLh7kaQsEDX4qEe1pjhdvCBxDywCfSPF5ssU3eqZ3yTuYTjECzmhhkqc=
=1S7z
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
