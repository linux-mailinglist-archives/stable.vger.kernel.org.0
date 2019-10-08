Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 483E2CF661
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 11:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729790AbfJHJp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 05:45:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:35805 "EHLO
        atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728866AbfJHJp5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 05:45:57 -0400
Received: by atrey.karlin.mff.cuni.cz (Postfix, from userid 512)
        id E468C803E2; Tue,  8 Oct 2019 11:45:39 +0200 (CEST)
Date:   Tue, 8 Oct 2019 11:45:54 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Joel Savitz <jsavitz@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 011/106] PCI: rpaphp: Avoid a
 sometimes-uninitialized warning
Message-ID: <20191008094554.GB608@amd>
References: <20191006171124.641144086@linuxfoundation.org>
 <20191006171129.951697403@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <20191006171129.951697403@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Nathan Chancellor <natechancellor@gmail.com>
>=20
> [ Upstream commit 0df3e42167caaf9f8c7b64de3da40a459979afe8 ]
>=20
> When building with -Wsometimes-uninitialized, clang warns:
>=20
> drivers/pci/hotplug/rpaphp_core.c:243:14: warning: variable 'fndit' is
> used uninitialized whenever 'for' loop exits because its condition is
> false [-Wsometimes-uninitialized]
>         for (j =3D 0; j < entries; j++) {
>                     ^~~~~~~~~~~
=2E..
> fndit is only used to gate a sprintf call, which can be moved into the
> loop to simplify the code and eliminate the local variable, which will
> fix this warning.

Well, you fixed the warning, but the code is still buggy:

> +++ b/drivers/pci/hotplug/rpaphp_core.c
> @@ -230,7 +230,7 @@ static int rpaphp_check_drc_props_v2(struct device_no=
de *dn, char *drc_name,
>  	struct of_drc_info drc;
>  	const __be32 *value;
>  	char cell_drc_name[MAX_DRC_NAME_LEN];
> -	int j, fndit;
> +	int j;
> =20
>  	info =3D of_find_property(dn->parent, "ibm,drc-info", NULL);
>  	if (info =3D=3D NULL)
> @@ -245,17 +245,13 @@ static int rpaphp_check_drc_props_v2(struct device_=
node *dn, char *drc_name,
> =20
>  		/* Should now know end of current entry */
> =20
> -		if (my_index > drc.last_drc_index)
> -			continue;
> -
> -		fndit =3D 1;
> -		break;
> +		/* Found it */
> +		if (my_index <=3D drc.last_drc_index) {
> +			sprintf(cell_drc_name, "%s%d", drc.drc_name_prefix,
> +				my_index);
> +			break;
> +		}
>  	}
> -	/* Found it */
> -
> -	if (fndit)
> -		sprintf(cell_drc_name, "%s%d", drc.drc_name_prefix,=20
> -			my_index);
> =20
>  	if (((drc_name =3D=3D NULL) ||
>  	     (drc_name && !strcmp(drc_name, cell_drc_name))) &&

In case we do not find it, cell_drc_name is not initialized, yet we
use it in strcmp(). Same bug exists in the mainline.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl2cWtIACgkQMOfwapXb+vLErgCfcqCv/v2ppCMwY/lzYyPR6qMH
ONkAni6v57Wf59ytP1Kv6o7X9zW8nf7Y
=3Dox
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
