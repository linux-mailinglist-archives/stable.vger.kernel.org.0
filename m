Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9D429D908
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731232AbgJ1Wl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:41:56 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:57404 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbgJ1Wlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Oct 2020 18:41:55 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id E5F711C0BB6; Wed, 28 Oct 2020 21:12:34 +0100 (CET)
Date:   Wed, 28 Oct 2020 21:12:34 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 111/264] nvmem: core: fix possibly memleak when use
 nvmem_cell_info_to_nvmem_cell()
Message-ID: <20201028201234.GA11038@duo.ucw.cz>
References: <20201027135430.632029009@linuxfoundation.org>
 <20201027135435.887735842@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <20201027135435.887735842@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Vadym Kochan <vadym.kochan@plvision.eu>
>=20
> [ Upstream commit fc9eec4d643597cf4cb2fef17d48110e677610da ]
>=20
> Fix missing 'kfree_const(cell->name)' when call to
> nvmem_cell_info_to_nvmem_cell() in several places:
>=20
>      * after nvmem_cell_info_to_nvmem_cell() failed during
>        nvmem_add_cells()
>=20
>      * during nvmem_device_cell_{read,write} when cell->name is
>        kstrdup'ed() without calling kfree_const() at the end, but
>        really there is no reason to do that 'dup, because the cell
>        instance is allocated on the stack for some short period to be
>        read/write without exposing it to the caller.
>=20
> So the new nvmem_cell_info_to_nvmem_cell_nodup() helper is introduced
> which is used to convert cell_info -> cell without name duplication as
> a lighweight version of nvmem_cell_info_to_nvmem_cell().
>=20
> Fixes: e2a5402ec7c6 ("nvmem: Add nvmem_device based consumer apis.")

There's something very wrong here.

> index 30c040786fde2..54204d550fc22 100644
> --- a/drivers/nvmem/core.c
> +++ b/drivers/nvmem/core.c
> @@ -326,9 +326,9 @@ static void nvmem_cell_add(struct nvmem_cell *cell)
>  	mutex_unlock(&nvmem_cells_mutex);
>  }
> =20
> -static int nvmem_cell_info_to_nvmem_cell(struct nvmem_device *nvmem,
> -				   const struct nvmem_cell_info *info,
> -				   struct nvmem_cell *cell)
> +static int nvmem_cell_info_to_nvmem_cell_nodup(struct nvmem_device *nvme=
m,
> +					const struct nvmem_cell_info *info,
> +					struct nvmem_cell *cell)
>  {
>  	cell->nvmem =3D nvmem;
>  	cell->offset =3D info->offset;
> @@ -345,13 +345,30 @@ static int nvmem_cell_info_to_nvmem_cell(struct nvm=
em_device *nvmem,
>  	if (!IS_ALIGNED(cell->offset, nvmem->stride)) {
>  		dev_err(&nvmem->dev,
>  			"cell %s unaligned to nvmem stride %d\n",
> -			cell->name, nvmem->stride);
> +			cell->name ?: "<unknown>", nvmem->stride);
>  		return -EINVAL;
>  	}
> =20
>  	return 0;
>  }

We rename call from .._cell to .._cell_nodup, but it did not have the
kstrdup_const() in the first place!

> +static int nvmem_cell_info_to_nvmem_cell(struct nvmem_device *nvmem,
> +				const struct nvmem_cell_info *info,
> +				struct nvmem_cell *cell)
> +{
> +	int err;
> +
> +	err =3D nvmem_cell_info_to_nvmem_cell_nodup(nvmem, info, cell);
> +	if (err)
> +		return err;
> +
> +	cell->name =3D kstrdup_const(info->name, GFP_KERNEL);
> +	if (!cell->name)
> +		return -ENOMEM;
> +
> +	return 0;
> +}

So now we introduce an allocation, but we don't have a place to free
it. In mainline, it is freed in nvmem_cell_drop(), but 4.19 does not
have a free there.

Best regards,
								Pavel
--=20
http://www.livejournal.com/~pavelmachek

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX5nQsgAKCRAw5/Bqldv6
8ihBAJ0dzQuBqm8Owd8kn4PWA8aEWAyTtwCgs0Ffgl8YI4NWlTA13oW6fwieVU8=
=0+Y+
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
