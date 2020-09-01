Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0864625948A
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730601AbgIAPku (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:52234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727918AbgIAPks (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:40:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6CFA02064B;
        Tue,  1 Sep 2020 15:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598974847;
        bh=e7g4NunmCYbHix/BFPrdxNGzrOkjbfzrdeVG6NOHEWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ohGH7CzpydrrPqc7W6oT757TEyrYZKtOcp6FqdwCJU5P73PPkEldb8ajHgJsfke2H
         88DeYoFOqEVWx5+xl1mfg+ze1TSlS7Hh1iNORA7pmjfkShhmEKoTtbtuCzrVc5igRg
         E3+P3MJOjxifc67vz3/l1aof9p8Lif1x5mtop5FE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "zhangyi (F)" <yi.zhang@huawei.com>,
        Jan Kara <jack@suse.cz>, Theodore Tso <tytso@mit.edu>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 112/255] ext4: abort the filesystem if failed to async write metadata buffer
Date:   Tue,  1 Sep 2020 17:09:28 +0200
Message-Id: <20200901151006.088784465@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhangyi (F) <yi.zhang@huawei.com>

[ Upstream commit bc71726c725767205757821df364acff87f92ac5 ]

There is a risk of filesystem inconsistency if we failed to async write
back metadata buffer in the background. Because of current buffer's end
io procedure is handled by end_buffer_async_write() in the block layer,
and it only clear the buffer's uptodate flag and mark the write_io_error
flag, so ext4 cannot detect such failure immediately. In most cases of
getting metadata buffer (e.g. ext4_read_inode_bitmap()), although the
buffer's data is actually uptodate, it may still read data from disk
because the buffer's uptodate flag has been cleared. Finally, it may
lead to on-disk filesystem inconsistency if reading old data from the
disk successfully and write them out again.

This patch detect bdev mapping->wb_err when getting journal's write
access and mark the filesystem error if bdev's mapping->wb_err was
increased, this could prevent further writing and potential
inconsistency.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Suggested-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20200620025427.1756360-2-yi.zhang@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h      |  3 +++
 fs/ext4/ext4_jbd2.c | 25 +++++++++++++++++++++++++
 fs/ext4/super.c     | 17 +++++++++++++++++
 3 files changed, 45 insertions(+)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 42815304902b8..eec5c03534d05 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1585,6 +1585,9 @@ struct ext4_sb_info {
 #ifdef CONFIG_EXT4_DEBUG
 	unsigned long s_simulate_fail;
 #endif
+	/* Record the errseq of the backing block device */
+	errseq_t s_bdev_wb_err;
+	spinlock_t s_bdev_wb_lock;
 };
 
 static inline struct ext4_sb_info *EXT4_SB(struct super_block *sb)
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 0c76cdd44d90d..760b9ee49dc00 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -195,6 +195,28 @@ static void ext4_journal_abort_handle(const char *caller, unsigned int line,
 	jbd2_journal_abort_handle(handle);
 }
 
+static void ext4_check_bdev_write_error(struct super_block *sb)
+{
+	struct address_space *mapping = sb->s_bdev->bd_inode->i_mapping;
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	int err;
+
+	/*
+	 * If the block device has write error flag, it may have failed to
+	 * async write out metadata buffers in the background. In this case,
+	 * we could read old data from disk and write it out again, which
+	 * may lead to on-disk filesystem inconsistency.
+	 */
+	if (errseq_check(&mapping->wb_err, READ_ONCE(sbi->s_bdev_wb_err))) {
+		spin_lock(&sbi->s_bdev_wb_lock);
+		err = errseq_check_and_advance(&mapping->wb_err, &sbi->s_bdev_wb_err);
+		spin_unlock(&sbi->s_bdev_wb_lock);
+		if (err)
+			ext4_error_err(sb, -err,
+				       "Error while async write back metadata");
+	}
+}
+
 int __ext4_journal_get_write_access(const char *where, unsigned int line,
 				    handle_t *handle, struct buffer_head *bh)
 {
@@ -202,6 +224,9 @@ int __ext4_journal_get_write_access(const char *where, unsigned int line,
 
 	might_sleep();
 
+	if (bh->b_bdev->bd_super)
+		ext4_check_bdev_write_error(bh->b_bdev->bd_super);
+
 	if (ext4_handle_valid(handle)) {
 		err = jbd2_journal_get_write_access(handle, bh);
 		if (err)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index dda967efcbc2c..c77b10257b36a 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4765,6 +4765,15 @@ no_journal:
 	}
 #endif  /* CONFIG_QUOTA */
 
+	/*
+	 * Save the original bdev mapping's wb_err value which could be
+	 * used to detect the metadata async write error.
+	 */
+	spin_lock_init(&sbi->s_bdev_wb_lock);
+	if (!sb_rdonly(sb))
+		errseq_check_and_advance(&sb->s_bdev->bd_inode->i_mapping->wb_err,
+					 &sbi->s_bdev_wb_err);
+	sb->s_bdev->bd_super = sb;
 	EXT4_SB(sb)->s_mount_state |= EXT4_ORPHAN_FS;
 	ext4_orphan_cleanup(sb, es);
 	EXT4_SB(sb)->s_mount_state &= ~EXT4_ORPHAN_FS;
@@ -5654,6 +5663,14 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 				goto restore_opts;
 			}
 
+			/*
+			 * Update the original bdev mapping's wb_err value
+			 * which could be used to detect the metadata async
+			 * write error.
+			 */
+			errseq_check_and_advance(&sb->s_bdev->bd_inode->i_mapping->wb_err,
+						 &sbi->s_bdev_wb_err);
+
 			/*
 			 * Mounting a RDONLY partition read-write, so reread
 			 * and store the current valid flag.  (It may have
-- 
2.25.1



