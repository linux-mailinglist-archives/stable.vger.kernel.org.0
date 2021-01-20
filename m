Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C44F12FD4F9
	for <lists+stable@lfdr.de>; Wed, 20 Jan 2021 17:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729840AbhATQIL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 11:08:11 -0500
Received: from mx2.suse.de ([195.135.220.15]:42856 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391401AbhATQHA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 20 Jan 2021 11:07:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EBD0DAF32;
        Wed, 20 Jan 2021 16:06:18 +0000 (UTC)
Received: by quack2.suse.cz (Postfix, from userid 1000)
        id B4D381E0831; Wed, 20 Jan 2021 17:06:18 +0100 (CET)
From:   Jan Kara <jack@suse.cz>
To:     <linux-fsdevel@vger.kernel.org>
Cc:     Matthew Wilcox <willy@infradead.org>, <linux-ext4@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, stable@vger.kernel.org,
        Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/3] ext4: Fix stale data exposure when read races with hole punch
Date:   Wed, 20 Jan 2021 17:06:11 +0100
Message-Id: <20210120160611.26853-4-jack@suse.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210120160611.26853-1-jack@suse.cz>
References: <20210120160611.26853-1-jack@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 fs/ext4/file.c  | 16 ++++++++++++++++
 fs/ext4/inode.c | 21 +++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 349b27f0dda0..d66f7c08b123 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -30,6 +30,7 @@
 #include <linux/uio.h>
 #include <linux/mman.h>
 #include <linux/backing-dev.h>
+#include <linux/fadvise.h>
 #include "ext4.h"
 #include "ext4_jbd2.h"
 #include "xattr.h"
@@ -131,6 +132,20 @@ static ssize_t ext4_file_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	return generic_file_read_iter(iocb, to);
 }
 
+static int ext4_fadvise(struct file *filp, loff_t start, loff_t end, int advice)
+{
+	struct inode *inode = file_inode(filp);
+	int ret;
+
+	/* Readahead needs protection from hole punching and similar ops */
+	if (advice == POSIX_FADV_WILLNEED)
+		down_read(&EXT4_I(inode)->i_mmap_sem);
+	ret = generic_fadvise(filp, start, end, advice);
+	if (advice == POSIX_FADV_WILLNEED)
+		up_read(&EXT4_I(inode)->i_mmap_sem);
+	return ret;
+}
+
 /*
  * Called when an inode is released. Note that this is different
  * from ext4_file_open: open gets called at every open, but release
@@ -911,6 +926,7 @@ const struct file_operations ext4_file_operations = {
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= ext4_fallocate,
+	.fadvise	= ext4_fadvise,
 };
 
 const struct inode_operations ext4_file_inode_operations = {
diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index c173c8405856..a01569f2fa49 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3646,9 +3646,28 @@ static int ext4_iomap_swap_activate(struct swap_info_struct *sis,
 				       &ext4_iomap_report_ops);
 }
 
+static int ext4_fill_pages(struct kiocb *iocb, size_t len, bool partial_page,
+			   struct page **pagep, unsigned int nr_pages)
+{
+	struct ext4_inode_info *ei = EXT4_I(iocb->ki_filp->f_mapping->host);
+	int ret;
+
+	/*
+	 * Protect adding of pages into page cache against hole punching and
+	 * other cache manipulation functions so that we don't expose
+	 * potentially stale user data.
+	 */
+	down_read(&ei->i_mmap_sem);
+	ret = generic_file_buffered_read_get_pages(iocb, len, partial_page,
+						   pagep, nr_pages);
+	up_read(&ei->i_mmap_sem);
+	return ret;
+}
+
 static const struct address_space_operations ext4_aops = {
 	.readpage		= ext4_readpage,
 	.readahead		= ext4_readahead,
+	.fill_pages		= ext4_fill_pages,
 	.writepage		= ext4_writepage,
 	.writepages		= ext4_writepages,
 	.write_begin		= ext4_write_begin,
@@ -3667,6 +3686,7 @@ static const struct address_space_operations ext4_aops = {
 static const struct address_space_operations ext4_journalled_aops = {
 	.readpage		= ext4_readpage,
 	.readahead		= ext4_readahead,
+	.fill_pages		= ext4_fill_pages,
 	.writepage		= ext4_writepage,
 	.writepages		= ext4_writepages,
 	.write_begin		= ext4_write_begin,
@@ -3684,6 +3704,7 @@ static const struct address_space_operations ext4_journalled_aops = {
 static const struct address_space_operations ext4_da_aops = {
 	.readpage		= ext4_readpage,
 	.readahead		= ext4_readahead,
+	.fill_pages		= ext4_fill_pages,
 	.writepage		= ext4_writepage,
 	.writepages		= ext4_writepages,
 	.write_begin		= ext4_da_write_begin,
-- 
2.26.2

