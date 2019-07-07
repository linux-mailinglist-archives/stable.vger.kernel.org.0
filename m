Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7FA616FB
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728051AbfGGToW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:44:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57330 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727555AbfGGTiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:09 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz5-0006gs-BW; Sun, 07 Jul 2019 20:38:03 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz3-0005an-UT; Sun, 07 Jul 2019 20:38:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "zhangyi (F)" <yi.zhang@huawei.com>, "Jan Kara" <jack@suse.cz>,
        "Theodore Ts'o" <tytso@mit.edu>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.585148062@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 056/129] jbd2: clear dirty flag when revoking a
 buffer from an older transaction
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "zhangyi (F)" <yi.zhang@huawei.com>

commit 904cdbd41d749a476863a0ca41f6f396774f26e4 upstream.

Now, we capture a data corruption problem on ext4 while we're truncating
an extent index block. Imaging that if we are revoking a buffer which
has been journaled by the committing transaction, the buffer's jbddirty
flag will not be cleared in jbd2_journal_forget(), so the commit code
will set the buffer dirty flag again after refile the buffer.

fsx                               kjournald2
                                  jbd2_journal_commit_transaction
jbd2_journal_revoke                commit phase 1~5...
 jbd2_journal_forget
   belongs to older transaction    commit phase 6
   jbddirty not clear               __jbd2_journal_refile_buffer
                                     __jbd2_journal_unfile_buffer
                                      test_clear_buffer_jbddirty
                                       mark_buffer_dirty

Finally, if the freed extent index block was allocated again as data
block by some other files, it may corrupt the file data after writing
cached pages later, such as during unmount time. (In general,
clean_bdev_aliases() related helpers should be invoked after
re-allocation to prevent the above corruption, but unfortunately we
missed it when zeroout the head of extra extent blocks in
ext4_ext_handle_unwritten_extents()).

This patch mark buffer as freed and set j_next_transaction to the new
transaction when it already belongs to the committing transaction in
jbd2_journal_forget(), so that commit code knows it should clear dirty
bits when it is done with the buffer.

This problem can be reproduced by xfstests generic/455 easily with
seeds (3246 3247 3248 3249).

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/jbd2/transaction.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -1479,14 +1479,21 @@ int jbd2_journal_forget (handle_t *handl
 		/* However, if the buffer is still owned by a prior
 		 * (committing) transaction, we can't drop it yet... */
 		JBUFFER_TRACE(jh, "belongs to older transaction");
-		/* ... but we CAN drop it from the new transaction if we
-		 * have also modified it since the original commit. */
+		/* ... but we CAN drop it from the new transaction through
+		 * marking the buffer as freed and set j_next_transaction to
+		 * the new transaction, so that not only the commit code
+		 * knows it should clear dirty bits when it is done with the
+		 * buffer, but also the buffer can be checkpointed only
+		 * after the new transaction commits. */
 
-		if (jh->b_next_transaction) {
-			J_ASSERT(jh->b_next_transaction == transaction);
+		set_buffer_freed(bh);
+
+		if (!jh->b_next_transaction) {
 			spin_lock(&journal->j_list_lock);
-			jh->b_next_transaction = NULL;
+			jh->b_next_transaction = transaction;
 			spin_unlock(&journal->j_list_lock);
+		} else {
+			J_ASSERT(jh->b_next_transaction == transaction);
 
 			/*
 			 * only drop a reference if this transaction modified

