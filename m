Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55B854D55C4
	for <lists+stable@lfdr.de>; Fri, 11 Mar 2022 00:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240670AbiCJXuE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 18:50:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244700AbiCJXuE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 18:50:04 -0500
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450C615FC85;
        Thu, 10 Mar 2022 15:49:02 -0800 (PST)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 096F91C0B7F; Fri, 11 Mar 2022 00:49:01 +0100 (CET)
Date:   Fri, 11 Mar 2022 00:48:59 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        James Morse <james.morse@arm.com>
Subject: Re: [PATCH 5.10 38/58] KVM: arm64: Allow indirect vectors to be used
 without SPECTRE_V3A
Message-ID: <20220310234858.GB16308@amd>
References: <20220310140812.869208747@linuxfoundation.org>
 <20220310140813.956533242@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="rS8CxjVDS/+yyDmU"
Content-Disposition: inline
In-Reply-To: <20220310140813.956533242@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--rS8CxjVDS/+yyDmU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

What is going on here?

> commit 5bdf3437603d4af87f9c7f424b0c8aeed2420745 upstream.

Upstream commit 5bdf is very different from this. In particular,

>  arch/arm64/kvm/hyp/smccc_wa.S    |   66 ++++++++++++++++++++++++++++++++=
+++++++

I can't find smccc_wa.S, neither in mainline, nor in -next. And it
looks buggy. I suspect loop_k24 should loop 24 times, but it does 8
loops AFAICT. Same problem with loop_k32.

Best regards,
							Pavel
> --- a/arch/arm64/kvm/hyp/smccc_wa.S
> +++ b/arch/arm64/kvm/hyp/smccc_wa.S
> +
> +	.global	__spectre_bhb_loop_k24
> +SYM_DATA_START(__spectre_bhb_loop_k24)
> +	esb
> +	sub	sp, sp, #(8 * 2)
> +	stp	x0, x1, [sp, #(8 * 0)]
> +	mov	x0, #8
> +2:	b	. + 4
> +	subs	x0, x0, #1
> +	b.ne	2b
> +	dsb	nsh
> +	isb
> +	ldp	x0, x1, [sp, #(8 * 0)]
> +	add	sp, sp, #(8 * 2)
> +1:	.org __spectre_bhb_loop_k24 + __SPECTRE_BHB_LOOP_SZ
> +	.org 1b
> +SYM_DATA_END(__spectre_bhb_loop_k24)
> +
> +	.global	__spectre_bhb_loop_k32
> +SYM_DATA_START(__spectre_bhb_loop_k32)
> +	esb
> +	sub	sp, sp, #(8 * 2)
> +	stp	x0, x1, [sp, #(8 * 0)]
> +	mov	x0, #8
> +2:	b	. + 4
> +	subs	x0, x0, #1
> +	b.ne	2b
> +	dsb	nsh
> +	isb
> +	ldp	x0, x1, [sp, #(8 * 0)]
> +	add	sp, sp, #(8 * 2)
> +1:	.org __spectre_bhb_loop_k32 + __SPECTRE_BHB_LOOP_SZ
> +	.org 1b
> +SYM_DATA_END(__spectre_bhb_loop_k32)
>=20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--rS8CxjVDS/+yyDmU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmIqjmoACgkQMOfwapXb+vKocgCfaskmbakMG67jBcUrKypKGRW5
7uAAniypC4Uhk0lyTS6P8Ecd55ECxKhK
=yE8B
-----END PGP SIGNATURE-----

--rS8CxjVDS/+yyDmU--
