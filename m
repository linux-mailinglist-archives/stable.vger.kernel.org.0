Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60147472592
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:44:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235203AbhLMJoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:44:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56236 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbhLMJmT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:42:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37527B80E15;
        Mon, 13 Dec 2021 09:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 848E1C00446;
        Mon, 13 Dec 2021 09:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388537;
        bh=WzI8d3jgoWNvbGn9QBVOeez0UL9AobdND61llHL5yUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fbRku/aFMR/ceSPrRpsqWjj6L41RsPy1qDJOzEn0JtD9NOQIwAWp7KeXUgtE2ZUMw
         KXp5pBvrJ0YRzQ/dxYeFKEbgyiBHvAFQBUfgFUWONDghPE3BU1BHnD0ZMIzlgIoYvh
         AatE0IYsFSXg7sIwwMFQmP2MNjJBXrjd3ySwKBbs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 5.4 10/88] HID: wacom: fix problems when device is not a valid USB device
Date:   Mon, 13 Dec 2021 10:29:40 +0100
Message-Id: <20211213092933.583260855@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092933.250314515@linuxfoundation.org>
References: <20211213092933.250314515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 720ac467204a70308bd687927ed475afb904e11b upstream.

The wacom driver accepts devices of more than just USB types, but some
code paths can cause problems if the device being controlled is not a
USB device due to a lack of checking.  Add the needed checks to ensure
that the USB device accesses are only happening on a "real" USB device,
and not one on some other bus.

Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: linux-input@vger.kernel.org
Cc: stable@vger.kernel.org
Tested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20211201183503.2373082-2-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -726,7 +726,7 @@ static void wacom_retrieve_hid_descripto
 	 * Skip the query for this type and modify defaults based on
 	 * interface number.
 	 */
-	if (features->type == WIRELESS) {
+	if (features->type == WIRELESS && intf) {
 		if (intf->cur_altsetting->desc.bInterfaceNumber == 0)
 			features->device_type = WACOM_DEVICETYPE_WL_MONITOR;
 		else
@@ -2448,6 +2448,9 @@ static void wacom_wireless_work(struct w
 
 	wacom_destroy_battery(wacom);
 
+	if (!usbdev)
+		return;
+
 	/* Stylus interface */
 	hdev1 = usb_get_intfdata(usbdev->config->interface[1]);
 	wacom1 = hid_get_drvdata(hdev1);
@@ -2727,8 +2730,6 @@ static void wacom_mode_change_work(struc
 static int wacom_probe(struct hid_device *hdev,
 		const struct hid_device_id *id)
 {
-	struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
-	struct usb_device *dev = interface_to_usbdev(intf);
 	struct wacom *wacom;
 	struct wacom_wac *wacom_wac;
 	struct wacom_features *features;
@@ -2763,8 +2764,14 @@ static int wacom_probe(struct hid_device
 	wacom_wac->hid_data.inputmode = -1;
 	wacom_wac->mode_report = -1;
 
-	wacom->usbdev = dev;
-	wacom->intf = intf;
+	if (hid_is_usb(hdev)) {
+		struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
+		struct usb_device *dev = interface_to_usbdev(intf);
+
+		wacom->usbdev = dev;
+		wacom->intf = intf;
+	}
+
 	mutex_init(&wacom->lock);
 	INIT_DELAYED_WORK(&wacom->init_work, wacom_init_work);
 	INIT_WORK(&wacom->wireless_work, wacom_wireless_work);


