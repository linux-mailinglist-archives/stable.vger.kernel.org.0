Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBF6E2EBE00
	for <lists+stable@lfdr.de>; Wed,  6 Jan 2021 13:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726807AbhAFMzd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 07:55:33 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:43598 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726303AbhAFMzc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 07:55:32 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DED801C0B9B; Wed,  6 Jan 2021 13:54:49 +0100 (CET)
Date:   Wed, 6 Jan 2021 13:54:49 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Naohiro Aota <naohiro.aota@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 4.19 13/35] null_blk: Fix zone size initialization
Message-ID: <20210106125449.GA7589@duo.ucw.cz>
References: <20210104155703.375788488@linuxfoundation.org>
 <20210104155704.049016882@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <20210104155704.049016882@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 0ebcdd702f49aeb0ad2e2d894f8c124a0acc6e23 upstream.
>=20
> For a null_blk device with zoned mode enabled is currently initialized
> with a number of zones equal to the device capacity divided by the zone
> size, without considering if the device capacity is a multiple of the
> zone size. If the zone size is not a divisor of the capacity, the zones
> end up not covering the entire capacity, potentially resulting is out
> of bounds accesses to the zone array.
>=20
> Fix this by adding one last smaller zone with a size equal to the
> remainder of the disk capacity divided by the zone size if the capacity
> is not a multiple of the zone size. For such smaller last zone, the zone
> capacity is also checked so that it does not exceed the smaller zone
> size.

> --- a/drivers/block/null_blk_zoned.c
> +++ b/drivers/block/null_blk_zoned.c
> @@ -1,9 +1,9 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <linux/vmalloc.h>
> +#include <linux/sizes.h>
>  #include "null_blk.h"
> =20
> -/* zone_size in MBs to sectors. */
> -#define ZONE_SIZE_SHIFT		11
> +#define MB_TO_SECTS(mb) (((sector_t)mb * SZ_1M) >> SECTOR_SHIFT)

This macro is quite dangerous. (mb) would help, but inline function
would be better.


> +	dev->nr_zones =3D dev_capacity_sects >> ilog2(dev->zone_size_sects);
> +	if (dev_capacity_sects & (dev->zone_size_sects - 1))
> +		dev->nr_zones++;

Is this same as nr_zones =3D DIV_ROUND_UP(dev_capacity_sects,
dev->zone_size_sects)? Would that be faster, more readable and robust
against weird dev->zone_size_sects sizes?

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX/WzGQAKCRAw5/Bqldv6
8lqUAKC4lnEVavZsVvuVOURrv5t1AOeYXACaArcggbTBIyOc+PTZkdqWBpNO+O0=
=UkhQ
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
