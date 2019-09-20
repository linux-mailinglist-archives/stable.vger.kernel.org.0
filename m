Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E75FBB98D4
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 23:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbfITVRB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 17:17:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39458 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725842AbfITVRA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 17:17:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBQGv-0000JI-JA; Fri, 20 Sep 2019 22:16:57 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBQGv-0001ab-Cj; Fri, 20 Sep 2019 22:16:57 +0100
Message-ID: <8dbced01558cd8d4a1d4f058010e7d63e5f6810e.camel@decadent.org.uk>
Subject: Re: [PATCH 3.16 000/132] 3.16.74-rc1 review
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Date:   Fri, 20 Sep 2019 22:16:49 +0100
In-Reply-To: <20190920200423.GA26056@roeck-us.net>
References: <lsq.1568989414.954567518@decadent.org.uk>
         <20190920200423.GA26056@roeck-us.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-/rRJG551LxhZ+TSENQAr"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-/rRJG551LxhZ+TSENQAr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-09-20 at 13:04 -0700, Guenter Roeck wrote:
> On Fri, Sep 20, 2019 at 03:23:34PM +0100, Ben Hutchings wrote:
> > This is the start of the stable review cycle for the 3.16.74 release.
> > There are 132 patches in this series, which will be posted as responses
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >=20
> > Responses should be made by Mon Sep 23 20:00:00 UTC 2019.
> > Anything received after that time might be too late.
> >=20
>=20
> Build results:
> 	total: 136 pass: 135 fail: 1
> Failed builds:
> 	arm:allmodconfig
> Qemu test results:
> 	total: 229 pass: 229 fail: 0
>=20
> Build errors in arm:allmodconfig are along the line of
>=20
> In file included from include/linux/printk.h:5,
>                  from include/linux/kernel.h:13,
>                  from include/linux/clk.h:16,
>                  from drivers/gpu/drm/tilcdc/tilcdc_drv.h:21,
>                  from drivers/gpu/drm/tilcdc/tilcdc_drv.c:20:
> include/linux/init.h:343:7: error: 'cleanup_module'
> 	specifies less restrictive attribute than its target 'tilcdc_drm_fini': =
'cold'
>=20
> In addition to a few errors like that, there are literally thousands
> of similar warnings.

It looks like this is triggered by you switching arm builds from gcc 8
to 9, rather than by any code change.

Does it actually make sense to try to support building Linux 3.16 with
gcc 9?  If so, I suppose I'll need to add:

commit edc966de8725f9186cc9358214da89d335f0e0bd
Author: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Fri Aug 2 12:37:56 2019 +0200

    Backport minimal compiler_attributes.h to support GCC 9

commit a6e60d84989fa0e91db7f236eda40453b0e44afa
Author: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date:   Sat Jan 19 20:59:34 2019 +0100

    include/linux/module.h: copy __init/__exit attrs to init/cleanup_module

Ben.

--=20
Ben Hutchings
Nothing is ever a complete failure;
it can always serve as a bad example.



--=-/rRJG551LxhZ+TSENQAr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl2FQcEACgkQ57/I7JWG
EQkgFw/+P7CzjA+0Pbp70U6LrRKkknpueGfl4pU0Yf6pFa7JrViMkDjHCa7QupPE
ct40MZvLllbC8Fh/WhwL6c91sLFU2I3KubltYm9zb4I1zk2qpZq6ZJ3PZ1sFvfjj
u/RgUT1GmhxWCZJD2U0De/vorHuKskPe5oO9ZZ39X3YBKlf/POH+TPU5siXXsCm0
8j6aEqnDmXcbobfz6eEjE2jTfUEwxrq9OlzbJtrmPVrdmGRcRNFgEyAR6wM/UWa4
y4NfE35Qb9pz2MvU1FW4kKV0BA2HPA0ZzvLDqcqKBR48kkxYLlAnidXyMsTpfymX
x4NGW/ZeMUbwabaeucOVVjw1dFYJrQw7cCymF3yelrlK3OuN1f3SDBj9PhxX4hHd
5JPijSSOg/7baJtRS7oLbzC6B0ittNr2JV4hc9SLpPL9nzApOMt8PodtS5ZoEqhX
r/5XyDGThqKr5+ByXuxpVKubsYJL0fdqdd5Xx1Zt051cuaFYwjMGELQfPHzcF+qF
fhA0Ffpn6dJ8Vhl1G9sZGvcCWH4+DWH0AZzZbYrASoh60OGACKJ3QJML3G0cg1Fv
FD2BAL2i+buooiPuJk2bDutRjKn+WIJgLEDMvcp/PCb2/M8K/IZ8Cy04bB8HTKyr
DQE3pSa3xfxMWlPGUtpoipeQFMH5Z3ocRFZX6OzKexYi+HlpkUw=
=+EhR
-----END PGP SIGNATURE-----

--=-/rRJG551LxhZ+TSENQAr--
