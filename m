Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5B04330F0
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 15:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbfFCNWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 09:22:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:40902 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726336AbfFCNWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 09:22:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 04D2BAD31;
        Mon,  3 Jun 2019 13:22:03 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id 50CEE1E3C9A; Mon,  3 Jun 2019 15:22:00 +0200 (CEST)
From:   Jan Kara <jack@suse.cz>
To:     <linux-ext4@vger.kernel.org>
Cc:     Ted Tso <tytso@mit.edu>, <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>,
        Amir Goldstein <amir73il@gmail.com>, Jan Kara <jack@suse.cz>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] ext4: Fix stale data exposure when read races with hole punch
Date:   Mon,  3 Jun 2019 15:21:55 +0200
Message-Id: <20190603132155.20600-3-jack@suse.cz>
X-Mailer: git-send-email 2.16.4
In-Reply-To: <20190603132155.20600-1-jack@suse.cz>
References: <20190603132155.20600-1-jack@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hole puching currently evicts pages from page cache and then goes on to
remove blocks from the inode. This happens under both i_mmap_sem and
i_rwsem held exclusively which provides appropriate serialization with
racing page faults. However there is currently nothing that prevents
ordinary read(2) from racing with the hole punch and instantiating page
cache page after hole punching has evicted page cache but before it has
removed blocks from the inode. This page cache page will be mapping soon
to be freed block and that can lead to returning stale data to userspace
or even filesystem corruption.

Fix the problem by protecting reads as well as readahead requests with
i_mmap_sem.

CC: stable@vger.kernel.org
Reported-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/file.c | 35 +++++++++++++++++++++++++++++++----
 1 file changed, 31 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 2c5baa5e8291..a21fa9f8fb5d 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -34,6 +34,17 @@
 #include "xattr.h"
 #include "acl.h"
 
+static ssize_t ext4_file_buffered_read(struct kiocb *iocb, struct iov_iter *to)
+{
+	ssize_t ret;
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	down_read(&EXT4_I(inode)->i_mmap_sem);
+	ret = generic_file_read_iter(iocb, to);
+	up_read(&EXT4_I(inode)->i_mmap_sem);
+	return ret;
+}
+
 #ifdef CONFIG_FS_DAX
 static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
@@ -52,7 +63,7 @@ static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	if (!IS_DAX(inode)) {
 		inode_unlock_shared(inode);
 		/* Fallback to buffered IO in case we cannot support DAX */
-		return generic_file_read_iter(iocb, to);
+		return ext4_file_buffered_read(iocb, to);
 	}
 	ret = dax_iomap_rw(iocb, to, &ext4_iomap_ops);
 	inode_unlock_shared(inode);
@@ -64,17 +75,32 @@ static ssize_t ext4_dax_read_iter(struct kiocb *iocb, struct iov_iter *to)
 
 static ssize_t ext4_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
-	if (unlikely(ext4_forced_shutdown(EXT4_SB(file_inode(iocb->ki_filp)->i_sb))))
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	if (unlikely(ext4_forced_shutdown(EXT4_SB(inode->i_sb))))
 		return -EIO;
 
 	if (!iov_iter_count(to))
 		return 0; /* skip atime */
 
 #ifdef CONFIG_FS_DAX
-	if (IS_DAX(file_inode(iocb->ki_filp)))
+	if (IS_DAX(inode))
 		return ext4_dax_read_iter(iocb, to);
 #endif
-	return generic_file_read_iter(iocb, to);
+	if (iocb->ki_flags & IOCB_DIRECT)
+		return generic_file_read_iter(iocb, to);
+	return ext4_file_buffered_read(iocb, to);
+}
+
+static int ext4_readahead(struct file *filp, loff_t start, loff_t end)
+{
+	struct inode *inode = file_inode(filp);
+	int ret;
+
+	down_read(&EXT4_I(inode)->i_mmap_sem);
+	ret = generic_readahead(filp, start, end);
+	up_read(&EXT4_I(inode)->i_mmap_sem);
+	return ret;
 }
 
 /*
@@ -518,6 +544,7 @@ const struct file_operations ext4_file_operations = {
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= ext4_fallocate,
+	.readahead	= ext4_readahead,
 };
 
 const struct inode_operations ext4_file_inode_operations = {
-- 
2.16.4

