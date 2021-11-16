Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59F0C453199
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 13:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235736AbhKPMCO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 07:02:14 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:57084 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235623AbhKPMCL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 07:02:11 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 8D55E1C0BA2; Tue, 16 Nov 2021 12:59:13 +0100 (CET)
Date:   Tue, 16 Nov 2021 12:59:12 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Alagu Sankar <alagusankar@silex-india.com>,
        Erik Stromdahl <erik.stromdahl@gmail.com>,
        Fabio Estevam <festevam@denx.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 187/575] ath10k: high latency fixes for beacon buffer
Message-ID: <20211116115912.GA24443@amd>
References: <20211115165343.579890274@linuxfoundation.org>
 <20211115165350.173331894@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <20211115165350.173331894@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Alagu Sankar <alagusankar@silex-india.com>
>=20
> [ Upstream commit e263bdab9c0e8025fb7f41f153709a9cda51f6b6 ]
>=20
> Beacon buffer for high latency devices does not use DMA. other similar
> buffer allocation methods in the driver have already been modified for
> high latency path. Fix the beacon buffer allocation left out in the
> earlier high latency changes.

There's GFP_KERNEL vs. GFP_ATOMIC confusion here:

> @@ -5466,10 +5470,17 @@ static int ath10k_add_interface(struct ieee80211_=
hw *hw,
>  	if (vif->type =3D=3D NL80211_IFTYPE_ADHOC ||
>  	    vif->type =3D=3D NL80211_IFTYPE_MESH_POINT ||
>  	    vif->type =3D=3D NL80211_IFTYPE_AP) {
> -		arvif->beacon_buf =3D dma_alloc_coherent(ar->dev,
> -						       IEEE80211_MAX_FRAME_LEN,
> -						       &arvif->beacon_paddr,
> -						       GFP_ATOMIC);
> +		if (ar->bus_param.dev_type =3D=3D ATH10K_DEV_TYPE_HL) {
> +			arvif->beacon_buf =3D kmalloc(IEEE80211_MAX_FRAME_LEN,
> +						    GFP_KERNEL);
> +			arvif->beacon_paddr =3D (dma_addr_t)arvif->beacon_buf;
> +		} else {
> +			arvif->beacon_buf =3D
> +				dma_alloc_coherent(ar->dev,
> +						   IEEE80211_MAX_FRAME_LEN,
> +						   &arvif->beacon_paddr,
> +						   GFP_ATOMIC);
> +		}
>  		if (!arvif->beacon_buf) {
>  			ret =3D -ENOMEM;
>  			ath10k_warn(ar, "failed to allocate beacon
>  	buffer: %d\n",

I'd expect both allocations to use same GFP_ flags.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEUEARECAAYFAmGTnRAACgkQMOfwapXb+vLjLgCfQipfkKHQFgW+4mRTmd/TPkV1
XRYAmKggzhcpRiX0C19G7ZOnL3iTgWM=
=EftE
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
