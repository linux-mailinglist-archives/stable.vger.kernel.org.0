Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533214811F5
	for <lists+stable@lfdr.de>; Wed, 29 Dec 2021 12:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239899AbhL2LV2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Dec 2021 06:21:28 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:40998 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235496AbhL2LV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Dec 2021 06:21:27 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 189EC1C0B77; Wed, 29 Dec 2021 12:21:21 +0100 (CET)
Date:   Wed, 29 Dec 2021 12:21:20 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 19/38] sfc: falcon: Check null pointer of
 rx_queue->page_ring
Message-ID: <20211229112120.GC25195@amd>
References: <20211227151319.379265346@linuxfoundation.org>
 <20211227151320.015328013@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="adJ1OR3c6QgCpb/j"
Content-Disposition: inline
In-Reply-To: <20211227151320.015328013@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--adJ1OR3c6QgCpb/j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Jiasheng Jiang <jiasheng@iscas.ac.cn>
>=20
> [ Upstream commit 9b8bdd1eb5890aeeab7391dddcf8bd51f7b07216 ]
>=20
> Because of the possible failure of the kcalloc, it should be better to
> set rx_queue->page_ptr_mask to 0 when it happens in order to maintain
> the consistency.

Again this is confusing/wrong, or at least not a complete fix...

> +++ b/drivers/net/ethernet/sfc/falcon/rx.c
> @@ -732,7 +732,10 @@ static void ef4_init_rx_recycle_ring(struct ef4_nic =
*efx,
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

=2E..as we have=20

        index =3D rx_queue->page_remove & rx_queue->page_ptr_mask;
	page =3D rx_queue->page_ring[index];
	=09
in ef4_reuse_page, and similar problems in other places, including

        for (i =3D 0; i <=3D rx_queue->page_ptr_mask; i++) {
                struct page *page =3D rx_queue->page_ring[i];

=2E Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--adJ1OR3c6QgCpb/j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmHMRLAACgkQMOfwapXb+vLv3QCfYltEQWKbxc7CwHXr45EY1fLr
YjMAn30ENwp/slmShgX3WCJfomkydaQf
=DUYu
-----END PGP SIGNATURE-----

--adJ1OR3c6QgCpb/j--
