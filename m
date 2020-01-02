Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5025F12F03B
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729201AbgABWvm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:51:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:46792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729074AbgABWXt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:23:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCCB0222C3;
        Thu,  2 Jan 2020 22:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003829;
        bh=SRw83uJ4+3JRA4I99HLao4ZorzfbTvQ0yCMarohdFR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E6Q8ecVaApPqY18R4urGfaNnfotpwAWk0Mw/gZerivFhMzK5tAV1/91NKP5+TCQo8
         vDc1g47Kq5GsG2+vaV7dmKkCebQSh7Xjb1E93SfTpK4Jzy1m1JFD0F/8WYpUIIYGcH
         BkwPvJBtrW/s0+J8ltt0snF78OTLCu97XVklpT2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Theodore Tso <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 17/91] jbd2: Fix statistics for the number of logged blocks
Date:   Thu,  2 Jan 2020 23:06:59 +0100
Message-Id: <20200102220416.130348835@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102220356.856162165@linuxfoundation.org>
References: <20200102220356.856162165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0567b17a970c..7dd613392592 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -726,7 +726,6 @@ start_journal_io:
 				submit_bh(REQ_OP_WRITE, REQ_SYNC, bh);
 			}
 			cond_resched();
-			stats.run.rs_blocks_logged += bufs;
 
 			/* Force a new descriptor to be generated next
                            time round the loop. */
@@ -813,6 +812,7 @@ start_journal_io:
 		if (unlikely(!buffer_uptodate(bh)))
 			err = -EIO;
 		jbd2_unfile_log_bh(bh);
+		stats.run.rs_blocks_logged++;
 
 		/*
 		 * The list contains temporary buffer heads created by
@@ -858,6 +858,7 @@ start_journal_io:
 		BUFFER_TRACE(bh, "ph5: control buffer writeout done: unfile");
 		clear_buffer_jwrite(bh);
 		jbd2_unfile_log_bh(bh);
+		stats.run.rs_blocks_logged++;
 		__brelse(bh);		/* One for getblk */
 		/* AKPM: bforget here */
 	}
@@ -879,6 +880,7 @@ start_journal_io:
 	}
 	if (cbh)
 		err = journal_wait_on_commit_record(journal, cbh);
+	stats.run.rs_blocks_logged++;
 	if (jbd2_has_feature_async_commit(journal) &&
 	    journal->j_flags & JBD2_BARRIER) {
 		blkdev_issue_flush(journal->j_dev, GFP_NOFS, NULL);
-- 
2.20.1



