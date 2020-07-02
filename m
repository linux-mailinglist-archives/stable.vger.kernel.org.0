Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231D0212E9F
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 23:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbgGBVRV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 17:17:21 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:41926 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725937AbgGBVRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jul 2020 17:17:20 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id B9B9E1C0BD2; Thu,  2 Jul 2020 23:17:18 +0200 (CEST)
Date:   Thu, 2 Jul 2020 23:17:17 +0200
From:   Pavel Machek <pavel@denx.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>,
        Changwei Ge <gechangwei@live.cn>, Gang He <ghe@suse.com>,
        Joel Becker <jlbec@evilplan.org>,
        Jun Piao <piaojun@huawei.com>, Mark Fasheh <mark@fasheh.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.19 114/131] ocfs2: avoid inode removal while nfsd is
 accessing it
Message-ID: <20200702211717.GC5787@amd>
References: <20200629153502.2494656-1-sashal@kernel.org>
 <20200629153502.2494656-115-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="E13BgyNx05feLLmH"
Content-Disposition: inline
In-Reply-To: <20200629153502.2494656-115-sashal@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--E13BgyNx05feLLmH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> commit 4cd9973f9ff69e37dd0ba2bd6e6423f8179c329a upstream.
>=20
> Patch series "ocfs2: fix nfsd over ocfs2 issues", v2.
>=20
> This is a series of patches to fix issues on nfsd over ocfs2.  patch 1
> is to avoid inode removed while nfsd access it patch 2 & 3 is to fix a
> panic issue.
>=20
> This patch (of 4):
>=20
> When nfsd is getting file dentry using handle or parent dentry of some
> dentry, one cluster lock is used to avoid inode removed from other node,
> but it still could be removed from local node, so use a rw lock to avoid
> this.

This causes locking imbalance:

> @@ -2851,6 +2857,11 @@ int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, i=
nt ex)
>  	if (ocfs2_is_hard_readonly(osb))
>  		return -EROFS;
> =20
> +	if (ex)
> +		down_write(&osb->nfs_sync_rwlock);
> +	else
> +		down_read(&osb->nfs_sync_rwlock);
> +
>  	if (ocfs2_mount_local(osb))
>  		return 0;
>
=2E..
        status =3D ocfs2_cluster_lock(osb, lockres, ex ? LKM_EXMODE :LKM_PR=
MODE,
		                            0, 0);
	...
	return status;
  }
=09

When ocfs2_nfs_sync_lock() returns error, caller can not know if the
lock was taken or not.

ocfs2_get_dentry() for example will not call ocfs2_nfs_sync_unlock()
if sync_lock() failed, resulting in lock imbalance if
ocfs2_cluster_lock() fails.

(Totally untested).

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

Best regards,
								Pavel

diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
index c141b06811a6..8149fb6f1f0d 100644
--- a/fs/ocfs2/dlmglue.c
+++ b/fs/ocfs2/dlmglue.c
@@ -2867,9 +2867,15 @@ int ocfs2_nfs_sync_lock(struct ocfs2_super *osb, int=
 ex)
=20
 	status =3D ocfs2_cluster_lock(osb, lockres, ex ? LKM_EXMODE : LKM_PRMODE,
 				    0, 0);
-	if (status < 0)
+	if (status < 0) {
 		mlog(ML_ERROR, "lock on nfs sync lock failed %d\n", status);
=20
+		if (ex)
+			up_write(&osb->nfs_sync_rwlock);
+		else
+			up_read(&osb->nfs_sync_rwlock);
+	}
+
 	return status;
 }
=20


Best regards,
								Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--E13BgyNx05feLLmH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl7+Tt0ACgkQMOfwapXb+vLHKQCglu8bO4mSJD84VWxD5b0FwUQr
XiEAoKfoGKNzQpQxO5wXIPTp0yT/IRZA
=BuAt
-----END PGP SIGNATURE-----

--E13BgyNx05feLLmH--
