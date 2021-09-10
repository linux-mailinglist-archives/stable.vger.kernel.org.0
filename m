Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E514406399
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 02:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234048AbhIJAsH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 20:48:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234828AbhIJAY2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 20:24:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F245D604DC;
        Fri, 10 Sep 2021 00:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631233398;
        bh=CoxOSkqCcyFoZ1XMxlcsPS7952y2i7A5qqgWVHcmY+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oiTxuf2n1XTtRd6yidev4DWpt/XXQc+UmzEODZkHMrQtx0GMtLos8zxgWTcfu81a1
         A3HRjVc0TGl3XxxOfk/2AVd5N89iRs5Jgc7gwuDUxUNms3zGlzfwk3fZPcQGMOZbk1
         1VRWimixNEEUXqMsj4NMeCw+rdE1eMyqAuU9rMrbvGjzPaL5LxWIRuQhM+rlfxoGHP
         4uEXqKmtGOFdPb3Feh8HU+1BVXMHa+9AEVI0GDCLTY7DSrjLr9pXbL8PaUb0cdrlru
         /9fHORrykFDlQNrFeL2M7QlRbh1mR1F44TI410uQMIaElS63HJrq+ZEppbuZiiX6rq
         wEOm90MNCkRIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 06/19] jbd2: fix portability problems caused by unaligned accesses
Date:   Thu,  9 Sep 2021 20:22:56 -0400
Message-Id: <20210910002309.176412-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210910002309.176412-1-sashal@kernel.org>
References: <20210910002309.176412-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit a20d1cebb98bba75f2e34fddc768dd8712c1bded ]

This commit applies the e2fsck/recovery.c portions of commit
1e0c8ca7c08a ("e2fsck: fix portability problems caused by unaligned
accesses) from the e2fsprogs git tree.

The on-disk format for the ext4 journal can have unaigned 32-bit
integers.  This can happen when replaying a journal using a obsolete
checksum format (which was never popularly used, since the v3 format
replaced v2 while the metadata checksum feature was being stablized).

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/recovery.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index 02dd3360cb20..1b1a94172c08 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -200,7 +200,7 @@ static int jbd2_descriptor_block_csum_verify(journal_t *j, void *buf)
 static int count_tags(journal_t *journal, struct buffer_head *bh)
 {
 	char *			tagp;
-	journal_block_tag_t *	tag;
+	journal_block_tag_t	tag;
 	int			nr = 0, size = journal->j_blocksize;
 	int			tag_bytes = journal_tag_bytes(journal);
 
@@ -210,14 +210,14 @@ static int count_tags(journal_t *journal, struct buffer_head *bh)
 	tagp = &bh->b_data[sizeof(journal_header_t)];
 
 	while ((tagp - bh->b_data + tag_bytes) <= size) {
-		tag = (journal_block_tag_t *) tagp;
+		memcpy(&tag, tagp, sizeof(tag));
 
 		nr++;
 		tagp += tag_bytes;
-		if (!(tag->t_flags & cpu_to_be16(JBD2_FLAG_SAME_UUID)))
+		if (!(tag.t_flags & cpu_to_be16(JBD2_FLAG_SAME_UUID)))
 			tagp += 16;
 
-		if (tag->t_flags & cpu_to_be16(JBD2_FLAG_LAST_TAG))
+		if (tag.t_flags & cpu_to_be16(JBD2_FLAG_LAST_TAG))
 			break;
 	}
 
@@ -397,9 +397,9 @@ static int jbd2_commit_block_csum_verify(journal_t *j, void *buf)
 }
 
 static int jbd2_block_tag_csum_verify(journal_t *j, journal_block_tag_t *tag,
+				      journal_block_tag3_t *tag3,
 				      void *buf, __u32 sequence)
 {
-	journal_block_tag3_t *tag3 = (journal_block_tag3_t *)tag;
 	__u32 csum32;
 	__be32 seq;
 
@@ -458,7 +458,7 @@ static int do_one_pass(journal_t *journal,
 	while (1) {
 		int			flags;
 		char *			tagp;
-		journal_block_tag_t *	tag;
+		journal_block_tag_t	tag;
 		struct buffer_head *	obh;
 		struct buffer_head *	nbh;
 
@@ -563,8 +563,8 @@ static int do_one_pass(journal_t *journal,
 			       <= journal->j_blocksize - descr_csum_size) {
 				unsigned long io_block;
 
-				tag = (journal_block_tag_t *) tagp;
-				flags = be16_to_cpu(tag->t_flags);
+				memcpy(&tag, tagp, sizeof(tag));
+				flags = be16_to_cpu(tag.t_flags);
 
 				io_block = next_log_block++;
 				wrap(journal, next_log_block);
@@ -582,7 +582,7 @@ static int do_one_pass(journal_t *journal,
 
 					J_ASSERT(obh != NULL);
 					blocknr = read_tag_block(journal,
-								 tag);
+								 &tag);
 
 					/* If the block has been
 					 * revoked, then we're all done
@@ -597,8 +597,8 @@ static int do_one_pass(journal_t *journal,
 
 					/* Look for block corruption */
 					if (!jbd2_block_tag_csum_verify(
-						journal, tag, obh->b_data,
-						be32_to_cpu(tmp->h_sequence))) {
+			journal, &tag, (journal_block_tag3_t *)tagp,
+			obh->b_data, be32_to_cpu(tmp->h_sequence))) {
 						brelse(obh);
 						success = -EFSBADCRC;
 						printk(KERN_ERR "JBD2: Invalid "
-- 
2.30.2

