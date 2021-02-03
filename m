Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6322430E459
	for <lists+stable@lfdr.de>; Wed,  3 Feb 2021 21:56:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232270AbhBCUym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Feb 2021 15:54:42 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:45228 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbhBCUnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Feb 2021 15:43:35 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 5EB8E1C0BB5; Wed,  3 Feb 2021 21:42:43 +0100 (CET)
Date:   Wed, 3 Feb 2021 21:42:42 +0100
From:   Pavel Machek <pavel@ucw.cz>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 26/37] iwlwifi: pcie: use jiffies for memory read
 spin time limit
Message-ID: <20210203204242.GA24414@amd>
References: <20210202132942.915040339@linuxfoundation.org>
 <20210202132944.017286490@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="VbJkn9YxBvnuCH5J"
Content-Disposition: inline
In-Reply-To: <20210202132944.017286490@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--VbJkn9YxBvnuCH5J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Johannes Berg <johannes.berg@intel.com>
>=20
> [ Upstream commit 6701317476bbfb1f341aa935ddf75eb73af784f9 ]
>=20
> There's no reason to use ktime_get() since we don't need any better
> precision than jiffies, and since we no longer disable interrupts
> around this code (when grabbing NIC access), jiffies will work fine.
> Use jiffies instead of ktime_get().
>=20
> This cleanup is preparation for the following patch "iwlwifi: pcie: resch=
edule
> in long-running memory reads". The code gets simpler with the weird clock=
 use
> etc. removed before we add cond_resched().

As far as I can tell, this is not really suitable for v4.19 (and
probably others), as we still disable interrupts in
iwl_trans_pcie_release_nic_access() in 4.19.

Best regards,
								Pavel
							=09

> @@ -2137,11 +2137,7 @@ static int iwl_trans_pcie_read_mem(struct iwl_tran=
s *trans, u32 addr,
>  							HBUS_TARG_MEM_RDAT);
>  				offs++;
> =20
> -				/* calling ktime_get is expensive so
> -				 * do it once in 128 reads
> -				 */
> -				if (offs % 128 =3D=3D 0 && ktime_after(ktime_get(),
> -								   timeout))
> +				if (time_after(jiffies, end))
>  					break;
>  			}
>  			iwl_trans_release_nic_access(trans, &flags);

--=20
http://www.livejournal.com/~pavelmachek

--VbJkn9YxBvnuCH5J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAmAbCsIACgkQMOfwapXb+vJBGwCgjj0uxL8he8JnE/msgPpsdfyL
i/4AoJOPyzKvvdi3J6cLAZljsFB/TdlF
=FCKz
-----END PGP SIGNATURE-----

--VbJkn9YxBvnuCH5J--
