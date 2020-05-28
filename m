Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250D71E5857
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 09:19:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725819AbgE1HTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 03:19:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725601AbgE1HTV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 03:19:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53FD8208E4;
        Thu, 28 May 2020 07:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590650360;
        bh=1N2kBfBWAKJQ83e0fYdVKLdqy4rLXGKPhE+93zPLJnY=;
        h=Subject:To:From:Date:From;
        b=QjJ6o96QYUtWhY/Q6hoWqpb6gyMKl798xp2SZEWvIvEtweRVVdkb0bbaaTehh8t6k
         t9+kU+nep30EreLpiSPWegnJYhx0Wa3SKPtDm9egRNg3EEfX1a1QsBYHMipmQGf7IV
         j0rjTWw+zHGO8S0M67/tK/xlQ1c3kBljq50pjrYo=
Subject: patch "tty: hvc_console, fix crashes on parallel open/close" added to tty-next
To:     jslaby@suse.cz, gregkh@linuxfoundation.org, rananta@codeaurora.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 28 May 2020 09:19:08 +0200
Message-ID: <1590650348234158@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: hvc_console, fix crashes on parallel open/close

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From 24eb2377f977fe06d84fca558f891f95bc28a449 Mon Sep 17 00:00:00 2001
From: Jiri Slaby <jslaby@suse.cz>
Date: Tue, 26 May 2020 16:56:32 +0200
Subject: tty: hvc_console, fix crashes on parallel open/close

hvc_open sets tty->driver_data to NULL when open fails at some point.
Typically, the failure happens in hp->ops->notifier_add(). If there is
a racing process which tries to open such mangled tty, which was not
closed yet, the process will crash in hvc_open as tty->driver_data is
NULL.

All this happens because close wants to know whether open failed or not.
But ->open should not NULL this and other tty fields for ->close to be
happy. ->open should call tty_port_set_initialized(true) and close
should check by tty_port_initialized() instead. So do this properly in
this driver.

So this patch removes these from ->open:
* tty_port_tty_set(&hp->port, NULL). This happens on last close.
* tty->driver_data = NULL. Dtto.
* tty_port_put(&hp->port). This happens in shutdown and until now, this
  must have been causing a reference underflow, if I am not missing
  something.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: stable <stable@vger.kernel.org>
Reported-and-tested-by: Raghavendra <rananta@codeaurora.org>
Link: https://lore.kernel.org/r/20200526145632.13879-1-jslaby@suse.cz
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/hvc/hvc_console.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 436cc51c92c3..cdcc64ea2554 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -371,15 +371,14 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 	 * tty fields and return the kref reference.
 	 */
 	if (rc) {
-		tty_port_tty_set(&hp->port, NULL);
-		tty->driver_data = NULL;
-		tty_port_put(&hp->port);
 		printk(KERN_ERR "hvc_open: request_irq failed with rc %d.\n", rc);
-	} else
+	} else {
 		/* We are ready... raise DTR/RTS */
 		if (C_BAUD(tty))
 			if (hp->ops->dtr_rts)
 				hp->ops->dtr_rts(hp, 1);
+		tty_port_set_initialized(&hp->port, true);
+	}
 
 	/* Force wakeup of the polling thread */
 	hvc_kick();
@@ -389,22 +388,12 @@ static int hvc_open(struct tty_struct *tty, struct file * filp)
 
 static void hvc_close(struct tty_struct *tty, struct file * filp)
 {
-	struct hvc_struct *hp;
+	struct hvc_struct *hp = tty->driver_data;
 	unsigned long flags;
 
 	if (tty_hung_up_p(filp))
 		return;
 
-	/*
-	 * No driver_data means that this close was issued after a failed
-	 * hvc_open by the tty layer's release_dev() function and we can just
-	 * exit cleanly because the kref reference wasn't made.
-	 */
-	if (!tty->driver_data)
-		return;
-
-	hp = tty->driver_data;
-
 	spin_lock_irqsave(&hp->port.lock, flags);
 
 	if (--hp->port.count == 0) {
@@ -412,6 +401,9 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 		/* We are done with the tty pointer now. */
 		tty_port_tty_set(&hp->port, NULL);
 
+		if (!tty_port_initialized(&hp->port))
+			return;
+
 		if (C_HUPCL(tty))
 			if (hp->ops->dtr_rts)
 				hp->ops->dtr_rts(hp, 0);
@@ -428,6 +420,7 @@ static void hvc_close(struct tty_struct *tty, struct file * filp)
 		 * waking periodically to check chars_in_buffer().
 		 */
 		tty_wait_until_sent(tty, HVC_CLOSE_WAIT);
+		tty_port_set_initialized(&hp->port, false);
 	} else {
 		if (hp->port.count < 0)
 			printk(KERN_ERR "hvc_close %X: oops, count is %d\n",
-- 
2.26.2


