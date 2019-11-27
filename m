Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 433A710B864
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbfK0Um4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:42:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:49726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729372AbfK0Umx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:42:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C9E41215A4;
        Wed, 27 Nov 2019 20:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887372;
        bh=AOzwc6nHGmg4oVDPLB8ouoaKqwdKAmVHFY5iyrSIGYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yit6kDaf/bBq336zxMtspBJvRY1I6+AdRi1WHrVtGnWRYQAQvOGHB81neAlLN9lrs
         7RcQ03GQSNCzqBp0DYF8d5Bdq3bdzyTpf0U/PbeIjSc945khpqjZwC4HETr8Fy4iRa
         HokgNmtemEbfL11siMWemGbbBk3HoHXM+FnSJ7do=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Changwei Ge <ge.changwei@h3c.com>,
        Guozhonghua <guozhonghua@h3c.com>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Joseph Qi <jiangqi903@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 085/151] ocfs2: dont put and assigning null to bh allocated outside
Date:   Wed, 27 Nov 2019 21:31:08 +0100
Message-Id: <20191127203036.591821349@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Changwei Ge <ge.changwei@h3c.com>

[ Upstream commit cf76c78595ca87548ca5e45c862ac9e0949c4687 ]

ocfs2_read_blocks() and ocfs2_read_blocks_sync() are both used to read
several blocks from disk.  Currently, the input argument *bhs* can be
NULL or NOT.  It depends on the caller's behavior.  If the function
fails in reading blocks from disk, the corresponding bh will be assigned
to NULL and put.

Obviously, above process for non-NULL input bh is not appropriate.
Because the caller doesn't even know its bhs are put and re-assigned.

If buffer head is managed by caller, ocfs2_read_blocks and
ocfs2_read_blocks_sync() should not evaluate it to NULL.  It will cause
caller accessing illegal memory, thus crash.

Link: http://lkml.kernel.org/r/HK2PR06MB045285E0F4FBB561F9F2F9B3D5680@HK2PR06MB0452.apcprd06.prod.outlook.com
Signed-off-by: Changwei Ge <ge.changwei@h3c.com>
Reviewed-by: Guozhonghua <guozhonghua@h3c.com>
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <jiangqi903@gmail.com>
Cc: Changwei Ge <ge.changwei@h3c.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ocfs2/buffer_head_io.c | 77 ++++++++++++++++++++++++++++++---------
 1 file changed, 59 insertions(+), 18 deletions(-)

diff --git a/fs/ocfs2/buffer_head_io.c b/fs/ocfs2/buffer_head_io.c
index 935bac253991b..1403c88f2b053 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -98,25 +98,34 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
 	return ret;
 }
 
+/* Caller must provide a bhs[] with all NULL or non-NULL entries, so it
+ * will be easier to handle read failure.
+ */
 int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 			   unsigned int nr, struct buffer_head *bhs[])
 {
 	int status = 0;
 	unsigned int i;
 	struct buffer_head *bh;
+	int new_bh = 0;
 
 	trace_ocfs2_read_blocks_sync((unsigned long long)block, nr);
 
 	if (!nr)
 		goto bail;
 
+	/* Don't put buffer head and re-assign it to NULL if it is allocated
+	 * outside since the caller can't be aware of this alternation!
+	 */
+	new_bh = (bhs[0] == NULL);
+
 	for (i = 0 ; i < nr ; i++) {
 		if (bhs[i] == NULL) {
 			bhs[i] = sb_getblk(osb->sb, block++);
 			if (bhs[i] == NULL) {
 				status = -ENOMEM;
 				mlog_errno(status);
-				goto bail;
+				break;
 			}
 		}
 		bh = bhs[i];
@@ -156,9 +165,26 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 		submit_bh(REQ_OP_READ, 0, bh);
 	}
 
+read_failure:
 	for (i = nr; i > 0; i--) {
 		bh = bhs[i - 1];
 
+		if (unlikely(status)) {
+			if (new_bh && bh) {
+				/* If middle bh fails, let previous bh
+				 * finish its read and then put it to
+				 * aovoid bh leak
+				 */
+				if (!buffer_jbd(bh))
+					wait_on_buffer(bh);
+				put_bh(bh);
+				bhs[i - 1] = NULL;
+			} else if (bh && buffer_uptodate(bh)) {
+				clear_buffer_uptodate(bh);
+			}
+			continue;
+		}
+
 		/* No need to wait on the buffer if it's managed by JBD. */
 		if (!buffer_jbd(bh))
 			wait_on_buffer(bh);
@@ -168,8 +194,7 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 			 * so we can safely record this and loop back
 			 * to cleanup the other buffers. */
 			status = -EIO;
-			put_bh(bh);
-			bhs[i - 1] = NULL;
+			goto read_failure;
 		}
 	}
 
