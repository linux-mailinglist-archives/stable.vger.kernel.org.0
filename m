Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03AD147254A
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:43:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236177AbhLMJnP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbhLMJl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:41:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E65EC08E9B0;
        Mon, 13 Dec 2021 01:39:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C5FEB80E19;
        Mon, 13 Dec 2021 09:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83E42C00446;
        Mon, 13 Dec 2021 09:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388352;
        bh=7fw6eIAjoNXTmK0veCULfcLKFK5LMm4xKFHFJ14zlTA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TwXCOg+lReaZbhJVDQVgv5G88vamqEZtW+5Ezvwp3AZSX3PO81nXJKonMs5qSqXD0
         Mpi1w4TrFV+HEkuDvBgAi5Zz10yhiK6twMxsLqV5vMMvvogYavyslxgTOSL7iPcv6A
         EAlO54OveuRGQTosWDOe7Il6S0gRPgp/aLRv7p3U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 4.19 02/74] HID: add hid_is_usb() function to make it simpler for USB detection
Date:   Mon, 13 Dec 2021 10:29:33 +0100
Message-Id: <20211213092930.855330955@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f83baa0cb6cfc92ebaf7f9d3a99d7e34f2e77a8a upstream.

A number of HID drivers already call hid_is_using_ll_driver() but only
for the detection of if this is a USB device or not.  Make this more
obvious by creating hid_is_usb() and calling the function that way.

Also converts the existing hid_is_using_ll_driver() functions to use the
new call.

Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: linux-input@vger.kernel.org
Cc: stable@vger.kernel.org
Tested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20211201183503.2373082-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-asus.c  |    2 +-
 drivers/hid/wacom_sys.c |    2 +-
 include/linux/hid.h     |    5 +++++
 3 files changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -622,7 +622,7 @@ static int asus_probe(struct hid_device
 	if (drvdata->quirks & QUIRK_IS_MULTITOUCH)
 		drvdata->tp = &asus_i2c_tp;
 
-	if (drvdata->quirks & QUIRK_T100_KEYBOARD) {
+	if ((drvdata->quirks & QUIRK_T100_KEYBOARD) && hid_is_usb(hdev)) {
 		struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
 
 		if (intf->altsetting->desc.bInterfaceNumber == T100_TPAD_INTF) {
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2188,7 +2188,7 @@ static void wacom_update_name(struct wac
 	if ((features->type == HID_GENERIC) && !strcmp("Wacom HID", features->name)) {
 		char *product_name = wacom->hdev->name;
 
-		if (hid_is_using_ll_driver(wacom->hdev, &usb_hid_driver)) {
+		if (hid_is_usb(wacom->hdev)) {
 			struct usb_interface *intf = to_usb_interface(wacom->hdev->dev.parent);
 			struct usb_device *dev = interface_to_usbdev(intf);
 			product_name = dev->product;
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -834,6 +834,11 @@ static inline bool hid_is_using_ll_drive
 	return hdev->ll_driver == driver;
 }
 
+static inline bool hid_is_usb(struct hid_device *hdev)
+{
+	return hid_is_using_ll_driver(hdev, &usb_hid_driver);
+}
+
 #define	PM_HINT_FULLON	1<<5
 #define PM_HINT_NORMAL	1<<1
 


