Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D5B3B1C64
	for <lists+stable@lfdr.de>; Wed, 23 Jun 2021 16:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230182AbhFWO2y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Jun 2021 10:28:54 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:56102 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhFWO2y (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Jun 2021 10:28:54 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 92DC71C0B77; Wed, 23 Jun 2021 16:26:35 +0200 (CEST)
Date:   Wed, 23 Jun 2021 16:26:35 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Changbin Du <changbin.du@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 045/146] net: make get_net_ns return error if NET_NS
 is disabled
Message-ID: <20210623142635.GB27348@amd>
References: <20210621154911.244649123@linuxfoundation.org>
 <20210621154912.823486108@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LpQ9ahxlCli8rRTG"
Content-Disposition: inline
In-Reply-To: <20210621154912.823486108@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LpQ9ahxlCli8rRTG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!
>=20
> There is a panic in socket ioctl cmd SIOCGSKNS when NET_NS is not enabled.
> The reason is that nsfs tries to access ns->ops but the proc_ns_operations
> is not implemented in this case.
>=20
> [7.670023] Unable to handle kernel NULL pointer dereference at virtual ad=
dress 00000010
> [7.670268] pgd =3D 32b54000
> [7.670544] [00000010] *pgd=3D00000000
> [7.671861] Internal error: Oops: 5 [#1] SMP ARM
> [7.672315] Modules linked in:
> [7.672918] CPU: 0 PID: 1 Comm: systemd Not tainted 5.13.0-rc3-00375-g6799=
d4f2da49 #16
> [7.673309] Hardware name: Generic DT based system
> [7.673642] PC is at nsfs_evict+0x24/0x30
> [7.674486] LR is at clear_inode+0x20/0x9c
>=20
> The same to tun SIOCGSKNS command.
>=20
> To fix this problem, we make get_net_ns() return -EINVAL when NET_NS is
> disabled. Meanwhile move it to right place net/core/net_namespace.c.

-EINVAL sounds like wrong error code for valid operation kernel was
configured to do. -ENOTSUPP?

Best regards,
								Pavel
							=09
--=20
http://www.livejournal.com/~pavelmachek

--LpQ9ahxlCli8rRTG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmDTRJoACgkQMOfwapXb+vKLSgCgmVri4C1MoNWL+M+Rsa38QWIa
yEcAnRdpSF14hmblCXYBiOBkla8L08lc
=BmRA
-----END PGP SIGNATURE-----

--LpQ9ahxlCli8rRTG--
