Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC23241B23
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 14:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbgHKMqe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 08:46:34 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:39428 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbgHKMqe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 08:46:34 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id EAB7F1C0BD8; Tue, 11 Aug 2020 14:46:29 +0200 (CEST)
Date:   Tue, 11 Aug 2020 14:46:14 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Martyna Szapar <martyna.szapar@intel.com>,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: Re: [PATCH 4.19 47/48] i40e: Memory leak in i40e_config_iwarp_qvlist
Message-ID: <20200811124614.2myealhkhnla6v3a@duo.ucw.cz>
References: <20200810151804.199494191@linuxfoundation.org>
 <20200810151806.541597863@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="pkqhj7nvnn7tsqgk"
Content-Disposition: inline
In-Reply-To: <20200810151806.541597863@linuxfoundation.org>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--pkqhj7nvnn7tsqgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Martyna Szapar <martyna.szapar@intel.com>
>=20
> [ Upstream commit 0b63644602cfcbac849f7ea49272a39e90fa95eb ]
>=20
> Added freeing the old allocation of vf->qvlist_info in function
> i40e_config_iwarp_qvlist before overwriting it with
> the new allocation.

Ok, but this also other error paths:

> --- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
> @@ -449,16 +450,19 @@ static int i40e_config_iwarp_qvlist(stru
>  			 "Incorrect number of iwarp vectors %u. Maximum %u allowed.\n",
>  			 qvlist_info->num_vectors,
>  			 msix_vf);
> -		goto err;
> +		ret =3D -EINVAL;
> +		goto err_out;
>  	}

And it is no longer freeing data qvlist_info() in this path. Is that
correct? Should it goto err_free instead?=20

> @@ -512,10 +518,11 @@ static int i40e_config_iwarp_qvlist(stru
>  	}
> =20
>  	return 0;
> -err:
> +err_free:
>  	kfree(vf->qvlist_info);
>  	vf->qvlist_info =3D NULL;
> -	return -EINVAL;
> +err_out:
> +	return ret;
>  }

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--pkqhj7nvnn7tsqgk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EARECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXzKTFgAKCRAw5/Bqldv6
8nD1AJ9hp8KEZX9mmHBxiUCrpm+Gq6mugACfR7ihn9zGN+1XhiI1cZej7g1gahQ=
=eSCO
-----END PGP SIGNATURE-----

--pkqhj7nvnn7tsqgk--
