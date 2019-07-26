Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DB6E76CDD
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388325AbfGZP2I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:28:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388350AbfGZP2F (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:28:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F203205F4;
        Fri, 26 Jul 2019 15:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154884;
        bh=X4a6S48XDpjtzjwKzWAhTHiGq4G0dyB07eCAgVndoV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FN3kEw4NrWmyYtoufQbpQcT+Sk8sICqwChX6nRlw++X7OuhoMk4j3fj/5a/Ir9wGu
         I+fceeChdVNhg+4vdRXtIdw1ANErqzAE6qPm++P1NMmDIS3bd5G4U6hQjukFA8KbYr
         0XPBqh5CZXAWR3ppUREOiKZxBres8beZQmiERdGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ross Zwisler <zwisler@google.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>
Subject: [PATCH 5.2 59/66] jbd2: introduce jbd2_inode dirty range scoping
Date:   Fri, 26 Jul 2019 17:24:58 +0200
Message-Id: <20190726152308.189239072@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ross Zwisler <zwisler@chromium.org>

commit 6ba0e7dc64a5adcda2fbe65adc466891795d639e upstream.

Currently both journal_submit_inode_data_buffers() and
journal_finish_inode_data_buffers() operate on the entire address space
of each of the inodes associated with a given journal entry.  The
consequence of this is that if we have an inode where we are constantly
appending dirty pages we can end up waiting for an indefinite amount of
time in journal_finish_inode_data_buffers() while we wait for all the
pages under writeback to be written out.

The easiest way to cause this type of workload is do just dd from
/dev/zero to a file until it fills the entire filesystem.  This can
cause journal_finish_inode_data_buffers() to wait for the duration of
the entire dd operation.

We can improve this situation by scoping each of the inode dirty ranges
associated with a given transaction.  We do this via the jbd2_inode
structure so that the scoping is contained within jbd2 and so that it
follows the lifetime and locking rules for that structure.

This allows us to limit the writeback & wait in
journal_submit_inode_data_buffers() and
journal_finish_inode_data_buffers() respectively to the dirty range for
a given struct jdb2_inode, keeping us from waiting forever if the inode
in question is still being appended to.

Signed-off-by: Ross Zwisler <zwisler@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/jbd2/commit.c      |   23 +++++++++++++++++------
 fs/jbd2/journal.c     |    4 ++++
 fs/jbd2/transaction.c |   49 ++++++++++++++++++++++++++++---------------------
 include/linux/jbd2.h  |   22 ++++++++++++++++++++++
 4 files changed, 71 insertions(+), 27 deletions(-)

--- a/fs/jbd2/commit.c
+++ b/fs/jbd2/commit.c
@@ -187,14 +187,15 @@ static int journal_wait_on_commit_record
  * use writepages() because with dealyed allocation we may be doing
  * block allocation in writepages().
  */
-static int journal_submit_inode_data_buffers(struct address_space *mapping)
+static int journal_submit_inode_data_buffers(struct address_space *mapping,
+		loff_t dirty_start, loff_t dirty_end)
 {
 	int ret;
 	struct writeback_control wbc = {
 		.sync_mode =  WB_SYNC_ALL,
 		.nr_to_write = mapping->nrpages * 2,
-		.range_start = 0,
-		.range_end = i_size_read(mapping->host),
+		.range_start = dirty_start,
+		.range_end = dirty_end,
 	};
 
 	ret = generic_writepages(mapping, &wbc);
@@ -218,6 +219,9 @@ static int journal_submit_data_buffers(j
 
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
+		loff_t dirty_start = jinode->i_dirty_start;
+		loff_t dirty_end = jinode->i_dirty_end;
+
 		if (!(jinode->i_flags & JI_WRITE_DATA))
 			continue;
 		mapping = jinode->i_vfs_inode->i_mapping;
@@ -230,7 +234,8 @@ static int journal_submit_data_buffers(j
 		 * only allocated blocks here.
 		 */
 		trace_jbd2_submit_inode_data(jinode->i_vfs_inode);
-		err = journal_submit_inode_data_buffers(mapping);
+		err = journal_submit_inode_data_buffers(mapping, dirty_start,
+				dirty_end);
 		if (!ret)
 			ret = err;
 		spin_lock(&journal->j_list_lock);
@@ -257,12 +262,16 @@ static int journal_finish_inode_data_buf
 	/* For locking, see the comment in journal_submit_data_buffers() */
 	spin_lock(&journal->j_list_lock);
 	list_for_each_entry(jinode, &commit_transaction->t_inode_list, i_list) {
+		loff_t dirty_start = jinode->i_dirty_start;
+		loff_t dirty_end = jinode->i_dirty_end;
+
 		if (!(jinode->i_flags & JI_WAIT_DATA))
 			continue;
 		jinode->i_flags |= JI_COMMIT_RUNNING;
 		spin_unlock(&journal->j_list_lock);
-		err = filemap_fdatawait_keep_errors(
-				jinode->i_vfs_inode->i_mapping);
+		err = filemap_fdatawait_range_keep_errors(
+				jinode->i_vfs_inode->i_mapping, dirty_start,
+				dirty_end);
 		if (!ret)
 			ret = err;
 		spin_lock(&journal->j_list_lock);
@@ -282,6 +291,8 @@ static int journal_finish_inode_data_buf
 				&jinode->i_transaction->t_inode_list);
 		} else {
 			jinode->i_transaction = NULL;
+			jinode->i_dirty_start = 0;
+			jinode->i_dirty_end = 0;
 		}
 	}
 	spin_unlock(&journal->j_list_lock);
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -94,6 +94,8 @@ EXPORT_SYMBOL(jbd2_journal_try_to_free_b
 EXPORT_SYMBOL(jbd2_journal_force_commit);
 EXPORT_SYMBOL(jbd2_journal_inode_add_write);
 EXPORT_SYMBOL(jbd2_journal_inode_add_wait);
+EXPORT_SYMBOL(jbd2_journal_inode_ranged_write);
+EXPORT_SYMBOL(jbd2_journal_inode_ranged_wait);
 EXPORT_SYMBOL(jbd2_journal_init_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
@@ -2574,6 +2576,8 @@ void jbd2_journal_init_jbd_inode(struct
 	jinode->i_next_transaction = NULL;
 	jinode->i_vfs_inode = inode;
 	jinode->i_flags = 0;
+	jinode->i_dirty_start = 0;
+	jinode->i_dirty_end = 0;
 	INIT_LIST_HEAD(&jinode->i_list);
 }
 
--- a/fs/jbd2/transaction.c
+++ b/fs/jbd2/transaction.c
@@ -2565,7 +2565,7 @@ void jbd2_journal_refile_buffer(journal_
  * File inode in the inode list of the handle's transaction
  */
 static int jbd2_journal_file_inode(handle_t *handle, struct jbd2_inode *jinode,
-				   unsigned long flags)
+		unsigned long flags, loff_t start_byte, loff_t end_byte)
 {
 	transaction_t *transaction = handle->h_transaction;
 	journal_t *journal;
@@ -2577,26 +2577,17 @@ static int jbd2_journal_file_inode(handl
 	jbd_debug(4, "Adding inode %lu, tid:%d\n", jinode->i_vfs_inode->i_ino,
 			transaction->t_tid);
 
-	/*
-	 * First check whether inode isn't already on the transaction's
-	 * lists without taking the lock. Note that this check is safe
-	 * without the lock as we cannot race with somebody removing inode
-	 * from the transaction. The reason is that we remove inode from the
-	 * transaction only in journal_release_jbd_inode() and when we commit
-	 * the transaction. We are guarded from the first case by holding
-	 * a reference to the inode. We are safe against the second case
-	 * because if jinode->i_transaction == transaction, commit code
-	 * cannot touch the transaction because we hold reference to it,
-	 * and if jinode->i_next_transaction == transaction, commit code
-	 * will only file the inode where we want it.
-	 */
-	if ((jinode->i_transaction == transaction ||
-	    jinode->i_next_transaction == transaction) &&
-	    (jinode->i_flags & flags) == flags)
-		return 0;
-
 	spin_lock(&journal->j_list_lock);
 	jinode->i_flags |= flags;
+
+	if (jinode->i_dirty_end) {
+		jinode->i_dirty_start = min(jinode->i_dirty_start, start_byte);
+		jinode->i_dirty_end = max(jinode->i_dirty_end, end_byte);
+	} else {
+		jinode->i_dirty_start = start_byte;
+		jinode->i_dirty_end = end_byte;
+	}
+
 	/* Is inode already attached where we need it? */
 	if (jinode->i_transaction == transaction ||
 	    jinode->i_next_transaction == transaction)
@@ -2631,12 +2622,28 @@ done:
 int jbd2_journal_inode_add_write(handle_t *handle, struct jbd2_inode *jinode)
 {
 	return jbd2_journal_file_inode(handle, jinode,
-				       JI_WRITE_DATA | JI_WAIT_DATA);
+			JI_WRITE_DATA | JI_WAIT_DATA, 0, LLONG_MAX);
 }
 
 int jbd2_journal_inode_add_wait(handle_t *handle, struct jbd2_inode *jinode)
 {
-	return jbd2_journal_file_inode(handle, jinode, JI_WAIT_DATA);
+	return jbd2_journal_file_inode(handle, jinode, JI_WAIT_DATA, 0,
+			LLONG_MAX);
+}
+
+int jbd2_journal_inode_ranged_write(handle_t *handle,
+		struct jbd2_inode *jinode, loff_t start_byte, loff_t length)
+{
+	return jbd2_journal_file_inode(handle, jinode,
+			JI_WRITE_DATA | JI_WAIT_DATA, start_byte,
+			start_byte + length - 1);
+}
+
+int jbd2_journal_inode_ranged_wait(handle_t *handle, struct jbd2_inode *jinode,
+		loff_t start_byte, loff_t length)
+{
+	return jbd2_journal_file_inode(handle, jinode, JI_WAIT_DATA,
+			start_byte, start_byte + length - 1);
 }
 
 /*
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -451,6 +451,22 @@ struct jbd2_inode {
 	 * @i_flags: Flags of inode [j_list_lock]
 	 */
 	unsigned long i_flags;
+
+	/**
+	 * @i_dirty_start:
+	 *
+	 * Offset in bytes where the dirty range for this inode starts.
+	 * [j_list_lock]
+	 */
+	loff_t i_dirty_start;
+
+	/**
+	 * @i_dirty_end:
+	 *
+	 * Inclusive offset in bytes where the dirty range for this inode
+	 * ends. [j_list_lock]
+	 */
+	loff_t i_dirty_end;
 };
 
 struct jbd2_revoke_table_s;
@@ -1397,6 +1413,12 @@ extern int	   jbd2_journal_force_commit(
 extern int	   jbd2_journal_force_commit_nested(journal_t *);
 extern int	   jbd2_journal_inode_add_write(handle_t *handle, struct jbd2_inode *inode);
 extern int	   jbd2_journal_inode_add_wait(handle_t *handle, struct jbd2_inode *inode);
+extern int	   jbd2_journal_inode_ranged_write(handle_t *handle,
+			struct jbd2_inode *inode, loff_t start_byte,
+			loff_t length);
+extern int	   jbd2_journal_inode_ranged_wait(handle_t *handle,
+			struct jbd2_inode *inode, loff_t start_byte,
+			loff_t length);
 extern int	   jbd2_journal_begin_ordered_truncate(journal_t *journal,
 				struct jbd2_inode *inode, loff_t new_size);
 extern void	   jbd2_journal_init_jbd_inode(struct jbd2_inode *jinode, struct inode *inode);


