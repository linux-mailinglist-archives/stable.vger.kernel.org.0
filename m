Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7811A39706E
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 11:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233336AbhFAJdI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 05:33:08 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45654 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233573AbhFAJdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 05:33:07 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F0F4D1C0B7C; Tue,  1 Jun 2021 11:31:25 +0200 (CEST)
Date:   Tue, 1 Jun 2021 11:31:25 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 5.10 030/252] mac80211: prevent attacks on TKIP/WEP as
 well
Message-ID: <20210601093125.GA30646@amd>
References: <20210531130657.971257589@linuxfoundation.org>
 <20210531130659.005193399@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20210531130659.005193399@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

So this changes bool variables to u8:1, but still assigns true/false
there, which looks like "interesting" style. Should we switch to 0/1?

Best regards,
								Pavel

> --- a/net/mac80211/rx.c
> +++ b/net/mac80211/rx.c
> @@ -2284,6 +2284,7 @@ ieee80211_rx_h_defragment(struct ieee802
>  			 * next fragment has a sequential PN value.
>  			 */
>  			entry->check_sequential_pn =3D true;
> +			entry->is_protected =3D true;
>  			entry->key_color =3D rx->key->color;
>  			memcpy(entry->last_pn,
>  			       rx->key->u.ccmp.rx_pn[queue],
> @@ -2296,6 +2297,9 @@ ieee80211_rx_h_defragment(struct ieee802
>  				     sizeof(rx->key->u.gcmp.rx_pn[queue]));
>  			BUILD_BUG_ON(IEEE80211_CCMP_PN_LEN !=3D
>  				     IEEE80211_GCMP_PN_LEN);
> +		} else if (rx->key && ieee80211_has_protected(fc)) {
> +			entry->is_protected =3D true;
> +			entry->key_color =3D rx->key->color;
>  		}
>  		return RX_QUEUED;
>  	}
> @@ -2337,6 +2341,14 @@ ieee80211_rx_h_defragment(struct ieee802
>  		if (memcmp(pn, rpn, IEEE80211_CCMP_PN_LEN))
>  			return RX_DROP_UNUSABLE;
>  		memcpy(entry->last_pn, pn, IEEE80211_CCMP_PN_LEN);
> +	} else if (entry->is_protected &&
> +		   (!rx->key || !ieee80211_has_protected(fc) ||
> +		    rx->key->color !=3D entry->key_color)) {
> +		/* Drop this as a mixed key or fragment cache attack, even
> +		 * if for TKIP Michael MIC should protect us, and WEP is a
> +		 * lost cause anyway.
> +		 */
> +		return RX_DROP_UNUSABLE;
>  	}
> =20
>  	skb_pull(rx->skb, ieee80211_hdrlen(fc));
> --- a/net/mac80211/sta_info.h
> +++ b/net/mac80211/sta_info.h
> @@ -453,7 +453,8 @@ struct ieee80211_fragment_entry {
>  	u16 extra_len;
>  	u16 last_frag;
>  	u8 rx_queue;
> -	bool check_sequential_pn; /* needed for CCMP/GCMP */
> +	u8 check_sequential_pn:1, /* needed for CCMP/GCMP */
> +	   is_protected:1;
>  	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
>  	unsigned int key_color;
>  };
>=20

--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmC1/m0ACgkQMOfwapXb+vIl4QCeMJ0/Km/hKFlB00POoK8ZQTUB
O1YAn1kfj4yM4Bw5QNvf3wkgAkSTrSYU
=qtqE
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
