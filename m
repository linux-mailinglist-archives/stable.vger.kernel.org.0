Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 684D4114407
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 16:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbfLEPuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 10:50:19 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42334 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726028AbfLEPuT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 10:50:19 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ictOQ-0001Ug-Rq; Thu, 05 Dec 2019 15:50:14 +0000
Received: from ben by deadeye with local (Exim 4.93-RC1)
        (envelope-from <ben@decadent.org.uk>)
        id 1ictOO-00048x-Fj; Thu, 05 Dec 2019 15:50:12 +0000
Message-ID: <64c5b8b423774029c3030ae778bf214d36499d2a.camel@decadent.org.uk>
Subject: Re: [PATCH 4.9 45/47] Smack: Dont ignore other bprm->unsafe flags
 if LSM_UNSAFE_PTRACE is set
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Jann Horn <jannh@google.com>,
        Casey Schaufler <casey@schaufler-ca.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date:   Thu, 05 Dec 2019 15:50:07 +0000
In-Reply-To: <20191006172019.260683324@linuxfoundation.org>
References: <20191006172016.873463083@linuxfoundation.org>
         <20191006172019.260683324@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-WzXc7kbU+hI7YjTyITy7"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-WzXc7kbU+hI7YjTyITy7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2019-10-06 at 19:21 +0200, Greg Kroah-Hartman wrote:
> From: Jann Horn <jannh@google.com>
>=20
> commit 3675f052b43ba51b99b85b073c7070e083f3e6fb upstream.
[...]
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -949,7 +949,8 @@ static int smack_bprm_set_creds(struct l
> =20
>  		if (rc !=3D 0)
>  			return rc;
> -	} else if (bprm->unsafe)
> +	}
> +	if (bprm->unsafe & ~LSM_UNSAFE_PTRACE)

I think this needs to be ~(LSM_UNSAFE_PTRACE | LSM_UNSAFE_PTRACE_CAP)
for 4.9 and older branches.

Ben.

>  		return -EPERM;
> =20
>  	bsp->smk_task =3D isp->smk_task;
>=20
>=20
--=20
Ben Hutchings
Every program is either trivial or else contains at least one bug


--=-WzXc7kbU+hI7YjTyITy7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl3pJy8ACgkQ57/I7JWG
EQmkkA//UD3fSIdKqnWIbSozwT+fUUEodPEtil8oS6YYfxQ30ozagDG/xri/pnc8
gvpAdqfdw1jMv31OSPJKimWj3vN7GGzrNuIM3Xx+GUiV3xkCu52yhW7WONUPJG9n
BHmp2Sq0iCYZfufHTY4p0lqdSw4BYKEQKH9+mPc+SD06tAXazjDVnxmfJYyb3RBY
XzUJYhHJ78pJuuUeQdZ+gZq+CS22i0H/vfX+EwbxiNHu3skGz42/TuQ9aJVnGJLa
kM/14+MLXAqJ82JRQ53LRn5aPJEkbnHAijx5f1tdPJ6wZ7QQejfCJux1uKL6ow2f
exfVmpr2sBz5c9vW3/hmzzQ7DACMnLikQyGHw3M5niR9WloDLroDaPwzI5D0KjrV
SobwoY0nv19vyOiSO7qnZ3QAk5lsCgGIfEP6gt67a/VXnzyLN4DEj+1jPgxyAs2M
h4HPPfZRcGk9D8AiNnn4gM/5vAibscWFb1QUBakP/e9396VRP2LUAAWa6wW7x1jH
iV93B0jve4/vHMYY7k2KqY+GU2mgt13hOT3kE9j/IzVUSZNWpup5+fcavnf8bnX7
vZw96C7TTxYPOFNaw06R5PxjQ3M1mA1pFDHWY7SfXewrD6V0HkIQ3q9uvWyr6Poi
k26kOColNp1s6r/NBr5+USxQawr8F4xAB2/Z75yyfU9CDbvOuLs=
=8ruJ
-----END PGP SIGNATURE-----

--=-WzXc7kbU+hI7YjTyITy7--
