Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73E5D3215E4
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 13:15:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhBVMOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 07:14:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:44522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230367AbhBVMN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Feb 2021 07:13:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3173A64E44;
        Mon, 22 Feb 2021 12:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613995997;
        bh=JpPB1baWdElUFrLJuHGFPeK53hvzE2AvCocez83Q368=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dNHjzO83UCmY/3xq2z6bD7Y351029hzWAFcljNlG+YN4ImuWejg3RxF7O4KgWzUm+
         T1nC6qSRV23LYobHSM9SCmOSRvdXpTeDzYvx/DKf3piNaMMLb8sX57KcGD/AvGOOt/
         5i88952Pa/7XKbojhAu3nuox0D1fJA6o+O7mGtO0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Trent Piepho <tpiepho@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Sjoerd Simons <sjoerd@luon.net>,
        Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 5.11 11/12] Bluetooth: btusb: Always fallback to alt 1 for WBS
Date:   Mon, 22 Feb 2021 13:13:03 +0100
Message-Id: <20210222121018.922673929@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210222121013.586597942@linuxfoundation.org>
References: <20210222121013.586597942@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trent Piepho <tpiepho@gmail.com>

commit 517b693351a2d04f3af1fc0e506ac7e1346094de upstream.

When alt mode 6 is not available, fallback to the kernel <= 5.7 behavior
of always using alt mode 1.

Prior to kernel 5.8, btusb would always use alt mode 1 for WBS (Wide
Band Speech aka mSBC aka transparent SCO).  In commit baac6276c0a9
("Bluetooth: btusb: handle mSBC audio over USB Endpoints") this
was changed to use alt mode 6, which is the recommended mode in the
Bluetooth spec (Specifications of the Bluetooth System, v5.0, Vol 4.B
§2.2.1).  However, many if not most BT USB adapters do not support alt
mode 6.  In fact, I have been unable to find any which do.

In kernel 5.8, this was changed to use alt mode 6, and if not available,
use alt mode 0.  But mode 0 has a zero byte max packet length and can
not possibly work.  It is just there as a zero-bandwidth dummy mode to
work around a USB flaw that would prevent device enumeration if
insufficient bandwidth were available for the lowest isoc mode
supported.

In effect, WBS was broken for all USB-BT adapters that do not support
alt 6, which appears to nearly all of them.

Then in commit 461f95f04f19 ("Bluetooth: btusb: USB alternate setting 1 for
WBS") the 5.7 behavior was restored, but only for Realtek adapters.

I've tested a Broadcom BRCM20702A and CSR 8510 adapter, both work with
the 5.7 behavior and do not with the 5.8.

So get rid of the Realtek specific flag and use the 5.7 behavior for all
adapters as a fallback when alt 6 is not available.  This was the
kernel's behavior prior to 5.8 and I can find no adapters for which it
is not correct.  And even if there is an adapter for which this does not
work, the current behavior would be to fall back to alt 0, which can not
possibly work either, and so is no better.

Signed-off-by: Trent Piepho <tpiepho@gmail.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Cc: Sjoerd Simons <sjoerd@luon.net>
Cc: Sebastian Reichel <sre@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/bluetooth/btusb.c |   20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -506,7 +506,6 @@ static const struct dmi_system_id btusb_
 #define BTUSB_HW_RESET_ACTIVE	12
 #define BTUSB_TX_WAIT_VND_EVT	13
 #define BTUSB_WAKEUP_DISABLE	14
-#define BTUSB_USE_ALT1_FOR_WBS	15
 
 struct btusb_data {
 	struct hci_dev       *hdev;
@@ -1736,15 +1735,12 @@ static void btusb_work(struct work_struc
 				new_alts = data->sco_num;
 			}
 		} else if (data->air_mode == HCI_NOTIFY_ENABLE_SCO_TRANSP) {
-			/* Check if Alt 6 is supported for Transparent audio */
-			if (btusb_find_altsetting(data, 6)) {
-				data->usb_alt6_packet_flow = true;
-				new_alts = 6;
-			} else if (test_bit(BTUSB_USE_ALT1_FOR_WBS, &data->flags)) {
-				new_alts = 1;
-			} else {
-				bt_dev_err(hdev, "Device does not support ALT setting 6");
-			}
+			/* Bluetooth USB spec recommends alt 6 (63 bytes), but
+			 * many adapters do not support it.  Alt 1 appears to
+			 * work for all adapters that do not have alt 6, and
+			 * which work with WBS at all.
+			 */
+			new_alts = btusb_find_altsetting(data, 6) ? 6 : 1;
 		}
 
 		if (btusb_switch_alt_setting(hdev, new_alts) < 0)
@@ -4548,10 +4544,6 @@ static int btusb_probe(struct usb_interf
 		 * (DEVICE_REMOTE_WAKEUP)
 		 */
 		set_bit(BTUSB_WAKEUP_DISABLE, &data->flags);
-		if (btusb_find_altsetting(data, 1))
-			set_bit(BTUSB_USE_ALT1_FOR_WBS, &data->flags);
-		else
-			bt_dev_err(hdev, "Device does not support ALT setting 1");
 	}
 
 	if (!reset)


