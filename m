Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2098158358
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 20:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgBJTOp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 14:14:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:44322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727029AbgBJTOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 14:14:45 -0500
Received: from localhost (unknown [104.132.1.111])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2004420838;
        Mon, 10 Feb 2020 19:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581362085;
        bh=/wJA/6bu7T7nB6timRWWxjUYKVRGoMCmkQpwsUE4LcI=;
        h=Subject:To:From:Date:From;
        b=vfLAx91u9zIZWmfYz0wZsW1dL1S4TXDLbs1ljjz4NmR0oYYU0PpEArWYKvLbqOJFE
         1DFgqyk9k9PZmtzxFxSp3peZD2FxOgU8MkXy0utPa8XyRhSsc3z1qFKjLOqFcUUFL3
         I9ejW5E3oB+oN3dolh+JGXmZelAg0fO5gQKgTN8s=
Subject: patch "USB: core: add endpoint-blacklist quirk" added to usb-linus
To:     johan@kernel.org, edes@gmx.net, gregkh@linuxfoundation.org,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 10 Feb 2020 11:14:44 -0800
Message-ID: <1581362084144210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: core: add endpoint-blacklist quirk

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 73f8bda9b5dc1c69df2bc55c0cbb24461a6391a9 Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Mon, 3 Feb 2020 16:38:28 +0100
Subject: USB: core: add endpoint-blacklist quirk

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
---
 drivers/usb/core/config.c  | 11 +++++++++++
 drivers/usb/core/quirks.c  | 32 ++++++++++++++++++++++++++++++++
 drivers/usb/core/usb.h     |  3 +++
 include/linux/usb/quirks.h |  3 +++
 4 files changed, 49 insertions(+)

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 26bc05e48d8a..7df22bcefa9d 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -256,6 +256,7 @@ static int usb_parse_endpoint(struct device *ddev, int cfgno,
 		struct usb_host_interface *ifp, int num_ep,
 		unsigned char *buffer, int size)
 {
+	struct usb_device *udev = to_usb_device(ddev);
 	unsigned char *buffer0 = buffer;
 	struct usb_endpoint_descriptor *d;
 	struct usb_host_endpoint *endpoint;
@@ -297,6 +298,16 @@ static int usb_parse_endpoint(struct device *ddev, int cfgno,
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
 
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 6b6413073584..56c8dffaf5f5 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -472,6 +472,38 @@ static const struct usb_device_id usb_amd_resume_quirk_list[] = {
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
diff --git a/drivers/usb/core/usb.h b/drivers/usb/core/usb.h
index cf4783cf661a..3ad0ee57e859 100644
--- a/drivers/usb/core/usb.h
+++ b/drivers/usb/core/usb.h
@@ -37,6 +37,9 @@ extern void usb_authorize_interface(struct usb_interface *);
 extern void usb_detect_quirks(struct usb_device *udev);
 extern void usb_detect_interface_quirks(struct usb_device *udev);
 extern void usb_release_quirk_list(void);
+extern bool usb_endpoint_is_blacklisted(struct usb_device *udev,
+		struct usb_host_interface *intf,
+		struct usb_endpoint_descriptor *epd);
 extern int usb_remove_device(struct usb_device *udev);
 
 extern int usb_get_device_descriptor(struct usb_device *dev,
diff --git a/include/linux/usb/quirks.h b/include/linux/usb/quirks.h
index a1be64c9940f..22c1f579afe3 100644
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -69,4 +69,7 @@
 /* Hub needs extra delay after resetting its port. */
 #define USB_QUIRK_HUB_SLOW_RESET		BIT(14)
 
+/* device has blacklisted endpoints */
+#define USB_QUIRK_ENDPOINT_BLACKLIST		BIT(15)
+
 #endif /* __LINUX_USB_QUIRKS_H */
-- 
2.25.0


