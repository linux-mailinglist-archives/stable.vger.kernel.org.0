Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C00205F83
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:46:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391128AbgFWUdP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:33:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:54448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390947AbgFWUdO (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:33:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E209A2072E;
        Tue, 23 Jun 2020 20:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592944394;
        bh=MuWM5QvN4G9sI/MjLrwS3kH0SgnCo+ApbKr26ix7qGU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avqnvc6i2jG7vJ1WMFevMpzby53T+raROAL5jqV/ELPZLz0qRsrJsMvgB3Ou9EazH
         qRS0MlXf/qEx7U2woeiS2VQeyJF5hegp9gsnr0dDf7L1r6JTMq5822RH9KryAk4o7S
         GjKpyh0S/ueyqGl+8RHXUYWujBCsexWC1m14/OTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 287/314] jbd2: clean __jbd2_journal_abort_hard() and __journal_abort_soft()
Date:   Tue, 23 Jun 2020 21:58:02 +0200
Message-Id: <20200623195352.675603121@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195338.770401005@linuxfoundation.org>
References: <20200623195338.770401005@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

[ Upstream commit 7f6225e446cc8dfa4c3c7959a4de3dd03ec277bf ]

__jbd2_journal_abort_hard() is no longer used, so now we can merge
__jbd2_journal_abort_hard() and __journal_abort_soft() these two
functions into jbd2_journal_abort() and remove them.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20191204124614.45424-5-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/jbd2/journal.c    | 103 ++++++++++++++++++-------------------------
 include/linux/jbd2.h |   1 -
 2 files changed, 42 insertions(+), 62 deletions(-)

diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index c1ce2805c5639..fa58835668a62 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -96,7 +96,6 @@ EXPORT_SYMBOL(jbd2_journal_release_jbd_inode);
 EXPORT_SYMBOL(jbd2_journal_begin_ordered_truncate);
 EXPORT_SYMBOL(jbd2_inode_cache);
 
-static void __journal_abort_soft (journal_t *journal, int errno);
 static int jbd2_journal_create_slab(size_t slab_size);
 
 #ifdef CONFIG_JBD2_DEBUG
@@ -805,7 +804,7 @@ int jbd2_journal_bmap(journal_t *journal, unsigned long blocknr,
 					"at offset %lu on %s\n",
 			       __func__, blocknr, journal->j_devname);
 			err = -EIO;
-			__journal_abort_soft(journal, err);
+			jbd2_journal_abort(journal, err);
 		}
 	} else {
 		*retp = blocknr; /* +journal->j_blk_offset */
@@ -2070,64 +2069,6 @@ int jbd2_journal_wipe(journal_t *journal, int write)
 	return err;
 }
 
-/*
- * Journal abort has very specific semantics, which we describe
- * for journal abort.
- *
- * Two internal functions, which provide abort to the jbd layer
- * itself are here.
- */
-
-/*
- * Quick version for internal journal use (doesn't lock the journal).
- * Aborts hard --- we mark the abort as occurred, but do _nothing_ else,
- * and don't attempt to make any other journal updates.
- */
-void __jbd2_journal_abort_hard(journal_t *journal)
-{
-	transaction_t *transaction;
-
-	if (journal->j_flags & JBD2_ABORT)
-		return;
-
-	printk(KERN_ERR "Aborting journal on device %s.\n",
-	       journal->j_devname);
-
-	write_lock(&journal->j_state_lock);
-	journal->j_flags |= JBD2_ABORT;
-	transaction = journal->j_running_transaction;
-	if (transaction)
-		__jbd2_log_start_commit(journal, transaction->t_tid);
-	write_unlock(&journal->j_state_lock);
-}
-
-/* Soft abort: record the abort error status in the journal superblock,
- * but don't do any other IO. */
-static void __journal_abort_soft (journal_t *journal, int errno)
-{
-	int old_errno;
-
-	write_lock(&journal->j_state_lock);
-	old_errno = journal->j_errno;
-	if (!journal->j_errno || errno == -ESHUTDOWN)
-		journal->j_errno = errno;
-
-	if (journal->j_flags & JBD2_ABORT) {
-		write_unlock(&journal->j_state_lock);
-		if (old_errno != -ESHUTDOWN && errno == -ESHUTDOWN)
-			jbd2_journal_update_sb_errno(journal);
-		return;
-	}
-	write_unlock(&journal->j_state_lock);
-
-	__jbd2_journal_abort_hard(journal);
-
-	jbd2_journal_update_sb_errno(journal);
-	write_lock(&journal->j_state_lock);
-	journal->j_flags |= JBD2_REC_ERR;
-	write_unlock(&journal->j_state_lock);
-}
-
 /**
  * void jbd2_journal_abort () - Shutdown the journal immediately.
  * @journal: the journal to shutdown.
@@ -2171,7 +2112,47 @@ static void __journal_abort_soft (journal_t *journal, int errno)
 
 void jbd2_journal_abort(journal_t *journal, int errno)
 {
-	__journal_abort_soft(journal, errno);
+	transaction_t *transaction;
+
+	/*
+	 * ESHUTDOWN always takes precedence because a file system check
+	 * caused by any other journal abort error is not required after
+	 * a shutdown triggered.
+	 */
+	write_lock(&journal->j_state_lock);
+	if (journal->j_flags & JBD2_ABORT) {
+		int old_errno = journal->j_errno;
+
+		write_unlock(&journal->j_state_lock);
+		if (old_errno != -ESHUTDOWN && errno == -ESHUTDOWN) {
+			journal->j_errno = errno;
+			jbd2_journal_update_sb_errno(journal);
+		}
+		return;
+	}
+
+	/*
+	 * Mark the abort as occurred and start current running transaction
+	 * to release all journaled buffer.
+	 */
+	pr_err("Aborting journal on device %s.\n", journal->j_devname);
+
+	journal->j_flags |= JBD2_ABORT;
+	journal->j_errno = errno;
+	transaction = journal->j_running_transaction;
+	if (transaction)
+		__jbd2_log_start_commit(journal, transaction->t_tid);
+	write_unlock(&journal->j_state_lock);
+
+	/*
+	 * Record errno to the journal super block, so that fsck and jbd2
+	 * layer could realise that a filesystem check is needed.
+	 */
+	jbd2_journal_update_sb_errno(journal);
+
+	write_lock(&journal->j_state_lock);
+	journal->j_flags |= JBD2_REC_ERR;
+	write_unlock(&journal->j_state_lock);
 }
 
 /**
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 10e6049c0ba91..b0e97e5de8ca4 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -1402,7 +1402,6 @@ extern int	   jbd2_journal_skip_recovery	(journal_t *);
 extern void	   jbd2_journal_update_sb_errno(journal_t *);
 extern int	   jbd2_journal_update_sb_log_tail	(journal_t *, tid_t,
 				unsigned long, int);
-extern void	   __jbd2_journal_abort_hard	(journal_t *);
 extern void	   jbd2_journal_abort      (journal_t *, int);
 extern int	   jbd2_journal_errno      (journal_t *);
 extern void	   jbd2_journal_ack_err    (journal_t *);
-- 
2.25.1



