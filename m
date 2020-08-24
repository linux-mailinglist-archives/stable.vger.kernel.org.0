Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC0A25064C
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:31:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728432AbgHXRa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:30:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:39214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728133AbgHXQfR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Aug 2020 12:35:17 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22B4222BEF;
        Mon, 24 Aug 2020 16:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598286913;
        bh=QjxMfSf2YtZfIdIMF/+YbXzKaCbtEZ/DX8R9gXNGh6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KVRgzpb5cxpYPde2hvxF9723pINnn5nJk6L1tAO4fNVs9YIHPVnIoum8T5l8EjsB5
         xOi45PQ9hHV8AZ8hbfSQBITO/6sS9c6KMXtrnO+Elzqyrv/9wMvrMtiHSLB8oAOsT6
         4Fb0nJKmSKARsThGtP1iyJUeFt4FGanYiuqqFTi8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "zhangyi (F)" <yi.zhang@huawei.com>, Jan Kara <jack@suse.cz>,
        Theodore Ts'o <tytso@mit.edu>, Sasha Levin <sashal@kernel.org>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 07/63] ext4: abort the filesystem if failed to async write metadata buffer
Date:   Mon, 24 Aug 2020 12:34:07 -0400
Message-Id: <20200824163504.605538-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200824163504.605538-1-sashal@kernel.org>
References: <20200824163504.605538-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "zhangyi (F)" <yi.zhang@huawei.com>

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
index 42f5060f3cdf1..6a76bd94277f0 100644
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
@@ -4765,6 +4765,15 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
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

