Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBC42FAD7D
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 23:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730808AbhARWpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 17:45:22 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:58442 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732309AbhARWpS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 17:45:18 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id AD67C1C0B87; Mon, 18 Jan 2021 23:44:32 +0100 (CET)
Date:   Mon, 18 Jan 2021 23:44:32 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Ignat Korchagin <ignat@cloudflare.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 5.10 045/152] dm crypt: use GFP_ATOMIC when allocating
 crypto requests from softirq
Message-ID: <20210118224431.GA26685@amd>
References: <20210118113352.764293297@linuxfoundation.org>
 <20210118113354.944646657@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <20210118113354.944646657@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> Fix this by allocating crypto requests with GFP_ATOMIC mask in
> interrupt context.
=2E..

This one is wrong.


> +++ b/drivers/md/dm-crypt.c
> @@ -1454,13 +1454,16 @@ static int crypt_convert_block_skcipher(
> -	if (!ctx->r.req)
> -		ctx->r.req =3D mempool_alloc(&cc->req_pool, GFP_NOIO);
> +	if (!ctx->r.req) {
> +		ctx->r.req =3D mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMI=
C : GFP_NOIO);

Good so far. Ugly but good.

> -static void crypt_alloc_req_aead(struct crypt_config *cc,
> +static int crypt_alloc_req_aead(struct crypt_config *cc,
>  				 struct convert_context *ctx)
>  {
> -	if (!ctx->r.req_aead)
> -		ctx->r.req_aead =3D mempool_alloc(&cc->req_pool, GFP_NOIO);
> +	if (!ctx->r.req) {
> +		ctx->r.req =3D mempool_alloc(&cc->req_pool, in_interrupt() ? GFP_ATOMI=
C : GFP_NOIO);
> +		if (!ctx->r.req)
> +			return -ENOMEM;
> +	}

But this one can't be good. We are now allocating different field in
the structure!

								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director:    Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194    Groebenzell, Germany
   =20

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAGD08ACgkQMOfwapXb+vLfFACbBQYPZfTknkxa850Wi3i5c+9O
eyoAoI1ujm1OsqDFVX3i46cIBRXveKpb
=eL/i
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
