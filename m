Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1467124F53F
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 10:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729341AbgHXIq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 04:46:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729336AbgHXIqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 04:46:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DA65206F0;
        Mon, 24 Aug 2020 08:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598258778;
        bh=5qiH8qx2OjearFlXAlfeyMwlKikrC6AqQAD4PhxXNpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KTvXlj07kq0Sdz0g+pyEuSp/O2MWGBfXCHV3IDm4G2UAquZ1wxFgjVDjlMT1/F1Ej
         eYLeEklGvvEPsly8yjslJVhZqsJRvm1cFDt3tFCESBH8JBVcqzwQ/Pzqhpu9ouUCgv
         wEzMaRjRb8+pOB7nP2gA2SaJB5yIxls/T5ed80Do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Peterson <rpeterso@redhat.com>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 012/107] gfs2: Never call gfs2_block_zero_range with an open transaction
Date:   Mon, 24 Aug 2020 10:29:38 +0200
Message-Id: <20200824082405.672531551@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200824082405.020301642@linuxfoundation.org>
References: <20200824082405.020301642@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

[ Upstream commit 70499cdfeb3625c87eebe4f7a7ea06fa7447e5df ]

Before this patch, some functions started transactions then they called
gfs2_block_zero_range. However, gfs2_block_zero_range, like writes, can
start transactions, which results in a recursive transaction error.
For example:

do_shrink
   trunc_start
      gfs2_trans_begin <------------------------------------------------
         gfs2_block_zero_range
            iomap_zero_range(inode, from, length, NULL, &gfs2_iomap_ops);
               iomap_apply ... iomap_zero_range_actor
                  iomap_begin
                     gfs2_iomap_begin
                        gfs2_iomap_begin_write
                  actor (iomap_zero_range_actor)
		     iomap_zero
			iomap_write_begin
			   gfs2_iomap_page_prepare
			      gfs2_trans_begin <------------------------

This patch reorders the callers of gfs2_block_zero_range so that they
only start their transactions after the call. It also adds a BUG_ON to
ensure this doesn't happen again.

Fixes: 2257e468a63b ("gfs2: implement gfs2_block_zero_range using iomap_zero_range")
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/bmap.c | 69 ++++++++++++++++++++++++++++----------------------
 1 file changed, 39 insertions(+), 30 deletions(-)

diff --git a/fs/gfs2/bmap.c b/fs/gfs2/bmap.c
index 4846e0c47e6af..50fa3e08c02f3 100644
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@ -1350,9 +1350,15 @@ int gfs2_extent_map(struct inode *inode, u64 lblock, int *new, u64 *dblock, unsi
 	return ret;
 }
 
+/*
+ * NOTE: Never call gfs2_block_zero_range with an open transaction because it
+ * uses iomap write to perform its actions, which begin their own transactions
+ * (iomap_begin, page_prepare, etc.)
+ */
 static int gfs2_block_zero_range(struct inode *inode, loff_t from,
 				 unsigned int length)
 {
+	BUG_ON(current->journal_info);
 	return iomap_zero_range(inode, from, length, NULL, &gfs2_iomap_ops);
 }
 
@@ -1413,6 +1419,16 @@ static int trunc_start(struct inode *inode, u64 newsize)
 	u64 oldsize = inode->i_size;
 	int error;
 
+	if (!gfs2_is_stuffed(ip)) {
+		unsigned int blocksize = i_blocksize(inode);
+		unsigned int offs = newsize & (blocksize - 1);
+		if (offs) {
+			error = gfs2_block_zero_range(inode, newsize,
+						      blocksize - offs);
+			if (error)
+				return error;
+		}
+	}
 	if (journaled)
 		error = gfs2_trans_begin(sdp, RES_DINODE + RES_JDATA, GFS2_JTRUNC_REVOKES);
 	else
@@ -1426,19 +1442,10 @@ static int trunc_start(struct inode *inode, u64 newsize)
 
 	gfs2_trans_add_meta(ip->i_gl, dibh);
 
-	if (gfs2_is_stuffed(ip)) {
+	if (gfs2_is_stuffed(ip))
 		gfs2_buffer_clear_tail(dibh, sizeof(struct gfs2_dinode) + newsize);
-	} else {
-		unsigned int blocksize = i_blocksize(inode);
-		unsigned int offs = newsize & (blocksize - 1);
-		if (offs) {
-			error = gfs2_block_zero_range(inode, newsize,
-						      blocksize - offs);
-			if (error)
-				goto out;
-		}
+	else
 		ip->i_diskflags |= GFS2_DIF_TRUNC_IN_PROG;
-	}
 
 	i_size_write(inode, newsize);
 	ip->i_inode.i_mtime = ip->i_inode.i_ctime = current_time(&ip->i_inode);
@@ -2446,25 +2453,7 @@ int __gfs2_punch_hole(struct file *file, loff_t offset, loff_t length)
 	loff_t start, end;
 	int error;
 
-	start = round_down(offset, blocksize);
-	end = round_up(offset + length, blocksize) - 1;
-	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
-	if (error)
-		return error;
-
-	if (gfs2_is_jdata(ip))
-		error = gfs2_trans_begin(sdp, RES_DINODE + 2 * RES_JDATA,
-					 GFS2_JTRUNC_REVOKES);
-	else
-		error = gfs2_trans_begin(sdp, RES_DINODE, 0);
-	if (error)
-		return error;
-
-	if (gfs2_is_stuffed(ip)) {
-		error = stuffed_zero_range(inode, offset, length);
-		if (error)
-			goto out;
-	} else {
+	if (!gfs2_is_stuffed(ip)) {
 		unsigned int start_off, end_len;
 
 		start_off = offset & (blocksize - 1);
@@ -2487,6 +2476,26 @@ int __gfs2_punch_hole(struct file *file, loff_t offset, loff_t length)
 		}
 	}
 
+	start = round_down(offset, blocksize);
+	end = round_up(offset + length, blocksize) - 1;
+	error = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (error)
+		return error;
+
+	if (gfs2_is_jdata(ip))
+		error = gfs2_trans_begin(sdp, RES_DINODE + 2 * RES_JDATA,
+					 GFS2_JTRUNC_REVOKES);
+	else
+		error = gfs2_trans_begin(sdp, RES_DINODE, 0);
+	if (error)
+		return error;
+
+	if (gfs2_is_stuffed(ip)) {
+		error = stuffed_zero_range(inode, offset, length);
+		if (error)
+			goto out;
+	}
+
 	if (gfs2_is_jdata(ip)) {
 		BUG_ON(!current->journal_info);
 		gfs2_journaled_truncate_range(inode, offset, length);
-- 
2.25.1



