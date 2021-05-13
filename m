Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8BCF37F3CB
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 09:59:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231771AbhEMIBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 04:01:03 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50530 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbhEMIA4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 04:00:56 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B12641C0B80; Thu, 13 May 2021 09:59:41 +0200 (CEST)
Date:   Thu, 13 May 2021 09:59:41 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 050/530] md: md_open returns -EBUSY when entering
 racing area
Message-ID: <20210513075940.GA22156@amd>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144821.386618889@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <20210512144821.386618889@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 6a4db2a60306eb65bfb14ccc9fde035b74a4b4e7 upstream.
>=20
> commit d3374825ce57 ("md: make devices disappear when they are no longer
> needed.") introduced protection between mddev creating & removing. The
> md_open shouldn't create mddev when all_mddevs list doesn't contain
> mddev. With currently code logic, there will be very easy to trigger
> soft lockup in non-preempt env.
>=20
> This patch changes md_open returning from -ERESTARTSYS to -EBUSY, which
> will break the infinitely retry when md_open enter racing area.
>=20
> This patch is partly fix soft lockup issue, full fix needs mddev_find
> is split into two functions: mddev_find & mddev_find_or_alloc. And
> md_open should call new mddev_find (it only does searching job).
>=20
> For more detail, please refer with Christoph's "split mddev_find" patch
> in later commits.

Something went wrong here; changelog is truncated, in particular it
does not contain required sign-offs.

Best regards,
								Pavel

> +++ b/drivers/md/md.c
> @@ -7857,8 +7857,7 @@ static int md_open(struct block_device *
>  		/* Wait until bdev->bd_disk is definitely gone */
>  		if (work_pending(&mddev->del_work))
>  			flush_workqueue(md_misc_wq);
> -		/* Then retry the open from the top */
> -		return -ERESTARTSYS;
> +		return -EBUSY;
>  	}
>  	BUG_ON(mddev !=3D bdev->bd_disk->private_data);


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--82I3+IH0IqGh5yIs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmCc3GwACgkQMOfwapXb+vJetACfZSaV6mnf4lFZOAhR5tdTRm+4
6kQAoK+gyvSTIeuQp5YL6Q0FjRjZFlDz
=AZpd
-----END PGP SIGNATURE-----

--82I3+IH0IqGh5yIs--
