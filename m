Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E53501496B7
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 17:53:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726194AbgAYQw6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 11:52:58 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:36466 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbgAYQw6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jan 2020 11:52:58 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 792101C25DE; Sat, 25 Jan 2020 17:52:56 +0100 (CET)
Date:   Sat, 25 Jan 2020 17:52:55 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Steve Sistare <steven.sistare@oracle.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 255/639] scsi: megaraid_sas: reduce module load time
Message-ID: <20200125165255.GE14064@duo.ucw.cz>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093118.649741900@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="brEuL7wsLY8+TuWz"
Content-Disposition: inline
In-Reply-To: <20200124093118.649741900@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--brEuL7wsLY8+TuWz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 31b6a05f86e690e1818116fd23c3be915cc9d9ed ]
>=20
> megaraid_sas takes 1+ seconds to load while waiting for firmware:
>=20
> [2.822603] megaraid_sas 0000:03:00.0: Waiting for FW to come to ready sta=
te
> [3.871003] megaraid_sas 0000:03:00.0: FW now in Ready state
>=20
> This is due to the following loop in megasas_transition_to_ready(), which
> waits a minimum of 1 second, even though the FW becomes ready in tens of
> millisecs:
>=20
>         /*
>          * The cur_state should not last for more than max_wait secs
>          */
>         for (i =3D 0; i < max_wait; i++) {
>                 ...
>                 msleep(1000);
>         ...
>         dev_info(&instance->pdev->dev, "FW now in Ready state\n");
>=20
> This is a regression, caused by a change of the msleep granularity from 1
> to 1000 due to concern about waiting too long on systems with coarse
> jiffies.
>=20
> To fix, increase iterations and use msleep(20), which results in:
>=20
> [2.670627] megaraid_sas 0000:03:00.0: Waiting for FW to come to ready sta=
te
> [2.739386] megaraid_sas 0000:03:00.0: FW now in Ready state
>=20
> Fixes: fb2f3e96d80f ("scsi: megaraid_sas: Fix msleep granularity")


That commit does not exist, it seems this fixes:

commit 9155cf30a3c4ef97e225d6daddf9bd4b173267e8
    scsi: megaraid_sas: Fix msleep granularity

Best regards,
									Pavel
								=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--brEuL7wsLY8+TuWz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXixyZwAKCRAw5/Bqldv6
8uwyAJ95Arp4kjR/80ctKT6yKQsV9JoKZQCeMF+svEnMrBHXsUskWFYN+CnWKPY=
=Dylx
-----END PGP SIGNATURE-----

--brEuL7wsLY8+TuWz--
