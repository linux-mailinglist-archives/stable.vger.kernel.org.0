Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5878F542F61
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 13:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238297AbiFHLkw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 07:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238277AbiFHLkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 07:40:52 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E9401DFC6F;
        Wed,  8 Jun 2022 04:40:51 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 091A01C0BB4; Wed,  8 Jun 2022 13:40:50 +0200 (CEST)
Date:   Wed, 8 Jun 2022 13:40:49 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Yuntao Wang <ytcoode@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 136/452] bpf: Fix excessive memory allocation in
 stack_map_alloc()
Message-ID: <20220608114049.GC9333@duo.ucw.cz>
References: <20220607164908.521895282@linuxfoundation.org>
 <20220607164912.613808833@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wxDdMuZNg1r63Hyj"
Content-Disposition: inline
In-Reply-To: <20220607164912.613808833@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wxDdMuZNg1r63Hyj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> The 'n_buckets * (value_size + sizeof(struct stack_map_bucket))' part of =
the
> allocated memory for 'smap' is never used after the memlock accounting was
> removed, thus get rid of it.
>=20
> [ Note, Daniel:
>=20
> Commit b936ca643ade ("bpf: rework memlock-based memory accounting for map=
s")
> moved `cost +=3D n_buckets * (value_size + sizeof(struct stack_map_bucket=
))`
> up and therefore before the bpf_map_area_alloc() allocation, sigh. In a l=
ater
> step commit c85d69135a91 ("bpf: move memory size checks to bpf_map_charge=
_init()"),
> and the overflow checks of `cost >=3D U32_MAX - PAGE_SIZE` moved into
> bpf_map_charge_init(). And then 370868107bf6 ("bpf: Eliminate rlimit-based
> memory accounting for stackmap maps") finally removed the bpf_map_charge_=
init().
> Anyway, the original code did the allocation same way as /after/ this fix=
=2E ]

We don't have 370868107bf6 in 5.10. Can someone verify this is still
right think to do for 5.10?

Best regards,
								Pavel
							=09
> +++ b/kernel/bpf/stackmap.c
> @@ -121,7 +121,6 @@ static struct bpf_map *stack_map_alloc(union bpf_attr=
 *attr)
>  		return ERR_PTR(-E2BIG);
> =20
>  	cost =3D n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
> -	cost +=3D n_buckets * (value_size + sizeof(struct stack_map_bucket));
>  	err =3D bpf_map_charge_init(&mem, cost);
>  	if (err)
>  		return ERR_PTR(err);

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--wxDdMuZNg1r63Hyj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYqCKwQAKCRAw5/Bqldv6
8gOoAKCas9XK10HZN7NVkNBIUOQbTy1WBwCgoAlWLuRiNvh4TR+vRWJWLu6ex8Q=
=o2rh
-----END PGP SIGNATURE-----

--wxDdMuZNg1r63Hyj--
