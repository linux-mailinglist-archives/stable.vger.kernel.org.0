Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69CB660B667
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 20:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232711AbiJXS47 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 14:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbiJXSz7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 14:55:59 -0400
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EF58A1EB;
        Mon, 24 Oct 2022 10:36:48 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 62C951C002B; Mon, 24 Oct 2022 19:35:34 +0200 (CEST)
Date:   Mon, 24 Oct 2022 19:35:33 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH 5.10 080/390] efi: libstub: drop pointless
 get_memory_map() call
Message-ID: <20221024173533.GB25198@duo.ucw.cz>
References: <20221024113022.510008560@linuxfoundation.org>
 <20221024113026.018659861@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="yNb1oOkm5a9FJOVX"
Content-Disposition: inline
In-Reply-To: <20221024113026.018659861@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NEUTRAL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Ard Biesheuvel <ardb@kernel.org>
>=20
> commit d80ca810f096ff66f451e7a3ed2f0cd9ef1ff519 upstream.
>=20
> Currently, the non-x86 stub code calls get_memory_map() redundantly,
> given that the data it returns is never used anywhere. So drop the
> call.

In mainline, map is not used after this point.

But in 5.10, map is passed to

        status =3D efi_exit_boot_services(handle, &map, &priv, exit_boot_fu=
nc);

few lines below. Can someone verify this reasoning still holds?

Thanks and best regards,
								Pavel
> +++ b/drivers/firmware/efi/libstub/fdt.c
> @@ -281,14 +281,6 @@ efi_status_t allocate_new_fdt_and_exit_b
>  		goto fail;
>  	}
> =20
> -	/*
> -	 * Now that we have done our final memory allocation (and free)
> -	 * we can get the memory map key needed for exit_boot_services().
> -	 */
> -	status =3D efi_get_memory_map(&map);
> -	if (status !=3D EFI_SUCCESS)
> -		goto fail_free_new_fdt;
> -
>  	status =3D update_fdt((void *)fdt_addr, fdt_size,
>  			    (void *)*new_fdt_addr, MAX_FDT_SIZE, cmdline_ptr,
>  			    initrd_addr, initrd_size);
>=20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--yNb1oOkm5a9FJOVX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCY1bM5QAKCRAw5/Bqldv6
8j4EAKC+Ao6NWme/SwNPXR0c3Ce+T+NV5gCgiQZtQO5fTQwMb56ZmxX3TSGjUn8=
=86m7
-----END PGP SIGNATURE-----

--yNb1oOkm5a9FJOVX--
