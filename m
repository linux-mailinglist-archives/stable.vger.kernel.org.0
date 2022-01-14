Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5796448E623
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240436AbiANIX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:23:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240146AbiANIWT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:22:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E83BEC0617BD;
        Fri, 14 Jan 2022 00:21:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8E56B8243B;
        Fri, 14 Jan 2022 08:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF65BC36B01;
        Fri, 14 Jan 2022 08:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642148509;
        bh=9/N4BaNjin+okbQTdC62u02A2fP7O1ok2ZrHO+liqTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BaBXIMpjNzANNDk1ugnajeZU/akGiYqhPF7EmpiptoX5wDmSrVPTQTNmDpUl1R/jk
         gX564oylgBNpycIuuBReSOMz1Xbdscumg6U6E8zCgu6oOJDC3BG7J4oF2Mh3ZElO3Q
         0crbnoJb88TKrMxzNKKNQp5vvgFzDOdl3CGs1mLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tedd Ho-Jeong An <tedd.an@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.16 13/37] Bluetooth: btintel: Fix broken LED quirk for legacy ROM devices
Date:   Fri, 14 Jan 2022 09:16:27 +0100
Message-Id: <20220114081545.296079204@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220114081544.849748488@linuxfoundation.org>
References: <20220114081544.849748488@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tedd Ho-Jeong An <tedd.an@intel.com>

commit 95655456e7cee858a23793f67025765b4c4c227b upstream.

This patch fixes the broken LED quirk for Intel legacy ROM devices.
To fix the LED issue that doesn't turn off immediately, the host sends
the SW RFKILL command while shutting down the interface and it puts the
devices in SW RFKILL state.

Once the device is in SW RFKILL state, it can only accept HCI_Reset to
exit from the SW RFKILL state. This patch checks the quirk for broken
LED and sends the HCI_Reset before sending the HCI_Intel_Read_Version
command.

The affected legacy ROM devices are
 - 8087:07dc
 - 8087:0a2a
 - 8087:0aa7

Fixes: ffcba827c0a1d ("Bluetooth: btintel: Fix the LED is not turning off immediately")
Signed-off-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel.c |   20 +++++++++++---------
 drivers/bluetooth/btintel.h |    2 +-
 drivers/bluetooth/btusb.c   |   13 ++++++++++---
 3 files changed, 22 insertions(+), 13 deletions(-)

