Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 108B4561ABA
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 14:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234766AbiF3MtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 08:49:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233832AbiF3MtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 08:49:15 -0400
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97953FDAD
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 05:49:14 -0700 (PDT)
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1o6tbT-0001RQ-EK; Thu, 30 Jun 2022 14:49:03 +0200
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1o6tbR-003M4l-LM;
        Thu, 30 Jun 2022 14:49:01 +0200
Message-ID: <01d6cfab3d8e466718cb254279bcae90d3390235.camel@decadent.org.uk>
Subject: Re: [PATCH stable 4.19] swiotlb: skip swiotlb_bounce when orig_addr
 is zero
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Liu Shixin <liushixin2@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Thu, 30 Jun 2022 14:48:56 +0200
In-Reply-To: <20220630113331.1544886-1-liushixin2@huawei.com>
References: <20220630113331.1544886-1-liushixin2@huawei.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-yepyHi/rra1L4p3Rn+ML"
User-Agent: Evolution 3.44.1-2 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-yepyHi/rra1L4p3Rn+ML
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2022-06-30 at 19:33 +0800, Liu Shixin wrote:
> After patch ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE"),
> swiotlb_bounce will be called in swiotlb_tbl_map_single unconditionally.
> This requires that the physical address must be valid, which is not alway=
s
> true on stable-4.19 or earlier version.
> On stable-4.19, swiotlb_alloc_buffer will call swiotlb_tbl_map_single wit=
h
> orig_addr equal to zero, which cause such a panic:
>=20
> Unable to handle kernel paging request at virtual address ffffb77a4000000=
0
> ...
> pc : __memcpy+0x100/0x180
> lr : swiotlb_bounce+0x74/0x88
> ...
> Call trace:
>  __memcpy+0x100/0x180
>  swiotlb_tbl_map_single+0x2c8/0x338
>  swiotlb_alloc+0xb4/0x198
>  __dma_alloc+0x84/0x1d8
>  ...
>=20
> On stable-4.9 and stable-4.14, swiotlb_alloc_coherent wille call map_sing=
le
> with orig_addr equal to zero, which can cause same panic.
>=20
> Fix this by skipping swiotlb_bounce when orig_addr is zero.

Thanks for fixing this.  I tried to test the backports by forcing use
of swiotlb, but apparently it still didn't get used.

Ben.

> Fixes: ddbd89deb7d3 ("swiotlb: fix info leak with DMA_FROM_DEVICE")
> Signed-off-by: Liu Shixin <liushixin2@huawei.com>
> ---
>  kernel/dma/swiotlb.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/kernel/dma/swiotlb.c b/kernel/dma/swiotlb.c
> index 8b1360772fc5..b1e2ce2f9c2d 100644
> --- a/kernel/dma/swiotlb.c
> +++ b/kernel/dma/swiotlb.c
> @@ -594,7 +594,8 @@ phys_addr_t swiotlb_tbl_map_single(struct device *hwd=
ev,
>  	 * unconditional bounce may prevent leaking swiotlb content (i.e.
>  	 * kernel memory) to user-space.
>  	 */
> -	swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
> +	if (orig_addr)
> +		swiotlb_bounce(orig_addr, tlb_addr, size, DMA_TO_DEVICE);
>  	return tlb_addr;
>  }
> =20

--=20
Ben Hutchings
Nothing is ever a complete failure;
it can always serve as a bad example.

--=-yepyHi/rra1L4p3Rn+ML
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIyBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmK9m7kACgkQ57/I7JWG
EQmAzg/4778VL7ohyyfG2tX3pG5qxojr5oph3JeBdR1qkBQ40kvSS4KXd3yk8d4t
9CfsXko1TQie1bp01KsEJtcpbuo6V2Hsz7T+eb3z15C4FB1RZ5j7W45Sd4Tu8NkB
aCxzxgUJYoSXodZsKXQU/cA3hXEDv0ypE+JQvMHFJ+8CqSKD6IXaPaxZg65RtlQz
btmh3U3NeQ4Kn7d7LYsxU0JaF1qNVESqbRnO92SXqfStZDt3aL8loO+rOJiEwpdp
Wp0zWNyPyo9AosmrIKo9a4kJbj9k30ND8aPCoO6H5NpMVO6/kYO4sCHuQcYUKyUa
lXuoJG0RQnOuWOVm9OqfeVIa9G8MfZ0JH8YCLJ8/w/jxGcPweRC9h2YrwzR/9cNQ
wqWH9sscwtBUTEaY73+URipEeQz32R/qSXmZksmSPGzdsB7A3ruErBoD7VK5LkNX
INOgIYDRMR9RnEVsEULeb5b6xaxex+LZSnS78D503bV9pHafw4zxjVgLYhPhN7ZG
pOnS3QBoOfX35taT1p9UwLl+NvJmtSP5BGnx8Py24SZlYLQWSFlaT0BjteFJcFXR
FsnaT990164jM7Mw9uqj5PUkNZvmgVdw8z65ZkjsWt/0h2+MOXUU7cmh8s13PHzE
IVMkayp7kk1VuXeIHgwcrRUEq1Ek/Qlwya1tYCbqQEuwh+Nl/Q==
=lErt
-----END PGP SIGNATURE-----

--=-yepyHi/rra1L4p3Rn+ML--
