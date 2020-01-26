Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E361149A6C
	for <lists+stable@lfdr.de>; Sun, 26 Jan 2020 12:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgAZLgT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jan 2020 06:36:19 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:52142 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728689AbgAZLgT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jan 2020 06:36:19 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 68FEA1C2103; Sun, 26 Jan 2020 12:36:17 +0100 (CET)
Date:   Sun, 26 Jan 2020 12:36:16 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 540/639] wcn36xx: use dynamic allocation for large
 variables
Message-ID: <20200126113616.GB19082@duo.ucw.cz>
References: <20200124093047.008739095@linuxfoundation.org>
 <20200124093156.657476612@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
In-Reply-To: <20200124093156.657476612@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Arnd Bergmann <arnd@arndb.de>
>=20
> [ Upstream commit 355cf31912014e6ff1bb1019ae4858cad12c68cf ]
>=20
> clang triggers a warning about oversized stack frames that gcc does not
> notice because of slightly different inlining decisions:
>=20
> ath/wcn36xx/smd.c:1409:5: error: stack frame size of 1040 bytes in functi=
on 'wcn36xx_smd_config_bss' [-Werror,-Wframe-larger-than=3D]
> ath/wcn36xx/smd.c:640:5: error: stack frame size of 1032 bytes in functio=
n 'wcn36xx_smd_start_hw_scan' [-Werror,-Wframe-larger-than=3D]
>=20
> Basically the wcn36xx_hal_start_scan_offload_req_msg,
> wcn36xx_hal_config_bss_req_msg_v1, and wcn36xx_hal_config_bss_req_msg
> structures are too large to be put on the kernel stack, but small
> enough that gcc does not warn about them.
>=20
> Use kzalloc() to allocate them all. There are similar structures in other
> parts of this driver, but they are all smaller, with the next largest
> stack frame at 480 bytes for wcn36xx_smd_send_beacon.

>  	int ret, i;
> =20
>  	if (req->ie_len > WCN36XX_MAX_SCAN_IE_LEN)
>  		return -EINVAL;
> =20
>  	mutex_lock(&wcn->hal_mutex);
> -	INIT_HAL_MSG(msg_body, WCN36XX_HAL_START_SCAN_OFFLOAD_REQ);
> +	msg_body =3D kzalloc(sizeof(*msg_body), GFP_KERNEL);
> +	if (!msg_body) {
> +		ret =3D -ENOMEM;
> +		goto out;
> +	}

The allocation can be done outside the lock.

> @@ -1410,16 +1428,21 @@ int wcn36xx_smd_config_bss(struct wcn36xx *wcn, s=
truct ieee80211_vif *vif,
>  			   struct ieee80211_sta *sta, const u8 *bssid,
>  			   bool update)
>  {
> -	struct wcn36xx_hal_config_bss_req_msg msg;
> +	struct wcn36xx_hal_config_bss_req_msg *msg;
>  	struct wcn36xx_hal_config_bss_params *bss;
>  	struct wcn36xx_hal_config_sta_params *sta_params;
>  	struct wcn36xx_vif *vif_priv =3D wcn36xx_vif_to_priv(vif);
>  	int ret;
> =20
>  	mutex_lock(&wcn->hal_mutex);
> -	INIT_HAL_MSG(msg, WCN36XX_HAL_CONFIG_BSS_REQ);
> +	msg =3D kzalloc(sizeof(*msg), GFP_KERNEL);
> +	if (!msg) {
> +		ret =3D -ENOMEM;
> +		goto out;
> +	}
> +	INIT_HAL_MSG((*msg), WCN36XX_HAL_CONFIG_BSS_REQ);

Same here.

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXi15sAAKCRAw5/Bqldv6
8jrlAJ96jj/ngctVdO0FcxlO4LRn9I1GRwCgsrfJ9BdWXm1gqcF4PqOnk5kpq2U=
=wSzG
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
