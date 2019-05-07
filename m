Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA4F15AA2
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbfEGFko (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:40:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:60190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729168AbfEGFko (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:40:44 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15757206A3;
        Tue,  7 May 2019 05:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207643;
        bh=sr0fZASfak6ElNor1dSUQ6Ch8QcfbkoAmu36P/qWnoI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nb4fWFOx6j0vuPSe1f3L/TojrJCxUaf4CgcAKOk159dSRJuEL6abiAXeEDbKpGL2A
         3M2NYBTs4+2WlogK7ZdRIc7Q0Oz0CbG/Cdao0DQJS5wMNwtqhfBSWeTbMi9oS81FRx
         f4Dnuj5RaNIkHA1q00ahmzjtKdsFitzH3NAV4SNA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     yangerkun <yangerkun@huawei.com>, Theodore Ts'o <tytso@mit.edu>,
        stable@kernel.org, Sasha Levin <alexander.levin@microsoft.com>,
        linux-ext4@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 76/95] ext4: cleanup pagecache before swap i_data
Date:   Tue,  7 May 2019 01:38:05 -0400
Message-Id: <20190507053826.31622-76-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: yangerkun <yangerkun@huawei.com>

[ Upstream commit a46c68a318b08f819047843abf349aeee5d10ac2 ]

While do swap, we should make sure there has no new dirty page since we
should swap i_data between two inode:
1.We should lock i_mmap_sem with write to avoid new pagecache from mmap
read/write;
2.Change filemap_flush to filemap_write_and_wait and move them to the
space protected by inode lock to avoid new pagecache from buffer read/write.

Signed-off-by: yangerkun <yangerkun@huawei.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 fs/ext4/ioctl.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 3dbf4e414706..ca6d27bfcdd8 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -116,9 +116,6 @@ static long swap_inode_boot_loader(struct super_block *sb,
 		return PTR_ERR(inode_bl);
 	ei_bl = EXT4_I(inode_bl);
 
-	filemap_flush(inode->i_mapping);
-	filemap_flush(inode_bl->i_mapping);
-
 	/* Protect orig inodes against a truncate and make sure,
 	 * that only 1 swap_inode_boot_loader is running. */
 	lock_two_nondirectories(inode, inode_bl);
@@ -126,6 +123,15 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	truncate_inode_pages(&inode->i_data, 0);
 	truncate_inode_pages(&inode_bl->i_data, 0);
 
+	down_write(&EXT4_I(inode)->i_mmap_sem);
+	err = filemap_write_and_wait(inode->i_mapping);
+	if (err)
+		goto err_out;
+
+	err = filemap_write_and_wait(inode_bl->i_mapping);
+	if (err)
+		goto err_out;
+
 	/* Wait for all existing dio workers */
 	ext4_inode_block_unlocked_dio(inode);
 	ext4_inode_block_unlocked_dio(inode_bl);
@@ -135,7 +141,7 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	handle = ext4_journal_start(inode_bl, EXT4_HT_MOVE_EXTENTS, 2);
 	if (IS_ERR(handle)) {
 		err = -EINVAL;
-		goto journal_err_out;
+		goto err_out;
 	}
 
 	/* Protect extent tree against block allocations via delalloc */
@@ -190,6 +196,8 @@ static long swap_inode_boot_loader(struct super_block *sb,
 	ext4_journal_stop(handle);
 	ext4_double_up_write_data_sem(inode, inode_bl);
 
+err_out:
+	up_write(&EXT4_I(inode)->i_mmap_sem);
 journal_err_out:
 	ext4_inode_resume_unlocked_dio(inode);
 	ext4_inode_resume_unlocked_dio(inode_bl);
-- 
2.20.1

