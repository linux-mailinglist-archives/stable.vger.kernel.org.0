Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB3771E9A80
	for <lists+stable@lfdr.de>; Sun, 31 May 2020 23:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728342AbgEaVXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 31 May 2020 17:23:00 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:48784 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727000AbgEaVXA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 31 May 2020 17:23:00 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id F0CF31C0BD2; Sun, 31 May 2020 23:22:58 +0200 (CEST)
Date:   Sun, 31 May 2020 23:22:58 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        cluster-devel@redhat.com
Subject: Re: [PATCH AUTOSEL 4.19 10/19] gfs2: don't call quota_unhold if
 quotas are not locked
Message-ID: <20200531212258.GA9004@amd>
References: <20200522145120.434921-1-sashal@kernel.org>
 <20200522145120.434921-10-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
In-Reply-To: <20200522145120.434921-10-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit c9cb9e381985bbbe8acd2695bbe6bd24bf06b81c ]
>=20
> Before this patch, function gfs2_quota_unlock checked if quotas are
> turned off, and if so, it branched to label out, which called
> gfs2_quota_unhold. With the new system of gfs2_qa_get and put, we
> no longer want to call gfs2_quota_unhold or we won't balance our
> gets and puts.

4.19 does not yet contain gfw2_qa_get; according to the changelog that
means that this patch is not suitable for 4.19 kernel.

Best regards,
								Pavel
							=09
> index dd0f9bc13164..ce47c8233612 100644
> --- a/fs/gfs2/quota.c
> +++ b/fs/gfs2/quota.c
> @@ -1116,7 +1116,7 @@ void gfs2_quota_unlock(struct gfs2_inode *ip)
>  	int found;
> =20
>  	if (!test_and_clear_bit(GIF_QD_LOCKED, &ip->i_flags))
> -		goto out;
> +		return;
> =20
>  	for (x =3D 0; x < ip->i_qadata->qa_qd_num; x++) {
>  		struct gfs2_quota_data *qd;
> @@ -1153,7 +1153,6 @@ void gfs2_quota_unlock(struct gfs2_inode *ip)
>  			qd_unlock(qda[x]);
>  	}
> =20
> -out:
>  	gfs2_quota_unhold(ip);
>  }
> =20

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--5vNYLRcllDrimb99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7UIDIACgkQMOfwapXb+vJu0wCgjsov0xQd93uDe72Sr3YqhVNv
EPgAniLulgMO2BTGivnJWdmZeVqcclxO
=TKQj
-----END PGP SIGNATURE-----

--5vNYLRcllDrimb99--
