Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F356747AD53
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236236AbhLTOvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:51:15 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54486 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236726AbhLTOt3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:49:29 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 543E0B80EB3;
        Mon, 20 Dec 2021 14:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852B0C36AE7;
        Mon, 20 Dec 2021 14:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011767;
        bh=R/fl/XWtezSMRY0BwaliBkDRbbav2JoWmpqKxKcBL5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OckjfUwZpXxvhockTDXL1JDyR4/lkD0S0kIb0gZ55kZ7vNI9U4JGsgEQtQ8Kd40wj
         AYjv+juMqovZSggSrgZZbOyy+F5tEawF8Dd+546R/S8hmpuyOPj2g38Tv8uavpT5Ee
         uJ/vXDPWuJooGz6hSxZckt3M0+g1O04r09pOxWeM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+5f47a8cea6a12b77a876@syzkaller.appspotmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 5.10 67/99] tty: n_hdlc: make n_hdlc_tty_wakeup() asynchronous
Date:   Mon, 20 Dec 2021 15:34:40 +0100
Message-Id: <20211220143031.649396763@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

commit 1ee33b1ca2b8dabfcc17198ffd049a6b55674a86 upstream.

syzbot is reporting that an unprivileged user who logged in from tty
console can crash the system using a reproducer shown below [1], for
n_hdlc_tty_wakeup() is synchronously calling n_hdlc_send_frames().

----------
  #include <sys/ioctl.h>
  #include <unistd.h>

  int main(int argc, char *argv[])
  {
    const int disc = 0xd;

    ioctl(1, TIOCSETD, &disc);
    while (1) {
      ioctl(1, TCXONC, 0);
      write(1, "", 1);
      ioctl(1, TCXONC, 1); /* Kernel panic - not syncing: scheduling while atomic */
    }
  }
----------

Linus suspected that "struct tty_ldisc"->ops->write_wakeup() must not
sleep, and Jiri confirmed it from include/linux/tty_ldisc.h. Thus, defer
n_hdlc_send_frames() from n_hdlc_tty_wakeup() to a WQ context like
net/nfc/nci/uart.c does.

Link: https://syzkaller.appspot.com/bug?extid=5f47a8cea6a12b77a876 [1]
Reported-by: syzbot <syzbot+5f47a8cea6a12b77a876@syzkaller.appspotmail.com>
Cc: stable <stable@vger.kernel.org>
Analyzed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Confirmed-by: Jiri Slaby <jirislaby@kernel.org>
Reviewed-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Link: https://lore.kernel.org/r/40de8b7e-a3be-4486-4e33-1b1d1da452f8@i-love.sakura.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/n_hdlc.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

--- a/drivers/tty/n_hdlc.c
+++ b/drivers/tty/n_hdlc.c
@@ -139,6 +139,8 @@ struct n_hdlc {
 	struct n_hdlc_buf_list	rx_buf_list;
 	struct n_hdlc_buf_list	tx_free_buf_list;
 	struct n_hdlc_buf_list	rx_free_buf_list;
+	struct work_struct	write_work;
+	struct tty_struct	*tty_for_write_work;
 };
 
 /*
@@ -153,6 +155,7 @@ static struct n_hdlc_buf *n_hdlc_buf_get
 /* Local functions */
 
 static struct n_hdlc *n_hdlc_alloc(void);
+static void n_hdlc_tty_write_work(struct work_struct *work);
 
 /* max frame size for memory allocations */
 static int maxframe = 4096;
@@ -209,6 +212,8 @@ static void n_hdlc_tty_close(struct tty_
 	wake_up_interruptible(&tty->read_wait);
 	wake_up_interruptible(&tty->write_wait);
 
+	cancel_work_sync(&n_hdlc->write_work);
+
 	n_hdlc_free_buf_list(&n_hdlc->rx_free_buf_list);
 	n_hdlc_free_buf_list(&n_hdlc->tx_free_buf_list);
 	n_hdlc_free_buf_list(&n_hdlc->rx_buf_list);
@@ -240,6 +245,8 @@ static int n_hdlc_tty_open(struct tty_st
 		return -ENFILE;
 	}
 
+	INIT_WORK(&n_hdlc->write_work, n_hdlc_tty_write_work);
+	n_hdlc->tty_for_write_work = tty;
 	tty->disc_data = n_hdlc;
 	tty->receive_room = 65536;
 
@@ -334,6 +341,20 @@ check_again:
 }	/* end of n_hdlc_send_frames() */
 
 /**
+ * n_hdlc_tty_write_work - Asynchronous callback for transmit wakeup
+ * @work: pointer to work_struct
+ *
+ * Called when low level device driver can accept more send data.
+ */
+static void n_hdlc_tty_write_work(struct work_struct *work)
+{
+	struct n_hdlc *n_hdlc = container_of(work, struct n_hdlc, write_work);
+	struct tty_struct *tty = n_hdlc->tty_for_write_work;
+
+	n_hdlc_send_frames(n_hdlc, tty);
+}	/* end of n_hdlc_tty_write_work() */
+
+/**
  * n_hdlc_tty_wakeup - Callback for transmit wakeup
  * @tty: pointer to associated tty instance data
  *
@@ -343,7 +364,7 @@ static void n_hdlc_tty_wakeup(struct tty
 {
 	struct n_hdlc *n_hdlc = tty->disc_data;
 
-	n_hdlc_send_frames(n_hdlc, tty);
+	schedule_work(&n_hdlc->write_work);
 }	/* end of n_hdlc_tty_wakeup() */
 
 /**


