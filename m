Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA974D555A
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 00:28:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344696AbiCJX2i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 18:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233249AbiCJX2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 18:28:36 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4595F62;
        Thu, 10 Mar 2022 15:27:32 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7D2DD1C0B7F; Fri, 11 Mar 2022 00:27:30 +0100 (CET)
Date:   Fri, 11 Mar 2022 00:27:29 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH 5.16 29/37] arm64: entry: Add vectors that have the bhb
 mitigation sequences
Message-ID: <20220310232729.GA16308@amd>
References: <20220309155859.086952723@linuxfoundation.org>
 <20220309155859.932269331@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
In-Reply-To: <20220309155859.932269331@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: James Morse <james.morse@arm.com>
>=20
> commit ba2689234be92024e5635d30fe744f4853ad97db upstream.
>=20
> Some CPUs affected by Spectre-BHB need a sequence of branches, or a
> firmware call to be run before any indirect branch. This needs to go
> in the vectors. No CPU needs both.
>=20
> While this can be patched in, it would run on all CPUs as there is a
> single set of vectors. If only one part of a big/little combination is
> affected, the unaffected CPUs have to run the mitigation too.

This adds build error. Same problem is in 5.10.

> --- /dev/null
> +++ b/arch/arm64/include/asm/vectors.h
> @@ -0,0 +1,34 @@
=2E..
> +/*
> + * Note: the order of this enum corresponds to two arrays in entry.S:
> + * tramp_vecs and __bp_harden_el1_vectors. By default the canonical
> + * 'full fat' vectors are used directly.
> + */
> +enum arm64_bp_harden_el1_vectors {
> +#ifdef CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY
> +	/*
> +	 * Perform the BHB loop mitigation, before branching to the canonical
> +	 * vectors.
> +	 */
> +	EL1_VECTOR_BHB_LOOP,
> +
> +	/*
> +	 * Make the SMC call for firmware mitigation, before branching to the
> +	 * canonical vectors.
> +	 */
> +	EL1_VECTOR_BHB_FW,
> +#endif /* CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY */
> +
> +	/*
> +	 * Remap the kernel before branching to the canonical vectors.
> +	 */
> +	EL1_VECTOR_KPTI,
> ++};
> +


Note "++". Following patch fixes this up, but it is still a trap for
people trying to bisect.

Best regards,
								Pavel

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmIqiWEACgkQMOfwapXb+vLy5gCfWRIJ0Gpwt5BQAmTQySGr7Sl0
ZrgAniQ1l8OEhCOD7oeg9XkYGAdBZnVC
=cf+X
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
