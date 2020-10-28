Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A762B29D7C9
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733139AbgJ1W0z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:26:55 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:55674 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733126AbgJ1W0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:26:55 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id DB79D1C0BA7; Wed, 28 Oct 2020 08:10:57 +0100 (CET)
Date:   Wed, 28 Oct 2020 08:10:57 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 228/264] PM: hibernate: remove the bogus call to
 get_gendisk() in software_resume()
Message-ID: <20201028071057.GC8084@amd>
References: <20201027135430.632029009@linuxfoundation.org>
 <20201027135441.360964081@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Clx92ZfkiYIKRjnr"
Content-Disposition: inline
In-Reply-To: <20201027135441.360964081@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Clx92ZfkiYIKRjnr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2020-10-27 14:54:46, Greg Kroah-Hartman wrote:
> From: Christoph Hellwig <hch@lst.de>
>=20
> [ Upstream commit 428805c0c5e76ef643b1fbc893edfb636b3d8aef ]
>=20
> get_gendisk grabs a reference on the disk and file operation, so this
> code will leak both of them while having absolutely no use for the
> gendisk itself.
>=20
> This effectively reverts commit 2df83fa4bce421f ("PM / Hibernate: Use
> get_gendisk to verify partition if resume_file is integer format")

This does not fix anything in 4.19, and should not be there.

It will break resume for people using resumewait option and using
numeric values, as original changelog explains. Eventually, someone
will cry regression and we'll have to fix it in the mainline, but no
need to bring this to -stable, too.

								Pavel
> +++ b/kernel/power/hibernate.c
> @@ -842,17 +842,6 @@ static int software_resume(void)
> =20
>  	/* Check if the device is there */
>  	swsusp_resume_device =3D name_to_dev_t(resume_file);
> -
> -	/*
> -	 * name_to_dev_t is ineffective to verify parition if resume_file is in
> -	 * integer format. (e.g. major:minor)
> -	 */
> -	if (isdigit(resume_file[0]) && resume_wait) {
> -		int partno;
> -		while (!get_gendisk(swsusp_resume_device, &partno))
> -			msleep(10);
> -	}
> -
>  	if (!swsusp_resume_device) {
>  		/*
>  		 * Some device discovery might still be in progress; we need

--=20
http://www.livejournal.com/~pavelmachek

--Clx92ZfkiYIKRjnr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+ZGYEACgkQMOfwapXb+vKgcgCglC6VPB3QxXCD4LK7LE68kqWA
nuwAnRhTCK3UnXaj6YT7IlIuFpC/bOmb
=XBYh
-----END PGP SIGNATURE-----

--Clx92ZfkiYIKRjnr--
