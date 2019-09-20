Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E80AB92A5
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391697AbfITOe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:34:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36300 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388215AbfITOZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:07 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqK-00051C-Rg; Fri, 20 Sep 2019 15:25:04 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqH-0007zR-NL; Fri, 20 Sep 2019 15:25:01 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Loic Poulain" <loic.poulain@intel.com>,
        "Marcel Holtmann" <marcel@holtmann.org>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.915776834@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 127/132] Bluetooth: hci_ldisc: Fix null pointer
 derefence in case of early data
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@intel.com>

commit 84cb3df02aea4b00405521e67c4c67c2d525c364 upstream.

HCI_UART_PROTO_SET flag is set before hci_uart_set_proto call. If we
receive data from tty layer during this procedure, proto pointer may
not be assigned yet, leading to null pointer dereference in rx method
hci_uart_tty_receive.

This patch fixes this issue by introducing HCI_UART_PROTO_READY flag in
order to avoid any proto operation before proto opening and assignment.

Signed-off-by: Loic Poulain <loic.poulain@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/bluetooth/hci_ldisc.c | 11 +++++++----
 drivers/bluetooth/hci_uart.h  |  1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -225,7 +225,7 @@ static int hci_uart_flush(struct hci_dev
 	tty_ldisc_flush(tty);
 	tty_driver_flush_buffer(tty);
 
-	if (test_bit(HCI_UART_PROTO_SET, &hu->flags))
+	if (test_bit(HCI_UART_PROTO_READY, &hu->flags))
 		hu->proto->flush(hu);
 
 	return 0;
@@ -342,7 +342,7 @@ static void hci_uart_tty_close(struct tt
 
 	cancel_work_sync(&hu->write_work);
 
-	if (test_and_clear_bit(HCI_UART_PROTO_SET, &hu->flags)) {
+	if (test_and_clear_bit(HCI_UART_PROTO_READY, &hu->flags)) {
 		if (hdev) {
 			if (test_bit(HCI_UART_REGISTERED, &hu->flags))
 				hci_unregister_dev(hdev);
@@ -350,6 +350,7 @@ static void hci_uart_tty_close(struct tt
 		}
 		hu->proto->close(hu);
 	}
+	clear_bit(HCI_UART_PROTO_SET, &hu->flags);
 
 	kfree(hu);
 }
@@ -376,7 +377,7 @@ static void hci_uart_tty_wakeup(struct t
 	if (tty != hu->tty)
 		return;
 
-	if (test_bit(HCI_UART_PROTO_SET, &hu->flags))
+	if (test_bit(HCI_UART_PROTO_READY, &hu->flags))
 		hci_uart_tx_wakeup(hu);
 }
 
@@ -399,7 +400,7 @@ static void hci_uart_tty_receive(struct
 	if (!hu || tty != hu->tty)
 		return;
 
-	if (!test_bit(HCI_UART_PROTO_SET, &hu->flags))
+	if (!test_bit(HCI_UART_PROTO_READY, &hu->flags))
 		return;
 
 	spin_lock(&hu->rx_lock);
@@ -476,9 +477,11 @@ static int hci_uart_set_proto(struct hci
 		return err;
 
 	hu->proto = p;
+	set_bit(HCI_UART_PROTO_READY, &hu->flags);
 
 	err = hci_uart_register_dev(hu);
 	if (err) {
+		clear_bit(HCI_UART_PROTO_READY, &hu->flags);
 		p->close(hu);
 		return err;
 	}
--- a/drivers/bluetooth/hci_uart.h
+++ b/drivers/bluetooth/hci_uart.h
@@ -81,6 +81,7 @@ struct hci_uart {
 /* HCI_UART proto flag bits */
 #define HCI_UART_PROTO_SET	0
 #define HCI_UART_REGISTERED	1
+#define HCI_UART_PROTO_READY	2
 
 /* TX states  */
 #define HCI_UART_SENDING	1

