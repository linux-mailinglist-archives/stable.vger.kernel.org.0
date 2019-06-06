Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A64137488
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 14:53:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbfFFMx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 08:53:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50137 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726822AbfFFMx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 08:53:26 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id E1AF980262; Thu,  6 Jun 2019 14:53:13 +0200 (CEST)
Date:   Thu, 6 Jun 2019 14:53:23 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        James Smart <james.smart@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 237/276] scsi: lpfc: avoid uninitialized variable
 warning
Message-ID: <20190606125323.GC27432@amd>
References: <20190530030523.133519668@linuxfoundation.org>
 <20190530030539.944220603@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="adJ1OR3c6QgCpb/j"
Content-Disposition: inline
In-Reply-To: <20190530030539.944220603@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--adJ1OR3c6QgCpb/j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit faf5a744f4f8d76e7c03912b5cd381ac8045f6ec ]
>=20
> clang -Wuninitialized incorrectly sees a variable being used without
> initialization:
>=20
> drivers/scsi/lpfc/lpfc_nvme.c:2102:37: error: variable 'localport' is uni=
nitialized when used here
>       [-Werror,-Wuninitialized]
>                 lport =3D (struct lpfc_nvme_lport *)localport->private;
>                                                   ^~~~~~~~~
> drivers/scsi/lpfc/lpfc_nvme.c:2059:38: note: initialize the variable 'loc=
alport' to silence this warning
>         struct nvme_fc_local_port *localport;
>                                             ^
>                                              =3D NULL
> 1 error generated.
>=20
> This is clearly in dead code, as the condition leading up to it is always
> false when CONFIG_NVME_FC is disabled, and the variable is always
> initialized when nvme_fc_register_localport() got called successfully.
>=20
> Change the preprocessor conditional to the equivalent C construct, which
> makes the code more readable and gets rid of the warning.

Unfortunately, this missed "else" branch where the code was freeing
the memory with kfree(cstat)... so this introduces a memory leak.

Best regards,
									Pavel

> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Acked-by: James Smart <james.smart@broadcom.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>


--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--adJ1OR3c6QgCpb/j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlz5DMMACgkQMOfwapXb+vL9mgCfWykgy5M4WHThY/CXqMxs9B8y
7BcAnikxGH2w2GgBe5Ox/uWDPPO4yA9q
=n/8A
-----END PGP SIGNATURE-----

--adJ1OR3c6QgCpb/j--
