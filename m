Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 199A81DB724
	for <lists+stable@lfdr.de>; Wed, 20 May 2020 16:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgETOeA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 May 2020 10:34:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34138 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726943AbgETOd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 May 2020 10:33:59 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPn8-0003vS-VC; Wed, 20 May 2020 15:33:55 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbPn8-007E8U-Ip; Wed, 20 May 2020 15:33:54 +0100
Message-ID: <87267d7217e4a3d58440079c16d313e411eab004.camel@decadent.org.uk>
Subject: Re: Backporting "padata: Remove broken queue flushing"
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, stable <stable@vger.kernel.org>
Date:   Wed, 20 May 2020 15:33:44 +0100
In-Reply-To: <20200519200018.5vuyuxmjy5ypgi3w@ca-dmjordan1.us.oracle.com>
References: <0b158b60fe621552c327e9d822bc3245591a4bd6.camel@decadent.org.uk>
         <20200519200018.5vuyuxmjy5ypgi3w@ca-dmjordan1.us.oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-m2IaeLpxmCsA51lvJPJZ"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-m2IaeLpxmCsA51lvJPJZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2020-05-19 at 16:00 -0400, Daniel Jordan wrote:
> Hello Ben,
>=20
> On Tue, May 19, 2020 at 02:53:05PM +0100, Ben Hutchings wrote:
> > I noticed that commit 07928d9bfc81 "padata: Remove broken queue
> > flushing" has been backported to most stable branches, but commit
> > 6fc4dbcf0276 "padata: Replace delayed timer with immediate workqueue in
> > padata_reorder" has not.
> >=20
> > Is this correct?  What prevents the parallel_data ref-count from
> > dropping to 0 while the timer is scheduled?
>=20
> Doesn't seem like anything does, looking at 4.19.

OK, so it looks like the following commits should be backported:

[3.16-4.9]  119a0798dc42 padata: Remove unused but set variables
[3.16]      de5540d088fe padata: avoid race in reordering
[3.16-4.9]  69b348449bda padata: get_next is never NULL
[3.16-4.14] cf5868c8a22d padata: ensure the reorder timer callback runs on =
the correct CPU
[3.16-4.14] 350ef88e7e92 padata: ensure padata_do_serial() runs on the corr=
ect CPU
[3.16-4.19] 6fc4dbcf0276 padata: Replace delayed timer with immediate workq=
ueue in padata_reorder
[3.16-4.19] ec9c7d19336e padata: initialize pd->cpu with effective cpumask
[3.16-4.19] 065cf577135a padata: purge get_cpu and reorder_via_wq from pada=
ta_do_serial

Ben.

> I can see a race where the timer function uses a parallel_data after free
> whether or not the refcount goes to 0.  Don't think it's likely to happen=
 in
> practice because of how small the window is between the serial callback
> finishing and the timer being deactivated.
>=20
>=20
>    task1:
>    padata_reorder
>                                       task2:
>                                       padata_do_serial
>                                         // object arrives in reorder queu=
e
>      // sees reorder_objects > 0,
>      //   set timer for 1 second
>      mod_timer
>      return
>                                         padata_reorder
>                                           // queue serial work, which fin=
ishes
>                                           //   (now possibly no more obje=
cts
>                                           //    left)
>                                           |
>    task1:                                 |
>    // pd is freed one of two ways:        |
>    //   1) pcrypt is unloaded             |
>    //   2) padata_replace triggered       |
>    //      from userspace                 | (small window)
>                                           |
>    task3:                                 |
>    padata_reorder_timer                   |
>      // uses pd after free                |
>                                           |
>                                           del_timer  // too late
>=20
>=20
> If I got this right we might want to backport the commit you mentioned to=
 be on
> the safe side.
--=20
Ben Hutchings
All the simple programs have been written, and all the good names taken


--=-m2IaeLpxmCsA51lvJPJZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7FP8gACgkQ57/I7JWG
EQn6PQ/7B6DuS4mLpMfbLThku0x4T3b4Mhh+LNlKYqNNrY/InGKhOrRt0b+m/UBV
V8Q2VLfdJTXLcQ4W2i9AK0hSdRMx6RuFCrtqDdKdhsICPqyLTIvqOQB0/2ZID1c8
Eo1gykwtj8ixN29MjszIJB7YciQETIaXMG/qMpJ1Q6jFLyyaGF83obf4WoTzhJ6U
/PfHzh0P1oXwtX2OelIPif4qVRko06o+oCioZAldCyAD4Cdp6z+iIvPTNlGFduiy
cB9WMdL733hCHnevGgn9XLAOK4yhtxS7GCmvCiGF4i9AWbEgzwkNg3kXmPGixW5x
Imrj1ZTUN42jAtwScnyKcBFcYriG3Q0SeHArR1SJOZIToOZzgJIKMdvS7NJcyE0d
Vwno/paJOgQx7hEU8aI3Hu8Q9YCF4u2k59tUNK+Agx+MzTtJlYPuFqyoIJCzJ+tZ
l8UyQt0dZvpGQ19Hku8NrKfqo+4biX/hUdDS+vbMPutMHNVY0mvZHz1+5c/j2OvN
/6p84DU+ipJP347Lr9SjtfqMCG6Uy9hooMaIbpdS1tFldBgYGggGgvY8fTXwsnDm
Ly7RPkbNf61qqaGkCPGkktnBqkjienwxo7xE39eeF+wy63g2G+beE7WEV7H4S67N
dYNxplOEWP8pfLThv61n9wj4BWGDcXD+UNmSewFpj039h30d1Ek=
=GHff
-----END PGP SIGNATURE-----

--=-m2IaeLpxmCsA51lvJPJZ--
