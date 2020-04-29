Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08FC91BE02A
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 16:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgD2OGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 10:06:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30390 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726950AbgD2OGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 10:06:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588169191;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=w/B3fn9TsJR5V2+8f8MPJsoD0Ivx+Xsfq+6JufCjm+8=;
        b=XpGXFU+LKr+xV53cJjmSc0mPpJPElyJINiYfzUNFxnRH8TGe3eUktGqhPq+eYFO7TbIZGe
        C6OF8caq7+Vs2KDaEz6GHCM7QFlQ2IvjZgePIw7lmaSEhc/H72WZkyFO1utF+J61xiQI4w
        PfCljSpuutbR1A+t77GO9uxfQ8XpPOY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-215-oitl5K2VMuuseGJpiPxHIA-1; Wed, 29 Apr 2020 10:06:29 -0400
X-MC-Unique: oitl5K2VMuuseGJpiPxHIA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9FA66107ACCD
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 14:06:28 +0000 (UTC)
Received: from max.home.com (ovpn-114-63.ams2.redhat.com [10.36.114.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B23AE1001281;
        Wed, 29 Apr 2020 14:06:24 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     cluster-devel@redhat.com
Cc:     Andreas Gruenbacher <agruenba@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] gfs2: More gfs2_find_jhead fixes
Date:   Wed, 29 Apr 2020 16:06:23 +0200
Message-Id: <20200429140623.236426-1-agruenba@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It turns out that when extending an existing bio, gfs2_find_jhead fails t=
o
check if the block number is consecutive, which leads to incorrect reads =
for
fragmented journals.

In addition, limit the maximum bio size to an arbitrary value of 2 megaby=
tes:
since commit 07173c3ec276 ("block: enable multipage bvecs"), if we just k=
eep
adding pages until bio_add_page fails, bios will grow much larger than us=
eful,
which pins more memory than necessary with barely any additional performa=
nce
gains.

Fixes: f4686c26ecc3 ("gfs2: read journal in large chunks")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/lops.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 5ea96757afc4..48b54ec1c793 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -263,7 +263,7 @@ static struct bio *gfs2_log_alloc_bio(struct gfs2_sbd=
 *sdp, u64 blkno,
 	struct super_block *sb =3D sdp->sd_vfs;
 	struct bio *bio =3D bio_alloc(GFP_NOIO, BIO_MAX_PAGES);
=20
-	bio->bi_iter.bi_sector =3D blkno << (sb->s_blocksize_bits - 9);
+	bio->bi_iter.bi_sector =3D blkno << sdp->sd_fsb2bb_shift;
 	bio_set_dev(bio, sb->s_bdev);
 	bio->bi_end_io =3D end_io;
 	bio->bi_private =3D sdp;
@@ -509,7 +509,7 @@ int gfs2_find_jhead(struct gfs2_jdesc *jd, struct gfs=
2_log_header_host *head,
 	unsigned int bsize =3D sdp->sd_sb.sb_bsize, off;
 	unsigned int bsize_shift =3D sdp->sd_sb.sb_bsize_shift;
 	unsigned int shift =3D PAGE_SHIFT - bsize_shift;
-	unsigned int readahead_blocks =3D BIO_MAX_PAGES << shift;
+	unsigned int max_bio_size =3D 2 * 1024 * 1024;
 	struct gfs2_journal_extent *je;
 	int sz, ret =3D 0;
 	struct bio *bio =3D NULL;
@@ -537,12 +537,17 @@ int gfs2_find_jhead(struct gfs2_jdesc *jd, struct g=
fs2_log_header_host *head,
 				off =3D 0;
 			}
=20
-			if (!bio || (bio_chained && !off)) {
+			if (!bio || (bio_chained && !off) ||
+			    bio->bi_iter.bi_size >=3D max_bio_size) {
 				/* start new bio */
 			} else {
-				sz =3D bio_add_page(bio, page, bsize, off);
-				if (sz =3D=3D bsize)
-					goto block_added;
+				sector_t sector =3D dblock << sdp->sd_fsb2bb_shift;
+
+				if (bio_end_sector(bio) =3D=3D sector) {
+					sz =3D bio_add_page(bio, page, bsize, off);
+					if (sz =3D=3D bsize)
+						goto block_added;
+				}
 				if (off) {
 					unsigned int blocks =3D
 						(PAGE_SIZE - off) >> bsize_shift;
@@ -568,7 +573,7 @@ int gfs2_find_jhead(struct gfs2_jdesc *jd, struct gfs=
2_log_header_host *head,
 			off +=3D bsize;
 			if (off =3D=3D PAGE_SIZE)
 				page =3D NULL;
-			if (blocks_submitted < blocks_read + readahead_blocks) {
+			if (blocks_submitted < 2 * max_bio_size >> bsize_shift) {
 				/* Keep at least one bio in flight */
 				continue;
 			}

base-commit: fbe051ea4adf66950e2f23e71ace8eeb4e0e1c73
prerequisite-patch-id: f37202c2597b647c19a42736cfec807040560d9b
--=20
2.25.3

