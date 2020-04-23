Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61E301B685E
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:14:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729119AbgDWXOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:14:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:49788 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728437AbgDWXGs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:48 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvT-0004hp-Lg; Fri, 24 Apr 2020 00:06:35 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvS-00E6qh-3o; Fri, 24 Apr 2020 00:06:34 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Johan Hovold" <johan@kernel.org>
Date:   Fri, 24 Apr 2020 00:06:12 +0100
Message-ID: <lsq.1587683028.789400120@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 145/245] USB: core: fix check for duplicate endpoints
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

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

Signed-off-by: Johan Hovold <johan@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20191219161016.6695-1-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/config.c | 70 ++++++++++++++++++++++++++++++++-------
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
@@ -481,8 +527,8 @@ static int usb_parse_interface(struct de
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

