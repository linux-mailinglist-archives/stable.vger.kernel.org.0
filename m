Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F9324463FA
	for <lists+stable@lfdr.de>; Fri,  5 Nov 2021 14:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhKENVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Nov 2021 09:21:33 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:46342 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbhKENV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 5 Nov 2021 09:21:29 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 29D0D1C0BAC; Fri,  5 Nov 2021 14:18:49 +0100 (CET)
Date:   Fri, 5 Nov 2021 14:18:48 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bryan ODonoghue <bryan.odonoghue@linaro.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 5.10 14/16] Revert "wcn36xx: Disable bmps when encryption
 is disabled"
Message-ID: <20211105131848.GA9566@amd>
References: <20211104141159.561284732@linuxfoundation.org>
 <20211104141200.061783376@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
In-Reply-To: <20211104141200.061783376@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>=20
> commit 285bb1738e196507bf985574d0bc1e9dd72d46b1 upstream.
>=20
> This reverts commit c6522a5076e1a65877c51cfee313a74ef61cabf8.
>=20
> Testing on tip-of-tree shows that this is working now. Revert this and
> re-enable BMPS for Open APs.

This explains why revert is a good idea for mainline, but it may still
cause problems for 5.10. Is someone able to test it in 5.10?

Best regards,
								Pavel
							=09
> +++ b/drivers/net/wireless/ath/wcn36xx/main.c
> @@ -601,15 +601,6 @@ static int wcn36xx_set_key(struct ieee80
>  				}
>  			}
>  		}
> -		/* FIXME: Only enable bmps support when encryption is enabled.
> -		 * For any reasons, when connected to open/no-security BSS,
> -		 * the wcn36xx controller in bmps mode does not forward
> -		 * 'wake-up' beacons despite AP sends DTIM with station AID.
> -		 * It could be due to a firmware issue or to the way driver
> -		 * configure the station.
> -		 */
> -		if (vif->type =3D=3D NL80211_IFTYPE_STATION)
> -			vif_priv->allow_bmps =3D true;
>  		break;
>  	case DISABLE_KEY:
>  		if (!(IEEE80211_KEY_FLAG_PAIRWISE & key_conf->flags)) {
> @@ -909,7 +900,6 @@ static void wcn36xx_bss_info_changed(str
>  				    vif->addr,
>  				    bss_conf->aid);
>  			vif_priv->sta_assoc =3D false;
> -			vif_priv->allow_bmps =3D false;
>  			wcn36xx_smd_set_link_st(wcn,
>  						bss_conf->bssid,
>  						vif->addr,
> --- a/drivers/net/wireless/ath/wcn36xx/pmc.c
> +++ b/drivers/net/wireless/ath/wcn36xx/pmc.c
> @@ -23,10 +23,7 @@ int wcn36xx_pmc_enter_bmps_state(struct
>  {
>  	int ret =3D 0;
>  	struct wcn36xx_vif *vif_priv =3D wcn36xx_vif_to_priv(vif);
> -
> -	if (!vif_priv->allow_bmps)
> -		return -ENOTSUPP;
> -
> +	/* TODO: Make sure the TX chain clean */
>  	ret =3D wcn36xx_smd_enter_bmps(wcn, vif);
>  	if (!ret) {
>  		wcn36xx_dbg(WCN36XX_DBG_PMC, "Entered BMPS\n");
> --- a/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
> +++ b/drivers/net/wireless/ath/wcn36xx/wcn36xx.h
> @@ -127,7 +127,6 @@ struct wcn36xx_vif {
>  	enum wcn36xx_hal_bss_type bss_type;
> =20
>  	/* Power management */
> -	bool allow_bmps;
>  	enum wcn36xx_power_state pw_state;
> =20
>  	u8 bss_index;
>=20

--=20
http://www.livejournal.com/~pavelmachek

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmGFLzcACgkQMOfwapXb+vIvSgCfWEGScZvpLBIVFnE6MdChrXrX
9kcAnRkUNyebee7rJ3rFsNj9P7DD4Ahd
=iub4
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
