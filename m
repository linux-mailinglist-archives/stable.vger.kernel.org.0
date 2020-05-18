Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9461D8272
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730848AbgERR4b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:56:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:34470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731112AbgERR4b (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:56:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3C6F20715;
        Mon, 18 May 2020 17:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824590;
        bh=qQxHrE0APJ8K5bxvRs0/Ncm3ebux1nvud96TSgi13cY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DwBAlf1E0nx577OQmsvb194HLBTj8jm+inqFnW3i/Wpwk2MvIFRTwdKwMJthm2lvF
         OpZHgHmQbEcZbkfzc3cyF1pThQl5mGvajtBgt1hFW/E/iKLv2ZZO5phXilH4iShh+w
         5omrQIEVj3HCXWD1MrXN902FH/4HAYxrKvv7F6Tg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/147] gfs2: More gfs2_find_jhead fixes
Date:   Mon, 18 May 2020 19:36:34 +0200
Message-Id: <20200518173522.837620586@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173513.009514388@linuxfoundation.org>
References: <20200518173513.009514388@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit aa83da7f47b26c9587bade6c4bc4736ffa308f0a ]

It turns out that when extending an existing bio, gfs2_find_jhead fails to
check if the block number is consecutive, which leads to incorrect reads for
fragmented journals.

In addition, limit the maximum bio size to an arbitrary value of 2 megabytes:
since commit 07173c3ec276 ("block: enable multipage bvecs"), if we just keep
adding pages until bio_add_page fails, bios will grow much larger than useful,
which pins more memory than necessary with barely any additional performance
gains.

Fixes: f4686c26ecc3 ("gfs2: read journal in large chunks")
Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/lops.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 7ca84be20cf69..8303b44a50682 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -264,7 +264,7 @@ static struct bio *gfs2_log_alloc_bio(struct gfs2_sbd *sdp, u64 blkno,
 	struct super_block *sb = sdp->sd_vfs;
 	struct bio *bio = bio_alloc(GFP_NOIO, BIO_MAX_PAGES);
 
-	bio->bi_iter.bi_sector = blkno << (sb->s_blocksize_bits - 9);
+	bio->bi_iter.bi_sector = blkno << sdp->sd_fsb2bb_shift;
 	bio_set_dev(bio, sb->s_bdev);
 	bio->bi_end_io = end_io;
 	bio->bi_private = sdp;
@@ -504,7 +504,7 @@ int gfs2_find_jhead(struct gfs2_jdesc *jd, struct gfs2_log_header_host *head,
 	unsigned int bsize = sdp->sd_sb.sb_bsize, off;
 	unsigned int bsize_shift = sdp->sd_sb.sb_bsize_shift;
 	unsigned int shift = PAGE_SHIFT - bsize_shift;
-	unsigned int readahead_blocks = BIO_MAX_PAGES << shift;
+	unsigned int max_bio_size = 2 * 1024 * 1024;
 	struct gfs2_journal_extent *je;
 	int sz, ret = 0;
 	struct bio *bio = NULL;
@@ -532,12 +532,17 @@ int gfs2_find_jhead(struct gfs2_jdesc *jd, struct gfs2_log_header_host *head,
 				off = 0;
 			}
 
-			if (!bio || (bio_chained && !off)) {
+			if (!bio || (bio_chained && !off) ||
+			    bio->bi_iter.bi_size >= max_bio_size) {
 				/* start new bio */
 			} else {
-				sz = bio_add_page(bio, page, bsize, off);
-				if (sz == bsize)
-					goto block_added;
+				sector_t sector = dblock << sdp->sd_fsb2bb_shift;
+
+				if (bio_end_sector(bio) == sector) {
+					sz = bio_add_page(bio, page, bsize, off);
+					if (sz == bsize)
+						goto block_added;
+				}
 				if (off) {
 					unsigned int blocks =
 						(PAGE_SIZE - off) >> bsize_shift;
@@ -563,7 +568,7 @@ int gfs2_find_jhead(struct gfs2_jdesc *jd, struct gfs2_log_header_host *head,
 			off += bsize;
 			if (off == PAGE_SIZE)
 				page = NULL;
-			if (blocks_submitted < blocks_read + readahead_blocks) {
+			if (blocks_submitted < 2 * max_bio_size >> bsize_shift) {
 				/* Keep at least one bio in flight */
 				continue;
 			}
-- 
2.20.1



