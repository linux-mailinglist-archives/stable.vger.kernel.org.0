Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A0F64040CE
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 00:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235447AbhIHWBf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 18:01:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:39990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234144AbhIHWBc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Sep 2021 18:01:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F77D61102;
        Wed,  8 Sep 2021 22:00:24 +0000 (UTC)
From:   Jaegeuk Kim <jaegeuk@google.com>
To:     stable@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>
Subject: [PATCH] f2fs: guarantee to write dirty data when enabling checkpoint back
Date:   Wed,  8 Sep 2021 15:00:20 -0700
Message-Id: <20210908220020.599899-1-jaegeuk@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaegeuk Kim <jaegeuk@kernel.org>

commit dddd3d65293a52c2c3850c19b1e5115712e534d8 upstream.

We must flush all the dirty data when enabling checkpoint back. Let's guarantee
that first by adding a retry logic on sync_inodes_sb(). In addition to that,
this patch adds to flush data in fsync when checkpoint is disabled, which can
mitigate the sync_inodes_sb() failures in advance.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/file.c  |  5 ++---
 fs/f2fs/super.c | 11 ++++++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 5c74b2997197..6ee8b1e0e174 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -259,8 +259,7 @@ static int f2fs_do_sync_file(struct file *file, loff_t start, loff_t end,
 	};
 	unsigned int seq_id = 0;
 
-	if (unlikely(f2fs_readonly(inode->i_sb) ||
-				is_sbi_flag_set(sbi, SBI_CP_DISABLED)))
+	if (unlikely(f2fs_readonly(inode->i_sb)))
 		return 0;
 
 	trace_f2fs_sync_file_enter(inode);
@@ -274,7 +273,7 @@ static int f2fs_do_sync_file(struct file *file, loff_t start, loff_t end,
 	ret = file_write_and_wait_range(file, start, end);
 	clear_inode_flag(inode, FI_NEED_IPU);
 
-	if (ret) {
+	if (ret || is_sbi_flag_set(sbi, SBI_CP_DISABLED)) {
 		trace_f2fs_sync_file_exit(inode, cp_reason, datasync, ret);
 		return ret;
 	}
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index c52988067887..476b2c497d28 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1764,8 +1764,17 @@ static int f2fs_disable_checkpoint(struct f2fs_sb_info *sbi)
 
 static void f2fs_enable_checkpoint(struct f2fs_sb_info *sbi)
 {
+	int retry = DEFAULT_RETRY_IO_COUNT;
+
 	/* we should flush all the data to keep data consistency */
-	sync_inodes_sb(sbi->sb);
+	do {
+		sync_inodes_sb(sbi->sb);
+		cond_resched();
+		congestion_wait(BLK_RW_ASYNC, DEFAULT_IO_TIMEOUT);
+	} while (get_pages(sbi, F2FS_DIRTY_DATA) && retry--);
+
+	if (unlikely(retry < 0))
+		f2fs_warn(sbi, "checkpoint=enable has some unwritten data.");
 
 	down_write(&sbi->gc_lock);
 	f2fs_dirty_to_prefree(sbi);
-- 
2.33.0.153.gba50c8fa24-goog

