Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 146FD10BDE
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 19:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726088AbfEARQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 13:16:53 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:46534 "EHLO tmailer.gwdg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfEARQx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 May 2019 13:16:53 -0400
X-Greylist: delayed 1036 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 May 2019 13:16:51 EDT
Received: from mailgw.tuebingen.mpg.de ([192.124.27.5] helo=tuebingen.mpg.de)
        by mailer.gwdg.de with esmtp (Exim 4.90_1)
        (envelope-from <maan@tuebingen.mpg.de>)
        id 1hLsZy-0002zC-9v; Wed, 01 May 2019 18:59:34 +0200
Received: from [10.37.80.2] (HELO mailhost.tuebingen.mpg.de)
  by tuebingen.mpg.de (CommuniGate Pro SMTP 6.2.6)
  with SMTP id 22798746; Wed, 01 May 2019 19:01:00 +0200
Received: by mailhost.tuebingen.mpg.de (sSMTP sendmail emulation); Wed, 01 May 2019 18:59:33 +0200
Date:   Wed, 1 May 2019 18:59:33 +0200
From:   Andre Noll <maan@tuebingen.mpg.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Darrick J. Wong" <darrick.wong@oracle.com>,
        linux-xfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190501165933.GF2780@tuebingen.mpg.de>
References: <20190430121420.GW2780@tuebingen.mpg.de>
 <20190430151151.GF5207@magnolia>
 <20190430162506.GZ2780@tuebingen.mpg.de>
 <20190430174042.GH5207@magnolia>
 <20190430190525.GB2780@tuebingen.mpg.de>
 <20190430191825.GF5217@magnolia>
 <20190430210724.GD2780@tuebingen.mpg.de>
 <20190501153643.GL5207@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="udOl8koJG4PSVcOF"
