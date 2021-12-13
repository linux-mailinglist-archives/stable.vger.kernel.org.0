Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F50A47299B
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239438AbhLMKXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236845AbhLMJrf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:47:35 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E551CC07E5C4;
        Mon, 13 Dec 2021 01:42:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 69438CE0B59;
        Mon, 13 Dec 2021 09:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1858DC00446;
        Mon, 13 Dec 2021 09:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388559;
        bh=PfNCq6by0GUv1vRDTl5zK0YHGAGxlSw4VN/lC2e+fKo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PiHp2rwgcYMh8Z+10LDdejBzD7MyUDu+xaij3whMpjViosX6Po5xfvOEp9aWjynqS
         EGqD+bCRKF/oLf8URUShZIEeEycLKnSvnDB6YqSdsNcqLVFb2X5uazBDJeNQz7ee37
         UdA8rekK2bEj/akB/lkTzxW61YQ4OhzFN1S4HOns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 5.4 05/88] HID: add hid_is_usb() function to make it simpler for USB detection
Date:   Mon, 13 Dec 2021 10:29:35 +0100
Message-Id: <20211213092933.427562426@linuxfoundation.org>
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
 drivers/hid/hid-asus.c           |    2 +-
 drivers/hid/hid-logitech-dj.c    |    2 +-
 drivers/hid/hid-u2fzero.c        |    2 +-
 drivers/hid/hid-uclogic-params.c |    3 +--
 drivers/hid/wacom_sys.c          |    2 +-
 include/linux/hid.h              |    5 +++++
 6 files changed, 10 insertions(+), 6 deletions(-)

--- a/drivers/hid/hid-asus.c
+++ b/drivers/hid/hid-asus.c
@@ -849,7 +849,7 @@ static int asus_probe(struct hid_device
 	if (drvdata->quirks & QUIRK_IS_MULTITOUCH)
 		drvdata->tp = &asus_i2c_tp;
 
-	if (drvdata->quirks & QUIRK_T100_KEYBOARD) {
+	if ((drvdata->quirks & QUIRK_T100_KEYBOARD) && hid_is_usb(hdev)) {
 		struct usb_interface *intf = to_usb_interface(hdev->dev.parent);
 
 		if (intf->altsetting->desc.bInterfaceNumber == T100_TPAD_INTF) {
--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -1686,7 +1686,7 @@ static int logi_dj_probe(struct hid_devi
 	case recvr_type_27mhz:		no_dj_interfaces = 2; break;
 	case recvr_type_bluetooth:	no_dj_interfaces = 2; break;
 	}
-	if (hid_is_using_ll_driver(hdev, &usb_hid_driver)) {
+	if (hid_is_usb(hdev)) {
 		intf = to_usb_interface(hdev->dev.parent);
 		if (intf && intf->altsetting->desc.bInterfaceNumber >=
 							no_dj_interfaces) {
--- a/drivers/hid/hid-u2fzero.c
+++ b/drivers/hid/hid-u2fzero.c
@@ -290,7 +290,7 @@ static int u2fzero_probe(struct hid_devi
 	unsigned int minor;
 	int ret;
 
-	if (!hid_is_using_ll_driver(hdev, &usb_hid_driver))
+	if (!hid_is_usb(hdev))
 		return -EINVAL;
 
 	dev = devm_kzalloc(&hdev->dev, sizeof(*dev), GFP_KERNEL);
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -841,8 +841,7 @@ int uclogic_params_init(struct uclogic_p
 	struct uclogic_params p = {0, };
 
 	/* Check arguments */
-	if (params == NULL || hdev == NULL ||
-	    !hid_is_using_ll_driver(hdev, &usb_hid_driver)) {
+	if (params == NULL || hdev == NULL || !hid_is_usb(hdev)) {
 		rc = -EINVAL;
 		goto cleanup;
 	}
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -2217,7 +2217,7 @@ static void wacom_update_name(struct wac
 	if ((features->type == HID_GENERIC) && !strcmp("Wacom HID", features->name)) {
 		char *product_name = wacom->hdev->name;
 
-		if (hid_is_using_ll_driver(wacom->hdev, &usb_hid_driver)) {
+		if (hid_is_usb(wacom->hdev)) {
 			struct usb_interface *intf = to_usb_interface(wacom->hdev->dev.parent);
 			struct usb_device *dev = interface_to_usbdev(intf);
 			product_name = dev->product;
--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -831,6 +831,11 @@ static inline bool hid_is_using_ll_drive
 	return hdev->ll_driver == driver;
 }
 
+static inline bool hid_is_usb(struct hid_device *hdev)
+{
+	return hid_is_using_ll_driver(hdev, &usb_hid_driver);
+}
+
 #define	PM_HINT_FULLON	1<<5
 #define PM_HINT_NORMAL	1<<1
 


