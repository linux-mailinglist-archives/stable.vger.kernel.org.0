Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B731EB0B5
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 23:09:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbgFAVJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 17:09:08 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:58236 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727875AbgFAVJH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jun 2020 17:09:07 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 1471F1C0BD2; Mon,  1 Jun 2020 23:09:06 +0200 (CEST)
Date:   Mon, 1 Jun 2020 23:09:05 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Linus =?iso-8859-1?Q?L=FCssing?= <ll@simonwunderlich.de>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH 4.19 72/95] mac80211: mesh: fix discovery timer re-arming
 issue / crash
Message-ID: <20200601210905.GC17898@amd>
References: <20200601174020.759151073@linuxfoundation.org>
 <20200601174032.067230223@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="96YOpH+ONegL0A3E"
Content-Disposition: inline
In-Reply-To: <20200601174032.067230223@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--96YOpH+ONegL0A3E
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Linus L=FCssing <ll@simonwunderlich.de>
>=20
> commit e2d4a80f93fcfaf72e2e20daf6a28e39c3b90677 upstream.

> This patch fixes this issue by re-checking if mpath is about to be
> free'd and if so bails out of re-arming the timer.

> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -1088,7 +1088,14 @@ void mesh_path_start_discovery(struct ie
>  	mesh_path_sel_frame_tx(MPATH_PREQ, 0, sdata->vif.addr, ifmsh->sn,
>  			       target_flags, mpath->dst, mpath->sn, da, 0,
>  			       ttl, lifetime, 0, ifmsh->preq_id++, sdata);
> +
> +	spin_lock_bh(&mpath->state_lock);
> +	if (mpath->flags & MESH_PATH_DELETED) {
> +		spin_unlock_bh(&mpath->state_lock);
> +		goto enddiscovery;
> +	}
>  	mod_timer(&mpath->timer, jiffies + mpath->discovery_timeout);
> +	spin_unlock_bh(&mpath->state_lock);
> =20
>  enddiscovery:
>  	rcu_read_unlock();

This made brain freeze for a while. AFAICT it can be rewritten as:

 +     spin_lock_bh(&mpath->state_lock);
 +     if (!(mpath->flags & MESH_PATH_DELETED))
  	       mod_timer(&mpath->timer, jiffies + mpath->discovery_timeout);
 +     spin_unlock_bh(&mpath->state_lock);

=2E..?

Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--96YOpH+ONegL0A3E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7VbnEACgkQMOfwapXb+vLRNACdEKKxeCtjWzveafWjSWO0iu+a
1l8AnAuQDNh+vyOPRNlyKOZrBdH9VKbB
=FqG9
-----END PGP SIGNATURE-----

--96YOpH+ONegL0A3E--
