Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D518378F08
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241178AbhEJN1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:27:14 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:54446 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233896AbhEJMHF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 08:07:05 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8E4331C0B7C; Mon, 10 May 2021 14:05:54 +0200 (CEST)
Date:   Mon, 10 May 2021 14:05:54 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shixin Liu <liushixin2@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 104/299] crypto: stm32/hash - Fix PM reference leak
 on stm32-hash.c
Message-ID: <20210510120554.GB3547@duo.ucw.cz>
References: <20210510102004.821838356@linuxfoundation.org>
 <20210510102008.377102138@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <20210510102008.377102138@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> pm_runtime_get_sync will increment pm usage counter even it failed.
> Forgetting to putting operation will result in reference leak here.
> Fix it by replacing it with pm_runtime_resume_and_get to keep usage
> counter balanced.

I believe we need to enforce "patches need to be tested" rule at least
against robots.

Code was correct in 3/4 instances, this introduces bugs. Yes, last one
needs fixing.

Best regards,
								Pavel

> +++ b/drivers/crypto/stm32/stm32-hash.c
> @@ -812,7 +812,7 @@ static void stm32_hash_finish_req(struct ahash_reques=
t *req, int err)
>  static int stm32_hash_hw_init(struct stm32_hash_dev *hdev,
>  			      struct stm32_hash_request_ctx *rctx)
>  {
> -	pm_runtime_get_sync(hdev->dev);
> +	pm_runtime_resume_and_get(hdev->dev);
> =20
>  	if (!(HASH_FLAGS_INIT & hdev->flags)) {
>  		stm32_hash_write(hdev, HASH_CR, HASH_CR_INIT);
> @@ -961,7 +961,7 @@ static int stm32_hash_export(struct ahash_request *re=
q, void *out)
>  	u32 *preg;
>  	unsigned int i;
> =20
> -	pm_runtime_get_sync(hdev->dev);
> +	pm_runtime_resume_and_get(hdev->dev);
> =20
>  	while ((stm32_hash_read(hdev, HASH_SR) & HASH_SR_BUSY))
>  		cpu_relax();
> @@ -999,7 +999,7 @@ static int stm32_hash_import(struct ahash_request *re=
q, const void *in)
> =20
>  	preg =3D rctx->hw_context;
> =20
> -	pm_runtime_get_sync(hdev->dev);
> +	pm_runtime_resume_and_get(hdev->dev);
> =20
>  	stm32_hash_write(hdev, HASH_IMR, *preg++);
>  	stm32_hash_write(hdev, HASH_STR, *preg++);

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYJkhogAKCRAw5/Bqldv6
8v/SAKCt0vlNj8WNcw3FsHi/g5drvv9CugCfQnV2lUXyG4V2RpeJ7VBSwT893TI=
=oHNw
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
