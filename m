Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C63DE298A9B
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 11:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770495AbgJZKoI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 06:44:08 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:36019 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1770474AbgJZKoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 06:44:08 -0400
Received: by mail-lf1-f68.google.com with SMTP id h6so11079867lfj.3;
        Mon, 26 Oct 2020 03:44:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Krd96NyjTrIz4kGk8+eicuNx9zWNUJ7PdywyCrNz6qU=;
        b=A+vNjyOWMn3A1BeLmILAxVXFZpfoTpyBDOZJh0tIMwvdrm9EWabChScqL+uCxaHyr0
         mGeROvybhFtFw73XDwi4GwfR+abnjYZqkLtn4dd9RDScH98cl44tfHpAZ7MzIg8Q7kc+
         N1CcEc0ywy4crYLZQ7s5/NiKtcGuGAa5r5db9Z1VaWBIC/dFg+DHYt8z+VMJjCPf79OO
         +ZAWeq0t8ROKW/3vdNOXr0yKAepdibClQoIiov4YOvR7Y/1ixskG50LDh2EHdqdXl5zK
         IlCGkPWDIIARklr3mCHR2YhrE/FYfCYLzG99BY+F29vwQOxSq68CNJl1a046wJqZXofO
         9aIA==
X-Gm-Message-State: AOAM533t2hgYFrmZCNLjihriLeRXNnL4q3WNp6JIXomwi1i+4/DJHrEX
        e2T7Zs9fQbpVmJCRsNuTTh/Huc25ZETeRQ==
X-Google-Smtp-Source: ABdhPJwsC2tWbOlt8miCx+4lCBmAwDaJmA+WGb1hzoaD7lJ6H+/XFyKEtxtIB1xBhf87Qvz/jtFMHA==
X-Received: by 2002:a19:40ca:: with SMTP id n193mr4306914lfa.96.1603709043819;
        Mon, 26 Oct 2020 03:44:03 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id i5sm12737lfe.29.2020.10.26.03.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 03:44:03 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@xi.terra>)
        id 1kWzyy-0007iU-Fb; Mon, 26 Oct 2020 11:44:09 +0100
From:   Johan Hovold <johan@kernel.org>
To:     linux-usb@vger.kernel.org
Cc:     Johan Hovold <johan@kernel.org>, stable@vger.kernel.org
Subject: [PATCH] USB: serial: digi_acceleport: fix write-wakeup deadlocks
Date:   Mon, 26 Oct 2020 11:43:06 +0100
Message-Id: <20201026104306.29576-1-johan@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The driver must not call tty_wakeup() while holding its private lock as
line disciplines are allowed to call back into write() from
write_wakeup(), leading to a deadlock.

Also remove the unneeded work struct that was used to defer wakeup in
order to work around a possible race in ancient times (see comment about
n_tty write_chan() in commit 14b54e39b412 ("USB: serial: remove
changelogs and old todo entries")).

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
---
 drivers/usb/serial/digi_acceleport.c | 45 ++++++++--------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index 91055a191995..0d606fa9fdca 100644
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
@@ -986,6 +963,7 @@ static void digi_write_bulk_callback(struct urb *urb)
 	unsigned long flags;
 	int ret = 0;
 	int status = urb->status;
+	bool wakeup;
 
 	/* port and serial sanity check */
 	if (port == NULL || (priv = usb_get_serial_port_data(port)) == NULL) {
@@ -1012,6 +990,7 @@ static void digi_write_bulk_callback(struct urb *urb)
 	}
 
 	/* try to send any buffered data on this port */
+	wakeup = true;
 	spin_lock_irqsave(&priv->dp_port_lock, flags);
 	priv->dp_write_urb_in_use = 0;
 	if (priv->dp_out_buf_len > 0) {
@@ -1027,19 +1006,18 @@ static void digi_write_bulk_callback(struct urb *urb)
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
@@ -1239,7 +1217,6 @@ static int digi_port_init(struct usb_serial_port *port, unsigned port_num)
 	init_waitqueue_head(&priv->dp_transmit_idle_wait);
 	init_waitqueue_head(&priv->dp_flush_wait);
 	init_waitqueue_head(&priv->dp_close_wait);
-	INIT_WORK(&priv->dp_wakeup_work, digi_wakeup_write_lock);
 	priv->dp_port = port;
 
 	init_waitqueue_head(&port->write_wait);
@@ -1508,13 +1485,14 @@ static int digi_read_oob_callback(struct urb *urb)
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
@@ -1533,6 +1511,9 @@ static int digi_read_oob_callback(struct urb *urb)
 				priv->dp_modem_signals &= ~TIOCM_CD;
 
 			spin_unlock_irqrestore(&priv->dp_port_lock, flags);
+
+			if (wakeup)
+				tty_port_tty_wakeup(&port->port);
 		} else if (opcode == DIGI_CMD_TRANSMIT_IDLE) {
 			spin_lock_irqsave(&priv->dp_port_lock, flags);
 			priv->dp_transmit_idle = 1;
-- 
2.26.2

