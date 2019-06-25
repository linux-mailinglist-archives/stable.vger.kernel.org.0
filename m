Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF070555FD
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 19:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731933AbfFYRcl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 13:32:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41254 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727652AbfFYRcl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 25 Jun 2019 13:32:41 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5ED6822387A;
        Tue, 25 Jun 2019 17:32:35 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.43.2.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 58C975D9D3;
        Tue, 25 Jun 2019 17:32:33 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+79337b501d6aa974d0f6@syzkaller.appspotmail.com,
        stable@vger.kernel.org, Loic Poulain <loic.poulain@intel.com>,
        Ilya Faenson <ifaenson@broadcom.com>
Subject: [PATCH] Bluetooth: hci_ldisc: check for missing tty operations
Date:   Tue, 25 Jun 2019 19:32:15 +0200
Message-Id: <20190625173215.25999-1-vdronov@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Tue, 25 Jun 2019 17:32:40 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Certain ttys lack operations (eg: pty_unix98_ops) which still can be
called by certain hci uart proto (eg: mrvl, ath). Currently this leads
to execution at address 0x0. Fix this by adding checks for missing tty
operations.

Link: https://syzkaller.appspot.com/bug?id=1b42faa2848963564a5b1b7f8c837ea7b55ffa50
Reported-by: syzbot+79337b501d6aa974d0f6@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org # v2.6.39+
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
---
 drivers/bluetooth/hci_ath.c   |  7 ++++-
 drivers/bluetooth/hci_ldisc.c | 58 ++++++++++++++++++++---------------
 2 files changed, 39 insertions(+), 26 deletions(-)

diff --git a/drivers/bluetooth/hci_ath.c b/drivers/bluetooth/hci_ath.c
index a55be205b91a..92d9bded5880 100644
--- a/drivers/bluetooth/hci_ath.c
+++ b/drivers/bluetooth/hci_ath.c
@@ -49,7 +49,12 @@ struct ath_vendor_cmd {
 
 static int ath_wakeup_ar3k(struct tty_struct *tty)
 {
-	int status = tty->driver->ops->tiocmget(tty);
+	int status;
+
+	if (!(tty->driver->ops->tiocmget && tty->driver->ops->tiocmset))
+		return TIOCM_CTS;
+
+	status = tty->driver->ops->tiocmget(tty);
 
 	if (status & TIOCM_CTS)
 		return status;
diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index c84f985f348d..29b4970f9bca 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -307,32 +307,40 @@ void hci_uart_set_flow_control(struct hci_uart *hu, bool enable)
 		BT_DBG("Disabling hardware flow control: %s",
 		       status ? "failed" : "success");
 
-		/* Clear RTS to prevent the device from sending */
-		/* Most UARTs need OUT2 to enable interrupts */
-		status = tty->driver->ops->tiocmget(tty);
-		BT_DBG("Current tiocm 0x%x", status);
-
-		set &= ~(TIOCM_OUT2 | TIOCM_RTS);
-		clear = ~set;
-		set &= TIOCM_DTR | TIOCM_RTS | TIOCM_OUT1 |
-		       TIOCM_OUT2 | TIOCM_LOOP;
-		clear &= TIOCM_DTR | TIOCM_RTS | TIOCM_OUT1 |
-			 TIOCM_OUT2 | TIOCM_LOOP;
-		status = tty->driver->ops->tiocmset(tty, set, clear);
-		BT_DBG("Clearing RTS: %s", status ? "failed" : "success");
+		if (tty->driver->ops->tiocmget && tty->driver->ops->tiocmset) {
+			/* Clear RTS to prevent the device from sending */
+			/* Most UARTs need OUT2 to enable interrupts */
+			status = tty->driver->ops->tiocmget(tty);
+			BT_DBG("Current tiocm 0x%x", status);
+
+			set &= ~(TIOCM_OUT2 | TIOCM_RTS);
+			clear = ~set;
+			set &= TIOCM_DTR | TIOCM_RTS | TIOCM_OUT1 |
+			       TIOCM_OUT2 | TIOCM_LOOP;
+			clear &= TIOCM_DTR | TIOCM_RTS | TIOCM_OUT1 |
+			         TIOCM_OUT2 | TIOCM_LOOP;
+			status = tty->driver->ops->tiocmset(tty, set, clear);
+			BT_DBG("Clearing RTS: %s",
+			       status ? "failed" : "success");
+		} else
+			BT_DBG("Terminal RTS control is not present");
 	} else {
-		/* Set RTS to allow the device to send again */
-		status = tty->driver->ops->tiocmget(tty);
-		BT_DBG("Current tiocm 0x%x", status);
-
-		set |= (TIOCM_OUT2 | TIOCM_RTS);
-		clear = ~set;
-		set &= TIOCM_DTR | TIOCM_RTS | TIOCM_OUT1 |
-		       TIOCM_OUT2 | TIOCM_LOOP;
-		clear &= TIOCM_DTR | TIOCM_RTS | TIOCM_OUT1 |
-			 TIOCM_OUT2 | TIOCM_LOOP;
-		status = tty->driver->ops->tiocmset(tty, set, clear);
-		BT_DBG("Setting RTS: %s", status ? "failed" : "success");
+		if (tty->driver->ops->tiocmget && tty->driver->ops->tiocmset) {
+			/* Set RTS to allow the device to send again */
+			status = tty->driver->ops->tiocmget(tty);
+			BT_DBG("Current tiocm 0x%x", status);
+
+			set |= (TIOCM_OUT2 | TIOCM_RTS);
+			clear = ~set;
+			set &= TIOCM_DTR | TIOCM_RTS | TIOCM_OUT1 |
+			       TIOCM_OUT2 | TIOCM_LOOP;
+			clear &= TIOCM_DTR | TIOCM_RTS | TIOCM_OUT1 |
+			         TIOCM_OUT2 | TIOCM_LOOP;
+			status = tty->driver->ops->tiocmset(tty, set, clear);
+			BT_DBG("Setting RTS: %s",
+			       status ? "failed" : "success");
+		} else
+			BT_DBG("Terminal RTS control is not present");
 
 		/* Re-enable hardware flow control */
 		ktermios = tty->termios;
-- 
2.20.1

