Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6B8511B457
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:47:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733177AbfLKP0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:26:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:60252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733174AbfLKP0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:26:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E8CA24658;
        Wed, 11 Dec 2019 15:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078009;
        bh=o9oNc69DmTqn3hH7gqvokMwckcvcCRhoSdzLpmEDsi4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cUfbNxOKNYQWcawp0YZ14MZv9NrmlGiYAUkW0yKw46X2rXbssy3IVCCU3Npka1jBV
         5hB3oOEXotqC0SEHrHSRlDYUAqMXXRIbLQe/uX5nJPZOnZk1kG9g8XWox/3YS87qS/
         nIGcjSFTAQ2oLsXnCvWdYtGanx0NDlAZcXXUysjM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 4.19 05/79] f2fs: fix to update time in lazytime mode
Date:   Wed, 11 Dec 2019 10:25:29 -0500
Message-Id: <20191211152643.23056-5-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152643.23056-1-sashal@kernel.org>
References: <20191211152643.23056-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chao Yu <yuchao0@huawei.com>

[ Upstream commit fe1897eaa6646f5a64a4cee0e6473ed9887d324b ]

generic/018 reports an inconsistent status of atime, the
testcase is as below:
- open file with O_SYNC
- write file to construct fraged space
- calc md5 of file
- record {a,c,m}time
- defrag file --- do nothing
- umount & mount
- check {a,c,m}time

The root cause is, as f2fs enables lazytime by default, atime
update will dirty vfs inode, rather than dirtying f2fs inode (by set
with FI_DIRTY_INODE), so later f2fs_write_inode() called from VFS will
fail to update inode page due to our skip:

f2fs_write_inode()
	if (is_inode_flag_set(inode, FI_DIRTY_INODE))
		return 0;

So eventually, after evict(), we lose last atime for ever.

To fix this issue, we need to check whether {a,c,m,cr}time is
consistent in between inode cache and inode page, and only skip
f2fs_update_inode() if f2fs inode is not dirty and time is
consistent as well.

Signed-off-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h  | 23 +++++++++++++++--------
 fs/f2fs/inode.c |  6 +++++-
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 34e48bcf50874..72d154e71bb56 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2578,6 +2578,20 @@ static inline void clear_file(struct inode *inode, int type)
 	f2fs_mark_inode_dirty_sync(inode, true);
 }
 
+static inline bool f2fs_is_time_consistent(struct inode *inode)
+{
+	if (!timespec64_equal(F2FS_I(inode)->i_disk_time, &inode->i_atime))
+		return false;
+	if (!timespec64_equal(F2FS_I(inode)->i_disk_time + 1, &inode->i_ctime))
+		return false;
+	if (!timespec64_equal(F2FS_I(inode)->i_disk_time + 2, &inode->i_mtime))
+		return false;
+	if (!timespec64_equal(F2FS_I(inode)->i_disk_time + 3,
+						&F2FS_I(inode)->i_crtime))
+		return false;
+	return true;
+}
+
 static inline bool f2fs_skip_inode_update(struct inode *inode, int dsync)
 {
 	bool ret;
@@ -2595,14 +2609,7 @@ static inline bool f2fs_skip_inode_update(struct inode *inode, int dsync)
 			i_size_read(inode) & ~PAGE_MASK)
 		return false;
 
-	if (!timespec64_equal(F2FS_I(inode)->i_disk_time, &inode->i_atime))
-		return false;
-	if (!timespec64_equal(F2FS_I(inode)->i_disk_time + 1, &inode->i_ctime))
-		return false;
-	if (!timespec64_equal(F2FS_I(inode)->i_disk_time + 2, &inode->i_mtime))
-		return false;
-	if (!timespec64_equal(F2FS_I(inode)->i_disk_time + 3,
-						&F2FS_I(inode)->i_crtime))
+	if (!f2fs_is_time_consistent(inode))
 		return false;
 
 	down_read(&F2FS_I(inode)->i_sem);
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index 540d45759621a..a01be7d8db867 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -614,7 +614,11 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 			inode->i_ino == F2FS_META_INO(sbi))
 		return 0;
 
-	if (!is_inode_flag_set(inode, FI_DIRTY_INODE))
+	/*
+	 * atime could be updated without dirtying f2fs inode in lazytime mode
+	 */
+	if (f2fs_is_time_consistent(inode) &&
+		!is_inode_flag_set(inode, FI_DIRTY_INODE))
 		return 0;
 
 	/*
-- 
2.20.1

