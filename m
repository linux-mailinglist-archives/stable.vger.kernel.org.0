Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0413F3289B7
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239302AbhCASDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:03:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:52492 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237683AbhCAR4u (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:56:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4B00465017;
        Mon,  1 Mar 2021 17:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618653;
        bh=eZrItpCHUWUJRJyeuDr14FUUsfLauxG5itDTHJPIt2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FHuy49Y0bP8VoGR5SE2d+tfzCVf1ClgZ1C8Nm46Xgkxka2ANfmBlGlI4LaF2rOvUE
         E2+cqrUpul8B2NzDLb6b8YBdLPQh6ofCPS6lG6BsNLnGOPrUy9mvl+2nKkeYvwoWfl
         8oc9jMuYzKGC3mD9JEqfeLvNo6dlmQ5K3zlgZGVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 136/663] tty: convert tty_ldisc_ops read() function to take a kernel pointer
Date:   Mon,  1 Mar 2021 17:06:24 +0100
Message-Id: <20210301161148.483404342@linuxfoundation.org>
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

[ Upstream commit 3b830a9c34d5897be07176ce4e6f2d75e2c8cfd7 ]

The tty line discipline .read() function was passed the final user
pointer destination as an argument, which doesn't match the 'write()'
function, and makes it very inconvenient to do a splice method for
ttys.

This is a conversion to use a kernel buffer instead.

NOTE! It does this by passing the tty line discipline ->read() function
an additional "cookie" to fill in, and an offset into the cookie data.

The line discipline can fill in the cookie data with its own private
information, and then the reader will repeat the read until either the
cookie is cleared or it runs out of data.

The only real user of this is N_HDLC, which can use this to handle big
packets, even if the kernel buffer is smaller than the whole packet.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/hci_ldisc.c | 34 +++++++--------
 drivers/input/serio/serport.c |  4 +-
 drivers/net/ppp/ppp_async.c   |  3 +-
 drivers/net/ppp/ppp_synctty.c |  3 +-
 drivers/tty/n_gsm.c           |  3 +-
 drivers/tty/n_hdlc.c          | 60 +++++++++++++++++--------
 drivers/tty/n_null.c          |  3 +-
 drivers/tty/n_r3964.c         | 10 ++---
 drivers/tty/n_tracerouter.c   |  4 +-
 drivers/tty/n_tracesink.c     |  4 +-
 drivers/tty/n_tty.c           | 82 +++++++++++++++--------------------
 drivers/tty/tty_io.c          | 64 +++++++++++++++++++++++++--
 include/linux/tty_ldisc.h     |  3 +-
 net/nfc/nci/uart.c            |  3 +-
 14 files changed, 178 insertions(+), 102 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 8be4d807d1370..637c5b8c2aa1a 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -801,7 +801,8 @@ static int hci_uart_tty_ioctl(struct tty_struct *tty, struct file *file,
  * We don't provide read/write/poll interface for user space.
  */
 static ssize_t hci_uart_tty_read(struct tty_struct *tty, struct file *file,
-				 unsigned char __user *buf, size_t nr)
+				 unsigned char *buf, size_t nr,
+				 void **cookie, unsigned long offset)
 {
 	return 0;
 }
@@ -818,29 +819,28 @@ static __poll_t hci_uart_tty_poll(struct tty_struct *tty,
 	return 0;
 }
 