@@ -177,6 +202,9 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 	return status;
 }
 
+/* Caller must provide a bhs[] with all NULL or non-NULL entries, so it
+ * will be easier to handle read failure.
+ */
 int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 		      struct buffer_head *bhs[], int flags,
 		      int (*validate)(struct super_block *sb,
@@ -186,6 +214,7 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 	int i, ignore_cache = 0;
 	struct buffer_head *bh;
 	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
+	int new_bh = 0;
 
 	trace_ocfs2_read_blocks_begin(ci, (unsigned long long)block, nr, flags);
 
@@ -211,6 +240,11 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 		goto bail;
 	}
 
+	/* Don't put buffer head and re-assign it to NULL if it is allocated
+	 * outside since the caller can't be aware of this alternation!
+	 */
+	new_bh = (bhs[0] == NULL);
+
 	ocfs2_metadata_cache_io_lock(ci);
 	for (i = 0 ; i < nr ; i++) {
 		if (bhs[i] == NULL) {
@@ -219,7 +253,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 				ocfs2_metadata_cache_io_unlock(ci);
 				status = -ENOMEM;
 				mlog_errno(status);
-				goto bail;
+				/* Don't forget to put previous bh! */
+				break;
 			}
 		}
 		bh = bhs[i];
@@ -313,16 +348,27 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 		}
 	}
 
-	status = 0;
-
+read_failure:
 	for (i = (nr - 1); i >= 0; i--) {
 		bh = bhs[i];
 
 		if (!(flags & OCFS2_BH_READAHEAD)) {
-			if (status) {
-				/* Clear the rest of the buffers on error */
-				put_bh(bh);
-				bhs[i] = NULL;
+			if (unlikely(status)) {
+				/* Clear the buffers on error including those
+				 * ever succeeded in reading
+				 */
+				if (new_bh && bh) {
+					/* If middle bh fails, let previous bh
+					 * finish its read and then put it to
+					 * aovoid bh leak
+					 */
+					if (!buffer_jbd(bh))
+						wait_on_buffer(bh);
+					put_bh(bh);
+					bhs[i] = NULL;
+				} else if (bh && buffer_uptodate(bh)) {
+					clear_buffer_uptodate(bh);
+				}
 				continue;
 			}
 			/* We know this can't have changed as we hold the
@@ -340,9 +386,7 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 				 * uptodate. */
 				status = -EIO;
 				clear_buffer_needs_validate(bh);
-				put_bh(bh);
-				bhs[i] = NULL;
-				continue;
+				goto read_failure;
 			}
 
 			if (buffer_needs_validate(bh)) {
@@ -352,11 +396,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 				BUG_ON(buffer_jbd(bh));
 				clear_buffer_needs_validate(bh);
 				status = validate(sb, bh);
-				if (status) {
-					put_bh(bh);
-					bhs[i] = NULL;
-					continue;
-				}
+				if (status)
+					goto read_failure;
 			}
 		}
 
-- 
2.20.1



