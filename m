Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9D9328B03
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239746AbhCAS1P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:27:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:39426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239751AbhCASUd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:20:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8F776518C;
        Mon,  1 Mar 2021 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618656;
        bh=fwLK89waWPTZp0FdyENMnZNvWfk0vbtv/UML20L1HBg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yh0bdA8yQcx2A4SkVRxq6crCdlSAodoGrahtWrooFYu8ul4MfbFgZIbYb5NeFpbME
         qjjigyyX8zaBkwHRQ0vZgcjJJoDL+hqIWYbqqBVFykU9EJSL8/QYYUdGVeOyuFEvpu
         7FK5nPP3oSM/7FAnqaI9hI/VnWlk/9dOXnyaB3Jc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Giles <ohw.giles@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/663] tty: implement read_iter
Date:   Mon,  1 Mar 2021 17:06:25 +0100
Message-Id: <20210301161148.535047104@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

[ Upstream commit dd78b0c483e33225e0e0782b0ed887129b00f956 ]

Now that the ldisc read() function takes kernel pointers, it's fairly
straightforward to make the tty file operations use .read_iter() instead
of .read().

That automatically gives us vread() and friends, and also makes it
possible to do .splice_read() on ttys again.

Fixes: 36e2c7421f02 ("fs: don't allow splice read/write without explicit ops")
Reported-by: Oliver Giles <ohw.giles@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_io.c | 36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index a50c8a4318228..3f55fe7293f31 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -142,7 +142,7 @@ LIST_HEAD(tty_drivers);			/* linked list of tty drivers */
 /* Mutex to protect creating and releasing a tty */
 DEFINE_MUTEX(tty_mutex);
 
-static ssize_t tty_read(struct file *, char __user *, size_t, loff_t *);
+static ssize_t tty_read(struct kiocb *, struct iov_iter *);
 static ssize_t tty_write(struct kiocb *, struct iov_iter *);
 static __poll_t tty_poll(struct file *, poll_table *);
 static int tty_open(struct inode *, struct file *);
@@ -473,8 +473,9 @@ static void tty_show_fdinfo(struct seq_file *m, struct file *file)
 
 static const struct file_operations tty_fops = {
 	.llseek		= no_llseek,
-	.read		= tty_read,
+	.read_iter	= tty_read,
 	.write_iter	= tty_write,
+	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.poll		= tty_poll,
 	.unlocked_ioctl	= tty_ioctl,
@@ -487,8 +488,9 @@ static const struct file_operations tty_fops = {
 
 static const struct file_operations console_fops = {
 	.llseek		= no_llseek,
-	.read		= tty_read,
+	.read_iter	= tty_read,
 	.write_iter	= redirected_tty_write,
+	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.poll		= tty_poll,
 	.unlocked_ioctl	= tty_ioctl,
@@ -841,16 +843,17 @@ static void tty_update_time(struct timespec64 *time)
  * data or clears the cookie. The cookie may be something that the
  * ldisc maintains state for and needs to free.
  */
-static int iterate_tty_read(struct tty_ldisc *ld, struct tty_struct *tty, struct file *file,
-		char __user *buf, size_t count)
+static int iterate_tty_read(struct tty_ldisc *ld, struct tty_struct *tty,
+		struct file *file, struct iov_iter *to)
 {
 	int retval = 0;
 	void *cookie = NULL;
 	unsigned long offset = 0;
 	char kernel_buf[64];
+	size_t count = iov_iter_count(to);
 
 	do {
-		int size, uncopied;
+		int size, copied;
 
 		size = count > sizeof(kernel_buf) ? sizeof(kernel_buf) : count;
 		size = ld->ops->read(tty, file, kernel_buf, size, &cookie, offset);
@@ -866,10 +869,9 @@ static int iterate_tty_read(struct tty_ldisc *ld, struct tty_struct *tty, struct
 			return size;
 		}
 
-		uncopied = copy_to_user(buf+offset, kernel_buf, size);
-		size -= uncopied;
-		offset += size;
-		count -= size;
+		copied = copy_to_iter(kernel_buf, size, to);
+		offset += copied;
+		count -= copied;
 
 		/*
 		 * If the user copy failed, we still need to do another ->read()
@@ -877,7 +879,7 @@ static int iterate_tty_read(struct tty_ldisc *ld, struct tty_struct *tty, struct
 		 *
 		 * But make sure size is zeroed.
 		 */
-		if (unlikely(uncopied)) {
+		if (unlikely(copied != size)) {
 			count = 0;
 			retval = -EFAULT;
 		}
@@ -904,10 +906,10 @@ static int iterate_tty_read(struct tty_ldisc *ld, struct tty_struct *tty, struct
  *	read calls may be outstanding in parallel.
  */
 
-static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
-			loff_t *ppos)
+static ssize_t tty_read(struct kiocb *iocb, struct iov_iter *to)
 {
 	int i;
+	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
 	struct tty_struct *tty = file_tty(file);
 	struct tty_ldisc *ld;
@@ -920,11 +922,9 @@ static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
 	/* We want to wait for the line discipline to sort out in this
 	   situation */
 	ld = tty_ldisc_ref_wait(tty);
-	if (!ld)
-		return hung_up_tty_read(file, buf, count, ppos);
 	i = -EIO;
-	if (ld->ops->read)
-		i = iterate_tty_read(ld, tty, file, buf, count);
+	if (ld && ld->ops->read)
+		i = iterate_tty_read(ld, tty, file, to);
 	tty_ldisc_deref(ld);
 
 	if (i > 0)
@@ -2943,7 +2943,7 @@ static long tty_compat_ioctl(struct file *file, unsigned int cmd,
 
 static int this_tty(const void *t, struct file *file, unsigned fd)
 {
-	if (likely(file->f_op->read != tty_read))
+	if (likely(file->f_op->read_iter != tty_read))
 		return 0;
 	return file_tty(file) != t ? 0 : fd + 1;
 }
-- 
2.27.0



