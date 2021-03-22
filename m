Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E08A34410A
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhCVMa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230242AbhCVM35 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:29:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EEEBA6198D;
        Mon, 22 Mar 2021 12:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416196;
        bh=LHaubciIY+oHnLTj2kVl3f/oS13n8D+RYAd9C4t69ds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vaAGrSUK57sVj6gVsiXyZLRj6RYvfJYBTfKUcNywFIjyM+d9KY8Xdv9gl/wvNfyxw
         SzOks8BHyEnanRDCSmCCiKtrC6sw9GOyrTx/k6AhnKcFokwBtOziF7NGo5ODU+T0gH
         ODqcMDwwy/zQfsjjr6KfkRMj/Fkho7yDtnQw4njY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 5.11 016/120] zonefs: Fix O_APPEND async write handling
Date:   Mon, 22 Mar 2021 13:26:39 +0100
Message-Id: <20210322121930.211205713@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@wdc.com>

commit ebfd68cd0c1e81267c757332385cb96df30dacce upstream.

zonefs updates the size of a sequential zone file inode only on
completion of direct writes. When executing asynchronous append writes
(with a file open with O_APPEND or using RWF_APPEND), the use of the
current inode size in generic_write_checks() to set an iocb offset thus
leads to unaligned write if an application issues an append write
operation with another write already being executed.

Fix this problem by introducing zonefs_write_checks() as a modified
version of generic_write_checks() using the file inode wp_offset for an
append write iocb offset. Also introduce zonefs_write_check_limits() to
replace generic_write_check_limits() call. This zonefs special helper
makes sure that the maximum file limit used is the maximum size of the
file being accessed.

Since zonefs_write_checks() already truncates the iov_iter, the calls
to iov_iter_truncate() in zonefs_file_dio_write() and
zonefs_file_buffered_write() are removed.

Fixes: 8dcc1a9d90c1 ("fs: New zonefs file system")
Cc: <stable@vger.kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/zonefs/super.c |   78 +++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 68 insertions(+), 10 deletions(-)

--- a/fs/zonefs/super.c
+++ b/fs/zonefs/super.c
@@ -720,6 +720,68 @@ out_release:
 }
 
 /*
+ * Do not exceed the LFS limits nor the file zone size. If pos is under the
+ * limit it becomes a short access. If it exceeds the limit, return -EFBIG.
+ */
+static loff_t zonefs_write_check_limits(struct file *file, loff_t pos,
+					loff_t count)
+{
+	struct inode *inode = file_inode(file);
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+	loff_t limit = rlimit(RLIMIT_FSIZE);
+	loff_t max_size = zi->i_max_size;
+
+	if (limit != RLIM_INFINITY) {
+		if (pos >= limit) {
+			send_sig(SIGXFSZ, current, 0);
+			return -EFBIG;
+		}
+		count = min(count, limit - pos);
+	}
+
+	if (!(file->f_flags & O_LARGEFILE))
+		max_size = min_t(loff_t, MAX_NON_LFS, max_size);
+
+	if (unlikely(pos >= max_size))
+		return -EFBIG;
+
+	return min(count, max_size - pos);
+}
+
+static ssize_t zonefs_write_checks(struct kiocb *iocb, struct iov_iter *from)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
+	struct zonefs_inode_info *zi = ZONEFS_I(inode);
+	loff_t count;
+
+	if (IS_SWAPFILE(inode))
+		return -ETXTBSY;
+
+	if (!iov_iter_count(from))
+		return 0;
+
+	if ((iocb->ki_flags & IOCB_NOWAIT) && !(iocb->ki_flags & IOCB_DIRECT))
+		return -EINVAL;
+
+	if (iocb->ki_flags & IOCB_APPEND) {
+		if (zi->i_ztype != ZONEFS_ZTYPE_SEQ)
+			return -EINVAL;
+		mutex_lock(&zi->i_truncate_mutex);
+		iocb->ki_pos = zi->i_wpoffset;
+		mutex_unlock(&zi->i_truncate_mutex);
+	}
+
+	count = zonefs_write_check_limits(file, iocb->ki_pos,
+					  iov_iter_count(from));
+	if (count < 0)
+		return count;
+
+	iov_iter_truncate(from, count);
+	return iov_iter_count(from);
+}
+
+/*
  * Handle direct writes. For sequential zone files, this is the only possible
  * write path. For these files, check that the user is issuing writes
  * sequentially from the end of the file. This code assumes that the block layer
@@ -736,8 +798,7 @@ static ssize_t zonefs_file_dio_write(str
 	struct super_block *sb = inode->i_sb;
 	bool sync = is_sync_kiocb(iocb);
 	bool append = false;
-	size_t count;
-	ssize_t ret;
+	ssize_t ret, count;
 
 	/*
 	 * For async direct IOs to sequential zone files, refuse IOCB_NOWAIT
@@ -755,12 +816,11 @@ static ssize_t zonefs_file_dio_write(str
 		inode_lock(inode);
 	}
 
-	ret = generic_write_checks(iocb, from);
-	if (ret <= 0)
+	count = zonefs_write_checks(iocb, from);
+	if (count <= 0) {
+		ret = count;
 		goto inode_unlock;
-
-	iov_iter_truncate(from, zi->i_max_size - iocb->ki_pos);
-	count = iov_iter_count(from);
+	}
 
 	if ((iocb->ki_pos | count) & (sb->s_blocksize - 1)) {
 		ret = -EINVAL;
@@ -820,12 +880,10 @@ static ssize_t zonefs_file_buffered_writ
 		inode_lock(inode);
 	}
 
-	ret = generic_write_checks(iocb, from);
+	ret = zonefs_write_checks(iocb, from);
 	if (ret <= 0)
 		goto inode_unlock;
 
-	iov_iter_truncate(from, zi->i_max_size - iocb->ki_pos);
-
 	ret = iomap_file_buffered_write(iocb, from, &zonefs_iomap_ops);
 	if (ret > 0)
 		iocb->ki_pos += ret;


