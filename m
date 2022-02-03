Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271F94A8F63
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbiBCUwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:52:25 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:52632 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiBCUwY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:52:24 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 6317B1C0B79; Thu,  3 Feb 2022 21:52:23 +0100 (CET)
Date:   Thu, 3 Feb 2022 21:52:23 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Aditya Garg <gargaditya08@live.com>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 5.10 011/100] efi: runtime: avoid EFIv2 runtime services
 on Apple x86 machines
Message-ID: <20220203205223.GA19153@duo.ucw.cz>
References: <20220131105220.424085452@linuxfoundation.org>
 <20220131105220.835281614@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="7AUc2qLy4jB3hD7Z"
Content-Disposition: inline
In-Reply-To: <20220131105220.835281614@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--7AUc2qLy4jB3hD7Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Aditya reports [0] that his recent MacbookPro crashes in the firmware
> when using the variable services at runtime. The culprit appears to be a
> call to QueryVariableInfo(), which we did not use to call on Apple x86
> machines in the past as they only upgraded from EFI v1.10 to EFI v2.40
> firmware fairly recently, and QueryVariableInfo() (along with
> UpdateCapsule() et al) was added in EFI v2.00.
>=20
> The only runtime service introduced in EFI v2.00 that we actually use in
> Linux is QueryVariableInfo(), as the capsule based ones are optional,
> generally not used at runtime (all the LVFS/fwupd firmware update
> infrastructure uses helper EFI programs that invoke capsule update at
> boot time, not runtime), and not implemented by Apple machines in the
> first place. QueryVariableInfo() is used to 'safely' set variables,
> i.e., only when there is enough space. This prevents machines with buggy
> firmwares from corrupting their NVRAMs when they run out of space.
>=20
> Given that Apple machines have been using EFI v1.10 services only for
> the longest time (the EFI v2.0 spec was released in 2006, and Linux
> support for the newly introduced runtime services was added in 2011, but
> the MacbookPro12,1 released in 2015 still claims to be EFI v1.10 only),
> let's avoid the EFI v2.0 ones on all Apple x86 machines.

So Apple x86 machines claim they support EFI v2 but really don't?

> +++ b/drivers/firmware/efi/efi.c
> @@ -719,6 +719,13 @@ void __init efi_systab_report_header(con
>  		systab_hdr->revision >> 16,
>  		systab_hdr->revision & 0xffff,
>  		vendor);
> +
> +	if (IS_ENABLED(CONFIG_X86_64) &&
> +	    systab_hdr->revision > EFI_1_10_SYSTEM_TABLE_REVISION &&
> +	    !strcmp(vendor, "Apple")) {
> +		pr_info("Apple Mac detected, using EFI v1.10 runtime services only\n");
> +		efi.runtime_version =3D EFI_1_10_SYSTEM_TABLE_REVISION;
> +	}
>  }

This problem is not 64-bit specific, right? Should it depend on
CONFIG_X86, instead?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--7AUc2qLy4jB3hD7Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYfxAhwAKCRAw5/Bqldv6
8msJAJ9YUK6hbmRnGSAZkOrAk3efCqjCMACgkSvffri+H6ZcNVutTAGrx7CZ0LI=
=lKcG
-----END PGP SIGNATURE-----

--7AUc2qLy4jB3hD7Z--
