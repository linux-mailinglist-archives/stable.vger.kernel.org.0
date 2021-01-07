Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCF12ED200
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 15:22:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbhAGOQt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 09:16:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:38994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728816AbhAGOQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 7 Jan 2021 09:16:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD72923343;
        Thu,  7 Jan 2021 14:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610028946;
        bh=lfil6zS8OB/gOcAYPslknKv20SsUYoOKgOQgH00KE9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UkPu8O/Jsm72RNIPzZMlYuCgPcwdYYg8gVDqyNt5ktOCaHVcOYxeNNoBQ9vkdyHQR
         EXBi++luK+rlDMCAqXCPLfuHJVa2oDtI1RzOZWyboERTJXB4SYgYQtUjFpHkzSpVC/
         c1JFIy+2EKbMOvz46xvUbzoonNq9hz4saPm6BBkc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 08/19] USB: serial: digi_acceleport: fix write-wakeup deadlocks
Date:   Thu,  7 Jan 2021 15:16:33 +0100
Message-Id: <20210107140827.968177664@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210107140827.584658199@linuxfoundation.org>
References: <20210107140827.584658199@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 5098e77962e7c8947f87bd8c5869c83e000a522a ]

The driver must not call tty_wakeup() while holding its private lock as
line disciplines are allowed to call back into write() from
write_wakeup(), leading to a deadlock.

Also remove the unneeded work struct that was used to defer wakeup in
order to work around a possible race in ancient times (see comment about
n_tty write_chan() in commit 14b54e39b412 ("USB: serial: remove
changelogs and old todo entries")).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/digi_acceleport.c |   45 ++++++++++-------------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -23,7 +23,6 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <linux/workqueue.h>
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/wait.h>
@@ -201,14 +200,12 @@ struct digi_port {
 	int dp_throttle_restart;
 	wait_queue_head_t dp_flush_wait;
 	wait_queue_head_t dp_close_wait;	/* wait queue for close */
-	struct work_struct dp_wakeup_work;
 	struct usb_serial_port *dp_port;
 };
 
 
 /* Local Function Declarations */
 
-static void digi_wakeup_write_lock(struct work_struct *work);
 static int digi_write_oob_command(struct usb_serial_port *port,
 	unsigned char *buf, int count, int interruptible);
 static int digi_write_inb_command(struct usb_serial_port *port,
@@ -355,26 +352,6 @@ __releases(lock)
 	return timeout;
 }
 
-
-/*
- *  Digi Wakeup Write
- *
- *  Wake up port, line discipline, and tty processes sleeping
- *  on writes.
- */
-
-static void digi_wakeup_write_lock(struct work_struct *work)
-{
-	struct digi_port *priv =
-			container_of(work, struct digi_port, dp_wakeup_work);
-	struct usb_serial_port *port = priv->dp_port;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->dp_port_lock, flags);
-	tty_port_tty_wakeup(&port->port);
-	spin_unlock_irqrestore(&priv->dp_port_lock, flags);
-}
-
 /*
  *  Digi Write OOB Command
  *
@@ -986,6 +963,7 @@ static void digi_write_bulk_callback(str
 	struct digi_serial *serial_priv;
 	int ret = 0;
 	int status = urb->status;
+	bool wakeup;
 
 	/* port and serial sanity check */
 	if (port == NULL || (priv = usb_get_serial_port_data(port)) == NULL) {
@@ -1012,6 +990,7 @@ static void digi_write_bulk_callback(str
 	}
 
 	/* try to send any buffered data on this port */
+	wakeup = true;
 	spin_lock(&priv->dp_port_lock);
 	priv->dp_write_urb_in_use = 0;
 	if (priv->dp_out_buf_len > 0) {
@@ -1027,19 +1006,18 @@ static void digi_write_bulk_callback(str
 		if (ret == 0) {
 			priv->dp_write_urb_in_use = 1;
 			priv->dp_out_buf_len = 0;
+			wakeup = false;
 		}
 	}
-	/* wake up processes sleeping on writes immediately */
-	tty_port_tty_wakeup(&port->port);
-	/* also queue up a wakeup at scheduler time, in case we */
-	/* lost the race in write_chan(). */
-	schedule_work(&priv->dp_wakeup_work);
-
 	spin_unlock(&priv->dp_port_lock);
+
 	if (ret && ret != -EPERM)
 		dev_err_console(port,
 			"%s: usb_submit_urb failed, ret=%d, port=%d\n",
 			__func__, ret, priv->dp_port_num);
+
+	if (wakeup)
+		tty_port_tty_wakeup(&port->port);
 }
 
 static int digi_write_room(struct tty_struct *tty)
@@ -1239,7 +1217,6 @@ static int digi_port_init(struct usb_ser
 	init_waitqueue_head(&priv->dp_transmit_idle_wait);
 	init_waitqueue_head(&priv->dp_flush_wait);
 	init_waitqueue_head(&priv->dp_close_wait);
-	INIT_WORK(&priv->dp_wakeup_work, digi_wakeup_write_lock);
 	priv->dp_port = port;
 
 	init_waitqueue_head(&port->write_wait);
@@ -1525,13 +1502,14 @@ static int digi_read_oob_callback(struct
 			rts = tty->termios.c_cflag & CRTSCTS;
 		
 		if (tty && opcode == DIGI_CMD_READ_INPUT_SIGNALS) {
+			bool wakeup = false;
+
 			spin_lock(&priv->dp_port_lock);
 			/* convert from digi flags to termiox flags */
 			if (val & DIGI_READ_INPUT_SIGNALS_CTS) {
 				priv->dp_modem_signals |= TIOCM_CTS;
-				/* port must be open to use tty struct */
 				if (rts)
-					tty_port_tty_wakeup(&port->port);
+					wakeup = true;
 			} else {
 				priv->dp_modem_signals &= ~TIOCM_CTS;
 				/* port must be open to use tty struct */
@@ -1550,6 +1528,9 @@ static int digi_read_oob_callback(struct
 				priv->dp_modem_signals &= ~TIOCM_CD;
 
 			spin_unlock(&priv->dp_port_lock);
+
+			if (wakeup)
+				tty_port_tty_wakeup(&port->port);
 		} else if (opcode == DIGI_CMD_TRANSMIT_IDLE) {
 			spin_lock(&priv->dp_port_lock);
 			priv->dp_transmit_idle = 1;


