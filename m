Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC781171A29
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 14:51:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730610AbgB0NvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:51:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731370AbgB0NvT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:51:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A383520578;
        Thu, 27 Feb 2020 13:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811479;
        bh=zPI+G63XN7GA5JIiv3P2eKVG5/EXsBnIsCOe9KKoThs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3qul+TgLOGVJzoMBj5ebcuzRMEONdbkCwMpTbQgHF453bBQeNmFGllYLcc85I+yr
         JWgjYl/Nl2Ennq2M0ctX6A3hSUcXU+QI7f+lhiWUL4y/ZB1p2u7aeY3Ja+Xm+DAlhG
         a2GPjrYy4MnPNQfgTQwWXGZ3YmTP5PC2FS/u+QPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        stable@kernel.org
Subject: [PATCH 4.9 148/165] ext4: rename s_journal_flag_rwsem to s_writepages_rwsem
Date:   Thu, 27 Feb 2020 14:37:02 +0100
Message-Id: <20200227132252.381564558@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit bbd55937de8f2754adc5792b0f8e5ff7d9c0420e upstream.

In preparation for making s_journal_flag_rwsem synchronize
ext4_writepages() with changes to both the EXTENTS and JOURNAL_DATA
flags (rather than just JOURNAL_DATA as it does currently), rename it to
s_writepages_rwsem.

Link: https://lore.kernel.org/r/20200219183047.47417-2-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4.h  |    2 +-
 fs/ext4/inode.c |   10 +++++-----
 fs/ext4/super.c |    6 +++---
 3 files changed, 9 insertions(+), 9 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1515,7 +1515,7 @@ struct ext4_sb_info {
 	struct ratelimit_state s_msg_ratelimit_state;
 
 	/* Barrier between changing inodes' journal flags and writepages ops. */
-	struct percpu_rw_semaphore s_journal_flag_rwsem;
+	struct percpu_rw_semaphore s_writepages_rwsem;
 
 	/* Encryption support */
 #ifdef CONFIG_EXT4_FS_ENCRYPTION
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -2652,7 +2652,7 @@ static int ext4_writepages(struct addres
 	struct blk_plug plug;
 	bool give_up_on_write = false;
 
-	percpu_down_read(&sbi->s_journal_flag_rwsem);
+	percpu_down_read(&sbi->s_writepages_rwsem);
 	trace_ext4_writepages(inode, wbc);
 
 	if (dax_mapping(mapping)) {
@@ -2853,7 +2853,7 @@ retry:
 out_writepages:
 	trace_ext4_writepages_result(inode, wbc, ret,
 				     nr_to_write - wbc->nr_to_write);
-	percpu_up_read(&sbi->s_journal_flag_rwsem);
+	percpu_up_read(&sbi->s_writepages_rwsem);
 	return ret;
 }
 
@@ -5688,7 +5688,7 @@ int ext4_change_inode_journal_flag(struc
 		}
 	}
 
-	percpu_down_write(&sbi->s_journal_flag_rwsem);
+	percpu_down_write(&sbi->s_writepages_rwsem);
 	jbd2_journal_lock_updates(journal);
 
 	/*
@@ -5705,7 +5705,7 @@ int ext4_change_inode_journal_flag(struc
 		err = jbd2_journal_flush(journal);
 		if (err < 0) {
 			jbd2_journal_unlock_updates(journal);
-			percpu_up_write(&sbi->s_journal_flag_rwsem);
+			percpu_up_write(&sbi->s_writepages_rwsem);
 			ext4_inode_resume_unlocked_dio(inode);
 			return err;
 		}
@@ -5714,7 +5714,7 @@ int ext4_change_inode_journal_flag(struc
 	ext4_set_aops(inode);
 
 	jbd2_journal_unlock_updates(journal);
-	percpu_up_write(&sbi->s_journal_flag_rwsem);
+	percpu_up_write(&sbi->s_writepages_rwsem);
 
 	if (val)
 		up_write(&EXT4_I(inode)->i_mmap_sem);
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -865,7 +865,7 @@ static void ext4_put_super(struct super_
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
-	percpu_free_rwsem(&sbi->s_journal_flag_rwsem);
+	percpu_free_rwsem(&sbi->s_writepages_rwsem);
 	brelse(sbi->s_sbh);
 #ifdef CONFIG_QUOTA
 	for (i = 0; i < EXT4_MAXQUOTAS; i++)
@@ -4223,7 +4223,7 @@ no_journal:
 		err = percpu_counter_init(&sbi->s_dirtyclusters_counter, 0,
 					  GFP_KERNEL);
 	if (!err)
-		err = percpu_init_rwsem(&sbi->s_journal_flag_rwsem);
+		err = percpu_init_rwsem(&sbi->s_writepages_rwsem);
 
 	if (err) {
 		ext4_msg(sb, KERN_ERR, "insufficient memory");
@@ -4322,7 +4322,7 @@ failed_mount6:
 	percpu_counter_destroy(&sbi->s_freeinodes_counter);
 	percpu_counter_destroy(&sbi->s_dirs_counter);
 	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
-	percpu_free_rwsem(&sbi->s_journal_flag_rwsem);
+	percpu_free_rwsem(&sbi->s_writepages_rwsem);
 failed_mount5:
 	ext4_ext_release(sb);
 	ext4_release_system_zone(sb);


