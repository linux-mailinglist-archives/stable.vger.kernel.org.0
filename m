Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6E447AF7F
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239779AbhLTPN7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239934AbhLTPMS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:12:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96B4C08EB3F;
        Mon, 20 Dec 2021 06:56:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 795F5B80EEB;
        Mon, 20 Dec 2021 14:56:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3C3AC36AE7;
        Mon, 20 Dec 2021 14:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012198;
        bh=QS3/dkB+tB/5IAh2e9vOTrOIW7Lz2+qYnejvi53vs0Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MIj8rg51WlHEufs+OCihy9aHjv++Q7wjlmCdYA5yFmbBSIAPKAVYlo2prsFnlI6dl
         Aob+r71GknmCZP7aalap63Fq8WV1Jy9tF++FcwJincqlw9vOvOc/GQ2MW/MkRIPByp
         OqdKIdkO2AgdcTb2JYVJdVdAILwn4RX3cSiy3ipI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+5f47a8cea6a12b77a876@syzkaller.appspotmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Jiri Slaby <jirislaby@kernel.org>
Subject: [PATCH 5.15 116/177] tty: n_hdlc: make n_hdlc_tty_wakeup() asynchronous
Date:   Mon, 20 Dec 2021 15:34:26 +0100
Message-Id: <20211220143043.982140657@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
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
@@ -140,6 +140,8 @@ struct n_hdlc {
 	struct n_hdlc_buf_list	rx_buf_list;
 	struct n_hdlc_buf_list	tx_free_buf_list;
 	struct n_hdlc_buf_list	rx_free_buf_list;
+	struct work_struct	write_work;
+	struct tty_struct	*tty_for_write_work;
 };
 
 /*
@@ -154,6 +156,7 @@ static struct n_hdlc_buf *n_hdlc_buf_get
 /* Local functions */
 
 static struct n_hdlc *n_hdlc_alloc(void);
+static void n_hdlc_tty_write_work(struct work_struct *work);
 
 /* max frame size for memory allocations */
 static int maxframe = 4096;
@@ -210,6 +213,8 @@ static void n_hdlc_tty_close(struct tty_
 	wake_up_interruptible(&tty->read_wait);
 	wake_up_interruptible(&tty->write_wait);
 
+	cancel_work_sync(&n_hdlc->write_work);
+
 	n_hdlc_free_buf_list(&n_hdlc->rx_free_buf_list);
 	n_hdlc_free_buf_list(&n_hdlc->tx_free_buf_list);
 	n_hdlc_free_buf_list(&n_hdlc->rx_buf_list);
@@ -241,6 +246,8 @@ static int n_hdlc_tty_open(struct tty_st
 		return -ENFILE;
 	}
 
+	INIT_WORK(&n_hdlc->write_work, n_hdlc_tty_write_work);
+	n_hdlc->tty_for_write_work = tty;
 	tty->disc_data = n_hdlc;
 	tty->receive_room = 65536;
 
@@ -335,6 +342,20 @@ check_again:
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
@@ -344,7 +365,7 @@ static void n_hdlc_tty_wakeup(struct tty
 {
 	struct n_hdlc *n_hdlc = tty->disc_data;
 
-	n_hdlc_send_frames(n_hdlc, tty);
+	schedule_work(&n_hdlc->write_work);
 }	/* end of n_hdlc_tty_wakeup() */
 
 /**


