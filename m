Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB1E1818FE
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 14:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729401AbgCKNBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 09:01:09 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:50772 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729358AbgCKNBJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 09:01:09 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 836551C0317; Wed, 11 Mar 2020 14:01:07 +0100 (CET)
Date:   Wed, 11 Mar 2020 14:01:07 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4.19 84/86] efi/x86: Handle by-ref arguments covering
 multiple pages in mixed mode
Message-ID: <20200311130106.GB7285@duo.ucw.cz>
References: <20200310124530.808338541@linuxfoundation.org>
 <20200310124535.409134291@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="kXdP64Ggrk/fb43R"
Content-Disposition: inline
In-Reply-To: <20200310124535.409134291@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--kXdP64Ggrk/fb43R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> Currently, the mixed mode runtime service wrappers require that all by-ref
> arguments that live in the vmalloc space have a size that is a power of 2,
> and are aligned to that same value. While this is a sensible way to
> construct an object that is guaranteed not to cross a page boundary, it is
> overly strict when it comes to checking whether a given object violates
> this requirement, as we can simply take the physical address of the first
> and the last byte, and verify that they point into the same physical
> page.

Dunno. If start passing buffers that _sometime_ cross page boundaries,
we'll get hard to debug failures. Maybe original code is better
buecause it catches problems earlier?

Furthermore, all existing code should pass aligned, 2^n size buffers,
so we should not need this in stable?

> --- a/arch/x86/platform/efi/efi_64.c
> +++ b/arch/x86/platform/efi/efi_64.c
> @@ -321,16 +321,13 @@ virt_to_phys_or_null_size(void *va, unsi
>  	if (virt_addr_valid(va))
>  		return virt_to_phys(va);
> =20
> -	/*
> -	 * A fully aligned variable on the stack is guaranteed not to
> -	 * cross a page bounary. Try to catch strings on the stack by
> -	 * checking that 'size' is a power of two.
> -	 */
> -	bad_size =3D size > PAGE_SIZE || !is_power_of_2(size);
> +	pa =3D slow_virt_to_phys(va);
> =20
> -	WARN_ON(!IS_ALIGNED((unsigned long)va, size) || bad_size);
> +	/* check if the object crosses a page boundary */
> +	if (WARN_ON((pa ^ (pa + size - 1)) & PAGE_MASK))
> +		return 0;

We don't really need to do this computation on pa, it would work on va
as well, right? It does not matter much, but old code worked that way.

Plus, strictly speaking, pa + size can overflow for huge sizes, and
test will return false negatives.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--kXdP64Ggrk/fb43R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXmjhEgAKCRAw5/Bqldv6
8mj+AJ9SlIdfv4wT11lvQQHCHbshsYOwEACgjkW9w1shhVkmNA2Mt7K1kXdu+/w=
=b2DV
-----END PGP SIGNATURE-----

--kXdP64Ggrk/fb43R--
