Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEA543D6919
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 23:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbhGZVRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 17:17:18 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:35418 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbhGZVRS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 17:17:18 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 397D91C0B76; Mon, 26 Jul 2021 23:57:45 +0200 (CEST)
Date:   Mon, 26 Jul 2021 23:57:44 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
        Grzegorz Siwik <grzegorz.siwik@intel.com>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Slawomir Laba <slawomirx.laba@intel.com>,
        Sylwester Dziedziuch <sylwesterx.dziedziuch@intel.com>,
        Mateusz Palczewski <mateusz.placzewski@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.4 19/47] igb: Check if num of q_vectors is smaller than
 max before array access
Message-ID: <20210726215744.GA4797@amd>
References: <20210726153822.980271128@linuxfoundation.org>
 <20210726153823.586319573@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20210726153823.586319573@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit 6c19d772618fea40d9681f259368f284a330fd90 ]
>=20
> Ensure that the adapter->q_vector[MAX_Q_VECTORS] array isn't accessed
> beyond its size. It was fixed by using a local variable num_q_vectors
> as a limit for loop index, and ensure that num_q_vectors is not bigger
> than MAX_Q_VECTORS.

Ok, so this is interesting design.

> +++ b/drivers/net/ethernet/intel/igb/igb_main.c
> @@ -945,6 +945,7 @@ static void igb_configure_msix(struct igb_adapter *ad=
apter)
>   **/
>  static int igb_request_msix(struct igb_adapter *adapter)
>  {
> +	unsigned int num_q_vectors =3D adapter->num_q_vectors;
>  	struct net_device *netdev =3D adapter->netdev;
>  	int i, err =3D 0, vector =3D 0, free_vector =3D 0;
> =20
> @@ -953,7 +954,13 @@ static int igb_request_msix(struct igb_adapter *adap=
ter)
>  	if (err)
>  		goto err_out;
> =20
> -	for (i =3D 0; i < adapter->num_q_vectors; i++) {
> +	if (num_q_vectors > MAX_Q_VECTORS) {
> +		num_q_vectors =3D MAX_Q_VECTORS;
> +		dev_warn(&adapter->pdev->dev,
> +			 "The number of queue vectors (%d) is higher than max allowed (%d)\n",
> +			 adapter->num_q_vectors, MAX_Q_VECTORS);
> +	}
> +	for (i =3D 0; i < num_q_vectors; i++) {
>  		struct igb_q_vector *q_vector =3D adapter->q_vector[i];
> =20
>  		vector++;

We limit num_q_vectors here, but too big value remains in
adapter->num_q_vectors. Loop in igb_request_msix is fixed, but there's
similar loop in igb_configure_msix() and in igb_free_irq() and
igp_up() and ...

Either adapter->num_q_vectors should be limited, or all those places
need fixing, no?

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmD/L9gACgkQMOfwapXb+vKXfACfUNEzAb93WuO1t8r15I4ZwC3K
SmQAoL7uA0gv2GaEENqwmT7lg9sM2Ywk
=WIym
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
