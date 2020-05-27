Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFD9E1E43C0
	for <lists+stable@lfdr.de>; Wed, 27 May 2020 15:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387972AbgE0Ndj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 May 2020 09:33:39 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46334 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387514AbgE0Ndi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 May 2020 09:33:38 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 462FE1C0320; Wed, 27 May 2020 15:33:36 +0200 (CEST)
Date:   Wed, 27 May 2020 15:33:35 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>,
        Dexuan Cui <decui@microsoft.com>,
        Pedro dAquino Filocre F S Barbuda 
        <pbarbuda@microsoft.com>, Vishal Verma <vishal.l.verma@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 53/81] libnvdimm/btt: Fix LBA masking during free
 list population
Message-ID: <20200527133335.GB11424@amd>
References: <20200526183923.108515292@linuxfoundation.org>
 <20200526183932.993059888@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="aVD9QWMuhilNxW9f"
Content-Disposition: inline
In-Reply-To: <20200526183932.993059888@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> If an implementation does happen to have it set, we would happily read
> it in as the next block to write to for writes. Since a high bit is set,
> it pushes the block number out of the range of an 'arena', and we fail
> such a write with an EIO.
>=20
> Follow the robustness principle, and tolerate such implementations by
> stripping out the zero flag when populating the free list during
> initialization. Additionally, use the same stripped out entries for
> detection of incomplete writes and map restoration that happens at this
> stage.

> Add a sysfs file 'log_zero_flags' that indicates the ability to accept
> such a layout to userspace applications. This enables 'ndctl
> check-namespace' to recognize whether the kernel is able to handle zero
> flags, or whether it should attempt a fix-up under the --repair
> option.

Ok, so new /sys file is added; but that should have entry in
Documentation/ and that one is not there AFAICT. (Not in -linus, so
I assume not in -stable, either).

Best regards,
								Pavel

> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Dexuan Cui <decui@microsoft.com>
> Reported-by: Pedro d'Aquino Filocre F S Barbuda <pbarbuda@microsoft.com>
> Tested-by: Dexuan Cui <decui@microsoft.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/nvdimm/btt.c      | 25 +++++++++++++++++++------
>  drivers/nvdimm/btt.h      |  2 ++
>  drivers/nvdimm/btt_devs.c |  8 ++++++++
>  3 files changed, 29 insertions(+), 6 deletions(-)
>=20
> diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
> index d78cfe82ad5c..1064a703ccec 100644
> --- a/drivers/nvdimm/btt.c
> +++ b/drivers/nvdimm/btt.c
> @@ -542,8 +542,8 @@ static int arena_clear_freelist_error(struct arena_in=
fo *arena, u32 lane)
>  static int btt_freelist_init(struct arena_info *arena)
>  {
>  	int new, ret;
> -	u32 i, map_entry;
>  	struct log_entry log_new;
> +	u32 i, map_entry, log_oldmap, log_newmap;
> =20
>  	arena->freelist =3D kcalloc(arena->nfree, sizeof(struct free_entry),
>  					GFP_KERNEL);
> @@ -555,16 +555,22 @@ static int btt_freelist_init(struct arena_info *are=
na)
>  		if (new < 0)
>  			return new;
> =20
> +		/* old and new map entries with any flags stripped out */
> +		log_oldmap =3D ent_lba(le32_to_cpu(log_new.old_map));
> +		log_newmap =3D ent_lba(le32_to_cpu(log_new.new_map));
> +
>  		/* sub points to the next one to be overwritten */
>  		arena->freelist[i].sub =3D 1 - new;
>  		arena->freelist[i].seq =3D nd_inc_seq(le32_to_cpu(log_new.seq));
> -		arena->freelist[i].block =3D le32_to_cpu(log_new.old_map);
> +		arena->freelist[i].block =3D log_oldmap;
> =20
>  		/*
>  		 * FIXME: if error clearing fails during init, we want to make
>  		 * the BTT read-only
>  		 */
> -		if (ent_e_flag(log_new.old_map)) {
> +		if (ent_e_flag(log_new.old_map) &&
> +				!ent_normal(log_new.old_map)) {
> +			arena->freelist[i].has_err =3D 1;
>  			ret =3D arena_clear_freelist_error(arena, i);
>  			if (ret)
>  				dev_err_ratelimited(to_dev(arena),
> @@ -572,7 +578,7 @@ static int btt_freelist_init(struct arena_info *arena)
>  		}
> =20
>  		/* This implies a newly created or untouched flog entry */
> -		if (log_new.old_map =3D=3D log_new.new_map)
> +		if (log_oldmap =3D=3D log_newmap)
>  			continue;
> =20
>  		/* Check if map recovery is needed */
> @@ -580,8 +586,15 @@ static int btt_freelist_init(struct arena_info *aren=
a)
>  				NULL, NULL, 0);
>  		if (ret)
>  			return ret;
> -		if ((le32_to_cpu(log_new.new_map) !=3D map_entry) &&
> -				(le32_to_cpu(log_new.old_map) =3D=3D map_entry)) {
> +
> +		/*
> +		 * The map_entry from btt_read_map is stripped of any flag bits,
> +		 * so use the stripped out versions from the log as well for
> +		 * testing whether recovery is needed. For restoration, use the
> +		 * 'raw' version of the log entries as that captured what we
> +		 * were going to write originally.
> +		 */
> +		if ((log_newmap !=3D map_entry) && (log_oldmap =3D=3D map_entry)) {
>  			/*
>  			 * Last transaction wrote the flog, but wasn't able
>  			 * to complete the map write. So fix up the map.
> diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
> index db3cb6d4d0d4..ddff49c707b0 100644
> --- a/drivers/nvdimm/btt.h
> +++ b/drivers/nvdimm/btt.h
> @@ -44,6 +44,8 @@
>  #define ent_e_flag(ent) (!!(ent & MAP_ERR_MASK))
>  #define ent_z_flag(ent) (!!(ent & MAP_TRIM_MASK))
>  #define set_e_flag(ent) (ent |=3D MAP_ERR_MASK)
> +/* 'normal' is both e and z flags set */
> +#define ent_normal(ent) (ent_e_flag(ent) && ent_z_flag(ent))
> =20
>  enum btt_init_state {
>  	INIT_UNCHECKED =3D 0,
> diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
> index e341498876ca..9486acc08402 100644
> --- a/drivers/nvdimm/btt_devs.c
> +++ b/drivers/nvdimm/btt_devs.c
> @@ -159,11 +159,19 @@ static ssize_t size_show(struct device *dev,
>  }
>  static DEVICE_ATTR_RO(size);
> =20
> +static ssize_t log_zero_flags_show(struct device *dev,
> +		struct device_attribute *attr, char *buf)
> +{
> +	return sprintf(buf, "Y\n");
> +}
> +static DEVICE_ATTR_RO(log_zero_flags);
> +
>  static struct attribute *nd_btt_attributes[] =3D {
>  	&dev_attr_sector_size.attr,
>  	&dev_attr_namespace.attr,
>  	&dev_attr_uuid.attr,
>  	&dev_attr_size.attr,
> +	&dev_attr_log_zero_flags.attr,
>  	NULL,
>  };
> =20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--aVD9QWMuhilNxW9f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7ObC8ACgkQMOfwapXb+vKI2QCgsQVbH25sPaT9obowvjG18XW2
4bYAn0eM2z+qaiMlvYRCpnmbjp+K1r8Z
=0FpG
-----END PGP SIGNATURE-----

--aVD9QWMuhilNxW9f--
