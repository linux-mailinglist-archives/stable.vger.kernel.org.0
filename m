Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38442149C1D
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 18:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725944AbgAZRg4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 12:36:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52376 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725838AbgAZRg4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 12:36:56 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ivlq9-0000Xg-Vj; Sun, 26 Jan 2020 17:36:54 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1ivlq9-0015q1-Ig; Sun, 26 Jan 2020 17:36:53 +0000
Message-ID: <d344f152a9627944a3e8e4dccd8fc9e5c6ef8a40.camel@decadent.org.uk>
Subject: Re: [PATCH v4.4] net: davinci_cpdma: use dma_addr_t for DMA address
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Daniel Wagner <dwagner@suse.de>, stable@vger.kernel.org
Cc:     Pavel Machek <pavel@denx.de>, Arnd Bergmann <arnd@arndb.de>,
        "David S . Miller" <davem@davemloft.net>
Date:   Sun, 26 Jan 2020 17:36:48 +0000
In-Reply-To: <20191221104948.10233-1-dwagner@suse.de>
References: <20191221104948.10233-1-dwagner@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-oLrKoZR6T1ctKK58NWW7"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-oLrKoZR6T1ctKK58NWW7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2019-12-21 at 11:49 +0100, Daniel Wagner wrote:
> From: Arnd Bergmann <arnd@arndb.de>
>=20
> [ Upstream commit 84092996673211f16ef3b942a191d7952e9dfea9 ]
[...]
> Pavel reported this fix is needed for the CIP kernel.
>=20
> Since this patch was added to v4.5, we only need to backport
> to v4.4.

It looks like it's also applicable to 3.16, so I've queued it up for
that.

Ben.

> Thanks,
> Daniel
>=20
>  drivers/net/ethernet/ti/davinci_cpdma.c | 12 ++++++------
>  1 file changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/ti/davinci_cpdma.c b/drivers/net/ethern=
et/ti/davinci_cpdma.c
> index 657b65bf5cac..18bf3a8fdc50 100644
> --- a/drivers/net/ethernet/ti/davinci_cpdma.c
> +++ b/drivers/net/ethernet/ti/davinci_cpdma.c
> @@ -82,7 +82,7 @@ struct cpdma_desc {
> =20
>  struct cpdma_desc_pool {
>  	phys_addr_t		phys;
> -	u32			hw_addr;
> +	dma_addr_t		hw_addr;
>  	void __iomem		*iomap;		/* ioremap map */
>  	void			*cpumap;	/* dma_alloc map */
>  	int			desc_size, mem_size;
> @@ -152,7 +152,7 @@ struct cpdma_chan {
>   * abstract out these details
>   */
>  static struct cpdma_desc_pool *
> -cpdma_desc_pool_create(struct device *dev, u32 phys, u32 hw_addr,
> +cpdma_desc_pool_create(struct device *dev, u32 phys, dma_addr_t hw_addr,
>  				int size, int align)
>  {
>  	int bitmap_size;
> @@ -176,13 +176,13 @@ cpdma_desc_pool_create(struct device *dev, u32 phys=
, u32 hw_addr,
> =20
>  	if (phys) {
>  		pool->phys  =3D phys;
> -		pool->iomap =3D ioremap(phys, size);
> +		pool->iomap =3D ioremap(phys, size); /* should be memremap? */
>  		pool->hw_addr =3D hw_addr;
>  	} else {
> -		pool->cpumap =3D dma_alloc_coherent(dev, size, &pool->phys,
> +		pool->cpumap =3D dma_alloc_coherent(dev, size, &pool->hw_addr,
>  						  GFP_KERNEL);
> -		pool->iomap =3D pool->cpumap;
> -		pool->hw_addr =3D pool->phys;
> +		pool->iomap =3D (void __iomem __force *)pool->cpumap;
> +		pool->phys =3D pool->hw_addr; /* assumes no IOMMU, don't use this valu=
e */
>  	}
> =20
>  	if (pool->iomap)
--=20
Ben Hutchings
The program is absolutely right; therefore, the computer must be wrong.



--=-oLrKoZR6T1ctKK58NWW7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl4tzjAACgkQ57/I7JWG
EQkE/xAAtHS5fhHvjezT8ZaPg1XkF4DOuXz66wI1wuupbaHelWd/d+gFSId7pkYx
ExOqiwts1PplQeVuPlHewQ9/VXxnqx8cTmQgPr3Rl3gWuWd9EdLXbC9EHB9VWvJ4
nDSGwDYrjODJ7J+2PLB66l7HKQ+mmKnuxzVXViTCytbhUB57R4cbg80ASbPHuQKS
1jYVzieuCUsKHEkm5lMFc1ybjwubM+X0d5nllCojB8vEtq9JgAJvl/N7QL1KMNYC
oDTH3Poj2pUhN9hlmbR87W23jNKoipNzCnvs9xnXPH4lZQfqvxoIyMewvWvmiA5r
LeLVy/qQCW8+t9mHNUx0fweDN9rCV76r7eUHUN97ri/UfV3YUyrRvLLwpgp/l4e2
skiuvRwVa8R3v5GV1ekCIrzQJrckmYh0O3aJLjLcODN0IaOWfqHneqK+pb5pn8SR
1LyJG1KZvfQ3MD9eaR0MuOKnUibiLLerEP4I3mx9MQiJrRnPuC3GwI8qKrQovG5b
mWZiy42j8GBICstcAvpfWWer7yUAAntvXXaHWi91sCZcMpDiwMRO338YDRoTSRi+
0YNGoumP0B+lONh/vcug5MUhxPkDnrDT38NULjqSqvBbzjMKTGbBDYNGKgv5N62X
obBVC2MkEdWwTFJsqa8nCAyxHh+XYnnW6Ow+TcercpbRr/JdOE4=
=Kqjp
-----END PGP SIGNATURE-----

--=-oLrKoZR6T1ctKK58NWW7--
