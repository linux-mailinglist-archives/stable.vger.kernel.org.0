Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85396126A22
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:44:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728991AbfLSSoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:44:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728985AbfLSSoY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:44:24 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9E7224686;
        Thu, 19 Dec 2019 18:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781063;
        bh=+pXstj1akIlpYdwN1UUXNtNGfKWRZp8HuK14W+SVRR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AwgIb/gl75HbP1fOLoS8OAxi0Vi/8RncidSWLBBpp+VyrL4OM8+OgoC3aqlautbua
         YsbMrnn0ym2A3M2rTsSi0/dABJC69gf+5AjbV1OBvnIk1+0iu8lzND+s/Xbejys3Zl
         dhK9lHge2vlUOoaOl/TF4tY5NobG7AJAxLDr4g5c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Dmitry Safonov <dima@arista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 067/199] tty: Dont block on IO when ldisc change is pending
Date:   Thu, 19 Dec 2019 19:32:29 +0100
Message-Id: <20191219183218.710721089@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

[ Upstream commit c96cf923a98d1b094df9f0cf97a83e118817e31b ]

There might be situations where tty_ldisc_lock() has blocked, but there
is already IO on tty and it prevents line discipline changes.
It might theoretically turn into dead-lock.

Basically, provide more priority to pending tty_ldisc_lock() than to
servicing reads/writes over tty.

User-visible issue was reported by Mikulas where on pa-risc with
Debian 5 reboot took either 80 seconds, 3 minutes or 3:25 after proper
locking in tty_reopen().

Cc: Jiri Slaby <jslaby@suse.com>
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/n_hdlc.c    | 4 ++--
 drivers/tty/n_r3964.c   | 2 +-
 drivers/tty/n_tty.c     | 8 ++++----
 drivers/tty/tty_ldisc.c | 7 +++++++
 include/linux/tty.h     | 7 +++++++
 5 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/n_hdlc.c b/drivers/tty/n_hdlc.c
index 8d6253903f24f..0c12dec110bc4 100644
--- a/drivers/tty/n_hdlc.c
+++ b/drivers/tty/n_hdlc.c
@@ -614,7 +614,7 @@ static ssize_t n_hdlc_tty_read(struct tty_struct *tty, struct file *file,
 		}
 			
 		/* no data */
-		if (file->f_flags & O_NONBLOCK) {
+		if (tty_io_nonblock(tty, file)) {
 			ret = -EAGAIN;
 			break;
 		}
@@ -681,7 +681,7 @@ static ssize_t n_hdlc_tty_write(struct tty_struct *tty, struct file *file,
 		if (tbuf)
 			break;
 
-		if (file->f_flags & O_NONBLOCK) {
+		if (tty_io_nonblock(tty, file)) {
 			error = -EAGAIN;
 			break;
 		}
diff --git a/drivers/tty/n_r3964.c b/drivers/tty/n_r3964.c
index 345111467b850..ee0e07b4a13d0 100644
--- a/drivers/tty/n_r3964.c
+++ b/drivers/tty/n_r3964.c
@@ -1080,7 +1080,7 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 		pMsg = remove_msg(pInfo, pClient);
 		if (pMsg == NULL) {
 			/* no messages available. */
-			if (file->f_flags & O_NONBLOCK) {
+			if (tty_io_nonblock(tty, file)) {
 				ret = -EAGAIN;
 				goto unlock;
 			}
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 904fc9c37fdea..8214b0326b3a1 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1704,7 +1704,7 @@ n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
 
 	down_read(&tty->termios_rwsem);
 
-	while (1) {
+	do {
 		/*
 		 * When PARMRK is set, each input char may take up to 3 chars
 		 * in the read buf; reduce the buffer space avail by 3x
@@ -1746,7 +1746,7 @@ n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
 			fp += n;
 		count -= n;
 		rcvd += n;
-	}
+	} while (!test_bit(TTY_LDISC_CHANGING, &tty->flags));
 
 	tty->receive_room = room;
 
@@ -2213,7 +2213,7 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 					break;
 				if (!timeout)
 					break;
-				if (file->f_flags & O_NONBLOCK) {
+				if (tty_io_nonblock(tty, file)) {
 					retval = -EAGAIN;
 					break;
 				}
@@ -2367,7 +2367,7 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 		}
 		if (!nr)
 			break;
-		if (file->f_flags & O_NONBLOCK) {
+		if (tty_io_nonblock(tty, file)) {
 			retval = -EAGAIN;
 			break;
 		}
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 3eb3f2a03bbb9..706faca834f27 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -348,6 +348,11 @@ int tty_ldisc_lock(struct tty_struct *tty, unsigned long timeout)
 {
 	int ret;
 
+	/* Kindly asking blocked readers to release the read side */
+	set_bit(TTY_LDISC_CHANGING, &tty->flags);
+	wake_up_interruptible_all(&tty->read_wait);
+	wake_up_interruptible_all(&tty->write_wait);
+
 	ret = __tty_ldisc_lock(tty, timeout);
 	if (!ret)
 		return -EBUSY;
@@ -358,6 +363,8 @@ int tty_ldisc_lock(struct tty_struct *tty, unsigned long timeout)
 void tty_ldisc_unlock(struct tty_struct *tty)
 {
 	clear_bit(TTY_LDISC_HALTED, &tty->flags);
+	/* Can be cleared here - ldisc_unlock will wake up writers firstly */
+	clear_bit(TTY_LDISC_CHANGING, &tty->flags);
 	__tty_ldisc_unlock(tty);
 }
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index fe1b8623a3a1f..fe483976b1193 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -356,6 +356,7 @@ struct tty_file_private {
 #define TTY_NO_WRITE_SPLIT 	17	/* Preserve write boundaries to driver */
 #define TTY_HUPPED 		18	/* Post driver->hangup() */
 #define TTY_HUPPING		19	/* Hangup in progress */
+#define TTY_LDISC_CHANGING	20	/* Change pending - non-block IO */
 #define TTY_LDISC_HALTED	22	/* Line discipline is halted */
 
 /* Values for tty->flow_change */
@@ -373,6 +374,12 @@ static inline void tty_set_flow_change(struct tty_struct *tty, int val)
 	smp_mb();
 }
 
+static inline bool tty_io_nonblock(struct tty_struct *tty, struct file *file)
+{
+	return file->f_flags & O_NONBLOCK ||
+		test_bit(TTY_LDISC_CHANGING, &tty->flags);
+}
+
 static inline bool tty_io_error(struct tty_struct *tty)
 {
 	return test_bit(TTY_IO_ERROR, &tty->flags);
-- 
2.20.1



