Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 042938DAF7
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730289AbfHNRJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730283AbfHNRJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:09:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B1858214DA;
        Wed, 14 Aug 2019 17:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802549;
        bh=rDtx/CqF0F237JhsM7MFNIO+jwNhyv+rna3pVjVcc5Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ckAEUfklPYoZtsNT0iUVQ2/z6NWYW6Qpw//ldTtECeN07XWle942WVery6j52H2oG
         L+0rZDg2leqVF3m/61+FUJRd/GrXuShO1yvH+F2jqbS6dJRmlArCvTD6I/CNUWLkp8
         mh0zyhBwSq3RcMOQZ1fGzggezlCh81tfqlwjybOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>,
        Bob Peterson <rpeterso@redhat.com>
Subject: [PATCH 4.19 24/91] gfs2: gfs2_walk_metadata fix
Date:   Wed, 14 Aug 2019 19:00:47 +0200
Message-Id: <20190814165750.730973940@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

commit a27a0c9b6a208722016c8ec5ad31ec96082b91ec upstream.

It turns out that the current version of gfs2_metadata_walker suffers
from multiple problems that can cause gfs2_hole_size to report an
incorrect size.  This will confuse fiemap as well as lseek with the
SEEK_DATA flag.

Fix that by changing gfs2_hole_walker to compute the metapath to the
first data block after the hole (if any), and compute the hole size
based on that.

Fixes xfstest generic/490.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Bob Peterson <rpeterso@redhat.com>
Cc: stable@vger.kernel.org # v4.18+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/gfs2/bmap.c |  168 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 103 insertions(+), 65 deletions(-)

--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -392,6 +392,19 @@ static int fillup_metapath(struct gfs2_i
 	return mp->mp_aheight - x - 1;
 }
 
+static sector_t metapath_to_block(struct gfs2_sbd *sdp, struct metapath *mp)
+{
+	sector_t factor = 1, block = 0;
+	int hgt;
+
+	for (hgt = mp->mp_fheight - 1; hgt >= 0; hgt--) {
+		if (hgt < mp->mp_aheight)
+			block += mp->mp_list[hgt] * factor;
+		factor *= sdp->sd_inptrs;
+	}
+	return block;
+}
+
 static void release_metapath(struct metapath *mp)
 {
 	int i;
@@ -432,60 +445,84 @@ static inline unsigned int gfs2_extent_l
 	return ptr - first;
 }
 
