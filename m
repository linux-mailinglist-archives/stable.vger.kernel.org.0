Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 723CA12D3B1
	for <lists+stable@lfdr.de>; Mon, 30 Dec 2019 20:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727597AbfL3TCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Dec 2019 14:02:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727278AbfL3TCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Dec 2019 14:02:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B922F206DB;
        Mon, 30 Dec 2019 19:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577732540;
        bh=9Jnpk337mAi69HO+gjGOn55ikLR5t2L7kToE5uNbu1o=;
        h=Subject:To:From:Date:From;
        b=qls/95NpAMiCHeiEOOKE5cf0ce2LI7aVZ/3ntY3hj8TW6gp2SJmsL0tcM5Chj91/H
         6cUWYVsxKOmveGtYHNGvStfeuw9WA6H5F7/SFzfk7+mv5ubI61LP8/qGxquZF/qUl/
         zNo1Ubtaua4/9uvMLgpL75gXmIPeBp/ZozYawr50=
Subject: patch "USB: core: fix check for duplicate endpoints" added to usb-linus
To:     johan@kernel.org, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, stern@rowland.harvard.edu
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 30 Dec 2019 20:02:18 +0100
Message-ID: <1577732538224254@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    USB: core: fix check for duplicate endpoints

to my usb git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
in the usb-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 3e4f8e21c4f27bcf30a48486b9dcc269512b79ff Mon Sep 17 00:00:00 2001
From: Johan Hovold <johan@kernel.org>
Date: Thu, 19 Dec 2019 17:10:16 +0100
Subject: USB: core: fix check for duplicate endpoints

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
 drivers/usb/core/config.c | 70 ++++++++++++++++++++++++++++++++-------
 1 file changed, 58 insertions(+), 12 deletions(-)

diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 5f40117e68e7..21291950cc97 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -203,9 +203,58 @@ static const unsigned short super_speed_maxpacket_maxes[4] = {
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
@@ -242,13 +291,10 @@ static int usb_parse_endpoint(struct device *ddev, int cfgno, int inum,
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
@@ -522,8 +568,8 @@ static int usb_parse_interface(struct device *ddev, int cfgno,
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
-- 
2.24.1


