Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D960B3E8B06
	for <lists+stable@lfdr.de>; Wed, 11 Aug 2021 09:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbhHKH3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Aug 2021 03:29:08 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39902 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbhHKH3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Aug 2021 03:29:08 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 2A2F11C0B76; Wed, 11 Aug 2021 09:28:44 +0200 (CEST)
Date:   Wed, 11 Aug 2021 09:28:43 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        jason@jlekstrand.net, Jonathan Gray <jsg@jsg.id.au>
Subject: Re: [PATCH 5.10 125/135] drm/i915: avoid uninitialised var in
 eb_parse()
Message-ID: <20210811072843.GC10829@duo.ucw.cz>
References: <20210810172955.660225700@linuxfoundation.org>
 <20210810173000.050147269@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="iFRdW5/EC4oqxDHL"
Content-Disposition: inline
In-Reply-To: <20210810173000.050147269@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--iFRdW5/EC4oqxDHL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Jonathan Gray <jsg@jsg.id.au>
>=20
> The backport of c9d9fdbc108af8915d3f497bbdf3898bf8f321b8 to 5.10 in
> 6976f3cf34a1a8b791c048bbaa411ebfe48666b1 removed more than it should
> have leading to 'batch' being used uninitialised.  The 5.13 backport and
> the mainline commit did not remove the portion this patch adds back.

This patch has no upstream equivalent, right?

Which is okay -- it explains it in plain english, but it shows that
scripts should not simply search for anything that looks like SHA and
treat it as upsteam commit it.

So let me re-iterate need for consistent marking of upstream commits.

So far this works reasonably well, but selecting one format and
sticking to it would be even better.

                ma =3D re.match(".*Upstream commit ([0-9a-f]*) .*", l)
                if ma:
                    m.upstream =3D ma.group(1)
		ma =3D re.match("[Cc]ommit ([0-9a-f]*) upstream[.]*", l)
                if ma:
                    m.upstream =3D ma.group(1)
		ma =3D re.match("[Cc]ommit: ([0-9a-f]*)", l)
                if ma:
	            m.upstream =3D ma.group(1)

Thanks and best regards,
								Pavel

> Signed-off-by: Jonathan Gray <jsg@jsg.id.au>
> Fixes: 6976f3cf34a1 ("drm/i915: Revert "drm/i915/gem: Asynchronous cmdpar=
ser"")
> Cc: <stable@vger.kernel.org> # 5.10
> Cc: Jason Ekstrand <jason@jlekstrand.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |    7 +++++++
>  1 file changed, 7 insertions(+)
>=20
> --- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> @@ -2351,6 +2351,12 @@ static int eb_parse(struct i915_execbuff
>  		eb->batch_flags |=3D I915_DISPATCH_SECURE;
>  	}
> =20
> +	batch =3D eb_dispatch_secure(eb, shadow);
> +	if (IS_ERR(batch)) {
> +		err =3D PTR_ERR(batch);
> +		goto err_trampoline;
> +	}
> +
>  	err =3D intel_engine_cmd_parser(eb->engine,
>  				      eb->batch->vma,
>  				      eb->batch_start_offset,
> @@ -2377,6 +2383,7 @@ secure_batch:
>  err_unpin_batch:
>  	if (batch)
>  		i915_vma_unpin(batch);
> +err_trampoline:
>  	if (trampoline)
>  		i915_vma_unpin(trampoline);
>  err_shadow:
>=20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--iFRdW5/EC4oqxDHL
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCYRN8KwAKCRAw5/Bqldv6
8jBbAKCauBZgV5eO5Kezo/NR3t/5b6kB2wCeJ+0eyFa9mRtULm2hLeFAoRvDWQc=
=jABX
-----END PGP SIGNATURE-----

--iFRdW5/EC4oqxDHL--
