Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 412F61080DD
	for <lists+stable@lfdr.de>; Sat, 23 Nov 2019 22:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726760AbfKWVzq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Nov 2019 16:55:46 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:43690 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbfKWVzq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Nov 2019 16:55:46 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 080851C1DC8; Sat, 23 Nov 2019 22:55:44 +0100 (CET)
Date:   Sat, 23 Nov 2019 22:55:28 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alan Mikhak <alan.mikhak@sifive.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 217/220] tools: PCI: Fix broken pcitest compilation
Message-ID: <20191123215527.GA22003@duo.ucw.cz>
References: <20191122100912.732983531@linuxfoundation.org>
 <20191122100929.234765315@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <20191122100929.234765315@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Alan Mikhak <alan.mikhak@sifive.com>
>=20
> [ Upstream commit 8a5e0af240e07dd3d4897eb8ff52aab757da7fab ]
>=20
> pcitest is currently broken due to the following compiler error
> and related warning. Fix by changing the run_test() function
> signature to return an integer result.
>=20
> pcitest.c: In function run_test:
> pcitest.c:143:9: warning: return with a value, in function
> returning void
>   return (ret < 0) ? ret : 1 - ret; /* return 0 if test succeeded */

There is no such line in 4.19 version.

> +++ b/tools/pci/pcitest.c
> @@ -47,15 +47,15 @@ struct pci_test {
>  	unsigned long	size;
>  };
> =20
> -static void run_test(struct pci_test *test)
> +static int run_test(struct pci_test *test)
>  {
> -	long ret;
> +	int ret =3D -EINVAL;
>  	int fd;

=2E..
        fflush(stdout);
}

No, sorry, this will bring back warning fef31ecaaf2c was supposed to
fix.

My recommendation would be to drop this and fef31ecaaf2c from the
stable. It is warning, not a "serious bug" after all.

Alternatively, it needs to return something at the end of function,
after the fflush().

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXdmqzwAKCRAw5/Bqldv6
8pnlAKDAfSH8VkUmTSRZNPCevb35JDDkBACfa5vcKOesMKaocy/Vkwm65/9lFRo=
=TbXN
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
