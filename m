Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0509A7F39C
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406837AbfHBJ5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:57:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:36196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405495AbfHBJ5I (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:57:08 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3A0D2064A;
        Fri,  2 Aug 2019 09:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739827;
        bh=56LODa/vH88SLw3LuJ7bMvX5SWWkDx8jvff44dlAp8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uiGmqRiXtOJQOTwwM47vGAbTWf0HiOkJvmKqPJiVeHasnIgWUbagMJ3qNNLOSzppJ
         mM0632X9LOp7B6jupASwsQFDY3+DEdAft+nlVbKclB/oByBzufM9NPAFWqj3GPllGX
         xT4AomVqy4a43Mc209/fFMz4v/mIBgaR3jf+nEk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+79337b501d6aa974d0f6@syzkaller.appspotmail.com,
        Vladis Dronov <vdronov@redhat.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        "Yu-Chen, Cho" <acho@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 19/32] Bluetooth: hci_uart: check for missing tty operations
Date:   Fri,  2 Aug 2019 11:39:53 +0200
Message-Id: <20190802092107.905678482@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092101.913646560@linuxfoundation.org>
References: <20190802092101.913646560@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org # v2.6.36+
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/hci_ath.c   |    3 +++
 drivers/bluetooth/hci_bcm.c   |    3 +++
 drivers/bluetooth/hci_intel.c |    3 +++
 drivers/bluetooth/hci_ldisc.c |   13 +++++++++++++
 drivers/bluetooth/hci_mrvl.c  |    3 +++
 drivers/bluetooth/hci_qca.c   |    3 +++
 drivers/bluetooth/hci_uart.h  |    1 +
 7 files changed, 29 insertions(+)

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
--- a/drivers/bluetooth/hci_bcm.c
+++ b/drivers/bluetooth/hci_bcm.c
@@ -369,6 +369,9 @@ static int bcm_open(struct hci_uart *hu)
 
 	bt_dev_dbg(hu->hdev, "hu %p", hu);
 
+	if (!hci_uart_has_flow_control(hu))
+		return -EOPNOTSUPP;
+
 	bcm = kzalloc(sizeof(*bcm), GFP_KERNEL);
 	if (!bcm)
 		return -ENOMEM;
--- a/drivers/bluetooth/hci_intel.c
+++ b/drivers/bluetooth/hci_intel.c
@@ -406,6 +406,9 @@ static int intel_open(struct hci_uart *h
 
 	BT_DBG("hu %p", hu);
 
+	if (!hci_uart_has_flow_control(hu))
+		return -EOPNOTSUPP;
+
 	intel = kzalloc(sizeof(*intel), GFP_KERNEL);
 	if (!intel)
 		return -ENOMEM;
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -299,6 +299,19 @@ static int hci_uart_send_frame(struct hc
 	return 0;
 }
 
+/* Check the underlying device or tty has flow control support */
+bool hci_uart_has_flow_control(struct hci_uart *hu)
+{
+	/* serdev nodes check if the needed operations are present */
+	if (hu->serdev)
+		return true;
+
+	if (hu->tty->driver->ops->tiocmget && hu->tty->driver->ops->tiocmset)
+		return true;
+
+	return false;
+}
+
 /* Flow control or un-flow control the device */
 void hci_uart_set_flow_control(struct hci_uart *hu, bool enable)
 {
--- a/drivers/bluetooth/hci_mrvl.c
+++ b/drivers/bluetooth/hci_mrvl.c
@@ -66,6 +66,9 @@ static int mrvl_open(struct hci_uart *hu
 
 	BT_DBG("hu %p", hu);
 
+	if (!hci_uart_has_flow_control(hu))
+		return -EOPNOTSUPP;
+
 	mrvl = kzalloc(sizeof(*mrvl), GFP_KERNEL);
 	if (!mrvl)
 		return -ENOMEM;
--- a/drivers/bluetooth/hci_qca.c
+++ b/drivers/bluetooth/hci_qca.c
@@ -450,6 +450,9 @@ static int qca_open(struct hci_uart *hu)
 
 	BT_DBG("hu %p qca_open", hu);
 
+	if (!hci_uart_has_flow_control(hu))
+		return -EOPNOTSUPP;
+
 	qca = kzalloc(sizeof(struct qca_data), GFP_KERNEL);
 	if (!qca)
 		return -ENOMEM;
--- a/drivers/bluetooth/hci_uart.h
+++ b/drivers/bluetooth/hci_uart.h
@@ -118,6 +118,7 @@ int hci_uart_tx_wakeup(struct hci_uart *
 int hci_uart_init_ready(struct hci_uart *hu);
 void hci_uart_init_work(struct work_struct *work);
 void hci_uart_set_baudrate(struct hci_uart *hu, unsigned int speed);
+bool hci_uart_has_flow_control(struct hci_uart *hu);
 void hci_uart_set_flow_control(struct hci_uart *hu, bool enable);
 void hci_uart_set_speeds(struct hci_uart *hu, unsigned int init_speed,
 			 unsigned int oper_speed);


