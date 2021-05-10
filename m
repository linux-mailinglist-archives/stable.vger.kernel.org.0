Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88724378F0A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235863AbhEJN1W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:27:22 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54664 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234630AbhEJMIs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 08:08:48 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6848E1C0B7F; Mon, 10 May 2021 14:07:42 +0200 (CEST)
Date:   Mon, 10 May 2021 14:07:42 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shixin Liu <liushixin2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 105/299] crypto: stm32/cryp - Fix PM reference leak
 on stm32-cryp.c
Message-ID: <20210510120742.GC3547@duo.ucw.cz>
References: <20210510102004.821838356@linuxfoundation.org>
 <20210510102008.407819731@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kVXhAStRUZ/+rrGn"
Content-Disposition: inline
In-Reply-To: <20210510102008.407819731@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kVXhAStRUZ/+rrGn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2021-05-10 12:18:22, Greg Kroah-Hartman wrote:
> From: Shixin Liu <liushixin2@huawei.com>
>=20
> [ Upstream commit 747bf30fd944f02f341b5f3bc7d97a13f2ae2fbe ]
>=20
> pm_runtime_get_sync will increment pm usage counter even it failed.
> Forgetting to putting operation will result in reference leak here.
> Fix it by replacing it with pm_runtime_resume_and_get to keep usage
> counter balanced.

Yes, but that only works when code checks the return value.

> +++ b/drivers/crypto/stm32/stm32-cryp.c
> @@ -542,7 +542,7 @@ static int stm32_cryp_hw_init(struct stm32_cryp *cryp)
>  	int ret;
>  	u32 cfg, hw_mode;
> =20
> -	pm_runtime_get_sync(cryp->dev);
> +	pm_runtime_resume_and_get(cryp->dev);
> =20
>  	/* Disable interrupt */
>  	stm32_cryp_write(cryp, CRYP_IMSCR, 0);

Again, this is wrong.

> @@ -2043,7 +2043,7 @@ static int stm32_cryp_remove(struct platform_device=
 *pdev)
>  	if (!cryp)
>  		return -ENODEV;
> =20
> -	ret =3D pm_runtime_get_sync(cryp->dev);
> +	ret =3D pm_runtime_resume_and_get(cryp->dev);
>  	if (ret < 0)
>  		return ret;
> =20

But this may be right.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--kVXhAStRUZ/+rrGn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYJkiDgAKCRAw5/Bqldv6
8jAUAJ4sCCOB4Iu67jIwt5xH1DGKnA1rngCeMAdwdlkpwrCsBOHr5fmCHel8j+k=
=ZzZU
-----END PGP SIGNATURE-----

--kVXhAStRUZ/+rrGn--
