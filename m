Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16D884E8402
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 21:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbiCZUMQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 16:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231216AbiCZUMQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 16:12:16 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE5A22BD71;
        Sat, 26 Mar 2022 13:10:38 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 0CA811C0BB0; Sat, 26 Mar 2022 21:10:37 +0100 (CET)
Date:   Sat, 26 Mar 2022 21:10:36 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5.10 28/38] netfilter: nf_tables: initialize registers in
 nft_do_chain()
Message-ID: <20220326201036.GB9262@duo.ucw.cz>
References: <20220325150419.757836392@linuxfoundation.org>
 <20220325150420.557842097@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <20220325150420.557842097@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri 2022-03-25 16:05:12, Greg Kroah-Hartman wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>=20
> commit 4c905f6740a365464e91467aa50916555b28213d upstream.
>=20
> Initialize registers to avoid stack leak into userspace.

For that, memset() is better, due to padding. There is no padding in
the struct AFAICT, still memset would be better for robustness.

> --- a/net/netfilter/nf_tables_core.c
> +++ b/net/netfilter/nf_tables_core.c
> @@ -162,7 +162,7 @@ nft_do_chain(struct nft_pktinfo *pkt, vo
>  	struct nft_rule *const *rules;
>  	const struct nft_rule *rule;
>  	const struct nft_expr *expr, *last;
> -	struct nft_regs regs;
> +	struct nft_regs regs =3D {};
>  	unsigned int stackptr =3D 0;
>  	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
>  	bool genbit =3D READ_ONCE(net->nft.gencursor);
>=20

Best regards,
							Pavel
--=20
People of Russia, stop Putin before his war on Ukraine escalates.

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYj9zPAAKCRAw5/Bqldv6
8uFUAJ0dgspbW7SWdQHTDw3qdWRM3AyAhACgrfL15kW6mI/AjG4R78R8Ll/sAWE=
=Xkqn
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
