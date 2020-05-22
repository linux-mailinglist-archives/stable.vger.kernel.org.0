Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AB7E1DDC13
	for <lists+stable@lfdr.de>; Fri, 22 May 2020 02:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbgEVAVG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 21 May 2020 20:21:06 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44566 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726693AbgEVAVG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 21 May 2020 20:21:06 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbvQi-0001eH-1E; Fri, 22 May 2020 01:20:52 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jbvQh-007Yy5-S0; Fri, 22 May 2020 01:20:51 +0100
Message-ID: <452c787b78093a4705374e5f4b643105ffdde24c.camel@decadent.org.uk>
Subject: Re: [stable-4.4 1/5] padata: set cpu_index of unused CPUs to -1
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Mathias Krause <minipli@googlemail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org
Date:   Fri, 22 May 2020 01:20:45 +0100
In-Reply-To: <20200521205145.1953392-1-daniel.m.jordan@oracle.com>
References: <20200521205145.1953392-1-daniel.m.jordan@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-B/2ViPqdyklqoChOzszE"
User-Agent: Evolution 3.36.2-1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-B/2ViPqdyklqoChOzszE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2020-05-21 at 16:51 -0400, Daniel Jordan wrote:
> From: Mathias Krause <minipli@googlemail.com>
>=20
> [ Upstream commit 1bd845bcb41d5b7f83745e0cb99273eb376f2ec5 ]

Well spotted, I'll add this for 3.16 as well.

Ben.

> The parallel queue per-cpu data structure gets initialized only for CPUs
> in the 'pcpu' CPU mask set. This is not sufficient as the reorder timer
> may run on a different CPU and might wrongly decide it's the target CPU
> for the next reorder item as per-cpu memory gets memset(0) and we might
> be waiting for the first CPU in cpumask.pcpu, i.e. cpu_index 0.
>=20
> Make the '__this_cpu_read(pd->pqueue->cpu_index) =3D=3D next_queue->cpu_i=
ndex'
> compare in padata_get_next() fail in this case by initializing the
> cpu_index member of all per-cpu parallel queues. Use -1 for unused ones.
>=20
> Signed-off-by: Mathias Krause <minipli@googlemail.com>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> ---
>  kernel/padata.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>=20
> diff --git a/kernel/padata.c b/kernel/padata.c
> index 8aef48c3267b..4f860043a8e5 100644
> --- a/kernel/padata.c
> +++ b/kernel/padata.c
> @@ -461,8 +461,14 @@ static void padata_init_pqueues(struct parallel_data=
 *pd)
>  	struct padata_parallel_queue *pqueue;
> =20
>  	cpu_index =3D 0;
> -	for_each_cpu(cpu, pd->cpumask.pcpu) {
> +	for_each_possible_cpu(cpu) {
>  		pqueue =3D per_cpu_ptr(pd->pqueue, cpu);
> +
> +		if (!cpumask_test_cpu(cpu, pd->cpumask.pcpu)) {
> +			pqueue->cpu_index =3D -1;
> +			continue;
> +		}
> +
>  		pqueue->pd =3D pd;
>  		pqueue->cpu_index =3D cpu_index;
>  		cpu_index++;
--=20
Ben Hutchings
Logic doesn't apply to the real world. - Marvin Minsky



--=-B/2ViPqdyklqoChOzszE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl7HGt0ACgkQ57/I7JWG
EQnYJg/8CUMVCpACrK3mulPMC+30AGGLzEuGyDzELzVU0kUbGFD63Kxk04yJfk0N
855fPcGW4qZOxvgo/HHdzg5WiYvaveLitbK1QWPxkTvwldYMD7Wy8Tnfvf/q5vI2
K/l+QBIKI4GJZSAUdeaV1navzJADAR/y2Bo1JnOOEmxZvw0cKAJl0nWnQ9h/fbc6
3GaenhRkNM98rRHbqK/pDeWNwZ0HYoZEMC9pDegvbNZb8AJOU+YAz9ILLCGbRaGb
+Iohxu2/3nwEBpz4WJevfX8LuoO2hekx8MuDc0jhXHU+9n9NjxygLIdCGB35kJkD
WU4+63EcmZtVIQu6sVpFEfvC3YIK+4rhRJgtnZqXRhlyxHk7TewVjR4xO0BYgUu3
OZDBHU98cstdRYTiaVXZPGE2Tu9XcAI0H44KQMetdJAi5E7ldb87EZJdtnJ8kIai
F4ixLsGU6bMvv2QMJQneWK0vfkInaMKTAxknPBC+w31ynq2r2Gid9GydGR+Vvr2D
rWH6wWpWP5C326v8UEcjdz4ZtE6//Obllj98iUcJwf7MxvDxAI6VQ7OrEpe7Xttk
LGqxqjxkRqqYG8GM4lyDRYhCHWdluyLThMEl11rZaF254bEqMcxL5MH8wgg9ZDkk
G3nQqdu6Mq5P7g6/vMISTaX6ZIXQjyQicywhXAmhrewt5fpIGqg=
=B0fu
-----END PGP SIGNATURE-----

--=-B/2ViPqdyklqoChOzszE--
