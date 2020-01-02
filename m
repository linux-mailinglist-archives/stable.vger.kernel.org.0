Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B07912EBAF
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726148AbgABWLU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:11:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:49246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725872AbgABWLT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:11:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3768D21835;
        Thu,  2 Jan 2020 22:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003078;
        bh=nEmCH8FIOJvwpG1CKDyvod+lwXCSTiUJilMAN/cIPWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ElmgKwIADB5ScfEw8ZoMLWAFdek1rSdTZ685hXg0Tl0dI73AEbayEJ352Ay+PQbDJ
         XeSzuyG8VaF/vK5J5/EvgYGqVbFKdZEaQKTP2e9dzNhJR7omELSTjnHU8ohVOGiZCP
         Am2O5p4OzCBd79odJeSoRvO+s135ReCMa3VX/t+M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <yuchao0@huawei.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 011/191] f2fs: fix to update time in lazytime mode
Date:   Thu,  2 Jan 2020 23:04:53 +0100
Message-Id: <20200102215830.944028838@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 4024790028aa..f078cd20dab8 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2704,6 +2704,20 @@ static inline void clear_file(struct inode *inode, int type)
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
@@ -2721,14 +2735,7 @@ static inline bool f2fs_skip_inode_update(struct inode *inode, int dsync)
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
index db4fec30c30d..386ad54c13c3 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -615,7 +615,11 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 			inode->i_ino == F2FS_META_INO(sbi))
 		return 0;
 
-	if (!is_inode_flag_set(inode, FI_DIRTY_INODE))
+	/*
+	 * atime could be updated without dirtying f2fs inode in lazytime mode
+	 */
+	if (f2fs_is_time_consistent(inode) &&
+		!is_inode_flag_set(inode, FI_DIRTY_INODE))
 		return 0;
 
 	if (!f2fs_is_checkpoint_ready(sbi))
-- 
2.20.1



