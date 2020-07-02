Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BF6212EA6
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 23:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgGBVRr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 17:17:47 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:42002 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgGBVRr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 17:17:47 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id D85461C0C0F; Thu,  2 Jul 2020 23:17:44 +0200 (CEST)
Date:   Thu, 2 Jul 2020 23:17:43 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sagi Grimberg <sagi@grimberg.me>,
        Anton Eidelman <anton@lightbitslabs.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 4.19 082/131] nvme: fix possible deadlock when I/O is
 blocked
Message-ID: <20200702211743.GE5787@amd>
References: <20200629153502.2494656-1-sashal@kernel.org>
 <20200629153502.2494656-83-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="TD8GDToEDw0WLGOL"
Content-Disposition: inline
In-Reply-To: <20200629153502.2494656-83-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--TD8GDToEDw0WLGOL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Sagi Grimberg <sagi@grimberg.me>
>=20
> [ Upstream commit 3b4b19721ec652ad2c4fe51dfbe5124212b5f581 ]
>=20
> Revert fab7772bfbcf ("nvme-multipath: revalidate nvme_ns_head gendisk
> in nvme_validate_ns")
>=20
> When adding a new namespace to the head disk (via nvme_mpath_set_live)
> we will see partition scan which triggers I/O on the mpath device node.
> This process will usually be triggered from the scan_work which holds
> the scan_lock. If I/O blocks (if we got ana change currently have only
> available paths but none are accessible) this can deadlock on the head
> disk bd_mutex as both partition scan I/O takes it, and head disk revalida=
tion
> takes it to check for resize (also triggered from scan_work on a different
> path). See trace [1].
>=20
> The mpath disk revalidation was originally added to detect online disk
> size change, but this is no longer needed since commit cb224c3af4df
> ("nvme: Convert to use set_capacity_revalidate_and_notify") which already
> updates resize info without unnecessarily revalidating the disk (the

Unfortunately, v4.19-stable does not contain cb224c3af4df. According
to changelog, it seems it should be cherry-picked?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--TD8GDToEDw0WLGOL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7+TvcACgkQMOfwapXb+vLCDQCdHgUqVmHHOrxKOFDl+TEPiuA5
qagAoJdaX1u8zSmok2ri4m3VAnjJveuO
=UhDj
-----END PGP SIGNATURE-----

--TD8GDToEDw0WLGOL--
