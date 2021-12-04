Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5C44684C3
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 13:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236691AbhLDM1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 07:27:10 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:59798 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbhLDM1K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 07:27:10 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D73541C0BA4; Sat,  4 Dec 2021 13:23:43 +0100 (CET)
Date:   Sat, 4 Dec 2021 13:23:42 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Guenter Roeck <linux@roeck-us.net>,
        Anton Altaparmakov <anton@tuxera.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-ntfs-dev@lists.sourceforge.net
Subject: Re: [PATCH AUTOSEL 4.4 9/9] fs: ntfs: Limit NTFS_RW to page sizes
 smaller than 64k
Message-ID: <20211204122342.GB15934@duo.ucw.cz>
References: <20211130145402.947049-1-sashal@kernel.org>
 <20211130145402.947049-9-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Content-Disposition: inline
In-Reply-To: <20211130145402.947049-9-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 4eec7faf6775263d9e450ae7ee5bc4101d4a0bc9 ]
>=20
> NTFS_RW code allocates page size dependent arrays on the stack. This
> results in build failures if the page size is 64k or larger.
>=20
>   fs/ntfs/aops.c: In function 'ntfs_write_mst_block':
>   fs/ntfs/aops.c:1311:1: error:
> 	the frame size of 2240 bytes is larger than 2048 bytes
>=20
> Since commit f22969a66041 ("powerpc/64s: Default to 64K pages for 64 bit
> book3s") this affects ppc:allmodconfig builds, but other architectures
> supporting page sizes of 64k or larger are also affected.

NAK, this will disable NTFS_RW support in 4.4 entirely.

> +++ b/fs/ntfs/Kconfig
> @@ -51,6 +51,7 @@ config NTFS_DEBUG
>  config NTFS_RW
>  	bool "NTFS write support"
>  	depends on NTFS_FS
> +	depends on PAGE_SIZE_LESS_THAN_64KB
>  	help
>  	  This enables the partial, but safe, write support in the NTFS driver.
> =20

AFAICT CONFIG_PAGE_SIZE_LESS_THAN_64KB is not present in 4.4 (and
probably other) -stable kernels, nor it is queued to be added there.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYatdzgAKCRAw5/Bqldv6
8u0ZAJ4pY50kOKbOi8W8JLzZ2EpJR7kD5QCcCnnonpNpUUFQklXrQYadva0TRK0=
=pEaq
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
