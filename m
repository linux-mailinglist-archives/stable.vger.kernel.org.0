Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AFFA2A51C0
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730748AbgKCUnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:43:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:57580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730737AbgKCUni (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:43:38 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 638CA2224E;
        Tue,  3 Nov 2020 20:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436216;
        bh=zyP1SQE7JxFLTilBxolT5UvQ/9UfKBWQC03ePhvOfJo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYnl86WaoFgJMaU5+R4aRaHaP2P3rtxW2EZslUtZUDtOfeDIZr1uM6Xa0uUxzk+Jr
         bYPnYWrHiQgpyoR6phQOst3Ih5PVGptaNR2EeaZZ0nqDOhvsQ6LjrQOl8vHXMeW9wf
         Smh0Ut+vhqyHV5JuOsB07aSKA35DEcde+bQpJ0IQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Fengnan Chang <changfengnan@hikvision.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 154/391] jbd2: avoid transaction reuse after reformatting
Date:   Tue,  3 Nov 2020 21:33:25 +0100
Message-Id: <20201103203357.224493868@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: changfengnan <fengnanchang@foxmail.com>

[ Upstream commit fc750a3b44bdccb9fb96d6abbc48a9b8e480ce7b ]

When ext4 is formatted with lazy_journal_init=1 and transactions from
the previous filesystem are still on disk, it is possible that they are
considered during a recovery after a crash. Because the checksum seed
has changed, the CRC check will fail, and the journal recovery fails
with checksum error although the journal is otherwise perfectly valid.
Fix the problem by checking commit block time stamps to determine
whether the data in the journal block is just stale or whether it is
indeed corrupt.

Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Fengnan Chang <changfengnan@hikvision.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20201012164900.20197-1-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/recovery.c | 78 +++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 66 insertions(+), 12 deletions(-)

diff --git a/fs/jbd2/recovery.c b/fs/jbd2/recovery.c
index faa97d748474d..fb134c7a12c89 100644
--- a/fs/jbd2/recovery.c
+++ b/fs/jbd2/recovery.c
@@ -428,6 +428,8 @@ static int do_one_pass(journal_t *journal,
 	__u32			crc32_sum = ~0; /* Transactional Checksums */
 	int			descr_csum_size = 0;
 	int			block_error = 0;
+	bool			need_check_commit_time = false;
+	__u64			last_trans_commit_time = 0, commit_time;
 
 	/*
 	 * First thing is to establish what we expect to find in the log
@@ -520,12 +522,21 @@ static int do_one_pass(journal_t *journal,
 			if (descr_csum_size > 0 &&
 			    !jbd2_descriptor_block_csum_verify(journal,
 							       bh->b_data)) {
-				printk(KERN_ERR "JBD2: Invalid checksum "
-				       "recovering block %lu in log\n",
-				       next_log_block);
-				err = -EFSBADCRC;
-				brelse(bh);
-				goto failed;
+				/*
+				 * PASS_SCAN can see stale blocks due to lazy
+				 * journal init. Don't error out on those yet.
+				 */
+				if (pass != PASS_SCAN) {
+					pr_err("JBD2: Invalid checksum recovering block %lu in log\n",
+					       next_log_block);
+					err = -EFSBADCRC;
+					brelse(bh);
+					goto failed;
+				}
+				need_check_commit_time = true;
+				jbd_debug(1,
+					"invalid descriptor block found in %lu\n",
+					next_log_block);
 			}
 
 			/* If it is a valid descriptor block, replay it
@@ -535,6 +546,7 @@ static int do_one_pass(journal_t *journal,
 			if (pass != PASS_REPLAY) {
 				if (pass == PASS_SCAN &&
 				    jbd2_has_feature_checksum(journal) &&
+				    !need_check_commit_time &&
 				    !info->end_transaction) {
 					if (calc_chksums(journal, bh,
 							&next_log_block,
@@ -683,11 +695,41 @@ static int do_one_pass(journal_t *journal,
 			 *	 mentioned conditions. Hence assume
 			 *	 "Interrupted Commit".)
 			 */
+			commit_time = be64_to_cpu(
+				((struct commit_header *)bh->b_data)->h_commit_sec);
+			/*
+			 * If need_check_commit_time is set, it means we are in
+			 * PASS_SCAN and csum verify failed before. If
+			 * commit_time is increasing, it's the same journal,
+			 * otherwise it is stale journal block, just end this
+			 * recovery.
+			 */
+			if (need_check_commit_time) {
+				if (commit_time >= last_trans_commit_time) {
+					pr_err("JBD2: Invalid checksum found in transaction %u\n",
+					       next_commit_ID);
+					err = -EFSBADCRC;
+					brelse(bh);
+					goto failed;
+				}
+			ignore_crc_mismatch:
+				/*
+				 * It likely does not belong to same journal,
+				 * just end this recovery with success.
+				 */
+				jbd_debug(1, "JBD2: Invalid checksum ignored in transaction %u, likely stale data\n",
+					  next_commit_ID);
+				err = 0;
+				brelse(bh);
+				goto done;
+			}
 
-			/* Found an expected commit block: if checksums
-			 * are present verify them in PASS_SCAN; else not
+			/*
+			 * Found an expected commit block: if checksums
+			 * are present, verify them in PASS_SCAN; else not
 			 * much to do other than move on to the next sequence
-			 * number. */
+			 * number.
+			 */
 			if (pass == PASS_SCAN &&
 			    jbd2_has_feature_checksum(journal)) {
 				struct commit_header *cbh =
@@ -719,6 +761,8 @@ static int do_one_pass(journal_t *journal,
 			    !jbd2_commit_block_csum_verify(journal,
 							   bh->b_data)) {
 			chksum_error:
+				if (commit_time < last_trans_commit_time)
+					goto ignore_crc_mismatch;
 				info->end_transaction = next_commit_ID;
 
 				if (!jbd2_has_feature_async_commit(journal)) {
@@ -728,11 +772,24 @@ static int do_one_pass(journal_t *journal,
 					break;
 				}
 			}
+			if (pass == PASS_SCAN)
+				last_trans_commit_time = commit_time;
 			brelse(bh);
 			next_commit_ID++;
 			continue;
 
 		case JBD2_REVOKE_BLOCK:
+			/*
+			 * Check revoke block crc in pass_scan, if csum verify
+			 * failed, check commit block time later.
+			 */
+			if (pass == PASS_SCAN &&
+			    !jbd2_descriptor_block_csum_verify(journal,
+							       bh->b_data)) {
+				jbd_debug(1, "JBD2: invalid revoke block found in %lu\n",
+					  next_log_block);
+				need_check_commit_time = true;
+			}
 			/* If we aren't in the REVOKE pass, then we can
 			 * just skip over this block. */
 			if (pass != PASS_REVOKE) {
@@ -800,9 +857,6 @@ static int scan_revoke_records(journal_t *journal, struct buffer_head *bh,
 	offset = sizeof(jbd2_journal_revoke_header_t);
 	rcount = be32_to_cpu(header->r_count);
 
-	if (!jbd2_descriptor_block_csum_verify(journal, header))
-		return -EFSBADCRC;
-
 	if (jbd2_journal_has_csum_v2or3(journal))
 		csum_size = sizeof(struct jbd2_journal_block_tail);
 	if (rcount > journal->j_blocksize - csum_size)
-- 
2.27.0



