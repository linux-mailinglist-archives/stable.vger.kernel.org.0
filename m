Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 374A82D0631
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 18:08:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727735AbgLFRHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 12:07:51 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:53964 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727706AbgLFRHv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 12:07:51 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id BCB441C0B77; Sun,  6 Dec 2020 18:07:08 +0100 (CET)
Date:   Sun, 6 Dec 2020 18:07:08 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Brian King <brking@linux.vnet.ibm.com>,
        Pradeep Satyanarayana <pradeeps@linux.vnet.ibm.com>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 4.19 11/32] ibmvnic: notify peers when failover and
 migration happen
Message-ID: <20201206170708.GA4901@duo.ucw.cz>
References: <20201206111555.787862631@linuxfoundation.org>
 <20201206111556.317195640@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="tThc/1wpZn/ma/RB"
Content-Disposition: inline
In-Reply-To: <20201206111556.317195640@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--tThc/1wpZn/ma/RB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Lijun Pan <ljp@linux.ibm.com>
>=20
> [ Upstream commit 98025bce3a6200a0c4637272a33b5913928ba5b8 ]
>=20
> Commit 61d3e1d9bc2a ("ibmvnic: Remove netdev notify for failover resets")
> excluded the failover case for notify call because it said
> netdev_notify_peers() can cause network traffic to stall or halt.
> Current testing does not show network traffic stall
> or halt because of the notify call for failover event.
> netdev_notify_peers may be used when a device wants to inform the
> rest of the network about some sort of a reconfiguration
> such as failover or migration.
>=20
> It is unnecessary to call that in other events like
> FATAL, NON_FATAL, CHANGE_PARAM, and TIMEOUT resets
> since in those scenarios the hardware does not change.
> If the driver must do a hard reset, it is necessary to notify peers.

Something went wrong here.

> @@ -1877,8 +1877,9 @@ static int do_reset(struct ibmvnic_adapt
>  	for (i =3D 0; i < adapter->req_rx_queues; i++)
>  		napi_schedule(&adapter->napi[i]);
> =20
> -	if (adapter->reset_reason !=3D VNIC_RESET_FAILOVER &&
> -	    adapter->reset_reason !=3D VNIC_RESET_CHANGE_PARAM) {
> +	if ((adapter->reset_reason !=3D VNIC_RESET_FAILOVER &&
> +	     adapter->reset_reason !=3D VNIC_RESET_CHANGE_PARAM) ||
> +	     adapter->reset_reason =3D=3D VNIC_RESET_MOBILITY) {

This condition does not make sense... part after || is redundant.

Mainline changed !=3D in FAILOVER test to =3D=3D, so it does not have same
problem.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--tThc/1wpZn/ma/RB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX80PvAAKCRAw5/Bqldv6
8ipcAKCRPgd82pYiv9P5ZuSS7mCa8yLRXgCgvSa6B+g4Z7PgsKwqQQX/eDbLqAk=
=xEkZ
-----END PGP SIGNATURE-----

--tThc/1wpZn/ma/RB--
