Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5714B2E81E4
	for <lists+stable@lfdr.de>; Thu, 31 Dec 2020 21:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbgLaUJ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Dec 2020 15:09:57 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:56548 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgLaUJ5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Dec 2020 15:09:57 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A1CF51C0B79; Thu, 31 Dec 2020 21:09:14 +0100 (CET)
Date:   Thu, 31 Dec 2020 21:09:13 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 4.19 287/346] crypto: ecdh - avoid unaligned accesses in
 ecdh_set_secret()
Message-ID: <20201231200913.GA32313@amd>
References: <20201228124919.745526410@linuxfoundation.org>
 <20201228124933.649086790@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20201228124933.649086790@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> ecdh_set_secret() casts a void* pointer to a const u64* in order to
> feed it into ecc_is_key_valid(). This is not generally permitted by
> the C standard, and leads to actual misalignment faults on ARMv6
> cores. In some cases, these are fixed up in software, but this still
> leads to performance hits that are entirely avoidable.
>=20
> So let's copy the key into the ctx buffer first, which we will do
> anyway in the common case, and which guarantees correct alignment.

Fair enough... but: params.key_size is validated in
ecc_is_key_valid(), and that now happens _after_ memcpy.

How is it guaranteed that we don't overflow the buffer during memcpy?

> +++ b/crypto/ecdh.c
> @@ -57,12 +57,13 @@ static int ecdh_set_secret(struct crypto
>  		return ecc_gen_privkey(ctx->curve_id, ctx->ndigits,
>  				       ctx->private_key);
> =20
> -	if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
> -			     (const u64 *)params.key, params.key_size) < 0)
> -		return -EINVAL;
> -
>  	memcpy(ctx->private_key, params.key, params.key_size);
> =20
> +	if (ecc_is_key_valid(ctx->curve_id, ctx->ndigits,
> +			     ctx->private_key, params.key_size) < 0) {
> +		memzero_explicit(ctx->private_key, params.key_size);
> +		return -EINVAL;
> +	}
>  	return 0;

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl/uL+kACgkQMOfwapXb+vL/zgCfV9frB8aOKtDBX6hBaRHumNTR
sMoAn0AMBIwfvbTX3PKLzZAL8rhBosyQ
=X5PK
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
