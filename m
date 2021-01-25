Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25FE0302AE1
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:56:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731383AbhAYSz2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:55:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:41248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731374AbhAYSzV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 951AA20719;
        Mon, 25 Jan 2021 18:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600906;
        bh=b9/PnXiWVuWWv+6ysr1/+T+fJJOF4mysCxbAqNLW0eY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gnwFxw9kwiCqqv29qjd1nFY4wz8Qo6CY/BaiYPLohWP5PCo/zs6oJPGC8qwWkxcV5
         CqBbZTqhopZsG8W2V0T/6KDRF198UpxkBc/t9zqQbrtKlc0R+N0h4ebzv9cM1ilplg
         ixPpJZ6K9gEro8FYhgvywcank1JEDTuj3LTzjPOc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 197/199] kernfs: implement ->write_iter
Date:   Mon, 25 Jan 2021 19:40:19 +0100
Message-Id: <20210125183224.488254865@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

commit cc099e0b399889c6485c88368b19824b087c9f8c upstream.

Switch kernfs to implement the write_iter method instead of plain old
write to prepare to supporting splice and sendfile again.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210120204631.274206-3-hch@lst.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/file.c |   28 ++++++++++------------------
 1 file changed, 10 insertions(+), 18 deletions(-)

--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -242,13 +242,7 @@ static ssize_t kernfs_fop_read_iter(stru
 	return kernfs_file_read_iter(iocb, iter);
 }
 
-/**
- * kernfs_fop_write - kernfs vfs write callback
- * @file: file pointer
- * @user_buf: data to write
- * @count: number of bytes
- * @ppos: starting offset
- *
+/*
  * Copy data in from userland and pass it to the matching kernfs write
  * operation.
  *
@@ -258,20 +252,18 @@ static ssize_t kernfs_fop_read_iter(stru
  * modify only the the value you're changing, then write entire buffer
  * back.
  */
-static ssize_t kernfs_fop_write(struct file *file, const char __user *user_buf,
-				size_t count, loff_t *ppos)
+static ssize_t kernfs_fop_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
-	struct kernfs_open_file *of = kernfs_of(file);
+	struct kernfs_open_file *of = kernfs_of(iocb->ki_filp);
+	ssize_t len = iov_iter_count(iter);
 	const struct kernfs_ops *ops;
-	ssize_t len;
 	char *buf;
 
 	if (of->atomic_write_len) {
-		len = count;
 		if (len > of->atomic_write_len)
 			return -E2BIG;
 	} else {
-		len = min_t(size_t, count, PAGE_SIZE);
+		len = min_t(size_t, len, PAGE_SIZE);
 	}
 
 	buf = of->prealloc_buf;
@@ -282,7 +274,7 @@ static ssize_t kernfs_fop_write(struct f
 	if (!buf)
 		return -ENOMEM;
 
-	if (copy_from_user(buf, user_buf, len)) {
+	if (copy_from_iter(buf, len, iter) != len) {
 		len = -EFAULT;
 		goto out_free;
 	}
@@ -301,7 +293,7 @@ static ssize_t kernfs_fop_write(struct f
 
 	ops = kernfs_ops(of->kn);
 	if (ops->write)
-		len = ops->write(of, buf, len, *ppos);
+		len = ops->write(of, buf, len, iocb->ki_pos);
 	else
 		len = -EINVAL;
 
@@ -309,7 +301,7 @@ static ssize_t kernfs_fop_write(struct f
 	mutex_unlock(&of->mutex);
 
 	if (len > 0)
-		*ppos += len;
+		iocb->ki_pos += len;
 
 out_free:
 	if (buf == of->prealloc_buf)
@@ -662,7 +654,7 @@ static int kernfs_fop_open(struct inode
 
 	/*
 	 * Write path needs to atomic_write_len outside active reference.
-	 * Cache it in open_file.  See kernfs_fop_write() for details.
+	 * Cache it in open_file.  See kernfs_fop_write_iter() for details.
 	 */
 	of->atomic_write_len = ops->atomic_write_len;
 
@@ -950,7 +942,7 @@ EXPORT_SYMBOL_GPL(kernfs_notify);
 
 const struct file_operations kernfs_file_fops = {
 	.read_iter	= kernfs_fop_read_iter,
-	.write		= kernfs_fop_write,
+	.write_iter	= kernfs_fop_write_iter,
 	.llseek		= generic_file_llseek,
 	.mmap		= kernfs_fop_mmap,
 	.open		= kernfs_fop_open,


