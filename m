Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D521112ACA
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 12:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727445AbfLDL40 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 06:56:26 -0500
Received: from jabberwock.ucw.cz ([46.255.230.98]:50226 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727268AbfLDL40 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Dec 2019 06:56:26 -0500
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id CC4261C2462; Wed,  4 Dec 2019 12:56:23 +0100 (CET)
Date:   Wed, 4 Dec 2019 12:56:23 +0100
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ahmed Zaki <anzaki@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 044/321] mac80211: fix station inactive_time shortly
 after boot
Message-ID: <20191204115623.GA25176@duo.ucw.cz>
References: <20191203223427.103571230@linuxfoundation.org>
 <20191203223429.401517191@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20191203223429.401517191@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2019-12-03 23:31:50, Greg Kroah-Hartman wrote:
> From: Ahmed Zaki <anzaki@gmail.com>
>=20
> [ Upstream commit 285531f9e6774e3be71da6673d475ff1a088d675 ]
>=20
> In the first 5 minutes after boot (time of INITIAL_JIFFIES),
> ieee80211_sta_last_active() returns zero if last_ack is zero. This
> leads to "inactive time" showing jiffies_to_msecs(jiffies).
>=20
>  # iw wlan0 station get fc:ec:da:64:a6:dd
>  Station fc:ec:da:64:a6:dd (on wlan0)
> 	inactive time:	4294894049 ms
> 	.
> 	.
> 	connected time:	70 seconds
>=20
> Fix by returning last_rx if last_ack =3D=3D 0.

I guess it fixes the message, but is it right fix?

> diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
> index f34202242d24d..507409e3fd39c 100644
> --- a/net/mac80211/sta_info.c
> +++ b/net/mac80211/sta_info.c
> @@ -2356,7 +2356,8 @@ unsigned long ieee80211_sta_last_active(struct sta_=
info *sta)
>  {
>  	struct ieee80211_sta_rx_stats *stats =3D sta_get_last_rx_stats(sta);
> =20
> -	if (time_after(stats->last_rx, sta->status_stats.last_ack))
> +	if (!sta->status_stats.last_ack ||
> +	    time_after(stats->last_rx, sta->status_stats.last_ack))
>  		return stats->last_rx;
>  	return sta->status_stats.last_ack;
>  }

I mean, jiffies do wrapraound periodically, so eventually we'll have
sta->status_stats.last_ack =3D=3D 0 even through it is not short after
boot, no?

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCXeee5wAKCRAw5/Bqldv6
8mVbAKCkAZf8HJ79qfd54n1ch2WztEMILACgv+jqioCPEnTJexWPWb5L/nE+2Sg=
=fzGi
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
