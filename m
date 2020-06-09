Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E098D1F42FF
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732438AbgFIRtD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:49:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732430AbgFIRtC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:49:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3C6D2081A;
        Tue,  9 Jun 2020 17:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591724941;
        bh=SBq97HSBScKwgsw2VpKUNlJJSPLI3KEzhD1ab8lOY+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r669+xueqexj5vbT8K6ArAxj9xR2BHhqgVgyunH896q0ossUN3/Jd2ml4oYh2qGQB
         DgmMqrCqlpdtLLJ3JZY3SDznJOr1t9TlDVG3silzkMpGMuoJ+Ube58FGqOgmOfq2N7
         ciywOQZUfQXSRS5n4xQ4uRAqioEoVwaGh7K3XEbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Raghavendra <rananta@codeaurora.org>
Subject: [PATCH 4.9 33/42] tty: hvc_console, fix crashes on parallel open/close
Date:   Tue,  9 Jun 2020 19:44:39 +0200
Message-Id: <20200609174019.120239972@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174015.379493548@linuxfoundation.org>
References: <20200609174015.379493548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit 24eb2377f977fe06d84fca558f891f95bc28a449 upstream.

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
 drivers/tty/hvc/hvc_console.c |   23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -358,15 +358,14 @@ static int hvc_open(struct tty_struct *t
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
@@ -376,22 +375,12 @@ static int hvc_open(struct tty_struct *t
 
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
@@ -399,6 +388,9 @@ static void hvc_close(struct tty_struct
 		/* We are done with the tty pointer now. */
 		tty_port_tty_set(&hp->port, NULL);
 
+		if (!tty_port_initialized(&hp->port))
+			return;
+
 		if (C_HUPCL(tty))
 			if (hp->ops->dtr_rts)
 				hp->ops->dtr_rts(hp, 0);
@@ -415,6 +407,7 @@ static void hvc_close(struct tty_struct
 		 * waking periodically to check chars_in_buffer().
 		 */
 		tty_wait_until_sent(tty, HVC_CLOSE_WAIT);
+		tty_port_set_initialized(&hp->port, false);
 	} else {
 		if (hp->port.count < 0)
 			printk(KERN_ERR "hvc_close %X: oops, count is %d\n",


