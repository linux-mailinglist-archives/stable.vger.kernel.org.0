Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24BB62B879A
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 23:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgKRWRw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 17:17:52 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:35390 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgKRWRw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Nov 2020 17:17:52 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 85C271C0B87; Wed, 18 Nov 2020 23:17:49 +0100 (CET)
Date:   Wed, 18 Nov 2020 23:17:49 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Brian Bunker <brian@purestorage.com>,
        Jitendra Khasdev <jitendra.khasdev@oracle.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 042/101] scsi: scsi_dh_alua: Avoid crash during
 alua_bus_detach()
Message-ID: <20201118221748.GC23840@amd>
References: <20201117122113.128215851@linuxfoundation.org>
 <20201117122115.140763276@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="w7PDEPdKQumQfZlR"
Content-Disposition: inline
In-Reply-To: <20201117122115.140763276@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--w7PDEPdKQumQfZlR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Hannes Reinecke <hare@suse.de>
>=20
> [ Upstream commit 5faf50e9e9fdc2117c61ff7e20da49cd6a29e0ca ]
>=20
> alua_bus_detach() might be running concurrently with alua_rtpg_work(), so
> we might trip over h->sdev =3D=3D NULL and call BUG_ON().  The correct wa=
y of
> handling it is to not set h->sdev to NULL in alua_bus_detach(), and call
> rcu_synchronize() before the final delete to ensure that all concurrent
> threads have left the critical section.  Then we can get rid of the
> BUG_ON() and replace it with a simple if condition.

I don't get it.

In the new version, h->sdev will never be NULL, because it is never
set to NULL. It is will be valid up-to the point when h is freed...

synchronize_rcu() should prevent race with alua_rtpg(), but BUG_ON()s
should stay, to catch any bogosity... Or maybe the if (!h->sdev) tests
should be simply removed. But it does not make sense to silently
continue.

Best regards,
								Pavel

> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -672,8 +672,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct=
 alua_port_group *pg)
>  					rcu_read_lock();
>  					list_for_each_entry_rcu(h,
>  						&tmp_pg->dh_list, node) {
> -						/* h->sdev should always be valid */
> -						BUG_ON(!h->sdev);
> +						if (!h->sdev)
> +							continue;
>  						h->sdev->access_state =3D desc[0];
>  					}
>  					rcu_read_unlock();
> @@ -719,7 +719,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct=
 alua_port_group *pg)
>  			pg->expiry =3D 0;
>  			rcu_read_lock();
>  			list_for_each_entry_rcu(h, &pg->dh_list, node) {
> -				BUG_ON(!h->sdev);
> +				if (!h->sdev)
> +					continue;
>  				h->sdev->access_state =3D
>  					(pg->state & SCSI_ACCESS_STATE_MASK);
>  				if (pg->pref)
> @@ -1160,7 +1161,6 @@ static void alua_bus_detach(struct scsi_device *sde=
v)
>  	spin_lock(&h->pg_lock);
>  	pg =3D rcu_dereference_protected(h->pg, lockdep_is_held(&h->pg_lock));
>  	rcu_assign_pointer(h->pg, NULL);
> -	h->sdev =3D NULL;
>  	spin_unlock(&h->pg_lock);
>  	if (pg) {
>  		spin_lock_irq(&pg->lock);
> @@ -1169,6 +1169,7 @@ static void alua_bus_detach(struct scsi_device *sde=
v)
>  		kref_put(&pg->kref, release_port_group);
>  	}
>  	sdev->handler_data =3D NULL;
> +	synchronize_rcu();
>  	kfree(h);
>  }
> =20

--
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--w7PDEPdKQumQfZlR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl+1nYwACgkQMOfwapXb+vK+hwCgtdGjUC5SDTskKGawaebLbk4A
rbIAoMASXeepTdLkbGDwRW/3R1yeS5L7
=kj7v
-----END PGP SIGNATURE-----

--w7PDEPdKQumQfZlR--
