Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5F511B4EB
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732137AbfLKPXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:23:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:54542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732442AbfLKPXa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F3862077B;
        Wed, 11 Dec 2019 15:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077810;
        bh=9HIukwdJ6Blfu5phf9vcWxH++CWcCuidXrY1XXmWsFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hjQ2BfpeGHI0WVwGN1kwheUL8AhvDKNTt2L/OjtjrqxMvtgKI/S2gAADu4k6pXGfp
         O/b6XX/TAEzddItI46k8FW1w8TxxWsiQN1KbLRIB8OVOYdKy9diab76fFJ6UH2gJRZ
         9CgeE0K+TYS0LKn7xJkCb8IiN7saTTak+6G1juXA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Dmitry Safonov <dima@arista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 178/243] tty: Dont block on IO when ldisc change is pending
Date:   Wed, 11 Dec 2019 16:05:40 +0100
Message-Id: <20191211150351.188475500@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
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
index c943716c019e4..0636e10c76c7f 100644
--- a/drivers/tty/n_hdlc.c
+++ b/drivers/tty/n_hdlc.c
@@ -613,7 +613,7 @@ static ssize_t n_hdlc_tty_read(struct tty_struct *tty, struct file *file,
 		}
 			
 		/* no data */
-		if (file->f_flags & O_NONBLOCK) {
+		if (tty_io_nonblock(tty, file)) {
 			ret = -EAGAIN;
 			break;
 		}
@@ -680,7 +680,7 @@ static ssize_t n_hdlc_tty_write(struct tty_struct *tty, struct file *file,
 		if (tbuf)
 			break;
 
-		if (file->f_flags & O_NONBLOCK) {
+		if (tty_io_nonblock(tty, file)) {
 			error = -EAGAIN;
 			break;
 		}
diff --git a/drivers/tty/n_r3964.c b/drivers/tty/n_r3964.c
index dbf1ab36758eb..a3969b773cbe4 100644
--- a/drivers/tty/n_r3964.c
+++ b/drivers/tty/n_r3964.c
@@ -1078,7 +1078,7 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 		pMsg = remove_msg(pInfo, pClient);
 		if (pMsg == NULL) {
 			/* no messages available. */
-			if (file->f_flags & O_NONBLOCK) {
+			if (tty_io_nonblock(tty, file)) {
 				ret = -EAGAIN;
 				goto unlock;
 			}
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 3ad460219fd62..5dc9686697cfa 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1702,7 +1702,7 @@ n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
 
 	down_read(&tty->termios_rwsem);
 
-	while (1) {
+	do {
 		/*
 		 * When PARMRK is set, each input char may take up to 3 chars
 		 * in the read buf; reduce the buffer space avail by 3x
@@ -1744,7 +1744,7 @@ n_tty_receive_buf_common(struct tty_struct *tty, const unsigned char *cp,
 			fp += n;
 		count -= n;
 		rcvd += n;
-	}
+	} while (!test_bit(TTY_LDISC_CHANGING, &tty->flags));
 
 	tty->receive_room = room;
 
@@ -2211,7 +2211,7 @@ static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 					break;
 				if (!timeout)
 					break;
-				if (file->f_flags & O_NONBLOCK) {
+				if (tty_io_nonblock(tty, file)) {
 					retval = -EAGAIN;
 					break;
 				}
@@ -2365,7 +2365,7 @@ static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 		}
 		if (!nr)
 			break;
-		if (file->f_flags & O_NONBLOCK) {
+		if (tty_io_nonblock(tty, file)) {
 			retval = -EAGAIN;
 			break;
 		}
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 53bb6d4e9e8d9..245c9a51c2de2 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -336,6 +336,11 @@ int tty_ldisc_lock(struct tty_struct *tty, unsigned long timeout)
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
@@ -346,6 +351,8 @@ int tty_ldisc_lock(struct tty_struct *tty, unsigned long timeout)
 void tty_ldisc_unlock(struct tty_struct *tty)
 {
 	clear_bit(TTY_LDISC_HALTED, &tty->flags);
+	/* Can be cleared here - ldisc_unlock will wake up writers firstly */
+	clear_bit(TTY_LDISC_CHANGING, &tty->flags);
 	__tty_ldisc_unlock(tty);
 }
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 808fbfe86f858..76db046f09ab6 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -366,6 +366,7 @@ struct tty_file_private {
 #define TTY_NO_WRITE_SPLIT 	17	/* Preserve write boundaries to driver */
 #define TTY_HUPPED 		18	/* Post driver->hangup() */
 #define TTY_HUPPING		19	/* Hangup in progress */
+#define TTY_LDISC_CHANGING	20	/* Change pending - non-block IO */
 #define TTY_LDISC_HALTED	22	/* Line discipline is halted */
 
 /* Values for tty->flow_change */
@@ -383,6 +384,12 @@ static inline void tty_set_flow_change(struct tty_struct *tty, int val)
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