+static struct tty_ldisc_ops hci_uart_ldisc = {
+	.owner		= THIS_MODULE,
+	.magic		= TTY_LDISC_MAGIC,
+	.name		= "n_hci",
+	.open		= hci_uart_tty_open,
+	.close		= hci_uart_tty_close,
+	.read		= hci_uart_tty_read,
+	.write		= hci_uart_tty_write,
+	.ioctl		= hci_uart_tty_ioctl,
+	.compat_ioctl	= hci_uart_tty_ioctl,
+	.poll		= hci_uart_tty_poll,
+	.receive_buf	= hci_uart_tty_receive,
+	.write_wakeup	= hci_uart_tty_wakeup,
+};
+
 static int __init hci_uart_init(void)
 {
-	static struct tty_ldisc_ops hci_uart_ldisc;
 	int err;
 
 	BT_INFO("HCI UART driver ver %s", VERSION);
 
 	/* Register the tty discipline */
-
-	memset(&hci_uart_ldisc, 0, sizeof(hci_uart_ldisc));
-	hci_uart_ldisc.magic		= TTY_LDISC_MAGIC;
-	hci_uart_ldisc.name		= "n_hci";
-	hci_uart_ldisc.open		= hci_uart_tty_open;
-	hci_uart_ldisc.close		= hci_uart_tty_close;
-	hci_uart_ldisc.read		= hci_uart_tty_read;
-	hci_uart_ldisc.write		= hci_uart_tty_write;
-	hci_uart_ldisc.ioctl		= hci_uart_tty_ioctl;
-	hci_uart_ldisc.compat_ioctl	= hci_uart_tty_ioctl;
-	hci_uart_ldisc.poll		= hci_uart_tty_poll;
-	hci_uart_ldisc.receive_buf	= hci_uart_tty_receive;
-	hci_uart_ldisc.write_wakeup	= hci_uart_tty_wakeup;
-	hci_uart_ldisc.owner		= THIS_MODULE;
-
 	err = tty_register_ldisc(N_HCI, &hci_uart_ldisc);
 	if (err) {
 		BT_ERR("HCI line discipline registration failed. (%d)", err);
diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 8ac970a423de6..33e9d9bfd036f 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -156,7 +156,9 @@ out:
  * returning 0 characters.
  */
 
-static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file, unsigned char __user * buf, size_t nr)
+static ssize_t serport_ldisc_read(struct tty_struct * tty, struct file * file,
+				  unsigned char *kbuf, size_t nr,
+				  void **cookie, unsigned long offset)
 {
 	struct serport *serport = (struct serport*) tty->disc_data;
 	struct serio *serio;
diff --git a/drivers/net/ppp/ppp_async.c b/drivers/net/ppp/ppp_async.c
index 29a0917a81e60..f14a9d190de91 100644
--- a/drivers/net/ppp/ppp_async.c
+++ b/drivers/net/ppp/ppp_async.c
@@ -259,7 +259,8 @@ static int ppp_asynctty_hangup(struct tty_struct *tty)
  */
 static ssize_t
 ppp_asynctty_read(struct tty_struct *tty, struct file *file,
-		  unsigned char __user *buf, size_t count)
+		  unsigned char *buf, size_t count,
+		  void **cookie, unsigned long offset)
 {
 	return -EAGAIN;
 }
diff --git a/drivers/net/ppp/ppp_synctty.c b/drivers/net/ppp/ppp_synctty.c
index 0f338752c38b9..f774b7e52da44 100644
--- a/drivers/net/ppp/ppp_synctty.c
+++ b/drivers/net/ppp/ppp_synctty.c
@@ -257,7 +257,8 @@ static int ppp_sync_hangup(struct tty_struct *tty)
  */
 static ssize_t
 ppp_sync_read(struct tty_struct *tty, struct file *file,
-	       unsigned char __user *buf, size_t count)
+	      unsigned char *buf, size_t count,
+	      void **cookie, unsigned long offset)
 {
 	return -EAGAIN;
 }
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 25f3152089c2a..fea1eeac5b907 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2557,7 +2557,8 @@ static void gsmld_write_wakeup(struct tty_struct *tty)
  */
 
 static ssize_t gsmld_read(struct tty_struct *tty, struct file *file,
-			 unsigned char __user *buf, size_t nr)
+			  unsigned char *buf, size_t nr,
+			  void **cookie, unsigned long offset)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/tty/n_hdlc.c b/drivers/tty/n_hdlc.c
index 12557ee1edb68..1363e659dc1db 100644
--- a/drivers/tty/n_hdlc.c
+++ b/drivers/tty/n_hdlc.c
@@ -416,13 +416,19 @@ static void n_hdlc_tty_receive(struct tty_struct *tty, const __u8 *data,
  * Returns the number of bytes returned or error code.
  */
 static ssize_t n_hdlc_tty_read(struct tty_struct *tty, struct file *file,
-			   __u8 __user *buf, size_t nr)
+			   __u8 *kbuf, size_t nr,
+			   void **cookie, unsigned long offset)
 {
 	struct n_hdlc *n_hdlc = tty->disc_data;
 	int ret = 0;
 	struct n_hdlc_buf *rbuf;
 	DECLARE_WAITQUEUE(wait, current);
 
+	/* Is this a repeated call for an rbuf we already found earlier? */
+	rbuf = *cookie;
+	if (rbuf)
+		goto have_rbuf;
+
 	add_wait_queue(&tty->read_wait, &wait);
 
 	for (;;) {
@@ -436,25 +442,8 @@ static ssize_t n_hdlc_tty_read(struct tty_struct *tty, struct file *file,
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		rbuf = n_hdlc_buf_get(&n_hdlc->rx_buf_list);
-		if (rbuf) {
-			if (rbuf->count > nr) {
-				/* too large for caller's buffer */
-				ret = -EOVERFLOW;
-			} else {
-				__set_current_state(TASK_RUNNING);
-				if (copy_to_user(buf, rbuf->buf, rbuf->count))
-					ret = -EFAULT;
-				else
-					ret = rbuf->count;
-			}
-
-			if (n_hdlc->rx_free_buf_list.count >
-			    DEFAULT_RX_BUF_COUNT)
-				kfree(rbuf);
-			else
-				n_hdlc_buf_put(&n_hdlc->rx_free_buf_list, rbuf);
+		if (rbuf)
 			break;
-		}
 
 		/* no data */
 		if (tty_io_nonblock(tty, file)) {
@@ -473,6 +462,39 @@ static ssize_t n_hdlc_tty_read(struct tty_struct *tty, struct file *file,
 	remove_wait_queue(&tty->read_wait, &wait);
 	__set_current_state(TASK_RUNNING);
 
+	if (!rbuf)
+		return ret;
+	*cookie = rbuf;
+
+have_rbuf:
+	/* Have we used it up entirely? */
+	if (offset >= rbuf->count)
+		goto done_with_rbuf;
+
+	/* More data to go, but can't copy any more? EOVERFLOW */
+	ret = -EOVERFLOW;
+	if (!nr)
+		goto done_with_rbuf;
+
+	/* Copy as much data as possible */
+	ret = rbuf->count - offset;
+	if (ret > nr)
+		ret = nr;
+	memcpy(kbuf, rbuf->buf+offset, ret);
+	offset += ret;
+
+	/* If we still have data left, we leave the rbuf in the cookie */
+	if (offset < rbuf->count)
+		return ret;
+
+done_with_rbuf:
+	*cookie = NULL;
+
+	if (n_hdlc->rx_free_buf_list.count > DEFAULT_RX_BUF_COUNT)
+		kfree(rbuf);
+	else
+		n_hdlc_buf_put(&n_hdlc->rx_free_buf_list, rbuf);
+
 	return ret;
 
 }	/* end of n_hdlc_tty_read() */
diff --git a/drivers/tty/n_null.c b/drivers/tty/n_null.c
index 96feabae47407..ce03ae78f5c6a 100644
--- a/drivers/tty/n_null.c
+++ b/drivers/tty/n_null.c
@@ -20,7 +20,8 @@ static void n_null_close(struct tty_struct *tty)
 }
 
 static ssize_t n_null_read(struct tty_struct *tty, struct file *file,
-			   unsigned char __user * buf, size_t nr)
+			   unsigned char *buf, size_t nr,
+			   void **cookie, unsigned long offset)
 {
 	return -EOPNOTSUPP;
 }
diff --git a/drivers/tty/n_r3964.c b/drivers/tty/n_r3964.c
index 934dd2fb2ec80..3161f0a535e37 100644
--- a/drivers/tty/n_r3964.c
+++ b/drivers/tty/n_r3964.c
@@ -129,7 +129,7 @@ static void remove_client_block(struct r3964_info *pInfo,
 static int r3964_open(struct tty_struct *tty);
 static void r3964_close(struct tty_struct *tty);
 static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
-		unsigned char __user * buf, size_t nr);
+		void *cookie, unsigned char *buf, size_t nr);
 static ssize_t r3964_write(struct tty_struct *tty, struct file *file,
 		const unsigned char *buf, size_t nr);
 static int r3964_ioctl(struct tty_struct *tty, struct file *file,
@@ -1058,7 +1058,8 @@ static void r3964_close(struct tty_struct *tty)
 }
 
 static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
-			  unsigned char __user * buf, size_t nr)
+			  unsigned char *kbuf, size_t nr,
+			  void **cookie, unsigned long offset)
 {
 	struct r3964_info *pInfo = tty->disc_data;
 	struct r3964_client_info *pClient;
@@ -1109,10 +1110,7 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 		kfree(pMsg);
 		TRACE_M("r3964_read - msg kfree %p", pMsg);
 
-		if (copy_to_user(buf, &theMsg, ret)) {
-			ret = -EFAULT;
-			goto unlock;
-		}
+		memcpy(kbuf, &theMsg, ret);
 
 		TRACE_PS("read - return %d", ret);
 		goto unlock;
diff --git a/drivers/tty/n_tracerouter.c b/drivers/tty/n_tracerouter.c
index 4479af4d2fa5c..3490ed51b1a3c 100644
--- a/drivers/tty/n_tracerouter.c
+++ b/drivers/tty/n_tracerouter.c
@@ -118,7 +118,9 @@ static void n_tracerouter_close(struct tty_struct *tty)
  *	 -EINVAL
  */
 static ssize_t n_tracerouter_read(struct tty_struct *tty, struct file *file,
-				  unsigned char __user *buf, size_t nr) {
+				  unsigned char *buf, size_t nr,
+				  void **cookie, unsigned long offset)
+{
 	return -EINVAL;
 }
 
diff --git a/drivers/tty/n_tracesink.c b/drivers/tty/n_tracesink.c
index d96ba82cc3569..1d9931041fd8b 100644
--- a/drivers/tty/n_tracesink.c
+++ b/drivers/tty/n_tracesink.c
@@ -115,7 +115,9 @@ static void n_tracesink_close(struct tty_struct *tty)
  *	 -EINVAL
  */
 static ssize_t n_tracesink_read(struct tty_struct *tty, struct file *file,
-				unsigned char __user *buf, size_t nr) {
+				unsigned char *buf, size_t nr,
+				void **cookie, unsigned long offset)
+{
 	return -EINVAL;
 }
 
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index c2869489ba681..e8963165082ee 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -164,29 +164,24 @@ static void zero_buffer(struct tty_struct *tty, u8 *buffer, int size)
 		memset(buffer, 0x00, size);
 }
 
