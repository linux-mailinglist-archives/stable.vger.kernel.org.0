Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4584E118375
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 10:24:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfLJJYp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 04:24:45 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:52942 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726574AbfLJJYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Dec 2019 04:24:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575969883;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yysTNdKJ8HLfLmP68ssP1bFYv2EPEfhq+cfHv2KETG0=;
        b=KT8ZWLHEYZvUw7dQg9O0qdEU94q2lDmShwpmdaVIWggru9PMuWj1WOrmTJdTGPl1BWSmNR
        2bODImZ6Swe2odHXvKGxQZpoHxfmLsCOsi3MMOQ375oX2kcOoWQgxQRi2iIBtIBqjgTAE9
        QET3SikuIFT6gwP1Om+JEAt68iW/zpg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-dL-nzP7tMTmOrWTnLfnQXQ-1; Tue, 10 Dec 2019 04:24:39 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A058BA08FF
        for <stable@vger.kernel.org>; Tue, 10 Dec 2019 09:24:38 +0000 (UTC)
Received: from max.com (ovpn-205-78.brq.redhat.com [10.40.205.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 741FA600D3;
        Tue, 10 Dec 2019 09:24:34 +0000 (UTC)
From:   Andreas Gruenbacher <agruenba@redhat.com>
To:     cluster-devel@redhat.com
Cc:     Abhi Das <adas@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        stable@vger.kernel.org
Subject: [PATCH v2] gfs2: Another gfs2_find_jhead fix
Date:   Tue, 10 Dec 2019 10:24:32 +0100
Message-Id: <20191210092432.30382-1-agruenba@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: dL-nzP7tMTmOrWTnLfnQXQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On filesystems with a block size smaller than the page size,
gfs2_find_jhead can split a page across two bios (for example, when
blocks are not allocated consecutively).  When that happens, the first
bio that completes will unlock the page in its bi_end_io handler even
though the page hasn't been read completely yet.  Fix that by using a
small chained bio.

While at it, clean up the sector calculation logic in
gfs2_log_alloc_bio.  In gfs2_find_jhead, simplify the disk block and
offset calculation logic and fix a variable name.

Fixes: f4686c26ecc3 ("gfs2: read journal in large chunks")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/gfs2/lops.c | 68 ++++++++++++++++++++++++++++++++------------------
 1 file changed, 44 insertions(+), 24 deletions(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 55fed7daf2b1..12696133618c 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -259,7 +259,7 @@ static struct bio *gfs2_log_alloc_bio(struct gfs2_sbd *=
sdp, u64 blkno,
 =09struct super_block *sb =3D sdp->sd_vfs;
 =09struct bio *bio =3D bio_alloc(GFP_NOIO, BIO_MAX_PAGES);
=20
-=09bio->bi_iter.bi_sector =3D blkno * (sb->s_blocksize >> 9);
+=09bio->bi_iter.bi_sector =3D blkno << (sb->s_blocksize_bits - 9);
 =09bio_set_dev(bio, sb->s_bdev);
 =09bio->bi_end_io =3D end_io;
 =09bio->bi_private =3D sdp;
@@ -472,6 +472,20 @@ static void gfs2_jhead_process_page(struct gfs2_jdesc =
*jd, unsigned long index,
 =09put_page(page); /* Once more for find_or_create_page */
 }
=20
+static struct bio *gfs2_chain_bio(struct bio *prev, unsigned int nr_iovecs=
)
+{
+=09struct bio *new;
+
+=09new =3D bio_alloc(GFP_NOIO, nr_iovecs);
+=09bio_copy_dev(new, prev);
+=09new->bi_iter.bi_sector =3D bio_end_sector(prev);
+=09new->bi_opf =3D prev->bi_opf;
+=09new->bi_write_hint =3D prev->bi_write_hint;
+=09bio_chain(new, prev);
+=09submit_bio(prev);
+=09return new;
+}
+
 /**
  * gfs2_find_jhead - find the head of a log
  * @jd: The journal descriptor
@@ -488,15 +502,15 @@ int gfs2_find_jhead(struct gfs2_jdesc *jd, struct gfs=
2_log_header_host *head,
 =09struct gfs2_sbd *sdp =3D GFS2_SB(jd->jd_inode);
 =09struct address_space *mapping =3D jd->jd_inode->i_mapping;
 =09unsigned int block =3D 0, blocks_submitted =3D 0, blocks_read =3D 0;
-=09unsigned int bsize =3D sdp->sd_sb.sb_bsize;
+=09unsigned int bsize =3D sdp->sd_sb.sb_bsize, off;
 =09unsigned int bsize_shift =3D sdp->sd_sb.sb_bsize_shift;
 =09unsigned int shift =3D PAGE_SHIFT - bsize_shift;
-=09unsigned int readhead_blocks =3D BIO_MAX_PAGES << shift;
+=09unsigned int readahead_blocks =3D BIO_MAX_PAGES << shift;
 =09struct gfs2_journal_extent *je;
 =09int sz, ret =3D 0;
 =09struct bio *bio =3D NULL;
 =09struct page *page =3D NULL;
-=09bool done =3D false;
+=09bool bio_chained, done =3D false;
 =09errseq_t since;
=20
 =09memset(head, 0, sizeof(*head));
@@ -505,9 +519,9 @@ int gfs2_find_jhead(struct gfs2_jdesc *jd, struct gfs2_=
log_header_host *head,
=20
 =09since =3D filemap_sample_wb_err(mapping);
 =09list_for_each_entry(je, &jd->extent_list, list) {
-=09=09for (; block < je->lblock + je->blocks; block++) {
-=09=09=09u64 dblock;
+=09=09u64 dblock =3D je->dblock;
=20
+=09=09for (; block < je->lblock + je->blocks; block++, dblock++) {
 =09=09=09if (!page) {
 =09=09=09=09page =3D find_or_create_page(mapping,
 =09=09=09=09=09=09block >> shift, GFP_NOFS);
@@ -516,35 +530,41 @@ int gfs2_find_jhead(struct gfs2_jdesc *jd, struct gfs=
2_log_header_host *head,
 =09=09=09=09=09done =3D true;
 =09=09=09=09=09goto out;
 =09=09=09=09}
+=09=09=09=09off =3D 0;
 =09=09=09}
=20
-=09=09=09if (bio) {
-=09=09=09=09unsigned int off;
-
-=09=09=09=09off =3D (block << bsize_shift) & ~PAGE_MASK;
+=09=09=09if (!bio || (bio_chained && !off)) {
+=09=09=09=09/* start new bio */
+=09=09=09} else {
 =09=09=09=09sz =3D bio_add_page(bio, page, bsize, off);
-=09=09=09=09if (sz =3D=3D bsize) { /* block added */
-=09=09=09=09=09if (off + bsize =3D=3D PAGE_SIZE) {
-=09=09=09=09=09=09page =3D NULL;
-=09=09=09=09=09=09goto page_added;
-=09=09=09=09=09}
-=09=09=09=09=09continue;
+=09=09=09=09if (sz =3D=3D bsize)
+=09=09=09=09=09goto block_added;
+=09=09=09=09if (off) {
+=09=09=09=09=09unsigned int blocks =3D
+=09=09=09=09=09=09(PAGE_SIZE - off) >> bsize_shift;
+
+=09=09=09=09=09bio =3D gfs2_chain_bio(bio, blocks);
+=09=09=09=09=09bio_chained =3D true;
+=09=09=09=09=09goto add_block_to_new_bio;
 =09=09=09=09}
+=09=09=09}
+
+=09=09=09if (bio) {
 =09=09=09=09blocks_submitted =3D block + 1;
 =09=09=09=09submit_bio(bio);
-=09=09=09=09bio =3D NULL;
 =09=09=09}
=20
-=09=09=09dblock =3D je->dblock + (block - je->lblock);
 =09=09=09bio =3D gfs2_log_alloc_bio(sdp, dblock, gfs2_end_log_read);
 =09=09=09bio->bi_opf =3D REQ_OP_READ;
-=09=09=09sz =3D bio_add_page(bio, page, bsize, 0);
-=09=09=09gfs2_assert_warn(sdp, sz =3D=3D bsize);
-=09=09=09if (bsize =3D=3D PAGE_SIZE)
+=09=09=09bio_chained =3D false;
+add_block_to_new_bio:
+=09=09=09sz =3D bio_add_page(bio, page, bsize, off);
+=09=09=09BUG_ON(sz !=3D bsize);
+block_added:
+=09=09=09off +=3D bsize;
+=09=09=09if (off =3D=3D PAGE_SIZE)
 =09=09=09=09page =3D NULL;
-
-page_added:
-=09=09=09if (blocks_submitted < blocks_read + readhead_blocks) {
+=09=09=09if (blocks_submitted < blocks_read + readahead_blocks) {
 =09=09=09=09/* Keep at least one bio in flight */
 =09=09=09=09continue;
 =09=09=09}
--=20
2.20.1

