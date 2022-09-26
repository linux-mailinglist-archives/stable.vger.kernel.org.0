Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCED55EA76F
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 15:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbiIZNhw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 09:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234687AbiIZNhX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 09:37:23 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ACC51E1CDF;
        Mon, 26 Sep 2022 04:57:27 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 7392E1C0016; Mon, 26 Sep 2022 13:08:25 +0200 (CEST)
Date:   Mon, 26 Sep 2022 13:08:26 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Daniel Marth <daniel.marth@inso.tuwien.ac.at>,
        Ard Biesheuvel <ardb@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.14 06/40] efi: libstub: Disable struct randomization
Message-ID: <20220926110826.GE8978@amd>
References: <20220926100738.148626940@linuxfoundation.org>
 <20220926100738.463310701@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="imjhCm/Pyz7Rq5F2"
Content-Disposition: inline
In-Reply-To: <20220926100738.463310701@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--imjhCm/Pyz7Rq5F2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> These structs look like the ideal randomization candidates to the
> randstruct plugin (as they only carry function pointers), but of course,
> these protocols are contracts between the firmware that exposes them,
> and the EFI applications (including our stubbed kernel) that invoke
> them. This means that struct randomization for EFI protocols is not a
> great idea, and given that the stub shares very little data with the
> core kernel that is represented as a randomizable struct, we're better
> off just disabling it completely here.

> Cc: <stable@vger.kernel.org> # v4.14+

AFAICT RANDSTRUCT_CFLAGS is not available in v4.19, so we should not
take this patch.

Best regards,
								Pavel

> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -23,6 +23,13 @@ KBUILD_CFLAGS			:=3D $(cflags-y) -DDISABLE_BRANCH_PROF=
ILING \
>  				   $(call cc-option,-ffreestanding) \
>  				   $(call cc-option,-fno-stack-protector)
> =20
> +#
> +# struct randomization only makes sense for Linux internal types, which =
the EFI
> +# stub code never touches, so let's turn off struct randomization for th=
e stub
> +# altogether
> +#
> +KBUILD_CFLAGS :=3D $(filter-out $(RANDSTRUCT_CFLAGS), $(KBUILD_CFLAGS))
> +
>  # remove SCS flags from all objects in this directory
>  KBUILD_CFLAGS :=3D $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
> =20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--imjhCm/Pyz7Rq5F2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmMxiCkACgkQMOfwapXb+vJtZQCffY9WfxvtGdq8edyOwHSeKdw2
sWAAn1ENXv4qLWWJwOhKZ3LmXqwksGkc
=lLvp
-----END PGP SIGNATURE-----

--imjhCm/Pyz7Rq5F2--
