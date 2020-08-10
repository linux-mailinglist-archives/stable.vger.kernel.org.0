Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37525240B4F
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 18:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgHJQl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 12:41:57 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:47742 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726910AbgHJQl4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 12:41:56 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8B77A1C0BD6; Mon, 10 Aug 2020 18:41:52 +0200 (CEST)
Date:   Mon, 10 Aug 2020 18:41:51 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Qiushi Wu <wu000273@umn.edu>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 25/48] firmware: Fix a reference count leak.
Message-ID: <20200810164151.GC24408@amd>
References: <20200810151804.199494191@linuxfoundation.org>
 <20200810151805.452009812@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <20200810151805.452009812@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Qiushi Wu <wu000273@umn.edu>
>=20
> [ Upstream commit fe3c60684377d5ad9b0569b87ed3e26e12c8173b ]
>=20
> kobject_init_and_add() takes reference even when it fails.
> If this function returns an error, kobject_put() must be called to
> properly clean up the memory associated with the object.
> Callback function fw_cfg_sysfs_release_entry() in kobject_put()
> can handle the pointer "entry" properly.

Okay, but... does that mean err_add_raw: should be using
kobject_put(), too (w/o the kfree)? It is strange to have different
error handling for different error paths.

Best regards,
								Pavel

> +++ b/drivers/firmware/qemu_fw_cfg.c
> @@ -605,8 +605,10 @@ static int fw_cfg_register_file(const struct fw_cfg_=
file *f)
>  	/* register entry under "/sys/firmware/qemu_fw_cfg/by_key/" */
>  	err =3D kobject_init_and_add(&entry->kobj, &fw_cfg_sysfs_entry_ktype,
>  				   fw_cfg_sel_ko, "%d", entry->select);
> -	if (err)
> -		goto err_register;
> +	if (err) {
> +		kobject_put(&entry->kobj);
> +		return err;
> +	}
> =20
>  	/* add raw binary content access */
>  	err =3D sysfs_create_bin_file(&entry->kobj, &fw_cfg_sysfs_attr_raw);
> @@ -622,7 +624,6 @@ static int fw_cfg_register_file(const struct fw_cfg_f=
ile *f)
> =20
>  err_add_raw:
>  	kobject_del(&entry->kobj);
> -err_register:
>  	kfree(entry);
>  	return err;
>  }

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8xeM8ACgkQMOfwapXb+vKP7QCgvXf4MTqkSx6rLOBaewd+iJzC
3XoAoLM1R4UvFXeJf1CqodIDMu3yYzu8
=pWli
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
