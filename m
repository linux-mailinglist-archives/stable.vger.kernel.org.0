Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE06F302AEF
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 20:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727219AbhAYS4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:56:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:42148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731211AbhAYS4P (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:56:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 85B45224BE;
        Mon, 25 Jan 2021 18:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600932;
        bh=V4dlzO8psg4w5D5nl2EYcBeoVTlrXDghGkrpve01VaM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BS1GbykWCgpqgLjHFLvT22XVZIUgAJTAHt3urjX3/3gIDZ5EJ9yjbtbs1qTgULBSr
         22TgqszBah3Yukzl1VES5WKltXkdi7el77TATBCc6gcaopgwumaTFgggrsOJwpkH7A
         HskfAJZnfJfV/2k8qvVyPu3ZreddglhWoPb236JY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5.10 196/199] kernfs: implement ->read_iter
Date:   Mon, 25 Jan 2021 19:40:18 +0100
Message-Id: <20210125183224.443408624@linuxfoundation.org>
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

commit 4eaad21a6ac9865df7f31983232ed5928450458d upstream.

Switch kernfs to implement the read_iter method instead of plain old
read to prepare to supporting splice and sendfile again.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20210120204631.274206-2-hch@lst.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/file.c |   35 ++++++++++++-----------------------
 1 file changed, 12 insertions(+), 23 deletions(-)

--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -14,6 +14,7 @@
 #include <linux/pagemap.h>
 #include <linux/sched/mm.h>
 #include <linux/fsnotify.h>
+#include <linux/uio.h>
 
 #include "kernfs-internal.h"
 
@@ -180,11 +181,10 @@ static const struct seq_operations kernf
  * it difficult to use seq_file.  Implement simplistic custom buffering for
  * bin files.
  */
-static ssize_t kernfs_file_direct_read(struct kernfs_open_file *of,
-				       char __user *user_buf, size_t count,
-				       loff_t *ppos)
+static ssize_t kernfs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
-	ssize_t len = min_t(size_t, count, PAGE_SIZE);
+	struct kernfs_open_file *of = kernfs_of(iocb->ki_filp);
+	ssize_t len = min_t(size_t, iov_iter_count(iter), PAGE_SIZE);
 	const struct kernfs_ops *ops;
 	char *buf;
 
@@ -210,7 +210,7 @@ static ssize_t kernfs_file_direct_read(s
 	of->event = atomic_read(&of->kn->attr.open->event);
 	ops = kernfs_ops(of->kn);
 	if (ops->read)
-		len = ops->read(of, buf, len, *ppos);
+		len = ops->read(of, buf, len, iocb->ki_pos);
 	else
 		len = -EINVAL;
 
@@ -220,12 +220,12 @@ static ssize_t kernfs_file_direct_read(s
 	if (len < 0)
 		goto out_free;
 
-	if (copy_to_user(user_buf, buf, len)) {
+	if (copy_to_iter(buf, len, iter) != len) {
 		len = -EFAULT;
 		goto out_free;
 	}
 
-	*ppos += len;
+	iocb->ki_pos += len;
 
  out_free:
 	if (buf == of->prealloc_buf)
@@ -235,22 +235,11 @@ static ssize_t kernfs_file_direct_read(s
 	return len;
 }
 
-/**
- * kernfs_fop_read - kernfs vfs read callback
- * @file: file pointer
- * @user_buf: data to write
- * @count: number of bytes
- * @ppos: starting offset
- */
-static ssize_t kernfs_fop_read(struct file *file, char __user *user_buf,
-			       size_t count, loff_t *ppos)
+static ssize_t kernfs_fop_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
-	struct kernfs_open_file *of = kernfs_of(file);
-
-	if (of->kn->flags & KERNFS_HAS_SEQ_SHOW)
-		return seq_read(file, user_buf, count, ppos);
-	else
-		return kernfs_file_direct_read(of, user_buf, count, ppos);
+	if (kernfs_of(iocb->ki_filp)->kn->flags & KERNFS_HAS_SEQ_SHOW)
+		return seq_read_iter(iocb, iter);
+	return kernfs_file_read_iter(iocb, iter);
 }
 
 /**
@@ -960,7 +949,7 @@ void kernfs_notify(struct kernfs_node *k
 EXPORT_SYMBOL_GPL(kernfs_notify);
 
 const struct file_operations kernfs_file_fops = {
-	.read		= kernfs_fop_read,
+	.read_iter	= kernfs_fop_read_iter,
 	.write		= kernfs_fop_write,
 	.llseek		= generic_file_llseek,
 	.mmap		= kernfs_fop_mmap,


