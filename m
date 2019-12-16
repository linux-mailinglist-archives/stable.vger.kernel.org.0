Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF40D1218C7
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbfLPR4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 12:56:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:54414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727398AbfLPR4W (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 12:56:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C99E205ED;
        Mon, 16 Dec 2019 17:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576518981;
        bh=S/ZI0/t3JJ3sZ1nghjzdLLcA7v4p3ZJs0Zv7kefuPyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kFWJdf2MvkpCtmkh1RSsDfqWnWO+ZEfhAIVXvkTlpm4nmJtau+v5Cf9qn5TiKfb+b
         bvnBR14vPp+7PmeT8XQc4vcSOC3nvfb9Q2FXEo4nM5Vm4ywrCWZmalnM7HSLIZBfpC
         m2t0/Yas9fuP4OtxOmP71qOC5OQ0qUsQ+aLcbpxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Dmitry Safonov <dima@arista.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 108/267] tty: Dont block on IO when ldisc change is pending
Date:   Mon, 16 Dec 2019 18:47:14 +0100
Message-Id: <20191216174902.634453449@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
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
index e83dea8d6633a..19c4aa800c810 100644
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
index 305b6490d4053..08ac04d089916 100644
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
index 01fcdc7ff0771..62dd2abb57fea 100644
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
index 1dd587ba6d882..0cd621d8c7f05 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -365,6 +365,7 @@ struct tty_file_private {
 #define TTY_NO_WRITE_SPLIT 	17	/* Preserve write boundaries to driver */
 #define TTY_HUPPED 		18	/* Post driver->hangup() */
 #define TTY_HUPPING		19	/* Hangup in progress */
+#define TTY_LDISC_CHANGING	20	/* Change pending - non-block IO */
 #define TTY_LDISC_HALTED	22	/* Line discipline is halted */
 
 /* Values for tty->flow_change */
@@ -382,6 +383,12 @@ static inline void tty_set_flow_change(struct tty_struct *tty, int val)
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



