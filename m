Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA25538FC5
	for <lists+stable@lfdr.de>; Fri,  7 Jun 2019 17:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731154AbfFGPpH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jun 2019 11:45:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:56830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729992AbfFGPpG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Jun 2019 11:45:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83B0121479;
        Fri,  7 Jun 2019 15:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559922305;
        bh=HrNGaz2LLONuXWjzVTdf+cNnrNJ+P+bIS1tgahF+ueM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QKhp884jd4EuGcRmIisp/hsynYRehJF7gfVBm6COXxaN6DIxKYeL+p/COlMpydRCm
         RvH1jt2q73d3MsOjA4inJ0AmqQpAcm7O6BgIN3+ndkahTK18GOWVwSYTM9WEB4D7Hk
         EvNKBDriiLgrQX6m7EuCuU44qAL2jC56tppVtRl8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4.19 07/73] usbip: usbip_host: fix BUG: sleeping function called from invalid context
Date:   Fri,  7 Jun 2019 17:38:54 +0200
Message-Id: <20190607153849.578210937@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190607153848.669070800@linuxfoundation.org>
References: <20190607153848.669070800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 0c9e8b3cad654bfc499c10b652fbf8f0b890af8f upstream.

stub_probe() and stub_disconnect() call functions which could call
sleeping function in invalid context whil holding busid_lock.

Fix the problem by refining the lock holds to short critical sections
to change the busid_priv fields. This fix restructures the code to
limit the lock holds in stub_probe() and stub_disconnect().

stub_probe():

[15217.927028] BUG: sleeping function called from invalid context at mm/slab.h:418
[15217.927038] in_atomic(): 1, irqs_disabled(): 0, pid: 29087, name: usbip
[15217.927044] 5 locks held by usbip/29087:
[15217.927047]  #0: 0000000091647f28 (sb_writers#6){....}, at: vfs_write+0x191/0x1c0
[15217.927062]  #1: 000000008f9ba75b (&of->mutex){....}, at: kernfs_fop_write+0xf7/0x1b0
[15217.927072]  #2: 00000000872e5b4b (&dev->mutex){....}, at: __device_driver_lock+0x3b/0x50
[15217.927082]  #3: 00000000e74ececc (&dev->mutex){....}, at: __device_driver_lock+0x46/0x50
[15217.927090]  #4: 00000000b20abbe0 (&(&busid_table[i].busid_lock)->rlock){....}, at: get_busid_priv+0x48/0x60 [usbip_host]
[15217.927103] CPU: 3 PID: 29087 Comm: usbip Tainted: G        W         5.1.0-rc6+ #40
[15217.927106] Hardware name: Dell Inc. OptiPlex 790/0HY9JP, BIOS A18 09/24/2013
[15217.927109] Call Trace:
[15217.927118]  dump_stack+0x63/0x85
[15217.927127]  ___might_sleep+0xff/0x120
[15217.927133]  __might_sleep+0x4a/0x80
[15217.927143]  kmem_cache_alloc_trace+0x1aa/0x210
[15217.927156]  stub_probe+0xe8/0x440 [usbip_host]
[15217.927171]  usb_probe_device+0x34/0x70

stub_disconnect():

[15279.182478] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:908
[15279.182487] in_atomic(): 1, irqs_disabled(): 0, pid: 29114, name: usbip
[15279.182492] 5 locks held by usbip/29114:
[15279.182494]  #0: 0000000091647f28 (sb_writers#6){....}, at: vfs_write+0x191/0x1c0
[15279.182506]  #1: 00000000702cf0f3 (&of->mutex){....}, at: kernfs_fop_write+0xf7/0x1b0
[15279.182514]  #2: 00000000872e5b4b (&dev->mutex){....}, at: __device_driver_lock+0x3b/0x50
[15279.182522]  #3: 00000000e74ececc (&dev->mutex){....}, at: __device_driver_lock+0x46/0x50
[15279.182529]  #4: 00000000b20abbe0 (&(&busid_table[i].busid_lock)->rlock){....}, at: get_busid_priv+0x48/0x60 [usbip_host]
[15279.182541] CPU: 0 PID: 29114 Comm: usbip Tainted: G        W         5.1.0-rc6+ #40
[15279.182543] Hardware name: Dell Inc. OptiPlex 790/0HY9JP, BIOS A18 09/24/2013
[15279.182546] Call Trace:
[15279.182554]  dump_stack+0x63/0x85
[15279.182561]  ___might_sleep+0xff/0x120
[15279.182566]  __might_sleep+0x4a/0x80
[15279.182574]  __mutex_lock+0x55/0x950
[15279.182582]  ? get_busid_priv+0x48/0x60 [usbip_host]
[15279.182587]  ? reacquire_held_locks+0xec/0x1a0
[15279.182591]  ? get_busid_priv+0x48/0x60 [usbip_host]
[15279.182597]  ? find_held_lock+0x94/0xa0
[15279.182609]  mutex_lock_nested+0x1b/0x20
[15279.182614]  ? mutex_lock_nested+0x1b/0x20
[15279.182618]  kernfs_remove_by_name_ns+0x2a/0x90
[15279.182625]  sysfs_remove_file_ns+0x15/0x20
[15279.182629]  device_remove_file+0x19/0x20
[15279.182634]  stub_disconnect+0x6d/0x180 [usbip_host]
[15279.182643]  usb_unbind_device+0x27/0x60

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/usbip/stub_dev.c |   65 ++++++++++++++++++++++++++++---------------
 1 file changed, 43 insertions(+), 22 deletions(-)

