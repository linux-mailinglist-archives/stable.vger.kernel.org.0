Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B70121FCC
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727427AbfLQAcW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:32:22 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34370 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726556AbfLQAcW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:32:22 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih0mi-0002Js-MY; Tue, 17 Dec 2019 00:32:20 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih0mi-00028Z-8u; Tue, 17 Dec 2019 00:32:20 +0000
Message-ID: <3c22055318a71ff372fcc4864e865e8dfa878779.camel@decadent.org.uk>
Subject: Re: [PATCH stable 3.16] rtlwifi: Fix potential overflow on P2P code
From:   Ben Hutchings <ben@decadent.org.uk>
To:     pkshih@realtek.com, stable@vger.kernel.org
Cc:     linux-wireless@vger.kernel.org
Date:   Tue, 17 Dec 2019 00:32:19 +0000
In-Reply-To: <20191105060858.6306-1-pkshih@realtek.com>
References: <20191105060858.6306-1-pkshih@realtek.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-KPY8TOYuomOyN1GFRbm7"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-KPY8TOYuomOyN1GFRbm7
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-11-05 at 14:08 +0800, pkshih@realtek.com wrote:
> From: Laura Abbott <labbott@redhat.com>
>=20
> commit 8c55dedb795be8ec0cf488f98c03a1c2176f7fb1 upstream.
>=20
> Nicolas Waisman noticed that even though noa_len is checked for
> a compatible length it's still possible to overrun the buffers
> of p2pinfo since there's no check on the upper bound of noa_num.
> Bound noa_num against P2P_MAX_NOA_NUM.
>=20
> Reported-by: Nicolas Waisman <nico@semmle.com>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> ---
> This fix is applied to most of stable kernel excepting to 3.16 due to
> directory change on kernel 4.4. So, I compose this patch with old directo=
ry
> for stable kernel 3.16.

Thanks for this.  I actually got round to backporting this myself
before seeing your mail, so this ended up 3.16.77.

Ben.

> ---
>  drivers/net/wireless/rtlwifi/ps.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/drivers/net/wireless/rtlwifi/ps.c b/drivers/net/wireless/rtl=
wifi/ps.c
> index 50504942ded1..bfe097b224ad 100644
> --- a/drivers/net/wireless/rtlwifi/ps.c
> +++ b/drivers/net/wireless/rtlwifi/ps.c
> @@ -801,6 +801,9 @@ static void rtl_p2p_noa_ie(struct ieee80211_hw *hw, v=
oid *data,
>  				return;
>  			} else {
>  				noa_num =3D (noa_len - 2) / 13;
> +				if (noa_num > P2P_MAX_NOA_NUM)
> +					noa_num =3D P2P_MAX_NOA_NUM;
> +
>  			}
>  			noa_index =3D ie[3];
>  			if (rtlpriv->psc.p2p_ps_info.p2p_ps_mode =3D=3D
> @@ -895,6 +898,9 @@ static void rtl_p2p_action_ie(struct ieee80211_hw *hw=
, void *data,
>  				return;
>  			} else {
>  				noa_num =3D (noa_len - 2) / 13;
> +				if (noa_num > P2P_MAX_NOA_NUM)
> +					noa_num =3D P2P_MAX_NOA_NUM;
> +
>  			}
>  			noa_index =3D ie[3];
>  			if (rtlpriv->psc.p2p_ps_info.p2p_ps_mode =3D=3D
--=20
Ben Hutchings
If the facts do not conform to your theory, they must be disposed of.


--=-KPY8TOYuomOyN1GFRbm7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl34IhQACgkQ57/I7JWG
EQlZWQ/9GWOW+zR7vLtydjIKhhuEWniEpAXk/0jLlCphusV7q0grVdSqA+rfGW7g
5+c1Ntobmz3WrDEP/XatpsuqhHj6SU7KAnfDyJsCILOMPpYBaAf0sCPry/z+Aiy9
LkYNpgj370CXdf7XZMihJ7CzozPIXYEmY+zBmVZZUPIMBEzY+VTUcyr2GKixkmqR
zbi7pGC1aS9I1VcPrn4IJGxC1zSHAVXadyf+FETzDGgB9qcZcvV3aV0JXRtUeLk0
dWH0UpP2Jd9TNq/Vi4P/EojUix9gZvtzbE12AXjXVEnSVIWiVkT2kLuH400+FeQX
7nBJu8N5IP/iPa0gd5okYg/zHJa3p7AO3/11E3LZzZ30iEwHF9ETBRiOCPvdL90D
M93OXuh/VERq+UMXqYX3LoFuiI/FiHs7NC41xNePvFwBvS1XAxcfP9UaN63/HnT8
Op07gNF7kdnL0iomunNrhjkiqEGOa3r2VPGhdKg6nD9z8Pft7Cn5W6jfzerGMPG9
953MBURp6Vj0761PpVKCDY31YcQIcs441OcTiCtcSgU6F4F4jGf/8LRrjaGk0YOa
2ciTBJt6rvFH6Qa7pxjopd+ntL/bNFEhja+5eUNhlIwPV+nGzoiDnz49ldDmYUYP
QCgStgzc8YwHZxudmn5vzbIqrwc29wjVsTp++yYijl8kWecv/5w=
=G3u7
-----END PGP SIGNATURE-----

--=-KPY8TOYuomOyN1GFRbm7--
