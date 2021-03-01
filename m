Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1179328A9A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:20:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239582AbhCASTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:19:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:60792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238479AbhCASNx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:13:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E7CD650B5;
        Mon,  1 Mar 2021 17:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620425;
        bh=XjxSP4gTK0DUqbdh6+kze/ZU1l3SZVJox4fJHvNI6/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OkflpFP6q4cfSOzrVZwqzz8DFk28JB8jwuOiS3nbQ7ecY5QOapK1gCKJvROTGtP0w
         ZPUOvE1yLyocvHS62nBEvgki6mHmNhbRS7MVaWgeyMkg14UGJP3D+AVM8UOlNOh5zS
         L69nudYKBHz6RTqE451tPLe96PTaK1bpRCKbgDfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Giles <ohw.giles@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 149/775] tty: implement read_iter
Date:   Mon,  1 Mar 2021 17:05:17 +0100
Message-Id: <20210301161209.012290354@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
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
index 0c11c65d27431..623738d8e32c8 100644
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
@@ -840,16 +842,17 @@ static void tty_update_time(struct timespec64 *time)
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
@@ -865,10 +868,9 @@ static int iterate_tty_read(struct tty_ldisc *ld, struct tty_struct *tty, struct
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
@@ -876,7 +878,7 @@ static int iterate_tty_read(struct tty_ldisc *ld, struct tty_struct *tty, struct
 		 *
 		 * But make sure size is zeroed.
 		 */
-		if (unlikely(uncopied)) {
+		if (unlikely(copied != size)) {
 			count = 0;
 			retval = -EFAULT;
 		}
@@ -903,10 +905,10 @@ static int iterate_tty_read(struct tty_ldisc *ld, struct tty_struct *tty, struct
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
@@ -919,11 +921,9 @@ static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
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
@@ -2945,7 +2945,7 @@ static long tty_compat_ioctl(struct file *file, unsigned int cmd,
 
 static int this_tty(const void *t, struct file *file, unsigned fd)
 {
-	if (likely(file->f_op->read != tty_read))
+	if (likely(file->f_op->read_iter != tty_read))
 		return 0;
 	return file_tty(file) != t ? 0 : fd + 1;
 }
-- 
2.27.0



