Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A231566F5
	for <lists+stable@lfdr.de>; Sat,  8 Feb 2020 19:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbgBHS3g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Feb 2020 13:29:36 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33630 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727650AbgBHS3f (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Feb 2020 13:29:35 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrF-0003cK-Lx; Sat, 08 Feb 2020 18:29:33 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1j0UrE-000CKi-L8; Sat, 08 Feb 2020 18:29:32 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Marcel Holtmann" <marcel@holtmann.org>,
        "Mattijs Korpershoek" <mkorpershoek@baylibre.com>
Date:   Sat, 08 Feb 2020 18:19:28 +0000
Message-ID: <lsq.1581185940.463080775@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 029/148] Bluetooth: hci_core: fix init for
 HCI_USER_CHANNEL
In-Reply-To: <lsq.1581185939.857586636@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.82-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Mattijs Korpershoek <mkorpershoek@baylibre.com>

commit eb8c101e28496888a0dcfe16ab86a1bee369e820 upstream.

During the setup() stage, HCI device drivers expect the chip to
acknowledge its setup() completion via vendor specific frames.

If userspace opens() such HCI device in HCI_USER_CHANNEL [1] mode,
the vendor specific frames are never tranmitted to the driver, as
they are filtered in hci_rx_work().

Allow HCI devices which operate in HCI_USER_CHANNEL mode to receive
frames if the HCI device is is HCI_INIT state.

[1] https://www.spinics.net/lists/linux-bluetooth/msg37345.html

Fixes: 23500189d7e0 ("Bluetooth: Introduce new HCI socket channel for user operation")
Signed-off-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
[bwh: Backported to 3.16: Keep checking both HCI_RAW and HCI_USER_CHANNEL
 bits here]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -5226,8 +5226,15 @@ static void hci_rx_work(struct work_stru
 			hci_send_to_sock(hdev, skb);
 		}
 
-		if (test_bit(HCI_RAW, &hdev->flags) ||
-		    test_bit(HCI_USER_CHANNEL, &hdev->dev_flags)) {
+		/* If the device has been opened in HCI_USER_CHANNEL,
+		 * the userspace has exclusive access to device.
+		 * When device is HCI_INIT, we still need to process
+		 * the data packets to the driver in order
+		 * to complete its setup().
+		 */
+		if ((test_bit(HCI_RAW, &hdev->flags) ||
+		     test_bit(HCI_USER_CHANNEL, &hdev->dev_flags)) &&
+		    !test_bit(HCI_INIT, &hdev->flags)) {
 			kfree_skb(skb);
 			continue;
 		}

