Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D164A397051
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 11:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhFAJ2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 05:28:02 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:45040 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbhFAJ2C (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 05:28:02 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5D9881C0B76; Tue,  1 Jun 2021 11:26:20 +0200 (CEST)
Date:   Tue, 1 Jun 2021 11:26:19 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 5.10 024/252] mac80211: prevent mixed key and fragment
 cache attacks
Message-ID: <20210601092619.GA30422@amd>
References: <20210531130657.971257589@linuxfoundation.org>
 <20210531130658.804599277@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20210531130658.804599277@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
>=20
> commit 94034c40ab4a3fcf581fbc7f8fdf4e29943c4a24 upstream.
>=20
> Simultaneously prevent mixed key attacks (CVE-2020-24587) and fragment
> cache attacks (CVE-2020-24586). This is accomplished by assigning a
> unique color to every key (per interface) and using this to track which
> key was used to decrypt a fragment. When reassembling frames, it is
> now checked whether all fragments were decrypted using the same key.
>=20
> To assure that fragment cache attacks are also prevented, the ID that is
> assigned to keys is unique even over (re)associations and (re)connects.
> This means fragments separated by a (re)association or (re)connect will
> not be reassembled. Because mac80211 now also prevents the reassembly of
> mixed encrypted and plaintext fragments, all cache attacks are
> prevented.

> --- a/net/mac80211/key.c
> +++ b/net/mac80211/key.c
> @@ -799,6 +799,7 @@ int ieee80211_key_link(struct ieee80211_
>  		       struct ieee80211_sub_if_data *sdata,
>  		       struct sta_info *sta)
>  {
> +	static atomic_t key_color =3D ATOMIC_INIT(0);
>  	struct ieee80211_key *old_key;

This is nice and simple, but does not include any kind of overflow
handling. sparc32 moved away from 24-bit atomics, which is good I
guess. OTOH if this is incremented 10 times a second, we'll still
overflow in 6 years or so. Can attacker make it overflow?

Should this have a note why overflow is not possible / why it is not a
problem?

Best regards,
								Pavel

--=20
http://www.livejournal.com/~pavelmachek

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmC1/TsACgkQMOfwapXb+vKafACeK7LHyqgR/LXzCJStHK/t9FPn
lJwAn0zBUrv5N044KgDaC9cHseCAyo4x
=yXDY
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
