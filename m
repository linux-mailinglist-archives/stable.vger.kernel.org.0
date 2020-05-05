Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D9E1C554A
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 14:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728627AbgEEMRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 08:17:54 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:41262 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728819AbgEEMRy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 08:17:54 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2D53C1C0225; Tue,  5 May 2020 14:17:53 +0200 (CEST)
Date:   Tue, 5 May 2020 14:17:52 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 4.19 21/37] vfio: avoid possible overflow in
 vfio_iommu_type1_pin_pages
Message-ID: <20200505121752.GB28722@amd>
References: <20200504165448.264746645@linuxfoundation.org>
 <20200504165450.604878640@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="CUfgB8w4ZwR/yMy5"
Content-Disposition: inline
In-Reply-To: <20200504165450.604878640@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--CUfgB8w4ZwR/yMy5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon 2020-05-04 19:57:34, Greg Kroah-Hartman wrote:
> From: Yan Zhao <yan.y.zhao@intel.com>
>=20
> commit 0ea971f8dcd6dee78a9a30ea70227cf305f11ff7 upstream.
>=20
> add parentheses to avoid possible vaddr overflow.

AFAICT the values are unsigned, so yes, this is nice cleanup, but it
does not really fix any problem, right? IOW it overflows, then
underflows, but the result is still correct...

Best regards,
								Pavel

> Fixes: a54eb55045ae ("vfio iommu type1: Add support for mediated devices")
> Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  drivers/vfio/vfio_iommu_type1.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/drivers/vfio/vfio_iommu_type1.c
> +++ b/drivers/vfio/vfio_iommu_type1.c
> @@ -598,7 +598,7 @@ static int vfio_iommu_type1_pin_pages(vo
>  			continue;
>  		}
> =20
> -		remote_vaddr =3D dma->vaddr + iova - dma->iova;
> +		remote_vaddr =3D dma->vaddr + (iova - dma->iova);
>  		ret =3D vfio_pin_page_external(dma, remote_vaddr, &phys_pfn[i],
>  					     do_accounting);
>  		if (ret)
>=20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--CUfgB8w4ZwR/yMy5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl6xWXAACgkQMOfwapXb+vK7bQCbBvZQDzcjZdosrXP+fk2XRmmv
dtoAoJtNLoHV7yoyx/gKlXEIwkLI2ehi
=LUUN
-----END PGP SIGNATURE-----

--CUfgB8w4ZwR/yMy5--
