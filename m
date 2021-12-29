Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818FF4811F0
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 12:17:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239879AbhL2LRj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 06:17:39 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:40520 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbhL2LRi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 06:17:38 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5FA3A1C0B9E; Wed, 29 Dec 2021 12:17:31 +0100 (CET)
Date:   Wed, 29 Dec 2021 12:17:30 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 26/76] sfc: Check null pointer of rx_queue->page_ring
Message-ID: <20211229111730.GB25195@amd>
References: <20211227151324.694661623@linuxfoundation.org>
 <20211227151325.595242432@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CdrF4e02JqNVZeln"
Content-Disposition: inline
In-Reply-To: <20211227151325.595242432@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CdrF4e02JqNVZeln
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

hi!

> From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>=20
> [ Upstream commit bdf1b5c3884f6a0dc91b0dbdb8c3b7d205f449e0 ]
>=20
> Because of the possible failure of the kcalloc, it should be better to
> set rx_queue->page_ptr_mask to 0 when it happens in order to maintain
> the consistency.

This is confusing/wrong, or at least not a complete fix.

> +++ b/drivers/net/ethernet/sfc/rx_common.c
> @@ -150,7 +150,10 @@ static void efx_init_rx_recycle_ring(struct efx_rx_q=
ueue *rx_queue)
>  					    efx->rx_bufs_per_page);
>  	rx_queue->page_ring =3D kcalloc(page_ring_size,
>  				      sizeof(*rx_queue->page_ring), GFP_KERNEL);
> -	rx_queue->page_ptr_mask =3D page_ring_size - 1;
> +	if (!rx_queue->page_ring)
> +		rx_queue->page_ptr_mask =3D 0;
> +	else
> +		rx_queue->page_ptr_mask =3D page_ring_size - 1;
>  }
> =20

So we have !rx_queue->page_ring. But in efx_reuse_page, we do

        index =3D rx_queue->page_remove & rx_queue->page_ptr_mask;
	page =3D rx_queue->page_ring[index];

So index is now zero, but we'll derefernce null pointer anyway.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--CdrF4e02JqNVZeln
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmHMQ8oACgkQMOfwapXb+vLLxgCePwbsG8eshowzPtNbLnn50H64
GRoAoMPF3krazvtwdgPuLYX1gXR/qQcl
=0zyK
-----END PGP SIGNATURE-----

--CdrF4e02JqNVZeln--