--- a/drivers/usb/usbip/stub_dev.c
+++ b/drivers/usb/usbip/stub_dev.c
@@ -301,9 +301,17 @@ static int stub_probe(struct usb_device
 	const char *udev_busid = dev_name(&udev->dev);
 	struct bus_id_priv *busid_priv;
 	int rc = 0;
+	char save_status;
 
 	dev_dbg(&udev->dev, "Enter probe\n");
 
+	/* Not sure if this is our device. Allocate here to avoid
+	 * calling alloc while holding busid_table lock.
+	 */
+	sdev = stub_device_alloc(udev);
+	if (!sdev)
+		return -ENOMEM;
+
 	/* check we should claim or not by busid_table */
 	busid_priv = get_busid_priv(udev_busid);
 	if (!busid_priv || (busid_priv->status == STUB_BUSID_REMOV) ||
@@ -318,14 +326,14 @@ static int stub_probe(struct usb_device
 		 * See driver_probe_device() in driver/base/dd.c
 		 */
 		rc = -ENODEV;
-		goto call_put_busid_priv;
+		goto sdev_free;
 	}
 
 	if (udev->descriptor.bDeviceClass == USB_CLASS_HUB) {
 		dev_dbg(&udev->dev, "%s is a usb hub device... skip!\n",
 			 udev_busid);
 		rc = -ENODEV;
-		goto call_put_busid_priv;
+		goto sdev_free;
 	}
 
 	if (!strcmp(udev->bus->bus_name, "vhci_hcd")) {
@@ -334,15 +342,9 @@ static int stub_probe(struct usb_device
 			udev_busid);
 
 		rc = -ENODEV;
-		goto call_put_busid_priv;
+		goto sdev_free;
 	}
 
-	/* ok, this is my device */
-	sdev = stub_device_alloc(udev);
-	if (!sdev) {
-		rc = -ENOMEM;
-		goto call_put_busid_priv;
-	}
 
 	dev_info(&udev->dev,
 		"usbip-host: register new device (bus %u dev %u)\n",
@@ -352,9 +354,13 @@ static int stub_probe(struct usb_device
 
 	/* set private data to usb_device */
 	dev_set_drvdata(&udev->dev, sdev);
+
 	busid_priv->sdev = sdev;
 	busid_priv->udev = udev;
 
+	save_status = busid_priv->status;
+	busid_priv->status = STUB_BUSID_ALLOC;
+
 	/*
 	 * Claim this hub port.
 	 * It doesn't matter what value we pass as owner
@@ -367,15 +373,16 @@ static int stub_probe(struct usb_device
 		goto err_port;
 	}
 
+	/* release the busid_lock */
+	put_busid_priv(busid_priv);
+
 	rc = stub_add_files(&udev->dev);
 	if (rc) {
 		dev_err(&udev->dev, "stub_add_files for %s\n", udev_busid);
 		goto err_files;
 	}
-	busid_priv->status = STUB_BUSID_ALLOC;
 
-	rc = 0;
-	goto call_put_busid_priv;
+	return 0;
 
 err_files:
 	usb_hub_release_port(udev->parent, udev->portnum,
@@ -384,23 +391,24 @@ err_port:
 	dev_set_drvdata(&udev->dev, NULL);
 	usb_put_dev(udev);
 
+	/* we already have busid_priv, just lock busid_lock */
+	spin_lock(&busid_priv->busid_lock);
 	busid_priv->sdev = NULL;
+	busid_priv->status = save_status;
+sdev_free:
 	stub_device_free(sdev);
-
-call_put_busid_priv:
+	/* release the busid_lock */
 	put_busid_priv(busid_priv);
+
 	return rc;
 }
 
 static void shutdown_busid(struct bus_id_priv *busid_priv)
 {
-	if (busid_priv->sdev && !busid_priv->shutdown_busid) {
-		busid_priv->shutdown_busid = 1;
-		usbip_event_add(&busid_priv->sdev->ud, SDEV_EVENT_REMOVED);
+	usbip_event_add(&busid_priv->sdev->ud, SDEV_EVENT_REMOVED);
 
-		/* wait for the stop of the event handler */
-		usbip_stop_eh(&busid_priv->sdev->ud);
-	}
+	/* wait for the stop of the event handler */
+	usbip_stop_eh(&busid_priv->sdev->ud);
 }
 
 /*
@@ -432,6 +440,9 @@ static void stub_disconnect(struct usb_d
 
 	dev_set_drvdata(&udev->dev, NULL);
 
+	/* release busid_lock before call to remove device files */
+	put_busid_priv(busid_priv);
+
 	/*
 	 * NOTE: rx/tx threads are invoked for each usb_device.
 	 */
@@ -442,18 +453,27 @@ static void stub_disconnect(struct usb_d
 				  (struct usb_dev_state *) udev);
 	if (rc) {
 		dev_dbg(&udev->dev, "unable to release port\n");
-		goto call_put_busid_priv;
+		return;
 	}
 
 	/* If usb reset is called from event handler */
 	if (usbip_in_eh(current))
-		goto call_put_busid_priv;
+		return;
+
+	/* we already have busid_priv, just lock busid_lock */
+	spin_lock(&busid_priv->busid_lock);
+	if (!busid_priv->shutdown_busid)
+		busid_priv->shutdown_busid = 1;
+	/* release busid_lock */
+	put_busid_priv(busid_priv);
 
 	/* shutdown the current connection */
 	shutdown_busid(busid_priv);
 
 	usb_put_dev(sdev->udev);
 
+	/* we already have busid_priv, just lock busid_lock */
+	spin_lock(&busid_priv->busid_lock);
 	/* free sdev */
 	busid_priv->sdev = NULL;
 	stub_device_free(sdev);
@@ -462,6 +482,7 @@ static void stub_disconnect(struct usb_d
 		busid_priv->status = STUB_BUSID_ADDED;
 
 call_put_busid_priv:
+	/* release busid_lock */
 	put_busid_priv(busid_priv);
 }
 


