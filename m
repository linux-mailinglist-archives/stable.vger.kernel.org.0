Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A8F302ADF
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 19:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731381AbhAYSz0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:55:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:40802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731189AbhAYSzT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:55:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45A10221E3;
        Mon, 25 Jan 2021 18:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600903;
        bh=QLybVCtLtDGCA3o+z0JpUHWVG9H724oYol2uWzkSnt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/n5K5CH2B226pcSkAwE+mQE4mT6vpWsN0JoNZhHY3IyHNNId5Pkh2ozDtCP35Bxc
         EKAd3pfj6rMajqFY/CwL+pmcJ7t9l/y5TcYvsvNF4huZnm/uCOZmFD7BJLIbbqlFnd
         z6BBl/ngLY2gyU8a3OfnLXA4IQ6UsPyqx/jh4fGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Giles <ohw.giles@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 188/199] tty: implement write_iter
Date:   Mon, 25 Jan 2021 19:40:10 +0100
Message-Id: <20210125183224.113872517@linuxfoundation.org>
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

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 9bb48c82aced07698a2d08ee0f1475a6c4f6b266 upstream.

This makes the tty layer use the .write_iter() function instead of the
traditional .write() functionality.

That allows writev(), but more importantly also makes it possible to
enable .splice_write() for ttys, reinstating the "splice to tty"
functionality that was lost in commit 36e2c7421f02 ("fs: don't allow
splice read/write without explicit ops").

Fixes: 36e2c7421f02 ("fs: don't allow splice read/write without explicit ops")
Reported-by: Oliver Giles <ohw.giles@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/tty_io.c |   48 ++++++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -143,9 +143,8 @@ LIST_HEAD(tty_drivers);			/* linked list
 DEFINE_MUTEX(tty_mutex);
 
 static ssize_t tty_read(struct file *, char __user *, size_t, loff_t *);
-static ssize_t tty_write(struct file *, const char __user *, size_t, loff_t *);
-ssize_t redirected_tty_write(struct file *, const char __user *,
-							size_t, loff_t *);
+static ssize_t tty_write(struct kiocb *, struct iov_iter *);
+ssize_t redirected_tty_write(struct kiocb *, struct iov_iter *);
 static __poll_t tty_poll(struct file *, poll_table *);
 static int tty_open(struct inode *, struct file *);
 long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
@@ -478,7 +477,8 @@ static void tty_show_fdinfo(struct seq_f
 static const struct file_operations tty_fops = {
 	.llseek		= no_llseek,
 	.read		= tty_read,
-	.write		= tty_write,
+	.write_iter	= tty_write,
+	.splice_write	= iter_file_splice_write,
 	.poll		= tty_poll,
 	.unlocked_ioctl	= tty_ioctl,
 	.compat_ioctl	= tty_compat_ioctl,
@@ -491,7 +491,8 @@ static const struct file_operations tty_
 static const struct file_operations console_fops = {
 	.llseek		= no_llseek,
 	.read		= tty_read,
-	.write		= redirected_tty_write,
+	.write_iter	= redirected_tty_write,
+	.splice_write	= iter_file_splice_write,
 	.poll		= tty_poll,
 	.unlocked_ioctl	= tty_ioctl,
 	.compat_ioctl	= tty_compat_ioctl,
@@ -607,9 +608,9 @@ static void __tty_hangup(struct tty_stru
 	/* This breaks for file handles being sent over AF_UNIX sockets ? */
 	list_for_each_entry(priv, &tty->tty_files, list) {
 		filp = priv->file;
-		if (filp->f_op->write == redirected_tty_write)
+		if (filp->f_op->write_iter == redirected_tty_write)
 			cons_filp = filp;
-		if (filp->f_op->write != tty_write)
+		if (filp->f_op->write_iter != tty_write)
 			continue;
 		closecount++;
 		__tty_fasync(-1, filp, 0);	/* can't block */
@@ -902,9 +903,9 @@ static inline ssize_t do_tty_write(
 	ssize_t (*write)(struct tty_struct *, struct file *, const unsigned char *, size_t),
 	struct tty_struct *tty,
 	struct file *file,
-	const char __user *buf,
-	size_t count)
+	struct iov_iter *from)
 {
+	size_t count = iov_iter_count(from);
 	ssize_t ret, written = 0;
 	unsigned int chunk;
 
@@ -956,14 +957,20 @@ static inline ssize_t do_tty_write(
 		size_t size = count;
 		if (size > chunk)
 			size = chunk;
+
 		ret = -EFAULT;
-		if (copy_from_user(tty->write_buf, buf, size))
+		if (copy_from_iter(tty->write_buf, size, from) != size)
 			break;
+
 		ret = write(tty, file, tty->write_buf, size);
 		if (ret <= 0)
 			break;
+
+		/* FIXME! Have Al check this! */
+		if (ret != size)
+			iov_iter_revert(from, size-ret);
+
 		written += ret;
-		buf += ret;
 		count -= ret;
 		if (!count)
 			break;
@@ -1023,9 +1030,9 @@ void tty_write_message(struct tty_struct
  *	write method will not be invoked in parallel for each device.
  */
 
-static ssize_t tty_write(struct file *file, const char __user *buf,
-						size_t count, loff_t *ppos)
+static ssize_t tty_write(struct kiocb *iocb, struct iov_iter *from)
 {
+	struct file *file = iocb->ki_filp;
 	struct tty_struct *tty = file_tty(file);
  	struct tty_ldisc *ld;
 	ssize_t ret;
@@ -1038,18 +1045,15 @@ static ssize_t tty_write(struct file *fi
 	if (tty->ops->write_room == NULL)
 		tty_err(tty, "missing write_room method\n");
 	ld = tty_ldisc_ref_wait(tty);
-	if (!ld)
-		return hung_up_tty_write(file, buf, count, ppos);
-	if (!ld->ops->write)
+	if (!ld || !ld->ops->write)
 		ret = -EIO;
 	else
-		ret = do_tty_write(ld->ops->write, tty, file, buf, count);
+		ret = do_tty_write(ld->ops->write, tty, file, from);
 	tty_ldisc_deref(ld);
 	return ret;
 }
 
-ssize_t redirected_tty_write(struct file *file, const char __user *buf,
-						size_t count, loff_t *ppos)
+ssize_t redirected_tty_write(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *p = NULL;
 
@@ -1060,11 +1064,11 @@ ssize_t redirected_tty_write(struct file
 
 	if (p) {
 		ssize_t res;
-		res = vfs_write(p, buf, count, &p->f_pos);
+		res = vfs_iocb_iter_write(p, iocb, iter);
 		fput(p);
 		return res;
 	}
-	return tty_write(file, buf, count, ppos);
+	return tty_write(iocb, iter);
 }
 
 /**
@@ -2293,7 +2297,7 @@ static int tioccons(struct file *file)
 {
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
-	if (file->f_op->write == redirected_tty_write) {
+	if (file->f_op->write_iter == redirected_tty_write) {
 		struct file *f;
 		spin_lock(&redirect_lock);
 		f = redirect;


