Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF992126669
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 17:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbfLSQKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 11:10:50 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34486 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726778AbfLSQKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Dec 2019 11:10:50 -0500
Received: by mail-lf1-f66.google.com with SMTP id l18so4767474lfc.1;
        Thu, 19 Dec 2019 08:10:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Q+mWCcB2PjNV8Cf0S7CrD5a7sF3u4PcjJA+VPFUwOwc=;
        b=f9LjlbQbs8saprawrcF7ocdUvFw/KD3P7iOFeM43L8JGie/fPj/TIhDh/gknI/7JgI
         Ke/HdQK7lazuyNZugGt4fRL6REp5uIGfkgiLwXtjhivI6H36y8VnKyke+zdL40lCs2/1
         uUl/k/JVIqOhI9SwOEaU2C3r/LkUYz9g+0qbyyPeI5kbXJr6XersJWLD7yhzyAf4qF0i
         Dp/IDbNDNuO6VN7n/B8EoIcIIzPrU4l4dJdHVzt7xIT3aEwKdUm10g6+R+KkuAeqLp1A
         mi+paRivFlqerVooX6BxsSmAgSPhZhoOsUu6a/jfYugTEGCFeBDG0ivyJ5oOWhVDm/2X
         qmRg==
X-Gm-Message-State: APjAAAXDOKzrvxNzxHWkiWheFBhEh7fvhJ7J/ONgDKc0HzasVFdXVeXm
        XLwYaoaBo9wNZMJfqQaBvZ4=
X-Google-Smtp-Source: APXvYqxtvBGfAe6Dc/6onsWLggo73Oeoxys2KzvUdYqMSyoYVAWxx+JdhRJ+Sml8m43K3PBCpeBqTQ==
X-Received: by 2002:ac2:420e:: with SMTP id y14mr5960231lfh.145.1576771848251;
        Thu, 19 Dec 2019 08:10:48 -0800 (PST)
Received: from xi.terra (c-14b8e655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.184.20])
        by smtp.gmail.com with ESMTPSA id r21sm3071231ljn.64.2019.12.19.08.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 08:10:47 -0800 (PST)
Received: from johan by xi.terra with local (Exim 4.92.3)
        (envelope-from <johan@xi.terra>)
        id 1ihyNw-0001kn-EH; Thu, 19 Dec 2019 17:10:44 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: [PATCH] USB: core: fix check for duplicate endpoints
Date:   Thu, 19 Dec 2019 17:10:16 +0100
Message-Id: <20191219161016.6695-1-johan@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---

Exploiting this to trigger a crash probably requires a lot more
malicious intent than the syzbot fuzzer currently possesses, but I think
we need to plug this nonetheless.

Johan


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

