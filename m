Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F94205DF2
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 22:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388614AbgFWUSW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:18:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389656AbgFWUSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:18:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41B5D2080C;
        Tue, 23 Jun 2020 20:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943500;
        bh=I3EqAM4xVySC7eMeVsaJKh3V6AEFAqnKGrskWC5c+dM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OCNnLWCMXOwuwUIozv+xpHNbUpSmDtvlYQliBoR0WYkV4a2qYIca1yceF2Oz1uNhx
         X+CSKe9xNRZLgEE68elj6ukiraGQjcKbELMC/9lo5TccPr8Oe70jmRiwSI8WYWdG2R
         j+VshqWw2D0lCqPny8NLgwema0KY6BWbIInN1VIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.7 417/477] ext4, jbd2: ensure panic by fix a race between jbd2 abort and ext4 error handlers
Date:   Tue, 23 Jun 2020 21:56:54 +0200
Message-Id: <20200623195427.236410823@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

commit 7b97d868b7ab2448859668de9222b8af43f76e78 upstream.

In the ext4 filesystem with errors=panic, if one process is recording
errno in the superblock when invoking jbd2_journal_abort() due to some
error cases, it could be raced by another __ext4_abort() which is
setting the SB_RDONLY flag but missing panic because errno has not been
recorded.

jbd2_journal_commit_transaction()
 jbd2_journal_abort()
  journal->j_flags |= JBD2_ABORT;
  jbd2_journal_update_sb_errno()
                                    | ext4_journal_check_start()
                                    |  __ext4_abort()
                                    |   sb->s_flags |= SB_RDONLY;
                                    |   if (!JBD2_REC_ERR)
                                    |        return;
  journal->j_flags |= JBD2_REC_ERR;

Finally, it will no longer trigger panic because the filesystem has
already been set read-only. Fix this by introduce j_abort_mutex to make
sure journal abort is completed before panic, and remove JBD2_REC_ERR
flag.

Fixes: 4327ba52afd03 ("ext4, jbd2: ensure entering into panic after recording an error in superblock")
Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200609073540.3810702-1-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/super.c      |   16 +++++-----------
 fs/jbd2/journal.c    |   17 ++++++++++++-----
 include/linux/jbd2.h |    6 +++++-
 3 files changed, 22 insertions(+), 17 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -522,9 +522,6 @@ static void ext4_handle_error(struct sup
 		smp_wmb();
 		sb->s_flags |= SB_RDONLY;
 	} else if (test_opt(sb, ERRORS_PANIC)) {
-		if (EXT4_SB(sb)->s_journal &&
-		  !(EXT4_SB(sb)->s_journal->j_flags & JBD2_REC_ERR))
-			return;
 		panic("EXT4-fs (device %s): panic forced after error\n",
 			sb->s_id);
 	}
@@ -725,23 +722,20 @@ void __ext4_abort(struct super_block *sb
 	va_end(args);
 
 	if (sb_rdonly(sb) == 0) {
-		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
 		EXT4_SB(sb)->s_mount_flags |= EXT4_MF_FS_ABORTED;
+		if (EXT4_SB(sb)->s_journal)
+			jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
+
+		ext4_msg(sb, KERN_CRIT, "Remounting filesystem read-only");
 		/*
 		 * Make sure updated value of ->s_mount_flags will be visible
 		 * before ->s_flags update
 		 */
 		smp_wmb();
 		sb->s_flags |= SB_RDONLY;
-		if (EXT4_SB(sb)->s_journal)
-			jbd2_journal_abort(EXT4_SB(sb)->s_journal, -EIO);
 	}
-	if (test_opt(sb, ERRORS_PANIC) && !system_going_down()) {
-		if (EXT4_SB(sb)->s_journal &&
-		  !(EXT4_SB(sb)->s_journal->j_flags & JBD2_REC_ERR))
-			return;
+	if (test_opt(sb, ERRORS_PANIC) && !system_going_down())
 		panic("EXT4-fs panic from previous error\n");
-	}
 }
 
 void __ext4_msg(struct super_block *sb,
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1140,6 +1140,7 @@ static journal_t *journal_init_common(st
 	init_waitqueue_head(&journal->j_wait_commit);
 	init_waitqueue_head(&journal->j_wait_updates);
 	init_waitqueue_head(&journal->j_wait_reserved);
+	mutex_init(&journal->j_abort_mutex);
 	mutex_init(&journal->j_barrier);
 	mutex_init(&journal->j_checkpoint_mutex);
 	spin_lock_init(&journal->j_revoke_lock);
@@ -1402,7 +1403,8 @@ static int jbd2_write_superblock(journal
 		printk(KERN_ERR "JBD2: Error %d detected when updating "
 		       "journal superblock for %s.\n", ret,
 		       journal->j_devname);
-		jbd2_journal_abort(journal, ret);
+		if (!is_journal_aborted(journal))
+			jbd2_journal_abort(journal, ret);
 	}
 
 	return ret;
@@ -2154,6 +2156,13 @@ void jbd2_journal_abort(journal_t *journ
 	transaction_t *transaction;
 
 	/*
+	 * Lock the aborting procedure until everything is done, this avoid
+	 * races between filesystem's error handling flow (e.g. ext4_abort()),
+	 * ensure panic after the error info is written into journal's
+	 * superblock.
+	 */
+	mutex_lock(&journal->j_abort_mutex);
+	/*
 	 * ESHUTDOWN always takes precedence because a file system check
 	 * caused by any other journal abort error is not required after
 	 * a shutdown triggered.
@@ -2167,6 +2176,7 @@ void jbd2_journal_abort(journal_t *journ
 			journal->j_errno = errno;
 			jbd2_journal_update_sb_errno(journal);
 		}
+		mutex_unlock(&journal->j_abort_mutex);
 		return;
 	}
 
@@ -2188,10 +2198,7 @@ void jbd2_journal_abort(journal_t *journ
 	 * layer could realise that a filesystem check is needed.
 	 */
 	jbd2_journal_update_sb_errno(journal);
-
-	write_lock(&journal->j_state_lock);
-	journal->j_flags |= JBD2_REC_ERR;
-	write_unlock(&journal->j_state_lock);
+	mutex_unlock(&journal->j_abort_mutex);
 }
 
 /**
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -766,6 +766,11 @@ struct journal_s
 	int			j_errno;
 
 	/**
+	 * @j_abort_mutex: Lock the whole aborting procedure.
+	 */
+	struct mutex		j_abort_mutex;
+
+	/**
 	 * @j_sb_buffer: The first part of the superblock buffer.
 	 */
 	struct buffer_head	*j_sb_buffer;
@@ -1247,7 +1252,6 @@ JBD2_FEATURE_INCOMPAT_FUNCS(csum3,		CSUM
 #define JBD2_ABORT_ON_SYNCDATA_ERR	0x040	/* Abort the journal on file
 						 * data write error in ordered
 						 * mode */
-#define JBD2_REC_ERR	0x080	/* The errno in the sb has been recorded */
 
 /*
  * Function declarations for the journaling transaction and buffer


