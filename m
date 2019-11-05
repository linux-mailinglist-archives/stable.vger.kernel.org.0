Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 941AAF033C
	for <lists+stable@lfdr.de>; Tue,  5 Nov 2019 17:44:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390343AbfKEQoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Nov 2019 11:44:39 -0500
Received: from mx2.suse.de ([195.135.220.15]:41514 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390335AbfKEQoj (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Nov 2019 11:44:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 9C278AF3F;
        Tue,  5 Nov 2019 16:44:37 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 26B691E420F; Tue,  5 Nov 2019 17:44:37 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     Ted Tso <tytso@mit.edu>
Cc:     <linux-ext4@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 01/25] jbd2: Fix possible overflow in jbd2_log_space_left()
Date:   Tue,  5 Nov 2019 17:44:07 +0100
Message-Id: <20191105164437.32602-1-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20191003215523.7313-1-jack@suse.cz>
References: <20191003215523.7313-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When number of free space in the journal is very low, the arithmetic in
jbd2_log_space_left() could underflow resulting in very high number of
free blocks and thus triggering assertion failure in transaction commit
code complaining there's not enough space in the journal:

J_ASSERT(journal->j_free > 1);

Properly check for the low number of free blocks.

CC: stable@vger.kernel.org
Reviewed-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 include/linux/jbd2.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 603fbc4e2f70..10e6049c0ba9 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1582,7 +1582,7 @@ static inline int jbd2_space_needed(journal_t *journal)
 static inline unsigned long jbd2_log_space_left(journal_t *journal)
 {
 	/* Allow for rounding errors */
-	unsigned long free = journal->j_free - 32;
+	long free = journal->j_free - 32;
 
 	if (journal->j_committing_transaction) {
 		unsigned long committing = atomic_read(&journal->
@@ -1591,7 +1591,7 @@ static inline unsigned long jbd2_log_space_left(journal_t *journal)
 		/* Transaction + control blocks */
 		free -= committing + (committing >> JBD2_CONTROL_BLOCKS_SHIFT);
 	}
-	return free;
+	return max_t(long, free, 0);
 }
 
 /*
-- 
2.16.4

