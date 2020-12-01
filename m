Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DF82C9AAE
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 10:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388209AbgLAI7y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:59:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:35740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388203AbgLAI7w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:59:52 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A97AB21D7A;
        Tue,  1 Dec 2020 08:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606813151;
        bh=uW6h1dpk5WRQ8A5hECvFORk7m2rs7cHBa3T/Gw34zAc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4Tw0ynp0lpDQ16ZVL8F1h9+NFq1DoHj+Obx38ktmUvreaVVY5Kpi0F5X44ysgP/s
         TSP5LLOy+Ce+fboN62qRKCr6+FuYtCsOOihq6HTXJLljDlinzAIy/HlM3JFey9nTAB
         4G6zqdhDqNTd4ibBVxoZv7nXPNaDV+3EQiHaI4rQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, edes <edes@gmx.net>,
        Johan Hovold <johan@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.14 49/50] USB: core: add endpoint-blacklist quirk
Date:   Tue,  1 Dec 2020 09:53:48 +0100
Message-Id: <20201201084650.528328585@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201201084644.803812112@linuxfoundation.org>
References: <20201201084644.803812112@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 73f8bda9b5dc1c69df2bc55c0cbb24461a6391a9 upstream

Add a new device quirk that can be used to blacklist endpoints.

Since commit 3e4f8e21c4f2 ("USB: core: fix check for duplicate
endpoints") USB core ignores any duplicate endpoints found during
descriptor parsing.

In order to handle devices where the first interfaces with duplicate
endpoints are the ones that should have their endpoints ignored, we need
to add a blacklist.

Tested-by: edes <edes@gmx.net>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20200203153830.26394-2-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/config.c  |   11 +++++++++++
 drivers/usb/core/quirks.c  |   32 ++++++++++++++++++++++++++++++++
 drivers/usb/core/usb.h     |    3 +++
 include/linux/usb/quirks.h |    3 +++
 4 files changed, 49 insertions(+)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -256,6 +256,7 @@ static int usb_parse_endpoint(struct dev
 		struct usb_host_interface *ifp, int num_ep,
 		unsigned char *buffer, int size)
 {
+	struct usb_device *udev = to_usb_device(ddev);
 	unsigned char *buffer0 = buffer;
 	struct usb_endpoint_descriptor *d;
 	struct usb_host_endpoint *endpoint;
@@ -297,6 +298,16 @@ static int usb_parse_endpoint(struct dev
 		goto skip_to_next_endpoint_or_interface_descriptor;
 	}
 
+	/* Ignore blacklisted endpoints */
+	if (udev->quirks & USB_QUIRK_ENDPOINT_BLACKLIST) {
+		if (usb_endpoint_is_blacklisted(udev, ifp, d)) {
+			dev_warn(ddev, "config %d interface %d altsetting %d has a blacklisted endpoint with address 0x%X, skipping\n",
+					cfgno, inum, asnum,
+					d->bEndpointAddress);
+			goto skip_to_next_endpoint_or_interface_descriptor;
+		}
+	}
+
 	endpoint = &ifp->endpoint[ifp->desc.bNumEndpoints];
 	++ifp->desc.bNumEndpoints;
 
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -344,6 +344,38 @@ static const struct usb_device_id usb_am
 	{ }  /* terminating entry must be last */
 };
 
+/*
+ * Entries for blacklisted endpoints that should be ignored when parsing
+ * configuration descriptors.
+ *
+ * Matched for devices with USB_QUIRK_ENDPOINT_BLACKLIST.
+ */
+static const struct usb_device_id usb_endpoint_blacklist[] = {
+	{ }
+};
+
+bool usb_endpoint_is_blacklisted(struct usb_device *udev,
+		struct usb_host_interface *intf,
+		struct usb_endpoint_descriptor *epd)
+{
+	const struct usb_device_id *id;
+	unsigned int address;
+
+	for (id = usb_endpoint_blacklist; id->match_flags; ++id) {
+		if (!usb_match_device(udev, id))
+			continue;
+
+		if (!usb_match_one_id_intf(udev, intf, id))
+			continue;
+
+		address = id->driver_info;
+		if (address == epd->bEndpointAddress)
+			return true;
+	}
+
+	return false;
+}
+
 static bool usb_match_any_interface(struct usb_device *udev,
 				    const struct usb_device_id *id)
 {
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -36,6 +36,9 @@ extern void usb_deauthorize_interface(st
 extern void usb_authorize_interface(struct usb_interface *);
 extern void usb_detect_quirks(struct usb_device *udev);
 extern void usb_detect_interface_quirks(struct usb_device *udev);
+extern bool usb_endpoint_is_blacklisted(struct usb_device *udev,
+		struct usb_host_interface *intf,
+		struct usb_endpoint_descriptor *epd);
 extern int usb_remove_device(struct usb_device *udev);
 
 extern int usb_get_device_descriptor(struct usb_device *dev,
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -60,4 +60,7 @@
 /* Device needs a pause after every control message. */
 #define USB_QUIRK_DELAY_CTRL_MSG		BIT(13)
 
+/* device has blacklisted endpoints */
+#define USB_QUIRK_ENDPOINT_BLACKLIST		BIT(15)
+
 #endif /* __LINUX_USB_QUIRKS_H */


