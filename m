Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 581E92A460B
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 14:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgKCNPE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 08:15:04 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:39658 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729005AbgKCNPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Nov 2020 08:15:04 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D938D1C0B77; Tue,  3 Nov 2020 14:15:01 +0100 (CET)
Date:   Tue, 3 Nov 2020 14:15:01 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Juergen Gross <jgross@suse.com>, marmarek@invisiblethingslab.com,
        luke1337@theori.io, sstabellini@kernel.org, wl@xen.org,
        Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 02/13] xen/events: avoid removing an event channel while
 handling it
Message-ID: <20201103131501.GA30723@duo.ucw.cz>
References: <20201103084150.8625-1-jgross@suse.com>
 <20201103084150.8625-3-jgross@suse.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="0F1p//8PRICkK4MW"
Content-Disposition: inline
In-Reply-To: <20201103084150.8625-3-jgross@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--0F1p//8PRICkK4MW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Today it can happen that an event channel is being removed from the
> system while the event handling loop is active. This can lead to a
> race resulting in crashes or WARN() splats when trying to access the
> irq_info structure related to the event channel.
>=20
> Fix this problem by using a rwlock taken as reader in the event
> handling loop and as writer when deallocating the irq_info structure.
>=20
> As the observed problem was a NULL dereference in evtchn_from_irq()
> make this function more robust against races by testing the irq_info
> pointer to be not NULL before dereferencing it.
>=20
> And finally make all accesses to evtchn_to_irq[row][col] atomic ones
> in order to avoid seeing partial updates of an array element in irq
> handling. Note that irq handling can be entered only for event channels
> which have been valid before, so any not populated row isn't a problem
> in this regard, as rows are only ever added and never removed.
>=20
> This is XSA-331.
>=20
> This is upstream commit 073d0552ead5bfc7a3a9c01de590e924f11b5dd2

This one is mismerged.


> @@ -1242,6 +1269,8 @@ static void __xen_evtchn_do_upcall(void)
>  	int cpu =3D get_cpu();
>  	unsigned count;
> =20
> +	read_lock(&evtchn_rwlock);
> +
>  	do {
>  		vcpu_info->evtchn_upcall_pending =3D 0;
> =20
> @@ -1256,6 +1285,8 @@ static void __xen_evtchn_do_upcall(void)
>  		__this_cpu_write(xed_nesting_count, 0);
>  	} while (count !=3D 1 || vcpu_info->evtchn_upcall_pending);
> =20
> +	read_unlock(&evtchn_rwlock);
> +
>  out:

read_unlock needs to be after the out: label. Or better yet, goto can
be avoided.

Best regards,
								Pavel
Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/xen/events/events_base.c b/drivers/xen/events/events_b=
ase.c
index cef70f4b52ef..ba36bdd49d22 100644
--- a/drivers/xen/events/events_base.c
+++ b/drivers/xen/events/events_base.c
@@ -1556,8 +1556,8 @@ static void __xen_evtchn_do_upcall(void)
 	do {
 		vcpu_info->evtchn_upcall_pending =3D 0;
=20
-		if (__this_cpu_inc_return(xed_nesting_count) - 1)
-			goto out;
+		if (__this_cpu_inc_return(xed_nesting_count) !=3D 1)
+			break;
=20
 		xen_evtchn_handle_events(cpu, &ctrl);
=20
@@ -1568,8 +1568,6 @@ static void __xen_evtchn_do_upcall(void)
 	} while (count !=3D 1 || vcpu_info->evtchn_upcall_pending);
=20
 	read_unlock(&evtchn_rwlock);
-
-out:
 	/*
 	 * Increment irq_epoch only now to defer EOIs only for
 	 * xen_irq_lateeoi() invocations occurring from inside the loop


--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--0F1p//8PRICkK4MW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX6FX1QAKCRAw5/Bqldv6
8rB8AKDDHUVyjSbZagN6iNixOh1bIs/SagCgtKJthlbalWdzjUyOAF/ihUzqE14=
=ABHU
-----END PGP SIGNATURE-----

--0F1p//8PRICkK4MW--
