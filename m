Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29720FF27C
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbfKPQTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:19:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:52466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729317AbfKPPqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:46:12 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74E7520871;
        Sat, 16 Nov 2019 15:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573919172;
        bh=Vt4u48HOCbcz3ybOMB9dVcvqoXTpvruV+PEMafpIE0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AX4ZXBZajY9K7W4de4zIrVZQYnF7hjB4BRpjyjqOnigNVC0w6M0GsAlauxztUioX3
         2orTYC0fOtqO+dt4TIVMF4oF8UiZsTXYXpeWMJlWjV6Ntqk4obsK+0C9uhABJltsyc
         zvU4++TkOPiL+ovWalEHcQbJRx9TdqfcratCyceU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Changwei Ge <ge.changwei@h3c.com>,
        Guozhonghua <guozhonghua@h3c.com>, Mark Fasheh <mark@fasheh.com>,
        Joel Becker <jlbec@evilplan.org>,
        Junxiao Bi <junxiao.bi@oracle.com>,
        Joseph Qi <jiangqi903@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 181/237] ocfs2: don't put and assigning null to bh allocated outside
Date:   Sat, 16 Nov 2019 10:40:16 -0500
Message-Id: <20191116154113.7417-181-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 9f8250df99f1f..f9b84f7a3e4bb 100644
--- a/fs/ocfs2/buffer_head_io.c
+++ b/fs/ocfs2/buffer_head_io.c
@@ -99,25 +99,34 @@ int ocfs2_write_block(struct ocfs2_super *osb, struct buffer_head *bh,
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
@@ -157,9 +166,26 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
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
@@ -169,8 +195,7 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 			 * so we can safely record this and loop back
 			 * to cleanup the other buffers. */
 			status = -EIO;
-			put_bh(bh);
-			bhs[i - 1] = NULL;
+			goto read_failure;
 		}
 	}
 
@@ -178,6 +203,9 @@ int ocfs2_read_blocks_sync(struct ocfs2_super *osb, u64 block,
 	return status;
 }
 
+/* Caller must provide a bhs[] with all NULL or non-NULL entries, so it
+ * will be easier to handle read failure.
+ */
 int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 		      struct buffer_head *bhs[], int flags,
 		      int (*validate)(struct super_block *sb,
@@ -187,6 +215,7 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 	int i, ignore_cache = 0;
 	struct buffer_head *bh;
 	struct super_block *sb = ocfs2_metadata_cache_get_super(ci);
+	int new_bh = 0;
 
 	trace_ocfs2_read_blocks_begin(ci, (unsigned long long)block, nr, flags);
 
@@ -212,6 +241,11 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
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
@@ -220,7 +254,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 				ocfs2_metadata_cache_io_unlock(ci);
 				status = -ENOMEM;
 				mlog_errno(status);
-				goto bail;
+				/* Don't forget to put previous bh! */
+				break;
 			}
 		}
 		bh = bhs[i];
@@ -314,16 +349,27 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
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
@@ -341,9 +387,7 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
 				 * uptodate. */
 				status = -EIO;
 				clear_buffer_needs_validate(bh);
-				put_bh(bh);
-				bhs[i] = NULL;
-				continue;
+				goto read_failure;
 			}
 
 			if (buffer_needs_validate(bh)) {
@@ -353,11 +397,8 @@ int ocfs2_read_blocks(struct ocfs2_caching_info *ci, u64 block, int nr,
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