-typedef const __be64 *(*gfs2_metadata_walker)(
-		struct metapath *mp,
-		const __be64 *start, const __be64 *end,
-		u64 factor, void *data);
-
-#define WALK_STOP ((__be64 *)0)
-#define WALK_NEXT ((__be64 *)1)
-
-static int gfs2_walk_metadata(struct inode *inode, sector_t lblock,
-		u64 len, struct metapath *mp, gfs2_metadata_walker walker,
-		void *data)
+enum walker_status { WALK_STOP, WALK_FOLLOW, WALK_CONTINUE };
+
+/*
+ * gfs2_metadata_walker - walk an indirect block
+ * @mp: Metapath to indirect block
+ * @ptrs: Number of pointers to look at
+ *
+ * When returning WALK_FOLLOW, the walker must update @mp to point at the right
+ * indirect block to follow.
+ */
+typedef enum walker_status (*gfs2_metadata_walker)(struct metapath *mp,
+						   unsigned int ptrs);
+
+/*
+ * gfs2_walk_metadata - walk a tree of indirect blocks
+ * @inode: The inode
+ * @mp: Starting point of walk
+ * @max_len: Maximum number of blocks to walk
+ * @walker: Called during the walk
+ *
+ * Returns 1 if the walk was stopped by @walker, 0 if we went past @max_len or
+ * past the end of metadata, and a negative error code otherwise.
+ */
+
+static int gfs2_walk_metadata(struct inode *inode, struct metapath *mp,
+		u64 max_len, gfs2_metadata_walker walker)
 {
-	struct metapath clone;
 	struct gfs2_inode *ip = GFS2_I(inode);
 	struct gfs2_sbd *sdp = GFS2_SB(inode);
-	const __be64 *start, *end, *ptr;
 	u64 factor = 1;
 	unsigned int hgt;
-	int ret = 0;
+	int ret;
 
-	for (hgt = ip->i_height - 1; hgt >= mp->mp_aheight; hgt--)
+	/*
+	 * The walk starts in the lowest allocated indirect block, which may be
+	 * before the position indicated by @mp.  Adjust @max_len accordingly
+	 * to avoid a short walk.
+	 */
+	for (hgt = mp->mp_fheight - 1; hgt >= mp->mp_aheight; hgt--) {
+		max_len += mp->mp_list[hgt] * factor;
+		mp->mp_list[hgt] = 0;
 		factor *= sdp->sd_inptrs;
+	}
 
 	for (;;) {
-		u64 step;
+		u16 start = mp->mp_list[hgt];
+		enum walker_status status;
+		unsigned int ptrs;
+		u64 len;
 
 		/* Walk indirect block. */
-		start = metapointer(hgt, mp);
-		end = metaend(hgt, mp);
-
-		step = (end - start) * factor;
-		if (step > len)
-			end = start + DIV_ROUND_UP_ULL(len, factor);
-
-		ptr = walker(mp, start, end, factor, data);
-		if (ptr == WALK_STOP)
+		ptrs = (hgt >= 1 ? sdp->sd_inptrs : sdp->sd_diptrs) - start;
+		len = ptrs * factor;
+		if (len > max_len)
+			ptrs = DIV_ROUND_UP_ULL(max_len, factor);
+		status = walker(mp, ptrs);
+		switch (status) {
+		case WALK_STOP:
+			return 1;
+		case WALK_FOLLOW:
+			BUG_ON(mp->mp_aheight == mp->mp_fheight);
+			ptrs = mp->mp_list[hgt] - start;
+			len = ptrs * factor;
 			break;
-		if (step >= len)
+		case WALK_CONTINUE:
 			break;
-		len -= step;
-		if (ptr != WALK_NEXT) {
-			BUG_ON(!*ptr);
-			mp->mp_list[hgt] += ptr - start;
-			goto fill_up_metapath;
 		}
+		if (len >= max_len)
+			break;
+		max_len -= len;
+		if (status == WALK_FOLLOW)
+			goto fill_up_metapath;
 
 lower_metapath:
 		/* Decrease height of metapath. */
-		if (mp != &clone) {
-			clone_metapath(&clone, mp);
-			mp = &clone;
-		}
 		brelse(mp->mp_bh[hgt]);
 		mp->mp_bh[hgt] = NULL;
+		mp->mp_list[hgt] = 0;
 		if (!hgt)
 			break;
 		hgt--;
@@ -493,10 +530,7 @@ lower_metapath:
 
 		/* Advance in metadata tree. */
 		(mp->mp_list[hgt])++;
-		start = metapointer(hgt, mp);
-		end = metaend(hgt, mp);
-		if (start >= end) {
-			mp->mp_list[hgt] = 0;
+		if (mp->mp_list[hgt] >= sdp->sd_inptrs) {
 			if (!hgt)
 				break;
 			goto lower_metapath;
@@ -504,44 +538,36 @@ lower_metapath:
 
 fill_up_metapath:
 		/* Increase height of metapath. */
-		if (mp != &clone) {
-			clone_metapath(&clone, mp);
-			mp = &clone;
-		}
 		ret = fillup_metapath(ip, mp, ip->i_height - 1);
 		if (ret < 0)
-			break;
+			return ret;
 		hgt += ret;
 		for (; ret; ret--)
 			do_div(factor, sdp->sd_inptrs);
 		mp->mp_aheight = hgt + 1;
 	}
-	if (mp == &clone)
-		release_metapath(mp);
-	return ret;
+	return 0;
 }
 
-struct gfs2_hole_walker_args {
-	u64 blocks;
-};
-
-static const __be64 *gfs2_hole_walker(struct metapath *mp,
-		const __be64 *start, const __be64 *end,
-		u64 factor, void *data)
+static enum walker_status gfs2_hole_walker(struct metapath *mp,
+					   unsigned int ptrs)
 {
-	struct gfs2_hole_walker_args *args = data;
-	const __be64 *ptr;
+	const __be64 *start, *ptr, *end;
+	unsigned int hgt;
+
+	hgt = mp->mp_aheight - 1;
+	start = metapointer(hgt, mp);
+	end = start + ptrs;
 
 	for (ptr = start; ptr < end; ptr++) {
 		if (*ptr) {
-			args->blocks += (ptr - start) * factor;
+			mp->mp_list[hgt] += ptr - start;
 			if (mp->mp_aheight == mp->mp_fheight)
 				return WALK_STOP;
-			return ptr;  /* increase height */
+			return WALK_FOLLOW;
 		}
 	}
-	args->blocks += (end - start) * factor;
-	return WALK_NEXT;
+	return WALK_CONTINUE;
 }
 
 /**
@@ -559,12 +585,24 @@ static const __be64 *gfs2_hole_walker(st
 static int gfs2_hole_size(struct inode *inode, sector_t lblock, u64 len,
 			  struct metapath *mp, struct iomap *iomap)
 {
-	struct gfs2_hole_walker_args args = { };
-	int ret = 0;
+	struct metapath clone;
+	u64 hole_size;
+	int ret;
+
+	clone_metapath(&clone, mp);
+	ret = gfs2_walk_metadata(inode, &clone, len, gfs2_hole_walker);
+	if (ret < 0)
+		goto out;
+
+	if (ret == 1)
+		hole_size = metapath_to_block(GFS2_SB(inode), &clone) - lblock;
+	else
+		hole_size = len;
+	iomap->length = hole_size << inode->i_blkbits;
+	ret = 0;
 
-	ret = gfs2_walk_metadata(inode, lblock, len, mp, gfs2_hole_walker, &args);
-	if (!ret)
-		iomap->length = args.blocks << inode->i_blkbits;
+out:
+	release_metapath(&clone);
 	return ret;
 }
 


