Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 101AC2520E2
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 21:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgHYTqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 15:46:24 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47524 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYTqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 15:46:23 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7BCE71C0BB9; Tue, 25 Aug 2020 21:46:21 +0200 (CEST)
Date:   Tue, 25 Aug 2020 21:46:21 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        JiangYu <lnsyyj@hotmail.com>,
        Daniel Meyerholt <dxm523@gmail.com>,
        Mike Christie <michael.christie@oracle.com>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 22/71] scsi: target: tcmu: Fix crash in
 tcmu_flush_dcache_range on ARM
Message-ID: <20200825194621.GA27453@duo.ucw.cz>
References: <20200824082355.848475917@linuxfoundation.org>
 <20200824082356.994960635@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <20200824082356.994960635@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>=20
> [ Upstream commit 3145550a7f8b08356c8ff29feaa6c56aca12901d ]
>=20
> This patch fixes the following crash (see
> https://bugzilla.kernel.org/show_bug.cgi?id=3D208045)
>=20
>  Process iscsi_trx (pid: 7496, stack limit =3D 0x0000000010dd111a)
>  CPU: 0 PID: 7496 Comm: iscsi_trx Not tainted 4.19.118-0419118-generic
>         #202004230533
>  Hardware name: Greatwall QingTian DF720/F601, BIOS 601FBE20 Sep 26 2019
>  pstate: 80400005 (Nzcv daif +PAN -UAO)
=2E..
> The solution is based on patch:
>=20
>   "scsi: target: tcmu: Optimize use of flush_dcache_page"
>=20
> which restricts the use of tcmu_flush_dcache_range() to addresses from
> vmalloc'ed areas only.

Yeah, but the patch mentioned is not queued for 4.19, so we should not
be simply applying this to 4.19. Does it need to be cherry-picked,
too?

commit 3c58f737231e2c8cbf543a09d84d8c8e80e05e43
Author: Bodo Stroesser <bstroesser@ts.fujitsu.com>

    scsi: target: tcmu: Optimize use of flush_dcache_page
   =20
    (scatter|gather)_data_area() need to flush dcache after writing data to=
 or

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX0VqjQAKCRAw5/Bqldv6
8vu/AJ9YX4Il9EcjOVNDspPm4O+tbFt5CgCgjktotSacjmX7kU0hdJ1wf/l4LM8=
=+yPH
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
