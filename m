Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C56BE11B2BC
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387536AbfLKPhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:37:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388098AbfLKPfZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:35:25 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9670022B48;
        Wed, 11 Dec 2019 15:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078525;
        bh=7OTXKHMyZQdmv+WVq286A13gtGQFrZqRiEqEhDM10g8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jahoev7jZnk5B5TIrYGpxCFCAQ4Yfx8pc2aEceSVqwpADs83ipvQTDLiF7u26pIH1
         EfYwrPf0KFPa5KhTC00tzE9qQQECvB215rGa9vDXBRF/HoJv4BPw3UfuuxvqLu1yEA
         9D0+qFBAUxCaNa7BbL9EHNse3RGgliQW3npUKAfw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jan Kara <jack@suse.cz>, Theodore Ts'o <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>, linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 14/42] jbd2: Fix statistics for the number of logged blocks
Date:   Wed, 11 Dec 2019 10:34:42 -0500
Message-Id: <20191211153510.23861-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211153510.23861-1-sashal@kernel.org>
References: <20191211153510.23861-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

[ Upstream commit 015c6033068208d6227612c878877919f3fcf6b6 ]

jbd2 statistics counting number of blocks logged in a transaction was
wrong. It didn't count the commit block and more importantly it didn't
count revoke descriptor blocks. Make sure these get properly counted.

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191105164437.32602-13-jack@suse.cz
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/commit.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index 10ec276761913..d002b2b6895fe 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -722,7 +722,6 @@ start_journal_io:
 				submit_bh(REQ_OP_WRITE, WRITE_SYNC, bh);
 			}
 			cond_resched();
-			stats.run.rs_blocks_logged += bufs;
 
 			/* Force a new descriptor to be generated next
                            time round the loop. */
@@ -809,6 +808,7 @@ start_journal_io:
 		if (unlikely(!buffer_uptodate(bh)))
 			err = -EIO;
 		jbd2_unfile_log_bh(bh);
+		stats.run.rs_blocks_logged++;
 
 		/*
 		 * The list contains temporary buffer heads created by
@@ -854,6 +854,7 @@ start_journal_io:
 		BUFFER_TRACE(bh, "ph5: control buffer writeout done: unfile");
 		clear_buffer_jwrite(bh);
 		jbd2_unfile_log_bh(bh);
+		stats.run.rs_blocks_logged++;
 		__brelse(bh);		/* One for getblk */
 		/* AKPM: bforget here */
 	}
@@ -875,6 +876,7 @@ start_journal_io:
 	}
 	if (cbh)
 		err = journal_wait_on_commit_record(journal, cbh);
+	stats.run.rs_blocks_logged++;
 	if (jbd2_has_feature_async_commit(journal) &&
 	    journal->j_flags & JBD2_BARRIER) {
 		blkdev_issue_flush(journal->j_dev, GFP_NOFS, NULL);
-- 
2.20.1

