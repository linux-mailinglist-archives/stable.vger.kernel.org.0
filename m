Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 595443C8D3E
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 21:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236812AbhGNToQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:44:16 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:44424 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235431AbhGNTnY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Jul 2021 15:43:24 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 9871B1C0B98; Wed, 14 Jul 2021 21:40:29 +0200 (CEST)
Date:   Wed, 14 Jul 2021 21:40:28 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thara Gopinath <thara.gopinath@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 129/593] crypto: qce: skcipher: Fix incorrect sg
 count for dma transfers
Message-ID: <20210714194028.GA15200@amd>
References: <20210712060843.180606720@linuxfoundation.org>
 <20210712060857.335221127@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <20210712060857.335221127@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 1339a7c3ba05137a2d2fe75f602311bbfc6fab33 ]
>=20
> Use the sg count returned by dma_map_sg to call into
> dmaengine_prep_slave_sg rather than using the original sg count. dma_map_=
sg
> can merge consecutive sglist entries, thus making the original sg count
> wrong. This is a fix for memory coruption issues observed while testing
> encryption/decryption of large messages using libkcapi framework.
>=20
> Patch has been tested further by running full suite of tcrypt.ko tests
> including fuzz tests.

This still needs more work AFAICT.

> index a2d3da0ad95f..5a6559131eac 100644
> --- a/drivers/crypto/qce/skcipher.c
> +++ b/drivers/crypto/qce/skcipher.c
> @@ -122,21 +122,22 @@ qce_skcipher_async_req_handle(struct crypto_async_r=
equest *async_req)
>  	sg_mark_end(sg);
>  	rctx->dst_sg =3D rctx->dst_tbl.sgl;

ret is =3D=3D 0 at this point.

> -	ret =3D dma_map_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_dst);
> -	if (ret < 0)
> +	dst_nents =3D dma_map_sg(qce->dev, rctx->dst_sg, rctx->dst_nents, dir_d=
st);
> +	if (dst_nents < 0)
>  		goto error_free;

And we go to the error path, and return ret... instead of returning failure.

>  	if (diff_dst) {
> -		ret =3D dma_map_sg(qce->dev, req->src, rctx->src_nents, dir_src);
> -		if (ret < 0)
> +		src_nents =3D dma_map_sg(qce->dev, req->src, rctx->src_nents, dir_src);
> +		if (src_nents < 0)
>  			goto error_unmap_dst;
>  		rctx->src_sg =3D req->src;

Same problem happens here.

The problem is already fixed in the mainline; I believe we want that
in 5.10-stable at least.

commit a8bc4f5e7a72e4067f5afd7e98b61624231713ca
Author: Wei Yongjun <weiyongjun1@huawei.com>
Date:   Wed Jun 2 11:36:45 2021 +0000

    crypto: qce - fix error return code in qce_skcipher_async_req_handle()

    Fix to return a negative error code from the error handling
        case instead of 0, as done elsewhere in this function.

    Fixes: 1339a7c3ba05 ("crypto: qce: skcipher: Fix incorrect sg
    count for dma transfers")
        Reported-by: Hulk Robot <hulkci@huawei.com>
	    Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
	   =20

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDvPawACgkQMOfwapXb+vJgCgCgs86Ch90+Sx6C+nZfUprneMWn
60kAoLFLd57INRSDiSOmjrqyGLrF4RxM
=PjM2
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
