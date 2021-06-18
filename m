Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 015833ACA6A
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 13:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232258AbhFRLxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 07:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:42940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231849AbhFRLxf (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Jun 2021 07:53:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D35E613D1;
        Fri, 18 Jun 2021 11:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624017086;
        bh=vYZK8vTsfVOdXVXB0QFo0w3TjJiqmtRYwcEGIkSvqjM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LYd6PeqWTWFHGNaeIbOEvY+gnFFIT9DPDjC4o+J4vRXnDy+s/ZSPE92rD11Ow1Zdh
         BYZlEClp6Ofp3V9nwgXCwbUKVVeY8Hm5Bu8UcLftKAfkVuOLr/lYbdIcIO/AW38S2g
         zY8BdirSkRHScj7xbUE0w8CxGfreapkfSgYRFEi0f84DVKlRc2fnPVjLA7cdaieqUN
         HS9yuH3hdz8eNVbjnIR9XepVyDH9eZjxEZr6o1OdoOlJcIZRJcqJWMpSAoUVZ3XReL
         XqfKbhro9e/aqacezdsgAGIl7KoodLwXRtG7MHO4ZwmaczpC5HhJXlArKHapKdsd+v
         t1F4SOfWaBlEg==
Date:   Fri, 18 Jun 2021 12:51:04 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc:     srivasam@codeaurora.org, rafael@kernel.org,
        dp@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH] regmap: move readable check before accessing regcache.
Message-ID: <20210618115104.GB4920@sirena.org.uk>
References: <20210618113558.10046-1-srinivas.kandagatla@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="z6Eq5LdranGa6ru8"
Content-Disposition: inline
In-Reply-To: <20210618113558.10046-1-srinivas.kandagatla@linaro.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--z6Eq5LdranGa6ru8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 18, 2021 at 12:35:58PM +0100, Srinivas Kandagatla wrote:

> The issue that I encountered is when doing regmap_update_bits on
> a write only register. In regcache path this will not do the right
> thing as the register is not readable and driver which is using
> regmap_update_bits will never notice that it can not do a update
> bits on write only register leading to inconsistent writes and
> random hardware behavior.

Why will use of regmap_update_bits() mean that a driver will never
notice a write failure?  Shouldn't remgap_update_bits() be fixed to
report any errors it isn't reporting, or the driver fixed to check=20
error codes?  I really don't understand the issue you're trying to
report - what is "the right thing" and what makes you believe that a
driver can't do an _update_bits() on a write only but cached register?
Can you specify in concrete terms what the problem is.

> There seems to be missing checks in regcache_read() which is
> now added by moving the orignal check in _regmap_read() before
> accessing regcache.

> Cc: stable@vger.kernel.org
> Fixes: 5d1729e7f02f ("regmap: Incorporate the regcache core into regmap")

Are you *sure* you've identified the actual issue here - nobody has seen
any problems with this in the past decade?  Please don't just pick a
random commit for the sake of adding a Fixes tag.

> @@ -2677,6 +2677,9 @@ static int _regmap_read(struct regmap *map, unsigne=
d int reg,
>  	int ret;
>  	void *context =3D _regmap_map_get_context(map);
> =20
> +	if (!regmap_readable(map, reg))
> +		return -EIO;
> +
>  	if (!map->cache_bypass) {
>  		ret =3D regcache_read(map, reg, val);
>  		if (ret =3D=3D 0)
> @@ -2686,9 +2689,6 @@ static int _regmap_read(struct regmap *map, unsigne=
d int reg,
>  	if (map->cache_only)
>  		return -EBUSY;
> =20
> -	if (!regmap_readable(map, reg))
> -		return -EIO;
> -

This puts the readability check before the cache check which will break
all drivers using the cache on write only registers.

--z6Eq5LdranGa6ru8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmDMiKcACgkQJNaLcl1U
h9DsIAf5Afd+Q+6o68mPeTQ66gkNA3M28sW18xKpTCwg4Pvb1SjI9zqnz9MoVH/0
d4iKxGR5q7xQwdteTLxsCUAFECKxPb03EGOEtMd3t/hjRau5LVs/CUKMpbig5M2w
YWUbsAekvXv773+Y5E9DaXljqYaIxk9sAPog5MupiBShBlOSSaM23XQqhlrE2/Kq
kpjdZzyR3q3yVcXqxjwlWtsiR5Iuzz/djnYJEprfQHDhoHCZ3hrKvGcuLvcIHScY
bMJhLnRbb1C17sy3z18aPC+u0wqQqSCvLfstlc+burujEHDZWSSictoutSp4URWa
yGi2EibjoNft/jCQU/0IxMssaFN9/Q==
=5sp4
-----END PGP SIGNATURE-----

--z6Eq5LdranGa6ru8--
