Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6B8888DC2
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfHJUsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:48:45 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54750 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726768AbfHJUoA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:44:00 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDV-00053O-Co; Sat, 10 Aug 2019 21:43:57 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDO-0003jW-CT; Sat, 10 Aug 2019 21:43:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        syzbot+79337b501d6aa974d0f6@syzkaller.appspotmail.com,
        "Vladis Dronov" <vdronov@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Marcel Holtmann" <marcel@holtmann.org>,
        "Yu-Chen, Cho" <acho@suse.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.541662992@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 135/157] Bluetooth: hci_uart: check for missing tty
 operations
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Vladis Dronov <vdronov@redhat.com>

commit b36a1552d7319bbfd5cf7f08726c23c5c66d4f73 upstream.

Certain ttys operations (pty_unix98_ops) lack tiocmget() and tiocmset()
functions which are called by the certain HCI UART protocols (hci_ath,
hci_bcm, hci_intel, hci_mrvl, hci_qca) via hci_uart_set_flow_control()
or directly. This leads to an execution at NULL and can be triggered by
an unprivileged user. Fix this by adding a helper function and a check
for the missing tty operations in the protocols code.

This fixes CVE-2019-10207. The Fixes: lines list commits where calls to
tiocm[gs]et() or hci_uart_set_flow_control() were added to the HCI UART
protocols.

Link: https://syzkaller.appspot.com/bug?id=1b42faa2848963564a5b1b7f8c837ea7b55ffa50
Reported-by: syzbot+79337b501d6aa974d0f6@syzkaller.appspotmail.com
Fixes: b3190df62861 ("Bluetooth: Support for Atheros AR300x serial chip")
Fixes: 118612fb9165 ("Bluetooth: hci_bcm: Add suspend/resume PM functions")
Fixes: ff2895592f0f ("Bluetooth: hci_intel: Add Intel baudrate configuration support")
Fixes: 162f812f23ba ("Bluetooth: hci_uart: Add Marvell support")
Fixes: fa9ad876b8e0 ("Bluetooth: hci_qca: Add support for Qualcomm Bluetooth chip wcn3990")
Signed-off-by: Vladis Dronov <vdronov@redhat.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Reviewed-by: Yu-Chen, Cho <acho@suse.com>
Tested-by: Yu-Chen, Cho <acho@suse.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[bwh: Backported to 3.16:
 - Only hci_ath is affected
 - There is no serdev support]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/bluetooth/hci_ath.c
+++ b/drivers/bluetooth/hci_ath.c
@@ -112,6 +112,9 @@ static int ath_open(struct hci_uart *hu)
 
 	BT_DBG("hu %p", hu);
 
+	if (!hci_uart_has_flow_control(hu))
+		return -EOPNOTSUPP;
+
 	ath = kzalloc(sizeof(*ath), GFP_KERNEL);
 	if (!ath)
 		return -ENOMEM;
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -261,6 +261,15 @@ static int hci_uart_send_frame(struct hc
 	return 0;
 }
 
+/* Check the underlying device or tty has flow control support */
+bool hci_uart_has_flow_control(struct hci_uart *hu)
+{
+	if (hu->tty->driver->ops->tiocmget && hu->tty->driver->ops->tiocmset)
+		return true;
+
+	return false;
+}
+
 /* ------ LDISC part ------ */
 /* hci_uart_tty_open
  *
--- a/drivers/bluetooth/hci_uart.h
+++ b/drivers/bluetooth/hci_uart.h
@@ -90,6 +90,7 @@ int hci_uart_register_proto(struct hci_u
 int hci_uart_unregister_proto(struct hci_uart_proto *p);
 int hci_uart_tx_wakeup(struct hci_uart *hu);
 int hci_uart_init_ready(struct hci_uart *hu);
+bool hci_uart_has_flow_control(struct hci_uart *hu);
 
 #ifdef CONFIG_BT_HCIUART_H4
 int h4_init(void);

