Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A299150A03
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 16:41:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgBCPlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 10:41:52 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:36315 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728173AbgBCPlo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Feb 2020 10:41:44 -0500
Received: by mail-lf1-f67.google.com with SMTP id f24so10039176lfh.3;
        Mon, 03 Feb 2020 07:41:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rG+lNEiDpqMWdi6EGu9J11of9DzgpUPGwdm5nMRBvp4=;
        b=d4GcxcZVWim6KNpJe6nOCQTFTHTZYjmq8tvro560O3psMK041qGvzZ2qaqtlN/IKPh
         72rRb7dL2MWQkkgofQR92zGhFn+IKkhf6OTsILkqApooA/t24h/k1soZuAVL7Uc7katN
         tEwGHwIQc435L5yr4NAtJPZZrSCRCaigoH5ROEpdm9YuvlGE+GxePOcIXN6JYd9wVyc5
         8P+M+V/NdSHiDERRY9U4I54GZcnmfueoAQNN5fBrXD13Go3FosWQMgOWG4pz6Mav/PVN
         BnhxeLwiITwPYhtyNTl/42E8xUWs5b/0BAjYypA8o0m2KxKAkbuAh5yny2HvY+QrheH2
         U/9g==
X-Gm-Message-State: APjAAAVWguB6/VJPPqTqIMYTeDPDZH+UyTgsKTKz1kdXMFE8huF8vSVl
        MGICE96szBalxPUExZ36CCPZHQGG
X-Google-Smtp-Source: APXvYqwpL9XoWOel+/TgronBlrhOchU8/yyfdHbGjRPIFqRGgYEubqAAw64/ghDEZRXPUP6IX3mXJQ==
X-Received: by 2002:ac2:47ec:: with SMTP id b12mr12425750lfp.162.1580744500043;
        Mon, 03 Feb 2020 07:41:40 -0800 (PST)
Received: from xi.terra (c-12aae455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.170.18])
        by smtp.gmail.com with ESMTPSA id p12sm9101719lfc.43.2020.02.03.07.41.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Feb 2020 07:41:38 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1iydrA-0006tB-8B; Mon, 03 Feb 2020 16:41:48 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>, edes <edes@gmx.net>,
        Takashi Iwai <tiwai@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH 1/3] USB: core: add endpoint-blacklist quirk
Date:   Mon,  3 Feb 2020 16:38:28 +0100
Message-Id: <20200203153830.26394-2-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200203153830.26394-1-johan@kernel.org>
References: <20200203153830.26394-1-johan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
2.24.1