Content-Disposition: inline
In-Reply-To: <20190501153643.GL5207@magnolia>
User-Agent: Mutt/1.11.4 (207b9306) (2019-03-13)
X-Spam-Level: $
X-Virus-Scanned: (clean) by clamav
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--udOl8koJG4PSVcOF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 01, 08:36, Darrick J. Wong wrote
> > > You could send this patch to the stable list, but my guess is that
> > > they'd prefer a straight backport of all three commits...
> >=20
> > Hm, cherry-picking the first commit onto 4.9,171 already gives
> > four conflicting files. The conflicts are trivial to resolve (git
> > cherry-pick -xX theirs 21ec54168b36 does it), but that doesn't
> > compile because xfs_btree_query_all() is missing.  So e9a2599a249ed
> > (xfs: create a function to query all records in a btree) is needed as
> > well. But then, applying 86210fbebae (xfs: move various type verifiers
> > to common file) on top of that gives non-trivial conflicts.
>=20
> Ah, I suspected that might happen.  Backports are hard. :(
>=20
> I suppose one saving grace of the patch you sent is that it'll likely
> break the build if anyone ever /does/ attempt a backport of those first
> two commits.  Perhaps that is the most practical way forward.
>=20
> > So, for automatic backporting we would need to cherry-pick even more,
> > and each backported commit should be tested of course. Given this, do
> > you still think Greg prefers a rather large set of straight backports
> > over the simple commit that just pulls in the missing function?
>=20
> I think you'd have to ask him that, if you decide not to send
> yesterday's patch.

Let's try. I've added a sentence to the commit message which explains
why a straight backport is not practical, and how to proceed if anyone
wants to backport the earlier commits.

Greg: Under the given circumstances, would you be willing to accept
the patch below for 4.9?

Thanks
Andre
---
commit 6a12a8bda15d5223103df76b8f92cc277c2f5e69
Author: Dave Chinner <dchinner@redhat.com>
Date:   Mon Nov 19 13:31:08 2018 -0800

    xfs: finobt AG reserves don't consider last AG can be a runt
   =20
    This is a backport of upstream commit c08768977b9 and the part of
    21ec54168b36 which is needed by c08768977b9 to fix a ENOSPC issue
    due to a bug in the finobt per-ag space reservation code. The bug
    was observed on an almost empty 100T large filesystem whose last AG
    happened to be very small.
   =20
    A direct backport of the above mentioned two commits is not possible
    because the second commit relies on further infrastructure that was
    introduced earlier. If anyone ever attempts to backport those earlier
    commits, this commit has to be reverted first so that the earlier
    commits apply, and c08768977b9 has to be applied on top of that.
   =20
    Commit log of c08768977b9 follows.
   =20
            commit c08768977b9a65cab9bcfd1ba30ffb686b2b7c69
            Author: Dave Chinner <dchinner@redhat.com>
            Date:   Mon Nov 19 13:31:08 2018 -0800
   =20
                xfs: finobt AG reserves don't consider last AG can be a runt
   =20
                The last AG may be very small comapred to all other AGs, an=
d hence
                AG reservations based on the superblock AG size may actuall=
y consume
                more space than the AG actually has. This results on assert=
 failures
                like:
   =20
                XFS: Assertion failed: xfs_perag_resv(pag, XFS_AG_RESV_META=
DATA)->ar_reserved + xfs_perag_resv(pag, XFS_AG_RESV_RMAPBT)->ar_reserved <=
=3D pag->pagf_freeblks + pag->pagf_flcount, file: fs/xfs/libxfs/xfs_ag_resv=
=2Ec, line: 319
                [   48.932891]  xfs_ag_resv_init+0x1bd/0x1d0
                [   48.933853]  xfs_fs_reserve_ag_blocks+0x37/0xb0
                [   48.934939]  xfs_mountfs+0x5b3/0x920
                [   48.935804]  xfs_fs_fill_super+0x462/0x640
                [   48.936784]  ? xfs_test_remount_options+0x60/0x60
                [   48.937908]  mount_bdev+0x178/0x1b0
                [   48.938751]  mount_fs+0x36/0x170
                [   48.939533]  vfs_kern_mount.part.43+0x54/0x130
                [   48.940596]  do_mount+0x20e/0xcb0
                [   48.941396]  ? memdup_user+0x3e/0x70
                [   48.942249]  ksys_mount+0xba/0xd0
                [   48.943046]  __x64_sys_mount+0x21/0x30
                [   48.943953]  do_syscall_64+0x54/0x170
                [   48.944835]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
   =20
                Hence we need to ensure the finobt per-ag space reservation=
s take
                into account the size of the last AG rather than treat it l=
ike all
                the other full size AGs.
   =20
                Note that both refcountbt and rmapbt already take the size =
of the AG
                into account via reading the AGF length directly.
   =20
                Signed-off-by: Dave Chinner <dchinner@redhat.com>
                Reviewed-by: Christoph Hellwig <hch@lst.de>
                Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
                Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
   =20
    Suggested-by: Darrick J. Wong <darrick.wong@oracle.com>
    Tested-by: Andre Noll <maan@tuebingen.mpg.de>

diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_bt=
ree.c
index b9c351ff0422..33905989929e 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -502,17 +502,33 @@ xfs_inobt_rec_check_count(
 }
 #endif	/* DEBUG */
=20
+/* Find the size of the AG, in blocks. */
+static xfs_agblock_t
+xfs_ag_block_count(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	ASSERT(agno < mp->m_sb.sb_agcount);
+
+	if (agno < mp->m_sb.sb_agcount - 1)
+		return mp->m_sb.sb_agblocks;
+	return mp->m_sb.sb_dblocks - (agno * mp->m_sb.sb_agblocks);
+}
+
 static xfs_extlen_t
 xfs_inobt_max_size(
-	struct xfs_mount	*mp)
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
 {
+	xfs_agblock_t		agblocks =3D xfs_ag_block_count(mp, agno);
+
 	/* Bail out if we're uninitialized, which can happen in mkfs. */
 	if (mp->m_inobt_mxr[0] =3D=3D 0)
 		return 0;
=20
 	return xfs_btree_calc_size(mp, mp->m_inobt_mnr,
-		(uint64_t)mp->m_sb.sb_agblocks * mp->m_sb.sb_inopblock /
-				XFS_INODES_PER_CHUNK);
+				(uint64_t)agblocks * mp->m_sb.sb_inopblock /
+					XFS_INODES_PER_CHUNK);
 }
=20
 static int
@@ -558,7 +574,7 @@ xfs_finobt_calc_reserves(
 	if (error)
 		return error;
=20
-	*ask +=3D xfs_inobt_max_size(mp);
+	*ask +=3D xfs_inobt_max_size(mp, agno);
 	*used +=3D tree_len;
 	return 0;
 }
--=20
Max Planck Institute for Developmental Biology
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany. Phone: (+49) 7071 601 829
http://people.tuebingen.mpg.de/maan/

--udOl8koJG4PSVcOF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCXMnQcgAKCRBa2jVAMQCT
D3HfAJ9PvNqUiBP2ZCp72IN5vriE70RANwCfaCoW4ZaNLoc/h8csx/DPrunm4mw=
=pOip
-----END PGP SIGNATURE-----

--udOl8koJG4PSVcOF--
