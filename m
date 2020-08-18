Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A69072481D2
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 11:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbgHRJWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 05:22:35 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46126 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726145AbgHRJWf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 05:22:35 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 4BC761C0BB6; Tue, 18 Aug 2020 11:22:32 +0200 (CEST)
Date:   Tue, 18 Aug 2020 11:22:31 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Markus Elfring <Markus.Elfring@web.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 012/168] crypto: ccree - fix resource leak on error
 path
Message-ID: <20200818092231.GA10974@amd>
References: <20200817143733.692105228@linuxfoundation.org>
 <20200817143734.336080170@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <20200817143734.336080170@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Fix a small resource leak on the error path of cipher processing.

I believe this one is wrong.

> @@ -149,10 +148,19 @@ static int cc_cipher_init(struct crypto_tfm *tfm)
>  	ctx_p->flow_mode =3D cc_alg->flow_mode;
>  	ctx_p->drvdata =3D cc_alg->drvdata;
> =20
> +	if (ctx_p->cipher_mode =3D=3D DRV_CIPHER_ESSIV) {
> +		/* Alloc hash tfm for essiv */
> +		ctx_p->shash_tfm =3D crypto_alloc_shash("sha256-generic", 0, 0);
> +		if (IS_ERR(ctx_p->shash_tfm)) {
> +			dev_err(dev, "Error allocating hash tfm for ESSIV.\n");
> +			return PTR_ERR(ctx_p->shash_tfm);
> +		}
> +	}

shash_tfm() is only allocated conditionally.

> +free_key:
> +	kfree(ctx_p->user.key);
> +free_shash:
> +	crypto_free_shash(ctx_p->shash_tfm);

But it is freed unconditionally, and free_shash() is not robust
against NULL pointer due to undefined behaviour in crypto_shash_tfm.

Additionally, it would be cleaner to set ctx_p->shash_tfm to NULL in
this path.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl87ndcACgkQMOfwapXb+vJqAgCeJ4kPDDTti77BdUluNZl/BNi4
iugAn0Lm5kyR9qunG2p49VLBxbJaxd/0
=9bnH
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
