Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D99B43AA1B
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732505AbfFIQyA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:54:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:55468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732513AbfFIQx7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:53:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A065206C3;
        Sun,  9 Jun 2019 16:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099239;
        bh=YLT6PZzhz5CbO5aRKc8oe50qorQ6mekAjquFK2H4gNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YypB5Bmj0m6nglgMSOFdu8BWl0o2z2IZo2OyUJqiIXAdnuWyH3xa8hYvIazMTH940
         fU8VcPojO+h/wBp4CDSZpc+OPgQsHWXHe9RXZ/b/TAUfGYlR87fL7i381D0yrVZ+WA
         DsF1B5S1LtqNO4fZ6WmxCVuTVrj3dDKYtmYwkq4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4.9 25/83] usbip: usbip_host: fix stub_dev lock context imbalance regression
Date:   Sun,  9 Jun 2019 18:41:55 +0200
Message-Id: <20190609164129.699822253@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.843327870@linuxfoundation.org>
References: <20190609164127.843327870@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 3ea3091f1bd8586125848c62be295910e9802af0 upstream.

Fix the following sparse context imbalance regression introduced in
a patch that fixed sleeping function called from invalid context bug.

kbuild test robot reported on:

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git  usb-linus

Regressions in current branch:

drivers/usb/usbip/stub_dev.c:399:9: sparse: sparse: context imbalance in 'stub_probe' - different lock contexts for basic block
drivers/usb/usbip/stub_dev.c:418:13: sparse: sparse: context imbalance in 'stub_disconnect' - different lock contexts for basic block
drivers/usb/usbip/stub_dev.c:464:1-10: second lock on line 476

Error ids grouped by kconfigs:

recent_errors
├── i386-allmodconfig
│   └── drivers-usb-usbip-stub_dev.c:second-lock-on-line
├── x86_64-allmodconfig
│   ├── drivers-usb-usbip-stub_dev.c:sparse:sparse:context-imbalance-in-stub_disconnect-different-lock-contexts-for-basic-block
│   └── drivers-usb-usbip-stub_dev.c:sparse:sparse:context-imbalance-in-stub_probe-different-lock-contexts-for-basic-block
└── x86_64-allyesconfig
    └── drivers-usb-usbip-stub_dev.c:second-lock-on-line

This is a real problem in an error leg where spin_lock() is called on an
already held lock.

Fix the imbalance in stub_probe() and stub_disconnect().

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Fixes: 0c9e8b3cad65 ("usbip: usbip_host: fix BUG: sleeping function called from invalid context")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/usbip/stub_dev.c |   36 +++++++++++++++++++++++-------------
 1 file changed, 23 insertions(+), 13 deletions(-)

--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -340,14 +340,17 @@ static int stub_probe(struct usb_device
 		 * See driver_probe_device() in driver/base/dd.c
 		 */
 		rc = -ENODEV;
-		goto sdev_free;
+		if (!busid_priv)
+			goto sdev_free;
+
+		goto call_put_busid_priv;
 	}
 
 	if (udev->descriptor.bDeviceClass == USB_CLASS_HUB) {
 		dev_dbg(&udev->dev, "%s is a usb hub device... skip!\n",
 			 udev_busid);
 		rc = -ENODEV;
-		goto sdev_free;
+		goto call_put_busid_priv;
 	}
 
 	if (!strcmp(udev->bus->bus_name, "vhci_hcd")) {
@@ -356,7 +359,7 @@ static int stub_probe(struct usb_device
 			udev_busid);
 
 		rc = -ENODEV;
-		goto sdev_free;
+		goto call_put_busid_priv;
 	}
 
 
@@ -375,6 +378,9 @@ static int stub_probe(struct usb_device
 	save_status = busid_priv->status;
 	busid_priv->status = STUB_BUSID_ALLOC;
 
+	/* release the busid_lock */
+	put_busid_priv(busid_priv);
+
 	/*
 	 * Claim this hub port.
 	 * It doesn't matter what value we pass as owner
@@ -387,9 +393,6 @@ static int stub_probe(struct usb_device
 		goto err_port;
 	}
 
-	/* release the busid_lock */
-	put_busid_priv(busid_priv);
-
 	rc = stub_add_files(&udev->dev);
 	if (rc) {
 		dev_err(&udev->dev, "stub_add_files for %s\n", udev_busid);
@@ -409,11 +412,17 @@ err_port:
 	spin_lock(&busid_priv->busid_lock);
 	busid_priv->sdev = NULL;
 	busid_priv->status = save_status;
-sdev_free:
-	stub_device_free(sdev);
+	spin_unlock(&busid_priv->busid_lock);
+	/* lock is released - go to free */
+	goto sdev_free;
+
+call_put_busid_priv:
 	/* release the busid_lock */
 	put_busid_priv(busid_priv);
 
+sdev_free:
+	stub_device_free(sdev);
+
 	return rc;
 }
 
@@ -449,7 +458,9 @@ static void stub_disconnect(struct usb_d
 	/* get stub_device */
 	if (!sdev) {
 		dev_err(&udev->dev, "could not get device");
-		goto call_put_busid_priv;
+		/* release busid_lock */
+		put_busid_priv(busid_priv);
+		return;
 	}
 
 	dev_set_drvdata(&udev->dev, NULL);
@@ -479,7 +490,7 @@ static void stub_disconnect(struct usb_d
 	if (!busid_priv->shutdown_busid)
 		busid_priv->shutdown_busid = 1;
 	/* release busid_lock */
-	put_busid_priv(busid_priv);
+	spin_unlock(&busid_priv->busid_lock);
 
 	/* shutdown the current connection */
 	shutdown_busid(busid_priv);
@@ -494,10 +505,9 @@ static void stub_disconnect(struct usb_d
 
 	if (busid_priv->status == STUB_BUSID_ALLOC)
 		busid_priv->status = STUB_BUSID_ADDED;
-
-call_put_busid_priv:
 	/* release busid_lock */
-	put_busid_priv(busid_priv);
+	spin_unlock(&busid_priv->busid_lock);
+	return;
 }
 
 #ifdef CONFIG_PM


