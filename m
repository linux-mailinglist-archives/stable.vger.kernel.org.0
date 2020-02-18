Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3041A162528
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 12:01:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbgBRLBL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 06:01:11 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10207 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726363AbgBRLBL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 06:01:11 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 4CEF49279E823156A4A0;
        Tue, 18 Feb 2020 19:01:04 +0800 (CST)
Received: from huawei.com (10.175.124.28) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Tue, 18 Feb 2020
 19:00:57 +0800
From:   "zhangyi (F)" <yi.zhang@huawei.com>
To:     <gregkh@linuxfoundation.org>
CC:     <stable@vger.kernel.org>, <jack@suse.cz>, <tytso@mit.edu>,
        <yi.zhang@huawei.com>
Subject: [PATCH 5.4 1/2] jbd2: move the clearing of b_modified flag to the journal_unmap_buffer()
Date:   Tue, 18 Feb 2020 18:59:52 +0800
Message-ID: <20200218105953.10684-1-yi.zhang@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6a66a7ded12baa6ebbb2e3e82f8cb91382814839 ]

There is no need to delay the clearing of b_modified flag to the
transaction committing time when unmapping the journalled buffer, so
just move it to the journal_unmap_buffer().

Link: https://lore.kernel.org/r/20200213063821.30455-2-yi.zhang@huawei.com
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
---
 fs/jbd2/commit.c      | 43 +++++++++++++++----------------------------
 fs/jbd2/transaction.c | 10 ++++++----
 2 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/fs/jbd2/commit.c b/fs/jbd2/commit.c
index c43591cd70f1..7fdb5f130f64 100644
--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -974,34 +974,21 @@ void jbd2_journal_commit_transaction(journal_t *journal)
 		 * it. */
 
 		/*
-		* A buffer which has been freed while still being journaled by
-		* a previous transaction.
-		*/
-		if (buffer_freed(bh)) {
-			/*
-			 * If the running transaction is the one containing
-			 * "add to orphan" operation (b_next_transaction !=
-			 * NULL), we have to wait for that transaction to
-			 * commit before we can really get rid of the buffer.
-			 * So just clear b_modified to not confuse transaction
-			 * credit accounting and refile the buffer to
-			 * BJ_Forget of the running transaction. If the just
-			 * committed transaction contains "add to orphan"
-			 * operation, we can completely invalidate the buffer
-			 * now. We are rather through in that since the
-			 * buffer may be still accessible when blocksize <
-			 * pagesize and it is attached to the last partial
-			 * page.
-			 */
-			jh->b_modified = 0;
-			if (!jh->b_next_transaction) {
-				clear_buffer_freed(bh);
-				clear_buffer_jbddirty(bh);
-				clear_buffer_mapped(bh);
-				clear_buffer_new(bh);
-				clear_buffer_req(bh);
-				bh->b_bdev = NULL;
-			}
+		 * A buffer which has been freed while still being journaled
+		 * by a previous transaction, refile the buffer to BJ_Forget of
+		 * the running transaction. If the just committed transaction
+		 * contains "add to orphan" operation, we can completely
+		 * invalidate the buffer now. We are rather through in that
+		 * since the buffer may be still accessible when blocksize <
+		 * pagesize and it is attached to the last partial page.
+		 */
+		if (buffer_freed(bh) && !jh->b_next_transaction) {
+			clear_buffer_freed(bh);
+			clear_buffer_jbddirty(bh);
+			clear_buffer_mapped(bh);
+			clear_buffer_new(bh);
+			clear_buffer_req(bh);
+			bh->b_bdev = NULL;
 		}
 
 		if (buffer_jbddirty(bh)) {
diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
index bee8498d7792..3930c68a9c20 100644
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2296,14 +2296,16 @@ static int journal_unmap_buffer(journal_t *journal, struct buffer_head *bh,
 			return -EBUSY;
 		}
 		/*
-		 * OK, buffer won't be reachable after truncate. We just set
-		 * j_next_transaction to the running transaction (if there is
-		 * one) and mark buffer as freed so that commit code knows it
-		 * should clear dirty bits when it is done with the buffer.
+		 * OK, buffer won't be reachable after truncate. We just clear
+		 * b_modified to not confuse transaction credit accounting, and
+		 * set j_next_transaction to the running transaction (if there
+		 * is one) and mark buffer as freed so that commit code knows
+		 * it should clear dirty bits when it is done with the buffer.
 		 */
 		set_buffer_freed(bh);
 		if (journal->j_running_transaction && buffer_jbddirty(bh))
 			jh->b_next_transaction = journal->j_running_transaction;
+		jh->b_modified = 0;
 		jbd2_journal_put_journal_head(jh);
 		spin_unlock(&journal->j_list_lock);
 		jbd_unlock_bh_state(bh);
-- 
2.17.2