--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2353,8 +2353,15 @@ static int btintel_setup_combined(struct
 	 * As a workaround, send HCI Reset command first which will reset the
 	 * number of completed commands and allow normal command processing
 	 * from now on.
+	 *
+	 * Regarding the INTEL_BROKEN_SHUTDOWN_LED flag, these devices maybe
+	 * in the SW_RFKILL ON state as a workaround of fixing LED issue during
+	 * the shutdown() procedure, and once the device is in SW_RFKILL ON
+	 * state, the only way to exit out of it is sending the HCI_Reset
+	 * command.
 	 */
-	if (btintel_test_flag(hdev, INTEL_BROKEN_INITIAL_NCMD)) {
+	if (btintel_test_flag(hdev, INTEL_BROKEN_INITIAL_NCMD) ||
+	    btintel_test_flag(hdev, INTEL_BROKEN_SHUTDOWN_LED)) {
 		skb = __hci_cmd_sync(hdev, HCI_OP_RESET, 0, NULL,
 				     HCI_INIT_TIMEOUT);
 		if (IS_ERR(skb)) {
@@ -2426,12 +2433,6 @@ static int btintel_setup_combined(struct
 				set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED,
 					&hdev->quirks);
 
-			/* These devices have an issue with LED which doesn't
-			 * go off immediately during shutdown. Set the flag
-			 * here to send the LED OFF command during shutdown.
-			 */
-			btintel_set_flag(hdev, INTEL_BROKEN_LED);
-
 			err = btintel_legacy_rom_setup(hdev, &ver);
 			break;
 		case 0x0b:      /* SfP */
@@ -2562,9 +2563,10 @@ static int btintel_shutdown_combined(str
 
 	/* Some platforms have an issue with BT LED when the interface is
 	 * down or BT radio is turned off, which takes 5 seconds to BT LED
-	 * goes off. This command turns off the BT LED immediately.
+	 * goes off. As a workaround, sends HCI_Intel_SW_RFKILL to put the
+	 * device in the RFKILL ON state which turns off the BT LED immediately.
 	 */
-	if (btintel_test_flag(hdev, INTEL_BROKEN_LED)) {
+	if (btintel_test_flag(hdev, INTEL_BROKEN_SHUTDOWN_LED)) {
 		skb = __hci_cmd_sync(hdev, 0xfc3f, 0, NULL, HCI_INIT_TIMEOUT);
 		if (IS_ERR(skb)) {
 			ret = PTR_ERR(skb);
--- a/drivers/bluetooth/btintel.h
+++ b/drivers/bluetooth/btintel.h
@@ -150,7 +150,7 @@ enum {
 	INTEL_FIRMWARE_FAILED,
 	INTEL_BOOTING,
 	INTEL_BROKEN_INITIAL_NCMD,
-	INTEL_BROKEN_LED,
+	INTEL_BROKEN_SHUTDOWN_LED,
 	INTEL_ROM_LEGACY,
 
 	__INTEL_NUM_FLAGS,
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -59,6 +59,7 @@ static struct usb_driver btusb_driver;
 #define BTUSB_WIDEBAND_SPEECH	0x400000
 #define BTUSB_VALID_LE_STATES   0x800000
 #define BTUSB_QCA_WCN6855	0x1000000
+#define BTUSB_INTEL_BROKEN_SHUTDOWN_LED	0x2000000
 #define BTUSB_INTEL_BROKEN_INITIAL_NCMD 0x4000000
 
 static const struct usb_device_id btusb_table[] = {
@@ -380,10 +381,13 @@ static const struct usb_device_id blackl
 	{ USB_DEVICE(0x8087, 0x0033), .driver_info = BTUSB_INTEL_COMBINED },
 	{ USB_DEVICE(0x8087, 0x07da), .driver_info = BTUSB_CSR },
 	{ USB_DEVICE(0x8087, 0x07dc), .driver_info = BTUSB_INTEL_COMBINED |
-						     BTUSB_INTEL_BROKEN_INITIAL_NCMD },
-	{ USB_DEVICE(0x8087, 0x0a2a), .driver_info = BTUSB_INTEL_COMBINED },
+						     BTUSB_INTEL_BROKEN_INITIAL_NCMD |
+						     BTUSB_INTEL_BROKEN_SHUTDOWN_LED },
+	{ USB_DEVICE(0x8087, 0x0a2a), .driver_info = BTUSB_INTEL_COMBINED |
+						     BTUSB_INTEL_BROKEN_SHUTDOWN_LED },
 	{ USB_DEVICE(0x8087, 0x0a2b), .driver_info = BTUSB_INTEL_COMBINED },
-	{ USB_DEVICE(0x8087, 0x0aa7), .driver_info = BTUSB_INTEL_COMBINED },
+	{ USB_DEVICE(0x8087, 0x0aa7), .driver_info = BTUSB_INTEL_COMBINED |
+						     BTUSB_INTEL_BROKEN_SHUTDOWN_LED },
 	{ USB_DEVICE(0x8087, 0x0aaa), .driver_info = BTUSB_INTEL_COMBINED },
 
 	/* Other Intel Bluetooth devices */
@@ -3888,6 +3892,9 @@ static int btusb_probe(struct usb_interf
 
 		if (id->driver_info & BTUSB_INTEL_BROKEN_INITIAL_NCMD)
 			btintel_set_flag(hdev, INTEL_BROKEN_INITIAL_NCMD);
+
+		if (id->driver_info & BTUSB_INTEL_BROKEN_SHUTDOWN_LED)
+			btintel_set_flag(hdev, INTEL_BROKEN_SHUTDOWN_LED);
 	}
 
 	if (id->driver_info & BTUSB_MARVELL)


