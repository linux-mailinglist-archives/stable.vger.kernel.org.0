Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA6C8171D91
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389304AbgB0OQk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:16:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:56814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389513AbgB0OQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 09:16:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 321C924697;
        Thu, 27 Feb 2020 14:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582812998;
        bh=jkYdk5GPjRMF+1Mp6sEtQBoKAH0fRpvJ+jXGrkPxhWg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BGheQ4yvZ7sRalakp7G4pYbv6cB2luBrTbpXibbUL1Ko5miZFk6S46HbbmAWIqlKX
         ttVSR/r0H6HGa+Q51p24IzBv6U4BuWTgt4Rq2oLIqBRJ2KoqajpqpL2BAsreAEWltH
         3ouhkw86l33mvIaciZO/Vgn+qQOKEBstwcBz6BwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2202a584a00fffd19fbf@syzkaller.appspotmail.com,
        Eric Biggers <ebiggers@google.com>,
        Theodore Tso <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        stable@kernel.org
Subject: [PATCH 5.5 096/150] ext4: fix race between writepages and enabling EXT4_EXTENTS_FL
Date:   Thu, 27 Feb 2020 14:37:13 +0100
Message-Id: <20200227132247.023835616@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132232.815448360@linuxfoundation.org>
References: <20200227132232.815448360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit cb85f4d23f794e24127f3e562cb3b54b0803f456 upstream.

If EXT4_EXTENTS_FL is set on an inode while ext4_writepages() is running
on it, the following warning in ext4_add_complete_io() can be hit:

WARNING: CPU: 1 PID: 0 at fs/ext4/page-io.c:234 ext4_put_io_end_defer+0xf0/0x120

Here's a minimal reproducer (not 100% reliable) (root isn't required):

        while true; do
                sync
        done &
        while true; do
                rm -f file
                touch file
                chattr -e file
                echo X >> file
                chattr +e file
        done

The problem is that in ext4_writepages(), ext4_should_dioread_nolock()
(which only returns true on extent-based files) is checked once to set
the number of reserved journal credits, and also again later to select
the flags for ext4_map_blocks() and copy the reserved journal handle to
ext4_io_end::handle.  But if EXT4_EXTENTS_FL is being concurrently set,
the first check can see dioread_nolock disabled while the later one can
see it enabled, causing the reserved handle to unexpectedly be NULL.

Since changing EXT4_EXTENTS_FL is uncommon, and there may be other races
related to doing so as well, fix this by synchronizing changing
EXT4_EXTENTS_FL with ext4_writepages() via the existing
s_writepages_rwsem (previously called s_journal_flag_rwsem).

This was originally reported by syzbot without a reproducer at
https://syzkaller.appspot.com/bug?extid=2202a584a00fffd19fbf,
but now that dioread_nolock is the default I also started seeing this
when running syzkaller locally.

Link: https://lore.kernel.org/r/20200219183047.47417-3-ebiggers@kernel.org
Reported-by: syzbot+2202a584a00fffd19fbf@syzkaller.appspotmail.com
Fixes: 6b523df4fb5a ("ext4: use transaction reservation for extent conversion in ext4_end_io")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ext4/ext4.h    |    5 ++++-
 fs/ext4/migrate.c |   27 +++++++++++++++++++--------
 2 files changed, 23 insertions(+), 9 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1553,7 +1553,10 @@ struct ext4_sb_info {
 	struct ratelimit_state s_warning_ratelimit_state;
 	struct ratelimit_state s_msg_ratelimit_state;
 
-	/* Barrier between changing inodes' journal flags and writepages ops. */
+	/*
+	 * Barrier between writepages ops and changing any inode's JOURNAL_DATA
+	 * or EXTENTS flag.
+	 */
 	struct percpu_rw_semaphore s_writepages_rwsem;
 	struct dax_device *s_daxdev;
 };
--- a/fs/ext4/migrate.c
+++ b/fs/ext4/migrate.c
@@ -407,6 +407,7 @@ static int free_ext_block(handle_t *hand
 
 int ext4_ext_migrate(struct inode *inode)
 {
+	struct ext4_sb_info *sbi = EXT4_SB(inode->i_sb);
 	handle_t *handle;
 	int retval = 0, i;
 	__le32 *i_data;
@@ -431,6 +432,8 @@ int ext4_ext_migrate(struct inode *inode
 		 */
 		return retval;
 
+	percpu_down_write(&sbi->s_writepages_rwsem);
+
 	/*
 	 * Worst case we can touch the allocation bitmaps, a bgd
 	 * block, and a block to link in the orphan list.  We do need
@@ -441,7 +444,7 @@ int ext4_ext_migrate(struct inode *inode
 
 	if (IS_ERR(handle)) {
 		retval = PTR_ERR(handle);
-		return retval;
+		goto out_unlock;
 	}
 	goal = (((inode->i_ino - 1) / EXT4_INODES_PER_GROUP(inode->i_sb)) *
 		EXT4_INODES_PER_GROUP(inode->i_sb)) + 1;
@@ -452,7 +455,7 @@ int ext4_ext_migrate(struct inode *inode
 	if (IS_ERR(tmp_inode)) {
 		retval = PTR_ERR(tmp_inode);
 		ext4_journal_stop(handle);
-		return retval;
+		goto out_unlock;
 	}
 	i_size_write(tmp_inode, i_size_read(inode));
 	/*
@@ -494,7 +497,7 @@ int ext4_ext_migrate(struct inode *inode
 		 */
 		ext4_orphan_del(NULL, tmp_inode);
 		retval = PTR_ERR(handle);
-		goto out;
+		goto out_tmp_inode;
 	}
 
 	ei = EXT4_I(inode);
@@ -576,10 +579,11 @@ err_out:
 	ext4_ext_tree_init(handle, tmp_inode);
 out_stop:
 	ext4_journal_stop(handle);
-out:
+out_tmp_inode:
 	unlock_new_inode(tmp_inode);
 	iput(tmp_inode);
-
+out_unlock:
+	percpu_up_write(&sbi->s_writepages_rwsem);
 	return retval;
 }
 
@@ -589,7 +593,8 @@ out:
 int ext4_ind_migrate(struct inode *inode)
 {
 	struct ext4_extent_header	*eh;
-	struct ext4_super_block		*es = EXT4_SB(inode->i_sb)->s_es;
+	struct ext4_sb_info		*sbi = EXT4_SB(inode->i_sb);
+	struct ext4_super_block		*es = sbi->s_es;
 	struct ext4_inode_info		*ei = EXT4_I(inode);
 	struct ext4_extent		*ex;
 	unsigned int			i, len;
@@ -613,9 +618,13 @@ int ext4_ind_migrate(struct inode *inode
 	if (test_opt(inode->i_sb, DELALLOC))
 		ext4_alloc_da_blocks(inode);
 
+	percpu_down_write(&sbi->s_writepages_rwsem);
+
 	handle = ext4_journal_start(inode, EXT4_HT_MIGRATE, 1);
-	if (IS_ERR(handle))
-		return PTR_ERR(handle);
+	if (IS_ERR(handle)) {
+		ret = PTR_ERR(handle);
+		goto out_unlock;
+	}
 
 	down_write(&EXT4_I(inode)->i_data_sem);
 	ret = ext4_ext_check_inode(inode);
@@ -650,5 +659,7 @@ int ext4_ind_migrate(struct inode *inode
 errout:
 	ext4_journal_stop(handle);
 	up_write(&EXT4_I(inode)->i_data_sem);
+out_unlock:
+	percpu_up_write(&sbi->s_writepages_rwsem);
 	return ret;
 }


