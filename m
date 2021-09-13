Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5068409007
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242544AbhIMNtB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:49:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:51786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243755AbhIMNqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:46:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 53BAB6159A;
        Mon, 13 Sep 2021 13:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539925;
        bh=rmyUtVsEdh0gseDg+t15mYDPwUXTV9Y5f3XzJUbybiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqDuORCpAj8mxVEizpXcZVMyI35S+oXneDXIy8W5Kib0sVKfkr9ZhicwRigMtOuZw
         8NDsv9zyArMAySSa61krodeBUFCG/oB7/D7g3A8SctYElaJ54hcc37InkFMUwc1ovw
         gxGlcp13wzX5GZC5afSKkoXF5JGCwllYBTfBFHJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 5.10 217/236] f2fs: guarantee to write dirty data when enabling checkpoint back
Date:   Mon, 13 Sep 2021 15:15:22 +0200
Message-Id: <20210913131107.750805752@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/file.c  |    5 ++---
 fs/f2fs/super.c |   11 ++++++++++-
 2 files changed, 12 insertions(+), 4 deletions(-)

--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -259,8 +259,7 @@ static int f2fs_do_sync_file(struct file
 	};
 	unsigned int seq_id = 0;
 
-	if (unlikely(f2fs_readonly(inode->i_sb) ||
-				is_sbi_flag_set(sbi, SBI_CP_DISABLED)))
+	if (unlikely(f2fs_readonly(inode->i_sb)))
 		return 0;
 
 	trace_f2fs_sync_file_enter(inode);
@@ -274,7 +273,7 @@ static int f2fs_do_sync_file(struct file
 	ret = file_write_and_wait_range(file, start, end);
 	clear_inode_flag(inode, FI_NEED_IPU);
 
-	if (ret) {
+	if (ret || is_sbi_flag_set(sbi, SBI_CP_DISABLED)) {
 		trace_f2fs_sync_file_exit(inode, cp_reason, datasync, ret);
 		return ret;
 	}
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1764,8 +1764,17 @@ restore_flag:
 
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


