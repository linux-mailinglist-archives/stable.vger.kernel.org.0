Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92C72137D7D
	for <lists+stable@lfdr.de>; Sat, 11 Jan 2020 11:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729216AbgAKJ6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Jan 2020 04:58:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:51548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729146AbgAKJ6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Jan 2020 04:58:23 -0500
Received: from localhost (unknown [62.119.166.9])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E1F92077C;
        Sat, 11 Jan 2020 09:58:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578736703;
        bh=dd7rgfDmKyqdCCGrdR4U/MtLUXQUe55wHKwFxZa3gZc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j17gSOdvb0Tna98f7XFrMXGHB0fKF10kdnW0XvR/2n9NqlxJ1CQlf8KNnsCSsjwKw
         3C6D7MprBRMwmZ3kipMtSxet7JOs9lLDrXTZ1CrCmrzCmUrp2/6EF+TUI0M7rapD9U
         QCQ4N4PrVEuOnivtgybReeMLNN9aYIxWvuyfT5UA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 4.4 58/59] USB: core: fix check for duplicate endpoints
Date:   Sat, 11 Jan 2020 10:50:07 +0100
Message-Id: <20200111094853.753644646@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200111094835.417654274@linuxfoundation.org>
References: <20200111094835.417654274@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 3e4f8e21c4f27bcf30a48486b9dcc269512b79ff upstream.

Amend the endpoint-descriptor sanity checks to detect all duplicate
endpoint addresses in a configuration.

Commit 0a8fd1346254 ("USB: fix problems with duplicate endpoint
addresses") added a check for duplicate endpoint addresses within a
single alternate setting, but did not look for duplicate addresses in
other interfaces.

The current check would also not detect all duplicate addresses when one
endpoint is as a (bi-directional) control endpoint.

This specifically avoids overwriting the endpoint entries in struct
usb_device when enabling a duplicate endpoint, something which could
potentially lead to crashes or leaks, for example, when endpoints are
later disabled.

Cc: stable <stable@vger.kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20191219161016.6695-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/config.c |   70 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 58 insertions(+), 12 deletions(-)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -169,9 +169,58 @@ static const unsigned short super_speed_
 	[USB_ENDPOINT_XFER_INT] = 1024,
 };
 
-static int usb_parse_endpoint(struct device *ddev, int cfgno, int inum,
-    int asnum, struct usb_host_interface *ifp, int num_ep,
-    unsigned char *buffer, int size)
+static bool endpoint_is_duplicate(struct usb_endpoint_descriptor *e1,
+		struct usb_endpoint_descriptor *e2)
+{
+	if (e1->bEndpointAddress == e2->bEndpointAddress)
+		return true;
+
+	if (usb_endpoint_xfer_control(e1) || usb_endpoint_xfer_control(e2)) {
+		if (usb_endpoint_num(e1) == usb_endpoint_num(e2))
+			return true;
+	}
+
+	return false;
+}
+
+/*
+ * Check for duplicate endpoint addresses in other interfaces and in the
+ * altsetting currently being parsed.
+ */
+static bool config_endpoint_is_duplicate(struct usb_host_config *config,
+		int inum, int asnum, struct usb_endpoint_descriptor *d)
+{
+	struct usb_endpoint_descriptor *epd;
+	struct usb_interface_cache *intfc;
+	struct usb_host_interface *alt;
+	int i, j, k;
+
+	for (i = 0; i < config->desc.bNumInterfaces; ++i) {
+		intfc = config->intf_cache[i];
+
+		for (j = 0; j < intfc->num_altsetting; ++j) {
+			alt = &intfc->altsetting[j];
+
+			if (alt->desc.bInterfaceNumber == inum &&
+					alt->desc.bAlternateSetting != asnum)
+				continue;
+
+			for (k = 0; k < alt->desc.bNumEndpoints; ++k) {
+				epd = &alt->endpoint[k].desc;
+
+				if (endpoint_is_duplicate(epd, d))
+					return true;
+			}
+		}
+	}
+
+	return false;
+}
+
+static int usb_parse_endpoint(struct device *ddev, int cfgno,
+		struct usb_host_config *config, int inum, int asnum,
+		struct usb_host_interface *ifp, int num_ep,
+		unsigned char *buffer, int size)
 {
 	unsigned char *buffer0 = buffer;
 	struct usb_endpoint_descriptor *d;
@@ -208,13 +257,10 @@ static int usb_parse_endpoint(struct dev
 		goto skip_to_next_endpoint_or_interface_descriptor;
 
 	/* Check for duplicate endpoint addresses */
-	for (i = 0; i < ifp->desc.bNumEndpoints; ++i) {
-		if (ifp->endpoint[i].desc.bEndpointAddress ==
-		    d->bEndpointAddress) {
-			dev_warn(ddev, "config %d interface %d altsetting %d has a duplicate endpoint with address 0x%X, skipping\n",
-			    cfgno, inum, asnum, d->bEndpointAddress);
-			goto skip_to_next_endpoint_or_interface_descriptor;
-		}
+	if (config_endpoint_is_duplicate(config, inum, asnum, d)) {
+		dev_warn(ddev, "config %d interface %d altsetting %d has a duplicate endpoint with address 0x%X, skipping\n",
+				cfgno, inum, asnum, d->bEndpointAddress);
+		goto skip_to_next_endpoint_or_interface_descriptor;
 	}
 
 	endpoint = &ifp->endpoint[ifp->desc.bNumEndpoints];
@@ -488,8 +534,8 @@ static int usb_parse_interface(struct de
 		if (((struct usb_descriptor_header *) buffer)->bDescriptorType
 		     == USB_DT_INTERFACE)
 			break;
-		retval = usb_parse_endpoint(ddev, cfgno, inum, asnum, alt,
-		    num_ep, buffer, size);
+		retval = usb_parse_endpoint(ddev, cfgno, config, inum, asnum,
+				alt, num_ep, buffer, size);
 		if (retval < 0)
 			return retval;
 		++n;


