Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A782ACD7F
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 05:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732725AbgKJDyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 22:54:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:55506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732752AbgKJDyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 22:54:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8022E20731;
        Tue, 10 Nov 2020 03:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604980475;
        bh=OidxuqgApJGSfeLbGgjwnebB6KwQH162UtIBtQlTeno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyxnm4NCAP1gfEPzlsO6fuBk6KpGW/hQOtBq7kXmQ7vaCGMJnLgDV50ZTdBdaVS/e
         dSlmLyI9c0DnUaNFKGnElm+HD/iNcH6TrCFfQ+1ayceAwTIh9QZ4e/DGd2PvGGfNqs
         F9iFFAycBetucHL/HRkZ45AzTDdvpVrQmp5/sb0M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.9 53/55] seq_file: add seq_read_iter
Date:   Mon,  9 Nov 2020 22:53:16 -0500
Message-Id: <20201110035318.423757-53-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201110035318.423757-1-sashal@kernel.org>
References: <20201110035318.423757-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d4d50710a8b46082224376ef119a4dbb75b25c56 ]

iov_iter based variant for reading a seq_file.  seq_read is
reimplemented on top of the iter variant.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/seq_file.c            | 45 ++++++++++++++++++++++++++++------------
 include/linux/seq_file.h |  1 +
 2 files changed, 33 insertions(+), 13 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 31219c1db17de..3b20e21604e74 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -18,6 +18,7 @@
 #include <linux/mm.h>
 #include <linux/printk.h>
 #include <linux/string_helpers.h>
+#include <linux/uio.h>
 
 #include <linux/uaccess.h>
 #include <asm/page.h>
@@ -146,7 +147,28 @@ static int traverse(struct seq_file *m, loff_t offset)
  */
 ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 {
-	struct seq_file *m = file->private_data;
+	struct iovec iov = { .iov_base = buf, .iov_len = size};
+	struct kiocb kiocb;
+	struct iov_iter iter;
+	ssize_t ret;
+
+	init_sync_kiocb(&kiocb, file);
+	iov_iter_init(&iter, READ, &iov, 1, size);
+
+	kiocb.ki_pos = *ppos;
+	ret = seq_read_iter(&kiocb, &iter);
+	*ppos = kiocb.ki_pos;
+	return ret;
+}
+EXPORT_SYMBOL(seq_read);
+
+/*
+ * Ready-made ->f_op->read_iter()
+ */
+ssize_t seq_read_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	struct seq_file *m = iocb->ki_filp->private_data;
+	size_t size = iov_iter_count(iter);
 	size_t copied = 0;
 	size_t n;
 	void *p;
@@ -158,14 +180,14 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 	 * if request is to read from zero offset, reset iterator to first
 	 * record as it might have been already advanced by previous requests
 	 */
-	if (*ppos == 0) {
+	if (iocb->ki_pos == 0) {
 		m->index = 0;
 		m->count = 0;
 	}
 
-	/* Don't assume *ppos is where we left it */
-	if (unlikely(*ppos != m->read_pos)) {
-		while ((err = traverse(m, *ppos)) == -EAGAIN)
+	/* Don't assume ki_pos is where we left it */
+	if (unlikely(iocb->ki_pos != m->read_pos)) {
+		while ((err = traverse(m, iocb->ki_pos)) == -EAGAIN)
 			;
 		if (err) {
 			/* With prejudice... */
@@ -174,7 +196,7 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 			m->count = 0;
 			goto Done;
 		} else {
-			m->read_pos = *ppos;
+			m->read_pos = iocb->ki_pos;
 		}
 	}
 
@@ -187,13 +209,11 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 	/* if not empty - flush it first */
 	if (m->count) {
 		n = min(m->count, size);
-		err = copy_to_user(buf, m->buf + m->from, n);
-		if (err)
+		if (copy_to_iter(m->buf + m->from, n, iter) != n)
 			goto Efault;
 		m->count -= n;
 		m->from += n;
 		size -= n;
-		buf += n;
 		copied += n;
 		if (!size)
 			goto Done;
@@ -254,8 +274,7 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 	}
 	m->op->stop(m, p);
 	n = min(m->count, size);
-	err = copy_to_user(buf, m->buf, n);
-	if (err)
+	if (copy_to_iter(m->buf, n, iter) != n)
 		goto Efault;
 	copied += n;
 	m->count -= n;
@@ -264,7 +283,7 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 	if (!copied)
 		copied = err;
 	else {
-		*ppos += copied;
+		iocb->ki_pos += copied;
 		m->read_pos += copied;
 	}
 	mutex_unlock(&m->lock);
@@ -276,7 +295,7 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 	err = -EFAULT;
 	goto Done;
 }
-EXPORT_SYMBOL(seq_read);
+EXPORT_SYMBOL(seq_read_iter);
 
 /**
  *	seq_lseek -	->llseek() method for sequential files.
diff --git a/include/linux/seq_file.h b/include/linux/seq_file.h
index 813614d4b71fb..b83b3ae3c877f 100644
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -107,6 +107,7 @@ void seq_pad(struct seq_file *m, char c);
 char *mangle_path(char *s, const char *p, const char *esc);
 int seq_open(struct file *, const struct seq_operations *);
 ssize_t seq_read(struct file *, char __user *, size_t, loff_t *);
+ssize_t seq_read_iter(struct kiocb *iocb, struct iov_iter *iter);
 loff_t seq_lseek(struct file *, loff_t, int);
 int seq_release(struct inode *, struct file *);
 int seq_write(struct seq_file *seq, const void *data, size_t len);
-- 
2.27.0