-static int tty_copy_to_user(struct tty_struct *tty, void __user *to,
-			    size_t tail, size_t n)
+static void tty_copy(struct tty_struct *tty, void *to, size_t tail, size_t n)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	size_t size = N_TTY_BUF_SIZE - tail;
 	void *from = read_buf_addr(ldata, tail);
-	int uncopied;
 
 	if (n > size) {
 		tty_audit_add_data(tty, from, size);
-		uncopied = copy_to_user(to, from, size);
-		zero_buffer(tty, from, size - uncopied);
-		if (uncopied)
-			return uncopied;
+		memcpy(to, from, size);
+		zero_buffer(tty, from, size);
 		to += size;
 		n -= size;
 		from = ldata->read_buf;
 	}
 
 	tty_audit_add_data(tty, from, n);
-	uncopied = copy_to_user(to, from, n);
-	zero_buffer(tty, from, n - uncopied);
-	return uncopied;
+	memcpy(to, from, n);
+	zero_buffer(tty, from, n);
 }
 
 /**
@@ -1942,15 +1937,16 @@ static inline int input_available_p(struct tty_struct *tty, int poll)
 /**
  *	copy_from_read_buf	-	copy read data directly
  *	@tty: terminal device
- *	@b: user data
+ *	@kbp: data
  *	@nr: size of data
  *
  *	Helper function to speed up n_tty_read.  It is only called when
- *	ICANON is off; it copies characters straight from the tty queue to
- *	user space directly.  It can be profitably called twice; once to
- *	drain the space from the tail pointer to the (physical) end of the
- *	buffer, and once to drain the space from the (physical) beginning of
- *	the buffer to head pointer.
+ *	ICANON is off; it copies characters straight from the tty queue.
+ *
+ *	It can be profitably called twice; once to drain the space from
+ *	the tail pointer to the (physical) end of the buffer, and once
+ *	to drain the space from the (physical) beginning of the buffer
+ *	to head pointer.
  *
  *	Called under the ldata->atomic_read_lock sem
  *
@@ -1960,7 +1956,7 @@ static inline int input_available_p(struct tty_struct *tty, int poll)
  */
 
 static int copy_from_read_buf(struct tty_struct *tty,
-				      unsigned char __user **b,
+				      unsigned char **kbp,
 				      size_t *nr)
 
 {
@@ -1976,8 +1972,7 @@ static int copy_from_read_buf(struct tty_struct *tty,
 	n = min(*nr, n);
 	if (n) {
 		unsigned char *from = read_buf_addr(ldata, tail);
-		retval = copy_to_user(*b, from, n);
-		n -= retval;
+		memcpy(*kbp, from, n);
 		is_eof = n == 1 && *from == EOF_CHAR(tty);
 		tty_audit_add_data(tty, from, n);
 		zero_buffer(tty, from, n);
@@ -1986,7 +1981,7 @@ static int copy_from_read_buf(struct tty_struct *tty,
 		if (L_EXTPROC(tty) && ldata->icanon && is_eof &&
 		    (head == ldata->read_tail))
 			n = 0;
-		*b += n;
+		*kbp += n;
 		*nr -= n;
 	}
 	return retval;
@@ -1995,12 +1990,12 @@ static int copy_from_read_buf(struct tty_struct *tty,
 /**
  *	canon_copy_from_read_buf	-	copy read data in canonical mode
  *	@tty: terminal device
- *	@b: user data
+ *	@kbp: data
  *	@nr: size of data
  *
  *	Helper function for n_tty_read.  It is only called when ICANON is on;
  *	it copies one line of input up to and including the line-delimiting
- *	character into the user-space buffer.
+ *	character into the result buffer.
  *
  *	NB: When termios is changed from non-canonical to canonical mode and
  *	the read buffer contains data, n_tty_set_termios() simulates an EOF
@@ -2016,14 +2011,14 @@ static int copy_from_read_buf(struct tty_struct *tty,
  */
 
 static int canon_copy_from_read_buf(struct tty_struct *tty,
-				    unsigned char __user **b,
+				    unsigned char **kbp,
 				    size_t *nr)
 {
 	struct n_tty_data *ldata = tty->disc_data;
 	size_t n, size, more, c;
 	size_t eol;
 	size_t tail;
-	int ret, found = 0;
+	int found = 0;
 
 	/* N.B. avoid overrun if nr == 0 */
 	if (!*nr)
@@ -2059,10 +2054,8 @@ static int canon_copy_from_read_buf(struct tty_struct *tty,
 	n_tty_trace("%s: eol:%zu found:%d n:%zu c:%zu tail:%zu more:%zu\n",
 		    __func__, eol, found, n, c, tail, more);
 
-	ret = tty_copy_to_user(tty, *b, tail, n);
-	if (ret)
-		return -EFAULT;
-	*b += n;
+	tty_copy(tty, *kbp, tail, n);
+	*kbp += n;
 	*nr -= n;
 
 	if (found)
@@ -2127,10 +2120,11 @@ static int job_control(struct tty_struct *tty, struct file *file)
  */
 
 static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
-			 unsigned char __user *buf, size_t nr)
+			  unsigned char *kbuf, size_t nr,
+			  void **cookie, unsigned long offset)
 {
 	struct n_tty_data *ldata = tty->disc_data;
-	unsigned char __user *b = buf;
+	unsigned char *kb = kbuf;
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int c;
 	int minimum, time;
@@ -2176,17 +2170,13 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 		/* First test for status change. */
 		if (packet && tty->link->ctrl_status) {
 			unsigned char cs;
-			if (b != buf)
+			if (kb != kbuf)
 				break;
 			spin_lock_irq(&tty->link->ctrl_lock);
 			cs = tty->link->ctrl_status;
 			tty->link->ctrl_status = 0;
 			spin_unlock_irq(&tty->link->ctrl_lock);
-			if (put_user(cs, b)) {
-				retval = -EFAULT;
-				break;
-			}
-			b++;
+			*kb++ = cs;
 			nr--;
 			break;
 		}
@@ -2229,24 +2219,20 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 		}
 
 		if (ldata->icanon && !L_EXTPROC(tty)) {
-			retval = canon_copy_from_read_buf(tty, &b, &nr);
+			retval = canon_copy_from_read_buf(tty, &kb, &nr);
 			if (retval)
 				break;
 		} else {
 			int uncopied;
 
 			/* Deal with packet mode. */
-			if (packet && b == buf) {
-				if (put_user(TIOCPKT_DATA, b)) {
-					retval = -EFAULT;
-					break;
-				}
-				b++;
+			if (packet && kb == kbuf) {
+				*kb++ = TIOCPKT_DATA;
 				nr--;
 			}
 
-			uncopied = copy_from_read_buf(tty, &b, &nr);
-			uncopied += copy_from_read_buf(tty, &b, &nr);
+			uncopied = copy_from_read_buf(tty, &kb, &nr);
+			uncopied += copy_from_read_buf(tty, &kb, &nr);
 			if (uncopied) {
 				retval = -EFAULT;
 				break;
@@ -2255,7 +2241,7 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 
 		n_tty_check_unthrottle(tty);
 
-		if (b - buf >= minimum)
+		if (kb - kbuf >= minimum)
 			break;
 		if (time)
 			timeout = time;
@@ -2267,8 +2253,8 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 	remove_wait_queue(&tty->read_wait, &wait);
 	mutex_unlock(&ldata->atomic_read_lock);
 
-	if (b - buf)
-		retval = b - buf;
+	if (kb - kbuf)
+		retval = kb - kbuf;
 
 	return retval;
 }
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 21cd5ac6ca8b5..a50c8a4318228 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -830,6 +830,65 @@ static void tty_update_time(struct timespec64 *time)
 		time->tv_sec = sec;
 }
 
+/*
+ * Iterate on the ldisc ->read() function until we've gotten all
+ * the data the ldisc has for us.
+ *
+ * The "cookie" is something that the ldisc read function can fill
+ * in to let us know that there is more data to be had.
+ *
+ * We promise to continue to call the ldisc until it stops returning
+ * data or clears the cookie. The cookie may be something that the
+ * ldisc maintains state for and needs to free.
+ */
+static int iterate_tty_read(struct tty_ldisc *ld, struct tty_struct *tty, struct file *file,
+		char __user *buf, size_t count)
+{
+	int retval = 0;
+	void *cookie = NULL;
+	unsigned long offset = 0;
+	char kernel_buf[64];
+
+	do {
+		int size, uncopied;
+
+		size = count > sizeof(kernel_buf) ? sizeof(kernel_buf) : count;
+		size = ld->ops->read(tty, file, kernel_buf, size, &cookie, offset);
+		if (!size)
+			break;
+
+		/*
+		 * A ldisc read error return will override any previously copied
+		 * data (eg -EOVERFLOW from HDLC)
+		 */
+		if (size < 0) {
+			memzero_explicit(kernel_buf, sizeof(kernel_buf));
+			return size;
+		}
+
+		uncopied = copy_to_user(buf+offset, kernel_buf, size);
+		size -= uncopied;
+		offset += size;
+		count -= size;
+
+		/*
+		 * If the user copy failed, we still need to do another ->read()
+		 * call if we had a cookie to let the ldisc clear up.
+		 *
+		 * But make sure size is zeroed.
+		 */
+		if (unlikely(uncopied)) {
+			count = 0;
+			retval = -EFAULT;
+		}
+	} while (cookie);
+
+	/* We always clear tty buffer in case they contained passwords */
+	memzero_explicit(kernel_buf, sizeof(kernel_buf));
+	return offset ? offset : retval;
+}
+
+
 /**
  *	tty_read	-	read method for tty device files
  *	@file: pointer to tty file
@@ -863,10 +922,9 @@ static ssize_t tty_read(struct file *file, char __user *buf, size_t count,
 	ld = tty_ldisc_ref_wait(tty);
 	if (!ld)
 		return hung_up_tty_read(file, buf, count, ppos);
+	i = -EIO;
 	if (ld->ops->read)
-		i = ld->ops->read(tty, file, buf, count);
-	else
-		i = -EIO;
+		i = iterate_tty_read(ld, tty, file, buf, count);
 	tty_ldisc_deref(ld);
 
 	if (i > 0)
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index b1e6043e99175..572a079761165 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -185,7 +185,8 @@ struct tty_ldisc_ops {
 	void	(*close)(struct tty_struct *);
 	void	(*flush_buffer)(struct tty_struct *tty);
 	ssize_t	(*read)(struct tty_struct *tty, struct file *file,
-			unsigned char __user *buf, size_t nr);
+			unsigned char *buf, size_t nr,
+			void **cookie, unsigned long offset);
 	ssize_t	(*write)(struct tty_struct *tty, struct file *file,
 			 const unsigned char *buf, size_t nr);
 	int	(*ioctl)(struct tty_struct *tty, struct file *file,
diff --git a/net/nfc/nci/uart.c b/net/nfc/nci/uart.c
index 11b554ce07ffc..1204c438e87dc 100644
--- a/net/nfc/nci/uart.c
+++ b/net/nfc/nci/uart.c
@@ -292,7 +292,8 @@ static int nci_uart_tty_ioctl(struct tty_struct *tty, struct file *file,
 
 /* We don't provide read/write/poll interface for user space. */
 static ssize_t nci_uart_tty_read(struct tty_struct *tty, struct file *file,
-				 unsigned char __user *buf, size_t nr)
+				 unsigned char *buf, size_t nr,
+				 void **cookie, unsigned long offset)
 {
 	return 0;
 }
-- 
2.27.0



