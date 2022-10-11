Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90B05FB1D1
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 13:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiJKLtf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 07:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJKLte (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 07:49:34 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C8F1DD;
        Tue, 11 Oct 2022 04:49:33 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5F6AF1C0025; Tue, 11 Oct 2022 13:49:32 +0200 (CEST)
Date:   Tue, 11 Oct 2022 13:49:31 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kees Cook <keescook@chromium.org>,
        kernel test robot <lkp@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.10 07/10] ARM: decompressor: Include
 .data.rel.ro.local
Message-ID: <20221011114931.GB12851@duo.ucw.cz>
References: <20221009205350.1203176-1-sashal@kernel.org>
 <20221009205350.1203176-7-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Content-Disposition: inline
In-Reply-To: <20221009205350.1203176-7-sashal@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Kees Cook <keescook@chromium.org>
>=20
> [ Upstream commit 1b64daf413acd86c2c13f5443f6b4ef3690c8061 ]
>=20
> The .data.rel.ro.local section has the same semantics as .data.rel.ro
> here, so include it in the .rodata section of the decompressor.
> Additionally since the .printk_index section isn't usable outside of
> the core kernel, discard it in the decompressor. Avoids these warnings:
>=20
> arm-linux-gnueabi-ld: warning: orphan section `.data.rel.ro.local' from `=
arch/arm/boot/compressed/fdt_rw.o' being placed in section `.data.rel.ro.lo=
cal'
> arm-linux-gnueabi-ld: warning: orphan section `.printk_index' from `arch/=
arm/boot/compressed/fdt_rw.o' being placed in section `.printk_index'
>

There's no printk_index in 5.10. Perhaps this does not need to be
backported?

Best regards,
							Pavel

> +++ b/arch/arm/boot/compressed/vmlinux.lds.S
> @@ -23,6 +23,7 @@ SECTIONS
>      *(.ARM.extab*)
>      *(.note.*)
>      *(.rel.*)
> +    *(.printk_index)
>      /*
>       * Discard any r/w data - this produces a link error if we have any,
>       * which is required for PIC decompression.  Local data generates
> @@ -57,6 +58,7 @@ SECTIONS
>      *(.rodata)
>      *(.rodata.*)
>      *(.data.rel.ro)
> +    *(.data.rel.ro.*)
>    }
>    .piggydata : {
>      *(.piggydata)
> --=20
> 2.35.1

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY0VYSwAKCRAw5/Bqldv6
8uFAAJsFBphUKE9odWnrQVbCd7RKpnLTxQCeO8kRkJIJEMSEVmW3OQp4mFFDXeE=
=CNMf
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
