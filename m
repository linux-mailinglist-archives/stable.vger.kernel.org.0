Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8072E3F78
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502424AbgL1O20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:28:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:36296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502267AbgL1O20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:28:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 851A72245C;
        Mon, 28 Dec 2020 14:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165665;
        bh=hScZq2bfKuFde1eMFLZw7d6KeBqdZrjeqlvmUHCfFrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iGssH3r+7+RNKVuiAKF5VbrQYGU5ajyCwg48rlo05HNPXezhb2+cPL0R35Gt2hnOF
         KTndhCJCJDy9eV5yi1fdOFHBCQx7/n8rUKIeeOC8wAAJHpJN+lN1nX2Y185x7MJZ43
         MvL1DG1Srw0T9/eaJiXMLYxdyEQ01jRpp6kBgpv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 580/717] USB: serial: digi_acceleport: fix write-wakeup deadlocks
Date:   Mon, 28 Dec 2020 13:49:38 +0100
Message-Id: <20201228125048.701761332@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 5098e77962e7c8947f87bd8c5869c83e000a522a upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/serial/digi_acceleport.c |   45 ++++++++++-------------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -19,7 +19,6 @@
 #include <linux/tty_flip.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
-#include <linux/workqueue.h>
 #include <linux/uaccess.h>
 #include <linux/usb.h>
 #include <linux/wait.h>
@@ -198,14 +197,12 @@ struct digi_port {
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
@@ -356,26 +353,6 @@ __releases(lock)
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
 	unsigned long flags;
 	int ret = 0;
 	int status = urb->status;
+	bool wakeup;
 
 	/* port and serial sanity check */
 	if (port == NULL || (priv = usb_get_serial_port_data(port)) == NULL) {
@@ -1012,6 +990,7 @@ static void digi_write_bulk_callback(str
 	}
 
 	/* try to send any buffered data on this port */
+	wakeup = true;
 	spin_lock_irqsave(&priv->dp_port_lock, flags);
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
 	spin_unlock_irqrestore(&priv->dp_port_lock, flags);
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
@@ -1508,13 +1485,14 @@ static int digi_read_oob_callback(struct
 			rts = C_CRTSCTS(tty);
 
 		if (tty && opcode == DIGI_CMD_READ_INPUT_SIGNALS) {
+			bool wakeup = false;
+
 			spin_lock_irqsave(&priv->dp_port_lock, flags);
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
@@ -1533,6 +1511,9 @@ static int digi_read_oob_callback(struct
 				priv->dp_modem_signals &= ~TIOCM_CD;
 
 			spin_unlock_irqrestore(&priv->dp_port_lock, flags);
+
+			if (wakeup)
+				tty_port_tty_wakeup(&port->port);
 		} else if (opcode == DIGI_CMD_TRANSMIT_IDLE) {
 			spin_lock_irqsave(&priv->dp_port_lock, flags);
 			priv->dp_transmit_idle = 1;


