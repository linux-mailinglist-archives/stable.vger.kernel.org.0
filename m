Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F376610B8A3
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 21:45:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729722AbfK0UpW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 15:45:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:55826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727487AbfK0UpR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 15:45:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A3E821780;
        Wed, 27 Nov 2019 20:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574887516;
        bh=k16vSFfB3VcnFtGPPlm6toStzxruCtOzTNuNmFq9ccA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SDQmre/qGg3Netny21fYegGrSkmGsDxeTwKCfO7Ednp1bC6WeXkWqp0JhaXYgVKC7
         SaIiGVH2lHnxYI2b9dtBJ8UM24bBe/rN4LzOvqJMuHA+RCKDxFIOAP4qhWJoTlSXqh
         q29ig4eXv+KbZQQESWvtZMQea1R4k+Azmb9Llv5U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver Neukum <oneukum@suse.de>
Subject: [PATCH 4.9 141/151] USB: chaoskey: fix error case of a timeout
Date:   Wed, 27 Nov 2019 21:32:04 +0100
Message-Id: <20191127203047.107855223@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
References: <20191127203000.773542911@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>

commit 92aa5986f4f7b5a8bf282ca0f50967f4326559f5 upstream.

In case of a timeout or if a signal aborts a read
communication with the device needs to be ended
lest we overwrite an active URB the next time we
do IO to the device, as the URB may still be active.

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20191107142856.16774-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/chaoskey.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/usb/misc/chaoskey.c
+++ b/drivers/usb/misc/chaoskey.c
@@ -412,13 +412,17 @@ static int _chaoskey_fill(struct chaoske
 		!dev->reading,
 		(started ? NAK_TIMEOUT : ALEA_FIRST_TIMEOUT) );
 
-	if (result < 0)
+	if (result < 0) {
+		usb_kill_urb(dev->urb);
 		goto out;
+	}
 
-	if (result == 0)
+	if (result == 0) {
 		result = -ETIMEDOUT;
-	else
+		usb_kill_urb(dev->urb);
+	} else {
 		result = dev->valid;
+	}
 out:
 	/* Let the device go back to sleep eventually */
 	usb_autopm_put_interface(dev->interface);
@@ -554,7 +558,21 @@ static int chaoskey_suspend(struct usb_i
 
 static int chaoskey_resume(struct usb_interface *interface)
 {
+	struct chaoskey *dev;
+	struct usb_device *udev = interface_to_usbdev(interface);
+
 	usb_dbg(interface, "resume");
+	dev = usb_get_intfdata(interface);
+
+	/*
+	 * We may have lost power.
+	 * In that case the device that needs a long time
+	 * for the first requests needs an extended timeout
+	 * again
+	 */
+	if (le16_to_cpu(udev->descriptor.idVendor) == ALEA_VENDOR_ID)
+		dev->reads_started = false;
+
 	return 0;
 }
 #else


