Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C99D150D20
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727129AbgBCQlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:41:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729397AbgBCQe2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:34:28 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E8862051A;
        Mon,  3 Feb 2020 16:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747667;
        bh=T64QrRaEnROFMpUc27dauKgdZLOW/bWruBQ/BjfdlSw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G0yGvfpmMKyCCG43SgazHuDhsPpLyfByI7rMvewh9ON4JwOEO2OCFHs4LDIKAJapb
         J1c/odmVxvvbfgRePnLN5P1UvAwoECukMI+QRja4oSyzzzjl35JQcB6FGEugBxRTCF
         cuifULWzTc8EbU0fe11lRoFT+UZ47dWsHk0sH+48=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 5.4 08/90] gfs2: Another gfs2_find_jhead fix
Date:   Mon,  3 Feb 2020 16:19:11 +0000
Message-Id: <20200203161918.669230239@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit eed0f953b90e86e765197a1dad06bb48aedc27fe upstream.

On filesystems with a block size smaller than the page size,
gfs2_find_jhead can split a page across two bios (for example, when
blocks are not allocated consecutively).  When that happens, the first
bio that completes will unlock the page in its bi_end_io handler even
though the page hasn't been read completely yet.  Fix that by using a
chained bio for the rest of the page.

While at it, clean up the sector calculation logic in
gfs2_log_alloc_bio.  In gfs2_find_jhead, simplify the disk block and
offset calculation logic and fix a variable name.

Fixes: f4686c26ecc3 ("gfs2: read journal in large chunks")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/lops.c |   68 ++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 24 deletions(-)

--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -264,7 +264,7 @@ static struct bio *gfs2_log_alloc_bio(st
 	struct super_block *sb = sdp->sd_vfs;
 	struct bio *bio = bio_alloc(GFP_NOIO, BIO_MAX_PAGES);
 
-	bio->bi_iter.bi_sector = blkno * (sb->s_blocksize >> 9);
+	bio->bi_iter.bi_sector = blkno << (sb->s_blocksize_bits - 9);
 	bio_set_dev(bio, sb->s_bdev);
 	bio->bi_end_io = end_io;
 	bio->bi_private = sdp;
@@ -471,6 +471,20 @@ static void gfs2_jhead_process_page(stru
 	put_page(page); /* Once more for find_or_create_page */
 }
 
+static struct bio *gfs2_chain_bio(struct bio *prev, unsigned int nr_iovecs)
+{
+	struct bio *new;
+
+	new = bio_alloc(GFP_NOIO, nr_iovecs);
+	bio_copy_dev(new, prev);
+	new->bi_iter.bi_sector = bio_end_sector(prev);
+	new->bi_opf = prev->bi_opf;
+	new->bi_write_hint = prev->bi_write_hint;
+	bio_chain(new, prev);
+	submit_bio(prev);
+	return new;
+}
+
 /**
  * gfs2_find_jhead - find the head of a log
  * @jd: The journal descriptor
@@ -487,15 +501,15 @@ int gfs2_find_jhead(struct gfs2_jdesc *j
 	struct gfs2_sbd *sdp = GFS2_SB(jd->jd_inode);
 	struct address_space *mapping = jd->jd_inode->i_mapping;
 	unsigned int block = 0, blocks_submitted = 0, blocks_read = 0;
-	unsigned int bsize = sdp->sd_sb.sb_bsize;
+	unsigned int bsize = sdp->sd_sb.sb_bsize, off;
 	unsigned int bsize_shift = sdp->sd_sb.sb_bsize_shift;
 	unsigned int shift = PAGE_SHIFT - bsize_shift;
-	unsigned int readhead_blocks = BIO_MAX_PAGES << shift;
+	unsigned int readahead_blocks = BIO_MAX_PAGES << shift;
 	struct gfs2_journal_extent *je;
 	int sz, ret = 0;
 	struct bio *bio = NULL;
 	struct page *page = NULL;
-	bool done = false;
+	bool bio_chained = false, done = false;
 	errseq_t since;
 
 	memset(head, 0, sizeof(*head));
@@ -504,9 +518,9 @@ int gfs2_find_jhead(struct gfs2_jdesc *j
 
 	since = filemap_sample_wb_err(mapping);
 	list_for_each_entry(je, &jd->extent_list, list) {
-		for (; block < je->lblock + je->blocks; block++) {
-			u64 dblock;
+		u64 dblock = je->dblock;
 
+		for (; block < je->lblock + je->blocks; block++, dblock++) {
 			if (!page) {
 				page = find_or_create_page(mapping,
 						block >> shift, GFP_NOFS);
@@ -515,35 +529,41 @@ int gfs2_find_jhead(struct gfs2_jdesc *j
 					done = true;
 					goto out;
 				}
+				off = 0;
 			}
 
-			if (bio) {
-				unsigned int off;
-
-				off = (block << bsize_shift) & ~PAGE_MASK;
+			if (!bio || (bio_chained && !off)) {
+				/* start new bio */
+			} else {
 				sz = bio_add_page(bio, page, bsize, off);
-				if (sz == bsize) { /* block added */
-					if (off + bsize == PAGE_SIZE) {
-						page = NULL;
-						goto page_added;
-					}
-					continue;
+				if (sz == bsize)
+					goto block_added;
+				if (off) {
+					unsigned int blocks =
+						(PAGE_SIZE - off) >> bsize_shift;
+
+					bio = gfs2_chain_bio(bio, blocks);
+					bio_chained = true;
+					goto add_block_to_new_bio;
 				}
+			}
+
+			if (bio) {
 				blocks_submitted = block + 1;
 				submit_bio(bio);
-				bio = NULL;
 			}
 
-			dblock = je->dblock + (block - je->lblock);
 			bio = gfs2_log_alloc_bio(sdp, dblock, gfs2_end_log_read);
 			bio->bi_opf = REQ_OP_READ;
-			sz = bio_add_page(bio, page, bsize, 0);
-			gfs2_assert_warn(sdp, sz == bsize);
-			if (bsize == PAGE_SIZE)
+			bio_chained = false;
+add_block_to_new_bio:
+			sz = bio_add_page(bio, page, bsize, off);
+			BUG_ON(sz != bsize);
+block_added:
+			off += bsize;
+			if (off == PAGE_SIZE)
 				page = NULL;
-
-page_added:
-			if (blocks_submitted < blocks_read + readhead_blocks) {
+			if (blocks_submitted < blocks_read + readahead_blocks) {
 				/* Keep at least one bio in flight */
 				continue;
 			}


