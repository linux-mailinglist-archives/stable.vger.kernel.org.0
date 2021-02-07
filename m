Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEE031230E
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 10:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhBGJVB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 04:21:01 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:40420 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhBGJVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 04:21:00 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id A18411C0B77; Sun,  7 Feb 2021 10:20:16 +0100 (CET)
Date:   Sun, 7 Feb 2021 10:20:15 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Kevin Hao <haokexin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.10 04/57] net: octeontx2: Make sure the buffer is 128
 byte aligned
Message-ID: <20210207092015.GA32297@amd>
References: <20210205140655.982616732@linuxfoundation.org>
 <20210205140656.168305608@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="BOKacYhQ+x31HxR3"
Content-Disposition: inline
In-Reply-To: <20210205140656.168305608@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--BOKacYhQ+x31HxR3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit db2805150a0f27c00ad286a29109397a7723adad upstream.
>=20
> The octeontx2 hardware needs the buffer to be 128 byte aligned.
> But in the current implementation of napi_alloc_frag(), it can't
> guarantee the return address is 128 byte aligned even the request size
> is a multiple of 128 bytes, so we have to request an extra 128 bytes and
> use the PTR_ALIGN() to make sure that the buffer is aligned correctly.
>=20
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -473,10 +473,11 @@ dma_addr_t __otx2_alloc_rbuf(struct otx2
>  	dma_addr_t iova;
>  	u8 *buf;
> =20
> -	buf =3D napi_alloc_frag(pool->rbsize);
> +	buf =3D napi_alloc_frag(pool->rbsize + OTX2_ALIGN);
>  	if (unlikely(!buf))
>  		return -ENOMEM;
> =20
> +	buf =3D PTR_ALIGN(buf, OTX2_ALIGN);

So we allocate a buffer, then change it, and then pass modified
pointer to the page_frag_free(buf); in the error path. That... can't
be right, right?

>  	iova =3D dma_map_single_attrs(pfvf->dev, buf, pool->rbsize,
>  				    DMA_FROM_DEVICE, DMA_ATTR_SKIP_CPU_SYNC);
>  	if (unlikely(dma_mapping_error(pfvf->dev, iova))) {

BTW otx2_alloc_rbuf and __otx2_alloc_rbuf should probably return s64,
as they return negative error code...

Best regards,
							Pavel

--=20
http://www.livejournal.com/~pavelmachek

--BOKacYhQ+x31HxR3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAfsM8ACgkQMOfwapXb+vIl0QCgk69H52jrBg3QTdCu0tD/nL/q
SQoAn2S0Dij/cUdtTKroFagyHVfIUxfi
=9MqR
-----END PGP SIGNATURE-----

--BOKacYhQ+x31HxR3--
