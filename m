Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE431FB67A
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:39:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730400AbgFPPho (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:37:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730038AbgFPPho (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:37:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 521E421473;
        Tue, 16 Jun 2020 15:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321862;
        bh=2souSL7wUqJV7CFj5gHSHcYp9MqYWOL8FgY3TjLkAOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eLbUlbELl9n/G/h3IsZdpxUS0e8kVl6e6zawYxAfi3lDbOQJPkDvwB6/o4IivNQGq
         4fY/TGYUw+vWe3gHIvttnR15+buRiCUyg7DwumyYu0sAlWH12dIZEwbggrI0UBWoAy
         tmPg4hHcQbo47Ii9eOV9WSaYcNdrMPTRQShQ2g+Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 014/134] gfs2: Even more gfs2_find_jhead fixes
Date:   Tue, 16 Jun 2020 17:33:18 +0200
Message-Id: <20200616153101.375360447@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 20be493b787cd581c9fffad7fcd6bfbe6af1050c ]

Fix several issues in the previous gfs2_find_jhead fix:
* When updating @blocks_submitted, @block refers to the first block block not
  submitted yet, not the last block submitted, so fix an off-by-one error.
* We want to ensure that @blocks_submitted is far enough ahead of @blocks_read
  to guarantee that there is in-flight I/O.  Otherwise, we'll eventually end up
  waiting for pages that haven't been submitted, yet.
* It's much easier to compare the number of blocks added with the number of
  blocks submitted to limit the maximum bio size.
* Even with bio chaining, we can keep adding blocks until we reach the maximum
  bio size, as long as we stop at a page boundary.  This simplifies the logic.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/lops.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 8303b44a5068..d2ed4dc4434c 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -504,12 +504,12 @@ int gfs2_find_jhead(struct gfs2_jdesc *jd, struct gfs2_log_header_host *head,
 	unsigned int bsize = sdp->sd_sb.sb_bsize, off;
 	unsigned int bsize_shift = sdp->sd_sb.sb_bsize_shift;
 	unsigned int shift = PAGE_SHIFT - bsize_shift;
-	unsigned int max_bio_size = 2 * 1024 * 1024;
+	unsigned int max_blocks = 2 * 1024 * 1024 >> bsize_shift;
 	struct gfs2_journal_extent *je;
 	int sz, ret = 0;
 	struct bio *bio = NULL;
 	struct page *page = NULL;
-	bool bio_chained = false, done = false;
+	bool done = false;
 	errseq_t since;
 
 	memset(head, 0, sizeof(*head));
@@ -532,10 +532,7 @@ int gfs2_find_jhead(struct gfs2_jdesc *jd, struct gfs2_log_header_host *head,
 				off = 0;
 			}
 
-			if (!bio || (bio_chained && !off) ||
-			    bio->bi_iter.bi_size >= max_bio_size) {
-				/* start new bio */
-			} else {
+			if (bio && (off || block < blocks_submitted + max_blocks)) {
 				sector_t sector = dblock << sdp->sd_fsb2bb_shift;
 
 				if (bio_end_sector(bio) == sector) {
@@ -548,19 +545,17 @@ int gfs2_find_jhead(struct gfs2_jdesc *jd, struct gfs2_log_header_host *head,
 						(PAGE_SIZE - off) >> bsize_shift;
 
 					bio = gfs2_chain_bio(bio, blocks);
-					bio_chained = true;
 					goto add_block_to_new_bio;
 				}
 			}
 
 			if (bio) {
-				blocks_submitted = block + 1;
+				blocks_submitted = block;
 				submit_bio(bio);
 			}
 
 			bio = gfs2_log_alloc_bio(sdp, dblock, gfs2_end_log_read);
 			bio->bi_opf = REQ_OP_READ;
-			bio_chained = false;
 add_block_to_new_bio:
 			sz = bio_add_page(bio, page, bsize, off);
 			BUG_ON(sz != bsize);
@@ -568,7 +563,7 @@ block_added:
 			off += bsize;
 			if (off == PAGE_SIZE)
 				page = NULL;
-			if (blocks_submitted < 2 * max_bio_size >> bsize_shift) {
+			if (blocks_submitted <= blocks_read + max_blocks) {
 				/* Keep at least one bio in flight */
 				continue;
 			}
-- 
2.25.1



