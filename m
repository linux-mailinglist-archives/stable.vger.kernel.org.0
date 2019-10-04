Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3DA6CB7DA
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 12:05:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726333AbfJDKFT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 06:05:19 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54825 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfJDKFT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Oct 2019 06:05:19 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id 6A84080309; Fri,  4 Oct 2019 12:05:01 +0200 (CEST)
Date:   Fri, 4 Oct 2019 12:05:14 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Liguang Zhang <zhangliguang@linux.alibaba.com>,
        Borislav Petkov <bp@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.2 123/313] ACPI / APEI: Release resources if
 gen_pool_add() fails
Message-ID: <20191004100514.GA24970@amd>
References: <20191003154533.590915454@linuxfoundation.org>
 <20191003154545.050926099@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <20191003154545.050926099@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> @@ -172,7 +173,19 @@ int ghes_estatus_pool_init(int num_ghes)
>  	 */
>  	vmalloc_sync_all();
> =20
> -	return gen_pool_add(ghes_estatus_pool, addr, PAGE_ALIGN(len), -1);
> +	rc =3D gen_pool_add(ghes_estatus_pool, addr, PAGE_ALIGN(len), -1);
> +	if (rc)
> +		goto err_pool_add;
> +
> +	return 0;
> +
> +err_pool_add:
> +	vfree((void *)addr);
> +

AFAICT this cast should not be neccessary.

Best regards,
									Pavel

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2XGVoACgkQMOfwapXb+vITrQCeKWIYX7A0qg3mm2+giDF0YuAc
p74An0EhumHqGNowy1oF32N5XiGgmYSu
=svwu
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
